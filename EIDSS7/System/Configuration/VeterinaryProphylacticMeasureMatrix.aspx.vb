Imports System.Web.Script.Services
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class VeterinaryProphylacticMeasureMatrix
    Inherits BaseEidssPage
    Private ReadOnly Log As log4net.ILog
    Private ReadOnly HumanClient As HumanServiceClient
    Private ReadOnly CrossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly ConfigurationApiClient As ConfigurationServiceClient
    Private webconfigClient As WebConfigServiceClientSettings
    Private globalSiteDetails As GblSiteGetDetailModel

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Log.Info("Entering Page Load AggregateSettings.aspx")
        Try

            webconfigClient = New WebConfigServiceClientSettings()
            hiddenBaseRoute.Value = webconfigClient.GetEnvironment()
        Catch ex As Exception
            Log.Error("Error On Page Load" & ex.Message)
            Throw ex
        End Try
    End Sub

    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(AggregateSettings))
            Log.Info("Loading Contructor Classes HumanReportMatrix.aspx")
            HumanClient = New HumanServiceClient()
            ConfigurationApiClient = New ConfigurationServiceClient()
            globalSiteDetails = New GblSiteGetDetailModel()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
    End Sub




    <System.Web.Services.WebMethod()>
    Public Shared Function GetVetDiagnosisList() As String
        Dim ret = String.Empty
        Try
            Dim item As ConfGetVetDiseaseListGetModel

            Dim listOfDiseases As List(Of ConfGetVetDiseaseListGetModel)
            listOfDiseases = New List(Of ConfGetVetDiseaseListGetModel)()
            Dim configurationServiceClient As ConfigurationServiceClient
            configurationServiceClient = New ConfigurationServiceClient()
            Dim diseases = configurationServiceClient.GetVetDiagnosisList("en", 32, ReferenceEditorType.Disease).Result
            For index = 1 To diseases.Count
                item = New ConfGetVetDiseaseListGetModel()
                Dim strdefault
                Dim diagnosisbasereference
                Dim oie
                If diseases(index - 1).strDefault Is Nothing Then
                    strdefault = String.Empty
                Else
                    strdefault = diseases(index - 1).strDefault
                End If
                If diseases(index - 1).strOIECode Is Nothing Then
                    oie = String.Empty
                Else
                    oie = diseases(index - 1).strOIECode
                End If

                diagnosisbasereference = diseases(index - 1).idfsBaseReference

                item.strOIECode = oie
                item.idfsBaseReference = diagnosisbasereference
                item.strDefault = strdefault
                listOfDiseases.Add(item)
            Next
            ret = Newtonsoft.Json.JsonConvert.SerializeObject(listOfDiseases)

        Catch ex As Exception

        End Try
        Return ret
    End Function

    '''' <summary>
    '''' Build Dynamic Drop Down Items when button is selected in Grid
    '''' </summary>
    '''' <returns></returns>
    '<System.Web.Services.WebMethod()>
    'Public Shared Function GetAll() As String
    '    Dim sb As New StringBuilder()
    '    Try

    '        Dim HumanStaticClient As HumanServiceClient
    '        HumanStaticClient = New HumanServiceClient()
    '        Dim diseases = HumanStaticClient.HumanAggCaseGetMTXlistAsync(ReferenceEditorType.Disease, 2, "en").Result
    '        For index = 1 To diseases.Count
    '            sb.AppendLine("<li class=""list-group-item"">")
    '            sb.AppendLine("<a style=""width:50%;"" class=""subSelect""  style=""cursor:pointer;"" onclick=""ChangeData(this.id);"" id=""sub_" & diseases(index - 1).idfsBaseReference & """>")
    '            sb.AppendLine(diseases(index - 1).strDefault.ToString())
    '            sb.AppendLine("</a>")
    '            sb.AppendLine("<span style=""width:50%;""  class=""pull-right"" id=""icd_" & diseases(index - 1).idfsBaseReference & """>")
    '            sb.AppendLine(diseases(index - 1).strIDC10)
    '            sb.AppendLine("</span>")
    '            sb.AppendLine("</li>")
    '        Next

    '    Catch ex As Exception

    '    End Try
    '    Return sb.ToString()
    'End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetProphylacticMeasureTypes() As String
        Dim ret = String.Empty
        Try

            Dim editableObjectList As New List(Of ConfGetProphylacticMeasuresGetModel)()
            Dim editableJs As New ConfGetProphylacticMeasuresGetModel()
            Dim ConfigurationCLient As ConfigurationServiceClient
            ConfigurationCLient = New ConfigurationServiceClient()
            Dim measureTypes = ConfigurationCLient.GetProphylacticMeasureTypes("en", 32, ReferenceEditorType.Prophylactic).Result
            For index = 1 To measureTypes.Count
                editableJs = New ConfGetProphylacticMeasuresGetModel()
                editableJs.strDefault = measureTypes(index - 1).strDefault.ToString()
                editableJs.idfsBaseReference = measureTypes(index - 1).idfsBaseReference.ToString()
                If measureTypes(index - 1).strActionCode Is Nothing Then
                    editableJs.strActionCode = String.Empty
                Else
                    editableJs.strActionCode = measureTypes(index - 1).strActionCode.ToString()
                End If

                editableObjectList.Add(editableJs)
            Next
            ret = Newtonsoft.Json.JsonConvert.SerializeObject(editableObjectList)

        Catch ex As Exception

        End Try
        Return ret
    End Function


    <System.Web.Services.WebMethod()>
    Public Shared Function GetSpecies() As String
        Dim ret = String.Empty
        Try

            Dim editableObjectList As New List(Of ConfGetSpeciesListGetModel)()
            Dim editableJs As New ConfGetSpeciesListGetModel()
            Dim ConfigurationCLient As ConfigurationServiceClient
            ConfigurationCLient = New ConfigurationServiceClient()
            Dim species = ConfigurationCLient.GetSpeciesList("en", 32, ReferenceEditorType.SpeciesList).Result
            For index = 1 To species.Count
                editableJs = New ConfGetSpeciesListGetModel()
                editableJs.strDefault = species(index - 1).strDefault.ToString()
                editableJs.idfsBaseReference = species(index - 1).idfsBaseReference.ToString()
                editableObjectList.Add(editableJs)
            Next
            ret = Newtonsoft.Json.JsonConvert.SerializeObject(editableObjectList)

        Catch ex As Exception

        End Try
        Return ret
    End Function









    ''' <summary>
    ''' Saves a new Matrix Version - > Call to Service Client
    ''' </summary>
    ''' <returns></returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function SaveVersion(params As AggregateCaseVerionPostParams) As ConfHumanAggregateCaseMatrixVersionPostModel
        Dim versionModel As New ConfHumanAggregateCaseMatrixVersionPostModel()
        Try
            params.idfsMatrixType = ReferenceEditorType.Prophylactic
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

        End Try
        Return versionModel
    End Function



    ''' <summary>
    ''' Saves a new Matrix Version - > Call to Service Client
    ''' </summary>
    ''' <returns></returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function DeleteMatrixRecord(params As Long) As String
        Dim results = String.Empty
        Try
            Dim sb As New StringBuilder()
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            Dim res = ConfigApiCLient.ProphylacticDeleteMatrixRecord(params).Result
            If res.Count > 0 Then
                results = res(0).ReturnMessage
            End If
        Catch ex As Exception

        End Try
        Return results
    End Function





    ''' <summary>
    ''' Saves a new Matrix record(s) -> Call to Service Client
    ''' </summary>
    ''' <param name="params"></param>
    ''' <returns></returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function SaveMatrix(params As String) As String
        Dim message = String.Empty
        Dim result As List(Of ConFtlbAggrProphylacticActionMtxReportJsonPostModel)
        Try
            Dim Post As List(Of ProphylacticMtxReportPostParams) = Json.JsonConvert.DeserializeObject(Of List(Of ProphylacticMtxReportPostParams))(params)
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            result = ConfigApiCLient.SaveProphylacticReportMatrix(Post).Result
            If result.Count > 0 Then
                message = "Success"
            Else
                message = "Failed"
            End If

        Catch ex As Exception

        End Try
        Return message.ToString()
    End Function

    ''' <summary>
    ''' Loads Matrix Versions
    ''' </summary>
    <System.Web.Services.WebMethod()>
    Public Shared Function GetMatrixVersions() As String
        Dim ConfigApiCLient As ConfigurationServiceClient
        ConfigApiCLient = New ConfigurationServiceClient()
        Dim _matrixType
        _matrixType = ReferenceEditorType.Prophylactic
        Dim matrixVersions = ConfigApiCLient.GetMatrixVersionByType(_matrixType)
        Dim sb As New StringBuilder()
        Return Newtonsoft.Json.JsonConvert.SerializeObject(matrixVersions)
    End Function


End Class