Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' 
''' Use Case: LUC07 - Amend a Test Result
''' 
''' The objective Of the Amend Test Result Use Case Specification Is To define the functional 
''' requirements for a user with appropriate permissions to amend a validated test result in 
''' the laboratory module In EIDSS. The functional requirements, or functionality that must be 
''' provided to users, are described in terms of use cases.
'''  
''' The Amend Test Result Use Case Specification defines the functional requirements to give 
''' the authorized user the ability to amend a validated test result in the Laboratory Module 
''' of EIDSS.
''' 
''' </summary>
Public Class AmendTestResultUserControl
    Inherits UserControl

#Region "Global Values"

    Private Const SESSION_TEST_AMENDMENTS_LIST As String = "gvTestAmendements_List"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(AmendTestResultUserControl))

    Public Property TestResultTypeName As String

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
                Reset()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        txtTestResultTypeName.Text = String.Empty
        ddlChangedTestResultTypeID.SelectedIndex = -1
        txtReasonForAmendment.Text = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="test"></param>
    Public Sub Setup(test As LabTestGetListModel)

        Dim testAmendementsPendingSave = CType(Session(SESSION_TEST_AMENDMENTS_LIST), List(Of TestAmendmentParameters))

        hdfIdentity.Value = testAmendementsPendingSave.Count + 1

        upAmendTestResult.Update()

        Reset()

        txtTestResultTypeName.Text = test.TestResultTypeName
        hdfOriginalTestResultTypeID.Value = test.TestResultTypeID
        hdfTestID.Value = test.TestID

        GetUserProfile()

        FillDropDowns(test.TestResultTypeID)

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns(ByVal currentTestResultTypeID As Long)

        Dim item As ListItem

        FillBaseReferenceDropDownList(ddlChangedTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.AllHACode, True)
        item = ddlChangedTestResultTypeID.Items.FindByValue(currentTestResultTypeID)
        ddlChangedTestResultTypeID.Items.Remove(item)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        hdfSiteID.Value = Session("UserSite")
        hdfPersonID.Value = Session("Person")
        hdfOrganizationID.Value = Session("Institution")
        hdfFirstName.Value = Session("FirstName")
        hdfLastName.Value = Session("FamilyName")
        hdfOrganizationName.Value = Session("Organization")

    End Sub


#End Region

#Region "Amend Test Results Method"

    Public Function Amend() As TestAmendmentParameters

        Try
            Dim amendment = New TestAmendmentParameters With {
                .AmendedByOrganizationID = hdfOrganizationID.Value,
                .AmendedByPersonID = hdfPersonID.Value,
                .AmendmentDate = Date.Now,
                .ChangedTestResultTypeID = ddlChangedTestResultTypeID.SelectedValue,
                .OldTestResultTypeID = hdfOriginalTestResultTypeID.Value,
                .ReasonForAmendment = txtReasonForAmendment.Text,
                .RowAction = RecordConstants.Insert,
                .RowStatus = RecordConstants.ActiveRowStatus,
                .TestAmendmentID = hdfIdentity.Value * -1,
                .TestID = hdfTestID.Value
            }

            TestResultTypeName = ddlChangedTestResultTypeID.SelectedItem.Text

            Return amendment
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return Nothing

    End Function

#End Region

End Class