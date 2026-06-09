table 56002 "FLT Maintenance Activity"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Machine Code"; Code[20])
        {
            Caption = 'Machine Code';
            TableRelation = "FLT Machine".Code;
        }
        field(2; "Activity Code"; Code[20])
        {
            Caption = 'Activity Code';
        }
        field(3; "Maintenance Type"; Option)
        {
            Caption = 'Maintenance Type';
            OptionMembers = Time,Parts;
            OptionCaption = 'Time,Parts';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    
    keys
    {
        key(PK; "Machine Code", "Activity Code")
        {
            Clustered = true;
        }
    }
    
}