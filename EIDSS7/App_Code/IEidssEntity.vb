Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI

Namespace EIDSS

    Public Interface IEidssEntity

        Function ListAll(Optional args() As String = Nothing) As DataSet

        Function SelectOne(dblId As Double) As DataSet

    End Interface

End Namespace
