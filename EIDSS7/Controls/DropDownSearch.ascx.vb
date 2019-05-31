Imports EIDSS.EIDSS
Public Class DropDownSearch
    Inherits System.Web.UI.UserControl

    Public Enum OrganizationTextField
        Name = 1
        FullName = 2
        EnglishFullName = 3
        EnglishName = 4
        strOrganizationID = 5
    End Enum

    Public Enum EmployeeTextField
        strFirstName = 1
        strLastName = 2

    End Enum

    Public Enum PersonTextField
        strFirstName = 1
        strLastName = 2

    End Enum

    Public Enum TypeOfSearch
        Employee = 1
        Organization = 2
        Person = 3
        Outbreak = 4
    End Enum

    Public ReadOnly Property SelectedValue As String
        Get
            If ddlAllItems.SelectedIndex = -1 Then
                Return String.Empty
            Else
                Return ddlAllItems.SelectedValue
            End If
        End Get
    End Property

    Public Property SearchType As TypeOfSearch
        Get
            Return _searchType
        End Get
        Set(value As TypeOfSearch)
            _searchType = value
        End Set
    End Property

    Public Property FillOnLoad As Boolean
        Get
            Return _fillOnLoad
        End Get
        Set(value As Boolean)
            _fillOnLoad = value
        End Set
    End Property

    Public Property DataSource As Object
        Get
            Return ddlAllItems.DataSource
        End Get
        Set(value As Object)
            ddlAllItems.DataSource = value
        End Set
    End Property

    Public Property OrganizationDisplayField As OrganizationTextField
        Get
            Return _organizationDisplayField
        End Get
        Set(value As OrganizationTextField)
            _organizationDisplayField = value
        End Set
    End Property

    Public Property EmployeeDisplayField As EmployeeTextField
        Get
            Return _employeeDisplayField
        End Get
        Set(value As EmployeeTextField)
            _employeeDisplayField = value
        End Set
    End Property

    Public Property PersonDisplayField As PersonTextField
        Get
            Return _personDisplayField
        End Get
        Set(value As PersonTextField)
            _personDisplayField = value
        End Set
    End Property

    Private _searchType As TypeOfSearch
    Private _fillOnLoad As Boolean
    Private _organizationDisplayField
    Private _employeeDisplayField
    Private _personDisplayField
    Private _outbreakDisplayField

    Private oDS As DataSet
    Private oOrganization As New EIDSS.clsOrganization
    Private oEmployeeAdmin As New EIDSS.clsEmployee
    Private oPerson As New EIDSS.clsPerson

    Private Shared oComm As clsCommon = New clsCommon
    Private Shared oService As NG.EIDSSService = oComm.getService()

    Protected Overrides Sub OnPreRender(e As EventArgs)
        If Not IsPostBack Then
            If SearchType = TypeOfSearch.Employee And EmployeeDisplayField = Nothing Then
                Throw New ApplicationException("Please set an employee field to display.")
            End If

            If SearchType = TypeOfSearch.Organization And OrganizationDisplayField = Nothing Then
                Throw New ApplicationException("Please set an organization field to display.")
            End If

            If SearchType = TypeOfSearch.Person And PersonDisplayField = Nothing Then
                Throw New ApplicationException("Please set a person field to display.")
            End If
        End If
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If _fillOnLoad Then
                Select Case SearchType
                    Case TypeOfSearch.Organization
                        'Load Organization List
                        FillDropDown(ddlAllItems, GetType(clsOrganization),
                              Nothing,
                             OrganizationConstants.idfInstitution,
                             OrganizationTextField.EnglishName.ToString(),
                             String.Empty,
                             Nothing,
                             True)
                        pnlOrganization.Visible = True
                        LoadOrganizationDropdowns()
                    Case TypeOfSearch.Employee
                        FillDropDown(ddlAllItems, GetType(clsEmployee),
                              Nothing,
                             EmployeeConstants.idfEmployee,
                             "strFamilyName",
                             String.Empty,
                             Nothing,
                             True)
                        pnlEmployee.Visible = True
                        LoadEmployeeDropdowns()
                    Case TypeOfSearch.Outbreak
                        LoadOutbreakDropdowns()
                    Case TypeOfSearch.Person
                        FillDropDown(ddlAllItems, GetType(clsPerson),
                                     Nothing,
                                     PersonConstants.idfPerson,
                                     "strLastName",
                                     String.Empty,
                                     Nothing,
                                     True)
                        pnlPerson.Visible = True
                        LoadPersonDropdowns()
                End Select
            Else
                Select Case SearchType
                    Case TypeOfSearch.Organization
                        pnlOrganization.Visible = True
                        LoadOrganizationDropdowns()
                    Case TypeOfSearch.Employee
                        pnlEmployee.Visible = True
                        LoadEmployeeDropdowns()
                    Case TypeOfSearch.Outbreak
                        pnlOutbreak.Visible = True
                        LoadOutbreakDropdowns()
                    Case TypeOfSearch.Person
                        pnlPerson.Visible = True
                        LoadPersonDropdowns()
                End Select
            End If

        End If
    End Sub

    Private Function FillOrganizationList() As DataSet

        FillOrganizationList = Nothing
        oDS = New DataSet()

        Try
            oDS = oOrganization.ListAll()
            Dim strFilter As String = ""

            If txtUniqueOrgID.Text <> "" Then
                strFilter += $"{OrganizationConstants.strOrganizationID} Like '{txtUniqueOrgID.Text.ToString.Trim()}%'"
            End If

            If txtAbbrevation.Text <> "" Then
                strFilter += $"{OrganizationConstants.OrgName} Like '{txtAbbrevation.Text.ToString.Trim()}%'"
            End If

            If txtOrginazationFullName.Text <> "" Then
                strFilter += $" And {OrganizationConstants.EnglishFullName} Like '{txtOrginazationFullName.Text.ToString.Trim()}%'"
            End If

            If Not ddlOrganizationSearchRegion.SelectedValue.IsValueNullOrEmpty() Then
                strFilter += $" And {RegionConstants.RegionID} = '{ddlOrganizationSearchRegion.SelectedValue}'"
            End If

            If Not ddlOrganizationSearchRayon.SelectedValue.IsValueNullOrEmpty() Then
                strFilter += $" And {RayonConstants.RayonID} = '{ddlOrganizationSearchRayon.SelectedValue}'"
            End If

            If Not ddlOrganizationSearchSettlement.SelectedValue.IsValueNullOrEmpty() Then
                strFilter += $" And {SettlementConstants.idfsSettlement} = '{ddlOrganizationSearchSettlement.SelectedValue}'"
            End If

            If strFilter <> "" Then
                If strFilter.Substring(0, 4) = " And" Then
                    strFilter = strFilter.Substring(5)
                End If
            End If

            If strFilter <> "" Then
                Dim oDV As DataView = oDS.Tables(0).DefaultView()
                oDV.RowFilter = strFilter
                Dim oFilteredDS As DataSet = New DataSet()
                Dim oDT As DataTable = oDV.ToTable()
                oFilteredDS.Tables.Add(oDT)
                oDS = oFilteredDS
            End If

            FillOrganizationList = oDS

        Catch ex As Exception

            Dim strMsg As String = "The following error occurred in FillOrganizationList:" & ex.Message
            ASPNETMsgBox(strMsg)

        End Try

    End Function

    Private Function FillEmployeeList() As DataSet
        FillEmployeeList = Nothing
        oDS = New DataSet()

        Try
            oDS = oEmployeeAdmin.ListAll()

            'Apply the filters
            Dim strFilter As String = ""
            If ddlPosition.SelectedValue <> -1 Then strFilter = "idfRankName = '" & ddlPosition.SelectedValue & "'"

            If txtFirstName.Text <> "" Then
                If strFilter <> "" Then strFilter &= " And "
                strFilter &= "strFirstName Like '" & txtFirstName.Text.ToString().Trim() & "%'"
            End If

            If txtLastName.Text <> "" Then
                If strFilter <> "" Then strFilter &= " And "
                strFilter &= "strFamilyName Like '" & txtLastName.Text.ToString().Trim() & "%'"
            End If

            If txtMiddleName.Text <> "" Then
                If strFilter <> "" Then strFilter &= " And "
                strFilter &= "strSecondName Like '" & txtMiddleName.Text.ToString().Trim() & "%'"
            End If

            If ddlOrganization.SelectedValue <> -1 Then
                If strFilter <> "" Then strFilter &= " And "
                strFilter &= "Organization = '" & ddlOrganization.SelectedItem.ToString() & "'"
            End If

            If strFilter <> "" Then
                Dim oDV As DataView = oDS.Tables(0).DefaultView()
                oDV.RowFilter = strFilter
                Dim oFilteredDS As DataSet = New DataSet()
                Dim oDT As DataTable = oDV.ToTable()
                oFilteredDS.Tables.Add(oDT)
                oDS = oFilteredDS
            End If

            FillEmployeeList = oDS

        Catch ex As Exception

            Dim strMsg As String = "The following error occurred in FillEmployeeList:" & ex.Message
            ASPNETMsgBox(strMsg)

        End Try
    End Function

    Private Function FillPersonList() As DataSet
        FillPersonList = Nothing
        oDS = New DataSet()

        Try
            oDS = oPerson.ListAll()
            Dim Filter As StringBuilder = New StringBuilder()
            If txtPersonSearchEIDSSIDNumber.Text.Length > 0 Then
                Filter.Append("idfPerson = '").Append(txtPersonSearchEIDSSIDNumber.Text.Trim()).Append("'")
            Else
                If ddlPersonSearchGender.SelectedValue <> -1 Then Filter.Append("idfsHumanGender = ").Append(ddlPersonSearchGender.SelectedValue)

                If txtPersonalID.Text.Length > 0 Then
                    If Filter.Length > 0 Then Filter.Append(" and ")
                    Filter.Append("strPersonID like '").Append(txtPersonalID.Text.Trim()).Append("%'")
                End If
                If txtPersonSearchFirstName.Text.Length > 0 Then
                    If Filter.Length > 0 Then Filter.Append(" and ")
                    Filter.Append("strFirstName like '").Append(txtPersonSearchFirstName.Text.Trim()).Append("%'")
                End If
                If txtPersonSearchMiddleInit.Text.Length > 0 Then
                    If Filter.Length > 0 Then Filter.Append(" and ")
                    Filter.Append("strMiddleInit like '").Append(txtPersonSearchMiddleInit.Text.Trim()).Append("%'")
                End If
                If txtPersonSearchLastName.Text.Length > 0 Then
                    If Filter.Length > 0 Then Filter.Append(" and ")
                    Filter.Append("strLastName like '").Append(txtPersonSearchLastName.Text.Trim()).Append("%'")
                End If
                If txtPersonSearchBirthDate.Text.Length > 0 Then
                    If Filter.Length > 0 Then Filter.Append(" and ")
                    Filter.Append("datDateofBirth = '").Append(txtPersonSearchBirthDate.Text.Trim()).Append("'")
                End If
                If Not ddlPersonSearchRegion.SelectedValue.IsValueNullOrEmpty() Then
                    If Filter.Length > 0 Then Filter.Append(" and ")
                    Filter.Append("idfsRegion = ").Append(ddlPersonSearchRegion.SelectedValue)
                End If
                If ddlPersonSearchRayon.SelectedIndex <> -1 AndAlso ddlPersonSearchRayon.SelectedValue <> "" Then
                    If Filter.Length > 0 Then Filter.Append(" and ")
                    Filter.Append("idfsRayon = ").Append(ddlPersonSearchRayon.SelectedValue)
                End If
                'If ddlPersonSearchPersonalIDType.SelectedValue <> "" AndAlso ddlPersonSearchPersonalIDType.SelectedValue <> -1 Then
                '    If Filter.Length > 0 Then Filter.Append(" and ")
                '    Filter.Append("idfsRayon = ").Append(ddlPersonSearchPersonalIDType.SelectedValue)
                'End If
            End If

            Dim strFilter As String = Filter.ToString()
            If strFilter <> "" Then
                Dim oDV As DataView = oDS.Tables(0).DefaultView()
                oDV.RowFilter = strFilter
                Dim oFilteredDS As DataSet = New DataSet()
                Dim oDT As DataTable = oDV.ToTable()
                oFilteredDS.Tables.Add(oDT)
                oDS = oFilteredDS
            End If

            FillPersonList = oDS
        Catch ex As Exception
            Dim strMsg As String = "The following error occurred in FillPersonList:" & ex.Message
            ASPNETMsgBox(strMsg)
        End Try
    End Function

    Private Function FillOutbreakList() As DataSet
        FillOutbreakList = Nothing
        oDS = New DataSet()

        Try
            Dim strFilter As String = String.Empty
            FillOutbreakList = oDS
        Catch ex As Exception
            Dim strMsg As String = "The following error occurred in FillOutbreakList:" & ex.Message
            ASPNETMsgBox(strMsg)
        End Try
    End Function

    Private Sub LoadEmployeeDropdowns()
        'Load Position
        BaseReferenceLookUp(ddlPosition, BaseReferenceConstants.EmployeePosition, HACodeList.NoneHACode, True)

        'Load Organization List
        FillDropDown(ddlOrganization, GetType(clsOrganization),
                      Nothing,
                     OrganizationConstants.idfInstitution,
                     OrganizationConstants.OrgName,
                     Session("Institution").ToString(),
                     Nothing,
                     True)
    End Sub

    Private Sub LoadOrganizationDropdowns()
        FillDropDown(ddlOrganizationSearchRegion, GetType(clsRegion), {getConfigValue("CountryID")}, RegionConstants.RegionID, RegionConstants.RegionName, Nothing, Nothing, True)
    End Sub

    Private Sub LoadPersonDropdowns()

        'ddlPersonSearchPersonalIDType
        BaseReferenceLookUp(ddlPersonSearchPersonalIDType, BaseReferenceConstants.PersonalIDType, HACodeList.NoneHACode, True)

        'ddlNewGender
        BaseReferenceLookUp(ddlPersonSearchGender, BaseReferenceConstants.HumanGender, HACodeList.HumanHACode, True)

        FillDropDown(ddlPersonSearchRegion, GetType(clsRegion), {getConfigValue("CountryID")}, RegionConstants.RegionID, RegionConstants.RegionName, Nothing, Nothing, True)
    End Sub

    Private Sub LoadOutbreakDropdowns()
        'Disease List
        BaseReferenceLookUp(ddlOutbreakSearchDisease, BaseReferenceConstants.VectorSubType, HACodeList.VectorHACode, True)
        'Disease Groups
        BaseReferenceLookUp(ddlOutbreakSearchDiagnosesGroup, BaseReferenceConstants.DiagnosesGroups, HACodeList.VectorHACode, True)
        'Status List
        BaseReferenceLookUp(ddlSearchOutbreakStatus, BaseReferenceConstants.VectorSurveillanceSessionStatus, HACodeList.VectorHACode, False)
    End Sub

    Protected Sub btnSearchOrganization_Click(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('hide');});", True)
        ddlAllItems.Items.Clear()
        ddlAllItems.Items.Add(New ListItem("", ""))
        ddlAllItems.DataSource = FillOrganizationList()
        ddlAllItems.DataValueField = OrganizationConstants.strOrganizationID
        ddlAllItems.DataTextField = OrganizationDisplayField.ToString()
        ddlAllItems.DataBind()
    End Sub

    Protected Sub btnSearchEmployee_Click(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('hide');});", True)
        ddlAllItems.Items.Clear()
        ddlAllItems.Items.Add(New ListItem("", ""))
        ddlAllItems.DataSource = FillEmployeeList()
        ddlAllItems.DataValueField = EmployeeConstants.idfEmployee
        ddlAllItems.DataTextField = EmployeeDisplayField.ToString()
        ddlAllItems.DataBind()
    End Sub

    Protected Sub btnSearchPerson_Click(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('hide');});", True)
        ddlAllItems.Items.Clear()
        ddlAllItems.Items.Add(New ListItem("", ""))
        ddlAllItems.DataSource = FillPersonList()
        ddlAllItems.DataValueField = PersonConstants.idfPerson
        ddlAllItems.DataTextField = PersonDisplayField.ToString()
        ddlAllItems.DataBind()
    End Sub

    Protected Sub btnSearchOutbreak_Click(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('hide');});", True)
        ddlAllItems.Items.Clear()
        ddlAllItems.Items.Add(New ListItem("", ""))
    End Sub

    Protected Sub ddlOrganizationSearchRegion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlOrganizationSearchRegion.SelectedIndexChanged
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('show');});", True)
        FillDropDown(ddlOrganizationSearchRayon, GetType(clsRayon), {ddlOrganizationSearchRegion.SelectedValue}, RayonConstants.RayonID, RayonConstants.RayonName, Nothing, Nothing, True)
        ddlOrganizationSearchSettlement.Items.Clear()
        ddlOrganizationSearchSettlement.Enabled = False
    End Sub

    Protected Sub ddlOrganizationSearchRayon_SelectedIndexChanged(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('show');});", True)
        FillDropDown(ddlOrganizationSearchSettlement, GetType(clsTownOrVillage), {ddlOrganizationSearchRayon.SelectedValue}, TownOrVillageConstants.TownOrVillageID, TownOrVillageConstants.TownOrVillageName, Nothing, Nothing, True)
        ddlOrganizationSearchSettlement.Enabled = True
    End Sub

    Protected Sub ddlPersonSearchRegion_SelectedIndexChanged(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('show');});", True)
        FillDropDown(ddlPersonSearchRayon, GetType(clsRayon), {ddlPersonSearchRegion.SelectedValue}, RayonConstants.RayonID, RayonConstants.RayonName, Nothing, Nothing, True)
        ddlPersonSearchSettlement.Items.Clear()
        ddlPersonSearchSettlement.Enabled = False
    End Sub

    Protected Sub ddlPersonSearchRayon_SelectedIndexChanged(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('show');});", True)
        FillDropDown(ddlPersonSearchSettlement, GetType(clsTownOrVillage), {ddlPersonSearchRayon.SelectedValue}, TownOrVillageConstants.TownOrVillageID, TownOrVillageConstants.TownOrVillageName, Nothing, Nothing, True)
        ddlPersonSearchSettlement.Enabled = True
    End Sub

    Protected Sub ddlOutbreakSearchRegion_SelectedIndexChanged(sender As Object, e As EventArgs)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & searchModal.ClientID & "').modal('show');});", True)
        FillDropDown(ddlOutbreakSearchRayon, GetType(clsRayon), {ddlOutbreakSearchRegion.SelectedValue}, RayonConstants.RayonID, RayonConstants.RayonName, Nothing, Nothing, True)
    End Sub
End Class

