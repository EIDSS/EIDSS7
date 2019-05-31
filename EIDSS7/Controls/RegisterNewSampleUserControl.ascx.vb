Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' 
''' Use Case: LUC10 - Enter a New Sample
'''
''' The objective of the Enter a Sample Use Case Specification is to define the functional requirements 
''' for the user to enter a sample in the laboratory module of EIDSS and save it in the database. The 
''' functional requirements, or functionality that must be provided to users, are described in terms of 
''' use cases.
''' 
''' The Enter a Sample Use Case Specification defines the functional requirements to give the user the 
''' ability to enter a sample in the Laboratory Module of EIDSS.
''' 
''' </summary>
Public Class RegisterNewSampleUserControl
    Inherits UserControl

#Region "Global Values"

    Public Event ShowSearchPersonModal()
    Public Event ShowCreatePersonModal()
    Public Event ShowSearchReportSessionModal(reportSessionCategoryID As String)
    Public Event ShowErrorModal(messageType As MessageType, message As String)
    Public Event ShowWarningModal(messageType As MessageType, message As String)

    Private HumanAPIService As HumanServiceClient
    Private VeterinaryAPIService As VeterinaryServiceClient
    Private VectorAPIService As VectorServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(RegisterNewSampleUserControl))

#End Region

#Region "Initialize Methods"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If Not IsPostBack Then
                Reset()

                FillDropDowns()

                cvCollectionDate.ValueToCompare = Date.Now.ToShortDateString()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleCount"></param>
    ''' <param name="personID"></param>
    ''' <param name="organizationID"></param>
    Public Sub Setup(sampleCount As Integer, siteID As Long, personID As Long, organizationID As Long)

        Try
            Reset()

            hdfPersonID.Value = personID.ToString()
            hdfSiteID.Value = siteID.ToString()
            hdfInstitutionID.Value = organizationID.ToString()
            hdfIdentity.Value = sampleCount

            FillDiseaseDropDown()

            upRegisterNewSample.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="reportSessionID"></param>
    ''' <param name="reportSessionEIDSSID"></param>
    ''' <param name="diseases"></param>
    Public Sub SetReportSession(reportSessionID As Long, reportSessionEIDSSID As String, diseases As String)

        Try
            Select Case ddlReportSessionTypeID.SelectedItem.Text
                Case ReportSessionTypeConstants.HumanDiseaseReport
                    hdfHumanDiseaseReportID.Value = reportSessionID
                Case ReportSessionTypeConstants.HumanActiveSurveillanceSession, ReportSessionTypeConstants.VeterinaryActiveSurveillanceSession
                    hdfMonitoringSessionID.Value = reportSessionID
                Case ReportSessionTypeConstants.VectorSurveillanceSession
                    hdfVectorSurveillanceSessionID.Value = reportSessionID
                Case ReportSessionTypeConstants.VeterinaryDiseaseReport
                    hdfVeterinaryDiseaseReportID.Value = reportSessionID
            End Select

            If Not diseases = String.Empty Then
                If diseases.Contains(";") Then
                    Dim splitDiseases As String() = diseases.ToString().Split(";")
                    FillDiseaseDropDown(filterDiseases:=splitDiseases)
                Else
                    FillDiseaseDropDown()
                    ddlDiseaseID.SelectedValue = diseases
                    ddlDiseaseID.Enabled = False
                End If
            End If

            txtReportSessionID.Text = reportSessionEIDSSID

            'upRegisterNewSample.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="patientFarmOwnerID"></param>
    ''' <param name="patientFarmOwnerName"></param>
    Public Sub SetPatientFarmOwner(patientFarmOwnerID As Long, patientFarmOwnerName As String)

        Try
            If patientFarmOwnerID.ToString().IsValueNullOrEmpty = False Then
                hdfHumanID.Value = patientFarmOwnerID
                txtPatientFarmOwner.Text = patientFarmOwnerName
            End If

            upRegisterNewSample.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        txtCollectionDate.Text = Date.Now.ToShortDateString()
        hdfRecordID.Value = "0"
        hdfRecordAction.Value = ""
        hdfHumanID.Value = ""
        ddlReportSessionTypeID.SelectedIndex = 0
        txtReportSessionID.Text = String.Empty
        txtPatientFarmOwner.Text = String.Empty
        txtNumberOfSamples.Text = 1
        ddlSampleTypeID.SelectedIndex = -1
        ddlDiseaseID.Items.Clear()

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        ddlReportSessionTypeID.SelectedIndex = -1

        FillBaseReferenceDropDownList(ddlSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.AllHACode, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="filterDiseases"></param>
    Private Sub FillDiseaseDropDown(Optional filterDiseases As String() = Nothing)

        ddlDiseaseID.Items.Clear()

        If ddlReportSessionTypeID.SelectedItem Is Nothing Then
            Dim ddl As DropDownList = New DropDownList

            FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode, True)
            ddlDiseaseID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
            ddl.SelectedIndex = -1
        Else
            If ddlReportSessionTypeID.SelectedItem.Text.IsValueNullOrEmpty = True Then
                Dim ddl As DropDownList = New DropDownList

                FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode, True)
                ddlDiseaseID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
                ddl.SelectedIndex = -1
            Else
                Select Case ddlReportSessionTypeID.SelectedItem.Text
                    Case ReportSessionTypeConstants.HumanActiveSurveillanceSession, ReportSessionTypeConstants.HumanDiseaseReport
                        FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
                    Case ReportSessionTypeConstants.VeterinaryActiveSurveillanceSession, ReportSessionTypeConstants.VeterinaryDiseaseReport
                        FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.LiveStockAndAvian, True)
                    Case ReportSessionTypeConstants.VectorSurveillanceSession
                        FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.VectorHACode, True)
                    Case Else
                        Dim ddl As DropDownList = New DropDownList
                        FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode, True)

                        If filterDiseases Is Nothing Then
                            ddlDiseaseID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
                            ddl.SelectedIndex = -1
                            ddlDiseaseID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
                        Else
                            Dim iCounter As Integer

                            While iCounter < filterDiseases.Length
                                ddlDiseaseID.Items.Add(ddl.Items.FindByValue(filterDiseases(iCounter)))
                                ddl.SelectedIndex = -1
                                iCounter += 1
                            End While
                        End If
                End Select
            End If
        End If

        ddlDiseaseID = SortDropDownList(ddlDiseaseID)
        ddlDiseaseID.SelectedIndex = -1
        ddlDiseaseID.Enabled = True

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        hdfSiteID.Value = Session("UserSite")
        hdfPersonID.Value = Session("Person")
        hdfInstitutionID.Value = Session("Institution")

    End Sub

