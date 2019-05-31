Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS

    Public Class clsEmployee
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim oTuple = oService.GetData(GetCurrentCountry(), "PersonGetList", args(0))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception

                ListAll = Nothing
                Throw

            Finally

                oService = Nothing

            End Try

            Return ListAll

        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfPerson", .ParamValue = dblId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "PersonGetDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            Finally

                oService = Nothing

            End Try

            Return SelectOne

        End Function

        Public Sub Delete(ByVal id As Double)

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfPerson", .ParamValue = id, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "PersonDelete", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            Finally

                oService = Nothing

            End Try

        End Sub

        Function HashValue(sVal As String) As Object

            Dim hashVal As Object = Nothing
            oService = oComm.GetService()
            hashVal = oService.InitialHash(GetCurrentCountry(), sVal)
            oService = Nothing

            Return hashVal

        End Function

        Function AddUpdate(sDataFor As String, sSPVal As String) As Object

            Dim oTuple As Object = Nothing
            oService = oComm.GetService()
            oTuple = oService.GetData(GetCurrentCountry(), sDataFor, sSPVal)
            oService = Nothing

            Return oTuple

        End Function

    End Class

End Namespace