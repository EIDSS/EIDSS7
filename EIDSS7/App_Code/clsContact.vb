Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI

Namespace EIDSS
    Public Class clsContact
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        '#Region "Global Values"

        '        Private Const BASE_REFERENCE_SET_SP As String = "BaseReferenceSet"
        '        Private Const DISEASE_TYPE_GET_LOOKUP_SP As String = "DiseaseTypeLookup"

        '#End Region

        'List all contacts by idfHumanCase
        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll
            ListAll = Nothing
            Try
                oService = oComm.GetService()
                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})

                If (Not (args Is Nothing)) Then
                    If (args(0).Contains("|")) Then
                        param = "|" & args(0)
                        param = oComm.KeyValPairToString(KeyValPair) & "|" & args(0)

                    Else
                        Dim strParam As String()
                        For intArgCounter As Integer = 0 To args.Count - 1
                            strParam = args(intArgCounter).ToString().Split(";"c, ":"c)
                            KeyValPair.Add(New clsCommon.Param() With {.ParamName = strParam(0).ToString(), .ParamValue = strParam(1).ToString(), .ParamMode = "IN"})
                            param = oComm.KeyValPairToString(KeyValPair)

                        Next

                    End If
                End If

                Dim oTuple = oService.GetData(GetCurrentCountry(), "HumDisContactsGet", param)

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
    End Class
End Namespace
