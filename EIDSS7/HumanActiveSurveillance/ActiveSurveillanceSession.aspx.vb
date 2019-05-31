Imports EIDSS.EIDSS
Imports System.IO
Imports System.Web.UI.WebControls
Imports System.Xml.Serialization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports OpenEIDSS.Domain.Return_Contracts
Imports System.Reflection
Public Class ActiveSurveillanceSession
    Inherits BaseEidssPage

    Private ReadOnly Log As log4net.ILog
    Private oCommon As clsCommon
    Private oService As NG.EIDSSService
    Private oDS As DataSet
    Private sFile As String

    Private Const sessionSamples As String = "sessionSamples"
    Private Const sessionActions As String = "sessionActions"
    Private Const sessionDetails As String = "sessionDetails"
    Private Const sessionTests As String = "sessionTests"
    Private Const campaign As String = "campaign"
    Private Const campaignSamples As String = "campaignSamples"
    Private Const results As String = "searchResults"

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"
    Private ReadOnly HumanServiceClientAPIClient As HumanServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient


    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(ActiveSurveillanceSession))
            Log.Info("Loading Contructor Classes ActiveSurveillanceSession.aspx")
            HumanServiceClientAPIClient = New HumanServiceClient()
            CrossCuttingAPIService = New CrossCuttingServiceClient()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        oCommon = New clsCommon()
        If Not Page.IsPostBack Then
            Try
                ExtractViewStateSession()

                hdgActiveSurveillanceSession.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
                hdgActiveSurveillanceSessionReview.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

                fillSearchDropdowns()
                fillSessionDropdowns()

                'Restore search filters
                sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.HumanActiveSurveillanceSessionPrefix)
                oCommon.GetSearchFields({search}, sFile)

                'This session will be added to a campaign
                If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignSearch Then
                    txtMonitoringSessionstrCampaignID.Text = Session("SelectedCampaign")
                    ViewState(CALLER) = CallerPages.Dashboard
                ElseIf ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaign Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignIDSearch Then
                    If Not IsNothing(Session("SelectedCampaign")) Then
                        hdfidfCampaign.Value = Session("SelectedCampaign")
                    Else
                        hdfidfCampaign.Value = ViewState(CALLER_KEY)
                    End If
                    searchForm.Visible = False
                    sessions.Visible = True
                    txtstrMonitoringSessionID.Text = "NULL"
                    If IsNumeric(hdfidfCampaign.Value) And hdfidfCampaign.Value <> "0" Then
                        Dim hasc As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
                        oDS = hasc.SelectOne(Convert.ToDouble(hdfidfCampaign.Value))
                        If oDS.CheckDataSet() Then
                            ViewState(campaign) = oDS
                            ViewState(campaignSamples) = oDS.Tables(1)


                            'divSessionDiagnosis.Visible = False  Defect was fixed to 
                            divSessionDiagnosis.Visible = True
                            'ddlidfsDiagnosis.Enabled = False





                            oCommon = New clsCommon()
                            oCommon.Scatter(campaignInformation, New DataTableReader(oDS.Tables(0)), 3, True)
                            If (oDS.Tables.Count > 0) Then
                                ViewState(campaign) = oDS
                                Dim dr As DataRow = oDS.Tables(0).Rows(0)
                                txtdatStartDate.MinDate = String.Format("{0:MM/dd/yyyy}", dr(ActiveSurveillanceCampaignConstants.StartDate))
                                txtdatStartDate.MaxDate = String.Format("{0:MM/dd/yyyy}", dr(ActiveSurveillanceCampaignConstants.EndDate))
                                txtdatEndDate.MinDate = String.Format("{0:MM/dd/yyyy}", dr(ActiveSurveillanceCampaignConstants.StartDate))
                                txtdatEndDate.MaxDate = String.Format("{0:MM/dd/yyyy}", dr(ActiveSurveillanceCampaignConstants.EndDate))
                            End If
                        End If
                    End If

                    Dim dt As DataTable = New DataTable()
                    dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType)
                    dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.MonitoringSession)
                    dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeID)
                    dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesType)
                    dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID)
                    dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleType)
                    dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.Order)

                    ViewState(sessionSamples) = dt
                    gvSamples.DataSource = dt
                    gvSamples.DataBind()

                    Dim ddlSampleType As DropDownList = gvSamples.HeaderRow.FindControl("ddlSampleType")
                    If Not IsNothing(ddlSampleType) Then
                        If Not IsNothing(ViewState(campaignSamples)) Then
                            fillSampleTypes(ddlSampleType, ViewState(campaignSamples))
                        End If
                    End If
                ElseIf ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionSearch Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceReturnToCampaignSessions Then
                    hdfidfCampaign.Value = ViewState(CALLER_KEY)
                    gvSearchResults.Columns(6).Visible = False
                    gvSearchResults.Columns(7).Visible = False
                ElseIf ViewState(CALLER) = CallerPages.Dashboard Then
                    gvSearchResults.Columns(6).Visible = True
                    gvSearchResults.Columns(7).Visible = True
                ElseIf ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationPersonSearch Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationOrganizationSearch Then
                    fillSession()
                ElseIf ViewState(CALLER) = CallerPages.HumanActiveSurveillanceEditCampaignSession Then
                    hdfidfMonitoringSession.Value = ViewState(CALLER_KEY)
                    fillSession()
                End If
            Catch ex As Exception
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Page.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
            End Try
        Else
            Dim target As String = TryCast(Request("__EVENTTARGET"), String)
            Dim couName As String = "ctl00$EIDSSBodyCPH$sLI$ddlsLIidfsCountry"
            Dim regName As String = "ctl00$EIDSSBodyCPH$sLI$ddlsLIidfsRegion"
            Dim rayName As String = "ctl00$EIDSSBodyCPH$sLI$ddlsLIidfsRayon"
            Dim setName As String = "ctl00$EIDSSBodyCPH$sLI$ddlsLIidfsSettlement"
            Dim searchRegName As String = "ctl00$EIDSSBodyCPH$MonitoringSession$ddlMonitoringSessionidfsRegion"
            Dim searchRayName As String = "ctl00$EIDSSBodyCPH$MonitoringSession$ddlMonitoringSessionidfsRayon"

            If couName = target Or regName = target Or rayName = target Or setName = target Then
                showHideSectionsandSidebarItems()
                hdnPanelController.Value = "0"
            ElseIf searchRegName = target Or searchRayName = target Then
                searchResults.Visible = False
                searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
                btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
                showClearandSearchButtons(True)
            End If
        End If
    End Sub

    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = oCommon.GetViewState(True)

            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        PrepViewStates()

    End Sub

    Private Sub PrepViewStates()

        'Used to correct any "nothing" values for known Viewstate variables
        Dim lKeys As List(Of String) = New List(Of String)

        'Add your new View State variables here
        lKeys.Add(CALLER)
        lKeys.Add(CALLER_KEY)

        For Each sKey As String In lKeys
            If (ViewState(sKey) Is Nothing) Then
                ViewState(sKey) = String.Empty
            End If
        Next

    End Sub

#Region "Buttons"

#Region "Search"

    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        oCommon = New clsCommon()
        'oComm.DeleteTempFiles(getSFileName())
        oCommon.ResetForm(search)

        'hdgMonitoringSessionstrSessionID.Text = String.Empty
        hdfidfMonitoringSession.Value = "NULL"
        'hdfstrMonitoringSessionID.Value = "NULL"
        hdfidfCampaign.Value = "NULL"

        searchResults.Visible = False


        btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        btnShowSearchCriteria.Visible = False
        showSearchCriteria(True)
    End Sub

    Protected Sub btnSearchforCampaignID_Click(sender As Object, e As EventArgs) Handles btnSearchforCampaignID.ServerClick
        'ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignSearch
        ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSession
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceCampaignUrl), False)
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Try
            If Not validateForSearch() Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_One_Search_Criterion.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            Else
                If Not validateDates(txtMonitoringSessionDatEnteredFrom.Text, txtMonitoringSessionDatEnteredTo.Text, False) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Date_Entered.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                    Exit Sub
                Else
                    oCommon = New clsCommon()

                    sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.HumanActiveSurveillanceSessionPrefix)
                    'Save search fields
                    oCommon.SaveSearchFields({search}, CallerPages.HumanActiveSurveillanceSession, sFile)

                    searchResults.Visible = True
                    fillSessionGV(bRefresh:=True)
                    btnShowSearchCriteria.Visible = True
                    showSearchCriteria(False)
                    'showClearandSearchButtons(False)
                End If
            End If
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Search.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    'Protected Sub btnSearchCancel_Click(sender As Object, e As EventArgs) Handles btnSearchCancel.ServerClick
    '    oCommon.SaveViewState(ViewState)

    '    If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionSearch Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceReturnToCampaignSessions Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceEditCampaignSession Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaign Then
    '        Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceCampaignUrl), True)
    '    Else
    '        ViewState(CALLER) = CallerPages.Dashboard
    '        ViewState(CALLER_KEY) = 0
    '        Response.Redirect(GetURL(CallerPages.DashboardURL), True)
    '    End If
    'End Sub

    Protected Sub getDefaultsForSession()
        txtstrSite.Text = Session("Organization")
        txtstrOfficer.Text = Session("FirstName") & " " & Session("FamilyName")
        txtdatEnteredDate.Text = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
    End Sub

    Protected Sub btnCreateSession_Click(sender As Object, e As EventArgs) Handles btnCreateSession.Click
        searchForm.Visible = False
        sessions.Visible = True

        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "0"

        Dim dt As DataTable = New DataTable()
        dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType)
        dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.MonitoringSession)
        dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeID)
        dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesType)
        dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID)
        dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleType)
        dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.Order)

        ViewState(sessionSamples) = dt
        gvSamples.DataSource = dt
        gvSamples.DataBind()

        divstrSessionID.Visible = False
        txtstrMonitoringSessionID.Text = "NULL"

        ' Replace these buttons with new version
        btnCreateSession.Visible = True
        btnDelete.Visible = False
        btnCancelSubmit.Visible = True


        btnPreviousSection.Visible = False 'Added for Test AK Looks Good
        btnNextSection.Visible = False 'Should go to Review Screen - Or the same as Go TO 1
        getDefaultsForSession()




    End Sub

    Protected Sub btnCampaignIDSearch_Click(sender As Object, e As EventArgs) Handles btnCampaignIDSearch.ServerClick
        ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignIDSearch
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceCampaignUrl), False)
    End Sub

#End Region

#Region "Session Information"

#Region "Sample"

    Protected Sub btnCancelSampleTypeYes_Click(sender As Object, e As EventArgs) Handles btnCancelSampleTypeYes.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "1"

        gvSamples.EditIndex = -1
        gvSamples.DataSource = ViewState(sessionSamples)
        gvSamples.DataBind()

        populateSampleTypeAdd()
    End Sub

    Protected Sub btnDeleteSampleType_Click(sender As Object, e As EventArgs) Handles btnDeleteSampleType.ServerClick
        Try

            Dim dt As DataTable = ViewState(sessionSamples)

            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "1"
            Dim oHASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
            Dim results As Object = Nothing

            If hdfSessionSampleTypeID.Value <> "NULL" Then
                oHASS.DeleteSample(Convert.ToDouble(hdfSessionSampleTypeID.Value))
            End If

            dt.Rows.RemoveAt(hdfSessionSampleTypeIndex.Value)
            gvSamples.DeleteRow(hdfSessionSampleTypeIndex.Value)
            gvSamples.DataSource = dt
            gvSamples.DataBind()
            ViewState(sessionSamples) = dt
            hdfSessionSampleTypeID.Value = "NULL"
            hdfSessionSampleTypeIndex.Value = "-1"
            populateSampleTypeAdd()
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub




#End Region

