Imports System.Data
Imports EIDSS.NG
Imports  System.Web.UI

Namespace EIDSS
    Public Class clsAdminOrganization
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()
                Dim oDS As DataSet

                Dim oTuple = oService.GetData(GetCurrentCountry(), "AdminOrganization", GetLanguageParameter())
                oDS = DirectCast(oTuple.m_Item1, DataSet)
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