#End Region

#Region "Report/Session Lookup Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LookupReportSession_Click(sender As Object, e As EventArgs) Handles btnLookupReportSession.Click

        Try
            RaiseEvent ShowSearchReportSessionModal(ddlReportSessionTypeID.SelectedItem.Text)
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
    Protected Sub ReportSessionID_TextChanged(sender As Object, e As EventArgs) Handles txtReportSessionID.TextChanged

        If txtReportSessionID.Text.IsValueNullOrEmpty = False Then
            upRegisterNewSample.Update()
            ddlDiseaseID.Enabled = True
            Select Case ddlReportSessionTypeID.SelectedItem.Text
                Case ReportSessionTypeConstants.HumanActiveSurveillanceSession
                    If HumanAPIService Is Nothing Then
                        HumanAPIService = New HumanServiceClient()
                    End If

                    Dim parameters As New MonitoringSessionGetListParameters With {.LanguageID = GetCurrentLanguage(), .EIDSSSessionID = txtReportSessionID.Text, .PaginationSetNumber = 1}
                    Dim list = HumanAPIService.GetHumanMonitoringSessionListAsync(parameters).Result

                    If list.Count > 0 Then
                        FillDiseaseDropDown()
                        txtPatientFarmOwner.Text = Resources.Labels.Lbl_Not_Applicable_Text
                        ddlDiseaseID.SelectedValue = list.FirstOrDefault().DiseaseID
                        hdfMonitoringSessionID.Value = list.FirstOrDefault().HumanMonitoringSessionID
                        ddlDiseaseID.Enabled = False
                    Else
                        RaiseEvent ShowWarningModal(messageType:=MessageType.ReportSessionNotFound, message:=Nothing)
                    End If
                Case ReportSessionTypeConstants.HumanDiseaseReport
                    If HumanAPIService Is Nothing Then
                        HumanAPIService = New HumanServiceClient()
                    End If

                    Dim parameters As New HumanDiseaseReportGetListParams With {.LanguageID = GetCurrentLanguage(), .EIDSSReportID = txtReportSessionID.Text, .PaginationSetNumber = 1}
                    Dim list = HumanAPIService.GetHumanDiseaseReportListAsync(parameters).Result

                    If list.Count > 0 Then
                        FillDiseaseDropDown()
                        txtPatientFarmOwner.Text = list.FirstOrDefault().PatientName
                        hdfHumanID.Value = list.FirstOrDefault().PatientID
                        ddlDiseaseID.SelectedValue = list.FirstOrDefault().DiseaseID
                        hdfHumanDiseaseReportID.Value = list.FirstOrDefault().HumanDiseaseReportID
                        ddlDiseaseID.Enabled = False
                    Else
                        RaiseEvent ShowWarningModal(messageType:=MessageType.ReportSessionNotFound, message:=Nothing)
                    End If
                Case ReportSessionTypeConstants.VeterinaryActiveSurveillanceSession
                    If VeterinaryAPIService Is Nothing Then
                        VeterinaryAPIService = New VeterinaryServiceClient()
                    End If

                    Dim parameters As New MonitoringSessionGetListParameters With {.LanguageID = GetCurrentLanguage(), .EIDSSSessionID = txtReportSessionID.Text, .PaginationSetNumber = 1}
                    Dim list = VeterinaryAPIService.GetMonitoringSessionListAsync(parameters).Result

                    If list.Count > 0 Then
                        FillDiseaseDropDown()
                        txtPatientFarmOwner.Text = Resources.Labels.Lbl_Not_Applicable_Text
                        ddlDiseaseID.SelectedValue = list.FirstOrDefault().DiseaseID
                        hdfMonitoringSessionID.Value = list.FirstOrDefault().VeterinaryMonitoringSessionID
                        ddlDiseaseID.Enabled = False
                    Else
                        RaiseEvent ShowWarningModal(messageType:=MessageType.ReportSessionNotFound, message:=Nothing)
                    End If
                Case ReportSessionTypeConstants.VeterinaryDiseaseReport
                    If VeterinaryAPIService Is Nothing Then
                        VeterinaryAPIService = New VeterinaryServiceClient()
                    End If

                    Dim parameters As New VeterinaryDiseaseReportGetListParameters With {.LanguageID = GetCurrentLanguage(), .EIDSSReportID = txtReportSessionID.Text, .PaginationSetNumber = 1}
                    Dim list = VeterinaryAPIService.GetVeterinaryDiseaseReportListAsync(parameters).Result

                    If list.Count > 0 Then
                        FillDiseaseDropDown()
                        txtPatientFarmOwner.Text = list.FirstOrDefault().FarmOwnerName
                        hdfHumanID.Value = list.FirstOrDefault().FarmOwnerID
                        ddlDiseaseID.SelectedValue = list.FirstOrDefault().DiseaseID
                        hdfHumanDiseaseReportID.Value = list.FirstOrDefault().VeterinaryDiseaseReportID
                        ddlDiseaseID.Enabled = False
                    Else
                        RaiseEvent ShowWarningModal(messageType:=MessageType.ReportSessionNotFound, message:=Nothing)
                    End If
                Case ReportSessionTypeConstants.VectorSurveillanceSession
                    If VectorAPIService Is Nothing Then
                        VectorAPIService = New VectorServiceClient()
                    End If

                    Dim parameters As New VectorSurveillanceSessionGetListParams With {.LanguageID = GetCurrentLanguage(), .EIDSSSessionID = txtReportSessionID.Text, .PaginationSetNumber = 1}
                    Dim list = VectorAPIService.GetVectorSurveillanceSessionListAsync(parameters).Result

                    If list.Count > 0 Then
                        txtPatientFarmOwner.Text = list.FirstOrDefault().Vectors

                        If Not list.FirstOrDefault().Disease = String.Empty Then
                            If list.FirstOrDefault().Disease.Contains(";") Then
                                Dim splitDiseases As String() = list.FirstOrDefault().Disease.ToString().Split(";")
                                FillDiseaseDropDown(filterDiseases:=splitDiseases)
                            Else
                                FillDiseaseDropDown()
                                ddlDiseaseID.SelectedValue = list.FirstOrDefault().Disease
                                ddlDiseaseID.Enabled = False
                            End If
                        End If

                        If list.Count = 1 Then
                            ddlDiseaseID.Enabled = False
                        Else
                            ddlDiseaseID.Enabled = True
                        End If

                        hdfVectorSurveillanceSessionID.Value = list.FirstOrDefault().VectorSurveillanceSessionID
                    Else
                        RaiseEvent ShowWarningModal(messageType:=MessageType.ReportSessionNotFound, message:=Nothing)
                    End If
            End Select
        End If

    End Sub

