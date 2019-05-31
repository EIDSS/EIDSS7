Imports System.Globalization
Imports System.Threading.Tasks
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class DataArchiveSettings
    Inherits BaseEidssPage
    Private ReadOnly Log As log4net.ILog
    Private ReadOnly BaseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly ConfigurationAPIClient As ConfigurationServiceClient
    Private ReadOnly CrossCuttingAPIClient As CrossCuttingServiceClient
    Private caseTypes As New List(Of AdminBaserefGetListModel)
    Private adminLevels As New List(Of AdminBaserefGetListModel)
    Private minimumTimeIntervalUnit As New List(Of AdminBaserefGetListModel)
    Private viewStateKeys As New List(Of String)
    Private globalSiteDetails As GblSiteGetDetailModel
    Private ReadOnly aggregateSettingMdl As AggregateSettingsSetParam
    Private UserId As String

    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(DataArchiveSettings))
            Log.Info("Loading Contructor Classes DataArchiveSettings.aspx")
            CrossCuttingAPIClient = New CrossCuttingServiceClient()
            BaseReferenceAPIClient = New BaseReferenceClient()
            ConfigurationAPIClient = New ConfigurationServiceClient()
            globalSiteDetails = New GblSiteGetDetailModel()
            aggregateSettingMdl = New AggregateSettingsSetParam()
            'If Session(UserConstants.idfUserID) Is Nothing Then
            '    Response.Redirect("~/Login.aspx")
            'Else
            '    UserId = Session(UserConstants.idfUserID)
            'End If
        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Log.Info("Page_Load DataArchiveSettings.aspx")
            If Session(UserConstants.idfUserID) Is Nothing Then
                Response.Redirect("~/Login.aspx")
            Else
                UserId = Session(UserConstants.idfUserID)
            End If
            If Page.IsPostBack = False Then
                GetDataArchiveSettings()
            End If
        Catch ex As Exception
            Log.Error("Error on Page_Load " & ex.Message)
        End Try


    End Sub

    Protected Sub AddArchiveDescription_Click(sender As Object, e As EventArgs) Handles AddArchiveDescription.Click

        ArchiveSettingState.ActiveViewIndex = 1
        UpdatePanel1.Update()
    End Sub



    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles CancelBtn.Click
        ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#cancelModal').modal({
                show: true,
                backdrop: false 
                });", True)
    End Sub
    Protected Sub ModalCancelBtn_Click(sender As Object, e As EventArgs) Handles ModalCancelBtn.Click
        'After Clicking Change Panel to return to initial State'
        ArchiveSettingState.ActiveViewIndex = 0
    End Sub

    Public Sub GetDataArchiveSettings()
        Try
            Log.Info("Entering GetDataArchiveSettings")
            Dim dataArchiveSettings = ConfigurationAPIClient.GetDataArchiveSettings()
            If dataArchiveSettings.Count > 0 Then

                hiddenArchiveSettingUID.Value = dataArchiveSettings(0).ArchiveSettingUID
                TxtDate.Text = DateTime.Parse(dataArchiveSettings(0).ArchiveBeginDate.ToString()).ToString("MM/dd/yyyy")
                TxtStartTime.Text = dataArchiveSettings(0).ArchiveScheduledStartTime.ToString()
                Literal1.Text = DateTime.Parse(dataArchiveSettings(0).ArchiveBeginDate.ToString()).ToString("yyyy-MM-dd")
                txtIntervalSet.Text = dataArchiveSettings(0).DataAgeforArchiveInYears
                txtIntervalYearsDefined.Text = dataArchiveSettings(0).DataAgeforArchiveInYears
                TextSummaryDescriptionSet.Text = "Occurs every day beginning on " & DateTime.Parse(dataArchiveSettings(0).ArchiveBeginDate.ToString()).ToString("dddd", CultureInfo.InvariantCulture) & " " & DateTime.Parse(dataArchiveSettings(0).ArchiveBeginDate.ToString()).ToShortDateString() & " at " & DateTime.Parse(dataArchiveSettings(0).ArchiveScheduledStartTime.ToString()).ToShortTimeString()
                txtDescriptionDefined.Text = "Occurs every day beginning  on " & DateTime.Parse(dataArchiveSettings(0).ArchiveBeginDate.ToString()).ToString("dddd", CultureInfo.InvariantCulture) & " " & DateTime.Parse(dataArchiveSettings(0).ArchiveBeginDate.ToString()).ToShortDateString() & " at " & DateTime.Parse(dataArchiveSettings(0).ArchiveScheduledStartTime.ToString()).ToShortTimeString()
            Else

            End If
        Catch ex As Exception
            Log.Error("Error GetDataArchiveSettings" & ex.Message)
        End Try


    End Sub

    Sub SaveDataArchiveSettings(adminArchiveSettingsSetParams As AdminArchiveSettingsSetParams)
        Try
            Log.Info("Entering SaveDataArchiveSettings")
            Dim dataArchiveSettings = ConfigurationAPIClient.SaveDataArchiveSettings(adminArchiveSettingsSetParams)
            If dataArchiveSettings.Result.Count > 0 Then
                GetDataArchiveSettings()
                ArchiveSettingState.ActiveViewIndex = 0
                resultsLiteral.Text = "Changes are submitted successfully"
                ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal({
                show: true,
                backdrop: false 
                });", True)

            End If
        Catch ex As Exception
            Log.Error("Error SaveDataArchiveSettings" & ex.Message)
        End Try
    End Sub



    Protected Sub Button2_Click(sender As Object, e As EventArgs) Handles SubmitBtn.Click


        Try
            Log.Info("Entering SaveDataArchiveSettings on Button2_Click CLick Event")
            Dim adminArchiveSettingsSetParams = New AdminArchiveSettingsSetParams()
            adminArchiveSettingsSetParams.archiveBeginDate = TxtDate.Text
            adminArchiveSettingsSetParams.dataAgeforArchiveInYears = txtIntervalYearsDefined.Text
            adminArchiveSettingsSetParams.archiveFrequencyInDays = CInt(Date.Parse(TxtDate.Text).DayOfWeek)
            adminArchiveSettingsSetParams.archiveScheduledStartTime = TimeSpan.Parse(TxtStartTime.Text)
            adminArchiveSettingsSetParams.auditCreateUser = UserId
            If (hiddenArchiveSettingUID.Value.IsValueNullOrEmpty = False) Then
                adminArchiveSettingsSetParams.archiveSettingUid = Long.Parse(hiddenArchiveSettingUID.Value)
            End If
            SaveDataArchiveSettings(adminArchiveSettingsSetParams)
        Catch ex As Exception
            Log.Error("Error Editing DataArchiveSettings" & ex.Message)
        End Try
    End Sub

    Protected Sub Edit_Click(sender As Object, e As EventArgs) Handles EditBtn.Click

        Try
            Log.Info("Entering SaveDataArchiveSettings on Edit_Click CLick Event")
            Dim adminArchiveSettingsSetParams = New AdminArchiveSettingsSetParams()
            adminArchiveSettingsSetParams.archiveBeginDate = TxtDate.Text
            adminArchiveSettingsSetParams.dataAgeforArchiveInYears = txtIntervalYearsDefined.Text
            adminArchiveSettingsSetParams.archiveFrequencyInDays = CInt(Date.Parse(TxtDate.Text).DayOfWeek)
            adminArchiveSettingsSetParams.archiveScheduledStartTime = TimeSpan.Parse(TxtStartTime.Text)
            adminArchiveSettingsSetParams.auditCreateUser = UserId
            If (hiddenArchiveSettingUID.Value.IsValueNullOrEmpty = False) Then
                adminArchiveSettingsSetParams.archiveSettingUid = Long.Parse(hiddenArchiveSettingUID.Value)
            End If
            SaveDataArchiveSettings(adminArchiveSettingsSetParams)
        Catch ex As Exception
            Log.Error("Error Saving DataArchiveSettings" & ex.Message)
        End Try
    End Sub
End Class