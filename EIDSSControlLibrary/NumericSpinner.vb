Imports System.ComponentModel
Imports System.Text
Imports System.Web.UI
Imports System.Web.UI.WebControls


<DefaultProperty("Text"), ToolboxData("<{0}:NumericSpinner runat=server></{0}:NumericSpinner>")>
Public Class NumericSpinner
    Inherits TextBox

    Private _minValue As String
    Private _maxValue As String
    Private _integerOnly As Boolean
    Private _onChange As String
    Private _repeatedItem As Boolean

    Public Property IntegerOnly As Boolean
        Get
            Return _integerOnly
        End Get
        Set(value As Boolean)
            _integerOnly = value
        End Set
    End Property

    ''' <summary>
    ''' OnLoad we register jQuery Scripts and CSS files to parent page
    ''' </summary>
    ''' <param name="e"></param>
    Protected Overrides Sub OnLoad(e As EventArgs)
        MyBase.OnLoad(e)
        Dim scriptName As String = "spinner-script"
        ' We only want to register Scripts and CSS once, if the Scripts were previously Registered then skip adding CSS
        Registrar.RegisterJavaScriptFile(Me.Page, Me.GetType(), Registrar.BaseJsFile)
        Registrar.RegisterCssFile(Me.Page, Me.GetType(), Registrar.BaseCssFile)

        If IntegerOnly Then
            Me.Attributes.Add("onkeypress", "isIntegerKey(event)")
            Me.Attributes.Add("onchange", onChange)
        Else
            Me.Attributes.Add("onkeypress", "isNumberKey(event)")
            Me.Attributes.Add("onchange", onChange)
        End If

    End Sub

    Public Property MaxValue As String
        Get

            If IsNumeric(_maxValue) Then
                Return _maxValue
            Else
                If IntegerOnly Then
                    Return Integer.MaxValue
                Else
                    Return Double.MaxValue
                End If
            End If
        End Get
        Set(value As String)
            _maxValue = value
        End Set
    End Property

    Public Property MinValue As String
        Get
            If IsNumeric(_minValue) Then
                Return _minValue
            Else
                If IntegerOnly Then
                    Return Integer.MinValue
                Else
                    Return Double.MinValue
                End If
            End If
        End Get
        Set(value As String)
            _minValue = value
        End Set
    End Property

    Public Property onChange As String
        Get
            Return _onChange
        End Get
        Set(value As String)
            _onChange = value
        End Set
    End Property

    Public Property RepeatedItem As Boolean
        Get
            Return _repeatedItem
        End Get
        Set(value As Boolean)
            _repeatedItem = value
        End Set
    End Property



    ''' <summary>
    ''' Renders HTML to page inserting Divs, buttons and Input
    ''' </summary>
    ''' <param name="writer"></param>
    Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)

        Dim sb As StringBuilder = New StringBuilder()
        Dim prefix As String
        Dim suffix As String
        Dim strOnchangeScript As String = ""

        If (Not onChange Is Nothing) Then
            If (onChange.IndexOf(":")) Then
                strOnchangeScript = onChange.Substring(onChange.IndexOf(":") + 1)
            Else
                strOnchangeScript = onChange
            End If
        End If

        prefix = $"<div class=""input-group spinner"">{vbNewLine}{vbTab}"
        sb.AppendLine($"{vbTab}<div id=""{Me.ClientID}_buttons"" class=""input-group-btn-vertical"" role=""group"">")

        If _repeatedItem Then
            sb.AppendLine($"{vbTab}{vbTab}<button onclick=""spinnerUpClicked_ri(this,'{MaxValue}');{strOnchangeScript}"" class=""btn btn-Default"" type=""button""><i class=""glyphicon glyphicon-triangle-top""></i></button>")
            sb.AppendLine($"{vbTab}{vbTab}<button onclick=""spinnerDownClicked_ri(this,'{MinValue}');{strOnchangeScript}"" class=""btn btn-Default"" type=""button""><i class=""glyphicon glyphicon-triangle-bottom""></i></button>")
        Else
            sb.AppendLine($"{vbTab}{vbTab}<button onclick=""spinnerUpClicked('{Me.ClientID}','{MaxValue}');{strOnchangeScript}"" class=""btn btn-Default"" type=""button""><i class=""glyphicon glyphicon-triangle-top""></i></button>")
            sb.AppendLine($"{vbTab}{vbTab}<button onclick=""spinnerDownClicked('{Me.ClientID}','{MinValue}');{strOnchangeScript}"" class=""btn btn-Default"" type=""button""><i class=""glyphicon glyphicon-triangle-bottom""></i></button>")
        End If

        sb.AppendLine($"{vbTab}</div>")
        sb.AppendLine($"</div>")
        suffix = sb.ToString()

        writer.AddAttribute("onblur", "spinnerBlur('" + Me.ClientID + "','" + MinValue + "','" + MaxValue + "');")
        writer.Write(prefix)
        MyBase.Render(writer)
        writer.Write(suffix)

    End Sub

End Class
