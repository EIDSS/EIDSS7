Imports EIDSS.EIDSS
Imports EIDSS.BaseEidssPage

Public Class HumanDiseaseReportUserControl
    Inherits System.Web.UI.UserControl

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
    Private lookupSampleIdList As New List(Of clsRefGuidStringList)

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private Cosr
    Private Const sampleTestStatusText As String = "Final"
    Private Const sampleTestStatusValue As Int64 = 10001001

    Private oCommon As clsCommon = New clsCommon()

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Check language. Inherited from BaseEidssPage
        'If PageLanguage.ToString().IsValueNullOrEmpty() Then PageLanguage = getConfigValue(GlobalConstants.DefaultLanguage, "en-us")
        'hdfLangID.Value = PageLanguage
        Dim oComm As clsCommon = New clsCommon()

        If Not Page.IsPostBack Then
            ExtractViewStateSession()

            rdbExposureAddressTypeExact.Checked = True
            lucExposure.ShowCountry = False
            lucExposure.ShowCountryOnly = False
            lucExposure.IsDbRequiredCountry = False
            lucExposure.DataBind()
            foreignAddressType.Visible = False
            relativeAddressType.Visible = False

            If (ViewState(CALLER).ToString().EqualsAny({CallerPages.Person})) Then
                OpenPageFromPerson()

            ElseIf (ViewState(CALLER).ToString().EqualsAny({CallerPages.SearchDiseaseReports})) Then
                OpenPageFromReportSearch()

            ElseIf (ViewState(CALLER) = CallerPages.EmployeeAdmin) Then
                'get init values from HDR xml session file 
                sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportInitSuffix)
                Dim ctrlList1 As ICollection(Of Web.UI.Control) = {divHiddenFieldsEAtoHDRInitCache}
                oComm.GetSearchFields(ctrlList1, sFile)
                oComm.DeleteTempFiles(sFile)

                hdfidfHumanActual.Value = hdfEAidfHumanActual.Value
                hdfidfHumanCase.Value = hdfEAHumanCase.Value
                hdfstrHumanCaseId.Value = hdfEAstrHumanCaseId.Value
                hdfCallerPage.Value = hdfEAInitiatingCallerPage.Value
                hdfPageMode.Value = hdfEAPageMode.Value
                hdfCallerKey.Value = hdfEAidfHumanActual.Value

                ViewState(CALLER) = hdfEAInitiatingCallerPage.Value
                ViewState(CALLER_KEY) = hdfCallerKey.Value
                Session("idfHumanActual") = hdfidfHumanActual.Value
                Session("idfHumanCase") = hdfidfHumanCase.Value

                'fill page values based on caller and init values
                If (hdfEAInitiatingCallerPage.Value = CallerPages.SearchDiseaseReports) Then
                    OpenPageFromReportSearch()
                Else
                    OpenPageFromPerson()
                End If

                'fill page values previously set from cache
                '   get all data from HDR xml session file to all tabs on page
                sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSuffix)
                Dim ctrlList2 As ICollection(Of Web.UI.Control) = {disease, divHiddenFieldsSection}
                oComm.GetSearchFields(ctrlList2, sFile)
                oComm.DeleteTempFiles(sFile)

                'get return hidden fields from employeeAdmin xml file
                sFile = oComm.CreateTempFile(CallerPages.EmployeeAdminPrefix)
                Dim ctrlListEA As ICollection(Of Web.UI.Control) = {divHiddenFieldsEAtoHDRResponse}
                oComm.GetSearchFields(ctrlListEA, sFile)
                oComm.DeleteTempFiles(sFile)

                Dim textToShow As String = String.Format("{0}/{1}", hdfEAInstitutionFullName.Value, hdfEAEmployeeFullName.Value)
                If (hdfEALastControlFocus.Value = "txtstrNotificationSentby") Then
                    txtstrNotificationSentby.Text = textToShow
                    hdfidfSentByPerson.Value = hdfEAEmployeeId.Value
                    hdfstrSentByFirstName.Value = hdfEAFirstName.Value
                    hdfstrSentByPatronymicName.Value = hdfEAPatronymicName.Value
                    hdfstrSentByLastName.Value = hdfEALastName.Value
                    hdfidfSentByOffice.Value = hdfEAInstitutionId.Value
                ElseIf (hdfEALastControlFocus.Value = "txtstrNotificationReceivedby") Then
                    txtstrNotificationReceivedby.Text = textToShow
                    hdfidfReceivedByPerson.Value = hdfEAEmployeeId.Value
                    hdfstrReceivedByFirstName.Value = hdfEAFirstName.Value
                    hdfstrReceivedByPatronymicName.Value = hdfEAPatronymicName.Value
                    hdfstrReceivedByLastName.Value = hdfEALastName.Value
                    hdfidfReceivedByOffice.Value = hdfEAInstitutionId.Value
                ElseIf (hdfEALastControlFocus.Value = "txtstrCollectedByOfficer") Then
                    txtstrCollectedByOfficer.Text = textToShow
                    Dim idx As Integer = gvSamples.SelectedIndex
                    If (idx < 0) Then
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
                    Else
                        fillBasicSamplesModal()
                        btnMasAddSampleSave.Enabled = True
                        btnMasAddSampleDelete.Enabled = True

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
                    End If

                    hdnPanelController.Value = "4"

                End If

            ElseIf (ViewState(CALLER) = CallerPages.OrganizationAdmin) Then
                'get init values from HDR xml session file 
                sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportInitSuffix)
                Dim ctrlList1 As ICollection(Of Web.UI.Control) = {divHiddenFieldsEAtoHDRInitCache}
                oComm.GetSearchFields(ctrlList1, sFile)
                oComm.DeleteTempFiles(sFile)

                'get return hidden fields from organizationAdmin xml file
                sFile = oComm.CreateTempFile(CallerPages.OrganizationAdminPrefix)
                Dim ctrlListOA As ICollection(Of Web.UI.Control) = {divHiddenFieldsSection}
                oComm.GetSearchFields(ctrlListOA, sFile)
                oComm.DeleteTempFiles(sFile)

                hdfidfHumanActual.Value = hdfEAidfHumanActual.Value
                hdfidfHumanCase.Value = hdfEAHumanCase.Value
                hdfstrHumanCaseId.Value = hdfEAstrHumanCaseId.Value
                hdfCallerPage.Value = hdfEAInitiatingCallerPage.Value
                hdfPageMode.Value = hdfEAPageMode.Value
                hdfCallerKey.Value = hdfEAidfHumanActual.Value

                ViewState(CALLER) = hdfEAInitiatingCallerPage.Value
                ViewState(CALLER_KEY) = hdfCallerKey.Value
                Session("idfHumanActual") = hdfidfHumanActual.Value
                Session("idfHumanCase") = hdfidfHumanCase.Value

                'fill page values based on caller and init values
                If (hdfEAInitiatingCallerPage.Value = CallerPages.SearchDiseaseReports) Then
                    OpenPageFromReportSearch()
                Else
                    OpenPageFromPerson()
                End If


                Dim textToShow As String = String.Format("{0}", hdfOrgName.Value)
                'Dim textToShow As String = String.Format("{0}/{1}", hdfUniqueOrgID.Value, hdfOrgName.Value)
                hdfEALastControlFocus.Value = "txtstrCollectedByInstitution"
                If (hdfEALastControlFocus.Value = "txtstrCollectedByInstitution") Then
                    txtstrCollectedByInstitution.Text = textToShow
                    hdfOfficeID.Value = hdfOfficeID.Value
                    Dim idx As Integer = gvSamples.SelectedIndex
                    If (idx < 0) Then
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
                    Else
                        fillBasicSamplesModal()
                        btnMasAddSampleSave.Enabled = True
                        btnMasAddSampleDelete.Enabled = True

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
                    End If

                    hdnPanelController.Value = "4"

                End If
            Else
                ViewState(CALLER) = CallerPages.HumanDiseaseReport
                ViewState(CALLER_KEY) = Nothing
                oCommon.SaveViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.PersonURL), True)
            End If

            'Samples grid from cache if cache file has anything
            Dim HdrSampleList As New List(Of clsHumanDiseaseSample)
            sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSamples)
            'Dim oSample As New clsHumanDiseaseSample
            'Dim oSample As New clsSample
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
            'Dim oTest As New clsHumanDiseaseTest
            oComm.HydrateListFromXmlFile(HdrTestList, sFile)
            If (HdrTestList.Count > 0) Then
                ViewState(HDR_TESTS_GvList) = HdrTestList
                gvTests.DataSource = HdrTestList
                gvTests.DataBind()
            End If
            oComm.DeleteTempFiles(sFile)

            'Contacts grid from cache if cache file has anything

        End If

        setIsDiagnosisSyndromic()
        SetControls()
        If Page.IsPostBack Then
            Page.Validate()
        End If

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
        hdfPageMode.Value = PageUsageMode.Edit
        hdfidfHumanActual.Value = ViewState(CALLER_KEY)
        'FillPerson() - removed per bug 1810 Remove Person Information from Human Diesease Report
        hdfCurrentDate.Value = DateTime.Today.ToString("d")
        ToggleVisibility(SectionDisease)
        PopulateDiseaseDropDowns()

        btn_Return_to_Person_Record.Visible = True
        btnReturnToSearch.Visible = True
        btnReturnToReportSearch.Visible = False

        If String.IsNullOrEmpty(txtLegacyCaseID.Text) Then
            divDiseaseLegacyCaseID.Visible = False
        End If

        If (hdfstrHumanCaseId.Value = "" Or hdfstrHumanCaseId.Value = "(New)") Then
            hdfstrHumanCaseId.Value = "(New)"
            hdfPageMode.Value = PageUsageMode.CreateNew
        Else
            FillDiseaseForEdit(hdfidfHumanCase.Value)
            FillDiseaseReportSummary()
        End If
    End Sub

    Private Sub OpenPageFromReportSearch()
        hdfPageMode.Value = PageUsageMode.Edit
        hdfidfHumanActual.Value = Session("hdfidfHumanActual")
        hdfidfHuman.Value = ViewState(CALLER_KEY)
        hdfidfHumanCase.Value = Session("idfHumanCase")
        hdfSearchHumanCaseId.Value = Session("idfHumanCase")
        FillPerson()
        hdfCurrentDate.Value = DateTime.Today.ToString("d")
        ToggleVisibility(SectionDisease)
        btn_Return_to_Person_Record.Visible = False
        btnReturnToSearch.Visible = False
        btnReturnToReportSearch.Visible = True
        PopulateDiseaseDropDowns()
        FillDiseaseForEdit(hdfidfHumanCase.Value)

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
    End Sub
    Private Sub ToggleVisibility(ByVal sSection As String)
        'Containers
        disease.Visible = sSection.EqualsAny({SectionDisease})
        'Set focus to first panel
        If sSection.EqualsAny({SectionPerson, SectionDisease}) Then hdnPanelController.Value = 0
    End Sub

    Private Sub SetControls()
        If (hdfPageMode.Value = PageUsageMode.CreateNew) Then
            If (ddlidfsFinalDiagnosis.Enabled = False) Then
                ddlidfsFinalDiagnosis.Enabled = True
            End If
        Else
            If (ddlidfsFinalDiagnosis.Enabled = True) Then
                ddlidfsFinalDiagnosis.Enabled = False
            End If
        End If

        If (hdfIsDiagnosisSyndromic.Value = 1) Then
            txtdatDateOfDiagnosis.Enabled = False
            txtdatDateOfDiagnosis.Text = String.Empty
            ddlidfsFinalState.Enabled = False
            ddlidfsFinalState.SelectedIndex = -1
            ddlidfsHospitalizationStatus.Enabled = False
            ddlidfsHospitalizationStatus.SelectedIndex = -1
            ddlidfHospital.Enabled = False
            ddlidfHospital.SelectedIndex = -1
            txtstrCurrentLocation.Enabled = False
            txtstrCurrentLocation.Text = String.Empty
            ddlidfsInitialCaseStatus.Enabled = False
            ddlidfsInitialCaseStatus.SelectedIndex = -1
            SetEnableControls(finalOutcome, False)
            SetEnableControls(contactList, False)

            'PatientPreviouslySought1.Enabled = False
            'Hospitalization.Enabled = False
            'LocationofExposureKnown.Enabled = False

            ddlidfsHospitalizationStatus.Enabled = False
            ddlidfHospital.Enabled = False
            txtstrCurrentLocation.Enabled = False

            rblidfsYNHospitalization.Enabled = False



        Else
            txtdatDateOfDiagnosis.Enabled = True
            ddlidfsFinalState.Enabled = True
            ddlidfsHospitalizationStatus.Enabled = True
            ddlidfHospital.Enabled = True
            txtstrCurrentLocation.Enabled = True
            ddlidfsInitialCaseStatus.Enabled = True
            SetEnableControls(finalOutcome, True)
            SetEnableControls(contactList, True)

            'PatientPreviouslySought1.Enabled = True
            'Hospitalization.Enabled = True
            'LocationofExposureKnown.Enabled = True

            ddlidfsHospitalizationStatus.Enabled = True
            ddlidfHospital.Enabled = True
            txtstrCurrentLocation.Enabled = True

            rblidfsYNHospitalization.Enabled = True


        End If

        hospital.Visible = False
        otherLocation.Visible = False
        If (ddlidfsHospitalizationStatus.SelectedValue = "5350000000") Then
            hospital.Visible = True
        ElseIf (ddlidfsHospitalizationStatus.SelectedValue = "5360000000") Then
            otherLocation.Visible = True
            pnlPatientPreviouslySought.Visible = False
            txtdatFirstSoughtCareDate.Enabled = False
            txtFacilityFirstSoughtCare.Enabled = False
            ddlidfsNonNotifiableDiagnosis.Enabled = False
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
                'txtstrHospitalName.Enabled = True
                pnlHospitalization.Visible = True
            Else
                txtdatHospitalizationDate.Enabled = False
                txtdatDischargeDate.Enabled = False
                'txtstrHospitalName.Enabled = False
                pnlHospitalization.Visible = False
            End If
        End If

        samplesGridPanel.Visible = True
        btnSampleNewAdd.Enabled = False
        If (IsNumeric(rblidfsYNSpecimenCollected.SelectedValue)) Then
            btnSampleNewAdd.Enabled = True
            '    If (Convert.ToInt64(rblidfsYNSpecimenCollected.SelectedValue) = 10100001) Then
            '        samplesGridPanel.Visible = True
            '    Else
            '        samplesGridPanel.Visible = False
            '    End If
        End If

        If rdbAntibioticAntiviralTherapyAdministeredYes.Checked Then
            pnlAntiBioticAdministred.Visible = True
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


    End Sub

