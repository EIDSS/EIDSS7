Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI

Namespace EIDSS

    Public Class clsSampleTypeReference
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService


        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SampleTypeReferenceList", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception
                ListAll = Nothing
                Throw
            End Try

            Return ListAll

        End Function


        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne
            Throw New NotImplementedException()
        End Function

        Public Function AddorUpdate(ByVal strParams As String, ByRef returnObject As Object) As Int32

            Dim intResult As Int32 = 0

            Try

                oService = oComm.GetService()
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SampleTypeReferenceSet", strParams & "|" & oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    intResult = oTuple.m_Item1.Tables(0).Rows(0)(0)
                End If

            Catch ex As Exception

                Throw

            End Try

            Return intResult
        End Function


        Public Function CurrentlyInUse(ByVal id As Double) As Boolean
            CurrentlyInUse = False
            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfsSampleType", .ParamValue = id, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SampleTypeReferenceInUse", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1

                If (oDS.CheckDataSet()) Then
                    CurrentlyInUse = oDS.Tables(0).Rows(0)("CurrentlyInUse")
                End If
            Catch
                Throw
            End Try
        End Function

        Public Function Delete(ByVal id As Double) As Boolean
            Delete = False
            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfsSampleType", .ParamValue = id, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SampleTypeReferenceDelete", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch
                Throw
            End Try
        End Function

        Public Function DoesExist(ByVal name As String) As Boolean
            DoesExist = False
            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@strName", .ParamValue = name, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SampleTypeDoesExist", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1

                If (oDS.CheckDataSet()) Then
                    DoesExist = oDS.Tables(0).Rows(0)("DoesExist")
                End If
            Catch
                Throw
            End Try
        End Function

    End Class

End Namespace