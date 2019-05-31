Imports EIDSS.EIDSS
Imports EIDSS.NG

Public Class EmployeeDetails
    Inherits BaseEidssPage

    Dim oEIDSSDS As DataSet = Nothing
    Private oComm As clsCommon = New clsCommon()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack() Then

            oEIDSSDS = oComm.ReadEIDSSXML()

            'Check for value saved in Employee Admin
            hdfidfEmployee.Value = -1
            If oEIDSSDS.CheckDataSet() Then hdfidfEmployee.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfEmployee") & ""
            If hdfidfEmployee.Value = -1 Then hdfidfUserID.Value = -1

            'Assign defaults from current user data
            oEIDSSDS = Nothing
            Dim sUserSettingsFile As String = oComm.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
            oEIDSSDS = oComm.ReadEIDSSXML(sUserSettingsFile)
            If oEIDSSDS.CheckDataSet() Then
                hdfidfsSite.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfsSite") & ""
                hdfUser.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfUserID") & ""
            End If

            txtPassword.Attributes("type") = "password"
            txtPasswordConfirm.Attributes("type") = "password"

            'By defaul enable account name, password validators and required images, if user login exists
            txtstrAccountName.Enabled = True
            rfvbinPassword.Enabled = True
            rfvPasswordConfirm.Enabled = True
            iconBinPass.Visible = True
            iconPassConfirm.Visible = True

            'Get Employee dataset
            Dim oEmployee As New clsEmployee
            Dim dsEmployee As DataSet = oEmployee.SelectOne(hdfidfEmployee.Value)
            dsEmployee.CheckDataSet()

            Dim sInstiution As String = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfInstitution") & ""
            Dim sDepartment As String = ""
            If dsEmployee.Tables(0).Rows.Count > 0 Then
                sInstiution = dsEmployee.Tables(0).Rows(0)(OrganizationConstants.idfInstitution) & ""
                sDepartment = dsEmployee.Tables(0).Rows(0)(DepartmentConstants.idfDepartment) & ""
            End If

            If dsEmployee.Tables(1).Rows.Count > 0 Then
                hdfidfUserID.Value = dsEmployee.Tables(1).Rows(0)(GlobalConstants.UserID) & ""
            End If

            'Populate Organization List
            'By default the selected organization is the organization user used to login
            Dim oOrgDS As DataSet = Nothing
            FillDropDown(ddlidfInstitution, GetType(clsOrganization) _
                         , Nothing _
                         , OrganizationConstants.idfInstitution _
                         , OrganizationConstants.OrgName _
                         , sInstiution _
                         , Nothing _
                         , False _
                         , oOrgDS)

            'Save the dataset to find the site for selected organization
            ViewState(GlobalConstants.Organization) = oOrgDS

            'Populate department list
            'By default show department for logged in user institution - departments
            FillDropDown(ddlidfDepartment _
                         , GetType(clsDepartment) _
                         , {sInstiution} _
                         , DepartmentConstants.idfDepartment _
                         , DepartmentConstants.Name _
                         , sDepartment _
                         , Nothing _
                         , True)

            'Populate Employee Position List
            BaseReferenceLookUp(ddlidfsStaffPosition, BaseReferenceConstants.EmployeePosition, HACodeList.NoneHACode)

            'populate PersonalInformationSection with the values
            oComm.Scatter(PersonalInformationSection, New DataTableReader(dsEmployee.Tables(0)))
            oComm.Scatter(divHiddenFieldsSection, New DataTableReader(dsEmployee.Tables(0)))

            'populate LoginSection with the values
            oComm.Scatter(LoginSection, New DataTableReader(dsEmployee.Tables(1)))
            oComm.Scatter(divHiddenFieldsSection, New DataTableReader(dsEmployee.Tables(1)))

            'Disable account name, password validators and required images, if user login exists
            txtstrAccountName.Enabled = (dsEmployee.Tables(1).Rows.Count = 0)
            rfvbinPassword.Enabled = (dsEmployee.Tables(1).Rows.Count = 0)
            rfvPasswordConfirm.Enabled = (dsEmployee.Tables(1).Rows.Count = 0)
            iconBinPass.Visible = (dsEmployee.Tables(1).Rows.Count = 0)
            iconPassConfirm.Visible = (dsEmployee.Tables(1).Rows.Count = 0)

            'populate group grid
            FillGroupsEdit(dsEmployee)

            'populate SystemFunctionsSection with the values
            FillObjectAccessModelForEdit()

        End If

    End Sub

