<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="HumanDiseaseReportDeduplication.aspx.vb" Inherits="EIDSS.HumanDiseaseReportDeduplication" %>
<%@ Register Src="~/Controls/HorizontalLocationUserControl.ascx" TagPrefix="eidss" TagName="Location" %>
<%@ Register Src="~/Controls/FlexFormLoadTemplate.ascx" TagPrefix="eidss" TagName="FlexFormLoadTemplate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <asp:UpdatePanel ID="upDeduplication" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnWarningModalYes" EventName="Click" />
        </Triggers>
        <ContentTemplate>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="Hdg_Disease_Report_Deduplication"></h2>
                </div>
                <div class="panel-body">
                    <asp:HiddenField ID="hdfidfUserID" runat="server" />
                    <asp:HiddenField ID="hdfidfInstitution" runat="server" />
                    <asp:HiddenField ID="hdfWarningMessageType" runat="server" Value="" />
                    <asp:HiddenField ID="hdfCurrentTab" runat="server" Value="" />
                    <asp:UpdatePanel ID="upSearch" runat="server" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnDeduplicate" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                        </Triggers>
                        <ContentTemplate>
                    <div id="divDeduplicationList" class="row embed-panel" runat="server">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <h3 id="hdrDeduplicationList" class="heading" runat="server" meta:resourcekey="Hdg_Human_Disease_Report_Deduplication_List"></h3>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-body">
                                <asp:UpdatePanel ID="upDeduplicationList" runat="server">
                                   <Triggers>
                                       <asp:AsyncPostBackTrigger ControlID="gvDeduplicationList" EventName="RowCommand" />
                                   </Triggers>
                                   <ContentTemplate>
                                       <div class="table-responsive">
                                            <eidss:GridView
                                                ID="gvDeduplicationList"
                                                runat="server"
                                                AllowPaging="true"
                                                AllowSorting="true"
                                                AutoGenerateColumns="false"
                                                CaptionAlign="Top"
                                                CssClass="table table-striped"
                                                ShowHeaderWhenEmpty="true"
                                                DataKeyNames="EIDSSReportID, HumanDiseaseReportID, PatientID, HumanMasterID, EnteredDate, DiseaseName, ClassificationTypeName, PatientLocation, PatientName, ReportStatusTypeName"
                                                ShowFooter="true"
                                                GridLines="None"
                                                Visible="true" >
                                                <HeaderStyle CssClass="table-striped-header" />
                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="<%$ Resources:Grd_Report_ID %>" SortExpression="EIDSSReportID">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("EIDSSReportID") %>' Visible="true" CausesValidation="false" CommandName="select"
                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>  
                                                    <asp:BoundField DataField="EIDSSPersonID" ReadOnly="True" SortExpression="PersonID" HeaderText="<%$ Resources:Grd_Disease_PersonID %>" />                                                    
                                                    <asp:BoundField DataField="DiseaseName" ReadOnly="true" SortExpression="DiseaseName" HeaderText="<%$ Resources:Grd_Disease_Clinical_Diagnosis_Heading %>" />
                                                    <asp:BoundField DataField="ReportStatusTypeName" ReadOnly="true" SortExpression="ReportStatusTypeName" HeaderText="<%$ Resources:Grd_Disease_ReportStatus %>" /> 
                                                    <asp:BoundField DataField="RegionName" ReadOnly="true" SortExpression="RegionName" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" />
                                                    <asp:BoundField DataField="RayonName" ReadOnly="true" SortExpression="RayonName" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" />
                                                    <asp:BoundField DataField="EnteredDate" ReadOnly="true" SortExpression="EnteredDate" DataFormatString="{0:d}" HeaderText="<%$ Resources:Grd_Disease_Date_Entered_Heading %>" />
                                                    <asp:BoundField DataField="ClassificationTypeName" SortExpression="ClassificationTypeName" ReadOnly="true" HeaderText="<%$ Resources:Grd_Disease_Classification_Heading %>" />
