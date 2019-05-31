Imports System.Globalization
Imports System.Resources
Imports System.IO
Imports System.Xml

Public Class ResourceEditor
    Inherits BaseEidssPage

    Protected Property BaseDirectoryUri As String = HttpRuntime.AppDomainAppPath

    Protected Property Modules As Dictionary(Of String, String)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack() Then

            ListLanguages()

            ListModules()

            ListResourceFiles()

            ListNewLanguages()

            'Set various attributes
            ddlResources.Enabled = False
            gvResourceList.Visible = False
            rdoText.Checked = True
        End If

    End Sub

    Private Sub ResourceEditor_Error(sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then

            ASPNETMsgBox("An error occurred on this page. Please verify your information to resolve the issue.")

        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & Me.GetType.Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()

    End Sub

#Region "DROPDOWNLIST EVENTS (ALL)"
    Private Sub ddlLanguages_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlLanguages.SelectedIndexChanged

        If (String.IsNullOrEmpty(ddlLanguages.SelectedValue) = False) And
           (String.IsNullOrEmpty(ddlModule.SelectedValue) = False) Then
            ClearResourceGrid()
            ListResourceFiles()
            EnableCopyButton()
        End If
    End Sub

    Private Sub ddlModule_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlModule.SelectedIndexChanged

        If (String.IsNullOrEmpty(ddlLanguages.SelectedValue) = False) And
           (String.IsNullOrEmpty(ddlModule.SelectedValue) = False) Then
            ClearResourceGrid()
            ListResourceFiles()
            EnableCopyButton()
        End If

    End Sub

    Private Sub ddlResources_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlResources.SelectedIndexChanged

        If (ddlResources.SelectedIndex <> 0) Then
            FillResourceGridView()
            EnableCopyButton()
        End If

    End Sub

#End Region

#Region "Radio Button events"
    Protected Sub EditOptionsChanged(sender As Object, e As EventArgs)
        If (ddlResources.SelectedIndex <> 0) Then
            FillResourceGridView()
            EnableCopyButton()
        End If
    End Sub
#End Region

#Region "GRID VIEW EVENTS"
    Private Sub gvResourceList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvResourceList.PageIndexChanging

        gvResourceList.PageIndex = e.NewPageIndex
        FillResourceGridView()

    End Sub

    Private Sub gvResourceList_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvResourceList.RowEditing

        gvResourceList.EditIndex = e.NewEditIndex
        FillResourceGridView()

    End Sub

    Private Sub gvResourceList_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvResourceList.RowCancelingEdit

        gvResourceList.EditIndex = -1
        FillResourceGridView()

    End Sub

    Private Sub gvResourceList_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvResourceList.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then

            Dim rowState As DataControlRowState = e.Row.RowState
            Dim editState As DataControlRowState = DataControlRowState.Edit
            Dim alternateEditState As DataControlRowState = DataControlRowState.Edit Or DataControlRowState.Alternate
            If (rowState = editState) Or
               (rowState = alternateEditState) Then

                Dim textControl = TryCast(e.Row.FindControl("editText"), TextBox)
                Dim chkTrueFalse = TryCast(e.Row.FindControl("chkTrueFalseValue"), CheckBox)

                If IsNothing(textControl) Or
                    IsNothing(chkTrueFalse) Then
                    Return
                End If

                ' by default all controls should be not visible
                textControl.Visible = False
                chkTrueFalse.Visible = False

                Dim rowView As DataRowView = e.Row.DataItem

                If IsNothing(rowView) Then
                    Return
                End If

                Dim dataKey As String = rowView(0).ToString().ToLower()

                If dataKey.Contains(".enabled") Or
                   dataKey.Contains(".visible") Then
                    chkTrueFalse.Visible = True
                    Boolean.TryParse(textControl.Text, chkTrueFalse.Checked)
                Else
                    textControl.Visible = True
                End If
            End If
        End If
    End Sub

    Private Sub gvResourceList_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvResourceList.RowUpdating

        Dim sFilename As String = BaseDirectoryUri & ddlResources.SelectedValue

        Dim lblRowCounter As Label = gvResourceList.Rows(e.RowIndex).FindControl("rowCounter")
        Dim intID As Integer = lblRowCounter.Text

        Dim txtResourceValue As TextBox = gvResourceList.Rows(e.RowIndex).FindControl("editText")
        Dim chkResourceValue As CheckBox = gvResourceList.Rows(e.RowIndex).FindControl("chkTrueFalseValue")
        Dim valueToSave As String = String.Empty

        Dim dataKey As String = e.Keys(0).ToString().ToLower()

        If dataKey.Contains(".enabled") Or
           dataKey.Contains(".visible") Then
            valueToSave = chkResourceValue.Checked.ToString()
        Else
            valueToSave = txtResourceValue.Text
        End If

        Dim xmlDoc As XmlDocument = New XmlDocument()
        xmlDoc.Load(sFilename)

        Dim nlist As XmlNodeList = xmlDoc.GetElementsByTagName("data")

        For Each node In nlist
            Dim element As XmlNode = node
            If element.Attributes("name").Value.ToString().ToLower() = e.Keys(0).ToString().ToLower() Then
                Dim lastnode As XmlNode = element.SelectSingleNode("value")
                lastnode.InnerText = valueToSave
                Exit For
            End If
        Next

        xmlDoc.Save(sFilename)

        gvResourceList.EditIndex = -1
        FillResourceGridView()

    End Sub

#End Region

#Region "FILLING  DROPDOWNLISTS"
    ''' <summary>
    ''' Appends the languages set in web.config to the languages drop down
    ''' </summary>
    Private Sub ListLanguages()

        Dim section As NameValueCollection
        section = CType(ConfigurationManager.GetSection("LocalizationAndCulture"), NameValueCollection)

        If IsNothing(section) Then
            Return
        End If

        ddlLanguages.Items.Clear()

        If section.Keys.Count > 0 Then

            ddlLanguages.Items.Add(New ListItem(GetLocalResourceObject("Itm_Select_Language.Text"), ""))

            For Each key In section.Keys
                ddlLanguages.Items.Add(New ListItem(GetGlobalResourceObject("LanguageList", section(key).ToString().Remove(2, 1)), section(key).ToString()))
            Next

        End If

    End Sub


    ''' <summary>
    ''' Appents languages set in web.config except english US to drop down
    ''' </summary>
    Private Sub ListNewLanguages()
        Dim section As NameValueCollection
        section = CType(ConfigurationManager.GetSection("LocalizationAndCulture"), NameValueCollection)

        If IsNothing(section) Then
            Return
        End If

        ddlNewLanguageSelector.Items.Clear()

        If section.Keys.Count > 0 Then

            ddlNewLanguageSelector.Items.Add(New ListItem(GetLocalResourceObject("Itm_Select_Language.Text"), ""))

            For Each key In section.Keys
                If (section(key).ToString().ToUpper().Equals("EN-US")) Then
                    Continue For
                End If
                ddlNewLanguageSelector.Items.Add(New ListItem(GetGlobalResourceObject("LanguageList", section(key).ToString().Remove(2, 1)), section(key).ToString()))
            Next

        End If
    End Sub


    ''' <summary>
    ''' Appends the Modules found by FindModules Sub to the drop down
    ''' </summary>
    Private Sub ListModules()

        ddlModule.Items.Clear()

        ddlModule.Items.Add(New ListItem(GetLocalResourceObject("Itm_Select_Module.Text"), ""))

        FindModules()

        For Each thing In Modules
            ddlModule.Items.Add(New ListItem(thing.Key, thing.Value))
        Next

    End Sub


    ''' <summary>
    ''' appends list of Resource files found in a given module by selected language
    ''' </summary>
    Private Sub ListResourceFiles()

        ddlResources.Items.Clear()
        ddlResources.Items.Insert(0, New ListItem("Select a Resource File"))
        Dim selectedModule = ddlModule.SelectedValue

        If String.IsNullOrEmpty(selectedModule) Then
            Return
        End If

        Dim dirInfo As DirectoryInfo = New DirectoryInfo(BaseDirectoryUri + selectedModule)

        If (dirInfo.Exists() = False) Then
            Return
        End If

        Dim delimiter As Char = "."
        Dim files = dirInfo.GetFiles()

        For Each file In files
            ' move forward only if it's a resource file
            If file.Name.ToUpper().Contains(".RESX") = False Then
                Continue For
            End If

            Dim fileName As String = CleanUpResourceFileName(file.Name)
            Dim fileParts As String() = fileName.Split(delimiter)
            Dim language As String = fileParts(1).Remove(2, 1)

            If (ddlLanguages.SelectedValue.ToUpper().Remove(2, 1).Equals(language.ToUpper()) = False) Then
                Continue For
            End If
            Dim LanguageAndCulture = fileParts(1).ToUpper()
            Dim fileNameToDisplay = $"{fileParts(0)} ({LanguageAndCulture})"
            ddlResources.Items.Add(New ListItem(fileNameToDisplay, $"{selectedModule}\{file.Name}"))
        Next

        If ddlResources.Items.Count > 0 Then
            ddlResources.Enabled = True
        Else
            ddlResources.Enabled = False
        End If


    End Sub


    ''' <summary>
    ''' Cleans up file names for processing
    ''' </summary>
    ''' <param name="fileName"></param>
    ''' <returns></returns>
    Private Function CleanUpResourceFileName(fileName As String) As String
        ' Too many differences in the file names.. make them more similar
        ' Buttons.resx  - ADD the language en-us
        ' Buttons.es-mx.resx -Do Nothing
        ' Dashboard.aspx.resx - Remove aspx
        ' Dashboard.aspx.es-mx resx - Remove aspx
        Dim delimiter As String = "."
        Dim fileParts As String() = fileName.Split(delimiter)

        Dim ascx As String = ".ascx"
        Dim aspx As String = ".aspx"
        Dim usEnglish As String = "EN-US"

        If (fileParts.Length = 2) Then
            Return $"{fileParts(0)}.en-us.{fileParts(1)}"
        End If

        If (fileName.ToLower().IndexOf(aspx) > 0) Or
            (fileName.ToLower().IndexOf(ascx) > 0) Then

            Dim tempFileName = fileName.Replace(aspx, String.Empty).Replace(ascx, String.Empty)

            fileParts = tempFileName.Split(delimiter)

            If (fileParts.Length = 2) Then
                Return $"{fileParts(0)}.{usEnglish}.{fileParts(1)}"
            Else
                Return tempFileName
            End If
        End If

        Return fileName

    End Function


    ''' <summary>
    ''' Navigates through the application directory structure looking for installed modules
    ''' it populates the property Modules with the results
    ''' </summary>
    Private Sub FindModules()

        If IsNothing(Modules) Then
            Modules = New Dictionary(Of String, String)
        End If

        ' Add top level local Resources
        If HasModules(BaseDirectoryUri) Then
            Modules.Add(GetLocalResourceObject("Itm_Base_Views.Text"), "App_LocalResources")
        End If

        Dim directories = Directory.GetDirectories(BaseDirectoryUri)
        LoopThroughFolders(directories)

    End Sub


    ''' <summary>
    ''' Loops through folder structure looking for "Modules"
    ''' </summary>
    ''' <param name="folders"></param>
    Private Sub LoopThroughFolders(folders As String())

        For Each folder In folders
            If HasModules(folder) Then
                Modules.Add(folder.Substring(BaseDirectoryUri.Length), folder.Substring(BaseDirectoryUri.Length) + "\App_LocalResources")
            End If

            Dim subDirectories As String() = Directory.GetDirectories(folder)
            If (subDirectories.Length > 0) Then
                LoopThroughFolders(subDirectories)
            End If
        Next
    End Sub


    ''' <summary>
    ''' Determines if a given directory path has "modules" (e.g. Human, Vet, lab, etc.)
    ''' </summary>
    ''' <param name="dir"></param>
    ''' <returns>boolean</returns>
    Private Function HasModules(dir As String) As Boolean
        Dim subDirectories = Directory.GetDirectories(dir)

        For Each subDir In subDirectories

            If (subDir.ToLower().Contains("bin\") Or
                    (subDir.ToLower().Contains("obj\"))) Then
                Continue For
            End If

            If (subDir.Contains("App_LocalResources")) Then
                Return True
            End If

        Next

        Return False

    End Function

#End Region

#Region "FILLING THE GRID VIEW"
    ''' <summary>
    ''' This Subroutine will remove the data source from the grid so as to remove it from the display
    ''' </summary>
    Private Sub ClearResourceGrid()
        gvResourceList.DataSource = Nothing
        gvResourceList.DataBind()
        gvResourceList.Caption = String.Empty
    End Sub

    ''' <summary>
    ''' Fills grid view with data from the selected resource file
    ''' </summary>
    Private Sub FillResourceGridView()

        Dim sFilename As String = BaseDirectoryUri + ddlResources.SelectedValue
        Dim oResourceReader As ResXResourceReader = New ResXResourceReader(sFilename)
        Dim oResourceEnumerator As IDictionaryEnumerator = oResourceReader.GetEnumerator()
        Dim dsResourceList As DataSet = New DataSet("ResourceList")
        Dim dtResourceList As DataTable = dsResourceList.Tables.Add("Resource")

        Dim pkKey As DataColumn = dtResourceList.Columns.Add("ResourceKey", Type.GetType("System.String"))
        dtResourceList.Columns.Add("ElementName", Type.GetType("System.String"))
        dtResourceList.Columns.Add("EnglishReadOnly", Type.GetType("System.String"))
        dtResourceList.Columns.Add("ResourceValue", Type.GetType("System.String"))
        dtResourceList.PrimaryKey = New DataColumn() {pkKey}

        While (oResourceEnumerator.MoveNext())
            Dim elementName As String = GetKey(oResourceEnumerator)

            If (SkipThisKey(elementName)) Then
                Continue While
            End If

            If IsNothing(dtResourceList.Rows.Find(elementName)) Then
                If (ddlLanguages.SelectedValue.ToLower() = "en-us") Then
                    dtResourceList.Rows.Add({oResourceEnumerator.Key, elementName, oResourceEnumerator.Value, oResourceEnumerator.Value})
                Else
                    dtResourceList.Rows.Add({oResourceEnumerator.Key, elementName, String.Empty, oResourceEnumerator.Value})
                End If
            End If

        End While

        If (ddlLanguages.SelectedValue.ToLower() <> "en-us") Then
            Dim sEnglishOnlyFileName = sFilename.Replace($".{ddlLanguages.Text}", "")
            If File.Exists(sEnglishOnlyFileName) Then
                oResourceReader = New ResXResourceReader(sEnglishOnlyFileName)
                oResourceEnumerator = oResourceReader.GetEnumerator()
                While (oResourceEnumerator.MoveNext())
                    Dim key As String = GetKey(oResourceEnumerator)

                    If (SkipThisKey(key)) Then
                        Continue While
                    End If

                    If IsNothing(dtResourceList.Rows.Find(key)) Then
                        Dim foundRow As DataRow = dtResourceList.Rows.Find(key)
                        If IsNothing(foundRow) Then
                            Continue While
                        End If
                        foundRow("EnglishReadOnly") = oResourceEnumerator.Value
                    End If

                End While
            End If
        End If

        oResourceReader.Close()
        oResourceReader = Nothing
        Session("ResourceEditorList") = dsResourceList
        gvResourceList.DataSource = dsResourceList
        gvResourceList.DataBind()

        If dsResourceList.Tables("Resource").Rows.Count > 0 Then
            gvResourceList.Visible = True
            gvResourceList.Caption = $"{ddlLanguages.SelectedItem.ToString()} ({ddlResources.SelectedItem})"
        End If
    End Sub

    Private Function GetKey(enumerator As IDictionaryEnumerator)
        Dim splitKey As List(Of String) = enumerator.Key.ToString().Split(".").ToList()
        Dim nameArray As List(Of String) = splitKey(0).Split("_").ToList()
        Dim attribute As String = String.Empty


        If (splitKey.Count > 1) Then
            nameArray.Remove(splitKey(1))
            attribute = splitKey(1)
        Else
            attribute = nameArray.LastOrDefault()
            nameArray.Remove(nameArray.LastOrDefault())
        End If

        Dim key As String = $"{GetFirstPartOfKey(nameArray(0))} {attribute}:"

        For x As Integer = 1 To nameArray.Count - 1
            key += $" {nameArray(x)}"
        Next

        Return key
    End Function

    ''' <summary>
    ''' This function translates the abbreviated part of the key that refers to the Control such as Lbl
    ''' into an english like word such as Label or Button to be displayed on the screen
    ''' </summary>
    ''' <param name="parts"></param>
    ''' <returns></returns>
    Private Function GetFirstPartOfKey(parts As String) As String
        'Private Function GetFirstPartOfKey(parts As String()) As String
        Dim output As String = String.Empty

        Select Case (parts.ToUpper())
            Case "BTN"
                output = "Button "
            Case "DIS"
                output = "Form Control "
            Case "GRD"
                output = "Table "
            Case "HDG"
                output = "Heading "
            Case "LBL", "SPN"
                output = "Label "
            Case "VAL"
                output = "Validator "
            Case "LEG"
                output = "Legend"
            Case Else
                output = parts
        End Select

        'output += parts.Last

        Return output
    End Function

    Private Function SkipThisKey(key As String) As Boolean

        If key.ToLower().Contains("form control  visible") And
            rdoVisibility.Checked Then
            Return False
        End If

        If key.ToLower().Contains("validator") And
           rdoValidation.Checked Then
            Return False
        End If

        If key.ToLower().Contains("req visible") And
                rdoValidation.Checked Then
            Return False
        End If

        If rdoText.Checked Then
            If ((key.ToLower().Contains("form control  visible")) Or
            (key.ToLower().Contains("validator"))) Then
                Return True
            End If
            Return False
        End If

        Return True

    End Function
#End Region

#Region "DUPLICATING RESOURCE FILES"
    Private Sub EnableCopyButton()
        btnNew.Disabled = True
        ' Determine the selected resource file
        ' Determine if the selected  resource file  is a base file "en-us"
        Dim selectedValue As String = CleanUpResourceFileName(ddlResources.SelectedValue)
        If (selectedValue.ToLower().IndexOf("en-us") > 0) Then
            btnNew.Disabled = False
        End If
    End Sub

    Protected Sub btnSelectLanguageClick(sender As Object, e As EventArgs)

        ' first read the original file name and load it into a writer so we can generate the new file
        Dim originalFileName As String = BaseDirectoryUri & ddlResources.SelectedValue
        Dim oResourceReader As ResXResourceReader = New ResXResourceReader(originalFileName)
        Dim oResourceEnumerator As IDictionaryEnumerator = oResourceReader.GetEnumerator()

        Dim newFileName As String = BaseDirectoryUri & CreateNewFileName(ddlResources.SelectedValue)
        Dim oResourceWriter As ResXResourceWriter = New ResXResourceWriter(newFileName)
        Do While (oResourceEnumerator.MoveNext())
            Dim key As String = oResourceEnumerator.Key
            Dim val As String = oResourceEnumerator.Value

            oResourceWriter.AddResource(key, val)
        Loop

        If File.Exists(newFileName) Then
            ' alert the user that the file already exists
            Throw New Exception("file already exists")
        End If

        ' generate the new file
        oResourceWriter.Generate()
        ' dispose of things
        oResourceReader.Close()
        oResourceReader = Nothing
        oResourceWriter.Close()
        oResourceWriter = Nothing


        '  change the selected language
        '  reload the resource list to show the new file
        '  reload the grid with the new file data

        ddlLanguages.Text = ddlNewLanguageSelector.Text
        ListResourceFiles()
        ddlResources.SelectedIndex = FindResourceItem(newFileName)
        FillResourceGridView()

    End Sub

    Private Function FindResourceItem(ByRef valueToCompare As String) As Integer
        Dim output As Integer = -1
        For Each item As ListItem In ddlResources.Items
            If valueToCompare.ToLower().Contains(item.Value.ToLower()) Then
                output = ddlResources.Items.IndexOf(ddlResources.Items.FindByValue(item.Value))
            End If
        Next
        Return output
    End Function


    Private Function CreateNewFileName(oldName As String) As String
        ' incoming value is made up of two parts.. containing folder and file name
        Dim parts As String() = oldName.Split("\")

        Dim output As StringBuilder = New StringBuilder()

        For Each part In parts
            If (part.Contains(".resx")) Then

                Dim fileNameParts As String() = part.Split(".")

                For Each fileNamePart In fileNameParts

                    If fileNamePart.ToLower().Contains("aspx") Or
                        fileNamePart.ToLower().Contains("ascx") Then
                        output.Append($"{fileNamePart}.{ddlNewLanguageSelector.SelectedValue.ToLower()}.")
                    Else
                        output.Append($"{fileNamePart}.")
                    End If

                Next
                output.Remove(output.Length - 1, 1)
            Else
                output.Append($"{part.ToLower()}\")
            End If
        Next
        Return output.ToString()
    End Function

    Protected Sub gvResourceList_Sorting(sender As Object, e As GridViewSortEventArgs)
        Dim oDS As DataSet
        oDS = Session("ResourceEditorList")

        Dim dt As DataTable = oDS.Tables(0)

        If Not IsNothing(dt) Then
            dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression)
            gvResourceList.DataSource = Session("ResourceEditorList")
            gvResourceList.DataBind()
        End If
    End Sub

    Private Function GetSortDirection(ByVal column As String) As String

        ' By default, set the sort direction to ascending.
        Dim sortDirection = "ASC"

        ' Retrieve the last column that was sorted.
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then
            ' Check if the same column is being sorted.
            ' Otherwise, the default value can be returned.
            If sortExpression = column Then
                Dim lastDirection = TryCast(ViewState("SortDirection"), String)
                If lastDirection IsNot Nothing _
                  AndAlso lastDirection = "ASC" Then

                    sortDirection = "DESC"

                End If
            End If
        End If

        ' Save new values in ViewState.
        ViewState("SortDirection") = sortDirection
        ViewState("SortExpression") = column

        Return sortDirection

    End Function
#End Region
End Class