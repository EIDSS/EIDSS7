Imports System.ComponentModel
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' 
''' Use Case: LUC08 - Create a Batch
''' 
''' The objective of the Create a Batch Use Case Specification is to define the functional 
''' requirements for user to create a batched test in the laboratory module in EIDSS. The 
''' functional requirements, or functionality that must be provided to users, are described in 
''' terms of use cases.
''' 
''' The Create a Batch Use Case Specification defines the functional requirements to give the user 
''' the ability to create a test batch in the Laboratory Module of EIDSS.
''' 
''' Use Case: LUC09 - Edit a Batch
''' 
''' The objective of the Edit a Batch Use Case Specification is to define the functional 
''' requirements for user to add results to, modify details, and/or close a batch in the laboratory 
''' module in EIDSS. The functional requirements, or functionality that must be provided to users, 
''' are described in terms of use cases.
''' 
''' The Edit a Batch Use Case Specification defines the functional requirements to give the user 
''' the ability to add results and details to or close a batch in the Laboratory Module of EIDSS.
''' 
''' TODO's:
''' 
''' If batching is not performed in user’s organization then the Batching tab shall be hidden.
''' 
''' If “Allow dates in the Past in the Laboratory Module” is checked in System Preferences (see 
''' SAUC52 System Preferences), user shall be able to edit the date/time. No future dates allowed.
''' </summary>
Public Class AddUpdateBatchUserControl
    Inherits UserControl

#Region "Global Values"

    Private Const SESSION_BATCH_TEST As String = "ucAddUpdateBatch_BatchTest"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private EmployeeAPIService As EmployeeServiceClient
    Private LaboratoryAPIService As LaboratoryServiceClient
    Private FlexibleFormAppService As FlexibleFormServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(AddUpdateBatchUserControl))

    Public Event ShowSearchEmployeeModal()
    Public Event ShowCreateEmployeeModal()
    Public Event ShowErrorModal(messageType As MessageType, message As String)

    <Category("ValidationGroup"), Description("Specify the validation group for the control.")>
    Public Property ValidationGroup As String

    Public Property BatchTest As LabBatchGetListModel

        Get
            Return CType(Session(SESSION_BATCH_TEST), LabBatchGetListModel)
        End Get
        Set(ByVal value As LabBatchGetListModel)
            Session(SESSION_BATCH_TEST) = value
        End Set

    End Property

    <PersistenceMode(PersistenceMode.Attribute)>
    Public Property DiagnosisID As Long
        Get
            If hdfDiagnosisID.Value Is Nothing OrElse hdfObservationID.Value = "null" Then
                Return Nothing
            Else
                Return Long.Parse(hdfDiagnosisID.Value)
            End If
        End Get
        Set(value As Long)
            hdfDiagnosisID.Value = value
        End Set
    End Property

    <PersistenceMode(PersistenceMode.Attribute)>
    Public Property ObservationID As Long
        Get
            If hdfObservationID.Value Is Nothing OrElse hdfObservationID.Value = "null" Then
                Return Nothing
            Else
                Return Long.Parse(hdfObservationID.Value)
            End If
        End Get
        Set(value As Long)
            hdfObservationID.Value = value
        End Set
    End Property

    <PersistenceMode(PersistenceMode.Attribute)>
    Public Property FormTemplateID As Long
        Get
            If hdfFormTemplateID.Value Is Nothing Then
                Return Nothing
            Else
                Return Long.Parse(hdfFormTemplateID.Value)
            End If
        End Get
        Set(value As Long)
            hdfFormTemplateID.Value = value
        End Set
    End Property

    ''' <summary>
    ''' This is passed by the user to GetFlexFormTemplate method. 
    ''' If nothing, then Nothing is passed. 
    ''' </summary>
    ''' <returns></returns>
    <PersistenceMode(PersistenceMode.Attribute)>
    Public Property CountryID As Long
        Get
            If hdfCountryID.Value Is Nothing Then
                Return Nothing
            Else
                Return Long.Parse(hdfCountryID.Value)
            End If
        End Get
        Set(value As Long)
            hdfCountryID.Value = value
        End Set
    End Property

    <PersistenceMode(PersistenceMode.Attribute)>
    Public Property FormType As Long
        Get
            If hdfFormTypeID.Value Is Nothing Then
                Return Nothing
            Else
                Return Long.Parse(hdfFormTypeID.Value)
            End If
        End Get
        Set(value As Long)
            hdfFormTypeID.Value = value.ToString()
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
                rfvTestedByPersonID.ValidationGroup = ValidationGroup
                cvResultDate.ValueToCompare = Date.Now.ToShortDateString()
                cvResultDate.ValidationGroup = ValidationGroup
            Else
                If Not HttpContext.Current.Session("AddUpdateBatchTable") Is Nothing Then
                    Dim tbl As Table = HttpContext.Current.Session("AddUpdateBatchTable")
                    pnlLUC08.Controls.Add(tbl)
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
    ''' <param name="personID"></param>
    ''' <param name="personName"></param>
    Public Sub SetTestedByPerson(personID As String, personName As String)

        If personID.IsValueNullOrEmpty = False Then
            ddlTestedByPersonID.SelectedValue = personID
        End If

        upAddUpdateBatch.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        divEIDSSBatchID.Visible = False
        txtBatchTestTestNameTypeName.Text = String.Empty
        txtTestStartedDate.Text = Date.Now.ToShortDateString()
        ddlTestedByPersonID.SelectedIndex = -1
        txtEIDSSBatchTestID.Text = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="batchesPendingSaveCount"></param>
    Public Sub Setup(Optional batchesPendingSaveCount As Integer = Nothing)

        upAddUpdateBatch.Update()

        Reset()

        GetUserProfile()

        hdfIdentity.Value = batchesPendingSaveCount

        FillControls()

        If BatchTest.BatchTestID > 0 Then
            divEIDSSBatchID.Visible = True
            divTestResult.Visible = True
            FillBatchTest()
        Else
            divEIDSSBatchID.Visible = False
            divTestResult.Visible = False
            FillBatchTest()
        End If

    End Sub

    Private Sub FillBatchTest()

        Scatter(Me, BatchTest)

        'TODO: Kishore
        'BatchTest.ObservationID
        'BatchTest.TestNameTypeID
        If Not BatchTest.BatchTestTestNameTypeID Is Nothing Then
            'If BatchTest.ObservationID = 0 Then
            '    Saveobservation()
            'End If
            LoadFlexForm(BatchTest.ObservationID, BatchTest.BatchTestTestNameTypeID)
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

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillControls()

        If EmployeeAPIService Is Nothing Then
            EmployeeAPIService = New EmployeeServiceClient()
        End If
        Dim parameters = New AdminEmployeeGetListParams()
        parameters.LanguageID = GetCurrentLanguage()
        parameters.OrganizationID = hdfOrganizationID.Value

        Dim list As List(Of AdminEmployeeGetlistModel) = EmployeeAPIService.GetEmployees(parameters).Result.OrderBy(Function(x) x.EmployeeFullName).ToList()
        FillDropDownList(ddlTestedByPersonID, list, {GlobalConstants.NullValue}, EmployeeConstants.EmployeeID, EmployeeConstants.FullName, Nothing, Nothing, True)

    End Sub

