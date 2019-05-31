Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SearchSampleUserControl
    Inherits UserControl

#Region "Global Values"

    Public Event UpdateSamplesSearchResults(results As List(Of LabSampleAdvancedSearchGetListModel), resultCount As Integer)
    Public Event UpdateTestingSearchResults(results As List(Of LabTestAdvancedSearchGetListModel), resultCount As Integer)
    Public Event UpdateTransferredSearchResults(results As List(Of LabTransferAdvancedSearchGetListModel), resultCount As Integer)
    Public Event UpdateMyFavoritesSearchResults(results As List(Of LabFavoriteAdvancedSearchGetListModel), resultCount As Integer)
    Public Event UpdateBatchesSearchResults(results As List(Of LabBatchAdvancedSearchGetListModel), resultCount As Integer)
    Public Event UpdateApprovalsSearchResults(results As List(Of LabApprovalAdvancedSearchGetListModel), resultCount As Integer)
    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event ShowErrorModal(messageType As MessageType, message As String)

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchSampleUserControl))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If Not IsPostBack Then
                Reset()

                'If CrossCuttingAPIService Is Nothing Then
                '    CrossCuttingAPIService = New CrossCuttingServiceClient()
                'End If

                'FillDropDowns()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="userID"></param>
    ''' <param name="tab"></param>
    Public Sub Setup(userID As Long, tab As String)

        Try
            Reset()

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            FillDropDowns()

            hdfUserID.Value = userID
            hdfCurrentTab.Value = tab

            Dim parameters = New LaboratoryAdvancedSearchParameters()
            Scatter(divSearchParameters, ReadSearchCriteriaJSON(parameters, CreateTempFile(ID)), 3)

            'VerifyPermissions()

            upSearchSample.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Reset()

        ResetForm(divSearchParameters)
        cvAccessionDate.ValueToCompare = Date.Now.ToShortDateString()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        Try
            FillBaseReferenceDropDownList(ddlReportSessionType, BaseReferenceConstants.CaseType, HACodeList.AllHACode, True)
            Dim li As ListItem = ddlReportSessionType.Items.FindByValue(ReportSessionTypes.Avian)
            ddlReportSessionType.Items.Remove(li)
            li = ddlReportSessionType.Items.FindByValue(ReportSessionTypes.Livestock)
            ddlReportSessionType.Items.Remove(li)
            ddlReportSessionType = SortDropDownList(ddlReportSessionType)

            Dim ddl As DropDownList = New DropDownList()
            FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.CaseReportType, HACodeList.AllHACode, True)
            ddlSurveillanceTypeID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
            FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.CaseReportType, HACodeList.NoneHACode, False)
            ddl.SelectedIndex = -1
            ddlSurveillanceTypeID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
            ddlSurveillanceTypeID = SortDropDownList(ddlSurveillanceTypeID)

            lbxSampleStatusTypeID.Items.Clear()
            Dim lbx As ListBox = New ListBox
            li = New ListItem With {.Value = Resources.Labels.Lbl_Unaccessioned_Text, .Text = Resources.Labels.Lbl_Unaccessioned_Text}
            lbxSampleStatusTypeID.Items.Add(li)

            FillBaseReferenceListBox(lbx, BaseReferenceConstants.AccessionCondition, HACodeList.AllHACode, True)
            lbxSampleStatusTypeID.Items.AddRange(lbx.Items.Cast(Of ListItem).ToArray())
            lbx = New ListBox()
            FillBaseReferenceListBox(lbx, BaseReferenceConstants.SampleStatus, HACodeList.AllHACode, False)
            lbx.SelectedIndex = -1
            lbxSampleStatusTypeID.Items.AddRange(lbx.Items.Cast(Of ListItem).ToArray())
            lbxSampleStatusTypeID.SelectedIndex = -1
            lbxSampleStatusTypeID = SortListBox(lbxSampleStatusTypeID)

            FillBaseReferenceDropDownList(ddlSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.AllHACode, True)
            ddlSampleTypeID = SortDropDownList(ddlSampleTypeID)

            FillBaseReferenceDropDownList(ddlTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.AllHACode, True)
            ddlTestNameTypeID = SortDropDownList(ddlTestNameTypeID)

            FillBaseReferenceDropDownList(ddlTestStatusTypeID, BaseReferenceConstants.TestStatus, HACodeList.AllHACode, True)
            ddlTestStatusTypeID = SortDropDownList(ddlTestStatusTypeID)

            FillBaseReferenceDropDownList(ddlTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.AllHACode, True)
            ddlTestResultTypeID = SortDropDownList(ddlTestResultTypeID)

            FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode, True)
            ddlDiseaseID = SortDropDownList(ddlDiseaseID)

            FillBaseReferenceDropDownList(ddlSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.AllHACode, True)
            ddlSpeciesTypeID = SortDropDownList(ddlSpeciesTypeID)

            Dim list As List(Of GblOrganizationByTypeGetListModel) = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Laboratory).Result
            FillDropDownList(ddlOrganizationSentToID, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)
            FillDropDownList(ddlOrganizationTransferredToID, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)
            FillDropDownList(ddlResultsReceivedFromID, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            If ValidateForSearch() Then
                Select Case hdfCurrentTab.Value
                    Case LaboratoryModuleTabConstants.Samples
                        FillSamplesList()
                    Case LaboratoryModuleTabConstants.Testing
                        FillTestingList()
                    Case LaboratoryModuleTabConstants.Transferred
                        FillTransferredList()
                    Case LaboratoryModuleTabConstants.MyFavorites
                        FillMyFavoritesList()
                    Case LaboratoryModuleTabConstants.Batches
                        FillBatchesList()
                    Case LaboratoryModuleTabConstants.Approvals
                        FillApprovalsList()
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
    Private Function ValidateForSearch() As Boolean

        Dim validated As Boolean = False

        'Check if the from and to data entry dates are both entered.
        'If Yes then ignore rest of the search fields
        'If No, check if any other search criteria is entered, if not, raise error.
        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divSearchParameters, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each rdb As RadioButton In FindControlList(controls, divSearchParameters, GetType(RadioButton))
                    If Not validated Then validated = (rdb.Checked)
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divSearchParameters, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, divSearchParameters, GetType(EIDSSControlLibrary.DropDownList))
                    If ddl.ClientID.Contains("ddlSearchFormidfsCountry") = False Then
                        If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                    End If
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each lbx As ListBox In FindControlList(controls, divSearchParameters, GetType(ListBox))
                    If Not validated Then validated = (Not lbx.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(controls, divSearchParameters, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False)
                ddlReportSessionType.Focus()
            End If
        End If

        Return validated

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub FillSamplesList()

        Try
            Dim parameters = New LaboratoryAdvancedSearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ReportSessionType = ddlReportSessionType.SelectedValue}
            Dim sampleStatusTypes As String = Nothing
            For Each li As ListItem In lbxSampleStatusTypeID.Items
                If li.Selected Then
                    If li.Value = Resources.Labels.Lbl_Unaccessioned_Text Then
                        parameters.AccessionedIndicator = 1
                    Else
                        sampleStatusTypes += li.Value + ","
                        parameters.AccessionedIndicator = Nothing
                    End If
                End If
            Next

            If Not sampleStatusTypes Is Nothing Then
                sampleStatusTypes = sampleStatusTypes.Remove(sampleStatusTypes.Length - 1, 1)
            End If

            Gather(divSearchParameters, parameters, 3)
            parameters.SampleStatusTypeID = sampleStatusTypes

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))

            RaiseEvent UpdateSamplesSearchResults(LaboratoryAPIService.LaboratorySampleAdvancedSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratorySampleAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub FillTestingList()

        Try
            Dim parameters = New LaboratoryAdvancedSearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ReportSessionType = ddlReportSessionType.SelectedValue}
            Dim sampleStatusTypes As String = Nothing
            For Each li As ListItem In lbxSampleStatusTypeID.Items
                If li.Selected Then
                    If li.Value = Resources.Labels.Lbl_Unaccessioned_Text Then
                        parameters.AccessionedIndicator = 1
                    Else
                        sampleStatusTypes += li.Value + ","
                        parameters.AccessionedIndicator = Nothing
                    End If
                End If
            Next

            If Not sampleStatusTypes Is Nothing Then
                sampleStatusTypes = sampleStatusTypes.Remove(sampleStatusTypes.Length - 1, 1)
            End If

            Gather(divSearchParameters, parameters, 3)
            parameters.SampleStatusTypeID = sampleStatusTypes

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))

            RaiseEvent UpdateTestingSearchResults(LaboratoryAPIService.LaboratoryTestAdvancedSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryTestAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub FillTransferredList()

        Try
            Dim parameters = New LaboratoryAdvancedSearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ReportSessionType = ddlReportSessionType.SelectedValue}
            Dim sampleStatusTypes As String = Nothing
            For Each li As ListItem In lbxSampleStatusTypeID.Items
                If li.Selected Then
                    If li.Value = Resources.Labels.Lbl_Unaccessioned_Text Then
                        parameters.AccessionedIndicator = 1
                    Else
                        sampleStatusTypes += li.Value + ","
                        parameters.AccessionedIndicator = Nothing
                    End If
                End If
            Next

            If Not sampleStatusTypes Is Nothing Then
                sampleStatusTypes = sampleStatusTypes.Remove(sampleStatusTypes.Length - 1, 1)
            End If

            Gather(divSearchParameters, parameters, 3)
            parameters.SampleStatusTypeID = sampleStatusTypes

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))

            RaiseEvent UpdateTransferredSearchResults(LaboratoryAPIService.LaboratoryTransferAdvancedSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryTransferAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub FillMyFavoritesList()

        Try
            Dim parameters = New LaboratoryAdvancedSearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ReportSessionType = ddlReportSessionType.SelectedValue}
            Dim sampleStatusTypes As String = Nothing
            For Each li As ListItem In lbxSampleStatusTypeID.Items
                If li.Selected Then
                    If li.Value = Resources.Labels.Lbl_Unaccessioned_Text Then
                        parameters.AccessionedIndicator = 1
                    Else
                        sampleStatusTypes += li.Value + ","
                        parameters.AccessionedIndicator = Nothing
                    End If
                End If
            Next

            If Not sampleStatusTypes Is Nothing Then
                sampleStatusTypes = sampleStatusTypes.Remove(sampleStatusTypes.Length - 1, 1)
            End If

            Gather(divSearchParameters, parameters, 3)
            parameters.SampleStatusTypeID = sampleStatusTypes

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))

            RaiseEvent UpdateMyFavoritesSearchResults(LaboratoryAPIService.LaboratoryFavoriteAdvancedSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryFavoriteAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub FillBatchesList()

        Try
            Dim parameters = New LaboratoryAdvancedSearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ReportSessionType = ddlReportSessionType.SelectedValue}
            Dim sampleStatusTypes As String = Nothing
            For Each li As ListItem In lbxSampleStatusTypeID.Items
                If li.Selected Then
                    If li.Value = Resources.Labels.Lbl_Unaccessioned_Text Then
                        parameters.AccessionedIndicator = 1
                    Else
                        sampleStatusTypes += li.Value + ","
                        parameters.AccessionedIndicator = Nothing
                    End If
                End If
            Next

            If Not sampleStatusTypes Is Nothing Then
                sampleStatusTypes = sampleStatusTypes.Remove(sampleStatusTypes.Length - 1, 1)
            End If

            Gather(divSearchParameters, parameters, 3)
            parameters.SampleStatusTypeID = sampleStatusTypes

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))

            RaiseEvent UpdateBatchesSearchResults(LaboratoryAPIService.LaboratoryBatchAdvancedSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryBatchAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub FillApprovalsList()

        Try
            Dim parameters = New LaboratoryAdvancedSearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ReportSessionType = ddlReportSessionType.SelectedValue}
            Dim sampleStatusTypes As String = Nothing
            For Each li As ListItem In lbxSampleStatusTypeID.Items
                If li.Selected Then
                    If li.Value = Resources.Labels.Lbl_Unaccessioned_Text Then
                        parameters.AccessionedIndicator = 1
                    Else
                        sampleStatusTypes += li.Value + ","
                        parameters.AccessionedIndicator = Nothing
                    End If
                End If
            Next

            If Not sampleStatusTypes Is Nothing Then
                sampleStatusTypes = sampleStatusTypes.Remove(sampleStatusTypes.Length - 1, 1)
            End If

            Gather(divSearchParameters, parameters, 3)
            parameters.SampleStatusTypeID = sampleStatusTypes

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))

            RaiseEvent UpdateApprovalsSearchResults(LaboratoryAPIService.LaboratoryApprovalAdvancedSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryApprovalAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().Column1)
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
    Protected Sub Clear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        Try
            Reset()
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
    Private Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        Try
            RaiseEvent ShowWarningModal(MessageType.CancelSearchConfirm, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class