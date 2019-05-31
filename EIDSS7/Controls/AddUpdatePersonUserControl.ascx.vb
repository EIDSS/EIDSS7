Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class AddUpdatePersonUserControl
    Inherits UserControl

#Region "Global Values"

    Private Const SectionRead As String = "Read"
    Private Const PAGE_KEY As String = "Page"
    Private Const MODAL_KEY As String = "Modal"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const SHOW_BASE_REFERENCE_EDITOR_MODAL As String = "showBaseReferenceEditorModal();"
    Private Const HIDE_BASE_REFERENCE_EDITOR_MODAL As String = "hideBaseReferenceEditorModal();"
    Private Const PIN As String = "PIN"

    Public Event ValidatePage()
    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String)
    Public Event ShowErrorModal(messageType As MessageType, message As String)
    Public Event CreatePerson(humanID As Long, eidssPersonID As String, fullName As String, firstName As String, lastName As String, message As String)
    Public Event UpdatePerson(humanID As Long, fullName As String, eidssPersonID As String, message As String)
    Public Event EditPerson(humanID As Long, fullName As String)

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private HumanAPIService As HumanServiceClient
    Private FarmAPIService As FarmServiceClient
    Private OutbreakAPIService As OutbreakServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(AddUpdatePersonUserControl))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                rdbAnotherAddressYes.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbAnotherAddressYes.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbAnotherAddressNo.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbAnotherAddressNo.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbAnotherPhoneNo.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbAnotherPhoneNo.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbAnotherPhoneYes.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbAnotherPhoneYes.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbCurrentlyEmployedNo.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbCurrentlyEmployedNo.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbCurrentlyEmployedUnknown.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbCurrentlyEmployedUnknown.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbCurrentlyEmployedYes.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbCurrentlyEmployedYes.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbCurrentlyInSchoolNo.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbCurrentlyInSchoolNo.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbCurrentlyInSchoolUnknown.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbCurrentlyInSchoolUnknown.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                rdbCurrentlyInSchoolYes.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + rdbCurrentlyInSchoolYes.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                chkEmployerForeignAddressIndicator.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + chkEmployerForeignAddressIndicator.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                chkHumanAltForeignAddressIndicator.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + chkHumanAltForeignAddressIndicator.ClientID.Replace("_", "$") + "\',\'\')', 0)")
                chkSchoolForeignAddressIndicator.Attributes.Add("onclick", "javascript:setTimeout('__doPostBack(\'" + chkSchoolForeignAddressIndicator.ClientID.Replace("_", "$") + "\',\'\')', 0)")
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="initialPanelID"></param>
    ''' <param name="action"></param>
    ''' <param name="humanID"></param>
    ''' <param name="copyToHumanIndicator">Used by the laboratory module to indicate that the human record will need to be created on 
    ''' saving the master (actual) record.  This is done as the samples table has a foreign key relationship to the human table.</param>
    Public Sub Setup(initialPanelID As Integer, Optional action As String = UserAction.Insert, Optional humanID As Long = Nothing, Optional copyToHumanIndicator As Boolean = False)

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Reset()

            FillDropDowns()

            Select Case action
                Case UserAction.Insert
                    Human.Setup(CrossCuttingAPIService)
                    HumanAlt.Setup(CrossCuttingAPIService)
                    Employer.Setup(CrossCuttingAPIService)
                    School.Setup(CrossCuttingAPIService)

                    hdfSearchPatientID.Value = "0"
                    divPersonID.Visible = False
                    btnAddSelectablePreviewHumanDiseaseReport.Visible = False
                    btnAddSelectablePreviewOutbreakCaseReport.Visible = False
                    divSelectablePreviewFarmList.Visible = False
                    divSelectablePreviewHumanDiseaseReportList.Visible = False
                    divSelectablePreviewOutbreakCaseList.Visible = False
                    hdfHumanMasterID.Value = String.Empty
                    hdfHumanidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
                    hdfHumanAltidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
                    hdfEmployeridfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
                    hdfSchoolidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
                    hdfPersonPanelController.Value = 0
                    hdfCopyToHumanIndicator.Value = copyToHumanIndicator
                    ddlCitizenshipTypeID.SelectedValue = ConfigurationManager.AppSettings("DefaultCitizenshipTypeID")
                Case UserAction.Read
                    hdfHumanMasterID.Value = humanID
                    hdfSearchPatientID.Value = humanID
                    divPersonID.Visible = True
                    divSelectablePreviewFarmList.Visible = True
                    divSelectablePreviewHumanDiseaseReportList.Visible = True
                    divSelectablePreviewOutbreakCaseList.Visible = True
                    FillPerson(edit:=True)
                    hdfPersonPanelController.Value = 3
                    ScriptManager.RegisterClientScriptBlock(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'))", True)
                    PersonSideBar.Visible = False
                Case UserAction.Update
                    hdfPersonPanelController.Value = 0
                    hdfHumanMasterID.Value = humanID
                    hdfSearchPatientID.Value = humanID
                    divSelectablePreviewFarmList.Visible = True
                    divSelectablePreviewHumanDiseaseReportList.Visible = True
                    divSelectablePreviewOutbreakCaseList.Visible = True
                    FillPerson(edit:=True)
            End Select

            If ddlPersonalIDType.SelectedItem.Text = PIN Then
                btnFindInPINSystem.Enabled = True
                btnFindInPINSystem.Visible = True
            Else
                btnFindInPINSystem.Enabled = False
                btnFindInPINSystem.Visible = False
            End If

            upAddUpdatePerson.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        hdfCurrentDate.Value = Date.Today.ToString("d")
        hdfCopyToHumanIndicator.Value = "False"

        ExtractViewStateSession()

        ResetForm(divPersonForm)
        ResetForm(Human)
        ResetForm(HumanAlt)
        ResetForm(Employer)
        ResetForm(School)

        rdbAnotherAddressNo.Checked = False
        rdbAnotherAddressYes.Checked = False

        pnlEmploymentInformation.Visible = False
        pnlSchoolInformation.Visible = False
        divEmployerForeignAddress.Visible = False
        divSchoolForeignAddress.Visible = False
        divHumanAltForeignAddress.Visible = False
        pnlAnotherAddress.Visible = False
        pnlAnotherPhone.Visible = False

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = GetViewState(True)

            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        PrepViewStates()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub PrepViewStates()

        'Used to correct any "nothing" values for known Viewstate variables
        'Add your new View State variables here
        Dim lKeys As List(Of String) = New List(Of String) From {CALLER, CALLER_KEY}

        For Each sKey As String In lKeys
            If (ViewState(sKey) Is Nothing) Then
                ViewState(sKey) = String.Empty
            End If
        Next

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="section"></param>
    Private Sub ToggleVisibility(ByVal section As String)

    End Sub

#End Region

#Region "Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            FillBaseReferenceDropDownList(ddlPersonalIDType, BaseReferenceConstants.PersonalIDType, HACodeList.NoneHACode, True)
            FillBaseReferenceDropDownList(ddlGenderTypeID, BaseReferenceConstants.HumanGender, HACodeList.HumanHACode, True)
            FillBaseReferenceDropDownList(ddlReportedAgeUOMID, BaseReferenceConstants.HumanAgeType, HACodeList.HumanHACode, True)
            FillBaseReferenceDropDownList(ddlOccupationTypeID, BaseReferenceConstants.OccupationType, HACodeList.HumanHACode, True)
            FillBaseReferenceDropDownList(ddlCitizenshipTypeID, BaseReferenceConstants.NationalityList, HACodeList.NoneHACode, True)
            FillBaseReferenceDropDownList(ddlContactPhoneTypeID, BaseReferenceConstants.ContactPhoneType, HACodeList.HumanHACode, True)
            FillBaseReferenceDropDownList(ddlContactPhone2TypeID, BaseReferenceConstants.ContactPhoneType, HACodeList.HumanHACode, True)

            Dim countries As List(Of CountryGetLookupModel) = CrossCuttingAPIService.GetCountryListAsync(GetCurrentLanguage()).Result
            countries.OrderBy(Function(x) x.strCountryName)
            FillDropDownList(ddlEmployeridfsCountry, countries, {GlobalConstants.NullValue}, CountryConstants.CountryID, CountryConstants.CountryName, Nothing, Nothing, True)
            FillDropDownList(ddlSchoolidfsCountry, countries, {GlobalConstants.NullValue}, CountryConstants.CountryID, CountryConstants.CountryName, Nothing, Nothing, True)
            FillDropDownList(ddlHumanAltidfsCountry, countries, {GlobalConstants.NullValue}, CountryConstants.CountryID, CountryConstants.CountryName, Nothing, Nothing, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Submit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click

        Try
            RaiseEvent ValidatePage()

            If (Page.IsValid) Then
                If hdfEmployerForeignAddressIndicator.Value.IsValueNullOrEmpty = False Then
                    If hdfEmployerForeignAddressIndicator.Value = True Then
                        hdfEmployeridfsCountry.Value = ddlEmployeridfsCountry.SelectedValue
                    End If
                End If

                If hdfSchoolForeignAddressIndicator.Value.IsValueNullOrEmpty = False Then
                    If hdfSchoolForeignAddressIndicator.Value = True Then
                        hdfSchoolidfsCountry.Value = ddlSchoolidfsCountry.SelectedValue
                    End If
                End If

                If hdfHumanAltForeignAddressIndicator.Value.IsValueNullOrEmpty = False Then
                    If hdfHumanAltForeignAddressIndicator.Value = True Then
                        hdfHumanAltidfsCountry.Value = ddlHumanAltidfsCountry.SelectedValue
                    End If
                End If

                ScriptManager.RegisterClientScriptBlock(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'))", True)

                If HumanAPIService Is Nothing Then
                    HumanAPIService = New HumanServiceClient()
                End If

                If hdfHumanMasterID.Value.IsValueNullOrEmpty() Then
                    'Perform duplicate check.
                    If txtDateOfBirth.Text.IsValueNullOrEmpty = False Then
                        Dim duplicateParams As New HumanGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ExactDateOfBirth = txtDateOfBirth.Text,
                            .FirstOrGivenName = txtFirstOrGivenName.Text, .SecondName = (IIf(txtSecondName.Text.IsValueNullOrEmpty = True, Nothing, txtSecondName.Text)), .LastOrSurname = txtLastOrSurname.Text}

                        Dim list = HumanAPIService.GetHumanMasterListAsync(parameters:=duplicateParams).Result

                        If list.Count > 0 Then
                            Dim duplicateRecordsFound As String = Resources.WarningMessages.Duplicate_Record_Found

                            For Each human As HumHumanMasterGetListModel In list
                                duplicateRecordsFound += human.EIDSSPersonID & ", "
                            Next

                            'Remove last comma and space.
                            duplicateRecordsFound = duplicateRecordsFound.Remove(duplicateRecordsFound.Length - 2, 2)
                            duplicateRecordsFound &= ". " & Resources.Labels.Lbl_Continue_Save_Question_Text

                            RaiseEvent ShowWarningModal(messageType:=MessageType.DuplicateHuman, isConfirm:=True, message:=duplicateRecordsFound)
                        Else
                            ContinueSave()
                        End If
                    Else
                        ContinueSave()
                    End If
                Else
                    ContinueSave()
                End If
            Else
                DisplayPersonValidationErrors()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub ContinueSave()

        Try
            Dim parameters = New HumanSetParam()
            parameters = Gather(Me, parameters, 3)
            'parameters = Gather(divHiddenFieldsSection, parameters, 3)
            parameters = Gather(Human, parameters, 3, True)
            parameters = Gather(HumanAlt, parameters, 3, True)
            parameters = Gather(Employer, parameters, 3, True)
            parameters = Gather(School, parameters, 3, True)

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If
            Dim result As List(Of HumHumanMasterSetModel) = HumanAPIService.SaveHumanMasterAsync(parameters).Result

            If result.Count > 0 Then
                If result.FirstOrDefault().ReturnCode = 0 Then 'Success
                    Dim fullName As String = String.Empty
                    If txtFirstOrGivenName.Text = String.Empty Then
                        fullName = txtLastOrSurname.Text
                    Else
                        fullName = txtFirstOrGivenName.Text & " " & txtLastOrSurname.Text
                    End If

                    If hdfHumanMasterID.Value.IsValueNullOrEmpty() Then
                        RaiseEvent CreatePerson(result.FirstOrDefault().HumanMasterID, result.FirstOrDefault().EIDSSPersonID.ToString(), fullName, txtFirstOrGivenName.Text, txtLastOrSurname.Text, GetLocalResourceObject("Lbl_Create_Success"))
                    Else
                        RaiseEvent UpdatePerson(result.FirstOrDefault().HumanMasterID, fullName, txtEIDSSPersonID.Text, GetLocalResourceObject("Lbl_Update_Success"))
                    End If

                    hdfHumanMasterID.Value = result.FirstOrDefault().HumanMasterID.ToString()

                    hdfPersonPanelController.Value = 3
                    hdfSearchPatientID.Value = result.FirstOrDefault().HumanMasterID.ToString()
                    divSelectablePreviewFarmList.Visible = True
                    divSelectablePreviewHumanDiseaseReportList.Visible = True
                    divSelectablePreviewOutbreakCaseList.Visible = True

                    FillPerson(edit:=True)

                    ScriptManager.RegisterClientScriptBlock(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'))", True)
                Else 'Error
                    hdfPersonPanelController.Value = 3
                    upAddUpdatePerson.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'))", True)
                    RaiseEvent ShowErrorModal(messageType:=MessageType.CannotAddUpdate, message:=String.Empty)
                End If
            Else
                hdfPersonPanelController.Value = 3
                upAddUpdatePerson.Update()
                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_hdfPersonPanelController'), document.getElementById('PersonSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_divPersonForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdatePerson_btnSubmit'))", True)
                RaiseEvent ShowErrorModal(messageType:=MessageType.CannotAddUpdate, message:=String.Empty)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DisplayPersonValidationErrors()

        'Paint all SideBarItems as Passed Validation and then correct those that failed
        sbiPersonInformation.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sbiPersonAddress.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sbiPersonEmploymentSchoolInformation.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Page.Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim ctrl As Control = failedValidator
                Dim section As HtmlGenericControl = Nothing

                While (section Is Nothing)
                    ctrl = ctrl.Parent
                    section = TryCast(ctrl, HtmlGenericControl)
                    Try
                        Select Case section.ID
                            Case "PersonInformation"
                                sbiPersonInformation.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                                sbiPersonInformation.CssClass = "glyphicon glyphicon-remove"
                            Case "PersonAddress"
                                sbiPersonAddress.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                                sbiPersonAddress.CssClass = "glyphicon glyphicon-remove"
                            Case "PersonEmploymentSchoolInformation"
                                sbiPersonEmploymentSchoolInformation.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                                sbiPersonEmploymentSchoolInformation.CssClass = "glyphicon glyphicon-remove"
                            Case Else
                                section = Nothing
                        End Select
                    Catch e As Exception
                    End Try
                End While
            End If
        Next

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub DeletePersonRecord()

        Try
            Dim list = New List(Of HumHumanSetModel)()

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            list = HumanAPIService.DeleteHumanMasterAsync(GetCurrentLanguage(), hdfHumanMasterID.Value).Result
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function FillHumanDiseaseReportList() As List(Of HumDiseaseReportGetListModel)

        Dim humanDiseaseReports = New List(Of HumDiseaseReportGetListModel)
        Try
            Dim parameters = New HumanDiseaseReportGetListParams With {.LanguageID = GetCurrentLanguage(), .PatientID = hdfHumanMasterID.Value, .PaginationSetNumber = 1}
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If
            humanDiseaseReports = HumanAPIService.GetHumanDiseaseReportListAsync(parameters).Result
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return humanDiseaseReports

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanDiseaseReports"></param>
    Private Sub BindHumanDiseaseReportsGridView(humanDiseaseReports As List(Of HumDiseaseReportGetListModel))

        gvHumanDiseaseReports.DataSource = humanDiseaseReports
        gvHumanDiseaseReports.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub HumanDiseaseReports_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHumanDiseaseReports.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ViewCommand
                        ViewState(CALLER_KEY) = e.CommandArgument
                        ViewState(CALLER) = ApplicationActions.PersonPreviewHumanDiseaseReport.ToString()
                        SaveEIDSSViewState(ViewState)

                        Response.Redirect(GetURL(CallerPages.HumanDiseaseReportPreviewURL), True)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function FillOutbreakList() As List(Of OmmCaseGetListModel)

        Dim outbreakCases = New List(Of OmmCaseGetListModel)
        Try
            Dim parameters = New OmmCaseGetListParams With {.langId = GetCurrentLanguage(), .QuickSearch = Nothing, .HumanMasterID = hdfHumanMasterID.Value}
            If OutbreakAPIService Is Nothing Then
                OutbreakAPIService = New OutbreakServiceClient()
            End If
            outbreakCases = OutbreakAPIService.OmmCaseGetListAsync(parameters, False).Result
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return outbreakCases

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="outbreakCases"></param>
    Private Sub BindOutbreakCasesGridView(outbreakCases As List(Of OmmCaseGetListModel))

        gvOutbreakCases.DataSource = outbreakCases
        If outbreakCases.Count > 0 Then
            gvOutbreakCases.DataBind()
        Else
            divSelectablePreviewOutbreakCaseList.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub OutbreakCases_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOutbreakCases.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ViewCommand
                        ViewState(CALLER_KEY) = e.CommandArgument
                        ViewState(CALLER) = ApplicationActions.PersonPreviewOutbreakCaseReport.ToString()
                        SaveEIDSSViewState(ViewState)

                        Response.Redirect(GetURL(CallerPages.OutbreakCaseReportURL), False)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function FillFarmList() As List(Of VetFarmMasterGetListModel)

        Dim farms = New List(Of VetFarmMasterGetListModel)

        Try
            Dim parameters = New FarmGetListParameters With {.LanguageID = GetCurrentLanguage(), .FarmOwnerID = hdfHumanMasterID.Value}
            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If
            farms = FarmAPIService.FarmMasterGetListAsync(parameters).Result
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return farms

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farms"></param>
    Private Sub BindFarmsGridView(farms As List(Of VetFarmMasterGetListModel))

        gvFarms.DataSource = farms
        If farms.Count > 0 Then
            gvFarms.DataBind()
        Else
            divSelectablePreviewFarmList.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Farms_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFarms.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ViewCommand
                        ViewState(CALLER_KEY) = e.CommandArgument
                        ViewState(CALLER) = ApplicationActions.PersonPreviewFarm.ToString()
                        SaveEIDSSViewState(ViewState)

                        Response.Redirect(GetURL(CallerPages.FarmURL), False)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="edit"></param>
    Private Sub FillPerson(edit As Boolean)

        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If
            Dim list As List(Of HumHumanMasterGetDetailModel) = HumanAPIService.GetHumanMasterDetailAsync(GetCurrentLanguage(), hdfHumanMasterID.Value).Result

            BindHumanDiseaseReportsGridView(FillHumanDiseaseReportList())
            BindFarmsGridView(FillFarmList())
            BindOutbreakCasesGridView(FillOutbreakList())

            Scatter(Me, list.FirstOrDefault())

            divPersonID.Visible = True
            btnAddSelectablePreviewHumanDiseaseReport.Visible = True
            btnAddSelectablePreviewOutbreakCaseReport.Visible = True

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
                        If hdfEmployerForeignAddressIndicator.Value = True Then
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
                        If hdfSchoolForeignAddressIndicator.Value = True Then
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

                If hdfHumanAltForeignAddressIndicator.Value = True Then
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
            Human.Setup(CrossCuttingAPIService)

            HumanAlt.LocationCountryID = list.FirstOrDefault().HumanAltidfsCountry
            HumanAlt.LocationRegionID = list.FirstOrDefault().HumanAltidfsRegion
            HumanAlt.LocationRayonID = list.FirstOrDefault().HumanAltidfsRayon
            HumanAlt.LocationSettlementID = list.FirstOrDefault().HumanAltidfsSettlement
            HumanAlt.LocationPostalCodeName = list.FirstOrDefault().HumanAltstrPostalCode
            HumanAlt.Setup(CrossCuttingAPIService)

            Employer.LocationCountryID = list.FirstOrDefault().EmployeridfsCountry
            Employer.LocationRegionID = list.FirstOrDefault().EmployeridfsRegion
            Employer.LocationRayonID = list.FirstOrDefault().EmployeridfsRayon
            Employer.LocationSettlementID = list.FirstOrDefault().EmployeridfsSettlement
            Employer.LocationPostalCodeName = list.FirstOrDefault().EmployerstrPostalCode
            Employer.Setup(CrossCuttingAPIService)

            School.LocationCountryID = list.FirstOrDefault().SchoolidfsCountry
            School.LocationRegionID = list.FirstOrDefault().SchoolidfsRegion
            School.LocationRayonID = list.FirstOrDefault().SchoolidfsRayon
            School.LocationSettlementID = list.FirstOrDefault().SchoolidfsSettlement
            School.LocationPostalCodeName = list.FirstOrDefault().SchoolstrPostalCode
            School.Setup(CrossCuttingAPIService)

            EnableForm(divPersonForm, edit)
            txtEIDSSPersonID.Enabled = False
            If txtDateOfBirth.Text.IsValueNullOrEmpty() Then
                txtReportedAge.Enabled = True
                ddlReportedAgeUOMID.Enabled = True
            Else
                txtReportedAge.Enabled = False
                ddlReportedAgeUOMID.Enabled = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub DateOfBirth_TextChanged(sender As Object, e As EventArgs) Handles txtDateOfBirth.TextChanged

        Try
            CalculateAge()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub CalculateAge()

        Try
            If Not String.IsNullOrEmpty(txtDateOfBirth.Text) Then
                Dim age As Long = DateDiff(DateInterval.Day, Convert.ToDateTime(txtDateOfBirth.Text), Date.Today, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1)

                If age <= 30 Then
                    ddlReportedAgeUOMID.SelectedValue = HumanAgeTypeConstants.Days
                ElseIf age > 30 And age <= 364 Then
                    age = DateDiff(DateInterval.Month, Convert.ToDateTime(txtDateOfBirth.Text), Date.Today, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1)
                    ddlReportedAgeUOMID.SelectedValue = HumanAgeTypeConstants.Months
                ElseIf age >= 365 Then
                    age = DateDiff(DateInterval.Year, Convert.ToDateTime(txtDateOfBirth.Text), Date.Today, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, FirstWeekOfYear.Jan1)
                    ddlReportedAgeUOMID.SelectedValue = HumanAgeTypeConstants.Years
                End If

                txtReportedAge.Text = age.ToString()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub EmployerForeignAddress_CheckedChanged(sender As Object, e As EventArgs) Handles chkEmployerForeignAddressIndicator.CheckedChanged

        Try
            If chkEmployerForeignAddressIndicator.Checked = True Then
                divEmployerForeignAddress.Visible = True
                ResetForm(Employer)
                Employer.Visible = False
                hdfEmployerForeignAddressIndicator.Value = True
            Else
                divEmployerForeignAddress.Visible = False
                ResetForm(divEmployerForeignAddress)
                Employer.Visible = True
                hdfEmployerForeignAddressIndicator.Value = False
            End If

            hdfEmployeridfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SchoolForeignAddress_CheckedChanged(sender As Object, e As EventArgs) Handles chkSchoolForeignAddressIndicator.CheckedChanged

        Try
            If chkSchoolForeignAddressIndicator.Checked = True Then
                divSchoolForeignAddress.Visible = True
                ResetForm(School)
                School.Visible = False
                hdfSchoolForeignAddressIndicator.Value = True
            Else
                divSchoolForeignAddress.Visible = False
                ResetForm(divSchoolForeignAddress)
                School.Visible = True
                hdfSchoolForeignAddressIndicator.Value = False
            End If

            hdfSchoolidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub HumanAltForeignAddress_CheckedChanged(sender As Object, e As EventArgs) Handles chkHumanAltForeignAddressIndicator.CheckedChanged

        Try
            If chkHumanAltForeignAddressIndicator.Checked = True Then
                divHumanAltForeignAddress.Visible = True
                ResetForm(HumanAlt)
                HumanAlt.Visible = False
                hdfHumanAltForeignAddressIndicator.Value = True
            Else
                divHumanAltForeignAddress.Visible = False
                ResetForm(divHumanAltForeignAddress)
                HumanAlt.Visible = True
                hdfHumanAltForeignAddressIndicator.Value = False
            End If

            hdfHumanAltidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CurrentlyEmployed_CheckedChanged(sender As Object, e As EventArgs) Handles rdbCurrentlyEmployedNo.CheckedChanged, rdbCurrentlyEmployedUnknown.CheckedChanged, rdbCurrentlyEmployedYes.CheckedChanged

        Try
            If rdbCurrentlyEmployedYes.Checked Then
                pnlEmploymentInformation.Visible = True
                hdfIsEmployedTypeID.Value = YesNoUnknown.Yes
            Else
                If rdbCurrentlyEmployedNo.Checked Then
                    hdfIsEmployedTypeID.Value = YesNoUnknown.No
                Else
                    If rdbCurrentlyEmployedUnknown.Checked Then
                        hdfIsEmployedTypeID.Value = YesNoUnknown.Unknown
                    Else
                        hdfIsEmployedTypeID.Value = GlobalConstants.NullValue
                    End If
                End If
                ResetForm(pnlEmploymentInformation)
                pnlEmploymentInformation.Visible = False
            End If

            hdfEmployeridfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CurrentlyInSchool_CheckedChanged(sender As Object, e As EventArgs) Handles rdbCurrentlyInSchoolNo.CheckedChanged, rdbCurrentlyInSchoolUnknown.CheckedChanged, rdbCurrentlyInSchoolYes.CheckedChanged

        Try
            If rdbCurrentlyInSchoolYes.Checked Then
                pnlSchoolInformation.Visible = True
                hdfIsStudentTypeID.Value = YesNoUnknown.Yes
            Else
                If rdbCurrentlyInSchoolNo.Checked Then
                    hdfIsStudentTypeID.Value = YesNoUnknown.No
                Else
                    If rdbCurrentlyInSchoolUnknown.Checked Then
                        hdfIsStudentTypeID.Value = YesNoUnknown.Unknown
                    Else
                        hdfIsStudentTypeID.Value = GlobalConstants.NullValue
                    End If
                End If
                ResetForm(pnlSchoolInformation)
                pnlSchoolInformation.Visible = False
            End If

            hdfSchoolidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AnotherAddress_CheckedChanged(sender As Object, e As EventArgs) Handles rdbAnotherAddressNo.CheckedChanged, rdbAnotherAddressYes.CheckedChanged

        Try
            If rdbAnotherAddressYes.Checked Then
                pnlAnotherAddress.Visible = True
            Else
                ResetForm(pnlAnotherAddress)
                pnlAnotherAddress.Visible = False
            End If

            hdfHumanAltidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AnotherPhone_CheckedChanged(sender As Object, e As EventArgs) Handles rdbAnotherPhoneNo.CheckedChanged, rdbAnotherPhoneYes.CheckedChanged

        Try
            If rdbAnotherPhoneYes.Checked Then
                pnlAnotherPhone.Visible = True
            Else
                ResetForm(pnlAnotherPhone)
                pnlAnotherPhone.Visible = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddSelectablePreviewHumanDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnAddSelectablePreviewHumanDiseaseReport.Click

        Try
            ViewState(CALLER_KEY) = hdfHumanMasterID.Value
            ViewState(CALLER) = ApplicationActions.PersonAddHumanDiseaseReport.ToString()
            SaveEIDSSViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), False)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddSelectablePreviewOutbreakCaseReport_Click(sender As Object, e As EventArgs) Handles btnAddSelectablePreviewOutbreakCaseReport.Click

        Try
            ViewState(CALLER_KEY) = hdfHumanMasterID.Value
            ViewState(CALLER) = ApplicationActions.PersonAddOutbreakCaseReport.ToString()
            SaveEIDSSViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.OutbreakCaseReportURL), False)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        Try
            RaiseEvent ShowWarningModal(MessageType.CancelConfirmAddUpdate, True, Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddOccupation_Click(sender As Object, e As EventArgs) Handles btnAddOccupation.Click

        Try
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_BASE_REFERENCE_EDITOR_MODAL, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub BaseReferenceCancel_Click(sender As Object, e As EventArgs) Handles btnBaseReferenceCancel.Click

        Try
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, HIDE_BASE_REFERENCE_EDITOR_MODAL, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PersonalIDType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlPersonalIDType.SelectedIndexChanged

        Try
            If ddlPersonalIDType.SelectedItem.Text = PIN Then
                btnFindInPINSystem.Enabled = True
                btnFindInPINSystem.Visible = True
            Else
                btnFindInPINSystem.Enabled = False
                btnFindInPINSystem.Visible = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillCountry(selectedValue As String, selectedText As String)

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of CountryGetLookupModel) = CrossCuttingAPIService.GetCountryListAsync(GetCurrentLanguage()).Result.OrderBy(Function(x) x.strCountryName).ToList()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class