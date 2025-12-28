const cds = require("@sap/cds");
const { UPDATE } = require("@sap/cds/lib/ql/cds-ql");
// const { and } = require("three/tsl");


module.exports = class TimesheetService extends cds.ApplicationService {
  async init() {
    const { Activities, ApproverWorkList } = cds.entities("TimesheetService");

    this.before("READ", async (req) => {
      console.log("--- REQUEST ---", req);
      console.log("Event :", req.event);
      console.log("Path  :", req.path);
      console.log("User  :", req.user?.id);
      console.log("➡️ User roles   :", req.user?.roles);
      console.log("➡️ Is Manager? :", req.user?.is?.("Manager"));
    
    });

    const calcDiffMinutes = (from, to) => {
      if (!from || !to) return null;

      const [fh, fm] = String(from).split(":").map(Number);
      const [th, tm] = String(to).split(":").map(Number);

      const fromMin = fh * 60 + fm;
      const toMin = th * 60 + tm;

      let diffMin = toMin - fromMin;
      if (diffMin < 0) diffMin += 24 * 60;

      return diffMin;
    };

    const toDecimalHours = (mins) => Math.round((mins / 60) * 100) / 100;

    const toHoursText = (mins) => {
      const h = Math.floor(mins / 60);
      const m = mins % 60;
      return `${h}h ${m}m`;
    };

    this.on("me", async (req) => ({
      isManager: req.user.is("Manager"),
    }));
    this.before(["CREATE", "UPDATE"], ApproverWorkList, async (req) => {});

    this.before(["CREATE", "UPDATE"], Activities, async (req) => {
      req.data.status_code = "P";
    });

 

    this.on(["Approve"], ApproverWorkList, async (req) => {
      const keys = req.params[0];
      console.log("Event :", keys);

      await UPDATE(Activities).set({ status_code: "A" }).where(keys);

      req.info(200, `Activity ${keys.ID} sent successfully`);
      return await cds.read(Activities).where(keys);
    });

    this.on(["Reject"], ApproverWorkList, async (req) => {
      const keys = req.params[0];
      const { text } = req.data;
      console.log("Event :", keys);
      await UPDATE(Activities)
        .set({ status_code: "R", rejectionComment: text })
        .where(keys);

      req.info(200, `Activity ${keys.ID} rejected successfully`);

      return await cds.read(ApproverWorkList).where(keys);
    });

    this.before(["CREATE", "UPDATE"], Activities.drafts, async (req) => {
      let { timeFrom, timeTo } = req.data;

      const ID = req.params?.[0]?.ID || req.data.ID;

      if (ID && (!timeFrom || !timeTo)) {
        const current = await cds
          .tx(req)
          .run(
            SELECT.one
              .from(Activities.drafts)
              .columns("timeFrom", "timeTo")
              .where({ ID })
          );
        timeFrom ??= current?.timeFrom;
        timeTo ??= current?.timeTo;
      }

      const mins = calcDiffMinutes(timeFrom, timeTo);
      if (mins == null) return;

      req.data.hours = toDecimalHours(mins); // 1.73
      req.data.hoursText = toHoursText(mins); // "1h 44m"

      let {} = req.data;
    });

    return super.init();
  }
};
