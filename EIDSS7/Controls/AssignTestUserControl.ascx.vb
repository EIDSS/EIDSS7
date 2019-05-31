Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain

''' <summary>
''' 
''' Use Case: LUC04
''' 
''' The objective of the Assign a Test Use Case Specification is to define the functional requirements for 
''' a user to assign a test in the laboratory module in EIDSS. The functional requirements, or functionality 
''' that must be provided to users, are described in terms of use cases.
''' 
''' The Assign a Test Use Case Specification defines the functional requirements to give the user the ability 
''' to assign a test in the Laboratory Module of EIDSS.
''' 
''' </summary>
Public Class AssignTestUserControl
    Inherits UserControl

#Region "Global Values"

    Private Const SESSION_TEST_ASSIGNMENTS_LIST As String = "ucAssignTest_Tests"
    Private Const SESSION_TESTS_BY_DISEASES_LIST As String = "ucAssignTest_TestsByDiseases"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(AssignTestUserControl))

    Public Event FilterTestNameByDiseaseCheckedChanged(checked As Boolean)
    Public Event ShowErrorModal(messageType As MessageType, message As String)

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If Not IsPostBack Then
                Session(SESSION_TEST_ASSIGNMENTS_LIST) = New List(Of LabTestGetListModel)()
                gvTestAssignments.DataSource = Session(SESSION_TEST_ASSIGNMENTS_LIST)
                gvTestAssignments.DataBind()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="diseaseIDList">List of diseases associated with the selected samples corresponding diseases.</param>
    Public Sub Setup(diseaseIDList As String)

        Try
            upAssignTest.Update()

            Session(SESSION_TEST_ASSIGNMENTS_LIST) = New List(Of LabTestGetListModel)()
            gvTestAssignments.DataSource = Session(SESSION_TEST_ASSIGNMENTS_LIST)
            gvTestAssignments.DataBind()

            hdfDiseaseIDList.Value = diseaseIDList

            FillDropDowns()

            Reset()

            If hdfDiseaseIDList.Value.IsValueNullOrEmpty() Then
                cbxFilterTestNameByDisease.Enabled = False
                FillBaseReferenceDropDownList(ddlInsertTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.AllHACode, True)
            Else
                cbxFilterTestNameByDisease.Checked = True
                cbxFilterTestNameByDisease.Enabled = True
                FilterTestsByDisease()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindGridView()

        Dim testAssignments As List(Of LabTestGetListModel) = CType(Session(SESSION_TEST_ASSIGNMENTS_LIST), List(Of LabTestGetListModel))

        gvTestAssignments.DataSource = testAssignments.GroupBy(Function(x) x.TestNameTypeID).Select(Function(x) x.First).ToList().OrderBy(Function(x) x.TestNameTypeName)
        gvTestAssignments.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub FilterTestNameByDisease_CheckedChanged(sender As Object, e As EventArgs) Handles cbxFilterTestNameByDisease.CheckedChanged

        Try
            If cbxFilterTestNameByDisease.Checked Then
                FilterTestsByDisease()
            Else
                FillBaseReferenceDropDownList(ddlInsertTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.AllHACode, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FilterTestsByDisease()

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        Dim list As List(Of GblTestDiseaseGetListModel) = CrossCuttingAPIService.GetTestByDiseaseListAsync(GetCurrentLanguage(), hdfDiseaseIDList.Value).Result.OrderBy(Function(x) x.TestNameTypeName).ToList()
        FillDropDownList(ddlInsertTestNameTypeID, list, {GlobalConstants.NullValue}, TestNameTypeConstants.TestNameTypeID, TestNameTypeConstants.TestNameTypeName, Nothing, Nothing, True)

        Session(SESSION_TESTS_BY_DISEASES_LIST) = list

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        FillBaseReferenceDropDownList(ddlInsertTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.AllHACode, True)
        FillBaseReferenceDropDownList(ddlInsertTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.AllHACode, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ddlInsertTestNameTypeID.SelectedIndex = -1
        ddlInsertTestResultTypeID.SelectedIndex = -1

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        hdfPersonID.Value = Session("Person")
        hdfOrganizationID.Value = Session("Institution")

    End Sub

#End Region

#Region "Assign Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestAssignments_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTestAssignments.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim test As LabTestGetListModel = TryCast(e.Row.DataItem, LabTestGetListModel)
            If Not test Is Nothing Then
                Dim ddl As DropDownList = CType(e.Row.FindControl("ddlEditTestNameTypeID"), DropDownList)
                FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.TestName, HACodeList.AllHACode, True)
                ddl.SelectedValue = test.TestNameTypeID
                ddl.ToolTip = test.TestID

                ddl = CType(e.Row.FindControl("ddlEditTestResultTypeID"), DropDownList)
                FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.TestResult, HACodeList.AllHACode, True)

                If Not test.TestResultTypeID Is Nothing Then
                    ddl.SelectedValue = test.TestResultTypeID
                End If
                ddl.ToolTip = test.TestID
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub NewTestAssignment_Click(sender As Object, e As EventArgs) Handles btnNewTestAssignment.Click

        Try
            Dim test = New LabTestGetListModel()
            Dim testAssignments = CType(Session(SESSION_TEST_ASSIGNMENTS_LIST), List(Of LabTestGetListModel))
            Dim testsByDisease As List(Of GblTestDiseaseGetListModel)

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)

            If testAssignments Is Nothing Then
                testAssignments = New List(Of LabTestGetListModel)()
            End If

            If Session(SESSION_TESTS_BY_DISEASES_LIST) Is Nothing Then
                testsByDisease = New List(Of GblTestDiseaseGetListModel)()
            Else
                testsByDisease = CType(Session(SESSION_TESTS_BY_DISEASES_LIST), List(Of GblTestDiseaseGetListModel))
            End If

            If ddlInsertTestNameTypeID.SelectedValue = GlobalConstants.NullValue Then
                test.TestNameTypeID = Nothing
                test.TestNameTypeName = Nothing
            Else
                test.TestNameTypeID = CType(ddlInsertTestNameTypeID.SelectedValue, Long)
                test.TestNameTypeName = ddlInsertTestNameTypeID.SelectedItem.Text
            End If

            If ddlInsertTestResultTypeID.SelectedValue = GlobalConstants.NullValue Then
                test.TestResultTypeID = Nothing
                test.TestResultTypeName = Nothing

            Else
                test.TestResultTypeID = CType(ddlInsertTestResultTypeID.SelectedValue, Long)
                test.TestResultTypeName = ddlInsertTestResultTypeID.SelectedItem.Text
            End If

            If testsByDisease.Count = 0 Then
                test.TestCategoryTypeID = Nothing
            Else
                test.TestCategoryTypeID = testsByDisease.Where(Function(x) x.TestNameTypeID = ddlInsertTestNameTypeID.SelectedValue And x.DiseaseID).FirstOrDefault().TestCategoryTypeID
            End If

            If testsByDisease.Count = 0 Then
                test.TestCategoryTypeName = Nothing
            Else
                test.TestCategoryTypeName = testsByDisease.Where(Function(x) x.TestNameTypeID = ddlInsertTestNameTypeID.SelectedValue And x.DiseaseID).FirstOrDefault().TestCategoryTypeName
            End If

            test.TestID = identity
            testAssignments.Add(test)

            Session(SESSION_TEST_ASSIGNMENTS_LIST) = testAssignments

            BindGridView()

            Reset()
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
    Protected Sub EditTestNameTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddlEditTestNameTypeID As DropDownList = sender
            Dim testAssignments = CType(Session(SESSION_TEST_ASSIGNMENTS_LIST), List(Of LabTestGetListModel))

            If testAssignments Is Nothing Then
                testAssignments = New List(Of LabTestGetListModel)()
            End If

            If ddlEditTestNameTypeID.SelectedValue = GlobalConstants.NullValue Then
                testAssignments.Where(Function(x) x.TestID = ddlEditTestNameTypeID.ToolTip).FirstOrDefault().TestNameTypeID = Nothing
            Else
                testAssignments.Where(Function(x) x.TestID = ddlEditTestNameTypeID.ToolTip).FirstOrDefault().TestNameTypeID = CType(ddlEditTestNameTypeID.SelectedValue, Long)
            End If

            If ddlEditTestNameTypeID.SelectedValue = GlobalConstants.NullValue Then
                testAssignments.Where(Function(x) x.TestID = ddlEditTestNameTypeID.ToolTip).FirstOrDefault().TestNameTypeName = Nothing
            Else
                testAssignments.Where(Function(x) x.TestID = ddlEditTestNameTypeID.ToolTip).FirstOrDefault().TestNameTypeName = ddlEditTestNameTypeID.SelectedItem.Text
            End If

            Session(SESSION_TEST_ASSIGNMENTS_LIST) = testAssignments
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
    Protected Sub EditTestResultTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim ddlEditTestResultTypeID As DropDownList = sender
            Dim testAssignments = CType(Session(SESSION_TEST_ASSIGNMENTS_LIST), List(Of LabTestGetListModel))

            If testAssignments Is Nothing Then
                testAssignments = New List(Of LabTestGetListModel)()
            End If

            If ddlEditTestResultTypeID.SelectedValue = GlobalConstants.NullValue Then
                testAssignments.Where(Function(x) x.TestID = ddlEditTestResultTypeID.ToolTip).FirstOrDefault().TestResultTypeID = Nothing
            Else
                testAssignments.Where(Function(x) x.TestID = ddlEditTestResultTypeID.ToolTip).FirstOrDefault().TestResultTypeID = CType(ddlEditTestResultTypeID.SelectedValue, Long)
            End If

            If ddlEditTestResultTypeID.SelectedValue = GlobalConstants.NullValue Then
                testAssignments.Where(Function(x) x.TestID = ddlEditTestResultTypeID.ToolTip).FirstOrDefault().TestResultTypeName = Nothing
            Else
                testAssignments.Where(Function(x) x.TestID = ddlEditTestResultTypeID.ToolTip).FirstOrDefault().TestResultTypeName = ddlEditTestResultTypeID.SelectedItem.Text
            End If

            Session(SESSION_TEST_ASSIGNMENTS_LIST) = testAssignments
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="tab"></param>
    ''' <param name="samples"></param>
    ''' <param name="testing"></param>
    ''' <param name="transferred"></param>
    ''' <param name="myFavorites"></param>
    ''' <returns></returns>
    Public Function AssignTests(ByVal tab As String,
                                ByVal samples As List(Of LabSampleGetListModel),
                                ByVal testing As List(Of LabTestGetListModel),
                                ByVal transferred As List(Of LabTransferGetListModel),
                                ByVal myFavorites As List(Of LabFavoriteGetListModel)) As List(Of LabTestGetListModel)

        Try
            If Session(SESSION_TEST_ASSIGNMENTS_LIST) Is Nothing Then
                RaiseEvent ShowErrorModal(messageType:=MessageType.CannotAssignTest, message:=String.Empty)
            Else
                If CType(Session(SESSION_TEST_ASSIGNMENTS_LIST), List(Of LabTestGetListModel)).ToList().Count() = 0 Then
                    RaiseEvent ShowErrorModal(messageType:=MessageType.CannotAssignTest, message:=String.Empty)
                Else
                    Dim testAssignments = CType(Session(SESSION_TEST_ASSIGNMENTS_LIST), List(Of LabTestGetListModel))

                    If hdfOrganizationID.Value.IsValueNullOrEmpty = True Then
                        GetUserProfile()
                    End If

                    If testAssignments Is Nothing Then
                        testAssignments = New List(Of LabTestGetListModel)()
                    End If

                    Select Case tab
                        Case LaboratoryModuleTabConstants.Samples
                            Return AddTestsFromSamples(testAssignments, samples)
                        Case LaboratoryModuleTabConstants.Testing
                            Return AddTestsFromTesting(testAssignments, testing)
                        Case LaboratoryModuleTabConstants.Transferred
                            Return AddTestsFromTransferred(testAssignments, transferred)
                        Case LaboratoryModuleTabConstants.MyFavorites
                            Return AddTestsFromMyFavorites(testAssignments, myFavorites)
                    End Select
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return New List(Of LabTestGetListModel)()

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testAssignments"></param>
    ''' <param name="samples"></param>
    ''' <returns></returns>
    Private Function AddTestsFromSamples(ByVal testAssignments As List(Of LabTestGetListModel), ByVal samples As List(Of LabSampleGetListModel)) As List(Of LabTestGetListModel)

        Dim tests = New List(Of LabTestGetListModel)()
        Dim index As Integer = 0
        Dim testIndex As Integer = 0
        Dim identity As Integer = 0

        If samples Is Nothing Then
            samples = New List(Of LabSampleGetListModel)()
        End If

        For Each sample In samples
            testIndex = 0

            For Each testAssignment In testAssignments
                identity = identity + 1

                testAssignment = New LabTestGetListModel With {
                    .AccessionConditionTypeID = samples(index).AccessionConditionTypeID,
                    .AccessionConditionOrSampleStatusTypeName = samples(index).AccessionConditionOrSampleStatusTypeName,
                    .AccessionDate = samples(index).AccessionDate,
                    .BatchTestID = Nothing,
                    .ResultDate = Nothing,
                    .ContactPersonName = Nothing,
                    .DiseaseID = samples(index).DiseaseID,
                    .DiseaseName = samples(index).DiseaseName,
                    .EIDSSAnimalID = samples(index).EIDSSAnimalID,
                    .EIDSSLaboratorySampleID = samples(index).EIDSSLaboratorySampleID,
                    .EIDSSReportSessionID = samples(index).EIDSSReportSessionID,
                    .ExternalTestIndicator = 0,
                    .FunctionalAreaName = samples(index).FunctionalAreaName,
                    .NonLaboratoryTestIndicator = 0,
                    .Note = Nothing,
                    .ObservationID = Nothing,
                    .PatientFarmOwnerName = samples(index).PatientFarmOwnerName,
                    .PerformedByOrganizationID = hdfOrganizationID.Value,
                    .PerformedByOrganizationName = Nothing,
                    .PreviousTestStatusTypeID = Nothing,
                    .ReadOnlyIndicator = 0,
                    .ReceivedDate = Nothing,
                    .RowStatus = RecordConstants.ActiveRowStatus,
                    .RowSelectionIndicator = 0,
                    .RowAction = RecordConstants.Insert,
                    .SampleID = samples(index).SampleID,
                    .SampleStatusTypeID = samples(index).SampleStatusTypeID,
                    .SampleTypeName = samples(index).SampleTypeName,
                    .StartedDate = Date.Today,
                    .TestID = (identity * -1),
                    .TestCategoryTypeID = testAssignments(testIndex).TestCategoryTypeID,
                    .TestCategoryTypeName = testAssignments(testIndex).TestCategoryTypeName,
                    .TestNameTypeID = testAssignments(testIndex).TestNameTypeID,
                    .TestNameTypeName = testAssignments(testIndex).TestNameTypeName,
                    .TestResultTypeID = testAssignments(testIndex).TestResultTypeID,
                    .TestResultTypeName = testAssignments(testIndex).TestResultTypeName
                }

                If sample.FavoriteIndicator Is Nothing Then
                    testAssignment.FavoriteIndicator = 0
                Else
                    testAssignment.FavoriteIndicator = samples(index).FavoriteIndicator
                End If

                If testAssignment.TestResultTypeID Is Nothing Then
                    testAssignment.ResultEnteredByOrganizationID = Nothing
                    testAssignment.ResultEnteredByOrganizationName = Nothing
                    testAssignment.ResultDate = Nothing
                    testAssignment.TestStatusTypeID = TestStatusTypes.InProgress
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                Else
                    testAssignment.ResultDate = Date.Today
                    testAssignment.ResultEnteredByOrganizationID = hdfOrganizationID.Value
                    testAssignment.ResultEnteredByPersonID = hdfPersonID.Value
                    testAssignment.TestStatusTypeID = TestStatusTypes.Preliminary
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                End If

                tests.Add(testAssignment)

                testIndex += 1
            Next

            index += 1
        Next

        Return tests

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testAssignments"></param>
    ''' <param name="testing"></param>
    ''' <returns></returns>
    Private Function AddTestsFromTesting(ByVal testAssignments As List(Of LabTestGetListModel), ByVal testing As List(Of LabTestGetListModel)) As List(Of LabTestGetListModel)

        Dim tests = New List(Of LabTestGetListModel)()
        Dim index As Integer = 0
        Dim testIndex As Integer = 0
        Dim identity As Integer = 0

        If testing Is Nothing Then
            testing = New List(Of LabTestGetListModel)()
        End If

        For Each test In testing
            testIndex = 0
            For Each testAssignment In testAssignments
                identity = identity + 1

                testAssignment = New LabTestGetListModel With {
                    .AccessionConditionTypeID = tests(index).AccessionConditionTypeID,
                    .AccessionConditionOrSampleStatusTypeName = tests(index).AccessionConditionOrSampleStatusTypeName,
                    .AccessionDate = tests(index).AccessionDate,
                    .BatchTestID = Nothing,
                    .ResultDate = Nothing,
                    .ContactPersonName = Nothing,
                    .DiseaseID = tests(index).DiseaseID,
                    .DiseaseName = tests(index).DiseaseName,
                    .EIDSSAnimalID = tests(index).EIDSSAnimalID,
                    .EIDSSLaboratorySampleID = tests(index).EIDSSLaboratorySampleID,
                    .EIDSSReportSessionID = tests(index).EIDSSReportSessionID,
                    .ExternalTestIndicator = 0,
                    .FunctionalAreaName = tests(index).FunctionalAreaName,
                    .NonLaboratoryTestIndicator = 0,
                    .Note = Nothing,
                    .ObservationID = Nothing,
                    .PatientFarmOwnerName = tests(index).PatientFarmOwnerName,
                    .PerformedByOrganizationID = hdfOrganizationID.Value,
                    .PerformedByOrganizationName = Nothing,
                    .PreviousTestStatusTypeID = Nothing,
                    .ReadOnlyIndicator = 0,
                    .ReceivedDate = Nothing,
                    .RowStatus = RecordConstants.ActiveRowStatus,
                    .RowSelectionIndicator = 0,
                    .RowAction = RecordConstants.Insert,
                    .SampleID = tests(index).SampleID,
                    .SampleStatusTypeID = tests(index).SampleStatusTypeID,
                    .SampleTypeName = tests(index).SampleTypeName,
                    .StartedDate = Date.Today,
                    .TestID = (identity * -1),
                    .TestCategoryTypeID = testAssignments(testIndex).TestCategoryTypeID,
                    .TestCategoryTypeName = testAssignments(testIndex).TestCategoryTypeName,
                    .TestNameTypeID = testAssignments(testIndex).TestNameTypeID,
                    .TestNameTypeName = testAssignments(testIndex).TestNameTypeName,
                    .TestResultTypeID = testAssignments(testIndex).TestResultTypeID,
                    .TestResultTypeName = testAssignments(testIndex).TestResultTypeName
                }

                If test.FavoriteIndicator Is Nothing Then
                    testAssignment.FavoriteIndicator = 0
                Else
                    testAssignment.FavoriteIndicator = tests(index).FavoriteIndicator
                End If

                If testAssignment.TestResultTypeID Is Nothing Then
                    testAssignment.ResultEnteredByOrganizationID = Nothing
                    testAssignment.ResultEnteredByOrganizationName = Nothing
                    testAssignment.ResultDate = Nothing
                    testAssignment.TestStatusTypeID = TestStatusTypes.InProgress
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                Else
                    testAssignment.ResultDate = Date.Today
                    testAssignment.ResultEnteredByOrganizationID = hdfOrganizationID.Value
                    testAssignment.ResultEnteredByPersonID = hdfPersonID.Value
                    testAssignment.TestStatusTypeID = TestStatusTypes.Preliminary
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                End If

                tests.Add(testAssignment)

                testIndex += 1
            Next

            index += 1
        Next

        Return tests

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testAssignments"></param>
    ''' <param name="transferred"></param>
    ''' <returns></returns>
    Private Function AddTestsFromTransferred(ByVal testAssignments As List(Of LabTestGetListModel), ByVal transferred As List(Of LabTransferGetListModel)) As List(Of LabTestGetListModel)

        Dim tests = New List(Of LabTestGetListModel)()
        Dim index As Integer = 0
        Dim testIndex As Integer = 0
        Dim identity As Integer = 0

        If transferred Is Nothing Then
            transferred = New List(Of LabTransferGetListModel)()
        End If

        For Each transfer In transferred
            testIndex = 0
            For Each testAssignment In testAssignments
                identity = identity + 1

                testAssignment = New LabTestGetListModel With {
                    .AccessionConditionTypeID = transferred(index).AccessionConditionTypeID,
                    .AccessionConditionOrSampleStatusTypeName = transferred(index).AccessionConditionOrSampleStatusTypeName,
                    .AccessionDate = transferred(index).AccessionDate,
                    .BatchTestID = Nothing,
                    .ResultDate = Nothing,
                    .ContactPersonName = Nothing,
                    .DiseaseID = transferred(index).DiseaseID,
                    .DiseaseName = transferred(index).DiseaseName,
                    .EIDSSAnimalID = transferred(index).EIDSSAnimalID,
                    .EIDSSLaboratorySampleID = transferred(index).EIDSSLaboratorySampleID,
                    .EIDSSReportSessionID = transferred(index).EIDSSReportSessionID,
                    .ExternalTestIndicator = 0,
                    .FunctionalAreaName = transferred(index).FunctionalAreaName,
                    .NonLaboratoryTestIndicator = 0,
                    .Note = Nothing,
                    .ObservationID = Nothing,
                    .PatientFarmOwnerName = transferred(index).PatientFarmOwnerName,
                    .PerformedByOrganizationID = hdfOrganizationID.Value,
                    .PerformedByOrganizationName = Nothing,
                    .PreviousTestStatusTypeID = Nothing,
                    .ReadOnlyIndicator = 0,
                    .ReceivedDate = Nothing,
                    .RowStatus = RecordConstants.ActiveRowStatus,
                    .RowSelectionIndicator = 0,
                    .RowAction = RecordConstants.Insert,
                    .SampleID = transferred(index).TransferredOutSampleID,
                    .SampleStatusTypeID = transferred(index).SampleStatusTypeID,
                    .SampleTypeName = transferred(index).SampleTypeName,
                    .StartedDate = Date.Today,
                    .TestID = (identity * -1),
                    .TestCategoryTypeID = testAssignments(testIndex).TestCategoryTypeID,
                    .TestCategoryTypeName = testAssignments(testIndex).TestCategoryTypeName,
                    .TestNameTypeID = testAssignments(testIndex).TestNameTypeID,
                    .TestNameTypeName = testAssignments(testIndex).TestNameTypeName,
                    .TestResultTypeID = testAssignments(testIndex).TestResultTypeID,
                    .TestResultTypeName = testAssignments(testIndex).TestResultTypeName
                }

                If transfer.FavoriteIndicator Is Nothing Then
                    testAssignment.FavoriteIndicator = 0
                Else
                    testAssignment.FavoriteIndicator = transferred(index).FavoriteIndicator
                End If

                If testAssignment.TestResultTypeID Is Nothing Then
                    testAssignment.ResultEnteredByOrganizationID = Nothing
                    testAssignment.ResultEnteredByOrganizationName = Nothing
                    testAssignment.ResultDate = Nothing
                    testAssignment.TestStatusTypeID = TestStatusTypes.InProgress
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                Else
                    testAssignment.ResultDate = Date.Today
                    testAssignment.ResultEnteredByOrganizationID = hdfOrganizationID.Value
                    testAssignment.ResultEnteredByPersonID = hdfPersonID.Value
                    testAssignment.TestStatusTypeID = TestStatusTypes.Preliminary
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                    testAssignment.ExternalTestIndicator = 1
                End If

                tests.Add(testAssignment)

                testIndex += 1
            Next

            index += 1
        Next

        Return tests

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testAssignments"></param>
    ''' <param name="myFavorites"></param>
    ''' <returns></returns>
    Private Function AddTestsFromMyFavorites(ByVal testAssignments As List(Of LabTestGetListModel), ByVal myFavorites As List(Of LabFavoriteGetListModel)) As List(Of LabTestGetListModel)

        Dim tests = New List(Of LabTestGetListModel)()
        Dim index As Integer = 0
        Dim testIndex As Integer = 0
        Dim identity As Integer = 0

        If myFavorites Is Nothing Then
            myFavorites = New List(Of LabFavoriteGetListModel)()
        End If

        For Each myFavorite In myFavorites
            testIndex = 0
            For Each testAssignment In testAssignments
                identity = identity + 1

                testAssignment = New LabTestGetListModel With {
                    .AccessionConditionTypeID = Nothing,
                    .AccessionConditionOrSampleStatusTypeName = myFavorites(index).AccessionConditionOrSampleStatusTypeName,
                    .AccessionDate = myFavorites(index).AccessionDate,
                    .BatchTestID = Nothing,
                    .ResultDate = Nothing,
                    .ContactPersonName = Nothing,
                    .DiseaseID = myFavorites(index).DiseaseID,
                    .DiseaseName = myFavorites(index).DiseaseName,
                    .EIDSSAnimalID = myFavorites(index).EIDSSAnimalID,
                    .EIDSSLaboratorySampleID = myFavorites(index).EIDSSLaboratorySampleID,
                    .EIDSSReportSessionID = myFavorites(index).EIDSSReportSessionID,
                    .ExternalTestIndicator = 0,
                    .FavoriteIndicator = 1,
                    .FunctionalAreaName = myFavorites(index).FunctionalAreaName,
                    .NonLaboratoryTestIndicator = 0,
                    .Note = Nothing,
                    .ObservationID = Nothing,
                    .PatientFarmOwnerName = myFavorites(index).PatientFarmOwnerName,
                    .PerformedByOrganizationID = hdfOrganizationID.Value,
                    .PerformedByOrganizationName = Nothing,
                    .PreviousTestStatusTypeID = Nothing,
                    .ReadOnlyIndicator = 0,
                    .ReceivedDate = Nothing,
                    .RowStatus = RecordConstants.ActiveRowStatus,
                    .RowSelectionIndicator = 0,
                    .RowAction = RecordConstants.Insert,
                    .SampleID = tests(index).SampleID,
                    .SampleStatusTypeID = tests(index).SampleStatusTypeID,
                    .SampleTypeName = tests(index).SampleTypeName,
                    .StartedDate = Date.Today,
                    .TestID = (identity * -1),
                    .TestCategoryTypeID = testAssignments(testIndex).TestCategoryTypeID,
                    .TestCategoryTypeName = testAssignments(testIndex).TestCategoryTypeName,
                    .TestNameTypeID = testAssignments(testIndex).TestNameTypeID,
                    .TestNameTypeName = testAssignments(testIndex).TestNameTypeName,
                    .TestResultTypeID = testAssignments(testIndex).TestResultTypeID,
                    .TestResultTypeName = testAssignments(testIndex).TestResultTypeName
                }

                If testAssignment.TestResultTypeID Is Nothing Then
                    testAssignment.ResultEnteredByOrganizationID = Nothing
                    testAssignment.ResultEnteredByOrganizationName = Nothing
                    testAssignment.ResultDate = Nothing
                    testAssignment.TestStatusTypeID = TestStatusTypes.InProgress
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_In_Progress_Text
                Else
                    testAssignment.ResultDate = Date.Today
                    testAssignment.ResultEnteredByOrganizationID = hdfOrganizationID.Value
                    testAssignment.ResultEnteredByPersonID = hdfPersonID.Value
                    testAssignment.TestStatusTypeID = TestStatusTypes.Preliminary
                    testAssignment.TestStatusTypeName = Resources.Labels.Lbl_Preliminary_Text
                End If

                tests.Add(testAssignment)

                testIndex += 1
            Next

            index += 1
        Next

        Return tests

    End Function

#End Region

End Class