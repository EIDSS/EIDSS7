<%@ Page Title="Livestock Veterinary Disease Report" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="LivestockDiseaseReport.aspx.vb" Inherits="EIDSS.LivestockDiseaseReport" MaintainScrollPositionOnPostback="true" %>

<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<%@ Register Src="~/Controls/SearchPersonUserControl.ascx" TagPrefix="eidss" TagName="SearchPersonUserControl" %>
<%@ Register Src="~/Controls/AddUpdatePersonUserControl.ascx" TagPrefix="eidss" TagName="AddUpdatePersonUserControl" %>
<%@ Register Src="~/Controls/SearchVeterinaryDiseaseReportUserControl.ascx" TagPrefix="eidss" TagName="SearchVeterinaryDiseaseReportUserControl" %>
<%@ Register Src="~/Controls/VeterinaryFFLoadTemplate.ascx" TagPrefix="eidss" TagName="FlexForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="upHiddenFields" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divHiddenFieldsSection" runat="server" visible="false">
                <asp:HiddenField ID="hdfCaller" runat="server" Value="DASHBOARD" />
                <asp:HiddenField ID="hdfFarmMasterID" runat="server" Value="" />
                <asp:HiddenField ID="hdfFarmID" runat="server" Value="" />
                <asp:HiddenField ID="hdfFarmOwnerID" runat="server" Value="" />
                <asp:HiddenField ID="hdfFarmAddressID" runat="server" Value="" />
                <asp:HiddenField ID="hdfEIDSSFarmID" runat="server" Value="" />
                <asp:HiddenField ID="hdfVeterinaryDiseaseReportID" runat="server" Value="-1" />
                <asp:HiddenField ID="hdfFarmEpidemiologicalInfoObservationID" runat="server" Value="" />
                <asp:HiddenField ID="hdfControlMeasuresObservationID" runat="server" Value="" />
                <asp:HiddenField ID="hdfTestsConductedIndicator" runat="server" Value="" />
                <asp:HiddenField ID="hdfRowStatus" runat="server" Value="0" />
                <asp:HiddenField ID="hdfReportCategoryTypeID" runat="server" Value="10012003" />
                <asp:HiddenField ID="hdfFarmSickAnimalQuantity" runat="server" Value="0" />
                <asp:HiddenField ID="hdfFarmTotalAnimalQuantity" runat="server" Value="0" />
                <asp:HiddenField ID="hdfFarmDeadAnimalQuantity" runat="server" Value="0" />
                <asp:HiddenField ID="hdfEnteredByPersonID" runat="server" Value="" />
                <asp:HiddenField ID="hdfRelatedToVeterinaryDiseaseReportID" runat="server" Value="" />
            </div>
            <asp:HiddenField ID="hdfRowID" runat="server" Value="0" />
            <asp:HiddenField ID="hdfRowAction" runat="server" Value="" />
            <asp:HiddenField ID="hdfIdentity" runat="server" Value="0" />
            <asp:HiddenField ID="hdfRecordType" runat="server" Value="" />
            <asp:HiddenField ID="hdfCopySpeciesClinicalInvestigationObservationID" runat="server" Value="" />
            <asp:HiddenField ID="hdfWarningMessageType" runat="server" Value="" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h2 runat="server" meta:resourcekey="Hdg_Livestock_Disease_Report"></h2>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-12">
                    <div class="glyphicon glyphicon-asterisk text-danger"></div>
                    <label><%= GetGlobalResourceObject("OtherText", "Pln_Required_Text") %></label>
                </div>
            </div>
            <asp:UpdatePanel ID="upSearchDiseaseReports" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <eidss:SearchVeterinaryDiseaseReportUserControl ID="ucSearchVeterinaryDiseaseReport" runat="server" />
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdatePanel ID="upAddUpdateDiseaseReport" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div id="divDiseaseReportContainer" class="embed-panel" runat="server">
                        <div id="divDiseaseReportForm" runat="server">
                            <div class="panel panel-default">
                                <div id="divStickyHeader" runat="server" class="panel-heading" role="tab">
                                    <div class="row">
                                        <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                            <h3 runat="server" meta:resourcekey="Hdg_Disease_Report_Summary"></h3>
                                        </div>
                                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                            <a id="diseaseReportSummaryCollapsible" data-toggle="collapse" data-parent="#diseaseReportSummary" href="#diseaseReportSummaryDetail" role="button" aria-expanded="false" aria-controls="diseaseReportSummaryDetail">
                                                <span class="glyphicon glyphicon-triangle-bottom header-button"></span>
                                            </a>
                                        </div>
                                    </div>
                                    <asp:UpdatePanel ID="upDiseaseReportStickySummary" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Disease_Report_ID">
                                                    <label runat="server" for="<%= txtEIDSSReportID.ClientID %>" meta:resourcekey="Lbl_Report_ID" class="control-label"></label>
                                                    <asp:TextBox ID="txtEIDSSReportID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="Dis_Report_Status">
                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Report_Status"></div>
                                                    <label for="<%= ddlReportStatusTypeID.ClientID %>" runat="server" meta:resourcekey="Lbl_Report_Status" class="control-label"></label>
                                                    <eidss:DropDownList ID="ddlReportStatusTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlReportStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Report_Status"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="Dis_Case_Classification">
                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Case_Classification"></div>
                                                    <label for="<%= ddlClassificationTypeID.ClientID %>" runat="server" meta:resourcekey="Lbl_Case_Classification" class="control-label"></label>
                                                    <eidss:DropDownList ID="ddlClassificationTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlClassificationTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Case_Classification"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <div class="row">&nbsp;</div>
                                </div>
                                <div id="diseaseReportSummaryDetail" class="panel-collapse" role="tabpanel" aria-labelledby="headingOne">
                                    <div class="panel-body">
                                        <asp:UpdatePanel ID="upDiseaseReportCollapsibleSummary" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <div id="divReportSummary" runat="server">
                                                    <div class="form-group">
                                                        <p runat="server" meta:resourcekey="Lbl_Required"></p>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div id="divRelatedToDiseaseReport" class="col-lg-3 col-md-3 col-sm-12 col-xs-12" runat="server" visible="false">
                                                                    <label for="<%= btnRelatedToDiseaseReport.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Related_To_Disease_Report_Text") %></label>
                                                                    <asp:LinkButton ID="btnRelatedToDiseaseReport" runat="server"></asp:LinkButton>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Field_Accession_ID">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Field_Accession_ID"></div>
                                                                    <label for="<%= txtEIDSSFieldAccessionID.ClientID %>" runat="server" meta:resourcekey="Lbl_Field_Accession_ID"></label>
                                                                    <asp:TextBox ID="txtEIDSSFieldAccessionID" runat="server" CssClass="form-control"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEIDSSFieldAccessionID" CssClass="alert-danger" Display="Dynamic" InitialValue="" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Field_Accession_ID"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Outbreak_ID">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Outbreak_ID"></div>
                                                                    <label for="<%= txtEIDSSOutbreakID.ClientID %>" runat="server" meta:resourcekey="Lbl_Outbreak_ID" class="control-label"></label>
                                                                    <asp:TextBox ID="txtEIDSSOutbreakID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEIDSSOutbreakID" CssClass="alert-danger" Display="Dynamic" InitialValue="" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Outbreak_ID"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Session_ID">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Session_ID"></div>
                                                                    <label for="<%= txtEIDSSParentMonitoringSessionID.ClientID %>" runat="server" meta:resourcekey="Lbl_Session_ID" class="control-label"></label>
                                                                    <asp:TextBox ID="txtEIDSSParentMonitoringSessionID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEIDSSParentMonitoringSessionID" CssClass="alert-danger" Display="Dynamic" InitialValue="" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Session_ID"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div id="divLegacyID" class="col-lg-3 col-md-3 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Legacy_ID">
                                                                    <label runat="server" for="<%= txtLegacyID.ClientID %>" meta:resourcekey="Lbl_Legacy_ID" class="control-label"></label>
                                                                    <asp:TextBox ID="txtLegacyID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="Dis_Report_Type">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Report_Type"></div>
                                                                    <label for="<%= ddlReportTypeID.ClientID %>" runat="server" meta:resourcekey="Lbl_Report_Type" class="control-label"></label>
                                                                    <eidss:DropDownList ID="ddlReportTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlReportTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Report_Type"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-6" runat="server" meta:resourcekey="Dis_Diagnosis_Date">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Diagnosis_Date"></div>
                                                                    <label for="<%= txtDiagnosisDate.ClientID %>" runat="server" meta:resourcekey="Lbl_Date_Of_Diagnosis"></label>
                                                                    <eidss:CalendarInput ID="txtDiagnosisDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                                    <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="txtDiagnosisDate" ValidationGroup="DiseaseReport" InitialValue="" Display="Dynamic" meta:resourceKey="Val_Diagnosis_Date"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-6" runat="server" meta:resourcekey="Dis_Disease">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Disease"></div>
                                                                    <label for="<%= ddlDiseaseID.ClientID %>" runat="server" meta:resourcekey="Lbl_Disease"></label>
                                                                    <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDiseaseID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Disease"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="sectionContainer expanded">
                                            <section id="FarmDetails" runat="server" class="col-md-12">
                                                <p runat="server" meta:resourcekey="Lbl_Required"></p>
                                                <div class="panel panel-default">
                                                    <div class="panel-heading">
                                                        <div class="row">
                                                            <div class="col-lg-11 col-md-11 col-sm-10 col-xs-10">
                                                                <h3><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Details_Text") %></h3>
                                                            </div>
                                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                                <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(0, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="panel-body">
                                                        <div class="form-group" runat="server" meta:resourcekey="Dis_Farm_Details_Farm_ID">
                                                            <div class="row">
                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Farm_Details_Farm_ID"></div>
                                                                    <label for="<%= txtEIDSSFarmID.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Farm_ID_Text") %></label>
                                                                    <asp:TextBox ID="txtEIDSSFarmID" runat="server" CssClass="form-control"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="txtEIDSSFarmID" Display="Dynamic" meta:resourceKey="Val_Farm_Details_Farm_ID"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Farm_Name">
                                                                    <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Farm_Name"></div>
                                                                    <label for="<%= txtFarmName.ClientID %>" class="control-label"><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Name_Text") %></label>
                                                                    <asp:TextBox ID="txtFarmName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFarmName" CssClass="alert-danger" Display="Dynamic" InitialValue="null" ValidationGroup="DiseaseReport" meta:resourceKey="Val_Disease"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <fieldset>
                                                            <legend><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Owner_Text") %></legend>
                                                            <div class="form-group">
                                                                <div class="row">
                                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                        <label for="<%= txtEIDSSPersonID.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Farm_Owner_ID_Text") %></label>
                                                                        <asp:TextBox ID="txtEIDSSPersonID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                        <label for="<%= txtFarmOwnerLastName.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Last_Name_Text") %></label>
                                                                        <asp:TextBox ID="txtFarmOwnerLastName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                        <label for="<%= txtFarmOwnerFirstName.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_First_Name_Text") %></label>
                                                                        <asp:TextBox ID="txtFarmOwnerFirstName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                                        <label for="<%= txtFarmOwnerSecondName.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Middle_Name_Text") %></label>
                                                                        <asp:TextBox ID="txtFarmOwnerSecondName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                                                    <label for="<%= txtPhone.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Phone_Text") %></label>
                                                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                </div>
                                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                                                    <label for="<%= txtEmail.ClientID %>"><%= GetGlobalResourceObject("Labels", "Lbl_Email_Text") %></label>
                                                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label runat="server" meta:resourcekey="Lbl_Current_Address"></label>
                                                        </div>
                                                        <eidss:LocationUserControl ID="FarmAddress" runat="server" OnLoad="FarmAddress_Load" IsHorizontalLayout="true" ShowCountry="true" IsDbRequiredCountry="true" ShowRegion="true" IsDbRequiredRegion="true" ShowRayon="true" IsDbRequiredRayon="true" ShowSettlementType="true" ShowSettlement="true" ShowStreet="true" ShowBuildingHouseApartmentGroup="true" ShowPostalCode="true" ShowElevation="false" ShowMap="true" ShowCoordinates="true" />
                                                    </div>
                                                </div>
                                            </section>
                                            <section id="Notification" runat="server" class="col-md-12 hidden">
                                                <p runat="server" meta:resourcekey="Lbl_Required"></p>
                                                <div class="panel panel-default">
                                                    <div class="panel-heading">
                                                        <div class="row">
                                                            <div class="col-lg-11 col-md-11 col-sm-10 col-xs-10">
                                                                <h3 runat="server" meta:resourcekey="Hdg_Notification"></h3>
                                                            </div>
                                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                                <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(1, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="panel-body">
                                                        <fieldset>
                                                            <legend runat="server" meta:resourcekey="Lbl_Notification"></legend>
                                                            <div class="form-group">
                                                                <div class="row">
                                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Reported_By_Organization">
                                                                        <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Reported_By_Organization"></div>
                                                                        <label for="<%= ddlReportedByOrganizationID.ClientID %>" runat="server" meta:resourcekey="Lbl_Organization"></label>
                                                                        <asp:DropDownList ID="ddlReportedByOrganizationID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                                        <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="ddlReportedByOrganizationID" ValidationGroup="Notification" InitialValue="null" Display="Dynamic" meta:resourceKey="Val_Reported_By_Organization"></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Reported_By_Person">
                                                                        <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Reported_By_Person"></div>
                                                                        <label for="<%= ddlReportedByPersonID.ClientID %>" runat="server" meta:resourcekey="Lbl_Reported_By"></label>
                                                                        <asp:UpdatePanel ID="upReportedByPerson" runat="server" UpdateMode="Conditional">
                                                                            <Triggers>
                                                                                <asp:AsyncPostBackTrigger ControlID="ddlReportedByOrganizationID" EventName="SelectedIndexChanged" />
                                                                            </Triggers>
                                                                            <ContentTemplate>
                                                                                <asp:DropDownList ID="ddlReportedByPersonID" runat="server" CssClass="form-control" Enabled="false"></asp:DropDownList>
                                                                                <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="ddlReportedByPersonID" ValidationGroup="Notification" InitialValue="null" Display="Dynamic" meta:resourceKey="Val_Reported_By_Person"></asp:RequiredFieldValidator>
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Initial_Report_Date">
                                                                        <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Initial_Report_Date"></div>
                                                                        <label for="<%= txtReportDate.ClientID %>" runat="server" meta:resourcekey="Lbl_Initial_Report_Date"></label>
                                                                        <eidss:CalendarInput ID="txtReportDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                                        <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="txtReportDate" ValidationGroup="Notification" InitialValue="" Display="Dynamic" meta:resourceKey="Val_Initial_Report_Date"></asp:RequiredFieldValidator>
                                                                        <asp:CompareValidator ID="cmvFutureReportDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtReportDate" meta:resourcekey="Val_Future_Report_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="Notification" SetFocusOnError="True"></asp:CompareValidator>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                        <fieldset>
                                                            <legend runat="server" meta:resourcekey="Lbl_Investigated"></legend>
                                                            <div class="form-group" runat="server">
                                                                <div class="row">
                                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Investigated_By_Organization">
                                                                        <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Investigated_By_Organization"></div>
                                                                        <label for="<%= ddlInvestigatedByOrganizationID.ClientID %>" runat="server" meta:resourcekey="Lbl_Investigation_Organization"></label>
                                                                        <asp:DropDownList ID="ddlInvestigatedByOrganizationID" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                                                                        <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="ddlInvestigatedByOrganizationID" ValidationGroup="Notification" InitialValue="null" Display="Dynamic" meta:resourceKey="Val_Investigated_By_Organization"></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12" runat="server" meta:resourcekey="Dis_Investigated_By_Person">
                                                                        <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Investigated_By_Person"></div>
                                                                        <label for="<%= ddlInvestigatedByPersonID.ClientID %>" runat="server" meta:resourcekey="Lbl_Investigator_Name"></label>
                                                                        <asp:DropDownList ID="ddlInvestigatedByPersonID" runat="server" CssClass="form-control" Enabled="false"></asp:DropDownList>
                                                                        <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="ddlInvestigatedByPersonID" ValidationGroup="Notification" InitialValue="null" Display="Dynamic" meta:resourceKey="Val_Investigated_By_Person"></asp:RequiredFieldValidator>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="row">
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="Dis_Assigned_Date">
                                                                        <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Assigned_Date"></div>
                                                                        <label for="<%= txtAssignedDate.ClientID %>" runat="server" meta:resourcekey="Lbl_Assigned_Date"></label>
                                                                        <eidss:CalendarInput ID="txtAssignedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                                        <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="txtAssignedDate" ValidationGroup="Notification" InitialValue="" Display="Dynamic" meta:resourceKey="Val_Assigned_Date"></asp:RequiredFieldValidator>
                                                                        <asp:CompareValidator ID="cmvFutureAssignedDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtAssignedDate" meta:resourcekey="Val_Future_Assigned_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="Notification" SetFocusOnError="True"></asp:CompareValidator>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="Dis_Investigation_Date">
                                                                        <div class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="Req_Investigation_Date"></div>
                                                                        <label for="<%= txtInvestigationDate.ClientID %>" runat="server" meta:resourcekey="Lbl_Invesigation_Date"></label>
                                                                        <eidss:CalendarInput ID="txtInvestigationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                                        <asp:RequiredFieldValidator runat="server" CssClass="text-danger" ControlToValidate="txtInvestigationDate" ValidationGroup="Notification" InitialValue="" Display="Dynamic" meta:resourceKey="Val_Investigation_Date"></asp:RequiredFieldValidator>
                                                                        <asp:CompareValidator ID="cmvFutureInvestigationDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtInvestigationDate" meta:resourcekey="Val_Future_Investigation_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="Notification" SetFocusOnError="True"></asp:CompareValidator>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                        <fieldset>
                                                            <legend runat="server" meta:resourcekey="Lbl_Data_Entry"></legend>
                                                            <div class="form-group">
                                                                <div class="row">
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                                        <label for="<%= txtSiteName.ClientID %>" runat="server" meta:resourcekey="Lbl_Site"></label>
                                                                        <asp:TextBox ID="txtSiteName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                                        <label for="<%= txtEnteredByPersonName.ClientID %>" runat="server" meta:resourcekey="Lbl_Officer"></label>
                                                                        <asp:TextBox ID="txtEnteredByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                                        <label for="<%= txtEnteredDate.ClientID %>" runat="server" meta:resourcekey="Lbl_Entered_Date"></label>
                                                                        <asp:TextBox ID="txtEnteredDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                    </div>
                                                </div>
                                            </section>
                                            <section id="FarmHerdSpecies" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upFarmHerdSpecies" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Farm_Herd_Species"></h3>
                                                                    </div>
                                                                    <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 text-right">
                                                                        <asp:Button ID="btnAddHerd" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="<%$ Resources: Buttons, Btn_Add_Herd_ToolTip %>" Text="<%$ Resources: Buttons, Btn_Add_Herd_Text %>" />
                                                                    </div>
                                                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(2, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="table-responsive">
                                                                    <eidss:GridView AllowPaging="False" AllowSorting="False" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="HerdMasterID"
                                                                        GridLines="None" ID="gvHerds" runat="server" PagerSettings-Visible="false" ShowFooter="true" UseAccessibleHeader="true">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <Columns>
                                                                            <asp:TemplateField ItemStyle-Width="100%">
                                                                                <HeaderTemplate>
                                                                                    <div class="col-lg-4">
                                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Species_Text") %></label>
                                                                                    </div>
                                                                                    <div class="col-lg-1">
                                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Total_Text") %></label>
                                                                                    </div>
                                                                                    <div class="col-lg-1">
                                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Dead_Text") %></label>
                                                                                    </div>
                                                                                    <div class="col-lg-1">
                                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Sick_Text") %></label>
                                                                                    </div>
                                                                                    <div class="col-lg-2">
                                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Start_Of_Signs_Text") %></label>
                                                                                    </div>
                                                                                    <div class="col-lg-2">
                                                                                        <label><% =GetGlobalResourceObject("Labels", "Lbl_Note_Include_Breed_Text") %></label>
                                                                                    </div>
                                                                                    <div class="col-lg-1"></div>
                                                                                </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <div class="row">
                                                                                        <div class="col-lg-3">
                                                                                            <asp:Label runat="server" ID="lblEIDSSHerdID" CssClass="form-control"></asp:Label>
                                                                                            <asp:HiddenField ID="hdfHerdMasterID" runat="server" Value='<% #Eval("HerdMasterID") %>' />
                                                                                        </div>
                                                                                        <div class="col-lg-1">
                                                                                            <asp:Label runat="server" ID="lblTotalAnimalQuantity" Text='<% #Eval("TotalAnimalQuantity") %>' CssClass="form-control"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-lg-1">
                                                                                            <asp:Label runat="server" ID="lblDeadAnimalQuantity" Text='<% #Eval("DeadAnimalQuantity") %>' CssClass="form-control"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-lg-1">
                                                                                            <asp:Label runat="server" ID="lblSickAnimalQuantity" Text='<% #Eval("SickAnimalQuantity") %>' CssClass="form-control"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-lg-7 text-right">
                                                                                            <asp:LinkButton ID="btnAddSpecies" runat="server" CssClass="btn btn-default btn-sm" CommandName="Update" CommandArgument='<% #Eval("HerdMasterID") %>' CausesValidation="false" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>"></asp:LinkButton>
                                                                                        </div>
                                                                                    </div>
                                                                                    <eidss:GridView ID="gvSpecies" runat="server" AllowPaging="False" AllowSorting="false" AutoGenerateColumns="false" CssClass="table table-striped table-transparent" DataKeyNames="SpeciesMasterID"
                                                                                        GridLines="None" ShowHeader="false" ShowFooter="false" UseAccessibleHeader="false" OnRowDataBound="Species_RowDataBound">
                                                                                        <Columns>
                                                                                            <asp:TemplateField>
                                                                                                <ItemTemplate>
                                                                                                    <asp:UpdatePanel ID="upSpecies" runat="server" UpdateMode="Conditional">
                                                                                                        <Triggers>
                                                                                                            <asp:AsyncPostBackTrigger ControlID="ddlSpeciesTypeID" EventName="SelectedIndexChanged" />
                                                                                                            <asp:AsyncPostBackTrigger ControlID="txtTotalAnimalQuantity" EventName="TextChanged" />
                                                                                                            <asp:AsyncPostBackTrigger ControlID="txtDeadAnimalQuantity" EventName="TextChanged" />
                                                                                                            <asp:AsyncPostBackTrigger ControlID="txtSickAnimalQuantity" EventName="TextChanged" />
                                                                                                            <asp:AsyncPostBackTrigger ControlID="txtStartOfSignsDate" EventName="TextChanged" />
                                                                                                            <asp:AsyncPostBackTrigger ControlID="txtNote" EventName="TextChanged" />
                                                                                                        </Triggers>
                                                                                                        <ContentTemplate>
                                                                                                            <div class="row">
                                                                                                                <div class="col-lg-3">
                                                                                                                    <asp:HiddenField ID="hdfSpeciesMasterID" runat="server" Value='<%# Bind("SpeciesMasterID") %>' />
                                                                                                                    <eidss:DropDownList ID="ddlSpeciesTypeID" runat="server" CssClass="form-control" Height="33" OnSelectedIndexChanged="SpeciesControlEventHandler"></eidss:DropDownList>
                                                                                                                </div>
                                                                                                                <div class="col-lg-1">
                                                                                                                    <eidss:NumericSpinner ID="txtTotalAnimalQuantity" runat="server" CssClass="form-control" Text='<% #Bind("TotalAnimalQuantity") %>' MinValue="0" Height="33" Width="33" OnTextChanged="SpeciesControlEventHandler"></eidss:NumericSpinner>
                                                                                                                    <asp:RequiredFieldValidator ControlToValidate="txtTotalAnimalQuantity" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Total_Animal_Qty" runat="server" ValidationGroup="FarmHerdSpeciesSection"></asp:RequiredFieldValidator>
                                                                                                                </div>
                                                                                                                <div class="col-lg-1">
                                                                                                                    <eidss:NumericSpinner ID="txtDeadAnimalQuantity" runat="server" CssClass="form-control" Text='<% #Bind("DeadAnimalQuantity") %>' MinValue="0" Height="33" Width="33" OnTextChanged="SpeciesControlEventHandler"></eidss:NumericSpinner>
                                                                                                                    <asp:RequiredFieldValidator ControlToValidate="txtDeadAnimalQuantity" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Dead_Animal_Qty" runat="server" ValidationGroup="FarmHerdSpeciesSection"></asp:RequiredFieldValidator>
                                                                                                                </div>
                                                                                                                <div class="col-lg-1">
                                                                                                                    <eidss:NumericSpinner ID="txtSickAnimalQuantity" runat="server" CssClass="form-control" Text='<% #Bind("SickAnimalQuantity") %>' MinValue="0" Height="33" Width="33" OnTextChanged="SpeciesControlEventHandler"></eidss:NumericSpinner>
                                                                                                                    <asp:RequiredFieldValidator ControlToValidate="txtSickAnimalQuantity" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Sick_Animal_Qty" runat="server" ValidationGroup="FarmHerdSpeciesSection"></asp:RequiredFieldValidator>
                                                                                                                </div>
                                                                                                                <div class="col-lg-3">
                                                                                                                    <asp:UpdatePanel ID="upStartOfSignsDate" runat="server" UpdateMode="Conditional">
                                                                                                                        <ContentTemplate>
                                                                                                                            <eidss:CalendarInput ID="txtStartOfSignsDate" runat="server" CssClass="form-control" ContainerCssClass="input-group datepicker" Text='<% #Bind("StartOfSignsDate") %>' Height="33" OnTextChanged="SpeciesControlEventHandler"></eidss:CalendarInput>
                                                                                                                            <asp:RequiredFieldValidator ControlToValidate="txtStartOfSignsDate" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Start_of_Signs_Date" runat="server" ValidationGroup="FarmHerdSpeciesSection"></asp:RequiredFieldValidator>
                                                                                                                            <asp:CompareValidator ID="cmvFutureStartOfSignsDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtStartOfSignsDate" meta:resourcekey="Val_Future_Start_Of_Signs_Date" Operator="LessThanEqual" ValidationGroup="FarmHerdSpeciesSection" SetFocusOnError="True"></asp:CompareValidator>
                                                                                                                        </ContentTemplate>
                                                                                                                    </asp:UpdatePanel>
                                                                                                                </div>
                                                                                                                <div class="col-lg-2">
                                                                                                                    <asp:TextBox ID="txtNote" runat="server" CssClass="form-control" Text='<% #Bind("Note") %>' MaxLength="2000" OnTextChanged="SpeciesControlEventHandler"></asp:TextBox>
                                                                                                                    <asp:RequiredFieldValidator ControlToValidate="txtNote" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Species_Note" runat="server" ValidationGroup="FarmHerdSpeciesSection"></asp:RequiredFieldValidator>
                                                                                                                </div>
                                                                                                                <div class="col-lg-1">
                                                                                                                    <asp:LinkButton ID="btnDeleteSpecies" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<%# Bind("SpeciesMasterID") %>' CausesValidation="false"></asp:LinkButton>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                        </ContentTemplate>
                                                                                                    </asp:UpdatePanel>
                                                                                                </ItemTemplate>
                                                                                            </asp:TemplateField>
                                                                                        </Columns>
                                                                                    </eidss:GridView>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                            <section id="FarmEpidemiologicalInfo" runat="server" class="col-md-12 hidden">
                                                <div class="panel panel-default">
                                                    <div class="panel-heading">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-5">
                                                                <h3 runat="server" meta:resourcekey="Hdg_Farm_Epidemiological_Info"></h3>
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 pull-right">
                                                                <input type="submit" id="btnClearFarmEpidemiologicalInfo" runat="server" class="btn btn-primary btn-sm" value="<%$ Resources: Buttons, Btn_Clear_Text %>" title="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" />
                                                                <a href="#" class="btn glyphicon glyphicon-edit hidden pull-right" onclick="goToSideBarSection(3, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="panel-body">
                                                        <div class="form-group">
                                                            <asp:UpdatePanel ID="upFarmEpidemiologicalInfo" runat="server" UpdateMode="Conditional">
                                                                <ContentTemplate>
                                                                    <eidss:FlexForm runat="server" ID="ucFarmEpidemiologicalInfo" LegendHeader="" FormType="10034015" />
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </div>
                                                    </div>
                                                </div>
                                            </section>
                                            <section id="SpeciesClinicalInvestigation" runat="server" class="col-md-12 hidden">
                                                <div class="panel panel-default">
                                                    <div class="panel-heading">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-5">
                                                                <h3 runat="server" meta:resourcekey="Hdg_Species_Investigation"></h3>
                                                            </div>
                                                            <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 pull-right">
                                                                <asp:Button ID="btnClearSpeciesInvestigation" runat="server" Enabled="false" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
                                                                <asp:Button ID="btnCopySpeciesInvestigation" runat="server" Enabled="False" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Copy_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Copy_ToolTip %>" CausesValidation="false" />
                                                                <asp:Button ID="btnPasteSpeciesInvestigation" runat="server" Enabled="false" CssClass="btn btn-default btn-sm" Text="<%$ Resources: Buttons, Btn_Paste_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Paste_ToolTip %>" CausesValidation="false" />

                                                                <a href="#" class="btn glyphicon glyphicon-edit hidden pull-right" onclick="goToSideBarSection(4, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="panel-body">
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                    <asp:Label AssociatedControlID="ddlSpeciesClinicalInvestigationSpeciesID" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                                                    <eidss:DropDownList CssClass="form-control" ID="ddlSpeciesClinicalInvestigationSpeciesID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                                                </div>
                                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                                                    <asp:LinkButton ID="btnEditSpeciesClinicalInvestigation" runat="server" CommandName="Edit" CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                    <asp:LinkButton ID="btnDeleteSpeciesClinicalInvestigation" runat="server" CommandName="Delete" CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <asp:UpdatePanel ID="upSpeciesClinicalInvestigation" runat="server" UpdateMode="Conditional">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="ddlSpeciesClinicalInvestigationSpeciesID" EventName="SelectedIndexChanged" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <eidss:FlexForm runat="server" ID="ucSpeciesClinicalInvestigation" LegendHeader="" FormType="10034016" />
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </div>
                                                    </div>
                                                </div>
                                            </section>
                                            <section id="VaccinationInformation" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upVaccinations" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnAddVaccination" EventName="Click" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Vaccination_Information"></h3>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                                        <asp:Button ID="btnAddVaccination" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(5, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="table-responsive">
                                                                    <eidss:GridView ID="gvVaccinations" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="VaccinationID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowFooter="True" ShowHeader="true" ShowHeaderWhenEmpty="true" GridLines="None">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="DiseaseName" HeaderText="<%$ Resources: Grd_Vaccinations_List_Disease_Heading %>" />
                                                                            <asp:BoundField DataField="VaccinationDate" HeaderText="<%$ Resources: Grd_Vaccinations_List_Date_Heading %>" DataFormatString="{0:d}" />
                                                                            <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Vaccinations_List_Species_Heading %>" />
                                                                            <asp:BoundField DataField="NumberVaccinated" HeaderText="<%$ Resources: Grd_Vaccinations_List_Number_Vaccinated_Heading %>" />
                                                                            <asp:BoundField DataField="VaccinationTypeName" HeaderText="<%$ Resources: Grd_Vaccinations_List_Vaccination_Type_Heading %>" DataFormatString="{0:d}" />
                                                                            <asp:BoundField DataField="VaccinationRouteTypeName" HeaderText="<%$ Resources: Grd_Vaccinations_List_Vaccination_Route_Heading %>" DataFormatString="{0:d}" />
                                                                            <asp:BoundField DataField="LotNumber" HeaderText="<%$ Resources: Grd_Samples_List_Vaccinations_Lot_Number_Heading %>" meta:resourcekey="Dis_Lot_Number" />
                                                                            <asp:BoundField DataField="Manufacturer" HeaderText="<%$ Resources: Grd_Vaccinations_List_Manufacturer_Heading %>" meta:resourcekey="Dis_Manufacturer" />
                                                                            <asp:BoundField DataField="Comments" HeaderText="<%$ Resources: Grd_Vaccinations_List_Comment_Heading %>" meta:resourcekey="Dis_Vaccination_Comment" />
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnEditVaccination" runat="server" CommandName="Edit" CommandArgument='<% #Bind("VaccinationID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteVaccination" runat="server" CommandName="Delete" CommandArgument='<% #Bind("VaccinationID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                            <section id="ControlMeasures" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upControlMeasures" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Control_Measures"></h3>
                                                                    </div>
                                                                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(6, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="form-group">
                                                                    <eidss:FlexForm runat="server" ID="ucControlMeasures" LegendHeader="" FormType="10034014" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                            <section id="Animals" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upAnimals" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnAddAnimal" EventName="Click" />
                                                        <asp:AsyncPostBackTrigger ControlID="radClinicalSignsYes" EventName="CheckedChanged" />
                                                        <asp:AsyncPostBackTrigger ControlID="radClinicalSignsNo" EventName="CheckedChanged" />
                                                        <asp:AsyncPostBackTrigger ControlID="radClinicalSignsUnknown" EventName="CheckedChanged" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-9 col-md-9 col-sm-8 col-xs-7">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Animals"></h3>
                                                                    </div>
                                                                    <div class="col-lg-3 col-md-3 col-sm-4 col-xs-5 text-right">
                                                                        <asp:Button ID="btnAddAnimal" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(7, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="table-responsive">
                                                                    <eidss:GridView ID="gvAnimals" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="AnimalID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="EIDSSHerdID" HeaderText="<%$ Resources: Grd_Animals_List_Herd_ID_Heading %>" />
                                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Grd_Animals_List_Animal_ID_Heading %>" />
                                                                            <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Animals_List_Species_Heading %>" />
                                                                            <asp:BoundField DataField="AnimalAgeTypeName" HeaderText="<%$ Resources: Grd_Animals_List_Age_Heading %>" />
                                                                            <asp:BoundField DataField="AnimalGenderTypeName" HeaderText="<%$ Resources: Grd_Animals_List_Gender_Heading %>" />
                                                                            <asp:BoundField DataField="AnimalConditionTypeName" HeaderText="<%$ Resources: Grd_Animals_List_Status_Heading %>" />
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnEditAnimal" runat="server" CommandName="Edit" CommandArgument='<% #Bind("AnimalID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteAnimal" runat="server" CommandName="Delete" CommandArgument='<% #Bind("AnimalID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                            <section id="Samples" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upSamples" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnAddSample" EventName="Click" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Samples"></h3>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                                        <asp:Button ID="btnAddSample" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(8, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="form-group">
                                                                    <div class="row">
                                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                                                            <asp:CheckBox ID="chkFilterByDisease" runat="server" meta:resourceKey="Lbl_Filter_By_Disease" CssClass="checkbox-inline" Enabled="false" AutoPostBack="true" />
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="table-responsive">
                                                                    <eidss:GridView ID="gvSamples" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="SampleID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Samples_List_Sample_Type_Heading %>" />
                                                                            <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText="<%$ Resources: Grd_Samples_List_Field_Sample_ID_Heading %>" />
                                                                            <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Samples_List_Species_Heading %>" />
                                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Grd_Samples_List_Animal_Heading %>" />
                                                                            <asp:BoundField DataField="CollectionDate" HeaderText="<%$ Resources: Grd_Samples_List_Collection_Date_Heading %>" DataFormatString="{0:d}" />
                                                                            <asp:BoundField DataField="AccessionDate" HeaderText="<%$ Resources: Grd_Samples_List_Accession_Date_Heading %>" DataFormatString="{0:d}" meta:resourcekey="Dis_Accession_Date" />
                                                                            <asp:BoundField DataField="AccessionConditionTypeName" HeaderText="<%$ Resources: Grd_Samples_List_Sample_Condition_Received_Heading %>" meta:resourcekey="Dis_Condition_Received" />
                                                                            <asp:BoundField DataField="AccessionComment" HeaderText="<%$ Resources: Grd_Samples_List_Field_Comment_Heading %>" meta:resourcekey="Dis_Sample_Comment" />
                                                                            <asp:BoundField DataField="CollectedByOrganizationName" HeaderText="<%$ Resources: Grd_Samples_List_Field_Collected_By_Institution_Heading %>" meta:resourcekey="Dis_Collected_By_Institution" />
                                                                            <asp:BoundField DataField="CollectedByPersonName" HeaderText="<%$ Resources: Grd_Samples_List_Field_Collected_By_Officer_Heading %>" meta:resourcekey="Dis_Collected_By_Officer" />
                                                                            <asp:BoundField DataField="SentToOrganizationName" HeaderText="<%$ Resources: Grd_Samples_List_Field_Sent_To_Organization_Heading %>" meta:resourcekey="Dis_Sent_To_Organization" />
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnEditSample" runat="server" CommandName="Edit" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteSample" runat="server" CommandName="Delete" CommandArgument='<% #Bind("SampleID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField>
                                                                                <ItemTemplate>
                                                                                    <span class="glyphicon glyphicon-triangle-bottom" onclick="showSampleSubGrid(event,'div<%# Eval("SampleID") %>');"></span>
                                                                                    <tr id="div<%# Eval("SampleID") %>" style="display: none;">
                                                                                        <td colspan="11" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                                                            <div>
                                                                                                <asp:Label ID="lblAliquotPlaceholder" CssClass="col-lg-2 col-md-2 col-sm-3 col-xs-6 control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Aliqouts_Derivatives_Text %>" />
                                                                                                <br />
                                                                                                <eidss:GridView ID="gvAliquotsDerivatives" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="SampleID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                                                    <HeaderStyle CssClass="table-striped-header" />
                                                                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                                                    <Columns>
                                                                                                        <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Aliquots_List_Sample_Type_Heading %>" />
                                                                                                        <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Grd_Aliquots_List_Lab_Sample_ID_Heading %>" />
                                                                                                        <asp:BoundField DataField="SampleStatusTypeName" HeaderText="<%$ Resources: Grd_Aliquots_List_Status_Heading %>" />
                                                                                                        <asp:BoundField DataField="CollectedByOrganizationName" HeaderText="<%$ Resources: Grd_Aliquots_List_Lab_Heading %>" />
                                                                                                        <asp:BoundField DataField="SentToOrganizationName" HeaderText="<%$ Resources: Grd_Aliquots_List_Field_Functional_Lab_Heading %>" />
                                                                                                    </Columns>
                                                                                                </eidss:GridView>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                            <section id="PensideTests" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upPensideTests" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnAddPensideTest" EventName="Click" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Penside_Tests"></h3>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                                        <asp:Button ID="btnAddPensideTest" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(9, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="table-responsive">
                                                                    <eidss:GridView ID="gvPensideTests" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="PensideTestID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="PensideTestNameTypeName" HeaderText="<%$ Resources: Grd_Penside_Tests_List_Test_Name_Heading %>" />
                                                                            <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText="<%$ Resources: Grd_Penside_Tests_List_Field_Sample_ID_Heading %>" />
                                                                            <asp:BoundField DataField="SpeciesTypeName" HeaderText="<%$ Resources: Grd_Penside_Tests_List_Species_Heading %>" />
                                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Grd_Penside_Tests_List_Animal_Heading %>" />
                                                                            <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Penside_Tests_List_Sample_Type_Heading %>" />
                                                                            <asp:BoundField DataField="PensideTestResultTypeName" HeaderText="<%$ Resources: Grd_Penside_Tests_List_Test_Result_Heading %>" DataFormatString="{0:d}" />
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnEditPensideTest" runat="server" CommandName="Edit" CommandArgument='<% #Bind("PensideTestID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnDeletePensideTest" runat="server" CommandName="Delete" CommandArgument='<% #Bind("PensideTestID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                            <section id="TestsAndTestInterpretations" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upTestsAndTestInterpretations" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnAddLabTest" EventName="Click" />
                                                        <asp:AsyncPostBackTrigger ControlID="rdbLabTestConductedYes" EventName="CheckedChanged" />
                                                        <asp:AsyncPostBackTrigger ControlID="rdbLabTestConductedNo" EventName="CheckedChanged" />
                                                        <asp:AsyncPostBackTrigger ControlID="rdbLabTestConductedUnknown" EventName="CheckedChanged" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Lab_Tests_Interpretation"></h3>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                                        <asp:Button ID="btnAddLabTest" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(10, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="form-group">
                                                                    <div class="row">
                                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                            <label runat="server" meta:resourcekey="Lbl_Tests_Conducted"></label>
                                                                            <div class="btn btn-group">
                                                                                <asp:RadioButton ID="rdbLabTestConductedYes" runat="server" CssClass="radio-inline" GroupName="TestConducted" meta:resourceKey="Lbl_Yes" AutoPostBack="true" />
                                                                                <asp:RadioButton ID="rdbLabTestConductedNo" runat="server" CssClass="radio-inline" GroupName="TestConducted" meta:resourceKey="Lbl_No" AutoPostBack="true" />
                                                                                <asp:RadioButton ID="rdbLabTestConductedUnknown" runat="server" CssClass="radio-inline" GroupName="TestConducted" meta:resourceKey="Lbl_Unknown" AutoPostBack="true" />
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="table-responsive">
                                                                    <eidss:GridView ID="gvLabTests" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="TestID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Field_Sample_ID_Heading %>" meta:resourcekey="Dis_Lab_Test_Field_Sample_ID" />
                                                                            <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Lab_Sample_ID_Heading %>" meta:resourcekey="Dis_Lab_Sample_ID" />
                                                                            <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Sample_Type_Heading %>" meta:resourcekey="Dis_Lab_Test_Sample_Type" />
                                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Animal_Heading %>" meta:resourcekey="Dis_Lab_Test_Animal" />
                                                                            <asp:BoundField DataField="DiseaseName" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Disease_Heading %>" meta:resourcekey="Dis_Lab_Test_Test_Disease" />
                                                                            <asp:BoundField DataField="TestNameTypeName" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Test_Name_Heading %>" meta:resourcekey="Dis_Lab_Test_Test_Name" />
                                                                            <asp:BoundField DataField="TestStatusTypeName" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Test_Status_Heading %>" meta:resourcekey="Dis_Lab_Test_Test_Status" />
                                                                            <asp:BoundField DataField="TestCategoryTypeName" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Test_Category_Heading %>" meta:resourcekey="Dis_Lab_Test_Test_Category" />
                                                                            <asp:BoundField DataField="ResultDate" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Result_Date_Heading %>" DataFormatString="{0:d}" meta:resourcekey="Dis_Result_Date" />
                                                                            <asp:BoundField DataField="TestResultTypeName" HeaderText="<%$ Resources: Grd_Lab_Tests_List_Result_Observation_Heading %>" meta:resourcekey="Dis_Result_Observation" />
                                                                            <asp:TemplateField>
                                                                                <ItemTemplate>
                                                                                    <div class="divDetailsContainer" style="white-space: nowrap; vertical-align: top;">
                                                                                        <asp:UpdatePanel ID="upTestInterpretation" runat="server" UpdateMode="Conditional">
                                                                                            <Triggers>
                                                                                                <asp:AsyncPostBackTrigger ControlID="btnAddTestInterpretation" EventName="Click" />
                                                                                            </Triggers>
                                                                                            <ContentTemplate>
                                                                                                <asp:Button ID="btnAddTestInterpretation" runat="server" CommandName="New Interpretation" CommandArgument='<% #Bind("TestID") %>' CausesValidation="False" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" />
                                                                                            </ContentTemplate>
                                                                                        </asp:UpdatePanel>
                                                                                    </div>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnEditLabTest" runat="server" CommandName="Edit" CommandArgument='<% #Bind("TestID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteLabTest" runat="server" CommandName="Delete" CommandArgument='<% #Bind("TestID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Interpretation"></h3>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="table-responsive">
                                                                    <eidss:GridView ID="gvTestInterpretations" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="TestInterpretationID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="EIDSSAnimalID" HeaderText="<%$ Resources: Grd_Interpretations_List_Animal_Heading %>" />
                                                                            <asp:BoundField DataField="DiseaseName" HeaderText="<%$ Resources: Grd_Interpretations_List_Disease_Heading %>" meta:resourcekey="Dis_Lab_Test_Test_Disease" />
                                                                            <asp:BoundField DataField="TestNameTypeName" HeaderText="<%$ Resources: Grd_Interpretations_List_Test_Name_Heading %>" meta:resourcekey="Dis_Lab_Test_Test_Name" />
                                                                            <asp:BoundField DataField="TestResultTypeName" HeaderText="<%$ Resources: Grd_Interpretations_List_Test_Result_Heading %>" />
                                                                            <asp:BoundField DataField="TestCategoryTypeName" HeaderText="<%$ Resources: Grd_Interpretations_List_Test_Category_Heading %>" meta:resourcekey="Dis_Lab_Test_Test_Category" />
                                                                            <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText="<%$ Resources: Grd_Interpretations_List_Lab_Sample_ID_Heading %>" meta:resourcekey="Dis_Lab_Sample_ID" />
                                                                            <asp:BoundField DataField="SampleTypeName" HeaderText="<%$ Resources: Grd_Interpretations_List_Sample_Type_Heading %>" meta:resourcekey="Dis_Lab_Test_Sample_Type" />
                                                                            <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText="<%$ Resources: Grd_Interpretations_List_Field_Sample_ID_Heading %>" meta:resourcekey="Dis_Lab_Test_Field_Sample_ID" />
                                                                            <asp:BoundField DataField="InterpretedStatusTypeName" HeaderText="<%$ Resources: Grd_Interpretations_List_Rule_Out_Rule_In_Heading %>" />
                                                                            <asp:BoundField DataField="InterpretedComment" HeaderText="<%$ Resources: Grd_Interpretations_List_Interpreted_Comment_Heading %>" />
                                                                            <asp:BoundField DataField="ValidatedStatusIndicator" HeaderText="<%$ Resources: Grd_Interpretations_List_Validated_Heading %>" />
                                                                            <asp:BoundField DataField="ValidatedComment" HeaderText="<%$ Resources: Grd_Interpretations_List_Validated_Comment_Heading %>" />
                                                                            <asp:BoundField DataField="ValidatedDate" HeaderText="<%$ Resources: Grd_Interpretations_List_Date_Validated_Heading %>" DataFormatString="{0:d}" />
                                                                            <asp:BoundField DataField="ValidatedByPersonName" HeaderText="<%$ Resources: Grd_Interpretations_List_Validated_By_Heading %>" />
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnEditTestInterpretation" runat="server" CommandName="Edit" CommandArgument='<% #Bind("TestInterpretationID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteTestInterpretation" runat="server" CommandName="Delete" CommandArgument='<% #Bind("TestInterpretationID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                            <section id="ReportLog" runat="server" class="col-md-12 hidden">
                                                <asp:UpdatePanel ID="upReportLogs" runat="server" UpdateMode="Conditional">
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="btnAddReportLog" EventName="Click" />
                                                    </Triggers>
                                                    <ContentTemplate>
                                                        <div class="panel panel-default">
                                                            <div class="panel-heading">
                                                                <div class="row">
                                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                                        <h3 runat="server" meta:resourcekey="Hdg_Case_Log"></h3>
                                                                    </div>
                                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                                        <asp:Button ID="btnAddReportLog" runat="server" CssClass="btn btn-primary btn-sm" Text="<%$ Resources: Buttons, Btn_Add_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Add_ToolTip %>" CausesValidation="false" />
                                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(11, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="panel-body">
                                                                <div class="table-responsive">
                                                                    <eidss:GridView ID="gvReportLogs" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="VeterinaryDiseaseReportLogID" EmptyDataText="<%$ Resources: Labels, Lbl_No_Results_Found_Text %>" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
                                                                        <HeaderStyle CssClass="table-striped-header" />
                                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                        <Columns>
                                                                            <asp:BoundField DataField="ActionRequired" HeaderText="<%$ Resources: Grd_Case_Log_List_Action_Required_Heading %>" />
                                                                            <asp:BoundField DataField="LogDate" HeaderText="<%$ Resources: Grd_Case_Log_List_Date_Heading %>" DataFormatString="{0:d}" />
                                                                            <asp:BoundField DataField="PersonName" HeaderText="<%$ Resources: Grd_Case_Log_List_Entered_By_Heading %>" />
                                                                            <asp:BoundField DataField="Comments" HeaderText="<%$ Resources: Grd_Case_Log_List_Comment_Heading %>" />
                                                                            <asp:BoundField DataField="LogStatusTypeName" HeaderText="<%$ Resources: Grd_Case_Log_List_Status_Heading %>" />
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnEditReportLog" runat="server" CommandName="Edit" CommandArgument='<% #Bind("VeterinaryDiseaseReportLogID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="btnDeleteReportLog" runat="server" CommandName="Delete" CommandArgument='<% #Bind("VeterinaryDiseaseReportLogID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </eidss:GridView>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </section>
                                        </div>
                                        <eidss:SideBarNavigation ID="DiseaseReportSideBar" runat="server">
                                            <MenuItems>
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="0, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiFarmDetails" ItemStatus="IsNormal" meta:resourceKey="Tab_Farm_Details" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="1, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiNotification" ItemStatus="IsNormal" meta:resourceKey="Tab_Notification" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="2, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiFarmHerdSpecies" ItemStatus="IsNormal" meta:resourceKey="Tab_Farm_Herd_Species" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="3, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiFarmEpidemiologicalInfo" ItemStatus="IsNormal" meta:resourceKey="Tab_Farm_Epidemiological_Info" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="4, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiSpeciesInvestigation" ItemStatus="IsNormal" meta:resourceKey="Tab_Species_Clinical_Investigation" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="5, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiVaccinationInformation" ItemStatus="IsNormal" meta:resourceKey="Tab_Vaccination_Information" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="6, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiControlMeasures" ItemStatus="IsNormal" meta:resourceKey="Tab_Control_Measures" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="7, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiAnimals" ItemStatus="IsNormal" meta:resourceKey="Tab_Animals" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="8, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiSamples" ItemStatus="IsNormal" meta:resourceKey="Tab_Samples" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="9, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiPensideTests" ItemStatus="IsNormal" meta:resourceKey="Tab_Penside_Tests" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="10, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiLabTestsInterpretation" ItemStatus="IsNormal" meta:resourceKey="Tab_Lab_Tests_Interpretation" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="11, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiCaseLog" ItemStatus="IsNormal" meta:resourceKey="Tab_Case_Log" runat="server" />
                                                <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToSideBarSection="12, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')" ID="sbiReview" ItemStatus="IsReview" meta:resourceKey="Tab_Review" runat="server" />
                                            </MenuItems>
                                        </eidss:SideBarNavigation>
                                        <div class="sectionContainer text-center">
                                            <asp:UpdatePanel ID="upDiseaseReportCommands" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Button ID="btnCancelVeterinaryDiseaseReport" CssClass="btn btn-default" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                                    <asp:Button ID="btnPrintVeterinaryDiseaseReport" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Print_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Print_ToolTip %>" CausesValidation="false" Visible="False" />
                                                    <asp:Button ID="btnPreviousSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Previous_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Previous_ToolTip %>" CausesValidation="false" OnClientClick="goToPreviousSection(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;" UseSubmitBehavior="False" />
                                                    <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" OnClientClick="goToNextSection(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;" UseSubmitBehavior="False" />
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" ValidationGroup="DiseaseReport" />
                                                    <asp:Button ID="btnDelete" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Delete_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Delete_ToolTip %>" runat="server" CausesValidation="false" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divVaccinationModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divVaccinationModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divVaccinationModal')">&times;</button>
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Vaccination_Information"></h4>
            </div>
            <asp:UpdatePanel ID="upVaccinationModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnVaccinationSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnVaccinationCancel" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div id="divVaccinationForm" class="modal-body">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vaccination_Disease" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vaccination_Disease" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlVaccinationDiseaseID" CssClass="control-label" meta:resourcekey="Lbl_Disease" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlVaccinationDiseaseID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlVaccinationDiseaseID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vaccination_Disease" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vaccination_Date" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vaccination_Date" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtVaccinationVaccinationDate" CssClass="control-label" meta:resourcekey="Lbl_Date" runat="server"></asp:Label>
                                    <eidss:CalendarInput ID="txtVaccinationVaccinationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    <asp:CompareValidator ID="cmvFutureVaccinationDate" runat="server" CssClass="alert-danger" Display="Dynamic" ControlToValidate="txtVaccinationVaccinationDate" meta:resourcekey="Val_Future_Vaccination_Date" Operator="LessThanEqual" Type="Date" ValidationGroup="VaccinationsSection" SetFocusOnError="True"></asp:CompareValidator>
                                    <asp:RequiredFieldValidator ControlToValidate="txtVaccinationVaccinationDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Vaccination_Date" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vaccination_Species" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vaccination_Species" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlVaccinationSpeciesID" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlVaccinationSpeciesID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlVaccinationSpeciesID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vaccination_Species" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Number_Vaccinated" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Number_Vaccinated" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtVaccinationNumberVaccinated" CssClass="control-label" meta:resourcekey="Lbl_Number_Vaccinated" runat="server"></asp:Label>
                                    <eidss:NumericSpinner ID="txtVaccinationNumberVaccinated" runat="server" CssClass="form-control" MaxLength="6" MinValue="0" MaxValue="999999"></eidss:NumericSpinner>
                                    <asp:RequiredFieldValidator ControlToValidate="txtVaccinationNumberVaccinated" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Number_Vaccinated" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vaccination_Type" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vaccination_Type" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlVaccinationVaccinationTypeID" CssClass="control-label" meta:resourcekey="Lbl_Vaccination_Type" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlVaccinationVaccinationTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlVaccinationVaccinationTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vaccination_Type" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vaccination_Route" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vaccination_Route" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlVaccinationVaccinationRouteTypeID" CssClass="control-label" meta:resourcekey="Lbl_Vaccination_Route" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlVaccinationVaccinationRouteTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlVaccinationVaccinationRouteTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vaccination_Route" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Lot_Number" runat="server">
                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lot_Number" runat="server"></div>
                                        <asp:Label AssociatedControlID="txtVaccinationLotNumber" CssClass="control-label" meta:resourcekey="Lbl_Lot_Number" runat="server"></asp:Label>
                                        <asp:TextBox ID="txtVaccinationLotNumber" runat="server" CssClass="form-control" MaxLength="200" Enabled="false"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtVaccinationLotNumber" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Lot_Number" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Manufacturer" runat="server">
                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Manufacturer" runat="server"></div>
                                        <asp:Label AssociatedControlID="txtVaccinationManufacturer" CssClass="control-label" meta:resourcekey="Lbl_Manufacturer" runat="server"></asp:Label>
                                        <asp:TextBox ID="txtVaccinationManufacturer" runat="server" CssClass="form-control" MaxLength="200" Enabled="false"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtVaccinationManufacturer" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Manufacturer" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" meta:resourcekey="Dis_Vaccination_Comment" runat="server">
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vaccination_Comment" runat="server"></div>
                                <asp:Label AssociatedControlID="txtVaccinationComments" CssClass="control-label" meta:resourcekey="Lbl_Comment" runat="server"></asp:Label>
                                <asp:TextBox ID="txtVaccinationComments" runat="server" CssClass="form-control" MaxLength="2000" Enabled="false"></asp:TextBox>
                                <asp:RequiredFieldValidator ControlToValidate="txtVaccinationComments" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Vaccination_Comment" runat="server" ValidationGroup="VaccinationsSection"></asp:RequiredFieldValidator>
                            </div>
                            <div class="modal-footer text-center">
                                <asp:Button ID="btnVaccinationSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="VaccinationsSection" />
                                <asp:Button ID="btnVaccinationCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                            </div>
                        </div>

                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divAnimalModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divAnimalModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divAnimalModal')">&times;</button>
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Animals"></h4>
            </div>
            <asp:UpdatePanel ID="upAnimalModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAnimalSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnAnimalCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="ddlAnimalHerdID" EventName="SelectedIndexChanged" />
                </Triggers>
                <ContentTemplate>
                    <div id="divAnimalForm" class="modal-body" runat="server">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Animal_Herd_ID" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Animal_Herd_ID" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlAnimalHerdID" CssClass="control-label" meta:resourcekey="Lbl_Herd_ID" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAnimalHerdID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAnimalHerdID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Animal_Herd_ID" runat="server" ValidationGroup="AnimalsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Animal_Species" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Animal_Species" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlAnimalSpeciesID" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAnimalSpeciesID" runat="server" Enabled="false"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAnimalSpeciesID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Animal_Species" runat="server" ValidationGroup="AnimalsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Animal_Name" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Animal_Name" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtAnimalName" CssClass="control-label" meta:resourcekey="Lbl_Animal_Name" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtAnimalName" runat="server" MaxLength="200" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtAnimalName" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Animal_Name" runat="server" ValidationGroup="AnimalsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Animal_Age" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Animal_Age" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlAnimalAgeTypeID" CssClass="control-label" meta:resourcekey="Lbl_Animal_Age" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAnimalAgeTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAnimalAgeTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Animal_Age" runat="server" ValidationGroup="AnimalsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Animal_Gender" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Animal_Gender" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlAnimalGenderTypeID" CssClass="control-label" meta:resourcekey="Lbl_Animal_Gender" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAnimalGenderTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAnimalGenderTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Animal_Gender" runat="server" ValidationGroup="AnimalsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Animal_Condition" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Animal_Condition" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlAnimalConditionTypeID" CssClass="control-label" meta:resourcekey="Lbl_Animal_Condition" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlAnimalConditionTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlAnimalConditionTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Animal_Condition" runat="server" ValidationGroup="AnimalsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <label runat="server" meta:resourcekey="Lbl_Clinical_Signs_For_Animal"></label>
                                    <div class="btn btn-group">
                                        <asp:RadioButton ID="radClinicalSignsYes" runat="server" CssClass="radio-inline" GroupName="ClinicalSigns" meta:resourceKey="Lbl_Yes" AutoPostBack="true" />
                                        <asp:RadioButton ID="radClinicalSignsNo" runat="server" CssClass="radio-inline" GroupName="ClinicalSigns" meta:resourceKey="Lbl_No" AutoPostBack="true" />
                                        <asp:RadioButton ID="radClinicalSignsUnknown" runat="server" CssClass="radio-inline" GroupName="ClinicalSigns" meta:resourceKey="Lbl_Unknown" AutoPostBack="true" />
                                    </div>
                                </div>
                            </div>
                            <eidss:FlexForm runat="server" ID="ucClinicalSigns" LegendHeader="" FormType="10034013" />
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnAnimalSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CssClass="btn btn-primary" ValidationGroup="AnimalsSection" />
                            <asp:Button ID="btnAnimalCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divSampleModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divSampleModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divSampleModal')">&times;</button>
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Samples"></h4>
            </div>
            <asp:UpdatePanel ID="upSampleModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnSampleSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnSampleCancel" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div id="divSampleForm" class="modal-body" runat="server">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Sample_Type" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Type" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlSampleSampleTypeID" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleSampleTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Field_Sample_ID" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Field_Sample_ID" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtSampleEIDSSLocalOrFieldSampleID" CssClass="control-label" meta:resourcekey="Lbl_Field_Sample_ID" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtSampleEIDSSLocalOrFieldSampleID" runat="server" MaxLength="200" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleEIDSSLocalOrFieldSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Field_Sample_ID" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Sample_Species" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Species" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlSampleSpeciesID" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleSpeciesID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleSpeciesID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Species" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Sample_Animal" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Animal" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlSampleAnimalID" CssClass="control-label" meta:resourcekey="Lbl_Animal_ID" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlSampleAnimalID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleAnimalID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Animal" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Collection_Date" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collection_Date" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtSampleCollectionDate" CssClass="control-label" meta:resourcekey="Lbl_Collection_Date" runat="server"></asp:Label>
                                    <eidss:CalendarInput ID="txtSampleCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" UseCurrent="False"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Collection_Date" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Accession_Date" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Accession_Date" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtSampleAccessionDate" CssClass="control-label" meta:resourcekey="Lbl_Accession_Date" runat="server"></asp:Label>
                                    <eidss:CalendarInput ID="txtSampleAccessionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleAccessionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Accession_Date" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Condition_Received" runat="server">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Condition_Received" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtSampleAccessionComment" CssClass="control-label" meta:resourcekey="Lbl_Condition_Received" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtSampleAccessionComment" runat="server" CssClass="form-control" MaxLength="200" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleAccessionComment" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Condition_Received" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Sample_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Comment" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtSampleComments" CssClass="control-label" meta:resourcekey="Lbl_Comment" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtSampleComments" runat="server" CssClass="form-control" MaxLength="500" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtSampleComments" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Sample_Comment" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Collected_By_Institution" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collected_By_Institution" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlSampleCollectedByOrganizationID" CssClass="control-label" meta:resourcekey="Lbl_Collected_By_Institution" runat="server"></asp:Label>
                                    <eidss:DropDownList ID="ddlSampleCollectedByOrganizationID" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Collected_By_Officer" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collected_By_Officer" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlSampleCollectedByPersonID" CssClass="control-label" meta:resourcekey="Lbl_Collected_By_Officer" runat="server"></asp:Label>
                                    <eidss:DropDownList ID="ddlSampleCollectedByPersonID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlSampleCollectedByPersonID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Collected_By_Officer" runat="server" ValidationGroup="SamplesSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Sent_To_Organization" runat="server">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sent_To_Organization" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlSampleSentToOrganizationID" CssClass="control-label" meta:resourcekey="Lbl_Sent_To_Organization" runat="server"></asp:Label>
                                    <eidss:DropDownList ID="ddlSampleSentToOrganizationID" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnSampleSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="SamplesSection" />
                            <asp:Button ID="btnSampleCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divPensideTestModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divPensideTestModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divPensideTestModal')">&times;</button>
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Penside_Tests"></h4>
            </div>
            <asp:UpdatePanel ID="upPensideTestModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnPensideTestSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnPensideTestCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="ddlPensideTestSampleID" EventName="SelectedIndexChanged" />
                </Triggers>
                <ContentTemplate>
                    <div id="divPensideTestForm" class="modal-body" runat="server">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Penside_Test_Test_Name" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Penside_Test_Test_Name" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlPensideTestPensideTestNameTypeID" CssClass="control-label" meta:resourcekey="Lbl_Test_Name" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlPensideTestPensideTestNameTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlPensideTestPensideTestNameTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Penside_Test_Test_Name" runat="server" ValidationGroup="PensideTestsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Penside_Test_Field_Sample_ID" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Penside_Test_Field_Sample_ID" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlPensideTestSampleID" CssClass="control-label" meta:resourcekey="Lbl_Field_Sample_ID" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlPensideTestSampleID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlPensideTestSampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Penside_Test_Field_Sample_ID" runat="server" ValidationGroup="PensideTestsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Penside_Test_Animal" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Penside_Test_Animal" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtPensideTestEIDSSAnimalID" CssClass="control-label" meta:resourcekey="Lbl_Animal_ID" runat="server"></asp:Label>
                                    <asp:TextBox CssClass="form-control" ID="txtPensideTestEIDSSAnimalID" runat="server" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtPensideTestEIDSSAnimalID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Penside_Test_Animal" runat="server" ValidationGroup="PensideTestsSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Penside_Test_Sample_Type" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Penside_Test_Sample_Type" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtPensideTestSampleType" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                    <asp:TextBox CssClass="form-control" ID="txtPensideTestSampleType" runat="server" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtPensideTestSampleType" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Penside_Test_Sample_Type" runat="server" ValidationGroup="PensideTestsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Penside_Test_Test_Result" runat="server">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Penside_Test_Test_Result" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlPensideTestPensideTestResultTypeID" CssClass="control-label" meta:resourcekey="Lbl_Test_Result" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlPensideTestPensideTestResultTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlPensideTestPensideTestResultTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Penside_Test_Test_Result" runat="server" ValidationGroup="PensideTestsSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnPensideTestSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="PensideTestsSection" />
                            <asp:Button ID="btnPensideTestCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divLabTestModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divLabTestModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divLabTestModal')">&times;</button>
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Lab_Tests_Interpretation"></h4>
            </div>
            <asp:UpdatePanel ID="upLabTestModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnLabTestSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnLabTestCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="ddlLabTestSampleID" EventName="SelectedIndexChanged" />
                </Triggers>
                <ContentTemplate>
                    <div id="divLabTestForm" class="modal-body" runat="server">
                        <div class="form-group" meta:resourcekey="Dis_Lab_Test_Field_Sample_ID" runat="server">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Field_Sample_ID" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlLabTestSampleID" CssClass="control-label" meta:resourcekey="Lbl_Field_Sample_ID" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlLabTestSampleID" runat="server" AutoPostBack="true"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlLabTestSampleID" CssClass="alert-danger" InitialValue="null" Display="Dynamic" meta:resourcekey="Val_Lab_Test_Field_Sample_ID" runat="server" ValidationGroup="LabTestSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Lab_Test_Lab_Sample_ID" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Lab_Sample_ID" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtLabTestEIDSSLaboratorySampleID" CssClass="control-label" meta:resourcekey="Lbl_Lab_Sample_ID" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtLabTestEIDSSLaboratorySampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestEIDSSLaboratorySampleID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Test_Lab_Sample_ID" runat="server" ValidationGroup="LabTestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" meta:resourcekey="Dis_Lab_Test_Sample_Type" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Sample_Type" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtLabTestSampleTypeName" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtLabTestSampleTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestSampleTypeName" CssClass="alert-danger" Display="Dynamic" meta:resourcekey="Val_Lab_Test_Sample_Type" runat="server" ValidationGroup="LabTestSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Lab_Test_Animal" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Animal" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtLabTestEIDSSAnimalID" CssClass="control-label" meta:resourcekey="Lbl_Animal_ID" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtLabTestEIDSSAnimalID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestEIDSSAnimalID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Test_Animal" runat="server" ValidationGroup="LabTestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Lab_Test_Test_Disease" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Test_Disease" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtTestDisease" CssClass="control-label" meta:resourcekey="Lbl_Disease" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtLabTestDisease" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestDisease" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Test_Test_Disease" runat="server" ValidationGroup="LabTestSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Lab_Test_Test_Name" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Test_Name" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlLabTestTestNameTypeID" CssClass="control-label" meta:resourcekey="Lbl_Test_Name" runat="server"></asp:Label>
                                    <eidss:DropDownList ID="ddlLabTestTestNameTypeID" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Lab_Test_Test_Status" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Test_Status" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlLabTestTestStatusTypeID" CssClass="control-label" meta:resourcekey="Lbl_Test_Status" runat="server"></asp:Label>
                                    <eidss:DropDownList ID="ddlLabTestTestStatusTypeID" runat="server" CssClass="form-control" Enabled="false"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlLabTestTestStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Test_Test_Status" runat="server" ValidationGroup="LabTestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Lab_Test_Test_Category" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Lab_Test_Test_Category" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlLabTestTestCategoryTypeID" CssClass="control-label" meta:resourcekey="Lbl_Test_Category" runat="server"></asp:Label>
                                    <eidss:DropDownList ID="ddlLabTestTestCategoryTypeID" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Result_Date" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Date" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtLabTestResultDate" CssClass="control-label" meta:resourcekey="Lbl_Result_Date" runat="server"></asp:Label>
                                    <eidss:CalendarInput ID="txtLabTestResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtLabTestResultDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Lab_Test_Result_Date" runat="server" ValidationGroup="LabTestSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Result_Observation" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Result_Observation" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlLabTestTestResultTypeID" CssClass="control-label" meta:resourcekey="Lbl_Result_Observation" runat="server"></asp:Label>
                                    <eidss:DropDownList ID="ddlLabTestTestResultTypeID" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnLabTestSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="LabTestSection" />
                            <asp:Button ID="btnLabTestCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divTestInterpretationModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divTestInterpretationModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divTestInterpretationModal')">&times;</button>
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Interpretation"></h4>
                <asp:HiddenField ID="hdfTestID" runat="server" Value="" />
            </div>
            <asp:UpdatePanel ID="upTestInterpretationModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnTestInterpretationSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnTestInterpretationCancel" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div id="divTestInterpretationForm" class="modal-body" runat="server">
                        <div class="form-group" meta:resourcekey="Dis_Rule_Out_Rule_In" runat="server">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Rule_Out_Rule_In" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlInterpretationInterpretedStatusTypeID" CssClass="control-label" meta:resourcekey="Lbl_Rule_Out_Rule_In" runat="server"></asp:Label>
                                    <eidss:DropDownList CssClass="form-control" ID="ddlInterpretationInterpretedStatusTypeID" runat="server"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlInterpretationInterpretedStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Rule_Out_Rule_In" runat="server" ValidationGroup="InterpretationSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Interpreted_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Interpreted_Comment" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtInterpretationInterpretedComment" CssClass="control-label" meta:resourcekey="Lbl_Interpreted_Comment" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtInterpretationInterpretedComment" runat="server" MaxLength="200" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtInterpretationInterpretedComment" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Interpreted_Comment" runat="server" ValidationGroup="InterpretationSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Date_Interpreted" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Date_Interpreted" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtInterpretationInterpretedDate" CssClass="control-label" meta:resourcekey="Lbl_Date_Interpreted" runat="server"></asp:Label>
                                    <eidss:CalendarInput ID="txtInterpretationInterpretedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtInterpretationInterpretedDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Date_Interpreted" runat="server" ValidationGroup="InterpretationSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Validated" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Validated" runat="server"></div>
                                    <asp:CheckBox ID="chkInterpretationValidatedStatusIndicator" runat="server" meta:resourcekey="Lbl_Validated" CssClass="checkbox-inline" />
                                    <%-- <asp:RequiredFieldValidator ControlToValidate="chkInterpretationblnValidateStatus" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Validated" runat="server" ValidationGroup="InterpretationSection"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Validated_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Validated_Comment" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtInterpretationValidatedComment" CssClass="control-label" meta:resourcekey="Lbl_Validated_Comment" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtInterpretationValidatedComment" runat="server" MaxLength="200" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtInterpretationValidatedComment" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Validated_Comment" runat="server" ValidationGroup="InterpretationSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Date_Validated" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Date_Validated" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtInterpretationValidatedDate" CssClass="control-label" meta:resourcekey="Lbl_Date_Validated" runat="server"></asp:Label>
                                    <eidss:CalendarInput ID="txtInterpretationValidatedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtInterpretationValidatedDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Date_Validated" runat="server" ValidationGroup="InterpretationSection"></asp:RequiredFieldValidator>

                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" meta:resourcekey="Dis_Validated_By" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Validated_By" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtInterpretationValidatedByPersonName" CssClass="control-label" meta:resourcekey="Lbl_Validated_By" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtInterpretationValidatedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtInterpretationValidatedByPersonName" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Validated_By" runat="server" ValidationGroup="InterpretationSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer text-center">
                        <asp:Button ID="btnTestInterpretationSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="InterpretationSection"></asp:Button>
                        <asp:Button ID="btnTestInterpretationCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        <asp:LinkButton ID="btnCreateConnectedDiseaseReport" runat="server" CssClass="btn btn-primary btn-sm" CausesValidation="false"><span><%= GetLocalResourceObject("Btn_Create_Connected_Disease_Report.Text")  %></span></asp:LinkButton>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divReportLogModal" class="modal container fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="divReportLogModal">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="hideModal('#divReportLogModal')">&times;</button>
                <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Case_Log"></h4>
            </div>
            <asp:UpdatePanel ID="upReportLogModal" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnReportLogSave" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="btnReportLogCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="txtReportLogActionRequired" EventName="TextChanged" />
                </Triggers>
                <ContentTemplate>
                    <div id="divReportLogForm" class="modal-body" runat="server">
                        <div class="form-group" meta:resourcekey="Dis_Action_Required" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Action_Required" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtReportLogActionRequired" CssClass="control-label" meta:resourcekey="Lbl_Action_Required" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtReportLogActionRequired" runat="server" CssClass="form-control" MaxLength="200" AutoPostBack="true"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtReportLogActionRequired" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Action_Required" runat="server" ValidationGroup="CaseLogSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Case_Log_Date" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Case_Log_Date" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtReportLogLogDate" CssClass="control-label" meta:resourcekey="Lbl_Case_Log_Date" runat="server"></asp:Label>
                                    <eidss:CalendarInput ID="txtReportLogLogDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                    <asp:RequiredFieldValidator ControlToValidate="txtReportLogLogDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Case_Log_Date" runat="server" ValidationGroup="CaseLogSection"></asp:RequiredFieldValidator>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Entered_By" runat="server">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Entered_By" runat="server"></div>
                                    <asp:Label AssociatedControlID="ddlReportLogEnteredByPersonID" CssClass="control-label" meta:resourcekey="Lbl_Entered_By" runat="server"></asp:Label>
                                    <asp:DropDownList ID="ddlReportLogEnteredByPersonID" runat="server" CssClass="form-control"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="ddlReportLogEnteredByPersonID" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Entered_By" runat="server" ValidationGroup="CaseLogSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Comment" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Comment" runat="server"></div>
                                    <asp:Label AssociatedControlID="txtReportLogComments" CssClass="control-label" meta:resourcekey="Lbl_Comment" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtReportLogComments" runat="server" CssClass="form-control" MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtReportLogComments" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Comment" runat="server" ValidationGroup="CaseLogSection"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" meta:resourcekey="Dis_Status" runat="server">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-8 col-xs-6">
                                    <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Status" runat="server"></div>
                                    <asp:Label CssClass="control-label" meta:resourcekey="Lbl_Status" runat="server"></asp:Label>
                                    <asp:RadioButton ID="rdbReportLogStatusOpen" runat="server" GroupName="CaseStatus" meta:resourceKey="Lbl_Open" CssClass="radio-inline" />
                                    <asp:RadioButton ID="rdbReportLogStatusClosed" runat="server" GroupName="CaseStatus" meta:resourceKey="Lbl_Closed" CssClass="radio-inline" />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <asp:Button ID="btnReportLogSave" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" CausesValidation="True" ValidationGroup="CaseLogSection"></asp:Button>
                            <asp:Button ID="btnReportLogCancel" runat="server" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CssClass="btn btn-default" CausesValidation="false" OnClientClick="showProcessing(this);" data-loading-text="..." />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divCancelModalContainer" class="modal" role="dialog" data-backdrop="static" tabindex="-1" runat="server">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="panel-heading">
                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Cancel_Disease_Report"></h4>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-alert modal-icon"></span></div>
                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <p runat="server" meta:resourcekey="Lbl_Cancel_Disease_Report"></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center">
                    <asp:Button ID="btnCancelYes" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                    <button type="button" runat="server" class="btn btn-default" data-dismiss="modal" title="<%$ Resources: Buttons, Btn_No_ToolTip %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                </div>
            </div>
        </div>
    </div>
    <div id="divSuccessModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divSuccessModal">
        <asp:UpdatePanel ID="upSuccessModal" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 id="hdgSuccess" class="modal-title"><%= GetGlobalResourceObject("Labels", "Lbl_EIDSS_Success_Message_Text") %></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right"><span class="glyphicon glyphicon-ok-sign modal-icon"></span></div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <p id="lblSuccessMessage" runat="server" meta:resourcekey="Lbl_Success"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnModalSuccessOK" runat="server" CssClass="btn btn-primary" CausesValidation="false" Text="<%$ Resources: Buttons, Btn_OK_Text %>" ToolTip="<%$ Resources: Buttons, Btn_OK_ToolTip %>" OnClientClick="hideModal('#divSuccessModal');" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divWarningModal" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="divWarningModal">
        <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-warning">
                        <div class="panel-heading">
                            <button type="button" class="close" onclick="hideModal('#divWarningModal');" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link" id="hdgWarning" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="warningSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="divWarningBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <div id="divWarningYesNo" runat="server">
                                <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnWarningModalNo" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_No_Text %>" ToolTip="<%$ Resources: Buttons, Btn_No_ToolTip %>" CausesValidation="false" />
                            </div>
                            <div id="divWarningOK" runat="server">
                                <button id="btnWarningModalOK" type="button" class="btn btn-warning alert-link" onclick="hideModal('#divWarningModal');" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divErrorModal" class="modal container fade" tabindex="-1" data-backdrop="static" data-focus-on="input:first" role="dialog" aria-labelledby="divErrorModal">
        <asp:UpdatePanel ID="upErrorModal" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-danger">
                        <div class="panel-heading">
                            <button type="button" class="close" onclick="hideModal('#divErrorModal');" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link danger" id="hdgError" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="errorSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="divErrorBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <button id="btnErrorModalOK" type="button" class="btn btn-danger alert-link" onclick="hideModal('#divErrorModal');" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <asp:UpdatePanel ID="upSearchPerson" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divSearchPersonModal" class="modal fade bs-example-modal-lg">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                            <h4 id="modalOnModalTitleHeading" class="modal-title" meta:resourcekey="Hdg_Search_Person" runat="server"></h4>
                        </div>
                        <div class="modal-body modal-wrapper">
                            <div class="form-group">
                                <eidss:SearchPersonUserControl ID="ucSearchPerson" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="upPerson" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="divPersonModal" class="modal fade bs-example-modal-lg">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                            <h4 id="hdgPerson" class="modal-title" meta:resourcekey="Hdg_Add_Update_Person" runat="server"></h4>
                        </div>
                        <div class="modal-body modal-wrapper">
                            <div class="form-group">
                                <eidss:AddUpdatePersonUserControl ID="ucAddUpdatePerson" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hdfDiseaseReportPanelController" runat="server" Value="0" />
    <script type="text/javascript">
        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
            var diseaseSection = document.getElementById("EIDSSBodyCPH_divDiseaseReportForm");
            if (diseaseSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));
            }
        });

        function callBackHandler() {
            var diseaseSection = document.getElementById("EIDSSBodyCPH_divDiseaseReportForm");
            if (diseaseSection != undefined) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));
            }
        }

        //  This function is unique for each page.  It checks to see if the container(s)
        //  that need the side navigation are currently being displayed.
        function checkContainersExist() {
            //  get instance of div containers with sections
            var diseaseSection = document.getElementById("<%= divDiseaseReportForm.ClientID %>");

            // if instances are not null, return true
            if (diseaseSection != null) {
                return true;
            }
            return false;
        }

        function expandDiseaseReportSummary() {
            $('#diseaseReportSummaryCollapsible').collapse('show');
        }

        function showModalHandler(modalID) {
            if ($('.modal.in').length == 0)
                showModal(modalID);
            else
                showModalOnModal(modalID);
        };

        function showModal(modalID) {
            //var bd = $('<div class="modal-backdrop show"></div>');
            $(modalID).modal('show');
            $("body").addClass("modal-open");
            //bd.appendTo(document.body);
        };

        function showModalOnModal(modalID) {
            $(modalID).modal('show');
        }

        function hideModal(modalID) {
            $(modalID).modal('hide');

            if ($('.modal.in').length == 0) {
                $('body').removeClass('modal-open');
                $('.modal-backdrop').remove();
            }
        };

        function hideModalAndWarningModal(modalID) {
            $('#divWarningModal').modal('hide');
            $(modalID).modal('hide');
        };

        function showProcessing(button) {
            var btn = $("#" + button.id);

            btn.button('loading');
        };

        function showSearchPersonModal() {
            $('#divSearchPersonModal').modal({ show: true });
        }

        function hideSearchPersonModal() {
            $('#divSearchPersonModal').modal('hide');
        }

        function showAddUpdatePersonModal() {
            $('#divPersonModal').modal({ show: true });
        }

        function hideAddUpdatePersonModal() {
            $('#divPersonModal').modal('hide');
        }

        function hideSearchPersonModalShowAddUpdatePersonModal() {
            $('#divSearchPersonModal').modal('hide');

            $('#divPersonModal').modal({ show: true });
        }

        function showSampleSubGrid(e, f) {
            var cl = e.target.className;
            if (cl == 'glyphicon glyphicon-triangle-bottom') {
                e.target.className = "glyphicon glyphicon-triangle-top";
                $('#' + f).show();
            }
            else {
                e.target.className = "glyphicon glyphicon-triangle-bottom";
                $('#' + f).hide();
            }
        }
    </script>
</asp:Content>
