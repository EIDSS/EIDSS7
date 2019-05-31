Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS

    Public Class clsDisease
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing

                Dim oTuple = oService.GetData(GetCurrentCountry(), "DiseaseGetList", args(0))
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

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@SearchHumanCaseId", .ParamValue = dblId.ToString(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "DiseaseGetDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function AdUpdateDisease(ByVal diseaseValues As String) As Int32

            Dim intResult As Int32 = 0
            Try

                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), "DiseaseSet", diseaseValues)
                Dim oDS As DataSet = oTuple.m_Item1

                Dim oResult As Object() = Nothing
                If oDS.CheckDataSet() Then
                    oResult = oTuple.m_Item2
                    intResult = oResult(0)
                End If

            Catch ex As Exception

                Throw

            End Try

            Return intResult

        End Function


        Public Function AdUpdateDisease(ByVal diseaseValues As String, ByVal ds As DataSet) As Int32

            Dim intResult As Int32 = 0
            Try
                Dim oService As EIDSSService = oComm.GetService()
                Dim strParamSamples As String = "|Samples;Samples;IN;dbo.tlbHdrMaterialGetListSPType"
                Dim strParamTests As String = "|Tests;Tests;IN;dbo.tlbHdrTestGetListSPType"
                'add contacts here


                Dim oTuple = oService.GetDataWithStructuredParams(GetCurrentCountry(), "DiseaseSet",
                                                                  diseaseValues &
                                                                  strParamSamples &
                                                                  strParamTests,
                                                                  ds)

                Dim oDS As DataSet = oTuple.m_Item1

                Dim oResult As Object() = Nothing
                If oDS.CheckDataSet() Then
                    oResult = oTuple.m_Item2
                    intResult = oResult(0)
                End If

            Catch ex As Exception

                Throw

            End Try

            Return intResult

        End Function

        Public Function DeleteDisease(ByVal strParams As String,
                                   ByRef strWarningMessage As String) As Int32

            oService = oComm.GetService()
            Dim intResult As Int32 = 0
            Dim strTempWarningMessage As String = Nothing
            Dim formValues As String = ""

            Try
                Dim oDS As DataSet = Nothing
                formValues = "LangID" + New clsCommon.Param() With {.ParamValue = GetCurrentLanguage(), .ParamMode = "IN"}.ToString
                formValues = String.Concat(formValues, "|idfHumanCase" + New clsCommon.Param() With {.ParamValue = strParams, .ParamMode = "IN"}.ToString)
                Dim oTuple = oService.GetData(GetCurrentCountry(), "DiseaseDelete", formValues)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                'TODO - MD: Incorrect way to return "return" value
                intResult = oDS.Tables(1).Rows(0)(0)

            Catch ex As Exception

                DeleteDisease = Nothing
                Throw

            End Try

            Return intResult

        End Function


#Region "Risk"
        Public Function ListAllRiskEmpty(ByVal diagnosisID As Double) As DataSet

            'TODO - JJ: Incomplete method
            ListAllRiskEmpty = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = "|idfDiag;" & diagnosisID.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                'Dim oTuple = oService.GetData(GetCurrentCountry(), "RiskSP", oComm.KeyValPairToString(KeyValPair) & param)
                'oDS = DirectCast(oTuple.m_Item1, DataSet)

                ListAllRiskEmpty = oDS

            Catch ex As Exception

                ListAllRiskEmpty = Nothing
                Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
                ASPNETMsgBox(strMsg)

            End Try

            Return ListAllRiskEmpty

        End Function

        Public Function ListAllRisk(ByVal diseaseID As Double) As DataSet

            'TODO - JJ: Incomplete method
            ListAllRisk = Nothing

            Try
                Dim oComm As clsCommon = New clsCommon
                Dim oService As EIDSSService = oComm.getService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = "|idfDiag;" & diseaseID.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                'Dim oTuple = oService.GetData(GetCurrentCountry(), "RiskSP", oComm.KeyValPairToString(KeyValPair) & param)
                'oDS = DirectCast(oTuple.m_Item1, DataSet)

                ListAllRisk = oDS

            Catch ex As Exception

                ListAllRisk = Nothing
                Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
                ASPNETMsgBox(strMsg)

            End Try

            Return ListAllRisk

        End Function

#End Region

#Region "Symptoms"

        Public Function ListAllSympEmpty(ByVal diagnosisID As Double) As DataSet

            'TODO - JJ: Incomplete method
            ListAllSympEmpty = Nothing

            Try
                Dim oComm As clsCommon = New clsCommon
                Dim oService As EIDSSService = oComm.getService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = "|idfDiag;" & diagnosisID.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                'Dim oTuple = oService.GetData(GetCurrentCountry(), "SymptomSP", oComm.KeyValPairToString(KeyValPair) & param)
                'oDS = DirectCast(oTuple.m_Item1, DataSet)

                ListAllSympEmpty = oDS

            Catch ex As Exception

                ListAllSympEmpty = Nothing
                Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
                ASPNETMsgBox(strMsg)

            End Try

            Return ListAllSympEmpty

        End Function

        Public Function ListAllSymp(ByVal diseaseID As Double) As DataSet

            'TODO - JJ: Incomplete method
            ListAllSymp = Nothing

            Try
                Dim oComm As clsCommon = New clsCommon
                Dim oService As EIDSSService = oComm.getService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = "|idfDiag;" & diseaseID.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                'Dim oTuple = oService.GetData(GetCurrentCountry(), "SymptomSP", oComm.KeyValPairToString(KeyValPair) & param)
                'oDS = DirectCast(oTuple.m_Item1, DataSet)

                ListAllSymp = oDS

            Catch ex As Exception

                ListAllSymp = Nothing
                Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
                ASPNETMsgBox(strMsg)

            End Try

            Return ListAllSymp

        End Function

#End Region

    End Class

End Namespace