#End Region

#Region "Employee Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LookupEmployee_Click(sender As Object, e As EventArgs) Handles btnLookupEmployee.Click

        Try
            RaiseEvent ShowSearchEmployeeModal()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CreateEmployee_Click(sender As Object, e As EventArgs) Handles btnCreateEmployee.Click

        Try
            RaiseEvent ShowCreateEmployeeModal()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Public Function GetTestedByPersonID() As Long

        If ddlTestedByPersonID.SelectedValue = String.Empty Then
            Return Nothing
        Else
            Return ddlTestedByPersonID.SelectedValue
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Public Function GetTestedByPersonName() As String

        If ddlTestedByPersonID.SelectedValue = String.Empty Then
            Return Nothing
        Else
            Return ddlTestedByPersonID.SelectedItem.Text
        End If

    End Function

#End Region

#Region "Save Batch Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="test"></param>
    ''' <returns></returns>
    Public Function SaveBatchTest(test As LabTestGetListModel) As LabBatchGetListModel

        Try
            If BatchTest.BatchTestID <= 0 Then
                Page.Validate("AddUpdateBatchTest")

                Dim identity As Integer = hdfIdentity.Value

                GetUserProfile()

                identity = identity + 1

                BatchTest.BatchTestID = (identity * -1)

                If test.FavoriteIndicator Is Nothing Then
                    BatchTest.FavoriteIndicator = 0
                Else
                    BatchTest.FavoriteIndicator = test.FavoriteIndicator
                End If

                test.BatchTestID = BatchTest.BatchTestID
                test.RowAction = RecordConstants.Update
            Else
                Page.Validate("AddUpdateBatchTest")
            End If

            'Flex Form Saving data and populate Observation ID if needed. 
            SaveActualData()

            With BatchTest
                .AccessionComment = test.AccessionComment
                .AccessionConditionOrSampleStatusTypeName = test.AccessionConditionOrSampleStatusTypeName
                .AccessionDate = test.AccessionDate
                .BatchTestPerformedByOrganizationID = hdfOrganizationID.Value
                .BatchTestPerformedByPersonID = If(String.IsNullOrEmpty(ddlTestedByPersonID.SelectedValue.ToString()), CType(Nothing, Long?), Long.Parse(ddlTestedByPersonID.SelectedValue))
                .BatchStatusTypeID = BatchTestStatusTypes.InProgress
                .ContactPersonName = Nothing
                .DiseaseID = test.DiseaseID
                .DiseaseName = test.DiseaseName
                .EIDSSLaboratorySampleID = test.EIDSSLaboratorySampleID
                .EIDSSReportSessionID = test.EIDSSReportSessionID
                .EIDSSBatchTestID = Nothing
                .EIDSSAnimalID = test.EIDSSAnimalID
                .ExternalTestIndicator = test.ExternalTestIndicator
                .FunctionalAreaName = test.FunctionalAreaName
                .NonLaboratoryTestIndicator = test.NonLaboratoryTestIndicator
                .Note = test.Note
                .ObservationID = ObservationID
                .PatientFarmOwnerName = test.PatientFarmOwnerName
                .PerformedByOrganizationID = hdfOrganizationID.Value
                .PerformedByPersonID = If(String.IsNullOrEmpty(ddlTestedByPersonID.SelectedValue.ToString()), CType(Nothing, Long?), Long.Parse(ddlTestedByPersonID.SelectedValue))
                .PerformedDate = txtTestStartedDate.Text
                .ReadOnlyIndicator = test.ReadOnlyIndicator
                .ReceivedDate = test.ReceivedDate
                .ResultDate = Nothing
                .ResultEnteredByOrganizationID = test.ResultEnteredByOrganizationID
                .ResultEnteredByPersonID = test.ResultEnteredByPersonID
                .RowStatus = RecordConstants.ActiveRowStatus
                .RowSelectionIndicator = 0
                .RowAction = RecordConstants.Insert
                .SampleID = test.SampleID
                .SampleStatusTypeID = test.SampleStatusTypeID
                .SampleTypeName = test.SampleTypeName
                .SiteID = hdfSiteID.Value
                .StartedDate = txtTestStartedDate.Text
                .TestCategoryTypeID = test.TestCategoryTypeID
                .TestCategoryTypeName = test.TestCategoryTypeName
                .TestedByOrganizationID = test.TestedByOrganizationID
                .TestedByPersonID = test.TestedByPersonID
                .TestID = test.TestID
                .TestNameTypeID = test.TestNameTypeID
                .TestNameTypeName = test.TestNameTypeName
                .TestNumber = test.TestNumber
                .TestResultTypeID = test.TestResultTypeID
                .TestResultTypeName = test.TestResultTypeName
                .TestStatusTypeID = test.TestStatusTypeID
                .TestStatusTypeName = test.TestStatusTypeName
                .ValidatedByOrganizationID = test.ValidatedByOrganizationID
                .ValidatedByPersonID = test.ValidatedByPersonID
            End With

            HttpContext.Current.Session("AddUpdateBatchTable") = Nothing

            Return BatchTest
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            HttpContext.Current.Session("AddUpdateBatchTable") = Nothing
            Throw
        End Try

        Return Nothing

    End Function

#End Region

#Region "FlexForm - pnlLUC08"

    Private Sub ObservationSetup(idfsFormTemplate As Long)
        If FlexibleFormAppService Is Nothing Then
            FlexibleFormAppService = New FlexibleFormServiceClient()
        End If


        Dim gblObservationSetParams As New GblObservationSetParams With {
            .idfObservation = Nothing,
            .idfsFormTemplate = idfsFormTemplate,
            .idfsSite = 1,
            .intRowStatus = 0
            }

        Dim setObservationId As List(Of GblObservationSetModel) = FlexibleFormAppService.SET_FF_GBLOBSERVATION(gblObservationSetParams).Result

        BatchTest.ObservationID = CLng(setObservationId.FirstOrDefault().idfObservation)
        hdfObservationID.Value = setObservationId.FirstOrDefault().idfObservation.ToString()
        'ObservationID = CLng(setObservationId.FirstOrDefault().idfObservation)

        'Dim list As List(Of AdminFfObservationsGetModel) = FlexibleFormService.GET_FF_Observation(GenrateObservationId.ToString()).Result

    End Sub
    Public Sub LoadFlexForm(lObservationID As Long, lDiagnosisID As Long)

        ObservationID = lObservationID
        DiagnosisID = lDiagnosisID

        If Not hdfDiagnosisID.Value = "null" Then

            If FlexibleFormAppService Is Nothing Then
                FlexibleFormAppService = New FlexibleFormServiceClient()
            End If

            ''Retrieve the actual template and load that into the DIV tag (running at server). 
            ''Long.Parse(GetCurrentCountry()) - What is the value to be it to be long ? 
            Dim list As List(Of AdminFfActualTemplateGetModel)

            If hdfCountryID.Value = "null" Then
                list = FlexibleFormAppService.GET_FF_ActualTemplate(Nothing, Long.Parse(hdfDiagnosisID.Value), Long.Parse(hdfFormTypeID.Value), True).Result
            Else
                list = FlexibleFormAppService.GET_FF_ActualTemplate(CountryID, Long.Parse(hdfDiagnosisID.Value), Long.Parse(hdfFormTypeID.Value), True).Result
            End If

            If list.Count > 0 Then
                'This is where the formTemplateID setup happens. 
                hdfFormTemplateID.Value = list.Item(0).idfsFormTemplate
                LoadFlexFormTemplate(list.Item(0).idfsFormTemplate)
            End If

            If Not ObservationID = 0 Then
                LoadActualData()
            End If
        End If
    End Sub

    ''' <summary>
    ''' </summary>
    ''' <param name="formTemplate"></param>
    ''' <param name="cleanUp">
    '''  If the cleanUp tag is specified, then it means the Clear button is pressed or loading the form for the first time so empty out any web controls. 
    ''' </param>
    Private Sub LoadFlexFormTemplate(formTemplate As Long, Optional cleanUp As Boolean = False)

        If FlexibleFormAppService Is Nothing Then
            FlexibleFormAppService = New FlexibleFormServiceClient()
        End If

        'Retrieve the actual template and load that into the DIV tag (running at server). 
        Dim list As List(Of AdminFfParameterTemplateGetModel) = FlexibleFormAppService.GET_FF_ParameterTemplates(Nothing, formTemplate, GetCurrentLanguage()).Result
        HttpContext.Current.Session("AddUpdateBatchTable") = Nothing
        Dim tbl As New Table With {
                .ID = "tblHumanCaseClassification",
                .Width = New Unit("100%"),
                .CellSpacing = 3,
                .CellPadding = 2
            }

        'Iterate through the data elements to add them to the display DIV tag's inner html
        For Each ParameterTemplateRecord As AdminFfParameterTemplateGetModel In list

            ''Parameter Type will be parsed to get the list of different objects we need to rely on. 
            'Dim FFReferenceTypes As List(Of FfGetReferenceTypesModel) = CrossCuttingAppService.GetFlexibleFormsReferenceTypesAsync(GetCurrentLanguage()).Result
            If Not ParameterTemplateRecord.idfsSection Is Nothing Then

                'Need a border and Section Name around the field. 
                ParseSection(ParameterTemplateRecord)
                Dim tblSectionRetrieved As Table = CType(pnlLUC08.FindControl("tblSection" + ParameterTemplateRecord.idfsSection.ToString()), Table)
                If Not tblSectionRetrieved Is Nothing Then
                    tblSectionRetrieved.Rows.Add(CreateRow(ParameterTemplateRecord))
                End If
            Else
                tbl.Rows.Add(CreateRow(ParameterTemplateRecord))
            End If
        Next

        'Creates the last row with 2 buttons within the form.
        'tbl.Rows.Add(CreateFinalRow())
        HttpContext.Current.Session("AddUpdateBatchTable") = tbl
        pnlLUC08.Controls.Add(tbl)

    End Sub

    Private Shared Function ExtractParameterID(ByVal value As String) As Long
        Dim returnVal As String = String.Empty
        Dim collection As MatchCollection = Regex.Matches(value, "\d+")
        For Each m As Match In collection
            returnVal += m.ToString()
        Next
        Return Long.Parse(returnVal)
    End Function

    Private Sub UpdateRow(item As AdminFfParameterTemplateGetModel, row As TableRow)
        'Here we want to iterate through all the controls in the Panel 
        ' and load all the AJAX control extenders on top of the registered controls on the server. 
        ' it was failing initially as - the original control is not registered 
        ' so we had to create teh UpdateRow seperated which will be called after the CreateRow

        'This is good place to add the - Rules / Actions and Required field Validator 
        'Numeric Validator and other Validators. 

        'row.Cells(1).Controls always is the hardcoded value as the all the UI controls are loaded in Cells(1)

        'Load all the Rules here for the Template and iterate through. 
        'If FlexibleFormAppService Is Nothing Then
        '    FlexibleFormAppService = New FlexibleFormServiceClient()
        'End If

        'Dim list As List(Of AdminFfRulesGetModel) = FlexibleFormAppService.GET_FF_Rules(GetCurrentLanguage(), item.idfsFormTemplate).Result

        ''Iterate through the data elements to add them to the display DIV tag's inner html
        'For Each RuleRecord As AdminFfRulesGetModel In list
        '    'Dim tblSectionRetrieved As Table = CType(pnlLUC08.FindControl("tblSection" + RuleRecord.idfsSection.ToString()), Table)
        '    'If Not tblSectionRetrieved Is Nothing Then
        '    '    'tblSectionRetrieved.Rows.Add(CreateRow(ParameterTemplateRecord))
        '    'End If
        'Next

        'Load any events on these dropdowns or check boxes to raise any events. 
        For Each control As Control In row.Cells(1).Controls
            Select Case control.ID
                Case "txtNumberNatural" + item.idfsParameter.ToString()

                Case "txtString" + item.idfsParameter.ToString()
                    'This must be loaded when rules request them. 
                    Dim txtRequiredFieldValidator As New RequiredFieldValidator With {
                        .ID = "txtreq" + item.idfsParameter.ToString(),
                        .ControlToValidate = "txtString" + item.idfsParameter.ToString(),
                        .Display = ValidatorDisplay.Dynamic,
                        .ErrorMessage = "** Required"
                    }
                    'Commented this out for now. 
                    'row.Cells(1).Controls.Add(txtRequiredFieldValidator)
                    Exit For

                Case "txtNumberPositive" + item.idfsParameter.ToString()
                Case "txtDate" + item.idfsParameter.ToString()
                    Dim txtAjaxDate As New AjaxControlToolkit.CalendarExtender With {
                        .ID = "txtAjaxDate" + item.idfsParameter.ToString(),
                        .TargetControlID = "txtDate" + item.idfsParameter.ToString(),
                        .PopupPosition = AjaxControlToolkit.CalendarPosition.BottomRight
                    }
                    'Commented out as this is loading properly. 
                    'row.Cells(1).Controls.Add(txtAjaxDate)
                    Exit For

                Case "ddlYNU" + item.idfsParameter.ToString()

                Case "chk" + item.idfsParameter.ToString()

            End Select
        Next

    End Sub

    Private Function CreateRow(item As AdminFfParameterTemplateGetModel, Optional cleanUp As Boolean = False) As TableRow

        If FlexibleFormAppService Is Nothing Then
            FlexibleFormAppService = New FlexibleFormServiceClient()
        End If

        Dim row As New TableRow
        row.Height = New Unit(50)
        Dim cell1 As New TableCell

        'Label cell will fill with the text needed. 
        cell1.Width = New Unit("40%")
        cell1.CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12"
        Dim childLabel As New Label
        childLabel.ID = "lbl" + item.idfsParameter.ToString()
        childLabel.Text = item.DefaultName
        cell1.Controls.Add(childLabel)
        cell1.HorizontalAlign = HorizontalAlign.Left
        row.Cells.Add(cell1)

        'Retrieve the actual template and load that into the DIV tag (running at server). 
        Dim ParameterList As List(Of AdminFfParametersGetModel) = FlexibleFormAppService.GET_FF_Parameters(GetCurrentLanguage(), item.idfsSection, item.idfsFormType).Result

        Dim parameterType As String = String.Empty
        For Each parameterItem As AdminFfParametersGetModel In ParameterList
            If parameterItem.idfsParameter = item.idfsParameter Then
                parameterType = parameterItem.ParameterTypeName
                'Exit For
            End If
        Next

        Dim cell2 As New TableCell With {
            .Width = New Unit("60%"),
            .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12"
        }

        Select Case parameterType
            Case "Numeric Natural"

                Dim textNumber As New TextBox With {
                    .ID = "txtNumberNatural" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }

                If cleanUp Then
                    textNumber.Text = String.Empty
                End If

                cell2.Controls.Add(textNumber)

            Case "Y_N_Unk"

                Dim childDropDownList As New DropDownList With {
                    .ID = "ddlYNU" + item.idfsParameter.ToString(),
                    .Width = 250,
                    .CssClass = "form-control"
                }

                'Call the API to load the Dropdown list. 
                Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormAppService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                childDropDownList.DataSource = dropDownList
                childDropDownList.DataTextField = "strValueCaption"
                childDropDownList.DataValueField = "idfsValue"
                childDropDownList.DataBind()
                childDropDownList.Items.Insert(0, "")

                If cleanUp Then
                    childDropDownList.SelectedIndex = 0
                End If

                cell2.Controls.Add(childDropDownList)

            Case "Boolean"

                Dim chkBoxItem As New CheckBox With {
                    .ID = "chk" + item.idfsParameter.ToString(),
                    .CssClass = "form-control"
                }

                If cleanUp Then
                    chkBoxItem.Checked = False
                End If

                cell2.Controls.Add(chkBoxItem)

            Case "String"

                Dim textString As New TextBox With {
                    .ID = "txtString" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }

                If cleanUp Then
                    textString.Text = String.Empty
                End If

                cell2.Controls.Add(textString)

            Case "Numeric Positive"

                Dim textNumber As New TextBox With {
                    .ID = "txtNumberPositive" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }

                If cleanUp Then
                    textNumber.Text = String.Empty
                End If

                cell2.Controls.Add(textNumber)

            Case "Date"

                Dim textDate As New EIDSSControlLibrary.CalendarInput With {
                        .ID = "txtDate" + item.idfsParameter.ToString(),
                        .ContainerCssClass = "input-group datepicker",
                        .CssClass = "form-control"
                    }
                '<eidss:CalendarInput ContainerCssClass = "input-group datepicker" ID="txtdatNotificationDate" runat="server" CssClass="form-control"></eidss: CalendarInput>
                If cleanUp Then
                    textDate.Text = String.Empty
                End If

                cell2.Controls.Add(textDate)

            Case Else
                Dim childDropDownList As New DropDownList With {
                    .ID = "ddlParam" + item.idfsParameter.ToString(),
                    .Width = 250,
                    .CssClass = "form-control"
                }

                '' Here is where we link the dropdowns with the Parameter FIxed pre-set / Reference type values. 
                'Call the API to load the Dropdown list. 
                Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormAppService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                childDropDownList.DataSource = dropDownList
                childDropDownList.DataTextField = "strValueCaption"
                childDropDownList.DataValueField = "idfsValue"
                childDropDownList.DataBind()
                childDropDownList.Items.Insert(0, "")

                If cleanUp Then
                    childDropDownList.SelectedIndex = 0
                End If

                cell2.Controls.Add(childDropDownList)
        End Select
        row.Cells.Add(cell2)
        UpdateRow(item, row)
        Return row
    End Function

    Private Sub ParseSection(item As AdminFfParameterTemplateGetModel)

        Dim sectionCollection As List(Of AdminFfParentSectionsGetModel) = FlexibleFormAppService.GET_FF_ParentSections(GetCurrentLanguage(), item.idfsSection).Result

        'Iterate through the data elements to add them to the display DIV tag's inner html
        Dim iterationCount As Integer = 0
        Dim verifTable As String = Nothing
        For Each sectionRecord As AdminFfParentSectionsGetModel In sectionCollection
            'Now we are within each iteration row record.
            'First record should always be inserted if not already preset on the page. 
            If iterationCount = 0 Then
                ' We are at the first record, so store the Verif table ID for the subsequent inserts for the sections. 
                'Changing iterationCount to 1 so it doesn't go into the loop anymore. 
                iterationCount = 1
                If ValidateSection(sectionRecord.SectionID) Then
                    InsertSection(sectionRecord.SectionID, sectionRecord.SectionName)
                End If
                verifTable = "tblSection" + sectionRecord.SectionID.ToString()
            Else
                'The main section exists already, Now need to insert the child sections. 
                If ValidateSection(sectionRecord.SectionID) Then
                    InsertSection(sectionRecord.SectionID, sectionRecord.SectionName, verifTable)
                End If
                verifTable = "tblSection" + sectionRecord.SectionID.ToString()
            End If
        Next

    End Sub

    Private Function ValidateSection(sectionID As Long) As Boolean
        Dim convertedTable As Table = CType(pnlLUC08.FindControl("tblSection" + sectionID.ToString()), Table)
        If convertedTable Is Nothing Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub InsertSection(sectionID As Long, sectionName As String, Optional verifTableID As String = Nothing)
        ' No Table was found, so create a new one. 
        ' And add a header row. 
        Dim tblSection As New Table With {
            .ID = "tblSection" + sectionID.ToString(),
            .Height = New Unit("100%"),
            .BorderWidth = New Unit(1),
            .BorderStyle = BorderStyle.None,
            .BackColor = Drawing.Color.White,
            .CellSpacing = 3,
            .CellPadding = 2
        }

        If verifTableID Is Nothing Then
            tblSection.Width = New Unit("100%")
        Else
            tblSection.Width = New Unit("96%")
            tblSection.HorizontalAlign = HorizontalAlign.Right
        End If

        Dim headerRow As New TableRow With {
            .Height = New Unit(30),
            .BorderStyle = BorderStyle.None,
            .BackColor = Drawing.Color.White
        }

        'Label cell will fill with the text needed. 
        Dim headerCell As New TableCell With {
            .ColumnSpan = 2,
            .Width = New Unit("100%"),
            .HorizontalAlign = HorizontalAlign.Left,
            .CssClass = "flex-form-header"
        }

        Dim headerLabel As New Label With {
            .ID = "lblHeader" + sectionID.ToString(),
            .Text = sectionName
        }

        headerCell.Controls.Add(headerLabel)
        headerRow.Cells.Add(headerCell)
        tblSection.Rows.Add(headerRow)

        Dim pnlSection As New Panel With {
            .ID = "pnlSection" + sectionID.ToString(),
            .BorderStyle = BorderStyle.None,
            .BackColor = Drawing.Color.White,
            .Width = New Unit("100%"),
            .HorizontalAlign = HorizontalAlign.Center
        }

        pnlSection.Controls.Add(tblSection)

        'Only enter inside if the verifTableID is not nothing. If nothing, don't bother and insert to the PanelCaseClassification 
        If Not verifTableID Is Nothing Then
            Dim verifTable As Table = CType(pnlLUC08.FindControl(verifTableID), Table)
            If Not verifTable Is Nothing Then
                Dim row As New TableRow
                row.Height = New Unit(50)
                Dim cell1 As New TableCell

                'Label cell will fill with the text needed. 
                cell1.Width = New Unit("100%")
                cell1.ColumnSpan = 2
                cell1.Controls.Add(pnlSection)
                row.Cells.Add(cell1)
                verifTable.Rows.Add(row)
            End If
        Else
            pnlLUC08.Controls.Add(pnlSection)
        End If

    End Sub

    Private Sub LoadActualData()

        Dim cls As New clsCommon
        Dim allCtrl As New List(Of Control)
        allCtrl.Clear()

        If FlexibleFormAppService Is Nothing Then
            FlexibleFormAppService = New FlexibleFormServiceClient()
        End If

        Dim listGet As List(Of AdminFfActivityParametersGetModel) = FlexibleFormAppService.GET_FF_ActivityParameters(Convert.ToString(ObservationID), GetCurrentLanguage()).Result

        For Each activityParameter As AdminFfActivityParametersGetModel In listGet
            For Each txt As TextBox In cls.FindCtrl(allCtrl, pnlLUC08, GetType(TextBox))

                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(txt.ID.ToString())
                Dim DataTypeAndID As String = txt.ID.Remove(txt.ID.IndexOf("txt"), "txt".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

                If activityParameter.idfsParameter = idfsParameterRetreived Then
                    txt.Text = activityParameter.varValue
                    Exit For
                End If
            Next

            allCtrl.Clear()
            'Iterate through all DropdownLists. 
            For Each ddl As DropDownList In cls.FindCtrl(allCtrl, pnlLUC08, GetType(DropDownList))
                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(ddl.ID.ToString())
                Dim DataTypeAndID As String = ddl.ID.Remove(ddl.ID.IndexOf("ddl"), "ddl".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

                If activityParameter.idfsParameter = idfsParameterRetreived Then
                    ddl.SelectedValue = activityParameter.varValue
                    Exit For
                End If
            Next

            allCtrl.Clear()
            'Iterate through all Date controls. 
            For Each txtDT As EIDSSControlLibrary.CalendarInput In cls.FindCtrl(allCtrl, pnlLUC08, GetType(EIDSSControlLibrary.CalendarInput))
                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(txtDT.ID.ToString())
                Dim DataTypeAndID As String = txtDT.ID.Remove(txtDT.ID.IndexOf("txt"), "txt".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

                If activityParameter.idfsParameter = idfsParameterRetreived Then
                    txtDT.Text = activityParameter.varValue
                    Exit For
                End If
            Next

            allCtrl.Clear()
            'Iterate through all check Boxes. 
            For Each chk As CheckBox In cls.FindCtrl(allCtrl, pnlLUC08, GetType(CheckBox))
                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(chk.ID.ToString())
                Dim DataTypeAndID As String = chk.ID.Remove(chk.ID.IndexOf("chk"), "chk".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

                If activityParameter.idfsParameter = idfsParameterRetreived Then
                    chk.Checked = Boolean.Parse(activityParameter.varValue)
                    Exit For
                End If
            Next
        Next
    End Sub

    Public Sub SaveActualData()

        If ObservationID = 0 Then
            ObservationSetup(CType(hdfFormTemplateID.Value, Long))
        End If
        ' Handle your Button clicks here
        Dim allCtrl As New List(Of Control)

        allCtrl.Clear()
        Dim cls As New clsCommon
        'Iterate through all text boxes. 
        For Each txt As TextBox In cls.FindCtrl(allCtrl, pnlLUC08, GetType(TextBox))

            'ParseParameter
            Dim idfsParameterRetreived As Long = ExtractParameterID(txt.ID.ToString())
            Dim DataTypeAndID As String = txt.ID.Remove(txt.ID.IndexOf("txt"), "txt".Length)
            Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

            Dim ActivityParamValue As String

            'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
            'If txt.Text <> "" Then
            ActivityParamValue = txt.Text
            If FlexibleFormAppService Is Nothing Then
                FlexibleFormAppService = New FlexibleFormServiceClient()
            End If

            Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                .idfsParameter = idfsParameterRetreived,
                .idfObservation = ObservationID,
                .idfsFormTemplate = FormTemplateID,
                .varValue = ActivityParamValue,
                .isDynamicParameter = False,
                .idfRow = 0,
                .idfActivityParameters = Nothing
                }

            Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(parameters).Result
        Next

        allCtrl.Clear()
        'Iterate through all check Boxes. 
        For Each chk As CheckBox In cls.FindCtrl(allCtrl, pnlLUC08, GetType(CheckBox))

            'ParseParameter
            Dim idfsParameterRetreived As Long = ExtractParameterID(chk.ID.ToString())
            Dim DataTypeAndID As String = chk.ID.Remove(chk.ID.IndexOf("chk"), "chk".Length)
            Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

            Dim ActivityParamValue As Boolean

            'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
            'If txt.Text <> "" Then
            ActivityParamValue = chk.Checked
            If FlexibleFormAppService Is Nothing Then
                FlexibleFormAppService = New FlexibleFormServiceClient()
            End If

            Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                .idfsParameter = idfsParameterRetreived,
                .idfObservation = ObservationID,
                .idfsFormTemplate = FormTemplateID,
                .varValue = Convert.ToString(ActivityParamValue),
                .isDynamicParameter = False,
                .idfRow = 0,
                .idfActivityParameters = Nothing
                }

            Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(parameters).Result
            'Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(idfsParameterRetreived, ObservationID, FormTemplateID, Convert.ToString(ActivityParamValue), False, Nothing, Nothing).Result

        Next

        allCtrl.Clear()
        'Iterate through all DropdownLists. 
        For Each ddl As DropDownList In cls.FindCtrl(allCtrl, pnlLUC08, GetType(DropDownList))

            'ParseParameter
            Dim idfsParameterRetreived As Long = ExtractParameterID(ddl.ID.ToString())
            Dim DataTypeAndID As String = ddl.ID.Remove(ddl.ID.IndexOf("ddl"), "ddl".Length)
            Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

            Dim ActivityParamValue As String
            'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
            ActivityParamValue = ddl.SelectedValue.ToString()
            If FlexibleFormAppService Is Nothing Then
                FlexibleFormAppService = New FlexibleFormServiceClient()
            End If

            Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                .idfsParameter = idfsParameterRetreived,
                .idfObservation = ObservationID,
                .idfsFormTemplate = FormTemplateID,
                .varValue = Convert.ToString(ActivityParamValue),
                .isDynamicParameter = False,
                .idfRow = 0,
                .idfActivityParameters = Nothing
                }

            Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(parameters).Result
            'Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(idfsParameterRetreived, ObservationID, FormTemplateID, ActivityParamValue, False, Nothing, Nothing).Result
        Next

        allCtrl.Clear()
        'Iterate through all Date controls. 
        For Each txtDT As EIDSSControlLibrary.CalendarInput In cls.FindCtrl(allCtrl, pnlLUC08, GetType(EIDSSControlLibrary.CalendarInput))

            'ParseParameter
            Dim idfsParameterRetreived As Long = ExtractParameterID(txtDT.ID.ToString())
            Dim DataTypeAndID As String = txtDT.ID.Remove(txtDT.ID.IndexOf("txt"), "txt".Length)
            Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

            Dim ActivityParamValue As String
            'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
            ActivityParamValue = txtDT.Text
            If FlexibleFormAppService Is Nothing Then
                FlexibleFormAppService = New FlexibleFormServiceClient()
            End If

            Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                .idfsParameter = idfsParameterRetreived,
                .idfObservation = ObservationID,
                .idfsFormTemplate = FormTemplateID,
                .varValue = Convert.ToString(ActivityParamValue),
                .isDynamicParameter = False,
                .idfRow = 0,
                .idfActivityParameters = Nothing
                }

            Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(parameters).Result
            'Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(idfsParameterRetreived, ObservationID, FormTemplateID, ActivityParamValue, False, Nothing, Nothing).Result
        Next



    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="value"></param>
    Public Sub EnableControls(value As Boolean)

        Dim allCtrl As New List(Of Control)
        allCtrl.Clear()
        'Iterate through all DropdownLists. 
        For Each ddl As DropDownList In FindControlList(allCtrl, pnlLUC08, GetType(DropDownList))
            ddl.Enabled = value
        Next
        allCtrl.Clear()
        'Iterate through all Date controls. 
        For Each txtDT As EIDSSControlLibrary.CalendarInput In FindControlList(allCtrl, pnlLUC08, GetType(EIDSSControlLibrary.CalendarInput))
            txtDT.Enabled = value
        Next

        allCtrl.Clear()
        'Iterate through all check Boxes. 
        For Each chk As CheckBox In FindControlList(allCtrl, pnlLUC08, GetType(CheckBox))
            chk.Enabled = value
        Next

        allCtrl.Clear()
        'Iterate through all text boxes. 
        For Each txt As TextBox In FindControlList(allCtrl, pnlLUC08, GetType(TextBox))
            txt.Enabled = value
        Next

    End Sub
#End Region

End Class