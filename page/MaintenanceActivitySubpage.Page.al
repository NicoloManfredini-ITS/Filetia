page 56003 "FLT Maint. Activity Subpage"
{
    Caption = 'Maintenance Activity Subpage';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "FLT Maintenance Activity";
    
    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Activity Code"; Rec."Activity Code") { }
                field("Maintenance Type"; Rec."Maintenance Type") { }
                field(Description; Rec.Description) { }
            }
        }
    }
}