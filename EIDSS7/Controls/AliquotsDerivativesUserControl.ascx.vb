Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports Newtonsoft.Json
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class AliquotsDerivativesUserControl
    Inherits UserControl

#Region "Global Values"

    'CSS Constants
    Private Const CSS_BTN_GLYPHICON_CHECKED As String = "btn glyphicon glyphicon-check selectButton"
    Private Const CSS_BTN_GLYPHICON_UNCHECKED As String = "btn glyphicon glyphicon-unchecked selectButton"
    Private Const CSS_BOX_LOCATION As String = "boxLocation"
    Private Const CSS_DISABLED_BOX_LOCATION As String = "disabledBoxLocation"

    Private Const SESSION_SELECTED_SAMPLES As String = "ucAliquotDerivative_SelectedSamples"
    Private Const SESSION_ALIQUOT_DERIVATIVE_SAMPLES As String = "ucAliquotDerivative_Samples"
    Private Const SESSION_FREEZER_SUBDIVISIONS_LIST As String = "treFreezerSubdivisions_List"

    Private Const MODAL_KEY As String = "Modal"
    Private Const SORT_EXPRESSION As String = "aliquotSortCol"
    Private Const SORT_DIRECTION As String = "aliquotSortDir"

    Private treeViewList As New List(Of TreeViewItem)

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(AliquotsDerivativesUserControl))

    Public Event AliquotDerivativeBoxLocationChanged(radioButtonID As String)

    Public FreezerBoxLocationAvailabilities As List(Of FreezerBoxLocationAvailabilityParameters)

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If (Not IsPostBack) Then
                rblCreateAliquotDerivative.Items.Clear()
                Dim item As ListItem = New ListItem With {.Text = GetLocalResourceObject("Lbl_Create_Aliquot_Text"), .Value = SampleKindTypes.Aliquot}
                rblCreateAliquotDerivative.Items.Add(item)
                item = New ListItem With {.Text = GetLocalResourceObject("Lbl_Create_Derivative_Text"), .Value = SampleKindTypes.Derivative}
                rblCreateAliquotDerivative.Items.Add(item)

                FillDropDowns()
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")

                If eventSource.Contains(ID) Then
                    If eventSource.Contains("Box") Then
                        RaiseEvent AliquotDerivativeBoxLocationChanged(eventSource)
                    End If
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleKindTypeID"></param>
    ''' <param name="samples"></param>
    ''' <param name="samplesPendingSaveCount"></param>
    ''' <param name="siteID"></param>
    ''' <param name="personID"></param>
    ''' <param name="organizationID"></param>
    Public Sub Setup(ByVal sampleKindTypeID As SampleKindTypes?, ByVal samples As List(Of LabSampleGetListModel), ByVal samplesPendingSaveCount As Integer, ByVal siteID As Long, ByVal personID As Long, ByVal organizationID As Long)

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            upAliquotsDerivatives.Update()
            upCreateAliquotDerivative.Update()
            upCreateAliquotDerivativeSelectedSamples.Update()
            upTypeOfAliquotDerivative.Update()

            hdfSiteID.Value = siteID.ToString()
            hdfPersonID.Value = personID.ToString()
            hdfIdentity.Value = samplesPendingSaveCount

            Reset()

            If Not sampleKindTypeID Is Nothing Then
                If sampleKindTypeID = SampleKindTypes.Aliquot Then
                    ddlTypeOfDerivative.Enabled = False
                    rfvDerivativeType.Enabled = False
                    reqTypeOfDerivative.Visible = False
                    rblCreateAliquotDerivative.SelectedValue = SampleKindTypes.Aliquot
                Else
                    ddlTypeOfDerivative.Enabled = True
                    rfvDerivativeType.Enabled = True
                    reqTypeOfDerivative.Visible = True
                    rblCreateAliquotDerivative.SelectedValue = SampleKindTypes.Derivative
                End If

                rblCreateAliquotDerivative.SelectedValue = sampleKindTypeID
            End If

            For Each sample In samples
                sample.RowSelectionIndicator = 0
            Next

            Session(SESSION_SELECTED_SAMPLES) = samples
            gvSelectedSamples.DataSource = samples
            gvSelectedSamples.DataBind()

            Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES) = New List(Of LabSampleGetListModel)()
            gvAliqoutsDerivatives.DataSource = Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES)
            gvAliqoutsDerivatives.DataBind()

            FillTreeView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ddlTypeOfDerivative.Enabled = False
        ddlTypeOfDerivative.ClearSelection()
        reqTypeOfDerivative.Visible = False
        rfvDerivativeType.Enabled = False
        rblCreateAliquotDerivative.ClearSelection()

        txtNumberOfSamples.Text = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        FillBaseReferenceDropDownList(ddlTypeOfDerivative, BaseReferenceConstants.SampleType, HACodeList.AllHACode, True)

    End Sub

    Private Sub FillTreeView()

        If LaboratoryAPIService Is Nothing Then
            LaboratoryAPIService = New LaboratoryServiceClient()
        End If

        Dim freezerSubdivisions = LaboratoryAPIService.LaboratoryFreezerSubdivisionGetListAsync(GetCurrentLanguage(), Nothing, hdfSiteID.Value).Result
        Dim freezers = freezerSubdivisions.GroupBy(Function(x) x.FreezerID).Select(Function(y) y.First())

        Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="parentID"></param>
    ''' <param name="parentNode"></param>
    Private Function PopulateTreeView(ByVal subdivisions As TreeView, ByVal parentID As Long, ByVal parentNode As TreeNode) As TreeView

        Try
            Dim childNode As TreeNode

            For Each item As TreeViewItem In treeViewList.Where(Function(x) x.ParentID = parentID)
                Dim t As TreeNode = New TreeNode With {.Text = item.Text, .Value = item.ID}

                If parentNode Is Nothing Then
                    subdivisions.Nodes.Add(t)
                    childNode = t
                Else
                    parentNode.ChildNodes.Add(t)
                    childNode = t
                End If

                If Not parentID = childNode.Value Then
                    subdivisions = PopulateTreeView(subdivisions, item.ID, childNode)
                End If
            Next

            Return subdivisions
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return Nothing

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        hdfSiteID.Value = Session("UserSite")
        hdfPersonID.Value = Session("Person")

    End Sub

