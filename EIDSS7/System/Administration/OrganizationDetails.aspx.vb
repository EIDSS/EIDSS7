Imports EIDSS.EIDSS

Public Class OrganizationDetails
    Inherits BaseEidssPage

    Private sObjectID As String = ""
    Private hsModifiedOA As New HashSet(Of String)
    Dim oEIDSSDS As DataSet = Nothing
    Private oComm As clsCommon = New clsCommon()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack Then

            oEIDSSDS = oComm.ReadEIDSSXML()

            'Check for value saved in Organization Admin
            hdfidfOrganization.Value = -1
            If oEIDSSDS.CheckDataSet() Then hdfidfOrganization.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfOrgId")

            'Assign defaults from current user data
            oEIDSSDS = Nothing
            Dim sUserSettingsFile As String = oComm.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
            oEIDSSDS = oComm.ReadEIDSSXML(sUserSettingsFile)
            If oEIDSSDS.CheckDataSet() Then
                hdfUser.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfUserID") & ""
            End If

            ' Populate Accessory Codes        
            FillAccessoryCodeList()

            If (String.IsNullOrWhiteSpace(hdfidfOrganization.Value) OrElse hdfidfOrganization.Value = "-1") Then

                hdfidfOfficeNewID.Value = -1
                hdfidfOfficeNewID.Value = 0 'AK New Org


                Dim oDepartments As New clsDepartment
                Dim dsDepartments = oDepartments.ListAll({hdfidfOrganization.Value})

                ' Departments     
                Dim dtDepartment As DataTable = dsDepartments.Tables(0)
                Dim dtOrigDepartment As DataTable = dtDepartment.Copy()
                ViewState("OrigDepartmentsTable") = dtOrigDepartment
                ViewState("DepartmentsTable") = dtDepartment

                Dim uniqueKey As New System.Data.UniqueConstraint(dtDepartment.Columns(DepartmentConstants.Name))
                dtDepartment.Constraints.Add(uniqueKey)

                'populate Departments with the values
                With gvDepartments
                    .DataSource = dtDepartment
                    .DataBind()
                    .SelectedIndex = -1
                    .Visible = True
                End With
            Else
                hdfidfOfficeNewID.Value = hdfidfOrganization.Value
                FillFormForEdit()
            End If
        End If

    End Sub

    Private Sub FillAccessoryCodeList()

        Dim oAccessoryCodes As New clsAccessoryCodes
        Dim dsAccessoryCodes = oAccessoryCodes.GetChecklist()

        With lsbintHACode1
            .DataSource = dsAccessoryCodes.Tables(0)
            .DataTextField = "CodeName"
            .DataValueField = "intHACode"
            .DataBind()
        End With


    End Sub

