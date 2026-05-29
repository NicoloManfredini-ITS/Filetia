page 56000 "FLT Machine Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "FLT Machine";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec."Code") { }
                field(Description; Rec.Description) { }
                field("Linked to Item No."; Rec."Linked to Item No.") { }
            }
            group(Maintenance)
            {
                Caption = 'Maintenance';
                field("Lifecycle Quantity";Rec."Lifecycle Quantity") { }
                field("Maintenance Cycle: Quantity"; Rec."Maintenance Cycle: Quantity") { }
                field("Maintenance Cycle: Time"; Rec."Maintenance Cycle: Time") { }
            }
            group(Production)
            {
                Caption = 'Production';
                field("Unit Time for Part"; Rec."Unit Time for Part") { }
                field(TotalTimeWorked; CalcTotalTimeWorked())
                {
                    Caption = 'Total Time Worked (hrs)';
                    Editable = false;
                }
                field("Total Parts Produced"; Rec."Total Parts Produced") { }
                field("Scrap Rate"; Rec."Scrap Rate") { }
                field(ScrapedParts; CalcScrapedParts())
                {
                    Caption = 'Scraped Parts';
                    Editable = false;
                }
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

    local procedure CalcTotalTimeWorked(): Decimal
    begin
        Rec.CalcFields("Total Parts Produced");
        exit(Rec."Total Parts Produced" * Rec."Unit Time for Part" / 3600000);
    end;

    local procedure CalcScrapedParts(): Integer
    begin
        Rec.CalcFields("Total Parts Produced");
        exit(Round(Rec."Total Parts Produced" * Rec."Scrap Rate" / 100, 1));
    end;

}