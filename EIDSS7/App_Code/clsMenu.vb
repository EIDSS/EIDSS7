Imports EIDSS.NG
Imports System.Text

Namespace EIDSS

    Public Class clsMenu

        Private strMenuString As New StringBuilder
        Private strCSSClass As String
        Private _objMenuItems As clsMenuItemCollection

        Public Const StartParentTag As String = "STARTPARENT"
        Public Const CloseParentTag As String = "CLOSEPARENT"

        'Denotes a sub-menu that has child menu items
        Public Const StartChildParentTag As String = "STARTCHILDPARENT"
        Public Const CloseChildParentTag As String = "CLOSECHILDPARENT"

        Private iParentCount As Integer = 0

        Public Function ShowMenu() As String

            Return BuildMenu(MenuItems)

        End Function

        Public Function ShowMenu(ByVal pMenuItemCollection As clsMenuItemCollection) As String

            MenuItems = pMenuItemCollection
            Return BuildMenu(MenuItems)

        End Function

        Public Property MenuItems() As clsMenuItemCollection

            Get
                Return _objMenuItems
            End Get

            Set(ByVal Value As clsMenuItemCollection)
                _objMenuItems = Value
            End Set

        End Property

        Private Function BuildMenu(ByVal prmMI As clsMenuItemCollection) As String

            strMenuString = strMenuString.Clear()

            strMenuString = strMenuString.AppendLine("<ul Class=""nav navbar-nav"">")

            For intCtr As Integer = 0 To prmMI.Count - 1

                If prmMI.Item(intCtr).Parent.ToString().EqualsAny({clsMenu.StartParentTag, clsMenu.StartChildParentTag}) Then
                    iParentCount += 1
                    strMenuString = strMenuString.AppendLine("<li Class=""dropdown"">")
                    strMenuString = strMenuString.AppendLine("<a Class=""dropdown-toggle"" data-toggle=""dropdown"" id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "<span Class=""caret""></span></a>")
                    strMenuString = strMenuString.AppendLine("<ul Class=""dropdown-menu"">")
                Else

                    If prmMI.Item(intCtr).LinkDisabled = True Then
                        strMenuString = strMenuString.AppendLine("<li><a disabled style=""padding: 3px 25px;"" id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></li>")
                    Else
                        If Not Me.CSSClass Is Nothing Then
                            If prmMI.Item(intCtr).OpenInNewwindow = True Then
                                strMenuString = strMenuString.AppendLine("<li><a style=""padding: 3px 25px;"" class=" & Me.CSSClass & " id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='javascript:void(window.open(""" & prmMI.Item(intCtr).LinkTo & """))' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></li>")
                            Else
                                strMenuString = strMenuString.AppendLine("<li><a style=""padding: 3px 25px;"" class=" & Me.CSSClass & " id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='" & prmMI.Item(intCtr).LinkTo & "' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></li>")
                            End If
                        Else
                            If prmMI.Item(intCtr).OpenInNewwindow = True Then
                                strMenuString = strMenuString.AppendLine("<li><a style=""padding: 3px 25px;"" id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='javascript:void(window.open(""" & prmMI.Item(intCtr).LinkTo & """))' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></li>")
                            Else
                                strMenuString = strMenuString.AppendLine("<li><a style=""padding: 3px 25px;"" id=""leftNav_" & prmMI.Item(intCtr).LinkID & """ href='" & prmMI.Item(intCtr).LinkTo & "' onmousemove='javascript:setStatusBarText(""" & prmMI.Item(intCtr).StatusBarText & """);'>" & prmMI.Item(intCtr).LinkText & "</a></li>")
                            End If
                        End If

                    End If

                End If

                Select Case prmMI.Item(intCtr).Parent
                    Case clsMenu.CloseParentTag
                        For iCounter As Integer = 1 To iParentCount
                            strMenuString = strMenuString.AppendLine("</ul>")
                            strMenuString = strMenuString.AppendLine("</li>")
                        Next

                        iParentCount = 0

                    Case clsMenu.CloseChildParentTag
                        strMenuString = strMenuString.AppendLine("</ul>")
                        strMenuString = strMenuString.AppendLine("</li>")

                        iParentCount -= 1
                End Select

            Next

            strMenuString = strMenuString.AppendLine("</ul>")

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

        Public Sub DisableAll(ByVal prmFormMenuItems As clsMenuItemCollection)

            For Each mi As clsMenuItem In prmFormMenuItems
                mi.LinkDisabled = True
            Next

        End Sub

    End Class

    Public Class clsMenuItem

        Private _LinkID, _LinkTo, _LinkText As String, _LinkDisabled As Boolean, strStatusBarText As String, _OpenInNewWindow As Boolean, _QueryString As String, _Parent As String

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

        Property Parent() As String

            Get
                Return _Parent
            End Get

            Set(ByVal Value As String)
                _Parent = Value
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
            Me.Parent = ""

        End Sub

        Sub New(ByVal strLinkID As String, ByVal strLinkTo As String, ByVal strLinkText As String, ByVal blnDisabled As Boolean, ByVal StatusBarText As String, ByVal bOpenInNewWindow As Boolean, Optional strParent As String = "", Optional sQueryString As String = "")

            Me.LinkID = strLinkID
            Me.LinkTo = GetURL(strLinkTo)
            Me.LinkText = strLinkText.ReplaceAll({"(HUMAN)", "(VET)", "ADMINISTRATION-", "(LAB)", "(OMM)"}, {"", "", "", "", ""}, StringComparison.CurrentCultureIgnoreCase)
            Me.LinkDisabled = blnDisabled
            Me.StatusBarText = StatusBarText
            Me.OpenInNewwindow = bOpenInNewWindow
            Me.Parent = strParent
            Me.QueryString = sQueryString

        End Sub

    End Class

    Public Class clsMenuItemCollection
        Inherits CollectionBase

        Sub Add(ByVal mi As clsMenuItem)
            Me.List.Add(mi)
        End Sub

        Sub Remove(ByVal mi As clsMenuItem)
            Me.List.Remove(mi)
        End Sub

        Default Property Item(ByVal Index As Integer) As clsMenuItem

            Get
                Return DirectCast(Me.List.Item(Index), clsMenuItem)
            End Get

            Set(ByVal Value As clsMenuItem)
                Me.List.Item(Index) = Value
            End Set

        End Property

    End Class

End Namespace
