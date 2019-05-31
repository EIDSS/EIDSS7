Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain

<ViewStateModeById()>
Public Class LocationUserControl
    Inherits UserControl

#Region "Private Properties"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(LocationUserControl))

    Public Event ItemSelected(id As String)
    Private globalSiteDetails As GblSiteGetDetailModel

#Region "Labels"

    Protected Property LblCountry As Label

    Protected Property LblRegion As Label

    Protected Property LblRayon As Label

    Protected Property LblTown As Label

    Protected Property LblStreet As Label

    Protected Property LblBuilding As Label

    Protected Property LblHouse As Label

    Protected Property LblApartment As Label

    Protected Property LblPostalCode As Label

    Protected Property LblLatitude As Label

    Protected Property LblLongitude As Label

    Protected Property LblElevation As Label

    Protected Property LblMap As Label

#End Region

#Region "Controls"

    Protected Property DdlCountry As DropDownList

    Protected Property DdlRegion As DropDownList

    Protected Property DdlRayon As DropDownList

    Protected Property DdlSettlement As DropDownList

    Protected Property TxtStreetName As TextBox

    Protected Property TxtBuilding As TextBox

    Protected Property TxtHouse As TextBox

    Protected Property TxtApartment As TextBox

    Protected Property DdlPostalCode As DropDownList

    Protected Property TxtLatitude As NumericSpinner

    Protected Property TxtLongitude As NumericSpinner

    Protected Property TxtElevation As NumericSpinner

    Protected Property BtnMap As HyperLink

    Protected Property BtnCopyCoordinates As HtmlButton

    Protected Property Map As HtmlGenericControl
#End Region

#Region "Validation Controls"

    Protected Property ValCountry As RequiredFieldValidator

    Protected Property ValRegion As RequiredFieldValidator

    Protected Property ValRayon As RequiredFieldValidator

    Protected Property ValTown As RequiredFieldValidator

    Protected Property ValStreet As RequiredFieldValidator

    Protected Property ValBuilding As RequiredFieldValidator

    Protected Property ValHouse As RequiredFieldValidator

    Protected Property ValApartment As RequiredFieldValidator

    Protected Property ValPostalCode As RequiredFieldValidator

    Protected Property ValLatitude As RequiredFieldValidator

    Protected Property ValLongitude As RequiredFieldValidator

    Protected Property ValElevation As RequiredFieldValidator

#End Region

#Region "Visibility Methods"

    Private IsCountryVisible As Boolean = True
    Private IsCountryOnlyVisible As Boolean = False
    Private IsRegionVisible As Boolean = True
    Private IsRayonVisible As Boolean = True
    Private IsForceEditRayonFill As Boolean = False
    Private IsTownVisible As Boolean = True
    Private IsStreetVisible As Boolean = True
    Private IsBuildingHouseApartmentVisible As Boolean = True
    Private IsBuildingVisible As Boolean = True
    Private IsHouseVisible As Boolean = True
    Private IsApartmentVisible As Boolean = True
    Private IsPostalCodeVisible As Boolean = True
    Private IsCoordinatesVisible As Boolean = True
    Private IsLatitudeVisible As Boolean = True
    Private IsLongitudeVisible As Boolean = True
    Private IsMapVisible As Boolean = True
    Private IsElevationVisible As Boolean = True

#End Region

#End Region

#Region "Public Properties"

    Public Property IsHorizontalLayout As Boolean
    Public Property LocationCountryID As Long?
    Public Property LocationCountryName As String
    Public Property LocationRegionID As Long?
    Public Property LocationRegionName As String
    Public Property LocationRayonID As Long?
    Public Property LocationRayonName As String
    Public Property LocationSettlementID As Long?
    Public Property LocationSettlementName As String
    Public Property LocationPostalCodeID As Long?
    Public Property LocationPostalCodeName As String
    Public Property SelectionNotification As Boolean

    Public Property DisplayPrePopulatedRegionRayon As Boolean

    Private isAutoPostBack As Boolean = True
    Private countryValue

    Public Property SelectedCountryValue As String
        Get
            If String.IsNullOrEmpty(countryValue) Then
                If String.IsNullOrEmpty(ddlCountry.SelectedValue) Then
                    countryValue = "-1"
                Else
                    countryValue = ddlCountry.SelectedValue
                End If
            End If
            Return countryValue
        End Get
        Set(value As String)
            countryValue = value
        End Set
    End Property

    Private countryText As String

    Public Property SelectedCountryText As String
        Get
            If String.IsNullOrEmpty(countryText) Then
                If IsNothing(ddlCountry.SelectedItem) Then
                    countryText = Nothing
                Else
                    countryText = ddlCountry.SelectedItem.Text
                End If
            End If
            Return countryText
        End Get
        Set(value As String)
            countryText = value
        End Set
    End Property

    Private regionValue As String

    Public Property SelectedRegionValue As String
        Get
            If String.IsNullOrEmpty(regionValue) Then
                If String.IsNullOrEmpty(ddlRegion.SelectedValue) Then
                    regionValue = "-1"
                Else
                    regionValue = ddlRegion.SelectedValue
                End If
            End If
            Return regionValue
        End Get
        Set(value As String)
            regionValue = value
        End Set
    End Property

    Private regionText As String

    Public Property SelectedRegionText As String
        Get
            If String.IsNullOrEmpty(regionText) Then
                If IsNothing(ddlRegion.SelectedItem) Then
                    regionText = String.Empty
                Else
                    regionText = ddlRegion.SelectedItem.Text
                End If
            End If
            Return regionText
        End Get
        Set
            regionText = Value
        End Set
    End Property

    Private rayonValue As String

    Public Property SelectedRayonValue As String
        Get
            If String.IsNullOrEmpty(rayonValue) Then
                If String.IsNullOrEmpty(ddlRayon.SelectedValue) Then
                    rayonValue = "-1"
                Else
                    rayonValue = ddlRayon.SelectedValue
                End If
            End If
            Return rayonValue
        End Get
        Set(value As String)
            rayonValue = value
        End Set
    End Property

    Private rayonText As String
    Public Property SelectedRayonText As String
        Get
            If String.IsNullOrEmpty(rayonText) Then
                If IsNothing(ddlRayon.SelectedItem) Then
                    rayonText = String.Empty
                Else
                    rayonText = ddlRayon.SelectedItem.Text
                End If
            End If
            Return rayonText
        End Get
        Set(value As String)
            rayonText = value
        End Set
    End Property

    Private settlementValue As String

    Public Property SelectedSettlementValue As String
        Get
            If String.IsNullOrEmpty(settlementValue) Then
                If String.IsNullOrEmpty(ddlSettlement.SelectedValue) Then
                    settlementValue = "-1"
                Else
                    settlementValue = ddlSettlement.SelectedValue
                End If
            End If
            Return settlementValue
        End Get
        Set(value As String)
            settlementValue = value
        End Set
    End Property

    Private settlementText As String

    Public Property SelectedSettlementText As String
        Get
            If String.IsNullOrEmpty(settlementText) Then
                If IsNothing(ddlSettlement.SelectedItem) Then
                    settlementText = String.Empty
                Else
                    settlementText = ddlSettlement.SelectedItem.Text
                End If
            End If
            Return settlementText
        End Get
        Set(value As String)
            settlementText = value
        End Set
    End Property

    Private postalValue As String

    Public Property SelectedPostalValue As String
        Get
            If String.IsNullOrEmpty(postalValue) Then
                If String.IsNullOrEmpty(ddlPostalCode.SelectedValue) Then
                    postalValue = "-1"
                Else
                    postalValue = ddlPostalCode.SelectedValue
                End If
            End If
            Return postalValue
        End Get
        Set(value As String)
            postalValue = value
        End Set
    End Property

    Private postalText As String

    Public Property SelectedPostalText As String
        Get
            If String.IsNullOrEmpty(postalText) Then
                If IsNothing(ddlPostalCode.SelectedItem) Then
                    postalText = String.Empty
                Else
                    postalText = ddlPostalCode.SelectedItem.Text
                End If

            End If
            Return postalText
        End Get
        Set(value As String)
            postalText = value
        End Set
    End Property

    Public Property StreetText As String
        Get
            Return txtStreetName.Text
        End Get
        Set(value As String)
            txtStreetName.Text = value
        End Set
    End Property

    Public Property BuildingText As String
        Get
            Return txtBuilding.Text
        End Get
        Set(value As String)
            txtBuilding.Text = value
        End Set
    End Property

    Public Property HouseText As String
        Get
            Return txtHouse.Text
        End Get
        Set(value As String)
            txtHouse.Text = value
        End Set
    End Property

    Public Property AppartmentText As String
        Get
            Return txtApartment.Text
        End Get
        Set(value As String)
            txtApartment.Text = value
        End Set
    End Property

    Public Property LatitudeText As String
        Get
            Return txtLatitude.Text
        End Get
        Set(value As String)
            txtLatitude.Text = value
        End Set
    End Property

    Public Property LongitudeText As String
        Get
            Return txtLongitude.Text
        End Get
        Set(value As String)
            txtLongitude.Text = value
        End Set
    End Property

    Public Property ElevationText As String
        Get
            Return txtElevation.Text
        End Get
        Set(value As String)
            txtElevation.Text = value
        End Set
    End Property

    Public Property ValidationGroup As String

    Public Property IsDbRequiredCountry As Boolean

    Public Property IsDbRequiredRegion As Boolean

    Public Property IsDbRequiredRayon As Boolean

    Public Property IsDbRequiredTown As Boolean

    Public Property IsDbRequiredStreet As Boolean

    Public Property IsDbRequiredBuilding As Boolean

    Public Property IsDbRequiredHouse As Boolean

    Public Property IsDbRequiredApartment As Boolean

    Public Property IsDbRequiredPostalCode As Boolean

    Public Property IsDbRequiredLatitude As Boolean

    Public Property IsDbRequiredLongitude As Boolean

    Public Property IsDbRequiredElevation As Boolean

