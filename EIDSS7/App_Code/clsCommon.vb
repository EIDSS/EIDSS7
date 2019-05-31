Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.IO
Imports System.Xml.Serialization
Imports System.Web.UI
Imports EIDSS.NG
Imports EIDSSControlLibrary
Imports System.Xml
Imports System.Reflection
Imports System.ComponentModel

Namespace EIDSS

    Public Class clsCommon

        Private oComm As clsCommon
        Private oService As EIDSSService

        ''' <summary>
        ''' Gets the current build number for the application.
        ''' </summary>
        ''' <returns>Returns a string representing the Major.Minor.Revision number of the EIDSS Website.</returns>
        Public Function GetCurrentBuildNumber() As String
            Dim nsClient As Assembly = Assembly.ReflectionOnlyLoad("EIDSS.Client")
            Dim nsName As AssemblyName = nsClient.GetName()
            Return nsName.Version.ToString()

        End Function

        ''' <summary>
        ''' Retrieves the application environment setting from the configuration file.
        ''' </summary>
        ''' <returns>Returns a string representing the application's targeted deployment environment.</returns>
        Public Function GetApplicationEnvironment() As String

            ' Get the application environment configuration.
            Dim settings = System.Configuration.ConfigurationManager.AppSettings

            Dim env As String = settings.Get("Environment")

            If IsValueNullOrEmpty(env) Then env = String.Empty

            Return env

        End Function

        Public Function GetUserSettings() As DataSet

            Dim oDS As DataSet = Nothing
            Dim sFile = CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
            oDS = ReadEIDSSXML(sFile)

            Return oDS

        End Function

        Public Function GetSPList(sModule As String) As String()

            oComm = New clsCommon()
            oService = oComm.GetService()
            Dim aSP As String()

            aSP = oService.getSPList(sModule)

            oService = Nothing
            oComm = Nothing

            Return aSP

        End Function

        'get values from DB and populate form fields
        'Prefix are generally lbl, txt, ddl, cbo, rbl etc. hence _PrefixLength is defaulted to 3
        'If the form fields (all) have prefix more then 3 then pass the length
        'For this method to work correctly form fields prefix length in any given "section" should be same

        Public Sub Scatter(ByRef ctrl As Web.UI.Control _
                          , ByRef _dr As DataTableReader _
                          , Optional ByVal _PrefixLength As Integer = 3 _
                          , Optional ByRef _IncludeLabels As Boolean = False _
                          , Optional ByRef _TableName As String = "")

            Dim allCtrl As New List(Of Control)
            Dim dtSchema As DataTable = _dr.GetSchemaTable()
            Dim aFldName As String()
            Dim sFldName As String
            Dim sFldType As String

            If _dr.HasRows() Then
                While _dr.Read

                    'Find all TextBox control and populate
                    allCtrl.Clear()
                    For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.TextBox))
                        'default field type to string
                        sFldType = "String"
                        aFldName = txt.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength, sFldType) Then
                                txt.Text = _dr(sFldName) & ""
                                If txt.Text <> "" Then
                                    Select Case sFldType.ToUpper()
                                        Case "DECIMAL"
                                            txt.Text = txt.Text.ToDecimal().ToString("n2")
                                        Case "MONEY"
                                            txt.Text = txt.Text.ToDecimal().ToString("n2")
                                    End Select
                                End If

                                'Added option to set max length to a text field.
                                SetFieldMaxLength(txt, _TableName, _PrefixLength, sFldName)

                            End If
                        End If
                    Next

                    'Find all Hidden control and populate
                    'allCtrl.Clear()
                    'For Each hfld As WebControls.HiddenField In FindCtrl(allCtrl, ctrl, GetType(WebControls.HiddenField))
                    '    'default field type to string
                    '    sFldType = "String"
                    '    aFldName = hfld.ClientID.Split("_")
                    '    sFldName = aFldName(aFldName.Count - 1)
                    '    If sFldName.Length > _PrefixLength Then
                    '        If FindField(sFldName, dtSchema, _PrefixLength, sFldType) Then
                    '            If Not (_dr(sFldName) Is DBNull.Value) Then
                    '                hfld.Value = _dr(sFldName) & ""
                    '            End If
                    '        End If
                    '    End If
                    'Next

                    'Find all Hidden control and populate
                    allCtrl.Clear()
                    For Each txt As WebControls.HiddenField In FindCtrl(allCtrl, ctrl, GetType(WebControls.HiddenField))
                        'default field type to string
                        sFldType = "String"
                        aFldName = txt.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength, sFldType) Then
                                txt.Value = _dr(sFldName) & ""
                                If txt.Value <> "" Then
                                    Select Case sFldType.ToUpper()
                                        Case "DECIMAL"
                                            txt.Value = txt.Value.ToDecimal().ToString("n2")
                                        Case "MONEY"
                                            txt.Value = txt.Value.ToDecimal().ToString("n2")
                                    End Select
                                End If
                            End If
                        End If
                    Next

                    'Find all CheckBox List control and populate
                    allCtrl.Clear()
                    For Each chklst As WebControls.CheckBoxList In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBoxList))
                        aFldName = chklst.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then chklst.SelectedValue = _dr(sFldName) & ""
                        End If
                    Next

                    'Find all CheckBox control and populate
                    allCtrl.Clear()
                    For Each chk As WebControls.CheckBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBox))
                        aFldName = chk.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then chk.Checked = (_dr(sFldName) = True)
                        End If
                    Next

                    'Find all DropDownList control and populate
                    allCtrl.Clear()
                    For Each ddl As WebControls.DropDownList In FindCtrl(allCtrl, ctrl, GetType(WebControls.DropDownList))
                        aFldName = ddl.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        'sFldName = aFldName(1) - SHL overlays the prior line that has the correct name.
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then
                                Try
                                    ddl.SelectedValue = _dr(sFldName) & ""
                                Catch ex As Exception
                                End Try
                            End If
                        End If
                    Next

                    'Find all EIDSS Control Library DropDownList control and populate
                    allCtrl.Clear()
                    For Each ddl As EIDSSControlLibrary.DropDownList In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                        aFldName = ddl.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        'sFldName = aFldName(1)
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then
                                'ddl.SelectedValue = _dr(sFldName) & ""
                                If IsDBNull(_dr(sFldName)) Then
                                    ddl.SelectedValue = Nothing
                                Else
                                    Try
                                        ddl.SelectedValue = _dr(sFldName) & ""
                                    Catch ex As Exception
                                    End Try
                                End If

                            End If
                        End If
                    Next

                    'Find all EIDSS Control Library Spinner control and populate
                    allCtrl.Clear()
                    For Each txt As EIDSSControlLibrary.NumericSpinner In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                        aFldName = txt.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        'sFldName = aFldName(1) - SHL overlays the prior line that has the correct name.
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then
                                txt.Text = _dr(sFldName) & ""
                            End If
                        End If
                    Next

                    'Find all EIDSS Control Library Calendar Input control and populate
                    allCtrl.Clear()
                    For Each txt As EIDSSControlLibrary.CalendarInput In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                        aFldName = txt.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        'sFldName = aFldName(1) - SHL overlays the prior line that has the correct name.
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then
                                txt.Text = _dr(sFldName) & ""
                            End If
                        End If
                    Next

                    'Find all RadioButton control and populate
                    allCtrl.Clear()
                    For Each rbtn As WebControls.RadioButton In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButton))
                        aFldName = rbtn.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then rbtn.Checked = (_dr(sFldName) = True)
                        End If
                    Next

                    'Find all RadioButtonList control and populate
                    allCtrl.Clear()
                    For Each rbtnlst As WebControls.RadioButtonList In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButtonList))
                        aFldName = rbtnlst.ClientID.Split("_")
                        sFldName = aFldName(aFldName.Count - 1)
                        If sFldName.Length > _PrefixLength Then
                            If FindField(sFldName, dtSchema, _PrefixLength) Then rbtnlst.SelectedValue = _dr(sFldName) & ""
                        End If
                    Next

                    If _IncludeLabels Then
                        allCtrl.Clear()
                        For Each lbl As WebControls.Label In FindCtrl(allCtrl, ctrl, GetType(WebControls.Label))
                            aFldName = lbl.ClientID.Split("_")
                            sFldName = aFldName(aFldName.Count - 1)
                            If sFldName.Length > _PrefixLength Then
                                If FindField(sFldName, dtSchema, _PrefixLength) Then lbl.Text = _dr(sFldName) & ""
                            End If
                        Next
                    End If

                End While
            Else

                'there are no rows in the data set
                'Find all TextBox control and set the max length of text fields

                allCtrl.Clear()
                For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.TextBox))
                    aFldName = txt.ClientID.Split("_")
                    sFldName = aFldName(aFldName.Count - 1)
                    If sFldName.Length > _PrefixLength Then
                        If FindField(sFldName, dtSchema, _PrefixLength) Then
                            txt.Text = ""
                            'Added option to set max length to a text field.
                            SetFieldMaxLength(txt, _TableName, _PrefixLength, sFldName)

                        End If
                    End If
                Next

            End If

        End Sub

        'Get values from the form and create a string
        'Prefix are generally lbl, txt, ddl, cbo, rbl etc. hence _PrefixLength is defaulted to 3
        'If the forn fields (all) have prefix more then 3 then pass the length
        'For this method to work correctly form fields prefix length in any given "section" should be same
        'Use _Debug option to view how parameter and values are paired and if we are missing any parameter/value.

        Public Function Gather(ByRef ctrl As Web.UI.Control _
                              , ByVal spname As String _
                              , Optional ByVal _PrefixLength As Integer = 3 _
                              , Optional ByVal _ValueWithKey As Boolean = False) As String

            Gather = ""

            Dim sp As String = "usp_dbGetProcParams"
            Dim KeyValPair As New List(Of clsCommon.Param)

            Try

                Dim oDS As DataSet = Nothing
                oComm = New clsCommon()
                oService = oComm.GetService()

                'Get all the parameters for the sp
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "proc_name", .ParamValue = spname, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "GetProcParams", oComm.KeyValPairToString(KeyValPair))
                oDS = DirectCast(oTuple.m_Item1, DataSet)

                Dim allCtrl As New List(Of Control)
                Dim aFormFldID As String()
                Dim sFormFldID As String = ""
                Dim sFldName As String = ""
                Dim sFldDataType As String = ""
                Dim sFieldMaxLength As String = ""
                Dim sParameterMode As String = "IN" 'INOUT for output parameter
                Dim aDataTypes As String() = "BIG,TIN,INT,NUM,FLO,REA,MON,DEC,BIT".Split(",")
                Dim aNumDataTypes As String() = "BIG,TIN,INT,NUM,FLO,REA,MON,DEC".Split(",")
                Dim sValue As String = ""
                Dim aValue As New List(Of String)
                Dim aValueWithKey As New List(Of String)

                aValue.Clear()
                aValueWithKey.Clear()

                If oDS.CheckDataSet() Then
                    For i = 0 To oDS.Tables(0).Rows.Count - 1
                        sFldName = oDS.Tables(0).Rows(i).Item("PARAMETER_NAME") & ""
                        sFldName = sFldName.Replace("@", "")
                        sFldDataType = oDS.Tables(0).Rows(i).Item("DATA_TYPE")
                        sFieldMaxLength = IIf(TypeOf oDS.Tables(0).Rows(i).Item("CHARACTER_MAXIMUM_LENGTH") Is DBNull, "NULL", oDS.Tables(0).Rows(i).Item("CHARACTER_MAXIMUM_LENGTH"))
                        sParameterMode = oDS.Tables(0).Rows(i).Item("PARAMETER_MODE") & ""

                        'For each field in the SP parameter, loop through all form controls and collect value
                        'Initialize the sFormField = "" so that we can assign NULL values.
                        sFormFldID = ""

                        'TextBox control
                        allCtrl.Clear()
                        For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.TextBox))
                            aFormFldID = txt.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    If txt.Text = "" Then
                                        If aDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                            If sFieldMaxLength = "NULL" Then
                                                'Commented as this would need SNPService:ExecuteDatabaseCommond(0 method changes
                                                'aValue.Add(sFieldMaxLength)
                                                'aValueWithKey.Add(sFldName & "=" & sFieldMaxLength)
                                                aValue.Add(0)
                                                aValueWithKey.Add(sFldName & ";NULL;" & sParameterMode)
                                            Else
                                                aValue.Add(0)
                                                aValueWithKey.Add(sFldName & ";0;" & sParameterMode)
                                            End If
                                        Else
                                            If aNumDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                                aValue.Add(txt.Text.Replace(",", "") & "")
                                                aValueWithKey.Add(sFldName & ";" & txt.Text.Replace(",", "") & ";" & sParameterMode)
                                            Else
                                                aValue.Add(txt.Text.Replace("|", "/") & "")
                                                aValueWithKey.Add(sFldName & ";" & txt.Text.Replace("|", "/") & ";" & sParameterMode)
                                            End If
                                        End If
                                    Else
                                        If aNumDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                            aValue.Add(txt.Text.Replace(",", "") & "")
                                            aValueWithKey.Add(sFldName & ";" & txt.Text.Replace(",", "") & ";" & sParameterMode)
                                        Else
                                            aValue.Add(txt.Text.Replace("|", "/") & "")
                                            aValueWithKey.Add(sFldName & ";" & txt.Text.Replace("|", "/") & ";" & sParameterMode)
                                        End If
                                    End If
                                End If
                            End If
                        Next

                        'Hidden control
                        allCtrl.Clear()
                        For Each txt As WebControls.HiddenField In FindCtrl(allCtrl, ctrl, GetType(WebControls.HiddenField))
                            aFormFldID = txt.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    If txt.Value = "" Then
                                        If aDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                            If sFieldMaxLength = "NULL" Then
                                                aValue.Add(0)
                                                'Changed the hidden field value as SQL foreign key constraint violations were being thrown on ID fields with zero sent in.
                                                'aValueWithKey.Add(sFldName & ";0;" & sParameterMode)
                                                aValueWithKey.Add(sFldName & ";NULL;" & sParameterMode)
                                            Else
                                                aValue.Add(0)
                                                aValueWithKey.Add(sFldName & ";0;" & sParameterMode)
                                            End If
                                        Else
                                            If aNumDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                                aValue.Add(txt.Value.Replace(",", "") & "")
                                                aValueWithKey.Add(sFldName & ";" & txt.Value.Replace(",", "") & ";" & sParameterMode)
                                            Else
                                                aValue.Add(txt.Value.Replace("|", "/") & "")
                                                aValueWithKey.Add(sFldName & ";" & txt.Value.Replace("|", "/") & ";" & sParameterMode)
                                            End If
                                        End If
                                    Else
                                        If aNumDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                            aValue.Add(txt.Value.Replace(",", "") & "")
                                            aValueWithKey.Add(sFldName & ";" & txt.Value.Replace(",", "") & ";" & sParameterMode)
                                        Else
                                            aValue.Add(txt.Value.Replace("|", "/") & "")
                                            aValueWithKey.Add(sFldName & ";" & txt.Value.Replace("|", "/") & ";" & sParameterMode)
                                        End If
                                    End If
                                End If
                            End If
                        Next

                        'CheckBox List control
                        allCtrl.Clear()
                        For Each chklst As WebControls.CheckBoxList In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBoxList))
                            aFormFldID = chklst.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    aValue.Add(chklst.SelectedValue & "")
                                    aValueWithKey.Add(sFldName & ";" & chklst.SelectedValue & ";" & sParameterMode)
                                End If
                            End If
                        Next

                        'CheckBox control
                        allCtrl.Clear()
                        For Each chk As WebControls.CheckBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBox))
                            aFormFldID = chk.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    aValue.Add(chk.Checked & "")
                                    aValueWithKey.Add(sFldName & ";" & chk.Checked & ";" & sParameterMode)
                                End If
                            End If
                        Next

                        'DropDownList control
                        allCtrl.Clear()
                        For Each ddl As WebControls.DropDownList In FindCtrl(allCtrl, ctrl, GetType(WebControls.DropDownList))
                            aFormFldID = ddl.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    If ddl.SelectedValue = "" Then
                                        aValue.Add("null")
                                        aValueWithKey.Add(sFldName & ";null;" & sParameterMode)
                                    Else
                                        aValue.Add(ddl.SelectedValue.Replace("|", "/") & "")
                                        aValueWithKey.Add(sFldName & ";" & ddl.SelectedValue.Replace("|", "/") & ";" & sParameterMode)
                                    End If
                                End If
                            End If
                        Next

                        'ListBox control
                        allCtrl.Clear()
                        For Each ddl As WebControls.ListBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.ListBox))
                            aFormFldID = ddl.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    If ddl.SelectedValue = "" Then
                                        aValue.Add("null")
                                        aValueWithKey.Add(sFldName & ";null;" & sParameterMode)
                                    Else
                                        Dim selectedValues As Integer = 0

                                        For Each li As ListItem In ddl.Items
                                            If li.Selected Then
                                                selectedValues = selectedValues + Convert.ToInt16(li.Value)
                                            End If
                                        Next

                                        aValue.Add(selectedValues.ToString.Replace("|", "/") & "")
                                        aValueWithKey.Add(sFldName & ";" & selectedValues.ToString().Replace("|", "/") & ";" & sParameterMode)
                                    End If
                                End If
                            End If
                        Next

                        'EIDSSControlLibrary.DropDownList control
                        allCtrl.Clear()
                        For Each ddl As EIDSSControlLibrary.DropDownList In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                            aFormFldID = ddl.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    If ddl.SelectedValue = "" Then
                                        aValue.Add("null")
                                        aValueWithKey.Add(sFldName & ";null;" & sParameterMode)
                                    Else
                                        aValue.Add(ddl.SelectedValue.Replace("|", "/") & "")
                                        aValueWithKey.Add(sFldName & ";" & ddl.SelectedValue.Replace("|", "/") & ";" & sParameterMode)
                                    End If
                                End If
                            End If
                        Next

                        'EIDSSControlLibrary.NumericSpinner control
                        allCtrl.Clear()
                        For Each txt As EIDSSControlLibrary.NumericSpinner In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                            aFormFldID = txt.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    If txt.Text = "" Then
                                        aValue.Add("null")
                                        aValueWithKey.Add(sFldName & ";null;" & sParameterMode)
                                    Else
                                        aValue.Add(txt.Text.Replace("|", "/") & "")
                                        aValueWithKey.Add(sFldName & ";" & txt.Text.Replace("|", "/") & ";" & sParameterMode)
                                    End If
                                End If
                            End If
                        Next

                        'RadioButton control
                        allCtrl.Clear()
                        For Each rbtn As WebControls.RadioButton In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButton))
                            aFormFldID = rbtn.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    aValue.Add(rbtn.Checked & "")
                                    aValueWithKey.Add(sFldName & ";" & rbtn.Checked & ";" & sParameterMode)
                                End If
                            End If
                        Next

                        'RadioButtonList control
                        allCtrl.Clear()
                        For Each rbtnlst As WebControls.RadioButtonList In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButtonList))
                            aFormFldID = rbtnlst.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    aValue.Add(rbtnlst.SelectedValue & "")
                                    aValueWithKey.Add(sFldName & ";" & rbtnlst.SelectedValue & ";" & sParameterMode)
                                End If
                            End If
                        Next
                        'eidss:CalendarInput control
                        allCtrl.Clear()
                        For Each txt As EIDSSControlLibrary.CalendarInput In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                            aFormFldID = txt.ClientID.Split("_")
                            sFormFldID = aFormFldID(aFormFldID.Count - 1)
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    If txt.Text = "" Then
                                        If aDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                            If sFieldMaxLength = "NULL" Then
                                                aValue.Add(0)
                                                aValueWithKey.Add(sFldName & ";0;" & sParameterMode)
                                            Else
                                                aValue.Add(0)
                                                aValueWithKey.Add(sFldName & ";0;" & sParameterMode)
                                            End If
                                        Else
                                            If aNumDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                                aValue.Add(txt.Text.Replace(",", "") & "")
                                                aValueWithKey.Add(sFldName & ";" & txt.Text.Replace(",", "") & ";" & sParameterMode)
                                            Else
                                                aValue.Add(txt.Text.Replace("|", "/") & "")
                                                aValueWithKey.Add(sFldName & ";NULL;" & sParameterMode)
                                            End If
                                        End If
                                    Else
                                        If aNumDataTypes.Contains(sFldDataType.Substring(0, 3)) Then
                                            aValue.Add(txt.Text.Replace(",", "") & "")
                                            aValueWithKey.Add(sFldName & ";" & txt.Text.Replace(",", "") & ";" & sParameterMode)
                                        Else
                                            aValue.Add(txt.Text.Replace("|", "/") & "")
                                            aValueWithKey.Add(sFldName & ";" & txt.Text.Replace("|", "/") & ";" & sParameterMode)
                                        End If
                                    End If
                                End If
                            End If
                        Next

                        If sFormFldID = "" Then
                            'Did not find the parameter value on the form; assign a NULL value
                            'ToDo - can run a validation; if in the database the field is NOT NULL, throw an exception
                            sFormFldID = "NULL"
                        End If

                    Next
                End If

                If _ValueWithKey Then
                    Gather = String.Join("|", aValueWithKey)
                Else
                    Gather = String.Join("|", aValue)
                End If

            Catch ex As Exception

                Gather = ""
                Dim strMessage As String = "The following Error occured in clsCommon::Gather() -  " & ex.Message

                ASPNETMsgBox(strMessage)

            End Try

            Return Gather

        End Function

        'Get values from the form and create a string
        'Overloaded function to get values for all controls under a parent control

        Public Function Gather(ByRef ctrl As Web.UI.Control) As String

            Gather = ""

            Dim sp As String = "usp_dbGetProcParams"
            Dim KeyValPair As New List(Of Param)

            Try

                Dim oDS As DataSet = Nothing
                oComm = New clsCommon()
                oService = oComm.GetService()

                Dim allCtrl As New List(Of Control)
                Dim aFormFldID As String()
                Dim sFormFldID As String = ""
                Dim aValueWithKey As New List(Of String)
                Dim sParameterMode As String = "IN" 'used to make it compatiple with scatter
                aValueWithKey.Clear()

                'TextBox control
                allCtrl.Clear()
                For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.TextBox))
                    aFormFldID = txt.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & txt.Text.Replace("|", "/") & ";" & sParameterMode)
                Next

                'Hidden control
                allCtrl.Clear()
                For Each txt As WebControls.HiddenField In FindCtrl(allCtrl, ctrl, GetType(WebControls.HiddenField))
                    aFormFldID = txt.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & txt.Value.Replace("|", "/") & ";" & sParameterMode)
                Next

                'CheckBox List control
                allCtrl.Clear()
                For Each chklst As WebControls.CheckBoxList In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBoxList))
                    aFormFldID = chklst.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & chklst.SelectedValue & ";" & sParameterMode)
                Next

                'CheckBox control
                allCtrl.Clear()
                For Each chk As WebControls.CheckBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBox))
                    aFormFldID = chk.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & chk.Checked & ";" & sParameterMode)
                Next

                'DropDownList control
                allCtrl.Clear()
                For Each ddl As WebControls.DropDownList In FindCtrl(allCtrl, ctrl, GetType(WebControls.DropDownList))
                    aFormFldID = ddl.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & ddl.SelectedValue.Replace("|", "/") & ";" & sParameterMode)
                Next

                'EIDSSControlLibrary.DropDownList control
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                    aFormFldID = ddl.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & ddl.SelectedValue.Replace("|", "/") & ";" & sParameterMode)
                Next

                'EIDSSControlLibrary.NumericSpinner control
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.NumericSpinner In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                    aFormFldID = txt.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & txt.Text.Replace("|", "/") & ";" & sParameterMode)
                Next

                'RadioButton control
                allCtrl.Clear()
                For Each rbtn As WebControls.RadioButton In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButton))
                    aFormFldID = rbtn.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & rbtn.Checked & ";" & sParameterMode)
                Next

                'RadioButtonList control
                allCtrl.Clear()
                For Each rbtnlst As WebControls.RadioButtonList In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButtonList))
                    aFormFldID = rbtnlst.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & rbtnlst.SelectedValue & ";" & sParameterMode)
                Next

                'eidss:CalendarInput control
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                    aFormFldID = txt.ClientID.Split("_")
                    sFormFldID = aFormFldID(aFormFldID.Count - 1)
                    aValueWithKey.Add(sFormFldID & ";" & txt.Text.Replace("|", "/") & ";" & sParameterMode)
                Next

                Gather = String.Join("|", aValueWithKey)

            Catch ex As Exception

                Gather = ""
                Dim strMessage As String = "The following Error occured in clsCommon::Gather() -  " & ex.Message

                ASPNETMsgBox(strMessage)

            End Try

            Return Gather

        End Function

        Public Sub ResetForm(ByRef ctrl As Web.UI.Control)

            'Collection of control of given type are collected in this variable
            Dim allCtrl As New List(Of Control)

            'TextBox
            'Loop through the collection and disable the control
            For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.TextBox))
                txt.Text = ""
            Next

            For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                txt.Text = ""
            Next

            For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                txt.Text = ""
            Next

            'Disable CheckBox
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each chk As WebControls.CheckBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBox))
                chk.Checked = False
            Next

            'Disable DropDownList
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each ddl As WebControls.DropDownList In FindCtrl(allCtrl, ctrl, GetType(WebControls.DropDownList))
                ddl.SelectedIndex = -1
            Next

            'Disable EIDSS Control Library DropDownList
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each ddl As EIDSSControlLibrary.DropDownList In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                ddl.SelectedIndex = -1
            Next

            'Hide RadioButton
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each rbtn As WebControls.RadioButton In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButton))
                rbtn.Checked = False
            Next

            'Hide RadioButtonList
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each rbtnlst As WebControls.RadioButtonList In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButtonList))
                rbtnlst.SelectedIndex = -1
            Next

            allCtrl.Clear()
            For Each gv As WebControls.GridView In FindCtrl(allCtrl, ctrl, GetType(WebControls.GridView))
                gv.DataSource = Nothing
            Next

            allCtrl.Clear()
            For Each hf As WebControls.HiddenField In FindCtrl(allCtrl, ctrl, GetType(WebControls.HiddenField))
                hf.Value = String.Empty
            Next

        End Sub

        Public Sub SetFieldMaxLength(ByRef ctrl As WebControls.TextBox, ByVal tblname As String, Optional ByVal _PrefixLength As Integer = 3, Optional ByVal colname As String = "")

            Dim KeyValPair As New List(Of clsCommon.Param)

            Try

                'Get all the parameters for the sp
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "table_name", .ParamValue = tblname, .ParamMode = "IN"})
                If colname <> "" Then KeyValPair.Add(New clsCommon.Param() With {.ParamName = "column_name", .ParamValue = colname, .ParamMode = "IN"})

                Dim oDS As DataSet
                oComm = New clsCommon()
                oService = oComm.GetService()
                Dim oTuple = oService.GetData(GetCurrentCountry(), "GetTableColumns", oComm.KeyValPairToString(KeyValPair))
                oDS = DirectCast(oTuple.m_Item1, DataSet)

                Dim allCtrl As New List(Of Control)
                Dim sFormFldID As String = ""
                Dim sFldName As String = ""
                Dim sFldDataType As String = ""
                Dim sFieldMaxLength As String = ""
                Dim sValue As String = ""
                Dim aValue As New List(Of String)
                Dim aValueWithKey As New List(Of String)

                aValue.Clear()
                aValueWithKey.Clear()

                If oDS.CheckDataSet() Then
                    For i = 0 To oDS.Tables(0).Rows.Count - 1
                        sFldName = oDS.Tables(0).Rows(i).Item("COLUMN_NAME") & ""
                        sFldDataType = oDS.Tables(0).Rows(i).Item("DATA_TYPE")

                        'Set the max length only when the field is text 
                        If sFldDataType.ToUpper() = "VARCHAR" Then

                            sFieldMaxLength = oDS.Tables(0).Rows(i).Item("CHARACTER_MAXIMUM_LENGTH")

                            sFormFldID = ""
                            sFormFldID = ctrl.ID
                            If sFormFldID.Length > _PrefixLength Then
                                If sFormFldID.Substring(_PrefixLength).ToUpper() = sFldName.ToUpper() Then
                                    ctrl.MaxLength = sFieldMaxLength
                                End If
                            End If

                        End If
                    Next
                End If

            Catch ex As Exception

                Dim strMessage As String = "The following Error occured in clsCommon::SetFieldMaxLength() -  " & ex.Message

                ASPNETMsgBox(strMessage)

            End Try

        End Sub

        'Find controls of given type under parent control
        Public Function FindCtrl(ByVal _list As List(Of Control), ByVal _parent As Control, ByVal _ctrlType As Type) As List(Of Control)

            If _parent Is Nothing Then Return _list

            If _parent.GetType Is _ctrlType Then
                _list.Add(_parent)
            End If

            For Each child As Control In _parent.Controls
                FindCtrl(_list, child, _ctrlType)
            Next

            Return _list

        End Function

        Public Function FindField(ByRef sFldName As String, ByRef dtSchema As DataTable, ByVal _PrefixLength As Integer, Optional ByRef _FldType As String = "String") As Boolean

            FindField = False

            Try
                Dim sColName As String = ""

                '_PrefixLength is the length of prefix given to form field from database. for e.g, txtName - Where txt is prefix and "Name" is DB field name
                sFldName = sFldName.Substring(_PrefixLength)
                If Not dtSchema Is Nothing Then
                    For Each drow As DataRow In dtSchema.Rows
                        sColName = System.Convert.ToString(drow("ColumnName"))
                        If sFldName.ToUpper() = sColName.ToUpper() Then
                            _FldType = drow.Item("DataType").Name.ToString()
                            FindField = True
                            Exit For
                        End If
                    Next
                End If

            Catch ex As Exception
                'If a control is not in dr, it will run into exception. Ignore and continue
                FindField = False
            End Try

            Return FindField

        End Function

        Public Function GetConfigValue(ByVal key As String) As String

            GetConfigValue = System.Configuration.ConfigurationManager.AppSettings.Get(key)

        End Function

        Public Function GetService() As EIDSSService

            Dim oService As EIDSSService = New EIDSSService With {
                .UseDefaultCredentials = True,
                .Credentials = System.Net.CredentialCache.DefaultCredentials
            }
            GetService = oService

            Return oService

        End Function

        'Usage: ToggleReview(Me.FindControl("frmMain"), Request.Url.Segments)

        Public Sub ToggleReview(ByVal frm As Web.UI.Control, ByVal WebSegments() As String)

            'assuming that the last segment is the aspx page
            Dim strModule As String = "Application"
            Dim strWebPageName As String = WebSegments(WebSegments.Count - 1)

            'Assuming that the last segment contains page name.
            If strWebPageName.IndexOf("aspx") > 0 Then

                Try

                    'Get the rights
                    Dim ds As DataSet = New DataSet
                    Dim sPath As String = HttpContext.Current.Server.MapPath("~/App_Data/EIDSSPages.xml")
                    ds.ReadXml(sPath)

                    Dim dv As DataView = Nothing
                    Dim dsFiltered As New DataSet

                    If ds.CheckDataSet() Then

                        Dim sFilter As String = "Upper(PageName) = '" & strWebPageName.ToUpper() & "'"
                        dv.RowFilter = sFilter
                        Dim dtFiltered As DataTable = dv.ToTable()
                        dsFiltered.Tables.Add(dtFiltered)

                    End If

                    If dsFiltered.CheckDataSet() Then

                        Dim drFiltered As DataTableReader = dsFiltered.Tables(0).CreateDataReader()

                        'Collection of control of given type are collected in this variable
                        Dim allCtrl As New List(Of Control)

                        'Disable TextBox
                        'Loop through the collection and disable the control
                        For Each txt As WebControls.TextBox In FindCtrl(allCtrl, frm, GetType(WebControls.TextBox))
                            txt.Enabled = txt.ID.EqualsAny(drFiltered("ExceptionControlList").ToString().Split(","))
                        Next

                        'Disable CheckBox
                        'Loop through the collection and disable the control
                        allCtrl.Clear()
                        For Each chk As WebControls.CheckBox In FindCtrl(allCtrl, frm, GetType(WebControls.CheckBox))
                            chk.Enabled = chk.ID.EqualsAny(drFiltered("ExceptionControlList").ToString().Split(","))
                        Next

                        'Disable DropDownList
                        'Loop through the collection and disable the control
                        allCtrl.Clear()
                        For Each ddl As WebControls.DropDownList In FindCtrl(allCtrl, frm, GetType(WebControls.DropDownList))
                            ddl.Enabled = ddl.ID.EqualsAny(drFiltered("ExceptionControlList").ToString().Split(","))
                        Next

                        'Disable Button
                        'Loop through the collection and disable the control
                        allCtrl.Clear()
                        For Each btn As WebControls.Button In FindCtrl(allCtrl, frm, GetType(WebControls.Button))
                            btn.Enabled = (btn.ID.EqualsAny(drFiltered("ExceptionControlList").ToString().Split(",")) Or btn.Text.EqualsAny(drFiltered("ExceptionCtrlList").ToString().Split(",")))
                        Next

                        'Hide RadioButton
                        'Loop through the collection and disable the control
                        allCtrl.Clear()
                        For Each rbtn As WebControls.RadioButton In FindCtrl(allCtrl, frm, GetType(WebControls.RadioButton))
                            rbtn.Enabled = rbtn.ID.EqualsAny(drFiltered("ExceptionControlList").ToString().Split(","))
                        Next

                        'Hide RadioButtonList
                        'Loop through the collection and disable the control
                        allCtrl.Clear()
                        For Each rbtnlst As WebControls.RadioButtonList In FindCtrl(allCtrl, frm, GetType(WebControls.RadioButtonList))
                            rbtnlst.Enabled = rbtnlst.ID.EqualsAny(drFiltered("ExceptionControlList").ToString().Split(","))
                        Next

                    End If

                Catch ex As Exception

                    Dim strMessage As String = "The following Error occured in ToggleReview:  " & ex.Message

                    ASPNETMsgBox(strMessage)

                End Try

            End If

        End Sub

        Public Function CreateTempFile(Optional sFileSuffix As String = "",
                                       Optional sFilePrefix As String = "") As String

            Dim sfile As String = ""

            If sFilePrefix = "" Then sFilePrefix = HttpContext.Current.Session.SessionID.ToString()
            sfile = HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & sFilePrefix & sFileSuffix & ".xml"

            Return sfile

        End Function

        Public Sub DeleteTempFiles(Optional sFile As String = "")

            Try

                'Delete user temporary files.
                Dim SourceDir As String = HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\"

                If sFile = "" Then
                    sFile = HttpContext.Current.Session.SessionID.ToString() & "*.*"
                Else
                    Dim aFile As String()
                    aFile = sFile.Split("\")
                    sFile = aFile.Last()

                    aFile.RemoveAt(aFile.GetUpperBound(0))
                    SourceDir = String.Join("\", aFile)
                End If

                Dim UserFileList As String() = Directory.GetFiles(SourceDir, sFile)

                For Each f As String In UserFileList
                    File.Delete(f)
                Next

            Catch ex As Exception

            End Try

        End Sub

        Public Function KeyValPairToString(KeyValPair As List(Of Param)) As String

            Dim spVal As String = ""
            For Each aParam As Param In KeyValPair
                If spVal <> "" Then spVal &= "|"
                spVal &= aParam.ToString()
            Next

            Return spVal

        End Function

        ''' <summary>
        ''' Validates a string as a date no later than current date
        ''' </summary>
        ''' <param name="sDoB"></param>
        ''' <returns></returns>
        Public Function ValidateDOB(ByVal sDoB As String) As Boolean
            If sDoB.Length = 0 Then
                Return True
            Else
                If IsDate(sDoB) Then
                    Return CType(sDoB, DateTime) <= DateTime.Today
                Else
                    Return False
                End If
            End If
        End Function

        Public Sub EnableForm(ByRef ctrl As Web.UI.Control, ByVal enabled As Boolean)

            'Collection of control of given type are collected in this variable
            Dim allCtrl As New List(Of Control)

            'TextBox
            'Loop through the collection and disable the control
            For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.TextBox))
                txt.Enabled = enabled
            Next

            For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                txt.Enabled = enabled
            Next

            For Each txt As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                txt.Enabled = enabled
            Next

            'Disable CheckBox
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each chk As WebControls.CheckBox In FindCtrl(allCtrl, ctrl, GetType(WebControls.CheckBox))
                chk.Enabled = enabled
            Next

            'Disable DropDownList
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each ddl As WebControls.DropDownList In FindCtrl(allCtrl, ctrl, GetType(WebControls.DropDownList))
                ddl.Enabled = enabled
            Next

            'Hide RadioButton
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each rbtn As WebControls.RadioButton In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButton))
                rbtn.Enabled = enabled
            Next

            'allCtrl.Clear()
            'For Each btn As WebControls.Button In FindCtrl(allCtrl, ctrl, GetType(WebControls.Button))
            '    btn.Visible = enabled
            'Next

            'allCtrl.Clear()
            'For Each hbtn As HtmlControls.HtmlButton In FindCtrl(allCtrl, ctrl, GetType(HtmlControls.HtmlButton))
            '    hbtn.Visible = enabled
            'Next

            'Hide RadioButtonList
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each rbtnlst As WebControls.RadioButtonList In FindCtrl(allCtrl, ctrl, GetType(WebControls.RadioButtonList))
                rbtnlst.Enabled = enabled
            Next

            'Disable/enable EIDSS Drop Down
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each eidssDropDown As EIDSSControlLibrary.DropDownList In FindCtrl(allCtrl, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                eidssDropDown.Enabled = enabled
            Next

            'Disable/enable Link Buttons
            allCtrl.Clear()
            For Each btn As WebControls.LinkButton In FindCtrl(allCtrl, ctrl, GetType(WebControls.LinkButton))
                btn.Enabled = enabled
            Next

            allCtrl.Clear()
            For Each ddl As WebControls.DropDownList In FindCtrl(allCtrl, ctrl, GetType(LocationUserControl))
                ddl.Enabled = enabled
            Next

            For Each tb As WebControls.TextBox In FindCtrl(allCtrl, ctrl, GetType(LocationUserControl))
                tb.Enabled = enabled
            Next

        End Sub

        Public Sub SaveEIDSSXML(ByVal sModule As String _
                                , ByVal sKeyValPair As String _
                                , Optional ByRef sFile As String = "")

            Dim oXMLDoc As XmlDocument = Nothing
            Dim oXMLNode As XmlNode = Nothing
            Dim oRecordNode As XmlNode = Nothing
            Dim oFieldNode As XmlNode = Nothing

            Try

                oXMLDoc = New XmlDocument
                oXMLNode = oXMLDoc.CreateXmlDeclaration("1.0", "UTF-8", String.Empty)
                oXMLDoc.AppendChild(oXMLNode)

                'Create xml parent node
                oRecordNode = oXMLDoc.CreateElement(sModule)
                oXMLDoc.AppendChild(oRecordNode)

                Dim dKeyValPair As Dictionary(Of String, String()) = New Dictionary(Of String, String()) From {
                    {sModule, sKeyValPair.Split("|")}
                }

                For Each _Field As String In dKeyValPair(sModule)

                    'Add fields to the record
                    oFieldNode = oXMLDoc.CreateElement(_Field.Split(";")(0))
                    oFieldNode.AppendChild(oXMLDoc.CreateTextNode(_Field.Split(";")(1)))
                    oRecordNode.AppendChild(oFieldNode)

                Next

                Dim oWriter As StreamWriter
                If sFile.IsValueNullOrEmpty() Then sFile = CreateTempFile()
                oWriter = New StreamWriter(sFile)
                oXMLDoc.Save(oWriter)
                oWriter.Close()
                oWriter.Dispose()

            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

        End Sub
        Public Sub SaveEIDSSObject(ByVal sData As String _
                                , Optional ByRef sFile As String = "")

            Try

                Dim oWriter As StreamWriter
                oWriter = New StreamWriter(sFile)
                oWriter.Write(sData)
                oWriter.Close()
                oWriter.Dispose()

            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

        End Sub
        Public Function ReadEIDSSXML(Optional ByVal sFile As String = "" _
                                     , Optional bDeleteFileAfterRead As Boolean = False) As DataSet

            Dim oDS As DataSet = Nothing

            Try
                If sFile.IsValueNullOrEmpty() Then sFile = CreateTempFile()
                If sFile <> "" AndAlso File.Exists(sFile) Then
                    oDS = New DataSet
                    oDS.ReadXml(sFile)
                    If oDS.CheckDataSet() Then
                        If bDeleteFileAfterRead Then DeleteTempFiles(sFile)
                    End If
                End If
            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

            Return oDS

        End Function

        Public Function ReadEIDSSObject(Optional ByVal sFile As String = "" _
                                     , Optional bDeleteFileAfterRead As Boolean = False) As DataSet
            Dim deserializedValue As Object = Nothing
            Dim lf As LosFormatter = New LosFormatter()
            Dim sr As StreamReader = New StreamReader(sFile)

            deserializedValue = lf.Deserialize(sr.ReadToEnd())

            lf = Nothing
            If bDeleteFileAfterRead Then DeleteTempFiles(sFile)

            Return deserializedValue
        End Function

        Public Sub GetSearchFields(ByRef ctrls As ICollection(Of Web.UI.Control) _
                                   , sFile As String)

            Dim oDS As DataSet = New DataSet
            oDS = ReadEIDSSXML(sFile)
            If oDS.CheckDataSet() Then
                Dim oComm As New clsCommon
                For Each ctrl In ctrls
                    oComm.Scatter(ctrl, New DataTableReader(oDS.Tables(0)), 0)
                Next
            End If
        End Sub

        Public Sub SaveSearchFields(ByRef ctrls As ICollection(Of Web.UI.Control) _
                                    , sModule As String _
                                    , sFile As String)


            Dim oComm As clsCommon = New clsCommon
            Dim formValues As String = ""
            For Each ctrl In ctrls
                If (formValues = "") Then
                    formValues = oComm.Gather(ctrl)
                Else
                    formValues &= "|" & oComm.Gather(ctrl)
                End If

            Next
            oComm.SaveEIDSSXML(sModule, formValues, sFile)

        End Sub

        ''' <summary>
        ''' Saves a List Of 'Single Value' variables (IE: String, Integer, Boolean, etc...) to an xml file in replacement of the Session object.
        ''' 'Single Value' from viewstates are treated as 'String' objects and will undergo abtraction
        ''' Objects, such as datasets, will be excluded
        ''' </summary>
        ''' <param name="stateBag"></param>
        Public Sub SaveViewState(ByRef stateBag As StateBag)

            Dim formValues As String = ""
            Dim sFile = CreateTempFile("_VState")

            'Form values created will mimic existing EIDSSXML process for continuity.
            For Each key In stateBag.Keys
                If (TypeOf stateBag.Item(key) Is String Or
                        TypeOf stateBag.Item(key) Is Double Or
                        TypeOf stateBag.Item(key) Is Integer) Then
                    formValues &= "|" + key + ";" + stateBag.Item(key).ToString() + ";IN"
                ElseIf (TypeOf stateBag.Item(key) Is DataSet) Then
                    SavePageStateToPersistenceMedium(stateBag.Item(key), key)
                End If
            Next

            SaveEIDSSXML("createViewStateToSession", formValues.Substring(1), sFile)

        End Sub

        Private Sub SavePageStateToPersistenceMedium(obj As Object, key As String)
            Dim lf As LosFormatter = New LosFormatter()
            Dim sw As StringWriter = New StringWriter()
            Dim sb As System.Text.StringBuilder = New System.Text.StringBuilder()
            Dim fileName As String = ""

            lf.Serialize(sw, obj)
            sb = sw.GetStringBuilder()

            Dim sType As String = obj.GetType.ToString()
            Dim sFile = CreateTempFile("_" & key & "_VState")

            SaveEIDSSObject(sb.ToString(), sFile)
        End Sub

        ''' <summary>
        ''' Retreives a set of values, relating to entries made into the ViewState 
        ''' </summary>
        Public Function GetViewState(Optional bDeleteFileAfterRead As Boolean = False) As NameValueCollection
            Dim sFile = CreateTempFile("_VState")

            Dim oDS As DataSet = New DataSet

            oDS = ReadEIDSSXML(sFile, bDeleteFileAfterRead)

            Dim nvc As NameValueCollection = New NameValueCollection

            If Not oDS Is Nothing Then
                If oDS.Tables.Count > 0 Then
                    For Each dColumn As Data.DataColumn In oDS.Tables(0).Columns
                        nvc.Add(dColumn.ToString(), oDS.Tables(0).Rows(0).Item(dColumn.ToString()).ToString())

                    Next
                End If
            End If

            Return nvc

        End Function

        Public Function GetViewState(Optional bDeleteFileAfterRead As Boolean = False, Optional sDataName As String = "") As DataSet
            Dim sFile = CreateTempFile("_" & sDataName & "_VState").Replace("__", "_")

            Return ReadEIDSSObject(sFile, bDeleteFileAfterRead)

        End Function

        ''' <summary>
        ''' Saves a List Of customObjects to an xml file 
        ''' </summary>
        ''' <param name="oList"></param>
        ''' <param name="fileName"></param>
        Public Sub SerializeListToXmlFile(ByRef oList As List(Of clsHumanDiseaseTest), fileName As String)
            'Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(oList.GetType())
            Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseTest)))
            Dim fw As IO.StreamWriter
            Dim sFile As String = fileName
            If sFile <> "" Then
                fw = New IO.StreamWriter(sFile)
                oSerializer.Serialize(fw, oList)
                fw.Flush()
                fw.Close()
                fw.Dispose()
            End If
        End Sub

        ''' <summary>
        ''' Hydrates a List Of customObjects from an xml file 
        ''' </summary>
        ''' <param name="oList"></param>
        ''' <param name="fileName"></param>
        Public Sub HydrateListFromXmlFile(ByRef oList As List(Of clsHumanDiseaseTest), FileName As String)
            Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseTest)))
            Dim fs As IO.FileStream
            Dim sFile As String = FileName
            If sFile <> "" AndAlso IO.File.Exists(sFile) Then
                fs = New IO.FileStream(sFile, IO.FileMode.Open)
                oList = oSerializer.Deserialize(fs)
                fs.Close()
                fs.Dispose()
            End If
        End Sub

        ''' <summary>
        ''' Saves a List Of customObjects to an xml file 
        ''' </summary>
        ''' <param name="oList"></param>
        ''' <param name="fileName"></param>
        Public Sub SerializeListToXmlFile(ByRef oList As List(Of clsHumanDiseaseSample), fileName As String)
            'Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(oList.GetType())
            Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseSample)))
            Dim fw As IO.StreamWriter
            Dim sFile As String = fileName
            If sFile <> "" Then
                fw = New IO.StreamWriter(sFile)
                oSerializer.Serialize(fw, oList)
                fw.Flush()
                fw.Close()
                fw.Dispose()
            End If
        End Sub

        ''' <summary>
        ''' Hydrates a List Of customObjects from an xml file 
        ''' </summary>
        ''' <param name="oList"></param>
        ''' <param name="fileName"></param>
        Public Sub HydrateListFromXmlFile(ByRef oList As List(Of clsHumanDiseaseSample), FileName As String)
            Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseSample)))
            Dim fs As IO.FileStream
            Dim sFile As String = FileName
            If sFile <> "" AndAlso IO.File.Exists(sFile) Then
                fs = New IO.FileStream(sFile, IO.FileMode.Open)
                oList = oSerializer.Deserialize(fs)
                fs.Close()
                fs.Dispose()
            End If
        End Sub




        ''' <summary>
        ''' Validates two strings as dates, FROM date must be before TO date, either can be empty. We assume at least one has a value. 
        ''' </summary>
        ''' <param name="sFrom"></param>
        ''' <param name="sTo"></param>
        ''' <returns>boolean value, isValid</returns>
        Public Function ValidateFromToDates(ByVal sFrom As String, ByVal sTo As String) As Boolean

            'we begin by assuming one or both have values
            'if one has a value, return isValid=true
            If (sFrom.Length = 0 And sTo.Length > 0) Or (sFrom.Length > 0 And sTo.Length = 0) Then
                Return (IsDate(sFrom) Or IsDate(sTo))
            ElseIf (IsDate(sFrom) And IsDate(sTo)) Then 'here we know both have a value that can be converted to a date
                Return CType(sFrom, DateTime) <= CType(sTo, DateTime)       'if sFrom <= sTo then return isValid=true
            Else
                Return False                                                'if sFrom > sTo then return isValid=false
            End If

        End Function


        Public Function CreateDataTable(ByVal tableName As String) As DataTable

            Dim KeyValPair As New List(Of Param) From {
                New Param() With {.ParamName = "table_name", .ParamValue = tableName, .ParamMode = "IN"}
            }
            Dim oComm As clsCommon = New clsCommon
            Dim oService As EIDSSService = oComm.GetService()
            Dim oDS As DataSet
            Dim oTuple = oService.GetData(GetCurrentCountry(), "GetTableColumns", oComm.KeyValPairToString(KeyValPair))
            oDS = DirectCast(oTuple.m_Item1, DataSet)

            Dim dt = New DataTable()
            Dim dc As DataColumn
            If oDS.CheckDataSet() Then
                For i = 0 To oDS.Tables(0).Rows.Count - 1
                    dc = New DataColumn With {
                        .ColumnName = oDS.Tables(0).Rows(i).Item("COLUMN_NAME")
                    }
                    dt.Columns.Add(dc)
                Next
            End If

            Return dt

        End Function

        Public Function GetValidatorParent(ByVal validator As IValidator) As HtmlGenericControl

            Dim section As HtmlGenericControl = Nothing
            Select Case validator.GetType().Name
                Case "RequiredFieldValidator"
                    Dim failedValidator As RequiredFieldValidator = validator
                    section = FindImmediateParentOfTag("section", failedValidator.Parent)
                Case "CompareValidator"
                    Dim failedValidator As CompareValidator = validator
                    section = FindImmediateParentOfTag("section", failedValidator.Parent)
                Case "RangeValidator"
                    Dim failedValidator As RangeValidator = validator
                    section = FindImmediateParentOfTag("section", failedValidator.Parent)
                Case "RegularExpressionValidator"
                    Dim failedValidator As RegularExpressionValidator = validator
                    section = FindImmediateParentOfTag("section", failedValidator.Parent)
            End Select

            Return section

        End Function

        Public Class Param

            Implements IEquatable(Of Param)

            Public Property ParamName() As String
                Get
                    Return m_ParamName
                End Get
                Set(value As String)
                    m_ParamName = value
                End Set
            End Property

            Private m_ParamName As String

            Public Property ParamValue() As String
                Get
                    Return m_ParmValue
                End Get
                Set(value As String)
                    m_ParmValue = value
                End Set
            End Property

            Private m_ParmValue As String

            Public Property ParamValueDT() As DataTable
                Get
                    Return m_ParmValueDT
                End Get
                Set(value As DataTable)
                    m_ParmValueDT = value
                End Set
            End Property

            Private m_ParmValueDT As DataTable

            Public Property ParamMode() As String
                Get
                    Return m_ParmMode
                End Get
                Set(value As String)
                    m_ParmMode = value
                End Set
            End Property

            Private m_ParmMode As String

            Public Property ParamTypeName() As String
                Get
                    Return m_ParmTypeName
                End Get
                Set(value As String)
                    m_ParmTypeName = value
                End Set
            End Property

            Private m_ParmTypeName As String

            Public Overrides Function ToString() As String

                If ParamTypeName = Nothing Then
                    Return ParamName & ";" & ParamValue & ";" & ParamMode
                Else
                    Return ParamName & ";" & ParamValue & ";" & ParamMode & ";" & ParamTypeName
                End If

            End Function

            Public Overrides Function Equals(obj As Object) As Boolean
                If obj Is Nothing Then
                    Return False
                End If
                Dim objAsParam As Param = TryCast(obj, Param)
                If objAsParam Is Nothing Then
                    Return False
                Else
                    Return Equals(objAsParam)
                End If
            End Function

            Public Overloads Function Equals(other As Param) As Boolean _
                Implements IEquatable(Of Param).Equals
                If other Is Nothing Then
                    Return False
                End If
                Return (Me.ParamName.Equals(other.ParamName))
            End Function

            ' Should also override == and != operators.
        End Class

        Public Class ListItemComparer : Implements IComparer

            Public Function Compare(ByVal x As Object,
                  ByVal y As Object) As Integer _
                  Implements IComparer.Compare

                Dim a As ListItem = x
                Dim b As ListItem = y
                Dim c As New CaseInsensitiveComparer
                Return c.Compare(a.Text, b.Text)

            End Function

        End Class

    End Class

End Namespace
