Imports System.ComponentModel
Imports System.Web.UI

<DefaultProperty("Items"), ToolboxData("<{0}:SideBarNavigation runat=server> </{0}:SideBarNavigation>")>
Public Class SideBarNavigation
    Inherits UserControl

    <PersistenceMode(PersistenceMode.InnerProperty)>
    Public Property MenuItems() As List(Of SideBarItem)
        Get
            Dim s As List(Of SideBarItem) = TryCast(ViewState("MenuItems"), List(Of SideBarItem))
            If s Is Nothing Then
                Return Nothing
            End If
            Return TryCast(ViewState("MenuItems"), List(Of SideBarItem))
        End Get
        Set(value As List(Of SideBarItem))
            ViewState("MenuItems") = value
        End Set
    End Property

    Private Property container As String

    Protected Overrides Sub OnLoad(e As EventArgs)
        Registrar.RegisterJavaScriptFile(Page, Me.GetType(), Registrar.BaseJsFile)
        Registrar.RegisterCssFile(Page, Me.GetType(), Registrar.BaseCssFile)
        Registrar.RegisterJavaScriptFile(Page, Me.GetType(), Registrar.StickyFile)
        Registrar.RegisterJavaScriptBlob(Page, "SideBarNav", "$(document).ready(wireSidePanelEvents);")
        Registrar.RegisterJavaScriptBlob(Page, "PostBackNav", "Sys.WebForms.PageRequestManager.getInstance().add_endRequest(wireSidePanelEvents);")
    End Sub

    Public Overrides Sub RenderControl(writer As HtmlTextWriter)
        Dim isLowerList As Boolean = False
        Dim isActiveListRendered As Boolean = False
        Dim isActiveListClosed As Boolean = False


        writer.Write($"<div id=""{ID}"" class=""menuContainer"">")
        writer.Write($"<button id=""btnSideMenuToggle"" type=""button"" class=""menuButton"">")
        writer.Write($"<span class=""sr-only"">Toggle navigation</span>")
        writer.Write($"<span class=""menubar""></span>")
        writer.Write($"<span class=""menubar""></span>")
        writer.Write($"<span class=""menubar""></span>")
        writer.Write($"</button>")


        writer.Write($"<aside class=""sidepanel"">")
        writer.Write($"<ul>")

        ' loop through items property objects and start building the lists
        For Each sideBarItem In Me.MenuItems
            If sideBarItem.IsActive Then
                If Not isActiveListRendered Then
                    writer.Write($"<li>")
                    writer.Write($"<ul id=""panelList"">")
                    isActiveListRendered = True
                    isLowerList = True
                End If
                sideBarItem.RenderControl(writer)
            Else
                If (Not isLowerList) Then
                    sideBarItem.RenderControl(writer)
                Else
                    If Not isActiveListClosed Then
                        writer.Write($"</ul>")
                        writer.Write($"</li>")
                        isActiveListClosed = True
                    End If
                    sideBarItem.RenderControl(writer)
                End If
            End If
        Next
        If Not isActiveListClosed Then
            writer.Write($"</ul>")
            writer.Write($"</li>")
            isActiveListClosed = True
        End If

        writer.Write($"</ul>")
        writer.Write($"</aside>")
        writer.Write($"</div><div class=""sideMenuToolTip""></div>")

    End Sub

End Class