#End Region

#Region "Aliquot/Derivative Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Public Function Save() As List(Of LabSampleGetListModel)

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Dim samplesSelected As List(Of LabSampleGetListModel) = CType(Session(SESSION_SELECTED_SAMPLES), List(Of LabSampleGetListModel))
            If samplesSelected Is Nothing Then
                samplesSelected = New List(Of LabSampleGetListModel)()
            End If

            Dim aliquotDerivativeSamples As List(Of LabSampleGetListModel) = CType(Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES), List(Of LabSampleGetListModel))
            If aliquotDerivativeSamples Is Nothing Then
                aliquotDerivativeSamples = New List(Of LabSampleGetListModel)()
            End If

            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            If freezerSubdivisions Is Nothing Then
                freezerSubdivisions = New List(Of LabFreezerSubdivisionGetListModel)()
            End If
            FreezerBoxLocationAvailabilities = New List(Of FreezerBoxLocationAvailabilityParameters)()
            Dim freezerBoxLocationAvailability As FreezerBoxLocationAvailabilityParameters

            For Each freezerSubdivision In freezerSubdivisions
                If Not freezerSubdivision.BoxPlaceAvailability Is Nothing Then
                    freezerBoxLocationAvailability = New FreezerBoxLocationAvailabilityParameters With {.FreezerSubdivisionID = freezerSubdivision.SubdivisionID, .BoxPlaceAvailability = freezerSubdivision.BoxPlaceAvailability}
                    FreezerBoxLocationAvailabilities.Add(freezerBoxLocationAvailability)
                End If
            Next

            Return aliquotDerivativeSamples
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

        Return New List(Of LabSampleGetListModel)()

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub OK_Click(sender As Object, e As EventArgs) Handles btnOK.Click

        Try
            Dim samplesSelected As List(Of LabSampleGetListModel) = CType(Session(SESSION_SELECTED_SAMPLES), List(Of LabSampleGetListModel))
            If samplesSelected Is Nothing Then
                samplesSelected = New List(Of LabSampleGetListModel)()
            End If

            Dim aliquotDerivativeSamples As List(Of LabSampleGetListModel) = CType(Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES), List(Of LabSampleGetListModel))
            If aliquotDerivativeSamples Is Nothing Then
                aliquotDerivativeSamples = New List(Of LabSampleGetListModel)()
            End If

            Dim aliquotDerivativeSample As LabSampleGetListModel
            Dim index As Integer = 0
            Dim identity As Integer = hdfIdentity.Value
            Dim parameters As LaboratorySearchParameters
            Dim sampleSearchCounts As List(Of LabSampleSearchGetCountModel)

            For Each sample In samplesSelected
                index = 0

                If LaboratoryAPIService Is Nothing Then
                    LaboratoryAPIService = New LaboratoryServiceClient()
                End If

                parameters = New LaboratorySearchParameters With {.LanguageID = GetCurrentLanguage(), .SearchString = sample.EIDSSLaboratorySampleID}
                sampleSearchCounts = LaboratoryAPIService.LaboratorySampleSearchGetListCountAsync(parameters).Result

                If sample.RowSelectionIndicator = 1 Then
                    While index < txtNumberOfSamples.Text
                        aliquotDerivativeSample = New LabSampleGetListModel With {
                            .SampleID = ((identity + 1) * -1),
                            .RowAction = RecordConstants.InsertAliquotDerivative,
                            .AccessionByPersonID = sample.AccessionByPersonID,
                            .AccessionConditionOrSampleStatusTypeName = Resources.Labels.Lbl_Accepted_In_Good_Condition_Text,
                            .AccessionConditionTypeID = AccessionConditionTypes.AcceptedInGoodCondition,
                            .AccessionConditionTypeName = Resources.Labels.Lbl_Accepted_In_Good_Condition_Text,
                            .AccessionDate = Date.Now,
                            .AccessionIndicator = 1,
                            .AnimalID = sample.AnimalID,
                            .BirdStatusTypeID = sample.BirdStatusTypeID,
                            .CollectedByOrganizationID = sample.CollectedByOrganizationID,
                            .CollectedByOrganizationName = sample.CollectedByOrganizationName,
                            .CollectedByPersonID = sample.CollectedByPersonID,
                            .CollectedByPersonName = sample.CollectedByPersonName,
                            .CollectionDate = sample.CollectionDate,
                            .CurrentSiteID = hdfSiteID.Value,
                            .DestroyedByPersonID = sample.DestroyedByPersonID,
                            .DestructionDate = sample.DestructionDate,
                            .DestructionMethodTypeID = sample.DestructionMethodTypeID,
                            .DestructionMethodTypeName = sample.DestructionMethodTypeName,
                            .DiseaseID = sample.DiseaseID,
                            .DiseaseName = sample.DiseaseName,
                            .EIDSSAnimalID = sample.EIDSSAnimalID,
                            .EIDSSLaboratoryOrLocalFieldSampleID = sample.EIDSSLaboratoryOrLocalFieldSampleID,
                            .EIDSSLaboratorySampleID = sample.EIDSSLaboratorySampleID & "-" & sampleSearchCounts.FirstOrDefault().RecordCount.ToString(),
                            .EIDSSLocalFieldSampleID = sample.EIDSSLocalFieldSampleID,
                            .EIDSSReportSessionID = sample.EIDSSReportSessionID,
                            .EnteredDate = Date.Now,
                            .FavoriteIndicator = 0,
                            .FreezerSubdivisionID = Nothing,
                            .FunctionalAreaID = sample.FunctionalAreaID,
                            .FunctionalAreaName = sample.FunctionalAreaName,
                            .HumanDiseaseReportID = sample.HumanDiseaseReportID,
                            .HumanID = sample.HumanID,
                            .MainTestID = sample.MainTestID,
                            .MarkedForDispositionByPersonID = sample.MarkedForDispositionByPersonID,
                            .MonitoringSessionID = sample.MonitoringSessionID,
                            .Note = Nothing,
                            .OutOfRepositoryDate = sample.OutOfRepositoryDate,
                            .ParentEIDSSLaboratorySampleID = sample.EIDSSLaboratorySampleID,
                            .ParentSampleID = sample.SampleID,
                            .RowSelectionIndicator = 0
                        }

                        sampleSearchCounts.FirstOrDefault().RecordCount += 1

                        If rblCreateAliquotDerivative.SelectedValue = SampleKindTypes.Aliquot Then
                            aliquotDerivativeSample.SampleKindTypeID = SampleKindTypes.Aliquot
                            aliquotDerivativeSample.SampleTypeID = sample.SampleTypeID
                            aliquotDerivativeSample.SampleTypeName = sample.SampleTypeName
                        Else
                            aliquotDerivativeSample.SampleKindTypeID = SampleKindTypes.Derivative
                            aliquotDerivativeSample.SampleTypeID = ddlTypeOfDerivative.SelectedValue
                            aliquotDerivativeSample.SampleTypeName = ddlTypeOfDerivative.SelectedItem.Text
                        End If

                        aliquotDerivativeSample.SampleStatusTypeID = SampleStatusTypes.InRepository
                        aliquotDerivativeSample.SentDate = sample.SentDate
                        aliquotDerivativeSample.SiteID = hdfSiteID.Value
                        aliquotDerivativeSample.SpeciesID = sample.SpeciesID
                        aliquotDerivativeSample.StorageBoxPlace = Nothing
                        aliquotDerivativeSample.TestAssignedCount = 0
                        aliquotDerivativeSample.TestAssignedIndicator = 0
                        aliquotDerivativeSample.TestCompletedIndicator = 0
                        aliquotDerivativeSample.TransferCount = 0
                        aliquotDerivativeSample.VectorID = sample.VectorID
                        aliquotDerivativeSample.VectorSessionID = sample.VectorSessionID
                        aliquotDerivativeSample.VeterinaryDiseaseReportID = sample.VeterinaryDiseaseReportID

                        aliquotDerivativeSamples.Add(aliquotDerivativeSample)
                        index += 1
                        identity += 1
                    End While
                End If
            Next

            hdfIdentity.Value = identity

            Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES) = aliquotDerivativeSamples

            gvAliqoutsDerivatives.DataSource = aliquotDerivativeSamples
            gvAliqoutsDerivatives.DataBind()
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
    Private Sub SelectedSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSelectedSamples.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.ToggleSelect
                    e.Handled = True
                    Dim gvr As GridViewRow = CType(((CType(e.CommandSource, LinkButton)).NamingContainer), GridViewRow)
                    Dim btnSelectedSample As LinkButton = CType(e.CommandSource, LinkButton)
                    Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_SELECTED_SAMPLES), List(Of LabSampleGetListModel))
                    Dim samplesID As Long = btnSelectedSample.CommandArgument
                    If btnSelectedSample.CssClass = CSS_BTN_GLYPHICON_CHECKED Then
                        samples.Where(Function(x) x.SampleID = samplesID).FirstOrDefault().RowSelectionIndicator = 0
                    Else
                        samples.Where(Function(x) x.SampleID = samplesID).FirstOrDefault().RowSelectionIndicator = 1
                    End If

                    Session(SESSION_SELECTED_SAMPLES) = samples

                    gvSelectedSamples.DataSource = samples
                    gvSelectedSamples.DataBind()
                    gvSelectedSamples.PageIndex = 0
            End Select
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
    Private Sub AliqoutsDerivatives_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAliqoutsDerivatives.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    Dim gvr As GridViewRow = CType(((CType(e.CommandSource, LinkButton)).NamingContainer), GridViewRow)
                    Dim btnDeleteSample As LinkButton = CType(e.CommandSource, LinkButton)
                    hdfCurrentRecord.Value = btnDeleteSample.CommandArgument
                    hdfCurrentModuleAction.Value = MessageType.ConfirmDelete

                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)
            End Select
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
    Private Sub AliqoutsDerivatives_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvAliqoutsDerivatives.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim sample As LabSampleGetListModel = TryCast(e.Row.DataItem, LabSampleGetListModel)
                If Not sample Is Nothing Then
                    Dim treSubdivisions As TreeView = CType(e.Row.FindControl("treSubdivisions"), TreeView)
                    Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
                    Dim freezers = freezerSubdivisions.GroupBy(Function(x) x.FreezerID).Select(Function(y) y.First())
                    Dim storageBoxLocation As String = ""

                    treeViewList = New List(Of TreeViewItem)()
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

                                If Not sample.FreezerSubdivisionID Is Nothing Then
                                    storageBoxLocation &= " " & Resources.Labels.Lbl_Shelf_Text & " #" & freezerSubdivision.SubdivisionName
                                End If
                            Case SubdivisionTypes.Rack
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Rack_Text") & " " & freezerSubdivision.SubdivisionName})

                                If Not sample.FreezerSubdivisionID Is Nothing Then
                                    storageBoxLocation &= " " & Resources.Labels.Lbl_Rack_Text & " #" & freezerSubdivision.SubdivisionName
                                End If
                            Case SubdivisionTypes.Box
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Box_Text") & " " & freezerSubdivision.SubdivisionName})

                                If Not sample.StorageBoxPlace Is Nothing Then
                                    storageBoxLocation &= " " & Resources.Labels.Lbl_Box_Text & " #" & sample.StorageBoxPlace
                                End If
                        End Select
                    Next

                    Dim binding = New TreeNodeBinding With {.TextField = "Text", .ValueField = "ID"}
                    treSubdivisions.DataBindings.Add(binding)
                    treSubdivisions = PopulateTreeView(treSubdivisions, 0, Nothing)
                    treSubdivisions.Nodes(0).Text &= storageBoxLocation
                    treSubdivisions.CollapseAll()
                    treSubdivisions.ToolTip = sample.SampleID
                End If

                'Dim _cellIndex As Integer = -1
                '_cellIndex = GetColumnIndex(ViewState(SORT_EXPRESSION))

                'If (_cellIndex > -1) Then
                '    If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                '        e.Row.Cells(_cellIndex).CssClass = "glyphicon glyphicon-triangle-top"
                '    Else
                '        e.Row.Cells(_cellIndex).CssClass = "glyphicon glyphicon-triangle-bottom"
                '    End If
                'End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="_SortExpression"></param>
    ''' <returns></returns>
    Private Function GetColumnIndex(_SortExpression As String) As Integer

        Dim intI As Integer = -1
        For Each col As DataControlField In gvAliqoutsDerivatives.Columns
            If col.SortExpression = _SortExpression Then
                intI = gvAliqoutsDerivatives.Columns.IndexOf(col)
                Exit For
            End If
        Next

        Return intI

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub AliqoutsDerivatives_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvAliqoutsDerivatives.Sorting

        Try
            ViewState(SORT_DIRECTION) = IIf(ViewState(SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(SORT_EXPRESSION) = e.SortExpression

            BindGridView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindGridView()

        Dim aliquotDerivativeSamples = CType(Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES), List(Of LabSampleGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                aliquotDerivativeSamples = aliquotDerivativeSamples.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                aliquotDerivativeSamples = aliquotDerivativeSamples.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES) = aliquotDerivativeSamples

        gvAliqoutsDerivatives.DataSource = aliquotDerivativeSamples
        gvAliqoutsDerivatives.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="boxConfiguration"></param>
    ''' <param name="columns"></param>
    ''' <param name="rows"></param>
    Private Function BuildBoxConfiguration(ByVal sampleID As Long, ByVal subdivisionID As Long, ByVal tblBoxConfiguration As Table, ByVal columns As Integer, ByVal rows As Integer, ByVal boxConfiguration As String) As Table

        Try
            Dim tr As TableRow = New TableRow()
            Dim boxLocationAvailability = JsonConvert.DeserializeObject(Of List(Of FreezerSubdivisionBoxLocationAvailability))(boxConfiguration)

            For c As Integer = 0 To columns
                Dim tc As TableCell = New TableCell With {
                    .ID = "tc_" & c.ToString() & "_0"
                }
                If c > 0 Then
                    tc.Text = c.ToString()
                End If
                tr.Cells.Add(tc)
            Next
            tblBoxConfiguration.Rows.Add(tr)

            For r As Integer = 1 To rows
                tr = New TableRow()

                For c As Integer = 0 To columns
                    Dim tc As TableCell = New TableCell With {.ID = "tc_" & c.ToString() & "_" & r.ToString()}

                    If c = 0 Then
                        tc.Text = GetLetter(r)
                    Else
                        Dim rad As RadioButton = New RadioButton With {
                            .AutoPostBack = True,
                            .Checked = False,
                            .ID = "rad_" & GetLetter(r) & "_" & c.ToString() & "_Sample_" & sampleID & "_Box_" & subdivisionID,
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

            upAliquotsDerivatives.Update()

            Return tblBoxConfiguration
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return Nothing

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="boxLocation"></param>
    Protected Sub AliquotDerivativeBoxLocationChanged_Event(boxLocation As String) Handles Me.AliquotDerivativeBoxLocationChanged

        Try
            Dim boxLocationArray As String() = boxLocation.Split("_")
            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            Dim samples = CType(Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES), List(Of LabSampleGetListModel))
            Dim newStorageBoxPlace As String = boxLocationArray(1) & "-" & boxLocationArray(2)
            Dim sampleID As Long = boxLocationArray(4)
            Dim newSubdivisionID As Long = boxLocationArray(6)
            Dim oldSubdivisionID As Long = 0
            Dim oldStorageBoxPlace As String = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().StorageBoxPlace

            If freezerSubdivisions Is Nothing Then
                freezerSubdivisions = New List(Of LabFreezerSubdivisionGetListModel)()
            End If

            If Not samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().FreezerSubdivisionID Is Nothing Then
                oldSubdivisionID = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().FreezerSubdivisionID
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

            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().FreezerSubdivisionID = newSubdivisionID
            samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault().StorageBoxPlace = newStorageBoxPlace

            Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions
            Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES) = samples

            gvAliqoutsDerivatives.DataSource = samples
            gvAliqoutsDerivatives.DataBind()
            gvAliqoutsDerivatives.PageIndex = 0
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
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
    Private Sub SelectedSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSelectedSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim sample As LabSampleGetListModel = TryCast(e.Row.DataItem, LabSampleGetListModel)
                Dim i As Integer = 0

                If Not sample Is Nothing Then
                    Dim btnToggleSamples As LinkButton = CType(e.Row.FindControl("btnToggleSamples"), LinkButton)

                    If sample.RowSelectionIndicator = 0 Then
                        btnToggleSamples.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                    Else
                        btnToggleSamples.CssClass = CSS_BTN_GLYPHICON_CHECKED
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Subdivisions_SelectedNodeChanged(sender As Object, e As EventArgs)

        Try
            Dim treSubdivisions As TreeView = CType(sender, TreeView)
            Dim row As GridViewRow = CType(treSubdivisions.NamingContainer, GridViewRow)
            Dim sampleID As Long = gvAliqoutsDerivatives.DataKeys(row.RowIndex).Value
            Dim tblBoxConfiguration As Table = CType(row.FindControl("tblBoxConfiguration"), Table)
            Dim freezerSubdivision = New LabFreezerSubdivisionGetListModel()
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
                        tblBoxConfiguration = BuildBoxConfiguration(sampleID, freezerSubdivision.SubdivisionID, tblBoxConfiguration, boxSize(0), boxSize(1), freezerSubdivision.BoxPlaceAvailability)
                        tblBoxConfiguration.Visible = True

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
    Protected Sub Note_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txt As TextBox = sender

            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES), List(Of LabSampleGetListModel))
            If Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES) Is Nothing Then
                samples = New List(Of LabSampleGetListModel)()
            End If

            samples.Where(Function(x) x.SampleID = txt.ToolTip).FirstOrDefault().Note = txt.Text

            Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES) = samples
            gvAliqoutsDerivatives.PageIndex = 0
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        hdgWarning.InnerText = Resources.WarningMessages.Warning_Message_Alert

        Select Case messageType
            Case MessageType.ConfirmDelete
                divWarningBody.InnerHtml = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.PrintBarcodes
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Print_Bar_Codes_Body_Text")
        End Select

        If isConfirm Then
            divWarningYesNo.Visible = True
            divWarningOK.Visible = False
        Else
            divWarningOK.Visible = True
            divWarningYesNo.Visible = False
        End If

        upWarningModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "showModal('#divWarningModal');", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            Select Case hdfCurrentModuleAction.Value
                Case MessageType.ConfirmDelete
                    DeleteAliquotDerivative()
            End Select

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, "hideModalOnModal('#divWarningModal');", True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DeleteAliquotDerivative()

        Try
            Dim samples As List(Of LabSampleGetListModel) = CType(Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES), List(Of LabSampleGetListModel))
            Dim sampleID As Long = hdfCurrentRecord.Value

            samples.Remove(samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault())

            Session(SESSION_ALIQUOT_DERIVATIVE_SAMPLES) = samples

            gvAliqoutsDerivatives.DataSource = samples
            gvAliqoutsDerivatives.DataBind()
            gvAliqoutsDerivatives.PageIndex = 0

            upAliquotsDerivatives.Update()
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
    Private Sub CreateAliquotDerivative_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblCreateAliquotDerivative.SelectedIndexChanged

        Try
            upTypeOfAliquotDerivative.Update()

            If rblCreateAliquotDerivative.SelectedValue = SampleKindTypes.Aliquot Then
                ddlTypeOfDerivative.Enabled = False
                rfvDerivativeType.Enabled = False
                reqTypeOfDerivative.Visible = False
                ddlTypeOfDerivative.ClearSelection()
            Else
                ddlTypeOfDerivative.Enabled = True
                rfvDerivativeType.Enabled = True
                reqTypeOfDerivative.Visible = True
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class