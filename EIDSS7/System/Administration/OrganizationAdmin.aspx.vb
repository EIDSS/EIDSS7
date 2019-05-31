Imports System.IO
Imports System.Xml.Serialization
Imports EIDSS.EIDSS

Public Class OrganizationAdmin
    Inherits BaseEidssPage

    Private sFile As String
    Dim oEIDSSDS As DataSet = Nothing

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private oCommon As clsCommon = New clsCommon()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack() Then
            ExtractViewStateSession()

            'Stores the data set
            ViewState(CallerPages.OrganizationAdmin) = Nothing

            'Assign defaults from current user data
            Dim sUserSettingsFile As String = oCommon.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
            oEIDSSDS = oCommon.ReadEIDSSXML(sUserSettingsFile)
            If oEIDSSDS.CheckDataSet() Then
                hdfidfUserID.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfUserID") & ""
            End If

            BaseReferenceLookUp(ddlSpecialization, BaseReferenceConstants.AccessoryList, 0, True)

            'Restore search filters
            sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.OrganizationAdminPrefix)
            oCommon.GetSearchFields({searchUpdatePanel}, sFile)

            'List data
            FillOrganizationList(True)

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

    Private Sub FillOrganizationList(Optional bRefresh As Boolean = False)

        Dim oOrg As clsOrganization = New clsOrganization()
        Dim oDS As DataSet

        Try
            If (ViewState(CallerPages.OrganizationAdmin) Is Nothing) OrElse bRefresh Then

                Dim aSP As String()
                Dim formValues As String = ""

                aSP = oCommon.GetSPList(EIDSSModules.Organization)
                formValues = oCommon.Gather(searchUpdatePanel, aSP(SPType.SPGetList).ToString(), 3, True)

                oDS = oOrg.ListAll({formValues})
            Else
                oDS = ViewState(CallerPages.OrganizationAdmin)
            End If

            oDS.CheckDataSet()

            ViewState(CallerPages.OrganizationAdmin) = oDS

            With gvOrganizationList
                .DataSource = oDS.Tables(0)
                .DataBind()
                .SelectedIndex = -1
            End With

            If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationOrganizationSearch Then
                gvOrganizationList.Columns(0).Visible = True
            End If

            If ViewState(CALLER) = CallerPages.HumanDiseaseReport Then
                gvOrganizationList.Columns(0).Visible = True
            End If

        Catch ex As Exception

            Throw

        Finally

            'clean
            oOrg = Nothing
            oDS = Nothing

        End Try

    End Sub

    Private Sub CallOrganizationDetails()

        oCommon.SaveSearchFields({divHiddenFieldsSection}, CallerPages.OrganizationAdmin, "")
        Response.Redirect(GetURL(CallerPages.OrganizationDetailsURL), True)

    End Sub

    Private Function GetSortDirection(ByVal column As String) As String

        ' By default, set the sort direction to ascending.
        Dim sortDirection = "ASC"

        ' Retrieve the last column that was sorted.
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then
            ' Check if the same column is being sorted.
            ' Otherwise, the default value can be returned.
            If sortExpression = column Then
                Dim lastDirection = TryCast(ViewState("SortDirection"), String)
                If lastDirection IsNot Nothing _
                  AndAlso lastDirection = "ASC" Then

                    sortDirection = "DESC"

                End If
            End If
        End If

        ' Save new values in ViewState.
        ViewState("SortDirection") = sortDirection
        ViewState("SortExpression") = column

        Return sortDirection

    End Function

#End Region

