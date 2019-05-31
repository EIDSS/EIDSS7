Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain

''' <summary>
''' 
''' </summary>
Public Class HorizontalLocationUserControl
    Inherits UserControl

#Region "Properties"

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(HorizontalLocationUserControl))

    Public Event ItemSelected(id As String)

    Public Property IsHorizontalLayout As Boolean
    Public Property LocationCountryID As Long?
    Public Property LocationCountryName As String
    Public Property LocationRegionID As Long?
    Public Property LocationRegionName As String
    Public Property LocationRayonID As Long?
    Public Property LocationRayonName As String
    ''' <summary>
    ''' Settlement type indicates town, village or other values as determined by each country.
    ''' </summary>
    ''' <returns></returns>
    Public Property LocationSettlementTypeID As Long?
    ''' <summary>
    ''' Settlement ID is the identification of the town, village, etc.
    ''' </summary>
    ''' <returns></returns>
    Public Property LocationSettlementID As Long?
    Public Property LocationSettlementName As String
    Public Property LocationPostalCodeID As Long?
    Public Property LocationPostalCodeName As String
    Public Property SelectionNotification As Boolean

    Private countryValue

    Public Property SelectedCountryValue As String
        Get
            If String.IsNullOrEmpty(countryValue) Then
                If String.IsNullOrEmpty(ddlidfsCountry.SelectedValue) Then
                    countryValue = "-1"
                Else
                    countryValue = ddlidfsCountry.SelectedValue
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
                If IsNothing(ddlidfsCountry.SelectedItem) Then
                    countryText = Nothing
                Else
                    countryText = ddlidfsCountry.SelectedItem.Text
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
                If String.IsNullOrEmpty(ddlidfsRegion.SelectedValue) Then
                    regionValue = "-1"
                Else
                    regionValue = ddlidfsRegion.SelectedValue
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
                If IsNothing(ddlidfsRegion.SelectedItem) Then
                    regionText = String.Empty
                Else
                    regionText = ddlidfsRegion.SelectedItem.Text
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
                If String.IsNullOrEmpty(ddlidfsRayon.SelectedValue) Then
                    rayonValue = "-1"
                Else
                    rayonValue = ddlidfsRayon.SelectedValue
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
                If IsNothing(ddlidfsRayon.SelectedItem) Then
                    rayonText = String.Empty
                Else
                    rayonText = ddlidfsRayon.SelectedItem.Text
                End If
            End If
            Return rayonText
        End Get
        Set(value As String)
            rayonText = value
        End Set
    End Property

    Private settlementTypeValue As String

    Public Property SelectedSettlementTypeValue As String
        Get
            If String.IsNullOrEmpty(settlementTypeValue) Then
                If String.IsNullOrEmpty(ddlSettlementType.SelectedValue) Then
                    settlementTypeValue = "-1"
                Else
                    settlementTypeValue = ddlSettlementType.SelectedValue
                End If
            End If
            Return settlementTypeValue
        End Get
        Set(value As String)
            settlementTypeValue = value
        End Set
    End Property

    Private settlementValue As String

    Public Property SelectedSettlementValue As String
        Get
            If String.IsNullOrEmpty(settlementValue) Then
                If String.IsNullOrEmpty(ddlidfsSettlement.SelectedValue) Then
                    settlementValue = "-1"
                Else
                    settlementValue = ddlidfsSettlement.SelectedValue
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
                If IsNothing(ddlidfsSettlement.SelectedItem) Then
                    settlementText = String.Empty
                Else
                    settlementText = ddlidfsSettlement.SelectedItem.Text
                End If
            End If
            Return settlementText
        End Get
        Set(value As String)
            settlementText = value
        End Set
    End Property

    Private settlementTypeText As String

    Public Property SelectedSettlementTypeText As String
        Get
            If String.IsNullOrEmpty(settlementTypeText) Then
                If IsNothing(ddlSettlementType.SelectedItem) Then
                    settlementTypeText = String.Empty
                Else
                    settlementTypeText = ddlSettlementType.SelectedItem.Text
                End If
            End If
            Return settlementTypeText
        End Get
        Set(value As String)
            settlementTypeText = value
        End Set
    End Property

    Private postalValue As String

    Public Property SelectedPostalValue As String
        Get
            If String.IsNullOrEmpty(postalValue) Then
                If String.IsNullOrEmpty(ddlidfsPostalCode.SelectedValue) Then
                    postalValue = "-1"
                Else
                    postalValue = ddlidfsPostalCode.SelectedValue
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
                If IsNothing(ddlidfsPostalCode.SelectedItem) Then
                    postalText = String.Empty
                Else
                    postalText = ddlidfsPostalCode.SelectedItem.Text
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
            Return txtstrStreetName.Text
        End Get
        Set(value As String)
            txtstrStreetName.Text = value
        End Set
    End Property

    Public Property BuildingText As String
        Get
            Return txtstrBuilding.Text
        End Get
        Set(value As String)
            txtstrBuilding.Text = value
        End Set
    End Property

    Public Property HouseText As String
        Get
            Return txtstrHouse.Text
        End Get
        Set(value As String)
            txtstrHouse.Text = value
        End Set
    End Property

    Public Property ApartmentText As String
        Get
            Return txtstrApartment.Text
        End Get
        Set(value As String)
            txtstrApartment.Text = value
        End Set
    End Property

    Public Property LatitudeText As String
        Get
            Return txtstrLatitude.Text
        End Get
        Set(value As String)
            txtstrLatitude.Text = value
        End Set
    End Property

    Public Property LongitudeText As String
        Get
            Return txtstrLongitude.Text
        End Get
        Set(value As String)
            txtstrLongitude.Text = value
        End Set
    End Property

    Public Property ElevationText As String
        Get
            Return txtstrElevation.Text
        End Get
        Set(value As String)
            txtstrElevation.Text = value
        End Set
    End Property

    Public Property ValidationGroup As String
    Public Property IsDbRequiredCountry As Boolean
    Public Property IsDbRequiredRegion As Boolean
    Public Property IsDbRequiredRayon As Boolean
    Public Property IsDbRequiredSettlement As Boolean
    Public Property IsDbRequiredStreet As Boolean
    Public Property IsDbRequiredBuilding As Boolean
    Public Property IsDbRequiredHouse As Boolean
    Public Property IsDbRequiredApartment As Boolean
    Public Property IsDbRequiredPostalCode As Boolean
    Public Property IsDbRequiredLatitude As Boolean
    Public Property IsDbRequiredLongitude As Boolean
    Public Property IsDbRequiredElevation As Boolean
    Public Property ShowCountry As Boolean = True
    Public Property ShowCountryOnly As Boolean = False
    Public Property ShowRegion As Boolean = True
    Public Property ShowRayon As Boolean = True
    Public Property ForceEditRayonFill As Boolean = False
    Public Property ShowSettlementType As Boolean = True
    Public Property ShowSettlement As Boolean = True
    Public Property ShowStreet As Boolean = True
    Public Property ShowBuildingHouseApartmentGroup As Boolean = True
    Public Property ShowBuilding As Boolean = True
    Public Property ShowHouse As Boolean = True
    Public Property ShowApartment As Boolean = True
    Public Property ShowPostalCode As Boolean = True
    Public Property ShowCoordinates As Boolean = True
    Public Property ShowLatitude As Boolean = True
    Public Property ShowLongitude As Boolean = True
    Public Property ShowMap As Boolean = True
    Public Property ShowElevation As Boolean = True

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
                If ShowCountryOnly Then
                    divCountry.Visible = True
                    divRegion.Visible = False
                    divRayon.Visible = False
                    divSettlementGroup.Visible = False
                    divBuildingHouseApartment.Visible = False
                    divPostalCode.Visible = False
                    divCoordinates.Visible = False

                    reqApartment.Visible = False
                    reqBuilding.Visible = False
                    reqCountry.Visible = IsDbRequiredCountry
                    reqElevation.Visible = False
                    reqHouse.Visible = False
                    reqLatitude.Visible = False
                    reqLongitude.Visible = False
                    reqPostalCode.Visible = False
                    reqRayon.Visible = False
                    reqRegion.Visible = False
                    reqSettlement.Visible = False
                    reqStreetName.Visible = False

                    valCountry.Enabled = True
                    valRegion.Enabled = False
                    valRayon.Enabled = False
                    valSettlement.Enabled = False
                    valStreetName.Enabled = False
                    valApartment.Enabled = False
                    valBuilding.Enabled = False
                    valHouse.Enabled = False
                    valPostalCode.Enabled = False
                    valLatitude.Enabled = False
                    valLongitude.Enabled = False
                    valElevation.Enabled = False
                Else
                    divCountry.Visible = ShowCountry
                    valCountry.Enabled = IsDbRequiredCountry
                    divRegion.Visible = ShowRegion
                    valRegion.Enabled = IsDbRequiredRegion
                    divRayon.Visible = ShowRayon
                    valRayon.Enabled = IsDbRequiredRayon
                    divSettlementGroup.Visible = True
                    divSettlementType.Visible = ShowSettlementType
                    divSettlement.Visible = ShowSettlement
                    valSettlement.Enabled = IsDbRequiredSettlement
                    divStreet.Visible = ShowStreet
                    valStreetName.Enabled = IsDbRequiredStreet
                    divBuildingHouseApartment.Visible = ShowBuildingHouseApartmentGroup
                    valApartment.Enabled = IsDbRequiredApartment
                    valBuilding.Enabled = IsDbRequiredBuilding
                    valHouse.Enabled = IsDbRequiredHouse
                    divPostalCode.Visible = ShowPostalCode
                    valPostalCode.Enabled = IsDbRequiredPostalCode
                    divCoordinates.Visible = ShowCoordinates
                    divElevation.Visible = ShowElevation
                    divLatitude.Visible = ShowLatitude
                    divLongitude.Visible = ShowLongitude
                    valLatitude.Enabled = IsDbRequiredLatitude
                    valLongitude.Enabled = IsDbRequiredLongitude
                    valElevation.Enabled = IsDbRequiredElevation

                    reqApartment.Visible = IsDbRequiredApartment
                    reqBuilding.Visible = IsDbRequiredBuilding
                    reqCountry.Visible = IsDbRequiredCountry
                    reqElevation.Visible = IsDbRequiredElevation
                    reqHouse.Visible = IsDbRequiredHouse
                    reqLatitude.Visible = IsDbRequiredLatitude
                    reqLongitude.Visible = IsDbRequiredLongitude
                    reqPostalCode.Visible = IsDbRequiredPostalCode
                    reqRayon.Visible = IsDbRequiredRayon
                    reqRegion.Visible = IsDbRequiredRegion
                    reqSettlement.Visible = IsDbRequiredSettlement
                    reqStreetName.Visible = IsDbRequiredStreet

                    If ShowMap And IsGoogleAuthorized() Then
                        SetMapScripts()

                        btnMap.Attributes.Add("data-target", $"#{ClientID}_divMapModal")
                        btnMap.Attributes.Add("onclick", $"setMapObject('{divMapModal.ClientID}');")
                        btnMap.Visible = True
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
    Public Sub Setup(CallerCrossCuttingAPIService As CrossCuttingServiceClient)

        valApartment.ValidationGroup = ValidationGroup
        valBuilding.ValidationGroup = ValidationGroup
        valCountry.ValidationGroup = ValidationGroup
        valElevation.ValidationGroup = ValidationGroup
        valHouse.ValidationGroup = ValidationGroup
        valLatitude.ValidationGroup = ValidationGroup
        valLongitude.ValidationGroup = ValidationGroup
        valPostalCode.ValidationGroup = ValidationGroup
        valRayon.ValidationGroup = ValidationGroup
        valRegion.ValidationGroup = ValidationGroup
        valSettlement.ValidationGroup = ValidationGroup
        valStreetName.ValidationGroup = ValidationGroup

        CrossCuttingAPIService = CallerCrossCuttingAPIService
        DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SetMapScripts()

        Dim section As NameValueCollection
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
        sb.AppendLine($"{vbTab}var parentNodeName = activeMap.replace(""divMapModal"", """");")
        sb.AppendLine($"{vbTab}for( var x = 0; x < inputs.length; x++){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}if(inputs[x].id.startsWith(parentNodeName)){"{"}")
        sb.AppendLine($"{vbTab}{vbTab}{vbTab}return inputs[x];{vbCr}{vbTab}{vbTab}{"}"}")
        sb.AppendLine($"{vbTab}{"}"}{vbCr}{vbTab}throw ""control Not found"";{vbCr}{"}"};{vbCr}")

        sb.AppendLine($"function getActiveLongitudeInput() {"{"}")
        sb.AppendLine($"{vbTab}var activeMap = mapObject.id;")
        sb.AppendLine($"{vbTab}var inputs = $('input[name *= ""Longitude""]');")
        sb.AppendLine($"{vbTab}var parentNodeName = activeMap.replace(""divMapModal"", """");")
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
        sb.Append($"$(document).ready(function(){"{"}{vbCr}{vbTab}$(""#{ClientID}_divMapModal"").on(""shown.bs.modal"", initMap);{vbCrLf}{"}"});")
        Return sb.ToString()

    End Function

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

            If ShowElevation Then
                lblElevation.Visible = True
                txtstrElevation.Visible = True
            Else
                lblElevation.Visible = False
                txtstrElevation.Visible = False
            End If

            If ShowMap Then
                lblMap.Visible = True
                btnMap.Visible = True
            Else
                lblMap.Visible = False
                btnMap.Visible = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillSettlementTypes()

        Try
            Dim settlementTypes As List(Of SettlementTypeGetLookupModel) = CrossCuttingAPIService.GetSettlementTypeListAsync(GetCurrentLanguage()).Result.OrderBy(Function(x) x.name).ToList()

            FillDropDownList(ddlSettlementType, settlementTypes, {GlobalConstants.NullValue.ToLower()}, "idfsReference", "name", Nothing, Nothing, True)

            If settlementTypes.Count < 2 Then
                divSettlementType.Visible = False
            Else
                divSettlementType.Visible = True
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function IsGoogleAuthorized()

        Dim section As NameValueCollection
        section = CType(ConfigurationManager.GetSection("GoogleMaps"), NameValueCollection)

        If IsNothing(section) Then
            Return False
        End If

        Dim googleKey As String = section.Item("securityToken").ToString()

        If String.IsNullOrEmpty(googleKey) Then
            Return False
        End If

        Return True

    End Function

#End Region

#Region "Fill Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillControlForInsert()

        If String.IsNullOrEmpty(SelectedCountryText) And (SelectedCountryValue = "-1" Or SelectedCountryValue = GlobalConstants.NullValue.ToLower()) Then
            FillCountry(Nothing, getConfigValue("DefaultCountry").ToString())
        ElseIf String.IsNullOrEmpty(SelectedCountryText) And SelectedCountryValue <> "-1" Then
            FillCountry(SelectedCountryValue, Nothing)
        ElseIf (String.IsNullOrEmpty(SelectedCountryText) = False) And SelectedCountryValue = "-1" Then
            FillCountry(Nothing, SelectedCountryText)
        Else
            FillCountry(SelectedCountryValue, SelectedCountryText)
        End If

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
            ddlidfsRayon.Enabled = False
        ElseIf String.IsNullOrEmpty(SelectedRayonText) And SelectedRayonValue <> "-1" Then
            FillRayon(SelectedRayonValue, Nothing)
            ddlidfsRayon.Enabled = True
        ElseIf (String.IsNullOrEmpty(SelectedRayonText) = False) And SelectedRayonValue = "-1" Then
            FillRayon(Nothing, SelectedRayonText)
            ddlidfsRayon.Enabled = True
        Else
            FillRayon(SelectedRayonValue, SelectedRayonText)
            ddlidfsRayon.Enabled = True
        End If

        If String.IsNullOrEmpty(SelectedSettlementText) And (SelectedSettlementValue = "-1" Or SelectedSettlementValue = GlobalConstants.NullValue.ToLower()) Then
            ddlidfsSettlement.Enabled = False
        ElseIf String.IsNullOrEmpty(SelectedSettlementText) And SelectedSettlementValue <> "-1" Then
            FillSettlement(SelectedSettlementValue, Nothing)
            ddlSettlementType.Enabled = True
            ddlidfsSettlement.Enabled = True
        ElseIf (String.IsNullOrEmpty(SelectedSettlementText) = False) And SelectedSettlementValue = "-1" Then
            FillSettlement(Nothing, SelectedSettlementText)
            ddlSettlementType.Enabled = True
            ddlidfsSettlement.Enabled = True
        Else
            FillSettlement(SelectedSettlementValue, SelectedSettlementText)
            ddlidfsSettlement.Enabled = True
        End If

        If String.IsNullOrEmpty(SelectedPostalText) And (SelectedPostalValue = "-1" Or SelectedPostalValue = GlobalConstants.NullValue.ToLower()) Then
            ddlidfsPostalCode.Enabled = False
        ElseIf String.IsNullOrEmpty(SelectedPostalText) And SelectedPostalValue <> "-1" Then
            FillPostalCode(postalValue, Nothing)
            ddlidfsPostalCode.Enabled = True
        ElseIf (String.IsNullOrEmpty(SelectedPostalText) = False) And SelectedPostalValue = "-1" Then
            FillPostalCode(Nothing, SelectedPostalText)
            ddlidfsPostalCode.Enabled = True
        Else
            FillPostalCode(SelectedPostalValue, SelectedPostalText)
            ddlidfsPostalCode.Enabled = True
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillControlforEdit()

        If LocationCountryID.HasValue Then
            FillCountry(LocationCountryID, Nothing)
        ElseIf String.IsNullOrEmpty(LocationCountryName) = False Then
            FillCountry(Nothing, LocationCountryName)
        Else
            FillCountry(Nothing, getConfigValue("DefaultCountry").ToString())
        End If

        If ShowRegion Then
            If LocationRegionID.HasValue Then
                FillRegion(LocationRegionID, Nothing)
            ElseIf String.IsNullOrEmpty(LocationRegionName) = False Then
                FillRegion(Nothing, LocationRegionName)
            Else
                FillRegion(Nothing, Nothing)
            End If
        End If

        If ShowRayon Then
            If LocationRayonID.HasValue Then
                FillRayon(LocationRayonID, Nothing)
            ElseIf String.IsNullOrEmpty(LocationRayonName) = False Then
                FillRayon(Nothing, LocationRayonName)
            Else
                FillRayon(Nothing, Nothing)
            End If
        End If

        If ShowSettlementType Then
            If LocationSettlementTypeID.HasValue Then
                ddlSettlementType.SelectedValue = LocationSettlementTypeID
            End If
        End If

        If ShowSettlement Then
            If LocationSettlementID.HasValue Then
                FillSettlement(LocationSettlementID, Nothing)
            ElseIf String.IsNullOrEmpty(LocationSettlementName) = False Then
                FillSettlement(Nothing, LocationSettlementName)
            Else
                FillSettlement(Nothing, Nothing)
            End If
        End If

        If ShowPostalCode Then
            If LocationPostalCodeID.HasValue Then
                FillPostalCode(LocationPostalCodeID, Nothing)
            ElseIf String.IsNullOrEmpty(LocationPostalCodeName) = False Then
                FillPostalCode(Nothing, LocationPostalCodeName)
            Else
                FillPostalCode(Nothing, Nothing)
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillCountry(selectedValue As String, selectedText As String)

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If
        Dim list As List(Of CountryGetLookupModel) = CrossCuttingAPIService.GetCountryListAsync(GetCurrentLanguage()).Result.OrderBy(Function(x) x.strCountryName).ToList()
        FillDropDownList(ddlidfsCountry, list, {GlobalConstants.NullValue.ToLower()}, CountryConstants.CountryID, CountryConstants.CountryName, selectedValue, selectedText, True)

        If ShowCountryOnly Then
            ShowCountry = True
        End If

        If (ShowCountry = True) Then
            If ddlidfsCountry.SelectedIndex = 0 Or ShowCountryOnly Then
                ddlidfsRegion.Enabled = False
                ddlidfsRayon.Enabled = False
                ddlSettlementType.Enabled = False
                ddlidfsSettlement.Enabled = False
                txtstrStreetName.Enabled = False
                txtstrApartment.Enabled = False
                txtstrBuilding.Enabled = False
                txtstrHouse.Enabled = False
                If ShowCountryOnly Then
                    valRegion.Enabled = False
                    valRayon.Enabled = False
                    valSettlement.Enabled = False
                End If
            End If
        Else
            ddlidfsRegion.Enabled = True
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillRegion(selectedValue As String, selectedText As String)

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If
        Dim list As List(Of RegionGetLookupModel) = CrossCuttingAPIService.GetRegionListAsync(GetCurrentLanguage(), ddlidfsCountry.SelectedValue.ToString(), Nothing).Result.OrderBy(Function(x) x.strRegionName).ToList()
        FillDropDownList(ddlidfsRegion, list, Nothing, RegionConstants.RegionID, RegionConstants.RegionName, selectedValue, selectedText, True)

        If ddlidfsRegion.SelectedIndex = 0 Then
            ddlidfsRayon.Enabled = False
            ddlSettlementType.Enabled = False
            ddlidfsSettlement.Enabled = False
            txtstrStreetName.Enabled = False
            txtstrApartment.Enabled = False
            txtstrBuilding.Enabled = False
            txtstrHouse.Enabled = False
            ddlidfsPostalCode.Enabled = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillRayon(selectedValue As String, selectedText As String)

        Dim regionID As Long?,
            rayonID As Long?

        If ddlidfsRegion.SelectedValue.IsValueNullOrEmpty() Then
            regionID = Nothing
        Else
            regionID = CType(ddlidfsRegion.SelectedValue, Long)
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
        FillDropDownList(ddlidfsRayon, list, {GlobalConstants.NullValue.ToLower()}, RayonConstants.RayonID, RayonConstants.RayonName, selectedValue, selectedText, True)

        If ddlidfsRayon.SelectedIndex = 0 Then
            ddlSettlementType.Enabled = False
            ddlidfsSettlement.Enabled = False
            txtstrStreetName.Enabled = False
            txtstrApartment.Enabled = False
            txtstrBuilding.Enabled = False
            txtstrHouse.Enabled = False
            ddlidfsPostalCode.Enabled = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillSettlement(selectedValue As String, selectedText As String)

        Dim rayonID As Long?,
            settlementID As Long?

        If ddlidfsRayon.SelectedValue.IsValueNullOrEmpty() Then
            rayonID = Nothing
        Else
            rayonID = CType(ddlidfsRayon.SelectedValue, Long)
        End If

        If selectedValue.IsValueNullOrEmpty() Then
            settlementID = Nothing
        Else
            settlementID = CType(selectedValue, Long)
        End If

        If Not rayonID Is Nothing Then
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Dim settlements As List(Of SettlementGetLookupModel) = CrossCuttingAPIService.GetSettlementListAsync(GetCurrentLanguage(), rayonID, settlementID).Result.OrderBy(Function(x) x.strSettlementName).ToList()

            Dim selectedSettlementType As String = ddlSettlementType.SelectedValue
            FillSettlementTypes()
            If Not selectedSettlementType = String.Empty Then
                ddlSettlementType.SelectedValue = selectedSettlementType
            End If

            If settlements.Where(Function(x) x.SettlementTypeID = SettlementTypes.Settlement).Count = 0 Then
                    ddlSettlementType.Items.Remove(ddlSettlementType.Items.FindByValue(SettlementTypes.Settlement))
                End If

                If settlements.Where(Function(x) x.SettlementTypeID = SettlementTypes.Town).Count = 0 Then
                    ddlSettlementType.Items.Remove(ddlSettlementType.Items.FindByValue(SettlementTypes.Town))
                End If

                If settlements.Where(Function(x) x.SettlementTypeID = SettlementTypes.Village).Count = 0 Then
                    ddlSettlementType.Items.Remove(ddlSettlementType.Items.FindByValue(SettlementTypes.Village))
                End If

                If ddlSettlementType.Items.Count > 2 Then
                    ddlSettlementType.Items(0).Text = "ALL"
                End If

                If ddlSettlementType.Items.Count < 2 Then
                    divSettlementGroup.Visible = False
                Else
                    divSettlementGroup.Visible = True
                End If

                If ddlSettlementType.SelectedValue = GlobalConstants.NullValue.ToLower() Then
                    FillDropDownList(ddlidfsSettlement, settlements, {GlobalConstants.NullValue.ToLower()}, TownOrVillageConstants.TownOrVillageID, TownOrVillageConstants.TownOrVillageName, selectedValue, selectedText, True)
                Else
                    FillDropDownList(ddlidfsSettlement, settlements.Where(Function(x) x.SettlementTypeID = ddlSettlementType.SelectedValue).ToList(), {GlobalConstants.NullValue.ToLower()}, TownOrVillageConstants.TownOrVillageID, TownOrVillageConstants.TownOrVillageName, selectedValue, selectedText, True)
                End If
            End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectedValue"></param>
    ''' <param name="selectedText"></param>
    Private Sub FillPostalCode(selectedValue As String, selectedText As String)

        Dim settlementID As Long?

        If ddlidfsSettlement.SelectedValue.IsValueNullOrEmpty() Then
            settlementID = Nothing
        Else
            settlementID = CType(ddlidfsSettlement.SelectedValue, Long)
        End If

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If
        Dim list As List(Of PostalCodeGetLookupModel) = CrossCuttingAPIService.GetPostalCodeListAsync(settlementID).Result.OrderBy(Function(x) x.strPostCode).ToList()
        FillDropDownList(ddlidfsPostalCode, list, {GlobalConstants.NullValue.ToLower()}, PostalCodeConstants.PostalCodeID, PostalCodeConstants.PostalCodeName, selectedValue, selectedText, True)

    End Sub

