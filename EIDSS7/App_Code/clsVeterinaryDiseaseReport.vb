Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS

    Public Class clsVeterinaryDiseaseReport
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

#Region "Global Values"

        Private Const VET_DISEASE_GET_LIST_SP As String = "VetDiseaseGetList"
        Private Const VET_DISEASE_SET_SP As String = "VetDiseaseSet"
        Private Const VET_DISEASE_GET_DETAIL_SP As String = "VetDiseaseGetDetail"
        Private Const VET_DISEASE_DEL_SP As String = "VetDiseaseDel"
        Private Const VET_CASE_LOG_GET_LIST_SP As String = "VetCaseLogGetList"

#End Region

#Region "Select Methods"

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), VET_DISEASE_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
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
                Dim param As String = "|idfVetCase;" & dblId.ToString() & ";IN"

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), VET_DISEASE_GET_DETAIL_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

#Region "Veterinary Disease Report Logs"

        Public Function ListAllVetCaseLogs(Optional args() As String = Nothing) As DataSet

            ListAllVetCaseLogs = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), VET_CASE_LOG_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAllVetCaseLogs = oDS

            Catch ex As Exception

                ListAllVetCaseLogs = Nothing
                Throw

            End Try

            Return ListAllVetCaseLogs

        End Function

#End Region

#End Region

#Region "Add/Update Methods"

        Public Function AddUpdateVeterinaryDiseaseReport(ByVal args() As String,
                                                         ByVal dtHerds As DataTable,
                                                         ByVal dtSpecies As DataTable,
                                                         ByVal dtVaccinations As DataTable,
                                                         ByVal dtAnimals As DataTable,
                                                         ByVal dtSamples As DataTable,
                                                         ByVal dtPensideTests As DataTable,
                                                         ByVal dtLabTests As DataTable,
                                                         ByVal dtInterpretations As DataTable,
                                                         ByVal dtVetCaseLogs As DataTable,
                                                         ByRef oReturnValues As Object) As Int32

            Dim intResult As Int32 = 0

            Try
                Dim oComm As clsCommon = New clsCommon
                Dim oService As EIDSSService = oComm.GetService()
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim strParamHerds As String = "|Herds;Herds;IN;dbo.tlbFarmHerdSpeciesGetListSPType"
                Dim strParamSpecies As String = "|Species;Species;IN;dbo.tlbFarmHerdSpeciesGetListSPType"
                Dim strParamVaccinations As String = "|Vaccinations;Vaccinations;IN;dbo.tlbVaccinationGetListSPType"
                Dim strParamAnimals As String = "|Animals;Animals;IN;dbo.tlbAnimalGetListSPType"
                Dim strParamSamples As String = "|Samples;Samples;IN;dbo.tlbMaterialGetListSPType"
                Dim strParamPensideTests As String = "|PensideTests;PensideTests;IN;dbo.tlbPensideTestGetListSPType"
                Dim strParamLabTests As String = "|LabTests;LabTests;IN;dbo.tlbTestingGetListSPType"
                Dim strParamInterpretations As String = "|Interpretations;Interpretations;IN;dbo.tlbTestValidationGetListSPType"
                Dim strParamVetCaseLogs As String = "|VetCaseLogs;VetCaseLogs;IN;dbo.tlbVetCaseLogGetListSPType"

                Dim dsStructuredTables As DataSet = New DataSet
                dsStructuredTables.Tables.Add(dtHerds)
                dsStructuredTables.Tables.Add(dtSpecies)
                dsStructuredTables.Tables.Add(dtVaccinations)
                dsStructuredTables.Tables.Add(dtAnimals)
                dsStructuredTables.Tables.Add(dtSamples)
                dsStructuredTables.Tables.Add(dtPensideTests)
                dsStructuredTables.Tables.Add(dtLabTests)
                dsStructuredTables.Tables.Add(dtInterpretations)
                dsStructuredTables.Tables.Add(dtVetCaseLogs)

                Dim oTuple = oService.GetDataWithStructuredParams(GetCurrentCountry(), VET_DISEASE_SET_SP,
                                                                  oComm.KeyValPairToString(KeyValPair) & param &
                                                                  strParamHerds &
                                                                  strParamSpecies &
                                                                  strParamVaccinations &
                                                                  strParamAnimals &
                                                                  strParamSamples &
                                                                  strParamPensideTests &
                                                                  strParamLabTests &
                                                                  strParamInterpretations &
                                                                  strParamVetCaseLogs,
                                                                  dsStructuredTables)

                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    oReturnValues = oTuple.m_Item2
                    intResult = oTuple.m_Item2(0)
                End If

            Catch ex As Exception

                AddUpdateVeterinaryDiseaseReport = Nothing
                Throw

            End Try

            Return intResult

        End Function

