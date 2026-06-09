table 56001 "FLT Maintenance Machine"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Machine Code"; Code[20])
        {
            Caption = 'Machine Code';
            TableRelation = "FLT Machine".Code;
            Editable = false;
        }
        field(2; "Maint. Time Work"; Integer)
        {
            Caption = 'Maint. Time Work';
        }
        field(3; "Maint. Time Last Date"; Date)
        {
            Caption = 'Maint. Time Last Date';
        }
        field(4; "Maint. Time Counter"; Integer)
        {
            Caption = 'Maint. Time Counter';
        }
        field(5; "Maint. Parts Q.ty"; Integer)
        {
            Caption = 'Maint. Parts Q.ty';
        }
        field(6; "Maint. Parts Last Date"; Date)
        {
            Caption = 'Maint. Parts Last Date';
        }
        field(7; "Maint. Parts Counter"; Integer)
        {
            Caption = 'Maint. Parts Counter';
        }
        field(8; "Lifecycle End Status"; Enum "FLT Lifecycle End Status")
        {
            Caption = 'Lifecycle End Status';
        }
        field(9; "Lifecycle End Date"; Date)
        {
            Caption = 'Lifecycle End Date';
            Editable = false;
        }
    }
    
    keys
    {
        key(PK; "Machine Code")
        {
            Clustered = true;
        }
    }    
}