Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports EIDSS.Client.Responses
Imports EIDSS.Client.Enumerations
Imports Newtonsoft.Json

Public Class HumanDiseaseReport
    Inherits BaseEidssPage

#Region "Global Values"

    'Constants for Sections/Panels on the form
    Private Const SectionPerson As String = "PatientReview"
    Private Const SectionDisease As String = "Disease"
    Public sFile As String
    Private lookupDiagHaCodeList As New List(Of clsRefIntList)
    Private Const HDR_SAMPLES_GvList As String = "HDRSamplesGVList"
    Private Const HDR_SAMPLES_GvListDS As String = "dsHDRSamples"
    Private Const HDR_TESTS_DATASET As String = "dsHDRTests"
    Private Const HDR_TESTS_GvList As String = "HDRTestsGVList"
    Private Const HDR_TESTS_GvListDS As String = "dsHDRTests"
    Private Const HDR_VACCINATIONS_GvList As String = "VaccinationsGVList"
    Private Const HDR_VACCINATIONS_GvListDS As String = "dsVaccinations"
    Private Const HDR_ANTIVIRALTHERAPIES_GvList As String = "AntiviralTherapiesGVList"
    Private Const HDR_ANTIVIRALTHERAPIES_GvListDS As String = "dsAntiviralTherapies"
    Private Const HDR_CONTACTS_GvList As String = "HDRContactsGVList"
    Private Const HDR_CONTACTS_GvListDS As String = "dsHDRContact"
    Private lookupSampleIdList As New List(Of clsRefGuidStringList)

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"
    Private Const SHOW_SEARCH_PERSON_MODAL As String = "showSearchPersonModal('" & CallerPages.HumanDiseaseReport & "');"
    Private Const HIDE_SEARCH_PERSON_MODAL As String = "hideSearchPersonModal();"
    Private Const SHOW_SEARCH_ORGANIZATION_MODAL As String = "showSearchOrganizationModal('" & CallerPages.HumanDiseaseReport & "');"
    Private Const HIDE_SEARCH_ORGANIZATION_MODAL As String = "hideSearchOrganizationModal();"
    Private Const SHOW_SEARCH_EMPLOYEE_MODAL As String = "show SearchEmployeeModal('" & CallerPages.HumanDiseaseReport & "');"
    Private Const HIDE_SEARCH_EMPLOYEE_MODAL As String = "hide SearchEmployeeModal();"
    Private Const SHOW_ADD_CONTACT_MODAL As String = "openModalContactEdit();"
    Private Const HIDE_ADD_CONTACT_MODAL As String = "closeModalContactEdit();"

    Private Const sampleTestStatusText As String = "Final"
    Private Const sampleTestStatusValue As Int64 = 10001001

    Private oCommon As clsCommon = New clsCommon()
    Private HumanAPIService As HumanServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchPersonUserControl))


#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim oComm As clsCommon = New clsCommon()

        Try
            If Not Page.IsPostBack Then

                If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpidemiologist) Then
                End If

                ExtractViewStateSession()

                rdbExposureAddressTypeExact.Checked = True
                lucExposure.ShowCountry = False
                lucExposure.ShowCountryOnly = False
                lucExposure.IsDbRequiredCountry = False
                lucExposure.DataBind()
                foreignAddressType.Visible = False
                relativeAddressType.Visible = False
                divRelatedTo.Visible = False
                lblRelatedTo.Visible = False

                Session("Open_Add_Contact_Modal") = ""
                hdfAddContactModalStatus.Value = ""

                ViewState("UserAction") = ""
                If Request.Params("Action") = "preview" Then
                    ViewState("UserAction") = "preview"
                End If

                If Not String.IsNullOrEmpty(Request.Params("relatedToID")) Then
                    ViewState("UserAction") = "relatedToID"
                    ViewState(CALLER) = CallerPages.HumanDiseaseReport
                    Session("idfHumanCase") = Request.Params("relatedToID") 'gives the id of the Human Case
                End If

                If (ViewState(CALLER).ToString().EqualsAny({ApplicationActions.PersonPreviewHumanDiseaseReport.ToString(),
                                                           ApplicationActions.PersonAddHumanDiseaseReport.ToString()})) Then
                    If (ViewState(CALLER).ToString().EqualsAny({ApplicationActions.PersonPreviewHumanDiseaseReport.ToString()})) Then
                        hdfidfHumanCase.Value = ViewState(CALLER_KEY).ToString()
                    Else

                        hdfidfHumanActual.Value = ViewState(CALLER_KEY).ToString()
                    End If
                    OpenPageFromPerson()

                ElseIf (ViewState(CALLER).ToString().EqualsAny({CallerPages.SearchDiseaseReports})) Then
                    OpenPageFromReportSearch()

                Else
                    ViewState(CALLER) = CallerPages.HumanDiseaseReport
                    OpenPageFromReportSearch()

                End If

                'Samples grid from cache if cache file has anything
                Dim HdrSampleList As New List(Of clsHumanDiseaseSample)
                sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSamples)
                oComm.HydrateListFromXmlFile(HdrSampleList, sFile)
                If (HdrSampleList.Count > 0) Then
                    ViewState(HDR_SAMPLES_GvList) = HdrSampleList
                    gvSamples.DataSource = HdrSampleList
                    gvSamples.DataBind()
                End If
                oComm.DeleteTempFiles(sFile)


                'Tests grid from cache if cache file has anything
                Dim HdrTestList As New List(Of clsHumanDiseaseTest)
                sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportTests)
                oComm.HydrateListFromXmlFile(HdrTestList, sFile)
                If (HdrTestList.Count > 0) Then
                    ViewState(HDR_TESTS_GvList) = HdrTestList
                    gvTests.DataSource = HdrTestList
                    gvTests.DataBind()
                End If
                oComm.DeleteTempFiles(sFile)

                'Contacts grid from cache if cache file has anything

            End If

            SetControls()
            If IsControlsByUsersRolesandPermissionsSet.Value = "0" Then
                SetControlsByUsersRolesandPermissions()
            End If
            FillDiseaseReportSummaryRelated()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#Region "Common"

    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = oCommon.GetViewState(True)

            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        PrepViewStates()

    End Sub

    Private Sub PrepViewStates()

        'Used to correct any "Nothing" values for known Viewstate variables
        Dim lKeys As List(Of String) = New List(Of String)

        'Add your new View State variables here
        lKeys.Add(CALLER)
        lKeys.Add(CALLER_KEY)

        For Each sKey As String In lKeys
            If (ViewState(sKey) Is Nothing) Then
                ViewState(sKey) = String.Empty
            End If
        Next

    End Sub

    Private Sub OpenPageFromPerson()

        'FillPerson()
        hdfCurrentDate.Value = Date.Today.ToString("d")
        ToggleVisibility(SectionDisease)
        PopulateDiseaseDropDowns()

        btn_Return_to_Person_Record.Visible = True
        btnReturnToSearch.Visible = True
        btn_Return_to_Person_Record.Visible = False
        btnReturnToReportSearch.Visible = False
        btnReturnToDiseaseSearchResultsList.Visible = False

        If String.IsNullOrEmpty(txtLegacyCaseID.Text) Then
            divDiseaseLegacyCaseID.Visible = False
        End If

        If ViewState(CALLER).ToString().Equals(ApplicationActions.PersonAddHumanDiseaseReport.ToString()) Then
            hdfstrHumanCaseId.Value = "(New)"
            hdfPageMode.Value = PageUsageMode.CreateNew
            hdfidfHumanActual.Value = ViewState(CALLER_KEY)
            hdfidfPersonEnteredBy.Value = Session("Person").ToString

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            hdfHumanMasterID.Value = hdfidfHumanActual.Value
            Dim list As List(Of HumHumanMasterGetDetailModel) = HumanAPIService.GetHumanMasterDetailAsync(GetCurrentLanguage(), hdfHumanMasterID.Value).Result

            Scatter(Me, list.FirstOrDefault())

            'Fill Summary
            txtSummarystrPersonName.Text = hdfLastOrSurname.Value + ", " + hdfFirstOrGivenName.Value + ", " + hdfSecondName.Value
            txtSummaryEidsId.Text = hdfEIDSSPersonID.Value
        Else
            hdfPageMode.Value = PageUsageMode.Edit
            FillDiseaseForEdit(hdfidfHumanCase.Value)

            HumanDiseaseFlexFormRiskFactors.HumanCaseID = Long.Parse(hdfidfHumanCase.Value)
            FlexFormSymptoms.HumanCaseID = Long.Parse(hdfidfHumanCase.Value)
            'Try enter the Disease ID if available. 

            HumanDiseaseFlexFormRiskFactors.DiagnosisID = Long.Parse(ddlidfsFinalDiagnosis.SelectedItem.Value)
            FlexFormSymptoms.DiagnosisID = Long.Parse(ddlidfsFinalDiagnosis.SelectedItem.Value)

            If hdfidfCSObservation.Value = "0" OrElse hdfidfCSObservation.Value = "" Then
                FlexFormSymptoms.ObservationID = 0
            Else
                FlexFormSymptoms.ObservationID = Long.Parse(hdfidfCSObservation.Value)
            End If

            If hdfidfEpiObservation.Value = "0" OrElse hdfidfEpiObservation.Value = "" Then
                    HumanDiseaseFlexFormRiskFactors.ObservationID = 0
                Else
                HumanDiseaseFlexFormRiskFactors.ObservationID = Long.Parse(hdfidfEpiObservation.Value)
            End If
                FillDiseaseReportSummary()

            If ddlidfsCaseProgressStatus.Text = "10109002" Then 'Closed Status
                ddlidfsCaseProgressStatus.Enabled = False
            End If

        End If

    End Sub

    Private Sub OpenPageFromReportSearch()
        hdfPageMode.Value = PageUsageMode.Edit
        hdfidfHumanActual.Value = Session("hdfidfHumanActual").ToString
        If Not ViewState(CALLER_KEY).ToString = Nothing Then
            hdfidfHuman.Value = ViewState(CALLER_KEY).ToString
        End If
        hdfidfHumanCase.Value = Session("idfHumanCase").ToString
        hdfSearchHumanCaseId.Value = Session("idfHumanCase").ToString

        ' Reset Date Picker Controls Max Date to nothing for edit date fields to display     
        hdfCurrentDate.Value = ""
        txtdatDateOfDiagnosis.MaxDate = hdfCurrentDate.Value
        txtdatNotificationDate.MaxDate = hdfCurrentDate.Value
        txtStartDateofInvestigation.MaxDate = hdfCurrentDate.Value
        txtdatHospitalizationDate.MaxDate = hdfCurrentDate.Value
        masAddSampleDateCollected.MaxDate = hdfCurrentDate.Value
        masAddSampleDateSent.MaxDate = hdfCurrentDate.Value
        txtAddFieldTestResultDate.MaxDate = hdfCurrentDate.Value
        datAddFieldTestResultReceived.MaxDate = hdfCurrentDate.Value
        txtdatInterpretedDate.MaxDate = hdfCurrentDate.Value
        txtdatValidationDate.MaxDate = hdfCurrentDate.Value
        txtdatLastContactDate.MaxDate = hdfCurrentDate.Value
        txtDateofClassification.MaxDate = hdfCurrentDate.Value
        txtdatOnSetDate.MaxDate = hdfCurrentDate.Value
        txtDateofDeath.MaxDate = hdfCurrentDate.Value

        ToggleVisibility(SectionDisease)
        btn_Return_to_Person_Record.Visible = False
        btnReturnToSearch.Visible = False
        btnReturnToReportSearch.Visible = False
        btnReturnToDiseaseSearchResultsList.Visible = True
        PopulateDiseaseDropDowns()

        If ViewState("UserAction").ToString().Equals("relatedToID") Then

            FillDiseaseForEdit(hdfidfHumanCase.Value)
            FillPerson()

        Else
            FillPerson()
            FillDiseaseForEdit(hdfidfHumanCase.Value)

        End If

        'Flex form variable entry path. 
        If Not String.IsNullOrEmpty(hdfidfHumanCase.Value) Then
            HumanDiseaseFlexFormRiskFactors.HumanCaseID = Long.Parse(hdfidfHumanCase.Value)
            FlexFormSymptoms.HumanCaseID = Long.Parse(hdfidfHumanCase.Value)
        End If

        If Not String.IsNullOrEmpty(ddlidfsFinalDiagnosis.SelectedItem.Value) Then

            HumanDiseaseFlexFormRiskFactors.DiagnosisID = Long.Parse(ddlidfsFinalDiagnosis.SelectedItem.Value)
            FlexFormSymptoms.DiagnosisID = Long.Parse(ddlidfsFinalDiagnosis.SelectedItem.Value)

            'Hard coded the value for now for testing purposes. 
            'Developer to supply this from tlbHumanCase 
            'There are idfEpiObservation, idfCSObservation so which one to retreive is based on the FormType

            'Form types (Human Module)
            '10034010 -- Clinical Signs
            '10034011 -- EPI investigation

            'FormType, DiagnosisID are used to retrieve 'FormTemplate, 
            'and then ObservationID and FormTemplateID are used to insert a new record into tlbObservation using USP_ADMIN_FF_Observtion_SET 
            'once the observationID is generated, based on the FormType to be either CS or EPI the tlbHumanCase has to be update with the columns 
            'idfCSObservation and idfEpiObservation

            If hdfidfCSObservation.Value = "0" OrElse hdfidfCSObservation.Value = "" Then
                FlexFormSymptoms.ObservationID = 0
            Else
                FlexFormSymptoms.ObservationID = Long.Parse(hdfidfCSObservation.Value)
            End If

            If hdfidfEpiObservation.Value = "0" OrElse hdfidfEpiObservation.Value = "" Then
                HumanDiseaseFlexFormRiskFactors.ObservationID = 0
            Else
                HumanDiseaseFlexFormRiskFactors.ObservationID = Long.Parse(hdfidfEpiObservation.Value)
            End If

        End If


        Try

            If hdfblnClinicalDiagBasis.Value = "True" Then
                cblBasisofDiagnosis.Items(0).SelectItem
            End If

            If hdfblnEpiDiagBasis.Value = "True" Then
                cblBasisofDiagnosis.Items(1).SelectItem
            End If

            If hdfblnLabDiagBasis.Value = "True" Then
                cblBasisofDiagnosis.Items(2).SelectItem
            End If


            If hdfidfsYNExposureLocationKnown.Value = "1" Then
                rdbLocationofExposureKnownYes.Checked = True
                pnlLocationofExposureKnown.Visible = True
            End If

            If hdfidfsYNExposureLocationKnown.Value = "0" Then
                rdbLocationofExposureKnownNo.Checked = True
                pnlLocationofExposureKnown.Visible = False
            End If

            FillDiseaseReportSummary()

            If ddlidfsCaseProgressStatus.Text = "10109002" Then 'Closed Status
                ddlidfsCaseProgressStatus.Enabled = False
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try
    End Sub
    Private Sub ToggleVisibility(ByVal sSection As String)
        'Containers
        disease.Visible = sSection.EqualsAny({SectionDisease})
        'Set focus to first panel
        If sSection.EqualsAny({SectionPerson, SectionDisease}) Then hdnPanelController.Value = 1
    End Sub

    Private Sub SetControls()
        Try
            If (hdfPageMode.Value = PageUsageMode.CreateNew) Then
                If (ddlidfsFinalDiagnosis.Enabled = False) Then
                    ddlidfsFinalDiagnosis.Enabled = True
                End If

                If divDiseaseSave.Visible = True Then
                    ddlidfsFinalDiagnosis.Enabled = False
                End If
            Else
                If (ddlidfsFinalDiagnosis.Enabled = True) Then
                    ddlidfsFinalDiagnosis.Enabled = False
                End If
            End If

            If hdfNewNotifiableDiseaseFlag.Value = "1" Then
                ddlidfsFinalDiagnosis.Enabled = True
            End If

            txtdatDateOfDiagnosis.Enabled = True
            ddlidfsFinalState.Enabled = True
            ddlidfsHospitalizationStatus.Enabled = True
            ddlidfHospital.Enabled = True
            txtstrCurrentLocation.Enabled = True
            ddlidfsInitialCaseStatus.Enabled = True
            SetEnableControls(finalOutcome, True)
            SetEnableControls(contactList, True)
            ddlidfsHospitalizationStatus.Enabled = True
            ddlidfHospital.Enabled = True
            txtstrCurrentLocation.Enabled = True
            rblidfsYNHospitalization.Enabled = True


            hospital.Visible = False
            otherLocation.Visible = False
            If Not ddlidfsHospitalizationStatus.SelectedIndex = -1 Then
                If (ddlidfsHospitalizationStatus.SelectedValue = "5350000000") Then
                    pnlHospitalization.Visible = True
                    hospital.Visible = True

                ElseIf (ddlidfsHospitalizationStatus.SelectedValue = "5360000000") Then
                    otherLocation.Visible = True
                    'rblidfsYNHospitalization.SelectedValue = "10100002"
                    'pnlPatientPreviouslySought.Visible = False
                    'txtdatFirstSoughtCareDate.Enabled = False
                    'txtFacilityFirstSoughtCare.Enabled = False
                    'ddlidfsNonNotifiableDiagnosis.Enabled = False
                ElseIf (ddlidfsHospitalizationStatus.SelectedValue = "10041001") Then
                    'rblidfsYNHospitalization.SelectedValue = "10100003"
                    'pnlPatientPreviouslySought.Visible = False
                    'txtdatFirstSoughtCareDate.Enabled = False
                    'txtFacilityFirstSoughtCare.Enabled = False
                    'ddlidfsNonNotifiableDiagnosis.Enabled = False
                End If

            End If

            If (IsNumeric(rblidfsYNPreviouslySoughtCare.SelectedValue)) Then
                If (Convert.ToInt64(rblidfsYNPreviouslySoughtCare.SelectedValue) = 10100001) Then
                    txtdatFirstSoughtCareDate.Enabled = True
                    txtFacilityFirstSoughtCare.Enabled = True
                    ddlidfsNonNotifiableDiagnosis.Enabled = True
                    pnlPatientPreviouslySought.Visible = True
                Else

                    pnlPatientPreviouslySought.Visible = False
                    txtdatFirstSoughtCareDate.Enabled = False
                    txtFacilityFirstSoughtCare.Enabled = False
                    ddlidfsNonNotifiableDiagnosis.Enabled = False
                End If
            End If

            If (IsNumeric(rblidfsYNHospitalization.SelectedValue)) Then
                If (Convert.ToInt64(rblidfsYNHospitalization.SelectedValue) = 10100001) Then
                    txtdatHospitalizationDate.Enabled = True
                    txtdatDischargeDate.Enabled = True
                    pnlHospitalization.Visible = True
                Else
                    txtdatHospitalizationDate.Enabled = False
                    txtdatDischargeDate.Enabled = False
                    pnlHospitalization.Visible = False
                End If
            End If

            samplesGridPanel.Visible = True
            btnSampleNewAdd.Enabled = False
            If (IsNumeric(rblidfsYNSpecimenCollected.SelectedValue)) Then
                btnSampleNewAdd.Enabled = True
            End If

            If rdbAntibioticAntiviralTherapyAdministeredYes.Checked Then
                pnlAntiBioticAdministred.Visible = True
                gvAntiviralTherapies.Visible = True
            Else
                pnlAntiBioticAdministred.Visible = False
            End If

            If rdbExposureAddressTypeExact.Checked Then
                lucExposure.ShowCountry = False
                lucExposure.ShowCountryOnly = False
                lucExposure.IsDbRequiredCountry = False
                lucExposure.DataBind()
                foreignAddressType.Visible = False
                relativeAddressType.Visible = False
            End If

            If gvSamples.Rows.Count > 0 Then
                btnHdrAddNewTest.Enabled = True
            Else
                btnHdrAddNewTest.Enabled = False
            End If

            hdfNotificationSentBySelected.Value = "0"
            If ddlNotificationSentBy.SelectedIndex > 0 Then
                hdfNotificationSentBySelected.Value = "1"
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

#End Region

