Imports EIDSS.EIDSS

Public Class PersonSearch
    Inherits BaseEidssPage

    'Private sPerID As String
    Private Const idColumn = 6
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            'On Page load all my containers are invisible.  Set the Search panel if it is the firstload\
            If Page.IsPostBack = False Then
                searchForm.Visible = True
            End If
            PopulateSearchDropdowns()
            GetSearchFields()
        End If

    End Sub

    Private Sub PopulateSearchDropdowns()

        'ddlPersonalIDType
        BaseReferenceLookUp(lddlidfsPersonIdType, BaseReferenceConstants.PersonalIDType, HACodeList.NoneHACode, True)

        'ddlNewGender
        BaseReferenceLookUp(lddlidfsHumanGender, BaseReferenceConstants.HumanGender, HACodeList.HumanHACode, True)
    End Sub
    Private Sub PopulateNewPatientDropdowns()

        'ddlPersonalIDType
        BaseReferenceLookUp(ddlidfsPersonIDType, BaseReferenceConstants.PersonalIDType, HACodeList.NoneHACode, True)

        'ddlNewGender
        BaseReferenceLookUp(ddlidfsHumanGender, BaseReferenceConstants.HumanGender, HACodeList.HumanHACode, True)
        'Age Type
        BaseReferenceLookUp(ddlReportAgeUOMID, BaseReferenceConstants.HumanAgeType, HACodeList.HumanHACode, True)
        'Citizenship
        'BaseReferenceLookUp(ddlidfsCitizenship, BaseReferenceConstants.NationalityList, HACodeList.HumanHACode, True)
        'Phone Types
        'BaseReferenceLookUp(ddlidfsPhoneType, BaseReferenceConstants.PhoneType, HACodeList.NoneHACode, True)
        'BaseReferenceLookUp(ddlidfsOtherPhoneType, BaseReferenceConstants.PhoneType, HACodeList.NoneHACode, True)
        'BaseReferenceLookUp(ddlidfsEmployerPhoneType, BaseReferenceConstants.PhoneType, HACodeList.NoneHACode, True)
        'BaseReferenceLookUp(ddlidfsSchoolPhoneType, BaseReferenceConstants.PhoneType, HACodeList.NoneHACode, True)
        '
    End Sub
    Private Sub PersonSearchList()
        If ValidateForSearch() Then
            ShowSearchCriteria()
            FillPersonList(bRefresh:=True)
        End If
    End Sub

    Private Sub FillPersonList(Optional sGetDataFor As String = "GRIDROWS", Optional bRefresh As Boolean = False)

        Dim dsPeople As DataSet

        'Place Region and Rayon data in txt boxes
        If lucSearch.SelectedRayonValue <> -1 AndAlso lucSearch.SelectedRayonValue <> "" Then ltxtidfsRayon.Text = lucSearch.SelectedRayonValue
        If lucSearch.SelectedRegionValue <> -1 AndAlso lucSearch.SelectedRegionValue <> "" Then ltxtidfsRegion.Text = lucSearch.SelectedRegionValue
        ltxtdatDateOfBirth.Text = ltxtdatDateOfBirth.Text
        SaveSearchFields()

        Try
            If bRefresh Or IsNothing(ViewState("dsPeople")) Then
                Dim oCommon As New clsCommon()
                Dim oPerson As clsPerson = New clsPerson()
                Dim oService As NG.EIDSSService = oCommon.GetService()
                Dim aSP As String() = oService.getSPList("PatientGetList")
                Dim strParams As String = oCommon.Gather(searchForm, aSP(0), 4, True)
                dsPeople = oPerson.ListAll({strParams})
                If dsPeople.CheckDataSet() Then
                    ViewState("dsPeople") = dsPeople
                End If
            Else
                dsPeople = CType(ViewState("dsPeople"), DataSet)
            End If

            gvPeople.DataSource = Nothing
            'If dsPeople.CheckDataSet() Then
            Dim strFilter As String = ""
            'BuildSearchFilter(strFilter)
            'If strFilter <> "" Then
            '    Dim oDV As DataView = dsPeople.Tables(0).DefaultView()
            '    oDV.RowFilter = strFilter
            '    Dim oFilteredDS As DataSet = New DataSet()
            '    Dim oDT As DataTable = oDV.ToTable()
            '    oFilteredDS.Tables.Add(oDT)
            '    dsPeople = oFilteredDS
            'End If
            gvPeople.DataSource = dsPeople.Tables(0)
            gvPeople.DataBind()

            'End If

        Catch ex As Exception
            Dim strMsg As String = "The following Error occurred In FillPersonList:" & ex.Message.Replace("'", "`")
            lblAlertMessage.InnerText = strMsg
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "AlertModalScript", "$(Function(){ $('#" & alertMessageVSS.ClientID & "').modal('show');});", True)
        End Try
    End Sub
    Private Sub SortGrid(ByVal e As GridViewSortEventArgs, ByRef gv As GridView, ByVal vsDS As String)

        Dim sortedView As DataView = New DataView(CType(ViewState(vsDS), DataSet).Tables(0))
        Dim sortDir As String = SetSortDirection(e)

        sortedView.Sort = e.SortExpression + " " + sortDir

        gv.DataSource = sortedView
        gv.DataBind()
    End Sub

    Private Function SetSortDirection(ByVal e As GridViewSortEventArgs) As String

        Dim dir As String '= "0"
        Dim lastCol As String = String.Empty
        If Not IsNothing(ViewState("peoCol")) Then lastCol = ViewState("peoCol").ToString()

        If lastCol = e.SortExpression Then
            If ViewState("peoDir") = "0" Then
                dir = "DESC"
                ViewState("peoDir") = SortDirection.Descending
            Else
                dir = "ASC"
                ViewState("peoDir") = SortDirection.Ascending
            End If
        Else
            dir = "ASC"
            ViewState("peoDir") = SortDirection.Ascending
        End If
        ViewState("peoCol") = e.SortExpression

        Return dir
    End Function
    'Private Sub BuildSearchFilter(ByRef strFilter)
    '    Dim Filter As StringBuilder = New StringBuilder()

    '    SaveSearchFields()

    '    If txtEIDSSIDNumber.Text.Length > 0 Then
    '        Filter.Append("idfPerson = '").Append(txtEIDSSIDNumber.Text.Trim()).Append("'")
    '    Else
    '        If ddlGender.SelectedValue <> -1 Then Filter.Append("idfsHumanGender = ").Append(ddlGender.SelectedValue)

    '        If txtPersonalID.Text.Length > 0 Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("strPersonID like '").Append(txtPersonalID.Text.Trim()).Append("%'")
    '        End If
    '        If txtFirstName.Text.Length > 0 Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("strFirstName like '").Append(txtFirstName.Text.Trim()).Append("%'")
    '        End If
    '        If txtMiddleInit.Text.Length > 0 Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("strMiddleInit like '").Append(txtMiddleInit.Text.Trim()).Append("%'")
    '        End If
    '        If txtLastName.Text.Length > 0 Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("strLastName like '").Append(txtLastName.Text.Trim()).Append("%'")
    '        End If
    '        'If txtSuffix.Text.Length > 0 Then
    '        '    If Filter.Length > 0 Then Filter.Append(" and ")
    '        '    Filter.Append("strPersonID like '").Append(txtSuffix.Text.Trim()).Append("%'")
    '        'End If
    '        If txtdatDoB.Text.Length > 0 Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("datDateofBirth = '").Append(txtdatDoB.Text.Trim()).Append("'")
    '        End If
    '        If lucSearch.SelectedRegionValue <> -1 AndAlso lucSearch.SelectedRegionValue Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("idfsRegion = ").Append(lucSearch.SelectedRegionValue)
    '        End If
    '        If lucSearch.SelectedRayonValue <> -1 AndAlso lucSearch.SelectedRayonValue <> "" Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("idfsRayon = ").Append(lucSearch.SelectedRayonValue)
    '        End If
    '        If ddlPersonalIDType.SelectedValue <> "" AndAlso ddlPersonalIDType.SelectedValue <> -1 Then
    '            If Filter.Length > 0 Then Filter.Append(" and ")
    '            Filter.Append("idfsRayon = ").Append(ddlPersonalIDType.SelectedValue)
    '        End If
    '    End If

    '    strFilter = Filter.ToString()

    'End Sub
    Private Function FillDiseaseList(Optional sGetDataFor As String = "GRIDROWS", Optional bRefresh As Boolean = False) As DataSet
        Return Nothing
    End Function
    Private Sub EnablePersonalID()
        ltxtstrPersonID.Enabled = lddlidfsPersonIdType.SelectedIndex > -1
    End Sub
    Private Sub ShowSearchCriteria()
        Try
            lblSearchCritEIDSSID.Text = ltxtEIDSSIDNumber.Text
            lblSearchCritFirstName.Text = ltxtstrFirstName.Text
            lblSearchCritLastName.Text = ltxtstrLastName.Text
            lblSearchCritDoB.Text = ltxtdatDateOfBirth.Text
            lblSearchCritPersonalID.Text = ltxtstrPersonID.Text
            lblSearchCritRegion.Text = lucSearch.SelectedRegionText
            lblSearchCritGender.Text = lddlidfsHumanGender.SelectedItem.Text
            lblSearchCritIDType.Text = lddlidfsPersonIdType.SelectedItem.Text
            lblSearchCritRayon.Text = lucSearch.SelectedRayonText
        Catch x As NullReferenceException
        End Try
    End Sub

    Protected Sub AddPerson()
        Dim oCommon As New clsCommon()
        'Dim oLoc As New clsLocation()
        Dim oService As NG.EIDSSService = oCommon.GetService()
        Dim aSPL As String() = oService.getSPList("LocationSave") 'need to have a row in SpList referring to locations

        'Step 1:
        'Gather the location data to different variables
        'Dim empAddrValues As String = oCommon.Gather(employmentInformation, aSPL(0), 3, True)
        'Dim schAddrValues As String = oCommon.Gather(schoolInformation, aSPL(0), 3, True)
        'Dim othAddressValues As String = oCommon.Gather(otherAddress, aSPL(0), 3, True)
        'Dim regAddressValues As String = oCommon.Gather(patientAddress, aSPL(0), 3, True)

        'Step 2
        'save the adresses to location table and
        'Store the idfs for each address type in hidden fields within personalInformation
        'hdfidfPatientAddress.Value = oLoc.AddOrUpdate(othAddressValues).ToString()

        'Currently, additional parameter references are needed to satisfy the procedure
        'hdfidfEmployerAddress.Value = oLoc.AddOrUpdate(empAddrValues).ToString()
        'hdfidfEmployerAddress.Value = oLoc.AddOrUpdate("idfGeoLocation;-1;IN|idfsCountry;780000000;IN|idfsRegion;37030000000;IN|idfsRayon;-1;IN|idfsSettlement;-1;IN|strApartment;;IN|strBuilding;;IN|strStreetName;;IN|strHouse;321;IN|strPostCode;-1;IN|blnForeignAddress;0;IN|strForeignAddress;null;IN")
        'for foreign address
        'hdfidfEmployerAddress.Value = oLoc.AddOrUpdate("idfGeoLocation;-1;IN|idfsCountry;780000000;IN|idfsRegion;-1;IN|idfsRayon;-1;IN|idfsSettlement;-1;IN|strApartment;;IN|strBuilding;;IN|strStreetName;;IN|strHouse;;IN|strPostCode;;IN|blnForeignAddress;1;IN|strForeignAddress;not from around here;IN")

        'hdfidfSchoolAddress.Value = oLoc.AddOrUpdate(schAddrValues).ToString()
        'hdfidfRegistrationAddress.Value = oLoc.AddOrUpdate(regAddressValues).ToString()

        'Step 3
        'Gather the patient info along with hidden fields
        Dim aSPP As String() = oService.getSPList("PatientSet")
        Dim patientValues As String = oCommon.Gather(patient, aSPP(0), 3, True)
        'patientValues = patientValues & oCommon.Gather(personalAddress, aSPP(0), 3, True)

        'Dim oPerson As clsPerson = New clsPerson()
        'Dim result As Int16 = oPerson.AdUpdatePatient(patientValues)
    End Sub


    ''' <summary>
    ''' Determines that there are search fields populated
    ''' Satisfies 3.1 The system checks to ensure at least one search parameter is entered.
    ''' </summary>
    ''' <returns></returns>
    Private Function ValidateForSearch() As Boolean
        Dim oCom As clsCommon = New clsCommon()
        ValidateForSearch = False
        If oCom.ValidateDOB(ltxtdatDateOfBirth.Text) Then
            ValidateForSearch = ltxtEIDSSIDNumber.TextSize() Or ltxtdatDateOfBirth.TextSize() Or ltxtstrFirstName.TextSize() Or ltxtstrLastName.TextSize() Or ltxtstrSecondName.TextSize() Or ltxtstrPersonID.TextSize() Or lddlidfsHumanGender.SelectedValue > -1 Or lucSearch.SelectedRegionValue > -1 Or lucSearch.SelectedRayonValue > -1
            If Not ValidateForSearch Then
                lblAlertMessage.InnerText = "Please enter at least one search parameter"
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "AlertModalScript", "$(Function(){ $('#" & alertMessageVSS.ClientID & "').modal('show');});", True)

                ltxtEIDSSIDNumber.Focus()
            End If
        Else
            lblAlertMessage.InnerText = "Date of Birth is not valid"
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "AlertModalScript", "$(Function(){ $('#" & alertMessageVSS.ClientID & "').modal('show');});", True)
            ltxtdatDateOfBirth.Focus()
        End If

    End Function
    Private Sub FillFormForReview(Optional ByVal row As Integer = -1)
        Dim sPerID As String ' = gvPeople.SelectedIndex

        Try
            If row < 0 Then
                sPerID = gvPeople.SelectedRow.Cells(idColumn).Text
                'Review
                patientReview.Visible = True
            Else
                sPerID = gvPeople.Rows(row).Cells(idColumn).Text
                patient.Visible = True
            End If

            If row = -1 Then
                'Review
                patientReview.Visible = True
            Else
                'edit
                patient.Visible = True
            End If

            Dim oPerson As New clsPerson
            Dim dsPerson As DataSet = oPerson.SelectOne(sPerID)
            searchResults.Visible = False
            disease.Visible = False

            Dim ds As DataSet = New DataSet()
            ds.Tables.Add(MimicFillDisGrid())
            gvDisease.DataSource = ds
            gvDisease.DataBind()
            ViewState("dsDis") = ds
            If dsPerson.CheckDataSet() Then


                Dim oCommon As New clsCommon
                oCommon.Scatter(patientReview, New DataTableReader(dsPerson.Tables(0)))
                'If (Not ClientScript.IsStartupScriptRegistered("rtp")) Then
                '    Page.ClientScript.RegisterStartupScript(Me.GetType(), "rtp", "returntoPerson();", True)
                'End If


            End If
        Catch ae As ArgumentOutOfRangeException
            '
        End Try
    End Sub

    Private Sub FillDiseaseFormForReview(Optional ByVal row As Integer = -1)
        Dim sDisID As String

        Try
            If row < 0 Then
                sDisID = gvDisease.SelectedRow.Cells(1).Text
            Else
                sDisID = gvDisease.Rows(row).Cells(1).Text
            End If

            'Dim oDis As clsHumanDisease = New clsHumanDisease()
            'Dim dsD As DataSet = oDis.ListOne(sDisID)

        Catch ae As ArgumentOutOfRangeException

        Catch ex As Exception
        End Try

    End Sub
    Private Sub GetSearchFields()
        Dim oPSD As PersonSearchData = New PersonSearchData()

        Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(PersonSearchData))
        Dim fs As IO.FileStream
        Dim sFile As String = GetSFileName()

        If sFile <> "" AndAlso IO.File.Exists(sFile) Then
            fs = New IO.FileStream(sFile, IO.FileMode.Open)
            oPSD = oSerializer.Deserialize(fs)

            With oPSD
                ltxtEIDSSIDNumber.Text = .StxtEiddssID
                lddlidfsPersonIdType.SelectedValue = .SddlPerIdType
                ltxtstrPersonID.Text = .StxtPerIdNum
                ltxtstrFirstName.Text = .StxtFirstName
                ltxtstrLastName.Text = .StxtLastName
                ltxtstrSecondName.Text = .StxtMidName
                ltxtdatDateOfBirth.Text = .StxtDOB
                lddlidfsHumanGender.SelectedValue = .SddlGender
                lucSearch.SelectedRayonValue = .SddlRayon
                lucSearch.SelectedRegionValue = .SddlRegion
            End With

            fs.Close()
            fs.Dispose()

            '    FillPersonList(bRefresh:=True)
            'Else
            '    FillPersonList()
        End If
    End Sub
    Private Sub SaveSearchFields()
        Dim oPSD As PersonSearchData = New PersonSearchData()

        With oPSD
            .StxtEiddssID = ltxtEIDSSIDNumber.Text
            .SddlPerIdType = lddlidfsPersonIdType.SelectedValue
            .StxtPerIdNum = ltxtstrPersonID.Text
            .StxtFirstName = ltxtstrFirstName.Text
            .StxtLastName = ltxtstrLastName.Text
            .StxtMidName = ltxtstrSecondName.Text
            .StxtDOB = ltxtdatDateOfBirth.Text
            .SddlGender = lddlidfsHumanGender.SelectedValue
            .SddlRayon = lucSearch.SelectedRayonValue
            .SddlRegion = lucSearch.SelectedRegionValue
        End With

        Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(PersonSearchData))
        Dim fw As IO.StreamWriter
        Dim sFile As String = GetSFileName()

        If sFile <> "" Then
            fw = New IO.StreamWriter(sFile)
            oSerializer.Serialize(fw, oPSD)
            fw.Flush()
            fw.Close()
            fw.Dispose()
        End If
    End Sub
    Private Sub ShowPersonDetail(pnl As Integer)
        hdnPanelController.Value = pnl
        searchResults.Visible = False
        patient.Visible = True
        PopulateNewPatientDropdowns()
    End Sub
    Private Sub ClearSearch()
        Dim clsComm As New clsCommon()
        clsComm.DeleteTempFiles(GetSFileName())
        clsComm.ResetForm(searchForm)
    End Sub
    Private Function GetSFileName() As String
        Return Server.MapPath("\") & "App_Data\" & Session("UserID").ToString() & "_PS.xml"
    End Function

    Private Sub PersonSearch_Error(Sender As Object, e As EventArgs) Handles Me.[Error]
        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then

            'ASPNETMsgBox("An error occurred on this page. Please verify your information to resolve the issue.")
            lblAlertMessage.InnerText = "An Error occurred On this page. Please verify your information To resolve the issue."
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "AlertModalScript", "$(Function(){ $('#" & alertMessageVSS.ClientID & "').modal('show');});", True)
        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~" & Request.ApplicationPath & "GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & Me.GetType.Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()
    End Sub
    Private Function MimicFillDisGrid() As DataTable

        Dim filename As String = Server.MapPath(" \ ") & "App_Data\" & "disease.txt"
        Dim dt As DataTable = New DataTable()
        Dim sr As IO.StreamReader

        Try

            sr = New IO.StreamReader(filename)
            Dim textLine As String()

            dt.Columns.Add("idfsDisease", GetType(String))
            dt.Columns.Add("datEnteredDate", GetType(DateTime))
            dt.Columns.Add("strClinicalDiagnosis", GetType(String))
            dt.Columns.Add("datTentativeDiagnosisDate", GetType(DateTime))
            dt.Columns.Add("strStatus", GetType(String))
            dt.Columns.Add("strRegion", GetType(String))
            dt.Columns.Add("strRayon", GetType(String))
            dt.Columns.Add("strClassification", GetType(String))
            dt.Columns.Add("strPersonName", GetType(String))
            dt.Columns.Add("idfHuman", GetType(String))
            dt.Columns.Add("strPersonEnteredBy", GetType(String))
            dt.Columns.Add("datOnSetDate", GetType(DateTime))

            While Not sr.EndOfStream
                textLine = sr.ReadLine().Split(";")
                Dim newRow As DataRow = dt.Rows.Add()
                For col As Integer = 0 To textLine.Length - 1
                    newRow.SetField(col, textLine(col).Trim())
                Next
            End While
        Catch exi As IO.IOException

        Catch ex As Exception
        Finally
            If Not IsNothing(sr) Then sr.Dispose()
        End Try
        Return dt
    End Function
#Region "Events"
    Protected Sub gvPeople_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvPeople.PageIndexChanging
        gvPeople.PageIndex = e.NewPageIndex
        FillPersonList(sGetDataFor:="PAGE")
    End Sub

    Protected Sub gvDisease_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDisease.PageIndexChanging
        gvDisease.PageIndex = e.NewPageIndex
        FillDiseaseList(sGetDataFor:="PAGE")
    End Sub

    Protected Sub gvPeople_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvPeople.SelectedIndexChanged
        FillFormForReview()
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        ' Hide the search form and show the results
        searchForm.Visible = False
        searchResults.Visible = True

        PersonSearchList()
    End Sub

    Protected Sub gvPeople_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvPeople.RowEditing
        FillFormForReview(e.NewEditIndex)
    End Sub

    Protected Sub ddlPersonalIDType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles lddlidfsPersonIdType.SelectedIndexChanged
        EnablePersonalID()
    End Sub

    Protected Sub btnEditSearch_Click(sender As Object, e As EventArgs) Handles btnEditSearch.Click
        ' hide the results and show the search form
        searchResults.Visible = False
        searchForm.Visible = True
    End Sub

    Protected Sub btnNewSearch_Click(sender As Object, e As EventArgs) Handles btnNewSearch.Click
        searchResults.Visible = False
        searchForm.Visible = True
        patient.Visible = False
        disease.Visible = False
        FillPersonList()
    End Sub

    Protected Sub btnNewPatient_Click(sender As Object, e As EventArgs) Handles btnNewPatient.Click
        ShowPersonDetail(0)
        'hdnPanelController.Value = 0
        'searchResults.Visible = False
        'patient.Visible = True
    End Sub

    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ClearSearch()
    End Sub

    Protected Sub gvPeople_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvPeople.Sorting
        SortGrid(e, CType(sender, GridView), "dsPeople")
    End Sub
    Private Sub gvDisease_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvDisease.Sorting
        SortGrid(e, CType(sender, GridView), "dsDis")
    End Sub

    Protected Sub btn_Return_to_Person_Record_Click(sender As Object, e As EventArgs)

    End Sub

    Protected Sub btn_Submit_Disease_Report_Click(sender As Object, e As EventArgs)

    End Sub

    Protected Sub btnAddNew_Click(sender As Object, e As EventArgs)
        patient.Visible = False
        patientReview.Visible = True
        AddPerson()
    End Sub

    Protected Sub btnReturnToSearch2_ServerClick(sender As Object, e As EventArgs) Handles btnReturnToSearch2.ServerClick
        patientReview.Visible = False
        disease.Visible = False
        searchForm.Visible = True
    End Sub

    Protected Sub btnNewSearch2_ServerClick(sender As Object, e As EventArgs) Handles btnNewSearch2.ServerClick
        ClearSearch()
        patientReview.Visible = False
        searchForm.Visible = True
    End Sub

    Protected Sub btnNewDisease_ServerClick(sender As Object, e As EventArgs) Handles btnNewDisease.ServerClick
        hdnPanelController.Value = 0
        patientReview.Visible = False
        disease.Visible = True
    End Sub

    Private Sub gvDisease_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvDisease.SelectedIndexChanged
        FillDiseaseFormForReview()
    End Sub
    Protected Sub lnkEditPerson_Click(sender As Object, e As EventArgs)
        patientReview.Visible = False
        patient.Visible = True
    End Sub

#End Region

    Public Class PersonSearchData
        Private _StxtEiddssID As String
        Private _SddlPerIdType As String
        Private _StxtPerIdNum As String
        Private _StxtFirstName As String
        Private _StxtLastName As String
        Private _StxtMidName As String
        Private _StxtSuffix As String
        Private _StxtDOB As String
        Private _SddlGender As String
        Private _SddlRayon As String
        Private _SddlRegion As String


        Public Property StxtEiddssID As String
            Get
                Return _StxtEiddssID
            End Get
            Set(value As String)
                _StxtEiddssID = value
            End Set
        End Property

        Public Property SddlPerIdType As String
            Get
                Return _SddlPerIdType
            End Get
            Set(value As String)
                _SddlPerIdType = value
            End Set
        End Property

        Public Property StxtPerIdNum As String
            Get
                Return _StxtPerIdNum
            End Get
            Set(value As String)
                _StxtPerIdNum = value
            End Set
        End Property

        Public Property StxtFirstName As String
            Get
                Return _StxtFirstName
            End Get
            Set(value As String)
                _StxtFirstName = value
            End Set
        End Property

        Public Property StxtLastName As String
            Get
                Return _StxtLastName
            End Get
            Set(value As String)
                _StxtLastName = value
            End Set
        End Property

        Public Property StxtMidName As String
            Get
                Return _StxtMidName
            End Get
            Set(value As String)
                _StxtMidName = value
            End Set
        End Property

        Public Property StxtSuffix As String
            Get
                Return _StxtSuffix
            End Get
            Set(value As String)
                _StxtSuffix = value
            End Set
        End Property

        Public Property StxtDOB As String
            Get
                Return _StxtDOB
            End Get
            Set(value As String)
                _StxtDOB = value
            End Set
        End Property

        Public Property SddlGender As String
            Get
                Return _SddlGender
            End Get
            Set(value As String)
                _SddlGender = value
            End Set
        End Property

        Public Property SddlRayon As String
            Get
                Return _SddlRayon
            End Get
            Set(value As String)
                _SddlRayon = value
            End Set
        End Property

        Public Property SddlRegion As String
            Get
                Return _SddlRegion
            End Get
            Set(value As String)
                _SddlRegion = value
            End Set
        End Property
    End Class


End Class