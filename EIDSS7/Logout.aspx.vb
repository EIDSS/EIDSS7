Public Class Logout
    Inherits BaseEidssPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Session.Clear()
        System.Web.Security.FormsAuthentication.SignOut()
        Response.Redirect(GetURL("/Login.aspx"), True)

    End Sub

End Class