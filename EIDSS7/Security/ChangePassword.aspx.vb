Public Class ChangePassword

    Inherits BaseEidssPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack() Then
            txtOrganization.Text = Session("Organization")
            txtOrganization.ReadOnly = True
            txtUserName.Text = Session("UserName")
            txtUserName.ReadOnly = True
        End If

    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click

        Dim oSecurity As EIDSS.clsSecurity = New EIDSS.clsSecurity
        Dim intResult As Integer = 0


        intResult = oSecurity.ChangePassword(canvasChangePassword)

        If (intResult = 0) Then
            ASPNETMsgBox("Password was updated.", Session("HomeURL"))
        Else
            ASPNETMsgBox("Failed to update the Password.")
        End If

    End Sub

End Class