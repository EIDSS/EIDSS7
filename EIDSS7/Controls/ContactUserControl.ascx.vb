Public Class ContactUserControl
    Inherits System.Web.UI.UserControl


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim mydatasource As New List(Of tempData)
        grdContacts.DataSource = mydatasource
        grdContacts.DataBind()
    End Sub

    Protected Sub btnSearchContacts_Click(sender As Object, e As EventArgs)
        Dim dataElement = New tempData()
        dataElement.DateOfBirth = "1/1/2016"
        dataElement.Name = "Joe Dirt"
        dataElement.PersonalId = "123456789"
        dataElement.Rayon = "someplace"

        Dim mydatasource As New List(Of tempData)
        mydatasource.Add(dataElement)

        grdContacts.DataSource = mydatasource
        grdContacts.DataBind()
    End Sub

    Protected Sub grdContacts_RowCommand(sender As Object, e As GridViewCommandEventArgs)

    End Sub

End Class

Public Class tempData
    Public Property Name As String
    Public Property DateOfBirth As String
    Public Property PersonalId As String
    Public Property Rayon As String

End Class