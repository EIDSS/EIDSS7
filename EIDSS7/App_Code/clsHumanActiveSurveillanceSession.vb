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
    Public Class clsHumanActiveSurveillanceSession
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As NG.EIDSSService

        Public Function ListAll(Optional ByVal args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            Try
                oService = oComm.GetService()
                Dim param As String = String.Empty
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@SessionModule", .ParamValue = "human", .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvSessionGetList", oComm.KeyValPairToString(KeyValPair) & "|" & param)
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

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfMonitoringSession", .ParamValue = dblId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvSessionGetDetail", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    SelectOne = oDS
                End If
            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function AddUpdateHASS(ByVal HASSValues As String, ByRef oResult As Object()) As Int32
            AddUpdateHASS = 0
            Try
                oService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@SessionCategoryID", .ParamValue = SessionCategory.Human, .ParamMode = "IN"})
                Dim params As String = HASSValues & "|" & oComm.KeyValPairToString(KeyValPair)
                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumanActiveSurvSessionSet", params)
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    'oResult = oTuple.m_Item2
                    'AddUpdateHASS = oResult(1)
                    AddUpdateHASS = 0
                End If
            Catch
                AddUpdateHASS = -1
                Throw
            End Try
        End Function

        Public Sub AddUpdateHASStoSample(ByVal HASStoSampleValues As String, ByRef oResult As Object())
            Try
                Dim oComm As clsCommon = New clsCommon()
                Dim oService As NG.EIDSSService = oComm.GetService()
                Dim oTuple1 = oService.GetData(getConfigValue("CountryCode"), "HumanActiveSurvSessionToSampleType", HASStoSampleValues)
                Dim oDS As DataSet = oTuple1.m_Item1
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub DeleteSample(ByVal dblid As Double)
            Try
                Dim oComm As clsCommon = New clsCommon()
                Dim oService As NG.EIDSSService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType, .ParamValue = dblid, .ParamMode = "IN"})
                Dim oTuple1 As Object = oService.GetData(getConfigValue("CountryCode"), "DeleteHumanActiveSurvSessionToSampleType", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple1.m_Item1
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub AddUpdateHAStoAction(ByVal HASStoActionValues As String)
            Try
                oService = oComm.GetService()
                Dim oTuple As Object = oService.GetData(GetCurrentCountry(), "HumanActiveSurvSessionToAction", HASStoActionValues)
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub DeleteHAStoAction(ByVal dblId As Double)
            Try
                Dim oComm As clsCommon = New clsCommon()
                Dim oService As NG.EIDSSService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & MonitoringSessionActionConstants.MonitoringSessionActionID, .ParamValue = dblId, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(getConfigValue("CountryCode"), "DeleteHumanActiveSurvSessionAction", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub AddUpdateHASStoMaterial(ByVal hassToMaterial As String, ByRef materialID As Double)
            Try
                Dim oComm As clsCommon = New clsCommon()
                Dim oService As NG.EIDSSService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = getConfigValue("DefaultLanguage"), .ParamMode = "IN"})

                Dim params As String = hassToMaterial & "|" & oComm.KeyValPairToString(KeyValPair)
                Dim oTuple1 As Object = oService.GetData(getConfigValue("CountryCode"), "HumanActiveSurvSessionToMaterial", params)
                Dim oDS As DataSet = oTuple1.m_Item1
                materialID = oTuple1.m_Item2(0)
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub DeleteHAStoMaterial(ByVal dblId As Double)
            Try
                Dim oComm As clsCommon = New clsCommon()
                Dim oService As NG.EIDSSService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & MaterialConstants.Material, .ParamValue = dblId, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(getConfigValue("CountryCode"), "DeleteHumanActiveSurvSessionMaterial", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub AddUpdateHASStoTest(ByVal hassToTest As String)
            Try
                Dim oComm As clsCommon = New clsCommon()
                Dim oService As NG.EIDSSService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = getConfigValue("DefaultLanguage"), .ParamMode = "IN"})
                Dim params As String = hassToTest & "|" & oComm.KeyValPairToString(KeyValPair)
                Dim oTuple1 As Object = oService.GetData(getConfigValue("CountryCode"), "HumanActiveSurvSessionToTesting", params)
                Dim oDS As DataSet = oTuple1.m_Item1
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub DeleteHAStoTest(ByVal dblId As Double)
            Try
                Dim oComm As clsCommon = New clsCommon()
                Dim oService As NG.EIDSSService = oComm.GetService()
                Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@" & TestConstants.TestingID, .ParamValue = dblId, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(getConfigValue("CountryCode"), "DeleteHumanActiveSurvSessionTest", oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1
                oDS.CheckDataSet()
            Catch
                Throw
            End Try
        End Sub

        Public Sub Delete(ByVal dblId As Double)
            Dim oComm As clsCommon = New clsCommon()
            Dim oService As NG.EIDSSService = oComm.GetService()
            Dim KeyValPair As List(Of clsCommon.Param) = New List(Of clsCommon.Param)

            KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfMonitoringSession", .ParamValue = dblId, .ParamMode = "IN"})
            Dim oTuple = oService.GetData(getConfigValue("CountryCode"), "HumanActiveSurvSessionDelete", oComm.KeyValPairToString(KeyValPair))

        End Sub
    End Class

End Namespace