#Region "Visibility Management"

    Public Property ShowCountry As Boolean
        Get
            Return IsCountryVisible
        End Get
        Set(value As Boolean)
            IsCountryVisible = value
        End Set
    End Property

    Public Property ShowCountryOnly As Boolean
        Get
            Return IsCountryOnlyVisible
        End Get
        Set(value As Boolean)
            IsCountryOnlyVisible = value
        End Set
    End Property
    Public Property ShowRegion As Boolean
        Get
            Return IsRegionVisible
        End Get
        Set(value As Boolean)
            IsRegionVisible = value
        End Set
    End Property
    Public Property ShowRayon As Boolean
        Get
            Return IsRayonVisible
        End Get
        Set(value As Boolean)
            IsRayonVisible = value
        End Set
    End Property

    Public Property ForceEditRayonFill As Boolean
        Get
            Return IsForceEditRayonFill
        End Get

        Set(value As Boolean)
            IsForceEditRayonFill = value
        End Set
    End Property
    Public Property ShowTownOrVillage As Boolean
        Get
            Return IsTownVisible
        End Get
        Set(value As Boolean)
            IsTownVisible = value
        End Set
    End Property
    Public Property ShowStreet As Boolean
        Get
            Return IsStreetVisible
        End Get
        Set(value As Boolean)
            IsStreetVisible = value
        End Set
    End Property
    Public Property ShowBuildingHouseApartmentGroup As Boolean
        Get
            Return IsBuildingHouseApartmentVisible
        End Get
        Set(value As Boolean)
            IsBuildingHouseApartmentVisible = value
        End Set
    End Property
    Public Property ShowBuilding As Boolean
        Get
            Return IsBuildingVisible
        End Get
        Set(value As Boolean)
            IsBuildingVisible = value
        End Set
    End Property
    Public Property ShowHouse As Boolean
        Get
            Return IsHouseVisible
        End Get
        Set(value As Boolean)
            IsHouseVisible = value
        End Set
    End Property
    Public Property ShowApartment As Boolean
        Get
            Return IsApartmentVisible
        End Get
        Set(value As Boolean)
            IsApartmentVisible = value
        End Set
    End Property
    Public Property ShowPostalCode As Boolean
        Get
            Return IsPostalCodeVisible
        End Get
        Set(value As Boolean)
            IsPostalCodeVisible = value
        End Set
    End Property
    Public Property ShowCoordinates As Boolean
        Get
            Return IsCoordinatesVisible
        End Get
        Set(value As Boolean)
            IsCoordinatesVisible = value
        End Set
    End Property

    Public Property ShowLatitude As Boolean
        Get
            Return IsLatitudeVisible
        End Get
        Set(value As Boolean)
            IsLatitudeVisible = value
        End Set
    End Property
    Public Property ShowLongitude As Boolean
        Get
            Return IsLongitudeVisible
        End Get
        Set(value As Boolean)
            IsLongitudeVisible = value
        End Set
    End Property
    Public Property ShowMap As Boolean
        Get
            Return IsMapVisible
        End Get
        Set(value As Boolean)
            IsMapVisible = value
        End Set
    End Property
    Public Property ShowElevation As Boolean
        Get
            Return IsElevationVisible
        End Get
        Set(value As Boolean)
            IsElevationVisible = value
        End Set
    End Property
#End Region

#End Region

