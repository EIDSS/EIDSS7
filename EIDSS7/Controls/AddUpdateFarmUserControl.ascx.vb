Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' 
''' </summary>
Public Class AddUpdateFarmUserControl
    Inherits UserControl

#Region "Global Values"

    Private Const SectionFarmInformation As String = "Farm Information"
    Private Const SectionFarmAddress As String = "Farm Address"
    Private Const SectionFlockHerdSpecies As String = "Flock/Herd Species"

    Private Const SEARCH_FARM_TYPE As String = "SearchFarmType"

    Private Const PAGE_KEY As String = "Page"
    Private Const MODAL_KEY As String = "Modal"

    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"

    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private Const FLOCKS_HERDS_LIST As String = "gvFlocksHerds"
    Private Const SPECIES_LIST As String = "gvSpecies"
    Private Const FLOCK_HERD_SPECIES_LIST As String = "gvFarmFlockSpecies"
    Private Const HERD_FLOCK_SPECIES_LIST As String = "gvHerdFlockSpecies_List"
    Private Const SESSION_VETERINARY_DISEASE_REPORT_LIST As String = "gvVeterinaryDiseaseReports_List"
    Private Const VETERINARY_DISEASE_REPORT_SORT_DIRECTION As String = "gvVeterinaryDiseaseReports_SortDirection"
    Private Const VETERINARY_DISEASE_REPORT_SORT_EXPRESSION As String = "gvVeterinaryDiseaseReports_SortExpression"
    Private Const VETERINARY_DISEASE_REPORT_PAGINATION_SET_NUMBER As String = "gvVeterinaryDiseaseReports_PaginationSet"
    Private Const SESSION_OUTBREAK_CASE_LIST As String = "gvOutbreakCases_List"
    Private Const OUTBREAK_CASE_SORT_DIRECTION As String = "gvOutbreakCases_SortDirection"
    Private Const OUTBREAK_CASE_SORT_EXPRESSION As String = "gvOutbreakCases_SortExpression"
    Private Const OUTBREAK_CASE_PAGINATION_SET_NUMBER As String = "gvOutbreakCases_PaginationSet"

    Public Event ValidatePage()
    Public Event ShowSuccessModal(messageType As MessageType)
    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String)
    Public Event ShowErrorModal(messageType As MessageType, message As String)
    Public Event CreateFarm(farmID As Long, farmName As String, eidssFarmID As String, message As String)
    Public Event UpdateFarm(farmID As Long, farmName As String, eidssFarmID As String, message As String)
    Public Event EditFarm(farmID As Long, farmName As String)
    Public Event ShowSearch()
    Public Event ShowSearchPersonModal()
    Public Event ShowSpeciesModal()

    Private FarmAPIService As FarmServiceClient
    Private OutbreakAPIService As OutbreakServiceClient
    Private VeterinaryAPIService As VeterinaryServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(AddUpdateFarmUserControl))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
            Else
                If hdfShowFarmInventory.Value = True Then
                    upAddUpdateFarm.Update()

                    If FarmSideBar.MenuItems.Count < 4 Then
                        FarmSideBar.MenuItems.Insert(2, sbiFlocksHerdsSpecies)
                        sbiFlocksHerdsSpecies.GoToSideBarSection = "2, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')"
                        sbiFarmReview.GoToSideBarSection = "3, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')"
                    End If

                    HerdSpeciesInformation.Visible = True

                    If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                        sbiFlocksHerdsSpecies.Text = Resources.Tabs.Tab_Flocks_Species_Text
                    Else
                        sbiFlocksHerdsSpecies.Text = Resources.Tabs.Tab_Herds_Species_Text
                    End If

                    rfvHerd.Enabled = True
                    rfvSpeciesType.Enabled = True
                    rfvTotalAnimalQuantity.Enabled = True

                    upFarmHerdSpecies.Update()
                Else
                    upAddUpdateFarm.Update()

                    FarmSideBar.MenuItems.Remove(sbiFlocksHerdsSpecies)
                    HerdSpeciesInformation.Visible = False
                    sbiFarmReview.GoToSideBarSection = "2, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')"

                    rfvHerd.Enabled = False
                    rfvSpeciesType.Enabled = False
                    rfvTotalAnimalQuantity.Enabled = False

                    upFarmHerdSpecies.Update()
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' Use setup instead of page load to perform most operations.  The reason is some modules have a
    ''' multitude of controls that we'd like to spread out the loading to reduce initial load 
    ''' time.
    ''' </summary>
    ''' <param name="initialPanelID"></param>
    ''' <param name="monitoringSessionIndicator"></param>
    ''' <param name="action"></param>
    ''' <param name="farmID"></param>
    ''' <param name="farmType"></param>
    ''' <param name="monitoringSessionSpeciesToSampleTypes"></param>
    Public Sub Setup(initialPanelID As Integer, Optional monitoringSessionIndicator As Boolean = False, Optional action As String = UserAction.Insert, Optional farmID As Long = Nothing, Optional farmType As String = Nothing, Optional monitoringSessionSpeciesToSampleTypes As List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel) = Nothing)

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Reset()

            hdfShowFarmInventory.Value = monitoringSessionIndicator

            If monitoringSessionIndicator = False Then
                HerdSpeciesInformation.Visible = False
                sbiFarmReview.GoToSideBarSection = "2, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')"

                upFarmHerdSpecies.Update()
                rblFarmTypeID.Enabled = True
            Else
                If FarmSideBar.MenuItems.Count < 4 Then
                    FarmSideBar.MenuItems.Insert(2, sbiFlocksHerdsSpecies)
                    sbiFlocksHerdsSpecies.GoToSideBarSection = "2, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')"
                    sbiFarmReview.GoToSideBarSection = "3, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit')"
                End If

                HerdSpeciesInformation.Visible = True

                If (farmType.EqualsAny({FarmTypes.AvianFarmTypeName})) Then
                    rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType
                    btnAddFlock.Visible = True
                    btnAddHerd.Visible = False
                    hdgFlocksHerdsSpecies.InnerText = Resources.Labels.Lbl_Farm_Flock_Species_Text
                ElseIf (farmType.EqualsAny({FarmTypes.LivestockFarmTypeName})) Then
                    rblFarmTypeID.SelectedValue = FarmTypes.LivestockFarmType
                    btnAddFlock.Visible = False
                    btnAddHerd.Visible = True
                    hdgFlocksHerdsSpecies.InnerText = Resources.Labels.Lbl_Farm_Herd_Species_Text
                End If

                rblFarmTypeID.Enabled = False
                rblFarmTypeID.Items(0).Enabled = False
                rblFarmTypeID.Items(1).Enabled = False

                If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                    sbiFlocksHerdsSpecies.Text = Resources.Tabs.Tab_Flocks_Species_Text
                Else
                    sbiFlocksHerdsSpecies.Text = Resources.Tabs.Tab_Herds_Species_Text
                End If

                rfvHerd.Enabled = True
                rfvSpeciesType.Enabled = True
                rfvTotalAnimalQuantity.Enabled = True

                upFarmHerdSpecies.Update()
            End If

            FarmAddress.Setup(CrossCuttingAPIService)

            Select Case action
                Case UserAction.Insert
                    divFarmID.Visible = False
                    btnAddVeterinaryDiseaseReport.Visible = False
                    btnAddOutbreakCase.Visible = False
                    divSelectablePreviewVeterinaryDiseaseReportList.Visible = False
                    divSelectablePreviewOutbreakCaseList.Visible = False
                    hdfFarmMasterID.Value = "-1"
                    hdfFarmAddressidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
                    ToggleVisibility(String.Empty)

                    If monitoringSessionIndicator = True Then
                        FillFlockHerdSpecies(monitoringSessionSpeciesToSampleTypes)
                    End If

                    EnableForm(divFarmForm, True)
                    EnableForm(txtEIDSSFarmID, False)
                    EnableForm(txtEnteredDate, False)
                    EnableForm(txtModifiedDate, False)
                    hdfFarmPanelController.Value = 0
                    btnDelete.Visible = False
                Case UserAction.Read
                    hdfFarmMasterID.Value = farmID
                    divFarmID.Visible = True
                    FillFarm(edit:=False)
                    btnSubmit.Visible = False
                    hdfFarmPanelController.Value = 2
                    ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "goToSideBarSection(2, document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'))", True)
                    FarmSideBar.Visible = False
                    btnDelete.Visible = True
                    divSelectablePreviewVeterinaryDiseaseReportList.Visible = True
                    divSelectablePreviewOutbreakCaseList.Visible = True
                Case UserAction.Update
                    btnSubmit.Visible = True
                    hdfFarmMasterID.Value = farmID
                    divSelectablePreviewVeterinaryDiseaseReportList.Visible = True
                    divSelectablePreviewOutbreakCaseList.Visible = True
                    FillFarm(edit:=True)
                    If hdfFarmAddressidfsCountry.Value.IsValueNullOrEmpty = True Then
                        hdfFarmAddressidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
                    End If
                    hdfFarmPanelController.Value = 0
                    btnDelete.Visible = False
            End Select

            upAddUpdateFarm.Update()
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
    Private Sub Reset()

        ExtractViewStateSession()

        FillControlLists()

        ResetForm(divFarmForm)
        ResetForm(FarmAddress)

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
            Throw
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
    Private Sub ToggleVisibility(section As String)

        'Buttons
        If hdfFarmMasterID.Value = "-1" Then
            btnAddVeterinaryDiseaseReport.Visible = False
            btnDelete.Visible = False
        Else
            btnAddVeterinaryDiseaseReport.Visible = True
        End If

        'Set focus to correct panel
        Select Case section
            Case SectionFarmInformation
                hdfFarmPanelController.Value = 0
            Case SectionFarmAddress
                hdfFarmPanelController.Value = 1
            Case SectionFlockHerdSpecies
                hdfFarmPanelController.Value = 2
        End Select

    End Sub

