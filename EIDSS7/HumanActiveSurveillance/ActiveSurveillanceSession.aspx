<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="ActiveSurveillanceSession.aspx.vb" EnableEventValidation="true" Inherits="EIDSS.ActiveSurveillanceSession" MaintainScrollPositionOnPostback="true"
    meta:resourcekey="Page" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdateProgress runat="server">
        <ProgressTemplate>
            <div class="modal" role="dialog">
                <div class="modal-dialog" id="pleaseWaitModal" runat="server" meta:resourcekey="Pnl_Please_Wait">
                    <div class="modal-content">
                        <div class="modal-body">
                            <asp:Label ID="pleaseWaitbody" runat="server" meta:resourcekey="Lbl_Please_Wait"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="uppPanel" runat="server">
        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div id="divHiddenFieldsSection" runat="server">
                        <asp:HiddenField ID="hdfidfCampaign" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfMonitoringSession" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfsSite" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfinstitution" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfPersonEnteredBy" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSessionSearchIndex" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSessionSampleTypeID" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSessionSampleTypeIndex" runat="server" Value="-1" />
                        <asp:HiddenField ID="hdfSessionActionID" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSessionActionIndex" runat="server" Value="-1" />
                        <asp:HiddenField ID="hdfSessionDetailID" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSessionDetailIndex" runat="server" Value="-1" />
                        <asp:HiddenField ID="hdfSessionTestID" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSessionTestIndex" runat="server" Value="-1" />
                        <asp:HiddenField ID="hdfdatCampaignDateStart" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfdatCampaignDateEND" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfDeleteSessionFromSearchResults" runat="server" Value="false" />
                        <asp:HiddenField ID="hdfidfUserID" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfEmployee" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfOrganizationFullName" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfInstitution" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfPosition" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfSessionInformationDisplay" runat="server" Value="block" />
                        <asp:HiddenField ID="hdfidfsSiteAK" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfDiagnosis" runat="server" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfDiseaseSelected" Value="NULL" />
                    </div>
                    <div id="divHiddenMaterialSection" runat="server">
                        <asp:HiddenField runat="server" ID="hdfNewMaterialID" Value="0" />
                        <asp:HiddenField ID="hdfidfRootMaterial" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfParentMaterial" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfAnimal" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfdatFieldSentDate" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfVectorSurveillanceSession" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfVector" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfSubdivision" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfsSampleStatus" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfInDepartment" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfDestroyedByPerson" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfdatEnteringDate" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfdatDestructionDate" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfstrBarcode" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfstrNote" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfintRowStatus" runat="server" Value="0" />
                        <asp:HiddenField ID="hdfblnReadOnly" runat="server" Value="False" />
                        <asp:HiddenField ID="hdfidfsBirdStatus" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfHumanCase" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfVetCase" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfdatAccession" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfsAccessionCondition" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfstrCondition" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfAccesionByPerson" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfsDestructionMethod" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfsCurrentSite" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfsSampleKind" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfidfMarkedForDispositionByPerson" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfdatOutOfRepositoryDate" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfstrMaintenanceFlag" runat="server" Value="NULL" />
                    </div>
                    <div id="divHiddenEmployeeSearch" runat="server">
                        <asp:HiddenField runat="server" ID="hdfLangID" Value="en-us" />
                        <asp:HiddenField runat="server" ID="hdfPageIndex" Value="1" />
                        <asp:HiddenField runat="server" ID="hdfPageSize" Value="1000" />
                        <asp:HiddenField runat="server" ID="hdfRecordCount" Value="0" />
                    </div>
                    <div id="divHiddenTestingSession" runat="server">
                        <asp:HiddenField ID="hdfTestidfsDiagnosis" runat="server" Value="779090000000" />
                        <asp:HiddenField ID="hdfTestidfsTestStatus" runat="server" Value="0" />
                        <asp:HiddenField ID="hdfTestidfBatchTest" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfObservation" runat="server" Value="0" />
                        <asp:HiddenField ID="hdfTestintTestNumber" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTeststrNote" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestintRowStatus" runat="server" Value="0" />
                        <asp:HiddenField ID="hdfTestdatStartedDate" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfTestedByOffice" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfTestedByPerson" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfResultEnteredByOffice" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfResultEnteredByPerson" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfValidatedByOffice" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfValidatedByPerson" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestblnReadOnly" runat="server" Value="0" />
                        <asp:HiddenField ID="hdfTestblnNonLaboratoryTest" runat="server" Value="0" />
                        <asp:HiddenField ID="hdfTestblnExternalTest" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestidfPerformedByOffice" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTestdatReceivedDate" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTeststrContactPerson" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTeststrMaintenanceFlag" runat="server" Value="NULL" />
                        <asp:HiddenField ID="hdfTeststrReservedAttribute" runat="server" Value="NULL" />
                    </div>

                   <div id="divHiddenSummary" runat="server">
                        <asp:HiddenField runat="server" ID="hdfsessionIDsummary" Value="Null" />
                        <asp:HiddenField runat="server" ID="hdfsessionStatusSummary" Value="Null" />
                        <asp:HiddenField runat="server" ID="hdfsessionDiseaseSummary" Value="Null" />

                    </div>


                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h2 id="hdgActiveSurveillanceSession" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h2>
                            <h2 id="hdgActiveSurveillanceSessionReview" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session_Review"></h2>
                        </div>
                        <div class="panel-body">
                            <div id="searchForm" runat="server">
                                <div id="search" class="embed-panel" runat="server">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                    <h3 id="hdgSearchCriteria" class="heading" runat="server" meta:resourcekey="hdg_Search_Criteria"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                                    <span id="btnShowSearchCriteria" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" visible="false" meta:resourcekey="btn_Show_Search_Criteria" onclick="showSearchCriteria(event);"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="searchCriteria" runat="server" class="panel-body">
                                            <p runat="server" meta:resourcekey="lbl_Search_Instructions"></p>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Session_ID_Number"></label>
                                                        <asp:TextBox ID="txtMonitoringSessionstrID" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="searchCriteria_Changed"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Or"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                        <label runat="server" meta:resourcekey="lbl_Campaign_ID_Number"></label>
                                                        <div class="input-group">
                                                            <div class="input-group-btn">
                                                                <button class="btn" runat="server" id="btnSearchforCampaignID" type="submit" meta:resourcekey="btn_Search_Campaign">
                                                                    <span class="glyphicon glyphicon-search"></span>
                                                                </button>
                                                            </div>
                                                            <asp:TextBox ID="txtMonitoringSessionstrCampaignID" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-3 col-xs-12" runat="server" meta:resourcekey="dis_Search_Session_Status">
                                                        <label runat="server" meta:resourcekey="lbl_Session_Status"></label>
                                                        <asp:DropDownList ID="ddlMonitoringSessionidfsStatus" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="searchCriteria_Changed"></asp:DropDownList>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-5 col-xs-12" runat="server" meta:resourcekey="dis_Search_Session_Disease">
                                                        <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                        <asp:DropDownList ID="ddlMonitoringSessionidfsDiagnosis" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="searchCriteria_Changed"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <fieldset runat="server" meta:resourcekey="dis_Search_Date_Range">
                                                <legend runat="server" meta:resourcekey="lbl_Date_Entered_Range"></legend>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_From"></label>
                                                            <eidss:CalendarInput ID="txtMonitoringSessionDatEnteredFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_To"></label>
                                                            <eidss:CalendarInput ID="txtMonitoringSessionDatEnteredTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                        </div>
                                                    </div>
                                                </div>
                                            </fieldset>
                                            <eidss:LocationUserControl ID="MonitoringSession" runat="server" IsHorizontalLayout="true" ShowCountry="false" ShowTownOrVillage="false" ShowStreet="false" ShowPostalCode="false" ShowCoordinates="false" ShowElevation="false" ShowBuildingHouseApartmentGroup="false" IsDbRequiredRegion="false" />
                                        </div>
                                    </div>
                                </div>
                                <div id="searchResults" class="embed-panel" runat="server" visible="false">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                    <h3 class="heading" runat="server" meta:resourcekey="hdg_Search_Results"></h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <eidss:GridView ID="gvSearchResults"
                                                    runat="server"
                                                    AllowPaging="true"
                                                    AllowSorting="true"
                                                    PageSize="10"
                                                    AutoGenerateColumns="false"
                                                    CssClass="table table-striped table-hover"
                                                    GridLines="None"
                                                    RowStyle-CssClass="table"
                                                    meta:resourcekey="grd_Search"
                                                    ShowHeaderWhenEmpty="true"
                                                    ShowFooter="True"
                                                    DataKeyNames="idfMonitoringSession"
                                                    OnPageIndexChanging="gvSearchResults_PageIndexChanging"
                                                    OnSelectedIndexChanging="gvSearchResults_SelectedIndexChanging"
                                                    OnRowEditing="gvSearchResults_RowEditing"
                                                    OnRowDeleting="gvSearchResults_RowDeleting" OnRowDataBound="gvSearchResults_RowDataBound"
                                                    OnSorting="gvSearchResults_Sorting">
                                                    <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                    <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_Session_ID_Number.InnerText %>" SortExpression="strMonitoringSessionID">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnSelect" runat="server" CausesValidation="False" CommandName="select" meta:resourceKey="btn_Select_Session"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' Text='<%# Eval("strMonitoringSessionID") %>'></asp:LinkButton>
                                                                <asp:Label ID="lblstrMonitoringSessionID" runat="server" Text='<%# Eval("strMonitoringSessionID") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="MonitoringSessionStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Session_Status.InnerText %>" SortExpression="MonitoringSessionStatus" />
                                                        <asp:BoundField DataField="datEnteredDate" DataFormatString="{0:MM/dd/yyyy}" ReadOnly="true" HeaderText="<%$ Resources:lbl_Date_Entered.InnerText %>" SortExpression="datEnteredDate" />
                                                        <asp:BoundField DataField="Region" ReadOnly="true" HeaderText="<%$ Resources:lbl_Region.InnerText %>" SortExpression="Region" />
                                                        <asp:BoundField DataField="Rayon" ReadOnly="true" HeaderText="<%$ Resources:lbl_Rayon.InnerText %>" SortExpression="Rayon" />
                                                        <asp:BoundField DataField="Diagnosis" ReadOnly="true" HeaderText="<%$ Resources:lbl_Disease.InnerText %>" SortExpression="Diagnosis" />
                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Session"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Session"
                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' Text=""><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField ItemStyle-CssClass="icon">
                                                            <ItemTemplate>
                                                                <span class="glyphicon glyphicon-triangle-bottom" onclick="showSubGrid(event,'divHASS<%#Eval("idfMonitoringSession") %>');"></span>
                                                                <tr id="divHASS<%# Eval("idfMonitoringSession") %>" style="display: none;">
                                                                    <td colspan="6" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                                        <div>
                                                                            <div class="form-group form-group-sm">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Start_Date"></label>
                                                                                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control input-sm" Text='<%# String.Format("{0:MM/dd/yyyy}", Eval("datStartDate")) %>' Enabled="false"></asp:TextBox>
                                                                                    </div>
                                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="lbl_End_Date"></label>
                                                                                        <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control input-sm" Text='<%# String.Format("{0:MM/dd/yyyy}", Eval("datEndDate")) %>' Enabled="false"></asp:TextBox>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group form-group-sm">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Site"></label>
                                                                                        <asp:TextBox ID="txtstrSite" runat="server" CssClass="form-control input-sm" Text='<%# Eval("EnglishName") %>' Enabled="false"></asp:TextBox>
                                                                                    </div>
                                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Officer"></label>
                                                                                        <asp:TextBox ID="txtstrOfficer" runat="server" CssClass="form-control input-sm" Text='<%# Eval("Officer") %>' Enabled="false"></asp:TextBox>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group form-group-sm">
                                                                                <div class="row">
                                                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                                                        <label class="table-striped-header" runat="server" meta:resourcekey="lbl_Town"></label>
                                                                                        <asp:TextBox ID="txtstrTown" runat="server" CssClass="form-control input-sm" Text='<%# Eval("Town") %>' Enabled="false"></asp:TextBox>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
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
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                            <button id="btnCancelSessionRTD" type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel" data-toggle="modal" data-target="#sessionCancelModal"></button>

                                            <asp:Button ID="btnClear" CssClass="btn btn-default" runat="server" meta:resourcekey="btn_Clear" OnClick="btnClear_Click" />
                                            <asp:Button ID="btnSearch" CssClass="btn btn-primary" runat="server" meta:resourcekey="btn_Search" OnClick="btnSearch_Click" />
                                            <asp:Button ID="btnCreateSession" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Create_Session" OnClick="btnCreateSession_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="sessions" class="embed-panel" runat="server" visible="false">
                                <div class="sectionContainer expanded">
                                    <section id="sessionInformation" runat="server" class="col-md-12">
                                        <div id="sesInfo" runat="server" class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-10 col-md-10 col-sm-10 col-xs-9">
                                                        <h3 class="heading" runat="server" meta:resourcekey="hdg_Session_Information"></h3>
                                                    </div>
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-3 text-right">
                                                        <asp:LinkButton ID="btnShowCampaignInformation" runat="server" CssClass="btn" meta:resourceKey="btn_Show_Session_Information"><span id="campaignInformationStatus" runat="server" class="glyphicon glyphicon-triangle-top header-button"></span></asp:LinkButton>
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)" runat="server" meta:resourcekey="btn_Go_To_Session_Information"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="sessionDetail" runat="server" class="panel-body">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div id="divstrSessionID" class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" visible="false" meta:resourcekey="dis_Session_ID_Number">
                                                            <label runat="server" meta:resourcekey="lbl_Session_ID_Number"></label>
                                                            <asp:TextBox ID="txtstrMonitoringSessionID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Session_Status">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_Status"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Session_Status"></label>
                                                            <asp:DropDownList ID="ddlidfsMonitoringSessionStatus" runat="server" CssClass="form-control"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsMonitoringSessionStatus" CssClass="text-danger" InitialValue="null" Display="Dynamic" ValidationGroup="sessionInformation" meta:resourceKey="val_Session_Status"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <fieldset id="campaignInformation" runat="server" class="panel-body">
                                                    <legend runat="server" meta:resourcekey="hdg_Campaign_Information"></legend>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Campaign_ID_Number"></label>
                                                                <div class="input-group">
                                                                    <div class="input-group-btn">
                                                                        <button class="btn" runat="server" id="btnCampaignIDSearch" type="submit" meta:resourcekey="btn_Search_Campaign">
                                                                            <span class="glyphicon glyphicon-search"></span>
                                                                        </button>
                                                                    </div>
                                                                    <asp:TextBox ID="txtstrCampaignID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Campaign_Name"></label>
                                                                <asp:TextBox ID="txtstrCampaignName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Campaign_Type"></label>
                                                                <asp:TextBox ID="txtstrCampaignType" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Session_Start_Date">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_Start_Date"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Session_Start_Date"></label>
                                                            <eidss:CalendarInput ID="txtdatStartDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtdatStartDate" CssClass="text-danger" InitialValue="" Display="Dynamic" ValidationGroup="sessionInformation" meta:resourceKey="val_Session_Start_Date"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Session_End_Date">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_End_Date"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Session_End_Date"></label>
                                                            <eidss:CalendarInput ID="txtdatEndDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtdatEndDate" CssClass="text-danger" InitialValue="" Display="Dynamic" ValidationGroup="sessionInformation" meta:resourceKey="val_Session_End_Date"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="divSessionDiagnosis" runat="server" meta:resourcekey="dis_Session_Diagnosis" class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-8 col-md-8 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Diagnosis">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_Diagnosis"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                            <asp:DropDownList ID="ddlidfsDiagnosis" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlidfsDiagnosis_SelectedIndexChanged"></asp:DropDownList>
                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsDiagnosis" CssClass="text-danger" InitialValue="null" Display="Dynamic" ValidationGroup="sessionInformation" meta:resourceKey="val_Session_Diagnosis"></asp:RequiredFieldValidator>
                                                        </div>
             
                                                    </div>




                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label runat="server" meta:resourcekey="lbl_Site"></label>
                                                            <asp:TextBox ID="txtstrSite" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label runat="server" meta:resourcekey="lbl_Officer"></label>
                                                            <asp:TextBox ID="txtstrOfficer" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                                                            <label runat="server" meta:resourcekey="lbl_Date_Entered"></label>
                                                            <asp:TextBox ID="txtdatEnteredDate" runat="server" CssClass="form-control" Enabled="false" Text='<%# String.Format("{0:d}", DateTime.Today) %>'></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="sesLocInfo" runat="server" class="panel panel-default">
                                            <div class="panel-heading">
                                                <h3 class="heading" runat="server" meta:resourcekey="hdg_Session_Location"></h3>
                                            </div>
                                            <div class="panel-body">
                                                <eidss:LocationUserControl ID="sLI" runat="server" IsHorizontalLayout="true" IsDbRequiredRegion="true" IsDbRequiredCountry="true" IsDbRequiredRayon="false" IsDbRequiredTown="false" ShowCountry="true" ShowRegion="true" ShowRayon="true" ShowTownOrVillage="true" ShowStreet="false" ShowBuildingHouseApartmentGroup="false" ShowPostalCode="false" ShowCoordinates="false" ShowElevation="false" />
                                            </div>
                                        </div>

                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-6">
                                                        <h3 class="heading" runat="server" meta:resourcekey="hdg_Samples"></h3>
                                                    </div>
                                            </div>
                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <eidss:GridView
                                                        AllowPaging="true"
                                                        AllowSorting="true"
                                                        AutoGenerateColumns="false"
                                                        CaptionAlign="Top"
                                                        CssClass="table table-striped table-hover"
                                                        GridLines="None"
                                                        ID="gvSamples"
                                                        DataKeyNames="MonitoringSessionToSampleType"
                                                        KeyNameUsedOnModal="FullName"
                                                        meta:resourcekey="Grd_Sample"
                                                        runat="server"
                                                        ShowFooter="true"
                                                        ShowHeader="true" ShowHeaderWhenEmpty="true"
                                                        OnRowDataBound="gvSamples_RowDataBound"
                                                        OnRowEditing="gvSamples_RowEditing"
                                                        OnRowCancelingEdit="gvSamples_RowCancelingEdit"
                                                        OnRowUpdating="gvSamples_RowUpdating"
                                                        OnRowCommand="gvSamples_RowCommand"
                                                        UseAccessibleHeader="true">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                        <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                        <SortedAscendingCellStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                        <SortedDescendingCellStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                        <Columns>
                                                            <%--Fields to display--%>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <%# GetLocalResourceObject("lbl_Sample_Type.InnerText") %>
                                                                    <asp:DropDownList ID="ddlSampleType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSampleTypeText" runat="server" Text='<%# Bind("SampleType") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList ID="ddlSampleType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ControlStyle-CssClass="icon" ItemStyle-CssClass="icon">
                                                                <HeaderTemplate>
                                                                    <br />
                                                                    <asp:LinkButton ID="btnAdd" runat="server" CausesValidation="False" CommandName="insert" meta:resourceKey="btn_Insert_Sample_Type"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-plus-sign"></span></asp:LinkButton>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Sample_Type"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:LinkButton ID="btnUpdate" runat="server" CausesValidation="False" CommandName="update" meta:resourceKey="btn_Save_Sample_Type"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-disk"></span></asp:LinkButton>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icon" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Sample_Type"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:LinkButton ID="btnCancel" runat="server" CausesValidation="False" CommandName="cancel" meta:resourceKey="btn_Cancel_Sample_Type"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-remove"></span></asp:LinkButton>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </eidss:GridView>
                                                </div>
                                            </div>
                                        </div>


                                    </section>  <%-- end session information--%>

                                    <section id="personsAndSamples" class="col-md-12" runat="server" visible="false">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                        <h3 class="heading" runat="server" meta:resourcekey="hdg_Persons_Samples"></h3>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                        <input type="submit" id="btnCreateDetails" runat="server" class="btn btn-default btn-sm" meta:resourcekey="btn_Create_Details" />
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)" runat="server" meta:resourcekey="btn_Go_To_Details"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">

                                                  <fieldset id="sessionSummary" runat="server" class="panel-body">
                                                    <legend runat="server" meta:resourcekey="hdg_Session_Summary"></legend>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div id="divstrSessionIDPerson" class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" visible="true" meta:resourcekey="dis_Session_ID_Number">
                                                            <label runat="server" meta:resourcekey="lbl_Session_ID_Number"></label>
                                                            <asp:TextBox ID="txtstrMonitoringSessionIDPerson" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" meta:resourcekey="dis_Session_Status">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_Status"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Session_Status"></label>

                                                             <asp:TextBox ID="strMonitoringSessionStatusPerson" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                              
                                                          </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                                <asp:TextBox ID="txtstrdisease" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </fieldset>

                                                <div class="form-group">
                                                    <div class="row">
                                                         <div runat="server" meta:resourcekey="Dis_Person_ID" class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <label runat="server" meta:resourcekey="Lbl_Person_ID"></label>
                                                            <asp:TextBox ID="txtSummaryEidsId" runat="server" CssClass="form-control" Enabled="True"></asp:TextBox>
                                                        </div>
                                                        <div runat="server" meta:resourcekey="Dis_Person_Address" class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                                                            <label runat="server" meta:resourcekey="Lbl_Person_Address"></label>
                                                            <asp:TextBox ID="txtSummarystrPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                
                                                    </div>
                                                </div>  


                                                <div id="addDetail" runat="server" visible="false">
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Information_Person_ID">
                                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Detailed_Information_Person_ID"></span>
                                                                <label runat="server" meta:resourcekey="lbl_Person"></label>
                           
                                                                <asp:DropDownList ID="ddlDIstrPersonID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                <asp:RequiredFieldValidator ControlToValidate="ddlDIstrPersonID" CssClass="alert-text" Display="Dynamic" InitialValue="null" meta:resourcekey="val_Detailed_Information_Person_ID" runat="server" ValidationGroup="detailedInformation"></asp:RequiredFieldValidator>

                                                                <asp:HiddenField ID="hdfPersonID" runat="server" Value="NULL" />
                                                                <asp:HiddenField ID="hdfOrganizationID" runat="server" Value="NULL" />
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Information_Person_Address">
                                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Detailed_Information_Person_Address"></span>
                                                                <label runat="server" meta:resourcekey="lbl_Person_Address"></label>
                                                                <asp:TextBox ID="txtDIstrAddress" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                                <asp:RequiredFieldValidator ControlToValidate="txtDIstrAddress" CssClass="alert-text" Display="Dynamic" InitialValue="" meta:resourcekey="val_Detailed_Information_Person_Address" runat="server" ValidationGroup="detailedInformation"></asp:RequiredFieldValidator>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Information_Sample_Type">
                                                                <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Detailed_Information_Sample_Type"></span>
                                                                <label runat="server" meta:resourcekey="lbl_Sample_Type"></label>
                                                                <asp:DropDownList ID="ddlDIidfsSampleType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                <asp:RequiredFieldValidator ControlToValidate="ddlDIidfsSampleType" CssClass="alert-text" Display="Dynamic" InitialValue="null" meta:resourcekey="val_Detailed_Information_Sample_Type" runat="server" ValidationGroup="detailedInformation"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Information_Field_Sample_ID">
                                                                <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Detailed_Information_Field_Sample_ID"></span>
                                                                <label runat="server" meta:resourcekey="lbl_Field_Sample_ID"></label>
                                                                <asp:TextBox ID="txtidfsFieldSampleID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Information_Collection_Date">
                                                                <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Detailed_Information_Collection_Date"></span>
                                                                <label runat="server" meta:resourcekey="lbl_Collection_Date"></label>
                                                                <eidss:CalendarInput ID="txtDIdatCollectionDate" runat="server" CssClass="form-control" ContainerCssClass="input-group datepicker"></eidss:CalendarInput>
                                                                <asp:RequiredFieldValidator ControlToValidate="txtDIdatCollectionDate" CssClass="alert-text" Display="Dynamic" InitialValue="" meta:resourcekey="val_Aggregate_Collection_Date" runat="server" ValidationGroup="detailedInformation"></asp:RequiredFieldValidator>
                                                            </div>
                                                            <div class="col-lg-8 col-md-8 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Detailed_Information_Sent_To_Organization">
                                                                <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Detailed_Information_Sent_To_Organization"></span>
                                                                <label runat="server" meta:resourcekey="lbl_Sent_To_Organization"></label>

                                                                <%--<div class="input-group"><span class="input-group-btn">
                                                                        <button class="btn" runat="server" id="btnOrganizationSearch" type="submit">
                                                                            <i class="glyphicon glyphicon-search"></i>
                                                                        </button>
                                                                    </span></div>--%>
                                                                <asp:DropDownList ID="ddlDIidfsOrganizationID" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                <asp:RequiredFieldValidator ControlToValidate="ddlDIidfsOrganizationID" CssClass="alert-text" Display="Dynamic" InitialValue="null" meta:resourcekey="val_Detailed_Information_Person_ID" runat="server" ValidationGroup="detailedInformation"></asp:RequiredFieldValidator>

                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-12 text-right">
                                                                <input type="submit" id="btnAddDetails" runat="server" class="btn btn-default btn-sm" meta:resourcekey="btn_Add_Detail" />
                                                                <input type="submit" id="btnCancelAddDetail" runat="server" class="btn btn-default btn-sm" meta:resourcekey="btn_Cancel_Detail" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="table-responsive">
                                                    <eidss:GridView
                                                        AllowPaging="True"
                                                        AllowSorting="True"
                                                        AutoGenerateColumns="False"
                                                        CaptionAlign="Top"
                                                        CssClass="table table-striped table-hover"
                                                        DataKeyNames="idfMaterial"
                                                        GridLines="None"
                                                        ID="gvDetailInformation"
                                                        runat="server"
                                                        ShowHeader="true"
                                                        ShowHeaderWhenEmpty="true" OnRowDataBound="gvDetailInformation_RowDataBound" OnRowDeleting="gvDetailInformation_RowDeleting" OnRowCancelingEdit="gvDetailInformation_RowCancelingEdit" OnRowEditing="gvDetailInformation_RowEditing" OnRowCommand="gvDetailInformation_RowCommand">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                        <Columns>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <%# GetLocalResourceObject("lbl_Sample_Type.InnerText") %>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSampleType" runat="server" Text='<%# Bind("SampleTypeName") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList ID="ddlidfsSampleType" runat="server" CssClass="form-control input-sm"></asp:DropDownList>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <%# GetLocalResourceObject("lbl_Field_Sample_ID.InnerText") %>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblTestName" runat="server" Text='<%# Bind("strFieldBarCode") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox ID="txtTestName" runat="server" Text='<%# Bind("strFieldBarCode") %>' CssClass="form-control input-sm" Enabled="false"></asp:TextBox>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <%# GetLocalResourceObject("lbl_Collection_Date.InnerText") %>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblTestResultDate" runat="server" Text='<%# Bind("datFieldCollectionDate", "{0:MM/dd/yyyy}") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <eidss:CalendarInput
                                                                        ContainerCssClass="input-group datepicker"
                                                                        CssClass="form-control"
                                                                        ID="txtdatFieldCollectionDate"
                                                                        runat="server" Text='<%# Bind("datFieldCollectionDate", "{0:MM/dd/yyyy}") %>'></eidss:CalendarInput>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <%# GetLocalResourceObject("lbl_Sent_To_Organization.InnerText") %>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblSendToOffice" runat="server" Text='<%# Bind("SendToOfficeSiteName") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList ID="ddlidfsSendToOffice" runat="server" CssClass="form-control input-sm"></asp:DropDownList>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <HeaderTemplate>
                                                                    <%# GetLocalResourceObject("lbl_Person.InnerText") %>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblFieldCollectedByPersonName" runat="server" Text='<%# Bind("FieldCollectedByPersonName") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList ID="ddlidfsFieldCollectedByPerson" runat="server" CssClass="form-control input-sm"></asp:DropDownList>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:Button ID="btnShowTest" runat="server" CausesValidation="False" CssClass="btn btn-default btn-xs" CommandName="showTest" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourceKey="btn_Add_Tests" Enabled="false" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Detail"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:LinkButton ID="btnUpdate" runat="server" CausesValidation="False" CommandName="update" meta:resourceKey="btn_Update_Detail"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-disk"></span></asp:LinkButton>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Detail"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:LinkButton ID="btnCancel" runat="server" CausesValidation="False" CommandName="cancel" meta:resourceKey="btn_Cancel_Detail"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-remove"></span></asp:LinkButton>
                                                                </EditItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField>
                                                                <ItemTemplate>
                                                                    <asp:HiddenField ID="hdfMaterial" runat="server" Value='<%# Eval("idfMaterial") %>'></asp:HiddenField>
                                                                    <span class="glyphicon glyphicon-triangle-bottom" onclick="showSubGrid(event,'divDetail<%# CType(Container, GridViewRow).RowIndex %>');"></span>
                                                                    <tr id="divDetail<%# CType(Container, GridViewRow).RowIndex %>" style="display: none;">
                                                                        <td colspan="8" style="border-top: 0 solid transparent; border-bottom: 0 solid transparent">
                                                                            <div class="table-responsive">
                                                                                <eidss:GridView ID="gvTests" runat="server"
                                                                                    AutoGenerateColumns="False"
                                                                                    CaptionAlign="Top"
                                                                                    CssClass="table table-striped table-hover"
                                                                                    GridLines="None"
                                                                                    ShowHeader="true"
                                                                                    ShowHeaderWhenEmpty="true" OnRowDeleting="gvTests_RowDeleting"
                                                                                    DataKeyNames="idfTesting">
                                                                                    <Columns>
                                                                                        <asp:TemplateField HeaderText='<%$ Resources:lbl_Test_Name.InnerText %>'>
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblstrTestName" runat="server" Text='<%# Eval("strTestName") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <EditItemTemplate>
                                                                                                <asp:DropDownList ID="ddlidfsTestName" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                                            </EditItemTemplate>
                                                                                        </asp:TemplateField>
                                                                                        <asp:TemplateField HeaderText='<%$ Resources:lbl_Test_Category.InnerText %>'>
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblstrTestCategory" runat="server" Text='<%# Eval("strTestCategory") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <EditItemTemplate>
                                                                                                <asp:DropDownList ID="ddlidfsTestCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                                            </EditItemTemplate>
                                                                                        </asp:TemplateField>
                                                                                        <asp:TemplateField HeaderText='<%$ Resources:lbl_Test_Result.InnerText %>'>
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblstrTestResult" runat="server" Text='<%# Eval("strTestResult") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <EditItemTemplate>
                                                                                                <asp:DropDownList ID="ddlidfsTestResult" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                                            </EditItemTemplate>
                                                                                        </asp:TemplateField>
                                                                                        <asp:TemplateField HeaderText='<%$ Resources:lbl_Test_Result_Date.InnerText %>'>
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lbldatConcludedDate" runat="server" Text='<%# Eval("datConcludedDate", "{0:MM/dd/yyyy}") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <EditItemTemplate>
                                                                                                <eidss:CalendarInput ID="txtdatConcludedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                                                            </EditItemTemplate>
                                                                                        </asp:TemplateField>
                                                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                            <ItemTemplate>
                                                                                                <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Test"
                                                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                            </ItemTemplate>
                                                                                            <EditItemTemplate>
                                                                                                <asp:LinkButton ID="btnUpdate" runat="server" CausesValidation="False" CommandName="update" meta:resourceKey="btn_Update_Test"
                                                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-disk"></span></asp:LinkButton>
                                                                                            </EditItemTemplate>
                                                                                        </asp:TemplateField>
                                                                                        <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                                            <ItemTemplate>
                                                                                                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Test"
                                                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                            </ItemTemplate>
                                                                                            <EditItemTemplate>
                                                                                                <asp:LinkButton ID="btnCancel" runat="server" CausesValidation="False" CommandName="cancel" meta:resourceKey="btn_Cancel_Test"
                                                                                                    CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-remove"></span></asp:LinkButton>
                                                                                            </EditItemTemplate>
                                                                                        </asp:TemplateField>
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
                                    </section>  <%--Ends Person & Samples Section--%>


 


                                    <section id="actions" class="col-md-12 hidden" runat="server" visible="false">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                        <h3 class="heading" id="actionsHdg" runat="server" meta:resourcekey="hdg_Actions"></h3>
                                                    </div>



                                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                        <input type="submit" id="btnCreateActions" runat="server" class="btn btn-default btn-sm" meta:resourcekey="btn_Create_Actions" visible="false" />
                                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" runat="server" onclick="goToTab(2)" meta:resourcekey="btn_Go_To_Actions"></a>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel-body">



                                                 <fieldset id="actionSummary" runat="server" class="panel-body">
                                                    <legend runat="server" meta:resourcekey="hdg_Session_Summary"></legend>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div id="divstrSessionIDAction" class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" visible="true" meta:resourcekey="dis_Session_ID_Number">
                                                            <label runat="server" meta:resourcekey="lbl_Session_ID_Number"></label>
                                                            <asp:TextBox ID="txtstrMonitoringSessionIDAction" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" meta:resourcekey="dis_Session_Status">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_Status"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Session_Status"></label>

                                                             <asp:TextBox ID="strMonitoringSessionStatusAction" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                              
                                                          </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                                <asp:TextBox ID="txtdiseaseSummaryAction" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </fieldset>


 


                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-6 col-sm-6 col-xs-12">
                                                            <label runat="server" meta:resourcekey="lbl_Action_Entries"></label>
                                                            <div class="input-group">
                                                                <div class="btn btn-group">
                                                                    <asp:RadioButton ID="rdbActionEntriesYes" runat="server" GroupName="ActionEntries" CssClass="radio-inline" AutoPostBack="true" OnCheckedChanged="rdbActionEntries_CheckedChanged" meta:resourceKey="lbl_Yes" />
                                                                    <asp:RadioButton ID="rdbActionEntriesNo" runat="server" GroupName="ActionEntries" CssClass="radio-inline" AutoPostBack="true" OnCheckedChanged="rdbActionEntries_CheckedChanged" meta:resourceKey="lbl_No" />
                                                                    <asp:RadioButton ID="rdbActionEntriesUnknown" runat="server" GroupName="ActionEntries" CssClass="radio-inline" AutoPostBack="true" OnCheckedChanged="rdbActionEntries_CheckedChanged" meta:resourceKey="lbl_Unknown" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="actionReq" runat="server" visible="true">
                                                    <div id="addAction" runat="server" visible="true">
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Actions_Action_Required">
                                                                    <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Actions_Action_Required"></span>
                                                                    <label runat="server" meta:resourcekey="lbl_Action_Required"></label>
                                                                    <asp:DropDownList ID="ddlidfsActionType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Actions_Date">
                                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Actions_Date"></span>
                                                                    <label runat="server" meta:resourcekey="lbl_Date_of_Action"></label>
                                                                    <eidss:CalendarInput ID="txtdatActionDate" runat="server" CssClass="form-control" ContainerCssClass="input-group datepicker"></eidss:CalendarInput>
                                                                    <asp:RequiredFieldValidator ControlToValidate="txtdatActionDate" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="val_Actions_Date" runat="server" ValidationGroup="actions"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Actions_Entered_By">
                                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Actions_Entered_By"></span>
                                                                    <label runat="server" meta:resourcekey="lbl_Entered_By"></label>
                                                                    <asp:DropDownList ID="ddlidfsEnteredBy" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                    <asp:RequiredFieldValidator ControlToValidate="ddlidfsEnteredBy" CssClass="alert-text" Display="Dynamic" InitialValue="null" meta:resourcekey="val_Actions_Entered_By" runat="server" ValidationGroup="actions"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Actions_Status">
                                                                    <span class="glyphicon glyphicon-certificate text-danger" runat="server" meta:resourcekey="req_Actions_Status"></span>
                                                                    <label runat="server" meta:resourcekey="lbl_Status"></label>
                                                                    <asp:DropDownList ID="ddlidfsActionStatus" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group" runat="server" meta:resourcekey="dis_Actions_Comments">
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                    <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Actions_Comments"></span>
                                                                    <label runat="server" meta:resourcekey="lbl_Comments"></label>
                                                                    <asp:TextBox ID="txtstrComments" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ControlToValidate="txtstrComments" CssClass="text-danger" Display="Dynamic" InitialValue="null" meta:resourcekey="val_Actions_Comments" runat="server" ValidationGroup="actions"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                                                    <asp:Button ID="btnNewAction" runat="server" CssClass="btn btn-default btn-sm" meta:resourceKey="btn_Add_Action" OnClick="btnNewAction_Click" />
                                                                    <asp:Button ID="btnCancelAction" runat="server" CssClass="btn btn-default btn-sm" meta:resourceKey="btn_Cancel_Action" OnClick="btnCancelAction_Click" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="table-responsive">
                                                        <eidss:GridView
                                                            AllowPaging="True"
                                                            AllowSorting="True"
                                                            AutoGenerateColumns="False"
                                                            CaptionAlign="Top"
                                                            CssClass="table table-striped table-hover"
                                                            DataKeyNames="idfMonitoringSessionAction"
                                                            GridLines="None"
                                                            ID="gvActions"
                                                            meta:resourcekey="Grd_Actions"
                                                            runat="server"
                                                            OnRowCommand="gvActions_RowCommand"
                                                            OnRowDeleting="gvActions_RowDeleting"
                                                            OnRowCancelingEdit="gvActions_RowCancelingEdit"
                                                            OnRowUpdating="gvActions_RowUpdating"
                                                            OnRowDataBound="gvActions_RowDataBound">
                                                            <HeaderStyle CssClass="table-striped-header" />
                                                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                            <Columns>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <asp:Label runat="server" Text='<%$ Resources:lbl_Action_Required.InnerText %>'></asp:Label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblMonitoringSessionActionStatus" runat="server" Text='<%# Eval("strMonitoringSessionActionStatus") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:DropDownList ID="ddlMonitoringSessionActionStatus" runat="server" CssClass="form-control input-sm"></asp:DropDownList>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <asp:Label runat="server" Text='<%$ Resources:lbl_Action_Required.InnerText %>'></asp:Label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblMonitoringSessionActionType" runat="server" Text='<%# Eval("strMonitoringSessionActionType") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:DropDownList ID="ddlMonitoringSessionActionType" runat="server" CssClass="form-control input-sm"></asp:DropDownList>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <asp:Label runat="server" Text='<%$ Resources:lbl_Date_of_Action.InnerText %>'></asp:Label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblActionDate" runat="server" Text='<%# Eval("datActionDate", "{0:MM/dd/yyyy}") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <eidss:CalendarInput ID="txtActionDate" runat="server" CssClass="form-control" ContainerCssClass="input-group datepicker" Text='<%# Eval("datActionDate", "{0:MM/dd/yyyy}") %>'></eidss:CalendarInput>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <asp:Label runat="server" Text='<%$ Resources:lbl_Entered_By.InnerText %>'></asp:Label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblPersonEnteredBy" runat="server" Text='<%# Eval("strPersonEnteredBy") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:DropDownList ID="ddlPersonEnteredBy" runat="server" CssClass="form-control input-sm"></asp:DropDownList>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <HeaderTemplate>
                                                                        <asp:Label runat="server" Text='<%$ Resources:lbl_Comments.InnerText %>'></asp:Label>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblstrComments" runat="server" Text='<%# Eval("strComments") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:TextBox ID="txtComments" runat="server" Text='<%# Eval("strComments") %>' TextMode="MultiLine" CssClass="form-control input-sm"></asp:TextBox>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="False">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnbEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Actions"
                                                                            CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:LinkButton ID="lnbUpdate" runat="server" CausesValidation="False" CommandName="update" meta:resourceKey="btn_Save_Actions"
                                                                            CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-disk"></span></asp:LinkButton>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField ShowHeader="False">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnbDelete" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Actions"
                                                                            CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                    <EditItemTemplate>
                                                                        <asp:LinkButton ID="lnbCancel" runat="server" CausesValidation="False" CommandName="cancel" meta:resourceKey="btn_Cancel_Actions"
                                                                            CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-floppy-remove"></span></asp:LinkButton>
                                                                    </EditItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </eidss:GridView>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </section> <%--Ends Actions Section--%>

                                   <section id="diseaseReport" runat="server" visible="false">
                                        <%--Needs to be implemented--%>
                                     <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Disease_Reports"></h3>
                                                </div>







                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnDiseaseReport" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Test" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(3)" runat="server" meta:resourcekey="lbl_Tests_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <asp:Panel ID="Panel1" class="row embed-panel" runat="server">
                                                    <div class="panel-body">





                                                 <fieldset id="diseaseReportSummary" runat="server" class="panel-body">
                                                    <legend runat="server" meta:resourcekey="hdg_Session_Summary"></legend>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div id="divstrSessionIDDR" class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" visible="true" meta:resourcekey="dis_Session_ID_Number">
                                                            <label runat="server" meta:resourcekey="lbl_Session_ID_Number"></label>
                                                            <asp:TextBox ID="txtstrMonitoringSessionIDDR" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" meta:resourcekey="dis_Session_Status">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_Status"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Session_Status"></label>

                                                             <asp:TextBox ID="strMonitoringSessionStatusDR" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                              
                                                          </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                                <asp:TextBox ID="txtdiseaseSummaryDR" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </fieldset>









                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="GridView1"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="No data available."
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, idfsSampleType, idfsTestName, idfsTestCategory, idfsTestResult, idfsTestStatus, idfsDiagnosis, idfTestedByOffice, datReceivedDate, datConcludedDate, idfTestedByPerson, strBarcode, testGuid, sampleGuid "
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />

                                                                <Columns>
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="name" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Name %>" />
                                                                    <asp:BoundField DataField="strTestStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Status %>" />
                                                                    <asp:BoundField DataField="datReceivedDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Date_Received %>" DataFormatString="{0:d}" />

                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </div>
                                        </div>
                                    </div>
                                    </section> <%--Ends DiseaseReport Section--%>

                <%--Cant retrieve data from database with out this Samples  was here --%>

                                <section id="testsTab" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h3 runat="server" meta:resourcekey="hdg_Tests_Tab"></h3>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnAddNewTest" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Test" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(4)" runat="server" meta:resourcekey="lbl_Tests_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">

                                                 <fieldset id="TesttabSummary" runat="server" class="panel-body">
                                                    <legend runat="server" meta:resourcekey="hdg_Session_Summary"></legend>
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div id="divstrSessionIDTesttab" class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" visible="true" meta:resourcekey="dis_Session_ID_Number">
                                                            <label runat="server" meta:resourcekey="lbl_Session_ID_Number"></label>
                                                            <asp:TextBox ID="txtstrMonitoringSessionIDTesttab" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                        <div class="col-lg-3 col-md-2 col-sm-2 col-xs-8" runat="server" meta:resourcekey="dis_Session_Status">
                                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Session_Status"></span>
                                                            <label runat="server" meta:resourcekey="lbl_Session_Status"></label>

                                                             <asp:TextBox ID="strMonitoringSessionStatusTesttab" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                              
                                                          </div>
                                                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                                <label runat="server" meta:resourcekey="lbl_Disease"></label>
                                                                <asp:TextBox ID="txtdiseaseSummaryTesttab" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </fieldset>

                                         <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12"> 
                                                    <label for="txtlabSampleId" runat="server" meta:resourcekey="lbl_lab_Sample_ID"></label>           
                                                    <asp:TextBox ID="txtlabSampleId" runat="server" > </asp:TextBox>
                                            
                                                </div> 
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" >
                                                    <label for="ddlfieldSampleId" runat="server" meta:resourcekey="lbl_field_Sample_ID"></label>     
                                                    <asp:DropDownList ID="ddlfieldSampleId" runat="server" CssClass="form-control" ></asp:DropDownList>
                                                    <%--<asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddlAddFieldTestFieldSampleID_SelectedIndexChanged"></asp:DropDownList>--%>
