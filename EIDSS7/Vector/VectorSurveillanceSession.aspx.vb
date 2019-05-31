Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class VectorSurveillanceSession
    Inherits BaseEidssPage

    Private userSettingsFile As String
    Private oCommon As clsCommon = New clsCommon()

    Private Const PAGE_KEY As String = "Page"
    Private Const PAGE_ERROR_SCRIPT As String = "showErrorModal();"
    Private Const PAGE_CANCEL_SCRIPT As String = "showCancelModal();"
    Private Const PAGE_DELETE_SCRIPT As String = "showDeleteModal();"
    Private Const PAGE_SUCCESS_SCRIPT As String = "showSuccessModal()"
    Private Const PAGE_DETAILED_COLLECTION_COPY_SCRIPT As String = "showDetailedCollectionCopyModal();"

    Dim ExceptionCtrlList As List(Of String)

    Private VectorAPIService As VectorServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchPersonUserControl))

#Region "ENUM"

    Private Structure VSS

        Public Const SearchResults As String = "gvVSSSearchResults"
        Public Const SearchResultsRecordCount As String = "gvVSSSearchResults_RecordCount"
        Public Const SearchResultsSortDirection As String = "gvVSSSearchResults_SortDirection"
        Public Const SearchResultsSortExpression As String = "gvVSSSearchResults_SortExpression"
        Public Const SearchResultsPaginationSet As String = "gvVSSSearchResults_PaginationSet"

        Public Const DetailedCollections As String = "gvDetailedCollections"
        Public Const DetailedCollectionsRecordCount As String = "gvDetailedCollections_RecordCount"
        Public Const DetailedCollectionsSortDirection As String = "gvDetailedCollections_SortDirection"
        Public Const DetailedCollectionsSortExpression As String = "gvDetailedCollections_SortExpression"
        Public Const DetailedCollectionsPaginationSet As String = "gvDetailedCollections_PaginationSet"

        Public Const AggregateCollections As String = "gvAggregateCollections"
        Public Const AggregateCollectionsRecordCount As String = "gvAggregateCollections_RecordCount"
        Public Const AggregateCollectionsSortDirection As String = "gvAggregateCollections_SortDirection"
        Public Const AggregateCollectionsSortExpression As String = "gvAggregateCollections_SortExpression"
        Public Const AggregateCollectionsPaginationSet As String = "gvAggregateCollections_PaginationSet"

        Public Const DetailedCollectionsSample As String = "gvDetailedCollectionsSample"
        Public Const DetailedCollectionsSampleRecordCount As String = "gvDetailedCollectionsSample_RecordCount"
        Public Const DetailedCollectionsSampleSortDirection As String = "gvDetailedCollectionsSample_SortDirection"
        Public Const DetailedCollectionsSampleSortExpression As String = "gvDetailedCollectionsSample_SortExpression"
        Public Const DetailedCollectionsSamplePaginationSet As String = "gvDetailedCollectionsSample_PaginationSet"

        Public Const DetailedCollectionsFieldTests As String = "gvDetailedCollectionsFieldTests"
        Public Const DetailedCollectionsFieldTestsRecordCount As String = "gvDetailedCollectionsFieldTests_RecordCount"
        Public Const DetailedCollectionsFieldTestsSortDirection As String = "gvDetailedCollectionsFieldTests_SortDirection"
        Public Const DetailedCollectionsFieldTestsSortExpression As String = "gvDetailedCollectionsFieldTests_SortExpression"
        Public Const DetailedCollectionsFieldTestsPaginationSet As String = "gvDetailedCollectionsFieldTests_PaginationSet"

        Public Const DetailedCollectionsLabTests As String = "gvDetailedCollectionsLabTests"
        Public Const DetailedCollectionsLabTestsRecordCount As String = "gvDetailedCollectionsLabTests_RecordCount"
        Public Const DetailedCollectionsLabTestsSortDirection As String = "gvDetailedCollectionsLabTests_SortDirection"
        Public Const DetailedCollectionsLabTestsSortExpression As String = "gvDetailedCollectionsLabTests_SortExpression"
        Public Const DetailedCollectionsLabTestsPaginationSet As String = "gvDetailedCollectionsLabTests_PaginationSet"

        Public Const AggregateCollectionsDiseases As String = "gvAggregateCollectionDiseases"
        Public Const AggregateCollectionsDiseasesRecordCount As String = "gvAggregateCollectionDiseases_RecordCount"
        Public Const AggregateCollectionsDiseasesSortDirection As String = "gvAggregateCollectionDiseases_SortDirection"
        Public Const AggregateCollectionsDiseasesSortExpression As String = "gvAggregateCollectionDiseases_SortExpression"
        Public Const AggregateCollectionsDiseasesPaginationSet As String = "gvAggregateCollectionDiseases_PaginationSet"

        Public Const VSSDetail As String = "VSSDetail"
        Public Const VSSDetailedCollectionDetail As String = "VSSDetailedCollectionDetail"
        Public Const VSSAggregateCollectionDetail As String = "VSSAggregateCollectionDetail"

        Public Const VSSSessionID As String = "VSSSessionID"
        Public Const VSSDetailCollectionID As String = "VSSDetailCollectionID"
        Public Const VSSAggregateCollectionID As String = "VSSAggregateCollectionID"
        Public Const VSSDetailCollectionSampleID As String = "VSSDetailCollectionSampleID"
        Public Const VSSDetailCollectionFieldTestsID As String = "VSSDetailCollectionFieldTestsID"
        Public Const VSSDetailCollectionLabTestsID As String = "VSSDetailCollectionLabTestsID"
        Public Const VSSAggregateCollectionDiseaseID As String = "VSSAggregateCollectionDiseaseID"

    End Structure

    'Basereference table values (idfsBaseRefernce) for "Vector Surveillance Session Status" for HACode: 128.
    Private Structure VSSStatus
        Public Const InProcessStatus As Long = 10310001
        Public Const ClosedStatus As Long = 10310002
    End Structure

    'Basereference table values (idfsBaseRefernce) for "Geo Location Type" for HACode: 128. 
    Public Structure VSSLocation

        Public Const National As Long = 10036005
        Public Const ExactPoint As Long = 10036003
        Public Const RelativePoint As Long = 10036004
        Public Const ForeignAddress As Long = 10036001

    End Structure

    Public Enum FormSection
        SelectOne = -1
        SearchForm = 0
        SearchResults = 1
        Vector = 2
        VectorSummary = 3
        VectorLocation = 4
        VectorDetailedCollection = 5
        VectorAggregateCollection = 6
        VectorDetailedCollectionDetail = 7
        VectorAggregateCollectionDetail = 8
    End Enum

    Public Enum FormSectionShowHide
        SelectOne = -1
        SearchTriangleBottom = 0
        SearchTriangleTop = 1
        VectorSummaryTriangleBottom = 2
        VectorSummaryTriangleTop = 3
        VectorLocationTriangleBottom = 4
        VectorLocationTriangleTop = 5
        VectorDetailedCollectionsTriangleBottom = 6
        VectorDetailedCollectionsTriangleTop = 7
        VectorAggregateCollectionTriangleBottom = 8
        VectorAggregateCollectionTriangleTop = 9
    End Enum

    Public Enum FormAction
        VSSSelect = 0
        VSSAddFromSearch = 1
        VSSAddFromSearchResults = 2
        VSSEdit = 3
        VSSDelete = 4
        VSSDetailedCollectionEdit = 5
        VSSDetailedCollectionDelete = 6
        VSSDetailedCollectionSampleEdit = 7
        VSSVSSDetailedCollectionSampleDelete = 8
        VSSVSSDetailedCollectionFieldTestsEdit = 9
        VSSVSSDetailedCollectionFieldTestsDelete = 10
        VSSVSSDetailedCollectionLabTestsEdit = 11
        VSSVSSDetailedCollectionLabTestsDelete = 12
        VSSAggregateCollectionEdit = 13
        VSSAggregateCollectionDelete = 14
        VSSAggregateCollectionDiseasesEdit = 15
        VSSAggregateCollectionDiseasesDelete = 16
    End Enum

    Public Enum ModalType
        Cancel = 0
        Delete = 1
        AppError = 2
    End Enum

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            ViewState("ExceptionCtrlList") = Nothing

            'Cancel search sends back to caller page
            ViewState("Caller") = Request.ServerVariables("HTTP_REFERER")

            BindToEnum(GetType(FormSection), ddlVSSFormSection)
            ddlVSSFormSection.SelectedValue = FormSection.SelectOne

            BindToEnum(GetType(FormSectionShowHide), ddlVSSFormSectionShowHide)
            ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne

            BindToEnum(GetType(FormAction), ddlVSSFormAction)
            ddlVSSFormAction.SelectedValue = FormAction.VSSSelect

            Session(VSS.SearchResults) = Nothing
            Session(VSS.DetailedCollections) = Nothing
            Session(VSS.AggregateCollections) = Nothing
            Session(VSS.DetailedCollectionsSample) = Nothing
            Session(VSS.DetailedCollectionsFieldTests) = Nothing
            Session(VSS.DetailedCollectionsLabTests) = Nothing
            Session(VSS.AggregateCollectionsDiseases) = Nothing

            ViewState(VSS.VSSSessionID) = -1
            ViewState(VSS.VSSDetailCollectionID) = -1
            ViewState(VSS.VSSDetailCollectionSampleID) = -1
            ViewState(VSS.VSSDetailCollectionFieldTestsID) = -1
            ViewState(VSS.VSSDetailCollectionLabTestsID) = -1
            ViewState(VSS.VSSAggregateCollectionID) = -1

            ViewState(VSS.SearchResultsSortDirection) = SortConstants.Ascending
            ViewState(VSS.SearchResultsSortExpression) = "EIDSSSessionID"
            ViewState(VSS.SearchResultsPaginationSet) = 1

            ViewState(VSS.DetailedCollectionsSortDirection) = SortConstants.Ascending
            ViewState(VSS.DetailedCollectionsSortExpression) = "idfVector"
            ViewState(VSS.DetailedCollectionsPaginationSet) = 1

            ViewState(VSS.AggregateCollectionsSortDirection) = SortConstants.Ascending
            ViewState(VSS.AggregateCollectionsSortExpression) = "idfsVSSessionSummary"
            ViewState(VSS.AggregateCollectionsPaginationSet) = 1

            ViewState(VSS.DetailedCollectionsSampleSortDirection) = SortConstants.Ascending
            ViewState(VSS.DetailedCollectionsSampleSortExpression) = "strBarcode"
            ViewState(VSS.DetailedCollectionsSamplePaginationSet) = 1

            ViewState(VSS.DetailedCollectionsFieldTestsSortDirection) = SortConstants.Ascending
            ViewState(VSS.DetailedCollectionsFieldTestsSortExpression) = "strFieldBarcode"
            ViewState(VSS.DetailedCollectionsFieldTestsPaginationSet) = 1

            ViewState(VSS.DetailedCollectionsLabTestsSortDirection) = SortConstants.Ascending
            ViewState(VSS.DetailedCollectionsLabTestsSortExpression) = "strLabSampleID"
            ViewState(VSS.DetailedCollectionsLabTestsPaginationSet) = 1

            ViewState(VSS.AggregateCollectionsDiseasesSortDirection) = SortConstants.Ascending
            ViewState(VSS.AggregateCollectionsDiseasesSortExpression) = "strDiagnosis"
            ViewState(VSS.AggregateCollectionsDiseasesPaginationSet) = 1

            ddlVSSFormSection.SelectedValue = FormSection.SearchForm
            ToggleDisplay(ddlVSSFormSection.SelectedValue)

            'Fill Search Form fields including saved search values from previous search by the current user
            FillFormForSearch()
        Else
            'Find the control that caused the postback and call relavent event
            'Dim ctrl As Control = GetControlThatCausedPostBack()
            'If Not ctrl Is Nothing Then
            '    Select Case ctrl.ID
            '        Case "ddlVSSFormSectionShowHide"
            '            ShowHideSection()
            '    End Select
            'End If
        End If

    End Sub

