Imports System.Drawing
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class TemplateEditor
    Inherits BaseEidssPage

    Private oCommon As clsCommon = New clsCommon()
    Private CrossCuttingAppService As CrossCuttingServiceClient
    Private FlexibleFormService As FlexibleFormServiceClient
    Private Shared Log As log4net.ILog
    Dim loadMatxrixTable As New Table With {
                .ID = "tblHumanAggerCaseClassification",
                .Width = New Unit("100%"),
                .CellSpacing = 3,
                .CellPadding = 2,
                .HorizontalAlign = HorizontalAlign.Center
            }
    Dim SectionRow As New TableRow With {
            .Height = New Unit(30),
            .BorderStyle = BorderStyle.Solid,
            .BorderWidth = 1,
            .BackColor = Drawing.Color.White
        }
    Dim parameterrow As New TableRow With {
            .Height = New Unit(30),
            .BorderStyle = BorderStyle.Solid,
            .BorderWidth = 1,
            .BackColor = Drawing.Color.White
        }
    Dim parameterControlRow As New TableRow With {
            .Height = New Unit(30),
            .BorderStyle = BorderStyle.Solid,
            .BorderWidth = 1,
            .BackColor = Drawing.Color.White
        }

    Public Property SortDirection() As SortDirection
        Get
            If ViewState("SortDirection") Is Nothing Then
                ViewState("SortDirection") = SortDirection.Ascending
            End If
            Return DirectCast(ViewState("SortDirection"), SortDirection)
        End Get
        Set(ByVal value As SortDirection)
            ViewState("SortDirection") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage
        If Not Page.IsPostBack Then
            BindTreeView()
            TvTempleteEditor.CollapseAll()
        End If
    End Sub

    Private Sub BindTreeView()

        If FlexibleFormService Is Nothing Then
            FlexibleFormService = New FlexibleFormServiceClient()
        End If

        Try
            ' Get FormType Collection List 
            Dim formTypeCollection As List(Of AdminFfFormTypesGetModel) = FlexibleFormService.GET_FF_FormType(GetCurrentLanguage(), Nothing).Result

            If formTypeCollection.Count > 0 Then

                For Each FormTypeRecord As AdminFfFormTypesGetModel In formTypeCollection
                    Dim child As New TreeNode() With {
                        .Text = FormTypeRecord.Name,
                        .Value = FormTypeRecord.idfsFormType,
                        .Target = 0
                    }


                    'Get Form Templates On FormType

                    Dim templateCollection As List(Of AdminFfTemplatesGetModel) = FlexibleFormService.GET_FF_Templates(GetCurrentLanguage(), Nothing, FormTypeRecord.idfsFormType).Result

                    If templateCollection.Count > 0 Then

                        For Each templateRecord As AdminFfTemplatesGetModel In templateCollection
                            Dim childtemplate As New TreeNode() With {
                                .Text = templateRecord.DefaultName,
                                .Value = templateRecord.idfsFormTemplate,
                                .Target = 1
                            }
                            child.ChildNodes.Add(childtemplate)
                        Next


                    End If
                    TvTempleteEditor.Nodes.Add(child)
                Next
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

