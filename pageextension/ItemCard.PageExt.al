pageextension 56000 FLTP56000 extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("FLT Machine Code"; Rec."FLT Machine Code")
            {
                ApplicationArea = All;
            }
        }
    }
    
    actions
    {
        addlast(Navigation_Item)
        {
            action(FLTMachineCard)
            {
                ApplicationArea = All;
                Caption = 'Open Machine Card';
                Image = SetupFluent;
                RunObject = page "FLT Machine Card";
                RunPageLink = Code = field("FLT Machine Code");
            }
        }
    }
}