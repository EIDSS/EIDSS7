Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS

Public Class AddUpdateOrganizationUserControl
    Inherits UserControl

#Region "Global Values"

    Public Event ValidatePage()
    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String)
    Public Event ShowErrorModal(messageType As MessageType, message As String)
    Public Event CreateOrganization(organizationID As Long, organizationName As String, eidssOrganizationID As String, message As String)
    Public Event UpdateOrganization(organizationID As Long, organizationName As String, eidssOrganizationID As String, message As String)
    Public Event EditOrganization(organizationID As Long, organizationName As String)

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log As log4net.ILog

#End Region

#Region "Initialize Methods"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

#End Region

    Protected Sub ForeignAddress_CheckedChanged(sender As Object, e As EventArgs)

        If chkForeignAddress.Checked Then
            Location.ShowCountry = True
            Location.ShowRegion = False
            Location.ShowRayon = False
            Location.ShowSettlement = False
            Location.ShowStreet = False
            Location.ShowPostalCode = False
            Location.ShowCoordinates = False
            Location.ShowBuildingHouseApartmentGroup = False
        Else
            Location.ShowRegion = True
            Location.ShowRayon = True
            Location.ShowSettlement = True
            Location.ShowPostalCode = True
            Location.ShowStreet = True
            Location.ShowCoordinates = True
            Location.ShowBuildingHouseApartmentGroup = True
        End If

    End Sub

End Class