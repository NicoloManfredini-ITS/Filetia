tableextension 56001 FLTT56001 extends "Sales & Receivables Setup"
{
    fields
    {
        field(56000; "FLT Machine Nos."; Code[20])
        {
            Caption = 'Machine Nos.';
            TableRelation = "No. Series".Code;
        }
    }
}