#Region "Actions"

    Protected Sub btnCancelAction_Click(sender As Object, e As EventArgs) Handles btnCancelAction.Click
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "2"
        addAction.Visible = False
        btnCreateActions.Visible = True
        showOrHideActionIcons(True)
    End Sub

    Protected Sub btnCancelActionYes_Click(sender As Object, e As EventArgs) Handles btnCancelActionYes.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "3"

        gvActions.EditIndex = -1
        gvActions.DataSource = ViewState(sessionActions)
        gvActions.DataBind()
        btnCreateActions.Visible = True
    End Sub
    Protected Sub btnCreateActions_Click(sender As Object, e As EventArgs) Handles btnCreateActions.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "2"
        addAction.Visible = True
        btnCreateActions.Visible = False
        showOrHideActionIcons(False)
    End Sub
    Protected Sub btnDiseaseReport_Click(sender As Object, e As EventArgs) 'Handles btnDiseaseReport.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "3"
        'addAction.Visible = True
        'btnCreateActions.Visible = False
        'showOrHideActionIcons(False)
    End Sub

    Protected Sub btnAddNewTest_Click(sender As Object, e As EventArgs)

        'open modal, add new Test, save, put in grid on underlying page

        'AK this not ready

        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "4"

        'hdfModalAddTestGuid.Value = String.Empty
        'hdfModalAddTestNewIndicator.Value = "new"
        'fillBasicTestsModal()
        'btnModalAddTestSave.Enabled = False   'postfix for tests req fields, comment out this line
        'btnModalAddTestDelete.Enabled = False
        'ddlidfsSampleType.SelectedIndex = -1
        'ddlSampleTestName.SelectedIndex = -1
        'ddlSampleTestCategory.SelectedIndex = -1
        'ddlSampleTestResult.SelectedIndex = -1
        'ddlSampleTestStatus.SelectedIndex = -1
        'ddlSampleTestDiagnosis.SelectedIndex = -1
        'ddlAddFieldTestTestedByInstitution.SelectedIndex = -1
        'datAddFieldTestResultReceived.Text = String.Empty
        'txtAddFieldTestResultDate.Text = String.Empty
        'ddlAddFieldTestTestedBy.SelectedIndex = -1

        'Dim page As Page = CType(HttpContext.Current.Handler, Page)
        'ScriptManager.RegisterStartupScript(page, GetType(Page), "PopupTestsModal", "openModalTestTab();", True)

    End Sub

    Protected Sub btnDeleteAction_Click(sender As Object, e As EventArgs) Handles btnDeleteAction.ServerClick
        Try
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "3"

            Dim dt As DataTable = ViewState(sessionActions)
            Dim index As Integer = Convert.ToInt32(hdfSessionActionIndex.Value)
            Dim actionID As Double = Convert.ToDouble(hdfSessionActionID.Value)

            If actionID <> -1 Then
                Dim hass As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
                hass.DeleteHAStoAction(actionID)
            End If

            dt.Rows.RemoveAt(index)
            gvActions.DataSource = dt
            gvActions.DataBind()
            ViewState(sessionActions) = dt

            hdfSessionActionIndex.Value = "-1"
            hdfSessionActionID.Value = "NULL"
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Deleting_Action.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnNewAction_Click(sender As Object, e As EventArgs) Handles btnNewAction.Click
        Try
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "3"

            Dim dt As DataTable = New DataTable()

            If IsNothing(ViewState(sessionActions)) Then

                dt.Columns.Add(MonitoringSessionActionConstants.MonitoringSessionActionID)
                dt.Columns.Add(MonitoringSessionActionConstants.MonitoringSessionID)
                dt.Columns.Add(MonitoringSessionActionConstants.PersonEnteredByID)
                dt.Columns.Add(MonitoringSessionActionConstants.MonitoringSessionActionTypeID)
                dt.Columns.Add(MonitoringSessionActionConstants.MonitoringSessionStatusTypeID)
                dt.Columns.Add(MonitoringSessionActionConstants.ActionDate)
                dt.Columns.Add(MonitoringSessionActionConstants.Comment)
                dt.Columns.Add(MonitoringSessionActionConstants.PersonName)
                dt.Columns.Add(MonitoringSessionActionConstants.ActionRequired)
                dt.Columns.Add(MonitoringSessionActionConstants.MonitoringSessionStatusTypeName)
            Else
                dt = ViewState(sessionActions)
            End If

            dt.Rows.Add(-1, hdfidfMonitoringSession.Value, ddlidfsEnteredBy.SelectedValue, ddlidfsActionType.SelectedValue, ddlidfsActionStatus.SelectedValue, txtdatActionDate.Text, txtstrComments.Text, ddlidfsEnteredBy.SelectedItem.Text, ddlidfsActionType.SelectedItem.Text, ddlidfsActionStatus.SelectedItem.Text)
            'dt.Rows.Add(-1, hdfidfMonitoringSession.Value, hdfidfPersonEnteredBy.Value, ddlidfsActionType.SelectedValue, ddlidfsActionStatus.SelectedValue, txtdatActionDate.Text, txtstrComments.Text, ddlidfsEnteredBy.SelectedItem.Text, ddlidfsActionType.SelectedItem.Text, ddlidfsActionStatus.SelectedItem.Text)
            gvActions.DataSource = dt
            gvActions.DataBind()
            ViewState(sessionActions) = dt

            txtstrComments.Text = ""
            txtdatActionDate.Text = ""
            ddlidfsActionStatus.SelectedIndex = -1
            ddlidfsEnteredBy.SelectedIndex = -1
            ddlidfsActionType.SelectedIndex = -1

            addAction.Visible = False
            btnCreateActions.Visible = True

            showOrHideActionIcons(True)
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Add_Session.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

#End Region

#Region "Details"

    Protected Sub btnAddDetails_Click(sender As Object, e As EventArgs) Handles btnAddDetails.ServerClick
        Try
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "2"

            If ddlDIidfsSampleType.SelectedIndex < 1 Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Sample_Type_Detail_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If

            If ddlDIidfsOrganizationID.SelectedValue = "null" Or ddlDIidfsOrganizationID.SelectedIndex = -1 Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Organization_Detail_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If

            If ddlDIstrPersonID.SelectedValue = "null" Or ddlDIstrPersonID.SelectedIndex = -1 Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Person_ID_Detail_Information.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If

            If String.IsNullOrEmpty(txtDIdatCollectionDate.Text) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Collection_Date_Detail_Information.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If

            Dim dt As DataTable
            If IsNothing(ViewState(sessionDetails)) Then
                dt = New DataTable()
                Dim paramNames As String() = {MaterialConstants.Material, MaterialConstants.MonitoringSessionID, MaterialConstants.SampleTypeID, MaterialConstants.SampleType, MaterialConstants.FieldBarCode, MaterialConstants.FieldCollectedByPersonID, MaterialConstants.FieldCollectedByPerson, MaterialConstants.FieldCollectionDate, MaterialConstants.SendToOfficeID, MaterialConstants.SendToOffice}
                For i As Integer = 0 To paramNames.Count() - 1
                    dt.Columns.Add(paramNames(i))
                Next
            Else
                dt = ViewState(sessionDetails)
                Dim paramNames As String() = {MaterialConstants.Material, MaterialConstants.MonitoringSessionID, MaterialConstants.SampleTypeID, MaterialConstants.SampleType, MaterialConstants.FieldBarCode, MaterialConstants.FieldCollectedByPersonID, MaterialConstants.FieldCollectedByPerson, MaterialConstants.FieldCollectionDate, MaterialConstants.SendToOfficeID, MaterialConstants.SendToOffice}
                dt = dt.DefaultView.ToTable(True, paramNames)
            End If

            dt.Rows.Add(-1, Convert.ToDouble(hdfidfMonitoringSession.Value), ddlDIidfsSampleType.SelectedValue, ddlDIidfsSampleType.SelectedItem.Text, String.Empty, ddlDIstrPersonID.SelectedValue, ddlDIstrPersonID.SelectedItem.Text, txtDIdatCollectionDate.Text, ddlDIidfsOrganizationID.SelectedValue, ddlDIidfsOrganizationID.SelectedItem.Text)

            gvDetailInformation.DataSource = dt
            gvDetailInformation.DataBind()

            ViewState(sessionDetails) = dt

            txtDIdatCollectionDate.Text = String.Empty
            ddlDIidfsOrganizationID.SelectedIndex = -1
            ddlDIstrPersonID.SelectedIndex = -1
            txtDIstrAddress.Text = String.Empty
            hdfPersonID.Value = "NULL"
            hdfOrganizationID.Value = "NULL"
            Session("EmployeeID") = Nothing
            Session("OrganizationID") = Nothing
            showOrHideDetailIcons(True)
            hdfNewMaterialID.Value = hdfNewMaterialID.Value - 1

            Dim sessionTest As String = "sessionTest" & hdfNewMaterialID.Value
            Dim paramNames2 As String() = {TestConstants.TestingID, TestConstants.MaterialID, TestConstants.TestNameID, TestConstants.TestName, TestConstants.TestCategoryID, TestConstants.TestCategory, TestConstants.TestResultID, TestConstants.TestResult, TestConstants.ConclusionDate}

            Dim dt2 As DataTable = New DataTable()
            For i As Integer = 0 To paramNames2.Count() - 1
                dt2.Columns.Add(paramNames2(i))
            Next
            ViewState(sessionTest) = dt2

            addDetail.Visible = False
            btnCreateDetails.Visible = True
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Adding_Detail.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnCancelAddDetail_Click(sender As Object, e As EventArgs) Handles btnCancelAddDetail.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "1"

        btnCreateDetails.Visible = True
        addDetail.Visible = False
        showOrHideDetailIcons(True)
    End Sub

    Protected Sub btnCancelDetailYes_Click(sender As Object, e As EventArgs) Handles btnCancelDetailYes.ServerClick
        Try
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "2"

            showOrHideTestGridExist(gvDetailInformation.EditIndex, True)
            gvDetailInformation.EditIndex = -1
            gvDetailInformation.DataSource = ViewState(sessionDetails)
            gvDetailInformation.DataBind()
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Detail_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnCreateDetails_Click(sender As Object, e As EventArgs) Handles btnCreateDetails.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "1"

        addDetail.Visible = True
        btnCreateDetails.Visible = False
        showOrHideDetailIcons(False)
    End Sub

    Protected Sub btnDeleteDetail_Click(sender As Object, e As EventArgs) Handles btnDeleteDetail.ServerClick
        Try
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "2"

            Dim dt As DataTable = ViewState(sessionDetails)
            If Not IsNothing(dt) Then
                Dim detailIndex As Integer = Convert.ToInt32(hdfSessionDetailIndex.Value)

                Dim gvTests As EIDSSControlLibrary.GridView = gvDetailInformation.Rows(detailIndex).FindControl("gvTests")
                If (gvTests.Rows.Count() < 1) Then

                    dt.Rows.RemoveAt(detailIndex)
                    gvDetailInformation.DeleteRow(detailIndex)
                    Dim detailId As Double = Convert.ToDouble(hdfSessionDetailID.Value)

                    If detailId <> -1 Then
                        Dim oHASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
                        Dim results As Object = Nothing
                        oHASS.DeleteHAStoMaterial(detailId)
                    End If

                    gvDetailInformation.DataSource = dt
                    gvDetailInformation.DataBind()
                    ViewState(sessionDetails) = dt
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Cannot_Delete_Detail.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End If
            End If
            hdfSessionDetailIndex.Value = "-1"
            hdfSessionDetailID.Value = "NULL"
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Detail_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnPersonSearch_Click(sender As Object, e As EventArgs) 'Handles btnPersonSearch.ServerClick
        ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationPersonSearch
        ViewState(CALLER_KEY) = hdfidfMonitoringSession.Value
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.EmployeeAdminURL), True)
    End Sub

    Protected Sub btnOrganizationSearch_Click(sender As Object, e As EventArgs) 'Handles btnOrganizationSearch.ServerClick
        ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationOrganizationSearch
        ViewState(CALLER_KEY) = hdfidfMonitoringSession.Value
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.OrganizationAdminURL))
    End Sub

    Protected Sub btnSaveDetails_Click(sender As Object, e As EventArgs)
        Dim detailIndex As Integer = Convert.ToInt32(hdfSessionDetailIndex.Value)
        Dim dt As DataTable = ViewState(sessionDetails)

        dt.Rows(detailIndex)(MaterialConstants.SendToOfficeID) = ddlDIidfsOrganizationID.SelectedValue
        dt.Rows(detailIndex)(MaterialConstants.SendToOffice) = ddlDIidfsOrganizationID.SelectedItem.Text

        dt.Rows(detailIndex)(MaterialConstants.SampleTypeID) = ddlDIidfsSampleType.SelectedValue
        dt.Rows(detailIndex)(MaterialConstants.SampleType) = ddlDIidfsSampleType.SelectedItem.Text

        dt.Rows(detailIndex)(MaterialConstants.FieldCollectedByPersonID) = ddlDIstrPersonID.SelectedValue
        dt.Rows(detailIndex)(MaterialConstants.FieldCollectedByPerson) = ddlDIstrPersonID.SelectedItem.Text

        dt.Rows(detailIndex)(MaterialConstants.FieldCollectionDate) = txtDIdatCollectionDate.Text

        gvDetailInformation.DataSource = dt
        gvDetailInformation.DataBind()
        ViewState(sessionDetails) = dt
        showOrHideDetailIcons(True)
        gvDetailInformation.Columns(5).Visible = True

        btnCreateDetails.Visible = True
        btnAddDetails.Visible = True
        addDetail.Visible = False
    End Sub

