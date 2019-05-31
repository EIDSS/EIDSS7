Imports System.Web.Script.Services
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Public Class VeterinaryAggregateReportMatrix
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




    Sub LoadControls()

        Dim diseases = HumanClient.HumanAggCaseGetMTXlistAsync(ReferenceEditorType.Disease, 2, "en").Result
        For index = 1 To diseases.Count
            Dim tr As New TableRow()
            Dim tc0 As New TableCell()
            Dim tc1 As New TableCell()
            Dim tc2 As New TableCell()
            Dim tc3 As New TableCell()
            tr.ClientIDMode = ClientIDMode.Static
            tr.CssClass = "table-row"

            tc2.ClientIDMode = ClientIDMode.Static
            tc0.ClientIDMode = ClientIDMode.Static

            tc0.Text = (index - 1).ToString()
            tc0.ID = "row_" & diseases(index - 1).idfsBaseReference.ToString()

            tc1.Text = diseases(index - 1).strDefault
            tc1.ID = diseases(index - 1).idfsBaseReference.ToString()

            tc1.ClientIDMode = ClientIDMode.Static
            tc1.CssClass = "contentInTable"
            Dim literalForDiv As New LiteralControl()
            literalForDiv.Text = LoadDropDownItems(diseases(index - 1).idfsBaseReference.ToString()) & " <br><input type=""hidden"" id=""hidden_" & diseases(index - 1).idfsBaseReference.ToString() & """ class=""hiddenSelected""" & "/>"
            tc2.Controls.Add(literalForDiv)


            tc3.ClientIDMode = ClientIDMode.Static
            tc3.ID = "col3_" & diseases(index - 1).idfsBaseReference
            tc3.Text = diseases(index - 1).strIDC10

            tr.Cells.Add(tc0)
            tr.Cells.Add(tc1)
            tr.Cells.Add(tc2)
            tr.Cells.Add(tc3)
            HumanAggregateCaseTable.Rows.Add(tr)

        Next
        ' UpdatePanel1.Update()
        HumanAggregateCaseTable.Attributes.Add("style", "z-index:-1;")

    End Sub


    '''' <summary>
    '''' Buid Version drop Down List
    '''' </summary>
    'Public Sub GetVersions()
    '    Dim matrixVersions = ConfigurationApiClient.GetMatrixVersions()
    '    Dim sb As New StringBuilder()
    '    For index = 1 To matrixVersions.Count()
    '        sb.AppendLine("<a  style=""cursor:pointer;""  class=""list-group-item selectedMatrixVerion"" title=""" & matrixVersions(index - 1).MatrixName.ToString() & """  id=""version_" & matrixVersions(index - 1).idfVersion.ToString() & """>")
    '        sb.AppendLine(matrixVersions(index - 1).MatrixName.ToString())
    '        sb.AppendLine("</a>")
    '    Next
    '    ' VersionLiteral.Text = sb.ToString()
    'End Sub


    ''' <summary>
    ''' Load Buttons in Grid and empty UL element to hold dynamic list items
    ''' </summary>
    ''' <param name="id"></param>
    ''' <returns></returns>
    Public Function LoadDropDownItems(id As String) As String

        Dim dropDownHtml As New StringBuilder()
        'dropDownHtml.AppendLine("<div Class=""btn-group"">")
        'dropDownHtml.AppendLine("<Button type=""button"" id=""btn_" & id & """Class=""autoComplete btn btn-default dropdown-toggle"" data-toggle=""dropdown"">")
        'dropDownHtml.AppendLine("Select <span class=""caret""></span>")
        'dropDownHtml.AppendLine("</button>")
        'dropDownHtml.AppendLine("<ul id=""dd_" & id & """Class=""dropdown-menu list-group"" role=""menu"" style=""height:200px;width:500px;overflow:hidden; overflow-y:scroll;z-index:1000;""")
        'dropDownHtml.AppendLine("</ul>")
        'dropDownHtml.AppendLine("</div>")

        dropDownHtml.AppendLine("<a href = ""#"" id=""btn_" & id & """data-type=""select"" class=""diagnosisEditor""  data-title=""Select"">Select</a>")
        Return dropDownHtml.ToString()

    End Function



    ''' <summary>
    ''' Build Dynamic Drop Down Items when button is selected in Grid
    ''' </summary>
    ''' <returns></returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function GetAll() As String
        Dim sb As New StringBuilder()
        Try

            Dim HumanStaticClient As HumanServiceClient
            HumanStaticClient = New HumanServiceClient()
            Dim diseases = HumanStaticClient.HumanAggCaseGetMTXlistAsync(ReferenceEditorType.Disease, 2, "en").Result
            For index = 1 To diseases.Count
                sb.AppendLine("<li class=""list-group-item"">")
                sb.AppendLine("<a style=""width:50%;"" class=""subSelect""  style=""cursor:pointer;"" onclick=""ChangeData(this.id);"" id=""sub_" & diseases(index - 1).idfsBaseReference & """>")
                sb.AppendLine(diseases(index - 1).strDefault.ToString())
                sb.AppendLine("</a>")
                sb.AppendLine("<span style=""width:50%;""  class=""pull-right"" id=""icd_" & diseases(index - 1).idfsBaseReference & """>")
                sb.AppendLine(diseases(index - 1).strIDC10)
                sb.AppendLine("</span>")
                sb.AppendLine("</li>")
            Next

        Catch ex As Exception

        End Try
        Return sb.ToString()
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetAllDiseases() As String
        Dim ret = String.Empty
        Try

            Dim editableObjectList As New List(Of EditableJSObject)()
            Dim editableJs As New EditableJSObject()
            Dim HumanStaticClient As HumanServiceClient
            HumanStaticClient = New HumanServiceClient()
            Dim diseases = HumanStaticClient.HumanAggCaseGetMTXlistAsync(ReferenceEditorType.Disease, 2, "en").Result
            For index = 1 To diseases.Count
                editableJs = New EditableJSObject()
                editableJs.text = diseases(index - 1).strDefault.ToString()
                editableJs.value = diseases(index - 1).idfsBaseReference.ToString()
                editableObjectList.Add(editableJs)
            Next
            ret = Newtonsoft.Json.JsonConvert.SerializeObject(editableObjectList)

        Catch ex As Exception

        End Try
        Return ret
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function GetAllHumanDiseases() As String
        Dim ret = String.Empty
        Try
            Dim item As GblDiseaseMtxGetModel

            Dim listOfDiseases As List(Of GblDiseaseMtxGetModel)
            listOfDiseases = New List(Of GblDiseaseMtxGetModel)()
            Dim HumanStaticClient As HumanServiceClient
            HumanStaticClient = New HumanServiceClient()
            Dim diseases = HumanStaticClient.HumanAggCaseGetMTXlistAsync(ReferenceEditorType.Disease, 2, "en").Result
            For index = 1 To diseases.Count
                item = New GblDiseaseMtxGetModel()
                Dim strdefault
                Dim diagnosisbasereference
                Dim idc10
                If diseases(index - 1).strDefault Is Nothing Then
                    strdefault = String.Empty
                Else
                    strdefault = diseases(index - 1).strDefault
                End If
                If diseases(index - 1).strIDC10 Is Nothing Then
                    idc10 = String.Empty
                Else
                    idc10 = diseases(index - 1).strIDC10
                End If

                diagnosisbasereference = diseases(index - 1).idfsBaseReference

                item.strIDC10 = idc10
                item.idfsBaseReference = diagnosisbasereference
                item.strDefault = strdefault
                listOfDiseases.Add(item)
            Next
            ret = Newtonsoft.Json.JsonConvert.SerializeObject(listOfDiseases)

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
            params.idfsMatrixType = ReferenceEditorType.VetAggregateCaseMatrix
            Dim sb As New StringBuilder()
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            Dim version = ConfigApiCLient.VetAggReportSaveVersion(params).Result
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
            Dim res = ConfigApiCLient.VetAggReportDeleteMatrixRecord(params).Result
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
        Dim result As List(Of ConfVetAggregateCaseMatrixReportPostModel)
        Try
            Dim Post As List(Of VetCaseMtxReportPostParams) = Json.JsonConvert.DeserializeObject(Of List(Of VetCaseMtxReportPostParams))(params)
            Dim ConfigApiCLient As ConfigurationServiceClient
            ConfigApiCLient = New ConfigurationServiceClient()
            result = ConfigApiCLient.SaveVetAggregateCaseReportMatrix(Post).Result
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
        _matrixType = ReferenceEditorType.VetAggregateCaseMatrix
        Dim matrixVersions = ConfigApiCLient.GetMatrixVersionByType(_matrixType)
        Dim sb As New StringBuilder()
        Return Newtonsoft.Json.JsonConvert.SerializeObject(matrixVersions)
    End Function


    <System.Web.Services.WebMethod()>
    Public Shared Function GetSpeciesList()

        Dim ret = String.Empty
        Try
            Dim item As ConfGetSpeciesListGetModel

            Dim listOfSpecies As List(Of ConfGetSpeciesListGetModel)
            listOfSpecies = New List(Of ConfGetSpeciesListGetModel)()
            Dim configurationServiceClient As New ConfigurationServiceClient()
            configurationServiceClient = New ConfigurationServiceClient
            Dim speciesTypes = configurationServiceClient.GetSpeciesList("en", 32, ReferenceEditorType.SpeciesList).Result
            For index = 1 To speciesTypes.Count
                item = New ConfGetSpeciesListGetModel()
                Dim strdefault
                Dim diagnosisbasereference
                If speciesTypes(index - 1).strDefault Is Nothing Then
                    strdefault = String.Empty
                Else
                    strdefault = speciesTypes(index - 1).strDefault
                End If
                diagnosisbasereference = speciesTypes(index - 1).idfsBaseReference
                item.idfsBaseReference = diagnosisbasereference
                item.strDefault = strdefault
                listOfSpecies.Add(item)
            Next
            ret = Newtonsoft.Json.JsonConvert.SerializeObject(listOfSpecies)
        Catch ex As Exception

        End Try
        Return ret
    End Function
End Class