#Region "Search"

    Private Sub FillFormForSearch()

        'Set cancel message
        SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Search.Text")})

        'Load all required base referene lookup values in drop down list
        Dim BaseRefItems As New Dictionary(Of Int32, BaseRefDictItems) From {
            {1, New BaseRefDictItems With {.Ctrl = ddlSearchVectorType, .BaseReferenceType = BaseReferenceConstants.VectorType, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {2, New BaseRefDictItems With {.Ctrl = ddlSearchDiseaseID, .BaseReferenceType = BaseReferenceConstants.Diagnosis, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {3, New BaseRefDictItems With {.Ctrl = ddlSearchSessionStatusTypeID, .BaseReferenceType = BaseReferenceConstants.VectorSurveillanceSessionStatus, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {4, New BaseRefDictItems With {.Ctrl = ddlSearchSpeciesTypeID, .BaseReferenceType = BaseReferenceConstants.SpeciesList, .HACode = HACodeList.VectorHACode, .BlankRow = True}}
        }

        For Each item As KeyValuePair(Of Int32, BaseRefDictItems) In BaseRefItems
            With item.Value
                BaseReferenceLookUp(.Ctrl, .BaseReferenceType, .HACode, .BlankRow)
            End With
        Next

        GetSavedSearchFieldsData()

        'Default set to empty value for status field
        ddlSearchSessionStatusTypeID.SelectedIndex = 0

        'TODO: MD: Set the Region ID for logged in user as default
        'lucSearch.LocationRegionID=?

        'TODO: MD: Get the "Number of days for which data is displayed by default" value from system configuration settings
        'txtSearchStartDateFrom.Text = DateTime.Today.AddDays(-<NUM_OF_DAYS>).ToString()
        'txtSearchStartDateTo.Text = Convert.ToDateTime(DateTime.Now.ToString())

    End Sub

    Private Sub gvVSSSearchResults_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVSSSearchResults.Sorting

        GridDataSort(e.SortExpression, VSS.SearchResults)

    End Sub

    Private Sub gvVSSSearchResults_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvVSSSearchResults.RowDataBound

        If (e.Row.RowType = DataControlRowType.Header) Then

            GridDatabound(e.Row, VSS.SearchResults)

        End If

    End Sub

    Private Sub gvVSSSearchResults_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVSSSearchResults.RowCommand


        Select Case e.CommandName

            Case GridViewCommandConstants.EditCommand, GridViewCommandConstants.SelectCommand

                ddlVSSFormAction.SelectedValue = FormAction.VSSEdit

                'Get the Session ID
                ViewState(VSS.VSSSessionID) = e.CommandArgument.ToString().ToInt64()

                FillVSSDetail()

        End Select

    End Sub

    Private Sub gvVSSSearchResults_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvVSSSearchResults.RowEditing

        e.Cancel = True

    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearchList.Click

        'Error handling required because of API design
        Try

            If ValidateSearchFields() Then

                Dim parameters As New VectorSurveillanceSessionGetListParams With {.LanguageID = GetCurrentLanguage()}
                Dim controls As New List(Of Control)

                If VectorAPIService Is Nothing Then VectorAPIService = New VectorServiceClient()

                Dim list = VectorAPIService.GetVectorSurveillanceSessionListCountAsync(Gather(divSearchFields, parameters, 9)).Result

                lblSearchResultsNumberOfRecords.Text = list.Item(0).RecordCount

                gvVSSSearchResults.PageIndex = 0
                gvVSSSearchResults.Visible = True
                lblSearchResultsPageNumber.Text = "1"
                FillVSSList(1, 1, VSS.SearchResults)

                'Display search results section
                ddlVSSFormSection.SelectedValue = FormSection.SearchResults
                SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Search_Results.Text")})
                ToggleDisplay(ddlVSSFormSection.SelectedValue)

            Else

                ddlVSSFormSection.SelectedValue = FormSection.SearchForm
                ToggleDisplay(ddlVSSFormSection.SelectedValue)

                txtSearchEIDSSSessionID.Focus()

            End If

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Clear()

            lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText")
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)

            ddlVSSFormSection.SelectedValue = FormSection.SearchForm
            ToggleDisplay(ddlVSSFormSection.SelectedValue)

            txtSearchEIDSSSessionID.Focus()

        End Try

    End Sub

    Private Function ValidateSearchFields() As Boolean

        'Enable to allow the validator event to work
        cvSearchSessionID.Visible = True
        cvFutureDate.Visible = True

        'Validatation to check at-least one search field in entered by user
        Page.Validate("SearchFields")
        If Page.IsValid() Then

            'Validate that the Session start date from/to are not future dates
            Page.Validate("SearchFieldsFutureDate")
            If Page.IsValid() Then
                'Validate business rule for Session start/end date from/to
                Page.Validate("ValidDateRange")
                If Page.IsValid() Then
                    'Validate business rule check session end date range with session start date range
                    Page.Validate("ValidateDates")
                End If
            Else
                lblErr.InnerText = GetLocalResourceObject("lbl_Bad_Date.InnerText")
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)
            End If
        Else
            lblErr.InnerText = GetLocalResourceObject("lbl_One_Search_Criterion.InnerText")
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)
        End If

        'Disable as we do not want to display message on the UI
        cvSearchSessionID.Visible = False
        cvFutureDate.Visible = False

        Return Page.IsValid()

    End Function

    Private Sub FillSpeciesDDL(Optional vectorType As String = "", Optional ddlName As DropDownList = Nothing)

        If Not (ddlName Is Nothing) Then
            FillDropDown(ddlName,
                        GetType(clsSpecies),
                        {vectorType},
                        BaseReferenceConstants.idfsBaseReference,
                        BaseReferenceConstants.Name,
                        AddBlankRow:=True)
        End If

    End Sub

    Protected Sub cvSearchEndDateStartDate_ServerValidate(source As Object, args As ServerValidateEventArgs)

        If String.IsNullOrEmpty(args.Value) Then
            args.IsValid = True
        Else
            Dim dtStartDateFrom? As Date = Nothing
            Dim dtStartDateTo? As Date = Nothing
            Dim dtSearchEndDate? As Date = Convert.ToDateTime(args.Value)

            If Not String.IsNullOrEmpty(txtSearchStartDateFrom.Text) Then dtStartDateFrom = Convert.ToDateTime(txtSearchStartDateFrom.Text)
            If Not String.IsNullOrEmpty(txtSearchStartDateTo.Text) Then dtStartDateTo = Convert.ToDateTime(txtSearchStartDateTo.Text)

            If (dtStartDateFrom Is Nothing) And (dtStartDateTo Is Nothing) Then
                args.IsValid = True
            ElseIf (dtStartDateFrom Is Nothing) Or (dtStartDateTo Is Nothing) Then
                If (dtStartDateTo Is Nothing) Then
                    'Start Date From has value so the rule 2 from use case should satisfy
                    args.IsValid = (dtSearchEndDate >= dtStartDateFrom)
                Else
                    'Start Date To has value so the rule 3 from use case should satisfy
                    args.IsValid = (dtSearchEndDate >= dtStartDateTo)
                End If
            Else
                'Both Start Date From and Strat Date To have values so the rule 3 from use case should satisfy
                args.IsValid = (dtSearchEndDate >= dtStartDateTo)
            End If
        End If

    End Sub

    Protected Sub cvSearchSessionID_ServerValidate(source As Object, args As ServerValidateEventArgs)

        Dim blnValidated As Boolean = False

        Dim ctrlLst As Dictionary(Of String, System.Type) = New Dictionary(Of String, System.Type) From {
                {"txt", GetType(WebControls.TextBox)},
                {"ddl", GetType(WebControls.DropDownList)},
                {"ddlCtrl", GetType(EIDSSControlLibrary.DropDownList)},
                {"txtDT", GetType(EIDSSControlLibrary.CalendarInput)}
            }

        Dim allCtrl As New List(Of Control)
        Dim sCtrlVal As String = ""

        For Each kvp As KeyValuePair(Of String, System.Type) In ctrlLst

            allCtrl.Clear()
            For Each ctrl As WebControls.WebControl In oCommon.FindCtrl(allCtrl, divSearchForm, kvp.Value)

                Select Case kvp.Value
                    Case GetType(WebControls.TextBox)
                        Dim txt As WebControls.TextBox = DirectCast(ctrl, WebControls.TextBox)
                        sCtrlVal = txt.Text
                    Case GetType(WebControls.DropDownList)
                        Dim ddl As WebControls.DropDownList = DirectCast(ctrl, WebControls.DropDownList)
                        sCtrlVal = ddl.SelectedValue
                    Case GetType(EIDSSControlLibrary.DropDownList)
                        Dim ddlCtrl As WebControls.DropDownList = DirectCast(ctrl, WebControls.DropDownList)
                        sCtrlVal = ddlCtrl.SelectedValue
                    Case GetType(EIDSSControlLibrary.CalendarInput)
                        Dim txtDT As EIDSSControlLibrary.CalendarInput = DirectCast(ctrl, EIDSSControlLibrary.CalendarInput)
                        sCtrlVal = txtDT.Text
                End Select
                blnValidated = Not (sCtrlVal.ToString().IsValueNullOrEmpty())
                If blnValidated Then Exit For

            Next
            If blnValidated Then Exit For

        Next

        args.IsValid = blnValidated

    End Sub

    Protected Sub cvFutureDate_ServerValidate(source As Object, args As ServerValidateEventArgs)

        Dim dtStartDateFrom? As Date = Nothing
        Dim dtStartDateTo? As Date = Nothing

        If Not String.IsNullOrEmpty(txtSearchStartDateFrom.Text) Then dtStartDateFrom = Convert.ToDateTime(txtSearchStartDateFrom.Text)
        If Not String.IsNullOrEmpty(txtSearchStartDateTo.Text) Then dtStartDateTo = Convert.ToDateTime(txtSearchStartDateTo.Text)

        If (dtStartDateFrom Is Nothing) And (dtStartDateTo Is Nothing) Then
            args.IsValid = True
        Else
            If Not (dtStartDateFrom Is Nothing) And Not (dtStartDateTo Is Nothing) Then
                args.IsValid = (Date.Compare(dtStartDateFrom, Date.Now) < 0) And (Date.Compare(dtStartDateTo, Date.Now) < 0)
            ElseIf Not (dtStartDateFrom Is Nothing) Then
                args.IsValid = (Date.Compare(dtStartDateFrom, Date.Now) < 0)
            ElseIf Not (dtStartDateTo Is Nothing) Then
                args.IsValid = (Date.Compare(dtStartDateTo, Date.Now) < 0)
            End If
        End If

    End Sub

    Protected Sub ddlSearchVectorType_SelectedIndexChanged(sender As Object, e As EventArgs)

        FillSpeciesDDL(ddlSearchVectorType.SelectedValue, ddlName:=ddlSearchSpeciesTypeID)

    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ClearForms(divSearchForm)
    End Sub

    Public Class BaseRefDictItems

        Public Property Ctrl As DropDownList
        Public Property BaseReferenceType As String
        Public Property HACode As Integer
        Public Property BlankRow As Boolean

        Public Sub New()
        End Sub

    End Class

#End Region

#Region "VSS Detail"

    'Fill the VSS detail section with the record selected from search grid
    Private Sub FillVSSDetail()

        ddlVSSFormSection.SelectedValue = FormSection.Vector
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne

        BaseReferenceLookUp(ddlidfsVectorSurveillanceStatus, BaseReferenceConstants.VectorSurveillanceSessionStatus, HACodeList.VectorHACode, False)
        FillRadioButtonList(rblidfLocation, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.GeoLocationType, "@intHACode:" & HACodeList.VectorHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, Nothing, Nothing)

        'Set the cancel modal text
        SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Vector_Surveillance_Summary.Text")})

        ResetForm(divVector)

        Session(VSS.DetailedCollections) = Nothing
        gvDetailedCollections.DataSource = Nothing
        gvDetailedCollections.DataBind()

        Session(VSS.AggregateCollections) = Nothing
        gvAggregateCollections.DataSource = Nothing
        gvAggregateCollections.DataBind()

        Select Case ddlVSSFormAction.SelectedValue
            Case FormAction.VSSAddFromSearch, FormAction.VSSAddFromSearchResults
                'Set default for new VSS
                ddlidfsVectorSurveillanceStatus.SelectedValue = VSSStatus.InProcessStatus
                rblidfLocation.SelectedValue = VSSLocation.ExactPoint

                'Disable closed status when user is adding a new session
                ddlidfsVectorSurveillanceStatus.Items(1).Attributes("disabled") = "disabled"

            Case FormAction.VSSEdit

                GetVSSDetail()

                PopulateForm(FormSection.Vector)

                'Dim VSSDetailList As List(Of VctsVssessionGetDetailModel) = CType(Session(VSS.VSSDetail), List(Of VctsVssessionGetDetailModel))
                'Scatter(divVector, VSSDetailList.FirstOrDefault())

                'Get Detailed Collections List
                GetVSSDetailedCollectionsList()

                'Get Aggregate Collections List
                GetVSSAggregateCollectionsList()
        End Select

        'Toggle readonly based on status
        ToggleVectorDisplay(True)

        'Display section for selected location type
        ToggleLocationDisplay()

        'Set display to Vector details
        ToggleDisplay(FormSection.Vector)

    End Sub

    'Get VSS details from DB
    Private Sub GetVSSDetail()

        Try

            Dim VSSSessionID As Long = ViewState(VSS.VSSSessionID).ToString().ToInt64()
            If VectorAPIService Is Nothing Then VectorAPIService = New VectorServiceClient()
            Session(VSS.VSSDetail) = VectorAPIService.VectorSurveillanceSessionGetDetail(GetCurrentLanguage(), VSSSessionID).Result

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub ToggleVectorDisplay(Optional blnCreateExceptionList As Boolean = False)

        Dim lngStatus As String = ddlidfsVectorSurveillanceStatus.SelectedValue

        'Set closed date
        txtdatCloseDate.Text = ""
        If lngStatus = VSSStatus.ClosedStatus Then
            txtdatCloseDate.Text = FormatDateTime(DateTime.Now, DateFormat.ShortDate)
        End If

        'Show hide close date
        divCloseDates.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, IIf(lngStatus = VSSStatus.ClosedStatus, "inline", "none"))

        'If status is closed, make the form read only
        ToggleFormView(divVector, (lngStatus <> VSSStatus.ClosedStatus), blnCreateExceptionList)

        'Enable status field
        ddlidfsVectorSurveillanceStatus.Enabled = True

    End Sub

    Private Sub ddlidfsVectorSurveillanceStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsVectorSurveillanceStatus.SelectedIndexChanged

        ToggleVectorDisplay()

    End Sub

    Private Sub rblidfLocation_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblidfLocation.SelectedIndexChanged

        ToggleLocationDisplay()

    End Sub

    'New VSS record
    Private Sub btnCreateVectorSurveillance_Click(sender As Object, e As EventArgs) Handles btnCreateVectorSurveillance.Click

        ddlVSSFormAction.SelectedValue = FormAction.VSSAddFromSearch
        If ddlVSSFormSection.SelectedValue = FormSection.SearchResults Then ddlVSSFormAction.SelectedValue = FormAction.VSSAddFromSearchResults

        'Set the Session ID to New session
        ViewState(VSS.VSSSessionID) = 0

        FillVSSDetail()

    End Sub

    Private Sub btnReturnToSearchFromVector_Click(sender As Object, e As EventArgs) Handles btnReturnToSearchFromVector.Click

        If ViewState(VSS.VSSSessionID).ToString().ToInt64 > 0 Then
            ddlVSSFormSection.SelectedValue = FormSection.SearchResults
        Else
            ddlVSSFormSection.SelectedValue = FormSection.SearchForm
        End If
        ToggleDisplay(ddlVSSFormSection.SelectedValue)

    End Sub

    Private Sub btnVectorSummaryDelete_Click(sender As Object, e As EventArgs) Handles btnVectorSummaryDelete.Click

        ddlVSSFormAction.SelectedValue = FormAction.VSSDelete
        h4DeleteHeader.InnerText = GetLocalResourceObject("hdg_Vector_Surveillance_Session")
        SetModalText(ModalType.Delete, {GetLocalResourceObject("val_Vector_Surveillance_Summary.Text"), txtstrSessionID.Text})
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_DELETE_SCRIPT, True)

    End Sub

    Private Sub btnVectorSummarySubmit_Click(sender As Object, e As EventArgs) Handles btnVectorSummarySubmit.Click

        'TODO MD: Add validations
        'Not implemented datModificationForArchiveDate
        Page.Validate("VectorSummary")
        If Page.IsValid() Then

            Dim VSSSetParams As New VectorSurveillanceSessionSetParams
            With VSSSetParams
                .strFieldSessionId = txtstrFieldSessionID.Text
                .idfsVectorSurveillanceStatus = ddlidfsVectorSurveillanceStatus.SelectedValue
                .datStartDate = txtdatStartDate.Text
                If IsDate(txtdatCloseDate.Text) Then .datCloseDate = txtdatCloseDate.Text
                If Not (txtidfOutbreak.Text.IsValueNullOrEmpty()) AndAlso (txtidfOutbreak.Text <> "0") Then .idfOutbreak = txtidfOutbreak.Text
                .strDescription = txtstrDescription.Text
                If Not (txtintCollectionEffort.Text.IsValueNullOrEmpty()) Then .intCollectionEffort = txtintCollectionEffort.Text
                If Not (rblidfLocation.Text.IsValueNullOrEmpty()) Then .idfsGeolocationType = rblidfLocation.Text
                If Not (ucLocVD.SelectedCountryValue.ToString().IsValueNullOrEmpty()) Then .idfsCountry = ucLocVD.SelectedCountryValue
                If Not (ucLocVD.SelectedRegionValue.ToString().IsValueNullOrEmpty()) Then .idfsRegion = ucLocVD.SelectedRegionValue
                If Not (ucLocVD.SelectedRayonValue.ToString().IsValueNullOrEmpty()) Then .idfsRayon = ucLocVD.SelectedRayonValue
                If Not (ucLocVD.SelectedSettlementValue.ToString().IsValueNullOrEmpty()) Then .idfsSettlement = ucLocVD.SelectedSettlementValue
                .blnForeignAddress = (rblidfLocation.SelectedValue = VSSLocation.ForeignAddress) 'This flag is to indicate if the address is foreign
                .strForeignAddress = txtForeignAddressType.Text 'This is the actual foreign address
                If Not (ucLocVD.LatitudeText.ToString().IsValueNullOrEmpty()) Then .dblLatitude = ucLocVD.LatitudeText
                If Not (ucLocVD.LongitudeText.ToString().IsValueNullOrEmpty()) Then .dblLongitude = ucLocVD.LongitudeText
                .blnGeoLocationShared = False
                If Not (ddlGroundType.SelectedValue.IsValueNullOrEmpty()) Then .idfsGroundType = ddlGroundType.SelectedValue
                If Not (txtDistance.Text.IsValueNullOrEmpty()) Then .dblDistance = txtDistance.Text
                If Not (txtDirection.Text.IsValueNullOrEmpty()) Then .dblDirection = txtDirection.Text

                If ddlVSSFormAction.SelectedValue = FormAction.VSSEdit Then
                    .idfVectorSurveillanceSession = ViewState(VSS.VSSSessionID)
                    .strSessionId = txtstrSessionID.Text
                    .idfGeoLocation = hdfidfGeoLocation.Value
                End If

            End With

            Try
                If VectorAPIService Is Nothing Then VectorAPIService = New VectorServiceClient()
                Dim returnSet = VectorAPIService.VectorSurveillanceSessionSaveDetail(VSSSetParams).Result

                ddlVSSFormSection.SelectedValue = FormSection.Vector
                ddlVSSFormAction.SelectedValue = FormAction.VSSEdit

                'Set the cancel modal text
                SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Vector_Surveillance_Summary.Text")})

                ToggleDisplay(ddlVSSFormSection.SelectedValue)

            Catch ex As Exception

                lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText")
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)

            End Try

        End If

    End Sub

    Protected Sub cvVectorSummary_ServerValidate(source As Object, args As ServerValidateEventArgs)

        'Check if start date is entered and is not greater than current date
        Dim dtStartDate? As Date = Nothing

        If Not String.IsNullOrEmpty(txtdatStartDate.Text) Then dtStartDate = Convert.ToDateTime(txtdatStartDate.Text)
        args.IsValid = ((Not (dtStartDate Is Nothing)) AndAlso (Date.Compare(dtStartDate, Date.Now()) < 0))

        If args.IsValid() Then
            'Check if loction type is foriegn and if yes then check address in entered
            If rblidfLocation.Text = VSSLocation.ForeignAddress Then
                args.IsValid = Not String.IsNullOrEmpty(txtstrForeignAddress.Text)
                If Not args.IsValid() Then
                    lblErr.InnerText = GetLocalResourceObject("val_Session_Foriegn_Address.ErrorMessage")
                End If
            End If
        Else
            lblErr.InnerText = GetLocalResourceObject("val_Session_Start_Future_Date.ErrorMessage")
        End If

        If Not args.IsValid() Then
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)
        End If

    End Sub