#Region "Person"

    Private Sub FillPerson()
        Try

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            hdfHumanMasterID.Value = hdfidfHumanActual.Value
            Dim list As List(Of HumDiseasePersoninformationGetDetailModel) = HumanAPIService.GetHumDiseasePersoninformationDetailAsync(GetCurrentLanguage(), hdfidfHuman.Value, hdfidfHumanActual.Value).Result

            FillPersonDropDowns()

            Scatter(Me, list.FirstOrDefault())

            Select Case hdfIsEmployedTypeID.Value
                Case YesNoUnknown.No
                    rdbCurrentlyEmployedNo.Checked = True
                    pnlEmploymentInformation.Visible = False
                Case YesNoUnknown.Unknown
                    rdbCurrentlyEmployedUnknown.Checked = True
                    pnlEmploymentInformation.Visible = False
                Case YesNoUnknown.Yes
                    rdbCurrentlyEmployedYes.Checked = True
                    pnlEmploymentInformation.Visible = True

                    If hdfEmployerForeignAddressIndicator.Value.IsValueNullOrEmpty = False Then
                        If hdfEmployerForeignAddressIndicator.Value = True.ToString Then
                            divEmployerForeignAddress.Visible = True
                            chkEmployerForeignAddressIndicator.Checked = True
                            If hdfEmployeridfsCountry.Value.IsValueNullOrEmpty = False Then
                                ddlEmployeridfsCountry.SelectedValue = hdfEmployeridfsCountry.Value
                            End If
                            Employer.Visible = False
                        Else
                            chkEmployerForeignAddressIndicator.Checked = False
                            Employer.Visible = True
                        End If
                    End If
            End Select

            Select Case hdfIsStudentTypeID.Value
                Case YesNoUnknown.No
                    rdbCurrentlyInSchoolNo.Checked = True
                    pnlSchoolInformation.Visible = False
                Case YesNoUnknown.Unknown
                    rdbCurrentlyInSchoolUnknown.Checked = True
                    pnlSchoolInformation.Visible = False
                Case YesNoUnknown.Yes
                    rdbCurrentlyInSchoolYes.Checked = True
                    pnlSchoolInformation.Visible = True

                    If hdfSchoolForeignAddressIndicator.Value.IsValueNullOrEmpty = False Then
                        If hdfSchoolForeignAddressIndicator.Value = True.ToString Then
                            divSchoolForeignAddress.Visible = True
                            chkSchoolForeignAddressIndicator.Checked = True
                            If hdfSchoolidfsCountry.Value.IsValueNullOrEmpty = False Then
                                ddlSchoolidfsCountry.SelectedValue = hdfSchoolidfsCountry.Value
                            End If
                            School.Visible = False
                        Else
                            chkSchoolForeignAddressIndicator.Checked = False
                            School.Visible = True
                        End If
                    End If
            End Select

            If hdfHumanAltGeoLocationID.Value.IsValueNullOrEmpty Then
                rdbAnotherAddressNo.Checked = True
                pnlAnotherAddress.Visible = False
            Else
                rdbAnotherAddressYes.Checked = True
                pnlAnotherAddress.Visible = True

                If hdfHumanAltForeignAddressIndicator.Value = True.ToString Then
                    divHumanAltForeignAddress.Visible = True
                    chkHumanAltForeignAddressIndicator.Checked = True
                    If hdfHumanAltidfsCountry.Value.IsValueNullOrEmpty = False Then
                        ddlHumanAltidfsCountry.SelectedValue = hdfHumanAltidfsCountry.Value
                    End If
                    HumanAlt.Visible = False
                Else
                    chkHumanAltForeignAddressIndicator.Checked = False
                    HumanAlt.Visible = True
                End If
            End If

            If txtContactPhone2.Text.IsValueNullOrEmpty = True And ddlContactPhone2TypeID.SelectedValue.IsValueNullOrEmpty = True Then
                pnlAnotherPhone.Visible = False
                rdbAnotherPhoneNo.Checked = True
            Else
                pnlAnotherPhone.Visible = True
                rdbAnotherPhoneYes.Checked = True
            End If

            CalculateAge()

            Human.LocationCountryID = list.FirstOrDefault().HumanidfsCountry
            Human.LocationRegionID = list.FirstOrDefault().HumanidfsRegion
            Human.LocationRayonID = list.FirstOrDefault().HumanidfsRayon
            Human.LocationSettlementID = list.FirstOrDefault().HumanidfsSettlement
            Human.LocationPostalCodeName = list.FirstOrDefault().HumanstrPostalCode
            Human.DataBind()

            HumanAlt.LocationCountryID = list.FirstOrDefault().HumanAltidfsCountry
            HumanAlt.LocationRegionID = list.FirstOrDefault().HumanAltidfsRegion
            HumanAlt.LocationRayonID = list.FirstOrDefault().HumanAltidfsRayon
            HumanAlt.LocationSettlementID = list.FirstOrDefault().HumanAltidfsSettlement
            HumanAlt.LocationPostalCodeName = list.FirstOrDefault().HumanAltstrPostalCode
            HumanAlt.DataBind()

            Employer.LocationCountryID = list.FirstOrDefault().EmployeridfsCountry
            Employer.LocationRegionID = list.FirstOrDefault().EmployeridfsRegion
            Employer.LocationRayonID = list.FirstOrDefault().EmployeridfsRayon
            Employer.LocationSettlementID = list.FirstOrDefault().EmployeridfsSettlement
            Employer.LocationPostalCodeName = list.FirstOrDefault().EmployerstrPostalCode
            Employer.DataBind()

            School.LocationCountryID = list.FirstOrDefault().SchoolidfsCountry
            School.LocationRegionID = list.FirstOrDefault().SchoolidfsRegion
            School.LocationRayonID = list.FirstOrDefault().SchoolidfsRayon
            School.LocationSettlementID = list.FirstOrDefault().SchoolidfsSettlement
            School.LocationPostalCodeName = list.FirstOrDefault().SchoolstrPostalCode
            School.DataBind()

            txtEIDSSPersonID.Enabled = False
            If txtDateOfBirth.Text.IsValueNullOrEmpty() Then
                txtReportedAge.Enabled = True
                ddlReportedAgeUOMID.Enabled = True
            Else
                txtReportedAge.Enabled = False
                ddlReportedAgeUOMID.Enabled = False
            End If

            EnableForm(divPersonInformation, False)
            EnableForm(divPersonInformationAddress, False)
            EnableForm(divPersonInformationEmploymentSchool, False)

        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub FillPersonDropDowns()

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        FillBaseReferenceDropDownList(ddlPersonalIDType, BaseReferenceConstants.PersonalIDType, HACodeList.NoneHACode, True)
        FillBaseReferenceDropDownList(ddlGenderTypeID, BaseReferenceConstants.HumanGender, HACodeList.HumanHACode, True)
        FillBaseReferenceDropDownList(ddlReportedAgeUOMID, BaseReferenceConstants.HumanAgeType, HACodeList.HumanHACode, True)
        FillBaseReferenceDropDownList(ddlOccupationTypeID, BaseReferenceConstants.OccupationType, HACodeList.HumanHACode, True)
        'The citizenship list is not the same as the country list.  Using the country values throws a foreign key constraint violation.
        FillBaseReferenceDropDownList(ddlCitizenshipTypeID, BaseReferenceConstants.NationalityList, HACodeList.NoneHACode, True)
        FillBaseReferenceDropDownList(ddlContactPhoneTypeID, BaseReferenceConstants.ContactPhoneType, HACodeList.HumanHACode, True)
        FillBaseReferenceDropDownList(ddlContactPhone2TypeID, BaseReferenceConstants.ContactPhoneType, HACodeList.HumanHACode, True)

        Dim list As List(Of CountryGetLookupModel) = CrossCuttingAPIService.GetCountryListAsync(GetCurrentLanguage()).Result
        list.OrderBy(Function(x) x.strCountryName)
        FillDropDownList(ddlEmployeridfsCountry, list, {GlobalConstants.NullValue}, CountryConstants.CountryID, CountryConstants.CountryName, Nothing, Nothing, True)
        FillDropDownList(ddlSchoolidfsCountry, list, {GlobalConstants.NullValue}, CountryConstants.CountryID, CountryConstants.CountryName, Nothing, Nothing, True)
        FillDropDownList(ddlHumanAltidfsCountry, list, {GlobalConstants.NullValue}, CountryConstants.CountryID, CountryConstants.CountryName, Nothing, Nothing, True)

    End Sub

    Private Sub CalculateAge()

        If Not String.IsNullOrEmpty(txtDateOfBirth.Text) Then
            Dim age As Long = DateDiff(DateInterval.Day, Convert.ToDateTime(txtDateOfBirth.Text), Date.Today, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1)

            If age <= 30 Then
                ddlReportedAgeUOMID.SelectedValue= HumanAgeTypeConstants.Days
            ElseIf age > 30 And age <= 364 Then
                age = DateDiff(DateInterval.Month, Convert.ToDateTime(txtDateOfBirth.Text), Date.Today, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1)
                ddlReportedAgeUOMID.SelectedValue = HumanAgeTypeConstants.Months
            ElseIf age >= 365 Then
                age = DateDiff(DateInterval.Year, Convert.ToDateTime(txtDateOfBirth.Text), Date.Today, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1)
                ddlReportedAgeUOMID.SelectedValue = HumanAgeTypeConstants.Years
            End If

            txtReportedAge.Text = age.ToString()
        End If

    End Sub

#End Region

    Private Sub FillContactsList(Optional sGetDataFor As String = "GRIDROWS",
                            Optional bRefresh As Boolean = False)

        Try
            Dim dsContacts As New DataSet
            Dim HdrContactsList As New List(Of clsHumanDiseaseContact)

            'Save the data set in view state to re-use
            If bRefresh Then ViewState(HDR_CONTACTS_GvList) = Nothing

            If IsNothing(ViewState(HDR_CONTACTS_GvList)) Then
                If hdfidfHumanCase.Value.ToString().IsValueNullOrEmpty() = False Then
                    If HumanAPIService Is Nothing Then
                        HumanAPIService = New HumanServiceClient()
                    End If

                    Dim List = HumanAPIService.GetHumanDiseaseContacts(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value)).Result
                    dsContacts.Tables.Add(ConvertListToDataTable(List))
                Else
                    Dim List = New List(Of HumDiseaseContactsGetListModel)()
                    dsContacts.Tables.Add(ConvertListToDataTable(List))
                End If
            Else
                dsContacts = CType(ViewState(HDR_CONTACTS_GvListDS), DataSet)
            End If

            gvContacts.DataSource = Nothing

            'convert stored proc results to List(clsHumanDiseaseContact)
            For Each r As DataRow In dsContacts.Tables(0).Rows
                Dim li As New clsHumanDiseaseContact
                li.idfContactedCasePerson = r.Item("idfContactedCasePerson")
                li.strContactPersonFullName = r.Item("strContactPersonFullName")
                li.idfsPersonContactType = r.Item("idfsPersonContactType")
                li.strPersonContactType = r.Item("strPersonContactType")
                li.idfHuman = r.Item("idfHuman")
                li.idfHumanCase = r.Item("idfHumanCase")
                li.idfHumanActual = r.Item("idfRootHuman")
                If Not IsDBNull(r.Item("datDateOfLastContact")) Then
                    li.datDateOfLastContact = r.Item("datDateOfLastContact")
                End If
                If Not IsDBNull(r.Item("strPlaceInfo")) Then
                    li.strPlaceInfo = r.Item("strPlaceInfo").ToString
                End If
                If Not IsDBNull(r.Item("strComments")) Then
                    li.strComments = r.Item("strComments").ToString
                End If
                'li.datDateOfBirth = r.Item("datDateOfBirth")
                'li.idfsCountry = r.Item("idfsCountry")
                'li.idfsRegion = r.Item("idfsRegion")
                'li.idfsRayon = r.Item("idfsRayon")
                'li.idfsSettlement = Nothing
                'li.strStreetName = r.Item("strStreetName")
                'li.strPostCode = Nothing
                'li.strBuilding = Nothing 'r.Item("strBuilding")
                'li.strHouse = Nothing 'r.Item("strHouse")
                'li.strApartment = Nothing 'r.Item("strApartment")
                'li.strContactPhone = r.Item("strContactPhone")
                'li.idfContactPhoneType = Nothing ' r.Item("idfContactPhoneType ")
                li.rowguid = r.Item("rowguid")
                HdrContactsList.Add(li)
            Next

            ViewState(HDR_CONTACTS_GvList) = HdrContactsList
            gvContacts.DataSource = HdrContactsList
            gvContacts.DataBind()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Sub SetEnableControls(section As HtmlGenericControl, ByVal enabled As Boolean)

        For Each control As Control In section.Controls
            Dim textBox As TextBox = TryCast(control, TextBox)
            If Not IsNothing(textBox) Then
                textBox.Enabled = enabled
                Continue For
            End If

            Dim dropDown As DropDownList = TryCast(control, DropDownList)
            If Not IsNothing(dropDown) Then
                dropDown.Enabled = enabled
                Continue For
            End If

            Dim button As Button = TryCast(control, Button)
            If Not IsNothing(button) Then
                button.Visible = enabled
                Continue For
            End If

            Dim radioButton As RadioButton = TryCast(control, RadioButton)
            If Not IsNothing(radioButton) Then
                radioButton.Enabled = enabled
                Continue For
            End If

            Dim checkBox As CheckBox = TryCast(control, CheckBox)
            If Not IsNothing(checkBox) Then
                checkBox.Enabled = enabled
                Continue For
            End If

            Dim lc As LocationUserControl = TryCast(control, LocationUserControl)
            If Not IsNothing(lc) Then
                Dim ddlCountry As DropDownList = lc.FindControl("ddlCountry")
                If Not IsNothing(ddlCountry) Then
                    ddlCountry.Enabled = enabled
                End If

                Dim ddlRegion As DropDownList = lc.FindControl("ddllsearchFormidfsRegion")
                If Not IsNothing(ddlRegion) Then
                    ddlRegion.Enabled = enabled
                End If

                Dim ddlRayon As DropDownList = lc.FindControl("ddlRayon")
                If Not IsNothing(ddlRayon) Then
                    ddlRayon.Enabled = enabled
                End If
            End If

            Dim div As HtmlContainerControl = TryCast(control, HtmlContainerControl)
            If Not IsNothing(div) Then
                For Each c As Control In div.Controls

                    Dim tb As TextBox = TryCast(c, TextBox)
                    If Not IsNothing(tb) Then
                        tb.Enabled = enabled
                        Continue For
                    End If

                    Dim ddl As DropDownList = TryCast(c, DropDownList)
                    If Not IsNothing(ddl) Then
                        ddl.Enabled = enabled
                        Continue For
                    End If

                    Dim but As Button = TryCast(c, Button)
                    If Not IsNothing(but) Then
                        but.Enabled = enabled
                        Continue For
                    End If

                    Dim rdb As RadioButton = TryCast(control, RadioButton)
                    If Not IsNothing(rdb) Then
                        rdb.Enabled = enabled
                        Continue For
                    End If

                    Dim chb As CheckBox = TryCast(control, CheckBox)
                    If Not IsNothing(chb) Then
                        chb.Enabled = enabled
                        Continue For
                    End If
                Next
            End If
        Next
    End Sub

