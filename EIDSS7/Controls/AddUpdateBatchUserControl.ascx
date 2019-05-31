<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AddUpdateBatchUserControl.ascx.vb" Inherits="EIDSS.AddUpdateBatchUserControl" %>
<%@ Register Src="~/Controls/FlexFormLoadTemplate.ascx" TagPrefix="eidss" TagName="FlexFormLoadTemplate" %>
<div id="divHiddenFieldsSection" runat="server" visible="false">
    <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
    <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
    <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
    <asp:HiddenField ID="hdfFirstName" runat="server" Value="" />
    <asp:HiddenField ID="hdfLastName" runat="server" Value="" />
    <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />
    <asp:HiddenField ID="hdfOrganizationName" runat="server" Value="" />
    <asp:HiddenField ID="hdfBatchTestTestTypeID" runat="server" Value="" />
    <asp:HiddenField ID="hdfFormTypeID" runat="server" Value="10034019" />
    <asp:HiddenField ID="hdfDiagnosisID" runat="server" Value="null" />
    <asp:HiddenField ID="hdfCountryID" runat="server" Value="null" />
</div>
<asp:UpdatePanel ID="upAddUpdateBatch" runat="server" UpdateMode="Conditional">
    <Triggers></Triggers>
    <ContentTemplate>
        <asp:HiddenField ID="hdfObservationID" runat="server" Value="null" />
        <asp:HiddenField ID="hdfFormTemplateID" runat="server" Value="null" />
        <div id="divEIDSSBatchID" runat="server">
            <div class="row" runat="server" meta:resourcekey="Dis_Batch_ID">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Batch_ID" runat="server"></div>
                    <label for="<%= txtEIDSSBatchTestID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Batch_ID_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtEIDSSBatchTestID" runat="server" Enabled="false" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="row">&nbsp;</div>
        <div class="row" meta:resourcekey="Dis_Test_Name">
            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Name" runat="server"></div>
                <label for="<%= txtBatchTestTestNameTypeName.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Name_Text") %></label>
            </div>
            <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                <asp:TextBox ID="txtBatchTestTestNameTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
            </div>
        </div>
        <div id="divTestResult" runat="server">
            <div class="row">&nbsp;</div>
            <div class="row" meta:resourcekey="Dis_Test_Result" runat="server">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Result" runat="server"></div>
                    <label for="<%= ddlTestResultTypeID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Result_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:DropDownList ID="ddlTestResultTypeID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvTestResultTypeID" runat="server" ControlToValidate="ddlTestResultTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="EditSampleTestDetails" meta:resourceKey="Val_Test_Result"></asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
        <div class="row">&nbsp;</div>
        <div class="row" meta:resourcekey="Dis_Tested_By">
            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Tested_By" runat="server"></div>
                <label for="<%= ddlTestedByPersonID.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Tested_By_Text") %></label>
            </div>
            <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                <eidss:DropDownList CssClass="form-control" ID="ddlTestedByPersonID" runat="server"></eidss:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTestedByPersonID" ControlToValidate="ddlTestedByPersonID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Tested_By" runat="server"></asp:RequiredFieldValidator>
            </div>
            <div class="col-md-2">
                <asp:LinkButton ID="btnLookupEmployee" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="false"><span class="glyphicon glyphicon-search"></span></asp:LinkButton>
                <asp:LinkButton ID="btnCreateEmployee" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="false"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
            </div>
        </div>
        <div class="row">&nbsp;</div>
        <div class="row" meta:resourcekey="Dis_Test_Started_Date">
            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Started_Date" runat="server"></div>
                <label for="<%= txtTestStartedDate.ClientID %>" class="control-label"><% =GetGlobalResourceObject("Labels", "Lbl_Test_Started_Date_Text") %></label>
            </div>
            <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                <eidss:CalendarInput ID="txtTestStartedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
            </div>
        </div>
        <div class="row">&nbsp;</div>
        <div class="row" runat="server" meta:resourcekey="Dis_Result_Date">
            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                <label for="<%= txtResultDate.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Result_Date_Text") %></label>
            </div>
            <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                <eidss:CalendarInput ID="txtResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                <asp:CompareValidator ID="cvResultDate" Operator="LessThanEqual" Type="Date" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtResultDate" meta:resourcekey="Val_Future_Result_Date" runat="server" />
            </div>
        </div>
        <div class="row">&nbsp;</div>
        <div class="form-group">
            <div class="row">
                <asp:UpdatePanel runat="server" ID="LUC08FlexFormTemplate">
                    <ContentTemplate>
                        <fieldset>
                            <legend runat="server" meta:resourcekey="Lbl_Quality_Control_Values"></legend>
                                <asp:Panel runat="server" ID="pnlLUC08" Width="100%"></asp:Panel>
                        </fieldset>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
