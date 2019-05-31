<%@ Page Title="Search Disease Reports" Language="vb" AutoEventWireup="false" MasterPageFile="~/NormalView.Master" CodeBehind="SearchDiseaseReports.aspx.vb" Inherits="EIDSS.SearchDiseaseReports" meta:resourcekey="PageResource1" %>

<%@ Register Src="~/Controls/LocationUserControl.ascx" TagPrefix="eidss" TagName="LocationUserControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="EIDSSHeadCPH" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="EIDSSBodyCPH" runat="server">

    <asp:UpdateProgress runat="server">
    </asp:UpdateProgress>    
    <asp:UpdatePanel ID="uppPersonSearch" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional" >
     <%--   <Triggers>
            <asp:PostBackTrigger ControlID="gvDisease" />
        </Triggers>--%>
       
        <ContentTemplate>
            <div id="divHiddenFieldsSection" runat="server" class="row embed-panel">
                <asp:HiddenField runat="server" ID="hdfLangID" Value="EN" />
                <asp:HiddenField runat="server" ID="hdfidfHumanActual" Value="null" />
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
                <asp:HiddenField runat="server" ID="hdfidfHumanCase"/>
                <asp:HiddenField runat="server" ID="hdfstrHumanCaseId" />
                <asp:HiddenField runat="server" ID="hdfidfHuman" Value="null" />
                <asp:HiddenField runat="server" ID="hdfPatientPreviouslySought" />
                <asp:HiddenField runat="server" ID="hdfidfSougtCareFacility" />
                <asp:HiddenField runat="server" ID="hdfhospitalization" />
                <asp:HiddenField runat="server" ID="hdfYNAntimicrobialTherapy" />
                <asp:HiddenField runat="server" ID="hdfidfsYNSpecificVaccinationAdministered" />
                <asp:HiddenField runat="server" ID="hdfRelatedToOutbreak" />
                <asp:HiddenField runat="server" ID="hdfLocationofExposureKnown" />
                <asp:HiddenField runat="server" ID="hdfExposureAddressType" />
                <asp:HiddenField runat="server" ID="hdfRiskFactor" />
                <asp:HiddenField runat="server" ID="hdfDeleteSessionFromSearchResults" />
                 <asp:HiddenField runat="server" ID="hfAccordionIndex" />
            </div>
            <div class="panel panel-default" style="padding-bottom:50px;">
                <div class="panel-heading">
                    <h2 runat="server" meta:resourcekey="Hdg_Disease_Reports" ></h2>
                </div>
                <div id="instructionTextSelectARow" class="row col-lg-12 col-md-12 col-sm-12 col-xs-12" runat="server">
                    <p><%= GetLocalResourceObject("Instruction_Text_SelectARow") %></p>
                </div>
                <div class="panel-body">
                    <div class="modal" id="searchCancelModal" role="dialog">
                    <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Disease_Reports" ></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="Lbl_Cancel_Search" ></p>
                                        </div>
                                    </div>
                                </di
                                <div class="modal-footer text-center">
                                    <asp:Button ID="CancelModelSearchBtn" runat="server" CssClass="btn btn-primary" OnClick="CancelModelSearchBtn_Click" meta:resourcekey="Btn_Yes" />
                                 <%--   <a runat="server" class="btn btn-primary" href="../Human/SearchDiseaseReports.aspx" meta:resourcekey="Btn_Yes"   ></a>--%>
                                    <input type="button" runat="server" class="btn btn-default" data-dismiss="modal" meta:resourcekey="Btn_No" />
                                &nbsp;</div>
                            </div>
                        </div>
                    </div>
                    <div class="modal" id="deleteHDR" runat="server" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Disease_Reports" ></h4>
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                            <span class="glyphicon glyphicon-alert modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p runat="server" meta:resourcekey="lbl_Remove_HDR" ></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer text-center">
                                    <button type="submit" id="btnDeleteHDR" runat="server" class="btn btn-primary" meta:resourcekey="btn_Yes" data-dismiss="modal" ></button>
                                    <button type="button" runat="server" class="btn btn-default" meta:resourcekey="btn_No" data-dismiss="modal" ></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="errorVSS" class="modal" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Disease_Reports" ></h4>
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
                                    <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" ></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="successVSS" class="modal" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" runat="server" meta:resourcekey="Hdg_Disease_Reports" ></h4>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-2">
                                            <span class="glyphicon glyphicon-remove-circle modal-icon"></span>
                                        </div>
                                        <div class="col-lg-11 col-md-11 col-sm-11 col-xs-10">
                                            <p id="lblSuccess" runat="server"></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer text-center">
                                    <button runat="server" class="btn btn-primary" data-dismiss="modal" meta:resourcekey="btn_OK" ></button>
                                </div>
                            </div>
                        </div>
                    </div>


                    <br />

                                            
                        
                        
                          <div class="panel-group" id="accordion">


                              <div class="panel">
                                        <div class="panel-heading">
                                            <div class="row" style="border-bottom:solid;border-bottom-width:1px; border-bottom-color:#cccccc;">
                                                <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                    <h3 id="hdgSearchCriteria" class="" runat="server" meta:resourcekey="hdg_SearchCriteria" onclick="ToggleSearch(1);"></h3>
                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                    <span id="Span2" role="button" runat="server"  class="glyphicon glyphicon-triangle-bottom header-button" onclick="ToggleSearch(1);"></span>
                                                </div>
                                               
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div id="collapseOne" class="panel-collapse collapse in">
                                                <div class="panel-body">
                                                    <!-- Default Search -->


                                                    <div id="searchCriteria" class="panel-collapse collapse in" runat="server">
                                                        <div class="panel-body">
                                                            <div id="searchForm" runat="server">
                                                                <div id="instructionTextUseTheFollowing" class="row col-lg-12 col-md-12 col-sm-12 col-xs-12" runat="server">
                                                                    <p><%= GetLocalResourceObject("Instruction_Text_UseThefollowing") %></p>
                                                                </div>
                                                                <div class="form-group">
                                                                    <div class="row">
                                                                        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Eidss_ID">
                                                                            <label runat="server" for="txtSearchStrCaseId" meta:resourcekey="Lbl_Search_Eidss_ID"></label>
                                                                            <asp:TextBox ID="txtSearchStrCaseId" runat="server" CssClass="form-control" meta:resourcekey="txtSearchStrCaseIdResource1"></asp:TextBox>
                                                                        </div>
                                                                        <div class="row">

                                                                            <div id="divSearchLegacyCaseID" class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Eidss_Legacy_ID">
                                                                                <label runat="server" for="txtSearchLegacyCaseID" meta:resourcekey="Lbl_Search_Eidss_Legacy_ID"></label>
                                                                                <asp:TextBox ID="txtSearchLegacyCaseID" runat="server" CssClass="form-control" meta:resourcekey="txtSearchLegacyCaseIDResource1"></asp:TextBox>
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
                                                                            <label for="ddlSearchDiagnosis" runat="server" class="control-label" meta:resourcekey="SearchLbl_Disease_Diagnosis"></label>
                                                                            <asp:DropDownList ID="ddlSearchDiagnosis" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchDiagnosisResource1">
                                                                                <asp:ListItem meta:resourcekey="ListItemResource1"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                        <div runat="server" meta:resourcekey="Dis_Disease_Report_Report_Status" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                                            <label for="ddlSearchReportStatus" runat="server" class="control-label" meta:resourcekey="SearchLbl_Disease_Report_Status"></label>
                                                                            <asp:DropDownList ID="ddlSearchReportStatus" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchReportStatusResource1">
                                                                                <asp:ListItem meta:resourcekey="ListItemResource2"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group">
                                                                    <div class="row">
                                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Name">
                                                                            <label runat="server" for="txtSearchStrPersonFirstName" meta:resourcekey="Lbl_Search_First_Name"></label>
                                                                            <asp:TextBox ID="txtSearchStrPersonFirstName" runat="server" CssClass="form-control" meta:resourcekey="txtSearchStrPersonFirstNameResource1"></asp:TextBox>
                                                                        </div>
                                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Name">
                                                                            <label runat="server" for="txtSearchStrPersonMiddleName" meta:resourcekey="Lbl_Search_Middle_Name"></label>
                                                                            <asp:TextBox ID="txtSearchStrPersonMiddleName" runat="server" CssClass="form-control" meta:resourcekey="txtSearchStrPersonMiddleNameResource1"></asp:TextBox>
                                                                        </div>
                                                                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12" runat="server" meta:resourcekey="Dis_Search_Name">
                                                                            <label runat="server" for="txtSearchStrPersonLastName" meta:resourcekey="Lbl_Search_Last_Name"></label>
                                                                            <asp:TextBox ID="txtSearchStrPersonLastName" runat="server" CssClass="form-control" meta:resourcekey="txtSearchStrPersonLastNameResource1"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group">

                                                                    <div class="row">
                                                                        <div runat="server" meta:resourcekey="Dis_Disease_Report_Case_Classification" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                                            <asp:Label for="RegionDD" runat="server" meta:resourcekey="RegionDD"></asp:Label>
                                                                            <asp:DropDownList ID="RegionDD" runat="server" CssClass="form-control" AppendDataBoundItems="True" meta:resourcekey="RegionDDResource1">
                                                                                <asp:ListItem></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                        <div runat="server" meta:resourcekey="Dis_Disease_Report_Hospitaliztion" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                                            <asp:Label for="RayonDD" runat="server" meta:resourcekey="RayonDD"></asp:Label>
                                                                            <asp:DropDownList ID="RayonDD" runat="server" CssClass="form-control" AppendDataBoundItems="True" meta:resourcekey="RayonDDResource1">
                                                                                <asp:ListItem></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </div>
                                                                    </div>




                                                                </div>
                                                                <fieldset>
                                                                    <legend runat="server" meta:resourcekey="Searchlbl_DateEnteredRange"></legend>
                                                                    <div class="form-group">
                                                                        <div class="row">
                                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_DateEntered_From">
                                                                                <label for="txtSearchHDRDateEnteredFrom" runat="server" meta:resourcekey="Searchlbl_DateEntered_From"></label>
                                                                                <eidss:CalendarInput ID="txtSearchHDRDateEnteredFrom" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="txtSearchHDRDateEnteredFromResource1" />
                                                                            </div>
                                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server" meta:resourcekey="dis_DateEntered_To">
                                                                                <label for="txtSearchHDRDateEnteredTo" runat="server" meta:resourcekey="Searchlbl_DateEntered_To"></label>
                                                                                <eidss:CalendarInput ID="txtSearchHDRDateEnteredTo" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="txtSearchHDRDateEnteredToResource1" />
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </fieldset>
                                                                <div class="form-group">
                                                                    <div class="row">
                                                                        <div runat="server" meta:resourcekey="Dis_Disease_Report_Case_Classification" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                                            <label for="ddlSearchCaseClassification" runat="server" meta:resourcekey="Lbl_Disease_Report_Case_Classification" class="control-label"></label>
                                                                            <asp:DropDownList ID="ddlSearchCaseClassification" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchCaseClassificationResource1"></asp:DropDownList>
                                                                        </div>
                                                                        <div runat="server" meta:resourcekey="Dis_Disease_Report_Hospitaliztion" class="col-lg-6 col-md-6 col-sm-12 col-xs-12" visible="False">
                                                                            <label for="ddlSearchIdfsHospitalizationStatus" runat="server" meta:resourcekey="lbl_Hospitalization" class="control-label"></label>
                                                                            <asp:DropDownList ID="ddlSearchIdfsHospitalizationStatus" runat="server" CssClass="form-control" meta:resourcekey="ddlSearchIdfsHospitalizationStatusResource1" />
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>






                              <div class="panel">
                                        <div class="panel-heading">
                                            <div class="row" style="border-bottom:solid;border-bottom-width:1px;border-bottom-color:#cccccc;">
                                                <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                    <h3 id="h1" class="" runat="server" meta:resourcekey="hdg_AdvSearch"></h3>

                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                    <span id="Span1" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" onclick="ToggleSearch(2)"></span>
                                               
                                                </div>
                                               
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div id="collapseTwo" class="panel-collapse collapse">
                                                <div class="panel-body">

                                                    <!--Advance Search -->
                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Case_Classification" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                                <asp:Label for="SentByFacilityDD" runat="server" class="control-label" Text="Sent By Facility" meta:resourcekey="LabelResource3"></asp:Label>
                                                                <asp:DropDownList ID="SentByFacilityDD" runat="server" CssClass="form-control" AppendDataBoundItems="True" meta:resourcekey="SentByFacilityDDResource1">
                                                                    <asp:ListItem></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Hospitaliztion" class="col-lg-6 col-md-6 col-sm-12 col-xs-12" visible="False">
                                                                <asp:Label for="RecievedByFacilityDD" runat="server" class="control-label" Text="Recieved By Facility" meta:resourcekey="LabelResource4"></asp:Label>
                                                                <asp:DropDownList ID="RecievedByFacilityDD" runat="server" CssClass="form-control" AppendDataBoundItems="True" meta:resourcekey="RecievedByFacilityDDResource1">
                                                                    <asp:ListItem></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server">
                                                                <asp:Label for="txtSearchHDRDateEnteredFrom" runat="server" Text="Diagnosis Date From" meta:resourcekey="LabelResource5"></asp:Label>
                                                                <eidss:CalendarInput ID="DiagnosisDateFromTxt" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="DiagnosisDateFromTxtResource1" />
                                                            </div>
                                                            <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" runat="server">
                                                                <asp:Label for="txtSearchHDRDateEnteredTo" runat="server" Text="Diagnosis Date To" meta:resourcekey="LabelResource6"></asp:Label>
                                                                <eidss:CalendarInput ID="DiagnosisDateToTxt" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="DiagnosisDateToTxtResource1" />
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <div class="row">

                                                            <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server">
                                                                <asp:Label runat="server" for="LocalSampleIdTxt" Text="Local Sample Id" meta:resourcekey="LabelResource7"></asp:Label>
                                                                <asp:TextBox ID="LocalSampleIdTxt" runat="server" CssClass="form-control" meta:resourcekey="LocalSampleIdTxtResource1"></asp:TextBox>
                                                            </div>
                                                            <div class="row">

                                                                <div id="div1" class="col-lg-6 col-md-6 col-sm-12 col-xs-12" runat="server">
                                                                    <asp:Label runat="server" for="txtSearchLegacyCaseID" Text="Data Entry Site" meta:resourcekey="LabelResource8"></asp:Label>
                                                                    <asp:TextBox ID="DataEntrySiteTxt" runat="server" CssClass="form-control" meta:resourcekey="DataEntrySiteTxtResource1"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server">
                                                                <asp:Label for="DateOfSymptomsOnsetTxt" runat="server" Text="Date Of Symptoms Onset" meta:resourcekey="LabelResource9"></asp:Label>
                                                                <eidss:CalendarInput ID="DateOfSymptomsOnsetTxt" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="DateOfSymptomsOnsetTxtResource1" />
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server">
                                                                <asp:Label for="NotificationDateTxt" runat="server" Text="Notification Date" meta:resourcekey="LabelResource10"></asp:Label>
                                                                <eidss:CalendarInput ID="NotificationDateTxt" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="NotificationDateTxtResource1" />
                                                            </div>
                                                            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" runat="server">
                                                                <asp:Label for="DateOfFinalCaseClassificationTxt" runat="server" Text="Date Of Final Case Classification" meta:resourcekey="LabelResource11"></asp:Label>
                                                                <eidss:CalendarInput ID="DateOfFinalCaseClassificationTxt" runat="server" ContainerCssClass="input-group datepicker" CssClass="form-control" meta:resourcekey="DateOfFinalCaseClassificationTxtResource1" />
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <div class="row">
                                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Case_Classification" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                                <asp:Label for="LocationOfExposureRegionDD" runat="server" class="control-label" Text="Location Of Exposure Region" meta:resourcekey="LabelResource12"></asp:Label>
                                                                <asp:DropDownList ID="LocationOfExposureRegionDD" runat="server" CssClass="form-control" AppendDataBoundItems="True" meta:resourcekey="LocationOfExposureRegionDDResource1">
                                                                    <asp:ListItem></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div runat="server" meta:resourcekey="Dis_Disease_Report_Hospitaliztion" class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                                                                <asp:Label for="LocationOfExposureRayonDD" runat="server" class="control-label" Text="Location Of Exposure Rayon" meta:resourcekey="LabelResource13"></asp:Label>
                                                                <asp:DropDownList ID="LocationOfExposureRayonDD" runat="server" CssClass="form-control" AppendDataBoundItems="True" meta:resourcekey="LocationOfExposureRayonDDResource1">
                                                                    <asp:ListItem></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>

                              


                              <div class="panel">
                                  <div class="panel-heading">
                                      <div class="row" style="border-bottom: solid; border-bottom-width: 1px; border-bottom-color: #cccccc;">
                                          <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                              <h3 id="h2" class="" runat="server" meta:resourcekey="hdg_SearchResults"></h3>

                                          </div>
                                          <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                              <span id="Span3" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" onclick="ToggleSearch(3)"></span>

                                          </div>

                                      </div>
                                  </div>
                                  <div class="panel-body">
                                      <div id="collapseThree" class="panel-collapse ">
                                          <div class="panel-body">
                                              <asp:UpdatePanel ID="gridUpdatePanel" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional" >
                                                  <Triggers>

                                                      <asp:AsyncPostBackTrigger ControlID="gvDisease" />
                                                  </Triggers>
                                                  <ContentTemplate>
                                                      <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

                                                          <asp:View ID="SearchFieldsPnl" runat="server">
                                                          </asp:View>


                                                          <asp:View ID="SearchResultsPnl" runat="server">
                                                              <div class="panel panel-default">
                                                                  <div class="panel-body">
                                                                      <div class="panel-heading">
                                                                          <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10">
                                                                          </div>
                                                                          <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-right">
                                                                              <span id="btnShowSearchCriteria" runat="server" role="button" class="glyphicon glyphicon-triangle-bottom header-button" onclick="ToggleSearch(3)" meta:resourcekey="btn_Show_Search_Criteria"></span>
                                                                          </div>
                                                                      </div>
                                                                      <div id="searchResults" class="row embed-panel" runat="server">
                                                                          <div class="panel panel-default">
                                                                              <%--           
                                                               <div class="panel-heading">
                                                                          <div class="row">
                                                                              <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                                                  <h3 id="hdrSearchResults" class="heading" runat="server" meta:resourcekey="Hdg_Search_Results"></h3>
                                                                              </div>
                                                                          </div>
                                                                      </div>
                                                                              --%>
                                                                              <div class="panel-body">
                                                                                  <p id="pDiseasePageText" runat="server"><%= GetLocalResourceObject("Page_Text_2") %></p>



                                                                                  <div class="table-responsive">
                                                                                      <eidss:GridView
                                                                                          ID="gvDisease"
                                                                                          runat="server"
                                                                                          AllowPaging="True"
                                                                                          AllowSorting="True"
                                                                                          AutoGenerateColumns="False"
                                                                                          CaptionAlign="Top"
                                                                                          CssClass="table table-striped"
                                                                                          EmptyDataText="<%$ Resources:Labels, Lbl_No_Results_Found_Text %>"
                                                                                          ShowHeaderWhenEmpty="True"
                                                                                          DataKeyNames="HumanDiseaseReportID,PatientID,HumanMasterID"
                                                                                          ShowFooter="True"
                                                                                          GridLines="None">
                                                                                          <HeaderStyle CssClass="table-striped-header" />
                                                                                          <PagerStyle CssClass="table-striped-pager" HorizontalAlign="Right" />
                                                                                          <Columns>
                                                                                              <asp:TemplateField HeaderText="<%$ Resources:Grd_Disease_strCaseId %>" SortExpression="EIDSSReportID">
                                                                                                  <ItemTemplate>
                                                                                                      <asp:LinkButton ID="btnSelect" runat="server" Text='<%# Eval("Report_ID") %>' CausesValidation="False" CommandName="select"
                                                                                                          CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourcekey="btnSelectResource1"></asp:LinkButton>
                                                                                                  </ItemTemplate>
                                                                                              </asp:TemplateField>
                                                                                              <asp:TemplateField HeaderText="<%$ Resources:Grd_Disease_LegacyID %>" SortExpression="LegacyCaseID">
                                                                                                  <ItemTemplate>
                                                                                                      <asp:Label ID="lblLegacyCaseID" runat="server" Text='<%# Eval("LegacyCaseID") %>' Visible="False" meta:resourcekey="lblLegacyCaseIDResource1"></asp:Label>
                                                                                                  </ItemTemplate>
                                                                                              </asp:TemplateField>
                                                                                              <asp:TemplateField HeaderText="<%$ Resources:Grd_Disease_Name_Heading %>" SortExpression="PatientName">
                                                                                                  <ItemTemplate>
                                                                                                      <asp:LinkButton ID="btnSelectPerson" runat="server" Text='<%# Eval("Persons_Name") %>' CausesValidation="False" CommandName="selectPerson"
                                                                                                          CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>' meta:resourcekey="btnSelectPersonResource1"></asp:LinkButton>
                                                                                                  </ItemTemplate>
                                                                                              </asp:TemplateField>
                                                                                              <asp:BoundField DataField="Date_Entered" ReadOnly="True" SortExpression="EnteredDate" DataFormatString="{0:d}" HeaderText="<%$ Resources:Grd_Disease_Date_Entered_Heading %>" />
                                                                                              <asp:BoundField DataField="Disease" ReadOnly="True" SortExpression="DiseaseName" HeaderText="<%$ Resources:Grd_Disease_Clinical_Diagnosis_Heading %>" />
                                                                                              <asp:BoundField DataField="Report_Status" ReadOnly="True" SortExpression="Report_Status" HeaderText="<%$ Resources:Grd_Disease_CaseProgressStatus %>" />
                                                                                              <asp:BoundField DataField="Location" SortExpression="PatientLocation" ReadOnly="True" HeaderText="<%$ Resources:Grd_Disease_Location %>" />
                                                                                              <asp:BoundField DataField="Case_Classification" SortExpression="Case_Classification" ReadOnly="True" HeaderText="<%$ Resources:Grd_Disease_Classification_Heading %>" />
                                                                                              <asp:TemplateField ShowHeader="False">
                                                                                                  <ItemTemplate>
                                                                                                      <asp:LinkButton ID="btnEdit" runat="server" CausesValidation="False" CommandName="edit" meta:resourceKey="btn_Edit_Human_Disease_Report"
                                                                                                          CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                                                                                                  </ItemTemplate>
                                                                                                  <ItemStyle CssClass="icon" />
                                                                                              </asp:TemplateField>
                                                                                              <asp:TemplateField ShowHeader="False">
                                                                                                  <ItemTemplate>
                                                                                                      <asp:LinkButton ID="btnDelete" Visible="False" Enabled="False" runat="server" CausesValidation="False" CommandName="delete" meta:resourceKey="btn_Delete_Human_Disease_Report"
                                                                                                          CommandArgument='<%# CType(Container, GridViewRow).RowIndex %>'><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                                                                  </ItemTemplate>
                                                                                                  <ItemStyle CssClass="icon" />
                                                                                              </asp:TemplateField>
                                                                                              <asp:TemplateField meta:resourcekey="TemplateFieldResource6">
                                                                                                  <ItemTemplate>
                                                                                                      <span class="glyphicon glyphicon-triangle-bottom" onclick="showSubGrid(event,'div<%# Eval("HumanDiseaseReportID") %>');"></span>
                                                                                                      <tr id="div<%# Eval("HumanDiseaseReportID") %>" style="display: none;">
                                                                                                          <td colspan="10" style="border-top: 0 none transparent;">

                                                                                                              <div class="row" style="background-color: aliceblue">


                                                                                                                  <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                                                                                      <label class="table-striped-header" runat="server" meta:resourcekey="Person_ID"></label>
                                                                                                                      <br />
                                                                                                                      <asp:Label ID="Label1" runat="server" Text='<%# Bind("Person_ID") %>' Enabled="False" meta:resourcekey="Label1Resource1"></asp:Label>
                                                                                                                  </div>



                                                                                                                  <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
                                                                                                                      <label class="table-striped-header" runat="server" meta:resourcekey="Entered_By_Organization"></label>
                                                                                                                      <br />
                                                                                                                      <asp:Label ID="txtstrEnteredByOrg" runat="server" Text='<%# Bind("Entered_By_Organization") %>' Enabled="False" meta:resourcekey="txtstrEnteredByOrgResource1"></asp:Label>
                                                                                                                  </div>
                                                                                                                  <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                                                                                      <label class="table-striped-header" runat="server" meta:resourcekey="Entered_By_Name"></label>
                                                                                                                      <br />
                                                                                                                      <asp:Label ID="txtstrPersonEnteredByName" runat="server" Text='<%# Bind("Entered_By_Name") %>' Enabled="False" meta:resourcekey="txtstrPersonEnteredByNameResource1"></asp:Label>
                                                                                                                  </div>

                                                                                                                  <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                                                                                      <label class="table-striped-header" runat="server" meta:resourcekey="Report_Type"></label>
                                                                                                                      <br />
                                                                                                                      <asp:Label ID="txtstrPersonName" runat="server" Text='<%# Bind("Report_Type") %>' Enabled="False" meta:resourcekey="txtstrPersonNameResource1"></asp:Label>
                                                                                                                  </div>

                                                                                                                  <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                                                                                                      <label class="table-striped-header" runat="server" meta:resourcekey="Hospitalization"></label>
                                                                                                                      <br />
                                                                                                                      <asp:Label ID="Label2" runat="server" Text='<%# Bind("Hospitalization") %>' Enabled="False" meta:resourcekey="Label2Resource1"></asp:Label>
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
                                                                  </div>

                                                              </div>








                                                          </asp:View>


                                                      </asp:MultiView>
                                                  </ContentTemplate>
                                              </asp:UpdatePanel>
                                          </div>
                                      </div>
                                  </div>
                              </div>
                              



                    












                              <div id="searchFilterSummary" class="row embed-panel" runat="server">
                                  <div class="panel panel-default">
                                      <div class="panel-heading">
                                          <div class="row">
                                              <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
                                                  <h3 class="heading" runat="server" meta:resourcekey="Hdg_FilterSummary"></h3>
                                              </div>

                                          </div>
                                      </div>
                                      <div class="panel-body">
                                          <p><%= GetLocalResourceObject("Page_Text_2") %></p>
                                          <div class="table-responsive">
                                              Filter Summary Here- We will not implement this section at this time.
                                          </div>
                                      </div>
                                  </div>
                              </div>
                              <div class="modal-footer text-center">


                                  <button id="btnCancelSearch" type="button" class="btn btn-default" runat="server" meta:resourcekey="Btn_Cancel" data-backdrop="false" data-toggle="modal" data-target="#searchCancelModal"></button>


                                  <asp:Button ID="btnClear" runat="server" CssClass="btn btn-default" meta:resourcekey="Btn_Clear" />






                                  <button id="btnCancelSearchResults" type="button" class="btn btn-default" runat="server" meta:resourcekey="Btn_Cancel" data-toggle="modal" data-backdrop="false" data-target="#searchCancelModal" hidden="hidden"></button>
                                  <asp:Button runat="server" ID="btnSearch" CssClass="btn btn-primary"  meta:resourcekey="Btn_Search" OnClick="btnSearch_Click" />
                                  <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-default" meta:resourceKey="btn_Print" />


                              </div>
          
                
           
            </div>
                        
            </div>
        </ContentTemplate>
   
        
    
    
    
    </asp:UpdatePanel>
    
    <script type="text/javascript">
                var messageResx = '';
               <%-- $(document).ready(function () {
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(callBackHandler);
                    var searchForm = document.getElementById("<% = searchForm.ClientID %>");
                    if (searchForm != undefined && <%= (Not Page.IsPostBack).ToString().ToLower() %>)
                        $('#<%= txtSearchStrCaseId.ClientID %>').focus();
                    $('.modal').modal({ show: false, backdrop: 'static' });
                    $('#<%= deleteHDR.ClientID %>').modal({ show: false, backdrop: 'static' });
                });

                function callBackHandler() {
                    $('.modal').modal({ show: false, backdrop: 'static' });
                    $('#<%= deleteHDR.ClientID %>').modal({ show: false, backdrop: 'static' });
                }--%>
          
           
                               
        function ShowResults() {

            $('#collapseThree').collapse('show');
            $('#collapseOne').collapse('hide');
            $('#collapseTwo').collapse('hide');
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

        var advanceShown = false;
        function ToggleSearch(panel) {
            if (panel == 1) {
                $('#collapseOne').collapse('show');
                $('#collapseTwo').collapse('hide');
                $('#collapseThree').collapse('hide');
            }
            if (panel == 2) {
                $('#collapseOne').collapse('hide');
                $('#collapseTwo').collapse('show');
                $('#collapseThree').collapse('hide');
            }
            if (panel == 3) {
                $('#collapseOne').collapse('hide');
                $('#collapseTwo').collapse('hide');
                $('#collapseThree').collapse('show');
            }
            //if (advanceShown == false) {
            //    $('#collapseOne').collapse('hide');
            //    $('#collapseTwo').collapse('show');
            //    advanceShown = true;
            //}
            //else {
            //    $('#collapseOne').collapse('show');
            //    $('#collapseTwo').collapse('hide');
            //    advanceShown = false;
            //}

        }



           
</script>







          
</asp:Content>
