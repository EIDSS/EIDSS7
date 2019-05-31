Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class StorageSchemaUserControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Private Sub FillFreezerDetails()

        'Add the freezer
        'tvFreezerDetails.Nodes.Add()

        'Add any shelves


    End Sub

    Private Sub PopulateTreeView(dtParent As DataTable, parentId As Long, treeNode As TreeNode)
        For Each row As DataRow In dtParent.Rows
            Dim child As New TreeNode() With {
             .Text = row("Name").ToString(),
             .Value = row("Id").ToString()
            }
            If parentId = 0 Then
                tvFreezerDetails.Nodes.Add(child)
                'Dim dtChild As DataTable = Me.GetData("SELECT Id, Name FROM VehicleSubTypes WHERE VehicleTypeId = " + child.Value)
                'PopulateTreeView(dtChild, Integer.Parse(child.Value), child)
            Else
                treeNode.ChildNodes.Add(child)
            End If
        Next
    End Sub

End Class