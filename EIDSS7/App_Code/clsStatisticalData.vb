Imports EIDSS.NG
Imports System
Imports System.Data
Imports System.Text
Imports System.Web.UI

Namespace EIDSS
    Public Class clsStatisticalData
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            Dim oDS As DataSet = Nothing

            Try

                oService = oComm.GetService()
                Dim oTuple = oService.GetData(GetCurrentCountry(), "StatisticalList", args(0))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception

                ListAll = Nothing
                Throw

            Finally
                oDS = Nothing
            End Try

            Return ListAll

        End Function

        Public Function SelectOne(idfsStatisticId As Double) As DataSet Implements IEidssEntity.SelectOne

            SelectOne = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfStatistic", .ParamValue = idfsStatisticId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "StatisticGetDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

        End Function

        Public Sub Delete(ByVal id As Double)

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@ID", .ParamValue = id, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "StatisticDelete", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            Finally

            End Try

        End Sub

    End Class

End Namespace