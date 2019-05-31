Imports System.Data
Imports EIDSS.EIDSS
Imports System.Web.UI.Control
Imports System
Imports System.Collections.Generic
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS

    Public Class clsHumActiveSurvCampaign
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As NG.EIDSSService

        Private oDS As DataSet

        Dim KeyValPair As List(Of clsCommon.Param)

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()
                Dim param As String = String.Empty
                KeyValPair = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvGetList", oComm.KeyValPairToString(KeyValPair) & param)
                Dim oDS As DataSet = oTuple.m_Item1
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
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfCampaign", .ParamValue = dblId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvGetDetail", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function AddUpdateHASC(ByVal HASCValues As String) As Int32

            'TODO RM: why campain category is added when not used
            Dim intResult As Int32 = 0

            Try

                oService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@CampaignCategoryID", .ParamValue = AggregateValue.Human, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvSet", HASCValues)
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

        Public Sub Delete(dblId As Double)

            Try
                oService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfCampaign", .ParamValue = dblId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvDelete", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            End Try

        End Sub

    End Class

End Namespace