#Region "Tests"

    Protected Sub btnAddTest_Click(sender As Object, e As EventArgs) Handles btnAddTest.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "4"

        Dim detailindex As Integer = Convert.ToInt32(hdfDetailRowIndex.Value.Substring(0, hdfDetailRowIndex.Value.Length - 1))
        Dim gvTests As EIDSSControlLibrary.GridView = gvDetailInformation.Rows(detailindex).FindControl("gvTests")
        If Not IsNothing(gvTests) Then
            Dim materialID As Integer = gvDetailInformation.DataKeys(detailindex).Value
            Dim sessionTest As String = "sessionTest" & ((detailindex * -1) - 1).ToString()

            Dim dt As DataTable = New DataTable()
            If Not IsNothing(ViewState(sessionTest)) Then
                dt = ViewState(sessionTest)
            Else
                Dim paramNames As String() = {TestConstants.TestingID, TestConstants.MaterialID, TestConstants.TestNameID, TestConstants.TestName, TestConstants.TestCategoryID, TestConstants.TestCategory, TestConstants.TestResultID, TestConstants.TestResult, TestConstants.ConclusionDate}

                For i As Integer = 0 To paramNames.Count() - 1
                    dt.Columns.Add(paramNames(i))
                Next
            End If

            dt.Rows.Add(-1, materialID, ddlidfsTestName.SelectedValue, ddlidfsTestName.SelectedItem.Text, ddlidfsTestCategory.SelectedValue, ddlidfsTestCategory.SelectedItem.Text, ddlidfsTestResult.SelectedValue, ddlidfsTestResult.SelectedItem.Text, txtdatTestResultDate.Text.Substring(0, txtdatTestResultDate.Text.Length - 1))
            gvTests.DataSource = dt
            gvTests.DataBind()

            ViewState(sessionTest) = dt

            ddlidfsTestName.SelectedIndex = -1
            ddlidfsTestResult.SelectedIndex = -1
            ddlidfsTestCategory.SelectedIndex = -1
            txtdatTestResultDate.Text = String.Empty
            txtdatTestResultDate.MaxDate = String.Format("{0:MM/dd/yyyy}", DateTime.Today)
        End If
    End Sub

    Protected Sub btnDeleteTest_Click(sender As Object, e As EventArgs) Handles btnDeleteTest.ServerClick
        Try
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "2"

            Dim gvTests As EIDSSControlLibrary.GridView = gvDetailInformation.Rows(Convert.ToInt32(hdfSessionDetailIndex.Value)).FindControl("gvTests")

            If Not IsNothing(gvTests) Then
                Dim testIndex As Integer = Convert.ToInt32(hdfSessionTestIndex.Value)
                Dim detailIndex As Integer = (hdfSessionDetailIndex.Value * -1) - 1
                If Not IsNothing(ViewState("sessionTest" & detailIndex.ToString())) Then
                    Dim dt As DataTable = ViewState("sessionTest" & detailIndex.ToString())
                    dt.Rows.RemoveAt(testIndex)
                    If gvTests.DataKeys(testIndex).Value <> -1 Then
                        Dim testID As Double = gvTests.DataKeys(testIndex).Value
                        If testID <> -1 Then
                            Dim oHASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
                            oHASS.DeleteHAStoTest(testID)
                        End If

                        gvTests.DataSource = dt
                        gvTests.DataBind()
                    End If
                End If
            End If
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Country.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnCancelTest_Click(sender As Object, e As EventArgs) Handles btnCancelTest.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "2"

        Dim detailIndex As Integer = Convert.ToInt32(hdfSessionDetailIndex.Value)
        Dim gvTests As EIDSSControlLibrary.GridView = gvDetailInformation.Rows(detailIndex).FindControl("gvTests")

        If Not IsNothing(gvTests) And Not IsNothing(ViewState("sessionTest" & ((detailIndex * -1) - 1)).ToString()) Then
            Dim dt As DataTable = ViewState("sessionTest" & (detailIndex * -1) - 1)
            gvTests.EditIndex = -1
            gvTests.DataSource = dt
            gvTests.DataBind()
        End If

    End Sub

#End Region

#End Region

    Protected Sub btnCancelYes_Click(sender As Object, e As EventArgs) Handles btnCancelYes.ServerClick
        If ViewState(CALLER).ToString().EqualsAny({CallerPages.HumanActiveSurveillanceCampaign, CallerPages.HumanActiveSurveillanceSessionSearch}) Then
            oCommon.SaveViewState(ViewState)
            Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceCampaignUrl), True)
        Else
            oCommon = New clsCommon()
            oCommon.ResetForm(sessions)
            oCommon.ResetForm(sesLocInfo)
            hdfidfCampaign.Value = "NULL"
            hdfidfMonitoringSession.Value = "NULL"
            ViewState(campaign) = Nothing
            ViewState(sessionDetails) = Nothing
            ViewState(sessionActions) = Nothing
            ViewState(sessionSamples) = Nothing
            sessions.Visible = False
            searchForm.Visible = True
            hdgActiveSurveillanceSession.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            hdgActiveSurveillanceSessionReview.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            searchResults.Visible = True
            If Not IsNothing(ViewState(results)) Then
                gvSearchResults.DataSource = ViewState(results)
                gvSearchResults.DataBind()
            Else
                fillSessionGV(True)
            End If
        End If
    End Sub







    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click

        Try
            Dim values As String = String.Empty
            showHideSectionsandSidebarItems()

            If sLI.SelectedCountryValue = "null" Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Country.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If

            If sLI.SelectedRegionValue = "null" Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Region.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If

            If Not validateDates(txtdatStartDate.Text, txtdatEndDate.Text, False) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Date.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If

            'Validate Disease Here
            If ddlidfsDiagnosis.SelectedValue = "null" Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Disease.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                Exit Sub
            End If


            If Not IsNothing(ViewState(campaign)) And Not hdfidfCampaign.Value.Equals({"0", "NULL"}) Then
                Dim ds As DataSet = ViewState(campaign)
                Dim dr As DataRow = ds.Tables(0).Rows(0)
                Dim campaignStartDate As DateTime = Nothing
                Dim campaignEndDate As DateTime = Nothing



                If Not IsNothing(dr) Then

                    If Not IsDBNull(dr(ActiveSurveillanceCampaignConstants.StartDate)) Then
                        campaignStartDate = dr(ActiveSurveillanceCampaignConstants.StartDate)
                    End If

                    If Not IsDBNull(dr(ActiveSurveillanceCampaignConstants.EndDate)) Then
                        campaignEndDate = dr(ActiveSurveillanceCampaignConstants.EndDate)
                    End If

                    Dim sessionStartDate As DateTime = Nothing
                        Dim sessionEndDate As DateTime = Nothing

                        If Not String.IsNullOrEmpty(txtdatStartDate.Text) Then
                            sessionStartDate = Convert.ToDateTime(txtdatStartDate.Text)
                        If sessionStartDate < campaignStartDate Then
                            lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Session_Campaign_Date.InnerText")
                            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                            Exit Sub
                        End If

                    End If

                        If Not String.IsNullOrEmpty(txtdatEndDate.Text) Then
                            sessionEndDate = Convert.ToDateTime(txtdatEndDate.Text)
                        If sessionEndDate > campaignEndDate Then
                            lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Session_Campaign_Date.InnerText")
                            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                            Exit Sub
                        End If
                    End If
                    End If
                End If



                oCommon = New clsCommon()
            Dim asp() As String = oCommon.GetSPList("HumanActiveSurvSessionSet")
            values = oCommon.Gather(sesInfo, asp(0), 3, True)

            values = values & "|" & oCommon.Gather(sesLocInfo, asp(0), 6, True)

            hdfidfsSite.Value = hdfidfsSiteAK.Value
            values = values & "|" & oCommon.Gather(divHiddenFieldsSection, asp(0), 3, True)


            Dim oHASC As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
            Dim oReturnValues As Object() = Nothing
            Dim result As Integer = oHASC.AddUpdateHASS(values, oReturnValues)
            If result > -1 Then
                If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceEditCampaignSession Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceReturnToCampaignSessions Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceEditCampaignSession Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaign Then
                    btnRTCR.Visible = True
                End If
                If hdfidfMonitoringSession.Value = "NULL" Then
                    hdfidfMonitoringSession.Value = result.ToString()
                    'hdfstrMonitoringSessionID.Value = oReturnValues(1)
                    fillSamples()
                    'lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Creation.InnerText") & " The Campaign ID is " & oReturnValues(0).ToString() & "."
                    lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Creation.InnerText") & "."

                Else
                    fillSamples()
                    fillDetails()
                    fillActions()
                    'lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Update.InnerText") & oReturnValues(0).ToString() & "."
                    lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Update.InnerText") & "."

                End If
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & successSession.ClientID & "');});", True)


                txtDIdatCollectionDate.MinDate = txtdatStartDate.Text
                Dim sessionEndDate As DateTime = Convert.ToDateTime(txtdatEndDate.Text)

                If sessionEndDate < DateTime.Today Then
                    txtDIdatCollectionDate.MaxDate = txtdatEndDate.Text
                End If

                txtdatTestResultDate.MaxDate = txtDIdatCollectionDate.MaxDate
            Else
                If (Not String.IsNullOrEmpty(hdfidfMonitoringSession.Value)) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_No_Rows_Updated.InnerText")
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_No_Rows_Created.InnerText")
                End If
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
            End If
        Catch ex As Exception
            If hdfidfMonitoringSession.Value <> "NULL" Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Update.InnerText")
            Else
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Add.InnerText")
            End If
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnShowCampaignInformation_Click(sender As Object, e As EventArgs) Handles btnShowCampaignInformation.Click
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "0"
        sessionDetail.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)
        campaignInformationStatus.Attributes.Remove("class")

        If hdfSessionInformationDisplay.Value = "none" Then
            sessionDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            hdfSessionInformationDisplay.Value = "block"
            campaignInformationStatus.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
        Else
            sessionDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            hdfSessionInformationDisplay.Value = "none"
            campaignInformationStatus.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_Click(sender As Object, e As EventArgs) Handles btnDeleteYes.ServerClick
        Try
            Dim oHASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
            Dim id As Double = Convert.ToInt64(hdfidfMonitoringSession.Value)

            oHASS.Delete(id)
            If hdfDeleteSessionFromSearchResults.Value Then
                gvSearchResults.DeleteRow(Convert.ToInt32(hdfSessionSearchIndex.Value))
                hdfSessionSearchIndex.Value = "NULL"
                hdfDeleteSessionFromSearchResults.Value = False
            Else
                sessions.Visible = False
                searchForm.Visible = True
                lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Deletion.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & successDeleteSession.ClientID & "');});", True)
            End If
            hdfidfMonitoringSession.Value = "NULL"
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Deletion.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnReturnToSearch_Click(sender As Object, e As EventArgs) Handles btnReturnToSearch.ServerClick, btnReturntoSearchResults.ServerClick

        sessions.Visible = False
        searchForm.Visible = True
        btnShowSearchCriteria.Visible = True
        btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        showClearandSearchButtons(False)
        showSearchCriteria(False)
        resetSession()
        hdfidfMonitoringSession.Value = "NULL"
        hdfidfCampaign.Value = "NULL"

        If Not IsNothing(ViewState(results)) Then
            gvSearchResults.DataSource = ViewState(results)
            gvSearchResults.DataBind()
        Else
            fillSessionGV(True)
        End If
    End Sub

    Protected Sub btnRTCR_Click(sender As Object, e As EventArgs) Handles btnRTCR.ServerClick
        ViewState(CALLER_KEY) = hdfidfCampaign.Value
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceCampaignUrl), True)
    End Sub

    Protected Sub btnRTSR_Click(sender As Object, e As EventArgs) Handles btnRTSR.ServerClick
        ViewState(CALLER_KEY) = hdfidfMonitoringSession.Value

        ViewState(campaign) = Nothing
        ViewState(sessionSamples) = Nothing
        Dim dt As DataTable = ViewState(sessionDetails)
        If Not IsNothing(ViewState(sessionDetails)) Then
            For i As Integer = 0 To dt.Rows.Count() - 1
                Dim rowPos As Integer = ((i * -1) - 1).ToString()
                ViewState("sessionTest" & rowPos) = Nothing
            Next
        End If
        ViewState(sessionDetails) = Nothing
        ViewState(sessionActions) = Nothing
        ViewState(sessionTests) = Nothing
        fillSession()

        If hdfDiseaseSelected.Value <> "null" Then
            ddlidfsDiagnosis.SelectedItem.Text = hdfDiseaseSelected.Value
        End If


        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "0"
        hdgActiveSurveillanceSessionReview.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        hdgActiveSurveillanceSession.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
    End Sub

    Protected Sub btnRtD_Click(sender As Object, e As EventArgs) Handles btnRtD.ServerClick
        clearAndReset()
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.DashboardURL), False)
    End Sub

    Protected Sub btnDelete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click
        showHideSectionsandSidebarItems()
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteSession');});", True)
    End Sub

#End Region

#Region "Gridview"