#End Region

#Region "Event Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub Country_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            ddlidfsRayon.Enabled = False
            ddlSettlementType.Enabled = False
            ddlidfsSettlement.Enabled = False
            txtstrStreetName.Enabled = False
            ddlidfsPostalCode.Enabled = False
            txtstrApartment.Enabled = False
            txtstrBuilding.Enabled = False
            txtstrHouse.Enabled = False
            FillRegion(Nothing, Nothing)

            'Force clearing of the rayon and settlement as the country has been cleared out.
            If ShowCountryOnly Then
                ShowCountry = True
            End If

            If (ShowCountry = True) Then
                If ddlidfsCountry.SelectedIndex = 0 Or ShowCountryOnly Then
                    ddlidfsRegion.Enabled = False
                    FillRayon(Nothing, Nothing)
                    FillSettlement(Nothing, Nothing)
                    If ShowCountryOnly Then
                        valRegion.Enabled = False
                        valRayon.Enabled = False
                        valSettlement.Enabled = False
                    End If
                Else
                    ddlidfsRegion.Enabled = True
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
    Protected Sub Region_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsRegion.SelectedIndexChanged

        Try
            upSettlementGroup.Update()
            upStreetBuildingHouseApartmentPostalCode.Update()

            ddlidfsPostalCode.ClearSelection()
            ddlidfsPostalCode.Enabled = False
            ddlidfsSettlement.ClearSelection()
            ddlSettlementType.Enabled = False
            ddlSettlementType.Items.Clear()
            ddlidfsSettlement.Enabled = False
            txtstrApartment.Enabled = False
            txtstrBuilding.Enabled = False
            txtstrHouse.Enabled = False
            txtstrStreetName.Enabled = False
            FillRayon(Nothing, Nothing)
            'Force clearing of the settlement as the region has been cleared out.
            FillSettlement(Nothing, Nothing)

            If ddlidfsRegion.SelectedIndex = 0 Then
                ddlidfsRayon.Enabled = False
            Else
                ddlidfsRayon.Enabled = True
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
    Protected Sub Rayon_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsRayon.SelectedIndexChanged

        Try
            txtstrStreetName.Enabled = False
            ddlidfsPostalCode.Enabled = False
            txtstrApartment.Enabled = False
            txtstrBuilding.Enabled = False
            txtstrHouse.Enabled = False
            FillSettlement(Nothing, Nothing)
            ddlidfsRegion.Enabled = True

            If ddlidfsRayon.SelectedIndex = 0 Then
                ddlSettlementType.Enabled = False
                ddlidfsSettlement.Enabled = False
            Else
                ddlSettlementType.Enabled = True
                ddlidfsSettlement.Enabled = True
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
    Protected Sub Settlement_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsSettlement.SelectedIndexChanged

        Try
            ddlidfsPostalCode.Enabled = True
            txtstrStreetName.Enabled = True
            ddlidfsPostalCode.Enabled = True
            txtstrApartment.Enabled = True
            txtstrBuilding.Enabled = True
            txtstrHouse.Enabled = True
            FillPostalCode(Nothing, Nothing)
            ddlidfsRegion.Enabled = True
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

        Dim regionGroup As HtmlContainerControl = FindControl("divRegion")
        Dim rayonGroup As HtmlContainerControl = FindControl("divRayon")
        Dim townGroup As HtmlContainerControl = FindControl("divSettlementGroup")
        Dim streetGroup As HtmlContainerControl = FindControl("divStreet")
        Dim buildingHouseApartmentGroup As HtmlContainerControl = FindControl("divBuildingHouseApartment")
        Dim postalGroup As HtmlContainerControl = FindControl("divPostalCode")
        Dim countryGroup As HtmlContainerControl = FindControl("divCountry")
        Dim coordinatesGroup As HtmlContainerControl = FindControl("divCoordinates")

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

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SendNotification()

        'Check to see if the calling page is requesting that notification of any selection of the Country, Region, Rayon, or Settlement is made
        If (SelectionNotification = "True") Then
            'Generic raised event to indicate back that a change was commited for a specific called location user control
            'This can be expanded on, if necessary, but this was needed to indicate a change for the outbreak module
            RaiseEvent ItemSelected(ID)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub SettlementType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSettlementType.SelectedIndexChanged

        Try
            FillSettlement(Nothing, Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class