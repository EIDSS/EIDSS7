Imports System.Collections.Generic
Imports System.Data
Imports System.Reflection
Imports OpenEIDSS.Domain
Namespace EIDSS
    Public Class clsAggregate
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As NG.EIDSSService
        Private Shared Log = log4net.LogManager.GetLogger(GetType(LocationUserControl))

        Private m_MonthList As DataTable = New DataTable()
        Private m_QuarterList As DataTable = New DataTable()
        Private m_WeekList As DataTable = New DataTable()
        Private ReadOnly m_MinYear As Integer = 1900
        Dim WeeksList As List(Of WeekPeriod) = New List(Of WeekPeriod)

#Region "Database Methods"

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing

                Dim oTuple = oService.GetData(GetCurrentCountry(), "AggregateGetList", args(0))
                oDS = DirectCast(oTuple.m_Item1, DataSet)
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception
                ListAll = Nothing
                'Throw
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)

            End Try

            Return ListAll

        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne

            SelectOne = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@RegionID", .ParamValue = dblId.ToString(), .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "<enter proc reference>", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

        End Function

        Public Function SelectOneCase(strID As String) As DataSet

            SelectOneCase = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@strSearchCaseID", .ParamValue = strID, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "AggregateGetList", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOneCase = oDS

            Catch ex As Exception

                SelectOneCase = Nothing
                Throw

            End Try

        End Function

        Public Function AddOrUpdate(aggValues As String) As String
            Dim idfAgg As String = "0"

            Try
                Dim intResult As Int32 = 0
                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), "AggregateSave", aggValues)
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    Dim oRetVal As Object() = oTuple.m_Item2
                    'idfAgg = DirectCast(oRetVal(0), String) '=>= Throws an exception

                    ' Temp fix '==> Asim
                    '? tlb.Rows(0)("strCaseID") ==> "VADTBTBZ190054"
                    ' Bug 2617 - Enter Veterinary Aggregate - No confirmation message displays when adding a new report
                    Dim tlb As DataTable = oDS.Tables(oDS.Tables.Count - 1)
                    Dim dataRow As DataRow = tlb.Rows(0)
                    idfAgg = tlb.Rows(0)("strCaseID")
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
            Return idfAgg
        End Function

        Public Function AddUpdateAgg(ByVal args() As String,
                                      ByVal dtHerds As DataTable,
                                      ByVal dtSpecies As DataTable,
                                      ByRef oReturnValues As Object) As Int32

            Dim intResult As Int32 = 0

            Try

                oService = oComm.GetService()

                Dim param As String = String.Empty
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim strParamHerds As String = "|Herds;Herds;IN;dbo.tlbFarmHerdSpeciesGetListSPType"
                Dim strParamSpecies As String = "|Species;Species;IN;dbo.tlbFarmHerdSpeciesGetListSPType"

                Dim dsStructuredTables As DataSet = New DataSet
                dsStructuredTables.Tables.Add(dtHerds)
                dsStructuredTables.Tables.Add(dtSpecies)

                Dim oTuple = oService.GetDataWithStructuredParams(GetCurrentCountry(), "AggregateSet",
                                                                  oComm.KeyValPairToString(KeyValPair) & param &
                                                                  strParamHerds &
                                                                  strParamSpecies,
                                                                  dsStructuredTables)

                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    oReturnValues = oTuple.m_Item2
                    intResult = oTuple.m_Item2(0)
                End If

                'Catch ex As Exception

                '    Throw

                'End Try
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return intResult

        End Function
        Public Sub Delete(ByVal id As Double)

            Try
                oService = oComm.GetService()
                Dim oDS As DataSet = New DataSet()

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@ID", .ParamValue = id, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "AggregateHumanDelete", oComm.KeyValPairToString(KeyValPair))

                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                'Catch ex As Exception
                '    Throw
                'Finally

                'End Try
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        End Sub

        Public Function GetOrgByEmp(empID As Double) As DataSet

            Dim oEmpDS As DataSet
            Dim oOrgDS As DataSet = Nothing
            Dim oEmp As clsEmployee = New clsEmployee
            Dim oOrg As clsOrganization = New clsOrganization()

            Try
                oEmpDS = oEmp.SelectOne(empID)
                If oEmpDS.CheckDataSet() Then

                    If oEmpDS.Tables(0).CheckDataTable() Then
                        oOrgDS = oOrg.SelectOne(CType(oEmpDS.Tables(0).Rows(0)(PersonConstants.idfInstitution), Double))
                        oOrgDS.CheckDataSet()
                    End If

                End If

            Catch ex As Exception
                oOrgDS = Nothing
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)

            Finally
                oEmpDS = Nothing
                oEmp = Nothing
                oOrg = Nothing
            End Try

            Return oOrgDS

        End Function

#End Region

