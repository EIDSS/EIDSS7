Imports System.Globalization
Imports System.Threading
Imports EIDSS.EIDSS

Public Class BaseEidssPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property IsModal As Boolean

        Get
            If Request.QueryString("isModal") Is Nothing Then
                Return False
            End If

            Dim queryKey = CType(Request.QueryString("isModal"), Boolean)

            Return queryKey

        End Get

    End Property

    Protected Overrides Sub OnPreInit(e As EventArgs)

        If (IsModal) Then
            MasterPageFile = "/BlankView.Master"
        End If
        MyBase.OnPreInit(e)

    End Sub

    Protected Overrides Sub OnPreLoad(e As EventArgs)

        If IsNothing(Me.Master) = False Then
            If Me.Master.GetType().Name = "normalview_master" Then
                Dim myMaster = CType(Master, NormalView)
                AddHandler myMaster.LanguageChanged, AddressOf LanguageChanged
            End If
        End If

        MyBase.OnPreLoad(e)

    End Sub

    Public Property PageLanguage As String

        Set(value As String)
            Dim cookie As HttpCookie = New HttpCookie("CultureInfo")
            cookie.Value = value
            Response.Cookies.Add(cookie)
        End Set

        Get
            Dim cookie As HttpCookie = Request.Cookies("CultureInfo")

            If (cookie Is Nothing OrElse cookie.Value.IsValueNullOrEmpty()) Then
                PageLanguage = "en-US"
            Else
                PageLanguage = cookie.Value
            End If

        End Get

    End Property

    Public Sub LanguageChanged(ByVal sender As Object, ByVal e As LanguageEventArgs)

        'Sets the cookie that Is to be used by Global.asax
        Dim cookie As HttpCookie = New HttpCookie("CultureInfo")
        cookie.Value = e.NewLanguage
        Response.Cookies.Add(cookie)

        InitializeCulture()

    End Sub

    Protected Overrides Sub InitializeCulture()

        Try

            Dim cookie As HttpCookie = Request.Cookies("CultureInfo")

            If (cookie Is Nothing OrElse cookie.Value.IsValueNullOrEmpty()) Then
                Thread.CurrentThread.CurrentUICulture = New CultureInfo("en-US")
                Thread.CurrentThread.CurrentCulture = New CultureInfo("en-US")
            Else
                Thread.CurrentThread.CurrentUICulture = New CultureInfo(cookie.Value)
                Thread.CurrentThread.CurrentCulture = New CultureInfo(cookie.Value)
            End If

            MyBase.InitializeCulture()

        Catch ex As System.Web.HttpException
            '  do nothing for now
        Catch ex As System.Exception
            ' do nothing for now
        End Try

    End Sub

End Class