<%--                                                    <asp:BoundField DataField="PatientLocation" SortExpression="PatientLocation" ReadOnly="true" HeaderText="<%$ Resources:Grd_Disease_Location %>" />
                                                    <asp:BoundField DataField="PatientName" SortExpression="PatientFirstOrGivenName" ReadOnly="true" HeaderText="Patient Name" /> --%>
                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                        <ItemTemplate>
                                                            <asp:UpdatePanel ID="upDelete" runat="server">
                                                                <Triggers>
                                                                    <asp:AsyncPostBackTrigger ControlID="btnDelete" />
                                                                </Triggers>
                                                                <ContentTemplate>
                                                                    <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" meta:resourceKey="Btn_Delete" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </ItemTemplate>
                                                        <ItemStyle CssClass="icon" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </eidss:GridView>
                                    </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                        <asp:Button ID="btnCancelForm" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" visible="false" />
                                        <asp:Button runat="server" ID="btnDeduplicate" CssClass="btn btn-default" meta:resourcekey="Btn_Deduplicate" visible="false" />
                                    </div>
                                </div>
                            </div>   
                        </div>
                    </div>
                    <asp:Panel ID="pnlSearchForm" runat="server" DefaultButton="btnSearch">
                        <div id="divSearchCriteria" runat="server" class="row embed-panel">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                            <h3 id="hdgSearchCriteria" class="header" runat="server" meta:resourcekey="Hdg_Human_Disease_Report_Search"></h3>
                                        </div>
                                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                <a href="#divSearchCriteriaForm" data-toggle="collapse" data-parent="#divSearchCriteria" onclick="toggleSearchCriteria(event);">
                                                    <span id="toggleIcon" runat="server" class="toggle-icon glyphicon glyphicon-triangle-bottom header-button">&nbsp;</span>
                                                </a>
                                        </div>
                                    </div>
                                </div>
                                <div id="divSearchForm" class="panel-collapse collapse in" runat="server">
                                    <div class="panel-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Report_ID">
                                                    <label runat="server" for="txtEIDSSReportID" meta:resourcekey="Lbl_Search_Report_ID"></label>
                                                    <asp:TextBox ID="txtEIDSSReportID" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Person_ID">
                                                        <label runat="server" for="txtEIDSSPersonID" meta:resourcekey="Lbl_Search_Eidss_Person_ID"></label>
                                                        <asp:TextBox ID="txtEIDSSPersonID" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                             </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
                                                    <label runat="server" meta:resourcekey="dis_Search_Or"></label>
                                                </div>
                                            </div>
                                         </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div runat="server" meta:resourcekey="Dis_Disease_Diagnosis" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label for="ddlDiseaseID" runat="server" class="control-label" meta:resourcekey="SearchLbl_Disease_Diagnosis"></label>
                                                    <asp:DropDownList ID="ddlDiseaseID" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchDiagnosisResource1">
                                                        <asp:ListItem meta:resourcekey="ListItemResource1"></asp:ListItem>
                                                    </asp:DropDownList>
                                                 </div>
                                                 <div runat="server" meta:resourcekey="Dis_Disease_Report_Report_Status" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label for="ddlReportStatusTypeID" runat="server" class="control-label" meta:resourcekey="SearchLbl_Disease_Report_Status"></label>
                                                    <asp:DropDownList ID="ddlReportStatusTypeID" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchReportStatusResource1">
                                                        <asp:ListItem meta:resourcekey="ListItemResource2"></asp:ListItem>
                                                    </asp:DropDownList>
                                                 </div>
                                            </div>
                                        </div>
                                        <eidss:Location ID="ucLocation" runat="server" ShowCountry="false" ShowBuildingHouseApartmentGroup="false" ShowCoordinates="false" ShowPostalCode="false" ShowStreet="false" ShowSettlementType="false" ShowSettlement="false" IsHorizontalLayout="true" />
                                        <fieldset>
                                            <legend runat="server" meta:resourcekey="Searchlbl_DateEnteredRange"></legend>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_DateEntered_From">
                                                        <label for="txtHumanDiseaseReportDateEnteredFrom" runat="server" meta:resourcekey="Searchlbl_DateEntered_From"></label>
                                                        <eidss:CalendarInput ID="txtHumanDiseaseReportDateEnteredFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="txtSearchHDRDateEnteredFromResource1" />
                                                    </div>
                                                    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_DateEntered_To">
                                                        <label for="txtHumanDiseaseReportDateEnteredTo" runat="server" meta:resourcekey="Searchlbl_DateEntered_To"></label>
                                                        <eidss:CalendarInput ID="txtHumanDiseaseReportDateEnteredTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="txtSearchHDRDateEnteredToResource1" />
                                                    </div>
                                                </div>
                                            </div>
                                        </fieldset>
                                        <div class="form-group">
                                            <div class="row">
                                                <div runat="server" meta:resourcekey="Dis_Disease_Report_Case_Classification" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label for="ddlClassificationTypeID" runat="server" meta:resourcekey="Lbl_Disease_Report_Case_Classification" class="control-label"></label>
                                                    <asp:DropDownList ID="ddlClassificationTypeID" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchCaseClassificationResource1"></asp:DropDownList>
                                                </div>
