Imports EIDSS.EIDSS
Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI
Imports System

Public Class clsAccessoryCodes
    Implements IEidssEntity

    Private oComm As clsCommon = New clsCommon()
    Private oService As EIDSSService

    ''' <summary>
    ''' Get the selected codes for this HACode    
    ''' </summary>
    ''' <param name="intHACode"></param>
    ''' <returns></returns>
    Public Function GetSelected(intHACode As Integer) As DataSet

        GetSelected = Nothing

        Try

            Dim oDS As DataSet = Nothing
            oService = oComm.GetService()

            Dim KeyValPair As New List(Of clsCommon.Param)

            KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangId", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
            KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@HACode", .ParamValue = intHACode, .ParamMode = "IN"})
            Dim oTuple = oService.GetData(GetCurrentCountry(), "AccessoryCodesGetLookup", oComm.KeyValPairToString(KeyValPair))

            oDS = oTuple.m_Item1
            oDS.CheckDataSet()

            'TODO - MD: refactor the code with default view
            ' Delete rows that are not single values.        
            For Each row As DataRow In oDS.Tables(0).Rows
                If row("name").ToString.Contains(",") Then
                    row.Delete()
                End If
            Next

            oDS.AcceptChanges()

            GetSelected = oDS

        Catch ex As Exception

            GetSelected = Nothing
            Throw

        End Try

    End Function

    ''' <summary>
    ''' Get all codes      
    ''' </summary>
    ''' <returns></returns>
    Public Function GetChecklist() As DataSet

        GetChecklist = Nothing

        Try

            Dim oDS As DataSet = Nothing
            oService = oComm.GetService()

            Dim oTuple = oService.GetData(GetCurrentCountry(), "AccessoryCodesGetChecklist", GetLanguageParameter())
            oDS = oTuple.m_Item1
            oDS.CheckDataSet()

            GetChecklist = oDS

        Catch ex As Exception

            GetChecklist = Nothing
            Throw

        End Try

    End Function

    Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll
        Throw New NotImplementedException()
    End Function

    Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne
        Throw New NotImplementedException()
    End Function
End Class
