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

Public Class ActiveSurveillanceCampaign
    Inherits BaseEidssPage

    Private ReadOnly Log As log4net.ILog
    Private oCommon As clsCommon = New clsCommon()
    Private oService As NG.EIDSSService
    Private oDS As DataSet
    Private sFile As String

    Private Const campaign As String = "campaign"
    Private Const campaignSamples As String = "campaignSamples"
    Private Const campaignSessions As String = "campaignSessions"
    Private Const sessionSamples As String = "sessionSamples"
    Private Const sessionDetails As String = "sessionDetails"
    Private Const sessionActions As String = "sessionActions"
    Private Const results As String = "results"

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"
    Private Const SESSION_SEARCH_LIST As String = "gvSearchResults_List"
    Private Const SORT_DIRECTION As String = "gvSearchResults_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvSearchResults_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvSearchResults_PaginationSet"

    Private ReadOnly HumanServiceClientAPIClient As HumanServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient


    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(ActiveSurveillanceCampaign))
            Log.Info("Loading Contructor Classes ActiveSurveillanceCampaign.aspx")
            HumanServiceClientAPIClient = New HumanServiceClient()
            CrossCuttingAPIService = New CrossCuttingServiceClient()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
    End Sub


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try

                btn_scClear.Visible = False
                btn_scSearch.Visible = False

                ViewState("campaignSamples") = Nothing  'Initialize AK

                hdrHASC.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
                hdrHASR.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                FillSearchDropdowns()
                fillCampaignDropdowns()

                'Restore search filters
                sFile = oCommon.CreateTempFile(Session("UserID").ToString(), CallerPages.HumanActiveSurveillanceCampaignPrefix)
                oCommon.GetSearchFields({search}, sFile)

                ExtractViewStateSession()

                If ViewState(CALLER).ToString().EqualsAny({CallerPages.HumanActiveSurveillanceReturnToCampaignSessions, CallerPages.HumanActiveSurveillanceEditCampaignSession, CallerPages.HumanActiveSurveillanceCampaign, CallerPages.HumanActiveSurveillanceSessionSearch}) Then
                    hdfidfCampaign.Value = ViewState(CALLER_KEY)
                    searchForm.Visible = False
                    campaignInformation.Visible = True

                    fillCampaignInformation(Convert.ToDouble(hdfidfCampaign.Value))

                    If ViewState(CALLER).ToString().EqualsAny({CallerPages.HumanActiveSurveillanceReturnToCampaignSessions, CallerPages.HumanActiveSurveillanceEditCampaignSession, CallerPages.HumanActiveSurveillanceCampaign, CallerPages.HumanActiveSurveillanceSessionSearch}) Then
                        hdnPanelController.Value = "2"
                    End If
                ElseIf (ViewState(CALLER_KEY) <> 0 Or ViewState(CALLER_KEY) <> "NULL" Or ViewState(CALLER_KEY) <> Nothing) And ViewState(CALLER).ToString().EqualsAny({CallerPages.HumanActiveSurveillanceCampaign, CallerPages.Dashboard}) Then
                    hdfidfCampaign.Value = ViewState(CALLER_KEY)
                    searchForm.Visible = False
                    campaignInformation.Visible = True
                End If
            Catch
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Page.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
            End Try
            showHideSectionsandSidebarItems()
        Else
            showClearandSearchButtons(True)
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
        Try
            oCommon = New clsCommon()
            oCommon.ResetForm(search)

            hdfidfCampaign.Value = "NULL"

            showClearandSearchButtons(True)

            searchResults.Visible = False
            btnShowSearchCriteria.Visible = False
            showSearchCriteria(True)
            btnShowSearchCriteria.Attributes.Remove("class")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
            btnShowSearchCriteria.Visible = False
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Return_to_Search.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnCreateCampaign_Click(sender As Object, e As EventArgs) Handles btnCreateCampaign.Click
        Try
            searchForm.Visible = False
            sessions.Visible = False

            campaignInformation.Visible = True

            txtstrConclusion.Text = "" 'Clear out any old values

            ' When ddlidfscampaignStatus changes to not new, then conclusion.visible = true

            btnNextSection.Visible = False
            btnDelete.Visible = False
            btnSubmit.Visible = True





            'Reset forms of the page
            oCommon = New clsCommon()
            oCommon.ResetForm(divHiddenFieldsSection)
            oCommon.ResetForm(campaignInformation)

            Dim dt As DataTable = New DataTable()
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.Campaign)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.Order)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SpeciesTypeID)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SpeciesType)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.PlannedNumber)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SampleType)
            dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.HasOpenSession)

            gvSamples.DataSource = dt
            gvSamples.DataBind()

            ViewState(campaignSamples) = dt

            fillAllSamples()

            'Important to set value to "NULL" for a new campaign
            hdfidfCampaign.Value = "NULL"
            txtstrCampaignID.Text = "NULL"
            showHideSectionsandSidebarItems()

            'Shows first section of Campaign Information
            hdnPanelController.Value = "0"






        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Add_Campaign.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Try
            If Not ValidateForSearch() Then
                txtCampaignStrIDFilter.Focus()
                lbl_Error.InnerText = GetLocalResourceObject("lbl_One_Search_Criterion.InnerText")
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                Exit Sub
            Else
                If Not validateDates(txtStartDateFromFilter.Text, txtStartToFilter.Text, True) Then
                    txtStartDateFromFilter.Focus()
                    'Exits search with bad date error message
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Date.InnerText")
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                    Exit Sub
                Else

                    showClearandSearchButtons(False)
                    btnCancelCampaignRTD.Visible = False
                    btnCancelCampaignSearch.Visible = True
                    searchResults.Visible = True

                    oCommon = New clsCommon()

                    sFile = oCommon.CreateTempFile(Session("UserID").ToString(), CallerPages.HumanActiveSurveillanceCampaignPrefix)
                    'Save search fields
                    oCommon.SaveSearchFields({search}, CallerPages.HumanActiveSurveillanceCampaign, sFile)

                    FillCampaignGV(bRefresh:=True)
                    btnShowSearchCriteria.Visible = True
                    showSearchCriteria(False)

                End If
            End If
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Search.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
        End Try
    End Sub

#End Region

