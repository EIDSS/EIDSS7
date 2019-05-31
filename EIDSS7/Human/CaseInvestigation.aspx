<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="CaseInvestigation.aspx.vb" Inherits="EIDSS.CaseInvestigation" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>
<%@ Register Src="~/Controls/ContactUserControl.ascx" TagPrefix="eidss" TagName="ContactUserControl" %>
<%@ Register Src="~/Controls/SampleUserControl.ascx" TagPrefix="eidss" TagName="SampleUserControl" %>
<%@ Register Src="~/Controls/NonDtraSampleUserControl.ascx" TagPrefix="eidss" TagName="NonDtraSampleUserControl" %>

<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">
    <div class="container">
        <div class="page-heading">
            <h2>Human Case Investigation</h2>
        </div>
        <div class="alert alert-warning">
            <%= GetLocalResourceObject("PleaseNoteText") %>
        </div>
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div class="row">
                    <div class="sectionContainer">

                        <!-- This is the "REQUIRED ONLY ALERT at top of panels -->
                        <div class="form-group">
                            <div class="glyphicon glyphicon-asterisk text-danger"></div>
                            <label><%= GetGlobalResourceObject("OtherText", "Pln_Required_Text") %></label>
                        </div>
                        <!-- This is the READ ONLY section at the top-->
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-md-6">
                                            <!-- CASE ID: unique identifier of this case -->
                                            <asp:Label AssociatedControlID="caseId" CssClass="control-label" runat="server" Text="<%$ Resources:LblCaseIdText %>" ToolTip="<%$ Resources: LblCaseIdToolTip %>"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="caseId" ReadOnly="true" runat="server"></asp:TextBox>
                                        </div>
                                        <div class="col-md-6">
                                            <!--  the Name of the patient first and last name-->
                                            <asp:Label AssociatedControlID="txtPatientFullName" CssClass="control-label" runat="server" Text="<%$ Resources: Labels, Lbl_Name_Text %>" ToolTip="<%$ Resources: Labels, Lbl_Name_ToolTip %>"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="txtPatientFullName" ReadOnly="true" runat="server"></asp:TextBox>
                                        </div>
                                        <div class="col-md-6">
                                            <!--  The Text or value of the tentative diagnosis -->
                                            <asp:Label AssociatedControlID="txtTentativeDiagnosis" CssClass="control-label" runat="server" Text="<%$ Resources:LblTentativeDiagnosisText %>" ToolTip="<%$ Resources: LblTentativeDiagnosisToolTip %>"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="txtTentativeDiagnosis" ReadOnly="true" runat="server"></asp:TextBox>
                                        </div>
                                        <div class="col-md-6">
                                            <!-- the place where case was registered -->
                                            <asp:Label AssociatedControlID="txtPlace" CssClass="control-label" runat="server" Text="<%$ Resources: LblPlaceText %>" ToolTip="<%$ Resources: LblPlaceToolTip %>"></asp:Label>
                                            <asp:TextBox CssClass="form-control" ID="txtPlace" ReadOnly="true" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="upArrowGlyph" class="glyphicon glyphicon-arrow-up"></div>
                            <a id="btnShowMore" href="#moreInfoPanel" data-toggle="collapse"><%= GetLocalResourceObject("ShowMoreData") %></a>
                        </div>
                        <div class="panel-body collapse" id="moreInfoPanel">
                            <div class="row">
                                <div class="form-group">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                        <!-- the date the case was first diagnosed-->
                                        <asp:Label AssociatedControlID="txtDiagnosisDate" CssClass="control-label" runat="server" Text="<%$ Resources:Labels, Lbl_Date_of_Diagnosis_Text %>" ToolTip="<%$ Resources:Labels, Lbl_Date_of_Diagnosis_ToolTip %>"></asp:Label>
                                        <div class="input-group">
                                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                                            <asp:TextBox CssClass="form-control" ID="txtDiagnosisDate" ReadOnly="true" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                        <!-- -->
                                        <asp:Label AssociatedControlID="txtSymptomOnsetDate" CssClass="control-label" runat="server" Text="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_Text %>" ToolTip="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_ToolTip %>"></asp:Label>
                                        <div class="input-group">
                                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
                                            <asp:TextBox CssClass="form-control" ID="txtSymptomOnsetDate" ReadOnly="true" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                        <!-- -->
                                        <asp:Label AssociatedControlID="txtPassportId" CssClass="control-label" runat="server" Text="<%$ Resources:LblPassportIdText %>" ToolTip="<%$ Resources:lblPassportIdToolTip %>"></asp:Label>
                                        <asp:TextBox CssClass="form-control" ID="txtPassportId" ReadOnly="true" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="form-group col-md-12">
                                    <!-- Patient's current address -->
                                    <asp:Label AssociatedControlID="txtCurrentAddress" CssClass="control-label" runat="server" Text="<%$ Resources:Labels, Lbl_Current_Address_Text %>" ToolTip="<%$ Resources:Labels, Lbl_Current_Address_ToolTip %>"></asp:Label>
                                    <asp:TextBox CssClass="form-control Top" ID="txtCurrentAddress" runat="server" ReadOnly="true" TextMode="MultiLine"></asp:TextBox>
                                </div>
                                <div class="form-group col-md-12">
                                    <!-- Other Address -->
                                    <asp:Label AssociatedControlID="txtOtherAddress" CssClass="control-label" runat="server" Text="<%$ Resources:LblOtherAddressText %>" ToolTip="<%$ Resources:lblOtherAddressToolTip %>"></asp:Label>
                                    <asp:TextBox CssClass="form-control top" ID="txtOtherAddress" runat="server" ReadOnly="true" TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <!-- these are the page sections-->
                        <!--  Sections 1 Case Information Section -->
                        <section id="GeneralInfoSection" runat="server" class="hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-md-11">
                                            <h3 class="heading"><% = GetLocalResourceObject("GeneralInfoSectionHeading") %></h3>
                                        </div>
                                        <div class="col-md-1 heading text-right">
                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="ddlOrganizationSent"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblOrganizationSentText %>"
                                            ToolTip="<%$ Resources:LblOrganizationSentToolTip %>"></asp:Label>
                                        <eidss:DropDownList
                                            CssClass="form-control eidss-dropdown"
                                            ContainerCssClass="full-width"
                                            ID="ddlOrganizationSent"
                                            PopUpWindowId="CaseInvestigationPopUpDialog"
                                            runat="server"
                                            SearchButtonCssClass="searchButton">
                                        </eidss:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="ddlOrganizationReceived"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblOrganizationReceivedText %>"
                                            ToolTip="<%$ Resources:LblOrganizationReceivedToolTip %>"></asp:Label>
                                        <eidss:DropDownList
                                            CssClass="form-control eidss-dropdown"
                                            ID="ddlOrganizationReceived"
                                            PopUpWindowId="CaseInvestigationPopUpDialog"
                                            runat="server"
                                            SearchButtonCssClass="searchButton">
                                        </eidss:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="txtDateRecieved"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:Labels, Lbl_Date_Received_Text %>"
                                            ToolTip="<%$ Resources:LblDateRecievedToolTip %>"></asp:Label>
                                        <eidss:CalendarInput ID="txtDateRecieved" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>                                        
                                    </div>
                                    <!--  a DIVIDER should go here -->
                                    <hr />
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="ddlOrganizationInvestigating"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblOrganizationInvestigatingText %>"
                                            ToolTip="<%$ Resources:LblOrganizationInvestigatingToolTip %>"></asp:Label>
                                        <p><%= GetLocalResourceObject("SelectMultipleText") %></p>
                                        <eidss:DropDownList
                                            CssClass="form-control eidss-dropdown"
                                            ID="ddlOrganizationInvestigating"
                                            PopUpWindowId="CaseInvestigationPopUpDialog"
                                            runat="server"
                                            SearchButtonCssClass="searchButton">
                                        </eidss:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="txtInvestigationStartDate"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblInvestigationStartDateText %>"
                                            ToolTip="<%$ Resources:LblInvestigationStartDateToolTip %>"></asp:Label>
                                        <eidss:CalendarInput ID="txtInvestigationStartDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                    </div>
                                    <!--  a DIVIDER should go here -->
                                    <hr />
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="txtIdentificationNumber"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblIdentificationNumberText %>"
                                            ToolTip="<%$ Resources:LblIdentificationNumberToolTip %>"></asp:Label>
                                        <p><%= GetLocalResourceObject("LblIdentificationNumberToolTip") %></p>
                                        <asp:TextBox ID="txtIdentificationNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="txtCaseInfoComments"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:Labels, LblCommentsText %>"
                                            ToolTip="<%$ Resources:Labels, LblCommentsToolTip %>"></asp:Label>
                                        <asp:TextBox CssClass="form-control" ID="txtCaseInfoComments" TextMode="MultiLine" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="panel-footer">&nbsp;</div>
                            </div>
                        </section>
                        <!-- Section 2 Patient Information Section -->
                        <section id="PatientInfoSection" runat="server" class="col-md-12 hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-md-11">
                                            <h3 class="heading"><% = GetLocalResourceObject("PatientInfoSectionHeading") %></h3>
                                        </div>
                                        <div class="col-md-1 heading text-right">
                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">
                                        <span class="glyphicon glyphicon-asterisk alert-danger pull-left"></span>
                                        <div class="control-label" aria-label="Name"><%=GetGlobalResourceObject("Labels", "Lbl_Name_Text") %></div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-md-5">
                                                <asp:Label AssociatedControlID="txtFirstName" CssClass="control-label" runat="server" Text="<%$ Resources:LblFirstNameText %>" ToolTip="<%$ Resources:LblFirstNameToolTip %>"></asp:Label>
                                                <asp:TextBox CssClass="form-control" ID="txtFirstName" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:Label AssociatedControlID="txtSecondName" CssClass="control-label" runat="server" Text="<%$ Resources:Labels, Lbl_Second_Name_Text %>" ToolTip="<%$ Resources:LblSecondNameToolTip %>"></asp:Label>
                                                <asp:TextBox CssClass="form-control" ID="txtSecondName" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="col-md-5">
                                                <asp:Label AssociatedControlID="txtLastName" CssClass="control-label" runat="server" Text="<%$ Resources:LblLastNameText %>" ToolTip="<%$ Resources:LblLastNameToolTip %>"></asp:Label>
                                                <asp:TextBox CssClass="form-control" ID="txtLastName" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label AssociatedControlID="txtDateOfBirth"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources: Labels, Lbl_Date_Of_Birth_Text %>"
                                            ToolTip="<%$ Resources: Labels, Lbl_Date_Of_Birth_ToolTip %>"></asp:Label>
                                        <eidss:CalendarInput ID="txtDateOfBirth" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                        <asp:CheckBox ID="chkUnknownDob" runat="server" />
                                        <asp:Label
                                            AssociatedControlID="chkUnknownDob"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblUnknownDobText %>"
                                            ToolTip="<%$ Resources:LblUnknownDobToolTip %>"></asp:Label>
                                    </div>
                                    <div class="form-group hidden" id="estimatedAgeGroup">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="txtEstimatedAge"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblEstimatedAgeText %>"
                                            ToolTip="<%$ Resources:LblEstimatedAgeToolTip %>"></asp:Label>
                                        <asp:TextBox CssClass="form-control" ID="txtEstimatedAge" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <fieldset>
                                            <legend>
                                                <div class="glyphicon glyphicon-asterisk"></div>
                                                <span aria-label="<%= GetLocalResourceObject("SexText") %>" class="control-label"><%= GetLocalResourceObject("SexText") %></span></legend>
                                            <div class="form-group">
                                                <asp:RadioButton ID="rdoFemale" runat="server" GroupName="gender" />
                                                <asp:Label AssociatedControlID="rdoFemale"
                                                    CssClass="control-label"
                                                    runat="server"
                                                    Text="<%$ Resources:Labels, Lbl_Female_Text %>"
                                                    ToolTip="<%$ Resources:Labels, Lbl_Female_ToolTip %>"></asp:Label>
                                                <asp:RadioButton ID="rdonMale" runat="server" GroupName="gender" />
                                                <asp:Label AssociatedControlID="rdonMale"
                                                    CssClass="control-label"
                                                    runat="server"
                                                    Text="<%$ Resources:Labels, Lbl_Male_Text %>"
                                                    ToolTip="<%$ Resources:Labels, Lbl_Male_ToolTip %>"></asp:Label>
                                            </div>
                                        </fieldset>
                                    </div>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="ddlCitizenShip"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblCitizenShipText %>"
                                            ToolTip="<%$ Resources:LblCitizenShipToolTip %>"></asp:Label>
                                        <asp:DropDownList CssClass="form-control" ID="ddlCitizenShip" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="ddlIdType"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:Labels, Lbl_Id_Type_Text %>"
                                            ToolTip="<%$ Resources:Labels, Lbl_Id_Type_ToolTip %>"></asp:Label>
                                        <asp:DropDownList CssClass="form-control" ID="ddlIdType" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="txtPersonalId"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:Lbl_Personal_Id_Instruction_Text %>"
                                            ToolTip="<%$ Resources:Lbl_Personal_Id_Instruction_ToolTip %>"></asp:Label>
                                        <asp:TextBox CssClass="form-control" ID="txtPersonalId" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="heading"><% = GetLocalResourceObject("DemographicsSectionHeading") %></h3>
                                </div>
                                <div class="panel-body">
                                    <h4><%= GetLocalResourceObject("LocalAddressText") %></h4>
                                    <eidss:LocationUserControl runat="server" ID="localAddress" />
                                    <fieldset>
                                        <legend>
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <span aria-label="<%= GetLocalResourceObject("LblCanStayText") %>" class="control-label"><%= GetLocalResourceObject("LblCanStayText") %></span>
                                        </legend>

                                        <div class="form-group">
                                            <asp:RadioButton ID="rdoCanStayYes" runat="server" GroupName="CanStay" />
                                            <asp:Label AssociatedControlID="rdoCanStayYes"
                                                CssClass="control-label"
                                                runat="server"
                                                Text="<%$Resources:LblChkYesText %>"
                                                ToolTip="<%$ Resources:LblChkYesToolTip %>"></asp:Label>
                                        </div>
                                        <div class="form-group">
                                            <asp:RadioButton ID="rdoCanStayNo" runat="server" GroupName="CanStay" />
                                            <asp:Label AssociatedControlID="rdoCanStayNo"
                                                CssClass="control-label"
                                                runat="server"
                                                Text="<%$Resources:LblChkNoText %>"
                                                ToolTip="<%$ Resources:LblChkNoToolTip %>"></asp:Label>
                                        </div>
                                    </fieldset>
                                    <!-- hidden other address container -->
                                    <div id="secondAddressContainer" class="hidden">
                                        <h4><%= GetLocalResourceObject("OtherAddressText") %></h4>
                                        <eidss:LocationUserControl ID="OtherAddress" runat="server" ShowPhone="false" />
                                    </div>

                                </div>
                                <div class="panel-footer"></div>
                            </div>
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="heading"><% = GetLocalResourceObject("WorkOrSchoolText") %></h3>
                                </div>
                                <div class="panel-body">

                                    <fieldset>
                                        <legend>
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <span aria-label="<%= GetLocalResourceObject("LblWorkOrStudyText") %>" class="control-label"><%= GetLocalResourceObject("LblWorkOrStudyText") %></span></legend>

                                        <div class="form-group">
                                            <asp:RadioButton ID="rdoStudyWorkYes" runat="server" GroupName="WorkOrStudy" />
                                            <asp:Label AssociatedControlID="rdoStudyWorkYes"
                                                CssClass="control-label"
                                                runat="server"
                                                Text="<%$ Resources:LblChkYesText %>"
                                                ToolTip="<%$ Resources:LblChkYesToolTip %>"></asp:Label>

                                            <asp:RadioButton ID="rdoStudyWorkNo" runat="server" GroupName="WorkOrStudy" />
                                            <asp:Label AssociatedControlID="rdoStudyWorkNo"
                                                CssClass="control-label"
                                                runat="server"
                                                Text="<%$ Resources:lblChkNoText %>"
                                                ToolTip="<% Resources:  LblChkNoToolTip %>"></asp:Label>
                                            <asp:RadioButton ID="rdoStudyWorkUnknown" runat="server" GroupName="WorkOrStudy" />
                                            <asp:Label AssociatedControlID="rdoStudyWorkUnknown"
                                                CssClass="control-label"
                                                runat="server"
                                                Text="<%$ Resources:LblChkUnknownText %>"
                                                ToolTip="<%$ Resources:LblChkUnknownToolTip %>"></asp:Label>
                                        </div>
                                    </fieldset>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="txtEmployerName"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:Labels, Lbl_Employer_Name_Text %>"
                                            ToolTip="<%$ Resources:Labels, Lbl_Employer_Name_ToolTip %>"></asp:Label>
                                        <asp:TextBox CssClass="form-control" ID="txtEmployerName" runat="server"></asp:TextBox>
                                    </div>
                                    <h4><%= GetLocalResourceObject("WorkAddressText") %></h4>
                                    <eidss:LocationUserControl ID="schoolOrWorkAddress" runat="server" />

                                </div>
                                <div class="panel-footer"></div>
                            </div>
                        </section>
                        <!-- Section 3 Clinical Section -->
                        <section id="ClinicalSection" runat="server" class="col-md-12 hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-md-11">
                                            <h3 class="heading"><% = GetLocalResourceObject("ClinicalSectionHeading") %></h3>
                                        </div>
                                        <div class="col-md-1 heading text-right">
                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <fieldset>
                                        <legend>
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <span aria-label="<%= GetLocalResourceObject("CaseClassificationText") %>"
                                                class="control-label"><%= GetLocalResourceObject("CaseClassificationText") %></span>
                                        </legend>

                                        <div class="form-group">
                                            <asp:RadioButton ID="rdoSuspected" runat="server" GroupName="CaseClassification" />
                                            <asp:Label AssociatedControlID="rdoSuspected"
                                                CssClass="control-label"
                                                runat="server"
                                                Text="<%$ Resources:LblSuspectedText %>"
                                                ToolTip="<%$ Resources:LblSuspectedToolTip %>"></asp:Label>

                                            <asp:RadioButton ID="rdoProbable" runat="server" GroupName="CaseClassification" />
                                            <asp:Label AssociatedControlID="rdoProbable"
                                                CssClass="control-label"
                                                runat="server"
                                                Text="<%$ Resources:LblProbableText %>"
                                                ToolTip="<%$ Resources:LblProbableToolTip %>"></asp:Label>

                                            <asp:RadioButton ID="rdoConfirmed" runat="server" GroupName="CaseClassification" />
                                            <asp:Label AssociatedControlID="rdoConfirmed"
                                                CssClass="control-label"
                                                runat="server"
                                                Text=" <%$ Resources:LblConfirmedText %>"
                                                ToolTip="<%$ Resources:LblConfirmedToolTip %>"></asp:Label>
                                        </div>
                                    </fieldset>

                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="txtDateOfExposure"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblDateOfExposureText %>"
                                            ToolTip="<%$ Resources:LblDateOfExposureToolTip %>"></asp:Label>
                                        <eidss:CalendarInput ID="txtDateOfExposure" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                    </div>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="txtDateOfSymptomOnset"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_Text %>"
                                            ToolTip="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_ToolTip %>"></asp:Label>
                                        <eidss:CalendarInput ID="txtDateOfSymptomOnset" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                    </div>
                                    <h4><%=GetLocalResourceObject("locationOfExposureText") %></h4>
                                    <eidss:LocationUserControl ID="locationOfExposure" runat="server" ShowPhone="false" />
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <h3><%=GetLocalResourceObject("InitialCareText") %></h3>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <fieldset>
                                        <legend>
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <span aria-label="<%=GetLocalResourceObject("DiffFacilityText") %>" class="control-label">
                                                <%=GetLocalResourceObject("DiffFacilityText") %>
                                            </span>
                                        </legend>
                                        <asp:RadioButton GroupName="DifferentFacility" ID="rdoDifferentFacilityYes" runat="server" />
                                        <asp:Label AssociatedControlID="rdoDifferentFacilityYes"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblChkYesText %>"
                                            ToolTip="<%$ Resources:LblChkYesToolTip %>"></asp:Label>
                                        <asp:RadioButton GroupName="DifferentFacility" ID="rdoDifferentFacilityNo" runat="server" />
                                        <asp:Label AssociatedControlID="rdoDifferentFacilityNo"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblChkNoText %>"
                                            ToolTip="<%$ Resources:LblChkNoToolTip %>"></asp:Label>
                                    </fieldset>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label AssociatedControlID="txtDateOfFirstCare"
                                            CssClass="control-label"
                                            runat="server"
                                            Text="<%$ Resources:LblFirstCareText %>"
                                            ToolTip="<%$ Resources:LblFirstCareToolTip %>"></asp:Label>
                                        <eidss:CalendarInput ID="txtDateOfFirstCare" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Format="MM/DD/YYYY"></eidss:CalendarInput>
                                    </div>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="txtOtherFacilityName"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblOtherFacilityNameText %>"
                                            ToolTip="<%$ Resources:LblOtherFacilityNameToolTip %>"></asp:Label>
                                        <asp:TextBox ID="txtOtherFacilityName" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="ddlDiagnosisOtherFacility"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblDiagnosisOtherFacilityText %>"
                                            ToolTip="<%$ Resources:LblDiagnosisOtherFacilityToolTip %>"></asp:Label>
                                        <asp:DropDownList ID="ddlDiagnosisOtherFacility" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <hr />
                                    <fieldset>
                                        <legend>
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <span aria-label="<%= GetLocalResourceObject("DifferentHospitalText") %>" class="control-label">
                                                <%= GetLocalResourceObject("DifferentHospitalText") %>
                                            </span>
                                        </legend>
                                        <asp:RadioButton ID="rdoHospitalizedOtherYes" runat="server" GroupName="HospitalizedOther" />
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="rdoHospitalizedOtherYes"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblChkYesText %>"
                                            ToolTip="<%$ Resources:LblChkYesToolTip %>"></asp:Label>
                                        <asp:RadioButton ID="rdoHospitalizedOtherNo" runat="server" GroupName="HospitalizedOther" />
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="rdoHospitalizedOtherNo"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblChkNoText %>"
                                            ToolTip="<%$ Resources:LblChkNoToolTip %>"></asp:Label>
                                    </fieldset>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="txtDateOfOtherHospitalization"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblOtherHospitalText %>"
                                            ToolTip="<%$ Resources:LblOtherHospitalToolTip %>"></asp:Label>
                                        <asp:TextBox ID="txtDateOfOtherHospitalization" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <div class="glyphicon glyphicon-asterisk"></div>
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="ddlOtherPlaceHospital"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblOtherFacilityNameText %>"
                                            ToolTip="<%$ Resources:LblOtherFacilityNameToolTip %>"></asp:Label>
                                        <asp:DropDownList ID="ddlOtherPlaceHospital" runat="server" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                    <fieldset>
                                        <legend>
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <span aria-label="<%=GetLocalResourceObject("AntibacterialText") %>" class="control-label">
                                                <%=GetLocalResourceObject("AntibacterialText") %>
                                            </span>
                                        </legend>
                                        <asp:RadioButton ID="rdoAntibacteriaAdministereYes" runat="server" GroupName="AntibacterialOther" />
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="rdoAntibacteriaAdministereYes"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblChkYesText %>"
                                            ToolTip="<%$ Resources:LblChkYesToolTip %>"></asp:Label>
                                        <asp:RadioButton ID="rdoAntibacteriaAdministeredNo" runat="server" GroupName="AntibacterialOther" />
                                        <asp:Label
                                            runat="server"
                                            AssociatedControlID="rdoAntibacteriaAdministeredNo"
                                            CssClass="control-label"
                                            Text="<%$ Resources:LblChkNoText %>"
                                            ToolTip="<%$ Resources:LblChkNoToolTip %>"></asp:Label>
                                    </fieldset>
                                    <div class="form-group">
                                        <div class="table-responsive">
                                            <asp:GridView
                                                AllowPaging="true"
                                                AllowSorting="true"
                                                AutoGenerateColumns="false"
                                                Caption="<%$ Resources:AntibacterialGridHeading %>"
                                                CaptionAlign="Left"
                                                CssClass="table table-striped table-hover"
                                                DataKeyNames="Name,Dose"
                                                EmptyDataText="<%$ Resources:AntibacterialGridEmptyData %>"
                                                ShowHeader="true"
                                                ID="grdAntiviralOther"
                                                runat="server">
                                                <Columns>
                                                    <asp:BoundField AccessibleHeaderText="<%$ Resources: LblAntibacterialGridNameHeading %>" HeaderText="<%$ Resources: LblAntibacterialGridNameHeading %>" DataField="Name" />
                                                    <asp:BoundField AccessibleHeaderText="<%$ Resources:LblAntibacterialGridDoseHeading %>" HeaderText="<%$ Resources:LblAntibacterialGridDoseHeading %>" DataField="Dose" />
                                                    <asp:BoundField AccessibleHeaderText="<%$ Resources:LblAntibacterialGridDateHeading %>" HeaderText="<%$ Resources:LblAntibacterialGridDateHeading %>" DataField="DateAdministered" />
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                        <asp:LinkButton CssClass="btn btn-primary" ID="btnAddAntiviral" runat="server">
                                            <span><%= GetLocalResourceObject("btnAddNewAntibacterial") %></span>
                                        </asp:LinkButton>
                                    </div>
                                    <div class="panel-footer"></div>
                                </div>
                            </div>
                        </section>
                        <!-- Section 4 Sample Collection & Registration Section -->
                        <section id="SamplesSection" runat="server" class="col-md-12 hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-md-11">
                                            <h3 class="heading"><% = GetLocalResourceObject("SamplesSectionHeading") %></h3>
                                        </div>
                                        <div class="col-md-1 heading text-right">
                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">
                                        <div class="table-responsive">
                                            <asp:GridView
                                                AllowPaging="true"
                                                AllowSorting="true"
                                                AutoGenerateColumns="false"
                                                Caption="<%$ Resources:SamplesGridHeading %>"
                                                CaptionAlign="Left"
                                                CssClass="table table-striped table-hover"
                                                DataKeyNames="sampleID"
                                                EmptyDataText="<%$ Resources:SamplesGridEmptyData %>"
                                                ShowHeader="true"
                                                ID="grdSamplesCollection"
                                                runat="server">
                                                <Columns>
                                                    <asp:BoundField AccessibleHeaderText="<%$ Resources:LblSampleTypeHeading %>" HeaderText="<%$ Resources:LblSampleTypeHeading %>" DataField="SampleType" />
                                                    <asp:BoundField AccessibleHeaderText="<%$ Resources:LblSampleIdHeading %>" HeaderText="<%$ Resources:LblSampleIdHeading %>" DataField="SampleID" />
                                                    <asp:BoundField AccessibleHeaderText="<%$ Resources:LblCollectionDateHeading %>" HeaderText="<%$ Resources:LblCollectionDateHeading %>" DataField="DateCollected" />
                                                    <asp:BoundField AccessibleHeaderText="<%$ Resources:LblSentDateHeading %>" HeaderText="<%$ Resources:LblSentDateHeading %>" DataField="DateSent" />
                                                    <asp:CommandField ShowEditButton="true" />
                                                    <asp:CommandField ShowDeleteButton="true" />
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                        <a class="btn btn-primary" id="btnAddSample" data-toggle="modal" data-target="#SampleModal">
                                            <span><%= GetGlobalResourceObject("Buttons", "Btn_Add_Sample_Text") %></span>
                                        </a>
                                        <a class="btn btn-primary" id="btnAddNonDtraSample" runat="server" data-toggle="modal" data-target="#NonDtraSampleModal"></a>
                                    </div>
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                        </section>
                        <!-- Section 5 Contacts Section -->
                        <section id="ContactsSection" runat="server" class="col-md-12 hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-md-11">
                                            <h3 class="heading"><% = GetLocalResourceObject("ContactsSectionHeading") %></h3>
                                        </div>
                                        <div class="col-md-1 heading text-right">
                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">
                                        <div class="table-responsive">
                                            <asp:GridView
                                                AllowPaging="true"
                                                AllowSorting="true"
                                                AutoGenerateColumns="false"
                                                Caption="<%$ Resources:ContactsGridHeading %>"
                                                CaptionAlign="Left"
                                                CssClass="table table-striped table-hover"
                                                DataKeyNames="sampleID"
                                                EmptyDataText="<%$ Resources:ContactsGridEmptyData %>"
                                                ShowHeader="true"
                                                ID="grdContacts"
                                                runat="server">
                                                <Columns>
                                                    <asp:CommandField ShowEditButton="true" />
                                                    <asp:CommandField ShowDeleteButton="true" />
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                        <a class="btn btn-primary" id="btnShowContactSearch" data-toggle="modal" data-target="#ContactModal">
                                            <span><%= GetGlobalResourceObject("Buttons", "Btn_Add_Contact_Text") %></span>
                                        </a>
                                    </div>
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                        </section>
                        <!-- Section 6 Case Classification Section -->
                        <section id="CaseClassificationSection" runat="server" class="col-md-12 hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                            <h3 class="heading"><% = GetLocalResourceObject("CaseClassificationSectionHeading") %></h3>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 heading text-right">
                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <!--  Suspect questions -->

                                    <div class="form-group">
                                        <fieldset>
                                            <legend>
                                                <span id="suspectMainQuestion" runat="server"></span>
                                            </legend>
                                            <asp:RadioButton ID="rdoSuspectMainQuestionYes" runat="server" GroupName="SuspectMain" />
                                            <asp:Label
                                                runat="server"
                                                AssociatedControlID="rdoSuspectMainQuestionYes"
                                                CssClass="control-label"
                                                Text="<%$ Resources:LblChkYesText %>"
                                                ToolTip="<%$ Resources:LblChkYesToolTip %>"></asp:Label>
                                            <asp:RadioButton ID="rdoSuspectMainQuestionNo" runat="server" GroupName="SuspectMain" />
                                            <asp:Label
                                                runat="server"
                                                AssociatedControlID="rdoSuspectMainQuestionNo"
                                                CssClass="control-label"
                                                Text="<%$ Resources:LblChkNoText %>"
                                                ToolTip="<%$ Resources:LblChkNoToolTip %>"></asp:Label>
                                            <asp:RadioButton ID="rdoSuspectMainQuestionUnknown" runat="server" GroupName="SuspectMain" />
                                            <asp:Label
                                                runat="server"
                                                AssociatedControlID="rdoSuspectMainQuestionUnknown"
                                                CssClass="control-label"
                                                Text="<%$ Resources:LblCheckUnknownText %>"
                                                ToolTip="<%$ Resources:LblCheckUnknownToolTip %>"></asp:Label>
                                        </fieldset>
                                    </div>
                                    <div id="suspectQuestionContainer" runat="server" class="hidden">
                                    </div>
                                    <div class="alert alert-success hidden" id="alertSuspect">
                                        <% = GetLocalResourceObject("LblAlertSuspect1") %>
                                        <strong><% = GetLocalResourceObject("LblAlertSuspect2") %></strong>
                                        <% = GetLocalResourceObject("LblAlertSuspect3") %>
                                        <!-- TODO:  ENTER VARIABLE THAT HOLDS the disease name -->
                                        some disease
                                        <% = GetLocalResourceObject("LblAlertSuspect4") %>
                                    </div>
                                    <div id="probableQuestionContainer" runat="server" class="hidden">
                                    </div>
                                    <div class="alert alert-success hidden" id="alertProbable">
                                        <% = GetLocalResourceObject("LblAlertProbable1") %>
                                        <strong><% = GetLocalResourceObject("LblAlertProbable2") %></strong>
                                        <% = GetLocalResourceObject("LblAlertProbable3") %>
                                        <!-- TODO:  ENTER VARIABLE THAT HOLDS the disease name -->
                                        Some Disease
                                        <% = GetLocalResourceObject("LblAlertProbable4") %>
                                    </div>
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                        </section>
                        <!-- Section 7 Epidemic links Section -->
                        <section id="EpiLinksSection" runat="server" class="col-md-12 hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                        <h3 class="heading"><% = GetLocalResourceObject("EpiLinksSectionHeading") %></h3>
                                    </div>
                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 heading text-right">
                                        <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                            <% = GetLocalResourceObject("SubheaderEpiLinksText") %>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <fieldset>
                                            <legend>
                                                <div class="glyphicon glyphicon-asterisk"></div>
                                                <span aria-label="" class="control-label"></span>
                                            </legend>
                                            <asp:RadioButton ID="rdoEpiYes" runat="server" GroupName="EpiGroup" />
                                            <asp:Label ID="Label1"
                                                runat="server"
                                                AssociatedControlID="rdoEpiYes"
                                                CssClass="control-label"
                                                Text="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_ToolTip %>"
                                                ToolTip="<%$ Resources:Labels, Lbl_Yes_ToolTip %>"></asp:Label>
                                            <asp:RadioButton ID="rdoEpiNo" runat="server" GroupName="EpiGroup" />
                                            <asp:Label ID="Label2"
                                                runat="server"
                                                AssociatedControlID="rdoEpiNo"
                                                CssClass="control-label"
                                                Text="<%$ Resources: Labels, Lbl_No_Text%>"
                                                ToolTip="<%$ Resources:Labels, Lbl_No_ToolTip %>"></asp:Label>
                                        </fieldset>
                                    </div>
                                    <div id="EpiQuestionContainer" class="hidden">
                                        <div class="row">
                                            <div class="col-md-5">
                                                <asp:Label ID="Label3"
                                                    AssociatedControlID="txtFirstName"
                                                    CssClass="control-label"
                                                    runat="server"
                                                    Text="<%$ Resources: Labels, LblFirstNameText %>"
                                                    ToolTip="<%$ Resources: Labels, LblFirstNameToolTip %>"></asp:Label>
                                                <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="col-md-2">
                                                <asp:Label ID="Label4"
                                                    AssociatedControlID="txtSecondName"
                                                    CssClass="control-label"
                                                    runat="server"
                                                    Text="<%$ Resources:Labels, Lbl_Second_Name_Text %>"
                                                    ToolTip="<%$ Resources:Labels, LblSecondNameToolTip %>"></asp:Label>
                                                <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="col-md-5">
                                                <asp:Label
                                                    ID="Label5"
                                                    AssociatedControlID="txtLastName"
                                                    CssClass="control-label" runat="server"
                                                    Text="<%$ Resources:Labels, Lbl_Family_Name_Text %>"
                                                    ToolTip="<%$ Resources:Labels, Lbl_Family_Name_ToolTip %>"></asp:Label>
                                                <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <asp:Label ID="Label6"
                                                runat="server"
                                                AssociatedControlID="txtSymptomOnset"
                                                CssClass="control-label"
                                                Text="<%$ Resources:LblSymtpomOnsetText %>"
                                                ToolTip="<%$ Resources:LblSymtpomOnsetToolTip %>"></asp:Label>
                                            <asp:TextBox ID="txtSymptomOnset" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="form-group">
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <asp:Label ID="Label7"
                                                runat="server"
                                                AssociatedControlID="txtPersonLocation"
                                                CssClass="control-label"
                                                Text="<%$ Resources:LblPersonLocationText %>"
                                                ToolTip="<%$ Resources:LblPersonLocationToolTip %>"></asp:Label>
                                            <asp:TextBox ID="txtPersonLocation" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="form-group">
                                            <fieldset>
                                                <legend>
                                                    <div class="glyphicon glyphicon-asterisk"></div>
                                                    <span aria-label="" class="control-label">
                                                        <%= GetLocalResourceObject("LgdHaveContactText") %>
                                                    </span>
                                                </legend>
                                                <asp:RadioButton ID="rdoTwoWeekContactYes" runat="server" GroupName="TwoWeekContact" />
                                                <asp:Label ID="Label9"
                                                    runat="server"
                                                    AssociatedControlID="rdoTwoWeekContactYes"
                                                    CssClass="control-label"
                                                    Text="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_ToolTip %>"
                                                    ToolTip="<%$ Resources:Labels, Lbl_Yes_ToolTip %>"></asp:Label>
                                                <asp:RadioButton ID="rdoTwoWeekContactNo" runat="server" GroupName="TwoWeekContact" />
                                                <asp:Label ID="Label10"
                                                    runat="server"
                                                    AssociatedControlID="rdoTwoWeekContactNo"
                                                    CssClass="control-label"
                                                    Text="<%$ Resources:Labels, Lbl_No_Text %>"
                                                    ToolTip="<%$ Resources:Labels, Lbl_No_ToolTip %>"></asp:Label>
                                            </fieldset>
                                        </div>
                                        <div class="form-group">
                                            <div class="glyphicon glyphicon-asterisk"></div>
                                            <asp:Label ID="Label8"
                                                runat="server"
                                                AssociatedControlID="txtPlaceOfContact"
                                                CssClass="control-label"
                                                Text="<%$ Resources:LblPlaceOfContactText %>"
                                                ToolTip="<%$ Resources:LblPlaceOfContactToolTip %>"></asp:Label>
                                            <asp:TextBox ID="txtPlaceOfContact" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <div class="form-group">
                                            <fieldset>
                                                <legend>
                                                    <div class="glyphicon glyphicon-asterisk"></div>
                                                    <span aria-label="" class="control-label">
                                                        <% = GetLocalResourceObject("LgdAnyOthersText") %>
                                                    </span>
                                                </legend>
                                                <asp:RadioButton ID="rdoAnyOthersYes" runat="server" GroupName="AnyOthers" />
                                                <asp:Label ID="Label11"
                                                    runat="server"
                                                    AssociatedControlID="rdoAnyOthersYes"
                                                    CssClass="control-label"
                                                    Text="<%$ Resources:Labels, Lbl_Date_of_Symptom_Onset_ToolTip %>"
                                                    ToolTip="<%$ Resources:Labels, Lbl_Yes_ToolTip %>"></asp:Label>
                                                <asp:RadioButton ID="rdoAnyOthersNo" runat="server" GroupName="AnyOthers" />
                                                <asp:Label ID="Label12"
                                                    runat="server"
                                                    AssociatedControlID="rdoAnyOthersNo"
                                                    CssClass="control-label"
                                                    Text="<%$ Resources:Labels, Lbl_No_Text %>"
                                                    ToolTip="<%$ Resources:Labels, Lbl_No_ToolTip %>"></asp:Label>
                                            </fieldset>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                        </section>
                        <!-- Section 8 Risk Factors Section -->
                        <section id="RiskfactorsSection" runat="server" class="col-md-12 hidden">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-md-11">
                                            <h3 class="heading"><% = GetLocalResourceObject("RiskFactorsSectionHeading") %></h3>
                                        </div>
                                        <div class="col-md-1 heading text-right">
                                            <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)"></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body" id="riskFactorsContainer" runat="server">
                                </div>
                                <div class="panel-footer"></div>
                            </div>
                        </section>
                    </div>
                    <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                            <MenuItems>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="0" 
                                    ID="sideBarItemGeneralInfo" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_General_Info_Section_Heading"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="1" 
                                    ID="sideBarItemPatientInfo" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Patient_Info_Section"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="2" 
                                    ID="sideBarItemClinical" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Clinical"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="3" 
                                    ID="sideBarItemSamples" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Samples"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="4" 
                                    ID="sideBarItemContacts" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Contacts"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="5" 
                                    ID="sideBarItemCaseClassification" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Case_Classification"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="6" 
                                    ID="sideBarItemEpiLinks" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Epi_Links"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="7" 
                                    ID="sideBarItemRiskFactors" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Risk_factors"
                                    runat="server"></eidss:SideBarItem>
                                <eidss:SideBarItem 
                                    CssClass="glyphicon glyphicon-ok" 
                                    GoToTab="8" 
                                    ID="sideBarItemReview" 
                                    IsActive="true" 
                                    ItemStatus="IsNormal" 
                                    meta:resourcekey="Tab_Review"
                                    runat="server"></eidss:SideBarItem>
                                </MenuItems>
                        </eidss:SideBarNavigation>                   
                </div>
                <div class="row">
                    <div class="col-md-6 col-md-offset-1 text-center">
                        <input  
                            class="btn btn-default" 
                            id="btnCancel" 
                            onclick="location.replace('Dashboard.aspx')"
                            value="<%= GetGlobalResourceObject("Buttons", "Btn_Cancel_Text") %>" 
                            type="button" />
                        <input type="button" id="btnPreviousSection" value="<%= GetGlobalResourceObject("Buttons", "Btn_Back_Text") %>" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                        <input type="button" id="btnNextSection" value="<%= GetGlobalResourceObject("Buttons", "BtnContinueText") %>" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                        <asp:Button runat="server" Text="<%$ Resources:Buttons, Btn_Save_Text %>" ID="btnSave" CssClass="btn btn-primary" ToolTip="<%$Resources:Buttons, Btn_Save_ToolTip %>" />
                        <asp:Button runat="server" Text="<%$ Resources:Buttons, Btn_Submit_Text %>" ID="btnSubmit" CssClass="btn btn-primary hidden" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8 col-lg-offset-2 col-md-offset-2 col-sm-offset-2 col-xs-offset-2">
                        <eidss:PopUpDialog ID="CaseInvestigationPopUpDialog" runat="server" ShowModalHeader="true" />
                        <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
                    </div>
                </div>
            
                
                <script type="text/javascript">

                    $(document).ready(function () {
                        //  adding click events to up/down arrow to collapse/expand the more info panel
                        var arrow = $("#btnShowMore").click(function () {
                            $("#upArrowGlyph").toggleClass("glyphicon glyphicon-arrow-down")
                            $("#upArrowGlyph").toggleClass("glyphicon glyphicon-arrow-up")
                            var showLess = "<%= GetLocalResourceObject("ShowLessData") %>";
                            var showMore = "<%= GetLocalResourceObject("ShowMoreData") %>";
                            if ($("#upArrowGlyph").hasClass("glyphicon-arrow-down")) {
                                $("#btnShowMore").text(showLess);
                            }
                            else {
                                $("#btnShowMore").text(showMore);
                            }
                        }); // end of upArrowGlyph.click() event

                        //  adding onclick events to radio buttons in epi section
                        //  to toggle display of hidden container
                        var epiYes = $("#<% = rdoEpiYes.ClientID %>");
                        epiYes.change(function () {
                            var container = $("#EpiQuestionContainer");
                            if (container.hasClass("hidden")) {
                                container.removeClass("hidden");
                            }
                        });  // end of epiYes.change()
                        var epiNo = $("#<% = rdoEpiNo.ClientID %>");
                        epiNo.change(function () {
                            var container = $("#EpiQuestionContainer");
                            if (container.hasClass("hidden") == false) {
                                container.addClass("hidden");
                            }

                        });  // end of epiNo.change()

                        $("#estimatedAgeGroup").change(function () {
                            var container = $("#estimatedAgeGroup");
                            container.toggleClass("hidden");
                        }); //  end of estimatedAgeGroup.change()

                        $("#rdoCanStayYes").change(function () {
                            $("#secondAddressContainer").removeClass("hidden");
                        }); //  end of rdoCanStayYes.change()

                        $("#rdoCanStayNo").change(function () {
                            var container = $("#secondAddressContainer");
                            if (container.hasClass("hidden") == false) {
                                container.addClass("hidden");
                            }
                        }); // end of rdoCanStayNo.change()

                        $("#<% =rdoSuspectMainQuestionYes.ClientID %>").change(function () {
                            $("#<% =suspectQuestionContainer.ClientID %>").removeClass("hidden");
                        });  // end of rdoSuspectMainQuestionYes.change()

                        $("#<% =rdoSuspectMainQuestionNo.ClientID %>").change(function () {
                            var container = $("#<% =suspectQuestionContainer.ClientID %>");
                            if (container.hasClass("hidden") == false) {
                                container.addClass("hidden")
                            }
                        });  // end of rdoSuspectMainQuestionNo.change()

                        $("#<% =rdoSuspectMainQuestionUnknown.ClientID %>").change(function () {
                            var container = $("#<% =suspectQuestionContainer.ClientID %>");
                            if (container.hasClass("hidden") == false) {
                                container.addClass("hidden")
                            }
                        });  // end of rdoSuspectMainQuestionUnknown()

                        setViewOnPageLoad("<% =hdnPanelController.ClientID %>");
                        setCaseClassificationOnLoad();
                    });  // end of ready()

                    var suspectQuestionArray = new Array();

                    function tallySuspectQuestions(id, vote) {
                        // determine if I should add or update
                        var addNew = true;
                        var counter = 0;

                        for (key in suspectQuestionArray) {

                            if (suspectQuestionArray[key].key == id) {
                                suspectQuestionArray[key].value = vote;
                                addNew = false;
                            }

                            if ((suspectQuestionArray[key] != undefined) &&
                                (suspectQuestionArray[key].value == "yes")) {
                                counter++;
                            }
                        }

                        if (addNew) {
                            //  add new key/value pair
                            var point = { key: id, value: vote };
                            suspectQuestionArray.push(point);
                            if (vote == "yes") {
                                counter++;
                            }
                        }

                        //  after adding or updating.. manipulate view contents if necessary
                        if (counter >= 5) {
                            $("#<% = probableQuestionContainer.ClientID %>").removeClass("hidden");
                            $("#alertSuspect").removeClass("hidden");
                        }
                        else {
                            if ($("#<% = probableQuestionContainer.ClientID %>").hasClass("hidden") == false) {
                                $("#<% = probableQuestionContainer.ClientID %>").addClass("hidden")
                                $("#alertSuspect").addClass("hidden");
                            }
                        }
                    }

                    var probableQuestionArray = new Array();

                    function tallyProbableQuestions(id, vote) {
                        // determine if I should add or update
                        var addNew = true;
                        var counter = 0;

                        for (key in probableQuestionArray) {

                            if (probableQuestionArray[key].key == id) {
                                probableQuestionArray[key].value = vote;
                                addNew = false;
                            }

                            if ((probableQuestionArray[key] != undefined) &&
                                (probableQuestionArray[key].value == "yes")) {
                                counter++;
                            }
                        }

                        if (addNew) {
                            //  add new key/value pair
                            var point = { key: id, value: vote };
                            probableQuestionArray.push(point);
                            if (vote == "yes") {
                                counter++;
                            }
                        }

                        //  after adding or updating.. manipulate view contents if necessary
                        if (counter >= 1) {
                            $("#alertProbable").removeClass("hidden");
                        }
                        else {
                            if ($("#alertProbable").hasClass("hidden") == false) {
                                $("#alertProbable").addClass("hidden");
                            }
                        }
                    }

                    ///  NOTE: this is meant to maintain the view during postbacks; however, I'm not sure I need it
                    function setCaseClassificationOnLoad() {
                        if ($("#<% =rdoSuspectMainQuestionYes.ClientID %>").prop('checked') == true) {
                            $("#<% =suspectQuestionContainer.ClientID %>").removeClass("hidden");
                            var suspectRadioButtons = $("input[name='SuspectMain']");
                            if (suspectRadioButtons.length > 0) {
                                for (key in suspectRadioButtons) {
                                    var id = suspectRadioButtons[key].key;
                                    var vote = suspectRadioButtons[key].value;
                                    tallySuspectQuestions(id, vote)
                                }
                            }
                        }
                    }
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>






    <div id="SampleModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <eidss:SampleUserControl runat="server" ID="SampleUserControl" />
                </div>
            </div>
        </div>
    </div>
    <div id="ContactModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <eidss:ContactUserControl runat="server" ID="ContactUserControl" />
                </div>
            </div>
        </div>
    </div>
    <div id="NonDtraSampleModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <eidss:NonDtraSampleUserControl runat="server" ID="NonDtraSampleUserControl" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
