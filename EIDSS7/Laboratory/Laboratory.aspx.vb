Imports System.Globalization
Imports System.Reflection
Imports EIDSS
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports Newtonsoft.Json
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' 
''' Use Cases: LUC01, LUC02, LUC03, LUC04, LUC05, LUC06, LUC07, LUC08, LUC09, LUC10, LUC11, LUC12, LUC13, LUC14, 
''' LUC15, LUC16, LUC17, LUC18, LUC19, and LUC21.
''' 
''' This is the primary landing page and "controller" for most laboratory module use cases. It includes the 
''' navigational tab control for samples, testing, transferred, favorites, batches and approval tab items.
''' 
''' </summary>
Public Class Laboratory
    Inherits BaseEidssPage

#Region "Global Values"

    'CSS Constants
    Private Const CSS_BTN_GLYPHICON_CHECKED As String = "btn glyphicon glyphicon-check selectButton"
    Private Const CSS_BTN_GLYPHICON_UNCHECKED As String = "btn glyphicon glyphicon-unchecked selectButton"
    Private Const CSS_UNACCESSIONED As String = "unaccessioned"
    Private Const CSS_UNACCESSIONED_SAVE_PENDING As String = "unaccessionedSavePending"
    Private Const CSS_NO_SAVE_PENDING As String = "noSavePending"
    Private Const CSS_SAVE_PENDING As String = "savePending"
    Private Const CSS_MY_FAVORITE As String = "myFavorite"
    Private Const CSS_MY_FAVORITE_NO As String = "myFavoriteNo"

    'Sections/Panels Constants
    Private Const SampleTestDetailsAccordion As String = "Sample/Test Details Accordion"

    'Session Constants
    Private Const SESSION_SAMPLES_LIST As String = "gvSamples_List"
    Private Const SESSION_SAMPLES_SAVE_LIST As String = "gvSamples_Save"
    Private Const SESSION_SAMPLES_FILTER_LIST As String = "gvSamples_Filter"
    Private Const SESSION_GROUP_ACCESSION_SAMPLES As String = "ucGroupAccessionIn_Samples"
    Private Const SESSION_GROUP_ACCESSION_SELECT_SAMPLES As String = "gvGroupAccessionInSelectSamples_List"
    Private Const SESSION_GROUP_ACCESSION_SELECT_SAMPLES_SAVE As String = "gvGroupAccessionInSelectSamples_Save"
    Private Const SESSION_FAVORITES_LIST As String = "gvMyFavorites_List"
    Private Const SESSION_TESTING_LIST As String = "gvTesting_List"
    Private Const SESSION_TESTING_SAVE_LIST As String = "gvTesting_Save"
    Private Const SESSION_TRANSFERRED_LIST As String = "gvTransferred_List"
    Private Const SESSION_TRANSFERRED_SAVE_LIST As String = "gvTransferred_Save"
    Private Const SESSION_BATCHES_LIST As String = "gvBatches_List"
    Private Const SESSION_BATCHES_SAVE_LIST As String = "gvBatches_Save"
    Private Const SESSION_BATCH_TESTS_LIST As String = "gvBatchTests_List"
    Private Const SESSION_BATCH_TESTS_SAVE_LIST As String = "gvBatchTests_Save"
    Private Const SESSION_BATCH_SELECT_SAMPLES As String = "gvBatchSelectSamples_List"
    Private Const SESSION_BATCH_SELECT_SAMPLES_SAVE As String = "gvBatchSelectSamples_Save"
    Private Const SESSION_APPROVALS_LIST As String = "gvApprovals_List"
    Private Const SESSION_APPROVALS_SAVE_LIST As String = "gvApprovals_Save"
    Private Const SESSION_TEST_AMENDMENTS_LIST As String = "gvTestAmendements_List"
    Private Const SESSION_NOTIFICATIONS_SAVE_LIST As String = "labPagNotifications_Save"
    Private Const SESSION_SAMPLES_TO_DELETE_LIST As String = "gvSamplesToDelete_List"
    Private Const SESSION_TESTS_TO_DELETE_LIST As String = "gvTestsToDelete_List"
    Private Const SESSION_FREEZER_BOX_LOCATION_AVAILABILITY_SAVE_LIST As String = "freezerBoxLocationAvailability_Save"

    Private Const SESSION_ACCESSION_CONDITION_TYPES_DROP_DOWN As String = "AccessionConditionType_DDL"
    Private Const SESSION_ACCESSION_IN_DROP_DOWN As String = "AccessionIn_DDL"
    Private Const SESSION_ADD_GROUP_RESULT_DROP_DOWN As String = "AddGroupResult_DDL"
    Private Const SESSION_TEST_RESULT_TYPES_DROP_DOWN As String = "TestResultType_DDL"
    Private Const SESSION_TEST_STATUS_TYPES_DROP_DOWN As String = "TestStatusType_DDL"
    Private Const SESSION_TEST_CATEGORY_TYPES_DROP_DOWN As String = "TestCategoryType_DDL"
    Private Const SESSION_FUNCTIONAL_AREA_DROP_DOWN As String = "FunctionalArea_DDL"

    'Grid View Sorting and Pagination Constants
    Private Const SAMPLES_SORT_DIRECTION As String = "gvSamples_SortDirection"
    Private Const SAMPLES_SORT_EXPRESSION As String = "gvSamples_SortExpression"
    Private Const SAMPLES_PAGINATION_SET_NUMBER As String = "gvSamples_PaginationSet"
    Private Const TESTING_SORT_DIRECTION As String = "gvTesting_SortDirection"
    Private Const TESTING_SORT_EXPRESSION As String = "gvTesting_SortExpression"
    Private Const TESTING_PAGINATION_SET_NUMBER As String = "gvTesting_PaginationSet"
    Private Const TRANSFERRED_SORT_DIRECTION As String = "gvTransferred_SortDirection"
    Private Const TRANSFERRED_SORT_EXPRESSION As String = "gvTransferred_SortExpression"
    Private Const TRANSFERRED_PAGINATION_SET_NUMBER As String = "gvTransferred_PaginationSet"
    Private Const MY_FAVORITES_SORT_DIRECTION As String = "gvMyFavorites_SortDirection"
    Private Const MY_FAVORITES_SORT_EXPRESSION As String = "gvMyFavorites_SortExpression"
    Private Const MY_FAVORITES_PAGINATION_SET_NUMBER As String = "gvMyFavorites_PaginationSet"
    Private Const BATCHES_SORT_DIRECTION As String = "gvBatches_SortDirection"
    Private Const BATCHES_SORT_EXPRESSION As String = "gvBatches_SortExpression"
    Private Const BATCHES_PAGINATION_SET_NUMBER As String = "gvBatches_PaginationSet"
    Private Const APPROVALS_SORT_DIRECTION As String = "gvApprovals_SortDirection"
    Private Const APPROVALS_SORT_EXPRESSION As String = "gvApprovals_SortExpression"
    Private Const APPROVALS_PAGINATION_SET_NUMBER As String = "gvApprovals_PaginationSet"
    Private Const GROUP_ACCESSION_IN_SELECT_SAMPLES_PAGINATION_SET_NUMBER As String = "gvGroupAccessionInSelectSamples_PaginationSet"
    Private Const BATCH_SELECT_SAMPLES_PAGINATION_SET_NUMBER As String = "gvBatchSelectSamples_PaginationSet"

    'Client Side Script Constants
    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"
    Private Const POPOVER_KEY As String = "Popover"
    Private Const PAGE_KEY As String = "Page"
    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"
    Private Const STICKY_COLUMNS_SCRIPT As String = "stickyColumns();"
    Private Const SET_ACTIVE_TAB_ITEM_SCRIPT As String = "setActiveTabItem();"
    Private Const SHOW_EDIT_SAMPLE_SAMPLES_MODAL As String = "showSampleTestDetails('Sample');"
    Private Const SHOW_EDIT_TEST_MODAL As String = "showSampleTestDetails('Test');"
    Private Const SHOW_EDIT_TRANSFER_MODAL As String = "showSampleTestDetails('Transfer');"
    Private Const SHOW_SEARCH_RESULTS As String = "showSearchResults();"
    Private Const RESET_SEARCH As String = "resetSearch();"
    Private Const POPOVER_SCRIPT As String = "popOver();"
    Private Const SHOW_ACCESSION_IN_POPOVER_SCRIPT As String = "accessionIn();"
    Private Const SHOW_ADD_GROUP_RESULT_POPOVER_SCRIPT As String = "addGroupResult();"
    Private Const ACCESSION_COMMENT_POPOVER_SCRIPT As String = "accessionCommentPopOver();"
    Private Const ACCESSION_COMMENT_WITH_COMMENT_POPOVER_SCRIPT As String = "accessionCommentWithCommentPopOver();"
    Private Const TAB_CHANGED_EVENT As String = "TabChanged"
    Private Const EDIT_BATCH_EVENT As String = "EditBatch"

    Public Event TabItemSelected(tab As String)

    'API Clients
    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient

    'Logging
    Private Shared Log = log4net.LogManager.GetLogger(GetType(Laboratory))

    'Tab Grid View Row Drop Downs
    Private ddlAccessionConditionTypes As DropDownList = New DropDownList()
    Private ddlFunctionalAreas As DropDownList = New DropDownList()
    Private ddlTestCategoryTypes As DropDownList = New DropDownList()
    Private ddlTestResultTypes As DropDownList = New DropDownList()
    Private ddlTestStatusTypes As DropDownList = New DropDownList()

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If (Not IsPostBack) Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If

                If LaboratoryAPIService Is Nothing Then
                    LaboratoryAPIService = New LaboratoryServiceClient()
                End If

                CheckCallerHandler()
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")

                Select Case eventArg.ToString()
                    Case TAB_CHANGED_EVENT
                        RaiseEvent TabItemSelected(eventSource)
                    Case EDIT_BATCH_EVENT
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditBatch.ToString()
                        InitializeControl(LaboratoryModuleTabConstants.Batches, batchTestID:=CType(eventSource, Long))
                End Select
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

        Try
            hdfCurrentModuleAction.Value = Request.QueryString("ActionRequested")

            gvSamples.PageSize = ConfigurationManager.AppSettings("PageSize")
            gvTesting.PageSize = ConfigurationManager.AppSettings("PageSize")
            gvTransferred.PageSize = ConfigurationManager.AppSettings("PageSize")
            gvMyFavorites.PageSize = ConfigurationManager.AppSettings("PageSize")
            gvBatches.PageSize = ConfigurationManager.AppSettings("PageSize")
            gvApprovals.PageSize = ConfigurationManager.AppSettings("PageSize")

            gvGroupAccessionInSelectSamples.PageSize = ConfigurationManager.AppSettings("PageSize")

            GetUserProfile()

            FillDropDowns()

            hdgSamplesQueryText.Visible = False
            hdgSamplesSearchResults.Visible = False
            hdgTestingQueryText.Visible = False
            hdgTestingSearchResults.Visible = False
            hdgTransferredQueryText.Visible = False
            hdgTransferredSearchResults.Visible = False
            hdgMyFavoritesQueryText.Visible = False
            hdgMyFavoritesSearchResults.Visible = False
            hdgBatchesSearchResults.Visible = False
            hdgBatchesQueryText.Visible = False
            hdgApprovalsQueryText.Visible = False
            hdgApprovalsSearchResults.Visible = False
            btnTestingAssignTest.Enabled = False
            btnTestingBatch.Enabled = False
            btnMyFavoritesBatch.Disabled = True
            btnMyFavoritesAssignTest.Enabled = False
            btnBatchesRemoveSample.Enabled = False
            btnAddGroupResult.Disabled = True
            btnCloseBatch.Enabled = False
            hdgApprovalsSearchResults.Visible = False
            hdgApprovalsQueryText.Visible = False

            SetTabControl()

            ExtractViewStateSession()
            GetSearchFields({divHiddenFieldsSection}, CreateTempFile(GlobalConstants.UserSettingsFilePrefix))

            Session(SESSION_TEST_AMENDMENTS_LIST) = New List(Of TestAmendmentParameters)()
            Session(SESSION_NOTIFICATIONS_SAVE_LIST) = New List(Of NotificationSetParameters)()

            ucSamplesSearch.Setup(hdfUserID.Value)
            ucTestingSearch.Setup(hdfUserID.Value)
            ucTransferredSearch.Setup(hdfUserID.Value)
            ucMyFavoritesSearch.Setup(hdfUserID.Value)
            ucBatchesSearch.Setup(hdfUserID.Value)
            ucApprovalsSearch.Setup(hdfUserID.Value)

            upLaboratoryTabCounts.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SetTabControl()

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            FillTabCounts()

            hdfCurrentTab.Value = Request.QueryString("Tab")

            Select Case hdfCurrentTab.Value
                Case LaboratoryModuleTabConstants.Approvals
                    FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
                    lblApprovalsPageNumber.Text = 1
                    BindApprovalsGridView()
                    upApprovals.Update()
                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    BindMyFavoritesGridView()
                    upMyFavorites.Update()
                Case LaboratoryModuleTabConstants.Batches
                    FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
                    lblBatchesPageNumber.Text = 1
                    BindBatchesGridView()
                    upBatches.Update()
                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    BindMyFavoritesGridView()
                    upMyFavorites.Update()
                Case LaboratoryModuleTabConstants.MyFavorites
                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    lblMyFavoritesPageNumber.Text = 1
                    BindMyFavoritesGridView()
                    upMyFavorites.Update()
                Case LaboratoryModuleTabConstants.Samples
                    FillSamplesList(pageIndex:=1, paginationSetNumber:=1)
                    lblSamplesPageNumber.Text = 1
                    BindSamplesGridView()
                    upSamples.Update()
                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    BindMyFavoritesGridView()
                    upMyFavorites.Update()
                Case LaboratoryModuleTabConstants.Testing
                    FillTestingList(pageIndex:=1, paginationSetNumber:=1)
                    lblTestingPageNumber.Text = 1
                    BindTestingGridView()
                    upTesting.Update()
                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    BindMyFavoritesGridView()
                    upMyFavorites.Update()
                Case LaboratoryModuleTabConstants.Transferred
                    FillTransferredList(pageIndex:=1, paginationSetNumber:=1)
                    lblTransferredPageNumber.Text = 1
                    BindTransferredGridView()
                    upTransferred.Update()
                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    BindMyFavoritesGridView()
                    upMyFavorites.Update()
                Case Else
                    hdfCurrentTab.Value = LaboratoryModuleTabConstants.Samples.ToString()
                    FillSamplesList(pageIndex:=1, paginationSetNumber:=1)
                    lblSamplesPageNumber.Text = 1
                    BindSamplesGridView()
                    upSamples.Update()
                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    BindMyFavoritesGridView()
                    upMyFavorites.Update()
            End Select

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)

            lblMyFavoritesPageNumber.Text = 1
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

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

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        hdfUserID.Value = Session("UserID")
        hdfSiteID.Value = Session("UserSite")
        hdfPersonID.Value = Session("Person")
        hdfOrganizationID.Value = Session("Institution")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="section"></param>
    Private Sub ToggleVisibility(ByVal section As String)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="root"></param>
    ''' <param name="id"></param>
    ''' <returns></returns>
    Public Shared Function FindControlRecursive(root As Control, id As String) As Control

        If root.ID = id Then
            Return root
        End If

        Return root.Controls.Cast(Of Control)().[Select](Function(c) FindControlRecursive(c, id)).FirstOrDefault(Function(c) c IsNot Nothing)

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Laboratory_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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
    ''' <returns></returns>
    Private Function GetErrorMessages(validationGroup As String) As String

        Dim message As String = String.Empty

        Page.Validate(validationGroup)
        For i = 0 To Page.Validators.Count() - 1
            If Page.Validators(i).IsValid = False Then
                message = message & Page.Validators(i).ErrorMessage & vbLf
            End If

            i += 1
        Next

        Return message

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dTable"></param>
    ''' <param name="colName"></param>
    ''' <returns></returns>
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ModalSuccessOK_Click(sender As Object, e As EventArgs) Handles btnModalSuccessOK.Click

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, "hideModal('#divSuccessModal');", True)

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
            Case MessageType.CannotAddUpdate
                warningSubTitle.InnerText = GetLocalResourceObject("Warning_Message_Cannot_Save_SubHeading")
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Cannot_Save_Body_Text")
            Case MessageType.CannotDelete
                divWarningBody.InnerText = message
            Case MessageType.CancelConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelConfirmAddUpdate
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Add_Update_Confirm
                'Save for the user confirmation to continue saving the person or go back to review and potentially cancel the add.
                hdfCurrentModuleAction.Value = MessageType.CancelConfirmAddUpdate.ToString()
            Case MessageType.CannotGroupAccession
                divWarningBody.InnerText = message
            Case MessageType.CannotAssignTest
                divWarningBody.InnerText = message
            Case MessageType.CannotTransferOut
                divWarningBody.InnerHtml = message
            Case MessageType.CannotSetTestResult
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Test_Must_Be_Selected_Body_Text")
            Case MessageType.CancelSearchConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case MessageType.CancelSearchPersonConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case MessageType.CannotGetValidatorSection
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Validator_Section_Body_Text")
            Case MessageType.SearchCriteriaRequired
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Search_Criteria_Required_Body_Text")
            Case MessageType.UnhandledException
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Unhandled_Exception_Body_Text")
            Case MessageType.NoSampleSelectedForSampleDestruction
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_No_Sample_Selected_For_Sample_Destruction_Body_Text")
            Case MessageType.NoSampleSelectedForSampleDeletion
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_No_Sample_Selected_For_Sample_Deletion_Body_Text")
            Case MessageType.NoSamplesToAccession
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_No_Samples_To_Accession_Body_Text")
            Case MessageType.NoTestSelectedForTestDeletion
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_No_Test_Selected_For_Test_Deletion_Body_Text")
            Case MessageType.NoSamplesToPrintBarCodes
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_No_Samples_To_Print_Bar_Codes_Text")
            Case MessageType.PrintBarcodes
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Print_Bar_Codes_Body_Text")
                'Save for the user confirmation to continue saving the person or go back to review and potentially cancel the add.
                hdfCurrentModuleAction.Value = MessageType.PrintBarcodes.ToString()
            Case MessageType.DuplicateHuman
                divWarningBody.InnerText = message
                'Save for the user confirmation to continue saving the person or go back to review and potentially cancel the add.
                hdfCurrentModuleAction.Value = MessageType.DuplicateHuman.ToString()
            Case MessageType.ReportSessionNotFound
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Report_Session_Not_Found_Body_Text")
        End Select

        If isConfirm Then
            divWarningYesNo.Visible = True
            divWarningOK.Visible = False
        Else
            divWarningOK.Visible = True
            divWarningYesNo.Visible = False
        End If

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
            Select Case hdfCurrentModuleAction.Value
                Case ucSearchHumanDiseaseReport.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchHumanDiseaseReportModal"), True)
                Case ucSearchHumanSession.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchHumanSessionModal"), True)
                Case ucSearchPerson.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchPersonModal"), True)
                Case ucSearchVectorSession.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchVectorSessionModal"), True)
                Case ucSearchVeterinaryDiseaseReport.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchVeterinaryDiseaseReportModal"), True)
                Case ucSearchVeterinarySession.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchVeterinarySessionModal"), True)
                Case LaboratoryModuleActions.DeleteSample
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divDeleteSampleModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case LaboratoryModuleActions.DeleteTest
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divDeleteTestModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case ucCreateAliquotDerivative.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divCreateAliquotDerivativeModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case ucAmendTestResult.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAmendTestResultModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case ucAssignTest.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAssignTestModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case ucGroupAccessionIn.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divGroupAccessionInModal"), True)
                Case ucRegisterNewSample.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divRegisterNewSampleModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case ucAddUpdateBatchTest.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAddUpdateBatchTestModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case ucTransferSample.ID
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divTransferSampleModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case LaboratoryModuleActions.EditSample
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSampleTestDetailsModal"), True)
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
                Case LaboratoryModuleActions.AdvancedSearch
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchSampleModal"), True)
                Case MessageType.CancelConfirmAddUpdate.ToString()
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAddUpdatePersonModal"), True)
                Case MessageType.PrintBarcodes.ToString()
                    chkSamplePrintBarcodes.Checked = True
                    hdfSamplePrintBarcodes.Value = "True"
                Case MessageType.DuplicateHuman.ToString()
                    upAddUpdatePerson.Update()
                    ucAddUpdatePerson.ContinueSave()
            End Select

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
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
            hdfCurrentModuleAction.Value = LaboratoryModuleActions.None

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

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
            Case MessageType.CannotEditSample
                divErrorBody.InnerText = GetLocalResourceObject("Err_Edit_Sample")
            Case MessageType.CannotEditTest
                errorSubTitle.InnerHtml = GetLocalResourceObject("Err_Edit_Test")
                divErrorBody.InnerHtml = message
            Case MessageType.CannotSaveSampleTestDetails
                errorSubTitle.InnerHtml = GetLocalResourceObject("Err_Save_Sample_Test")
                divErrorBody.InnerHtml = message
            Case MessageType.CannotAccession
                errorSubTitle.InnerText = GetLocalResourceObject("Err_Accession_Sample")
                divErrorBody.InnerHtml = message
            Case MessageType.CannotGroupAccession
                divErrorBody.InnerText = GetLocalResourceObject("Err_Group_Accession")
            Case MessageType.CannotRegisterNewSample
                divErrorBody.InnerText = GetLocalResourceObject("Err_Register_New_Sample")
            Case MessageType.SampleMustBeAccessioned
                divErrorBody.InnerText = GetLocalResourceObject("Err_Message_Sample_Must_Be_Accessioned")
            Case MessageType.CannotDeleteSample
                errorSubTitle.InnerText = GetLocalResourceObject("Err_Delete_Sample")
                divErrorBody.InnerHtml = message
            Case MessageType.TestMustBePreliminaryOrInProgressStatus
                divErrorBody.InnerText = GetLocalResourceObject("Err_Message_Test_Must_Have_Preliminary_In_Progress_Test")
            Case MessageType.CannotAssignTest
                divErrorBody.InnerText = GetLocalResourceObject("Error_Message_Cannot_Assign_Test")
            Case MessageType.CannotCloseBatch
                divErrorBody.InnerText = GetLocalResourceObject("Err_Message_Test_Must_Have_Result_Text")
            Case MessageType.CannotAddUpdate
                divErrorBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case MessageType.UnhandledException
                divErrorBody.InnerText = Resources.WarningMessages.Unhandled_Exception
        End Select

        upErrorModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "function showErrorModal() { $('#divErrorModal').modal('show'); }", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType)

        Select Case messageType
            Case MessageType.DeleteSuccess
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Message_Delete_Success")
            Case MessageType.AddUpdateSuccess
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Message_Add_Update_Success")
            Case MessageType.RegisterNewSampleSuccess
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Register_New_Sample_Success_Text")
        End Select

        upSuccessModal.Update()

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tab"></param>
    ''' <param name="sampleID"></param>
    ''' <param name="testID"></param>
    ''' <param name="transferID"></param>
    ''' <param name="batchTestID"></param>
    Private Sub InitializeControl(tab As String, Optional sampleID As Long? = Nothing, Optional testID As Long? = Nothing, Optional transferID As Long? = Nothing, Optional batchTestID As Long? = Nothing)

        Try
            Select Case hdfCurrentModuleAction.Value
                Case LaboratoryModuleActions.AccessionIn.ToString()
                    AccessionIn()
                Case LaboratoryModuleActions.AssignTest.ToString()
                    Select Case tab
                        Case LaboratoryModuleTabConstants.Samples.ToString()
                            InitializeAssignTests(tab:=LaboratoryModuleTabConstants.Samples)
                        Case LaboratoryModuleTabConstants.Testing.ToString()
                            InitializeAssignTests(tab:=LaboratoryModuleTabConstants.Testing)
                        Case LaboratoryModuleTabConstants.Transferred.ToString()
                            InitializeAssignTests(tab:=LaboratoryModuleTabConstants.Transferred)
                        Case LaboratoryModuleTabConstants.MyFavorites.ToString()
                            InitializeAssignTests(tab:=LaboratoryModuleTabConstants.MyFavorites)
                    End Select
                Case LaboratoryModuleActions.AmendTestResult.ToString()
                    InitializeAmendTestResult()
                Case LaboratoryModuleActions.GroupAccessionIn.ToString()
                    InitializeGroupAccessionIn()
                Case LaboratoryModuleActions.CreateAliquot.ToString()
                    InitializeAliquot()
                Case LaboratoryModuleActions.CreateDerivative.ToString()
                    InitializeDerivative()
                Case LaboratoryModuleActions.Reference.ToString()
                    InitializeReference()
                Case LaboratoryModuleActions.RegisterNewSample.ToString()
                    InitializeRegisterNewSample()
                Case LaboratoryModuleActions.EditSample.ToString()
                    InitializeEditSample(sampleID:=sampleID)
                Case LaboratoryModuleActions.EditTest.ToString()
                    InitializeEditTest(testID:=testID, batchTestID:=batchTestID)
                Case LaboratoryModuleActions.EditTransfer.ToString()
                    InitializeEditTransfer(transferID:=transferID, testID:=testID)
                Case LaboratoryModuleActions.EditBatch.ToString()
                    InitializeEditBatch(batchTestID:=batchTestID)
                Case LaboratoryModuleActions.SearchPerson.ToString()
                Case LaboratoryModuleActions.TransferOut.ToString()
                    InitializeTransferOut()
                Case LaboratoryModuleActions.SetTestResultsForSample.ToString()
                    InitializeEditSample(sampleID:=sampleID)
                Case LaboratoryModuleActions.SetTestResultsForTest.ToString()
                    InitializeEditTest(testID:=testID)
                Case LaboratoryModuleActions.DestroyByAutoclave.ToString()
                    SampleDestruction(destructionMethodTypeID:=DestructionMethodTypes.Autoclave)
                Case LaboratoryModuleActions.DestroyByIncineration.ToString()
                    SampleDestruction(destructionMethodTypeID:=DestructionMethodTypes.Incineration)
                Case LaboratoryModuleActions.DeleteSample.ToString()
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.DeleteSample
                    SampleDeletion()
                Case LaboratoryModuleActions.RestoreSample.ToString()
                    SetRestoreSample()
                Case LaboratoryModuleActions.DeleteTest.ToString()
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.DeleteTest
                    TestDeletion()
                Case LaboratoryModuleActions.PrintBarcode.ToString()
                    InitializePrintBarCode(tab)
                Case LaboratoryModuleActions.ApproveDeletion.ToString()
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.ApproveDeletion
                    Approve()
                Case LaboratoryModuleActions.ApproveDestruction.ToString()
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.ApproveDestruction
                    Approve()
                Case LaboratoryModuleActions.RejectDeletion.ToString()
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.RejectDeletion
                    Reject()
                Case LaboratoryModuleActions.RejectDestruction.ToString()
                    hdfCurrentModuleAction.Value = LaboratoryModuleActions.RejectDestruction
                    Reject()
                Case LaboratoryModuleActions.SampleReport.ToString()
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleReportModal"), True)
                Case LaboratoryModuleActions.TestReport.ToString()
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTestResultReportModal"), True)
                Case LaboratoryModuleActions.TransferReport.ToString()
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTransferReportModal"), True)
                Case LaboratoryModuleActions.AccessionInForm.ToString()
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAccessionInFormModal"), True)
                Case LaboratoryModuleActions.DestructionReport.ToString()
                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divDestructionReportModal"), True)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        If Session(SESSION_ACCESSION_CONDITION_TYPES_DROP_DOWN) Is Nothing Then
            FillBaseReferenceDropDownList(ddlAccessionConditionTypes, BaseReferenceConstants.AccessionCondition, HACodeList.AllHACode, True)
            Session(SESSION_ACCESSION_CONDITION_TYPES_DROP_DOWN) = ddlAccessionConditionTypes
            FillBaseReferenceDropDownList(ddlAccessionIn, BaseReferenceConstants.AccessionCondition, HACodeList.AllHACode, True)
            Session(SESSION_ACCESSION_IN_DROP_DOWN) = ddlAccessionIn
        Else
            ddlAccessionConditionTypes = Session(SESSION_ACCESSION_CONDITION_TYPES_DROP_DOWN)
            ddlAccessionIn = Session(SESSION_ACCESSION_IN_DROP_DOWN)
        End If

        If Session(SESSION_TEST_CATEGORY_TYPES_DROP_DOWN) Is Nothing Then
            FillBaseReferenceDropDownList(ddlTestCategoryTypes, BaseReferenceConstants.TestCategory, HACodeList.AllHACode, True)
            Session(SESSION_TEST_CATEGORY_TYPES_DROP_DOWN) = ddlTestCategoryTypes
        Else
            ddlTestCategoryTypes = Session(SESSION_TEST_CATEGORY_TYPES_DROP_DOWN)
        End If

        If Session(SESSION_TEST_RESULT_TYPES_DROP_DOWN) Is Nothing Then
            FillBaseReferenceDropDownList(ddlTestResultTypes, BaseReferenceConstants.TestResult, HACodeList.AllHACode, True)
            Session(SESSION_TEST_RESULT_TYPES_DROP_DOWN) = ddlTestResultTypes

            FillBaseReferenceDropDownList(ddlAddGroupResultTestResultType, BaseReferenceConstants.TestResult, HACodeList.AllHACode, True)
            Session(SESSION_ADD_GROUP_RESULT_DROP_DOWN) = ddlAddGroupResultTestResultType
        Else
            ddlTestResultTypes = Session(SESSION_TEST_RESULT_TYPES_DROP_DOWN)
            ddlAddGroupResultTestResultType = Session(SESSION_ADD_GROUP_RESULT_DROP_DOWN)
        End If

        If Session(SESSION_TEST_STATUS_TYPES_DROP_DOWN) Is Nothing Then
            FillBaseReferenceDropDownList(ddlTestStatusTypes, BaseReferenceConstants.TestStatus, HACodeList.AllHACode, True)
            Session(SESSION_TEST_STATUS_TYPES_DROP_DOWN) = ddlTestStatusTypes
        Else
            ddlTestStatusTypes = Session(SESSION_TEST_STATUS_TYPES_DROP_DOWN)
        End If

        'Removed by business rule in use case LUC04.  User may only use in progress and preliminary.
        Dim item As ListItem = ddlTestStatusTypes.Items.FindByValue(TestStatusTypes.Amended)
        ddlTestStatusTypes.Items.Remove(item)
        item = ddlTestStatusTypes.Items.FindByValue(TestStatusTypes.Declined)
        ddlTestStatusTypes.Items.Remove(item)
        item = ddlTestStatusTypes.Items.FindByValue(TestStatusTypes.Deleted)
        ddlTestStatusTypes.Items.Remove(item)
        item = ddlTestStatusTypes.Items.FindByValue(TestStatusTypes.Final)
        ddlTestStatusTypes.Items.Remove(item)
        item = ddlTestStatusTypes.Items.FindByValue(TestStatusTypes.MarkedForDeletion)
        ddlTestStatusTypes.Items.Remove(item)
        item = ddlTestStatusTypes.Items.FindByValue(TestStatusTypes.NotStarted)
        ddlTestStatusTypes.Items.Remove(item)

        If Session(SESSION_FUNCTIONAL_AREA_DROP_DOWN) Is Nothing Then
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of GblDepartmentGetListModel) = CrossCuttingAPIService.GetDepartmentListAsync(GetCurrentLanguage(), Nothing, Nothing).Result.OrderBy(Function(x) x.DepartmentName).ToList()
            FillDropDownList(ddlFunctionalAreas, list, {GlobalConstants.NullValue}, DepartmentConstants.DepartmentId, DepartmentConstants.DepartmentName, Nothing, Nothing, True)
            Session(SESSION_FUNCTIONAL_AREA_DROP_DOWN) = ddlFunctionalAreas
        Else
            ddlFunctionalAreas = Session(SESSION_FUNCTIONAL_AREA_DROP_DOWN)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillTabCounts()

        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If

        Dim samplesParameters = New LaboratorySampleGetListParameters With {.DaysFromAccessionDate = ConfigurationManager.AppSettings("DaysFromAccessionDate"), .LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .SiteID = hdfSiteID.Value, .UserID = hdfUserID.Value}
        Dim samplesCounts = LaboratoryAPIService.LaboratorySampleGetListCountAsync(parameters:=samplesParameters).Result
        lblSamplesCount.Text = samplesCounts(0).UnaccessionedSampleCount
        hdfSamplesCount.Value = samplesCounts(0).RecordCount

        Dim testingParameters = New LaboratoryTestGetListParameters With {.TestStatusTypeID = TestStatusTypes.InProgress, .LanguageID = GetCurrentLanguage(), .SiteID = hdfSiteID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
        Dim testingCount = LaboratoryAPIService.LaboratoryTestGetListCountAsync(parameters:=testingParameters).Result
        lblTestingCount.Text = testingCount(0).RecordCount
        hdfTestingCount.Value = testingCount(0).RecordCount

        Dim transferredParameters = New LaboratoryTransferGetListParameters With {.LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
        Dim transferredCount = LaboratoryAPIService.LaboratoryTransferGetListCountAsync(parameters:=transferredParameters).Result
        lblTransferredCount.Text = transferredCount(0).RecordCount

        Dim myFavoritesCount = LaboratoryAPIService.LaboratoryFavoriteGetListCountAsync(languageID:=GetCurrentLanguage(), userID:=hdfUserID.Value).Result
        lblMyFavoritesCount.Text = myFavoritesCount(0).RecordCount

        Dim batchesParameters = New LaboratoryBatchGetListParameters With {.LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
        Dim batchesCount = LaboratoryAPIService.LaboratoryBatchGetListCountAsync(parameters:=batchesParameters).Result
        lblBatchesCount.Text = batchesCount(0).RecordCount

        Dim approvalsParameters = New LaboratoryApprovalGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SiteID = hdfSiteID.Value}
        Dim approvalsCount = LaboratoryAPIService.LaboratoryApprovalGetListCountAsync(approvalsParameters).Result
        lblApprovalsCount.Text = approvalsCount(0).RecordCount

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectAll"></param>
    ''' <param name="favoritesList"></param>
    Private Sub SetMyFavorite(selectAll As Boolean, favoritesList As List(Of LabFavoriteGetListModel))

        Try
            Dim favoriteIndicator As Integer = 0
            Dim favorites As List(Of LabFavoriteGetListModel) = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))

            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            If samples Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
            End If

            If favorites Is Nothing Then
                favorites = New List(Of LabFavoriteGetListModel)()
            End If

            Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            If tests Is Nothing Then
                tests = New List(Of LabTestGetListModel)()
            End If

            Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
            If transfers Is Nothing Then
                transfers = New List(Of LabTransferGetListModel)()
            End If

            Dim batches As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
            If batches Is Nothing Then
                batches = New List(Of LabBatchGetListModel)()
            End If

            Dim itemToRemove As LabFavoriteGetListModel

            For Each item As LabFavoriteGetListModel In favoritesList
                If favorites.Count > 0 Then
                    If favorites.Where(Function(x) x.SampleID = item.SampleID).Count > 0 Then
                        If selectAll = True Then
                            favoriteIndicator = 1
                        Else
                            favoriteIndicator = 0
                            itemToRemove = favorites.Where(Function(x) x.SampleID = item.SampleID).FirstOrDefault()
                            favorites.Remove(itemToRemove)
                        End If
                    Else
                        favoriteIndicator = 1
                        favorites.Add(item)
                    End If
                Else
                    favoriteIndicator = 1
                    favorites.Add(item)
                End If

                If samples.Count > 0 Then
                    If samples.Where(Function(x) x.SampleID = item.SampleID).Count() > 0 Then
                        With samples.Where(Function(x) x.SampleID = item.SampleID).FirstOrDefault()
                            .FavoriteIndicator = favoriteIndicator
                        End With
                    End If
                End If

                If tests.Count > 0 Then
                    If tests.Where(Function(x) x.SampleID = item.SampleID).Count() > 0 Then
                        With tests.Where(Function(x) x.SampleID = item.SampleID).FirstOrDefault()
                            .FavoriteIndicator = favoriteIndicator
                        End With
                    End If
                End If

                If transfers.Count > 0 Then
                    If transfers.Where(Function(x) x.TransferredOutSampleID = item.SampleID).Count() > 0 Then
                        With transfers.Where(Function(x) x.TransferredOutSampleID = item.SampleID).FirstOrDefault()
                            .FavoriteIndicator = favoriteIndicator
                        End With
                    End If
                End If

                If batches.Count > 0 Then
                    If batches.Where(Function(x) x.SampleID = item.SampleID).Count() > 0 Then
                        With batches.Where(Function(x) x.SampleID = item.SampleID).FirstOrDefault()
                            .FavoriteIndicator = favoriteIndicator
                        End With
                    End If
                End If

                If favorites.Count > 0 Then
                    If favorites.Where(Function(x) x.SampleID = item.SampleID).Count() > 0 Then
                        With favorites.Where(Function(x) x.SampleID = item.SampleID).FirstOrDefault()
                            .RowSelectionIndicator = 0
                        End With
                    End If
                End If
            Next

            Session(SESSION_SAMPLES_LIST) = samples
            Session(SESSION_TESTING_LIST) = tests
            Session(SESSION_TRANSFERRED_LIST) = transfers
            Session(SESSION_BATCHES_LIST) = batches
            Session(SESSION_FAVORITES_LIST) = favorites.GroupBy(Function(x) x.SampleID).Select(Function(y) y.First()).ToList

            FillDropDowns()

            BindSamplesGridView()
            BindTestingGridView()
            BindTransferredGridView()
            BindBatchesGridView()
            BindMyFavoritesGridView()
            FillMyFavoritesPager(lblMyFavoritesCount.Text, 1)

            upSamples.Update()
            upTesting.Update()
            upTransferred.Update()
            upBatches.Update()
            upLaboratoryTabCounts.Update()
            upMyFavorites.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleDetail"></param>
    ''' <returns></returns>
    Private Function ConvertSample(sampleDetail As LabSampleGetDetailModel) As LabSampleGetListModel

        Dim sampleListModel = New LabSampleGetListModel

        With sampleListModel
            .AccessionByPersonID = sampleDetail.AccessionByPersonID
            .AccessionComment = sampleDetail.AccessionComment
            .AccessionConditionTypeID = sampleDetail.AccessionConditionTypeID
            .AccessionConditionOrSampleStatusTypeName = sampleDetail.AccessionConditionOrSampleStatusTypeName
            .AccessionDate = sampleDetail.AccessionDate
            .AnimalID = sampleDetail.AnimalID
            .BirdStatusTypeID = sampleDetail.BirdStatusTypeID
            .CurrentSiteID = sampleDetail.CurrentSiteID
            .DestroyedByPersonID = sampleDetail.DestroyedByPersonID
            .DestructionDate = sampleDetail.DestructionDate
            .DestructionMethodTypeID = sampleDetail.DestructionMethodTypeID
            .DestructionMethodTypeName = sampleDetail.DestructionMethodTypeName
            .DiseaseID = sampleDetail.DiseaseIDList
            .DiseaseName = sampleDetail.DiseaseName
            .EIDSSLocalFieldSampleID = sampleDetail.EIDSSLocalFieldSampleID
            .EIDSSLaboratorySampleID = sampleDetail.EIDSSLaboratorySampleID
            .EIDSSReportSessionID = sampleDetail.EIDSSReportSessionID
            .EnteredDate = sampleDetail.EnteredDate
            .FavoriteIndicator = 0 'TODO: add favorite indicator to the sample details get method
            .CollectedByOrganizationID = sampleDetail.FieldCollectedByOrganizationID
            .CollectedByOrganizationName = sampleDetail.FieldCollectedByOrganizationName
            .CollectedByPersonID = sampleDetail.FieldCollectedByPersonID
            .CollectedByPersonName = sampleDetail.FieldCollectedByPersonName
            .CollectionDate = sampleDetail.FieldCollectionDate
            .SentDate = sampleDetail.FieldSentDate
            .SentToOrganizationID = sampleDetail.FieldSentToOrganizationID
            .SentToOrganizationName = sampleDetail.FieldSentToOrganizationName
            .FreezerSubdivisionID = sampleDetail.FreezerSubdivisionID
            .FunctionalAreaID = sampleDetail.FunctionalAreaID
            .HumanDiseaseReportID = sampleDetail.HumanDiseaseReportID
            .HumanID = sampleDetail.HumanID
            .MainTestID = sampleDetail.MainTestID
            .MarkedForDispositionByPersonID = sampleDetail.MarkedForDispositionByPersonID
            .MonitoringSessionID = sampleDetail.MonitoringSessionID
            .Note = sampleDetail.Note
            .ParentSampleID = sampleDetail.OriginalSampleID
            .ParentEIDSSLaboratorySampleID = sampleDetail.OriginalLaboratorySampleEIDSSID
            .OutOfRepositoryDate = sampleDetail.OutOfRepositoryDate
            .PatientFarmOwnerName = sampleDetail.PatientFarmOwnerName
            .PreviousSampleStatusTypeID = sampleDetail.PreviousSampleStatusTypeID
            .ReadOnlyIndicator = sampleDetail.ReadOnlyIndicator
            .ReportSessionTypeName = sampleDetail.ReportSessionTypeName
            .RootSampleID = sampleDetail.RootSampleID
            .RowSelectionIndicator = 0
            .RowStatus = sampleDetail.RowStatus
            .SampleID = sampleDetail.SampleID
            .SampleKindTypeID = sampleDetail.SampleKindTypeID
            .SampleStatusTypeID = sampleDetail.SampleStatusTypeID
            .SampleTypeID = sampleDetail.SampleTypeID
            .SampleTypeName = sampleDetail.SampleTypeName
            .SiteID = sampleDetail.SiteID
            .SpeciesID = sampleDetail.SpeciesID
            .VectorID = sampleDetail.VectorID
            .VectorSessionID = sampleDetail.VectorSessionID
            .VeterinaryDiseaseReportID = sampleDetail.VeterinaryDiseaseReportID
        End With

        Return sampleListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <returns></returns>
    Private Function ConvertSampleSearch(samples As List(Of LabSampleSearchGetListModel)) As List(Of LabSampleGetListModel)

        Dim sampleListModel = New List(Of LabSampleGetListModel)()
        Dim sample As LabSampleGetListModel

        For Each sampleSearchModel As LabSampleSearchGetListModel In samples
            sample = New LabSampleGetListModel()
            With sample
                .AccessionByPersonID = sampleSearchModel.AccessionByPersonID
                .AccessionComment = sampleSearchModel.AccessionComment
                .AccessionConditionTypeID = sampleSearchModel.AccessionConditionTypeID
                .AccessionConditionOrSampleStatusTypeName = sampleSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = sampleSearchModel.AccessionDate
                .AccessionIndicator = sampleSearchModel.AccessionIndicator
                .AnimalID = sampleSearchModel.AnimalID
                .BirdStatusTypeID = sampleSearchModel.BirdStatusTypeID
                .CurrentSiteID = sampleSearchModel.CurrentSiteID
                .DestroyedByPersonID = sampleSearchModel.DestroyedByPersonID
                .DestructionDate = sampleSearchModel.DestructionDate
                .DestructionMethodTypeID = sampleSearchModel.DestructionMethodTypeID
                .DestructionMethodTypeName = sampleSearchModel.DestructionMethodTypeName
                .DiseaseID = sampleSearchModel.DiseaseID
                .DiseaseName = sampleSearchModel.DiseaseName
                .EIDSSLocalFieldSampleID = sampleSearchModel.EIDSSLocalFieldSampleID
                .EIDSSLaboratorySampleID = sampleSearchModel.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = sampleSearchModel.EIDSSReportSessionID
                .EnteredDate = sampleSearchModel.EnteredDate
                .FavoriteIndicator = sampleSearchModel.FavoriteIndicator
                .CollectedByOrganizationID = sampleSearchModel.CollectedByOrganizationID
                .CollectedByOrganizationName = sampleSearchModel.CollectedByOrganizationName
                .CollectedByPersonID = sampleSearchModel.CollectedByPersonID
                .CollectedByPersonName = sampleSearchModel.CollectedByPersonName
                .CollectionDate = sampleSearchModel.CollectionDate
                .SentDate = sampleSearchModel.SentDate
                .SentToOrganizationID = sampleSearchModel.SentToOrganizationID
                .SentToOrganizationName = sampleSearchModel.SentToOrganizationName
                .FreezerSubdivisionID = sampleSearchModel.FreezerSubdivisionID
                .FunctionalAreaID = sampleSearchModel.FunctionalAreaID
                .FunctionalAreaName = sampleSearchModel.FunctionalAreaName
                .HumanDiseaseReportID = sampleSearchModel.HumanDiseaseReportID
                .HumanID = sampleSearchModel.HumanID
                .MainTestID = sampleSearchModel.MainTestID
                .MarkedForDispositionByPersonID = sampleSearchModel.MarkedForDispositionByPersonID
                .MonitoringSessionID = sampleSearchModel.MonitoringSessionID
                .Note = sampleSearchModel.Note
                .ParentSampleID = sampleSearchModel.ParentSampleID
                .ParentEIDSSLaboratorySampleID = sampleSearchModel.ParentEIDSSLaboratorySampleID
                .OutOfRepositoryDate = sampleSearchModel.OutOfRepositoryDate
                .PatientFarmOwnerName = sampleSearchModel.PatientFarmOwnerName
                .PreviousSampleStatusTypeID = sampleSearchModel.PreviousSampleStatusTypeID
                .ReadOnlyIndicator = sampleSearchModel.ReadOnlyIndicator
                .ReportSessionTypeName = sampleSearchModel.ReportSessionTypeName
                .RootSampleID = sampleSearchModel.RootSampleID
                .RowAction = sampleSearchModel.RowAction
                .RowSelectionIndicator = 0
                .RowStatus = sampleSearchModel.RowStatus
                .SampleID = sampleSearchModel.SampleID
                .SampleKindTypeID = sampleSearchModel.SampleKindTypeID
                .SampleStatusTypeID = sampleSearchModel.SampleStatusTypeID
                .SampleTypeID = sampleSearchModel.SampleTypeID
                .SampleTypeName = sampleSearchModel.SampleTypeName
                .SiteID = sampleSearchModel.SiteID
                .SpeciesID = sampleSearchModel.SpeciesID
                .StorageBoxPlace = sampleSearchModel.StorageBoxPlace
                .TestAssignedIndicator = sampleSearchModel.TestAssignedIndicator
                .TestCompletedIndicator = sampleSearchModel.TestCompletedIndicator
                .TransferCount = sampleSearchModel.TransferCount
                .VectorID = sampleSearchModel.VectorID
                .VectorSessionID = sampleSearchModel.VectorSessionID
                .VeterinaryDiseaseReportID = sampleSearchModel.VeterinaryDiseaseReportID
            End With

            sampleListModel.Add(sample)
        Next

        Return sampleListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <returns></returns>
    Private Function ConvertSampleAdvancedSearch(samples As List(Of LabSampleAdvancedSearchGetListModel)) As List(Of LabSampleGetListModel)

        Dim sampleListModel = New List(Of LabSampleGetListModel)()
        Dim sample As LabSampleGetListModel

        For Each sampleAdvancedSearchModel As LabSampleAdvancedSearchGetListModel In samples
            sample = New LabSampleGetListModel()
            With sample
                .AccessionByPersonID = sampleAdvancedSearchModel.AccessionByPersonID
                .AccessionComment = sampleAdvancedSearchModel.AccessionComment
                .AccessionConditionTypeID = sampleAdvancedSearchModel.AccessionConditionTypeID
                .AccessionConditionOrSampleStatusTypeName = sampleAdvancedSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = sampleAdvancedSearchModel.AccessionDate
                .AccessionIndicator = sampleAdvancedSearchModel.AccessionIndicator
                .AnimalID = sampleAdvancedSearchModel.AnimalID
                .BirdStatusTypeID = sampleAdvancedSearchModel.BirdStatusTypeID
                .CurrentSiteID = sampleAdvancedSearchModel.CurrentSiteID
                .DestroyedByPersonID = sampleAdvancedSearchModel.DestroyedByPersonID
                .DestructionDate = sampleAdvancedSearchModel.DestructionDate
                .DestructionMethodTypeID = sampleAdvancedSearchModel.DestructionMethodTypeID
                .DestructionMethodTypeName = sampleAdvancedSearchModel.DestructionMethodTypeName
                .DiseaseID = sampleAdvancedSearchModel.DiseaseID
                .DiseaseName = sampleAdvancedSearchModel.DiseaseName
                .EIDSSLocalFieldSampleID = sampleAdvancedSearchModel.EIDSSLocalFieldSampleID
                .EIDSSLaboratorySampleID = sampleAdvancedSearchModel.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = sampleAdvancedSearchModel.EIDSSReportSessionID
                .EnteredDate = sampleAdvancedSearchModel.EnteredDate
                .FavoriteIndicator = sampleAdvancedSearchModel.FavoriteIndicator
                .CollectedByOrganizationID = sampleAdvancedSearchModel.CollectedByOrganizationID
                .CollectedByOrganizationName = sampleAdvancedSearchModel.CollectedByOrganizationName
                .CollectedByPersonID = sampleAdvancedSearchModel.CollectedByPersonID
                .CollectedByPersonName = sampleAdvancedSearchModel.CollectedByPersonName
                .CollectionDate = sampleAdvancedSearchModel.CollectionDate
                .SentDate = sampleAdvancedSearchModel.SentDate
                .SentToOrganizationID = sampleAdvancedSearchModel.SentToOrganizationID
                .SentToOrganizationName = sampleAdvancedSearchModel.SentToOrganizationName
                .FreezerSubdivisionID = sampleAdvancedSearchModel.FreezerSubdivisionID
                .FunctionalAreaID = sampleAdvancedSearchModel.FunctionalAreaID
                .FunctionalAreaName = sampleAdvancedSearchModel.FunctionalAreaName
                .HumanDiseaseReportID = sampleAdvancedSearchModel.HumanDiseaseReportID
                .HumanID = sampleAdvancedSearchModel.HumanID
                .MainTestID = sampleAdvancedSearchModel.MainTestID
                .MarkedForDispositionByPersonID = sampleAdvancedSearchModel.MarkedForDispositionByPersonID
                .MonitoringSessionID = sampleAdvancedSearchModel.MonitoringSessionID
                .Note = sampleAdvancedSearchModel.Note
                .ParentSampleID = sampleAdvancedSearchModel.ParentSampleID
                .ParentEIDSSLaboratorySampleID = sampleAdvancedSearchModel.ParentEIDSSLaboratorySampleID
                .OutOfRepositoryDate = sampleAdvancedSearchModel.OutOfRepositoryDate
                .PatientFarmOwnerName = sampleAdvancedSearchModel.PatientFarmOwnerName
                .PreviousSampleStatusTypeID = sampleAdvancedSearchModel.PreviousSampleStatusTypeID
                .ReadOnlyIndicator = sampleAdvancedSearchModel.ReadOnlyIndicator
                .ReportSessionTypeName = sampleAdvancedSearchModel.ReportSessionTypeName
                .RootSampleID = sampleAdvancedSearchModel.RootSampleID
                .RowAction = sampleAdvancedSearchModel.RowAction
                .RowStatus = sampleAdvancedSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleID = sampleAdvancedSearchModel.SampleID
                .SampleKindTypeID = sampleAdvancedSearchModel.SampleKindTypeID
                .SampleStatusTypeID = sampleAdvancedSearchModel.SampleStatusTypeID
                .SampleTypeID = sampleAdvancedSearchModel.SampleTypeID
                .SampleTypeName = sampleAdvancedSearchModel.SampleTypeName
                .SiteID = sampleAdvancedSearchModel.SiteID
                .SpeciesID = sampleAdvancedSearchModel.SpeciesID
                .StorageBoxPlace = sampleAdvancedSearchModel.StorageBoxPlace
                .TestAssignedIndicator = sampleAdvancedSearchModel.TestAssignedIndicator
                .TestCompletedIndicator = sampleAdvancedSearchModel.TestCompletedIndicator
                .TransferCount = sampleAdvancedSearchModel.TransferCount
                .VectorID = sampleAdvancedSearchModel.VectorID
                .VectorSessionID = sampleAdvancedSearchModel.VectorSessionID
                .VeterinaryDiseaseReportID = sampleAdvancedSearchModel.VeterinaryDiseaseReportID
            End With

            sampleListModel.Add(sample)
        Next

        Return sampleListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <returns></returns>
    Private Function ConvertTestSearch(tests As List(Of LabTestSearchGetListModel)) As List(Of LabTestGetListModel)

        Dim testListModel = New List(Of LabTestGetListModel)()
        Dim test As LabTestGetListModel

        For Each testSearchModel As LabTestSearchGetListModel In tests
            test = New LabTestGetListModel()
            With test
                .AccessionComment = testSearchModel.AccessionComment
                .AccessionConditionTypeID = testSearchModel.AccessionConditionTypeID
                .AccessionConditionOrSampleStatusTypeName = testSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = testSearchModel.AccessionDate
                .BatchTestID = testSearchModel.BatchTestID
                .ContactPersonName = testSearchModel.ContactPersonName
                .DiseaseID = testSearchModel.DiseaseID
                .DiseaseName = testSearchModel.DiseaseName
                .EIDSSLaboratorySampleID = testSearchModel.EIDSSLaboratorySampleID
                .EIDSSLocalFieldSampleID = testSearchModel.EIDSSLocalFieldSampleID
                .EIDSSReportSessionID = testSearchModel.EIDSSReportSessionID
                .ExternalTestIndicator = testSearchModel.ExternalTestIndicator
                .FavoriteIndicator = testSearchModel.FavoriteIndicator
                .FunctionalAreaName = testSearchModel.FunctionalAreaName
                .NonLaboratoryTestIndicator = testSearchModel.NonLaboratoryTestIndicator
                .Note = testSearchModel.Note
                .ObservationID = testSearchModel.ObservationID
                .ParentSampleID = testSearchModel.ParentSampleID
                .PatientFarmOwnerName = testSearchModel.PatientFarmOwnerName
                .PreviousTestStatusTypeID = testSearchModel.PreviousTestStatusTypeID
                .ReadOnlyIndicator = testSearchModel.ReadOnlyIndicator
                .ReceivedDate = testSearchModel.ReceivedDate
                .ResultDate = testSearchModel.ResultDate
                .ResultEnteredByOrganizationID = testSearchModel.ResultEnteredByOrganizationID
                .ResultEnteredByOrganizationName = testSearchModel.ResultEnteredByOrganizationName
                .ResultEnteredByPersonID = testSearchModel.ResultEnteredByPersonID
                .ResultEnteredByPersonName = testSearchModel.ResultEnteredByPersonName
                .ResultEnteredByPersonSiteID = testSearchModel.ResultEnteredByPersonSiteID
                .ResultEnteredByPersonSiteTypeID = testSearchModel.ResultEnteredByPersonSiteTypeID
                .ResultEnteredByPersonUserID = testSearchModel.ResultEnteredByPersonUserID
                .RootSampleID = testSearchModel.RootSampleID
                .RowAction = testSearchModel.RowAction
                .RowStatus = testSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleID = testSearchModel.SampleID
                .SampleStatusTypeID = testSearchModel.SampleStatusTypeID
                .SampleTypeName = testSearchModel.SampleTypeName
                .StartedDate = testSearchModel.StartedDate
                .TestCategoryTypeID = testSearchModel.TestCategoryTypeID
                .TestCategoryTypeName = testSearchModel.TestCategoryTypeName
                .TestedByOrganizationID = testSearchModel.TestedByOrganizationID
                .TestedByOrganizationName = testSearchModel.TestedByOrganizationName
                .TestedByPersonID = testSearchModel.TestedByPersonID
                .TestedByPersonName = testSearchModel.TestedByPersonName
                .TestID = testSearchModel.TestID
                .TestNameTypeID = testSearchModel.TestNameTypeID
                .TestNameTypeName = testSearchModel.TestNameTypeName
                .TestNumber = testSearchModel.TestNumber
                .TestResultTypeID = testSearchModel.TestResultTypeID
                .TestResultTypeName = testSearchModel.TestResultTypeName
                .TestStatusTypeID = testSearchModel.TestStatusTypeID
                .TestStatusTypeName = testSearchModel.TestStatusTypeName
                .ValidatedByOrganizationID = testSearchModel.ValidatedByOrganizationID
                .ValidatedByPersonID = testSearchModel.ValidatedByPersonID
                .ValidatedByPersonName = testSearchModel.ValidatedByPersonName
            End With

            testListModel.Add(test)
        Next

        Return testListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <returns></returns>
    Private Function ConvertTestAdvancedSearch(tests As List(Of LabTestAdvancedSearchGetListModel)) As List(Of LabTestGetListModel)

        Dim testListModel = New List(Of LabTestGetListModel)()
        Dim test As LabTestGetListModel

        For Each testAdvancedSearchModel As LabTestAdvancedSearchGetListModel In tests
            test = New LabTestGetListModel()
            With test
                .AccessionComment = testAdvancedSearchModel.AccessionComment
                .AccessionConditionTypeID = testAdvancedSearchModel.AccessionConditionTypeID
                .AccessionConditionOrSampleStatusTypeName = testAdvancedSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = testAdvancedSearchModel.AccessionDate
                .BatchTestID = testAdvancedSearchModel.BatchTestID
                .ContactPersonName = testAdvancedSearchModel.ContactPersonName
                .DiseaseID = testAdvancedSearchModel.DiseaseID
                .DiseaseName = testAdvancedSearchModel.DiseaseName
                .EIDSSLaboratorySampleID = testAdvancedSearchModel.EIDSSLaboratorySampleID
                .EIDSSLocalFieldSampleID = testAdvancedSearchModel.EIDSSLocalFieldSampleID
                .EIDSSReportSessionID = testAdvancedSearchModel.EIDSSReportSessionID
                .ExternalTestIndicator = testAdvancedSearchModel.ExternalTestIndicator
                .FavoriteIndicator = testAdvancedSearchModel.FavoriteIndicator
                .FunctionalAreaName = testAdvancedSearchModel.FunctionalAreaName
                .NonLaboratoryTestIndicator = testAdvancedSearchModel.NonLaboratoryTestIndicator
                .Note = testAdvancedSearchModel.Note
                .ObservationID = testAdvancedSearchModel.ObservationID
                .ParentSampleID = testAdvancedSearchModel.ParentSampleID
                .PatientFarmOwnerName = testAdvancedSearchModel.PatientFarmOwnerName
                .PreviousTestStatusTypeID = testAdvancedSearchModel.PreviousTestStatusTypeID
                .ReadOnlyIndicator = testAdvancedSearchModel.ReadOnlyIndicator
                .ReceivedDate = testAdvancedSearchModel.ReceivedDate
                .ResultDate = testAdvancedSearchModel.ResultDate
                .ResultEnteredByOrganizationID = testAdvancedSearchModel.ResultEnteredByOrganizationID
                .ResultEnteredByOrganizationName = testAdvancedSearchModel.ResultEnteredByOrganizationName
                .ResultEnteredByPersonID = testAdvancedSearchModel.ResultEnteredByPersonID
                .ResultEnteredByPersonName = testAdvancedSearchModel.ResultEnteredByPersonName
                .ResultEnteredByPersonSiteID = testAdvancedSearchModel.ResultEnteredByPersonSiteID
                .ResultEnteredByPersonSiteTypeID = testAdvancedSearchModel.ResultEnteredByPersonSiteTypeID
                .ResultEnteredByPersonUserID = testAdvancedSearchModel.ResultEnteredByPersonUserID
                .RootSampleID = testAdvancedSearchModel.RootSampleID
                .RowAction = testAdvancedSearchModel.RowAction
                .RowStatus = testAdvancedSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleID = testAdvancedSearchModel.SampleID
                .SampleStatusTypeID = testAdvancedSearchModel.SampleStatusTypeID
                .SampleTypeName = testAdvancedSearchModel.SampleTypeName
                .StartedDate = testAdvancedSearchModel.StartedDate
                .TestCategoryTypeID = testAdvancedSearchModel.TestCategoryTypeID
                .TestCategoryTypeName = testAdvancedSearchModel.TestCategoryTypeName
                .TestedByOrganizationID = testAdvancedSearchModel.TestedByOrganizationID
                .TestedByOrganizationName = testAdvancedSearchModel.TestedByOrganizationName
                .TestedByPersonID = testAdvancedSearchModel.TestedByPersonID
                .TestedByPersonName = testAdvancedSearchModel.TestedByPersonName
                .TestID = testAdvancedSearchModel.TestID
                .TestNameTypeID = testAdvancedSearchModel.TestNameTypeID
                .TestNameTypeName = testAdvancedSearchModel.TestNameTypeName
                .TestNumber = testAdvancedSearchModel.TestNumber
                .TestResultTypeID = testAdvancedSearchModel.TestResultTypeID
                .TestResultTypeName = testAdvancedSearchModel.TestResultTypeName
                .TestStatusTypeID = testAdvancedSearchModel.TestStatusTypeID
                .TestStatusTypeName = testAdvancedSearchModel.TestStatusTypeName
                .ValidatedByOrganizationID = testAdvancedSearchModel.ValidatedByOrganizationID
                .ValidatedByPersonID = testAdvancedSearchModel.ValidatedByPersonID
                .ValidatedByPersonName = testAdvancedSearchModel.ValidatedByPersonName
            End With

            testListModel.Add(test)
        Next

        Return testListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transfers"></param>
    ''' <returns></returns>
    Private Function ConvertTransferAdvancedSearch(transfers As List(Of LabTransferAdvancedSearchGetListModel)) As List(Of LabTransferGetListModel)

        Dim transferListModel = New List(Of LabTransferGetListModel)()
        Dim transfer As LabTransferGetListModel

        For Each transferAdvancedSearchModel As LabTransferAdvancedSearchGetListModel In transfers
            transfer = New LabTransferGetListModel()
            With transfer
                .AccessionComment = transferAdvancedSearchModel.AccessionComment
                .AccessionConditionOrSampleStatusTypeName = transferAdvancedSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = transferAdvancedSearchModel.AccessionDate
                .ContactPersonName = transferAdvancedSearchModel.ContactPersonName
                .DiseaseID = transferAdvancedSearchModel.DiseaseID
                .DiseaseName = transferAdvancedSearchModel.DiseaseName
                .EIDSSAnimalID = transferAdvancedSearchModel.EIDSSAnimalID
                .EIDSSLaboratorySampleID = transferAdvancedSearchModel.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = transferAdvancedSearchModel.EIDSSReportSessionID
                .EIDSSTransferID = transferAdvancedSearchModel.EIDSSTransferID
                .FavoriteIndicator = transferAdvancedSearchModel.FavoriteIndicator
                .FunctionalAreaID = transferAdvancedSearchModel.FunctionalAreaID
                .FunctionalAreaName = transferAdvancedSearchModel.FunctionalAreaName
                .NonEIDSSLaboratoryIndicator = transferAdvancedSearchModel.NonEIDSSLaboratoryIndicator
                .PatientFarmOwnerName = transferAdvancedSearchModel.PatientFarmOwnerName
                .PurposeOfTransfer = transferAdvancedSearchModel.PurposeOfTransfer
                .ResultDate = transferAdvancedSearchModel.ResultDate
                .RowAction = transferAdvancedSearchModel.RowAction
                .RowStatus = transferAdvancedSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleStatusTypeID = transferAdvancedSearchModel.SampleStatusTypeID
                .SampleTypeName = transferAdvancedSearchModel.SampleTypeName
                .SentByPersonID = transferAdvancedSearchModel.SentByPersonID
                .SentByPersonName = transferAdvancedSearchModel.SentByPersonName
                .TransferDate = transferAdvancedSearchModel.TransferDate
                .SiteID = transferAdvancedSearchModel.SiteID
                .TestRequested = transferAdvancedSearchModel.TestRequested
                .TestAssignedIndicator = transferAdvancedSearchModel.TestAssignedIndicator
                .TestID = transferAdvancedSearchModel.TestID
                .TestNameTypeName = transferAdvancedSearchModel.TestNameTypeName
                .TestResultTypeID = transferAdvancedSearchModel.TestResultTypeID
                .TestResultTypeName = transferAdvancedSearchModel.TestResultTypeName
                .TransferDate = transferAdvancedSearchModel.TransferDate
                .TransferID = transferAdvancedSearchModel.TransferID
                .TransferredFromOrganizationID = transferAdvancedSearchModel.TransferredFromOrganizationID
                .TransferredFromOrganizationName = transferAdvancedSearchModel.TransferredFromOrganizationName
                .TransferredInSampleID = transferAdvancedSearchModel.TransferredInSampleID
                .TransferredOutSampleID = transferAdvancedSearchModel.TransferredOutSampleID
                .TransferredToOrganizationID = transferAdvancedSearchModel.TransferredToOrganizationID
                .TransferredToOrganizationName = transferAdvancedSearchModel.TransferredToOrganizationName
                .TransferStatusTypeID = transferAdvancedSearchModel.TransferStatusTypeID
            End With

            transferListModel.Add(transfer)
        Next

        Return transferListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transfers"></param>
    ''' <returns></returns>
    Private Function ConvertTransferSearch(transfers As List(Of LabTransferSearchGetListModel)) As List(Of LabTransferGetListModel)

        Dim transferListModel = New List(Of LabTransferGetListModel)()
        Dim transfer As LabTransferGetListModel

        For Each transferSearchModel As LabTransferSearchGetListModel In transfers
            transfer = New LabTransferGetListModel()
            With transfer
                .AccessionComment = transferSearchModel.AccessionComment
                .AccessionConditionOrSampleStatusTypeName = transferSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = transferSearchModel.AccessionDate
                .ContactPersonName = transferSearchModel.ContactPersonName
                .DiseaseID = transferSearchModel.DiseaseID
                .DiseaseName = transferSearchModel.DiseaseName
                .EIDSSAnimalID = transferSearchModel.EIDSSAnimalID
                .EIDSSLaboratorySampleID = transferSearchModel.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = transferSearchModel.EIDSSReportSessionID
                .EIDSSTransferID = transferSearchModel.EIDSSTransferID
                .FavoriteIndicator = transferSearchModel.FavoriteIndicator
                .FunctionalAreaID = transferSearchModel.FunctionalAreaID
                .FunctionalAreaName = transferSearchModel.FunctionalAreaName
                .NonEIDSSLaboratoryIndicator = transferSearchModel.NonEIDSSLaboratoryIndicator
                .PatientFarmOwnerName = transferSearchModel.PatientFarmOwnerName
                .PurposeOfTransfer = transferSearchModel.PurposeOfTransfer
                .ResultDate = transferSearchModel.ResultDate
                .RowAction = transferSearchModel.RowAction
                .RowStatus = transferSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleStatusTypeID = transferSearchModel.SampleStatusTypeID
                .SampleTypeName = transferSearchModel.SampleTypeName
                .SentByPersonID = transferSearchModel.SentByPersonID
                .SentByPersonName = transferSearchModel.SentByPersonName
                .TransferDate = transferSearchModel.TransferDate
                .SiteID = transferSearchModel.SiteID
                .TestRequested = transferSearchModel.TestRequested
                .TestAssignedIndicator = transferSearchModel.TestAssignedIndicator
                .TestID = transferSearchModel.TestID
                .TestNameTypeName = transferSearchModel.TestNameTypeName
                .TestResultTypeID = transferSearchModel.TestResultTypeID
                .TestResultTypeName = transferSearchModel.TestResultTypeName
                .TransferDate = transferSearchModel.TransferDate
                .TransferID = transferSearchModel.TransferID
                .TransferredFromOrganizationID = transferSearchModel.TransferredFromOrganizationID
                .TransferredFromOrganizationName = transferSearchModel.TransferredFromOrganizationName
                .TransferredInSampleID = transferSearchModel.TransferredInSampleID
                .TransferredOutSampleID = transferSearchModel.TransferredOutSampleID
                .TransferredToOrganizationID = transferSearchModel.TransferredToOrganizationID
                .TransferredToOrganizationName = transferSearchModel.TransferredToOrganizationName
                .TransferStatusTypeID = transferSearchModel.TransferStatusTypeID
            End With

            transferListModel.Add(transfer)
        Next

        Return transferListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="favorites"></param>
    ''' <returns></returns>
    Private Function ConvertMyFavoriteAdvancedSearch(favorites As List(Of LabFavoriteAdvancedSearchGetListModel)) As List(Of LabFavoriteGetListModel)

        Dim favoriteListModel = New List(Of LabFavoriteGetListModel)()
        Dim favorite As LabFavoriteGetListModel

        For Each favoriteAdvancedSearchModel As LabFavoriteAdvancedSearchGetListModel In favorites
            favorite = New LabFavoriteGetListModel()
            With favorite
                .AccessionComment = favoriteAdvancedSearchModel.AccessionComment
                .AccessionConditionOrSampleStatusTypeName = favoriteAdvancedSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = favoriteAdvancedSearchModel.AccessionDate
                .DiseaseID = favoriteAdvancedSearchModel.DiseaseID
                .DiseaseName = favoriteAdvancedSearchModel.DiseaseName
                .EIDSSAnimalID = favoriteAdvancedSearchModel.EIDSSAnimalID
                .EIDSSLaboratorySampleID = favoriteAdvancedSearchModel.EIDSSLaboratorySampleID
                .EIDSSLocalFieldSampleID = favoriteAdvancedSearchModel.EIDSSLocalFieldSampleID
                .EIDSSReportSessionID = favoriteAdvancedSearchModel.EIDSSReportSessionID
                .FunctionalAreaID = favoriteAdvancedSearchModel.FunctionalAreaID
                .FunctionalAreaName = favoriteAdvancedSearchModel.FunctionalAreaName
                .ParentSampleID = favoriteAdvancedSearchModel.ParentSampleID
                .PatientFarmOwnerName = favoriteAdvancedSearchModel.PatientFarmOwnerName
                .ResultDate = favoriteAdvancedSearchModel.ResultDate
                .RootSampleID = favoriteAdvancedSearchModel.RootSampleID
                .RowAction = favoriteAdvancedSearchModel.RowAction
                .RowSelectionIndicator = 0
                .RootSampleID = favoriteAdvancedSearchModel.RootSampleID
                .SampleStatusTypeID = favoriteAdvancedSearchModel.SampleStatusTypeID
                .SampleTypeName = favoriteAdvancedSearchModel.SampleTypeName
                .StartedDate = favoriteAdvancedSearchModel.StartedDate
                .TestID = favoriteAdvancedSearchModel.TestID
                .TestNameTypeName = favoriteAdvancedSearchModel.TestNameTypeName
                .TestResultTypeID = favoriteAdvancedSearchModel.TestResultTypeID
                .TestResultTypeName = favoriteAdvancedSearchModel.TestResultTypeName
                .TestCategoryTypeID = favoriteAdvancedSearchModel.TestCategoryTypeID
                .TestCategoryTypeName = favoriteAdvancedSearchModel.TestCategoryTypeName
                .TestStatusTypeID = favoriteAdvancedSearchModel.TestStatusTypeID
                .TestStatusTypeName = favoriteAdvancedSearchModel.TestStatusTypeName
            End With

            favoriteListModel.Add(favorite)
        Next

        Return favoriteListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="favorites"></param>
    ''' <returns></returns>
    Private Function ConvertMyFavoriteSearch(favorites As List(Of LabFavoriteSearchGetListModel)) As List(Of LabFavoriteGetListModel)

        Dim favoriteListModel = New List(Of LabFavoriteGetListModel)()
        Dim favorite As LabFavoriteGetListModel

        For Each favoriteSearchModel As LabFavoriteSearchGetListModel In favorites
            favorite = New LabFavoriteGetListModel()
            With favorite
                .AccessionComment = favoriteSearchModel.AccessionComment
                .AccessionConditionOrSampleStatusTypeName = favoriteSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = favoriteSearchModel.AccessionDate
                .DiseaseID = favoriteSearchModel.DiseaseID
                .DiseaseName = favoriteSearchModel.DiseaseName
                .EIDSSAnimalID = favoriteSearchModel.EIDSSAnimalID
                .EIDSSLaboratorySampleID = favoriteSearchModel.EIDSSLaboratorySampleID
                .EIDSSLocalFieldSampleID = favoriteSearchModel.EIDSSLocalFieldSampleID
                .EIDSSReportSessionID = favoriteSearchModel.EIDSSReportSessionID
                .FunctionalAreaID = favoriteSearchModel.FunctionalAreaID
                .FunctionalAreaName = favoriteSearchModel.FunctionalAreaName
                .ParentSampleID = favoriteSearchModel.ParentSampleID
                .PatientFarmOwnerName = favoriteSearchModel.PatientFarmOwnerName
                .ResultDate = favoriteSearchModel.ResultDate
                .RootSampleID = favoriteSearchModel.RootSampleID
                .RowAction = favoriteSearchModel.RowAction
                .RowSelectionIndicator = 0
                .RootSampleID = favoriteSearchModel.RootSampleID
                .SampleStatusTypeID = favoriteSearchModel.SampleStatusTypeID
                .SampleTypeName = favoriteSearchModel.SampleTypeName
                .StartedDate = favoriteSearchModel.StartedDate
                .TestID = favoriteSearchModel.TestID
                .TestNameTypeName = favoriteSearchModel.TestNameTypeName
                .TestResultTypeID = favoriteSearchModel.TestResultTypeID
                .TestResultTypeName = favoriteSearchModel.TestResultTypeName
                .TestCategoryTypeID = favoriteSearchModel.TestCategoryTypeID
                .TestCategoryTypeName = favoriteSearchModel.TestCategoryTypeName
                .TestStatusTypeID = favoriteSearchModel.TestStatusTypeID
                .TestStatusTypeName = favoriteSearchModel.TestStatusTypeName
            End With

            favoriteListModel.Add(favorite)
        Next

        Return favoriteListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="batches"></param>
    ''' <returns></returns>
    Private Function ConvertBatchAdvancedSearch(batches As List(Of LabBatchAdvancedSearchGetListModel)) As List(Of LabBatchGetListModel)

        Dim batchListModel = New List(Of LabBatchGetListModel)()
        Dim batch As LabBatchGetListModel

        For Each batchAdvancedSearchModel As LabBatchAdvancedSearchGetListModel In batches
            batch = New LabBatchGetListModel()
            With batch
                .AccessionComment = batchAdvancedSearchModel.AccessionComment
                .AccessionConditionOrSampleStatusTypeName = batchAdvancedSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = batchAdvancedSearchModel.AccessionDate
                .BatchStatusTypeID = batchAdvancedSearchModel.BatchStatusTypeID
                .BatchStatusTypeName = batchAdvancedSearchModel.BatchStatusTypeName
                .BatchTestID = batchAdvancedSearchModel.BatchTestID
                .BatchTestPerformedByOrganizationID = batchAdvancedSearchModel.BatchTestPerformedByOrganizationID
                .BatchTestPerformedByPersonID = batchAdvancedSearchModel.BatchTestPerformedByPersonID
                .BatchTestTestNameTypeID = batchAdvancedSearchModel.BatchTestTestNameTypeID
                .BatchTestTestNameTypeName = batchAdvancedSearchModel.BatchTestTestNameTypeName
                .ContactPersonName = batchAdvancedSearchModel.ContactPersonName
                .DiseaseID = batchAdvancedSearchModel.DiseaseID
                .DiseaseName = batchAdvancedSearchModel.DiseaseName
                .EIDSSAnimalID = batchAdvancedSearchModel.EIDSSAnimalID
                .EIDSSBatchTestID = batchAdvancedSearchModel.EIDSSBatchTestID
                .EIDSSLaboratorySampleID = batchAdvancedSearchModel.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = batchAdvancedSearchModel.EIDSSReportSessionID
                .ExternalTestIndicator = batchAdvancedSearchModel.ExternalTestIndicator
                .FavoriteIndicator = batchAdvancedSearchModel.FavoriteIndicator
                .FunctionalAreaName = batchAdvancedSearchModel.FunctionalAreaName
                .NonLaboratoryTestIndicator = batchAdvancedSearchModel.NonLaboratoryTestIndicator
                .Note = batchAdvancedSearchModel.Note
                .ObservationID = batchAdvancedSearchModel.ObservationID
                .PatientFarmOwnerName = batchAdvancedSearchModel.PatientFarmOwnerName
                .PerformedByOrganizationID = batchAdvancedSearchModel.PerformedByOrganizationID
                .PerformedByPersonID = batchAdvancedSearchModel.PerformedByPersonID
                .PerformedDate = batchAdvancedSearchModel.PerformedDate
                .ReadOnlyIndicator = batchAdvancedSearchModel.ReadOnlyIndicator
                .ReceivedDate = batchAdvancedSearchModel.ReceivedDate
                .ResultDate = batchAdvancedSearchModel.ResultDate
                .ResultEnteredByOrganizationID = batchAdvancedSearchModel.ResultEnteredByOrganizationID
                .ResultEnteredByPersonID = batchAdvancedSearchModel.ResultEnteredByPersonID
                .RowAction = batchAdvancedSearchModel.RowAction
                .RowStatus = batchAdvancedSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleID = batchAdvancedSearchModel.SampleID
                .SampleStatusTypeID = batchAdvancedSearchModel.SampleStatusTypeID
                .SampleTypeName = batchAdvancedSearchModel.SampleTypeName
                .StartedDate = batchAdvancedSearchModel.StartedDate
                .TestCategoryTypeID = batchAdvancedSearchModel.TestCategoryTypeID
                .TestCategoryTypeName = batchAdvancedSearchModel.TestCategoryTypeName
                .TestedByOrganizationID = batchAdvancedSearchModel.TestedByOrganizationID
                .TestedByPersonID = batchAdvancedSearchModel.TestedByPersonID
                .TestID = batchAdvancedSearchModel.TestID
                .TestNameTypeID = batchAdvancedSearchModel.TestNameTypeID
                .TestNameTypeName = batchAdvancedSearchModel.TestNameTypeName
                .TestNumber = batchAdvancedSearchModel.TestNumber
                .TestResultTypeID = batchAdvancedSearchModel.TestResultTypeID
                .TestResultTypeName = batchAdvancedSearchModel.TestResultTypeName
                .TestStatusTypeID = batchAdvancedSearchModel.TestStatusTypeID
                .TestStatusTypeName = batchAdvancedSearchModel.TestStatusTypeName
                .ValidatedByOrganizationID = batchAdvancedSearchModel.ValidatedByOrganizationID
                .ValidatedByPersonID = batchAdvancedSearchModel.ValidatedByPersonID
            End With

            batchListModel.Add(batch)
        Next

        Return batchListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="approvals"></param>
    ''' <returns></returns>
    Private Function ConvertApprovalAdvancedSearch(approvals As List(Of LabApprovalAdvancedSearchGetListModel)) As List(Of LabApprovalGetListModel)

        Dim approvalListModel = New List(Of LabApprovalGetListModel)()
        Dim approval As LabApprovalGetListModel

        For Each approvalAdvancedSearchModel As LabApprovalAdvancedSearchGetListModel In approvals
            approval = New LabApprovalGetListModel()
            With approval
                .AccessionConditionOrSampleStatusTypeName = approvalAdvancedSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = approvalAdvancedSearchModel.AccessionDate
                .ActionRequested = approvalAdvancedSearchModel.ActionRequested
                .DiseaseID = approvalAdvancedSearchModel.DiseaseID
                .DiseaseName = approvalAdvancedSearchModel.DiseaseName
                .EIDSSAnimalID = approvalAdvancedSearchModel.EIDSSAnimalID
                .EIDSSLaboratorySampleID = approvalAdvancedSearchModel.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = approvalAdvancedSearchModel.EIDSSReportSessionID
                .PatientFarmOwnerName = approvalAdvancedSearchModel.PatientFarmOwnerName
                .PreviousSampleStatusTypeID = approvalAdvancedSearchModel.PreviousSampleStatusTypeID
                .PreviousTestStatusTypeID = approvalAdvancedSearchModel.PreviousTestStatusTypeID
                .ResultDate = approvalAdvancedSearchModel.ResultDate
                .RowAction = approvalAdvancedSearchModel.RowAction
                .RowStatus = approvalAdvancedSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleStatusTypeID = approvalAdvancedSearchModel.SampleStatusTypeID
                .SampleTypeName = approvalAdvancedSearchModel.SampleTypeName
                .TestCategoryTypeID = approvalAdvancedSearchModel.TestCategoryTypeID
                .TestID = approvalAdvancedSearchModel.TestID
                .TestNameTypeID = approvalAdvancedSearchModel.TestNameTypeID
                .TestNameTypeName = approvalAdvancedSearchModel.TestNameTypeName
                .TestResultTypeID = approvalAdvancedSearchModel.TestResultTypeID
                .TestResultTypeName = approvalAdvancedSearchModel.TestResultTypeName
                .TestStatusTypeID = approvalAdvancedSearchModel.TestStatusTypeID
                .TestStatusTypeName = approvalAdvancedSearchModel.TestStatusTypeName
            End With

            approvalListModel.Add(approval)
        Next

        Return approvalListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="approvals"></param>
    ''' <returns></returns>
    Private Function ConvertApprovalSearch(approvals As List(Of LabApprovalSearchGetListModel)) As List(Of LabApprovalGetListModel)

        Dim approvalListModel = New List(Of LabApprovalGetListModel)()
        Dim approval As LabApprovalGetListModel

        For Each approvalSearchModel As LabApprovalSearchGetListModel In approvals
            approval = New LabApprovalGetListModel()
            With approval
                .AccessionConditionOrSampleStatusTypeName = approvalSearchModel.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = approvalSearchModel.AccessionDate
                .ActionRequested = approvalSearchModel.ActionRequested
                .DiseaseID = approvalSearchModel.DiseaseID
                .DiseaseName = approvalSearchModel.DiseaseName
                .EIDSSAnimalID = approvalSearchModel.EIDSSAnimalID
                .EIDSSLaboratorySampleID = approvalSearchModel.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = approvalSearchModel.EIDSSReportSessionID
                .PatientFarmOwnerName = approvalSearchModel.PatientFarmOwnerName
                .PreviousSampleStatusTypeID = approvalSearchModel.PreviousSampleStatusTypeID
                .PreviousTestStatusTypeID = approvalSearchModel.PreviousTestStatusTypeID
                .ResultDate = approvalSearchModel.ResultDate
                .RowAction = approvalSearchModel.RowAction
                .RowStatus = approvalSearchModel.RowStatus
                .RowSelectionIndicator = 0
                .SampleStatusTypeID = approvalSearchModel.SampleStatusTypeID
                .SampleTypeName = approvalSearchModel.SampleTypeName
                .TestCategoryTypeID = approvalSearchModel.TestCategoryTypeID
                .TestID = approvalSearchModel.TestID
                .TestNameTypeID = approvalSearchModel.TestNameTypeID
                .TestNameTypeName = approvalSearchModel.TestNameTypeName
                .TestResultTypeID = approvalSearchModel.TestResultTypeID
                .TestResultTypeName = approvalSearchModel.TestResultTypeName
                .TestStatusTypeID = approvalSearchModel.TestStatusTypeID
                .TestStatusTypeName = approvalSearchModel.TestStatusTypeName
            End With

            approvalListModel.Add(approval)
        Next

        Return approvalListModel

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SampleTestDetailsSave_Click(sender As Object, e As EventArgs) Handles btnSampleTestDetailsSave.Click

        Try
            FillDropDowns()

            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            If samples Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
            End If

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            If Not ucAddUpdateSample.Sample Is Nothing Then
                If Not ucAddUpdateSample.Save() Is Nothing Then
                    If samples.Where(Function(x) x.SampleID = ucAddUpdateSample.Sample.SampleID).Count > 0 Then
                        samples(samples.IndexOf(ucAddUpdateSample.Sample)) = ucAddUpdateSample.Sample
                    Else
                        samples.Add(ucAddUpdateSample.Sample)
                    End If

                    If samplesPendingSave.Where(Function(x) x.SampleID = ucAddUpdateSample.Sample.SampleID).Count > 0 Then
                        samplesPendingSave(samplesPendingSave.IndexOf(ucAddUpdateSample.Sample)) = ucAddUpdateSample.Sample
                    Else
                        samplesPendingSave.Add(ucAddUpdateSample.Sample)
                    End If

                    Session(SESSION_SAMPLES_LIST) = samples
                    Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave

                    BindSamplesGridView()

                    upSamples.Update()
                    upSamplesSave.Update()
                End If
            End If

            If Not ucAddUpdateTest.Test Is Nothing Then
                Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
                Dim testsPendingSave As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))

                If tests Is Nothing Then
                    tests = New List(Of LabTestGetListModel)()
                End If

                If testsPendingSave Is Nothing Then
                    testsPendingSave = New List(Of LabTestGetListModel)()
                End If

                If Not ucAddUpdateTest.Save() Is Nothing Then
                    ucAddUpdateTest.Test.AccessionComment = ucAddUpdateSample.Sample.AccessionComment
                    ucAddUpdateTest.Test.AccessionConditionTypeID = ucAddUpdateSample.Sample.AccessionConditionTypeID
                    ucAddUpdateTest.Test.AccessionConditionOrSampleStatusTypeName = ucAddUpdateSample.Sample.AccessionConditionOrSampleStatusTypeName
                    ucAddUpdateTest.Test.FunctionalAreaName = ucAddUpdateSample.Sample.FunctionalAreaName

                    If tests.Where(Function(x) x.TestID = ucAddUpdateTest.Test.TestID).Count > 0 Then
                        tests(tests.IndexOf(ucAddUpdateTest.Test)) = ucAddUpdateTest.Test
                    Else
                        tests.Add(ucAddUpdateTest.Test)
                    End If

                    If testsPendingSave.Where(Function(x) x.TestID = ucAddUpdateTest.Test.TestID).Count > 0 Then
                        testsPendingSave(testsPendingSave.IndexOf(ucAddUpdateTest.Test)) = ucAddUpdateTest.Test
                    Else
                        testsPendingSave.Add(ucAddUpdateTest.Test)
                    End If

                    Session(SESSION_TESTING_LIST) = tests
                    Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave

                    If ucAddUpdateTest.Test.TestStatusTypeID = TestStatusTypes.InProgress Then
                        Dim testInProgressCount As Integer = lblTestingCount.Text
                        lblTestingCount.Text = testInProgressCount + 1
                    Else
                        If ucAddUpdateTest.Test.TestStatusTypeID = TestStatusTypes.Preliminary Then
                            Dim approvalsCount As Integer = lblApprovalsCount.Text
                            lblApprovalsCount.Text = approvalsCount + 1
                            BindApprovalsGridView()
                        End If
                    End If
                    BindTestingGridView()
                End If

                upTesting.Update()
                upTestingSave.Update()
            End If

            If Not ucTransferSampleForSampleTestDetails.Transfer Is Nothing Then
                Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
                Dim transfersPendingSave As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))

                If transfers Is Nothing Then
                    transfers = New List(Of LabTransferGetListModel)()
                End If

                If transfersPendingSave Is Nothing Then
                    transfersPendingSave = New List(Of LabTransferGetListModel)()
                End If

                If Not ucTransferSampleForSampleTestDetails.SaveTransfer(Nothing) Is Nothing Then
                    If CrossCuttingAPIService Is Nothing Then
                        CrossCuttingAPIService = New CrossCuttingServiceClient()
                    End If

                    Dim oldTransferredToOrganizationID As String = String.Empty
                    Dim organizationParameters = New OrganizationGetListParams With {.LanguageID = GetCurrentLanguage(), .OrganizationID = ucTransferSampleForSampleTestDetails.GetTransferredToOrganizationID(oldTransferredToOrganizationID:=oldTransferredToOrganizationID), .PaginationSetNumber = 1}
                    Dim sendToOrganization = CrossCuttingAPIService.GetOrganizationListAsync(organizationParameters).Result
                    Dim transferredInSample As LabSampleGetListModel
                    Dim transferredOutSample As LabSampleGetListModel

                    'Did the sent/transferred to organization change?
                    If oldTransferredToOrganizationID = sendToOrganization.FirstOrDefault().OrganizationID Then
                        'The organization did not change.  Is the sent/transferred to organization a non-EIDSS laboratory?
                        If ucTransferSampleForSampleTestDetails.Transfer.NonEIDSSLaboratoryIndicator = 0 Then
                            'Sent/transferred to EIDSS laboratory, so update the transferred in sample record with any changes to the sent date.
                            If samples.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).Count = 0 And
                                samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).Count = 0 Then
                                Dim parameters = New LaboratorySampleGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SiteID = Nothing, .UserID = Nothing, .OrganizationID = Nothing, .DaysFromAccessionDate = Int32.MinValue, .SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID, .ParentSampleID = Nothing}
                                transferredInSample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters).Result.FirstOrDefault()
                            Else
                                If samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).Count > 0 Then
                                    transferredInSample = samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).FirstOrDefault()
                                Else
                                    transferredInSample = samples.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).FirstOrDefault()
                                End If
                            End If

                            transferredInSample.SentDate = ucTransferSampleForSampleTestDetails.Transfer.TransferDate
                        End If
                    Else
                        'The sent/transferred to organization did change, so verify the new organization is an EIDSS laboratory.
                        If sendToOrganization.FirstOrDefault().SiteID Is Nothing Then
                            'Sent/transferred to organization is a non-EIDSS laboratory, so was the prior sent/transferred to organization a non-EIDSS laboratory?
                            If ucTransferSampleForSampleTestDetails.Transfer.NonEIDSSLaboratoryIndicator = 0 Then
                                'De-activate the transferred in sample.
                                If samples.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).Count = 0 And
                                samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).Count = 0 Then
                                    Dim parameters = New LaboratorySampleGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SiteID = Nothing, .UserID = Nothing, .OrganizationID = Nothing, .DaysFromAccessionDate = Int32.MinValue, .SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID, .ParentSampleID = Nothing}
                                    transferredInSample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters).Result.FirstOrDefault()
                                Else
                                    If samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).Count > 0 Then
                                        transferredInSample = samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).FirstOrDefault()
                                    Else
                                        transferredInSample = samples.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredInSampleID).FirstOrDefault()
                                    End If
                                End If

                                transferredInSample.RowStatus = RecordConstants.InactiveRowStatus
                                transferredInSample.Note = GetLocalResourceObject("Lbl_Transferred_In_Sample_Deactivated_Note")
                            End If
                        Else
                            If samples.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID).Count = 0 And
                                samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID).Count = 0 Then
                                Dim parameters = New LaboratorySampleGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SiteID = Nothing, .UserID = Nothing, .OrganizationID = Nothing, .DaysFromAccessionDate = Integer.MinValue, .SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID, .ParentSampleID = Nothing}
                                transferredOutSample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters).Result.FirstOrDefault()
                            Else
                                If samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID).Count > 0 Then
                                    transferredOutSample = samplesPendingSave.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID).FirstOrDefault()
                                Else
                                    transferredOutSample = samples.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID).FirstOrDefault()
                                End If
                            End If

                            transferredInSample = CreateTransferredInSample(transferredOutSample, sendToOrganization.FirstOrDefault.SiteID, samplesPendingSave.Count)

                            samplesPendingSave.Add(transferredInSample)
                        End If
                    End If

                    If transfers.Where(Function(x) x.TransferID = ucTransferSampleForSampleTestDetails.Transfer.TransferID).Count > 0 Then
                        transfers(transfers.IndexOf(ucTransferSampleForSampleTestDetails.Transfer)) = ucTransferSampleForSampleTestDetails.Transfer
                    Else
                        transfers.Add(ucTransferSampleForSampleTestDetails.Transfer)
                    End If

                    If transfersPendingSave.Where(Function(x) x.TransferID = ucTransferSampleForSampleTestDetails.Transfer.TransferID).Count > 0 Then
                        transfersPendingSave(transfersPendingSave.IndexOf(ucTransferSampleForSampleTestDetails.Transfer)) = ucTransferSampleForSampleTestDetails.Transfer
                    Else
                        transfersPendingSave.Add(ucTransferSampleForSampleTestDetails.Transfer)
                    End If

                    Session(SESSION_TRANSFERRED_LIST) = transfers
                    Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave

                    BindTransferredGridView()
                End If

                upTransferDetails.Update()
                upTransferredSave.Update()
            End If

            Dim errorMessages = GetErrorMessages("EditSampleTestDetails")

            If errorMessages = String.Empty Then
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "hideModal('#divSampleTestDetailsModal');", True)
            Else
                ShowErrorMessage(messageType:=MessageType.CannotSaveSampleTestDetails, message:=errorMessages)
            End If

            Session(SESSION_SAMPLES_LIST) = samples
            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave

            ucAddUpdateSample.Sample = Nothing
            ucAddUpdateTest.Test = Nothing
            ucTransferSample.Transfer = Nothing
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Samples Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillSamplesList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            If hdfAdvancedSearchIndicator.Value = YesNoUnknown.No And hdgTestingQueryText.InnerText = String.Empty Then
                Dim parameters = New LaboratorySampleGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber, .SiteID = hdfSiteID.Value, .UserID = hdfUserID.Value, .OrganizationID = hdfOrganizationID.Value, .DaysFromAccessionDate = ConfigurationManager.AppSettings("DaysFromAccessionDate")}
                Session(SESSION_SAMPLES_LIST) = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters).Result
            Else
                If hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes Then
                    ucSearchSample.FillSamplesList()
                Else
                    ucSamplesSearch.Search()
                End If
            End If

            FillSamplesPager(hdfSamplesCount.Value, pageIndex)
            ViewState(SAMPLES_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindSamplesGridView()

        Try
            Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))

            If samples Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
                Session(SESSION_SAMPLES_LIST) = samples
            End If

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
                Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
            End If

            If samplesPendingSave.Count > 0 Then
                btnSamplesSave.Enabled = True

                If (Not ViewState(SAMPLES_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(SAMPLES_SORT_DIRECTION) = SortConstants.Ascending Then
                        samples = samples.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SAMPLES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        samples = samples.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SAMPLES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    samples = samples.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.AccessionDate).ThenBy(Function(z) z.PatientFarmOwnerName).ToList()
                End If
            Else
                btnSamplesSave.Enabled = False

                If (Not ViewState(SAMPLES_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(SAMPLES_SORT_DIRECTION) = SortConstants.Ascending Then
                        samples = samples.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SAMPLES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        samples = samples.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SAMPLES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    samples = samples.OrderBy(Function(x) x.AccessionDate).ThenBy(Function(y) y.PatientFarmOwnerName).ToList()
                End If
            End If

            If samples.Where(Function(x) x.RowSelectionIndicator = 1).Count > 0 Then
                If samples.Where(Function(x) x.RowSelectionIndicator = 1).Count = 1 Then
                    If samples.Where(Function(x) x.RowSelectionIndicator = 1).FirstOrDefault().AccessionIndicator = 0 Then
                        btnAccession.Disabled = False
                        btnSamplesAssignTest.Enabled = False
                        btnSamplesAliquot.Enabled = False
                        ucSamplesMenu.SetAssignTestDisabled(True)
                        ucSamplesMenu.SetDeleteSampleDisabled(True)
                    Else
                        btnSamplesAssignTest.Enabled = True
                        btnSamplesAliquot.Enabled = True
                        ucSamplesMenu.SetAssignTestDisabled(False)
                        ucSamplesMenu.SetDeleteSampleDisabled(False)
                        ucSamplesMenu.SetTransferOutDisabled(False)
                    End If

                    'LUC21 - Restore Deleted Sample
                    If samples.Where(Function(x) x.RowSelectionIndicator = 1).FirstOrDefault().SampleStatusTypeID = SampleStatusTypes.Deleted Then
                        ucSamplesMenu.SetRestoreSampleDisabled(False)
                    End If

                    'LUC14 - Sample Destruction
                    If samples.Where(Function(x) x.RowSelectionIndicator = 1).FirstOrDefault().AccessionIndicator = 0 Or
                            (samples.Where(Function(x) x.RowSelectionIndicator = 1).FirstOrDefault().SampleStatusTypeID = SampleStatusTypes.Destroyed Or
                            samples.Where(Function(x) x.RowSelectionIndicator = 1).FirstOrDefault().SampleStatusTypeID = SampleStatusTypes.MarkedForDestruction) Then
                        ucSamplesMenu.SetSampleDestructionDisabled(True)
                    Else
                        ucSamplesMenu.SetSampleDestructionDisabled(False)
                    End If
                Else
                    If samples.Where(Function(x) x.AccessionIndicator = 1).Count > 0 Then
                        btnSamplesAssignTest.Enabled = True
                        btnSamplesAliquot.Enabled = True
                        ucSamplesMenu.SetAssignTestDisabled(False)
                        ucSamplesMenu.SetDeleteSampleDisabled(False)
                        ucSamplesMenu.SetSampleDestructionDisabled(False)
                        ucSamplesMenu.SetTransferOutDisabled(False)
                    End If

                    ucSamplesMenu.SetRestoreSampleDisabled(False)
                End If
            Else
                btnAccession.Disabled = True
                btnSamplesAssignTest.Enabled = False
                btnSamplesAliquot.Enabled = False
                ucSamplesMenu.SetAssignTestDisabled(True)
                ucSamplesMenu.SetDeleteSampleDisabled(True)
                ucSamplesMenu.SetSampleDestructionDisabled(True)
                ucSamplesMenu.SetRestoreSampleDisabled(True)
                ucSamplesMenu.SetTransferOutDisabled(True)
            End If

            gvSamples.DataSource = samples
            gvSamples.DataBind()
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
    Protected Sub Samples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then
                Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                If Not samples Is Nothing Then
                    Dim btnToggleAllSamples As LinkButton = CType(e.Row.FindControl("btnToggleAllSamples"), LinkButton)
                    Dim btnHeaderSamplesSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnHeaderSamplesSetMyFavorite"), LinkButton)
                    Dim imgHeaderSamplesMyFavoriteStar As Image = CType(e.Row.FindControl("imgHeaderSamplesMyFavoriteStar"), Image)

                    If samples.Where(Function(x) x.RowSelectionIndicator = 1).Count = samples.Count And samples.Count > 0 Then
                        btnToggleAllSamples.CssClass = CSS_BTN_GLYPHICON_CHECKED
                    Else
                        btnToggleAllSamples.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                    End If

                    If samples.Where(Function(x) x.FavoriteIndicator = 1).Count = samples.Count And samples.Count > 0 Then
                        btnHeaderSamplesSetMyFavorite.CssClass = CSS_MY_FAVORITE
                        imgHeaderSamplesMyFavoriteStar.ImageUrl = "~/Includes/Images/whiteStar.png"
                    Else
                        btnHeaderSamplesSetMyFavorite.CssClass = CSS_MY_FAVORITE_NO
                        imgHeaderSamplesMyFavoriteStar.ImageUrl = "~/Includes/Images/blueStar.png"
                    End If
                End If
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim sample As LabSampleGetListModel = TryCast(e.Row.DataItem, LabSampleGetListModel)
                    If Not sample Is Nothing Then
                        Dim lblSampleStatusTypeName As Label = CType(e.Row.FindControl("lblSamplesSampleStatusTypeName"), Label)
                        Dim ddlSampleStatusType As DropDownList = CType(e.Row.FindControl("ddlSamplesSampleStatusType"), DropDownList)
                        Dim lblFunctionalAreaName As Label = CType(e.Row.FindControl("lblSamplesFunctionalAreaName"), Label)
                        Dim ddlFunctionalArea As DropDownList = CType(e.Row.FindControl("ddlSamplesFunctionalArea"), DropDownList)
                        Dim btnToggleSamples As LinkButton = CType(e.Row.FindControl("btnToggleSamples"), LinkButton)
                        Dim btnSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnSamplesSetMyFavorite"), LinkButton)
                        Dim imgMyFavoriteStar As Image = CType(e.Row.FindControl("imgSamplesMyFavoriteStar"), Image)
                        Dim accessionUpdatePanel As UpdatePanel = CType(e.Row.FindControl("upSamplesAccessionItemTemplate"), UpdatePanel)
                        Dim clientID As String = sender.ClientID
                        Dim i As Integer = 0

                        If sample.RowSelectionIndicator = 0 Then
                            btnToggleSamples.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                        Else
                            btnToggleSamples.CssClass = CSS_BTN_GLYPHICON_CHECKED
                        End If

                        accessionUpdatePanel.Update()

                        If sample.FavoriteIndicator = 0 Then
                            btnSetMyFavorite.CssClass = CSS_MY_FAVORITE_NO
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/blueStar.png"
                        Else
                            btnSetMyFavorite.CssClass = CSS_MY_FAVORITE
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/whiteStar.png"
                        End If

                        Dim commentBoxEmptyLink As HtmlAnchor = CType(e.Row.FindControl("lnkSamplesSampleStatusCommentEmpty"), HtmlAnchor)
                        commentBoxEmptyLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentBoxLink As HtmlAnchor = CType(e.Row.FindControl("lnkSamplesSampleStatusComment"), HtmlAnchor)
                        commentBoxLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentEmptyJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divSamplesCommentBoxEmptyContainer_" & e.Row.RowIndex & "').html(); }});"
                        Dim commentJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divSamplesCommentBoxContainer_" & e.Row.RowIndex & "').html(); }});"

                        If sample.AccessionComment.IsValueNullOrEmpty() Then
                            commentBoxEmptyLink.Visible = True
                            commentBoxLink.Visible = False

                            Dim divCommentRequired As HtmlGenericControl = CType(e.Row.FindControl("divSamplesCommentRequired"), HtmlGenericControl)
                            If sample.AccessionConditionTypeID Is Nothing Then
                                divCommentRequired.Visible = False
                            Else
                                If (sample.AccessionConditionTypeID.ToString() = AccessionConditionTypes.AcceptedInPoorCondition Or
                                sample.AccessionConditionTypeID.ToString() = AccessionConditionTypes.Rejected) Then
                                    divCommentRequired.Visible = True
                                Else
                                    divCommentRequired.Visible = False
                                End If
                            End If

                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentEmptyJavaScript, True)
                        Else
                            commentBoxEmptyLink.Visible = False
                            commentBoxLink.Visible = True
                            Dim commentTextBox As TextBox = CType(e.Row.FindControl("txtSamplesCommentTextBox"), TextBox)
                            commentTextBox.Text = sample.AccessionComment
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentJavaScript, True)
                        End If

                        If sample.AccessionIndicator = 0 Then
                            If sample.RowAction = RecordConstants.Insert Or
                                sample.RowAction = RecordConstants.InsertAccession Or
                                sample.RowAction = RecordConstants.Update Or
                                sample.RowAction = RecordConstants.Accession Then
                                e.Row.CssClass = CSS_UNACCESSIONED_SAVE_PENDING
                            Else
                                e.Row.CssClass = CSS_UNACCESSIONED
                            End If

                            lblSampleStatusTypeName.Visible = False
                            ddlSampleStatusType.DataSource = ddlAccessionConditionTypes.Items
                            ddlSampleStatusType.DataTextField = "Text"
                            ddlSampleStatusType.DataValueField = "Value"
                            ddlSampleStatusType.DataBind()
                            ddlSampleStatusType.Visible = True
                            ddlSampleStatusType.SelectedValue = If(sample.AccessionConditionTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, sample.AccessionConditionTypeID)

                            lblFunctionalAreaName.Visible = False
                            ddlFunctionalArea.DataSource = ddlFunctionalAreas.Items
                            ddlFunctionalArea.DataTextField = "Text"
                            ddlFunctionalArea.DataValueField = "Value"
                            ddlFunctionalArea.DataBind()
                            ddlFunctionalArea.Visible = True
                            ddlFunctionalArea.SelectedValue = If(sample.FunctionalAreaID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, sample.FunctionalAreaID)
                        Else
                            If sample.RowAction = RecordConstants.Update Or
                               sample.RowAction = RecordConstants.Accession Or
                               sample.RowAction = RecordConstants.InsertAccession Then
                                e.Row.CssClass = CSS_SAVE_PENDING

                                If sample.SampleStatusTypeID = SampleStatusTypes.MarkedForDeletion Or sample.SampleStatusTypeID = SampleStatusTypes.MarkedForDestruction Then
                                    lblSampleStatusTypeName.Visible = True
                                    ddlSampleStatusType.Visible = False
                                    lblFunctionalAreaName.Visible = True
                                    ddlFunctionalArea.Visible = False
                                Else
                                    lblSampleStatusTypeName.Visible = False
                                    ddlSampleStatusType.DataSource = ddlAccessionConditionTypes.Items
                                    ddlSampleStatusType.DataTextField = "Text"
                                    ddlSampleStatusType.DataValueField = "Value"
                                    ddlSampleStatusType.DataBind()
                                    ddlSampleStatusType.Visible = True
                                    ddlSampleStatusType.SelectedValue = If(sample.AccessionConditionTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, sample.AccessionConditionTypeID)

                                    lblFunctionalAreaName.Visible = False
                                    ddlFunctionalArea.DataSource = ddlFunctionalAreas.Items
                                    ddlFunctionalArea.DataTextField = "Text"
                                    ddlFunctionalArea.DataValueField = "Value"
                                    ddlFunctionalArea.DataBind()
                                    ddlFunctionalArea.Visible = True
                                    ddlFunctionalArea.SelectedValue = If(sample.FunctionalAreaID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, sample.FunctionalAreaID)
                                End If
                            Else
                                e.Row.CssClass = CSS_NO_SAVE_PENDING
                                lblSampleStatusTypeName.Visible = True
                                ddlSampleStatusType.Visible = False
                                lblFunctionalAreaName.Visible = True
                                ddlFunctionalArea.Visible = False
                            End If
                        End If
                    End If
                End If
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
    Protected Sub Samples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSamples.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelectAll
                        Dim btnToggleAllSamples As LinkButton = CType(e.CommandSource, LinkButton)
                        Dim toggleIndicator As Boolean = False

                        If btnToggleAllSamples.CssClass = CSS_BTN_GLYPHICON_UNCHECKED Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleAllSamples(toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.ToggleSelect
                        Dim toggleIndicator As Boolean = False

                        If CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel)).Where(Function(x) x.SampleID = e.CommandArgument).FirstOrDefault().RowSelectionIndicator = 0 Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleSamples(sampleID:=e.CommandArgument, toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.EditCommand
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditSample.ToString()
                        InitializeControl(LaboratoryModuleTabConstants.Samples, sampleID:=CType(e.CommandArgument, Long))
                    Case GridViewCommandConstants.MyFavoriteCommand
                        Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel)).Where(Function(x) x.SampleID = e.CommandArgument).ToList()
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite As LabFavoriteGetListModel
                        For Each item As LabSampleGetListModel In samples
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .AccessionDate = item.AccessionDate
                                .AccessionedIndicator = item.AccessionIndicator
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSLocalFieldSampleID = item.EIDSSLocalFieldSampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .SampleTypeName = item.SampleTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next
                        SetMyFavorite(False, favorites)
                        btnSamplesSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                        upSamplesSave.Update()
                        upTesting.Update()
                        upTransferred.Update()
                        upBatches.Update()
                    Case GridViewCommandConstants.SelectAllRecordsMyFavoriteCommand
                        Dim selectAll As Boolean = False
                        Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel)).ToList()
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite = New LabFavoriteGetListModel()

                        If samples Is Nothing Then
                            samples = New List(Of LabSampleGetListModel)()
                        End If

                        If samples.Where(Function(x) x.FavoriteIndicator = 1).Count < samples.Count() Then
                            selectAll = True
                        End If

                        For Each item As LabSampleGetListModel In samples
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .AccessionDate = item.AccessionDate
                                .AccessionedIndicator = item.AccessionIndicator
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSLocalFieldSampleID = item.EIDSSLocalFieldSampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .SampleTypeName = item.SampleTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next

                        SetMyFavorite(selectAll, favorites)
                        btnSamplesSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        upSamplesSave.Update()
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Samples_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvSamples.Sorting

        Try
            ViewState(SAMPLES_SORT_DIRECTION) = IIf(ViewState(SAMPLES_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(SAMPLES_SORT_EXPRESSION) = e.SortExpression

            FillDropDowns()

            BindSamplesGridView()

            upSamples.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillSamplesPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divSamplesPager.Visible = True

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
            rptSamplesPager.DataSource = pages
            rptSamplesPager.DataBind()
        Else
            divSamplesPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SamplesPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            lblSamplesPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvSamples.PageSize)

            FillDropDowns()

            If Not ViewState(SAMPLES_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvSamples.PageIndex = gvSamples.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvSamples.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvSamples.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvSamples.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvSamples.PageIndex = gvSamples.PageSize - 1
                        Else
                            gvSamples.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillSamplesList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvSamples.PageIndex = gvSamples.PageSize - 1
                Else
                    gvSamples.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindSamplesGridView()
                FillSamplesPager(hdfSamplesCount.Value, pageIndex)
            End If

            upSamples.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleSamples(sampleID As Long, toggleIndicator As Boolean)

        Try
            Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            If samples Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
            End If

            If toggleIndicator = True Then
                samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowSelectionIndicator = 1
                If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 0 Then
                    btnAccession.Disabled = False
                    hdfUnaccessionedSamplesSelectedCount.Value += 1
                    btnSamplesAssignTest.Enabled = False
                    btnSamplesAliquot.Enabled = False
                    ucSamplesMenu.SetAssignTestDisabled(True)
                    ucSamplesMenu.SetDeleteSampleDisabled(True)
                Else
                    hdfAccessionedSamplesSelectedCount.Value += 1
                    btnSamplesAssignTest.Enabled = True
                    btnSamplesAliquot.Enabled = True
                    ucSamplesMenu.SetAssignTestDisabled(False)
                    ucSamplesMenu.SetDeleteSampleDisabled(False)
                End If

                'LUC21 - Restore Deleted Sample
                If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SampleStatusTypeID = SampleStatusTypes.Deleted Then
                    ucSamplesMenu.SetRestoreSampleDisabled(False)
                End If

                'LUC14 - Sample Destruction
                If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 0 Or
                        (samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SampleStatusTypeID = SampleStatusTypes.Destroyed Or
                        samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SampleStatusTypeID = SampleStatusTypes.MarkedForDestruction) Then
                    ucSamplesMenu.SetSampleDestructionDisabled(True)
                Else
                    ucSamplesMenu.SetSampleDestructionDisabled(False)
                End If

                upSamplesButtons.Update()
            Else
                samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowSelectionIndicator = 0
                'LUC21 - Restore Deleted Sample
                If samples.Where(Function(x) x.RowSelectionIndicator = True And x.SampleStatusTypeID = SampleStatusTypes.Deleted).Count > 0 Then
                    ucSamplesMenu.SetRestoreSampleDisabled(False)
                Else
                    ucSamplesMenu.SetRestoreSampleDisabled(True)
                End If

                If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 0 Then
                    hdfUnaccessionedSamplesSelectedCount.Value -= 1

                    If hdfUnaccessionedSamplesSelectedCount.Value = "0" Then
                        btnAccession.Disabled = True

                        upSamplesButtons.Update()
                    End If
                Else
                    hdfAccessionedSamplesSelectedCount.Value -= 1

                    If hdfAccessionedSamplesSelectedCount.Value = "0" Then
                        btnSamplesAssignTest.Enabled = False

                        upSamplesButtons.Update()
                    End If
                End If
            End If

            Session(SESSION_SAMPLES_LIST) = samples
            FillDropDowns()
            gvSamples.PageIndex = lblSamplesPageNumber.Text - 1
            BindSamplesGridView()
            upSamplesMenu.Update()
            upSamplesButtons.Update()
            upSamples.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the samples select/deselect all toggle event.
    ''' </summary>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleAllSamples(toggleIndicator As Boolean)

        Try
            Dim index As Integer = 0
            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))

            If toggleIndicator = True Then
                For Each sample In samples
                    samples(index).RowSelectionIndicator = 1

                    If samples(index).AccessionIndicator = 0 Then
                        btnAccession.Disabled = False
                        btnSamplesAliquot.Enabled = False
                        hdfUnaccessionedSamplesSelectedCount.Value += 1
                    Else
                        btnSamplesAssignTest.Enabled = True
                        btnSamplesAliquot.Enabled = True
                        hdfAccessionedSamplesSelectedCount.Value += 1
                    End If

                    index += 1
                Next
            Else
                For Each sample In samples
                    samples(index).RowSelectionIndicator = 0

                    index += 1
                Next

                btnAccession.Disabled = True
                btnSamplesAssignTest.Enabled = False
                btnSamplesAliquot.Enabled = False

                hdfUnaccessionedSamplesSelectedCount.Value = 0
            End If

            Session(SESSION_SAMPLES_LIST) = samples
            FillDropDowns()
            gvSamples.PageIndex = lblSamplesPageNumber.Text - 1
            BindSamplesGridView()
            upSamplesMenu.Update()
            upSamplesButtons.Update()
            upSamples.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub


    ''' <summary>
    ''' Validates samples selected by the user for accessioning meet the business rules.
    ''' </summary>
    ''' <param name="samples">Samples selected for accessioning into the lab.</param>
    ''' <param name="errorMessages">Validation error messages returned to display back to the user.</param>
    ''' <returns></returns>
    Private Function ValidateAccessioningIn(ByVal samples As List(Of LabSampleGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each sample In samples
            If Not sample.AccessionConditionTypeID Is Nothing Then
                If (sample.AccessionConditionTypeID.ToString() = AccessionConditionTypes.AcceptedInPoorCondition Or
                sample.AccessionConditionTypeID.ToString() = AccessionConditionTypes.Rejected) Then
                    If sample.AccessionComment.IsValueNullOrEmpty() Then
                        errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Required") & "</p>")
                        validateStatus = False
                    ElseIf sample.AccessionComment.Length < 7 Then
                        errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Length") & "</p>")
                        validateStatus = False
                    End If
                End If
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PrintBarCodes_CheckedChanged(sender As Object, e As EventArgs) Handles chkSamplePrintBarcodes.CheckedChanged

        ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, SHOW_ACCESSION_IN_POPOVER_SCRIPT, True)

    End Sub

    ''' <summary>
    ''' Event handler for the sample status drop down list selected index changed event.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SamplesSampleStatusType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddlSamplesSampleStatusType As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddlSamplesSampleStatusType.NamingContainer, GridViewRow)
            Dim dataKey As String = gvSamples.DataKeys(row.RowIndex).Value.ToString()

            UpdateAccessionCondition(accessionConditionTypeID:=ddlSamplesSampleStatusType.SelectedValue, sampleID:=dataKey)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the empty comment text box text changed event.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SamplesCommentTextBoxEmpty_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txtAccessionComment As TextBox = sender
            Dim row As GridViewRow = TryCast(txtAccessionComment.NamingContainer, GridViewRow)
            Dim dataKey As String = gvSamples.DataKeys(row.RowIndex).Value.ToString()

            UpdateAccessionComment(txtAccessionComment.Text, dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the comment text box text changed event.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SamplesCommentTextBox_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txtAccessionComment As TextBox = sender
            Dim row As GridViewRow = TryCast(txtAccessionComment.NamingContainer, GridViewRow)
            Dim dataKey As String = gvSamples.DataKeys(row.RowIndex).Value.ToString()

            UpdateAccessionComment(txtAccessionComment.Text, dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the functional area drop down selected index changed event.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SamplesFunctionalArea_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddlSamplesFunctionalArea As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddlSamplesFunctionalArea.NamingContainer, GridViewRow)
            Dim dataKey As String = gvSamples.DataKeys(row.RowIndex).Value.ToString()

            UpdateFunctionalArea(functionalAreaID:=ddlSamplesFunctionalArea.SelectedValue, functionalAreaName:=ddlSamplesFunctionalArea.SelectedItem.Text, sampleID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="accessionConditionTypeID"></param>
    ''' <param name="sampleID"></param>
    Public Sub UpdateAccessionCondition(ByVal accessionConditionTypeID As String,
                                        ByVal sampleID As Long)

        Try
            Dim gridViewList As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim pendingSaveList As List(Of LabSampleGetListModel)
            If Session(SESSION_SAMPLES_SAVE_LIST) Is Nothing Then
                pendingSaveList = New List(Of LabSampleGetListModel)()
            Else
                pendingSaveList = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            End If

            gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionTypeID = If(accessionConditionTypeID.IsValueNullOrEmpty, Nothing, accessionConditionTypeID)

            Select Case accessionConditionTypeID
                Case AccessionConditionTypes.AcceptedInGoodCondition
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 1
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionDate = Date.Now
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionByPersonID = hdfPersonID.Value
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().CurrentSiteID = hdfSiteID.Value
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionOrSampleStatusTypeName = If(accessionConditionTypeID.IsValueNullOrEmpty, Nothing, Resources.Labels.Lbl_Accepted_In_Good_Condition_Text)
                Case AccessionConditionTypes.AcceptedInPoorCondition
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 1
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionDate = Date.Now
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionByPersonID = hdfPersonID.Value
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().CurrentSiteID = hdfSiteID.Value
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionOrSampleStatusTypeName = If(accessionConditionTypeID.IsValueNullOrEmpty, Nothing, Resources.Labels.Lbl_Accepted_In_Poor_Condition_Text)
                Case AccessionConditionTypes.Rejected
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 0
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionDate = Nothing
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionByPersonID = Nothing
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().CurrentSiteID = Nothing
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionOrSampleStatusTypeName = If(accessionConditionTypeID.IsValueNullOrEmpty, Nothing, Resources.Labels.Lbl_Rejected_Text)
            End Select

            If accessionConditionTypeID = AccessionConditionTypes.Rejected Then
                gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionDate = Nothing
                gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 0
                If sampleID > 0 Then
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Update
                Else
                    gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Insert
                End If
            Else
                If (Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Accession AndAlso
                    Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Insert AndAlso
                    Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.InsertAccession) Then
                    If sampleID > 0 Then
                        gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Accession
                    Else
                        gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.InsertAccession
                    End If
                End If
            End If

            If pendingSaveList.Where(Function(x) x.SampleID = sampleID).Count = 0 Then
                pendingSaveList.Add(gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
            Else
                Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
                pendingSaveList(index) = gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault()
            End If

            Session(SESSION_SAMPLES_LIST) = gridViewList
            Session(SESSION_SAMPLES_SAVE_LIST) = pendingSaveList
            FillDropDowns()
            gvSamples.PageIndex = 0
            lblSamplesPageNumber.Text = 1
            ViewState(SAMPLES_SORT_DIRECTION) = Nothing
            ViewState(SAMPLES_SORT_EXPRESSION) = Nothing
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)

            upSamples.Update()
            upSamplesSave.Update()
            upSamplesMenu.Update()
            upSamplesButtons.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="comment"></param>
    ''' <param name="sampleID"></param>
    Private Sub UpdateAccessionComment(ByVal comment As String,
                                      ByVal sampleID As Long)

        'TODO: Bootstrap 3.3.x appends the text when the popover container html is set to true.  
        'True must be used to support the input (textarea)/ASP.NET Text Box control for the comment.  
        'This Is a band-aid to remove the appended items and the comma it also adds.  This will need to be 
        're-checked on any upgrade of Bootstrap 4.x and greater until a JavaScript library fix is put in. - Stephen Long 07/18/2018.

        Dim gridViewList As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
        Dim pendingSaveList As List(Of LabSampleGetListModel)
        If Session(SESSION_SAMPLES_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabSampleGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
        End If

        If gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionComment.IsValueNullOrEmpty() Then
            comment = comment.Remove(comment.Length - 1)
        Else
            comment = comment.Remove(comment.Length - (gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionComment.Length + 1))
        End If

        gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionComment = If(comment = "", Nothing, comment)

        If Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Accession AndAlso
            Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Insert AndAlso
            Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.InsertAccession Then
            gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.SampleID = sampleID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault()
        End If

        Session(SESSION_SAMPLES_LIST) = gridViewList
        Session(SESSION_SAMPLES_SAVE_LIST) = pendingSaveList
        FillDropDowns()
        gvSamples.PageIndex = 0
        lblSamplesPageNumber.Text = 1
        ViewState(SAMPLES_SORT_DIRECTION) = Nothing
        ViewState(SAMPLES_SORT_EXPRESSION) = Nothing
        BindSamplesGridView()
        FillSamplesPager(hdfSamplesCount.Value, 1)

        upSamples.Update()
        upSamplesSave.Update()
        upSamplesMenu.Update()
        upSamplesButtons.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="functionalAreaID"></param>
    ''' <param name="functionalAreaName"></param>
    ''' <param name="sampleID"></param>
    Public Sub UpdateFunctionalArea(ByVal functionalAreaID As String,
                                    ByVal functionalAreaName As String,
                                    ByVal sampleID As Long)

        Dim gridViewList As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
        Dim pendingSaveList As List(Of LabSampleGetListModel)
        If Session(SESSION_SAMPLES_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabSampleGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
        End If

        gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().FunctionalAreaID = If(functionalAreaID = "", Nothing, functionalAreaID)
        gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().FunctionalAreaName = If(functionalAreaID = "", Nothing, functionalAreaName)

        If (Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Accession AndAlso
            Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Insert AndAlso
            Not gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.InsertAccession) Then
            gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.SampleID = sampleID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.SampleID = sampleID).FirstOrDefault()
        End If

        Session(SESSION_SAMPLES_LIST) = gridViewList
        Session(SESSION_SAMPLES_SAVE_LIST) = pendingSaveList
        FillDropDowns()
        lblSamplesPageNumber.Text = 1
        gvSamples.PageIndex = 0
        ViewState(SAMPLES_SORT_DIRECTION) = Nothing
        ViewState(SAMPLES_SORT_EXPRESSION) = Nothing
        BindSamplesGridView()
        FillSamplesPager(hdfSamplesCount.Value, 1)

        upSamples.Update()
        upSamplesSave.Update()
        upSamplesMenu.Update()
        upSamplesButtons.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SamplesSave_Click(sender As Object, e As EventArgs) Handles btnSamplesSave.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Validate("Samples")

            If (Page.IsValid) Then
                AddUpdateLaboratory()

                Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
                Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))

                If samples Is Nothing Then
                    samples = New List(Of LabSampleGetListModel)()
                End If

                If samplesPendingSave Is Nothing Then
                    samplesPendingSave = New List(Of LabSampleGetListModel)()
                End If
                For Each sample In samplesPendingSave
                    sample.RowSelectionIndicator = 1
                    sample.RowAction = String.Empty
                Next

                Dim index As Integer = 0

                If chkSamplePrintBarcodes.Checked = True Or hdfSamplePrintBarcodes.Value = "True" Then
                    chkSamplePrintBarcodes.Checked = False

                    For Each sample As LabSampleGetListModel In samplesPendingSave
                        If samples.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                            index = samples.FindIndex(Function(x) x.SampleID = sample.SampleID)
                            samples(index) = sample
                        End If
                        index += 1
                    Next

                    InitializePrintBarCode(LaboratoryModuleTabConstants.Samples)
                    hdfSamplePrintBarcodes.Value = "False"
                End If

                FillDropDowns()
                FillTabCounts()

                lblSamplesPageNumber.Text = 1
                gvSamples.PageIndex = 0
                FillSamplesList(pageIndex:=1, paginationSetNumber:=1)

                samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                If samples Is Nothing Then
                    samples = New List(Of LabSampleGetListModel)()
                End If

                'Keep the saved records at the top of the sort order for the grid right after saving.
                For Each sample As LabSampleGetListModel In samplesPendingSave
                    If samples.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                        index = samples.FindIndex(Function(x) x.SampleID = sample.SampleID)
                        samples(index).RowSelectionIndicator = 1
                    End If
                    index += 1
                Next
                ViewState(SAMPLES_SORT_DIRECTION) = SortConstants.Descending
                ViewState(SAMPLES_SORT_EXPRESSION) = "RowSelectionIndicator"
                Session(SESSION_SAMPLES_SAVE_LIST) = New List(Of LabSampleGetListModel)()

                BindSamplesGridView()

                FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                BindMyFavoritesGridView()

                upLaboratoryTabCounts.Update()
                upSamples.Update()
                upSamplesButtons.Update()
                upSamplesSave.Update()
                upSamplesMenu.Update()

                'VerifyUserPermissions(False)

                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            Else
                DisplayValidationErrors()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

#End Region

#Region "Add/Update Laboratory Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DisplayValidationErrors()

        'TODO:  Show the errors  modal...

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function AddUpdateLaboratory() As List(Of LabSetModel)

        Try
            If Session(SESSION_BATCHES_SAVE_LIST) Is Nothing Then
                Session(SESSION_BATCHES_SAVE_LIST) = New List(Of LabBatchGetListModel)()
            End If

            If Session(SESSION_FAVORITES_LIST) Is Nothing Then
                Session(SESSION_FAVORITES_LIST) = New List(Of LabFavoriteGetListModel)()
            End If

            If Session(SESSION_SAMPLES_SAVE_LIST) Is Nothing Then
                Session(SESSION_SAMPLES_SAVE_LIST) = New List(Of LabSampleGetListModel)()
            End If

            If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
                Session(SESSION_TESTING_SAVE_LIST) = New List(Of LabTestGetListModel)()
            End If

            If Session(SESSION_TEST_AMENDMENTS_LIST) Is Nothing Then
                Session(SESSION_TEST_AMENDMENTS_LIST) = New List(Of TestAmendmentParameters)()
            End If

            If Session(SESSION_TRANSFERRED_SAVE_LIST) Is Nothing Then
                Session(SESSION_TRANSFERRED_SAVE_LIST) = New List(Of LabTransferGetListModel)()
            End If

            If Session(SESSION_FREEZER_BOX_LOCATION_AVAILABILITY_SAVE_LIST) Is Nothing Then
                Session(SESSION_FREEZER_BOX_LOCATION_AVAILABILITY_SAVE_LIST) = New List(Of FreezerBoxLocationAvailabilityParameters)()
            End If

            If Session(SESSION_NOTIFICATIONS_SAVE_LIST) Is Nothing Then
                Session(SESSION_NOTIFICATIONS_SAVE_LIST) = New List(Of NotificationSetParameters)()
            End If

            Dim parameters As LaboratorySetParameters = New LaboratorySetParameters With {
                .LanguageID = GetCurrentLanguage(),
                .Samples = BuildSampleParameters(CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))),
                .BatchTests = BuildBatchTestParameters(CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))),
                .Tests = BuildTestParameters(CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))),
                .TestAmendments = CType(Session(SESSION_TEST_AMENDMENTS_LIST), List(Of TestAmendmentParameters)),
                .Transfers = BuildTransferParameters(CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))),
                .FreezerBoxLocationAvailabilities = CType(Session(SESSION_FREEZER_BOX_LOCATION_AVAILABILITY_SAVE_LIST), List(Of FreezerBoxLocationAvailabilityParameters)),
                .Notifications = CType(Session(SESSION_NOTIFICATIONS_SAVE_LIST), List(Of NotificationSetParameters)),
                .UserID = hdfUserID.Value,
                .Favorites = BuildFavorites(CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel)))
            }

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If
            Dim returnResults As List(Of LabSetModel) = LaboratoryAPIService.SaveLaboratoryAsync(parameters).Result

            If returnResults.Count = 0 Then
                ShowErrorMessage(messageType:=MessageType.CannotAddUpdate)
            Else
                If returnResults.FirstOrDefault().ReturnCode = 0 Then
                    ShowSuccessMessage(MessageType.AddUpdateSuccess)

                    Session(SESSION_TEST_AMENDMENTS_LIST) = New List(Of TestAmendmentParameters)()
                Else
                    ShowWarningMessage(messageType:=MessageType.CannotAddUpdate, isConfirm:=False)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
        End Try

        Return New List(Of LabSetModel)()

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <returns></returns>
    Private Function BuildSampleParameters(samples As List(Of LabSampleGetListModel)) As List(Of LaboratorySampleParameters)

        Dim sampleParameters As List(Of LaboratorySampleParameters) = New List(Of LaboratorySampleParameters)()
        Dim sampleParameter As LaboratorySampleParameters

        For Each sampleModel As LabSampleGetListModel In samples
            sampleParameter = New LaboratorySampleParameters()
            With sampleParameter
                .AccessionByPersonID = sampleModel.AccessionByPersonID
                .AccessionComment = sampleModel.AccessionComment
                .AccessionConditionTypeID = sampleModel.AccessionConditionTypeID
                .AccessionDate = sampleModel.AccessionDate
                .AnimalID = sampleModel.AnimalID
                .BirdStatusTypeID = sampleModel.BirdStatusTypeID
                .CurrentSiteID = sampleModel.CurrentSiteID
                .DestroyedByPersonID = sampleModel.DestroyedByPersonID
                .DestructionDate = sampleModel.DestructionDate
                .DestructionMethodTypeID = sampleModel.DestructionMethodTypeID
                .DiseaseID = sampleModel.DiseaseID
                .EIDSSLocalFieldSampleID = sampleModel.EIDSSLocalFieldSampleID
                .EIDSSLaboratorySampleID = sampleModel.EIDSSLaboratorySampleID
                .EnteredDate = sampleModel.EnteredDate
                .FavoriteIndicator = sampleModel.FavoriteIndicator
                .CollectedByOrganizationID = sampleModel.CollectedByOrganizationID
                .CollectedByPersonID = sampleModel.CollectedByPersonID
                .CollectionDate = sampleModel.CollectionDate
                .SentDate = sampleModel.SentDate
                .SentToOrganizationID = sampleModel.SentToOrganizationID
                .FreezerSubdivisionID = sampleModel.FreezerSubdivisionID
                .FunctionalAreaID = sampleModel.FunctionalAreaID
                .HumanDiseaseReportID = sampleModel.HumanDiseaseReportID
                .HumanID = sampleModel.HumanID
                .MainTestID = sampleModel.MainTestID
                .MarkedForDispositionByPersonID = sampleModel.MarkedForDispositionByPersonID
                .MonitoringSessionID = sampleModel.MonitoringSessionID
                .Note = sampleModel.Note
                .OriginalSampleID = sampleModel.ParentSampleID
                .OutOfRepositoryDate = sampleModel.OutOfRepositoryDate
                .ReadOnlyIndicator = sampleModel.ReadOnlyIndicator
                .RootSampleID = sampleModel.RootSampleID
                .RowAction = sampleModel.RowAction
                .RowStatus = sampleModel.RowStatus
                .SampleID = sampleModel.SampleID
                .SampleKindTypeID = sampleModel.SampleKindTypeID
                .SampleStatusTypeID = sampleModel.SampleStatusTypeID
                .SampleTypeID = sampleModel.SampleTypeID
                .SiteID = sampleModel.SiteID
                .SpeciesID = sampleModel.SpeciesID
                .StorageBoxPlace = sampleModel.StorageBoxPlace
                .VectorID = sampleModel.VectorID
                .VectorSessionID = sampleModel.VectorSessionID
                .VeterinaryDiseaseReportID = sampleModel.VeterinaryDiseaseReportID
            End With

            sampleParameters.Add(sampleParameter)
        Next

        Return sampleParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="batchTests"></param>
    ''' <returns></returns>
    Private Function BuildBatchTestParameters(batchTests As List(Of LabBatchGetListModel)) As List(Of BatchTestParameters)

        Dim batchTestParameters As List(Of BatchTestParameters) = New List(Of BatchTestParameters)()
        Dim batchTestParameter As BatchTestParameters

        For Each batchTestModel As LabBatchGetListModel In batchTests
            batchTestParameter = New BatchTestParameters()
            With batchTestParameter
                .BatchStatusTypeID = batchTestModel.BatchStatusTypeID
                .BatchTestID = batchTestModel.BatchTestID
                .EIDSSBatchTestID = batchTestModel.EIDSSBatchTestID
                .ObservationID = batchTestModel.ObservationID
                .PerformedByOrganizationID = batchTestModel.BatchTestPerformedByOrganizationID
                .PerformedByPersonID = batchTestModel.BatchTestPerformedByPersonID
                .PerformedDate = batchTestModel.PerformedDate
                .ResultEnteredByOrganizationID = batchTestModel.ResultEnteredByOrganizationID
                .ResultEnteredByPersonID = batchTestModel.ResultEnteredByPersonID
                .RowAction = batchTestModel.RowAction
                .RowStatus = batchTestModel.RowStatus
                .SiteID = batchTestModel.SiteID
                .TestNameTypeID = batchTestModel.TestNameTypeID
                .TestRequested = batchTestModel.TestRequested
                .ValidatedByOrganizationID = batchTestModel.ValidatedByOrganizationID
                .ValidatedByPersonID = batchTestModel.ValidatedByPersonID
                .ValidationDate = batchTestModel.ValidationDate
            End With

            batchTestParameters.Add(batchTestParameter)
        Next

        Return batchTestParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <returns></returns>
    Private Function BuildTestParameters(tests As List(Of LabTestGetListModel)) As List(Of LaboratoryTestParameters)

        Dim testParameters As List(Of LaboratoryTestParameters) = New List(Of LaboratoryTestParameters)()
        Dim testParameter As LaboratoryTestParameters

        For Each testModel As LabTestGetListModel In tests
            testParameter = New LaboratoryTestParameters()
            With testParameter
                .BatchTestID = testModel.BatchTestID
                .ConcludedDate = testModel.ResultDate
                .ContactPersonName = testModel.ContactPersonName
                .DiseaseID = testModel.DiseaseID
                .ExternalTestIndicator = testModel.ExternalTestIndicator
                .NonLaboratoryTestIndicator = testModel.NonLaboratoryTestIndicator
                .Note = testModel.Note
                .PerformedByOrganizationID = testModel.PerformedByOrganizationID
                .PreviousTestStatusTypeID = testModel.PreviousTestStatusTypeID
                .ReadOnlyIndicator = testModel.ReadOnlyIndicator
                .ReceivedDate = testModel.ReceivedDate
                .ResultEnteredByOrganizationID = testModel.ResultEnteredByOrganizationID
                .ResultEnteredByPersonID = testModel.ResultEnteredByPersonID
                .RowAction = testModel.RowAction
                .RowStatus = testModel.RowStatus
                .SampleID = testModel.SampleID
                .StartedDate = testModel.StartedDate
                .TestCategoryTypeID = testModel.TestCategoryTypeID
                .TestedByOrganizationID = testModel.TestedByOrganizationID
                .TestedByPersonID = testModel.TestedByPersonID
                .TestID = testModel.TestID
                .TestNameTypeID = testModel.TestNameTypeID
                .TestNumber = testModel.TestNumber
                .TestResultTypeID = testModel.TestResultTypeID
                .TestStatusTypeID = testModel.TestStatusTypeID
                .ValidatedByOrganizationID = testModel.ValidatedByOrganizationID
                .ValidatedByPersonID = testModel.ValidatedByPersonID
            End With

            testParameters.Add(testParameter)
        Next

        Return testParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transfers"></param>
    ''' <returns></returns>
    Private Function BuildTransferParameters(transfers As List(Of LabTransferGetListModel)) As List(Of LaboratoryTransferParameters)

        Dim transferParameters As List(Of LaboratoryTransferParameters) = New List(Of LaboratoryTransferParameters)()
        Dim transferParameter As LaboratoryTransferParameters

        For Each transferModel As LabTransferGetListModel In transfers
            transferParameter = New LaboratoryTransferParameters()
            With transferParameter
                .EIDSSTransferID = transferModel.EIDSSTransferID
                .PurposeOfTransfer = transferModel.PurposeOfTransfer
                .RowAction = transferModel.RowAction
                .RowStatus = transferModel.RowStatus
                .SampleID = transferModel.TransferredOutSampleID
                .SentByPersonID = transferModel.SentByPersonID
                .TransferDate = transferModel.TransferDate
                .TransferredFromOrganizationID = transferModel.TransferredFromOrganizationID
                .TransferredToOrganizationID = transferModel.TransferredToOrganizationID
                .SiteID = transferModel.SiteID
                .TestRequested = transferModel.TestRequested
                .TransferID = transferModel.TransferID
                .TransferStatusTypeID = transferModel.TransferStatusTypeID
            End With

            transferParameters.Add(transferParameter)
        Next

        Return transferParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="favorites"></param>
    ''' <returns></returns>
    Private Function BuildFavorites(favorites As List(Of LabFavoriteGetListModel)) As String

        Dim favoritesXML As String = Nothing

        favorites = favorites.GroupBy(Function(x) x.SampleID).Select(Function(y) y.First()).ToList

        If favorites.Count > 0 Then
            favoritesXML = "<Favorites>"
            For Each favoriteModel As LabFavoriteGetListModel In favorites
                favoritesXML &= "<Favorite SampleID=""" & favoriteModel.SampleID & """ />"
            Next
            favoritesXML &= "</Favorites>"
        Else
            favoritesXML = "<Favorites></Favorites>"
        End If

        Return favoritesXML

    End Function

#End Region

#Region "Accession In Methods"

    ''' <summary>
    ''' Event handler for the accession in drop down list selected index changed event.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub AccessionIn_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlAccessionIn.SelectedIndexChanged

        Try
            Dim accessionConditionTypeID As String = ddlAccessionIn.SelectedValue
            Dim index As Integer = 0

            If accessionConditionTypeID = AccessionConditionTypes.Rejected Then
                chkSamplePrintBarcodes.Checked = False
                chkSamplePrintBarcodes.Enabled = False
            Else
                chkSamplePrintBarcodes.Enabled = True
            End If

            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            If samples Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
            End If

            Dim samplesPendingSave As List(Of LabSampleGetListModel)
            If Session(SESSION_SAMPLES_SAVE_LIST) Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            Else
                samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            End If

            Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
            If transfers Is Nothing Then
                transfers = New List(Of LabTransferGetListModel)()
            End If

            Dim transfersPendingSave = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))
            If transfersPendingSave Is Nothing Then
                transfersPendingSave = New List(Of LabTransferGetListModel)()
            End If

            For Each gvr As GridViewRow In gvSamples.Rows
                If CType(gvr.FindControl("btnToggleSamples"), LinkButton).CssClass = CSS_BTN_GLYPHICON_CHECKED Then
                    Dim sampleID = CType(gvr.FindControl("btnSamplesEdit"), LinkButton).CommandArgument
                    If accessionConditionTypeID = AccessionConditionTypes.Rejected Then
                        If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SampleID > 0 Then
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Update
                        Else
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Insert
                        End If

                        If samplesPendingSave.Where(Function(x) x.SampleID = sampleID).Count = 0 Then
                            samplesPendingSave.Add(samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
                        End If

                        samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionTypeID = accessionConditionTypeID
                        samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionOrSampleStatusTypeName = ddlAccessionIn.SelectedItem.Text

                        'Is this a transferred in sample?
                        'Deferred for a later release.  BA Team will consider this part of the workflow on a post release of EIDSS.
                        'If samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SampleKindTypeID = SampleKindTypes.TransferredIn Then
                        '    Dim transferParameters = New LaboratoryTransferGetListParameters With {.LanguageID = GetCurrentLanguage(), .SampleID = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().ParentSampleID}
                        '    Dim transfer As LabTransferGetListModel

                        '    If LaboratoryAPIService Is Nothing Then
                        '        LaboratoryAPIService = New LaboratoryServiceClient()
                        '    End If
                        '    transfer = LaboratoryAPIService.LaboratoryTransferGetListAsync(transferParameters).Result.FirstOrDefault()

                        '    transfer.TransferStatusTypeID = TransferStatusTypes.Declined
                        '    transfer.RowAction = RecordConstants.Update

                        '    If transfers.Where(Function(x) x.TransferID = transfer.TransferID).Count > 0 Then
                        '        transfers(transfers.IndexOf(transfer)) = transfer
                        '    Else
                        '        transfers.Add(transfer)
                        '    End If

                        '    If transfersPendingSave.Where(Function(x) x.TransferID = transfer.TransferID).Count > 0 Then
                        '        transfersPendingSave(transfersPendingSave.IndexOf(transfer)) = transfer
                        '    Else
                        '        transfersPendingSave.Add(transfer)
                        '    End If

                        '    Session(SESSION_TRANSFERRED_LIST) = transfers
                        '    Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave

                        '    BindTransferredGridView()
                        'End If
                    Else
                        If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 0 Then
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionTypeID = accessionConditionTypeID
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionOrSampleStatusTypeName = ddlAccessionIn.SelectedItem.Text
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionDate = Date.Now
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 1
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionByPersonID = hdfPersonID.Value
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SiteID = hdfSiteID.Value
                            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().CurrentSiteID = hdfSiteID.Value

                            If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SampleID > 0 Then
                                samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Accession
                            Else
                                samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.InsertAccession
                            End If

                            If samplesPendingSave.Where(Function(x) x.SampleID = sampleID).Count = 0 Then
                                samplesPendingSave.Add(samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())
                            End If

                            samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionTypeID = accessionConditionTypeID
                            samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionConditionOrSampleStatusTypeName = ddlAccessionIn.SelectedItem.Text
                            samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionDate = Date.Now
                            samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionIndicator = 1
                            samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().AccessionByPersonID = hdfPersonID.Value
                            samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SiteID = hdfSiteID.Value
                            samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().CurrentSiteID = hdfSiteID.Value

                            If samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().SampleID > 0 Then
                                samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.Accession
                            Else
                                samplesPendingSave.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowAction = RecordConstants.InsertAccession
                            End If
                        End If
                    End If
                End If
            Next

            Session(SESSION_SAMPLES_LIST) = samples
            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
            FillDropDowns()
            gvSamples.PageIndex = 0
            lblSamplesPageNumber.Text = 1
            ViewState(SAMPLES_SORT_DIRECTION) = Nothing
            ViewState(SAMPLES_SORT_EXPRESSION) = Nothing
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)

            upSamples.Update()
            upSamplesSave.Update()
            upSamplesButtons.Update()
            upSamplesMenu.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, SHOW_ACCESSION_IN_POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Function AccessionInTransferredSample(ByVal rootSampleID As Long) As LabTransferGetListModel

        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If

        Dim transferParameters = New LaboratoryTransferGetListParameters With {.PaginationSetNumber = 1, .SampleID = rootSampleID}
        Dim transfer = LaboratoryAPIService.LaboratoryTransferGetListAsync(parameters:=transferParameters).Result.FirstOrDefault()
        transfer.TransferStatusTypeID = TransferStatusTypes.Final

        Return transfer

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub AccessionIn()

        Try
            Dim index As Integer = 0
            Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim errorMessages As New StringBuilder()

            If samples Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
            End If

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            If ValidateAccessioningIn(samples.Where(Function(x) x.RowSelectionIndicator = 1).ToList(), errorMessages:=errorMessages) = True Then
                For Each sample In samples
                    If samples(index).RowSelectionIndicator = 1 Then
                        If Not sample.AccessionConditionTypeID Is Nothing Then
                            If samples(index).AccessionConditionTypeID = AccessionConditionTypes.Rejected Then
                                samples(index).AccessionIndicator = 0
                                samples(index).SampleTypeID = Nothing

                                If samples(index).SampleID > 0 Then
                                    samples(index).RowAction = RecordConstants.Update

                                    If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count = 0 Then
                                        samplesPendingSave.Add(sample)
                                    Else
                                        samplesPendingSave(samplesPendingSave.IndexOf(samples(index))) = samples(index)
                                    End If
                                Else
                                    samples(index).RowAction = RecordConstants.Insert
                                    samplesPendingSave.Add(samples(index))
                                End If
                            Else
                                samples(index).SampleStatusTypeID = SampleStatusTypes.InRepository
                                samples(index).AccessionIndicator = 1
                                samples(index).AccessionDate = Date.Now
                                samples(index).AccessionByPersonID = hdfPersonID.Value
                                samples(index).CurrentSiteID = hdfSiteID.Value

                                If samples(index).SampleID > 0 Then
                                    samples(index).RowAction = RecordConstants.Accession
                                    If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count = 0 Then
                                        samplesPendingSave.Add(sample)
                                    Else
                                        samplesPendingSave(samplesPendingSave.IndexOf(samples(index))) = samples(index)
                                    End If
                                Else
                                    samples(index).RowAction = RecordConstants.InsertAccession
                                    If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count = 0 Then
                                        samplesPendingSave.Add(sample)
                                    Else
                                        samplesPendingSave(samplesPendingSave.IndexOf(samples(index))) = samples(index)
                                    End If
                                End If
                            End If
                        End If
                    End If

                    index += 1
                Next

                If samples.Where(Function(x) x.RowAction = RecordConstants.Accession Or x.RowAction = RecordConstants.InsertAccession Or x.RowAction = RecordConstants.Update And x.AccessionIndicator = 1).Count() > 0 Then
                    Session(SESSION_SAMPLES_LIST) = samples
                    Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave

                    ShowWarningMessage(messageType:=MessageType.PrintBarcodes, isConfirm:=True)

                    lblSamplesCount.Text = samples.ToList().Where(Function(x) x.AccessionIndicator = 0).Count
                    upLaboratoryTabCounts.Update()
                Else
                    ShowWarningMessage(messageType:=MessageType.NoSamplesToAccession, isConfirm:=False)
                End If
            Else
                ShowErrorMessage(messageType:=MessageType.CannotAccession, message:=errorMessages.ToString())
            End If

            FillDropDowns()
            gvSamples.PageIndex = 0
            lblSamplesPageNumber.Text = 1
            ViewState(SAMPLES_SORT_DIRECTION) = Nothing
            ViewState(SAMPLES_SORT_EXPRESSION) = Nothing
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)

            upSamples.Update()
            upSamplesSave.Update()
            upSamplesButtons.Update()
            upSamplesMenu.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Assign Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tab"></param>
    Private Sub InitializeAssignTests(ByVal tab As String)

        Try
            Select Case tab
                Case LaboratoryModuleTabConstants.Samples.ToString()
                    Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                    Dim selectedSamples = New List(Of LabSampleGetListModel)()

                    If samples Is Nothing Then
                        samples = New List(Of LabSampleGetListModel)()
                    End If

                    For Each sample In samples
                        If sample.RowSelectionIndicator = 1 Then
                            If sample.AccessionIndicator = 1 Then
                                selectedSamples.Add(sample)
                                If hdfDiseaseIDList.Value.IsValueNullOrEmpty() Then
                                    hdfDiseaseIDList.Value = sample.DiseaseID
                                Else
                                    hdfDiseaseIDList.Value += hdfDiseaseIDList.Value + "," + sample.DiseaseID
                                End If
                            End If
                        End If
                    Next

                    If selectedSamples.Count = 0 Then
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAssignTestModal"), True)
                        ShowWarningMessage(messageType:=MessageType.CannotAssignTest, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Sample_Must_Be_Accessioned_Assign_Test_Body_Text"))
                    Else
                        ucAssignTest.Setup(diseaseIDList:=hdfDiseaseIDList.Value)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAssignTestModal"), True)
                    End If
                Case LaboratoryModuleTabConstants.Testing.ToString()
                    Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
                    Dim selectedTests = New List(Of LabTestGetListModel)()

                    If tests Is Nothing Then
                        tests = New List(Of LabTestGetListModel)()
                        Session(SESSION_TESTING_LIST) = tests
                    End If

                    For Each test In tests
                        If test.RowSelectionIndicator = 1 Then
                            selectedTests.Add(test)

                            If hdfDiseaseIDList.Value.IsValueNullOrEmpty() Then
                                hdfDiseaseIDList.Value = test.DiseaseID
                            Else
                                hdfDiseaseIDList.Value += hdfDiseaseIDList.Value + "," + test.DiseaseID
                            End If
                        End If
                    Next

                    If selectedTests.Count = 0 Then
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAssignTestModal"), True)
                        ShowWarningMessage(messageType:=MessageType.CannotAssignTest, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Sample_Must_Be_Accessioned_Assign_Test_Body_Text"))
                    Else
                        ucAssignTest.Setup(diseaseIDList:=hdfDiseaseIDList.Value)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAssignTestModal"), True)
                    End If
                Case LaboratoryModuleTabConstants.MyFavorites.ToString()
                    Dim myFavorites = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))
                    Dim selectedMyFavorites = New List(Of LabFavoriteGetListModel)()

                    If myFavorites Is Nothing Then
                        myFavorites = New List(Of LabFavoriteGetListModel)()
                        Session(SESSION_FAVORITES_LIST) = myFavorites
                    End If

                    For Each myFavorite In myFavorites
                        If myFavorite.RowSelectionIndicator = 1 Then
                            selectedMyFavorites.Add(myFavorite)

                            If hdfDiseaseIDList.Value.IsValueNullOrEmpty() Then
                                hdfDiseaseIDList.Value = myFavorite.DiseaseID
                            Else
                                hdfDiseaseIDList.Value += hdfDiseaseIDList.Value + "," + myFavorite.DiseaseID
                            End If
                        End If
                    Next

                    If selectedMyFavorites.Count = 0 Then
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAssignTestModal"), True)
                        ShowWarningMessage(messageType:=MessageType.CannotAssignTest, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Sample_Must_Be_Accessioned_Assign_Test_Body_Text"))
                    Else
                        ucAssignTest.Setup(diseaseIDList:=hdfDiseaseIDList.Value)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAssignTestModal"), True)
                    End If
                Case LaboratoryModuleTabConstants.Transferred.ToString()
                    Dim transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
                    Dim selectedTransfers = New List(Of LabTransferGetListModel)()

                    If transfers Is Nothing Then
                        transfers = New List(Of LabTransferGetListModel)()
                        Session(SESSION_TRANSFERRED_LIST) = transfers
                    End If

                    For Each transfer In transfers
                        If transfer.RowSelectionIndicator = 1 Then
                            selectedTransfers.Add(transfer)

                            If hdfDiseaseIDList.Value.IsValueNullOrEmpty() Then
                                hdfDiseaseIDList.Value = transfer.DiseaseID
                            Else
                                hdfDiseaseIDList.Value += hdfDiseaseIDList.Value + "," + transfer.DiseaseID
                            End If
                        End If
                    Next

                    If selectedTransfers.Count = 0 Then
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAssignTestModal"), True)
                        ShowWarningMessage(messageType:=MessageType.CannotAssignTest, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Sample_Must_Be_Accessioned_Assign_Test_Body_Text"))
                    Else
                        ucAssignTest.Setup(diseaseIDList:=hdfDiseaseIDList.Value)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAssignTestModal"), True)
                    End If
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the assign test button click event.
    ''' </summary>
    Protected Sub SamplesAssignTest_Click(sender As Object, e As EventArgs) Handles btnSamplesAssignTest.Click

        Try
            InitializeAssignTests(LaboratoryModuleTabConstants.Samples.ToString)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the assign test button click event.
    ''' </summary>
    Protected Sub TestingAssignTest_Click(sender As Object, e As EventArgs) Handles btnTestingAssignTest.Click

        Try
            InitializeAssignTests(LaboratoryModuleTabConstants.Testing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the assign test button click event.
    ''' </summary>
    Protected Sub MyFavoritesAssignTest_Click(sender As Object, e As EventArgs) Handles btnMyFavoritesAssignTest.Click

        Try
            InitializeAssignTests(tab:=LaboratoryModuleTabConstants.MyFavorites)
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
    Protected Sub AssignTestSave_Click(sender As Object, e As EventArgs) Handles btnAssignTestSave.Click

        Try
            Dim testing As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            Dim pendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim testAssignments = New List(Of LabTestGetListModel)()

            If testing Is Nothing Then
                FillTestingList(pageIndex:=1, paginationSetNumber:=1)
                testing = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            End If

            If pendingSave Is Nothing Then
                pendingSave = New List(Of LabTestGetListModel)()
            End If

            FillDropDowns()

            Select Case hdfCurrentTab.Value
                Case LaboratoryModuleTabConstants.Samples.ToString()
                    Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                    If samples Is Nothing Then
                        samples = New List(Of LabSampleGetListModel)()
                        Session(SESSION_SAMPLES_LIST) = samples
                    End If

                    testAssignments = ucAssignTest.AssignTests(hdfCurrentTab.Value, samples.Where(Function(x) x.RowSelectionIndicator = 1).ToList(), Nothing, Nothing, Nothing)

                    samples.RemoveAll(Function(x) x.RowSelectionIndicator = 1)
                    Session(SESSION_SAMPLES_LIST) = samples
                    BindSamplesGridView()
                    hdfSamplesCount.Value = samples.Count
                Case LaboratoryModuleTabConstants.Testing.ToString()
                    testAssignments = ucAssignTest.AssignTests(hdfCurrentTab.Value, Nothing, testing.Where(Function(x) x.RowSelectionIndicator = 1).ToList(), Nothing, Nothing)
                Case LaboratoryModuleTabConstants.Transferred.ToString()
                    Dim transferred = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
                    If transferred Is Nothing Then
                        transferred = New List(Of LabTransferGetListModel)()
                        Session(SESSION_TRANSFERRED_LIST) = transferred
                    End If

                    testAssignments = ucAssignTest.AssignTests(hdfCurrentTab.Value, Nothing, Nothing, transferred.Where(Function(x) x.RowSelectionIndicator = 1).ToList(), Nothing)

                    BindTransferredGridView()
                Case LaboratoryModuleTabConstants.MyFavorites.ToString()
                    Dim myFavorites = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))

                    If myFavorites Is Nothing Then
                        myFavorites = New List(Of LabFavoriteGetListModel)()
                        Session(SESSION_FAVORITES_LIST) = myFavorites
                    End If

                    BindMyFavoritesGridView()

                    testAssignments = ucAssignTest.AssignTests(hdfCurrentTab.Value, Nothing, Nothing, Nothing, myFavorites.Where(Function(x) x.RowSelectionIndicator = 1).ToList())
            End Select

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)

            If testAssignments.Count > 0 Then
                testing.AddRange(testAssignments)
                pendingSave.AddRange(testAssignments)

                lblTestingCount.Text = testing.ToList().Where(Function(x) x.TestStatusTypeID = TestStatusTypes.InProgress).Count
                hdfTestingCount.Value = testing.ToList().Count

                Session(SESSION_TESTING_LIST) = testing
                Session(SESSION_TESTING_SAVE_LIST) = pendingSave
                BindTestingGridView()

                upSamplesSave.Update()
                upTestingSave.Update()
                upSamples.Update()
                upTesting.Update()
                upTransferredSave.Update()
                upTransferred.Update()
                upMyFavoritesSave.Update()
                upMyFavorites.Update()
                upLaboratoryTabCounts.Update()

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "hideModal('#divAssignTestModal');", True)

                hdfCurrentModuleAction.Value = LaboratoryModuleActions.None
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub AssignTest_ShowErrorModal(messageType As MessageType, message As String) Handles ucAssignTest.ShowErrorModal

        Try
            ShowErrorMessage(messageType:=messageType, message:=message)
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
    Protected Sub CancelAssignTest_Click(sender As Object, e As EventArgs) Handles btnCancelAssignTest.Click

        Try
            hdfCurrentModuleAction.Value = ucAssignTest.ID
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Print Bar Code Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub InitializePrintBarCode(tab As String)

        Try
            'TODO: Verify Permissions
            'TODO: Check for records meeting criteria (selected with a local/field sample ID.

            Dim index As Integer = 0
            Dim selectedSamples = New List(Of LabSampleGetListModel)()
            Dim sample As LabSampleGetListModel

            Select Case tab
                Case LaboratoryModuleTabConstants.Samples
                    Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                    For Each sample In samples
                        If samples(index).RowSelectionIndicator = 1 Then
                            selectedSamples.Add(samples(index))
                        End If

                        index += 1
                    Next

                    If selectedSamples.Count = 0 Then
                        ShowWarningMessage(messageType:=MessageType.NoSamplesToPrintBarCodes, isConfirm:=False)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divPrintBarCodesModal"), True)
                    Else
                        ucPrintBarCode.Setup(selectedSamples)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divPrintBarCodesModal"), True)
                    End If
                Case LaboratoryModuleTabConstants.Testing
                    Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
                    For Each test In tests
                        If tests(index).RowSelectionIndicator = 1 Then
                            sample = New LabSampleGetListModel With {
                                        .SampleID = tests(index).SampleID,
                                        .EIDSSLaboratorySampleID = tests(index).EIDSSLaboratorySampleID,
                                        .PatientFarmOwnerName = tests(index).PatientFarmOwnerName
                                    }
                            selectedSamples.Add(sample)
                        End If

                        index += 1
                    Next

                    If selectedSamples.Count = 0 Then
                        ShowWarningMessage(messageType:=MessageType.NoSamplesToPrintBarCodes, isConfirm:=False)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divPrintBarCodesModal"), True)
                    Else
                        ucPrintBarCode.Setup(selectedSamples)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divPrintBarCodesModal"), True)
                    End If
                Case LaboratoryModuleTabConstants.MyFavorites
                    Dim myFavorites As List(Of LabFavoriteGetListModel) = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))
                    For Each myFavorite In myFavorites
                        If myFavorites(index).RowSelectionIndicator = 1 Then
                            sample = New LabSampleGetListModel With {
                                        .SampleID = myFavorites(index).SampleID,
                                        .EIDSSLaboratorySampleID = myFavorites(index).EIDSSLaboratorySampleID,
                                        .PatientFarmOwnerName = myFavorites(index).PatientFarmOwnerName
                                    }
                            selectedSamples.Add(sample)
                        End If

                        index += 1
                    Next

                    If selectedSamples.Count = 0 Then
                        ShowWarningMessage(messageType:=MessageType.NoSamplesToPrintBarCodes, isConfirm:=False)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divPrintBarCodesModal"), True)
                    Else
                        ucPrintBarCode.Setup(selectedSamples)
                        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divPrintBarCodesModal"), True)
                    End If
            End Select
        Catch ex As SqlClient.SqlException
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Reference Methods"

    Private Sub InitializeReference()

        'ucReference.Setup()

    End Sub

    'Protected Sub btnModalOnModalSave_Click(sender As Object, e As EventArgs) Handles btnModalOnModalAction.Click

    '    'ucReference.Save()

    '    RefreshControl()

    '    'ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL, HIDE_REFERENCE_MODAL, True)

    '    ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_ALL_SAMPLES_MODAL_ON_MODAL, True)

    'End Sub

#End Region

#Region "Group Accession In Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub InitializeGroupAccessionIn()

        ucGroupAccessionIn.Setup(siteID:=hdfSiteID.Value, personID:=hdfPersonID.Value)

        ToggleVisibility(LaboratoryModuleActions.GroupAccessionIn.ToString())

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divGroupAccessionInModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Protected Sub GroupAccession_ShowWarningModal(messageType As MessageType, message As String) Handles ucGroupAccessionIn.ShowWarningModal

        ShowWarningMessage(messageType:=messageType, isConfirm:=False, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="enabledIndicator"></param>
    Protected Sub GroupAccession_DisableEnableAccession(enabledIndicator As Boolean) Handles ucGroupAccessionIn.DisableEnableAccession

        btnGroupAccessionInAccession.Enabled = enabledIndicator

        upGroupAccessionInControls.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="recordCount"></param>
    ''' <param name="eidssLocalFieldSampleID"></param>
    Protected Sub GroupAccession_ShowSampleSelectionModal(samples As List(Of LabSampleAdvancedSearchGetListModel), recordCount As Integer, eidssLocalFieldSampleID As String) Handles ucGroupAccessionIn.ShowSampleSelectionModal

        Try
            upGroupAccessionInSelectSamples.Update()

            gvGroupAccessionInSelectSamples.DataSource = samples
            gvGroupAccessionInSelectSamples.DataBind()
            hdfGroupAccessionInSelectSamplesCount.Value = recordCount
            hdfEIDSSLocalFieldSampleID.Value = eidssLocalFieldSampleID
            Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES) = samples
            Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES_SAVE) = New List(Of LabSampleAdvancedSearchGetListModel)()
            FillGroupAccessionInSelectSamplesPager(hdfGroupAccessionInSelectSamplesCount.Value, 1)
            lblGroupAccessionInSelectSamplesPageNumber.Text = "1"
            ViewState(GROUP_ACCESSION_IN_SELECT_SAMPLES_PAGINATION_SET_NUMBER) = 1

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divGroupAccessionInSelectSamplesModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillGroupAccessionInSelectSamples(pageIndex As Integer, paginationSetNumber As Integer)

        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If
        Dim parameters = New LaboratoryAdvancedSearchParameters With {.PaginationSetNumber = paginationSetNumber, .ExactMatchEIDSSLocalFieldSampleID = hdfEIDSSLocalFieldSampleID.Value}
        Dim recordCount = LaboratoryAPIService.LaboratorySampleAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount
        Dim validatedSamples = LaboratoryAPIService.LaboratorySampleAdvancedSearchGetListAsync(parameters).Result
        FillGroupAccessionInSelectSamplesPager(recordCount, pageIndex)
        ViewState(GROUP_ACCESSION_IN_SELECT_SAMPLES_PAGINATION_SET_NUMBER) = paginationSetNumber

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindGroupAccessionInSelectSamplesGridView()

        Dim list As List(Of LabSampleAdvancedSearchGetListModel) = CType(Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES), List(Of LabSampleAdvancedSearchGetListModel))

        lblGroupAccessionInSelectSamplesPageNumber.Text = "1"
        gvGroupAccessionInSelectSamples.DataSource = list
        gvGroupAccessionInSelectSamples.DataBind()
        gvGroupAccessionInSelectSamples.PageIndex = 0

    End Sub

    Private Sub FillGroupAccessionInSelectSamplesPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

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
            pages.Add(New ListItem("<<", "1"))
        End If

        'Add the Previous Button.
        If currentPage > 1 Then
            pages.Add(New ListItem("<", (currentPage - 1).ToString()))
        End If

        Dim paginationSetNumber As Integer = 1,
            pageCounter As Integer = 1

        For i As Integer = startIndex To endIndex
            pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
        Next

        'Add the Next Button.
        If currentPage < pageCount Then
            pages.Add(New ListItem(">", (currentPage + 1).ToString()))
        End If

        'Add the Last Button.
        If currentPage <> pageCount Then
            pages.Add(New ListItem(">>", pageCount.ToString()))
        End If
        rptGroupAccessionInSelectSamples.DataSource = pages
        rptGroupAccessionInSelectSamples.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub GroupAccessionInSelectSamplesPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvGroupAccessionInSelectSamples.PageSize)

        If Not ViewState(GROUP_ACCESSION_IN_SELECT_SAMPLES_PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvGroupAccessionInSelectSamples.PageIndex = gvGroupAccessionInSelectSamples.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvGroupAccessionInSelectSamples.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvGroupAccessionInSelectSamples.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvGroupAccessionInSelectSamples.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvGroupAccessionInSelectSamples.PageIndex = gvGroupAccessionInSelectSamples.PageSize - 1
                    Else
                        gvGroupAccessionInSelectSamples.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillGroupAccessionInSelectSamples(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvGroupAccessionInSelectSamples.PageIndex = gvGroupAccessionInSelectSamples.PageSize - 1
            Else
                gvGroupAccessionInSelectSamples.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindGroupAccessionInSelectSamplesGridView()
            FillGroupAccessionInSelectSamplesPager(hdfGroupAccessionInSelectSamplesCount.Value, pageIndex)
        End If

        lblGroupAccessionInSelectSamplesPageNumber.Text = pageIndex.ToString()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub GroupAccessionInSelectSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvGroupAccessionInSelectSamples.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.ToggleSelect
                    e.Handled = True
                    Dim gvr As GridViewRow = CType(((CType(e.CommandSource, LinkButton)).NamingContainer), GridViewRow)
                    Dim btnGroupAccessionInSample As LinkButton = CType(e.CommandSource, LinkButton)
                    Dim samples As List(Of LabSampleAdvancedSearchGetListModel) = CType(Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES), List(Of LabSampleAdvancedSearchGetListModel))
                    Dim saveSamples As List(Of LabSampleAdvancedSearchGetListModel) = CType(Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES_SAVE), List(Of LabSampleAdvancedSearchGetListModel))
                    Dim samplesID As Long = btnGroupAccessionInSample.CommandArgument
                    If btnGroupAccessionInSample.CssClass = "btn glyphicon glyphicon-check" Then
                        samples.Where(Function(x) x.SampleID = samplesID).FirstOrDefault().RowSelectionIndicator = 0
                        saveSamples.Add(samples.Where(Function(x) x.SampleID = samplesID).FirstOrDefault())
                    Else
                        samples.Where(Function(x) x.SampleID = samplesID).FirstOrDefault().RowSelectionIndicator = 1
                        saveSamples.Add(samples.Where(Function(x) x.SampleID = samplesID).FirstOrDefault())
                    End If

                    Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES) = samples
                    Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES_SAVE) = saveSamples
            End Select

            BindGroupAccessionInSelectSamplesGridView()

            btnGroupAccessionInSelectSamplesSelect.Enabled = True
            upGroupAccessionInSelectSamples.Update()
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
    Protected Sub GroupAccessionInSelectSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvGroupAccessionInSelectSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim sample As LabSampleAdvancedSearchGetListModel = TryCast(e.Row.DataItem, LabSampleAdvancedSearchGetListModel)
                Dim i As Integer = 0

                If Not sample Is Nothing Then
                    Dim btnGroupAccessionInSample As LinkButton = CType(e.Row.FindControl("btnGroupAccessionInSample"), LinkButton)

                    If sample.RowSelectionIndicator = 0 Then
                        btnGroupAccessionInSample.CssClass = "btn glyphicon glyphicon-unchecked"
                    Else
                        btnGroupAccessionInSample.CssClass = "btn glyphicon glyphicon-check"
                    End If
                End If
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
    Protected Sub GroupAccessionInSelectSamplesSelect_Click(sender As Object, e As EventArgs) Handles btnGroupAccessionInSelectSamplesSelect.Click

        Try
            GetUserProfile()

            ucGroupAccessionIn.SamplesSelected(samples:=CType(Session(SESSION_GROUP_ACCESSION_SELECT_SAMPLES_SAVE), List(Of LabSampleAdvancedSearchGetListModel)),
                                               siteID:=hdfSiteID.Value, personID:=hdfPersonID.Value)

            Session.Remove(SESSION_GROUP_ACCESSION_SELECT_SAMPLES_SAVE)

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divGroupAccessionInSelectSamplesModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GroupAccessionIn()

        FillDropDowns()

        BindSamplesGridView()

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, "hideModal('#divGroupAccessionInModal');", True)

    End Sub

    Protected Sub GroupAccessionInAccession_Click(sender As Object, e As EventArgs) Handles btnGroupAccessionInAccession.Click

        Try
            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))

            upLaboratoryTabCounts.Update()

            upSamples.Update()

            Dim samplesToAccession = ConvertSampleAdvancedSearch(ucGroupAccessionIn.Accession())
            Dim index As Integer = 0
            For Each sample As LabSampleGetListModel In samplesToAccession
                If samples.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                    index = samples.FindIndex(Function(x) x.SampleID = sample.SampleID)
                    samples(index) = sample
                Else
                    samples.Add(sample)
                End If
                index += 1
            Next

            index = 0
            For Each sample As LabSampleGetListModel In samplesToAccession
                If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                    index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                    samplesPendingSave(index) = sample
                Else
                    samplesPendingSave.Add(sample)
                End If
                index += 1
            Next

            Session(SESSION_SAMPLES_LIST) = samples.Distinct.ToList()
            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave.Distinct.ToList()

            lblSamplesCount.Text = samples.ToList().Where(Function(x) x.AccessionIndicator = 0).Count
            FillDropDowns()
            gvSamples.PageIndex = 0
            lblSamplesPageNumber.Text = 1
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)

            upSamples.Update()
            upSamplesButtons.Update()
            upSamplesMenu.Update()
            upSamplesSave.Update()
            upSamplesSearchResults.Update()

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, "hideModal('#divGroupAccessionInModal');", True)
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
    Private Sub GroupAccessionInPrintBarCode_CheckedChanged(sender As Object, e As EventArgs) Handles chkGroupAccessionInPrintBarCode.CheckedChanged

        Try
            hdfSamplePrintBarcodes.Value = chkGroupAccessionInPrintBarCode.Checked
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Register New Sample Methods"

    ''' <summary>
    ''' Initializes and sets up the register new sample modal popup.
    ''' 
    ''' The sample count is used to track the sample identifier to keep the new samples added unique 
    ''' from existing samples or any previously registered samples for this session.  The sample identity 
    ''' for newly registered samples prior to saving use negative numbers to avoid an existing sample 
    ''' duplicate identifier.
    ''' </summary>
    Private Sub InitializeRegisterNewSample()

        Try
            Dim pendingSaveList As List(Of LabSampleGetListModel)
            If Session(SESSION_SAMPLES_SAVE_LIST) Is Nothing Then
                pendingSaveList = New List(Of LabSampleGetListModel)()
            Else
                pendingSaveList = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            End If

            ucRegisterNewSample.Setup(sampleCount:=pendingSaveList.Count, siteID:=hdfSiteID.Value, personID:=hdfPersonID.Value, organizationID:=hdfOrganizationID.Value)

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divRegisterNewSampleModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Displays the selected search report or session modal popup.
    ''' </summary>
    ''' <param name="reportSessionCategoryType">User selected parameter that is used to display the desired search user control: 
    ''' Human disease report, human active surveillance session, vector surveillance session, veterinary disease report 
    ''' or veterinary active surveillance session.</param>
    Protected Sub RegisterNewSample_ShowSearchReportSessionModal(reportSessionCategoryType As String) Handles ucRegisterNewSample.ShowSearchReportSessionModal

        Try
            Select Case reportSessionCategoryType
                Case ReportSessionTypeConstants.HumanDiseaseReport
                    ucSearchHumanDiseaseReport.Setup(selectMode:=SelectModes.Selection)
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchHumanDiseaseReportModal"), True)
                Case ReportSessionTypeConstants.HumanActiveSurveillanceSession
                    ucSearchHumanSession.Setup(selectMode:=SelectModes.Selection)
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchHumanSessionModal"), True)
                Case ReportSessionTypeConstants.VectorSurveillanceSession
                    ucSearchVectorSession.Setup(selectMode:=SelectModes.Selection)
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchVectorSessionModal"), True)
                Case ReportSessionTypeConstants.VeterinaryDiseaseReport
                    ucSearchVeterinaryDiseaseReport.Setup(selectMode:=SelectModes.Selection)
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchVeterinaryDiseaseReportModal"), True)
                Case ReportSessionTypeConstants.VeterinaryActiveSurveillanceSession
                    ucSearchVeterinarySession.Setup(selectMode:=SelectModes.Selection)
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchVeterinarySessionModal"), True)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Displays the search person modal popup.
    ''' 
    ''' The laboratory module searches by the human identifier as opposed to the human master identifier.  The sample 
    ''' table's human identifier foreign key relationship is to the human table.
    ''' 
    ''' The selection mode allows the user to select a person record on the search results to populate the patient/
    ''' farm owner text box on the register new sample modal popup.
    ''' </summary>
    Protected Sub RegisterNewSample_ShowSearchPersonModal() Handles ucRegisterNewSample.ShowSearchPersonModal

        Try
            ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchPersonModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Displays the add/update person modal.
    ''' 
    ''' Adding a person from the laboratory module will require the saving of a human master and human record.
    ''' 
    ''' TODO:  The add/update person needs to have the addition of the human actual to human copy.  Add indicator
    ''' similiar to the search person use human master indicator.  When false add both master and copy.
    ''' </summary>
    Protected Sub RegisterNewSample_ShowCreatePersonModal() Handles ucRegisterNewSample.ShowCreatePersonModal

        Try
            InitializeAddUpdatePerson(runScript:=True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event for the add sample button click event.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddSample_Click(sender As Object, e As EventArgs) Handles btnAddSample.Click

        Try
            Dim gridViewList As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim pendingSaveList As List(Of LabSampleGetListModel)
            If Session(SESSION_SAMPLES_SAVE_LIST) Is Nothing Then
                pendingSaveList = New List(Of LabSampleGetListModel)()
            Else
                pendingSaveList = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            End If

            upLaboratoryTabCounts.Update()
            upSamples.Update()
            upSamplesButtons.Update()
            upSamplesMenu.Update()
            upSamplesSave.Update()

            Dim registerNewSampleList = ucRegisterNewSample.AddSample()
            pendingSaveList.AddRange(registerNewSampleList)
            gridViewList.AddRange(registerNewSampleList)

            lblSamplesCount.Text = lblSamplesCount.Text + registerNewSampleList.Where(Function(x) x.AccessionDate Is Nothing).Count()
            hdfSamplesCount.Value = hdfSamplesCount.Value + registerNewSampleList.Count()
            FillSamplesPager(hdfSamplesCount.Value, 1)
            ViewState(SAMPLES_PAGINATION_SET_NUMBER) = 1

            FillDropDowns()

            Session(SESSION_SAMPLES_SAVE_LIST) = pendingSaveList
            Session(SESSION_SAMPLES_LIST) = gridViewList

            BindSamplesGridView()

            ShowSuccessMessage(messageType:=MessageType.RegisterNewSampleSuccess)

            ucRegisterNewSample.Setup(sampleCount:=pendingSaveList.Count, siteID:=hdfSiteID.Value, personID:=hdfPersonID.Value, organizationID:=hdfOrganizationID.Value)
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
    Protected Sub CancelRegisterNewSampleModal_Click(sender As Object, e As EventArgs) Handles btnCancelRegisterNewSampleModal.Click

        Try
            hdfCurrentModuleAction.Value = ucRegisterNewSample.ID
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event for the register new sample show warning.
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Protected Sub RegisterNewSample_ShowWarningModal(messageType As MessageType, message As String) Handles ucRegisterNewSample.ShowWarningModal

        ShowWarningMessage(messageType:=messageType, isConfirm:=False, message:=message)

    End Sub

    ''' <summary>
    ''' Event for the register new sample show error.
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Protected Sub RegisterNewSample_ShowErrorModal(messageType As MessageType, message As String) Handles ucRegisterNewSample.ShowErrorModal

        ShowErrorMessage(messageType:=messageType, message:=message)

    End Sub

#End Region

#Region "Create Aliquot"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub SamplesAliquot_Click(sender As Object, e As EventArgs) Handles btnSamplesAliquot.Click

        Try
            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim samplesToAliquotDerivative = New List(Of LabSampleGetListModel)()
            Dim errorMessages As New StringBuilder()

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            For Each sample In samples
                If sample.RowSelectionIndicator = 1 Then
                    samplesToAliquotDerivative.Add(sample)
                End If
            Next

            If ValidateSampleForAliquotDerivative(samplesToAliquotDerivative, errorMessages:=errorMessages) = True Then
                Dim index As Integer = 0

                Dim samplesTemp = JsonConvert.SerializeObject(samplesToAliquotDerivative.ToList)
                Dim samplesIn = JsonConvert.DeserializeObject(Of List(Of LabSampleGetListModel))(samplesTemp)

                ucCreateAliquotDerivative.Setup(sampleKindTypeID:=Nothing, samples:=samplesIn, samplesPendingSaveCount:=samplesPendingSave.Count, siteID:=hdfSiteID.Value, personID:=hdfPersonID.Value, organizationID:=hdfOrganizationID.Value)

                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divCreateAliquotDerivativeModal"), True)
            Else
                ShowErrorMessage(messageType:=MessageType.CannotDeleteSample, message:=errorMessages.ToString())
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Initializes and sets up the create aliquot modal popup.
    ''' 
    ''' The sample count is used to track the sample identifier to keep the new samples added unique 
    ''' from existing samples or any previously registered samples for this session.  The sample identity 
    ''' for newly registered samples prior to saving use negative numbers to avoid an existing sample 
    ''' duplicate identifier.
    ''' </summary>
    Private Sub InitializeAliquot()

        Try
            Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim samplesToAliquotDerivative = New List(Of LabSampleGetListModel)()
            Dim errorMessages As New StringBuilder()

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            For Each sample In samples
                If sample.RowSelectionIndicator = 1 Then
                    samplesToAliquotDerivative.Add(sample)
                End If
            Next

            If samplesToAliquotDerivative.Count = 0 Then
                ShowWarningMessage(messageType:=MessageType.CannotTransferOut, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Select_Sample_To_Aliquot_Derivative_Body_Text"))
            Else
                If ValidateSampleForAliquotDerivative(samplesToAliquotDerivative, errorMessages:=errorMessages) = True Then
                    Dim index As Integer = 0

                    Dim samplesTemp = JsonConvert.SerializeObject(samplesToAliquotDerivative.ToList)
                    Dim samplesIn = JsonConvert.DeserializeObject(Of List(Of LabSampleGetListModel))(samplesTemp)

                    ucCreateAliquotDerivative.Setup(sampleKindTypeID:=SampleKindTypes.Aliquot, samples:=samplesIn, samplesPendingSaveCount:=samplesPendingSave.Count, siteID:=hdfSiteID.Value, personID:=hdfPersonID.Value, organizationID:=hdfOrganizationID.Value)

                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divCreateAliquotDerivativeModal"), True)
                Else
                    ShowErrorMessage(messageType:=MessageType.CannotDeleteSample, message:=errorMessages.ToString())
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Initializes and sets up the create aliquot modal popup.
    ''' 
    ''' The sample count is used to track the sample identifier to keep the new samples added unique 
    ''' from existing samples or any previously registered samples for this session.  The sample identity 
    ''' for newly registered samples prior to saving use negative numbers to avoid an existing sample 
    ''' duplicate identifier.
    ''' </summary>
    Private Sub InitializeDerivative()

        Try
            Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim samplesToAliquotDerivative = New List(Of LabSampleGetListModel)()
            Dim errorMessages As New StringBuilder()

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            For Each sample In samples
                If sample.RowSelectionIndicator = 1 Then
                    samplesToAliquotDerivative.Add(sample)
                End If
            Next

            If samplesToAliquotDerivative.Count = 0 Then
                ShowWarningMessage(messageType:=MessageType.CannotTransferOut, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Select_Sample_To_Aliquot_Derivative_Body_Text"))
            Else
                If ValidateSampleForAliquotDerivative(samplesToAliquotDerivative, errorMessages:=errorMessages) = True Then
                    Dim index As Integer = 0

                    Dim samplesTemp = JsonConvert.SerializeObject(samplesToAliquotDerivative.ToList)
                    Dim samplesIn = JsonConvert.DeserializeObject(Of List(Of LabSampleGetListModel))(samplesTemp)

                    ucCreateAliquotDerivative.Setup(sampleKindTypeID:=SampleKindTypes.Derivative, samples:=samplesIn, samplesPendingSaveCount:=samplesPendingSave.Count, siteID:=hdfSiteID.Value, personID:=hdfPersonID.Value, organizationID:=hdfOrganizationID.Value)

                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divCreateAliquotDerivativeModal"), True)
                Else
                    ShowErrorMessage(messageType:=MessageType.CannotDeleteSample, message:=errorMessages.ToString())
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="errorMessages"></param>
    ''' <returns></returns>
    Private Function ValidateSampleForAliquotDerivative(samples As List(Of LabSampleGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each sample In samples
            If sample.RowSelectionIndicator = 1 Then
                If (sample.AccessionIndicator = 0) Then
                    errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Sample_Must_Be_Accessioned") & "</p>")
                    validateStatus = False
                End If
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub AliquotDerivativePrintBarcodes_CheckedChanged(sender As Object, e As EventArgs) Handles chkAliquotDerivativePrintBarcodes.CheckedChanged

        Try
            hdfAliquotDerivativePrintBarcodes.Value = chkAliquotDerivativePrintBarcodes.Checked
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub AliquotsDerivativesSave_Click(sender As Object, e As EventArgs) Handles btnCreateAliquotDerivativeSave.Click

        Try
            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim freezerBoxLocationAvailabilitiesPendingSave As List(Of FreezerBoxLocationAvailabilityParameters) = CType(Session(SESSION_FREEZER_BOX_LOCATION_AVAILABILITY_SAVE_LIST), List(Of FreezerBoxLocationAvailabilityParameters))

            upLaboratoryTabCounts.Update()
            upSamples.Update()

            Dim samplesToAliquotDerivative = ucCreateAliquotDerivative.Save()
            Dim index As Integer = 0
            For Each sample As LabSampleGetListModel In samplesToAliquotDerivative
                If samples.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                    index = samples.FindIndex(Function(x) x.SampleID = sample.SampleID)
                    samples(index) = sample
                Else
                    samples.Add(sample)
                End If
                index += 1
            Next

            index = 0
            For Each sample As LabSampleGetListModel In samplesToAliquotDerivative
                If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                    index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                    samplesPendingSave(index) = sample
                Else
                    samplesPendingSave.Add(sample)
                End If
                index += 1
            Next

            freezerBoxLocationAvailabilitiesPendingSave = ucCreateAliquotDerivative.FreezerBoxLocationAvailabilities
            If freezerBoxLocationAvailabilitiesPendingSave Is Nothing Then
                freezerBoxLocationAvailabilitiesPendingSave = New List(Of FreezerBoxLocationAvailabilityParameters)()
            End If

            Session(SESSION_SAMPLES_LIST) = samples.Distinct.ToList()
            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave.Distinct.ToList()
            Session(SESSION_FREEZER_BOX_LOCATION_AVAILABILITY_SAVE_LIST) = freezerBoxLocationAvailabilitiesPendingSave

            AddUpdateLaboratory()

            If hdfAliquotDerivativePrintBarcodes.Value = "True" Then
                chkAliquotDerivativePrintBarcodes.Checked = False
                InitializePrintBarCode(LaboratoryModuleTabConstants.Samples)
                hdfAliquotDerivativePrintBarcodes.Value = "False"
            End If

            Session(SESSION_SAMPLES_SAVE_LIST) = New List(Of LabSampleGetListModel)()

            FillSamplesList(pageIndex:=1, paginationSetNumber:=1)
            lblSamplesCount.Text = samples.ToList().Where(Function(x) x.AccessionIndicator = 0).Count
            FillDropDowns()
            gvSamples.PageIndex = 0
            lblSamplesPageNumber.Text = 1
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)

            upSamples.Update()
            upSamplesButtons.Update()
            upSamplesMenu.Update()
            upSamplesSave.Update()
            upSamplesSearchResults.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, "hideModal('#divCreateAliquotDerivativeModal');", True)
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
    Protected Sub CancelCreateAliquotDerivativeModal(sender As Object, e As EventArgs) Handles btnCancelCreateAliquotDerivativeModal.Click

        Try
            hdfCurrentModuleAction.Value = ucCreateAliquotDerivative.ID
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Edit Sample Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    Private Sub InitializeEditSample(sampleID As Long)

        Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
        Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))

        If tests Is Nothing Then
            tests = New List(Of LabTestGetListModel)()
            Session(SESSION_TESTING_LIST) = New List(Of LabTestGetListModel)()
        End If

        If samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().TransferCount = 0 Then
            divTransferDetailsAccordionPanel.Visible = False
        Else
            divTransferDetailsAccordionPanel.Visible = True
        End If

        ucAddUpdateSample.Sample = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault()
        ucAddUpdateSample.Setup()

        If ucAddUpdateSample.Sample.AccessionIndicator = 0 Then
            divTestDetailsAccordionPanel.Visible = False
            divAdditionalTestDetailsAccordionPanel.Visible = False
            divAmendmentHistoryAccordionPanel.Visible = False
        Else
            If ucAddUpdateSample.Sample.TestAssignedCount > 0 Then
                If LaboratoryAPIService Is Nothing Then
                    LaboratoryAPIService = New LaboratoryServiceClient()
                End If

                Dim sampleTests = New List(Of LabTestGetListModel)()
                Dim parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SampleID = ucAddUpdateSample.Sample.SampleID, .UserID = hdfUserID.Value}
                sampleTests = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result.OrderBy(Function(x) x.StartedDate)

                If sampleTests.Count > 0 Then
                    ucAddUpdateTest.Test = sampleTests.FirstOrDefault()
                End If
            Else
                If ucAddUpdateSample.Sample.TestCompletedIndicator = 1 Then
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If

                    Dim sampleTests = New List(Of LabTestGetListModel)()
                    Dim parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SampleID = ucAddUpdateSample.Sample.SampleID, .UserID = hdfUserID.Value}
                    sampleTests = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result

                    If sampleTests.Count > 0 Then
                        ucAddUpdateTest.Test = sampleTests.OrderBy(Function(x) x.StartedDate).FirstOrDefault()
                    End If
                Else
                    ucAddUpdateTest.Test = New LabTestGetListModel With {
                        .DiseaseID = ucAddUpdateSample.Sample.DiseaseID,
                        .DiseaseName = ucAddUpdateSample.Sample.DiseaseName,
                        .EIDSSLaboratorySampleID = ucAddUpdateSample.Sample.EIDSSLaboratorySampleID,
                        .EIDSSReportSessionID = ucAddUpdateSample.Sample.EIDSSReportSessionID,
                        .FavoriteIndicator = ucAddUpdateSample.Sample.FavoriteIndicator,
                        .RowAction = RecordConstants.Insert,
                        .SampleID = ucAddUpdateSample.Sample.SampleID,
                        .TestStatusTypeID = TestStatusTypes.NotStarted,
                        .TestStatusTypeName = Resources.Labels.Lbl_Not_Started_Text
                    }
                End If
            End If

            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
            End If

            divTestDetailsAccordionPanel.Visible = True
            divAdditionalTestDetailsAccordionPanel.Visible = True
            divAmendmentHistoryAccordionPanel.Visible = True

            ucAddUpdateTest.Setup(testCount:=testsPendingSave.Count)
        End If

        upSampleTestTransferDetailsAccordion.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_EDIT_SAMPLE_SAMPLES_MODAL, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ShowSampleDetailsForm_Click(sender As Object, e As ImageClickEventArgs) Handles btnShowSampleDetailsForm.Click

        Try
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleDetailsFormModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event for the add/update sample show error.
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdateSample_ShowErrorModal(messageType As MessageType, message As String) Handles ucAddUpdateSample.ShowErrorModal

        ShowErrorMessage(messageType:=messageType, message:=GetErrorMessages("EditSampleTestDetails"))

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CancelSampleTestDetailsModal(sender As Object, e As EventArgs) Handles btnCancelSampleTestDetailsModal.Click

        Try
            hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditSample
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Sample Destruction Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="destructionMethodTypeID"></param>
    Private Sub SampleDestruction(ByVal destructionMethodTypeID As Long)

        Try
            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim samplesToDestroy = New List(Of LabSampleGetListModel)()
            Dim errorMessages As New StringBuilder()

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            For Each sample In samples
                If sample.RowSelectionIndicator = 1 Then
                    samplesToDestroy.Add(sample)
                End If
            Next

            If ValidateSampleForDestruction(samplesToDestroy, errorMessages:=errorMessages) = True Then
                Dim index As Integer = 0

                For Each sample In samplesToDestroy
                    With samples.Where(Function(x) x.SampleID = sample.SampleID).FirstOrDefault()
                        .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Destruction_Text
                        .DestructionMethodTypeID = destructionMethodTypeID

                        If destructionMethodTypeID = DestructionMethodTypes.Autoclave Then
                            .DestructionMethodTypeName = Resources.Labels.Lbl_Autoclave_Text
                        Else
                            .DestructionMethodTypeName = Resources.Labels.Lbl_Incineration_Text
                        End If

                        .MarkedForDispositionByPersonID = hdfPersonID.Value
                        .PreviousSampleStatusTypeID = sample.SampleStatusTypeID
                        .SampleStatusTypeID = SampleStatusTypes.MarkedForDestruction
                        .RowAction = RecordConstants.Update
                    End With
                Next

                For Each sample As LabSampleGetListModel In samplesToDestroy
                    If samples.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                        index = samples.FindIndex(Function(x) x.SampleID = sample.SampleID)
                        samples(index) = sample
                    Else
                        samples.Add(sample)
                    End If
                    index += 1
                Next

                index = 0
                For Each sample As LabSampleGetListModel In samplesToDestroy
                    If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                        index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                        samplesPendingSave(index) = sample
                    Else
                        samplesPendingSave.Add(sample)
                    End If
                    index += 1
                Next

                upLaboratoryTabCounts.Update()
                upSamples.Update()
                upSamplesSave.Update()
                upSamplesButtons.Update()
                upSamplesMenu.Update()
                upApprovals.Update()

                FillDropDowns()
                Session(SESSION_SAMPLES_LIST) = samples
                Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
                gvSamples.PageIndex = 0
                lblSamplesPageNumber.Text = 1
                BindSamplesGridView()
                FillSamplesPager(hdfSamplesCount.Value, 1)
                BindApprovalsGridView()

                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            Else
                ShowErrorMessage(messageType:=MessageType.CannotDeleteSample, message:=errorMessages.ToString())
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Function ValidateSampleForDestruction(samples As List(Of LabSampleGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each sample In samples
            If sample.RowSelectionIndicator = 1 Then
                If (sample.AccessionIndicator = 0) Then
                    errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Sample_Must_Be_Accessioned") & "</p>")
                    validateStatus = False
                End If
            End If
        Next

        Return validateStatus

    End Function

#End Region

#Region "Sample Deletion Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SampleDeletion()

        Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
        Dim samplesToDelete = New List(Of LabSampleGetListModel)()

        If samples Is Nothing Then
            samples = New List(Of LabSampleGetListModel)()
        End If

        For Each sample In samples
            If sample.RowSelectionIndicator = 1 Then
                samplesToDelete.Add(sample)
            End If
        Next

        If samplesToDelete.Count() > 0 Then
            If ValidateSampleForDeletion(samplesToDelete) = True Then
                upDeleteSample.Update()

                Session(SESSION_SAMPLES_TO_DELETE_LIST) = samplesToDelete
                gvDeleteSamples.DataSource = samplesToDelete
                gvDeleteSamples.DataBind()

                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divDeleteSampleModal"), True)
            Else
                ShowErrorMessage(messageType:=MessageType.SampleMustBeAccessioned)
            End If
        Else
            ShowWarningMessage(messageType:=MessageType.NoSampleSelectedForSampleDeletion, isConfirm:=False)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub DeleteSampleDelete_Click(sender As Object, e As EventArgs) Handles btnDeleteSampleDelete.Click

        Try
            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim samplesToDelete As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_TO_DELETE_LIST), List(Of LabSampleGetListModel))
            Dim errorMessages As New StringBuilder()

            For Each sample In samplesToDelete
                With samples.Where(Function(x) x.SampleID = sample.SampleID).FirstOrDefault()
                    .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                    .MarkedForDispositionByPersonID = hdfPersonID.Value
                    .PreviousSampleStatusTypeID = sample.SampleStatusTypeID
                    .SampleStatusTypeID = SampleStatusTypes.MarkedForDeletion
                    .Note = txtDeleteSampleReasonForDeletion.Text
                    .RowAction = RecordConstants.Update
                End With
            Next

            If ValidateSampleDeletion(samplesToDelete, errorMessages:=errorMessages) = True Then
                Dim index As Integer = 0
                For Each sample As LabSampleGetListModel In samplesToDelete
                    If samples.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                        index = samples.FindIndex(Function(x) x.SampleID = sample.SampleID)
                        samples(index) = sample
                    Else
                        samples.Add(sample)
                    End If
                    index += 1
                Next

                index = 0
                For Each sample As LabSampleGetListModel In samplesToDelete
                    If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                        index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                        samplesPendingSave(index) = sample
                    Else
                        samplesPendingSave.Add(sample)
                    End If
                    index += 1
                Next

                upLaboratoryTabCounts.Update()
                upSamples.Update()
                upApprovals.Update()

                FillDropDowns()
                Session(SESSION_SAMPLES_LIST) = samples
                Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
                BindSamplesGridView()
                BindApprovalsGridView()

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "hideModal('#divDeleteSampleModal');", True)
            Else
                ShowErrorMessage(messageType:=MessageType.CannotDeleteSample, message:=errorMessages.ToString())
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Validates samples selected are accessioned and are candidates for sample deletion.
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <returns></returns>
    Private Function ValidateSampleForDeletion(samples As List(Of LabSampleGetListModel)) As Boolean

        Dim validateStatus As Boolean = True
        Dim errorMessages As New StringBuilder()

        For Each sample In samples
            If (sample.AccessionIndicator = False) Then
                errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Sample_Must_Be_Accessioned") & "</p>")
                validateStatus = False
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' Validates samples selected by the user for deletion meet the business rules.
    ''' </summary>
    ''' <param name="samples">Samples selected for accessioning into the lab.</param>
    ''' <param name="errorMessages">Validation error messages returned to display back to the user.</param>
    ''' <returns></returns>
    Private Function ValidateSampleDeletion(ByVal samples As List(Of LabSampleGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each sample In samples
            If sample.Note.IsValueNullOrEmpty() Then
                errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Required") & "</p>")
                validateStatus = False
            ElseIf sample.Note.Length < 7 Then
                errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Length") & "</p>")
                validateStatus = False
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CancelDeleteSampleModal(sender As Object, e As EventArgs) Handles btnCancelDeleteSampleModal.Click

        Try
            hdfCurrentModuleAction.Value = LaboratoryModuleActions.DeleteSample
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Restore Deleted Sample Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SetRestoreSample()

        Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
        Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
        Dim samplesToRestore = New List(Of LabSampleGetListModel)()
        Dim errorMessages As New StringBuilder()

        If samples Is Nothing Then
            samples = New List(Of LabSampleGetListModel)()
        End If

        If samplesPendingSave Is Nothing Then
            samplesPendingSave = New List(Of LabSampleGetListModel)()
        End If

        For Each sample In samples
            If sample.RowSelectionIndicator = 1 Then
                samplesToRestore.Add(sample)
            End If
        Next

        If ValidateSampleForRestoration(samplesToRestore, errorMessages:=errorMessages) = True Then
            Dim index As Integer = 0
            For Each sample In samplesToRestore
                With samples.Where(Function(x) x.SampleID = sample.SampleID).FirstOrDefault()
                    .RowAction = RecordConstants.Update
                    .SampleStatusTypeID = sample.PreviousSampleStatusTypeID
                    .RowSelectionIndicator = False

                    If Not sample.SampleStatusTypeID Is Nothing Then
                        Select Case sample.SampleStatusTypeID
                            Case SampleStatusTypes.Deleted
                                .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                            Case SampleStatusTypes.Destroyed
                                .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Destroyed_Text
                            Case SampleStatusTypes.InRepository
                                .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_In_Repository_Text
                            Case SampleStatusTypes.MarkedForDeletion
                                .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                            Case SampleStatusTypes.MarkedForDestruction
                                .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Destruction_Text
                            Case SampleStatusTypes.TransferredOut
                                .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Transferred_Out_Text
                        End Select
                    End If
                    .PreviousSampleStatusTypeID = Nothing
                End With
            Next

            For Each sample As LabSampleGetListModel In samplesToRestore
                If samples.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                    index = samples.FindIndex(Function(x) x.SampleID = sample.SampleID)
                    samples(index) = sample
                Else
                    samples.Add(sample)
                End If
                index += 1
            Next

            index = 0
            For Each sample As LabSampleGetListModel In samplesToRestore
                If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                    index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                    samplesPendingSave(index) = sample
                Else
                    samplesPendingSave.Add(sample)
                End If
                index += 1
            Next

            FillDropDowns()

            Session(SESSION_SAMPLES_SAVE_LIST) = samples
            Session(SESSION_SAMPLES_LIST) = samples
            BindSamplesGridView()

            ucSamplesMenu.SetRestoreSampleDisabled(True)

            upSamplesMenu.Update()
            upSamplesSave.Update()
            upSamples.Update()
        Else
            ShowErrorMessage(messageType:=MessageType.CannotRestoreSample, message:=errorMessages.ToString())
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="errorMessages"></param>
    ''' <returns></returns>
    Private Function ValidateSampleForRestoration(samples As List(Of LabSampleGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each sample In samples
            If sample.RowSelectionIndicator = 1 Then
                If (Not sample.SampleStatusTypeID = SampleStatusTypes.Deleted) Then
                    errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Sample_Must_Be_Deleted") & "</p>")
                    validateStatus = False
                End If
            End If
        Next

        Return validateStatus

    End Function

#End Region

#Region "Test Deletion Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub TestDeletion()

        Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        Dim testsToDelete = New List(Of LabTestGetListModel)()

        If tests Is Nothing Then
            tests = New List(Of LabTestGetListModel)()
        End If

        For Each test In tests
            If test.RowSelectionIndicator = 1 Then
                testsToDelete.Add(test)
            End If
        Next

        If testsToDelete.Count() > 0 Then
            If ValidateTestForDeletion(testsToDelete) = True Then
                upDeleteTest.Update()

                Session(SESSION_TESTS_TO_DELETE_LIST) = testsToDelete
                gvDeleteTests.DataSource = testsToDelete
                gvDeleteTests.DataBind()
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divDeleteTestModal"), True)
            Else
                ShowErrorMessage(messageType:=MessageType.SampleMustBeAccessioned)
            End If
        Else
            ShowWarningMessage(messageType:=MessageType.NoSampleSelectedForSampleDeletion, isConfirm:=False)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub DeleteTestDelete_Click(sender As Object, e As EventArgs) Handles btnDeleteTestDelete.Click

        Try
            Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            Dim testsPendingSave As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim testsToDelete As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTS_TO_DELETE_LIST), List(Of LabTestGetListModel))
            Dim errorMessages As New StringBuilder()

            For Each test In testsToDelete
                With tests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault()
                    .PreviousTestStatusTypeID = test.TestStatusTypeID
                    .TestStatusTypeID = TestStatusTypes.MarkedForDeletion
                    .TestStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                    .Note = txtDeleteTestReasonForDeletion.Text
                    .RowAction = RecordConstants.Update
                End With
            Next

            If ValidateTestDeletion(testsToDelete, errorMessages:=errorMessages) = True Then
                Dim index As Integer = 0
                For Each test As LabTestGetListModel In testsToDelete
                    If tests.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                        index = tests.FindIndex(Function(x) x.TestID = test.TestID)
                        tests(index) = test
                    Else
                        tests.Add(test)
                    End If
                    index += 1
                Next

                index = 0
                For Each test As LabTestGetListModel In testsToDelete
                    If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                        index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                        testsPendingSave(index) = test
                    Else
                        testsPendingSave.Add(test)
                    End If
                    index += 1
                Next

                upLaboratoryTabCounts.Update()
                upTesting.Update()
                upApprovals.Update()

                FillDropDowns()
                Session(SESSION_TESTING_LIST) = tests
                Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
                gvTesting.PageIndex = 0
                BindTestingGridView()
                BindApprovalsGridView()

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "hideModal('#divDeleteTestModal');", True)
            Else
                ShowErrorMessage(messageType:=MessageType.CannotDeleteSample, message:=errorMessages.ToString())
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try


    End Sub

    ''' <summary>
    ''' Validates tests selected are in progress/preliminary and are candidates for test deletion.
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <returns></returns>
    Private Function ValidateTestForDeletion(tests As List(Of LabTestGetListModel)) As Boolean

        Dim validateStatus As Boolean = True
        Dim errorMessages As New StringBuilder()

        For Each test In tests
            If (Not test.TestStatusTypeID = TestStatusTypes.InProgress And Not test.TestStatusTypeID = TestStatusTypes.Preliminary) Then
                errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Test_Must_Have_Preliminary_In_Progress_Test") & "</p>")
                validateStatus = False
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' Validates tests selected by the user for deletion meet the business rules.
    ''' </summary>
    ''' <param name="tests">Tests selected for deletion.</param>
    ''' <param name="errorMessages">Validation error messages returned to display back to the user.</param>
    ''' <returns></returns>
    Private Function ValidateTestDeletion(ByVal tests As List(Of LabTestGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each test In tests
            If test.Note.IsValueNullOrEmpty() Then
                errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Required") & "</p>")
                validateStatus = False
            ElseIf test.Note.Length < 7 Then
                errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Length") & "</p>")
                validateStatus = False
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CancelDeleteTestModal(sender As Object, e As EventArgs) Handles btnCancelDeleteTestModal.Click

        Try
            hdfCurrentModuleAction.Value = LaboratoryModuleActions.DeleteTest
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Transfer Out Methods"

    ''' <summary>
    ''' Initializes and sets up the transfer sample modal popup.
    ''' </summary>
    Private Sub InitializeTransferOut()

        Try
            Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim selectedSamples = New List(Of LabSampleGetListModel)()

            For Each sample In samples
                If sample.RowSelectionIndicator = 1 Then
                    If sample.AccessionIndicator = 1 Then
                        selectedSamples.Add(sample)
                    End If
                End If
            Next

            If selectedSamples.Count = 0 Then
                ShowWarningMessage(messageType:=MessageType.CannotTransferOut, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Sample_Must_Be_Accessioned_Transfer_Out_Body_Text"))
            Else
                Dim errorMessages As StringBuilder = New StringBuilder()
                If ValidateSampleForTransferOut(selectedSamples, errorMessages:=errorMessages) = False Then
                    ShowErrorMessage(messageType:=MessageType.CannotTransferOut, message:=errorMessages.ToString())
                Else
                    ucTransferSample.Transfer = New LabTransferGetListModel()
                    ucTransferSample.Setup()

                    ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTransferSampleModal"), True)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="errorMessages"></param>
    ''' <returns></returns>
    Private Function ValidateSampleForTransferOut(samples As List(Of LabSampleGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each sample In samples
            If sample.RowSelectionIndicator = 1 Then
                If sample.TestAssignedIndicator = 1 Then
                    errorMessages.Append("<p>" & GetLocalResourceObject("Err_Sample_Has_Test_In_Progress_Part_1_Text") & " " & sample.EIDSSLaboratorySampleID & " " & GetLocalResourceObject("Err_Sample_Has_Test_In_Progress_Part_2_Text") & "</p>")
                    validateStatus = False
                End If
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' Event for the add sample button click event.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Transfer_Click(sender As Object, e As EventArgs) Handles btnTransfer.Click

        Try
            Dim samples = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim transfersPendingSave = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))
            Dim samplesTransferOut = New List(Of LabSampleGetListModel)()

            If samples Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
            End If

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            If transfersPendingSave Is Nothing Then
                transfersPendingSave = New List(Of LabTransferGetListModel)()
            End If

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim organizationParameters = New OrganizationGetListParams With {.LanguageID = GetCurrentLanguage(), .OrganizationID = ucTransferSample.GetTransferredToOrganizationID(), .PaginationSetNumber = 1}
            Dim sendToOrganization = CrossCuttingAPIService.GetOrganizationListAsync(organizationParameters).Result

            Dim index As Integer = 0
            Dim samplesTransferOutIndex = 0
            Dim transferredInSample As LabSampleGetListModel
            For Each sample In samples
                If sample.RowSelectionIndicator = 1 Then
                    If sample.AccessionIndicator = 1 Then
                        'Is the send to organization an EIDSS laboratory? If so, then create new sample record for accessioning.  
                        'If not, then the transferred from laboratory will enter the test result received back from the transferred 
                        'to (aka send to organization) laboratory via e-mail, phone, etc.
                        If Not sendToOrganization.FirstOrDefault().SiteID Is Nothing Then
                            transferredInSample = CreateTransferredInSample(sample, sendToOrganization.FirstOrDefault().SiteID, samplesPendingSave.Count)
                            samplesPendingSave.Add(transferredInSample)
                        End If

                        sample.SampleStatusTypeID = SampleStatusTypes.TransferredOut
                        sample.FreezerSubdivisionID = Nothing

                        If sample.RowAction = String.Empty Then
                            If sample.SampleID > 0 Then
                                sample.RowAction = RecordConstants.Update
                            Else
                                sample.RowAction = RecordConstants.InsertAccession
                            End If
                        End If

                        samplesTransferOut.Add(sample)

                        If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                            index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                            samplesPendingSave(index) = sample
                        Else
                            samplesPendingSave.Add(sample)
                        End If
                    End If
                End If
                samplesTransferOutIndex += 1
            Next

            transfersPendingSave.AddRange(ucTransferSample.SaveTransfer(samplesTransferOut))

            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
            Session(SESSION_SAMPLES_LIST) = samples
            Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave

            AddUpdateLaboratory()

            If hdfTransferPrintBarcodes.Value = "True" Then
                chkTransferPrintBarcodes.Checked = False
                InitializePrintBarCode(LaboratoryModuleTabConstants.Samples)
                hdfTransferPrintBarcodes.Value = "False"
            End If

            Dim samplesParameters = New LaboratorySampleGetListParameters With {.DaysFromAccessionDate = ConfigurationManager.AppSettings("DaysFromAccessionDate"), .PaginationSetNumber = 1, .UserID = hdfUserID.Value, .OrganizationID = hdfOrganizationID.Value}
            Dim samplesCounts = LaboratoryAPIService.LaboratorySampleGetListCountAsync(samplesParameters).Result
            lblSamplesCount.Text = samplesCounts(0).UnaccessionedSampleCount
            hdfSamplesCount.Value = samplesCounts(0).RecordCount
            lblSamplesPageNumber.Text = 1
            gvSamples.PageIndex = 0
            FillSamplesList(pageIndex:=1, paginationSetNumber:=1)
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)

            Session(SESSION_SAMPLES_SAVE_LIST) = New List(Of LabSampleGetListModel)()
            Session(SESSION_TRANSFERRED_SAVE_LIST) = New List(Of LabTransferGetListModel)()

            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
            BindMyFavoritesGridView()

            Dim transferredParameters = New LaboratoryTransferGetListParameters With {.PaginationSetNumber = 1, .OrganizationID = hdfOrganizationID.Value, .UserID = hdfUserID.Value}
            Dim transferredCount = LaboratoryAPIService.LaboratoryTransferGetListCountAsync(transferredParameters).Result
            lblTransferredCount.Text = transferredCount(0).RecordCount
            lblTransferredPageNumber.Text = 1
            gvTransferred.PageIndex = 0
            FillTransferredList(pageIndex:=1, paginationSetNumber:=1)
            BindTransferredGridView()

            FillTabCounts()

            upLaboratoryTabCounts.Update()
            upSamples.Update()
            upSamplesButtons.Update()
            upSamplesSave.Update()
            upSamplesMenu.Update()
            'VerifyUserPermissions(False)

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    Private Sub TransferPrintBarcodes_CheckedChanged(sender As Object, e As EventArgs) Handles chkTransferPrintBarcodes.CheckedChanged

        Try
            hdfTransferPrintBarcodes.Value = chkTransferPrintBarcodes.Checked
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transferredOutSample"></param>
    ''' <param name="siteID"></param>
    ''' <param name="pendingSaveCount"></param>
    ''' <returns></returns>
    Private Function CreateTransferredInSample(ByVal transferredOutSample As LabSampleGetListModel, ByVal siteID As Long, ByVal pendingSaveCount As Integer) As LabSampleGetListModel

        Return New LabSampleGetListModel With {
                            .SampleID = pendingSaveCount + 1 * -1,
                            .AccessionByPersonID = Nothing,
                            .AccessionComment = Nothing,
                            .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Unaccessioned_Text,
                            .AccessionConditionTypeID = Nothing,
                            .AccessionDate = Nothing,
                            .AccessionIndicator = 0,
                            .AnimalID = transferredOutSample.AnimalID,
                            .BirdStatusTypeID = transferredOutSample.BirdStatusTypeID,
                            .CollectedByOrganizationID = transferredOutSample.CollectedByOrganizationID,
                            .CollectedByOrganizationName = transferredOutSample.CollectedByOrganizationName,
                            .CollectedByPersonID = transferredOutSample.CollectedByPersonID,
                            .CollectedByPersonName = transferredOutSample.CollectedByPersonName,
                            .CollectionDate = transferredOutSample.CollectionDate,
                            .CurrentSiteID = Nothing,
                            .DestroyedByPersonID = transferredOutSample.DestroyedByPersonID,
                            .DestructionDate = transferredOutSample.DestructionDate,
                            .DestructionMethodTypeID = transferredOutSample.DestructionMethodTypeID,
                            .DestructionMethodTypeName = transferredOutSample.DestructionMethodTypeName,
                            .DiseaseID = transferredOutSample.DiseaseID,
                            .DiseaseName = transferredOutSample.DiseaseName,
                            .EIDSSAnimalID = transferredOutSample.EIDSSAnimalID,
                            .EIDSSLaboratoryOrLocalFieldSampleID = transferredOutSample.EIDSSLocalFieldSampleID,
                            .EIDSSLaboratorySampleID = Nothing,
                            .EnteredDate = transferredOutSample.EnteredDate,
                            .FavoriteIndicator = 0,
                            .FreezerSubdivisionID = Nothing,
                            .FunctionalAreaID = Nothing,
                            .FunctionalAreaName = Nothing,
                            .HumanDiseaseReportID = transferredOutSample.HumanDiseaseReportID,
                            .HumanID = transferredOutSample.HumanID,
                            .MainTestID = transferredOutSample.MainTestID,
                            .MarkedForDispositionByPersonID = transferredOutSample.MarkedForDispositionByPersonID,
                            .MonitoringSessionID = transferredOutSample.MonitoringSessionID,
                            .Note = transferredOutSample.Note,
                            .OutOfRepositoryDate = Nothing,
                            .ParentEIDSSLaboratorySampleID = transferredOutSample.ParentEIDSSLaboratorySampleID,
                            .ParentSampleID = transferredOutSample.SampleID,
                            .PatientFarmOwnerName = transferredOutSample.PatientFarmOwnerName,
                            .PreviousSampleStatusTypeID = transferredOutSample.PreviousSampleStatusTypeID,
                            .ReadOnlyIndicator = transferredOutSample.ReadOnlyIndicator,
                            .ReportSessionTypeName = transferredOutSample.ReportSessionTypeName,
                            .SampleTypeID = transferredOutSample.SampleTypeID,
                            .SampleTypeName = transferredOutSample.SampleTypeName,
                            .SentDate = Date.Now,
                            .SpeciesID = transferredOutSample.SpeciesID,
                            .TestAssignedIndicator = transferredOutSample.TestAssignedIndicator,
                            .TestCompletedIndicator = transferredOutSample.TestCompletedIndicator,
                            .TransferCount = 0,
                            .VectorID = transferredOutSample.VectorID,
                            .VectorSessionID = transferredOutSample.VectorSessionID,
                            .VeterinaryDiseaseReportID = transferredOutSample.VeterinaryDiseaseReportID,
                            .SentToOrganizationID = ucTransferSample.GetTransferredToOrganizationID(),
                            .SentToOrganizationName = ucTransferSample.GetTransferredToOrganizationName(),
                            .RootSampleID = transferredOutSample.RootSampleID,
                            .RowAction = RecordConstants.Insert,
                            .RowSelectionIndicator = 0,
                            .RowStatus = RecordConstants.ActiveRowStatus,
                            .SampleKindTypeID = SampleKindTypes.TransferredIn,
                            .SampleStatusTypeID = Nothing,
                            .SiteID = siteID
                        }

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CancelTransferModal(sender As Object, e As EventArgs) Handles btnCancelTransferModal.Click

        Try
            hdfCurrentModuleAction.Value = ucTransferSample.ID
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Search Report/Session Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanDiseaseReportID"></param>
    ''' <param name="eidssReportID"></param>
    ''' <param name="diseaseID"></param>
    ''' <param name="patientFarmOwnerID"></param>
    ''' <param name="patientFarmOwnerName"></param>
    Protected Sub SearchHumanDiseaseReportUserControl_SelectHumanDiseaseReport(humanDiseaseReportID As Long, eidssReportID As String, diseaseID As Long?, patientFarmOwnerID As Long?, patientFarmOwnerName As String) Handles ucSearchHumanDiseaseReport.SelectHumanDiseaseReport

        ucRegisterNewSample.SetReportSession(reportSessionID:=humanDiseaseReportID, reportSessionEIDSSID:=eidssReportID, diseases:=diseaseID)

        If Not patientFarmOwnerID Is Nothing Then
            ucRegisterNewSample.SetPatientFarmOwner(patientFarmOwnerID:=patientFarmOwnerID, patientFarmOwnerName:=patientFarmOwnerName)
        End If

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchHumanDiseaseReportModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchHumanDiseaseReportUserControl_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchHumanDiseaseReport.ShowWarningModal

        hdfCurrentModuleAction.Value = ucSearchHumanDiseaseReport.ID
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanSessionID"></param>
    ''' <param name="eidssSessionID"></param>
    ''' <param name="diseaseID"></param>
    Protected Sub SearchHumanSessionUserControl_SelectHumanSession(humanSessionID As Long, eidssSessionID As String, diseaseID As Long?) Handles ucSearchHumanSession.SelectHumanSession

        ucRegisterNewSample.SetReportSession(reportSessionID:=humanSessionID, reportSessionEIDSSID:=eidssSessionID, diseases:=diseaseID)

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchHumanSessionModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchHumanSessionUserControl_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchHumanSession.ShowWarningModal

        hdfCurrentModuleAction.Value = ucSearchHumanSession.ID
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchVectorSessionUserControl_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchVectorSession.ShowWarningModal

        hdfCurrentModuleAction.Value = ucSearchVectorSession.ID
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="vectorSurveillanceSession"></param>
    ''' <param name="eidssSessionID"></param>
    ''' <param name="diseases"></param>
    Protected Sub SearchVectorSessionUserControl_SelectVectorSession(vectorSurveillanceSession As Long, eidssSessionID As String, diseases As String) Handles ucSearchVectorSession.SelectVectorSession

        ucRegisterNewSample.SetReportSession(reportSessionID:=vectorSurveillanceSession, reportSessionEIDSSID:=eidssSessionID, diseases:=diseases)

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchVectorSessionModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchVeterinaryDiseaseReportUserControl_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchVeterinaryDiseaseReport.ShowWarningModal

        hdfCurrentModuleAction.Value = ucSearchVeterinaryDiseaseReport.ID
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="veterinaryDiseaseReportID"></param>
    ''' <param name="eidssID"></param>
    ''' <param name="diseaseID"></param>
    ''' <param name="farmOwnerID"></param>
    ''' <param name="farmOwnerName"></param>
    Protected Sub SearchVeterinaryDiseaseReportUserControl_SelectVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long, eidssID As String, diseaseID As Long?, farmOwnerID As Long?, farmOwnerName As String) Handles ucSearchVeterinaryDiseaseReport.SelectVeterinaryDiseaseReport

        ucRegisterNewSample.SetReportSession(reportSessionID:=veterinaryDiseaseReportID, reportSessionEIDSSID:=eidssID, diseases:=diseaseID)

        If Not farmOwnerID Is Nothing Then
            ucRegisterNewSample.SetPatientFarmOwner(farmOwnerID, farmOwnerName)
        End If

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchVeterinaryDiseaseReportModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchVeterinarySessionUserControl_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchVeterinarySession.ShowWarningModal

        hdfCurrentModuleAction.Value = ucSearchVeterinarySession.ID
        ShowWarningMessage(messageType, isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="veterinaryDiseaseReportID"></param>
    ''' <param name="eidssID"></param>
    ''' <param name="diseaseID"></param>
    Protected Sub SearchVeterinarySessionUserControl_SelectVeterinarySession(veterinaryDiseaseReportID As Long, eidssID As String, diseaseID As Long?) Handles ucSearchVeterinarySession.SelectVeterinarySessionRecord

        ucRegisterNewSample.SetReportSession(reportSessionID:=veterinaryDiseaseReportID, reportSessionEIDSSID:=eidssID, diseases:=diseaseID)

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchVeterinarySessionModal"), True)

    End Sub

#End Region

#Region "Search Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchPerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchPerson.ShowWarningModal

        hdfCurrentModuleAction.Value = ucSearchPerson.ID
        ShowWarningMessage(messageType, isConfirm)

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

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchPersonModal"), True)

        ucRegisterNewSample.SetPatientFarmOwner(humanID, fullName)

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

        hdfCurrentModuleAction.Value = ucAddUpdatePerson.ID
        upAddUpdatePerson.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdatePerson_ShowErrorModal(messageType As MessageType, message As String) Handles ucAddUpdatePerson.ShowErrorModal

        upAddUpdatePerson.Update()
        ShowErrorMessage(messageType:=messageType, message:=message)

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

        ucRegisterNewSample.SetPatientFarmOwner(patientFarmOwnerID:=humanID, patientFarmOwnerName:=fullName)

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAddUpdatePersonModal"), True)

    End Sub

#End Region

#Region "Testing Methods"

    ''' <summary>
    ''' Fill the testing tab grid view with tests that are currently marked as in progress (Test Status Type - 10001003).
    ''' 
    ''' Tests returned will also be for the current logged in user's associated site matching the current site of the 
    ''' test's sample record.
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillTestingList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            If hdfAdvancedSearchIndicator.Value = YesNoUnknown.No And hdgTestingQueryText.InnerText = String.Empty Then
                Dim parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .TestStatusTypeID = TestStatusTypes.InProgress, .SiteID = hdfSiteID.Value, .PaginationSetNumber = paginationSetNumber, .UserID = hdfUserID.Value, .BatchTestID = Nothing}
                Session(SESSION_TESTING_LIST) = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result
            Else
                If hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes Then
                    ucSearchSample.FillTestingList()
                Else
                    ucTestingSearch.Search()
                End If
            End If

            FillTestingPager(hdfTestingCount.Value, pageIndex)
            ViewState(TESTING_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillTestingPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Try
            Dim pages As New List(Of ListItem)()
            Dim startIndex As Integer, endIndex As Integer
            Dim pagerSpan As Integer = 5

            If recordCount > 0 Then
                divTestingPager.Visible = True

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
                rptTestingPager.DataSource = pages
                rptTestingPager.DataBind()
            Else
                divTestingPager.Visible = False
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
    Protected Sub TestingPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvTesting.PageSize)

            FillDropDowns()

            If Not ViewState(TESTING_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvTesting.PageIndex = gvTesting.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvTesting.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvTesting.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvTesting.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvTesting.PageIndex = gvTesting.PageSize - 1
                        Else
                            gvTesting.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillTestingList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvTesting.PageIndex = gvTesting.PageSize - 1
                Else
                    gvTesting.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindTestingGridView()
                FillTestingPager(hdfTestingCount.Value, pageIndex)
            End If

            lblTestingPageNumber.Text = pageIndex.ToString()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindTestingGridView()

        Try
            Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))

            If tests Is Nothing Then
                tests = New List(Of LabTestGetListModel)()
                Session(SESSION_TESTING_LIST) = tests
            End If

            'User has pending changes to save; enable the appropriate controls.
            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
                Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
            End If

            If testsPendingSave.Count > 0 Then
                btnTestingSave.Enabled = True

                If (Not ViewState(TESTING_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(TESTING_SORT_DIRECTION) = SortConstants.Ascending Then
                        tests = tests.OrderBy(Function(x) x.GetType().GetProperty(ViewState(TESTING_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        tests = tests.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(TESTING_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    tests = tests.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.AccessionDate).ThenBy(Function(z) z.PatientFarmOwnerName).ToList()
                End If
            Else
                btnTestingSave.Enabled = False

                If (Not ViewState(TESTING_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(TESTING_SORT_DIRECTION) = SortConstants.Ascending Then
                        tests = tests.OrderBy(Function(x) x.GetType().GetProperty(ViewState(TESTING_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        tests = tests.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(TESTING_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    tests = tests.OrderBy(Function(x) x.AccessionDate).ThenBy(Function(y) y.PatientFarmOwnerName).ToList()
                End If
            End If

            gvTesting.DataSource = tests
            gvTesting.DataBind()
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
    Protected Sub Testing_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTesting.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then
                Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
                If Not tests Is Nothing Then
                    Dim btnToggleAllTesting As LinkButton = CType(e.Row.FindControl("btnToggleAllTesting"), LinkButton)
                    Dim btnHeaderTestingSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnHeaderTestingSetMyFavorite"), LinkButton)
                    Dim imgHeaderTestingMyFavoriteStar As Image = CType(e.Row.FindControl("imgHeaderTestingMyFavoriteStar"), Image)

                    If tests.Where(Function(x) x.RowSelectionIndicator = 1).Count = tests.Count And tests.Count > 0 Then
                        btnToggleAllTesting.CssClass = CSS_BTN_GLYPHICON_CHECKED
                    Else
                        btnToggleAllTesting.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                    End If

                    If tests.Where(Function(x) x.FavoriteIndicator = 1).Count = tests.Count And tests.Count > 0 Then
                        btnHeaderTestingSetMyFavorite.CssClass = CSS_MY_FAVORITE
                        imgHeaderTestingMyFavoriteStar.ImageUrl = "~/Includes/Images/whiteStar.png"
                    Else
                        btnHeaderTestingSetMyFavorite.CssClass = CSS_MY_FAVORITE_NO
                        imgHeaderTestingMyFavoriteStar.ImageUrl = "~/Includes/Images/blueStar.png"
                    End If
                End If
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim test As LabTestGetListModel = TryCast(e.Row.DataItem, LabTestGetListModel)
                    Dim i As Integer = 0

                    If Not test Is Nothing Then
                        Dim lblSampleStatusTypeName As Label = CType(e.Row.FindControl("lblTestingSampleStatusTypeName"), Label)
                        Dim btnToggleTesting As LinkButton = CType(e.Row.FindControl("btnToggleTesting"), LinkButton)
                        Dim lblTestStartedDate As Label = CType(e.Row.FindControl("lblTestingTestStartedDate"), Label)
                        Dim txtTestStartedDate As CalendarInput = CType(e.Row.FindControl("txtTestingTestStartedDate"), CalendarInput)
                        Dim cvFutureTestingTestStartedDate As CompareValidator = CType(e.Row.FindControl("cvFutureTestingTestStartedDate"), CompareValidator)
                        Dim lblTestingResultDate As Label = CType(e.Row.FindControl("lblTestingResultDate"), Label)
                        Dim txtTestingResultDate As CalendarInput = CType(e.Row.FindControl("txtTestingResultDate"), CalendarInput)
                        Dim cvFutureTestingResultDate As CompareValidator = CType(e.Row.FindControl("cvFutureTestingResultDate"), CompareValidator)
                        Dim clientID As String = sender.ClientID

                        If test.RowSelectionIndicator = 0 Then
                            btnToggleTesting.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                        Else
                            btnToggleTesting.CssClass = CSS_BTN_GLYPHICON_CHECKED
                        End If

                        Dim lblTestStatusTypeName As Label = CType(e.Row.FindControl("lblTestingTestStatusTypeName"), Label)
                        Dim ddlTestStatusType As DropDownList = CType(e.Row.FindControl("ddlTestingTestStatusType"), DropDownList)
                        ddlTestStatusType.DataSource = ddlTestStatusTypes.Items
                        ddlTestStatusType.DataTextField = "Text"
                        ddlTestStatusType.DataValueField = "Value"
                        ddlTestStatusType.DataBind()
                        ddlTestStatusType.SelectedValue = If(test.TestStatusTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, test.TestStatusTypeID)

                        Dim lblTestResultTypeName As Label = CType(e.Row.FindControl("lblTestingTestResultTypeName"), Label)
                        Dim ddlTestResultType As DropDownList = CType(e.Row.FindControl("ddlTestingTestResultType"), DropDownList)
                        ddlTestResultType.DataSource = ddlTestResultTypes.Items
                        ddlTestResultType.DataTextField = "Text"
                        ddlTestResultType.DataValueField = "Value"
                        ddlTestResultType.DataBind()
                        ddlTestResultType.SelectedValue = If(test.TestResultTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, test.TestResultTypeID.ToString())

                        Dim lblTestCategoryTypeName As Label = CType(e.Row.FindControl("lblTestingTestCategoryTypeName"), Label)
                        Dim ddlTestCategoryType As DropDownList = CType(e.Row.FindControl("ddlTestingTestCategoryType"), DropDownList)
                        ddlTestCategoryType.DataSource = ddlTestCategoryTypes.Items
                        ddlTestCategoryType.DataTextField = "Text"
                        ddlTestCategoryType.DataValueField = "Value"
                        ddlTestCategoryType.DataBind()
                        ddlTestCategoryType.SelectedValue = If(test.TestCategoryTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, test.TestCategoryTypeID)

                        Select Case test.TestStatusTypeID
                            Case TestStatusTypes.Amended
                                lblTestStatusTypeName.Visible = True
                                ddlTestStatusType.Visible = False

                                lblTestResultTypeName.Visible = True
                                ddlTestResultType.Visible = False

                                lblTestCategoryTypeName.Visible = True
                                ddlTestCategoryType.Visible = False
                            Case TestStatusTypes.Final
                                lblTestStatusTypeName.Visible = True
                                ddlTestStatusType.Visible = False

                                lblTestResultTypeName.Visible = True
                                ddlTestResultType.Visible = False

                                lblTestCategoryTypeName.Visible = True
                                ddlTestCategoryType.Visible = False
                            Case TestStatusTypes.MarkedForDeletion
                                lblTestStatusTypeName.Visible = True
                                ddlTestStatusType.Visible = False

                                lblTestResultTypeName.Visible = True
                                ddlTestResultType.Visible = False

                                lblTestCategoryTypeName.Visible = True
                                ddlTestCategoryType.Visible = False
                            Case Else
                                lblTestStatusTypeName.Visible = False
                                ddlTestStatusType.Visible = True

                                lblTestResultTypeName.Visible = False
                                ddlTestResultType.Visible = True

                                lblTestCategoryTypeName.Visible = False
                                ddlTestCategoryType.Visible = True
                        End Select

                        'TODO on LUC05: Verify systems settings allow test started and result dates to be editable.  This is associated with use case SAUC##  System Preferences.
                        lblTestStartedDate.Visible = True
                        lblTestStartedDate.Text = ToShortDate(lblTestStartedDate.Text)
                        txtTestStartedDate.Visible = False
                        cvFutureTestingTestStartedDate.ValueToCompare = Date.Now.ToShortDateString()

                        lblTestingResultDate.Visible = True
                        lblTestingResultDate.Text = ToShortDate(lblTestingResultDate.Text)
                        txtTestingResultDate.Visible = False
                        cvFutureTestingResultDate.ValueToCompare = Date.Now.ToShortDateString()

                        Dim btnSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnTestingSetMyFavorite"), LinkButton)
                        Dim imgMyFavoriteStar As Image = CType(e.Row.FindControl("imgTestingMyFavoriteStar"), Image)

                        If test.FavoriteIndicator Is Nothing Or test.FavoriteIndicator = 0 Then
                            btnSetMyFavorite.CssClass = CSS_MY_FAVORITE_NO
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/blueStar.png"
                        Else
                            btnSetMyFavorite.CssClass = CSS_MY_FAVORITE
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/whiteStar.png"
                        End If

                        Dim commentBoxEmptyLink As HtmlAnchor = CType(e.Row.FindControl("lnkTestingSampleStatusCommentEmpty"), HtmlAnchor)
                        commentBoxEmptyLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentBoxLink As HtmlAnchor = CType(e.Row.FindControl("lnkTestingSampleStatusComment"), HtmlAnchor)
                        commentBoxLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentEmptyJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divTestingCommentBoxEmptyContainer_" & e.Row.RowIndex & "').html(); }});"
                        Dim commentJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divTestingCommentBoxContainer_" & e.Row.RowIndex & "').html(); }});"

                        If test.AccessionComment.IsValueNullOrEmpty() Then
                            commentBoxEmptyLink.Visible = True
                            commentBoxLink.Visible = False
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentEmptyJavaScript, True)
                        Else
                            commentBoxEmptyLink.Visible = False
                            commentBoxLink.Visible = True
                            Dim commentTextBox As TextBox = CType(e.Row.FindControl("txtTestingCommentTextBox"), TextBox)
                            commentTextBox.Text = test.AccessionComment
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentJavaScript, True)
                        End If

                        If test.RowAction = RecordConstants.Insert Or
                            test.RowAction = RecordConstants.Update Or
                            test.RowAction = RecordConstants.Favorite Then
                            e.Row.CssClass = CSS_SAVE_PENDING
                        Else
                            e.Row.CssClass = CSS_NO_SAVE_PENDING
                        End If

                        lblSampleStatusTypeName.Visible = True
                    End If
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' TODO: Move to common area for the application.
    ''' </summary>
    ''' <param name="input"></param>
    ''' <returns></returns>
    Function ToShortDate(input)

        Dim c As CultureInfo = New CultureInfo(GetCurrentLanguage(), False)
        Threading.Thread.CurrentThread.CurrentCulture = c
        Try
            Return CType(input, Date).ToString("d")
        Catch ' null 
            Return String.Empty
        End Try

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestingTestStartedDate_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txtTestingTestStartedDate As TextBox = sender
            Dim row As GridViewRow = TryCast(txtTestingTestStartedDate.NamingContainer, GridViewRow)
            Dim dataKey As String = gvTesting.DataKeys(row.RowIndex).Value.ToString()

            UpdateTestingTestStartedDate(startedDate:=txtTestingTestStartedDate.Text, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="startedDate"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateTestingTestStartedDate(ByVal startedDate As String, ByVal testID As Long)

        Dim gridViewList As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        Dim pendingSaveList As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabTestGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().StartedDate = If(startedDate.IsValueNullOrEmpty, Nothing, startedDate)

        If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = gridViewList
        Session(SESSION_TESTING_SAVE_LIST) = pendingSaveList
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestingResultDate_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txtTestingTestResultDate As TextBox = sender
            Dim row As GridViewRow = TryCast(txtTestingTestResultDate.NamingContainer, GridViewRow)
            Dim dataKey As String = gvTesting.DataKeys(row.RowIndex).Value.ToString()

            UpdateTestingTestResultDate(resultDate:=txtTestingTestResultDate.Text, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="resultDate"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateTestingTestResultDate(ByVal resultDate As String, ByVal testID As Long)

        Dim gridViewList As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        Dim pendingSaveList As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabTestGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().ResultDate = If(resultDate.IsValueNullOrEmpty, Nothing, resultDate)

        If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = gridViewList
        Session(SESSION_TESTING_SAVE_LIST) = pendingSaveList
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Testing_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvTesting.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelectAll
                        Dim btnToggleAllTesting As LinkButton = CType(e.CommandSource, LinkButton)
                        Dim toggleIndicator As Boolean = False

                        If btnToggleAllTesting.CssClass = CSS_BTN_GLYPHICON_UNCHECKED Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleAllTesting(toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.ToggleSelect
                        Dim toggleIndicator As Boolean = False

                        If CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel)).Where(Function(x) x.TestID = e.CommandArgument).FirstOrDefault().RowSelectionIndicator = 0 Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleTesting(testID:=e.CommandArgument, toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.EditCommand
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditTest.ToString()
                        InitializeControl(tab:=LaboratoryModuleTabConstants.Testing, testID:=CType(e.CommandArgument, Long))
                    Case GridViewCommandConstants.MyFavoriteCommand
                        Dim list As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel)).Where(Function(x) x.SampleID = e.CommandArgument).ToList()
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite As LabFavoriteGetListModel
                        For Each item As LabTestGetListModel In list
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next
                        SetMyFavorite(False, favorites)
                        btnTestingSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                        upTestingSave.Update()
                        upTesting.Update()
                        upTransferred.Update()
                        upBatches.Update()
                    Case GridViewCommandConstants.SelectAllRecordsMyFavoriteCommand
                        Dim selectAll As Boolean = False
                        Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite = New LabFavoriteGetListModel()

                        If tests Is Nothing Then
                            tests = New List(Of LabTestGetListModel)()
                        End If

                        If tests.Where(Function(x) x.FavoriteIndicator = 1).Count < tests.Count() Then
                            selectAll = True
                        End If

                        For Each item As LabTestGetListModel In tests
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next

                        SetMyFavorite(selectAll, favorites)
                        upTestingSave.Update()
                        btnTestingSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Testing_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvTesting.Sorting

        Try
            ViewState(TESTING_SORT_DIRECTION) = IIf(ViewState(TESTING_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(TESTING_SORT_EXPRESSION) = e.SortExpression

            FillDropDowns()

            BindTestingGridView()

            upTesting.Update()
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
    Protected Sub TestingTestResultType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddlTestingTestResultType As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddlTestingTestResultType.NamingContainer, GridViewRow)
            Dim dataKey As String = gvTesting.DataKeys(row.RowIndex).Value.ToString()

            UpdateTestResult(testResultTypeID:=ddlTestingTestResultType.SelectedValue, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testResultTypeID"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateTestResult(ByVal testResultTypeID As String, ByVal testID As Long)

        Dim gridViewList As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        Dim pendingSaveList As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabTestGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        If testResultTypeID.IsValueNullOrEmpty = True Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestResultTypeID = Nothing
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeID = TestStatusTypes.InProgress
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().ResultDate = Nothing
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().ResultEnteredByPersonID = Nothing
            If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
                gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
            End If
        Else
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestResultTypeID = If(testResultTypeID.IsValueNullOrEmpty, Nothing, testResultTypeID)
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeID = TestStatusTypes.Preliminary
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().ResultDate = Date.Now
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().ResultEnteredByPersonID = hdfPersonID.Value
            If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
                gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
            End If
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = gridViewList
        Session(SESSION_TESTING_SAVE_LIST) = pendingSaveList
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestingTestStatusType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddlTestingTestStatusType As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddlTestingTestStatusType.NamingContainer, GridViewRow)
            Dim dataKey As String = gvTesting.DataKeys(row.RowIndex).Value.ToString()

            UpdateTestStatus(testStatusTypeID:=ddlTestingTestStatusType.SelectedValue, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testStatusTypeID"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateTestStatus(ByVal testStatusTypeID As String, ByVal testID As Long)

        Dim gridViewList As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        Dim pendingSaveList As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabTestGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeID = If(testStatusTypeID.IsValueNullOrEmpty, Nothing, testStatusTypeID)

        If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = gridViewList
        Session(SESSION_TESTING_SAVE_LIST) = pendingSaveList
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestingTestCategoryType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddlTestingTestCategoryType As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddlTestingTestCategoryType.NamingContainer, GridViewRow)
            Dim dataKey As String = gvTesting.DataKeys(row.RowIndex).Value.ToString()

            UpdateTestCategory(testCategoryTypeID:=ddlTestingTestCategoryType.SelectedValue, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testCategoryTypeID"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateTestCategory(ByVal testCategoryTypeID As String, ByVal testID As Long)

        Dim gridViewList As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        Dim pendingSaveList As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabTestGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestCategoryTypeID = If(testCategoryTypeID.IsValueNullOrEmpty, Nothing, testCategoryTypeID)

        If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = gridViewList
        Session(SESSION_TESTING_SAVE_LIST) = pendingSaveList
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testID"></param>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleTesting(testID As Long, toggleIndicator As Boolean)

        Try
            Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            If tests Is Nothing Then
                tests = New List(Of LabTestGetListModel)()
            End If

            If toggleIndicator = True Then
                tests.Where(Function(x) x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 1
                btnTestingAssignTest.Enabled = True

                If tests.Where(Function(x) x.TestID = testID).FirstOrDefault().TestResultTypeID Is Nothing Then
                    Dim selectedCount As Integer = tests.Where(Function(x) x.RowSelectionIndicator = 1).Count
                    Dim selectedtestNameTypeID As Long? = tests.Where(Function(x) x.TestID = testID).FirstOrDefault().TestNameTypeID
                    If selectedCount = tests.Where(Function(x) x.TestNameTypeID = selectedtestNameTypeID).Count Or tests.Where(Function(x) x.RowSelectionIndicator = 1).Count = 1 Then
                        btnTestingBatch.Enabled = True
                    Else
                        btnTestingBatch.Enabled = False
                    End If
                Else
                    btnTestingBatch.Enabled = False
                End If

                If tests.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeID = TestStatusTypes.InProgress Or
                    tests.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeID = TestStatusTypes.Preliminary Then
                    ucTestingMenu.SetDeleteTestDisabled(False)
                Else
                    ucTestingMenu.SetDeleteTestDisabled(True)
                End If
            Else
                tests.Where(Function(x) x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 0

                If tests.Where(Function(x) x.RowSelectionIndicator = 1).Count = 0 Then
                    btnTestingAssignTest.Enabled = False
                    btnTestingBatch.Enabled = False
                    ucTestingMenu.SetDeleteTestDisabled(True)
                Else
                    If tests.Where(Function(x) x.TestStatusTypeID = TestStatusTypes.InProgress Or x.TestStatusTypeID = TestStatusTypes.Preliminary).Count > 0 Then
                        ucTestingMenu.SetDeleteTestDisabled(False)
                    Else
                        ucTestingMenu.SetDeleteTestDisabled(True)
                    End If
                End If
            End If

            Session(SESSION_TESTING_LIST) = tests
            FillDropDowns()
            gvTesting.PageIndex = lblTestingPageNumber.Text - 1
            BindTestingGridView()
            upTestingMenu.Update()
            upTestingButtons.Update()
            upTesting.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the testing select/deselect all toggle event.
    ''' </summary>
    Private Sub ToggleAllTesting(toggleIndicator As Boolean)

        Try
            Dim index As Integer = 0
            Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))

            If toggleIndicator = True Then
                For Each test In tests
                    tests(index).RowSelectionIndicator = 1
                    index += 1
                Next

                btnTestingAssignTest.Enabled = True
                btnTestingBatch.Enabled = True
            Else
                For Each test In tests
                    tests(index).RowSelectionIndicator = 0
                    index += 1
                Next

                btnTestingAssignTest.Enabled = False
                btnTestingBatch.Enabled = False
            End If

            Session(SESSION_TESTING_LIST) = tests
            FillDropDowns()
            gvTesting.PageIndex = lblTestingPageNumber.Text - 1
            BindTestingGridView()
            upTestingButtons.Update()
            upTestingMenu.Update()
            upTesting.Update()
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
    Protected Sub TestingSave_Click(sender As Object, e As EventArgs) Handles btnTestingSave.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Validate("Testing")

            If (Page.IsValid) Then
                AddUpdateLaboratory()

                Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
                Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))

                If tests Is Nothing Then
                    tests = New List(Of LabTestGetListModel)()
                End If

                If testsPendingSave Is Nothing Then
                    testsPendingSave = New List(Of LabTestGetListModel)()
                End If
                For Each test In testsPendingSave
                    test.RowSelectionIndicator = 1
                    test.RowAction = String.Empty
                Next

                Dim index As Integer = 0

                If chkSamplePrintBarcodes.Checked = True Or hdfSamplePrintBarcodes.Value = "True" Then
                    chkSamplePrintBarcodes.Checked = False

                    For Each test As LabTestGetListModel In testsPendingSave
                        If tests.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                            index = tests.FindIndex(Function(x) x.TestID = test.TestID)
                            tests(index) = test
                        End If
                        index += 1
                    Next

                    InitializePrintBarCode(LaboratoryModuleTabConstants.Testing)
                    hdfSamplePrintBarcodes.Value = "False"
                End If

                FillDropDowns()

                Dim testingParameters = New LaboratoryTestGetListParameters With {.BatchTestID = Nothing, .LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .SampleID = Nothing, .UserID = hdfUserID.Value}
                Dim testingCounts = LaboratoryAPIService.LaboratoryTestGetListCountAsync(parameters:=testingParameters).Result
                lblTestingCount.Text = testingCounts(0).RecordCount
                hdfTestingCount.Value = testingCounts(0).RecordCount

                lblTestingPageNumber.Text = 1
                gvTesting.PageIndex = 0
                FillTestingList(pageIndex:=1, paginationSetNumber:=1)

                tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))

                If tests Is Nothing Then
                    tests = New List(Of LabTestGetListModel)()
                End If

                For Each test As LabTestGetListModel In testsPendingSave
                    If tests.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                        index = tests.FindIndex(Function(x) x.TestID = test.TestID)
                        tests(index) = test
                    End If
                    index += 1
                Next

                ViewState(TESTING_SORT_DIRECTION) = SortConstants.Descending
                ViewState(TESTING_SORT_EXPRESSION) = "RowSelectionIndicator"
                BindTestingGridView()

                Session(SESSION_TESTING_SAVE_LIST) = New List(Of LabTestGetListModel)()

                FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
                lblApprovalsPageNumber.Text = 1
                BindApprovalsGridView()
                upApprovals.Update()
                upApprovalsButtons.Update()
                upApprovalsMenu.Update()
                upApprovalsSave.Update()

                FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                BindMyFavoritesGridView()

                FillTabCounts()

                upLaboratoryTabCounts.Update()
                upTesting.Update()
                upTestingButtons.Update()
                upTestingSave.Update()
                upTestingMenu.Update()
                'VerifyUserPermissions(False)

                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            Else
                DisplayValidationErrors()
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
    ''' <param name="tests"></param>
    ''' <returns></returns>
    Private Function ValidateTesting(tests As List(Of LabTestGetListModel)) As Boolean

        Dim validateStatus As Boolean = True
        Dim errorMessages As New StringBuilder()

        For Each test In tests
            If (test.AccessionConditionTypeID = AccessionConditionTypes.AcceptedInPoorCondition Or
                test.AccessionConditionTypeID = AccessionConditionTypes.Rejected) Then

                If test.AccessionComment.IsValueNullOrEmpty() Then
                    errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Required") & "</p>")
                    validateStatus = False
                ElseIf test.AccessionComment.Length < 7 Then
                    errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Comment_Length") & "</p>")
                    validateStatus = False
                End If
            End If
        Next

        Return validateStatus

    End Function

#End Region

#Region "Edit Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testID"></param>
    ''' <param name="batchTestID"></param>
    Private Sub InitializeEditTest(testID As Long, Optional batchTestID As Long? = Nothing)

        Try
            If testID = 0 Then
                ShowWarningMessage(messageType:=MessageType.CannotSetTestResult, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Test_Must_Be_Selected_Body_Text"))

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "hideModal('#divSampleTestDetailsModal');", True)
            Else
                Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))

                If tests Is Nothing Then
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    Dim parameters = New LaboratoryTestGetListParameters With {.BatchTestID = batchTestID, .TestID = testID, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
                    tests = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result
                ElseIf tests.Where(Function(x) x.TestID = testID).Count = 0 Then
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    Dim parameters = New LaboratoryTestGetListParameters With {.BatchTestID = batchTestID, .TestID = testID, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
                    tests = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result
                End If

                ucAddUpdateTest.Test = tests.Where(Function(x) x.TestID = testID).FirstOrDefault()

                If samples Is Nothing Then
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If

                    ucAddUpdateSample.Sample = ConvertSample(LaboratoryAPIService.LaboratorySampleGetDetailAsync(GetCurrentLanguage(), ucAddUpdateTest.Test.SampleID).Result.FirstOrDefault())
                ElseIf samples.Where(Function(x) x.SampleID = ucAddUpdateTest.Test.SampleID).Count() > 0 Then
                    ucAddUpdateSample.Sample = samples.Where(Function(x) x.SampleID = tests.Where(Function(y) y.TestID = testID).FirstOrDefault().SampleID).FirstOrDefault()
                Else
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    ucAddUpdateSample.Sample = ConvertSample(LaboratoryAPIService.LaboratorySampleGetDetailAsync(GetCurrentLanguage(), ucAddUpdateTest.Test.SampleID).Result.FirstOrDefault())
                End If

                If ucAddUpdateSample.Sample.TransferCount = 0 Then
                    divTransferDetailsAccordionPanel.Visible = False
                Else
                    divTransferDetailsAccordionPanel.Visible = True
                End If

                ucAddUpdateSample.Setup()
                ucAddUpdateTest.Setup(tests.Count, testID:=testID)

                If tests.Where(Function(x) x.TestID = testID).FirstOrDefault().TransferCount > 0 Then
                    Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))

                    If transfers Is Nothing Then
                        If LaboratoryAPIService Is Nothing Then
                            LaboratoryAPIService = New LaboratoryServiceClient()
                        End If
                        Dim transferredParameters = New LaboratoryTransferGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .OrganizationID = hdfOrganizationID.Value, .SampleID = ucAddUpdateTest.Test.SampleID, .UserID = hdfUserID.Value}
                        ucTransferSampleForSampleTestDetails.Transfer = LaboratoryAPIService.LaboratoryTransferGetListAsync(transferredParameters).Result.FirstOrDefault()
                    ElseIf transfers.Where(Function(x) x.TransferredInSampleID = ucAddUpdateTest.Test.SampleID Or x.TransferredOutSampleID = ucAddUpdateTest.Test.SampleID).Count() > 0 Then
                        ucTransferSampleForSampleTestDetails.Transfer = transfers.Where(Function(x) x.TransferredInSampleID = tests.Where(Function(y) y.TestID = testID).FirstOrDefault().SampleID Or
                                                                        x.TransferredOutSampleID = tests.Where(Function(y) y.TestID = testID).FirstOrDefault().SampleID).FirstOrDefault()
                    Else
                        If LaboratoryAPIService Is Nothing Then
                            LaboratoryAPIService = New LaboratoryServiceClient()
                        End If
                        Dim transferredParameters = New LaboratoryTransferGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .OrganizationID = hdfOrganizationID.Value, .SampleID = ucAddUpdateTest.Test.SampleID, .UserID = hdfUserID.Value}
                        ucTransferSampleForSampleTestDetails.Transfer = LaboratoryAPIService.LaboratoryTransferGetListAsync(transferredParameters).Result.FirstOrDefault()
                    End If

                    ucAddUpdateTest.SetFromTransfer(ucTransferSample.Transfer)
                    ucTransferSampleForSampleTestDetails.Setup()
                End If

                ucAdditionalTestDetails.Setup(ucAddUpdateTest.Test.Note, ucAddUpdateTest.Test.EIDSSBatchTestID, ucAddUpdateTest.Test.BatchStatusTypeName, ucAddUpdateTest.Test.BatchTestTestNameTypeID, ucAddUpdateTest.Test.QualityControlValuesObservationID)

                ucAmendmentHistory.Setup(testID:=testID)

                ToggleVisibility(LaboratoryModuleActions.EditTest.ToString())

                upAccordionAddUpdateSample.Update()
                upAmendmentHistory.Update()

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_EDIT_TEST_MODAL, True)
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
    Protected Sub ShowTestDetailsForm_Click(sender As Object, e As ImageClickEventArgs) Handles btnShowTestDetailsForm.Click

        Try
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTestDetailsFormModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event for the add/update test show error.
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdateTest_ShowErrorModal(messageType As MessageType, message As String) Handles ucAddUpdateTest.ShowErrorModal

        ShowErrorMessage(messageType:=messageType, message:=GetErrorMessages("EditSampleTestDetails"))

    End Sub


#End Region

#Region "Amend Test Result Methods"

    ''' <summary>
    ''' Initializes and sets up the create aliquot modal popup.
    ''' 
    ''' The sample count is used to track the sample identifier to keep the new samples added unique 
    ''' from existing samples or any previously registered samples for this session.  The sample identity 
    ''' for newly registered samples prior to saving use negative numbers to avoid an existing sample 
    ''' duplicate identifier.
    ''' </summary>
    Private Sub InitializeAmendTestResult()

        Try
            Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            Dim testsPendingSave As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim testsToAmend = New List(Of LabTestGetListModel)()
            Dim test As LabTestGetListModel

            Dim errorMessages As New StringBuilder()

            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
            End If

            For Each test In tests
                If test.RowSelectionIndicator = 1 Then
                    testsToAmend.Add(test)
                End If
            Next

            If ValidateTestForAmendTestResult(testsToAmend, errorMessages:=errorMessages) = True Then
                Dim index As Integer = 0

                ucAmendTestResult.Setup(testsToAmend.FirstOrDefault())
            Else
                ShowErrorMessage(messageType:=MessageType.CannotDeleteSample, message:=errorMessages.ToString())
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <param name="errorMessages"></param>
    ''' <returns></returns>
    Private Function ValidateTestForAmendTestResult(tests As List(Of LabTestGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        If tests.Count > 1 Then
            errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Test_Must_Be_Final") & "</p>")
            validateStatus = False
        End If

        For Each test In tests
            If test.RowSelectionIndicator = 1 Then
                If (Not test.TestStatusTypeID = TestStatusTypes.Final) Then
                    errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Test_Must_Be_Final") & "</p>")
                    validateStatus = False
                End If
            End If
        Next

        Return validateStatus

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub Amend_Click(sender As Object, e As EventArgs) Handles btnAmend.Click

        Try
            Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim testAmendementsPendingSave = CType(Session(SESSION_TEST_AMENDMENTS_LIST), List(Of TestAmendmentParameters))
            Dim testAmendment = ucAmendTestResult.Amend()
            Dim test = New LabTestGetListModel()
            Dim index As Integer = 0

            If tests.Where(Function(x) x.TestID = testAmendment.TestID).Count() > 0 Then
                index = tests.FindIndex(Function(x) x.TestID = testAmendment.TestID)
                test = tests(index)
                test.TestStatusTypeID = TestStatusTypes.Amended
                test.TestStatusTypeName = Resources.Labels.Lbl_Amended_Text
                test.TestResultTypeID = testAmendment.ChangedTestResultTypeID
                test.TestResultTypeName = ucAmendTestResult.TestResultTypeName
                test.RowAction = RecordConstants.Update

                tests(index) = test
            Else
                If LaboratoryAPIService Is Nothing Then
                    LaboratoryAPIService = New LaboratoryServiceClient()
                End If

                Dim parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = testAmendment.TestID, .UserID = hdfUserID.Value}
                test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result.FirstOrDefault()

                test.TestStatusTypeID = TestStatusTypes.Amended
                test.TestStatusTypeName = Resources.Labels.Lbl_Amended_Text
                test.TestResultTypeID = testAmendment.ChangedTestResultTypeID
                test.TestResultTypeName = ucAmendTestResult.TestResultTypeName
                test.RowAction = RecordConstants.Update

                tests.Add(test)
            End If

            index = 0
            If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                testsPendingSave(index) = test
            Else
                testsPendingSave.Add(test)
            End If

            index = 0
            If testAmendementsPendingSave.Where(Function(x) x.TestAmendmentID = testAmendment.TestAmendmentID).Count() > 0 Then
                index = testAmendementsPendingSave.FindIndex(Function(x) x.TestAmendmentID = testAmendment.TestAmendmentID)
                testAmendementsPendingSave(index) = testAmendment
            Else
                testAmendementsPendingSave.Add(testAmendment)
            End If

            Session(SESSION_TESTING_LIST) = tests
            Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
            Session(SESSION_TEST_AMENDMENTS_LIST) = testAmendementsPendingSave

            FillDropDowns()
            gvTesting.PageIndex = 0
            lblTestingPageNumber.Text = 1
            BindTestingGridView()
            FillTestingPager(hdfTestingCount.Value, 1)

            upTesting.Update()
            upTestingButtons.Update()
            upTestingMenu.Update()
            upTestingSave.Update()
            upTestingSearchResults.Update()

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAmendTestResultModal"), True)
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
    Protected Sub CancelAmendTestResultModal(sender As Object, e As EventArgs) Handles btnCancelAmendTestResultModal.Click

        Try
            hdfCurrentModuleAction.Value = LaboratoryModuleActions.AmendTestResult
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Transferred Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillTransferredList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            If hdfAdvancedSearchIndicator.Value = YesNoUnknown.No And hdgTestingQueryText.InnerText = String.Empty Then
                Dim parameters = New LaboratoryTransferGetListParameters With {.LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = paginationSetNumber, .SampleID = Nothing, .UserID = hdfUserID.Value}
                Session(SESSION_TRANSFERRED_LIST) = LaboratoryAPIService.LaboratoryTransferGetListAsync(parameters).Result
            Else
                If hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes Then
                    ucSearchSample.FillTransferredList()
                Else
                    ucTransferredSearch.Search()
                End If
            End If

            FillTransferredPager(lblTransferredCount.Text, pageIndex)
            ViewState(TRANSFERRED_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillTransferredPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divTransferredPager.Visible = True

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
            rptTransferredPager.DataSource = pages
            rptTransferredPager.DataBind()
        Else
            divTransferredPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TransferredPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblTransferredPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvTransferred.PageSize)

            FillDropDowns()

            If Not ViewState(TRANSFERRED_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvTransferred.PageIndex = gvTransferred.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvTransferred.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvTransferred.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvTransferred.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvTransferred.PageIndex = gvTransferred.PageSize - 1
                        Else
                            gvTransferred.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillTransferredList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvTransferred.PageIndex = gvTransferred.PageSize - 1
                Else
                    gvTransferred.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindTransferredGridView()
                FillTransferredPager(lblTransferredCount.Text, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindTransferredGridView()

        Try
            Dim transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
            Dim transfersPendingSave = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))

            If transfers Is Nothing Then
                transfers = New List(Of LabTransferGetListModel)()
                Session(SESSION_TRANSFERRED_LIST) = transfers
            End If

            If transfersPendingSave Is Nothing Then
                transfersPendingSave = New List(Of LabTransferGetListModel)()
                Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave
            End If

            If transfersPendingSave.Count > 0 Then
                If (Not ViewState(TRANSFERRED_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(TRANSFERRED_SORT_DIRECTION) = SortConstants.Ascending Then
                        transfers = transfers.OrderBy(Function(x) x.GetType().GetProperty(ViewState(TRANSFERRED_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        transfers = transfers.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(TRANSFERRED_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    transfers = transfers.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.AccessionDate).ThenBy(Function(z) z.PatientFarmOwnerName).ToList()
                End If
            Else
                If (Not ViewState(TRANSFERRED_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(TRANSFERRED_SORT_DIRECTION) = SortConstants.Ascending Then
                        transfers = transfers.OrderBy(Function(x) x.GetType().GetProperty(ViewState(TRANSFERRED_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        transfers = transfers.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(TRANSFERRED_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    transfers = transfers.OrderBy(Function(x) x.AccessionDate).ThenBy(Function(y) y.PatientFarmOwnerName).ToList()
                End If
            End If

            If transfers.Where(Function(x) x.RowSelectionIndicator = 1).Count = 0 Then
                btnCancelTransfer.Enabled = False
                btnPrintTransfer.Attributes.Add("disabled", "disabled")
            Else
                btnCancelTransfer.Enabled = True
                btnPrintTransfer.Attributes.Remove("disabled")
            End If

            If transfersPendingSave.Count = 0 Then
                btnTransferredSave.Enabled = False
            Else
                btnTransferredSave.Enabled = True
            End If

            gvTransferred.DataSource = transfers
            gvTransferred.DataBind()
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
    Protected Sub Transferred_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTransferred.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then
                Dim transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
                If Not transfers Is Nothing Then
                    Dim btnToggleAllTransferred As LinkButton = CType(e.Row.FindControl("btnToggleAllTransferred"), LinkButton)
                    Dim btnHeaderTransferredSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnHeaderTransferredSetMyFavorite"), LinkButton)
                    Dim imgHeaderTransferredMyFavoriteStar As Image = CType(e.Row.FindControl("imgHeaderTransferredMyFavoriteStar"), Image)

                    If transfers.Where(Function(x) x.RowSelectionIndicator = 1).Count = transfers.Count And transfers.Count > 0 Then
                        btnToggleAllTransferred.CssClass = CSS_BTN_GLYPHICON_CHECKED
                    Else
                        btnToggleAllTransferred.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                    End If

                    If transfers.Where(Function(x) x.FavoriteIndicator = 1).Count = transfers.Count And transfers.Count > 0 Then
                        btnHeaderTransferredSetMyFavorite.CssClass = CSS_MY_FAVORITE
                        imgHeaderTransferredMyFavoriteStar.ImageUrl = "~/Includes/Images/whiteStar.png"
                    Else
                        btnHeaderTransferredSetMyFavorite.CssClass = CSS_MY_FAVORITE_NO
                        imgHeaderTransferredMyFavoriteStar.ImageUrl = "~/Includes/Images/blueStar.png"
                    End If
                End If
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim transfer As LabTransferGetListModel = TryCast(e.Row.DataItem, LabTransferGetListModel)
                    Dim clientID As String = sender.ClientID
                    Dim i As Integer = 0

                    If Not transfer Is Nothing Then
                        Dim lblSampleStatusTypeName As Label = CType(e.Row.FindControl("lblTransferredSampleStatusTypeName"), Label)
                        Dim btnToggleTransferred As LinkButton = CType(e.Row.FindControl("btnToggleTransferred"), LinkButton)
                        Dim btnSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnTransferredSetMyFavorite"), LinkButton)
                        Dim imgMyFavoriteStar As Image = CType(e.Row.FindControl("imgTransferredMyFavoriteStar"), Image)
                        Dim txtPointOfContact As TextBox = CType(e.Row.FindControl("txtPointOfContact"), TextBox)
                        Dim txtTransferredResultDate As CalendarInput = CType(e.Row.FindControl("txtTransferredResultDate"), CalendarInput)
                        Dim pnlTestResultType As Panel = CType(e.Row.FindControl("pnlTestResultType"), Panel)
                        Dim cvFutureTransferredResultDate As CompareValidator = CType(e.Row.FindControl("cvFutureTransferredResultDate"), CompareValidator)
                        Dim ddlTestResultType As DropDownList = CType(e.Row.FindControl("ddlTransferredTestResultType"), DropDownList)

                        If transfer.RowSelectionIndicator = 0 Then
                            btnToggleTransferred.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                        Else
                            btnToggleTransferred.CssClass = CSS_BTN_GLYPHICON_CHECKED
                        End If

                        If transfer.FavoriteIndicator Is Nothing Then
                            btnSetMyFavorite.CssClass = CSS_MY_FAVORITE_NO
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/blueStar.png"
                        Else
                            btnSetMyFavorite.CssClass = CSS_MY_FAVORITE
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/whiteStar.png"
                        End If

                        ddlTestResultType.DataSource = ddlTestResultTypes.Items
                        ddlTestResultType.DataTextField = "Text"
                        ddlTestResultType.DataValueField = "Value"
                        ddlTestResultType.DataBind()
                        ddlTestResultType.SelectedValue = If(transfer.TestResultTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, transfer.TestResultTypeID)

                        cvFutureTransferredResultDate.ValueToCompare = Date.Now.ToShortDateString()

                        If transfer.ResultDate Is Nothing Then
                            txtTransferredResultDate.Text = String.Empty
                        Else
                            txtTransferredResultDate.Text = ToShortDate(transfer.ResultDate)
                        End If

                        Dim upTestResultType As UpdatePanel = CType(e.Row.FindControl("upTransferredTestResultType"), UpdatePanel)

                        'TODO: Verify with BA team that any transferred sample with a test pending results would have a test name.
                        If transfer.TestAssignedIndicator = 1 And transfer.NonEIDSSLaboratoryIndicator = 1 And transfer.TestNameTypeName.IsValueNullOrEmpty = False Then
                            pnlTestResultType.Enabled = True
                            txtPointOfContact.Enabled = True
                            txtTransferredResultDate.Enabled = True
                        Else
                            pnlTestResultType.Enabled = False
                            txtPointOfContact.Enabled = False
                            txtTransferredResultDate.Enabled = False
                        End If

                        Dim commentBoxEmptyLink As HtmlAnchor = CType(e.Row.FindControl("lnkTransferredSampleStatusCommentEmpty"), HtmlAnchor)
                        commentBoxEmptyLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentBoxLink As HtmlAnchor = CType(e.Row.FindControl("lnkTransferredSampleStatusComment"), HtmlAnchor)
                        commentBoxLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentEmptyJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divTransferredCommentBoxEmptyContainer_" & e.Row.RowIndex & "').html(); }});"
                        Dim commentJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divTransferredCommentBoxContainer_" & e.Row.RowIndex & "').html(); }});"

                        If transfer.AccessionComment.IsValueNullOrEmpty() Then
                            commentBoxEmptyLink.Visible = True
                            commentBoxLink.Visible = False
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentEmptyJavaScript, True)
                        Else
                            commentBoxEmptyLink.Visible = False
                            commentBoxLink.Visible = True
                            Dim commentTextBox As TextBox = CType(e.Row.FindControl("txtTransferredCommentTextBox"), TextBox)
                            commentTextBox.Text = transfer.AccessionComment
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentJavaScript, True)
                        End If

                        If transfer.RowAction = RecordConstants.Update Or
                            transfer.RowAction = RecordConstants.Accession Or
                            transfer.RowAction = RecordConstants.Favorite Then
                            e.Row.CssClass = CSS_SAVE_PENDING
                        Else
                            If transfer.RowAction = RecordConstants.Accession Or transfer.RowAction = RecordConstants.InsertAccession Then
                                e.Row.CssClass = CSS_UNACCESSIONED_SAVE_PENDING
                            Else
                                e.Row.CssClass = CSS_NO_SAVE_PENDING
                            End If
                        End If

                        lblSampleStatusTypeName.Visible = True
                    End If
                End If
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
    Protected Sub Transferred_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvTransferred.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelectAll
                        Dim btnToggleAllTransferred As LinkButton = CType(e.CommandSource, LinkButton)
                        Dim toggleIndicator As Boolean = False

                        If btnToggleAllTransferred.CssClass = CSS_BTN_GLYPHICON_UNCHECKED Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleAllTransferred(toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.ToggleSelect
                        Dim toggleIndicator As Boolean = False
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        If commandArguments(1).IsValueNullOrEmpty Then
                            If CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel)).Where(Function(x) x.TransferID = commandArguments(0)).FirstOrDefault().RowSelectionIndicator = 0 Then
                                toggleIndicator = True
                            Else
                                toggleIndicator = False
                            End If

                            ToggleTransferred(transferID:=commandArguments(0), testID:=Nothing, toggleIndicator:=toggleIndicator)
                        Else
                            If CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel)).Where(Function(x) x.TransferID = commandArguments(0) And x.TestID = commandArguments(1)).FirstOrDefault().RowSelectionIndicator = 0 Then
                                toggleIndicator = True
                            Else
                                toggleIndicator = False
                            End If

                            ToggleTransferred(transferID:=commandArguments(0), testID:=commandArguments(1), toggleIndicator:=toggleIndicator)
                        End If

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.EditCommand
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditTransfer.ToString()
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")

                        If commandArguments(1).IsValueNullOrEmpty Then
                            InitializeControl(tab:=LaboratoryModuleTabConstants.Transferred, transferID:=CType(commandArguments(0), Long), testID:=Nothing)
                        Else
                            InitializeControl(tab:=LaboratoryModuleTabConstants.Transferred, transferID:=CType(commandArguments(0), Long), testID:=CType(commandArguments(1), Long))
                        End If
                    Case GridViewCommandConstants.MyFavoriteCommand
                        Dim list As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel)).Where(Function(x) x.TransferredOutSampleID = e.CommandArgument).ToList()
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite As LabFavoriteGetListModel
                        For Each item As LabTransferGetListModel In list
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.TransferredOutSampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .SampleTypeName = item.SampleTypeName
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next
                        SetMyFavorite(False, favorites)
                        btnTransferredSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                        upTesting.Update()
                    Case GridViewCommandConstants.SelectAllRecordsMyFavoriteCommand
                        Dim selectAll As Boolean = False
                        Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite = New LabFavoriteGetListModel()

                        If transfers Is Nothing Then
                            transfers = New List(Of LabTransferGetListModel)()
                        End If

                        If transfers.Where(Function(x) x.FavoriteIndicator = 1).Count < transfers.Count() Then
                            selectAll = True
                        End If

                        For Each item As LabTransferGetListModel In transfers
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.TransferredOutSampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .SampleTypeName = item.SampleTypeName
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next

                        SetMyFavorite(selectAll, favorites)
                        btnTransferredSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Transferred_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvTransferred.Sorting

        Try
            ViewState(TRANSFERRED_SORT_DIRECTION) = IIf(ViewState(TRANSFERRED_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(TRANSFERRED_SORT_EXPRESSION) = e.SortExpression

            FillDropDowns()

            BindTransferredGridView()

            upTransferred.Update()
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
    Protected Sub TransferredResultDate_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txt As TextBox = sender
            Dim row As GridViewRow = TryCast(txt.NamingContainer, GridViewRow)

            If txt.Text.IsValueNullOrEmpty = False Then
                UpdateTransferResultDate(resultDate:=txt.Text, testID:=gvTransferred.DataKeys(row.RowIndex).Values(1), transferID:=gvTransferred.DataKeys(row.RowIndex).Values(0))
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
    Protected Sub PointOfContact_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txt As TextBox = sender
            Dim row As GridViewRow = TryCast(txt.NamingContainer, GridViewRow)

            UpdateTransferPointOfContact(pointOfContact:=txt.Text, testID:=gvTransferred.DataKeys(row.RowIndex).Values(1), transferID:=gvTransferred.DataKeys(row.RowIndex).Values(0))
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
    Protected Sub TransferredTestResultType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddl As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddl.NamingContainer, GridViewRow)

            If ddl.SelectedValue.IsValueNullOrEmpty Then
                UpdateTransferTestResult(testResultTypeID:=String.Empty, testResultTypeName:=String.Empty, testID:=gvTransferred.DataKeys(row.RowIndex).Values(1), transferID:=gvTransferred.DataKeys(row.RowIndex).Values(0))
            Else
                UpdateTransferTestResult(testResultTypeID:=ddl.SelectedValue, testResultTypeName:=ddl.SelectedItem.Text, testID:=gvTransferred.DataKeys(row.RowIndex).Values(1), transferID:=gvTransferred.DataKeys(row.RowIndex).Values(0))
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="resultDate"></param>
    ''' <param name="testID"></param>
    ''' <param name="transferID"></param>
    Private Sub UpdateTransferResultDate(ByVal resultDate As DateTime, ByVal testID As Long, ByVal transferID As Long)

        Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        If Session(SESSION_TESTING_LIST) Is Nothing Then
            tests = New List(Of LabTestGetListModel)()
        Else
            tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        End If

        Dim testsPendingSave As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            testsPendingSave = New List(Of LabTestGetListModel)()
        Else
            testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
        If Session(SESSION_TRANSFERRED_LIST) Is Nothing Then
            transfers = New List(Of LabTransferGetListModel)()
        Else
            transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
        End If

        Dim transfersPendingSave As List(Of LabTransferGetListModel)
        If Session(SESSION_TRANSFERRED_SAVE_LIST) Is Nothing Then
            transfersPendingSave = New List(Of LabTransferGetListModel)()
        Else
            transfersPendingSave = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))
        End If

        Dim transfer As LabTransferGetListModel = transfers.Where(Function(x) x.TransferID And x.TestID = testID).FirstOrDefault()

        Dim test As LabTestGetListModel
        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If
        Dim parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = testID}
        test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result.FirstOrDefault()

        test.ResultDate = resultDate

        If test.TestID < 0 Then
            test.RowAction = RecordConstants.Insert
        Else
            test.RowAction = RecordConstants.Update
        End If

        Dim index As Integer = 0
        If tests.Where(Function(x) x.TestID = testID).Count() > 0 Then
            index = tests.FindIndex(Function(x) x.TestID = testID)
            tests(index) = test
        Else
            tests.Add(test)
        End If

        index = 0
        If testsPendingSave.Where(Function(x) x.TestID = testID).Count() > 0 Then
            index = testsPendingSave.FindIndex(Function(x) x.TestID = testID)
            testsPendingSave(index) = test
        Else
            testsPendingSave.Add(test)
        End If

        transfer.ResultDate = resultDate
        If transfer.TransferID < 0 Then
            transfer.RowAction = RecordConstants.Insert
        Else
            transfer.RowAction = RecordConstants.Update
        End If
        index = transfers.FindIndex(Function(x) x.TransferID = transferID And x.TestID = testID)
        transfers(index) = transfer

        index = 0
        If transfersPendingSave.Where(Function(x) x.TransferID = transferID).Count() > 0 Then
            index = transfersPendingSave.FindIndex(Function(x) x.TransferID = transferID)
            transfersPendingSave(index) = transfer
        Else
            transfersPendingSave.Add(transfer)
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = tests
        Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        Session(SESSION_TRANSFERRED_LIST) = transfers
        Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave
        gvTransferred.PageIndex = 0
        lblTransferredPageNumber.Text = 1
        ViewState(TRANSFERRED_SORT_DIRECTION) = Nothing
        ViewState(TRANSFERRED_SORT_EXPRESSION) = Nothing
        BindTransferredGridView()
        FillTransferredPager(transfers.Count, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

        upTransferred.Update()
        upTransferredSave.Update()
        upTransferredButtons.Update()
        upTransferredMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testResultTypeID"></param>
    ''' <param name="testID"></param>
    ''' <param name="transferID"></param>
    Private Sub UpdateTransferTestResult(ByVal testResultTypeID As String, ByVal testResultTypeName As String, ByVal testID As Long, ByVal transferID As Long)

        Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        If Session(SESSION_TESTING_LIST) Is Nothing Then
            tests = New List(Of LabTestGetListModel)()
        Else
            tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        End If

        Dim testsPendingSave As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            testsPendingSave = New List(Of LabTestGetListModel)()
        Else
            testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
        If Session(SESSION_TRANSFERRED_LIST) Is Nothing Then
            transfers = New List(Of LabTransferGetListModel)()
        Else
            transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
        End If

        Dim transfersPendingSave As List(Of LabTransferGetListModel)
        If Session(SESSION_TRANSFERRED_SAVE_LIST) Is Nothing Then
            transfersPendingSave = New List(Of LabTransferGetListModel)()
        Else
            transfersPendingSave = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))
        End If

        Dim transfer As LabTransferGetListModel = transfers.Where(Function(x) x.TransferID And x.TestID = testID).FirstOrDefault()

        Dim test As LabTestGetListModel
        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If
        Dim parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = testID}
        test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result.FirstOrDefault()

        If testResultTypeID.IsValueNullOrEmpty = True Then
            test.TestResultTypeID = Nothing
            test.TestStatusTypeID = TestStatusTypes.InProgress
            test.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
            test.ResultDate = Nothing
            test.ResultEnteredByPersonID = Nothing
        Else
            test.TestResultTypeID = If(testResultTypeID.IsValueNullOrEmpty, Nothing, testResultTypeID)
            test.TestResultTypeName = testResultTypeName
            test.TestStatusTypeID = TestStatusTypes.Preliminary
            test.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
            test.ResultDate = Date.Now
            test.ResultEnteredByPersonID = hdfPersonID.Value
        End If

        If test.TestID < 0 Then
            test.RowAction = RecordConstants.Insert
        Else
            test.RowAction = RecordConstants.Update
        End If

        Dim index As Integer = 0
        If tests.Where(Function(x) x.TestID = testID).Count() > 0 Then
            index = tests.FindIndex(Function(x) x.TestID = testID)
            tests(index) = test
        Else
            tests.Add(test)
        End If

        index = 0
        If testsPendingSave.Where(Function(x) x.TestID = testID).Count() > 0 Then
            index = testsPendingSave.FindIndex(Function(x) x.TestID = testID)
            testsPendingSave(index) = test
        Else
            testsPendingSave.Add(test)
        End If

        transfer.TestResultTypeID = test.TestResultTypeID
        transfer.TestResultTypeName = test.TestResultTypeName
        transfer.ResultDate = test.ResultDate
        If transfer.TransferID < 0 Then
            transfer.RowAction = RecordConstants.Insert
        Else
            transfer.RowAction = RecordConstants.Update
        End If
        index = transfers.FindIndex(Function(x) x.TransferID = transferID And x.TestID = testID)
        transfers(index) = transfer

        index = 0
        If transfersPendingSave.Where(Function(x) x.TransferID = transferID).Count() > 0 Then
            index = transfersPendingSave.FindIndex(Function(x) x.TransferID = transferID)
            transfersPendingSave(index) = transfer
        Else
            transfersPendingSave.Add(transfer)
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = tests
        Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        Session(SESSION_TRANSFERRED_LIST) = transfers
        Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave
        gvTransferred.PageIndex = 0
        lblTransferredPageNumber.Text = 1
        ViewState(TRANSFERRED_SORT_DIRECTION) = Nothing
        ViewState(TRANSFERRED_SORT_EXPRESSION) = Nothing
        BindTransferredGridView()
        FillTransferredPager(transfers.Count, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

        upTransferred.Update()
        upTransferredSave.Update()
        upTransferredButtons.Update()
        upTransferredMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pointOfContact"></param>
    ''' <param name="testID"></param>
    ''' <param name="transferID"></param>
    Private Sub UpdateTransferPointOfContact(ByVal pointOfContact As String, ByVal testID As Long, ByVal transferID As Long)

        Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        If Session(SESSION_TESTING_LIST) Is Nothing Then
            tests = New List(Of LabTestGetListModel)()
        Else
            tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
        End If

        Dim testsPendingSave As List(Of LabTestGetListModel)
        If Session(SESSION_TESTING_SAVE_LIST) Is Nothing Then
            testsPendingSave = New List(Of LabTestGetListModel)()
        Else
            testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
        End If

        Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
        If Session(SESSION_TRANSFERRED_LIST) Is Nothing Then
            transfers = New List(Of LabTransferGetListModel)()
        Else
            transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
        End If

        Dim transfersPendingSave As List(Of LabTransferGetListModel)
        If Session(SESSION_TRANSFERRED_SAVE_LIST) Is Nothing Then
            transfersPendingSave = New List(Of LabTransferGetListModel)()
        Else
            transfersPendingSave = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))
        End If

        Dim transfer As LabTransferGetListModel = transfers.Where(Function(x) x.TransferID And x.TestID = testID).FirstOrDefault()

        Dim test As LabTestGetListModel
        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If
        Dim parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = testID}
        test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result.FirstOrDefault()

        test.ContactPersonName = pointOfContact

        If test.TestID < 0 Then
            test.RowAction = RecordConstants.Insert
        Else
            test.RowAction = RecordConstants.Update
        End If

        Dim index As Integer = 0
        If tests.Where(Function(x) x.TestID = testID).Count() > 0 Then
            index = tests.FindIndex(Function(x) x.TestID = testID)
            tests(index) = test
        Else
            tests.Add(test)
        End If

        index = 0
        If testsPendingSave.Where(Function(x) x.TestID = testID).Count() > 0 Then
            index = testsPendingSave.FindIndex(Function(x) x.TestID = testID)
            testsPendingSave(index) = test
        Else
            testsPendingSave.Add(test)
        End If

        transfer.ContactPersonName = pointOfContact
        If transfer.TransferID < 0 Then
            transfer.RowAction = RecordConstants.Insert
        Else
            transfer.RowAction = RecordConstants.Update
        End If
        index = transfers.FindIndex(Function(x) x.TransferID = transferID And x.TestID = testID)
        transfers(index) = transfer

        index = 0
        If transfersPendingSave.Where(Function(x) x.TransferID = transferID).Count() > 0 Then
            index = transfersPendingSave.FindIndex(Function(x) x.TransferID = transferID)
            transfersPendingSave(index) = transfer
        Else
            transfersPendingSave.Add(transfer)
        End If

        FillDropDowns()
        Session(SESSION_TESTING_LIST) = tests
        Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
        gvTesting.PageIndex = 0
        lblTestingPageNumber.Text = 1
        ViewState(TESTING_SORT_DIRECTION) = Nothing
        ViewState(TESTING_SORT_EXPRESSION) = Nothing
        BindTestingGridView()
        FillTestingPager(hdfTestingCount.Value, 1)

        Session(SESSION_TRANSFERRED_LIST) = transfers
        Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave
        gvTransferred.PageIndex = 0
        lblTransferredPageNumber.Text = 1
        ViewState(TRANSFERRED_SORT_DIRECTION) = Nothing
        ViewState(TRANSFERRED_SORT_EXPRESSION) = Nothing
        BindTransferredGridView()
        FillTransferredPager(transfers.Count, 1)

        upTesting.Update()
        upTestingSave.Update()
        upTestingButtons.Update()
        upTestingMenu.Update()

        upTransferred.Update()
        upTransferredSave.Update()
        upTransferredButtons.Update()
        upTransferredMenu.Update()

    End Sub

    ''' <summary>
    ''' Selects or deselects a record when the user clicks on the left hand selection box.
    ''' 
    ''' Use Case: LUC03
    ''' </summary>
    ''' <param name="transferID"></param>
    ''' <param name="testID"></param>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleTransferred(transferID As Long, testID As Long?, toggleIndicator As Boolean)

        Try
            Dim transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
            If transfers Is Nothing Then
                transfers = New List(Of LabTransferGetListModel)()
            End If

            If toggleIndicator = True Then
                If testID Is Nothing Then
                    transfers.Where(Function(x) x.TransferID = transferID).FirstOrDefault().RowSelectionIndicator = 1
                Else
                    transfers.Where(Function(x) x.TransferID = transferID And x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 1
                End If
            Else
                If testID Is Nothing Then
                    transfers.Where(Function(x) x.TransferID = transferID).FirstOrDefault().RowSelectionIndicator = 0
                Else
                    transfers.Where(Function(x) x.TransferID = transferID And x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 0
                End If
            End If

            Session(SESSION_TRANSFERRED_LIST) = transfers
            FillDropDowns()
            gvTransferred.PageIndex = lblTransferredPageNumber.Text - 1
            BindTransferredGridView()
            upTransferredMenu.Update()
            upTransferredButtons.Update()
            upTransferred.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the transferred select/deselect all toggle event.
    ''' </summary>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleAllTransferred(toggleIndicator As Boolean)

        Try
            Dim index As Integer = 0
            Dim transfers As List(Of LabTransferGetListModel) = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))

            If toggleIndicator = True Then
                For Each transfer In transfers
                    transfers(index).RowSelectionIndicator = 1
                    index += 1
                Next
            Else
                For Each transfer In transfers
                    transfers(index).RowSelectionIndicator = 0
                    index += 1
                Next
            End If

            Session(SESSION_TRANSFERRED_LIST) = transfers
            FillDropDowns()
            BindTransferredGridView()
            upTransferredMenu.Update()
            upTransferredButtons.Update()
            upTransferred.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Cancels a transfer record that is currently in progress.
    ''' 
    ''' Use Case: LUC03
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub CancelTransfer_Click(sender As Object, e As EventArgs) Handles btnCancelTransfer.Click

        Try
            Dim transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim transfersPendingSave = CType(Session(SESSION_TRANSFERRED_SAVE_LIST), List(Of LabTransferGetListModel))

            If transfers Is Nothing Then
                transfers = New List(Of LabTransferGetListModel)()
            End If

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            If transfersPendingSave Is Nothing Then
                transfersPendingSave = New List(Of LabTransferGetListModel)()
            End If

            Dim index As Integer = 0
            Dim samplesTransferOutIndex = 0
            Dim transferredOutSample As LabSampleGetListModel
            Dim transferredInSample As LabSampleGetListModel
            Dim sampleParameters As LaboratorySampleGetListParameters
            For Each transfer In transfers
                If transfer.RowSelectionIndicator = 1 Then
                    'transfer.EIDSSTransferID = Nothing 'TODO: Talk to BA team about either removing this requirement or have the data team change the unique index that is currently on this field.
                    transfer.TransferredFromOrganizationID = Nothing
                    transfer.TransferredToOrganizationID = Nothing
                    transfer.TransferDate = Nothing
                    transfer.TransferStatusTypeID = TransferStatusTypes.Deleted

                    If transfer.RowAction = String.Empty Then
                        If transfer.TransferID > 0 Then
                            transfer.RowAction = RecordConstants.Update
                        Else
                            transfer.RowAction = RecordConstants.Insert
                        End If
                    End If

                    sampleParameters = New LaboratorySampleGetListParameters With {.PaginationSetNumber = 1, .SampleID = transfer.TransferredOutSampleID}

                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    transferredOutSample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters:=sampleParameters).Result.FirstOrDefault()
                    transferredOutSample.SampleStatusTypeID = SampleStatusTypes.InRepository

                    If transferredOutSample.RowAction = String.Empty Then
                        If transferredOutSample.SampleID > 0 Then
                            transferredOutSample.RowAction = RecordConstants.Update
                        Else
                            transferredOutSample.RowAction = RecordConstants.Insert
                        End If
                    End If

                    If samplesPendingSave.Where(Function(x) x.SampleID = transferredOutSample.SampleID).Count() > 0 Then
                        index = samplesPendingSave.FindIndex(Function(x) x.SampleID = transferredOutSample.SampleID)
                        samplesPendingSave(index) = transferredOutSample
                    Else
                        samplesPendingSave.Add(transferredOutSample)
                    End If

                    'Transferred to an EIDSS laboratory; deactivate transferred in sample record so the transferred to organization 
                    'no longer sees the sample record on the samples tab to be accessioned.
                    If Not transfer.TransferredInSampleID Is Nothing Then
                        sampleParameters = New LaboratorySampleGetListParameters With {.PaginationSetNumber = 1, .SampleID = transfer.TransferredInSampleID}
                        transferredInSample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters:=sampleParameters).Result.FirstOrDefault()
                        transferredInSample.Note = GetLocalResourceObject("Lbl_Transfer_Cancelled_Text")
                        transferredInSample.SampleStatusTypeID = SampleStatusTypes.Deleted
                        transferredInSample.RowStatus = RecordConstants.InactiveRowStatus

                        If transferredInSample.RowAction = String.Empty Then
                            If transferredInSample.SampleID > 0 Then
                                transferredInSample.RowAction = RecordConstants.Update
                            Else
                                transferredInSample.RowAction = RecordConstants.Insert
                            End If
                        End If

                        If samplesPendingSave.Where(Function(x) x.SampleID = transferredInSample.SampleID).Count() > 0 Then
                            index = samplesPendingSave.FindIndex(Function(x) x.SampleID = transferredInSample.SampleID)
                            samplesPendingSave(index) = transferredInSample
                        Else
                            samplesPendingSave.Add(transferredInSample)
                        End If
                    End If

                    If transfersPendingSave.Where(Function(x) x.TransferID = transfer.TransferID).Count() > 0 Then
                        index = transfersPendingSave.FindIndex(Function(x) x.TransferID = transfer.TransferID)
                        transfersPendingSave(index) = transfer
                    Else
                        transfersPendingSave.Add(transfer)
                    End If

                    samplesTransferOutIndex += 1
                End If
            Next

            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
            Session(SESSION_TRANSFERRED_SAVE_LIST) = transfersPendingSave

            AddUpdateLaboratory()

            Dim samplesParameters = New LaboratorySampleGetListParameters With {.DaysFromAccessionDate = ConfigurationManager.AppSettings("DaysFromAccessionDate"), .PaginationSetNumber = 1, .UserID = hdfUserID.Value, .OrganizationID = hdfOrganizationID.Value}
            Dim samplesCounts = LaboratoryAPIService.LaboratorySampleGetListCountAsync(samplesParameters).Result
            lblSamplesCount.Text = samplesCounts(0).UnaccessionedSampleCount
            hdfSamplesCount.Value = samplesCounts(0).RecordCount

            lblSamplesPageNumber.Text = 1
            gvSamples.PageIndex = 0
            FillSamplesList(pageIndex:=1, paginationSetNumber:=1)

            BindSamplesGridView()

            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
            BindMyFavoritesGridView()

            Dim transferredParameters = New LaboratoryTransferGetListParameters With {.PaginationSetNumber = 1, .OrganizationID = hdfOrganizationID.Value, .SampleID = Nothing, .UserID = hdfUserID.Value}
            Dim transferredCount = LaboratoryAPIService.LaboratoryTransferGetListCountAsync(transferredParameters).Result
            lblTransferredCount.Text = transferredCount(0).RecordCount

            lblTransferredPageNumber.Text = 1
            gvTransferred.PageIndex = 0
            FillTransferredList(pageIndex:=1, paginationSetNumber:=1)
            BindTransferredGridView()

            Session(SESSION_TRANSFERRED_SAVE_LIST) = New List(Of LabTransferGetListModel)()
            Session(SESSION_SAMPLES_SAVE_LIST) = New List(Of LabSampleGetListModel)()

            FillTabCounts()

            upLaboratoryTabCounts.Update()
            upSamples.Update()
            upSamplesButtons.Update()
            upSamplesSave.Update()
            upSamplesMenu.Update()

            upTransferred.Update()
            upTransferredButtons.Update()
            upTransferredSave.Update()
            upTransferredMenu.Update()
            'VerifyUserPermissions(False)

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    Private Sub PrintTransfer_Click(sender As Object, e As EventArgs) Handles btnPrintTransfer.Click

        Try
            upTransferredButtons.Update()
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTransferDetailsFormModal"), True)
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
    Private Sub TransferredSave_Click(sender As Object, e As EventArgs) Handles btnTransferredSave.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            AddUpdateLaboratory()

            upSuccessModal.Update()

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)

            FillDropDowns()
            FillTabCounts()
            FillTransferredList(pageIndex:=1, paginationSetNumber:=1)
            BindTransferredGridView()
            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
            BindMyFavoritesGridView()
            BindSamplesGridView()

            upLaboratoryTabCounts.Update()
            upTransferred.Update()
            upTransferredButtons.Update()
            upTransferredSave.Update()
            upTransferredMenu.Update()
            'VerifyUserPermissions(False)

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

#End Region

#Region "Edit Transfer Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transferID"></param>
    ''' <param name="testID"></param>
    Private Sub InitializeEditTransfer(transferID As Long, testID As Long?)

        Try
            If transferID = 0 Then
                ShowWarningMessage(messageType:=MessageType.CannotSetTestResult, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Transfer_Must_Be_Selected_Body_Text"))

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "hideModal('#divSampleTestDetailsModal');", True)
            Else
                Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                Dim tests As List(Of LabTestGetListModel) = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
                Dim transfers = CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel))
                Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
                If testsPendingSave Is Nothing Then
                    testsPendingSave = New List(Of LabTestGetListModel)()
                End If

                divTransferDetailsAccordionPanel.Visible = True

                If testID Is Nothing Then
                    ucTransferSampleForSampleTestDetails.Transfer = transfers.Where(Function(x) x.TransferID = transferID).FirstOrDefault()
                Else
                    ucTransferSampleForSampleTestDetails.Transfer = transfers.Where(Function(x) x.TransferID = transferID And x.TestID = testID).FirstOrDefault()
                End If

                If samples Is Nothing Then
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    Dim samplesParameters = New LaboratorySampleGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .DaysFromAccessionDate = Integer.MinValue, .SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID}
                    ucAddUpdateSample.Sample = LaboratoryAPIService.LaboratorySampleGetListAsync(samplesParameters).Result.FirstOrDefault()
                ElseIf samples.Where(Function(x) x.SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID).Count() > 0 Then
                    ucAddUpdateSample.Sample = samples.Where(Function(x) x.SampleID = transfers.Where(Function(y) y.TransferID = transferID).FirstOrDefault().TransferredOutSampleID).FirstOrDefault()
                Else
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    Dim samplesParameters = New LaboratorySampleGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SampleID = ucTransferSampleForSampleTestDetails.Transfer.TransferredOutSampleID}
                    ucAddUpdateSample.Sample = LaboratoryAPIService.LaboratorySampleGetListAsync(samplesParameters).Result.FirstOrDefault()
                End If

                ucAddUpdateSample.Setup()

                If Not ucTransferSampleForSampleTestDetails.Transfer.TestID Is Nothing Then
                    If tests Is Nothing Then
                        If LaboratoryAPIService Is Nothing Then
                            LaboratoryAPIService = New LaboratoryServiceClient()
                        End If
                        Dim testingParameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = ucTransferSampleForSampleTestDetails.Transfer.TestID}
                        ucAddUpdateTest.Test = LaboratoryAPIService.LaboratoryTestGetListAsync(testingParameters).Result.FirstOrDefault()

                        If ucAddUpdateTest.Test Is Nothing Then
                            ucAddUpdateTest.Test = New LabTestGetListModel With {
                                .DiseaseID = ucAddUpdateSample.Sample.DiseaseID,
                                .DiseaseName = ucAddUpdateSample.Sample.DiseaseName
                            }
                        End If
                    ElseIf tests.Where(Function(x) x.TestID = ucTransferSampleForSampleTestDetails.Transfer.TestID).Count() > 0 Then
                        ucAddUpdateTest.Test = tests.Where(Function(x) x.TestID = transfers.Where(Function(y) y.TransferID = transferID).FirstOrDefault().TestID).FirstOrDefault()
                    Else
                        If LaboratoryAPIService Is Nothing Then
                            LaboratoryAPIService = New LaboratoryServiceClient()
                        End If
                        Dim testingParameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = ucTransferSampleForSampleTestDetails.Transfer.TestID}
                        ucAddUpdateTest.Test = LaboratoryAPIService.LaboratoryTestGetListAsync(testingParameters).Result.FirstOrDefault()
                    End If

                    If ucTransferSampleForSampleTestDetails.Transfer.NonEIDSSLaboratoryIndicator = 1 Then
                        ucAddUpdateTest.Test.ExternalTestIndicator = True
                    Else
                        ucAddUpdateTest.Test.ExternalTestIndicator = False
                    End If

                    ucAddUpdateTest.Setup(testCount:=testsPendingSave.Count, testID:=ucTransferSampleForSampleTestDetails.Transfer.TestID)

                    ucAmendmentHistory.Setup(testID:=ucTransferSampleForSampleTestDetails.Transfer.TestID)
                Else
                    ucAddUpdateTest.Test = New LabTestGetListModel With {
                        .DiseaseID = ucAddUpdateSample.Sample.DiseaseID,
                        .DiseaseName = ucAddUpdateSample.Sample.DiseaseName,
                        .EIDSSLaboratorySampleID = ucAddUpdateSample.Sample.EIDSSLaboratorySampleID,
                        .EIDSSReportSessionID = ucAddUpdateSample.Sample.EIDSSReportSessionID,
                        .ExternalTestIndicator = 1,
                        .FavoriteIndicator = ucAddUpdateSample.Sample.FavoriteIndicator,
                        .RowAction = RecordConstants.Insert,
                        .SampleID = ucAddUpdateSample.Sample.SampleID,
                        .TestStatusTypeID = TestStatusTypes.InProgress,
                        .TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                    }

                    If ucTransferSampleForSampleTestDetails.Transfer.NonEIDSSLaboratoryIndicator = 1 Then
                        ucAddUpdateTest.Test.ExternalTestIndicator = True
                    Else
                        ucAddUpdateTest.Test.ExternalTestIndicator = False
                    End If

                    ucAddUpdateTest.Setup(testCount:=testsPendingSave.Count)
                End If

                ucTransferSampleForSampleTestDetails.Setup()

                ToggleVisibility(LaboratoryModuleActions.EditTransfer.ToString())

                upAccordionAddUpdateSample.Update()

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, SHOW_EDIT_TRANSFER_MODAL, True)
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
    Protected Sub ShowTransferDetailsForm_Click(sender As Object, e As ImageClickEventArgs) Handles btnShowTransferDetailsForm.Click

        Try
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTransferDetailsFormModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "My Favorites Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillMyFavoritesList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            If hdfAdvancedSearchIndicator.Value = YesNoUnknown.No And hdgTestingQueryText.InnerText = String.Empty Then
                Session(SESSION_FAVORITES_LIST) = LaboratoryAPIService.LaboratoryFavoriteGetListAsync(GetCurrentLanguage(), hdfUserID.Value, paginationSetNumber).Result
            Else
                If hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes Then
                    ucSearchSample.FillMyFavoritesList()
                Else
                    ucMyFavoritesSearch.Search()
                End If
            End If

            FillMyFavoritesPager(lblMyFavoritesCount.Text, pageIndex)
            ViewState(MY_FAVORITES_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillMyFavoritesPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Try
            Dim pages As New List(Of ListItem)()
            Dim startIndex As Integer, endIndex As Integer
            Dim pagerSpan As Integer = 5

            If recordCount > 0 Then
                divMyFavoritesPager.Visible = True

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
                rptMyFavoritesPager.DataSource = pages
                rptMyFavoritesPager.DataBind()
            Else
                divMyFavoritesPager.Visible = False
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
    Protected Sub MyFavoritesPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblMyFavoritesPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvMyFavorites.PageSize)

            FillDropDowns()

            If Not ViewState(MY_FAVORITES_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvMyFavorites.PageIndex = gvMyFavorites.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvMyFavorites.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvMyFavorites.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvMyFavorites.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvMyFavorites.PageIndex = gvMyFavorites.PageSize - 1
                        Else
                            gvMyFavorites.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillMyFavoritesList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvMyFavorites.PageIndex = gvMyFavorites.PageSize - 1
                Else
                    gvMyFavorites.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindMyFavoritesGridView()
                FillMyFavoritesPager(lblMyFavoritesCount.Text, pageIndex)
            End If

            upMyFavorites.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindMyFavoritesGridView()

        Try
            Dim myFavorites = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))
            If myFavorites Is Nothing Then
                myFavorites = New List(Of LabFavoriteGetListModel)()
                Session(SESSION_FAVORITES_LIST) = myFavorites
            End If

            If myFavorites.Where(Function(x) x.RowAction = RecordConstants.Insert).Count > 0 Or
               myFavorites.Where(Function(x) x.RowAction = RecordConstants.Update).Count > 0 Then
                btnMyFavoritesSave.Enabled = True

                If (Not ViewState(MY_FAVORITES_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(MY_FAVORITES_SORT_DIRECTION) = SortConstants.Ascending Then
                        myFavorites = myFavorites.OrderBy(Function(x) x.GetType().GetProperty(ViewState(MY_FAVORITES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        myFavorites = myFavorites.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(MY_FAVORITES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    myFavorites.OrderByDescending(Function(x) x.RowAction)
                End If
            Else
                btnMyFavoritesSave.Enabled = False

                If (Not ViewState(MY_FAVORITES_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(MY_FAVORITES_SORT_DIRECTION) = SortConstants.Ascending Then
                        myFavorites = myFavorites.OrderBy(Function(x) x.GetType().GetProperty(ViewState(MY_FAVORITES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        myFavorites = myFavorites.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(MY_FAVORITES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    myFavorites.OrderBy(Function(x) x.AccessionDate).ThenBy(Function(y) y.PatientFarmOwnerName).ToList()
                End If
            End If

            gvMyFavorites.DataSource = myFavorites
            gvMyFavorites.DataBind()
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
    Protected Sub MyFavorites_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvMyFavorites.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then
                Dim myFavorites = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))
                If Not myFavorites Is Nothing Then
                    Dim btnToggleAllMyFavorites As LinkButton = CType(e.Row.FindControl("btnToggleAllMyFavorites"), LinkButton)
                    Dim btnHeaderMyFavoritesSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnHeaderMyFavoritesSetMyFavorite"), LinkButton)
                    Dim imgHeaderMyFavoritesMyFavoriteStar As Image = CType(e.Row.FindControl("imgHeaderMyFavoritesMyFavoriteStar"), Image)

                    If myFavorites.Where(Function(x) x.RowSelectionIndicator = 1).Count = myFavorites.Count And myFavorites.Count > 0 Then
                        btnToggleAllMyFavorites.CssClass = CSS_BTN_GLYPHICON_CHECKED
                    Else
                        btnToggleAllMyFavorites.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                    End If
                End If
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim favorite As LabFavoriteGetListModel = TryCast(e.Row.DataItem, LabFavoriteGetListModel)
                    Dim clientID As String = sender.ClientID
                    Dim i As Integer = 0

                    If Not favorite Is Nothing Then
                        Dim lblSampleStatusTypeName As Label = CType(e.Row.FindControl("lblMyFavoritesSampleStatusTypeName"), Label)
                        lblSampleStatusTypeName.Visible = True
                        Dim ddlTestCategoryType As DropDownList = CType(e.Row.FindControl("ddlMyFavoritesTestCategoryType"), DropDownList)
                        Dim ddlTestResultType As DropDownList = CType(e.Row.FindControl("ddlMyFavoritesTestResultType"), DropDownList)
                        Dim lblTestStatusTypeName As Label = CType(e.Row.FindControl("lblMyFavoritesTestStatusTypeName"), Label)
                        Dim ddlTestStatusType As DropDownList = CType(e.Row.FindControl("ddlMyFavoritesTestStatusType"), DropDownList)
                        Dim lblFunctionalAreaName As Label = CType(e.Row.FindControl("lblMyFavoritesFunctionalAreaName"), Label)
                        Dim lblResultDate As Label = CType(e.Row.FindControl("lblMyFavoritesResultDate"), Label)
                        Dim lblTestStartedDate As Label = CType(e.Row.FindControl("lblMyFavoritesTestStartedDate"), Label)
                        Dim btnToggleMyFavorites As LinkButton = CType(e.Row.FindControl("btnToggleMyFavorites"), LinkButton)
                        Dim commentBoxEmptyLink As HtmlAnchor = CType(e.Row.FindControl("lnkMyFavoritesSampleStatusCommentEmpty"), HtmlAnchor)
                        commentBoxEmptyLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)
                        Dim commentBoxLink As HtmlAnchor = CType(e.Row.FindControl("lnkMyFavoritesSampleStatusComment"), HtmlAnchor)
                        commentBoxLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        If favorite.RowSelectionIndicator = 0 Then
                            btnToggleMyFavorites.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                        Else
                            btnToggleMyFavorites.CssClass = CSS_BTN_GLYPHICON_CHECKED
                        End If

                        Dim commentEmptyJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divMyFavoritesCommentBoxEmptyContainer_" & e.Row.RowIndex & "').html(); }});"
                        Dim commentJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divMyFavoritesCommentBoxContainer_" & e.Row.RowIndex & "').html(); }});"

                        If favorite.AccessionComment.IsValueNullOrEmpty() Then
                            commentBoxEmptyLink.Visible = True
                            commentBoxLink.Visible = False
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentEmptyJavaScript, True)
                        Else
                            commentBoxEmptyLink.Visible = False
                            commentBoxLink.Visible = True
                            Dim commentTextBox As TextBox = CType(e.Row.FindControl("txtMyFavoritesCommentTextBox"), TextBox)
                            commentTextBox.Text = favorite.AccessionComment
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentJavaScript, True)
                        End If

                        If favorite.AccessionedIndicator = 0 Then
                            If favorite.RowAction = RecordConstants.Insert Or
                            favorite.RowAction = RecordConstants.Update Then
                                e.Row.CssClass = CSS_UNACCESSIONED_SAVE_PENDING
                            Else
                                e.Row.CssClass = CSS_UNACCESSIONED
                            End If

                            lblFunctionalAreaName.Visible = False

                            ddlTestCategoryType.Visible = False
                            ddlTestResultType.Visible = False
                            ddlTestStatusType.Visible = False
                        Else
                            If favorite.RowAction = RecordConstants.Update Or favorite.RowAction = RecordConstants.Accession Then
                                e.Row.CssClass = CSS_UNACCESSIONED_SAVE_PENDING
                            End If

                            lblFunctionalAreaName.Visible = True
                            lblTestStatusTypeName.Visible = False

                            ddlTestCategoryType.DataSource = ddlTestCategoryTypes.Items
                            ddlTestCategoryType.DataTextField = "Text"
                            ddlTestCategoryType.DataValueField = "Value"
                            ddlTestCategoryType.DataBind()
                            ddlTestCategoryType.Visible = True
                            ddlTestCategoryType.SelectedValue = If(favorite.TestCategoryTypeID.ToString = "", GlobalConstants.NullValue, favorite.TestCategoryTypeID)

                            ddlTestResultType.DataSource = ddlTestResultTypes.Items
                            ddlTestResultType.DataTextField = "Text"
                            ddlTestResultType.DataValueField = "Value"
                            ddlTestResultType.DataBind()
                            ddlTestResultType.Visible = True
                            ddlTestResultType.SelectedValue = If(favorite.TestResultTypeID.ToString = "", GlobalConstants.NullValue, favorite.TestResultTypeID)

                            ddlTestStatusType.DataSource = ddlTestStatusTypes.Items
                            ddlTestStatusType.DataTextField = "Text"
                            ddlTestStatusType.DataValueField = "Value"
                            ddlTestStatusType.DataBind()
                            ddlTestStatusType.Visible = True
                            ddlTestStatusType.SelectedValue = If(favorite.TestStatusTypeID.ToString = "", GlobalConstants.NullValue, favorite.TestStatusTypeID)
                        End If

                        lblTestStartedDate.Text = ToShortDate(lblTestStartedDate.Text)
                        lblResultDate.Text = ToShortDate(lblResultDate.Text)

                        If favorite.RowAction = RecordConstants.Update Or favorite.RowAction = RecordConstants.Accession Then
                            e.Row.CssClass = CSS_UNACCESSIONED_SAVE_PENDING
                        End If
                    End If
                End If
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
    Protected Sub MyFavorites_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMyFavorites.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelectAll
                        Dim btnToggleAllMyFavorites As LinkButton = CType(e.CommandSource, LinkButton)
                        Dim toggleIndicator As Boolean = False

                        If btnToggleAllMyFavorites.CssClass = CSS_BTN_GLYPHICON_UNCHECKED Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleAllMyFavorites(toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.ToggleSelect
                        Dim toggleIndicator As Boolean = False

                        If CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel)).Where(Function(x) x.SampleID = e.CommandArgument).FirstOrDefault().RowSelectionIndicator = 0 Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleMyFavorites(sampleID:=e.CommandArgument, toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.EditCommand
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditSample.ToString()
                        InitializeControl(CType(e.CommandArgument, Long))
                    Case GridViewCommandConstants.MyFavoriteCommand
                        Dim list As List(Of LabFavoriteGetListModel) = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel)).Where(Function(x) x.SampleID = e.CommandArgument).ToList()
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite As LabFavoriteGetListModel
                        For Each item As LabFavoriteGetListModel In list
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next
                        SetMyFavorite(False, favorites)
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.SelectAllRecordsMyFavoriteCommand
                        Dim myFavorites As List(Of LabFavoriteGetListModel) = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite = New LabFavoriteGetListModel()

                        For Each item As LabFavoriteGetListModel In myFavorites
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next

                        SetMyFavorite(True, favorites)
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub MyFavorites_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvMyFavorites.Sorting

        Try
            ViewState(MY_FAVORITES_SORT_DIRECTION) = IIf(ViewState(MY_FAVORITES_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(MY_FAVORITES_SORT_EXPRESSION) = e.SortExpression

            FillDropDowns()

            BindMyFavoritesGridView()

            upMyFavorites.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleMyFavorites(sampleID As Long, toggleIndicator As Boolean)

        Try
            Dim myFavorites = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))
            If myFavorites Is Nothing Then
                myFavorites = New List(Of LabFavoriteGetListModel)()
            End If

            If toggleIndicator = True Then
                myFavorites.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowSelectionIndicator = 1

                btnMyFavoritesAssignTest.Enabled = True
                btnMyFavoritesBatch.Disabled = False
            Else
                myFavorites.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowSelectionIndicator = 0

                If myFavorites.Where(Function(x) x.RowSelectionIndicator = 1).Count = 0 Then
                    btnMyFavoritesAssignTest.Enabled = False
                    btnMyFavoritesBatch.Disabled = True
                End If
            End If

            Session(SESSION_FAVORITES_LIST) = myFavorites
            FillDropDowns()
            gvMyFavorites.PageIndex = lblMyFavoritesPageNumber.Text - 1
            BindMyFavoritesGridView()
            upMyFavoritesButtons.Update()
            upMyFavoritesMenu.Update()
            upMyFavorites.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the my favorites select/deselect all toggle event.
    ''' </summary>
    Private Sub ToggleAllMyFavorites(toggleIndicator As Boolean)

        Try
            Dim index As Integer = 0
            Dim myFavorites As List(Of LabFavoriteGetListModel) = CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel))

            If toggleIndicator = True Then
                For Each myFavorite In myFavorites
                    myFavorites(index).RowSelectionIndicator = 1

                    index += 1
                Next

                btnMyFavoritesAssignTest.Enabled = True
                btnMyFavoritesBatch.Disabled = False
            Else
                For Each myFavorite In myFavorites
                    myFavorites(index).RowSelectionIndicator = 0

                    index += 1
                Next

                btnMyFavoritesAssignTest.Enabled = False
                btnMyFavoritesBatch.Disabled = True
            End If

            Session(SESSION_FAVORITES_LIST) = myFavorites
            FillDropDowns()
            gvMyFavorites.PageIndex = lblMyFavoritesPageNumber.Text - 1
            BindMyFavoritesGridView()
            upMyFavoritesButtons.Update()
            upMyFavorites.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Batches Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillBatchesList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            Dim parameters = New LaboratoryBatchGetListParameters With {.LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = paginationSetNumber, .UserID = hdfUserID.Value}
            Dim batchTests = LaboratoryAPIService.LaboratoryBatchGetListAsync(parameters:=parameters).Result

            Session(SESSION_BATCH_TESTS_LIST) = batchTests

            Dim batchTestsTemp = JsonConvert.SerializeObject(batchTests.GroupBy(Function(x) x.BatchTestID).Select(Function(y) y.First()).ToList)
            Dim batches = JsonConvert.DeserializeObject(Of List(Of LabBatchGetListModel))(batchTestsTemp)

            For Each batch In batches
                batch.TestID = Nothing
            Next
            Session(SESSION_BATCHES_LIST) = batches

            FillBatchesPager(lblBatchesCount.Text, pageIndex)
            ViewState(BATCHES_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillBatchesPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Try
            Dim pages As New List(Of ListItem)()
            Dim startIndex As Integer, endIndex As Integer
            Dim pagerSpan As Integer = 5

            If recordCount > 0 Then
                divBatchesPager.Visible = True

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
                rptBatchesPager.DataSource = pages
                rptBatchesPager.DataBind()
            Else
                divBatchesPager.Visible = False
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
    Protected Sub BatchesPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblBatchesPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvBatches.PageSize)

            FillDropDowns()

            If Not ViewState(BATCHES_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvBatches.PageIndex = gvBatches.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvBatches.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvBatches.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvBatches.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvBatches.PageIndex = gvBatches.PageSize - 1
                        Else
                            gvBatches.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillBatchesList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvBatches.PageIndex = gvBatches.PageSize - 1
                Else
                    gvBatches.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindBatchesGridView()
                FillBatchesPager(lblBatchesCount.Text, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindBatchesGridView()

        Try
            Dim batches = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
            Dim batchesPendingSave = CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))
            Dim batchTests = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel))

            If batches Is Nothing Then
                batches = New List(Of LabBatchGetListModel)()
                Session(SESSION_BATCHES_LIST) = batches
            End If

            If batchesPendingSave Is Nothing Then
                batchesPendingSave = New List(Of LabBatchGetListModel)()
                Session(SESSION_BATCHES_SAVE_LIST) = batchesPendingSave
            End If

            If batchTests Is Nothing Then
                batchTests = New List(Of LabBatchGetListModel)()
            End If

            Dim batchesAndBatchTests = New List(Of LabBatchGetListModel)()
            batchesAndBatchTests.AddRange(batches)
            batchesAndBatchTests.AddRange(batchTests)

            If batchesPendingSave.Count > 0 Or batchTests.Where(Function(x) x.RowAction = RecordConstants.Update).Count > 0 Then
                btnBatchesSave.Enabled = True

                If (Not ViewState(BATCHES_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(BATCHES_SORT_DIRECTION) = SortConstants.Ascending Then
                        batches = batches.OrderBy(Function(x) x.GetType().GetProperty(ViewState(BATCHES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        batches = batches.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(BATCHES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    batches = batches.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.AccessionDate).ThenBy(Function(z) z.PatientFarmOwnerName).ToList()
                End If
            Else
                btnBatchesSave.Enabled = False

                If (Not ViewState(BATCHES_SORT_EXPRESSION) Is Nothing) Then
                    If ViewState(BATCHES_SORT_DIRECTION) = SortConstants.Ascending Then
                        batches = batches.OrderBy(Function(x) x.GetType().GetProperty(ViewState(BATCHES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    Else
                        batches = batches.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(BATCHES_SORT_EXPRESSION)).GetValue(x)).ToList()
                    End If
                Else
                    batches = batches.OrderBy(Function(x) x.AccessionDate).ThenBy(Function(y) y.PatientFarmOwnerName).ToList()
                End If
            End If

            If batchesAndBatchTests.Where(Function(x) x.RowSelectionIndicator = 1).Count > 0 Then
                If batchesAndBatchTests.Where(Function(x) x.RowSelectionIndicator = 1 And Not x.TestID Is Nothing).Count = 1 Then
                    btnBatchesRemoveSample.Enabled = True
                    btnCloseBatch.Enabled = False
                Else
                    If batchesAndBatchTests.Where(Function(x) x.RowSelectionIndicator = 1 And x.TestID Is Nothing).Count > 0 Then
                        btnAddGroupResult.Disabled = False
                        btnCloseBatch.Enabled = True
                    End If
                    btnBatchesRemoveSample.Enabled = False
                End If
            Else
                btnAddGroupResult.Disabled = True
                btnCloseBatch.Enabled = False
                btnBatchesRemoveSample.Enabled = False
            End If

            gvBatches.DataSource = batches
            gvBatches.DataBind()
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
    Protected Sub Batches_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvBatches.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then
                Dim batches = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
                If Not batches Is Nothing Then
                    'Dim btnToggleAllBatches As LinkButton = CType(e.Row.FindControl("btnToggleAllBatches"), LinkButton)

                    'If batches.Where(Function(x) x.RowSelectionIndicator = 1).Count = batches.Count And batches.Count > 0 Then
                    '    btnToggleAllBatches.CssClass = "btn glyphicon glyphicon-check selectButton"
                    'Else
                    '    btnToggleAllBatches.CssClass = "btn glyphicon glyphicon-unchecked selectButton"
                    'End If
                End If
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim batches = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
                    Dim batchTests = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel))
                    Dim lblEditBatch = CType(e.Row.FindControl("lblEditBatch"), HtmlGenericControl)
                    Dim lblBatchStatusTypeName = CType(e.Row.FindControl("lblBatchStatusTypeName"), Label)
                    Dim batch As LabBatchGetListModel = TryCast(e.Row.DataItem, LabBatchGetListModel)
                    Dim i As Integer = 0

                    ' *************************************************************************
                    ' Accordion control
                    ' *************************************************************************
                    Dim divBatchAccordion As HtmlGenericControl = CType(e.Row.FindControl("divBatchAccordion"), HtmlGenericControl)
                    Dim batchTestAccordion As HtmlGenericControl = CType(e.Row.FindControl("divBatchTestAccordion"), HtmlGenericControl)
                    Dim divBatchTestHeading As HtmlGenericControl = CType(e.Row.FindControl("divBatchTestHeading"), HtmlGenericControl)
                    Dim divBatchTestDetails As HtmlGenericControl = CType(e.Row.FindControl("divBatchTestDetails"), HtmlGenericControl)
                    Dim lnkBatchTestAccordion As HtmlAnchor = CType(e.Row.FindControl("lnkBatchTestAccordion"), HtmlAnchor)
                    lnkBatchTestAccordion.Attributes.Add("data-parent", batchTestAccordion.ClientID)
                    lnkBatchTestAccordion.Attributes.Add("aria-controls", divBatchTestDetails.ClientID)
                    lnkBatchTestAccordion.HRef = "#" & divBatchTestDetails.ClientID
                    divBatchTestDetails.Attributes.Add("aria-labelledby", divBatchTestHeading.ClientID)

                    If Not batch Is Nothing Then
                        Dim gvBatchTests As GridView = CType(e.Row.FindControl("gvBatchTests"), GridView)
                        Dim btnToggleBatch As LinkButton = CType(e.Row.FindControl("btnToggleBatch"), LinkButton)

                        lblEditBatch.Attributes.Add("onclick", "editBatch('" + batch.BatchTestID.ToString() + "');")

                        If batch.RowSelectionIndicator = 0 Then
                            btnToggleBatch.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                        Else
                            btnToggleBatch.CssClass = CSS_BTN_GLYPHICON_CHECKED
                        End If

                        gvBatchTests.DataSource = batchTests.Where(Function(x) x.BatchTestID = batch.BatchTestID And Not x.TestID Is Nothing).ToList()
                        gvBatchTests.DataBind()

                        If batch.BatchStatusTypeID = TestStatusTypes.Final Then
                            e.Row.CssClass = "closed"
                            e.Row.Cells(0).CssClass = "closed"
                            divBatchAccordion.Attributes.Remove("class")
                            divBatchAccordion.Attributes.Add("class", "closed-batch-test-accordion-wrapper")
                            lnkBatchTestAccordion.Attributes.Remove("class")
                            lnkBatchTestAccordion.Attributes.Add("class", "batch-accordion-toggle collapsed")
                            divBatchTestDetails.Attributes.Remove("class")
                            divBatchTestDetails.Attributes.Add("class", "panel-collapse collapse")
                            lblBatchStatusTypeName.Text = Resources.Labels.Lbl_Closed_Text 'Final status
                        Else
                            If batch.RowAction = RecordConstants.Update Or batch.RowAction = RecordConstants.Accession Then
                                e.Row.CssClass = "inProgressSavePending"
                                e.Row.Cells(0).CssClass = "inProgressSavePending"
                            Else
                                e.Row.CssClass = "inProgress"
                                e.Row.Cells(0).CssClass = "inProgress"
                            End If
                        End If
                    End If
                End If
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
    Protected Sub BatchTests_RowDataBound(sender As Object, e As GridViewRowEventArgs)

        Try
            If e.Row.RowType = DataControlRowType.Header Then
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim batchTest As LabBatchGetListModel = TryCast(e.Row.DataItem, LabBatchGetListModel)
                    Dim i As Integer = 0
                    Dim clientID As String = sender.ClientID

                    If Not batchTest Is Nothing Then
                        Dim lblSampleStatusTypeName As Label = CType(e.Row.FindControl("lblBatchesSampleStatusTypeName"), Label)
                        Dim btnToggleBatches As LinkButton = CType(e.Row.FindControl("btnToggleBatchTest"), LinkButton)
                        Dim btnSetMyFavorite As LinkButton = CType(e.Row.FindControl("btnBatchesSetMyFavorite"), LinkButton)
                        Dim imgMyFavoriteStar As Image = CType(e.Row.FindControl("imgBatchesMyFavoriteStar"), Image)
                        Dim lblBatchesStartedDate As Label = CType(e.Row.FindControl("lblBatchesStartedDate"), Label)
                        Dim lblBatchesResultDate As Label = CType(e.Row.FindControl("lblBatchesResultDate"), Label)

                        If Not batchTest.ResultDate Is Nothing Then
                            lblBatchesResultDate.Text = Convert.ToDateTime(batchTest.ResultDate).ToShortDateString()
                        End If

                        If Not batchTest.StartedDate Is Nothing Then
                            lblBatchesStartedDate.Text = Convert.ToDateTime(batchTest.StartedDate).ToShortDateString()
                        End If

                        Dim lblTestStatusTypeName As Label = CType(e.Row.FindControl("lblBatchesTestStatusTypeName"), Label)
                        Dim ddlTestStatusType As DropDownList = CType(e.Row.FindControl("ddlBatchesTestStatusType"), DropDownList)
                        ddlTestStatusType.DataSource = ddlTestStatusTypes.Items
                        ddlTestStatusType.DataTextField = "Text"
                        ddlTestStatusType.DataValueField = "Value"
                        ddlTestStatusType.DataBind()
                        ddlTestStatusType.SelectedValue = If(batchTest.TestStatusTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, batchTest.TestStatusTypeID)

                        Dim lblTestResultTypeName As Label = CType(e.Row.FindControl("lblBatchesTestResultTypeName"), Label)
                        Dim ddlTestResultType As DropDownList = CType(e.Row.FindControl("ddlBatchesTestResultType"), DropDownList)
                        ddlTestResultType.DataSource = ddlTestResultTypes.Items
                        ddlTestResultType.DataTextField = "Text"
                        ddlTestResultType.DataValueField = "Value"
                        ddlTestResultType.DataBind()
                        ddlTestResultType.SelectedValue = If(batchTest.TestResultTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, batchTest.TestResultTypeID.ToString())

                        Dim lblTestCategoryTypeName As Label = CType(e.Row.FindControl("lblBatchesTestCategoryTypeName"), Label)
                        Dim ddlTestCategoryType As DropDownList = CType(e.Row.FindControl("ddlBatchesTestCategoryType"), DropDownList)
                        ddlTestCategoryType.DataSource = ddlTestCategoryTypes.Items
                        ddlTestCategoryType.DataTextField = "Text"
                        ddlTestCategoryType.DataValueField = "Value"
                        ddlTestCategoryType.DataBind()
                        ddlTestCategoryType.SelectedValue = If(batchTest.TestCategoryTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, batchTest.TestCategoryTypeID)

                        Select Case batchTest.TestStatusTypeID
                            Case TestStatusTypes.Amended
                                lblTestStatusTypeName.Visible = True
                                ddlTestStatusType.Visible = False

                                lblTestResultTypeName.Visible = True
                                ddlTestResultType.Visible = False

                                lblTestCategoryTypeName.Visible = True
                                ddlTestCategoryType.Visible = False
                            Case TestStatusTypes.Final
                                lblTestStatusTypeName.Visible = True
                                ddlTestStatusType.Visible = False

                                lblTestResultTypeName.Visible = True
                                ddlTestResultType.Visible = False

                                lblTestCategoryTypeName.Visible = True
                                ddlTestCategoryType.Visible = False
                            Case TestStatusTypes.MarkedForDeletion
                                lblTestStatusTypeName.Visible = True
                                ddlTestStatusType.Visible = False

                                lblTestResultTypeName.Visible = True
                                ddlTestResultType.Visible = False

                                lblTestCategoryTypeName.Visible = True
                                ddlTestCategoryType.Visible = False
                            Case Else
                                lblTestStatusTypeName.Visible = False
                                ddlTestStatusType.Visible = True

                                lblTestResultTypeName.Visible = False
                                ddlTestResultType.Visible = True

                                lblTestCategoryTypeName.Visible = False
                                ddlTestCategoryType.Visible = True
                        End Select

                        If batchTest.RowSelectionIndicator = 0 Then
                            btnToggleBatches.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                        Else
                            btnToggleBatches.CssClass = CSS_BTN_GLYPHICON_CHECKED
                        End If

                        If batchTest.FavoriteIndicator Is Nothing Then
                            btnSetMyFavorite.CssClass = "myFavoriteNo"
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/blueStar.png"
                        Else
                            btnSetMyFavorite.CssClass = "myFavorite"
                            imgMyFavoriteStar.ImageUrl = "~/Includes/Images/whiteStar.png"
                        End If

                        Dim commentBoxEmptyLink As HtmlAnchor = CType(e.Row.FindControl("lnkBatchesSampleStatusCommentEmpty"), HtmlAnchor)
                        commentBoxEmptyLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentBoxLink As HtmlAnchor = CType(e.Row.FindControl("lnkBatchesSampleStatusComment"), HtmlAnchor)
                        commentBoxLink.Attributes.Add("data-toggle", "comment-popover_" & e.Row.RowIndex)

                        Dim commentEmptyJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divBatchesCommentBoxEmptyContainer_" & e.Row.RowIndex & "').html(); }});"
                        Dim commentJavaScript As String = "$('[data-toggle=comment-popover_" & e.Row.RowIndex & "]').popover({ html: true, content: function () { return $('#" & clientID & "_divBatchesCommentBoxContainer_" & e.Row.RowIndex & "').html(); }});"

                        If batchTest.AccessionComment.IsValueNullOrEmpty() Then
                            commentBoxEmptyLink.Visible = True
                            commentBoxLink.Visible = False
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentEmptyJavaScript, True)
                        Else
                            commentBoxEmptyLink.Visible = False
                            commentBoxLink.Visible = True
                            'Dim commentTextBox As TextBox = CType(e.Row.FindControl("txtBatchesCommentTextBox"), TextBox)
                            'commentTextBox.Text = batchTest.AccessionComment
                            ScriptManager.RegisterStartupScript(Me, [GetType](), POPOVER_KEY & "_" & e.Row.RowIndex, commentJavaScript, True)
                        End If

                        If batchTest.RowAction = RecordConstants.Update Or
                            batchTest.RowAction = RecordConstants.Accession Then
                            e.Row.CssClass = "savePending"
                            e.Row.Cells(0).CssClass = "savePending"
                            e.Row.Cells(e.Row.Cells.Count - 1).CssClass = "savePending"
                        Else
                            e.Row.CssClass = "noSavePending"
                            e.Row.Cells(0).CssClass = "noSavePending"
                            e.Row.Cells(e.Row.Cells.Count - 1).CssClass = "noSavePending"
                        End If

                        lblSampleStatusTypeName.Visible = True
                    End If
                End If
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
    Protected Sub Batches_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvBatches.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelectAll
                        Dim btnToggleAllBatches As LinkButton = CType(e.CommandSource, LinkButton)
                        Dim toggleIndicator As Boolean = False

                        If btnToggleAllBatches.CssClass = CSS_BTN_GLYPHICON_UNCHECKED Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleAllBatches(toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.ToggleSelect
                        Dim toggleIndicator As Boolean = False

                        If CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel)).Where(Function(x) x.BatchTestID = e.CommandArgument).FirstOrDefault().RowSelectionIndicator = 0 Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleBatchTest(batchTestID:=e.CommandArgument, testID:=Nothing, toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)

                        upBatches.Update()
                    Case GridViewCommandConstants.EditCommand
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditBatch.ToString()
                        InitializeControl(tab:=LaboratoryModuleTabConstants.Batches, batchTestID:=CType(e.CommandArgument, Long))
                    Case GridViewCommandConstants.MyFavoriteCommand
                        Dim list As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel)).Where(Function(x) x.BatchTestID = e.CommandArgument).ToList()
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite As LabFavoriteGetListModel
                        For Each item As LabBatchGetListModel In list
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next
                        SetMyFavorite(False, favorites)
                        btnBatchesSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                        upBatches.Update()
                    Case GridViewCommandConstants.SelectAllRecordsMyFavoriteCommand
                        Dim selectAll As Boolean = False
                        Dim batches As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite = New LabFavoriteGetListModel()

                        If batches Is Nothing Then
                            batches = New List(Of LabBatchGetListModel)()
                        End If

                        If batches.Where(Function(x) x.FavoriteIndicator = 1).Count < batches.Count() Then
                            selectAll = True
                        End If

                        For Each item As LabBatchGetListModel In batches
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next

                        SetMyFavorite(selectAll, favorites)
                        btnBatchesSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Batches_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvBatches.Sorting

        Try
            ViewState(BATCHES_SORT_DIRECTION) = IIf(ViewState(BATCHES_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(BATCHES_SORT_EXPRESSION) = e.SortExpression

            FillDropDowns()

            BindBatchesGridView()

            upBatches.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the batches select/deselect all toggle event.
    ''' </summary>
    Private Sub ToggleAllBatches(toggleIndicator As Boolean)

        Try
            Dim index As Integer = 0
            Dim batches As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))

            If toggleIndicator = True Then
                For Each batch In batches
                    batches(index).RowSelectionIndicator = 1

                    index += 1
                Next
            Else
                For Each batch In batches
                    batches(index).RowSelectionIndicator = 0

                    index += 1
                Next
            End If

            Session(SESSION_BATCHES_LIST) = batches
            FillDropDowns()
            gvBatches.PageIndex = lblBatchesPageNumber.Text - 1
            BindBatchesGridView()
            upBatchesButtons.Update()
            upBatchesMenu.Update()
            upBatches.Update()
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
    Protected Sub BatchTests_RowCommand(sender As Object, e As GridViewCommandEventArgs)

        Try
            If Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelectAll
                        Dim btnToggleAllBatches As LinkButton = CType(e.CommandSource, LinkButton)
                        Dim toggleIndicator As Boolean = False

                        If btnToggleAllBatches.CssClass = CSS_BTN_GLYPHICON_UNCHECKED Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleAllBatches(toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.ToggleSelect
                        Dim toggleIndicator As Boolean = False
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")

                        If CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel)).Where(Function(x) x.BatchTestID = commandArguments(0) And x.TestID = commandArguments(1)).FirstOrDefault().RowSelectionIndicator = 0 Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If

                        ToggleBatchTest(batchTestID:=commandArguments(0), testID:=commandArguments(1), toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.EditCommand
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditTest.ToString()
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        InitializeControl(tab:=LaboratoryModuleTabConstants.Testing, testID:=CType(commandArguments(0), Long), batchTestID:=CType(commandArguments(1), Long))
                    Case GridViewCommandConstants.MyFavoriteCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        Dim list As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel)).Where(Function(x) x.BatchTestID = commandArguments(0) And x.TestID = commandArguments(1)).ToList()
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite As LabFavoriteGetListModel
                        For Each item As LabBatchGetListModel In list
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next
                        SetMyFavorite(False, favorites)
                        btnBatchesSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                        upBatches.Update()
                    Case GridViewCommandConstants.SelectAllRecordsMyFavoriteCommand
                        Dim selectAll As Boolean = False
                        Dim batchTests As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel))
                        Dim favorites = New List(Of LabFavoriteGetListModel)()
                        Dim favorite = New LabFavoriteGetListModel()

                        If batchTests Is Nothing Then
                            batchTests = New List(Of LabBatchGetListModel)()
                        End If

                        If batchTests.Where(Function(x) x.FavoriteIndicator = 1).Count < batchTests.Count() Then
                            selectAll = True
                        End If

                        For Each item As LabBatchGetListModel In batchTests
                            favorite = New LabFavoriteGetListModel()
                            With favorite
                                .AccessionComment = item.AccessionComment
                                .AccessionConditionOrSampleStatusTypeName = item.AccessionConditionOrSampleStatusTypeName
                                .AccessionDate = item.AccessionDate
                                .DiseaseName = item.DiseaseName
                                .EIDSSAnimalID = item.EIDSSAnimalID
                                .EIDSSLaboratorySampleID = item.EIDSSLaboratorySampleID
                                .EIDSSReportSessionID = item.EIDSSReportSessionID
                                .FunctionalAreaName = item.FunctionalAreaName
                                .PatientFarmOwnerName = item.PatientFarmOwnerName
                                .SampleID = item.SampleID
                                .SampleStatusTypeID = item.SampleStatusTypeID
                                .SampleTypeName = item.SampleTypeName
                                .TestCategoryTypeID = item.TestCategoryTypeID
                                .TestCategoryTypeName = item.TestCategoryTypeName
                                .TestID = item.TestID
                                .TestNameTypeName = item.TestNameTypeName
                                .TestResultTypeID = item.TestResultTypeID
                                .TestResultTypeName = item.TestResultTypeName
                                .TestStatusTypeID = item.TestStatusTypeID
                                .TestStatusTypeName = item.TestStatusTypeName
                                .RowAction = RecordConstants.Insert
                            End With
                            favorites.Add(favorite)
                        Next

                        SetMyFavorite(selectAll, favorites)
                        btnBatchesSave.Enabled = True
                        btnMyFavoritesSave.Enabled = True
                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    ''' <param name="testID"></param>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleBatchTest(batchTestID As Long, testID As Long?, toggleIndicator As Boolean)

        Try
            Dim batchTests As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel))
            Dim batches As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))

            If batches Is Nothing Then
                batches = New List(Of LabBatchGetListModel)()
            End If

            If batchTests Is Nothing Then
                batchTests = New List(Of LabBatchGetListModel)()
            End If

            If toggleIndicator = True Then
                If testID Is Nothing Then
                    batches.Where(Function(x) x.BatchTestID = batchTestID).FirstOrDefault().RowSelectionIndicator = 1

                    ucBatchesSearch.BatchTestDiseaseID = batches.Where(Function(x) x.BatchTestID = batchTestID).FirstOrDefault().DiseaseID
                    ucBatchesSearch.DisableEnableForBatchTestSelectSample(toggleIndicator:=toggleIndicator)
                    hdfBatchTestID.Value = batchTestID

                    btnAddGroupResult.Disabled = False
                    btnBatchesRemoveSample.Enabled = False
                Else
                    batchTests.Where(Function(x) x.BatchTestID = batchTestID And x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 1

                    btnAddGroupResult.Disabled = True
                    btnBatchesRemoveSample.Enabled = True
                End If
            Else
                If testID Is Nothing Then
                    batches.Where(Function(x) x.BatchTestID = batchTestID).FirstOrDefault().RowSelectionIndicator = 0

                    ucBatchesSearch.BatchTestDiseaseID = Nothing
                    ucBatchesSearch.DisableEnableForBatchTestSelectSample(toggleIndicator:=toggleIndicator)

                    btnAddGroupResult.Disabled = True
                    btnBatchesRemoveSample.Enabled = False
                Else
                    batchTests.Where(Function(x) x.BatchTestID = batchTestID And x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 0

                    btnBatchesRemoveSample.Enabled = False
                End If
            End If

            Session(SESSION_BATCHES_LIST) = batches
            Session(SESSION_BATCH_TESTS_LIST) = batchTests
            FillDropDowns()
            gvBatches.PageIndex = lblBatchesPageNumber.Text - 1
            BindBatchesGridView()
            upBatchesMenu.Update()
            upBatchesButtons.Update()
            upBatchesSearch.Update()
            upBatches.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
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
    Private Sub BatchesSave_Click(sender As Object, e As EventArgs) Handles btnBatchesSave.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            AddUpdateLaboratory()

            upSuccessModal.Update()
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)

            FillDropDowns()
            FillTabCounts()
            FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
            BindBatchesGridView()
            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
            BindMyFavoritesGridView()

            FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
            lblApprovalsPageNumber.Text = 1
            BindApprovalsGridView()

            FillTabCounts()

            upLaboratoryTabCounts.Update()
            upApprovals.Update()
            upApprovalsButtons.Update()
            upApprovalsSave.Update()
            upApprovalsMenu.Update()

            upBatches.Update()
            upBatchesButtons.Update()
            upBatchesMenu.Update()
            upBatchesSave.Update()
            upBatchesSearch.Update()
            upBatchesSearchResults.Update()
            'VerifyUserPermissions(False)

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    Private Sub CancelAddUpdateBatchTest_Click(sender As Object, e As EventArgs) Handles btnCancelAddUpdateBatchTest.Click

        Try
            hdfCurrentModuleAction.Value = ucAddUpdateBatchTest.ID
            ShowWarningMessage(messageType:=MessageType.CancelConfirm, isConfirm:=True, message:=Nothing)
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
    Protected Sub BatchesTestStatusType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddl As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddl.NamingContainer, GridViewRow)
            Dim gvBatchTest As GridView = Nothing
            Dim batchTestID As String = String.Empty
            Dim dataKey As String = String.Empty

            For Each batchesRow As GridViewRow In gvBatches.Rows
                gvBatchTest = CType(batchesRow.FindControl("gvBatchTests"), GridView)

                If Not gvBatchTest Is Nothing Then
                    If gvBatchTest.ClientID = row.NamingContainer.ClientID Then
                        batchTestID = gvBatches.DataKeys(batchesRow.RowIndex).Value.ToString()
                        Exit For
                    End If
                End If
            Next

            If gvBatchTest Is Nothing Then
                ShowErrorMessage(messageType:=MessageType.UnhandledException, message:=GetLocalResourceObject("Err_Unable_To_Update_Value_Message_Text"))
            Else
                dataKey = gvBatchTest.DataKeys(row.RowIndex).Value.ToString()
            End If

            UpdateBatchTestTestStatus(testStatusTypeID:=ddl.SelectedValue, batchTestID:=batchTestID, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testStatusTypeID"></param>
    ''' <param name="batchTestID"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateBatchTestTestStatus(ByVal testStatusTypeID As String, ByVal batchTestID As Long, ByVal testID As Long)

        Dim gridViewList As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel)).Where(Function(x) x.BatchTestID = batchTestID And x.TestID = testID).ToList()
        Dim pendingSaveList As List(Of LabBatchGetListModel)
        If Session(SESSION_BATCHES_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabBatchGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))
        End If

        gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestStatusTypeID = If(testStatusTypeID.IsValueNullOrEmpty, Nothing, testStatusTypeID)

        If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_BATCH_TESTS_LIST) = gridViewList
        Session(SESSION_BATCH_TESTS_SAVE_LIST) = pendingSaveList
        gvBatches.PageIndex = 0
        lblBatchesPageNumber.Text = 1
        ViewState(BATCHES_SORT_DIRECTION) = Nothing
        ViewState(BATCHES_SORT_DIRECTION) = Nothing
        BindBatchesGridView()
        FillBatchesPager(hdfTestingCount.Value, 1)

        upBatches.Update()
        upBatchesSave.Update()
        upBatchesButtons.Update()
        upBatchesMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub BatchesTestResultType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddl As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddl.NamingContainer, GridViewRow)
            Dim gvBatchTest As GridView = Nothing
            Dim batchTestID As String = String.Empty
            Dim dataKey As String = String.Empty

            For Each batchesRow As GridViewRow In gvBatches.Rows
                gvBatchTest = CType(batchesRow.FindControl("gvBatchTests"), GridView)

                If Not gvBatchTest Is Nothing Then
                    If gvBatchTest.ClientID = row.NamingContainer.ClientID Then
                        batchTestID = gvBatches.DataKeys(batchesRow.RowIndex).Value.ToString()
                        Exit For
                    End If
                End If
            Next

            If gvBatchTest Is Nothing Then
                ShowErrorMessage(messageType:=MessageType.UnhandledException, message:=GetLocalResourceObject("Err_Unable_To_Update_Value_Message_Text"))
            Else
                dataKey = gvBatchTest.DataKeys(row.RowIndex).Value.ToString()
            End If

            UpdateBatchTestTestResult(testResultTypeID:=ddl.SelectedValue, batchTestID:=batchTestID, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testResultTypeID"></param>
    ''' <param name="batchTestID"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateBatchTestTestResult(ByVal testResultTypeID As String, ByVal batchTestID As Long, ByVal testID As Long)

        Dim gridViewList As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel)).Where(Function(x) x.BatchTestID = batchTestID And x.TestID = testID).ToList()
        Dim pendingSaveList As List(Of LabBatchGetListModel)
        If Session(SESSION_BATCHES_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabBatchGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))
        End If

        gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestResultTypeID = If(testResultTypeID.IsValueNullOrEmpty, Nothing, testResultTypeID)

        If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_BATCH_TESTS_LIST) = gridViewList
        Session(SESSION_BATCH_TESTS_SAVE_LIST) = pendingSaveList
        gvBatches.PageIndex = 0
        lblBatchesPageNumber.Text = 1
        ViewState(BATCHES_SORT_DIRECTION) = Nothing
        ViewState(BATCHES_SORT_DIRECTION) = Nothing
        BindBatchesGridView()
        FillBatchesPager(hdfTestingCount.Value, 1)

        upBatches.Update()
        upBatchesSave.Update()
        upBatchesButtons.Update()
        upBatchesMenu.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub BatchesTestCategoryType_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddl As DropDownList = sender
            Dim row As GridViewRow = TryCast(ddl.NamingContainer, GridViewRow)
            Dim gvBatchTest As GridView = Nothing
            Dim dataKey As String = String.Empty
            Dim batchTestID As String = String.Empty

            For Each batchesRow As GridViewRow In gvBatches.Rows
                gvBatchTest = CType(batchesRow.FindControl("gvBatchTests"), GridView)

                If Not gvBatchTest Is Nothing Then
                    If gvBatchTest.ClientID = row.NamingContainer.ClientID Then
                        batchTestID = gvBatches.DataKeys(batchesRow.RowIndex).Value.ToString()
                        Exit For
                    End If
                End If
            Next

            If gvBatchTest Is Nothing Then
                ShowErrorMessage(messageType:=MessageType.UnhandledException, message:=GetLocalResourceObject("Err_Unable_To_Update_Value_Message_Text"))
            Else
                dataKey = gvBatchTest.DataKeys(row.RowIndex).Value.ToString()
            End If

            UpdateBatchTestTestCategory(testCategoryTypeID:=ddl.SelectedValue, batchTestID:=batchTestID, testID:=dataKey)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testCategoryTypeID"></param>
    ''' <param name="batchTestID"></param>
    ''' <param name="testID"></param>
    Private Sub UpdateBatchTestTestCategory(ByVal testCategoryTypeID As String, ByVal batchTestID As Long, ByVal testID As Long)

        Dim gridViewList As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel)).Where(Function(x) x.BatchTestID = batchTestID And x.TestID = testID).ToList()
        Dim pendingSaveList As List(Of LabBatchGetListModel)
        If Session(SESSION_BATCH_TESTS_SAVE_LIST) Is Nothing Then
            pendingSaveList = New List(Of LabBatchGetListModel)()
        Else
            pendingSaveList = CType(Session(SESSION_BATCH_TESTS_SAVE_LIST), List(Of LabBatchGetListModel))
        End If

        gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().TestCategoryTypeID = If(testCategoryTypeID.IsValueNullOrEmpty, Nothing, testCategoryTypeID)

        If Not gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Insert Then
            gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault().RowAction = RecordConstants.Update
        End If

        If pendingSaveList.Where(Function(x) x.TestID = testID).Count = 0 Then
            pendingSaveList.Add(gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault())
        Else
            Dim index As Integer = pendingSaveList.IndexOf(pendingSaveList.Where(Function(x) x.TestID = testID).FirstOrDefault())
            pendingSaveList(index) = gridViewList.Where(Function(x) x.TestID = testID).FirstOrDefault()
        End If

        FillDropDowns()
        Session(SESSION_BATCH_TESTS_LIST) = gridViewList
        Session(SESSION_BATCH_TESTS_SAVE_LIST) = pendingSaveList
        gvBatches.PageIndex = 0
        lblBatchesPageNumber.Text = 1
        ViewState(BATCHES_SORT_DIRECTION) = Nothing
        ViewState(BATCHES_SORT_DIRECTION) = Nothing
        BindBatchesGridView()
        FillBatchesPager(hdfTestingCount.Value, 1)

        upBatches.Update()
        upBatchesSave.Update()
        upBatchesButtons.Update()
        upBatchesMenu.Update()

    End Sub

#End Region

#Region "Remove Sample from Batch Methods"

    ''' <summary>
    ''' Removes the selected sample/test from the batch test record.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub BatchesRemoveSample_Click(sender As Object, e As EventArgs) Handles btnBatchesRemoveSample.Click

        Try
            Dim batchTests = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim test As LabTestGetListModel
            Dim parameters As LaboratoryTestGetListParameters

            If batchTests Is Nothing Then
                FillBatchesList(lblBatchesPageNumber.Text, ViewState(BATCHES_PAGINATION_SET_NUMBER))
                batchTests = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel))
            End If

            If batchTests.Where(Function(x) x.RowSelectionIndicator = 1).Count = 0 Then
                ShowWarningMessage(messageType:=MessageType.CannotAssignTest, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_No_Batch_Test_Selected_To_Remove_Body_Text"))
            Else
                If testsPendingSave Is Nothing Then
                    testsPendingSave = New List(Of LabTestGetListModel)()
                End If

                For Each batchTest In batchTests
                    If batchTest.RowSelectionIndicator = 1 Then
                        parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = batchTest.TestID, .UserID = hdfUserID.Value, .BatchTestID = batchTest.BatchTestID}

                        If LaboratoryAPIService Is Nothing Then
                            LaboratoryAPIService = New LaboratoryServiceClient()
                        End If
                        test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result.FirstOrDefault()

                        test.BatchTestID = Nothing
                        testsPendingSave.Add(test)
                    End If
                Next
            End If

            Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave

            AddUpdateLaboratory()

            FillDropDowns()

            Dim testingParameters = New LaboratoryTestGetListParameters With {.BatchTestID = Nothing, .LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .SampleID = Nothing, .UserID = hdfUserID.Value}
            Dim testingCounts = LaboratoryAPIService.LaboratoryTestGetListCountAsync(parameters:=testingParameters).Result
            lblTestingCount.Text = testingCounts(0).RecordCount
            hdfTestingCount.Value = testingCounts(0).RecordCount
            lblTestingPageNumber.Text = 1
            gvTesting.PageIndex = 0
            FillTestingList(pageIndex:=1, paginationSetNumber:=1)
            BindTestingGridView()

            Session(SESSION_TESTING_SAVE_LIST) = New List(Of LabTestGetListModel)()

            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
            BindMyFavoritesGridView()

            Dim batchesParameters = New LaboratoryBatchGetListParameters With {.OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
            Dim batchesCount = LaboratoryAPIService.LaboratoryBatchGetListCountAsync(parameters:=batchesParameters).Result
            lblBatchesCount.Text = batchesCount(0).RecordCount
            FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
            BindBatchesGridView()

            FillTabCounts()

            upLaboratoryTabCounts.Update()
            upTesting.Update()
            upTestingButtons.Update()
            upTestingSave.Update()
            upTestingMenu.Update()

            upBatches.Update()
            upBatchesButtons.Update()
            upBatchesSave.Update()
            upBatchesMenu.Update()
            'VerifyUserPermissions(False)

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Close Batch Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub CloseBatch_Click(sender As Object, e As EventArgs) Handles btnCloseBatch.Click

        Try
            Dim batches = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
            Dim batchesPendingSave = CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))
            Dim index As Integer = 0

            If batches Is Nothing Then
                batches = New List(Of LabBatchGetListModel)()
            End If

            If batches.Where(Function(x) x.RowSelectionIndicator = 1).Count = 0 Then
                ShowWarningMessage(messageType:=MessageType.NoBatchSelectedForClosure, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_No_Batch_Test_Selected_To_Close_Body_Text"))
            Else
                If batchesPendingSave Is Nothing Then
                    batchesPendingSave = New List(Of LabBatchGetListModel)()
                End If

                Dim errorMessages As New StringBuilder()

                If ValidateBatchForClosure(batches.Where(Function(x) x.RowSelectionIndicator = 1).ToList(), errorMessages:=errorMessages) = True Then
                    For Each batch In batches
                        If batch.RowSelectionIndicator = 1 Then
                            batch.BatchStatusTypeID = TestStatusTypes.Final
                            batch.BatchStatusTypeName = Resources.Labels.Lbl_Closed_Text
                            batch.RowAction = RecordConstants.Update

                            If batchesPendingSave.Where(Function(x) x.BatchTestID = batch.BatchTestID).Count() > 0 Then
                                index = batchesPendingSave.FindIndex(Function(x) x.BatchTestID = batch.BatchTestID)
                                batchesPendingSave(index) = batch
                            Else
                                batchesPendingSave.Add(batch)
                            End If
                        End If
                    Next

                    AddUpdateLaboratory()

                    FillDropDowns()

                    Dim batchesPrameters = New LaboratoryBatchGetListParameters With {.OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
                    Dim batchesCount = LaboratoryAPIService.LaboratoryBatchGetListCountAsync(parameters:=batchesPrameters).Result
                    lblBatchesCount.Text = batchesCount(0).RecordCount
                    FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
                    Session(SESSION_BATCHES_SAVE_LIST) = New List(Of LabTestGetListModel)()

                    Dim approvalsParameters = New LaboratoryApprovalGetListParameters With {.LanguageID = GetCurrentLanguage(), .SiteID = hdfSiteID.Value, .PaginationSetNumber = 1}
                    Dim approvalsCount = LaboratoryAPIService.LaboratoryApprovalGetListCountAsync(parameters:=approvalsParameters).Result
                    lblApprovalsCount.Text = approvalsCount(0).RecordCount
                    FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
                    BindApprovalsGridView()
                    lblApprovalsPageNumber.Text = 1

                    FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    BindMyFavoritesGridView()

                    FillTabCounts()

                    upLaboratoryTabCounts.Update()
                    upApprovals.Update()
                    upApprovalsButtons.Update()
                    upApprovalsSave.Update()
                    upApprovalsMenu.Update()

                    upBatches.Update()
                    upBatchesButtons.Update()
                    upBatchesSave.Update()
                    upBatchesMenu.Update()
                    'VerifyUserPermissions(False)

                    ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Validates batches selected by the user for closure meet the business rules.
    ''' </summary>
    ''' <param name="batchTests">Batch tests selected for closure.</param>
    ''' <param name="errorMessages">Validation error messages returned to display back to the user.</param>
    ''' <returns></returns>
    Private Function ValidateBatchForClosure(ByVal batchTests As List(Of LabBatchGetListModel), ByRef errorMessages As StringBuilder) As Boolean

        Dim validateStatus As Boolean = True

        For Each batchTest In batchTests
            If batchTest.TestResultTypeID.ToString.IsValueNullOrEmpty() Then
                errorMessages.Append("<p>" & GetLocalResourceObject("Err_Message_Test_Must_Have_Result_Text") & "</p>")
                validateStatus = False
            End If
        Next

        Return validateStatus

    End Function

#End Region

#Region "Create Batch Methods"

    ''' <summary>
    ''' Event handler for the assign test button click event.
    ''' </summary>
    Protected Sub TestingBatch_Click(sender As Object, e As EventArgs) Handles btnTestingBatch.Click

        Try
            InitializeBatch(LaboratoryModuleTabConstants.Testing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub InitializeBatch(tab As String)

        Try
            upAddUpdateBatch.Update()

            Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            Dim selectedTests = New List(Of LabTestGetListModel)()
            Dim batchTestsPendingSave = CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))

            If tests Is Nothing Then
                tests = New List(Of LabTestGetListModel)()
                Session(SESSION_TESTING_LIST) = tests
            End If

            If batchTestsPendingSave Is Nothing Then
                batchTestsPendingSave = New List(Of LabBatchGetListModel)()
            End If

            For Each test In tests
                If test.RowSelectionIndicator = 1 Then
                    selectedTests.Add(test)
                End If
            Next

            hdgAddUpdateBatchTest.InnerHtml = Resources.Labels.Lbl_Create_Batch_Text
            pnlAddUpdateBatchTestForm.DefaultButton = "btnAddUpdateBatchTestBatch"
            btnAddUpdateBatchTestBatch.Visible = True
            btnSaveAddUpdateBatchTest.Visible = False

            If selectedTests.Count = 0 Then
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAddUpdateBatchTestModal"), True)
                ShowWarningMessage(messageType:=MessageType.CannotBatchTest, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Sample_Must_Be_Accessioned_Assign_Test_Body_Text"))
            Else
                ucAddUpdateBatchTest.BatchTest = New LabBatchGetListModel With {
                    .BatchTestTestNameTypeID = selectedTests.FirstOrDefault().TestNameTypeID,
                    .BatchTestTestNameTypeName = selectedTests.FirstOrDefault().TestNameTypeName
                }
                ucAddUpdateBatchTest.Setup(batchesPendingSaveCount:=batchTestsPendingSave.Count)
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAddUpdateBatchTestModal"), True)
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
    Private Sub AddUpdateBatchTestBatch_Click(sender As Object, e As EventArgs) Handles btnAddUpdateBatchTestBatch.Click

        Try
            Dim batchTests = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
            Dim batchTestsPendingSave = CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))
            Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim test = tests.Where(Function(x) x.RowSelectionIndicator = 1).FirstOrDefault()

            If batchTests Is Nothing Then
                batchTests = New List(Of LabBatchGetListModel)()
            End If

            If batchTestsPendingSave Is Nothing Then
                batchTestsPendingSave = New List(Of LabBatchGetListModel)()
            End If

            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
            End If

            batchTestsPendingSave.Add(ucAddUpdateBatchTest.SaveBatchTest(test))

            Dim index As Integer = 0

            If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                testsPendingSave(index) = test
            Else
                testsPendingSave.Add(test)
            End If

            Session(SESSION_TESTING_LIST) = tests
            Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
            Session(SESSION_BATCHES_LIST) = batchTests
            Session(SESSION_BATCHES_SAVE_LIST) = batchTestsPendingSave

            AddUpdateLaboratory()

            FillDropDowns()

            Dim batchesParameters = New LaboratoryBatchGetListParameters With {.PaginationSetNumber = 1, .UserID = hdfUserID.Value, .OrganizationID = hdfOrganizationID.Value}
            Dim batchesCounts = LaboratoryAPIService.LaboratoryBatchGetListCountAsync(batchesParameters).Result
            lblBatchesCount.Text = batchesCounts(0).InProgressCount
            hdfBatchesCount.Value = batchesCounts(0).RecordCount
            lblBatchesPageNumber.Text = 1
            gvBatches.PageIndex = 0
            FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
            BindBatchesGridView()
            FillBatchesPager(hdfBatchesCount.Value, 1)

            Session(SESSION_BATCHES_SAVE_LIST) = New List(Of LabBatchGetListModel)()
            Session(SESSION_TESTING_SAVE_LIST) = New List(Of LabTestGetListModel)()

            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
            BindMyFavoritesGridView()

            Dim testingParameters = New LaboratoryTestGetListParameters With {.PaginationSetNumber = 1, .OrganizationID = hdfOrganizationID.Value, .UserID = hdfUserID.Value}
            Dim testingCounts = LaboratoryAPIService.LaboratoryTestGetListCountAsync(testingParameters).Result
            lblTestingCount.Text = testingCounts(0).RecordCount
            lblTestingPageNumber.Text = 1
            gvTesting.PageIndex = 0
            FillTestingList(pageIndex:=1, paginationSetNumber:=1)
            BindTestingGridView()

            FillTabCounts()

            upLaboratoryTabCounts.Update()
            upBatches.Update()
            upBatchesButtons.Update()
            upBatchesSave.Update()
            upBatchesMenu.Update()
            'VerifyUserPermissions(False)

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)

            ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAddUpdateBatchTestModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Edit Batch Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="batchTestID"></param>
    Private Sub InitializeEditBatch(batchTestID As Long)

        Try
            If batchTestID = 0 Then
                ShowWarningMessage(messageType:=MessageType.CannotSetTestResult, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Batch_Must_Be_Selected_Body_Text"))

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "hideModal('#divEditBatchTestModal');", True)
            Else
                Dim batches As List(Of LabBatchGetListModel) = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))

                If batches Is Nothing Then
                    FillBatchesList(lblBatchesPageNumber.Text, ViewState(BATCHES_PAGINATION_SET_NUMBER))
                End If

                hdgAddUpdateBatchTest.InnerHtml = Resources.Labels.Lbl_Batch_Results_Details_Text
                pnlAddUpdateBatchTestForm.DefaultButton = "btnSaveAddUpdateBatchTest"
                btnAddUpdateBatchTestBatch.Visible = False
                btnSaveAddUpdateBatchTest.Visible = True

                ucAddUpdateBatchTest.BatchTest = batches.Where(Function(x) x.BatchTestID = batchTestID).FirstOrDefault()
                ucAddUpdateBatchTest.Setup()
                ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAddUpdateBatchTestModal"), True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Approvals Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillApprovalsList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            If hdfAdvancedSearchIndicator.Value = YesNoUnknown.No And hdgTestingQueryText.InnerText = String.Empty Then
                Dim parameters = New LaboratoryApprovalGetListParameters With {.LanguageID = GetCurrentLanguage(), .SiteID = hdfSiteID.Value, .PaginationSetNumber = paginationSetNumber}

                If hdfCurrentModuleAction.Value.IsValueNullOrEmpty Then
                    parameters.SpecificApprovalTypeIndicator = False
                Else
                    If hdfCurrentModuleAction.Value = DirectCast([Enum].Parse(GetType(LaboratoryModuleActions), LaboratoryModuleActions.ValidationApprovals), LaboratoryModuleActions) Or
                    hdfCurrentModuleAction.Value = DirectCast([Enum].Parse(GetType(LaboratoryModuleActions), LaboratoryModuleActions.SampleDestructionApprovals), LaboratoryModuleActions) Or
                    hdfCurrentModuleAction.Value = DirectCast([Enum].Parse(GetType(LaboratoryModuleActions), LaboratoryModuleActions.RecordDeletionApprovals), LaboratoryModuleActions) Then
                        parameters.SpecificApprovalTypeIndicator = True
                    Else
                        parameters.SpecificApprovalTypeIndicator = False
                    End If
                End If
                Session(SESSION_APPROVALS_LIST) = LaboratoryAPIService.LaboratoryApprovalGetListAsync(parameters:=parameters).Result
            Else
                If hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes Then
                    ucSearchSample.FillMyFavoritesList()
                Else
                    ucMyFavoritesSearch.Search()
                End If
            End If

            FillApprovalsPager(lblApprovalsCount.Text, pageIndex)
            ViewState(APPROVALS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillApprovalsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Try
            Dim pages As New List(Of ListItem)()
            Dim startIndex As Integer, endIndex As Integer
            Dim pagerSpan As Integer = 5

            If recordCount > 0 Then
                divApprovalsPager.Visible = True

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
                rptApprovalsPager.DataSource = pages
                rptApprovalsPager.DataBind()
            Else
                divApprovalsPager.Visible = False
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
    Protected Sub ApprovalsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblApprovalsPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = 0

            If hdfCurrentModuleAction.Value.IsValueNullOrEmpty Then
                paginationSetNumber = Math.Ceiling(pageIndex / gvApprovals.PageSize)
            Else
                'Bring back a max of 500 at a time for approvals requested from the dashboard.
                If hdfCurrentModuleAction.Value = DirectCast([Enum].Parse(GetType(LaboratoryModuleActions), LaboratoryModuleActions.ValidationApprovals), LaboratoryModuleActions) Or
                    hdfCurrentModuleAction.Value = DirectCast([Enum].Parse(GetType(LaboratoryModuleActions), LaboratoryModuleActions.SampleDestructionApprovals), LaboratoryModuleActions) Or
                    hdfCurrentModuleAction.Value = DirectCast([Enum].Parse(GetType(LaboratoryModuleActions), LaboratoryModuleActions.RecordDeletionApprovals), LaboratoryModuleActions) Then
                    paginationSetNumber = Math.Ceiling(pageIndex / (gvApprovals.PageSize + 40))
                Else
                    paginationSetNumber = Math.Ceiling(pageIndex / gvApprovals.PageSize)
                End If
            End If

            FillDropDowns()

            If Not ViewState(APPROVALS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvApprovals.PageIndex = gvApprovals.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvApprovals.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvApprovals.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvApprovals.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvApprovals.PageIndex = gvApprovals.PageSize - 1
                        Else
                            gvApprovals.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillApprovalsList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvApprovals.PageIndex = gvApprovals.PageSize - 1
                Else
                    gvApprovals.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindApprovalsGridView()
                FillApprovalsPager(lblApprovalsCount.Text, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindApprovalsGridView()

        Try
            Dim approvals = CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel))
            Dim approvalsPendingSave = CType(Session(SESSION_APPROVALS_SAVE_LIST), List(Of LabApprovalGetListModel))
            Dim approvalsByActionRequested = New List(Of LabApprovalGetListModel)()

            If approvals Is Nothing Then
                approvals = New List(Of LabApprovalGetListModel)()
                Session(SESSION_APPROVALS_LIST) = approvals
            End If

            If approvalsPendingSave Is Nothing Then
                approvalsPendingSave = New List(Of LabApprovalGetListModel)()
                Session(SESSION_APPROVALS_SAVE_LIST) = approvalsPendingSave
            End If

            Select Case hdfCurrentModuleAction.Value
                Case LaboratoryModuleActions.SampleDestructionApprovals
                    If approvalsPendingSave.Count > 0 Then
                        If (Not ViewState(APPROVALS_SORT_EXPRESSION) Is Nothing) Then
                            If ViewState(APPROVALS_SORT_DIRECTION) = SortConstants.Ascending Then
                                approvals = approvals.OrderBy(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            Else
                                approvals = approvals.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            End If
                        Else
                            approvals = approvals.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.EIDSSReportSessionID).ToList()
                        End If
                    Else
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Sample_Destruction_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        'Add the rest of the approval records; not equal sample destruction.
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested <> Resources.Labels.Lbl_Sample_Destruction_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvals = approvalsByActionRequested
                    End If

                    For Each approval In approvals
                        If approval.ActionRequested = Resources.Labels.Lbl_Sample_Destruction_Text Then
                            approval.RowSelectionIndicator = 1
                        End If
                    Next
                Case LaboratoryModuleActions.RecordDeletionApprovals
                    If approvalsPendingSave.Count > 0 Then
                        If (Not ViewState(APPROVALS_SORT_EXPRESSION) Is Nothing) Then
                            If ViewState(APPROVALS_SORT_DIRECTION) = SortConstants.Ascending Then
                                approvals = approvals.OrderBy(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            Else
                                approvals = approvals.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            End If
                        Else
                            approvals = approvals.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.EIDSSReportSessionID).ToList()
                        End If
                    Else
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Sample_Deletion_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Test_Deletion_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Sample_Destruction_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Validation_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvals = approvalsByActionRequested
                    End If

                    For Each approval In approvals
                        If approval.ActionRequested = Resources.Labels.Lbl_Sample_Deletion_Text Or approval.ActionRequested = Resources.Labels.Lbl_Test_Deletion_Text Then
                            approval.RowSelectionIndicator = 1
                        End If
                    Next
                Case LaboratoryModuleActions.ValidationApprovals
                    If approvalsPendingSave.Count > 0 Then
                        If (Not ViewState(APPROVALS_SORT_EXPRESSION) Is Nothing) Then
                            If ViewState(APPROVALS_SORT_DIRECTION) = SortConstants.Ascending Then
                                approvals = approvals.OrderBy(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            Else
                                approvals = approvals.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            End If
                        Else
                            approvals = approvals.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.EIDSSReportSessionID).ToList()
                        End If
                    Else
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Validation_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Sample_Deletion_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Sample_Destruction_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvalsByActionRequested.AddRange(approvals.Where(Function(x) x.ActionRequested = Resources.Labels.Lbl_Test_Deletion_Text).OrderBy(Function(x) x.EIDSSReportSessionID))
                        approvals = approvalsByActionRequested
                    End If

                    For Each approval In approvals
                        If approval.ActionRequested = Resources.Labels.Lbl_Validation_Text Then
                            approval.RowSelectionIndicator = 1
                        End If
                    Next
                Case Else
                    If approvalsPendingSave.Count > 0 Then
                        If (Not ViewState(APPROVALS_SORT_EXPRESSION) Is Nothing) Then
                            If ViewState(APPROVALS_SORT_DIRECTION) = SortConstants.Ascending Then
                                approvals = approvals.OrderBy(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            Else
                                approvals = approvals.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            End If
                        Else
                            approvals = approvals.OrderByDescending(Function(x) x.RowAction).ThenBy(Function(y) y.EIDSSReportSessionID).ToList()
                        End If
                    Else
                        If (Not ViewState(APPROVALS_SORT_EXPRESSION) Is Nothing) Then
                            If ViewState(APPROVALS_SORT_DIRECTION) = SortConstants.Ascending Then
                                approvals = approvals.OrderBy(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            Else
                                approvals = approvals.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(APPROVALS_SORT_EXPRESSION)).GetValue(x)).ToList()
                            End If
                        Else
                            approvals = approvals.OrderBy(Function(x) x.EIDSSReportSessionID).ToList()
                        End If
                    End If
            End Select

            If approvals.Where(Function(x) x.RowSelectionIndicator = 1).Count = 0 Then
                btnApprove.Enabled = False
                btnReject.Enabled = False
            Else
                btnApprove.Enabled = True
                btnReject.Enabled = True
            End If

            If approvalsPendingSave.Count = 0 Then
                btnApprovalsSave.Enabled = False
            Else
                btnApprovalsSave.Enabled = True
            End If

            gvApprovals.DataSource = approvals
            gvApprovals.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    ''' <param name="toggleIndicator"></param>
    Private Sub ToggleApprovals(sampleID As Long, toggleIndicator As Boolean)

        Try
            Dim approvals = CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel))
            If approvals Is Nothing Then
                approvals = New List(Of LabApprovalGetListModel)()
            End If

            If toggleIndicator = True Then
                approvals.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowSelectionIndicator = 1
            Else
                approvals.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().RowSelectionIndicator = 0
            End If

            Session(SESSION_APPROVALS_LIST) = approvals
            FillDropDowns()
            gvApprovals.PageIndex = lblApprovalsPageNumber.Text - 1
            BindApprovalsGridView()
            upApprovalsMenu.Update()
            upApprovalsButtons.Update()
            upApprovals.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Event handler for the approvals select/deselect all toggle event.
    ''' </summary>
    Private Sub ToggleAllApprovals(toggleIndicator As Boolean)

        Try
            Dim index As Integer = 0
            Dim approvals As List(Of LabApprovalGetListModel) = CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel))

            If toggleIndicator = True Then
                For Each approval In approvals
                    approvals(index).RowSelectionIndicator = 1
                    index += 1
                Next
            Else
                For Each approval In approvals
                    approvals(index).RowSelectionIndicator = 0
                    index += 1
                Next
            End If

            Session(SESSION_APPROVALS_LIST) = approvals
            FillDropDowns()
            gvApprovals.PageIndex = lblApprovalsPageNumber.Text - 1
            BindApprovalsGridView()
            upApprovalsButtons.Update()
            upApprovalsMenu.Update()
            upApprovals.Update()
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
    Protected Sub Approvals_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvApprovals.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True
                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelectAll
                        Dim btnToggleAllApprovals As LinkButton = CType(e.CommandSource, LinkButton)
                        Dim toggleIndicator As Boolean = False

                        If btnToggleAllApprovals.CssClass = CSS_BTN_GLYPHICON_UNCHECKED Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleAllApprovals(toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.ToggleSelect
                        Dim toggleIndicator As Boolean = False

                        If CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel)).Where(Function(x) x.SampleID = e.CommandArgument).FirstOrDefault().RowSelectionIndicator = 0 Then
                            toggleIndicator = True
                        Else
                            toggleIndicator = False
                        End If
                        ToggleApprovals(sampleID:=e.CommandArgument, toggleIndicator:=toggleIndicator)

                        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                    Case GridViewCommandConstants.EditCommand
                        hdfCurrentModuleAction.Value = LaboratoryModuleActions.EditSample.ToString()
                        InitializeControl(CType(e.CommandArgument, Long))
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Approvals_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvApprovals.Sorting

        Try
            ViewState(APPROVALS_SORT_DIRECTION) = IIf(ViewState(APPROVALS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(APPROVALS_SORT_EXPRESSION) = e.SortExpression

            FillDropDowns()

            BindApprovalsGridView()

            upApprovals.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Protected Sub Approvals_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvApprovals.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then
                Dim approvals = CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel))
                If Not approvals Is Nothing Then
                    Dim btnToggleAllApprovals As LinkButton = CType(e.Row.FindControl("btnToggleAllApprovals"), LinkButton)

                    If approvals.Where(Function(x) x.RowSelectionIndicator = 1).Count = approvals.Count And approvals.Count > 0 Then
                        btnToggleAllApprovals.CssClass = CSS_BTN_GLYPHICON_CHECKED
                    Else
                        btnToggleAllApprovals.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                    End If
                End If
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim approval As LabApprovalGetListModel = TryCast(e.Row.DataItem, LabApprovalGetListModel)
                    Dim i As Integer = 0

                    If Not approval Is Nothing Then
                        Dim btnToggleApprovals As LinkButton = CType(e.Row.FindControl("btnToggleApprovals"), LinkButton)
                        Dim lblResultDate As Label = CType(e.Row.FindControl("lblApprovalsResultDate"), Label)

                        If approval.RowSelectionIndicator = 0 Then
                            btnToggleApprovals.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                        Else
                            btnToggleApprovals.CssClass = CSS_BTN_GLYPHICON_CHECKED
                        End If

                        lblResultDate.Text = ToShortDate(lblResultDate.Text)

                        If approval.RowAction = String.Empty Then
                            e.Row.CssClass = CSS_NO_SAVE_PENDING
                        Else
                            e.Row.CssClass = CSS_SAVE_PENDING
                        End If
                    End If
                End If
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
    Protected Sub ApprovalsSave_Click(sender As Object, e As EventArgs) Handles btnApprovalsSave.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            AddUpdateLaboratory()

            upSuccessModal.Update()
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)

            FillDropDowns()
            FillTabCounts()
            FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
            BindApprovalsGridView()
            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
            BindMyFavoritesGridView()
            BindTestingGridView()

            upLaboratoryTabCounts.Update()
            upApprovals.Update()
            upApprovalsButtons.Update()
            upApprovalsSave.Update()
            upApprovalsMenu.Update()
            'VerifyUserPermissions(False)

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

#End Region

#Region "Approve Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Approve_Click(sender As Object, e As EventArgs) Handles btnApprove.Click

        Try
            Approve()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Approve()

        Try
            Dim index As Integer = 0
            Dim approvals As List(Of LabApprovalGetListModel) = CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel))
            Dim approvalsPendingSave = CType(Session(SESSION_APPROVALS_SAVE_LIST), List(Of LabApprovalGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim sample As LabSampleGetListModel
            Dim test As LabTestGetListModel

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
            End If

            If approvals Is Nothing Then
                approvals = New List(Of LabApprovalGetListModel)()
            End If

            If approvalsPendingSave Is Nothing Then
                approvalsPendingSave = New List(Of LabApprovalGetListModel)()
            End If

            For Each approval In approvals
                If approval.RowSelectionIndicator = 1 Then
                    Select Case approval.ActionRequested
                        Case Resources.Labels.Lbl_Sample_Deletion_Text
                            Dim samplesParameters = New LaboratorySampleGetListParameters With {.DaysFromAccessionDate = Integer.MinValue, .LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .SampleID = approval.SampleID, .UserID = hdfUserID.Value}
                            sample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters:=samplesParameters).Result.FirstOrDefault()
                            approval.SampleStatusTypeID = SampleStatusTypes.Deleted
                            approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                            approval.RowAction = RecordConstants.Update

                            sample.SampleStatusTypeID = SampleStatusTypes.Deleted
                            sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                            sample.RowAction = RecordConstants.Update

                            index = 0
                            If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                samplesPendingSave(index) = sample
                            Else
                                samplesPendingSave.Add(sample)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If
                        Case Resources.Labels.Lbl_Sample_Destruction_Text
                            Dim samplesParameters = New LaboratorySampleGetListParameters With {.DaysFromAccessionDate = Integer.MinValue, .LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .SampleID = approval.SampleID, .UserID = hdfUserID.Value}
                            sample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters:=samplesParameters).Result.FirstOrDefault()
                            approval.SampleStatusTypeID = SampleStatusTypes.Destroyed
                            approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Destroyed_Text
                            approval.RowAction = RecordConstants.Update

                            sample.SampleStatusTypeID = SampleStatusTypes.Destroyed
                            sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Destroyed_Text
                            sample.DestructionDate = Date.Now
                            sample.DestroyedByPersonID = hdfPersonID.Value
                            sample.RowAction = RecordConstants.Update

                            index = 0
                            If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                samplesPendingSave(index) = sample
                            Else
                                samplesPendingSave.Add(sample)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If
                        Case Resources.Labels.Lbl_Test_Deletion_Text
                            Dim testingParameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = approval.TestID, .SiteID = hdfSiteID.Value, .UserID = hdfUserID.Value}
                            test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=testingParameters).Result.FirstOrDefault()
                            approval.TestStatusTypeID = TestStatusTypes.Deleted
                            approval.TestStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                            approval.RowAction = RecordConstants.Update

                            test.TestStatusTypeID = TestStatusTypes.Deleted
                            test.TestStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                            test.RowAction = RecordConstants.Update

                            index = 0
                            If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                testsPendingSave(index) = test
                            Else
                                testsPendingSave.Add(test)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If
                        Case Resources.Labels.Lbl_Validation_Text
                            Dim testingParameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = approval.TestID, .SiteID = hdfSiteID.Value, .UserID = hdfUserID.Value}
                            test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=testingParameters).Result.FirstOrDefault()

                            approval.TestStatusTypeID = TestStatusTypes.Final
                            approval.TestStatusTypeName = Resources.Labels.Lbl_Final_Text
                            approval.ResultDate = Date.Now
                            approval.RowAction = RecordConstants.Update

                            test.TestStatusTypeID = TestStatusTypes.Final
                            test.TestStatusTypeName = Resources.Labels.Lbl_Final_Text
                            test.ResultDate = Date.Now
                            test.RowAction = RecordConstants.Update

                            index = 0
                            If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                testsPendingSave(index) = test
                            Else
                                testsPendingSave.Add(test)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If
                    End Select

                    index += 1
                End If
            Next

            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
            Session(SESSION_APPROVALS_SAVE_LIST) = approvalsPendingSave
            Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave

            FillDropDowns()
            BindApprovalsGridView()

            upApprovals.Update()
            upApprovalsButtons.Update()
            upApprovalsMenu.Update()
            upApprovalsSave.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Reject Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Reject_Click(sender As Object, e As EventArgs) Handles btnReject.Click

        Try
            Reject()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reject()

        Try
            Dim index As Integer = 0
            Dim approvals As List(Of LabApprovalGetListModel) = CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel))
            Dim approvalsPendingSave = CType(Session(SESSION_APPROVALS_SAVE_LIST), List(Of LabApprovalGetListModel))
            Dim samplesPendingSave = CType(Session(SESSION_SAMPLES_SAVE_LIST), List(Of LabSampleGetListModel))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim notificationsPendingSave = CType(Session(SESSION_NOTIFICATIONS_SAVE_LIST), List(Of NotificationSetParameters))
            Dim sample As LabSampleGetListModel
            Dim test As LabTestGetListModel

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            If samplesPendingSave Is Nothing Then
                samplesPendingSave = New List(Of LabSampleGetListModel)()
            End If

            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
            End If

            If notificationsPendingSave Is Nothing Then
                notificationsPendingSave = New List(Of NotificationSetParameters)()
            End If

            If approvalsPendingSave Is Nothing Then
                approvalsPendingSave = New List(Of LabApprovalGetListModel)()
            End If

            For Each approval In approvals
                If approval.RowSelectionIndicator = 1 Then
                    Select Case approval.ActionRequested
                        Case Resources.Labels.Lbl_Sample_Deletion_Text
                            Dim samplesParameters = New LaboratorySampleGetListParameters With {.DaysFromAccessionDate = Integer.MinValue, .LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .SampleID = approval.SampleID, .UserID = hdfUserID.Value}
                            sample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters:=samplesParameters).Result.FirstOrDefault()

                            If approval.PreviousSampleStatusTypeID Is Nothing Then
                                'Migrated record, set as default to in repository.
                                approval.SampleStatusTypeID = SampleStatusTypes.InRepository
                                sample.SampleStatusTypeID = SampleStatusTypes.InRepository
                            Else
                                approval.SampleStatusTypeID = approval.PreviousSampleStatusTypeID
                                sample.SampleStatusTypeID = sample.PreviousSampleStatusTypeID
                            End If

                            Select Case approval.SampleStatusTypeID
                                Case SampleStatusTypes.Deleted
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                Case SampleStatusTypes.Destroyed
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Destroyed_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Destroyed_Text
                                Case SampleStatusTypes.InRepository
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_In_Repository_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_In_Repository_Text
                                Case SampleStatusTypes.MarkedForDeletion
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                Case SampleStatusTypes.MarkedForDestruction
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Destruction_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Destruction_Text
                                Case SampleStatusTypes.TransferredOut
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Transferred_Out_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Transferred_Out_Text
                            End Select

                            approval.PreviousSampleStatusTypeID = Nothing
                            approval.RowAction = RecordConstants.Update

                            sample.PreviousSampleStatusTypeID = Nothing
                            sample.RowAction = RecordConstants.Update

                            index = 0
                            If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                samplesPendingSave(index) = sample
                            Else
                                samplesPendingSave.Add(sample)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If
                        Case Resources.Labels.Lbl_Sample_Destruction_Text
                            Dim samplesParameters = New LaboratorySampleGetListParameters With {.DaysFromAccessionDate = Integer.MinValue, .LanguageID = GetCurrentLanguage(), .OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .SampleID = approval.SampleID, .UserID = hdfUserID.Value}
                            sample = LaboratoryAPIService.LaboratorySampleGetListAsync(parameters:=samplesParameters).Result.FirstOrDefault()

                            If approval.PreviousSampleStatusTypeID Is Nothing Then
                                'Migrated record, set as default to in repository.
                                approval.SampleStatusTypeID = SampleStatusTypes.InRepository
                                sample.SampleStatusTypeID = SampleStatusTypes.InRepository
                            Else
                                approval.SampleStatusTypeID = approval.PreviousSampleStatusTypeID
                                sample.SampleStatusTypeID = sample.PreviousSampleStatusTypeID
                            End If

                            Select Case approval.SampleStatusTypeID
                                Case SampleStatusTypes.Deleted
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                Case SampleStatusTypes.Destroyed
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Destroyed_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Destroyed_Text
                                Case SampleStatusTypes.InRepository
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_In_Repository_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_In_Repository_Text
                                Case SampleStatusTypes.MarkedForDeletion
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                Case SampleStatusTypes.MarkedForDestruction
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Destruction_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Marked_For_Destruction_Text
                                Case SampleStatusTypes.TransferredOut
                                    approval.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Transferred_Out_Text
                                    sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Transferred_Out_Text
                            End Select

                            approval.PreviousSampleStatusTypeID = Nothing
                            approval.RowAction = RecordConstants.Update

                            sample.PreviousSampleStatusTypeID = Nothing
                            sample.RowAction = RecordConstants.Update

                            index = 0
                            If samplesPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = samplesPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                samplesPendingSave(index) = sample
                            Else
                                samplesPendingSave.Add(sample)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.SampleID = sample.SampleID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.SampleID = sample.SampleID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If
                        Case Resources.Labels.Lbl_Test_Deletion_Text
                            Dim testingParameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .TestID = approval.TestID, .SiteID = hdfSiteID.Value, .UserID = hdfUserID.Value}
                            test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=testingParameters).Result.FirstOrDefault()

                            If approval.PreviousTestStatusTypeID Is Nothing Then
                                'Migrated record, set as default to in progress.
                                approval.TestStatusTypeID = TestStatusTypes.InProgress
                                test.TestStatusTypeID = TestStatusTypes.InProgress
                            Else
                                approval.TestStatusTypeID = approval.PreviousTestStatusTypeID
                                test.TestStatusTypeID = test.PreviousTestStatusTypeID
                            End If

                            approval.PreviousTestStatusTypeID = Nothing
                            approval.RowAction = RecordConstants.Update

                            test.PreviousTestStatusTypeID = Nothing
                            test.RowAction = RecordConstants.Update

                            Select Case approval.TestStatusTypeID
                                Case TestStatusTypes.Amended
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Amended_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Amended_Text
                                Case TestStatusTypes.Declined
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Declined_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Declined_Text
                                Case TestStatusTypes.Deleted
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                Case TestStatusTypes.Final
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Final_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Final_Text
                                Case TestStatusTypes.InProgress
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                                Case TestStatusTypes.MarkedForDeletion
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                Case TestStatusTypes.NotStarted
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Not_Started_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Not_Started_Text
                                Case TestStatusTypes.Preliminary
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                            End Select

                            index = 0
                            If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                testsPendingSave(index) = test
                            Else
                                testsPendingSave.Add(test)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If
                        Case Resources.Labels.Lbl_Validation_Text
                            Dim testingParameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .SiteID = hdfSiteID.Value, .PaginationSetNumber = 1, .TestID = approval.TestID, .UserID = hdfUserID.Value}
                            test = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=testingParameters).Result.FirstOrDefault()

                            If approval.PreviousTestStatusTypeID Is Nothing Then
                                'Migrated record, set as default to in progress.
                                approval.TestStatusTypeID = TestStatusTypes.InProgress
                                test.TestStatusTypeID = TestStatusTypes.InProgress
                            Else
                                approval.TestStatusTypeID = approval.PreviousTestStatusTypeID
                                test.TestStatusTypeID = test.PreviousTestStatusTypeID
                            End If

                            approval.PreviousTestStatusTypeID = Nothing
                            approval.RowAction = RecordConstants.Update

                            test.PreviousTestStatusTypeID = Nothing
                            test.RowAction = RecordConstants.Update

                            Select Case approval.TestStatusTypeID
                                Case TestStatusTypes.Amended
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Amended_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Amended_Text
                                Case TestStatusTypes.Declined
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Declined_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Declined_Text
                                Case TestStatusTypes.Deleted
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Deleted_Text
                                Case TestStatusTypes.Final
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Final_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Final_Text
                                Case TestStatusTypes.InProgress
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                                Case TestStatusTypes.MarkedForDeletion
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Marked_For_Deletion_Text
                                Case TestStatusTypes.NotStarted
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Not_Started_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Not_Started_Text
                                Case TestStatusTypes.Preliminary
                                    approval.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                                    test.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                            End Select

                            index = 0
                            If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                testsPendingSave(index) = test
                            Else
                                testsPendingSave.Add(test)
                            End If

                            index = 0
                            If approvalsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                                index = approvalsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                                approvalsPendingSave(index) = approval
                            Else
                                approvalsPendingSave.Add(approval)
                            End If

                            Dim notification = New NotificationSetParameters With {
                                .LanguageID = GetCurrentLanguage(),
                                .NotificationID = (notificationsPendingSave.Count + 1) * -1,
                                .TargetUserID = test.ResultEnteredByPersonUserID,
                                .TargetSiteID = test.ResultEnteredByPersonSiteID,
                                .TargetSiteTypeID = test.ResultEnteredByPersonSiteTypeID,
                                .NotificationTypeID = NotificationTypes.LaboratoryTestResultRejected,
                                .Payload = GetLocalResourceObject("Notification_Message_Test_Result_Rejected_Part_1") & test.TestResultTypeName & " " & test.TestNameTypeName & " " &
                                GetLocalResourceObject("Notification_Message_Test_Result_Rejected_Part_2") & test.ResultDate & " " &
                                GetLocalResourceObject("Notification_Message_Test_Result_Rejected_Part_3") & test.EIDSSLaboratorySampleID & " " &
                                GetLocalResourceObject("Notification_Message_Test_Result_Rejected_Part_4"),
                                .SiteID = hdfSiteID.Value,
                                .UserID = hdfUserID.Value,
                                .NotificationObjectID = test.TestID
                            }

                            notificationsPendingSave.Add(notification)
                    End Select
                End If
            Next

            Session(SESSION_SAMPLES_SAVE_LIST) = samplesPendingSave
            Session(SESSION_APPROVALS_SAVE_LIST) = approvalsPendingSave
            Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
            Session(SESSION_NOTIFICATIONS_SAVE_LIST) = notificationsPendingSave

            FillDropDowns()
            BindApprovalsGridView()

            upApprovals.Update()
            upApprovalsButtons.Update()
            upApprovalsMenu.Update()
            upApprovalsSave.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Search Sample Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestNotAssigned_CheckedChanged(sender As Object, e As EventArgs) Handles chkTestNotAssigned.CheckedChanged

        Try
            If chkTestComplete.Checked = True Then
                chkTestComplete.Checked = False

                Session(SESSION_SAMPLES_LIST) = Session(SESSION_SAMPLES_FILTER_LIST)
                Session(SESSION_SAMPLES_FILTER_LIST) = Nothing
            End If

            If chkTestNotAssigned.Checked = False Then
                Session(SESSION_SAMPLES_LIST) = Session(SESSION_SAMPLES_FILTER_LIST)
                Session(SESSION_SAMPLES_FILTER_LIST) = Nothing

                hdfSamplesCount.Value = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel)).Count()
            Else
                Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                samples = samples.Where(Function(x) x.TestAssignedIndicator = 0 And Not x.AccessionConditionTypeID Is Nothing).ToList()
                samples = samples.Where(Function(x) x.AccessionConditionTypeID = AccessionConditionTypes.AcceptedInGoodCondition Or x.AccessionConditionTypeID = AccessionConditionTypes.AcceptedInPoorCondition).ToList()

                Session(SESSION_SAMPLES_FILTER_LIST) = Session(SESSION_SAMPLES_LIST)
                Session(SESSION_SAMPLES_LIST) = samples.ToList()

                hdfSamplesCount.Value = samples.Count
            End If

            FillDropDowns()
            gvSamples.PageIndex = 0
            lblSamplesPageNumber.Text = 1
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)
            upSamples.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
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
    Protected Sub TestComplete_CheckedChanged(sender As Object, e As EventArgs) Handles chkTestComplete.CheckedChanged

        Try
            hdfAccessionedIndicator.Value = "1"

            If chkTestNotAssigned.Checked = True Then
                chkTestNotAssigned.Checked = False

                Session(SESSION_SAMPLES_LIST) = Session(SESSION_SAMPLES_FILTER_LIST)
                Session(SESSION_SAMPLES_FILTER_LIST) = Nothing
            End If

            If chkTestComplete.Checked = False Then
                Session(SESSION_SAMPLES_LIST) = Session(SESSION_SAMPLES_FILTER_LIST)
                Session(SESSION_SAMPLES_FILTER_LIST) = Nothing

                hdfSamplesCount.Value = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel)).Count()
            Else
                Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel))
                samples = samples.Where(Function(x) x.TestCompletedIndicator = 1).ToList()

                Session(SESSION_SAMPLES_FILTER_LIST) = Session(SESSION_SAMPLES_LIST)
                Session(SESSION_SAMPLES_LIST) = samples.ToList()

                hdfSamplesCount.Value = samples.Count
            End If

            FillDropDowns()
            gvSamples.PageIndex = 0
            lblSamplesPageNumber.Text = 1
            BindSamplesGridView()
            FillSamplesPager(hdfSamplesCount.Value, 1)
            upSamplesFilter.Update()
            upSamples.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    Protected Sub AdvancedSearch_UpdateSamplesSearchResults(samples As List(Of LabSampleAdvancedSearchGetListModel), resultCount As Integer) Handles ucSearchSample.UpdateSamplesSearchResults

        upSamplesButtons.Update()
        upLaboratoryTabCounts.Update()
        upSamples.Update()
        upSamplesSearchResults.Update()
        hdgSamplesSearchResults.Visible = True

        Session(SESSION_SAMPLES_LIST) = ConvertSampleAdvancedSearch(samples)
        hdfSamplesCount.Value = resultCount
        lblSamplesCount.Text = resultCount 'TODO: Change to the unaccessioned count, stored procedure updates needed.

        FillDropDowns()
        FillSamplesPager(hdfSamplesCount.Value, 1)
        ViewState(SAMPLES_PAGINATION_SET_NUMBER) = 1
        lblSamplesPageNumber.Text = 1
        gvSamples.PageIndex = 0
        BindSamplesGridView()
        FillSamplesPager(hdfSamplesCount.Value, 1)

        hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchSampleModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    Protected Sub AdvancedSearch_UpdateTestingSearchResults(tests As List(Of LabTestAdvancedSearchGetListModel), resultCount As Integer) Handles ucSearchSample.UpdateTestingSearchResults

        upTestingButtons.Update()
        upLaboratoryTabCounts.Update()
        upTesting.Update()
        upTestingSearchResults.Update()
        hdgTestingSearchResults.Visible = True

        Session(SESSION_TESTING_LIST) = ConvertTestAdvancedSearch(tests)
        hdfTestingCount.Value = resultCount
        lblTestingCount.Text = resultCount

        FillDropDowns()
        FillTestingPager(hdfTestingCount.Value, 1)
        ViewState(TESTING_PAGINATION_SET_NUMBER) = 1
        lblTestingPageNumber.Text = 1
        gvTesting.PageIndex = 0
        BindTestingGridView()

        hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchSampleModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transfers"></param>
    Protected Sub AdvancedSearch_UpdateTransferredSearchResults(transfers As List(Of LabTransferAdvancedSearchGetListModel), resultCount As Integer) Handles ucSearchSample.UpdateTransferredSearchResults

        upTransferredButtons.Update()
        upLaboratoryTabCounts.Update()
        upTransferred.Update()
        upTransferredSearchResults.Update()
        hdgTransferredSearchResults.Visible = True

        Session(SESSION_TRANSFERRED_LIST) = ConvertTransferAdvancedSearch(transfers)
        hdfTestingCount.Value = resultCount
        lblTestingCount.Text = resultCount

        FillDropDowns()
        FillTransferredPager(lblTransferredCount.Text, 1)
        ViewState(TRANSFERRED_PAGINATION_SET_NUMBER) = 1
        lblTransferredPageNumber.Text = 1
        gvTransferred.PageIndex = 0
        BindTransferredGridView()

        hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchSampleModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="myFavorites"></param>
    Protected Sub AdvancedSearch_UpdateMyFavoritesSearchResults(myFavorites As List(Of LabFavoriteAdvancedSearchGetListModel), resultCount As Integer) Handles ucSearchSample.UpdateMyFavoritesSearchResults

        upMyFavoritesButtons.Update()
        upLaboratoryTabCounts.Update()
        upMyFavorites.Update()
        upMyFavoritesSearchResults.Update()
        hdgMyFavoritesSearchResults.Visible = True

        Session(SESSION_FAVORITES_LIST) = ConvertMyFavoriteAdvancedSearch(myFavorites)
        lblMyFavoritesCount.Text = resultCount

        FillDropDowns()
        FillMyFavoritesPager(lblMyFavoritesCount.Text, 1)
        ViewState(MY_FAVORITES_PAGINATION_SET_NUMBER) = 1
        lblMyFavoritesPageNumber.Text = 1
        gvMyFavorites.PageIndex = 0
        BindMyFavoritesGridView()

        hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchSampleModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="batches"></param>
    ''' <param name="resultCount"></param>
    Protected Sub AdvancedSearch_UpdateBatchesSearchResults(batches As List(Of LabBatchAdvancedSearchGetListModel), resultCount As Integer) Handles ucSearchSample.UpdateBatchesSearchResults

        upBatchesButtons.Update()
        upLaboratoryTabCounts.Update()
        upBatches.Update()
        upBatchesSearchResults.Update()
        hdgBatchesSearchResults.Visible = True

        Session(SESSION_BATCHES_LIST) = ConvertBatchAdvancedSearch(batches)
        hdfBatchesCount.Value = resultCount
        lblBatchesCount.Text = resultCount

        FillDropDowns()
        FillBatchesPager(hdfTestingCount.Value, 1)
        ViewState(BATCHES_PAGINATION_SET_NUMBER) = 1
        lblBatchesPageNumber.Text = 1
        gvBatches.PageIndex = 0
        BindBatchesGridView()

        hdfAdvancedSearchIndicator.Value = YesNoUnknown.Yes

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchSampleModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub LaboratorySearch_ShowAdvancedSearch() Handles ucSamplesSearch.ShowAdvancedSearch, ucTestingSearch.ShowAdvancedSearch, ucTransferredSearch.ShowAdvancedSearch,
            ucMyFavoritesSearch.ShowAdvancedSearch, ucApprovalsSearch.ShowAdvancedSearch, ucBatchesSearch.ShowAdvancedSearch

        Try
            ucSearchSample.Setup(hdfUserID.Value, hdfCurrentTab.Value)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SampleSearch_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchSample.ShowWarningModal

        Try
            hdfCurrentModuleAction.Value = LaboratoryModuleActions.AdvancedSearch
            ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="query"></param>
    Protected Sub SamplesSearch_UpdateSamplesSearchResults(samples As List(Of LabSampleSearchGetListModel), resultCount As String, query As String) Handles ucSamplesSearch.UpdateSamplesSearchResults

        Try
            UpdateSamplesSearchResults(samples, resultCount, query)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <param name="query"></param>
    Protected Sub TestingSearch_UpdateTestingSearchResults(tests As List(Of LabTestSearchGetListModel), resultCount As String, query As String) Handles ucTestingSearch.UpdateTestingSearchResults

        Try
            UpdateTestingSearchResults(tests, resultCount, query)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transfers"></param>
    ''' <param name="query"></param>
    Protected Sub TransferredSearch_UpdateTransferredSearchResults(transfers As List(Of LabTransferSearchGetListModel), resultCount As String, query As String) Handles ucTransferredSearch.UpdateTransferredSearchResults

        Try
            UpdateTransferredSearchResults(transfers, resultCount, query)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="myFavorites"></param>
    ''' <param name="query"></param>
    Protected Sub MyFavoritesSearch_UpdateMyFavoritesSearchResults(myFavorites As List(Of LabFavoriteSearchGetListModel), resultCount As String, query As String) Handles ucMyFavoritesSearch.UpdateMyFavoritesSearchResults

        Try
            UpdateMyFavoritesSearchResults(myFavorites, resultCount, query)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="resultCount"></param>
    ''' <param name="query"></param>
    Protected Sub BatchesSearch_UpdateSearchResults(samples As List(Of LabTestAdvancedSearchGetListModel), resultCount As String, query As String) Handles ucBatchesSearch.UpdateBatchesSearchResults

        Try
            UpdateBatchesSearchResults(samples, resultCount, query)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="approvals"></param>
    ''' <param name="query"></param>
    Protected Sub ApprovalsSearch_UpdateApprovalsSearchResults(approvals As List(Of LabApprovalSearchGetListModel), resultCount As String, query As String) Handles ucApprovalsSearch.UpdateApprovalsSearchResults

        Try
            UpdateApprovalsSearchResults(approvals, resultCount, query)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="resultCount"></param>
    ''' <param name="query"></param>
    Private Sub UpdateSamplesSearchResults(samples As List(Of LabSampleSearchGetListModel), resultCount As String, query As String)

        Try
            upSamplesButtons.Update()
            upLaboratoryTabCounts.Update()
            upSamples.Update()
            upSamplesSearchResults.Update()
            upTestingSearchResults.Update()
            upTransferredSearchResults.Update()
            upMyFavoritesSearchResults.Update()
            upApprovalsSearchResults.Update()

            hdgApprovalsQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgMyFavoritesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgSamplesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTestingQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTransferredQueryText.InnerText = Chr(34) & query & Chr(34)

            FillDropDowns()

            Session(SESSION_SAMPLES_FILTER_LIST) = Session(SESSION_SAMPLES_LIST)
            Session(SESSION_SAMPLES_LIST) = ConvertSampleSearch(samples)
            hdfSamplesCount.Value = resultCount
            lblSamplesCount.Text = resultCount

            If query = String.Empty Then
                hdgSamplesQueryText.Visible = False
                hdgSamplesSearchResults.Visible = False
                hdgTestingQueryText.Visible = False
                hdgTestingSearchResults.Visible = False
                hdgTransferredQueryText.Visible = False
                hdgTransferredSearchResults.Visible = False
                hdgMyFavoritesQueryText.Visible = False
                hdgMyFavoritesSearchResults.Visible = False
                hdgBatchesSearchResults.Visible = False
                hdgBatchesQueryText.Visible = False
                hdgApprovalsQueryText.Visible = False
                hdgApprovalsSearchResults.Visible = False

                ucTestingSearch.SetSearchString(query)
                ucTransferredSearch.SetSearchString(query)
                ucMyFavoritesSearch.SetSearchString(query)
                ucApprovalsSearch.SetSearchString(query)

                Session(SESSION_SAMPLES_LIST) = Session(SESSION_SAMPLES_FILTER_LIST)
                Session(SESSION_SAMPLES_FILTER_LIST) = Nothing
                FillSamplesList(pageIndex:=1, paginationSetNumber:=1)
                gvSamples.PageIndex = 0
                lblSamplesPageNumber.Text = 1
                BindSamplesGridView()
                FillSamplesPager(hdfSamplesCount.Value, 1)

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, RESET_SEARCH, True)
            Else
                hdgSamplesQueryText.Visible = True
                hdgSamplesSearchResults.Visible = True
                hdgTestingQueryText.Visible = True
                hdgTestingSearchResults.Visible = True
                hdgTransferredQueryText.Visible = True
                hdgTransferredSearchResults.Visible = True
                hdgMyFavoritesQueryText.Visible = True
                hdgMyFavoritesSearchResults.Visible = True
                hdgApprovalsQueryText.Visible = True
                hdgApprovalsSearchResults.Visible = True

                gvSamples.PageIndex = 0
                lblSamplesPageNumber.Text = 1
                BindSamplesGridView()
                FillSamplesPager(hdfSamplesCount.Value, 1)

                RaiseEvent TabItemSelected("TabGetSamplesData")
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_RESULTS, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <param name="resultCount"></param>
    ''' <param name="query"></param>
    Private Sub UpdateTestingSearchResults(tests As List(Of LabTestSearchGetListModel), resultCount As String, query As String)

        Try
            upTestingButtons.Update()
            upLaboratoryTabCounts.Update()
            upTesting.Update()
            upTestingSearchResults.Update()
            upSamplesSearchResults.Update()
            upTransferredSearchResults.Update()
            upMyFavoritesSearchResults.Update()
            upApprovalsSearchResults.Update()

            hdgApprovalsQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgMyFavoritesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgSamplesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTestingQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTransferredQueryText.InnerText = Chr(34) & query & Chr(34)

            ucSamplesSearch.SetSearchString(query)
            ucTransferredSearch.SetSearchString(query)
            ucMyFavoritesSearch.SetSearchString(query)
            ucApprovalsSearch.SetSearchString(query)

            FillDropDowns()

            Session(SESSION_TESTING_LIST) = ConvertTestSearch(tests)
            hdfTestingCount.Value = resultCount
            lblTestingCount.Text = resultCount

            If query = String.Empty Then
                hdgSamplesQueryText.Visible = False
                hdgSamplesSearchResults.Visible = False
                hdgTestingQueryText.Visible = False
                hdgTestingSearchResults.Visible = False
                hdgTransferredQueryText.Visible = False
                hdgTransferredSearchResults.Visible = False
                hdgMyFavoritesQueryText.Visible = False
                hdgMyFavoritesSearchResults.Visible = False
                hdgBatchesSearchResults.Visible = False
                hdgBatchesQueryText.Visible = False
                hdgApprovalsQueryText.Visible = False
                hdgApprovalsSearchResults.Visible = False

                FillTestingList(pageIndex:=1, paginationSetNumber:=1)
                gvTesting.PageIndex = 0
                lblTestingPageNumber.Text = 1
                BindTestingGridView()
                FillTestingPager(hdfTestingCount.Value, 1)

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, RESET_SEARCH, True)
            Else
                hdgSamplesQueryText.Visible = True
                hdgSamplesSearchResults.Visible = True
                hdgTestingQueryText.Visible = True
                hdgTestingSearchResults.Visible = True
                hdgTransferredQueryText.Visible = True
                hdgTransferredSearchResults.Visible = True
                hdgMyFavoritesQueryText.Visible = True
                hdgMyFavoritesSearchResults.Visible = True
                hdgApprovalsQueryText.Visible = True
                hdgApprovalsSearchResults.Visible = True

                gvTesting.PageIndex = 0
                lblTestingPageNumber.Text = 1
                BindTestingGridView()
                FillTestingPager(hdfTestingCount.Value, 1)

                RaiseEvent TabItemSelected(hdfCurrentTab.Value)
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_RESULTS, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transfers"></param>
    ''' <param name="resultCount"></param>
    ''' <param name="query"></param>
    Private Sub UpdateTransferredSearchResults(transfers As List(Of LabTransferSearchGetListModel), resultCount As String, query As String)

        Try
            upTransferredButtons.Update()
            upLaboratoryTabCounts.Update()
            upTransferred.Update()
            upTransferredSearchResults.Update()
            upTestingSearchResults.Update()
            upSamplesSearchResults.Update()
            upMyFavoritesSearchResults.Update()
            upApprovalsSearchResults.Update()

            hdgApprovalsQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgMyFavoritesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgSamplesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTestingQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTransferredQueryText.InnerText = Chr(34) & query & Chr(34)

            ucSamplesSearch.SetSearchString(query)
            ucTestingSearch.SetSearchString(query)
            ucMyFavoritesSearch.SetSearchString(query)
            ucApprovalsSearch.SetSearchString(query)

            FillDropDowns()

            Session(SESSION_TRANSFERRED_LIST) = ConvertTransferSearch(transfers)
            lblTransferredCount.Text = resultCount

            If query = String.Empty Then
                hdgSamplesQueryText.Visible = False
                hdgSamplesSearchResults.Visible = False
                hdgTestingQueryText.Visible = False
                hdgTestingSearchResults.Visible = False
                hdgTransferredQueryText.Visible = False
                hdgTransferredSearchResults.Visible = False
                hdgMyFavoritesQueryText.Visible = False
                hdgMyFavoritesSearchResults.Visible = False
                hdgBatchesSearchResults.Visible = False
                hdgBatchesQueryText.Visible = False
                hdgApprovalsQueryText.Visible = False
                hdgApprovalsSearchResults.Visible = False

                FillTransferredList(pageIndex:=1, paginationSetNumber:=1)
                gvTransferred.PageIndex = 0
                lblTransferredPageNumber.Text = 1
                BindTransferredGridView()
                FillTransferredPager(lblTransferredCount.Text, 1)

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, RESET_SEARCH, True)
            Else
                hdgSamplesQueryText.Visible = True
                hdgSamplesSearchResults.Visible = True
                hdgTestingQueryText.Visible = True
                hdgTestingSearchResults.Visible = True
                hdgTransferredQueryText.Visible = True
                hdgTransferredSearchResults.Visible = True
                hdgMyFavoritesQueryText.Visible = True
                hdgMyFavoritesSearchResults.Visible = True
                hdgApprovalsQueryText.Visible = True
                hdgApprovalsSearchResults.Visible = True

                gvTransferred.PageIndex = 0
                lblTransferredPageNumber.Text = 1
                BindTransferredGridView()
                FillTransferredPager(lblTransferredCount.Text, 1)

                RaiseEvent TabItemSelected("TabGetTransferredData")
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_RESULTS, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="myFavorites"></param>
    ''' <param name="resultCount"></param>
    ''' <param name="query"></param>
    Private Sub UpdateMyFavoritesSearchResults(myFavorites As List(Of LabFavoriteSearchGetListModel), resultCount As String, query As String)

        Try
            upMyFavoritesButtons.Update()
            upLaboratoryTabCounts.Update()
            upMyFavorites.Update()
            upMyFavoritesSearchResults.Update()
            upTestingSearchResults.Update()
            upTransferredSearchResults.Update()
            upSamplesSearchResults.Update()
            upApprovalsSearchResults.Update()

            hdgApprovalsQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgMyFavoritesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgSamplesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTestingQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTransferredQueryText.InnerText = Chr(34) & query & Chr(34)

            ucSamplesSearch.SetSearchString(query)
            ucTransferredSearch.SetSearchString(query)
            ucTestingSearch.SetSearchString(query)
            ucApprovalsSearch.SetSearchString(query)

            FillDropDowns()

            Session(SESSION_FAVORITES_LIST) = ConvertMyFavoriteSearch(myFavorites)
            lblMyFavoritesCount.Text = resultCount

            If query = String.Empty Then
                hdgSamplesQueryText.Visible = False
                hdgSamplesSearchResults.Visible = False
                hdgTestingQueryText.Visible = False
                hdgTestingSearchResults.Visible = False
                hdgTransferredQueryText.Visible = False
                hdgTransferredSearchResults.Visible = False
                hdgMyFavoritesQueryText.Visible = False
                hdgMyFavoritesSearchResults.Visible = False
                hdgBatchesSearchResults.Visible = False
                hdgBatchesQueryText.Visible = False
                hdgApprovalsQueryText.Visible = False
                hdgApprovalsSearchResults.Visible = False

                FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                gvMyFavorites.PageIndex = 0
                lblMyFavoritesPageNumber.Text = 1
                BindMyFavoritesGridView()
                FillMyFavoritesPager(lblMyFavoritesCount.Text, 1)

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, RESET_SEARCH, True)
            Else
                hdgSamplesQueryText.Visible = True
                hdgSamplesSearchResults.Visible = True
                hdgTestingQueryText.Visible = True
                hdgTestingSearchResults.Visible = True
                hdgTransferredQueryText.Visible = True
                hdgTransferredSearchResults.Visible = True
                hdgMyFavoritesQueryText.Visible = True
                hdgMyFavoritesSearchResults.Visible = True
                hdgApprovalsQueryText.Visible = True
                hdgApprovalsSearchResults.Visible = True

                gvMyFavorites.PageIndex = 0
                lblMyFavoritesPageNumber.Text = 1
                BindMyFavoritesGridView()
                FillMyFavoritesPager(lblMyFavoritesCount.Text, 1)

                RaiseEvent TabItemSelected("TabGetMyFavoritesData")
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_RESULTS, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tests"></param>
    ''' <param name="resultCount"></param>
    ''' <param name="query"></param>
    Private Sub UpdateBatchesSearchResults(tests As List(Of LabTestAdvancedSearchGetListModel), resultCount As String, query As String)

        Try
            upBatchSelectSamples.Update()

            gvBatchSelectSamples.DataSource = tests
            gvBatchSelectSamples.DataBind()
            Session(SESSION_BATCH_SELECT_SAMPLES) = tests
            Session(SESSION_BATCH_SELECT_SAMPLES_SAVE) = New List(Of LabTestAdvancedSearchGetListModel)()
            ViewState(BATCH_SELECT_SAMPLES_PAGINATION_SET_NUMBER) = 1

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divBatchSelectSamplesModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="approvals"></param>
    ''' <param name="resultCount"></param>
    ''' <param name="query"></param>
    Private Sub UpdateApprovalsSearchResults(approvals As List(Of LabApprovalSearchGetListModel), resultCount As String, query As String)

        Try
            upApprovalsButtons.Update()
            upLaboratoryTabCounts.Update()
            upApprovals.Update()
            upApprovalsSearchResults.Update()
            upTestingSearchResults.Update()
            upTransferredSearchResults.Update()
            upMyFavoritesSearchResults.Update()
            upSamplesSearchResults.Update()

            hdgApprovalsQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgMyFavoritesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgSamplesQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTestingQueryText.InnerText = Chr(34) & query & Chr(34)
            hdgTransferredQueryText.InnerText = Chr(34) & query & Chr(34)

            ucSamplesSearch.SetSearchString(query)
            ucTransferredSearch.SetSearchString(query)
            ucMyFavoritesSearch.SetSearchString(query)
            ucTestingSearch.SetSearchString(query)

            FillDropDowns()

            Session(SESSION_APPROVALS_LIST) = ConvertApprovalSearch(approvals)
            lblApprovalsCount.Text = resultCount

            If query = String.Empty Then
                hdgSamplesQueryText.Visible = False
                hdgSamplesSearchResults.Visible = False
                hdgTestingQueryText.Visible = False
                hdgTestingSearchResults.Visible = False
                hdgTransferredQueryText.Visible = False
                hdgTransferredSearchResults.Visible = False
                hdgMyFavoritesQueryText.Visible = False
                hdgMyFavoritesSearchResults.Visible = False
                hdgBatchesSearchResults.Visible = False
                hdgBatchesQueryText.Visible = False
                hdgApprovalsQueryText.Visible = False
                hdgApprovalsSearchResults.Visible = False

                FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
                gvApprovals.PageIndex = 0
                lblApprovalsPageNumber.Text = 1
                BindApprovalsGridView()
                FillApprovalsPager(lblApprovalsCount.Text, 1)

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, RESET_SEARCH, True)
            Else
                hdgSamplesQueryText.Visible = True
                hdgSamplesSearchResults.Visible = True
                hdgTestingQueryText.Visible = True
                hdgTestingSearchResults.Visible = True
                hdgTransferredQueryText.Visible = True
                hdgTransferredSearchResults.Visible = True
                hdgMyFavoritesQueryText.Visible = True
                hdgMyFavoritesSearchResults.Visible = True
                hdgApprovalsQueryText.Visible = True
                hdgApprovalsSearchResults.Visible = True

                gvApprovals.PageIndex = 0
                lblApprovalsPageNumber.Text = 1
                BindApprovalsGridView()
                FillApprovalsPager(lblApprovalsCount.Text, 1)

                RaiseEvent TabItemSelected("TabGetApprovalsData")
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_RESULTS, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub SamplesSearch_ClearSearch() Handles ucSamplesSearch.ClearSearch

        Try
            upSamplesButtons.Update()
            upLaboratoryTabCounts.Update()
            upSamples.Update()

            Session(SESSION_SAMPLES_LIST) = Nothing

            ClearSearch()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub TestingSearch_ClearSearch() Handles ucTestingSearch.ClearSearch

        Try
            upTestingButtons.Update()
            upLaboratoryTabCounts.Update()
            upTesting.Update()

            Session(SESSION_TESTING_LIST) = Nothing

            ClearSearch()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub TransferredSearch_ClearSearch() Handles ucTransferredSearch.ClearSearch

        Try
            upTransferredButtons.Update()
            upLaboratoryTabCounts.Update()
            upTransferred.Update()

            Session(SESSION_TRANSFERRED_LIST) = Nothing

            ClearSearch()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub MyFavoritesSearch_ClearSearch() Handles ucMyFavoritesSearch.ClearSearch

        Try
            upMyFavoritesButtons.Update()
            upLaboratoryTabCounts.Update()
            upMyFavorites.Update()

            Session(SESSION_FAVORITES_LIST) = Nothing

            ClearSearch()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub ApprovalsSearch_ClearSearch() Handles ucApprovalsSearch.ClearSearch

        Try
            upApprovalsButtons.Update()
            upLaboratoryTabCounts.Update()
            upApprovals.Update()

            Session(SESSION_APPROVALS_LIST) = Nothing

            ClearSearch()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ClearSearch()

        Try
            hdgSamplesQueryText.Visible = False
            hdgSamplesSearchResults.Visible = False
            hdgTestingQueryText.Visible = False
            hdgTestingSearchResults.Visible = False
            hdgTransferredQueryText.Visible = False
            hdgTransferredSearchResults.Visible = False
            hdgMyFavoritesQueryText.Visible = False
            hdgMyFavoritesSearchResults.Visible = False
            hdgBatchesSearchResults.Visible = False
            hdgBatchesQueryText.Visible = False
            hdgApprovalsQueryText.Visible = False
            hdgApprovalsSearchResults.Visible = False

            hdgApprovalsQueryText.InnerText = String.Empty
            hdgBatchesQueryText.InnerText = String.Empty
            hdgMyFavoritesQueryText.InnerText = String.Empty
            hdgSamplesQueryText.InnerText = String.Empty
            hdgTestingQueryText.InnerText = String.Empty
            hdgTransferredQueryText.InnerText = String.Empty

            ucApprovalsSearch.SetSearchString(String.Empty)
            ucBatchesSearch.SetSearchString(String.Empty)
            ucMyFavoritesSearch.SetSearchString(String.Empty)
            ucSamplesSearch.SetSearchString(String.Empty)
            ucTestingSearch.SetSearchString(String.Empty)
            ucTransferredSearch.SetSearchString(String.Empty)

            upApprovalsSearchResults.Update()
            upBatchesSearchResults.Update()
            upTestingSearchResults.Update()
            upTransferredSearchResults.Update()
            upMyFavoritesSearchResults.Update()
            upSamplesSearchResults.Update()

            FillDropDowns()

            RaiseEvent TabItemSelected(hdfCurrentTab.Value)

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Add Sample/Test to Batch"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindBatchSelectSamplesGridView()

        Dim list As List(Of LabTestAdvancedSearchGetListModel) = CType(Session(SESSION_BATCH_SELECT_SAMPLES), List(Of LabTestAdvancedSearchGetListModel))

        gvBatchSelectSamples.DataSource = list
        gvBatchSelectSamples.DataBind()
        gvBatchSelectSamples.PageIndex = 0

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub BatchSelectSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvBatchSelectSamples.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.ToggleSelect
                    e.Handled = True
                    Dim gvr As GridViewRow = CType(((CType(e.CommandSource, LinkButton)).NamingContainer), GridViewRow)
                    Dim btnBatchTest As LinkButton = CType(e.CommandSource, LinkButton)
                    Dim tests As List(Of LabTestAdvancedSearchGetListModel) = CType(Session(SESSION_BATCH_SELECT_SAMPLES), List(Of LabTestAdvancedSearchGetListModel))
                    Dim saveTests As List(Of LabTestAdvancedSearchGetListModel) = CType(Session(SESSION_BATCH_SELECT_SAMPLES_SAVE), List(Of LabTestAdvancedSearchGetListModel))
                    Dim testID As Long = btnBatchTest.CommandArgument
                    If btnBatchTest.CssClass = "btn glyphicon glyphicon-check" Then
                        tests.Where(Function(x) x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 0
                        saveTests.Add(tests.Where(Function(x) x.TestID = testID).FirstOrDefault())
                    Else
                        tests.Where(Function(x) x.TestID = testID).FirstOrDefault().RowSelectionIndicator = 1
                        saveTests.Add(tests.Where(Function(x) x.TestID = testID).FirstOrDefault())
                    End If

                    Session(SESSION_BATCH_SELECT_SAMPLES) = tests
                    Session(SESSION_BATCH_SELECT_SAMPLES_SAVE) = saveTests
            End Select

            BindBatchSelectSamplesGridView()

            btnBatchSelectSamplesAdd.Enabled = True
            upBatchSelectSamples.Update()
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
    Protected Sub BatchSelectSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvBatchSelectSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim test As LabTestAdvancedSearchGetListModel = TryCast(e.Row.DataItem, LabTestAdvancedSearchGetListModel)
                Dim i As Integer = 0

                If Not test Is Nothing Then
                    Dim btnBatchSample As LinkButton = CType(e.Row.FindControl("btnBatchSample"), LinkButton)

                    If test.RowSelectionIndicator = 0 Then
                        btnBatchSample.CssClass = "btn glyphicon glyphicon-unchecked"
                    Else
                        btnBatchSample.CssClass = "btn glyphicon glyphicon-check"
                    End If
                End If
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
    Protected Sub BatchSelectSamplesAdd_Click(sender As Object, e As EventArgs) Handles btnBatchSelectSamplesAdd.Click

        Try
            GetUserProfile()

            Dim selectedTests = ConvertTestAdvancedSearch(CType(Session(SESSION_BATCH_SELECT_SAMPLES_SAVE), List(Of LabTestAdvancedSearchGetListModel)))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim index As Integer = 0

            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
            End If

            If hdfBatchTestID.Value.IsValueNullOrEmpty = False Then
                For Each test In selectedTests
                    test.BatchTestID = hdfBatchTestID.Value
                    test.StartedDate = Date.Today
                    test.RowAction = RecordConstants.Update

                    If testsPendingSave.Where(Function(x) x.TestID = test.TestID).Count() > 0 Then
                        index = testsPendingSave.FindIndex(Function(x) x.TestID = test.TestID)
                        testsPendingSave(index) = test
                    Else
                        testsPendingSave.Add(test)
                    End If
                Next

                Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave

                AddUpdateLaboratory()

                Session.Remove(SESSION_BATCH_SELECT_SAMPLES_SAVE)

                Session(SESSION_TESTING_SAVE_LIST) = New List(Of LabTestGetListModel)()

                FillDropDowns()

                FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
                BindBatchesGridView()

                FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                BindMyFavoritesGridView()

                Dim testingParameters = New LaboratoryTestGetListParameters With {.PaginationSetNumber = 1, .OrganizationID = hdfOrganizationID.Value, .UserID = hdfUserID.Value}
                Dim testingCounts = LaboratoryAPIService.LaboratoryTestGetListCountAsync(testingParameters).Result
                lblTestingCount.Text = testingCounts(0).RecordCount
                lblTestingPageNumber.Text = 1
                gvTesting.PageIndex = 0
                FillTestingList(pageIndex:=1, paginationSetNumber:=1)
                BindTestingGridView()

                FillTabCounts()

                upLaboratoryTabCounts.Update()

                hdfBatchTestID.Value = String.Empty
                ucBatchesSearch.DisableEnableForBatchTestSelectSample(False)

                upLaboratoryTabCounts.Update()
                upBatchesSearch.Update()
            End If

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divBatchSelectSamplesModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Add Group Result Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub AddGroupResultTestResultType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlAddGroupResultTestResultType.SelectedIndexChanged

        Try
            Dim batches = CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel))
            Dim batchesPendingSave = CType(Session(SESSION_BATCHES_SAVE_LIST), List(Of LabBatchGetListModel))
            Dim batchTests = CType(Session(SESSION_BATCH_TESTS_LIST), List(Of LabBatchGetListModel))
            Dim testsPendingSave = CType(Session(SESSION_TESTING_SAVE_LIST), List(Of LabTestGetListModel))
            Dim parameters As LaboratoryTestGetListParameters
            Dim index As Integer = 0

            If batches Is Nothing Then
                batches = New List(Of LabBatchGetListModel)()
            End If

            If batchesPendingSave Is Nothing Then
                batchesPendingSave = New List(Of LabBatchGetListModel)()
            End If

            If batchTests Is Nothing Then
                batchTests = New List(Of LabBatchGetListModel)()
            End If

            If testsPendingSave Is Nothing Then
                testsPendingSave = New List(Of LabTestGetListModel)()
            End If

            For Each batch In batches
                If batch.RowSelectionIndicator = 1 Then
                    parameters = New LaboratoryTestGetListParameters With {.LanguageID = GetCurrentLanguage(), .TestStatusTypeID = TestStatusTypes.InProgress, .SiteID = hdfSiteID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value, .BatchTestID = batch.BatchTestID}
                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    testsPendingSave = LaboratoryAPIService.LaboratoryTestGetListAsync(parameters:=parameters).Result

                    For Each test In testsPendingSave
                        test.TestResultTypeID = ddlAddGroupResultTestResultType.SelectedValue
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().TestResultTypeID = ddlAddGroupResultTestResultType.SelectedValue
                        test.TestResultTypeName = ddlAddGroupResultTestResultType.SelectedItem.Text
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().TestResultTypeName = ddlAddGroupResultTestResultType.SelectedItem.Text
                        test.TestStatusTypeID = TestStatusTypes.Preliminary
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().TestStatusTypeID = TestStatusTypes.Preliminary
                        test.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                        test.ResultDate = Date.Today
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().ResultDate = Date.Today
                        test.ResultEnteredByOrganizationID = hdfOrganizationID.Value
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().ResultEnteredByOrganizationID = hdfOrganizationID.Value
                        test.ResultEnteredByPersonID = hdfPersonID.Value
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().ResultEnteredByPersonID = hdfPersonID.Value
                        test.RowAction = RecordConstants.Update
                        batchTests.Where(Function(x) x.TestID = test.TestID).FirstOrDefault().RowAction = RecordConstants.Update
                    Next

                    batch.RowAction = RecordConstants.Update
                    batch.ResultEnteredByOrganizationID = hdfOrganizationID.Value
                    batch.ResultEnteredByPersonID = hdfPersonID.Value

                    If batchesPendingSave.Where(Function(x) x.BatchTestID = batch.BatchTestID).Count() > 0 Then
                        index = batchesPendingSave.FindIndex(Function(x) x.BatchTestID = batch.BatchTestID)
                        batchesPendingSave(index) = batch
                    Else
                        batchesPendingSave.Add(batch)
                    End If
                End If
            Next

            Session(SESSION_BATCHES_LIST) = batches
            Session(SESSION_BATCH_TESTS_LIST) = batchTests
            Session(SESSION_TESTING_SAVE_LIST) = testsPendingSave
            FillDropDowns()
            gvBatches.PageIndex = lblBatchesPageNumber.Text - 1
            BindBatchesGridView()
            upBatchesMenu.Update()
            upBatchesButtons.Update()
            upBatchesSave.Update()
            upBatches.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, SHOW_ADD_GROUP_RESULT_POPOVER_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Tab Methods"

    ''' <summary>
    ''' Fill and bind the selected tab.  For performance purposes, the application does not 
    ''' initially load all 6 tabs.  It is more efficient to load seperately as needed by the 
    ''' user.
    ''' </summary>
    ''' <param name="tab"></param>
    Protected Sub TabItemSelected_Event(tab As String) Handles Me.TabItemSelected

        Try
            FillDropDowns()

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            hdfCurrentTab.Value = tab.Replace("lnk", "")

            Select Case hdfCurrentTab.Value
                Case LaboratoryModuleTabConstants.Samples
                    If Session(SESSION_SAMPLES_LIST) Is Nothing Then
                        Dim parameters = New LaboratorySampleGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SiteID = hdfSiteID.Value, .UserID = hdfUserID.Value, .OrganizationID = hdfOrganizationID.Value, .DaysFromAccessionDate = ConfigurationManager.AppSettings("DaysFromAccessionDate")}
                        Dim samplesCounts = LaboratoryAPIService.LaboratorySampleGetListCountAsync(parameters:=parameters).Result
                        hdfSamplesCount.Value = samplesCounts(0).RecordCount
                        lblSamplesCount.Text = samplesCounts(0).UnaccessionedSampleCount
                        FillSamplesList(pageIndex:=1, paginationSetNumber:=1)
                    Else
                        If hdfSamplesCount.Value > 0 And CType(Session(SESSION_SAMPLES_LIST), List(Of LabSampleGetListModel)).Count = 0 Then
                            FillSamplesList(pageIndex:=1, paginationSetNumber:=1)
                        End If
                    End If

                    BindSamplesGridView()

                    lblSamplesPageNumber.Text = 1

                    upSamples.Update()
                    upSamplesButtons.Update()
                    upSamplesMenu.Update()
                    upSamplesSave.Update()
                    upSamplesSearchResults.Update()

                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, POPOVER_SCRIPT, True)
                Case LaboratoryModuleTabConstants.Testing
                    If Session(SESSION_TESTING_LIST) Is Nothing Then
                        Dim parameters = New LaboratoryTestGetListParameters With {.TestStatusTypeID = TestStatusTypes.InProgress, .SiteID = hdfSiteID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
                        Dim testingCount = LaboratoryAPIService.LaboratoryTestGetListCountAsync(parameters:=parameters).Result
                        lblTestingCount.Text = testingCount(0).RecordCount
                        hdfTestingCount.Value = testingCount(0).RecordCount
                        FillTestingList(pageIndex:=1, paginationSetNumber:=1)
                    Else
                        If hdfTestingCount.Value > 0 And CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel)).Count = 0 Then
                            FillTestingList(pageIndex:=1, paginationSetNumber:=1)
                        End If
                    End If

                    BindTestingGridView()

                    lblTestingPageNumber.Text = 1

                    upTesting.Update()
                    upTestingButtons.Update()
                    upTestingMenu.Update()
                    upTestingSave.Update()
                    upTestingSearch.Update()
                    upTestingSearchResults.Update()
                Case LaboratoryModuleTabConstants.Transferred
                    If Session(SESSION_TRANSFERRED_LIST) Is Nothing Then
                        Dim parameters = New LaboratoryTransferGetListParameters With {.OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
                        Dim transferredCount = LaboratoryAPIService.LaboratoryTransferGetListCountAsync(parameters:=parameters).Result
                        lblTransferredCount.Text = transferredCount(0).RecordCount
                        FillTransferredList(pageIndex:=1, paginationSetNumber:=1)
                    Else
                        If lblTransferredCount.Text > 0 And CType(Session(SESSION_TRANSFERRED_LIST), List(Of LabTransferGetListModel)).Count = 0 Then
                            FillTransferredList(pageIndex:=1, paginationSetNumber:=1)
                        End If
                    End If

                    BindTransferredGridView()

                    lblTransferredPageNumber.Text = 1

                    upTransferred.Update()
                    upTransferredButtons.Update()
                    upTransferredMenu.Update()
                    upTransferredSave.Update()
                    upTransferredSearchResults.Update()
                Case LaboratoryModuleTabConstants.MyFavorites
                    If Session(SESSION_FAVORITES_LIST) Is Nothing Then
                        Dim favoritesCount = LaboratoryAPIService.LaboratoryFavoriteGetListCountAsync(languageID:=GetCurrentLanguage(), userID:=hdfUserID.Value).Result
                        lblMyFavoritesCount.Text = favoritesCount(0).RecordCount
                        FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                    Else
                        If lblMyFavoritesCount.Text > 0 And CType(Session(SESSION_FAVORITES_LIST), List(Of LabFavoriteGetListModel)).Count = 0 Then
                            FillMyFavoritesList(pageIndex:=1, paginationSetNumber:=1)
                        End If
                    End If

                    BindMyFavoritesGridView()

                    lblMyFavoritesPageNumber.Text = 1

                    upMyFavorites.Update()
                    upMyFavoritesButtons.Update()
                    upMyFavoritesMenu.Update()
                    upMyFavoritesSave.Update()
                    upMyFavoritesSearchResults.Update()
                Case LaboratoryModuleTabConstants.Batches
                    If Session(SESSION_BATCHES_LIST) Is Nothing Then
                        Dim parameters = New LaboratoryBatchGetListParameters With {.OrganizationID = hdfOrganizationID.Value, .PaginationSetNumber = 1, .UserID = hdfUserID.Value}
                        Dim batchesCount = LaboratoryAPIService.LaboratoryBatchGetListCountAsync(parameters:=parameters).Result
                        lblBatchesCount.Text = batchesCount(0).RecordCount
                        FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
                    Else
                        If lblBatchesCount.Text > 0 And CType(Session(SESSION_BATCHES_LIST), List(Of LabBatchGetListModel)).Count = 0 Then
                            FillBatchesList(pageIndex:=1, paginationSetNumber:=1)
                        End If
                    End If

                    BindBatchesGridView()

                    lblBatchesPageNumber.Text = 1

                    upBatches.Update()
                    upBatchesSearch.Update()
                    upBatchesButtons.Update()
                    upBatchesMenu.Update()
                    upBatchesSave.Update()
                Case LaboratoryModuleTabConstants.Approvals
                    If Session(SESSION_APPROVALS_LIST) Is Nothing Then
                        Dim parameters = New LaboratoryApprovalGetListParameters With {.LanguageID = GetCurrentLanguage(), .SiteID = hdfSiteID.Value, .PaginationSetNumber = 1}
                        Dim approvalsCount = LaboratoryAPIService.LaboratoryApprovalGetListCountAsync(parameters:=parameters).Result
                        lblApprovalsCount.Text = approvalsCount(0).RecordCount
                        FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
                    Else
                        If lblApprovalsCount.Text > 0 And CType(Session(SESSION_APPROVALS_LIST), List(Of LabApprovalGetListModel)).Count = 0 Then
                            FillApprovalsList(pageIndex:=1, paginationSetNumber:=1)
                        End If
                    End If

                    BindApprovalsGridView()

                    lblApprovalsPageNumber.Text = 1

                    upApprovals.Update()
                    upApprovalsButtons.Update()
                    upApprovalsMenu.Update()
                    upApprovalsSave.Update()
                    upApprovalsSearchResults.Update()
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Menu Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedMenuItem"></param>
    Protected Sub SamplesMenu_MenuItemSelected(selectedMenuItem As String, tab As String) Handles ucSamplesMenu.MenuItemSelected

        Try
            If selectedMenuItem = LaboratoryModuleActions.SetTestResults.ToString() Then
                hdfCurrentModuleAction.Value = LaboratoryModuleActions.SetTestResultsForSample.ToString()
            Else
                hdfCurrentModuleAction.Value = selectedMenuItem
            End If

            InitializeControl(tab:=tab)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedMenuItem"></param>
    Protected Sub TestingMenu_MenuItemSelected(selectedMenuItem As String, tab As String) Handles ucTestingMenu.MenuItemSelected

        Try
            Dim testID As Long = 0
            Dim tests = CType(Session(SESSION_TESTING_LIST), List(Of LabTestGetListModel))
            If tests Is Nothing Then
                tests = New List(Of LabTestGetListModel)()
            End If

            For Each test In tests
                If test.RowSelectionIndicator = 1 Then
                    testID = test.TestID
                End If
            Next

            If selectedMenuItem = LaboratoryModuleActions.SetTestResults.ToString() Then
                hdfCurrentModuleAction.Value = LaboratoryModuleActions.SetTestResultsForTest.ToString()
            Else
                hdfCurrentModuleAction.Value = selectedMenuItem
            End If

            InitializeControl(LaboratoryModuleTabConstants.Testing.ToString(), testID:=testID)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedMenuItem"></param>
    Protected Sub TransferredMenu_MenuItemSelected(selectedMenuItem As String, tab As String) Handles ucTransferredMenu.MenuItemSelected

        Try
            If selectedMenuItem = LaboratoryModuleActions.SetTestResults.ToString() Then
                hdfCurrentModuleAction.Value = LaboratoryModuleActions.SetTestResultsForSample.ToString()
            Else
                hdfCurrentModuleAction.Value = selectedMenuItem
            End If

            InitializeControl(tab:=tab)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedMenuItem"></param>
    ''' <param name="tab"></param>
    Private Sub ApprovalsMenu_MenuItemSelected(selectedMenuItem As String, tab As String) Handles ucApprovalsMenu.MenuItemSelected

        Try
            If selectedMenuItem = LaboratoryModuleActions.SetTestResults.ToString() Then
                hdfCurrentModuleAction.Value = LaboratoryModuleActions.SetTestResultsForSample.ToString()
            Else
                hdfCurrentModuleAction.Value = selectedMenuItem
            End If

            InitializeControl(tab:=tab)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Column View Preference Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub SamplesColumnChooser_Click(sender As Object, e As EventArgs) Handles btnSamplesColumnChooser.Click, btnTestingColumnChooser.Click, btnTransferredColumnChooser.Click,
        btnMyFavoritesColumnChooser.Click, btnBatchesColumnChooser.Click, btnApprovalsColumnChooser.Click

        Try
            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divColumnViewPreferences"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

End Class
