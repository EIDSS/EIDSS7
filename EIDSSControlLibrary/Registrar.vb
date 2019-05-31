Imports System.Web.UI.HtmlControls
Imports System.Web.UI
Public Class Registrar

    Public Shared BaseCssFile As String = "EIDSSControlLibrary.EIDSSControlLibraryCss.css"

    Public Shared BaseJsFile As String = "EIDSSControlLibrary.EIDSSControlLibraryScripts.js"

    Public Shared StickyFile As String = "EIDSSControlLibrary.StickyPanel.js"

    Public Shared Sub RegisterJavaScriptFile(ByRef page As Page, ByRef type As Type, ByRef fileName As String)

        Dim cs As ClientScriptManager = page.ClientScript
        cs.RegisterClientScriptResource(type, fileName)
    End Sub

    Public Shared Sub RegisterJavaScriptBlob(ByRef Page As Page, ByRef ScriptKey As String, ByRef Script As String)
        Dim cs As ClientScriptManager = Page.ClientScript

        If (Not cs.IsStartupScriptRegistered(Page.GetType(), ScriptKey)) Then
            cs.RegisterStartupScript(Page.GetType(), ScriptKey, Script, True)
        End If
    End Sub

    Public Shared Sub RegisterCssFile(ByRef page As Page, ByRef type As Type, ByRef fileName As String)
        Dim includeTemplate As String = "<link rel='stylesheet' href='{0}' />"
        Dim includeCss As String = page.ClientScript.GetWebResourceUrl(type, fileName)
        Dim include As LiteralControl = New LiteralControl(String.Format(includeTemplate, includeCss))

        Dim pageHead As HtmlHead
        pageHead = page.Header

        Dim exists As Boolean

        If (pageHead.Controls.Count > 0) Then
            For Each control In pageHead.Controls
                If control.ToString() = GetType(LiteralControl).FullName Then
                    Dim testSubject = DirectCast(control, LiteralControl)
                    If (testSubject.Text.Contains(includeCss)) Then
                        exists = True
                        Exit For
                    End If
                End If
            Next
        End If
        If Not exists Then
            pageHead.Controls.AddAt(0, include)
        End If
    End Sub
End Class
