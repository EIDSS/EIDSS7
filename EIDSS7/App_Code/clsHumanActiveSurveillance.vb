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
    Public Class clsHumanActiveSurveillance
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As NG.EIDSSService

        Public Function ListAll(Optional ByVal args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()
                Dim param As String = String.Empty
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@CampaignModule", .ParamValue = "human", .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumActiveSurvGetList", oComm.KeyValPairToString(KeyValPair) & param)
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception

                ListAll = Nothing
                Throw

            End Try

            Return ListAll

        End Function

        Public Function SelectOne(ByVal dblId As Double) As DataSet Implements IEidssEntity.SelectOne

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

        Public Function AddUpdateHASC(ByVal HASCValues As String, ByRef oResult As Object()) As Int32

            Dim intResult As Int32 = 0

            Try

                oService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@CampaignCategoryID", .ParamValue = CampaignCategory.Human, .ParamMode = "IN"})
                Dim params As String = HASCValues & "|" & oComm.KeyValPairToString(KeyValPair)
                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvSet", params)
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    oResult = oTuple.m_Item2
                    intResult = oResult(1)
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
                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvDelete", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            End Try

        End Sub

        Public Sub DeleteSample(dblId As Double, ByRef oResult As Object())

            Try
                oService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & ActiveSurveillanceCampaignToSampleTypeConstants.CampaignToSampleType, .ParamValue = dblId, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "DeleteHumanActiveSurvCampaignToSampleType", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1

                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            End Try

        End Sub

        Public Sub SessionToCampaign(ByVal campaignID As Double, ByVal sessionID As Double)
            Try
                oService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                If campaignID <> 0 Then
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & ActiveSurveillanceCampaignConstants.Campaign, .ParamValue = campaignID, .ParamMode = "IN"})
                Else
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & ActiveSurveillanceCampaignConstants.Campaign, .ParamValue = "NULL", .ParamMode = "IN"})
                End If
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & ActiveSurveillanceSessionConstants.Session, .ParamValue = sessionID, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvSessionToCampaign", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1

                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            End Try
        End Sub

    End Class

End Namespace
