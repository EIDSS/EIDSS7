Imports System.Data
Imports System.Reflection
Imports System.Runtime.CompilerServices
Imports AjaxControlToolkit
Imports System.Web.UI.WebControls
Imports System.ComponentModel
Imports System.Collections.Generic
Imports System
Imports System.Web.UI
Imports System.Linq
Imports System.Text
Imports System.Web.UI.HtmlControls
Imports System.Text.RegularExpressions
Imports Microsoft.VisualBasic

Namespace EIDSS

    Public Module Extensions

        ' TODO:  Move to modCommon    
        Public Function ToType(Of T)(obj As Object, ByVal type As T) As Object
            'create instance of T type object:            
            Dim tmp = Activator.CreateInstance(System.Type.GetType(type.ToString))
            'loop through the properties of the object you want to covert:          
            For Each pi As PropertyInfo In obj.GetType.GetProperties
                Try
                    'get the value of property and try 
                    'to assign it to the property of T type object:
                    tmp.GetType.GetProperty(pi.Name).SetValue(tmp, pi.GetValue(obj, Nothing), Nothing)
                Catch ex As System.Exception

                End Try

            Next
            'return the T type object:         
            Return tmp
        End Function

        <System.Runtime.CompilerServices.Extension>
        Public Function ToNonAnonymousList(Of T)(list As List(Of T), ty As Type) As Object

            'define system Type representing List of objects of T type:
            Dim genericType = GetType(List(Of )).MakeGenericType(ty)

            'create an object instance of defined type:
            Dim l = Activator.CreateInstance(genericType)

            'get method Add from from the list:
            Dim addMethod As MethodInfo = l.[GetType]().GetMethod("Add")

            'loop through the calling list:
            For Each item As Object In list

                'convert each object of the list into T object 
                'by calling extension ToType<T>()
                'Add this object to newly created list:
                '  addMethod.Invoke(l, New Object() {item.ToType(ty)})   
                addMethod.Invoke(l, New Object() {ToType(item, ty)})
            Next

            'return List of T objects:
            Return l
        End Function

        <Extension()>
        Public Sub Populate(cbo As ComboBox, dt As DataTable, DataTextField As String, DataValueField As String)

            cbo.DataSource = dt
            cbo.DataTextField = DataTextField
            cbo.DataValueField = DataValueField
            cbo.DataBind()

        End Sub

        <Extension()>
        Public Sub Populate(ddl As DropDownList,
                            dt As DataTable,
                            DataTextField As String,
                            DataValueField As String,
                            Optional CurrentValue As String = Nothing,
                            Optional CurrentText As String = Nothing,
                            Optional AddEmptyItem As Boolean = False)

            ddl.DataSource = dt
            ddl.DataTextField = DataTextField
            ddl.DataValueField = DataValueField
            Try
                ddl.DataBind()
            Catch ex As Exception

            End Try

            If AddEmptyItem Then ddl.Items.Insert(0, New ListItem("", "null"))

            Try

                If CurrentValue Is Nothing Then
                    If CurrentText Is Nothing Then
                        ddl.SelectedIndex = 0
                    Else
                        ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByText(CurrentText))
                    End If
                Else
                    ddl.SelectedValue = CurrentValue
                End If

            Catch ex As Exception

            End Try

        End Sub

        <Extension()>
        Public Function NonLiteralControl(ByRef cellControls As ControlCollection _
                                         , ByVal index As Long) As Control
            Dim count As Long
            For Each ctl In cellControls
                If Not ctl.GetType() Is (New LiteralControl).GetType Then
                    If count = index Then Return ctl
                    count += 1
                End If
            Next
            Return Nothing
        End Function

        <Extension()>
        Public Sub Deactivate(ByVal controls As ControlCollection)
            If Not controls Is Nothing Then
                For Each c As Control In controls
                    Try

                        If TypeOf c Is TextBox Then
                            If c.Visible Then DirectCast(c, TextBox).Deactivate()
                        ElseIf TypeOf c Is CheckBox Then
                            DirectCast(c, CheckBox).Enabled = False
                        ElseIf TypeOf c Is CheckBoxList Then
                            For Each item In DirectCast(c, CheckBoxList).Items
                                DirectCast(item, ListItem).Enabled = False
                            Next
                        ElseIf TypeOf c Is RadioButton Then
                            DirectCast(c, RadioButton).Enabled = False
                        ElseIf TypeOf c Is RadioButtonList Then
                            For Each item In DirectCast(c, RadioButtonList).Items
                                DirectCast(item, ListItem).Enabled = False
                            Next
                        ElseIf TypeOf c Is DropDownList Then
                            With DirectCast(c, DropDownList)
                                If .Visible Then
                                    '.ToReadOnlyTextBox(c.ID & Guid.NewGuid.ToString, WidthOfText(.SelectedItem.Text, "Arial", 10))
                                    ' Control collection changed so start over at parent and exit for
                                    'c.Parent.Controls.Deactivate()
                                    .Enabled = False
                                    'Exit For
                                End If
                            End With

                        ElseIf TypeOf c Is Button Then
                            DirectCast(c, Button).Enabled = False
                        ElseIf TypeOf c Is ImageButton Then
                            DirectCast(c, ImageButton).Enabled = False
                        ElseIf TypeOf c Is LinkButton Then
                            With DirectCast(c, LinkButton)
                                If .Visible Then
                                    .Enabled = False
                                    .Visible = False
                                    Dim newLink As New HtmlAnchor With {
                                        .HRef = "javascript:void(null);"
                                    }
                                    newLink.InnerText = .Text

                                    c.Parent.Controls.AddAt(c.Parent.Controls.IndexOf(c) + 1, newLink)

                                    ' Control collection changed so start over and exit for
                                    c.Parent.Controls.Deactivate()
                                    Exit For
                                End If
                            End With
                        ElseIf c.HasControls Then
                            ' Recurse through child controls
                            c.Controls.Deactivate()
                        End If
                    Catch ex As Exception

                    End Try

                Next
            End If

        End Sub

        <Extension()>
        Public Sub Activate(ByVal controls As ControlCollection)
            If Not controls Is Nothing Then
                For Each c As Control In controls
                    Try

                        If TypeOf c Is TextBox Then
                            If c.Visible Then DirectCast(c, TextBox).Activate()
                        ElseIf TypeOf c Is CheckBox Then
                            DirectCast(c, CheckBox).Enabled = True
                        ElseIf TypeOf c Is CheckBoxList Then
                            For Each item In DirectCast(c, CheckBoxList).Items
                                DirectCast(item, ListItem).Enabled = True
                            Next
                        ElseIf TypeOf c Is RadioButton Then
                            DirectCast(c, RadioButton).Enabled = True
                        ElseIf TypeOf c Is RadioButtonList Then
                            For Each item In DirectCast(c, RadioButtonList).Items
                                DirectCast(item, ListItem).Enabled = True
                            Next
                        ElseIf TypeOf c Is DropDownList Then
                            With DirectCast(c, DropDownList)
                                If .Visible Then
                                    '.ToReadOnlyTextBox(c.ID & Guid.NewGuid.ToString, WidthOfText(.SelectedItem.Text, "Arial", 10))
                                    ' Control collection changed so start over at parent and exit for
                                    'c.Parent.Controls.Deactivate()
                                    .Enabled = True
                                    'Exit For
                                End If
                            End With

                        ElseIf TypeOf c Is Button Then
                            DirectCast(c, Button).Enabled = True
                        ElseIf TypeOf c Is ImageButton Then
                            DirectCast(c, ImageButton).Enabled = True
                        ElseIf TypeOf c Is LinkButton Then
                            With DirectCast(c, LinkButton)
                                If .Visible Then
                                    .Enabled = True
                                    .Visible = True
                                    Dim newLink As New HtmlAnchor With {
                                        .HRef = "javascript:void(null);"
                                    }
                                    newLink.InnerText = .Text

                                    c.Parent.Controls.AddAt(c.Parent.Controls.IndexOf(c) + 1, newLink)

                                    ' Control collection changed so start over and exit for
                                    c.Parent.Controls.Activate()
                                    Exit For
                                End If
                            End With
                        ElseIf c.HasControls Then
                            ' Recurse through child controls
                            c.Controls.Activate()
                        End If
                    Catch ex As Exception

                    End Try

                Next
            End If

        End Sub

        <Extension()>
        Public Sub Deactivate(ByRef control As WebControls.TextBox)
            Try
                control.ReadOnly = True
                control.BackColor = System.Drawing.Color.LightGray
                Try
                    control.ToolTip = If(control.ToolTip.Trim <> "" AndAlso control.ToolTip.IndexOf("ReadOnly", StringComparison.OrdinalIgnoreCase) = -1, control.ToolTip.Trim & " ReadOnly", control.ToolTip)
                Catch ex As Exception
                End Try

            Catch ex As Exception
            End Try
        End Sub

        <Extension()>
        Public Sub Activate(ByRef control As WebControls.TextBox)
            Try
                control.ReadOnly = False
                control.BackColor = System.Drawing.Color.White
                control.ToolTip = If(control.ToolTip.Trim <> "" AndAlso control.ToolTip.IndexOf("ReadOnly", StringComparison.OrdinalIgnoreCase) > -1, control.ToolTip.Trim.Replace(" ReadOnly", ""), control.ToolTip)
            Catch ex As Exception
            End Try
        End Sub

        <Extension()>
        Public Sub Deactivate(ByRef control As LinkButton)
            If control.Visible Then
                control.Enabled = False
                'control.Visible = False
                'Dim newLink As New HtmlAnchor
                'newLink.HRef = "javascript:void(null);"
                'newLink.InnerText = control.Text

                'control.Parent.Controls.AddAt(control.Parent.Controls.IndexOf(control) + 1, newLink)
            End If

        End Sub

        ''' <summary>Finds a first parent of control with a specified type</summary>
        <Extension()>
        Public Function FindImmediateParentOfType(Of T As Control)(control As Control) As T
            Dim retVal As T = Nothing
            Dim parentCtl As Control = control.Parent
            While parentCtl IsNot Nothing
                If TypeOf parentCtl Is T Then
                    retVal = DirectCast(parentCtl, T)
                    Exit While
                Else
                    parentCtl = parentCtl.Parent
                End If
            End While
            Return retVal

        End Function

        <Extension()>
        Public Function FindImmediateParentOfTag(tag As String, control As Control) As Control

            Dim ctrl As HtmlGenericControl = Nothing
            While control IsNot Nothing
                ctrl = TryCast(control, HtmlGenericControl)

                If ctrl IsNot Nothing Then
                    If ctrl.TagName = tag Then
                        Return ctrl
                    End If
                End If

                If control.Parent IsNot Nothing Then
                    control = control.Parent
                Else
                    control = Nothing
                End If
            End While

            Return Nothing

        End Function

        ''' <summary>
        ''' Hides &amp; Disables a DropDownList and shows a 
        ''' Read Only TextBox in it's place (for Section 508 compliance).
        ''' </summary>
        ''' <param name="ddl">DropDownList control you wish to disable.</param>
        ''' <param name="width">Width of new TextBox control in pixels, optional (default=100).</param>
        <Extension()>
        Public Sub ToReadOnlyTextBox(ByRef ddl As WebControls.DropDownList _
                                    , ByVal id As String _
                                    , Optional ByVal width As Long = 100)

            ' Prevent duplicates in event sub is called twice for same control
            'If Not ddl.Visible Then Exit Sub 'we don't need to deal with non-visible controls

            If ddl.Parent.FindControl(id) Is Nothing Then
                ' Instantiate new control and set properties
                Dim tb As New TextBox With {
                    .ID = id
                }
                tb.Deactivate()
                Dim sourceDropDownList As DropDownList = ddl
                tb.Text = sourceDropDownList.SelectedItem.Text
                ' Grab the old tooltip and replace old text control type name with "Text Box"
                tb.ToolTip = New Regex("^[ ]*(?:label|drop {0,1}down {0,1}list {0,1}(?:choose|select)|drop {0,1}down(?: {0,1}(?:list|select)|)|radio {0,1}button {0,1}(?:list {0,1}choose|choose|list|)|combo {0,1}box|combo)(.*)$", RegexOptions.IgnoreCase).Replace(ddl.ToolTip, "Text Box$1 Read Only") ' Regex pattern is ready for use on other control types
                tb.Width = width
                ddl.Parent.Controls.AddAt(ddl.Parent.Controls.IndexOf(ddl) + 1, tb) ' caused old control's value not to pass without +1

                ' Disable/Hide DDL
                ddl.Visible = False
                ddl.Enabled = False

            End If
        End Sub

        <Extension()>
        Public Sub SetDefaultButton(ByRef tb As TextBox _
                                   , ByVal defaultButton As Button)
            ResetDefaultButton(tb, defaultButton)
        End Sub

        <Extension()>
        Public Sub SetDefaultButton(ByRef btn As Button _
                                   , ByVal defaultButton As Button)
            ResetDefaultButton(btn, defaultButton)
        End Sub

        <Extension()>
        Public Sub SetDefaultButton(ByRef cb As CheckBox _
                                   , ByVal defaultButton As Button)
            ResetDefaultButton(cb, defaultButton)
        End Sub

        <Extension()>
        Public Sub SetDefaultButton(ByRef ddl As DropDownList _
                                   , ByVal defaultButton As Button)
            ResetDefaultButton(ddl, defaultButton)
        End Sub

        <Extension()>
        Public Sub SetDefaultButton(ByRef controls As ControlCollection _
                                   , ByVal defaultButton As Button)

            If Not controls Is Nothing Then
                For Each c As Control In controls
                    If TypeOf c Is TextBox _
                                OrElse TypeOf c Is CheckBox _
                                OrElse TypeOf c Is RadioButton Then
                        ResetDefaultButton(c, defaultButton)
                    ElseIf TypeOf c Is RadioButtonList Then
                        For Each item In DirectCast(c, RadioButtonList).Items
                            ResetDefaultButton(DirectCast(item, ListItem), defaultButton)
                        Next

                    ElseIf c.HasControls Then
                        ' Recurse through child controls
                        c.Controls.SetDefaultButton(defaultButton)
                    End If

                Next
            End If

        End Sub

        <Extension()>
        Public Sub Disable(ByRef controls As ControlCollection)

            If Not controls Is Nothing Then
                For Each c As Control In controls
                    If TypeOf c Is TextBox Then
                        DirectCast(c, TextBox).Enabled = False
                    ElseIf TypeOf c Is CheckBox Then
                        DirectCast(c, CheckBox).Enabled = False
                    ElseIf TypeOf c Is RadioButton Then
                        DirectCast(c, RadioButton).Enabled = False
                    ElseIf TypeOf c Is RadioButtonList Then
                        For Each item In DirectCast(c, RadioButtonList).Items
                            DirectCast(item, ListItem).Enabled = False
                        Next
                    ElseIf TypeOf c Is DropDownList Then
                        DirectCast(c, DropDownList).Enabled = False
                    ElseIf TypeOf c Is Button Then
                        DirectCast(c, Button).Enabled = False
                    ElseIf TypeOf c Is ImageButton Then
                        DirectCast(c, ImageButton).Enabled = False
                    ElseIf TypeOf c Is LinkButton Then
                        DirectCast(c, LinkButton).Enabled = False
                    ElseIf c.HasControls Then
                        ' Recurse through child controls
                        c.Controls.Disable()
                    End If

                Next
            End If

        End Sub

        Private Sub ResetDefaultButton(ByVal o As Object _
                                      , ByVal defaultbutton As Button)
            Try
                o.Attributes.Remove("OnKeyPress")
                o.Attributes.Add("OnKeyPress", "return clickButton(event,'" + defaultbutton.ClientID + "')")
            Catch ex As Exception
                ASPNETMsgBox("Failed to set default button")
            End Try

        End Sub

        <Extension()>
        Public Sub SetActiveNavLink(ByRef master As MasterPage _
                                   , ByVal LinkId As String)
            Try
                'Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "HighligtNavLink", strClientScript.ToString)
                Dim objPH As New ContentPlaceHolder
                'reference local PlaceHolder object as the head's PlaceHolder
                objPH = master.FindControl("headerPlaceHolder")

                'if we were able to reference the head's PlaceHolder ...
                If Not objPH Is Nothing Then
                    'create a string for the inner HTML of the script
                    Dim sbScript As New StringBuilder
                    ' add contents of the script (do not include <script> tags)
                    sbScript.Append("setActiveNavLink('" & LinkId.Replace(" ", "_") & "')")
                    'create script control
                    Dim objScript As New HtmlGenericControl("script")
                    'add javascript type
                    objScript.Attributes.Add("type", "text/javascript")
                    'set innerHTML to be our StringBuilder string
                    objScript.InnerHtml = sbScript.ToString()
                    'add script to PlaceHolder control
                    objPH.Controls.Add(objScript)
                End If

            Catch ex As Exception

            End Try
        End Sub

        <Extension()>
        Public Function ReadAll(ByVal memStream As IO.MemoryStream) As String
            ' Reset the stream otherwise you will just get an empty string.
            ' Remember the position so we can restore it later.
            Dim pos = memStream.Position
            memStream.Position = 0

            Dim reader As New IO.StreamReader(memStream)
            Dim str = reader.ReadToEnd()

            ' Reset the position so that subsequent writes are correct.
            memStream.Position = pos

            Return str
        End Function

        <Extension>
        Public Sub SelectItem(ByVal lstItm As ListItem)

            Try
                If (lstItm IsNot Nothing) Then lstItm.Selected = True
            Catch ex As Exception

            End Try

        End Sub

        <Extension()>
        Function GetSelectedItems(ByVal items As ListItemCollection) As IEnumerable(Of ListItem)
            Return items.OfType(Of ListItem)().Where(Function(item) item.Selected)
        End Function

    End Module

    Public Module DataTableReaderExtensions

        <Extension()>
        Public Sub RemoveColumns(ByRef dr As DataTableReader _
                                , ByVal columnNames() As String)

            Dim schemaTable As DataTable = dr.GetSchemaTable
            Dim dataTable As New DataTable
            Dim intCounter As Integer

            For intCounter = 0 To schemaTable.Rows.Count - 1
                Dim dataRow As DataRow = schemaTable.Rows(intCounter)
                Dim columnName As String = CType(dataRow("ColumnName"), String)
                If Array.IndexOf(columnNames, columnName) = -1 Then
                    Dim column As DataColumn = New DataColumn(columnName,
                       CType(dataRow("DataType"), Type))
                    dataTable.Columns.Add(column)
                End If
            Next

            While dr.Read()
                Dim dataRow As DataRow = dataTable.NewRow()
                For intCounter = 0 To dr.FieldCount - 1
                    dataRow(intCounter) = dr.GetValue(intCounter)
                Next
                dataTable.Rows.Add(dataRow)
            End While
            dr = dataTable.CreateDataReader
        End Sub
    End Module

End Namespace

Public Module GlobalExtensions

    <Extension()>
    Public Function EqualsAny(ByVal s As String _
                             , ByVal strings() As String _
                             , Optional ByVal comparisonType As StringComparison = StringComparison.OrdinalIgnoreCase) As Boolean
        Try
            For Each token In strings
                If token.Equals(s, comparisonType) Then Return True
            Next
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function

    <Extension()>
    Private Function EqualsAny(ByVal s As String _
                              , ByVal strings As System.Collections.Generic.IEnumerable(Of String) _
                              , Optional ByVal comparisonType As StringComparison = StringComparison.OrdinalIgnoreCase) As Boolean
        Try
            For Each token In strings
                If token.Equals(s, comparisonType) Then Return True
            Next
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function

    <Extension()>
    Public Function AnyEquals(ByVal s As String() _
                             , ByVal find As String _
                             , Optional ByVal comparisonType As StringComparison = StringComparison.OrdinalIgnoreCase) As Boolean
        Try
            For Each stringText In s
                Return stringText.Equals(find, comparisonType)
            Next
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function

    ''' <summary>
    ''' Adds overload that gives ability to ignore case when using .Replace()
    ''' </summary>
    ''' <param name="original"></param>
    ''' <param name="oldValue"></param>
    ''' <param name="newValue"></param>
    ''' <param name="comparisonType"></param>
    ''' <returns></returns>
    ''' <remarks>http://weblogs.asp.net/jgalloway/archive/2004/02/11/71188.aspx</remarks>
    <Extension()>
    Public Function Replace(ByVal original As String _
                           , ByVal oldValue As String _
                           , ByVal newValue As String _
                           , ByVal comparisonType As StringComparison) As String
        If original Is Nothing Then
            Return Nothing
        End If

        If [String].IsNullOrEmpty(oldValue) Then
            Return original
        End If

        Dim lenPattern As Integer = oldValue.Length
        Dim idxPattern As Integer = -1
        Dim idxLast As Integer = 0
        Dim result As New StringBuilder()

        While True
            idxPattern = original.IndexOf(oldValue, idxPattern + 1, comparisonType)
            If idxPattern < 0 Then
                result.Append(original, idxLast, original.Length - idxLast)
                Exit While
            End If

            result.Append(original, idxLast, idxPattern - idxLast)
            result.Append(newValue)
            idxLast = idxPattern + lenPattern
        End While

        Return result.ToString()
    End Function

    <Extension()>
    Public Function ReplaceAll(ByVal original As String _
                               , ByVal oldValue() As String _
                               , ByVal newValue() As String _
                               , ByVal comparisonType As StringComparison) As String

        If original Is Nothing Then
            Return original
        End If

        If oldValue.Count <> newValue.Count Then
            Return original
        End If

        Try
            For iCount As Integer = 0 To oldValue.Count - 1
                original = original.Replace(oldValue(iCount), newValue(iCount), comparisonType)
            Next
        Catch ex As Exception
            Return original
        End Try

        Return original.ToString()

    End Function

    ''' <summary>
    ''' Returns Int16 value of string.  Non numeric text will return 0.
    ''' </summary>
    <Extension()>
    Public Function ToInt16(ByVal value As String) As Long
        Dim result As Int16 = 0

        If Not String.IsNullOrEmpty(value) Then
            Int16.TryParse(value, result)
        End If

        Return result
    End Function

    <Extension()>
    Public Function ToInt32(ByVal value As String) As Long
        Dim result As Int32 = 0

        If Not String.IsNullOrEmpty(value) Then
            Int32.TryParse(value, result)
        End If

        Return result
    End Function

    <Extension()>
    Public Function ToInt64(ByVal value As String) As Long
        Dim result As Int64 = 0

        If Not String.IsNullOrEmpty(value) Then
            Int64.TryParse(value, result)
        End If

        Return result
    End Function

    <Extension()>
    Public Function ToDecimal(ByVal value As String) As Decimal
        Dim result As Decimal = 0
        If Not String.IsNullOrEmpty(value) Then
            Decimal.TryParse(value, result)
        End If
        Return result
    End Function

    ''' <summary>
    ''' Checks to see if the value = "" or value = "null".
    ''' </summary>
    <Extension()>
    Public Function IsValueNullOrEmpty(ByVal value As String) As Boolean

        Return (String.IsNullOrWhiteSpace(value) OrElse (value.ToString().ToUpper() = "NULL"))

    End Function

    ''' <summary>
    ''' Checks if number is evenly devisible by another number.
    ''' </summary>
    ''' <returns>True if evenly devisible.</returns>
    ''' <remarks>Created 6/12/2012 for FY13 budget</remarks>
    <Extension()>
    Public Function IsDivisibleBy(val As Decimal _
                                 , number As Decimal) As Boolean
        If val Mod number = 0 Then Return True
        Return False
    End Function

    <Extension()>
    Public Sub SelectTextClientSide(ByVal textbox As TextBox)
        textbox.Focus()
        Dim strScript As String = "document.getElementById('" & textbox.ClientID & "').select();"
        Dim oGUID As Guid = Guid.NewGuid()
        ScriptManager.RegisterStartupScript(textbox, textbox.Page.GetType, oGUID.ToString(), strScript, True)
    End Sub

    <Extension()>
    Public Function CheckDataSet(_ds As DataSet) As Boolean

        CheckDataSet = ((Not _ds Is Nothing) AndAlso _ds.Tables.Count > 0 AndAlso _ds.Tables(_ds.Tables.Count - 1).Rows.Count > 0)

        If CheckDataSet Then
            'Check to see if the dataset last table, first row and second column is not an error message
            'When DB errors out, error message is sent out to caller as a dataset

            Dim sRetVal As String = ""
            Dim tlb As DataTable = _ds.Tables(_ds.Tables.Count - 1)
            Dim dataRow As DataRow = tlb.Rows(0)

            'Fix until all SP are following the standards
            sRetVal = ""
            For iColCount As Integer = 0 To (dataRow.ItemArray.Length - 1)
                If iColCount = 2 Then Exit For
                sRetVal &= IIf(sRetVal = "", "", ";") & dataRow.Item(iColCount).ToString()
            Next

            If (sRetVal.IndexOf("Error") <> -1) Then
                CheckDataSet = False
                Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, sRetVal)
            End If

        End If

        Return CheckDataSet

    End Function

    <Extension()>
    Public Function CheckDataTable(_dt As DataTable) As Boolean

        CheckDataTable = ((Not _dt Is Nothing) AndAlso _dt.Rows.Count > 0)

        Return CheckDataTable

    End Function

    <Extension>
    Public Sub SelectText(txt As TextBox)
        If (ScriptManager.GetCurrent(txt.Page) Is Nothing And ScriptManager.GetCurrent(txt.Page).IsInAsyncPostBack) Then
            ScriptManager.RegisterStartupScript(txt.Page,
                                txt.Page.GetType(),
                                "SetFocusInUpdatePanel-" + txt.ClientID,
                                String.Format("ctrlToSelect='{0}';", txt.ClientID),
                                True)
        Else
            txt.Page.ClientScript.RegisterStartupScript(txt.Page.GetType(),
                                      "Select-" + txt.ClientID,
                                      String.Format("document.getElementById('{0}').select();", txt.ClientID),
                                      True)
        End If
    End Sub

    <Extension>
    Public Sub RemoveAt(Of T)(ByRef a() As T, ByVal index As Integer)
        ' Move elements after "index" down 1 position.
        Array.Copy(a, index + 1, a, index, UBound(a) - index)
        ' Shorten by 1 element.
        ReDim Preserve a(UBound(a) - 1)
    End Sub

    <Extension>
    Public Function TextSize(ByVal tb As TextBox) As Boolean
        Return tb.Text.Trim().Length > 0
    End Function

    <Extension>
    Public Sub ToggleControlVisibility(ByRef ctrl As Control, Optional ByVal bHide As Boolean = True)

        If ctrl.Visible Then ctrl.Visible = bHide

    End Sub

    <Extension>
    Public Function GetFileName(ByRef sFullNameWithExtension As String) As String

        If (Not sFullNameWithExtension.IsValueNullOrEmpty()) AndAlso (sFullNameWithExtension.LastIndexOf(".") <> -1) Then
            Return sFullNameWithExtension.Substring(0, sFullNameWithExtension.LastIndexOf("."))
        Else
            Return sFullNameWithExtension
        End If

    End Function

    <Extension()>
    Public Function GetProperties(ByVal [me] As Object) As List(Of KeyValuePair(Of String, Object))
        Dim result As List(Of KeyValuePair(Of String, Object)) = New List(Of KeyValuePair(Of String, Object))()

        For Each [property] In [me].[GetType]().GetProperties()
            result.Add(New KeyValuePair(Of String, Object)([property].Name, [property].GetValue([me])))
        Next

        Return result
    End Function

End Module

Public Module GridviewExtensions
    Public Class GridViewExtended
        Inherits GridView

        Private _footerRow As GridViewRow

        <DefaultValue(False), Category("Appearance"), Description("Include the footer when the table is empty")>
        Property ShowFooterWhenEmpty As Boolean

        <DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden), Browsable(False)>
        Public Overrides ReadOnly Property FooterRow As GridViewRow
            Get
                If (Me._footerRow Is Nothing) Then
                    Me.EnsureChildControls()
                End If
                Return Me._footerRow
            End Get
        End Property

        Protected Overrides Function CreateChildControls(ByVal dataSource As System.Collections.IEnumerable, ByVal dataBinding As Boolean) As Integer
            Dim returnVal As Integer = MyBase.CreateChildControls(dataSource, dataBinding)
            If returnVal = 0 AndAlso Me.ShowFooterWhenEmpty Then
                Dim table As Table = Me.Controls.OfType(Of Table)().First
                Me._footerRow = Me.CreateRow(-1, -1, DataControlRowType.Footer, DataControlRowState.Normal, dataBinding, Nothing, Me.Columns.Cast(Of DataControlField).ToArray, table.Rows, Nothing)
                If Not Me.ShowFooter Then
                    _footerRow.Visible = False
                End If
            End If
            Return returnVal
        End Function

        Private Overloads Function CreateRow(ByVal rowIndex As Integer, ByVal dataSourceIndex As Integer, ByVal rowType As DataControlRowType, ByVal rowState As DataControlRowState, ByVal dataBind As Boolean, ByVal dataItem As Object, ByVal fields As DataControlField(), ByVal rows As TableRowCollection, ByVal pagedDataSource As PagedDataSource) As GridViewRow
            Dim row As GridViewRow = Me.CreateRow(rowIndex, dataSourceIndex, rowType, rowState)
            Dim e As New GridViewRowEventArgs(row)
            If (rowType <> DataControlRowType.Pager) Then
                Me.InitializeRow(row, fields)
            Else
                Me.InitializePager(row, fields.Length, pagedDataSource)
            End If
            If dataBind Then
                row.DataItem = dataItem
            End If
            Me.OnRowCreated(e)
            rows.Add(row)
            If dataBind Then
                row.DataBind()
                Me.OnRowDataBound(e)
                row.DataItem = Nothing
            End If
            Return row
        End Function

    End Class
End Module
