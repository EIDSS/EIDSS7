Imports System.IO
Imports System.Xml.Serialization
Imports System.Web.Configuration
Imports System.Resources
Imports EIDSS.EIDSS

Public Class EmployeeAdmin
    Inherits BaseEidssPage

    Private sFile As String
    Dim oEIDSSDS As DataSet = Nothing

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"

    Private oCommon As clsCommon = New clsCommon()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack() Then

            'Assign defaults from current user data
            Dim sUserSettingsFile As String = oCommon.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
            oEIDSSDS = oCommon.ReadEIDSSXML(sUserSettingsFile)
            If oEIDSSDS.CheckDataSet() Then
                hdfidfUserID.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfUserID") & ""
                hdfidfInstitution.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfInstitution") & ""
            End If

            ExtractViewStateSession()

            'Load Position
            BaseReferenceLookUp(ddlidfPosition, BaseReferenceConstants.EmployeePosition, HACodeList.NoneHACode, True)

            'Load Organization List
            FillDropDown(ddlOrganization _
                        , GetType(clsOrganization) _
                        , Nothing _
                        , OrganizationConstants.idfInstitution _
                        , OrganizationConstants.OrgName _
                        , hdfidfInstitution.Value _
                        , Nothing _
                        , True)

            'Restore search filters
            sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.EmployeeAdminPrefix)
            oCommon.GetSearchFields({searchUpdatePanel}, sFile)

            'List data
            FillEmployeeList(True)

            If (ViewState(CALLER) = CallerPages.HumanDiseaseReport Or ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationPersonSearch) Then
                gvEmployeeList.Columns(4).Visible = True
            Else
                gvEmployeeList.Columns(4).Visible = False
            End If

        End If

    End Sub

#Region "Methods"

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

    Private Sub FillEmployeeList(Optional bRefresh As Boolean = False)

        Dim oEmp As clsEmployee = New clsEmployee()
        Dim oDS As DataSet = Nothing

        Try

            Dim aSP As String()
            Dim formValues As String = ""

            aSP = oCommon.GetSPList(EIDSSModules.Employee)
            formValues = oCommon.Gather(searchUpdatePanel, aSP(SPType.SPGetList).ToString(), 3, True)

            oDS = oEmp.ListAll({formValues})

            ' oDS.CheckDataSet()


            If oDS.CheckDataSet Then
                hdfRecordCount.Value = oDS.Tables(1).Rows(0).Item("RecordCount") & ""
            End If

            With gvEmployeeList
                .DataSource = oDS.Tables(0)
                .DataBind()
                .SelectedIndex = -1
            End With

            PopulatePageSection(rptPageSection, hdfRecordCount.Value, hdfPageIndex.Value)

        Catch ex As Exception

            Throw

        Finally

            'Clean objects
            oEmp = Nothing
            oDS = Nothing

        End Try

    End Sub

    Private Sub CallEmployeeDetails()

        oCommon.SaveSearchFields({divHiddenFieldsSection}, CallerPages.EmployeeAdmin, "")
        Response.Redirect(GetURL(CallerPages.EmployeeDetailsURL), True)

    End Sub

    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
        hdfPageIndex.Value = pageIndex
        FillEmployeeList()

    End Sub

#End Region

#Region "Grid Events"

    Private Sub gvEmployeeList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvEmployeeList.PageIndexChanging

        gvEmployeeList.PageIndex = e.NewPageIndex
        FillEmployeeList()

    End Sub

    Private Sub gvEmployeeList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvEmployeeList.RowCommand

        If e.CommandName.ToUpper().EqualsAny("SELECT,EDIT,DELETE".Split(",")) Then
            Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvEmployeeList.Rows(idx)

            'Set the values of selected row in hidden fields
            With gvEmployeeList.DataKeys(idx)
                hdfidfEmployee.Value = .Values(EmployeeConstants.idfEmployee)
                hdfidfInstitution.Value = .Values(PersonConstants.idfInstitution)
                hdfPosition.Value = .Values(PositionConstants.idfPositionId)

                'values for returning to the HDR page after choosing a facility/person
                hdfEAEmployeeId.Value = .Values(EmployeeConstants.idfEmployee)
                hdfEAEmployeeFullName.Value = row.Cells(6).Text + " " + row.Cells(5).Text
                hdfEAFirstName.Value = row.Cells(6).Text
                hdfEAPatronymicName.Value = ""
                hdfEALastName.Value = row.Cells(5).Text
                hdfEAInstitutionId.Value = .Values(OrganizationConstants.idfInstitution)
                hdfEAInstitutionFullName.Value = row.Cells(8).Text
            End With
        End If

    End Sub

    'Private Sub gvEmployeeList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvEmployeeList.RowDeleting

    '    Dim oEmp As clsEmployee = New clsEmployee()
    '    If Not hdfidfEmployee.Value.IsValueNullOrEmpty() Then

    '        Try

    '            oEmp.Delete(Double.Parse(hdfidfEmployee.Value))
    '            FillEmployeeList(True)

    '        Finally

    '            oEmp = Nothing

    '        End Try

    '    End If

    'End Sub




    Protected Sub gvEmployeeList_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvEmployeeList.RowEditing

        e.Cancel = True
        CallEmployeeDetails()

    End Sub

    Protected Sub gvEmployeeList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvEmployeeList.SelectedIndexChanged
        If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationPersonSearch Then
            Session("EmployeeID") = gvEmployeeList.SelectedDataKey.Value

            Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), True)
        ElseIf Not IsNothing(hdfidfEmployee.Value) Then
            If (ViewState(CALLER) = CallerPages.HumanDiseaseReport) Then
                'write selected values to xml session file for page EmployeeAdmin.aspx
                Dim oComm As clsCommon = New clsCommon()
                'Get search filters
                Dim ctrlList As ICollection(Of Web.UI.Control) = {divHiddenFieldsEAtoHDRResponse}
                sFile = oComm.CreateTempFile(CallerPages.EmployeeAdminPrefix)
                oComm.SaveSearchFields(ctrlList, "EAtoHDRResponse", sFile)

                ViewState(CALLER) = CallerPages.EmployeeAdmin
                oCommon.SaveViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), True)
            End If
        End If

    End Sub

    Protected Sub gvEmployeeList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvEmployeeList.RowDeleting
        hdfidfEmployee.Value = e.Keys.Item(0).ToString()

        'hdfidfEmployee.Value = e.RowIndex.ToString()
        Dim Message As String = "alert('hello wolrd')"
        'ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), Guid.NewGuid().ToString(), Message, True)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteEmployee');});", True)




    End Sub

