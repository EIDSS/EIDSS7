Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' Use Case: LUC22 - Search for a Freezer (Advanced)
''' 
''' The objective of the Search for a Freezer Use Case Specification is to define the functional 
''' requirements for a user to search the laboratory module in EIDSS to find a freezer. The 
''' functional requirements, or functionality that must be provided to users, are described in 
''' terms of use cases.
'''
''' The Search for a Freezer Use Case Specification defines the functional requirements to give 
''' the user the ability to search for a freezer in the Laboratory Module of EIDSS. 
''' </summary>
Public Class SearchFreezerUserControl
    Inherits UserControl

#Region "Global Values"

    Private userSettingsFile As String

    Private Const SESSION_FREEZER_LIST As String = "gvFreezer_List"

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event UpdateSearchResults(results As List(Of LabFreezerGetListModel), resultCount As Integer)
    Public Event CloseModal()

    Private Const MODAL_KEY As String = "Modal"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchFreezerUserControl))

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
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Setup()

        'Assign defaults from current user data.
        hdfUserID.Value = Session("UserID")
        hdfSiteID.Value = Session("UserSite")

        Reset()

        FillDropDowns()

        ExtractViewStateSession()

        Dim parameters = New LaboratoryFreezerGetListParams()
        Scatter(divSearchFreezerCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(ID)), 3)

        upSearchFreezer.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ResetForm(divSearchFreezerCriteria)

        'Restore search filters
        userSettingsFile = CreateTempFile(hdfUserID.Value.ToString(), ID)

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        FillBaseReferenceDropDownList(ddlStorageTypeID, BaseReferenceConstants.StorageType, HACodeList.NoneHACode, True)

    End Sub

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
            Dim parameters As New LaboratoryFreezerGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .OrganizationID = Nothing, .SearchString = Nothing}

            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))

            RaiseEvent UpdateSearchResults(LaboratoryAPIService.LaboratoryFreezerGetListAsync(Gather(divSearchFreezerCriteria, parameters, 3)).Result,
                                           LaboratoryAPIService.LaboratoryFreezerGetListCountAsync(Gather(divSearchFreezerCriteria, parameters, 3)).Result.FirstOrDefault().RecordCount)
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
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        Try
            SaveEIDSSViewState(ViewState)

            RaiseEvent ShowWarningModal(messageType:=MessageType.CancelSearchConfirm, isConfirm:=True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class