Imports EIDSS
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports Newtonsoft
Imports System.Reflection
Imports EIDSS.EIDSS
Imports System.Linq


Public Class PersonRecordDeduplication
    Inherits System.Web.UI.Page

#Region "Global Values"

    Private Const SectionSearch As String = "Search"
    Private Const SectionPerson As String = "Person"

    Private Const HIDE_WARNING_MODAL As String = "hideWarningModal();"

    Private Const MODAL_KEY As String = "Modal"
    Private Const PAGE_KEY As String = "Page"

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"
    Private Const SET_ACTIVE_TAB_ITEM_SCRIPT As String = "setActiveTabItem();"
    Private Const TAB_CHANGED_EVENT As String = "TabChanged"
    Private Const HUMANADDRESSNUMBERFIELD As Int16 = 10
    Private Const HUMANALTADDRESSNUMBERFIELD As Int16 = 9
    Private Const EMPLOYERADDRESSNUMBERFIELD As Int16 = 9
    Private Const SCHOOLADDRESSNUMBERFIELD As Int16 = 8
    Private Const TextField As String = "Label"
    Private Const ValueField As String = "Value"
    Private Const SurvivorHumanMasterID As String = "SurvivorHumanMasterID"
    Private Const SupersededHumanMasterID As String = "SupersededHumanMasterID"
    Private Const InfoList As String = "InfoList"
    Private Const InfoList2 As String = "InfoList2"
    Private Const AddressList As String = "AddressList"
    Private Const AddressList2 As String = "AddressList2"
    Private Const EmpList As String = "EmpList"
    Private Const EmpList2 As String = "EmpList2"
    Private Const AddressList0 As String = "AddressList0"
    Private Const AddressList02 As String = "AddressList02"
    Private Const EmpList0 As String = "EmpList0"
    Private Const EmpList02 As String = "EmpList02"

    Private Const SURVIVOR_LIST_INFO As String = "SurvivorListInfo"
    Private Const SURVIVOR_LIST_ADDRESS As String = "SurvivorListAddress"
    Private Const SURVIVOR_LIST_EMP As String = "SurvivorListEmp"


    Public Event TabItemSelected(tab As String)

    Private Shared Log As log4net.ILog = log4net.LogManager.GetLogger(GetType(PersonRecordDeduplication))
    Private HumanAPIService As HumanServiceClient
    Private FarmAPIService As FarmServiceClient
    Private PersonClient As PersonServiceClient
    Private ReadOnly CrossCuttingAPIClient As CrossCuttingServiceClient
    Private OutbreakAPIService As OutbreakServiceClient

    Private SurvivorListInfo As New List(Of Field)
    Private SurvivorListAddress As New List(Of Field)
    Private SurvivorListEmp As New List(Of Field)

    Dim keyDict As New Dictionary(Of String, Integer) From {{"EIDSSPersonID", 0}, {"PersonalIDType", 1}, {"PersonalID", 2}, {"LastOrSurname", 3}, {"SecondName", 4}, {"FirstOrGivenName", 5},
            {"DateOfBirth", 6}, {"ReportedAge", 7}, {"GenderTypeID", 8}, {"CitizenshipTypeID", 9}, {"PassportNumber", 10}}

    Dim keyDict2 As New Dictionary(Of String, Integer) From {{"HumanidfsRegion", 0}, {"HumanidfsRayon", 1}, {"HumanidfsSettlement", 2}, {"HumanstrStreetName", 3}, {"HumanstrHouse", 4},
                    {"HumanstrBuilding", 5}, {"HumanstrApartment", 6}, {"HumanstrPostalCode", 7}, {"HumanstrLatitude", 8}, {"HumanstrLongitude", 9},
                    {"HumanGeoLocationID", 10}, {"HumanAltForeignAddressIndicator", 11},
                    {"HumanAltForeignAddressString", 12}, {"HumanAltidfsRegion", 13}, {"HumanAltidfsRayon", 14}, {"HumanAltidfsSettlement", 15}, {"HumanAltstrStreetName", 16}, {"HumanAltstrHouse", 17}, {"HumanAltstrBuilding", 18},
                    {"HumanAltstrApartment", 19}, {"HumanAltstrPostalCode", 20},
                    {"HumanAltidfsCountry", 21}, {"ContactPhoneCountryCode", 22}, {"ContactPhone", 23}, {"ContactPhoneTypeID", 24}, {"ContactPhone2CountryCode", 25}, {"ContactPhone2", 26}, {"ContactPhone2TypeID", 27}}

    Dim keyDict3 As New Dictionary(Of String, Integer) From {{"IsEmployedTypeID", 0}, {"OccupationTypeID", 1}, {"EmployerName", 2}, {"EmployedDateLastPresent", 3},
                    {"EmployerForeignAddressIndicator", 4},
                    {"EmployerForeignAddressString", 5}, {"EmployeridfsRegion", 6}, {"EmployeridfsRayon", 7}, {"EmployeridfsSettlement", 8}, {"EmployerstrStreetName", 9}, {"EmployerstrHouse", 10}, {"EmployerstrBuilding", 11},
                    {"EmployerstrApartment", 12}, {"EmployerstrPostalCode", 13}, {"EmployeridfsCountry", 14}, {"EmployerPhone", 15}, {"IsStudentTypeID", 16}, {"SchoolName", 17}, {"SchoolDateLastAttended", 18},
                    {"SchoolForeignAddressIndicator", 19}, {"SchoolForeignAddressString", 20},
                    {"SchoolidfsRegion", 21}, {"SchoolidfsRayon", 22}, {"SchoolidfsSettlement", 23}, {"SchoolstrStreetName", 24}, {"SchoolstrHouse", 25}, {"SchoolstrBuilding", 26}, {"SchoolstrApartment", 27},
                    {"SchoolstrPostalCode", 28}, {"SchoolPhone", 29}}

    Dim labelDict As New Dictionary(Of Integer, String) From {{0, "Person_ID"}, {1, "Personal_ID_Type"}, {2, "Personal_ID"}, {3, "Last_Name"}, {4, "Middle_Name"},
                    {5, "First_Name"}, {6, "Date_Of_Birth"}, {7, "Age"}, {8, "Gender"}, {9, "Citizenship"}, {10, "Passport_Number"}}

    Dim labelDict2 As New Dictionary(Of Integer, String) From {{0, "Region"}, {1, "Rayon"}, {2, "Settlement"}, {3, "Street"}, {4, "House"},
                    {5, "Building"}, {6, "Apartment/Unit"}, {7, "PostalCode"}, {8, "Latitude"}, {9, "Longitude"}, {10, "Location"},
                    {11, "AnotherAddress"},
                    {12, "ForeignAddress"}, {13, "Region"}, {14, "Rayon"}, {15, "Settlement"},
                    {16, "Street"}, {17, "House"}, {18, "Building"}, {19, "Apartment/Unit"}, {20, "PostalCode"},
                    {21, "Country"}, {22, "CountryCode"}, {23, "PhoneNumber"}, {24, "PhoneType"},
                    {25, "CountryCode"}, {26, "PhoneNumber"}, {27, "PhoneType"}}

    Dim labelDict3 As New Dictionary(Of Integer, String) From {{0, "Employed"}, {1, "Occupation"}, {2, "EmployerName"},
                    {3, "EmployedDate"}, {4, "EmployerForeignAddress"},
                    {5, "ForeignAddress"}, {6, "Region"}, {7, "Rayon"}, {8, "Settlement"}, {9, "Street"}, {10, "House"}, {11, "Building"},
                    {12, "Apartment/Unit"}, {13, "PostalCode"}, {14, "Country"}, {15, "PhoneNumber"}, {16, "CurrentlyInSchool"},
                    {17, "SchoolName"}, {18, "SchoolDate"}, {19, "SchoolAddress"}, {20, "ForeignAddress"},
                    {21, "Region"}, {22, "Rayon"}, {23, "Settlement"}, {24, "Street"}, {25, "House"}, {26, "Building"}, {27, "Apartment/Unit"},
                    {28, "PostalCode"}, {29, "PhoneNumber"}}

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                CheckCallerHandler()
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")

                Select Case eventArg.ToString()
                    Case TAB_CHANGED_EVENT
                        RaiseEvent TabItemSelected(eventSource)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    '**********************************************************************************************
    '* Sub-routine: CheckCallerHandler
    '*
    '* Description: Handler for checking if calls from other web pages were made.
    '* 
    '**********************************************************************************************
    Private Sub CheckCallerHandler()

        ExtractViewStateSession()

        '******************************************************************************************
        '* Add additional modules to the equals any as needed for selecting a person.
        '******************************************************************************************
        Select Case ViewState(CALLER).ToString()
            Case CallerPages.Dashboard, CallerPages.Person
                ucSearchPersonInformation.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.View)
            Case Else
                ucSearchPersonInformation.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.View)
        End Select

        divDeduplicationDetails.Visible = False
        divSurvivorReview.Visible = False
    End Sub
    ''' <summary>
    ''' Fill and bind the selected tab.  For performance purposes, the application does not 
    ''' initially load all 3 tabs.  It is more efficient to load seperately as needed by the 
    ''' user.
    ''' </summary>
    ''' <param name="tab"></param>
    Protected Sub TabItemSelected_Event(tab As String) Handles Me.TabItemSelected
        Try
            hdfCurrentTab.Value = tab.Replace("lnk", "")

            Select Case hdfCurrentTab.Value
                Case PersonDeduplicationTabConstants.Info
                    btnNextSection.Visible = True
                Case PersonDeduplicationTabConstants.Address
                    btnNextSection.Visible = True
                Case PersonDeduplicationTabConstants.Emp
                    btnNextSection.Visible = False
            End Select

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub
#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = GetViewState(True)

            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        PrepViewStates()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub PrepViewStates()

        'Used to correct any "nothing" values for known Viewstate variables
        'Add your new View State variables here
        Dim lKeys As List(Of String) = New List(Of String) From {CALLER, CALLER_KEY}

        For Each sKey As String In lKeys
            If (ViewState(sKey) Is Nothing) Then
                ViewState(sKey) = String.Empty
            End If
        Next

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="section"></param>
    Private Sub ToggleVisibility(ByVal section As String)

        ucSearchPersonInformation.Visible = section.Equals(SectionSearch)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        warningHeading.InnerText = Resources.WarningMessages.Warning_Message_Alert
        warningSubTitle.InnerText = String.Empty
        hdfWarningMessageType.Value = messageType.ToString()

        Select Case messageType
            Case MessageType.CancelConfirm
                warningBody.InnerText = Resources.WarningMessages.Cancel_Confirm
            Case MessageType.CancelSearchConfirm
                warningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case MessageType.CancelFormConfirm
                warningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CannotGetValidatorSection
                warningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case MessageType.UnhandledException
                warningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case MessageType.SearchCriteriaRequired
                warningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case messageType.ConfirmMerge
                warningBody.InnerText = Resources.WarningMessages.Confirm_Merge_Record
            Case MessageType.FieldValuePairFoundNoSelection
                warningBody.InnerText = Resources.WarningMessages.Field_Value_Pair_Found_No_Selection
        End Select

        If isConfirm Then
            divWarningYesNoContainer.Visible = True
            divWarningOKContainer.Visible = False
        Else
            divWarningOKContainer.Visible = True
            divWarningYesNoContainer.Visible = False
        End If

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divWarningModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowErrorMessage(messageType As MessageType, Optional message As String = Nothing)

        hdgError.InnerText = Resources.WarningMessages.Error_Message_Text
        errorSubTitle.InnerText = String.Empty

        Select Case messageType
            Case MessageType.UnhandledException
                divErrorBody.InnerText = Resources.WarningMessages.Unhandled_Exception
        End Select

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divErrorModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType, Optional message As String = Nothing)

        Select Case messageType
            Case MessageType.SaveSuccess
                lblSuccessMessage.InnerText = message
        End Select

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Sender"></param>
    ''' <param name="e"></param>
    Private Sub Page_Error(Sender As Object, e As EventArgs) Handles Me.Error

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then
            ShowWarningMessage(messageType:=MessageType.UnhandledException, isConfirm:=False)
        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & [GetType].Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()

    End Sub

    Protected Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            Select Case hdfWarningMessageType.Value.ToString()
                Case MessageType.FieldValuePairFoundNoSelection.ToString()
                    upPerson.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, HIDE_WARNING_MODAL, True)
                Case MessageType.ConfirmMerge.ToString()
                    upPerson.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, HIDE_WARNING_MODAL, True)
                    DeduplicateRecords()
                Case Else
                    Response.Redirect(GetURL(CallerPages.DashboardURL), False)
                    Context.ApplicationInstance.CompleteRequest()
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnReturnToPersonRecord_Click(sender As Object, e As EventArgs) Handles btnReturnToPersonRecord.Click
        ReturnToPersonRecordDeduplication()
    End Sub

    Protected Sub ReturnToPersonRecordDeduplication()
        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('hide');});", True)

        'upPerson.Update()
        'divDeduplicationDetails.Visible = False
        'ucSearchPersonInformation.Visible = True
        'divSurvivorReview.Visible = False
        Response.Redirect(GetURL(CallerPages.PersonRecordDeduplicationURL), False)
        Context.ApplicationInstance.CompleteRequest()

    End Sub
#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchPerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchPersonInformation.ShowWarningModal

        upPerson.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub DeduplicatePerson(humanID As Long, humanID2 As Long) Handles ucSearchPersonInformation.DeduplicatePerson
        upPerson.Update()
        divDeduplicationDetails.Visible = True
        ucSearchPersonInformation.Visible = False
        divSurvivorReview.Visible = False

        hdfCurrentTab.Value = PersonDeduplicationTabConstants.Info
        FillDeduplicationDetails(humanID, humanID2)

        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    ''' <param name="humanID2"></param>
    Private Sub FillDeduplicationDetails(humanID As Long, humanID2 As Long)
        Try
            hdfPersonHumanMasterID.Value = humanID.ToString
            hdfPersonHumanMasterID2.Value = humanID2.ToString

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list As List(Of HumHumanMasterGetDetailModel) = HumanAPIService.GetHumanMasterDetailAsync(GetCurrentLanguage(), humanID).Result
            Dim list2 As List(Of HumHumanMasterGetDetailModel) = HumanAPIService.GetHumanMasterDetailAsync(GetCurrentLanguage(), humanID2).Result

            Dim record As HumHumanMasterGetDetailModel = list.FirstOrDefault()
            Dim record2 As HumHumanMasterGetDetailModel = list2.FirstOrDefault()

            Dim kvInfo As New List(Of KeyValuePair(Of String, String))
            Dim kvInfo2 As New List(Of KeyValuePair(Of String, String))

            Dim type As Type = record.GetType()
            Dim props() As PropertyInfo = type.GetProperties()

            Dim type2 = record2.GetType()
            Dim props2() As PropertyInfo = type2.GetProperties()

            Dim value As String = String.Empty

            Dim itemList As New List(Of Field)
            Dim itemList2 As New List(Of Field)

            Dim itemListAddress As New List(Of Field)
            Dim itemListAddress2 As New List(Of Field)

            Dim itemListEmp As New List(Of Field)
            Dim itemListEmp2 As New List(Of Field)

            For index = 0 To props.Count - 1
                If IsInTabInfo(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemList, itemList2, keyDict, labelDict)
                End If
                If IsInTabAddress(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListAddress, itemListAddress2, keyDict2, labelDict2)
                End If
                If IsInTabEmp(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListEmp, itemListEmp2, keyDict3, labelDict3)
                End If
            Next

            'Bind Tab Person Information 
            Session(InfoList) = itemList.OrderBy(Function(s) s.Index).ToList()
            Session(InfoList2) = itemList2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList1.DataSource = itemList.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList1.DataTextField = TextField
            CheckBoxList1.DataValueField = ValueField

            CheckBoxList2.DataSource = itemList2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList2.DataTextField = TextField
            CheckBoxList2.DataValueField = ValueField

            CheckBoxList1.DataBind()
            CheckBoxList2.DataBind()

            For i As Integer = 0 To CheckBoxList1.Items.Count - 1
                If itemList.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList1.Items(i).Selected = True
                    CheckBoxList1.Items(i).Enabled = False
                    CheckBoxList2.Items(i).Selected = True
                    CheckBoxList2.Items(i).Enabled = False
                End If
            Next

            'Bind Tab Person Current Residence 
            Session(AddressList0) = itemListAddress.OrderBy(Function(s) s.Index).ToList().ConvertAll(Function(x) New Field(x))
            Session(AddressList02) = itemListAddress2.OrderBy(Function(s) s.Index).ToList().ConvertAll(Function(x) New Field(x))

            Session(AddressList) = itemListAddress.OrderBy(Function(s) s.Index).ToList()
            Session(AddressList2) = itemListAddress2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList3.DataSource = itemListAddress.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList3.DataTextField = TextField
            CheckBoxList3.DataValueField = ValueField

            CheckBoxList4.DataSource = itemListAddress2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList4.DataTextField = TextField
            CheckBoxList4.DataValueField = ValueField

            CheckBoxList3.DataBind()
            CheckBoxList4.DataBind()

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If itemListAddress.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList3.Items(i).Selected = True
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Selected = True
                    CheckBoxList4.Items(i).Enabled = False
                ElseIf IsInHumanAddressGroup(itemListAddress.OrderBy(Function(s) s.Index).ToList().Item(i).Key) = True Then
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Enabled = False
                ElseIf IsInHumanAltAddressGroup(itemListAddress.OrderBy(Function(s) s.Index).ToList().Item(i).Key) = True Then
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Enabled = False
                End If
            Next

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If CType(Session(AddressList), List(Of Field))(i).Key = PersonDeduplicationAddressConstants.HumanidfsRegion And CheckBoxList3.Items(i).Selected = True Then
                    If GroupAllChecked(i, HUMANADDRESSNUMBERFIELD, CheckBoxList3) = False Then
                        CType(Session(AddressList), List(Of Field))(i).Checked = False
                        CType(Session(AddressList2), List(Of Field))(i).Checked = False
                        CheckBoxList3.Items(i).Selected = False
                        CheckBoxList3.Items(i).Enabled = True
                        CheckBoxList4.Items(i).Selected = False
                        CheckBoxList4.Items(i).Enabled = True
                    End If
                ElseIf CType(Session(AddressList), List(Of Field))(i).Key = PersonDeduplicationAddressConstants.HumanAltidfsRegion And CheckBoxList3.Items(i).Selected = True Then
                    If GroupAllChecked(i, HUMANALTADDRESSNUMBERFIELD, CheckBoxList3) = False Then
                        CType(Session(AddressList), List(Of Field))(i).Checked = False
                        CType(Session(AddressList2), List(Of Field))(i).Checked = False
                        CheckBoxList3.Items(i).Selected = False
                        CheckBoxList3.Items(i).Enabled = True
                        CheckBoxList4.Items(i).Selected = False
                        CheckBoxList4.Items(i).Enabled = True
                    End If
                End If
            Next

            'Bind Tab Person Employment/School Information 
            Session(EmpList0) = itemListEmp.OrderBy(Function(s) s.Index).ToList().ConvertAll(Function(x) New Field(x))
            Session(EmpList02) = itemListEmp2.OrderBy(Function(s) s.Index).ToList().ConvertAll(Function(x) New Field(x))

            Session(EmpList) = itemListEmp.OrderBy(Function(s) s.Index).ToList()
            Session(EmpList2) = itemListEmp2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList5.DataSource = itemListEmp.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList5.DataTextField = TextField
            CheckBoxList5.DataValueField = ValueField

            CheckBoxList6.DataSource = itemListEmp2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList6.DataTextField = TextField
            CheckBoxList6.DataValueField = ValueField

            CheckBoxList5.DataBind()
            CheckBoxList6.DataBind()

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If itemListEmp.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList5.Items(i).Selected = True
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Selected = True
                    CheckBoxList6.Items(i).Enabled = False
                ElseIf IsInEmployerAddressGroup(itemListEmp.OrderBy(Function(s) s.Index).ToList().Item(i).Key) = True Then
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Enabled = False
                ElseIf IsInSchoolAddressGroup(itemListEmp.OrderBy(Function(s) s.Index).ToList().Item(i).Key) = True Then
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Enabled = False
                End If
            Next

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If CType(Session(EmpList), List(Of Field))(i).Key = PersonDeduplicationEmpConstants.EmployeridfsRegion And CheckBoxList5.Items(i).Selected = True Then
                    If GroupAllChecked(i, EMPLOYERADDRESSNUMBERFIELD, CheckBoxList5) = False Then
                        CType(Session(EmpList), List(Of Field))(i).Checked = False
                        CType(Session(EmpList2), List(Of Field))(i).Checked = False
                        CheckBoxList5.Items(i).Selected = False
                        CheckBoxList5.Items(i).Enabled = True
                        CheckBoxList6.Items(i).Selected = False
                        CheckBoxList6.Items(i).Enabled = True
                    End If
                ElseIf CType(Session(EmpList), List(Of Field))(i).Key = PersonDeduplicationEmpConstants.SchoolidfsRegion And CheckBoxList5.Items(i).Selected = True Then
                    If GroupAllChecked(i, SCHOOLADDRESSNUMBERFIELD, CheckBoxList5) = False Then
                        CType(Session(EmpList), List(Of Field))(i).Checked = False
                        CType(Session(EmpList2), List(Of Field))(i).Checked = False
                        CheckBoxList5.Items(i).Selected = False
                        CheckBoxList5.Items(i).Enabled = True
                        CheckBoxList6.Items(i).Selected = False
                        CheckBoxList6.Items(i).Enabled = True
                    End If
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="index"></param>
    ''' <param name="length"></param>
    ''' <param name="control"></param>
    Private Function GroupAllChecked(ByVal index As Integer, ByVal length As Integer, control As CheckBoxList) As Boolean
        Try
            Dim AllChecked As Boolean = True

            For i As Integer = index + 1 To index + length - 1
                If control.Items(i).Selected = False Then
                    AllChecked = False
                    Return False
                End If
            Next
            Return True
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return False
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="list"></param>
    Private Sub BindCheckBoxList(control As CheckBoxList, ByRef list As List(Of Field))
        Try
            control.Items.Clear()

            control.DataSource = list
            control.DataTextField = TextField
            control.DataValueField = ValueField

            control.DataBind()

            For i As Integer = 0 To control.Items.Count - 1
                If list(i).Checked = True Then
                    If IsRegion(list(i).Key) = True Then
                        control.Items(i).Selected = True
                    Else
                        control.Items(i).Selected = True
                        control.Items(i).Enabled = False
                    End If
                ElseIf IsInEmployerAddressGroup(list(i).Key) = True Then
                    control.Items(i).Enabled = False
                ElseIf IsInSchoolAddressGroup(list(i).Key) = True Then
                    control.Items(i).Enabled = False
                ElseIf IsInHumanAddressGroup(list(i).Key) = True Then
                    control.Items(i).Enabled = False
                ElseIf IsInHumanAltAddressGroup(list(i).Key) = True Then
                    control.Items(i).Enabled = False
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabInfo(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationInfoConstants.EIDSSPersonID
                Return True
            Case PersonDeduplicationInfoConstants.PersonalIDType
                Return True
            Case PersonDeduplicationInfoConstants.PersonalID
                Return True
            Case PersonDeduplicationInfoConstants.LastOrSurname
                Return True
            Case PersonDeduplicationInfoConstants.SecondName
                Return True
            Case PersonDeduplicationInfoConstants.FirstOrGivenName
                Return True
            Case PersonDeduplicationInfoConstants.DateOfBirth
                Return True
            Case PersonDeduplicationInfoConstants.ReportedAge
                Return True
            Case PersonDeduplicationInfoConstants.GenderTypeID
                Return True
            Case PersonDeduplicationInfoConstants.CitizenshipTypeID
                Return True
            Case PersonDeduplicationInfoConstants.PassportNumber
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabEmp(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationEmpConstants.IsEmployedTypeID
                Return True
            Case PersonDeduplicationEmpConstants.OccupationTypeID
                Return True
            Case PersonDeduplicationEmpConstants.EmployerName
                Return True
            Case PersonDeduplicationEmpConstants.EmployedDateLastPresent
                Return True
            Case PersonDeduplicationEmpConstants.EmployerPhone
                Return True
            Case PersonDeduplicationEmpConstants.EmployerForeignAddressIndicator
                Return True
            Case PersonDeduplicationEmpConstants.EmployerForeignAddressString
                Return True
            Case PersonDeduplicationEmpConstants.EmployeridfsRegion
                Return True
            Case PersonDeduplicationEmpConstants.EmployeridfsRayon
                Return True
            Case PersonDeduplicationEmpConstants.EmployeridfsSettlement
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrStreetName
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrHouse
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrBuilding
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrApartment
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrPostalCode
                Return True
            Case PersonDeduplicationEmpConstants.EmployeridfsCountry
                Return True
            Case PersonDeduplicationEmpConstants.IsStudentTypeID
                Return True
            Case PersonDeduplicationEmpConstants.SchoolName
                Return True
            Case PersonDeduplicationEmpConstants.SchoolDateLastAttended
                Return True
            Case PersonDeduplicationEmpConstants.SchoolForeignAddressIndicator
                Return True
            Case PersonDeduplicationEmpConstants.SchoolForeignAddressString
                Return True
            Case PersonDeduplicationEmpConstants.SchoolidfsRegion
                Return True
            Case PersonDeduplicationEmpConstants.SchoolidfsRayon
                Return True
            Case PersonDeduplicationEmpConstants.SchoolidfsSettlement
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrStreetName
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrHouse
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrBuilding
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrApartment
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrPostalCode
                Return True
            Case PersonDeduplicationEmpConstants.SchoolidfsCountry
                Return True
            Case PersonDeduplicationEmpConstants.SchoolPhone
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabAddress(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationAddressConstants.HumanidfsRegion
                Return True
            Case PersonDeduplicationAddressConstants.HumanidfsRayon
                Return True
            Case PersonDeduplicationAddressConstants.HumanidfsSettlement
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrStreetName
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrHouse
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrBuilding
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrApartment
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrPostalCode
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrLatitude
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrLongitude
                Return True
            Case PersonDeduplicationAddressConstants.HumanGeoLocationID
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltForeignAddressIndicator
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltForeignAddressString
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltidfsRegion
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltidfsRayon
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltidfsSettlement
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrStreetName
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrHouse
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrBuilding
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrApartment
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrPostalCode
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltidfsCountry
                Return True
            Case PersonDeduplicationAddressConstants.ContactPhoneCountryCode
                Return True
            Case PersonDeduplicationAddressConstants.ContactPhone
                Return True
            Case PersonDeduplicationAddressConstants.ContactPhoneTypeID
                Return True
            Case PersonDeduplicationAddressConstants.ContactPhone2CountryCode
                Return True
            Case PersonDeduplicationAddressConstants.ContactPhone2
                Return True
            Case PersonDeduplicationAddressConstants.ContactPhone2TypeID
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="key"></param>
    ''' <param name="value"></param>
    ''' <param name="key2"></param>
    ''' <param name="value2"></param>
    ''' <param name="list"></param>
    ''' <param name="list2"></param>
    ''' <param name="keyDict"></param>
    ''' <param name="labelDict"></param>
    Sub FillTabList(key As String, value As String, key2 As String, value2 As String, ByRef list As List(Of Field), ByRef list2 As List(Of Field), ByRef keyDict As Dictionary(Of String, Integer), ByRef labelDict As Dictionary(Of Integer, String))
        Try
            Dim temp As String = String.Empty
            Dim temp2 As String = String.Empty
            Dim item As New Field
            Dim item2 As New Field

            If keyDict.ContainsKey(key) Then
                item.Index = keyDict.Item(key)
                item.Key = key
                item.Value = value
                item2.Index = keyDict.Item(key)
                item2.Key = key
                item2.Value = value2

                If value = value2 Or key = PersonDeduplicationInfoConstants.EIDSSPersonID Then
                    If value IsNot Nothing Then
                        temp = value.ToString
                        temp2 = value2.ToString
                    Else
                        temp = String.Empty
                    End If

                    item.Label = "<font style='color:#2C6187;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp + "</font>"
                    item2.Label = "<font style='color:#2C6187;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp2 + "</font>"
                    item.Checked = True
                    item2.Checked = True
                Else
                    If value IsNot Nothing Then
                        temp = value.ToString
                    Else
                        temp = String.Empty
                    End If

                    item.Label = "<font style='color:#9b1010;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp + "</font>"
                    item.Checked = False

                    If value2 IsNot Nothing Then
                        temp = value2.ToString
                    Else
                        temp = String.Empty
                    End If

                    item2.Label = "<font style='color:#9b1010;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp + "</font>"
                    item2.Checked = False
                End If

                list.Add(item)
                list2.Add(item2)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInEmployerAddressGroup(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationEmpConstants.EmployeridfsRayon
                Return True
            Case PersonDeduplicationEmpConstants.EmployeridfsSettlement
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrStreetName
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrHouse
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrBuilding
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrApartment
                Return True
            Case PersonDeduplicationEmpConstants.EmployerstrPostalCode
                Return True
            Case PersonDeduplicationEmpConstants.EmployeridfsCountry
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInSchoolAddressGroup(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationEmpConstants.SchoolidfsRayon
                Return True
            Case PersonDeduplicationEmpConstants.SchoolidfsSettlement
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrStreetName
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrHouse
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrBuilding
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrApartment
                Return True
            Case PersonDeduplicationEmpConstants.SchoolstrPostalCode
                Return True
            Case PersonDeduplicationEmpConstants.SchoolidfsCountry
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInHumanAddressGroup(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationAddressConstants.HumanidfsRayon
                Return True
            Case PersonDeduplicationAddressConstants.HumanidfsSettlement
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrStreetName
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrHouse
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrBuilding
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrApartment
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrPostalCode
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrLatitude
                Return True
            Case PersonDeduplicationAddressConstants.HumanstrLongitude
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInHumanAltAddressGroup(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationAddressConstants.HumanAltidfsRayon
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltidfsSettlement
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrStreetName
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrHouse
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrBuilding
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrApartment
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltstrPostalCode
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltidfsCountry
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsRegion(ByVal strName As String) As Boolean
        Select Case strName
            Case PersonDeduplicationAddressConstants.HumanidfsRegion
                Return True
            Case PersonDeduplicationAddressConstants.HumanAltidfsRegion
                Return True
            Case PersonDeduplicationEmpConstants.EmployeridfsRegion
                Return True
            Case PersonDeduplicationEmpConstants.SchoolidfsRegion
                Return True
        End Select
        Return False
    End Function

    Private Sub BindTabs()
        Try
            CheckBoxList1.DataSource = CType(Session(InfoList), List(Of Field))
            CheckBoxList1.DataTextField = TextField
            CheckBoxList1.DataValueField = ValueField

            CheckBoxList2.DataSource = CType(Session(InfoList2), List(Of Field))
            CheckBoxList2.DataTextField = TextField
            CheckBoxList2.DataValueField = ValueField

            CheckBoxList1.DataBind()
            CheckBoxList2.DataBind()

            For i As Integer = 0 To CheckBoxList1.Items.Count - 1
                If CType(Session(InfoList), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList1.Items(i).Selected = True
                    CheckBoxList1.Items(i).Enabled = False
                    CheckBoxList2.Items(i).Selected = True
                    CheckBoxList2.Items(i).Enabled = False
                End If
            Next

            CheckBoxList3.DataSource = CType(Session(AddressList0), List(Of Field))
            CheckBoxList3.DataTextField = TextField
            CheckBoxList3.DataValueField = ValueField

            CheckBoxList4.DataSource = CType(Session(AddressList02), List(Of Field))
            CheckBoxList4.DataTextField = TextField
            CheckBoxList4.DataValueField = ValueField

            CheckBoxList3.DataBind()
            CheckBoxList4.DataBind()

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If CType(Session(AddressList0), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList3.Items(i).Selected = True
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Selected = True
                    CheckBoxList4.Items(i).Enabled = False
                ElseIf IsInHumanAddressGroup(CType(Session(AddressList0), List(Of Field)).Item(i).Key) = True Then
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Enabled = False
                ElseIf IsInHumanAltAddressGroup(CType(Session(AddressList0), List(Of Field)).Item(i).Key) = True Then
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Enabled = False
                End If
            Next

            CheckBoxList5.DataSource = CType(Session(EmpList0), List(Of Field))
            CheckBoxList5.DataTextField = TextField
            CheckBoxList5.DataValueField = ValueField

            CheckBoxList6.DataSource = CType(Session(EmpList02), List(Of Field))
            CheckBoxList6.DataTextField = TextField
            CheckBoxList6.DataValueField = ValueField

            CheckBoxList5.DataBind()
            CheckBoxList6.DataBind()

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If CType(Session(EmpList0), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList5.Items(i).Selected = True
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Selected = True
                    CheckBoxList6.Items(i).Enabled = False
                ElseIf IsInEmployerAddressGroup(CType(Session(EmpList0), List(Of Field)).Item(i).Key) = True Then
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Enabled = False
                ElseIf IsInSchoolAddressGroup(CType(Session(EmpList0), List(Of Field)).Item(i).Key) = True Then
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Enabled = False
                End If
            Next

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If CType(Session(AddressList), List(Of Field))(i).Key = PersonDeduplicationAddressConstants.HumanidfsRegion And CheckBoxList3.Items(i).Selected = True Then
                    If GroupAllChecked(i, HUMANADDRESSNUMBERFIELD, CheckBoxList3) = False Then
                        CType(Session(AddressList), List(Of Field))(i).Checked = False
                        CType(Session(AddressList2), List(Of Field))(i).Checked = False
                        CheckBoxList3.Items(i).Selected = False
                        CheckBoxList3.Items(i).Enabled = True
                        CheckBoxList4.Items(i).Selected = False
                        CheckBoxList4.Items(i).Enabled = True
                    End If
                ElseIf CType(Session(AddressList), List(Of Field))(i).Key = PersonDeduplicationAddressConstants.HumanAltidfsRegion And CheckBoxList3.Items(i).Selected = True Then
                    If GroupAllChecked(i, HUMANALTADDRESSNUMBERFIELD, CheckBoxList3) = False Then
                        CType(Session(AddressList), List(Of Field))(i).Checked = False
                        CType(Session(AddressList2), List(Of Field))(i).Checked = False
                        CheckBoxList3.Items(i).Selected = False
                        CheckBoxList3.Items(i).Enabled = True
                        CheckBoxList4.Items(i).Selected = False
                        CheckBoxList4.Items(i).Enabled = True
                    End If
                End If
            Next

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If CType(Session(EmpList), List(Of Field))(i).Key = PersonDeduplicationEmpConstants.EmployeridfsRegion And CheckBoxList5.Items(i).Selected = True Then
                    If GroupAllChecked(i, EMPLOYERADDRESSNUMBERFIELD, CheckBoxList5) = False Then
                        CType(Session(EmpList), List(Of Field))(i).Checked = False
                        CType(Session(EmpList2), List(Of Field))(i).Checked = False
                        CheckBoxList5.Items(i).Selected = False
                        CheckBoxList5.Items(i).Enabled = True
                        CheckBoxList6.Items(i).Selected = False
                        CheckBoxList6.Items(i).Enabled = True
                    End If
                ElseIf CType(Session(EmpList), List(Of Field))(i).Key = PersonDeduplicationEmpConstants.SchoolidfsRegion And CheckBoxList5.Items(i).Selected = True Then
                    If GroupAllChecked(i, SCHOOLADDRESSNUMBERFIELD, CheckBoxList5) = False Then
                        CType(Session(EmpList), List(Of Field))(i).Checked = False
                        CType(Session(EmpList2), List(Of Field))(i).Checked = False
                        CheckBoxList5.Items(i).Selected = False
                        CheckBoxList5.Items(i).Enabled = True
                        CheckBoxList6.Items(i).Selected = False
                        CheckBoxList6.Items(i).Enabled = True
                    End If
                End If
            Next

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

#End Region

#Region "Deduplication Details Methods"

    Protected Sub Record_CheckedChanged(sender As Object, e As EventArgs) Handles rdbSurvivor.CheckedChanged, rdbSuperceded.CheckedChanged
        Try
            If rdbSurvivor.Checked Then
                rdbSuperceded2.Checked = True
                FillSurvivorLists(False)
                Session(SurvivorHumanMasterID) = hdfPersonHumanMasterID.Value
                Session(SupersededHumanMasterID) = hdfPersonHumanMasterID2.Value
            End If
            If rdbSuperceded.Checked Then
                rdbSurvivor2.Checked = True
                FillSurvivorLists(True)
                Session(SurvivorHumanMasterID) = hdfPersonHumanMasterID2.Value
                Session(SupersededHumanMasterID) = hdfPersonHumanMasterID.Value
            End If
            BindTabs()
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub Record2_CheckedChanged(sender As Object, e As EventArgs) Handles rdbSurvivor2.CheckedChanged, rdbSuperceded2.CheckedChanged
        Try
            If rdbSurvivor2.Checked Then
                rdbSuperceded.Checked = True
                FillSurvivorLists(True)
                Session(SurvivorHumanMasterID) = hdfPersonHumanMasterID2.Value
                Session(SupersededHumanMasterID) = hdfPersonHumanMasterID.Value
            End If
            If rdbSuperceded2.Checked Then
                rdbSurvivor.Checked = True
                FillSurvivorLists(False)
                Session(SurvivorHumanMasterID) = hdfPersonHumanMasterID.Value
                Session(SupersededHumanMasterID) = hdfPersonHumanMasterID2.Value
            End If
            BindTabs()
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="record2"></param>
    Protected Sub FillSurvivorLists(record2 As Boolean)
        Try
            SurvivorListInfo.Clear()
            SurvivorListAddress.Clear()
            SurvivorListEmp.Clear()

            If record2 = True Then
                If SurvivorListInfo.Count = 0 Then
                    For i As Integer = 0 To CType(Session(InfoList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(InfoList2), List(Of Field)).Item(i))
                        SurvivorListInfo.Add(item)
                    Next
                End If
                If SurvivorListAddress.Count = 0 Then
                    For i As Integer = 0 To CType(Session(AddressList02), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(AddressList02), List(Of Field)).Item(i))
                        SurvivorListAddress.Add(item)
                    Next
                End If
                If SurvivorListEmp.Count = 0 Then
                    For i As Integer = 0 To CType(Session(EmpList02), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(EmpList02), List(Of Field)).Item(i))
                        SurvivorListEmp.Add(item)
                    Next
                End If
            Else
                If SurvivorListInfo.Count = 0 Then
                    For i As Integer = 0 To CType(Session(InfoList), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(InfoList), List(Of Field)).Item(i))
                        SurvivorListInfo.Add(item)
                    Next
                End If
                If SurvivorListAddress.Count = 0 Then
                    For i As Integer = 0 To CType(Session(AddressList0), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(AddressList0), List(Of Field)).Item(i))
                        SurvivorListAddress.Add(item)
                    Next
                End If
                If SurvivorListEmp.Count = 0 Then
                    For i As Integer = 0 To CType(Session(EmpList0), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(EmpList0), List(Of Field)).Item(i))
                        SurvivorListEmp.Add(item)
                    Next
                End If
            End If
            Session(SURVIVOR_LIST_INFO) = SurvivorListInfo
            Session(SURVIVOR_LIST_ADDRESS) = SurvivorListAddress
            Session(SURVIVOR_LIST_EMP) = SurvivorListEmp
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub CheckBoxList1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList1.SelectedIndexChanged
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            Dim result As String = Request.Form("__EVENTTARGET")

            Dim checkedBox As String() = result.Split("$"c)
            Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))

            If CheckBoxList1.Items(index).Selected Then
                CheckBoxList2.Items(index).Selected = False
                value = CheckBoxList1.Items(index).Value
            Else
                CheckBoxList2.Items(index).Selected = True
                value = CheckBoxList2.Items(index).Value
            End If
            If Session(SURVIVOR_LIST_INFO) IsNot Nothing Then
                If CType(Session(SURVIVOR_LIST_INFO), List(Of Field)).Count > 0 Then
                    label = CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label

                    If value Is Nothing Then
                        CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value, "")
                    ElseIf CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value Is Nothing Then
                        CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label = label.Replace("</font>", value + "</font>")
                    Else
                        CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value, value)
                    End If

                    CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value = value
                End If
            End If
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub CheckBoxList2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList2.SelectedIndexChanged
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            Dim result As String = Request.Form("__EVENTTARGET")

            Dim checkedBox As String() = result.Split("$"c)
            Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))

            If CheckBoxList2.Items(index).Selected Then
                CheckBoxList1.Items(index).Selected = False
                value = CheckBoxList2.Items(index).Value
            Else
                CheckBoxList1.Items(index).Selected = True
                value = CheckBoxList1.Items(index).Value
            End If
            If Session(SURVIVOR_LIST_INFO) IsNot Nothing Then
                If CType(Session(SURVIVOR_LIST_INFO), List(Of Field)).Count > 0 Then
                    label = CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label

                    If value Is Nothing Then
                        CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value, "")
                    ElseIf CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value Is Nothing Then
                        CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label = label.Replace("</font>", value + "</font>")
                    Else
                        CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value, value)
                    End If

                    CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(index).Value = value
                End If
            End If
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub CheckBoxListAddress_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList3.SelectedIndexChanged, CheckBoxList4.SelectedIndexChanged
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            Dim result As String = Request.Form("__EVENTTARGET")

            If result.Contains("CheckBoxList3") Or result.Contains("CheckBoxList4") Then

                Dim checkedBox As String() = result.Split("$"c)
                Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))
                Dim str As String = checkedBox(checkedBox.Length - 2)

                Select Case str
                    Case "CheckBoxList3"
                        If CheckBoxList3.Items(index).Selected Then
                            value = CheckBoxList3.Items(index).Value
                            If CType(Session(AddressList), List(Of Field))(index).Key = PersonDeduplicationAddressConstants.HumanidfsRegion Then
                                SelectAllAndUnSelectAll(index, HUMANADDRESSNUMBERFIELD, CheckBoxList3, CheckBoxList4, CType(Session(AddressList), List(Of Field)), CType(Session(AddressList2), List(Of Field)), CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field)))
                            ElseIf CType(Session(AddressList), List(Of Field))(index).Key = PersonDeduplicationAddressConstants.HumanAltidfsRegion Then
                                SelectAllAndUnSelectAll(index, HUMANALTADDRESSNUMBERFIELD, CheckBoxList3, CheckBoxList4, CType(Session(AddressList), List(Of Field)), CType(Session(AddressList2), List(Of Field)), CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field)))
                            Else
                                CheckBoxList4.Items(index).Selected = False
                                CType(Session(AddressList), List(Of Field))(index).Checked = True
                                CType(Session(AddressList2), List(Of Field))(index).Checked = False
                            End If
                        End If
                    Case "CheckBoxList4"
                        If CheckBoxList4.Items(index).Selected Then
                            value = CheckBoxList4.Items(index).Value
                            If CType(Session(AddressList), List(Of Field))(index).Key = PersonDeduplicationAddressConstants.HumanidfsRegion Then
                                SelectAllAndUnSelectAll(index, HUMANADDRESSNUMBERFIELD, CheckBoxList4, CheckBoxList3, CType(Session(AddressList2), List(Of Field)), CType(Session(AddressList), List(Of Field)), CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field)))
                            ElseIf CType(Session(AddressList), List(Of Field))(index).Key = PersonDeduplicationAddressConstants.HumanAltidfsRegion Then
                                SelectAllAndUnSelectAll(index, HUMANALTADDRESSNUMBERFIELD, CheckBoxList4, CheckBoxList3, CType(Session(AddressList2), List(Of Field)), CType(Session(AddressList), List(Of Field)), CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field)))
                            Else
                                CheckBoxList3.Items(index).Selected = False
                                CType(Session(AddressList), List(Of Field))(index).Checked = False
                                CType(Session(AddressList2), List(Of Field))(index).Checked = True
                            End If
                        End If
                End Select

                If Session(SURVIVOR_LIST_ADDRESS) IsNot Nothing Then
                    If CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field)).Count > 0 Then
                        label = CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Label

                        If value Is Nothing Then
                            CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Value, "")
                        ElseIf CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Value Is Nothing Then
                            CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Label = label.Replace("</font>", value + "</font>")
                        Else
                            CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Value, value)
                        End If

                        CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(index).Value = value
                    End If
                End If

                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub CheckBoxListEmp_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList5.SelectedIndexChanged, CheckBoxList6.SelectedIndexChanged
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            Dim result As String = Request.Form("__EVENTTARGET")

            If result.Contains("CheckBoxList5") Or result.Contains("CheckBoxList6") Then

                Dim checkedBox As String() = result.Split("$"c)
                Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))
                Dim str As String = checkedBox(checkedBox.Length - 2)

                Select Case str
                    Case "CheckBoxList5"
                        If CheckBoxList5.Items(index).Selected Then
                            value = CheckBoxList5.Items(index).Value
                            If CType(Session(EmpList), List(Of Field))(index).Key = PersonDeduplicationEmpConstants.EmployeridfsRegion Then
                                SelectAllAndUnSelectAll(index, EMPLOYERADDRESSNUMBERFIELD, CheckBoxList5, CheckBoxList6, CType(Session(EmpList), List(Of Field)), CType(Session(EmpList2), List(Of Field)), CType(Session(SURVIVOR_LIST_EMP), List(Of Field)))
                            ElseIf CType(Session(EmpList), List(Of Field))(index).Key = PersonDeduplicationEmpConstants.SchoolidfsRegion Then
                                SelectAllAndUnSelectAll(index, SCHOOLADDRESSNUMBERFIELD, CheckBoxList5, CheckBoxList6, CType(Session(EmpList), List(Of Field)), CType(Session(EmpList2), List(Of Field)), CType(Session(SURVIVOR_LIST_EMP), List(Of Field)))
                            Else
                                CheckBoxList6.Items(index).Selected = False
                                CType(Session(EmpList), List(Of Field))(index).Checked = True
                                CType(Session(EmpList2), List(Of Field))(index).Checked = False
                            End If
                        End If
                    Case "CheckBoxList6"
                        If CheckBoxList6.Items(index).Selected Then
                            value = CheckBoxList6.Items(index).Value
                            If CType(Session(EmpList), List(Of Field))(index).Key = PersonDeduplicationEmpConstants.EmployeridfsRegion Then
                                SelectAllAndUnSelectAll(index, EMPLOYERADDRESSNUMBERFIELD, CheckBoxList6, CheckBoxList5, CType(Session(EmpList2), List(Of Field)), CType(Session(EmpList), List(Of Field)), CType(Session(SURVIVOR_LIST_EMP), List(Of Field)))
                            ElseIf CType(Session(EmpList), List(Of Field))(index).Key = PersonDeduplicationEmpConstants.SchoolidfsRegion Then
                                SelectAllAndUnSelectAll(index, SCHOOLADDRESSNUMBERFIELD, CheckBoxList6, CheckBoxList5, CType(Session(EmpList2), List(Of Field)), CType(Session(EmpList), List(Of Field)), CType(Session(SURVIVOR_LIST_EMP), List(Of Field)))
                            Else
                                CheckBoxList5.Items(index).Selected = False
                                CType(Session(EmpList), List(Of Field))(index).Checked = False
                                CType(Session(EmpList2), List(Of Field))(index).Checked = True
                            End If
                        End If
                End Select

                If Session(SURVIVOR_LIST_EMP) IsNot Nothing Then
                    If CType(Session(SURVIVOR_LIST_EMP), List(Of Field)).Count > 0 Then
                        label = CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Label

                        If value Is Nothing Then
                            CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Value, "")
                        ElseIf CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Value Is Nothing Then
                            CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Label = label.Replace("</font>", value + "</font>")
                        Else
                            CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Label = label.Replace(CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Value, value)
                        End If

                        CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(index).Value = value
                    End If
                End If

                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="index"></param>
    ''' <param name="length"></param>
    ''' <param name="control"></param>
    ''' <param name="control2"></param>
    ''' <param name="list"></param>
    ''' <param name="list2"></param>
    ''' <param name="listSurvivor"></param>
    Private Sub SelectAllAndUnSelectAll(ByVal index As Integer, ByVal length As Integer, control As CheckBoxList, control2 As CheckBoxList, ByRef list As List(Of Field), ByRef list2 As List(Of Field), ByRef listSurvivor As List(Of Field))
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            For i As Integer = index To index + length - 1
                list(i).Checked = True
                list2(i).Checked = False
                value = control.Items(i).Value
                If listSurvivor IsNot Nothing Then
                    If listSurvivor.Count > 0 Then
                        listSurvivor(i).Checked = True
                        label = listSurvivor(i).Label
                        If value Is Nothing Then
                            listSurvivor(i).Label = label.Replace(listSurvivor(i).Value, "")
                        ElseIf listSurvivor(i).Value Is Nothing Then
                            listSurvivor(i).Label = label.Replace("</font>", value + "</font>")
                        ElseIf listSurvivor(i).Value = value Then
                            listSurvivor(i).Label = label
                        ElseIf listSurvivor(i).Value = "" Then
                            listSurvivor(i).Label = label.Replace("</font>", value + "</font>")
                        Else
                            listSurvivor(i).Label = label.Replace(listSurvivor(i).Value, value)
                        End If
                        listSurvivor(i).Value = value
                    End If
                End If
            Next

            BindCheckBoxList(control, list)
            BindCheckBoxList(control2, list2)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Public Structure PersonDeduplicationInfoConstants
        Public Const EIDSSPersonID As String = "EIDSSPersonID"
        Public Const PersonalIDType As String = "PersonalIDType"
        Public Const PersonalID As String = "PersonalID"
        Public Const LastOrSurname As String = "LastOrSurname"
        Public Const SecondName As String = "SecondName"
        Public Const FirstOrGivenName As String = "FirstOrGivenName"
        Public Const DateOfBirth As String = "DateOfBirth"
        Public Const ReportedAge As String = "ReportedAge"
        Public Const GenderTypeID As String = "GenderTypeID"
        Public Const CitizenshipTypeID As String = "CitizenshipTypeID"
        Public Const PassportNumber As String = "PassportNumber"
    End Structure

    Public Structure PersonDeduplicationEmpConstants
        Public Const IsEmployedTypeID As String = "IsEmployedTypeID"
        Public Const OccupationTypeID As String = "OccupationTypeID"
        Public Const EmployerName As String = "EmployerName"
        Public Const EmployedDateLastPresent As String = "EmployedDateLastPresent"
        Public Const EmployerPhone As String = "EmployerPhone"
        Public Const EmployerForeignAddressIndicator As String = "EmployerForeignAddressIndicator"
        Public Const EmployerForeignAddressString As String = "EmployerForeignAddressString"
        Public Const EmployeridfsRegion As String = "EmployeridfsRegion"
        Public Const EmployeridfsRayon As String = "EmployeridfsRayon"
        Public Const EmployeridfsSettlement As String = "EmployeridfsSettlement"
        Public Const EmployerstrStreetName As String = "EmployerstrStreetName"
        Public Const EmployerstrHouse As String = "EmployerstrHouse"
        Public Const EmployerstrBuilding As String = "EmployerstrBuilding"
        Public Const EmployerstrApartment As String = "EmployerstrApartment"
        Public Const EmployerstrPostalCode As String = "EmployerstrPostalCode"
        Public Const EmployeridfsCountry As String = "EmployeridfsCountry"
        Public Const WorkPhone As String = "WorkPhone"
        Public Const IsStudentTypeID As String = "IsStudentTypeID"
        Public Const SchoolName As String = "SchoolName"
        Public Const SchoolDateLastAttended As String = "SchoolDateLastAttended"
        Public Const SchoolForeignAddressIndicator As String = "SchoolForeignAddressIndicator"
        Public Const SchoolForeignAddressString As String = "SchoolForeignAddressString"
        Public Const SchoolidfsRegion As String = "SchoolidfsRegion"
        Public Const SchoolidfsRayon As String = "SchoolidfsRayon"
        Public Const SchoolidfsSettlement As String = "SchoolidfsSettlement"
        Public Const SchoolstrStreetName As String = "SchoolstrStreetName"
        Public Const SchoolstrHouse As String = "SchoolstrHouse"
        Public Const SchoolstrBuilding As String = "SchoolstrBuilding"
        Public Const SchoolstrApartment As String = "SchoolstrApartment"
        Public Const SchoolstrPostalCode As String = "SchoolstrPostalCode"
        Public Const SchoolidfsCountry As String = "Country"
        Public Const SchoolPhone As String = "SchoolPhone"
    End Structure

    Public Structure PersonDeduplicationAddressConstants
        Public Const HumanidfsRegion As String = "HumanidfsRegion"
        Public Const HumanidfsRayon As String = "HumanidfsRayon"
        Public Const HumanidfsSettlement As String = "HumanidfsSettlement"
        Public Const HumanstrStreetName As String = "HumanstrStreetName"
        Public Const HumanstrHouse As String = "HumanstrHouse"
        Public Const HumanstrBuilding As String = "HumanstrBuilding"
        Public Const HumanstrApartment As String = "HumanstrApartment"
        Public Const HumanstrPostalCode As String = "HumanstrPostalCode"
        Public Const HumanstrLatitude As String = "HumanstrLatitude"
        Public Const HumanstrLongitude As String = "HumanstrLongitude"
        Public Const HumanGeoLocationID As String = "HumanGeoLocationID"
        Public Const HumanAltGeoLocationID As String = "HumanAltGeoLocationID"
        Public Const HumanAltForeignAddressIndicator As String = "HumanAltForeignAddressIndicator"
        Public Const HumanAltForeignAddressString As String = "HumanAltForeignAddressString"
        Public Const HumanAltidfsRegion As String = "HumanAltidfsRegion"
        Public Const HumanAltidfsRayon As String = "HumanAltidfsRayon"
        Public Const HumanAltidfsSettlement As String = "HumanAltidfsSettlement"
        Public Const HumanAltstrStreetName As String = "HumanAltstrStreetName"
        Public Const HumanAltstrHouse As String = "HumanAltstrHouse"
        Public Const HumanAltstrBuilding As String = "HumanAltstrBuilding"
        Public Const HumanAltstrApartment As String = "HumanAltstrApartment"
        Public Const HumanAltstrPostalCode As String = "HumanAltstrPostalCode"
        Public Const HumanAltidfsCountry As String = "HumanAltidfsCountry"
        Public Const ContactPhoneCountryCode As String = "ContactPhoneCountryCode"
        Public Const ContactPhone As String = "ContactPhone"
        Public Const ContactPhoneTypeID As String = "ContactPhoneTypeID"
        Public Const ContactPhone2CountryCode As String = "ContactPhone2CountryCode"
        Public Const ContactPhone2 As String = "ContactPhone2"
        Public Const ContactPhone2TypeID As String = "ContactPhone2TypeID"
    End Structure
    Public Structure PersonDeduplicationTabConstants
        Public Const Info = "Info"
        Public Const Address = "Address"
        Public Const Emp = "Emp"
    End Structure

    Protected Sub btnMerge_Click(sender As Object, e As EventArgs) Handles btnMerge.Click
        Try
            upPerson.Update()
            ucSearchPersonInformation.Visible = False

            If rdbSurvivor.Checked = False And rdbSurvivor2.Checked = False Then
                hdfCurrentTab.Value = PersonDeduplicationTabConstants.Info
                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            Else
                If AllFieldValuePairsSelected() = True Then
                    CheckBoxList7.DataSource = CType(Session(SURVIVOR_LIST_INFO), List(Of Field))
                    CheckBoxList7.DataTextField = TextField
                    CheckBoxList7.DataValueField = ValueField

                    CheckBoxList8.DataSource = CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))
                    CheckBoxList8.DataTextField = TextField
                    CheckBoxList8.DataValueField = ValueField

                    CheckBoxList9.DataSource = CType(Session(SURVIVOR_LIST_EMP), List(Of Field))
                    CheckBoxList9.DataTextField = TextField
                    CheckBoxList9.DataValueField = ValueField

                    CheckBoxList7.DataBind()
                    CheckBoxList8.DataBind()
                    CheckBoxList9.DataBind()

                    For i As Integer = 0 To CheckBoxList7.Items.Count - 1
                        CheckBoxList7.Items(i).Selected = True
                        CheckBoxList7.Items(i).Enabled = False
                    Next
                    For i As Integer = 0 To CheckBoxList8.Items.Count - 1
                        CheckBoxList8.Items(i).Selected = True
                        CheckBoxList8.Items(i).Enabled = False
                    Next
                    For i As Integer = 0 To CheckBoxList9.Items.Count - 1
                        CheckBoxList9.Items(i).Selected = True
                        CheckBoxList9.Items(i).Enabled = False
                    Next

                    divDeduplicationDetails.Visible = False
                    divSurvivorReview.Visible = True
                Else
                    ShowWarningMessage(messageType:=MessageType.FieldValuePairFoundNoSelection, isConfirm:=False)
                    ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Function AllFieldValuePairsSelected() As Boolean
        Try
            Dim sScript As String

            For i As Integer = 0 To CheckBoxList1.Items.Count - 1
                If CheckBoxList1.Items(i).Selected = False And CheckBoxList2.Items(i).Selected = False Then
                    hdfCurrentTab.Value = PersonDeduplicationTabConstants.Info
                    btnNextSection.Visible = True
                    sScript = "SetFocus('" + CheckBoxList1.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If CheckBoxList3.Items(i).Selected = False And CheckBoxList4.Items(i).Selected = False Then
                    hdfCurrentTab.Value = PersonDeduplicationTabConstants.Address
                    btnNextSection.Visible = True
                    sScript = "SetFocus('" + CheckBoxList3.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If CheckBoxList5.Items(i).Selected = False And CheckBoxList6.Items(i).Selected = False Then
                    hdfCurrentTab.Value = PersonDeduplicationTabConstants.Emp
                    btnNextSection.Visible = False
                    sScript = "SetFocus('" + CheckBoxList5.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next
            Return True
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return False
        End Try
    End Function

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        ShowWarningMessage(messageType:=MessageType.ConfirmMerge, isConfirm:=True)
    End Sub

    Private Shared Function IsNullableType(type As Type) As Boolean
        Return type.IsGenericType AndAlso type.GetGenericTypeDefinition().Equals(GetType(Nullable(Of )))
    End Function

    Public Shared Sub SetValue(inputObject As Object, propertyName As String, propertyVal As Object)
        'find out the type
        Dim type As Type = inputObject.GetType()

        'get the property information based on the type
        Dim propertyInfo As System.Reflection.PropertyInfo = type.GetProperty(propertyName)

        'find the property type
        Dim propertyType As Type = propertyInfo.PropertyType

        'Convert.ChangeType does not handle conversion to nullable types
        'if the property type is nullable, we need to get the underlying type of the property
        Dim targetType = If(IsNullableType(propertyType), Nullable.GetUnderlyingType(propertyType), propertyType)

        'Returns an System.Object with the specified System.Type and whose value is
        'equivalent to the specified object.
        propertyVal = Convert.ChangeType(propertyVal, targetType)

        'Set the value of the property
        propertyInfo.SetValue(inputObject, propertyVal, Nothing)

    End Sub

    Private Sub SaveSurvivorRecord()
        Try
            Dim parameters = New HumanSetParam()
            Dim type As Type = parameters.GetType()
            Dim props() As PropertyInfo = type.GetProperties()
            Dim Index = -1

            For i = 0 To props.Count - 1
                If IsInTabInfo(props(i).Name) = True Then
                    Index = keyDict.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_INFO), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                ElseIf IsInTabAddress(props(i).Name) = True Then
                    Index = keyDict2.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_ADDRESS), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                ElseIf IsInTabEmp(props(i).Name) = True Then
                    Index = keyDict3.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_EMP), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                End If
            Next

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If
            Dim result As List(Of HumHumanMasterSetModel) = HumanAPIService.SaveHumanMasterAsync(parameters).Result

            If result.Count > 0 Then
                If result.FirstOrDefault().ReturnCode = 0 Then 'Success
                    ShowSuccessMessage(messageType:=MessageType.SaveSuccess, message:=GetLocalResourceObject("Lbl_Save_Success").ToString())
                Else 'Error
                End If
            Else
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub ReplaceSupersededDiseaseListPersonID()
        Try
            Dim parameters = New PersonDedupeSetParams()

            If Session(SurvivorHumanMasterID) IsNot Nothing And Session(SupersededHumanMasterID) IsNot Nothing Then
                Dim result = New List(Of AdminDeduplicationPersonidHumanDiseaseSetModel)()

                Dim survivorID As Long = CType(Session(SurvivorHumanMasterID).ToString, Long)
                Dim supersededID As Long = CType(Session(SupersededHumanMasterID).ToString, Long)

                parameters.SurvivorHumanMasterID = survivorID
                parameters.SupersededHumanMasterID = supersededID

                If PersonClient Is Nothing Then
                    PersonClient = New PersonServiceClient()
                End If

                result = PersonClient.DedupePersonIdHumanDiseaseAsync(parameters).Result
                If result.Count > 0 Then
                    If result.FirstOrDefault().ReturnCode = 0 Then 'Success
                    Else 'Error
                    End If
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub ReplaceSupersededFarmListPersonID()
        Try
            Dim parameters = New PersonDedupeSetParams()

            If Session(SurvivorHumanMasterID) IsNot Nothing And Session(SupersededHumanMasterID) IsNot Nothing Then
                Dim result = New List(Of AdminDeduplicationPersonidFarmSetModel)()

                Dim survivorID As Long = CType(Session(SurvivorHumanMasterID).ToString, Long)
                Dim supersededID As Long = CType(Session(SupersededHumanMasterID).ToString, Long)

                parameters.SurvivorHumanMasterID = survivorID
                parameters.SupersededHumanMasterID = supersededID

                If PersonClient Is Nothing Then
                    PersonClient = New PersonServiceClient()
                End If

                result = PersonClient.DedupePersonIdFarmAsync(parameters).Result
                If result.Count > 0 Then
                    If result.FirstOrDefault().ReturnCode = 0 Then 'Success
                    Else 'Error
                    End If
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub RemoveSupersededRecord()
        Try
            If Session(SupersededHumanMasterID) IsNot Nothing Then
                Dim result = New List(Of HumHumanSetModel)()

                Dim humanID As Long = CType(Session(SupersededHumanMasterID).ToString, Long)

                If HumanAPIService Is Nothing Then
                    HumanAPIService = New HumanServiceClient()
                End If

                result = HumanAPIService.DeleteHumanMasterAsync(GetCurrentLanguage(), humanID).Result
                If result.Count > 0 Then
                    If result.FirstOrDefault().ReturnCode = 0 Then 'Success
                    Else 'Error
                    End If
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        ShowWarningMessage(messageType:=MessageType.CancelFormConfirm, isConfirm:=True)
    End Sub

    Protected Sub btnNextSection_Click(sender As Object, e As EventArgs) Handles btnNextSection.Click
        upPerson.Update()

        Select Case hdfCurrentTab.Value
            Case PersonDeduplicationTabConstants.Info
                hdfCurrentTab.Value = PersonDeduplicationTabConstants.Address
                btnNextSection.Visible = True
            Case PersonDeduplicationTabConstants.Address
                hdfCurrentTab.Value = PersonDeduplicationTabConstants.Emp
                btnNextSection.Visible = False
            Case PersonDeduplicationTabConstants.Emp
        End Select

        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
    End Sub

    Private Sub DeduplicateRecords()
        Try
            SaveSurvivorRecord()
            ReplaceSupersededDiseaseListPersonID()
            ReplaceSupersededFarmListPersonID()
            RemoveSupersededRecord()
            ShowSuccessMessage(messageType:=MessageType.SaveSuccess, message:=GetLocalResourceObject("Lbl_Save_Success").ToString())
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelSubmit_Click(sender As Object, e As EventArgs) Handles btnCancelSubmit.Click
        ShowWarningMessage(messageType:=MessageType.CancelFormConfirm, isConfirm:=True)
    End Sub

#End Region

End Class
