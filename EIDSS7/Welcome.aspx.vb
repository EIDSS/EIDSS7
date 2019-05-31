
Public Class Welcome
    Inherits BaseEidssPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        testddl.SearchPageUrl = "../System/Administration/OrganizationAdmin.aspx?isModal=true&ListId=" + testddl.ClientID
        ResetVisibility()
        DisplaySelectedSample()
    End Sub

    Protected Sub testBtn_Click(sender As Object, e As EventArgs)
        mynav.MenuItems(0).ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
        mynav.MenuItems(1).ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
    End Sub

    Protected Sub LoadData(sender As Object, e As EventArgs) Handles btnLoadData.Click

        'Dim dt As New DataTable

        'dt.Columns.Add("idfsCountry", GetType(String))
        'dt.Columns.Add("strCountryName", GetType(String))
        'dt.Columns.Add("idfsRegion", GetType(String))
        'dt.Columns.Add("strRegionName", GetType(String))
        'dt.Columns.Add("idfsRayon", GetType(String))
        'dt.Columns.Add("strRayonName", GetType(String))
        'dt.Columns.Add("idfsSettlement", GetType(String))
        'dt.Columns.Add("strSettlementName", GetType(String))
        'dt.Columns.Add("idfsPostalCode", GetType(String))
        'dt.Columns.Add("strPostCode", GetType(String))
        'dt.Columns.Add("strStreetName", GetType(String))
        'dt.Columns.Add("strBuilding", GetType(String))
        'dt.Columns.Add("strLatitude", GetType(String))
        'dt.Columns.Add("strLongitude", GetType(String))

        'dt.Rows.Add("780000000", "Georgia",
        '            "37050000000", "Imereti",
        '            "1342980000000", "Kutaisi",
        '            "265470000000", "Baraleti",
        '            "",
        '            "",
        '            "Rural Road 47",
        '            "A",
        '            "41.981207267892955",
        '            "43.652763925000045")

        'verticalLocation.LocationCountryID = ds.Tables(0).Rows(0)(CountryConstants.CountryID)
        'verticalLocation.LocationRegionID = ds.Tables(0).Rows(0)(RegionConstants.RegionID)
        'verticalLocation.LocationRayonID = ds.Tables(0).Rows(0)(RayonConstants.RayonID)
        'verticalLocation.LocationSettlementID = ds.Tables(0).Rows(0)(SettlementConstants.idfsSettlement)
        'verticalLocation.LocationPostalCodeID = ds.Tables(0).Rows(0)(PostalCodeConstants.PostalCodeID)
        'verticalLocation.DataBind()

    End Sub

    Private Sub ResetVisibility()
        calendarSample.Visible = False
        dropdownSample.Visible = False
        spinnerSample.Visible = False
        locSampleV.Visible = False
        locSampleH.Visible = False
        sideBarSample.Visible = False
        cancelBtnSample.Visible = False
        dismissableMessageDisplay.Visible = False
    End Sub

    Private Sub DisplaySelectedSample()
        Select Case rblListOfSamples.SelectedValue
            Case 0
                calendarSample.Visible = True
            Case 1
                dropdownSample.Visible = True
            Case 2
                spinnerSample.Visible = True
            Case 3
                locSampleV.Visible = True
            Case 4
                locSampleH.Visible = True
            Case 5
                sideBarSample.Visible = True
            Case 6
                cancelBtnSample.Visible = True
            Case 7
                dismissableMessageDisplay.Visible = True
        End Select
    End Sub
End Class