<%--                                                     <eidss:DropDownList runat="server" ID="masddlSampleType" CssClass="form-control" />--%>
                                                    
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                                    <label for="txtSampleType" runat="server" meta:resourcekey="lbl_Sample_Type"></label>     
                                                    <asp:TextBox ID="txtSampleType" runat="server" > </asp:TextBox>
        
                                                </div>
                                            </div>
                                        </div>


                                        <div class="form-group">
                                                    <div class="row">
                                                         <div runat="server" meta:resourcekey="Dis_Person_ID" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                            <label for="txtTestPersonID"  runat="server" meta:resourcekey="Lbl_Person_ID"></label>
                                                            <asp:TextBox ID="txtTestPersonID" runat="server" CssClass="form-control" Enabled="False"></asp:TextBox>
                                                        </div>
                                                      </div>
                                              </div>  
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Test_Test_Name">
                                                        <label runat="server" meta:resourcekey="lbl_Test_Name"></label>
                                                        <asp:DropDownList ID="ddlidfsTestName1" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                     <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Test_Test_Category">
                                                        <label runat="server" meta:resourcekey="lbl_Test_Category"></label>
                                                        <asp:DropDownList ID="ddlidfsTestCategory1" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Test_Test_Result">
                                                        <label runat="server" meta:resourcekey="lbl_Test_Result"></label>
                                                        <asp:DropDownList ID="ddlidfsTestResult1" runat="server" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                 </div>
                                            </div>
                                                <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" runat="server" meta:resourcekey="dis_Test_Result_Date">
                                                            <label runat="server" meta:resourcekey="lbl_Test_Result_Date"></label>
                                                            <eidss:CalendarInput ID="txtdatTestResultDate1" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                 

                                            <div class="form-group">
                                                <asp:Panel ID="gvTestsPanel" class="row embed-panel" runat="server">
                                                    <div class="panel-body">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvTests"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="No data available."
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, idfsSampleType, idfsTestName, idfsTestCategory, idfsTestResult, idfsTestStatus, idfsDiagnosis, idfTestedByOffice, datReceivedDate, datConcludedDate, idfTestedByPerson, strBarcode, testGuid, sampleGuid "
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />

                                                                <Columns>
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="name" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Name %>" />
                                                                    <asp:BoundField DataField="strTestStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Status %>" />
                                                                    <asp:BoundField DataField="datReceivedDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Date_Received %>" DataFormatString="{0:d}" />

                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </div>
                                        </div>
  <%--                                  </div>--%>
    <%--                                </div>--%>
                                </section> <%--Ends TestTabs Section--%>
                                </div>


                                <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                    <MenuItems>
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="0" ID="sideBarItemEnterHASC" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Session_Information" runat="server"></eidss:SideBarItem>
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="1" ID="sideBarItemPersonsAndSamples" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Persons_Samples" runat="server"></eidss:SideBarItem>
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="2" ID="sideBarItemActions" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="Tab_Actions" runat="server"></eidss:SideBarItem>
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="3" ID="sidebaritem_DiseaseReport" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Disease_Report" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="4" ID="sidebaritem_Tests" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Tests" runat="server" />
                                        <eidss:SideBarItem CssClass="glyphicon glyphicon-file disabled" GoToTab="5" ID="sideBarItemReview" IsActive="true" ItemStatus="IsReview" meta:resourcekey="Tab_Review" runat="server"></eidss:SideBarItem>
                                    </MenuItems>
                                </eidss:SideBarNavigation>
                                <div class="row">
                                <div  class="col-lg-6 col-md-6 col-sm-6 col-xs-6 text-center">

                                        <button type="button" id="btnCancelSubmit" runat="server" class="btn btn-default" data-toggle="modal" data-target="#cancelSession" meta:resourcekey="btn_Cancel"></button>

                                       <input type="button" id="btnPreviousSection" runat="server" meta:resourcekey="btn_Previous" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                                        <input type="button" id="btnNextSection" runat="server" meta:resourcekey="btn_Next" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                                        <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" meta:resourceKey="btn_Submit" OnClick="btnSubmit_Click" />

                                        <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_Delete" OnClick="btnDelete_Click" />
                                    </div>
                                </div>
 


                            </div>
                        </div>
                    </div>
                </div>

                <div id="testDetails" runat="server" class="modal" role="dialog">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3 id="testHdg" class="modal-title" runat="server" meta:resourcekey="Hdg_Test_Details"></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Test_Test_Name">
                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Test_Test_Name"></span>
                                            <label runat="server" meta:resourcekey="lbl_Test_Name"></label>
                                            <asp:DropDownList ID="ddlidfsTestName" runat="server" CssClass="form-control"></asp:DropDownList>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsTestName" Display="Dynamic" InitialValue="null" CssClass="text-danger" ValidationGroup="testInformation" meta:resourceKey="val_Test_Test_Name"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Test_Test_Category">
                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Test_Test_Category"></span>
                                            <label runat="server" meta:resourcekey="lbl_Test_Category"></label>
                                            <asp:DropDownList ID="ddlidfsTestCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsTestCategory" Display="Dynamic" InitialValue="null" CssClass="text-danger" ValidationGroup="testInformation" meta:resourceKey="val_Test_Test_Category"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="dis_Test_Test_Result">
                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Test_Test_Result"></span>
                                            <label runat="server" meta:resourcekey="lbl_Test_Result"></label>
                                            <asp:DropDownList ID="ddlidfsTestResult" runat="server" CssClass="form-control"></asp:DropDownList>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlidfsTestResult" Display="Dynamic" InitialValue="null" CssClass="text-danger" ValidationGroup="testInformation" meta:resourceKey="val_Test_Test_Disease"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_Test_Result_Date">
                                            <span class="glyphicon glyphicon-asterisk text-danger" runat="server" meta:resourcekey="req_Test_Test_Result_Date"></span>
                                            <label runat="server" meta:resourcekey="lbl_Test_Result_Date"></label>
                                            <eidss:CalendarInput ID="txtdatTestResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtdatTestResultDate" Display="Dynamic" InitialValue="" CssClass="text-danger" ValidationGroup="testInformation" meta:resourceKey="val_Test_Result_Date"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                                <asp:HiddenField ID="hdfDetailRowIndex" runat="server" />
                            </div>
                            <div class="modal-footer text-center">
                                <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                                <button id="btnAddTest" runat="server" type="submit" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_Add_Test"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="errorSession" class="modal" role="dialog" runat="server">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-remove-sign modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lbl_Error" runat="server"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="successSession" class="modal" role="dialog" runat="server">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lblCampaignSuccess" runat="server"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button id="btnRtD" type="submit" runat="server" meta:resourcekey="Hpl_Return_to_Dashboard" class="btn btn-primary" data-dismiss="modal"></button>
                                <button id="btnReturntoSearchResults" type="submit" runat="server" meta:resourcekey="btn_Return_to_Search" class="btn btn-primary" data-dismiss="modal"></button>
                                <button id="btnRTSR" type="submit" runat="server" meta:resourcekey="btn_Return_to_Session_Record" class="btn btn-primary" data-dismiss="modal"></button>
                                <button id="btnRTCR" type="submit" runat="server" meta:resourcekey="btn_Return_to_Campaign" class="btn btn-primary" data-dismiss="modal" visible="false"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="successDeleteSession" class="modal" role="dialog" runat="server">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-ok-sign modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Successful_Delete"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <a class="btn-primary" runat="server" meta:resourcekey="Hpl_Return_to_Dashboard" href="../Dashboard.aspx"></a>
                                <button id="btnReturnToSearch" type="submit" runat="server" meta:resourcekey="btn_Return_to_Search" class="btn-primary" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="cancelAction" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Cancel_Sample_Type"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnCancelActionYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="cancelDetail" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Cancel_Detail"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnCancelDetailYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="cancelTest" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Cancel_Test"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnCancelTest" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="cancelSampleType" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Cancel_Sample_Type"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnCancelSampleTypeYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="cancelSearch" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lbl_Cancel_Search" runat="server" meta:resourcekey="lbl_Cancel_Search"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnCancelSearchYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="cancelSession" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lblSessionCancel" runat="server" meta:resourcekey="lbl_Cancel_Session"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnCancelYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>


                <div id="deleteSession" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lblDeleteSession" runat="server" meta:resourcekey="lbl_Delete_Session"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnDeleteYes" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="deleteSampleType" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lblRemoveSampleType" runat="server" meta:resourcekey="lbl_Remove_Sample_Type"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnDeleteSampleType" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="deleteDetail" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Remove_Detail"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnDeleteDetail" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="deleteAction" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Remove_Action"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnDeleteAction" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="deleteTest" class="modal">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2 text-right">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Remove_Detail"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-center">
                                <button type="submit" id="btnDeleteTest" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal"></button>
                                <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                            </div>
                        </div>
                    </div>
                </div>

              <div id="sessionCancelModal" class="modal" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Active_Surveillance_Session"></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                        <span class="glyphicon glyphicon-alert modal-icon"></span>
                                    </div>
                                    <div class="col-lg-11 col-md-12 col-sm-12 col-xs-12">
                                        <p runat="server" meta:resourcekey="Hpl_Return_to_Dashboard"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer text-center">
                            <a runat="server" class="btn btn-primary" href="~/Dashboard.aspx" meta:resourcekey="btn_Yes"></a>
                            <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal"></button>
                        </div>
                    </div>
                </div>
            </div>

                <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
                <script type="text/javascript">
                    var isModalShown = false;

                    $(document).ready(function () {
                        modalize();

                        $("#searchModal").on("shown.bs.modal", function () { isModalShown = true; })
                        focusSearch();
                        sidePanels();
                        modalize();

                        //  This registers a call back handler that is triggered after every successful postback (sync or async)
                        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(showModalAfterPostBack);
                        showModalAfterPostBack();
                    });

                    function callBackHandler() {
                        $("#searchModal").on("shown.bs.modal", function () { isModalShown = true; })
                        var search = document.getElementById("<% = search.ClientID %>");
                        focusSearch();
                        sidePanels();
                        modalize();
                    }

                    function modalize() {
                        $('.modal').modal({ show: false, backdrop: 'static', keyboard: false });
                    }

                    function showSubGrid(e, f) {
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

                    function showSearchCriteria(e) {
                        var cl = e.target.className;
                        if (cl == 'glyphicon glyphicon-triangle-bottom header-button') {
                            e.target.className = "glyphicon glyphicon-triangle-top header-button";
                            $('#<%= searchCriteria.ClientID %>').show();
                            $('#<%= btnClear.ClientID %>').show();
                            $('#<%= btnSearch.ClientID %>').show();
                        }
                        else {
                            e.target.className = "glyphicon glyphicon-triangle-bottom header-button";
                            $('#<%= searchCriteria.ClientID %>').hide();
                            $('#<%= btnClear.ClientID %>').hide();
                            $('#<%= btnSearch.ClientID %>').hide();
                        }
                    }

                    function showModalAfterPostBack() {
                        if (isModalShown) {
                            $('.modal-backdrop').remove();
                            $('#searchModal').modal({ show: true });
                        }
                    }     
                
                    function focusSearch(){
                        var search = document.getElementById("<% = search.ClientID %>");
                        if (search != undefined && <%= (Not Page.IsPostBack).ToString().ToLower() %>)
                            $('#<%= txtMonitoringSessionstrID.ClientID %>').focus();
                    }

 <%--                   function sidePanels(){
                        var sessionInformation = document.getElementById("<% = sessions.ClientID %>");

                        if (sessionInformation != undefined) {
                            setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                            $('#<%= btnNextSection.ClientID %>, #<%= btnPreviousSection.ClientID %>').click( function(){ headerTitle(); }); 
                            $('.sidepanel ul li').click( function(){ headerTitle(); });
                        }
                    }--%>


                    function sidePanels(){
                        var sessionInformation = document.getElementById("<% = sessions.ClientID %>");

                        if (sessionInformation != undefined) {
                            setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                            $('#<%= btnNextSection.ClientID %>, #<%= btnPreviousSection.ClientID %>').click( function(){ headerTitle(); }); 
                            $('.sidepanel ul li').click( function(){ headerTitle(); });
                        }
                    }





 <%--               
                    function headerTitle(){
                        var sessionID = $('#<%= hdfidfMonitoringSession.ClientID %>').val();
                        var panelController = $('#<%= hdnPanelController.ClientID %>').val();
                        debugger;
                        if((sessionID == 'NULL' && panelController == "0") || (sessionID != 'NULL' && panelController == "4")){
                            $('#<%= hdgActiveSurveillanceSession.ClientID %>').hide();
                            $('#<%= hdgActiveSurveillanceSessionReview.ClientID %>').show();
                        }
                        else
                        {
                            $('#<%= hdgActiveSurveillanceSessionReview.ClientID %>').hide();
                            $('#<%= hdgActiveSurveillanceSession.ClientID %>').show();
                        }
                    }--%>


                    function headerTitle() {


                        var sessionID = $('#<%= hdfidfMonitoringSession.ClientID %>').val();
                        var panelController = $('#<%= hdnPanelController.ClientID %>').val();
                            $('#<%= hdgActiveSurveillanceSession.ClientID %>').hide();
                            $('#<%= hdgActiveSurveillanceSessionReview.ClientID %>').show();
                        }
                   








            
                    function showModal(modalPopup){
                        var p = '#' + modalPopup;
                        $(p).modal({show: true, backdrop: 'static'});
                    }

                    function hideModal(modalPopup){
                        var p = '#' + modalPopup;
                        $(p).modal('hide');
                    }
                </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
