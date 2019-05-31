Imports System.IO

Namespace EIDSS

    Public Class clsErrorHandler

        'Log an Exception
        Public Sub LogException(exc As Exception, source As String)

            'Get the absolute path to the log file
            Dim dtFormatted As String = ""
            Dim logFile As String = "App_Data/ErrorLog" & ".log"

            dtFormatted = DateTime.Today.ToString("yyyyMMdd")
            logFile = System.Web.HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\ErrorLog" & dtFormatted & ".log"

            'Open the log file for append And write the log
            Dim sw As StreamWriter = New StreamWriter(logFile, True)
            sw.WriteLine("Error Date: {0}", DateTime.Now)


            If Not (exc.InnerException Is Nothing) Then
                sw.Write("Inner Exception Type: ")
                sw.WriteLine(exc.InnerException.GetType().ToString())
                sw.Write("Inner Exception: ")
                sw.WriteLine(exc.InnerException.Message)
                sw.Write("Inner Source: ")
                sw.WriteLine(exc.InnerException.Source)

                If Not (exc.InnerException.StackTrace Is Nothing) Then
                    sw.WriteLine("Inner Stack Trace: ")
                    sw.WriteLine(exc.InnerException.StackTrace)
                End If
            End If

            sw.Write("Exception Type: ")
            sw.WriteLine(exc.GetType().ToString())
            sw.WriteLine("Exception: " + exc.Message)
            sw.WriteLine("Source: " + source)
            sw.WriteLine("Stack Trace: ")

            If Not (exc.StackTrace Is Nothing) Then
                sw.WriteLine(exc.StackTrace)
                sw.WriteLine()
            End If

            sw.Close()

        End Sub

    End Class

End Namespace