#Region "Disease"

    Private Sub FillDiseaseReportSummary()
        If String.IsNullOrEmpty(hdfidfHumanCase.Value) Then
            divDiseaseHumanDetail.Visible = False
        Else
            txtSummaryidfHumanCase.Text = hdfstrCaseId.Value
            divDiseaseHumanDetail.Visible = True
        End If
        If String.IsNullOrEmpty(txtLegacyCaseID.Text) Then
            divDiseaseLegacyCaseID.Visible = False
        End If
        txtSummaryDiagnosis.Text = hdfSummaryIdfsFinalDiagnosis.Value
        txtSummarystrPersonName.Text = hdfstrPersonName.Value
        'txtSummaryEidsId.Text = hdfstrCaseId.Value
        txtSummaryEidsId.Text = hdfEIDSSPersonID.Value
        txtSummaryCaseClassification.Text = hdfSummaryCaseClassification.Value

        txtSummaryEnteredByPerson.Text = hdfEnteredByPerson.Value
        txtSummaryOrganizationFullName.Text = hdfOrganizationFullName.Value
        txtstrInterpretedBy.Text = hdfEnteredByPerson.Value
        txtstrInterpretedBy.Enabled = False
        txtstrValidatedBy.Text = hdfEnteredByPerson.Value
        txtstrValidatedBy.Enabled = False

        Dim myUser As Security.Principal.IIdentity
        myUser = HttpContext.Current.User.Identity
        hdfstrAccountName.Value = myUser.Name

        If DateTime.TryParse(hdfdatEnteredDate.Value, Nothing) Then
            txtSummaryDateEntered.Text = String.Format(DateTime.Parse(hdfdatEnteredDate.Value).ToString("d"), "dd/MM/yyyy")
        End If
        If DateTime.TryParse(hdfdatModificationDate.Value, Nothing) Then
            txtSummarydatModificationDate.Text = String.Format(DateTime.Parse(hdfdatModificationDate.Value).ToString("d"), "dd/MM/yyyy")
        End If

        RelatedSessionID.Visible = False
        If ddlDiseaseReportTypeID.SelectedValue = "Active" Then
            RelatedSessionID.Visible = True
        End If

        'FillDiseaseReportSummaryRelated()
    End Sub

    Private Sub SetControlsByUsersRolesandPermissions()

        Dim permissionList As New List(Of Permission)

        Try
            permissionList = EIDSSAuthenticatedUser.GetPermissions()

        Dim accessToHumanDiseaseReportDataPermission As List(Of Permission) = permissionList.Where(Function(x) _
                                                        (x.PermissionType = "Access to Human Disease Report Data")).ToList()
        If accessToHumanDiseaseReportDataPermission.Count > 0 Then
            btnDiseaseReportDelete.Visible = False

            If (EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Or EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpidemiologist) Or EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Epidemiologist)) Then

                If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Then
                    btnDiseaseReportDelete.Visible = True
                    btnSubmit.Visible = True
                    ddlidfsCaseProgressStatus.Enabled = True
                End If

                If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpidemiologist) Then
                    btnDiseaseReportDelete.Visible = True

                    Dim reopenClosedDiseaseReportPermission As List(Of Permission) = permissionList.Where(Function(x) _
                                                            (x.PermissionType = "Can Reopen Closed Disease Report")).ToList()
                    If reopenClosedDiseaseReportPermission.Count > 0 Then
                        btnDiseaseReportDelete.Visible = True
                        btnSubmit.Visible = True
                        ddlidfsCaseProgressStatus.Enabled = True
                    End If
                End If

            Else
                DisableControls()
                ddlidfsFinalDiagnosis.Enabled = False
                btnDiseaseReportDelete.Visible = False
                btnSubmit.Visible = False
            End If

        ElseIf Not EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Then
            DisableControls()
            ddlidfsFinalDiagnosis.Enabled = False
            btnDiseaseReportDelete.Visible = False
            btnSubmit.Visible = False
        End If

            IsControlsByUsersRolesandPermissionsSet.Value = "1"
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub
    Private Sub FillDiseaseReportSummaryRelated()
        Try
            divRelatedTo.Visible = False
            lblRelatedTo.Visible = False
            ' Create hyperlinks for parentHumanDiseaseReportID
            If Not hdfparentHumanDiseaseReportID.Value = "" Then
                divRelatedTo.Visible = True
                lblRelatedTo.Visible = True
                hlParentHumanDiseaseReport.NavigateUrl = "~/Human/HumanDiseaseReport.aspx?relatedToID=" + hdfparentHumanDiseaseReportID.Value
                FillRelatedDiseaseForEdit(hdfparentHumanDiseaseReportID.Value)
                hlParentHumanDiseaseReport.Text = rldstrCaseId.Value
                Session("parentHumanActual") = hdfidfHumanActual.Value
            End If

            ' Create hyperlinks for relatedHumanDiseaseReportIdList
            If Not String.IsNullOrEmpty(hdfrelatedHumanDiseaseReportIdList.Value) Then
                divRelatedTo.Visible = True
                lblRelatedTo.Visible = True
                Dim relatedHumanDiseaseReportIdList As String = hdfrelatedHumanDiseaseReportIdList.Value

                Dim idArray() As String = relatedHumanDiseaseReportIdList.Split(",")
                For i = 0 To idArray.Length - 1
                    Dim l As HyperLink = New HyperLink()
                    l.Visible = True
                    l.ID = i.ToString
                    FillRelatedDiseaseForEdit(idArray(i).ToString)
                    l.NavigateUrl = "~/Human/HumanDiseaseReport.aspx?relatedToID=" + idArray(i).ToString
                    l.Text = rldstrCaseId.Value + ", "
                    If i = (idArray.Length - 1) Then
                        l.Text = l.Text.ToString.Replace(",", "")
                    End If
                    lrlRelatedToChildren.Controls.Add(l)
                    l = Nothing
                Next
                divRelatedToChildren.Controls.Add(lrlRelatedToChildren)

            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Throw
        End Try
    End Sub

    Private Sub PopulateDiseaseDropDowns()
        BaseReferenceLookUp(ddlidfsInitialCaseStatus, BaseReferenceConstants.CaseClassification, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfsFinalDiagnosis, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
        populateLookupDiagHaCodeList(ddlidfsFinalDiagnosis.DataSource)
        BaseReferenceLookUp(ddlidfsFinalCaseStatus, BaseReferenceConstants.CaseClassification, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfsFinalState, BaseReferenceConstants.PatientState, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfsHospitalizationStatus, BaseReferenceConstants.PatientLocationType, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfsNonNotifiableDiagnosis, BaseReferenceConstants.NonNotifiableDiagnosis, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlGroundType, BaseReferenceConstants.GroundType, HACodeList.NoneHACode, blnBlankRow:=True)

        'Load Organization and People List
        FillHumanOrganizationList(ddlNotificationSentBy, Nothing, Nothing, True)
        ddlNotificationSentBy.DataSource = SortDropDownList(ddlNotificationSentBy).Items

        FillHumanOrganizationList(ddlNotificationReceivedBy, Nothing, Nothing, True)
        ddlNotificationReceivedBy.DataSource = SortDropDownList(ddlNotificationReceivedBy).Items

        FillHumanOrganizationList(ddlidfHospital, Nothing, Nothing, True)
        ddlidfFaciltyHospital.DataSource = SortDropDownList(ddlidfFaciltyHospital).Items

        FillHumanOrganizationList(ddlidfFaciltyHospital, Nothing, Nothing, True)
        ddlidfFaciltyHospital.DataSource = SortDropDownList(ddlidfFaciltyHospital).Items

        FillHumanOrganizationList(ddlnvestigationNameOrganization, Nothing, Nothing, True)
        ddlnvestigationNameOrganization.DataSource = SortDropDownList(ddlnvestigationNameOrganization).Items

        FillHumanOrganizationList(ddlFacilityFirstSoughtCare, Nothing, Nothing, True)
        ddlstrCollectedByInstitution.DataSource = SortDropDownList(ddlFacilityFirstSoughtCare).Items

        FillHumanOrganizationList(ddlstrCollectedByInstitution, Nothing, Nothing, True)
        ddlstrCollectedByInstitution.DataSource = SortDropDownList(ddlstrCollectedByInstitution).Items

        'FillBaseReferenceDropDownList(ddlNotificationSentBy, BaseReferenceConstants.OrganizationName, HACodeList.HumanHACode, True)
        'FillBaseReferenceDropDownList(ddlNotificationReceivedBy, BaseReferenceConstants.OrganizationName, HACodeList.HumanHACode, True)
        'FillBaseReferenceDropDownList(ddlstrCollectedByInstitution, BaseReferenceConstants.OrganizationName, HACodeList.HumanHACode, True)
        'FillBaseReferenceDropDownList(ddlnvestigationNameOrganization, BaseReferenceConstants.OrganizationName, HACodeList.HumanHACode, True)

        FillDropDown(ddlNotificationSentByName, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
        FillDropDown(ddlNotificationReceivedByName, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
        FillDropDown(ddlstrEpidemiologistName, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
        FillDropDown(ddlstrCollectedByOfficer, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)

        'FillDropDown(ddlidfHospital _
        '                , GetType(clsOrganization) _
        '                , {"@OrganizationTypeID:" & "10504002", "@intHACode:" & HACodeList.HumanHACode} _
        '                , OrganizationConstants.idfInstitution _
        '                , OrganizationConstants.OrgName _
        '                , Nothing _
        '                , Nothing _
        '                , True)

        'FillBaseReferenceDropDownList(ddlidfFaciltyHospital, BaseReferenceConstants.OrganizationName, HACodeList.HumanHACode, True)
        'FillDropDown(ddlidfFaciltyHospital _
        '                , GetType(clsOrganization) _
        '                , {"@OrganizationTypeID:" & "10504002", "@intHACode:" & HACodeList.HumanHACode} _
        '                , OrganizationConstants.idfInstitution _
        '                , OrganizationConstants.OrgName _
        '                , Nothing _
        '                , Nothing _
        '                , True)

        FillRadioButtonList(rblidfsYNPreviouslySoughtCare,
                    GetType(clsBaseReference),
                    {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode},
                    BaseReferenceConstants.idfsBaseReference,
                    BaseReferenceConstants.Name,
                    "10100002",
                    Nothing)
        rblidfsYNPreviouslySoughtCare.SelectedIndex = -1

        FillRadioButtonList(rblidfsYNHospitalization,
                    GetType(clsBaseReference),
                    {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode},
                    BaseReferenceConstants.idfsBaseReference,
                    BaseReferenceConstants.Name,
                    "10100002",
                    Nothing)
        rblidfsYNHospitalization.SelectedIndex = -1

        FillRadioButtonList(rblidfsYNSpecimenCollected,
                    GetType(clsBaseReference),
                    {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode},
                    BaseReferenceConstants.idfsBaseReference,
                    BaseReferenceConstants.Name,
                    "10100002",
                    Nothing)
        rblidfsYNSpecimenCollected.SelectedIndex = -1


        'Contacts
        '   BaseReferenceLookUp(ddlContactRelation, BaseReferenceConstants.ObjectTypeRelation, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlContactRelation, BaseReferenceConstants.PatientContactType, HACodeList.HumanHACode, True)
        ddlContactRelation.SelectedValue = 430000000

        'Human Report Status
        BaseReferenceLookUp(ddlidfsCaseProgressStatus, BaseReferenceConstants.CaseStatus, HACodeList.HumanHACode, False)

        'Human Disease Report Type
        BaseReferenceLookUp(ddlDiseaseReportTypeID, BaseReferenceConstants.CaseReportType, HACodeList.HumanHACode, False)

        'BaseReferenceLookUp(ddlAddFieldTestValidated, BaseReferenceConstants.YesNoValueList, HACodeList.NoneHACode, True)

        txtdatInterpretedDate.Text = Convert.ToDateTime(DateTime.Now.ToString())
        txtdatValidationDate.Text = Convert.ToDateTime(DateTime.Now.ToString())

        FillHdrSamplesList()
        FillHdrTestsList()
        FillVaccinationsList(bRefresh:=True)
        FillAntiviralTherapiesList(bRefresh:=True)
        FillContactsList(bRefresh:=True)
    End Sub

    Private Sub DisableControls()

        EnableForm(diseaseNotification, False)
        EnableForm(symptoms, False)
        EnableForm(facilityDetails, False)
        EnableForm(antibioticVaccineHistory, False)
        EnableForm(samplesTab, False)
        EnableForm(testsTab, False)
        EnableForm(caseDetails, False)
        EnableForm(riskFactors, False)
        EnableForm(contactList, False)
        EnableForm(finalOutcome, False)
        EnableForm(contactList, False)
        EnableForm(divYNHospitalization, False)

        txtdatDateOfDiagnosis.Enabled = False
        txtdatNotificationDate.Enabled = False
        txtstrCurrentLocation.Enabled = False
        txtdatOnSetDate.Enabled = False
        txtdatFirstSoughtCareDate.Enabled = False
        txtdatHospitalizationDate.Enabled = False
        txtdatDischargeDate.Enabled = False
        txdatFirstAdministeredDate.Enabled = False
        txtVaccinationDate.Enabled = False
        ddlidfsFinalState.Enabled = False
        txtStartDateofInvestigation.Enabled = False
        ddlidfsHospitalizationStatus.Enabled = False
        txtDateofPotentialExposure.Enabled = False
        txtDateofClassification.Enabled = False
        txtDateofDeath.Enabled = False
        txtstrSummaryNotes.Enabled = False
        txtstrEpidemiologistName.Enabled = False

        ddlidfHospital.Enabled = False
        txtstrCurrentLocation.Enabled = False
        ddlidfsInitialCaseStatus.Enabled = False
        ddlidfsHospitalizationStatus.Enabled = False
        ddlidfHospital.Enabled = False
        txtstrCurrentLocation.Enabled = False
        rblidfsYNHospitalization.Enabled = False

        gvAntiviralTherapies.Enabled = False
        gvVaccinations.Enabled = False
        gvSamples.Enabled = False
        gvTests.Enabled = False
        gvContacts.Enabled = False

        ddlidfsHospitalizationStatus.Attributes.Add("disabled", "disabled")
        ddlidfsInitialCaseStatus.Attributes.Add("disabled", "disabled")
        ddlidfsFinalDiagnosis.Attributes.Add("disabled", "disabled")
        ddlidfsFinalCaseStatus.Attributes.Add("disabled", "disabled")
        ddlidfsFinalState.Attributes.Add("disabled", "disabled")
        ddlidfsHospitalizationStatus.Attributes.Add("disabled", "disabled")
        ddlidfsNonNotifiableDiagnosis.Attributes.Add("disabled", "disabled")
        ddlGroundType.Attributes.Add("disabled", "disabled")
        ddlidfHospital.Attributes.Add("disabled", "disabled")
        ddlidfFaciltyHospital.Attributes.Add("disabled", "disabled")
        rblidfsYNPreviouslySoughtCare.Attributes.Add("disabled", "disabled")
        rblidfsYNPreviouslySoughtCare.Enabled = False
        rblidfsYNPreviouslySoughtCare.Items.Item(0).Enabled = False
        rblidfsYNPreviouslySoughtCare.Items.Item(1).Enabled = False
        rblidfsYNPreviouslySoughtCare.Items.Item(2).Enabled = False
        rblidfsYNHospitalization.Attributes.Add("disabled", "disabled")
        rblidfsYNHospitalization.Enabled = False
        rblidfsYNHospitalization.Items.Item(0).Enabled = False
        rblidfsYNHospitalization.Items.Item(1).Enabled = False
        rblidfsYNHospitalization.Items.Item(2).Enabled = False
        rblidfsYNSpecimenCollected.Attributes.Add("disabled", "disabled")
        rblidfsYNSpecimenCollected.Enabled = False
        rblidfsYNSpecimenCollected.Items.Item(0).Enabled = False
        rblidfsYNSpecimenCollected.Items.Item(1).Enabled = False
        rblidfsYNSpecimenCollected.Items.Item(2).Enabled = False
        rdbAntibioticAntiviralTherapyAdministeredYes.Enabled = False
        rdbAntibioticAntiviralTherapyAdministeredNo.Enabled = False
        rdbAntibioticAntiviralTherapyAdministeredUnknown.Enabled = False
        rdbSpecificVaccinationYes.Enabled = False
        rdbSpecificVaccinationNo.Enabled = False
        rdbSpecificVaccinationUnknown.Enabled = False
        ddlContactRelation.Attributes.Add("disabled", "disabled")
        'ddlidfsCaseProgressStatus.Enabled = False
        ddlDiseaseReportTypeID.Attributes.Add("disabled", "disabled")
        txtdatInterpretedDate.Attributes.Add("disabled", "disabled")
        txtdatValidationDate.Attributes.Add("disabled", "disabled")
        ddlOutcome.Attributes.Add("disabled", "disabled")
        cblBasisofDiagnosis.Enabled = False

        btnSampleNewAdd.Enabled = False
        btnHdrAddNewTest.Enabled = False
        btnAddAntiviralTherapy.Enabled = False
        btnAddVaccination.Enabled = False
        btnAddContact.Enabled = False


    End Sub

    Private Sub fillBasicSamplesModal()

        'fill Samples modal to default values
        BaseReferenceLookUp(masddlSampleType, BaseReferenceConstants.SampleType, HACodeList.HumanHACode, True)
        FillDropDown(ddlmasAddSampleSentTo,
            GetType(clsAdminOrganization),
            {},
             AdminOrganization.OfficeID,
             AdminOrganization.Name,
            AddBlankRow:=True)
        ddlmasAddSampleSentTo.SelectedItem.Selected = False

    End Sub
    Private Sub fillBasicTestsModal()
        'populate dropdown for selecting sample
        'ddlmatLocalSampleId
        Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        populateLookupSampleIdList(HdrSampleList)
        ddlmatLocalSampleId.DataTextField = "text"
        ddlmatLocalSampleId.DataValueField = "id"
        ddlmatLocalSampleId.DataSource = lookupSampleIdList
        ddlmatLocalSampleId.DataBind()

        'ViewState("recID_FieldTest") = -1
        BaseReferenceLookUp(ddlSampleTestName, BaseReferenceConstants.TestName, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlSampleTestCategory, BaseReferenceConstants.TestCategory, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlSampleTestResult, BaseReferenceConstants.TestResult, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlSampleTestDiagnosis, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, False)
        'BaseReferenceLookUp(ddlidfsSampleType, BaseReferenceConstants.SampleType, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlSampleTestStatus, BaseReferenceConstants.TestStatus, HACodeList.HumanHACode, True)

        FillDropDown(ddlAddFieldTestTestedByInstitution,
                    GetType(clsAdminOrganization),
                    {},
                     AdminOrganization.OfficeID,
                     AdminOrganization.Name,
                    AddBlankRow:=True)
        FillDropDown(ddlAddFieldTestTestedBy, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
        ddlSampleTestName.SelectedItem.Selected = False
        ddlSampleTestCategory.SelectedItem.Selected = False
        ddlSampleTestResult.SelectedItem.Selected = False
        ddlSampleTestDiagnosis.SelectedItem.Selected = False
        'ddlidfsSampleType.SelectedItem.Selected = False
        ddlSampleTestStatus.SelectedItem.Selected = True
        ddlSampleTestStatus.SelectedItem.Text = sampleTestStatusText
        txtstrSampleTestStatus.Text = sampleTestStatusText

        ddlAddFieldTestTestedByInstitution.Visible = False
        ddlAddFieldTestTestedBy.Visible = False
    End Sub

    Private Sub FillHdrSamplesList(Optional sGetDataFor As String = "GRIDROWS",
        Optional bRefresh As Boolean = False)

        Try
            Dim dsHdrSamples As New DataSet
            Dim HdrSampleList As New List(Of clsHumanDiseaseSample)

            'Save the data set in view state to re-use
            If bRefresh Then ViewState(HDR_SAMPLES_GvListDS) = Nothing

            If IsNothing(ViewState(HDR_SAMPLES_GvListDS)) Then
                If hdfidfHumanCase.Value.ToString().IsValueNullOrEmpty() = False Then
                    If HumanAPIService Is Nothing Then
                        HumanAPIService = New HumanServiceClient()
                    End If

                    Dim list = HumanAPIService.GetHumanSamples(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value), Long.Parse("0")).Result
                    dsHdrSamples.Tables.Add(ConvertListToDataTable(list))
                Else
                    Dim list = New List(Of HumSamplesGetListModel)()
                    dsHdrSamples.Tables.Add(ConvertListToDataTable(list))
                End If
            Else
                dsHdrSamples = CType(ViewState(HDR_SAMPLES_GvListDS), DataSet)
            End If

            gvSamples.DataSource = Nothing
            'convert stored proc results to List(clsHumanDiseaseSample)
            For Each r As DataRow In dsHdrSamples.Tables(0).Rows
                Dim li As New clsHumanDiseaseSample
                li.idfHumanCase = r.Item("idfHumanCase")
                li.idfMaterial = If(Not IsDBNull(r.Item("idfMaterial")), r.Item("idfMaterial"), Nothing)
                li.strBarcode = If(Not IsDBNull(r.Item("strBarcode")), r.Item("strBarcode"), Nothing)
                li.strFieldBarcode = If(Not IsDBNull(r.Item("strFieldBarcode")), r.Item("strFieldBarcode"), Nothing)
                li.idfsSampleType = If(Not IsDBNull(r.Item("idfsSampleType")), r.Item("idfsSampleType"), Nothing)
                li.strSampleTypeName = If(Not IsDBNull(r.Item("strSampleTypeName")), r.Item("strSampleTypeName"), Nothing)
                li.datFieldCollectionDate = If(Not IsDBNull(r.Item("datFieldCollectionDate")), r.Item("datFieldCollectionDate"), Nothing)
                li.idfSendToOffice = If(Not IsDBNull(r.Item("idfSendToOffice")), r.Item("idfSendToOffice"), Nothing)
                li.strSendToOffice = If(Not IsDBNull(r.Item("strSendToOffice")), r.Item("strSendToOffice"), Nothing)
                li.idfFieldCollectedByOffice = If(Not IsDBNull(r.Item("idfFieldCollectedByOffice")), r.Item("idfFieldCollectedByOffice"), Nothing)
                li.strFieldCollectedByOffice = If(Not IsDBNull(r.Item("strFieldCollectedByOffice")), r.Item("strFieldCollectedByOffice"), Nothing)
                li.datFieldSentDate = If(Not IsDBNull(r.Item("datFieldSentDate")), r.Item("datFieldSentDate"), Nothing)
                li.strNote = If(Not IsDBNull(r.Item("strNote")), r.Item("strNote"), Nothing)
                li.datAccession = If(Not IsDBNull(r.Item("datAccession")), r.Item("datAccession"), Nothing)
                li.idfsAccessionCondition = If(Not IsDBNull(r.Item("idfsAccessionCondition")), r.Item("idfsAccessionCondition"), Nothing)
                li.strCondition = If(Not IsDBNull(r.Item("strCondition")), r.Item("strCondition"), Nothing)
                li.idfsRegion = If(Not IsDBNull(r.Item("idfsRegion")), r.Item("idfsRegion"), Nothing)
                li.strRegionName = If(Not IsDBNull(r.Item("strRegionName")), r.Item("strRegionName"), Nothing)
                li.idfsRayon = If(Not IsDBNull(r.Item("idfsRayon")), r.Item("idfsRayon"), Nothing)
                li.strRayonName = If(Not IsDBNull(r.Item("strRayonName")), r.Item("strRayonName"), Nothing)
                li.blnAccessioned = If(Not IsDBNull(r.Item("blnAccessioned")), r.Item("blnAccessioned"), Nothing)
                li.RecordAction = If(Not IsDBNull(r.Item("RecordAction")), r.Item("RecordAction"), Nothing)
                li.idfsSampleKind = If(Not IsDBNull(r.Item("idfsSampleKind")), r.Item("idfsSampleKind"), Nothing)
                li.SampleKindTypeName = If(Not IsDBNull(r.Item("SampleKindTypeName")), r.Item("SampleKindTypeName"), Nothing)
                li.idfsSampleStatus = If(Not IsDBNull(r.Item("idfsSampleStatus")), r.Item("idfsSampleStatus"), Nothing)
                li.SampleStatusTypeName = If(Not IsDBNull(r.Item("SampleStatusTypeName")), r.Item("SampleStatusTypeName"), Nothing)
                li.idfFieldCollectedByPerson = If(Not IsDBNull(r.Item("idfFieldCollectedByPerson")), r.Item("idfFieldCollectedByPerson"), Nothing)
                li.datSampleStatusDate = If(Not IsDBNull(r.Item("datSampleStatusDate")), r.Item("datSampleStatusDate"), Nothing)
                li.sampleGuid = If(Not IsDBNull(r.Item("sampleGuid")), r.Item("sampleGuid"), Nothing)
                li.intRowStatus = If(Not IsDBNull(r.Item("intRowStatus")), r.Item("intRowStatus"), Nothing)
                HdrSampleList.Add(li)
            Next
            ViewState(HDR_SAMPLES_GvList) = HdrSampleList
            gvSamples.DataSource = HdrSampleList
            gvSamples.DataBind()

            If gvSamples.Rows.Count > 0 Then
                btnHdrAddNewTest.Enabled = True
            Else
                btnHdrAddNewTest.Enabled = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Sub FillHdrTestsList(Optional sGetDataFor As String = "GRIDROWS",
        Optional bRefresh As Boolean = False)
        Try
            Dim dsHdrTests As New DataSet
            Dim HdrTestList As New List(Of clsHumanDiseaseTest)
            'Save the data set in view state to re-use
            If bRefresh Then ViewState(HDR_TESTS_GvListDS) = Nothing
            If IsNothing(ViewState(HDR_TESTS_GvListDS)) Then
                If hdfidfHumanCase.Value.ToString().IsValueNullOrEmpty() = False Then
                    If HumanAPIService Is Nothing Then
                        HumanAPIService = New HumanServiceClient()
                    End If

                    Dim list = HumanAPIService.GetHumanDiseaseTests(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value), Long.Parse("0")).Result
                    dsHdrTests.Tables.Add(ConvertListToDataTable(list))
                Else
                    Dim list = New List(Of HumTestsGetListModel)()
                    dsHdrTests.Tables.Add(ConvertListToDataTable(list))
                End If
            Else
                dsHdrTests = CType(ViewState(HDR_TESTS_GvListDS), DataSet)
            End If

            gvTests.DataSource = Nothing
            'convert stored proc results to List(clsHumanDiseaseTest
            For Each r As DataRow In dsHdrTests.Tables(0).Rows
                Dim li As New clsHumanDiseaseTest
                li.idfHumanCase = r.Item("idfHumanCase")
                li.idfMaterial = r.Item("idfMaterial")
                li.strBarcode = r.Item("strBarcode")
                li.strFieldBarcode = r.Item("strFieldBarcode")
                li.idfsSampleType = r.Item("idfsSampleType")
                li.strSampleTypeName = r.Item("strSampleTypeName")
                li.datFieldCollectionDate = r.Item("datFieldCollectionDate")
                li.idfSendToOffice = r.Item("idfSendToOffice")
                li.strSendToOffice = r.Item("strSendToOffice")
                li.idfFieldCollectedByOffice = r.Item("idfFieldCollectedByOffice")
                li.strFieldCollectedByOffice = r.Item("strFieldCollectedByOffice")
                li.datFieldSentDate = r.Item("datFieldSentDate")
                li.idfsSampleKind = r.Item("idfsSampleKind")
                li.SampleKindTypeName = r.Item("SampleKindTypeName")
                li.idfsSampleStatus = r.Item("idfsSampleStatus")
                li.SampleStatusTypeName = r.Item("SampleStatusTypeName")
                li.idfFieldCollectedByPerson = r.Item("idfFieldCollectedByPerson")
                li.datSampleStatusDate = r.Item("datSampleStatusDate")
                li.sampleGuid = r.Item("sampleGuid")
                li.idfTesting = r.Item("idfTesting")
                li.idfsTestName = r.Item("idfsTestName")
                li.idfsTestCategory = r.Item("idfsTestCategory")
                li.idfsTestResult = r.Item("idfsTestResult")
                li.idfsTestStatus = r.Item("idfsTestStatus")
                li.idfsDiagnosis = r.Item("idfsDiagnosis")
                li.strTestStatus = r.Item("strTestStatus")
                li.strTestResult = r.Item("strTestResult")
                li.name = r.Item("name")
                li.datReceivedDate = r.Item("datReceivedDate")
                li.datConcludedDate = r.Item("datConcludedDate")
                li.idfTestedByPerson = r.Item("idfTestedByPerson")
                li.idfTestedByOffice = r.Item("idfTestedByOffice")
                li.idfsInterpretedStatus = r.Item("idfsInterpretedStatus")
                li.strInterpretedStatus = r.Item("strInterpretedStatus")
                li.strInterpretedComment = r.Item("strInterpretedComment")
                li.datInterpretedDate = r.Item("datInterpretedDate")
                li.strInterpretedBy = r.Item("strInterpretedBy")
                li.blnValidateStatus = r.Item("blnValidateStatus")
                li.strValidateComment = r.Item("strValidateComment")
                li.datValidationDate = r.Item("datValidationDate")
                li.strValidatedBy = r.Item("strValidatedBy")
                li.strAccountName = r.Item("strAccountName")
                li.testGuid = r.Item("testGuid")
                li.intRowStatus = r.Item("intRowStatus")
                HdrTestList.Add(li)
            Next
            ViewState(HDR_TESTS_GvList) = HdrTestList
            gvTests.DataSource = HdrTestList
            gvTests.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub


    Private Sub FillVaccinationsList(Optional sGetDataFor As String = "GRIDROWS",
        Optional bRefresh As Boolean = False)

        Try
            Dim dsVaccinations As New DataSet
            Dim HdrVaccinationsList As New List(Of clsHumanDiseaseVaccination)

            'Save the data set in view state to re-use
            If bRefresh Then ViewState(HDR_VACCINATIONS_GvListDS) = Nothing

            If IsNothing(ViewState(HDR_VACCINATIONS_GvListDS)) Then
                If hdfidfHumanCase.Value.ToString().IsValueNullOrEmpty() = False Then
                    If HumanAPIService Is Nothing Then
                        HumanAPIService = New HumanServiceClient()
                    End If

                    Dim list = HumanAPIService.HumDiseaseVaccinationsGetListAsync(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value)).Result
                    dsVaccinations.Tables.Add(ConvertListToDataTable(list))
                Else
                    Dim list = New List(Of HumDiseaseVaccinationsGetListModel)()
                    dsVaccinations.Tables.Add(ConvertListToDataTable(list))
                End If
            Else
                dsVaccinations = CType(ViewState(HDR_VACCINATIONS_GvListDS), DataSet)
            End If

            gvVaccinations.DataSource = Nothing
            'If dsVaccinations.CheckDataSet() Then
            'convert stored proc results to List(clsHumanDiseaseSample)
            For Each r As DataRow In dsVaccinations.Tables(0).Rows
                Dim li As New clsHumanDiseaseVaccination
                li.humanDiseaseReportVaccinationUID = r.Item("humanDiseaseReportVaccinationUID")
                li.idfHumanCase = r.Item("idfHumanCase")
                li.vaccinationName = r.Item("VaccinationName")
                li.vaccinationDate = r.Item("VaccinationDate")

                HdrVaccinationsList.Add(li)
            Next
            ViewState(HDR_VACCINATIONS_GvList) = HdrVaccinationsList
            gvVaccinations.DataSource = HdrVaccinationsList
            gvVaccinations.DataBind()
            If gvVaccinations.Rows.Count > 0 Then
                rdbSpecificVaccinationYes.Checked = True
                pnlSpecialVaccination.Visible = True
            End If
            '  End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Private Sub FillAntiviralTherapiesList(Optional sGetDataFor As String = "GRIDROWS",
        Optional bRefresh As Boolean = False)

        Try
            Dim dsAntiviralTherapies As New DataSet
            Dim HdrAntiviralTherapiesList As New List(Of clsHumanDiseaseAntiviralThearapy)

            'Save the data set in view state to re-use
            If bRefresh Then ViewState(HDR_ANTIVIRALTHERAPIES_GvListDS) = Nothing

            If IsNothing(ViewState(HDR_ANTIVIRALTHERAPIES_GvListDS)) Then
                If hdfidfHumanCase.Value.ToString().IsValueNullOrEmpty() = False Then
                    If HumanAPIService Is Nothing Then
                        HumanAPIService = New HumanServiceClient()
                    End If

                    Dim list = HumanAPIService.HumDiseaseAntiviraltherapiesGetListAsync(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value)).Result
                    dsAntiviralTherapies.Tables.Add(ConvertListToDataTable(list))
                Else
                    Dim list = New List(Of HumDiseaseAntiviraltherapiesGetListModel)()
                    dsAntiviralTherapies.Tables.Add(ConvertListToDataTable(list))
                End If
            Else
                dsAntiviralTherapies = CType(ViewState(HDR_ANTIVIRALTHERAPIES_GvListDS), DataSet)
            End If

            gvAntiviralTherapies.DataSource = Nothing
            ' If dsAntiviralTherapies.CheckDataSet() Then
            'convert stored proc results to List(clsHumanDiseaseSample)
            For Each r As DataRow In dsAntiviralTherapies.Tables(0).Rows
                Dim li As New clsHumanDiseaseAntiviralThearapy
                li.idfAntimicrobialTherapy = r.Item("idfAntimicrobialTherapy")
                li.idfHumanCase = r.Item("idfHumanCase")
                li.strAntimicrobialTherapyName = r.Item("strAntimicrobialTherapyName")
                li.strDosage = r.Item("strDosage")
                li.datFirstAdministeredDate = r.Item("datFirstAdministeredDate")

                HdrAntiviralTherapiesList.Add(li)
            Next

            ViewState(HDR_ANTIVIRALTHERAPIES_GvList) = HdrAntiviralTherapiesList
            gvAntiviralTherapies.DataSource = HdrAntiviralTherapiesList
            gvAntiviralTherapies.DataBind()
            If gvAntiviralTherapies.Rows.Count > 0 Then
                rdbAntibioticAntiviralTherapyAdministeredYes.Checked = True
                pnlAntiBioticAdministred.Visible = True
            End If
            ' End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Private Function populateLookupDiagHaCodeList(dt1 As DataTable) As List(Of clsRefIntList)
        For Each row As DataRow In dt1.Rows
            Dim newItem As clsRefIntList = New clsRefIntList()
            newItem.id = row.Item(0)
            newItem.numericValue = row.Item(5)
            lookupDiagHaCodeList.Add(newItem)
        Next
        ViewState("lookupDiagHaCodeList") = lookupDiagHaCodeList
        Return lookupDiagHaCodeList
    End Function

    Private Sub populateLookupSampleIdList(ByRef sampleList As List(Of clsHumanDiseaseSample))
        lookupSampleIdList.Clear()
        'add blank item to dropdown list
        Dim newItem As clsRefGuidStringList = New clsRefGuidStringList()
        newItem.id = Nothing
        newItem.text = String.Empty
        lookupSampleIdList.Add(newItem)
        For Each r As clsHumanDiseaseSample In sampleList.OrderBy(Function(x) x.strFieldBarcode).ToList()
            Dim i As clsRefGuidStringList = New clsRefGuidStringList()
            i.id = r.sampleGuid
            'i.text = r.strBarcode
            i.text = r.strFieldBarcode
            lookupSampleIdList.Add(i)
        Next

        ViewState("lookupSampleIdList") = lookupSampleIdList
    End Sub

    Protected Sub ddlidfsFinalDiagnosis_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsFinalDiagnosis.SelectedIndexChanged
        If hdfNewNotifiableDiseaseFlag.Value = "1" Then
            ddlidfsFinalDiagnosis.Enabled = True
        End If
        txtSummaryDiagnosis.Text = ddlidfsFinalDiagnosis.SelectedItem.Text
        If Not hdfidfHumanCaseCopy.Value = "" Then
            hdfparentHumanDiseaseReportID.Value = hdfidfHumanCaseCopy.Value
            hdfrelatedHumanDiseaseReportIdList.Value = ""
            FillDiseaseReportSummaryRelated()
            'hdfidfHumanCaseCopy.Value = ""
        End If
        SetControls()
        'If Page.IsPostBack Then
        Validate()
        'End If

        'Check syndromic Surveillance condition is selected (ILI or SARD) condition
        hdfIsDiagnosisSyndromic.Value = "0"
        If (ddlidfsFinalDiagnosis.Text = "10019001" Or ddlidfsFinalDiagnosis.Text = "10019002") Then
            hdfIsDiagnosisSyndromic.Value = "1"
            ddlidfsInitialCaseStatus.Enabled = False
            ddlidfsFinalCaseStatus.Enabled = False
        End If

        'rdbPatientPreviouslySoughtYes.Attributes.Add("disabled", "disabled")
        HumanDiseaseFlexFormRiskFactors.DiagnosisID = CType(ddlidfsFinalDiagnosis.SelectedValue, Long)
        FlexFormSymptoms.DiagnosisID = CType(ddlidfsFinalDiagnosis.SelectedValue, Long)


        If hdfidfCSObservation.Value = "0" OrElse hdfidfCSObservation.Value = "" OrElse hdfidfCSObservation.Value = "null" Then
            HumanDiseaseFlexFormRiskFactors.ObservationID = 0
        Else
            HumanDiseaseFlexFormRiskFactors.ObservationID = Long.Parse(hdfidfCSObservation.Value)
        End If

        If hdfidfEpiObservation.Value = "0" OrElse hdfidfEpiObservation.Value = "" OrElse hdfidfEpiObservation.Value = "null" Then
            FlexFormSymptoms.ObservationID = 0
        Else
            FlexFormSymptoms.ObservationID = Long.Parse(hdfidfEpiObservation.Value)
        End If

    End Sub

    '    hdfidfSentByOffice.Value = ddlNotificationSentBy.Text
    '    'If Page.IsPostBack Then
    '    Validate()

    'End Sub
    Protected Sub ddlNotificationSentBy_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNotificationSentBy.SelectedIndexChanged

        hdfNotificationSentBySelected.Value = "0"
        If ddlNotificationSentBy.SelectedIndex > 0 Then
            hdfNotificationSentBySelected.Value = "1"
        End If

    End Sub

    'Protected Sub ddlNotificationSentByName_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNotificationSentByName.SelectedIndexChanged

    '    hdfidfSentByPerson.Value = ddlNotificationSentByName.Text
    '    'If Page.IsPostBack Then
    '    Validate()

    'End Sub
    'Protected Sub ddlNotificationReceivedBy_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNotificationReceivedBy.SelectedIndexChanged

    '    hdfidfReceivedByOffice.Value = ddlNotificationReceivedBy.Text
    '    'If Page.IsPostBack Then
    '    Validate()

    'End Sub
    'Protected Sub ddlNotificationReceivedByName_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNotificationReceivedByName.SelectedIndexChanged

    '    hdfidfReceivedByPerson.Value = ddlNotificationSentByName.Text
    '    'If Page.IsPostBack Then
    '    Validate()

    'End Sub

    Protected Sub chkblnFilterTestNameByDisease_CheckedChanged(sender As Object, e As EventArgs) Handles chkblnFilterTestNameByDisease.CheckedChanged
        If chkblnFilterTestNameByDisease.Checked Then
            BaseReferenceLookUp(ddlSampleTestName, BaseReferenceConstants.TestName, HACodeList.HumanHACode, True)

        Else
            BaseReferenceLookUp(ddlSampleTestName, BaseReferenceConstants.TestName, HACodeList.HumanHACode, True)
        End If
    End Sub

    Protected Function ConvertToDataTable(Of T)(list As IList(Of T)) As DataTable
        Dim entityType As Type = GetType(T)
        Dim table As New DataTable()
        For Each item As T In list
            Dim row As DataRow = table.NewRow()
            table.Rows.Add(row)
        Next
        Return table
    End Function

    Private Sub FillDiseaseForEdit(ByVal disID As String)
        Dim dsDis As DataSet = New DataSet()
        Dim oCommon As New clsCommon()
        Dim list = New List(Of HumDiseaseGetDetailModel)()
        Dim strLangID As String = GetCurrentLanguage()

        Try

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            list = HumanAPIService.GetHumanDiseaseDetail(strLangID, Long.Parse(disID.ToString)).Result
            dsDis.Tables.Add(ConvertListToDataTable(list))
            oCommon.Scatter(divHiddenFieldsSection, New DataTableReader(dsDis.Tables(0)))
            oCommon.Scatter(disease, New DataTableReader(dsDis.Tables(0)))
            hdfstrHumanCaseId.Value = hdfstrCaseId.Value

            ddlNotificationSentBy.SelectedValue = hdfidfSentByOffice.Value
            ddlNotificationSentByName.SelectedValue = hdfidfSentByPerson.Value
            ddlNotificationReceivedBy.SelectedValue = hdfidfReceivedByOffice.Value
            ddlNotificationReceivedByName.SelectedValue = hdfidfReceivedByPerson.Value
            ddlnvestigationNameOrganization.SelectedValue = hdfidfInvestigatedByOffice.Value
            ddlidfFaciltyHospital.SelectedItem.Text = hdfstrHospitalizationPlace.Value


            If (ddlidfsHospitalizationStatus.SelectedValue = "5350000000") Then
                pnlHospitalization.Visible = True
                hospital.Visible = True

            ElseIf (ddlidfsHospitalizationStatus.SelectedValue = "5360000000") Then
                otherLocation.Visible = True
                'rblidfsYNHospitalization.SelectedValue = "10100002"
                'pnlPatientPreviouslySought.Visible = False
                'txtdatFirstSoughtCareDate.Enabled = False
                'txtFacilityFirstSoughtCare.Enabled = False
                'ddlidfsNonNotifiableDiagnosis.Enabled = False
            ElseIf (ddlidfsHospitalizationStatus.SelectedValue = "10041001") Then
                'rblidfsYNHospitalization.SelectedValue = "10100003"
                'pnlPatientPreviouslySought.Visible = False
                'txtdatFirstSoughtCareDate.Enabled = False
                'txtFacilityFirstSoughtCare.Enabled = False
                'ddlidfsNonNotifiableDiagnosis.Enabled = False
            End If

            If Not list.FirstOrDefault().idfsYNPreviouslySoughtCare Is Nothing Then
                hdfidfsYNPreviouslySoughtCare.Value = list.FirstOrDefault().idfsYNPreviouslySoughtCare.ToString
            End If

            If Not list.FirstOrDefault().idfsYNHospitalization Is Nothing Then
                hdfidfsYNHospitalization.Value = list.FirstOrDefault().idfsYNHospitalization.ToString
            End If

            If Not String.IsNullOrEmpty(hdfdatFinalDiagnosisDate.Value) Then
                txtdatDateOfDiagnosis.Text = hdfdatFinalDiagnosisDate.Value
            End If

            If Not String.IsNullOrEmpty(hdfidfsOutcome.Value) Then
                ' ddlOutcome.SelectedItem.Value = hdfidfsOutcome.Value
                If hdfidfsOutcome.Value = "10760000000" Then
                    ddlOutcome.SelectedItem.Text = "Recovered"
                ElseIf hdfidfsOutcome.Value = "10770000000" Then
                    ddlOutcome.SelectedItem.Text = "Died"
                ElseIf hdfidfsOutcome.Value = "10780000000" Then
                    ddlOutcome.SelectedItem.Text = "Unknown"
                End If
            End If

            If Not String.IsNullOrEmpty(hdfdatExposureDate.Value) Then
                txtDateofPotentialExposure.Text = hdfdatExposureDate.Value
            End If

            ' If String.IsNullOrEmpty(txtstrSummaryNotes.Text) Then
            If txtstrSummaryNotes.Text.Length <3 Then
                txtstrSummaryNotes.Text= String.Empty
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Sub FillRelatedDiseaseForEdit(ByVal disID As String)
        Dim dsDis As DataSet = New DataSet()
        Dim oCommon As New clsCommon()
        Dim list = New List(Of HumDiseaseGetDetailModel)()
        Dim strLangID As String = GetCurrentLanguage()

        Try

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            list = HumanAPIService.GetHumanDiseaseDetail(strLangID, Long.Parse(disID.ToString)).Result
            dsDis.Tables.Add(ConvertListToDataTable(list))
            oCommon.Scatter(rldstrCaseId, New DataTableReader(dsDis.Tables(0)))
            'oCommon.Scatter(disease, New DataTableReader(dsDis.Tables(0)))
            'hdfstrHumanCaseId.Value = hdfstrCaseId.Value

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Function AddDisease() As Integer
        'recover idf value
        Try
            Dim oCommon As New clsCommon()
            Dim oService As NG.EIDSSService = oCommon.GetService()
            Dim aSpD As String() = oService.getSPList("DiseaseSet")
            Dim disValues As String = ""
            Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
            Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
            Dim HdrAntiviralThearapyList As List(Of clsHumanDiseaseAntiviralThearapy) = TryCast(ViewState(HDR_ANTIVIRALTHERAPIES_GvList), List(Of clsHumanDiseaseAntiviralThearapy))
            Dim HdrVaccinationList As List(Of clsHumanDiseaseVaccination) = TryCast(ViewState(HDR_VACCINATIONS_GvList), List(Of clsHumanDiseaseVaccination))
            Dim HdrContactList As List(Of clsHumanDiseaseContact) = TryCast(ViewState(HDR_CONTACTS_GvList), List(Of clsHumanDiseaseContact))

            Dim ds As New DataSet()

            Dim result = 0
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If
            Dim list = New List(Of HumHumanDiseaseSetModel)
            Dim parameters As HumanDiseaseSetParams
            parameters = New HumanDiseaseSetParams()

            hdfidfSentByOffice.Value = ddlNotificationSentBy.Text
            hdfidfSentByPerson.Value = ddlNotificationSentByName.Text
            hdfidfReceivedByOffice.Value = ddlNotificationReceivedBy.Text
            hdfidfReceivedByPerson.Value = ddlNotificationReceivedByName.Text
            hdfidfInvestigatedByOffice.Value = ddlnvestigationNameOrganization.Text
            hdfstrHospitalizationPlace.Value = ddlidfFaciltyHospital.SelectedItem.Text

            parameters = Gather(Me, parameters, 3)

            If hdfNewNotifiableDiseaseFlag.Value = "1" Then
                hdfidfHumanCase.Value = String.Empty
                parameters.idfHumanCase = Nothing
                If Not String.IsNullOrEmpty(hdfidfHumanCaseCopy.Value) Then
                    parameters.idfHumanCaseRelatedTo = Convert.ToInt64(hdfidfHumanCaseCopy.Value)
                End If
                hdfstrHumanCaseId.Value = "(New)"
                parameters.strHumanCaseId = "(New)"
                'parameters.datDateOfDiagnosis = Nothing

            End If

            parameters.idfHospital = Nothing
            parameters.idfsHospitalizationStatus = Nothing
            parameters.idfsYNHospitalization = Nothing
            If Not ddlidfFaciltyHospital.SelectedIndex = -1 Then
                If Not ddlidfFaciltyHospital.SelectedItem.Value = "Null" Then
                    parameters.idfHospital = Long.Parse(ddlidfFaciltyHospital.SelectedItem.Value)
                End If
            End If

            If Not rblidfsYNHospitalization.SelectedIndex = -1 Then
                ''Hospitalization Yes
                If rblidfsYNHospitalization.SelectedItem.Value = "10100001" Then
                    parameters.idfsHospitalizationStatus = 5350000000
                End If

                ''Hospitalization No
                If rblidfsYNHospitalization.SelectedItem.Value = "10100002" Then
                    parameters.idfsHospitalizationStatus = 5360000000
                End If

                ''Hospitalization Unknown
                If rblidfsYNHospitalization.SelectedItem.Value = "10100003" Then
                    parameters.idfsHospitalizationStatus = 10041001
                End If
            End If


            If Not ddlOutcome.SelectedIndex = -1 Then
                If ddlOutcome.SelectedItem.Text = "Recovered" Then
                    parameters.idfsOutcome = 10760000000
                ElseIf ddlOutcome.SelectedItem.Text = "Died" Then
                    parameters.idfsOutcome = 10770000000
                ElseIf ddlOutcome.SelectedItem.Text = "Unknown" Then
                    parameters.idfsOutcome = 10780000000
                End If
            End If

            If Not String.IsNullOrEmpty(txtDateofPotentialExposure.Text) Then
                parameters.datExposureDate = txtDateofPotentialExposure.Text
            End If

            'Add Samples collection to Sample Paramters for Client API
            parameters.SamplesParameters = New List(Of SampleParameters)()
            Dim sampleParameters As New SampleParameters
            sampleParameters = New SampleParameters()

            If Not HdrSampleList Is Nothing Then

                For Each item As clsHumanDiseaseSample In HdrSampleList
                    sampleParameters.blnAccessioned = item.blnAccessioned
                    sampleParameters.datAccession = item.datAccession
                    sampleParameters.datFieldCollectionDate = item.datFieldCollectionDate
                    sampleParameters.datFieldSentDate = item.datFieldSentDate
                    sampleParameters.datSampleStatusDate = item.datSampleStatusDate
                    sampleParameters.idfFieldCollectedByOffice = item.idfFieldCollectedByOffice
                    sampleParameters.idfFieldCollectedByPerson = item.idfFieldCollectedByPerson
                    sampleParameters.idfHumanCase = item.idfHumanCase
                    If hdfNewNotifiableDiseaseFlag.Value = "1" Then
                        sampleParameters.idfHumanCase = Nothing
                    End If
                    If item.idfMaterial = 0 Then
                        sampleParameters.idfMaterial = Nothing
                    Else
                        sampleParameters.idfMaterial = item.idfMaterial
                    End If
                    sampleParameters.idfsAccessionCondition = item.idfsAccessionCondition
                    sampleParameters.idfSendToOffice = item.idfSendToOffice
                    sampleParameters.idfsRayon = item.idfsRayon
                    sampleParameters.idfsRegion = item.idfsRegion
                    sampleParameters.idfsSampleKind = item.idfsSampleKind
                    sampleParameters.idfsSampleStatus = item.idfsSampleStatus
                    sampleParameters.idfsSampleType = item.idfsSampleType
                    sampleParameters.intRowStatus = item.intRowStatus
                    sampleParameters.RecordAction = item.RecordAction
                    sampleParameters.sampleGuid = item.sampleGuid
                    sampleParameters.SampleKindTypeName = item.SampleKindTypeName
                    sampleParameters.SampleStatusTypeName = item.SampleStatusTypeName
                    sampleParameters.strBarcode = item.strBarcode
                    sampleParameters.strCondition = item.strCondition
                    sampleParameters.strFieldBarcode = item.strFieldBarcode
                    sampleParameters.strFieldCollectedByOffice = item.strFieldCollectedByOffice
                    sampleParameters.strNote = item.strNote
                    sampleParameters.strRayonName = item.strRayonName
                    sampleParameters.strRegionName = item.strRegionName
                    sampleParameters.strSampleTypeName = item.strSampleTypeName
                    sampleParameters.strSendToOffice = item.strSendToOffice

                    parameters.SamplesParameters.Add(sampleParameters)
                Next
            End If


            'Add Samples collection to Sample Paramters for Client API
            parameters.TestsParameters = New List(Of TestParameters)()
            Dim testParameters As New TestParameters
            testParameters = New TestParameters()

            If Not HdrTestList Is Nothing Then

                For Each item As clsHumanDiseaseTest In HdrTestList
                    testParameters.idfHumanCase = item.idfHumanCase
                    If hdfNewNotifiableDiseaseFlag.Value = "1" Then
                        testParameters.idfHumanCase = Nothing
                    End If
                    If item.idfMaterial = 0 Then
                        testParameters.idfMaterial = Nothing
                    Else
                        testParameters.idfMaterial = item.idfMaterial
                    End If
                    testParameters.strBarcode = item.strBarcode
                    testParameters.strFieldBarcode = item.strFieldBarcode
                    testParameters.idfsSampleType = item.idfsSampleType
                    testParameters.strSampleTypeName = item.strSampleTypeName
                    testParameters.datFieldCollectionDate = item.datFieldCollectionDate
                    testParameters.idfSendToOffice = item.idfSendToOffice
                    testParameters.strSendToOffice = item.strSendToOffice
                    testParameters.idfFieldCollectedByOffice = item.idfFieldCollectedByOffice
                    testParameters.strFieldCollectedByOffice = item.strFieldCollectedByOffice
                    testParameters.datFieldSentDate = item.datFieldSentDate
                    testParameters.idfsSampleKind = item.idfsSampleKind
                    testParameters.SampleKindTypeName = item.SampleKindTypeName
                    testParameters.idfsSampleStatus = item.idfsSampleStatus
                    testParameters.SampleStatusTypeName = item.SampleStatusTypeName
                    testParameters.idfFieldCollectedByPerson = item.idfFieldCollectedByPerson
                    testParameters.datSampleStatusDate = item.datSampleStatusDate
                    testParameters.sampleGuid = item.sampleGuid
                    testParameters.idfTesting = item.idfTesting
                    testParameters.idfsTestName = item.idfsTestName
                    testParameters.idfsTestCategory = item.idfsTestCategory
                    testParameters.idfsTestResult = item.idfsTestResult
                    testParameters.idfsTestStatus = item.idfsTestStatus
                    testParameters.idfsDiagnosis = item.idfsDiagnosis
                    testParameters.strTestStatus = item.strTestStatus
                    testParameters.strTestResult = item.strTestResult
                    testParameters.name = item.name
                    testParameters.datReceivedDate = item.datReceivedDate
                    testParameters.datConcludedDate = item.datConcludedDate
                    testParameters.idfTestedByPerson = item.idfTestedByPerson
                    testParameters.idfTestedByOffice = item.idfTestedByOffice
                    testParameters.idfsInterpretedStatus = item.idfsInterpretedStatus
                    testParameters.strInterpretedStatus = item.strInterpretedStatus
                    testParameters.strInterpretedComment = item.strInterpretedComment
                    testParameters.datInterpretedDate = item.datInterpretedDate
                    testParameters.strInterpretedBy = item.strInterpretedBy
                    testParameters.blnValidateStatus = item.blnValidateStatus
                    testParameters.strValidateComment = item.strValidateComment
                    testParameters.datValidationDate = item.datValidationDate
                    testParameters.strValidatedBy = item.strValidatedBy
                    testParameters.strAccountName = item.strAccountName
                    testParameters.testGuid = item.testGuid
                    'testParameters.intRowStatus = item.intRowStatus

                    parameters.TestsParameters.Add(testParameters)
                Next

            End If

            'Add Antiviral Therapy collection to AntiviralTherapy Paramters for Client API
            parameters.AntiviralTherapiesParameters = New List(Of AntiviralTherapyParameters)()
            Dim antiviralTherapyParameters As New AntiviralTherapyParameters
            antiviralTherapyParameters = New AntiviralTherapyParameters()

            If Not HdrAntiviralThearapyList Is Nothing Then
                For Each item As clsHumanDiseaseAntiviralThearapy In HdrAntiviralThearapyList
                    If item.idfAntimicrobialTherapy = 0 Then
                        antiviralTherapyParameters.idfAntimicrobialTherapy = Nothing
                    Else
                        antiviralTherapyParameters.idfAntimicrobialTherapy = item.idfAntimicrobialTherapy
                    End If
                    antiviralTherapyParameters.idfHumanCase = item.idfHumanCase
                    If hdfNewNotifiableDiseaseFlag.Value = "1" Then
                        antiviralTherapyParameters.idfHumanCase = Nothing
                    End If
                    antiviralTherapyParameters.strAntimicrobialTherapyName = item.strAntimicrobialTherapyName
                    antiviralTherapyParameters.strDosage = item.strDosage
                    antiviralTherapyParameters.datFirstAdministeredDate = item.datFirstAdministeredDate

                    parameters.AntiviralTherapiesParameters.Add(antiviralTherapyParameters)
                Next

            End If

            'Add Vaccination collection to Vaccination Paramters for Client API
            parameters.VaccinationsParameters = New List(Of VaccinationParameters)()
            Dim vaccinationParameters As New VaccinationParameters
            vaccinationParameters = New VaccinationParameters()

            If Not HdrVaccinationList Is Nothing Then
                For Each item As clsHumanDiseaseVaccination In HdrVaccinationList
                    If item.humanDiseaseReportVaccinationUID = 0 Then
                        vaccinationParameters.idfHumanCase = Nothing
                    Else
                        vaccinationParameters.idfHumanCase = item.idfHumanCase
                    End If
                    vaccinationParameters.HumanDiseaseReportVaccinationUID = item.humanDiseaseReportVaccinationUID
                    vaccinationParameters.idfHumanCase = item.idfHumanCase
                    If hdfNewNotifiableDiseaseFlag.Value = "1" Then
                        vaccinationParameters.idfHumanCase = Nothing
                    End If
                    vaccinationParameters.VaccinationDate = item.vaccinationDate
                    vaccinationParameters.VaccinationName = item.vaccinationName

                    parameters.VaccinationsParameters.Add(vaccinationParameters)
                Next
            End If

            'Add Contacts collection to Contacts Paramters for Client API
            parameters.ContactsParameters = New List(Of ContactParameters)()
            Dim contactsParameters As New ContactParameters
            contactsParameters = New ContactParameters()

            If Not HdrContactList Is Nothing Then
                For Each item As clsHumanDiseaseContact In HdrContactList
                    If item.idfContactedCasePerson = 0 Then
                        contactsParameters.idfContactedCasePerson = Nothing
                    Else
                        contactsParameters.idfContactedCasePerson = item.idfContactedCasePerson
                    End If
                    If Not String.IsNullOrEmpty(hdfidfHuman.Value) Then
                        contactsParameters.idfHuman = hdfidfHuman.Value.ToInt64
                    End If
                    contactsParameters.idfHumanCase = item.idfHumanCase
                    contactsParameters.idfHumanActual = item.idfHumanActual
                    contactsParameters.intRowStatus = item.intRowStatus
                    contactsParameters.rowguid = Nothing
                    contactsParameters.strComments = item.strComments
                    contactsParameters.strContactPersonFullName = item.strContactPersonFullName
                    contactsParameters.strFirstName = item.strFirstName
                    contactsParameters.strSecondName = item.strSecondName
                    contactsParameters.strLastName = item.strLastName
                    contactsParameters.strMaintenanceFlag = item.strMaintenanceFlag
                    contactsParameters.strPlaceInfo = item.strPlaceInfo
                    contactsParameters.strReservedAttribute = item.strReservedAttribute
                    contactsParameters.datDateOfLastContact = item.datDateOfLastContact
                    parameters.ContactsParameters.Add(contactsParameters)
                Next
            End If

            If (parameters.datDateOfDiagnosis = DateTime.MinValue) Then
                parameters.datDateOfDiagnosis = Nothing
            End If

            If (parameters.datDischargeDate = DateTime.MinValue) Then
                parameters.datDischargeDate = Nothing
            End If

            If (parameters.dateofClassification = DateTime.MinValue) Then
                parameters.dateofClassification = Nothing
            End If

            If (parameters.datExposureDate = DateTime.MinValue) Then
                parameters.datExposureDate = Nothing
            End If

            If (parameters.datNotificationDate = DateTime.MinValue) Then
                parameters.datNotificationDate = Nothing
            End If

            If (parameters.datHospitalizationDate = DateTime.MinValue) Then
                parameters.datHospitalizationDate = Nothing
            End If

            If (parameters.datFirstAdministeredDate = DateTime.MinValue) Then
                parameters.datFirstAdministeredDate = Nothing
            End If

            If (parameters.datFirstSoughtCareDate = DateTime.MinValue) Then
                parameters.datFirstSoughtCareDate = Nothing
            End If

            If (parameters.datOnSetDate = DateTime.MinValue) Then
                parameters.datOnSetDate = Nothing
            End If

            If (parameters.datDateofDeath = DateTime.MinValue) Then
                parameters.datDateofDeath = Nothing
            End If

            If (parameters.idfsYNHospitalization = 0) Then
                parameters.idfsYNHospitalization = Nothing
            End If

            If (parameters.idfHospital = 0) Then
                parameters.idfHospital = Nothing
            End If
            If (parameters.idfInvestigatedByOffice = 0) Then
                parameters.idfInvestigatedByOffice = Nothing
            End If
            If (parameters.idfOutbreak = 0) Then
                parameters.idfOutbreak = Nothing
            End If
            If (parameters.idfPointGeoLocation = 0) Then
                parameters.idfPointGeoLocation = Nothing
            End If
            If (parameters.idfReceivedByOffice = 0) Then
                parameters.idfReceivedByOffice = Nothing
            End If
            If (parameters.idfsCaseProgressStatus = 0) Then
                parameters.idfsCaseProgressStatus = Nothing
            End If
            If (parameters.idfSentByOffice = 0) Then
                parameters.idfSentByOffice = Nothing
            End If
            If (parameters.idfsFinalState = 0) Then
                parameters.idfsFinalState = Nothing
            End If
            If (parameters.idfsHospitalizationStatus = 0) Then
                parameters.idfsHospitalizationStatus = Nothing
            End If
            If (parameters.idfsInitialCaseStatus = 0) Then
                parameters.idfsInitialCaseStatus = Nothing
            End If
            If (parameters.idfsLocationCountry = 0) Then
                parameters.idfsLocationCountry = Nothing
            End If
            If (parameters.idfsLocationGroundType = 0) Then
                parameters.idfsLocationGroundType = Nothing
            End If
            If (parameters.idfsLocationRayon = 0) Then
                parameters.idfsLocationRayon = Nothing
            End If
            If (parameters.idfsLocationRegion = 0) Then
                parameters.idfsLocationRegion = Nothing
            End If
            If (parameters.idfsLocationSettlement = 0) Then
                parameters.idfsLocationSettlement = Nothing
            End If
            If (parameters.idfsNonNotIFiableDiagnosis = 0) Then
                parameters.idfsNonNotIFiableDiagnosis = Nothing
            End If
            If (parameters.idfSougtCareFacility = 0) Then
                parameters.idfSougtCareFacility = Nothing
            End If
            If (parameters.idfsOutcome = 0) Then
                parameters.idfsOutcome = Nothing
            End If
            If (parameters.idfsYNAntimicrobialTherapy = 0) Then
                parameters.idfsYNAntimicrobialTherapy = Nothing
            End If
            If (parameters.idfsYNExposureLocationKnown = 0) Then
                parameters.idfsYNExposureLocationKnown = Nothing
            End If
            If (parameters.idfsYNPreviouslySoughtCare = 0) Then
                parameters.idfsYNPreviouslySoughtCare = Nothing
            End If
            If (parameters.idfsYNRelatedToOutbreak = 0) Then
                parameters.idfsYNRelatedToOutbreak = Nothing
            End If
            If (parameters.idfsYNSpecIFicVaccinationAdministered = 0) Then
                parameters.idfsYNSpecIFicVaccinationAdministered = Nothing
            End If
            If (parameters.idfsYNSpecimenCollected = 0) Then
                parameters.idfsYNSpecimenCollected = Nothing
            End If
            If (parameters.intLocationDistance = 0) Then
                parameters.intLocationDistance = Nothing
            End If
            If (parameters.intLocationLatitude = 0) Then
                parameters.intLocationLatitude = Nothing
            End If
            If (parameters.intLocationLongitude = 0) Then
                parameters.intLocationLongitude = Nothing
            End If
            If (parameters.idfsNonNotIFiableDiagnosis = 0) Then
                parameters.idfsNonNotIFiableDiagnosis = Nothing
            End If
            If (parameters.intLocationLongitude = 0) Then
                parameters.intLocationLongitude = Nothing
            End If

            list = HumanAPIService.SetHumanDisease(parameters).Result


            For Each item As HumHumanDiseaseSetModel In list
                If (item.idfHumanCase >= 0) Then
                    result = item.idfHumanCase
                    txtSummaryidfHumanCase.Text = item.strHumanCaseID
                ElseIf Not parameters.strHumanCaseId = "(New)" Then
                    result = parameters.idfHumanCase
                    txtSummaryidfHumanCase.Text = parameters.strHumanCaseId
                End If
            Next

            Return result
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Function

    Private Function ExtractParameterTo(ByVal paramName As String, ByVal args() As String, ByVal type As ConversionType, ByRef field As Object)

        Dim strValue As String = ExtractParamater(paramName, args)

        If (strValue <> "") Then

            Dim bSuccess As Boolean

            Select Case type
                Case ConversionType.ConvertLong

                    Dim lValue As Long

                    bSuccess = Long.TryParse(strValue, lValue)

                    If (bSuccess) Then
                        field = lValue
                    End If

                Case ConversionType.ConvertString

                    field = strValue.ToString()

                Case ConversionType.ConvertDate

                    Dim dtValue As DateTime

                    bSuccess = DateTime.TryParse(strValue, dtValue)

                    If (bSuccess) Then
                        field = dtValue
                    End If

                Case ConversionType.ConvertBool

                    Dim lValue As Boolean

                    bSuccess = Boolean.TryParse(strValue, lValue)

                    If (bSuccess) Then
                        field = lValue
                    End If

            End Select

            Dim test As String = ""

        End If

    End Function

    Private Function ExtractParamater(ByVal paramName As String, ByVal args() As String)

        Dim strReturnValue As String = ""

        Try
            Dim aItems As String()

            For Each arg As String In args(0).Split("|")
                aItems = arg.Split(";")
                If aItems(0).ToString() = paramName Then
                    strReturnValue = aItems(1).ToString()
                End If
            Next

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

        Return strReturnValue

    End Function
    Private Enum ConversionType

        ConvertLong = 0
        ConvertString = 1
        ConvertDate = 2
        ConvertBool = 3

    End Enum

    Private Sub AddSampleListToDs(ByRef ds As DataSet, ByRef list As List(Of clsHumanDiseaseSample))

        'Dim _result As New DataSet()
        ds.Tables.Add("Samples")
        ds.Tables("Samples").Columns.Add("idfHumanCase")
        ds.Tables("Samples").Columns.Add("idfMaterial")
        ds.Tables("Samples").Columns.Add("strBarcode")
        ds.Tables("Samples").Columns.Add("strFieldBarcode")
        ds.Tables("Samples").Columns.Add("idfsSampleType")
        ds.Tables("Samples").Columns.Add("strSampleTypeName")
        ds.Tables("Samples").Columns.Add("datFieldCollectionDate")

        ds.Tables("Samples").Columns.Add("idfSendToOffice")
        ds.Tables("Samples").Columns.Add("strSendToOffice")
        ds.Tables("Samples").Columns.Add("idfFieldCollectedByOffice")
        ds.Tables("Samples").Columns.Add("strFieldCollectedByOffice")
        ds.Tables("Samples").Columns.Add("datFieldSentDate")
        ds.Tables("Samples").Columns.Add("strNote")
        ds.Tables("Samples").Columns.Add("datAccession")

        ds.Tables("Samples").Columns.Add("idfsAccessionCondition")
        ds.Tables("Samples").Columns.Add("strCondition")
        ds.Tables("Samples").Columns.Add("idfsRegion")
        ds.Tables("Samples").Columns.Add("strRegionName")
        ds.Tables("Samples").Columns.Add("idfsRayon")
        ds.Tables("Samples").Columns.Add("strRayonName")
        ds.Tables("Samples").Columns.Add("blnAccessioned")

        ds.Tables("Samples").Columns.Add("RecordAction")
        ds.Tables("Samples").Columns.Add("idfsSampleKind")
        ds.Tables("Samples").Columns.Add("SampleKindTypeName")
        ds.Tables("Samples").Columns.Add("idfsSampleStatus")
        ds.Tables("Samples").Columns.Add("SampleStatusTypeName")
        ds.Tables("Samples").Columns.Add("idfFieldCollectedByPerson")
        ds.Tables("Samples").Columns.Add("datSampleStatusDate")

        ds.Tables("Samples").Columns.Add("sampleGuid")
        ds.Tables("Samples").Columns.Add("intRowStatus")

        For Each item As clsHumanDiseaseSample In list
            Dim newRow As DataRow = ds.Tables("Samples").NewRow()
            newRow("idfHumanCase") = item.idfHumanCase
            newRow("idfMaterial") = item.idfMaterial
            newRow("strBarcode") = item.strBarcode
            newRow("strFieldBarcode") = item.strFieldBarcode
            newRow("idfsSampleType") = item.idfsSampleType
            newRow("strSampleTypeName") = item.strSampleTypeName
            newRow("datFieldCollectionDate") = item.datFieldCollectionDate

            newRow("idfSendToOffice") = item.idfSendToOffice
            newRow("strSendToOffice") = item.strSendToOffice
            newRow("idfFieldCollectedByOffice") = item.idfFieldCollectedByOffice
            newRow("strFieldCollectedByOffice") = item.strFieldCollectedByOffice
            newRow("datFieldSentDate") = item.datFieldSentDate
            newRow("strNote") = item.strNote
            newRow("datAccession") = item.datAccession

            newRow("idfsAccessionCondition") = item.idfsAccessionCondition
            newRow("strCondition") = item.strCondition
            newRow("idfsRegion") = item.idfsRegion
            newRow("strRegionName") = item.strRegionName
            newRow("idfsRayon") = item.idfsRayon
            newRow("strRayonName") = item.strRayonName
            newRow("blnAccessioned") = item.blnAccessioned

            newRow("RecordAction") = item.RecordAction
            newRow("idfsSampleKind") = item.idfsSampleKind
            newRow("SampleKindTypeName") = item.SampleKindTypeName
            newRow("idfsSampleStatus") = item.idfsSampleStatus
            newRow("SampleStatusTypeName") = item.SampleStatusTypeName
            newRow("idfFieldCollectedByPerson") = item.idfFieldCollectedByPerson
            newRow("datSampleStatusDate") = item.datSampleStatusDate

            newRow("sampleGuid") = item.sampleGuid
            newRow("intRowStatus") = item.intRowStatus

            ds.Tables("Samples").Rows.Add(newRow)
        Next
    End Sub

    Private Sub AddTestListToDs(ByRef ds As DataSet, ByRef list As List(Of clsHumanDiseaseTest))

        'Dim _result As New DataSet()
        ds.Tables.Add("Tests")
        ds.Tables("Tests").Columns.Add("idfHumanCase")
        ds.Tables("Tests").Columns.Add("idfMaterial")
        ds.Tables("Tests").Columns.Add("strBarcode")
        ds.Tables("Tests").Columns.Add("strFieldBarcode")
        ds.Tables("Tests").Columns.Add("idfsSampleType")
        ds.Tables("Tests").Columns.Add("strSampleTypeName")

        ds.Tables("Tests").Columns.Add("datFieldCollectionDate")
        ds.Tables("Tests").Columns.Add("idfSendToOffice")
        ds.Tables("Tests").Columns.Add("strSendToOffice")
        ds.Tables("Tests").Columns.Add("idfFieldCollectedByOffice")
        ds.Tables("Tests").Columns.Add("strFieldCollectedByOffice")
        ds.Tables("Tests").Columns.Add("datFieldSentDate")

        ds.Tables("Tests").Columns.Add("idfsSampleKind")
        ds.Tables("Tests").Columns.Add("SampleKindTypeName")
        ds.Tables("Tests").Columns.Add("idfsSampleStatus")
        ds.Tables("Tests").Columns.Add("SampleStatusTypeName")
        ds.Tables("Tests").Columns.Add("idfFieldCollectedByPerson")
        ds.Tables("Tests").Columns.Add("datSampleStatusDate")

        ds.Tables("Tests").Columns.Add("sampleGuid")
        ds.Tables("Tests").Columns.Add("idfTesting")
        ds.Tables("Tests").Columns.Add("idfsTestName")
        ds.Tables("Tests").Columns.Add("idfsTestCategory")
        ds.Tables("Tests").Columns.Add("idfsTestResult")
        ds.Tables("Tests").Columns.Add("idfsTestStatus")

        ds.Tables("Tests").Columns.Add("idfsDiagnosis")
        ds.Tables("Tests").Columns.Add("strTestStatus")
        ds.Tables("Tests").Columns.Add("strTestResult")
        ds.Tables("Tests").Columns.Add("name")
        ds.Tables("Tests").Columns.Add("datReceivedDate")
        ds.Tables("Tests").Columns.Add("datConcludedDate")
        ds.Tables("Tests").Columns.Add("idfTestedByPerson")

        ds.Tables("Tests").Columns.Add("idfTestedByOffice")

        ds.Tables("Tests").Columns.Add("idfsInterpretedStatus")
        ds.Tables("Tests").Columns.Add("strInterpretedComment")
        ds.Tables("Tests").Columns.Add("datInterpretedDate")
        ds.Tables("Tests").Columns.Add("strInterpretedBy")
        ds.Tables("Tests").Columns.Add("blnValidateStatus")
        ds.Tables("Tests").Columns.Add("strValidateComment")
        ds.Tables("Tests").Columns.Add("datValidationDate")
        ds.Tables("Tests").Columns.Add("strValidatedBy")
        ds.Tables("Tests").Columns.Add("strAccountName")

        ds.Tables("Tests").Columns.Add("testGuid")
        ds.Tables("Tests").Columns.Add("intRowStatus")


        For Each item As clsHumanDiseaseTest In list
            Dim newRow As DataRow = ds.Tables("Tests").NewRow()
            newRow("idfHumanCase") = item.idfHumanCase
            newRow("idfMaterial") = item.idfMaterial
            newRow("strBarcode") = item.strBarcode
            newRow("strFieldBarcode") = item.strFieldBarcode
            newRow("idfsSampleType") = item.idfsSampleType
            newRow("strSampleTypeName") = item.strSampleTypeName

            newRow("datFieldCollectionDate") = item.datFieldCollectionDate
            newRow("idfSendToOffice") = item.idfSendToOffice
            newRow("strSendToOffice") = item.strSendToOffice
            newRow("idfFieldCollectedByOffice") = item.idfFieldCollectedByOffice
            newRow("strFieldCollectedByOffice") = item.strFieldCollectedByOffice
            newRow("datFieldSentDate") = item.datFieldSentDate

            newRow("idfsSampleKind") = item.idfsSampleKind
            newRow("SampleKindTypeName") = item.SampleKindTypeName
            newRow("idfsSampleStatus") = item.idfsSampleStatus
            newRow("SampleStatusTypeName") = item.SampleStatusTypeName
            newRow("idfFieldCollectedByPerson") = item.idfFieldCollectedByPerson
            newRow("datSampleStatusDate") = item.datSampleStatusDate

            newRow("sampleGuid") = item.sampleGuid
            newRow("idfTesting") = item.idfTesting
            newRow("idfsTestName") = item.idfsTestName
            newRow("idfsTestCategory") = item.idfsTestCategory
            newRow("idfsTestResult") = item.idfsTestResult
            newRow("idfsTestStatus") = item.idfsTestStatus

            newRow("idfsDiagnosis") = item.idfsDiagnosis
            newRow("strTestStatus") = item.strTestStatus
            newRow("strTestResult") = item.strTestResult
            newRow("name") = item.name
            newRow("datReceivedDate") = item.datReceivedDate
            newRow("datConcludedDate") = item.datConcludedDate
            newRow("idfTestedByPerson") = item.idfTestedByPerson

            newRow("idfsInterpretedStatus") = item.idfsInterpretedStatus
            newRow("strInterpretedComment") = item.strInterpretedComment
            newRow("datInterpretedDate") = item.datInterpretedDate
            newRow("strInterpretedBy") = item.strInterpretedBy
            newRow("blnValidateStatus") = item.blnValidateStatus
            newRow("strValidateComment") = item.strValidateComment
            newRow("datValidationDate") = item.datValidationDate
            newRow("strValidatedBy") = item.strValidatedBy
            newRow("strAccountName") = item.strAccountName

            newRow("idfTestedByOffice") = item.idfTestedByOffice
            newRow("testGuid") = item.testGuid
            newRow("intRowStatus") = item.intRowStatus


            ds.Tables("Tests").Rows.Add(newRow)
        Next
    End Sub

    Private Sub DisplayDiseaseValidationErrors()
        'Paint all SideBarItems as Passed Validation and then correct those that failed
        sidebaritem_notification.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritem_symptoms.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritem_FacilityDetails.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritemAnti_Vaccine_History.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritem_Samples.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritem_CaseDetails.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritem_RiskFactors.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritem_FinalOutcome.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sidebaritem_ContactList.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Validators
            If oValidator.IsValid = False Then
                If (oValidator.GetType() Is GetType(RequiredFieldValidator)) Then


                    Dim failedValidator As RequiredFieldValidator = oValidator
                    Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)
                    Select Case section.ID
                        Case "diseaseNotification"
                            sidebaritem_notification.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_notification.CssClass = "glyphicon glyphicon-remove"
                        Case "symptoms"
                            sidebaritem_symptoms.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_symptoms.CssClass = "glyphicon glyphicon-remove"
                        Case "facilityDetails"
                            sidebaritem_FacilityDetails.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_FacilityDetails.CssClass = "glyphicon glyphicon-remove"
                        Case "antibioticVaccineHistory"
                            sidebaritemAnti_Vaccine_History.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritemAnti_Vaccine_History.CssClass = "glyphicon glyphicon-remove"
                        Case "samples"
                            sidebaritem_Samples.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_Samples.CssClass = "glyphicon glyphicon-remove"
                        Case "caseDetails"
                            sidebaritem_CaseDetails.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_CaseDetails.CssClass = "glyphicon glyphicon-remove"
                        Case "riskFactors"
                            sidebaritem_RiskFactors.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_RiskFactors.CssClass = "glyphicon glyphicon-remove"
                        Case "finalOutcome"
                            sidebaritem_FinalOutcome.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_FinalOutcome.CssClass = "glyphicon glyphicon-remove"
                        Case "contactList"
                            sidebaritem_ContactList.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_ContactList.CssClass = "glyphicon glyphicon-remove"
                    End Select
                ElseIf (oValidator.GetType() Is GetType(CustomValidator)) Then
                    Dim failedValidator As CustomValidator = oValidator
                    Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)
                    Select Case section.ID
                        Case "diseaseNotification"
                            sidebaritem_notification.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_notification.CssClass = "glyphicon glyphicon-remove"
                        Case "symptoms"
                            sidebaritem_symptoms.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_symptoms.CssClass = "glyphicon glyphicon-remove"
                        Case "facilityDetails"
                            sidebaritem_FacilityDetails.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_FacilityDetails.CssClass = "glyphicon glyphicon-remove"
                        Case "antibioticVaccineHistory"
                            sidebaritemAnti_Vaccine_History.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritemAnti_Vaccine_History.CssClass = "glyphicon glyphicon-remove"
                        Case "samples"
                            sidebaritem_Samples.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_Samples.CssClass = "glyphicon glyphicon-remove"
                        Case "caseDetails"
                            sidebaritem_CaseDetails.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_CaseDetails.CssClass = "glyphicon glyphicon-remove"
                        Case "riskFactors"
                            sidebaritem_RiskFactors.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_RiskFactors.CssClass = "glyphicon glyphicon-remove"
                        Case "finalOutcome"
                            sidebaritem_FinalOutcome.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_FinalOutcome.CssClass = "glyphicon glyphicon-remove"
                        Case "contactList"
                            sidebaritem_ContactList.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                            sidebaritem_ContactList.CssClass = "glyphicon glyphicon-remove"
                    End Select
                End If

            End If
        Next
    End Sub

