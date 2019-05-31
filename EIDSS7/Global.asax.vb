Imports System.Globalization
Imports System.Threading
Imports System.Web.SessionState

<Assembly: log4net.Config.XmlConfigurator(Watch:=True)>
Public Class Global_asax
    Inherits System.Web.HttpApplication

    ReadOnly Logger As log4net.ILog = log4net.LogManager.GetLogger(GetType(Global_asax).ToString)

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application is started

        ScriptManager.ScriptResourceMapping.AddDefinition("jquery", New ScriptResourceDefinition With {
            .Path = "~/Includes/Scripts/jquery-3.2.1.js",
            .DebugPath = "~/Includes/Scripts/jquery-3.2.1.js",
            .CdnPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.2.1.js",
            .CdnDebugPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.2.1.js"
        })

        ScriptManager.ScriptResourceMapping.AddDefinition("jquery-ui", New ScriptResourceDefinition With {
            .Path = "~/Includes/Scripts/jquery-ui.js",
            .DebugPath = "~/Includes/Scripts/jquery-ui.js"
        })

        ScriptManager.ScriptResourceMapping.AddDefinition("jquery-dragtable", New ScriptResourceDefinition With {
            .Path = "~/Includes/Scripts/jquery.dragtable.js",
            .DebugPath = "~/Includes/Scripts/jquery.dragtable.js"
        })

        ScriptManager.ScriptResourceMapping.AddDefinition("jquery-scannerdetection", New ScriptResourceDefinition With {
            .Path = "~/Includes/Scripts/jquery.scannerdetection.js",
            .DebugPath = "~/Includes/Scripts/jquery.scannerdetection.js"
        })

        ScriptManager.ScriptResourceMapping.AddDefinition("bootstrap", New ScriptResourceDefinition With {
            .Path = "~/Includes/Scripts/bootstrap.js",
            .DebugPath = "~/Includes/Scripts/bootstrap.js"
        })

        ScriptManager.ScriptResourceMapping.AddDefinition("moment-with-locales", New ScriptResourceDefinition With {
            .Path = "~/Includes/Scripts/moment-with-locales.js",
            .DebugPath = "~/Includes/Scripts/moment-with-locales.js"
        })

        ScriptManager.ScriptResourceMapping.AddDefinition("bootstrap-datetimepicker", New ScriptResourceDefinition With {
            .Path = "~/Includes/Scripts/bootstrap-datetimepicker.js",
            .DebugPath = "~/Includes/Scripts/bootstrap-datetimepicker.js"
        })

    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)

        ' Fires when the session is started
        Session("Caller") = "DASHBOARD"
        Session("CallerKey") = 0

        Session("UserID") = "0"
        Session("Person") = "0"
        Session("FirstName") = ""
        Session("SecondName") = ""
        Session("FamilyName") = ""
        Session("Institution") = "0"
        Session("UserName") = ""
        Session("Organization") = ""
        Session("strOptions") = ""
        Session("language") = getConfigValue("Language")

        'Set the Session variables that store data
        Session("CountryDS") = Nothing
        Session("RegionDS") = Nothing
        Session("RayonDS") = Nothing

    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)

        ' Fires at the beginning of each request
        'Dim cookie As HttpCookie = Request.Cookies("CultureInfo")

        'If (cookie Is Nothing OrElse cookie.Value.IsValueNullOrEmpty()) Then
        '    Thread.CurrentThread.CurrentUICulture = New CultureInfo("en-US")
        '    Thread.CurrentThread.CurrentCulture = New CultureInfo("en-US")
        'Else
        '    Thread.CurrentThread.CurrentUICulture = New CultureInfo(cookie.Value)
        '    Thread.CurrentThread.CurrentCulture = New CultureInfo(cookie.Value)
        'End If

    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)

        Dim errors() As Exception = Me.Context.AllErrors()

        Dim exc As Exception = Server.GetLastError()
        'log error
        LogException(exc)

        Server.Transfer("~/GeneralError.aspx?handler=Application_Error%20-%20Global.asax", True)

    End Sub

    Protected Sub LogException(ByVal exc As Exception)
        If (exc Is Nothing) Then
            Return
        End If

        'ignore 404 HTTP errors
        Dim httpException = CType(exc, HttpException)
        If ((Not (httpException) Is Nothing) AndAlso (httpException.GetHttpCode = 404)) Then
            Return
        End If

        Try
            'log
            Logger.Error(exc.Message, exc)
        Catch ex As Exception
            'don't throw new exception if occurs
        End Try

    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)

        ' Fires when the session ends
        Session("UserID") = "0"
        Session("Person") = "0"
        Session("FirstName") = ""
        Session("SecondName") = ""
        Session("FamilyName") = ""
        Session("Institution") = "0"
        Session("UserName") = ""
        Session("Organization") = ""
        Session("strOptions") = ""
        Session("language") = "EN"
        Session("CountryDS") = Nothing
        Session("RegionDS") = Nothing
        Session("RayonDS") = Nothing

    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application ends
    End Sub

End Class