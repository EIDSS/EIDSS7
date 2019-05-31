Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS

    Public Class clsPerson
        Implements IEidssEntity

#Region "Global Values"

        Private HUMAN_GET_DETAIL_SP As String = "HumanGetDetail"
        Private HUMAN_GET_DETAIL_EDIT_SP As String = "HumanGetDetailEdit"
        Private HUMAN_GET_LIST_SP As String = "HumanGetList"
        Private HUMAN_SET_SP As String = "HumanSet"
        Private PERSON_DELETE_SP As String = "PersonDelete"
        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

#End Region

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LanguageID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), HUMAN_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
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

                Dim param As String = "|idfHumanActual;" & dblId.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), HUMAN_GET_DETAIL_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS
            Catch ex As Exception
                SelectOne = Nothing
                Throw
            End Try

            Return SelectOne

        End Function

        Public Function SelectForEdit(dblID As Double) As DataSet

            SelectForEdit = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                Dim param As String = "|idfHumanActual;" & dblID.ToString() & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = getConfigValue("DefaultLanguage"), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), HUMAN_GET_DETAIL_EDIT_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectForEdit = oDS
            Catch ex As Exception
                SelectForEdit = Nothing
                Throw
            End Try

            Return SelectForEdit

        End Function

        Public Function AddUpdatePerson(ByVal personValues As String, ByRef oReturnValues As Object) As Int32

            Dim intResult As Int32 = 0

            Try
                oService = oComm.GetService()

                Dim oTuple = oService.GetData(GetCurrentCountry(), HUMAN_SET_SP, personValues)
                Dim oDS As DataSet = oTuple.m_Item1

                If oDS.CheckDataSet() Then
                    oReturnValues = oTuple.m_Item2
                    intResult = oTuple.m_Item1.Tables(0).Rows(0)(0)
                End If
            Catch ex As Exception
                Throw
            End Try

            Return intResult

        End Function

        Public Sub Delete(ByVal id As Double)

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet

                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfPerson", .ParamValue = id, .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), PERSON_DELETE_SP, oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()
            Catch ex As Exception
                Throw
            Finally

            End Try

        End Sub

    End Class

End Namespace
