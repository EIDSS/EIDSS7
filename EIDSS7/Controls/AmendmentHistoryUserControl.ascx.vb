Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain

Public Class AmendmentHistoryUserControl
    Inherits UserControl

#Region "Global Values"

    Private LaboratoryAPIService As LaboratoryServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(AmendmentHistoryUserControl))

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
    Public Sub Setup(testID As Long)

        Dim testAmendments = New List(Of LabTestAmendmentGetListModel)()

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If
            testAmendments = LaboratoryAPIService.LaboratoryTestAmendmentGetListAsync(GetCurrentLanguage(), testID).Result

            gvAmendmentHistory.DataSource = testAmendments
            gvAmendmentHistory.DataBind()
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

End Class