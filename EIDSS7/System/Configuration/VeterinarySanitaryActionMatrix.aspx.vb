Imports System.Web.Script.Services
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Public Class VeterinarySanitaryActionMatrix
    Inherits BaseEidssPage
    Private ReadOnly Log As log4net.ILog
    Private ReadOnly HumanClient As HumanServiceClient
    Private ReadOnly CrossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly ConfigurationApiClient As ConfigurationServiceClient
    Private webconfigClient As WebConfigServiceClientSettings
    Private globalSiteDetails As GblSiteGetDetailModel

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Log.Info("Entering Page Load VeterinarySanitaryActionMatrix.aspx")
        Try

            webconfigClient = New WebConfigServiceClientSettings()
            hiddenBaseRoute.Value = webconfigClient.GetEnvironment()
        Catch ex As Exception
            Log.Error("Error On Page Load" & ex.Message)
            Throw ex
        End Try
        Log.Info("Exiting page Load for VeterinarySanitaryActionMatrix.aspx ")
    End Sub

    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(VeterinarySanitaryActionMatrix))
            Log.Info("Loading Contructor Classes VeterinarySanitaryActionMatrix.aspx")
            HumanClient = New HumanServiceClient()
            ConfigurationApiClient = New ConfigurationServiceClient()
            globalSiteDetails = New GblSiteGetDetailModel()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
        Log.Info("Exiting Contructor Class for VeterinarySanitaryActionMatrix.aspx")
    End Sub






    <System.Web.Services.WebMethod()>
    Public Shared Function GetAllSanitaryActions() As String
        Dim Log As log4net.ILog
        Log = log4net.LogManager.GetLogger(GetType(VeterinarySanitaryActionMatrix))
        Dim ret = String.Empty
        Log.Info("Entering GetAllSanitaryActions")
        Try
            Dim item As ConfGetSanitaryActionsGetModel

            Dim listOfDiseases As List(Of ConfGetSanitaryActionsGetModel)
            listOfDiseases = New List(Of ConfGetSanitaryActionsGetModel)()
            Dim ConfigurationApiClient As ConfigurationServiceClient
            ConfigurationApiClient = New ConfigurationServiceClient()
            Dim diseases = ConfigurationApiClient.GetSanitaryActionTypes(ReferenceEditorType.Sanitary, 32, "en").Result
            For index = 1 To diseases.Count
                item = New ConfGetSanitaryActionsGetModel()
                Dim strdefault
                Dim diagnosisbasereference
                Dim strActionCode
                If diseases(index - 1).strDefault Is Nothing Then
                    strdefault = String.Empty
                Else
                    strdefault = diseases(index - 1).strDefault
                End If
                If diseases(index - 1).strActionCode Is Nothing Then
                    strActionCode = String.Empty
                Else
                    strActionCode = diseases(index - 1).strActionCode
                End If

                diagnosisbasereference = diseases(index - 1).idfsBaseReference

                item.strActionCode = strActionCode
                item.idfsBaseReference = diagnosisbasereference
                item.strDefault = strdefault
                listOfDiseases.Add(item)
            Next
            ret = Newtonsoft.Json.JsonConvert.SerializeObject(listOfDiseases)

        Catch ex As Exception
            Log.Error("Error " + ex.Message, ex)
        End Try
        Log.Info("Exiting GetAllSanitaryActions")
        Return ret
    End Function




    ''' <summary>
    ''' Saves a new Matrix Version - > Call to Service Client
    ''' </summary>
    ''' <returns></returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function SaveVersion(params As AggregateCaseVerionPostParams) As ConfHumanAggregateCaseMatrixVersionPostModel
        Dim Log As log4net.ILog
        Log = log4net.LogManager.GetLogger(GetType(VeterinarySanitaryActionMatrix))
        Log.Info("Entering SaveVersion")
        Dim versionModel As New ConfHumanAggregateCaseMatrixVersionPostModel()
        Try
            params.idfsMatrixType = ReferenceEditorType.Sanitary
            Dim sb As New StringBuilder()
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            Dim version = ConfigApiCLient.HumanAggReportSaveVersion(params).Result
            If version.Count = 1 Then
                versionModel.idfVersion = version(0).idfVersion.ToString()
                versionModel.idfsMatrixType = version(0).idfsMatrixType.ToString()
                versionModel.MatrixName = version(0).MatrixName.ToString()
                versionModel.datStartDate = version(0).datStartDate.ToString()
                versionModel.blnIsActive = version(0).blnIsActive.ToString()
            End If
        Catch ex As Exception
            Log.Error("Error " + ex.Message, ex)
        End Try
        Log.Info("Exiting SaveVersion")
        Return versionModel
    End Function



    ''' <summary>
    ''' Saves a new Matrix Version - > Call to Service Client
    ''' </summary>
    ''' <returns></returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function DeleteMatrixRecord(params As Long) As String
        Dim Log As log4net.ILog
        Log = log4net.LogManager.GetLogger(GetType(VeterinarySanitaryActionMatrix))
        Log.Info("Entering DeleteMatrixRecord")
        Dim results = String.Empty
        Try
            Dim sb As New StringBuilder()
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            Dim res = ConfigApiCLient.SanitaryDeleteMatrixRecord(params).Result
            If res.Count > 0 Then
                results = res(0).ReturnMessage
            End If
        Catch ex As Exception
            Log.Error("Error " + ex.Message, ex)
        End Try
        Log.Info("Exitng DeleteMatrixRecord")
        Return results
    End Function





    ''' <summary>
    ''' Saves a new Matrix record(s) -> Call to Service Client
    ''' </summary>
    ''' <param name="params"></param>
    ''' <returns></returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function SaveMatrix(params As String) As String
        Dim Log As log4net.ILog
        Log = log4net.LogManager.GetLogger(GetType(VeterinarySanitaryActionMatrix))
        Log.Info("Entering SaveMatrix")
        Dim message = String.Empty
        Dim result As List(Of ConfAggrSanitaryActionMtxReportJsonPostModel)
        Try
            Dim Post As List(Of SanitaryMtxReportPostParams) = Json.JsonConvert.DeserializeObject(Of List(Of SanitaryMtxReportPostParams))(params)
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            result = ConfigApiCLient.SaveSanitaryMatrixReport(Post).Result
            If result.Count > 0 Then
                message = "Success"
            Else
                message = "Failed"
            End If

        Catch ex As Exception
            Log.Error("Error " + ex.Message, ex)
        End Try
        Log.Info("Exitng SaveMatrix")
        Return message.ToString()
    End Function

    ''' <summary>
    ''' Loads Matrix Versions
    ''' </summary>
    <System.Web.Services.WebMethod()>
    Public Shared Function GetMatrixVersions() As String
        Dim Log As log4net.ILog
        Log = log4net.LogManager.GetLogger(GetType(VeterinarySanitaryActionMatrix))
        Log.Info("Entering GetMatrixVersions")
        Dim matrixVersions As List(Of ConfHumanAggregateCaseMatrixVersionByMatrixTypeGetModel)
        matrixVersions = New List(Of ConfHumanAggregateCaseMatrixVersionByMatrixTypeGetModel)
        Try
            Log.Info("Entering GetMatrixVersions")
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            Dim _matrixType
            _matrixType = ReferenceEditorType.Sanitary
            matrixVersions = ConfigApiCLient.GetMatrixVersionByType(_matrixType)
            Dim sb As New StringBuilder()
        Catch ex As Exception
            Log.Error("Error " + ex.Message, ex)
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(matrixVersions)
    End Function


End Class