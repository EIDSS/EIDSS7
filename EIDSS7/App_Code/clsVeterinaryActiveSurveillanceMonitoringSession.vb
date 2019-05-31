Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS
    Public Class clsVeterinaryActiveSurveillanceMonitoringSession
        Implements IEidssEntity

#Region "Global Values"

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Private Const MONITORING_SESSION_TO_SAMPLE_TYPE_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionToSampleTypeGetList"
        Private Const MONITORING_SESSION_ACTION_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionActionGetList"
        Private Const MONITORING_SESSION_SUMMARY_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionSummaryGetList"
        Private Const MONITORING_SESSION_SET_SP As String = "VetActiveSurvMonitoringSessionSet"
        Private Const MONITORING_SESSION_DEL_SP As String = "VetActiveSurvMonitoringSessionDelete"
        Private Const MONITORING_SESSION_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionGetList"
        Private Const MONITORING_SESSION_GET_DETAIL_SP As String = "VetActiveSurvMonitoringSessionGetDetail"

        Private Const SESSION_DATASET As String = "dsSessions"
        Private Const DISEASE_TO_SPECIES_DATASET As String = "dsDiseaseToSpecies"
        Private Const SPECIES_AND_SAMPLES_DATASET As String = "dsSpeciesAndSamples"
        Private Const HERD_SPECIES_DATASET As String = "dsFarmHerdsSpecies"
        Private Const ANIMAL_DATASET As String = "dsAnimals"
        Private Const SAMPLE_DATASET As String = "dsSamples"
        Private Const TEST_DATASET As String = "dsTests"
        Private Const INTERPRETATION_DATASET As String = "dsInterpretations"
        Private Const ACTION_DATASET As String = "dsActions"
        Private Const AGGREGATE_INFO_DATASET As String = "dsAggregateInfo"
        Private Const VETERINARY_DISEASE_REPORT_DATASET As String = "dsVeterinaryDiseaseReports"
        Private Const MONITORING_SESSION_DATATABLE As String = "dtMonitoringSession"

#End Region

#Region "Select Methods"

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), MONITORING_SESSION_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
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

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfMonitoringSession", .ParamValue = dblId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), MONITORING_SESSION_GET_DETAIL_SP, oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

#Region "Monitoring Session To Sample Type"

        Public Function ListAllMonitoringSessionToSampleType(Optional args() As String = Nothing) As DataSet

            ListAllMonitoringSessionToSampleType = Nothing

            Try
                Dim oCommon As clsCommon = New clsCommon
                Dim oService As NG.EIDSSService = oCommon.GetService()

                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oDS As DataSet = Nothing
                Dim oTuple = oService.GetData(getConfigValue("CountryCode"), MONITORING_SESSION_TO_SAMPLE_TYPE_GET_LIST_SP, oCommon.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet

                ListAllMonitoringSessionToSampleType = oDS
            Catch ex As Exception
                ListAllMonitoringSessionToSampleType = Nothing
                Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
                ASPNETMsgBox(strMsg)
            End Try

            Return ListAllMonitoringSessionToSampleType

        End Function

#End Region

#Region "Monitoring Session Actions"

        Public Function ListAllMonitoringSessionActions(Optional args() As String = Nothing) As DataSet

            ListAllMonitoringSessionActions = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), MONITORING_SESSION_ACTION_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAllMonitoringSessionActions = oDS

            Catch ex As Exception

                ListAllMonitoringSessionActions = Nothing
                Throw

            End Try

            Return ListAllMonitoringSessionActions

        End Function

#End Region

#Region "Monitoring Session Summaries"

        Public Function ListAllMonitoringSessionSummaries(Optional args() As String = Nothing) As DataSet

            ListAllMonitoringSessionSummaries = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), MONITORING_SESSION_SUMMARY_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAllMonitoringSessionSummaries = oDS

            Catch ex As Exception

                ListAllMonitoringSessionSummaries = Nothing
                Throw

            End Try

            Return ListAllMonitoringSessionSummaries

        End Function

