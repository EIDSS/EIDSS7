Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class AggregateSettings
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





#Region "Constructors"

    ''' <summary>
    ''' Instantiate our API Clients
    ''' </summary>




    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(AggregateSettings))
            Log.Info("Loading Contructor Classes AggregateSettings.aspx")
            CrossCuttingAPIClient = New CrossCuttingServiceClient()
            BaseReferenceAPIClient = New BaseReferenceClient()
            ConfigurationAPIClient = New ConfigurationServiceClient()
            globalSiteDetails = New GblSiteGetDetailModel()
            aggregateSettingMdl = New AggregateSettingsSetParam()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
    End Sub

#End Region



    ''' <summary>
    ''' Get userId and SiteId to retreieve CustomizationPackage needed to store into aggregate settings.
    ''' Loading Controls.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Log.Info("Entering Page Load AggregateSettings.aspx")
        Try
            Dim userId = Session(UserConstants.idfUserID)
            Dim userSite = Session(UserConstants.UserSite)
            If String.IsNullOrEmpty(userId) = False And String.IsNullOrEmpty(userSite) = False Then
                Log.Info(String.Format("Getting UserId and SiteId Variables from Session: UserId ={0} SiteId={1}", userId.ToString(), userSite.ToString()))
                globalSiteDetails = CrossCuttingAPIClient.GetGlobalSiteDetails(userSite, userId).Result(0)
                If globalSiteDetails Is Nothing Or globalSiteDetails.idfCustomizationPackage = 0 Then
                    Response.Redirect("~/Login.aspx")
                End If
                If Page.IsPostBack = False Then
                    GetSavedSettings()
                    LoadViewStateData()
                End If

            End If
        Catch ex As Exception
            Log.Error("Error On Page Load" & ex.Message)
            Throw ex
        End Try


    End Sub


    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Try
            Log.Info("Calling  Page_Init")
            Dim userId = Session(UserConstants.idfUserID)
            If userId Is Nothing Then
                Response.Redirect("~/Login.aspx")
            End If
            LoadControls(New List(Of String))
        Catch ex As Exception
            Log.Error("Error Calling  Page_Init : " & ex.Message)
            Throw ex
        End Try

    End Sub



    ''' <summary>
    ''' Generate and poplulate dynamic  controls with data from API
    ''' </summary>
    Sub LoadControls(Keys As List(Of String))


        Try
            Log.Info("Loading Controls")

            caseTypes = BaseReferenceAPIClient.GetBaseReferneceTypes(AggregateSetting.CaseTypes)
            adminLevels = BaseReferenceAPIClient.GetBaseReferneceTypes(AggregateSetting.AdminLevels)
            minimumTimeIntervalUnit = BaseReferenceAPIClient.GetBaseReferneceTypes(AggregateSetting.MinimumTimeInterVal)

            For index = 1 To caseTypes.Count

                Dim row = New TableRow()

                Dim cell = New TableCell()
                Dim rowCountLabel As Label = New Label()
                rowCountLabel.ID = "rowCountLabel" & (index - 1).ToString()
                rowCountLabel.Text = index.ToString()
                cell.Controls.Add(rowCountLabel)
                row.Cells.Add(cell)

                Dim cell0 = New TableCell()
                Dim caseTypeLabel As Label = New Label()
                caseTypeLabel.ID = "caseTypeLabel" & (index - 1).ToString()
                caseTypeLabel.CssClass = CType(caseTypes(index - 1).idfsBaseReference, String)
                caseTypeLabel.Text = caseTypes(index - 1).strDefault
                cell0.Controls.Add(caseTypeLabel)
                row.Cells.Add(cell0)

                Dim cell1 = New TableCell()
                Dim adminLevelDropDown As DropDownList = New DropDownList()
                adminLevelDropDown.Items.Add(New ListItem("", ""))
                adminLevelDropDown.AppendDataBoundItems = True
                adminLevelDropDown.ID = "adminLevelDropDown" & (index - 1).ToString()
                adminLevelDropDown.DataSource = adminLevels
                adminLevelDropDown.DataTextField = "strDefault"
                adminLevelDropDown.DataValueField = "idfsBaseReference"
                adminLevelDropDown.DataBind()

                adminLevelDropDown.AutoPostBack = True
                adminLevelDropDown.EnableViewState = True
                If ViewState("adminLevelDropDown" & (index - 1).ToString()) IsNot Nothing Then
                    Dim listItemIndex As Int32 = CType(ViewState("adminLevelDropDown" & (index - 1).ToString()), Int32)
                    adminLevelDropDown.SelectedIndex = listItemIndex
                End If
                AddHandler adminLevelDropDown.SelectedIndexChanged, AddressOf OnSelectedIndexChanged
                cell1.Controls.Add(adminLevelDropDown)
                row.Cells.Add(cell1)




                Dim cell2 = New TableCell()
                Dim minimumTimeIntervalUnitDropDown As DropDownList = New DropDownList()
                minimumTimeIntervalUnitDropDown.Items.Add(New ListItem("", ""))
                minimumTimeIntervalUnitDropDown.AppendDataBoundItems = True
                minimumTimeIntervalUnitDropDown.ID = "minimumTimeIntervalUnitDropDown" & (index - 1).ToString()
                minimumTimeIntervalUnitDropDown.DataSource = minimumTimeIntervalUnit
                minimumTimeIntervalUnitDropDown.DataTextField = "strDefault"
                minimumTimeIntervalUnitDropDown.DataValueField = "idfsBaseReference"
                minimumTimeIntervalUnitDropDown.DataBind()
                minimumTimeIntervalUnitDropDown.AutoPostBack = True
                AddHandler minimumTimeIntervalUnitDropDown.SelectedIndexChanged, AddressOf OnSelectedIndexChanged
                cell2.Controls.Add(minimumTimeIntervalUnitDropDown)
                row.Cells.Add(cell2)


                Table1.Rows.Add(row)
            Next
        Catch ex As Exception
            Log.Error("Error Loading Controls : " & ex.Message)
            Throw ex
        End Try
        Log.Info("Finished Loading Controls")
    End Sub

    Protected Sub OnSelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddl As DropDownList = CType(sender, DropDownList)
        If ddl.SelectedValue = String.Empty Then
            blankSelectionLiteral.Text = "Clear The Content?"
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#blankDropDownValuesModal').modal({
  show: true,
  backdrop: false 
});", True)
        Else
            ViewState.Add(ddl.ID, ddl.SelectedIndex)
        End If

    End Sub




    ''' <summary>
    ''' Save Details from Form
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub submit_Click(sender As Object, e As EventArgs) Handles submit.Click
        Try

            Log.Info("Loading Modal to Save Settings")
            resultsLiteral.Text = "Are You Sure You Want To Save Settings"
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal({
  show: true,
  backdrop: false 
});", True)

        Catch ex As Exception
            Log.Error("Error Loading Modal to Save Settings" & ex.Message, ex)

        End Try


    End Sub

    Protected Sub RevertData(sender As Object, e As EventArgs) Handles revertDataBtn.Click
        Log.Info("Starting Reverting Data")
        Try
            LoadViewStateData()
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#blankDropDownValuesModal').modal('hide');", True)
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal('hide');", True)
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#VerificationModal').modal('hide');", True)
        Catch ex As Exception
            Log.Error("Error Reverting Data" & ex.Message, ex)
        End Try

        Log.Info("Finished Reverting Data")
    End Sub

    Public Sub LoadViewStateData()
        Log.Info("Starting LoadViewStateData")
        For row = 1 To Table1.Rows.Count()
            If row > 0 Then
                Dim aggregateSetting = New AggregateSettingsSetParam()
                Dim adminLevelDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("adminLevelDropDown" + (row - 1).ToString()), DropDownList)
                Dim minimumTimeIntervalUnitDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("minimumTimeIntervalUnitDropDown" + (row - 1).ToString()), DropDownList)
                Dim caseTypeLabel As Label = CType(Table1.Rows.Item(row - 1).FindControl("caseTypeLabel" + (row - 1).ToString()), Label)
                If minimumTimeIntervalUnitDropDown IsNot Nothing And adminLevelDropDown IsNot Nothing Then
                    Dim mti = ViewState(minimumTimeIntervalUnitDropDown.ID)
                    Dim ald = ViewState(adminLevelDropDown.ID)
                    If mti IsNot Nothing Then
                        minimumTimeIntervalUnitDropDown.SelectedIndex = CInt(mti)
                    End If
                    If ald IsNot Nothing Then
                        adminLevelDropDown.SelectedIndex = CInt(ald)
                    End If
                End If

            End If
        Next

        Log.Info("Finished LoadViewStateData")
    End Sub

    Protected Sub GetSavedSettings()
        Dim savedSettings = ConfigurationAPIClient.GetAggregateSettings(globalSiteDetails.idfCustomizationPackage)

        Try
            Log.Info("Starting GetSavedSettings ")
            For settingsIndex = 1 To savedSettings.Count()
                For row = 1 To Table1.Rows.Count()
                    If row > 0 Then
                        Dim adminLevelDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("adminLevelDropDown" + (row - 1).ToString()), DropDownList)
                        Dim minimumTimeIntervalUnitDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("minimumTimeIntervalUnitDropDown" + (row - 1).ToString()), DropDownList)
                        Dim caseTypeLabel As Label = CType(Table1.Rows.Item(row - 1).FindControl("caseTypeLabel" + (row - 1).ToString()), Label)
                        If caseTypeLabel IsNot Nothing Then
                            If CLng(caseTypeLabel.CssClass) = savedSettings(settingsIndex - 1).idfsAggrCaseType Then
                                adminLevelDropDown.Items.FindByValue(savedSettings(settingsIndex - 1).idfsStatisticAreaType).Selected = True
                                minimumTimeIntervalUnitDropDown.Items.FindByValue(savedSettings(settingsIndex - 1).idfsStatisticPeriodType).Selected = True
                                ViewState.Add(minimumTimeIntervalUnitDropDown.ID, minimumTimeIntervalUnitDropDown.SelectedIndex)
                                ViewState.Add(adminLevelDropDown.ID, adminLevelDropDown.SelectedIndex)
                                Exit For
                            End If
                        End If

                    End If
                Next

            Next

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Log.Info("Finished GetSavedSettings")
    End Sub

    Protected Sub clearDataBtn_Click(sender As Object, e As EventArgs) Handles clearDataBtn.Click
        Log.Info("Starting Clearing Data")
        For row = 1 To Table1.Rows.Count()
            If row > 0 Then
                Dim aggregateSetting = New AggregateSettingsSetParam()
                Dim adminLevelDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("adminLevelDropDown" + (row - 1).ToString()), DropDownList)
                Dim minimumTimeIntervalUnitDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("minimumTimeIntervalUnitDropDown" + (row - 1).ToString()), DropDownList)
                Dim caseTypeLabel As Label = CType(Table1.Rows.Item(row - 1).FindControl("caseTypeLabel" + (row - 1).ToString()), Label)
                If minimumTimeIntervalUnitDropDown IsNot Nothing And adminLevelDropDown IsNot Nothing Then
                    If adminLevelDropDown.SelectedValue = String.Empty Then
                        ViewState.Remove(adminLevelDropDown.ID)
                    End If
                    If minimumTimeIntervalUnitDropDown.SelectedValue = String.Empty Then
                        ViewState.Remove(minimumTimeIntervalUnitDropDown.ID)
                    End If
                End If
            End If
        Next
        Log.Info("Finished Clearing Data")
    End Sub

    Protected Sub SaveChangesBtn_Click(sender As Object, e As EventArgs) Handles SaveChangesBtn.Click

        Log.Info("Saving Aggregate Settings")
        Dim aggregateSettingsList As List(Of AggregateSettingsSetParam) = New List(Of AggregateSettingsSetParam)
        Try
            For row = 1 To Table1.Rows.Count()

                If row > 0 Then
                    Dim aggregateSetting = New AggregateSettingsSetParam()
                    Dim adminLevelDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("adminLevelDropDown" + (row - 1).ToString()), DropDownList)
                    Dim minimumTimeIntervalUnitDropDown As DropDownList = CType(Table1.Rows.Item(row - 1).FindControl("minimumTimeIntervalUnitDropDown" + (row - 1).ToString()), DropDownList)
                    Dim caseTypeLabel As Label = CType(Table1.Rows.Item(row - 1).FindControl("caseTypeLabel" + (row - 1).ToString()), Label)
                    If minimumTimeIntervalUnitDropDown IsNot Nothing And adminLevelDropDown IsNot Nothing Then
                        If minimumTimeIntervalUnitDropDown.SelectedValue = String.Empty Then
                            resultsLiteral.Text = "The field ""Minimum Time Interval Unit"" is mandatory. You must enter data in this field before saving this form."
                            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal({
show: true,
backdrop: false 
});", True)
                            Return
                        End If
                        If adminLevelDropDown.SelectedValue = String.Empty Then

                            resultsLiteral.Text = "The field ""Minimum Administrative Level"" is mandatory. You must enter data in this field before saving this form."
                            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal({
              show: true,
              backdrop: false 
            });", True)
                            Return
                        End If
                        aggregateSetting.IdfCustomizationPackage = CType(globalSiteDetails.idfCustomizationPackage, String)
                        aggregateSetting.IdfsAggrCaseType = caseTypeLabel.CssClass
                        aggregateSetting.IdfsStatisticPeriodType = minimumTimeIntervalUnitDropDown.SelectedValue
                        aggregateSetting.IdfsStatisticAreaType = adminLevelDropDown.SelectedValue
                        aggregateSettingsList.Add(aggregateSetting)
                    End If

                End If

            Next
            Log.Info("Finished Saving Aggregate Settings")
            Dim results = ConfigurationAPIClient.SaveAggregateSettings(aggregateSettingsList).Result
            Dim returnMessage = String.Empty

            If results.Count() = 0 Then
                returnMessage = "AN ERROR OCCURED"
            Else
                returnMessage = "Changes are submitted successfully"
                For index = 1 To results.Count
                    If results(index - 1).ReturnMessage.ToUpper() <> "SUCCESS" Then
                        returnMessage = "ONE OR MORE ITEMS FAILED"
                    End If
                Next

            End If
            verificationLiteral.Text = returnMessage
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal('hide');", True)
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript2", "$('#VerificationModal').modal({
                  show: true,
                  backdrop: false 
                });", True)
        Catch ex As Exception
            Log.Error("Error Saving Aggregate Settings :" & ex.Message)
            verificationLiteral.Text = ex.Message
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal('hide');", True)
            ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript2", "$('#VerificationModal').modal({
                  show: true,
                  backdrop: false 
                });", True)
        End Try
    End Sub

    Protected Sub CloseSaveChangesMdlBtn_Click(sender As Object, e As EventArgs) Handles CloseSaveChangesMdlBtn.Click
        ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript", "$('#resultsModal').modal('hide');", True)
        ScriptManager.RegisterStartupScript(Me, Page.GetType, "ModalScript2", "$('#VerificationModal').modal('hide');", True)
        'Response.Redirect(Request.Url.ToString())
    End Sub
End Class