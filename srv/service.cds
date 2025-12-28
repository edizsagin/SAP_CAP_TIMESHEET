using timesheet as db from '../db/schema';


service TimesheetService @(requires: 'authenticated-user') {
  function me() returns {
    isManager : Boolean;
  };

  @odata.draft.enabled

  entity Activities       as projection on db.Activities;

  @(requires: 'Manager')
  entity DescriptionQV    as projection on db.DescriptionQV;

  entity CompaniesVH      as
    projection on db.Companies {
      companyCode,
      companyName
    }

  entity ActivityStatus   as projection on db.ActivityStatus;
  entity Modules          as projection on db.Modules;
  entity EmployeesDetail  as projection on db.Employees;

  type inText : {
    comment : String;
  };

      @(requires: 'Manager')
  entity ApproverWorkList as projection on db.ApproverWorkList
    actions {

      @Common.SideEffects     : {TargetEntities: ['']}
      @Core.OperationAvailable: {$edmJson: {$Ne: [
        {$Path: 'in/status_code'},
        'A'
      ]}}
      action Approve()                    returns Activities;

      @Common.SideEffects     : {TargetEntities: ['']}
      @Core.OperationAvailable: {$edmJson: {$Ne: [
        {$Path: 'in/status_code'},
        'A'
      ]}}
      action Reject(text: inText:comment) returns ApproverWorkList;

    };

}
