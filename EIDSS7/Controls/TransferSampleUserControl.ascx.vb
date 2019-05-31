Imports System.ComponentModel
Imports System.Globalization
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain

''' <summary>
''' 
''' Use Case: LUC03 - Transfer a Sample
''' 
''' The objective of the Transfer a Sample Use Case Specification is to define the functional requirements for a user 
''' to transfer a sample to another EIDSS lab or to an external lab. The functional requirements, or functionality that 
''' must be provided to users, are described in terms of use cases.
''' 
''' The Transfer a Sample Use Case Specification defines the functional requirements to give the user the ability to 
''' track a transferred sample in the Laboratory Module of EIDSS.
''' 
''' </summary>
Public Class TransferSampleUserControl
    Inherits UserControl

#Region "Global Values"

    Private Const SESSION_TRANSFER As String = "ucTransferSample_Sample"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(TransferSampleUserControl))

    Public Event ShowSearchOrganizationModal()
    Public Event ShowCreateOrganizationModal()
    Public Event ShowErrorModal(messageType As MessageType, message As String)

    <Category("ValidationGroup"), Description("Specify the validation group for the control.")>
    Public Property ValidationGroup As String

    Public Property Transfer As LabTransferGetListModel

        Get
            Return CType(Session(SESSION_TRANSFER), LabTransferGetListModel)
        End Get
        Set(ByVal value As LabTransferGetListModel)
            Session(SESSION_TRANSFER) = value
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
            If Not IsPostBack Then
                rfvTransferDate.ValidationGroup = ValidationGroup
                rfvTransferredToOrganization.ValidationGroup = ValidationGroup
                rfvTestRequested.ValidationGroup = ValidationGroup
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="organizationID"></param>
    ''' <param name="organizationName"></param>
    Public Sub SetTransferToOrganization(organizationID As String, organizationName As String)

        If organizationID.IsValueNullOrEmpty = False Then
            ddlTransferredToOrganizationID.SelectedValue = organizationID
        End If

        upTransferSample.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        divEIDSSTransferID.Visible = False
        txtTestRequested.Text = String.Empty
        txtTransferDate.Text = Date.Now.ToShortDateString()
        ddlTransferredToOrganizationID.SelectedIndex = -1
        txtPurposeOfTransfer.Text = String.Empty
        txtSentByPersonName.Text = String.Empty
        txtEIDSSTransferID.Text = String.Empty
        txtTransferredFromOrganizationName.Text = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Setup()

        Reset()

        GetUserProfile()

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If
        Dim list As List(Of GblOrganizationByTypeGetListModel) = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Laboratory).Result
        FillDropDownList(ddlTransferredToOrganizationID, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)

        If Transfer.TransferID > 0 Then
            FillTransfer()
            divEIDSSTransferID.Visible = True
            hdfOldTransferredToOrganizationID.Value = Transfer.TransferredToOrganizationID
        Else
            divEIDSSTransferID.Visible = False
            txtTransferredFromOrganizationName.Text = hdfOrganizationName.Value
            txtSentByPersonName.Text = hdfFirstName.Value & " " & hdfLastName.Value
            txtTransferDate.Text = Date.Today
        End If

        upTransferSample.Update()

    End Sub

    Private Sub FillTransfer()

        Scatter(Me, Transfer)

        If Not Transfer.TransferDate Is Nothing Then
            Dim c As CultureInfo = New CultureInfo(GetCurrentLanguage(), False)
            Threading.Thread.CurrentThread.CurrentCulture = c
            txtTransferDate.Text = CType(Transfer.TransferDate, Date).ToString("d")
        End If

    End Sub

#End Region

#Region "Common Methods"

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

#Region "Organization Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="oldTransferredToOrganizationID"></param>
    ''' <returns></returns>
    Public Function GetTransferredToOrganizationID(Optional ByRef oldTransferredToOrganizationID As String = Nothing) As Long

        oldTransferredToOrganizationID = hdfOldTransferredToOrganizationID.Value

        If ddlTransferredToOrganizationID.SelectedValue = String.Empty Then
            Return Nothing
        Else
            Return ddlTransferredToOrganizationID.SelectedValue
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Public Function GetTransferredToOrganizationName() As String

        If ddlTransferredToOrganizationID.SelectedValue = String.Empty Then
            Return Nothing
        Else
            Return ddlTransferredToOrganizationID.SelectedItem.Text
        End If

    End Function