#End Region

#End Region

#Region "Add/Update Methods"

        Public Function AddUpdateActiveSurveillanceMonitoringSession(ByVal args() As String,
                                                           ByVal dtFarms As DataTable,
                                                           ByVal dtHerds As DataTable,
                                                           ByVal dtSpecies As DataTable,
                                                           ByVal dtAnimals As DataTable,
                                                           ByVal dtMonitoringSessionToSampleType As DataTable,
                                                           ByVal dtSamples As DataTable,
                                                           ByVal dtLabTests As DataTable,
                                                           ByVal dtInterpretations As DataTable,
                                                           ByVal dtActions As DataTable,
                                                           ByVal dtAggregateInfo As DataTable,
                                                           ByRef oReturnValues As Object) As Int32

            Dim intResult As Int32 = 0

            Try
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                oService = oComm.GetService()

                Dim strParamFarms As String = "|Farms;Farms;IN;dbo.tlbFarmHerdSpeciesGetListSPType"
                Dim strParamHerds As String = "|Herds;Herds;IN;dbo.tlbFarmHerdSpeciesGetListSPType"
                Dim strParamSpecies As String = "|Species;Species;IN;dbo.tlbFarmHerdSpeciesGetListSPType"
                Dim strParamAnimals As String = "|Animals;Animals;IN;dbo.tlbAnimalGetListSPType"
                Dim strParamMonitoringSessionToSampleType As String = "|SpeciesAndSamples;SpeciesAndSamples;IN;dbo.tlbMonitoringSessionToSampleTypeGetListSPType"
                Dim strParamSamples As String = "|Samples;Samples;IN;dbo.tlbMaterialGetListSPType"
                Dim strParamLabTests As String = "|Tests;Tests;IN;dbo.tlbTestingGetListSPType"
                Dim strParamInterpretations As String = "|Interpretations;Interpretations;IN;dbo.tlbTestValidationGetListSPType"
                Dim strParamActions As String = "|Actions;Actions;IN;dbo.tlbMonitoringSessionActionGetListSPType"
                Dim strParamAggregateInfo As String = "|Summaries;Summaries;IN;dbo.tlbMonitoringSessionSummaryGetListSPType"

                Dim dsStructuredTables As DataSet = New DataSet
                dsStructuredTables.Tables.Add(dtFarms)
                dsStructuredTables.Tables.Add(dtHerds)
                dsStructuredTables.Tables.Add(dtSpecies)
                dsStructuredTables.Tables.Add(dtAnimals)
                dsStructuredTables.Tables.Add(dtMonitoringSessionToSampleType)
                dsStructuredTables.Tables.Add(dtSamples)
                dsStructuredTables.Tables.Add(dtLabTests)
                dsStructuredTables.Tables.Add(dtInterpretations)
                dsStructuredTables.Tables.Add(dtActions)
                dsStructuredTables.Tables.Add(dtAggregateInfo)

                Dim oTuple = oService.GetDataWithStructuredParams(GetCurrentCountry(),
                                                                  MONITORING_SESSION_SET_SP,
                                                                  oComm.KeyValPairToString(KeyValPair) & param &
                                                                  strParamFarms &
                                                                  strParamHerds &
                                                                  strParamSpecies &
                                                                  strParamAnimals &
                                                                  strParamMonitoringSessionToSampleType &
                                                                  strParamSamples &
                                                                  strParamLabTests &
                                                                  strParamInterpretations &
                                                                  strParamActions &
                                                                  strParamAggregateInfo,
                                                                  dsStructuredTables)

                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    oReturnValues = oTuple.m_Item2
                    intResult = oTuple.m_Item1.Tables(0).Rows(0)(0)
                End If

            Catch ex As Exception

                AddUpdateActiveSurveillanceMonitoringSession = Nothing
                Throw

            End Try

            Return intResult

        End Function

