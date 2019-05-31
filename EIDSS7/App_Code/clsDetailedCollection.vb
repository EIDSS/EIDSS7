Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS
    Public Class clsDetailedCollection
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
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfVectorSurveillanceSession", .ParamValue = args(0).ToString(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "VectorCollectionGetList", oComm.KeyValPairToString(KeyValPair))
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

            SelectOne = Nothing
            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)


                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfVectorSurveillanceSession", .ParamValue = dblId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "DetailedCollectionGet", oComm.KeyValPairToString(KeyValPair))
                oDS = DirectCast(oTuple.m_Item1, DataSet)
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function SelectForEdit(dblID As Double) As DataSet

            'TODO RG: To be completed
            Return Nothing

        End Function

        Public Function AdUpdatePatient(ByVal patientValues As String) As Int32

            'TODO RG: To be completed
            Return Nothing

        End Function

        Public Sub Delete(ByVal id As Double)

            'TODO RG: To be completed

        End Sub

    End Class

End Namespace