<%--                                                <div runat="server" meta:resourcekey="Dis_Disease_Report_Hospitaliztion" class="col-lg-6 col-md-6 col-sm-12 col-xs-12" visible="False">
                                                    <label for="ddlSearchIdfsHospitalizationStatus" runat="server" meta:resourcekey="lbl_Hospitalization" class="control-label"></label>
                                                    <asp:DropDownList ID="ddlSearchIdfsHospitalizationStatus" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchIdfsHospitalizationStatusResource1" />
                                                </div>--%>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>  
                            <div class="modal-footer text-center">
                                <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Clear_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Clear_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Search_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Search_ToolTip %>" ValidationGroup="SearchPerson" />
                            </div>
                        </div>
                    </asp:Panel>
                    <div id="divSearchResults" class="row embed-panel" runat="server">
                      <div class="panel panel-default">
                          <div class="panel-heading">
                              <div class="row">
                                  <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                      <h3 id="hdrSearchResults" class="heading" runat="server" meta:resourcekey="Hdg_Human_Disease_Report_List"></h3>
                                  </div>
                              </div>
                          </div>
                          <div class="panel-body">
                            <asp:UpdatePanel ID="upSearchResults" runat="server" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="gvSearchResults" EventName="RowCommand" />
                                    <asp:AsyncPostBackTrigger ControlID="gvSearchResults" EventName="Sorting" />
                                </Triggers>
                                <ContentTemplate>
                                    <div class="table-responsive">
                                        <eidss:GridView
                                            ID="gvSearchResults"
                                            runat="server"
                                            AllowPaging="True"
                                            AllowSorting="True"
                                            AutoGenerateColumns="False"
                                            CaptionAlign="Top"
                                            CssClass="table table-striped"
                                            EmptyDataText="<%$ Resources:Labels, Lbl_No_Results_Found_Text %>"
                                            ShowHeaderWhenEmpty="True"
                                            DataKeyNames="HumanDiseaseReportID, PatientID, HumanMasterID, EIDSSReportID"
                                            ShowFooter="True"
                                            GridLines="None">
                                            <HeaderStyle CssClass="table-striped-header" />
                                            <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="<%$ Resources:Grd_Report_ID %>" SortExpression="EIDSSReportID">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("EIDSSReportID") %>' CausesValidation="False" CommandName="select"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                    </ItemTemplate>
                                               </asp:TemplateField>
                                               <asp:TemplateField HeaderText="<%$ Resources:Grd_Disease_PersonID %>" SortExpression="EIDSSPersonID">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblEIDSSPersonID" runat="server" Text='<%# Eval("EIDSSPersonID") %>' ></asp:Label>
                                                    </ItemTemplate>
                                               </asp:TemplateField>
<%--                                               <asp:TemplateField HeaderText="<%$ Resources:Grd_Disease_Name_Heading %>" SortExpression="PatientName">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnSelectPerson" runat="server" Text='<%# Eval("Persons_Name") %>' CausesValidation="False" CommandName="selectPerson"
                                                                        CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourcekey="btnSelectPersonResource1"></asp:LinkButton>
                                                    </ItemTemplate>
                                               </asp:TemplateField>--%>
                                               <asp:BoundField DataField="DiseaseName" ReadOnly="True" SortExpression="DiseaseName" HeaderText="<%$ Resources:Grd_Disease_Clinical_Diagnosis_Heading %>" />
                                               <asp:BoundField DataField="ReportStatusTypeName" ReadOnly="True" SortExpression="ReportStatusTypeName" HeaderText="<%$ Resources:Grd_Disease_CaseProgressStatus %>" />
                                               <asp:BoundField DataField="RegionName" ReadOnly="true" SortExpression="RegionName" HeaderText="<%$ Resources: Labels, Lbl_Region_Text %>" />
                                                <asp:BoundField DataField="RayonName" ReadOnly="true" SortExpression="RayonName" HeaderText="<%$ Resources: Labels, Lbl_Rayon_Text %>" />
