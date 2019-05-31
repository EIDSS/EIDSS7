<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="Outbreak.aspx.vb" Inherits="EIDSS.Outbreak" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<%@ Register Src="~/Controls/SearchVeterinaryDiseaseReportUserControl.ascx" TagPrefix="eidss" TagName="SearchVeterinaryDiseaseReportUserControl" %>
<%@ Register Src="~/Controls/SearchHumanDiseaseReportUserControl.ascx" TagPrefix="eidss" TagName="SearchHumanDiseaseReportUserControl" %>
<%@ Register Src="~/Controls/FlexFormLoadTemplate.ascx" TagPrefix="eidss" TagName="FlexFormLoadTemplate" %>
<%@ Register Src="~/Controls/SearchPersonUserControl.ascx" TagPrefix="eidss" TagName="SearchPerson" %>
<%@ Register Src="~/Controls/AddUpdateSampleUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateSample" %>
<%@ Register Src="~/Controls/SearchEmployeeUserControl.ascx" TagPrefix="eidss" TagName="SearchEmployeeUserControl" %>
<%@ Register Src="~/Controls/SearchOrganizationUserControl.ascx" TagPrefix="eidss" TagName="SearchOrganizationUserControl" %>
<%@ Register Src="~/Controls/AddUpdateOrganizationUserControl.ascx" TagPrefix="eidss" TagName="AddUpdateOrganizationUserControl" %>
<%@ Register Src="~/Controls/SearchFarmUserControl.ascx" TagPrefix="eidss" TagName="SearchFarmUserControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
    <link href="../Includes/CSS/bootstrap-datetimepicker.css" rel="stylesheet" />
    <link href="../Includes/CSS/EIDSS7FullViewModuleStyles-1.0.0.css" rel="stylesheet" type="text/css" />
    <link href="../Includes/CSS/EIDSS7Styles-1.0.0.css" rel="stylesheet" type="text/css" />
    <link href="../Includes/CSS/bootstrap.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="container col-md-14">
        <div class="panel-body">
            <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Conditional">
                <Triggers></Triggers>
                <ContentTemplate>
                    <div id="divHiddenFieldsSection" runat="server">
                        <asp:HiddenField runat="server" Value="0" ID="hdnSearchMode" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfOutbreak" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfsDiagnosisOrDiagnosisGroup" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfidfHuman" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfidfHumanActual" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfidfContactHumanActual" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfidfSpeciesActualNext" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfidfFarm" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfidfFarmActual" />
                        <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfidfPerson" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfsCountry" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdfOutBreakCaseReportUID" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfOutbreakNote" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnOutbreakCaseReportUID" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnOutbreakContactReportUID" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnOutbreakCaseContactUID" />
                        <asp:HiddenField runat="server" Value="0" ID="hdnintRowStatus" />
                        <asp:HiddenField runat="server" Value="null" ID="hdfidfsSite" />
                        <asp:HiddenField runat="server" Value="null" ID="hdfidfPersonEnteredBy" />
                        <asp:HiddenField runat="server" Value="" ID="hdnCurrentSummaryTab" ClientIDMode="Static" />
                        <asp:HiddenField runat="server" Value="" ID="hdfRecordAction" />
                        <asp:HiddenField runat="server" Value="0" ID="hdnPersonSearchMode" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnNotificationSentByFacility" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnNotificationReceivedByFacility" />
                        <asp:HiddenField runat="server" Value="" ID="hdnNotificationReceivedByFirstName" />
                        <asp:HiddenField runat="server" Value="" ID="hdnNotificationReceivedByLastName" />
                        <asp:HiddenField runat="server" Value="" ID="hdnNotificationSentByFirstame" />
                        <asp:HiddenField runat="server" Value="" ID="hdnNotificationSentByLastName" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnstrInvestigatorOrganization" />
                        <asp:HiddenField runat="server" Value="" ID="hdnstrInvestigatorName" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdntxtFieldCollectedByOffice" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdntxtFieldCollectedByPerson" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdntxtSentToOrganization" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnMonitoringInvestigatorOrganization" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnContactName" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnstrVetInvestigatorOrganization" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnVetMonitoringInvestigatorOrganization" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnSampleCollectedByOrganizationID" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnSampleSentToOrganizationID" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnSampleCollectedByPersonID" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfVetNotificationSentByFacilty" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfVetNotificationSentByName" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfVetNotificationReceivedByFacilty" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfVetNotificationReceivedByName" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnidfVetInvestigatorName" />
                        <asp:HiddenField runat="server" Value="-1" ID="hd2VetContactName" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnVetSampleTypeId" />
                        <asp:HiddenField runat="server" Value="-1" ID="hdnVetContactName" />
                        <asp:HiddenField runat="server" Value="" ID="hdnDiseaseReport" />
                        <asp:HiddenField runat="server" Value="" ID="hdfRowAction" />
                    </div>

                    <asp:Panel ID="pSearchForm" runat="server" CssClass="row" Visible="false">
                        <div id="searchForm" runat="server" class="row">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h2 runat="server" meta:resourcekey="hdg_Outbreak_Search"></h2>
                                </div>
                            </div>
                            <div class="panel-heading" style="border-bottom:2px;">
                                <div class="row">
                                    <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                        <h3 id="hdgSearchCriteria" runat="server" class="header" meta:resourcekey="Lbl_Search_Criteria"></h3>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                        <a href="#divAdvanceSearchCriteriaForm" data-toggle="collapse" onclick="toggleAdvanceSearchCriteria();">
                                            <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div id="dSearchForm" class="panel-collapse in">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 embed-panel">
                                    <div class="panel-default">
                                        <div class="panel-heading">
                                            <h3 class="heading" meta:resourcekey="hdg_Search_Criteria" runat="server"></h3>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                        <label for="<%= txtSearchOutbreakID.ClientID  %>" runat="server" meta:resourcekey="lbl_Outbreak_ID"></label>
                                                        <asp:TextBox ID="sftxtstrOutbreakID" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                        <label for="<%= ddlOutbreakType.ClientID  %>" runat="server" meta:resourcekey="lbl_Outbreak_Type"></label>
                                                        <eidss:DropDownList ID="sfddlOutbreakTypeID" runat="server" CssClass="form-control" AutoPostBack="true"  ValidationGroup="create"></eidss:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                        <label for="<%= ddlSearchDiagnosesGroup.ClientID  %>" runat="server" meta:resourcekey="lbl_Diagnoses_Group"></label>
                                                        <asp:DropDownList ID="sfddlSearchDiagnosesGroup" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="<%= hdfSearchStartDate.ClientID %>" runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                                <div class="row">
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                                        <label for="<%= txtSearchStartDateFrom.ClientID  %>" runat="server" meta:resourcekey="lbl_From"></label>
                                                        <eidss:CalendarInput ID="sftxtStartDateFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                                                        <label for="<%= txtSearchStartDateTo.ClientID  %>" runat="server" meta:resourcekey="lbl_To"></label>
                                                        <eidss:CalendarInput ID="sftxtStartDateTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                        <label for="<%= ddlidfsOutbreakStatus.ClientID  %>" runat="server" meta:resourcekey="lbl_Outbreak_Status"></label>
                                                        <eidss:DropDownList ID="sfddlidfsOutbreakStatus" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <eidss:LocationUserControl
                                                    ID="sflucSearch"
                                                    runat="server"
                                                    ShowCountry="false"
                                                    ShowBuildingHouseApartmentGroup="false"
                                                    ShowCoordinates="false"
                                                    ShowPostalCode="false"
                                                    ShowStreet="false"
                                                    ShowTownOrVillage="false"
                                                    IsHorizontalLayout="true"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                                <asp:Button ID="btnCancel" CssClass="btn btn-primary" runat="server"  meta:resourcekey="btn_Cancel" onclick="btnCancelList_Click" />
                                                <asp:Button ID="btnClear" CssClass="btn btn-default" runat="server"  meta:resourcekey="btn_Clear" />
                                                <asp:Button ID="btnAdd" CssClass="btn btn-default" runat="server"  meta:resourcekey="btn_Add" />
                                                <asp:Button ID="btnSearchList" CssClass="btn btn-primary" runat="server"  meta:resourcekey="btn_Search" onclick="btnSearchList_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:panel>
                    <asp:Panel ID="pOutbreakManagement" runat="server" CssClass="row" Visible="false">
                        <div id="outbreakManagement" runat="server" class="row">
                            <div class="panel panel-default" id="pOutbreakManagementHeader" runat="server">
                                <div class="panel-heading">
                                    <h2 runat="server" meta:resourcekey="hdg_Outbreak_Management"></h2>
                                </div>
                            </div>
                            <div class="form-group" id="pOutbreakManagementControls" runat="server">
                                <div id="dActions" runat="server">
                                    <asp:Button ID="btnCreate" CssClass="btn btn-primary" runat="server" meta:resourcekey="btn_Create_Outbreak" OnClick="btnCreate_Click" />
                                    <div class="flex-container-sm search-group pull-right">
                                        <div class="form-group has-feedback has-clear">
                                            <asp:TextBox ID="obmtxtstrquickSearch" runat="server" ClientIDMode="Static" MaxLength ="20" CssClass="form-control" Height="35px" meta:resourcekey="txt_Outbreak_Query" AutoPostBack="false"></asp:TextBox>
                                            <span class="form-control-clear glyphicon glyphicon-remove form-control-feedback" onclick="clearQuickSearch();"></span>
                                        </div>
                                        <span>
                                            <a id="btnIdSearch" class="btn btn-default btn-md" href="" runat="server" ClientIDMode="Static"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></a>
                                        </span>
                                    </div>
                                </div>
                                <div style="clear:both"></div>
                                <div class="flex-container-sm search-group upper-right">
                                    <a id="btnAdvanceSearch" href="#" runat="server"  meta:resourcekey="hpl_Advance_Search"></a>
                                </div>
                            </div>
                            <eidss:GridView
                                        AllowPaging="True"
                                        AllowSorting="True"
                                        AutoGenerateColumns="False"
                                        CssClass="table table-striped"
                                        DataKeyNames="idfOutbreak"
                                        EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                        GridLines="None"
                                        ID="gvOutbreaks"
                                        runat="server"
                                        PageSize="10"
                                        PagerSettings-Visible="false"
                                        ShowFooter="true"
                                        UseAccessibleHeader="true">
                                <HeaderStyle CssClass="table-striped-header" />
                                <Columns>                                    
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="hlOutbreak" runat="server" CommandName="Select" CommandArgument='<% #Bind("idfOutbreak")%>' CausesValidation="false" Text='<% #Bind("strOutbreakID") %>'   HeaderText="<%$ Resources:  Grd_Outbreak_List_Outbreak_ID_Heading %>" SortExpression="strOutbreakID"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField Visible="false" DataField="idfsDiagnosisOrDiagnosisGroup" ReadOnly="true" />
                                    <asp:BoundField DataField="strOutbreakStatus" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Outbreak_List_Status_Heading %>" SortExpression="MonitoringSessionStatus" />
                                    <asp:BoundField DataField="strOutbreakType" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Outbreak_List_Type_Heading %>" SortExpression="datEnteredDate" DataFormatString="{0:d}" />
                                    <asp:BoundField DataField="Region" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Outbreak_List_Region_Heading %>" SortExpression="Region" />
                                    <asp:BoundField DataField="Rayon" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Outbreak_List_Rayon_Heading %>" SortExpression="Rayon" />
                                    <asp:BoundField DataField="strDiagnosis" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Outbreak_List_Disease_Heading %>" SortExpression="Diagnosis" />
                                    <asp:BoundField DataField="datStartDate" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Outbreak_List_Start_Date_Heading %>" SortExpression="StartDate" />
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnbEditSession" runat="server"  CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("idfOutbreak") %>' CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnbDeleteSession" runat="server"  CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfOutbreak") %>' CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </eidss:GridView>
                            <div class="row grid-footer">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <label><%= GetGlobalResourceObject("Labels", "Lbl_Page_Text") %></label>&nbsp;<asp:Label ID="lblOutbreakPageNumber" runat="server" CssClass="control-label"></asp:Label>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-right">
                                    <asp:Repeater ID="rptOutbreakPager" runat="server">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkOutbreakPage" runat="server"  CssClass="btn btn-primary btn-xs" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>' Enabled='<%# Eval("Enabled") %>' OnClick="OutbreakPage_Changed" Height="20"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pSearchResults" runat="server" CssClass="row" Visible="false">
                        <div id="searchResults" runat="server" class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 embed-panel">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8">
                                            <h3 class="heading" runat="server" meta:resourcekey="hdg_Search_Criteria"></h3>
                                        </div>
                                        <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4 text-right">
                                            <asp:Button ID="btnEditSearch" CssClass="btn btn-default" runat="server" meta:resourcekey="btn_Edit" OnClick="btnEditSearch_Click" />
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <label for="<%= lblSearchResultsOutbreakID.ClientID %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Outbreak_ID"></label>
                                            <asp:Label ID="lblSearchResultsOutbreakID" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                            <label for="<%= lblSearchResultsOutbreakStatus.ClientID %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Outbreak_Status"></label>
                                            <asp:Label ID="lblSearchResultsOutbreakStatus" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <label for="<%= lblSearchResultsDiagnosis.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Diagnosis"></label>
                                            <asp:Label ID="lblSearchResultsDiagnosis" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                            <label for="<%= lblSearchResultsDiagnosesGroup.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Diagnoses_Group"></label>
                                            <asp:Label ID="lblSearchResultsDiagnosesGroup" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <label for="<%= lblSearchResultsRegion.ClientID  %>" class="col-lg-2 col-md-2 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Region"></label>
                                            <asp:Label ID="lblSearchResultsRegion" runat="server" CssClass="form-label col-lg-2 col-md-2 col-sm-3 col-xs-6"></asp:Label>
                                            <label for="<%= lblSearchResultsRayon.ClientID  %>" class="col-lg-2 col-md-2 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Rayon"></label>
                                            <asp:Label ID="lblSearchResultsRayon" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                            <label for="<%= lblSearchResultsSettlement.ClientID  %>" class="col-lg-2 col-md-2 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Settlement"></label>
                                            <asp:Label ID="lblSearchResultsSettlement" runat="server" CssClass="form-label col-lg-2 col-md-2 col-sm-3 col-xs-6"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="<%= hdfSearchStartDate.ClientID %>" runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label for="<%= lblSearchResultsStartDate.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_From"></label>
                                                <asp:Label ID="lblSearchResultsStartDate" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                                <label for="<%= lblSearchResultsStartDateTo.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_To"></label>
                                                <asp:Label ID="lblSearchResultsStartDateTo" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="<%= hdfSearchEndDate.ClientID %>" runat="server" meta:resourcekey="lbl_End_Date"></label>
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label for="<%= lblSearchResultsEndDateFrom.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_From"></label>
                                                <asp:Label ID="lblSearchResultsEndDateFrom" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                                <label for="<%= lblSearchResultsEndDateTo.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_To"></label>
                                                <asp:Label ID="lblSearchResultsEndDateTo" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <label for="<%= lblSearchResultsPatient.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Patient"></label>
                                            <asp:Label ID="lblSearchResultsPatient" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                            <label for="<%= lblSearchResultsFarmOwner.ClientID  %>" class="col-lg-3 col-md-3 col-sm-3 col-xs-6" runat="server" meta:resourcekey="lbl_Farm_Owner"></label>
                                            <asp:Label ID="lblSearchResultsFarmOwner" runat="server" CssClass="form-label col-lg-3 col-md-3 col-sm-3 col-xs-6"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 runat="server" class="heading" meta:resourcekey="hdg_Search_Results"></h3>
                                </div>
                                <div class="panel-body">
                                    <div class="table-responsive">
                                        <asp:GridView ID="gvSearchResults" runat="server" AllowPaging="true"
                                            AllowSorting="true"
                                            AutoGenerateColumns="false"
                                            CssClass="table-striped"
                                            GridLines="None"
                                            RowStyle-CssClass="table"
                                            EmptyDataText="No data available."
                                            ShowHeaderWhenEmpty="true"
                                            ShowFooter="true">
                                            <Columns>
                                                <asp:BoundField DataField="idfsOutbreakID" ReadOnly="true" HeaderText="<%lbl_Outbreak_ID.InnerText %>" SortExpression="idfsOutbreakID" />
                                                <asp:BoundField DataField="strDiagnosisDiagnosisGroup" ReadOnly="true" HeaderText="<%lbl_Longitude.InnerText %>" SortExpression="lbl_Diagnosis_Diagnosis_Group.InnerText" />
                                                <asp:BoundField DataField="datStartDate" DataFormatString="{0:d}" ReadOnly="true" HeaderText="<%lbl_Start_Date.InnerText %>" SortExpression="datStartDate" />
                                                <asp:BoundField DataField="datCloseDate" DataFormatString="{0:d}" ReadOnly="true" HeaderText="<%lbl_End_Date.InnerText %>" SortExpression="datCloseDate" />
                                                <asp:BoundField DataField="strOutbreakStatus" ReadOnly="true" HeaderText="<%lbl_Outbreak_Status.InnerText %>" />
                                                <asp:BoundField ReadOnly="true" HeaderText="<%lbl_Patient_Farm_Owner.InnerText %>" />
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                    <a class="btn btn-default" runat="server" meta:resourcekey="hpl_Return_to_Dashboard" href="../Dashboard.aspx"></a>
                                    <asp:Button ID="btnNewSearch" runat="server"  CssClass="btn btn-default" meta:resourceKey="btn_New_Search" OnClick="btnNewSearch_Click" />
                                    <asp:Button ID="btnCreateOutbreak" runat="server"  class="btn btn-primary" meta:resourceKey="btn_Create_Outbreak" OnClick="btnCreateOutbreak_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                    </asp:Panel>
                    <asp:Panel ID="pOutbreak" runat="server" CssClass="row" Visible="false">
                        <div id="outbreak" runat="server" class="row">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h2 runat="server" meta:resourcekey="hdg_Outbreak_Create"></h2>
                            </div>
                        </div>
                        <div class="upper-left">
                            <asp:LinkButton runat="server"  ID="lbOutbreakHome2"  meta:resourceKey="Btn_Outbreak_Management" class="OutbreakHome-txt" />
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 embed-panel">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="heading" runat="server" meta:resourceKey="hdg_Outbreak_Information"></h3>
                                </div>
                                <div id="outbreakDetails" runat="server" class="panel-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <label for="<%=txtOutBreakID.ClientID %>" runat="server" meta:resourcekey="lbl_OutBreak_ID"></label>
                                                <asp:TextBox runat="server" ID="txtstrOutbreakID" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="txt_OutBreak_ID" ReadOnly="true"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Session_Start_Date" runat="server"></div>
                                                <label for="<%=txtdatStartDate.ClientID %>" runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                                <eidss:CalendarInput ID="clidatStartDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                <asp:RequiredFieldValidator ControlToValidate="clidatStartDate" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Session_Start_Date" runat="server" ValidationGroup="create"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12"n>
                                                <label id="lblclidatCloseDate" for="<%=txtdatCloseDate.ClientID %>" runat="server" meta:resourcekey="lbl_End_Date" visible="false"></label>
                                                <eidss:CalendarInput ID="clidatCloseDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" Visible="false" AutoPostBack="true"></eidss:CalendarInput>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Outbreak_Type_Id" runat="server"></div>
                                                <label for="<%= ddlOutbreakType.ClientID  %>" runat="server" meta:resourcekey="lbl_Outbreak_Type"></label>
                                                <eidss:DropDownList ID="ddlOutbreakTypeId" runat="server"  CssClass="form-control" AutoPostBack="true"  ValidationGroup="create"></eidss:DropDownList>
                                                <asp:RequiredFieldValidator ControlToValidate="ddlOutbreakTypeId" CssClass="text-danger" InitialValue="null" Display="Dynamic" meta:resourcekey="Val_Outbreak_Type_Id" runat="server" ValidationGroup="create"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Outbreak_Status" runat="server"></div>
                                                <label for="<%= ddlOutbreakStatus.ClientID  %>" runat="server" meta:resourcekey="lbl_Outbreak_Status"></label>
                                                <eidss:DropDownList ID="ddlidfsOutbreakStatus" runat="server" CssClass="form-control"  ValidationGroup="create" AutoPostBack="true" OnSelectedIndexChanged="DeterminePossibleMessage"></eidss:DropDownList>
                                                <asp:RequiredFieldValidator ControlToValidate="ddlidfsOutbreakStatus" CssClass="text-danger" InitialValue="null" Display="Dynamic" meta:resourcekey="Val_Outbreak_Status" runat="server" ValidationGroup="create"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                                                <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Diagnosis_Group" runat="server"></div>
                                                <label for="<%= ddlDiagnosesGroup.ClientID  %>" runat="server" meta:resourcekey="lbl_Diagnoses_Group"></label>
                                                <eidss:DropDownList ID="ddlidfsDiagnosisOrDiagnosisGroup" runat="server" CssClass="form-control" Enabled="false" ValidationGroup="create" OnSelectedIndexChanged="ddlidfsDiagnosisOrDiagnosisGroup_SelectedIndexChanged"></eidss:DropDownList>
                                                <asp:RequiredFieldValidator ControlToValidate="ddlidfsDiagnosisOrDiagnosisGroup" CssClass="text-danger" InitialValue="null" Display="Dynamic" meta:resourcekey="Val_Diagnosis_Group" runat="server" ValidationGroup="create"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <label runat="server" meta:resourcekey="lbl_Outbreak_Location"></label>
                                    </div>
                                    <div class="form-group">
                                        <eidss:LocationUserControl ID="outbreakLocation" runat="server" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowCountry="false" ShowPostalCode="false" ShowStreet="false" IsHorizontalLayout="true"  />
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label for="" runat="server" meta:resourcekey="lbl_Species_Affected"></label>
                                                <div class="input-group continue-checkbox-set">
                                                    <div class="checkbox-inline">
                                                        <input type="checkbox" runat="server" id="idfscbHuman" onclick="showParameters(this,'Human')" disabled="disabled" />Human
                                                    </div>
                                                    <div class="checkbox-inline">
                                                        <input type="checkbox" runat="server" id="idfscbAvian" onclick="showParameters(this, 'Avian')" disabled="disabled" />Avian
                                                    </div>
                                                    <div class="checkbox-inline">
                                                        <input type="checkbox" runat="server" id="idfscbLivestock" onclick="showParameters(this, 'Livestock')" disabled="disabled" />Livestock
                                                    </div>
                                                    <div class="checkbox-inline">
                                                        <input type="checkbox" runat="server" id="idfscbVector" onclick="showParameters(this, 'Vector')" disabled="disabled" />Vector
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" id="dSpeciesAffectedError" style="display:none">
                                            <label runat="server" class="text-danger" meta:resourceKey="Val_Vector_Selection" style="color:red"></label>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-heading">
                                    <div id="dOutbreakHeading" runat="server" style="display:none">
                                        <h3 class="heading" runat="server" meta:resourceKey="lbl_Outbreak_Parameters"></h3>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div id="dOutbreakParameters" runat="server">	
                                        <div id="dParametersidfscbHuman" runat="server" style="display:none">
                                            <h4 class="heading" runat="server" meta:resourceKey="lbl_Human_Parameters"></h4>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensHumanCaseMonitoringDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensHumanCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensHumanCaseMonitoringFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false" onChange="javascript:limitCeiling('ensHumanCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensHumanContactTracingDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensHumanContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensHumanContactTracingFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false" onChange="javascript:limitCeiling('ensHumanContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="dParametersidfscbAvian" runat="server"  style="display:none">
                                            <h4 class="heading" runat="server" meta:resourceKey="lbl_Avian_Parameters"></h4>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxAvianCaseMonitoringDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensxAvianCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxAvianCaseMonitoringFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false" onChange="javascript:limitCeiling('ensxAvianCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxAvianContactTracingDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensxAvianContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxAvianContactTracingFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false" onChange="javascript:limitCeiling('ensxAvianContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="dParametersidfscbLivestock" runat="server" style="display:none">
                                            <h4 class="heading" runat="server" meta:resourceKey="lbl_Livestock_Parameters"></h4>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensLivestockCaseMonitoringDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensLivestockCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensLivestockCaseMonitoringFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false" onChange="javascript:limitCeiling('ensLivestockCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensLivestockContactTracingDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensLivestockContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensLivestockContactTracingFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false" onChange="javascript:limitCeiling('ensLivestockContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="dParametersidfscbVector" runat="server" style="display:none">
                                            <h4 class="heading" runat="server" meta:resourceKey="lbl_Vector_Parameters"></h4>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxVectorCaseMonitoringDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensxVectorCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_CaseMonitoringFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxVectorCaseMonitoringFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false" onChange="javascript:limitCeiling('ensxVectorCaseMonitoring');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingDuration"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxVectorContactTracingDuration" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" onChange="javascript:enableParameter('ensxVectorContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
	                                                <div class="col-sm-3">
		                                                <label runat="server" meta:resourceKey="lbl_Parameters_ContactTracingFrequency"></label>
	                                                </div>
	                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-3">
			                                            <eidss:NumericSpinner ID="ensxVectorContactTracingFrequency" ClientIDMode="Static" runat="server" CssClass="form-control" MinValue="0" MaxValue="365" Enabled="false"  onChange="javascript:limitCeiling('ensxVectorContactTracing');"></eidss:NumericSpinner>
	                                                </div>
                                                </div>
                                            </div>
                                        </div>
<%--                                        <div id="Div2" runat="server">
                                            <div class="row">
                                                Flex Form Selection #1
                                            </div>
                                            <div class="row">
                                                <eidss:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" AutoPostBack="true"  ValidationGroup="create">
                                                    <asp:ListItem Text="" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="Selection #1" Value="1"></asp:ListItem>
                                                </eidss:DropDownList>
                                            </div>
                                            <div class="row">
                                                Flex Form Selection #2
                                            </div>
                                            <div class="row">
                                                <eidss:DropDownList ID="DropDownList2" runat="server" CssClass="form-control" AutoPostBack="true"  ValidationGroup="create">
                                                    <asp:ListItem Text="" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="Selection #1" Value="1"></asp:ListItem>
                                                </eidss:DropDownList>
                                            </div>
                                            <div class="row">
                                                Flex Form Selection #3
                                            </div>
                                            <div class="row">
                                                <eidss:DropDownList ID="DropDownList3" runat="server" CssClass="form-control" AutoPostBack="true"  ValidationGroup="create">
                                                    <asp:ListItem Text="" Value="0"></asp:ListItem>
                                                    <asp:ListItem Text="Selection #1" Value="1"></asp:ListItem>
                                                </eidss:DropDownList>
                                            </div>
                                        </div>--%>
                                    </div>
                                </div>
                                <div id="dSubmissionPanelDivider" runat="server" style="display:none">
                                    <div class=""></div>
                                </div>
                                <div id="dSubmissionPanel" runat="server" style="display:none">
                                    <div class="modal-footer">
                                        <div class="row">
	                                        <div class="continue-radio-set">
		                                        <label runat="server" meta:resourceKey="lbl_Submission_Questionnaire" style="float:left;margin-right:25px"></label>
                                                <asp:Label ID="lblQuestionnaireYes" meta:resourceKey="lbl_Questionnaire_Yes" runat="server"></asp:Label>
                                                <input type="radio" id="rbQuestionnaireYes" name="rbQuestionnaire" value="1" onclick="javascript: setQuestionnaire(1);" checked="checked" />
                                                <asp:Label ID="lblQuestionnaireNo" meta:resourceKey="lbl_Questionnaire_No" runat="server" ></asp:Label>
                                                <input type="radio" id="rbQuestionnaireNo" name="rbQuestionnaire" value="0" onclick="javascript:setQuestionnaire(0);"/>
	                                        </div>
                                            <div class="push-btn-right">
                                                <asp:Button ID="bNext" runat="server"  class="btn btn-default" meta:resourceKey="btn_Next" OnClick="btnNextOutbreak_Click" CausesValidation="true" ValidationGroup="create" ClientIDMode="Static" />
                                                <asp:Button ID="bSubmit" runat="server"  class="btn btn-primary" meta:resourceKey="btn_Submit" OnClick="btnSubmitOutbreak_Click" CausesValidation="true" ValidationGroup="create" ClientIDMode="Static" />
                                                <asp:Button ID="bCancel" runat="server"  class="btn btn-default" meta:resourceKey="btn_Cancel" OnClick="btnCancelOutbreak_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    </asp:Panel>
                    <asp:Panel ID="pOutbreakQuestionnaire" runat="server" CssClass="row" Visible="false">
                        <div id="outbreakQuestionnaire" runat="server" class="row">
                        <label for="hdfoutbreakQuestionnaire" runat="server" meta:resourcekey="lbl_Questionnaire"></label>
                            <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakCase" />
                        <div class="text-center">
                            <asp:Button ID="bQuestionnaireSubmit" runat="server" class="btn btn-primary" meta:resourceKey="btn_Submit" OnClick="btnQuestionnaireSubmitOutbreak_Click" />
                            <asp:Button ID="bQuestionnaireCancel" runat="server" class="btn btn-default" meta:resourceKey="btn_Cancel" OnClick="btnQuestionnaireCancelOutbreak_Click" />
                        </div>
                    </div>
                    </asp:Panel>
                    <asp:Panel ID="pOutbreakSummaryAndQuestions" runat="server" CssClass="row" Visible="false">
                        <div id="outbreakSummaryAndQuestions" runat="server" class="row">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h2 runat="server" meta:resourcekey="hdg_Outbreak_Session"></h2>
                            </div>
                        </div>
                        <div class="upper-left">
                            <asp:LinkButton runat="server"  ID="lbOutbreakHome"  meta:resourceKey="Btn_Outbreak_Management" class="OutbreakHome-txt"/>
                        </div>
                        <fieldset>
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 embed-panel">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                            <h3 class="heading" id="outbreakInfoHeading" meta:resourcekey="Hdg_Outbreak_Summary" runat="server"></h3>
                                        </div>
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                            <asp:LinkButton runat="server" ID="lbEditSession" CssClass="glyphicon glyphicon-edit" OnClick="EditOutbreakSession" />
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="row" >
	                                    <div class="col-md-3">
		                                    <label runat="server" meta:resourcekey="lbl_OutBreak_ID"></label>
                                            <div class="panel panel-default">
                                                <asp:Label runat="server" id="lblstrOutbreakID" />
                                            </div>
	                                    </div>
	                                    <div class="col-md-3">
                                            <label runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                            <div class="panel panel-default">
                                                <asp:Label runat="server" id="lbldatStartDate" />
                                            </div>
	                                    </div>
                                        <div class="col-md-3">
                                            <label  runat="server" meta:resourcekey="lbl_End_Date"></label>
                                            <div class="panel panel-default">
                                                <asp:Label runat="server" id="lbldatCloseDate" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-3">
		                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Type"></label>
                                            <div class="panel panel-default">
                                                <asp:Label runat="server" id="lblstrOutbreakType" />
                                            </div>
	                                    </div>
	                                    <div class="col-md-3">
		                                    <label runat="server" meta:resourcekey="lbl_Diagnoses_Group"></label>
                                            <div class="panel panel-default">
                                                <asp:Label runat="server" id="lblstrDiagnosis" />
                                            </div>
	                                    </div>
	                                    <div class="col-md-3">
                                            <label runat="server" meta:resourcekey="lbl_Outbreak_Status"></label>
                                            <div class="panel panel-default">
                                                <asp:Label runat="server" id="lblstrOutbreakStatus" />
                                            </div>
	                                    </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-3">
                                            <label runat="server" meta:resourcekey="lbl_Outbreak_Location"></label>
                                            <div class="panel panel-default">
                                                <asp:Label runat="server" id="lblRegion" />
                                            </div>
	                                    </div>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                        <div class="row">
                            <div class="col-xs-12">
                                <asp:UpdatePanel ID="upAllSamplesCount" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <ul class="nav nav-tabs lab">
                                            <li id="liCases" class="active">
                                                <a id="nav-all-cases-tab" href="#nav-all-cases" onclick="javascript:setCurrentSummaryTab(this.id)" data-toggle="tab">
                                                    <asp:Label ID="lblCases" runat="server" meta:resourcekey="lbl_Import_Case"></asp:Label>
                                                    <asp:Label ID="lblCasesCount" runat="server" Font-Bold="True"></asp:Label>
                                                </a>
                                            </li>
                                            <li id="liContacts">
                                                <a id="nav-contacts-tab" href="#nav-contacts" onclick="javascript:setCurrentSummaryTab(this.id)" data-toggle="tab">
                                                    <asp:Label ID="lblContacts" runat="server" meta:resourcekey="lbl_Contacts"></asp:Label>
                                                    <asp:Label ID="lblContactsCounts" runat="server" Font-Bold="True"></asp:Label>
                                                </a>
                                            </li>
                                            <li id="liUpdates">
                                                <a id="nav-updates-tab" href="#nav-updates" onclick="javascript:setCurrentSummaryTab(this.id)" data-toggle="tab">
                                                    <asp:Label ID="lblUpdates" runat="server" meta:resourcekey="lbl_Updates"></asp:Label>
                                                    <asp:Label ID="lblUpdatesCount" runat="server" Font-Bold="True"></asp:Label>
                                                </a>
                                            </li>
                                            <li id="liAnalysis">
                                                <a id="nav-analysis-tab" href="#nav-analysis" onclick="javascript:setCurrentSummaryTab(this.id)" data-toggle="tab">
                                                    <asp:Label ID="lblAnalysis" runat="server" meta:resourcekey="lbl_Analysis"></asp:Label>
                                                    <asp:Label ID="lblAnalysisCount" runat="server" Font-Bold="True"></asp:Label>
                                                </a>
                                            </li>
                                        </ul>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="tab-content">
                                    <div id="nav-all-cases" class="tab-pane active" role="tabpanel" aria-labelledby="nav-cases-tab">
                                        <div class="row">
                                            <div id="divOutbreakCases" runat="server" class="flex-container-sm">
                                                <div id="divOutbreakCaseListing" class="all-samples-command-panel">
                                                    <asp:UpdatePanel ID="upAllSamplesButtons" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>
                                                            <a href="#" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                                                <img src="../Includes/Images/labMenu.png">
                                                            </a>
                                                                <input type="button" id="bImportCase" meta:resourceKey="Btn_Import_Case" class="btn btn-primary" value="Import" onclick="showDecision(this)"/><input type="button" id="bCreateCase" meta:resourceKey="Btn_Create_Case" class="btn btn-primary" value="Create" onclick="showDecision(this)"/>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                                <div id="divAllSamplesDivider1" class="divider-panel">&nbsp;</div>
                                                <div class="form-group has-feedback has-clear">
                                                    <asp:TextBox ID="obmctxtstrCaseQuickSearch" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" meta:resourcekey="txt_Outbreak_Query"></asp:TextBox>
                                                    <span class="form-control-clear glyphicon glyphicon-remove form-control-feedback hidden"></span>
                                                </div>
                                                <span>
                                                    <a id="btnIdSearchCase" runat="server" class="btn btn-default btn-md" href="#"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></a>
                                                </span>
                                                <div id="divPrint" class="pull-right">
                                                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btn btn-primary btn-md" CausesValidation="false">
                                                        <span class="glyphicon glyphicon-print" aria-hidden="true"></span>
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <asp:UpdatePanel runat="server" ID="upOutbreakCases" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <eidss:GridView 
                                                            ID="gvOutbreakCases" 
                                                            runat="server" 
                                                            AllowPaging="True" 
                                                            AllowSorting="True" 
                                                            AutoGenerateColumns="False" 
                                                            CssClass="table table-striped table-hover" 
                                                            DataKeyNames="OutbreakCaseReportUID" 
                                                            GridLines="None" 
                                                            EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                            UseAccessibleHeader="false" 
                                                            PageSize="10"
                                                            PagerSettings-Visible="false"
                                                            ShowFooter="false"                                                                
                                                            ShowHeaderWhenEmpty="true">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" />
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="31">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkCase" runat="server" AutoPostBack="true" Value='<%#Eval("OutbreakCaseReportUID")%>' CaseType='<%#Eval("CaseType")%>' onclick="javascript:clearContactSelections(this);" OnCheckedChanged="chkCase_Click"  />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-Width="31">
                                                                <ItemTemplate>
                                                                    <asp:UpdatePanel ID="upAllCasesEdit" runat="server" UpdateMode="Conditional">
                                                                        <Triggers>
                                                                            <asp:PostBackTrigger ControlID="btnEditCase" />
                                                                        </Triggers>
                                                                        <ContentTemplate>
                                                                            <asp:LinkButton ID="btnEditCase" runat="server" AutoPostBack="true"  CssClass="btn btn-sm" CommandName="Edit" CommandArgument='<%#Eval("OutbreakCaseReportUID")%>' idfHumanCase='<%#Eval("idfHumanCase")%>' idfVetCase='<%#Eval("idfVetCase")%>' CausesValidation="false" OnClientClick="javascript:initializeSideBar_Immediate();">
                                                                                <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
                                                                            </asp:LinkButton>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="strOutbreakCaseID" HeaderText="<%$ Resources: Grd_Outbreak_Case_ID_Heading %>" />
                                                            <asp:BoundField DataField="DateEntered" HeaderText="<%$ Resources: Grd_Outbreak_Case_Date_Entered_Heading %>" />
                                                            <asp:BoundField DataField="FarmOwner" HeaderText="<%$ Resources: Grd_Outbreak_Case_Name_Heading %>" />
                                                            <asp:BoundField DataField="CaseType" HeaderText="<%$ Resources: Grd_Outbreak_Case_Type_Heading %>" />
                                                            <asp:BoundField DataField="CaseFarmStatus" HeaderText="<%$ Resources: Grd_Outbreak_Case_Farm_Status_Heading %>" />
                                                            <asp:BoundField DataField="DateOfSymptomOnset" HeaderText="<%$ Resources: Grd_Outbreak_Case_Date_Symptom_Onset_Heading %>" />
                                                            <asp:BoundField DataField="CaseClassification" HeaderText="<%$ Resources: Grd_Outbreak_Case_Classification_Heading %>" />
                                                            <asp:BoundField DataField="CaseLocation" HeaderText="<%$ Resources: Grd_Outbreak_Case_Location_Heading %>" />
                                                        </Columns>
                                                    </eidss:GridView>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                        <div class="row">
                                            <asp:Label ID="lblCaseTotalRecords" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                    <div id="nav-contacts" class="tab-pane" role="tabpanel" aria-labelledby="nav-testing-samples-tab">
                                            <div class="row">
                                                <div id="dContactActions" runat="server" class="flex-container-sm">
                                                    <span>
                                                        <asp:CheckBox ID="chkShowTodaysFollowUps" runat="server" meta:resourcekey="chk_Outbreak_Contact_FollowUps" AutoPostBack="true" />
                                                    </span>
                                                    <div class="divider-panel">&nbsp;</div>
                                                    <div class="form-group has-feedback has-clear">
                                                        <div class="input-group">
                                                            <asp:TextBox ID="obmtxtstrQuickContactSearch" runat="server" ClientIDMode="Static" MaxLength ="20" CssClass="form-control" Height="35px" meta:resourcekey="txt_Outbreak_Query" AutoPostBack="false"></asp:TextBox>
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton id="btnContactSearch" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                        </div>
                                        <div class="row">
                                            <asp:UpdatePanel runat="server" ID="upContacts" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <eidss:GridView 
                                                            ID="gvContacts" 
                                                            runat="server" 
                                                            AllowPaging="True" 
                                                            AllowSorting="True" 
                                                            AutoGenerateColumns="False" 
                                                            CaptionAlign="Bottom" 
                                                            CssClass="table table-striped table-hover" 
                                                            DataKeyNames="OutbreakCaseContactUID" 
                                                            GridLines="None" 
                                                            EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                            UseAccessibleHeader="false" 
                                                            ShowHeader="true" 
                                                            ShowHeaderWhenEmpty="true">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <FooterStyle HorizontalAlign="Right" />
                                                        <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
                                                        <PagerStyle CssClass="table-striped-pager" />
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="31">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnbEditContact" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("OutbreakCaseContactUID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="ContactedHumanCasePersonID" HeaderText="<%$ Resources: Grd_Outbreak_Contact_ID_Heading %>" />
                                                            <asp:BoundField DataField="Name" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Name_Heading %>" />
                                                            <asp:BoundField DataField="Gender" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Gender_Heading %>" />
                                                            <asp:BoundField DataField="DateOfLastContact" HeaderText="<%$ Resources: Grd_Outbreak_Date_Last_Contact_Heading %>" />
                                                            <asp:BoundField DataField="ContactStatus" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Status_Heading %>" />
                                                            <asp:BoundField DataField="CurrentLocation" HeaderText="<%$ Resources: Grd_Outbreak_Contact_CurrentLocation_Heading %>" />
                                                        </Columns>
                                                    </eidss:GridView>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                    </div>
                                    <div id="nav-updates" class="tab-pane" role="tabpanel" aria-labelledby="nav-transferred-samples-tab">
                                        <div class="row">
                                            <div class="flex-container-sm">
                                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                    <asp:Button ID="btnCreateUpdate" CssClass="btn btn-primary" runat="server"  meta:resourcekey="Btn_Create" OnClick="btnCreateUpdate_Click"/>
                                                </div>
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10 text-right">
                                                    <asp:LinkButton ID="lnbPrint" runat="server" CssClass="btn btn-primary btn-md" CausesValidation="false">
                                                        <span class="glyphicon glyphicon-print" aria-hidden="true"></span>
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:Repeater runat="server" ID="rOutbreakSessionNotes">
                                            <HeaderTemplate>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="row">
                                                    <div class="flex-container-sm">
                                                        <div class="divider-panel-sm-left"></div>
                                                        <div class='divider-panel-no-margin outbreakNoteAlter<%#Eval("UpdatePriority")%>'>&nbsp;</div>
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 outbreakNoteContainer-left">
                                                            <div class="outbreakNoteContainer-inside">
                                                                <div class="row">
                                                                    Record #<%#Eval("NoteRecordUID") %></div>
                                                                <div class="row">
                                                                    <%#Eval("UserName") %> | <%#Eval("Organization") %>
                                                                </div>
                                                                <div class="row">
                                                                    <%#Eval("datNoteDate") %>
                                                                </div>
                                                                <div class="row">
                                                                </div>
                                                                <div class="row">
                                                                    <asp:ImageButton ID="ibDelete" runat="server" ImageUrl="~/Includes/Images/red-invertered-X-sm.png" OnDataBinding="ItemNoteBinding_OnDataBinding" CommandName="Delete" CommandArgument='<%#Eval("idfPerson")%>' outbreakNoteId='<%#Eval("idfOutbreakNote")%>' />
                                                                    <asp:HyperLink ID="hlView" runat="server" Text='<%#Eval("FileView") %>' OnDataBinding="ItemNoteBinding_OnDataBinding" CommandName="View" CommandArgument='<%#Eval("idfPerson")%>' target="_blank" NavigateUrl='<%#Eval("idfOutbreakNote", "NoteFileDownload.aspx?idfOutbreakNote={0}&download=false")%>'></asp:HyperLink>
                                                                    <asp:HyperLink ID="hlDownload" runat="server" Text='<%#Eval("FileView") %>' OnDataBinding="ItemNoteBinding_OnDataBinding" CommandName="Download" CommandArgument='<%#Eval("idfPerson")%>' NavigateUrl='<%#Eval("idfOutbreakNote", "NoteFileDownload.aspx?idfOutbreakNote={0}&download=true")%>'></asp:HyperLink>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="divider-panel-outbreak-note">&nbsp;</div>
                                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10 outbreakNoteContainer-right">
                                                            <div class="outbreakNoteContainer-inside">
                                                                <asp:Label runat="server" Text='<%# Eval("UpdateRecordTitle") %>'></asp:Label><br />
                                                                <asp:Label runat="server" Text='<%# Eval("strNote") %>'></asp:Label>
                                                            </div>
                                                            <div class="text-right">
                                                                <asp:LinkButton ID="lnbEditNote" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<%#Eval("idfPerson")%>' outbreakNoteId='<%#Eval("idfOutbreakNote")%>' CausesValidation="false" meta:resourceKey="btn_Edit" OnDataBinding="ItemNoteBinding_OnDataBinding" OnClick="lnbEditNote_Click" ></asp:LinkButton>
                                                            </div>
                                                        </div>
                                                        <div class="divider-panel-sm-right"></div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                    <div id="nav-analysis" class="tab-pane" role="tabpanel" aria-labelledby="nav-my-favorite-samples-tab">
                                            
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    </asp:Panel>
                    <asp:Panel ID="pOutbreakCaseCreation" runat="server" CssClass="row" Visible="false">
                        <div id="outbreakCaseCreation" runat="server" class="row">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h2 runat="server" meta:resourcekey="hdg_Outbreak_Management"></h2>
                                </div>
                            </div>
                            <div class="panel-body">
                                <fieldset>
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 embed-panel" id="dCaseDetails" runat="server">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 class="heading" id="H2" meta:resourcekey="Hdg_Outbreak_Case_Summary" runat="server"> - ######</h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 class="sub-header" id="H3" meta:resourcekey="lbl_Case_Details" runat="server"></h4>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-md-3">
                                                    <label runat="server" ID="lblPersonFarmEIDSSId"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lblEIDSSId" />
                                                    </div>
	                                            </div>
                                                <div class="col-md-3">
                                                    <label  runat="server" meta:resourcekey="lbl_Person"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lblPerson" />
                                                    </div>
                                                </div>
                                            </div>
                                            <hr class="section-hr"/>
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 class="sub-header" id="H4" meta:resourcekey="lbl_Outbreak_Details" runat="server"></h4>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-md-3">
		                                            <label runat="server" meta:resourcekey="lbl_Outbreak_ID"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lb2strOutbreakId" />
                                                    </div>
	                                            </div>
	                                            <div class="col-md-3">
                                                    <label runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lb2datStartDate"/>
                                                    </div>
	                                            </div>
	                                            <div class="col-md-3">
                                                    <label runat="server" meta:resourcekey="lbl_End_Date"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lb2datCloseDate" />
                                                    </div>
	                                            </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-md-3">
		                                            <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lb2strDiagnosis" />
                                                    </div>
	                                            </div>
	                                            <div class="col-md-3">
                                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Status"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lb2strOutbreakStatus" />
                                                    </div>
	                                            </div>
	                                            <div class="col-md-3">
                                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Type"></label>
                                                    <div class="panel panel-default">
                                                        <asp:Label runat="server" id="lb2strOutbreakType" />
                                                    </div>
	                                            </div>
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                        </div>
                    </asp:Panel>
                    <div id="humanDisease" class="col-lg-12 col-md-12 col-sm-12 col-xs-12 embed-panel" runat="server">
                        <div class="row">
                            <div class="sectionContainer expanded">
                                <section id="diseaseNotification" runat="server" class="col-md-12">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H5" meta:resourcekey="Hdg_Notification" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pull-left">
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-md-4">
                                                    <label runat="server" meta:resourcekey="lbl_Date_Of_Notification"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-4">
                                                    <eidss:CalendarInput ID="ciDateOfNotification" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"  ClientIDMode="Static"></eidss:CalendarInput>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Sent_By_Facility"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="tx2NotificationSentByFacility" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" onkeyup="javascript:enableNotifiationName(this,'txtNotificationSentByName')"  />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="bNotificationSentByFacility" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="tx2NotificationSentByFacility" OnClick="SearchOrganization_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Sent_By_Name"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtNotificationSentByName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="false" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imNotificationSentByName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtNotificationSentByName" OnClick="SearchEmployee_Click" Enabled="false" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_By_Facility"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtNotificationReceivedByFacility" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" onkeyup="javascript:enableNotifiationName(this,'txtNotificationReceivedByName')" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imNotificationReceivedByFacility" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtNotificationReceivedByFacility" OnClick="SearchOrganization_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_By_Name"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtNotificationReceivedByName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="false" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imNotificationReceivedByName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtNotificationReceivedByName" OnClick="SearchEmployee_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="caseLocation" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H13" meta:resourcekey="Hdg_Location" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <eidss:LocationUserControl ID="lucCaseLocation" runat="server" IsHorizontalLayout="true" ShowElevation="false" ShowCountry="False" SelectionNotification="True" IsDbRequiredRayon="True" IsDbRequiredRegion="True" ValidationGroup="caseLocation" />
                                </section>
                                <section id="clinicalInformation" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H6" meta:resourcekey="Hdg_Clinical_Information" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pull-left">
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Case_Status" runat="server"></div>
                                                    <label runat="server" meta:resourcekey="lbl_Case_Status"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <eidss:DropDownList ID="ddlCaseStatus" runat="server" CssClass="form-control" ValidationGroup="clinicalInformation"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator ControlToValidate="ddlCaseStatus" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Outbreak_Case_Status" runat="server" ValidationGroup="clinicalInformation" InitialValue="null"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Date_Of_Symptons_Onset" runat="server"></div>
                                                    <label runat="server" meta:resourcekey="lbl_Date_Of_Symptoms_Onset"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-8">
                                                    <eidss:CalendarInput ID="ciDateOfSymptomsOnset" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ValidationGroup="clinicalInformation" ClientIDMode="Static"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator ControlToValidate="ciDateOfSymptomsOnset" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Date_Of_Symptoms_Onset" runat="server" ValidationGroup="clinicalInformation"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_Date_Of_Disease"></label>
                                                </div>
                                                <div class="col-lg-8">
                                                    <eidss:CalendarInput ID="ciDateOfDiagnosis" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_List_Of_Symptons"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakHumanCase" />
                                                </div>
                                                <div class="col-lg-8">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_Hospitalization"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <asp:RadioButtonList ID="rblHospitalization" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"></asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:Panel ID="pHospitalization" runat="server" Visible="false">
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Hospital_Name"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <eidss:DropDownList ID="ddlHospitalName" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Date_Of_Hospitalization"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <eidss:CalendarInput ID="cidatDateOfHospitalization" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Date_Of_Discharge"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <eidss:CalendarInput ID="cidatDischargeDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_Antibiotic_Antiviral_Therapy_Administered"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <asp:RadioButtonList ID="rblAntibioticAntiviralTherapyAdministered" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"></asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:Panel ID="pAntibioticAntiviralTherapy" runat="server" Visible="false">
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Antibiotic_Antiviral_Name"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <asp:TextBox runat="server" ID="txtAntibioticAntiviralName" MaxLength ="20" CssClass="form-control" Height="35px" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Antibiotic_Antiviral_Dose"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <asp:TextBox runat="server" ID="txtAntibioticAntiviralDose" MaxLength ="20" CssClass="form-control" Height="35px" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Date_Antibiotic_Antiviral_First_Administered"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <eidss:CalendarInput ID="cidatAntibioticAntiviralFirstAdministered" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_Was_Specific_Vaccination_Administered"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <asp:RadioButtonList ID="rblWasSpecificVaccinationAdministered" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"></asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:panel ID="pVaccination" runat="server" Visible="false">
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <label runat="server" meta:resourcekey="lbl_Vaccination_Name"></label>
                                                    </div>
                                                    <div class="col-lg-4">
                                                        <label runat="server" meta:resourcekey="lbl_Date_Of_Vaccination"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <asp:TextBox runat="server" ID="txtstrVaccinationName" MaxLength ="20" CssClass="form-control" Height="35px" ClientIDMode="Static" OnKeyUp="javascript:enableVaccinationAdd()" />
                                                    </div>
                                                    <div class="col-lg-4">
                                                        <eidss:CalendarInput ID="cidatDateOfVaccination" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ClientIDMode="Static" OnChange="javascript:enableVaccinationAdd()"></eidss:CalendarInput>
                                                    </div>
                                                    <div class="col-lg-2">
                                                        <asp:Button ID="btnAddVaccination" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Add" Enabled="false" ClientIDMode="Static" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
                                                    <eidss:GridView
                                                                AllowPaging="True"
                                                                AllowSorting="True"
                                                                AutoGenerateColumns="False"
                                                                CssClass="table table-striped"
                                                                DataKeyNames="HumanDiseaseReportVaccinationUID"
                                                                EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                                GridLines="None"
                                                                ID="gvVaccinations"
                                                                runat="server"
                                                                PageSize="10"
                                                                PagerSettings-Visible="false"
                                                                ShowFooter="true"
                                                                UseAccessibleHeader="true">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <Columns>                                    
                                                            <asp:BoundField DataField="Name" ReadOnly="true"  HeaderText="<%$ Resources:  Grd_Vaccination_Name %>" />
                                                            <asp:BoundField DataField="Date" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Date %>" dataformatstring="{0:MM/dd/yyyy}" />
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnbEditSession" runat="server"  CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("HumanDiseaseReportVaccinationUID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnbDeleteSession" runat="server"  CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("HumanDiseaseReportVaccinationUID") %>' CausesValidation="false"></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Additional_Comments"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-12">
                                                        <asp:TextBox ID="txtClinicalAdditionalComments" runat="server" CssClass="form-control"  MaxLength="500" TextMode="MultiLine" Rows="5"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </asp:panel>
                                    </div>
                                </section>
                                <section id="outbreakInvestigation" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H7" meta:resourcekey="Hdg_Outbreak_Investigation" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pull-left">
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Organization" runat="server"></div>
                                                    <label runat="server" meta:resourcekey="lbl_Investigator_Organization"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtstrInvestigatorOrganization" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imgstrInvestigatorOrganization" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrInvestigatorOrganization" OnClick="SearchOrganization_Click" />
                                                        </div>
                                                    </div>
                                                    <asp:RequiredFieldValidator runat="server" ID="rfvInvestigatorOrganization" ControlToValidate="txtstrInvestigatorOrganization" CssClass="text-danger"  meta:resourceKey="Val_Investigator_Organization" Display="Dynamic" ValidationGroup="outbreakInvestigation"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Name" runat="server"></div>
                                                    <label runat="server" meta:resourcekey="lbl_Investigator_Name"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtstrInvestigatorName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" enable="false" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imInvestigatorName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrInvestigatorName" OnClick="SearchEmployee_Click" />
                                                        </div>
                                                    </div>
                                                    <asp:RequiredFieldValidator runat="server" ID="rfvInvestigatorName" ControlToValidate="txtstrInvestigatorName" CssClass="text-danger"  meta:resourceKey="Val_Investigator_Name" Display="Dynamic" ValidationGroup="outbreakInvestigation"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Starting_Date_Of_Investigation"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <eidss:CalendarInput ID="cidatStartingDateOfInvestigation" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Case_Classification"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <eidss:DropDownList ID="ddlCaseClassification" runat="server" CssClass="form-control" ValidationGroup="investigation"></eidss:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Primary_Case"></label><asp:CheckBox ID="chkPrimaryCase" runat="server" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakInvestigation" LegendHeader="This Flex Form needs to be configured." />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Additional_Comments"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <asp:TextBox runat="server" ID="txtAdditionalComments" MaxLength ="500" CssClass="form-control" ClientIDMode="Static" TextMode="MultiLine" Rows="5" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="caseMonitoring" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H8" meta:resourcekey="Hdg_Case_Monitoring" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pull-left">
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Monitoring_Date"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <eidss:CalendarInput ID="cidatMonitoringDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakCaseMonitoring" LegendHeader="This Flex Form needs to be configured." />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Additional_Comments"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <asp:TextBox runat="server" ID="tx2AdditionalComments" MaxLength="500" CssClass="form-control" ClientIDMode="Static" Rows="5" TextMode="MultiLine" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Organization" runat="server"></div>
                                                    <label runat="server" meta:resourcekey="lbl_Investigator_Organization"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="tx2MonitoringInvestigatorOrganization" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imMonitoringInvestigatorOrganization" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="tx2MonitoringInvestigatorOrganization" OnClick="SearchOrganization_Click" />
                                                        </div>
                                                    </div>
                                                    <asp:RequiredFieldValidator runat="server" ID="rfvMonitoringInvestigatorOrganization" ControlToValidate="tx2MonitoringInvestigatorOrganization" CssClass="text-danger" meta:resourceKey="Val_Investigator_Organization" Display="Dynamic" ValidationGroup="caseMonitoring"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Name" runat="server"></div>
                                                    <label runat="server" meta:resourcekey="lbl_Investigator_Name"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="tx2MonitoringInvestigatorName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="false" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imMonitoringInvestigatorName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="tx2MonitoringInvestigatorName" OnClick="SearchEmployee_Click" />
                                                        </div>
                                                    </div>
                                                    <asp:RequiredFieldValidator runat="server" ID="rfvMonitoringInvestigatorName" ControlToValidate="tx2MonitoringInvestigatorName" CssClass="text-danger" meta:resourceKey="Val_Investigator_Name" Display="Dynamic" ValidationGroup="caseMonitoring"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="contacts" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H9" meta:resourcekey="Hdg_Contacts" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
	                                        <div class="col-lg-6">
                                                <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Contact_Type" runat="server"></div>
                                                <label runat="server" meta:resourcekey="lbl_Contact_Type"></label>
                                            </div>
                                        </div>
                                        <div class="row">
	                                        <div class="col-lg-6">
                                                <asp:RadioButtonList ID="rblContactType" runat="server" RepeatDirection="Horizontal" onchange="javascript:$('#dContacts').show();" ></asp:RadioButtonList>
                                                <asp:RequiredFieldValidator ControlToValidate="rblContactType" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Contact_Type" runat="server" ValidationGroup="contacts"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="dContacts">
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Contact_Name"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtContactName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" OnKeyUp="javascript:enableContactAdd()" ReadOnly="true" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imContactName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtContactName" OnClick="SearchOrganization_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Contact_Relationship_Type"></label>
                                                </div>
                                                <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Date_Of_Last_Contact"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <eidss:DropDownList ID="ddlContactRelationshipType" runat="server" CssClass="form-control" Height="35px" ClientIDMode="Static" OnChange="javascript:enableContactAdd()"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6">
                                                    <eidss:CalendarInput ID="cidatDateOfLastContact" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ClientIDMode="Static" OnChange="javascript:enableContactAdd()"></eidss:CalendarInput>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Place_Of_Last_Contact"></label>
                                                </div>
                                                <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Contact_Status"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <asp:TextBox runat="server" ID="tx2PlaceOfLastContact" CssClass="form-control" Height="35px" ClientIDMode="Static" OnKeyUp="javascript:enableContactAdd()"></asp:TextBox>
                                                </div>
                                                <div class="col-lg-6">
                                                    <eidss:DropDownList ID="ddlContactStatus" runat="server" CssClass="form-control" Height="35px" ClientIDMode="Static" OnChange="javascript:enableContactAdd()"></eidss:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-12">
                                                    <label runat="server" meta:resourcekey="lbl_Contact_Comments"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-12">
                                                    <asp:TextBox runat="server" ID="txtstrContactComments" MaxLength="500" CssClass="form-control" Rows="5" TextMode="MultiLine" ClientIDMode="Static" OnKeyUp="javascript:enableContactAdd()"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-lg-12 pull-right">
                                                    <asp:Button ID="bBatchAddContact" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Add" Enabled="false" ClientIDMode="Static" OnClientClick="BatchAddContact" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <eidss:GridView 
                                                AllowPaging="True"
                                                AllowSorting="True"
                                                AutoGenerateColumns="False"
                                                CssClass="table table-striped"
                                                DataKeyNames="idfContactCasePerson"
                                                EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                GridLines="None"
                                                ID="gvCaseContacts"
                                                runat="server"
                                                PageSize="10"
                                                PagerSettings-Visible="false"
                                                ShowFooter="true"
                                                UseAccessibleHeader="true">
                                            <HeaderStyle CssClass="lab-table-striped-header" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
                                            <PagerStyle CssClass="table-striped-pager" />
                                            <Columns>
                                                <asp:BoundField DataField="ContactType" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Type_Heading %>" />
                                                <asp:BoundField DataField="ContactName" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Name_Heading %>" />
                                                <asp:BoundField DataField="ContactStatus" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Status_Heading %>" />
                                                <asp:BoundField DataField="Relation" HeaderText="<%$ Resources: Grd_Outbreak_Relation_Heading %>" />
                                                <asp:BoundField DataField="DateOfLastContact" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Date_Last_Contact_Heading %>" />
                                                <asp:BoundField DataField="PlaceOfLastContact" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Place_Last_Contact_Heading %>" />
                                                <asp:TemplateField ItemStyle-Width="31">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkEditContact" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("idfContactCasePerson") %>' CausesValidation="false" meta:resourceKey="btn_Edit"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </eidss:GridView>
                                    </div>
                                </section>
                                <section id="samples" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H10" meta:resourcekey="Hdg_Samples" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pull-left">
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_Samples_Collected"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-12">
                                                    <asp:RadioButtonList ID="rblSamplesCollected" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" onchange="javascript:setSamplesPage();"></asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="dSamplesNo" style="display:none">
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <label runat="server" meta:resourcekey="lbl_Reason"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <eidss:DropDownList ID="ddlReason" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="dSamplesYes" style="display:none">
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <label runat="server" meta:resourcekey="lbl_Filter_Sample_By_Disease"></label><asp:CheckBox ID="chkFilterSampleByDisease" runat="server" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Case_Sample_Type" runat="server"></div>
                                                        <label runat="server" meta:resourcekey="lbl_Sample_Type"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <eidss:DropDownList ID="ddlSampleType" runat="server" CssClass="form-control" ValidationGroup="Samples" ClientIDMode="Static" OnChange="javascript:showSamplesAdd()"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator ControlToValidate="ddlSampleType" CssClass="text-danger" InitialValue="null" Display="Dynamic" meta:resourcekey="Val_Case_Sample_Type" runat="server" ValidationGroup="samples"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <label runat="server" meta:resourcekey="lbl_Local_Sample"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <asp:TextBox runat="server" ID="txtLocalSampleID" MaxLength ="20" CssClass="form-control" Height="35px" Enabled="False" ClientIDMode="Static" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Collection_Date"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <eidss:CalendarInput ID="cidatCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <label runat="server" meta:resourcekey="lbl_Field_Collected_By_Office"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6">
                                                        <div class="input-group">
                                                            <asp:TextBox runat="server" ID="txtFieldCollectedByOffice" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" />
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton id="imFieldCollectedByOffice" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtFieldCollectedByOffice" OnClick="SearchOrganization_Click" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <label runat="server" meta:resourcekey="lbl_Field_Collected_By_Person"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6">
                                                        <div class="input-group">
                                                            <asp:TextBox runat="server" ID="txtFieldCollectedByPerson" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="false" />
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton id="imFieldCollectedByPerson" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtFieldCollectedByPerson" OnClick="SearchEmployee_Click" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <label runat="server" meta:resourcekey="lbl_Sent_Date"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
	                                                <div class="col-lg-8">
                                                        <eidss:CalendarInput ID="cidatSentDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
	                                                <div class="col-lg-6">
                                                        <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Organization" runat="server"></div>
                                                        <label runat="server" meta:resourcekey="lbl_Sent_To_Organization"></label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6">
                                                        <div class="input-group">
                                                            <asp:TextBox runat="server" ID="txtSentToOrganization" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" />
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton id="imSentToOrganization" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtSentToOrganization" OnClick="SearchOrganization_Click" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_Accession_Date"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <asp:TextBox runat="server" ID="txtAccessionDate" MaxLength ="20" CssClass="form-control" Height="35px" Enabled="False" ClientIDMode="Static" ReadOnly="true" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <label runat="server" meta:resourcekey="lbl_Sample_Condition_Received"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-8">
                                                    <asp:TextBox runat="server" ID="txtSampleConditionReceived" MaxLength ="20" CssClass="form-control" Height="35px" Enabled="False" ClientIDMode="Static" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-lg-12 pull-right">
                                                    <asp:Button ID="btnAddCaseSample" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Add" Enabled="false" ClientIDMode="Static" OnClientClick="BatchAddSample" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <eidss:GridView 
                                                    AllowPaging="True"
                                                    AllowSorting="True"
                                                    AutoGenerateColumns="False"
                                                    CssClass="table table-striped"
                                                    DataKeyNames="idfMaterial"
                                                    EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                    GridLines="None"
                                                    ID="gvCaseSamples"
                                                    runat="server"
                                                    PageSize="10"
                                                    PagerSettings-Visible="false"
                                                    ShowFooter="true"
                                                    UseAccessibleHeader="true">
                                                <HeaderStyle CssClass="lab-table-striped-header" />
                                                <FooterStyle HorizontalAlign="Right" />
                                                <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
                                                <PagerStyle CssClass="table-striped-pager" />
                                                <Columns>
                                                    <asp:BoundField DataField="SampleType" HeaderText="<%$ Resources: Grd_Sample_Type_Heading %>" />
                                                    <asp:BoundField DataField="LocalSampleID" HeaderText="<%$ Resources: Grd_Sample_Local_Sample_Id_Heading %>" />
                                                    <asp:BoundField DataField="datCollectionDate" HeaderText="<%$ Resources: Grd_Sample_Collection_Date_Heading %>" />
                                                    <asp:BoundField DataField="CollectedByInstitution" HeaderText="<%$ Resources: Grd_Sample_Collected_By_Institution_Heading %>" />
                                                    <asp:BoundField DataField="CollectedByOfficer" HeaderText="<%$ Resources: Grd_Sample_Collected_By_Officer_Heading %>" />
                                                    <asp:BoundField DataField="SentDate" HeaderText="<%$ Resources: Grd_Sample_Sent_Date_Heading %>" />
                                                    <asp:BoundField DataField="SentToOrganization" HeaderText="<%$ Resources: Grd_Sample_Sent_To_Organization_Heading %>" />
                                                    <asp:TemplateField ItemStyle-Width="31">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnkEditContact" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("idfMaterial") %>' CausesValidation="false" meta:resourceKey="btn_Edit"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                </section>
                                <section id="tests" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H12" meta:resourcekey="Hdg_Tests" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="reviewSubmit" runat="server" class="col-md-12 hidden">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H11" meta:resourcekey="Hdg_Review" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                            </div>
                            <div id="dHumanSidebarPanel" runat="server">
                                <div class="col-lg-3 pull-right">
                                    <eidss:SideBarNavigation ID="sideBarPanel_Human" runat="server">
                                        <MenuItems>
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="0" ID="sidebaritem_Case_Notification" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Disease_Notification" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="1" ID="sidebaritem_Case_Location" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Case_Location" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="2" ID="sidebaritem_Clinical_Information" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Clinical_Information" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="3" ID="sidebaritem_Outbreak_Investigation" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Outbreak_Investigation" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="4" ID="sidebaritem_Case_Monitoring" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Case_Monitoring" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="5" ID="sidebaritem_Contacts" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Contacts" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="6" ID="sidebaritem_Samples" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Samples" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="7" ID="sidebaritem_Tests" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Tests" runat="server" />
                                            <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="8" ID="sidebaritem_Review_Submit" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_ReviewSubmit" runat="server" />
                                        </MenuItems>
                                    </eidss:SideBarNavigation>
                                </div>
                                <div style="clear:both"></div>
                                <div class="row col-md-6">
                                    <input id="btnPreviousCaseEntry" type="button" runat="server" class="btn btn-default" meta:resourceKey="btn_Previous" style="display:none" onclick="goBackToPreviousPanel(); setPreviousCaseButtons(); return false;" />
                                    <input id="btnNextCaseEntry" type="button" runat="server" class="btn btn-default" meta:resourceKey="btn_Next" onclick="goForwardToNextPanel(); setNextCaseButtons(); return false;" />
                                    <asp:Button ID="btnSubmitCaseEntry" runat="server"  class="btn btn-primary" meta:resourceKey="btn_Submit" OnClick="btnSubmitCaseEntry_Click" CausesValidation="true" ValidationGroup="CaseCreation" ClientIDMode="Static" />
                                    <asp:Button ID="btnCancelCaseEntry" runat="server"  class="btn btn-default" meta:resourceKey="btn_Cancel" OnClientClick="javascript:gototab(0)" OnClick="btnCancelOutbreak_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="veterinaryDisease" runat="server" class="col-lg-14">
                        <div class="sectionContainer expanded">
                            <section id="vetNotifications" runat="server">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H14" meta:resourcekey="Hdg_Notification" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pull-left">
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-md-4">
                                                    <label runat="server" meta:resourcekey="lbl_Date_Of_Notification"></label>
                                                </div>
                                            </div>
                                            <div class="row">
	                                            <div class="col-lg-4">
                                                    <eidss:CalendarInput ID="cidatVetNotificationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ClientIDMode="Static" OnChange='javascript:$("#rvciVetdatStartingDateOfInvestigation").attr("MinimumValue",$(this).val())'></eidss:CalendarInput>
                                                    <asp:RangeValidator ID="rvcidatVetNotificationDate" runat="server" ControlToValidate="cidatVetNotificationDate" CssClass="text-danger" Type="Date" Display="Dynamic" meta:resourcekey="Val_Vet_Notification_Date_Range" ValidationGroup="vetNotifications"></asp:RangeValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Sent_By_Facility"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtstrVetNotificationSentByFacilty" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" onkeyup="javascript:enableNotifiationName(this,'txtstrVetNotificationSentByName')"  />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imVetNotificationSentByFacilty" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrVetNotificationSentByFacilty" OnClick="SearchOrganization_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Sent_By_Name"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtstrVetNotificationSentByName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="false" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imVetNotificationSentByName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrVetNotificationSentByName" OnClick="SearchEmployee_Click" Enabled="false" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_By_Facility"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtstrVetNotificationReceivedByFacilty" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" onkeyup="javascript:enableNotifiationName(this,'txtstrVetNotificationReceivedByName')" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imVetNotificationReceivedByFacilty" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrVetNotificationReceivedByFacilty" OnClick="SearchOrganization_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
	                                            <div class="col-lg-6">
                                                    <label runat="server" meta:resourcekey="lbl_Notification_Received_By_Name"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <div class="input-group">
                                                        <asp:TextBox runat="server" ID="txtstrVetNotificationReceivedByName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="false" />
                                                        <div class="input-group-addon">
                                                            <asp:ImageButton id="imVetNotificationReceivedByName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrVetNotificationReceivedByName" OnClick="SearchEmployee_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="vetLocation" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                            <h3 class="heading" id="H15" meta:resourcekey="Hdg_Location" runat="server"></h3>
                                        </div>
                                    </div>
                                </div>
                                    <div class="panel-body">
                                        <eidss:LocationUserControl ID="ucVetCaseLocation" runat="server" IsHorizontalLayout="true" ShowElevation="false" ShowCountry="True" ShowPostalCode="false" SelectionNotification="True" IsDbRequiredRayon="True" IsDbRequiredRegion="True" ValidationGroup="vetLocation" />
                                    </div>
                                </div>
                            </section>
                            <section id="vetHerdFlockSpeciesInfo" runat="server" class="col-md-14 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H26" meta:resourcekey="Hdg_Speices_Information" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
	                                        <div class="col-lg-6">
                                                <fieldset>
                                                    <legend runat="server" meta:resourcekey="lbl_Type_Of_Case"><div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Case_Type" runat="server"></div></legend>
                                            	    <div class="form-group">
                                            	        <div class="row formatRadioButtonList">
                                                            <asp:RadioButtonList ID="rblidfsCaseType" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="VetTypeOfCase_OnSelectedIndexChanged" ></asp:RadioButtonList>
                                                            <asp:RequiredFieldValidator ControlToValidate="rblidfsCaseType" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Type_Of_Case" runat="server" ValidationGroup="vetHerdFlockSpeciesInfo"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </div>
                                        </div>
                                        <div class="float-right table-btn">
                                            <div class="row">
                                                <asp:Button ID="btnVetAddHerd" runat="server" meta:resourceKey="btn_Add" CssClass="btn-sm btn-default" OnClick="btnVetAddHerd_Click" Visible="False" />
                                                <asp:Button ID="btnVetUpdateSpecies" runat="server" meta:resourceKey="btn_Update_Records" CssClass="btn-sm btn-default" Visible="False" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <eidss:GridView
                                                        AllowPaging="True"
                                                        AllowSorting="True"
                                                        AutoGenerateColumns="False"
                                                        CssClass="table table-striped div-table"
                                                        DataKeyNames="idfHerdActual"
                                                        EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                        GridLines="None"
                                                        ID="gvHerds"
                                                        runat="server"
                                                        PageSize="10"
                                                        PagerSettings-Visible="false"
                                                        ShowFooter="true"
                                                        UseAccessibleHeader="true"
                                                        ClientIDMode="Static">
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="100%">
                                                        <HeaderTemplate>
                                                            <div class="col-lg-2">
                                                                <asp:label ID="lblVetHerdCode" runat="server" meta:resourceKey="Grd_Outbreak_Herd_Code_Heading"></asp:label>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <asp:label ID="lblVetSpecies" runat="server" meta:resourceKey="Grd_Outbreak_Species_Type_Heading"></asp:label>
                                                            </div>
                                                            <div class="col-lg-1"></div>
                                                            <div class="col-lg-1">
                                                                <asp:label ID="lblVetTotalAnimalQty" runat="server" meta:resourceKey="Grd_Outbreak_Total_Animal_Qty_Heading"></asp:label>
                                                            </div>
                                                            <div class="col-lg-1">
                                                                <asp:label id="lblVetDeadAnimalQty" runat="server" meta:resourceKey="Grd_Outbreak_Dead_Animal_Qty_Heading"></asp:label>
                                                            </div>
                                                            <div class="col-lg-1">
                                                                <asp:label id="lblVetSickAnimalQty" runat="server" meta:resourceKey="Grd_Outbreak_Sick_Animal_Qty_Heading"></asp:label>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <asp:label id="lblVetStartOfSignsDate" runat="server" meta:resourceKey="Grd_Outbreak_Start_Of_Signs_Date_Heading"></asp:label>
                                                            </div>
                                                            <div class="col-lg-2">
                                                                <asp:label id="lblVetNote" runat="server" meta:resourceKey="Grd_Outbreak_Note_Heading"></asp:label>
                                                            </div>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <div class="row">
                                                                <div class="col-lg-2">
                                                                    <asp:Label runat="server" ID="txtstrHerdCode" Text='<% #Eval("strHerdCode") %>' CssClass="form-control"></asp:Label>
                                                                    <asp:HiddenField ID="idfHerdActual" runat="server" Value='<%#Eval("idfHerdActual") %>' />
                                                                    <asp:HiddenField ID="idfHerd" runat="server" Value='<%#Eval("idfHerd") %>' />
                                                                </div>
                                                                <div class="col-lg-2">
                                                                    <asp:Label ID="lblAddSpeciesToHerd" runat="server" CssClass="form-control" meta:resourceKey="Lbl_Vet_Add_Species"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-1">
                                                                    <asp:LinkButton ID="lbAddSpecies" runat="server"  CssClass="btn glyphicon glyphicon-plus" CommandName="Update" CommandArgument='<% #Eval("idfHerdActual") & "|" & Eval("idfHerd") %>' CausesValidation="false"></asp:LinkButton>
                                                                </div>
                                                                <div class="col-lg-1">
                                                                    <asp:Label runat="server" ID="txtintTotalAnimalQty" Text='<% #Eval("intTotalAnimalQty") %>' CssClass="form-control"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-1">
                                                                    <asp:Label runat="server" ID="txtintDeadAnimalQty" Text='<% #Eval("intDeadAnimalQty") %>' CssClass="form-control"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-1">
                                                                    <asp:Label runat="server" ID="txtintSickAnimalQty" Text='<% #Eval("intSickAnimalQty") %>' CssClass="form-control"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <eidss:GridView
                                                                            AllowPaging="False"
                                                                            AllowSorting="False"
                                                                            AutoGenerateColumns="False"
                                                                            CssClass="table table-striped  div-table"
                                                                            DataKeyNames="idfSpeciesActual"
                                                                            EmptyDataText=""
                                                                            GridLines="None"
                                                                            ID="gvSpecies"
                                                                            runat="server"
                                                                            PageSize="10"
                                                                            PagerSettings-Visible="false"
                                                                            ShowFooter="False"
                                                                            UseAccessibleHeader="False"
                                                                            OnRowDataBound="gvSpecies_RowDataBound"
                                                                            OnRowCommand="gvSpecies_RowCommand"
                                                                            ClientIDMode="Static">
                                                                    <Columns>
                                                                        <asp:TemplateField>
                                                                            <ItemTemplate>
                                                                                <div class="row">
                                                                                    <div class="col-lg-2">
                                                                                        <asp:HiddenField ID="idfSpeciesActual" runat="server" Value='<%# Bind("idfSpeciesActual") %>' />
                                                                                        <asp:HiddenField ID="idfSpecies" runat="server" Value='<%# Bind("idfSpecies") %>' />
                                                                                    </div>
                                                                                    <div class="col-lg-2">
                                                                                        <eidss:DropDownList ID="ddlVetSpeciesType" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                                                    </div>
                                                                                    <div class="col-lg-1">
                                                                                        <asp:LinkButton ID="lnbDeleteSession" runat="server"  CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<%# Bind("idfSpeciesActual") %>' CausesValidation="false"></asp:LinkButton>
                                                                                    </div>
                                                                                    <div class="col-lg-1">
                                                                                        <eidss:NumericSpinner ID="intTotalAnimalQty" runat="server" CssClass="form-control" Text='<% #Bind("intTotalAnimalQty") %>' MinValue="0" RepeatedItem="true"></eidss:NumericSpinner>
                                                                                    </div>
                                                                                    <div class="col-lg-1">
                                                                                        <eidss:NumericSpinner ID="intDeadAnimalQty" runat="server" CssClass="form-control" Text='<% #Bind("intDeadAnimalQty") %>' MinValue="0" RepeatedItem="true"></eidss:NumericSpinner>
                                                                                    </div>
                                                                                    <div class="col-lg-1">
                                                                                        <eidss:NumericSpinner ID="intSickAnimalQty" runat="server" CssClass="form-control" Text='<% #Bind("intSickAnimalQty") %>' MinValue="0" RepeatedItem="true"></eidss:NumericSpinner>
                                                                                    </div>
                                                                                    <div class="col-lg-2">
                                                                                        <eidss:CalendarInput ID="datStartOfSignsDate" runat="server" Text='<% #Bind("datStartOfSignsDate") %>' ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ></eidss:CalendarInput>
                                                                                    </div>
                                                                                    <div class="col-lg-2">
                                                                                        <asp:TextBox ID="strNote" runat="server" Text='<% #Bind("strNote") %>' CssClass="form-control"></asp:TextBox>
                                                                                    </div>
                                                                                </div>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </eidss:GridView>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="vetClinicalInformation" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                            <h3 class="heading" id="H17" meta:resourcekey="Hdg_Clinical_Information" runat="server"></h3>
                                        </div>
                                    </div>
                                </div>
                                    <div class="panel-heading">
                                        <div class="panel-body">
                                            <div class="row">
                                                <eidss:GridView
                                                            AllowPaging="True"
                                                            AllowSorting="True"
                                                            AutoGenerateColumns="False"
                                                            CssClass="table table-striped"
                                                            DataKeyNames="idfsClinical"
                                                            EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                            GridLines="None"
                                                            ID="gvClinicalInvestigations"
                                                            runat="server"
                                                            PageSize="10"
                                                            PagerSettings-Visible="false"
                                                            ShowFooter="true"
                                                            UseAccessibleHeader="true">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <Columns>
                                                        <asp:TemplateField ItemStyle-Width="100%">
                                                            <HeaderTemplate>
                                                                <div class="col-lg-2">
                                                                    <asp:label ID="lblClinicalSpecies" runat="server" meta:resourceKey="Grd_Outbreak_Species_Heading"></asp:label>
                                                                </div>
                                                                <div class="col-lg-2">
                                                                    <asp:label ID="lblClinicalStatus" runat="server" meta:resourceKey="Grd_Outbreak_Status_Heading"></asp:label>
                                                                </div>
                                                                <div class="col-lg-6">
                                                                    <asp:label ID="lblClinicalInvestigationPerformed" runat="server" meta:resourceKey="Grd_Outbreak_INvestigation_Performed_Heading"></asp:label>
                                                                </div>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <div class="row">
                                                                    <div class="col-lg-2">
                                                                        <asp:TextBox runat="server" ID="txtHerdSpeciesName" Text='<% #Eval("SpeciesType") %>' CssClass="form-control"></asp:TextBox>
                                                                        <asp:HiddenField ID="hdnClinical" runat="server" Value='<%#Eval("idfsClinical") %>' />
                                                                    </div>
                                                                    <div class="col-lg-2">
                                                                        <eidss:DropDownList ID="ddlClinicalStatus" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                                    </div>
                                                                    <div class="col-lg-6">
                                                                        <asp:RadioButtonList ID="rblClinicalInvestigationPerformed" runat="server" AutoPostBack="true" RepeatDirection="Horizontal" idfsClinical='<%#Eval("idfsClinical") %>' OnSelectedIndexChanged="VetClinicalInvestigationPerformed">
                                                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                                                            <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                                                            <asp:ListItem Text="Unknown" Value="2"></asp:ListItem>
                                                                        </asp:RadioButtonList>
                                                                    </div>
                                                                    <div class="col-lg-1">
                                                                        <span class="glyphicon glyphicon-triangle-bottom" style="cursor:pointer" onclick="showVSSSubGrid(event,'divVSS<%#Eval("idfsClinical") %>');"></span>
                                                                    </div>
                                                                </div>
                                                                <tr id="divVSS<%# Eval("idfsClinical") %>" style="display: none;">
                                                                    <td>
                                                                        <asp:UpdatePanel ID="upOutbreakClinicalVetCase" runat="server" UpdateMode="Conditional">
                                                                            <ContentTemplate>
                                                                                <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakClinicalVetCase" idfsClinical='<%#Eval("idfsClinical") %>' />
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </eidss:GridView>
                                            </div>
                                        </div>
                                        <div id="dVetAnimalInvestigation" runat="server">
                                            <div class="row">
                                                <asp:Label ID="lblVCIAnimalInvestigation" runat="server" meta:resourceKey="Lbl_Outbreak_VCI_Animal_Investigation"></asp:Label>
                                            </div>
                                            <div class="panel-body">
                                                <div class="row">
                                                    <div class="col-lg-3">
                                                        <asp:label ID="lblVCIHerdId" runat="server" meta:resourceKey="Lbl_Vet_Herd_Id"></asp:label>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <asp:label ID="lblVCISpecies" runat="server" meta:resourceKey="Lbl_Vet_Species"></asp:label>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <asp:label ID="lblVCIAnimalId" runat="server" meta:resourceKey="Lbl_Vet_Animal_Id"></asp:label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <asp:UpdatePanel ID="upAnimalinvestigationHerdSpecies" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>
                                                            <div class="col-lg-3">
                                                                <eidss:DropDownList ID="ddlVCIHerdID" runat="server" class="form-control"></eidss:DropDownList>
                                                            </div>
                                                            <div class="col-lg-3">
                                                                <eidss:DropDownList ID="ddlVCISpecies" runat="server" class="form-control"></eidss:DropDownList>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <div class="col-lg-3">
                                                        <asp:TextBox ID="txtVCIAnimalID" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-3">
                                                        <asp:label ID="lblVCIAge" runat="server" meta:resourceKey="Lbl_Vet_Age"></asp:label>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <asp:label ID="lblVCISex" runat="server" meta:resourceKey="Lbl_Vet_Sex"></asp:label>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <asp:label ID="lblVCIStatus" runat="server" meta:resourceKey="Lbl_Vet_Status"></asp:label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-3">
                                                        <eidss:DropDownList ID="ddlVCIAge" runat="server" class="form-control"></eidss:DropDownList>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <eidss:DropDownList ID="ddlVCISex" runat="server" class="form-control"></eidss:DropDownList>
                                                    </div>
                                                    <div class="col-lg-3">
                                                        <eidss:DropDownList ID="ddlVCIStatus" runat="server" class="form-control"></eidss:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6">
                                                        <asp:label ID="lblVCINote" runat="server" meta:resourceKey="Lbl_Vet_Note"></asp:label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-9">
                                                        <asp:TextBox ID="txtVCINote" runat="server" CssClass="form-control" Rows="5" TextMode="MultiLine"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-2">
                                                        <asp:label ID="lblVCISigns" runat="server" meta:resourceKey="Lbl_Vet_Signs"></asp:label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-3">
                                                        <asp:RadioButtonList ID="rblVCISigns" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"></asp:RadioButtonList>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <asp:UpdatePanel ID="upOutbreakAnimalInvestigation" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakAnimalInvestigation" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-2">
                                                    <asp:Button ID="btnVCIClear" runat="server" CssClass="form-control btn-default" meta:resourceKey="btn_Clear" />
                                                </div>
                                                <div class="col-lg-2">
                                                    <asp:Button ID="btnVCICopy" runat="server" CssClass="form-control btn-default" meta:resourceKey="btn_Copy" />
                                                </div>
                                                <div class="col-lg-2">
                                                    <asp:Button ID="btnVCIPaste" runat="server" CssClass="form-control btn-default" meta:resourceKey="btn_Paste" />
                                                </div>
                                                <div class="col-lg-2">
                                                    <asp:Button ID="btnVCIAdd" runat="server" CssClass="form-control btn-default" meta:resourceKey="btn_Add" />
                                                </div>
                                                <div class="col-lg-2">
                                                    <asp:Button ID="btnVCIDelete" runat="server" CssClass="form-control btn-default" meta:resourceKey="btn_Delete" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <eidss:GridView
                                                            AllowPaging="True"
                                                            AllowSorting="True"
                                                            AutoGenerateColumns="False"
                                                            CssClass="table table-striped"
                                                            DataKeyNames="idfsClinical"
                                                            EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                            GridLines="None"
                                                            ID="gvAnimalInvestigation"
                                                            runat="server"
                                                            PageSize="10"
                                                            PagerSettings-Visible="false"
                                                            ShowFooter="true"
                                                            UseAccessibleHeader="true">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <Columns>
                                                        <asp:BoundField DataField="HerdCode" HeaderText="<%$ Resources: Grd_Outbreak_VCI_Herd_Id_Heading %>" />
                                                        <asp:BoundField DataField="SpeciesType" HeaderText="<%$ Resources: Grd_Outbreak_VCI_Species_Heading %>" />
                                                        <asp:BoundField DataField="strAnimalId" HeaderText="<%$ Resources: Grd_Outbreak_VCI_Animal_Id_Heading %>" />
                                                        <asp:BoundField DataField="Age" HeaderText="<%$ Resources: Grd_Outbreak_VCI_Age_Heading %>" />
                                                        <asp:BoundField DataField="Sex" HeaderText="<%$ Resources: Grd_Outbreak_VCI_Sex_Heading %>" />
                                                        <asp:BoundField DataField="Status" HeaderText="<%$ Resources: Grd_Outbreak_VCI_Status_Heading %>" />
                                                        <asp:BoundField DataField="Note" HeaderText="<%$ Resources: Grd_Outbreak_VCI_Note_Heading %>" />
                                                    </Columns>
                                                </eidss:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="vetVaccinationInformation" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H18" meta:resourcekey="Hdg_Vaccination_Information" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body" id="dVetVaccinationInformationForm" runat="server">
                                        <div class="row">
                                            <div class="col-lg-3">
                                                <asp:label id="lblVetVaccinationDiseaseName" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Disease_Name"></asp:label>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:label id="lblVetVaccinationDate" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Date"></asp:label>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:label id="lblVetVaccinationSpecies" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Species"></asp:label>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:label id="lblVetVaccinationVaccinated" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Vaccinated"></asp:label>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-3">
                                                <eidss:DropDownList ID="ddlVetVaccinationDiseaseName" runat="server" CssClass="form-control" AutoPostBack="true"></eidss:DropDownList>
                                            </div>
                                            <div class="col-lg-3">
                                                <eidss:CalendarInput ID="ciVetVaccinationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ClientIDMode="Static"></eidss:CalendarInput>
                                                <asp:RangeValidator ID="rvciVetVaccinationDate" runat="server" ControlToValidate="ciVetVaccinationDate" CssClass="text-danger" Type="Date" Display="Dynamic" meta:resourcekey="Val_Vet_Vaccination_Date_Range" ValidationGroup="vetVaccinationInformation"></asp:RangeValidator>
                                            </div>
                                            <div class="col-lg-3">
                                                <eidss:DropDownList ID="ddlVetVaccinationSpecies" runat="server" CssClass="form-control"></eidss:DropDownList>
                                            </div>
                                            <div class="col-lg-3">
                                                <eidss:NumericSpinner ID="nsVetVaccinationVaccinated" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                            </div>
 
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-3">
                                                <asp:label id="lblVetVaccinationType" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Type"></asp:label>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:label id="lblVetVaccinationRoute" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Route"></asp:label>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:label ID="lblVetVaccinationLotNumber" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Lot_Number"></asp:label>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:label ID="lblVetVaccinationManufacturer" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Manufacturer"></asp:label>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-3">
                                                <eidss:DropDownList ID="ddlVetvaccinationType" runat="server" CssClass="form-control"></eidss:DropDownList>
                                            </div>
                                            <div class="col-lg-3">
                                                <eidss:DropDownList ID="ddlVetVaccinationRoute" runat="server" CssClass="form-control"></eidss:DropDownList>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:TextBox ID="txtVetVaccinationLotNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="col-lg-3">
                                                <asp:TextBox ID="txtVetVaccinationManufacturer" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <asp:label ID="lblVetVaccinationComments" runat="server" meta:resourcekey="lbl_Outbreak_Vet_Vaccination_Comments"></asp:label>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <asp:TextBox ID="txtVetVaccinationComments" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <asp:Button ID="btnVetVaccinationAdd" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Add" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <eidss:GridView
                                                        AllowPaging="True"
                                                        AllowSorting="True"
                                                        AutoGenerateColumns="False"
                                                        CssClass="table table-striped"
                                                        DataKeyNames="idfVetVaccination"
                                                        EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                        GridLines="None"
                                                        ID="gvVetVaccinations"
                                                        runat="server"
                                                        PageSize="10"
                                                        PagerSettings-Visible="false"
                                                        ShowFooter="true"
                                                        UseAccessibleHeader="true">
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <Columns>                                    
                                                    <asp:BoundField DataField="Name" ReadOnly="true"  HeaderText="<%$ Resources:  Grd_Vaccination_Disease_Name %>" />
                                                    <asp:BoundField DataField="Date" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Date %>" />
                                                    <asp:BoundField DataField="Species" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Species %>" />
                                                    <asp:BoundField DataField="NumberVaccinated" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Vaccinated %>" />
                                                    <asp:BoundField DataField="Type" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Type %>" />
                                                    <asp:BoundField DataField="Route" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Route %>" />
                                                    <asp:BoundField DataField="LotNumber" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Lot_Number %>" />
                                                    <asp:BoundField DataField="Manufacturer" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Manufacturer %>" />
                                                    <asp:BoundField DataField="Comments" ReadOnly="true" HeaderText="<%$ Resources:  Grd_Vaccination_Comments %>" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnbEditSession" runat="server"  CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("idfVetVaccination") %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnbDeleteSession" runat="server"  CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfVetVaccination") %>' CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="VetOutbreakInvestigation" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
	                                    <div class="row">
		                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
			                                    <h3 class="heading" id="H16" meta:resourcekey="Hdg_Outbreak_Investigation" runat="server"></h3>
		                                    </div>
	                                    </div>
                                    </div>
                                    <div class="pull-left">
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Organization" runat="server"></div>
				                                    <label runat="server" meta:resourcekey="lbl_Investigator_Organization"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="input-group">
					                                    <asp:TextBox runat="server" ID="txtstrVetInvestigatorOrganization" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" />
					                                    <div class="input-group-addon">
						                                    <asp:ImageButton id="imgstrVetInvestigatorOrganization" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrVetInvestigatorOrganization" OnClick="SearchOrganization_Click" />
					                                    </div>
				                                    </div>
				                                    <asp:RequiredFieldValidator runat="server" ID="rfvVetInvestigatorOrganization" ControlToValidate="txtstrVetInvestigatorOrganization" CssClass="text-danger"  meta:resourceKey="Val_Investigator_Organization" Display="Dynamic" ValidationGroup="VetOutbreakInvestigation"></asp:RequiredFieldValidator>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Name" runat="server"></div>
				                                    <label runat="server" meta:resourcekey="lbl_Investigator_Name"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="input-group">
					                                    <asp:TextBox runat="server" ID="txtstrVetInvestigatorName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="False" />
					                                    <div class="input-group-addon">
						                                    <asp:ImageButton id="ibVetInvestigationName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtstrVetInvestigatorName" OnClick="SearchEmployee_Click" />
					                                    </div>
				                                    </div>
				                                    <asp:RequiredFieldValidator runat="server" ID="rfvVetVetInvestigatorName" ControlToValidate="txtstrVetInvestigatorName" CssClass="text-danger"  meta:resourceKey="Val_Investigator_Name" Display="Dynamic" ValidationGroup="VetOutbreakInvestigation"></asp:RequiredFieldValidator>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Starting_Date_Of_Investigation"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <eidss:CalendarInput ID="ciVetdatStartingDateOfInvestigation" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ClientIDMode="Static"></eidss:CalendarInput>
                                                    <asp:CompareValidator ID="cvciVetdatStartingDateOfInvestigation" runat="server" ControlToValidate="ciVetdatStartingDateOfInvestigation" CssClass="text-danger" ControlToCompare="cidatVetNotificationDate" Operator="GreaterThanEqual" meta:resourcekey="Val_Vet_Starting_Date_Investigation_Range"></asp:CompareValidator>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Case_Status"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <eidss:DropDownList ID="ddlidfVetCaseStatus" runat="server" CssClass="form-control" ValidationGroup="VetOutbreakInvestigation"></eidss:DropDownList>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Case_Classification"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <eidss:DropDownList ID="ddlidfVetCaseClassification" runat="server" CssClass="form-control" ValidationGroup="VetOutbreakInvestigation"></eidss:DropDownList>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Primary_Case"></label><asp:CheckBox ID="chkVetPrimaryCase" runat="server" />
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakVetInvestigation" LegendHeader="This Flex Form needs to be configured." />
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Additional_Comments"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <asp:TextBox runat="server" ID="txtVetAdditionalComments" MaxLength ="500" CssClass="form-control" ClientIDMode="Static" TextMode="MultiLine" Rows="5" />
			                                    </div>
		                                    </div>
	                                    </div>
                                    </div>
                                </div>
                            </section>
                            <section id="vetCaseMonitoring" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
	                                <div class="row">
		                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
			                                <h3 class="heading" id="H21" meta:resourcekey="Hdg_Case_Monitoring" runat="server"></h3>
		                                </div>
	                                </div>
                                </div>
                                    <div class="pull-left" id="dVetCaseMonitoringForm" runat="server">
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Monitoring_Date"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
                                                    <asp:UpdatePanel ID="upciVetdatMonitoringDate" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>
				                                            <eidss:CalendarInput ID="ciVetdatMonitoringDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" OnKeyUp="javascript:enableVetCaseMonitoringAdd()" Enabled="false" ClientIDMode="Static"></eidss:CalendarInput>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <eidss:FlexFormLoadTemplate runat="server" ID="ffOutbreakVetCaseMonitoring" LegendHeader="This Flex Form needs to be configured." />
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Additional_Comments"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <asp:TextBox runat="server" ID="tx2VetAdditionalComments" MaxLength="500" CssClass="form-control" ClientIDMode="Static" Rows="5" TextMode="MultiLine" OnKeyUp="javascript:enableVetCaseMonitoringAdd()"/>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Organization" runat="server"></div>
				                                    <label runat="server" meta:resourcekey="lbl_Investigator_Organization"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="input-group">
					                                    <asp:TextBox runat="server" ID="tx2VetMonitoringInvestigatorOrganization" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" OnKeyUp="javascript:enableVetCaseMonitoringAdd()" />
					                                    <div class="input-group-addon">
						                                    <asp:ImageButton id="imVetMonitoringInvestigatorOrganization" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="tx2VetMonitoringInvestigatorOrganization" OnClick="SearchOrganization_Click" />
					                                    </div>
				                                    </div>
				                                    <asp:RequiredFieldValidator runat="server" ID="rfvVetMonitoringInvestigatorOrganization" ControlToValidate="tx2VetMonitoringInvestigatorOrganization" CssClass="text-danger" meta:resourceKey="Val_Investigator_Organization" Display="Dynamic" ValidationGroup="caseMonitoring"></asp:RequiredFieldValidator>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Investigator_Name" runat="server"></div>
				                                    <label runat="server" meta:resourcekey="lbl_Investigator_Name"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <div class="input-group">
					                                    <asp:TextBox runat="server" ID="tx2VetMonitoringInvestigatorName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" Enabled="false" OnKeyUp="javascript:enableVetCaseMonitoringAdd()" />
					                                    <div class="input-group-addon">
						                                    <asp:ImageButton id="imVetMonitoringInvestigatorName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="tx2VetMonitoringInvestigatorName" OnClick="SearchEmployee_Click" />
					                                    </div>
				                                    </div>
				                                    <asp:RequiredFieldValidator runat="server" ID="rfvVetMonitoringInvestigatorName" ControlToValidate="tx2VetMonitoringInvestigatorName" CssClass="text-danger" meta:resourceKey="Val_Investigator_Name" Display="Dynamic" ValidationGroup="caseMonitoring"></asp:RequiredFieldValidator>
			                                    </div>
		                                    </div>
	                                    </div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <asp:Button ID="btnVetAddCaseMonitoring" runat="server" Enabled="false" CssClass="btn btn-primary" meta:resourceKey="btn_Add" OnClick="BatchAddVetCaseMonitoring" CausesValidation="true" ClientIDMode="Static" />
                                            </div>
                                        </div>
                                        <div class="panel-body">
		                                    <div class="row">
                                                <eidss:GridView 
                                                        AllowPaging="True"
                                                        AllowSorting="True"
                                                        AutoGenerateColumns="False"
                                                        CssClass="table table-striped"
                                                        DataKeyNames="idfVetCaseMonitoring"
                                                        EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                        GridLines="None"
                                                        ID="gvVetCaseMonitoring"
                                                        runat="server"
                                                        PageSize="10"
                                                        PagerSettings-Visible="false"
                                                        ShowFooter="true"
                                                        UseAccessibleHeader="true">
                                                    <HeaderStyle CssClass="lab-table-striped-header" />
                                                    <FooterStyle HorizontalAlign="Right" />
                                                    <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
                                                    <PagerStyle CssClass="table-striped-pager" />
                                                    <Columns>
                                                        <asp:BoundField DataField="datMonitoringDate" HeaderText="<%$ Resources: Grd_Outbreak_Monitoring_Date %>" DataFormatString="{0:d}" />
                                                        <asp:BoundField DataField="InvestigatorOrganization" HeaderText="<%$ Resources: Grd_Outbreak_Investigator_Organization %>" />
                                                        <asp:BoundField DataField="InvestigatorName" HeaderText="<%$ Resources: Grd_Outbreak_Investigator_Name %>" />
                                                        <asp:TemplateField ItemStyle-Width="31">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkVetDeleteCaseMonitoring" runat="server" CssClass="btn glyphicon glyphicon-trash" CommandName="Delete" CommandArgument='<% #Bind("idfVetCaseMonitoring") %>' CausesValidation="false"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-Width="31">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkVetEditCaseMonitoring" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("idfVetCaseMonitoring") %>' CausesValidation="false"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </eidss:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            <section id="vetCaseContacts" runat="server" class="col-md-12 hidden">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
	                                    <div class="row">
		                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
			                                    <h3 class="heading" id="H19" meta:resourcekey="Hdg_Contacts" runat="server"></h3>
		                                    </div>
	                                    </div>
                                    </div>
                                    <div class="panel-body">
	                                    <div class="row">
		                                    <div class="col-lg-6">
			                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="Req_Contact_Type" runat="server"></div>
			                                    <label runat="server" meta:resourcekey="lbl_Contact_Type"></label>
		                                    </div>
	                                    </div>
	                                    <div class="row">
		                                    <div class="col-lg-6">
			                                    <asp:RadioButtonList ID="rblVetContactType" runat="server" RepeatDirection="Horizontal"></asp:RadioButtonList>
			                                    <asp:RequiredFieldValidator ControlToValidate="rblVetContactType" CssClass="text-danger" Display="Dynamic" meta:resourcekey="Val_Contact_Type" runat="server" ValidationGroup="vetCaseContacts"></asp:RequiredFieldValidator>
		                                    </div>
	                                    </div>
                                    </div>
                                    <div id="dVetContacts" runat="server">
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Contact_Name"></label>
			                                    </div>
		                                    </div>
                                            <asp:UpdatePanel ID="upVetContactName" runat="server">
                                                <ContentTemplate>
		                                            <div class="row">
			                                            <div class="col-lg-6">
				                                            <div class="input-group">
					                                            <asp:TextBox runat="server" ID="tx2VetContactName" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" OnKeyUp="javascript:enableVetContactAdd()" ReadOnly="true" />
					                                            <div class="input-group-addon">
						                                            <asp:ImageButton id="imVetContactName" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="tx2VetContactName" OnClick="SearchPerson_Click" />
					                                            </div>
				                                            </div>
			                                            </div>
		                                            </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Contact_Relationship_Type"></label>
			                                    </div>
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Date_Of_Last_Contact"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <eidss:DropDownList ID="ddlVetContactRelationshipType" runat="server" CssClass="form-control" Height="35px" ClientIDMode="Static" OnChange="javascript:enableVetContactAdd()"></eidss:DropDownList>
			                                    </div>
			                                    <div class="col-lg-6">
				                                    <eidss:CalendarInput ID="ciVetdatDateOfLastContact" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" ClientIDMode="Static" OnChange="javascript:enableVetContactAdd()"></eidss:CalendarInput>
                                                    <asp:CompareValidator ID="cvciVetdatDateOfLastContact" runat="server" ControlToValidate="ciVetdatDateOfLastContact" CssClass="text-danger" ControlToCompare="ciVetdatMonitoringDate" Operator="LessThanEqual" meta:resourcekey="Val_Vet_Date_Last_Contact_Compare" ValidationGroup="vetCaseContacts"></asp:CompareValidator>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Place_Of_Last_Contact"></label>
			                                    </div>
			                                    <div class="col-lg-6">
				                                    <label runat="server" meta:resourcekey="lbl_Contact_Status"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-6">
				                                    <asp:TextBox runat="server" ID="tx2VetPlaceOfLastContact" CssClass="form-control" Height="35px" ClientIDMode="Static" OnKeyUp="javascript:enableVetContactAdd()"></asp:TextBox>
			                                    </div>
			                                    <div class="col-lg-6">
				                                    <eidss:DropDownList ID="ddlVetContactStatus" runat="server" CssClass="form-control" Height="35px" ClientIDMode="Static" OnChange="javascript:enableVetContactAdd()"></eidss:DropDownList>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-12">
				                                    <label runat="server" meta:resourcekey="lbl_Contact_Comments"></label>
			                                    </div>
		                                    </div>
		                                    <div class="row">
			                                    <div class="col-lg-12">
				                                    <asp:TextBox runat="server" ID="txtVetstrContactComments" MaxLength="500" CssClass="form-control" Rows="5" TextMode="MultiLine" ClientIDMode="Static" OnKeyUp="javascript:enableVetContactAdd()"></asp:TextBox>
			                                    </div>
		                                    </div>
	                                    </div>
	                                    <div class="panel-body">
		                                    <div class="row">
			                                    <div class="col-lg-12 pull-right">
				                                    <asp:Button ID="bBatchAddVetContact" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Add" Enabled="false" ClientIDMode="Static" OnClientClick="BatchAddContact" />
			                                    </div>
		                                    </div>
	                                    </div>
                                    </div>
                                    <div class="row">
	                                    <eidss:GridView 
			                                    AllowPaging="True"
			                                    AllowSorting="True"
			                                    AutoGenerateColumns="False"
			                                    CssClass="table table-striped"
			                                    DataKeyNames="idfContactCasePerson"
			                                    EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
			                                    GridLines="None"
			                                    ID="gvVetCaseContacts"
			                                    runat="server"
			                                    PageSize="10"
			                                    PagerSettings-Visible="false"
			                                    ShowFooter="true"
			                                    UseAccessibleHeader="true">
		                                    <HeaderStyle CssClass="lab-table-striped-header" />
		                                    <FooterStyle HorizontalAlign="Right" />
		                                    <PagerStyle CssClass="lab-table-striped-pager" HorizontalAlign="Right" />
		                                    <PagerStyle CssClass="table-striped-pager" />
		                                    <Columns>
			                                    <asp:BoundField DataField="ContactType" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Type_Heading %>" />
			                                    <asp:BoundField DataField="ContactName" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Name_Heading %>" />
			                                    <asp:BoundField DataField="ContactStatus" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Status_Heading %>" />
			                                    <asp:BoundField DataField="Relation" HeaderText="<%$ Resources: Grd_Outbreak_Relation_Heading %>" />
			                                    <asp:BoundField DataField="DateOfLastContact" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Date_Last_Contact_Heading %>" DataFormatString="{0:d}"/>
			                                    <asp:BoundField DataField="PlaceOfLastContact" HeaderText="<%$ Resources: Grd_Outbreak_Contact_Place_Last_Contact_Heading %>" />
			                                    <asp:TemplateField ItemStyle-Width="31">
				                                    <ItemTemplate>
					                                    <asp:LinkButton ID="lnkEditContact" runat="server" CssClass="btn glyphicon glyphicon-edit" CommandName="Edit" CommandArgument='<% #Bind("idfContactCasePerson") %>' CausesValidation="false" meta:resourceKey="btn_Edit"></asp:LinkButton>
				                                    </ItemTemplate>
			                                    </asp:TemplateField>
		                                    </Columns>
	                                    </eidss:GridView>
                                    </div>
                                </div>
                            </section>
                            <section id="vetCaseSamples" runat="server" class="col-md-12 hidden">
                                <asp:UpdatePanel ID="upSample" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                        <h3 runat="server" meta:resourcekey="Hdg_Samples"></h3>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                        <asp:Button ID="btnAddVetSample2" runat="server" CssClass="btn btn-primary btn-sm" meta:resourceKey="btn_Add" OnClick="AddVetSample_Click" />
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToSideBarSection(6, document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'));"></a>
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
                                                    <eidss:GridView 
                                                            ID="gvVetSamples" 
                                                            runat="server" 
                                                            AllowPaging="False" 
                                                            AllowSorting="True" 
                                                            AutoGenerateColumns="False" 
                                                            CaptionAlign="Top" 
                                                            CssClass="table table-striped" 
                                                            DataKeyNames="idfVetSample" 
                                                            EmptyDataText="<%$ Resources: Grd_Sample_List_Empty_Data %>" 
                                                            ShowHeader="true" 
                                                            ShowHeaderWhenEmpty="true" 
                                                            ShowFooter="True" 
                                                            GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                        <Columns>
                                                            <asp:BoundField DataField="Type" HeaderText="<%$ Resources: Grd_Samples_List_Sample_Type_Heading %>" />
                                                            <asp:BoundField DataField="FieldId" HeaderText="<%$ Resources: Grd_Samples_List_Field_Sample_ID_Heading %>" />
                                                            <asp:BoundField DataField="Species" HeaderText="<%$ Resources: Grd_Samples_List_Species_Heading %>" />
                                                            <asp:BoundField DataField="BirdStatus" HeaderText="<%$ Resources: Grd_Samples_List_Bird_Status_Heading %>" />
                                                            <asp:BoundField DataField="datCollectionDate" HeaderText="<%$ Resources: Grd_Samples_List_Collection_Date_Heading %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="CollectedByOrganization" HeaderText="<%$ Resources: Grd_Samples_List_Field_Collected_By_Institution_Heading %>" meta:resourcekey="Dis_Collected_By_Institution" />
                                                            <asp:BoundField DataField="CollectedByPerson" HeaderText="<%$ Resources: Grd_Samples_List_Field_Collected_By_Officer_Heading %>" meta:resourcekey="Dis_Collected_By_Officer" />
                                                            <asp:BoundField DataField="SentToOrganization" HeaderText="<%$ Resources: Grd_Samples_List_Field_Sent_To_Organization_Heading %>" meta:resourcekey="Dis_Sent_To_Organization" />
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditSample" runat="server" CommandName="Edit" CommandArgument='<% #Bind("idfVetSample") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDeleteSample" runat="server" CommandName="Delete" CommandArgument='<% #Bind("idfVetSample") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
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
                            <section id="vetPensideTests" runat="server" class="col-md-12 hidden">
                                <div class="panel-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 class="heading" id="H23" meta:resourcekey="Hdg_Penside_Tests" runat="server"></h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">
                                        <asp:Panel id="pVetPensideTest" runat="server">
                                            <div class="row">
                                                <div class="col-lg-3">
                                                    <label runat="server" meta:resourcekey="lbl_Vet_Field_Samples"></label>
                                                </div>
                                                <div class="col-lg-3">
                                                    <label runat="server" meta:resourcekey="lbl_Vet_Sample_Type"></label>
                                                </div>
                                                <div class="col-lg-3">
                                                    <label id="lb2VetSpecies" runat="server" meta:resourcekey="lbl_Vet_Species"></label>
                                                    <label id="lb2VetAnimalId" runat="server" meta:resourcekey="lbl_Vet_Animal_Id"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-3">
                                                    <asp:UpdatePanel ID="upVetPenSideFieldSampleId" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>
                                                            <eidss:DropDownList ID="ddlVetFieldSampleId" runat="server" CssClass="form-control" OnSelectedIndexChanged="VetFieldSampleId_Selected" AutoPostBack="true" ClientIDMode="Static" OnChange="javascript:enableVetPensideTestAdd()"></eidss:DropDownList>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                                <asp:UpdatePanel ID="upVetPenSideAutopopulate" runat="server">
                                                    <ContentTemplate>
                                                        <div class="col-lg-3">
                                                            <asp:TextBox ID="txtVetSampleType" runat="server" CssClass="form-control" Enabled="false" ClientIDMode="Static"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-3">
                                                            <asp:TextBox ID="txtVetSpecies" runat="server" CssClass="form-control" Enabled="false" ClientIDMode="Static"></asp:TextBox>
                                                            <asp:TextBox ID="txtVetAnimalId" runat="server" CssClass="form-control" Enabled="false" ClientIDMode="Static"></asp:TextBox>
                                                            <asp:HiddenField ID="hdnVetAnimalId" runat="server" Value="" />
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-3">
                                                    <label runat="server" meta:resourcekey="lbl_Vet_Test_Name"></label>
                                                </div>
                                                <div class="col-lg-3">
                                                    <label runat="server" meta:resourcekey="lbl_Vet_Result"></label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-3">
                                                    <eidss:DropDownList ID="ddlVetTestName" runat="server" CssClass="form-control" ClientIDMode="Static" OnChange="javascript:enableVetPensideTestAdd()"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-3">
                                                    <eidss:DropDownList ID="ddlVetResult" runat="server" CssClass="form-control" ClientIDMode="Static" OnChange="javascript:enableVetPensideTestAdd()"></eidss:DropDownList>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </div>
                                <div class="panel-body">
		                            <div class="row">
			                            <div class="col-lg-12 pull-right">
				                            <asp:Button ID="btnAddPensideText" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Add" Enabled="false" ClientIDMode="Static" OnClientClick="BatchAddPensideTest" />
			                            </div>
		                            </div>
	                            </div>
                                <div class="panel-body">
                                    <div class="table-responsive">
                                        <eidss:GridView 
                                                ID="gvVetPensideTest" 
                                                runat="server" 
                                                AllowPaging="False" 
                                                AllowSorting="True" 
                                                AutoGenerateColumns="False" 
                                                CaptionAlign="Top" 
                                                CssClass="table table-striped" 
                                                DataKeyNames="idfVetPensideTest" 
                                                EmptyDataText="<%$ Resources: Grd_Penside_List_Empty_Data %>" 
                                                ShowHeader="true" 
                                                ShowHeaderWhenEmpty="true" 
                                                ShowFooter="True" 
                                                GridLines="None">
                                            <HeaderStyle CssClass="table-striped-header" />
                                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                            <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                            <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                            <Columns>
                                                <asp:BoundField DataField="FieldSampleId" HeaderText="<%$ Resources: Grd_Vet_Field_Sample_Id_Heading %>" />
                                                <asp:BoundField DataField="SampleType" HeaderText="<%$ Resources: Grd_Vet_Sample_Type_Heading %>" />
                                                <asp:BoundField DataField="Species" HeaderText="<%$ Resources: Grd_Vet_Species_Heading %>" />
                                                <asp:BoundField DataField="strAnimalId" HeaderText="<%$ Resources: Grd_Vet_Animal_Id_Heading %>" />
                                                <asp:BoundField DataField="TestName" HeaderText="<%$ Resources: Grd_Vet_Test_Name_Heading %>" />
                                                <asp:BoundField DataField="Result" HeaderText="<%$ Resources: Grd_Vet_Result_Heading %>"/>
                                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnEditSample" runat="server" CommandName="Edit" CommandArgument='<% #Bind("idfVetPensideTest") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnDeleteSample" runat="server" CommandName="Delete" CommandArgument='<% #Bind("idfVetPensideTest") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </eidss:GridView>
                                    </div>
                                </div>
                            </section>
                            <section id="vetLabTestInterpretation" runat="server" class="col-md-12 hidden">
                                <asp:UpdatePanel ID="upTestsAndTestInterpretations" runat="server" UpdateMode="Conditional">
	                                <Triggers>
	                                </Triggers>
	                                <ContentTemplate>
		                                <div class="panel panel-default">
				                            <div class="panel-heading">
				                                <div class="row">
					                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
						                                <h3 runat="server" meta:resourcekey="Hdg_Vet_Lab_Tests_Interpretation"></h3>
					                                </div>
					                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                        <asp:Button ID="btnAddVetLabTest2" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Add" OnClientClick="AddVetLabTest_Click" />
                                                        <%--<input type="button" ID="btnAddVetLabTest" runat="server" class="btn btn-primary btn-sm" meta:resourceKey="btn_Add" />--%>
					                                </div>
				                                </div>
			                                </div>
                                            <div class="panel-body">
				                                <div class="form-group">
					                                <div class="row">
						                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							                                <label runat="server" meta:resourcekey="Lbl_Vet_Lab_Tests_Conducted"></label>
							                                <div class="btn btn-group">
								                                <asp:RadioButtonList ID="rblVetLabTestsInterpretations" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"></asp:RadioButtonList>
							                                </div>
						                                </div>
					                                </div>
				                                </div>
                                                <div class="table-responsive">
					                                <eidss:GridView 
                                                            ID="gvLabTests" 
                                                            runat="server" 
                                                            AllowPaging="False" 
                                                            AllowSorting="True" 
                                                            AutoGenerateColumns="False" 
                                                            EmptyDataText="<%$ Resources: Grd_Outbreak_List_Empty_Data %>"
                                                            CaptionAlign="Top" 
                                                            CssClass="table table-striped" 
                                                            DataKeyNames="idfLabTest" 
                                                            ShowHeader="true" 
                                                            ShowHeaderWhenEmpty="true" 
                                                            ShowFooter="True" 
                                                            GridLines="None">
						                                <HeaderStyle CssClass="table-striped-header" />
						                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
						                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
						                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
						                                <Columns>
							                                <asp:BoundField DataField="LabSampleId" HeaderText="<%$ Resources: Grd_Vet_Lab_Sample_Id_Heading %>" />
							                                <asp:BoundField DataField="SampleType" HeaderText="<%$ Resources: Grd_Vet_Lab_Sample_Type_Heading %>"  />
							                                <asp:BoundField DataField="FieldSampleId" HeaderText="<%$ Resources: Grd_Vet_Lab_Field_Sample_Id_Heading %>" />
							                                <asp:BoundField DataField="strAnimalId" HeaderText="<%$ Resources: Grd_Vet_Lab_Animal_Id_Heading %>" />
							                                <asp:BoundField DataField="Species" HeaderText="<%$ Resources: Grd_Vet_Lab_Species_Heading %>" />
							                                <asp:BoundField DataField="TestDisease" HeaderText="<%$ Resources: Grd_Vet_Lab_Test_Disease_Heading %>"  />
							                                <asp:BoundField DataField="TestName" HeaderText="<%$ Resources: Grd_Vet_Lab_Test_Name_Heading %>" />
							                                <asp:BoundField DataField="TestCategory" HeaderText="<%$ Resources: Grd_Vet_Lab_Test_Category_Heading %>" />
							                                <asp:BoundField DataField="TestStatus" HeaderText="<%$ Resources: Grd_Vet_Lab_Test_Status_Heading %>" />
							                                <asp:BoundField DataField="ResultDate" HeaderText="<%$ Resources: Grd_Vet_Lab_Result_Date_Heading %>" DataFormatString="{0:d}" />
							                                <asp:BoundField DataField="ResultObservation" HeaderText="<%$ Resources: Grd_Vet_Lab_Result_Observation_Heading %>" />
							                                <asp:TemplateField>
								                                <ItemTemplate>
									                                <div class="divDetailsContainer" style="white-space: nowrap; vertical-align: top;">
										                                <asp:UpdatePanel ID="upTestInterpretation" runat="server" UpdateMode="Conditional">
											                                <Triggers>
												                                <asp:AsyncPostBackTrigger ControlID="btnAddTestInterpretation" EventName="Click" />
											                                </Triggers>
											                                <ContentTemplate>
												                                <asp:Button ID="btnAddTestInterpretation" runat="server" CommandName="New Interpretation" CommandArgument='' CausesValidation="False" Text="" ToolTip="" />
											                                </ContentTemplate>
										                                </asp:UpdatePanel>
									                                </div>
								                                </ItemTemplate>
							                                </asp:TemplateField>
							                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
								                                <ItemTemplate>
									                                <asp:LinkButton ID="btnEditLabTest" runat="server" CommandName="Edit" CommandArgument='' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
								                                </ItemTemplate>
							                                </asp:TemplateField>
							                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
								                                <ItemTemplate>
									                                <asp:LinkButton ID="btnDeleteLabTest" runat="server" CommandName="Delete" CommandArgument='' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
								                                </ItemTemplate>
							                                </asp:TemplateField>
						                                </Columns>
					                                </eidss:GridView>
				                                </div>
                                                <div id="divLabTestContainer" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog">
	                                                <div class="modal-dialog" role="document">
		                                                <div class="modal-content">
			                                                <div class="modal-header">
				                                                <h4 class="modal-title" runat="server" ></h4>
			                                                </div>
			                                                <div id="divLabTestForm" class="modal-body" runat="server">
				                                                <div class="form-group"  runat="server">
					                                                <div class="row">
						                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="ddlLabTestSampleID" CssClass="control-label"  runat="server"></asp:Label>
							                                                <eidss:DropDownList CssClass="form-control" ID="ddlLabTestSampleID" runat="server" AutoPostBack="true"></eidss:DropDownList>
							                                                <asp:RequiredFieldValidator ControlToValidate="ddlLabTestSampleID" CssClass="alert-danger" InitialValue="null" Display="Dynamic"  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
						                                                </div>
					                                                </div>
				                                                </div>
				                                                <div class="form-group">
					                                                <div class="row">
						                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="txtLabTestEIDSSLaboratorySampleID" CssClass="control-label"  runat="server"></asp:Label>
							                                                <asp:TextBox ID="txtLabTestEIDSSLaboratorySampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
							                                                <asp:RequiredFieldValidator ControlToValidate="txtLabTestEIDSSLaboratorySampleID" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
						                                                </div>
						                                                <div class="form-group"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="txtLabTestSampleTypeName" CssClass="control-label"  runat="server"></asp:Label>
							                                                <asp:TextBox ID="txtLabTestSampleTypeName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
							                                                <asp:RequiredFieldValidator ControlToValidate="txtLabTestSampleTypeName" CssClass="alert-danger" Display="Dynamic"  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
						                                                </div>
					                                                </div>
				                                                </div>
				                                                <div class="form-group">
					                                                <div class="row">
						                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="txtLabTestEIDSSAnimalID" CssClass="control-label"  runat="server"></asp:Label>
							                                                <asp:TextBox ID="txtLabTestEIDSSAnimalID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
							                                                <asp:RequiredFieldValidator ControlToValidate="txtLabTestEIDSSAnimalID" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
						                                                </div>
						                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="txtLabTestDisease" CssClass="control-label"  runat="server"></asp:Label>
							                                                <asp:TextBox ID="txtLabTestDisease" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
							                                                <asp:RequiredFieldValidator ControlToValidate="txtLabTestDisease" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
						                                                </div>
					                                                </div>
				                                                </div>
				                                                <div class="form-group">
					                                                <div class="row">
						                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="ddlLabTestTestNameTypeID" CssClass="control-label"  runat="server"></asp:Label>
							                                                <eidss:DropDownList ID="ddlLabTestTestNameTypeID" runat="server" CssClass="form-control" />
						                                                </div>
						                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="ddlLabTestTestStatusTypeID" CssClass="control-label"  runat="server"></asp:Label>
							                                                <eidss:DropDownList ID="ddlLabTestTestStatusTypeID" runat="server" CssClass="form-control" Enabled="false"></eidss:DropDownList>
							                                                <asp:RequiredFieldValidator ControlToValidate="ddlLabTestTestStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
						                                                </div>
						                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="ddlLabTestTestCategoryTypeID" CssClass="control-label"  runat="server"></asp:Label>
							                                                <eidss:DropDownList ID="ddlLabTestTestCategoryTypeID" runat="server" CssClass="form-control" />
						                                                </div>
					                                                </div>
				                                                </div>
				                                                <div class="form-group">
					                                                <div class="row">
						                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="txtLabTestResultDate" CssClass="control-label"  runat="server"></asp:Label>
							                                                <eidss:CalendarInput ID="txtLabTestResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
							                                                <asp:RequiredFieldValidator ControlToValidate="txtLabTestResultDate" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
						                                                </div>
						                                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6"  runat="server">
							                                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
							                                                <asp:Label AssociatedControlID="ddlLabTestTestResultTypeID" CssClass="control-label"  runat="server"></asp:Label>
							                                                <eidss:DropDownList ID="ddlLabTestTestResultTypeID" runat="server" CssClass="form-control" />
						                                                </div>
					                                                </div>
				                                                </div>
				                                                <div class="modal-footer text-center">
					                                                <asp:Button ID="btnLabTestOK" runat="server" Text="" ToolTip="" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="vetLabTestInterpretation" />
					                                                <button type="button" class="btn btn-default" runat="server" title="" data-dismiss="modal"></button>
				                                                </div>
			                                                </div>
		                                                </div>
	                                                </div>
                                                </div>
			                                </div>
		                                </div>
		                                <div class="panel panel-default">
			                                <div class="panel-heading">
				                                <div class="row">
					                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
						                                <h3 runat="server"></h3>
					                                </div>
				                                </div>
			                                </div>
			                                <div class="panel-body">
				                                <div class="table-responsive">
					                                <eidss:GridView ID="gvTestInterpretations" runat="server" AllowPaging="False" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="TestInterpretationID" EmptyDataText="" ShowHeader="true" ShowHeaderWhenEmpty="true" ShowFooter="True" GridLines="None">
						                                <HeaderStyle CssClass="table-striped-header" />
						                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
						                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
						                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
						                                <Columns>
							                                <asp:BoundField DataField="EIDSSAnimalID" HeaderText="" />
							                                <asp:BoundField DataField="DiseaseName" HeaderText=""  />
							                                <asp:BoundField DataField="TestNameTypeName" HeaderText=""  />
							                                <asp:BoundField DataField="TestResultTypeName" HeaderText="" />
							                                <asp:BoundField DataField="TestCategoryTypeName" HeaderText=""  />
							                                <asp:BoundField DataField="EIDSSLaboratorySampleID" HeaderText=""  />
							                                <asp:BoundField DataField="SampleTypeName" HeaderText=""  />
							                                <asp:BoundField DataField="EIDSSLocalOrFieldSampleID" HeaderText=""  />
							                                <asp:BoundField DataField="InterpretedStatusTypeName" HeaderText="" />
							                                <asp:BoundField DataField="InterpretedComment" HeaderText="" />
							                                <asp:BoundField DataField="ValidatedStatusIndicator" HeaderText="" />
							                                <asp:BoundField DataField="ValidatedComment" HeaderText="" />
							                                <asp:BoundField DataField="ValidatedDate" HeaderText="" DataFormatString="{0:d}" />
							                                <asp:BoundField DataField="ValidatedByPersonName" HeaderText="" />
							                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
								                                <ItemTemplate>
									                                <asp:LinkButton ID="btnEditTestInterpretation" runat="server" CommandName="Edit" CommandArgument='' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
								                                </ItemTemplate>
							                                </asp:TemplateField>
							                                <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
								                                <ItemTemplate>
									                                <asp:LinkButton ID="btnDeleteTestInterpretation" runat="server" CommandName="Delete" CommandArgument='' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
								                                </ItemTemplate>
							                                </asp:TemplateField>
						                                </Columns>
					                                </eidss:GridView>
				                                </div>
				                                <div id="divTestInterpretationContainer" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog">
					                                <div class="modal-dialog" role="document">
						                                <div class="modal-content">
							                                <div class="modal-header">
								                                <h4 class="modal-title" runat="server" ></h4>
								                                <asp:HiddenField ID="hdfTestID" runat="server" Value="" />
							                                </div>
							                                <div id="divTestInterpretationForm" class="modal-body" runat="server">
								                                <div class="form-group"  runat="server">
									                                <div class="row">
										                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
											                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
											                                <asp:Label AssociatedControlID="ddlInterpretationInterpretedStatusTypeID" CssClass="control-label"  runat="server"></asp:Label>
											                                <eidss:DropDownList CssClass="form-control" ID="ddlInterpretationInterpretedStatusTypeID" runat="server"></eidss:DropDownList>
											                                <asp:RequiredFieldValidator ControlToValidate="ddlInterpretationInterpretedStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null"  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
										                                </div>
									                                </div>
								                                </div>
								                                <div class="form-group"  runat="server">
									                                <div class="row">
										                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
											                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
											                                <asp:Label AssociatedControlID="txtInterpretationInterpretedComment" CssClass="control-label"  runat="server"></asp:Label>
											                                <asp:TextBox ID="txtInterpretationInterpretedComment" runat="server" MaxLength="200" CssClass="form-control" Enabled="false"></asp:TextBox>
											                                <asp:RequiredFieldValidator ControlToValidate="txtInterpretationInterpretedComment" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
										                                </div>
									                                </div>
								                                </div>
								                                <div class="form-group">
									                                <div class="row">
										                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"  runat="server">
											                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
											                                <asp:Label AssociatedControlID="txtInterpretationInterpretedDate" CssClass="control-label"  runat="server"></asp:Label>
											                                <eidss:CalendarInput ID="txtInterpretationInterpretedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
											                                <asp:RequiredFieldValidator ControlToValidate="txtInterpretationInterpretedDate" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
										                                </div>
										                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"  runat="server">
											                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
											                                <asp:CheckBox ID="chkInterpretationValidatedStatusIndicator" runat="server"  CssClass="checkbox-inline" />
										                                </div>
									                                </div>
								                                </div>
								                                <div class="form-group"  runat="server">
									                                <div class="row">
										                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
											                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
											                                <asp:Label AssociatedControlID="txtInterpretationValidatedComment" CssClass="control-label"  runat="server"></asp:Label>
											                                <asp:TextBox ID="txtInterpretationValidatedComment" runat="server" MaxLength="200" CssClass="form-control" Enabled="false"></asp:TextBox>
											                                <asp:RequiredFieldValidator ControlToValidate="txtInterpretationValidatedComment" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
										                                </div>
									                                </div>
								                                </div>
								                                <div class="form-group">
									                                <div class="row">
										                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"  runat="server">
											                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
											                                <asp:Label AssociatedControlID="txtInterpretationValidatedDate" CssClass="control-label"  runat="server"></asp:Label>
											                                <eidss:CalendarInput ID="txtInterpretationValidatedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
											                                <asp:RequiredFieldValidator ControlToValidate="txtInterpretationValidatedDate" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>

										                                </div>
										                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"  runat="server">
											                                <div class="glyphicon glyphicon-asterisk alert-danger"  runat="server"></div>
											                                <asp:Label AssociatedControlID="txtInterpretationValidatedByPersonName" CssClass="control-label"  runat="server"></asp:Label>
											                                <asp:TextBox ID="txtInterpretationValidatedByPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
											                                <asp:RequiredFieldValidator ControlToValidate="txtInterpretationValidatedByPersonName" CssClass="alert-danger" Display="Dynamic" InitialValue=""  runat="server" ValidationGroup="vetLabTestInterpretation"></asp:RequiredFieldValidator>
										                                </div>
									                                </div>
								                                </div>
							                                </div>
							                                <div class="modal-footer text-center">
								                                <asp:Button ID="btnTestInterpretationOK" runat="server" CssClass="btn btn-primary" Text="" ToolTip="" CausesValidation="True" ValidationGroup="vetLabTestInterpretation"></asp:Button>
								                                <button type="submit" class="btn btn-default" runat="server" title="" data-dismiss="modal"></button>
								                                <asp:LinkButton ID="btnCreateConnectedDiseaseReport" runat="server" CssClass="btn btn-primary btn-sm" CausesValidation="false"><span></span></asp:LinkButton>
							                                </div>
						                                </div>
					                                </div>
				                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </section>
                        </div>
                        <div id="dVeterinarySideBarPanel" runat="server">
                            <div class="col-lg-3 pull-right">
                                <eidss:SideBarNavigation ID="SideBarNavigation1" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="0" ID="sidebaritem_Case_Notification_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Disease_Notification" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="1" ID="sidebaritem_Case_Location_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Case_Location" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="2" ID="sidebaritem_Case_Species_Information_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Species_Information" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="3" ID="sidebaritem_Case_Clinical_Information_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Clinical_Information" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="4" ID="sidebaritem_Case_Vaccination_Information_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Case_Vaccination_Information" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="5" ID="sidebaritem_Case_Outbreak_Investigation_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Outbreak_Investigation" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="6" ID="sidebaritem_Case_Monitoring_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Case_Monitoring" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="7" ID="sidebaritem_Case_Contacts_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Contacts" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="8" ID="sidebaritem_Case_Samples_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Samples" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="9" ID="sidebaritem_Case_Penside_Tests_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Penside_Tests" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="10" ID="sidebaritem_Case_Lab_Tests_Interpretation_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Lab_Tests_Interpretation" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="11" ID="sidebaritem_Case_Review_Submit_Vet" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_ReviewSubmit" runat="server" />
                                    </MenuItems>
                                </eidss:SideBarNavigation>
                            </div>
                            <div style="clear:both"></div>
                            <div class="row col-md-6">
                                <input id="btnVetPreviousCaseEntry" type="button" runat="server" class="btn btn-default" meta:resourceKey="btn_Previous" style="display:none" onclick="goBackToPreviousPanel(); setVetPreviousCaseButtons(); return false;" />
                                <input id="btnVetNextCaseEntry" type="button" runat="server" class="btn btn-default" meta:resourceKey="btn_Next" onclick="goForwardToNextPanel(); setVetNextCaseButtons(); return false;" />
                                <asp:Button ID="btnVetSubmitCaseEntry" runat="server" style="display:none" class="btn btn-primary" meta:resourceKey="btn_Submit" OnClick="btnVetSubmitCaseEntry_Click" CausesValidation="true" ValidationGroup="CaseCreation" ClientIDMode="Static" />
                                <asp:Button ID="btnVetCancelCaseEntry" runat="server" class="btn btn-default" meta:resourceKey="btn_Cancel" OnClientClick="javascript:gototab(0)" OnClick="btnCancelOutbreak_Click" />
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="dOutbreakDecisionImport" class="outbreakDecision" mode="Import" style="display:none">
        <img src="../Includes/Images/outbreakDecision.png" />
        <div class="typeOfCaseSelection">
            <asp:RadioButtonList id="rblImportCase" runat="server" AutoPostBack="true" RepeatDirection="Horizontal" OnCheckedChanged="ImportCase_CheckedChange">
                <asp:ListItem Value="Human" Text="<%$ Resources: lbl_Human_Type_Case %>"  />
                <asp:ListItem Value="Veterinary" Text="<%$ Resources: lbl_Veterinary_Type_Case %>" />
            </asp:RadioButtonList>
        </div>
        <div class="typeOfCaseTitle">
            <label runat="server" meta:resourceKey="lbl_Type_Of_Case"></label>
        </div>
    </div>
    <div id="dOutbreakDecisionCreate" class="outbreakDecision" mode="Create" style="display:none">
        <img src="../Includes/Images/outbreakDecision.png" />
        <div class="typeOfCaseSelection">
            <asp:RadioButtonList id="rblCreateCase" runat="server" AutoPostBack="true" RepeatDirection="Horizontal" OnCheckedChanged="CreateCase_CheckedChange"  >
                <asp:ListItem Value="Human" Text="<%$ Resources: lbl_Human_Type_Case %>"  />
                <asp:ListItem Value="Veterinary" Text="<%$ Resources: lbl_Veterinary_Type_Case %>" />
            </asp:RadioButtonList>
        </div>
        <div class="typeOfCaseTitle">
            <label runat="server" meta:resourceKey="lbl_Type_Of_Case"></label>
        </div>
    </div>
    <asp:UpdatePanel ID="upOutbreakNoteForm" runat="server" Visible="True" UpdateMode="Conditional" ClientIDMode="static">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSaveNote" />
        </Triggers>
        <ContentTemplate>
            <div id="dOutbreakNoteForm" modal="OutbreakNoteForm" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 class="modal-title" id="hNewNoteRecord" meta:resourcekey="Hdg_Outbreak_Note_New_Record" runat="server"></h3>
                        </div>
                        <div class="modal-body">
                            <div class="row form-group" runat="server">
	                            <div class="col-sm-4 text-right">
		                            <label runat="server" meta:resourcekey="lbl_OutBreak_Note_Record_ID"></label>
                                </div>
	                            <div class="col-sm-6 pull-left">
                                    <asp:TextBox ID="txtidfOutbreakNote" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true"></asp:TextBox>
	                            </div>
                            </div>
                            <div class="row form-group">
	                            <div class="col-sm-4 text-right">
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_Employee_Name"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <asp:TextBox ID="textUserName" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
	                            </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-sm-4 text-right">
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_Organization"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <asp:TextBox ID="textOrganization" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-sm-4 text-right">
                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="req_Outbreak_Note_Priority" runat="server"></div>
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_Priority"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <eidss:DropDownList ID="drdlUpdatePriorityID" runat="server" CssClass="form-control" Height="35px"></eidss:DropDownList>
                                    <asp:RequiredFieldValidator ControlToValidate="drdlUpdatePriorityID" CssClass="text-danger" Display="Dynamic" meta:resourcekey="val_Outbreak_Note_Priority" runat="server" ValidationGroup="note"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-sm-4 text-right">
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_DateTime_Stamp"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <eidss:CalendarInput ID="calidatNoteDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY" Enabled="False"></eidss:CalendarInput>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-sm-4 text-right">
                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="req_Outbreak_Note_Title" runat="server"></div>
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_Title"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <asp:TextBox ID="textUpdateRecordTitle" runat="server" MaxLength ="20" CssClass="form-control" Height="35px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="textUpdateRecordTitle" CssClass="text-danger" Display="Dynamic" meta:resourcekey="val_Outbreak_Note_Title" runat="server" ValidationGroup="note"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-sm-4 text-right">
                                    <div class="glyphicon glyphicon-asterisk alert-red" meta:resourcekey="req_Outbreak_Note_Details" runat="server"></div>
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_Details"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <asp:Textbox ID="textstrNote" runat="server" MaxLength ="20" CssClass="form-control" TextMode="MultiLine" Rows="5" ></asp:Textbox>
                                    <asp:RequiredFieldValidator ControlToValidate="textstrNote" CssClass="text-danger" Display="Dynamic" meta:resourcekey="val_Outbreak_Note_Details" runat="server" ValidationGroup="note"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-sm-4 text-right">
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_Upload_File"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <asp:FileUpload ID="fileUploadFileObject" ClientIDMode="static" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" onchange="javascript:checkExtensions();"></asp:FileUpload>
                                    <label id="lValidExtensions" class="text-danger" ClientIDMode="static" runat="server" style="display:none" meta:resourcekey="lbl_Outbreak_Note_Valid_Extensions"></label>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-sm-4 text-right">
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Note_Upload_File_Description"></label>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <asp:TextBox ID="textUploadFileDescription" runat="server" MaxLength ="20" CssClass="form-control" Height="35px"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnSaveNote" CssClass="btn btn-primary" runat="server" ClientIDMode="Static" meta:resourcekey="btn_Save" OnClick="btnSaveNote_Click" CausesValidation="true" ValidationGroup="note" />
                            <input type="button" id="btnCancelNote" onclick="javascript: hideAllModals(this);" class="btn btn-default" value='<%=GetLocalResourceObject("btn_Cancel") %>' />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="upOutbreakContactForm" runat="server" Visible="True" UpdateMode="Conditional" ClientIDMode="static">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSaveContact" />
        </Triggers>
        <ContentTemplate>
            <div id="dOutbreakContactForm" modal="OutbreakContactForm" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
	                        <h3 class="modal-title" id="h1" meta:resourcekey="Hdg_Outbreak_Contact_Edit_Record" runat="server"></h3>
                        </div>
                        <div class="modal-body">
                            <div class="row" runat="server">
		                        <div class="col-lg-4">
			                        <label runat="server" meta:resourcekey="lbl_OutBreak_Contact_LastName"></label>
                                </div>
		                        <div class="col-lg-4">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_FirstName"></label>
		                        </div>
                            	<div class="col-lg-4">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_MiddleName"></label>
		                        </div>
	                        </div>
	                        <div class="row form-group">
		                        <div class="col-lg-4">
			                        <asp:TextBox ID="txtstrLastName" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
                                </div>
		                        <div class="col-lg-4">
			                        <asp:TextBox ID="txtstrFirstName" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
		                        </div>
		                        <div class="col-lg-4">
			                        <asp:TextBox ID="txtstrMiddleName" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
		                        </div>
	                        </div>
	                        <div class="row">
		                        <div class="col-lg-4 ">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_Date"></label>
		                        </div>
                                <div class="col-lg-4">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_Age"></label>
                                </div>
		                        <div class="col-lg-4">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_Gender"></label>
		                        </div>
	                        </div>
	                        <div class="row form-group">
		                        <div class="col-lg-4">
			                        <asp:TextBox ID="txtdatDateofBirth" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
		                        </div>
                                <div class="col-lg-4">
			                        <asp:TextBox ID="txtstrAge" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
                                </div>
		                        <div class="col-lg-4">
			                        <asp:TextBox ID="txtstrGender" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
		                        </div>
	                        </div>
	                        <div class="row">
		                        <div class="col-lg-6">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_Citizenship"></label>
                                </div>
                                <div class="col-lg-6">
			                        <label id="lblFarmName" runat="server" meta:resourcekey="lbl_Outbreak_Contact_FarmName"></label>
                                </div>
                            </div>
	                        <div class="row form-group">
		                        <div class="col-lg-6">
			                        <asp:TextBox ID="txtstrCitizenship" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
		                        </div>
                                <div class="col-lg-6">
			                        <asp:TextBox ID="txtFarmName" runat="server" MaxLength ="20" CssClass="form-control" Height="35px" ReadOnly="true" Enabled="false"></asp:TextBox>
		                        </div>
	                        </div>
                            <div style="clear:both"></div>
                            <div class="row form-group">
                                <div class="col-lg-12 pull-right">
                                    <input type="checkbox" id="chkForeignAddress" onclick="javascript:toggleForiegnAddress()" />
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_ForiegnAddress"></label>
                                </div>
                            </div>
	                        <div class="row form-group">
		                        <div class="col-lg-12">
		                            <eidss:LocationUserControl ID="lucContactLocation" runat="server" IsHorizontalLayout="true" ShowLatitude="false" ShowLongitude="false" ShowMap="false" ShowElevation="false" ShowCoordinates="false" />
                                </div>
	                        </div>
	                        <div class="row">
		                        <div class="col-lg-6">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_Relationship_Type"></label>
		                        </div>
		                        <div class="col-lg-6">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_DateOfLastContact"></label>
		                        </div>
	                        </div>
	                        <div class="row form-group">
		                        <div class="col-lg-6">
			                        <eidss:DropDownList ID="ddlContactRelationshipTypeID" runat="server" CssClass="form-control" Height="35px"></eidss:DropDownList>,s
		                        </div>
		                        <div class="col-lg-6">
			                        <eidss:CalendarInput ID="ciDateOfLastContact" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
		                        </div>
	                        </div>
	                        <div class="row">
		                        <div class="col-lg-6">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_PlaceOfLastContact"></label>
		                        </div>
		                        <div class="col-lg-6">
                                    <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_Status"></label>
		                        </div>
	                        </div>
	                        <div class="row">
		                        <div class="col-lg-6">
			                        <asp:TextBox ID="txtPlaceOfLastContact" runat="server" MaxLength ="200" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
		                        </div>
		                        <div class="col-lg-6">
			                        <eidss:DropDownList ID="ddlContactStatusID" runat="server" CssClass="form-control" Height="35px"></eidss:DropDownList>
		                        </div>
	                        </div>
	                        <div class="row">
		                        <div class="col-lg-12">
			                        <label runat="server" meta:resourcekey="lbl_Outbreak_Contact_Details"></label>
		                        </div>
                            </div>
                            <div class="row form-group">
		                        <div class="col-lg-12">
                                    <asp:TextBox ID="txtCommentText" runat="server" MaxLength ="500" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
		                        </div>
	                        </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnSaveContact" CssClass="btn btn-primary" runat="server" ClientIDMode="Static" meta:resourcekey="btn_Save" CausesValidation="true"/>
                            <input type="button" runat="server" id="btnCancelContact" meta:resourceKey="btn_Cancel" class="btn btn-default" onclick="javascript:hideAllModals()" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="outbreakVeterinaryDiseaseSearch" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="outbreakVeterinaryDiseaseSearch">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 id="hdgSearchVeterinaryMonitoringSessions" class="modal-title">
                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Search_Veterinary_Monitoring_Session_Text %>"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchVeterinaryDiseaseReportUserControl ID="ucSearchVeterinaryDiseaseReport" runat="server" />
            </div>
        </div>
    </div>
    <div id="AddOrganization" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="outbreakAddOrganization">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 id="hdgAddOrganization" class="modal-title">
                    <asp:Literal runat="server" Text="<%$ Resources: Lbl_Add_Organization %>"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:AddUpdateOrganizationUserControl runat="server" id="ucAddUpdateOrganizationUserControl" />
            </div>
        </div>
    </div>
    <div id="SearchEmployee" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="outbreakSearchEmployee">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 id="hdgSearchEmployee" class="modal-title">
                    <asp:Literal runat="server" Text="<%$ Resources: Lbl_Search_Employee %>"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body modal-wrapper">
                <%--<eidss:SearchEmployeeUserControl runat="server" id="ucSearchEmployee" />--%>
            </div>
        </div>
    </div>
    <div id="outbreakHumanDiseaseSearch" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="outbreakHumanDiseaseSearch">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 id="hdgSearchHumanMonitoringSessions" class="modal-title">
                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Search_Human_Monitoring_Session_Text %>"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchHumanDiseaseReportUserControl ID="ucSearchHumanDiseaseReport" runat="server" />
            </div>
        </div>
    </div>
    <div id="outbreakPersonSearch" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="outbreakPersonSearch">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 id="hdgSearchPerson" class="modal-title">
                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Search_Person_Text%>"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchPerson ID="ucSearchPerson" runat="server" />
            </div>
        </div>
    </div>
    <div id="outbreakFarmSearch" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="outbreakFarmSearch">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 id="hdgSearchFarm" class="modal-title">
                    <asp:Literal runat="server" Text="<%$ Resources: Labels, Lbl_Search_Farm_Text%>"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchFarmUserControl runat="server" ID="SearchFarmUserControl" />
            </div>
        </div>
    </div>
    <div id="outbreakVetSample" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Samples"></h4>
                </div>
                <div id="divSampleForm" class="modal-body" runat="server">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Sample_Type" runat="server">
                                <asp:UpdatePanel ID="upVetSampleTypeId" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Type" runat="server"></div>
                                        <asp:Label AssociatedControlID="ddlVetSampleTypeID" CssClass="control-label" meta:resourcekey="Lbl_Sample_Type" runat="server"></asp:Label>
                                        <eidss:DropDownList CssClass="form-control" ID="ddlVetSampleTypeID" runat="server"></eidss:DropDownList>
                                        <asp:RequiredFieldValidator ControlToValidate="ddlVetSampleTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Type" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                                    </ContentTemplate>
                                 </asp:UpdatePanel>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Field_Sample_ID" runat="server">
                                <asp:UpdatePanel ID="upVetSampleFieldId" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Field_Sample_ID" runat="server"></div>
                                        <asp:Label AssociatedControlID="txtVetSampleFieldId" CssClass="control-label" meta:resourcekey="Lbl_Field_Sample_ID" runat="server"></asp:Label>
                                        <asp:TextBox ID="txtVetSampleFieldId" runat="server" MaxLength="200" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ControlToValidate="txtVetSampleFieldId" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Field_Sample_ID" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Sample_Species" runat="server">
                                <asp:UpdatePanel ID="upSampleSpeciesID" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sample_Species" runat="server"></div>
                                        <asp:Label AssociatedControlID="ddlSampleSpeciesID" CssClass="control-label" meta:resourcekey="Lbl_Species" runat="server"></asp:Label>
                                        <eidss:DropDownList CssClass="form-control" ID="ddlSampleSpeciesID" runat="server" OnChange='javascript:$("#cidatVetSampleCollectionDate").val($("#ciVetdatMonitoringDate").val());'></eidss:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <asp:RequiredFieldValidator ControlToValidate="ddlSampleSpeciesID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sample_Species" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Bird_Id" runat="server">
                                <asp:UpdatePanel ID="upVetSampleStatus" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:Panel ID="pLivestockSampleStatus" runat="server">
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Animal_Id" runat="server"></div>
                                            <asp:Label AssociatedControlID="ddlVetAnimalId" CssClass="control-label" meta:resourcekey="Lbl_Animal_Id" runat="server"></asp:Label>
                                            <eidss:DropDownList CssClass="form-control" ID="ddlVetAnimalId" runat="server"></eidss:DropDownList>
                                            <asp:RequiredFieldValidator ControlToValidate="ddlVetAnimalId" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Animal_Id" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                                        </asp:Panel>
                                        <asp:Panel ID="pAvianSampleStatus" runat="server">
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Bird_Status" runat="server"></div>
                                            <asp:Label AssociatedControlID="ddlVetSampleBirdStatusTypeID" CssClass="control-label" meta:resourcekey="Lbl_Bird_Status" runat="server"></asp:Label>
                                            <eidss:DropDownList CssClass="form-control" ID="ddlVetSampleBirdStatusTypeID" runat="server"></eidss:DropDownList>
                                            <asp:RequiredFieldValidator ControlToValidate="ddlVetSampleBirdStatusTypeID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Bird_Status" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                                        </asp:Panel>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Collection_Date" runat="server">
                                <asp:UpdatePanel ID="upVetSampleCollectionDate" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collection_Date" runat="server"></div>
                                        <asp:Label AssociatedControlID="cidatVetSampleCollectionDate" CssClass="control-label" meta:resourcekey="Lbl_Collection_Date" runat="server"></asp:Label>
                                        <eidss:CalendarInput ID="cidatVetSampleCollectionDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" UseCurrent="False" ClientIDMode="Static"></eidss:CalendarInput>
                                        <asp:CompareValidator ID="vccidatVetSampleCollectionDate" runat="server" ControlToValidate="cidatVetSampleCollectionDate" CssClass="text-danger" ControlToCompare="ciVetdatMonitoringDate" Operator="LessThan" meta:resourcekey="Val_Vet_Sample_Collection_Date_Compare"></asp:CompareValidator>
                                        <asp:RequiredFieldValidator ControlToValidate="cidatVetSampleCollectionDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Collection_Date" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Collected_By_Institution" runat="server">
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collected_By_Institution" runat="server"></div>
                                <asp:Label AssociatedControlID="txtSampleCollectedByOrganizationID" CssClass="control-label" meta:resourcekey="Lbl_Collected_By_Institution" runat="server"></asp:Label>
                                <asp:UpdatePanel ID="upSampleCollectedByOrganizationID" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:TextBox runat="server" ID="txtSampleCollectedByOrganizationID" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" ViewStateMode="Enabled" ></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="input-group-addon">
                                    <asp:ImageButton id="imgSampleCollectedByOrganizationID" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtSampleCollectedByOrganizationID" OnClick="SearchOrganization_Click" />
                                </div>
                                <asp:RequiredFieldValidator ControlToValidate="txtSampleCollectedByOrganizationID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Collected_By_Officer" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Collected_By_Officer" runat="server">
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Collected_By_Officer" runat="server"></div>
                                <asp:Label AssociatedControlID="txtSampleCollectedByPersonID" CssClass="control-label" meta:resourcekey="Lbl_Collected_By_Officer" runat="server"></asp:Label>
                                <asp:UpdatePanel ID="upSampleCollectedByPersonID" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:TextBox runat="server" ID="txtSampleCollectedByPersonID" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" ViewStateMode="Enabled" ></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="input-group-addon">
                                    <asp:ImageButton id="imSampleCollectedByPersonID" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtSampleCollectedByPersonID" OnClick="SearchOrganization_Click" />
                                </div>
                                <asp:RequiredFieldValidator ControlToValidate="txtSampleCollectedByPersonID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Collected_By_Person_Id" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" meta:resourcekey="Dis_Sent_To_Organization" runat="server">
                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Sent_To_Organization" runat="server"></div>
                                <asp:Label AssociatedControlID="txtSampleSentToOrganizationID" CssClass="control-label" meta:resourcekey="Lbl_Sent_To_Organization" runat="server"></asp:Label>
                                <asp:UpdatePanel ID="upSampleSentToOrganizationID" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:TextBox runat="server" ID="txtSampleSentToOrganizationID" MaxLength="20" CssClass="form-control" Height="35px" ClientIDMode="Static" ViewStateMode="Enabled" ></asp:TextBox>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="input-group-addon">
                                    <asp:ImageButton id="imSampleSentToOrganizationID" runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" destination="txtSampleSentToOrganizationID" OnClick="SearchOrganization_Click" />
                                </div>
                                <asp:RequiredFieldValidator ControlToValidate="txtSampleSentToOrganizationID" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Sent_To_Organization_Id" runat="server" ValidationGroup="outbreakVetSample"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer text-center">
                        <asp:Button ID="btnVetSampleSave" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" OnClick="BatchAddVetSample" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="outbreakVetSample" />
                        <button type="button" class="btn btn-default" runat="server" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="outbreakVetLabTest" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Vet_Lab_Test"></h4>
                </div>
                <div id="div1" class="modal-body" runat="server">
                    <div class="form-group">
                        <asp:Panel ID="pOutbreakVetLabTest" runat="server">
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Sample_Type" runat="server">
                                    <asp:UpdatePanel ID="upVetLabSammpleId" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Sample_Id" runat="server"></div>
                                            <asp:Label AssociatedControlID="txtVetLabSampleId" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Sample_Id" runat="server"></asp:Label>
                                            <asp:TextBox ID="txtVetLabSampleId" runat="server" CssClass="form-control" ></asp:TextBox>
                                            <asp:RequiredFieldValidator ControlToValidate="txtVetLabSampleId" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Sample_Id" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Sample_Type" runat="server">
                                    <asp:Label AssociatedControlID="txtVetLabSampleType" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Sample_Type" runat="server"></asp:Label>
                                    <asp:TextBox ID="txtVetLabSampleType" runat="server" MaxLength="200" CssClass="form-control disabled-form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Field_Sample_Id" runat="server">
                                    <asp:UpdatePanel ID="upVetLabFieldSampleId" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Field_Sample_Id" runat="server"></div>
                                            <asp:Label AssociatedControlID="ddlVetLabFieldSampleId" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Field_Sample_Id" runat="server"></asp:Label>
                                            <eidss:DropDownList ID="ddlVetLabFieldSampleId" runat="server" CssClass="form-control" OnSelectedIndexChanged="VetFieldSampleId_Selected" AutoPostBack="true"></eidss:DropDownList>
                                            <asp:RequiredFieldValidator ControlToValidate="ddlVetLabFieldSampleId" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Field_Sample_Id" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Animal_Id" runat="server">
                                    <asp:UpdatePanel ID="upVetLabAnimalId" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Label AssociatedControlID="txtVetLabAnimalId" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Animal_Id" runat="server"></asp:Label>
                                            <asp:TextBox ID="txtVetLabAnimalId" runat="server" MaxLength="200" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            <asp:RequiredFieldValidator ControlToValidate="txtVetLabAnimalId" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Req_Vet_Lab_Animal_Id" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Species" runat="server">
                                    <asp:UpdatePanel ID="upVetLabSpecies" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Species" runat="server"></div>
                                            <asp:Label AssociatedControlID="txtVetLabSpecies" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Species" runat="server"></asp:Label>
                                            <asp:HiddenField ID="hdnVetLabSpecies" runat="server" Value="-1" />
                                            <asp:Textbox ID="txtVetLabSpecies" runat="server" CssClass="form-control" Enabled="false"></asp:Textbox>
                                            <asp:RequiredFieldValidator ControlToValidate="txtVetLabSpecies" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Species" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Test_Disease" runat="server">
                                    <asp:UpdatePanel ID="upVetLabTestDisease" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Test_Disease" runat="server"></div>
                                            <asp:Label AssociatedControlID="ddlVetLabTestDisease" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Test_Disease" runat="server"></asp:Label>
                                            <asp:DropDownList ID="ddlVetLabTestDisease" runat="server" CssClass="form-control"></asp:DropDownList>
                                            <asp:RequiredFieldValidator ControlToValidate="ddlVetLabTestDisease" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Test_Disease" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Test_Name" runat="server">
                                    <asp:UpdatePanel ID="upVetLabTestName" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Test_Name" runat="server"></div>
                                            <asp:Label AssociatedControlID="ddlVetLabTestName" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Test_Name" runat="server"></asp:Label>
                                            <asp:DropDownList ID="ddlVetLabTestName" runat="server" CssClass="form-control"></asp:DropDownList>
                                            <asp:RequiredFieldValidator ControlToValidate="ddlVetLabTestName" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Test_Name" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Test_Category" runat="server">
                                    <asp:UpdatePanel ID="upVetLabTestCategory" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Test_Category" runat="server"></div>
                                            <asp:Label AssociatedControlID="ddlVetLabTestCategory" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Test_Category" runat="server"></asp:Label>
                                            <asp:DropDownList ID="ddlVetLabTestCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                                            <asp:RequiredFieldValidator ControlToValidate="ddlVetLabTestCategory" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Test_Category" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Test_Status" runat="server">
                                    <asp:UpdatePanel ID="upVetLabTestStatus" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Test_Status" runat="server"></div>
                                            <asp:Label AssociatedControlID="txtVetLabSpecies" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Test_Status" runat="server"></asp:Label>
                                            <asp:Textbox ID="txtVetLabTestStatus" runat="server" CssClass="form-control"></asp:Textbox>
                                            <asp:RequiredFieldValidator ControlToValidate="txtVetLabSpecies" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Test_Status" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Result_Date" runat="server">
                                    <asp:UpdatePanel ID="upVetLabdatResultDate" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Result_Date" runat="server"></div>
                                            <asp:Label AssociatedControlID="ciVetLabdatResultDate" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Result_Date" runat="server"></asp:Label>
                                            <eidss:CalendarInput ID="ciVetLabdatResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                            <%--<asp:TextBox ID="VetLabSampleCollectionDate" CssClass="hidden" Text ="1/1/1901" runat="server"></asp:TextBox>--%>
                                            <asp:RequiredFieldValidator ControlToValidate="ciVetLabdatResultDate" CssClass="alert-danger" Display="Dynamic" InitialValue="" meta:resourcekey="Val_Vet_Lab_Result_Date" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                            <asp:RangeValidator ID="rvVetLabResultDate" runat="server" ControlToValidate="ciVetLabdatResultDate" CssClass="text-danger" Type="Date" Display="Dynamic" meta:resourcekey="Val_Vet_Notification_Date_Range" ValidationGroup="outbreakVetLabTest"></asp:RangeValidator>
                                            <%--<asp:CompareValidator ID="cvVetLabdatResultDateLow" runat="server" ControlToValidate="ciVetLabdatResultDate" Type="Date" CssClass="text-danger" ControlToCompare="VetLabSampleCollectionDate" Operator="LessThan" meta:resourcekey="Val_Vet_Lab_Result_Date_Low" ValidationGroup="outbreakVetLabTest"></asp:CompareValidator>
                                            <asp:CompareValidator ID="cvVetLabdatResultDateHigh" runat="server" ControlToValidate="ciVetLabdatResultDate" Type="Date" ControlToCompare="ciDateOfNotification" CssClass="text-danger" Operator="GreaterThan" meta:resourcekey="Val_Vet_Date_Last_Contact_Compare_High" ValidationGroup="outbreakVetLabTest"></asp:CompareValidator>--%>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" meta:resourcekey="Dis_Vet_Lab_Result_Observation" runat="server">
                                    <asp:UpdatePanel ID="upVetLabResultObservation" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <div class="glyphicon glyphicon-asterisk alert-danger" meta:resourcekey="Req_Vet_Lab_Result_Observation" runat="server"></div>
                                            <asp:Label AssociatedControlID="ddlVetLabResultObservation" CssClass="control-label" meta:resourcekey="Lbl_Vet_Lab_Result_Observation" runat="server"></asp:Label>
                                            <asp:DropDownList ID="ddlVetLabResultObservation" runat="server" CssClass="form-control"></asp:DropDownList>
                                            <asp:RequiredFieldValidator ControlToValidate="ddlVetLabResultObservation" CssClass="alert-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="Val_Vet_Lab_Result_Observation" runat="server" ValidationGroup="outbreakVetLabTest"></asp:RequiredFieldValidator>
                                        </ContentTemplate>
                                     </asp:UpdatePanel>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                    <div class="modal-footer text-center">
                        <asp:Button ID="btnVetAddLabTest" runat="server" Text="<%$ Resources: Buttons, Btn_Save_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Save_ToolTip %>" OnClick="BatchAddVetLabTest" CausesValidation="true" CssClass="btn btn-primary" ValidationGroup="outbreakVetLabTest" />
                        <button type="btnVetCancelLabTest" class="btn btn-default" runat="server" title="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" data-dismiss="modal"><%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="SearchOrganization" class="modal container fade" tabindex="-1" data-focus-on="input:first" role="dialog" aria-labelledby="outbreakSearchOrganization">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 id="hdgSearchOrganization" class="modal-title">
                    <asp:Literal runat="server" Text="<%$ Resources: Lbl_Search_Organization %>"></asp:Literal>
                </h4>
            </div>
            <div class="modal-body modal-wrapper">
                <eidss:SearchOrganizationUserControl runat="server" ID="ucSearchOrganizationUserControl" />
            </div>
        </div>
    </div>
    <asp:UpdatePanel ID="upWarningModal" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSaveNote" />
        </Triggers>
        <ContentTemplate>
            <div id="dWarningModalContainer" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" id="warningHeading" runat="server"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                        <strong id="warningSubTitle" runat="server"></strong>
                                        <br />
                                        <div id="warningBody" runat="server"></div>
                                        <br />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div id="dWarningYesNoContainer" runat="server">
                                <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Btn_Yes_Text %>" meta:resourcekey="Btn_Yes_Text" ToolTip="<%$ Resources: Btn_Yes_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnWarningModalNo" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Btn_No_Text %>" ToolTip="<%$ Resources: Btn_No_ToolTip %>" CausesValidation="false" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="EmployeeModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <%--<eidss:SearchEmployee ID="ucSearchEmployee" runat="server" RecordMode="Select" />--%> 
                </div>
            </div>
        </div>
    </div>

    <script src="../Includes/Scripts/moment-with-locales.js"></script>
    <script src="../Includes/Scripts/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#bSubmit,#btnSubmitCaseEntry,#btnVetSubmitCaseEntry").hide();
            $('body').removeClass('modal-open');
            $("#obmtxtstrquickSearch").on('keydown', function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                }
            });

            $("#rVeterinaryImport,#rHumanImport").removeAttr("checked");

        });

        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
            var personSection = document.getElementById("EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm");

            if (personSection != undefined && personSection != null ) {
                initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));
            }

            //initializeSideBarPanel(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'));
            //initalizeSidebar();
            if ($("#EIDSSBodyCPH_humanDisease").is(":visible") ||
                $("#EIDSSBodyCPH_veterinaryDisease").is(":visible")) {
                initializeSideBar_Immediate();
            }
        });

        function callBackHandler(data) {
            switch ($("#EIDSSBodyCPH_hdnDiseaseReport").val()) {
                case "Human":
                    initializeSideBar_Human();
                    break;
                case "Veterinary":
                    initializeSideBar_Veterinary();
                    break;
            }
        }

        //  this function is unique for each page it checks to see if the container(s)
        //  that need the side navigation are currently being displayed
        function checkContainersExist() {
            var hdID = "";
            var pcId = "";

            switch ($("#EIDSSBodyCPH_hdnDiseaseReport").val()) {
                case "Human":
                    hdID = "<%= humanDisease.ClientID %>";
                    break;
                case "Veterinary":
                    hdID = "<%= veterinaryDisease.ClientID %>";
                    break;
            }

            //  get instance of div containers with sections
            var hd = document.getElementById(hdID);

            // if instances are not null, return true
            if (hd != null) {
                return true;
            }
            return false;
        };

        function initializeSideBar_Human() {
            $(document).ready(function () {
                //  get instance of div containers with sections
                var hd = document.getElementById("<%= humanDisease.ClientID %>");
                // if instances are not null, return true
                if (hd != null || hd != undefined) {
                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                }
                //  this checks to see if the container that has <section> tabs is present
                if (checkContainersExist()) {
                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                }
            });
        }

        function initializeSideBar_Veterinary() {
            $(document).ready(function () {
                //  get instance of div containers with sections
                var hd = document.getElementById("<%= veterinaryDisease.ClientID %>");
                // if instances are not null, return true
                if (hd != null || hd != undefined) {
                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                }
                //  this checks to see if the container that has <section> tabs is present
                if (checkContainersExist()) {
                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                }
            });
        }

        function initializeSideBar_Immediate(currentTab) {
            var hdID = "";
            var pcId = "";
            
            switch ($("#EIDSSBodyCPH_hdnDiseaseReport").val()) {
                case "Human":
                    hdID = "<%= humanDisease.ClientID %>";
                    break;
                case "Veterinary":
                    hdID = "<%= veterinaryDisease.ClientID %>";
                    break;
            }

            //  get instance of div containers with sections
            var hd = document.getElementById(hdID);
            // if instances are not null, return true
            if (hd != null || hd != undefined) {
                setViewOnPageLoad(hdID);
            }
            //  this checks to see if the container that has <section> tabs is present
            if (checkContainersExist()) {
                setViewOnPageLoad(hdID);
            }

            if (currentTab == undefined) {
                return true;
            }
            else {
                goToTab(currentTab);
            }
        }

        function lockNumericSpinnerButtons() {
            $("[id*='CaseMonitoringFrequency'],[id*='ContactTracingFrequency']").parent().find("button").attr("disabled", "disabled");
            setQuestionnaire(1);
        }

        function checkExtensions() {
            var filePath = $("input#fileUploadFileObject").val();
            var extensions = [".doc", ".pdf", ".docx", ".xls", ".xlsx", ".png", ".jpg", ".jpeg", ".gif", ".bmp",
                ".dot", ".dotx", ".docm", ".dotm", ".xlt", ".xla", ".xltx", ".xlsm", ".xltm", ".xlam", ".xlsb",
                ".pot", ".pps", ".ppa", ".pptx", ".potx", ".ppsx", ".ppam", ".pptm", ".potm"];
                
            var extension = filePath.substring(filePath.lastIndexOf("."));
            var bFound = false;

            if (filePath == "") {
                bFound = true;
            }
            else {

                for (i = 0; i < extensions.length; i++) {
                    if (extensions[i].toLowerCase() == extension) {
                        bFound = true;
                        break;
                    }
                }
            }

            if (bFound) {
                $("#btnSaveNote").prop('disabled', false);
                $("#lValidExtensions").hide();
            }
            else {
                $("#btnSaveNote").prop('disabled', true);
                $("#lValidExtensions").show();
            }
        }

        $(window).resize(function () {
            showDecision();
        });

        function setQuestionnaire(val) {
            if (val == 1) {
                $("#bNext").show();
                $("#bSubmit").hide();
            }
            else {
                $("#bNext").hide();
                $("#bSubmit").show();
            }
        }

        function setCurrentSummaryTab(id) {
            $("#hdnCurrentSummaryTab").val("#" + id);
        }

        function recallSummaryTab() {
            $($("#hdnCurrentSummaryTab").val()).click();
        }

        function showParameters(obj, id) {
            if (id == undefined) {
                return false;
            }

            $("#EIDSSBodyCPH_dParametersidfscb" + id).hide();
            if (obj.checked) {
                $("#EIDSSBodyCPH_dParametersidfscb" + id).show();
            }

            var bHuman = false;
            var bAvian = false;
            var bLivestock = false;
            var bVector = false;

            if ($("#EIDSSBodyCPH_idfscbHuman").is(":checked")) { bHuman = true; }
            if ($("#EIDSSBodyCPH_idfscbAvian").is(":checked")) { bAvian = true; }
            if ($("#EIDSSBodyCPH_idfscbLivestock").is(":checked")) { bLivestock = true; }
            if ($("#EIDSSBodyCPH_idfscbVector").is(":checked")) { bVector = true; }

            if (bHuman || bAvian || bLivestock || bVector) {
                $("#EIDSSBodyCPH_dOutbreakHeading").parent().show();
            }
            else {
                $("#EIDSSBodyCPH_dOutbreakHeading").parent().hide();
            }

            if (!bHuman) { clearParameters("Human"); }
            if (!bAvian) { clearParameters("xAvian"); }
            if (!bLivestock) { clearParameters("Livestock"); }
            if (!bVector) { clearParameters("xVector"); }

            checkVector();
        }

        function clearParameters(parameter) {
            $("#ens" + parameter + "CaseMonitoringDuration").val(""); 
            $("#ens" + parameter + "CaseMonitoringFrequency").val("");
            $("#ens" + parameter + "ContactTracingDuration").val(""); 
            $("#ens" + parameter + "ContactTracingFrequency").val("");
        }

        function enableParameters() {

            var parameters = ['Human', 'xAvian', 'Livestock', 'xVector'];
            var parameter = "";

            for (i = 0; i < 3; i++) {
                parameter = parameters[i];
                enableParameter("ens" + parameter + "CaseMonitoring");
                enableParameter("ens" + parameter + "ContactTracing");
            }
        }

        function enableParameter(commonId) {
            var spinnerValue = $("#" + commonId + "Duration").val();
            var ctlFrequency = commonId + "Frequency";

            if (spinnerValue == undefined || spinnerValue == "") {
                spinnerValue = 0;
            }

            if (parseInt(spinnerValue) > 0) {
                $("#" + ctlFrequency).removeAttr("disabled");
                $("#" + ctlFrequency).parent().find("button").removeAttr("disabled");
            }
            else {
                $("#" + ctlFrequency).prop("disabled", "disabled").val("");
                $("#" + ctlFrequency).parent().find("button").prop("disabled", "disabled");
            }

            if ($("#" + commonId + "Frequency").val() != "" && $("#" + commonId + "Duration").val() != "") {
                limitCeiling(commonId);
            }
        }

        function limitCeiling(controlId) {
            if ($("#" + controlId + "Frequency").val() > $("#" + controlId + "Duration").val()) {
                $("#" + controlId + "Frequency").val($("#" + controlId + "Duration").val());
            }
        }

        function showDecision(obj) {

            if (obj == undefined) {
                var mode = $("[class='outbreakDecision']:visible").attr("mode");
                obj = $("#b" + mode + "Case");
                if (obj.length == 0) {
                    return false;
                }
                else
                {
                    $(".outbreakDecision").hide();
                }
            } 

            //Continue on as normal, since obj should be established by now.
            var objAbsoluteRight = $(obj).offset().left + $(obj).width();
            var objAbsoluteTop = $(obj).offset().top - $(obj).height() / 2;

            if ($("#dOutbreakDecision" + $(obj).val()).is(":visible")) {
                $("#dOutbreakDecision" + $(obj).val()).hide();
            }
            else {
                $(".outbreakDecision").hide();
                $("#dOutbreakDecision" + $(obj).val()).css({
                    position: "absolute",
                    left: objAbsoluteRight,
                    top: objAbsoluteTop
                }).show();
            }
        }

        //OutbreakNote
        function showModal(recallsummaryTab, partialFormId, modalId) {
            if (recallsummaryTab) { recallSummaryTab(); }

            if ($(partialFormId).length == 1) {
                $(partialFormId).modal({ show: true, backdrop: 'static' });
            }
            else if ($("[modal='" + modalId + "']").length == 1) {
                $("[modal='" + modalId + "']").modal({ show: true, backdrop: 'static' });
            }
        };

        function hideModalShowModal(hideModalId, recallsummaryTab, partialFormId, modalId) {
            $("#" + hideModalId).hide();

            if (recallsummaryTab) { recallSummaryTab(); }

            if ($(partialFormId).length == 1) {
                $(partialFormId).modal({ show: true, backdrop: 'static' });
            }
            else if ($("[modal='" + modalId + "']").length == 1) {
                $("[modal='" + modalId + "']").modal({ show: true, backdrop: 'static' });
            }
        };

        function hideModal(partialFormId, modalId) {
            if ($(partialFormId).length == 1) {
                $(partialFormId).hide();
            }
            else if ($("[modal='" + modalId + "']").length == 1) {
                $("[modal='" + modalId + "']").hide()
            }
            
            hideAllModals();
        };

        function hideAllModals() {

            $(".modal.fade.in[role='dialog']").hide();
            $(".modal-backdrop.fade.in").remove();

            return false;
        };

        function showScreen(screen) {
            $("#" + screen).show();
        }

        function showUpdatesTab() {
            $('#nav-updates-tab').click();
            hideAllModals();
        }

        function showContactsTab() {
            $('#nav-contacts-tab').click();
        }
        
        function closeModal(index) {
            $(".close").click();
            hideAllModals();
        }

        function closeModalById(id) {
            //$("#" + id).
        }

        function toggleForiegnAddress() {
            $("#EIDSSBodyCPH_lucContactLocation_upLocation").parent().toggle();
        }

        function checkVector() {
            if ($("#EIDSSBodyCPH_idfscbVector").is(":checked")) {
                var bHuman = false;
                var bAvian = false;
                var bLivestock = false;

                if ($("#EIDSSBodyCPH_idfscbHuman").is(":checked")) { bHuman = true; }
                if ($("#EIDSSBodyCPH_idfscbAvian").is(":checked")) { bAvian = true; }
                if ($("#EIDSSBodyCPH_idfscbLivestock").is(":checked")) { bLivestock = true; }

                if (!(bHuman || bAvian || bLivestock)) {
                    $("#dSpeciesAffectedError").show();
                    $("#bNext,#bSubmit").prop("disabled", "disabled");
                }
                else {
                    $("#dSpeciesAffectedError").hide();
                    $("#bNext,#bSubmit").prop("disabled", "");
                }
            }
        }

        function enableNotifiationName(obj,id) {
            if($("#" + obj.id).val() != ""){
                $("#" + id).prop("disabled", "");
            }
            else {
                $("#" + id).prop("disabled", "disabled");
            }
        }

        function clearContactSelections(object) {
            $("input:checked").prop("checked", "");
            $(object).prop("checked", "checked");
        }

        function returnToTab() {
            //Regardless of the situation, always return to the currenttab, incase of a post back that takes away the focus of the current one being worked on.
            goToTab(currentTab);
        }

        function setPreviousCaseButtons() {
            if (parseInt(currentTab) == 0) {
                $("#EIDSSBodyCPH_btnPreviousCaseEntry").hide();
            }
            else {
                $("#EIDSSBodyCPH_btnPreviousCaseEntry").show();
            }
        }

        function setVetPreviousCaseButtons() {
            $("#btnVetSubmitCaseEntry").show();

            if (parseInt(currentTab) == 0) {
                $("#EIDSSBodyCPH_btnVetPreviousCaseEntry").hide();
            }
            else {
                $("#EIDSSBodyCPH_btnVetPreviousCaseEntry").show();
            }
        }

        function setNextCaseButtons() {
            if (parseInt(currentTab) == 8) {
                $("#EIDSSBodyCPH_btnNextCaseEntry").hide();
                $("#btnSubmitCaseEntry").removeClass("hidden");
            }
            else {
                $("#EIDSSBodyCPH_btnPreviousCaseEntry").show();
                $("#btnSubmitCaseEntry").addClass("hidden");
            }
        }

        function setVetNextCaseButtons() {
            if (parseInt(currentTab) == 11) {
                $("#EIDSSBodyCPH_btnVetNextCaseEntry").hide();
                $("#btnVetSubmitCaseEntry").show();
            }
            else {
                $("#EIDSSBodyCPH_btnVetPreviousCaseEntry").show();
                $("#btnVetSubmitCaseEntry").hide();
            }
        }

        function alterCalendarInputJavascript() {
            var js = $($("script:contains('wirePickerEIDSSBodyCPH_ciDateOfNotification')")[0]).html().replace("minDate: '9/9/9999'", "3/1/2019").Replace("maxDate: '9/9/9999'", "3/20/2019");

            $("script:contains('wirePickerEIDSSBodyCPH_ciDateOfNotification')").html(js);
        }

        function enableVaccinationAdd() {
            if ($("#cidatDateOfVaccination").val() != "" &&
                $("#txtstrVaccinationName").val() != "") {
                $("#btnAddVaccination").prop("disabled","");
            }
            else {
                $("#btnAddVaccination").prop("disabled","disabled");
            }
        }

        function enableContactAdd() {
            if ($("#txtContactName").val() != "" &&
                $("#ddlContactRelationshipType").val() != "" &&
                $("#cidatDateOfLastContact").val() != "" &&
                $("#tx2PlaceOfLastContact").val() != "" &&
                $("#ddlContactStatus").val() != "" &&
                $("#txtstrContactComments").val() != "" &&
                $("#bBatchAddContact").val() != "") {

                $("#bBatchAddContact").prop("disabled","");
            }
            else {
                $("#bBatchAddContact").prop("disabled","disabled");
            }
        }

        function enableVetContactAdd() {
            if ($("#tx2VetContactName").val() != "" &&
                $("#ddlVetContactRelationshipType").val() != "" &&
                $("#ciVetdatDateOfLastContact").val() != "" &&
                $("#tx2VetPlaceOfLastContact").val() != "" &&
                $("#ddlVetContactStatus").val() != "" &&
                $("#txtVetstrContactComments").val() != "" &&
                $("#bBatchAddVetContact").val() != "") {

                $("#bBatchAddVetContact").prop("disabled","");
            }
            else {
                $("#bBatchAddVetContact").prop("disabled","disabled");
            }
        }
        
        function setSamplesPage() {
            $("#dSamplesYes,#dSamplesNo").hide();

            switch ($("#rblSamplesCollected input:checked").val()) {
                case '10100001':
                    $("#dSamplesYes").show();
                    break;
                case '10100002':
                    $("#dSamplesNo").show();
                    break;
                case '10100003':
                    break;
            }
        }

        function showSamplesAdd() {
            if ($("#ddlSampleType").val() != 'null' &&
                $("#txtSentToOrganization").val() != "") {
                $("#btnAddCaseSample").prop("disabled", "");
            }
            else {
                $("#btnAddCaseSample").prop("disabled", "disabled");
            }
        }

        function enableVetCaseMonitoringAdd() {
            if ($("#ciVetdatMonitoringDate").val() != "" &&
                $("#tx2VetAdditionalComments").val() != "" &&
                $("#tx2VetMonitoringInvestigatorOrganization").val() != "" &&
                $("#tx2VetMonitoringInvestigatorName").val() != "") {

                $("#btnVetAddCaseMonitoring").prop("disabled","");
            }
            else {
                $("#btnVetAddCaseMonitoring").prop("disabled","disabled");
            }
        }

        function enableVetPensideTestAdd() {
            if (
                $("#ddlVetFieldSampleId").val() != "" &&
                $("#txtVetSampleType").val() != "" &&
                $("#txtVetSpecies").val() != "" &&
                $("#txtVetAnimalId").val() != "" &&
                $("#ddlVetTestName").val() != "" &&
                $("#ddlVetResult").val() != ""
            ) {

                $("#btnAddPensideText").prop("disabled","");
            }
            else {
                $("#btnAddPensideText").prop("disabled","disabled");
            }
        }

        function toggleAdvanceSearchCriteria() {
            if ($("#dSearchForm").is(":visible")) {
                $('#EIDSSBodyCPH_toggleIcon').addClass("glyphicon-triangle-bottom");
                $('#EIDSSBodyCPH_toggleIcon').removeClass("glyphicon-triangle-top");
                $('#dSearchForm').collapse('hide');
            }
            else {
                $('#EIDSSBodyCPH_toggleIcon').removeClass("glyphicon-triangle-bottom");
                $('#EIDSSBodyCPH_toggleIcon').addClass("glyphicon-triangle-top");
                $('#dSearchForm').collapse('show');
            }
        }

        function clearQuickSearch() {
            if ($("#obmtxtstrquickSearch").val() != "") {
                $("#obmtxtstrquickSearch").val("");
                $("#btnIdSearch span").click();
            }
        }

        function copyCoordinatesFromMap() {

        }

        function showVSSSubGrid(e, f) {
            var cl = e.target.className;
            if (cl == 'glyphicon glyphicon-triangle-bottom') {
                e.target.className = "glyphicon glyphicon-triangle-top";
                $('#' + f).show();
            }
            else {
                e.target.className = "glyphicon glyphicon-triangle-bottom";
                $('#' + f).hide();
            }
        };
    </script>

</asp:Content>
