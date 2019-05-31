Imports EIDSS.EIDSS

Public Class SettlementDetails
    Inherits BaseEidssPage

    'Private sSettlementId As String
    Private gv As GridView
    Private sObjectID As String = ""
    Private hsModifiedOA As New HashSet(Of String)
    Dim oEIDSSDS As DataSet = Nothing
    Private oComm As clsCommon = New clsCommon()

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack Then

            oEIDSSDS = oComm.ReadEIDSSXML()

            'Check for value saved in Settlement Admin  

            'hdfidfSettlement.Value = -1  '???? why is this set AK - removed



            If oEIDSSDS.CheckDataSet() Then
                    hdfidfsSettlementID.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfsSettlement")
                End If

            ' Unconditionally fill all Settlement Types 
            FillDropDown(ddlidfsSettlementType, GetType(clsSettlementType),
                             Nothing,
                             SettlementTypeConstants.idfsReference,
                             SettlementTypeConstants.Name,
                             Nothing,
                             Nothing,
                             False, )


                LocationUserControl.ElevationText = "0" 'SAUC09


            'Here hdfidfSettlementID.Value <> "-1, then it should be the value that was passed from SettlementAdmin 'if it not new
            If (String.IsNullOrWhiteSpace(hdfidfsSettlementID.Value) OrElse hdfidfsSettlementID.Value <> "-1") Then
                FillFormForEdit()
            End If



        End If

    End Sub
    'Protected Sub ddlSaveSettlementType_SelectedIndexChanged(sender As Object, e As EventArgs)

    '    hdfidfSettlementType.Value = ddlidfsSettlementType.SelectedValue 'AK

    '    hdfidfSettlementType.Value = ddlidfsSettlementType.SelectedItem.Text 'AK


    'End Sub
    Private Sub FillFormForEdit()

        'Assign current settlement id

        Dim oSettlement = New clsSettlement
        Dim dsSettlement = oSettlement.SelectOne(ToInt64(hdfidfsSettlementID.Value))
        If dsSettlement.CheckDataSet() Then

            Dim dtSettlement = dsSettlement.Tables(0)

            'populate location control
            If dtSettlement.Rows(0)(CountryConstants.CountryID).ToString = "" Then
                LocationUserControl.LocationCountryID = Nothing
            Else
                LocationUserControl.LocationCountryID = CType(dtSettlement.Rows(0)(CountryConstants.CountryID), Long)
            End If

            If dtSettlement.Rows(0)(RegionConstants.RegionID).ToString = "" Then
                LocationUserControl.LocationRegionID = Nothing
            Else
                LocationUserControl.LocationRegionID = CType(dtSettlement.Rows(0)(RegionConstants.RegionID), Long)
            End If

            If dtSettlement.Rows(0)(RayonConstants.RayonID).ToString = "" Then
                LocationUserControl.LocationRayonID = Nothing
            Else
                LocationUserControl.LocationRayonID = CType(dtSettlement.Rows(0)(RayonConstants.RayonID), Long)
            End If

            If dtSettlement.Rows(0)("idfsSettlementID").ToString = "" Then
                LocationUserControl.LocationSettlementID = Nothing
            Else
                LocationUserControl.LocationSettlementID = CType(dtSettlement.Rows(0)("idfsSettlementID"), Long)
            End If

            'populate the values on the form
            oComm.Scatter(Me, New DataTableReader(dtSettlement))

            'defect 991 2018-01-24 TLP: storing long/lat in hidden, then copy values into LocationUC
            LocationUserControl.LatitudeText = hdfstrLatitude.Value
            LocationUserControl.LongitudeText = hdfstrLongitude.Value
            LocationUserControl.ElevationText = hdfstrElevation.Value

        End If

    End Sub

    Private Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        'validate the page
        Validate()

        If (Page.IsValid) Then
            SubmitFormData()
        Else
            DisplayValidationErrors()
        End If
    End Sub

    Private Sub SubmitFormData()

        'Serverside validaion of elevation as an int
        If ElevationAsInt(LocationUserControl.ElevationText) Then

            ' Save Personal info
            Dim oService As NG.EIDSSService = oComm.GetService()
            Dim aSP As String()
            Dim sRetVal As String = ""

            Dim oDS As DataSet = New DataSet()
            Dim formValues As String = ""
            Dim oTuple As Object

            aSP = oService.getSPList("SettlementSet")

            formValues = oComm.Gather(SettlementSection, aSP(0).ToString(), 3, True)



            oTuple = oService.GetData(GetCurrentCountry(), "SettlementSet", formValues)
            oDS = oTuple.m_Item1

            If oDS.CheckDataSet() Then ASPNETMsgBox(GetLocalResourceObject("Success_Message_text"), "SettlementAdmin.aspx")

        End If 'End elevation check

    End Sub

    Private Sub DisplayValidationErrors()

        'Paint all SideBarItems as Passed Validation and then correct those that failed
        sideBarItemSettlement.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)
                Select Case section.ID
                    Case "SettlementSection"
                        sideBarItemSettlement.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                        sideBarItemSettlement.CssClass = "glyphicon glyphicon-remove"
                End Select

            End If
        Next

    End Sub

    Private Function ElevationAsInt(ByVal elev As String) As Boolean

        ElevationAsInt = False
        If elev = "" Then
            ElevationAsInt = True
        Else
            Dim iElevation As Integer
            If Integer.TryParse(elev, iElevation) Then
                ElevationAsInt = True
            Else
                ASPNETMsgBox("Elevation must be an integer")
            End If
        End If

        Return ElevationAsInt

    End Function

    Private Sub SettlementDetails_Error(sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then

            ASPNETMsgBox("An error occurred on this page. Please verify your information to resolve the issue.")

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