#End Region

#Region "Events"

#Region "Button"
    Protected Sub btnAddNewSampleClick(sender As Object, e As EventArgs)
        'open modal, add new Sample, save, put in grid on underlying page
        fillBasicSamplesModal()
        btnMasAddSampleSave.Enabled = False
        btnMasAddSampleDelete.Enabled = False
        hdfModalAddSampleGuid.Value = String.Empty
        'Dim idx As Integer = gvSamples.SelectedIndex
        mastxtSampleId.Text = String.Format("New-{0}", hdfNextAddSampleInteger.Value)
        hdfNextAddSampleInteger.Value = CInt(hdfNextAddSampleInteger.Value) + 1
        masddlSampleType.SelectedIndex = -1
        'masddlSampleType.Enabled = True
        masAddSampleDateCollected.Text = String.Empty
        masAddSampleLocalSampleId.Text = String.Empty
        masAddSampleDateSent.Text = String.Empty
        ddlmasAddSampleSentTo.SelectedIndex = -1
        'openModalSampleTab()
        'show modal, call js method: openModalSampleTab()
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupSamplesModal", "openModalSampleTab();", True)
        hdnPanelController.Value = 5
    End Sub

    Protected Sub btnAddNewTestClick(sender As Object, e As EventArgs)
        'open modal, add new Test, save, put in grid on underlying page
        hdfModalAddTestGuid.Value = String.Empty
        hdfModalAddTestNewIndicator.Value = "New"
        fillBasicTestsModal()
        ddlSampleTestName.SelectedIndex = -1
        ddlSampleTestCategory.SelectedIndex = -1
        ddlSampleTestResult.SelectedIndex = -1
        ddlSampleTestStatus.SelectedIndex = -1
        ddlSampleTestDiagnosis.SelectedItem.Selected = True
        ddlSampleTestDiagnosis.SelectedItem.Text = ddlidfsFinalDiagnosis.SelectedItem.Text
        datAddFieldTestResultReceived.Text = String.Empty
        txtAddFieldTestResultDate.Text = String.Empty
        ddlmatLocalSampleId.SelectedIndex = 1
        txtstrBarCode.Text = String.Empty
        txtstrInterpretedComment.Text = String.Empty
        txtstrValidateComment.Text = String.Empty

        'Dim myUser As Security.Principal.IIdentity
        'myUser = HttpContext.Current.User.Identity
        'hdfstrAccountName.Value = myUser.Name

        'hdfstrAccountName.Value = ""
        'If ddlidfsInterpretedStatus.SelectedIndex > 0 Then
        '    hdfstrAccountName.Value = Session("FamilyName").ToString + ", " + Session("FirstName").ToString
        'End If
        hdfstrAccountName.Value = Session("FamilyName").ToString + ", " + Session("FirstName").ToString

        txtstrInterpretedBy.Text = hdfstrAccountName.Value
        txtstrValidatedBy.Text = hdfstrAccountName.Value

        'openModalTestTab()
        'show modal, call js method: openModalTestTab()
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupTestsModal", "openModalTestTab();", True)
        hdnPanelController.Value = 6
    End Sub

    Protected Sub btnAddAntiviralTherapyClick(sender As Object, e As EventArgs) Handles btnAddAntiviralTherapy.Click
        If IsValidFAD() Then
            AddNewAntiviralTherapyToGrid()
        End If
        hdnPanelController.Value = 4

    End Sub

    Protected Sub btnSaveAntiviralTherapyClick(sender As Object, e As EventArgs) Handles btnAntiviralTherapySave.Click
        Try

            Dim idx As Integer = gvAntiviralTherapies.SelectedIndex

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            If IsValidFAD() Then

                Dim list = New List(Of HumDiseaseAntiviraltherapySetModel)
                Dim antiviralTherapyParameters As New HumanDiseaseAntViralTherapySetParmas

                'loop through ViewState dsHdrContact.Tables(0): if materialid matches, assign values
                Dim HdrAntiviralTherapiesList As List(Of clsHumanDiseaseAntiviralThearapy) = TryCast(ViewState(HDR_ANTIVIRALTHERAPIES_GvList), List(Of clsHumanDiseaseAntiviralThearapy))

                For Each r As clsHumanDiseaseAntiviralThearapy In HdrAntiviralTherapiesList
                    If idx > -1 Then
                        If (r.idfAntimicrobialTherapy = gvAntiviralTherapies.DataKeys(idx).Values().Item("idfAntimicrobialTherapy")) Then
                            r.idfHumanCase = gvAntiviralTherapies.DataKeys(idx).Values().Item("idfHumanCase")
                            If Not String.IsNullOrEmpty(txtstrAntibioticName.Text) Then r.strAntimicrobialTherapyName = txtstrAntibioticName.Text
                            If Not String.IsNullOrEmpty(txtstrDosage.Text) Then r.strDosage = txtstrDosage.Text
                            If Not String.IsNullOrEmpty(txdatFirstAdministeredDate.Text) Then r.datFirstAdministeredDate = DateTime.Parse(txdatFirstAdministeredDate.Text)

                            antiviralTherapyParameters.idfAntimicrobialTherapy = r.idfAntimicrobialTherapy
                            antiviralTherapyParameters.idfHumanCase = r.idfHumanCase
                            antiviralTherapyParameters.strAntimicrobialTherapyName = r.strAntimicrobialTherapyName
                            antiviralTherapyParameters.strDosage = r.strDosage
                            antiviralTherapyParameters.datFirstAdministeredDate = r.datFirstAdministeredDate

                            list = HumanAPIService.SetHumDiseaseAntiviraltherapy(antiviralTherapyParameters).Result
                        End If
                    End If
                Next

                FillAntiviralTherapiesList(bRefresh:=True)
                txtstrAntibioticName.Text = String.Empty
                txtstrDosage.Text = String.Empty
                txdatFirstAdministeredDate.Text = String.Empty

                btnAddAntiviralTherapy.Visible = True
                btnAntiviralTherapySave.Visible = False

            End If

            hdnPanelController.Value = 4

        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAddVaccinationClick(sender As Object, e As EventArgs) Handles btnAddVaccination.Click

        AddNewVaccinationToGrid()
        hdnPanelController.Value = 4

    End Sub

    Protected Sub btnSaveVaccinationClick(sender As Object, e As EventArgs) Handles btnVaccinationSave.Click

        Try

            Dim idx As Integer = gvVaccinations.SelectedIndex

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumHumanDiseaseVaccinationSetModel)
            Dim vaccinationParameters As New HumanDiseaseVaccinationSetParams

            'loop through ViewState dsHdrContact.Tables(0): if materialid matches, assign values
            Dim HdrVaccinationsList As List(Of clsHumanDiseaseVaccination) = TryCast(ViewState(HDR_VACCINATIONS_GvList), List(Of clsHumanDiseaseVaccination))

            For Each r As clsHumanDiseaseVaccination In HdrVaccinationsList
                If idx > -1 Then
                    If (r.humanDiseaseReportVaccinationUID = gvVaccinations.DataKeys(idx).Values().Item("HumanDiseaseReportVaccinationUID")) Then
                        r.idfHumanCase = gvVaccinations.DataKeys(idx).Values().Item("idfHumanCase")
                        If Not String.IsNullOrEmpty(txtVaccinationName.Text) Then r.vaccinationName = txtVaccinationName.Text
                        If Not String.IsNullOrEmpty(txtVaccinationDate.Text) Then r.vaccinationDate = DateTime.Parse(txtVaccinationDate.Text)

                        vaccinationParameters.humanDiseaseReportVaccinationUid = r.humanDiseaseReportVaccinationUID
                        vaccinationParameters.idfHumanCase = r.idfHumanCase
                        vaccinationParameters.vaccinationName = r.vaccinationName
                        vaccinationParameters.vaccinationDate = r.vaccinationDate

                        list = HumanAPIService.SetHumDiseaseVaccination(vaccinationParameters).Result
                    End If
                End If
            Next

            FillVaccinationsList(bRefresh:=True)
            txtVaccinationName.Text = String.Empty
            txtVaccinationDate.Text = String.Empty

            btnAddVaccination.Visible = True
            btnVaccinationSave.Visible = False
            hdnPanelController.Value = 4

        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnEditAntiviralTherapyClick(sender As Object, e As EventArgs)
        'ddNewVaccinationToGrid()
        hdnPanelController.Value = 4

    End Sub
    Protected Sub btnRtD_Click(sender As Object, e As EventArgs) Handles btnRtD.ServerClick
        Response.Redirect(GetURL(CallerPages.DashboardURL), True)
    End Sub

    Protected Sub gvAntiviralTherapies_RowCommand(sender As Object, e As GridViewEditEventArgs)
        Dim idx As Int64 = Convert.ToInt64(e.NewEditIndex.ToString)
        gvAntiviralTherapies.SelectedIndex = idx

        Try
            Dim HdrAntiviralTherapyList As List(Of clsHumanDiseaseAntiviralThearapy) = TryCast(ViewState(HDR_ANTIVIRALTHERAPIES_GvList), List(Of clsHumanDiseaseAntiviralThearapy))

            Dim i As Integer = 0
            For Each r As clsHumanDiseaseAntiviralThearapy In HdrAntiviralTherapyList
                If i = idx Then
                    txtstrAntibioticName.Text = r.strAntimicrobialTherapyName
                    txtstrDosage.Text = r.strDosage
                    txdatFirstAdministeredDate.Text = r.datFirstAdministeredDate

                    btnAddAntiviralTherapy.Visible = False
                    btnAntiviralTherapySave.Visible = True
                    Exit For
                End If
                i = i + 1

            Next

        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub gvVaccinations_RowCommand(sender As Object, e As GridViewEditEventArgs)

        Dim idx As Int64 = Convert.ToInt64(e.NewEditIndex.ToString)
        gvVaccinations.SelectedIndex = idx

        Try

            Dim HdrVaccinationList As List(Of clsHumanDiseaseVaccination) = TryCast(ViewState(HDR_VACCINATIONS_GvList), List(Of clsHumanDiseaseVaccination))

            Dim i As Integer = 0
            For Each r As clsHumanDiseaseVaccination In HdrVaccinationList
                ' If idx > -1 Then
                If i = idx Then
                    'If (r.humanDiseaseReportVaccinationUID = idx) Then
                    txtVaccinationName.Text = r.vaccinationName
                    'txtVaccinationName.Focus()
                    txtVaccinationDate.Text = r.vaccinationDate

                    btnAddVaccination.Visible = False
                    btnVaccinationSave.Visible = True
                    Exit For
                    'End If
                End If
                i = i + 1
            Next

        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btn_Return_to_Person_Record_Click(sender As Object, e As EventArgs)

        ViewState(CALLER) = CallerPages.HumanDiseaseReport
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.PersonURL), True)

    End Sub

    Protected Sub btnOpenPageFindFacitlityPersonSentBy_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "ddlstrNotificationSentby"
        'openEmployeeAdminForPersonSelection()

        ucSearchOrganization.Setup(selectMode:=SelectModes.Selection)
        hdnPanelController.Value = 1
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_ORGANIZATION_MODAL, True)

    End Sub

    Protected Sub btnOpenPageFindFacitlityPersonReceivedBy_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "ddlstrNotificationReceivedby"
        'openEmployeeAdminForPersonSelection()

        ucSearchOrganization.Setup(selectMode:=SelectModes.Selection)
        hdnPanelController.Value = 1
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_ORGANIZATION_MODAL, True)

    End Sub

    Protected Sub btnOpenPageFindFacilityFirstSoughtCare_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtFacilityFirstSoughtCare"
        'openEmployeeAdminForPersonSelection()

        ucSearchOrganization.Setup(selectMode:=SelectModes.Selection)
        hdnPanelController.Value = 3
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_ORGANIZATION_MODAL, True)

    End Sub

    Protected Sub btnOpenPageFindInvestigatingOrganization_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtInvestigationNameOrganization"
        'openEmployeeAdminForPersonSelection()

        ucSearchOrganization.Setup(selectMode:=SelectModes.Selection)
        hdnPanelController.Value = 7
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_ORGANIZATION_MODAL, True)

    End Sub

    Protected Sub btnOpenPageFindCollectedInstitution_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtstrCollectedByInstitution"

        ucSearchOrganization.Setup(selectMode:=SelectModes.Selection)
        hdnPanelController.Value = 5
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_ORGANIZATION_MODAL, True)

        'hdfEACallerKey.Value = hdfidfHuman.Value
        'hdfEAPageMode.Value = hdfPageMode.Value
        'hdfEAInitiatingCallerPage.Value = ViewState(CALLER)
        'hdfidfHumanActual.Value = ViewState(CALLER_KEY)
        'hdfCallerPage.Value = CallerPages.HumanDiseaseReport

        'hdfEAidfHumanActual.Value = hdfidfHumanActual.Value
        'hdfEAHumanCase.Value = hdfidfHumanCase.Value
        'hdfEAstrHumanCaseId.Value = hdfstrHumanCaseId.Value

        'ViewState(CALLER) = CallerPages.HumanDiseaseReport
        'ViewState(CALLER_KEY) = CallerPages.HumanDiseaseReport
        'Session("hdfidfHumanActual") = hdfidfHumanActual.Value
        'Session("idfHumanCase") = hdfidfHumanCase.Value
        ''Session("idfHumanCase") = hdfSearchHumanCaseId.Value

        'Dim sFileInfo As String = ""
        'Dim sFileTable As String = ""
        'Dim oComm As clsCommon = New clsCommon()
        ''create cache xml file for HDR current values divHiddenFieldsSection
        'Dim ctrlList As ICollection(Of Web.UI.Control) = {disease, divHiddenFieldsSection}
        'sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSuffix)
        'oComm.SaveSearchFields(ctrlList, "HDRHiddenFieldsSection", sFile)
        ''create cache xml file for divHiddenFieldsEAtoHDRInitCache

        'Dim ctrlList2 As ICollection(Of Web.UI.Control) = {divHiddenFieldsEAtoHDRInitCache}
        'sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportInitSuffix)
        'oComm.SaveSearchFields(ctrlList2, "HDREAtoHDRInitCache", sFile)

        ''save to cache: samples grid list
        'Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        'sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSamples)
        ''Dim oSample As New clsHumanDiseaseSample
        'oComm.SerializeListToXmlFile(HdrSampleList, sFile)

        ''save to cache: tests grid list
        'Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
        'sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportTests)
        ''Dim oTest As New clsHumanDiseaseTest
        'oComm.SerializeListToXmlFile(HdrTestList, sFile)

        'oCommon.SaveViewState(ViewState)

        'Response.Redirect(GetURL(CallerPages.OrganizationAdminURL))

    End Sub

    'Protected Sub SearchOrgaization_UserControl_SelectOrgaization(organizationID As Long, organizationName As String) Handles ucSearchOrganization.SelectOrganizationRecord

    '    Try
    '        ViewState("SearchOrganizationID") = organizationID
    '        ViewState("OrganizationName") = organizationName

    '        If hdfEALastControlFocus.Value = "txtstrNotificationSentby" Then
    '            txtstrNotificationSentby.Text = organizationName
    '            hdfidfSentByOffice.Value = organizationID.ToString
    '        End If

    '        If hdfEALastControlFocus.Value = "txtstrNotificationReceivedby" Then
    '            txtstrNotificationReceivedby.Text = organizationName
    '            hdfidfReceivedByOffice.Value = organizationID.ToString
    '        End If

    '        If hdfEALastControlFocus.Value = "txtFacilityFirstSoughtCare" Then
    '            txtFacilityFirstSoughtCare.Text = organizationName
    '            hdfidfSoughtCareFacility.Value = organizationID.ToString
    '        End If

    '        If hdfEALastControlFocus.Value = "txtInvestigationNameOrganization" Then
    '            txtInvestigationNameOrganization.Text = organizationName
    '        End If

    '        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, HIDE_SEARCH_ORGANIZATION_MODAL, True)

    '    Catch ex As Exception
    '        Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
    '    End Try

    'End Sub

    Protected Sub btnOpenPageFindCollectedPerson_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtstrCollectedByOfficer"
        'openEmployeeAdminForPersonSelection()

        'ucSearchEmployee.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
        hdnPanelController.Value = 5

        '-- Employee Search
        'ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_EMPLOYEE_MODAL, True)

        'Temporary Person Search
        ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_PERSON_MODAL, True)

    End Sub

    Protected Sub btnOpenPageFindPerson_Click(sender As Object, e As EventArgs)
        oCommon.SaveViewState(ViewState)
        ViewState("CONTACTS_ACTION") = "Add"
        hdfEALastControlFocus.Value = "txtstrContactFirstName"
        'openPersonPageForPersonSelection()

        ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
        'ucSearchPerson.Visible = True
        'ucAddUpdatePerson.Visible = True
        hdfSearchHumanModalDate.Value = DateTime.Now
        hdnPanelController.Value = 9

        ScriptManager.RegisterStartupScript(Page, GetType(Page), "PopupModalAddContactContinue", "continueWithModalContactsTab();", True)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_SEARCH_PERSON_MODAL, True)

    End Sub

    Protected Sub SearchPerson_UserControl_SelectPerson(humanID As Long, eidssPersonID As String, humanName As String, firstName As String, lastName As String) Handles ucSearchPerson.SelectPerson

        Try

            If hdfEALastControlFocus.Value = "txtstrCollectedByOfficer" Then
                'txtstrCollectedByOfficer.Text = 

                hdnPanelController.Value = 5
            End If

            If hdfEALastControlFocus.Value = "txtstrContactFirstName" Then
                hdfHumanMasterID.Value = humanID

                hdnPanelController.Value = 9

                If HumanAPIService Is Nothing Then
                    HumanAPIService = New HumanServiceClient()
                End If
                Dim list As List(Of HumHumanMasterGetDetailModel) = HumanAPIService.GetHumanMasterDetailAsync(GetCurrentLanguage(), hdfHumanMasterID.Value).Result

                Scatter(Me, list.FirstOrDefault())

                txtstrContactFirstName.Text = hdfFirstOrGivenName.Value
                txtstrContactMiddleInit.Text = hdfSecondName.Value
                txtstrContactLastName.Text = hdfLastOrSurname.Value

                upContactModal.Update()

                Session("Open_Add_Contact_Modal") = "Open"
            End If

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, HIDE_SEARCH_PERSON_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub openPersonPageForPersonSelection()

        ViewState(CALLER) = CallerPages.HumanDiseaseReport
        ViewState(CALLER_KEY) = String.Empty
        oCommon.SaveViewState(ViewState) 'TODO:  Test that this is needed here for this redirect.  Stephen Long - 08/14/2018

        Response.Redirect(GetURL(CallerPages.PersonURL), True)

    End Sub

    Public Sub SetTransferToOrganization(organizationID As String, organizationName As String)

        If organizationID.IsValueNullOrEmpty = False Then
            txtstrNotificationSentby.Text = organizationName
            hdfidfSentByOffice.Value = organizationID

        End If

    End Sub

    Private Sub AddNewContactToGrid()
        Dim HdrContactList = TryCast(ViewState(HDR_CONTACTS_GvList), List(Of clsHumanDiseaseContact))

        'Check If your Contact collection exists
        If HdrContactList Is Nothing Then
            HdrContactList = New List(Of clsHumanDiseaseContact)
        End If

        Dim r As New clsHumanDiseaseContact

        hdfidfHumanActual.Value = hdfHumanMasterID.Value

        r.idfContactedCasePerson = Nothing
        r.idfHuman = hdfidfHuman.Value.ToInt64
        If Not String.IsNullOrEmpty(hdfidfHumanActual.Value) Then
            r.idfHumanActual = hdfidfHumanActual.Value
        End If

        If Not String.IsNullOrEmpty(hdfidfHumanCase.Value) Then
            r.idfHumanCase = hdfidfHumanCase.Value
        End If

        If Not String.IsNullOrEmpty(txtstrContactFirstName.Text) Then r.strFirstName = txtstrContactFirstName.Text
        If Not String.IsNullOrEmpty(txtstrContactMiddleInit.Text) Then r.strSecondName = txtstrContactMiddleInit.Text
        If Not String.IsNullOrEmpty(txtstrContactLastName.Text) Then r.strLastName = txtstrContactLastName.Text
        r.strContactPersonFullName = txtstrContactFirstName.Text + " " + txtstrContactMiddleInit.Text + " " + txtstrContactLastName.Text

        If ddlContactRelation.SelectedIndex > -1 Then r.strPersonContactType = ddlContactRelation.SelectedItem.Text
        If Not String.IsNullOrEmpty(txtdatLastContactDate.Text) Then r.datDateOfLastContact = DateTime.Parse(txtdatLastContactDate.Text)
        If Not String.IsNullOrEmpty(txtPlaceofLastContact.Text) Then r.strPlaceInfo = txtPlaceofLastContact.Text
        If Not String.IsNullOrEmpty(txtstrComments.Text) Then r.strComments = txtstrComments.Text
        r.intRowStatus = 0

        HdrContactList.Add(r)
        ViewState(HDR_CONTACTS_GvList) = HdrContactList
        gvContacts.DataSource = HdrContactList
        gvContacts.DataBind()
    End Sub
    Protected Sub SetContactModalValuesToGrid()
        Dim idx As Integer = gvContacts.SelectedIndex

        If HumanAPIService Is Nothing Then
            HumanAPIService = New HumanServiceClient()
        End If

        Dim list = New List(Of HumDiseaseContactsSetModel)
        Dim contactsParameters As New HumanDiseaseSetContactParams

        'loop through ViewState dsHdrContact.Tables(0): if materialid matches, assign values
        Dim HdrContactList As List(Of clsHumanDiseaseContact) = TryCast(ViewState(HDR_CONTACTS_GvList), List(Of clsHumanDiseaseContact))
        For Each r As clsHumanDiseaseContact In HdrContactList
            If idx > -1 Then
                If (r.idfHumanActual = gvContacts.DataKeys(idx).Values().Item("idfHumanActual")) Then
                    r.idfHuman = gvContacts.DataKeys(idx).Values().Item("idfHuman")
                    r.idfContactedCasePerson = gvContacts.DataKeys(idx).Values().Item("idfContactedCasePerson")
                    r.idfsPersonContactType = gvContacts.DataKeys(idx).Values().Item("idfsPersonContactType")
                    r.rowguid = gvContacts.DataKeys(idx).Values().Item("rowguid")
                    If Not String.IsNullOrEmpty(txtstrContactFirstName.Text) Then r.strFirstName = txtstrContactFirstName.Text
                    If Not String.IsNullOrEmpty(txtstrContactMiddleInit.Text) Then r.strSecondName = txtstrContactMiddleInit.Text
                    If Not String.IsNullOrEmpty(txtstrContactLastName.Text) Then r.strLastName = txtstrContactLastName.Text
                    r.strContactPersonFullName = txtstrContactFirstName.Text + " " + txtstrContactMiddleInit.Text + " " + txtstrContactLastName.Text

                    If ddlContactRelation.SelectedIndex > -1 Then r.strPersonContactType = ddlContactRelation.SelectedItem.Text
                    If Not String.IsNullOrEmpty(txtdatLastContactDate.Text) Then r.datDateOfLastContact = DateTime.Parse(txtdatLastContactDate.Text)
                    If Not String.IsNullOrEmpty(txtPlaceofLastContact.Text) Then r.strPlaceInfo = txtPlaceofLastContact.Text
                    If Not String.IsNullOrEmpty(txtstrComments.Text) Then r.strComments = txtstrComments.Text
                    r.intRowStatus = 0

                    'Save to database 
                    contactsParameters.idfContactedCasePerson = r.idfContactedCasePerson
                    contactsParameters.idfsPersonContactType = r.idfsPersonContactType
                    contactsParameters.idfHuman = r.idfHuman
                    contactsParameters.idfHumanCase = r.idfHumanCase
                    contactsParameters.datDateOfLastContact = r.datDateOfLastContact
                    'contactsParameters.idfHumanActual = r.idfHumanActual
                    contactsParameters.strPlaceInfo = r.strPlaceInfo
                    contactsParameters.strComments = r.strComments
                    contactsParameters.rowguid = r.rowguid


                    list = HumanAPIService.SetHumanDiseaseContacts(contactsParameters).Result

                End If
            End If
        Next

        FillContactsList(bRefresh:=True)

    End Sub


    Protected Sub gvContacts_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvContacts.SelectedIndexChanged
        Dim idx As Integer = gvContacts.SelectedIndex
        hdfHumanMasterID.Value = gvContacts.DataKeys(idx).Values().Item("idfHumanActual")
        ViewState("CONTACTS_ACTION") = "Edit"

        If HumanAPIService Is Nothing Then
            HumanAPIService = New HumanServiceClient()
        End If
        Dim list As List(Of HumHumanMasterGetDetailModel) = HumanAPIService.GetHumanMasterDetailAsync(GetCurrentLanguage(), hdfHumanMasterID.Value).Result

        Scatter(Me, list.FirstOrDefault())

        txtstrContactFirstName.Text = hdfFirstOrGivenName.Value
        txtstrContactFirstName.Enabled = False
        txtstrContactMiddleInit.Text = hdfSecondName.Value
        txtstrContactMiddleInit.Enabled = False
        txtstrContactLastName.Text = hdfLastOrSurname.Value
        txtstrContactLastName.Enabled = False
        txtdatLastContactDate.Text = gvContacts.DataKeys(idx).Values().Item("datDateOfLastContact")
        txtPlaceofLastContact.Text = gvContacts.DataKeys(idx).Values().Item("strPlaceInfo")
        txtstrComments.Text = gvContacts.DataKeys(idx).Values().Item("strComments")

        upContactModal.Update()

        'show modal, call js method:  openModalContactEdit()
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupContactsModal", "openModalContactEdit();", True)
        hdnPanelController.Value = 9
    End Sub

    Protected Sub Button1_Onclick(sender As Object, e As EventArgs) Handles Button1.ServerClick
        Try
            If gvContacts.SelectedIndex > -1 Then
                SetContactModalValuesToGrid()
            Else
                AddNewContactToGrid()
            End If

            hdfAddContactModalStatus.Value = "Save"
            hdnPanelController.Value = 9
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, HIDE_ADD_CONTACT_MODAL, True)

        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnContactCancel_Onclick(sender As Object, e As EventArgs) Handles btnContactCancel.ServerClick

        hdnPanelController.Value = 9
        hdfSearchHumanModalDate.Value = ""

    End Sub

    Protected Sub btnReturnToReportSearch_Click(sender As Object, e As EventArgs)

        ViewState(CALLER) = CallerPages.HumanDiseaseReport
        oCommon.SaveViewState(ViewState)
        Response.Redirect(GetURL(CallerPages.SearchDiseaseReportsURL), True)

    End Sub

    Protected Sub btnReturnToSearch_Click(sender As Object, e As EventArgs) Handles btnReturnToSearch.Click

        ViewState(CALLER) = CallerPages.HumanDiseaseReport
        ViewState(CALLER_KEY) = Nothing
        oCommon.SaveViewState(ViewState)
        divNewNotifiableDisease.Visible = False
        Response.Redirect(GetURL(CallerPages.PersonURL), True)

    End Sub

    Protected Sub btnReturnToDiseaseSearchResultsList_Click(sender As Object, e As EventArgs) Handles btnReturnToDiseaseSearchResultsList.Click

        divDiseaseCancel.Visible = True
        divDiseaseSave.Visible = False
        divNewNotifiableDisease.Visible = False
        lblSuccessSave.InnerText = GetLocalResourceObject("lbl_Cancel_Disease_Report.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & successVSS.ClientID & "').modal('show');});", True)
        hdnPanelController.Value = "1"

    End Sub

    Protected Sub btnInvestigationSearchOrganization_Click(sender As Object, e As EventArgs)

        lblCancel.InnerText = "Cancel Disease Report"
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "CancelModalScript", "$(function(){ $('#" & searchOrganizationModal.ClientID & "').modal('show');});", True)

        hdnPanelController.Value = "6"

    End Sub

    Protected Sub btndDiseaseReportCancel_Click(sender As Object, e As EventArgs) Handles btndDiseaseReportCancel.ServerClick

        ViewState(CALLER) = CallerPages.HumanDiseaseReportDetail
        'oCommon.SaveViewState(ViewState)
        Response.Redirect(GetURL(CallerPages.SearchDiseaseReportsURL), True)

    End Sub

    Protected Sub btn_Submit_Disease_Report_Click(sender As Object, e As EventArgs)

        Try
            Validate()

            'If (Page.IsValid) Then
            preSaveOperations()
            hdfidfsYNExposureLocationKnown.Value = hdfidfsYNExposureLocationKnown.Value
            hdfidfsFinalDiagnosisCopy.Value = ddlidfsFinalDiagnosis.Text

            'We need to save the data within the flexible form. 
            HumanDiseaseFlexFormRiskFactors.SaveActualData()
            FlexFormSymptoms.SaveActualData()

            hdfidfEpiObservation.Value = HumanDiseaseFlexFormRiskFactors.ObservationID.ToString()
            hdfidfCSObservation.Value = FlexFormSymptoms.ObservationID.ToString()
            'TODO: Harold please call the stored proc that updates the tlbHumanCase table with idfCSObservation and idfEpiObservation

            Dim resultAddDisease As Integer = AddDisease()
            Dim resultReportId As String = txtSummaryidfHumanCase.Text



            If (resultAddDisease > 0) Then

                'we need to add the popup for successful save.
                divDiseaseSave.Visible = True 
                divDiseaseCancel.Visible = False
                lblSuccessSave.InnerText = String.Format(GetLocalResourceObject("lbl_Human_Disease_Report_Saved_Successfully.InnerText") + " ID = {0}.", resultReportId)
                divNewNotifiableDisease.Visible = False
                If (ddlidfsCaseProgressStatus.Text = "10109002" And ddlidfsFinalCaseStatus.Text = "370000000") Then
                    divNewNotifiableDisease.Visible = True
                End If

                txtSummaryidfHumanCase.Text = resultReportId
                hdfstrCaseId.Value = resultReportId

                If Not hdfidfHumanCaseCopy.Value = "" Then
                    hdfparentHumanDiseaseReportID.Value = hdfidfHumanCaseCopy.Value
                    hdfrelatedHumanDiseaseReportIdList.Value = ""
                    FillDiseaseReportSummaryRelated()
                    'hdfidfHumanCaseCopy.Value = ""
                End If

                lblNewNotifiableDisease.InnerText = GetLocalResourceObject("lbl_New_Notifiable_Disease_Report_From_Changed_Disease.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & successVSS.ClientID & "').modal('show');});", True)

                    hdnPanelController.Value = "1"
                Else
                    lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalError", "$(function(){ $('#errorVSS').modal('show');});", True)
            End If

            hdnPanelController.Value = "1"

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Protected Sub btnDiseaseReportDelete_click(sender As Object, e As EventArgs) Handles btnDiseaseReportDelete.Click
        Try
            If gvSamples.Rows.Count = 0 Then
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "DeleteModalScript", "$(function(){ $('#" & deleteHDR.ClientID & "').modal('show');});", True)

            Else
                lblErr.InnerText = GetLocalResourceObject("lbl_Human_Disease_Report_Unable_Delete_Child.InnerText").ToString
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ErrorModalScript", "$(function(){ $('#" & errorVSS.ClientID & "').modal('show');});", True)

            End If
        Catch ex As Exception
            lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText").ToString
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#errorVSS').modal('show');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteHDR_Click(sender As Object, e As EventArgs) Handles btnDeleteHDR.ServerClick
        Try
            Dim list = New List(Of HumHumanDiseaseDelModel)()

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            list = HumanAPIService.DeleteHumanDisease(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value.ToString)).Result

            divDiseaseSave.Visible = False
            divDiseaseCancel.Visible = True
            lblSuccessSave.InnerText = GetLocalResourceObject("lbl_Human_Disease_Report_Deleted_Successfully.InnerText").ToString
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & successVSS.ClientID & "').modal('show');});", True)
            ViewState(CALLER) = CallerPages.HumanDiseaseReport
            ' oCommon.SaveViewState(ViewState)
            Response.Redirect(GetURL(CallerPages.SearchDiseaseReportsURL), True)

        Catch ex As Exception
            lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText").ToString
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#errorVSS').modal('show');});", True)
        End Try
    End Sub

    Protected Sub btnSuccessSave_Click(sender As Object, e As EventArgs) Handles btnSuccessSave.ServerClick

        ViewState(CALLER_KEY) = Nothing
        'oCommon.SaveViewState(ViewState)

    End Sub

    Protected Sub btnNewNotifiableDiseaseYes_Click(sender As Object, e As EventArgs) Handles btnNewNotifiableDiseaseYes.ServerClick

        'ViewState("ReportStatus") = "In process"
        ViewState(CALLER_KEY) = Nothing
        hdfNewNotifiableDiseaseFlag.Value = "1"
        hdfidfHumanCaseCopy.Value = hdfidfHumanCase.Value
        ddlidfsFinalDiagnosis.Enabled = True
        If (ddlidfsFinalDiagnosis.Enabled = False) Then
            ddlidfsFinalDiagnosis.Enabled = True
        End If
        ddlidfsFinalDiagnosis.Items.Remove(ddlidfsFinalDiagnosis.Items.FindByValue(hdfidfsFinalDiagnosisCopy.Value))
        txtdatDateOfDiagnosis.Enabled = True
        txtSummaryidfHumanCase.Text = String.Empty
        txtSummaryDiagnosis.Text = String.Empty
        ddlidfsCaseProgressStatus.Text = "10109001"
        ddlidfsFinalCaseStatus.SelectedIndex = 0
        ddlidfsFinalDiagnosis.SelectedIndex = 0
        txtdatDateOfDiagnosis.Text = String.Empty
        ddlOutcome.SelectedIndex = 0
        txtDateofClassification.Text = String.Empty
        txtDateofDeath.Text = String.Empty
        txtstrSummaryNotes.Text = String.Empty
        txtstrEpidemiologistName.Text = String.Empty
        cblBasisofDiagnosis.Text = String.Empty

        'oCommon.SaveViewState(ViewState)
        hdnPanelController.Value = "1"

    End Sub

    Protected Sub btnNewNotifiableDiseaseNo_Click(sender As Object, e As EventArgs) Handles btnNewNotifiableDiseaseNo.ServerClick

        ViewState(CALLER_KEY) = Nothing
        Response.Redirect(GetURL(CallerPages.DashboardURL), True)

    End Sub