#Region "Grid Events"

    Private Sub gvOrganizationList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvOrganizationList.PageIndexChanging

        gvOrganizationList.PageIndex = e.NewPageIndex
        FillOrganizationList()

    End Sub

    Private Sub gvOrganizationList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOrganizationList.RowCommand

        If e.CommandName.ToUpper().EqualsAny("SELECT,EDIT,DELETE".Split(",")) Then

            Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvOrganizationList.Rows(idx)

            'Set the values of selected row in hidden fields
            With gvOrganizationList.DataKeys(idx)



                hdfidfOrgID.Value = .Values(OrganizationConstants.idfInstitution) & ""
                hdfidfLocation.Value = .Values(OrganizationConstants.idfLocation) & ""
                hdfidfsSite.Value = .Values(OrganizationConstants.idfsSite) & ""
                hdfidfsRegion.Value = .Values(OrganizationConstants.idfsRegion) & ""
                hdfidfsRayon.Value = .Values(OrganizationConstants.idfsRayon) & ""
                hdfintHACode.Value = .Values(OrganizationConstants.intHACode) & ""

                'Need to save missing Data - Organization Name, Abbreviation, Unique Org Id
                hdfUniqueOrgID.Value = .Values(OrganizationConstants.strOrganizationID) & ""
                hdfOrgName.Value = .Values(OrganizationConstants.OrgFullName) & ""
                hdfAbbreviation.Value = .Values(OrganizationConstants.OrgName) & ""
                hdfOfficeID.Value = .Values(OrganizationConstants.idOffice) & ""



            End With

        End If

    End Sub

    Private Sub gvOrganizationList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvOrganizationList.RowDeleting

        Dim oOrg As clsOrganization = New clsOrganization()

        If Not hdfidfOrgID.Value.IsValueNullOrEmpty() Then

            Try

                oOrg.Delete(Double.Parse(hdfidfOrgID.Value))
                FillOrganizationList(True)

            Finally

                oOrg = Nothing

            End Try

        End If

    End Sub

    Protected Sub gvOrganizationList_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvOrganizationList.RowEditing

        e.Cancel = True
        CallOrganizationDetails()

    End Sub

    Protected Sub gvOrganizationList_Sorting(sender As Object, e As GridViewSortEventArgs)

        Dim oDS As DataSet
        oDS = ViewState(CallerPages.OrganizationAdmin)
        oDS.CheckDataSet()

        Dim oDT As DataTable = oDS.Tables(0)

        If oDT.CheckDataTable() Then

            oDT.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression)
            gvOrganizationList.DataSource = ViewState(CallerPages.OrganizationAdmin)
            gvOrganizationList.DataBind()

        End If

    End Sub

    Protected Sub gvOrganizationList_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles gvOrganizationList.SelectedIndexChanging
        Dim oDS As DataSet = Nothing

        If ViewState(CALLER) = CallerPages.HumanActiveSurveillanceSessionDetailedInformationOrganizationSearch Then
            Dim id As Double = gvOrganizationList.DataKeys(e.NewSelectedIndex).Values.Item(OrganizationConstants.idfInstitution)
            Dim oHASS As clsOrganization = New clsOrganization()
            oDS = oHASS.SelectOne(id)
            If oDS.CheckDataSet() Then
                Session("OrganizationID") = oDS.Tables(0).Rows(0)(OrganizationConstants.idOffice)
                oCommon.SaveViewState(ViewState)
                Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl))
            End If
        ElseIf ViewState(CALLER) = CallerPages.HumanDiseaseReport Then
            Dim id As Double = gvOrganizationList.DataKeys(e.NewSelectedIndex).Values.Item(OrganizationConstants.idfInstitution)
            Dim oHASS As clsOrganization = New clsOrganization()
            oDS = oHASS.SelectOne(id)
            If oDS.CheckDataSet() Then
                Session("OrganizationID") = oDS.Tables(0).Rows(0)(OrganizationConstants.idOffice)
                ViewState(CALLER) = CallerPages.OrganizationAdmin
                'Write selected values to xml session file for page EmployeeAdmin.aspx
                Dim oComm As clsCommon = New clsCommon()
                ''Get search filters
                'Dim ctrlList As ICollection(Of Web.UI.Control) = {divHiddenFieldsOAtoHDRResponse}
                Dim ctrlList As ICollection(Of Web.UI.Control) = {divHiddenFieldsSection}
                sFile = oComm.CreateTempFile(CallerPages.OrganizationAdminPrefix)
                oComm.SaveSearchFields(ctrlList, "HiddenFieldsSection", sFile)
                'oCommon.SaveSearchFields({divHiddenFieldsSection}, CallerPages.OrganizationAdmin, "")

                oCommon.SaveViewState(ViewState)
                Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL))
            End If
        End If
    End Sub

#End Region

#Region "Control Click Events"

    Private Sub ddlSpecialization_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSpecialization.SelectedIndexChanged

        If ddlSpecialization.SelectedIndex > 0 Then hdfintHACode.Value = ddlSpecialization.SelectedValue

    End Sub

    Protected Sub btnNew_ServerClick(sender As Object, e As EventArgs) Handles btnNew.ServerClick

        hdfidfOrgID.Value = -1


        'Based on Stephen Longs EmployeeAdmin AK
        Dim sUserFile As String = oCommon.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
        Dim oUserDefaultsDS As DataSet = oCommon.ReadEIDSSXML(sUserFile)


        CallOrganizationDetails()

    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.OrganizationAdminPrefix)
        'Save search fields
        oCommon.SaveSearchFields({searchUpdatePanel}, CallerPages.OrganizationAdmin, sFile)

        FillOrganizationList(True)

    End Sub

    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        sFile = oCommon.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.OrganizationAdminPrefix)
        oCommon.DeleteTempFiles(sFile)
        oCommon.ResetForm(searchUpdatePanel)

        FillOrganizationList(True)

    End Sub

#End Region

    Private Sub OrganizationAdmin_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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

End Class