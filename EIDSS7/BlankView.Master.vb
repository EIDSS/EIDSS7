Imports System.Threading
Public Class BlankViewMaster
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        LoadCssFiles()

        LoadScript()

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