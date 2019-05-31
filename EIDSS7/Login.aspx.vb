
Imports System.IO
Imports EIDSS.EIDSS
Imports EIDSS
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client
Imports EIDSS.Client.Responses

Public Class Login
    Inherits BaseEidssPage

    Private Shared ReadOnly log As log4net.ILog = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType)
    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private oCommon As clsCommon = New clsCommon()

    Private Sub Login_Load(sender As Object, e As EventArgs) Handles Me.Load

        'Get the language from configuration file
        PageLanguage = "en-us"

        LoadCssFiles()

        LoadScript()

        lblBuild.Text = oCommon.GetCurrentBuildNumber

    End Sub

    'Private Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click

    '    Dim oComm As clsCommon = Nothing
    '    Dim oService As NG.EIDSSService = Nothing
    '    Dim oDS As DataSet = Nothing

    '    log.Info("Login is called")

    '    Try
    '        oComm = New clsCommon()

    '        oService = oComm.GetService()

    '        Dim intResult As Integer = -1
    '        oService.LogIn(GetCurrentCountry(), txtOrganization.Text, txtUserName.Text, txtPassword.Text, intResult, 0, oDS)

    '        log.Info("Currently trying to login the user to the system " + System.Reflection.MethodBase.GetCurrentMethod().Name)
    '        log.Info("Entered values " + txtUserName.Text)

    '        If oDS.CheckDataSet() Then

    '            If (intResult = 0) Then

    '                'To Do: Find out why the sequence of tables are changing in the dataset
    '                'Patch to manage the change in sequence of tables
    '                For Each tab As DataTable In oDS.Tables
    '                    For Each col As DataColumn In tab.Columns
    '                        If col.ColumnName.ToString().ToUpper() = "IDFUSERID" Then
    '                            oComm.Scatter(divHiddenFieldsSection, New DataTableReader(tab))

    '                            Dim sFile As String = oComm.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
    '                            oComm.SaveSearchFields({divHiddenFieldsSection}, GlobalConstants.UserSettings, sFile)

    '                            'TODO - MD: Remove - after the use of sessions below are removed from other parts of the application

    '                            ViewState(CALLER) = CallerPages.Dashboard
    '                            ViewState(CALLER_KEY) = Nothing
    '                            ViewState(CALLER_INFO) = Nothing
    '                            oComm.SaveViewState(ViewState)

    '                            ' Left for backward compatibility
    '                            ' Remove once all code is upgraded to session less management
    '                            Session("UserID") = tab.Rows(0).Item("idfUserID").ToString()
    '                            Session("Person") = tab.Rows(0).Item("idfPerson").ToString()
    '                            Session("FirstName") = tab.Rows(0).Item("strFirstName").ToString()
    '                            Session("SecondName") = tab.Rows(0).Item("strSecondName").ToString()
    '                            Session("FamilyName") = tab.Rows(0).Item("strFamilyName").ToString()
    '                            Session("Institution") = tab.Rows(0).Item("idfInstitution").ToString()
    '                            Session("UserName") = tab.Rows(0).Item("strUserName").ToString()
    '                            Session("Organization") = tab.Rows(0).Item("strLoginOrganization").ToString()
    '                            Session("strOptions") = tab.Rows(0).Item("strOptions").ToString()
    '                            Session("UserSite") = tab.Rows(0).Item("idfsSite").ToString()

    '                            'Adding Information To Session -- Lamont M 11/20/18'
    '                            Session(UserConstants.idfUserID) = tab.Rows(0).Item("idfUserID").ToString()
    '                            Session(UserConstants.UserSite) = tab.Rows(0).Item("idfsSite").ToString()
    '                        End If
    '                    Next
    '                Next

    '            Else
    '                Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, "The dataset returned from Service Login has errors.")
    '            End If

    '            System.Web.Security.FormsAuthentication.SetAuthCookie(txtUserName.Text, False)

    '            'TODO - MD: get security configuration

    '            Response.Redirect(GetURL(CallerPages.DashboardURL), True)

    '        Else

    '            ASPNETMsgBox("Invalid User ID or Password. Please try again.")

    '        End If

    '    Catch ex As Exception
    '        log.Error("Login failed", ex)
    '        Throw

    '    Finally

    '        oComm = Nothing
    '        oService = Nothing
    '        oDS = Nothing
    '        log.Info("Login returned")
    '    End Try

    'End Sub

    Private Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click

        Dim oAccountService As AccountServiceClient = Nothing

        ' GET RID OF THIS!!!
        Dim oComm As clsCommon = New clsCommon()
        'Dim oService As NG.EIDSSService = Nothing
        'Dim oDS As DataSet = Nothing

        log.Info("Login is called")

        Try
            oAccountService = New AccountServiceClient

            'Dim intResult As Integer = -1

            '' If the user was successfully logged in... the service client sets the EIDSSUserToken static class for us!
            oAccountService.Logon(txtUserName.Text, txtPassword.Text)

            log.Info(String.Format("Attempting to log user {0} into the system ", txtUserName.Text) + System.Reflection.MethodBase.GetCurrentMethod().Name)
            log.Info("Entered values " + txtUserName.Text)


            If Not EIDSSAuthenticatedUser.AccessToken Is Nothing Then
                Scatter(divHiddenFieldsSection, EIDSSAuthenticatedUser.Instance())
                Dim sFile As String = CreateTempFile(GlobalConstants.UserSettingsFilePrefix)

                oComm.SaveSearchFields({divHiddenFieldsSection}, GlobalConstants.UserSettings, sFile)


                ViewState(CALLER) = CallerPages.Dashboard
                ViewState(CALLER_KEY) = Nothing
                ViewState(CALLER_INFO) = Nothing
                CrossCuttingModule.SaveEIDSSViewState(ViewState)

                ' Left for backward compatibility
                ' Remove once all code is upgraded to session less management
                Session("UserID") = Convert.ToInt64(EIDSSAuthenticatedUser.EIDSSUserId)
                Session("Person") = Convert.ToInt64(EIDSSAuthenticatedUser.PersonId)
                Session("FirstName") = EIDSSAuthenticatedUser.FirstName
                Session("SecondName") = EIDSSAuthenticatedUser.SecondName
                Session("FamilyName") = EIDSSAuthenticatedUser.LastName
                Session("Institution") = Convert.ToInt64(EIDSSAuthenticatedUser.Institution)
                Session("UserName") = EIDSSAuthenticatedUser.UserName
                Session("Organization") = EIDSSAuthenticatedUser.Organization
                Session("strOptions") = "" ' Deprecated...
                Session("UserSite") = Convert.ToInt64(EIDSSAuthenticatedUser.SiteId)

                'Adding Information To Session -- Lamont M 11/20/18'
                Session(UserConstants.idfUserID) = Convert.ToInt64(EIDSSAuthenticatedUser.EIDSSUserId)
                Session(UserConstants.UserSite) = Convert.ToInt64(EIDSSAuthenticatedUser.SiteId)
            Else
                Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, "An error has occured.")
            End If

            System.Web.Security.FormsAuthentication.SetAuthCookie(txtUserName.Text, False)

            Response.Redirect(GetURL(CallerPages.DashboardURL), False)

        Catch ex As Exception
            log.Error("Login failed", ex)
            ASPNETMsgBox(ex.Message)
            'Throw

        Finally
            oAccountService.Dispose()
            log.Info("Login returned")
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

End Class