#Region "Create/Edit Campaign"

    Protected Sub btnCancelSampleTypeYes_Click(sender As Object, e As EventArgs) Handles btnCancelSampleTypeYes.ServerClick
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "1"
        gvSamples.EditIndex = -1
        gvSamples.DataSource = ViewState(campaignSamples)
        gvSamples.DataBind()
        populateSampleTypeAdd()
    End Sub

    Protected Sub btnCancelYes_Click(sender As Object, e As EventArgs) Handles btnCancelYes.ServerClick
        campaignInformation.Visible = False
        searchForm.Visible = True

        If searchResults.Visible Then
            showClearandSearchButtons(False)
        Else
            showClearandSearchButtons(True)
        End If

        divCampaignID.Visible = False
        hdfidfCampaign.Value = "NULL"
    End Sub

    Protected Sub btnCancelYesSearch_Click(sender As Object, e As EventArgs) Handles btnCancelYesSearch.ServerClick
        campaignInformation.Visible = False
        searchForm.Visible = True
        searchResults.Visible = False
        'btnCancelCampaignSearch.Visible = False
        'btnCancelCampaignRTD.Visible = True

        If searchResults.Visible Then
            showClearandSearchButtons(False)
        Else
            showClearandSearchButtons(True)
        End If

        divCampaignID.Visible = False
        hdfidfCampaign.Value = "NULL"
    End Sub

    Protected Sub btnDeleteSession_Click(sender As Object, e As EventArgs) Handles btnDeleteSession.ServerClick
        Try
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "2"
            Dim dt As DataTable = ViewState(campaignSessions)
            Dim index As Integer = Convert.ToInt32(hdfCampaignToMonitoringSessionIndex.Value)
            Dim id As Double = Convert.ToDouble(hdfCampaignToMonitoringSessionID.Value)

            If id <> -1 Then
                Dim oHASC As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
                oHASC.SessionToCampaign(0, id)
            End If

            dt.Rows.RemoveAt(index)
            gvSessions.DataSource = dt
            gvSessions.DataBind()
            ViewState(campaignSessions) = dt
            ViewState(CALLER_KEY) = hdfidfCampaign.Value
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnRTCR_Click(sender As Object, e As EventArgs) Handles btnRTCR.ServerClick
        hdrHASC.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
        hdrHASR.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        campaignInformation.Visible = True
        fillCampaignInformation(Convert.ToDouble(hdfidfCampaign.Value))
    End Sub

    Protected Sub btnRtD_Click(sender As Object, e As EventArgs) Handles btnRTDSC.ServerClick, btnRTDSC.ServerClick
        clearCampaign()
        Response.Redirect(GetURL(CallerPages.DashboardURL), True)
    End Sub

    Protected Sub btnSearchSessions_Click(sender As Object, e As EventArgs) Handles btnSearchSessions.Click
        ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionSearch
        ViewState(CALLER_KEY) = hdfidfCampaign.Value
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), True)
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Try
            Dim values As String = String.Empty
            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "0"

            If Not validateDates(txtdatCampaignDateStart.Text, txtdatCampaignDateEND.Text, False) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Date.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & errorCampaign.ClientID & "').modal('show');});", True)
                Exit Sub
            End If

            If String.IsNullOrEmpty(txtstrCampaignName.Text) Or String.IsNullOrEmpty(ddlidfsCampaignType.SelectedValue) Or String.IsNullOrEmpty(ddlidfsDiagnosis.SelectedValue) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Required_Missing.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & errorCampaign.ClientID & "').modal('show');});", True)
                Exit Sub
            End If

            Dim caimpaignId As Long = 0



            If (Not hdfidfCampaign.Value.isValueNullOrEmpty) Then
                caimpaignId = CType(hdfidfCampaign.Value, Long)
            End If



            'Dim result As GblAscampaignSetModel = AddUpdateHASC(0, 0)
            Dim result As GblAscampaignSetModel = AddUpdateHASC(0, caimpaignId)



            If result.ReturnCode = 0 Then
                If hdfidfCampaign.Value = "NULL" Then
                    hdfidfCampaign.Value = result.idfCampaign
                    FillSamples()
                    'FillSamplesApi()
                    lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Creation.InnerText") & result.strCampaignID & "."
                Else
                    FillSamples()
                    'FillSamplesApi()
                    lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Update.InnerText") & result.strCampaignID & "."
                End If
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & successCampaign.ClientID & "').modal('show');});", True)

            Else
                If (Not String.IsNullOrEmpty(result.strCampaignID)) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_No_Rows_Updated.InnerText")
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_No_Rows_Created.InnerText")
                End If
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & errorCampaign.ClientID & "').modal('show');});", True)

            End If
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Adding_Campaign.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "SuccessModalScript", "$(function(){ $('#" & errorCampaign.ClientID & "').modal('show');});", True)

        End Try

    End Sub

    Protected Sub btnNewSession_Click(sender As Object, e As EventArgs) Handles btnNewSession.Click
        ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaign
        ViewState(CALLER_KEY) = hdfidfCampaign.Value
        oCommon.SaveViewState(ViewState)

        'If ddlidfsDiagnosis.SelectedValue.ToString() <> "null" Then
        '    hdfDiseaseSelected.Value = ddlidfsDiagnosis.SelectedValue.ToString()
        'End If

        If hdfDiseaseSelected.Value <> "null" Then
            ddlidfsDiagnosis.SelectedItem.Text = hdfDiseaseSelected.Value
        End If

        Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), True)
    End Sub




#End Region


#Region "API CALLS"
    Private Function AddUpdateHASC(ByVal resultCode As Long,
                                        ByVal campaignId As Long) As GblAscampaignSetModel


        Try
            Dim humanASModelSetParams As New HumanActiveSurveillanceCampaignSetParams()

            ' Add data here from the UI for the creation of an Campaign
            humanASModelSetParams.campaignCategoryId = 10168001 'Human
            'humanASModelSetParams.datCampaignDateEnd = txtdatCampaignDateEND.Text
            'humanASModelSetParams.datCampaignDateStart = txtdatCampaignDateStart.Text
            '    humanASModelSetParams.idfCampaign Output
            'humanASModelSetParams.idfsCampaignStatus = ddlidfsCampaignStatus.SelectedValue
            'humanASModelSetParams.idfsCampaignType = ddlidfsCampaignType.SelectedValue
            'humanASModelSetParams.idfsDiagnosis = ddlidfsDiagnosis.SelectedValue
            humanASModelSetParams.strCampaignAdministrator = txtstrCampaignAdministrator.Text
            'humanASModelSetParams.strCampaignId = strcampaignId
            'humanASModelSetParams.strCampaignName = txtstrCampaignName.Text
            '    humanASModelSetParams.strComments
            '    humanASModelSetParams.strConclusion



            humanASModelSetParams.idfCampaign = campaignId


            If (Not ddlidfsCampaignStatus.SelectedValue.IsValueNullOrEmpty AndAlso ddlidfsCampaignStatus.SelectedValue <> "-1") Then
                humanASModelSetParams.idfsCampaignStatus = ddlidfsCampaignStatus.SelectedValue.ToInt32 'CampaignStatus

            End If


            If Not txtstrCampaignName.Text.IsValueNullOrEmpty Then
                humanASModelSetParams.strCampaignName = txtstrCampaignName.Text 'CampaignName

            End If

            If Not txtdatCampaignDateStart.Text.IsValueNullOrEmpty Then
                humanASModelSetParams.datCampaignDateStart = txtdatCampaignDateStart.Text 'StartDate
            End If

            If Not txtdatCampaignDateEND.Text.IsValueNullOrEmpty Then
                humanASModelSetParams.datCampaignDateEnd = txtdatCampaignDateEND.Text 'EndDate
            End If

            If (Not ddlidfsCampaignType.SelectedValue.IsValueNullOrEmpty AndAlso ddlidfsCampaignType.SelectedValue <> "-1") Then
                humanASModelSetParams.idfsCampaignType = ddlidfsCampaignType.SelectedValue.ToInt32 'CampaignType

            End If

            If (Not ddlidfsDiagnosis.SelectedValue.IsValueNullOrEmpty AndAlso ddlidfsDiagnosis.SelectedValue <> "-1") Then
                humanASModelSetParams.idfsDiagnosis = ddlidfsDiagnosis.SelectedValue 'CampaignDisease

            End If


            'Dim returnResults = New CampaignSetResult(resultCode, campaignId)

            Dim returnResults = HumanServiceClientAPIClient.HumanActiveSurveillanceCampaignSet(humanASModelSetParams).Result


            If returnResults.FirstOrDefault().ReturnCode = 0 Then


                'Arnolds Testing values
                Dim campaignCreated As String = returnResults.FirstOrDefault().idfCampaign
                Dim campaignName As String = returnResults.FirstOrDefault().strCampaignID

            End If

            Return returnResults.FirstOrDefault()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
        End Try

    End Function



    'Private Function AddHASCApi(ByVal resultCode As Long,
    '                                    ByVal campaignId As Long)



    '    Dim result As GblAscampaignSetModel = AddUpdateHASC(resultCode, campaignId)

    '    If result.ReturnCode = 0 Then
    '        '      ShowSuccessMessage(MessageType.AddUpdateSuccess)
    '    Else
    '        '    ShowWarningMessage(messageType:=MessageType.CannotAddUpdate, isConfirm:=False)
    '    End If


    'End Function
