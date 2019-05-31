Imports System.Web.Script.Services
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SiteAlertsSubscription
    Inherits BaseEidssPage
    Private ReadOnly Log As log4net.ILog
    Private ReadOnly HumanClient As HumanServiceClient
    Private ReadOnly NotificationClient As NotificationServiceClient
    Private ReadOnly CrossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly ConfigurationApiClient As ConfigurationServiceClient
    Private webconfigClient As WebConfigServiceClientSettings
    Private globalSiteDetails As GblSiteGetDetailModel
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Log.Info("Entering Page Load SiteAlertsSubscriptions.aspx")
        Try

            webconfigClient = New WebConfigServiceClientSettings()
            hiddenBaseRoute.Value = webconfigClient.GetEnvironment()
        Catch ex As Exception
            Log.Error("Error On Page Load" & ex.Message)
            Throw ex
        End Try
    End Sub
    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(SiteAlertsSubscription))
            Log.Info("Loading Contructor Classes SiteAlertsSubsription.aspx")
            HumanClient = New HumanServiceClient()
            ConfigurationApiClient = New ConfigurationServiceClient()
            globalSiteDetails = New GblSiteGetDetailModel()
            NotificationClient = New NotificationServiceClient()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
    End Sub


    <System.Web.Services.WebMethod()>
    Public Shared Function LoadSubscriptionAlertTypes(params As String) As String

        Dim Log = log4net.LogManager.GetLogger(GetType(SiteAlertsSubscription))
        Log.Info("Calling Page Method LoadSubscriptionAlertTypes")
        Dim message = String.Empty
        Try
            Dim NotificationClient As NotificationServiceClient
            NotificationClient = New NotificationServiceClient()
            Dim subscriptionnEventTypes = NotificationClient.GetEventSubriptionTypes(GetCurrentLanguage()).Result
            message = Newtonsoft.Json.JsonConvert.SerializeObject(subscriptionnEventTypes)
        Catch ex As Exception
            Log.Error("Error On Page Method LoadSubscriptionAlertTypes" & ex.Message, ex)
        End Try


        Return message

    End Function
End Class