#Region "Date Functions"

        Public Function FillQuarterList(ByVal year As Integer) As DataTable

            If Not IsNothing(m_QuarterList) Then m_QuarterList.Clear()
            m_QuarterList = CreatePeriodTable()

            Dim d As Date = New DateTime(year, 1, 1)

            For i As Integer = 1 To 4
                If (year = DateTime.Today.Year AndAlso d > DateTime.Today) Then
                    Exit For
                End If

                Dim q As DataRow = m_QuarterList.NewRow
                q("StartDay") = d
                q("PeriodNumber") = i
                q("PeriodID") = year.ToString() + "_" + i.ToString()
                d = d.AddMonths(3)
                d = d.AddDays(-1)
                q("FinishDay") = d
                d = d.AddDays(1)
                'q("PeriodName") = String.Format("{0:d} - {1:d}", q("StartDay"), q("FinishDay"))

                'Bug 3830 - Concatenate "Period Number" to the Quarter display values as specified in VAUC05  - Asim
                q("PeriodName") = String.Format("{2} - {0:d} - {1:d}", q("StartDay"), q("FinishDay"), i)
                m_QuarterList.Rows.Add(q)
            Next

            Return m_QuarterList

        End Function

        Public Function GetQuarterValue(ByVal year As Integer, ByVal month As Integer) As String

            GetQuarterValue = ""
            Dim quart As Integer = ((month - 1) / 3) + 1

            GetQuarterValue = year.ToString() & "_" & quart.ToString()
            Return GetQuarterValue

        End Function

        Private Sub AddMonthRow(ByVal monthTable As DataTable, ByVal year As Integer, ByVal monthNum As Integer, ByVal monthName As String)

            Dim d As Date = New DateTime(year, monthNum, 1)
            If (d.Year = DateTime.Today.Year AndAlso d > DateTime.Today) Then
                Return
            End If
            Dim m As DataRow = monthTable.NewRow
            'm("PeriodName") = EidssMessages.Get(monthName)
            m("PeriodName") = monthName
            m("StartDay") = d
            m("PeriodNumber") = d.Month
            m("PeriodID") = year.ToString() + "_" + d.Month.ToString()
            d = d.AddMonths(1)
            m("FinishDay") = d.AddDays(-1)
            monthTable.Rows.Add(m)

        End Sub

        Public Function FillMonthList(ByVal year As Integer) As DataTable

            Try
                'If Not IsNothing(m_MonthList) Then m_MonthList.Clear()
                'm_MonthList = CreatePeriodTable()

                'Dim dsMonths As DataSet = GetMonthNames()
                'Dim intMonth As Integer = 1

                'If dsMonths.CheckDataSet() Then
                '    For Each dr As DataRow In dsMonths.Tables(0).Rows
                '        AddMonthRow(m_MonthList, year, intMonth, dr(Months.MonthName))
                '        intMonth = intMonth + 1
                '    Next
                'End If

                'Return m_MonthList

                ' THIS IS A HACK TO DEPLOY FOR VERSION 0.0.56.1.... CODE WILL BE REFACTORED!!!!! SV 12.12.2018

                If Not IsNothing(m_MonthList) Then m_MonthList.Clear()
                m_MonthList = CreatePeriodTable()

                'Dim dt As DataTable = New DataTable()
                'Dim dsMonths As DataSet = GetMonthNames()
                Dim intMonth As Integer = 1
                'Dim dr As DataRow = Nothing
                Dim monthDict As New Dictionary(Of Integer, String)

                monthDict.Add(10300007, "January")
                monthDict.Add(10300006, "February")
                monthDict.Add(10300010, "March")
                monthDict.Add(10300003, "April")
                monthDict.Add(10300011, "May")
                monthDict.Add(10300009, "June")
                monthDict.Add(10300008, "July")
                monthDict.Add(10300004, "August")
                monthDict.Add(10300014, "September")
                monthDict.Add(10300013, "October")
                monthDict.Add(10300012, "November")
                monthDict.Add(10300005, "December")

                For Each item As Integer In monthDict.Keys
                    AddMonthRow(m_MonthList, year, intMonth, monthDict(item))
                    intMonth = intMonth + 1
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return m_MonthList

        End Function

        Private Function GetMonthNames() As DataSet

            Dim oDS As DataSet = New DataSet()
            Try
                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), "MonthList", GetLanguageParameter())
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                'Catch
                '    oDS = Nothing
                '    Throw

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return oDS
        End Function

        Public Function GetSettingMins() As DataSet

            Dim oDS As DataSet = Nothing

            Try
                oService = oComm.GetService()
                Dim KeyValPair As New List(Of clsCommon.Param)

                'TODO - Remove the hardcoded value with a constant
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfsAggrCaseType", .ParamValue = 10102001, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "AggregateSettingDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
                'oDS = Nothing
                Throw
            End Try

            Return oDS
        End Function

        Public Sub FillPeriod(ByRef DropDown As DropDownList, Optional empty As Boolean = False)
            Try
                Log.Info("FillPeriod reference in ClsAggregate begins")

                'Display week # as the contents of PeriodName (VAUC05) - Asim
                If DropDown.ID = "ddlintWeek" Then
                    DropDown.DataTextField = "PeriodNumber"
                Else
                    DropDown.DataTextField = "PeriodName"
                End If

                'DropDown.DataTextField = "PeriodName"
                DropDown.DataValueField = "PeriodID"
                DropDown.DataBind()
                If empty Then DropDown.Items.Insert(0, New ListItem("", "null"))

                'Set default Month to current month;
                'DropDown.SelectedIndex = DropDown.Items.Count - 1  'UseCase requires default value to be <blank>

                Log.Info("FillPeriod reference in ClsAggregate ends")
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
                'oDS = Nothing
                Throw
            End Try
        End Sub

        Public Function FillWeekList(ByVal year As Integer) As DataTable

            Try
                m_WeekList.Clear()
                m_WeekList = CreatePeriodTable()

                For Each wp As WeekPeriod In GetWeeksList(year)
                    If (wp.weekStartDate.Year = DateTime.Today.Year AndAlso wp.weekStartDate > DateTime.Today) Then
                        Exit For
                    End If
                    Dim weekRow As DataRow = m_WeekList.NewRow
                    weekRow("PeriodNumber") = wp.weekNumber
                    weekRow("StartDay") = wp.weekStartDate
                    weekRow("PeriodID") = year.ToString() + "_" + wp.weekNumber.ToString()
                    weekRow("FinishDay") = wp.weekEndDate
                    weekRow("PeriodName") = String.Format("{0:d} - {1:d}", weekRow("StartDay"), weekRow("FinishDay"))
                    m_WeekList.Rows.Add(weekRow)
                Next

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return m_WeekList
        End Function

        Private Function GetWeeksList(year As Integer) As List(Of WeekPeriod)

            Dim wStartDate As DateTime = New DateTime(year, 1, 1)
            Dim lastDayOfYear As DateTime = wStartDate.AddYears(1).AddDays(-1)
            Dim weekNum As Int16 = 1

            Try
                'if year selected is current year, set last date to today
                If lastDayOfYear > DateTime.Today Then lastDayOfYear = DateTime.Today

                'in the loop, each week starts 7 days after the previous start date
                While wStartDate < lastDayOfYear
                    Dim wPer = New WeekPeriod()
                    wPer.year = year
                    wPer.weekNumber = weekNum
                    wPer.weekStartDate = wStartDate
                    wPer.weekEndDate = wStartDate.AddDays(6)
                    WeeksList.Add(wPer)

                    weekNum = weekNum + 1
                    wStartDate = wStartDate.AddDays(7)
                End While

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            Return WeeksList

        End Function

        Public Function GetWeekValue(ByVal sDate As DateTime) As String

            For Each wp In WeeksList
                If wp.weekStartDate.ToShortDateString() = sDate Then
                    Return wp.year.ToString() & "_" & wp.weekNumber.ToString()
                End If
            Next

            Return Nothing
        End Function

        Private Shared Function CreatePeriodTable() As DataTable

            Dim dt As New DataTable
            dt.Columns.Add(New DataColumn("PeriodNumber", GetType(Integer)))
            dt.Columns.Add(New DataColumn("StartDay", GetType(DateTime)))
            dt.Columns.Add(New DataColumn("FinishDay", GetType(DateTime)))
            dt.Columns.Add(New DataColumn("PeriodName", GetType(String)))
            dt.Columns.Add(New DataColumn("PeriodID", GetType(String)))
            dt.PrimaryKey = New DataColumn() {dt.Columns("PeriodNumber")}
            Return dt

        End Function

        Class WeekPeriod
            Private _year As Int16
            Private _weekNumber As Int16
            Private _weekStartDate As DateTime
            Private _weekEndDate As DateTime

            Public Property year As Int16
                Get
                    Return _year
                End Get
                Set(value As Int16)
                    _year = value
                End Set
            End Property

            Public Property weekNumber As Int16
                Get
                    Return _weekNumber
                End Get
                Set(value As Int16)
                    _weekNumber = value
                End Set
            End Property

            Public Property weekStartDate As DateTime
                Get
                    Return _weekStartDate
                End Get
                Set(value As DateTime)
                    _weekStartDate = value
                End Set
            End Property

            Public Property weekEndDate As DateTime
                Get
                    Return _weekEndDate
                End Get
                Set(value As DateTime)
                    _weekEndDate = value
                End Set
            End Property
        End Class

#End Region

    End Class

End Namespace