#End Region



#Region "Review"

#Region "Modal Button"

    Protected Sub btnDeleteYes_Click(sender As Object, e As EventArgs) Handles btnDeleteYes.ServerClick
        Try
            oCommon = New clsCommon()
            oService = oCommon.GetService()
            Dim oHASC As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
            Dim id As Double = Convert.ToInt64(hdfidfCampaign.Value)

            oDS = oHASC.SelectOne(id)

            If (oDS.CheckDataSet) Then
                If oDS.Tables(2).Rows.Count() = 0 Then
                    oHASC.Delete(id)

                    searchForm.Visible = True
                    campaignInformation.Visible = False
                    btnShowSearchCriteria.Visible = True

                    If hdfDeleteCampaignFromSearchResults.Value Then
                        searchResults.Visible = True

                        Dim dt As DataTable = ViewState(results)
                        Dim dr As DataRow() = dt.Select(ActiveSurveillanceCampaignConstants.Campaign & "=" & hdfidfCampaign.Value)

                        If (dr.Count() > 0) Then
                            For i As Integer = 0 To dr.Count() - 1
                                dt.Rows.Remove(dr(i))
                            Next
                        End If

                        gvSearchResults.DataSource = dt
                        gvSearchResults.DataBind()

                        ViewState(results) = dt
                    Else
                        showClearandSearchButtons(True)
                    End If


                    hdfDeleteCampaignFromSearchResults.Value = False
                    hdfCampaignIndex.Value = "NULL"

                    lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Deletion.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successDeleteCampaign');});", True)
                Else
                    If hdfDeleteCampaignFromSearchResults.Value = False Then
                        hdnPanelController.Value = 2
                        showHideSectionsandSidebarItems()
                    End If

                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Cannot_Delete_Campaign.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                End If
            End If
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Campaign.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
        End Try
    End Sub

    Protected Sub btnReturnToSearch_Click(sender As Object, e As EventArgs) Handles btnReturnToSearch.ServerClick, btnRTS.ServerClick
        hdfidfCampaign.Value = "NULL"
        ViewState(campaign) = Nothing
        ViewState(campaignSamples) = Nothing
        ViewState(campaignSessions) = Nothing

        clearCampaign()
        hdfidfCampaign.Value = "NULL"

        'btnCancelCampaignRTD.Visible = False
        'btnCancelCampaignSearch.Visible = True

        showClearandSearchButtons(False)
        showSearchCriteria(False)
        campaignInformation.Visible = False

        searchForm.Visible = True
        btnShowSearchCriteria.Visible = True
        searchResults.Visible = True
        FillCampaignGV(True)
    End Sub

    Protected Sub btnDeleteSampleType_Click(sender As Object, e As EventArgs) Handles btnDeleteSampleType.ServerClick
        Try
            Dim dt As DataTable = ViewState(campaignSamples)

            Dim oHASC As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
            Dim results As Object = Nothing

            If hdfCampaignToSampleTypeID.Value <> "NULL" And hdfCampaignToSampleTypeID.Value <> "" Then
                oHASC.DeleteSample(Convert.ToDouble(hdfCampaignToSampleTypeID.Value), results)
            End If

            dt.Rows.RemoveAt(hdfCampaignToSampleTypeIndex.Value)
            gvSamples.DeleteRow(hdfCampaignToSampleTypeIndex.Value)
            gvSamples.DataSource = dt
            gvSamples.DataBind()

            ViewState(campaignSamples) = dt
            hdfCampaignToSampleTypeID.Value = "NULL"
            hdfCampaignToSampleTypeIndex.Value = "NULL"

            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "1"

            populateSampleTypeAdd()
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
        End Try
    End Sub

#End Region

#End Region

#End Region

#Region "Dropdown List"

    Protected Sub ddlidfsDiagnosis_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsDiagnosis.SelectedIndexChanged
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "0"
        If ddlidfsDiagnosis.SelectedValue <> "null" Then
            populateSampleTypeAdd()
        Else
            fillAllSamples()
        End If
    End Sub



    ' When ddlidfscampaignStatus changes to not new, then conclusion.visible = true
    Protected Sub ddlidfscampaignStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsCampaignStatus.SelectedIndexChanged

        If ddlidfsCampaignStatus.SelectedItem.Text <> "new" Then
            conclusion.Visible = True
        Else
            conclusion.Visible = False
        End If
    End Sub


#End Region

#Region "Gridview"

