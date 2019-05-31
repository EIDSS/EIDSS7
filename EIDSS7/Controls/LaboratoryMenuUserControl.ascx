<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LaboratoryMenuUserControl.ascx.vb" Inherits="EIDSS.LaboratoryMenuUserControl" EnableViewState="False" %>

<a href="#" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
    <img src="../Includes/Images/labMenu.png" /></a>
<ul class="dropdown-menu" id="ddlMenu" runat="server">
    <li id="AccessionInMenuItem" runat="server"><a onclick="<%= AccessionInMenuItemPostBack %>" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Accession_In_Text %>"></asp:Literal></a></li>
    <li id="GroupAccessionInMenuItem" runat="server"><a onclick="<%= GroupAccessionInMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Group_Accession_Text %>"></asp:Literal></a></li>
    <li id="AssignTestMenuItem" runat="server"><a onclick="<%= AssignTestMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Assign_Test_Text %>"></asp:Literal></a></li>
    <li id="CreateAliquotMenuItem" runat="server"><a onclick="<%= CreateAliquotMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Create_Aliquot_Text %>"></asp:Literal></a></li>
    <li id="CreateDerivativeMenuItem" runat="server"><a onclick="<%= CreateDerivativeMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Create_Derivative_Text %>"></asp:Literal></a></li>
    <li id="TransferOutMenuItem" runat="server"><a onclick="<%= TransferOutMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Transfer_Out_Text %>"></asp:Literal></a></li>
    <li id="RegisterNewSampleMenuItem" runat="server"><a onclick="<%= RegisterNewSampleMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Register_New_Sample_Text %>"></asp:Literal></a></li>
    <li class="menu-divider"></li>
    <li id="SetTestResultsMenuItem" runat="server"><a onclick="<%= SetTestResultsMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Set_Test_Results_Text %>"></asp:Literal></a></li>
    <li id="ValidateTestResultMenuItem" runat="server"><a onclick="<%= ValidateTestResultMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Validate_Test_Result_Text %>"></asp:Literal></a></li>
    <li id="AmendTestResultMenuItem" runat="server"><a onclick="<%= AmendTestResultMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Amend_Test_Result_Text %>"></asp:Literal></a></li>
    <li class="menu-divider"></li>
    <li id="SampleDestructionMenuItem" class="dropdown-submenu"><a tabindex="-1" onclick="<%= SampleDestructionMenuItemPostBack %>" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Sample_Destruction_Text %>"></asp:Literal></a>
        <ul class="dropdown-menu">
            <li id="DestroyByIncinerationMenuItem" runat="server"><a onclick="<%= DestroyByIncinerationMenuItemPostBack %>" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Destroy_By_Incineration_Text %>"></asp:Literal></a></li>
            <li id="DestroyByAutoclaveMenuItem" runat="server"><a onclick="<%= DestroyByAutoclaveMenuItemPostBack %>" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Destroy_By_Autoclave_Text %>"></asp:Literal></a></li>
            <li id="ApproveDestructionMenuItem" runat="server"><a onclick="<%= ApproveDestructionMenuItemPostBack %>" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Approve_Destruction_Text %>"></asp:Literal></a></li>
            <li id="RejectDestructionMenuItem" runat="server"><a onclick="<%= RejectDestructionMenuItemPostBack %>" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Reject_Destruction_Text %>"></asp:Literal></a></li>
        </ul>
    </li>
    <li id="LaboratoryRecordDeletionMenuItem" class="dropdown-submenu"><a href="#" tabindex="-1" onclick="<%= LabRecordDeletionMenuItemPostBack %>">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Lab_Record_Deletion_Text %>"></asp:Literal></a>
        <ul class="dropdown-menu">
            <li id="DeleteSampleMenuItem" runat="server"><a onclick="<%= DeleteSampleMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Delete_Sample_Text %>"></asp:Literal></a></li>
            <li id="DeleteTestMenuItem" runat="server"><a onclick="<%= DeleteTestMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Delete_Test_Text %>"></asp:Literal></a></li>
            <li id="ApproveDeletionMenuItem" runat="server"><a onclick="<%= ApproveDeletionMenuItemPostBack %>" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Approve_Deletion_Text %>"></asp:Literal></a></li>
            <li id="RejectDeletionMenuItem" runat="server"><a onclick="<%= RejectDeletionMenuItemPostBack %>" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Reject_Deletion_Text %>"></asp:Literal></a></li>
        </ul>
    </li>
    <li id="RestoreSampleMenuItem" runat="server"><a tabindex="-1" onclick="<%= RestoreSampleMenuItemPostBack %>" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Restore_Sample_Text %>"></asp:Literal></a></li>
    <li class="menu-divider"></li>
    <li class="dropdown-submenu"><a tabindex="-1" onclick="<%= PaperFormsMenuItemPostBack %>" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Paper_Forms_Text %>"></asp:Literal></a>
        <ul class="dropdown-menu">
            <li id="SampleReportMenuItem" runat="server"><a onclick="<%= SampleReportMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Sample_Report_Text %>"></asp:Literal></a></li>
            <li id="AccessionInFormMenuItem" runat="server"><a onclick="<%= AccessionInFormMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Accession_In_Form_Text %>"></asp:Literal></a></li>
            <li id="TestResultReportMenuItem" runat="server"><a onclick="<%= TestReportMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Test_Result_Report_Text %>"></asp:Literal></a></li>
            <li id="TransferReportMenuItem" runat="server"><a onclick="<%= TransferReportMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Transfer_Report_Text %>"></asp:Literal></a></li>
            <li id="DestructionReportMenuItem" runat="server"><a onclick="<%= DestructionReportMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
                <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Destruction_Report_Text %>"></asp:Literal></a></li>
        </ul>
    </li>
    <li id="PrintBarcodeMenuItem" runat="server"><a onclick="<%= PrintBarcodeMenuItemPostBack %>" data-toggle="modal" style="cursor: pointer;">
        <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Print_Barcode_Text %>"></asp:Literal></a></li>
</ul>
