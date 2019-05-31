Imports System.Data
Imports EIDSS.NG
Imports  System.Web.UI

Namespace EIDSS
    Public Class clsOrgPerson
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not IsNothing(args) Then 'we will get list of all Persons
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@OfficeID", .ParamValue = args(0).ToString().ToInt64, .ParamMode = "IN"})
                End If
                Dim oTuple = oService.GetData(GetCurrentCountry(), "OrganizationPerson", oComm.KeyValPairToString(KeyValPair))
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

    End Class

End Namespace