#Region "Search"
    Protected Sub gvSearchResults_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSearchResults.PageIndexChanging
        gvSearchResults.PageIndex = e.NewPageIndex
        FillCampaignGV(bRefresh:=False)
    End Sub

    Protected Sub gvSearchResults_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSearchResults.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnSelect As LinkButton = e.Row.FindControl("btnSelect")
            Dim lblstrCampaignID As Label = e.Row.FindControl("lblstrCampaignID")

            If Not IsNothing(btnSelect) And Not IsNothing(lblstrCampaignID) Then
                If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignSearch Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignIDSearch Then
                    btnSelect.Visible = True
                    lblstrCampaignID.Visible = False
                Else
                    btnSelect.Visible = False
                    lblstrCampaignID.Visible = True
                End If
            End If
        End If
    End Sub

    Protected Sub gvSearchResults_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvSearchResults.RowDeleting
        hdfidfCampaign.Value = e.Keys.Item(0).ToString()
        hdfDeleteCampaignFromSearchResults.Value = True
        hdfCampaignIndex.Value = e.RowIndex.ToString()
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteCampaign');});", True)
    End Sub

    Protected Sub gvSearchResults_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvSearchResults.RowEditing
        Dim campaignID As Double = Convert.ToInt64(gvSearchResults.DataKeys(e.NewEditIndex).Value)
        e.Cancel = True
        hdfidfCampaign.Value = campaignID.ToString()

        If ddlidfsDiagnosis.SelectedValue.ToString() <> "null" Then
            hdfDiseaseSelected.Value = ddlidfsDiagnosis.SelectedItem.Text
        End If

        searchForm.Visible = False
        campaignInformation.Visible = True
        'Need to make sessions visible here
        sessions.Visible = True

        btnSubmit.Visible = True
        btnDelete.Visible = True

        btnCancelCampaignRTD.Visible = False


        fillCampaignInformation(campaignID)
        'fillCampaignInformationApi(campaignID)
    End Sub

    Protected Sub gvSearchResults_Sorting(sender As Object, e As GridViewSortEventArgs)
        Dim sortedView As DataView = New DataView(ViewState(results))
        Dim sortDir As String = SetSortDirection(e)
        sortedView.Sort = e.SortExpression + " " + sortDir
        gvSearchResults.DataSource = sortedView
        gvSearchResults.DataBind()
        ViewState(results) = sortedView.Table
    End Sub

    Protected Sub gvSearchResults_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles gvSearchResults.SelectedIndexChanging
        Dim btnSelect As LinkButton = gvSearchResults.Rows(e.NewSelectedIndex).FindControl("btnSelect")
        If Not IsNothing(btnSelect) And ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignSearch Then
            Session("SelectedCampaign") = btnSelect.Text
            Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), False)
        ElseIf Not IsNothing(btnSelect) And ViewState(CALLER) = CallerPages.HumanActiveSurveillanceCampaignIDSearch Then
            Session("SelectedCampaign") = gvSearchResults.DataKeys(e.NewSelectedIndex).Value
            Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), False)
        End If
    End Sub

    'Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)
    '    Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
    '    hdfPageIndex.Value = pageIndex
    '    FillHASCList()
    'End Sub

    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

        lblPageNumber.Text = pageIndex.ToString()

        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvSearchResults.PageSize)

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Dim controls As New List(Of Control)
            controls.Clear()

            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvSearchResults.PageIndex = gvSearchResults.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvSearchResults.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvSearchResults.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvSearchResults.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvSearchResults.PageIndex = gvSearchResults.PageSize - 1
                    Else
                        gvSearchResults.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillCampaignSearchList(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvSearchResults.PageIndex = gvSearchResults.PageSize - 1
            Else
                gvSearchResults.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindGridView()
            FillPager(lblNumberOfRecords.Text, pageIndex)
        End If

    End Sub



#End Region

#Region "Create/Edit Campaign"

#Region "Sample"

    Protected Sub gvSamples_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvSamples.RowCancelingEdit
        'Do not remove. Cancel Row Update will Not Work Properly
    End Sub

    Protected Sub gvSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSamples.RowCommand
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "1"

        oCommon = New clsCommon()
        oService = oCommon.GetService()

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        hdfCampaignToSampleTypeIndex.Value = index.ToString()
        Dim dt As DataTable = ViewState(campaignSamples)

        Select Case e.CommandName
            Case "delete"
                Try
                    Dim dr As DataRow = dt.Rows(Convert.ToInt32(index))

                    'Dim id As Double = Convert.ToInt64(dr(ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType))
                    Dim id As Double = dr(ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType)
                    If id <> -1 Then
                        hdfCampaignToSampleTypeID.Value = id
                    End If

                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteSampleType');});", True)
                    populateSampleTypeAdd()
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Delete.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                End Try
            Case "edit"
                Try
                    gvSamples.EditIndex = index
                    gvSamples.Rows(index).RowState = DataControlRowState.Edit

                    gvSamples.DataSource = dt
                    gvSamples.DataBind()

                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Edit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                End Try
            Case "update"
                Try
                    Dim ddlSampleType As DropDownList = gvSamples.Rows(index).FindControl("ddlSampleType")
                    If Not IsNothing(ddlSampleType) Then
                        dt(index)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID) = ddlSampleType.SelectedValue
                        dt(index)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleType) = ddlSampleType.SelectedItem.Text
                    End If

                    Dim txtPlannedNumber As EIDSSControlLibrary.NumericSpinner = gvSamples.Rows(index).FindControl("txtPlannedNumber")
                    If Not IsNothing(txtPlannedNumber) Then
                        Dim plannedNumber As Integer = Convert.ToInt32(txtPlannedNumber.Text)
                        If (plannedNumber < 1) Then
                            lbl_Error.InnerText = GetLocalResourceObject("lbl_Positive_Planned_Number.InnerText")
                            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                            Exit Sub
                        Else
                            dt(index)(ActiveSurveillanceCampaignToSampleTypeConstants.PlannedNumber) = plannedNumber
                        End If
                    End If

                    gvSamples.EditIndex = -1
                    gvSamples.DataSource = dt
                    gvSamples.DataBind()
                    ViewState(campaignSamples) = dt

                    populateSampleTypeAdd()
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Update.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                End Try
            Case "cancel"
                Try
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelSampleType');});", True)
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Cancel.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                End Try
            Case "insert"
                Try
                    Dim ddlSampleType As DropDownList = gvSamples.HeaderRow.FindControl("ddlSampleType")
                    Dim txtPlannedNumber As EIDSSControlLibrary.NumericSpinner = gvSamples.HeaderRow.FindControl("txtPlannedNumber")

                    If Not IsNothing(ddlSampleType) And Not IsNothing(txtPlannedNumber) Then
                        If (ddlSampleType.SelectedValue <> "" And txtPlannedNumber.Text = "") Or (ddlSampleType.SelectedIndex = 0 And txtPlannedNumber.Text <> "") Then
                            lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Sample.InnerText")
                            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                            Exit Sub
                        Else

                            Dim plannedNumber As Integer = Convert.ToInt32(txtPlannedNumber.Text)

                            If (plannedNumber < 1) Then
                                lbl_Error.InnerText = GetLocalResourceObject("lbl_Positive_Planned_Number.InnerText")
                                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                                Exit Sub
                            End If
                            If IsNothing(ViewState(campaignSamples)) Then
                                dt = New DataTable()
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.Campaign)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.Order)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SpeciesTypeID)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SpeciesType)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.PlannedNumber)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.SampleType)
                                dt.Columns.Add(ActiveSurveillanceCampaignToSampleTypeConstants.HasOpenSession)
                            Else
                                dt = ViewState(campaignSamples)
                            End If

                            dt.Rows.Add(hdfidfCampaign.Value, -1, dt.Rows.Count, Nothing, Nothing, Convert.ToInt32(txtPlannedNumber.Text), ddlSampleType.SelectedValue, ddlSampleType.SelectedItem.Text, False)

                            'Set session 
                            ViewState(campaignSamples) = dt

                            'Set gridview to  Samples 
                            gvSamples.DataSource = dt
                            gvSamples.DataBind()

                            txtPlannedNumber.Text = String.Empty
                            ddlSampleType.SelectedIndex = 0

                            populateSampleTypeAdd()

                            gvSamples.Columns(2).Visible = True
                            gvSamples.Columns(3).Visible = True
                        End If
                    End If
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Adding_Sample.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                End Try
        End Select

    End Sub

    Protected Sub gvSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSamples.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim ddlSampleType As DropDownList = e.Row.FindControl("ddlSampleType")
            If Not IsNothing(ddlSampleType) Then
                Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                FillDropDown(ddlSampleType, GetType(clsSampleDisease), {ddlidfsDiagnosis.SelectedValue}, SampleTypeConstants.SampleTypeID, SampleTypeConstants.SampleTypeName, dr(SampleTypeConstants.SampleTypeID).ToString(), Nothing, True)
                disableEditSelectedSampleTypes(ddlSampleType)
                ddlSampleType.ToolTip = dr("sampleType")
            End If
        ElseIf e.Row.RowType = DataControlRowType.Header Then
            populateSampleTypeAdd()
        End If
    End Sub

    Protected Sub gvSamples_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvSamples.RowEditing
        'Do not remove. Edit Row Will Not Work Properly
    End Sub

    Protected Sub gvSamples_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvSamples.RowUpdating
        'Do not remove. Update Row will Not Work Properly
    End Sub

    Protected Sub gvSamples_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        'Do not remove. Delete Row will Not Work Properly
    End Sub

