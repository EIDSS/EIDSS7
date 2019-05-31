Imports System.ComponentModel
Imports System.Web.UI
Imports System.Web.UI.HtmlControls

<DefaultProperty("Text"),
    Category("Appearance"),
    ToolboxData("<{0}:DropDownList runat=server AddPageUrl="""" SearchPageUrl="""" PopUpWindowId ></{0}:DropDownList>")>
Public Class DropDownList
    Inherits WebControls.DropDownList

    <Bindable(True), DefaultValue(""), Localizable(True), Category("Misc")>
    Public Property SearchPageUrl() As String
        Get
            Dim s As String = CStr(ViewState("SearchPageUrl"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("SearchPageUrl") = Value
        End Set
    End Property

    <Bindable(True), DefaultValue(""), Localizable(True), Category("Misc")>
    Public Property AddPageUrl() As String
        Get
            Dim s As String = CStr(ViewState("AddPageUrl"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("AddPageUrl") = Value
        End Set
    End Property

    <Bindable(True), DefaultValue(""), Localizable(True), Category("Misc")>
    Public Property PopUpWindowId As String
        Get
            Dim s As String = CStr(ViewState("PopUpWindowId"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get
        Set(value As String)
            ViewState("PopUpWindowId") = value
        End Set
    End Property

    <Bindable(True), DefaultValue(""), Localizable(True), Category("Misc")>
    Public Property AddButtonText As String
        Get
            Dim s As String = CStr(ViewState("AddButtonText"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get
        Set(value As String)
            ViewState("AddButtonText") = value
        End Set
    End Property

    <Bindable(True), DefaultValue(""), Localizable(True), Category("Misc")>
    Public Property SearchButtonText As String
        Get
            Dim s As String = CStr(ViewState("SearchButtonText"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get
        Set(value As String)
            ViewState("SearchButtonText") = value
        End Set
    End Property

    <Bindable(True), DefaultValue("addButton"), Localizable(True), Category("Misc")>
    Public Property AddButtonCssClass As String
        Get
            Dim s As String = CStr(ViewState("addButtonCssClass"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get
        Set(value As String)
            ViewState("addButtonCssClass") = value
        End Set
    End Property

    <Bindable(True), DefaultValue("addButton"), Localizable(True), Category("Misc")>
    Public Property SearchButtonCssClass As String
        Get
            Dim s As String = CStr(ViewState("searchButtonCssClass"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get
        Set(value As String)
            ViewState("searchButtonCssClass") = value
        End Set
    End Property

    Public Property ContainerCssClass As String
        Get
            Dim s As String = CStr(ViewState("containerCssClass"))
            If s Is Nothing Then
                Return String.Empty
            Else
                Return s
            End If
        End Get
        Set(value As String)
            ViewState("containerCssClass") = value
        End Set
    End Property

    Protected Overrides Sub OnPagePreLoad(sender As Object, e As EventArgs)
        MyBase.OnPagePreLoad(sender, e)
        Registrar.RegisterJavaScriptFile(Me.Page, Me.GetType(), Registrar.BaseJsFile)

        Registrar.RegisterCssFile(Me.Page, Me.GetType(), Registrar.BaseCssFile)
    End Sub

    Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)

        Dim _css As String

        If String.IsNullOrEmpty(CssClass) Then
            _css = "eidsDropDownContainerDiv"
        Else
            _css = ContainerCssClass
        End If

        Dim popUpId As String
        Try
            popUpId = Me.Parent.FindControl(PopUpWindowId).ClientID
        Catch
            popUpId = String.Empty
        End Try

        writer.Write($"<div class=""{ContainerCssClass}"">")

        MyBase.Render(writer)

        If String.IsNullOrEmpty(AddPageUrl) = False AndAlso String.IsNullOrEmpty(popUpId) = False Then
            writer.Write("<div class=""input-group-addon"">")
            writer.Write(String.Format("<span role=""button"" id=""{0}_buttonAdd"" name=""{0}_buttonAdd"" 
                                    value=""{1}"" class=""{4}"" onclick=""return eidssDropDownShowModalWindow('{2}','{3}')"" 
                                    data-toggle=""modal"" data-target=""#{3}""><span class=""glyphicon glyphicon-plus""></span></span>",
                           ID, AddButtonText, AddPageUrl, PopUpWindowId))
            writer.Write("</div>")
        End If

        If String.IsNullOrEmpty(SearchPageUrl) = False AndAlso String.IsNullOrEmpty(popUpId) = False Then
            writer.Write("<div class=""input-group-addon"">")
            writer.Write(String.Format("<span role=""button"" id=""{0}_buttonSearch"" name=""{0}_buttonSearch"" 
                                    value=""{1}"" onclick=""return eidssDropDownShowModalWindow('{2}','{3}')"" 
                                    data-toggle=""modal"" data-target=""#{3}""><span class=""glyphicon glyphicon-search""></span></span>",
                                  ID, SearchButtonText, SearchPageUrl, PopUpWindowId))
            writer.Write("</div>")
        End If

        writer.Write("</div>")

    End Sub
End Class