#End Region

#Region "Person"

    Private Sub FillPerson()
        Try
            Dim oPerson As New clsPerson
            Dim dsPerson As DataSet = oPerson.SelectOne(hdfidfHumanActual.Value)

            If dsPerson.CheckDataSet() Then
                Dim oCommon As New clsCommon

                'Fill form fields
                'oCommon.Scatter(patientReview, New DataTableReader(dsPerson.Tables(0)), 3, True)
            End If
        Catch ae As ArgumentOutOfRangeException

        End Try
    End Sub

#End Region

    Private Sub FillContactsList(Optional sGetDataFor As String = "GRIDROWS",
                        Optional bRefresh As Boolean = False)
        Try
            Dim dsContacts As DataSet
            'Save the data set in view state to re-use
            If bRefresh Then ViewState("dsContacts") = Nothing

            If bRefresh = True Then
                Dim oCommon As New clsCommon()
                Dim oContact As clsContact = New clsContact()
                Dim oService As NG.EIDSSService = oCommon.GetService()

                Dim aSP As String() = oService.getSPList("HumDisContactsGet")
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, aSP(0), 3, True)
                'searchForm
                dsContacts = oContact.ListAll({strParams})
            Else
                dsContacts = CType(ViewState("dsContacts"), DataSet)
            End If

            gvContacts.DataSource = Nothing
            If dsContacts.CheckDataSet() Then
                ViewState("dsContacts") = dsContacts
                gvContacts.DataSource = dsContacts.Tables(0)
                gvContacts.DataBind()
            End If

        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
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
            'txtSummaryidfHumanCase.Text = hdfidfHumanCase.Value
            txtSummaryidfHumanCase.Text = hdfstrCaseId.Value
            divDiseaseHumanDetail.Visible = True
        End If
        If String.IsNullOrEmpty(txtLegacyCaseID.Text) Then
            divDiseaseLegacyCaseID.Visible = False
        End If
        txtSummaryDiagnosis.Text = hdfSummaryIdfsFinalDiagnosis.Value
        txtSummarystrPersonName.Text = hdfstrPersonName.Value
        'txtSummaryEidsId.Text = hdfstrCaseId.Value
        txtSummaryEidsId.Text = hdfstrPersonId.Value
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
        'summaryCaseClassification.Text = hdfFinalCaseStatus.Value

        RelatedSessionID.Visible = False
        If ddlDiseaseReportTypeID.SelectedValue = "Active" Then
            RelatedSessionID.Visible = True
        End If
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

        'Load Organization List
        FillDropDown(ddlidfHospital _
                    , GetType(clsOrganization) _
                    , {"@OrganizationTypeID:" & "10504002", "@intHACode:" & HACodeList.HumanHACode} _
                    , OrganizationConstants.idfInstitution _
                    , OrganizationConstants.OrgName _
                    , Nothing _
                    , Nothing _
                    , True)

        FillDropDown(ddlidfFaciltyHospital _
                    , GetType(clsOrganization) _
                    , {"@OrganizationTypeID:" & "10504002", "@intHACode:" & HACodeList.HumanHACode} _
                    , OrganizationConstants.idfInstitution _
                    , OrganizationConstants.OrgName _
                    , Nothing _
                    , Nothing _
                    , True)


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
        BaseReferenceLookUp(ddlContactGender, BaseReferenceConstants.HumanGender, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlContactRelation, BaseReferenceConstants.ObjectTypeRelation, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlContactRelation, BaseReferenceConstants.PatientContactType, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlContactCitizenship, BaseReferenceConstants.NationalityList, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfContactPhoneType, BaseReferenceConstants.ContactPhoneType, HACodeList.HumanHACode, True)
        'Human Report Status
        BaseReferenceLookUp(ddlidfsCaseProgressStatus, BaseReferenceConstants.CaseStatus, HACodeList.HumanHACode, False)

        'Human Disease Report Type
        BaseReferenceLookUp(ddlDiseaseReportTypeID, BaseReferenceConstants.CaseReportType, HACodeList.HumanHACode, False)

        'BaseReferenceLookUp(ddlAddFieldTestValidated, BaseReferenceConstants.YesNoValueList, HACodeList.NoneHACode, True)

        txtdatInterpretedDate.Text = Convert.ToDateTime(DateTime.Now.ToString())
        txtdatValidationDate.Text = Convert.ToDateTime(DateTime.Now.ToString())

        FillHdrSamplesList()
        FillHdrTestsList()
        FillContactsList(bRefresh:=True)
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
        'ddlAddFieldTestTestedByInstitution.SelectedItem.Selected = False
        'ddlAddFieldTestTestedBy.SelectedItem.Selected = False

        ddlAddFieldTestTestedByInstitution.Visible = False
        ddlAddFieldTestTestedBy.Visible = False
        'ddlSampleTestDiagnosis.SelectedIndex = 0

        'If recID > -1 Then
        'End If
    End Sub

    Private Sub FillHdrSamplesList(Optional sGetDataFor As String = "GRIDROWS",
    Optional bRefresh As Boolean = False)

        Try
            Dim dsHdrSamples As DataSet
            Dim HdrSampleList As New List(Of clsHumanDiseaseSample)

            'Save the data set in view state to re-use
            If bRefresh Then ViewState(HDR_SAMPLES_GvListDS) = Nothing

            If IsNothing(ViewState(HDR_SAMPLES_GvListDS)) Then
                Dim oCommon As New clsCommon()
                Dim oSample As clsSample = New clsSample()
                Dim oService As NG.EIDSSService = oCommon.GetService()
                Dim aSP As String() = oService.getSPList("HumDisSamplesGet")
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, aSP(0), 3, True)
                dsHdrSamples = oSample.ListAllHDRSamples({strParams})
            Else
                dsHdrSamples = CType(ViewState(HDR_SAMPLES_GvListDS), DataSet)
            End If

            gvSamples.DataSource = Nothing
            If dsHdrSamples.CheckDataSet() Then
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
            End If
            'divSearchResultsContainer.Visible = False
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillHdrTestsList(Optional sGetDataFor As String = "GRIDROWS",
    Optional bRefresh As Boolean = False)
        Try
            Dim dsHdrTests As DataSet
            Dim HdrTestList As New List(Of clsHumanDiseaseTest)
            'Save the data set in view state to re-use
            If bRefresh Then ViewState(HDR_TESTS_GvListDS) = Nothing
            If IsNothing(ViewState(HDR_TESTS_GvListDS)) Then
                Dim oCommon As New clsCommon()
                Dim oTest As clsTest = New clsTest()
                Dim oService As NG.EIDSSService = oCommon.GetService()
                Dim aSP As String() = oService.getSPList("HumDisTestsGet")
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, aSP(0), 3, True)
                dsHdrTests = oTest.ListAllHDRTests({strParams})
            Else
                dsHdrTests = CType(ViewState(HDR_TESTS_GvListDS), DataSet)
            End If

            gvTests.DataSource = Nothing
            If dsHdrTests.CheckDataSet() Then
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
            End If
            'divSearchResultsContainer.Visible = False
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
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

        'For Each row In gvSamples.Rows
        '    Dim i As clsRefGuidStringList = New clsRefGuidStringList()
        '    'i.id = r.sampleGuid
        '    i.text = row.cells(3).Text
        '    lookupSampleIdList.Add(i)
        'Next

        ViewState("lookupSampleIdList") = lookupSampleIdList
    End Sub

    Protected Sub ddlidfsFinalDiagnosis_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsFinalDiagnosis.SelectedIndexChanged
        setIsDiagnosisSyndromic()
        SetControls()
        'If Page.IsPostBack Then
        Page.Validate()
        'End If
        'rdbPatientPreviouslySoughtYes.Attributes.Add("disabled", "disabled")
    End Sub

    Protected Sub setIsDiagnosisSyndromic()
        hdfIsDiagnosisSyndromic.Value = 0
        If (Not String.IsNullOrEmpty(ddlidfsFinalDiagnosis.Text) And IsNumeric(ddlidfsFinalDiagnosis.Text)) Then
            For Each item As clsRefIntList In ViewState("lookupDiagHaCodeList")
                If (item.id = Convert.ToInt64(ddlidfsFinalDiagnosis.Text)) Then
                    If (item.numericValue > (HACodeList.HumanHACode + HACodeList.SyndromicHACode)) Then
                        hdfIsDiagnosisSyndromic.Value = 1
                    End If
                End If
            Next
        End If
    End Sub

    Protected Sub chkblnFilterTestNameByDisease_CheckedChanged(sender As Object, e As EventArgs) Handles chkblnFilterTestNameByDisease.CheckedChanged
        If chkblnFilterTestNameByDisease.Checked Then
            BaseReferenceLookUp(ddlSampleTestName, BaseReferenceConstants.TestName, HACodeList.HumanHACode, True)

        Else
            BaseReferenceLookUp(ddlSampleTestName, BaseReferenceConstants.TestName, HACodeList.HumanHACode, True)
        End If
    End Sub

    Private Sub FillDiseaseForEdit(ByVal disID As String)
        Dim dsDis As DataSet
        Dim oCommon As New clsCommon()
        Dim oDis As clsDisease = New clsDisease()
        Dim oService As NG.EIDSSService = oCommon.GetService()
        Dim aSP As String() = oService.getSPList("DiseaseGetDetail")
        dsDis = oDis.SelectOne(disID)
        If dsDis.CheckDataSet() Then
            'Fill hidden fields
            oCommon.Scatter(divHiddenFieldsSection, New DataTableReader(dsDis.Tables(0)))
            'disease- this is the parent level, we can use Scatter here for all child sections
            oCommon.Scatter(disease, New DataTableReader(dsDis.Tables(0)))
            ' lblstrCaseId.Text = hdfstrCaseId.Value
            hdfstrHumanCaseId.Value = hdfstrCaseId.Value
            setIsDiagnosisSyndromic()
        End If
    End Sub

    Private Function AddDisease() As Integer
        'recover idf value
        Dim oCommon As New clsCommon()
        Dim oService As NG.EIDSSService = oCommon.GetService()
        Dim aSpD As String() = oService.getSPList("DiseaseSet")
        Dim disValues As String = ""
        Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
        Dim ds As New DataSet()
        AddSampleListToDs(ds, HdrSampleList)
        AddTestListToDs(ds, HdrTestList)


        'Collect key values from hidden fields
        disValues = oCommon.Gather(divHiddenFieldsSection, aSpD(0), 3, True)
        'Collect diease report values for disease report section
        disValues &= "|" & oCommon.Gather(disease, aSpD(0), 3, True)

        Dim oDisease As New clsDisease()
        Dim result = oDisease.AdUpdateDisease(disValues, ds)

        'show success message
        'lblSuccess.InnerText = GetLocalResourceObject("lbl_Human_Disease_Report_Deleted_Successfully.InnerText") + " ID = " + result.ToString
        'lblSuccess.InnerText = String.Format(GetLocalResourceObject("lbl_Human_Disease_Report_Deleted_Successfully.InnerText") + " ID = {0}.", result.ToString)
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#successVSS').modal('show');});", True)
        'ASPNETMsgBox(String.Format("Save Successful for Human Disease Report ID = {0}.", 10001))
        'ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid"))
        Return result

    End Function

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


    Protected Sub ContactLocationControl_Load()

        Try
            'The location user control has not completed loading with the page load, so some logic is called again
            'to account for its controls.
            'If ViewState(CALLER).ToString().Equals(CallerPages.VeterinaryActiveSurveillanceMonitoringSession) Then
            If True Then
                Dim ddl As System.Web.UI.WebControls.DropDownList = CType(Me.locationContact.FindControl("ddllocationContactidfsRegion"), System.Web.UI.WebControls.DropDownList)
                ddl.Enabled = False
                ddl = CType(Me.locationContact.FindControl("ddllocationContactidfsRayon"), System.Web.UI.WebControls.DropDownList)
                ddl.Enabled = False
                ddl = CType(Me.locationContact.FindControl("ddllocationContactidfsSettlement"), System.Web.UI.WebControls.DropDownList)
                ddl.Enabled = False
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub




    'Private Sub DisplayDiagnosisNotValid()
    '    sidebaritem_notification.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
    '    Dim oValidator As IValidator
    '    For Each oValidator In Validators
    '        If oValidator.IsValid = False Then
    '            If (oValidator.GetType() Is GetType(RequiredFieldValidator)) Then
    '                Dim failedValidator As RequiredFieldValidator = oValidator
    '                Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)
    '                Select Case section.ID
    '                    Case "diseaseNotification"
    '                        sidebaritem_notification.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
    '                        sidebaritem_notification.CssClass = "glyphicon glyphicon-remove"
    '                End Select
    '            End If
    '        End If
    '    Next
    'End Sub

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
        For Each oValidator In Page.Validators
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
        hdnPanelController.Value = 4
    End Sub

    Protected Sub btnAddNewTestClick(sender As Object, e As EventArgs)
        'open modal, add new Test, save, put in grid on underlying page
        hdfModalAddTestGuid.Value = String.Empty
        hdfModalAddTestNewIndicator.Value = "New"
        fillBasicTestsModal()
        'btnModalAddTestSave.Enabled = False   'postfix for tests req fields, comment out this line
        'btnModalAddTestDelete.Enabled = False
        'dlidfsSampleType.SelectedIndex = -1
        ddlSampleTestName.SelectedIndex = -1
        ddlSampleTestCategory.SelectedIndex = -1
        ddlSampleTestResult.SelectedIndex = -1
        ddlSampleTestStatus.SelectedIndex = -1
        'ddlSampleTestDiagnosis.SelectedIndex = 0
        ddlSampleTestDiagnosis.SelectedItem.Selected = True
        ddlSampleTestDiagnosis.SelectedItem.Text = hdfSummaryIdfsFinalDiagnosis.Value
        'ddlAddFieldTestTestedByInstitution.SelectedIndex = -1
        datAddFieldTestResultReceived.Text = String.Empty
        txtAddFieldTestResultDate.Text = String.Empty
        ' ddlAddFieldTestTestedBy.SelectedIndex = -1
        ddlmatLocalSampleId.SelectedIndex = 1
        txtstrBarCode.Text = String.Empty
        txtstrInterpretedComment.Text = String.Empty
        txtstrValidateComment.Text = String.Empty

        Dim myUser As Security.Principal.IIdentity
        myUser = HttpContext.Current.User.Identity
        hdfstrAccountName.Value = myUser.Name

        txtstrInterpretedBy.Text = hdfstrAccountName.Value
        txtstrValidatedBy.Text = hdfstrAccountName.Value

        'openModalTestTab()
        'show modal, call js method: openModalTestTab()
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupTestsModal", "openModalTestTab();", True)
        hdnPanelController.Value = 5
    End Sub

    Protected Sub btn_Return_to_Person_Record_Click(sender As Object, e As EventArgs)

        ViewState(CALLER) = CallerPages.HumanDiseaseReport
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.PersonURL), True)

    End Sub

    Protected Sub btnOpenPageFindFacitlityPersonSentBy_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtstrNotificationSentby"
        openEmployeeAdminForPersonSelection()

    End Sub

    Protected Sub btnOpenPageFindFacitlityPersonReceivedBy_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtstrNotificationReceivedby"
        openEmployeeAdminForPersonSelection()

    End Sub


    Protected Sub btnOpenPageFindCollectedInstitution_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtstrCollectedByInstitution"

        hdfEACallerKey.Value = hdfidfHuman.Value
        hdfEAPageMode.Value = hdfPageMode.Value
        hdfEAInitiatingCallerPage.Value = ViewState(CALLER)
        hdfidfHumanActual.Value = ViewState(CALLER_KEY)
        hdfCallerPage.Value = CallerPages.HumanDiseaseReport

        hdfEAidfHumanActual.Value = hdfidfHumanActual.Value
        hdfEAHumanCase.Value = hdfidfHumanCase.Value
        hdfEAstrHumanCaseId.Value = hdfstrHumanCaseId.Value

        ViewState(CALLER) = CallerPages.HumanDiseaseReport
        ViewState(CALLER_KEY) = CallerPages.HumanDiseaseReport
        Session("hdfidfHumanActual") = hdfidfHumanActual.Value
        Session("idfHumanCase") = hdfidfHumanCase.Value
        'Session("idfHumanCase") = hdfSearchHumanCaseId.Value

        Dim sFileInfo As String = ""
        Dim sFileTable As String = ""
        Dim oComm As clsCommon = New clsCommon()
        'create cache xml file for HDR current values divHiddenFieldsSection
        Dim ctrlList As ICollection(Of Web.UI.Control) = {disease, divHiddenFieldsSection}
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSuffix)
        oComm.SaveSearchFields(ctrlList, "HDRHiddenFieldsSection", sFile)
        'create cache xml file for divHiddenFieldsEAtoHDRInitCache

        Dim ctrlList2 As ICollection(Of Web.UI.Control) = {divHiddenFieldsEAtoHDRInitCache}
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportInitSuffix)
        oComm.SaveSearchFields(ctrlList2, "HDREAtoHDRInitCache", sFile)

        'save to cache: samples grid list
        Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSamples)
        'Dim oSample As New clsHumanDiseaseSample
        oComm.SerializeListToXmlFile(HdrSampleList, sFile)

        'save to cache: tests grid list
        Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportTests)
        'Dim oTest As New clsHumanDiseaseTest
        oComm.SerializeListToXmlFile(HdrTestList, sFile)

        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.OrganizationAdminURL))

    End Sub

    Protected Sub btnOpenPageFindCollectedPerson_Click(sender As Object, e As EventArgs)

        hdfEALastControlFocus.Value = "txtstrCollectedByOfficer"
        openEmployeeAdminForPersonSelection()

    End Sub

    Protected Sub openEmployeeAdminForPersonSelection()

        hdfEACallerKey.Value = hdfidfHuman.Value
        hdfEAPageMode.Value = hdfPageMode.Value
        hdfEAInitiatingCallerPage.Value = ViewState(CALLER)
        hdfidfHumanActual.Value = ViewState(CALLER_KEY)
        hdfCallerPage.Value = CallerPages.HumanDiseaseReport

        hdfEAidfHumanActual.Value = hdfidfHumanActual.Value
        hdfEAHumanCase.Value = hdfidfHumanCase.Value
        hdfEAstrHumanCaseId.Value = hdfstrHumanCaseId.Value

        ViewState(CALLER) = CallerPages.HumanDiseaseReport
        ViewState(CALLER_KEY) = hdfidfHuman.Value
        Session("hdfidfHumanActual") = hdfidfHumanActual.Value
        Session("idfHumanCase") = hdfidfHumanCase.Value
        'Session("idfHumanCase") = hdfSearchHumanCaseId.Value

        Dim sFileInfo As String = ""
        Dim sFileTable As String = ""
        Dim oComm As clsCommon = New clsCommon()
        'create cache xml file for HDR current values divHiddenFieldsSection
        Dim ctrlList As ICollection(Of Web.UI.Control) = {disease, divHiddenFieldsSection}
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSuffix)
        oComm.SaveSearchFields(ctrlList, "HDRHiddenFieldsSection", sFile)
        'create cache xml file for divHiddenFieldsEAtoHDRInitCache

        Dim ctrlList2 As ICollection(Of Web.UI.Control) = {divHiddenFieldsEAtoHDRInitCache}
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportInitSuffix)
        oComm.SaveSearchFields(ctrlList2, "HDREAtoHDRInitCache", sFile)

        'save to cache: samples grid list
        Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportSamples)
        'Dim oSample As New clsHumanDiseaseSample
        oComm.SerializeListToXmlFile(HdrSampleList, sFile)

        'save to cache: tests grid list
        Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
        sFile = oComm.CreateTempFile(CallerPages.HumanDiseaseReportTests)
        'Dim oTest As New clsHumanDiseaseTest
        oComm.SerializeListToXmlFile(HdrTestList, sFile)

        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.EmployeeAdminURL), True)

    End Sub

    Protected Sub btnOpenPageFindPerson_Click(sender As Object, e As EventArgs)

        ' hdfEALastControlFocus.Value = "txtstrNotificationReceivedby"
        openPersonPageForPersonSelection()

    End Sub

    Protected Sub openPersonPageForPersonSelection()

        oCommon.SaveViewState(ViewState) 'TODO:  Test that this is needed here for this redirect.  Stephen Long - 08/14/2018

        Response.Redirect(GetURL(CallerPages.PersonURL), True)

    End Sub


    Protected Sub gvContacts_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvContacts.SelectedIndexChanged
        Dim idx As Integer = gvContacts.SelectedIndex
        hdnPanelController.Value = 8
        'set values on modal
        txtstrContactFirstName.Text = gvContacts.DataKeys(idx).Values(1).ToString()  'strFirstName
        txtstrContactMiddleInit.Text = gvContacts.DataKeys(idx).Values(2).ToString()
        txtstrContactLastName.Text = gvContacts.DataKeys(idx).Values(3).ToString()
        If (IsNumeric(gvContacts.DataKeys(idx).Values(4))) Then
            ddlContactRelation.SelectedValue = gvContacts.DataKeys(idx).Values(4)
        Else
            ddlContactRelation.SelectedValue = 430000000
        End If

        If (IsDate(gvContacts.DataKeys(idx).Values(5)).ToString()) Then
            txtdatContactDoB.Text = gvContacts.DataKeys(idx).Values(5).ToString()
        End If

        If (IsNumeric(gvContacts.DataKeys(idx).Values(6))) Then
            ddlContactGender.SelectedValue = gvContacts.DataKeys(idx).Values(6)
        End If

        If (IsNumeric(gvContacts.DataKeys(idx).Values(7))) Then
            ddlContactCitizenship.SelectedValue = gvContacts.DataKeys(idx).Values(7)
        Else
            'ddlContactCitizenship.SelectedValue = 1  'default to the current country
        End If

        If (IsDate(gvContacts.DataKeys(idx).Values(8).ToString())) Then
            txtdatLastContactDate.Text = gvContacts.DataKeys(idx).Values(8).ToString()
        End If

        txtPlaceofLastContact.Text = gvContacts.DataKeys(idx).Values(9)

        locationContact.SelectedCountryValue = gvContacts.DataKeys(idx).Values(10)
        locationContact.SelectedRegionValue = gvContacts.DataKeys(idx).Values(11)

        'show modal, call js method:  openModalContactEdit()
        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupContactsModal", "openModalContactEdit();", True)
        hdnPanelController.Value = 8
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

        Response.Redirect(GetURL(CallerPages.PersonURL), True)

    End Sub

    Protected Sub btn_Submit_Disease_Report_Click(sender As Object, e As EventArgs)

        Page.Validate()

        If (Page.IsValid) Then
            preSaveOperations()
            hdfidfsYNExposureLocationKnown.Value = hdfidfsYNExposureLocationKnown.Value
            Dim resultAddDisease As Integer = AddDisease()
            If (resultAddDisease > 0) Then
                'we need to add the popup for successful save.
                lblSuccessSave.InnerText = String.Format(GetLocalResourceObject("lbl_Human_Disease_Report_Saved_Successfully.InnerText") + " ID = {0}.", resultAddDisease.ToString)
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & successVSS.ClientID & "').modal('show');});", True)

                hdnPanelController.Value = "0"
            Else
                lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalError", "$(function(){ $('#errorVSS').modal('show');});", True)
            End If
        Else
            DisplayDiseaseValidationErrors()
        End If

    End Sub

    Protected Sub btnSuccessSave_Click(sender As Object, e As EventArgs) Handles btnSuccessSave.ServerClick

        ViewState(CALLER_KEY) = Nothing
        oCommon.SaveViewState(ViewState)

        If (ViewState(CALLER).ToString().EqualsAny({CallerPages.Person})) Then
            Response.Redirect(GetURL(CallerPages.PersonURL), True)
        ElseIf (ViewState(CALLER).ToString().EqualsAny({CallerPages.SearchDiseaseReports})) Then
            Response.Redirect(GetURL(CallerPages.SearchDiseaseReportsURL), True)
        Else
            Response.Redirect(GetURL(CallerPages.DashboardURL), True)
        End If

    End Sub

