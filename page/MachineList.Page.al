page 56001 "FLT Machine List"
{
    Caption = 'Machine List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    DeleteAllowed = false;
    SourceTable = "FLT Machine";
    
    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("Linked to Item No."; Rec."Linked to Item No.") { }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ItemCard)
            {
                ApplicationArea = All;
                Caption = 'Open Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Linked to Item No.");
            }
        }
    }
}