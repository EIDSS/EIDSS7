Imports System.ComponentModel
Imports EIDSS.EIDSS

Public Class LaboratoryMenuUserControl
    Inherits UserControl

#Region "Global Values"

    Public Event MenuItemSelected(selectedMenuItem As String, tab As String)

    Protected AccessionInMenuItemPostBack As String
    Protected GroupAccessionInMenuItemPostBack As String
    Protected AssignTestMenuItemPostBack As String
    Protected CreateAliquotMenuItemPostBack As String
    Protected CreateDerivativeMenuItemPostBack As String
    Protected TransferOutMenuItemPostBack As String
    Protected RegisterNewSampleMenuItemPostBack As String
    Protected SetTestResultsMenuItemPostBack As String
    Protected ValidateTestResultMenuItemPostBack As String
    Protected AmendTestResultMenuItemPostBack As String
    Protected SampleDestructionMenuItemPostBack As String
    Protected DestroyByIncinerationMenuItemPostBack As String
    Protected DestroyByAutoclaveMenuItemPostBack As String
    Protected ApproveDestructionMenuItemPostBack As String
    Protected RejectDestructionMenuItemPostBack As String
    Protected LabRecordDeletionMenuItemPostBack As String
    Protected DeleteSampleMenuItemPostBack As String
    Protected DeleteTestMenuItemPostBack As String
    Protected ApproveDeletionMenuItemPostBack As String
    Protected RejectDeletionMenuItemPostBack As String
    Protected RestoreSampleMenuItemPostBack As String
    Protected PaperFormsMenuItemPostBack As String
    Protected SampleReportMenuItemPostBack As String
    Protected AccessionInFormMenuItemPostBack As String
    Protected TestReportMenuItemPostBack As String
    Protected TransferReportMenuItemPostBack As String
    Protected DestructionReportMenuItemPostBack As String
    Protected PrintBarcodeMenuItemPostBack As String

    <Category("Tab"), Description("Specify the tab the menu is associated with")>
    Public Property Tab As String

#End Region