#End Region

    Private Sub preSaveOperations()
        'if txtstrNotificationSentby is empty string, set this and others to null
        'If (String.IsNullOrEmpty(txtstrNotificationSentby.Text)) Then
        '    hdfidfSentByPerson.Value = vbNull
        '    hdfstrSentByFirstName.Value = vbNull
        '    hdfstrSentByPatronymicName.Value = vbNull
        '    hdfstrSentByLastName.Value = vbNull
        '    hdfidfSentByOffice.Value = vbNull
        'End If
        'If (String.IsNullOrEmpty(txtstrNotificationReceivedby.Text)) Then
        '    hdfidfReceivedByPerson.Value = vbNull
        '    hdfstrReceivedByFirstName.Value = vbNull
        '    hdfstrReceivedByPatronymicName.Value = vbNull
        '    hdfstrReceivedByLastName.Value = vbNull
        '    hdfidfReceivedByOffice.Value = vbNull
        'End If

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
    'Protected Sub rdbPatientPreviouslySought_CheckChanged(sender As Object, e As EventArgs)

    '    'TODO:  if YES then show the "Facility patient first sought care"

    '    Dim s As String = ""

    '    'If rdbPatientPreviouslySoughtYes.Checked Then
    '    '    pnlPatientPreviouslySought.Visible = True
    '    'Else
    '    '    pnlPatientPreviouslySought.Visible = False
    '    'End If
    'End Sub

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
        Else
            txtdatFirstSoughtCareDate.Enabled = False
            txtFacilityFirstSoughtCare.Enabled = False
            ddlidfsNonNotifiableDiagnosis.Enabled = False
        End If
        hdnPanelController.Value = 2
    End Sub




    'Protected Sub rdbHospitalization_CheckChanged(sender As Object, e As EventArgs)
    '    'If rdbHospitalizationYes.Checked Then
    '    '    pnlHospitalization.Visible = True
    '    'Else
    '    '    pnlHospitalization.Visible = False
    '    'End If
    'End Sub

    Protected Sub rblidfsYNHospitalization_CheckChanged(sender As Object, e As EventArgs) Handles rblidfsYNHospitalization.SelectedIndexChanged
        Dim i As Int64 = Convert.ToInt64(sender.SelectedValue)      'get int value of selected item
        If (i = 10100001) Then
            txtdatHospitalizationDate.Enabled = True
            txtdatDischargeDate.Enabled = True
            'txtstrHospitalName.Enabled = True
            pnlHospitalization.Visible = True
        Else
            txtdatHospitalizationDate.Enabled = False
            txtdatDischargeDate.Enabled = False
            'txtstrHospitalName.Enabled = False
            pnlHospitalization.Visible = False
        End If
        hdnPanelController.Value = 2
    End Sub

    Protected Sub rdbAntibioticAntiviralTherapyAdministered_CheckChanged(sender As Object, e As EventArgs)
        If rdbAntibioticAntiviralTherapyAdministeredYes.Checked Then
            pnlAntiBioticAdministred.Visible = True
        Else
            pnlAntiBioticAdministred.Visible = False
        End If
    End Sub


    Protected Sub rdbAntibioticAntiviralTherapyAdministeredYes_CheckChanged(sender As Object, e As EventArgs) Handles rdbAntibioticAntiviralTherapyAdministeredYes.CheckedChanged
        If rdbAntibioticAntiviralTherapyAdministeredYes.Checked Then
            pnlAntiBioticAdministred.Visible = True
        Else
            pnlAntiBioticAdministred.Visible = False
        End If
    End Sub

    Protected Sub rdbAntibioticAntiviralTherapyAdministeredNo_CheckChanged(sender As Object, e As EventArgs) Handles rdbAntibioticAntiviralTherapyAdministeredNo.CheckedChanged
        If rdbAntibioticAntiviralTherapyAdministeredNo.Checked Then
            pnlAntiBioticAdministred.Visible = False
        Else
            '
        End If
    End Sub

    Protected Sub rdbAntibioticAntiviralTherapyAdministeredUnknown_CheckChanged(sender As Object, e As EventArgs) Handles rdbAntibioticAntiviralTherapyAdministeredUnknown.CheckedChanged
        If rdbAntibioticAntiviralTherapyAdministeredUnknown.Checked Then
            pnlAntiBioticAdministred.Visible = False
        Else
            '
        End If
    End Sub

    'Protected Sub rdbRelatedToOutbreak_CheckChanged(sender As Object, e As EventArgs)
    '    If rdbRelatedToOutbreakYes.Checked Then
    '        pnlOutbreakID.Visible = True
    '    Else
    '        pnlOutbreakID.Visible = False
    '    End If

    'End Sub
    'Protected Sub rdbRelatedToOutbreakYes_CheckChanged(sender As Object, e As EventArgs) Handles rdbRelatedToOutbreakYes.CheckedChanged
    '    If rdbRelatedToOutbreakYes.Checked Then
    '        pnlOutbreakID.Visible = True
    '    Else
    '        pnlOutbreakID.Visible = False
    '    End If
    'End Sub

    'Protected Sub rdbRelatedToOutbreakNo_CheckChanged(sender As Object, e As EventArgs) Handles rdbRelatedToOutbreakNo.CheckedChanged
    '    If rdbRelatedToOutbreakNo.Checked Then
    '        pnlOutbreakID.Visible = False
    '    Else
    '        '
    '    End If
    'End Sub
    'Protected Sub RRelatedToOutbreakUnknown_CheckChanged(sender As Object, e As EventArgs) Handles RRelatedToOutbreakUnknown.CheckedChanged
    '    If RRelatedToOutbreakUnknown.Checked Then
    '        pnlOutbreakID.Visible = False
    '    Else
    '        '
    '    End If
    'End Sub

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

    'Protected Sub rdbLocationofExposureKnown_CheckChanged(sender As Object, e As EventArgs)
    '    If rdbLocationofExposureKnownYes.Checked Then
    '        pnlLocationofExposureKnown.Visible = True
    '        hdfidfsYNExposureLocationKnown.Value = "1"
    '    Else
    '        pnlLocationofExposureKnown.Visible = False
    '    End If
    'End Sub

    Protected Sub rdbSpecificVaccination_CheckChanged(sender As Object, e As EventArgs)
        If rdbSpecificVaccinationYes.Checked Then
            pnlSpecialVaccination.Visible = True
        Else
            pnlSpecialVaccination.Visible = False
        End If
    End Sub

    Protected Sub rdbSpecificVaccinationYes_CheckChanged(sender As Object, e As EventArgs) Handles rdbSpecificVaccinationYes.CheckedChanged
        If rdbSpecificVaccinationYes.Checked Then
            pnlSpecialVaccination.Visible = True
        Else
            pnlSpecialVaccination.Visible = False
        End If
    End Sub

    Protected Sub rdbSpecificVaccinationNo_CheckChanged(sender As Object, e As EventArgs) Handles rdbSpecificVaccinationNo.CheckedChanged
        If rdbSpecificVaccinationNo.Checked Then
            pnlSpecialVaccination.Visible = False
        Else
            '
        End If
    End Sub

    Protected Sub rdbSpecificVaccinationUnknown_CheckChanged(sender As Object, e As EventArgs) Handles rdbSpecificVaccinationUnknown.CheckedChanged
        If rdbSpecificVaccinationUnknown.Checked Then
            pnlSpecialVaccination.Visible = False
        Else

            '
        End If
    End Sub

    'rblidfsYNSpecimenCollected_CheckChanged
    Protected Sub rblidfsYNSpecimenCollected_CheckChanged(sender As Object, e As EventArgs) Handles rblidfsYNSpecimenCollected.SelectedIndexChanged
        Dim i As Int64 = Convert.ToInt64(sender.SelectedValue)      'get int value of selected item
        If (i = 10100001) Then
            'samplesGridPanel.Visible = True
            btnSampleNewAdd.Enabled = True
        Else
            'samplesGridPanel.Visible = False
            btnSampleNewAdd.Enabled = False
        End If
        hdnPanelController.Value = 4
    End Sub

    'Protected Sub btnAddNewSampleClick()
    '    'set modal to visible, for add new sample
    'End Sub

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
        If ddlOutcome.SelectedValue = "died" Then
            pnlOutcomeDateofDeath.Visible = True
        Else
            pnlOutcomeDateofDeath.Visible = False
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
        'If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim()) And (Not IsDate(txtdatNotificationDate.Text.Trim()))) Then
        '    isValidOrder = CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime)
        'ElseIf ((Not IsDate(txtdatOnSetDate.Text.Trim())) And IsDate(txtdatDateOfDiagnosis.Text.Trim()) And IsDate(txtdatNotificationDate.Text.Trim())) Then
        '    isValidOrder = CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) <= CType(txtdatNotificationDate.Text.Trim(), DateTime)
        'ElseIf (IsDate(txtdatOnSetDate.Text.Trim()) And (Not IsDate(txtdatDateOfDiagnosis.Text.Trim())) And IsDate(txtdatNotificationDate.Text.Trim())) Then
        '    isValidOrder = CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatNotificationDate.Text.Trim(), DateTime)
        'ElseIf (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim()) And IsDate(txtdatNotificationDate.Text.Trim())) Then
        '    isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime)) And (CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) <= CType(txtdatNotificationDate.Text.Trim(), DateTime))
        'End If

        If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim()) And IsDate(txtdatNotificationDate.Text.Trim())) Then
            isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime)) And (CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) <= CType(txtdatNotificationDate.Text.Trim(), DateTime))
        End If

        args.IsValid = isValidOrder
        'hdnPanelController.Value = 0
    End Sub

    Protected Sub ValidateDateOfNotification(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True  'if none of the three are set to dates, return "isValid = true" condition

        If (IsDate(txtdatNotificationDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim())) Then
            isValidOrder = (CType(txtdatNotificationDate.Text.Trim(), DateTime) >= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) And CType(txtdatNotificationDate.Text.Trim(), DateTime) <= DateTime.Now)
        End If

        args.IsValid = isValidOrder
        'hdnPanelController.Value = 0
    End Sub
    Protected Sub ValidateNotFutureDate(source As Object, args As ServerValidateEventArgs)
        Dim isValidDate As Boolean = True  'if none of the three are set to dates, return "isValid = true" condition
        If IsDate(txtdatDateOfDiagnosis.Text.Trim()) Then
            isValidDate = CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) <= DateTime.Now
        End If

        args.IsValid = isValidDate
        'hdnPanelController.Value = 0
    End Sub

    Protected Sub ValidateNotFutureNotificationDate(source As Object, args As ServerValidateEventArgs)
        Dim isValidDate As Boolean = True

        If IsDate(txtdatNotificationDate.Text.Trim()) Then
            isValidDate = CType(txtdatNotificationDate.Text.Trim(), DateTime) <= DateTime.Now
        End If

        args.IsValid = isValidDate
        'hdnPanelController.Value = 0
    End Sub

    Protected Sub ValidateNotFutureSymptomOnsetDate(source As Object, args As ServerValidateEventArgs)
        Dim isValidDate As Boolean = True

        If IsDate(txtdatOnSetDate.Text.Trim()) Then
            isValidDate = CType(txtdatOnSetDate.Text.Trim(), DateTime) <= DateTime.Now
        End If

        args.IsValid = isValidDate
        'hdnPanelController.Value = 0
    End Sub

    Protected Sub ValidateDoc(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True
        If (Not IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
            isValidOrder = True
        ElseIf ((Not IsDate(txtdatOnSetDate.Text.Trim())) And IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
            isValidOrder = CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= Date.Now
        ElseIf (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatFirstSoughtCareDate.Text.Trim())) Then
            isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) < CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime)) And (CType(txtdatFirstSoughtCareDate.Text.Trim(), DateTime) <= Date.Now)
        End If
        args.IsValid = isValidOrder
        'hdnPanelController.Value = 2
    End Sub
    Protected Sub ValidateDoh(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True
        If (Not IsDate(txtdatHospitalizationDate.Text.Trim())) Then
            isValidOrder = True
        ElseIf ((Not IsDate(txtdatOnSetDate.Text.Trim())) And IsDate(txtdatHospitalizationDate.Text.Trim())) Then
            isValidOrder = CType(txtdatHospitalizationDate.Text.Trim(), DateTime) <= Date.Now
        ElseIf (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatNotificationDate.Text.Trim())) Then
            isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatHospitalizationDate.Text.Trim(), DateTime)) And (CType(txtdatHospitalizationDate.Text.Trim(), DateTime) <= Date.Now)
        End If
        args.IsValid = isValidOrder
        'hdnPanelController.Value = 2
    End Sub

    Protected Sub ValidateDoi(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True
        If (Not IsDate(txtStartDateofInvestigation.Text.Trim())) Then
            isValidOrder = True
        ElseIf ((Not IsDate(txtdatNotificationDate.Text.Trim())) And IsDate(txtStartDateofInvestigation.Text.Trim())) Then
            isValidOrder = CType(txtdatHospitalizationDate.Text.Trim(), DateTime) <= Date.Now
        ElseIf IsDate(txtdatNotificationDate.Text.Trim()) Then
            isValidOrder = (CType(txtdatNotificationDate.Text.Trim(), DateTime) < CType(txtStartDateofInvestigation.Text.Trim(), DateTime)) And (CType(txtStartDateofInvestigation.Text.Trim(), DateTime) <= Date.Now)
        End If
        args.IsValid = isValidOrder
        'hdnPanelController.Value = 2
    End Sub

    Protected Sub ValidateDod(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True
        If (Not IsDate(txtdatDischargeDate.Text.Trim())) Then
            isValidOrder = True
        ElseIf ((Not IsDate(txtdatHospitalizationDate.Text.Trim())) And IsDate(txtdatDischargeDate.Text.Trim())) Then
            isValidOrder = CType(txtdatDischargeDate.Text.Trim(), DateTime) <= Date.Now
        ElseIf (IsDate(txtdatHospitalizationDate.Text.Trim()) And IsDate(txtdatDischargeDate.Text.Trim())) Then
            isValidOrder = (CType(txtdatHospitalizationDate.Text.Trim(), DateTime) <= CType(txtdatDischargeDate.Text.Trim(), DateTime)) And (CType(txtdatDischargeDate.Text.Trim(), DateTime) <= Date.Now)
        End If
        args.IsValid = isValidOrder
        'hdnPanelController.Value = 2
    End Sub

    Protected Sub ValidatorDateOfClassification(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True

        If (IsDate(txtDateofClassification.Text.Trim()) And IsDate(txtAddFieldTestResultDate.Text.Trim())) Then
            isValidOrder = (CType(txtDateofClassification.Text.Trim(), DateTime) >= CType(txtAddFieldTestResultDate.Text.Trim(), DateTime) And CType(txtDateofClassification.Text.Trim(), DateTime) <= Date.Now)

        ElseIf (Not IsDate(txtAddFieldTestResultDate.Text.Trim()) And IsDate(txtDateofClassification.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim())) Then
            isValidOrder = (CType(txtDateofClassification.Text.Trim(), DateTime) > CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) And CType(txtDateofClassification.Text.Trim(), DateTime) <= Date.Now)

        End If

        args.IsValid = isValidOrder

    End Sub
    Protected Sub ValidateDateOfSymptoms(source As Object, args As ServerValidateEventArgs)
        Dim isValidOrder As Boolean = True

        If (IsDate(txtdatOnSetDate.Text.Trim()) And IsDate(txtdatDateOfDiagnosis.Text.Trim())) Then
            isValidOrder = (CType(txtdatOnSetDate.Text.Trim(), DateTime) <= CType(txtdatDateOfDiagnosis.Text.Trim(), DateTime) And CType(txtdatOnSetDate.Text.Trim(), DateTime) <= Date.Now)

        End If

        args.IsValid = isValidOrder

    End Sub

    Protected Sub ValidateSentByReqIfDiagIsSyndromic(source As Object, args As ServerValidateEventArgs)
        'if diagnosis is syndromic, then must have a value set
        If (hdfIsDiagnosisSyndromic.Value = 1) Then
            If (txtstrNotificationSentby.Text.Length > 0) Then
                args.IsValid = True
            Else
                args.IsValid = False
            End If
        Else
            args.IsValid = True
        End If
        'hdnPanelController.Value = 0
    End Sub

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

        'hdnPanelController.Value = 4
    End Sub


    Protected Sub gvTests_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvTests.SelectedIndexChanged
        'Dim idx As Integer = 0
        Dim idx As Integer = gvTests.SelectedIndex
        ViewState("TestGridSelectedIndex") = idx

        'btnModalAddTestSave.Enabled = False  'postfix for tests req fields, set both to true, and bottom of page methods : uncomment out body of methods
        'btnModalAddTestDelete.Enabled = False

        fillBasicTestsModal()

        Dim fieldBarCode As String
        fieldBarCode = gvTests.DataKeys(idx).Values().Item("strFieldBarCode").ToString()
        Dim barCode As String
        barCode = gvTests.DataKeys(idx).Values().Item("strBarcode").ToString()
        Dim interpretedStatus As String
        interpretedStatus = gvTests.DataKeys(idx).Values().Item("idfsInterpretedStatus").ToString()
        Dim diagnosis As String
        diagnosis = gvTests.DataKeys(idx).Values().Item("idfsDiagnosis").ToString()

        '    ddlmatLocalSampleId.Items.FindByValue(If(Not IsNothing(gvTests.DataKeys(idx).Values(14)), gvTests.DataKeys(idx).Values(14).ToString(), Nothing)).SelectItem()
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
            ddlidfsInterpretedStatus.SelectedItem.Text = "Rule In"
        ElseIf interpretedStatus = "10104002" Then
            ddlidfsInterpretedStatus.SelectedItem.Text = "Rule Out"
        End If

        'If Not String.IsNullOrEmpty(gvTests.DataKeys(idx).Values().Item("strInterpretedBy").ToString()) Then
        '    txtstrInterpretedBy.Text = gvTests.DataKeys(idx).Values().Item("strInterpretedBy").ToString()
        'Else
        '    txtstrInterpretedBy.Text = hdfstrAccountName.Value
        'End If

        'If Not String.IsNullOrEmpty(gvTests.DataKeys(idx).Values().Item("strValidatedBy").ToString()) Then
        '    txtstrValidatedBy.Text = gvTests.DataKeys(idx).Values().Item("strValidatedBy").ToString()
        'Else
        '    txtstrValidatedBy.Text = hdfstrAccountName.Value
        'End If

        txtstrInterpretedBy.Text = hdfstrAccountName.Value
        txtstrValidatedBy.Text = hdfstrAccountName.Value

        ddlSampleTestDiagnosis.SelectedItem.Value = diagnosis

        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalSampleTab", "openModalTestTab();", True)

        'hdnPanelController.Value = 4
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

    Protected Sub ddlidfsFinalDiagnosis_SelectedIndexChanged()

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
        r.intRowStatus = 0
        r.sampleGuid = Guid.NewGuid()
        r.idfHumanCase = hdfidfHumanCase.Value

        HdrSampleList.Add(r)
        ViewState(HDR_SAMPLES_GvList) = HdrSampleList
        gvSamples.DataSource = HdrSampleList
        gvSamples.DataBind()
    End Sub





    Private Sub AddNewTestToGrid()
        Dim HdrTestList As List(Of clsHumanDiseaseTest) = TryCast(ViewState(HDR_TESTS_GvList), List(Of clsHumanDiseaseTest))
        Dim r As New clsHumanDiseaseTest

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
        r.idfHumanCase = hdfidfHumanCase.Value

        HdrTestList.Add(r)
        ViewState(HDR_TESTS_GvList) = HdrTestList
        gvTests.DataSource = HdrTestList
        gvTests.DataBind()
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

    'Private Sub ddlmatLocalSampleId_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlmatLocalSampleId.SelectedIndexChanged
    '    'selected Sample- required
    '    Dim HdrSampleList As List(Of clsHumanDiseaseSample) = TryCast(ViewState(HDR_SAMPLES_GvList), List(Of clsHumanDiseaseSample))
    '    If (ddlmatLocalSampleId.SelectedIndex = 0) Then
    '        ddlidfsSampleType.SelectedIndex = 0
    '    Else
    '        For Each r As clsHumanDiseaseSample In HdrSampleList
    '            If (r.sampleGuid.ToString() = ddlmatLocalSampleId.SelectedValue.ToString()) Then
    '                ddlidfsSampleType.SelectedValue = r.idfsSampleType
    '            End If
    '        Next
    '    End If
    '    'this postback causes the bootstrap modal to go away and screen is greyed out. The following will keep the modal open with values.
    '    Dim page As Page = CType(HttpContext.Current.Handler, Page)
    '    ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupModalAddTestContinue", "continueWithModalTestTab();", True)
    'End Sub

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
            'Else
            '    btnModalAddTestSave.Enabled = False
            'btnModalAddTestDelete.Enabled = False
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
        Else
            'btnModalAddTestSave.Enabled = False
            'btnModalAddTestDelete.Enabled = False
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

#End Region

End Class