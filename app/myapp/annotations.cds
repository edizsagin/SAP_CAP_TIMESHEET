using TimesheetService as service from '../../srv/service';

annotate service.Activities with @(
    UI.HeaderInfo                             : {
        TypeName      : 'Activity',
        TypeNamePlural: 'Activities',
        TypeImageUrl  : 'sap-icon://create-entry-time',
        Title         : {
            $Type: 'UI.DataField',
            Value: ActNo
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: status.name
        }
    },

    UI.FieldGroup #GeneratedGroup             : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Act.No',
                Value: ActNo,
            },
            {
                $Type : 'UI.DataField',
                Value : pers_ID,
                Label : 'Employee',
            },
            {
                $Type: 'UI.DataField',
                Label: 'Company',
                Value: company_companyCode,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Total Hours',
                Value: hours,
            },
            {

                $Type: 'UI.DataField',
                Label: 'Description',
                Value: description,
            },
            {
                @UI.Hidden: {$edmJson: {$Ne: [
                    {$Path: 'status_code'},
                    'R'
                ]}},
                $Type     : 'UI.DataField',
                Label     : 'Rejection Comment',
                Value     : rejectionComment,
            },
            {
                $Type : 'UI.DataField',
                Value : Module_ID,
                Label : 'Module',
            },
        ],
    },
    UI.Facets                                 : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'Activity Details',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Work Time',
            ID    : 'Time',
            Target: '@UI.FieldGroup#Time',
        },
    ],
    UI.LineItem                               : [
        {
            $Type: 'UI.DataField',
            Label: 'Act.No',
            Value: ActNo,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Employee',
            Value: pers_ID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Company',
            Value: company_companyCode,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Work Date',
            Value: workDate,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Time From',
            Value: timeFrom,
        },
        {
            $Type: 'UI.DataField',
            Value: timeTo,
            Label: 'Time To',
        },
        {
            $Type: 'UI.DataField',
            Value: hoursText,
            Label: 'Total Hours',
        },
        {
            $Type: 'UI.DataField',
            Value: hours,
            Label: 'Total Hours',
        },
        {
            $Type: 'UI.DataField',
            Value: createdBy,
        },
        {
            $Type: 'UI.DataField',
            Value: createdAt,
        },
        {
            $Type                    : 'UI.DataField',
            Value                    : status_code,
            Label                    : 'Status',
            Criticality              : status.criticality,
            CriticalityRepresentation: #WithoutIcon,
        },
    ],
    UI.SelectionPresentationVariant #tableView: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [],
        },
        Text               : 'Activities',
    },
    UI.DataPoint #createdBy                   : {
        $Type: 'UI.DataPointType',
        Value: createdBy,
        Title: 'Created By',
    },
    UI.DataPoint #createdAt                   : {
        $Type: 'UI.DataPointType',
        Value: createdAt,
        Title: 'Created At',
    },
    UI.HeaderFacets                           : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'createdBy',
            Target: '@UI.DataPoint#createdBy',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'createdAt',
            Target: '@UI.DataPoint#createdAt',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'status_code',
            Target: '@UI.DataPoint#status_code',
        },
    ],
    UI.LineItem.@UI.Criticality               : status.criticality,
    UI.FieldGroup #Time                       : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: timeFrom,
                Label: 'Time From',
            },
            {
                $Type: 'UI.DataField',
                Value: timeTo,
                Label: 'Time To',
            },
            {
                $Type: 'UI.DataField',
                Value: hoursText,
                Label: 'Total Hours',
            },
            {
                $Type: 'UI.DataField',
                Value: workDate,
                Label: 'Work Date',
            },
        ],
    },
    UI.DataPoint #status_code                 : {
        $Type      : 'UI.DataPointType',
        Value      : status_code,
        Title      : 'Status',
        Criticality: status.criticality,
    },

    UI.SelectionFields                        : [
        ActNo,
        pers_ID,
        status_code,
        workDate,
        company_companyCode,
    ],

);

annotate service.Activities with @Capabilities: {FilterRestrictions: {
    $Type                       : 'Capabilities.FilterRestrictionsType',
    FilterExpressionRestrictions: [{
        $Type             : 'Capabilities.FilterExpressionRestrictionType',
        Property          : workDate,
        AllowedExpressions: 'SingleRange'
    }]
}};


annotate service.Activities with {
    description      @UI.MultiLineText;
    rejectionComment @UI.MultiLineText;

};

