Imports System.ComponentModel
Imports System.IO
Imports System.Text
Imports System.Web.UI
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls
Imports System.Xml.Serialization

<DefaultProperty("Text"),
    Category("Appearance"),
    ToolboxData("<{0}:GridView runat=server></{0}:GridView>")>
Public Class GridView
    Inherits WebControls.GridView
#Region "Properties"
    ''' <summary>
    ''' This Property flags this grid as a modal pop up
    ''' </summary>
    ''' <returns></returns>
    Private ReadOnly Property IsModal As Boolean
        Get
            If Not Me.Page Is Nothing Then

                Dim queryKey = Me.Page.Request.QueryString("isModal")
                If queryKey Is Nothing Then
                    Return False
                End If

                If ((String.IsNullOrEmpty(queryKey) = False) And
               (CType(queryKey, Boolean) = True)) Then
                    Return True
                End If
                Return False
            Else
                Return False
            End If

        End Get
    End Property


    ''' <summary>
    ''' Read only property, gets wxpected value in query string key name: listId
    ''' </summary>
    ''' <returns></returns>
    Private ReadOnly Property ListId As String
        Get
            Return Me.Page.Request.QueryString("listId").ToString()
        End Get
    End Property

    ''' <summary>
    ''' key holds name of column used to return value to parent page
    ''' </summary>
    ''' <returns></returns>
    Private Property key As String

    ''' <summary>
    ''' Name of column that holds the id used to return value to parent page
    ''' </summary>
    ''' <returns></returns>
    <Category("Misc"), DefaultValue(""), Localizable(False)>
    Public Property KeyNameUsedOnModal As String
        Get
            Dim key As String = CStr(ViewState("KeyNameUsedOnModal"))
            If key Is Nothing Then
                Return String.Empty
            End If
            Return key
        End Get
        Set(value As String)
            ViewState("KeyNameUsedOnModal") = value
        End Set
    End Property

    ''' <summary>
    ''' This gets or sets a coma separated list of the column headings in shown in order of appearance
    ''' </summary>
    ''' <returns></returns>
    <Bindable(True), DefaultValue(""), Localizable(True), Category("Misc")>
    Public Property CurrentColumnOrder As String
        Get
            If IsNothing(hiddenOrderManager) Then
                Return String.Empty
            End If
            Return hiddenOrderManager.Value
        End Get
        Set(value As String)
            hiddenOrderManager.Value = value
        End Set
    End Property

    Public Property hiddenOrderManager As HiddenField
        Get
            Return CType(ViewState("fdsa"), HiddenField)
        End Get
        Set(value As HiddenField)
            ViewState("fdsa") = value
        End Set
    End Property

#End Region

