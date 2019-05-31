Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS
    Public Class clsVectorSurv
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), "VectorSurveillanceGetList", oComm.KeyValPairToString(KeyValPair) & param)
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

        Public Function SubmitNewFormData(ByVal diseaseValues As String,
                                            ByVal VectorSession As DataTable,
                                            ByVal Vector As DataTable,
                                            ByVal VectorSummary As DataTable,
                                            ByVal Samples As DataTable,
                                            ByVal FieldTests As DataTable,
                                            ByRef returnValues As Object) As Int32

            Dim intResult As Int32 = 0

            'Try
            '    Dim oComm As clsCommon = New clsCommon
            '    Dim KeyValPair As New List(Of clsCommon.Param)
            '    Dim oService As NG.EIDSSService = oComm.GetService()

            '    Dim paramHerds As String = "|Herds;Herds;IN;dbo.tlbHerdGetListSPType"
            '    Dim paramSpecies As String = "|Species;Species;IN;dbo.tlbSpeciesGetListSPType"
            '    Dim paramVaccinations As String = "|Vaccinations;Vaccinations;IN;dbo.tlbVaccinationGetListSPType"
            '    Dim paramSamples As String = "|Samples;Samples;IN;dbo.tlbMaterialGetListSPType"
            '    Dim paramPensideTests As String = "|PensideTests;PensideTests;IN;dbo.tlbPensideTestGetListSPType"
            '    Dim paramLabTests As String = "|LabTests;LabTests;IN;dbo.tlbTestingGetListSPType"
            '    Dim paramInterpretations As String = "|Interpretations;Interpretations;IN;dbo.tlbTestValidationGetListSPType"
            '    Dim paramVetCaseLogs As String = "|VetCaseLogs;VetCaseLogs;IN;dbo.tlbVetCaseLogGetListSPType"

            '    Dim structuredTables As DataSet = New DataSet
            '    structuredTables.Tables.Add(Herds)
            '    structuredTables.Tables.Add(Species)
            '    structuredTables.Tables.Add(Vaccinations)
            '    structuredTables.Tables.Add(Samples)
            '    structuredTables.Tables.Add(PensideTests)
            '    structuredTables.Tables.Add(LabTests)
            '    structuredTables.Tables.Add(Interpretations)
            '    structuredTables.Tables.Add(VetCaseLogs)

            '    Dim oTuple = oService.GetDataWithStructuredParams(GetCurrentCountry(), "VetDiseaseSet",
            '                                  diseaseValues &
            '                                  paramHerds &
            '                                  paramSpecies &
            '                                  paramVaccinations &
            '                                  paramSamples &
            '                                  paramPensideTests &
            '                                  paramLabTests &
            '                                  paramInterpretations &
            '                                  paramVetCaseLogs,
            '                                  structuredTables)

            '    Dim oDS As DataSet = oTuple.m_Item1

            '    If oDS.CheckDataSet() Then
            '        returnValues = oTuple.m_Item2
            '        intResult = oTuple.m_Item2(0)
            '    End If
            'Catch ex As Exception
            '    SubmitNewFormData = Nothing
            '    Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
            '    ASPNETMsgBox(strMsg)
            'End Try

            Return intResult

        End Function

    End Class
End Namespace
