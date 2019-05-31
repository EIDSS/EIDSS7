Imports System.Reflection
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS

Public Class PageFooterUserControl
    Inherits UserControl

#Region "Global Values"

    'Logging
    Private Shared Log = log4net.LogManager.GetLogger(GetType(PageFooterUserControl))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
                lblBuild.Text = GetCurrentBuildNumber()

                If EIDSSAuthenticatedUser.Organization.IsValueNullOrEmpty() = False Then
                    lblOrganization.Text = " " & EIDSSAuthenticatedUser.Organization & "."
                Else
                    lblOrganization.Text = "." 'End the copyright statement with just the period; no organization found.
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

End Class