#Region "Search Results"

    Protected Sub gvSearchResults_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles gvSearchResults.SelectedIndexChanging
        If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaign Then
            ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSession
            ViewState(CALLER_KEY) = hdfidfMonitoringSession.Value
            oCommon.SaveViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceCampaignUrl), True)
        ElseIf ViewState(CALLER).ToString().EqualsAny({CallerPages.HumanActiveSurveillanceSessionSearch, CallerPages.HumanActiveSurveillanceReturnToCampaignSessions}) Then
            Try
                Dim sessionId As Double = gvSearchResults.DataKeys(e.NewSelectedIndex).Values(0)
                Dim cID As Double = Convert.ToDouble(hdfidfCampaign.Value)

                Dim OHASC As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
                OHASC.SessionToCampaign(cID, sessionId)

                ViewState(CALLER) = CallerPages.HumanActiveSurveillanceReturnToCampaignSessions
                ViewState(CALLER_KEY) = hdfidfCampaign.Value
                oCommon.SaveViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceCampaignUrl), False)
            Catch
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Search.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
            End Try
        End If
    End Sub

    Protected Sub gvSearchResults_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSearchResults.PageIndexChanging
        gvSearchResults.PageIndex = e.NewPageIndex
        fillSessionGV(bRefresh:=False)
    End Sub

    Protected Sub gvSearchResults_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvSearchResults.Sorting
        Dim sortedView As DataView = New DataView(ViewState(results))
        Dim sortDir As String = setSortDirection(e)
        sortedView.Sort = e.SortExpression + " " + sortDir
        gvSearchResults.DataSource = sortedView
        gvSearchResults.DataBind()
        ViewState(results) = sortedView.Table
    End Sub

    Protected Sub gvSearchResults_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnSelect As LinkButton = e.Row.FindControl("btnSelect")
            Dim lblstrMonitoringSessionID As Label = e.Row.FindControl("lblstrMonitoringSessionID")
            If Not IsNothing(btnSelect) And Not IsNothing(lblstrMonitoringSessionID) Then
                If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionSearch Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceReturnToCampaignSessions Then
                    btnSelect.Visible = True
                    lblstrMonitoringSessionID.Visible = False
                Else
                    btnSelect.Visible = False
                    lblstrMonitoringSessionID.Visible = True
                End If
            End If
        End If
    End Sub

    Protected Sub gvSearchResults_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvSearchResults.RowEditing
        e.Cancel = True
        Try

            'Add buttons for side bar
            btnPreviousSection.Visible = True 'Added for Test AK Looks Good
            btnNextSection.Visible = True 'Should go to Review Screen - Or the same as Go TO 1

            oCommon = New clsCommon()
            Dim sessionId As Double = Convert.ToInt64(gvSearchResults.DataKeys(e.NewEditIndex).Value)
            hdfidfMonitoringSession.Value = sessionId
            fillSession()
            '            fillSessionApi(sessionId)

            hdnPanelController.Value = "0"
        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)

            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Search.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
            Throw ex
        End Try
    End Sub

    Protected Sub gvSearchResults_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvSearchResults.RowDeleting
        hdfSessionSearchIndex.Value = e.RowIndex.ToString()
        hdfDeleteSessionFromSearchResults.Value = True
        hdfidfMonitoringSession.Value = gvSearchResults.DataKeys(e.RowIndex).Value
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteSession');});", True)
    End Sub

#End Region

#Region "Session"

#Region "Samples"

    Protected Sub gvSamples_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvSamples.RowCancelingEdit
        'Do not remove. Cancel Row Update Will Not Work Properly
    End Sub

    Protected Sub gvSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSamples.RowCommand
        showHideSectionsandSidebarItems()

        hdnPanelController.Value = "1"

        oCommon = New clsCommon()
        oService = oCommon.GetService()

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim dt As DataTable = ViewState(sessionSamples)

        Select Case e.CommandName
            Case "delete"
                Try

                    Dim sampleTypeID As Double = gvSamples.DataKeys(index).Value

                    hdfSessionSampleTypeIndex.Value = e.CommandArgument.ToString()
                    hdfSessionSampleTypeID.Value = sampleTypeID.ToString

                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteSampleType');});", True)
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Delete.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
            Case "edit"
                Try
                    gvSamples.EditIndex = index
                    gvSamples.Rows(index).RowState = DataControlRowState.Edit

                    gvSamples.DataSource = dt
                    gvSamples.DataBind()
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Edit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
            Case "update"
                Try
                    Dim ddlSampleType As DropDownList = gvSamples.Rows(index).FindControl("ddlSampleType")
                    If Not IsNothing(ddlSampleType) Then
                        dt(index)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID) = ddlSampleType.SelectedValue
                        dt(index)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleType) = ddlSampleType.SelectedItem.Text
                    End If

                    gvSamples.EditIndex = -1
                    gvSamples.DataSource = dt
                    gvSamples.DataBind()
                    ViewState(sessionSamples) = dt
                    populateSampleTypeAdd()
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Update.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
            Case "cancel"
                Try
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('cancelSampleType');});", True)
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Cancel.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
            Case "insert"
                Try
                    showHideSectionsandSidebarItems()
                    hdnPanelController.Value = "1"

                    Dim ddlSampleType As DropDownList = gvSamples.HeaderRow.FindControl("ddlSampleType")
                    If (ddlSampleType.SelectedValue = "null") Then
                        lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Sample.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                        Exit Sub
                    Else
                        If IsNothing(ViewState(sessionSamples)) Then
                            dt = New DataTable()
                            dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType)
                            dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.MonitoringSession)
                            dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeID)
                            dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesType)
                            dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID)
                            dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleType)
                            dt.Columns.Add(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.Order)
                        Else
                            dt = ViewState(sessionSamples)
                        End If

                        If hdfidfMonitoringSession.Value = "NULL" Then
                            dt.Rows.Add(-1, 0, Nothing, Nothing, ddlSampleType.SelectedValue, ddlSampleType.SelectedItem.Text, dt.Rows.Count)
                        Else
                            dt.Rows.Add(-1, hdfidfMonitoringSession.Value, Nothing, Nothing, ddlSampleType.SelectedValue, ddlSampleType.SelectedItem.Text, dt.Rows.Count)
                        End If
                        'Set session 
                        ViewState(sessionSamples) = dt

                        'Set gridview to  Samples 
                        gvSamples.DataSource = dt
                        gvSamples.DataBind()

                        ddlSampleType.SelectedIndex = 0

                        populateSampleTypeAdd()
                        showOrHideSampleTypeIcons(True)
                        fillSampleTypes(ddlDIidfsSampleType, dt)
                    End If

                Catch ex As Exception
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Adding_Sample.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
        End Select

    End Sub

    Protected Sub gvSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSamples.RowDataBound
        Dim ddlSampleType As DropDownList = e.Row.FindControl("ddlSampleType")
        If Not IsNothing(ddlSampleType) Then
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                FillDropDown(ddlSampleType, GetType(clsSampleDisease), {ddlidfsDiagnosis.SelectedValue}, ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID, ActiveSurveillanceCampaignToSampleTypeConstants.SampleType, dr("idfsSampleType").ToString(), Nothing, True)

            ElseIf e.Row.RowType = DataControlRowType.Header Then
                FillDropDown(ddlSampleType, GetType(clsSampleDisease), {ddlidfsDiagnosis.SelectedValue}, ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID, ActiveSurveillanceCampaignToSampleTypeConstants.SampleType, Nothing, Nothing, True)
            End If
            disableEditSelectedSampleTypes(ddlSampleType)
        End If
    End Sub

    Protected Sub gvSamples_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvSamples.RowDeleting
        'Do not remove. Delete Row will Not Work Properly
    End Sub

    Protected Sub gvSamples_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvSamples.RowEditing
        'Do not remove. Edit Row Will Not Work Properly
    End Sub

    Protected Sub gvSamples_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvSamples.RowUpdating
        'Do not remove. Update Row Will Not Work Properly
    End Sub

#End Region

#Region "Detailed Information"

    Protected Sub gvDetailInformation_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvDetailInformation.RowCancelingEdit
        'Do not remove. Necessary for Cancelling Changes
    End Sub

    Protected Sub gvDetailInformation_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetailInformation.RowCommand
        showHideSectionsandSidebarItems()

        hdnPanelController.Value = "2"

        oCommon = New clsCommon()
        oService = oCommon.GetService()

        Dim detailIndex As Integer = Convert.ToInt32(e.CommandArgument)
        Dim dt As DataTable = ViewState(sessionDetails)

        Select Case e.CommandName
            Case "delete"
                hdfSessionDetailID.Value = gvDetailInformation.DataKeys(detailIndex).Value.ToString()
                hdfSessionDetailIndex.Value = detailIndex.ToString()
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteDetail');});", True)
            Case "edit"
                Try
                    gvDetailInformation.EditIndex = detailIndex
                    gvDetailInformation.DataSource = dt
                    gvDetailInformation.DataBind()
                    gvDetailInformation.Columns(5).Visible = False
                    showOrHideTestGridExist(detailIndex, False)
                Catch
                    gvDetailInformation.EditIndex = -1
                    gvDetailInformation.DataSource = dt
                    gvDetailInformation.DataBind()
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Detail_Edit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                    Exit Sub
                End Try
            Case "update"
                Try
                    Dim ddlidfsSendToOffice As DropDownList = gvDetailInformation.Rows(detailIndex).FindControl("ddlidfsSendToOffice")
                    If Not IsNothing(ddlidfsSendToOffice) Then
                        dt.Rows(detailIndex)(MaterialConstants.SendToOfficeID) = ddlidfsSendToOffice.SelectedValue
                        dt.Rows(detailIndex)(MaterialConstants.SendToOffice) = ddlidfsSendToOffice.SelectedItem.Text
                    End If

                    Dim ddlSampleType As DropDownList = gvDetailInformation.Rows(detailIndex).FindControl("ddlSampleType")
                    If Not IsNothing(ddlSampleType) Then
                        dt.Rows(detailIndex)(MaterialConstants.SampleTypeID) = ddlSampleType.SelectedValue
                        dt.Rows(detailIndex)(MaterialConstants.SampleType) = ddlSampleType.SelectedItem.Text
                    End If

                    Dim txtdatFieldCollectionDate As EIDSSControlLibrary.CalendarInput = gvDetailInformation.Rows(detailIndex).FindControl("txtdatFieldCollectionDate")
                    If Not IsNothing("txtdatFieldCollectionDate") Then
                        dt.Rows(detailIndex)(MaterialConstants.FieldCollectionDate) = txtdatFieldCollectionDate.Text
                    End If

                    gvDetailInformation.EditIndex = -1

                    gvDetailInformation.DataSource = dt
                    gvDetailInformation.DataBind()
                    ViewState(sessionDetails) = dt
                    gvDetailInformation.Columns(5).Visible = True
                Catch ex As Exception
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Detail_Update.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
            Case "cancel"
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelDetail');});", True)
            Case "showTest"
                Try
                    hdfDetailRowIndex.Value = detailIndex.ToString()
                    txtdatTestResultDate.MinDate = String.Format("{0:MM/dd/yyyy}", dt.Rows(detailIndex)(MaterialConstants.FieldCollectionDate))
                    txtdatTestResultDate.MaxDate = String.Format("{0:MM/dd/yyyy}", DateTime.Today)
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & testDetails.ClientID & "');});", True)
                Catch ex As Exception

                End Try
        End Select
    End Sub

    Private Sub gvDetailInformation_RowCreated(sender As Object, e As GridViewRowEventArgs) Handles gvDetailInformation.RowCreated
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim gvTests As EIDSSControlLibrary.GridView = e.Row.FindControl("gvTests")
            If Not IsNothing(gvTests) Then
                AddHandler gvTests.RowCommand, AddressOf gvTests_RowCommand
                AddHandler gvTests.RowDeleting, AddressOf gvTests_RowDeleting
                AddHandler gvTests.RowDataBound, AddressOf gvTests_RowDataBound
                AddHandler gvTests.RowEditing, AddressOf gvTests_RowEditing
                AddHandler gvTests.RowUpdating, AddressOf gvTests_RowUpdating
                AddHandler gvTests.RowCancelingEdit, AddressOf gvTests_RowCancelingEdit
            End If
        End If
    End Sub

    Protected Sub gvDetailInformation_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDetailInformation.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)

            Dim ddlSampleType As DropDownList = e.Row.FindControl("ddlidfsSampleType")
            If Not IsNothing(ddlSampleType) Then
                fillSampleTypes(ddlSampleType, ViewState(sessionSamples))
                ddlSampleType.SelectedValue = dr(MaterialConstants.SampleTypeID)
                ddlSampleType.ToolTip = dr(MaterialConstants.SampleType)
            End If

            Dim ddlidfsSendToOffice As DropDownList = e.Row.FindControl("ddlidfsSendToOffice")
            If Not IsNothing(ddlidfsSendToOffice) Then
                FillDropDown(ddlidfsSendToOffice, GetType(clsOrganization), Nothing, OrganizationConstants.idfInstitution, OrganizationConstants.OrgFullName, dr(MaterialConstants.SendToOfficeID), Nothing, False)
                ddlidfsSendToOffice.ToolTip = dr(MaterialConstants.SendToOffice)
            End If

            Dim ddlidfsFieldCollectedByPerson As DropDownList = e.Row.FindControl("ddlidfsFieldCollectedByPerson")
            If Not IsNothing(ddlidfsFieldCollectedByPerson) Then
                FillDropDown(ddlidfsFieldCollectedByPerson, GetType(clsEmployee), {"@LangId;EN;IN"}, EmployeeConstants.idfEmployee, EmployeeConstants.FullName, dr(MaterialConstants.FieldCollectedByPersonID), Nothing, True)
                ddlidfsFieldCollectedByPerson.ToolTip = dr(MaterialConstants.FieldCollectedByPerson)
            End If

            Dim txtdatFieldCollectionDate As EIDSSControlLibrary.CalendarInput = e.Row.FindControl("txtdatFieldCollectionDate")
            If Not IsNothing(txtdatFieldCollectionDate) Then
                txtdatFieldCollectionDate.Text = dr(MaterialConstants.FieldCollectionDate)
                txtdatFieldCollectionDate.ToolTip = String.Format("{0:MM/dd/yyyy}", dr(MaterialConstants.FieldCollectionDate))
            End If

            Dim gvTests As EIDSSControlLibrary.GridView = e.Row.FindControl("gvTests")
            If Not IsNothing(gvTests) Then

                Dim dt As DataTable
                Dim paramNames As String() = {TestConstants.TestingID, TestConstants.MaterialID, TestConstants.TestNameID, TestConstants.TestName, TestConstants.TestCategoryID, TestConstants.TestCategory, TestConstants.TestResultID, TestConstants.TestResult, TestConstants.ConclusionDate}

                If Not IsNothing(ViewState("sessionTest" & ((e.Row.DataItemIndex * -1) - 1).ToString())) Then
                    dt = ViewState("sessionTest" & ((e.Row.DataItemIndex * -1) - 1).ToString())
                Else
                    dt = New DataTable()
                    For i As Integer = 0 To paramNames.Count() - 1
                        dt.Columns.Add(paramNames(i))
                    Next
                    If Not IsNothing(ViewState(sessionTests)) Then
                        Dim sTDT As DataTable = ViewState(sessionTests)
                        Dim sDr As DataRow() = sTDT.Select(TestConstants.MaterialID & "=" & dr(MaterialConstants.Material) & " and " & TestConstants.TestingID & " IS NOT NULL")
                        If (sDr.Count() > 0) Then
                            dt = sDr.CopyToDataTable()
                            ViewState("sessionTest" & ((e.Row.DataItemIndex * -1) - 1).ToString()) = dt
                        End If
                    End If
                End If

                gvTests.DataSource = dt
                gvTests.DataBind()
                If Not IsNothing(ddlSampleType) Then
                    If dt.Rows.Count() > 0 Then
                        ddlSampleType.Enabled = False
                    Else
                        ddlSampleType.Enabled = True
                    End If
                End If
            End If
        End If
    End Sub

    Protected Sub gvDetailInformation_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDetailInformation.RowDeleting
        'Do not remove. Necessary for Deleting
    End Sub

    Protected Sub gvDetailInformation_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvDetailInformation.RowEditing
        'Do not remove. Necessary for Editing
    End Sub

    Protected Sub gvDetailInformation_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvDetailInformation.RowUpdating
        'Do not remove. Necessary for Updating
    End Sub

