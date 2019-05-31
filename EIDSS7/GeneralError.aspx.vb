Public Class GeneralError
    Inherits BaseEidssPage

    Dim sURL As String
    Public iErrCode As Double = 0


    Private Sub GeneralError_Init(sender As Object, e As EventArgs) Handles Me.Init

        If User.Identity.IsAuthenticated Then
            'ViewStateUserKey = Session.SessionID
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            'Create safe error messages.
            Dim generalErrorMsg As String = "A problem has occurred on this web site. Please try again. If this error continues, please contact support."
            Dim httpErrorMsg As String = "An HTTP error occurred. Page Not found. Please try again."
            Dim unhandledErrorMsg As String = "The error was unhandled by application code."

            'Display safe error message.
            lblFriendlyErrorMsg.Text = generalErrorMsg

            'Determine where error was handled.
            Dim ErrorHandler As String = Request.QueryString("handler")
            If (ErrorHandler Is Nothing) Then
                ErrorHandler = "Error Page"
            End If

            'Get the last error from the server.
            Dim ex As Exception = Server.GetLastError()

            'Get the error number passed as a querystring value.
            Dim errorMsg As String = Request.QueryString("msg")
            Select Case errorMsg
                Case "404"
                    ex = New HttpException(404, httpErrorMsg, ex)
                    lblFriendlyErrorMsg.Text = ex.Message
                Case "500"
                    ex = New HttpException(500, httpErrorMsg, ex)
                    lblFriendlyErrorMsg.Text = ex.Message
            End Select

            'If the exception no longer exists, create a generic exception.
            If (ex Is Nothing) Then
                ex = New Exception(unhandledErrorMsg)
            End If

            'Show error details to only to developer. LOCAL ACCESS ONLY.
            If (Request.IsLocal Or ConfigurationManager.AppSettings("Environment") = "Development") Then
                'Detailed Error Message.
                lblErrorDetailedMsg.Text = ex.Message

                'Show where the error was handled.
                lblErrorHandler.Text = ErrorHandler

                'Show local access details.
                pnlDetailedErrorPanel.Visible = True

                If Not (ex.InnerException Is Nothing) Then
                    lblInnerMessage.Text = ex.GetType().ToString() & "<br/>" & ex.InnerException.Message
                    lblInnerTrace.Text = ex.InnerException.StackTrace
                Else
                    lblInnerMessage.Text = ex.GetType().ToString()
                    If Not (ex.StackTrace Is Nothing) Then
                        lblInnerTrace.Text = ex.StackTrace.ToString().TrimStart()
                    End If
                End If
            End If

            'Log the exception.
            Dim clsErr As New EIDSS.clsErrorHandler
            clsErr.LogException(ex, ErrorHandler)

            'Clear the error from the server.
            Server.ClearError()
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

End Class