#Region "Page Life Cycle Events (Overwitten)"
    ''' <summary>
    ''' Instantiates objects
    ''' </summary>
    ''' <param name="e"></param>
    Protected Overrides Sub OnInit(e As EventArgs)
        MyBase.OnInit(e)
        If IsNothing(hiddenOrderManager) Then
            hiddenOrderManager = New HiddenField
        End If
    End Sub


    Protected Overrides Sub OnLoad(e As EventArgs)
        MyBase.OnLoad(e)
        '  Read current column order from file
        Dim fileOrder = GetColumnOrder()

        '  If CurrentColumnOrder is empty:  Set  hidden control and CurrentColumnOrder value to current column order from file 
        If String.IsNullOrEmpty(CurrentColumnOrder) Then
            hiddenOrderManager.Value = fileOrder
        Else
            '  ELSE  Compare CurrentColumnOrder against current column order from file
            '       if CurrentColumnOrder and column order from file are not the same, save CurrentColumnOrder to file and hidden control
            If CurrentColumnOrder <> fileOrder Then
                SaveColumnOrder()
            End If
        End If

    End Sub


    ''' <summary>
    ''' If Modal, this event will add a "select" link as the first column
    ''' </summary>
    ''' <param name="e"></param>
    Protected Overrides Sub OnRowDataBound(e As GridViewRowEventArgs)
        MyBase.OnRowDataBound(e)
        If IsModal Then
            If e.Row.RowType = DataControlRowType.DataRow Then

                For Each cell As TableCell In e.Row.Cells
                    If cell.Controls.Count > 0 Then
                        Dim lb As LinkButton = CType(cell.Controls(0), LinkButton)
                        If Not IsNothing(lb) Then
                            If lb.CommandName.ToLower() = "select" Then
                                cell.Controls.Clear()
                                Dim css As String = lb.CssClass
                                Dim button As LinkButton = New LinkButton()
                                If (String.IsNullOrEmpty(css)) Then
                                    button.CssClass = "btn glyphicon glyphicon-asterisk close"
                                Else
                                    button.CssClass = css
                                End If

                                button.OnClientClick = BuildSelectScript(e.Row.DataItem)
                                button.CommandName = "Select"
                                button.Attributes.Add("data-dismiss", "modal")
                                cell.Controls.Add(button)
                            End If
                        End If
                    End If
                Next


                'Dim cell As TableCell = e.Row.Cells(0)
                'cell.Controls.Clear()
                'Dim css As String = cell.CssClass

                'Dim button As LinkButton = New LinkButton()
                'If (String.IsNullOrEmpty(css)) Then
                '    button.CssClass = "btn glyphicon glyphicon-asterisk close"
                'Else
                '    button.CssClass = css
                'End If

                'button.OnClientClick = BuildSelectScript(e.Row.DataItem)
                'button.CommandName = "Select"
                'button.Attributes.Add("data-dismiss", "modal")
                'cell.Controls.Add(button)
            End If
        End If
    End Sub


    ''' <summary>
    ''' If modal, this event will hide edit and delete columns and display the "select" link
    ''' It will also set the grid to render with thead and tbody tags
    ''' </summary>
    ''' <param name="e"></param>
    Protected Overrides Sub OnPreRender(e As EventArgs)
        MyBase.OnPreRender(e)
        If IsModal Then
            HideEditDeleteColumns()
            ShowSelectColumn()
        End If
        'set the thead tag to be rendered (required by script)
        If (Not IsNothing(MyBase.HeaderRow)) Then
            MyBase.HeaderRow.TableSection = TableRowSection.TableHeader
        End If

    End Sub

    ''' <summary>
    ''' Renders Grid to Page
    ''' </summary>
    ''' <param name="writer"></param>
    Protected Overrides Sub RenderContents(writer As HtmlTextWriter)
        '  MyBase.Render Contents will render the entire grid
        MyBase.RenderContents(writer)

        ' add the hidden control that will capture the Order of the columns
        hiddenOrderManager.ID = $"hdn{Me.ClientID}"
        hiddenOrderManager.RenderControl(writer)

    End Sub

    ''' <summary>
    ''' This Event will append web resources to the page as well as a script block
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Overrides Sub OnPagePreLoad(sender As Object, e As EventArgs)
        MyBase.OnPagePreLoad(sender, e)
        Dim draggablekey As String = "draggableTable"

        Registrar.RegisterJavaScriptFile(Me.Page, Me.GetType(), Registrar.BaseJsFile)
        Registrar.RegisterJavaScriptBlob(Me.Page, draggablekey, BuildDraggableScript())
        Registrar.RegisterCssFile(Me.Page, Me.GetType(), Registrar.BaseCssFile)
    End Sub

#End Region

#Region "Private Methods"
    ''' <summary>
    ''' Hides edit and delete columns
    ''' </summary>
    Private Sub HideEditDeleteColumns()
        ' Loop through all the columns
        For counter As Integer = 0 To Columns.Count - 1
            ' if I find a command column check to see if it is an edit or delete column
            Dim column = Columns(counter)
            Dim columnName = column.GetType().Name

            If columnName = "CommandField" Then
                Dim deleteText = DirectCast(column, CommandField).AccessibleHeaderText
                Dim editText = DirectCast(column, CommandField).AccessibleHeaderText
                Dim virtualPath = Web.HttpContext.Current.Request.Url.LocalPath
                Dim deleteToken = Web.HttpContext.GetLocalResourceObject(virtualPath, "Btn_Delete.Text")
                Dim editToken = Web.HttpContext.GetLocalResourceObject(virtualPath, "Btn_Edit.Text")
                'if it is an edit or delete command button, hide it
                If deleteText = deleteToken Or
                    editText = editToken Then
                    column.Visible = False
                End If

            End If
        Next
    End Sub

    ''' <summary>
    ''' Shows select link
    ''' </summary>
    Private Sub ShowSelectColumn()
        ' Loop through all the columns
        For counter As Integer = 0 To Columns.Count - 1
            ' if I find a command column check to see if it is an edit or delete column
            Dim column = Columns(counter)
            Dim columnName = column.GetType().Name

            If columnName = "CommandField" Then
                Dim selectText = DirectCast(column, CommandField).AccessibleHeaderText
                Dim virtualPath = Web.HttpContext.Current.Request.Url.LocalPath
                Dim selectToken = Web.HttpContext.GetLocalResourceObject(virtualPath, "Btn_Select.Text")
                'if it is an edit or delete command button, show it
                'and change the onclick eventto the script we need to use
                If selectText = selectToken Then
                    column.Visible = True
                End If
            End If
        Next

    End Sub

    ''' <summary>
    ''' Builds script to be used by select link
    ''' </summary>
    ''' <param name="e"></param>
    ''' <returns></returns>
    Private Function BuildSelectScript(e As DataRowView)
        Dim id As String
        Dim onClickScript As String
        Try
            id = e(KeyNameUsedOnModal).ToString()

            onClickScript = $"eidssDropdownSelectItem('{ListId}','{id}', null);"

        Catch ex As Exception
            Throw New Exception("The Property KeyNameUsedOnModal was not set or the keyname was not found in the current DataRowView.  Set the proper keyname.")
        End Try

        Return onClickScript
    End Function

    ''' <summary>
    ''' Builds the draggable script
    ''' </summary>
    ''' <returns></returns>
    Private Function BuildDraggableScript() As String

        Dim sb As StringBuilder = New StringBuilder()

        sb.AppendLine("$(document).ready(function () {")
        sb.Append($"{vbTab}$(""#{Me.ClientID}"").dragtable({"{"}")
        sb.AppendLine($"{vbTab}{vbTab}{vbTab}stop:function(){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}{vbTab}{vbTab}$(""#hdn{Me.ClientID}"").val($(""#{Me.ClientID}"").dragtable('order'));")
        sb.AppendLine($"{vbTab}{vbTab}{vbTab}{"}"}")
        sb.AppendLine($"{vbTab}{vbTab}{"}"});")

        sb.AppendLine($"{vbTab}var order = $(""#hdn{Me.ClientID}"").val();")
        sb.AppendLine($"{vbTab}if (order != """"){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}$(""#{Me.ClientID}"").dragtable('order', [order])")
        sb.AppendLine($"{vbTab}{"}"}")
        'sb.Append($"{vbTab}$(""#hdn{Me.ClientID}"").val($(""#{Me.ClientID}"").dragtable('order'));")
        sb.AppendLine($"{vbTab}{"}"});")

        Return sb.ToString()

    End Function

    Private Sub SaveColumnOrder()
        Dim oUG As GridAndColumns = New GridAndColumns()
        With oUG
            .idOfGrid = Me.ID
            .columnorder = CurrentColumnOrder
        End With

        Dim oU As GridAndUser = New GridAndUser()
        With oU
            .userId = Web.HttpContext.Current.Session("UserID")
            .grid = New GridAndColumns() {oUG}
        End With


        Dim oGVCO As GridViewColumnOrder = New GridViewColumnOrder()
        With oGVCO
            .user = New GridAndUser() {oU}
        End With

        Dim oSerializer As XmlSerializer = New XmlSerializer(GetType(GridViewColumnOrder))
        Dim oWriter As StreamWriter

        Dim sFile As String = $"{ Web.HttpContext.Current.Server.MapPath("\") }App_Data\GridViewColumnOrderMapping.xml"

        If sFile <> "" Then
            oWriter = New StreamWriter(sFile)
            oSerializer.Serialize(oWriter, oGVCO)
            oWriter.Close()
            oWriter.Dispose()
        End If
    End Sub

    Private Function GetColumnOrder() As String
        Dim oGVCO As GridViewColumnOrder

        Dim oSerializer As XmlSerializer = New XmlSerializer(GetType(GridViewColumnOrder))
        Dim oFileStream As FileStream

        Dim sFile As String = $"{ Web.HttpContext.Current.Server.MapPath("\") }App_Data\GridViewColumnOrderMapping.xml"

        If sFile <> "" AndAlso File.Exists(sFile) Then
            oFileStream = New FileStream(sFile, FileMode.Open)
            oGVCO = oSerializer.Deserialize(oFileStream)

            Dim columnOrder As String = String.Empty
            Dim userid As String = Web.HttpContext.Current.Session("UserID")

            For Each user In oGVCO.user
                If user.userId = userid Then
                    For Each grid In user.grid
                        If grid.idOfGrid = Me.ID Then
                            columnOrder = grid.columnorder
                        End If
                    Next
                End If
            Next

            Return columnOrder
        Else
            Return String.Empty
        End If
    End Function
#End Region

End Class