#End Region

#Region "Button Click Events"

    Private Sub btnNew_ServerClick(sender As Object, e As EventArgs) Handles btnNew.ServerClick

        hdfidfEmployee.Value = -1
        hdfPosition.Value = -1
        hdfidfInstitution.Value = -1

        Dim sUserFile As String = oCommon.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
        Dim oUserDefaultsDS As DataSet = oCommon.ReadEIDSSXML(sUserFile)
        If oUserDefaultsDS.CheckDataSet() Then hdfidfInstitution.Value = oUserDefaultsDS.Tables(0).Rows(0).Item("hdfidfInstitution")

        CallEmployeeDetails()

    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)

        sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.EmployeeAdminPrefix)
        'Save search fields
        oCommon.SaveSearchFields({searchUpdatePanel}, CallerPages.EmployeeAdmin, sFile)

        FillEmployeeList(True)

    End Sub

    'Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click 'Causes an Exception AK

    '    sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.EmployeeAdminPrefix)
    '    oCommon.DeleteTempFiles(sFile)
    '    oCommon.ResetForm(searchUpdatePanel)

    '    FillEmployeeList(True)

    'End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs)

        sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.EmployeeAdminPrefix)
        oCommon.DeleteTempFiles(sFile)
        oCommon.ResetForm(searchUpdatePanel)

        FillEmployeeList(True)

    End Sub

#End Region

#Region "Page Button Events"

    Private Sub rptPageSection_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptPageSection.ItemDataBound

        Dim oLnkBtn As LinkButton = e.Item.FindControl("lnkPage")

        If (e.Item.DataItem.ToString() = hdfPageIndex.Value.ToString()) Then
            oLnkBtn.BackColor = Drawing.Color.FromArgb(51, 102, 153)
            oLnkBtn.ForeColor = Drawing.Color.White
        End If

    End Sub

#End Region

    Private Sub EmployeeAdmin_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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

#Region "Modal Button"

    Protected Sub btnDeleteYes_Click(sender As Object, e As EventArgs) Handles btnDeleteYes.ServerClick


        RowDeleting()



    End Sub

    Private Sub RowDeleting()

        Dim oEmp As clsEmployee = New clsEmployee()
        If Not hdfidfEmployee.Value.IsValueNullOrEmpty() Then

            Try

                oEmp.Delete(Double.Parse(hdfidfEmployee.Value))
                FillEmployeeList(True)

            Finally

                oEmp = Nothing

            End Try

        End If



        'Try
        '    oCommon = New clsCommon()
        '    oService = oCommon.GetService()
        '    Dim oHASC As clsEmployee = New clsEmployee()
        '    Dim id As Double = Convert.ToInt64(hdfidfEmployee.Value)
        '    oHASC.Delete(id)

        '    searchForm.Visible = True
        '    campaignInformation.Visible = False
        '    btnShowSearchCriteria.Visible = True

        '    If hdfDeleteCampaignFromSearchResults.Value Then
        '        searchResults.Visible = True

        '        Dim dt As DataTable = ViewState(results)
        '        Dim dr As DataRow() = dt.Select(ActiveSurveillanceCampaignConstants.Campaign & "=" & hdfidfCampaign.Value)

        '        If (dr.Count() > 0) Then
        '            For i As Integer = 0 To dr.Count() - 1
        '                dt.Rows.Remove(dr(i))
        '            Next
        '        End If

        '        gvEmployeeList.DataSource = dt
        '        gvEmployeeList.DataBind()

        '        ViewState(results) = dt
        '    Else
        '        showClearandSearchButtons(True)
        '    End If


        '    hdfDeleteCampaignFromSearchResults.Value = False
        '    hdfCampaignIndex.Value = "NULL"

        '    lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Deletion.InnerText")
        '    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successDeleteCampaign');});", True)
        'Catch
        '    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Campaign.InnerText")
        '    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
        'End Try






    End Sub


#End Region

End Class