Imports System.Data
Imports EIDSS.NG
Imports OpenEIDSS.Domain

Namespace EIDSS

    Public Class clsSample
        Implements IEidssEntity

#Region "Global Values"

        Private Const SAMPLE_GET_LIST_SP As String = "SampleGetList"
        Private Const SAMPLE_GET_DETAIL_SP As String = "SampleGetDetail"
        Private Const FARM_SAMPLE_GET_LIST_SP As String = "FarmSampleGetList"

        Private oCommon As clsCommon = New clsCommon()
        Private oService As EIDSSService

#End Region

#Region "Select Methods"

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oCommon.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), SAMPLE_GET_LIST_SP, oCommon.KeyValPairToString(KeyValPair) & param)
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
                oService = oCommon.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                Dim param As String = "|idfMaterial;" & dblId.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), SAMPLE_GET_DETAIL_SP, oCommon.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

#Region "Farm Sample Methods"

        Public Function ListAllFarmSamples(Optional args() As String = Nothing) As DataSet

            ListAllFarmSamples = Nothing

            Try
                oService = oCommon.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), FARM_SAMPLE_GET_LIST_SP, oCommon.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAllFarmSamples = oDS

            Catch ex As Exception

                ListAllFarmSamples = Nothing
                Throw

            End Try

            Return ListAllFarmSamples

        End Function

#End Region

#Region "Aliquots"

        Public Function ListAllAliquots(Optional args() As String = Nothing) As DataSet

            ListAllAliquots = Nothing

            Try
                oService = oCommon.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), SAMPLE_GET_LIST_SP, oCommon.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAllAliquots = oDS

            Catch ex As Exception

                ListAllAliquots = Nothing
                Throw

            End Try

            Return ListAllAliquots

        End Function

#End Region

#End Region

#Region "Add/Update Methods"

        Public Function AddUpdateSample(ByVal sampleValues As String) As Int32

            Dim intResult As Int32 = 0

            Try

                oService = oCommon.GetService()

                Dim oTuple = oService.GetData(getConfigValue("CountryCode"), "VectorSampleSet", sampleValues)
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

#End Region

#Region "Human Disease Report Samples"

        Public Function ListAllHDRSamples(Optional args() As String = Nothing) As DataSet

            Dim oDS As DataSet = Nothing
            oService = oCommon.GetService()
            Dim KeyValPair As New List(Of clsCommon.Param)
            Dim param As String = String.Empty

            Try
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumDisSamplesGet", oCommon.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()
            Catch ex As Exception
                oDS = Nothing
                Throw
            End Try

            Return oDS

        End Function

#End Region

    End Class

End Namespace
