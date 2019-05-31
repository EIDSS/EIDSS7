Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO
Imports System.Collections.Generic

Namespace EIDSS

    Public Class clsOrganization

        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try

                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty

                If args Is Nothing Then
                    param = GetLanguageParameter()
                Else
                    Dim strParam As String()

                    'Languge is by default part of the framework and should not be sent by caller
                    KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})

                    For intArgCounter As Integer = 0 To args.Count - 1
                        strParam = args(intArgCounter).ToString().Split(";"c, ":"c)
                        KeyValPair.Add(New clsCommon.Param() With {.ParamName = strParam(0).ToString(), .ParamValue = strParam(1).ToString(), .ParamMode = "IN"})
                    Next
                    param = oComm.KeyValPairToString(KeyValPair)

                End If

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim oTuple = oService.GetData(GetCurrentCountry(), "OrganizationList", param)
                oDS = oTuple.m_Item1

                oDS.CheckDataSet()

                ListAll = oDS

            Catch ex As Exception

                Throw

            End Try

            Return ListAll

        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne

            SelectOne = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfOffice", .ParamValue = dblId, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "OrganizationDetail", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

        End Function

        Function AddUpdate(sDataFor As String, sSPVal As String) As Object

            Dim oTuple As Object = Nothing
            oService = oComm.GetService()
            oTuple = oService.GetData(GetCurrentCountry(), sDataFor, sSPVal)
            oService = Nothing

            Return oTuple

        End Function

        Public Sub Delete(ByVal id As Double)

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@idfOffice", .ParamValue = id, .ParamMode = "IN"})

                Dim oTuple = oService.GetData(GetCurrentCountry(), "DeleteOrganization", oComm.KeyValPairToString(KeyValPair))
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

            Catch ex As Exception

                Throw

            Finally

            End Try

        End Sub

    End Class

End Namespace
