Imports OpenEIDSS.Domain
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain.Parameter_Contracts
'Imports Microsoft.Office.Interop.Word

Public Class NoteFileDownload
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim OutbreakAPIService As OutbreakServiceClient = New OutbreakServiceClient()
        Dim parameters = New OmmNoteFileParams()
        Dim idfOutbreakNote As Long
        Dim bForDownload As Boolean = False

        Long.TryParse(Request.QueryString("idfOutbreakNote"), idfOutbreakNote)

        If Request.QueryString("download") = "true" Then
            bForDownload = True
        End If

        parameters.idfOutbreakNote = idfOutbreakNote

        Dim result As List(Of OmmNoteFileGetModel) = OutbreakAPIService.OmmNoteFileGetAsync(parameters).Result
        Dim strFileName As String = result(0).UploadFileName
        Dim strContentType As String = String.Empty
        Dim strExtension As String = strFileName.Split(CType(".", Char))(1)

        Select Case strExtension
            Case "doc"
                strContentType = "application/msword"
            Case "dot"
                strContentType = "application/msword"
            Case "docx"
                strContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            Case "dotx"
                strContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
            Case "docm"
                strContentType = "application/vnd.ms-word.document.macroEnabled.12"
            Case "dotm"
                strContentType = "application/vnd.ms-word.template.macroEnabled.12"
            Case "xls"
                strContentType = "application/vnd.ms-excel"
            Case "xlt"
                strContentType = "application/vnd.ms-excel"
            Case "xla"
                strContentType = "application/vnd.ms-excel"
            Case "xlsx"
                strContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            Case "xltx"
                strContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
            Case "xlsm"
                strContentType = "application/vnd.ms-excel.sheet.macroEnabled.12"
            Case "xltm"
                strContentType = "application/vnd.ms-excel.template.macroEnabled.12"
            Case "xlam"
                strContentType = "application/vnd.ms-excel.addin.macroEnabled.12"
            Case "xlsb"
                strContentType = "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
            Case "ppt"
                strContentType = "application/vnd.ms-powerpoint"
            Case "pot"
                strContentType = "application/vnd.ms-powerpoint"
            Case "pps"
                strContentType = "application/vnd.ms-powerpoint"
            Case "ppa"
                strContentType = "application/vnd.ms-powerpoint"
            Case "pptx"
                strContentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
            Case "potx"
                strContentType = "application/vnd.openxmlformats-officedocument.presentationml.template"
            Case "ppsx"
                strContentType = "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
            Case "ppam"
                strContentType = "application/vnd.ms-powerpoint.addin.macroEnabled.12"
            Case "pptm"
                strContentType = "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
            Case "potm"
                strContentType = "application/vnd.ms-powerpoint.template.macroEnabled.12"
            Case "ppsm"
                strContentType = "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
            Case "pdf"
                strContentType = "application/pdf"
        End Select

        Response.ClearContent()
        Response.ClearHeaders()
        Response.Clear()
        Response.ContentType = strContentType

        If (bForDownload) Then
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + strFileName)
        End If

        Response.BinaryWrite(result(0).UploadFileObject.ToArray())
        Response.Flush()
        Response.End()

    End Sub

End Class