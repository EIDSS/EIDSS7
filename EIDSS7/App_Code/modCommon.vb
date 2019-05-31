Imports System
Imports System.Collections.Generic
Imports System.Reflection
Imports System.Text
Imports Microsoft.VisualBasic
Imports System.Web
Imports System.Web.UI.WebControls
Imports System.Web.UI
Imports System.Data
Imports EIDSS.EIDSS
Imports EIDSS.NG
Imports System.Collections
Imports System.Security.Policy
Imports System.Globalization
Imports System.Threading

Public Module modCommon

    Public Function GetPropertyList(poco As Type) As List(Of String)

        Dim result As List(Of String) = New List(Of String)

        For Each pi As PropertyInfo In poco.GetProperties
            result.Add(pi.Name)
        Next

        Return result

    End Function

    Public Function POCOToParams(Of T)(poco As T, toInterface As Type) As String

        Dim params As String = ""

        For Each iProp As PropertyInfo In toInterface.GetProperties

            For Each pi As PropertyInfo In poco.GetType.GetProperties
                Try
                    If iProp.Name = pi.Name Then
                        params += $"{pi.Name}={pi.GetValue(poco)}|"
                    End If
                Catch ex As System.Exception

                End Try
            Next
        Next

        params = params.Substring(0, params.Length - 1)

        Return params

    End Function

    Public Function DataTableToList(Of T)(dt As DataTable) As List(Of T)
        Dim data As New List(Of T)()
        For Each row As DataRow In dt.Rows
            Dim item As T = GetItem(Of T)(row)
            data.Add(item)
        Next
        Return data
    End Function

    Public Function GetItem(Of T)(dr As DataRow) As T
        Dim temp As Type = GetType(T)
        Dim obj As T = Activator.CreateInstance(Of T)()

        For Each column As DataColumn In dr.Table.Columns
            For Each pro As PropertyInfo In temp.GetProperties()
                If pro.Name = column.ColumnName Then
                    pro.SetValue(obj, dr(column.ColumnName), Nothing)
                Else
                    Continue For
                End If
            Next
        Next
        Return obj
    End Function

    Public Enum SimpleTypes
        [String]
        Int64
    End Enum

    Public Class QuickColumn
        Public Name As String
        Public Type As SimpleTypes

    End Class

    Public Function CreateDT(columns() As QuickColumn) As DataTable

        Dim dt As DataTable = New DataTable()

        For Each column As QuickColumn In columns
            dt.Columns.Add(New DataColumn(column.Name, Type.GetType($"System.{column.Type.ToString()}")))
        Next

        Return dt

    End Function

    Public Function GetCurrentLanguage() As String

        Dim cookie As HttpCookie = HttpContext.Current.Request.Cookies("CultureInfo")

        If (cookie Is Nothing OrElse cookie.Value.IsValueNullOrEmpty()) Then
            'en-US
            Return "en"
        Else
            Return cookie.Value.Split("-")(0)
        End If

    End Function

    Public Function GetCurrentCountry() As String

        Return getConfigValue("CountryCode")

        'TODO - MD: return country code based on the selected language from the list
        Dim cookie As HttpCookie = HttpContext.Current.Request.Cookies("CultureInfo")

        If (cookie Is Nothing OrElse cookie.Value.IsValueNullOrEmpty()) Then
            'en-US
            Return "US"
        Else
            Return cookie.Value.Split("-")(1)
        End If

    End Function

    Public Function getConfigValue(ByVal _Key As String,
                                   Optional ByVal sDefault As String = "") As String

        getConfigValue = ""
        getConfigValue = System.Configuration.ConfigurationManager.AppSettings.Get(_Key)
        If getConfigValue.IsValueNullOrEmpty() Then getConfigValue = sDefault
        If _Key.ToUpper() = "LANGUAGE" Then getConfigValue = getConfigValue.Split("-")(0)


    End Function

    Public Function GetLanguageParameter() As String

        Dim KeyValPair As New List(Of clsCommon.Param)
        Dim params As String = String.Empty
        Dim oComm As clsCommon = New clsCommon

        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
        params = oComm.KeyValPairToString(KeyValPair)

        Return params

    End Function

    Public Function getConnectionString(_Key As String) As String

        getConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings(_Key).ConnectionString()

    End Function

    Public Sub ASPNETMsgBox(ByVal messageIn As String, Optional ByVal returnURL As String = "")

        If messageIn Is Nothing Then Exit Sub
        Dim messageOut As New StringBuilder

        messageIn = messageIn.Replace("\", "\\").Replace("'", """").Replace("""", " \ """).Replace(vbCrLf, " \ r \ n").Replace(vbCr, "\r").Replace(vbLf, "\n").Replace(vbFormFeed, "\f")

        messageOut.AppendLine($"<script type=""text/javascript"">")
        messageOut.AppendLine($"alert('{messageIn}');")
        If returnURL <> "" Then
            messageOut.AppendLine($"window.location.href='{returnURL}';")
        End If
        messageOut.AppendLine("</script>")

        Dim page As Page = CType(HttpContext.Current.Handler, Page)
        page.Header.Controls.Add(New LiteralControl(messageOut.ToString()))

        ScriptManager.RegisterClientScriptBlock(page, page.GetType(), "ErrorModalScript", messageOut.ToString(), False)

    End Sub

    <System.Runtime.CompilerServices.Extension()>
    Public Sub Redirect(ByVal response As Net.HttpWebResponse,
                        ByVal url As String, ByVal target As String,
                        ByVal windowFeatures As String)

        If String.IsNullOrEmpty(target) Or
           target.Equals("_self", StringComparison.OrdinalIgnoreCase) And
           String.IsNullOrEmpty(windowFeatures) Then
            response.Redirect(url, target, windowFeatures)
        Else
            Dim page As Page = CType(HttpContext.Current.Handler, Page)
            If page Is Nothing Then
                Throw New InvalidOperationException("Cannot redirect to new window outside Page context.")
            End If
            url = page.ResolveClientUrl(url)
            Dim script As String
            If String.IsNullOrEmpty(windowFeatures) Then
                script = "window.open(""{0}"", ""{1}"", ""{2}"";"
            Else
                script = "window.open(""{0}"", ""{1}"");"
            End If
            script = String.Format(script, url, target, windowFeatures)
            ScriptManager.RegisterStartupScript(page, GetType(Page), "Redirect", script, True)

        End If
    End Sub

    Public Sub BindToEnum(ByVal enumType As Type, ByVal lc As ListControl)

        ' get the names from the enumeration
        Dim names As String() = [Enum].GetNames(enumType)
        ' get the values from the enumeration
        Dim values As Array = [Enum].GetValues(enumType)
        ' turn it into a hash table
        Dim ht As New Hashtable()
        For i As Integer = 0 To names.Length - 1
            ' note the cast to integer here is important
            ' otherwise we'll just get the enum string back again
            ht.Add(names(i), CInt(values.GetValue(i)))
        Next
        ' return the dictionary to be bound to
        lc.DataSource = ht
        lc.DataTextField = "Key"
        lc.DataValueField = "Value"
        lc.DataBind()

    End Sub

    Public Sub FillOrganizationList(Ctrl As DropDownList,
                                  Optional CurrentValue As String = Nothing,
                                  Optional CurrentText As String = Nothing,
                                  Optional AddBlankRow As Boolean = False)

        Dim oDS As DataSet
        Dim oOrganization As New clsOrganization

        oDS = oOrganization.ListAll()

        If oDS.CheckDataSet() Then
            Ctrl.Populate(oDS.Tables(0),
                          OrganizationConstants.OrgName,
                          OrganizationConstants.idfInstitution,
                          CurrentValue,
                          CurrentText,
                          AddBlankRow)
        End If

    End Sub

    Public Sub FillHumanOrganizationList(Ctrl As DropDownList,
                                  Optional CurrentValue As String = Nothing,
                                  Optional CurrentText As String = Nothing,
                                  Optional AddBlankRow As Boolean = False)

        Dim oDS As DataSet
        Dim oOrganization As New clsOrganization

        oDS = oOrganization.ListAll()
        Dim filterView As DataView = New DataView(oDS.Tables(0))
        filterView.RowFilter = "blnHuman = 'True'"

        Dim filteredTable As DataTable = filterView.ToTable
        filteredTable.TableName = "HumanOrganizations"

        'Add new filtered table
        oDS.Tables.Add(filteredTable)

        If oDS.CheckDataSet() Then
            Ctrl.Populate(oDS.Tables("HumanOrganizations"),
                          OrganizationConstants.OrgName,
                          OrganizationConstants.idfInstitution,
                          CurrentValue,
                          CurrentText,
                          AddBlankRow)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Ctrl">Target Dropdownlist</param>
    ''' <param name="eidssType">EIDSS.IEDSSEntity that controls or holds the data</param>
    ''' <param name="FilterKey">Filter key value</param>
    ''' <param name="ValueColumnName">Column with values for SelectedItem.Value</param>
    ''' <param name="DisplayColumnName">Column with values for SelectedItem.Text</param>
    ''' <param name="CurrentValue">Value to set the dropdown to once populated</param>
    ''' <param name="CurrentText">Text to set the dropdown to once populated</param>
    ''' <param name="AddBlankRow">Add an empty row to the top of the list dropdown items</param>
    Public Sub FillDropDown(Ctrl As DropDownList,
                            eidssType As Type,
                            FilterKey() As String,
                            ValueColumnName As String,
                            DisplayColumnName As String,
                            Optional CurrentValue As String = Nothing,
                            Optional CurrentText As String = Nothing,
                            Optional AddBlankRow As Boolean = False,
                            ByRef Optional oDS As DataSet = Nothing)

        Dim oEIDSSObject As IEidssEntity = Activator.CreateInstance(System.Type.GetType(eidssType.ToString))
        Dim ds As DataSet = Nothing
        If oDS Is Nothing Then
            ds = GetDataSet(eidssType, FilterKey)
            oDS = ds
        Else
            If FilterKey Is Nothing Then
                ds = oDS
            Else
                ds = FilterDataSet(oDS, FilterKey)
            End If
        End If

        If (Not (Ctrl Is Nothing)) And (ds.CheckDataSet()) Then
            Ctrl.Items.Clear()
            Ctrl.Populate(ds.Tables(0),
                      DisplayColumnName,
                      ValueColumnName,
                      CurrentValue,
                      CurrentText,
                      AddBlankRow)
        End If

    End Sub

    Public Sub FillRadioButtonList(Ctrl As RadioButtonList,
                                    eidssType As Type,
                                    FilterKey As String(),
                                    ValueColumnName As String,
                                    DisplayColumnName As String,
                                    Optional CurrentValue As String = Nothing,
                                    Optional CurrentText As String = Nothing,
                                    ByRef Optional oDS As DataSet = Nothing)

        Dim oEIDSSObject As IEidssEntity = Activator.CreateInstance(System.Type.GetType(eidssType.ToString))
        Dim ds As DataSet = Nothing
        If oDS Is Nothing Then
            ds = GetDataSet(eidssType, FilterKey)
            oDS = ds
        Else
            If FilterKey Is Nothing Then
                ds = oDS
            Else
                ds = FilterDataSet(oDS, FilterKey)
            End If
        End If

        With Ctrl
            .Items.Clear()
            .DataSource = oDS.Tables(0)
            .DataTextField = DisplayColumnName
            .DataValueField = ValueColumnName

            Try
                .DataBind()
            Catch ex As Exception

            End Try
        End With

        Try

            If CurrentValue Is Nothing Then
                If CurrentText Is Nothing Then
                    Ctrl.SelectedIndex = 0
                Else
                    Ctrl.SelectedIndex = Ctrl.Items.IndexOf(Ctrl.Items.FindByText(CurrentText))
                End If
            Else
                Ctrl.Items.FindByValue(CurrentValue).Selected = True
            End If

        Catch ex As Exception

        End Try

    End Sub

    Public Function GetDataSet(eidsstype As Type,
                               FilterKey() As String) As DataSet

        Dim oEIDSSObject As IEidssEntity = Activator.CreateInstance(System.Type.GetType(eidsstype.ToString))
        Dim ds As DataSet = oEIDSSObject.ListAll(FilterKey)

        If ds.CheckDataSet() Then
            Return ds
        Else
            Return Nothing
        End If

    End Function

    Public Function FilterDataSet(oDS As DataSet, FilterKey() As String) As DataSet

        Dim dt As DataTable
        Dim ds As DataSet = New DataSet()

        dt = oDS.Tables(0).Select(FilterKey(0)).CopyToDataTable

        ds.Tables.Add(dt)

        Return ds

    End Function

    Public Sub BaseReferenceLookUp(Ctrl As DropDownList,
                                   strRererenceTyeName As String,
                                   Optional intHACode As Integer = 0,
                                   Optional blnBlankRow As Boolean = False,
                                   ByRef Optional oDS As DataSet = Nothing)

        FillDropDown(Ctrl,
                     GetType(clsBaseReference),
                     {"@ReferenceTypeName:" & strRererenceTyeName, "@intHACode:" & intHACode},
                     BaseReferenceConstants.idfsBaseReference,
                     BaseReferenceConstants.Name,
                     Nothing,
                     Nothing,
                     blnBlankRow,
                     oDS)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Ctrl"></param>
    ''' <returns></returns>
    Public Function SortDropDownList(Ctrl As DropDownList) As DropDownList

        If Ctrl Is Nothing Then
            Ctrl = New DropDownList()
        End If

        'Get list items from DropDownList
        If Ctrl.Items.Count > 0 Then
            Dim ddlList As New ArrayList
            For Each li As ListItem In Ctrl.Items
                ddlList.Add(li)
            Next

            'Sort arraylist
            ddlList.Sort(New clsCommon.ListItemComparer)

            'Copy sorted list back into the DropDownList
            Ctrl.Items.Clear()
            For Each li As ListItem In ddlList
                Ctrl.Items.Add(li)
            Next
        End If

        Return Ctrl

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Ctrl"></param>
    ''' <returns></returns>
    Public Function SortListBox(Ctrl As ListBox) As ListBox

        If Ctrl Is Nothing Then
            Ctrl = New ListBox()
        End If

        'Get list items from ListBox
        If Ctrl.Items.Count > 0 Then
            Dim lbxList As New ArrayList
            For Each li As ListItem In Ctrl.Items
                lbxList.Add(li)
            Next

            'Sort arraylist
            lbxList.Sort(New clsCommon.ListItemComparer)

            'Copy sorted list back into the ListBox
            Ctrl.Items.Clear()
            For Each li As ListItem In lbxList
                Ctrl.Items.Add(li)
            Next
        End If

        Return Ctrl

    End Function

    Public Sub PopulatePageSection(ByVal repeaterCtrl As Repeater,
                                   ByVal recordCount As Integer,
                                   ByVal currentPage As Integer)

        'ToDo: define it as a configurable item
        Dim iRowsPerPage As Integer = 5

        'Calculate total pages based on rows per page
        Dim dblPageCount As Double = CType((CType(recordCount, Decimal) / Decimal.Parse(10)), Double)
        Dim iPageCount As Integer = CType(Math.Ceiling(dblPageCount), Integer)

        Dim iStartPage As Integer
        Dim iStartPageSet As Integer = 1
        Dim iPreviousPageSet As Integer = 1
        Dim iNextPageSet As Integer = iPageCount

        'Calculate next and previous page set
        For I As Integer = (currentPage + 1) To iPageCount
            If I Mod iRowsPerPage = 0 Then iNextPageSet = I
        Next
        iPreviousPageSet = (iNextPageSet - (5 * 2)) + 1
        If iPreviousPageSet <= 0 Then iPreviousPageSet = 1

        'Add pages to the repeater control
        Dim pages As New List(Of ListItem)
        If (iPageCount > 0) Then

            iStartPage = (iNextPageSet - iRowsPerPage) + 1
            If iStartPage <= 0 Then iStartPage = 1

            iStartPageSet = (iStartPage - 1)
            If iStartPageSet <= 0 Then iStartPageSet = 1

            pages.Add(New ListItem("<<", "1", (currentPage > 0)))
            pages.Add(New ListItem("<", iPreviousPageSet.ToString(), (currentPage > 0)))

            Do While (iStartPage <= iNextPageSet)
                pages.Add(New ListItem(iStartPage.ToString, iStartPage.ToString, (iStartPage <> currentPage)))
                iStartPage = (iStartPage + 1)
            Loop

            pages.Add(New ListItem(">", iNextPageSet.ToString(), (currentPage < iPageCount)))
            pages.Add(New ListItem(">>", iPageCount.ToString(), (currentPage < iPageCount)))

        End If

        repeaterCtrl.DataSource = pages
        repeaterCtrl.DataBind()

    End Sub

    Public Function GetURL(Optional ByVal sURL As String = "#") As String

        Dim oRequest = System.Web.HttpContext.Current.Request
        If sURL = "#" Then
            Return oRequest.Url.ToString()
        Else
            Return oRequest.Url.GetLeftPart(UriPartial.Authority) & oRequest.ApplicationPath & sURL
        End If

    End Function

End Module