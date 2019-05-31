Imports System.IO
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports EIDSS.NG
Imports OpenEIDSS.Domain

Public Class PageHeader
    Inherits UserControl

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private Const MenuID As String = "EIDSSMenuID"
    Private Const ParentMenuID As String = "EIDSSParentMenuID"

    Dim oCommon As clsCommon = New clsCommon()

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(PageHeader))

    Protected ReadOnly Property CurrentUser As String

        Get
            Dim myUser As Security.Principal.IIdentity
            myUser = HttpContext.Current.User.Identity
            Return myUser.Name
        End Get

    End Property

    Protected ReadOnly Property Organization As String

        Get
            Dim output As String = String.Empty
            Try
                If IsNothing(Session("Organization")) = False Then
                    output = Session("Organization").ToString()
                End If
            Catch ex As HttpException
                'Do nothing for now
            Catch ex As Exception
                'Do nothing for now
            End Try

            Return output
        End Get

    End Property

    Friend Sub ChangeLanguageCultureEvent(sender As Object, e As EventArgs)

        Throw New NotImplementedException()

    End Sub

    Protected Property MessageCount As Integer

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        If (Not IsPostBack) Then
            Dim oComm As clsCommon = New clsCommon()
            Dim oService As EIDSSService

            CreateLanguageOptions()

            ToggleHelp(Request.Url.Segments)

            'Create dynamic menu
            Dim AppMenu As New clsMenu
            Dim AppMenuItems As New clsMenuItemCollection
            Dim AppMenuFooterItems As New clsMenuItemCollection
            Dim oMenuDS As DataSet = New DataSet

            Try
                'Get logged in user ID
                Dim oEIDSSDS As DataSet = Nothing
                Dim sUserSettingsFile As String = oComm.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
                Dim userID As String = "0"

                ' SV
                userID = EIDSSAuthenticatedUser.EIDSSUserId

                'oEIDSSDS = oCommon.ReadEIDSSXML(sUserSettingsFile)
                'If oEIDSSDS.CheckDataSet() Then
                '    userID = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfUserID") & ""
                'End If

                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If

                Dim list As List(Of GblNotificationGetListModel) = CrossCuttingAPIService.GetNotificationListAsync(GetCurrentLanguage(), Nothing, Nothing, Nothing, userID, Nothing).Result.OrderByDescending(Function(x) x.EnteredDate).ToList()
                MessageCount = list.Count()

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfUserId", .ParamValue = userID, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim s = oComm.KeyValPairToString(KeyValPair)
                Dim oTuple = oService.GetData(GetCurrentCountry(), "UserMenu", oComm.KeyValPairToString(KeyValPair))
                oMenuDS = oTuple.m_Item1

                'TODO:  User has either no role, or no employee group member.  Recommend some kind of warning display to the user.  No menu items will show.
                If oMenuDS.Tables(0).Columns.Contains(ParentMenuID) = False Then
                    oMenuDS = Nothing
                End If
            Catch ex As Exception
                oMenuDS = Nothing
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Finally
                oService = Nothing
                oComm = Nothing
            End Try

            Try
                If oMenuDS.CheckDataSet() Then
                    Dim sFilter As String = ""
                    Dim dtFiltered As DataTable = Nothing
                    Dim oParentMenuDV As DataView = Nothing
                    Dim oParentMenuDSFiltered As DataSet = Nothing
                    Dim oParentMenuRow As DataRow

                    'Filter menu data to get Parent (top level) Menu List
                    sFilter = "[" & ParentMenuID & "] = [" & MenuID & "]"

                    oParentMenuDV = oMenuDS.Tables(0).DefaultView()

                    oParentMenuDV.RowFilter = sFilter
                    dtFiltered = oParentMenuDV.ToTable()

                    oParentMenuDSFiltered = New DataSet
                    oParentMenuDSFiltered.Tables.Add(dtFiltered)

                    If oParentMenuDSFiltered.CheckDataSet() Then
                        For Each oParentMenuRow In oParentMenuDSFiltered.Tables(0).Rows
                            With oParentMenuRow
                                AppMenuItems.Add(New clsMenuItem(.Item("idfsBaseReference"),
                                                                 .Item("PageLink"),
                                                                 .Item("MenuName"),
                                                                 False,
                                                                 "",
                                                                 (.Item("IsOpenInNewWindow") = 1),
                                                                 clsMenu.StartParentTag,
                                                                 ""))

                                'Find all sub-menus for this parent
                                CreateSubMenuItems(AppMenuItems, oMenuDS, .Item(MenuID), clsMenu.StartParentTag, clsMenu.CloseParentTag)
                            End With
                        Next
                    End If
                    divMenu.InnerHtml = AppMenu.ShowMenu(AppMenuItems)
                End If
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                oMenuDS = Nothing
            Finally
                oService = Nothing
                oComm = Nothing
            End Try
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="AppMenuItems"></param>
    ''' <param name="oMenuDS"></param>
    ''' <param name="iParentId"></param>
    ''' <param name="StartMenuTag"></param>
    ''' <param name="CloseMenuTag"></param>
    Private Sub CreateSubMenuItems(ByRef AppMenuItems As clsMenuItemCollection, ByVal oMenuDS As DataSet, ByVal iParentId As Integer, StartMenuTag As String, CloseMenuTag As String)

        Dim oSubMenuDS As DataSet
        Dim oSubMenuRow As DataRow
        Dim sMenuTag As String
        Dim bLastItem As Boolean = False

        oSubMenuDS = GetSubMenuItems(oMenuDS, iParentId)
        If oSubMenuDS.CheckDataSet() Then
            For iMenuCount As Integer = 0 To (oSubMenuDS.Tables(0).Rows.Count - 1)
                oSubMenuRow = oSubMenuDS.Tables(0).Rows(iMenuCount)

                With oSubMenuRow
                    'Check if this sub-menu is a parent
                    If GetSubMenuItems(oMenuDS, .Item(MenuID)).CheckDataSet() Then
                        bLastItem = (iMenuCount = (oSubMenuDS.Tables(0).Rows.Count - 1))
                        AppMenuItems.Add(New clsMenuItem(.Item("idfsBaseReference"),
                                                         .Item("PageLink"),
                                                         .Item("MenuName"),
                                                         False,
                                                         "",
                                                         (.Item("IsOpenInNewWindow") = 1),
                                                         clsMenu.StartChildParentTag,
                                                         ""))

                        CreateSubMenuItems(AppMenuItems, oMenuDS, .Item(MenuID), clsMenu.StartChildParentTag, IIf(bLastItem, clsMenu.CloseParentTag, clsMenu.CloseChildParentTag))
                    End If

                    sMenuTag = ""
                    If iMenuCount = (oSubMenuDS.Tables(0).Rows.Count - 1) Then
                        sMenuTag = CloseMenuTag
                    End If

                    If bLastItem = False Then
                        AppMenuItems.Add(New clsMenuItem(.Item("idfsBaseReference"),
                                                        .Item("PageLink"),
                                                        .Item("MenuName"),
                                                        False,
                                                        "",
                                                        (.Item("IsOpenInNewWindow") = 1),
                                                        sMenuTag,
                                                        ""))
                    End If
                End With
            Next
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="oMenuDS"></param>
    ''' <param name="iParentId"></param>
    ''' <returns></returns>
    Private Function GetSubMenuItems(ByVal oMenuDS As DataSet, ByVal iParentId As Integer) As DataSet

        Dim sFilter As String = ""
        Dim dtFiltered As DataTable = Nothing
        Dim oSubMeuDV As DataView = Nothing
        Dim oSubMenuDSFiltered As DataSet = Nothing

        Try
            'Sub-Menu
            sFilter = "[" & ParentMenuID & "] = '" & iParentId.ToString() & "' And [" & ParentMenuID & "] <> [" & MenuID & "]"

            oSubMeuDV = oMenuDS.Tables(0).DefaultView()

            oSubMeuDV.RowFilter = sFilter

            If Not (oSubMeuDV Is Nothing) Then
                dtFiltered = oSubMeuDV.ToTable()

                oSubMenuDSFiltered = New DataSet
                oSubMenuDSFiltered.Tables.Add(dtFiltered)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return oSubMenuDSFiltered

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub CreateLanguageOptions()

        'read values from config file
        Dim section As NameValueCollection
        section = CType(ConfigurationManager.GetSection("LocalizationAndCulture"), NameValueCollection)

        If IsNothing(section) Then
            Return
        End If

        languageContainer.Controls.Clear()

        If section.Keys.Count > 0 Then
            For Each key In section.Keys
                Dim languageItem = New HtmlGenericControl("li")
                Dim button As New Button With {
                    .CssClass = "languageNavLink",
                    .ID = "lang" + key.ToString(),
                    .Text = TryCast(GetGlobalResourceObject("LanguageList", section(key).ToString().Remove(2, 1)), String),
                    .ToolTip = TryCast(GetGlobalResourceObject("LanguageList", section(key).ToString().Remove(2, 1)), String)
                }
                AddHandler button.Click, AddressOf langChanged_Click

                languageItem.Controls.Add(button)
                languageContainer.Controls.Add(languageItem)
            Next
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub langChanged_Click(ByVal sender As Object, ByVal e As EventArgs)

        Dim buttonclicked = CType(sender, Button)

        If IsNothing(buttonclicked) Then
            Return
        End If

        ' Here we are substracting the 'lang' portion of the id to get the value we need
        Dim language = buttonclicked.ID.Substring(4)
        Dim LanguageEventArgs = New LanguageEventArgs

        Dim section As NameValueCollection
        section = CType(ConfigurationManager.GetSection("LocalizationAndCulture"), NameValueCollection)
        LanguageEventArgs.NewLanguage = section.Get(language).ToString()

        OnLanguageCulturechanged(LanguageEventArgs)
        Response.Redirect(Request.UrlReferrer.OriginalString)

    End Sub

    Public Event LanguageCultureChanged(ByVal sender As Object, ByVal e As LanguageEventArgs)

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="e"></param>
    Protected Overridable Sub OnLanguageCulturechanged(ByVal e As LanguageEventArgs)

        RaiseEvent LanguageCultureChanged(Me, e)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub menu_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)

        If ((e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem)) Then
            Dim item As SiteMapNode = e.Item.DataItem
            If item.Title.EqualsAny(getConfigValue("LocalMenu").Split(";")) Then
                e.Item.Visible = Request.IsLocal
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sFor"></param>
    ''' <returns></returns>
    Public Function ShowHideMenu(sFor As String) As Boolean

        If (sFor.EqualsAny(getConfigValue("LocalMenu").Split(";"))) Then
            'Return Request.IsLocal
            Return False
        End If

        Return True

    End Function

    ''' <summary>
    ''' Displays the help icons by page.
    ''' </summary>
    ''' <param name="WebSegments"></param>
    Public Sub ToggleHelp(ByVal WebSegments() As String)

        'Assuming that the last segment is the aspx page
        Dim strWebPageName As String = WebSegments(WebSegments.Count - 1)

        'Assuming that the last segment contains page name.
        If strWebPageName.IndexOf("aspx") > 0 Then
            Try
                'Get the Help files
                Dim oDS As DataSet = New DataSet
                Dim sPath As String = HttpContext.Current.Server.MapPath("~/App_Data/EIDSSPages.xml")
                oDS.ReadXml(sPath)

                Dim oDV As DataView = Nothing
                Dim oDSFiltered As New DataSet

                If oDS.CheckDataSet() Then
                    Dim sFilter As String = "PageName = '" & strWebPageName & "'"
                    oDV = oDS.Tables(0).DefaultView()

                    oDV.RowFilter = sFilter
                    Dim dtFiltered As DataTable = oDV.ToTable()
                    oDSFiltered.Tables.Add(dtFiltered)

                    Dim sHelpFilePath As String = "~/Help/{0}/"
                    Dim sHelpFile As String = "Page{0}File"
                    Dim sHelpTypes As String() = "Text;Audio;Video".Split(";")

                    If oDSFiltered.CheckDataSet() Then
                        'Make help visible only if the help file(s) are defined
                        lnkHelpText.Visible = (oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(0)).ToString()) <> "")
                        lnkHelpAudio.Visible = (oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(1)).ToString()) <> "")
                        lnkHelpVideo.Visible = (oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(2)).ToString()) <> "")

                        'Make help visible only if the help file(s) exist in the file system
                        If lnkHelpText.Visible Then lnkHelpText.Visible = (File.Exists(Server.MapPath(String.Format(sHelpFilePath, sHelpTypes(0)) & oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(0))).ToString())))
                        If lnkHelpAudio.Visible Then lnkHelpAudio.Visible = (File.Exists(Server.MapPath(String.Format(sHelpFilePath, sHelpTypes(1)) & oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(1))).ToString())))
                        If lnkHelpVideo.Visible Then lnkHelpVideo.Visible = (File.Exists(Server.MapPath(String.Format(sHelpFilePath, sHelpTypes(2)) & oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(2))).ToString())))
                        helpsection.Visible = (lnkHelpText.Visible Or lnkHelpAudio.Visible Or lnkHelpVideo.Visible)

                        If helpsection.Visible Then
                            'Set links
                            If lnkHelpText.Visible Then lnkHelpText.NavigateUrl = String.Format(sHelpFilePath, sHelpTypes(0)) & oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(0))).ToString()
                            If lnkHelpAudio.Visible Then lnkHelpAudio.NavigateUrl = String.Format(sHelpFilePath, sHelpTypes(1)) & oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(1))).ToString()
                            If lnkHelpVideo.Visible Then lnkHelpVideo.NavigateUrl = String.Format(sHelpFilePath, sHelpTypes(2)) & oDSFiltered.Tables(0).Rows(0).Item(String.Format(sHelpFile, sHelpTypes(2))).ToString()
                        End If
                    Else
                        helpsection.Visible = False
                    End If
                End If
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Throw
            End Try
        End If

    End Sub

    '**************************************************************************
    '*
    '* Method: hlpNavigationLink_Click
    '* 
    '* Purpose: Clear out caller related view state variables as the user is 
    '* switching modules.
    '*
    '**************************************************************************
    Protected Sub hplNavigationLink_Click(sender As Object, e As EventArgs)

        ViewState(CALLER) = CallerPages.Dashboard
        ViewState(CALLER_KEY) = Nothing
        ViewState(CALLER_INFO) = Nothing
        oCommon.SaveViewState(ViewState)

        Response.Redirect(CType(sender, LinkButton).CommandArgument)

    End Sub

End Class

Public Class LanguageEventArgs
    Inherits EventArgs
    Public Property NewLanguage As String
End Class