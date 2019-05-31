Public Class UrgentNotification
    Inherits BaseEidssPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

#Region "Index Changes"
#Region "Current"

    Protected Sub ddlCurrentCountry_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCurrentCountry.SelectedIndexChanged

    End Sub

    Protected Sub ddlCurrentRegion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCurrentRegion.SelectedIndexChanged

    End Sub

    Protected Sub ddlCurrentRayon_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCurrentRayon.SelectedIndexChanged

    End Sub

    Protected Sub ddlCurrentTownOrVillage_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub
#End Region
#Region "Other"

    Protected Sub ddlOtherCountry_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlOtherCountry.SelectedIndexChanged

    End Sub

    Protected Sub ddlOtherRegion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCurrentRegion.SelectedIndexChanged

    End Sub

    Protected Sub ddlOtherRayon_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCurrentRayon.SelectedIndexChanged

    End Sub

    Protected Sub ddlOtherTownOrVillage_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub
#End Region
#End Region

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)

    End Sub

    ''' <summary>
    ''' This Sub fixes issues that Visual Studio reports as warnings or messages in the error list
    ''' in .Net TextBox doesn't have a valid attribute for min or max, but these attributes are important.
    ''' adding these attributes programmatically removes these messages from the error list and renders them to the client code
    ''' </summary>
    Private Sub AddAttributesToControls()
        txtCurrentLatitude.Attributes.Add("min", "-90")
        txtCurrentLatitude.Attributes.Add("max", "90")
        txtCurrentLongitude.Attributes.Add("min", "-180")
        txtCurrentLongitude.Attributes.Add("max", "180")
        txtOtherLatitude.Attributes.Add("min", "-90")
        txtOtherLatitude.Attributes.Add("max", "90")
        txtOtherLongitude.Attributes.Add("min", "-180")
        txtOtherLongitude.Attributes.Add("max", "180")
    End Sub
End Class