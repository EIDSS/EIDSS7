Imports EIDSS.EIDSS
Public Class StatisticalDataDetails
    Inherits BaseEidssPage

    Private sObjectID As String = ""
    Private hsModifiedOA As New HashSet(Of String)
    Dim oEIDSSDS As DataSet = Nothing
    Private oComm As clsCommon = New clsCommon()
    Public sCountry As String = getConfigValue("DefaultCountry")

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack Then

            'Check for value saved in Statistical Data Admin
            oEIDSSDS = oComm.ReadEIDSSXML()
            hdfidfStatistic.Value = -1
            If oEIDSSDS.CheckDataSet() Then hdfidfStatistic.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfStatistic")
            oEIDSSDS = Nothing

            'Get Statistical dataset
            Dim oState As New clsStatisticalData
            Dim dsStatData As DataSet = oState.SelectOne(hdfidfStatistic.Value.ToInt64())
            dsStatData.CheckDataSet()

            Dim idfType As String = hdfStatisticDataType.Value
            Dim startDate As String = "null"

            If dsStatData.Tables(0).Rows.Count > 0 Then
                idfType = dsStatData.Tables(0).Rows(0)(StatisticTypes.idfsStatTypeData).ToString()
                startDate = dsStatData.Tables(0).Rows(0)(StatisticTypes.StatStartDate).ToString()
            End If

            'Populate Statisitic Type
            FillDropDown(ddlidfsStatisticDataType,
                         GetType(clsStatisticType),
                         Nothing,
                         "idfsStatisticDataType",
                         "strName",
                         idfType,
                         Nothing,
                         False)

            'populate parameter name
            BaseReferenceLookUp(ddlidfsParameterName, BaseReferenceConstants.HumanGender, HACodeList.HumanHACode)
            SaveHiddenBase()

            'populate age group
            BaseReferenceLookUp(ddlidfsStatisticalAgeGroup, BaseReferenceConstants.AgeGroups, HACodeList.NoneHACode)
            SetFormFields()

            If Not (String.IsNullOrWhiteSpace(hdfidfStatistic.Value) OrElse hdfidfStatistic.Value = "-1") Then
                FillFormForEdit(dsStatData)
            End If

        End If
        SetLocationUcProperties(ddlidfsStatisticDataType.SelectedValue)

    End Sub

    Private Sub SetFormFields()

        Dim oDS As DataSet = Nothing

        'Populate Statistical Period Type
        oDS = GetFormFieldIDAndValue(BaseReferenceConstants.StatisticalPeriodType, "Year")
        If oDS.CheckDataSet() Then
            hdfidfsStatisticPeriodType.Value = oDS.Tables(0).Rows(0).Item("idfsBaseReference")
            txtsetnPeriodTypeName.Text = oDS.Tables(0).Rows(0).Item("Name")
        End If

        'Reference Type Name
        oDS = GetFormFieldIDAndValue(BaseReferenceConstants.ReferenceTypeName, "Human Gender")
        If oDS.CheckDataSet() Then
            hdfidfsParameterType.Value = oDS.Tables(0).Rows(0).Item("idfsBaseReference")
            txtParameterType.Text = oDS.Tables(0).Rows(0).Item("Name")
            txtParameterType.ReadOnly = True
        End If

        Dim sSDT As String = ddlidfsStatisticDataType.SelectedValue

        SetLocationUcProperties(sSDT)
        SetPopDropDowns(sSDT)

        'Statistical Area Type
        Dim sAreaType As String = IIf(sSDT = StatisticTypes.Population, "Rayon", "Country")
        oDS = GetFormFieldIDAndValue(BaseReferenceConstants.StatisticalAreaType, sAreaType)
        If oDS.CheckDataSet() Then
            hdfidfsStatisticAreaType.Value = oDS.Tables(0).Rows(0).Item("idfsBaseReference")
            txtsetnAreaTypeName.Text = oDS.Tables(0).Rows(0).Item("Name") 'Not needed here Arnold but just in case change to ddl
            'ddlsetnAreaTypeName.Text = oDS.Tables(0).Rows(0).Item("Name")
        End If

    End Sub

    Private Sub SetPopDropDowns(ByVal sSDT As String)

        ageGroupContainer.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, IIf((sSDT = StatisticTypes.PopAgeGen), "display", "none"))
        parameterTypeContainer.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, IIf((sSDT = StatisticTypes.Population), "block", "none"))
        rfvParameterType.Enabled = sSDT.EqualsAny({StatisticTypes.PopAgeGen, StatisticTypes.PopGender})
        parameterNameContainer.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, IIf((sSDT = StatisticTypes.Population), "block", "none"))
        parameterTypeContainer.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, IIf((sSDT = StatisticTypes.PopAgeGen Or sSDT = StatisticTypes.PopGender), "display", "none"))
        parameterNameContainer.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, IIf((sSDT = StatisticTypes.PopAgeGen Or sSDT = StatisticTypes.PopGender), "display", "none"))

    End Sub

    Private Sub SetLocationUcProperties(sSDT As String)

        LocationUserControl.ShowCountry = (sSDT <> StatisticTypes.Population)
        LocationUserControl.ShowRegion = (sSDT = StatisticTypes.Population)
        LocationUserControl.ShowRayon = (sSDT = StatisticTypes.Population)
        ' is location db required?
        LocationUserControl.IsDbRequiredCountry = (sSDT = StatisticTypes.Population)
        LocationUserControl.IsDbRequiredRegion = (sSDT = StatisticTypes.Population)
        LocationUserControl.IsDbRequiredRayon = (sSDT = StatisticTypes.Population)


    End Sub

    Private Function GetFormFieldIDAndValue(sReferenceType As String, sValueFor As String) As DataSet

        Dim clsBR As clsBaseReference = New clsBaseReference
        Dim oDS As DataSet = Nothing

        'Statistical Period Type
        oDS = clsBR.ListAll({"@ReferenceTypeName:" & sReferenceType, "@intHACode:" & HACodeList.NoneHACode})
        If oDS.CheckDataSet() Then
            Dim oDV As DataView = oDS.Tables(0).DefaultView()
            oDV.RowFilter = "Name = '" & sValueFor & "'"
            Dim oFilteredDS As DataSet = New DataSet()
            Dim oDT As DataTable = oDV.ToTable()
            oFilteredDS.Tables.Add(oDT)
            oDS = oFilteredDS
        End If

        Return oDS

    End Function

    Private Sub FillFormForEdit(ByVal dsStatisticalData As DataSet)

        If dsStatisticalData.CheckDataSet() Then

            Dim oCommon As New clsCommon

            'populate PersonalInformationSection with the values
            oCommon.Scatter(StatisticalDataSection, New DataTableReader(dsStatisticalData.Tables(0)))
            SaveHiddenBase()

            'populate the location control
            Dim sSDT As String = ddlidfsStatisticDataType.SelectedValue
            SetPopDropDowns(sSDT)
            SetLocationUcProperties(sSDT)

            If dsStatisticalData.Tables(0).CheckDataTable() Then
                If dsStatisticalData.Tables(0).Rows(0)(CountryConstants.CountryID).ToString = "" Then
                    LocationUserControl.LocationCountryID = Nothing
                Else
                    LocationUserControl.LocationCountryID = CType(dsStatisticalData.Tables(0).Rows(0)(CountryConstants.CountryID), Long)
                End If

                If dsStatisticalData.Tables(0).Rows(0)(RegionConstants.RegionID).ToString = "" Then
                    LocationUserControl.LocationRegionID = Nothing
                Else
                    LocationUserControl.LocationRegionID = CType(dsStatisticalData.Tables(0).Rows(0)(RegionConstants.RegionID), Long)
                End If

                If dsStatisticalData.Tables(0).Rows(0)(RayonConstants.RayonID).ToString = "" Then
                    LocationUserControl.LocationRayonID = Nothing
                Else
                    LocationUserControl.LocationRayonID = CType(dsStatisticalData.Tables(0).Rows(0)(RayonConstants.RayonID), Long)
                End If

                If dsStatisticalData.Tables(0).Rows(0)(SettlementConstants.idfsSettlement).ToString = "" Then
                    LocationUserControl.LocationSettlementID = Nothing
                Else
                    LocationUserControl.LocationSettlementID = CType(dsStatisticalData.Tables(0).Rows(0)(SettlementConstants.idfsSettlement), Long)
                End If
                LocationUserControl.DataBind()
            End If

        End If

    End Sub

    Private Sub ddlidfsStatisticDataType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsStatisticDataType.SelectedIndexChanged
        SetFormFields()
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
        'Save Statistical  details  

        Dim oComm As clsCommon = New clsCommon
        Dim oService As NG.EIDSSService = oComm.getService()
        Dim aSP As String()
        Dim sRetVal As String = ""

        Dim oDS As DataSet = New DataSet()
        Dim formValues As String = ""
        Dim oTuple As Object

        aSP = oService.getSPList("StatisticSet")
        formValues = oComm.Gather(Me, aSP(0).ToString(), 3, True)
        oTuple = oService.GetData(GetCurrentCountry(), "StatisticSet", formValues)
        oDS = oTuple.m_Item1

        If oDS.CheckDataSet() Then ASPNETMsgBox(GetLocalResourceObject("Success_Message_text"), "StatisticalDataAdmin.aspx")
    End Sub

    Private Sub DisplayValidationErrors()
        'Paint all SideBarItems as Passed Validation and then correct those that failed
        sideBarItemStatisticalData.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)
                If IsNothing(section) Then section = TryCast(failedValidator.Parent.Parent.Parent, HtmlGenericControl)
                Select Case section.ID
                    Case "StatisticalDataSection"
                        sideBarItemStatisticalData.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
                        sideBarItemStatisticalData.CssClass = "glyphicon glyphicon-remove"
                End Select

            End If
        Next
    End Sub

    Private Sub SaveHiddenBase()
        hdfidfsMainBaseReference.Value = ddlidfsParameterName.SelectedValue
    End Sub

    Private Sub ddlidfsParameterName_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsParameterName.SelectedIndexChanged
        SaveHiddenBase()
    End Sub

    Private Sub StatisticalDataDetails_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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