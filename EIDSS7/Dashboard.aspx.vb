Imports System.Reflection
Imports EIDSS.Client
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain

Public Class Dashboard
    Inherits BaseEidssPage

    Private ReadOnly DashboardAPIClient As DashBoardServiceClient
    Private ReadOnly HumanAPIClient As HumanServiceClient
    Private ReadOnly VeterinaryAPIClient As VeterinaryServiceClient

    Private userSettingsFile As String

    Private Const SESSION_UNACCESSIONED_SAMPLES_LIST As String = "gvUnaccessionedSamples_List"
    Private Const UNACCESSIONED_SAMPLES_PAGINATION_SET_NUMBER As String = "gvUnaccessionedSamples_PaginationSet"
    Private Const UNACCESSIONED_SAMPLES_SORT_DIRECTION As String = "gvUnaccessionedSamples_SortDirection"
    Private Const UNACCESSIONED_SAMPLES_SORT_EXPRESSION As String = "gvUnaccessionedSamples_SortExpression"

    Private Const SESSION_USERS_LIST As String = "gvUsers_List"
    Private Const USERS_PAGINATION_SET_NUMBER As String = "gvUsers_PaginationSet"
    Private Const USERS_SORT_DIRECTION As String = "gvUsers_SortDirection"
    Private Const USERS_SORT_EXPRESSION As String = "gvUsers_SortExpression"

    Private Const SESSION_NOTIFICATIONS_LIST As String = "gvNotifications_List"
    Private Const NOTIFICATIONS_PAGINATION_SET_NUMBER As String = "gvNotifications_PaginationSet"
    Private Const NOTIFICATIONS_SORT_DIRECTION As String = "gvNotifications_SortDirection"
    Private Const NOTIFICATIONS_SORT_EXPRESSION As String = "gvNotifications_SortExpression"

    Private Const SESSION_MYNOTIFICATIONS_LIST As String = "gvMyNotifications_List"
    Private Const MYNOTIFICATIONS_PAGINATION_SET_NUMBER As String = "gvMyNotifications_PaginationSet"
    Private Const MYNOTIFICATIONS_SORT_DIRECTION As String = "gvMyNotifications_SortDirection"
    Private Const MYNOTIFICATIONS_SORT_EXPRESSION As String = "gvMyNotifications_SortExpression"

    Private Const SESSION_INVESTIGATIONS_LIST As String = "gvInvestigations_List"
    Private Const INVESTIGATIONS_PAGINATION_SET_NUMBER As String = "gvInvestigations_PaginationSet"
    Private Const INVESTIGATIONS_SORT_DIRECTION As String = "gvInvestigations_SortDirection"
    Private Const INVESTIGATIONS_SORT_EXPRESSION As String = "gvInvestigations_SortExpression"

    Private Const SESSION_MYINVESTIGATIONS_LIST As String = "gvMyInvestigations_List"
    Private Const MYINVESTIGATIONS_PAGINATION_SET_NUMBER As String = "gvMyInvestigations_PaginationSet"
    Private Const MYINVESTIGATIONS_SORT_DIRECTION As String = "gvMyInvestigations_SortDirection"
    Private Const MYINVESTIGATIONS_SORT_EXPRESSION As String = "gvMyInvestigations_SortExpression"

    Private Const SESSION_MYCOLLECTIONS_LIST As String = "gvMyCollections_List"
    Private Const MYCOLLECTIONS_PAGINATION_SET_NUMBER As String = "gvMyCollections_PaginationSet"
    Private Const MYCOLLECTIONS_SORT_DIRECTION As String = "gvMyCollections_SortDirection"
    Private Const MYCOLLECTIONS_SORT_EXPRESSION As String = "gvMyCollections_SortExpression"

    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private ReadOnly language As String

    Private Shared Log = log4net.LogManager.GetLogger(GetType(Dashboard))

    Sub New()
        DashboardAPIClient = New DashBoardServiceClient()
        HumanAPIClient = New HumanServiceClient()
        VeterinaryAPIClient = New VeterinaryServiceClient()
        language = GetCurrentLanguage()
    End Sub

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                LoadCssFiles()
                LoadScript()

                AddHandler ucPageHeader.LanguageCultureChanged, AddressOf LanguageChanged

                ViewState(CALLER) = CallerPages.Dashboard
                ViewState(CALLER_KEY) = Nothing

                GetUserProfile()

                FillDashboardLinks()
                'FillDashboardNavi()

                If EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.Administrator) Then
                    SetupUsers()
                ElseIf EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.LabTechnician_Human) Or EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.LabTechnician_Vet) Then
                    SetupUnaccessionedSamples()
                ElseIf EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.ChiefofLaboratory_Human) Or EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.ChiefofLaboratory_Vet) Then
                    FillMyApprovalsList()
                ElseIf EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.ChiefEpizootologist) Then
                    SetupInvestigations()
                ElseIf EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.Epizootologist) Then
                    SetupMyInvestigations()
                ElseIf EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.ChiefEpidemiologist) Or EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.Epidemiologist) Then
                    SetupNotifications()
                ElseIf EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.Notifiers) Then
                    SetupMyNotifications()
                ElseIf EIDSSAuthenticatedUser.IsInRole(Enumerations.EIDSSRoleEnum.Entomologist) Then
                    SetupMyCollections()
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            'Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try

    End Sub

    Private Sub LoadCssFiles()

        Dim link As HtmlLink

        link = New HtmlLink()
        link.Href = "~/Includes/CSS/bootstrap.css"
        link.Attributes.Add("rel", "stylesheet")
        link.Attributes.Add("type", "text/css")
        Page.Header.Controls.Add(link)

        link = New HtmlLink()
        link.Href = "~/Includes/CSS/EIDSS7Styles-1.0.0.css"
        link.Attributes.Add("rel", "stylesheet")
        link.Attributes.Add("type", "text/css")
        Page.Header.Controls.Add(link)

    End Sub

    Private Sub LoadScript()

        Dim scriptName As New ArrayList
        Dim scriptUrl As New ArrayList

        'JQuery
        scriptName.Add("_JQ")
        scriptUrl.Add("~/Includes/Scripts/jquery-3.2.1.js")

        'Bootstrap
        scriptName.Add("_BS")
        scriptUrl.Add("~/Includes/Scripts/bootstrap.js")

        'EIDSS Javascripts
        scriptName.Add("_ES")
        scriptUrl.Add("~/Includes/Scripts/eidss7scripts-1.0.0.js")

        Dim scriptType As Type = Me.GetType()
        Dim clientScriptManager As ClientScriptManager = Page.ClientScript

        Dim i As Integer
        For i = 0 To (scriptName.Count - 1)
            If (Not clientScriptManager.IsClientScriptIncludeRegistered(scriptType, scriptName(i))) Then
                clientScriptManager.RegisterClientScriptInclude(scriptType, scriptName(i), ResolveClientUrl(scriptUrl(i)))
            End If
        Next i

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = GetViewState(True)

            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()
        If Not EIDSSAuthenticatedUser.AccessToken Is Nothing Then
            hdfUserID.Value = EIDSSAuthenticatedUser.EIDSSUserId 'System.Convert.ToInt64(Session("UserID"))
            hdfSiteID.Value = EIDSSAuthenticatedUser.SiteId 'System.Convert.ToInt64(Session("UserSite"))
            hdfPersonID.Value = EIDSSAuthenticatedUser.PersonId 'System.Convert.ToInt64(Session("Person"))
            hdfOrganizationID.Value = EIDSSAuthenticatedUser.Institution 'System.Convert.ToInt64(Session("Institution"))
        End If

    End Sub

