page 56002 "FLT Machine Maint. Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "FLT Maintenance Machine";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';    
                field("Machine Code"; Rec."Machine Code") { }
                field("Lifecycle End Status"; Rec."Lifecycle End Status") { }
                field("Lifecycle End Date"; Rec."Lifecycle End Date") { }
            }
            group(MaintenanceTime)
            {
                Caption = 'Maintenance Time';
                field("Maint. Time Work"; Rec."Maint. Time Work") { }
                field("Maint. Time Last Date"; Rec."Maint. Time Last Date") { }
                field("Maint. Time Counter"; Rec."Maint. Time Counter") { }
            }
            group(MaintenanceParts)
            {
                Caption = 'Maintenance Parts';
                field("Maint. Parts Q.ty"; Rec."Maint. Parts Q.ty") { }
                field("Maint. Parts Last Date"; Rec."Maint. Parts Last Date") { }
                field("Maint. Parts Counter"; Rec."Maint. Parts Counter") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ChangeStatus)
            {
                Caption = 'Change Status';
                Image = Status;
                trigger OnAction()
                var
                    CustomMgt: Codeunit "FLT Custom Mgt.";
                begin
                    CustomMgt.SetStatusOnMachine(Rec);
                    CurrPage.Update();
                end;
            }
            action(ApplyTimeMaintenance)
            {
                Caption = 'Apply Time Maintenance';
                Image = MaintenanceLedger;
                trigger OnAction()
                var
                    CustomMgt: Codeunit "FLT Custom Mgt.";
                begin
                    CustomMgt.ApplyTimeMaintenance(Rec);
                    CurrPage.Update();
                end;
            }
            action(ApplyPartsMaintenance)
            {
                Caption = 'Apply Parts Maintenance';
                Image = MaintenanceLedger;
                trigger OnAction()
                var
                    CustomMgt: Codeunit "FLT Custom Mgt.";
                begin
                    CustomMgt.ApplyPartsMaintenance(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
}