#End Region

#Region "Farm Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillControlLists()

        'Farm Types
        rblFarmTypeID.Items.Clear()
        Dim li As ListItem
        li = New ListItem With {.Value = FarmTypes.AvianFarmType, .Text = Resources.Labels.Lbl_Avian_Text}
        rblFarmTypeID.Items.Add(li)
        li = New ListItem With {.Value = FarmTypes.LivestockFarmType, .Text = Resources.Labels.Lbl_Livestock_Text}
        rblFarmTypeID.Items.Add(li)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="edit"></param>
    Private Sub FillFarm(edit As Boolean)

        Try
            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            Dim farm = FarmAPIService.GetFarmMasterDetailAsync(GetCurrentLanguage(), hdfFarmMasterID.Value).Result

            If Not IsNothing(farm) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If

                Dim parameters As VeterinaryDiseaseReportGetListParameters
                parameters = New VeterinaryDiseaseReportGetListParameters()
                parameters = Gather(Me, parameters, 3)
                parameters.LanguageID = GetCurrentLanguage()
                parameters.FarmMasterID = hdfFarmMasterID.Value
                parameters.OutbreakCasesIndicator = 0
                parameters.PaginationSetNumber = 1

                Dim counts = VeterinaryAPIService.GetVeterinaryDiseaseReportListCountAsync(parameters).Result
                gvVeterinaryDiseaseReports.PageIndex = 0
                lblVeterinaryDiseaseReportNumberOfRecords.Text = counts.FirstOrDefault().RecordCount
                lblVeterinaryDiseaseReportPageNumber.Text = "1"
                FillVeterinaryDiseaseReportList(pageIndex:=1, paginationSetNumber:=1)

                EnableForm(divFarmForm, edit)
                'Disable farm type if at least one veterinary disease report is associated to the farm.
                rblFarmTypeID.Enabled = counts.FirstOrDefault().RecordCount = 0

                parameters.OutbreakCasesIndicator = 1
                counts = VeterinaryAPIService.GetVeterinaryDiseaseReportListCountAsync(parameters).Result
                gvOutbreakCases.PageIndex = 0
                lblOutbreakCaseNumberOfRecords.Text = counts.FirstOrDefault().RecordCount
                lblOutbreakCasePageNumber.Text = "1"
                FillOutbreakCaseList(pageIndex:=1, paginationSetNumber:=1)

                FarmAddress.LocationCountryID = farm.FirstOrDefault().FarmAddressidfsCountry
                FarmAddress.LocationRegionID = farm.FirstOrDefault().FarmAddressidfsRegion
                FarmAddress.LocationRayonID = farm.FirstOrDefault().FarmAddressidfsRayon
                FarmAddress.LocationSettlementID = farm.FirstOrDefault().FarmAddressidfsSettlement
                FarmAddress.LocationPostalCodeName = farm.FirstOrDefault().FarmAddressstrPostalCode
                FarmAddress.StreetText = farm.FirstOrDefault().FarmAddressstrStreetName
                FarmAddress.ApartmentText = farm.FirstOrDefault().FarmAddressstrApartment
                FarmAddress.BuildingText = farm.FirstOrDefault().FarmAddressstrBuilding
                FarmAddress.HouseText = farm.FirstOrDefault().FarmAddressstrHouse
                FarmAddress.LatitudeText = farm.FirstOrDefault().FarmAddressstrLatitude.ToString()
                FarmAddress.LongitudeText = farm.FirstOrDefault().FarmAddressstrLongitude.ToString()

                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                FarmAddress.Setup(CrossCuttingAPIService)

                Scatter(Me, farm.FirstOrDefault())
                Scatter(divFarmForm, farm.FirstOrDefault())

                If Not farm.FirstOrDefault().EnteredDate Is Nothing Then
                    txtEnteredDate.Text = CType(farm.FirstOrDefault().EnteredDate, Date).ToShortDateString()
                End If
                txtEnteredDate.Enabled = False

                If Not farm.FirstOrDefault().ModifiedDate Is Nothing Then
                    txtModifiedDate.Text = CType(farm.FirstOrDefault().ModifiedDate, Date).ToShortDateString()
                End If
                txtModifiedDate.Enabled = False

                rblFarmTypeID.SelectedValue = farm.FirstOrDefault().FarmTypeID

                divFarmID.Visible = True
                txtEIDSSFarmID.Enabled = False
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
    Protected Sub Submit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            RaiseEvent ValidatePage()

            If (Page.IsValid) Then
                ScriptManager.RegisterClientScriptBlock(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'))", True)

                If FarmAPIService Is Nothing Then
                    FarmAPIService = New FarmServiceClient()
                End If

                If hdfFarmMasterID.Value.IsValueNullOrEmpty() Then
                    'Perform duplicate check.
                    If txtFarmOwner.Text.IsValueNullOrEmpty = False Then
                        Dim duplicateParams As New FarmGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .FarmOwnerFirstName = hdfFarmOwnerFirstName.Value,
                            .FarmOwnerLastName = hdfFarmOwnerLastName.Value, .RegionID = FarmAddress.SelectedRegionValue, .RayonID = FarmAddress.SelectedRayonValue,
                            .SettlementID = FarmAddress.SelectedSettlementValue}

                        Dim farms = FarmAPIService.FarmMasterGetListAsync(parameters:=duplicateParams).Result
                        If farms.Count > 0 Then
                            Dim duplicateRecordsFound As String = Resources.WarningMessages.Duplicate_Record_Found

                            For Each farm As VetFarmMasterGetListModel In farms
                                duplicateRecordsFound += farm.EIDSSFarmID & ", "
                            Next

                            'Remove last comma and space.
                            duplicateRecordsFound = duplicateRecordsFound.Remove(duplicateRecordsFound.Length - 2, 2)
                            duplicateRecordsFound &= ". " & Resources.Labels.Lbl_Continue_Save_Question_Text

                            RaiseEvent ShowWarningModal(messageType:=MessageType.DuplicateFarm, isConfirm:=True, message:=duplicateRecordsFound)
                        Else
                            ContinueSave()
                        End If
                    Else
                        ContinueSave()
                    End If
                Else
                    ContinueSave()
                End If
            Else
                DisplayFarmValidationErrors()
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
    Public Sub ContinueSave()

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Dim parameters = New FarmMasterSetParameters With {.LanguageID = GetCurrentLanguage(), .ForeignAddressIndicator = 0}
            parameters = Gather(Me, parameters, 3)
            parameters = Gather(FarmAddress, parameters, 3, True)

            If Session(FLOCKS_HERDS_LIST) Is Nothing Then
                Session(FLOCKS_HERDS_LIST) = New List(Of VetFarmHerdSpeciesGetListModel)()
            End If

            If Session(SPECIES_LIST) Is Nothing Then
                Session(SPECIES_LIST) = New List(Of VetFarmHerdSpeciesGetListModel)()
            End If

            parameters.HerdsOrFlocks = BuildFlockOrHerdParameters(CType(Session(FLOCKS_HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel)).Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).ToList())
            parameters.Species = BuildSpeciesParameters(CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel)).Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList())

            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If
            Dim result As List(Of VetFarmMasterSetModel) = FarmAPIService.SaveFarmMasterAsync(parameters).Result

            If result.Count > 0 Then
                If result.FirstOrDefault().ReturnCode = 0 Then 'Success
                    If hdfFarmMasterID.Value.IsValueNullOrEmpty() Or hdfFarmMasterID.Value < 0 Then
                        RaiseEvent CreateFarm(result.FirstOrDefault().FarmMasterID, txtFarmName.Text, result.FirstOrDefault().EIDSSFarmID.ToString(), GetLocalResourceObject("Lbl_Create_Success"))
                    Else
                        RaiseEvent UpdateFarm(result.FirstOrDefault().FarmMasterID, txtFarmName.Text, txtEIDSSFarmID.Text, GetLocalResourceObject("Lbl_Update_Success"))
                    End If

                    hdfFarmMasterID.Value = result.FirstOrDefault().FarmMasterID.ToString()
                    hdfFarmPanelController.Value = 3
                    divSelectablePreviewVeterinaryDiseaseReportList.Visible = True
                    btnAddVeterinaryDiseaseReport.Visible = True
                    divSelectablePreviewOutbreakCaseList.Visible = True

                    FillFarm(edit:=True)

                    ScriptManager.RegisterClientScriptBlock(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'))", True)
                Else 'Error
                    hdfFarmPanelController.Value = 3
                    upAddUpdateFarm.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'))", True)
                    RaiseEvent ShowErrorModal(messageType:=MessageType.CannotAddUpdate, message:=String.Empty)
                End If
            Else
                hdfFarmPanelController.Value = 3
                upAddUpdateFarm.Update()
                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'))", True)
                RaiseEvent ShowErrorModal(messageType:=MessageType.CannotAddUpdate, message:=String.Empty)
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
    ''' <param name="herds"></param>
    ''' <returns></returns>
    Private Function BuildFlockOrHerdParameters(herds As List(Of VetFarmHerdSpeciesGetListModel)) As List(Of HerdMasterParameters)

        Dim herdParameters As List(Of HerdMasterParameters) = New List(Of HerdMasterParameters)()
        Dim herdParameter As HerdMasterParameters

        For Each herdModel As VetFarmHerdSpeciesGetListModel In herds
            herdParameter = New HerdMasterParameters()
            With herdParameter
                .EIDSSHerdID = herdModel.EIDSSHerdID
                .HerdMasterID = herdModel.HerdMasterID
                .TotalAnimalQuantity = herdModel.TotalAnimalQuantity
                .RowAction = herdModel.RowAction
                .RowStatus = herdModel.RowStatus
            End With

            herdParameters.Add(herdParameter)
        Next

        Return herdParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="species"></param>
    ''' <returns></returns>
    Private Function BuildSpeciesParameters(species As List(Of VetFarmHerdSpeciesGetListModel)) As List(Of SpeciesMasterParameters)

        Dim speciesParameters As List(Of SpeciesMasterParameters) = New List(Of SpeciesMasterParameters)()
        Dim speciesParameter As SpeciesMasterParameters

        For Each speciesModel As VetFarmHerdSpeciesGetListModel In species
            speciesParameter = New SpeciesMasterParameters()
            With speciesParameter
                .HerdMasterID = speciesModel.HerdMasterID
                .SpeciesMasterID = speciesModel.SpeciesMasterID
                .SpeciesTypeID = speciesModel.SpeciesTypeID
                .TotalAnimalQuantity = speciesModel.TotalAnimalQuantity
                .RowAction = speciesModel.RowAction
                .RowStatus = speciesModel.RowStatus
            End With

            speciesParameters.Add(speciesParameter)
        Next

        Return speciesParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub Delete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            RaiseEvent ShowWarningModal(MessageType.ConfirmDeleteFarm, True, Nothing)
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
    Public Sub DeleteFarmMasterRecord()

        Try
            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If
            Dim returnResults As List(Of VetFarmMasterDelModel) = FarmAPIService.DeleteFarmMasterAsync(GetCurrentLanguage(), hdfFarmMasterID.Value).Result

            If returnResults.Count = 0 Then
                RaiseEvent ShowErrorModal(messageType:=MessageType.CannotAddUpdate, message:=Nothing)
            Else
                Select Case returnResults.FirstOrDefault().ReturnCode
                    Case 0
                        RaiseEvent ShowSuccessModal(messageType:=MessageType.DeleteSuccess)
                    Case 1
                        RaiseEvent ShowWarningModal(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Child_Objects_Message)
                        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'))", True)
                    Case 2
                        RaiseEvent ShowWarningModal(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Another_Object_Message)
                        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_hdfFarmPanelController'), document.getElementById('FarmSideBar'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_divFarmForm'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_ucAddUpdateFarm_btnSubmit'))", True)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DisplayFarmValidationErrors()

        'Paint all side bar items as passed validation and then correct those that failed.
        sbiFarmInformation.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sbiFarmAddress.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Page.Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim ctrl As Control = failedValidator
                Dim section As HtmlGenericControl = Nothing

                While (section Is Nothing)
                    ctrl = ctrl.Parent

                    section = TryCast(ctrl, HtmlGenericControl)
                    Try
                        Select Case section.ID
                            Case "FarmInformation"
                                sbiFarmInformation.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                                sbiFarmInformation.CssClass = "glyphicon glyphicon-remove"
                            Case "FarmAddressInformation"
                                sbiFarmAddress.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                                sbiFarmAddress.CssClass = "glyphicon glyphicon-remove"
                            Case "HerdSpeciesInformation"
                                sbiFlocksHerdsSpecies.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                                sbiFlocksHerdsSpecies.CssClass = "glyphicon glyphicon-remove"
                            Case Else
                                section = Nothing
                        End Select
                    Catch e As Exception
                    End Try
                End While
            End If
        Next

    End Sub

    ''' <summary>
    ''' Validator for the farm type radio button list.  This field must have an entry selected.
    ''' </summary>
    ''' <param name="source"></param>
    ''' <param name="args"></param>
    Private Sub FarmTypeID_ServerValidate(source As Object, args As ServerValidateEventArgs) Handles cvFarmTypeID.ServerValidate

        Try
            Dim valid As Boolean = False
            For Each li As ListItem In rblFarmTypeID.Items
                If li.Selected Then
                    valid = True
                    Exit For
                End If
            Next

            args.IsValid = valid
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
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        Try
            RaiseEvent ShowWarningModal(MessageType.CancelConfirmAddUpdate, True, Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Farm Owner Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PersonSearch_Click(sender As Object, e As EventArgs) Handles btnPersonSearch.Click

        Try
            RaiseEvent ShowSearchPersonModal()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmOwnerID"></param>
    ''' <param name="farmOwnerName"></param>
    ''' <param name="eidssPersonID"></param>
    Public Sub SetFarmOwner(farmOwnerID As Long, farmOwnerName As String, eidssPersonID As String, firstName As String, lastName As String)

        Try
            upAddUpdateFarm.Update()
            txtFarmOwner.Text = farmOwnerName & " " & Chr(150) & " " & eidssPersonID

            hdfFarmOwnerID.Value = farmOwnerID
            hdfFarmOwnerFirstName.Value = firstName
            hdfFarmOwnerLastName.Value = lastName
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Flock/Herd and Species Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessionSpeciesToSampleTypes"></param>
    Private Sub FillFlockHerdSpecies(monitoringSessionSpeciesToSampleTypes As List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))

        Try
            Dim farmHerdSpecies = New List(Of VetFarmHerdSpeciesGetListModel)()
            Dim parameters = New FarmHerdSpeciesGetListParameters With {.LanguageID = GetCurrentLanguage(), .FarmMasterID = hdfFarmMasterID.Value}

            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If
            farmHerdSpecies = FarmAPIService.FarmHerdSpeciesGetListAsync(parameters).Result

            farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().EIDSSHerdID = Resources.Labels.Lbl_Farm_Text & " (new 1)"

            'Per use case VUC17 rule, when the species to sample type combination from the monitoring session is only one, then default the farm inventory to the 
            'corresponding species to sample type combination's species type.
            If monitoringSessionSpeciesToSampleTypes.Count = 1 Then
                Dim herdFlock = New VetFarmHerdSpeciesGetListModel()

                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)

                herdFlock.RecordID = identity
                herdFlock.RecordType = RecordTypeConstants.Herd
                herdFlock.FarmID = hdfFarmMasterID.Value
                herdFlock.HerdMasterID = identity

                If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                    herdFlock.EIDSSHerdID = HerdSpeciesConstants.Flock & " " & farmHerdSpecies.Where(Function(x) x.RowAction = RecordConstants.Insert).Count.ToString
                Else
                    herdFlock.EIDSSHerdID = HerdSpeciesConstants.Herd & " " & farmHerdSpecies.Where(Function(x) x.RowAction = RecordConstants.Insert).Count.ToString
                End If

                herdFlock.TotalAnimalQuantity = 0
                herdFlock.DeadAnimalQuantity = 0
                herdFlock.SickAnimalQuantity = 0
                herdFlock.RowStatus = RecordConstants.ActiveRowStatus
                herdFlock.RowAction = RecordConstants.Insert

                farmHerdSpecies.Add(herdFlock)

                Dim species = New VetFarmHerdSpeciesGetListModel()

                hdfIdentity.Value += 1
                identity = (hdfIdentity.Value * -1)
                species.RecordID = identity
                species.RecordType = RecordTypeConstants.Species
                species.SpeciesID = identity
                species.SpeciesMasterID = identity
                species.SpeciesTypeID = monitoringSessionSpeciesToSampleTypes.FirstOrDefault().SpeciesTypeID
                species.SpeciesTypeName = monitoringSessionSpeciesToSampleTypes.FirstOrDefault().SpeciesTypeName
                species.FarmMasterID = hdfFarmMasterID.Value
                species.HerdMasterID = herdFlock.HerdMasterID
                species.TotalAnimalQuantity = 0
                species.DeadAnimalQuantity = 0
                species.SickAnimalQuantity = 0
                species.RowStatus = RecordConstants.ActiveRowStatus
                species.RowAction = RecordConstants.Insert
                farmHerdSpecies.Add(species)
            End If

            upFarmHerdSpecies.Update()

            Session(FLOCKS_HERDS_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType IsNot RecordTypeConstants.Species).OrderBy(Function(x) x.EIDSSHerdID).ThenBy(Function(y) y.SpeciesTypeName).ToList()
            Session(SPECIES_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType = RecordTypeConstants.Species).ToList()

            gvFlocksHerds.DataSource = Nothing
            gvFlocksHerds.DataSource = Session(FLOCKS_HERDS_LIST)
            gvFlocksHerds.DataBind()
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
    Protected Sub AddFlock_Click(sender As Object, e As EventArgs) Handles btnAddFlock.Click

        Try
            Dim farmHerdSpecies = TryCast(Session(FLOCKS_HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim herdFlock = New VetFarmHerdSpeciesGetListModel()

            If farmHerdSpecies Is Nothing Then
                farmHerdSpecies = New List(Of VetFarmHerdSpeciesGetListModel)()
            End If

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)

            herdFlock.RecordID = identity
            herdFlock.RecordType = RecordTypeConstants.Herd
            herdFlock.FarmID = hdfFarmMasterID.Value
            herdFlock.HerdMasterID = identity

            herdFlock.EIDSSHerdID = HerdSpeciesConstants.Flock & " " & farmHerdSpecies.Where(Function(x) x.RowAction = RecordConstants.Insert).Count.ToString

            herdFlock.TotalAnimalQuantity = 0
            herdFlock.DeadAnimalQuantity = 0
            herdFlock.SickAnimalQuantity = 0
            herdFlock.RowStatus = RecordConstants.ActiveRowStatus
            herdFlock.RowAction = RecordConstants.Insert

            farmHerdSpecies.Add(herdFlock)
            farmHerdSpecies.OrderBy(Function(x) x.EIDSSHerdID)
            Session(FLOCKS_HERDS_LIST) = farmHerdSpecies

            gvFlocksHerds.DataSource = Nothing
            gvFlocksHerds.DataSource = farmHerdSpecies
            gvFlocksHerds.DataBind()

            ToggleVisibility(SectionFlockHerdSpecies)

            upFarmHerdSpecies.Update()
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
    Private Sub AddHerd_Click(sender As Object, e As EventArgs) Handles btnAddHerd.Click

        Try
            Dim farmHerdSpecies = TryCast(Session(FLOCKS_HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim herdFlock = New VetFarmHerdSpeciesGetListModel()

            If farmHerdSpecies Is Nothing Then
                farmHerdSpecies = New List(Of VetFarmHerdSpeciesGetListModel)()
            End If

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)

            herdFlock.RecordID = identity
            herdFlock.RecordType = RecordTypeConstants.Herd
            herdFlock.FarmID = hdfFarmMasterID.Value
            herdFlock.HerdMasterID = identity

            herdFlock.EIDSSHerdID = HerdSpeciesConstants.Herd & " " & farmHerdSpecies.Where(Function(x) x.RowAction = RecordConstants.Insert).Count.ToString

            herdFlock.TotalAnimalQuantity = 0
            herdFlock.DeadAnimalQuantity = 0
            herdFlock.SickAnimalQuantity = 0
            herdFlock.RowStatus = RecordConstants.ActiveRowStatus
            herdFlock.RowAction = RecordConstants.Insert

            farmHerdSpecies.Add(herdFlock)
            farmHerdSpecies.OrderBy(Function(x) x.EIDSSHerdID)
            Session(FLOCKS_HERDS_LIST) = farmHerdSpecies

            gvFlocksHerds.DataSource = Nothing
            gvFlocksHerds.DataSource = farmHerdSpecies
            gvFlocksHerds.DataBind()

            ToggleVisibility(SectionFlockHerdSpecies)

            upFarmHerdSpecies.Update()
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
    Protected Sub FarmSpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            UpdateFlockHerdSpecies()
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
    Protected Sub FarmTotalAnimalQuantity_TextChanged(sender As Object, e As EventArgs)

        Try
            UpdateFlockHerdSpecies()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub RollUp()

        Dim herds As List(Of VetFarmHerdSpeciesGetListModel) = CType(Session(FLOCKS_HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
        Dim speciesList As List(Of VetFarmHerdSpeciesGetListModel) = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

        If Not speciesList Is Nothing Then
            Dim herd As VetFarmHerdSpeciesGetListModel
            Dim species As VetFarmHerdSpeciesGetListModel

            Dim _herds As List(Of VetFarmHerdSpeciesGetListModel) = New List(Of VetFarmHerdSpeciesGetListModel)()
            Dim _herd As VetFarmHerdSpeciesGetListModel = New VetFarmHerdSpeciesGetListModel

            For Each herd In herds
                Dim intSick As Short = 0
                Dim intDead As Short = 0
                Dim intTotal As Short = 0

                If Not herd.RecordType = HerdSpeciesConstants.Farm Then
                    For Each species In speciesList.Where(Function(x) x.HerdMasterID = herd.HerdMasterID And x.RowStatus = 0).ToList()
                        If (Not species.TotalAnimalQuantity Is Nothing) Then
                            intTotal += species.TotalAnimalQuantity
                        End If
                    Next

                    herd.TotalAnimalQuantity = intTotal
                End If

                _herds.Add(herd)
            Next

            _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().TotalAnimalQuantity = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.TotalAnimalQuantity)

            hdfTotalAnimalQuantity.Value = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.TotalAnimalQuantity)

            Session(FLOCKS_HERDS_LIST) = _herds
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub FlocksHerds_ItemCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFlocksHerds.RowCommand

        Try
            Dim farmHerdSpecies = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            If farmHerdSpecies Is Nothing Then
                farmHerdSpecies = New List(Of VetFarmHerdSpeciesGetListModel)()
            End If

            Dim species = New VetFarmHerdSpeciesGetListModel()

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            species.RecordID = identity
            species.RecordType = RecordTypeConstants.Species
            species.SpeciesID = identity
            species.SpeciesMasterID = identity
            species.FarmMasterID = hdfFarmMasterID.Value
            species.HerdMasterID = CType(e.CommandArgument, Long)
            species.TotalAnimalQuantity = 0
            species.DeadAnimalQuantity = 0
            species.SickAnimalQuantity = 0
            species.RowStatus = RecordConstants.ActiveRowStatus
            species.RowAction = RecordConstants.Insert
            farmHerdSpecies.Add(species)

            ToggleVisibility(SectionFlockHerdSpecies)
            Session(SPECIES_LIST) = farmHerdSpecies
            gvFlocksHerds.DataSource = CType(Session(FLOCKS_HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            gvFlocksHerds.DataBind()
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
    Protected Sub FlocksHerds_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvFlocksHerds.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then

            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim lblAddSpecies As Label = CType(e.Row.FindControl("lblAddSpecies"), Label)
                    Dim btnAddSpecies As LinkButton = CType(e.Row.FindControl("btnAddSpecies"), LinkButton)
                    Dim lblEIDSSHerdID As Label = CType(e.Row.FindControl("lblEIDSSHerdID"), Label)

                    If e.Row.RowIndex = 0 Then
                        btnAddSpecies.Visible = False
                    End If

                    If e.Row.DataItem.RecordType = HerdSpeciesConstants.Farm Then
                        lblEIDSSHerdID.Text = Resources.Labels.Lbl_Farm_Text & " " & e.Row.DataItem.EIDSSHerdID.ToString().Remove(0, 4)
                    ElseIf e.Row.DataItem.RecordType = HerdSpeciesConstants.Herd Then
                        If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                            lblEIDSSHerdID.Text = Resources.Labels.Lbl_Flock_Text & " " & e.Row.DataItem.EIDSSHerdID.ToString().Remove(0, 5)
                        Else
                            lblEIDSSHerdID.Text = Resources.Labels.Lbl_Herd_Text & " " & e.Row.DataItem.EIDSSHerdID.ToString().Remove(0, 4)
                        End If
                    End If

                    Dim speciesList As List(Of VetFarmHerdSpeciesGetListModel) = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

                    If Not speciesList Is Nothing Then
                        Dim gvSpecies As GridView = CType(e.Row.FindControl("gvSpecies"), GridView)

                        gvSpecies.DataSource = speciesList.Where(Function(x) x.HerdMasterID = e.Row.DataItem.HerdMasterID).ToList()
                        gvSpecies.DataBind()
                    End If
                End If
            End If
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
    Protected Sub FlocksHerds_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFlocksHerds.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    'DeleteFarmFlockSpecies(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                Case GridViewCommandConstants.UpdateCommand
                    e.Handled = True
            End Select
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
    Protected Sub Species_RowDataBound(sender As Object, e As GridViewRowEventArgs)

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim ddlSpeciesTypeID As DropDownList = CType(e.Row.FindControl("ddlFarmSpeciesTypeID"), DropDownList)

                If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                    BaseReferenceLookUp(ddlSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.AvianHACode, True)
                    ddlSpeciesTypeID.SelectedValue = e.Row.DataItem.SpeciesTypeID
                Else
                    BaseReferenceLookUp(ddlSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.LivestockHACode, True)
                    ddlSpeciesTypeID.SelectedValue = e.Row.DataItem.SpeciesTypeID
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub UpdateFlockHerdSpecies()

        Try
            Dim farmHerdSpecies = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim record As VetFarmHerdSpeciesGetListModel
            Dim index As Integer = 0

            For Each row As GridViewRow In gvFlocksHerds.Rows
                Dim gvSpecies As GridView = CType(row.FindControl("gvSpecies"), GridView)

                If Not gvSpecies Is Nothing Then
                    For Each speciesRow As GridViewRow In gvSpecies.Rows
                        Dim hdfSpeciesMasterID As HiddenField = CType(speciesRow.FindControl("hdfSpeciesMasterID"), HiddenField)
                        Dim ddlSpeciesTypeID As DropDownList = CType(speciesRow.FindControl("ddlFarmSpeciesTypeID"), WebControls.DropDownList)
                        Dim txtTotalAnimalQuantity As TextBox = CType(speciesRow.FindControl("txtFarmTotalAnimalQuantity"), TextBox)

                        record = New VetFarmHerdSpeciesGetListModel()
                        record = farmHerdSpecies.Where(Function(x) x.SpeciesMasterID = hdfSpeciesMasterID.Value).FirstOrDefault()

                        If hdfRowAction.Value = RecordConstants.Read Then
                            record.RowAction = RecordConstants.Update
                        End If

                        record.SpeciesTypeID = ddlSpeciesTypeID.SelectedValue
                        record.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                        record.TotalAnimalQuantity = If(String.IsNullOrEmpty(txtTotalAnimalQuantity.Text), 0, Short.Parse(txtTotalAnimalQuantity.Text))

                        index = farmHerdSpecies.IndexOf(record)
                        farmHerdSpecies(index) = record
                    Next
                End If
            Next

            Session(SPECIES_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList()

            RollUp()

            gvFlocksHerds.DataSource = Session(FLOCKS_HERDS_LIST)
            gvFlocksHerds.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Veterinary Disease Report Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillVeterinaryDiseaseReportList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim veterinaryDiseaseReports = New List(Of VetDiseaseReportGetListModel)()
            Dim parameters As VeterinaryDiseaseReportGetListParameters
            parameters = New VeterinaryDiseaseReportGetListParameters()
            parameters = Gather(Me, parameters, 3)
            parameters.LanguageID = GetCurrentLanguage()
            parameters.FarmMasterID = hdfFarmMasterID.Value
            parameters.OutbreakCasesIndicator = 0
            parameters.PaginationSetNumber = paginationSetNumber

            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            veterinaryDiseaseReports = VeterinaryAPIService.GetVeterinaryDiseaseReportListAsync(parameters).Result
            Session(SESSION_VETERINARY_DISEASE_REPORT_LIST) = veterinaryDiseaseReports
            BindVeterinaryDiseaseReportGridView()

            FillVeterinaryDiseaseReportPager(lblVeterinaryDiseaseReportNumberOfRecords.Text, pageIndex)
            ViewState(VETERINARY_DISEASE_REPORT_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillVeterinaryDiseaseReportPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Try
            Dim pages As New List(Of ListItem)()
            Dim startIndex As Integer, endIndex As Integer
            Dim pagerSpan As Integer = 5

            If recordCount > 0 Then
                divVeterinaryDiseaseReportPager.Visible = True

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

                rptVeterinaryDiseaseReportPager.DataSource = pages
                rptVeterinaryDiseaseReportPager.DataBind()
            Else
                divVeterinaryDiseaseReportPager.Visible = False
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
    Protected Sub VeterinaryDiseaseReportPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, Button).CommandArgument)

            lblVeterinaryDiseaseReportPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvVeterinaryDiseaseReports.PageSize)

            If Not ViewState(VETERINARY_DISEASE_REPORT_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, Button).Text
                    Case PagingConstants.PreviousButtonText
                        gvVeterinaryDiseaseReports.PageIndex = gvVeterinaryDiseaseReports.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvVeterinaryDiseaseReports.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvVeterinaryDiseaseReports.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvVeterinaryDiseaseReports.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvVeterinaryDiseaseReports.PageIndex = gvVeterinaryDiseaseReports.PageSize - 1
                        Else
                            gvVeterinaryDiseaseReports.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillVeterinaryDiseaseReportList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvVeterinaryDiseaseReports.PageIndex = gvVeterinaryDiseaseReports.PageSize - 1
                Else
                    gvVeterinaryDiseaseReports.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If

                BindVeterinaryDiseaseReportGridView()
                FillVeterinaryDiseaseReportPager(lblVeterinaryDiseaseReportNumberOfRecords.Text, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindVeterinaryDiseaseReportGridView()

        Try
            Dim veterinaryDiseaseReports = CType(Session(SESSION_VETERINARY_DISEASE_REPORT_LIST), List(Of VetDiseaseReportGetListModel))

            If (Not ViewState(VETERINARY_DISEASE_REPORT_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(VETERINARY_DISEASE_REPORT_SORT_DIRECTION) = SortConstants.Ascending Then
                    veterinaryDiseaseReports = veterinaryDiseaseReports.OrderBy(Function(x) x.GetType().GetProperty(ViewState(VETERINARY_DISEASE_REPORT_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    veterinaryDiseaseReports = veterinaryDiseaseReports.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(VETERINARY_DISEASE_REPORT_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            End If

            gvVeterinaryDiseaseReports.DataSource = veterinaryDiseaseReports
            gvVeterinaryDiseaseReports.DataBind()
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
    Protected Sub VeterinaryDiseaseReports_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVeterinaryDiseaseReports.Sorting

        Try
            ViewState(VETERINARY_DISEASE_REPORT_SORT_DIRECTION) = IIf(ViewState(VETERINARY_DISEASE_REPORT_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(VETERINARY_DISEASE_REPORT_SORT_EXPRESSION) = e.SortExpression

            BindVeterinaryDiseaseReportGridView()
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
    Protected Sub AddVeterinaryDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnAddVeterinaryDiseaseReport.Click

        Try
            ViewState(CALLER_KEY) = hdfFarmMasterID.Value

            If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                ViewState(CALLER) = ApplicationActions.FarmAddAvianVeterinaryDiseaseReport.ToString()
                SaveEIDSSViewState(ViewState)
                Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
            Else
                ViewState(CALLER) = ApplicationActions.FarmAddLivestockVeterinaryDiseaseReport.ToString()
                SaveEIDSSViewState(ViewState)
                Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
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
    ''' <param name="veterinaryDiseaseReportID"></param>
    ''' <param name="reportTypeID"></param>
    Private Sub SelectDiseaseReport(ByVal veterinaryDiseaseReportID As Long, reportTypeID As Long)

        ViewState(CALLER_KEY) = veterinaryDiseaseReportID.ToString()
        ViewState(CALLER) = CallerPages.FarmWithVeterinaryDiseaseReport

        SaveEIDSSViewState(ViewState)

        If reportTypeID = VeterinaryDiseaseReportConstants.AvianDiseaseReportCaseType Then
            Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
        Else
            Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub VeterinaryDiseaseReports_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVeterinaryDiseaseReports.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.SelectCommand
                    Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                    SelectDiseaseReport(commandArguments(0), commandArguments(1))
                Case "Select Report"
                    SelectReport(e.CommandArgument)
            End Select
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
    ''' <param name="veterinaryDiseaseReportID"></param>
    Private Sub SelectReport(veterinaryDiseaseReportID As Long)

        Try
            ViewState(CALLER_KEY) = veterinaryDiseaseReportID.ToString()
            ViewState(CALLER) = CallerPages.FarmWithVeterinaryDiseaseReport
            SaveEIDSSViewState(ViewState)

            If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL))
            Else
                Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL))
            End If
        Catch ex As Exception

        End Try

    End Sub

#End Region

#Region "Outbreak Case Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillOutbreakCaseList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim outbreakCases = New List(Of VetDiseaseReportGetListModel)()
            Dim parameters As VeterinaryDiseaseReportGetListParameters
            parameters = New VeterinaryDiseaseReportGetListParameters()
            parameters = Gather(Me, parameters, 3)
            parameters.LanguageID = GetCurrentLanguage()
            parameters.FarmMasterID = hdfFarmMasterID.Value
            parameters.OutbreakCasesIndicator = 1
            parameters.PaginationSetNumber = paginationSetNumber

            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            outbreakCases = VeterinaryAPIService.GetVeterinaryDiseaseReportListAsync(parameters).Result
            Session(SESSION_OUTBREAK_CASE_LIST) = outbreakCases
            BindOutbreakCaseGridView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillOutbreakCasePager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Try
            Dim pages As New List(Of ListItem)()
            Dim startIndex As Integer, endIndex As Integer
            Dim pagerSpan As Integer = 5

            If recordCount > 0 Then
                divOutbreakCasePager.Visible = True

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

                rptOutbreakCasePager.DataSource = pages
                rptOutbreakCasePager.DataBind()
            Else
                divOutbreakCasePager.Visible = False
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
    Protected Sub OutbreakCasePage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, Button).CommandArgument)

            lblOutbreakCasePageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvOutbreakCases.PageSize)

            If Not ViewState(OUTBREAK_CASE_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, Button).Text
                    Case PagingConstants.PreviousButtonText
                        gvOutbreakCases.PageIndex = gvOutbreakCases.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvOutbreakCases.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvOutbreakCases.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvOutbreakCases.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvOutbreakCases.PageIndex = gvOutbreakCases.PageSize - 1
                        Else
                            gvOutbreakCases.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillOutbreakCaseList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvOutbreakCases.PageIndex = gvOutbreakCases.PageSize - 1
                Else
                    gvOutbreakCases.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If

                BindOutbreakCaseGridView()
                FillOutbreakCasePager(lblOutbreakCaseNumberOfRecords.Text, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindOutbreakCaseGridView()

        Try
            Dim outbreakCases = CType(Session(SESSION_OUTBREAK_CASE_LIST), List(Of VetDiseaseReportGetListModel))

            If (Not ViewState(OUTBREAK_CASE_SORT_EXPRESSION) Is Nothing) Then
                If ViewState(OUTBREAK_CASE_SORT_DIRECTION) = SortConstants.Ascending Then
                    outbreakCases = outbreakCases.OrderBy(Function(x) x.GetType().GetProperty(ViewState(OUTBREAK_CASE_SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    outbreakCases = outbreakCases.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(OUTBREAK_CASE_SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            End If

            gvOutbreakCases.DataSource = outbreakCases

            If outbreakCases.Count > 0 Then
                gvOutbreakCases.DataBind()
                divSelectablePreviewOutbreakCaseList.Visible = True
            Else
                divSelectablePreviewOutbreakCaseList.Visible = False
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
    Protected Sub OutbreakCases_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvOutbreakCases.Sorting

        Try
            ViewState(OUTBREAK_CASE_SORT_DIRECTION) = IIf(ViewState(OUTBREAK_CASE_SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(OUTBREAK_CASE_SORT_EXPRESSION) = e.SortExpression

            BindOutbreakCaseGridView()
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
    Protected Sub AddOutbreakCase_Click(sender As Object, e As EventArgs) Handles btnAddOutbreakCase.Click

        Try
            ViewState(CALLER_KEY) = hdfFarmMasterID.Value
            ViewState(CALLER) = CallerPages.Farm

            SaveEIDSSViewState(ViewState)

            If rblFarmTypeID.SelectedValue = FarmTypes.AvianFarmType Then
                Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
            Else
                Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
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
    ''' <param name="outbreakCaseID"></param>
    Private Sub SelectOutbreakCase(ByVal outbreakCaseID As Long)

        Try
            ViewState(CALLER_KEY) = outbreakCaseID.ToString()
            ViewState(CALLER) = ApplicationActions.FarmAddOutbreakCase
            SaveEIDSSViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.OutbreakCaseReportURL), True)
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
    Protected Sub OutbreakCases_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOutbreakCases.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.SelectCommand
                    SelectOutbreakCase(e.CommandArgument)
            End Select
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class