#End Region

    Private Sub FillDashboardLinks()
        Dim vr As List(Of DasDashboardGetListModel) = DashboardAPIClient.GetDashBoardLinks(language, Convert.ToInt64(hdfPersonID.Value), "Icon").Result
        Dim dashBoardHTML As String = String.Empty
        For Each row As DasDashboardGetListModel In vr
            dashBoardHTML = dashBoardHTML & CreateDashboardLink(row)
        Next
        dashboardLinks.InnerHtml = dashBoardHTML
    End Sub

    Private Sub FillDashboardNavi()
        Dim vr As List(Of DasDashboardGetListModel) = DashboardAPIClient.GetDashBoardLinks(language, Convert.ToInt64(hdfPersonID.Value), "Navi").Result
        If vr.Count > 0 Then
            Dim dashBoardHTML As String = String.Empty
            For Each row As DasDashboardGetListModel In vr
                dashBoardHTML = dashBoardHTML & CreateDashboardNavLink(row)
            Next
            'dashboardNavi.InnerHtml = dashBoardHTML
        Else
            'dashboardNavi.Visible = False
        End If
    End Sub

    Private Function CreateDashboardLink(ByVal row As DasDashboardGetListModel) As String
        CreateDashboardLink = "<div class=""col-md-6 col-sm-12 col-xs-12"">" & vbNewLine
        CreateDashboardLink = CreateDashboardLink & "<div class=""dashboard-group"">" & vbNewLine
        CreateDashboardLink = CreateDashboardLink & vbTab & vbTab & "<h3>" & vbNewLine
        CreateDashboardLink = CreateDashboardLink & vbTab & vbTab & vbTab & "<a href=""" & row.PageLink & """>" & row.strName.ToUpper() & "</a>" & vbNewLine
        CreateDashboardLink = CreateDashboardLink & vbTab & vbTab & "</h3>" & vbNewLine
        CreateDashboardLink = CreateDashboardLink & vbTab & "</div>" & vbNewLine
        CreateDashboardLink = CreateDashboardLink & "</div>" & vbNewLine
    End Function

    Private Function CreateDashboardNavLink(ByVal row As DasDashboardGetListModel) As String
        CreateDashboardNavLink = "<div class=""sidebox-group"">" & vbNewLine
        CreateDashboardNavLink = CreateDashboardNavLink & vbTab & vbTab & "<h4>" & vbNewLine
        CreateDashboardNavLink = CreateDashboardNavLink & vbTab & vbTab & vbTab & "<a href=""" & row.PageLink & """>" & row.strName.ToUpper() & "</a>" & vbNewLine
        CreateDashboardNavLink = CreateDashboardNavLink & vbTab & vbTab & "</h4>" & vbNewLine
        CreateDashboardNavLink = CreateDashboardNavLink & vbTab & "</div>" & vbNewLine
    End Function

#Region "Users Methods"

    Private Sub SetupUsers()
        usersDiv.Visible = True
        Dim usersCount As DasUsersGetCountModel = DashboardAPIClient.GetDashboardUsersCount().Result(0)
        hdfUsersCount.Value = usersCount.RecordCount
        lblUsersNumberOfRecords.Text = usersCount.RecordCount
        FillUsersList(pageIndex:=1, paginationSetNumber:=1)
        gvUsers.PageIndex = 0
        lblUsersPageNumber.Text = 1
        BindUsersGridView()
    End Sub

    Private Sub FillUsersList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Session(SESSION_USERS_LIST) = DashboardAPIClient.GetDashboardUsersList(language, paginationSetNumber).Result
            FillUsersPager(hdfUsersCount.Value, pageIndex)
            ViewState(USERS_PAGINATION_SET_NUMBER) = paginationSetNumber
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
    Protected Sub gvUsers_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvUsers.Sorting

        Try

            ViewState(USERS_SORT_DIRECTION) = IIf(ViewState(USERS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(USERS_SORT_EXPRESSION) = e.SortExpression

            BindUsersGridView()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try

    End Sub

    Private Sub BindUsersGridView()

        Try
            Dim users = CType(Session(SESSION_USERS_LIST), List(Of DasUsersGetListModel))

            If users Is Nothing Then
                users = New List(Of DasUsersGetListModel)()
                Session(SESSION_USERS_LIST) = users
            End If

            If (Not ViewState(USERS_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(USERS_SORT_DIRECTION) = SortConstants.Ascending Then
                    users = users.OrderBy(Function(x) x.GetType().GetProperty(ViewState(USERS_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    users = users.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(USERS_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            Else
                users = users.OrderBy(Function(x) x.strFamilyName).ToList()
            End If

            gvUsers.DataSource = users
            gvUsers.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillUsersPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divUsersPager.Visible = True

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
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptUsersPager.DataSource = pages
            rptUsersPager.DataBind()
        Else
            divUsersPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub UsersPage_Changed(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvUsers.PageSize)

            If Not ViewState(USERS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvUsers.PageIndex = gvUsers.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvUsers.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvUsers.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvUsers.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvUsers.PageIndex = gvUsers.PageSize - 1
                        Else
                            gvUsers.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillUsersList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvUsers.PageIndex = gvUsers.PageSize - 1
                Else
                    gvUsers.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindUsersGridView()
                FillUsersPager(hdfUsersCount.Value, pageIndex)
            End If

            lblUsersPageNumber.Text = pageIndex.ToString()
            upDashboard.Update()
        Catch ex As Exception
            Log.error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Paging.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblUsersPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer
            paginationSetNumber = Math.Ceiling(pageIndex / gvUsers.PageSize)

            If Not ViewState(USERS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvUsers.PageIndex = gvUsers.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvUsers.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvUsers.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvUsers.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvUsers.PageIndex = gvUsers.PageSize - 1
                        Else
                            gvUsers.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillUsersList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvUsers.PageIndex = gvUsers.PageSize - 1
                Else
                    gvUsers.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindUsersGridView()
                FillUsersPager(lblUsersNumberOfRecords.Text, pageIndex)
            End If
        Catch ex As Exception
            Log.error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Paging.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub gvUsers_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvUsers.RowCommand
        If e.CommandName = "edit" Then
            Dim gv As GridView = DirectCast(sender, GridView)
            Dim empId As Int64 = gv.DataKeys(e.CommandArgument)(0)
            ViewState(CALLER_KEY) = empId
            ViewState(CALLER) = ApplicationActions.DashboardEditEmployee
            SaveEIDSSViewState(ViewState)
            Response.Redirect(GetURL(CallerPages.EmployeeDetailsURL), True)
            Context.ApplicationInstance.CompleteRequest()
        End If
    End Sub

#End Region

#Region "Unaccessioned Samples Methods"

    Private Sub SetupUnaccessionedSamples()
        unaccessionedSamplesDiv.Visible = True
        Dim samplesCount As DasUnaccessionedSampleGetCountModel = DashboardAPIClient.GetDashboardUnaccessionedSamplesListCountAsync(language, hdfOrganizationID.Value, hdfSiteID.Value).Result(0)
        hdfUnaccessionedSamplesCount.Value = samplesCount.RecordCount
        lblUnaccessionedSamplesNumberofRecords.Text = samplesCount.RecordCount
        FillUnaccessionedSamplesList(pageIndex:=1, paginationSetNumber:=1)
        gvUnaccessionedSamples.PageIndex = 0
        lblUnaccessionedSamplesPageNumber.Text = 1
        BindUnaccessionedSamplesGridView()
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillUnaccessionedSamplesList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Session(SESSION_UNACCESSIONED_SAMPLES_LIST) = DashboardAPIClient.GetDashboardUnaccessionedSamplesListAsync(language, hdfOrganizationID.Value, hdfSiteID.Value, 1).Result
            FillUnaccessionedSamplesPager(hdfUnaccessionedSamplesCount.Value, pageIndex)
            ViewState(UNACCESSIONED_SAMPLES_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            'Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub gvUnaccessionedSamples_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvUnaccessionedSamples.Sorting

        Try
            ViewState(UNACCESSIONED_SAMPLES_SORT_DIRECTION) = IIf(ViewState(UNACCESSIONED_SAMPLES_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(UNACCESSIONED_SAMPLES_SORT_EXPRESSION) = e.SortExpression

            BindUnaccessionedSamplesGridView()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)

            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindUnaccessionedSamplesGridView()

        Try
            Dim samples = CType(Session(SESSION_UNACCESSIONED_SAMPLES_LIST), List(Of DasUnaccessionedsamplesGetListModel))

            If samples Is Nothing Then
                samples = New List(Of DasUnaccessionedsamplesGetListModel)()
                Session(SESSION_UNACCESSIONED_SAMPLES_LIST) = samples
            End If

            If (Not ViewState(UNACCESSIONED_SAMPLES_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(UNACCESSIONED_SAMPLES_SORT_DIRECTION) = SortConstants.Ascending Then
                    samples = samples.OrderBy(Function(x) x.GetType().GetProperty(ViewState(UNACCESSIONED_SAMPLES_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    samples = samples.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(UNACCESSIONED_SAMPLES_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            Else
                samples = samples.OrderBy(Function(x) x.EIDSSReportSessionID).ToList()
            End If

            gvUnaccessionedSamples.DataSource = samples
            gvUnaccessionedSamples.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            'Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillUnaccessionedSamplesPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divUnaccessionedSamplesPager.Visible = True

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
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptUnaccessionedSamplesPager.DataSource = pages
            rptUnaccessionedSamplesPager.DataBind()
        Else
            divUnaccessionedSamplesPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub UnaccessionedSamplesPage_Changed(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvUnaccessionedSamples.PageSize)

            If Not ViewState(UNACCESSIONED_SAMPLES_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvUnaccessionedSamples.PageIndex = gvUnaccessionedSamples.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvUnaccessionedSamples.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvUnaccessionedSamples.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvUnaccessionedSamples.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvUnaccessionedSamples.PageIndex = gvUnaccessionedSamples.PageSize - 1
                        Else
                            gvUnaccessionedSamples.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillUnaccessionedSamplesList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvUnaccessionedSamples.PageIndex = gvUnaccessionedSamples.PageSize - 1
                Else
                    gvUnaccessionedSamples.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindUnaccessionedSamplesGridView()
                FillUnaccessionedSamplesPager(hdfUnaccessionedSamplesCount.Value, pageIndex)
            End If

            lblUnaccessionedSamplesPageNumber.Text = pageIndex.ToString()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Paging.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "My Approvals Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillMyApprovalsList()
        Try
            approvalsDiv.Visible = True
            gvMyApprovals.DataSource = DashboardAPIClient.GetDashboardMyApprovalsListAsync(language, hdfSiteID.Value).Result
            gvMyApprovals.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Notifications Methods"

    Private Sub SetupNotifications()
        notificationsDiv.Visible = True
        Dim notificationsCount As DasNotificationsGetcountModel = DashboardAPIClient.GetDasNotificationsCount().Result(0)
        hdfNotificationsCount.Value = notificationsCount.RecordCount
        lblNotificationsNumberofRecords.Text = notificationsCount.RecordCount
        FillNotificationsList(pageIndex:=1, paginationSetNumber:=1)
        gvNotifications.PageIndex = 0
        lblNotificationsPageNumber.Text = 1
        BindNotificationsGridView()
    End Sub

    Private Sub FillNotificationsList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Session(SESSION_NOTIFICATIONS_LIST) = DashboardAPIClient.GetDashboardNotificationsList(language, paginationSetNumber).Result
            FillNotificationsPager(hdfNotificationsCount.Value, pageIndex)
            ViewState(NOTIFICATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvNotifications_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvNotifications.Sorting
        Try
            ViewState(NOTIFICATIONS_SORT_DIRECTION) = IIf(ViewState(NOTIFICATIONS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(NOTIFICATIONS_SORT_EXPRESSION) = e.SortExpression

            BindNotificationsGridView()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub BindNotificationsGridView()

        Try
            Dim notifications = CType(Session(SESSION_NOTIFICATIONS_LIST), List(Of DasNotificationsGetListModel))

            If notifications Is Nothing Then
                notifications = New List(Of DasNotificationsGetListModel)()
                Session(SESSION_NOTIFICATIONS_LIST) = notifications
            End If

            If (Not ViewState(NOTIFICATIONS_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(NOTIFICATIONS_SORT_DIRECTION) = SortConstants.Ascending Then
                    notifications = notifications.OrderBy(Function(x) x.GetType().GetProperty(ViewState(NOTIFICATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    notifications = notifications.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(NOTIFICATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            Else
                notifications = notifications.OrderBy(Function(x) x.datEnteredDate).ToList()
            End If

            gvNotifications.DataSource = notifications
            gvNotifications.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillNotificationsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divNotificationsPager.Visible = True

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
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptNotificationsPager.DataSource = pages
            rptNotificationsPager.DataBind()
        Else
            divNotificationsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub NotificationsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvUsers.PageSize)

            If Not ViewState(NOTIFICATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvNotifications.PageIndex = gvNotifications.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvNotifications.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvNotifications.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvNotifications.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvNotifications.PageIndex = gvNotifications.PageSize - 1
                        Else
                            gvNotifications.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillNotificationsList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvNotifications.PageIndex = gvNotifications.PageSize - 1
                Else
                    gvNotifications.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindNotificationsGridView()
                FillNotificationsPager(hdfNotificationsCount.Value, pageIndex)
            End If

            lblNotificationsPageNumber.Text = pageIndex.ToString()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Paging.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub notifications_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvNotifications.RowCommand, gvMyNotifications.RowCommand
        Try
            If e.CommandName = "view" Then
                Dim gv As GridView = DirectCast(sender, GridView)
                Dim hcId As Int64 = gv.DataKeys(e.CommandArgument)(0)
                fillViewNotification(hcId)
            ElseIf e.CommandName = "add" Then
                ViewState(CALLER) = ApplicationActions.PersonAddHumanDiseaseReport
                ViewState(CALLER_KEY) = 0
                SaveEIDSSViewState(ViewState)
                Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), True)
                Context.ApplicationInstance.CompleteRequest()
            End If
        Catch ex As Exception
            Log.error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Data.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "My Notifications Methods"

    Private Sub SetupMyNotifications()
        Dim myNotificationsCount As DasMynotificationsGetcountModel = DashboardAPIClient.GetDasMynotificationsCount(Convert.ToInt64(hdfPersonID.Value)).Result(0)
        hdfMyNotificationsCount.Value = myNotificationsCount.RecordCount
        lblMyNotificationsNumberofRecords.Text = myNotificationsCount.RecordCount
        FillMyNotificationsList(pageIndex:=1, paginationSetNumber:=1)
        gvMyNotifications.PageIndex = 0
        lblMyNotificationsPageNumber.Text = 1
        BindMyNotificationsGridView()
    End Sub

    Private Sub FillMyNotificationsList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Session(SESSION_MYNOTIFICATIONS_LIST) = DashboardAPIClient.GetDashboardMyNotificationsList(language, Convert.ToInt64(hdfPersonID.Value), paginationSetNumber).Result
            FillMyNotificationsPager(hdfMyNotificationsCount.Value, pageIndex)
            ViewState(MYNOTIFICATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvMyNotifications_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvMyNotifications.Sorting
        Try
            ViewState(MYNOTIFICATIONS_SORT_DIRECTION) = IIf(ViewState(MYNOTIFICATIONS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(MYNOTIFICATIONS_SORT_EXPRESSION) = e.SortExpression

            BindMyNotificationsGridView()

            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub BindMyNotificationsGridView()

        Try
            Dim myNotifications = CType(Session(SESSION_MYNOTIFICATIONS_LIST), List(Of DasMynotificationsGetListModel))

            If myNotifications Is Nothing Then
                myNotifications = New List(Of DasMynotificationsGetListModel)()
                Session(SESSION_MYNOTIFICATIONS_LIST) = myNotifications
            End If

            If (Not ViewState(MYNOTIFICATIONS_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(MYNOTIFICATIONS_SORT_DIRECTION) = SortConstants.Ascending Then
                    myNotifications = myNotifications.OrderBy(Function(x) x.GetType().GetProperty(ViewState(MYNOTIFICATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    myNotifications = myNotifications.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(NOTIFICATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            Else
                myNotifications = myNotifications.OrderBy(Function(x) x.datEnteredDate).ToList()
            End If

            gvMyNotifications.DataSource = myNotifications
            gvMyNotifications.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillMyNotificationsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divMyNotificationsPager.Visible = True

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
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptMyNotificationsPager.DataSource = pages
            rptMyNotificationsPager.DataBind()
        Else
            divMyNotificationsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub MyNotificationsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvUsers.PageSize)

        If Not ViewState(MYNOTIFICATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvNotifications.PageIndex = gvNotifications.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvNotifications.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvNotifications.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvNotifications.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvMyNotifications.PageIndex = gvMyNotifications.PageSize - 1
                    Else
                        gvMyNotifications.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillMyNotificationsList(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvMyNotifications.PageIndex = gvMyNotifications.PageSize - 1
            Else
                gvMyNotifications.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindMyNotificationsGridView()
            FillMyNotificationsPager(hdfMyNotificationsCount.Value, pageIndex)
        End If

        lblNotificationsPageNumber.Text = pageIndex.ToString()

        upDashboard.Update()

    End Sub

    'Protected Sub gvMyNotifications_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvMyNotifications.RowCommand
    '    If e.CommandName = "view" Then
    '        Dim hcId As Int64 = gvMyNotifications.DataKeys(e.CommandArgument)(0)
    '        fillViewNotification(hcId)
    '    End If
    'End Sub

#End Region

#Region "Investigations Methods"

    Private Sub SetupInvestigations()
        investigationsDiv.Visible = True
        Dim investigationsCount As DasInvestigationsGetcountModel = DashboardAPIClient.GetDashboardInvestigationsCount().Result(0)
        hdfInvestigationsCount.Value = investigationsCount.RecordCount
        lblInvestigationsNumberofRecords.Text = investigationsCount.RecordCount
        FillInvestigationsList(pageIndex:=1, paginationSetNumber:=1)
        gvInvestigations.PageIndex = 0
        lblInvestigationsPageNumber.Text = 1
        BindInvestigationsGridView()
    End Sub

    Private Sub FillInvestigationsList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Session(SESSION_INVESTIGATIONS_LIST) = DashboardAPIClient.GetDashboardInvestigationsList(language, paginationSetNumber).Result
            FillInvestigationsPager(hdfInvestigationsCount.Value, pageIndex)
            ViewState(INVESTIGATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvInvestigations_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvInvestigations.Sorting
        Try
            ViewState(INVESTIGATIONS_SORT_DIRECTION) = IIf(ViewState(INVESTIGATIONS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(INVESTIGATIONS_SORT_EXPRESSION) = e.SortExpression

            BindInvestigationsGridView()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub BindInvestigationsGridView()
        Try
            Dim investigations = CType(Session(SESSION_INVESTIGATIONS_LIST), List(Of DasInvestigationsGetListModel))

            If investigations Is Nothing Then
                investigations = New List(Of DasInvestigationsGetListModel)()
                Session(SESSION_INVESTIGATIONS_LIST) = investigations
            End If

            If (Not ViewState(INVESTIGATIONS_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(INVESTIGATIONS_SORT_DIRECTION) = SortConstants.Ascending Then
                    investigations = investigations.OrderBy(Function(x) x.GetType().GetProperty(ViewState(INVESTIGATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    investigations = investigations.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(INVESTIGATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            Else
                investigations = investigations.OrderBy(Function(x) x.datEnteredDate).ToList()
            End If

            gvInvestigations.DataSource = investigations
            gvInvestigations.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillInvestigationsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divInvestigationsPager.Visible = True

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
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptInvestigationsPager.DataSource = pages
            rptInvestigationsPager.DataBind()
        Else
            divInvestigationsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub InvestigationsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvUsers.PageSize)

        If Not ViewState(INVESTIGATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvInvestigations.PageIndex = gvInvestigations.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvInvestigations.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvInvestigations.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvInvestigations.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvInvestigations.PageIndex = gvInvestigations.PageSize - 1
                    Else
                        gvInvestigations.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillInvestigationsList(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvInvestigations.PageIndex = gvInvestigations.PageSize - 1
            Else
                gvInvestigations.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindInvestigationsGridView()
            FillInvestigationsPager(hdfInvestigationsCount.Value, pageIndex)
        End If

        lblInvestigationsPageNumber.Text = pageIndex.ToString()
        upDashboard.Update()
    End Sub

    Protected Sub investigations_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvInvestigations.RowCommand, gvMyInvestigations.RowCommand
        If e.CommandName = "view" Then
            Dim gv As GridView = DirectCast(sender, GridView)
            Dim vcId As Int64 = gv.DataKeys(e.CommandArgument)(0)
            fillViewInvestigation(vcId)
        ElseIf e.CommandName = "edit" Then
            Dim gv As GridView = DirectCast(sender, GridView)
            Dim cId As Int64 = gv.DataKeys(e.CommandArgument)(0)
            ViewState(CALLER_KEY) = cId
            ViewState(CALLER) = ApplicationActions.FarmAddLivestockVeterinaryDiseaseReport
            SaveEIDSSViewState(ViewState)
            Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
        End If
    End Sub

#End Region

#Region "My Investigations Methods"

    Private Sub SetupMyInvestigations()
        myinvestigationsDiv.Visible = True
        Dim myInvestigationsCount As DasMyinvestigationsGetcountModel = DashboardAPIClient.GetDashboardMyInvestigationCount(Convert.ToInt64(hdfPersonID.Value)).Result(0)
        hdfMyInvestigationsCount.Value = myInvestigationsCount.RecordCount
        lblMyInvestigationsNumberofRecords.Text = myInvestigationsCount.RecordCount
        FillMyInvestigationsList(pageIndex:=1, paginationSetNumber:=1)
        gvMyInvestigations.PageIndex = 0
        lblMyInvestigationsPageNumber.Text = 1
        BindMyInvestigationsGridView()
    End Sub

    Private Sub FillMyInvestigationsList(pageIndex As Integer, paginationSetNumber As Integer)
        Try
            Session(SESSION_MYINVESTIGATIONS_LIST) = DashboardAPIClient.GetDashboardMyInvestigationsList(language, Convert.ToInt64(hdfPersonID.Value), paginationSetNumber).Result
            FillMyInvestigationsPager(hdfMyInvestigationsCount.Value, pageIndex)
            ViewState(MYINVESTIGATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            'Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub gvMyInvestigations_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvMyInvestigations.Sorting
        Try
            ViewState(MYINVESTIGATIONS_SORT_DIRECTION) = IIf(ViewState(MYINVESTIGATIONS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(MYINVESTIGATIONS_SORT_EXPRESSION) = e.SortExpression

            BindMyInvestigationsGridView()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            'Throw
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub BindMyInvestigationsGridView()
        Try
            Dim myInvestigations = CType(Session(SESSION_MYINVESTIGATIONS_LIST), List(Of DasMyinvestigationsGetListModel))

            If myInvestigations Is Nothing Then
                myInvestigations = New List(Of DasMyinvestigationsGetListModel)()
                Session(SESSION_MYINVESTIGATIONS_LIST) = myInvestigations
            End If

            If (Not ViewState(MYINVESTIGATIONS_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(MYINVESTIGATIONS_SORT_DIRECTION) = SortConstants.Ascending Then
                    myInvestigations = myInvestigations.OrderBy(Function(x) x.GetType().GetProperty(ViewState(MYINVESTIGATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    myInvestigations = myInvestigations.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(MYINVESTIGATIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            Else
                myInvestigations = myInvestigations.OrderBy(Function(x) x.datEnteredDate).ToList()
            End If

            gvMyInvestigations.DataSource = myInvestigations
            gvMyInvestigations.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillMyInvestigationsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divMyInvestigationsPager.Visible = True

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
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptMyInvestigationsPager.DataSource = pages
            rptMyInvestigationsPager.DataBind()
        Else
            divMyInvestigationsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub MyInvestigationsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvMyInvestigations.PageSize)

            If Not ViewState(MYINVESTIGATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvInvestigations.PageIndex = gvInvestigations.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvInvestigations.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvInvestigations.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvInvestigations.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvMyInvestigations.PageIndex = gvInvestigations.PageSize - 1
                        Else
                            gvMyInvestigations.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillMyInvestigationsList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvMyInvestigations.PageIndex = gvInvestigations.PageSize - 1
                Else
                    gvMyInvestigations.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindMyInvestigationsGridView()
                FillMyInvestigationsPager(hdfMyInvestigationsCount.Value, pageIndex)
            End If

            lblMyInvestigationsPageNumber.Text = pageIndex.ToString()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Paging.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "My Collections Methods"

    Private Sub SetupMyCollections()
        myCollectionsDiv.Visible = True
        Dim myCollectionsCount As DasMycollectionsGetcountModel = DashboardAPIClient.GetDashboardCollectionsCount(language, Convert.ToInt64(hdfPersonID.Value)).Result(0)
        hdfMyCollectionsCount.Value = myCollectionsCount.RecordCount
        FillMyCollectionsList(pageIndex:=1, paginationSetNumber:=1)
        gvMyCollections.PageIndex = 0
        lblMyCollectionsPager.Text = 1
        BindMyCollectionsGridView()
    End Sub

    Private Sub FillMyCollectionsList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Session(SESSION_MYCOLLECTIONS_LIST) = DashboardAPIClient.GetDashboardCollectionsList(language, Convert.ToInt64(hdfPersonID.Value), paginationSetNumber).Result
            FillMyCollectionsPager(hdfMyCollectionsCount.Value, pageIndex)
            ViewState(MYCOLLECTIONS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            'Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try

    End Sub

    Protected Sub gvMyCollections_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvMyCollections.Sorting
        Try
            ViewState(MYCOLLECTIONS_SORT_DIRECTION) = IIf(ViewState(MYCOLLECTIONS_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(MYCOLLECTIONS_SORT_EXPRESSION) = e.SortExpression

            BindMyCollectionsGridView()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub BindMyCollectionsGridView()
        Try
            Dim myCollections = CType(Session(SESSION_MYCOLLECTIONS_LIST), List(Of DasMycollectionsGetListModel))

            If myCollections Is Nothing Then
                myCollections = New List(Of DasMycollectionsGetListModel)()
                Session(SESSION_MYCOLLECTIONS_LIST) = myCollections
            End If

            If (Not ViewState(MYCOLLECTIONS_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(MYCOLLECTIONS_SORT_DIRECTION) = SortConstants.Ascending Then
                    myCollections = myCollections.OrderBy(Function(x) x.GetType().GetProperty(ViewState(MYCOLLECTIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    myCollections = myCollections.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(MYCOLLECTIONS_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            Else
                myCollections = myCollections.OrderBy(Function(x) x.datEnteredDate).ToList()
            End If

            gvMyCollections.DataSource = myCollections
            gvMyCollections.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            'Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillMyCollectionsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divMyInvestigationsPager.Visible = True

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
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptMyInvestigationsPager.DataSource = pages
            rptMyInvestigationsPager.DataBind()
        Else
            divMyInvestigationsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub MyCollectionsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvMyInvestigations.PageSize)

            If Not ViewState(MYINVESTIGATIONS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvInvestigations.PageIndex = gvInvestigations.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvInvestigations.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvInvestigations.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvInvestigations.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvMyInvestigations.PageIndex = gvInvestigations.PageSize - 1
                        Else
                            gvMyInvestigations.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillMyCollectionsList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvMyCollections.PageIndex = gvMyCollections.PageSize - 1
                Else
                    gvMyCollections.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindMyCollectionsGridView()
                FillMyCollectionsPager(hdfMyCollectionsCount.Value, pageIndex)
            End If

            lblMyCollectionsPager.Text = pageIndex.ToString()
            upDashboard.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Paging.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub gvMyCollections_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvMyCollections.RowCommand
        If e.CommandName = "edit" Then
            Dim gv As GridView = DirectCast(sender, GridView)
            Dim cId As Int64 = gv.DataKeys(e.CommandArgument)(0)
            ViewState(CALLER_KEY) = cId
            SaveEIDSSViewState(ViewState)
            Response.Redirect(GetURL(CallerPages.VectorSurveillanceSessionURL), True)
        End If
    End Sub

#End Region

    Private Sub fillViewNotification(ByVal id As Int64)
        Dim notifDetail As HumDiseaseGetDetailModel = HumanAPIClient.GetHumanDiseaseDetail(language, id).Result(0)
        lblstrFinalDiagnosis.Text = notifDetail.SummaryIdfsFinalDiagnosis
        lblstrFinalState.Text = notifDetail.FinalCaseStatus
        lbldatDateOfDiagnosis.Text = IIf(Not IsNothing(notifDetail.datDateOfDiagnosis), String.Format("{0:MM/dd/yyyy}", notifDetail.datDateOfDiagnosis), String.Empty)
        lbldatNotificationDate.Text = IIf(Not IsNothing(notifDetail.datNotificationDate), String.Format("{0:MM/dd/yyyy}", notifDetail.datNotificationDate), String.Empty)
        lblstrNotificationSentby.Text = notifDetail.strNotificationSentby
        lblstrNotificationReceivedby.Text = notifDetail.strNotificationReceivedby
        lblstrHospitalizationStatus.Text = notifDetail.HospitalizationStatus
        lblstrHospital.Text = notifDetail.strHospitalizationPlace
        lblstrCurrentLocation.Text = notifDetail.strCurrentLocation

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('humanDiseaseNotification');});", True)
    End Sub

    Protected Sub btnNotificationsOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnNotificationsOK.ServerClick

        lblstrFinalDiagnosis.Text = String.Empty
        lblstrFinalState.Text = String.Empty
        lbldatDateOfDiagnosis.Text = String.Empty
        lbldatNotificationDate.Text = String.Empty
        lblstrNotificationSentby.Text = String.Empty
        lblstrNotificationReceivedby.Text = String.Empty
        lblstrHospitalizationStatus.Text = String.Empty
        lblstrHospital.Text = String.Empty
        lblstrCurrentLocation.Text = String.Empty
    End Sub

    Private Sub fillViewInvestigation(ByVal id As Int64)
        Dim investiDetail As VetDiseaseReportGetDetailModel = VeterinaryAPIClient.GetVeterinaryDiseaseReportDetailAsync(language, id).Result(0)

        lblReportedByOrganization.Text = investiDetail.ReportedByOrganizationName
        lblReportedByPersonID.Text = investiDetail.ReportedByPersonName
        lblReportDate.Text = IIf(Not IsNothing(investiDetail.ReportDate), String.Format("{0:MM/dd/yyyy}", investiDetail.ReportDate), String.Empty)
        lblInvestigatedByOrganizationName.Text = investiDetail.InvestigatedByOrganizationName
        lblInvestigatedByPersonName.Text = investiDetail.InvestigatedByPersonName
        lblInvestigationDate.Text = IIf(Not IsNothing(investiDetail.InvestigationDate), String.Format("{0:MM/dd/yyyy}", investiDetail.InvestigationDate), String.Empty)
        lblSiteName.Text = investiDetail.SiteName
        lblEnteredByPersonName.Text = investiDetail.EnteredByPersonName
        lblEnteredDate.Text = IIf(Not IsNothing(investiDetail.EnteredDate), String.Format("{0:MM/dd/yyyy}", investiDetail.EnteredDate), String.Empty)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('veterinaryDiseaseNotification');});", True)
    End Sub

    Protected Sub btnInvestigationsOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnInvestigationsOK.ServerClick
        lblReportedByOrganization.Text = String.Empty
        lblReportedByPersonID.Text = String.Empty
        lblReportDate.Text = String.Empty
        lblInvestigatedByOrganizationName.Text = String.Empty
        lblInvestigatedByPersonName.Text = String.Empty
        lblInvestigationDate.Text = String.Empty
        lblSiteName.Text = String.Empty
        lblEnteredByPersonName.Text = String.Empty
        lblEnteredDate.Text = String.Empty
    End Sub

End Class