#Region "Initilzation Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
                SetMenuItems()
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")
                If Not eventArg.ToString.IsValueNullOrEmpty() Then
                    If eventSource.Contains(ID) Then
                        Select Case eventSource
                            Case "ctl00$EIDSSBodyCPH$ucSamplesMenu"
                                RaiseEvent MenuItemSelected(eventArg, LaboratoryModuleTabConstants.Samples)
                            Case "ctl00$EIDSSBodyCPH$ucTestingMenu"
                                RaiseEvent MenuItemSelected(eventArg, LaboratoryModuleTabConstants.Testing)
                            Case "ctl00$EIDSSBodyCPH$ucTransferredMenu"
                                RaiseEvent MenuItemSelected(eventArg, LaboratoryModuleTabConstants.Transferred)
                            Case "ctl00$EIDSSBodyCPH$ucMyFavoritesMenu"
                                RaiseEvent MenuItemSelected(eventArg, LaboratoryModuleTabConstants.MyFavorites)
                            Case "ctl00$EIDSSBodyCPH$ucBatchesMenu"
                                RaiseEvent MenuItemSelected(eventArg, LaboratoryModuleTabConstants.Batches)
                            Case "ctl00$EIDSSBodyCPH$ucApprovalsMenu"
                                RaiseEvent MenuItemSelected(eventArg, LaboratoryModuleTabConstants.Approvals)
                        End Select
                    End If
                End If

                SetMenuItems()
            End If
        Catch ex As NullReferenceException
            Throw
        Catch ex As Exception
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SetMenuItems()

        Try
            AccessionInMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.AccessionIn.ToString())
            GroupAccessionInMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.GroupAccessionIn.ToString())
            CreateAliquotMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.CreateAliquot.ToString())
            CreateDerivativeMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.CreateDerivative.ToString())
            TransferOutMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.TransferOut.ToString())
            AssignTestMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.AssignTest.ToString())
            RegisterNewSampleMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.RegisterNewSample.ToString())
            SetTestResultsMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.SetTestResults.ToString())
            ValidateTestResultMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.ValidateTestResult.ToString())
            AmendTestResultMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.AmendTestResult.ToString())
            SampleDestructionMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.SampleDestruction.ToString())
            DestroyByIncinerationMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.DestroyByIncineration.ToString())
            DestroyByAutoclaveMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.DestroyByAutoclave.ToString())
            ApproveDestructionMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.ApproveDestruction.ToString())
            RejectDestructionMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.RejectDestruction.ToString())
            LabRecordDeletionMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.LabRecordDeletion.ToString())
            DeleteSampleMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.DeleteSample.ToString())
            DeleteTestMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.DeleteTest.ToString())
            ApproveDeletionMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.ApproveDeletion.ToString())
            RejectDeletionMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.RejectDeletion.ToString())
            RestoreSampleMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.RestoreSample.ToString())
            PaperFormsMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.PaperForms.ToString())
            SampleReportMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.SampleReport.ToString())
            AccessionInFormMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.AccessionInForm.ToString())
            TestReportMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.TestReport.ToString())
            TransferReportMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.TransferReport.ToString())
            DestructionReportMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.DestructionReport.ToString())
            PrintBarcodeMenuItemPostBack = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.PrintBarcode.ToString())

            Select Case Tab
                Case "Samples"
                    SetTestResultsMenuItem.Attributes.Add("class", "disabled")
                    ValidateTestResultMenuItem.Attributes.Add("class", "disabled")
                    AmendTestResultMenuItem.Attributes.Add("class", "disabled")
                    ApproveDestructionMenuItem.Attributes.Add("class", "disabled")
                    RejectDestructionMenuItem.Attributes.Add("class", "disabled")
                    DeleteTestMenuItem.Attributes.Add("class", "disabled")
                    ApproveDeletionMenuItem.Attributes.Add("class", "disabled")
                    RejectDeletionMenuItem.Attributes.Add("class", "disabled")
                    RestoreSampleMenuItem.Attributes.Add("class", "disabled")
                    DestroyByAutoclaveMenuItem.Attributes.Add("class", "disabled")
                    DestroyByIncinerationMenuItem.Attributes.Add("class", "disabled")
                    DeleteSampleMenuItem.Attributes.Add("class", "disabled")

                    'If User.(Roles.ChiefOfLaboratoryHuman) = False Then
                    '    RestoreSampleMenuItem.Attributes.Add("class", "disabled")
                    'End If
                Case "Testing"
                    AccessionInMenuItem.Attributes.Add("class", "disabled")
                    GroupAccessionInMenuItem.Attributes.Add("class", "disabled")
                    CreateAliquotMenuItem.Attributes.Add("class", "disabled")
                    CreateDerivativeMenuItem.Attributes.Add("class", "disabled")
                    TransferOutMenuItem.Attributes.Add("class", "disabled")
                    RegisterNewSampleMenuItem.Attributes.Add("class", "disabled")
                    ValidateTestResultMenuItem.Attributes.Add("class", "disabled")
                    ApproveDestructionMenuItem.Attributes.Add("class", "disabled")
                    RejectDestructionMenuItem.Attributes.Add("class", "disabled")
                    ApproveDeletionMenuItem.Attributes.Add("class", "disabled")
                    RejectDeletionMenuItem.Attributes.Add("class", "disabled")
                    RestoreSampleMenuItem.Attributes.Add("class", "disabled")
                    DestroyByAutoclaveMenuItem.Attributes.Add("class", "disabled")
                    DestroyByIncinerationMenuItem.Attributes.Add("class", "disabled")
                    DeleteSampleMenuItem.Attributes.Add("class", "disabled")

                    'If User.IsInRole(Roles.ChiefOfLaboratoryHuman) = False Then
                    '    AmendTestResultMenuItem.Attributes.Add("class", "disabled")
                    '    RestoreSampleMenuItem.Attributes.Add("class", "disabled")
                    'End If
                Case "Transferred"
                    CreateAliquotMenuItem.Attributes.Add("class", "disabled")
                    CreateDerivativeMenuItem.Attributes.Add("class", "disabled")
                    RegisterNewSampleMenuItem.Attributes.Add("class", "disabled")
                    ValidateTestResultMenuItem.Attributes.Add("class", "disabled")
                    RestoreSampleMenuItem.Attributes.Add("class", "disabled")

                Case "Favorites"
                    RestoreSampleMenuItem.Attributes.Add("class", "disabled")

                    'If User.IsInRole(Roles.ChiefOfLaboratoryHuman) = False And User.IsInRoles(Roles.LaboratoryTechnicianHuman) Then
                    '    ValidateTestResultMenuItem.Attributes.Add("class", "disabled")
                    '    AmendTestResultMenuItem.Attributes.Add("class", "disabled")
                    '    RestoreSampleMenuItem.Attributes.Add("class", "disabled")
                    'End If

                    'If User.IsInRole(Roles.ChiefOfLaboratoryHuman) = False Then
                    '    ApproveDestructionMenuItem.Attributes.Add("class", "disabled")
                    '    RejectDestructionMenuItem.Attributes.Add("class", "disabled")
                    '    ApproveDeletionMenuItem.Attributes.Add("class", "disabled")
                    '    RejectDeletionMenuItem.Attributes.Add("class", "disabled")
                    'End If
                Case "Batches"
                    AccessionInMenuItem.Attributes.Add("class", "disabled")
                    GroupAccessionInMenuItem.Attributes.Add("class", "disabled")
                    AssignTestMenuItem.Attributes.Add("class", "disabled")
                    CreateAliquotMenuItem.Attributes.Add("class", "disabled")
                    CreateDerivativeMenuItem.Attributes.Add("class", "disabled")
                    TransferOutMenuItem.Attributes.Add("class", "disabled")
                    RegisterNewSampleMenuItem.Attributes.Add("class", "disabled")
                    DestroyByIncinerationMenuItem.Attributes.Add("class", "disabled")
                    DestroyByAutoclaveMenuItem.Attributes.Add("class", "disabled")
                    ApproveDestructionMenuItem.Attributes.Add("class", "disabled")
                    RejectDestructionMenuItem.Attributes.Add("class", "disabled")
                    DeleteSampleMenuItem.Attributes.Add("class", "disabled")
                    DeleteTestMenuItem.Attributes.Add("class", "disabled")
                    ApproveDeletionMenuItem.Attributes.Add("class", "disabled")
                    RejectDeletionMenuItem.Attributes.Add("class", "disabled")
                    RestoreSampleMenuItem.Attributes.Add("class", "disabled")

                    'If User.IsInRole(Roles.ChiefOfLaboratoryHuman) = False And User.IsInRoles(Roles.LaboratoryTechnicianHuman) Then
                    '    ValidateTestResultMenuItem.Attributes.Add("class", "disabled")
                    '    AmendTestResultMenuItem.Attributes.Add("class", "disabled")
                    'End If
                Case "Approvals"
                    AccessionInMenuItem.Attributes.Add("class", "disabled")
                    GroupAccessionInMenuItem.Attributes.Add("class", "disabled")
                    AssignTestMenuItem.Attributes.Add("class", "disabled")
                    CreateAliquotMenuItem.Attributes.Add("class", "disabled")
                    CreateDerivativeMenuItem.Attributes.Add("class", "disabled")
                    TransferOutMenuItem.Attributes.Add("class", "disabled")
                    RegisterNewSampleMenuItem.Attributes.Add("class", "disabled")
                    SetTestResultsMenuItem.Attributes.Add("class", "disabled")
                    AmendTestResultMenuItem.Attributes.Add("class", "disabled")
                    DestroyByIncinerationMenuItem.Attributes.Add("class", "disabled")
                    DestroyByAutoclaveMenuItem.Attributes.Add("class", "disabled")
                    DeleteSampleMenuItem.Attributes.Add("class", "disabled")
                    DeleteTestMenuItem.Attributes.Add("class", "disabled")
                    SampleReportMenuItem.Attributes.Add("class", "disabled")
                    AccessionInFormMenuItem.Attributes.Add("class", "disabled")
                    TestResultReportMenuItem.Attributes.Add("class", "disabled")
                    TransferReportMenuItem.Attributes.Add("class", "disabled")
                    DestructionReportMenuItem.Attributes.Add("class", "disabled")
                    PrintBarcodeMenuItem.Attributes.Add("class", "disabled")
                    RestoreSampleMenuItem.Attributes.Add("class", "disabled")

                    'If User.IsInRole(Roles.ChiefOfLaboratoryHuman) = False And User.IsInRoles(Roles.LaboratoryTechnicianHuman) Then
                    '    ValidateTestResultMenuItem.Attributes.Add("class", "disabled")
                    '    RestoreSampleMenuItem.Attributes.Add("class", "disabled")
                    'End If

                    'If User.IsInRole(Roles.ChiefOfLaboratoryHuman) = False Then
                    '    ApproveDestructionMenuItem.Attributes.Add("class", "disabled")
                    '    RejectDestructionMenuItem.Attributes.Add("class", "disabled")
                    '    ApproveDeletionMenuItem.Attributes.Add("class", "disabled")
                    '    RejectDeletionMenuItem.Attributes.Add("class", "disabled")
                    'End If
            End Select
        Catch ex As Exception
            Throw
        End Try

    End Sub