#Region "Methods"

    Private Sub FillGroupsEdit(oEmpDS As DataSet)

        Dim oEG As New clsEmployeeGroup
        Dim aSP As String() = oComm.GetSPList("EmployeeGroupList")
        Dim oDS As New DataSet
        Dim strParams As String = ""

        Try

            strParams = oComm.Gather(divHiddenFieldsSection, aSP(0), 3, True)

            oDS = oEG.ListAll({strParams})

            If oDS.CheckDataSet() Then

                'Merge table in dataset
                Dim oEGDS As New DataSet
                Dim oEGDT As DataTable
                Dim oEGDR As DataRow
                Dim sColumns As String() = "idfEmployeeGroup,idfsEmployeeGroupName,strName,strDescription,chkExists".Split(",")
                Dim bChecked As Boolean = False

                'For Filter
                Dim oDV As DataView
                Dim oFilteredDS As DataSet
                Dim oDT As DataTable

                oEGDT = New DataTable()
                For Each item As String In sColumns
                    oEGDT.Columns.Add(New DataColumn(item.Trim(), Type.GetType("System.String")))
                Next

                Dim fld As String = ""
                Dim strFilter As String = ""
                For row As Int16 = 0 To oDS.Tables(0).Rows.Count - 1

                    'Apply filter to see if already added
                    'Apply the filters
                    bChecked = False
                    If oEmpDS.CheckDataSet() Then
                        strFilter = "idfEmployeeGroup = '" & oDS.Tables(0).Rows(row).Item(0) & "'"
                        oDV = oEmpDS.Tables(2).DefaultView()
                        oDV.RowFilter = strFilter
                        oDT = oDV.ToTable()
                        oFilteredDS = New DataSet()
                        oFilteredDS.Tables.Add(oDT)
                        bChecked = oFilteredDS.CheckDataSet()
                    End If

                    oEGDR = oEGDT.NewRow()

                    For Each sItem As String In sColumns

                        Select Case sItem.Trim()
                            Case "chkExists"
                                oEGDR(sItem) = bChecked
                            Case Else
                                oEGDR(sItem) = oDS.Tables(0).Rows(row).Item(sItem)
                        End Select

                    Next
                    oEGDT.Rows.Add(oEGDR)
                Next

                oEGDS.Tables.Add(oEGDT)

                With gvEmployeeDetailsGroup
                    .DataSource = oEGDS.Tables(0)
                    .DataBind()
                End With

            Else
                gvEmployeeDetailsGroup.EmptyDataText = GetLocalResourceObject("Val_EmployeeGroup_List")
            End If

        Finally

            oEG = Nothing

        End Try

    End Sub

    Private Sub FillObjectAccessModelForEdit()

        Dim oOA As clsObjectAccess = New clsObjectAccess()
        Dim gvDS As New DataSet

        Try

            gvDS = oOA.ListAll({hdfidfEmployee.Value})

            If gvDS.CheckDataSet() Then

                With gvSystemFunctions
                    .DataSource = gvDS.Tables(0)
                    .DataBind()
                End With

            End If

        Finally

            oOA = Nothing

        End Try

    End Sub

    Private Sub SubmitFormData()

        Dim bContinue As Boolean = True
        Dim bSaveUser As Boolean = False

        ' Save Personal info
        Dim oEmp As clsEmployee = New clsEmployee()
        Dim aSP As String()
        Dim sRetVal As String = ""

        Try

            If hdfidfEmployee.Value.ToString().IsValueNullOrEmpty() OrElse hdfidfEmployee.Value = -1 Then hdfidfEmployee.Value = "null"

            'Validations
            bSaveUser = txtPassword.Text <> ""
            If (bSaveUser) Then
                bContinue = MatchPassword()
                If bContinue Then bContinue = ValidatePWdLength()
            End If

            If bContinue Then

                Dim oDS As DataSet = New DataSet()
                Dim formValues As String = ""
                Dim oTuple As Object
                Dim oRetVal As Object()

                If bContinue Then
                    ' Save Personal Information  

                    aSP = oComm.GetSPList(EIDSSModules.Employee)
                    formValues = oComm.Gather(PersonalInformationSection, aSP(SPType.SPSet).ToString(), 3, True)
                    formValues &= "|" & oComm.Gather(divHiddenFieldsSection, aSP(SPType.SPSet).ToString(), 3, True)

                    oTuple = oEmp.AddUpdate(EIDSSModules.Employee & "_" & SPType.SPSet, formValues)
                    oDS = oTuple.m_Item1

                    'Check for errors
                    bContinue = oDS.CheckDataSet()
                    If bContinue Then
                        oRetVal = oTuple.m_Item2
                        Try
                            hdfidfEmployee.Value = DirectCast(oRetVal(0), String)
                        Catch ex As Exception
                        End Try
                    End If

                End If

                ' Save Employee Group(s)  
                If bContinue Then SaveEmployeeGroups(hdfidfEmployee.Value)

                ' Save sytsem functions  
                If bContinue Then SaveSystemFunctions()

                If (bContinue And bSaveUser) Then
                    If txtPassword.Text <> "" Then
                        If hdfidfUserID.Value.ToString().IsValueNullOrEmpty() OrElse hdfidfUserID.Value = -1 Then hdfidfUserID.Value = "null"

                        'create hash of passwd
                        Dim hashPwd As Object = Nothing
                        hashPwd = oEmp.HashValue(txtPassword.Text)

                        Dim sUserId As Int64 = -1
                        'save user login information
                        aSP = oComm.GetSPList("UserLoginSet")
                        formValues = oComm.Gather(LoginSection, aSP(0).ToString(), 3, True)
                        formValues &= "|" & oComm.Gather(divHiddenFieldsSection, aSP(0).ToString(), 3, True)
                        formValues &= "|binPassword;" & Encoding.Default.GetString(hashPwd) & ";IN"

                        oTuple = oEmp.AddUpdate("UserLoginSet", formValues)
                        oDS = oTuple.m_item1

                        If oDS.CheckDataSet() Then
                            oRetVal = oTuple.m_Item2
                            sUserId = oRetVal(0)
                            hdfidfUserID.Value = sUserId.ToString()
                        End If

                    End If
                End If

                'TODO - MD: Localize the message
                ASPNETMsgBox("Employee data saved sucessfully.", "EmployeeAdmin.aspx")

            End If

        Finally

            oEmp = Nothing

        End Try

    End Sub

    Private Sub DisplayValidationErrors()

        'Paint all SideBarItems as Passed Validation and then correct those that failed
        sideBarItemEmployee.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sideBarItemLogin.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sideBarItemGroups.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        sideBarItemFunctions.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)
                Select Case section.ID
                    Case "PersonalInformationSection"
                        sideBarItemEmployee.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                        sideBarItemEmployee.CssClass = "glyphicon glyphicon-remove"
                    Case "LoginSection"
                        sideBarItemLogin.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                        sideBarItemLogin.CssClass = "glyphicon glyphicon-remove"
                End Select

            End If
        Next

    End Sub

    Private Sub SaveEmployeeGroups(sEmpId As String)


        If fldGrpCheckList.Value.ToString() = "" Then
            'No controls were modified
        Else
            Dim oEmp As clsEmployee = New clsEmployee()
            Dim oDS As DataSet

            Dim gvRow As Integer = 0
            Dim keyPos As Integer = 3
            Dim sVal As String = ""

            Try

                Dim listOfCtrl As String() = (fldGrpCheckList.Value).ToString().Split("|")

                For iCount As Integer = 1 To listOfCtrl.Count - 1

                    'The length of listofCtrl is 2
                    '0 - name
                    '1 - true/false
                    Dim lstParts As String() = listOfCtrl(iCount).Split(";")

                    'name is made of 0 - content place holder, 1 - grid view control name, 2 - check box control name, 3- grid vire row number
                    Dim ctrlParts As String() = lstParts(0).Split("_")
                    gvRow = ctrlParts(3)


                    sVal = "idfEmployeeGroup;" & gvEmployeeDetailsGroup.DataKeys(gvRow).Values().Item("idfEmployeeGroup") & ";IN"
                    sVal &= "|" & "idfEmployee;" & sEmpId.ToString() & ";IN"

                    Dim oTuple As Object = oEmp.AddUpdate("UserGroupSet", sVal)
                    oDS = oTuple.m_item1

                    'Will display errors (if any)
                    oDS.CheckDataSet()
                Next

            Finally

                oEmp = Nothing

            End Try

        End If

    End Sub

    Private Sub SaveSystemFunctions()

        If fldOAChkList.Value.ToString() = "" Then
            'No controls were modified
        Else
            Dim oEmp As clsEmployee = New clsEmployee()
            Dim oDS As DataSet

            Dim gvRow As Integer = 0
            Dim keyPos As Integer = 3
            Dim sVal As String = ""

            Try

                Dim listOfCtrl As String() = (fldOAChkList.Value).ToString().Split("|")

                For iCount As Integer = 1 To listOfCtrl.Count - 1

                    'The length of listofCtrl is 2
                    '0 - name
                    '1 - true/false
                    Dim lstParts As String() = listOfCtrl(iCount).Split(";")

                    'name is made of 0 - content place holder, 1 - grid view control name, 2 - check box control name, 3- grid vire row number
                    Dim ctrlParts As String() = lstParts(0).Split("_")
                    gvRow = ctrlParts(3)
                    Select Case ctrlParts(2)
                        Case "chkCreate"
                            keyPos = 3
                        Case "chkRead"
                            keyPos = 6
                        Case "chkWrite"
                            keyPos = 9
                        Case "chkDelete"
                            keyPos = 12
                        Case "chkExecute"
                            keyPos = 15
                        Case "chkAccessToPersonalData"
                            keyPos = 18
                    End Select

                    sVal = "idfObjectAccess;" & IIf((gvSystemFunctions.DataKeys(gvRow).Values().Item(keyPos) & "") = "", "-1", gvSystemFunctions.DataKeys(gvRow).Values().Item(keyPos)) & ";IN"
                    sVal &= "|" & "idfsObjectOperation;" & (gvSystemFunctions.DataKeys(gvRow).Values().Item(keyPos + 1) & "") & ";IN"
                    sVal &= "|" & "idfsObjectType;" & (gvSystemFunctions.DataKeys(gvRow).Values().Item(0) & "") & ";IN"
                    sVal &= "|" & "idfsObjectID;" & (gvSystemFunctions.DataKeys(gvRow).Values().Item(2) & "") & ";IN"
                    sVal &= "|" & "idfEmployee;" & hdfidfEmployee.Value & ";IN"
                    sVal &= "|" & "isAllow;" & IIf(lstParts(1) = True, "1", "0") & ";IN"
                    sVal &= "|" & "isDeny;" & IIf(lstParts(1) = True, "0", "1") & ";IN"

                    Dim oTuple As Object = oEmp.AddUpdate("ObjectAccessSet", sVal)
                    oDS = oTuple.m_Item1

                    'Will display errors (if any)
                    oDS.CheckDataSet()

                Next

            Finally

                oEmp = Nothing

            End Try
        End If

    End Sub

