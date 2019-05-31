Imports System.ComponentModel
Imports System.Web.UI
Imports System.Web.UI.WebControls


<DefaultProperty("Text"), ToolboxData("<{0}:PopUpDialog runat=server></{0}:PopUpDialog>")> _
Public Class PopUpDialog
    Inherits WebControl

    <Bindable(True), Category("Appearance"), DefaultValue(""), Localizable(True)>
    Property Text() As String
        Get
            Dim s As String = CStr(ViewState("Text"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("Text") = Value
        End Set
    End Property

    <Bindable(True), Category("Misc"), DefaultValue(""), Localizable(True)>
    Public Property ModalTitle As String
        Get
            Dim s As String = CStr(ViewState("ModalTitle"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get
        Set(value As String)
            ViewState("ModalTitle") = value
        End Set
    End Property

    <Bindable(True), Category("Misc"), DefaultValue(""), Localizable(True)>
    Public Property ShowModalHeader As Boolean
        Get
            Return ViewState("ShowModalHeader")
        End Get
        Set(value As Boolean)
            ViewState("ShowModalHeader") = value
        End Set
    End Property

    <Bindable(True), Category("Misc"), DefaultValue(""), Localizable(True)>
    Public Property ShowModalFooter As Boolean
        Get
            Return ViewState("ShowModalFooter")
        End Get
        Set(value As Boolean)
            ViewState("ShowModalFooter") = value
        End Set
    End Property

    Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)

        Dim tophtml As String
        tophtml = String.Format("<div Class=""modal fade"" id=""{0}"" role=""dialog"">", ID)
        tophtml += "<div Class=""modalWithNoSetWidth"">"
        tophtml += "<div class=""eidss-dialog"">"

        ' Modal content
        tophtml += "<div Class=""modal-content"">"
        If ShowModalHeader Then
            tophtml += "<div Class=""modal-header"">"
            tophtml += "<Button type = ""button"" Class=""close"" data-dismiss=""modal"">&times;</button>"
            tophtml += String.Format("<h4 Class=""modal-title"">{0}</h4></div>", ModalTitle)
        End If

        tophtml += String.Format("<div Class=""modal-body"" id=""{0}_innerdiv"">", ID)

        writer.Write(tophtml)

        RenderContents(writer)

        Dim bottomhtml As String

        bottomhtml = "</div>"
        If ShowModalFooter Then
            bottomhtml += "<div Class=""modal-footer""><Button type=""button"" Class=""btn btn-Default"" data-dismiss=""modal"">Close</button></div>"
        End If
        bottomhtml += "</div></div></div></div>"
        writer.Write(bottomhtml)
    End Sub

End Class
