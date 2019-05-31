Imports EIDSS.NG
Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Text
Imports System.Web.UI

Namespace EIDSS
    Public Class clsSettlement
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAllTypes() As DataSet

            ListAllTypes = Nothing

            Try

                oService = oComm.GetService()

                Dim aSP As String()
                aSP = oService.getSPList("SettlementType")
                Dim sSP As String = aSP(0)
                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "PersonGetList", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAllTypes = oDS

            Catch ex As Exception

                ListAllTypes = Nothing
                Throw

            End Try

            Return ListAllTypes

        End Function

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@RayonID", .ParamValue = args(0).ToString(), .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "SettlementLookup", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception

                ListAll = Nothing
                Throw

            End Try

            Return ListAll

        End Function

        Public Function ListData(args() As String) As DataSet

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet

                Dim oTuple = oService.GetData(GetCurrentCountry(), "SettlementGetList", args(0))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListData = oDS

            Catch ex As Exception

                ListData = Nothing
                Throw

            End Try

            Return ListData

        End Function

        Public Function SelectOne(idfSettlement As Double) As DataSet Implements IEidssEntity.SelectOne

            SelectOne = Nothing

            oService = oComm.GetService()

            Try

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfsSettlementID", .ParamValue = idfSettlement, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})

                Dim oDS As DataSet
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SettlementGetDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function SettlementTypes() As DataSet

            SettlementTypes = Nothing

            oService = oComm.GetService()

            Try

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SettlementGetDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SettlementTypes = oDS

            Catch ex As Exception

                SettlementTypes = Nothing
                Throw

            End Try

        End Function

        Public Sub Delete(ByVal id As Double)

            oService = oComm.GetService()

            Try

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfsSettlement", .ParamValue = id, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SettlementDelete", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            End Try

        End Sub

    End Class

End Namespace