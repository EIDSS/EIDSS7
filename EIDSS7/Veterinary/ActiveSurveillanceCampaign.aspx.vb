Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Enumerations
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class VeterinaryActiveSurveillanceCampaign
    Inherits BaseEidssPage

#Region "Global Values"

    Public sFile As String

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    'Constants for Sections/Panels on the formt
    Private Const SectionMode As String = "SectionMode"
    Private Const SectionSearch As String = "Search"
    Private Const SectionSearchForm As String = "Search"
    Private Const SectionSearchResults As String = "SearchResults"
    Private Const SectionCampaignInformation As String = "Campaign"
    Private Const SectionMonitoringSessions As String = "Monitoring Sessions"
    Private Const SectionConclusion As String = "Conclusion"
    Private Const SectionDeleteCampaign As String = "Delete Campaign"

    Private Const PAGE_KEY As String = "Page"
    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"

    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideCampaignSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showCampaignSearchCriteria();"
    Private Const SHOW_SPECIES_AND_SAMPLE_MODAL As String = "showSpeciesAndSampleModal();"
    Private Const HIDE_SPECIES_AND_SAMPLE_MODAL As String = "hideSpeciesAndSampleModal();"

    Private Const CAMPAIGNS_SORT_DIRECTION As String = "gvCampaigns_SortDirection"
    Private Const CAMPAIGNS_SORT_EXPRESSION As String = "gvCampaigns_SortExpression"
    Private Const CAMPAIGNS_PAGINATION_SET_NUMBER As String = "gvCampaigns_PaginationSet"
    Private Const MONITORING_SESSIONS_SORT_DIRECTION As String = "gvMonitoringSessions_SortDirection"
    Private Const MONITORING_SESSIONS_SORT_EXPRESSION As String = "gvMonitoringSessions_SortExpression"
    Private Const MONITORING_SESSIONS_PAGINATION_SET_NUMBER As String = "gvMonitoringSessions_PaginationSet"

    Private Const SESSION_CAMPAIGNS As String = "gvCampaigns"
    Private Const CAMPAIGN_SESSION As String = "Campaign"
    Private Const SESSION_MONITORING_SESSIONS As String = "gvMonitoringSessions"
    Private Const SESSION_SPECIES_TO_SAMPLE_TYPES As String = "gvSpeciesToSampleTypes"
    Private Const SESSION_MONITORING_SESSION_SPECIES_TO_SAMPLE_TYPES As String = "gvMonitoringSessionSpeciesToSampleTypes"
    Private Const SESSION_DISEASE_TO_SPECIES As String = "gvDiseaseToSpeciesTypes"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private FarmAPIService As FarmServiceClient
    Private OrganizationAPIService As OrganizationServiceClient
    Private VeterinaryAPIService As VeterinaryServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(VeterinaryActiveSurveillanceCampaign))

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
                Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

                If Not EIDSSAuthenticatedUser.EIDSSUserId Is Nothing Then
                    sFile = Request.PhysicalApplicationPath & "App_Data\" & EIDSSAuthenticatedUser.EIDSSUserId.ToString() & "_VAS.xml"
                End If

                cmvFutureCampaignEndDate.ValueToCompare = Date.Now.ToShortDateString()
                cmvFutureCampaignStartDate.ValueToCompare = Date.Now.ToShortDateString()

                CheckCallerHandler()
                txtEIDSSCampaignID.Enabled = False
            End If
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
    Private Sub CheckCallerHandler()

        ExtractViewStateSession()

        If (Not hdfCampaignID.Value = "-1" AndAlso ViewState(CALLER).Equals(CallerPages.VeterinaryActiveSurveillanceMonitoringSession)) Then
            ToggleVisibility(SectionCampaignInformation)
            FillForm()
        ElseIf (ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignNewMonitoringSession Or
                ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignDeleteMonitoringSession Or
                ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignSelectMonitoringSession) Then
            hdfCampaignID.Value = ViewState(CALLER_KEY)
            ToggleVisibility(SectionMonitoringSessions)
            FillForm()
        Else
            ToggleVisibility(SectionSearch)
            FillSearch()
            hdfCampaignID.Value = "-1"
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

        'Containers
        divCampaignSearchForm.Visible = section.EqualsAny({SectionSearchForm, SectionSearchResults})
        divVeterinaryActiveSurveillanceCampaignForm.Visible = section.EqualsAny({SectionCampaignInformation, SectionDeleteCampaign, SectionMonitoringSessions})
        divCampaignSearchResults.Visible = section.Equals(SectionSearchResults)
        toggleIcon.Visible = section.Equals(SectionSearchResults)
        btnAddCampaign.Visible = section.Equals(SectionSearchResults)
        btnPrintSearchResults.Visible = section.Equals(SectionSearchResults)
        btnCancelSearchResults.Visible = section.Equals(SectionSearchResults)

        If hdfCampaignID.Value = "-1" Then
            divSessionsContainer.Visible = False
            divConclusionContainer.Visible = False
        Else
            divSessionsContainer.Visible = True
            divConclusionContainer.Visible = True
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ActiveSurveillanceCampaigns_Error(sender As Object, e As EventArgs) Handles Me.[Error]

        Dim ex As Exception = Server.GetLastError()

        If (TypeOf ex Is HttpUnhandledException) Then
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

    Function RemoveDuplicateRows(dTable As DataTable, colName As String) As DataTable

        Dim hTable As Hashtable = New Hashtable()
        Dim duplicateList As ArrayList = New ArrayList()

        For Each dtRow In dTable.Rows
            If hTable.Contains(dtRow(colName)) Then

                duplicateList.Add(dtRow)
            Else
                hTable.Add(dtRow(colName), String.Empty)
            End If
        Next

        For Each dr In duplicateList
            dTable.Rows.Remove(dr)
        Next

        Return dTable

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        hdgWarning.InnerText = Resources.WarningMessages.Warning_Message_Alert

        Select Case messageType
            Case MessageType.CancelSearchConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
                hdfWarningMessageType.Value = MessageType.CancelSearchConfirm
            Case MessageType.CancelConfirmAddUpdate
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Add_Update_Confirm
                hdfWarningMessageType.Value = MessageType.CancelConfirmAddUpdate
            Case MessageType.SearchCriteriaRequired
                divWarningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case MessageType.DuplicateSpeciesAndSample
                warningSubTitle.InnerText = GetLocalResourceObject("Warning_Message_Duplicate_Record_SubHeading")
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Duplicate_Record_Body_Text")
            Case MessageType.CannotDelete
                warningSubTitle.InnerText = GetLocalResourceObject("Warning_Message_Has_Sessions_SubHeading")
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Has_Sessions_Body_Text")
            Case MessageType.CancelConfirm
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Cancel_Confirm")
            Case MessageType.CampaignStatusOpenNew
                divWarningBody.InnerText = GetLocalResourceObject("Status_Open_New")
            Case MessageType.CampaignStatusOpenClosed
                divWarningBody.InnerText = GetLocalResourceObject("Success_Message_Delete")
            Case MessageType.CannotAddUpdate
                divWarningBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case MessageType.CannotGetValidatorSection
                divWarningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case MessageType.UnhandledException
                divWarningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case MessageType.ConfirmDeleteSpeciesToSampleType
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.ConfirmDeleteCampaign
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.CannotSelectVeterinaryMonitoringSessionForCampaign
                divWarningBody.InnerText = Resources.WarningMessages.Cannot_Select_Veterinary_Monitoring_Session_To_Campaign_Messgage
            Case MessageType.DuplicateCampaign
                divWarningBody.InnerText = message
                hdfWarningMessageType.Value = MessageType.DuplicateCampaign
        End Select

        If isConfirm Then
            divWarningYesNo.Visible = True
            divWarningOK.Visible = False
        Else
            divWarningOK.Visible = True
            divWarningYesNo.Visible = False
        End If

        upHiddenFields.Update()
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
            Select Case hdfWarningMessageType.Value
                Case MessageType.CancelConfirmAddUpdate
                    ToggleVisibility(SectionSearchResults)
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, "hideCampaignSearchCriteriaCloseWarningModal()", True)
                    upSearchCampaign.Update()
                    upAddUpdateCampaign.Update()
                Case MessageType.CancelSearchConfirm
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
                    SaveEIDSSViewState(ViewState)
                    Response.Redirect(GetURL(CallerPages.DashboardURL), True)
                    Context.ApplicationInstance.CompleteRequest()
                Case MessageType.ConfirmDeleteCampaign
                    DeleteCampaign()
                Case MessageType.ConfirmDeleteSpeciesToSampleType
                    Dim campaignToSampleTypeID As Long = hdfRecordID.Value
                    Dim speciesToSampleTypes = TryCast(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))
                    Dim speciesToSampleType = speciesToSampleTypes.Where(Function(x) x.CampaignToSampleTypeID = campaignToSampleTypeID).FirstOrDefault

                    If speciesToSampleType.RowAction = RecordConstants.Insert Then
                        speciesToSampleTypes.Remove(speciesToSampleType)
                    Else
                        speciesToSampleType.RowAction = RecordConstants.Delete
                        speciesToSampleType.RowStatus = RecordConstants.InactiveRowStatus
                    End If

                    Session(SESSION_SPECIES_TO_SAMPLE_TYPES) = speciesToSampleTypes
                    gvSpeciesAndSamples.DataSource = speciesToSampleTypes.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.SpeciesTypeName)
                    gvSpeciesAndSamples.DataBind()

                    upAddUpdateCampaign.Update()
                Case MessageType.DuplicateCampaign
                    ContinueSave()
            End Select

            hdfWarningMessageType.Value = String.Empty
            hdfRecordID.Value = String.Empty

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)

            upHiddenFields.Update()
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
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
    Private Sub WarningModalNo_Click(sender As Object, e As EventArgs) Handles btnWarningModalNo.Click

        Try
            hdfWarningMessageType.Value = String.Empty
            hdfRecordID.Value = String.Empty

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)

            upHiddenFields.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="message"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType, Optional message As String = Nothing)

        Select Case messageType
            Case MessageType.DeleteSuccess
                divAddUpdate.Visible = False
                divSuccessOK.Visible = True
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Message_Delete_Success")
            Case MessageType.AddUpdateSuccess
                divAddUpdate.Visible = True
                divSuccessOK.Visible = False
                lblSuccessMessage.InnerText = message
        End Select

        upSuccessModal.Update()

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)

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
            Case MessageType.CannotAddUpdate
                divErrorBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case MessageType.CannotDelete
                divErrorBody.InnerText = Resources.WarningMessages.Cannot_Delete
            Case MessageType.UnhandledException
                divErrorBody.InnerText = Resources.WarningMessages.Unhandled_Exception
        End Select

        upErrorModal.Update()

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divErrorModal"), True)

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillSearch()

        FillBaseReferenceDropDownList(ddlSearchCampaignStatusTypeID, BaseReferenceConstants.ASCampaignStatus, HACodeList.ASHACode, True)

        If (ddlSearchCampaignStatusTypeID.Items.Count > 0 AndAlso ddlSearchCampaignStatusTypeID.Items.Contains(ddlSearchCampaignStatusTypeID.Items.FindByText("Open"))) Then
            ddlSearchCampaignStatusTypeID.SelectedValue = ddlSearchCampaignStatusTypeID.Items.FindByText("Open").Value
        End If

        FillBaseReferenceDropDownList(ddlSearchCampaignTypeID, BaseReferenceConstants.ASCampaignType, HACodeList.ASHACode, True)
        FillBaseReferenceDropDownList(ddlSearchDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, True)

        Dim parameters = New CampaignGetListParameters()
        Scatter(divCampaignSearchCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)))

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If ValidateSearch() Then
                Dim parameters As New CampaignGetListParameters With {.LanguageID = GetCurrentLanguage()}

                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If

                Dim list As List(Of VctCampaignGetCountModel)
                Gather(divHiddenFieldsSection, parameters)
                Gather(divCampaignSearchCriteria, parameters, 9)
                list = VeterinaryAPIService.GetCampaignCountAsync(parameters).Result
                gvCampaigns.PageIndex = 0
                gvCampaigns.Visible = True
                hdfSearchCount.Value = list.FirstOrDefault().RecordCount

                If list.FirstOrDefault().RecordCount = 1 Then
                    lblCampaignsRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Record_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                Else
                    lblCampaignsRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Records_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                End If

                lblCampaignsPageNumber.Text = "1"
                FillCampaigns(pageIndex:=1, paginationSetNumber:=1)
                SaveSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId, ID))
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
                ToggleVisibility(SectionSearchResults)

                upSearchCampaign.Update()
                upCampaignSearchResults.Update()
            End If
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
    ''' <returns></returns>
    Private Function ValidateSearch() As Boolean

        Dim validated As Boolean = False

        Page.Validate("SearchCampaign")

        'Check if EIDSS ID is entered. If Yes, then ignore rest of the serach fields, otherwise, check if any other search criteria was entered.
        'If Not, raise an error to the user.
        validated = (Not txtSearchEIDSSCampaignID.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divCampaignSearchCriteria, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divCampaignSearchCriteria, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divCampaignSearchCriteria, GetType(WebControls.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As CalendarInput In FindControlList(controls, divCampaignSearchCriteria, GetType(CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                validated = ValidateFromToDates(txtSearchStartDateFrom.Text, txtSearchStartDateTo.Text)
                If Not validated Then
                    ShowWarningMessage(MessageType.InvalidDateOfBirth, False)
                    txtSearchStartDateFrom.Focus()
                End If
            End If

            If validated Then
                ToggleVisibility(SectionSearchResults)
            Else
                ShowWarningMessage(MessageType.SearchCriteriaRequired, False)
                txtSearchEIDSSCampaignID.Focus()
            End If
        End If

        Return validated

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Clear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnClear.Click

        Try
            ResetForm(divCampaignSearchCriteria)

            DeleteTempFiles(HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & ID & EIDSSAuthenticatedUser.EIDSSUserId.ToString() & ".xml")
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
    Private Sub CancelSearch_Click(sender As Object, e As EventArgs) Handles btnCancelSearchCriteria.Click, btnCancelSearchResults.Click

        Try
            ShowWarningMessage(MessageType.CancelSearchConfirm, isConfirm:=True)
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
    Protected Sub Campaigns_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvCampaigns.RowCommand

        Try
            e.Handled = True

            Select Case e.CommandName
                Case GridViewCommandConstants.EditCommand
                    hdfCampaignID.Value = e.CommandArgument
                    FillForm()
                    ShowEditCampaign()
                Case GridViewCommandConstants.ViewCommand
                    hdfCampaignID.Value = e.CommandArgument
                    FillForm()
                    ShowSelectCampaign()
            End Select

            upAddUpdateCampaign.Update()
            upSearchCampaign.Update()
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="campaignID"></param>
    Private Sub DeleteCampaign(campaignID As Long)

        hdfCampaignID.Value = campaignID
        ShowDeleteCampaign()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillCampaigns(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim parameters As New CampaignGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber}

            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If

            Gather(divHiddenFieldsSection, parameters)
            Gather(divCampaignSearchCriteria, parameters, 9)
            Session(SESSION_CAMPAIGNS) = VeterinaryAPIService.GetCampaignListAsync(parameters).Result
            BindCampaignsGridView()
            FillCampaignsPager(hdfSearchCount.Value, pageIndex)
            ViewState(CAMPAIGNS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindCampaignsGridView()

        Dim list = CType(Session(SESSION_CAMPAIGNS), List(Of VctCampaignGetListModel))

        If (Not ViewState(CAMPAIGNS_SORT_EXPRESSION) Is Nothing) Then
            If ViewState(CAMPAIGNS_SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(CAMPAIGNS_SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(CAMPAIGNS_SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvCampaigns.DataSource = Nothing
        gvCampaigns.DataSource = list
        gvCampaigns.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillCampaignsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divCampaignsPager.Visible = True

            'Calculate the start and end index of pages to be displayed.
            Dim dblPageCount As Double = recordCount / Convert.ToDecimal(10)
            Dim pageCount As Integer = Math.Ceiling(dblPageCount)
            startIndex = If(currentPage > 1 AndAlso currentPage + pagerSpan - 1 < pagerSpan, currentPage, 1)
            endIndex = If(pageCount > pagerSpan, pagerSpan, pageCount)
            If currentPage > pagerSpan Mod 2 Then
                If currentPage = 2 Then
                    endIndex = 5
                Else
                    endIndex = currentPage + 2
                End If
            Else
                endIndex = (pagerSpan - currentPage) + 1
            End If

            If endIndex - (pagerSpan - 1) > startIndex Then
                startIndex = endIndex - (pagerSpan - 1)
            End If

            If endIndex > pageCount Then
                endIndex = pageCount
                startIndex = If(((endIndex - pagerSpan) + 1) > 0, (endIndex - pagerSpan) + 1, 1)
            End If

            'Add the First Page Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptCampaignsPager.DataSource = pages
            rptCampaignsPager.DataBind()
            divCampaignsPager.Visible = True
        Else
            divCampaignsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CampaignsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            lblCampaignsPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer
            paginationSetNumber = Math.Ceiling(pageIndex / gvCampaigns.PageSize)

            If Not ViewState(CAMPAIGNS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvCampaigns.PageIndex = gvCampaigns.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvCampaigns.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvCampaigns.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvCampaigns.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvCampaigns.PageIndex = gvCampaigns.PageSize - 1
                        Else
                            gvCampaigns.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillCampaigns(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvCampaigns.PageIndex = gvCampaigns.PageSize - 1
                Else
                    gvCampaigns.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindCampaignsGridView()
                FillCampaignsPager(hdfSearchCount.Value, pageIndex)
            End If
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
    Protected Sub Campaigns_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvCampaigns.Sorting

        Try
            upCampaignSearchResults.Update()

            ViewState(CAMPAIGNS_SORT_DIRECTION) = IIf(ViewState(CAMPAIGNS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(CAMPAIGNS_SORT_EXPRESSION) = e.SortExpression

            SaveEIDSSViewState(ViewState)

            BindCampaignsGridView()
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
    Protected Sub SearchCriteria_Changed(sender As Object, e As EventArgs) Handles txtSearchCampaignName.TextChanged, txtSearchEIDSSCampaignID.TextChanged, ddlSearchCampaignTypeID.SelectedIndexChanged, ddlSearchDiseaseID.SelectedIndexChanged, ddlSearchCampaignStatusTypeID.SelectedIndexChanged

        divCampaignSearchResults.Visible = False
        divCampaignSearchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")

    End Sub

#End Region

#Region "Campaign Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddCampaign_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddCampaign.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            ResetForm(divVeterinaryActiveSurveillanceCampaignForm)
            hdfCampaignID.Value = -1
            btnSubmit.Visible = True
            btnDelete.Visible = False

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Dim diseases = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage, BaseReferenceConstants.Diagnosis, (HACodeList.LivestockHACode + HACodeList.AvianHACode)).Result
            ddlDiseaseID.DataSource = diseases
            ddlDiseaseID.DataTextField = "name"
            ddlDiseaseID.DataValueField = "idfsBaseReference"
            ddlDiseaseID.DataBind()
            Dim li As ListItem = New ListItem With {.Value = GlobalConstants.NullValue.ToLower(), .Text = String.Empty}
            ddlDiseaseID.Items.Insert(0, li)
            Session(SESSION_DISEASE_TO_SPECIES) = diseases

            ToggleVisibility(SectionCampaignInformation)

            FillNewRecord()
            FillSpeciesAndSamples(refresh:=True)

            upAddUpdateCampaign.Update()
            upSearchCampaign.Update()
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
    Private Sub FillNewRecord()

        FillBaseReferenceDropDownList(ddlCampaignStatusTypeID, BaseReferenceConstants.ASCampaignStatus, HACodeList.ASHACode, True)
        ddlCampaignStatusTypeID.SelectedValue = ddlCampaignStatusTypeID.Items.FindByValue(CampaignStatusTypes.NewStatus).Value
        FillBaseReferenceDropDownList(ddlCampaignTypeID, BaseReferenceConstants.ASCampaignType, HACodeList.ASHACode, True)
        FillBaseReferenceDropDownList(ddlInsertSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.AllHACode, True)
        FillBaseReferenceDropDownList(ddlInsertSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.AllHACode, True)

        EnableForm(divVeterinaryActiveSurveillanceCampaignForm, True)
        txtEIDSSCampaignID.Enabled = False

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ShowEditCampaign()

        EnableForm(divVeterinaryActiveSurveillanceCampaignForm, True)
        txtEIDSSCampaignID.Enabled = False
        ToggleVisibility(SectionCampaignInformation)
        btnSubmit.Visible = True
        btnDelete.Visible = False

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ShowSelectCampaign()

        FillForm()
        ToggleVisibility(SectionCampaignInformation)
        EnableForm(divVeterinaryActiveSurveillanceCampaignForm, False)
        EnableForm(btnCancelAddUpdate, True)

        If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpizootologist) Or EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Then
            btnDelete.Visible = True
        Else
            btnDelete.Visible = False
        End If

        EnableForm(btnDelete, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Delete_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnDelete.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            ShowWarningMessage(messageType:=MessageType.ConfirmDeleteCampaign, isConfirm:=True, message:=Nothing)

            hdfWarningMessageType.Value = MessageType.ConfirmDeleteCampaign

            upHiddenFields.Update()
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
    Private Sub DeleteCampaign()

        Try
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            Dim returnResults As List(Of VctCampaignDelModel) = VeterinaryAPIService.DeleteCampaignAsync(GetCurrentLanguage(), hdfCampaignID.Value).Result

            If returnResults.Count = 0 Then
                ShowErrorMessage(messageType:=MessageType.CannotDelete)
            Else
                Select Case returnResults.FirstOrDefault().ReturnCode
                    Case 0
                        upSearchCampaign.Update()
                        upAddUpdateCampaign.Update()
                        ShowSuccessMessage(messageType:=MessageType.DeleteSuccess)
                        ToggleVisibility(SectionSearch)
                    Case 1
                        ShowWarningMessage(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Child_Objects_Message)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ShowDeleteCampaign()

        FillForm()
        ToggleVisibility(SectionDeleteCampaign)
        EnableForm(divVeterinaryActiveSurveillanceCampaignForm, False)
        EnableForm(gvMonitoringSessions, True)
        EnableForm(gvSpeciesAndSamples, True)
        EnableForm(btnDelete, True)
        EnableForm(btnCancelAddUpdate, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Submit_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmit.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Validate("CampaignInfo")

            If (Page.IsValid()) Then
                AddUpdateCampaign()
                FillForm()
                ToggleVisibility(SectionCampaignInformation)
                upAddUpdateCampaign.Update()
            End If
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
    Private Sub ReturnToDashboard_Click(sender As Object, e As EventArgs) Handles btnReturnToDashboard.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Response.Redirect(GetURL(CallerPages.DashboardURL), True)
            Context.ApplicationInstance.CompleteRequest()
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
    Protected Sub CampaignStatusTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCampaignStatusTypeID.SelectedIndexChanged

        Try
            If ddlCampaignStatusTypeID.SelectedValue = CampaignStatusTypes.NewStatus Then
                cmvFutureCampaignStartDate.Enabled = False

                If gvMonitoringSessions.Rows.Count > 0 Then
                    ShowWarningMessage(messageType:=MessageType.CampaignStatusOpenNew, isConfirm:=False)
                    ddlCampaignStatusTypeID.SelectedValue = ddlCampaignStatusTypeID.Items.FindByValue(CampaignStatusTypes.Open).Value
                Else
                    Dim sessionStatusExist As Boolean = False
                    Dim monitoringSessions = TryCast(Session(SESSION_MONITORING_SESSIONS), List(Of VctMonitoringSessionGetListModel))
                    If Not monitoringSessions Is Nothing Then
                        For Each monitoringSession In monitoringSessions
                            If (Not IsDBNull(monitoringSession.SessionStatusTypeName) AndAlso monitoringSession.SessionStatusTypeName = "Open") Then
                                sessionStatusExist = True
                            End If
                        Next

                        If (ddlCampaignStatusTypeID.SelectedValue = CampaignStatusTypes.Closed AndAlso sessionStatusExist) Then
                            ShowWarningMessage(messageType:=MessageType.CampaignStatusOpenClosed, isConfirm:=False)
                            ddlCampaignStatusTypeID.SelectedValue = ddlCampaignStatusTypeID.Items.FindByValue(CampaignStatusTypes.Open).Value
                        End If
                    End If
                End If
            ElseIf ddlCampaignStatusTypeID.SelectedValue = CampaignStatusTypes.Open Then
                cmvFutureCampaignStartDate.Enabled = True
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillForm()

        'Populate disease with avian and livestock to determine the species and samples based on disease.
        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        If Session(SESSION_DISEASE_TO_SPECIES) Is Nothing Or ddlDiseaseID.Items.Count = 0 Then
            Dim diseases = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage, BaseReferenceConstants.Diagnosis, (HACodeList.LivestockHACode + HACodeList.AvianHACode)).Result
            ddlDiseaseID.DataSource = diseases
            ddlDiseaseID.DataTextField = "name"
            ddlDiseaseID.DataValueField = "idfsBaseReference"
            ddlDiseaseID.DataBind()
            Dim li As ListItem = New ListItem With {.Value = GlobalConstants.NullValue.ToLower(), .Text = String.Empty}
            ddlDiseaseID.Items.Insert(0, li)
            Session(SESSION_DISEASE_TO_SPECIES) = diseases
        End If

        If ddlCampaignStatusTypeID.Items.Count = 0 Then
            BaseReferenceLookUp(ddlCampaignStatusTypeID, BaseReferenceConstants.ASCampaignStatus, HACodeList.ASHACode, True)
        End If

        If ddlCampaignTypeID.Items.Count = 0 Then
            FillBaseReferenceDropDownList(ddlCampaignTypeID, BaseReferenceConstants.ASCampaignType, HACodeList.ASHACode, True)
        End If

        If ddlInsertSpeciesTypeID.Items.Count = 0 Then
            FillBaseReferenceDropDownList(ddlInsertSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.AllHACode, True)
        End If

        If ddlInsertSampleTypeID.Items.Count = 0 Then
            FillBaseReferenceDropDownList(ddlInsertSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.AllHACode, True)
        End If

        If Not hdfCampaignID.Value = "-1" Then 'editing/selecting the record
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If

            Dim campaign = VeterinaryAPIService.GetCampaignDetailAsync(GetCurrentLanguage(), hdfCampaignID.Value).Result
            Session(CAMPAIGN_SESSION) = campaign

            Scatter(divVeterinaryActiveSurveillanceCampaignForm, campaign.FirstOrDefault())
            Scatter(divHiddenFieldsSection, campaign.FirstOrDefault())

            FillSpeciesAndSamples(refresh:=True)

            Dim parameters = New MonitoringSessionGetListParameters With {.LanguageID = GetCurrentLanguage(), .CampaignID = hdfCampaignID.Value, .PaginationSetNumber = 1}
            Dim monitoringSessions = VeterinaryAPIService.GetMonitoringSessionCountAsync(parameters).Result
            gvMonitoringSessions.PageIndex = 0
            gvMonitoringSessions.Visible = True
            hdfMonitoringSessionCount.Value = monitoringSessions.FirstOrDefault().RecordCount

            lblMonitoringSessionsPageNumber.Text = "1"
            FillMonitoringSessions(pageIndex:=1, paginationSetNumber:=1)

            If campaign.FirstOrDefault().CampaignStatusTypeID = CampaignStatusTypes.Closed Then
                EnableForm(divVeterinaryActiveSurveillanceCampaignForm, False)
            End If
        Else
            FillSpeciesAndSamples(refresh:=True)
        End If

        ddlDiseaseID.Enabled = False

        ToggleVisibility(SectionCampaignInformation)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub AddUpdateCampaign()

        If Session(SESSION_SPECIES_TO_SAMPLE_TYPES) Is Nothing Then
            Session(SESSION_SPECIES_TO_SAMPLE_TYPES) = New List(Of VctCampaignSpeciesToSampleTypeGetListModel)()
        End If

        If Session(SESSION_MONITORING_SESSIONS) Is Nothing Then
            Session(SESSION_MONITORING_SESSIONS) = New List(Of VctMonitoringSessionGetListModel)()
        End If

        Dim duplicateParams As New CampaignGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .CampaignTypeID = ddlCampaignTypeID.SelectedValue,
                            .DiseaseID = ddlDiseaseID.SelectedValue}

        If VeterinaryAPIService Is Nothing Then
            VeterinaryAPIService = New VeterinaryServiceClient()
        End If
        Dim campaigns = VeterinaryAPIService.GetCampaignListAsync(parameters:=duplicateParams).Result

        If campaigns.Where(Function(x) x.EnteredDate < Date.Today.AddYears(1)).Count > 0 Then
            Dim duplicateRecordsFound As String = Resources.WarningMessages.Duplicate_Record_Found

            For Each campaign As VctCampaignGetListModel In campaigns
                duplicateRecordsFound += campaign.EIDSSCampaignID & ", "
            Next

            'Remove last comma and space.
            duplicateRecordsFound = duplicateRecordsFound.Remove(duplicateRecordsFound.Length - 2, 2)
            duplicateRecordsFound &= ". " & Resources.Labels.Lbl_Continue_Save_Question_Text

            ShowWarningMessage(messageType:=MessageType.DuplicateCampaign, isConfirm:=True, message:=duplicateRecordsFound)
        Else
            ContinueSave()
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ContinueSave()

        Dim parameters As CampaignSetParameters = New CampaignSetParameters With {
                .LanguageID = GetCurrentLanguage(),
                .AuditUserName = EIDSSAuthenticatedUser.UserName,
                .CampaignCategoryTypeID = CampaignCategory.Veterinary,
                .SiteID = EIDSSAuthenticatedUser.SiteId,
                .SpeciesToSampleTypeCombinations = BuildSpeciesToSampleTypeParameters(CType(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))),
                .MonitoringSessions = BuildMonitoringSessionParameters(CType(Session(SESSION_MONITORING_SESSIONS), List(Of VctMonitoringSessionGetListModel)))
            }

        Gather(divHiddenFieldsSection, parameters)
        Gather(divVeterinaryActiveSurveillanceCampaignForm, parameters)

        If VeterinaryAPIService Is Nothing Then
            VeterinaryAPIService = New VeterinaryServiceClient()
        End If
        Dim returnResults As List(Of VctCampaignSetModel) = VeterinaryAPIService.SaveCampaignAsync(parameters).Result

        If returnResults.Count = 0 Then
            ShowErrorMessage(messageType:=MessageType.CannotAddUpdate)
        Else
            If returnResults.FirstOrDefault().ReturnCode = 0 Then
                If hdfCampaignID.Value = "-1" Then
                    hdfCampaignID.Value = returnResults.FirstOrDefault().CampaignID
                    txtEIDSSCampaignID.Text = returnResults.FirstOrDefault().EIDSSCampaignID

                    ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=GetLocalResourceObject("Lbl_Create_Success") & returnResults.FirstOrDefault().EIDSSCampaignID & ".")
                Else
                    ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=GetLocalResourceObject("Lbl_Update_Success"))
                End If

                upHiddenFields.Update()
                upAddUpdateCampaign.Update()
            Else
                ShowWarningMessage(messageType:=MessageType.CannotAddUpdate, isConfirm:=False)
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="speciesToSampleTypes"></param>
    ''' <returns></returns>
    Private Function BuildSpeciesToSampleTypeParameters(speciesToSampleTypes As List(Of VctCampaignSpeciesToSampleTypeGetListModel)) As List(Of CampaignSpeciesToSampleTypeParameters)

        Dim speciesToSampleTypeParameters As List(Of CampaignSpeciesToSampleTypeParameters) = New List(Of CampaignSpeciesToSampleTypeParameters)()
        Dim speciesToSampleTypeParameter As CampaignSpeciesToSampleTypeParameters

        For Each speciesToSampleTypeModel As VctCampaignSpeciesToSampleTypeGetListModel In speciesToSampleTypes
            speciesToSampleTypeParameter = New CampaignSpeciesToSampleTypeParameters()
            With speciesToSampleTypeParameter
                .CampaignToSampleTypeID = speciesToSampleTypeModel.CampaignToSampleTypeID
                .Comments = speciesToSampleTypeModel.Comments
                .OrderNumber = speciesToSampleTypeModel.OrderNumber
                .PlannedNumber = speciesToSampleTypeModel.PlannedNumber
                .RowAction = speciesToSampleTypeModel.RowAction
                .RowStatus = speciesToSampleTypeModel.RowStatus
                .SampleTypeID = speciesToSampleTypeModel.SampleTypeID
                .SpeciesTypeID = speciesToSampleTypeModel.SpeciesTypeID
            End With

            speciesToSampleTypeParameters.Add(speciesToSampleTypeParameter)
        Next

        Return speciesToSampleTypeParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessions"></param>
    ''' <returns></returns>
    Private Function BuildMonitoringSessionParameters(monitoringSessions As List(Of VctMonitoringSessionGetListModel)) As List(Of CampaignMonitoringSessionParameters)

        Dim monitoringSessionParameters As List(Of CampaignMonitoringSessionParameters) = New List(Of CampaignMonitoringSessionParameters)()
        Dim monitoringSessionParameter As CampaignMonitoringSessionParameters

        For Each monitoringSessionModel As VctMonitoringSessionGetListModel In monitoringSessions
            If monitoringSessionModel.CampaignID Is Nothing Then
                monitoringSessionParameter = New CampaignMonitoringSessionParameters()
                With monitoringSessionParameter
                    .MonitoringSessionID = monitoringSessionModel.VeterinaryMonitoringSessionID
                End With

                monitoringSessionParameters.Add(monitoringSessionParameter)
            End If
        Next
        If monitoringSessionParameters.Count = 0 Then
            Return New List(Of CampaignMonitoringSessionParameters)()
        Else
            Return monitoringSessionParameters
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CancelAddUpdate_Click(sender As Object, e As EventArgs) Handles btnCancelAddUpdate.Click

        Try
            ShowWarningMessage(MessageType.CancelConfirmAddUpdate, isConfirm:=True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Species and Samples Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillSpeciesAndSamples(ByVal refresh As Boolean)

        Try
            Dim speciesToSampleTypes = New List(Of VctCampaignSpeciesToSampleTypeGetListModel)()

            If refresh Then Session(SESSION_SPECIES_TO_SAMPLE_TYPES) = Nothing

            If IsNothing(Session(SESSION_SPECIES_TO_SAMPLE_TYPES)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                speciesToSampleTypes = VeterinaryAPIService.GetCampaignSpeciesToSampleTypeListAsync(GetCurrentLanguage(), hdfCampaignID.Value).Result
                Session(SESSION_SPECIES_TO_SAMPLE_TYPES) = speciesToSampleTypes
            Else
                speciesToSampleTypes = CType(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))
            End If

            gvSpeciesAndSamples.DataSource = Nothing
            gvSpeciesAndSamples.DataSource = speciesToSampleTypes
            gvSpeciesAndSamples.DataBind()
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
    Private Sub InsertSpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlInsertSpeciesTypeID.SelectedIndexChanged

        Try
            If ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty Then
                ddlInsertSampleTypeID.Enabled = False
                ddlInsertSampleTypeID.ClearSelection()
                txtInsertPlannedNumber.Enabled = False
                txtInsertPlannedNumber.Text = String.Empty
            Else
                ddlInsertSampleTypeID.Enabled = True
                txtInsertPlannedNumber.Enabled = True
            End If
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
    Protected Sub EditSpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim gvr As GridViewRow = CType(sender, DropDownList).NamingContainer

            EditSpeciesToSampleTypeRecord(sender.ID, gvr)
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
    Protected Sub EditSampleTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim gvr As GridViewRow = CType(sender, DropDownList).NamingContainer

            EditSpeciesToSampleTypeRecord(sender.ID, gvr)
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
    Protected Sub EditPlannedNumber_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim gvr As GridViewRow = CType(sender, TextBox).NamingContainer

            EditSpeciesToSampleTypeRecord(sender.ID, gvr)
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
    Protected Sub EditComments_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim gvr As GridViewRow = CType(sender, TextBox).NamingContainer

            EditSpeciesToSampleTypeRecord(sender.ID, gvr)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="gvr"></param>
    Private Sub EditSpeciesToSampleTypeRecord(sender As String, gvr As GridViewRow)

        Dim speciesToSampleTypes = CType(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))
        Dim speciesToSampleType = speciesToSampleTypes.Where(Function(x) x.CampaignToSampleTypeID = gvSpeciesAndSamples.DataKeys(gvr.RowIndex).Values(0)).FirstOrDefault
        Dim ddlEditSpeciesTypeID As DropDownList = gvr.FindControl("ddlEditSpeciesTypeID")
        Dim ddlEditSampleTypeID As DropDownList = gvr.FindControl("ddlEditSampleTypeID")
        Dim txtEditPlannedNumber As NumericSpinner = gvr.FindControl("txtEditPlannedNumber")
        Dim txtEditComments As TextBox = gvr.FindControl("txtEditComments")

        'Check if species to sample type combination already exists.
        If ExistsSpeciesAndSampleRow(hdfRecordID.Value,
                                         If(ddlEditSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSampleTypeID.SelectedValue)),
                                         If(ddlEditSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSpeciesTypeID.SelectedValue))) Then
            ShowWarningMessage(messageType:=MessageType.DuplicateSpeciesAndSample, isConfirm:=False)

            Select Case sender
                Case "ddlEditSpeciesTypeID"
                    ddlEditSpeciesTypeID.SelectedValue = speciesToSampleType.SpeciesTypeID
                Case "ddlEditSampleTypeID"
                    ddlEditSampleTypeID.SelectedValue = speciesToSampleType.SampleTypeID
            End Select
        Else
            speciesToSampleType.SampleTypeID = If(ddlEditSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSampleTypeID.SelectedValue))
            speciesToSampleType.SampleTypeName = If(ddlEditSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlEditSampleTypeID.SelectedItem.Text)
            speciesToSampleType.SpeciesTypeID = If(ddlEditSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSpeciesTypeID.SelectedValue))
            speciesToSampleType.SpeciesTypeName = If(ddlEditSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlEditSpeciesTypeID.SelectedItem.Text)
            speciesToSampleType.PlannedNumber = If(txtEditPlannedNumber.Text.ToString() = "", Nothing, CInt(txtEditPlannedNumber.Text))
            speciesToSampleType.Comments = If(txtEditComments.Text.ToString() = "", Nothing, txtEditComments.Text)

            If speciesToSampleType.RowAction = RecordConstants.Read Then
                speciesToSampleType.RowAction = RecordConstants.Update
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub NewSpeciesToSampleType_Click(sender As Object, e As EventArgs) Handles btnNewSpeciesToSampleType.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            hdfRecordID.Value = identity

            'Check if species to sample type combination already exists.
            If ExistsSpeciesAndSampleRow(hdfRecordID.Value,
                                         If(ddlInsertSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSampleTypeID.SelectedValue)),
                                         If(ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSpeciesTypeID.SelectedValue))) Then
                ShowWarningMessage(messageType:=MessageType.DuplicateSpeciesAndSample, isConfirm:=False)
            Else
                AddUpdateSpeciesAndSampleRow(hdfRowAction.Value,
                                         hdfRecordID.Value,
                                         hdfCampaignID.Value,
                                         If(ddlInsertSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSampleTypeID.SelectedValue)),
                                         If(ddlInsertSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlInsertSampleTypeID.SelectedItem.Text),
                                         If(ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSpeciesTypeID.SelectedValue)),
                                         If(ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlInsertSpeciesTypeID.SelectedItem.Text),
                                         If(txtInsertPlannedNumber.Text.ToString() = "", Nothing, CInt(txtInsertPlannedNumber.Text)),
                                         If(txtInsertComments.Text.ToString() = "", Nothing, txtInsertComments.Text))

                ddlInsertSpeciesTypeID.SelectedIndex = -1
                ddlInsertSampleTypeID.SelectedIndex = -1
                txtInsertPlannedNumber.Text = String.Empty
                txtInsertComments.Text = String.Empty
                hdfRecordID.Value = "0"
                hdfRowAction.Value = ""
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' Return true if species and samples exist.
    ''' </summary>
    ''' <param name="campaignToSampleTypeID"></param>
    ''' <param name="sampleTypeID"></param>
    ''' <param name="speciesTypeID"></param>
    ''' <returns>Boolean</returns>
    Private Function ExistsSpeciesAndSampleRow(ByVal campaignToSampleTypeID As Long,
                                               ByVal sampleTypeID As Long,
                                               ByVal speciesTypeID As Long)

        Dim exist As Boolean = False
        Dim speciesToSampleTypes = TryCast(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))

        If speciesToSampleTypes Is Nothing Then
            Return exist
        End If

        Dim foundRow = speciesToSampleTypes.Where(Function(x) x.SampleTypeID = sampleTypeID And x.SpeciesTypeID = speciesTypeID And x.CampaignToSampleTypeID <> campaignToSampleTypeID).FirstOrDefault()

        If (Not foundRow Is Nothing) AndAlso (speciesToSampleTypes.Where(Function(x) x.SampleTypeID = sampleTypeID And x.SpeciesTypeID = speciesTypeID And x.CampaignToSampleTypeID <> campaignToSampleTypeID).Count > 0) Then
            exist = True
        Else
            exist = False
        End If

        Return exist

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="rowAction"></param>
    ''' <param name="recordID"></param>
    ''' <param name="campaignID"></param>
    ''' <param name="sampleTypeID"></param>
    ''' <param name="sampleTypeName"></param>
    ''' <param name="speciesTypeID"></param>
    ''' <param name="speciesTypeName"></param>
    ''' <param name="plannedNumber"></param>
    ''' <param name="comments"></param>
    Private Sub AddUpdateSpeciesAndSampleRow(rowAction As String,
                                             recordID As Integer,
                                             campaignID As Long,
                                             sampleTypeID As Long,
                                             sampleTypeName As String,
                                             speciesTypeID As Long,
                                             speciesTypeName As String,
                                             plannedNumber As Integer?,
                                             comments As String)

        Dim speciesToSampleTypes = TryCast(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))
        Dim speciesToSampleType As VctCampaignSpeciesToSampleTypeGetListModel = New VctCampaignSpeciesToSampleTypeGetListModel()

        speciesToSampleType.CampaignID = campaignID
        speciesToSampleType.SampleTypeID = sampleTypeID
        speciesToSampleType.SampleTypeName = sampleTypeName
        speciesToSampleType.SpeciesTypeID = speciesTypeID
        speciesToSampleType.SpeciesTypeName = speciesTypeName
        speciesToSampleType.PlannedNumber = plannedNumber
        speciesToSampleType.Comments = comments
        speciesToSampleType.CampaignToSampleTypeID = recordID
        speciesToSampleType.OrderNumber = speciesToSampleTypes.Count + 1
        speciesToSampleType.RowStatus = RecordConstants.ActiveRowStatus
        speciesToSampleType.RowAction = RecordConstants.Insert
        speciesToSampleTypes.Add(speciesToSampleType)

        gvSpeciesAndSamples.DataSource = Nothing
        gvSpeciesAndSamples.DataSource = speciesToSampleTypes.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.SpeciesTypeName)
        gvSpeciesAndSamples.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SpeciesAndSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSpeciesAndSamples.RowCommand

        Try
            e.Handled = True

            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    hdfRecordID.Value = e.CommandArgument
                    hdfWarningMessageType.Value = MessageType.ConfirmDeleteSpeciesToSampleType
                    ShowWarningMessage(MessageType.ConfirmDeleteSpeciesToSampleType, True)
                    upHiddenFields.Update()
                Case GridViewCommandConstants.EditCommand
                    Dim speciesToSampleTypes = CType(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))
                    Dim speciesToSampleType = speciesToSampleTypes.Where(Function(x) x.CampaignToSampleTypeID = e.CommandArgument).FirstOrDefault
                    Dim gvr As GridViewRow = CType(e.CommandSource, LinkButton).NamingContainer
                    Dim ddlEditSpeciesTypeID As DropDownList = gvr.FindControl("ddlEditSpeciesTypeID")
                    Dim ddlEditSampleTypeID As DropDownList = gvr.FindControl("ddlEditSampleTypeID")
                    Dim txtEditPlannedNumber As NumericSpinner = gvr.FindControl("txtEditPlannedNumber")
                    Dim txtEditComments As TextBox = gvr.FindControl("txtEditComments")
                    If Not speciesToSampleType Is Nothing Then
                        ddlEditSpeciesTypeID.SelectedValue = If(speciesToSampleType.SpeciesTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, speciesToSampleType.SpeciesTypeID)
                        ddlEditSpeciesTypeID.Enabled = True
                        ddlEditSampleTypeID.SelectedValue = If(speciesToSampleType.SampleTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, speciesToSampleType.SampleTypeID)
                        ddlEditSampleTypeID.Enabled = True
                        txtEditPlannedNumber.Text = If(speciesToSampleType.PlannedNumber.ToString.IsValueNullOrEmpty(), String.Empty, speciesToSampleType.PlannedNumber)
                        txtEditPlannedNumber.Enabled = True
                        txtEditComments.Text = If(speciesToSampleType.Comments Is Nothing, String.Empty, speciesToSampleType.Comments)
                        txtEditComments.Enabled = True

                        hdfRecordID.Value = speciesToSampleType.CampaignToSampleTypeID
                        hdfRowAction.Value = speciesToSampleType.RowAction.ToString
                    End If
            End Select
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
    Private Sub SpeciesAndSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSpeciesAndSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim speciesToSampleType As VctCampaignSpeciesToSampleTypeGetListModel = TryCast(e.Row.DataItem, VctCampaignSpeciesToSampleTypeGetListModel)
                If Not speciesToSampleType Is Nothing Then
                    Dim ddl As DropDownList = CType(e.Row.FindControl("ddlEditSpeciesTypeID"), DropDownList)
                    FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.SpeciesList, HACodeList.AllHACode, False)
                    ddl.SelectedValue = speciesToSampleType.SpeciesTypeID
                    ddl.Enabled = False

                    ddl = CType(e.Row.FindControl("ddlEditSampleTypeID"), DropDownList)
                    FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.SampleType, HACodeList.AllHACode, True)
                    ddl.SelectedValue = speciesToSampleType.SampleTypeID
                    ddl.Enabled = False

                    Dim txtEditPlannedNumber As NumericSpinner = CType(e.Row.FindControl("txtEditPlannedNumber"), NumericSpinner)
                    txtEditPlannedNumber.Text = speciesToSampleType.PlannedNumber
                    txtEditPlannedNumber.Enabled = False

                    Dim txtComments As TextBox = CType(e.Row.FindControl("txtEditComments"), TextBox)
                    txtComments.Text = speciesToSampleType.Comments
                    txtComments.Enabled = False
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Monitoring Session Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillMonitoringSessions(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim parameters As New MonitoringSessionGetListParameters With {.LanguageID = GetCurrentLanguage(), .CampaignID = hdfCampaignID.Value, .PaginationSetNumber = paginationSetNumber}

            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If

            Session(SESSION_MONITORING_SESSIONS) = VeterinaryAPIService.GetMonitoringSessionListAsync(parameters).Result
            gvMonitoringSessions.DataSource = Nothing
            BindMonitoringSessionsGridView()
            FillMonitoringSessionsPager(hdfMonitoringSessionCount.Value, pageIndex)
            ViewState(MONITORING_SESSIONS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindMonitoringSessionsGridView()

        Dim list = CType(Session(SESSION_MONITORING_SESSIONS), List(Of VctMonitoringSessionGetListModel))

        If (Not ViewState(MONITORING_SESSIONS_SORT_EXPRESSION) Is Nothing) Then
            If ViewState(MONITORING_SESSIONS_SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(MONITORING_SESSIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(MONITORING_SESSIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvMonitoringSessions.DataSource = list
        gvMonitoringSessions.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillMonitoringSessionsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divMonitoringSessionsPager.Visible = True

            'Calculate the start and end index of pages to be displayed.
            Dim dblPageCount As Double = recordCount / Convert.ToDecimal(10)
            Dim pageCount As Integer = Math.Ceiling(dblPageCount)
            startIndex = If(currentPage > 1 AndAlso currentPage + pagerSpan - 1 < pagerSpan, currentPage, 1)
            endIndex = If(pageCount > pagerSpan, pagerSpan, pageCount)
            If currentPage > pagerSpan Mod 2 Then
                If currentPage = 2 Then
                    endIndex = 5
                Else
                    endIndex = currentPage + 2
                End If
            Else
                endIndex = (pagerSpan - currentPage) + 1
            End If

            If endIndex - (pagerSpan - 1) > startIndex Then
                startIndex = endIndex - (pagerSpan - 1)
            End If

            If endIndex > pageCount Then
                endIndex = pageCount
                startIndex = If(((endIndex - pagerSpan) + 1) > 0, (endIndex - pagerSpan) + 1, 1)
            End If

            'Add the First Page Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptMonitoringSessionsPager.DataSource = pages
            rptMonitoringSessionsPager.DataBind()
            divMonitoringSessionsPager.Visible = True
        Else
            divMonitoringSessionsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub MonitoringSessionsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            lblMonitoringSessionsPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer
            paginationSetNumber = Math.Ceiling(pageIndex / gvMonitoringSessions.PageSize)

            If Not ViewState(MONITORING_SESSIONS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvMonitoringSessions.PageIndex = gvCampaigns.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvMonitoringSessions.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvMonitoringSessions.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvMonitoringSessions.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvMonitoringSessions.PageIndex = gvCampaigns.PageSize - 1
                        Else
                            gvMonitoringSessions.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillMonitoringSessions(pageIndex:=pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvMonitoringSessions.PageIndex = gvCampaigns.PageSize - 1
                Else
                    gvMonitoringSessions.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindMonitoringSessionsGridView()
                FillMonitoringSessionsPager(hdfSearchCount.Value, pageIndex)
            End If
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
    Protected Sub MonitoringSessions_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvMonitoringSessions.Sorting

        Try
            ViewState(MONITORING_SESSIONS_SORT_DIRECTION) = IIf(ViewState(MONITORING_SESSIONS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(MONITORING_SESSIONS_SORT_EXPRESSION) = e.SortExpression

            BindMonitoringSessionsGridView()
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
    Protected Sub MonitoringSessions_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvMonitoringSessions.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteMonitoringSession(e.CommandArgument)
                Case GridViewCommandConstants.SelectCommand
                    e.Handled = True
                    SelectMonitoringSession(e.CommandArgument)
            End Select
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessionID"></param>
    Private Sub DeleteMonitoringSession(monitoringSessionID As Long)

        Try
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            Dim returnResults As List(Of VctMonitoringSessionDelModel) = VeterinaryAPIService.DeleteMonitoringSessionAsync(GetCurrentLanguage(), monitoringSessionID).Result

            If returnResults.Count = 0 Then
                ShowErrorMessage(messageType:=MessageType.CannotDelete)
            Else
                Select Case returnResults.FirstOrDefault().ReturnCode
                    Case 0
                        ShowSuccessMessage(messageType:=MessageType.DeleteSuccess)
                    Case 1
                        ShowWarningMessage(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Child_Objects_Message)
                    Case 2
                        ShowWarningMessage(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Another_Object_Message)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessionID"></param>
    Private Sub SelectMonitoringSession(monitoringSessionID As Long)

        ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignSelectMonitoringSession
        ViewState(CALLER_KEY) = monitoringSessionID
        SaveEIDSSViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.VeterinaryActiveSurveillanceMonitoringSessionURL), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub SearchMonitoringSessions_Click(sender As Object, e As EventArgs) Handles btnSearchMonitoringSessions.Click

        Try
            ucSearchVeterinarySession.Setup(selectMode:=SelectModes.RecordDataSelection)
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchVeterinarySessionModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSession"></param>
    Protected Sub SearchVeterinarySessionUserControl_SelectVeterinarySession(monitoringSession As VctMonitoringSessionGetListModel) Handles ucSearchVeterinarySession.SelectVeterinarySessionRecordData

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Dim matchIndicator As Boolean = False
            Dim speciesToSampleTypeCombinationMatchIndicator = True

            If monitoringSession.StartDate >= txtCampaignStartDate.Text And monitoringSession.StartDate <= txtCampaignEndDate.Text Then
                If monitoringSession.EndDate <= txtCampaignEndDate.Text And monitoringSession.EndDate >= txtCampaignStartDate.Text Then
                    If ddlDiseaseID.SelectedValue = monitoringSession.DiseaseID Then
                        'Get the monitoring session's species to sample type combinations.
                        If VeterinaryAPIService Is Nothing Then
                            VeterinaryAPIService = New VeterinaryServiceClient()
                        End If

                        Dim monitoringSessionSpeciesToSampleTypeCombinations = VeterinaryAPIService.GetMonitoringSessionSpeciesToSampleTypeListAsync(GetCurrentLanguage(), monitoringSession.VeterinaryMonitoringSessionID).Result
                        Dim campaignSpeciesToSampleTypeCombinations = CType(Session(SESSION_SPECIES_TO_SAMPLE_TYPES), List(Of VctCampaignSpeciesToSampleTypeGetListModel))

                        If campaignSpeciesToSampleTypeCombinations Is Nothing Then
                            campaignSpeciesToSampleTypeCombinations = New List(Of VctCampaignSpeciesToSampleTypeGetListModel)()
                        End If

                        For Each combination In monitoringSessionSpeciesToSampleTypeCombinations
                            If campaignSpeciesToSampleTypeCombinations.Where(Function(x) x.SpeciesTypeID = combination.SpeciesTypeID And x.SampleTypeID = combination.SampleTypeID).Count = 0 Then
                                speciesToSampleTypeCombinationMatchIndicator = False
                                Exit For
                            End If
                        Next

                        If speciesToSampleTypeCombinationMatchIndicator = True Then
                            If monitoringSession.CampaignID Is Nothing Then
                                'Monitoring session passes business rules, add it to the campaign.
                                matchIndicator = True

                                Dim monitoringSessions = CType(Session(SESSION_MONITORING_SESSIONS), List(Of VctMonitoringSessionGetListModel))
                                If monitoringSessions Is Nothing Then
                                    monitoringSessions = New List(Of VctMonitoringSessionGetListModel)()
                                End If

                                monitoringSessions.Add(monitoringSession)

                                Session(SESSION_MONITORING_SESSIONS) = monitoringSessions
                                hdfMonitoringSessionCount.Value += 1
                                BindMonitoringSessionsGridView()
                                FillMonitoringSessionsPager(hdfMonitoringSessionCount.Value, 1)

                                upAddUpdateCampaign.Update()

                                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchVeterinarySessionModal"), True)
                            End If
                        End If
                    End If
                End If
            End If

            If matchIndicator = False Then
                ShowWarningMessage(messageType:=MessageType.CannotSelectVeterinaryMonitoringSessionForCampaign, isConfirm:=False)
            End If
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
    ''' <param name="isConfirm"></param>
    Protected Sub SearchVeterinarySessionUserControl_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchVeterinarySession.ShowWarningModal

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            ShowWarningMessage(messageType, isConfirm)
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
    Private Sub AddMonitoringSession_Click(sender As Object, e As EventArgs) Handles btnAddMonitoringSession.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            ViewState(CALLER_KEY) = hdfCampaignID.Value
            ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignNewMonitoringSession

            SaveEIDSSViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.VeterinaryActiveSurveillanceMonitoringSessionURL), True)
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

#End Region

End Class