#End Region

#Region "Delete Methods"

        Public Function DeleteSurveillanceSession(ByVal args() As String,
                                                  ByRef strWarningMessage As String,
                                                  ByVal sbViewState As StateBag) As Int32

            oService = oComm.GetService()
            Dim oAnimal As clsAnimal = New clsAnimal
            Dim oSample As clsSample = New clsSample
            Dim oFarm As clsFarm = New clsFarm
            Dim oTest As clsTest = New clsTest
            Dim oTestInterpretation As clsTestInterpretation = New clsTestInterpretation
            Dim intResult As Int32 = 0
            Dim strTempWarningMessage As String = Nothing
            Dim dsTemp As DataSet = New DataSet
            Dim dtTemp As DataTable = New DataTable
            Dim dsChildCollections As DataSet = New DataSet

            'Species and Samples
            If (sbViewState(SPECIES_AND_SAMPLES_DATASET) Is Nothing) Then
                dsTemp = ListAllMonitoringSessionToSampleType({args(0)})
                dsTemp.Tables(0).TableName = ActiveSurveillanceSessionConstants.SpeciesAndSamples
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            Else
                dsTemp = CType(sbViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
                If (dsTemp.Tables(0).Select("intRowStatus = 0").Length > 0) Then
                    dsTemp.Tables(0).TableName = ActiveSurveillanceSessionConstants.SpeciesAndSamples
                    dsChildCollections.Tables.Add(dsTemp.Tables(0).Select("intRowStatus = 0").CopyToDataTable)
                End If
            End If

            'Farms
            If (sbViewState(HERD_SPECIES_DATASET) Is Nothing) Then
                dsTemp = oFarm.ListAllFarmHerdSpecies({args(0)})
                If dsTemp.Tables(0).Select("RecordType = 'Herd'").Count > 0 Then
                    dtTemp = dsTemp.Tables(0).Select("RecordType = 'Herd'").CopyToDataTable
                    dtTemp.TableName = VeterinaryDiseaseReportConstants.Herds
                    dsChildCollections.Tables.Add(dtTemp)
                End If

                If dsTemp.Tables(0).Select("RecordType = 'Species'").Count > 0 Then
                    dtTemp = dsTemp.Tables(0).Select("RecordType = 'Species'").CopyToDataTable
                    dtTemp.TableName = VeterinaryDiseaseReportConstants.Species
                    dsChildCollections.Tables.Add(dtTemp)
                End If
            Else
                dsTemp = CType(sbViewState(HERD_SPECIES_DATASET), DataSet)
                If dsTemp.Tables(0).Select("RecordType = 'Herd' AND intRowStatus = 0").Count > 0 Then
                    dtTemp = dsTemp.Tables(0).Select("RecordType = 'Herd' AND intRowStatus = 0").CopyToDataTable
                    dtTemp.TableName = VeterinaryDiseaseReportConstants.Herds
                    dsChildCollections.Tables.Add(dtTemp)
                End If

                If dsTemp.Tables(0).Select("RecordType = 'Species' AND intRowStatus = 0").Count > 0 Then
                    dtTemp = dsTemp.Tables(0).Select("RecordType = 'Species' AND intRowStatus = 0").CopyToDataTable
                    dtTemp.TableName = VeterinaryDiseaseReportConstants.Species
                    dsChildCollections.Tables.Add(dtTemp)
                End If
            End If

            'Animals
            If (sbViewState(ANIMAL_DATASET) Is Nothing) Then
                dsTemp = oAnimal.ListAll({args(0)})
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Animals
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            Else
                dsTemp = CType(sbViewState(ANIMAL_DATASET), DataSet)
                If (dsTemp.Tables(0).Select("intRowStatus = 0").Length > 0) Then
                    dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Animals
                    dsChildCollections.Tables.Add(dsTemp.Tables(0).Select("intRowStatus = 0").CopyToDataTable)
                End If
            End If

            'Samples
            If (sbViewState(SAMPLE_DATASET) Is Nothing) Then
                dsTemp = oSample.ListAll({args(0)})
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Samples
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            Else
                dsTemp = CType(sbViewState(SAMPLE_DATASET), DataSet)
                If (dsTemp.Tables(0).Select("intRowStatus = 0").Length > 0) Then
                    dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Samples
                    dsChildCollections.Tables.Add(dsTemp.Tables(0).Select("intRowStatus = 0").CopyToDataTable)
                End If
            End If

            'Lab Tests
            If (sbViewState(TEST_DATASET) Is Nothing) Then
                dsTemp = oTest.ListAll({args(0)})
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.LabTests
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            Else
                dsTemp = CType(sbViewState(TEST_DATASET), DataSet)
                If (dsTemp.Tables(0).Select("intRowStatus = 0").Length > 0) Then
                    dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.LabTests
                    dsChildCollections.Tables.Add(dsTemp.Tables(0).Select("intRowStatus = 0").CopyToDataTable)
                End If
            End If


            'Interpretations
            If (sbViewState(INTERPRETATION_DATASET) Is Nothing) Then
                dsTemp = oTestInterpretation.ListAll({args(0)})
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Interpretations
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            Else
                dsTemp = CType(sbViewState(INTERPRETATION_DATASET), DataSet)
                If (dsTemp.Tables(0).Select("intRowStatus = 0").Length > 0) Then
                    dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Interpretations
                    dsChildCollections.Tables.Add(dsTemp.Tables(0).Select("intRowStatus = 0").CopyToDataTable)
                End If
            End If

            'Actions
            If (sbViewState(ACTION_DATASET) Is Nothing) Then
                dsTemp = ListAllMonitoringSessionActions({args(0)})
                dsTemp.Tables(0).TableName = ActiveSurveillanceSessionConstants.Actions
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            Else
                dsTemp = CType(sbViewState(ACTION_DATASET), DataSet)
                If (dsTemp.Tables(0).Select("intRowStatus = 0").Length > 0) Then
                    dsTemp.Tables(0).TableName = ActiveSurveillanceSessionConstants.Actions
                    dsChildCollections.Tables.Add(dsTemp.Tables(0).Select("intRowStatus = 0").CopyToDataTable)
                End If
            End If

            'Summaries
            If (sbViewState("dsSummaries") Is Nothing) Then
                dsTemp = ListAllMonitoringSessionSummaries({args(0)})
                dsTemp.Tables(0).TableName = ActiveSurveillanceSessionConstants.Summaries
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            Else
                dsTemp = CType(sbViewState("dsSummaries"), DataSet)
                If (dsTemp.Tables(0).Select("intRowStatus = 0").Length > 0) Then
                    dsTemp.Tables(0).TableName = ActiveSurveillanceSessionConstants.Summaries
                    dsChildCollections.Tables.Add(dsTemp.Tables(0).Select("intRowStatus = 0").CopyToDataTable)
                End If
            End If

            Try
                For Each dt As DataTable In dsChildCollections.Tables
                    If dt.Rows.Count > 0 Then
                        intResult = -1

                        If strTempWarningMessage = Nothing Then
                            strTempWarningMessage &= dt.TableName
                        Else
                            strTempWarningMessage &= ", " & dt.TableName
                        End If
                    End If
                Next

                If intResult = -1 Then
                    strWarningMessage = $"Unable to delete this Surveillance Session as it contains: " & strTempWarningMessage & ". Please remove those records prior to deletion of this Surveillance Session."
                    Return intResult
                End If

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), MONITORING_SESSION_DEL_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                intResult = oDS.Tables(0).Rows(0)(0)

            Catch ex As Exception

                DeleteSurveillanceSession = Nothing
                Throw

            End Try

            Return intResult

        End Function

#End Region

    End Class

End Namespace
