Imports System.ComponentModel
Imports System.Text
Imports System.Web.UI

<DefaultProperty("Text"), ToolboxData("<{0}:SideBarItem><{0}:SideBarItem")>
Public Class SideBarItem
    Inherits Control
    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("Text to be displayed")>
    Public Property GoToTab As String

    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("Section to navigate to")>
    Public Property GoToSideBarSection As String

    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("Naviate to review (use when disabling other side bar items, but want them to display)")>
    Public Property GoToReviewSection As String

    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("Status of Checkmark")>
    Public Property ItemStatus As SideBarStatus

    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("Indicates an active link")>
    Public Property IsActive As Boolean

    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("Text to display on link")>
    Public Property Text As String

    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("ToolTip to be displayed")>
    Public Property ToolTip As String

    <Bindable(True), Category("Appearance"), DefaultValue(""), Description("CSS Class of icon")>
    Public Property CssClass As String

    <Bindable(True), Category("Misc"), DefaultValue(""), Description("ID of checkmark")>
    Public Overrides Property ID As String

    <Bindable(True), Category("Navigation"), DefaultValue(""), Description("URL for HyperLink")>
    Public Property Href As String

    Protected Overrides Sub Render(writer As HtmlTextWriter)
        Dim sb As StringBuilder = New StringBuilder()
        sb.AppendLine($"<li>")
        If (String.IsNullOrEmpty(Href)) Then
            sb.AppendLine($"<a href = ""#"" class=""checkmarklink"" onclick=""goToTab({GoToTab})"">")
        Else
            sb.AppendLine($"<a href = ""{Href}"" class=""checkmarklink"" >")
        End If
        Select Case ItemStatus
            Case SideBarStatus.IsNormal
                sb.AppendLine($"<div id=""{ID}"" class=""{CssClass} normalcheckmark"" tooltip = ""{ToolTip}"" ></div>")
            Case SideBarStatus.IsValid
                sb.AppendLine($"<div id=""{ID}"" class=""{CssClass} passcheckmark"" tooltip = ""{ToolTip}"" ></div>")
            Case SideBarStatus.IsInvalid
                sb.AppendLine($"<div id=""{ID}"" class=""{CssClass} failcheckmark"" tooltip = ""{ToolTip}"" ></div>")
            Case SideBarStatus.IsReview
                sb.AppendLine($"<div id=""{ID}"" class=""{CssClass} normalcheckmark"" tooltip = ""{ToolTip}"" ></div>")
        End Select

        sb.AppendLine("</a>")
        If (String.IsNullOrEmpty(Href)) Then
            If String.IsNullOrEmpty(GoToSideBarSection) Then
                If String.IsNullOrEmpty(GoToReviewSection) Then
                    sb.AppendLine($"<a href = ""#"" onclick=""goToTab({GoToTab})"">{Text}</a>")
                Else
                    sb.AppendLine($"<a href = ""#"" onclick=""goToReviewSection({GoToReviewSection})"">{Text}</a>")
                End If
            Else
                sb.AppendLine($"<a href = ""#"" onclick=""goToSideBarSection({GoToSideBarSection})"">{Text}</a>")
            End If
        Else
                sb.AppendLine($"<a href = ""{Href}"">{Text}</a>")
        End If

        sb.AppendLine("</li>")

        writer.Write(sb.ToString())
    End Sub
End Class
