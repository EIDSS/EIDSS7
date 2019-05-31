Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports System.Reflection

Public Class GroupAccessionInUserControl
    Inherits UserControl

#Region "Global Values"

    Public Event ShowSampleSelectionModal(samples As List(Of LabSampleAdvancedSearchGetListModel), recordCount As Integer, eidssLocalFieldSampleID As String)
    Public Event ShowWarningModal(messageType As MessageType, message As String)
    Public Event DisableEnableAccession(enableIndicator As Boolean)

    Private Const MODAL_KEY As String = "Modal"
    Private Const SESSION_GROUP_ACCESSION_SAMPLES As String = "ucGroupAccessionIn_Samples"

    Private LaboratoryAPIService As LaboratoryServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(GroupAccessionInUserControl))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
                Session(SESSION_GROUP_ACCESSION_SAMPLES) = New List(Of LabSampleAdvancedSearchGetListModel)()
                gvSamplesToAccessionList.DataSource = Session(SESSION_GROUP_ACCESSION_SAMPLES)
                gvSamplesToAccessionList.DataBind()

                Reset()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="siteID"></param>
    ''' <param name="personID"></param>
    Public Sub Setup(siteID As Long, personID As Long)

        If Session(SESSION_GROUP_ACCESSION_SAMPLES) Is Nothing Then
            Session(SESSION_GROUP_ACCESSION_SAMPLES) = New List(Of LabSampleAdvancedSearchGetListModel)()
        End If
        hdfSiteID.Value = siteID.ToString()
        hdfPersonID.Value = personID.ToString()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        txtEIDSSLocalFieldSampleID.Text = String.Empty

    End Sub

#End Region

#Region "Group Accession Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub NewSampleToAccession_Click(sender As Object, e As EventArgs) Handles btnNewSampleToAccession.Click

        Try
            Dim samplesToAccession As List(Of LabSampleAdvancedSearchGetListModel) = TryCast(Session(SESSION_GROUP_ACCESSION_SAMPLES), List(Of LabSampleAdvancedSearchGetListModel))
            Dim samples = ValidateSample(txtEIDSSLocalFieldSampleID.Text)

            For Each sample In samples
                sample.AccessionByPersonID = hdfPersonID.Value
                sample.AccessionDate = Date.Now
                sample.AccessionConditionTypeID = AccessionConditionTypes.AcceptedInGoodCondition
                sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Accepted_In_Good_Condition_Text
                sample.AccessionIndicator = 1
                sample.FavoriteIndicator = 0
                sample.CurrentSiteID = hdfSiteID.Value
                sample.SiteID = hdfSiteID.Value
                sample.RowSelectionIndicator = 0
                sample.RowStatus = RecordConstants.ActiveRowStatus
                sample.RowAction = RecordConstants.Accession
                sample.SampleStatusTypeID = SampleStatusTypes.InRepository
                samplesToAccession.Add(sample)
            Next

            Session(SESSION_GROUP_ACCESSION_SAMPLES) = samplesToAccession
            gvSamplesToAccessionList.DataSource = samplesToAccession
            gvSamplesToAccessionList.DataBind()

            Reset()

            If samplesToAccession.Count = 0 Then
                RaiseEvent DisableEnableAccession(False)
            Else
                RaiseEvent DisableEnableAccession(True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="siteID"></param>
    ''' <param name="personID"></param>
    Public Sub SamplesSelected(samples As List(Of LabSampleAdvancedSearchGetListModel), siteID As Long, personID As Long)

        If Session(SESSION_GROUP_ACCESSION_SAMPLES) Is Nothing Then
            Session(SESSION_GROUP_ACCESSION_SAMPLES) = New List(Of LabSampleAdvancedSearchGetListModel)()
        End If

        For Each sample In samples
            sample.AccessionByPersonID = hdfPersonID.Value
            sample.AccessionDate = Date.Now
            sample.AccessionConditionTypeID = AccessionConditionTypes.AcceptedInGoodCondition
            sample.AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Accepted_In_Good_Condition_Text
            sample.AccessionIndicator = 1
            sample.FavoriteIndicator = 0
            sample.CurrentSiteID = hdfSiteID.Value
            sample.SiteID = hdfSiteID.Value
            sample.RowSelectionIndicator = 0
            sample.RowStatus = RecordConstants.ActiveRowStatus
            sample.RowAction = RecordConstants.Accession
            sample.SampleStatusTypeID = SampleStatusTypes.InRepository
        Next

        If samples.Count > 0 Then
            RaiseEvent DisableEnableAccession(True)
        Else
            RaiseEvent DisableEnableAccession(False)
        End If

        Session(SESSION_GROUP_ACCESSION_SAMPLES) = samples

        hdfSiteID.Value = siteID.ToString()
        hdfPersonID.Value = personID.ToString()

        gvSamplesToAccessionList.DataSource = Session(SESSION_GROUP_ACCESSION_SAMPLES)
        gvSamplesToAccessionList.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="eidssLocalFieldSampleID"></param>
    ''' <returns></returns>
    Private Function ValidateSample(ByVal eidssLocalFieldSampleID As String) As List(Of LabSampleAdvancedSearchGetListModel)

        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If
        Dim parameters = New LaboratoryAdvancedSearchParameters With {.PaginationSetNumber = 1, .ExactMatchEIDSSLocalFieldSampleID = eidssLocalFieldSampleID}
        Dim recordCount = LaboratoryAPIService.LaboratorySampleAdvancedSearchGetListCountAsync(parameters).Result.FirstOrDefault().RecordCount
        Dim validatedSamples = LaboratoryAPIService.LaboratorySampleAdvancedSearchGetListAsync(parameters).Result

        If validatedSamples.Count = 0 Then
            RaiseEvent ShowWarningModal(MessageType.CannotGroupAccession, GetLocalResourceObject("Warning_Message_Sample_Not_Found_Text"))
        ElseIf validatedSamples.Count > 1 Then
            RaiseEvent ShowSampleSelectionModal(validatedSamples.Where(Function(x) x.AccessionIndicator = 0).ToList(), recordCount, eidssLocalFieldSampleID)
        ElseIf validatedSamples.FirstOrDefault().AccessionIndicator = 1 Then
            RaiseEvent ShowWarningModal(MessageType.CannotGroupAccession, GetLocalResourceObject("Warning_Message_Sample_Accessioned_Text"))
        Else
            Return validatedSamples
        End If

        Return New List(Of LabSampleAdvancedSearchGetListModel)

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Public Function Accession() As List(Of LabSampleAdvancedSearchGetListModel)

        Try
            Dim samples = CType(Session(SESSION_GROUP_ACCESSION_SAMPLES), List(Of LabSampleAdvancedSearchGetListModel))

            Reset()

            Session.Remove(SESSION_GROUP_ACCESSION_SAMPLES)

            Return samples
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return Nothing

    End Function

#End Region

End Class