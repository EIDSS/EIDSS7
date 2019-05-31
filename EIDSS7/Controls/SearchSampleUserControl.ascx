<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchSampleUserControl.ascx.vb" Inherits="EIDSS.SearchSampleUserControl" %>

<asp:UpdatePanel ID="upSearchSample" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
    </Triggers>
    <ContentTemplate>
        <div id="divSearchParameters" runat="server" class="form-group">
            <asp:HiddenField runat="server" ID="hdfUserID" Value="NULL" />
            <asp:HiddenField runat="server" ID="hdfCurrentTab" Value="Samples" />
            <div class="row" runat="server" meta:resourcekey="Dis_Lab_Sample_ID">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Sample_ID" runat="server"></div>
                    <label for="<%= txtEIDSSLaboratorySampleID.ClientID %>" runat="server" meta:resourcekey="Lbl_Lab_Sample_ID" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:TextBox ID="txtEIDSSLaboratorySampleID" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSLaboratorySampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Sample_ID" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Local_Field_Sample_ID">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Local_Field_Sample_ID" runat="server"></div>
                    <label for="<%= txtEIDSSLocalFieldSampleID.ClientID %>" runat="server" meta:resourcekey="Lbl_Local_Field_Sample_ID" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:TextBox ID="txtEIDSSLocalFieldSampleID" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSLocalFieldSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Local_Field_Sample_ID" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Sample_Type">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Type" runat="server"></div>
                    <label for="<%= ddlSampleTypeID.ClientID %>" runat="server" meta:resourcekey="Lbl_Sample_Type" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleTypeID" runat="server"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Sample_Status">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Status" runat="server"></div>
                    <label for="<%= ddlSampleStatusTypeID.ClientID %>" runat="server" meta:resourcekey="Lbl_Sample_Status" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:ListBox CssClass="form-control" ID="lbxSampleStatusTypeID" runat="server" SelectionMode="Multiple"></asp:ListBox>
                    <asp:RequiredFieldValidator ControlToValidate="lbxSampleStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <fieldset>
                <legend runat="server" meta:resourcekey="Lbl_Accession_Date_Range"></legend>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"></div>
                        <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4">
                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Accession_Date_From"></span>
                            <label for="<% =txtAccessionDateFrom.ClientID %>" runat="server" meta:resourcekey="Lbl_From"></label>
                            <eidss:CalendarInput ID="txtAccessionDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                            <asp:RequiredFieldValidator ControlToValidate="txtAccessionDateFrom" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Accession_Date_From" runat="server" EnableClientScript="true" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4">
                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Accession_Date_To"></span>
                            <label for="<% =txtAccessionDateTo.ClientID %>" runat="server" meta:resourcekey="Lbl_To"></label>
                            <eidss:CalendarInput ID="txtAccessionDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                            <asp:RequiredFieldValidator ControlToValidate="txtAccessionDateTo" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Accession_Date_To" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cvAccessionDate" runat="server" CssClass="text-danger" ControlToCompare="txtAccessionDateTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtAccessionDateFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Accession_Date_Compare" ValidationGroup="SearchSample"></asp:CompareValidator>
                        </div>
                    </div>
                </div>
            </fieldset>
            <div class="row" runat="server" meta:resourcekey="Dis_Report_Session_Type">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Report_Session_Type" runat="server"></div>
                    <label for="<%= ddlReportSessionType.ClientID %>" runat="server" meta:resourcekey="Lbl_Report_Session_Type" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList ID="ddlReportSessionType" runat="server" CssClass="form-control" onchange="ddlReportSessionType_onchange();"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlReportSessionType" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Report_Session_Type" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Surveillance_Type">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Surveillance_Type" runat="server"></div>
                    <label for="<%= ddlSurveillanceType.ClientID %>" runat="server" meta:resourcekey="Lbl_Surveillance_Type" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList ID="ddlSurveillanceTypeID" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlSurveillanceTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Surveillance_Type" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Report_Campaign_Session_ID">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Report_Campaign_Session_ID" runat="server"></div>
                    <label for="<%= txtEIDSSReportCampaignSessionID.ClientID %>" runat="server" meta:resourcekey="Lbl_Report_Campaign_Session_ID" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:TextBox ID="txtEIDSSReportCampaignSessionID" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSReportCampaignSessionID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Report_Campaign_Session_ID" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Disease">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Disease"></div>
                    <label for="<%= ddlDiseaseID.ClientID %>" runat="server" meta:resourcekey="Lbl_Disease"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDiseaseID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="SearchSample" meta:resourceKey="Val_Disease"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Person">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Person" runat="server"></div>
                    <label for="<%= txtPatientName.ClientID %>" runat="server" meta:resourcekey="Lbl_Person" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:TextBox ID="txtPatientName" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtPatientName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Person" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Farm_Owner">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Farm_Owner" runat="server"></div>
                    <label for="<%= txtFarmOwnerName.ClientID %>" runat="server" meta:resourcekey="Lbl_Farm_Owner" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:TextBox ID="txtFarmOwnerName" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtFarmOwnerName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Farm_Owner" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Species">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Species" runat="server"></div>
                    <label for="<%= ddlSpeciesTypeID.ClientID %>" runat="server" meta:resourcekey="Lbl_Species" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList ID="ddlSpeciesTypeID" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlSpeciesTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Species" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Organization_Sent_To">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Organization_Sent_To" runat="server"></div>
                    <label for="<%= ddlOrganizationSentToID.ClientID %>" runat="server" meta:resourcekey="Lbl_Organization_Sent_To" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList ID="ddlOrganizationSentToID" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlOrganizationSentToID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Organization_Sent_To" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Organization_Transferred_To">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Organization_Transferred_To" runat="server"></div>
                    <label for="<%= ddlOrganizationTransferredToID.ClientID %>" runat="server" meta:resourcekey="Lbl_Organization_Transferred_To" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList ID="ddlOrganizationTransferredToID" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlOrganizationTransferredToID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Organization_Transferred_To" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Transfer_ID">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Transfer_ID" runat="server"></div>
                    <label for="<%= txtEIDSSTransferID.ClientID %>" runat="server" meta:resourcekey="Lbl_Transfer_ID" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <asp:TextBox ID="txtEIDSSTransferID" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtEIDSSTransferID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Transfer_ID" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Results_Received_From">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Results_Received_From" runat="server"></div>
                    <label for="<%= ddlResultsReceivedFromID.ClientID %>" runat="server" meta:resourcekey="Lbl_Results_Received_From" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList ID="ddlResultsReceivedFromID" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlResultsReceivedFromID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Results_Received_From" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Name">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Name" runat="server"></div>
                    <label for="<%= ddlTestNameTypeID.ClientID %>" runat="server" meta:resourcekey="Lbl_Test_Name" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList CssClass="form-control" ID="ddlTestNameTypeID" runat="server"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlTestNameTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Name" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Status">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Status" runat="server"></div>
                    <label for="<%= ddlTestStatusTypeID %>" runat="server" meta:resourcekey="Lbl_Test_Status" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList CssClass="form-control" ID="ddlTestStatusTypeID" runat="server"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlTestStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Name" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <div class="row" runat="server" meta:resourcekey="Dis_Test_Result">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-right">
                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Test_Result" runat="server"></div>
                    <label for="<%= ddlTestResultTypeID %>" runat="server" meta:resourcekey="Lbl_Test_Result" class="control-label"></label>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                    <eidss:DropDownList CssClass="form-control" ID="ddlTestResultTypeID" runat="server"></eidss:DropDownList>
                    <asp:RequiredFieldValidator ControlToValidate="ddlTestResultTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Result" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row">&nbsp;</div>
            <fieldset>
                <legend runat="server" meta:resourcekey="Lbl_Test_Result_Date_Range"></legend>
                <div class="form-group">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"></div>
                        <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4">
                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Test_Result_Date_From"></span>
                            <label for="<% =txtTestResultDateFrom.ClientID %>" runat="server" meta:resourcekey="Lbl_From"></label>
                            <eidss:CalendarInput ID="txtTestResultDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                            <asp:RequiredFieldValidator ControlToValidate="txtTestResultDateFrom" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Result_Date_From" runat="server" EnableClientScript="true" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4">
                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Test_Result_Date_To"></span>
                            <label for="<% =txtTestResultDateTo.ClientID %>" runat="server" meta:resourcekey="Lbl_To"></label>
                            <eidss:CalendarInput ID="txtTestResultDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" />
                            <asp:RequiredFieldValidator ControlToValidate="txtTestResultDateTo" CssClass="text-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Test_Result_Date_To" runat="server" ValidationGroup="SearchSample"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cvTestResultDateTo" runat="server" CssClass="text-danger" ControlToCompare="txtTestResultDateTo" CultureInvariantValues="true" Display="Dynamic" EnableClientScript="true" ControlToValidate="txtTestResultDateFrom" Type="Date" SetFocusOnError="true" Operator="LessThanEqual" meta:resourcekey="Val_Test_Result_Date_Compare" ValidationGroup="SearchSample"></asp:CompareValidator>
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="modal-footer text-center" style="padding-left: 0px; padding-right: 0px;">
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchSample" CausesValidation="False" />
        </div>
        <script>
            function ddlReportSessionType_onchange() {
                var ddlReportSessionType = document.getElementById("<%=ddlReportSessionType.ClientID %>");
                var ddlSpecies = document.getElementById("<%=ddlSpeciesTypeID.ClientID %>");

                if (ddlReportSessionType.options[ddlReportSessionType.selectedIndex].text == "Human" ||
                    ddlReportSessionType.options[ddlReportSessionType.selectedIndex].text == "Vector")
                    ddlSpecies.disabled = true;
                else
                    ddlSpecies.disabled = false;
            }
        </script>
    </ContentTemplate>
</asp:UpdatePanel>