#Region "FlexForm - RiskFactors"
    ''' <summary>
    ''' </summary>
    ''' <param name="formTemplate"></param>
    ''' <param name="cleanUp">
    '''  If the cleanUp tag is specified, then it means the Clear button is pressed or loading the form for the first time so empty out any web controls. 
    ''' </param>
    Private Sub LoadFlexFormTemplate(formTemplate As Long, Optional cleanUp As Boolean = False)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            'Retrieve the actual template and load that into the DIV tag (running at server). 
            Dim list As List(Of AdminFfParameterTemplateGetModel) = FlexibleFormService.GET_FF_ParameterTemplates(Nothing, formTemplate, GetCurrentLanguage()).Result

            Dim tbl As New Table With {
                    .ID = "tblHumanCaseClassification",
                    .Width = New Unit("100%"),
                    .CellSpacing = 3,
                    .CellPadding = 2
                }

            'Iterate through the data elements to add them to the display DIV tag's inner html
            For Each ParameterTemplateRecord As AdminFfParameterTemplateGetModel In list

                ''Parameter Type will be parsed to get the list of different objects we need to rely on. 
                'Dim FFReferenceTypes As List(Of FfGetReferenceTypesModel) = CrossCuttingAppService.GetFlexibleFormsReferenceTypesAsync(GetCurrentLanguage()).Result
                If Not ParameterTemplateRecord.idfsSection Is Nothing Then

                    'Need a border and Section Name around the field. 
                    ParseSection(ParameterTemplateRecord)
                    Dim tblSectionRetrieved As Table = CType(pnlCaseClassification.FindControl("tblSection" + ParameterTemplateRecord.idfsSection.ToString()), Table)
                    If Not tblSectionRetrieved Is Nothing Then
                        tblSectionRetrieved.Rows.Add(CreateRow(ParameterTemplateRecord))
                    End If
                Else
                    tbl.Rows.Add(CreateRow(ParameterTemplateRecord))
                End If
            Next

            'Creates the last row with 2 buttons within the form.
            'tbl.Rows.Add(CreateFinalRow())
            pnlCaseClassification.Controls.Add(tbl)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Shared Function ExtractParameterID(ByVal value As String) As Long
        'Try
        Dim returnVal As String = String.Empty
        Dim collection As MatchCollection = Regex.Matches(value, "\d+")
        For Each m As Match In collection
            returnVal += m.ToString()
        Next
        Return Long.Parse(returnVal)
        'Catch ex As Exception
        '    Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        '    Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        'End Try
    End Function

    Private Sub UpdateRow(item As AdminFfParameterTemplateGetModel, row As TableRow)
        Try
            'Here we want to iterate through all the controls in the Panel 
            ' and load all the AJAX control extenders on top of the registered controls on the server. 
            ' it was failing initially as - the original control is not registered 
            ' so we had to create teh UpdateRow seperated which will be called after the CreateRow

            'This is good place to add the - Rules / Actions and Required field Validator 
            'Numeric Validator and other Validators. 

            'row.Cells(1).Controls always is the hardcoded value as the all the UI controls are loaded in Cells(1)

            'Load all the Rules here for the Template and iterate through. 
            'If FlexibleFormService Is Nothing Then
            '    FlexibleFormService = New FlexibleFormServiceClient()
            'End If

            'Dim list As List(Of AdminFfRulesGetModel) = FlexibleFormService.GET_FF_Rules(GetCurrentLanguage(), item.idfsFormTemplate).Result

            ''Iterate through the data elements to add them to the display DIV tag's inner html
            'For Each RuleRecord As AdminFfRulesGetModel In list
            '    'Dim tblSectionRetrieved As Table = CType(pnlCaseClassification.FindControl("tblSection" + RuleRecord.idfsSection.ToString()), Table)
            '    'If Not tblSectionRetrieved Is Nothing Then
            '    '    'tblSectionRetrieved.Rows.Add(CreateRow(ParameterTemplateRecord))
            '    'End If
            'Next

            'Load any events on these dropdowns or check boxes to raise any events. 
            For Each control As Control In row.Cells(1).Controls
                Select Case control.ID
                    Case "txtNumberNatural" + item.idfsParameter.ToString()

                    Case "txtString" + item.idfsParameter.ToString()
                        'This must be loaded when rules request them. 
                        Dim txtRequiredFieldValidator As New RequiredFieldValidator With {
                        .ID = "txtreq" + item.idfsParameter.ToString(),
                        .ControlToValidate = "txtString" + item.idfsParameter.ToString(),
                        .Display = ValidatorDisplay.Dynamic,
                        .ErrorMessage = "** Required"
                    }
                        'Commented this out for now. 
                        'row.Cells(1).Controls.Add(txtRequiredFieldValidator)
                        Exit For

                    Case "txtNumberPositive" + item.idfsParameter.ToString()
                    Case "txtDate" + item.idfsParameter.ToString()
                        Dim txtAjaxDate As New AjaxControlToolkit.CalendarExtender With {
                        .ID = "txtAjaxDate" + item.idfsParameter.ToString(),
                        .TargetControlID = "txtDate" + item.idfsParameter.ToString(),
                        .PopupPosition = AjaxControlToolkit.CalendarPosition.BottomRight
                    }
                        'Commented out as this is loading properly. 
                        'row.Cells(1).Controls.Add(txtAjaxDate)
                        Exit For

                    Case "ddlYNU" + item.idfsParameter.ToString()

                    Case "chk" + item.idfsParameter.ToString()

                End Select

                ''Reads recursively throu the string of the ID (3 sets of Information) . 
                'Dim ControlDataTypeAndID As String = control.ID
                'Select Case ControlDataTypeAndID
                '    Case ControlDataTypeAndID.StartsWith("txt")
                '        Dim DataTypeAndID As String = ControlDataTypeAndID.TrimStart("txt")
                '        Select Case DataTypeAndID
                '            Case DataTypeAndID.StartsWith("NumberNatural")
                '                'Do Something
                '            Case DataTypeAndID.StartsWith("NumberPositive")
                '                'Do Something
                '            Case DataTypeAndID.StartsWith("String")
                '                'Do Something 
                '                'This must be loaded when rules request them. 
                '                Dim txtRequiredFieldValidator As New RequiredFieldValidator With {
                '                    .ID = "txtreq" + item.idfsParameter.ToString(),
                '                    .ControlToValidate = "txtString" + item.idfsParameter.ToString(),
                '                    .Display = ValidatorDisplay.Dynamic,
                '                    .ErrorMessage = "** Required"
                '                }
                '                'Commented this out for now. 
                '                'row.Cells(1).Controls.Add(txtRequiredFieldValidator)
                '                Exit For
                '            Case DataTypeAndID.StartsWith("Date")
                '                Dim txtAjaxDate As New AjaxControlToolkit.CalendarExtender With {
                '                    .ID = "txtAjaxDate" + item.idfsParameter.ToString(),
                '                    .TargetControlID = "txtDate" + item.idfsParameter.ToString(),
                '                    .PopupPosition = AjaxControlToolkit.CalendarPosition.BottomRight
                '                }
                '                'Commented out as this is loading properly. 
                '                'row.Cells(1).Controls.Add(txtAjaxDate)
                '                Exit For
                '            Case Else
                '                'Do something

                '        End Select
                '    Case ControlDataTypeAndID.StartsWith("ddl")
                '        Dim DataTypeAndID As String = ControlDataTypeAndID.TrimStart("ddl")
                '        Select Case DataTypeAndID
                '            Case DataTypeAndID.StartsWith("YNU")
                '                'Do Something
                '        End Select
                '    Case ControlDataTypeAndID.StartsWith("chk")
                '        'Do Something
                '    Case Else
                '        'Do something
                'End Select
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Function CreateRow(item As AdminFfParameterTemplateGetModel, Optional cleanUp As Boolean = False) As TableRow
        Try


            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim row As New TableRow
            row.Height = New Unit(50)

            Dim cellcheckbox As New TableCell

            'Label cell will fill with the text needed. 
            cellcheckbox.Width = New Unit("10%")
            cellcheckbox.CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12"

            Dim childCheckbox As New CheckBox
            childCheckbox.ID = "chk_" + item.idfsParameter.ToString()
            childCheckbox.CssClass = "customcheckbox"
            childCheckbox.Attributes.Add("name", item.idfsParameter.ToString())

            cellcheckbox.Controls.Add(childCheckbox)
            cellcheckbox.HorizontalAlign = HorizontalAlign.Left
            row.Cells.Add(cellcheckbox)

            Dim cell1 As New TableCell

            'Label cell will fill with the text needed. 
            cell1.Width = New Unit("40%")
            cell1.CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12"
            Dim childLabel As New Label
            childLabel.ID = "lbl" + item.idfsParameter.ToString()
            childLabel.Text = item.DefaultName
            cell1.Controls.Add(childLabel)
            cell1.HorizontalAlign = HorizontalAlign.Left
            row.Cells.Add(cell1)

            'Retrieve the actual template and load that into the DIV tag (running at server). 
            Dim ParameterList As List(Of AdminFfParametersGetModel) = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), item.idfsSection, item.idfsFormType).Result

            Dim parameterType As String = String.Empty
            For Each parameterItem As AdminFfParametersGetModel In ParameterList
                If parameterItem.idfsParameter = item.idfsParameter Then
                    parameterType = parameterItem.ParameterTypeName
                    'Exit For
                End If
            Next

            Dim cell2 As New TableCell With {
                        .Width = New Unit("50%"),
                        .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12"
                    }

            Select Case parameterType
                Case "Numeric Natural"

                    Dim textNumber As New TextBox With {
                                .ID = "txtNumberNatural" + item.idfsParameter.ToString(),
                                .Width = 200,
                                .CssClass = "form-control"
                            }

                    If cleanUp Then
                        textNumber.Text = String.Empty
                    End If

                    cell2.Controls.Add(textNumber)

                Case "Y_N_Unk"

                    Dim childDropDownList As New DropDownList With {
                                .ID = "ddlYNU" + item.idfsParameter.ToString(),
                                .Width = 250,
                                .CssClass = "form-control"
                            }

                    'Call the API to load the Dropdown list. 
                    Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                    childDropDownList.DataSource = dropDownList
                    childDropDownList.DataTextField = "strValueCaption"
                    childDropDownList.DataValueField = "idfsValue"
                    childDropDownList.DataBind()
                    childDropDownList.Items.Insert(0, "")

                    If cleanUp Then
                        childDropDownList.SelectedIndex = 0
                    End If

                    cell2.Controls.Add(childDropDownList)

                Case "Boolean"

                    Dim chkBoxItem As New CheckBox With {
                                .ID = "chk" + item.idfsParameter.ToString(),
                                .CssClass = "form-control"
                            }

                    If cleanUp Then
                        chkBoxItem.Checked = False
                    End If

                    cell2.Controls.Add(chkBoxItem)

                Case "String"

                    Dim textString As New TextBox With {
                                .ID = "txtString" + item.idfsParameter.ToString(),
                                .Width = 200,
                                .CssClass = "form-control"
                            }

                    If cleanUp Then
                        textString.Text = String.Empty
                    End If

                    cell2.Controls.Add(textString)

                Case "Numeric Positive"

                    Dim textNumber As New TextBox With {
                                .ID = "txtNumberPositive" + item.idfsParameter.ToString(),
                                .Width = 200,
                                .CssClass = "form-control"
                            }

                    If cleanUp Then
                        textNumber.Text = String.Empty
                    End If

                    cell2.Controls.Add(textNumber)

                Case "Date"

                    Dim textDate As New EIDSSControlLibrary.CalendarInput With {
                                    .ID = "txtDate" + item.idfsParameter.ToString(),
                                    .ContainerCssClass = "input-group datepicker",
                                    .CssClass = "form-control"
                                }
                    '<eidss:CalendarInput ContainerCssClass = "input-group datepicker" ID="txtdatNotificationDate" runat="server" CssClass="form-control"></eidss: CalendarInput>
                    If cleanUp Then
                        textDate.Text = String.Empty
                    End If

                    cell2.Controls.Add(textDate)

                Case Else
                    Dim childDropDownList As New DropDownList With {
                                .ID = "ddlParam" + item.idfsParameter.ToString(),
                                .Width = 250,
                                .CssClass = "form-control"
                            }

                    '' Here is where we link the dropdowns with the Parameter FIxed pre-set / Reference type values. 
                    'Call the API to load the Dropdown list. 
                    Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                    childDropDownList.DataSource = dropDownList
                    childDropDownList.DataTextField = "strValueCaption"
                    childDropDownList.DataValueField = "idfsValue"
                    childDropDownList.DataBind()
                    childDropDownList.Items.Insert(0, "")

                    If cleanUp Then
                        childDropDownList.SelectedIndex = 0
                    End If

                    cell2.Controls.Add(childDropDownList)
            End Select
            row.Cells.Add(cell2)
            UpdateRow(item, row)
            Return row
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Sub ParseSection(item As AdminFfParameterTemplateGetModel)
        Try
            Dim sectionCollection As List(Of AdminFfParentSectionsGetModel) = FlexibleFormService.GET_FF_ParentSections(GetCurrentLanguage(), item.idfsSection).Result

            'Iterate through the data elements to add them to the display DIV tag's inner html
            Dim iterationCount As Integer = 0
            Dim verifTable As String = Nothing
            For Each sectionRecord As AdminFfParentSectionsGetModel In sectionCollection
                'Now we are within each iteration row record.
                'First record should always be inserted if not already preset on the page. 
                If iterationCount = 0 Then
                    ' We are at the first record, so store the Verif table ID for the subsequent inserts for the sections. 
                    'Changing iterationCount to 1 so it doesn't go into the loop anymore. 
                    iterationCount = 1
                    If ValidateSection(sectionRecord.SectionID) Then
                        InsertSection(sectionRecord.SectionID, sectionRecord.SectionName)
                    End If
                    verifTable = "tblSection" + sectionRecord.SectionID.ToString()
                Else
                    'The main section exists already, Now need to insert the child sections. 
                    If ValidateSection(sectionRecord.SectionID) Then
                        InsertSection(sectionRecord.SectionID, sectionRecord.SectionName, verifTable)
                    End If
                    verifTable = "tblSection" + sectionRecord.SectionID.ToString()
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Function ValidateSection(sectionID As Long) As Boolean
        Try
            Dim convertedTable As Table = CType(pnlCaseClassification.FindControl("tblSection" + sectionID.ToString()), Table)
            If convertedTable Is Nothing Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Function

    Private Sub InsertSection(sectionID As Long, sectionName As String, Optional verifTableID As String = Nothing)
        Try
            ' No Table was found, so create a new one. 
            ' And add a header row. 

            Dim tblSection As New Table With {
            .ID = "tblSection" + sectionID.ToString(),
            .Height = New Unit("100%"),
            .BorderWidth = New Unit(1),
            .BorderStyle = BorderStyle.None,
            .BackColor = Drawing.Color.White,
            .CellSpacing = 3,
            .CellPadding = 2
        }

            If verifTableID Is Nothing Then
                tblSection.Width = New Unit("100%")
            Else
                tblSection.Width = New Unit("96%")
                tblSection.HorizontalAlign = HorizontalAlign.Right
            End If

            Dim headerRow As New TableRow With {
            .Height = New Unit(30),
            .BorderStyle = BorderStyle.None,
            .BackColor = Drawing.Color.White
        }

            'Label cell will fill with the text needed. 
            Dim headerCell As New TableCell With {
            .ColumnSpan = 3,
            .Width = New Unit("100%"),
            .HorizontalAlign = HorizontalAlign.Left,
            .CssClass = "flex-form-header"
        }

            Dim headerLabel As New Label With {
            .ID = "lblHeader" + sectionID.ToString(),
            .Text = sectionName
        }

            headerCell.Controls.Add(headerLabel)
            headerRow.Cells.Add(headerCell)
            tblSection.Rows.Add(headerRow)

            Dim pnlSection As New Panel With {
            .ID = "pnlSection" + sectionID.ToString(),
            .BorderStyle = BorderStyle.None,
            .BackColor = Drawing.Color.White,
            .Width = New Unit("100%"),
            .HorizontalAlign = HorizontalAlign.Center
        }

            pnlSection.Controls.Add(tblSection)

            'Only enter inside if the verifTableID is not nothing. If nothing, don't bother and insert to the PanelCaseClassification 
            If Not verifTableID Is Nothing Then
                Dim verifTable As Table = CType(pnlCaseClassification.FindControl(verifTableID), Table)
                If Not verifTable Is Nothing Then
                    Dim row As New TableRow
                    row.Height = New Unit(50)
                    Dim cell1 As New TableCell

                    'Label cell will fill with the text needed. 
                    cell1.Width = New Unit("100%")
                    cell1.ColumnSpan = 3
                    cell1.Controls.Add(pnlSection)
                    row.Cells.Add(cell1)
                    verifTable.Rows.Add(row)
                End If
            Else
                pnlCaseClassification.Controls.Add(pnlSection)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

