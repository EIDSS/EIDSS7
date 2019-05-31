Imports System.Reflection
Imports EIDSS.EIDSS

''' <summary>
''' 
''' </summary>
Public Class Farm
    Inherits BaseEidssPage

#Region "Global Values"

    Private Const SectionSearch As String = "Search"
    Private Const SectionPerson As String = "Person"
    Private Const SectionFarm As String = "Farm"

    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"
    Private Const PAGE_KEY As String = "Page"
    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SHOW_MODAL_SCRIPT As String = "hideModalShowModal('{0}', '{1}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"
    Private Const HIDE_MODAL_AND_WARNING_MODAL_SCRIPT As String = "hideModalAndWarningModal('{0}');"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideFarmSearchCriteria();"

    Private Const FARM_INVENTORY_SESSION As String = "FarmInventory"

    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private Shared Log = log4net.LogManager.GetLogger(GetType(Farm))

#End Region

#Region "Initialize Methods"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            Session(FARM_INVENTORY_SESSION) = False
            CheckCallerHandler()
        End If

    End Sub

    '**********************************************************************************************
    '* Sub-routine: CheckCallerHandler
    '*
    '* Description: Handler for checking if calls from other web pages were made.
    '* 
    '**********************************************************************************************
    Private Sub CheckCallerHandler()

        ExtractViewStateSession()

        Select Case ViewState(CALLER).ToString()
            Case CallerPages.Dashboard
                ucSearchFarm.Setup(enableFarmType:=True, selectMode:=SelectModes.View)
                ToggleVisibility(SectionSearch)
            Case CallerPages.SearchVeterinaryDiseaseReport
                ucAddUpdateFarm.Setup(3, monitoringSessionIndicator:=False, action:=UserAction.Read, farmID:=ViewState(CALLER_KEY))
                ToggleVisibility(SectionFarm)
            Case Else
                ucSearchFarm.Setup(enableFarmType:=True, selectMode:=SelectModes.View)
                ToggleVisibility(SectionSearch)
        End Select


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

        ucSearchFarm.Visible = section.Equals(SectionSearch)
        ucAddUpdateFarm.Visible = section.EqualsAny({SectionFarm, SectionPerson})

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        hdgWarning.InnerText = Resources.WarningMessages.Warning_Message_Alert

        Select Case messageType
            Case MessageType.CancelSearchFarmConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
                hdfWarningMessageType.Value = MessageType.CancelSearchConfirm.ToString()
            Case MessageType.CancelSearchPersonConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
                hdfWarningMessageType.Value = MessageType.CancelSearchPersonConfirm.ToString()
            Case MessageType.CancelConfirmAddUpdate
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Add_Update_Confirm
                hdfWarningMessageType.Value = MessageType.CancelConfirmAddUpdate.ToString()
            Case MessageType.CannotAddUpdate
                divWarningBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case MessageType.CannotDelete
                divWarningBody.InnerText = message
            Case MessageType.CannotGetValidatorSection
                divWarningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case MessageType.UnhandledException
                divWarningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case MessageType.SearchCriteriaRequired
                divWarningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case MessageType.InvalidDateOfBirth
                divWarningBody.InnerText = Resources.WarningMessages.Invalid_DOB
            Case MessageType.DuplicateHuman
                divWarningBody.InnerText = message
                hdfWarningMessageType.Value = MessageType.DuplicateHuman.ToString()
            Case MessageType.DuplicateFarm
                divWarningBody.InnerText = message
                hdfWarningMessageType.Value = MessageType.DuplicateFarm.ToString()
            Case MessageType.ConfirmDeletePerson
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
                hdfWarningMessageType.Value = MessageType.ConfirmDeletePerson.ToString()
            Case MessageType.ConfirmDeleteFarm
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
                hdfWarningMessageType.Value = MessageType.ConfirmDeleteFarm.ToString()
        End Select

        If isConfirm Then
            divWarningYesNo.Visible = True
            divWarningOK.Visible = False
        Else
            divWarningOK.Visible = True
            divWarningYesNo.Visible = False
        End If

        upFarm.Update()
        upWarningModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divWarningModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Select Case hdfWarningMessageType.Value.ToString()
                Case MessageType.DuplicateHuman.ToString()
                    upFarm.Update()
                    ucAddUpdatePerson.ContinueSave()
                Case MessageType.DuplicateFarm.ToString()
                    upFarm.Update()
                    ucAddUpdateFarm.ContinueSave()
                Case MessageType.CancelConfirmAddUpdate.ToString()
                    upFarm.Update()
                    ToggleVisibility(SectionSearch)
                    If ViewState(CALLER).ToString() = CallerPages.SearchVeterinaryDiseaseReport Then
                        ucSearchFarm.Setup(enableFarmType:=True, selectMode:=SelectModes.View)
                    Else
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
                    End If
                Case MessageType.ConfirmDeletePerson.ToString()
                    upFarm.Update()
                    ucAddUpdatePerson.DeletePersonRecord()
                Case MessageType.ConfirmDeleteFarm.ToString()
                    upFarm.Update()
                    ucAddUpdateFarm.DeleteFarmMasterRecord()
                Case MessageType.CancelSearchFarmConfirm.ToString()
                    Response.Redirect(GetURL(CallerPages.DashboardURL), False)
                    Context.ApplicationInstance.CompleteRequest()
                Case MessageType.CancelSearchPersonConfirm.ToString()
                    upFarm.Update()
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divSearchPersonModal"), True)
                Case Else
                    Response.Redirect(GetURL(CallerPages.DashboardURL), False)
                    Context.ApplicationInstance.CompleteRequest()
            End Select

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub WarningModalNo_Click(sender As Object, e As EventArgs) Handles btnWarningModalNo.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            hdfWarningMessageType.Value = String.Empty

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType, Optional message As String = Nothing)

        Select Case messageType
            Case MessageType.DeleteSuccess
                lblSuccessMessage.InnerText = Resources.Labels.Lbl_Delete_Success_Text
                ucSearchFarm.SearchFarms()
                ToggleVisibility(SectionSearch)
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SHOW_MODAL_SCRIPT, "#divWarningModal", "#divSuccessModal"), True)
            Case MessageType.AddUpdateSuccess
                lblSuccessMessage.InnerText = message
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)
        End Select

        upSuccessModal.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Sender"></param>
    ''' <param name="e"></param>
    Private Sub Farm_Error(Sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then
            ShowWarningMessage(messageType:=MessageType.UnhandledException, isConfirm:=False)
        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & [GetType].Name, True)
        End If

        Server.ClearError()

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Protected Sub SearchFarm_ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String) Handles ucSearchFarm.ShowWarningModal

        upFarm.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    Protected Sub SearchFarm_ViewFarm(farmID As Long) Handles ucSearchFarm.ViewFarm

        ToggleVisibility(SectionFarm)

        ucAddUpdateFarm.Setup(initialPanelID:=2, action:=UserAction.Read, farmID:=farmID)

        upFarm.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub SearchFarm_CreateFarm() Handles ucSearchFarm.CreateFarm

        Try
            upFarm.Update()

            ToggleVisibility(SectionFarm)

            ucAddUpdateFarm.Setup(initialPanelID:=0, monitoringSessionIndicator:=False, action:=UserAction.Insert)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    Protected Sub SearchFarm_EditFarm(farmID As Long) Handles ucSearchFarm.EditFarm

        ToggleVisibility(SectionFarm)

        ucAddUpdateFarm.Setup(initialPanelID:=0, action:=UserAction.Update, farmID:=farmID)

        upFarm.Update()

    End Sub

