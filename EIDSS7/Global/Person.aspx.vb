Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain

Public Class Person
    Inherits BaseEidssPage

#Region "Global Values"

    Private Const SectionSearch As String = "Search"
    Private Const SectionPerson As String = "Person"

    Private Const HIDE_WARNING_MODAL As String = "hideWarningModal();"

    Private Const MODAL_KEY As String = "Modal"
    Private Const PAGE_KEY As String = "Page"

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"

    Private Shared Log = log4net.LogManager.GetLogger(GetType(Person))
    Private HumanAPIService As HumanServiceClient
#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
                CheckCallerHandler()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    '**********************************************************************************************
    '* Sub-routine: CheckCallerHandler
    '*
    '* Description: Handler for checking if calls from other web pages were made.
    '* 
    '**********************************************************************************************
    Private Sub CheckCallerHandler()

        ExtractViewStateSession()

        '******************************************************************************************
        '* Add additional modules to the equals any as needed for selecting a person.
        '******************************************************************************************
        Select Case ViewState(CALLER).ToString()
            Case CallerPages.HumanDiseaseReport, CallerPages.Farm
                ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
            Case CallerPages.Dashboard, CallerPages.Person
                ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.View)
            Case Else
                ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.View)
        End Select

        If ViewState(CALLER) = CallerPages.HumanDiseaseReport AndAlso ViewState(CALLER_KEY) IsNot String.Empty Then
            ucAddUpdatePerson.Setup(initialPanelID:=0, action:=UserAction.Update, humanID:=ViewState(CALLER_KEY))
            ToggleVisibility(SectionPerson)
        ElseIf ViewState(CALLER) = CallerPages.Farm AndAlso ViewState(RETURN_KEY) IsNot String.Empty Then
            'Caller Key is set with the Farm ID, to maintain the selected farm on return with the selected farm owner.
            ucAddUpdatePerson.Setup(initialPanelID:=0, action:=UserAction.Update, humanID:=ViewState(RETURN_KEY))
            ToggleVisibility(SectionPerson)
        ElseIf ViewState(CALLER) = CallerPages.SearchDiseaseReports_SelectPerson Then
            'Caller Key is set with the HumanMasterID
            ucSearchPerson.GetPersonRecord(ViewState(CALLER_KEY))
        Else
            ToggleVisibility(SectionSearch)
        End If

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
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
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

        ucSearchPerson.Visible = section.Equals(SectionSearch)
        ucAddUpdatePerson.Visible = section.Equals(SectionPerson)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        warningHeading.InnerText = Resources.WarningMessages.Warning_Message_Alert
        warningSubTitle.InnerText = String.Empty

        Select Case messageType
            Case MessageType.CancelSearchPersonConfirm
                warningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case messageType.CancelConfirmAddUpdate
                warningBody.InnerText = Resources.WarningMessages.Cancel_Add_Update_Confirm
                'Save for the user confirmation to continue saving the person or go back to review and potentially cancel the add.
                hdfWarningMessageType.Value = messageType.CancelConfirmAddUpdate.ToString()
            Case messageType.CannotAddUpdate
                warningBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case messageType.CannotGetValidatorSection
                warningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case messageType.UnhandledException
                warningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case messageType.SearchCriteriaRequired
                warningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case messageType.InvalidDateOfBirth
                warningBody.InnerText = Resources.WarningMessages.Invalid_DOB
            Case messageType.DuplicateHuman
                warningBody.InnerText = message
                'Save for the user confirmation to continue saving the person or go back to review and potentially cancel the add.
                hdfWarningMessageType.Value = messageType.DuplicateHuman.ToString()
            Case MessageType.ConfirmDeletePerson
                warningBody.InnerText = Resources.WarningMessages.Confirm_Person_Delete
                'Save for the user confirmation to continue deleting the person or go back to review and potentially cancel the delete.
                hdfWarningMessageType.Value = messageType.ConfirmDelete.ToString()
        End Select

        If isConfirm Then
            divWarningYesNoContainer.Visible = True
            divWarningOKContainer.Visible = False
        Else
            divWarningOKContainer.Visible = True
            divWarningYesNoContainer.Visible = False
        End If

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divWarningModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowErrorMessage(messageType As MessageType, Optional message As String = Nothing)

        hdgError.InnerText = Resources.WarningMessages.Error_Message_Text
        errorSubTitle.InnerText = String.Empty

        Select Case messageType
            Case messageType.CannotAddUpdate
                divErrorBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case messageType.UnhandledException
                divErrorBody.InnerText = Resources.WarningMessages.Unhandled_Exception
        End Select

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divErrorModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType, Optional message As String = Nothing)

        Select Case messageType
            Case messageType.DeleteSuccess
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Message_Delete_Success")
            Case messageType.AddUpdateSuccess
                lblSuccessMessage.InnerText = message
        End Select

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Sender"></param>
    ''' <param name="e"></param>
    Private Sub Page_Error(Sender As Object, e As EventArgs) Handles Me.Error

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then
            ShowWarningMessage(messageType:=MessageType.UnhandledException, isConfirm:=False)
        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & [GetType].Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            Select Case hdfWarningMessageType.Value.ToString()
                Case MessageType.DuplicateHuman.ToString()
                    upPerson.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, HIDE_WARNING_MODAL, True)
                    ucAddUpdatePerson.ContinueSave()
                Case MessageType.CancelConfirmAddUpdate.ToString()
                    upPerson.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, HIDE_WARNING_MODAL, True)
                    ToggleVisibility(SectionSearch)
                Case MessageType.ConfirmDelete.ToString()
                    upPerson.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, HIDE_WARNING_MODAL, True)
                    ucAddUpdatePerson.DeletePersonRecord()
                    ToggleVisibility(SectionSearch)
                Case Else
                    Response.Redirect(GetURL(CallerPages.DashboardURL), False)
                    Context.ApplicationInstance.CompleteRequest()
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchPerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchPerson.ShowWarningModal

        upPerson.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    Protected Sub SearchPerson_ViewPersonRecord(humanID As Long) Handles ucSearchPerson.ViewPerson

        ToggleVisibility(SectionPerson)

        ucAddUpdatePerson.Setup(initialPanelID:=2, action:=UserAction.Read, humanID:=humanID)

        upPerson.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    ''' <param name="eidssPersonID"></param>
    ''' <param name="fullName"></param>
    ''' <param name="firstName"></param>
    ''' <param name="lastName"></param>
    Protected Sub SearchPerson_SelectPerson(humanID As Long, eidssPersonID As String, fullName As String, firstName As String, lastName As String) Handles ucSearchPerson.SelectPerson

        ViewState(CALLER_KEY) = humanID.ToString()

        Select Case ViewState(CALLER)
            Case CallerPages.HumanActiveSurveillanceSessionDetailedInformationPersonSearch
                ViewState(CALLER) = CallerPages.Person.ToString()
                SaveEIDSSViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), False)
                Context.ApplicationInstance.CompleteRequest()
            Case CallerPages.HumanDiseaseReport
                ViewState(CALLER) = ApplicationActions.PersonAddHumanDiseaseReport.ToString()
                SaveEIDSSViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.HumanDiseaseReportPreviewURL), True)
                Context.ApplicationInstance.CompleteRequest()
        End Select

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub SearchPerson_CreatePerson() Handles ucSearchPerson.CreatePerson

        upPerson.Update()

        ToggleVisibility(SectionPerson)

        ucAddUpdatePerson.Setup(initialPanelID:=0, action:=UserAction.Insert)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    Protected Sub SearchPerson_EditPerson(humanID As Long) Handles ucSearchPerson.EditPerson

        upPerson.Update()

        ToggleVisibility(SectionPerson)

        ucAddUpdatePerson.Setup(initialPanelID:=0, action:=UserAction.Update, humanID:=humanID)

    End Sub

#End Region

#Region "Add/Update Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    ''' <param name="eidssPersonID"></param>
    ''' <param name="fullName"></param>
    ''' <param name="firstName"></param>
    ''' <param name="lastName"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdatePerson_CreatePerson(humanID As Long, eidssPersonID As String, fullName As String, firstName As String, lastName As String, message As String) Handles ucAddUpdatePerson.CreatePerson

        upPerson.Update()

        hdfPersonHumanMasterID.Value = humanID

        ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=message & eidssPersonID & ".")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    ''' <param name="fullName"></param>
    ''' <param name="eidssPersonID"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdatePerson_UpdatePerson(humanID As Long, fullName As String, eidssPersonID As String, message As String) Handles ucAddUpdatePerson.UpdatePerson

        upPerson.Update()

        hdfPersonHumanMasterID.Value = fullName

        ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddPersonPerson_Validate() Handles ucAddUpdatePerson.ValidatePage

        Validate("PersonInformation")
        Validate("PersonAddress")
        Validate("PersonEmploymentSchoolInformation")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdatePerson_ShowErrorModal(messageType As MessageType, message As String) Handles ucAddUpdatePerson.ShowErrorModal

        upPerson.Update()
        ShowErrorMessage(messageType:=messageType, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdatePerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String) Handles ucAddUpdatePerson.ShowWarningModal

        upPerson.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnAddDiseaseReport.Click

        Try
            ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('hide');});", True)

            ViewState(CALLER) = ApplicationActions.PersonAddHumanDiseaseReport.ToString()
            ViewState(CALLER_KEY) = hdfPersonHumanMasterID.Value
            SaveEIDSSViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), False)
            Context.ApplicationInstance.CompleteRequest()
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
    Protected Sub ReturnToPersonRecord_Click(sender As Object, e As EventArgs) Handles btnReturnToPersonRecord.Click

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('hide');});", True)

        ucAddUpdatePerson.Setup(initialPanelID:=0, action:=UserAction.Update, humanID:=ViewState(CALLER_KEY))

    End Sub

#End Region

End Class