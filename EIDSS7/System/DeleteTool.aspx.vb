Imports EIDSS.EIDSS
Imports EIDSS.NG
Imports System.Data.SqlClient
Imports System.IO
Imports System.Security.Cryptography
Imports System.Web.Services

Public Class DeleteTool
    Inherits System.Web.UI.Page

    'set to true when released.
    Private bForRelease As Boolean = False
    Private sDeleteVal As String = "0"
    Private sDeleteKey As String = String.Empty
    Private sConfirmMsgKey As String = String.Empty
    Private sConfirmMsgVal As String = String.Empty
    Private bKeySelectd As Boolean = False
    Shared sSQL As String = String.Empty
    Private sw As StreamWriter
    Private LogFile As String
    Private cs As CryptoStream
    Private fsCrypt As FileStream
    Private dsSettings As DataSet
    Private RMCrypto As RijndaelManaged = New RijndaelManaged()
    Private key As Byte() = {145, 12, 32, 245, 98, 132, 98, 214, 6, 77, 131, 44, 221, 3, 9, 50}
    Private iv As Byte() = {15, 122, 132, 5, 93, 198, 44, 31, 9, 39, 241, 49, 250, 188, 80, 7}

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim ds As DataSet = getSettings()

            If CheckDataSet(ds) Then
                Dim dtSearch As DataTable = dsSettings.Tables(0)
                If dtSearch.Rows.Count > 0 Then
                    For Each drSearch As DataRow In dtSearch.Rows
                        ddlSearch.Items.Add(New ListItem(drSearch("SEARCHOPTION"), drSearch("SEARCHLABEL")))
                    Next
                    ddlSearch.SelectedIndex = 0
                End If
            End If
        End If
    End Sub

    Private Function getSettings() As DataSet
        Try
            dsSettings = New DataSet()
            Dim strSettings As String = Server.MapPath("../App_Data/EIDSSDeleteToolSettings.xml")
            dsSettings.ReadXml(strSettings)
            Return dsSettings
        Catch ex As Exception
            Return Nothing
        End Try

    End Function

    Private Function getSelectedDataRow(ByVal ds As DataSet) As DataRow
        getSelectedDataRow = Nothing
        For i As Integer = 0 To dsSettings.Tables(0).Rows.Count - 1 Step 1
            If dsSettings.Tables(0).Rows(i)("SEARCHLABEL") = ddlSearch.SelectedValue Then
                getSelectedDataRow = dsSettings.Tables(0).Rows(i)
                Exit For
            End If
        Next

        Return getSelectedDataRow
    End Function

    Private Function getDataSet(ByVal sql As String, ByVal sParam As String, ByVal sParamVal As String) As DataSet

        Dim oDS As DataSet = New DataSet()
        Try
            Dim oComm As clsCommon = New clsCommon
            Dim oService As EIDSSService = oComm.getService()
            Dim retVal As Object = Nothing
            oService.executeSP(GetCurrentCountry(), sql, Data.CommandType.Text, True, "", True, True, False, True, retVal)

        Catch ex As Exception
            Return Nothing
        End Try

        Return oDS
    End Function

    Private Function CheckDataSet(ds As DataSet) As Boolean
        Try
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    Return True
                Else
                    Return False
                End If
            Else
                Return False
            End If
        Catch
            Return False
        End Try
    End Function

    Private Function EncryptFile(inputFile As String, outputFile As String) As Boolean
        Try
            Dim sFile As String = outputFile
            fsCrypt = New FileStream(sFile, FileMode.Create)

            cs = New CryptoStream(fsCrypt, RMCrypto.CreateEncryptor(key, iv), CryptoStreamMode.Write)

            Dim fsIn As FileStream = New FileStream(inputFile, FileMode.Open)

            Dim Data As Integer
            While ((Data = fsIn.ReadByte()) <> -1)
                cs.WriteByte(Convert.ToByte(Data))
            End While

            fsIn.Close()
            cs.Close()
            fsCrypt.Close()

            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Function DecryptFile(ByVal inputFile As String, ByRef sOutput As String, Optional flOutPut As String = Nothing) As Boolean
        Try

            fsCrypt = New FileStream(inputFile, FileMode.Open)
            cs = New CryptoStream(fsCrypt, RMCrypto.CreateDecryptor(key, iv), CryptoStreamMode.Read)

            If IsNothing(flOutPut) Then
                sOutput = New StreamReader(cs).ReadToEnd()
            Else
                sOutput = String.Empty
                Dim fsOut As FileStream = New FileStream(flOutPut, FileMode.Create)

                Dim Data As Integer
                While ((Data = cs.ReadByte()) <> -1)
                    fsOut.WriteByte(Convert.ToByte(Data))
                End While

                fsOut.Close()
            End If

            cs.Close()
            fsCrypt.Close()

            Return True

        Catch ex As Exception
            sOutput = String.Empty
            Return False
        End Try
    End Function

    Private Shared Function Decrypt(ByVal inputFile As String, ByRef sOutput As String, Optional flOutPut As String = Nothing) As Boolean
        Try

            Dim RMCrypto As RijndaelManaged = New RijndaelManaged()
            Dim key As Byte() = {145, 12, 32, 245, 98, 132, 98, 214, 6, 77, 131, 44, 221, 3, 9, 50}
            Dim iv As Byte() = {15, 122, 132, 5, 93, 198, 44, 31, 9, 39, 241, 49, 250, 188, 80, 7}

            Dim fsCrypt As FileStream = New FileStream(inputFile, FileMode.Open)
            Dim cs As CryptoStream = New CryptoStream(fsCrypt, RMCrypto.CreateDecryptor(key, iv), CryptoStreamMode.Read)

            If IsNothing(flOutPut) Then
                sOutput = New StreamReader(cs).ReadToEnd()
            Else
                sOutput = String.Empty
                Dim fsOut As FileStream = New FileStream(flOutPut, FileMode.Create)

                Dim Data As Integer
                While ((Data = cs.ReadByte()) <> -1)
                    fsOut.WriteByte(Convert.ToByte(Data))
                End While

                fsOut.Close()
            End If

            cs.Close()
            fsCrypt.Close()

            Return True

        Catch ex As Exception
            sOutput = String.Empty
            Return False
        End Try
    End Function

    Private Shared Function Encrypt(inputFile As String, outputFile As String) As Boolean
        Try
            Dim sFile As String = outputFile
            Dim RMCrypto As RijndaelManaged = New RijndaelManaged()
            Dim key As Byte() = {145, 12, 32, 245, 98, 132, 98, 214, 6, 77, 131, 44, 221, 3, 9, 50}
            Dim iv As Byte() = {15, 122, 132, 5, 93, 198, 44, 31, 9, 39, 241, 49, 250, 188, 80, 7}

            Dim fsCrypt As FileStream = New FileStream(inputFile, FileMode.Create)
            Dim cs As CryptoStream = New CryptoStream(fsCrypt, RMCrypto.CreateEncryptor(key, iv), CryptoStreamMode.Write)

            Dim fsIn As FileStream = New FileStream(inputFile, FileMode.Open)

            Dim Data As Integer
            While ((Data = fsIn.ReadByte()) <> -1)
                cs.WriteByte(Convert.ToByte(Data))
            End While

            fsIn.Close()
            cs.Close()
            fsCrypt.Close()

            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Shared Function getData(ByVal sql As String, ByVal sParam As String, ByVal sParamVal As String) As DataSet

        Dim oDS As DataSet = New DataSet()
        Try
            Dim oComm As clsCommon = New clsCommon
            Dim oService As EIDSSService = oComm.getService()
            Dim retVal As Object = Nothing
            oService.executeSP(GetCurrentCountry(), sql, Data.CommandType.Text, True, "", True, True, False, True, retVal)

        Catch ex As Exception
            Return Nothing
        End Try

        Return oDS
    End Function

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim litText = GetLocalResourceObject("Hdg_Alert_Warning.Text")

        If bKeySelectd = False Then
            pnlStatus.Attributes.Remove("class")
            pnlStatus.Attributes.Add("class", "alert alert-warning")
            pnlStatus.Visible = True
            litStatus.Text = "<h4>" & String.Format(litText, sDeleteKey) & "</h4>"
        Else
            Try
                Dim dr As DataRow = Nothing
                Dim dsSearch As DataSet = New DataSet()
                Dim script As String = Server.MapPath("../Scripts/")
                getSettings()
                dr = getSelectedDataRow(dsSearch)
                sConfirmMsgKey = dr("CONFIRMMESSAGEFIELD")

                Dim inputFile As String = Server.MapPath("../Scripts" & dr("DELETESQL"))
                sSQL = String.Empty

                If DecryptFile(inputFile, sSQL) Then
                    If Not String.IsNullOrEmpty(sSQL) Then
                        Dim sParam As String = dr("DELETEPARAM")
                        Dim oDS As DataSet = getDataSet(sSQL, sParam, sDeleteVal)

                        If CheckDataSet(oDS) Then
                            Dim bError As Boolean = False
                            Dim sVal As String = String.Empty

                            For Each Row As DataRow In oDS.Tables(0).Rows
                                sVal = Row(0).ToString()
                                If Not bError Then
                                    bError = sVal.Contains("Error")
                                End If
                            Next

                            If bError Then
                                litText = GetLocalResourceObject("Hdg_Alert_Error.Text")
                                pnlStatus.Attributes.Remove("class")
                                pnlStatus.Attributes.Add("class", "alert alert-danger")
                                pnlStatus.Visible = True
                                litStatus.Text = $"<h4>{litText}</h4>"
                                Exit Sub
                            Else
                                litText = GetLocalResourceObject("Hdg_Alert_Success.Text")
                                pnlStatus.Attributes.Remove("class")
                                pnlStatus.Attributes.Add("class", "alert alert-success")
                                pnlStatus.Visible = True
                                litStatus.Text = $"<h4>{litText}</h4>"
                            End If

                            'write to log after the delete
                            Dim inputLogFile As String = Server.MapPath("../Log/" & txtSearchID.Text.ToString().Trim() & "_Delete_" & DateTime.Now.ToString("yyyyMMddHHmmssfff") + ".xml")
                            Dim outputLogFile As String = inputLogFile.Replace(".xml", "_Encrypted.xml")

                            oDS.WriteXml(inputLogFile)
                            EncryptFile(inputLogFile, outputLogFile)
                            File.Delete(inputLogFile)
                        Else
                            pnlStatus.Attributes.Remove("class")
                            pnlStatus.Attributes.Add("class", "alert alert-info")
                            pnlStatus.Visible = True
                            litText = GetLocalResourceObject("Hdg_Alert_No_Data.Text")
                            litStatus.Text = $"<h4>{litText}</h4>"
                        End If
                    End If
                Else
                    pnlStatus.Attributes.Remove("class")
                    pnlStatus.Attributes.Add("class", "alert alert-danger")
                    pnlStatus.Visible = True
                    litText = GetLocalResourceObject("Hdg_Alert_Delete_Error.Text")
                    litStatus.Text = $"<h4>{litText}</h4>"
                End If
            Catch ex As Exception
                pnlStatus.Attributes.Remove("class")
                pnlStatus.Attributes.Add("class", "alert alert-danger")
                pnlStatus.Visible = True
                litText = GetLocalResourceObject("Hdg_Alert_Delete_Error.Text")
                litStatus.Text = $"<h4>{litText}</h4>"
            End Try
        End If
    End Sub

    'Protected Sub trvDelete_SelectedNodeChanged(sender As Object, e As TreeNodeEventArgs) Handles trvDelete.SelectedNodeChanged
    '    bKeySelectd = False
    '    Dim node As TreeNode = trvDelete.SelectedNode
    '    Dim sVal As String = node.Text
    '    Dim aVal() As String = sVal.Split(":")

    '    'set delete key value
    '    If (aVal(0).ToString().Trim().ToUpper() = sDeleteKey.ToUpper()) Then
    '        bKeySelectd = True
    '        sDeleteVal = aVal(1).ToString().Trim()
    '    End If

    '    'set confirmation value
    '    If bKeySelectd Then

    '        Dim dr As DataRow = Nothing
    '        Dim dsSearch As DataSet = New DataSet()
    '        Dim script As String = Server.MapPath("../Scripts/")
    '        getSettings()
    '        For i As Integer = 0 To dsSettings.Tables(0).Rows.Count - 1 Step 1
    '            If dsSettings.Tables(0).Rows(i)("SEARCHLABEL") = ddlSearch.SelectedValue Then
    '                dr = dsSettings.Tables(0).Rows(i)
    '                Exit For
    '            End If
    '        Next
    '        sConfirmMsgKey = dr("CONFIRMMESSAGEFIELD")

    '        For Each childnode As TreeNode In node.ChildNodes
    '            sVal = childnode.Text
    '            aVal = sVal.Split(":")
    '            If (aVal(0).ToString().Trim().ToUpper() = sConfirmMsgKey.ToUpper()) Then
    '                sConfirmMsgVal = aVal(1).ToString().Trim()
    '            End If
    '        Next
    '    End If
    'End Sub

    <WebMethod()>
    Public Shared Function GetSearchResults(ByVal searchLabel As String, ByVal searchVal As String) As String
        Dim tnc As String = String.Empty

        Dim trv As TreeView = New TreeView()
        Dim ParentNode As TreeNode = New TreeNode("Parent", "parent")
        trv.Nodes.Add(ParentNode)
        Dim rdm As Random = New Random()
        Dim max As Integer = rdm.Next(0, 5)

        For j As Integer = 0 To max - 1
            Dim child As TreeNode = New TreeNode("Child " & (j + 1).ToString(), "child" & (j + 1).ToString())
            ParentNode.ChildNodes.Add(child)

            Dim grandrdm As Random = New Random()
            Dim grandmax As Integer = grandrdm.Next(0, 5)

            For i As Integer = 0 To grandmax - 1
                Dim grandchild As TreeNode = New TreeNode("Grand Child " & (i + 1).ToString(), "grandchild" & (i + 1).ToString())
                child.ChildNodes.Add(grandchild)
            Next
        Next

        'Dim dr As DataRow = Nothing
        'Dim dsSearch As DataSet = New DataSet()
        'Dim dsSettings As DataSet = New DataSet()
        'Dim strSettings As String = HttpContext.Current.Server.MapPath("../App_Data/EIDSSDeleteToolSettings.xml")
        'dsSettings.ReadXml(strSettings)

        'Dim script As String = HttpContext.Current.Server.MapPath("../Scripts/")
        'For i As Integer = 0 To dsSettings.Tables(0).Rows.Count - 1 Step 1
        '    If dsSettings.Tables(0).Rows(i)("SEARCHLABEL") = searchLabel Then
        '        dr = dsSettings.Tables(0).Rows(i)
        '        Exit For
        '    End If
        'Next
        'If Not IsNothing(dr) Then
        '    Dim inputFile As String = script & dr("SEARCHSQL")
        '    Decrypt(inputFile, sSQL)

        '    If Not String.IsNullOrEmpty(sSQL) Then
        '        Dim sParam As String = dr("SEARCHPARAM")
        '        If IsNothing(sParam) Or String.IsNullOrEmpty(sParam) Then
        '            Return Nothing
        '        End If


        'dsSearch = getData(sSQL, sParam, searchVal)
        'If (dsSearch.CheckDataSet()) Then
        '    'write to log after the Search
        '    Dim inputLogFile As String = HttpContext.Current.Server.MapPath("../Log/") & searchVal.ToString().Trim() + "_Search_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + ".xml"
        '    Dim outputLogFile As String = inputLogFile.Replace(".xml", "_Encrypted.xml")

        '    dsSearch.WriteXml(inputLogFile)
        '    Encrypt(inputLogFile, outputLogFile)
        '    File.Delete(inputLogFile)

        '    Dim columns As String = dr("SEARCHSETTINGS")

        '    If IsNothing(columns) Or String.IsNullOrEmpty(columns) Then
        '        Return Nothing
        '    End If

        '    Dim delim As Char = "|"
        '    Dim aColumns() As String = columns.Split(delim)

        '    Dim sFld As String
        '    Dim aFld() As String

        '    Dim ParentNode As TreeNode = Nothing
        '    Dim ChildNode As TreeNode
        '    For Each ParentRow As DataRow In dsSearch.Tables(0).Rows
        '        For i As Integer = 0 To aColumns.Count - 1

        '            sFld = aColumns(i)
        '            aFld = sFld.Split("=")
        '            If i = 0 Then

        '                'Tree View parent node
        '                ParentNode = New TreeNode(aFld(0) & ": " & ParentRow(aFld(1)).ToString())
        '                trvDelete.Nodes.Add(ParentNode)
        '            Else
        '                'Tree View child node
        '                ChildNode = New TreeNode(aFld(0) + ": " + ParentRow(aFld(1)).ToString())
        '                ParentNode.ChildNodes.Add(ChildNode)
        '            End If
        '        Next
        '    Next
        'End If
        'End If
        'End If

        Dim p As Page = New Page()
        Dim form As HtmlForm = New HtmlForm()
        form.Controls.Add(trv)
        p.Controls.Add(form)
        Dim stringWriter As StringWriter = New StringWriter()
        HttpContext.Current.Server.Execute(p, stringWriter, False)
        Dim rawHtml = stringWriter.ToString()
        Return rawHtml
    End Function
End Class