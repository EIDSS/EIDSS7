Imports EIDSS.Client.API_Clients
Imports System.Runtime.CompilerServices
Imports System.Xml
Imports System.IO
Imports System.Data
Imports System.ComponentModel
Imports System.Reflection
Imports OpenEIDSS.Domain
Imports Newtonsoft.Json

Namespace EIDSS

    Public Module CrossCuttingModule

#Region "Global Values"

        Public CrossCuttingAPIService As CrossCuttingServiceClient
        Private ReadOnly Log As log4net.ILog

#End Region

#Region "Constructors"

        ''' <summary>
        ''' 
        ''' </summary>
        Sub New()

            CrossCuttingAPIService = New CrossCuttingServiceClient()
            Log = log4net.LogManager.GetLogger(GetType(CrossCuttingModule))

        End Sub

#End Region

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

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="control"></param>
        ''' <param name="referenceTypeName"></param>
        ''' <param name="accessoryCode"></param>
        ''' <param name="blankRow"></param>
        Public Sub FillBaseReferenceDropDownList(control As DropDownList, referenceTypeName As String, Optional accessoryCode As Integer = 0, Optional blankRow As Boolean = False)

            Dim list As List(Of GblLkupBaseRefGetListModel) = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), referenceTypeName, accessoryCode).Result.OrderBy(Function(x) x.name).ToList()

            Try
                If (Not (control Is Nothing)) Then
                    control.Items.Clear()
                    control.Populate(list, BaseReferenceConstants.Name, BaseReferenceConstants.idfsBaseReference, Nothing, Nothing, blankRow)
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="control"></param>
        ''' <param name="referenceTypeName"></param>
        ''' <param name="accessoryCode"></param>
        ''' <param name="blankRow"></param>
        Public Sub FillBaseReferenceListBox(control As ListBox, referenceTypeName As String, Optional accessoryCode As Integer = 0, Optional blankRow As Boolean = False)

            Dim list As List(Of GblLkupBaseRefGetListModel) = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), referenceTypeName, accessoryCode).Result.OrderBy(Function(x) x.name).ToList()

            Try
                If (Not (control Is Nothing)) Then
                    control.Items.Clear()
                    control.Populate(list, BaseReferenceConstants.Name, BaseReferenceConstants.idfsBaseReference, Nothing, Nothing, blankRow)
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <typeparam name="T"></typeparam>
        ''' <param name="control"></param>
        ''' <param name="list"></param>
        ''' <param name="FilterKey"></param>
        ''' <param name="valueColumnName"></param>
        ''' <param name="displayColumnName"></param>
        ''' <param name="currentValue"></param>
        ''' <param name="currentText"></param>
        ''' <param name="blankRow"></param>
        Public Sub FillDropDownList(Of T)(control As DropDownList, list As List(Of T), FilterKey() As String, valueColumnName As String, displayColumnName As String,
                                    Optional currentValue As String = Nothing, Optional currentText As String = Nothing, Optional blankRow As Boolean = False)

            'TODO: Add back filtering.
            'If oDS Is Nothing Then
            '    ds = GetDataSet(eidssType, FilterKey)
            '    oDS = ds
            'Else
            '    If FilterKey Is Nothing Then
            '        ds = oDS
            '    Else
            '        ds = FilterDataSet(oDS, FilterKey)
            '    End If
            'End If

            Try
                If Not control Is Nothing Then
                    control.Items.Clear()
                    control.SelectedValue = Nothing
                    control.Populate(list, displayColumnName, valueColumnName, currentValue, currentText, blankRow)
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <typeparam name="T"></typeparam>
        ''' <param name="ddl"></param>
        ''' <param name="source"></param>
        ''' <param name="DataTextField"></param>
        ''' <param name="DataValueField"></param>
        ''' <param name="CurrentValue"></param>
        ''' <param name="CurrentText"></param>
        ''' <param name="AddEmptyItem"></param>
        <Extension()>
        Public Sub Populate(Of T)(ddl As DropDownList, source As List(Of T), DataTextField As String, DataValueField As String, Optional CurrentValue As String = Nothing,
                            Optional CurrentText As String = Nothing, Optional AddEmptyItem As Boolean = False)

            ddl.DataSource = source
            ddl.DataTextField = DataTextField
            ddl.DataValueField = DataValueField

            Try
                ddl.DataBind()
            Catch ex As Exception
                Throw
            End Try

            If AddEmptyItem Then ddl.Items.Insert(0, New ListItem("", "null"))

            Try
                'Or (CurrentValue = 0) ==> added by Asim to resolve an exception;
                If (CurrentValue Is Nothing) Or (CurrentValue = 0) Then
                    If CurrentText Is Nothing Then
                        ddl.SelectedIndex = 0
                    Else
                        ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByText(CurrentText))
                    End If
                Else
                    ddl.SelectedValue = CurrentValue
                End If
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)

                Throw
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <typeparam name="T"></typeparam>
        ''' <param name="ddl"></param>
        ''' <param name="source"></param>
        ''' <param name="DataTextField"></param>
        ''' <param name="DataValueField"></param>
        ''' <param name="CurrentValue"></param>
        ''' <param name="CurrentText"></param>
        ''' <param name="AddEmptyItem"></param>
        <Extension()>
        Public Sub Populate(Of T)(ddl As ListBox, source As List(Of T), DataTextField As String, DataValueField As String, Optional CurrentValue As String = Nothing,
                            Optional CurrentText As String = Nothing, Optional AddEmptyItem As Boolean = False)

            ddl.DataSource = source
            ddl.DataTextField = DataTextField
            ddl.DataValueField = DataValueField

            Try
                ddl.DataBind()
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
                Throw
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
                Throw
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="fileSuffix"></param>
        ''' <param name="filePrefix"></param>
        ''' <returns></returns>
        Public Function CreateTempFile(Optional fileSuffix As String = "",
                                       Optional filePrefix As String = "") As String

            Dim fileName As String = ""

            Try
                If filePrefix = "" Then filePrefix = HttpContext.Current.Session.SessionID.ToString()
                fileName = HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & filePrefix & fileSuffix & ".xml"

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return fileName

        End Function

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="fileName"></param>
        Public Sub DeleteTempFiles(Optional fileName As String = "")

            Try
                'Delete user temporary files.
                Dim SourceDir As String = HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\"

                If fileName = "" Then
                    fileName = HttpContext.Current.Session.SessionID.ToString() & "*.*"
                Else
                    Dim aFile As String()
                    aFile = fileName.Split("\")
                    fileName = aFile.Last()

                    aFile.RemoveAt(aFile.GetUpperBound(0))
                    SourceDir = String.Join("\", aFile)
                End If

                Dim UserFileList As String() = Directory.GetFiles(SourceDir, fileName)

                For Each f As String In UserFileList
                    File.Delete(f)
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <typeparam name="T"></typeparam>
        ''' <param name="parentControl"></param>
        ''' <param name="entity">Name of the class/object containing the properties.  Typically this will be the model generated from POCO.</param>
        ''' <param name="prefixLength">Length of the prefix of a control name such as txt, ddl, rad, etc.  This will be removed on comparing to the property name.</param>
        ''' <param name="includeUserControlName">Set to true when multiple instances of the same control are used on a page/container.</param>
        ''' <returns>Returns the class/object as type T.</returns>
        Public Function Gather(Of T)(ByRef parentControl As Control, entity As T, Optional prefixLength As Integer = 3, Optional includeUserControlName As Boolean = False) As T

            Dim entityType As Type = GetType(T)
            Dim properties As PropertyDescriptorCollection = TypeDescriptor.GetProperties(entityType)
            Dim controls As New List(Of Control)
            Dim fullFormFieldID As String()
            Dim formFieldID As String

            Try
                For Each prop As PropertyDescriptor In properties
                    controls.Clear()
                    For Each c As TextBox In FindControlList(controls, parentControl, GetType(TextBox))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.Text.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.Text, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As HiddenField In FindControlList(controls, parentControl, GetType(HiddenField))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim convertedValue = If(c.Value.IsValueNullOrEmpty(), Nothing, CustomConvert(c.Value, propType))
                                    prop.SetValue(entity, convertedValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As CheckBoxList In FindControlList(controls, parentControl, GetType(CheckBoxList))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.SelectedValue.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.SelectedValue, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As DropDownList In FindControlList(controls, parentControl, GetType(DropDownList))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.SelectedValue.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.SelectedValue, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As EIDSSControlLibrary.DropDownList In FindControlList(controls, parentControl, GetType(EIDSSControlLibrary.DropDownList))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then

                            'TODO: MD: Remove this patch after the location control is matched with application code
                            '          Currently the location control Region is idfsRegion, Rayon is idfsRayon, Settlement is idfsSettlement
                            '          The API understands Region as RegionID, Rayon as RayonID and Settlement as SettlementID
                            '          The use of this patch may require to set ClientIDMode as Static and/or send different prefix length

                            Dim locNames As String() = {"IDFSREGION", "IDFSRAYON", "IDFSSETTLEMENT"}
                            Dim appNames As String() = {"REGIONID", "RAYONID", "SETTLEMENTID"}
                            Dim blnReadValue As Boolean = False
                            If formFieldID.Substring(prefixLength).ToUpper().EqualsAny(locNames) Then
                                If prop.Name.ToUpper().EqualsAny(appNames) Then
                                    blnReadValue = (formFieldID.Substring(prefixLength).ToUpper().Replace("IDFS", "") = prop.Name.ToUpper().Replace("ID", ""))
                                End If
                            End If

                            'End of Patch

                            If ((formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper()) Or blnReadValue) Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = Nothing
                                    If c.ID.Contains("idfsPostalCode") Then 'Use selected item text on the location postal code as the Geo Location table stores the string value; not the ID.
                                        If c.SelectedItem Is Nothing Then
                                            safeValue = Nothing
                                        Else
                                            safeValue = If(c.SelectedValue.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.SelectedItem.Text, propType))
                                        End If
                                    Else
                                        safeValue = If(c.SelectedValue.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.SelectedValue, propType))
                                    End If
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As EIDSSControlLibrary.NumericSpinner In FindControlList(controls, parentControl, GetType(EIDSSControlLibrary.NumericSpinner))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.Text.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.Text, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As EIDSSControlLibrary.CalendarInput In FindControlList(controls, parentControl, GetType(EIDSSControlLibrary.CalendarInput))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.Text.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.Text, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As RadioButtonList In FindControlList(controls, parentControl, GetType(RadioButtonList))
                        fullFormFieldID = c.ClientID.Split("_")
                        formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.SelectedValue.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.SelectedValue, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As ListBox In FindControlList(controls, parentControl, GetType(ListBox))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.SelectedValue.IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.SelectedValue, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As CheckBox In FindControlList(controls, parentControl, GetType(CheckBox))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.Checked.ToString().IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.Checked, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As RadioButton In FindControlList(controls, parentControl, GetType(RadioButton))
                        fullFormFieldID = c.ClientID.Split("_")

                        If includeUserControlName = True Then
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1).Substring(0, prefixLength) & fullFormFieldID(fullFormFieldID.Count - 2) & fullFormFieldID(fullFormFieldID.Count - 1).Substring(prefixLength)
                        Else
                            formFieldID = fullFormFieldID(fullFormFieldID.Count - 1)
                        End If

                        If formFieldID.Length > prefixLength Then
                            If formFieldID.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    Dim propType = If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType)
                                    Dim safeValue = If(c.Checked.ToString().IsValueNullOrEmpty(), Nothing, Convert.ChangeType(c.Checked, propType))
                                    prop.SetValue(entity, safeValue)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return entity

        End Function

        Private Function CustomConvert(ByVal value As Object, ByVal targetType As Type) As Object

            Dim numericValue As Decimal

            Try
                If (targetType Is GetType(Boolean) OrElse targetType Is GetType(Boolean?)) AndAlso TypeOf value Is String AndAlso Decimal.TryParse(CStr(value), numericValue) Then
                    Return numericValue <> 0
                End If

                Dim valueType = value.[GetType]()
                Dim c1 = TypeDescriptor.GetConverter(valueType)

                If c1.CanConvertTo(targetType) Then
                    Return c1.ConvertTo(value, targetType)
                End If

                Dim c2 = TypeDescriptor.GetConverter(targetType)

                If c2.CanConvertFrom(valueType) Then
                    Return c2.ConvertFrom(value)
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return Convert.ChangeType(value, targetType)

        End Function

        ''' <summary>
        ''' Get values from properties and populate form fields/temporary files.
        ''' Prefix are generally lbl, txt, ddl, cbo, rbl etc. hence prefix length is defaulted to 3.
        ''' If all of the form fields have prefix more then 3 then pass the length.
        ''' For this method to work correctly form fields prefix length in any given "section" should be same
        ''' </summary>
        ''' <param name="ctrl"></param>
        ''' <param name="entity"></param>
        ''' <param name="prefixLength"></param>
        ''' <param name="includeLabels"></param>
        Public Sub Scatter(Of T)(ByRef ctrl As Control, ByRef entity As T, Optional ByVal prefixLength As Integer = 3, Optional includeLabels As Boolean = False)

            If entity Is Nothing Then
                Return
            End If

            Dim entityType As Type = GetType(T)
            Dim properties As PropertyDescriptorCollection = TypeDescriptor.GetProperties(entityType)
            Dim controls As New List(Of Control)
            Dim aFldName As String()
            Dim fieldName As String
            Dim fieldType As String

            Try
                For Each prop As PropertyDescriptor In properties
                    controls.Clear()
                    For Each c As TextBox In FindControlList(controls, ctrl, GetType(TextBox))
                        fieldType = "String"
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    c.Text = entity.GetType().GetProperty(prop.Name).GetValue(entity, Nothing)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As HiddenField In FindControlList(controls, ctrl, GetType(HiddenField))
                        fieldType = "String"
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    c.Value = entity.GetType().GetProperty(prop.Name).GetValue(entity, Nothing)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As CheckBoxList In FindControlList(controls, ctrl, GetType(CheckBoxList))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    If Not c.Items.FindByValue(entity.GetType().GetProperty(prop.Name).GetValue(entity)) Is Nothing Then
                                        c.Items.FindByValue(entity.GetType().GetProperty(prop.Name).GetValue(entity)).Value = entity.GetType().GetProperty(prop.Name).GetValue(entity)
                                    End If
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As CheckBox In FindControlList(controls, ctrl, GetType(CheckBox))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    c.Checked = entity.GetType().GetProperty(prop.Name).GetValue(entity, Nothing)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As DropDownList In FindControlList(controls, ctrl, GetType(DropDownList))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    If Not c.Items.FindByValue(entity.GetType().GetProperty(prop.Name).GetValue(entity)) Is Nothing Then
                                        c.SelectedValue = entity.GetType().GetProperty(prop.Name).GetValue(entity)
                                    End If
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As EIDSSControlLibrary.DropDownList In FindControlList(controls, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    If Not c.Items.FindByValue(entity.GetType().GetProperty(prop.Name).GetValue(entity)) Is Nothing Then
                                        c.SelectedValue = entity.GetType().GetProperty(prop.Name).GetValue(entity)
                                    End If
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As EIDSSControlLibrary.NumericSpinner In FindControlList(controls, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    c.Text = entity.GetType().GetProperty(prop.Name).GetValue(entity, Nothing)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As EIDSSControlLibrary.CalendarInput In FindControlList(controls, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    c.Text = entity.GetType().GetProperty(prop.Name).GetValue(entity, Nothing)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As RadioButton In FindControlList(controls, ctrl, GetType(RadioButton))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    c.Checked = entity.GetType().GetProperty(prop.Name).GetValue(entity, Nothing)
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    controls.Clear()
                    For Each c As RadioButtonList In FindControlList(controls, ctrl, GetType(RadioButtonList))
                        aFldName = c.ClientID.Split("_")
                        fieldName = aFldName(aFldName.Count - 1)
                        If fieldName.Length > prefixLength Then
                            If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                Try
                                    If Not c.Items.FindByValue(entity.GetType().GetProperty(prop.Name).GetValue(entity)) Is Nothing Then
                                        c.Items.FindByValue(entity.GetType().GetProperty(prop.Name).GetValue(entity)).Value = entity.GetType().GetProperty(prop.Name).GetValue(entity)
                                        c.Items.FindByValue(entity.GetType().GetProperty(prop.Name).GetValue(entity)).Selected = True
                                    End If
                                Catch ex As Exception
                                    Throw ex
                                End Try
                            End If
                        End If
                    Next

                    If includeLabels Then
                        controls.Clear()
                        For Each c As Label In FindControlList(controls, ctrl, GetType(Label))
                            aFldName = c.ClientID.Split("_")
                            fieldName = aFldName(aFldName.Count - 1)
                            If fieldName.Length > prefixLength Then
                                If fieldName.Substring(prefixLength).ToUpper() = prop.Name.ToUpper() Then
                                    Try
                                        c.Text = entity.GetType().GetProperty(prop.Name).GetValue(entity, Nothing)
                                    Catch ex As Exception
                                        Throw ex
                                    End Try
                                End If
                            End If
                        Next
                    End If
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' Retreives a set of values, relating to entries made into the ViewState 
        ''' </summary>
        Public Function GetViewState(Optional deleteFileAfterRead As Boolean = False) As NameValueCollection

            Dim fileName = CreateTempFile("_VState")
            Dim ds As DataSet = New DataSet
            Dim nvc As NameValueCollection = New NameValueCollection

            Try
                ds = ReadSearchCriteriaXML(fileName, deleteFileAfterRead)


                If Not ds Is Nothing Then
                    If ds.Tables.Count > 0 Then
                        For Each dColumn As DataColumn In ds.Tables(0).Columns
                            nvc.Add(dColumn.ToString(), ds.Tables(0).Rows(0).Item(dColumn.ToString()).ToString())
                        Next
                    End If
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return nvc

        End Function

        ''' <summary>
        ''' Saves a List Of 'Single Value' variables (IE: String, Integer, Boolean, etc...) to an xml file in replacement of the Session object.
        ''' 'Single Value' from viewstates are treated as 'String' objects and will undergo abtraction
        ''' Objects, such as datasets, will be excluded
        ''' </summary>
        ''' <param name="stateBag"></param>
        Public Sub SaveEIDSSViewState(ByRef stateBag As StateBag)

            Dim formValues As String = ""
            Dim sFile = CreateTempFile("_VState")

            Try
                'Form values created will mimic existing EIDSSXML process for continuity.
                For Each key In stateBag.Keys
                    If (TypeOf stateBag.Item(key) Is String Or
                        TypeOf stateBag.Item(key) Is Double Or
                        TypeOf stateBag.Item(key) Is Int64 Or
                        TypeOf stateBag.Item(key) Is ApplicationActions Or
                        TypeOf stateBag.Item(key) Is Integer) Then
                        formValues &= "|" + key + ";" + stateBag.Item(key).ToString() + ";IN"
                    ElseIf (TypeOf stateBag.Item(key) Is DataSet) Then
                        SavePageStateToPersistenceMedium(stateBag.Item(key), key)
                    End If
                Next

                If formValues.IsValueNullOrEmpty = False Then
                    SaveSearchCriteriaXML("createViewStateToSession", formValues.Substring(1), sFile)
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="obj"></param>
        ''' <param name="key"></param>
        Private Sub SavePageStateToPersistenceMedium(obj As Object, key As String)

            Dim lf As LosFormatter = New LosFormatter()
            Dim sw As StringWriter = New StringWriter()
            Dim sb As System.Text.StringBuilder = New System.Text.StringBuilder()
            Dim fileName As String = ""

            Try
                lf.Serialize(sw, obj)
                sb = sw.GetStringBuilder()

                Dim sType As String = obj.GetType.ToString()
                Dim sFile = CreateTempFile("_" & key & "_VState")

                SaveEIDSSObject(sb.ToString(), sFile)

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="sData"></param>
        ''' <param name="fileName"></param>
        Public Sub SaveEIDSSObject(ByVal sData As String, Optional ByRef fileName As String = "")

            Try
                Dim oWriter As StreamWriter
                oWriter = New StreamWriter(fileName)
                oWriter.Write(sData)
                oWriter.Close()
                oWriter.Dispose()
            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

        End Sub

        ''' <summary>
        ''' Find controls of given type under parent control.
        ''' </summary>
        ''' <param name="list"></param>
        ''' <param name="parent"></param>
        ''' <param name="ctrlType"></param>
        ''' <returns></returns>
        Public Function FindControlList(list As List(Of Control), parent As Control, ctrlType As Type) As List(Of Control)

            Try
                If parent Is Nothing Then Return list

                If parent.GetType Is ctrlType Then
                    list.Add(parent)
                End If

                For Each child As Control In parent.Controls
                    FindControlList(list, child, ctrlType)
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return list

        End Function

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="ctrl"></param>
        ''' <param name="enabled"></param>
        Public Sub EnableForm(ByRef ctrl As Control, ByVal enabled As Boolean)

            'Collection of control of given type are collected in this variable
            Dim allCtrl As New List(Of Control)

            Try
                'TextBox
                'Loop through the collection and disable the control
                For Each txt As TextBox In FindControlList(allCtrl, ctrl, GetType(TextBox))
                    txt.Enabled = enabled
                Next

                For Each txt As TextBox In FindControlList(allCtrl, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                    txt.Enabled = enabled
                Next

                For Each txt As TextBox In FindControlList(allCtrl, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                    txt.Enabled = enabled
                Next

                'Disable CheckBox
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each chk As CheckBox In FindControlList(allCtrl, ctrl, GetType(CheckBox))
                    chk.Enabled = enabled
                Next

                'Disable DropDownList
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each ddl As DropDownList In FindControlList(allCtrl, ctrl, GetType(DropDownList))
                    ddl.Enabled = enabled
                Next

                'Hide RadioButton
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each rbtn As RadioButton In FindControlList(allCtrl, ctrl, GetType(RadioButton))
                    rbtn.Enabled = enabled
                Next

                'Hide RadioButtonList
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each rbtnlst As RadioButtonList In FindControlList(allCtrl, ctrl, GetType(RadioButtonList))
                    rbtnlst.Enabled = enabled
                Next

                'Disable/enable EIDSS Drop Down
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each eidssDropDown As EIDSSControlLibrary.DropDownList In FindControlList(allCtrl, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                    eidssDropDown.Enabled = enabled
                Next

                'Disable/enable Link Buttons
                allCtrl.Clear()
                For Each btn As LinkButton In FindControlList(allCtrl, ctrl, GetType(LinkButton))
                    btn.Enabled = enabled
                Next

                allCtrl.Clear()
                For Each ddl As DropDownList In FindControlList(allCtrl, ctrl, GetType(LocationUserControl))
                    ddl.Enabled = enabled
                Next

                For Each tb As TextBox In FindControlList(allCtrl, ctrl, GetType(LocationUserControl))
                    tb.Enabled = enabled
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="ctrl"></param>
        Public Sub ResetForm(ByRef ctrl As Control)

            'Collection of control of given type are collected in this variable
            Dim allCtrl As New List(Of Control)

            Try
                'TextBox
                'Loop through the collection and disable the control
                For Each txt As TextBox In FindControlList(allCtrl, ctrl, GetType(TextBox))
                    txt.Text = ""
                Next

                For Each txt As TextBox In FindControlList(allCtrl, ctrl, GetType(EIDSSControlLibrary.CalendarInput))
                    txt.Text = ""
                Next

                For Each txt As TextBox In FindControlList(allCtrl, ctrl, GetType(EIDSSControlLibrary.NumericSpinner))
                    txt.Text = ""
                Next

                'Disable CheckBox
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each chk As CheckBox In FindControlList(allCtrl, ctrl, GetType(CheckBox))
                    chk.Checked = False
                Next

                allCtrl.Clear()
                For Each cbl As CheckBoxList In FindControlList(allCtrl, ctrl, GetType(CheckBoxList))
                    cbl.SelectedIndex = -1
                Next

                'Disable DropDownList
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each ddl As DropDownList In FindControlList(allCtrl, ctrl, GetType(DropDownList))
                    ddl.SelectedIndex = -1
                Next

                'Disable EIDSS Control Library DropDownList
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(allCtrl, ctrl, GetType(EIDSSControlLibrary.DropDownList))
                    ddl.SelectedIndex = -1
                Next

                'Hide RadioButton
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each rbtn As RadioButton In FindControlList(allCtrl, ctrl, GetType(RadioButton))
                    rbtn.Checked = False
                Next

                'Hide RadioButtonList
                'Loop through the collection and disable the control
                allCtrl.Clear()
                For Each rbtnlst As RadioButtonList In FindControlList(allCtrl, ctrl, GetType(RadioButtonList))
                    rbtnlst.SelectedIndex = -1
                Next

                allCtrl.Clear()
                For Each gv As GridView In FindControlList(allCtrl, ctrl, GetType(GridView))
                    gv.DataSource = Nothing
                Next

                allCtrl.Clear()
                For Each hf As HiddenField In FindControlList(allCtrl, ctrl, GetType(HiddenField))
                    hf.Value = String.Empty
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="fieldName"></param>
        ''' <param name="dtSchema"></param>
        ''' <param name="prefixLength"></param>
        ''' <param name="fieldType"></param>
        ''' <returns></returns>
        Public Function FindField(ByRef fieldName As String, ByRef dtSchema As DataTable, ByVal prefixLength As Integer, Optional ByRef fieldType As String = "String") As Boolean

            FindField = False

            Try
                Dim columnName As String = ""

                '_PrefixLength is the length of prefix given to form field from database. for e.g, txtName - Where txt is prefix and "Name" is DB field name
                fieldName = fieldName.Substring(prefixLength)
                If Not dtSchema Is Nothing Then
                    For Each drow As DataRow In dtSchema.Rows
                        columnName = System.Convert.ToString(drow("ColumnName"))
                        If fieldName.ToUpper() = columnName.ToUpper() Then
                            fieldType = drow.Item("DataType").Name.ToString()
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

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="moduleName"></param>
        ''' <param name="keyValPair"></param>
        ''' <param name="fileName"></param>
        Public Sub SaveSearchCriteriaXML(ByVal moduleName As String, ByVal keyValPair As String, Optional ByRef fileName As String = "")

            Dim oXMLDoc As XmlDocument = Nothing
            Dim oXMLNode As XmlNode = Nothing
            Dim oRecordNode As XmlNode = Nothing
            Dim oFieldNode As XmlNode = Nothing

            Try
                oXMLDoc = New XmlDocument
                oXMLNode = oXMLDoc.CreateXmlDeclaration("1.0", "UTF-8", String.Empty)
                oXMLDoc.AppendChild(oXMLNode)

                'Create XML parent node
                oRecordNode = oXMLDoc.CreateElement(moduleName)
                oXMLDoc.AppendChild(oRecordNode)

                Dim dKeyValPair As Dictionary(Of String, String()) = New Dictionary(Of String, String()) From {
                    {moduleName, keyValPair.Split("|")}
                }

                For Each _Field As String In dKeyValPair(moduleName)
                    'Add fields to the record
                    oFieldNode = oXMLDoc.CreateElement(_Field.Split(";")(0))
                    oFieldNode.AppendChild(oXMLDoc.CreateTextNode(_Field.Split(";")(1)))
                    oRecordNode.AppendChild(oFieldNode)
                Next

                Dim oWriter As StreamWriter
                If fileName.IsValueNullOrEmpty() Then fileName = CreateTempFile()
                oWriter = New StreamWriter(fileName)
                oXMLDoc.Save(oWriter)
                oWriter.Close()
                oWriter.Dispose()
            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <typeparam name="T"></typeparam>
        ''' <param name="entity"></param>
        ''' <param name="fileName"></param>
        Public Sub SaveSearchCriteriaJSON(Of T)(ByVal entity As T, Optional ByRef fileName As String = "")

            Try
                If fileName.IsValueNullOrEmpty() Then fileName = CreateTempFile()

                File.WriteAllText(fileName, JsonConvert.SerializeObject(entity))
            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="controls"></param>
        ''' <param name="fileName"></param>
        Public Sub GetSearchFields(ByRef controls As ICollection(Of Control), fileName As String)

            Dim ds As DataSet = New DataSet
            Try
                ds = ReadSearchCriteriaXML(fileName)
                If ds.CheckDataSet() Then
                    For Each ctrl In controls
                        Scatter(ctrl, New DataTableReader(ds.Tables(0)), 0)
                    Next
                End If
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="fileName"></param>
        ''' <param name="deleteFileAfterRead"></param>
        ''' <returns></returns>
        Public Function ReadSearchCriteriaXML(Optional ByVal fileName As String = "", Optional deleteFileAfterRead As Boolean = False) As DataSet

            Dim ds As DataSet = Nothing

            Try
                If fileName.IsValueNullOrEmpty() Then fileName = CreateTempFile()
                If fileName <> "" AndAlso File.Exists(fileName) Then
                    ds = New DataSet
                    ds.ReadXml(fileName)
                    If ds.CheckDataSet() Then
                        If deleteFileAfterRead Then DeleteTempFiles(fileName)
                    End If
                End If
            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

            Return ds

        End Function

        Public Function ReadSearchCriteriaJSON(Of T)(entity As T, Optional ByVal fileName As String = "", Optional deleteFileAfterRead As Boolean = False) As T

            Try
                If fileName.IsValueNullOrEmpty() Then fileName = CreateTempFile()
                If fileName <> "" AndAlso File.Exists(fileName) Then
                    ' Read file into a string And deserialize JSON to a type
                    entity = JsonConvert.DeserializeObject(Of T)(File.ReadAllText(fileName))

                    If deleteFileAfterRead Then DeleteTempFiles(fileName)

                    Return entity
                End If
            Catch ex As Exception
                HttpContext.Current.Server.ClearError()
            End Try

        End Function

        ''' <summary>
        ''' Validates a string as a date no later than current date.
        ''' </summary>
        ''' <param name="sDoB"></param>
        ''' <returns></returns>
        Public Function ValidateDateOfBirth(sDoB As String) As Boolean

            Try
                If sDoB.Length = 0 Then
                    Return True
                Else
                    If IsDate(sDoB) Then
                        Return sDoB <= Date.Today
                    Else
                        Return False
                    End If
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Function

        ''' <summary>
        ''' Validates two strings as dates. The from date must be before the to date, either can be empty.
        ''' </summary>
        ''' <param name="fromDate"></param>
        ''' <param name="toDate"></param>
        ''' <returns>boolean value, isValid</returns>
        Public Function ValidateFromToDates(ByVal fromDate As String, ByVal toDate As String) As Boolean

            'Begin by assuming one or both have values
            'If one has a value, then return valid.
            If (fromDate.Length = 0 And toDate.Length > 0) Or (fromDate.Length > 0 And toDate.Length = 0) Then
                Return (IsDate(fromDate) Or IsDate(toDate))
            ElseIf (IsDate(fromDate) And IsDate(toDate)) Then 'Both have a value that can be converted to a date.
                Return fromDate <= CType(toDate, Date) 'If the from date is earlier that the to date then return valid.
            Else
                Return False 'If the from date is past the to date, then return not valid
            End If

        End Function

        Public Function ConvertListToDataTable(Of T)(list As IList(Of T)) As DataTable

            Dim entityType As Type = GetType(T)
            Dim table As New DataTable()
            Dim properties As PropertyDescriptorCollection = TypeDescriptor.GetProperties(entityType)

            Try
                For Each prop As PropertyDescriptor In properties
                    table.Columns.Add(prop.Name, If(Nullable.GetUnderlyingType(prop.PropertyType), prop.PropertyType))
                Next

                For Each item As T In list
                    Dim row As DataRow = table.NewRow()
                    For Each prop As PropertyDescriptor In properties
                        row(prop.Name) = If(prop.GetValue(item), DBNull.Value)
                    Next
                    table.Rows.Add(row)
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return table

        End Function

    End Module

End Namespace
