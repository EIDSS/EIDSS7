<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AmendmentHistoryUserControl.ascx.vb" Inherits="EIDSS.AmendmentHistoryUserControl" %>
<div class="panel panel-default">
    <div class="panel-body">
        <div class="table-responsive">
            <eidss:GridView ID="gvAmendmentHistory" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="table table-striped" DataKeyNames="TestAmendmentHistoryID" GridLines="None" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeaderWhenEmpty="true" ShowFooter="true" UseAccessibleHeader="true">
                <HeaderStyle CssClass="table-striped-header" />
                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                <Columns>
                    <asp:BoundField DataField="AmendmentDate" ReadOnly="true" HeaderText="<%$ Resources: Grd_Amendement_History_List_Amendment_Date_Heading %>" SortExpression="AmendmentDate" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="AmendedByPersonName" ReadOnly="true" HeaderText="<%$ Resources: Grd_Amendement_History_List_Amended_By_Person_Name_Heading %>" SortExpression="AmendedByPersonName" />
                    <asp:BoundField DataField="AmendedByOrganizationSiteName" ReadOnly="true" HeaderText="<%$ Resources: Grd_Amendement_History_List_Amended_Ny_Organization_Name_Heading %>" SortExpression="AmendedByOrganizationSiteName" />
                    <asp:BoundField DataField="OriginalTestResultTypeName" ReadOnly="true" HeaderText="<%$ Resources: Grd_Amendement_History_List_Original_Test_Results_Heading %>" SortExpression="OriginalTestResultTypeName" />
                    <asp:BoundField DataField="ChangedTestResultTypeName" ReadOnly="true" HeaderText="<%$ Resources: Grd_Amendement_History_List_Changed_Test_Results_Heading %>" SortExpression="ChangedTestResultTypeName" />
                    <asp:BoundField DataField="ReasonForAmendment" ReadOnly="true" HeaderText="<%$ Resources: Grd_Amendement_History_List_Reason_For_Amendment_Heading %>" SortExpression="ReasonForAmendment" />
                </Columns>
            </eidss:GridView>
        </div>
    </div>
</div>