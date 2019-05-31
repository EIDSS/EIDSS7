<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AddUpdateTestUserControl.ascx.vb" Inherits="EIDSS.AddUpdateTestUserControl" %>
<div id="divHiddenFieldsSection" runat="server" visible="false">
    <asp:HiddenField ID="hdfRecordID" runat="server" Value="0" />
    <asp:HiddenField ID="hdfRecordAction" runat="server" Value="" />
    <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
    <asp:HiddenField ID="hdfDiseaseID" runat="server" Value="" />
    <asp:HiddenField ID="hdfTestCategoryTypeID" runat="server" Value="" />
    <asp:HiddenField ID="hdfTestsCount" runat="server" Value="0" />
    <asp:HiddenField ID="hdfSiteID" runat="server" Value="" />
    <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="" />
    <asp:HiddenField ID="hdfPersonID" runat="server" Value="" />
    <asp:HiddenField ID="hdfUserFirstName" runat="server" Value="" />
    <asp:HiddenField ID="hdfUserLastName" runat="server" Value="" />
</div>
<asp:UpdatePanel ID="upAddUpdateTest" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="chkExternalResultsIndicator" EventName="CheckedChanged" />
        <asp:AsyncPostBackTrigger ControlID="ddlTestResultTypeID" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="ddlTestNameTypeID" EventName="SelectedIndexChanged" />
    </Triggers>
    <ContentTemplate>
        <div id="divAddUpdateTest" runat="server" class="accordion-body">
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Disease">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtDiseaseName.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Disease_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtDiseaseName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Name">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtTestNameTypeName.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Name_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:DropDownList ID="ddlTestNameTypeID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                    <asp:TextBox ID="txtTestNameTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Status">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtTestStatusTypeName.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Status_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:DropDownList ID="ddlTestStatusTypeID" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:TextBox ID="txtTestStatusTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Result">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Test_Result"></div>
                    <label for="<%= ddlTestResultTypeID.ClientID %>" runat="server"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Result_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:DropDownList ID="ddlTestResultTypeID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlTestResultTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="EditSampleTestDetails" meta:resourceKey="Val_Test_Result"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Date_Test_Started">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtStartedDate.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Started_Date_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:CalendarInput ID="txtStartedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                    <asp:CompareValidator ID="cvStartedDate" Operator="LessThanEqual" CssClass="alert-danger" Type="String" Display="Dynamic" ControlToValidate="txtStartedDate" meta:resourcekey="Val_Future_Started_Date" runat="server" ValidationGroup="EditSampleTestDetails" />
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Result_Date">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtResultDate.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Result_Date_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <eidss:CalendarInput ID="txtResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                    <asp:CompareValidator ID="cvResultDate" Operator="LessThanEqual" Type="Date" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtResultDate" meta:resourcekey="Val_Future_Result_Date" runat="server" ValidationGroup="EditSampleTestDetails" />
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Category">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtTestCategoryTypeName.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Test_Category_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtTestCategoryTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Tested_By">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtTestedByPersonName.ClientID %>" class="control-label" runat="server"><%= GetGlobalResourceObject("Labels", "Lbl_Tested_By_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:DropDownList ID="ddlTestedByPerson" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:TextBox ID="txtTestedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Results_Entered_By">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtResultsEnteredByPersonName.ClientID %>" class="control-label" runat="server"><%= GetGlobalResourceObject("Labels", "Lbl_Results_Entered_By_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtResultsEnteredByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Validated_By">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtValidatedByPersonName.ClientID %>" class="control-label" runat="server"><%= GetGlobalResourceObject("Labels", "Lbl_Validated_By_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtValidatedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_External_Results">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= chkExternalResultsIndicator.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_External_Results_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <div class="btn-group">
                        <div class="checkbox-inline">
                            <asp:CheckBox ID="chkExternalResultsIndicator" runat="server" Enabled="false" />
                            <label runat="server" meta:resourcekey="Lbl_External_Results"></label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Results_Received_By">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtResultsReceivedByPersonName.ClientID %>" class="control-label" runat="server"><%= GetGlobalResourceObject("Labels", "Lbl_Results_Received_By_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtResultsReceivedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Date_Result_Received">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtReceivedDate.ClientID %>" runat="server" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Date_Result_Received_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtReceivedDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Contact_Person">
                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-right">
                    <label for="<%= txtContactPersonName.ClientID %>" class="control-label" runat="server"><%= GetGlobalResourceObject("Labels", "Lbl_Point_Of_Contact_Text") %></label>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <asp:TextBox ID="txtContactPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>