#End Region

#Region "Delete Methods"

        Public Function DeleteDiseaseReport(ByVal id As Double,
                                            ByRef strWarningMessage As String) As Int32

            oService = oComm.GetService()
            Dim KeyValPair As New List(Of clsCommon.Param)
            KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfVetCase", .ParamValue = id, .ParamMode = "IN"})

            Dim oFarm As clsFarm = New clsFarm
            Dim oAnimal As clsAnimal = New clsAnimal
            Dim oVaccination As clsVaccination = New clsVaccination
            Dim oSample As clsSample = New clsSample
            Dim oPensideTest As clsPensideTest = New clsPensideTest
            Dim oTest As clsTest = New clsTest
            Dim oTestInterpretation As clsTestInterpretation = New clsTestInterpretation
            Dim intResult As Int32 = 0
            Dim strTempWarningMessage As String = Nothing
            Dim dsTemp As DataSet = New DataSet
            Dim dtTemp As DataTable = New DataTable
            Dim dsChildCollections As DataSet = New DataSet

            dsTemp = oFarm.ListAllFarmHerdSpecies({oComm.KeyValPairToString(KeyValPair)})
            If dsTemp.Tables(0).Rows.Count > 0 Then
                dtTemp = dsTemp.Tables(0).Select("RecordType = 'Herd'").CopyToDataTable
                dtTemp.TableName = VeterinaryDiseaseReportConstants.Herds
                dsChildCollections.Tables.Add(dtTemp)
            End If

            If dsTemp.Tables(0).Rows.Count > 0 Then
                dtTemp = dsTemp.Tables(0).Select("RecordType = 'Species'").CopyToDataTable
                dtTemp.TableName = VeterinaryDiseaseReportConstants.Species
                dsChildCollections.Tables.Add(dtTemp)
            End If

            dsTemp = oVaccination.ListAll({oComm.KeyValPairToString(KeyValPair)})
            If dsTemp.Tables(0).Rows.Count > 0 Then
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Vaccinations
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            End If

            dsTemp = oAnimal.ListAll({oComm.KeyValPairToString(KeyValPair)})
            If dsTemp.Tables(0).Rows.Count > 0 Then
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Animals
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            End If

            dsTemp = oSample.ListAll({oComm.KeyValPairToString(KeyValPair)})
            If dsTemp.Tables(0).Rows.Count > 0 Then
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Samples
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            End If

            dsTemp = oPensideTest.ListAll({oComm.KeyValPairToString(KeyValPair)})
            If dsTemp.Tables(0).Rows.Count > 0 Then
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.PensideTests
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            End If

            dsTemp = oTest.ListAll({oComm.KeyValPairToString(KeyValPair)})
            If dsTemp.Tables(0).Rows.Count > 0 Then
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.LabTests
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
            End If

            dsTemp = oTestInterpretation.ListAll({oComm.KeyValPairToString(KeyValPair)})
            If dsTemp.Tables(0).Rows.Count > 0 Then
                dsTemp.Tables(0).TableName = VeterinaryDiseaseReportConstants.Interpretations
                dsChildCollections.Tables.Add(dsTemp.Tables(0).Copy)
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
                    'TODO: Localize message
                    strWarningMessage = $"Unable to delete this Disease Report as it contains: " & strTempWarningMessage & ". Please remove those records prior to deletion of this Disease Report."
                    Return intResult
                End If

                Dim oDS As DataSet = Nothing
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), VET_DISEASE_DEL_SP, oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    intResult = oDS.Tables(0).Rows(0)(0)
                End If

            Catch ex As Exception

                DeleteDiseaseReport = Nothing
                Throw

            End Try

            Return intResult

        End Function

#End Region

    End Class

End Namespace
