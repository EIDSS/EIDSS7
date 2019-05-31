Imports EIDSS.NG
Imports System.Web.UI
Imports System.Data
Imports System

Namespace EIDSS

    Public Class clsEmployeeGroup
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Private Const EMPLOYEE_GROUP_GET_LIST_SP As String = "EmployeeGroupList"
        Private Const EMPLOYEE_GROUP_GET_DETAIL_SP As String = "EmployeeGroupDetail"

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim oTuple = oService.GetData(GetCurrentCountry(), EMPLOYEE_GROUP_GET_LIST_SP, args(0))
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

            SelectOne = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfEmployee", .ParamValue = dblId.ToString(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), EMPLOYEE_GROUP_GET_DETAIL_SP, oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function Save(idfEmployeeGroup As String, idfEmployee As String) As Boolean

            'TODO MD: Modify SP to remove "action" parameter
            Save = True

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = EmployeeGroupConstants.idfEmployeeGroup, .ParamValue = idfEmployeeGroup, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = EmployeeConstants.idfEmployee, .ParamValue = idfEmployee, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "Action", .ParamValue = UserAction.Insert, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "UserGroupSet", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Save = False
                Throw

            End Try

            Return Save

        End Function

        Public Function Delete(idfEmployeeGroup As String, idfEmployee As String) As DataSet

            'TODO MD: Modify SP to remove "action" parameter
            Delete = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = EmployeeGroupConstants.idfEmployeeGroup, .ParamValue = idfEmployeeGroup, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = EmployeeConstants.idfEmployee, .ParamValue = idfEmployee, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "Action", .ParamValue = UserAction.Delete, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "UserGroupSet", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1

                Delete = oDS

            Catch ex As Exception

                Delete = Nothing
                Dim strMsg As String = $"The following error occurred in {System.Reflection.MethodBase.GetCurrentMethod().Name}: { ex.Message }"
                ASPNETMsgBox(strMsg)

            End Try

            Return Delete

        End Function

    End Class

End Namespace


























