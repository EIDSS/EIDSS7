Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS
    Public Class clsVeterinaryActiveSurveillanceCampaign
        Implements IEidssEntity

#Region "Global Values"

        Private Const CAMPAIGN_TO_SAMPLE_TYPE_GET_LIST_SP As String = "VetActiveSurvCampaignToSampleTypeGetList"
        Private Const CAMPAIGN_SET_SP As String = "VetActiveSurvCampaignSet"
        Private Const CAMPAIGN_DEL_SP As String = "VetActiveSurvCampaignDelete"
        Private Const CAMPAIGN_GET_LIST_SP As String = "VetActiveSurvCampaignGetList"
        Private Const CAMPAIGN_GET_DETAIL_SP As String = "VetActiveSurvCampaignGetDetail"

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

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

                Dim oTuple = oService.GetData(GetCurrentCountry(), CAMPAIGN_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
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

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfCampaign", .ParamValue = dblId, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), CAMPAIGN_GET_DETAIL_SP, oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

#Region "Campaign To Sample Type"

        Public Function ListAllCampaignToSampleType(Optional args() As String = Nothing) As DataSet

            ListAllCampaignToSampleType = Nothing

            Try
                Dim oCommon As clsCommon = New clsCommon
                Dim oService As NG.EIDSSService = oCommon.GetService()

                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oDS As DataSet = Nothing
                Dim oTuple = oService.GetData(getConfigValue("CountryCode"), CAMPAIGN_TO_SAMPLE_TYPE_GET_LIST_SP, oCommon.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet

                ListAllCampaignToSampleType = oDS
            Catch ex As Exception
                ListAllCampaignToSampleType = Nothing
                Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
                ASPNETMsgBox(strMsg)
            End Try

            Return ListAllCampaignToSampleType

        End Function

#End Region

#End Region

#Region "Add/Update Methods"

        Public Function AddUpdateActiveSurveillanceCampaign(ByVal args() As String,
                                                           ByVal dtCampaignToSampleType As DataTable,
                                                           ByRef oReturnValues As Object) As Int32

            Dim intResult As Int32 = 0

            Try
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                oService = oComm.GetService()

                Dim strParamCampaignToSampleType As String = "|SpeciesAndSamples;SpeciesAndSamples;IN;dbo.tlbCampaignToSampleTypeGetListSPType"

                Dim dsStructuredTables As DataSet = New DataSet
                dsStructuredTables.Tables.Add(dtCampaignToSampleType)

                Dim oTuple = oService.GetDataWithStructuredParams(GetCurrentCountry(),
                                                                  CAMPAIGN_SET_SP,
                                                                  oComm.KeyValPairToString(KeyValPair) & param &
                                                                  strParamCampaignToSampleType,
                                                                  dsStructuredTables)

                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    oReturnValues = oTuple.m_Item2
                    intResult = oTuple.m_Item1.Tables(0).Rows(0)(0)
                End If

            Catch ex As Exception

                AddUpdateActiveSurveillanceCampaign = Nothing
                Throw

            End Try

            Return intResult

        End Function

        Public Sub DeleteSession(ByVal SessionId As Double)

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfCampaign", .ParamValue = "null", .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfMonitoringSession", .ParamValue = SessionId, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "VetActiveSurvCmpnSessAssoc", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            Finally

            End Try

        End Sub

#End Region

#Region "Delete Methods"

        Public Sub DeleteCampaign(ByVal id As Double)

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfCampaign", .ParamValue = id, .ParamMode = "IN"})
                'KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), CAMPAIGN_DEL_SP, oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            Finally

            End Try

        End Sub

#End Region

    End Class

End Namespace