#End Region

#Region "Session"

    Protected Sub gvSessions_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)

    End Sub

    Protected Sub gvSessions_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        showHideSectionsandSidebarItems()
        hdnPanelController.Value = "2"

        Dim dt As DataTable = ViewState(campaignSessions)

        Select Case e.CommandName
            Case "edit"
                ViewState(CALLER_KEY) = gvSessions.DataKeys(CType(e.CommandArgument, Double)).Value.ToString()
                ViewState(CALLER) = CallerPages.HumanActiveSurveillanceEditCampaignSession
            Case "delete"
                Try
                    hdfCampaignToMonitoringSessionIndex.Value = e.CommandArgument
                    hdfCampaignToMonitoringSessionID.Value = Convert.ToInt64(dt.Rows(Convert.ToInt32(e.CommandArgument))(ActiveSurveillanceSessionConstants.Session)).ToString()
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteSession');});", True)
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Delete.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
                End Try
        End Select
    End Sub

    Protected Sub gvSessions_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

    End Sub

    Protected Sub gvSessions_RowEditing(sender As Object, e As GridViewEditEventArgs)

        e.Cancel = True
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), False)

    End Sub

    Protected Sub gvSessions_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs)

    End Sub


#End Region

#End Region

#End Region

#Region "Multiple"

    Protected Sub searchCriteria_Changed(sender As Object, e As EventArgs) Handles txtCampaignNameFilter.TextChanged, txtCampaignNameFilter.TextChanged, txtCampaignStrIDFilter.TextChanged, ddlCampaignTypedFilter.TextChanged, ddlCampaignDiseaseFilter.SelectedIndexChanged, ddlCampaignStatusFilter.SelectedIndexChanged
        searchResults.Visible = False
        searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
        btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        btnShowSearchCriteria.Visible = False
    End Sub

#End Region

#Region "Private"