#End Region

#Region "Patient/Farm Owner Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LookupPatientFarmOwner_Click(sender As Object, e As EventArgs) Handles btnLookupPatientFarmOwner.Click

        Try
            RaiseEvent ShowSearchPersonModal()
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
    Protected Sub BtnCreatePatientFarmOwner_Click(sender As Object, e As EventArgs) Handles btnCreatePatientFarmOwner.Click

        Try
            RaiseEvent ShowCreatePersonModal()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Register New Sample Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Public Function AddSample() As List(Of LabSampleGetListModel)

        Try
            Page.Validate("RegisterNewSample")

            If Page.IsValid Then
                Dim counter As Integer = 0
                Dim identity As Integer = 0
                Dim samples As List(Of LabSampleGetListModel) = New List(Of LabSampleGetListModel)()
                Dim sample As LabSampleGetListModel

                If hdfSiteID.Value.IsValueNullOrEmpty = True Or hdfPersonID.Value.IsValueNullOrEmpty = True Or hdfInstitutionID.Value.IsValueNullOrEmpty = True Then
                    GetUserProfile()
                End If

                While counter < txtNumberOfSamples.Text
                    sample = New LabSampleGetListModel()

                    With sample
                        .AccessionConditionTypeID = AccessionConditionTypes.AcceptedInGoodCondition
                        .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Accepted_In_Good_Condition_Text
                        .SampleStatusTypeID = SampleStatusTypes.InRepository
                        .AccessionDate = Date.Now
                        .AccessionByPersonID = hdfPersonID.Value
                        .SampleTypeID = If(ddlSampleTypeID.SelectedValue = "null", Nothing, ddlSampleTypeID.SelectedValue)
                        .SampleTypeName = If(ddlSampleTypeID.SelectedValue = "null", Nothing, ddlSampleTypeID.SelectedItem.Text)
                        .EnteredDate = Date.Now
                        .CollectionDate = If(txtCollectionDate.Text = "", Nothing, Convert.ToDateTime(txtCollectionDate.Text))
                        .SiteID = hdfSiteID.Value
                        .CurrentSiteID = hdfSiteID.Value
                        .ReadOnlyIndicator = 0
                        .AccessionIndicator = 1
                        .FavoriteIndicator = 0
                        .EIDSSReportSessionID = If(txtReportSessionID.Text.IsValueNullOrEmpty() = True, Nothing, txtReportSessionID.Text)
                        .EIDSSLocalFieldSampleID = Nothing
                        .HumanID = If(hdfHumanID.Value.IsValueNullOrEmpty = True, Nothing, hdfHumanID.Value)
                        .PatientFarmOwnerName = If(txtPatientFarmOwner.Text.IsValueNullOrEmpty() = True, Nothing, txtPatientFarmOwner.Text)

                        If hdfMonitoringSessionID.Value.IsValueNullOrEmpty = True Then
                            .MonitoringSessionID = Nothing
                        Else
                            .MonitoringSessionID = hdfMonitoringSessionID.Value
                        End If

                        If hdfHumanDiseaseReportID.Value.IsValueNullOrEmpty = True Then
                            .HumanDiseaseReportID = Nothing
                        Else
                            .HumanDiseaseReportID = hdfHumanDiseaseReportID.Value
                        End If

                        If hdfVectorSurveillanceSessionID.Value.IsValueNullOrEmpty = True Then
                            .VectorSessionID = Nothing
                        Else
                            .VectorSessionID = hdfVectorSurveillanceSessionID.Value
                        End If

                        If hdfVeterinaryDiseaseReportID.Value.IsValueNullOrEmpty = True Then
                            .VeterinaryDiseaseReportID = Nothing
                        Else
                            .VeterinaryDiseaseReportID = hdfVeterinaryDiseaseReportID.Value
                        End If

                        .DiseaseID = ddlDiseaseID.SelectedValue
                        .DiseaseName = ddlDiseaseID.SelectedItem.Text

                        .CollectedByOrganizationID = hdfInstitutionID.Value

                        .TestAssignedIndicator = 0
                        .TestCompletedIndicator = 0

                        hdfIdentity.Value = hdfIdentity.Value + 1
                        identity = (hdfIdentity.Value * -1)
                        .SampleID = identity
                        .RowStatus = RecordConstants.ActiveRowStatus
                        .RowAction = RecordConstants.InsertAccession
                        .RowSelectionIndicator = 0
                    End With

                    samples.Add(sample)

                    counter += 1
                End While

                Return samples
            Else
                RaiseEvent ShowErrorModal(messageType:=MessageType.CannotRegisterNewSample, message:=String.Empty)

                Return Nothing
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return Nothing

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ReportSessionTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlReportSessionTypeID.SelectedIndexChanged

        Try
            If ddlReportSessionTypeID.SelectedItem.Text = String.Empty Then
                txtReportSessionID.Enabled = False
                btnLookupReportSession.Enabled = False
            Else
                txtReportSessionID.Enabled = True
                btnLookupReportSession.Enabled = True
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class