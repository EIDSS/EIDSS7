Imports System.Web.UI
Imports System.Data
Imports EIDSS.NG
Imports System
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain
Imports System.Collections.Generic

Namespace EIDSS

    Public Class clsCountry

        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing
            Dim oDS As DataSet = Nothing

            Try

                'Dim oCountryService As CountryServiceClient = New CountryServiceClient()
                'Dim list As List(Of CountryGetLookupModel) = oCountryService.GetCountryList()

                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), "CountryList", GetLanguageParameter())
                oDS = DirectCast(oTuple.m_Item1, DataSet)
                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception

                ListAll = Nothing
                Throw

            End Try

            Return ListAll

        End Function

        'TODO - MD: Rewrite this method
        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne

            Dim oDS As DataSet = ListAll()

            If oDS.CheckDataSet() Then

                Dim oDV As DataView = oDS.Tables(0).DefaultView()
                oDV.RowFilter = "strCountryName = '" + getConfigValue("DefaultCountry") + "'"
                Dim oFilteredDS As DataSet = New DataSet()
                Dim oDT As DataTable = oDV.ToTable()
                oFilteredDS.Tables.Add(oDT)
                oDS = oFilteredDS

            End If

            Return oDS

        End Function

    End Class

End Namespace