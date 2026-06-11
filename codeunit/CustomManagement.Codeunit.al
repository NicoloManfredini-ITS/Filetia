codeunit 56000 "FLT Custom Mgt."
{
    procedure LinkMachineToItem(MachineCode: Code[20]; ItemNo: Code[20]; xItemNo: Code[20])
    var
        Item: Record Item;
        RemoveLinkWithItemCnf: Label 'Remove link between machine no. %1 and item no. %2?';
        CreateLinkWithItemCnf: Label 'Link item no. %1 to machine no. %2?';
        ConfirmSubstitutionCnf: Label 'This item is already linked to a different machine. Do you want to continue?';
        OperationAnnulledErr: Label 'Operation annulled.';
    begin
        if (ItemNo = '') and (xItemNo <> '') then
            if not Confirm(StrSubstNo(RemoveLinkWithItemCnf, MachineCode, xItemNo)) then
                Error(OperationAnnulledErr)
            else begin
                Item.Get(xItemNo);
                Item."FLT Machine Code" := '';
                Item.Modify();
                exit;
            end;

        if not Confirm(StrSubstNo(CreateLinkWithItemCnf, ItemNo, MachineCode)) then
            Error(OperationAnnulledErr);

        Item.Get(ItemNo);
        if (Item."FLT Machine Code" <> '') and
           (Item."FLT Machine Code" <> MachineCode) then
            if not Confirm(ConfirmSubstitutionCnf) then
                Error(OperationAnnulledErr);

        Item."FLT Machine Code" := MachineCode;
        Item.Modify();
    end;

    procedure LinkItemToMachine(ItemNo: Code[20]; MachineCode: Code[20]; xMachineCode: Code[20])
    var
        Machine: Record "FLT Machine";
        RemoveLinkWithMachineCnf: Label 'Remove link between item no. %1 and machine no. %2?';
        CreateLinkWithMachineCnf: Label 'Link machine no. %1 to item no. %2?';
        ConfirmSubstitutionCnf: Label 'This machine is already linked to an item. Do you want to continue?';
        OperationAnnulledErr: Label 'Operation annulled.';
    begin
        if (MachineCode = '') and (xMachineCode <> '') then
            if not Confirm(StrSubstNo(RemoveLinkWithMachineCnf, ItemNo, xMachineCode)) then
                Error(OperationAnnulledErr)
            else begin
                Machine.Get(xMachineCode);
                Machine."Linked to Item No." := '';
                Machine.Modify();
                exit;
            end;

        if not Confirm(StrSubstNo(CreateLinkWithMachineCnf, MachineCode, ItemNo)) then
            Error(OperationAnnulledErr);

        Machine.Get(MachineCode);
        if (Machine."Linked to Item No." <> '') and
           (Machine."Linked to Item No." <> ItemNo) then
            if not Confirm(ConfirmSubstitutionCnf) then
                Error(OperationAnnulledErr);

        Machine."Linked to Item No." := ItemNo;
        Machine.Modify();
    end;

    procedure SetStatusOnMachine(var MaintenanceMachine: Record "FLT Maintenance Machine")
    var
        Machine: Record "FLT Machine";
        ConfirmChangeStatusOnMachineLbl: Label 'Do you want to set %1 on %2?';
        AnnulledErr: Label 'Operation annulled.';
        OperationCompletedMsg: Label 'Operation completed successfully.';
    begin
        Machine.Get(MaintenanceMachine."Machine Code");
        Machine.TestField("Current Lifecycle End Status", Machine."Current Lifecycle End Status"::" ");

        MaintenanceMachine.TestField("Lifecycle End Status");

        if not Confirm(StrSubstNo(ConfirmChangeStatusOnMachineLbl, MaintenanceMachine."Lifecycle End Status", Machine.FieldCaption("Current Lifecycle End Status"))) then
            Error(AnnulledErr);

        Machine."Current Lifecycle End Status" := MaintenanceMachine."Lifecycle End Status";
        Machine.Modify();

        MaintenanceMachine."Lifecycle End Date" := Today();
        MaintenanceMachine.Modify();

        Message(OperationCompletedMsg);
    end;

    procedure ApplyTimeMaintenance(var MaintenanceMachine: Record "FLT Maintenance Machine")
    var
        Machine: Record "FLT Machine";
        TotalTimeWorked: Decimal;
        NotEnoughTimeErr: Label 'The required time for periodic maintenance has not been reached. Operation cancelled.';
        ApplyTimeMaintenanceLbl: Label 'Do you want to apply new time maintenance on machine no. %1?';
        OperationAnnulledErr: Label 'Operation annulled.';
        OperationCompletedMsg: Label 'Operation completed successfully.';
    begin
        Machine.Get(MaintenanceMachine."Machine Code");
        TotalTimeWorked := CalcTotalTimeWorked(Machine);
        if TotalTimeWorked < Machine."Maintenance Cycle: Time" * (MaintenanceMachine."Maint. Time Counter" + 1) then
            Error(NotEnoughTimeErr);

        if not Confirm(StrSubstNo(ApplyTimeMaintenanceLbl, MaintenanceMachine."Machine Code")) then
            Error(OperationAnnulledErr);

        MaintenanceMachine."Maint. Time Last Date" := Today();
        MaintenanceMachine."Maint. Time Counter" += 1;
        MaintenanceMachine.Modify();

        Message(OperationCompletedMsg);
    end;

    procedure ApplyPartsMaintenance(var MaintenanceMachine: Record "FLT Maintenance Machine")
    var
        Machine: Record "FLT Machine";
        NotEnoughPartsErr: Label 'The required number of parts for periodic maintenance has not been reached. Operation cancelled.';
        ApplyPartsMaintenanceLbl: Label 'Do you want to apply new parts maintenance on machine no. %1?';
        OperationAnnulledErr: Label 'Operation annulled.';
        OperationCompletedMsg: Label 'Operation completed successfully.';
    begin
        Machine.Get(MaintenanceMachine."Machine Code");
        Machine.CalcFields("Total Parts Produced");
        if Machine."Total Parts Produced" < Machine."Maintenance Cycle: Quantity" * (MaintenanceMachine."Maint. Parts Counter" + 1) then
            Error(NotEnoughPartsErr);

        if not Confirm(StrSubstNo(ApplyPartsMaintenanceLbl, MaintenanceMachine."Machine Code")) then
            Error(OperationAnnulledErr);

        MaintenanceMachine."Maint. Parts Last Date" := Today();
        MaintenanceMachine."Maint. Parts Counter" += 1;
        MaintenanceMachine.Modify();

        Message(OperationCompletedMsg);
    end;

    procedure CalcTotalTimeWorked(Machine: Record "FLT Machine"): Decimal
    begin
        Machine.CalcFields("Total Parts Produced");
        exit(Machine."Total Parts Produced" * Machine."Unit Time for Part" / 3600000);
    end;

    procedure CalcTotalTimeWorkedRestored(Machine: Record "FLT Machine"): Decimal
    begin
        Machine.CalcFields("Total Parts Prod. (Restored)");
        exit(Machine."Total Parts Prod. (Restored)" * Machine."Unit Time for Part" / 3600000);
    end;

    procedure CalcScrapedParts(Machine: Record "FLT Machine"): Integer
    begin
        Machine.CalcFields("Total Parts Produced");
        exit(Round(Machine."Total Parts Produced" * Machine."Scrap Rate" / 100, 1, '>'));
    end;
}