#End Region

#Region "Detailed Collection"

    'Get VSS details from DB
    Private Sub GetVSSDetailedCollectionsList()

        Try

            gvDetailedCollections.PageIndex = 0
            gvDetailedCollections.Visible = True
            lblDetailedCollectionsPageNumber.Text = "1"
            FillVSSList(1, 1, VSS.DetailedCollections)

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    'Fill the VSS detailed collection detail section with the record selected from grid
    Private Sub FillVSSDetailedCollectionDetail()

        Dim VSSDetailedCollectionID As Long = ViewState(VSS.VSSDetailCollectionID).ToString.ToInt64()

        ddlVSSFormSection.SelectedValue = FormSection.VectorDetailedCollectionDetail

        'Set the cancel modal text
        SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Detailed_Collection_Detail.Text")})

        'Load all required base referene lookup values in drop down list
        Dim BaseRefItems As New Dictionary(Of Int32, BaseRefDictItems) From {
            {1, New BaseRefDictItems With {.Ctrl = ddlidfsSex, .BaseReferenceType = BaseReferenceConstants.AnimalSex, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {2, New BaseRefDictItems With {.Ctrl = ddlDetailedSurroundings, .BaseReferenceType = BaseReferenceConstants.Surrounding, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {3, New BaseRefDictItems With {.Ctrl = ddlidfsBasisofRecord, .BaseReferenceType = BaseReferenceConstants.Basisofrecord, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {4, New BaseRefDictItems With {.Ctrl = ddlidfsHostReference, .BaseReferenceType = BaseReferenceConstants.VectorType, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {5, New BaseRefDictItems With {.Ctrl = ddlidfsDayPeriod, .BaseReferenceType = BaseReferenceConstants.Collectiontimeperiod, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {6, New BaseRefDictItems With {.Ctrl = ddlidfsIdentificationMethod, .BaseReferenceType = BaseReferenceConstants.Identificationmethod, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {7, New BaseRefDictItems With {.Ctrl = ddlidfsEctoparasitesCollected, .BaseReferenceType = BaseReferenceConstants.YesNoValueList, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {8, New BaseRefDictItems With {.Ctrl = ddlDetailedGroundType, .BaseReferenceType = BaseReferenceConstants.GroundType, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {9, New BaseRefDictItems With {.Ctrl = ddlidfsCollectionMethod, .BaseReferenceType = BaseReferenceConstants.Collectionmethod, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {10, New BaseRefDictItems With {.Ctrl = ddlidfDetailedVectorType, .BaseReferenceType = BaseReferenceConstants.VectorType, .HACode = HACodeList.VectorHACode, .BlankRow = True}}
        }

        For Each item As KeyValuePair(Of Int32, BaseRefDictItems) In BaseRefItems
            With item.Value
                BaseReferenceLookUp(.Ctrl, .BaseReferenceType, .HACode, .BlankRow)
            End With
        Next

        FillDropDown(ddlidfCollectedByOffice, GetType(clsAdminOrganization), {}, AdminOrganization.OfficeID, AdminOrganization.Name, AddBlankRow:=True)
        FillDropDown(ddlidfIdentifiedByOffice, GetType(clsAdminOrganization), {}, AdminOrganization.OfficeID, AdminOrganization.Name, AddBlankRow:=True)
        FillRadioButtonList(rbldidfsGeoLocationType, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.GeoLocationType, "@intHACode:" & HACodeList.VectorHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, Nothing, Nothing)

        If VSSDetailedCollectionID > 0 Then

            'set the active tab to review
            hdnPanelController.Value = 6

            GetVSSDetailedCollectionDetail()

            Dim VSSDetailedCollectionDetail As List(Of VctsVectCollectionGetDetailModel) = CType(Session(VSS.VSSDetailedCollectionDetail), List(Of VctsVectCollectionGetDetailModel))
            Scatter(divDetailedCollectionDetail, VSSDetailedCollectionDetail.FirstOrDefault())

            GetVSSDetailedCollectionsSampleList()
            GetVSSDetailedCollectionsFieldTestsList()
            GetVSSDetailedCollectionsLabTestsList()

        Else

            'set the active tab to first section
            hdnPanelController.Value = 0

            'Set default for new VSS
            rbldidfsGeoLocationType.SelectedValue = VSSLocation.ExactPoint

        End If

        ToggleLocationDisplay()

    End Sub

    'Get VSS detailed collection detail from DB
    Private Sub GetVSSDetailedCollectionDetail()

        Try

            Dim VSSSessionID As Long = ViewState(VSS.VSSSessionID).ToString().ToInt64()
            Dim VSSDetailedCollectionID = ViewState(VSS.VSSDetailCollectionID).ToString().ToInt64()

            If VectorAPIService Is Nothing Then VectorAPIService = New VectorServiceClient()
            Session(VSS.VSSDetailedCollectionDetail) = VectorAPIService.VectorSurveillanceSessionDetailedCollectionGetDetail(VSSDetailedCollectionID, VSSSessionID, GetCurrentLanguage()).Result

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub GetVSSDetailedCollectionsSampleList()

        Try

            gvDetailedCollectionsSample.PageIndex = 0
            gvDetailedCollectionsSample.Visible = True
            lblDetailedCollectionsSamplePageNumber.Text = "1"
            FillVSSList(1, 1, VSS.DetailedCollectionsSample)

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub GetVSSDetailedCollectionsFieldTestsList()

        Try

            gvDetailedCollectionsFieldTests.PageIndex = 0
            gvDetailedCollectionsFieldTests.Visible = True
            lblDetailedCollectionsFieldTestsPageNumber.Text = "1"
            FillVSSList(1, 1, VSS.DetailedCollectionsFieldTests)

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub GetVSSDetailedCollectionsLabTestsList()

        Try

            gvDetailedCollectionsLabTests.PageIndex = 0
            gvDetailedCollectionsLabTests.Visible = True
            lblDetailedCollectionsLabTestsPageNumber.Text = "1"
            FillVSSList(1, 1, VSS.DetailedCollectionsLabTests)

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub gvDetailedCollections_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDetailedCollections.RowDataBound

        If (e.Row.RowType = DataControlRowType.Header) Then

            GridDatabound(e.Row, VSS.DetailedCollections)

        End If

    End Sub

    Private Sub gvDetailedCollections_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvDetailedCollections.Sorting

        GridDataSort(e.SortExpression, VSS.DetailedCollections)

    End Sub

    Private Sub gvDetailedCollections_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetailedCollections.RowCommand

        Select Case e.CommandName
            Case GridViewCommandConstants.EditCommand, GridViewCommandConstants.SelectCommand

                ddlVSSFormSection.SelectedValue = FormSection.VectorDetailedCollectionDetail
                ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
                ddlVSSFormAction.SelectedValue = FormAction.VSSDetailedCollectionEdit

                'Get the Detailed Collection ID
                ViewState(VSS.VSSDetailCollectionID) = e.CommandArgument.ToString().ToInt64()

                FillVSSDetailedCollectionDetail()

                'Set display to Detailed Collection details
                ToggleDisplay(FormSection.VectorDetailedCollectionDetail)

        End Select

    End Sub

    Private Sub gvDetailedCollections_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvDetailedCollections.RowEditing

        e.Cancel = True

    End Sub

    Private Sub gvDetailedCollections_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDetailedCollections.RowDeleting

        ddlVSSFormAction.SelectedValue = FormAction.VSSDetailedCollectionDelete

        GetVSSDetailedCollectionsSampleList()
        GetVSSDetailedCollectionsFieldTestsList()
        GetVSSDetailedCollectionsLabTestsList()

        h4DeleteHeader.InnerText = GetLocalResourceObject("hdg_Vector_Surveillance_Session_Detailed_Collection")
        SetModalText(ModalType.Delete, {GetLocalResourceObject("val_Vector_Surveillance_Summary_Detailed_Collection.Text"), ViewState(VSS.VSSDetailCollectionID)})
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_DELETE_SCRIPT, True)

    End Sub

    Private Sub DifferentLocationfromSession(sender As Object, e As EventArgs) Handles rdbDifferentLocationfromSessionYes.CheckedChanged, rdbDifferentLocationfromSessionNo.CheckedChanged

        divVSSDetailedCollectionLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        If rdbDifferentLocationfromSessionYes.Checked Then
            divVSSDetailedCollectionLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
        End If

    End Sub

    Private Sub rbldidfsGeoLocationType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rbldidfsGeoLocationType.SelectedIndexChanged

        ToggleLocationDisplay()

    End Sub

    Private Sub gvDetailedCollectionsSample_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetailedCollectionsSample.RowCommand

        Select Case e.CommandName
            Case GridViewCommandConstants.EditCommand, GridViewCommandConstants.DeleteCommand

                'Get the Session ID
                ViewState(VSS.VSSDetailCollectionSampleID) = e.CommandArgument.ToString().ToInt64()

            Case GridViewCommandConstants.SelectCommand

                'ddlVSSFormSection.SelectedValue = FormSection.Vector
                ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
                ddlVSSFormAction.SelectedValue = FormAction.VSSDetailedCollectionSampleEdit

                'Get the Session ID
                ViewState(VSS.VSSDetailCollectionSampleID) = e.CommandArgument.ToString().ToInt64()

                'FillVSSDetail()

                'Set display to Vector details
                'ToggleDisplay(FormSection.Vector)

        End Select

    End Sub

    Private Sub gvDetailedCollectionsSample_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDetailedCollectionsSample.RowDataBound

        If (e.Row.RowType = DataControlRowType.Header) Then

            GridDatabound(e.Row, VSS.DetailedCollectionsSample)

        End If

    End Sub

    Private Sub gvDetailedCollectionsSample_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvDetailedCollectionsSample.Sorting

        GridDataSort(e.SortExpression, VSS.DetailedCollectionsSample)

    End Sub

    Private Sub gvDetailedCollectionsSample_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDetailedCollectionsSample.RowDeleting

        'ddlVSSFormSection.SelectedValue = FormSection.SearchResults
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSVSSDetailedCollectionSampleDelete

        'FillVSSDetail()

        'btnVectorSummaryDelete_Click(sender, e)

    End Sub

    Private Sub gvDetailedCollectionsSample_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvDetailedCollectionsSample.RowEditing

        'ddlVSSFormSection.SelectedValue = FormSection.Vector
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSDetailedCollectionSampleEdit

        'FillVSSDetail()

        'Set display to Vector details
        'ToggleDisplay(FormSection.Vector)

    End Sub

    Private Sub gvDetailedCollectionsFieldTests_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetailedCollectionsFieldTests.RowCommand

        Select Case e.CommandName
            Case GridViewCommandConstants.EditCommand, GridViewCommandConstants.DeleteCommand

                'Get the Session ID
                ViewState(VSS.VSSDetailCollectionFieldTestsID) = e.CommandArgument.ToString().ToInt64()

            Case GridViewCommandConstants.SelectCommand

                'ddlVSSFormSection.SelectedValue = FormSection.Vector
                ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
                ddlVSSFormAction.SelectedValue = FormAction.VSSVSSDetailedCollectionFieldTestsEdit

                'Get the Session ID
                ViewState(VSS.VSSDetailCollectionFieldTestsID) = e.CommandArgument.ToString().ToInt64()

                'FillVSSDetail()

                'Set display to Vector details
                'ToggleDisplay(FormSection.Vector)

        End Select

    End Sub

    Private Sub gvDetailedCollectionsFieldTests_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDetailedCollectionsFieldTests.RowDataBound

        If (e.Row.RowType = DataControlRowType.Header) Then

            GridDatabound(e.Row, VSS.DetailedCollectionsFieldTests)

        End If

    End Sub

    Private Sub gvDetailedCollectionsFieldTests_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvDetailedCollectionsFieldTests.RowEditing

        'ddlVSSFormSection.SelectedValue = FormSection.Vector
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSEdit

        'FillVSSDetail()

        'Set display to Vector details
        'ToggleDisplay(FormSection.Vector)

    End Sub

    Private Sub gvDetailedCollectionsFieldTests_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDetailedCollectionsFieldTests.RowDeleting

        'ddlVSSFormSection.SelectedValue = FormSection.SearchResults
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSVSSDetailedCollectionFieldTestsDelete

        'FillVSSDetail()

        'btnVectorSummaryDelete_Click(sender, e)

    End Sub

    Private Sub gvDetailedCollectionsFieldTests_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles gvDetailedCollectionsFieldTests.RowDeleted

    End Sub

    Private Sub gvDetailedCollectionsFieldTests_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvDetailedCollectionsFieldTests.Sorting

        GridDataSort(e.SortExpression, VSS.DetailedCollectionsFieldTests)

    End Sub

    Private Sub gvDetailedCollectionsLabTests_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetailedCollectionsLabTests.RowCommand

        Select Case e.CommandName
            Case GridViewCommandConstants.EditCommand, GridViewCommandConstants.DeleteCommand

                'Get the Session ID
                ViewState(VSS.VSSDetailCollectionLabTestsID) = e.CommandArgument.ToString().ToInt64()

            Case GridViewCommandConstants.SelectCommand

                'ddlVSSFormSection.SelectedValue = FormSection.Vector
                ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
                ddlVSSFormAction.SelectedValue = FormAction.VSSVSSDetailedCollectionLabTestsEdit

                'Get the Session ID
                ViewState(VSS.VSSDetailCollectionLabTestsID) = e.CommandArgument.ToString().ToInt64()

                'FillVSSDetail()

                'Set display to Vector details
                'ToggleDisplay(FormSection.Vector)

        End Select

    End Sub

    Private Sub gvDetailedCollectionsLabTests_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDetailedCollectionsLabTests.RowDataBound

        If (e.Row.RowType = DataControlRowType.Header) Then

            GridDatabound(e.Row, VSS.DetailedCollectionsLabTests)

        End If

    End Sub

    Private Sub gvDetailedCollectionsLabTests_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvDetailedCollectionsLabTests.RowEditing

        'ddlVSSFormSection.SelectedValue = FormSection.Vector
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSVSSDetailedCollectionLabTestsEdit

        'FillVSSDetail()

        'Set display to Vector details
        'ToggleDisplay(FormSection.Vector)

        e.Cancel = True

    End Sub

    Private Sub gvDetailedCollectionsLabTests_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDetailedCollectionsLabTests.RowDeleting

        'ddlVSSFormSection.SelectedValue = FormSection.SearchResults
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSVSSDetailedCollectionLabTestsDelete

        'FillVSSDetail()

        'btnVectorSummaryDelete_Click(sender, e)

    End Sub

    Private Sub gvDetailedCollectionsLabTests_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles gvDetailedCollectionsLabTests.RowDeleted

    End Sub

    Private Sub gvDetailedCollectionsLabTests_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvDetailedCollectionsLabTests.Sorting

        GridDataSort(e.SortExpression, VSS.DetailedCollectionsLabTests)

    End Sub

    Protected Sub chkCopyVSSDetailedCollectionResults_CheckedChanged(sender As Object, e As EventArgs)

        Dim _CheckBox As CheckBox = DirectCast(sender, CheckBox)
        If _CheckBox.Checked Then
            Dim _GridRow As GridViewRow = DirectCast(_CheckBox.NamingContainer, GridViewRow)
            ViewState(VSS.VSSDetailCollectionID) = gvDetailedCollections.DataKeys(_GridRow.RowIndex).Value
            _CheckBox.Checked = False
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_DETAILED_COLLECTION_COPY_SCRIPT, True)
        End If

    End Sub

    Private Sub btnDetailedCollectionCopyConfirm_Click(sender As Object, e As EventArgs) Handles btnDetailedCollectionCopyConfirm.Click

        'TODO MD:Copy detailed collection data

    End Sub

#End Region

#Region "Aggregate Collections"

    'Get VSS details from DB
    Private Sub GetVSSAggregateCollectionsList()

        Try

            gvAggregateCollections.PageIndex = 0
            gvAggregateCollections.Visible = True
            lblAggregateCollectionsPageNumber.Text = "1"
            FillVSSList(1, 1, VSS.AggregateCollections)

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    'Fill the VSS aggregate collection detail section with the record selected from grid
    Private Sub FillVSSAggregateCollectionDetail()

        Dim VSSAggregateCollectionID As Long = ViewState(VSS.VSSAggregateCollectionID).ToString.ToInt64()

        ddlVSSFormSection.SelectedValue = FormSection.VectorAggregateCollectionDetail

        'Set the cancel modal text
        SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Aggregate_Collection_Detail.Text")})

        'Load all required base referene lookup values in drop down list
        Dim BaseRefItems As New Dictionary(Of Int32, BaseRefDictItems) From {
            {1, New BaseRefDictItems With {.Ctrl = ddlAggregateDiagnosis, .BaseReferenceType = BaseReferenceConstants.Diagnosis, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {2, New BaseRefDictItems With {.Ctrl = ddlAggidfsVectorType, .BaseReferenceType = BaseReferenceConstants.VectorType, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {3, New BaseRefDictItems With {.Ctrl = ddlAggidfsVectorSubType, .BaseReferenceType = BaseReferenceConstants.SpeciesList, .HACode = HACodeList.VectorHACode, .BlankRow = True}},
            {4, New BaseRefDictItems With {.Ctrl = ddlAggidfsSex, .BaseReferenceType = BaseReferenceConstants.AnimalSex, .HACode = HACodeList.VectorHACode, .BlankRow = True}}
        }

        For Each item As KeyValuePair(Of Int32, BaseRefDictItems) In BaseRefItems
            With item.Value
                BaseReferenceLookUp(.Ctrl, .BaseReferenceType, .HACode, .BlankRow)
            End With
        Next

        If VSSAggregateCollectionID > 0 Then

            GetVSSAggregateCollectionDetail()

            Dim VSSAggregateCollectionDetail As List(Of VctsVecSessionSummaryGetDetailModel) = CType(Session(VSS.VSSAggregateCollectionDetail), List(Of VctsVecSessionSummaryGetDetailModel))
            Scatter(divAggregateCollectionDetail, VSSAggregateCollectionDetail.FirstOrDefault(), 6)

            GetVSSAggregateCollectionsDieaseList()

        Else
            'Set default for new VSS
        End If

        ToggleLocationDisplay()

    End Sub

    'Get VSS aggregate collection detail from DB
    Private Sub GetVSSAggregateCollectionDetail()

        Try

            Dim VSSSessionID As Long = ViewState(VSS.VSSSessionID).ToString().ToInt64()
            Dim VSSAggregateCollectionID = ViewState(VSS.VSSAggregateCollectionID).ToString().ToInt64()

            If VectorAPIService Is Nothing Then VectorAPIService = New VectorServiceClient()
            Session(VSS.VSSAggregateCollectionDetail) = VectorAPIService.VectorSurveillanceSessionAggregateCollectionGetDetail(VSSAggregateCollectionID, VSSSessionID, GetCurrentLanguage()).Result

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub GetVSSAggregateCollectionsDieaseList()

        Try

            gvAggregateCollectionDiseases.PageIndex = 0
            gvAggregateCollectionDiseases.Visible = True
            lblAggregateCollectionDiseasesPageNumber.Text = "1"
            FillVSSList(1, 1, VSS.AggregateCollectionsDiseases)

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub gvAggregateCollections_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvAggregateCollections.RowDataBound

        If (e.Row.RowType = DataControlRowType.Header) Then

            GridDatabound(e.Row, VSS.AggregateCollections)

        End If

    End Sub

    Private Sub gvAggregateCollections_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvAggregateCollections.Sorting

        GridDataSort(e.SortExpression, VSS.AggregateCollections)

    End Sub

    Private Sub gvAggregateCollections_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAggregateCollections.RowCommand

        Select Case e.CommandName
            Case GridViewCommandConstants.EditCommand, GridViewCommandConstants.DeleteCommand

                'Get the Aggregate Collection ID
                ViewState(VSS.VSSAggregateCollectionID) = e.CommandArgument.ToString().ToInt64()

            Case GridViewCommandConstants.SelectCommand

                ddlVSSFormSection.SelectedValue = FormSection.VectorAggregateCollectionDetail
                ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
                ddlVSSFormAction.SelectedValue = FormAction.VSSAggregateCollectionEdit

                'Get the Aggregate Collection ID
                ViewState(VSS.VSSAggregateCollectionID) = e.CommandArgument.ToString().ToInt64()

                FillVSSAggregateCollectionDetail()

                'Set display to Aggregate Collection details
                ToggleDisplay(FormSection.VectorAggregateCollectionDetail)

        End Select

    End Sub

    Private Sub gvAggregateCollections_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvAggregateCollections.RowEditing

        ddlVSSFormSection.SelectedValue = FormSection.VectorAggregateCollectionDetail
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSAggregateCollectionEdit

        FillVSSAggregateCollectionDetail()

        'Set display to Vector Aggregate Collection details
        ToggleDisplay(FormSection.VectorAggregateCollectionDetail)

        e.Cancel = True

    End Sub

    Private Sub gvAggregateCollectionDiseases_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAggregateCollectionDiseases.RowCommand

        Select Case e.CommandName
            Case GridViewCommandConstants.EditCommand, GridViewCommandConstants.DeleteCommand

                'Get the Session ID
                ViewState(VSS.VSSAggregateCollectionDiseaseID) = e.CommandArgument.ToString().ToInt64()

            Case GridViewCommandConstants.SelectCommand

                'ddlVSSFormSection.SelectedValue = FormSection.Vector
                ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
                ddlVSSFormAction.SelectedValue = FormAction.VSSAggregateCollectionDiseasesEdit

                'Get the Session ID
                ViewState(VSS.VSSAggregateCollectionDiseaseID) = e.CommandArgument.ToString().ToInt64()

                'FillVSSDetail()

                'Set display to Vector details
                'ToggleDisplay(FormSection.Vector)

        End Select

    End Sub

    Private Sub gvAggregateCollectionDiseases_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvAggregateCollectionDiseases.RowDataBound

        If (e.Row.RowType = DataControlRowType.Header) Then

            GridDatabound(e.Row, VSS.AggregateCollectionsDiseases)

        End If

    End Sub

    Private Sub gvAggregateCollectionDiseases_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvAggregateCollectionDiseases.RowDeleting

        ddlVSSFormAction.SelectedValue = FormAction.VSSAggregateCollectionDelete
        h4DeleteHeader.InnerText = GetLocalResourceObject("hdg_Vector_Surveillance_Session_Aggregate_Collection")
        SetModalText(ModalType.Delete, {GetLocalResourceObject("val_Vector_Surveillance_Summary_Aggregate_Collection.Text"), ViewState(VSS.VSSAggregateCollectionID)})
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_DELETE_SCRIPT, True)

    End Sub

    Private Sub gvAggregateCollectionDiseases_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvAggregateCollectionDiseases.RowEditing

        'ddlVSSFormSection.SelectedValue = FormSection.Vector
        ddlVSSFormSectionShowHide.SelectedValue = FormSectionShowHide.SelectOne
        ddlVSSFormAction.SelectedValue = FormAction.VSSAggregateCollectionDiseasesEdit

        'FillVSSDetail()

        'Set display to Vector details
        'ToggleDisplay(FormSection.Vector)

    End Sub

    Private Sub gvAggregateCollectionDiseases_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvAggregateCollectionDiseases.Sorting

        GridDataSort(e.SortExpression, VSS.AggregateCollectionsDiseases)

    End Sub

#End Region

#Region "Form Common Methods"

    Private Function GetControlThatCausedPostBack() As Control

        Dim ctrl As Control = Nothing
        'get the event target name And find the control
        Dim ctrlName As String = Page.Request.Params.Get("__EVENTTARGET")
        If Not (String.IsNullOrEmpty(ctrlName)) Then ctrl = Page.FindControl(ctrlName)

        Return ctrl

    End Function

    Private Sub FillVSSList(ByVal pageIndex As Integer, ByVal paginationSetNumber As Integer, ByVal ForControlName As String)

        Try

            If VectorAPIService Is Nothing Then VectorAPIService = New VectorServiceClient()

            Dim _GVControl As GridView = Nothing
            Dim _PaginationSet As String = ""
            Dim _RecordCount As Integer = 0

            Select Case ForControlName
                Case VSS.SearchResults

                    Dim parameters As New VectorSurveillanceSessionGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber}
                    Session(VSS.SearchResults) = VectorAPIService.GetVectorSurveillanceSessionListAsync(Gather(divSearchFields, parameters, 9)).Result

                    _GVControl = gvVSSSearchResults
                    _PaginationSet = VSS.SearchResultsPaginationSet
                    _RecordCount = lblSearchResultsNumberOfRecords.Text
                    SaveSearchCriteriaJSON(parameters, CreateTempFile(hdfidfUserID.Value.ToString(), ID))

                Case VSS.DetailedCollections

                    Dim VSSSessionID As Long = ViewState(VSS.VSSSessionID).ToString().ToInt64()
                    Dim VSSDetailedCollectionsList = VectorAPIService.VectorSurveillanceSessionDetailedCollectionGetList(GetCurrentLanguage(), VSSSessionID).Result
                    Session(VSS.DetailedCollections) = VSSDetailedCollectionsList

                    _GVControl = gvDetailedCollections
                    _PaginationSet = VSS.DetailedCollectionsPaginationSet
                    lblDetailedCollectionsNumberOfRecords.Text = VSSDetailedCollectionsList.Count
                    _RecordCount = lblDetailedCollectionsNumberOfRecords.Text

                Case VSS.AggregateCollections

                    Dim VSSSessionID As Long = ViewState(VSS.VSSSessionID).ToString().ToInt64()
                    Dim VSSAggregateCollectionsList = VectorAPIService.VectorSurveillanceSessionAggregateCollectionGetList(GetCurrentLanguage(), VSSSessionID).Result
                    Session(VSS.AggregateCollections) = VSSAggregateCollectionsList

                    _GVControl = gvDetailedCollections
                    _PaginationSet = VSS.AggregateCollectionsPaginationSet
                    lblAggregateCollectionsNumberOfRecords.Text = VSSAggregateCollectionsList.Count
                    _RecordCount = lblAggregateCollectionsNumberOfRecords.Text

                Case VSS.DetailedCollectionsSample

                    Dim VSSDetailCollectionID As Long = ViewState(VSS.VSSDetailCollectionID).ToString().ToInt64()
                    Dim VSSDetailedCollectionsSampleList = VectorAPIService.VectorSurveillanceSessionDetailedCollectionSampleGetList(VSSDetailCollectionID, GetCurrentLanguage()).Result
                    Session(VSS.DetailedCollectionsSample) = VSSDetailedCollectionsSampleList

                    _GVControl = gvDetailedCollectionsSample
                    _PaginationSet = VSS.DetailedCollectionsPaginationSet
                    lblDetailedCollectionsSampleNumberOfRecords.Text = VSSDetailedCollectionsSampleList.Count
                    _RecordCount = lblDetailedCollectionsSampleNumberOfRecords.Text

                Case VSS.DetailedCollectionsFieldTests

                    Dim VSSDetailCollectionID As Long = ViewState(VSS.VSSDetailCollectionID).ToString().ToInt64()
                    Dim VSSDetailedCollectionsFieldTestsList = VectorAPIService.VectorSurveillanceSessionDetailedCollectionFieldTestsGetList(VSSDetailCollectionID, GetCurrentLanguage()).Result
                    Session(VSS.DetailedCollectionsFieldTests) = VSSDetailedCollectionsFieldTestsList

                    _GVControl = gvDetailedCollectionsFieldTests
                    _PaginationSet = VSS.DetailedCollectionsPaginationSet
                    lblDetailedCollectionsFieldTestsNumberOfRecords.Text = VSSDetailedCollectionsFieldTestsList.Count
                    _RecordCount = lblDetailedCollectionsFieldTestsNumberOfRecords.Text

                Case VSS.DetailedCollectionsLabTests

                    Dim VSSSessionID As Long = ViewState(VSS.VSSSessionID).ToString().ToInt64()
                    Dim VSSDetailCollectionID As Long = ViewState(VSS.VSSDetailCollectionID).ToString().ToInt64()
                    Dim VSSDetailedCollectionsLabTestsList = VectorAPIService.VectorSurveillanceSessionDetailedCollectionLabTestsGetList(VSSDetailCollectionID, VSSSessionID, GetCurrentLanguage()).Result
                    Session(VSS.DetailedCollectionsLabTests) = VSSDetailedCollectionsLabTestsList

                    _GVControl = gvDetailedCollectionsLabTests
                    _PaginationSet = VSS.DetailedCollectionsPaginationSet
                    lblDetailedCollectionsLabTestsNumberOfRecords.Text = VSSDetailedCollectionsLabTestsList.Count
                    _RecordCount = lblDetailedCollectionsLabTestsNumberOfRecords.Text

                Case VSS.AggregateCollectionsDiseases

                    Dim VSSSessionID As Long = ViewState(VSS.VSSSessionID).ToString().ToInt64()
                    Dim VSSAggregateCollectionsDiseaseList = VectorAPIService.VectorSurveillanceSessionAggregateCollectionDiagnosisGetList(VSSSessionID, GetCurrentLanguage()).Result
                    Session(VSS.AggregateCollectionsDiseases) = VSSAggregateCollectionsDiseaseList

                    _GVControl = gvAggregateCollectionDiseases
                    _PaginationSet = VSS.AggregateCollectionsDiseasesPaginationSet
                    lblAggregateCollectionDiseasesNumberOfRecords.Text = VSSAggregateCollectionsDiseaseList.Count
                    _RecordCount = lblAggregateCollectionDiseasesNumberOfRecords.Text

            End Select

            _GVControl.DataSource = Nothing
            BindGridView(ForControlName)
            FillPager(_RecordCount, pageIndex, ForControlName)
            ViewState(_PaginationSet) = paginationSetNumber

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub BindGridView(ByVal ForControlName As String)

        Dim _SortExpression As String = Nothing
        Dim _SortDirection As String = SortConstants.Descending

        Select Case ForControlName
            Case VSS.SearchResults
                Dim VSSList = CType(Session(VSS.SearchResults), List(Of VctsSurveillanceSessionGetListModel))
                _SortExpression = ViewState(VSS.SearchResultsSortExpression)
                _SortDirection = ViewState(VSS.SearchResultsSortDirection)

                If (Not _SortExpression Is Nothing) Then
                    If _SortDirection = SortConstants.Ascending Then
                        VSSList = VSSList.OrderBy(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    Else
                        VSSList = VSSList.OrderByDescending(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    End If
                End If

                gvVSSSearchResults.DataSource = VSSList
                gvVSSSearchResults.DataBind()

            Case VSS.DetailedCollections

                Dim VSSList = CType(Session(VSS.DetailedCollections), List(Of VctsVectGetDetailModel))
                _SortExpression = ViewState(VSS.DetailedCollectionsSortExpression)
                _SortDirection = ViewState(VSS.DetailedCollectionsSortDirection)

                If (Not _SortExpression Is Nothing) Then
                    If _SortDirection = SortConstants.Ascending Then
                        VSSList = VSSList.OrderBy(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    Else
                        VSSList = VSSList.OrderByDescending(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    End If
                End If

                gvDetailedCollections.DataSource = VSSList
                gvDetailedCollections.DataBind()

            Case VSS.AggregateCollections

                Dim VSSList = CType(Session(VSS.AggregateCollections), List(Of VctsVecSessionSummaryGetListModel))
                _SortExpression = ViewState(VSS.AggregateCollectionsSortExpression)
                _SortDirection = ViewState(VSS.AggregateCollectionsSortDirection)

                If (Not _SortExpression Is Nothing) Then
                    If _SortDirection = SortConstants.Ascending Then
                        VSSList = VSSList.OrderBy(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    Else
                        VSSList = VSSList.OrderByDescending(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    End If
                End If

                gvAggregateCollections.DataSource = VSSList
                gvAggregateCollections.DataBind()

            Case VSS.DetailedCollectionsSample

                Dim VSSList = CType(Session(VSS.DetailedCollectionsSample), List(Of VctsSampleGetListModel))
                _SortExpression = ViewState(VSS.DetailedCollectionsSampleSortExpression)
                _SortDirection = ViewState(VSS.DetailedCollectionsSampleSortDirection)

                If (Not _SortExpression Is Nothing) Then
                    If _SortDirection = SortConstants.Ascending Then
                        VSSList = VSSList.OrderBy(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    Else
                        VSSList = VSSList.OrderByDescending(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    End If
                End If

                gvDetailedCollectionsSample.DataSource = VSSList
                gvDetailedCollectionsSample.DataBind()

            Case VSS.DetailedCollectionsFieldTests

                Dim VSSList = CType(Session(VSS.DetailedCollectionsFieldTests), List(Of VctsFieldtestGetListModel))
                _SortExpression = ViewState(VSS.DetailedCollectionsFieldTestsSortExpression)
                _SortDirection = ViewState(VSS.DetailedCollectionsFieldTestsSortDirection)

                If (Not _SortExpression Is Nothing) Then
                    If _SortDirection = SortConstants.Ascending Then
                        VSSList = VSSList.OrderBy(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    Else
                        VSSList = VSSList.OrderByDescending(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    End If
                End If

                gvDetailedCollectionsFieldTests.DataSource = VSSList
                gvDetailedCollectionsFieldTests.DataBind()

            Case VSS.DetailedCollectionsLabTests

                Dim VSSList = CType(Session(VSS.DetailedCollectionsLabTests), List(Of VctsLabtestGetListModel))
                _SortExpression = ViewState(VSS.DetailedCollectionsLabTestsSortExpression)
                _SortDirection = ViewState(VSS.DetailedCollectionsLabTestsSortDirection)

                If (Not _SortExpression Is Nothing) Then
                    If _SortDirection = SortConstants.Ascending Then
                        VSSList = VSSList.OrderBy(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    Else
                        VSSList = VSSList.OrderByDescending(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    End If
                End If

                gvDetailedCollectionsLabTests.DataSource = VSSList
                gvDetailedCollectionsLabTests.DataBind()

            Case VSS.AggregateCollectionsDiseases

                Dim VSSList = CType(Session(VSS.AggregateCollectionsDiseases), List(Of VctsSessionsummarydiagnosisGetDetailModel))
                _SortExpression = ViewState(VSS.AggregateCollectionsDiseasesSortExpression)
                _SortDirection = ViewState(VSS.AggregateCollectionsDiseasesSortDirection)

                If (Not _SortExpression Is Nothing) Then
                    If _SortDirection = SortConstants.Ascending Then
                        VSSList = VSSList.OrderBy(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    Else
                        VSSList = VSSList.OrderByDescending(Function(x) x.GetType().GetProperty(_SortExpression).GetValue(x)).ToList()
                    End If
                End If

                gvAggregateCollectionDiseases.DataSource = VSSList
                gvAggregateCollectionDiseases.DataBind()

        End Select

    End Sub

    Private Function GetColumnIndex(ByVal ForControlName As String) As Integer

        Dim SortExpression As String = ""
        Dim gvControl As GridView = Nothing
        Select Case ForControlName
            Case VSS.SearchResults
                SortExpression = ViewState(VSS.SearchResultsSortExpression)
                gvControl = gvVSSSearchResults
            Case VSS.DetailedCollections
                gvControl = gvDetailedCollections
                SortExpression = ViewState(VSS.DetailedCollectionsSortExpression)
            Case VSS.AggregateCollections
                gvControl = gvAggregateCollections
                SortExpression = ViewState(VSS.AggregateCollectionsSortExpression)
            Case VSS.DetailedCollectionsSample
                gvControl = gvDetailedCollectionsSample
                SortExpression = ViewState(VSS.DetailedCollectionsSampleSortExpression)
            Case VSS.DetailedCollectionsFieldTests
                gvControl = gvDetailedCollectionsFieldTests
                SortExpression = ViewState(VSS.DetailedCollectionsFieldTestsSortExpression)
            Case VSS.DetailedCollectionsLabTests
                gvControl = gvDetailedCollectionsLabTests
                SortExpression = ViewState(VSS.DetailedCollectionsLabTestsSortExpression)
            Case VSS.AggregateCollectionsDiseases
                gvControl = gvAggregateCollectionDiseases
                SortExpression = ViewState(VSS.AggregateCollectionsDiseasesSortExpression)
        End Select

        Dim intI As Integer = -1
        For Each col As DataControlField In gvControl.Columns
            If col.SortExpression = SortExpression Then
                intI = gvControl.Columns.IndexOf(col)
                Exit For
            End If
        Next

        Return intI

    End Function

    Private Sub ddlVSSFormSection_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVSSFormSection.SelectedIndexChanged
        ToggleDisplay(ddlVSSFormSection.SelectedValue)
    End Sub

    Private Sub ddlVSSFormSectionShowHide_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVSSFormSectionShowHide.SelectedIndexChanged
        ShowHideSection()
    End Sub

    Public Sub GetSavedSearchFieldsData()

        'Assign defaults from current user data
        GetUserProfile()

        Dim parameters = New VectorSurveillanceSessionGetListParams()
        Scatter(divSearchForm, ReadSearchCriteriaJSON(parameters, CreateTempFile(hdfidfUserID.Value.ToString(), ID)), 3)

    End Sub

    Protected Sub ClearForms(form As Control)

        Try
            If hdfidfUserID.Value.IsValueNullOrEmpty = True Then
                GetUserProfile()
            End If

            DeleteTempFiles(HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & ID & hdfidfUserID.Value & ".xml")

            ResetForm(form)

            ViewState(VSS.SearchResultsSortDirection) = SortConstants.Ascending
            ViewState(VSS.SearchResultsSortExpression) = "EIDSSSessionID"
            ViewState(VSS.SearchResultsPaginationSet) = 1

            gvVSSSearchResults.PageSize = ConfigurationManager.AppSettings("PageSize")

            ddlVSSFormSection.SelectedValue = FormSection.SearchForm
            ToggleDisplay(ddlVSSFormSection.SelectedValue)

            txtSearchEIDSSSessionID.Focus()

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub ShowHideSection(Optional _Section? As FormSectionShowHide = Nothing)

        If _Section Is Nothing Then _Section = ddlVSSFormSectionShowHide.SelectedValue

        Select Case _Section
            Case FormSectionShowHide.SearchTriangleBottom
                divSearchFields.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
                btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnSearchList.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

            Case FormSectionShowHide.SearchTriangleTop
                divSearchFields.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
                btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnSearchList.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

            Case FormSectionShowHide.VectorSummaryTriangleBottom
                divVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorSummary.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")

            Case FormSectionShowHide.VectorSummaryTriangleTop
                divVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnShowVectorSummary.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")

            Case FormSectionShowHide.VectorLocationTriangleBottom
                divVectorLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorLocation.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")

            Case FormSectionShowHide.VectorLocationTriangleTop
                divVectorLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnShowVectorLocation.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")

            Case FormSectionShowHide.VectorDetailedCollectionsTriangleBottom
                divVectorDetailedCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorDetailedCollection.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")

            Case FormSectionShowHide.VectorDetailedCollectionsTriangleTop
                divVectorDetailedCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnShowVectorDetailedCollection.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")

            Case FormSectionShowHide.VectorAggregateCollectionTriangleBottom
                divVectorAggregateCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorAggregateCollection.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")

            Case FormSectionShowHide.VectorAggregateCollectionTriangleTop
                divVectorAggregateCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnShowVectorAggregateCollection.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        End Select

    End Sub

    Private Sub ToggleDisplay(Optional _Section? As FormSection = Nothing)

        'divSearch includes divSearchResults and divSearchForm
        'divSearchForm includes divSearchFields
        'divVector for Vector details
        'divDetailedCollection for detailed collection
        'divAggregateCollection for Aggregate collection

        If _Section Is Nothing Then _Section = ddlVSSFormSectionShowHide.SelectedValue

        divSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        divSearchForm.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        divSearchFields.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

        btnShowSearchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        divSearchResults.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

        btnPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        btnSearchCancel.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        btnSearchList.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        btnCreateVectorSurveillance.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

        divVector.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        divCreateVectorSurveillance.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        divLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        divDetailedCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        divAggregateCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

        'These section manage show/hide and detail of vector sumamry
        divVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        btnShowVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

        divDetailedCollectionDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

        divAggregateCollectionDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

        Select Case _Section
            Case FormSection.SearchForm
                'Search fields 
                divSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                divSearchForm.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                divSearchFields.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                btnSearchCancel.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnSearchList.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnCreateVectorSurveillance.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

            Case FormSection.SearchResults
                'Search Results
                divSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                divSearchForm.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                divSearchResults.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowSearchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")

                'TODO MD:   un-comment this line after the design to fetch records are fixed.
                '           Currently the design limits 100 records per DB call and hence the print option cannot report more than 100 records
                'btnPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                btnSearchCancel.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnCreateVectorSurveillance.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

            Case FormSection.Vector
                divVector.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                divLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                btnShowVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorDetailedCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorDetailedCollection.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
                btnShowVectorAggregateCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorAggregateCollection.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")

                divCreateVectorSurveillance.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnVectorSummaryCancel.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                'btnReturnToSearchFromVector.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnVectorSummarySubmit.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                If ddlVSSFormAction.SelectedValue.EqualsAny({FormAction.VSSAddFromSearch, FormAction.VSSAddFromSearchResults}) Then

                    'For new VSS, Expand the summary section
                    divVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                    btnShowVectorSummary.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")

                    btnShowVectorLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                    btnShowVectorLocation.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")

                    'Detailed collection is hidden until a VSS record is created
                    divDetailedCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

                    'Aggregate collection is hidden until a VSS record is created
                    divAggregateCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

                    'Hide delete and Print
                    btnVectorSummaryDelete.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                    btnVectorSummaryPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

                Else

                    btnShowVectorSummary.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")

                    btnShowVectorLocation.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                    btnShowVectorLocation.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")

                    divDetailedCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                    divAggregateCollection.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                    btnVectorSummaryPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                    btnVectorSummaryDelete.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                End If

                'Exception list is already created when "Vector" section is displayed for the first tiem
                'ToggleVectorDisplay()

            Case FormSection.VectorDetailedCollectionDetail
                divVector.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorSummary.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
                divDetailedCollectionDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                'Exception list is already created when "Vector" section is displayed for the first tiem
                ToggleFormView(divVectorSummarySection)

            Case FormSection.VectorAggregateCollectionDetail
                divVector.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorSummary.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnShowVectorSummary.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
                divAggregateCollectionDetail.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

                'Exception list is already created when "Vector" section is displayed for the first tiem
                ToggleFormView(divVectorSummarySection)

        End Select

    End Sub

    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim _WhoCalledThis As String = DirectCast(sender, LinkButton).ID
        Dim _ForControlName As String = ""
        Dim _GVControl As GridView = Nothing
        Dim _PaginationSet As String = ""
        Dim _RecordCount As Integer = 0

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

        Select Case _WhoCalledThis
            Case "lnkSearchResultsPage"
                _ForControlName = VSS.SearchResults
                _GVControl = gvVSSSearchResults
                _PaginationSet = VSS.SearchResultsPaginationSet

                lblSearchResultsPageNumber.Text = pageIndex.ToString()
                _RecordCount = lblSearchResultsNumberOfRecords.Text
            Case "lnkDetailedCollectionsPage"
                _ForControlName = VSS.DetailedCollections
                _GVControl = gvDetailedCollections
                _PaginationSet = VSS.DetailedCollectionsPaginationSet

                lblDetailedCollectionsPageNumber.Text = pageIndex.ToString()
                _RecordCount = lblDetailedCollectionsNumberOfRecords.Text
            Case "lnkAggregateCollectionsPage"
                _ForControlName = VSS.AggregateCollections
                _GVControl = gvAggregateCollections
                _PaginationSet = VSS.AggregateCollectionsPaginationSet

                lblAggregateCollectionsPageNumber.Text = pageIndex.ToString()
                _RecordCount = lblAggregateCollectionsNumberOfRecords.Text
            Case "lnkDetailedCollectionsSamplePage"
                _ForControlName = VSS.DetailedCollectionsSample
                _GVControl = gvDetailedCollectionsSample
                _PaginationSet = VSS.DetailedCollectionsSamplePaginationSet

                lblDetailedCollectionsPageNumber.Text = pageIndex.ToString()
                _RecordCount = lblDetailedCollectionsNumberOfRecords.Text
            Case "lnkDetailedCollectionsFieldTestsPage"
                _ForControlName = VSS.DetailedCollectionsFieldTests
                _GVControl = gvDetailedCollectionsFieldTests
                _PaginationSet = VSS.DetailedCollectionsFieldTestsPaginationSet

                lblDetailedCollectionsFieldTestsPageNumber.Text = pageIndex.ToString()
                _RecordCount = lblDetailedCollectionsFieldTestsNumberOfRecords.Text
            Case "lnkDetailedCollectionsLabTestsPage"
                _ForControlName = VSS.DetailedCollectionsLabTests
                _GVControl = gvDetailedCollectionsLabTests
                _PaginationSet = VSS.DetailedCollectionsLabTestsPaginationSet

                lblDetailedCollectionsLabTestsPageNumber.Text = pageIndex.ToString()
                _RecordCount = lblDetailedCollectionsLabTestsNumberOfRecords.Text
            Case "lnkAggregateCollectionsDiseasesPage"
                _ForControlName = VSS.AggregateCollectionsDiseases
                _GVControl = gvAggregateCollectionDiseases
                _PaginationSet = VSS.AggregateCollectionsDiseasesPaginationSet

                lblAggregateCollectionDiseasesPageNumber.Text = pageIndex.ToString()
                _RecordCount = lblAggregateCollectionDiseasesNumberOfRecords.Text
        End Select

        Dim paginationSetNumber As Integer
        paginationSetNumber = Math.Ceiling(pageIndex / _GVControl.PageSize)

        If Not ViewState(_PaginationSet) = paginationSetNumber Then

            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    _GVControl.PageIndex = _GVControl.PageSize - 1
                Case PagingConstants.NextButtonText
                    _GVControl.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    _GVControl.PageIndex = 0
                Case PagingConstants.LastButtonText
                    _GVControl.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        _GVControl.PageIndex = _GVControl.PageSize - 1
                    Else
                        _GVControl.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillVSSList(pageIndex, paginationSetNumber, _ForControlName)

        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                _GVControl.PageIndex = _GVControl.PageSize - 1
            Else
                _GVControl.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If

            BindGridView(_ForControlName)
            FillPager(_RecordCount, pageIndex, _ForControlName)

        End If

    End Sub

    Private Sub FillPager(ByVal recordCount As Integer, ByVal currentPage As Integer, ByVal ForControlName As String)

        Dim _PageRepeater As Repeater = Nothing
        Dim _PageDiv As HtmlGenericControl = Nothing

        Select Case ForControlName
            Case VSS.SearchResults
                _PageRepeater = rptSearchResultsPager
                _PageDiv = divSearchResultsPager
            Case VSS.DetailedCollections
                _PageRepeater = rptDetailedCollectionsPager
                _PageDiv = divDetailedCollectionsPager
            Case VSS.AggregateCollections
                _PageRepeater = rptAggregateCollectionsPager
                _PageDiv = divAggregateCollectionsPager
            Case VSS.DetailedCollectionsSample
                _PageRepeater = rptDetailedCollectionsSamplePager
                _PageDiv = divDetailedCollectionsSamplePager
            Case VSS.DetailedCollectionsFieldTests
                _PageRepeater = rptDetailedCollectionsFieldTestsPager
                _PageDiv = divDetailedCollectionsFieldTestsPager
            Case VSS.DetailedCollectionsLabTests
                _PageRepeater = rptDetailedCollectionsLabTestsPager
                _PageDiv = divDetailedCollectionsLabTestsPager
            Case VSS.AggregateCollectionsDiseases
                _PageRepeater = rptAggregateCollectionDetailDiseasesPager
                _PageDiv = divAggregateCollectionDiseasePager
        End Select

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then

            'Calculate the start and end index of pages to be displayed.
            Dim dblPageCount As Double = recordCount / Convert.ToDecimal(10)
            Dim pageCount As Integer = Math.Ceiling(dblPageCount)
            startIndex = If(currentPage > 1 AndAlso currentPage + pagerSpan - 1 < pagerSpan, currentPage, 1)
            endIndex = If(pageCount > pagerSpan, pagerSpan, pageCount)
            If currentPage > pagerSpan Mod 2 Then
                If currentPage = 2 Then
                    endIndex = 5
                Else
                    endIndex = currentPage + 2
                End If
            Else
                endIndex = (pagerSpan - currentPage) + 1
            End If

            If endIndex - (pagerSpan - 1) > startIndex Then
                startIndex = endIndex - (pagerSpan - 1)
            End If

            If endIndex > pageCount Then
                endIndex = pageCount
                startIndex = If(((endIndex - pagerSpan) + 1) > 0, (endIndex - pagerSpan) + 1, 1)
            End If

            'Add the First Page Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If

            _PageRepeater.DataSource = pages
            _PageRepeater.DataBind()
            _PageDiv.Visible = True
        Else
            _PageDiv.Visible = False
        End If

    End Sub

    Private Sub GridDatabound(ByVal gvRow As GridViewRow, ByVal ForControlName As String)

        Dim SortDirection As String = ""
        Select Case ForControlName
            Case VSS.SearchResults
                SortDirection = VSS.SearchResultsSortDirection
            Case VSS.DetailedCollections
                SortDirection = VSS.DetailedCollectionsSortDirection
            Case VSS.AggregateCollections
                SortDirection = VSS.AggregateCollectionsSortDirection
            Case VSS.DetailedCollectionsSample
                SortDirection = VSS.DetailedCollectionsSampleSortDirection
            Case VSS.DetailedCollectionsFieldTests
                SortDirection = VSS.DetailedCollectionsFieldTestsSortDirection
            Case VSS.DetailedCollectionsLabTests
                SortDirection = VSS.DetailedCollectionsLabTestsSortDirection
            Case VSS.AggregateCollectionsDiseases
                SortDirection = VSS.AggregateCollectionsDiseasesSortDirection
        End Select

        Dim _cellIndex As Integer = -1
        _cellIndex = GetColumnIndex(ForControlName)

        If (_cellIndex > -1) Then
            If ViewState(SortDirection) = SortConstants.Ascending Then
                gvRow.Cells(_cellIndex).CssClass = "glyphicon glyphicon-triangle-top"
            Else
                gvRow.Cells(_cellIndex).CssClass = "glyphicon glyphicon-triangle-bottom"
            End If
        End If

    End Sub

    Private Sub GridDataSort(ByVal SortColumn As String, ByVal ForControlName As String)

        Try
            Dim _SortExpression As String = ""
            Dim _SortDirection As String = ""

            Select Case ForControlName
                Case VSS.SearchResults
                    _SortExpression = VSS.SearchResultsSortExpression
                    _SortDirection = VSS.SearchResultsSortDirection
                Case VSS.DetailedCollections
                    _SortExpression = VSS.DetailedCollectionsSortExpression
                    _SortDirection = VSS.DetailedCollectionsSortDirection
                Case VSS.AggregateCollections
                    _SortExpression = VSS.AggregateCollectionsSortExpression
                    _SortDirection = VSS.AggregateCollectionsSortDirection
                Case VSS.DetailedCollectionsSample
                    _SortExpression = VSS.DetailedCollectionsSampleSortExpression
                    _SortDirection = VSS.DetailedCollectionsSampleSortDirection
                Case VSS.DetailedCollectionsFieldTests
                    _SortExpression = VSS.DetailedCollectionsFieldTestsSortExpression
                    _SortDirection = VSS.DetailedCollectionsFieldTestsSortDirection
                Case VSS.DetailedCollectionsLabTests
                    _SortExpression = VSS.DetailedCollectionsLabTestsSortExpression
                    _SortDirection = VSS.DetailedCollectionsLabTestsSortDirection
                Case VSS.AggregateCollectionsDiseases
                    _SortExpression = VSS.AggregateCollectionsDiseasesSortExpression
                    _SortDirection = VSS.AggregateCollectionsDiseasesSortDirection
            End Select

            ViewState(_SortDirection) = IIf(ViewState(_SortDirection) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(_SortExpression) = SortColumn

            BindGridView(ForControlName)

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        userSettingsFile = CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
        Dim dsUserSettings As DataSet = ReadSearchCriteriaXML(userSettingsFile)
        If dsUserSettings.CheckDataSet() Then
            hdfidfUserID.Value = dsUserSettings.Tables(0).Rows(0).Item("hdfidfUserID") & ""
        End If

    End Sub

    Private Sub btnCancelModal_Click(sender As Object, e As EventArgs) Handles btnCancelModal.Click

        Select Case ddlVSSFormSection.SelectedValue
            Case FormSection.SearchForm

                Response.Redirect(ViewState("Caller"))

            Case FormSection.SearchResults

                ddlVSSFormSection.SelectedValue = FormSection.SearchForm

                'Set the cancel modal text
                SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Search.Text")})

                ToggleDisplay(ddlVSSFormSection.SelectedValue)

            Case FormSection.Vector

                Select Case ddlVSSFormAction.SelectedValue
                    Case FormAction.VSSAddFromSearch
                        ddlVSSFormSection.SelectedValue = FormSection.SearchForm
                        'Set the cancel modal text
                        SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Search.Text")})
                    Case FormAction.VSSAddFromSearchResults, FormAction.VSSEdit
                        ddlVSSFormSection.SelectedValue = FormSection.SearchResults
                        'Set the cancel modal text
                        SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Search_Results.Text")})
                End Select

                ToggleDisplay(ddlVSSFormSection.SelectedValue)

            Case FormSection.VectorDetailedCollectionDetail, FormSection.VectorAggregateCollectionDetail

                ddlVSSFormSection.SelectedValue = FormSection.Vector
                ddlVSSFormAction.SelectedValue = FormAction.VSSEdit

                'Set the cancel modal text
                SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Vector_Surveillance_Summary.Text")})

                ToggleDisplay(ddlVSSFormSection.SelectedValue)

        End Select

    End Sub

    Private Sub btnConfirmDeleteModal_Click(sender As Object, e As EventArgs) Handles btnConfirmDeleteModal.Click

        Select Case ddlVSSFormAction.SelectedValue
            Case FormAction.VSSDelete

                If (gvDetailedCollections.Rows.Count > 0 Or gvAggregateCollections.Rows.Count > 0 Or txtidfOutbreak.Text.ToInt64() > 0) Then

                    ddlVSSFormSection.SelectedValue = FormSection.Vector
                    ddlVSSFormAction.SelectedValue = FormAction.VSSEdit
                    SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Vector_Surveillance_Summary.Text")})

                    lblErr.InnerText = GetLocalResourceObject("lbl_Page_Delete.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)
                Else
                    If VectorAPIService Is Nothing Then VectorAPIService = New VectorServiceClient()
                    ' Dim retVal = VectorAPIService.VectorSurveillanceSessionDeleteDetail(ViewState(VSS.VSSSessionID)).Result

                    'lblSuccess.InnerText = GetLocalResourceObject("lbl_Page_Delete_Success.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_SUCCESS_SCRIPT, True)

                    ddlVSSFormSection.SelectedValue = FormSection.SearchResults
                    ddlVSSFormAction.SelectedValue = FormAction.VSSSelect

                    'Set the cancel modal text
                    SetModalText(ModalType.Cancel, {GetLocalResourceObject("val_Search_Results.Text")})
                    ToggleDisplay(ddlVSSFormSection.SelectedValue)
                End If

            Case FormAction.VSSDetailedCollectionDelete

                If (gvDetailedCollectionsSample.Rows.Count > 0 Or gvDetailedCollectionsFieldTests.Rows.Count > 0 Or gvDetailedCollectionsLabTests.Rows.Count > 0) Then
                    lblErr.InnerText = GetLocalResourceObject("lbl_Page_Delete.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)
                Else
                    'TODO MD: Delete the Vector Detail Collection record

                End If

        End Select

    End Sub

    Private Sub SetModalText(ByVal ForModal As ModalType, ByVal aVal() As String)

        Dim sMsg As String
        Select Case ForModal
            Case ModalType.Cancel
                sMsg = GetLocalResourceObject("lbl_Cancel_Modal.Text")
                sMsg = String.Format(sMsg, aVal)
                lblCancelModalMsg.InnerText = sMsg
            Case ModalType.Delete
                sMsg = GetLocalResourceObject("lbl_Delete_Modal.Text")
                sMsg = String.Format(sMsg, aVal)
                lblDeleteModalMsg.InnerText = sMsg
            Case ModalType.AppError
        End Select

    End Sub

    Public Sub ToggleFormView(ByVal frm As Web.UI.Control, Optional ByVal _Enable As Boolean = False, Optional blnCreateExceptionList As Boolean = False)

        Try
            'Collection of control of given type are collected in this variable
            Dim allCtrl As New List(Of Control)
            Dim ExceptionCtrlList As List(Of String) = New List(Of String)

            If (frm Is divVector) Then

                If blnCreateExceptionList Then
                    With ExceptionCtrlList
                        '.Add("btnReturnToSearchFromVector")
                        .Add("btnVectorSummarySubmit")
                    End With
                Else
                    ExceptionCtrlList = ViewState("ExceptionCtrlList")
                End If

                'Special handling for HTML control
                btnVectorSummaryDelete.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, IIf(_Enable, "inline", "none"))

            End If

            'Disable TextBox
            'Loop through the collection and disable the control
            For Each txt As WebControls.TextBox In oCommon.FindCtrl(allCtrl, frm, GetType(WebControls.TextBox))
                If ((blnCreateExceptionList) And (Not txt.Enabled)) Then ExceptionCtrlList.Add(txt.ID)
                If (Not ExceptionCtrlList.Contains(txt.ID, StringComparer.CurrentCultureIgnoreCase)) Then txt.Enabled = _Enable
            Next

            'Disable CheckBox
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each chk As WebControls.CheckBox In oCommon.FindCtrl(allCtrl, frm, GetType(WebControls.CheckBox))
                If ((blnCreateExceptionList) And (Not chk.Enabled)) Then ExceptionCtrlList.Add(chk.ID)
                If (Not ExceptionCtrlList.Contains(chk.ID, StringComparer.CurrentCultureIgnoreCase)) Then chk.Enabled = _Enable
            Next

            'Disable DropDownList
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each ddl As WebControls.DropDownList In oCommon.FindCtrl(allCtrl, frm, GetType(WebControls.DropDownList))
                If ((blnCreateExceptionList) And (Not ddl.Enabled)) Then ExceptionCtrlList.Add(ddl.ID)
                If (Not ExceptionCtrlList.Contains(ddl.ID, StringComparer.CurrentCultureIgnoreCase)) Then ddl.Enabled = _Enable
            Next

            'Disable Button
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each btn As WebControls.Button In oCommon.FindCtrl(allCtrl, frm, GetType(WebControls.Button))
                If ((blnCreateExceptionList) And (Not btn.Enabled)) Then ExceptionCtrlList.Add(btn.ID)
                If (Not ExceptionCtrlList.Contains(btn.ID, StringComparer.CurrentCultureIgnoreCase)) Then btn.Enabled = _Enable
            Next

            'Hide RadioButton
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each rbtn As WebControls.RadioButton In oCommon.FindCtrl(allCtrl, frm, GetType(WebControls.RadioButton))
                If ((blnCreateExceptionList) And (Not rbtn.Enabled)) Then ExceptionCtrlList.Add(rbtn.ID)
                If (Not ExceptionCtrlList.Contains(rbtn.ID, StringComparer.CurrentCultureIgnoreCase)) Then rbtn.Enabled = _Enable
            Next

            'Diable RadioButtonList
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each rbtnlst As WebControls.RadioButtonList In oCommon.FindCtrl(allCtrl, frm, GetType(WebControls.RadioButtonList))
                If ((blnCreateExceptionList) And (Not rbtnlst.Enabled)) Then ExceptionCtrlList.Add(rbtnlst.ID)
                If (Not ExceptionCtrlList.Contains(rbtnlst.ID, StringComparer.CurrentCultureIgnoreCase)) Then rbtnlst.Enabled = _Enable
            Next

            'Diable Grid control
            'Loop through the collection and disable the control
            allCtrl.Clear()
            For Each gvlst As WebControls.GridView In oCommon.FindCtrl(allCtrl, frm, GetType(WebControls.GridView))
                If ((blnCreateExceptionList) And (Not gvlst.Enabled)) Then ExceptionCtrlList.Add(gvlst.ID)
                If (Not ExceptionCtrlList.Contains(gvlst.ID, StringComparer.CurrentCultureIgnoreCase)) Then gvlst.Enabled = _Enable
            Next

            'EIDSS Controls

            'EIDSSControlLibrary.DropDownList control
            allCtrl.Clear()
            For Each ddl As EIDSSControlLibrary.DropDownList In oCommon.FindCtrl(allCtrl, frm, GetType(EIDSSControlLibrary.DropDownList))
                If ((blnCreateExceptionList) And (Not ddl.Enabled)) Then ExceptionCtrlList.Add(ddl.ID)
                If (Not ExceptionCtrlList.Contains(ddl.ID) = -1) Then ddl.Enabled = _Enable
            Next

            'EIDSSControlLibrary.NumericSpinner control
            allCtrl.Clear()
            For Each txt As EIDSSControlLibrary.NumericSpinner In oCommon.FindCtrl(allCtrl, frm, GetType(EIDSSControlLibrary.NumericSpinner))
                If ((blnCreateExceptionList) And (Not txt.Enabled)) Then ExceptionCtrlList.Add(txt.ID)
                If (Not ExceptionCtrlList.Contains(txt.ID) = -1) Then txt.Enabled = _Enable
            Next

            'eidss:CalendarInput control
            allCtrl.Clear()
            For Each txt As EIDSSControlLibrary.CalendarInput In oCommon.FindCtrl(allCtrl, frm, GetType(EIDSSControlLibrary.CalendarInput))
                If ((blnCreateExceptionList) And (Not txt.Enabled)) Then ExceptionCtrlList.Add(txt.ID)
                If (Not ExceptionCtrlList.Contains(txt.ID) = -1) Then txt.Enabled = _Enable
            Next

            If blnCreateExceptionList Then ViewState("ExceptionCtrlList") = ExceptionCtrlList

        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Clear()

        End Try

    End Sub

    Private Sub ToggleLocationDisplay()

        Try

            Dim locCtrl As LocationUserControl = ucLocVD
            Dim LocTypeCtrl As RadioButtonList = rblidfLocation

            Select Case ddlVSSFormSection.SelectedValue
                Case FormSection.Vector
                    locCtrl = ucLocVD
                    LocTypeCtrl = rblidfLocation
                    divForeignAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                    divRelativeAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                    divLocationDesc.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                Case FormSection.VectorDetailedCollectionDetail
                    locCtrl = ucLocDC
                    LocTypeCtrl = rbldidfsGeoLocationType
                    divVSSDetailedCollectionForeignAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                    divVSSDetailedCollectionRelativeAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                    divVSSDetailedCollectionLocationDesc.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            End Select

            Dim ctrl As HtmlGenericControl
            With locCtrl
                Select Case LocTypeCtrl.SelectedValue
                    Case VSSLocation.National
                        .AdjustToRadiControls(False, False, True)
                    Case VSSLocation.ExactPoint

                        Select Case ddlVSSFormSection.SelectedValue
                            Case FormSection.Vector
                                divLocationDesc.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                            Case FormSection.VectorDetailedCollectionDetail
                                divVSSDetailedCollectionLocationDesc.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                        End Select

                        .AdjustToRadiControls(True, False, False)

                        'Hide street
                        ctrl = .FindControl("streetGroup")
                        ctrl.Attributes.Add("class", "hidden")

                        'Hide Postal Group
                        ctrl = .FindControl("postalGroup")
                        ctrl.Attributes.Add("class", "hidden")

                        'Hide Building/house/Apartment
                        ctrl = .FindControl("buildingHouseApartmentGroup")
                        ctrl.Attributes.Add("class", "hidden")

                        'Hide Elevation
                        .ShowElevation = False
                        .DataBind()

                    Case VSSLocation.RelativePoint

                        Select Case ddlVSSFormSection.SelectedValue
                            Case FormSection.Vector
                                divRelativeAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                                divLocationDesc.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                            Case FormSection.VectorDetailedCollectionDetail
                                divVSSDetailedCollectionRelativeAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                                divVSSDetailedCollectionLocationDesc.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                        End Select

                        .AdjustToRadiControls(False, True, False)
                        ctrl = .FindControl("coordinatesGroup")
                        ctrl.Attributes.Add("class", "col-md-6")

                        'Hide Map
                        .ShowElevation = False
                        .ShowMap = False
                        .DataBind()

                    Case VSSLocation.ForeignAddress
                        .AdjustToRadiControls(False, False, True)

                        Select Case ddlVSSFormSection.SelectedValue
                            Case FormSection.Vector
                                divForeignAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                            Case FormSection.VectorDetailedCollectionDetail
                                divVSSDetailedCollectionForeignAddress.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                        End Select

                    Case Else
                        .AdjustToRadiControls(False, False, False)
                End Select
            End With

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw

        End Try

    End Sub

    Private Sub PopulateForm(ByVal oFormSection As FormSection)

        Select Case oFormSection
            Case FormSection.Vector
                Dim VSSDetailList As List(Of VctsVssessionGetDetailModel) = CType(Session(VSS.VSSDetail), List(Of VctsVssessionGetDetailModel))
                Dim oRecord As VctsVssessionGetDetailModel = VSSDetailList.FirstOrDefault()

                With oRecord
                    ViewState(VSS.VSSSessionID) = .idfVectorSurveillanceSession
                    txtstrSessionID.Text = .strSessionID
                    txtstrFieldSessionID.Text = .strFieldSessionID
                    ddlidfsVectorSurveillanceStatus.SelectedValue = .idfsVectorSurveillanceStatus
                    txtdatStartDate.Text = .datStartDate
                    If IsDate(txtdatCloseDate.Text) Then txtdatCloseDate.Text = .datCloseDate
                    txtidfOutbreak.Text = .idfOutbreak
                    txtstrDescription.Text = .strDescription & ""
                    If Not (.intCollectionEffort.ToString().IsValueNullOrEmpty()) Then txtintCollectionEffort.Text = .intCollectionEffort
                    If Not (.idfsGeoLocationType.ToString().IsValueNullOrEmpty()) Then rblidfLocation.SelectedValue = .idfsGeoLocationType
                    If Not (.idfsCountry.ToString().IsValueNullOrEmpty()) Then ucLocVD.LocationCountryID = .idfsCountry
                    If Not (.idfsRegion.ToString().IsValueNullOrEmpty()) Then ucLocVD.LocationRegionID = .idfsRegion
                    If Not (.idfsRayon.ToString().IsValueNullOrEmpty()) Then ucLocVD.LocationRayonID = .idfsRayon
                    If Not (.idfsSettlement.ToString().IsValueNullOrEmpty()) Then ucLocVD.LocationSettlementID = .idfsSettlement
                    txtForeignAddressType.Text = .idfsGeoLocationType  'This is the actual foreign address
                    ucLocVD.LatitudeText = .dblLatitude & ""
                    ucLocVD.LongitudeText = .dblLongitude & ""

                    'TODO MD: Not part of colelction
                    'ddlGroundType.SelectedValue
                    'txtDistance.Text
                    '.dblDirection = txtDirection.Text

                    hdfidfGeoLocation.Value = .idfLocation

                End With

        End Select

    End Sub

#End Region

    Private Sub VectorSurveillanceSession_Error(sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then
            lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText")
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, PAGE_ERROR_SCRIPT, True)
            Exit Sub
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