#Region "Search"
    Private Sub FillSearchDropdowns()
        BaseReferenceLookUp(ddlCampaignStatusFilter, BaseReferenceConstants.ASCampaignStatus, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlCampaignTypedFilter, BaseReferenceConstants.ASCampaignType, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlCampaignDiseaseFilter, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
        GetSearchFields()
    End Sub

    Public Sub GetSearchFields()

        Dim oVAS As HumanActSurvSearchData

        Dim oSerializer As XmlSerializer = New XmlSerializer(GetType(HumanActSurvSearchData))
        Dim oFileStream As FileStream
        Dim sFile As String = Server.MapPath("\") & "App_Data\" & Session("UserID").ToString() & "_HASC.xml"

        If sFile <> "" AndAlso File.Exists(sFile) Then     'Else is not added to the code due to not having the search criteria file values to populate GridView

            oFileStream = New FileStream(sFile, FileMode.Open)
            oVAS = oSerializer.Deserialize(oFileStream)

            With oVAS
                If (oVAS.CampaignStatus <> "" AndAlso oVAS.CampaignStatus <> "-1") Then
                    ddlCampaignStatusFilter.SelectedValue = .CampaignStatus
                End If
                txtCampaignStrIDFilter.Text = .CampaignID
                txtCampaignNameFilter.Text = .CampaignName
                txtStartDateFromFilter.Text = .StartDate
                txtStartToFilter.Text = .EndDate
                If (oVAS.CampaignType <> "" AndAlso oVAS.CampaignType <> "-1") Then
                    ddlCampaignTypedFilter.SelectedValue = .CampaignType
                End If
                If (oVAS.CampaignDisease <> "" AndAlso oVAS.CampaignDisease <> "-1") Then
                    ddlCampaignDiseaseFilter.SelectedValue = .CampaignDisease
                End If

            End With
            oFileStream.Close()
            oFileStream.Dispose()


        End If

    End Sub

    Private Function FillCampaignGV(Optional bRefresh As Boolean = False)
        FillCampaignGV = Nothing
        'Dim dt As DataTable

        Try
            'Replace old service

            'Dim oHASC As New clsHumanActiveSurveillance()
            'oCommon = New clsCommon()
            'oService = oCommon.GetService()
            'Dim aSP As String() = oService.getSPList("HumActiveSurvGetList")
            'Dim strParams As String = oCommon.Gather(search, aSP(0), 3, True)
            'oDS = oHASC.ListAll({strParams}) 'filter fields need to apply
            'dt = oDS.Tables(0) '.DefaultView.ToTable

            'If oDS.CheckDataSet() Then
            '    Dim paramNames As String() = {ActiveSurveillanceCampaignConstants.CampaignID, ActiveSurveillanceCampaignConstants.CampaignName, ActiveSurveillanceCampaignConstants.CampaignType, ActiveSurveillanceCampaignConstants.CampaignStatus, ActiveSurveillanceCampaignConstants.StartDate, ActiveSurveillanceCampaignConstants.EndDate, ActiveSurveillanceCampaignConstants.Diagnosis, ActiveSurveillanceCampaignConstants.Campaign, ActiveSurveillanceCampaignConstants.CampaignAdministrator, ActiveSurveillanceCampaignConstants.SampleTypesList}
            '    dt = dt.DefaultView.ToTable(True, paramNames)
            'End If

            Dim humanActiveGetParameters = New HumanActiveSurveillanceGetListParams() With {.langId = GetCurrentLanguage(), .campaignModule = "human"}
            humanActiveGetParameters.langId = GetCurrentLanguage()
            humanActiveGetParameters.campaignModule = "human"




            If Not txtCampaignStrIDFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.campaignStrIdFilter = txtCampaignStrIDFilter.Text 'CampaignID

            End If

            If Not txtCampaignNameFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.campaignNameFilter = txtCampaignNameFilter.Text 'CampaignName

            End If




            If Not txtStartDateFromFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.startDateFromFilter = txtStartDateFromFilter.Text 'StartDate
            End If

            If Not txtStartToFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.startToFilter = txtStartToFilter.Text 'EndDate
            End If

            If (Not ddlCampaignTypedFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignTypedFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignTypedFilter = ddlCampaignTypedFilter.SelectedValue.ToInt32 'CampaignType

            End If

            If (Not ddlCampaignDiseaseFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignDiseaseFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignDiseaseFilter = ddlCampaignDiseaseFilter.SelectedValue.ToInt32 'CampaignDisease

            End If

            If (Not ddlCampaignStatusFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignStatusFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignStatusFilter = ddlCampaignStatusFilter.SelectedValue.ToInt32 'CampaignStatus

            End If

            '           Dim list = HumanServiceClientAPIClient.HumanActiveSurveillanceCampaignListAsync(Gather(search, humanActiveGetParameters, 3)).Result Gather returns too much data
            Dim list = HumanServiceClientAPIClient.HumanActiveSurveillanceCampaignListAsync(humanActiveGetParameters).Result


            'pagination 
            lblNumberOfRecords.Text = list.Count
            lblPageNumber.Text = "1"
            FillCampaignSearchList(pageIndex:=1, paginationSetNumber:=1)
            gvSearchResults.PageIndex = 0
            'SaveSearchCriteria()

        Catch ex As Exception
            Throw
        Finally

        End Try

    End Function

    Private Sub FillCampaignSearchList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim humanActiveGetParameters = New HumanActiveSurveillanceGetListParams()

            ' Make this into a sub

            humanActiveGetParameters = New HumanActiveSurveillanceGetListParams() With {.langId = GetCurrentLanguage(), .campaignModule = "human"}
            humanActiveGetParameters.langId = GetCurrentLanguage()
            humanActiveGetParameters.campaignModule = "human"




            If Not txtCampaignStrIDFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.campaignStrIdFilter = txtCampaignStrIDFilter.Text 'CampaignID

            End If

            If Not txtCampaignNameFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.campaignNameFilter = txtCampaignNameFilter.Text 'CampaignName

            End If

            If Not txtStartDateFromFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.startDateFromFilter = txtStartDateFromFilter.Text 'StartDate
            End If

            If Not txtStartToFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.startToFilter = txtStartToFilter.Text 'EndDate
            End If

            If (Not ddlCampaignTypedFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignTypedFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignTypedFilter = ddlCampaignTypedFilter.SelectedValue.ToInt32 'CampaignType

            End If

            If (Not ddlCampaignDiseaseFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignDiseaseFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignDiseaseFilter = ddlCampaignDiseaseFilter.SelectedValue.ToInt32 'CampaignDisease

            End If

            If (Not ddlCampaignStatusFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignStatusFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignStatusFilter = ddlCampaignStatusFilter.SelectedValue.ToInt32 'CampaignStatus

            End If

            Session(SESSION_SEARCH_LIST) = HumanServiceClientAPIClient.HumanActiveSurveillanceCampaignListAsync(humanActiveGetParameters).Result
            gvSearchResults.DataSource = Nothing
            BindGridView()
            FillPager(lblNumberOfRecords.Text, pageIndex)
            ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    '''' <summary>
    '''' 
    '''' </summary>
    Private Sub BindGridView()

        Dim list As List(Of GblAscampaignGetListModel) = CType(Session(SESSION_SEARCH_LIST), List(Of GblAscampaignGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvSearchResults.DataSource = list
        gvSearchResults.DataBind()

    End Sub

    Private Sub FillPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        'Calculate the start and end index of pages to be displayed.
        Dim dblPageCount As Double = recordCount / Convert.ToDecimal(10)
        Dim pageCount As Integer = Math.Ceiling(dblPageCount)
        startIndex = If(currentPage > 1 AndAlso currentPage + pagerSpan - 1 < pagerSpan, currentPage, 1)
        endIndex = If(pageCount > pagerSpan, pagerSpan, pageCount)
        If currentPage > pagerSpan Mod 2 Then
            If currentPage = 2 Then
                endIndex = 5
            Else
                endIndex = currentPage + 2
            End If
        Else
            endIndex = (pagerSpan - currentPage) + 1
        End If

        If endIndex - (pagerSpan - 1) > startIndex Then
            startIndex = endIndex - (pagerSpan - 1)
        End If

        If endIndex > pageCount Then
            endIndex = pageCount
            startIndex = If(((endIndex - pagerSpan) + 1) > 0, (endIndex - pagerSpan) + 1, 1)
        End If

        'Add the First Page Button.
        If currentPage > 1 Then
            pages.Add(New ListItem("<<", "1"))
        End If

        'Add the Previous Button.
        If currentPage > 1 Then
            pages.Add(New ListItem("<", (currentPage - 1).ToString()))
        End If

        Dim paginationSetNumber As Integer = 1,
            pageCounter As Integer = 1

        For i As Integer = startIndex To endIndex
            pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
        Next

        'Add the Next Button.
        If currentPage < pageCount Then
            pages.Add(New ListItem(">", (currentPage + 1).ToString()))
        End If

        'Add the Last Button.
        If currentPage <> pageCount Then
            pages.Add(New ListItem(">>", pageCount.ToString()))
        End If
        'rptPager.DataSource = pages
        'rptPager.DataBind()
        rptPager.DataSource = pages
        rptPager.DataBind()

    End Sub

    Private Function SetSortDirection(ByVal e As GridViewSortEventArgs) As String

        Dim dir As String
        Dim lastCol As String = String.Empty
        If Not IsNothing(ViewState("vecCol")) Then lastCol = ViewState("vecCol").ToString()
        If lastCol = e.SortExpression Then
            If ViewState("vecDir") = "0" Then
                dir = "DESC"
                ViewState("vecDir") = SortDirection.Descending
            Else
                dir = "ASC"
                ViewState("vecDir") = SortDirection.Ascending
            End If
        Else
            dir = "ASC"
            ViewState("vecDir") = SortDirection.Ascending
        End If
        ViewState("vecCol") = e.SortExpression
        Return dir
    End Function

    Private Function ValidateForSearch() As Boolean

        Dim blnValidated As Boolean = False

        Dim oCommon As clsCommon = New clsCommon()

        'Check if Farm ID is entered.
        'If Yes then ignore rest of the search fields
        'If No, check if any other search criteria is entered, if not, raise error.
        blnValidated = (Not txtCampaignStrIDFilter.Text.IsValueNullOrEmpty())

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
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.Equals("null"))
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In oCommon.FindCtrl(allCtrl, search, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If
        End If

        Return blnValidated

    End Function

    Private Sub FillHASCList(Optional bRefresh As Boolean = False)

        Dim oEmp As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
        Dim oDS As DataSet = Nothing

        Try

            'Dim aSP As String()
            'Dim formValues As String = ""

            'aSP = oCommon.GetSPList("HumActiveSurvGetList")
            'formValues = oCommon.Gather(search, aSP(SPType.SPGetList).ToString(), 3, True)

            'oDS = oEmp.ListAll({formValues})

            'oDS.CheckDataSet()

            Dim humanActiveGetParameters = New HumanActiveSurveillanceGetListParams() With {.langId = GetCurrentLanguage(), .campaignModule = "human"}
            humanActiveGetParameters.langId = GetCurrentLanguage()
            humanActiveGetParameters.campaignModule = "human"




            If Not txtCampaignStrIDFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.campaignStrIdFilter = txtCampaignStrIDFilter.Text 'CampaignID

            End If

            If Not txtCampaignNameFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.campaignNameFilter = txtCampaignNameFilter.Text 'CampaignName

            End If




            If Not txtStartDateFromFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.startDateFromFilter = txtStartDateFromFilter.Text 'StartDate
            End If

            If Not txtStartToFilter.Text.IsValueNullOrEmpty Then
                humanActiveGetParameters.startToFilter = txtStartToFilter.Text 'EndDate
            End If

            If (Not ddlCampaignTypedFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignTypedFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignTypedFilter = ddlCampaignTypedFilter.SelectedValue.ToInt32 'CampaignType

            End If

            If (Not ddlCampaignDiseaseFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignDiseaseFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignDiseaseFilter = ddlCampaignDiseaseFilter.SelectedValue.ToInt32 'CampaignDisease

            End If

            If (Not ddlCampaignStatusFilter.SelectedValue.IsValueNullOrEmpty AndAlso ddlCampaignStatusFilter.SelectedValue <> "-1") Then
                humanActiveGetParameters.campaignStatusFilter = ddlCampaignStatusFilter.SelectedValue.ToInt32 'CampaignStatus

            End If




            '           Dim list = HumanServiceClientAPIClient.HumanActiveSurveillanceCampaignListAsync(Gather(search, humanActiveGetParameters, 3)).Result Gather returns too much data
            Dim list = HumanServiceClientAPIClient.HumanActiveSurveillanceCampaignListAsync(humanActiveGetParameters).Result





            'hdfRecordCount.Value = oDS.Tables(1).Rows(0).Item("RecordCount") & ""
            hdfRecordCount.Value = list.Count

            'With gvSearchResults
            '    .DataSource = oDS.Tables(0)
            '    .DataBind()
            '    .SelectedIndex = -1
            'End With

            PopulatePageSection(rptPager, hdfRecordCount.Value, hdfPageIndex.Value)

        Catch ex As Exception

            Throw

        Finally

            'Clean objects
            oEmp = Nothing
            oDS = Nothing

        End Try

    End Sub

    Private Sub showSearchCriteria(ByVal show As Boolean)
        If show Then
            searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
        Else
            searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            btn_scSearch.Visible = True
            btn_scClear.Visible = True
        End If
    End Sub

    Private Sub showClearandSearchButtons(ByVal show As Boolean)
        btnSearch.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)
        btnClear.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)

        If show Then
            btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
            btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
            btn_scSearch.Visible = False
            btn_scClear.Visible = False
        Else
            btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        End If
    End Sub

#End Region

#Region "Create/Edit Campaign"

    Private Sub FillSamples()
        If Not IsNothing(ViewState(campaignSamples)) Then
            Dim dt As DataTable = ViewState(campaignSamples)

            For i As Integer = 0 To dt.Rows.Count - 1
                Dim sampleStringBuilder As StringBuilder = New StringBuilder()

                If dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType) = -1 Then
                    'sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType & ";NULL;INOUT|")
                    sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType & ";;IN|")
                Else

                    sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType & ";" & dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType) & ";INOUT|")
                End If
                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.Campaign & ";" & hdfidfCampaign.Value & ";IN|")
                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID & ";" & dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.SpeciesTypeID & ";NULL;IN|")
                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.PlannedNumber & ";" & dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.PlannedNumber) & ";IN|")
                sampleStringBuilder.AppendFormat("@" & ActiveSurveillanceCampaignToSampleTypeConstants.Order & ";" & dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.Order) & ";IN")

                oCommon = New clsCommon
                oService = oCommon.GetService()
                oDS = New DataSet()
                Dim oTuple1 As Object = Nothing

                oTuple1 = oService.GetData(GetCurrentCountry(), "HumanActiveSurvCampaignToSampleType", sampleStringBuilder.ToString())
            Next
        End If
    End Sub

    Private Sub FillSamplesApi()
        Try

            'Need to replace this   = --oTuple1 = oService.GetData(GetCurrentCountry(), "HumanActiveSurvCampaignToSampleType", sampleStringBuilder.ToString())


        Catch ex As Exception

            Throw

        Finally

            'Clean objects
            oDS = Nothing

        End Try
    End Sub

    Private Sub fillCampaignDropdowns()
        BaseReferenceLookUp(ddlidfsCampaignStatus, BaseReferenceConstants.ASCampaignStatus, HACodeList.HumanHACode, False)
        BaseReferenceLookUp(ddlidfsCampaignType, BaseReferenceConstants.ASCampaignType, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlidfsDiagnosis, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
    End Sub

    Private Sub fillCampaignInformation(ByVal id As Double)
        oCommon = New clsCommon()
        Dim hasc As clsHumActiveSurvCampaign = New clsHumActiveSurvCampaign()
        oDS = hasc.SelectOne(id)

        If oDS.CheckDataSet() Then
            searchForm.Visible = False
            campaignInformation.Visible = True
            oCommon.Scatter(campaignInformation, New DataTableReader(oDS.Tables(0)), 3, True)
            oCommon.Scatter(divHiddenFieldsSection, New DataTableReader(oDS.Tables(0)), 3, True)


            If ddlidfsDiagnosis.SelectedValue.ToString() <> "null" Then
                hdfDiseaseSelected.Value = ddlidfsDiagnosis.SelectedItem.Text
            End If






            If hdfidfCampaign.Value <> "NULL" Then
                divCampaignID.Visible = True
            Else
                divCampaignID.Visible = False
            End If

            gvSamples.DataSource = oDS.Tables(1)
            gvSamples.DataBind()

            ViewState(campaignSamples) = oDS.Tables(1)

            If ddlidfsDiagnosis.SelectedIndex < 0 Then
                populateSampleTypeAdd()
            Else
                fillAllSamples()
            End If

            If hdfDiseaseSelected.Value <> "null" Then
                ddlidfsDiagnosis.SelectedItem.Text = hdfDiseaseSelected.Value
            End If


            gvSessions.DataSource = oDS.Tables(2)
            gvSessions.DataBind()
            ViewState(campaignSessions) = oDS.Tables(2)

            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "0"
        End If
    End Sub

    Private Sub fillCampaignInformationApi(ByVal id As Double)
        'oCommon = New clsCommon()
        'Dim hasc As clsHumActiveSurvCampaign = New clsHumActiveSurvCampaign()
        'oDS = hasc.SelectOne(id)



        If id >= 0 Then
            searchForm.Visible = False
            campaignInformation.Visible = True
            'oCommon.Scatter(campaignInformation, New DataTableReader(oDS.Tables(0)), 3, True)
            'oCommon.Scatter(divHiddenFieldsSection, New DataTableReader(oDS.Tables(0)), 3, True)

            Dim hascParameters = New HumanActiveSurveillanceGetListParams() With {.langId = GetCurrentLanguage(), .campaignModule = "Human"}
            Dim listOfOnehasc As List(Of GblAscampaignGetListModel) = HumanServiceClientAPIClient.HumanActiveSurveillanceCampaignListAsync(hascParameters).Result


            'hdfstrCaseID.Value = strCase
            hdfidfCampaign.Value = listOfOnehasc(0).idfCampaign
            'lblCASEIDDel.Text = "Delete CASE ID: " & strCase

            Scatter(campaignInformation, listOfOnehasc(0), 3, True)
            Scatter(divHiddenFieldsSection, listOfOnehasc(0), 3, True)





            If hdfidfCampaign.Value <> "NULL" Then
                divCampaignID.Visible = True
            Else
                divCampaignID.Visible = False
            End If


            'TBD - What is oDS.Tables(1) AK

            gvSamples.DataSource = oDS.Tables(1)
            gvSamples.DataBind()

            ViewState(campaignSamples) = oDS.Tables(1)

            If ddlidfsDiagnosis.SelectedIndex < 0 Then
                populateSampleTypeAdd()
            Else
                fillAllSamples()
            End If

            'TBD - What is oDS.Tables(2) AK
            gvSessions.DataSource = oDS.Tables(2)
            gvSessions.DataBind()
            ViewState(campaignSessions) = oDS.Tables(2)

            showHideSectionsandSidebarItems()
            hdnPanelController.Value = "0"
        End If
    End Sub

    Private Sub showHideSectionsandSidebarItems()
        If hdfidfCampaign.Value = "NULL" Then
            'Hides Session Tab
            sessions.Visible = False
            'sideBarItemSessions.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
            'sideBarItemSessions.IsActive = False
            'sideBarItemSessions.Visible = False
            'sideBarItemSessions.GoToTab = String.Empty
            ''Hides Conclusion Tab
            'conclusion.Visible = False
            'sideBarItemConclusions.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
            'sideBarItemConclusions.IsActive = False
            'sideBarItemConclusions.Visible = False
            'sideBarItemConclusions.GoToTab = String.Empty
            'sideBarItemReview.GoToTab = "2"
        Else
            'Hides Session Tab
            sessions.Visible = True
            'sideBarItemSessions.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            'sideBarItemSessions.IsActive = True
            'sideBarItemSessions.Visible = True
            'sideBarItemSessions.GoToTab = "2"
            'Hides Conclusion Tab
            conclusion.Visible = True
            'sideBarItemConclusions.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            'sideBarItemConclusions.IsActive = True
            'sideBarItemConclusions.Visible = True
            'sideBarItemConclusions.GoToTab = "3"
            'sideBarItemReview.GoToTab = "4"
        End If

    End Sub

    Private Sub disableSelectedSampleTypes(ByRef ddl As DropDownList)

        If Not IsNothing(ViewState(campaignSamples)) Then
            Dim dt As DataTable = ViewState(campaignSamples)
            For i As Integer = 0 To dt.Rows.Count() - 1
                Dim li As ListItem = ddl.Items.FindByValue(dt.Rows(i)(ActiveSurveillanceCampaignToSampleTypeConstants.SampleTypeID))
                If Not IsNothing(li) Then
                    li.Enabled = False
                End If
            Next
        End If
    End Sub

    Private Sub disableEditSelectedSampleTypes(ByRef ddl As DropDownList)

        If Not IsNothing(ViewState(campaignSamples)) Then
            Dim dt As DataTable = ViewState(campaignSamples)
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

    Private Sub populateSampleTypeAdd()
        If Not IsNothing(gvSamples.HeaderRow) Then
            Dim ddlSampleType As DropDownList = gvSamples.HeaderRow.FindControl("ddlSampleType")
            Dim txtPlannedNumber As EIDSSControlLibrary.NumericSpinner = gvSamples.HeaderRow.FindControl("txtPlannedNumber")
            Dim btnAdd As LinkButton = gvSamples.HeaderRow.FindControl("btnAdd")

            If Not IsNothing(ddlSampleType) Then
                FillDropDown(ddlSampleType, GetType(clsSampleDisease), {ddlidfsDiagnosis.SelectedValue}, SampleTypeConstants.SampleTypeID, SampleTypeConstants.SampleTypeName, Nothing, Nothing, True)
                disableSelectedSampleTypes(ddlSampleType)
            End If

            Dim dt As DataTable = ViewState(campaignSamples)
            If Not IsNothing(dt) Then
                Dim samples As Integer = dt.Rows.Count()
                If ddlSampleType.Items.Count - samples < 2 Then
                    ddlSampleType.Enabled = False                       '  Why AK   
                    txtPlannedNumber.Enabled = False                     ' Why AK                   
                    btnAdd.Visible = False
                Else
                    ddlSampleType.Enabled = True
                    txtPlannedNumber.Enabled = True
                    btnAdd.Visible = True
                End If
            Else
                ddlSampleType.Enabled = False
                txtPlannedNumber.Enabled = False
                btnAdd.Visible = False
            End If
        End If
    End Sub

    Private Sub fillAllSamples()
        If Not IsNothing(gvSamples.HeaderRow) Then
            Dim ddlSampleType As DropDownList = gvSamples.HeaderRow.FindControl("ddlSampleType")
            Dim txtPlannedNumber As EIDSSControlLibrary.NumericSpinner = gvSamples.HeaderRow.FindControl("txtPlannedNumber")
            If Not IsNothing(ddlSampleType) Then
                BaseReferenceLookUp(ddlSampleType, BaseReferenceConstants.SampleType, HACodeList.HumanHACode, True)
                ddlSampleType.Enabled = True
            End If
            If Not IsNothing(txtPlannedNumber) Then
                txtPlannedNumber.Enabled = True
            End If
        End If
    End Sub

#End Region

    Private Sub clearCampaign()
        ViewState(CALLER) = CallerPages.Dashboard
        ViewState(CALLER_KEY) = 0
        hdfidfCampaign.Value = "NULL"
        ViewState(campaign) = Nothing
        ViewState(campaignSamples) = Nothing
        ViewState(campaignSessions) = Nothing
    End Sub

    Private Function validateDates(startDate As String, endDate As String, Optional isRange As Boolean = True) As Boolean
        If String.IsNullOrWhiteSpace(startDate) And String.IsNullOrWhiteSpace(endDate) Then
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

    Private Sub ActiveSurveillanceCampaign_Error(Sender As Object, e As EventArgs) Handles Me.[Error]
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

    'Private Sub ddlidfsCampaignStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsCampaignStatus.SelectedIndexChanged
    '    If ddlidfsCampaignStatus.SelectedValue <> "new" Then
    '        conclusion.Visible = True
    '    Else
    '        conclusion.Visible = False
    '        End If
    'End Sub

#End Region

End Class

Public Class HumanActSurvSearchData

    Private stxtCampaignID As String
    Private stxtCampaignName As String
    Private sddlCampaignType As String
    Private sddlCampaignStatus As String
    Private sddlCampaignDisease As String
    Private stxtCampaignAdmin As String
    Private stxtStartDate As String
    Private stxtEndDate As String

    Public Property CampaignID As String
        Get
            Return stxtCampaignID
        End Get
        Set(value As String)
            stxtCampaignID = value
        End Set
    End Property

    Public Property CampaignName As String
        Get
            Return stxtCampaignName
        End Get
        Set(value As String)
            stxtCampaignName = value
        End Set
    End Property

    Public Property CampaignType As String
        Get
            Return sddlCampaignType
        End Get
        Set(value As String)
            sddlCampaignType = value
        End Set
    End Property

    Public Property CampaignStatus As String
        Get
            Return sddlCampaignStatus
        End Get
        Set(value As String)
            sddlCampaignStatus = value
        End Set
    End Property

    Public Property CampaignDisease As String
        Get
            Return sddlCampaignDisease
        End Get
        Set(value As String)
            sddlCampaignDisease = value
        End Set
    End Property

    Public Property CampaignAdmin As String
        Get
            Return stxtCampaignAdmin
        End Get
        Set(value As String)
            stxtCampaignAdmin = value
        End Set
    End Property

    Public Property StartDate As String
        Get
            Return stxtStartDate
        End Get
        Set(value As String)
            stxtStartDate = value
        End Set
    End Property

    Public Property EndDate As String
        Get
            Return stxtEndDate
        End Get
        Set(value As String)
            stxtEndDate = value
        End Set
    End Property

End Class