Public Class FullView
    Inherits MasterPage

    Protected WithEvents ErrorMessageContainer As HtmlGenericControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        LoadCssFiles()

        If Not IsPostBack Then
            AddHandler ucPageHeader.LanguageCultureChanged, AddressOf LanguageCultureChanged
        End If

    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Unload

        ScriptManager.RegisterStartupScript(Me, [GetType](), "Modal", "hideLoading();", True)

    End Sub

    Private Sub LoadCssFiles()

        Dim link As HtmlLink

        link = New HtmlLink With {
            .Href = "~/Includes/CSS/bootstrap.css"
        }
        link.Attributes.Add("rel", "stylesheet")
        link.Attributes.Add("type", "text/css")
        Page.Header.Controls.Add(link)

        link = New HtmlLink With {
            .Href = "~/Includes/CSS/EIDSS7Styles-1.0.0.css"
        }
        link.Attributes.Add("rel", "stylesheet")
        link.Attributes.Add("type", "text/css")
        Page.Header.Controls.Add(link)

        link = New HtmlLink With {
            .Href = "~/Includes/CSS/EIDSS7FullViewModuleStyles-1.0.0.css"
        }
        link.Attributes.Add("rel", "stylesheet")
        link.Attributes.Add("type", "text/css")
        Page.Header.Controls.Add(link)

    End Sub

    Public Event LanguageChanged(ByVal sender As Object, ByVal e As LanguageEventArgs)

    Public Sub LanguageCultureChanged(ByVal sender As Object, ByVal args As LanguageEventArgs) Handles ucPageHeader.LanguageCultureChanged

        RaiseEvent LanguageChanged(Me, args)

    End Sub

End Class