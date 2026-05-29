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
}