Imports System.ComponentModel
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Text


<DefaultProperty("Text"), ToolboxData("<{0}:ConfirmationButton runat=server></{0}:ConfirmationButton>")>
Public Class ConfirmationButton
    Inherits LinkButton


    Private _glyphicon As String
    Private _modalHeadingCss As String
    Private _btnCss As String
    Private _navigateToUrl As String
    Public Property HeaderGlyphicon As String
        Get
            If String.IsNullOrEmpty(_glyphicon) Then
                Return "red glyphicon glyphicon-warning-sign"
            End If
            Return _glyphicon
        End Get
        Set(value As String)
            _glyphicon = value
        End Set
    End Property
    Public Property ModalHeading As String
    Public Property ModalHeadingCss As String
        Get
            If String.IsNullOrEmpty(_modalHeadingCss) Then
                Return "red"
            End If
            Return _modalHeadingCss
        End Get
        Set(value As String)
            _modalHeadingCss = value
        End Set
    End Property
    Public Property ShowModalHeader As Boolean
    Public Property MessageTitle As String
    Public Property MessageText As String
    Public Property MessageConfirmation As String
    Public Property ButtonCss As String
        Get
            If String.IsNullOrEmpty(_btnCss) Then
                Return "btn btn-default"
            End If
            Return _btnCss
        End Get
        Set(value As String)
            _btnCss = value
        End Set
    End Property
    Public Property ButtonConfirmMessage As String
    Public Property ButtonNotConfirmMessage As String
    Public Property NavigateToUrl As String
        Get
            If String.IsNullOrEmpty(_navigateToUrl) Then
                Throw New Exception("NavigateToUrl was not set")
            End If
            Return _navigateToUrl
        End Get
        Set(value As String)
            _navigateToUrl = value
        End Set
    End Property

    Protected Overrides Sub RenderContents(ByVal writer As HtmlTextWriter)
        Dim sb As StringBuilder = New StringBuilder()

        sb.AppendLine($"<a class=""btn btn-default"" data-target=""#cancelModalWarning"" data-toggle=""modal"">{Text}</a>")
        sb.AppendLine($"<div class=""modal fade"" id=""cancelModalWarning"" role=""dialog"">")
        sb.AppendLine($"<div class=""modal-dialog""><div class=""modal-content"">")

        If ShowModalHeader Then

            sb.AppendLine($"<div class=""modal-header"">")
            sb.AppendLine($"<div class=""{HeaderGlyphicon}""></div>")
            sb.AppendLine($"<div class=""{ModalHeadingCss}"">{ModalHeading}</div>")
            sb.AppendLine($"</div>")

        End If

        sb.AppendLine($"<div class=""modal-body text-center"">")
        sb.AppendLine($"<b>{MessageTitle}</b><br /><span>{MessageText}</span><br /><span>{MessageConfirmation}</span><br /></div>")
        sb.AppendLine($"<div class=""modal-footer"">")
        sb.AppendLine($"<a class=""{ButtonCss}"" href=""{NavigateToUrl}"">{ButtonConfirmMessage}</a>")
        'sb.AppendLine($"<a class=""{ButtonCss}"" href=""#"" onclick=""$('#cancelModalWarning').modal({"{"} show: false{"}"});"">{ButtonNotConfirmMessage}</a>")
        sb.AppendLine($"<a class=""{ButtonCss}"" href=""#"" onclick=""$('#cancelModalWarning').modal('toggle');"">{ButtonNotConfirmMessage}</a>")
        sb.AppendLine($"</div>")
        sb.AppendLine($"</div></div>")

        writer.Write(sb.ToString())
    End Sub

End Class
