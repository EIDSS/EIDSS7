Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI

Namespace EIDSS

    Public Class clsBaseReference
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

#Region "Global Values"

        Private Const BASE_REFERENCE_SET_SP As String = "BaseReferenceSet"
        Private Const DISEASE_TYPE_GET_LOOKUP_SP As String = "DiseaseTypeLookup"

#End Region

        'List all records for a given reference type
        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})

                If Not (args Is Nothing) Then
                    Dim strParam As String()
                    For intArgCounter As Integer = 0 To args.Count - 1
                        strParam = args(intArgCounter).ToString().Split(";"c, ":"c)
                        KeyValPair.Add(New clsCommon.Param() With {.ParamName = strParam(0).ToString(), .ParamValue = strParam(1).ToString(), .ParamMode = "IN"})
                    Next
                End If

                Dim oTuple = oService.GetData(GetCurrentCountry(), "BaseReferenceLookup", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception

                ListAll = Nothing
                Throw

            End Try

        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne
            Throw New NotImplementedException()
        End Function

        Public Function AddUpdateBaseReference(ByVal strParams As String, ByRef returnValues As Object) As Int32

            Dim intResult As Int32 = 0

            Try

                oService = oComm.GetService()
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), BASE_REFERENCE_SET_SP, strParams & "|" & oComm.KeyValPairToString(KeyValPair))
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    intResult = oTuple.m_Item1.Tables(0).Rows(0)(0)
                End If

            Catch ex As Exception

                Throw

            End Try

            Return intResult

        End Function

        Public Function SelectCategories() As DataSet

            SelectCategories = Nothing

            Try
                Dim oDS As DataSet

                oService = oComm.GetService()
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "BaseReferenceTypeLookup", oComm.KeyValPairToString(KeyValPair))
                oDS = DirectCast(oTuple.m_Item1, DataSet)
                oDS.CheckDataSet()

                SelectCategories = oDS

            Catch ex As Exception

                SelectCategories = Nothing
                Throw

            End Try

        End Function

        Public Function DiseaseTypeLookup(Optional args() As String = Nothing) As DataSet

            DiseaseTypeLookup = Nothing

            Try
                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})

                If Not (args Is Nothing) Then param = "|" & args(0)

                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), DISEASE_TYPE_GET_LOOKUP_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = DirectCast(oTuple.m_Item1, DataSet)
                oDS.CheckDataSet()

                DiseaseTypeLookup = oDS

            Catch ex As Exception

                DiseaseTypeLookup = Nothing
                Throw

            End Try

        End Function

    End Class

End Namespace
