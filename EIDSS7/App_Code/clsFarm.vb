Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS
    Public Class clsFarm
        Implements IEidssEntity

#Region "Global Values"

        Private Const FARM_DEL_SP As String = "FarmDel"
        Private Const FARM_GET_LIST As String = "FarmGetList"
        Private Const FARM_GET_DETAIL As String = "FarmGetDetail"
        Private Const FARM_SET As String = "FarmSet"
        Private Const FARM_HERD_SPECIES_GET_LIST_SP As String = "FarmHerdSpeciesGetList"

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

#End Region

#Region "Select Methods"

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Try
                Dim oComm As clsCommon = New clsCommon
                Dim oService As EIDSSService = oComm.getService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), FARM_GET_LIST, oComm.KeyValPairToString(KeyValPair) & param)
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

                Dim param As String = "|IsRootFarm;True;IN" & "|idfFarmActual;" & dblId & ";IN" & "|idfFarm;NULL;IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), FARM_GET_DETAIL, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function SelectOne(ByVal isRootFarm As Boolean, idfFarmActual As String, idfFarm As String) As DataSet

            SelectOne = Nothing

            Try
                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                Dim param As String = "|IsRootFarm;" & isRootFarm & ";IN" & "|idfFarmActual;" & idfFarmActual & ";IN" & "|idfFarm;" & idfFarm & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), FARM_GET_DETAIL, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectOne = oDS

            Catch ex As Exception

                SelectOne = Nothing
                Throw

            End Try

            Return SelectOne

        End Function

        Public Function SelectForEdit(ByVal isRootFarm As Boolean, idfFarmActual As String, idfFarm As String) As DataSet

            SelectForEdit = Nothing
            Try

                oService = oComm.GetService()

                Dim oDS As DataSet = Nothing
                Dim KeyValPair As New List(Of clsCommon.Param)

                Dim param As String = "|IsRootFarm;" & isRootFarm & ";IN" & "|idfFarmActual;" & idfFarmActual & ";IN" & "|idfFarm;" & idfFarm & ";IN"
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                Dim oTuple = oService.GetData(GetCurrentCountry(), "FarmGetDetailEdit", oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                SelectForEdit = oDS

            Catch ex As Exception

                SelectForEdit = Nothing
                Throw

            End Try

            Return SelectForEdit

        End Function

#End Region

#Region "Add/Update Methods"

        Public Function AddUpdateFarm(ByVal args() As String,
                                      ByVal dtHerds As DataTable,
                                      ByVal dtSpecies As DataTable,
                                      ByRef oReturnValues As Object) As Int32

            Dim intResult As Int32 = 0

            Try

                oService = oComm.GetService()

                Dim param As String = String.Empty
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim strParamHerds As String = "|Herds;Herds;IN;dbo.tlbFarmHerdSpeciesGetListSPType"
                Dim strParamSpecies As String = "|Species;Species;IN;dbo.tlbFarmHerdSpeciesGetListSPType"

                Dim dsStructuredTables As DataSet = New DataSet
                dsStructuredTables.Tables.Add(dtHerds)
                dsStructuredTables.Tables.Add(dtSpecies)

                Dim oTuple = oService.GetDataWithStructuredParams(GetCurrentCountry(), FARM_SET,
                                                                  oComm.KeyValPairToString(KeyValPair) & param &
                                                                  strParamHerds &
                                                                  strParamSpecies,
                                                                  dsStructuredTables)

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

#End Region

#Region "Delete Methods"

        Public Function DeleteFarm(ByVal args() As String,
                                   ByRef strWarningMessage As String) As Int32

            oService = oComm.GetService()
            Dim intResult As Int32 = 0
            Dim strTempWarningMessage As String = Nothing

            Try
                Dim oDS As DataSet = Nothing
                Dim param As String = String.Empty
                Dim KeyValPair As New List(Of clsCommon.Param)

                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), FARM_DEL_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1
                oDS.CheckDataSet()

                If oTuple.m_Item1.Tables(0).Rows.Count > 0 Then
                    intResult = -1

                    For Each dr As DataRow In oTuple.m_Item1.Tables(0).Rows
                        If dr(RecordConstants.RecordCount) > 0 Then
                            If strTempWarningMessage = Nothing Then
                                strTempWarningMessage &= dr(RecordConstants.RecordType).ToString()
                            Else
                                strTempWarningMessage &= ", " & dr(RecordConstants.RecordType).ToString()
                            End If
                        End If
                    Next

                    strWarningMessage = $"Unable to delete this Farm as it contains: " & strTempWarningMessage & ". Please remove those records prior to deletion of this Farm."
                End If

                intResult = oDS.Tables(1).Rows(0)(0)

            Catch ex As Exception

                DeleteFarm = Nothing
                Throw

            End Try

            Return intResult

        End Function

#End Region

#Region "Farm/Herd or Flock/Species Methods"

        Public Function ListAllFarmHerdSpecies(Optional args() As String = Nothing) As DataSet

            ListAllFarmHerdSpecies = Nothing

            Try
                Dim oService As NG.EIDSSService = oComm.GetService()

                Dim oDS As DataSet
                Dim KeyValPair As New List(Of clsCommon.Param)
                Dim param As String = String.Empty
                KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
                If Not (args Is Nothing) Then param = "|" & args(0)

                Dim oTuple = oService.GetData(GetCurrentCountry(), FARM_HERD_SPECIES_GET_LIST_SP, oComm.KeyValPairToString(KeyValPair) & param)
                oDS = oTuple.m_Item1

                ListAllFarmHerdSpecies = oDS
            Catch ex As Exception

                ListAllFarmHerdSpecies = Nothing
                Throw

            End Try

            Return ListAllFarmHerdSpecies

        End Function

#End Region

    End Class

End Namespace