#Region "Fill"

    Private Sub FillFormForEdit()

        Dim oOrganization As New clsOrganization
        Dim dsOrganization As DataSet = oOrganization.SelectOne(hdfidfOrganization.Value)
        Dim dtOrganization As DataTable = Nothing
        Dim oDepartments As New clsDepartment
        Dim dsDepartments = oDepartments.ListAll({hdfidfOrganization.Value})

        If dsOrganization.CheckDataSet() Then

            If dsOrganization.Tables(0).CheckDataTable() Then
                dtOrganization = dsOrganization.Tables(0)
            End If

            ' Select AccessoryCodes     
            Dim oAccessoryCodes As New clsAccessoryCodes
            Dim dsSelected = oAccessoryCodes.GetSelected(dsOrganization.Tables(0).Rows(0)("intHACode").ToString())


            For Each item As ListItem In lsbintHACode1.Items
                item.Selected = (dsSelected.Tables(0).Select($"name = '{item.Text}'").Length = 1)
                lsbintHACode1.SelectedIndex = item.Selected 'AK Select look at item selcted
            Next

            'populate location control
            If dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsCountry").ToString = "" Then
                LUCDetails.LocationCountryID = Nothing
            Else
                LUCDetails.LocationCountryID = CType(dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsCountry"), Long)
            End If

            If dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsRegion").ToString = "" Then
                LUCDetails.LocationRegionID = Nothing
            Else
                LUCDetails.LocationRegionID = CType(dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsRegion"), Long)
            End If

            If dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsRayon").ToString = "" Then
                LUCDetails.LocationRayonID = Nothing
            Else
                LUCDetails.LocationRayonID = CType(dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsRayon"), Long)
            End If

            If dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsSettlement").ToString = "" Then
                LUCDetails.LocationSettlementID = Nothing
            Else
                LUCDetails.LocationSettlementID = CType(dsOrganization.Tables(0).Rows(0)("LocationUserControlidfsSettlement"), Long)
            End If

            If dsOrganization.Tables(0).Rows(0)(PostalCodeConstants.PostalCodeName).ToString = "" Then
                LUCDetails.LocationPostalCodeName = Nothing
            Else
                LUCDetails.LocationPostalCodeName = CType(dsOrganization.Tables(0).Rows(0)(PostalCodeConstants.PostalCodeName), Long)
            End If
            LUCDetails.DataBind()

            'populate the values on the form
            oComm.Scatter(Me, New DataTableReader(dtOrganization))

            ' Departments     
            Dim dtDepartment As DataTable = dsDepartments.Tables(0)
            Dim dtOrigDepartment As DataTable = dtDepartment.Copy()
            ViewState("OrigDepartmentsTable") = dtOrigDepartment
            ViewState("DepartmentsTable") = dtDepartment

            Dim uniqueKey As New System.Data.UniqueConstraint(dtDepartment.Columns(DepartmentConstants.Name))
            dtDepartment.Constraints.Add(uniqueKey)

            'populate Departments with the values
            With gvDepartments
                .DataSource = dtDepartment
                .DataBind()
                .SelectedIndex = -1
            End With

        End If

    End Sub

#End Region

#Region "Buttons"

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        'validate the page
        Validate() ' error occurs when we validate the HACCode in the Organization Section AK

        'set empty location dropdowns as invalid
        If (Page.IsValid) Then
            SubmitFormData()
        Else
            DisplayValidationErrors()
        End If
    End Sub

    Private Sub SubmitFormData()

        Dim bContinue As Boolean = True
        Dim oTuple As Object
        Dim oRetVal As Object()
        Dim oOrg As clsOrganization = New clsOrganization()

        Dim aSP As String()
        aSP = oComm.GetSPList("OrganizationSet")

        'hdfname.Value = txtEnglishName.Text  Move below AK
        'hdfEnglishFullName.Value = txtEnglishName.Text




        '        hdfintHACode.Value = CalculateHACode() Move below AK

        Dim formValues As String = oComm.Gather(OrganizationSection, aSP(0).ToString(), 3, True)

        hdfintHACode.Value = CalculateHACode()
        hdfname.Value = txtEnglishName.Text
        hdfEnglishFullName.Value = txtFullName.Text

        Dim oDS As DataSet = Nothing

        oTuple = oOrg.AddUpdate("OrganizationSet", formValues)
        oDS = oTuple.m_Item1
        oRetVal = oTuple.m_Item2

        'Check for errors
        bContinue = oDS.CheckDataSet()

        If bContinue Then
            hdfidfOrganization.Value = DirectCast(oRetVal(0), String)
        End If

        If bContinue Then SaveDepartments(hdfidfOrganization.Value)

        If bContinue Then ASPNETMsgBox(GetLocalResourceObject("Success_Message_text"), "OrganizationAdmin.aspx")

    End Sub

    Private Sub DisplayValidationErrors()

        'Paint all SideBarItems as Passed Validation and then correct those that failed
        sideBarItemOrganizationInfo.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sideBarItemDepartments.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)
                If IsNothing(section) Then section = TryCast(failedValidator.Parent.Parent.Parent, HtmlGenericControl)
                Select Case section.ID
                    Case "OrganizationSection"
                        sideBarItemOrganizationInfo.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                        sideBarItemOrganizationInfo.CssClass = "glyphicon glyphicon-remove"
                    Case "DepartmentsSection"
                        sideBarItemDepartments.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                        sideBarItemDepartments.CssClass = "glyphicon glyphicon-remove"
                End Select
            End If
        Next

    End Sub

    Private Sub SaveDepartments(idfOrganization As String)

        Dim oDepartment As New clsDepartment
        ' The new list as modified from the UI      
        Dim dtNewDepartments As DataTable = ViewState("DepartmentsTable")
        ' Thie orig list from the database    
        Dim dtOrigDepartments As DataTable = ViewState("OrigDepartmentsTable")
        Dim rows() As DataRow

        ' First DELETE departments that were deleted from UI  
        For Each dataRowOrig As DataRow In dtOrigDepartments.Rows

            ' Check for Orig data row ih dtNewDepartments    
            rows = dtNewDepartments.Select($"{DepartmentConstants.idfDepartment} =  {dataRowOrig(DepartmentConstants.idfDepartment)} and {OrganizationConstants.idfInstitution} = {dataRowOrig(OrganizationConstants.idfInstitution)} ")

            ' If it is NOT ih dtNewGroups then delete it     
            If rows.Length = 0 Then
                oDepartment.Delete(dataRowOrig(DepartmentConstants.idfDepartment))
            End If
        Next

        ' Next SAVE new groups that were added from UI        
        For Each dataRowNew As DataRow In dtNewDepartments.Rows
            ' Check for New data row ih  dtOrigidfDepartment
            rows = dtOrigDepartments.Select($"{DepartmentConstants.Name} =  '{dataRowNew(DepartmentConstants.Name).ToString() }' ")

            ' If it is not dtOrigDepartments save it.  (If it is then do nothing )
            If rows.Length = 0 Then
                oDepartment.Save("null",
                                 hdfidfOrganization.Value,
                                 dataRowNew(DepartmentConstants.Name),
                                 dataRowNew(DepartmentConstants.Name),  ' Parmater for DefaultName sent name on purpose 
                                 LUCDetails.SelectedCountryValue,
                                 "null")
            End If
        Next

    End Sub

    Private Function CalculateHACode() As String

        Dim tot As Integer = 0

        For Each item As ListItem In lsbintHACode1.Items
            If item.Selected Then

                tot += item.Value ' Original 
                'tot += lsbintHACode.SelectedValue 'AK


            End If
        Next

        Return tot

    End Function

    Private Sub DepartmentsGridDeleteRow(gv As GridView, name As String)

        ' TODO - do not delete any orig Departments without checkihg first          
        Dim dt As DataTable = ViewState("DepartmentsTable")

        If dt.CheckDataTable Then

            Dim drCurrentRow As DataRow = dt.Select($"{DepartmentConstants.Name} =  '{name}'")(0)

            drCurrentRow.Delete()
            dt.AcceptChanges()

            ViewState("DepartmentsTable") = dt

            gv.DataSource = dt
            gv.DataBind()

        End If

    End Sub

    Private Sub DepartmentsGridAddRow(gv As GridView, text As String)

        Try

            If text = "" Then
                Return
            End If

            Dim dt As DataTable = ViewState("DepartmentsTable")

            If (Not dt Is Nothing) Then

                Dim drCurrentRow As DataRow = Nothing

                drCurrentRow = dt.NewRow
                drCurrentRow(DepartmentConstants.Name) = text

                dt.Rows.Add(drCurrentRow)
                ViewState("DepartmentsTable") = dt
                gv.DataSource = dt
                gv.DataBind()

            End If

        Catch ex As System.Data.ConstraintException
            ' Cannot add duplicate depts    
        Catch ex As Exception

        End Try

    End Sub

#End Region

#Region "Control Events"

    Private m_txtDepartment As TextBox

    Private Sub gvDepartments_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDepartments.RowCommand

        If Not ViewState("DepartmentsTable") Is Nothing Then
            Select Case e.CommandName.ToUpper()
                Case "DEPARTMENTSADD", "DEPARTMENTSADDEMPTYDATA"
                    DepartmentsGridAddRow(gvDepartments, m_txtDepartment.Text)
                Case "DEPARTMENTDELETE"
                    Dim name As String = e.CommandArgument.ToString()
                    DepartmentsGridDeleteRow(gvDepartments, name)
            End Select
        End If

    End Sub

    Private Sub gvDepartments_RowCreated(sender As Object, e As GridViewRowEventArgs) Handles gvDepartments.RowCreated

        If e.Row.RowType = DataControlRowType.EmptyDataRow Or
           e.Row.RowType = DataControlRowType.Footer Then
            m_txtDepartment = New TextBox()
            m_txtDepartment = e.Row.FindControl("txtDepartmentName")
        End If

    End Sub

    Protected Sub chkblnForeignAddress_CheckedChanged(sender As Object, e As EventArgs)

        If chkblnForeignAddress.Checked Then
            LUCDetails.ShowCountry = True
            LUCDetails.ShowRegion = False
            LUCDetails.ShowRayon = False
            LUCDetails.ShowTownOrVillage = False
            LUCDetails.ShowStreet = False
            LUCDetails.ShowPostalCode = False
            LUCDetails.ShowCoordinates = False
            LUCDetails.ShowBuildingHouseApartmentGroup = False
        Else
            LUCDetails.ShowRegion = True
            LUCDetails.ShowRayon = True
            LUCDetails.ShowTownOrVillage = True
            LUCDetails.ShowPostalCode = True
            LUCDetails.ShowStreet = True
            LUCDetails.ShowCoordinates = True
            LUCDetails.ShowBuildingHouseApartmentGroup = True
        End If

    End Sub

#End Region

    Private Sub OrganizationDetails_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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