annotate service.ApproverWorkList with {
    description      @UI.MultiLineText;
    // rejectionComment @UI.MultiLineText;
};

annotate service.Activities @(Common.SideEffects #RecalcHours: {
    SourceProperties: [
        'timeFrom',
        'timeTo'
    ],
    TargetProperties: [
        'hours',
        'hoursText'
    ]
});

annotate service.Activities with {
    company @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'CompaniesVH',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: company_companyCode,
                ValueListProperty: 'companyCode',
            }, ],
        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : company.companyName,
        Common.Label                   : 'Company',
        Common.Text.@UI.TextArrangement : #TextOnly,
    )
};

annotate service.EmployeesDetail with {
    ID @(
        Common.Text                    : fullName,
        Common.Text.@UI.TextArrangement: #TextFirst,
    )
};

annotate service.CompaniesVH with {
    companyCode @(
        Common.Text                    : companyName,
        Common.Text.@UI.TextArrangement: #TextFirst,
    )
};

annotate service.Activities with {
    status @(
        UI.MultiLineText               : true,
        Common.Text                    : status.name,
        Common.Label                   : 'Status',
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'ActivityStatus',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: status_code,
                ValueListProperty: 'code',
            }, ],
            Label         : 'Status',
        },
        Common.ValueListWithFixedValues: true,
    )
};

annotate service.ActivityStatus with {
    code @(
        Common.Text                    : name,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};


annotate service.ApproverWorkList with @(

    UI.LineItem #tableView                    : [
        {
            $Type: 'UI.DataField',
            Value: DisplayActNo,
            Label: 'Act.No',
        },
        {
            $Type: 'UI.DataField',
            Value: pers_ID,
            Label: 'Employee',
        },
        {
            $Type: 'UI.DataField',
            Value: company_companyCode,
            Label: 'Company',
        },
        {
            $Type: 'UI.DataField',
            Value: workDate,
            Label: 'Work Date',
        },
        {
            $Type: 'UI.DataField',
            Value: timeFrom,
            Label: 'Time From',
        },
        {
            $Type: 'UI.DataField',
            Value: timeTo,
            Label: 'Time To',
        },
        {
            $Type: 'UI.DataField',
            Value: hoursText,
            Label: 'Total Hours',
        },
        {
            $Type                    : 'UI.DataField',
            Value                    : status_code,
            Label                    : 'Status',
            Criticality              : status.criticality,
            CriticalityRepresentation: #WithoutIcon,
        },
        {
            $Type: 'UI.DataField',
            Value: createdAt,
        },
        {
            $Type: 'UI.DataField',
            Value: createdBy,
        },
        {
            $Type: 'UI.DataField',
            Value: hours,
            Label: 'hours',
        },
        {
            $Type         : 'UI.DataField',
            Value         : ActNo,
            Label         : 'Remarks',
            @UI.Importance: #High,
        },
        {
            $Type         : 'UI.DataFieldForAction',
            Action        : 'TimesheetService.Approve',
            Label         : 'Approve',
            Inline        : true,
            IconUrl       : 'sap-icon://accept',
            Criticality   : #Positive,
            @UI.Importance: #High,
        },
        {
            $Type         : 'UI.DataFieldForAction',
            Action        : 'TimesheetService.Reject',
            Label         : 'Reject',
            Inline        : true,
            IconUrl       : 'sap-icon://decline',
            Criticality   : #Negative,
            @UI.Importance: #High,
        },

    ],
    UI.SelectionPresentationVariant #tableView: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [],
        },
        Text               : 'Approver Page',
    },
    UI.SelectionPresentationVariant #Pending  : {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#Pending',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: status_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'P',
                }, ],
            }, ],
        },
        Text               : '🟨 Pending',
    },
    UI.SelectionPresentationVariant #Approved : {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#Approved',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: status_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'A',
                }, ],
            }, ],
        },
        Text               : '🟩 Approved',
    },
    UI.SelectionPresentationVariant #Rejected : {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#Rejected',
            ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: status_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'R',
                }, ],
            }, ],
        },
        Text               : '🟥 Rejected',
    },

);

annotate service.ApproverWorkList with {
    status @(
        Common.Text                    : status.name,
        Common.Label                   : 'StatusOptions',
        Common.Text.@UI.TextArrangement: #TextFirst,
    )
};

annotate service.ApproverWorkList with {
    company @(
        Common.Text: company.companyName,
        Common.Text.@UI.TextArrangement : #TextOnly,
    )
};

