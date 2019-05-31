Imports System.Data
Imports EIDSS.NG
Imports System

Namespace EIDSS

    Public Class clsSampleDisease
        Implements IEidssEntity

#Region "Global Values"

        Private oCommon As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Private Const SAMPLE_DISEASE_GET_LIST_SP As String = "SampleDiseaseGetList"
        Private Const SAMPLE_DISEASE_GET_DETAIL_SP As String = "SampleDiseaseGetDetail"

#End Region

#Region "Get Methods"

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oCommon.GetService()
                Dim ds As DataSet = Nothing
                Dim optionalParameters As New List(Of clsCommon.Param)

                optionalParameters.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not IsNothing(args) Then 'we will get list of all sample types for the disease.
                    optionalParameters.Add(New clsCommon.Param() With {.ParamName = "@SearchidfsDiagnosis", .ParamValue = args(0).ToString().ToInt64, .ParamMode = "IN"})
                End If
                Dim oTuple = oService.GetData(GetCurrentCountry(), SAMPLE_DISEASE_GET_LIST_SP, oCommon.KeyValPairToString(optionalParameters))
                ds = oTuple.m_Item1
                ds.CheckDataSet()

                ListAll = ds
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

                Dim ds As DataSet = Nothing
                Dim optionalParameters As New List(Of clsCommon.Param)

                Dim parameters As String = "|idfMaterialForDisease;" & dblId.ToString() & ";IN"
                optionalParameters.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), SAMPLE_DISEASE_GET_DETAIL_SP, oCommon.KeyValPairToString(optionalParameters) & parameters)
                ds = oTuple.m_Item1
                ds.CheckDataSet()

                SelectOne = ds
            Catch ex As Exception
                SelectOne = Nothing
                Throw
            End Try

            Return SelectOne

        End Function

#End Region

    End Class

End Namespace
