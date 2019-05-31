<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HumanDiseaseReportUserControl.ascx.vb" Inherits="EIDSS.HumanDiseaseReportUserControl" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>


    <asp:UpdatePanel ID="uppPersonSearch" runat="server">
        <Triggers>
        </Triggers>
        <ContentTemplate>
            <div class="container col-md-12">
                <div class="row">
                    <div id="divHiddenFieldsSection" runat="server" class="row embed-panel">
                        <asp:HiddenField runat="server" ID="hdfCaller" Value="DASHBOARD" />
                        <%--     <asp:HiddenField runat="server" ID="hdfLangID" Value="EN" />--%>
                        <asp:HiddenField runat="server" ID="hdfidfHumanActual" Value="null" />
                        <%--  hdfidfHumanActual--%>
                        <asp:HiddenField runat="server" ID="hdfName" />
                        <asp:HiddenField runat="server" ID="hdfstrEIDSSPersonID" Value="(new)" />
                        <asp:HiddenField runat="server" ID="hdfCurrentDate" />
                        <asp:HiddenField runat="server" ID="txtdatDateOfDeath" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfblnCurrentlyEmployed" />
                        <asp:HiddenField runat="server" ID="hdfidfsOccupationType" Value="null" />
                        <asp:HiddenField runat="server" ID="dhfIsEmployedID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrEmployerPhone" />
                        <asp:HiddenField runat="server" ID="hdfidfEmployerGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfblnCurrentlyInSchool" />
                        <asp:HiddenField runat="server" ID="hdfIsStudentID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfSchoolPhoneNbr" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfSchoolGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfHumanGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfAnotherAddress" />
                        <asp:HiddenField runat="server" ID="hdfidfHumanAltGeoLocation" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrPhone" />
                        <asp:HiddenField runat="server" ID="hdfstrAnotherPhone" />
                        <asp:HiddenField runat="server" ID="hdfstrOtherPhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrRegistrationPhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrHomePhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrWorkPhone" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhoneCountryCode" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhoneNbr" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhoneNbrTypeID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhone2CountryCode" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhone2Nbr" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfContactPhone2NbrTypeID" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfSuccessPopUpFlag" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfidfHumanCase" />
                        <%--hdfidfHumanCase--%>
                        <asp:HiddenField runat="server" ID="hdfstrHumanCaseId" />

                        <asp:HiddenField runat="server" ID="hdfidfHuman" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfPatientPreviouslySought" />
                        <asp:HiddenField runat="server" ID="hdfidfSougtCareFacility" />
                        <asp:HiddenField runat="server" ID="hdfhospitalization" />
                        <asp:HiddenField runat="server" ID="hdfYNAntimicrobialTherapy" />
                        <asp:HiddenField runat="server" ID="hdfidfsYNSpecificVaccinationAdministered" />
                        <asp:HiddenField runat="server" ID="hdfRelatedToOutbreak" />
                        <asp:HiddenField runat="server" ID="hdfidfsYNExposureLocationKnown" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfExposureAddressType" />
                        <asp:HiddenField runat="server" ID="hdfRiskFactor" />
                        <asp:HiddenField runat="server" ID="hdfstrContactPhone" />
                        <asp:HiddenField runat="server" ID="hdfblnClinicalDiagBasis" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfblnLabDiagBasis" Value="0" />
                        <asp:HiddenField runat="server" ID="hdfblnEpiDiagBasis" Value="0" />

                        <%-- Human disease report list search fields --%>
                        <asp:HiddenField runat="server" ID="hdfSearchHumanCaseId" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrCaseId" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfRegion" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfRayon" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfPointGeoLocation" Value="null" />

                        <asp:HiddenField runat="server" ID="idfSentByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="strSentByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="strSentByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="strSentByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="idfSentByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="SentByOffice" Value="null" />

                        <asp:HiddenField runat="server" ID="idfReceivedByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="strReceivedByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="strReceivedByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="strReceivedByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="idfReceivedByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="ReceivedByOffice" Value="null" />




                        <%-- Hum Disease Report Summary --%>
                        <asp:HiddenField runat="server" ID="hdfSummaryIdfsFinalDiagnosis" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrPersonId" Value="null" /> 
                        <asp:HiddenField runat="server" ID="hdfstrPersonName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfFinalCaseStatus" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfdatEnteredDate" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfdatModificationDate" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfSummaryCaseClassification" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfidfPersonEnteredBy" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEnteredByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfOrganizationFullName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrAccountName" Value="null" />                        

                        <asp:HiddenField runat="server" ID="hdfPageMode" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfCallerPage" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfCallerKey" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfidfSentByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrSentByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrSentByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrSentByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfSentByOffice" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfReceivedByPerson" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrReceivedByFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrReceivedByPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfstrReceivedByLastName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfidfReceivedByOffice" Value="null" />

                        <asp:HiddenField runat="server" ID="hdfNextAddSampleInteger" Value="1" />
                        <asp:HiddenField runat="server" ID="hdfModalAddSampleGuid" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfNextAddTestInteger" Value="1" />
                        <asp:HiddenField runat="server" ID="hdfModalAddTestGuid" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfModalAddTestNewIndicator" Value="" />

                        
                         <%-- Organization Admin to HDR Response --%>
                        <asp:HiddenField runat="server" ID="hdfUniqueOrgID" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfOrgName" Value ="NULL" />
                        <asp:HiddenField runat="server" ID="hdfOfficeID" Value="NULL" />
                    </div>
                    <asp:HiddenField runat="server" ID="hdfSessionInformationDisplay" Value="none" />
                    <div id="divHiddenFieldsEAtoHDRInitCache" runat="server" class="row embed-panel">
                        <asp:HiddenField runat="server" ID="hdfEAidfHumanActual" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAHumanCase" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAstrHumanCaseId" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEACallerPage" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAInitiatingCallerPage" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEAPageMode" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEACallerKey" Value="NULL" />
                        <asp:HiddenField runat="server" ID="hdfEALastControlFocus" Value="null" />
                    </div>
                    <div id="divHiddenFieldsEAtoHDRResponse" runat="server" class="row embed-panel">
                        <asp:HiddenField runat="server" ID="hdfEAEmployeeId" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAEmployeeFullName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAFirstName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAPatronymicName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEALastName" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAInstitutionId" Value="null" />
                        <asp:HiddenField runat="server" ID="hdfEAInstitutionFullName" Value="null" />
                    </div>                  
                   

                    <div class="panel panel-default">
                        <%-- Begin: Section Header. The values are retrieved from resource file. --%>
                        <div class="panel-heading">
                            <h2 runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h2>
                            <p><%= GetLocalResourceObject("Page_Text_7") %></p>
                        </div>
                        <%--End: Section Header.--%>
                        <div class="panel-body">
                            <%-- Removed per bug 1810 - The Person Information section is not in the use case and should be removed.
                    <div id="patientReview" class="row embed-panel" runat="server">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
                                        <h3 runat="server" meta:resourcekey="hdg_Person_Information"></h3>
                                    </div>
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                        <label id="lblPersonID" class="label"></label>
                                    </div>
                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                    </div>
                                </div>
                            </div>

                            <%--Begin: Display Search Criteria at top of detail view - removed per bug 1810
                            <div class="panel-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                            <label for="<%= lbldatEnteredDate.ClientID%>" runat="server" meta:resourcekey="Lbl_Person_Review_Date_Created"></label>
                                            <asp:TextBox ID="disdatEnteredDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                            <label for="<%= lbldatModificationDate.ClientID%>" runat="server" meta:resourcekey="Lbl_Person_Review_Date_Updated"></label>
                                            <asp:TextBox ID="disdatModificationDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                                            <label for="<%= lblPatientName.ClientID%>" runat="server" meta:resourcekey="Lbl_Person_Review_Name"></label>
                                            <asp:TextBox ID="disPatientName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                            <%-- Begin: Human Disease Report --%>
                            <div id="disease" class="embed-panel" runat="server" visible="false">
                                <div class="panel panel-default">
                                    <div class="panel-heading" role="tab">
                                        <div class="row">
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                <h3 runat="server" meta:resourcekey="hdg_Disease_Report_Summary"></h3>
                                            </div>
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                <!-- jquery usage of hyperlink data-toggle and data-parent to show hide the summary section, operates on div: diseasedHumanDetail -->
                                                <%--<a id="diseaseReportSummaryCollapsible"
                                                    data-toggle="collapse"
                                                    data-parent="#diseaseReportSummary"
                                                    href="#diseasedHumanDetail"
                                                    role="button"
                                                    aria-expanded="false"
                                                    aria-controls="diseasedHumanDetail">
                                                    <span class="glyphicon glyphicon-triangle-bottom"></span>
                                                </a>--%>

                                                <asp:LinkButton ID="btnShowDiseaseReportSummary" runat="server" CssClass="btn" meta:resourceKey="btn_Show_Disease_Report_Summary"><span id="diseaseReportSummaryStatus" runat="server" class="glyphicon glyphicon-triangle-bottom header-button"></span></asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <div id="diseasedHumanDetail" runat="server" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                <div class="panel-body">
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_ID" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_ID" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryidfHumanCase" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div id="divDiseaseHumanDetail" runat="server" meta:resourcekey="Dis_Disease_Diagnosis" class="col-lg-6 col-md-6 col-sm-6 col-xs-12" visible="false" >
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Diagnosis" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryDiagnosis" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div id="divDiseaseLegacyCaseID" class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Disease_Eidss_Legacy_ID">
                                                <label runat="server" for="txtLegacyCaseID" meta:resourcekey="Lbl_Eidss_Legacy_ID"></label>
                                                <asp:TextBox ID="txtLegacyCaseID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Type" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Report_Type"></label>
                                                <eidss:DropDownList ID="ddlDiseaseReportTypeID" runat="server" CssClass="form-control"></eidss:DropDownList>
                                            </div>
                                            <div id="RelatedSessionID" runat="server" meta:resourcekey="Dis_Disease_Related_Session_ID" class="col-lg-6 col-md-6 col-sm-6 col-xs-12" visible="False">
                                                <label runat="server" meta:resourcekey="lbl_Related_Session_ID"></label>
                                                <asp:TextBox ID="txtSummaryRelatedSessionID" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Name" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_Name"></label>
                                                <asp:TextBox ID="txtSummarystrPersonName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_EIDSS_ID" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_EIDSS_ID"></label>
                                                <asp:TextBox ID="txtSummaryEidsId" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Report_Status" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_Report_Status"></label>
                                                <eidss:DropDownList ID="ddlidfsCaseProgressStatus" runat="server" CssClass="form-control"></eidss:DropDownList>
                                            </div>
                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Case_Classification" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="Lbl_Disease_Report_Case_Classification"></label>
                                                <asp:TextBox ID="txtSummaryCaseClassification" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Date_Entered"></label>
                                                <asp:TextBox ID="txtSummaryDateEntered" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div runat="server" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Date_Last_Updated"></label>
                                                <asp:TextBox ID="txtSummarydatModificationDate" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <div runat="server" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Person_Entered_By" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryEnteredByPerson" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                            <div runat="server" class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <label runat="server" meta:resourcekey="lbl_Entered_By_Organization_Full_Name" class="control-label"></label>
                                                <asp:TextBox ID="txtSummaryOrganizationFullName" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>                                
                            </div>
                            <div class="sectionContainer expanded">
                                <section id="diseaseNotification" runat="server" class="col-md-12 hidden">
                                   <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h3 runat="server" meta:resourcekey="Hdg_Disease_Notification_Sub_Title"></h3>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(0)" runat="server" meta:resourcekey="lbl_Disease_Notification_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"></div>
                                                        <%= GetLocalResourceObject("Page_Text_1") %>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                        meta:resourcekey="Dis_Diagnosis"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Diagnosis"
                                                            runat="server">
                                                        </div>
                                                        <label
                                                            meta:resourcekey="Lbl_Disease_Diagnosis"
                                                            runat="server">
                                                        </label>
                                                        <eidss:DropDownList runat="server" ID="ddlidfsFinalDiagnosis" CssClass="form-control" OnSelectedIndexChanged="ddlidfsFinalDiagnosis_SelectedIndexChanged" AutoPostBack="True" />
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsFinalDiagnosis"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Diagnosis"
                                                            runat="server"
                                                            InitialValue="null"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>

                                                    </div>
                                                </div>
                                            </div>
                                <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                        meta:resourcekey="Dis_Date_of_Diagnosis"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Diagnosis"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Date_of_Diagnosis"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatDateOfDiagnosis" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Diagnosis"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                           <%-- <asp:CustomValidator
                                                           ID="CustomValidatorNotFutureDiagDate"
                                                            runat="server"
                                                            Text="The Disease Date (mm/dd/yyyy) must be earlier than or same as 'Current date' (MM/dd/yyyy)."
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="ValidateNotFutureDate"
                                                            ClientValidationFunction="ValidateNotFutureDateClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>--%>
                                                       <%--  <asp:CustomValidator
                                                            ID="CustomValidator3DateOrderDiagDate"
                                                            runat="server"
                                                            Text="Must be after Symptom Onset and before Notification dates, inclusive, if present."
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="Validate3DateOrder"
                                                            ClientValidationFunction="Validate3DateOrderClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>--%>
                                                    </div>                                          
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                        meta:resourcekey="Dis_Date_of_Notification"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Notification"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Date_of_Notification"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatNotificationDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtdatNotificationDate"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Notification"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                        <%--  <asp:CustomValidator
                                                            ID="CustomValidatorDateOfNotification"
                                                            runat="server"
                                                            Text="Must be on or after Diagnosis Date. No future dates are allowed, inclusive, if present."
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="ValidateDateOfNotification"
                                                            ClientValidationFunction="ValidateDateOfNotificationClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>--%>
                                                    </div>   
                                                            
                                                    </div>
                                                </div>
                                      <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                        meta:resourcekey="Dis_Status_of_Patient"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Status_of_Patient"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Status_of_Patient"></label>
                                                        <eidss:DropDownList ID="ddlidfsFinalState" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsFinalState"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_Status_of_Patient"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                        <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                        meta:resourcekey="Dis_Notification_Sent_by"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Notification_Sent_by"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Notification_Sent_by"></label>
                                                        <div class="input-group">
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" OnClick="btnOpenPageFindFacitlityPersonSentBy_Click" />
                                                            </div>
                                                            <asp:TextBox ID="txtstrNotificationSentby" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtstrNotificationSentby"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Notification_Sent_by"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:CustomValidator
                                                            ID="CustomValidatorSentByReqIfDiagIsSyndromic"
                                                            runat="server"
                                                            meta:resourcekey="Val_Notification_Sent_by_Req_If_Syndomic"
                                                            Text="Required if the Disease is a Syndromic Surveillance condition."
                                                            ControlToValidate="txtstrNotificationSentby"
                                                            ValidationGroup="diseaseNotification"
                                                            OnServerValidate="ValidateSentByReqIfDiagIsSyndromic"
                                                            ClientValidationFunction="ValidateSentByReqIfDiagIsSyndromicClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            ValidateEmptyText="True"
                                                            EnableClientScript="True"></asp:CustomValidator>
                                                    </div>
                                                </div>
                                            </div>
                                       <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                        meta:resourcekey="Dis_Notification_Received_by"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Notification_Received_by"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Notification_Received_by"></label>
                                                        <div class="input-group">
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" OnClick="btnOpenPageFindFacitlityPersonReceivedBy_Click" />

                                                            </div>
                                                            <asp:TextBox ID="txtstrNotificationReceivedby" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtstrNotificationReceivedby"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Notification_Received_by"
                                                            runat="server"
                                                            ValidationGroup="diseaseNotification">
                                                        </asp:RequiredFieldValidator>
                                                    </div>

                                                </div>
                                            </div>
                                      <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Persons_Current_Location"
                                                        runat="server">
                                                        <label for="ddlidfsHospitalizationStatus" runat="server" meta:resourcekey="lbl_Persons_Current_Location"></label>
                                                        <eidss:DropDownList ID="ddlidfsHospitalizationStatus" runat="server" CssClass="form-control hStatus" autopostback="true" onchange="checkCurrentLocation();" />
                                                    </div>
                                                    <div id="hospital" runat="server" class="currentLocation hStatusHospital">
                                                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Hospital_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Hospital_Name" runat="server"></div>
                                                            <label for="ddlidfHospital" runat="server" meta:resourcekey="lbl_Hospital_Name"></label>
                                                            <eidss:DropDownList ID="ddlidfHospital" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="ddlidfHospital"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                InitialValue="null"
                                                                meta:resourcekey="Val_Hospital_Name"
                                                                runat="server"
                                                                ValidationGroup="diseaseNotification">
                                                            </asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div id="otherLocation" runat="server" class="currentLocation hStatusOtherLocation">
                                                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Other_Location"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Other_Location"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtstrCurrentLocation" runat="server" meta:resourcekey="lbl_Other_Location"></label>
                                                            <asp:TextBox ID="txtstrCurrentLocation" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrCurrentLocation"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Other_Location"
                                                                runat="server"
                                                                ValidationGroup="diseaseNotification">
                                                            </asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>                           
                                    </div>
                                </section>
                                <section id="symptoms" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Symptoms"></h4>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(1)" runat="server" meta:resourcekey="lbl_Clinical_Information_Symptoms_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Date_of_Symptom_Onset"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Symptom_Onset"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Date_of_Symptom_Onset"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatOnSetDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtdatOnSetDate"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Symptom_Onset"
                                                            runat="server"
                                                            ValidationGroup="symptoms"></asp:RequiredFieldValidator>
                                                        <asp:CustomValidator
                                                            ID="CustomValidateDateOfSymptoms"
                                                            runat="server"
                                                            Text="Must be before or same day as Date of Diagnosis. No future dates are allowed. Inclusive, if present."
                                                            ControlToValidate="txtdatDateOfDiagnosis"
                                                            ValidationGroup="symptoms"
                                                            OnServerValidate="ValidateDateOfSymptoms"
                                                            ClientValidationFunction="ValidateDateOfSymptomsClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>
                                                    </div>   
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Initial_Case_Classification"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Initial_Case_Classification"
                                                            runat="server">
                                                        </div>
                                                        <label runat="server" meta:resourcekey="lbl_Initial_Case_Classification"></label>
                                                        <eidss:DropDownList ID="ddlidfsInitialCaseStatus" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsInitialCaseStatus"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_Initial_Case_Classification"
                                                            runat="server"
                                                            ValidationGroup="symptoms"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="gvSymptoms" runat="server" meta:resourcekey="lbl_List_of_Symptoms"></label>
                                                <eidss:GridView
                                                    ID="gvSymptoms"
                                                    runat="server"
                                                    AllowPaging="true"
                                                    AllowSorting="true"
                                                    AutoGenerateColumns="false"
                                                    CaptionAlign="Top"
                                                    CssClass="table table-striped"
                                                    EmptyDataText="No data available."
                                                    ShowHeaderWhenEmpty="true"
                                                    ShowFooter="true"
                                                    GridLines="None">
                                                    <HeaderStyle CssClass="table-striped-header" />
                                                    <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                    <Columns>
                                                        <asp:BoundField DataField="idfSymptomName" ReadOnly="true" SortExpression="idfSymptomName" HeaderText="<%$ Resources:Grd_Symptoms_Column_Heading_idfSymptomName %>" />
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:Label
                                                                    ID="lblSgYes"
                                                                    meta:ResourceKey="Grd_Symptoms_Column_Heading_Checkbox_Yes"
                                                                    runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSgYes" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:Label
                                                                    ID="lblSgNo"
                                                                    meta:ResourceKey="Grd_Symptoms_Column_Heading_Checkbox_No"
                                                                    runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSgNo" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>

                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <asp:Label
                                                                    ID="lblSgUnknown"
                                                                    meta:ResourceKey="Grd_Symptoms_Column_Heading_Checkbox_Unknown"
                                                                    runat="server" />
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSgUnknown" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </eidss:GridView>
                                            </div>
                                            <div class="form-group"
                                                meta:resourcekey="Dis_Symptom_Comments"
                                                runat="server">
                                                <div class="glyphicon glyphicon-asterisk text-danger"
                                                    meta:resourcekey="Req_Symptom_Comments"
                                                    runat="server">
                                                </div>
                                                <label runat="server" meta:resourcekey="lbl_Comments"></label>
                                                <asp:TextBox ID="txtstrClinicalNotes" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                                <asp:RequiredFieldValidator
                                                    ControlToValidate="txtstrClinicalNotes"
                                                    CssClass="text-danger"
                                                    Display="Dynamic"
                                                    meta:resourcekey="Val_Comments"
                                                    runat="server"
                                                    ValidationGroup="symptoms"></asp:RequiredFieldValidator>
                                            </div>                                       
                                    </div>
                                </section>
                                <section id="facilityDetails" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Facility_Details"></h4>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(2)" runat="server" meta:resourcekey="lbl_Clinical_Information_Facility_Details_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div id="PatientPreviouslySoughtDiv" class="form-group">
                                                <div class="row">
                                                    <div id="PatientPreviouslySoughtRBPanel" class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_Patient_Previously_Sought">
                                                        <label for="" runat="server" meta:resourcekey="lbl_Patient_Previously_Sought"></label>
                                                        <div class="input-group">
                                                            <asp:RadioButtonList ID="rblidfsYNPreviouslySoughtCare" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" OnCheckedChanged="rdbPatientPreviouslySought_CheckChanged">
                                                            </asp:RadioButtonList>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlPatientPreviouslySought" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Date_First_Sought_Care"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_First_Sought_Care"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtdatFirstSoughtCareDate" runat="server" meta:resourcekey="lbl_Date_First_Sought_Care"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatFirstSoughtCareDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtdatFirstSoughtCareDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_First_Sought_Care"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                             <asp:CustomValidator
                                                                ID="CustomValidator_txtdatFirstSoughtCareDate"
                                                                runat="server"
                                                                Text="Must be after Symptom Onset, and before or equal to current date, if present, and not in the future."
                                                                ControlToValidate="txtdatFirstSoughtCareDate"
                                                                ValidationGroup="facilityDetails"
                                                                OnServerValidate="ValidateDoc"
                                                                ClientValidationFunction="ValidateDocClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"></asp:CustomValidator>
                                                        </div>
                                                        <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Facility_First_Sought_Care"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Facility_First_Sought_Care"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtFacilityFirstSoughtCare" runat="server" meta:resourcekey="lbl_Facility_First_Sought_Care"></label>
                                                            <div class="input-group">
                                                                <div class="input-group-addon">
                                                                    <span class="glyphicon glyphicon-search"></span>
                                                                </div>
                                                                <asp:TextBox ID="txtFacilityFirstSoughtCare" runat="server" CssClass="form-control"></asp:TextBox>
                                                            </div>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtFacilityFirstSoughtCare"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Facility_First_Sought_Care"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                        meta:resourcekey="Dis_NonNotifiable_Diagnosis"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_NonNotifiable_Diagnosis"
                                                            runat="server">
                                                        </div>
                                                        <label for="ddlidfsNonNotifiableDiagnosis" runat="server" meta:resourcekey="lbl_NonNotifiable_Diagnosis"></label>
                                                        <eidss:DropDownList ID="ddlidfsNonNotifiableDiagnosis" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsNonNotifiableDiagnosis"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_NonNotifiable_Diagnosis"
                                                            runat="server"
                                                            ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_Hospitalization">
                                                        <label runat="server" meta:resourcekey="lbl_Hospitalization"></label>
                                                        <div class="input-group">
                                                            <asp:RadioButtonList ID="rblidfsYNHospitalization" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" OnCheckedChanged="rblidfsYNHospitalization_CheckChanged">
                                                            </asp:RadioButtonList>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlHospitalization" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Date_of_Hospitalization"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Hospitalization"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtdatHospitalizationDate" runat="server" meta:resourcekey="lbl_Date_of_Hospitalization"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker"
                                                                ID="txtdatHospitalizationDate"
                                                                runat="server"
                                                                CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtdatHospitalizationDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Hospitalization"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>

                                                            <asp:CustomValidator
                                                                ID="CustomValidator_txtdatHospitalizationDate"
                                                                runat="server"
                                                                Text="Must be after Symptom Onset, and before or equal to current date, if present, and not in the future."
                                                                ControlToValidate="txtdatHospitalizationDate"
                                                                ValidationGroup="facilityDetails"
                                                                OnServerValidate="ValidateDoh"
                                                                ClientValidationFunction="ValidateDohClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"></asp:CustomValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Date_of_Discharge"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Discharge"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtdatDischargeDate" runat="server" meta:resourcekey="lbl_Date_of_Discharge"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtdatDischargeDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtdatDischargeDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Discharge"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails"></asp:RequiredFieldValidator>
                                                            <asp:CustomValidator
                                                                ID="CustomValidator_txtdatDischargeDate"
                                                                runat="server"
                                                                Text="Must be on or after Date of Hospitalization, if present, and not in the future."
                                                                ControlToValidate="txtdatDischargeDate"
                                                                ValidationGroup="facilityDetails"
                                                                OnServerValidate="ValidateDod"
                                                                ClientValidationFunction="ValidateDodClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"></asp:CustomValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                            meta:resourcekey="Dis_Facility_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Facility_Name"
                                                                runat="server">
                                                            </div>
                                                            <label for="ddlidfFaciltyHospital" runat="server" meta:resourcekey="lbl_Facility_Name"></label>
                                                            <eidss:DropDownList ID="ddlidfFaciltyHospital" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="ddlidfFaciltyHospital"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                InitialValue="null"
                                                                meta:resourcekey="Val_Facility_Name"
                                                                runat="server"
                                                                ValidationGroup="facilityDetails">
                                                            </asp:RequiredFieldValidator>
                                                        </div>                                                            
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>
                                <section id="antibioticVaccineHistory" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Antibiotics"></h4>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(3)" runat="server" meta:resourcekey="lbl_Clinical_Information_Antibiotics_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_Antibiotic_Antiviral_Therapy_Administered">
                                                        <label runat="server" meta:resourcekey="lbl_Antibiotic_Antiviral_Therapy_Administered"></label>
                                                        <div class="input-group">
                                                            <%--                                                            <div class="btn-group">
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredYes" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" OnCheckedChanged="rdbAntibioticAntiviralTherapyAdministered_CheckChanged" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredNo" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" OnCheckedChanged="rdbAntibioticAntiviralTherapyAdministered_CheckChanged" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredUnknown" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" OnCheckedChanged="rdbAntibioticAntiviralTherapyAdministered_CheckChanged" meta:resourcekey="lbl_Unknown" />
                                                            </div>--%>

                                                            <div class="btn-group">
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredYes" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredNo" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbAntibioticAntiviralTherapyAdministeredUnknown" runat="server" CssClass="radio-inline" GroupName="AntibioticAntiviralTherapyAdministered" AutoPostBack="true" meta:resourcekey="lbl_Unknown" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlAntiBioticAdministred" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Antibiotic_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Antibiotic_Name"
                                                                runat="server">
                                                            </div>
                                                            <label for="<%= txtstrAntibioticName.ClientID %>" runat="server" meta:resourcekey="lbl_Antibiotic_Name"></label>
                                                            <asp:TextBox ID="txtstrAntibioticName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrAntibioticName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Antibiotic_Name"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Dose"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Dose"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtstrDosage" runat="server" meta:resourcekey="lbl_Dose"></label>
                                                            <asp:TextBox ID="txtstrDosage" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrDosage"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Dose"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                                                            <label runat="server" meta:resourcekey="lbl_Unit_of_Measurement"></label>
                                                            <eidss:DropDownList ID="ddlidfsDoseMeasurements" runat="server" CssClass="form-control">
                                                                <asp:ListItem Value="null" Text=""></asp:ListItem>
                                                                <asp:ListItem Value="mg" Text="mg"></asp:ListItem>
                                                            </eidss:DropDownList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6"
                                                            meta:resourcekey="Dis_Date_Antibiotic_First_Administered"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_Antibiotic_First_Administered"
                                                                runat="server">
                                                            </div>
                                                            <label for="txdatFirstAdministeredDate" runat="server" meta:resourcekey="lbl_Date_Antibiotic_First_Administered"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txdatFirstAdministeredDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txdatFirstAdministeredDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_Antibiotic_First_Administered"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <hr />
                                                <div class="form-group"
                                                    meta:resourcekey="Dis_Antibiotic_Vaccine_History_Comments"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Antibiotic_Vaccine_History_Comments"
                                                        runat="server">
                                                    </div>
                                                    <label for="txtstrAntibioticComments" runat="server" meta:resourcekey="lbl_Antibiotic_Vaccine_History_Comments"></label>
                                                    <asp:TextBox ID="txtstrAntibioticComments" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrAntibioticComments"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Antibiotic_Vaccine_History_Comments"
                                                        runat="server"
                                                        ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <h4 runat="server" meta:resourcekey="hdg_Clinical_Information_Vaccines"></h4>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Specific_Vaccination">
                                                        <label runat="server" meta:resourcekey="lbl_Specific_Vaccination"></label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <%--  <asp:RadioButton ID="rdbSpecificVaccinationYes" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" OnCheckedChanged="rdbSpecificVaccination_CheckChanged" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationNo" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" OnCheckedChanged="rdbSpecificVaccination_CheckChanged" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationUnknown" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" OnCheckedChanged="rdbSpecificVaccination_CheckChanged" meta:resourcekey="lbl_Unknown" />--%>


                                                                <asp:RadioButton ID="rdbSpecificVaccinationYes" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationNo" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbSpecificVaccinationUnknown" runat="server" CssClass="radio-inline" GroupName="SpecificVaccination" AutoPostBack="true" meta:resourcekey="lbl_Unknown" />


                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlSpecialVaccination" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Vaccination_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Vaccination_Name"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtVaccinationName" runat="server" meta:resourcekey="lbl_Vaccination_Name"></label>
                                                            <asp:TextBox ID="txtVaccinationName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtVaccinationName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Vaccination_Name"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Date_of_Vaccination"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Vaccination"
                                                                runat="server">
                                                            </div>
                                                            <label for="txtVaccinationDate" runat="server" meta:resourcekey="lbl_Date_of_Vaccination"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtVaccinationDate" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtVaccinationDate"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Vaccination"
                                                                runat="server"
                                                                ValidationGroup="antibioticVaccineHistory"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>
                                <section id="samplesTab" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h4 runat="server" meta:resourcekey="hdg_Samples"></h4>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnSampleNewAdd" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Sample" OnClick="btnAddNewSampleClick" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(4)" runat="server" meta:resourcekey="lbl_Samples_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6" runat="server" meta:resourcekey="Dis_idfsYNSpecimenCollected">
                                                        <label for="rblidfsYNSpecimenCollected" runat="server" meta:resourcekey="lbl_idfsYNSpecimenCollected"></label>
                                                        <div class="input-group">
                                                            <asp:RadioButtonList ID="rblidfsYNSpecimenCollected" runat="server" CssClass="radio-inline formatRadioButtonList" RepeatDirection="Horizontal" AutoPostBack="true" OnCheckedChanged="rblidfsYNSpecimenCollected_CheckChanged">
                                                            </asp:RadioButtonList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <asp:Panel ID="samplesGridPanel" class="row embed-panel" runat="server" Visible="true">
                                                    <div class="panel-body">
                                                        <div class="table-responsive">
                                                            <asp:GridView
                                                                ID="gvSamples"
                                                                runat="server"
                                                                AllowPaging="true"
                                                                AllowSorting="true"
                                                                AutoGenerateColumns="false"
                                                                CaptionAlign="Top"
                                                                CssClass="table table-striped"
                                                                EmptyDataText="No data available."
                                                                ShowHeaderWhenEmpty="true"
                                                                DataKeyNames="idfMaterial, idfHumanCase, strBarcode, idfsSampleType, datFieldCollectionDate, strFieldBarcode, datFieldSentDate, idfSendToOffice, strSendToOffice, idfFieldCollectedByOffice, sampleGuid"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                <Columns>
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="datFieldCollectionDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Date_Collected.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="datFieldSentDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_Date.InnerText %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strSendToOffice" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sent_To.InnerText %>" />
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </div>
                                        </div>
                                    </div>

                                </section>
                                <section id="testsTab" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h4 runat="server" meta:resourcekey="hdg_Tests_Tab"></h4>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnHdrAddNewTest" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_New_Test" OnClick="btnAddNewTestClick" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(5)" runat="server" meta:resourcekey="lbl_Tests_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
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
                                                                DataKeyNames="idfMaterial, idfHumanCase, idfsSampleType, idfsTestName, idfsTestCategory, idfsTestResult, idfsTestStatus, idfsDiagnosis, idfTestedByOffice, datReceivedDate, datConcludedDate, idfTestedByPerson, strBarcode, testGuid, sampleGuid, strFieldBarCode, strSampleTypeName, idfsInterpretedStatus, strValidatedBy, strInterpretedBy"
                                                                ShowFooter="true"
                                                                GridLines="None">
                                                                <HeaderStyle CssClass="table-striped-header" />
                                                                <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" /> 
                                                               
                                                                <Columns>
                                                                    <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                                    <asp:BoundField DataField="strFieldBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Local_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strBarcode" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Lab_Sample_ID.InnerText %>" />
                                                                    <asp:BoundField DataField="strSampleTypeName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Samples_Sample_Type.InnerText %>" />
                                                                    <asp:BoundField DataField="name" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Name %>" />
                                                                    <asp:BoundField DataField="strTestResult" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Result.InnerText %>" />
                                                                    <asp:BoundField DataField="datReceivedDate" ReadOnly="true" HeaderText="<%$ Resources:lbl_Tests_Date_Received %>" DataFormatString="{0:d}" />
                                                                    <asp:BoundField DataField="strInterpretedStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_InterpretedStatus_RulesInOut.InnerText %>" />
                                                                    <asp:BoundField DataField="blnValidateStatus" ReadOnly="true" HeaderText="<%$ Resources:lbl_Test_Validated.InnerText %>" />                                                                     
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="caseDetails" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Details"></h4>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(5)" runat="server" meta:resourcekey="lbl_Case_Details_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"
                                                        meta:resourcekey="Dis_Investigator_Name_Organization"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="Req_Investigator_Name_Organization" runat="server"></div>
                                                        <label for="" runat="server" meta:resourcekey="lbl_Investigator_Name_Organization"></label>
                                                        <div class="input-group">
                                                            <div class="input-group-addon">
                                                                <span class="glyphicon glyphicon-search"></span>
                                                            </div>
                                                            <asp:TextBox ID="txtInvestigationNameOrganization" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtInvestigationNameOrganization"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Investigator_Name_Organization"
                                                            runat="server"
                                                            ValidationGroup="caseDetails"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Start_Date_of_Investigation"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Start_Date_of_Investigation"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtStartDateofInvestigation" runat="server" meta:resourcekey="lbl_Start_Date_of_Investigation"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtStartDateofInvestigation" runat="server" CssClass="input-group datepicker"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtStartDateofInvestigation"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Start_Date_of_Investigation"
                                                            runat="server"
                                                            ValidationGroup="caseDetails"></asp:RequiredFieldValidator>
                                                        <asp:CustomValidator
                                                                ID="CustomValidator_txtStartDateofInvestigation"
                                                                runat="server"
                                                                Text="Must be after Notification date, and before or equal to current date, if present, and not in the future."
                                                                ControlToValidate="txtStartDateofInvestigation"
                                                                ValidationGroup="caseDetails"
                                                                OnServerValidate="ValidateDoi"
                                                                ClientValidationFunction="ValidateDoiClient"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                EnableClientScript="True"
                                                                Autopostback="true"></asp:CustomValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    
                                                    <asp:Panel ID="pnlOutbreakID" CssClass="col-lg-4 col-md-6 col-sm-6 col-xs-12"
                                                        runat="server" Visible="true">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Outbreak_ID"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtCaseInvestigationOutbreakID" runat="server" meta:resourcekey="lbl_Outbreak_ID"></label>
                                                        <div class="input-group">
                                                            <div class="input-group-addon">
                                                                <span class="glyphicon glyphicon-search"></span>
                                                            </div>
                                                            <asp:TextBox ID="txtCaseInvestigationOutbreakID" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtCaseInvestigationOutbreakID"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Outbreak_ID"
                                                            runat="server"
                                                            ValidationGroup="samples"></asp:RequiredFieldValidator>
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                            <hr />
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        runat="server"
                                                        meta:resourcekey="Dis_Location_of_Exposure_Known">
                                                        <label for=""
                                                            runat="server"
                                                            meta:resourcekey="lbl_Location_of_Exposure_Known">
                                                        </label>
                                                        <div class="input-group">
                                                            <div class="btn-group">
                                                                <%--                                                                <asp:RadioButton ID="rdbLocationofExposureKnownYes" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" AutoPostBack="true" OnCheckedChanged="rdbLocationofExposureKnown_CheckChanged" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbLocationofExposureKnownNo" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" AutoPostBack="true" OnCheckedChanged="rdbLocationofExposureKnown_CheckChanged" meta:resourcekey="lbl_No" />--%>

                                                                <asp:RadioButton ID="rdbLocationofExposureKnownYes" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" autopostback="true" meta:resourcekey="lbl_Yes" />
                                                                <asp:RadioButton ID="rdbLocationofExposureKnownNo" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" autopostback="true" meta:resourcekey="lbl_No" />
                                                                <asp:RadioButton ID="rdbLocationofExposureUnKnown" runat="server" CssClass="radio-inline" GroupName="LocationofExposureKnown" autopostback="true" meta:resourcekey="lbl_Unknown" />  

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlLocationofExposureKnown" runat="server" Visible="false">
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                            meta:resourcekey="Dis_Date_of_Potential_Exposure"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Date_of_Potential_Exposure"
                                                                runat="server">
                                                            </div>
                                                            <label for="" runat="server" meta:resourcekey="lbl_Date_of_Potential_Exposure"></label>
                                                            <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtDateofPotentialExposure" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtDateofPotentialExposure"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Date_of_Potential_Exposure"
                                                                runat="server"
                                                                ValidationGroup="samples"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12"
                                                            runat="server"
                                                            meta:resourcekey="Dis_Exposure_Address_Type">
                                                            <label for="<%=  hdfExposureAddressType.ClientID %>"
                                                                runat="server"
                                                                meta:resourcekey="lbl_Exposure_Address_Type">
                                                            </label>
                                                            <div class="input-group">
                                                                <asp:RadioButton ID="rdbExposureAddressTypeExact" runat="server" CssClass="radio-inline" GroupName="ExposureAddressType" AutoPostBack="true" OnCheckedChanged="rdbExposureAddressType_CheckChanged" meta:resourcekey="lbl_Exact" />
                                                                <asp:RadioButton ID="rdbExposureAddressTypeRelative" runat="server" CssClass="radio-inline" GroupName="ExposureAddressType" AutoPostBack="true" OnCheckedChanged="rdbExposureAddressType_CheckChanged" meta:resourcekey="lbl_Relative" />
                                                                <asp:RadioButton ID="rdbExposureAddressTypeForeign" runat="server" CssClass="radio-inline" GroupName="ExposureAddressType" AutoPostBack="true" OnCheckedChanged="rdbExposureAddressType_CheckChanged" meta:resourcekey="lbl_Foreign" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>                                               
                                                <div class="form-group">
                                                    <div class="row">
                                                        <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12"
                                                            meta:resourcekey="Dis_Exposure_Location_Description"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Exposure_Location_Description"
                                                                runat="server">
                                                            </div>
                                                            <label for="" runat="server" meta:resourcekey="lbl_Exposure_Location_Description"></label>
                                                            <asp:TextBox ID="txtExposureLocationDescription" runat="server" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtExposureLocationDescription"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Exposure_Location_Description"
                                                                runat="server"
                                                                ValidationGroup="samples"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>                                                
                                                 <div class="form-group">
                                                    <div id="lucExposure_country_required" class="glyphicon glyphicon-certificate text-danger" runat="server" visible="false"></div>
                                                    <eidss:LocationUserControl
                                                        ID="lucExposure"
                                                        IsHorizontalLayout="true"
                                                        runat="server"
                                                        ShowCountry="True"
                                                        ShowElevation="false" 
                                                        ShowPostalCode="false" ShowBuildingHouseApartmentGroup="false" ShowApartment="false" ShowBuilding="false" ShowHouse="false" ShowMap="false"/>

                                                </div>
                                                 <div id="foreignAddressType" class="form-group" runat="server" meta:resourcekey="dis_Foreign_Address_Type" visible="false">
                                                        <div class="glyphicon glyphicon-asterisk text-danger" meta:resourcekey="req_Foreign_Address_Type" runat="server"></div>
                                                        <label runat="server" id="lbl_Address" meta:resourcekey="lbl_Address"></label>
                                                        <asp:TextBox ID="txtForeignAddressType" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtForeignAddressType" Display="Dynamic" meta:resourceKey="val_Foreign_Address_Type"></asp:RequiredFieldValidator>
                                                 </div>
                                                 <div id="relativeAddressType" runat="server" meta:resourcekey="dis_Ground_Type" visible="false">
                                                    <div class="form-group">
                                                        <div class="row">
                                                                <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">                                                                   
                                                                    <label runat="server" meta:resourcekey="lbl_Groud_Type"></label>
                                                                    <asp:DropDownList ID="ddlGroundType" runat="server" CssClass="form-control"></asp:DropDownList>
                                                                </div>
                                                            </div>
                                                        <div class="row">
                                                            <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Distance">
                                                                <label runat="server" meta:resourcekey="lbl_Distance"></label>
                                                                <eidss:NumericSpinner ID="txtDistance" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </div>
                                                            <div class="col-lg-2 col-md-2 col-sm-4 col-xs-6" meta:resourcekey="dis_Direction">
                                                                <label runat="server" meta:resourcekey="lbl_Direction"></label>
                                                                <eidss:NumericSpinner ID="txtDirection" runat="server" CssClass="form-control"></eidss:NumericSpinner>
                                                            </div>
                                                        </div>
                                                    </div>
                                                 </div>
                                                       
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </section>
                                <section id="riskFactors" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Risk_Factors"></h4>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(6)" runat="server" meta:resourcekey="lbl_Risk_Factors_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <label for="hdfRiskFactor" runat="server" meta:resourcekey="lbl_List_of_Risks"></label>
                                                <asp:GridView ID="gvRisk" runat="server" AllowPaging="false" AllowSorting="false" AutoGenerateColumns="false">
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <div class="row">
                                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                                        <label runat="server" meta:resourcekey="lbl_Symptom"></label>
                                                                    </div>
                                                                </div>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                                    <asp:Label ID="lblSymptom" runat="server"></asp:Label>
                                                                </div>
                                                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <div class="row">
                                                                    <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                                        <label runat="server" meta:resourcekey="lbl_YesNoUnknown"></label>
                                                                    </div>
                                                                </div>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <!-- display check boxes -->
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:CheckBoxList runat="server" ID="cblRisks">
                                                                    <asp:ListItem Value="ck1" />
                                                                    <asp:ListItem Value="ck2" />
                                                                    <asp:ListItem Value="ck3" />
                                                                </asp:CheckBoxList>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <section id="contactList" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-7">
                                                    <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Contact_List"></h4>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-5 text-right">
                                                    <asp:Button ID="btnAddContact" runat="server" CssClass="btn btn-default btn-sm" meta:resourcekey="btn_Add_Contact" OnClick="btnOpenPageFindPerson_Click" />
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(7)" runat="server" meta:resourcekey="lbl_Contact_List_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-right">
                                                    <%--<input type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact" data-toggle="modal" data-target="#modalAddContact" />--%>
                                                    <%--  <asp:Button ID="btnAddContact" CssClass="btn btn-primary"  runat="server" meta:resourceKey="btn_Add_Contact" data-toggle="modal" data-target="#modalAddContact" />--%>
                                                    <%--    <input type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact"  />--%>
                                                    <%--                                                    <button type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Add_Contact" onclick="addContact();"></button>--%>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:Panel ID="PanelContactsGrid" class="row embed-panel" runat="server">

                                            <div class="panel-body">
                                                <div class="table-responsive">
                                                    <asp:GridView
                                                        ID="gvContacts"
                                                        runat="server"
                                                        AllowPaging="true"
                                                        AllowSorting="true"
                                                        AutoGenerateColumns="false"
                                                        CaptionAlign="Top"
                                                        CssClass="table table-striped"
                                                        EmptyDataText="No data available."
                                                        ShowHeaderWhenEmpty="true"
                                                        DataKeyNames="idfHumanCase, strFirstName, strSecondName, strLastName, idfsPersonContactType, datDateOfBirth, idfsHumanGender, idfCitizenship, datDateOfLastContact, strPlaceInfo, idfsCountry, idfsRegion"
                                                        ShowFooter="true"
                                                        GridLines="None">
                                                        <HeaderStyle CssClass="table-striped-header" />
                                                        <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />

                                                        <Columns>
                                                            <asp:CommandField SelectText="" ControlStyle-CssClass="btn glyphicon glyphicon-edit" ShowSelectButton="true" />
                                                            <asp:BoundField DataField="strContactPersonFullName" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Full_Name %>" />
                                                            <asp:BoundField DataField="strPersonContactType" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Person_Contact_Type %>" />
                                                            <asp:BoundField DataField="datDateOfLastContact" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Date_Of_Last_Contact %>" DataFormatString="{0:d}" />
                                                            <asp:BoundField DataField="strPlaceInfo" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Place_Info %>" />
                                                            <asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" />
                                                            <%--<asp:BoundField DataField="strComments" ReadOnly="true" HeaderText="<%$ Resources:lbl_Contacts_Comments %>" DataFormatString="{0:d}" />--%>
                                                        </Columns>
                                                    </asp:GridView>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </section>
                                <section id="finalOutcome" runat="server" class="col-md-12 hidden">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                                    <h4 runat="server" meta:resourcekey="hdg_Case_Investigation_Final_Outcome"></h4>
                                                </div>
                                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-right">
                                                    <a href="#" class="btn glyphicon glyphicon-edit hidden" onclick="goToTab(8)" runat="server" meta:resourcekey="lbl_Final_Outcome_Tab"></a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Final_Case_Classification"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Final_Case_Classification"
                                                            runat="server">
                                                        </div>
                                                        <label for="ddlidfsFinalCaseStatus" runat="server" meta:resourcekey="lbl_Final_Case_Classification"></label>
                                                        <eidss:DropDownList ID="ddlidfsFinalCaseStatus" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlidfsFinalCaseStatus"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_Final_Case_Classification"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Date_of_Classification"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Classification"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtDateofClassification" runat="server" meta:resourcekey="lbl_Date_of_Classification"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtDateofClassification" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtDateofClassification"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Classification"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <asp:CustomValidator
                                                            ID="CustomValidatorDateOfClassification"
                                                            runat="server"
                                                            Text="Must be the same or after Result Date. If no Result Date, then after Date of Diagnosis. No future dates allowed, inclusive, if present."
                                                            ControlToValidate="txtDateofClassification"
                                                            ValidationGroup="finalOutcome"
                                                            OnServerValidate="ValidatorDateOfClassification"
                                                            ClientValidationFunction="ValidatorDateOfClassificationClient"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"></asp:CustomValidator>
                                                    </div>   
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Outcome"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Outcome"
                                                            runat="server">
                                                        </div>
                                                        <label for="ddlOutcome" runat="server" meta:resourcekey="lbl_Outcome" ></label>                                                       

                                                        <eidss:DropDownList ID="ddlOutcome" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlOutcome_SelectedIndexChanged">
                                                            <asp:ListItem Value="null" Text=""></asp:ListItem>
                                                            <asp:ListItem Value="recovered" Text="Recovered"></asp:ListItem>
                                                            <asp:ListItem Value="died" Text="Died"></asp:ListItem>
                                                            <asp:ListItem Value="unknown" Text="Unknown"></asp:ListItem>
                                                        </eidss:DropDownList>

                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="ddlOutcome"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            InitialValue="null"
                                                            meta:resourcekey="Val_Outcome"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <asp:Panel ID="pnlOutcomeDateofDeath" runat="server" CssClass="form-group" Visible="false">
                                                <div class="row">
                                                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"
                                                        meta:resourcekey="Dis_Date_of_Death"
                                                        runat="server">
                                                        <div class="glyphicon glyphicon-asterisk text-danger"
                                                            meta:resourcekey="Req_Date_of_Death"
                                                            runat="server">
                                                        </div>
                                                        <label for="txtDateofDeath" runat="server" meta:resourcekey="lbl_Date_of_Death"></label>
                                                        <eidss:CalendarInput ContainerCssClass="input-group datepicker" ID="txtDateofDeath" runat="server" CssClass="form-control"></eidss:CalendarInput>
                                                        <asp:RequiredFieldValidator
                                                            ControlToValidate="txtDateofDeath"
                                                            CssClass="text-danger"
                                                            Display="Dynamic"
                                                            meta:resourcekey="Val_Date_of_Death"
                                                            runat="server"
                                                            ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                            <div class="form-horizontal">
                                                <label for="cblBasisofDiagnosis" runat="server" meta:resourcekey="lbl_Basis_of_Diagnosis" ></label> 
	                                        <fieldset class="form-group">		                                                 
		                                        <div class="checkbox checkboxlist col-sm-9">
			                                        <asp:CheckBoxList ID="cblBasisofDiagnosis" runat="server" RepeatDirection="Vertical" RepeatLayout="Flow">
                                                            <asp:ListItem Value="clinical" Text="Clinical"></asp:ListItem>
                                                            <asp:ListItem Value="epidemiologicalLinks" Text="Epidemiological Links"></asp:ListItem>
                                                            <asp:ListItem Value="laboratoryTests" Text="Laboratory Tests"></asp:ListItem>
                                                        </asp:CheckBoxList>  
		                                        </div>
	                                        </fieldset>
                                         </div>
                                        </div>
                                    </div>
                                </section>
                                
                            </div>
                            <eidss:SideBarNavigation ID="sideBarPanel" runat="server">
                                <MenuItems>
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="0" ID="sidebaritem_notification" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Disease_Notification" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="1" ID="sidebaritem_symptoms" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Symptoms" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="2" ID="sidebaritem_FacilityDetails" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Facility_Details" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="3" ID="sidebaritemAnti_Vaccine_History" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Antibiotic_Vaccine_History" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="4" ID="sidebaritem_Samples" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Samples" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="5" ID="sidebaritem_Tests" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Tests" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="6" ID="sidebaritem_CaseDetails" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Case_Investigation" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="7" ID="sidebaritem_RiskFactors" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Risk_Factors" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="8" ID="sidebaritem_ContactList" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Contact_List" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="9" ID="sidebaritem_FinalOutcome" IsActive="true" ItemStatus="IsNormal" meta:resourcekey="tab_Final_Outcome" runat="server" />
                                    <eidss:SideBarItem CssClass="glyphicon glyphicon-ok" GoToTab="10" ID="sidebaritem_Review" IsActive="true" ItemStatus="IsReview" meta:resourcekey="tab_Review" runat="server" />
                                </MenuItems>
                            </eidss:SideBarNavigation>
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-center">
                                    <asp:Button ID="btn_Return_to_Person_Record" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Cancel" OnClick="btn_Return_to_Person_Record_Click" />
                                    <asp:Button ID="btnReturnToSearch" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Cancel" OnClick="btnReturnToSearch_Click" />
                                    <asp:Button ID="btnReturnToReportSearch" runat="server" CssClass="btn btn-default" meta:resourcekey="btn_Cancel" OnClick="btnReturnToReportSearch_Click" />
                                    <input type="button" id="btnPreviousSection" runat="server" meta:resourcekey="btn_Back" class="btn btn-default" onclick="goBackToPreviousPanel(); return false;" />
                                    <input type="button" id="btnNextSection" runat="server" meta:resourcekey="btn_Continue" class="btn btn-default" onclick="goForwardToNextPanel(); return false;" />
                                    <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" meta:resourcekey="btn_Submit_Disease" OnClick="btn_Submit_Disease_Report_Click" AutoPostBack="True" data-toggle="modal"/>
                                </div>
                            </div>
                            </div>
                            <%-- End: Human Disease Report --%>
                        </div>
                        <asp:HiddenField runat="server" Value="0" ID="hdnPanelController" />
                        <asp:HiddenField runat="server" ID="hdfIsDiagnosisSyndromic" Value="0" />

                        <div class="modal" id="errorVSS" runat="server" role="dialog">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                                <span class="glyphicon glyphicon-remove-circle modal-icon"></span>
                                            </div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                                <p id="lblErr" runat="server"></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer text-center">
                                        <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK"></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                         <div class="modal" id="successVSS" runat="server" role="dialog">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                         <h4 class="modal-title" runat="server" meta:resourcekey="hdg_Human_Disease_Report"></h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                                <span class="glyphicon glyphicon-remove-circle modal-icon"></span>
                                            </div>
                                            <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                               <p id="lblSuccessSave" runat="server"></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer text-center">
                                        <button ID="btnSuccessSave" runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" ></button>
                                    </div>
                                </div>
                            </div>
                        </div>                         

                        <%--Modals--%>
                        <div class="modal" id="modalAddSample" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="modalAddFieldTestLabel">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h5 class="modal-title" id="H1" runat="server" meta:resourcekey="hdg_Sample_Detail_Modal"></h5>
                                    </div>
                                    <div id="ModalAddSampleForm" runat="server" class="modal-body">

                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                    
                                                     <asp:CheckBox ID="chkblnFilterSampleTestNameByDisease" runat="server" meta:resourcekey="lbl_Test_Filter_Test_Name_By_Disease" checked="true" CssClass="checkbox-inline" />                                              
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" visible="false">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Lab_Sample_ID"></label>
                                                    <asp:TextBox ID="mastxtSampleId" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                    <%--<asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddlAddFieldTestFieldSampleID_SelectedIndexChanged"></asp:DropDownList>--%>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Sample_Type"></label>
                                                    <eidss:DropDownList runat="server" ID="masddlSampleType" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Date_Collected"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="masAddSampleDateCollected" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Local_Sample_ID"></label>
                                                    <asp:TextBox ID="masAddSampleLocalSampleId" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                   
                                                    <label runat="server" meta:resourcekey="lbl_Sample_by_Institution"></label>
                                                        <div class="input-group">
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" OnClick="btnOpenPageFindCollectedInstitution_Click" Enabled="false"/>
                                                            </div>
                                                            <asp:TextBox ID="txtstrCollectedByInstitution" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                   <label runat="server" meta:resourcekey="lbl_Sample_by"></label>
                                                        <div class="input-group">
                                                            <div class="input-group-addon">
                                                                <asp:ImageButton runat="server" ImageUrl="../Includes/Images/glyphicons-search2.png" CssClass="glyphicon glyphicon-search" OnClick="btnOpenPageFindCollectedPerson_Click" Enabled="false"/>
                                                            </div>
                                                            <asp:TextBox ID="txtstrCollectedByOfficer" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                        </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Date_Sent"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="masAddSampleDateSent" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Modal_Add_Sample_Sent_To"></label>
                                                    <%--<asp:TextBox ID="masAddSampleSentTo" runat="server" CssClass="form-control"></asp:TextBox>--%>
                                                    <%--ddlTestedByInstitution--%>

                                                    <eidss:DropDownList ID="ddlmasAddSampleSentTo" runat="server" AutoPostBack="true" CssClass="form-control"></eidss:DropDownList>

                                                </div>
                                            </div>
                                        </div>
                                   <div class="form-group">
                                    <div class="row">
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label runat="server" meta:resourcekey="lbl_Accession_Date"></label>
                                            <div class="input-group dates">
                                                <eidss:CalendarInput ID="txtAddSampleAccessionDate" runat="server" ContainerCssClass="input-group datepicker" Enabled="False" CssClass="form-control"></eidss:CalendarInput>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                            <label runat="server" meta:resourcekey="lbl_Sample_Condition_Received"></label>
                                            <asp:TextBox ID="txtstrCondition" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                   </div>
                                  </div>
                                    <div class="modal-footer">
                                        <button id="btnMasAddSampleClose" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="btn_Modal_Add_Sample_Close"></button>
                                        <asp:Button ID="btnMasAddSampleSave" runat="server" Text="Save" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Sample_Save" />
                                        <asp:Button ID="btnMasAddSampleDelete" runat="server" Text="Delete" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Sample_Delete" />
                                    </div>
                                </div>
                            </div>
                        </div>                       
                        <div class="modal" id="modalAddFieldTest" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="modalAddFieldTestLabel">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h5 class="modal-title" id="modalAddFieldTestLabel" runat="server" meta:resourcekey="hdg_Field_Test"></h5>
                                    </div>
                                    <div id="addFieldTestForm" runat="server" class="modal-body">   
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                    
                                                     <asp:CheckBox ID="chkblnFilterTestNameByDisease" runat="server" meta:resourcekey="lbl_Test_Filter_Test_Name_By_Disease" checked="true" CssClass="checkbox-inline" />                                              
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Local_Sample_ID"></label>
                                                    <eidss:DropDownList ID="ddlmatLocalSampleId" runat="server" CssClass="form-control">
                                                    </eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Diagnosis"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestDiagnosis" runat="server" AutoPostBack="true" CssClass="form-control"></eidss:DropDownList>
                                                </div>                                                                                       
                                            </div>
                                        </div>
                                         <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Sample_Type"></label>
                                                     <asp:TextBox runat="server" ID="txtidfsSampleType" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Lab_Sample_ID"></label>
                                                     <asp:TextBox ID="txtstrBarCode" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>     
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Name"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestName" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Category"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestCategory" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" visible="false">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Status" visible="false"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestStatus" runat="server" AutoPostBack="true" CssClass="form-control" visible="false"></eidss:DropDownList>
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Status" ></label>
                                                     <asp:TextBox ID="txtstrSampleTestStatus" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                                                </div>     
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                 <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Result"></label>
                                                    <eidss:DropDownList ID="ddlSampleTestResult" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Result_Date"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="txtAddFieldTestResultDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group" visible="false">
                                            <div class="row" visible="false">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Tested_by_Institution" visible="false"></label>
                                                    <eidss:DropDownList ID="ddlAddFieldTestTestedByInstitution" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Tested_by" visible="false"></label>
                                                    <eidss:DropDownList ID="ddlAddFieldTestTestedBy" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Result_Received_Date"></label>
                                                    <div class="input-group dates">
                                                        <eidss:CalendarInput ID="datAddFieldTestResultReceived" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_InterpretedStatus_RulesInOut"></label>
                                                    <eidss:DropDownList ID="ddlidfsInterpretedStatus" runat="server" CssClass="form-control">
                                                         <asp:ListItem Text=""></asp:ListItem>
                                                         <asp:ListItem Value=10104001 Text="Rule In"></asp:ListItem>
                                                         <asp:ListItem value=10104002 Text="Rule Out"></asp:ListItem>
                                                    </eidss:DropDownList>                                                    
                                                </div>    
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Interpreted_RulesInOutComments"></label>
                                                    <asp:TextBox ID="txtstrInterpretedComment" runat="server" CssClass="form-control" ></asp:TextBox>
                                                </div>           
                                            </div>
                                        </div>                                  
                                   <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Date_Interpreted"></label>
                                                    <eidss:CalendarInput ID="txtdatInterpretedDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                                </div>
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Interpreted_By"></label>
                                                    <asp:TextBox ID="txtstrInterpretedBy" runat="server" CssClass="form-control" enable="false" ></asp:TextBox>
                                                </div>   
                                            </div>
                                    </div>
                                   <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">                                                    
                                                     <asp:CheckBox ID="chkblnValidateStatus" runat="server" meta:resourcekey="lbl_Test_Validated" CssClass="checkbox-inline" />                                              
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_ValidatedComments"></label>
                                                    <asp:TextBox ID="txtstrValidateComment" runat="server" CssClass="form-control"  ></asp:TextBox>
                                                </div>   
                                            </div>
                                     </div>                                    
                                    <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Date_Validated"></label>
                                                    <eidss:CalendarInput ID="txtdatValidationDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" Enabled="false"></eidss:CalendarInput>
                                                </div> 
                                                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                    <label runat="server" meta:resourcekey="lbl_Test_Validated_By"></label>
                                                    <asp:TextBox ID="txtstrValidatedBy" runat="server" CssClass="form-control" enable="false"></asp:TextBox>
                                                </div>   
                                            </div>   
                                   </div>
                                    <div class="modal-footer">
                                        <button id="btnModalAddTestClose" class="btn btn-default" data-dismiss="modal" runat="server" meta:resourcekey="btn_Modal_Add_Test_Close"></button>
                                        <asp:Button ID="btnModalAddTestSave" runat="server" Text="Save" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Test_Save" />
                                        <asp:Button ID="btnModalAddTestDelete" runat="server" Text="Delete" CssClass="btn btn-default" meta:resourcekey="btn_Modal_Add_Test_Delete" />
                                    </div>
                                </div>
                            </div>
                        </div>                       
               </div>            
                        <div class="modal fade" id="modalAddContact" data-backdrop="static" tabindex="-1" role="dialog">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h5 class="modal-title" runat="server" meta:resourcekey="hdg_Contact_Information"></h5>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                                                    <div class="row">
                                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                            meta:resourcekey="Dis_Contact_Information_First_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Contact_Information_First_Name"
                                                                runat="server">
                                                            </div>
                                                            <asp:Label AssociatedControlID="txtstrContactFirstName"
                                                                meta:resourcekey="Lbl_Contact_Information_First_Name"
                                                                runat="server"></asp:Label>
                                                            <asp:TextBox ID="txtstrContactFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrContactFirstName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Contact_Information_First_Name"
                                                                runat="server"
                                                                ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-12"
                                                            meta:resourcekey="Dis_Contact_Information_Middle_Initial"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Contact_Information_Middle_Initial"
                                                                runat="server">
                                                            </div>
                                                            <asp:Label AssociatedControlID="txtstrContactMiddleInit"
                                                                meta:resourcekey="Lbl_Contact_Information_Middle_Initial"
                                                                runat="server"></asp:Label>
                                                            <asp:TextBox ID="txtstrContactMiddleInit" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrContactMiddleInit"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Contact_Information_Middle_Initial"
                                                                runat="server"
                                                                ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12"
                                                            meta:resourcekey="Dis_Contact_Information_Last_Name"
                                                            runat="server">
                                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                                meta:resourcekey="Req_Contact_Information_Last_Name"
                                                                runat="server">
                                                            </div>
                                                            <asp:Label AssociatedControlID="txtstrContactLastName"
                                                                meta:resourcekey="Lbl_Contact_Information_Last_Name"
                                                                runat="server"></asp:Label>
                                                            <asp:TextBox ID="txtstrContactLastName" runat="server" CssClass="form-control"></asp:TextBox>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtstrContactLastName"
                                                                CssClass="text-danger"
                                                                Display="Dynamic"
                                                                meta:resourcekey="Val_Contact_Information_Last_Name"
                                                                runat="server"
                                                                ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Relation"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Relation"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="ddlContactRelation"
                                                        meta:resourcekey="Lbl_Contact_Information_Relation"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList ID="ddlContactRelation" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlContactRelation"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Relation"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Date_Of_Birth"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Date_Of_Birth"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="txtdatContactDoB"
                                                        meta:resourcekey="Lbl_Contact_Information_Date_Of_Birth"
                                                        runat="server"></asp:Label>
                                                    <eidss:CalendarInput ID="txtdatContactDoB" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtdatContactDoB"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Contact_Information_Date_Of_Birth"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Gender"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Gender"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="ddlContactGender"
                                                        meta:resourcekey="Lbl_Contact_Information_Gender"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList ID="ddlContactGender" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlContactGender"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Gender"
                                                        runat="server"
                                                        ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Citizenship"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Citizenship"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="ddlContactCitizenship"
                                                        meta:resourcekey="Lbl_Contact_Information_Citizenship"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList ID="ddlContactCitizenship" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlContactCitizenship"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Citizenship"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <asp:Label AssociatedControlID="hdfstrContactPhone"
                                                meta:resourcekey="Lbl_Contact_Information_Employer_Phone"
                                                runat="server"></asp:Label>
                                            <div class="row">
                                                <div class="col-lg-6 col-md-6 col-sm-8 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Country_Code_And_Number"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Country_Code_And_Number"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="txtstrContactCountryCodeandNumber"
                                                        meta:resourcekey="Lbl_Contact_Information_Country_Code_And_Number"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox ID="txtstrContactCountryCodeandNumber" runat="server" CssClass="form-control"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtstrContactCountryCodeandNumber"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        meta:resourcekey="Val_Contact_Information_Country_Code_And_Number"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Phone_Type"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Phone_Type"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label AssociatedControlID="ddlidfContactPhoneType"
                                                        meta:resourcekey="Lbl_Contact_Information_Phone_Type"
                                                        runat="server"></asp:Label>
                                                    <eidss:DropDownList ID="ddlidfContactPhoneType" runat="server" CssClass="form-control"></eidss:DropDownList>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="ddlidfContactPhoneType"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Phone_Type"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group"
                                            meta:resourcekey="Dis_Contact_Information_Current_Address"
                                            runat="server">
                                            <div class="glyphicon glyphicon-asterisk text-danger"
                                                meta:resourcekey="Req_Contact_Information_Current_Address"
                                                runat="server">
                                            </div>
                                            <asp:Label
                                                meta:resourcekey="Lbl_Contact_Information_Current_Address"
                                                runat="server"></asp:Label>
                                            <div class="input-group" meta:resourcekey="Dis_Contact_Information_Foreign_Address"
                                                runat="server">
                                                <div class="btn-group">
                                                    <div class="checkbox-inline">
                                                        <input id="foreignContactAddress" type="checkbox" value="ContactForeignAddress" onchange="contactForeign();" />
                                                        <label runat="server" meta:resourcekey="Lbl_Contact_Information_Foreign_Address"></label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <eidss:LocationUserControl
                                                ID="locationContact"
                                                IsHorizontalLayout="true"
                                                runat="server"
                                                ShowCountry="false"
                                                ShowCoordinates="false"
                                                OnLoad="ContactLocationControl_Load" />
                                        </div>
                                        <hr />
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Date_of_Last_Contact"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Date_of_Last_Contact"
                                                        runat="server">
                                                    </div>
                                                    <label for="txtdatLastContactDate" runat="server" meta:resourcekey="Lbl_Contact_Information_Date_of_Last_Contact"></label>
                                                    <eidss:CalendarInput ID="txtdatLastContactDate" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control"></eidss:CalendarInput>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtdatLastContactDate"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Date_of_Last_Contact"
                                                        runat="server"
                                                        ValidationGroup="addContact"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12"
                                                    meta:resourcekey="Dis_Contact_Information_Place_of_Last_Contact"
                                                    runat="server">
                                                    <div class="glyphicon glyphicon-asterisk text-danger"
                                                        meta:resourcekey="Req_Contact_Information_Place_of_Last_Contact"
                                                        runat="server">
                                                    </div>
                                                    <asp:Label
                                                        AssociatedControlID="txtPlaceofLastContact"
                                                        meta:resourcekey="Lbl_Contact_Information_Place_of_Last_Contact"
                                                        runat="server"></asp:Label>
                                                    <asp:TextBox ID="txtPlaceofLastContact" runat="server" CssClass="form-control"></asp:TextBox>
                                                    <asp:RequiredFieldValidator
                                                        ControlToValidate="txtPlaceofLastContact"
                                                        CssClass="text-danger"
                                                        Display="Dynamic"
                                                        InitialValue="null"
                                                        meta:resourcekey="Val_Contact_Information_Place_of_Last_Contact"
                                                        runat="server"
                                                        ValidationGroup="finalOutcome"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer text-center">
                                        <button type="button" class="btn btn-primary" runat="server" meta:resourcekey="btn_Contact_Modal_Save" onclick="addContact();"></button>
                                        &nbsp;
                                                <button type="button" class="btn btn-default" runat="server" meta:resourcekey="btn_Cancel" data-dismiss="modal"></button>
                                    </div>
                                </div>
                            </div>                      
                        </div>
                        <script type="text/javascript">
                            $(document).ready(function () {
                                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                               var diseasedHumanDetailSection = document.getElementById("<%= diseasedHumanDetail.ClientID %>");
                                 if (diseasedHumanDetailSection != null || diseasedHumanDetailSection != undefined) {
                                    setViewOnPageLoad("<%= hdnPanelController.ClientID %>");
                                }
                                $('.modal').modal({ show: false, backdrop: 'static' });
                                $('#<%= errorVSS.ClientID %>').modal({ show: false, backdrop: 'static' });
                                $('#<%= successVSS.ClientID %>').modal({ show: false, backdrop: 'static' });


                                //displayDiseaseSuccessPopUp();
                                checkCurrentLocation();
                                $(".samplesDetailRow").hide();

                                //rodney want to drag the modals around the page:
                                $("#modalAddFieldTest").draggable({
                                    handle: ".modal-header"
                                });

                                sidePanels();
                                modalize();
                            });

                            function callBackHandler() {
                                var diseasedHumanDetailSection = document.getElementById("<%= diseasedHumanDetail.ClientID %>");
                                 if (diseasedHumanDetailSection != null || diseasedHumanDetailSection != undefined) {
                                    setViewOnPageLoad("<%= hdnPanelController.ClientID %>");
                                }
                                checkCurrentLocation();
                                //displayDiseaseSuccessPopUp();
                                $(".samplesDetailRow").hide();

                                //(document.getElementById('#Radios1')).diabled = true;
                                $('#<%= errorVSS.ClientID %>').modal({ show: false, backdrop: 'static' });
                                $('#<%= successVSS.ClientID %>').modal({ show: false, backdrop: 'static' });

                                sidePanels();
                                modalize();
                            };

                            function checkCurrentLocation() {
                                var el = $(".hStatus");
                                if (el[0].value === "5360000000")  //other location
                                {
                                    //show other location
                                    $(".hStatusHospital").hide();
                                    $(".hStatusOtherLocation").show();
                                }
                                else if (el[0].value === "5350000000") {   //hospital
                                    //show hospital
                                    $(".hStatusHospital").show();
                                    $(".hStatusOtherLocation").hide();
                                }
                                else {
                                    //set both invisible: home was chosen 
                                    $(".hStatusHospital").hide();
                                    $(".hStatusOtherLocation").hide();
                                }
                            };

                            function modalize() {
                             $('.modal').modal({ show: false, backdrop: 'static', keyboard: false });
                            }

                            function sidePanels(){
                                var sessionInformation = document.getElementById("<% = disease.ClientID %>");

                                if (sessionInformation != undefined) {
                                    setViewOnPageLoad("<% = hdnPanelController.ClientID %>");
                                    $('#<%= btnNextSection.ClientID %>, #<%= btnPreviousSection.ClientID %>').click( function(){ headerTitle(); }); 
                                    $('.sidepanel ul li').click( function(){ headerTitle(); });
                                }
                            }


                            function ValidateNotFutureDateClient(sender, args) {
                                var isValidDate = true;  
                                var d1 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;

                                if (IsDate(d1)) {
                                    isValidDate = new Date(d1) <= new Date();
                                }

                            args.IsValid = isValidDate;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };

                            function ValidateNotFutureNotificationDateClient(sender, args) {
                                var isValidDate = true;  
                                var d1 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;

                                if (IsDate(d1)) {
                                    isValidDate = new Date(d1) <= new Date();
                                }

                            args.IsValid = isValidDate;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };

                            function ValidateNotFutureSymptomOnsetDateClient(sender, args) {
                                var isValidDate = true;  
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;

                                if (IsDate(d1)) {
                                    isValidDate = new Date(d1) <= new Date();
                                }

                            args.IsValid = isValidDate;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };
                             
                            function Validate3DateOrderClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;
                                var d3 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;

                              <%--   if (IsDate(d1) && IsDate(d2) && (!(IsDate(d3)))) {
                                    isValidOrder = new Date(d1) <= new Date(d2);
                                }
                                else if (!IsDate(d1) && IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = new Date(d2) <= new Date(d3);
                                }
                                else if (IsDate(d1) && !IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = new Date(d1) <= new Date(d3);
                                }
                                else if (IsDate(d1) && IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= new Date(d3));
                                }--%>

                                if (IsDate(d1) && IsDate(d2) && IsDate(d3)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= new Date(d3));
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };
                            
                             function ValidateDateOfNotificationClient(sender, args) {
                                var isValidOrder = true;  //'if none of the two set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;
                                                             
                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) >= new Date(d2)  && new Date(d1) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };

                            function ValidatorDateOfClassificationClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtDateofClassification.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtAddFieldTestResultDate.ClientID %>")).value;
                                var d3 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;
                                                             
                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) >= new Date(d2) && new Date(d1) <= Date.now());
                                }
                                else if (!IsDate(d2) && IsDate(d1) && IsDate(d3)) {
                                    isValidOrder = (new Date(d1) > new Date(d3) && new Date(d1) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };                                                        

                            function ValidateDateOfSymptomsClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatDateOfDiagnosis.ClientID %>")).value;
                                                             
                                if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)  && new Date(d1) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };                                                            

                            function IsDate(str) {
                                return ((str.length > 0) && (Object.prototype.toString.call(new Date(str)) === "[object Date]"));
                            };

                            function ValidateSentByReqIfDiagIsSyndromicClient(sender, args) {
                                if ((document.getElementById("<%= hdfIsDiagnosisSyndromic.ClientID %>")) != null
                                    && (document.getElementById("<%= hdfIsDiagnosisSyndromic.ClientID %>")).value == 1) {
                                    if (document.getElementById("EIDSSBodyCPH_txtstrNotificationSentby").value.length > 0) {
                                        args.IsValid = true;
                                    } else {
                                        args.IsValid = false;
                                    }
                                } else {
                                    args.IsValid = true;
                                }
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 0;
                            };
                            function ValidateDocClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatFirstSoughtCareDate.ClientID %>")).value;

                                if (IsDate(d1) && !IsDate(d2)) {
                                    isValidOrder = true;
                                }
                                else if (!IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = new Date(d2) <= Date.now();
                                }
                                else if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) < new Date(d2)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 2;
                            };

                             function ValidateDoiClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatNotificationDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtStartDateofInvestigation.ClientID %>")).value;

                                if (IsDate(d1) && !IsDate(d2)) {
                                    isValidOrder = true;
                                }
                                else if (!IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = new Date(d2) <= Date.now();
                                }
                                else if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) > new Date(d2)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 6;
                            };

                            function ValidateDohClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatOnSetDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatHospitalizationDate.ClientID %>")).value;

                                if (IsDate(d1) && !IsDate(d2)) {
                                    isValidOrder = true;
                                }
                                else if (!IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = new Date(d2) <= Date.now();
                                }
                                else if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 2;
                            };

                            function ValidateDodClient(sender, args) {
                                var isValidOrder = true;  //'if none of the three are set to dates, return "isValid = true" condition
                                var d1 = (document.getElementById("<%= txtdatHospitalizationDate.ClientID %>")).value;
                                var d2 = (document.getElementById("<%= txtdatDischargeDate.ClientID %>")).value;

                                if (IsDate(d1) && !IsDate(d2)) {
                                    isValidOrder = true;
                                }
                                else if (!IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = new Date(d2) <= Date.now();
                                }
                                else if (IsDate(d1) && IsDate(d2)) {
                                    isValidOrder = (new Date(d1) <= new Date(d2)) && (new Date(d2) <= Date.now());
                                }
                                args.IsValid = isValidOrder;
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 2;
                            };

                            function showSamplesSubGrid(e, f) {
                                var cl = e.target.className;
                                if (cl == 'glyphicon glyphicon-plus-sign') {
                                    e.target.className = "glyphicon glyphicon-minus-sign";
                                    $('#' + f).show();
                                }
                                else {
                                    e.target.className = "glyphicon glyphicon-plus-sign";
                                    $('#' + f).hide();
                                }
                            };

                            function openModalSampleTab() {
                                $('#modalAddSample').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 4;
                            };

                            function openModalTestTab() {
                                $('#modalAddFieldTest').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;
                            };

                            function continueWithModalTestTab() {
                                $('#modalAddFieldTest').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                $('#modalAddFieldTest').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;
                            };

                            function continueWithModalSampleTab() {
                                $('#modalAddSample').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                $('#modalAddSample').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 4;
                            };


                            //show modal for modalAddContact
                            function openModalContactEdit() {
                                $('#modalAddContact').modal('show');
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 8;
                            };

                            function closeModalAddSample() {
                                $('#modalAddSample').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 4;
                            };

                            function closeModalAddTest() {
                                $('#modalAddTest').modal('hide');
                                $('body').removeClass('modal-open');
                                $('.modal-backdrop').remove();
                                (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;
                            };

                            <%--                    function continueModalAddTest() {
                        $('#modalAddTest').modal('hide');
                        $('body').removeClass('modal-open');
                        $('.modal-backdrop').remove();
                        (document.getElementById("<%= hdnPanelController.ClientID %>")).value = 5;    
                    };--%>
                        </script>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