#Region "Test Details"

    Protected Sub gvTests_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        showHideSectionsandSidebarItems()

        hdnPanelController.Value = "2"

        oCommon = New clsCommon()
        oService = oCommon.GetService()

        Dim gvTest As EIDSSControlLibrary.GridView = sender
        Dim gvr As GridViewRow = gvTest.Parent.Parent
        Dim parentRowIndex As Integer = 0
        If gvr.GetType() Is GetType(WebControls.GridViewRow) Then
            parentRowIndex = gvr.RowIndex
        End If

        Dim testIndex As Integer = Convert.ToInt32(e.CommandArgument)
        Dim dt As DataTable = ViewState("sessionTest" & ((parentRowIndex * -1) - 1))

        hdfSessionTestIndex.Value = e.CommandArgument
        hdfSessionDetailIndex.Value = parentRowIndex

        Select Case e.CommandName
            Case "delete"
                Try
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteTest');});", True)
                Catch

                End Try
            Case "edit"
                Try
                    gvTest.EditIndex = testIndex
                    gvTest.Rows(testIndex).RowState = DataControlRowState.Edit

                    gvTest.DataSource = dt
                    gvTest.DataBind()
                Catch

                End Try
            Case "update"
                Try
                    Dim ddlidfsTestCategory As DropDownList = gvTest.Rows(testIndex).FindControl("ddlidfsTestCategory")
                    If Not IsNothing(ddlidfsTestCategory) Then
                        dt.Rows(testIndex)(TestConstants.TestCategoryID) = ddlidfsTestCategory.SelectedValue
                        dt.Rows(testIndex)(TestConstants.TestCategory) = ddlidfsTestCategory.SelectedItem.Text
                    End If

                    Dim ddlidfsTestResult As DropDownList = gvTest.Rows(testIndex).FindControl("ddlidfsTestResult")
                    If Not IsNothing(ddlidfsTestCategory) Then
                        dt.Rows(testIndex)(TestConstants.TestResultID) = ddlidfsTestResult.SelectedValue
                        dt.Rows(testIndex)(TestConstants.TestResult) = ddlidfsTestResult.SelectedItem.Text
                    End If

                    Dim ddlidfsTestName As DropDownList = gvTest.Rows(testIndex).FindControl("ddlidfsTestName")
                    If Not IsNothing(ddlidfsTestName) Then
                        dt.Rows(testIndex)(TestConstants.TestNameID) = ddlidfsTestName.SelectedValue
                        dt.Rows(testIndex)(TestConstants.TestName) = ddlidfsTestName.SelectedItem.Text
                    End If

                    Dim txtdatConcludedDate As EIDSSControlLibrary.CalendarInput = gvTest.Rows(testIndex).FindControl("txtdatConcludedDate")
                    If Not IsNothing(txtdatConcludedDate) Then
                        dt.Rows(testIndex)(TestConstants.ConclusionDate) = txtdatConcludedDate.Text
                    End If

                    gvTest.EditIndex = -1

                    gvTest.DataSource = dt
                    gvTest.DataBind()
                Catch

                End Try
            Case "cancel"
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelTest');});", True)
        End Select

        ViewState("sessionTest" & ((parentRowIndex * -1) - 1)) = dt
    End Sub

    Protected Sub gvTests_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
            Dim ddlidfsTestCategory As DropDownList = e.Row.FindControl("ddlidfsTestCategory")
            If Not IsNothing(ddlidfsTestCategory) Then
                BaseReferenceLookUp(ddlidfsTestCategory, BaseReferenceConstants.TestCategory, HACodeList.HumanHACode, True)
                ddlidfsTestCategory.SelectedValue = dr(TestConstants.TestCategoryID)
                ddlidfsTestCategory.ToolTip = dr(TestConstants.TestCategory)
            End If
            Dim ddlidfsTestResult As DropDownList = e.Row.FindControl("ddlidfsTestResult")
            If Not IsNothing(ddlidfsTestCategory) Then
                BaseReferenceLookUp(ddlidfsTestResult, BaseReferenceConstants.TestResult, HACodeList.HumanHACode, True)
                ddlidfsTestResult.SelectedValue = dr(TestConstants.TestResultID)
                ddlidfsTestResult.ToolTip = dr(TestConstants.TestResult)
            End If
            Dim ddlidfsTestName As DropDownList = e.Row.FindControl("ddlidfsTestName")
            If Not IsNothing(ddlidfsTestName) Then
                BaseReferenceLookUp(ddlidfsTestName, BaseReferenceConstants.TestName, HACodeList.ASHACode, True)
                ddlidfsTestName.SelectedValue = dr(TestConstants.TestNameID)
                ddlidfsTestName.ToolTip = dr(TestConstants.TestName)
            End If
            Dim txtdatConcludedDate As EIDSSControlLibrary.CalendarInput = e.Row.FindControl("txtdatConcludedDate")
            If Not IsNothing(txtdatConcludedDate) Then
                txtdatConcludedDate.Text = dr(TestConstants.ConclusionDate)
                txtdatConcludedDate.ToolTip = String.Format("{0:MM/dd/yyyy}", dr(TestConstants.ConclusionDate))
            End If
        End If
    End Sub

    Protected Sub gvTests_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        'Do not remove. Necessary for Deleting
    End Sub

    Protected Sub gvTests_RowEditing(sender As Object, e As GridViewEditEventArgs)
        'Do not remove. Necessary for Editing
    End Sub

    Protected Sub gvTests_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        'Do not remove. Necessary for Editing
    End Sub

    Protected Sub gvTests_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        'Do not remove. Necessary for Updating
    End Sub

#End Region

#End Region

