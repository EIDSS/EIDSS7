Imports System.Data
Imports EIDSS.NG
Imports  System.Web.UI

Namespace EIDSS
    Public Class clsRegion
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing
            Dim oDS As DataSet = Nothing

            Try

                oService = oComm.GetService()

                If Not (args Is Nothing) Then

                    Dim KeyValPair As New List(Of clsCommon.Param)
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@CountryID", .ParamValue = args(0).ToString(), .ParamMode = "IN"})

                    Dim oTuple = oService.GetData(GetCurrentCountry(), "RegionList", oComm.KeyValPairToString(KeyValPair))
                    oDS = oTuple.m_Item1
                    oDS.CheckDataSet()

                End If

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