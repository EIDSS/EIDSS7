<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AmendTestResultUserControl.ascx.vb" Inherits="EIDSS.AmendTestResultUserControl" %>

<asp:UpdatePanel ID="upAmendTestResult" runat="server" UpdateMode="Conditional">
    <Triggers>
    </Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
        <asp:HiddenField ID="hdfTestID" runat="server" />
        <asp:HiddenField ID="hdfOriginalTestResultTypeID" runat="server" />
        <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
        <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
        <asp:HiddenField ID="hdfFirstName" runat="server" Value="" />
        <asp:HiddenField ID="hdfLastName" runat="server" Value="" />
        <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />
        <asp:HiddenField ID="hdfOrganizationName" runat="server" Value="" />

        <div class="panel panel-default">
            <div class="panel-body">
                <div class="row">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <label for="txtTestResultTypeName" runat="server" meta:resourcekey="Lbl_Current_Test_Result" class="control-label"></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <asp:TextBox ID="txtTestResultTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Changed_Test_Result" runat="server"></div>
                        <label for="ddlChangedTestResultTypeID" runat="server" meta:resourcekey="Lbl_Changed_Test_Result" class="control-label"></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <eidss:DropDownList CssClass="form-control" ID="ddlChangedTestResultTypeID" runat="server"></eidss:DropDownList>
                        <asp:RequiredFieldValidator ControlToValidate="ddlChangedTestResultTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Changed_Test_Result" runat="server" ValidationGroup="AmendTestResult"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">&nbsp;</div>
                <div class="row">
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Reason_For_Amendment" runat="server"></div>
                        <label for="txtReasonForAmendment" runat="server" meta:resourcekey="Lbl_Reason_For_Amendment" class="control-label"></label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <asp:TextBox ID="txtReasonForAmendment" runat="server" CssClass="form-control" Rows="5" TextMode="MultiLine"></asp:TextBox>
                        <asp:RequiredFieldValidator ControlToValidate="txtReasonForAmendment" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Reason_For_Amendment" runat="server" ValidationGroup="AmendTestResult"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
