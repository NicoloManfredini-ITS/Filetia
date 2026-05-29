tableextension 56000 FLTT56000 extends Item
{
    fields
    {
        field(56000; "FLT Machine Code"; Code[20])
        {
            Caption = 'Machine Code';
            TableRelation = "FLT Machine".Code;

            trigger OnValidate()
            var
                CustomMgt: Codeunit "FLT Custom Mgt.";
            begin
                CustomMgt.LinkItemToMachine(Rec."No.", Rec."FLT Machine Code", xRec."FLT Machine Code");
            end;
        }
    }
}