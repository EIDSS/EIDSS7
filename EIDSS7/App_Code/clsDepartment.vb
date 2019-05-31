Imports EIDSS.EIDSS
Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI
Imports System

Namespace EIDSS
    Public Class clsDepartment
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                If Not (args Is Nothing) Then
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@OrganizationId", .ParamValue = args(0).ToString(), .ParamMode = "IN"})
                    Dim oTuple = oService.GetData(GetCurrentCountry(), "DepartmentGetLookup", oComm.KeyValPairToString(KeyValPair))
                    oDS = oTuple.m_Item1
                    oDS.CheckDataSet()
                End If

                ListAll = oDS

            Catch ex As Exception

                ListAll = Nothing
                Throw

            End Try

        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne
            Throw New NotImplementedException
        End Function

        Public Function Delete(idfDepartment As String) As DataSet

            Delete = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "ID", .ParamValue = idfDepartment, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "DepartmentDelete", oComm.KeyValPairToString(KeyValPair))
                oDS = DirectCast(oTuple.m_Item1, DataSet)
                oDS.CheckDataSet()

                Delete = oDS

            Catch ex As Exception

                Delete = Nothing
                Throw

            End Try

            Return Delete

        End Function

        Public Function Save(idfDepartment As String _
                             , idfOrganization As String _
                             , name As String _
                             , DefaultName As String _
                             , idfsCountry As String _
                             , aUser As String) As DataSet

            Save = Nothing

            Try

                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = DepartmentConstants.idfDepartment, .ParamValue = idfDepartment, .ParamMode = "IN"})
                ' SP requires idfOrganization, not OrganizationConstants.idfInstituion    
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "idfOrganization", .ParamValue = idfOrganization, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = DepartmentConstants.DefaultName, .ParamValue = DefaultName, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = DepartmentConstants.Name, .ParamValue = name, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = CountryConstants.CountryID, .ParamValue = idfsCountry, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = DepartmentConstants.User, .ParamValue = aUser, .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "Action", .ParamValue = UserAction.Insert, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "DepartmentSet", oComm.KeyValPairToString(KeyValPair))
                oDS = DirectCast(oTuple.m_Item1, DataSet)
                oDS.CheckDataSet()

                Save = oDS

            Catch ex As Exception

                Save = Nothing
                Throw

            End Try

            Return Save

        End Function

    End Class

End Namespace