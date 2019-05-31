Public Class TemplateForNewForms
    Inherits BaseEidssPage '  It is very important that the new class Inherits from this class instead of System.Web.UI.Page

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.IsPostBack = False Then
            searchForm.Visible = True
            EnableSearchFormControls(True)
        End If
    End Sub
#End Region

#Region "Control Raised Events 'clicks and  stuff'"
    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnClear.Click
        ' Do something here to clear the search form
        For Each control As Control In Page.Controls
            Dim textBox As TextBox = DirectCast(control, TextBox)
            If textBox IsNot Nothing Then
                textBox.Text = String.Empty
            End If
        Next
    End Sub

    Protected Sub btnSearchList_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearchList.Click
        ' Handle object visibility based on where you are and where you're going.
        searchresults.Visible = True
        btnEditSearch.Visible = True
        EnableSearchFormControls(False)
        ' Export functionality to a private function or sub
        FillGrid()
    End Sub

    Protected Sub addNewRecord_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles addNewRecord.Click
        ' Handle object visibility based on where you are and where you're going.
        searchresults.Visible = False
        btnEditSearch.Visible = False
        searchForm.Visible = False
        idrelevantTothis.Visible = True
        ' Export functionality to a private function or sub
        EnableSearchFormControls(True)
    End Sub

    Protected Sub btnEditSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditSearch.Click
        ' Handle object visibility based on where you are and where you're going.
        btnEditSearch.Visible = False
        searchresults.Visible = False
        ' Export functionality to a private function or sub
        EnableSearchFormControls(True)
    End Sub

#End Region

#Region "Private Subs and Functions"

    Private Sub EnableSearchFormControls(ByVal enabled As Boolean)
        ' loop through controls in search form  and enable the controls
        samplesearchInput.Enabled = enabled
    End Sub

    Private Sub FillGrid()
        Dim test = New List(Of Object)
        gvSearchResults.DataSource = test
        gvSearchResults.DataBind()
    End Sub

#End Region

End Class