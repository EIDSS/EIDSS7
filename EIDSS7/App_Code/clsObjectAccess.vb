Imports System.Data
Imports EIDSS
Imports EIDSS.EIDSS
Imports EIDSS.NG

Namespace EIDSS

    Public Class clsObjectAccess
        Implements IEidssEntity

        Private oComm As clsCommon = New clsCommon()
        Private oService As EIDSSService

        Public Function ListAll(Optional args() As String = Nothing) As DataSet Implements IEidssEntity.ListAll

            ListAll = Nothing

            Dim sEmpId As String = args(0)

            oService = oComm.GetService()

            Dim oDS As DataSet
            Dim KeyValPair As New List(Of clsCommon.Param)

            KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@userID", .ParamValue = sEmpId.ToString(), .ParamMode = "IN"})
            Dim oTuple = oService.GetData(GetCurrentCountry(), "ObjectAccessGetDefaultUserDetail", oComm.KeyValPairToString(KeyValPair))
            oDS = oTuple.m_Item1

            If oDS.CheckDataSet() Then

                'Merge table in dataset
                Dim oOADS As New DataSet
                Dim oOADT As DataTable
                Dim oOADR As DataRow
                Dim sColumns As String() = "idfsObjectType,idfsObjectTypeName,idfsObjectId,CidfObjectAccess,CidfsObjectOperation,CFlag,RidfObjectAccess,RidfsObjectOperation,RFlag,WidfObjectAccess,WidfsObjectOperation,WFlag,DidfObjectAccess,DidfsObjectOperation,DFlag,EidfObjectAccess,EidfsObjectOperation,EFlag,AidfObjectAccess,AidfsObjectOperation,AFlag".Split(",")

                oOADT = New DataTable()
                For Each item As String In sColumns
                    oOADT.Columns.Add(New DataColumn(item.Trim(), Type.GetType("System.String")))
                Next

                Dim fld As String = ""
                For row As Int16 = 0 To oDS.Tables(0).Rows.Count - 1
                    oOADR = oOADT.NewRow()

                    For Each sItem As String In sColumns

                        Select Case sItem.Trim().Substring(0, 1)
                            Case "C"
                                fld = "Create"
                            Case "R"
                                fld = "Read"
                            Case "W"
                                fld = "Write"
                            Case "D"
                                fld = "Delete"
                            Case "E"
                                fld = "Execute"
                            Case "A"
                                fld = "Access To Personal Data"
                            Case Else
                                fld = ""
                        End Select

                        Select Case sItem.Substring(IIf(fld = "", 0, 1))
                            Case "idfObjectAccess"
                                oOADR(sItem) = oDS.Tables(2).Rows(row).Item(fld)
                            Case "idfsObjectOperation"
                                oOADR(sItem) = oDS.Tables(0).Rows(row).Item(fld)
                            Case "Flag"
                                oOADR(sItem) = oDS.Tables(1).Rows(row).Item(fld)
                            Case Else
                                oOADR(sItem) = oDS.Tables(0).Rows(row).Item(sItem)
                        End Select

                    Next
                    oOADT.Rows.Add(oOADR)
                Next

                oOADS.Tables.Add(oOADT)

                ListAll = oOADS

            End If

            Return ListAll

        End Function

        Public Function SelectOne(dblId As Double) As DataSet Implements IEidssEntity.SelectOne
            Throw New NotImplementedException()
        End Function

    End Class

End Namespace