#Region "Actions"

    Protected Sub gvActions_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvActions.RowCancelingEdit
        'Do not remove. Cancel Row Update Will Not Work Properly
    End Sub

    Protected Sub gvActions_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvActions.RowCommand
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "3"

        oCommon = New clsCommon()
        oService = oCommon.GetService()

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim dt As DataTable = ViewState(sessionActions)
        hdfSessionActionIndex.Value = index.ToString()
        Select Case e.CommandName
            Case "edit"
                Try
                    gvActions.EditIndex = index
                    gvActions.Rows(index).RowState = DataControlRowState.Edit

                    gvActions.DataSource = dt
                    gvActions.DataBind()
                    btnNewAction.Visible = False
                Catch ex As Exception
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Action.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
            Case "delete"
                Dim actionId As Double = gvActions.DataKeys(index).Value
                hdfSessionActionID.Value = actionId.ToString()

                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteAction');});", True)
                showHideSectionsandSidebarItems()
            Case "update"
                Try
                    Dim ddlMonitoringSessionActionStatus As DropDownList = gvActions.Rows(index).FindControl("ddlMonitoringSessionActionStatus")
                    If Not IsNothing(ddlMonitoringSessionActionStatus) Then
                        dt.Rows(index)(MonitoringSessionActionConstants.MonitoringSessionStatusTypeID) = ddlMonitoringSessionActionStatus.SelectedValue
                        dt.Rows(index)(MonitoringSessionActionConstants.MonitoringSessionStatusTypeName) = ddlMonitoringSessionActionStatus.SelectedItem.Text
                    End If

                    Dim ddlMonitoringSessionActionType As DropDownList = gvActions.Rows(index).FindControl("ddlMonitoringSessionActionType")
                    If Not IsNothing(ddlMonitoringSessionActionType) Then
                        dt.Rows(index)(MonitoringSessionActionConstants.MonitoringSessionActionTypeID) = ddlMonitoringSessionActionType.SelectedValue
                        dt.Rows(index)(MonitoringSessionActionConstants.MonitoringSessionActionTypeName) = ddlMonitoringSessionActionType.SelectedItem.Text
                    End If

                    Dim ddlPersonEnteredBy As DropDownList = gvActions.Rows(index).FindControl("ddlPersonEnteredBy")
                    If Not IsNothing(ddlPersonEnteredBy) Then
                        dt.Rows(index)(MonitoringSessionActionConstants.PersonEnteredByID) = ddlPersonEnteredBy.SelectedValue
                        dt.Rows(index)(MonitoringSessionActionConstants.PersonName) = ddlPersonEnteredBy.SelectedItem.Text
                    End If

                    Dim txtdatActionDate As EIDSSControlLibrary.CalendarInput = gvActions.Rows(index).FindControl("txtdatActionDate")
                    If Not IsNothing(txtdatActionDate) Then
                        Dim actionDate As DateTime
                        If DateTime.TryParse(txtdatActionDate.Text, actionDate) Then
                            txtdatActionDate.MaxDate = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
                            dt.Rows(index)(MonitoringSessionActionConstants.ActionDate) = actionDate
                        End If
                    End If

                    Dim txtComments As TextBox = gvActions.Rows(index).FindControl("txtComments")
                    If Not IsNothing(txtComments) Then
                        dt.Rows(index)(MonitoringSessionActionConstants.Comment) = txtComments.Text
                    End If

                    gvActions.EditIndex = -1
                    gvActions.DataSource = dt
                    gvActions.DataBind()
                    ViewState(sessionActions) = dt

                    btnNewAction.Visible = True
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Action.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
            Case "cancel"
                Try
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelAction');});", True)
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancelling_Action.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorSession.ClientID & "');});", True)
                End Try
        End Select
    End Sub

    Protected Sub gvActions_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvActions.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim ddlMonitoringSessionActionStatus As DropDownList = e.Row.FindControl("ddlMonitoringSessionActionStatus")
            If Not IsNothing(ddlMonitoringSessionActionStatus) Then
                BaseReferenceLookUp(ddlMonitoringSessionActionStatus, BaseReferenceConstants.ASSessionActionStatus, 34, False)
                Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                ddlMonitoringSessionActionStatus.SelectedValue = dr(MonitoringSessionActionConstants.MonitoringSessionStatusTypeID).ToString()
                ddlMonitoringSessionActionStatus.ToolTip = dr(MonitoringSessionActionConstants.MonitoringSessionStatusTypeName)

            End If

            Dim ddlMonitoringSessionActionType As DropDownList = e.Row.FindControl("ddlMonitoringSessionActionType")
            If Not IsNothing(ddlMonitoringSessionActionType) Then
                BaseReferenceLookUp(ddlMonitoringSessionActionType, BaseReferenceConstants.ASSessionActionType, 34, False)
                Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                ddlMonitoringSessionActionType.SelectedValue = dr(MonitoringSessionActionConstants.MonitoringSessionActionTypeID).ToString()
                ddlMonitoringSessionActionType.ToolTip = dr(MonitoringSessionActionConstants.MonitoringSessionActionTypeName)
            End If

            Dim ddlPersonEnteredBy As DropDownList = e.Row.FindControl("ddlPersonEnteredBy")
            If Not IsNothing(ddlPersonEnteredBy) Then
                FillDropDown(ddlPersonEnteredBy, GetType(clsOrgPerson), {hdfinstitution.Value}, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
                Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                ddlPersonEnteredBy.SelectedValue = dr(MonitoringSessionActionConstants.PersonEnteredByID).ToString()
                ddlPersonEnteredBy.ToolTip = dr("strPersonEnteredBy")
            End If
        End If
    End Sub

    Protected Sub gvActions_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        'Do not remove. Delete Row Will Not Work Properly
    End Sub

    Protected Sub gvActions_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvActions.RowEditing
        'Do not remove. Edit Row Will Not Work Properly
    End Sub

    Protected Sub gvActions_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvActions.RowUpdating
        'Do not remove. Update Row Will Not Work Properly
    End Sub

#End Region

#End Region

#End Region

#Region "Checkbox"

    Protected Sub rdbActionEntries_CheckedChanged(sender As Object, e As EventArgs) Handles rdbActionEntriesNo.CheckedChanged, rdbActionEntriesYes.CheckedChanged, rdbActionEntriesUnknown.CheckedChanged
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "2"
        If rdbActionEntriesYes.Checked Then
            actionReq.Visible = True
            btnCreateActions.Visible = True
        Else
            actionReq.Visible = False
            btnCreateActions.Visible = False
        End If
    End Sub

#End Region

#Region "Dropdown List"

    Protected Sub ddlidfsDiagnosis_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsDiagnosis.SelectedIndexChanged
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "0"
        If ddlidfsDiagnosis.SelectedValue <> "null" Then
            populateSampleTypeAdd()
            hdfDiseaseSelected.Value = ddlidfsDiagnosis.SelectedItem.Text
        Else
            fillSearchDropdowns()
        End If

    End Sub

#End Region

#Region "Multiple"

    Protected Sub searchCriteria_Changed(sender As Object, e As EventArgs) Handles txtMonitoringSessionstrID.TextChanged, ddlMonitoringSessionidfsDiagnosis.SelectedIndexChanged, ddlMonitoringSessionidfsStatus.SelectedIndexChanged
        searchResults.Visible = False
        searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
        btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        btnShowSearchCriteria.Visible = False
        showClearandSearchButtons(True)
    End Sub

#End Region

#Region "Private"

    Private Sub clearAndReset()
        ViewState(CALLER) = CallerPages.Dashboard
        ViewState(CALLER_KEY) = 0
        ViewState(campaign) = Nothing
        ViewState(sessionSamples) = Nothing
        Dim dt As DataTable = ViewState(sessionDetails)
        If Not IsNothing(ViewState(sessionDetails)) Then
            For i As Integer = 0 To dt.Rows.Count() - 1
                Dim rowPos As Integer = ((i * -1) - 1).ToString()
                ViewState("sessionTest" & rowPos) = Nothing
            Next
        End If
        ViewState(sessionDetails) = Nothing
        ViewState(sessionActions) = Nothing
        ViewState(sessionTests) = Nothing
        hdfidfMonitoringSession.Value = "NULL"
        hdfidfCampaign.Value = "NULL"
    End Sub

    Private Sub resetSession()
        ViewState(campaign) = Nothing
        ViewState(sessionSamples) = Nothing
        Dim dt As DataTable = ViewState(sessionDetails)
        If Not IsNothing(ViewState(sessionDetails)) Then
            For i As Integer = 0 To dt.Rows.Count() - 1
                Dim rowPos As Integer = ((i * -1) - 1).ToString()
                ViewState("sessionTest" & rowPos) = Nothing
            Next
        End If
        ViewState(sessionDetails) = Nothing
        ViewState(sessionActions) = Nothing
        ViewState(sessionTests) = Nothing
        hdfidfMonitoringSession.Value = "NULL"
        hdfidfCampaign.Value = "NULL"
    End Sub

    Private Sub disableSelectedSampleTypes(ByRef ddl As DropDownList)

        If Not IsNothing(ViewState(sessionSamples)) Then
            Dim dt As DataTable = ViewState(sessionSamples)
            For i As Integer = 0 To dt.Rows.Count() - 1
                Dim li As ListItem = ddl.Items.FindByValue(dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID))
                If Not IsNothing(li) Then
                    li.Enabled = False
                End If
            Next
        End If
    End Sub

    Private Sub disableEditSelectedSampleTypes(ByRef ddl As DropDownList)

        If Not IsNothing(ViewState(sessionSamples)) Then
            Dim dt As DataTable = ViewState(sessionSamples)
            For i As Integer = 0 To dt.Rows.Count() - 1
                Dim li As ListItem = ddl.Items.FindByValue(dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID))
                If Not IsNothing(li) Then
                    If li.Value <> ddl.SelectedValue Then
                        li.Enabled = False
                    End If
                End If
            Next
        End If
    End Sub

    Private Sub fillActions()
        Try
            If Not IsNothing(ViewState(sessionActions)) Then
                Dim dt As DataTable = ViewState(sessionActions)

                For i As Integer = 0 To dt.Rows.Count - 1
                    Dim sampleStringBuilder As StringBuilder = New StringBuilder()

                    If dt.Rows(i)(MonitoringSessionActionConstants.MonitoringSessionActionID) = -1 Then
                        sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.MonitoringSessionActionID & ";NULL;INOUT|")
                    Else
                        sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.MonitoringSessionActionID & ";" & dt.Rows(i)(MonitoringSessionActionConstants.MonitoringSessionActionID) & ";INOUT|")
                    End If
                    sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.MonitoringSessionID & ";" & hdfidfMonitoringSession.Value & ";IN|")
                    sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.PersonEnteredByID & ";" & dt.Rows(i)(MonitoringSessionActionConstants.PersonEnteredByID) & ";IN|")
                    sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.MonitoringSessionActionTypeID & ";" & dt.Rows(i)(MonitoringSessionActionConstants.MonitoringSessionActionTypeID) & ";IN|")
                    sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.MonitoringSessionStatusTypeID & ";" & dt.Rows(i)(MonitoringSessionActionConstants.MonitoringSessionStatusTypeID) & ";IN|")
                    sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.ActionDate & ";" & dt.Rows(i)(MonitoringSessionActionConstants.ActionDate) & ";IN|")
                    sampleStringBuilder.AppendFormat("@" & MonitoringSessionActionConstants.Comment & ";" & dt.Rows(i)(MonitoringSessionActionConstants.Comment) & ";IN")

                    Dim HASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
                    HASS.AddUpdateHAStoAction(sampleStringBuilder.ToString())
                Next
            End If
        Catch ex As Exception

        End Try

    End Sub

    Private Sub fillDetails()
        If Not IsNothing(ViewState(sessionDetails)) Then
            Dim dt As DataTable = ViewState(sessionDetails)

            For i As Integer = 0 To dt.Rows.Count() - 1

                Dim sampleStringBuilder As StringBuilder = New StringBuilder()

                If dt.Rows(i)(MaterialConstants.Material) = -1 Then
                    sampleStringBuilder.AppendFormat("@" & MaterialConstants.Material & ";NULL;INOUT|")
                    sampleStringBuilder.AppendFormat("@" & MaterialConstants.RecordAction & ";" & RecordConstants.Insert & ";IN|")
                Else
                    sampleStringBuilder.AppendFormat("@" & MaterialConstants.Material & ";" & dt.Rows(i)(MaterialConstants.Material) & ";INOUT|")
                    sampleStringBuilder.AppendFormat("@" & MaterialConstants.RecordAction & ";" & RecordConstants.Update & ";IN|")
                End If

                sampleStringBuilder.AppendFormat("@" & MaterialConstants.MonitoringSessionID & ";" & dt.Rows(i)(MaterialConstants.MonitoringSessionID) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & MaterialConstants.FieldBarCode & ";" & dt.Rows(i)(MaterialConstants.FieldBarCode) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & MaterialConstants.SendToOfficeID & ";" & dt.Rows(i)(MaterialConstants.SendToOfficeID) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & MaterialConstants.FieldCollectedByPersonID & ";" & dt.Rows(i)(MaterialConstants.FieldCollectedByPersonID) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & MaterialConstants.FieldCollectionDate & ";" & dt.Rows(i)(MaterialConstants.FieldCollectionDate) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & MaterialConstants.SampleTypeID & ";" & dt.Rows(i)(MaterialConstants.SampleTypeID) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & MaterialConstants.MaterialSiteID & ";" & Session("UserSite") & ";IN")

                oCommon = New clsCommon()
                oService = oCommon.GetService()
                Dim aSP As String() = oService.getSPList("HumanActiveSurvSessionToMaterial")
                Dim values As String = sampleStringBuilder.ToString() & "|" & oCommon.Gather(divHiddenMaterialSection, aSP(0), 3, True)
                Dim oHASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
                Dim materialID As Double = 0
                oHASS.AddUpdateHASStoMaterial(values, materialID)

                Dim mID As String = ((i * -1) - 1).ToString()
                If Not IsNothing(ViewState("sessionTest" & mID)) Then
                    Dim tDT As DataTable = ViewState("sessionTest" & mID)
                    fillTests(tDT, materialID)
                End If
            Next
        End If
    End Sub

    Private Sub fillSamples()
        If Not IsNothing(ViewState(sessionSamples)) Then
            Dim dt As DataTable = ViewState(sessionSamples)

            For i As Integer = 0 To dt.Rows.Count - 1
                Dim sampleStringBuilder As StringBuilder = New StringBuilder()

                If dt.Rows(i)(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType) = -1 Then
                    sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType & ";NULL;INOUT|")
                Else
                    sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType & ";" & dt.Rows(i)(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType) & ";INOUT|")
                End If

                If dt.Rows(i)(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType) = 0 Then
                    sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.MonitoringSession & ";NULL;IN|")
                Else
                    sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.MonitoringSession & ";" & hdfidfMonitoringSession.Value & ";IN|")
                End If

                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID & ";" & dt.Rows(i)(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeID & ";NULL;IN|")
                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.Order & ";" & dt.Rows(i)(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.Order) & ";IN")

                Dim HASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
                Dim oReturnValues As Object() = Nothing
                HASS.AddUpdateHASStoSample(sampleStringBuilder.ToString(), oReturnValues)
            Next
        End If
    End Sub

    Private Sub fillSampleTypes(ByRef ddl As DropDownList, ByVal dt As DataTable)
        ddl.Items.Clear()
        ddl.Items.Add(New ListItem("", "null"))
        ddl.AppendDataBoundItems = True
        ddl.DataSource = dt
        ddl.DataValueField = ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID
        ddl.DataTextField = ActiveSurveillanceCampaignToSampleTypeConstants.SampleType
        ddl.DataBind()
    End Sub

    Private Sub fillSearchDropdowns()
        BaseReferenceLookUp(ddlMonitoringSessionidfsStatus, BaseReferenceConstants.ASSessionStatus, HACodeList.ASHACode, True)
        BaseReferenceLookUp(ddlMonitoringSessionidfsDiagnosis, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
        getSearchFields()
    End Sub

    Private Sub fillSessionDropdowns()
        BaseReferenceLookUp(ddlidfsMonitoringSessionStatus, BaseReferenceConstants.ASSessionStatus, HACodeList.ASHACode, True)
        ddlidfsMonitoringSessionStatus.SelectedValue = ddlidfsMonitoringSessionStatus.Items.FindByText("Open").Value

        hdfidfsSite.Value = Session("UserSite")
        hdfidfsSiteAK.Value = Session("UserSite")

        hdfinstitution.Value = Session("Institution")
        hdfidfPersonEnteredBy.Value = Session("idfPerson")
        'hdfidfPersonEnteredBy.Value = Session("UserID").ToString()
        txtstrSite.Text = Session("Organization")
        txtstrOfficer.Text = Session("FirstName") & " " & Session("FamilyName")

        txtdatEnteredDate.Text = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
        txtdatActionDate.MaxDate = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
        txtDIdatCollectionDate.MaxDate = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
        txtdatTestResultDate.MaxDate = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
        FillDropDown(ddlidfsEnteredBy, GetType(clsOrgPerson), {hdfinstitution.Value}, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
        BaseReferenceLookUp(ddlidfsDiagnosis, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)

        FillDropDown(ddlDIstrPersonID, GetType(clsEmployee), {"@LangID;en;IN"}, EmployeeConstants.idfEmployee, EmployeeConstants.FullName, Nothing, Nothing, False)
        FillDropDown(ddlDIidfsOrganizationID, GetType(clsOrganization), Nothing, OrganizationConstants.idfInstitution, OrganizationConstants.OrgFullName, Nothing, Nothing, False)

        Dim sessionEndDate As DateTime = Convert.ToDateTime(txtdatEndDate.MaxDate)

        If DateTime.Today > sessionEndDate Then
            txtDIdatCollectionDate.MaxDate = txtdatEndDate.MaxDate
            txtdatTestResultDate.MaxDate = txtDIdatCollectionDate.MaxDate
        End If

        BaseReferenceLookUp(ddlidfsTestCategory, BaseReferenceConstants.TestCategory, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfsTestResult, BaseReferenceConstants.TestResult, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfsTestName, BaseReferenceConstants.TestName, HACodeList.ASHACode, True)

        BaseReferenceLookUp(ddlidfsActionType, BaseReferenceConstants.ASSessionActionType, HACodeList.ASHACode, False)

        ddlidfsEnteredBy.SelectedItem.Text = txtstrOfficer.Text
        'ddlidfsEnteredBy.SelectedItem.Value = hdfidfPersonEnteredBy.Value
        ddlidfsEnteredBy.Enabled = False

        BaseReferenceLookUp(ddlidfsActionStatus, BaseReferenceConstants.ASSessionActionStatus, HACodeList.ASHACode, False)
    End Sub

    Private Function fillSessionGV(Optional bRefresh As Boolean = False) As DataSet
        fillSessionGV = Nothing
        Dim dt As DataTable
        Dim HASS As Object = New clsHumanActiveSurveillanceSession()
        gvSearchResults.DataSource = Nothing

        'Try
        oCommon = New clsCommon()
        oService = oCommon.GetService()
        Dim aSP As String() = oService.getSPList("HumanActiveSurvSessionGetList")
        Dim strParams As String = oCommon.Gather(search, aSP(0), 3, True)
        oDS = HASS.ListAll({strParams}) 'filter fields need to apply
        dt = oDS.Tables(0).DefaultView.ToTable

        If bRefresh Then
            If oDS.CheckDataSet() Then
                ViewState(results) = dt
            End If
        Else
            If Not bRefresh Then
                dt = ViewState(results)  'Mock data population
            End If
        End If

        gvSearchResults.DataSource = dt          'Mock data population
        gvSearchResults.DataBind()

        If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionSearch Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceReturnToCampaignSessions Then
            gvSearchResults.Columns(6).Visible = False
            gvSearchResults.Columns(7).Visible = False
        Else
            gvSearchResults.Columns(6).Visible = True
            gvSearchResults.Columns(7).Visible = True
        End If
    End Function

    Private Sub fillSession()
        Try
            showHideSectionsandSidebarItems()
            Dim sessionEndDate As DateTime
            Dim hass As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
            oDS = hass.SelectOne(Convert.ToInt64(hdfidfMonitoringSession.Value))

            If oDS.CheckDataSet() Then

                oCommon = New clsCommon()

                searchForm.Visible = False
                sessions.Visible = True

                oCommon.Scatter(sesInfo, New DataTableReader(oDS.Tables(0)), 3, True)
                oCommon.Scatter(sesLocInfo, New DataTableReader(oDS.Tables(0)), 6, True)
                oCommon.Scatter(divHiddenFieldsSection, New DataTableReader(oDS.Tables(0)), 3, True)

                sLI.SelectedRegionValue = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.RegionID)

                If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.RayonID).ToString()) Then
                    sLI.SelectedRayonValue = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.RayonID)
                End If

                If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.TownID).ToString()) Then
                    sLI.SelectedSettlementValue = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.TownID)
                End If

                If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis).ToString()) Then
                    'hdfsessionDiseaseSummary = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis)


                    txtstrdisease.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis)
                    ddlidfsDiagnosis.SelectedItem.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis).ToString()

                    If ddlidfsDiagnosis.SelectedValue.ToString() <> "null" Then
                        hdfDiseaseSelected.Value = ddlidfsDiagnosis.SelectedItem.Text
                    End If

                End If

                'Added for summary data
                saveSummary()
                saveSummaryActions()
                saveSummaryDiseaseReports()
                saveSummaryTesttab()



                If hdfidfMonitoringSession.Value <> "NULL" Then
                    divstrSessionID.Visible = True
                Else
                    divstrSessionID.Visible = False
                    txtstrCampaignID.Text = "NULL"
                End If

                txtDIdatCollectionDate.MinDate = String.Format("{0:MM/dd/yyyy}", oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.StartDate))
                sessionEndDate = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.EndDate)
                If DateTime.Today > sessionEndDate Then
                    txtDIdatCollectionDate.MaxDate = String.Format("{0:MM/dd/yyyy}", sessionEndDate)
                End If

                If IsNothing(ViewState(sessionSamples)) Then
                    ViewState(sessionSamples) = oDS.Tables(3)
                    If oDS.Tables(3).Rows.Count() > 0 Then
                        btnCreateDetails.Visible = True
                    Else
                        btnCreateDetails.Visible = False
                    End If
                End If

                gvSamples.DataSource = ViewState(sessionSamples)
                gvSamples.DataBind()

                Dim dtDetails As DataTable
                If Not IsNothing(ViewState(sessionDetails)) Then
                    dtDetails = ViewState(sessionDetails)
                Else
                    dtDetails = oDS.Tables(4)
                    Dim paramNames As String() = {MaterialConstants.Material, MaterialConstants.MonitoringSessionID, MaterialConstants.SampleTypeID, MaterialConstants.SampleType, MaterialConstants.FieldBarCode, MaterialConstants.FieldCollectedByPersonID, MaterialConstants.FieldCollectedByPerson, MaterialConstants.FieldCollectionDate, MaterialConstants.SendToOfficeID, MaterialConstants.SendToOffice}
                    dtDetails = dtDetails.DefaultView.ToTable(True, paramNames)
                End If
                hdfNewMaterialID.Value = dtDetails.Rows.Count()

                Dim dtTests As DataTable = oDS.Tables(4)
                Dim testParamNames As String() = {TestConstants.TestingID, TestConstants.MaterialID, TestConstants.TestNameID, TestConstants.TestName, TestConstants.TestCategoryID, TestConstants.TestCategory, TestConstants.TestResultID, TestConstants.TestResult, TestConstants.ConclusionDate}
                dtTests = dtTests.DefaultView.ToTable(True, testParamNames)
                ViewState(sessionTests) = dtTests

                gvDetailInformation.DataSource = dtDetails
                gvDetailInformation.DataBind()
                ViewState(sessionDetails) = dtDetails

                'If Not IsNothing(Session("EmployeeID")) Then
                '    hdfPersonID.Value = Session("EmployeeID")

                '    Dim oPer As clsEmployee = New clsEmployee()
                '    Dim ds As DataSet = oPer.SelectOne(Convert.ToDouble(hdfPersonID.Value))

                '    If ds.CheckDataSet() Then
                '        'txtDIstrPersonID.Text = ds.Tables(0).Rows(0)(GlobalConstants.FirstName) & " " & ds.Tables(0).Rows(0)(GlobalConstants.FamilyName)
                '        txtDIstrAddress.Text = ds.Tables(1).Rows(0)("strSiteName")
                '    End If

                'End If

                'If Not IsNothing(Session("OrganizationID")) Then
                '    hdfOrganizationID.Value = Session("OrganizationID")

                '    Dim org As clsOrganization = New clsOrganization()
                '    Dim ds As DataSet = org.SelectOne(Convert.ToDouble(hdfOrganizationID.Value))

                '    If ds.CheckDataSet() Then
                '        txtDIidfsOrganizationID.Text = ds.Tables(0).Rows(0)(OrganizationConstants.OrgFullName)
                '    End If

                'End If

                If IsNothing(ViewState(sessionActions)) Then
                    ViewState(sessionActions) = oDS.Tables(2)
                End If

                gvActions.DataSource = oDS.Tables(2)
                gvActions.DataBind()

                If oDS.Tables(2).Rows.Count() > 0 Then
                    actionReq.Visible = True
                    rdbActionEntriesYes.Checked = True
                    btnCreateActions.Visible = True
                End If

                If hdfidfCampaign.Value <> "NULL" And Not String.IsNullOrEmpty(hdfidfCampaign.Value) Then

                    hdfidfCampaign.Value = oDS.Tables(0).Rows(0)(ActiveSurveillanceCampaignConstants.Campaign)
                    oCommon.Scatter(campaignInformation, New DataTableReader(oDS.Tables(0)), 3, True)

                    txtdatStartDate.MinDate = String.Format("{0:MM/dd/yyyy}", oDS.Tables(0).Rows(0)(ActiveSurveillanceCampaignConstants.StartDate))
                    txtdatStartDate.MaxDate = String.Format("{0:MM/dd/yyyy}", oDS.Tables(0).Rows(0)(ActiveSurveillanceCampaignConstants.EndDate))
                    txtdatEndDate.MinDate = String.Format("{0:MM/dd/yyyy}", oDS.Tables(0).Rows(0)(ActiveSurveillanceCampaignConstants.StartDate))
                    txtdatEndDate.MaxDate = String.Format("{0:MM/dd/yyyy}", oDS.Tables(0).Rows(0)(ActiveSurveillanceCampaignConstants.EndDate))

                    sessionEndDate = Convert.ToDateTime(txtdatEndDate.MaxDate)

                    If DateTime.Today > sessionEndDate Then
                        txtDIdatCollectionDate.MaxDate = txtdatEndDate.MaxDate
                        txtdatTestResultDate.MaxDate = txtDIdatCollectionDate.MaxDate
                    End If

                    divSessionDiagnosis.Visible = False

                    Dim oHASC As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
                    Dim cDS As DataSet = oHASC.SelectOne(Convert.ToDouble(hdfidfCampaign.Value))

                    If cDS.CheckDataSet() Then
                        ViewState(campaign) = cDS
                    End If
                Else
                    divSessionDiagnosis.Visible = True
                End If

                populateSampleTypeAdd()
                fillSampleTypes(ddlDIidfsSampleType, ViewState(sessionSamples))
            End If
        Catch ex As Exception

        End Try

    End Sub

    Private Sub fillSessionApi(ByVal id As Double)
    End Sub
    Private Sub saveSummary()
        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID).ToString()) Then
            'hdfsessionIDsummary = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID)
            txtstrMonitoringSessionIDPerson.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID)
        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID).ToString()) Then
            strMonitoringSessionStatusPerson.Text = ""
            Dim idfsessionStatusSummary = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID)
            If idfsessionStatusSummary = 10160000 Then
                strMonitoringSessionStatusPerson.Text = "Open"
            ElseIf idfsessionStatusSummary = 10160001 Then
                strMonitoringSessionStatusPerson.Text = "Closed"
            End If

        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis).ToString()) Then
            'hdfsessionDiseaseSummary = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis)
            txtstrdisease.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis)
        End If

    End Sub
    Private Sub saveSummaryActions()
        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID).ToString()) Then
            txtstrMonitoringSessionIDAction.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID)
        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID).ToString()) Then
            strMonitoringSessionStatusAction.Text = ""
            Dim idfsessionStatusSummary = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID)
            If idfsessionStatusSummary = 10160000 Then
                strMonitoringSessionStatusAction.Text = "Open"
            ElseIf idfsessionStatusSummary = 10160001 Then
                strMonitoringSessionStatusAction.Text = "Closed"
            End If

        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis).ToString()) Then
            txtdiseaseSummaryAction.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis)
        End If

    End Sub

    Private Sub saveSummaryDiseaseReports()
        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID).ToString()) Then
            txtstrMonitoringSessionIDDR.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID)
        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID).ToString()) Then
            strMonitoringSessionStatusDR.Text = ""
            Dim idfsessionStatusSummary = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID)
            If idfsessionStatusSummary = 10160000 Then
                strMonitoringSessionStatusDR.Text = "Open"
            ElseIf idfsessionStatusSummary = 10160001 Then
                strMonitoringSessionStatusDR.Text = "Closed"
            End If

        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis).ToString()) Then
            txtdiseaseSummaryDR.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis)
        End If

    End Sub
    Private Sub saveSummaryTesttab()
        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID).ToString()) Then
            txtstrMonitoringSessionIDTesttab.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionID)
        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID).ToString()) Then
            strMonitoringSessionStatusTesttab.Text = ""
            Dim idfsessionStatusSummary = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.SessionStatusID)
            If idfsessionStatusSummary = 10160000 Then
                strMonitoringSessionStatusTesttab.Text = "Open"
            ElseIf idfsessionStatusSummary = 10160001 Then
                strMonitoringSessionStatusTesttab.Text = "Closed"
            End If

        End If

        If Not String.IsNullOrEmpty(oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis).ToString()) Then
            txtdiseaseSummaryTesttab.Text = oDS.Tables(0).Rows(0)(ActiveSurveillanceSessionConstants.Diagnosis)
        End If

    End Sub
    Private Sub fillTests(ByVal dt As DataTable, ByRef mID As Double)
        For i As Integer = 0 To dt.Rows.Count() - 1

            Dim sampleStringBuilder As StringBuilder = New StringBuilder()

            Dim aSP As String() = oService.getSPList("HumanActiveSurvSessionToTesting")

            If dt.Rows(i)(TestConstants.TestingID) = -1 Then
                sampleStringBuilder.AppendFormat("@" & TestConstants.TestingID & ";NULL;INOUT|")
                sampleStringBuilder.AppendFormat("@" & TestConstants.RecordAction & ";" & RecordConstants.Insert & ";IN|")
            Else
                sampleStringBuilder.AppendFormat("@" & TestConstants.TestingID & ";" & dt.Rows(i)(TestConstants.TestingID) & ";INOUT|")
                sampleStringBuilder.AppendFormat("@" & TestConstants.RecordAction & ";" & RecordConstants.Update & ";IN|")
            End If

            If dt.Rows(i)(TestConstants.MaterialID) <= -1 Then
                dt.Rows(i)(TestConstants.MaterialID) = mID
            End If

            sampleStringBuilder.AppendFormat("@" & TestConstants.MaterialID & ";" & dt.Rows(i)(TestConstants.MaterialID) & ";IN|")
            sampleStringBuilder.AppendFormat("@" & TestConstants.TestNameID & ";" & dt.Rows(i)(TestConstants.TestNameID) & ";IN|")
            sampleStringBuilder.AppendFormat("@" & TestConstants.TestCategoryID & ";" & dt.Rows(i)(TestConstants.TestCategoryID) & ";IN|")
            sampleStringBuilder.AppendFormat("@" & TestConstants.TestResultID & ";" & dt.Rows(i)(TestConstants.TestResultID) & ";IN|")
            sampleStringBuilder.AppendFormat("@" & TestConstants.ConclusionDate & ";" & dt.Rows(i)(TestConstants.ConclusionDate) & ";IN|")
            Dim values As String = sampleStringBuilder.ToString() & oCommon.Gather(divHiddenTestingSession, aSP(0), 7, True)
            Dim oHASS As clsHumanActiveSurveillanceSession = New clsHumanActiveSurveillanceSession()
            oHASS.AddUpdateHASStoTest(values)

        Next
    End Sub

    Public Sub getSearchFields()

        Dim oHASS As HumanActSurvSessionSearchData

        Dim oSerializer As XmlSerializer = New XmlSerializer(GetType(HumanActSurvSearchData))
        Dim oFileStream As FileStream
        Dim sFile As String = Server.MapPath("\") & "App_Data\" & Session("UserID").ToString() & "_HASS.xml"

        If sFile <> "" AndAlso File.Exists(sFile) Then     'Else is not added to the code due to not having the search criteria file values to populate GridView

            oFileStream = New FileStream(sFile, FileMode.Open)
            oHASS = oSerializer.Deserialize(oFileStream)

            With oHASS
                If (oHASS.SessionStatus <> "" AndAlso oHASS.SessionStatus <> "-1") Then
                    ddlMonitoringSessionidfsStatus.SelectedValue = .SessionStatus
                End If

                txtMonitoringSessionstrID.Text = .SessionID
                txtMonitoringSessionDatEnteredFrom.Text = .FromDate
                txtMonitoringSessionDatEnteredTo.Text = .ToDate

                If (oHASS.SessionDisease <> "" AndAlso oHASS.SessionDisease <> "-1") Then
                    ddlMonitoringSessionidfsDiagnosis.SelectedValue = .SessionDisease
                End If

            End With
            oFileStream.Close()
            oFileStream.Dispose()
        End If

    End Sub

    Private Sub populateSampleTypeAdd()
        If Not IsNothing(gvSamples.HeaderRow) Then
            Dim ddlSampleType As DropDownList = gvSamples.HeaderRow.FindControl("ddlSampleType")
            Dim btnAdd As LinkButton = gvSamples.HeaderRow.FindControl("btnAdd")
            'If Not IsNothing(ddlSampleType) And IsNothing(btnAdd) Then
            If Not IsNothing(ddlSampleType) Then
                If hdfidfCampaign.Value = "NULL" Or hdfidfCampaign.Value = "" Then
                    FillDropDown(ddlSampleType, GetType(clsSampleDisease), {ddlidfsDiagnosis.SelectedValue}, SampleTypeConstants.SampleTypeID, SampleTypeConstants.SampleTypeName, Nothing, Nothing, True)
                    Dim dt As DataTable = ViewState(sessionSamples)
                    If Not IsNothing(dt) Then
                        Dim samples As Integer = dt.Rows.Count()
                        If ddlSampleType.Items.Count - samples < 2 Then
                            ddlSampleType.Enabled = False
                            btnAdd.Visible = False
                        Else
                            ddlSampleType.Enabled = True
                            btnAdd.Visible = True
                        End If
                    Else
                        ddlSampleType.Enabled = False
                        btnAdd.Visible = False
                    End If
                Else
                    Dim ds As DataSet = ViewState(campaign)
                    If Not IsNothing(ds) Then
                        Dim dt As DataTable = ds.Tables(1)
                        ViewState(campaignSamples) = dt
                        Dim dt2 As DataTable = ViewState(sessionSamples)
                        If Not IsNothing(dt) And Not IsNothing(dt2) Then
                            fillSampleTypes(ddlSampleType, dt)
                            Dim samples As Integer = dt2.Rows.Count()
                            If ddlSampleType.Items.Count - samples < 2 Then
                                ddlSampleType.Enabled = False
                                btnAdd.Visible = False
                            Else
                                ddlSampleType.Enabled = True
                                btnAdd.Visible = True
                            End If
                        Else
                            ddlSampleType.Enabled = False
                            btnAdd.Visible = False
                        End If
                    End If
                End If
                disableSelectedSampleTypes(ddlSampleType)
                If ddlSampleType.Items.Count() < 2 Then
                    ddlSampleType.Enabled = False
                Else
                    ddlSampleType.Enabled = True
                End If
            End If
        End If

        'If Not IsNothing(ViewState(sessionSamples)) Then
        '    If ViewState(sessionSamples).Rows.Count() < 2 Then
        '        ddlidfsDiagnosis.Enabled = True
        '    Else
        '        ddlidfsDiagnosis.Enabled = False
        '    End If
        'End If
    End Sub

    Private Function setSortDirection(ByVal e As GridViewSortEventArgs) As String

        Dim dir As String
        Dim lastCol As String = String.Empty
        If Not IsNothing(ViewState("sesCol")) Then lastCol = ViewState("sesCol").ToString()
        If lastCol = e.SortExpression Then
            If ViewState("sesDir") = "0" Then
                dir = "DESC"
                ViewState("sesDir") = SortDirection.Descending
            Else
                dir = "ASC"
                ViewState("sesDir") = SortDirection.Ascending
            End If
        Else
            dir = "ASC"
            ViewState("sesDir") = SortDirection.Ascending
        End If
        ViewState("sesCol") = e.SortExpression
        Return dir
    End Function

    Private Sub showHideSectionsandSidebarItems()
        If hdfidfMonitoringSession.Value = "NULL" Then
            'Hides Detailed Information Tab
            personsAndSamples.Visible = False
            sideBarItemPersonsAndSamples.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sideBarItemPersonsAndSamples.IsActive = True
            sideBarItemPersonsAndSamples.Visible = False
            'sideBarItemPersonsAndSamples.GoToTab = "1"
            sideBarItemPersonsAndSamples.GoToTab = String.Empty

            'Hides Actions Tab
            actions.Visible = False
            sideBarItemActions.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sideBarItemActions.IsActive = True
            sideBarItemActions.Visible = False
            'sideBarItemActions.GoToTab = "2"
            sideBarItemActions.GoToTab = String.Empty

            diseaseReport.Visible = False
            sidebaritem_DiseaseReport.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sidebaritem_DiseaseReport.IsActive = True
            sidebaritem_DiseaseReport.Visible = False
            'sidebaritem_DiseaseReport.GoToTab = "3"
            sidebaritem_DiseaseReport.GoToTab = String.Empty

            testsTab.Visible = False
            sidebaritem_Tests.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sidebaritem_Tests.IsActive = True
            sidebaritem_Tests.Visible = False
            'sidebaritem_Tests.GoToTab = "4"
            sidebaritem_Tests.GoToTab = String.Empty

            'sideBarItemReview.GoToTab = "5"
            sideBarItemReview.GoToTab = "1" 'Make this 1 so submit box appears when clicked


        Else
            'Shows Session Tab
            personsAndSamples.Visible = True
            sideBarItemPersonsAndSamples.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sideBarItemPersonsAndSamples.IsActive = True
            sideBarItemPersonsAndSamples.Visible = True
            sideBarItemPersonsAndSamples.GoToTab = "1"
            'Shows Actions Tab
            actions.Visible = True
            sideBarItemActions.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sideBarItemActions.IsActive = True
            sideBarItemActions.Visible = True
            sideBarItemActions.GoToTab = "2"

            diseaseReport.Visible = True
            sidebaritem_DiseaseReport.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sidebaritem_DiseaseReport.IsActive = True
            sidebaritem_DiseaseReport.Visible = True
            sidebaritem_DiseaseReport.GoToTab = "3"

            'Shows Test Tab
            testsTab.Visible = True
            sidebaritem_Tests.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sidebaritem_Tests.IsActive = True
            sidebaritem_Tests.Visible = True
            sidebaritem_Tests.GoToTab = "4"

            sideBarItemReview.GoToTab = "5"

        End If

    End Sub

    Private Sub showSearchCriteria(ByVal show As Boolean)
        If show Then
            searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
            btnClear.Visible = True
            btnSearch.Visible = True
        Else
            searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        End If
    End Sub

    Private Function validateDates(startDate As String, endDate As String, Optional isRange As Boolean = True) As Boolean
        If String.IsNullOrEmpty(startDate) And String.IsNullOrEmpty(endDate) Then
            Return True
        ElseIf Not String.IsNullOrEmpty(startDate) And String.IsNullOrEmpty(endDate) And isRange Then
            Return False
        ElseIf Not String.IsNullOrEmpty(startDate) And String.IsNullOrEmpty(endDate) And Not isRange Then
            Return True
        ElseIf String.IsNullOrEmpty(startDate) And Not String.IsNullOrEmpty(endDate) And isRange Then
            Return False
        ElseIf String.IsNullOrEmpty(startDate) And Not String.IsNullOrEmpty(endDate) And Not isRange Then
            Return True
        Else
            Dim fromDate As DateTime = Convert.ToDateTime(startDate)
            Dim toDate As DateTime = Convert.ToDateTime(endDate)

            If fromDate > toDate Then
                Return False
            Else
                Return True
            End If
        End If
    End Function

    Private Function validateForSearch() As Boolean

        Dim blnValidated As Boolean = False

        Dim oCommon As clsCommon = New clsCommon()

        'Check if Farm ID is entered.
        'If Yes then ignore rest of the search fields
        'If No, check if any other search criteria is entered, if not, raise error.
        blnValidated = (Not txtMonitoringSessionstrID.Text.IsValueNullOrEmpty())

        If Not blnValidated Then
            'searchForm
            Dim allCtrl As New List(Of Control)

            allCtrl.Clear()
            For Each txt As WebControls.TextBox In oCommon.FindCtrl(allCtrl, search, GetType(WebControls.TextBox))
                If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not blnValidated Then
                allCtrl.Clear()
                For Each rdb As WebControls.RadioButton In oCommon.FindCtrl(allCtrl, search, GetType(WebControls.RadioButton))
                    If Not blnValidated Then blnValidated = (rdb.Checked)
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As WebControls.DropDownList In oCommon.FindCtrl(allCtrl, search, GetType(WebControls.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In oCommon.FindCtrl(allCtrl, search, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                If Not blnValidated Then blnValidated = (Not MonitoringSession.SelectedRegionValue.Equals("null"))
                If Not blnValidated Then blnValidated = (Not MonitoringSession.SelectedRayonValue.Equals("null"))
            End If
        End If

        Return blnValidated

    End Function

    Private Sub showClearandSearchButtons(ByVal show As Boolean)
        btnSearch.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)
        btnClear.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)

        If show Then
            btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
            btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
        Else
            btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        End If
    End Sub

    Private Sub ActiveSurveillanceSession_Error(Sender As Object, e As EventArgs) Handles Me.[Error]
        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then

            ASPNETMsgBox("An error occurred on this page. Please verify your information to resolve the issue.")

        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & Me.GetType.Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()
    End Sub

#Region "show or hide detailed information"

    Private Sub showOrHideSampleTypeIcons(ByVal show As Boolean)
        gvSamples.Columns(1).Visible = show
        gvSamples.Columns(2).Visible = show
    End Sub

    Private Sub showOrHideActionIcons(ByVal show As Boolean)
        gvActions.Columns(5).Visible = show
        gvActions.Columns(6).Visible = show
    End Sub

    Private Sub showOrHideDetailIcons(ByVal show As Boolean)
        gvDetailInformation.Columns(5).Visible = show
        gvDetailInformation.Columns(6).Visible = show
        gvDetailInformation.Columns(7).Visible = show
    End Sub

    Private Sub showOrHideTestGridExist(ByVal index As Integer, ByVal show As Boolean)
        gvDetailInformation.Columns(5).Visible = show
        Dim gvTests As GridView = gvDetailInformation.Rows(index).FindControl("gvTests")
        If Not IsNothing(gvTests) Then
            gvTests.Columns(4).Visible = show
            gvTests.Columns(5).Visible = show
        End If
    End Sub

#End Region

#End Region

End Class

Public Class HumanActSurvSessionSearchData

    Private stxtSessionID As String
    Private stxtRegion As String
    Private stxtRayon As String
    Private sddlSessionStatus As String
    Private sddlSessionDisease As String
    Private stxtFromDate As String
    Private stxtToDate As String

    Public Property SessionID As String
        Get
            Return stxtSessionID
        End Get
        Set(value As String)
            stxtSessionID = value
        End Set
    End Property

    Public Property SessionStatus As String
        Get
            Return sddlSessionStatus
        End Get
        Set(value As String)
            sddlSessionStatus = value
        End Set
    End Property

    Public Property SessionDisease As String
        Get
            Return sddlSessionDisease
        End Get
        Set(value As String)
            sddlSessionDisease = value
        End Set
    End Property

    Public Property FromDate As String
        Get
            Return stxtFromDate
        End Get
        Set(value As String)
            stxtFromDate = value
        End Set
    End Property

    Public Property ToDate As String
        Get
            Return stxtToDate
        End Get
        Set(value As String)
            stxtToDate = value
        End Set
    End Property

End Class