#End Region

    Private Sub preSaveOperations()

        If cblBasisofDiagnosis.Items(0).Selected Then
            hdfblnClinicalDiagBasis.Value = "1"
        End If

        If cblBasisofDiagnosis.Items(1).Selected Then
            hdfblnEpiDiagBasis.Value = "1"
        End If

        If cblBasisofDiagnosis.Items(2).Selected Then

            hdfblnLabDiagBasis.Value = "1"
        End If

    End Sub

#Region "Check Changed"

    Protected Sub rdbPatientPreviouslySought_OnSelectedIndexChanged(sender As Object, e As EventArgs) Handles rblidfsYNPreviouslySoughtCare.SelectedIndexChanged

        'TODO:  if YES then show the "Facility patient first sought care"

        'idfsReference   name    
        '10100001        Yes	
        '10100002        No	
        '10100003        Unknown	

        Dim s As String = sender.SelectedValue                      'get string value of selected item
        Dim i As Int64 = Convert.ToInt64(sender.SelectedValue)      'get int value of selected item

        'if YES was selected
        If (i = 10100001) Then
            txtdatFirstSoughtCareDate.Enabled = True
            txtFacilityFirstSoughtCare.Enabled = True
            ddlidfsNonNotifiableDiagnosis.Enabled = True
            'rblidfsYNPreviouslySoughtCare.SelectedIndex = 0
        Else
            txtdatFirstSoughtCareDate.Enabled = False
            txtFacilityFirstSoughtCare.Enabled = False
            ddlidfsNonNotifiableDiagnosis.Enabled = False
        End If

        hdnPanelController.Value = 3
    End Sub

    Protected Sub rblidfsYNHospitalization_CheckChanged(sender As Object, e As EventArgs) Handles rblidfsYNHospitalization.SelectedIndexChanged
        Dim i As Int64 = Convert.ToInt64(sender.SelectedValue)      'get int value of selected item

        If (i = 10100001) Then
            txtdatHospitalizationDate.Enabled = True
            txtdatDischargeDate.Enabled = True
            pnlHospitalization.Visible = True
        Else
            txtdatHospitalizationDate.Enabled = False
            txtdatDischargeDate.Enabled = False
            pnlHospitalization.Visible = False
        End If
        hdnPanelController.Value = 3
    End Sub

    Protected Sub rdbAntibioticAntiviralTherapyAdministered_CheckChanged(sender As Object, e As EventArgs)
        If rdbAntibioticAntiviralTherapyAdministeredYes.Checked Then
            pnlAntiBioticAdministred.Visible = True
            gvAntiviralTherapies.Visible = True
        Else
            pnlAntiBioticAdministred.Visible = False
        End If
    End Sub


    Protected Sub rdbAntibioticAntiviralTherapyAdministeredYes_CheckChanged(sender As Object, e As EventArgs) Handles rdbAntibioticAntiviralTherapyAdministeredYes.CheckedChanged
        If rdbAntibioticAntiviralTherapyAdministeredYes.Checked Then
            pnlAntiBioticAdministred.Visible = True
            gvAntiviralTherapies.Visible = True
        Else
            pnlAntiBioticAdministred.Visible = False
        End If
    End Sub

    Protected Sub rdbAntibioticAntiviralTherapyAdministeredNo_CheckChanged(sender As Object, e As EventArgs) Handles rdbAntibioticAntiviralTherapyAdministeredNo.CheckedChanged
        If rdbAntibioticAntiviralTherapyAdministeredNo.Checked Then
            pnlAntiBioticAdministred.Visible = False
            gvAntiviralTherapies.Visible = False
        Else
            '
        End If
    End Sub

    Protected Sub rdbAntibioticAntiviralTherapyAdministeredUnknown_CheckChanged(sender As Object, e As EventArgs) Handles rdbAntibioticAntiviralTherapyAdministeredUnknown.CheckedChanged
        If rdbAntibioticAntiviralTherapyAdministeredUnknown.Checked Then
            pnlAntiBioticAdministred.Visible = False
            gvAntiviralTherapies.Visible = False
        Else
            '
        End If
    End Sub

    Protected Sub rdbLocationofExposureKnownYes_CheckChanged(sender As Object, e As EventArgs) Handles rdbLocationofExposureKnownYes.CheckedChanged
        If rdbLocationofExposureKnownYes.Checked Then
            pnlLocationofExposureKnown.Visible = True
            hdfidfsYNExposureLocationKnown.Value = "1"
        Else
            pnlLocationofExposureKnown.Visible = False
        End If
    End Sub

    Protected Sub rdbLocationofExposureKnownNo_CheckChanged(sender As Object, e As EventArgs) Handles rdbLocationofExposureKnownNo.CheckedChanged
        If rdbLocationofExposureKnownNo.Checked Then
            pnlLocationofExposureKnown.Visible = False
            hdfidfsYNExposureLocationKnown.Value = "0"
        Else
            '
        End If
    End Sub

    Protected Sub rdbLocationofExposureUnKnown_CheckChanged(sender As Object, e As EventArgs) Handles rdbLocationofExposureUnKnown.CheckedChanged
        If rdbLocationofExposureUnKnown.Checked Then
            pnlLocationofExposureKnown.Visible = False

        Else
            '
        End If
    End Sub

    Protected Sub rdbSpecificVaccination_CheckChanged(sender As Object, e As EventArgs)
        If rdbSpecificVaccinationYes.Checked Then
            pnlSpecialVaccination.Visible = True
            gvVaccinations.Visible = True
        Else
            pnlSpecialVaccination.Visible = False
        End If
    End Sub

    Protected Sub rdbSpecificVaccinationYes_CheckChanged(sender As Object, e As EventArgs) Handles rdbSpecificVaccinationYes.CheckedChanged
        If rdbSpecificVaccinationYes.Checked Then
            pnlSpecialVaccination.Visible = True
            gvVaccinations.Visible = True
        Else
            pnlSpecialVaccination.Visible = False
        End If
    End Sub

    Protected Sub rdbSpecificVaccinationNo_CheckChanged(sender As Object, e As EventArgs) Handles rdbSpecificVaccinationNo.CheckedChanged
        If rdbSpecificVaccinationNo.Checked Then
            pnlSpecialVaccination.Visible = False
            gvVaccinations.Visible = False
        Else
            '
        End If
    End Sub

    Protected Sub rdbSpecificVaccinationUnknown_CheckChanged(sender As Object, e As EventArgs) Handles rdbSpecificVaccinationUnknown.CheckedChanged
        If rdbSpecificVaccinationUnknown.Checked Then
            pnlSpecialVaccination.Visible = False
            gvVaccinations.Visible = False
        Else

            '
        End If
    End Sub

    Protected Sub rblidfsYNSpecimenCollected_CheckChanged(sender As Object, e As EventArgs) Handles rblidfsYNSpecimenCollected.SelectedIndexChanged
        Dim i As Int64 = Convert.ToInt64(sender.SelectedValue)      'get int value of selected item
        If (i = 10100001) Then
            'samplesGridPanel.Visible = True
            btnSampleNewAdd.Enabled = True
        Else
            'samplesGridPanel.Visible = False
            btnSampleNewAdd.Enabled = False
        End If
        hdnPanelController.Value = 5
    End Sub

    Protected Sub rdbExposureAddressType_CheckChanged(sender As Object, e As EventArgs)
        Dim regionGroup As HtmlContainerControl = lucExposure.FindControl("regionGroup")
        Dim rayonGroup As HtmlContainerControl = lucExposure.FindControl("rayonGroup")
        Dim townGroup As HtmlContainerControl = lucExposure.FindControl("townGroup")
        Dim streetGroup As HtmlContainerControl = lucExposure.FindControl("streetGroup")
        Dim buildingHouseApartmentGroup As HtmlContainerControl = lucExposure.FindControl("buildingHouseApartmentGroup")
        Dim postalGroup As HtmlContainerControl = lucExposure.FindControl("postalGroup")
        Dim countryGroup As HtmlContainerControl = lucExposure.FindControl("countryGroup")
        Dim coordinatesGroup As HtmlContainerControl = lucExposure.FindControl("coordinatesGroup")

        If rdbExposureAddressTypeExact.Checked Then

            If Not IsNothing(countryGroup) Then
                countryGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(regionGroup) Then
                regionGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(rayonGroup) Then
                rayonGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(townGroup) Then
                townGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(streetGroup) Then
                streetGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(buildingHouseApartmentGroup) Then
                buildingHouseApartmentGroup.Attributes.Add("class", "form-group")
            End If

            If Not IsNothing(postalGroup) Then
                postalGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(coordinatesGroup) Then
                coordinatesGroup.Attributes.Add("class", "col-md-12")
            End If
            lucExposure_country_required.Visible = False
            lucExposure.ShowCountry = False
            lucExposure.ShowCountryOnly = False
            lucExposure.IsDbRequiredCountry = False
            lucExposure.ShowElevation = True
            foreignAddressType.Visible = False
            relativeAddressType.Visible = False
            lucExposure.DataBind()
        ElseIf rdbExposureAddressTypeRelative.Checked Then
            If Not IsNothing(countryGroup) Then
                countryGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(regionGroup) Then
                regionGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(rayonGroup) Then
                rayonGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(townGroup) Then
                townGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(streetGroup) Then
                streetGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(buildingHouseApartmentGroup) Then
                buildingHouseApartmentGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(postalGroup) Then
                postalGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(coordinatesGroup) Then
                coordinatesGroup.Attributes.Add("class", "hidden")
            End If
            lucExposure_country_required.Visible = False
            lucExposure.ShowCountry = False
            lucExposure.ShowCountryOnly = False
            lucExposure.IsDbRequiredCountry = False
            lucExposure.DataBind()
            foreignAddressType.Visible = False
            relativeAddressType.Visible = True
        Else
            If Not IsNothing(countryGroup) Then
                countryGroup.Attributes.Add("class", "col-md-6")
            End If

            If Not IsNothing(regionGroup) Then
                regionGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(rayonGroup) Then
                rayonGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(townGroup) Then
                townGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(streetGroup) Then
                streetGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(buildingHouseApartmentGroup) Then
                buildingHouseApartmentGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(postalGroup) Then
                postalGroup.Attributes.Add("class", "hidden")
            End If

            If Not IsNothing(coordinatesGroup) Then
                coordinatesGroup.Attributes.Add("class", "hidden")
            End If
            lucExposure_country_required.Visible = True
            lucExposure.ShowCountry = True
            lucExposure.ShowCountryOnly = True
            lucExposure.IsDbRequiredCountry = True
            lucExposure.DataBind()
            foreignAddressType.Visible = True
            relativeAddressType.Visible = False
        End If
    End Sub
