Imports System
Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.WebControls

Namespace EIDSS

    Public Class clsSecurity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ChangePassword(ctrl As WebControl) As Integer

            Dim intResult As Integer = 0

            Try

                oService = oComm.GetService()

                Dim aSP As String()
                aSP = oService.getSPList("ChangePassword")
                Dim sSP As String = aSP(0)

                Dim sValues As String = ""
                sValues = oComm.Gather(ctrl, sSP, 3, True)
                oService.ChangePassword(GetCurrentCountry(), sValues, intResult, 0)

            Catch ex As Exception

                Throw

            End Try

            Return intResult

        End Function

        Public Function SecurityPolicyGet(ctrl As WebControl) As DataSet

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "SecurityPolicyGet", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SecurityPolicyGet = oDS

            Catch ex As Exception

                SecurityPolicyGet = Nothing
                Throw

            End Try

            Return SecurityPolicyGet

        End Function

        Public Function GetUserDetails(dblUserId As String) As DataSet

            GetUserDetails = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@UserId", .ParamValue = dblUserId, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "UserGetDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                GetUserDetails = oDS

            Catch ex As Exception

                GetUserDetails = Nothing
                Throw

            End Try

            Return GetUserDetails

        End Function

    End Class

End Namespace