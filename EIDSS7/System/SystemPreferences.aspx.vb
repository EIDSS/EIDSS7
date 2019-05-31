Imports System.IO
Imports System.Xml.Serialization
Imports System.Drawing.Printing

Public Class SystemPreferences
    Inherits BaseEidssPage

    Public Enum eStartUpLanguage

        English = 0

    End Enum

    Public Enum eCountry

        Georgia = 0

    End Enum

    Public Enum eDefaultMapProject

        _Default = 0

    End Enum

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack() Then

            BindToEnum(GetType(eStartUpLanguage), ddlStartupLanguage)
            BindToEnum(GetType(eCountry), ddlCountry)
            BindToEnum(GetType(eDefaultMapProject), ddlDefaultMapProject)
            PopulateInstalledPrintersCombo()

            Dim up As UserPreferences

            Dim oSerializer As XmlSerializer = New XmlSerializer(GetType(UserPreferences))
            Dim sFile As String = ""
            sFile = Server.MapPath("\") & "\System\UserPreferences\" & Session("UserName") & ".xml"
            Dim oFileStream As FileStream

            If sFile <> "" AndAlso File.Exists(sFile) Then

                oFileStream = New FileStream(sFile, FileMode.Open)
                up = oSerializer.Deserialize(oFileStream)

                ddlStartupLanguage.SelectedValue = up.StartUpLanguage
                ddlCountry.SelectedValue = up.Country
                ddlBarcodePrinter.SelectedValue = up.BarcodePrinter
                ddlDocumentPrinter.SelectedValue = up.DocumentPrinter
                lblEPIInfoPath.Text = up.EPIInfoPath
                ddlDefaultMapProject.SelectedValue = up.DefaultMapProject
                chkShowTextInToolbar.Checked = (up.ShowTextInToolbar = True)
                chkShowWarning.Checked = (up.ShowWarning = True)
                chkShowSaveDataPrompt.Checked = (up.ShowSaveDataPrompt = True)
                chkPrintVetrinaryMap.Checked = (up.PrintVetrinaryMap = True)
                chkShowNavigatorInH02Form.Checked = (up.ShowNavigatorInH02Form = True)
                chkShowStarForBlank.Checked = (up.ShowStarForBlank = True)
                chkLabModuleSimplifiedMode.Checked = (up.LabModuleSimplifiedMode = True)
                chkFilterSamplesByDiag.Checked = (up.FilterSamplesByDiag = True)
                chkDefaultRegionInSearchPanel.Checked = (up.DefaultRegionInSearchPanel = True)
                chkShowWarningForFinalCase.Checked = (up.ShowWarningForFinalCase = True)
                uccDefualtNumberofDaysDisplayed.Text = up.DefualtNumberofDaysDisplayed

                oFileStream.Close()
                oFileStream.Dispose()

            End If

        End If

    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click

        Dim up As UserPreferences = New UserPreferences()

        up.StartUpLanguage = ddlStartupLanguage.SelectedValue
        up.Country = ddlCountry.SelectedValue
        up.BarcodePrinter = ddlBarcodePrinter.SelectedValue
        up.DocumentPrinter = ddlDocumentPrinter.SelectedValue
        If fuEPIInfoPath.HasFile Then
            lblEPIInfoPath.Text = System.IO.Path.GetFullPath(fuEPIInfoPath.FileName)
            lblEPIInfoPath.Text = lblEPIInfoPath.Text.Replace(System.IO.Path.GetFileName(fuEPIInfoPath.FileName), "")
            up.EPIInfoPath = lblEPIInfoPath.Text
        Else
            up.EPIInfoPath = ""
        End If
        up.DefaultMapProject = ddlDefaultMapProject.SelectedValue
        up.ShowTextInToolbar = chkShowTextInToolbar.Checked
        up.ShowWarning = chkShowWarning.Checked
        up.ShowSaveDataPrompt = chkShowSaveDataPrompt.Checked
        up.PrintVetrinaryMap = chkPrintVetrinaryMap.Checked
        up.ShowNavigatorInH02Form = chkShowNavigatorInH02Form.Checked
        up.ShowStarForBlank = chkShowStarForBlank.Checked
        up.LabModuleSimplifiedMode = chkLabModuleSimplifiedMode.Checked
        up.FilterSamplesByDiag = chkFilterSamplesByDiag.Checked
        up.DefaultRegionInSearchPanel = chkDefaultRegionInSearchPanel.Checked
        up.ShowWarningForFinalCase = chkShowWarningForFinalCase.Checked
        up.DefualtNumberofDaysDisplayed = uccDefualtNumberofDaysDisplayed.Text

        Dim oSerializer As XmlSerializer = New XmlSerializer(GetType(UserPreferences))
        Dim sFile As String = ""
        sFile = Server.MapPath("\") & "\System\UserPreferences\" & Session("UserName") & ".xml"
        Dim oWriter As StreamWriter
        If sFile <> "" Then
            oWriter = New StreamWriter(sFile)
            oSerializer.Serialize(oWriter, up)
            oWriter.Close()
            oWriter.Dispose()
        End If

    End Sub

    Private Sub PopulateInstalledPrintersCombo()
        ' Add list of installed printers found to the combo box.
        ' The pkInstalledPrinters string will be used to provide the display string.
        Dim i As Integer
        Dim pkInstalledPrinters As String

        For i = 0 To PrinterSettings.InstalledPrinters.Count - 1
            pkInstalledPrinters = PrinterSettings.InstalledPrinters.Item(i)
            ddlBarcodePrinter.Items.Add(pkInstalledPrinters)
            ddlDocumentPrinter.Items.Add(pkInstalledPrinters)
        Next
    End Sub

    Private Sub SystemPreferences_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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

End Class

Public Class UserPreferences

    Private sStartUpLanguage As String
    Private sCountry As String
    Private sBarcodePrinter As String
    Private SDocumentPrinter As String
    Private sEPIInfoPath As String
    Private sDefaultMapProject As String
    Private bShowTextInToolbar As Boolean
    Private bShowWarning As Boolean
    Private bShowSaveDataPrompt As Boolean
    Private bPrintVetrinaryMap As Boolean
    Private bShowNavigatorInH02Form As Boolean
    Private bShowStarForBlank As Boolean
    Private bLabModuleSimplifiedMode As Boolean
    Private bFilterSamplesByDiag As Boolean
    Private bDefaultRegionInSearchPanel As Boolean
    Private bShowWarningForFinalCase As Boolean
    Private sDefualtNumberofDaysDisplayed As String

    Public Property StartUpLanguage As String
        Get
            Return sStartUpLanguage
        End Get
        Set(value As String)
            sStartUpLanguage = value
        End Set
    End Property

    Public Property Country As String
        Get
            Return sCountry
        End Get
        Set(value As String)
            sCountry = value
        End Set
    End Property

    Public Property BarcodePrinter As String
        Get
            Return sBarcodePrinter
        End Get
        Set(value As String)
            sBarcodePrinter = value
        End Set
    End Property

    Public Property DocumentPrinter As String
        Get
            Return SDocumentPrinter
        End Get
        Set(value As String)
            SDocumentPrinter = value
        End Set
    End Property

    Public Property EPIInfoPath As String
        Get
            Return sEPIInfoPath
        End Get
        Set(value As String)
            sEPIInfoPath = value
        End Set
    End Property

    Public Property DefaultMapProject As String
        Get
            Return sDefaultMapProject
        End Get
        Set(value As String)
            sDefaultMapProject = value
        End Set
    End Property

    Public Property ShowTextInToolbar As Boolean
        Get
            Return bShowTextInToolbar
        End Get
        Set(value As Boolean)
            bShowTextInToolbar = value
        End Set
    End Property

    Public Property ShowWarning As Boolean
        Get
            Return bShowWarning
        End Get
        Set(value As Boolean)
            bShowWarning = value
        End Set
    End Property

    Public Property ShowSaveDataPrompt As Boolean
        Get
            Return bShowSaveDataPrompt
        End Get
        Set(value As Boolean)
            bShowSaveDataPrompt = value
        End Set
    End Property

    Public Property PrintVetrinaryMap As Boolean
        Get
            Return bPrintVetrinaryMap
        End Get
        Set(value As Boolean)
            bPrintVetrinaryMap = value
        End Set
    End Property

    Public Property ShowNavigatorInH02Form As Boolean
        Get
            Return bShowNavigatorInH02Form
        End Get
        Set(value As Boolean)
            bShowNavigatorInH02Form = value
        End Set
    End Property

    Public Property ShowStarForBlank As Boolean
        Get
            Return bShowStarForBlank
        End Get
        Set(value As Boolean)
            bShowStarForBlank = value
        End Set
    End Property

    Public Property LabModuleSimplifiedMode As Boolean
        Get
            Return bLabModuleSimplifiedMode
        End Get
        Set(value As Boolean)
            bLabModuleSimplifiedMode = value
        End Set
    End Property

    Public Property FilterSamplesByDiag As Boolean
        Get
            Return bFilterSamplesByDiag
        End Get
        Set(value As Boolean)
            bFilterSamplesByDiag = value
        End Set
    End Property

    Public Property DefaultRegionInSearchPanel As Boolean
        Get
            Return bDefaultRegionInSearchPanel
        End Get
        Set(value As Boolean)
            bDefaultRegionInSearchPanel = value
        End Set
    End Property

    Public Property ShowWarningForFinalCase As Boolean
        Get
            Return bShowWarningForFinalCase
        End Get
        Set(value As Boolean)
            bShowWarningForFinalCase = value
        End Set
    End Property

    Public Property DefualtNumberofDaysDisplayed As String
        Get
            Return sDefualtNumberofDaysDisplayed
        End Get
        Set(value As String)
            sDefualtNumberofDaysDisplayed = value
        End Set
    End Property

End Class