#End Region

#Region "Events"

    'Save method should be edited out of the USer Control as to give the user the flexibility of allowing 
    'the save to be consistent with data integrity of the record

    Public Sub EnableControls(value As Boolean)
        Try
            Dim cls As New clsCommon
            Dim allCtrl As New List(Of Control)
            allCtrl.Clear()
            'Iterate through all DropdownLists. 
            For Each ddl As WebControls.DropDownList In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.DropDownList))
                ddl.Enabled = value
            Next
            allCtrl.Clear()
            'Iterate through all Date controls. 
            For Each txtDT As EIDSSControlLibrary.CalendarInput In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(EIDSSControlLibrary.CalendarInput))
                txtDT.Enabled = value
            Next

            allCtrl.Clear()
            'Iterate through all check Boxes. 
            For Each chk As WebControls.CheckBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.CheckBox))
                chk.Enabled = value
            Next

            allCtrl.Clear()
            'Iterate through all text boxes. 
            For Each txt As WebControls.TextBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.TextBox))
                txt.Enabled = value
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub TvTempleteEditor_SelectedNodeChanged(sender As Object, e As EventArgs)
        Try
            btnDeleteparameter.Visible = False
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If
            If TvTempleteEditor.SelectedNode.Target = 1 Then
                divTemplete.Visible = True
                If Not TvTempleteEditor.SelectedNode.Parent.Value Is Nothing Then
                    Dim formTypeCollection As List(Of AdminFfFormTypesGetModel) = FlexibleFormService.GET_FF_FormType(GetCurrentLanguage(), TvTempleteEditor.SelectedNode.Parent.Value).Result

                    For Each formTypeRecord As AdminFfFormTypesGetModel In formTypeCollection
                        If formTypeRecord.idfsMatrixType Is Nothing Then
                            LoadFlexFormTemplate(TvTempleteEditor.SelectedNode.Value)
                            btnDeleteparameter.Visible = True
                        Else
                            LoadFlexFormMatrix(TvTempleteEditor.SelectedNode.Value)
                        End If
                    Next
                Else
                    divTemplete.Visible = False
                End If
            Else
                divTemplete.Visible = False

            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnEditTemplate_Click(sender As Object, e As EventArgs)
        'UpdatePanel1.Update()
        ClearControls()
        hdgEditTemplate.Visible = False
        hdgAddTemplate.Visible = False
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim templateCollection As List(Of AdminFfTemplatesGetModel) = FlexibleFormService.GET_FF_Templates(GetCurrentLanguage(), TvTempleteEditor.SelectedNode.Value, Nothing).Result

            If templateCollection.Count > 0 Then
                Dim templateRecord As AdminFfTemplatesGetModel = templateCollection.FirstOrDefault()

                txtDefaultName.Text = templateRecord.DefaultName
                txtNationalName.Text = templateRecord.NationalName
                txtNote.Text = templateRecord.strNote
                chkIsUniTemplate.Checked = templateRecord.blnUNI
                hdfFormType.Value = templateRecord.idfsFormType
                hdfFormTemplate.Value = templateRecord.idfsFormTemplate
                hdgEditTemplate.Visible = True
                'ScriptManager.RegisterStartupScript(Me.Page, Page.GetType, "text", "OpenPopUp()", True)
                mpe.Show()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnaddTemplate_Click(sender As Object, e As EventArgs)
        ClearControls()
        hdgEditTemplate.Visible = False
        hdgAddTemplate.Visible = False
        Try
            mpe.Show()
            hdgAddTemplate.Visible = True
            'ScriptManager.RegisterStartupScript(Me.Page, Page.GetType, "text", "OpenPopUp()", True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            If hdfFormTemplate.Value <> "" Then

                Dim adminFfTemplateSetParams As New AdminFfTemplateSetParams With
                    {
                        .idfsFormTemplate = hdfFormTemplate.Value,
                        .idfsFormType = hdfFormType.Value,
                        .langId = GetCurrentLanguage(),
                        .defaultName = txtDefaultName.Text,
                        .nationalName = txtNationalName.Text,
                        .blnUni = chkIsUniTemplate.Checked,
                        .strNote = txtNote.Text
                    }

                Dim adminFfTemplateSetParamsCollection As List(Of AdminFfTemplateSetModel) = FlexibleFormService.SET_FF_TEMPLATE(adminFfTemplateSetParams).Result
                BindTreeView()
            Else

                Dim FormType As Long? = 0

                If (TvTempleteEditor.SelectedNode.Parent Is Nothing) Then
                    FormType = TvTempleteEditor.SelectedNode.Value
                Else
                    FormType = TvTempleteEditor.SelectedNode.Parent.Value
                End If

                Dim adminFfTemplateSetParams As New AdminFfTemplateSetParams With
                    {
                        .idfsFormType = FormType,
                        .langId = GetCurrentLanguage(),
                        .defaultName = txtDefaultName.Text,
                        .nationalName = txtNationalName.Text,
                        .blnUni = chkIsUniTemplate.Checked,
                        .strNote = txtNote.Text
                    }

                Dim adminFfTemplateSetParamsCollection As List(Of AdminFfTemplateSetModel) = FlexibleFormService.SET_FF_TEMPLATE(adminFfTemplateSetParams).Result
                BindTreeView()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnDeleteTemplate_Click(sender As Object, e As EventArgs)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim adminFfTemplateSetParamsCollection As List(Of AdminFfTemplateDelModel) = FlexibleFormService.DEL_FF_TEMPLATE(Convert.ToInt64(TvTempleteEditor.SelectedNode.Value)).Result

            BindTreeView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Public Sub ClearControls()
        Try
            txtDefaultName.Text = ""
            txtNationalName.Text = ""
            chkIsUniTemplate.Checked = False
            txtNote.Text = ""
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnClose_Click(sender As Object, e As EventArgs)
        ClearControls()
    End Sub
