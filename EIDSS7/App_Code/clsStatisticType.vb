Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI
Imports System
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports EIDSS.Client.Responses
Imports EIDSS.Client.Enumerations
Imports Newtonsoft.Json

Namespace EIDSS
    Public Class clsStatisticType

        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService
        Private StatisticDataTypeServiceClient As StatisticDataTypeServiceClient

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ' ListAll = Nothing
            Dim dsListAll As New DataSet

            Try
                If StatisticDataTypeServiceClient Is Nothing Then
                    StatisticDataTypeServiceClient = New StatisticDataTypeServiceClient()
                End If

                Dim list As List(Of RefStatisticdatatypeGetListModel) = StatisticDataTypeServiceClient.RefStatisticDataTypeGetList(GetCurrentLanguage()).Result
                dsListAll.Tables.Add(ConvertListToDataTable(list))

            Catch ex As Exception

                dsListAll = Nothing
                Throw

            End Try

            Return dsListAll

        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne
            Throw New NotImplementedException()
        End Function
    End Class

End Namespace

