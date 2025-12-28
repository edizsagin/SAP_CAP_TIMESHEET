using {
    managed,
    cuid
} from '@sap/cds/common';

namespace timesheet;

@Capabilities.SearchRestrictions: {
    $Type     : 'Capabilities.SearchRestrictionsType',
    Searchable: false
}
entity Activities : cuid, managed {
    ActNo            : String(10)    @readonly;
    pers             : Association to one Employees;
    company          : Association to one Companies;
    workDate         : Date default $now;
    timeFrom         : Time;
    timeTo           : Time;
    hours            : Decimal(5, 2) @UI.Hidden;
    hoursText        : String        @readonly;
    description      : String(500);
    Module           : Association to one Modules;

    @readonly
    status           : Association to ActivityStatus default 'I';

    @readonly
    rejectionComment : String(500);
}

annotate Activities with {
    ActNo @plugin.numberrange.rangeid: 'ACT_RANGE';
};

entity Modules {
    key ID   : String(10);
        name : String(80);
}

entity ActivityStatus {
    key code        : ActivityStatusCode;
        criticality : Integer;
        name        : String(30);
}


entity Employees : managed {
    key ID       : Integer;
        fullName : String(120);
        isActive : Boolean default true;
        email    : String(120);
        phone    : String(30);
        address  : String(250);
        city     : String(60);
        country  : String(60);
        manager  : String(60);
        position : String(80);
        level    : EmployeeLevel;
}

entity Companies : managed {
    key companyCode : Integer;
        companyName : String(120);
        isActive    : Boolean default true;
}

entity DescriptionQV    as
    select from Activities {
        key ActNo,
            description,
            rejectionComment,
    }

entity ApproverWorkList as
    select from Activities {
        *,
        ActNo          as DisplayActNo,
        'Show Remarks' as openText : String,
        qv                         : Association to one DescriptionQV
                                         on qv.ActNo = ActNo

    }


type ActivityStatusCode : String(1) enum {
    Initial = 'I';
    Pending = 'P';
    Approved = 'A';
    Rejected = 'R';
};


type EmployeeLevel      : String(15) enum {
    Junior = 'Junior';
    Mid = 'Mid';
    Senior = 'Senior';
    Lead = 'Lead';
};