annotate service.ApproverWorkList with {
    pers @Common.Text: pers.fullName
};

annotate service.Activities with {
    ActNo @(
        Common.Label                   : 'Act.No',
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Activities',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: ActNo,
                ValueListProperty: 'ActNo',
            }, ],
            Label         : 'Act.No',
        },
        Common.ValueListWithFixedValues: true,
    )
};

annotate service.Activities with {
    workDate @(Common.Label: 'Work Date',
    )
};

annotate service.Activities with {
    timeFrom @Common.Label: 'Time From'
};

annotate service.Activities with {
    timeTo @Common.Label: 'Time To'
};

annotate service.ApproverWorkList with @UI.SelectionPresentationVariant: {
    $Type              : 'UI.SelectionPresentationVariantType',
    Text               : 'Pending',
    SelectionVariant   : {
        $Type        : 'UI.SelectionVariantType',
        SelectOptions: [{
            $Type       : 'UI.SelectOptionType',
            PropertyName: status_code,
            Ranges      : [{
                $Type : 'UI.SelectionRangeType',
                Sign  : #I,
                Option: #EQ,
                Low   : 'P',
            }, ],
        }, ],

    },
    PresentationVariant: {
        $Type         : 'UI.PresentationVariantType',
        Visualizations: ['@UI.LineItem#tableView'],
        SortOrder     : [{
            Property  : createdAt,
            Descending: true
        }]

    },
};

annotate service.EmployeesDetail with @(
    UI.HeaderInfo                   : {
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
        Title         : {Value: fullName},
        Description   : {Value: position},
        TypeImageUrl  : 'sap-icon://employee'
    },

    UI.QuickViewFacets              : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Details',
        Target: '@UI.FieldGroup#EmployeeQuickView'
    }],

    UI.FieldGroup #EmployeeQuickView: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Employee ID',
                Value: ID
            },
            {
                $Type: 'UI.DataField',
                Label: 'Email',
                Value: email
            },
            {
                $Type: 'UI.DataField',
                Label: 'Phone',
                Value: phone
            },
            {
                $Type: 'UI.DataField',
                Label: 'City',
                Value: city
            },
            {
                $Type: 'UI.DataField',
                Label: 'Country',
                Value: country
            },
            {
                $Type: 'UI.DataField',
                Label: 'Address',
                Value: address
            },
            {
                $Type: 'UI.DataField',
                Label: 'Manager',
                Value: manager
            },
            {
                $Type: 'UI.DataField',
                Label: 'Position',
                Value: position
            },
            {
                $Type: 'UI.DataField',
                Label: 'Level',
                Value: level
            },
            {
                $Type: 'UI.DataField',
                Label: 'Active',
                Value: isActive
            }
        ]
    }
);

annotate service.DescriptionQV with @(

    UI.HeaderInfo     : {
        TypeName      : 'Description',
        TypeNamePlural: 'Descriptions',
        TypeImageUrl  : 'sap-icon://employee'
    },

    UI.QuickViewFacets: [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Remarks',
        Target: '@UI.FieldGroup#QV'
    }],

    UI.FieldGroup #QV : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Activity Description',
                Value: description
            },
            {
                $Type: 'UI.DataField',
                Label: 'Rejection Comment',
                Value: rejectionComment
            }
        ]
    }
);

annotate service.ApproverWorkList with {
    ActNo @(
        Common.Text                    : openText,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};



annotate service.inText:comment with @Common.Label : 'Reason for rejection';
annotate service.inText:comment with @(
UI.Placeholder : 'Text Area',
) ;
annotate service.inText:comment with @Common.FieldControl : #Mandatory;
annotate service.inText:comment with @UI.MultiLineText: true;


annotate service.Activities with {
    Module @(
        Common.Text : Module.name,
        Common.Text.@UI.TextArrangement : #TextOnly,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Modules',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : Module_ID,
                    ValueListProperty : 'ID',
                },
            ],
            Label : 'Module',
        },
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.Modules with {
    ID @(
        Common.Text : name,
        Common.Text.@UI.TextArrangement : #TextOnly,
)};

annotate service.Activities with {
    pers @(
        Common.Text : pers.fullName,
        Common.Text.@UI.TextArrangement : #TextOnly,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'EmployeesDetail',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : pers_ID,
                    ValueListProperty : 'ID',
                },
            ],
            Label : 'Employee',
        },
        Common.ValueListWithFixedValues : true,
        Common.Label : 'Employee',
    )
};

