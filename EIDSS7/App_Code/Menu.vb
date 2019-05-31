Imports System.Text

Namespace EIDSS

    Public Class Menu

        Private strMenuString As New StringBuilder
        Private strCSSClass As String
        Private _objMenuItems As MenuItemCollection

        Public Function ShowMenu() As String
            Return BuildMenu(MenuItems)
        End Function

        Public Function ShowMenu(ByVal pMenuItemCollection As MenuItemCollection) As String
            MenuItems = pMenuItemCollection
            Return BuildMenu(MenuItems)
        End Function

        Public Property MenuItems() As MenuItemCollection
            Get
                Return _objMenuItems
            End Get
            Set(ByVal Value As MenuItemCollection)
                _objMenuItems = Value
            End Set
        End Property

        Private Function BuildMenu(ByVal prmMI As MenuItemCollection) As String
            strMenuString = strMenuString.Clear()

            strMenuString = strMenuString.AppendLine("<table id=""MENUHEADER"" border=""1"" style=""height:1%;""><tr>")
            For intCtr As Integer = 0 To prmMI.Count - 1
                If prmMI.Item(intCtr).LinkDisabled = True Then
                    strMenuString = strMenuString.Append("<td style=""padding:1px 25px 1px 25px;""><a disabled id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></td>")
                Else
                    If Not Me.CSSClass Is Nothing Then
                        If prmMI.Item(intCtr).OpenInNewwindow = True Then
                            strMenuString = strMenuString.Append("<td style=""padding:1px 25px 1px 25px;""><a class=" & Me.CSSClass & " id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='javascript:void(window.open(""" & prmMI.Item(intCtr).LinkTo & "?oin=" & prmMI.Item(intCtr).OpenInNewwindow.ToString() & prmMI.Item(intCtr).QueryString.ToString() & """))' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></td>")
                        Else
                            strMenuString = strMenuString.Append("<td style=""padding:1px 25px 1px 25px;""><a class=" & Me.CSSClass & " id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='" & prmMI.Item(intCtr).LinkTo & "?oin=" & prmMI.Item(intCtr).OpenInNewwindow.ToString() & prmMI.Item(intCtr).QueryString.ToString() & "' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></td>")
                        End If
                    Else
                        If prmMI.Item(intCtr).OpenInNewwindow = True Then
                            strMenuString = strMenuString.Append("<td style=""padding:1px 25px 1px 25px;""><a id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='javascript:void(window.open(""" & prmMI.Item(intCtr).LinkTo & "?oin=" & prmMI.Item(intCtr).OpenInNewwindow.ToString() & prmMI.Item(intCtr).QueryString.ToString() & """))' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></td>")
                        Else
                            strMenuString = strMenuString.Append("<td style=""padding:1px 25px 1px 25px;""><a id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='" & prmMI.Item(intCtr).LinkTo & "?oin=" & prmMI.Item(intCtr).OpenInNewwindow.ToString() & prmMI.Item(intCtr).QueryString.ToString() & "' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></td>")
                        End If
                    End If
                End If
            Next
            strMenuString = strMenuString.AppendLine("</tr></table>")

            Return strMenuString.ToString
        End Function

        Public Property CSSClass() As String

            Get
                Return strCSSClass
            End Get

            Set(ByVal Value As String)
                strCSSClass = Value
            End Set

        End Property

        Public Sub DisableAll(ByVal prmFormMenuItems As MenuItemCollection)

            For Each mi As MenuItem In prmFormMenuItems
                mi.LinkDisabled = True
            Next

        End Sub

    End Class

    Public Class MenuItem

        Private _LinkID, _LinkTo, _LinkText As String, _LinkDisabled As Boolean, strStatusBarText As String, _OpenInNewWindow As Boolean, _QueryString As String

        Property LinkID() As String
            Get
                Return _LinkID.Replace(" ", "_").Replace("/", "_")
            End Get
            Set(ByVal Value As String)
                _LinkID = Value
            End Set
        End Property

        Property LinkTo() As String
            Get
                Return _LinkTo
            End Get
            Set(ByVal Value As String)
                _LinkTo = Value
            End Set
        End Property

        Property LinkText() As String
            Get
                Return _LinkText
            End Get
            Set(ByVal Value As String)
                _LinkText = Value
            End Set
        End Property

        Property LinkDisabled() As Boolean
            Get
                Return _LinkDisabled
            End Get
            Set(ByVal Value As Boolean)
                _LinkDisabled = Value
            End Set
        End Property

        Property StatusBarText() As String
            Get
                Return strStatusBarText
            End Get
            Set(ByVal Value As String)
                strStatusBarText = Value
            End Set
        End Property

        Property OpenInNewwindow() As Boolean
            Get
                Return _OpenInNewWindow
            End Get
            Set(ByVal Value As Boolean)
                _OpenInNewWindow = Value
            End Set
        End Property

        Property QueryString() As String
            Get
                Return _QueryString
            End Get
            Set(ByVal Value As String)
                _QueryString = Value
            End Set
        End Property

        Public Sub New()
            Me.LinkID = ""
            Me.LinkTo = ""
            Me.LinkText = ""
            Me.LinkDisabled = False
            Me.strStatusBarText = ""
            Me.OpenInNewwindow = False
            Me.QueryString = ""
        End Sub

        Sub New(ByVal strLinkID As String, ByVal strLinkTo As String, ByVal strLinkText As String, ByVal blnDisabled As Boolean, ByVal StatusBarText As String, ByVal bOpenInNewWindow As Boolean, Optional sQueryString As String = "")
            Me.LinkID = strLinkID
            Me.LinkTo = strLinkTo
            Me.LinkText = strLinkText
            Me.LinkDisabled = blnDisabled
            Me.StatusBarText = StatusBarText
            Me.OpenInNewwindow = bOpenInNewWindow
            Me.QueryString = sQueryString
        End Sub

    End Class

    Public Class MenuItemCollection

        Inherits CollectionBase

        Sub Add(ByVal mi As MenuItem)
            Me.List.Add(mi)
        End Sub

        Sub Remove(ByVal mi As MenuItem)
            Me.List.Remove(mi)
        End Sub

        Default Property Item(ByVal Index As Integer) As MenuItem
            Get
                Return DirectCast(Me.List.Item(Index), MenuItem)
            End Get
            Set(ByVal Value As MenuItem)
                Me.List.Item(Index) = Value
            End Set
        End Property

    End Class

End Namespace
