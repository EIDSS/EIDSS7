Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS

    Public Class clsTestInterpretation
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), "TestValidationGetList", oComm.KeyValPairToString(KeyValPair) & param)
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

                Dim param As String = "|idfTestValidation;" & dblId.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "TestValidationGetDetail", oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function AddUpdateTestInterpretation(ByVal testValues As String) As Int32

            Dim intResult As Int32 = 0

            Try

                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), "TestValidationSet", testValues)
                Dim oDS As DataSet = oTuple.m_Item1

                Dim oResult As Object() = Nothing
                If oDS.CheckDataSet() Then
                    oResult = oTuple.m_Item2
                    intResult = DirectCast(oResult(0), Int32)
                End If

            Catch ex As Exception

                Throw

            End Try

            Return intResult

        End Function

    End Class

End Namespace