#End Region
#Region "FlexForm - Matrix"
    Private Sub LoadFlexFormMatrix(formTemplate As Long)
        Try

            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            'Retrieve the actual template and load that into the DIV tag (running at server). 
            Dim list As List(Of AdminFfParameterTemplateGetModel) = FlexibleFormService.GET_FF_ParameterTemplates(Nothing, formTemplate, GetCurrentLanguage()).Result

            'Iterate through the data elements to add them to the display DIV tag's inner html
            For Each ParameterTemplateRecord As AdminFfParameterTemplateGetModel In list

                ''Parameter Type will be parsed to get the list of different objects we need to rely on. 
                'Dim FFReferenceTypes As List(Of FfGetReferenceTypesModel) = CrossCuttingAppService.GetFlexibleFormsReferenceTypesAsync(GetCurrentLanguage()).Result
                If Not ParameterTemplateRecord.idfsSection Is Nothing Then

                    'Need a border and Section Name around the field. 
                    MatrixParseSection(ParameterTemplateRecord)
                    Dim tblSectionRetrieved As TableCell = CType(pnlCaseClassification.FindControl("cellSection" + ParameterTemplateRecord.idfsSection.ToString()), TableCell)
                    If Not tblSectionRetrieved Is Nothing Then
                        CreateSectionParameterColumn(ParameterTemplateRecord)
                        CreateParameterColumn(ParameterTemplateRecord)
                    Else
                        CreateOnlyparameterColumn(ParameterTemplateRecord)
                        CreateParameterColumn(ParameterTemplateRecord)
                    End If
                Else

                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub MatrixParseSection(item As AdminFfParameterTemplateGetModel)
        Try
            Dim sectionCollection As List(Of AdminFfParentSectionsGetModel) = FlexibleFormService.GET_FF_ParentSections(GetCurrentLanguage(), item.idfsSection).Result

            'Iterate through the data elements to add them to the display DIV tag's inner html
            Dim iterationCount As Integer = 0
            Dim verifTable As String = Nothing

            For Each sectionRecord As AdminFfParentSectionsGetModel In sectionCollection
                'Now we are within each iteration row record.
                'First record should always be inserted if not already preset on the page. 
                If iterationCount = 0 Then
                    ' We are at the first record, so store the Verif table ID for the subsequent inserts for the sections. 
                    'Changing iterationCount to 1 so it doesn't go into the loop anymore. 
                    iterationCount = 1

                    verifTable = "cellSection" + sectionRecord.SectionID.ToString()
                Else
                    'The main section exists already, Now need to insert the child sections. 
                    If MatrixValidateSection(sectionRecord.SectionID) Then
                        'InsertSection(sectionRecord.SectionID, sectionRecord.SectionName, verifTable)
                        CreateSeactionColumn(sectionRecord.SectionID, sectionRecord.SectionName, verifTable)
                    End If
                    verifTable = "cellSection" + sectionRecord.SectionID.ToString()
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Function MatrixValidateSection(sectionID As Long) As Boolean
        Dim convertedTable As TableCell = CType(SectionRow.FindControl("cellSection" + sectionID.ToString()), TableCell)
        If convertedTable Is Nothing Then
            Return True
        Else
            Return False
        End If
    End Function

    Public Sub CreateSeactionColumn(sectionID As Long, sectionName As String, Optional verifTableID As String = Nothing)
        Try
            Dim FindCell = SectionRow.FindControl("cellSection" + sectionID.ToString())

            Dim countparameter = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), sectionID, Nothing).Result.Count

            'Dim Color As Color = CType(ColorConverter.ConvertFromString("#FFDFD991"), Color)

            If FindCell Is Nothing Then
                Dim cell1 As New TableHeaderCell With
                {
                    .ID = "cellSection" + sectionID.ToString(),
                    .BorderWidth = 2,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Color.Gray,
                    .ColumnSpan = countparameter,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .Width = New Unit("100%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                    .BackColor = ColorTranslator.FromHtml("#2d5b83"),
                    .ForeColor = Color.White
                }


                Dim headerLabel As New Label With {
            .ID = "lblHeader" + sectionID.ToString(),
            .Text = sectionName
        }
                cell1.Controls.Add(headerLabel)
                SectionRow.Cells.Add(cell1)
                loadMatxrixTable.Rows.Add(SectionRow)
                pnlCaseClassification.Controls.Add(loadMatxrixTable)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Public Sub CreateOnlyparameterColumn(item As AdminFfParameterTemplateGetModel)
        Try
            Dim cell1 As New TableHeaderCell With
            {
                .ID = "cellSection" + item.idfsParameter.ToString(),
                .BorderWidth = 2,
                .BorderStyle = BorderStyle.Solid,
                .BorderColor = Drawing.Color.Gray,
                .ColumnSpan = 1,
                .HorizontalAlign = HorizontalAlign.Center,
                .Width = New Unit("100%"),
                .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                .BackColor = ColorTranslator.FromHtml("#2d5b83"),
                .ForeColor = Drawing.Color.White
            }
            Dim headerLabel As New Label With {
            .ID = "lblHeader" + item.idfsParameter.ToString(),
            .Text = item.DefaultName
        }


            Dim cell2 As New TableHeaderCell With
            {
                .BorderWidth = 2,
                .BorderStyle = BorderStyle.Solid,
                .BorderColor = Drawing.Color.Gray,
                .ColumnSpan = 1,
                .HorizontalAlign = HorizontalAlign.Center,
                .Width = New Unit("100%"),
                .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12"
            }
            Dim headerLabel1 As New Label With {
            .Text = "            "
        }

            cell1.Controls.Add(headerLabel)
            SectionRow.Cells.Add(cell1)
            loadMatxrixTable.Rows.Add(SectionRow)

            cell2.Controls.Add(headerLabel1)
            parameterrow.Cells.Add(cell2)
            loadMatxrixTable.Rows.Add(parameterrow)

            pnlCaseClassification.Controls.Add(loadMatxrixTable)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Public Sub CreateSectionParameterColumn(item As AdminFfParameterTemplateGetModel)
        Try
            Dim FindCell = parameterrow.FindControl("cellSection" + item.idfsParameter.ToString())

            If FindCell Is Nothing Then
                Dim cell1 As New TableHeaderCell With
                {
                    .ID = "cellSection" + item.idfsParameter.ToString(),
                    .BorderWidth = 2,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Drawing.Color.Gray,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .Width = New Unit("100%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                    .ColumnSpan = 1
                }

                Dim headerLabel As New Label With {
            .ID = "lblHeader" + item.idfsParameter.ToString(),
            .Text = item.DefaultName
        }
                cell1.Controls.Add(headerLabel)
                parameterrow.Cells.Add(cell1)
                loadMatxrixTable.Rows.Add(parameterrow)
                pnlCaseClassification.Controls.Add(loadMatxrixTable)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Public Sub CreateParameterColumn(item As AdminFfParameterTemplateGetModel)
        Try

            Dim ParameterList As List(Of AdminFfParametersGetModel) = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), item.idfsSection, item.idfsFormType).Result

            Dim parameterType As String = String.Empty
            For Each parameterItem As AdminFfParametersGetModel In ParameterList
                If parameterItem.idfsParameter = item.idfsParameter Then
                    parameterType = parameterItem.ParameterTypeName
                    'Exit For
                End If
            Next
            Dim cell2 As New TableCell With
            {
                    .Width = New Unit("60%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12",
                    .BorderWidth = 2,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Drawing.Color.Gray,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .ColumnSpan = 1,
                    .RowSpan = 1
            }

            Select Case parameterType
                Case "Numeric Natural"

                    Dim textNumber As New TextBox With {
                    .ID = "txtNumberNatural" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(textNumber)

                Case "Y_N_Unk"

                    Dim childDropDownList As New DropDownList With {
                    .ID = "ddlYNU" + item.idfsParameter.ToString(),
                    .Width = 250,
                    .CssClass = "form-control"
                }

                    'Call the API to load the Dropdown list. 
                    Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                    childDropDownList.DataSource = dropDownList
                    childDropDownList.DataTextField = "strValueCaption"
                    childDropDownList.DataValueField = "idfsValue"
                    childDropDownList.DataBind()
                    childDropDownList.Items.Insert(0, "")
                    cell2.Controls.Add(childDropDownList)

                Case "Boolean"

                    Dim chkBoxItem As New CheckBox With {
                    .ID = "chk" + item.idfsParameter.ToString(),
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(chkBoxItem)

                Case "String"

                    Dim textString As New TextBox With {
                    .ID = "txtString" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(textString)

                Case "Numeric Positive"

                    Dim textNumber As New TextBox With {
                    .ID = "txtNumberPositive" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(textNumber)

                Case "Date"

                    Dim textDate As New EIDSSControlLibrary.CalendarInput With {
                        .ID = "txtDate" + item.idfsParameter.ToString(),
                        .ContainerCssClass = "input-group datepicker",
                        .CssClass = "form-control"
                    }
                    '<eidss:CalendarInput ContainerCssClass = "input-group datepicker" ID="txtdatNotificationDate" runat="server" CssClass="form-control"></eidss: CalendarInput>
                    cell2.Controls.Add(textDate)

                Case Else
                    Dim childDropDownList As New DropDownList With {
                    .ID = "ddlParam" + item.idfsParameter.ToString(),
                    .Width = 250,
                    .CssClass = "form-control"
                }

                    '' Here is where we link teh dropdowns with the Parameter FIxed pre-set / Reference type values. 
                    'Call the API to load the Dropdown list. 
                    Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                    childDropDownList.DataSource = dropDownList
                    childDropDownList.DataTextField = "strValueCaption"
                    childDropDownList.DataValueField = "idfsValue"
                    childDropDownList.DataBind()
                    childDropDownList.Items.Insert(0, "")
                    cell2.Controls.Add(childDropDownList)
            End Select

            parameterControlRow.Cells.Add(cell2)
            loadMatxrixTable.Rows.Add(parameterControlRow)
            pnlCaseClassification.Controls.Add(loadMatxrixTable)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub
    Protected Sub btnDeleteparameter_Click(sender As Object, e As EventArgs)
        Try
            If hdnidfparamter.Value.Length > 0 Then

                Dim idfparamter As String() = hdnidfparamter.Value.Split(",")
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                If idfparamter.Length > 0 Then

                    For Each idfparamterRecord As Long In idfparamter
                        Dim ParameterDelete As List(Of AdminFfParameterDelModel) = FlexibleFormService.AdminFfSectionDelAsync(idfparamterRecord).Result
                    Next
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "alertMessage", "alert('" & idfparamter.Length & "Parameters Deleted')", True)
                    LoadFlexFormTemplate(TvTempleteEditor.SelectedNode.Value)
                End If
            Else
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "alertMessage", "alert('No Parameter Selected.')", True)
                LoadFlexFormTemplate(TvTempleteEditor.SelectedNode.Value)
            End If

        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "alertMessage", "alert('" + ex.Message + "')", True)
            btnDeleteparameter.Visible = False
        End Try

    End Sub
#End Region
End Class