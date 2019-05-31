Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' 
''' Use Case: LUC12 - Edit a Test
''' 
''' The objective of the Edit a Test Use Case Specification is to define the functional requirements for 
''' a user to edit test details in the laboratory module in EIDSS. The functional requirements, or 
''' functionality that must be provided to users, are described in terms of use cases.
''' 
''' The Edit a Test Use Case Specification defines the functional requirements to give the user the ability 
''' to edit test details in the Laboratory Module of EIDSS.
''' 
''' </summary>
Public Class AddUpdateTestUserControl
    Inherits UserControl

#Region "Global Values"

    Private Const SESSION_TEST As String = "AddUpdateTest"

    Public Event ShowErrorModal(messageType As MessageType, message As String)
    Public Event ShowSearchEmployeeModal()
    Public Event ShowCreateEmployeeModal()

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private EmployeeAPIService As EmployeeServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(AddUpdateTestUserControl))

    Public Property Test As LabTestGetListModel
        Get
            Return CType(Session(SESSION_TEST), LabTestGetListModel)
        End Get
        Set(ByVal value As LabTestGetListModel)
            Session(SESSION_TEST) = value
        End Set
    End Property

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                cvStartedDate.ValueToCompare = Date.Now.ToShortDateString()
                cvResultDate.ValueToCompare = Date.Now.ToShortDateString()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testCount"></param>
    ''' <param name="testID"></param>
    Public Sub Setup(testCount As Integer, Optional testID As Long? = Nothing)

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Reset()

            FillDropDowns()

            hdfTestsCount.Value = testCount.ToString()

            If Test Is Nothing Then
                Test = New LabTestGetListModel()
            End If

            If Test.TestID = 0 Then
                hdfIdentity.Value = testCount
            End If

            FillTest()

            upAddUpdateTest.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        hdfRecordID.Value = "0"
        hdfRecordAction.Value = String.Empty
        hdfIdentity.Value = "0"
        hdfPersonID.Value = String.Empty
        hdfUserFirstName.Value = String.Empty
        hdfUserLastName.Value = String.Empty
        hdfTestsCount.Value = "0"
        hdfDiseaseID.Value = String.Empty
        hdfOrganizationID.Value = String.Empty

        ddlTestedByPerson.SelectedIndex = -1
        ddlTestNameTypeID.SelectedIndex = -1
        ddlTestStatusTypeID.SelectedIndex = -1
        ddlTestResultTypeID.SelectedIndex = -1
        txtContactPersonName.Text = String.Empty
        txtDiseaseName.Text = String.Empty
        txtReceivedDate.Text = String.Empty
        txtResultDate.Text = String.Empty
        txtResultsEnteredByPersonName.Text = String.Empty
        txtResultsReceivedByPersonName.Text = String.Empty
        txtStartedDate.Text = String.Empty
        txtTestCategoryTypeName.Text = String.Empty
        txtTestedByPersonName.Text = String.Empty
        txtTestNameTypeName.Text = String.Empty
        txtTestStatusTypeName.Text = String.Empty
        txtValidatedByPersonName.Text = String.Empty

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ToggleVisibility()

        ddlTestNameTypeID.Visible = Not hdfTestsCount.Value.IsValueNullOrEmpty()
        txtTestNameTypeName.Visible = hdfTestsCount.Value.IsValueNullOrEmpty()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        hdfSiteID.Value = Session("UserSite")
        hdfPersonID.Value = Session("Person")
        hdfOrganizationID.Value = Session("Institution")
        hdfUserFirstName.Value = Session("FirstName")
        hdfUserLastName.Value = Session("FamilyName")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        FillBaseReferenceDropDownList(ddlTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.AllHACode, True)
        FillBaseReferenceDropDownList(ddlTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.AllHACode, True)
        FillBaseReferenceDropDownList(ddlTestStatusTypeID, BaseReferenceConstants.TestStatus, HACodeList.AllHACode, True)

        'Removed by business rule in use case LUC04.  User may only use in progress and preliminary.
        Dim item As ListItem = ddlTestStatusTypeID.Items.FindByValue(TestStatusTypes.Amended)
        ddlTestStatusTypeID.Items.Remove(item)
        item = ddlTestStatusTypeID.Items.FindByValue(TestStatusTypes.Declined)
        ddlTestStatusTypeID.Items.Remove(item)
        item = ddlTestStatusTypeID.Items.FindByValue(TestStatusTypes.Deleted)
        ddlTestStatusTypeID.Items.Remove(item)
        item = ddlTestStatusTypeID.Items.FindByValue(TestStatusTypes.Final)
        ddlTestStatusTypeID.Items.Remove(item)
        item = ddlTestStatusTypeID.Items.FindByValue(TestStatusTypes.MarkedForDeletion)
        ddlTestStatusTypeID.Items.Remove(item)
        item = ddlTestStatusTypeID.Items.FindByValue(TestStatusTypes.NotStarted)
        ddlTestStatusTypeID.Items.Remove(item)

        If EmployeeAPIService Is Nothing Then
            EmployeeAPIService = New EmployeeServiceClient()
        End If

        If hdfOrganizationID.Value.IsValueNullOrEmpty() Then
            GetUserProfile()
        End If

        Dim parameters = New AdminEmployeeGetListParams With {.OrganizationID = hdfOrganizationID.Value}
        Dim employees = EmployeeAPIService.GetEmployees(parameters).Result
        ddlTestedByPerson.DataSource = employees.ToList()
        ddlTestedByPerson.DataTextField = "EmployeeFullName"
        ddlTestedByPerson.DataValueField = "EmployeeID"
        ddlTestedByPerson.DataBind()

    End Sub

#End Region

#Region "Add/Update Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillTest()

        Scatter(Me, Test)

        txtDiseaseName.Text = Test.DiseaseName

        If Not Test.ExternalTestIndicator Is Nothing Then
            chkExternalResultsIndicator.Checked = Test.ExternalTestIndicator
        End If

        If (Test.TestNameTypeID.ToString().IsValueNullOrEmpty() = False And (Test.RowAction = RecordConstants.Read Or Test.RowAction = String.Empty)) Then
            ddlTestNameTypeID.Visible = False
            txtTestNameTypeName.Visible = True
        Else
            ddlTestNameTypeID.Visible = True
            txtTestNameTypeName.Visible = False
        End If

        If Test.TestResultTypeID.ToString().IsValueNullOrEmpty = False Then
            If Test.TestResultTypeID.ToString() = TestResultTypes.Indeterminate.ToString() Then
                ddlTestStatusTypeID.Visible = True
                txtTestStatusTypeName.Visible = False
                ddlTestResultTypeID.Enabled = True

                ddlTestedByPerson.Visible = True
                txtTestedByPersonName.Visible = False
            Else
                ddlTestStatusTypeID.Visible = False
                txtTestStatusTypeName.Visible = True
                ddlTestResultTypeID.Enabled = False
                ddlTestedByPerson.Visible = False
                txtTestedByPersonName.Visible = True
            End If
        Else
            ddlTestStatusTypeID.Visible = True
            txtTestStatusTypeName.Visible = False
            ddlTestResultTypeID.Enabled = True

            ddlTestedByPerson.Visible = True
            txtTestedByPersonName.Visible = False
        End If

        If Test.ExternalTestIndicator.ToString().IsValueNullOrEmpty = False Then
            If Test.ExternalTestIndicator = True Then
                txtResultsReceivedByPersonName.Enabled = True
                txtReceivedDate.Enabled = True
                txtContactPersonName.Enabled = True
            Else
                txtResultsReceivedByPersonName.Enabled = False
                txtReceivedDate.Enabled = False
                txtContactPersonName.Enabled = False
            End If
        Else
            txtResultsReceivedByPersonName.Enabled = False
            txtReceivedDate.Enabled = False
            txtContactPersonName.Enabled = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Function Save() As LabTestGetListModel

        Try
            Page.Validate("EditSampleTestDetails")

            If Page.IsValid Then
                Dim identity As Integer = 0

                If Test.RowAction = RecordConstants.Insert Then
                    With Test
                        .ResultDate = If(String.IsNullOrEmpty(txtResultDate.Text), CType(Nothing, Date?), Date.Parse(txtResultDate.Text))
                        .ContactPersonName = If(String.IsNullOrEmpty(txtContactPersonName.Text), Nothing, txtContactPersonName.Text)
                        .ExternalTestIndicator = If(chkExternalResultsIndicator.Checked, True, False)
                        .NonLaboratoryTestIndicator = False
                        .ReadOnlyIndicator = False
                        .RowAction = RecordConstants.Insert
                        .RowSelectionIndicator = 0
                        .RowStatus = RecordConstants.ActiveRowStatus
                        .TestedByPersonID = If(String.IsNullOrEmpty(ddlTestedByPerson.SelectedValue.ToString()), CType(Nothing, Long?), Long.Parse(ddlTestedByPerson.SelectedValue))
                        .TestedByPersonName = If(String.IsNullOrEmpty(ddlTestedByPerson.SelectedValue.ToString()), Nothing, ddlTestedByPerson.SelectedItem.Text)
                        hdfIdentity.Value += 1
                        identity = (hdfIdentity.Value * -1)
                        .TestID = identity
                        .TestNameTypeID = If(ddlTestNameTypeID.SelectedValue = GlobalConstants.NullValue, CType(Nothing, Long?), Long.Parse(ddlTestNameTypeID.SelectedValue))
                    End With
                Else
                    With Test
                        .ExternalTestIndicator = If(chkExternalResultsIndicator.Checked, True, False)
                        .ResultDate = If(String.IsNullOrEmpty(txtResultDate.Text), CType(Nothing, Date?), Date.Parse(txtResultDate.Text))
                        .ContactPersonName = IIf(txtContactPersonName.Text.ToString() = String.Empty, Nothing, txtContactPersonName.Text)
                        .DiseaseID = If(String.IsNullOrEmpty(hdfDiseaseID.Value), CType(Nothing, Long?), Long.Parse(hdfDiseaseID.Value))
                        .FavoriteIndicator = 0
                        .NonLaboratoryTestIndicator = False
                        .ReadOnlyIndicator = False
                        .RowAction = RecordConstants.Update
                        .RowSelectionIndicator = 0
                        .RowStatus = RecordConstants.ActiveRowStatus
                        .StartedDate = If(String.IsNullOrEmpty(txtStartedDate.Text), CType(Nothing, Date?), Date.Parse(txtStartedDate.Text))
                        .TestedByPersonID = If(String.IsNullOrEmpty(ddlTestedByPerson.SelectedValue.ToString()), CType(Nothing, Long?), Long.Parse(ddlTestedByPerson.SelectedValue))
                        .TestedByPersonName = If(String.IsNullOrEmpty(ddlTestedByPerson.SelectedValue.ToString()), Nothing, ddlTestedByPerson.SelectedItem.Text)
                        .TestNameTypeID = If(IsValueNullOrEmpty(ddlTestNameTypeID.SelectedValue.ToString()), CType(Nothing, Long?), Long.Parse(ddlTestNameTypeID.SelectedValue))
                        .TestNameTypeName = If(IsValueNullOrEmpty(ddlTestNameTypeID.SelectedValue.ToString()), Nothing, ddlTestNameTypeID.SelectedItem.Text)
                        .TestResultTypeID = If(IsValueNullOrEmpty(ddlTestResultTypeID.SelectedValue.ToString()), CType(Nothing, Long?), Long.Parse(ddlTestResultTypeID.SelectedValue))
                        .TestResultTypeName = If(IsValueNullOrEmpty(ddlTestResultTypeID.SelectedValue.ToString()), Nothing, ddlTestResultTypeID.SelectedItem.Text)
                        .TestStatusTypeID = If(IsValueNullOrEmpty(ddlTestStatusTypeID.SelectedValue.ToString()), CType(Nothing, Long?), Long.Parse(ddlTestStatusTypeID.SelectedValue))
                        .TestStatusTypeName = If(IsValueNullOrEmpty(ddlTestStatusTypeID.SelectedValue.ToString()), Nothing, ddlTestStatusTypeID.SelectedItem.Text)
                    End With
                End If

                If Test.TestNameTypeID Is Nothing Then
                    Test.TestStatusTypeID = TestStatusTypes.NotStarted
                    Test.TestStatusTypeName = Resources.Labels.Lbl_Not_Started_Text
                End If

                Return Test
            Else
                RaiseEvent ShowErrorModal(messageType:=MessageType.CannotEditTest, message:=String.Empty)

                Return Nothing
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return Nothing

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub TestNameTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTestNameTypeID.SelectedIndexChanged

        Try
            If ddlTestNameTypeID.SelectedValue.IsValueNullOrEmpty() = False Then
                txtStartedDate.Text = Date.Today
            Else
                txtStartedDate.Text = String.Empty
            End If

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            If hdfDiseaseID.Value.IsValueNullOrEmpty() = False Then
                Dim testsByDisease As List(Of GblTestDiseaseGetListModel) = CrossCuttingAPIService.GetTestByDiseaseListAsync(GetCurrentLanguage(), hdfDiseaseID.Value).Result.OrderBy(Function(x) x.TestNameTypeName).ToList()

                hdfTestCategoryTypeID.Value = testsByDisease.Where(Function(x) x.TestNameTypeID = ddlTestNameTypeID.SelectedValue And x.DiseaseID).FirstOrDefault().TestCategoryTypeID
                txtTestCategoryTypeName.Text = testsByDisease.Where(Function(x) x.TestNameTypeID = ddlTestNameTypeID.SelectedValue And x.DiseaseID).FirstOrDefault().TestCategoryTypeName
            End If

            upAddUpdateTest.Update()
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
    Protected Sub TestResultTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTestResultTypeID.SelectedIndexChanged

        Try
            If ddlTestResultTypeID.SelectedValue.IsValueNullOrEmpty() = False Then
                ddlTestStatusTypeID.SelectedValue = TestStatusTypes.Preliminary
                txtResultDate.Text = Date.Today

                GetUserProfile()

                Test.ResultEnteredByPersonID = hdfPersonID.Value
                Test.ResultEnteredByOrganizationID = hdfOrganizationID.Value
                txtResultsEnteredByPersonName.Text = hdfUserFirstName.Value & " " & hdfUserLastName.Value
                Test.ResultEnteredByPersonName = txtResultsEnteredByPersonName.Text
            Else
                ddlTestStatusTypeID.SelectedValue = TestStatusTypes.InProgress
                txtResultDate.Text = String.Empty
                Test.ResultEnteredByOrganizationID = Nothing
                Test.ResultEnteredByOrganizationName = String.Empty
                Test.ResultEnteredByPersonID = Nothing
                txtResultsEnteredByPersonName.Text = String.Empty
                Test.ResultEnteredByPersonName = String.Empty
            End If

            upAddUpdateTest.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Tested By Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="employeeID"></param>
    Public Sub SetEmployee(employeeID As Long)

        Try
            If employeeID.ToString().IsValueNullOrEmpty = False Then
                ddlTestedByPerson.SelectedValue = employeeID
            End If

            upAddUpdateTest.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Transfer Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="transfer"></param>
    Public Sub SetFromTransfer(transfer As LabTransferGetListModel)

        'txtResultsReceivedByPersonName.Text = transfer.r
        If Not transfer.ResultDate Is Nothing Then
            txtReceivedDate.Text = transfer.ResultDate
        End If

    End Sub

#End Region

End Class