#Region "Initialization Routine"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="e"></param>
    Protected Overrides Sub OnInit(e As EventArgs)

        MyBase.OnInit(e)
        'Initialize Inputs first
        InitializeDropDown(DdlCountry, $"ddl{ID}idfsCountry")
        InitializeDropDown(DdlRegion, $"ddl{ID}idfsRegion")
        InitializeDropDown(DdlRayon, $"ddl{ID}idfsRayon")
        InitializeDropDown(DdlSettlement, $"ddl{ID}idfsSettlement")
        InitializeDropDown(DdlPostalCode, $"ddl{ID}idfsPostalCode")
        InitializeSpinner(TxtLatitude, $"txt{ID}strLatitude", "90", "-90")
        InitializeSpinner(TxtLongitude, $"txt{ID}strLongitude", "180", "-180")
        InitializeSpinner(TxtElevation, $"txt{ID}strElevation", "10000", "-10000", True)
        InitializeTextBox(TxtStreetName, $"txt{ID}strStreetName")
        InitializeTextBox(TxtBuilding, $"txt{ID}strBuilding")
        InitializeTextBox(TxtHouse, $"txt{ID}strHouse")
        InitializeTextBox(TxtApartment, $"txt{ID}strApartment")
        InitializeMapButton(btnMap, $"btn{ID}Map")

        'Add Event Handlers
        AddHandler DdlCountry.SelectedIndexChanged, AddressOf Country_SelectedIndexChanged
        AddHandler DdlRegion.SelectedIndexChanged, AddressOf Region_SelectedIndexChanged
        AddHandler DdlRayon.SelectedIndexChanged, AddressOf Rayon_SelectedIndexChanged
        AddHandler DdlSettlement.SelectedIndexChanged, AddressOf Settlement_SelectedIndexChanged

        'Initialize Labels
        InitializeLabel(LblCountry, DdlCountry.ID, "Lbl_Country")
        InitializeLabel(LblRegion, DdlRegion.ID, "Lbl_Region")
        InitializeLabel(LblRayon, DdlRayon.ID, "Lbl_Rayon")
        InitializeLabel(LblTown, DdlSettlement.ID, "Lbl_Town_or_Village")
        InitializeLabel(LblStreet, TxtStreetName.ID, "Lbl_Street")
        InitializeLabel(LblBuilding, TxtBuilding.ID, "Lbl_Building")
        InitializeLabel(LblHouse, TxtHouse.ID, "Lbl_House")
        InitializeLabel(LblApartment, TxtApartment.ID, "Lbl_Apartment")
        InitializeLabel(LblPostalCode, DdlPostalCode.ID, "Lbl_Postal_Code")
        InitializeLabel(LblLatitude, TxtLatitude.ID, "Lbl_Latitude")
        InitializeLabel(LblLongitude, TxtLongitude.ID, "Lbl_Longitude")
        InitializeLabel(LblElevation, TxtElevation.ID, "Lbl_Elevation")
        InitializeLabel(LblMap, BtnMap.ID, "Lbl_Map")

        'initialize validation controls
        InitializeValidator(ValCountry, $"ddl{ID}idfsCountry", "Val_Country", True)
        InitializeValidator(ValRegion, $"ddl{ID}idfsRegion", "Val_Region", True)
        InitializeValidator(ValRayon, $"ddl{ID}idfsRayon", "Val_Rayon", True)
        InitializeValidator(ValTown, $"ddl{ID}idfsSettlement", "Val_Town_or_Village", True)
        InitializeValidator(ValStreet, $"txt{ID}strStreetName", "Val_Street")
        InitializeValidator(ValBuilding, $"txt{ID}strBuilding", "Val_Building")
        InitializeValidator(ValHouse, $"txt{ID}strHouse", "Val_House")
        InitializeValidator(ValApartment, $"txt{ID}strApartment", "Val_Apartment")
        InitializeValidator(ValPostalCode, $"ddl{ID}idfsPostalCode", "Val_Postal_Code", True)
        InitializeValidator(ValLatitude, $"txt{ID}strLatitude", "Val_Latitude")
        InitializeValidator(ValLongitude, $"txt{ID}strLongitude", "Val_Longitude")
        InitializeValidator(ValElevation, $"txt{ID}strElevation", "Val_Elevation")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="label"></param>
    ''' <param name="associatedCtrl"></param>
    ''' <param name="resourceKey"></param>
    Private Sub InitializeLabel(ByRef label As Label, ByVal associatedCtrl As String, ByVal resourceKey As String)

        label = New Label With {.AssociatedControlID = associatedCtrl, .CssClass = "control-label", .Text = GetLocalResourceObject(resourceKey + ".Text"), .ToolTip = GetLocalResourceObject(resourceKey + ".ToolTip")}

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="id"></param>
    Private Sub InitializeMapButton(ByRef control As HyperLink, ByVal id As String)

        control = New HyperLink With {.ID = id, .CssClass = "btn btn-default glyphicon glyphicon-map-marker"}
        control.Attributes.Add("data-toggle", "modal")
        control.Attributes.Add("data-target", $"#{ClientID}_mapModal")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="id"></param>
    Private Sub InitializeTextBox(ByRef control As TextBox, ByVal id As String)

        control = New TextBox With {.ID = id, .CssClass = "form-control"}

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="id"></param>
    Private Sub InitializeDropDown(ByRef control As DropDownList, ByVal id As String)

        control = New DropDownList With {.ID = id, .CssClass = "form-control"}

        If (isAutoPostBack) Then
            control.AutoPostBack = True
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="id"></param>
    ''' <param name="max"></param>
    ''' <param name="min"></param>
    ''' <param name="isInt"></param>
    Private Sub InitializeSpinner(ByRef control As NumericSpinner, ByVal id As String, Optional ByVal max As String = "",
                                  Optional ByVal min As String = "", Optional ByVal isInt As Boolean = False)

        control = New NumericSpinner With {.ID = id, .CssClass = "form-control"}
        control.Attributes.Add("min", min)
        control.Attributes.Add("max", max)
        control.IntegerOnly = isInt

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="validatecontrolid"></param>
    ''' <param name="resourcekey"></param>
    ''' <param name="isDDL"></param>
    Private Sub InitializeValidator(ByRef control As RequiredFieldValidator, ByVal validatecontrolid As String, ByVal resourcekey As String, Optional ByVal isDDL As Boolean = False)

        control = New RequiredFieldValidator With {.ControlToValidate = validatecontrolid, .CssClass = "alert-danger", .Display = ValidatorDisplay.Dynamic, .Enabled = GetLocalResourceObject(resourcekey + ".Enabled"),
            .ErrorMessage = GetLocalResourceObject(resourcekey + ".ErrorMessage"), .Text = GetLocalResourceObject(resourcekey + ".Text")}

        If isDDL Then control.InitialValue = GlobalConstants.NullValue.ToLower()
        control.ValidationGroup = ValidationGroup

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub LocationUserControl_Load(sender As Object, e As EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
                If IsHorizontalLayout Then
                    RenderHorizontalLayout()
                Else
                    RenderVerticalLayout()
                End If

                DataBind()
            Else
                If IsHorizontalLayout Then
                    RenderHorizontalLayout()
                Else
                    RenderVerticalLayout()
                End If
            End If

            AddHandler DdlRegion.SelectedIndexChanged, AddressOf Region_SelectedIndexChanged

            Dim controls As New List(Of Control)
            controls.Clear()
            For Each ddl As DropDownList In FindControlList(controls, Me, GetType(DropDownList))
                If ddl.ClientID.Contains($"ddl{ID}idfsRegion") = True Or
                            ddl.ClientID.Contains($"ddl{ID}idfsRayon") = True Then
                    ScriptManager.GetCurrent(Page).RegisterAsyncPostBackControl(ddl)
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
    Public Overrides Sub DataBind()

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            If (LocationCountryID.HasValue = False And String.IsNullOrEmpty(LocationCountryName) = True) Then
                FillControlForInsert()
            Else
                FillControlforEdit()
            End If

            If IsElevationVisible Then
                LblElevation.Visible = True
                TxtElevation.Visible = True
            Else
                LblElevation.Visible = False
                TxtElevation.Visible = False
            End If

            If IsMapVisible Then
                LblMap.Visible = True
                BtnMap.Visible = True
            Else
                LblMap.Visible = False
                BtnMap.Visible = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Rendering Layout"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub RenderVerticalLayout()

        Dim position As Integer = 0
        Dim countryArray As String() = New String() {"Dis_Country.Visible", "Req_Country.Visible"}

        Try
            If AddVerticalControl(LblCountry, DdlCountry, ValCountry, countryArray, position, "countryGroup", IsDbRequiredCountry) Then
                position += 1
            End If

            If IsRegionVisible Then
                Dim RegionArray As String() = New String() {"Dis_Region.Visible", "Req_Region.Visible"}
                If AddVerticalControl(lblRegion, ddlRegion, valRegion, RegionArray, position, "regionGroup", IsDbRequiredRegion) Then
                    position += 1
                End If
            End If

            If IsRayonVisible Then
                Dim RayonArray As String() = New String() {"Dis_Rayon.Visible", "Req_Rayon.Visible"}
                If AddVerticalControl(lblRayon, ddlRayon, valRayon, RayonArray, position, "rayonGroup", IsDbRequiredRayon) Then
                    position += 1
                End If
            End If

            If IsTownVisible Then
                Dim TownArray As String() = New String() {"Dis_Town_or_Village.Visible", "Req_Town_or_Village.Visible"}
                If AddVerticalControl(lblTown, ddlSettlement, valTown, TownArray, position, "townGroup", IsDbRequiredTown) Then
                    position += 1
                End If
            End If

            If IsStreetVisible Then
                Dim StreetArray As String() = New String() {"Dis_Street.Visible", "Req_Street.Visible"}
                If AddVerticalControl(lblStreet, txtStreetName, valStreet, StreetArray, position, "streetGroup", IsDbRequiredStreet) Then
                    position += 1
                End If
            End If

            If IsBuildingHouseApartmentVisible Then
                Dim labelArray As List(Of Label) = New List(Of Label)({lblHouse, lblBuilding, lblApartment})
                Dim controlArray As List(Of Control) = New List(Of Control)({txtHouse, txtBuilding, txtApartment})
                Dim validatorArray As List(Of RequiredFieldValidator) = New List(Of RequiredFieldValidator)({valHouse, valBuilding, valApartment})
                Dim resourceDict As Dictionary(Of Integer, List(Of String)) = New Dictionary(Of Integer, List(Of String))
                Dim areDbReq As List(Of Boolean) = New List(Of Boolean)

                resourceDict.Add(0, New List(Of String)({"Dis_Building_House_Apt.Visible"}))
                resourceDict.Add(1, New List(Of String)({"Dis_House.Visible", "Req_House.Visible"}))
                resourceDict.Add(2, New List(Of String)({"Dis_Building.Visible", "Req_Building.Visible"}))
                resourceDict.Add(3, New List(Of String)({"Dis_Apartment.Visible", "Req_Apartment.Visible"}))

                areDbReq.AddRange(New Boolean() {False, IsDbRequiredHouse, IsDbRequiredBuilding, IsDbRequiredApartment})

                If AddVerticalControlGroup(labelArray, controlArray, validatorArray, resourceDict, position, "buildingHouseApartmentGroup", areDbReq) Then
                    position += 1
                End If
            End If

            If IsPostalCodeVisible Then
                Dim PostalArray As String() = New String() {"Dis_Postal_Code.Visible", "Req_Postal_Code.Visible"}
                If AddVerticalControl(lblPostalCode, ddlPostalCode, valPostalCode, PostalArray, position, "postalGroup", IsDbRequiredPostalCode) Then
                    position += 1
                End If
            End If

            If IsCoordinatesVisible Then
                Dim labelArray As List(Of Label) = New List(Of Label)({lblLatitude, lblLongitude, lblElevation, lblMap})
                Dim controlArray As List(Of Control) = New List(Of Control)({txtLatitude, txtLongitude, txtElevation, btnMap})
                Dim validatorArray As List(Of RequiredFieldValidator) = New List(Of RequiredFieldValidator)({valLatitude, valLongitude, valElevation, Nothing})
                Dim resourceDict As Dictionary(Of Integer, List(Of String)) = New Dictionary(Of Integer, List(Of String))
                Dim areDbReq As List(Of Boolean) = New List(Of Boolean)

                resourceDict.Add(0, New List(Of String)({"Dis_Coordinates.Visible"}))
                resourceDict.Add(1, New List(Of String)({"Dis_Latitude.Visible", "Req_Latitude.Visible"}))
                resourceDict.Add(2, New List(Of String)({"Dis_Longitude.Visible", "Req_Longitude.Visible"}))
                resourceDict.Add(3, New List(Of String)({"Dis_Elevation.Visible", "Req_Elevation.Visible"}))
                resourceDict.Add(4, New List(Of String)({"Dis_Map.Visible", ""}))

                areDbReq.AddRange(New Boolean() {False, IsDbRequiredLatitude, IsDbRequiredLongitude, IsDbRequiredElevation, False})

                If AddVerticalControlGroup(labelArray, controlArray, validatorArray, resourceDict, position, "coordinatesGroup", areDbReq) Then
                    position += 1
                End If

                If IsMapVisible And IsGoogleAuthorized() Then
                    BuildMapModal(position)

                    SetMapScripts()
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
    Private Sub RenderHorizontalLayout()

        Dim labelArray = New List(Of Label)
        Dim controlArray = New List(Of Control)
        Dim validatorArray = New List(Of RequiredFieldValidator)
        Dim resourceDict As Dictionary(Of Integer, List(Of String)) = New Dictionary(Of Integer, List(Of String))()
        Dim groupNames = New List(Of String)
        Dim position As Integer = 0
        Dim areDbRequired As New List(Of Boolean)

        Try
            If ShowCountry Then
                labelArray.Add(lblCountry)
                controlArray.Add(ddlCountry)
                validatorArray.Add(valCountry)
                resourceDict.Add(position, New List(Of String)({"Dis_Country.Visible", "Req_Country.Visible"}))
                groupNames.Add("countryGroup")
                areDbRequired.Add(IsDbRequiredCountry)
                position += 1
            End If

            If IsRegionVisible Then
                labelArray.Add(lblRegion)
                controlArray.Add(ddlRegion)
                valRegion.Enabled = IsDbRequiredRegion
                validatorArray.Add(valRegion)
                resourceDict.Add(position, New List(Of String)({"Dis_Region.Visible", "Req_Region.Visible"}))
                groupNames.Add("regionGroup")
                areDbRequired.Add(IsDbRequiredRegion)
                position += 1
            End If

            If IsRayonVisible Then
                labelArray.Add(lblRayon)
                controlArray.Add(ddlRayon)
                valRayon.Enabled = IsDbRequiredRayon
                validatorArray.Add(valRayon)
                resourceDict.Add(position, New List(Of String)({"Dis_Rayon.Visible", "Req_Rayon.Visible"}))
                groupNames.Add("rayonGroup")
                areDbRequired.Add(IsDbRequiredRayon)
                position += 1
            End If

            If IsTownVisible Then
                labelArray.Add(lblTown)
                controlArray.Add(ddlSettlement)
                valTown.Enabled = IsDbRequiredTown
                validatorArray.Add(valTown)
                resourceDict.Add(position, New List(Of String)({"Dis_Town_or_Village.Visible", "Req_Town_or_Village.Visible"}))
                groupNames.Add("townGroup")
                areDbRequired.Add(IsDbRequiredTown)
                position += 1
            End If

            If IsStreetVisible Then
                labelArray.Add(lblStreet)
                controlArray.Add(txtStreetName)
                valStreet.Enabled = IsDbRequiredStreet
                validatorArray.Add(valStreet)
                resourceDict.Add(position, New List(Of String)({"Dis_Street.Visible", "Req_Street.Visible"}))
                groupNames.Add("streetGroup")
                areDbRequired.Add(IsDbRequiredStreet)
                position += 1
            End If

            AddHorizontalControls(labelArray, controlArray, validatorArray, resourceDict, groupNames, areDbRequired)

            If IsBuildingHouseApartmentVisible Then
                labelArray = New List(Of Label)({lblHouse, lblBuilding, lblApartment})
                controlArray = New List(Of Control)({txtHouse, txtBuilding, txtApartment})
                validatorArray = New List(Of RequiredFieldValidator)({valHouse, valBuilding, valApartment})
                resourceDict = New Dictionary(Of Integer, List(Of String))
                areDbRequired = New List(Of Boolean)

                resourceDict.Add(0, New List(Of String)({"Dis_Building_House_Apt.Visible"}))
                resourceDict.Add(1, New List(Of String)({"Dis_House.Visible", "Req_House.Visible"}))
                resourceDict.Add(2, New List(Of String)({"Dis_Building.Visible", "Req_Building.Visible"}))
                resourceDict.Add(3, New List(Of String)({"Dis_Apartment.Visible", "Req_Apartment.Visible"}))

                areDbRequired.AddRange(New Boolean() {False, IsDbRequiredHouse, IsDbRequiredBuilding, IsDbRequiredApartment})

                AddHorizontalControlGroup(labelArray, controlArray, validatorArray, resourceDict, "buildingHouseApartmentGroup", areDbRequired)
            End If

            If IsPostalCodeVisible Then
                labelArray = New List(Of Label)({lblPostalCode})
                controlArray = New List(Of Control)({ddlPostalCode})
                validatorArray = New List(Of RequiredFieldValidator)({valPostalCode})
                resourceDict = New Dictionary(Of Integer, List(Of String))()
                groupNames = New List(Of String) From {"postalGroup"}
                areDbRequired = New List(Of Boolean)({False, IsDbRequiredPostalCode})
                resourceDict.Add(0, New List(Of String)({"Dis_Postal_Code.Visible", "Req_Postal_Code.Visible"}))

                AddHorizontalControls(labelArray, controlArray, validatorArray, resourceDict, groupNames, areDbRequired)
            End If

            If IsCoordinatesVisible Then
                labelArray = New List(Of Label)({lblLatitude, lblLongitude, lblElevation, lblMap})
                controlArray = New List(Of Control)({txtLatitude, txtLongitude, txtElevation, btnMap})
                validatorArray = New List(Of RequiredFieldValidator)({valLatitude, valLongitude, valElevation, Nothing})
                resourceDict = New Dictionary(Of Integer, List(Of String))
                areDbRequired = New List(Of Boolean)

                resourceDict.Add(0, New List(Of String)({"Dis_Coordinates.Visible"}))
                resourceDict.Add(1, New List(Of String)({"Dis_Latitude.Visible", "Req_Latitude.Visible"}))
                resourceDict.Add(2, New List(Of String)({"Dis_Longitude.Visible", "Req_Longitude.Visible"}))
                resourceDict.Add(3, New List(Of String)({"Dis_Elevation.Visible", "Req_Elevation.Visible"}))
                resourceDict.Add(4, New List(Of String)({"Dis_Map.Visible", ""}))

                areDbRequired.AddRange(New Boolean() {False, IsDbRequiredLatitude, IsDbRequiredLongitude, IsDbRequiredElevation, False})

                AddHorizontalControlGroup(labelArray, controlArray, validatorArray, resourceDict, "coordinatesGroup", areDbRequired)

                If IsMapVisible And IsGoogleAuthorized() Then
                    BuildMapModal(position)

                    SetMapScripts()
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
    Private Sub RenderHorizontalCountryOnlyLayout()

        Dim labelArray = New List(Of Label)
        Dim controlArray = New List(Of Control)
        Dim validatorArray = New List(Of RequiredFieldValidator)
        Dim resourceDict As Dictionary(Of Integer, List(Of String)) = New Dictionary(Of Integer, List(Of String))()
        Dim groupNames = New List(Of String)
        Dim position As Integer = 0
        Dim areDbRequired As New List(Of Boolean)

        Try
            If ShowCountry Then
                labelArray.Add(lblCountry)
                controlArray.Add(ddlCountry)
                validatorArray.Add(valCountry)
                resourceDict.Add(position, New List(Of String)({"Dis_Country.Visible", "Req_Country.Visible"}))
                groupNames.Add("countryGroup")
                areDbRequired.Add(IsDbRequiredCountry)
                position += 1

            End If

            AddHorizontalControls(labelArray, controlArray, validatorArray, resourceDict, groupNames, areDbRequired)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="label"></param>
    ''' <param name="control"></param>
    ''' <param name="validator"></param>
    ''' <param name="resourceKeys"></param>
    ''' <param name="position"></param>
    ''' <param name="groupName"></param>
    ''' <param name="IsDbReq"></param>
    ''' <returns></returns>
    Private Function AddVerticalControl(ByRef label As Label, ByRef control As Control, ByRef validator As RequiredFieldValidator,
                                        ByRef resourceKeys As String(), ByRef position As Integer, ByRef groupName As String,
                                        ByRef IsDbReq As Boolean) As Boolean

        Dim isVisible As Boolean = GetLocalResourceObject(resourceKeys(0))

        Try
            ' check each control against the resource file value to determine if control is rendered or not.  
            ' country must always render to client.
            If (control.ID.ToLower().Contains("country") = False) And (Not isVisible) Then
                'will not render, we return false so that the position is not incremented
                Return False
            End If

            'Assign outer div "group" name
            Dim outerDiv As HtmlGenericControl = New HtmlGenericControl("div") With {
                .ID = groupName,
                .ClientIDMode = ClientIDMode.Static
            }
            outerDiv.Attributes.Add("class", "form-group")

            ' if country is not to be shown, use CSS to hide it but Country must always be rendered
            If control.ID.ToLower().Contains("country") And (Not isVisible Or ShowCountry = False) Then
                outerDiv.Attributes.Add("class", "hidden")
            End If

            Dim reqDiv As HtmlGenericControl = New HtmlGenericControl("div")

            If IsDbReq Then
                reqDiv.Attributes.Add("class", "glyphicon glyphicon-certificate alert-danger")
                reqDiv.Visible = True
                validator.Enabled = True
            Else
                reqDiv.Visible = GetLocalResourceObject(resourceKeys(1))
                reqDiv.Attributes.Add("class", "glyphicon glyphicon-asterisk alert-danger")
            End If

            outerDiv.Controls.AddAt(0, reqDiv)
            outerDiv.Controls.AddAt(1, label)
            outerDiv.Controls.AddAt(2, control)
            outerDiv.Controls.AddAt(3, validator)

            Controls.AddAt(position, outerDiv)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return True

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labels"></param>
    ''' <param name="controls"></param>
    ''' <param name="validators"></param>
    ''' <param name="resourceKeys"></param>
    ''' <param name="position"></param>
    ''' <param name="groupName"></param>
    ''' <param name="isDbReq"></param>
    ''' <returns></returns>
    Private Function AddVerticalControlGroup(ByRef labels As List(Of Label), ByRef controls As List(Of Control),
                                             ByRef validators As List(Of RequiredFieldValidator),
                                             ByRef resourceKeys As Dictionary(Of Integer, List(Of String)),
                                             ByRef position As Integer, ByRef groupName As String,
                                             ByRef isDbReq As List(Of Boolean)) As Boolean

        Dim keys As List(Of String) = resourceKeys.Item(0)
        Dim isVisible As Boolean = GetLocalResourceObject(keys(0))

        Try
            If Not isVisible Then
                Return False
            End If

            Dim outerDiv As HtmlGenericControl = New HtmlGenericControl("div")
            outerDiv.Attributes.Add("class", "form-group")

            'Assign outer div "group" name
            outerDiv.ID = groupName
            outerDiv.ClientIDMode = ClientIDMode.Static

            Dim rowDiv As HtmlGenericControl = New HtmlGenericControl("div")
            rowDiv.Attributes.Add("class", "row")

            For counter As Integer = 0 To labels.Count - 1

                keys = resourceKeys(counter + 1)

                Dim groupDiv As HtmlGenericControl = New HtmlGenericControl("div") With {
                    .Visible = GetLocalResourceObject(keys(0))
                }
                groupDiv.Attributes.Add("class", DetermineColumnWidth(labels.Count, counter))

                Dim reqDiv As HtmlGenericControl = New HtmlGenericControl("div")
                If isDbReq(counter) Then
                    reqDiv.Attributes.Add("class", "glyphicon glyphicon-certificate alert-danger")
                    validators(counter).Enabled = True
                Else
                    reqDiv.Attributes.Add("class", "glyphicon glyphicon-asterisk alert-danger")
                End If

                Dim pos As Integer = 0

                reqDiv.Visible = GetLocalResourceObject(keys(1))

                If reqDiv.Visible Then
                    groupDiv.Controls.AddAt(pos, reqDiv)
                    pos += 1
                End If

                If Not IsNothing(labels(counter)) Then
                    groupDiv.Controls.AddAt(pos, labels(counter))
                    pos += 1
                End If

                If Not IsNothing(controls(counter)) Then
                    groupDiv.Controls.AddAt(pos, controls(counter))
                    pos += 1
                End If

                If Not IsNothing(validators(counter)) Then
                    groupDiv.Controls.AddAt(pos, validators(counter))
                    pos += 1
                End If

                rowDiv.Controls.AddAt(counter, groupDiv)
            Next

            outerDiv.Controls.Add(rowDiv)
            Me.Controls.AddAt(position, outerDiv)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return True

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="label"></param>
    ''' <param name="control"></param>
    ''' <param name="validator"></param>
    ''' <param name="resourceKeys"></param>
    ''' <param name="groupName"></param>
    ''' <param name="IsDbReq"></param>
    ''' <returns></returns>
    Private Function AddHorizontalControl(ByRef label As Label, ByRef control As Control,
                                          ByRef validator As RequiredFieldValidator,
                                          ByRef resourceKeys As String(),
                                          ByRef groupName As String,
                                          ByRef IsDbReq As Boolean) As Boolean

        Dim isVisible As Boolean = GetLocalResourceObject(resourceKeys(0))

        Try
            ' check each control against the resource file value to determine if control is rendered or not.  
            ' country must always render to client.
            If (control.ID.ToLower().Contains("country") = False) And (Not isVisible) Then
                'will not render, we return false so that the position is not incremented
                Return False
            End If

            'Assign outer div "group" name
            Dim outerDiv As HtmlGenericControl = New HtmlGenericControl("div") With {
                .ID = groupName,
                .ClientIDMode = ClientIDMode.Static
            }
            outerDiv.Attributes.Add("class", "form-group")

            ' if country is not to be shown, use CSS to hide it but Country must always be rendered
            If control.ID.ToLower().Contains("country") And (Not isVisible Or ShowCountry = False) Then
                outerDiv.Attributes.Add("class", "hidden")
            End If

            Dim reqDiv As HtmlGenericControl = New HtmlGenericControl("div")

            If IsDbReq Then
                reqDiv.Attributes.Add("class", "glyphicon glyphicon-certificate alert-danger")
                reqDiv.Visible = True
                validator.Enabled = True
            Else
                reqDiv.Visible = GetLocalResourceObject(resourceKeys(1))
                reqDiv.Attributes.Add("class", "glyphicon glyphicon-asterisk alert-danger")
            End If

            outerDiv.Controls.AddAt(0, reqDiv)
            outerDiv.Controls.AddAt(1, label)
            outerDiv.Controls.AddAt(2, control)
            outerDiv.Controls.AddAt(3, validator)

            Controls.AddAt(0, outerDiv)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return True

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labels"></param>
    ''' <param name="controls"></param>
    ''' <param name="validators"></param>
    ''' <param name="resourcekeys"></param>
    ''' <param name="groupNames"></param>
    ''' <param name="areDbReq"></param>
    Private Sub AddHorizontalControls(ByRef labels As List(Of Label),
                                      ByRef controls As List(Of Control),
                                      ByRef validators As List(Of RequiredFieldValidator),
                                      ByRef resourcekeys As Dictionary(Of Integer, List(Of String)),
                                      ByRef groupNames As List(Of String),
                                      ByRef areDbReq As List(Of Boolean))

        Dim outerDiv As HtmlGenericControl = New HtmlGenericControl("div")
        Dim rowDiv As HtmlGenericControl = New HtmlGenericControl("div")
        Dim containerDiv As HtmlGenericControl = New HtmlGenericControl("div")
        Dim requiredDiv As HtmlGenericControl = New HtmlGenericControl("div")

        Dim counter As Integer = 0

        Try
            For Each kvp As KeyValuePair(Of Integer, List(Of String)) In resourcekeys
                counter += 1

                Dim key As Integer = kvp.Key
                Dim list As List(Of String) = kvp.Value

                Dim display As String = GetLocalResourceObject(list(0))
                Dim required As String = GetLocalResourceObject(list(1))

                If display.ToLower() = "true" Then
                    If key Mod 2 = 0 Then
                        ' Start new group
                        outerDiv = New HtmlGenericControl("div")
                        rowDiv = New HtmlGenericControl("div")
                    End If

                    containerDiv = New HtmlGenericControl("div")
                    requiredDiv = New HtmlGenericControl("div")

                    containerDiv.ID = groupNames(key)
                    outerDiv.Attributes.Add("class", "form-group")
                    rowDiv.Attributes.Add("class", "row")
                    containerDiv.Attributes.Add("class", "col-md-6")

                    If (areDbReq(counter - 1)) Then
                        requiredDiv.Attributes.Add("class", "glyphicon glyphicon-certificate alert-danger")
                        validators(counter).Enabled = True
                        required = "True"
                    Else
                        required = "False"
                    End If

                    Dim addAt As Integer = 0

                    If required.ToLower() = "true" Then
                        containerDiv.Controls.AddAt(addAt, requiredDiv)
                        addAt += 1
                    End If

                    containerDiv.Controls.AddAt(addAt, labels(key))
                    addAt += 1

                    containerDiv.Controls.AddAt(addAt, controls(key))
                    addAt += 1

                    If required = "True" Then
                        containerDiv.Controls.AddAt(addAt, validators(key))
                    End If

                    rowDiv.Controls.Add(containerDiv)

                    If (key Mod 2 <> 0) Or (counter = resourcekeys.Count) Then
                        ' close the group
                        outerDiv.Controls.Add(rowDiv)
                        Me.Controls.Add(outerDiv)
                    End If
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
    ''' <param name="labels"></param>
    ''' <param name="controls"></param>
    ''' <param name="validators"></param>
    ''' <param name="resourceKeys"></param>
    ''' <param name="groupName"></param>
    ''' <param name="areDbReq"></param>
    ''' <returns></returns>
    Private Function AddHorizontalControlGroup(ByRef labels As List(Of Label),
                                               ByRef controls As List(Of Control),
                                               ByRef validators As List(Of RequiredFieldValidator),
                                               ByRef resourceKeys As Dictionary(Of Integer, List(Of String)),
                                               ByRef groupName As String,
                                               ByRef areDbReq As List(Of Boolean)) As Boolean

        Dim keys As List(Of String) = resourceKeys.Item(0)
        Dim isVisible As Boolean = GetLocalResourceObject(keys(0))

        Try
            If Not isVisible Then
                Return False
            End If

            Dim outerDiv As HtmlGenericControl = New HtmlGenericControl("div")
            outerDiv.Attributes.Add("class", "form-group")
            outerDiv.ID = groupName
            outerDiv.ClientIDMode = ClientIDMode.Static

            Dim rowDiv As HtmlGenericControl = New HtmlGenericControl("div")
            rowDiv.Attributes.Add("class", "row")

            For counter As Integer = 0 To labels.Count - 1
                keys = resourceKeys(counter + 1)

                Dim groupDiv As HtmlGenericControl = New HtmlGenericControl("div") With {.Visible = GetLocalResourceObject(keys(0))}
                groupDiv.Attributes.Add("class", DetermineColumnWidth(labels.Count, counter))

                Dim reqDiv As HtmlGenericControl = New HtmlGenericControl("div")

                If areDbReq(counter) Then
                    reqDiv.Attributes.Add("class", "glyphicon glyphicon-certificate alert-danger")
                    validators(counter).Enabled = True
                    reqDiv.Visible = True
                Else
                    reqDiv.Attributes.Add("class", "glyphicon glyphicon-asterisk alert-danger")
                    reqDiv.Visible = GetLocalResourceObject(keys(1))
                End If

                Dim pos As Integer = 0

                If reqDiv.Visible Then
                    groupDiv.Controls.AddAt(pos, reqDiv)
                    pos += 1
                End If

                If Not IsNothing(labels(counter)) Then
                    groupDiv.Controls.AddAt(pos, labels(counter))
                    pos += 1
                End If

                If Not IsNothing(controls(counter)) Then
                    groupDiv.Controls.AddAt(pos, controls(counter))
                    pos += 1
                End If

                If Not IsNothing(validators(counter)) Then
                    groupDiv.Controls.AddAt(pos, validators(counter))
                    pos += 1
                End If

                rowDiv.Controls.AddAt(counter, groupDiv)
            Next

            outerDiv.Controls.Add(rowDiv)
            Me.Controls.Add(outerDiv)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return True

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="itemCount"></param>
    ''' <param name="itemNumber"></param>
    ''' <returns></returns>
    Private Function DetermineColumnWidth(ByVal itemCount As Integer, ByVal itemNumber As Integer) As String

        Try
            If itemCount = 3 Then
                'house/building/appt
                Return "col-lg-4 col-md-4 col-sm-4 col-xs-4"
            End If
            'location
            Select Case (itemNumber)
                Case 0, 1
                    Return "col-lg-4 col-md-4 col-sm-4 col-xs-4"
                Case 2
                    Return "col-lg-3 col-md-3 col-sm-3 col-xs-3"
                Case 3
                    Return "col-lg-1 col-md-1 col-sm-1 col-xs-1"
            End Select

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return ""

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="position"></param>
    Private Sub BuildMapModal(ByVal position As Integer)

        Try
            Map = New HtmlGenericControl("div") With {.ID = "Map"}
            Map.Style.Add(HtmlTextWriterStyle.Width, "100%")
            Map.Style.Add(HtmlTextWriterStyle.Height, "100%")

            btnCopyCoordinates = New HtmlButton()
            btnCopyCoordinates.Attributes.Add("class", "close")
            btnCopyCoordinates.Attributes.Add("data-dismiss", "modal")
            btnCopyCoordinates.InnerHtml = GetLocalResourceObject("btn_Copy_Coordinates.Text")

            Dim footer As HtmlGenericControl = New HtmlGenericControl("div")
            footer.Attributes.Add("class", "modal-footer")
            footer.Controls.Add(btnCopyCoordinates)

            Dim body As HtmlGenericControl = New HtmlGenericControl("div")
            body.Attributes.Add("class", "modal-body")
            body.Style.Add(HtmlTextWriterStyle.Width, "600px")
            body.Style.Add(HtmlTextWriterStyle.Height, "600px")
            body.Controls.Add(Map)

            Dim dismissButton As HtmlButton = New HtmlButton()
            dismissButton.Attributes.Add("class", "close")
            dismissButton.Attributes.Add("data-dismiss", "modal")
            dismissButton.Attributes.Add("type", "button")
            dismissButton.InnerHtml = "&times;"

            Dim heading As HtmlGenericControl = New HtmlGenericControl("h4") With {.InnerText = GetLocalResourceObject("hdg_Map.InnerText")}
            heading.Attributes.Add("class", "modal-title")

            Dim header As HtmlGenericControl = New HtmlGenericControl("div")
            header.Attributes.Add("class", "modal-header")

            header.Controls.Add(dismissButton)
            header.Controls.Add(heading)

            Dim modalContent As HtmlGenericControl = New HtmlGenericControl("div")
            modalContent.Attributes.Add("class", "modal-content")

            Dim dialog As HtmlGenericControl = New HtmlGenericControl("div")
            dialog.Attributes.Add("class", "modal-dialog")

            Dim container As HtmlGenericControl = New HtmlGenericControl("div")
            container.Attributes.Add("class", "modal fade")
            container.Attributes.Add("role", "dialog")
            container.ID = $"{ClientID}_mapModal"
            container.ClientIDMode = ClientIDMode.Static

            modalContent.Controls.AddAt(0, header)
            modalContent.Controls.AddAt(1, body)
            modalContent.Controls.AddAt(2, footer)

            dialog.Controls.Add(modalContent)

            container.Controls.Add(dialog)
            If position > Controls.Count Then
                position = Controls.Count
            End If
            Controls.AddAt(position, container)
            btnMap.Attributes.Add("onclick", $"setMapObject('{Map.ClientID}');")

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SetMapScripts()

        Dim section As NameValueCollection

        Try
            section = CType(ConfigurationManager.GetSection("GoogleMaps"), NameValueCollection)

            If IsNothing(section) Then
                Return
            End If

            Dim scriptMgr As ClientScriptManager = Page.ClientScript
            Dim callBackFunction As String = $"initMap"
            Dim googleKey As String = section.Item("securityToken").ToString()

            Dim scriptSrc As String = $"<script async defer src='https://maps.googleapis.com/maps/api/js?key={googleKey}&callback={callBackFunction}'></script>"
            Dim staticVariables As String = $"var map, mapObject, latitude, longitude, isGeoLocated=false; defaultLatitude = {section.Item("defaultLatitude")}, defaultLongitude = {section.Item("defaultLongitude")};{vbCr}"

            Dim csname1 As String = "googleMaps"
            Dim csname2 As String = "googleMapstaticVariables"
            Dim csName3 As String = "googleMapsStaticFunctions"
            Dim csName4 As String = $"googleMapsUniqueFunctions{ID}"
            Dim csType As Type = [GetType]()

            If (Not scriptMgr.IsStartupScriptRegistered(csType, csname1)) Then
                scriptMgr.RegisterStartupScript(csType, csname1, scriptSrc, False)
            End If

            If Not scriptMgr.IsStartupScriptRegistered(csType, csname2) Then
                scriptMgr.RegisterStartupScript(csType, csname2, staticVariables, True)
            End If

            If Not scriptMgr.IsStartupScriptRegistered(csType, csName3) Then
                scriptMgr.RegisterStartupScript(csType, csName3, BuildMappingScript(), True)
            End If

            If Not scriptMgr.IsStartupScriptRegistered(csType, csName4) Then
                scriptMgr.RegisterStartupScript(csType, csName4, BuildUniqueScript(), True)
            End If

            BtnCopyCoordinates.Attributes.Add("onclick", $"copyCoordinatesFromMap()")

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function BuildMappingScript() As String

        Dim sb As StringBuilder = New StringBuilder()

        sb.AppendLine("function setMapObject(name){")
        sb.AppendLine($"{vbTab}mapObject = document.getElementById(name);{vbCr}{"}"};{vbCrLf}")

        sb.AppendLine("function initMap(){")
        sb.AppendLine($"{vbTab}if (mapObject == undefined){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}return;{vbCr}{vbTab}{"}"};{vbCr}")

        sb.AppendLine($"{vbTab}if (navigator.geolocation) {"{"}")
        sb.AppendLine($"{vbTab}{vbTab}navigator.geolocation.getCurrentPosition(showGeoLocation);{vbCr}{vbTab}{"}"}")
        sb.AppendLine($"{vbTab}if(isGeoLocated == false){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}showDefaultLocation();{vbCr}{vbTab}{"}"}{vbCr}{"}"}")

        sb.AppendLine($"function showDefaultLocation(){"{"}")
        sb.AppendLine($"{vbTab}latitude = getDefaultLatitude();")
        sb.AppendLine($"{vbTab}longitude = getDefaultLongitude();")
        sb.AppendLine($"{vbTab}showMap();{vbCr}{"}"};{vbCr}")

        sb.AppendLine("function showGeoLocation(position) {")
        sb.AppendLine($"{vbTab}latitude = position.coords.latitude;")
        sb.AppendLine($"{vbTab}longitude = position.coords.longitude;")
        sb.AppendLine($"{vbTab}showMap();{vbCr}{vbTab}isGeoLocated = true;{vbCr}{"}"};{vbCr}")

        sb.AppendLine("function showMap(){")
        sb.AppendLine($"{vbTab}var pos = {"{"} lat: latitude, lng: longitude {"}"};")
        sb.AppendLine($"{vbTab}map = new google.maps.Map(mapObject, {"{"} center: pos, zoom: 8 {"}"});{vbCr}")
        sb.AppendLine($"{vbTab}var marker = new google.maps.Marker({"{"} position: pos, map: map, draggable: true {"}"});")
        sb.AppendLine($"{vbTab}marker.addListener('dragend', function () {"{"}")
        sb.AppendLine($"{vbTab}{vbTab}latitude = marker.position.lat();")
        sb.AppendLine($"{vbTab}{vbTab}longitude = marker.position.lng();{vbCr}{vbTab}{"}"});{"}"};")

        sb.AppendLine($"function copyCoordinatesFromMap() {"{"}")
        sb.AppendLine($"{vbTab}try {"{"}")
        sb.AppendLine($"{vbTab}{vbTab}var inputLat = getActiveLatitudeInput();")
        sb.AppendLine($"{vbTab}{vbTab}var inputLng = getActiveLongitudeInput();")
        sb.AppendLine($"{vbTab}{vbTab}inputLat.value = latitude;")
        sb.AppendLine($"{vbTab}{vbTab}inputLng.value = longitude;")
        sb.AppendLine($"{vbTab}{"}"}catch(e){"{"}{"}"}")
        sb.AppendLine($"{"}"};{vbCr}")

        sb.AppendLine($"function getActiveLatitudeInput() {"{"}")
        sb.AppendLine($"{vbTab}var activeMap = mapObject.id;")
        sb.AppendLine($"{vbTab}var inputs = $('input[name *= ""Latitude""]');")
        sb.AppendLine($"{vbTab}var parentNodeName = activeMap.replace(""Map"", """");")
        sb.AppendLine($"{vbTab}for( var x = 0; x < inputs.length; x++){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}if(inputs[x].id.startsWith(parentNodeName)){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}{vbTab}return inputs[x];{vbCr}{vbTab}{vbTab}{"}"}")
        sb.AppendLine($"{vbTab}{"}"}{vbCr}{vbTab}throw ""control Not found"";{vbCr}{"}"};{vbCr}")

        sb.AppendLine($"function getActiveLongitudeInput() {"{"}")
        sb.AppendLine($"{vbTab}var activeMap = mapObject.id;")
        sb.AppendLine($"{vbTab}var inputs = $('input[name *= ""Longitude""]');")
        sb.AppendLine($"{vbTab}var parentNodeName = activeMap.replace(""Map"", """");")
        sb.AppendLine($"{vbTab}for( var x = 0; x < inputs.length; x++){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}if(inputs[x].id.startsWith(parentNodeName)){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}{vbTab}return inputs[x];{vbCr}{vbTab}{vbTab}{"}"}")
        sb.AppendLine($"{vbTab}{"}"}{vbCr}{vbTab}throw ""control Not found"";{vbCr}{"}"};{vbCr}")

        sb.AppendLine($"function getDefaultLatitude() {"{"}")
        sb.AppendLine($"{vbTab}try {"{"}")
        sb.AppendLine($"{vbTab}var inputLat = getActiveLatitudeInput();")
        sb.AppendLine($"{vbTab}if (inputLat.value == """"){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}return defaultLatitude;{vbCr}{vbTab}{"}"}")
        sb.AppendLine($"{vbTab}return inputLat.value;")
        sb.AppendLine($"{vbTab}{"}"}catch(e){"{"}{"}"}")
        sb.AppendLine($"{"}"};{vbCr}")

        sb.AppendLine($"function getDefaultLongitude() {"{"}")
        sb.AppendLine($"{vbTab}try {"{"}")
        sb.AppendLine($"{vbTab}var inputLng = getActiveLongitudeInput();")
        sb.AppendLine($"{vbTab}if (inputLng.value == """"){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}return defaultLongitude;{vbCr}{vbTab}{"}"}")
        sb.AppendLine($"{vbTab}return inputLng.value;")
        sb.AppendLine($"{vbTab}{"}"}catch(e){"{"}{"}"}")
        sb.AppendLine($"{"}"};{vbCr}")

        Return sb.ToString()

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function BuildUniqueScript() As String

        Dim sb As StringBuilder = New StringBuilder()

        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"")
        sb.Append($"$(document).ready(function(){"{"}{vbCr}{vbTab}$(""#{ClientID}_mapModal"").on(""shown.bs.modal"", initMap);{vbCr}{"}"});")
        Return sb.ToString()

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function IsGoogleAuthorized()

        Dim section As NameValueCollection

        Try
            section = CType(ConfigurationManager.GetSection("GoogleMaps"), NameValueCollection)

            If IsNothing(section) Then
                Return False
            End If

            Dim googleKey As String = section.Item("securityToken").ToString()

            If String.IsNullOrEmpty(googleKey) Then
                Return False
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return True

    End Function
#End Region

#Region "Filling Controls with Data"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillControlForInsert()

        Try
            If String.IsNullOrEmpty(SelectedCountryText) And (SelectedCountryValue = "-1" Or SelectedCountryValue = GlobalConstants.NullValue.ToLower()) Then
                FillCountry(Nothing, getConfigValue("DefaultCountry").ToString())
            ElseIf String.IsNullOrEmpty(SelectedCountryText) And SelectedCountryValue <> "-1" Then
                FillCountry(SelectedCountryValue, Nothing)
            ElseIf (String.IsNullOrEmpty(SelectedCountryText) = False) And SelectedCountryValue = "-1" Then
                FillCountry(Nothing, SelectedCountryText)
            Else
                FillCountry(SelectedCountryValue, SelectedCountryText)
            End If

            'Bug # 1909 pre-populated fields Region and Rayon (Begin) - Asim
            If LocationRegionID Is Nothing Then
                'Get Region & Rayon values based on UserID & SiteID
                globalSiteDetails = CrossCuttingAPIService.GetGlobalSiteDetails(Session(UserConstants.UserSite), Session(UserConstants.idfUserID)).Result(0)
                Session("LocationCountryID") = globalSiteDetails.idfsCountry
                Session("LocationRegionID") = globalSiteDetails.idfsRegion
                Session("LocationRayonID") = globalSiteDetails.idfsRayon
                'Session("LocationSettlementID") = globalSiteDetails.idfsSettlement

                'Bug # 2502 - Vet Aggregate Report\ Search\ Default Region and Default Rayon are not auto-populated - Asim
                SelectedRegionValue = globalSiteDetails.idfsRegion
                SelectedRayonValue = globalSiteDetails.idfsRayon
                'SelectedSettlementValue = globalSiteDetails.idfsSettlement  'This line ensures that "Settlement" dropdown is enabled
                SelectedSettlementValue = "0"
                'Bug # 2502 - Vet Aggregate Report\ Search\ Default Region and Default Rayon are not auto-populated - Asim

            End If
            'Bug # 1909 pre-populated fields Region and Rayon (End) - Asim

            If String.IsNullOrEmpty(SelectedRegionText) And (SelectedRegionValue = "-1" Or SelectedRegionValue = GlobalConstants.NullValue.ToLower()) Then
                FillRegion(Nothing, Nothing)
            ElseIf String.IsNullOrEmpty(SelectedRegionText) And SelectedRegionValue <> "-1" Then
                FillRegion(SelectedRegionValue, Nothing)
            ElseIf (String.IsNullOrEmpty(SelectedRegionText) = False) And SelectedRegionValue = "-1" Then
                FillRegion(Nothing, SelectedRegionText)
            Else
                FillRegion(SelectedRegionValue, SelectedRegionText)
            End If

            If String.IsNullOrEmpty(SelectedRayonText) And (SelectedRayonValue = "-1" Or SelectedRayonValue = GlobalConstants.NullValue.ToLower()) Then
                DdlRayon.Enabled = False
            ElseIf String.IsNullOrEmpty(SelectedRayonText) And SelectedRayonValue <> "-1" Then
                FillRayon(SelectedRayonValue, Nothing)
                DdlRayon.Enabled = True
            ElseIf (String.IsNullOrEmpty(SelectedRayonText) = False) And SelectedRayonValue = "-1" Then
                FillRayon(Nothing, SelectedRayonText)
                DdlRayon.Enabled = True
            Else
                FillRayon(SelectedRayonValue, SelectedRayonText)
                ddlRayon.Enabled = True
            End If

            If String.IsNullOrEmpty(SelectedSettlementText) And (SelectedSettlementValue = "-1" Or SelectedSettlementValue = GlobalConstants.NullValue.ToLower()) Then
                DdlSettlement.Enabled = False
            ElseIf String.IsNullOrEmpty(SelectedSettlementText) And SelectedSettlementValue <> "-1" Then
                FillSettlement(SelectedSettlementValue, Nothing)
                DdlSettlement.Enabled = True
            ElseIf (String.IsNullOrEmpty(SelectedSettlementText) = False) And SelectedSettlementValue = "-1" Then
                FillSettlement(Nothing, SelectedSettlementText)
                DdlSettlement.Enabled = True
            Else
                FillSettlement(SelectedSettlementValue, SelectedSettlementText)
                ddlSettlement.Enabled = True
            End If

            If String.IsNullOrEmpty(SelectedPostalText) And (SelectedPostalValue = "-1" Or SelectedPostalValue = GlobalConstants.NullValue.ToLower()) Then
                DdlPostalCode.Enabled = False
            ElseIf String.IsNullOrEmpty(SelectedPostalText) And SelectedPostalValue <> "-1" Then
                FillPostalCode(postalValue, Nothing)
                DdlPostalCode.Enabled = True
            ElseIf (String.IsNullOrEmpty(SelectedPostalText) = False) And SelectedPostalValue = "-1" Then
                FillPostalCode(Nothing, SelectedPostalText)
                DdlPostalCode.Enabled = True
            Else
                FillPostalCode(SelectedPostalValue, SelectedPostalText)
                ddlPostalCode.Enabled = True
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillControlforEdit()

        Try
            If LocationCountryID.HasValue Then
                FillCountry(LocationCountryID, Nothing)
            ElseIf String.IsNullOrEmpty(LocationCountryName) = False Then
                FillCountry(Nothing, LocationCountryName)
            Else
                FillCountry(Nothing, getConfigValue("DefaultCountry").ToString())
            End If

            If IsRegionVisible Then
                If LocationRegionID.HasValue Then
                    FillRegion(LocationRegionID, Nothing)
                ElseIf String.IsNullOrEmpty(LocationRegionName) = False Then
                    FillRegion(Nothing, LocationRegionName)
                Else
                    FillRegion(Nothing, Nothing)
                End If
            End If

            If IsRayonVisible Then
                If LocationRayonID.HasValue Then
                    FillRayon(LocationRayonID, Nothing)
                ElseIf String.IsNullOrEmpty(LocationRayonName) = False Then
                    FillRayon(Nothing, LocationRayonName)
                Else
                    FillRayon(Nothing, Nothing)
                End If
            End If

            If IsTownVisible Then
                If LocationSettlementID.HasValue Then
                    FillSettlement(LocationSettlementID, Nothing)
                ElseIf String.IsNullOrEmpty(LocationSettlementName) = False Then
                    FillSettlement(Nothing, LocationSettlementName)
                Else
                    FillSettlement(Nothing, Nothing)
                End If
            End If

            If IsPostalCodeVisible Then
                If LocationPostalCodeID.HasValue Then
                    FillPostalCode(LocationPostalCodeID, Nothing)
                ElseIf String.IsNullOrEmpty(LocationPostalCodeName) = False Then
                    FillPostalCode(Nothing, LocationPostalCodeName)
                Else
                    FillPostalCode(Nothing, Nothing)
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
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillCountry(selectedValue As String, selectedText As String)

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of CountryGetLookupModel) = CrossCuttingAPIService.GetCountryListAsync(GetCurrentLanguage()).Result.OrderBy(Function(x) x.strCountryName).ToList()
            FillDropDownList(DdlCountry, list, {GlobalConstants.NullValue}, CountryConstants.CountryID, CountryConstants.CountryName, selectedValue, selectedText, True)

            If IsCountryOnlyVisible Then
                ShowCountry = True
            End If

            If (ShowCountry = True) Then
                If DdlCountry.SelectedIndex = 0 Or IsCountryOnlyVisible Then
                    DdlRegion.Enabled = False
                    DdlRayon.Enabled = False
                    DdlSettlement.Enabled = False
                    If IsCountryOnlyVisible Then
                        ValRegion.Enabled = False
                        ValRayon.Enabled = False
                        ValTown.Enabled = False
                    End If
                End If
            Else
                DdlRegion.Enabled = True
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillRegion(selectedValue As String, selectedText As String)

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of RegionGetLookupModel) = CrossCuttingAPIService.GetRegionListAsync(GetCurrentLanguage(), ddlCountry.SelectedValue.ToString(), Nothing).Result.OrderBy(Function(x) x.strRegionName).ToList()
            FillDropDownList(DdlRegion, list, {GlobalConstants.NullValue.ToLower()}, RegionConstants.RegionID, RegionConstants.RegionName, selectedValue, selectedText, True)

            If ddlRegion.SelectedIndex = 0 Then
                ddlRayon.Enabled = False
                ddlSettlement.Enabled = False
            ElseIf DdlRegion.SelectedIndex <> 0 And DisplayPrePopulatedRegionRayon = True Then
                'Bug # 1909 pre-populated fields Region and Rayon - Asim
                DdlRayon.Enabled = True
                DdlSettlement.Enabled = True
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillRayon(selectedValue As String, selectedText As String)

        Dim regionID As Long?,
            rayonID As Long?

        Try
            If ddlRegion.SelectedValue.IsValueNullOrEmpty() Then
                regionID = Nothing
            Else
                regionID = CType(ddlRegion.SelectedValue, Long)
            End If

            If selectedValue.IsValueNullOrEmpty() Then
                rayonID = Nothing
            Else
                rayonID = CType(selectedValue, Long)
            End If

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of RayonGetLookupModel) = CrossCuttingAPIService.GetRayonListAsync(GetCurrentLanguage(), regionID, rayonID).Result.OrderBy(Function(x) x.strRayonName).ToList()
            FillDropDownList(DdlRayon, list, {GlobalConstants.NullValue.ToLower()}, RayonConstants.RayonID, RayonConstants.RayonName, selectedValue, selectedText, True)

            If ddlRayon.SelectedIndex = 0 Then
                DdlSettlement.Enabled = False
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillSettlement(selectedValue As String, selectedText As String)

        Dim rayonID As Long?,
            settlementID As Long?

        Try
            If ddlRayon.SelectedValue.IsValueNullOrEmpty() Then
                rayonID = Nothing
            Else
                rayonID = CType(ddlRayon.SelectedValue, Long)
            End If

            If selectedValue.IsValueNullOrEmpty() Then
                settlementID = Nothing
            Else
                settlementID = CType(selectedValue, Long)
            End If

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of SettlementGetLookupModel) = CrossCuttingAPIService.GetSettlementListAsync(GetCurrentLanguage(), rayonID, settlementID).Result.OrderBy(Function(x) x.strSettlementName).ToList()
            FillDropDownList(DdlSettlement, list, {GlobalConstants.NullValue.ToLower()}, TownOrVillageConstants.TownOrVillageID, TownOrVillageConstants.TownOrVillageName, selectedValue, selectedText, True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillPostalCode(selectedValue As String, selectedText As String)

        Dim settlementID As Long?

        Try
            If ddlSettlement.SelectedValue.IsValueNullOrEmpty() Then
                settlementID = Nothing
            Else
                settlementID = CType(ddlSettlement.SelectedValue, Long)
            End If

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of PostalCodeGetLookupModel) = CrossCuttingAPIService.GetPostalCodeListAsync(settlementID).Result.OrderBy(Function(x) x.strPostCode).ToList()
            FillDropDownList(DdlPostalCode, list, {GlobalConstants.NullValue.ToLower()}, PostalCodeConstants.PostalCodeID, PostalCodeConstants.PostalCodeName, selectedValue, selectedText, True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Events"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub Country_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            ddlRayon.Enabled = False
            ddlSettlement.Enabled = False
            txtStreetName.Enabled = False
            ddlPostalCode.Enabled = False
            txtApartment.Enabled = False
            txtBuilding.Enabled = False
            txtHouse.Enabled = False
            FillRegion(Nothing, Nothing)

            'Force clearing of the rayon and settlement as the country has been cleared out.
            If IsCountryOnlyVisible Then
                ShowCountry = True
            End If

            If (ShowCountry = True) Then
                If ddlCountry.SelectedIndex = 0 Or IsCountryOnlyVisible Then
                    ddlRegion.Enabled = False
                    FillRayon(Nothing, Nothing)
                    FillSettlement(Nothing, Nothing)
                    If IsCountryOnlyVisible Then
                        valRegion.Enabled = False
                        valRayon.Enabled = False
                        valTown.Enabled = False
                    End If
                Else
                    ddlRegion.Enabled = True
                End If
            End If

            SendNotification()
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
    Private Sub Region_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            DdlSettlement.Enabled = False
            TxtStreetName.Enabled = False
            DdlPostalCode.Enabled = False
            TxtApartment.Enabled = False
            TxtBuilding.Enabled = False
            TxtHouse.Enabled = False
            FillRayon(Nothing, Nothing)
            'Force clearing of the settlement as the region has been cleared out.
            FillSettlement(Nothing, Nothing)

            If DdlRegion.SelectedIndex = 0 Then
                DdlRayon.Enabled = False
            Else
                DdlRayon.Enabled = True
            End If

            'Bug 2499 - Vet Aggregate Report - Search - Organization field is enabled - Asim
            'If Region is set to blank, then disable ddlOrganization;
            LocationRegionID = DdlRegion.SelectedIndex

            'Dim vetAgg As VeterinaryAggregate = New VeterinaryAggregate()
            'If Not IsNothing(vetAgg) Then
            '    Dim ddlOrg As DropDownList = vetAgg.FindControl("EIDSSBodyCPH_ddlidfsOrganzation")
            'End If

            RaiseEvent ItemSelected(DdlRegion.SelectedIndex)

            'RaiseEvent at the UI so the ddlOrg can be set to disable - Asim
            SendNotification()
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
    Private Sub Rayon_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            txtStreetName.Enabled = True
            ddlPostalCode.Enabled = True
            txtApartment.Enabled = True
            txtBuilding.Enabled = True
            txtHouse.Enabled = True
            FillSettlement(Nothing, Nothing)
            ddlRegion.Enabled = True

            If ddlRayon.SelectedIndex = 0 Then
                ddlSettlement.Enabled = False
            Else
                ddlSettlement.Enabled = True
            End If

            SendNotification()
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
    Private Sub Settlement_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            ddlPostalCode.Enabled = True
            txtStreetName.Enabled = True
            ddlPostalCode.Enabled = True
            txtApartment.Enabled = True
            txtBuilding.Enabled = True
            txtHouse.Enabled = True
            FillPostalCode(Nothing, Nothing)
            ddlRegion.Enabled = True

            SendNotification()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="exact"></param>
    ''' <param name="relative"></param>
    ''' <param name="foreign"></param>
    Public Sub AdjustToRadiControls(ByVal exact As Boolean, ByVal relative As Boolean, ByVal foreign As Boolean)

        Dim regionGroup As HtmlContainerControl = FindControl("regionGroup")
        Dim rayonGroup As HtmlContainerControl = FindControl("rayonGroup")
        Dim townGroup As HtmlContainerControl = FindControl("townGroup")
        Dim streetGroup As HtmlContainerControl = FindControl("streetGroup")
        Dim buildingHouseApartmentGroup As HtmlContainerControl = FindControl("buildingHouseApartmentGroup")
        Dim postalGroup As HtmlContainerControl = FindControl("postalGroup")
        Dim countryGroup As HtmlContainerControl = FindControl("countryGroup")
        Dim coordinatesGroup As HtmlContainerControl = FindControl("coordinatesGroup")

        Try
            If exact Then
                If Not IsNothing(countryGroup) Then countryGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(regionGroup) Then regionGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(rayonGroup) Then rayonGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(townGroup) Then townGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(streetGroup) Then streetGroup.Attributes.Add("class", "col-md-12")
                If Not IsNothing(buildingHouseApartmentGroup) Then buildingHouseApartmentGroup.Attributes.Add("class", "col-md-12")
                If Not IsNothing(postalGroup) Then postalGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(coordinatesGroup) Then coordinatesGroup.Attributes.Add("class", "col-md-12")
            ElseIf relative Then
                If Not IsNothing(countryGroup) Then countryGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(regionGroup) Then regionGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(rayonGroup) Then rayonGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(townGroup) Then townGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(streetGroup) Then streetGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(buildingHouseApartmentGroup) Then buildingHouseApartmentGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(postalGroup) Then postalGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(coordinatesGroup) Then coordinatesGroup.Attributes.Add("class", "hidden")
            ElseIf foreign Then
                If Not IsNothing(countryGroup) Then countryGroup.Attributes.Add("class", "col-md-6")
                If Not IsNothing(regionGroup) Then regionGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(rayonGroup) Then rayonGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(townGroup) Then townGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(streetGroup) Then streetGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(buildingHouseApartmentGroup) Then buildingHouseApartmentGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(postalGroup) Then postalGroup.Attributes.Add("class", "hidden")
                If Not IsNothing(coordinatesGroup) Then coordinatesGroup.Attributes.Add("class", "hidden")
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

    Private Sub SendNotification()

        Try
            'Check to see if the calling page is requesting that notification of any selection of the Country, Region, Rayon, or Settlement is made
            If (SelectionNotification = "True") Then
                'Generic raised event to indicate back that a change was commited for a specific called location user control
                'This can be expanded on, if necessary, but this was needed to indicate a change for the outbreak module
                RaiseEvent ItemSelected(ID)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Called by VetAggCase.aspx.vb when user selects a different value from SearchAdminDDL - "ToggleSearchAdminDDLs"
    ''' </summary>
    ''' <param name="sAdmin"></param>
    Public Sub ToggleLUC(ByVal sAdmin As String)

        Try
            FillCountry(Session("LocationCountryID"), Session("Country"))

            If sAdmin = 10003001 Or sAdmin = 10003003 Then 'Country or Region
                'VAUC07 => If “Country” value is selected, the system shall disable “Rayon”, “Settlement”, and “Organization” fields.
                FillRegion(Nothing, Nothing)
                FillRayon(Nothing, Nothing)
                FillSettlement(Nothing, Nothing)

            ElseIf sAdmin = 10003002 Then 'Rayon
                'VAUC07 => If “Rayon” (default) value is selected, the system shall disable “Settlement” and “Organization” field.
                DdlRegion.Enabled = True
                DdlRayon.Enabled = True
                FillSettlement(Nothing, Nothing)

            ElseIf sAdmin = 10003005 Then 'Settlement
                'VAUC07 => If “Settlement” value is selected, fields “Region”, “Rayon”, and “Settlement” are enabled, and “Organization” field shall be disabled. 
                DdlRegion.Enabled = True
                DdlRayon.Enabled = True
                DdlSettlement.Enabled = True

            ElseIf sAdmin = 10003006 Then 'Organization
                'VAUC07 => If “Organization” value is selected, all fields “Region”, “Rayon”, “Settlement”, and “Organization” are enabled.
                DdlRegion.Enabled = True
                DdlRayon.Enabled = True
                DdlSettlement.Enabled = True

            ElseIf sAdmin = 10003004 Then 'Town
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

End Class