#End Region

#Region "Add/Update Farm Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    ''' <param name="farmName"></param>
    ''' <param name="eidssFarmID"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdateFarm_CreateFarm(farmID As Long, farmName As String, eidssFarmID As String, message As String) Handles ucAddUpdateFarm.CreateFarm

        upFarm.Update()

        ViewState(CALLER_KEY) = farmID

        ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=message & eidssFarmID & ".")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    ''' <param name="farmName"></param>
    ''' <param name="eidssFarmID"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdateFarm_UpdateFarm(farmID As Long, farmName As String, eidssFarmID As String, message As String) Handles ucAddUpdateFarm.UpdateFarm

        upFarm.Update()

        ViewState(CALLER_KEY) = farmID

        ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddFarmFarm_Validate() Handles ucAddUpdateFarm.ValidatePage

        Validate("FarmInformation")
        Validate("FarmAddressInformationSection")
        Validate("FarmHerdSpecies")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddFarm_ShowSearch() Handles ucAddUpdateFarm.ShowSearch

        upFarm.Update()

        ToggleVisibility(SectionSearch)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddUpdateFarm_ShowSearchPersonModal() Handles ucAddUpdateFarm.ShowSearchPersonModal

        upFarm.Update()
        InitializeSearchPerson()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdateFarm_ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String) Handles ucAddUpdateFarm.ShowWarningModal

        upFarm.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    Protected Sub AddUpdateFarm_ShowSuccessModal(messageType As MessageType) Handles ucAddUpdateFarm.ShowSuccessModal

        ShowSuccessMessage(messageType:=messageType)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ReturnToFarmRecord_Click(sender As Object, e As EventArgs) Handles btnReturnToFarmRecord.Click

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSuccessModal"), True)

        ucAddUpdateFarm.Setup(initialPanelID:=0, action:=UserAction.Update, farmID:=ViewState(CALLER_KEY))

    End Sub

#End Region

#Region "Search Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub InitializeSearchPerson()

        ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchPersonModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchPerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchPerson.ShowWarningModal

        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

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

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchPersonModal"), True)
        ucAddUpdateFarm.SetFarmOwner(farmOwnerID:=humanID, farmOwnerName:=fullName, eidssPersonID:=eidssPersonID, firstName:=firstName, lastName:=lastName)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub SearchPerson_CreatePerson() Handles ucSearchPerson.CreatePerson

        InitializeAddUpdatePerson(runScript:=False)
        ScriptManager.RegisterClientScriptBlock(Page, [GetType](), MODAL_ON_MODAL_KEY, "hideModalShowModal('#divSearchPersonModal', '#divAddUpdatePersonModal');", True)

    End Sub

#End Region

#Region "Add/Update Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="runScript"></param>
    Private Sub InitializeAddUpdatePerson(runScript As Boolean)

        upAddUpdatePerson.Update()

        ucAddUpdatePerson.Setup(initialPanelID:=0, action:=UserAction.Insert, copyToHumanIndicator:=True)

        If runScript = True Then
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAddUpdatePersonModal"), True)
        End If

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
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Protected Sub AddPersonPerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String) Handles ucAddUpdatePerson.ShowWarningModal

        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=message)

    End Sub

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

        ucAddUpdateFarm.SetFarmOwner(farmOwnerID:=humanID, farmOwnerName:=fullName, eidssPersonID:=eidssPersonID, firstName:=firstName, lastName:=lastName)
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAddUpdatePersonModal"), True)

    End Sub

#End Region

End Class