#End Region

#Region "Menu Methods"

    ''' <summary>
    ''' Sets the disabled attribute on the restore sample menu item.  Disabled is set to false when a sample that is currently in 
    ''' deleted status is selected, so the user has the option to restore the sample to the previously saved status.  See LUC21 
    ''' for more information.
    ''' </summary>
    ''' <param name="disabledIndicator"></param>
    Public Sub SetRestoreSampleDisabled(disabledIndicator As Boolean)

        If disabledIndicator = True Then
            RestoreSampleMenuItem.Attributes.Add("class", "disabled")
        Else
            If RestoreSampleMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = RestoreSampleMenuItem.Attributes("class").Replace("disabled", "")
                RestoreSampleMenuItem.Attributes.Remove("class")
                RestoreSampleMenuItem.Attributes.Add("class", newClassValue)
            End If
        End If
    End Sub

    ''' <summary>
    ''' Sets the disabled attribute on the sample destruction menu item.  Disabled is set to true when a sample that is currently 
    ''' un-accessioned is selected.  See LUC14 for more details.
    ''' </summary>
    ''' <param name="disabledIndicator"></param>
    Public Sub SetSampleDestructionDisabled(disabledIndicator As Boolean)

        If disabledIndicator = True Then
            DestroyByAutoclaveMenuItem.Attributes.Add("class", "disabled")
            DestroyByIncinerationMenuItem.Attributes.Add("class", "disabled")
        Else
            If DestroyByAutoclaveMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = DestroyByAutoclaveMenuItem.Attributes("class").Replace("disabled", "")
                DestroyByAutoclaveMenuItem.Attributes.Remove("class")
                DestroyByAutoclaveMenuItem.Attributes.Add("class", newClassValue)
            End If

            If DestroyByIncinerationMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = DestroyByIncinerationMenuItem.Attributes("class").Replace("disabled", "")
                DestroyByIncinerationMenuItem.Attributes.Remove("class")
                DestroyByIncinerationMenuItem.Attributes.Add("class", newClassValue)
            End If
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' See LUC15 for more details.
    ''' </summary>
    ''' <param name="disabledIndicator"></param>
    Public Sub SetDeleteSampleDisabled(disabledIndicator As Boolean)

        If disabledIndicator = True Then
            DeleteSampleMenuItem.Attributes.Add("class", "disabled")
        Else
            If DeleteSampleMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = DeleteSampleMenuItem.Attributes("class").Replace("disabled", "")
                DeleteSampleMenuItem.Attributes.Remove("class")
                DeleteSampleMenuItem.Attributes.Add("class", newClassValue)
            End If
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="disabledIndicator"></param>
    Public Sub SetDeleteTestDisabled(disabledIndicator As Boolean)

        If disabledIndicator = True Then
            DeleteTestMenuItem.Attributes.Add("class", "disabled")
        Else
            If DeleteTestMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = DeleteTestMenuItem.Attributes("class").Replace("disabled", "")
                DeleteTestMenuItem.Attributes.Remove("class")
                DeleteTestMenuItem.Attributes.Add("class", newClassValue)
            End If
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="disabledIndicator"></param>
    Public Sub SetTransferOutDisabled(disabledIndicator As Boolean)

        If disabledIndicator = True Then
            TransferOutMenuItem.Attributes.Add("class", "disabled")
        Else
            If TransferOutMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = TransferOutMenuItem.Attributes("class").Replace("disabled", "")
                TransferOutMenuItem.Attributes.Remove("class")
                TransferOutMenuItem.Attributes.Add("class", newClassValue)
            End If
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' See LUC18 for more details.
    ''' </summary>
    ''' <param name="disabledIndicator"></param>
    Public Sub SetPrintBarCodeDisabled(disabledIndicator As Boolean)

        If disabledIndicator = True Then
            PrintBarcodeMenuItem.Attributes.Add("class", "disabled")
        Else
            If PrintBarcodeMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = PrintBarcodeMenuItem.Attributes("class").Replace("disabled", "")
                PrintBarcodeMenuItem.Attributes.Remove("class")
                PrintBarcodeMenuItem.Attributes.Add("class", newClassValue)
            End If
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' See LUC01 for more details.
    ''' </summary>
    ''' <param name="disabledIndicator"></param>
    Public Sub SetAssignTestDisabled(disabledIndicator As Boolean)

        If disabledIndicator = True Then
            AssignTestMenuItem.Attributes.Add("class", "disabled")
        Else
            If AssignTestMenuItem.Attributes.Count > 0 Then
                Dim newClassValue = AssignTestMenuItem.Attributes("class").Replace("disabled", "")
                AssignTestMenuItem.Attributes.Remove("class")
                AssignTestMenuItem.Attributes.Add("class", newClassValue)
            End If
        End If

    End Sub

#End Region

End Class