#End Region

#Region "Control Events"

    Private Sub ddlidfInstitution_OnSelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfInstitution.SelectedIndexChanged

        'Find the site id associated with the selected organization
        Dim oOrgDS As DataSet = ViewState(GlobalConstants.Organization)
        Dim oDV As DataView = oOrgDS.Tables(0).DefaultView()
        oDV.RowFilter = "idfInstitution = '" + ddlidfInstitution.SelectedValue + "'"
        oOrgDS = New DataSet
        oOrgDS.Tables.Add(oDV.ToTable())
        If oOrgDS.Tables(0).Rows.Count > 0 Then hdfidfsSite.Value = oOrgDS.Tables(0).Rows(0).Item("idfsSite") & ""

        'Load the departments for the selected organization
        FillDropDown(ddlidfDepartment _
                     , GetType(clsDepartment) _
                     , {ddlidfInstitution.SelectedValue} _
                     , DepartmentConstants.idfDepartment _
                     , DepartmentConstants.Name _
                     , Nothing _
                     , Nothing _
                     , True)

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

    Private Function MatchPassword() As Boolean

        MatchPassword = True

        If txtPassword.Text <> txtPasswordConfirm.Text Then
            MatchPassword = False
            sideBarItemLogin.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
            sideBarItemLogin.CssClass = "glyphicon glyphicon-remove"
            'TODO - MD: Localize the message
            ASPNETMsgBox("Passwords do not match!")
            txtPasswordConfirm.Focus()
            txtPasswordConfirm.SelectText()
        End If

        Return MatchPassword

    End Function

    Private Function ValidatePWdLength() As Boolean

        ValidatePWdLength = False
        'TODO - MD: The length of the password is customizable.
        If txtPassword.Text.Length > 5 And txtPasswordConfirm.Text.Length > 5 Then
            ValidatePWdLength = True
            sideBarItemLogin.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
            sideBarItemLogin.CssClass = "glyphicon glyphicon-remove"
        Else
            sideBarItemLogin.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
            sideBarItemLogin.CssClass = "glyphicon glyphicon-remove"
            'TODO - MD: Localize the message
            ASPNETMsgBox("Password must be 6 or more characters in length!")
            txtPassword.Focus()
            txtPassword.SelectText()
        End If

        Return ValidatePWdLength

    End Function

#End Region

    Private Sub EmployeeDetails_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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