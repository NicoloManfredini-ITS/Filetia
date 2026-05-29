table 56000 "FLT Machine"
{
    DataClassification = CustomerContent;
    LookupPageId = "FLT Machine List";
    DrillDownPageId = "FLT Machine List";
    
    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            Editable = false;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Unit Time for Part"; Decimal)
        {
            Caption = 'Unit Time for Part';
        }
        field(4; "Scrap Rate"; Integer)
        {
            Caption = 'Scrap Rate';

            trigger OnValidate()
            var
                NotNegativeErr: Label 'Scrap Rate cannot be negative.';
                NotGreaterThanHundredErr: Label 'Scrap Rate cannot be greater than 100%.';
            begin
                if (Rec."Scrap Rate" < 0) then
                    Error(NotNegativeErr);
                if (Rec."Scrap Rate" > 100) then
                    Error(NotGreaterThanHundredErr);
            end;
        }
        field(10; "Total Parts Produced"; Integer)
        {
            Caption = 'Total Parts Produced';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line"."Quantity" where (Type = CONST(Item), "No." = field("Linked to Item No.")));
        }
        field(20; "Lifecycle Quantity"; Integer)
        {
            Caption = 'Lifecycle Quantity';
        }
        field(21; "Maintenance Cycle: Quantity"; Integer)
        {
            Caption = 'Maintenance Cycle: Quantity';
        }
        field(22; "Maintenance Cycle: Time"; Integer)
        {
            Caption = 'Maintenance Cycle: Time';
        }
        field(100; "Linked to Item No."; Code[20])
        {
            Caption = 'Linked to Item No.';
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                CustomMgt: Codeunit "FLT Custom Mgt.";
            begin
                CustomMgt.LinkMachineToItem(Rec.Code, Rec."Linked to Item No.", xRec."Linked to Item No.");
            end;
        }
    }
    
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }    

    trigger OnInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        SalesSetup.Get();
        SalesSetup.TestField("FLT Machine Nos.");
        Code := NoSeriesMgt.GetNextNo(SalesSetup."FLT Machine Nos.");
    end;
}