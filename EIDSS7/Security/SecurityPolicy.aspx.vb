Imports EIDSS.EIDSS
Imports EIDSS.NG

Public Class SecurityPolicy

    Inherits BaseEidssPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack() Then
            DisplayData()
        End If

    End Sub

    Protected Sub DisplayData()

        Dim oDS As DataSet = Nothing
        Dim oSecurity As EIDSS.clsSecurity = New EIDSS.clsSecurity
        oDS = oSecurity.SecurityPolicyGet(canvasSecurityPolicy)

        Dim sFldName As String = ""
        Dim _PrefixLength As Integer = 3

        oDS = oSecurity.SecurityPolicyGet(canvasSecurityPolicy)
        If Not (oDS Is Nothing) AndAlso oDS.Tables.Count > 0 AndAlso oDS.Tables(0).Rows.Count > 0 Then
            idfSecurityConfiguration.Text = oDS.Tables(0).Rows(0).Item("idfSecurityConfiguration")

            sFldName = txtintPasswordMinimalLength.ID.Substring(_PrefixLength)
            txtintPasswordMinimalLength.Text = oDS.Tables(0).Rows(0).Item(sFldName).ToString().ToInt16()

            sFldName = txtintPasswordHistoryLength.ID.Substring(_PrefixLength)
            txtintPasswordHistoryLength.Text = oDS.Tables(0).Rows(0).Item(sFldName).ToString().ToInt16()

            sFldName = txtintPasswordAge.ID.Substring(_PrefixLength)
            txtintPasswordAge.Text = oDS.Tables(0).Rows(0).Item(sFldName).ToString().ToInt16()

            sFldName = chkintForcePasswordComplexity.ID.Substring(_PrefixLength)
            chkintForcePasswordComplexity.Checked = (oDS.Tables(0).Rows(0).Item(sFldName).ToString().ToInt16() = 1)

            sFldName = txtintAccountTryCount.ID.Substring(_PrefixLength)
            txtintAccountTryCount.Text = oDS.Tables(0).Rows(0).Item(sFldName).ToString().ToInt16()

            sFldName = txtintAccountLockTimeout.ID.Substring(_PrefixLength)
            txtintAccountLockTimeout.Text = oDS.Tables(0).Rows(0).Item(sFldName).ToString().ToInt16()

            sFldName = txtintInactivityTimeout.ID.Substring(_PrefixLength)
            txtintInactivityTimeout.Text = oDS.Tables(0).Rows(0).Item(sFldName).ToString().ToInt16()

        End If

    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click

        Dim KeyValPair As New List(Of clsCommon.Param)
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@ID", .ParamValue = txtintPasswordMinimalLength.Text.ToString().ToInt16(), .ParamMode = "IN"})
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@intPasswordMinimalLength", .ParamValue = txtintPasswordMinimalLength.Text.ToString().ToInt16(), .ParamMode = "IN"})
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@intPasswordHistoryLength", .ParamValue = txtintPasswordHistoryLength.Text.ToString().ToInt16(), .ParamMode = "IN"})
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@intPasswordAge", .ParamValue = txtintPasswordAge.Text.ToString().ToInt16(), .ParamMode = "IN"})
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@intForcePasswordComplexity", .ParamValue = IIf(chkintForcePasswordComplexity.Checked, 1, 0).ParamMode = "IN"})
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@intAccountTryCount", .ParamValue = txtintAccountTryCount.Text.ToString().ToInt16(), .ParamMode = "IN"})
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@intAccountLockTimeout", .ParamValue = txtintAccountLockTimeout.Text.ToString().ToInt16(), .ParamMode = "IN"})
        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@intInactivityTimeout", .ParamValue = txtintInactivityTimeout.Text.ToString().ToInt16(), .ParamMode = "IN"})

        Dim oComm As EIDSS.clsCommon = New EIDSS.clsCommon
        Dim oService As EIDSSService = oComm.getService()
        Dim oDS As DataSet
        Dim oTuple = oService.GetData(GetCurrentCountry(), "SecurityPolicySet", oComm.KeyValPairToString(KeyValPair))
        oDS = oTuple.m_Item1

    End Sub

End Class