<%--                                               <asp:BoundField DataField="Location" SortExpression="PatientLocation" ReadOnly="True" HeaderText="<%$ Resources:Grd_Disease_Location %>" />--%>
                                               <asp:BoundField DataField="EnteredDate" ReadOnly="True" SortExpression="EnteredDate" DataFormatString="{0:d}" HeaderText="<%$ Resources:Grd_Disease_Date_Entered_Heading %>" />
                                               <asp:BoundField DataField="ClassificationTypeName" SortExpression="ClassificationTypeName" ReadOnly="True" HeaderText="<%$ Resources:Grd_Disease_Classification_Heading %>" />
                                               <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                    <ItemTemplate>
                                                        <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="btnToggleSelect" />
                                                            </Triggers>
                                                            <ContentTemplate>                                                        
                                                                <asp:LinkButton ID="btnToggleSelect" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="icon" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </eidss:GridView>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                          </div>
                      </div>
                  </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div id="divDeduplicationDetails" runat="server" class="row embed-panel">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <!-- Nav tabs -->
                                <ul class="nav nav-tabs" id="myTab">
                                    <li id="liNotification"><a id="lnkNotification" href="#EIDSSBodyCPH_Notification" data-toggle="tab" onclick="tabChanged(this, 'Notification');">
                                        <asp:Label ID="lblNotification" runat="server" meta:resourcekey="Lbl_Disease_Notification"/></a></li>
                                    <li id="liClinicalInfo"><a id="lnkClinicalInfo" href="#EIDSSBodyCPH_ClinicalInfo" data-toggle="tab" onclick="tabChanged(this, 'ClinicalInfo');">
                                        <asp:Label ID="lblClinicalInfo" runat="server" meta:resourcekey="Lbl_Clinical_Information"/></a></li>
                                    <li id="liSamples"><a id="lnkSamples" href="#EIDSSBodyCPH_Samples" data-toggle="tab" onclick="tabChanged(this, 'Samples');">
                                        <asp:Label ID="lblSamples" runat="server" meta:resourcekey="Lbl_Samples"/></a></li>
                                    <li id="liTestResults"><a id="lnkTestResults" href="#EIDSSBodyCPH_TestResults" data-toggle="tab" onclick="tabChanged(this, 'TestResults');">
                                        <asp:Label ID="lblTestResults" runat="server" meta:resourcekey="Lbl_Test_Results"/></a></li>
                                    <li id="liCaseInvestigation"><a id="lnkCaseInvestigation" href="#EIDSSBodyCPH_CaseInvestigation" data-toggle="tab" onclick="tabChanged(this, 'CaseInvestigation');">
                                        <asp:Label ID="lblCaseInvestigation" runat="server" meta:resourcekey="Lbl_Case_Investigation"/></a></li>
                                    <li id="liContactList"><a id="lnkContactList" href="#EIDSSBodyCPH_ContactList" data-toggle="tab" onclick="tabChanged(this, 'ContactList');">
                                        <asp:Label ID="lblContactList" runat="server" meta:resourcekey="Lbl_Contact_List"/></a></li>
                                    <li id="liFinalOutcome"><a id="lnkFinalOutcome" href="#EIDSSBodyCPH_FinalOutcome" data-toggle="tab" onclick="tabChanged(this, 'FinalOutcome');">
                                        <asp:Label ID="lblFinalOutcome" runat="server" meta:resourcekey="Lbl_Final_Outcome"/></a></li>
                                </ul>
                                <!-- Tab panes -->
                                <div class="tab-content">
                                    <div class="tab-pane" id="Notification" runat="server">           
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="panel panel-primary">                       
                                                    <div class="panel-heading">
                                                        <asp:RadioButton ID="rdbSurvivor" runat="server" GroupName="RecordType" CssClass="radio-inline" meta:resourceKey="Lbl_Survivor" AutoPostBack="true" OnCheckedChanged="Record_CheckedChanged" />
                                                        <asp:RadioButton ID="rdbSuperceded" runat="server"  GroupName="RecordType" CssClass="radio-inline" meta:resourceKey="Lbl_Superceded" AutoPostBack="true" OnCheckedChanged="Record_CheckedChanged"/>                                                    </div>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:HiddenField ID="hdfHumanDiseaseReportID" runat="server" />
                                                        <asp:HiddenField ID="hdfidfsFinalDiagnosis" runat="server" />
                                                        <asp:CheckBoxList ID="CheckBoxList1" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="panel">
                                                    <div class="panel-heading">
                                                        <asp:RadioButton ID="rdbSurvivor2" runat="server"  GroupName="RecordType2" CssClass="radio-inline" meta:resourceKey="Lbl_Survivor" AutoPostBack="true" OnCheckedChanged="Record2_CheckedChanged"/>
                                                        <asp:RadioButton ID="rdbSuperceded2" runat="server" GroupName="RecordType2" CssClass="radio-inline" meta:resourceKey="Lbl_Superceded" AutoPostBack="true" OnCheckedChanged="Record2_CheckedChanged"/>
                                                    </div>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:HiddenField ID="hdfHumanDiseaseReportID2" runat="server" />
                                                        <asp:HiddenField ID="hdfidfsFinalDiagnosis2" runat="server" />
                                                        <asp:CheckBoxList ID="CheckBoxList2" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                    <div class="tab-pane" id="ClinicalInfo" runat="server">           
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="panel panel-primary">                       
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList3" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                        <asp:HiddenField runat="server" ID="hdfidfEpiObservation" />
                                                    </div>
                                                    <section id="Symptoms" runat="server" >
                                                        <div class="panel panel-default">
                                                            <div class="panel-body">
                                                                <div class="form-group">
                                                                    <eidss:FlexFormLoadTemplate runat="server" 
                                                                            ID="FlexFormSymptoms" 
                                                                            LegendHeader="Human Case : Symptoms" 
                                                                            FormType="10034010"/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </section>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList20" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList22" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <eidss:GridView ID="gvAntibiotics" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfAntimicrobialTherapy, idfHumanCase, strAntimicrobialTherapyName, strDosage, datFirstAdministeredDate" EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>" ShowFooter="True" ShowHeader="true" ShowHeaderWhenEmpty="true" GridLines="None" >
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                <Columns> 
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Antibiotic_Name %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strAntimicrobialTherapyNam") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>                                    
                                                                    <asp:BoundField DataField="strAntimicrobialTherapyName" HeaderText="<%$ Resources: lbl_Antibiotic_Name %>" />
                                                                    <asp:BoundField DataField="strDosage" HeaderText="<%$ Resources: lbl_Dose %>" />
                                                                    <asp:BoundField DataField="datFirstAdministeredDate" HeaderText="<%$ Resources: lbl_Date_Antibiotic_First_Administered %>" DataFormatString="{0:d}" />
