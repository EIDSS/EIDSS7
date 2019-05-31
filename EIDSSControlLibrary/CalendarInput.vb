Imports System.ComponentModel
Imports System.Globalization
Imports System.Web.UI
Imports System.Web.UI.WebControls

<DefaultProperty("Text"), ToolboxData("<{0}:CalendarInput runat=server></{0}:CalendarInput>")>
Public Class CalendarInput
    Inherits TextBox

    Private ReadOnly _defaultDate As String

    ''' <summary>
    ''' This property is used to define the calendar format (e.g. MM/DD/YYYY)
    ''' </summary>
    ''' <returns></returns>
    Public Property Format As String

    ''' <summary>
    ''' This is the class given to the outer container of the elements rendered by this class.
    ''' If no class is specified, the container will receive a default class of .datepicker
    ''' </summary>
    ''' <returns></returns>
    Public Property ContainerCssClass As String

    ''' <summary>
    ''' This is the default css class used in the container if the Property ContainerCssClass is Empty or Null
    ''' </summary>
    ''' <returns></returns>
    Private Property DefaultCssClass As String = "datepicker"
    Public Property MinDate As String
    Public Property MaxDate As String
    Public Property Locale As String
    Public Property DisabledDates As String
    Public Property DaysOfWeekDisabled As String
    Public Property LinkedPickerID As String
    Public Property UseCurrent As String

    ''' <summary>
    ''' This is the method that renders all the elements to the page.  This method renders a div, two spans and a textbox with appropriate CSS to 
    ''' paint a jQuery calendar on the UI
    ''' </summary>
    ''' <param name="writer"></param>
    Protected Overrides Sub Render(writer As HtmlTextWriter)

        Dim htmlPrefix, htmlSuffix As String

        htmlPrefix = $"<div id=""{ClientID}_Calendar"" class=""{GetContainerCssClass()}"" runat=""server"">"
        htmlSuffix = "<span class=""input-group-addon""><span class=""glyphicon glyphicon-calendar"" aria-hidden=""true""></span></span></div>"

        writer.Write(htmlPrefix)
        MyBase.Render(writer)
        writer.Write(htmlSuffix)

    End Sub

    Protected Overrides Sub OnLoad(e As EventArgs)

        MyBase.OnLoad(e)

        Dim calendarScript As String = "calendarScript" + ClientID

        Registrar.RegisterJavaScriptBlob(Page, calendarScript, WritejQueryCalendar())

    End Sub

    ''' <summary>
    ''' Determines if the ContainerCsssClass is empty and assigns the default value of .datepicker
    ''' </summary>
    ''' <returns></returns>
    Private Function GetContainerCssClass() As String

        If String.IsNullOrEmpty(ContainerCssClass) Then
            Return DefaultCssClass
        ElseIf ContainerCssClass.IndexOf("datepicker") = 0 Then
            Return $"{ContainerCssClass} {DefaultCssClass.Substring(1)}"
        Else
            Return ContainerCssClass
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Public Function WritejQueryCalendar() As String

        Dim sb = New Text.StringBuilder()

        sb.AppendLine("$(document).ready(function() {")
        sb.AppendLine($"wirePicker{ClientID}();")
        sb.AppendLine($"Sys.WebForms.PageRequestManager.getInstance().add_endRequest(wirePicker{ClientID})")
        sb.AppendLine("});")

        sb.AppendLine($"function wirePicker{ClientID}(){" {"}")
        sb.AppendLine($"var id='#" & ClientID & "_Calendar'; ")
        sb.AppendLine($"$(id).datetimepicker({"{"}")

        'Passing the parameters into the datepicker function
        If String.IsNullOrEmpty(UseCurrent) = False Then
            sb.AppendLine("useCurrent: false, ")
        End If

        sb.AppendLine("debug: false, ")

        If String.IsNullOrEmpty(_defaultDate) = False Then
            Dim defaultValue As Date
            If Date.TryParse(_defaultDate, defaultValue) Then
                sb.AppendLine($"defaultDate: '" & defaultValue.ToShortDateString(DateTimeFormatInfo.CurrentInfo.ShortDatePattern.ToUpperInvariant) & "', ")
            End If
        End If

        If String.IsNullOrEmpty(Format) = True Then
            sb.AppendLine($"format: '" & DateTimeFormatInfo.CurrentInfo.ShortDatePattern.ToUpperInvariant & "', ")
        Else
            sb.AppendLine($"format: '" & Format & "', ")
        End If

        If String.IsNullOrEmpty(Locale) = True Then
            sb.AppendLine($"locale: '" & CultureInfo.CurrentCulture.Name & "', ")
        Else
            sb.AppendLine($"locale: '" & Locale & "', ")
        End If

        If String.IsNullOrEmpty(DisabledDates) = False Then
            sb.AppendLine($"disabledDates: '" & DisabledDates & "',")
        End If

        If String.IsNullOrEmpty(DaysOfWeekDisabled) = False Then
            sb.AppendLine($"daysOfWeekDisabled: '" & DaysOfWeekDisabled & "', ")
        End If

        If String.IsNullOrEmpty(MinDate) Then
            sb.AppendLine($"minDate: moment('1900-01-01T00:00:01.196Z'), ")
        Else
            sb.AppendLine($"minDate: '" & MinDate & "', ")
        End If

        If String.IsNullOrEmpty(MaxDate) Then
            sb.AppendLine($"maxDate: moment('2099-12-31T00:00:01.196Z') ")
        Else
            sb.AppendLine($"maxDate: '" & MaxDate & "' ")
        End If

        sb.AppendLine($"{"}"});") 'End of datetimepicker function

        'Triggers the change event from the calendar back to the input control. Should cause ASP.NET validators to fire, as well as, events.
        sb.AppendLine("$(""#" & ClientID & "_Calendar"").on(""dp.change"", function(e) { $('#" & ClientID & "').change(); });")

        'Band-aid fix to allow the arrow keys to function properly.  The author may fix this on future versions of this library.
        sb.AppendLine("$(""#" & ClientID & "_Calendar"").on(""dp.show"", function() { $(this).data(""DateTimePicker"").keyBinds($.fn.datetimepicker.defaults.keyBinds);}).on('dp.hide', function() { $(this).data(""DateTimePicker"").keyBinds({ down: function (widget) { if (!widget) {this.show();} } }); });")

        If String.IsNullOrEmpty(LinkedPickerID) = False Then
            sb.AppendLine("$('#" & ClientID & "_Calendar').datetimepicker();")
            sb.AppendLine("$('#" & LinkedPickerID & "_Calendar').datetimepicker( { useCurrent: false, format: '" & DateTimeFormatInfo.CurrentInfo.ShortDatePattern.ToUpperInvariant & "' });")
            sb.AppendLine("$('#" & ClientID & "_Calendar').on(""dp.change"", function(e) { $('#" & LinkedPickerID & "_Calendar').data(""DateTimePicker"").minDate(e.date); });")
            sb.AppendLine("$('#" & LinkedPickerID & "_Calendar').on(""dp.change"", function(e) { $('#" & ClientID & "_Calendar').data(""DateTimePicker"").maxDate(e.date); });")
        End If

        sb.AppendLine($"{"}"};") 'End of wirepicker function

        Return sb.ToString()

    End Function

End Class