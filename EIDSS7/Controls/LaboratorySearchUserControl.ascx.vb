Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' Use Case: LUC13
''' 
''' The objective of the Search for a Sample Use Case Specification is to define the functional requirements 
''' for a user to search for a sample in the laboratory module. The functional requirements, or functionality 
''' that must be provided to users, are described in terms of use cases.
''' 
''' The Search for a Sample Use Case Specification defines the functional requirements to give the user the 
''' ability to search for a sample in the Laboratory Module of EIDSS.
''' 
''' </summary>
Public Class LaboratorySearchUserControl
    Inherits UserControl

#Region "Global Values"

    Protected AdvancedSearchPostBackItem As String

    Private LaboratoryAPIService As LaboratoryServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(LaboratorySearchUserControl))

    Public Event UpdateSamplesSearchResults(results As List(Of LabSampleSearchGetListModel), resultCount As Integer, query As String)
    Public Event UpdateTestingSearchResults(results As List(Of LabTestSearchGetListModel), resultCount As Integer, query As String)
    Public Event UpdateTransferredSearchResults(results As List(Of LabTransferSearchGetListModel), resultCount As Integer, query As String)
    Public Event UpdateMyFavoritesSearchResults(results As List(Of LabFavoriteSearchGetListModel), resultCount As Integer, query As String)
    Public Event UpdateBatchesSearchResults(results As List(Of LabTestAdvancedSearchGetListModel), resultCount As Integer, query As String)
    Public Event UpdateApprovalsSearchResults(results As List(Of LabApprovalSearchGetListModel), resultCount As Integer, query As String)
    Public Event ShowAdvancedSearch()
    Public Event ClearSearch()

    Public Property BatchTestDiseaseID As Long?

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                SetPostBackEvents()

                If ID = "ucBatchesSearch" Then
                    divBatchAddSampleToBatch.Visible = True
                    txtSearchString.Enabled = False
                    btnSearch.Enabled = False
                    btnSearch.Attributes.CssStyle(HtmlTextWriterStyle.Color) = "gray"
                    btnSearch.Attributes.CssStyle(HtmlTextWriterStyle.Cursor) = "default"
                Else
                    divBatchAddSampleToBatch.Visible = False
                End If
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")
                If Not eventArg.ToString.IsValueNullOrEmpty() Then
                    If eventSource.Contains(ID) Then
                        RaiseEvent ShowAdvancedSearch()
                    Else
                        If eventArg = "Clear Search" Then
                            RaiseEvent ClearSearch()
                        End If
                    End If
                End If

                SetPostBackEvents()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SetPostBackEvents()

        AdvancedSearchPostBackItem = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.AdvancedSearch.ToString())

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="userID"></param>
    Public Sub Setup(userID As Long)

        hdfUserID.Value = userID

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="toggleIndicator"></param>
    Public Sub DisableEnableForBatchTestSelectSample(toggleIndicator As Boolean)

        txtSearchString.Enabled = toggleIndicator
        btnSearch.Enabled = toggleIndicator

        If toggleIndicator = True Then
            btnSearch.Attributes.CssStyle(HtmlTextWriterStyle.Color) = "blue"
            btnSearch.Attributes.CssStyle(HtmlTextWriterStyle.Cursor) = "hand"
        Else
            btnSearch.Attributes.CssStyle(HtmlTextWriterStyle.Color) = "gray"
            btnSearch.Attributes.CssStyle(HtmlTextWriterStyle.Cursor) = "default"
            txtSearchString.Text = String.Empty
        End If

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
            Search()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Search()

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            Dim parameters = New LaboratorySearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .UserID = hdfUserID.Value, .SearchString = txtSearchString.Text}

            Select Case ID
                Case "ucSamplesSearch"
                    RaiseEvent UpdateSamplesSearchResults(LaboratoryAPIService.LaboratorySampleSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratorySampleSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount, txtSearchString.Text)
                Case "ucTestingSearch"
                    RaiseEvent UpdateTestingSearchResults(LaboratoryAPIService.LaboratoryTestSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryTestSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount, txtSearchString.Text)
                Case "ucTransferredSearch"
                    RaiseEvent UpdateTransferredSearchResults(LaboratoryAPIService.LaboratoryTransferSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryTransferSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount, txtSearchString.Text)
                Case "ucMyFavoritesSearch"
                    RaiseEvent UpdateMyFavoritesSearchResults(LaboratoryAPIService.LaboratoryFavoriteSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryFavoriteSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount, txtSearchString.Text)
                Case "ucBatchesSearch"
                    Dim advancedSearchParameters = New LaboratoryAdvancedSearchParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .ReportSessionType = Nothing, .EIDSSLaboratorySampleID = txtSearchString.Text, .DiseaseID = BatchTestDiseaseID, .TestStatusTypeID = TestStatusTypes.InProgress}
                    RaiseEvent UpdateBatchesSearchResults(LaboratoryAPIService.LaboratoryTestAdvancedSearchGetListAsync(advancedSearchParameters).Result, LaboratoryAPIService.LaboratoryTestSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount, txtSearchString.Text)
                Case "ucApprovalSearch"
                    RaiseEvent UpdateApprovalsSearchResults(LaboratoryAPIService.LaboratoryApprovalSearchGetListAsync(parameters).Result, LaboratoryAPIService.LaboratoryApprovalSearchGetListCountAsync(parameters).Result.FirstOrDefault().Column1, txtSearchString.Text)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="searchString"></param>
    Public Sub SetSearchString(searchString As String)

        upLaboratorySearch.Update()

        txtSearchString.Text = searchString

    End Sub

#End Region

End Class