<%--                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="AntiviralTherapy" runat="server" CommandName="Edit" CommandArgument='<% #Bind("idfAntimicrobialTherapy") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnAntiviralTherapy" runat="server" CommandName="Delete" CommandArgument='<% #Bind("idfAntimicrobialTherapy") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>--%>
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectAntibiotics" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectAntibiotics" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
                                                                </Columns>
                                                             </eidss:GridView>
                                                        </div> 
                                                    </div>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList23" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <eidss:GridView ID="gvVaccinations" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="HumanDiseaseReportVaccinationUID, idfHumanCase, VaccinationName, VaccinationDate" EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>" ShowFooter="True" ShowHeader="true" ShowHeaderWhenEmpty="true" GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Vaccination_Name %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("vaccinationName") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>   
                                                                    <asp:BoundField DataField="vaccinationName" HeaderText="<%$ Resources: lbl_Vaccination_Name %>" />
                                                                    <asp:BoundField DataField="vaccinationDate" HeaderText="<%$ Resources: lbl_Date_of_Vaccination %>" DataFormatString="{0:d}" />                                                                            
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelectVaccinations" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectVaccinations" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectVaccinations" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
<%--                                                                     <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                               <ItemTemplate>
                                                                    <asp:LinkButton ID="btnEditVaccination" runat="server" CommandName="Edit" CommandArgument='<% #Bind("humanDiseaseReportVaccinationUID") %>' CausesValidation="false"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="btnDeleteVaccination" runat="server" CommandName="Delete" CommandArgument='<% #Bind("humanDiseaseReportVaccinationUID") %>' CausesValidation="false"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>--%>
                                                                </Columns>
                                                            </eidss:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="panel">
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList4" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                        <asp:HiddenField runat="server" ID="hdfidfEpiObservation2" />
                                                    </div>
                                                    <section id="Symptoms2" runat="server" >
                                                        <div class="panel panel-default">
                                                            <div class="panel-body">
                                                                <div class="form-group">
                                                                    <eidss:FlexFormLoadTemplate runat="server" 
                                                                            ID="FlexFormSymptoms2" 
                                                                            LegendHeader="Human Case : Symptoms" 
                                                                            FormType="10034010"/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </section>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList21" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList24" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <eidss:GridView ID="gvAntibiotics2" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="idfAntimicrobialTherapy, idfHumanCase, strAntimicrobialTherapyName, strDosage, datFirstAdministeredDate" EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>" ShowFooter="True" ShowHeader="true" ShowHeaderWhenEmpty="true" GridLines="None" >
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                <Columns> 
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Antibiotic_Name %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strAntimicrobialTherapyNam") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>                                    
                                                                    <asp:BoundField DataField="strAntimicrobialTherapyName" HeaderText="<%$ Resources: lbl_Antibiotic_Name %>" />
                                                                    <asp:BoundField DataField="strDosage" HeaderText="<%$ Resources: lbl_Dose %>" />
                                                                    <asp:BoundField DataField="datFirstAdministeredDate" HeaderText="<%$ Resources: lbl_Date_Antibiotic_First_Administered %>" DataFormatString="{0:d}" />
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectAntibiotics2" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectAntibiotics2" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
                                                                </Columns>
                                                             </eidss:GridView>
                                                        </div> 
                                                    </div>
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList25" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <eidss:GridView ID="gvVaccinations2" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CaptionAlign="Top" CssClass="table table-striped" DataKeyNames="HumanDiseaseReportVaccinationUID, idfHumanCase, VaccinationName, VaccinationDate" EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>" ShowFooter="True" ShowHeader="true" ShowHeaderWhenEmpty="true" GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <SortedAscendingHeaderStyle CssClass="glyphicon glyphicon-triangle-top" />
                                                                <SortedDescendingHeaderStyle CssClass="glyphicon glyphicon-triangle-bottom" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Vaccination_Name %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("vaccinationName") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>   
                                                                    <asp:BoundField DataField="vaccinationName" HeaderText="<%$ Resources: lbl_Vaccination_Name %>" />
                                                                    <asp:BoundField DataField="vaccinationDate" HeaderText="<%$ Resources: lbl_Date_of_Vaccination %>" DataFormatString="{0:d}" />                                                                            
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectVaccinations2" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectVaccinations2" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
                                                                </Columns>
                                                            </eidss:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                    <div class="tab-pane" id="Samples" runat="server">           
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="panel panel-primary">                       
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList5" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvSamples"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, strBarcode, idfsSampleType, datFieldCollectionDate, strFieldBarcode, datFieldSentDate, idfSendToOffice, strSendToOffice, idfFieldCollectedByOffice, sampleGuid"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strBarcode") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>  
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="datFieldCollectionDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Date_Collected.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="datFieldSentDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_Date.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strSendToOffice" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_To.InnerText %>" />
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectSamples" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectSamples" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="panel">
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList6" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvSamples2"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, strBarcode, idfsSampleType, datFieldCollectionDate, strFieldBarcode, datFieldSentDate, idfSendToOffice, strSendToOffice, idfFieldCollectedByOffice, sampleGuid"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strBarcode") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>  
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="datFieldCollectionDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Date_Collected.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="datFieldSentDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_Date.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strSendToOffice" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_To.InnerText %>" />
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectSamples2" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectSamples2" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                    <div class="tab-pane" id="TestResults" runat="server">           
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="panel panel-primary">                       
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList7" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvTests"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, idfsSampleType, idfsTestName, idfsTestCategory, idfsTestResult, idfsTestStatus, idfsDiagnosis, idfTestedByOffice, datReceivedDate, datConcludedDate, idfTestedByPerson, strBarcode, testGuid, sampleGuid, strFieldBarCode, strSampleTypeName, idfsInterpretedStatus, strValidatedBy, strInterpretedBy"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />                                                                
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strFieldBarcode") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField> 
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="name" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Name %>" />
                                                                    <asp:BoundField DataField="strTestResult" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Result.InnerText %>" />
                                                                    <asp:BoundField DataField="datReceivedDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Date_Received %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strInterpretedStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_InterpretedStatus_RulesInOut.InnerText %>" />
                                                                    <asp:BoundField DataField="blnValidateStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Validated.InnerText %>" /> 
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectTests" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectTests" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>                                                                    
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="panel">
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList8" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvTests2"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, idfsSampleType, idfsTestName, idfsTestCategory, idfsTestResult, idfsTestStatus, idfsDiagnosis, idfTestedByOffice, datReceivedDate, datConcludedDate, idfTestedByPerson, strBarcode, testGuid, sampleGuid, strFieldBarCode, strSampleTypeName, idfsInterpretedStatus, strValidatedBy, strInterpretedBy"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />                                                                
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strFieldBarcode") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField> 
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="name" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Name %>" />
                                                                    <asp:BoundField DataField="strTestResult" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Result.InnerText %>" />
                                                                    <asp:BoundField DataField="datReceivedDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Date_Received %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strInterpretedStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_InterpretedStatus_RulesInOut.InnerText %>" />
                                                                    <asp:BoundField DataField="blnValidateStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Validated.InnerText %>" /> 
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectTests2" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectTests2" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>                                                                    
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                    <div class="tab-pane" id="CaseInvestigation" runat="server">           
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="panel panel-primary">                       
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList9" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />   
                                                        <asp:HiddenField runat="server" ID="hdfidfCSObservation" />
                                                        <eidss:FlexFormLoadTemplate runat="server" 
                                                                            ID="HumanDiseaseFlexFormRiskFactors" 
                                                                            LegendHeader="Human Case Classification Form" 
                                                                            FormType="10034011"/>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="panel">
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList10" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                        <asp:HiddenField runat="server" ID="hdfidfCSObservation2" />
                                                        <eidss:FlexFormLoadTemplate runat="server" 
                                                                            ID="HumanDiseaseFlexFormRiskFactors2" 
                                                                            LegendHeader="Human Case Classification Form" 
                                                                            FormType="10034011"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                    <div class="tab-pane" id="ContactList" runat="server">           
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="panel panel-primary">                       
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList11" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvContacts"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfHumanCase, strFirstName, strSecondName, strLastName, idfsPersonContactType, datDateOfBirth, idfsHumanGender, idfCitizenship, datDateOfLastContact, strPlaceInfo, idfsCountry, idfsRegion, idfsRayon, idfsSettlement, strStreetName, strBuilding, strHouse, strApartment, strPostCode, strContactPersonFullName, strContactPhone, idfContactPhoneType,idfHumanActual, idfContactedCasePerson, rowguid, strComments"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Contacts_Person_Full_Name %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strContactPersonFullName") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField> 
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strContactPersonFullName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Full_Name %>" />
                                                                    <asp:BoundField DataField="strPersonContactType" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Contact_Type %>" />
                                                                    <asp:BoundField DataField="datDateOfLastContact" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Date_Of_Last_Contact %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strPlaceInfo" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Place_Info %>" />
                                                                    <asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" />
                                                                    <%--<asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" DataFormatString="{0:d}" />--%>
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectContacts" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectContacts" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="panel">
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList12" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                    <div class="form-group">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvContacts2"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="<%$ Resources: Grd_List_Empty_Data %>"
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfHumanCase, strFirstName, strSecondName, strLastName, idfsPersonContactType, datDateOfBirth, idfsHumanGender, idfCitizenship, datDateOfLastContact, strPlaceInfo, idfsCountry, idfsRegion, idfsRayon, idfsSettlement, strStreetName, strBuilding, strHouse, strApartment, strPostCode, strContactPersonFullName, strContactPhone, idfContactPhoneType,idfHumanActual, idfContactedCasePerson, rowguid, strComments"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Contacts_Person_Full_Name %>" >
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("strContactPersonFullName") %>' CausesValidation="False" CommandName="select"
                                                                                CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField> 
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strContactPersonFullName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Full_Name %>" />
                                                                    <asp:BoundField DataField="strPersonContactType" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Contact_Type %>" />
                                                                    <asp:BoundField DataField="datDateOfLastContact" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Date_Of_Last_Contact %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strPlaceInfo" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Place_Info %>" />
                                                                    <asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" />
                                                                    <%--<asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" DataFormatString="{0:d}" />--%>
                                                                    <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="icon">
                                                                         <ItemTemplate>
                                                                             <asp:UpdatePanel ID="upToggleSelect" runat="server">
                                                                                 <Triggers>
                                                                                     <asp:AsyncPostBackTrigger ControlID="btnToggleSelectContacts2" />
                                                                                 </Triggers>
                                                                                 <ContentTemplate>                                                        
                                                                                     <asp:LinkButton ID="btnToggleSelectContacts2" runat="server" CommandName="Toggle Select" CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' CssClass="btn glyphicon glyphicon-unchecked selectButton" CausesValidation="false"></asp:LinkButton>
                                                                                 </ContentTemplate>
                                                                             </asp:UpdatePanel>
                                                                         </ItemTemplate>
                                                                         <ItemStyle CssClass="icon" />
                                                                     </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div> 
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                    <div class="tab-pane" id="FinalOutcome" runat="server">           
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="panel panel-primary">                       
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList13" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="panel">
                                                    <div class="panel-body duplication_checkbox">
                                                        <asp:CheckBoxList ID="CheckBoxList14" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" AutoPostBack="true" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                        
                                    </div>
                                </div>
                                <div class="modal-footer text-center">
                                    <asp:Button ID="btnCancelMerge" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                    <asp:Button ID="btnNextSection" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Next_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Next_ToolTip %>" CausesValidation="false" UseSubmitBehavior="False" />
                                    <asp:Button ID="btnMerge" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Merge_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Merge_ToolTip %>" CausesValidation="false" UseSubmitBehavior="False" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divSurvivorReview" runat="server" class="row embed-panel">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <asp:HiddenField ID="hdfPersonHumanMasterIDMain" runat="server" />
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Disease_Notification"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList15" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Clinical_Information"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList16" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Samples"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList17" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Case_Investigation"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList18" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                                    <div class="panel-heading">
                                        <h3 runat="server" meta:resourcekey="Lbl_Final_Outcome"></h3>
                                    </div>
                                    <div class="panel-body duplication_checkbox">
                                        <asp:CheckBoxList ID="CheckBoxList19" runat="server" RepeatDirection="Horizontal" RepeatColumns="4"/>
                                    </div>
                            <div class="modal-footer text-center">
                                <asp:Button ID="btnCancelSubmit" runat="server" CssClass="btn btn-default" Text="<%$ Resources: Buttons, Btn_Cancel_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Cancel_ToolTip %>" CausesValidation="false" />
                                <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" Text="<%$ Resources: Buttons, Btn_Submit_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Submit_ToolTip %>" />
                            </div>
                        </div>
                </div>
            </div>
            <div id="divSuccessModal" class="modal" role="dialog" data-backdrop="static" tabindex="-1" runat="server">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Person"></h4>
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
                            <%--<asp:Button ID="btnAddDiseaseReport" runat="server" meta:resourcekey="Btn_Add_Disease_Report" CssClass="btn btn-default" />--%>
                            <a href="../../../Dashboard.aspx" class="btn btn-default" runat="server" title="<%$ Resources: Labels, Lbl_Return_to_Dashboard_ToolTip %>"><%= GetGlobalResourceObject("Labels", "Lbl_Return_to_Dashboard_Text") %></a>
                            <asp:Button ID="btnReturnToPersonRecord" runat="server" Text="<%$ Resources: Buttons, Btn_Ok_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Ok_ToolTip %>" CssClass="btn btn-primary" data-dismiss="modal" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="divWarningModal" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-warning">
                        <div class="panel-heading">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link" id="warningHeading" runat="server"></h4>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                    <strong id="warningSubTitle" runat="server"></strong>
                                    <br />
                                    <div id="warningBody" runat="server"></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <div id="divWarningYesNoContainer" runat="server">
                                <asp:Button ID="btnWarningModalYes" runat="server" CssClass="btn btn-warning alert-link" Text="<%$ Resources: Buttons, Btn_Yes_Text %>" ToolTip="<%$ Resources: Buttons, Btn_Yes_ToolTip %>" CausesValidation="false" />
                                <button id="btnWarningModalNo" type="button" class="btn btn-warning alert-link" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_No_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_No_Text") %></button>
                            </div>
                            <div id="divWarningOKContainer" runat="server">
                                <button id="btnWarningModalOK" type="button" class="btn btn-warning alert-link" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divErrorModal" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" runat="server">
                <div class="modal-dialog" role="document">
                    <div class="panel-warning alert alert-danger">
                        <div class="panel-heading">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="alert-link" id="hdgError" runat="server"></h4>
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
                            <button id="btnErrorModalOK" type="button" class="btn btn-danger alert-link" data-dismiss="modal" title="<%= GetGlobalResourceObject("Buttons", "Btn_Ok_ToolTip") %>"><%= GetGlobalResourceObject("Buttons", "Btn_Ok_Text") %></button>
                        </div>
                    </div>
                </div>
            </div>
            <script type="text/javascript">
              function showPersonSubGrid(e, f) {
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

            function toggleSearchCriteria(e) {
                var cl = e.target.className;
                if (cl == 'toggle-icon glyphicon glyphicon-triangle-bottom header-button') {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-top header-button";
                    $('#<%= btnClear.ClientID %>').show();
                    $('#<%= btnSearch.ClientID %>').show();
                    $("#divSearchCriteriaForm").collapse('hide');
                }
                else {
                    e.target.className = "toggle-icon glyphicon glyphicon-triangle-bottom header-button";
                    $('#<%= btnClear.ClientID %>').hide();
                    $('#<%= btnSearch.ClientID %>').hide();
                    $("#divSearchCriteriaForm").collapse('show');
                }
            }

            function hideSearchCriteria() {
                $('#<%= btnClear.ClientID %>').hide();
                $('#<%= btnSearch.ClientID %>').hide();
                $("#divSearchCriteriaForm").collapse('hide');
            }

            function showSearchCriteria() {
                $('#<%= btnClear.ClientID %>').show();
                $('#<%= btnSearch.ClientID %>').show();
                $("#divSearchCriteriaForm").collapse('show');
                }


                function tabChanged(obj, tab) {
                    var hdfCurrentTab = document.getElementById("EIDSSBodyCPH_hdfCurrentTab");
                    hdfCurrentTab.value = tab;

                    __doPostBack(obj.id, 'TabChanged');
                }

                function setActiveTabItem() {
                    var hdfCurrentTab = document.getElementById("EIDSSBodyCPH_hdfCurrentTab");

                    switch (hdfCurrentTab.value) {
                        case 'Notification':
                            document.getElementById('liNotification').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_Notification').setAttribute('class', 'tab-pane active');
                            break;
                        case 'ClinicalInfo':
                            document.getElementById('liClinicalInfo').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_ClinicalInfo').setAttribute('class', 'tab-pane active');
                            break;
                        case 'Samples':
                            document.getElementById('liSamples').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_Samples').setAttribute('class', 'tab-pane active');
                            break;
                        case 'TestResults':
                            document.getElementById('liTestResults').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_TestResults').setAttribute('class', 'tab-pane active');
                            break;
                        case 'CaseInvestigation':
                            document.getElementById('liCaseInvestigation').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_CaseInvestigation').setAttribute('class', 'tab-pane active');
                            break;
                        case 'ContactList':
                            document.getElementById('liContactList').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_ContactList').setAttribute('class', 'tab-pane active');
                            break;
                        case 'FinalOutcome':
                            document.getElementById('liFinalOutcome').setAttribute('class', 'active');
                            document.getElementById('EIDSSBodyCPH_FinalOutcome').setAttribute('class', 'tab-pane active');
                            break;
                    }
                };
        </script>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
