Imports System

Public Class TextWriter

    Public Sub TextWrite()

    End Sub

    ' strTag: p, h1, h2, i, b etc.
    Public Function CreateHtml(strTag As String _
                               , s As String) As String

        Return "<" & strTag & ">" & s & "</" & strTag & ">"

    End Function

    Public Function Line(s As String) As String

        Return s & "<br />"

    End Function

    ' Create html section
    ' strSection: div, panel, span etc.
    ' strClass: css class
    ' strText: text
    Public Function AddSection(strSection As String _
                               , strClass As String _
                               , strText As String) As String

        Return "<" & strSection & "class=\"" & strClass & " \ ">" & strText & "</" & strSection & ">"

    End Function

End Class
