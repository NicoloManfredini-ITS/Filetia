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
        field(10; "Total Parts Produced"; Decimal)
        {
            Caption = 'Total Parts Produced';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line"."Quantity" where(Type = CONST(Item), "No." = field("Linked to Item No."), "Posting Date" = field("Lifecycle End Date Filter")));
        }
        field(11; "Total Parts Prod. (Restored)"; Decimal)
        {
            Caption = 'Total Parts Produced (Restored)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line"."Quantity" where(Type = CONST(Item), "No." = field("Linked to Item No."), "Posting Date" = field("Lifec. End Date (Rest.) Filter")));
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
        field(200; "Current Lifecycle End Status"; Enum "FLT Lifecycle End Status")
        {
            Caption = 'Lifecycle End Status';
        }
        field(201; "Lifecycle End Date Filter"; Date)
        {
            Caption = 'Lifecycle End Date';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(202; "Lifec. End Date (Rest.) Filter"; Date)
        {
            Caption = 'Lifecycle End Date (Restored)';
            Editable = false;
            FieldClass = FlowFilter;
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