#End Region

    Protected Sub ddlOutcome_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlOutcome.SelectedIndexChanged
        If ddlOutcome.SelectedValue = "10770000000" Then
            pnlOutcomeDateofDeath.Visible = True
        Else
            pnlOutcomeDateofDeath.Visible = False
        End If
        hdnPanelController.Value = "10"
    End Sub
    'Protected Sub ddlidfsInterpretedStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsInterpretedStatus.SelectedIndexChanged
    '    hdfstrAccountName.Value = ""
    '    If ddlidfsInterpretedStatus.SelectedIndex > 0 Then
    '        hdfstrAccountName.Value = Session("FamilyName").ToString + ", " + Session("FirstName").ToString
    '        txtstrInterpretedBy.Text = hdfstrAccountName.Value
    '    End If
    'End Sub

    Protected Sub ddlidfsInitialCaseStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsInitialCaseStatus.SelectedIndexChanged
        If ddlidfsInitialCaseStatus.SelectedIndex > 0 And ddlidfsFinalCaseStatus.SelectedIndex < 1 Then
            hdfSummaryCaseClassification.Value = ddlidfsInitialCaseStatus.SelectedItem.Text
            txtSummaryCaseClassification.Text = hdfSummaryCaseClassification.Value
            hdnPanelController.Value = "2"
        End If
    End Sub

    Protected Sub ddlidfsFinalCaseStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsFinalCaseStatus.SelectedIndexChanged
        If ddlidfsFinalCaseStatus.SelectedIndex > 0 Then
            hdfSummaryCaseClassification.Value = ddlidfsFinalCaseStatus.SelectedItem.Text
            txtSummaryCaseClassification.Text = hdfSummaryCaseClassification.Value
        End If
    End Sub

    Private Sub HumanDiseaseReport_Error(Sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then
            ASPNETMsgBox("An error occurred on this page. Please verify your information to resolve the issue.")
        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & Me.GetType.Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()

    End Sub

    Protected Sub Validate3DateOrder(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True  'if none of the three are set to dates, return "isValid = true" condition
        Try
            If IsDate(txtdatDateOfDiagnosis.Text.Trim()) And IsDate(txtdatNotificationDate.Text.Trim()) Then
                isValidOrder = (CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) <= CType(txtdatNotificationDate.Text.Trim(), DateTime))
            End If

            args.IsValid = isValidOrder
            'hdnPanelController.Value = 0
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Throw
        End Try
    End Sub

    Protected Sub ValidateDateOfNotification(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True  'if none of the three are set to dates, return "isValid = true" condition
        Try
            If IsDate(txtdatNotificationDate.Text.Trim()) Then
                isValidOrder = (CType(txtdatNotificationDate.Text.Trim(), DateTime) <= DateTime.Now)
            End If

            If (IsDate(txtdatNotificationDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim())) Then
                isValidOrder = (CType(txtdatNotificationDate.Text.Trim(), DateTime) >= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) And CType(txtdatNotificationDate.Text.Trim(), DateTime) <= DateTime.Now)
            End If

            args.IsValid = isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Throw
        End Try
    End Sub
    Protected Sub ValidateNotFutureDate(source As Object, args As ServerValidateEventArgs)
        Dim isValidDate As Boolean = True  'if none of the three are set to dates, return "isValid = true" condition
        Try
            If IsDate(txtdatDateOfDiagnosis.Text.Trim()) Then
                isValidDate = CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) <= DateTime.Now
            End If

            args.IsValid = isValidDate
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Protected Sub ValidateNotFutureNotificationDate(source As Object, args As ServerValidateEventArgs)
        Dim isValidDate As Boolean = True
        Try

            If IsDate(txtdatNotificationDate.Text.Trim()) Then
                isValidDate = CType(txtdatNotificationDate.Text.Trim(), DateTime) <= DateTime.Now
            End If

            args.IsValid = isValidDate
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Protected Sub ValidateNotFutureSymptomOnsetDate(source As Object, args As ServerValidateEventArgs)
        Dim isValidDate As Boolean = True

        Try
            If IsDate(txtdatOnSetDate.Text.Trim()) Then
                isValidDate = CType(txtdatOnSetDate.Text.Trim(), DateTime) <= DateTime.Now
            End If

            args.IsValid = isValidDate
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Protected Sub ValidateDoc(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True

        Try
            If (IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
                isValidOrder = (CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= Date.Now)
            End If

            If (Not IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
                isValidOrder = True
            ElseIf (Not IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
                isValidOrder = CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= Date.Now
            End If

            If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatFirstSoughtCareDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim())) Then
                isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime)) And (CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime)) And (CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= Date.Now)
            End If
            args.IsValid = isValidOrder

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub
    Protected Sub ValidateDoh(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True

        Try
            If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatNotificationDate.Text.Trim())) Then
                isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatHospitalizationDate.Text.Trim(), DateTime)) And (CType(txtdatHospitalizationDate.Text.Trim(), DateTime) <= Date.Now)
            End If
            args.IsValid = isValidOrder

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Protected Sub ValidateDoi(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True
        Try
            If (Not IsDate(txtStartDateofInvestigation.Text.Trim())) Then
                isValidOrder = True
            ElseIf ((Not IsDate(txtdatNotificationDate.Text.Trim())) And IsDate(txtStartDateofInvestigation.Text.Trim())) Then
                isValidOrder = CType(txtStartDateofInvestigation.Text.Trim(), DateTime) <= Date.Now
            ElseIf IsDate(txtdatNotificationDate.Text.Trim()) Then
                isValidOrder = (CType(txtStartDateofInvestigation.Text.Trim(), DateTime) > CType(txtdatNotificationDate.Text.Trim(), DateTime)) And (CType(txtStartDateofInvestigation.Text.Trim(), DateTime) <= Date.Now)
            End If
            args.IsValid = isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Protected Sub ValidateDod(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True

        Try
            If (Not IsDate(txtdatDischargeDate.Text.Trim())) Then
                isValidOrder = True
            ElseIf ((Not IsDate(txtdatHospitalizationDate.Text.Trim())) And IsDate(txtdatDischargeDate.Text.Trim())) Then
                isValidOrder = CType(txtdatDischargeDate.Text.Trim(), DateTime) <= Date.Now
            ElseIf (IsDate(txtdatHospitalizationDate.Text.Trim()) And IsDate(txtdatDischargeDate.Text.Trim())) Then
                isValidOrder = (CType(txtdatHospitalizationDate.Text.Trim(), DateTime) <= CType(txtdatDischargeDate.Text.Trim(), DateTime)) And (CType(txtdatDischargeDate.Text.Trim(), DateTime) <= Date.Now)
            End If
            args.IsValid = isValidOrder

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Protected Sub ValidatorDateOfClassification(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True

        Try
            If (IsDate(txtDateofClassification.Text.Trim()) And IsDate(txtAddFieldTestResultDate.Text.Trim())) Then
                isValidOrder = (CType(txtDateofClassification.Text.Trim(), DateTime) >= CType(txtAddFieldTestResultDate.Text.Trim(), DateTime) And CType(txtDateofClassification.Text.Trim(), DateTime) <= Date.Now)

            ElseIf (Not IsDate(txtAddFieldTestResultDate.Text.Trim()) And IsDate(txtDateofClassification.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim())) Then
                isValidOrder = (CType(txtDateofClassification.Text.Trim(), DateTime) >= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) And CType(txtDateofClassification.Text.Trim(), DateTime) <= Date.Now)

            End If

            args.IsValid = isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub
    Protected Sub ValidateDateOfSymptoms(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True

        Try
            If (IsDate(txtdatOnSetDate.Text.Trim())) Then
                isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= Date.Now)

            End If

            If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim())) Then
                isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) And CType(txtdatOnSetDate.Text.Trim(), DateTime) <= Date.Now)

            End If

            args.IsValid = isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Protected Sub ValidateSentByReqIfDiagIsSyndromic(source As Object, args As ServerValidateEventArgs)
        'if diagnosis is syndromic, then must have a value set
        Dim isValidOrder As Boolean = True
        Try
            If ((ddlidfsFinalDiagnosis.Text = "10019001") Or (ddlidfsFinalDiagnosis.Text = "10019002")) Then
                isValidOrder = ddlNotificationSentBy.SelectedValue <> "null"
            End If

            args.IsValid = isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub
    Protected Sub ValidateSentByNameReqIfDiagIsSyndromic(source As Object, args As ServerValidateEventArgs)
        'if diagnosis is syndromic, then must have a value set
        Dim isValidOrder As Boolean = True
        Try
            If ((ddlidfsFinalDiagnosis.Text = "10019001") Or (ddlidfsFinalDiagnosis.Text = "10019002")) Then
                isValidOrder = ddlNotificationSentByName.SelectedValue <> "null"
            End If

            args.IsValid = isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Protected Sub ValidateFAD(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True
        Try
            If Not IsDate(txdatFirstAdministeredDate.Text.Trim()) Then
                isValidOrder = True
            End If

            If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
                isValidOrder = (CType(txdatFirstAdministeredDate.Text.Trim(), DateTime) >= CType(txtdatOnSetDate.Text.Trim(), DateTime)) And (CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= Date.Now)
            End If
            args.IsValid = isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Protected Function IsValidFAD() As Boolean
        Dim isValidOrder As Boolean = True
        Try
            If Not IsDate(txdatFirstAdministeredDate.Text.Trim()) Then
                isValidOrder = True
            End If

            If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
                isValidOrder = (CType(txdatFirstAdministeredDate.Text.Trim(), DateTime) >= CType(txtdatOnSetDate.Text.Trim(), DateTime)) And (CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= Date.Now)
            End If

            Return isValidOrder
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Function


    Protected Sub gvSamples_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvSamples.SelectedIndexChanged
        'Dim idx As Integer = 0
        fillBasicSamplesModal()
        btnMasAddSampleSave.Enabled = True
        btnMasAddSampleDelete.Enabled = True
        Dim idx As Integer = gvSamples.SelectedIndex

        mastxtSampleId.Text = If(Not IsDBNull(gvSamples.DataKeys(idx).Values(2).ToString()), gvSamples.DataKeys(idx).Values(2).ToString(), String.Empty)

        masddlSampleType.ClearSelection()
        masddlSampleType.Items.FindByValue(If(Not IsNothing(gvSamples.DataKeys(idx).Values(3)), gvSamples.DataKeys(idx).Values(3), -1)).SelectItem()

        masAddSampleDateCollected.Text = If(Not IsNothing(gvSamples.DataKeys(idx).Values(4)), gvSamples.DataKeys(idx).Values(4), String.Empty)

        masAddSampleLocalSampleId.Text = If(Not IsNothing(gvSamples.DataKeys(idx).Values(5)), gvSamples.DataKeys(idx).Values(5).ToString(), String.Empty)
        masAddSampleDateSent.Text = If(Not IsNothing(gvSamples.DataKeys(idx).Values(6)), gvSamples.DataKeys(idx).Values(6).ToString(), String.Empty)

        ddlmasAddSampleSentTo.ClearSelection()
        ddlmasAddSampleSentTo.Items.FindByValue(If(Not IsNothing(gvSamples.DataKeys(idx).Values(7)), gvSamples.DataKeys(idx).Values(7), -1)).SelectItem()

        hdfModalAddSampleGuid.Value = If(Not IsNothing(gvSamples.DataKeys(idx).Values(10)), gvSamples.DataKeys(idx).Values(10).ToString(), String.Empty)

        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalSampleTab", "openModalSampleTab();", True)
    End Sub


    Protected Sub gvTests_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvTests.SelectedIndexChanged
        Dim idx As Integer = gvTests.SelectedIndex
        ViewState("TestGridSelectedIndex") = idx

        fillBasicTestsModal()

        Dim fieldBarCode As String
        fieldBarCode = gvTests.DataKeys(idx).Values().Item("strFieldBarCode").ToString()
        Dim barCode As String
        barCode = gvTests.DataKeys(idx).Values().Item("strBarcode").ToString()
        Dim interpretedStatus As String
        interpretedStatus = gvTests.DataKeys(idx).Values().Item("idfsInterpretedStatus").ToString()
        Dim diagnosis As String
        diagnosis = gvTests.DataKeys(idx).Values().Item("idfsDiagnosis").ToString()

        'ddlmatLocalSampleId.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(14)), gvTests.DataKeys(idx).Values(14).ToString(), Nothing)).SelectItem()
        ddlmatLocalSampleId.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values().Item("strFieldBarCode")), gvTests.DataKeys(idx).Values().Item("strFieldBarCode"), Nothing)).SelectItem()
        ddlmatLocalSampleId.SelectedIndex = 1
        txtstrBarCode.Text = barCode
        datAddFieldTestResultReceived.Text = If(Not IsNothing(gvTests.DataKeys(idx).Values(9)), gvTests.DataKeys(idx).Values(9), String.Empty)
        txtAddFieldTestResultDate.Text = If(Not IsNothing(gvTests.DataKeys(idx).Values(10)), gvTests.DataKeys(idx).Values(10), String.Empty)
        txtidfsSampleType.Text = gvTests.DataKeys(idx).Values().Item("strSampleTypeName").ToString()
        ddlSampleTestName.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(3)), gvTests.DataKeys(idx).Values(3).ToString(), -1)).SelectItem()
        ddlSampleTestCategory.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(4)), gvTests.DataKeys(idx).Values(4).ToString(), -1)).SelectItem()
        ddlSampleTestResult.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(5)), gvTests.DataKeys(idx).Values(5).ToString(), -1)).SelectItem()
        ddlSampleTestStatus.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(6)), gvTests.DataKeys(idx).Values(6).ToString(), -1)).SelectItem()
        ddlSampleTestDiagnosis.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(7)), gvTests.DataKeys(idx).Values(7).ToString(), -1)).SelectItem()
        'ddlAddFieldTestTestedByInstitution.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(8)), gvTests.DataKeys(idx).Values(8).ToString(), -1)).SelectItem()
        ' ddlAddFieldTestTestedBy.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(11)), gvTests.DataKeys(idx).Values(11).ToString(), -1)).SelectItem()
        hdfModalAddTestGuid.Value = gvTests.DataKeys(idx).Values(13).ToString()
        hdfModalAddTestNewIndicator.Value = String.Empty

        If interpretedStatus = "10104001" Then
            ddlidfsInterpretedStatus.SelectedItem.Text = GetLocalResourceObject("Lbl_Interpreted_Status_Rule_In.InnerText")
        ElseIf interpretedStatus = "10104002" Then
            ddlidfsInterpretedStatus.SelectedItem.Text = GetLocalResourceObject("Lbl_Interpreted_Status_Rule_Out.InnerText")
        End If

        txtstrInterpretedBy.Text = hdfstrAccountName.Value
        txtstrValidatedBy.Text = hdfstrAccountName.Value

        ddlSampleTestDiagnosis.SelectedItem.Value = diagnosis

        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalSampleTab", "openModalTestTab();", True)

    End Sub


    Protected Sub SetSampleModalValuesToGrid()
        Dim idx As Integer = gvSamples.SelectedIndex

        'loop through ViewState dsHdrSamples.Tables(0): if materialid matches, assign values
        Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        For Each r As clsHumanDiseaseSample In HdrSampleList
            If idx > -1 Then
                If (r.sampleGuid = gvSamples.DataKeys(idx).Values(10)) Then
                    r.strBarcode = mastxtSampleId.Text
                    r.idfsSampleType = masddlSampleType.SelectedValue
                    r.strSampleTypeName = masddlSampleType.SelectedItem.Text
                    'special date handling here to fix 1/1/0001 date shown
                    If (IsDate(masAddSampleDateCollected.Text) And (Not String.IsNullOrEmpty(masAddSampleDateCollected.Text))) Then
                        r.datFieldCollectionDate = Convert.ToDateTime(masAddSampleDateCollected.Text)
                    Else
                        r.datFieldCollectionDate = Nothing
                    End If
                    r.strFieldBarcode = masAddSampleLocalSampleId.Text
                    If (IsDate(masAddSampleDateSent.Text) And (Not String.IsNullOrEmpty(masAddSampleDateSent.Text))) Then
                        r.datFieldSentDate = Convert.ToDateTime(masAddSampleDateSent.Text)
                    Else
                        r.datFieldSentDate = Nothing
                    End If
                    r.idfSendToOffice = ddlmasAddSampleSentTo.SelectedValue
                    r.strSendToOffice = ddlmasAddSampleSentTo.SelectedItem.Text
                End If
            End If
        Next
        ViewState(HDR_SAMPLES_GvList) = HdrSampleList
        gvSamples.DataSource = HdrSampleList
        gvSamples.DataBind()

        If gvSamples.Rows.Count > 0 Then
            btnHdrAddNewTest.Enabled = True
        Else
            btnHdrAddNewTest.Enabled = False
        End If
    End Sub

    Protected Sub SetTestModalValuesToGrid()
        Dim idx As Integer = gvTests.SelectedIndex

        'loop through ViewState dsHdrSamples.Tables(0): if materialid matches, assign values
        Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
        For Each r As clsHumanDiseaseTest In HdrTestList
            If idx > -1 Then
                If (r.testGuid = gvTests.DataKeys(idx).Values(13)) Then
                    r.strBarcode = txtstrBarCode.Text
                    r.strFieldBarcode = ddlmatLocalSampleId.SelectedItem.Text
                    r.sampleGuid = ddlmatLocalSampleId.SelectedValue
                    r.idfsSampleType = txtidfsSampleType.Text
                    r.strSampleTypeName = txtidfsSampleType.Text
                    r.idfsTestName = ddlSampleTestName.SelectedValue
                    r.name = ddlSampleTestName.SelectedItem.Text
                    r.idfsDiagnosis = ddlSampleTestDiagnosis.SelectedValue
                    'special date handling here to fix 1/1/0001 date shown
                    If (IsDate(txtAddFieldTestResultDate.Text) And (Not String.IsNullOrEmpty(txtAddFieldTestResultDate.Text))) Then
                        r.datConcludedDate = Convert.ToDateTime(txtAddFieldTestResultDate.Text)
                    Else
                        r.datConcludedDate = Nothing
                    End If
                    r.idfsTestCategory = ddlSampleTestCategory.SelectedValue
                    r.idfsTestStatus = sampleTestStatusValue
                    r.strTestStatus = sampleTestStatusText
                    r.idfsTestResult = ddlSampleTestResult.SelectedValue
                    'r.idfTestedByOffice = ddlAddFieldTestTestedByInstitution.SelectedValue
                    ' r.idfTestedByPerson = ddlAddFieldTestTestedBy.SelectedValue
                    If (IsDate(datAddFieldTestResultReceived.Text) And (Not String.IsNullOrEmpty(datAddFieldTestResultReceived.Text))) Then
                        r.datReceivedDate = Convert.ToDateTime(datAddFieldTestResultReceived.Text)
                    Else
                        r.datReceivedDate = Nothing
                    End If

                    r.idfsInterpretedStatus = ddlidfsInterpretedStatus.SelectedValue
                    r.strInterpretedComment = txtstrInterpretedComment.Text
                    r.datInterpretedDate = Convert.ToDateTime(txtdatInterpretedDate.Text)
                    r.strInterpretedBy = txtstrInterpretedBy.Text
                    If chkblnValidateStatus.Checked Then
                        r.blnValidateStatus = 1
                    Else
                        r.blnValidateStatus = 0
                    End If
                    r.strValidateComment = txtstrValidateComment.Text
                    r.datValidationDate = Convert.ToDateTime(txtdatValidationDate.Text)
                    r.strValidatedBy = txtstrValidatedBy.Text
                    r.strAccountName = hdfstrAccountName.Value
                End If
            End If
        Next
        ViewState(HDR_TESTS_GvList) = HdrTestList
        gvTests.DataSource = HdrTestList
        gvTests.DataBind()
    End Sub

    Protected Sub ddlAddFieldTestFieldSampleID_SelectedIndexChanged()

    End Sub

    Protected Sub ddlOutcome_SelectedIndexChanged()

    End Sub

    Private Sub btnMasAddSampleSave_Click(sender As Object, e As EventArgs) Handles btnMasAddSampleSave.Click
        If (mastxtSampleId.Text.Contains("New") And hdfModalAddSampleGuid.Value = String.Empty) Then
            AddNewSampleToGrid()
        Else
            'save this sample to grid
            SetSampleModalValuesToGrid()
        End If
        'close modal
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddSampleClose", "closeModalAddSample();", True)
    End Sub

    Private Sub AddNewSampleToGrid()
        Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        Dim r As New clsHumanDiseaseSample

        'Check If your Sample collection exists
        If HdrSampleList Is Nothing Then
            HdrSampleList = New List(Of clsHumanDiseaseSample)
        End If

        'r.strBarcode = mastxtSampleId.Text
        r.idfsSampleType = masddlSampleType.SelectedValue
        r.strSampleTypeName = masddlSampleType.SelectedItem.Text
        'special date handling here to fix 1/1/0001 date shown
        If (IsDate(masAddSampleDateCollected.Text) And (Not String.IsNullOrEmpty(masAddSampleDateCollected.Text))) Then
            r.datFieldCollectionDate = Convert.ToDateTime(masAddSampleDateCollected.Text)
        Else
            r.datFieldCollectionDate = Nothing
        End If
        r.strFieldBarcode = masAddSampleLocalSampleId.Text
        If (IsDate(masAddSampleDateSent.Text) And (Not String.IsNullOrEmpty(masAddSampleDateSent.Text))) Then
            r.datFieldSentDate = Convert.ToDateTime(masAddSampleDateSent.Text)
        Else
            r.datFieldSentDate = Nothing
        End If
        r.idfSendToOffice = ddlmasAddSampleSentTo.SelectedValue
        r.strSendToOffice = ddlmasAddSampleSentTo.SelectedItem.Text
        r.intRowStatus = 0
        r.sampleGuid = Guid.NewGuid()

        If Not String.IsNullOrEmpty(hdfidfHumanCase.Value) Then
            r.idfHumanCase = hdfidfHumanCase.Value
        End If

        HdrSampleList.Add(r)
        ViewState(HDR_SAMPLES_GvList) = HdrSampleList
        gvSamples.DataSource = HdrSampleList
        gvSamples.DataBind()

        If gvSamples.Rows.Count > 0 Then
            btnHdrAddNewTest.Enabled = True
        Else
            btnHdrAddNewTest.Enabled = False
        End If
    End Sub

    Private Sub AddNewTestToGrid()
        Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
        Dim r As New clsHumanDiseaseTest

        'Check If your Test collection exists
        If HdrTestList Is Nothing Then
            HdrTestList = New List(Of clsHumanDiseaseTest)
        End If

        'selected Sample- required
        r.sampleGuid = Nothing   'find this value from the selected dropdown value of SampleFieldBarcode
        r.idfMaterial = -1
        r.strBarcode = txtstrBarCode.Text
        r.strFieldBarcode = ddlmatLocalSampleId.SelectedItem.Text
        r.sampleGuid = ddlmatLocalSampleId.SelectedValue
        r.idfsSampleType = txtidfsSampleType.Text
        r.strSampleTypeName = txtidfsSampleType.Text

        r.idfsTestName = ddlSampleTestName.SelectedValue
        r.name = ddlSampleTestName.SelectedItem.Text
        r.idfsDiagnosis = ddlSampleTestDiagnosis.SelectedValue
        'special date handling here to fix 1/1/0001 date shown
        If (IsDate(txtAddFieldTestResultDate.Text) And (Not String.IsNullOrEmpty(txtAddFieldTestResultDate.Text))) Then
            r.datConcludedDate = Convert.ToDateTime(txtAddFieldTestResultDate.Text)
        Else
            r.datConcludedDate = Nothing
        End If
        r.idfsTestCategory = ddlSampleTestCategory.SelectedValue
        r.idfsTestStatus = sampleTestStatusValue
        r.strTestStatus = sampleTestStatusText
        r.idfsTestResult = ddlSampleTestResult.SelectedValue
        ' r.idfTestedByOffice = ddlAddFieldTestTestedByInstitution.SelectedValue
        ' r.idfTestedByPerson = ddlAddFieldTestTestedBy.SelectedValue
        If (IsDate(datAddFieldTestResultReceived.Text) And (Not String.IsNullOrEmpty(datAddFieldTestResultReceived.Text))) Then
            r.datReceivedDate = Convert.ToDateTime(datAddFieldTestResultReceived.Text)
        Else
            r.datReceivedDate = Nothing
        End If

        r.idfsInterpretedStatus = ddlidfsInterpretedStatus.SelectedValue
        r.strInterpretedComment = txtstrInterpretedComment.Text
        r.datInterpretedDate = Convert.ToDateTime(txtdatInterpretedDate.Text)
        r.strInterpretedBy = txtstrInterpretedBy.Text
        If chkblnValidateStatus.Checked Then
            r.blnValidateStatus = 1
        Else
            r.blnValidateStatus = 0
        End If
        r.strValidateComment = txtstrValidateComment.Text
        r.datValidationDate = Convert.ToDateTime(txtdatValidationDate.Text)
        r.strValidatedBy = txtstrValidatedBy.Text
        r.strAccountName = hdfstrAccountName.Value

        r.newIndicator = hdfModalAddTestNewIndicator.Value    'find this value
        r.intRowStatus = 0
        r.testGuid = Guid.NewGuid()

        If Not String.IsNullOrEmpty(hdfidfHumanCase.Value) Then
            r.idfHumanCase = hdfidfHumanCase.Value
        End If

        HdrTestList.Add(r)
        ViewState(HDR_TESTS_GvList) = HdrTestList
        gvTests.DataSource = HdrTestList
        gvTests.DataBind()
    End Sub
    Private Sub AddNewVaccinationToGrid()
        Dim HdrVaccinationList = TryCast(ViewState(HDR_VACCINATIONS_GvList), List(Of clsHumanDiseaseVaccination))

        'Check If your Vaccination collection exists
        If HdrVaccinationList Is Nothing Then
            HdrVaccinationList = New List(Of clsHumanDiseaseVaccination)
        End If

        Dim r As New clsHumanDiseaseVaccination

        r.humanDiseaseReportVaccinationUID = 0
        r.vaccinationName = txtVaccinationName.Text
        r.vaccinationDate = Convert.ToDateTime(txtVaccinationDate.Text)
        If Not String.IsNullOrEmpty(hdfidfHumanCase.Value) Then
            r.idfHumanCase = hdfidfHumanCase.Value
        End If

        HdrVaccinationList.Add(r)
        ViewState(HDR_VACCINATIONS_GvList) = HdrVaccinationList
        gvVaccinations.DataSource = HdrVaccinationList
        gvVaccinations.DataBind()

        txtVaccinationName.Text = String.Empty
        txtVaccinationDate.Text = String.Empty

    End Sub

    Private Sub AddNewAntiviralTherapyToGrid()
        Dim HdrAntiviralTherapyList = TryCast(ViewState(HDR_ANTIVIRALTHERAPIES_GvList), List(Of clsHumanDiseaseAntiviralThearapy))
        Dim r As New clsHumanDiseaseAntiviralThearapy

        'Check If your AntiviralTherapy collection exists
        If HdrAntiviralTherapyList Is Nothing Then
            HdrAntiviralTherapyList = New List(Of clsHumanDiseaseAntiviralThearapy)
        End If

        r.idfAntimicrobialTherapy = 0
        r.strAntimicrobialTherapyName = txtstrAntibioticName.Text
        r.strDosage = txtstrDosage.Text
        r.datFirstAdministeredDate = Convert.ToDateTime(txdatFirstAdministeredDate.Text)
        If Not String.IsNullOrEmpty(hdfidfHumanCase.Value) Then
            r.idfHumanCase = hdfidfHumanCase.Value
        End If

        HdrAntiviralTherapyList.Add(r)
        ViewState(HDR_ANTIVIRALTHERAPIES_GvList) = HdrAntiviralTherapyList
        gvAntiviralTherapies.DataSource = HdrAntiviralTherapyList
        gvAntiviralTherapies.DataBind()

        txtstrAntibioticName.Text = String.Empty
        txtstrDosage.Text = String.Empty
        txdatFirstAdministeredDate.Text = String.Empty

    End Sub

    Private Sub btnMasAddSampleDelete_Click(sender As Object, e As EventArgs) Handles btnMasAddSampleDelete.Click
        'delete this sample from the grid
        Dim idx As Integer = gvSamples.SelectedIndex
        Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        For Each r As clsHumanDiseaseSample In HdrSampleList
            If (r.sampleGuid = gvSamples.DataKeys(idx).Values(10)) Then
                r.strBarcode = mastxtSampleId.Text
                r.idfsSampleType = masddlSampleType.SelectedValue
                r.strSampleTypeName = masddlSampleType.SelectedItem.Text
                'special date handling here to fix 1/1/0001 date shown
                If (IsDate(masAddSampleDateCollected.Text) And (Not String.IsNullOrEmpty(masAddSampleDateCollected.Text))) Then
                    r.datFieldCollectionDate = Convert.ToDateTime(masAddSampleDateCollected.Text)
                Else
                    r.datFieldCollectionDate = Nothing
                End If
                r.strFieldBarcode = masAddSampleLocalSampleId.Text
                If (IsDate(masAddSampleDateSent.Text) And (Not String.IsNullOrEmpty(masAddSampleDateSent.Text))) Then
                    r.datFieldSentDate = Convert.ToDateTime(masAddSampleDateSent.Text)
                Else
                    r.datFieldSentDate = Nothing
                End If
                r.idfSendToOffice = ddlmasAddSampleSentTo.SelectedValue
                r.strSendToOffice = ddlmasAddSampleSentTo.SelectedItem.Text
                r.intRowStatus = 1
            End If
        Next

        ViewState(HDR_SAMPLES_GvList) = HdrSampleList
        gvSamples.DataSource = HdrSampleList
        gvSamples.DataBind()
        'close modal
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddSampleClose", "closeModalAddSample();", True)
    End Sub

    Private Sub gvSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSamples.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim r As clsHumanDiseaseSample = e.Row.DataItem
            If (r.intRowStatus = 1) Then
                e.Row.ForeColor = System.Drawing.Color.LightGray
            End If
        End If
    End Sub

    Private Sub gvTests_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTests.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim r As clsHumanDiseaseTest = e.Row.DataItem
            If (r.intRowStatus = 1) Then
                e.Row.ForeColor = System.Drawing.Color.LightGray
            End If
        End If
    End Sub


    Private Sub btnModalAddTestSave_Click(sender As Object, e As EventArgs) Handles btnModalAddTestSave.Click
        'save this Test to grid
        If (hdfModalAddTestNewIndicator.Value.Contains("New") And hdfModalAddTestGuid.Value = String.Empty) Then
            AddNewTestToGrid()
        Else
            Dim idx As Integer = gvTests.SelectedIndex
            'save this sample to grid
            SetTestModalValuesToGrid()
        End If

        'close modal
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddTestClose", "closeModalAddTest();", True)

    End Sub

    Private Sub btnModalAddTestDelete_Click(sender As Object, e As EventArgs) Handles btnModalAddTestDelete.Click
        'delete this Test from the grid
        Dim idx As Integer = gvTests.SelectedIndex
        Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))

        For Each r As clsHumanDiseaseTest In HdrTestList
            If (r.testGuid = gvTests.DataKeys(idx).Values().Item("strFieldBarCode").ToString()) Then
                r.strBarcode = txtstrBarCode.Text
                r.sampleGuid = ddlmatLocalSampleId.SelectedValue
                r.strFieldBarcode = ddlmatLocalSampleId.SelectedItem.Text
                r.idfsSampleType = txtidfsSampleType.Text
                r.strSampleTypeName = txtidfsSampleType.Text
                r.idfsTestName = ddlSampleTestName.SelectedValue
                r.name = ddlSampleTestName.SelectedItem.Text
                r.idfsDiagnosis = ddlSampleTestDiagnosis.SelectedValue
                'special date handling here to fix 1/1/0001 date shown
                If (IsDate(txtAddFieldTestResultDate.Text) And (Not String.IsNullOrEmpty(txtAddFieldTestResultDate.Text))) Then
                    r.datConcludedDate = Convert.ToDateTime(txtAddFieldTestResultDate.Text)
                Else
                    r.datConcludedDate = Nothing
                End If

                r.idfsTestCategory = ddlSampleTestCategory.SelectedValue
                r.idfsTestStatus = sampleTestStatusValue
                r.strTestStatus = sampleTestStatusText
                r.idfsTestResult = ddlSampleTestResult.SelectedValue
                ' r.idfTestedByOffice = ddlAddFieldTestTestedByInstitution.SelectedValue
                ' r.idfTestedByPerson = ddlAddFieldTestTestedBy.SelectedValue
                If (IsDate(datAddFieldTestResultReceived.Text) And (Not String.IsNullOrEmpty(datAddFieldTestResultReceived.Text))) Then
                    r.datReceivedDate = Convert.ToDateTime(datAddFieldTestResultReceived.Text)
                Else
                    r.datReceivedDate = Nothing
                End If
                r.intRowStatus = 1
            End If
        Next
        ViewState(HDR_TESTS_GvList) = HdrTestList
        gvTests.DataSource = HdrTestList
        gvTests.DataBind()
        'close modal
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddTestClose", "closeModalAddTest();", True)
    End Sub
    Private Sub ddlmasAddSampleSentTo_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlmasAddSampleSentTo.SelectedIndexChanged
        If (ddlmasAddSampleSentTo.SelectedIndex > 0) Then
            btnMasAddSampleSave.Enabled = True
        Else
            btnMasAddSampleSave.Enabled = False
        End If
        'this postback causes the bootstrap modal to go away and screen is greyed out. The following will keep the modal open with values.
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddTestContinue", "continueWithModalSampleTab();", True)
    End Sub

    Private Sub ddlSampleTestDiagnosis_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSampleTestDiagnosis.SelectedIndexChanged
        If ddlSampleTestDiagnosis.SelectedIndex > 0 Then
            btnModalAddTestSave.Enabled = True
            If (hdfModalAddTestGuid.Value.ToString().Length > 0) Then  'if we have a GUID it is preexisting from the grid, allow delete
                btnModalAddTestDelete.Enabled = True
            End If
        End If
        'this postback causes the bootstrap modal to go away and screen is greyed out. The following will keep the modal open with values.
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddTestContinue", "continueWithModalTestTab();", True)
    End Sub

    Private Sub ddlSampleTestStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSampleTestStatus.SelectedIndexChanged
        If (ddlSampleTestDiagnosis.SelectedIndex > 0 And ddlSampleTestStatus.SelectedIndex > 0) Then
            btnModalAddTestSave.Enabled = True
            If (hdfModalAddTestGuid.Value.ToString().Length > 0) Then  'if we have a GUID it is preexisting from the grid, allow delete
                btnModalAddTestDelete.Enabled = True
            End If
        End If
        'this postback causes the bootstrap modal to go away and screen is greyed out. The following will keep the modal open with values.
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddTestContinue", "continueWithModalTestTab();", True)
    End Sub

    Protected Sub btnShowDiseaseReportSummary_Click(sender As Object, e As EventArgs) Handles btnShowDiseaseReportSummary.Click
        diseasedHumanDetail.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)
        diseaseReportSummaryStatus.Attributes.Remove("class")

        If hdfSessionInformationDisplay.Value = "none" Then
            diseasedHumanDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            hdfSessionInformationDisplay.Value = "block"
            diseaseReportSummaryStatus.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
        Else
            diseasedHumanDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            hdfSessionInformationDisplay.Value = "none"
            diseaseReportSummaryStatus.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        End If
    End Sub

    Private Sub btnAddContact_Click(sender As Object, e As EventArgs) Handles btnAddContact.Click

    End Sub

#End Region

End Class