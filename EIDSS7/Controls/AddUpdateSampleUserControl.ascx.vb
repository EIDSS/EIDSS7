Imports System.Globalization
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports Newtonsoft.Json
Imports OpenEIDSS.Domain

''' <summary>
''' 
''' Use Case: LUC11
''' 
''' The objective of the Edit a Sample Use Case Specification is to define the functional requirements for a 
''' user to edit sample details in the laboratory module in EIDSS. The functional requirements, or functionality 
''' that must be provided to users, are described in terms of use cases.
''' 
''' The Edit a Sample Use Case Specification defines the functional requirements to give the user the ability to 
''' edit sample details in the Laboratory Module of EIDSS.
''' 
''' </summary>
Public Class AddUpdateSampleUserControl
    Inherits UserControl

#Region "Global Values"

    'CSS Constants
    Private Const CSS_BOX_LOCATION As String = "boxLocation"
    Private Const CSS_DISABLED_BOX_LOCATION As String = "disabledBoxLocation"

    Private Const EMPLOYEE_GROUP_DATASET As String = "dsEmployeeGroup" 'TODO: Incorporate into the login process once session is replaced.
    Private Const SESSION_SAMPLE As String = "AddUpdateSample"
    Private Const SESSION_FREEZER_SUBDIVISIONS_LIST As String = "treFreezerSubvidisions_List"

    Private treeViewList As New List(Of TreeViewItem)

    Public Event ShowErrorModal(messageType As MessageType, message As String)
    Public Event AddUpdateSampleBoxLocationChanged(radioButtonID As String)

    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(AddUpdateSampleUserControl))

    Public Property Sample As LabSampleGetListModel
        Get
            Return CType(Session(SESSION_SAMPLE), LabSampleGetListModel)
        End Get
        Set(ByVal value As LabSampleGetListModel)
            Session(SESSION_SAMPLE) = value
        End Set
    End Property

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                cvAccessionDate.ValueToCompare = Date.Now.ToShortDateString()
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")

                If eventSource.Contains(ID) Then
                    If eventSource.Contains("Box") Then
                        RaiseEvent AddUpdateSampleBoxLocationChanged(eventSource)
                    End If
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Setup()

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            'Assign defaults from current user data.
            hdfUserID.Value = Session("UserID")
            hdfSiteID.Value = Session("UserSite")
            hdfPersonID.Value = Session("Person")
            hdfOrganizationID.Value = Session("Institution")

            Reset()

            FillDropDowns()

            FillSample()

            VerifyPermissions()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Reset()

        txtAccessionDate.Text = String.Empty
        txtCollectionDate.Text = String.Empty
        txtDestructionMethodTypeName.Text = String.Empty
        txtCollectedByOrganizationName.Text = String.Empty
        txtCollectedByPersonName.Text = String.Empty
        txtParentEIDSSLaboratorySampleID.Text = String.Empty
        txtPatientSpeciesVectorInformation.Text = String.Empty
        txtReasonForDeletion.Text = String.Empty
        txtReportSessionTypeName.Text = String.Empty
        txtAccessionConditionOrSampleStatusTypeName.Text = String.Empty
        txtSampleTypeName.Text = String.Empty
        txtSentToOrganizationName.Text = String.Empty
        txtEIDSSLaboratorySampleID.Text = String.Empty
        txtAccessionComment.Text = String.Empty
        txtEIDSSLocalFieldSampleID.Text = String.Empty
        txtNote.Text = String.Empty
        txtTestAssignedCount.Text = String.Empty
        ddlFunctionalAreaID.SelectedIndex = -1

        divReasonForDeletion.Visible = False
        ddlFunctionalAreaID.Enabled = True
        treSubdivisions.Enabled = True

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        Dim list As List(Of GblDepartmentGetListModel) = CrossCuttingAPIService.GetDepartmentListAsync(GetCurrentLanguage(), Nothing, Nothing).Result.OrderBy(Function(x) x.DepartmentName).ToList()
        FillDropDownList(ddlFunctionalAreaID, list, {GlobalConstants.NullValue}, DepartmentConstants.DepartmentId, DepartmentConstants.DepartmentName, Nothing, Nothing, True)

        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If

        Dim freezerSubdivisions = LaboratoryAPIService.LaboratoryFreezerSubdivisionGetListAsync(GetCurrentLanguage(), Nothing, hdfSiteID.Value).Result
        Dim freezers = freezerSubdivisions.GroupBy(Function(x) x.FreezerID).Select(Function(y) y.First())
        Dim storageBoxLocation As String = ""

        treSubdivisions.Nodes.Clear()

        For Each freezer In freezers
            Dim freezerName As String

            If freezer.Building.IsValueNullOrEmpty = True Then
                If freezer.Room.IsValueNullOrEmpty = True Then
                    freezerName = GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & freezer.FreezerName
                Else
                    freezerName = "(" & Resources.Labels.Lbl_Room_Text & " #" & freezer.Room & ") " & GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & freezer.FreezerName
                End If
            Else
                If freezer.Room.IsValueNullOrEmpty = True Then
                    freezerName = "(" & Resources.Labels.Lbl_Building_Text & " #" & freezer.Building & ") " & GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & freezer.FreezerName
                Else
                    freezerName = "(" & Resources.Labels.Lbl_Building_Text & " #" & freezer.Building & "/" & Resources.Labels.Lbl_Room_Text & " #" & freezer.Room & ") " & GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & freezer.FreezerName
                End If
            End If

            treeViewList.Add(New TreeViewItem() With {.ParentID = 0, .ID = freezer.FreezerID, .Text = freezerName})
        Next

        For Each freezerSubdivision In freezerSubdivisions
            If freezerSubdivision.ParentSubdivisionID Is Nothing Then
                freezerSubdivision.ParentSubdivisionID = freezerSubdivision.FreezerID
            End If

            Select Case freezerSubdivision.SubdivisionTypeID
                Case SubdivisionTypes.Shelf
                    treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Shelf_Text") & " " & freezerSubdivision.SubdivisionName})

                    If Not Sample.FreezerSubdivisionID Is Nothing Then
                        storageBoxLocation &= " " & Resources.Labels.Lbl_Shelf_Text & " #" & freezerSubdivision.SubdivisionName
                    End If
                Case SubdivisionTypes.Rack
                    treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Rack_Text") & " " & freezerSubdivision.SubdivisionName})

                    If Not Sample.FreezerSubdivisionID Is Nothing Then
                        storageBoxLocation &= " " & Resources.Labels.Lbl_Rack_Text & " #" & freezerSubdivision.SubdivisionName
                    End If
                Case SubdivisionTypes.Box
                    treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Box_Text") & " " & freezerSubdivision.SubdivisionName})

                    If Not Sample.StorageBoxPlace Is Nothing Then
                        storageBoxLocation &= " " & Resources.Labels.Lbl_Box_Text & " #" & Sample.StorageBoxPlace
                    End If
            End Select
        Next

        Dim binding = New TreeNodeBinding With {.TextField = "Text", .ValueField = "ID"}
        treSubdivisions.DataBindings.Add(binding)
        PopulateTreeView(0, Nothing)
        treSubdivisions.CollapseAll()

        Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

        upAddUpdateSample.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="parentID"></param>
    ''' <param name="parentNode"></param>
    Private Sub PopulateTreeView(ByVal parentID As Long, ByVal parentNode As TreeNode)

        Try
            Dim childNode As TreeNode

            For Each item As TreeViewItem In treeViewList.Where(Function(x) x.ParentID = parentID)
                Dim t As TreeNode = New TreeNode With {.Text = item.Text, .Value = item.ID}

                If parentNode Is Nothing Then
                    treSubdivisions.Nodes.Add(t)
                    childNode = t
                Else
                    parentNode.ChildNodes.Add(t)
                    childNode = t
                End If

                If Not parentID = childNode.Value Then
                    PopulateTreeView(item.ID, childNode)
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub VerifyPermissions()

        Dim dsEmployeeGroup As DataSet = TryCast(ViewState(EMPLOYEE_GROUP_DATASET), DataSet)

        If dsEmployeeGroup Is Nothing Then
            dsEmployeeGroup = New DataSet
            Dim oEmployeeGroup As New clsEmployeeGroup
            dsEmployeeGroup = oEmployeeGroup.SelectOne(hdfPersonID.Value)
        End If

        'TFS 181
        If dsEmployeeGroup.CheckDataSet() Then
            If dsEmployeeGroup.Tables(0).Select(EmployeeGroupConstants.idfsEmployeeGroupName & " = " & EmployeeGroupTypes.ChiefOfLaboratoryHuman).Count > 0 Or
                dsEmployeeGroup.Tables(0).Select(EmployeeGroupConstants.idfsEmployeeGroupName & " = " & EmployeeGroupTypes.ChiefOfLaboratoryVeterinary).Count > 0 Then
                txtAccessionDate.Enabled = True
            Else
                txtAccessionDate.Enabled = False
            End If
        End If

        ViewState(EMPLOYEE_GROUP_DATASET) = dsEmployeeGroup

    End Sub

#End Region

#Region "Sample Methods"

    Private Sub FillSample()

        Scatter(Me, Sample)

        If Not Sample.AccessionDate Is Nothing Then
            Dim c As CultureInfo = New CultureInfo(GetCurrentLanguage(), False)
            Threading.Thread.CurrentThread.CurrentCulture = c
            txtAccessionDate.Text = CType(Sample.AccessionDate, Date).ToString("g")
        End If

        btnReportSession.Text = Sample.EIDSSReportSessionID

        If Not Sample.SampleStatusTypeID.ToString() = String.Empty Then
            Select Case Sample.SampleStatusTypeID
                Case SampleStatusTypes.Deleted
                    divReasonForDeletion.Visible = True
                Case SampleStatusTypes.Destroyed
                    ddlFunctionalAreaID.Enabled = False
                    treSubdivisions.Enabled = False
            End Select
        Else
            treSubdivisions.Enabled = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Function Save() As LabSampleGetListModel

        Page.Validate("EditSampleTestDetails")

        If Page.IsValid = True Then
            Sample = TryCast(Session(SESSION_SAMPLE), LabSampleGetListModel)
            Sample.RowAction = RecordConstants.Update
            If ddlFunctionalAreaID.SelectedValue.ToUpper() = GlobalConstants.NullValue Then
                Sample.FunctionalAreaID = Nothing
            Else
                Sample.FunctionalAreaID = ddlFunctionalAreaID.SelectedValue
                Sample.FunctionalAreaName = ddlFunctionalAreaID.SelectedItem.Text
            End If

            If Sample.DiseaseID = 0 Then
                Sample.DiseaseID = Nothing
            End If
            Sample.AccessionComment = txtAccessionComment.Text
            Sample.Note = txtNote.Text
            Sample.RowSelectionIndicator = 0

            Return Sample
        Else
            RaiseEvent ShowErrorModal(messageType:=MessageType.CannotEditSample, message:=String.Empty)

            Return Nothing
        End If

        Return Nothing

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ReportSession_Click(sender As Object, e As EventArgs) Handles btnReportSession.Click

        Try
            If Not hdfMonitoringSessionID.Value = String.Empty Then
                ViewState(CALLER) = LaboratoryModuleTabConstants.Samples
                ViewState(CALLER_KEY) = hdfMonitoringSessionID.Value
                SaveEIDSSViewState(ViewState)

                If hdfSessionCategoryTypeID.Value = SessionCategory.Human Then
                    Response.Redirect(GetURL(CallerPages.HumanActiveSurveillanceSessionUrl), False)
                Else
                    Response.Redirect(GetURL(CallerPages.VeterinaryActiveSurveillanceMonitoringSessionURL), False)
                End If
            ElseIf Not hdfHumanDiseaseReportID.Value = String.Empty Then
                ViewState(CALLER) = LaboratoryModuleTabConstants.Samples
                ViewState(CALLER_KEY) = hdfHumanDiseaseReportID.Value
                SaveEIDSSViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), False)
            ElseIf Not hdfVectorSurveillanceSessionID.Value = String.Empty Then
                ViewState(CALLER) = LaboratoryModuleTabConstants.Samples
                ViewState(CALLER_KEY) = hdfVectorSurveillanceSessionID.Value
                SaveEIDSSViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.VectorSurveillanceSessionURL), False)
            ElseIf Not hdfVeterinaryDiseaseReportID.Value = String.Empty Then
                ViewState(CALLER) = LaboratoryModuleTabConstants.Samples
                ViewState(CALLER_KEY) = hdfVeterinaryDiseaseReportID.Value
                SaveEIDSSViewState(ViewState)

                If hdfReportSessionTypeID.Value = VeterinaryDiseaseReportConstants.AvianDiseaseReportCaseType Then
                    Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), False)
                ElseIf hdfReportSessionTypeID.Value = VeterinaryDiseaseReportConstants.LivestockDiseaseReportCaseType Then
                    Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), False)
                End If
            End If
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AccessionDate_TextChanged(sender As Object, e As EventArgs) Handles txtAccessionDate.TextChanged

        cvAccessionDate.Validate()

    End Sub

#End Region

#Region "Storage Location Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="columns"></param>
    ''' <param name="rows"></param>
    ''' <param name="boxConfiguration"></param>
    Private Sub BuildBoxConfiguration(columns As Integer, rows As Integer, boxConfiguration As String)

        Try
            Dim tr As TableRow = New TableRow()
            Dim boxLocationAvailability = JsonConvert.DeserializeObject(Of List(Of FreezerSubdivisionBoxLocationAvailability))(boxConfiguration)

            For c As Integer = 0 To columns
                Dim tc As TableCell = New TableCell()
                tc.ID = "tc_" & c.ToString() & "_0"
                If c > 0 Then
                    tc.Text = c.ToString()
                End If
                tr.Cells.Add(tc)
            Next
            tblBoxConfiguration.Rows.Add(tr)

            For r As Integer = 1 To rows
                tr = New TableRow()

                For c As Integer = 0 To columns
                    Dim tc As TableCell = New TableCell With {
                        .ID = "tc_" & c.ToString() & "_" & r.ToString()
                    }

                    If c = 0 Then
                        tc.Text = GetLetter(r)
                    Else
                        Dim rad As RadioButton = New RadioButton With {
                            .Checked = False,
                            .ClientIDMode = ClientIDMode.Static,
                            .ID = "rad_" & GetLetter(r) & "_" & c.ToString(),
                            .ToolTip = GetLetter(r) & "-" & c.ToString(),
                            .GroupName = "BoxLocation"
                        }

                        rad.Attributes.Add("onchange", "boxLocationChanged(" & rad.ID & ");")

                        If boxLocationAvailability.Where(Function(x) x.BoxLocation = rad.ToolTip).FirstOrDefault().AvailabilityIndicator = True Then
                            rad.Enabled = True
                            rad.CssClass = CSS_BOX_LOCATION
                            rad.GroupName = "BoxLocation"
                        Else
                            rad.Enabled = False
                            rad.CssClass = CSS_DISABLED_BOX_LOCATION
                            rad.Checked = True
                        End If

                        tc.Controls.Add(rad)
                    End If

                    tr.Cells.Add(tc)
                Next

                tblBoxConfiguration.Rows.Add(tr)
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="boxLocation"></param>
    Protected Sub AddUpdateSampleBoxLocationChanged_Event(boxLocation As String) Handles Me.AddUpdateSampleBoxLocationChanged
        Try
            Dim boxLocationArray As String() = boxLocation.Split("_")
            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            Dim newStorageBoxPlace As String = boxLocationArray(1) & "-" & boxLocationArray(2)
            Dim sampleID As Long = boxLocationArray(4)
            Dim newSubdivisionID As Long = boxLocationArray(6)
            Dim oldSubdivisionID As Long = 0
            Dim oldStorageBoxPlace As String = Sample.StorageBoxPlace

            If freezerSubdivisions Is Nothing Then
                freezerSubdivisions = New List(Of LabFreezerSubdivisionGetListModel)()
            End If

            If Not Sample.FreezerSubdivisionID Is Nothing Then
                oldSubdivisionID = Sample.FreezerSubdivisionID
            Else
                oldSubdivisionID = newSubdivisionID
            End If

            Dim boxPlaceAvailability = JsonConvert.DeserializeObject(Of List(Of FreezerSubdivisionBoxLocationAvailability))(freezerSubdivisions.Where(Function(x) x.SubdivisionID = newSubdivisionID).FirstOrDefault().BoxPlaceAvailability)
            boxPlaceAvailability.Where(Function(x) x.BoxLocation = newStorageBoxPlace).FirstOrDefault().AvailabilityIndicator = False
            If oldStorageBoxPlace.IsValueNullOrEmpty = False Then
                boxPlaceAvailability.Where(Function(x) x.BoxLocation = oldStorageBoxPlace).FirstOrDefault().AvailabilityIndicator = True
            End If
            freezerSubdivisions.Where(Function(x) x.SubdivisionID = newSubdivisionID).FirstOrDefault().BoxPlaceAvailability = JsonConvert.SerializeObject(boxPlaceAvailability)

            If Not oldSubdivisionID = newSubdivisionID Then
                boxPlaceAvailability = JsonConvert.DeserializeObject(Of List(Of FreezerSubdivisionBoxLocationAvailability))(freezerSubdivisions.Where(Function(x) x.SubdivisionID = oldSubdivisionID).FirstOrDefault().BoxPlaceAvailability)
                boxPlaceAvailability.Where(Function(x) x.BoxLocation = oldStorageBoxPlace).FirstOrDefault().AvailabilityIndicator = True
                freezerSubdivisions.Where(Function(x) x.SubdivisionID = oldSubdivisionID).FirstOrDefault().BoxPlaceAvailability = JsonConvert.SerializeObject(boxPlaceAvailability)
            End If

            Sample.FreezerSubdivisionID = newSubdivisionID
            Sample.StorageBoxPlace = newStorageBoxPlace

            Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="number"></param>
    ''' <returns></returns>
    Friend Function GetLetter(ByVal number As Integer) As String

        Select Case number
            Case 1 : Return "A"
            Case 2 : Return "B"
            Case 3 : Return "C"
            Case 4 : Return "D"
            Case 5 : Return "E"
            Case 6 : Return "F"
            Case 7 : Return "G"
            Case 8 : Return "H"
            Case 9 : Return "I"
            Case 10 : Return "J"
            Case 11 : Return "K"
            Case 12 : Return "L"
            Case 13 : Return "M"
            Case 14 : Return "N"
            Case 15 : Return "O"
            Case 16 : Return "P"
            Case 17 : Return "Q"
            Case 18 : Return "R"
            Case 19 : Return "S"
            Case 20 : Return "T"
            Case 21 : Return "U"
            Case 22 : Return "V"
            Case 23 : Return "W"
            Case 24 : Return "X"
            Case 25 : Return "Y"
            Case 26 : Return "Z"
            Case Else : Return ""
        End Select

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Subdivisions_SelectedNodeChanged(sender As Object, e As EventArgs) Handles treSubdivisions.SelectedNodeChanged

        Try
            Dim freezerSubdivision As LabFreezerSubdivisionGetListModel
            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))

            freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = treSubdivisions.SelectedNode.Value).FirstOrDefault()

            If hdfFreezerSubdivisionID.Value.IsValueNullOrEmpty = False Then
                freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = hdfFreezerSubdivisionID.Value).FirstOrDefault()

                If freezerSubdivision.SubdivisionTypeID = SubdivisionTypes.Box Then
                    If freezerSubdivision.RowAction = RecordConstants.Read Then
                        freezerSubdivision.RowAction = RecordConstants.Update
                    End If
                    hdfFreezerSubdivisionID.Value = String.Empty
                End If

                Dim i As Integer = freezerSubdivisions.IndexOf(freezerSubdivision)

                freezerSubdivisions(i) = freezerSubdivision

                Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions
            End If

            freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = treSubdivisions.SelectedNode.Value).FirstOrDefault()

            freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = treSubdivisions.SelectedNode.Value).FirstOrDefault()

            If freezerSubdivision Is Nothing Then
                hdfFreezerSubdivisionID.Value = String.Empty
            Else
                If freezerSubdivision.ParentSubdivisionID Is Nothing Then
                    hdfFreezerSubdivisionID.Value = String.Empty
                Else
                    If freezerSubdivision.SubdivisionTypeID = SubdivisionTypes.Box Then
                        Dim boxSize As String() = freezerSubdivision.BoxSizeTypeName.Split("X")
                        hdfRows.Value = boxSize(0)
                        hdfColumns.Value = boxSize(1)

                        If Not freezerSubdivision.BoxPlaceAvailability Is Nothing Then
                            BuildBoxConfiguration(boxSize(0), boxSize(1), freezerSubdivision.BoxPlaceAvailability)
                            tblBoxConfiguration.Visible = True
                        End If

                        treSubdivisions.CollapseAll()

                            Dim node As TreeNode = treSubdivisions.SelectedNode
                            node.ExpandAll()
                        Else
                            tblBoxConfiguration.Visible = False
                    End If

                    hdfFreezerSubdivisionID.Value = freezerSubdivision.SubdivisionID
                End If
            End If

            Page.SetFocus(tblBoxConfiguration)

            upAddUpdateSample.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

End Class