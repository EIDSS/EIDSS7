Imports System
Imports System.Data

Namespace EIDSS
    Public Class clsVetAggregate

        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As NG.EIDSSService
        Public Function AddOrUpdate(aggValues As String) As String

            Dim idfVetAgg As String = "0"

            Try

                Dim intResult As Int32 = 0
                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), "AggregateSave", aggValues)
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    Dim oRetVal As Object() = oTuple.m_Item2
                    idfVetAgg = DirectCast(oRetVal(0), String)
                End If

            Catch ex As Exception

                Throw

            End Try

            Return idfVetAgg

        End Function

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll
            Throw New NotImplementedException()
        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne
            Throw New NotImplementedException()
        End Function
    End Class
End Namespace