#End Region

#Region "Save Transfer Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <returns></returns>
    Public Function SaveTransfer(ByVal samples As List(Of LabSampleGetListModel)) As List(Of LabTransferGetListModel)

        Try
            If Transfer.TransferID <= 0 Then
                If samples.Count = 0 Then
                    RaiseEvent ShowErrorModal(messageType:=MessageType.CannotTransferOut, message:=String.Empty)
                Else
                    Page.Validate("TransferOut")

                    Dim transfers = New List(Of LabTransferGetListModel)()
                    Dim transfer As LabTransferGetListModel
                    Dim index As Integer = 0
                    Dim identity As Integer = 0

                    If hdfOrganizationID.Value.IsValueNullOrEmpty = True Then
                        GetUserProfile()
                    End If

                    For Each sample In samples
                        index = 0
                        identity = identity + 1

                        transfer = New LabTransferGetListModel With {
                            .AccessionComment = sample.AccessionComment,
                            .AccessionConditionOrSampleStatusTypeName = sample.AccessionConditionOrSampleStatusTypeName,
                            .AccessionDate = sample.AccessionDate,
                            .ContactPersonName = Nothing,
                            .DiseaseName = sample.DiseaseName,
                            .EIDSSLaboratorySampleID = sample.EIDSSLaboratorySampleID,
                            .EIDSSLocalFieldSampleID = sample.EIDSSLocalFieldSampleID,
                            .EIDSSReportSessionID = sample.EIDSSReportSessionID,
                            .EIDSSTransferID = Nothing,
                            .PurposeOfTransfer = txtPurposeOfTransfer.Text,
                            .ResultDate = Nothing,
                            .PatientFarmOwnerName = sample.PatientFarmOwnerName,
                            .TransferredOutSampleID = sample.SampleID,
                            .SampleStatusTypeID = sample.SampleStatusTypeID,
                            .SampleTypeName = sample.SampleTypeName,
                            .SentByPersonID = hdfPersonID.Value,
                            .TransferDate = txtTransferDate.Text,
                            .TransferredFromOrganizationID = hdfOrganizationID.Value,
                            .TransferredToOrganizationID = ddlTransferredToOrganizationID.SelectedValue,
                            .SiteID = hdfSiteID.Value,
                            .TestNameTypeName = Nothing,
                            .TestRequested = txtTestRequested.Text,
                            .TestResultTypeID = Nothing,
                            .TestResultTypeName = Nothing,
                            .TransferredToOrganizationName = ddlTransferredToOrganizationID.SelectedItem.Text,
                            .TransferStatusTypeID = TransferStatusTypes.InProgress,
                            .RowStatus = RecordConstants.ActiveRowStatus,
                            .RowSelectionIndicator = 0,
                            .RowAction = RecordConstants.Insert,
                            .TransferID = (identity * -1)
                        }

                        If sample.FavoriteIndicator Is Nothing Then
                            transfer.FavoriteIndicator = 0
                        Else
                            transfer.FavoriteIndicator = sample.FavoriteIndicator
                        End If

                        transfers.Add(transfer)

                        index += 1
                    Next

                    Return transfers
                End If
            Else
                Transfer.PurposeOfTransfer = txtPurposeOfTransfer.Text
                Transfer.TestRequested = txtTestRequested.Text
                Transfer.TransferredToOrganizationID = ddlTransferredToOrganizationID.SelectedValue
                Transfer.TransferredToOrganizationName = ddlTransferredToOrganizationID.SelectedItem.Text
                Transfer.TransferDate = If(String.IsNullOrEmpty(txtTransferDate.Text), CType(Nothing, Date?), Date.Parse(txtTransferDate.Text))
                Transfer.SentByPersonName = txtSentByPersonName.Text
                Transfer.SentByPersonID = hdfPersonID.Value
                Transfer.SiteID = hdfSiteID.Value

                If Transfer.TransferID > 0 Then
                    Transfer.RowAction = RecordConstants.Update
                Else
                    Transfer.RowAction = RecordConstants.Insert
                End If

                Return New List(Of LabTransferGetListModel)()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

        Return Nothing

    End Function

#End Region

End Class