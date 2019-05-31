Imports System.Data.SqlClient
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class ParameterEditor
    Inherits BaseEidssPage

    Private oCommon As clsCommon = New clsCommon()
    Private CrossCuttingAppService As CrossCuttingServiceClient
    Private FlexibleFormService As FlexibleFormServiceClient
    Private Shared Log As log4net.ILog
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
        Try
            hdfLangID.Value = PageLanguage
            If Not Page.IsPostBack Then
                tblcreatesection.Visible = False
                LoadFlexFormTemplate()
                TreeView1.CollapseAll()
                FillReferenceTypeList()
                FillReferenceEditorList()
                FillHACodeList()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub
    Private Sub LoadFlexFormTemplate(Optional cleanUp As Boolean = False)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            'Retrieve the actual template and load that into the DIV tag (running at server). 
            Dim list As List(Of AdminFfParameterTemplateGetModel) = FlexibleFormService.GET_FF_ParameterTemplates(Nothing, Nothing, GetCurrentLanguage()).Result

            'Iterate through the data elements to add them to the display DIV tag's inner html
            For Each ParameterTemplateRecord As AdminFfParameterTemplateGetModel In list

                ''Parameter Type will be parsed to get the list of different objects we need to rely on. 
                'Dim FFReferenceTypes As List(Of FfGetReferenceTypesModel) = CrossCuttingAppService.GetFlexibleFormsReferenceTypesAsync(GetCurrentLanguage()).Result
                If Not ParameterTemplateRecord.idfsSection Is Nothing Then

                    'Generating TreeNodes for sections - It can be multiple levels. 
                    'First level - when iterating through sections 
                    ' We want to do is find if it has parentSection 
                    '    If it does then iterate until we find the parnet Section top level
                    '    Continue adding till current  level and above are loaded.
                    ' We want to do find if it has a child section. - IS this step needed? 
                    '   If needed we need to add all sections below the current level. 


                    ParseSection(ParameterTemplateRecord)
                    Dim child As New TreeNode() With {
             .Text = ParameterTemplateRecord.DefaultName,
             .Value = ParameterTemplateRecord.idfsParameter,
             .Target = 2
            }


                    Dim FindNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString())
                    If Not (FindNode Is Nothing) Then
                        Dim FindParameterNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString() + "/" + ParameterTemplateRecord.idfsParameter.ToString())
                        If (FindParameterNode Is Nothing) Then
                            FindNode.ChildNodes.Add(child)
                        End If
                    End If

                Else

                    Dim child As New TreeNode() With {
            .Text = ParameterTemplateRecord.DefaultName,
            .Value = ParameterTemplateRecord.idfsParameter,
            .Target = 2
           }
                    Dim FindNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString())
                    If Not (FindNode Is Nothing) Then
                        Dim FindParameterNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString() + "/" + ParameterTemplateRecord.idfsParameter.ToString())
                        If (FindParameterNode Is Nothing) Then
                            FindNode.ChildNodes.Add(child)
                        End If
                    End If
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub
    Private Sub ParseSection(item As AdminFfParameterTemplateGetModel)
        Try
            Dim sectionCollection As List(Of AdminFfParentSectionsGetModel) = FlexibleFormService.GET_FF_ParentSections(GetCurrentLanguage(), item.idfsSection).Result

            'Iterate through the data elements to add them to the display DIV tag's inner html
            Dim iterationCount As Integer = 0
            Dim ParentsectionId As Long = 0
            For Each sectionRecord As AdminFfParentSectionsGetModel In sectionCollection

                Dim node = TreeView1.FindNode(sectionRecord.SectionID)
                Dim child As New TreeNode() With {
             .Text = sectionRecord.SectionName,
             .Value = sectionRecord.SectionID
            }
                If iterationCount = 0 Then
                    ' We are at the first record, so store the Verif table ID for the subsequent inserts for the sections. 
                    'Changing iterationCount to 1 so it doesn't go into the loop anymore. 
                    iterationCount = 1

                    If (TreeView1.FindNode(sectionRecord.SectionID) Is Nothing) Then
                        child.Target = 0
                        TreeView1.Nodes.Add(child)
                    End If

                Else
                    'The main section exists already, Now need to insert the child sections. 
                    Dim FindParentNode = TreeView1.FindNode(sectionCollection(ParentsectionId).SectionID)

                    If Not (FindParentNode Is Nothing) Then
                        Dim FindChildNode = TreeView1.FindNode(sectionCollection(ParentsectionId).SectionID.ToString() + "/" + sectionRecord.SectionID.ToString())
                        If FindChildNode Is Nothing Then

                            ChildParameters(item, child, sectionCollection(ParentsectionId).SectionID)
                            child.Target = 1
                            FindParentNode.ChildNodes.Add(child)
                        End If
                    End If
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub
    Private Sub ChildParameters(item As AdminFfParameterTemplateGetModel, ChildParameterParentNode As TreeNode, ParentsectionId As String)
        Try
            Dim ParameterList As List(Of AdminFfParametersGetModel) = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), item.idfsSection, item.idfsFormType).Result

            Dim parameterType As String = String.Empty
            For Each parameterItem As AdminFfParametersGetModel In ParameterList
                Dim childparameters As New TreeNode() With {
                .Text = parameterItem.DefaultName,
                .Value = parameterItem.idfsParameter,
                .Target = 2
            }

                Dim FindChildParameterNode = TreeView1.FindNode(ParentsectionId.ToString() + "/" + ChildParameterParentNode.Value + "/" + parameterItem.idfsParameter.ToString())
                If (FindChildParameterNode Is Nothing) Then
                    ChildParameterParentNode.ChildNodes.Add(childparameters)
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub
    Protected Sub btnAddItem_Click(sender As Object, e As EventArgs)
        tblcreatesection.Visible = True
        tblParameterTypeQuestionEditor.Visible = False
        btnEdit.Visible = False
        btnCancel.Visible = True
        btnDelete.Visible = False
        btnsave.Visible = True
        'btnEdit.Enabled = False
        'btnCancel.Enabled = True
        'btnDelete.Enabled = False
        txtDefaultName.Text = " New Section "
        txtNationalName.Text = " New Section "
        btnAddItem.Visible = False
        btnParameteradd.Visible = False
        btnDelete.Visible = False
    End Sub

    Protected Sub TreeView1_SelectedNodeChanged(sender As Object, e As EventArgs)
        Try
            ButtonVisibility()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnsave_Click(sender As Object, e As EventArgs)
        Try
            If (hdnSectionId.Value = "") Then
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim AdminFfSectionSetParams = New AdminFfSectionSetParams()

                AdminFfSectionSetParams.DefaultName = txtDefaultName.Text
                AdminFfSectionSetParams.NationalName = txtNationalName.Text
                AdminFfSectionSetParams.blnGrid = ddlType.SelectedValue
                AdminFfSectionSetParams.langId = hdfLangID.Value
                AdminFfSectionSetParams.idfsSection = 0

                Dim list As List(Of AdminFfSectionsSetModel) = FlexibleFormService.SetFfSections(AdminFfSectionSetParams).Result


            Else
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim AdminFfSectionSetParams = New AdminFfSectionSetParams()

                AdminFfSectionSetParams.DefaultName = txtDefaultName.Text
                AdminFfSectionSetParams.NationalName = txtNationalName.Text
                AdminFfSectionSetParams.langId = hdfLangID.Value
                AdminFfSectionSetParams.idfsSection = hdnSectionId.Value
                'AdminFfSectionSetParams.idfsParentSection = hdnidfsParentSection.Value
                'AdminFfSectionSetParams.idfsFormType = hdfformType.Value
                'AdminFfSectionSetParams.blnGrid = ddlType.SelectedValue

                Dim list As List(Of AdminFfSectionsSetModel) = FlexibleFormService.SetFfSections(AdminFfSectionSetParams).Result


                LoadFlexFormTemplate()
                btnEdit.Visible = True
                btnCancel.Visible = False
                btnDelete.Visible = True
                btnsave.Visible = False
                btnAddItem.Visible = True
                tblcreatesection.Visible = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnEdit_Click(sender As Object, e As EventArgs)
        If FlexibleFormService Is Nothing Then
            FlexibleFormService = New FlexibleFormServiceClient()
        End If

        Dim AdminFfSectionSetParams = New AdminFfSectionSetParams()



        Dim list As List(Of AdminFfSectionsGetModel) = FlexibleFormService.GET_FF_Sections(hdfLangID.Value, Nothing, TreeView1.SelectedNode.Value, Nothing).Result

        tblcreatesection.Visible = True
        btnEdit.Visible = False
        btnCancel.Visible = True
        btnDelete.Visible = False
        btnsave.Visible = True

        txtDefaultName.Text = TreeView1.SelectedNode.Text
        txtNationalName.Text = TreeView1.SelectedNode.Text
        'If (list.FirstOrDefault().blnGrid = True) Then
        '    ddlType.SelectedValue = 1
        'Else
        '    ddlType.SelectedValue = 0

        'End If

        'If (list.FirstOrDefault().idfsParentSection Is Nothing) Then
        '    hdnidfsParentSection.Value = ""
        'Else
        '    hdnidfsParentSection.Value = list.FirstOrDefault().idfsParentSection

        'End If
        'If (list.FirstOrDefault().idfsFormType = True) Then
        '    hdfformType.Value = ""
        'Else
        '    hdfformType.Value = list.FirstOrDefault().idfsFormType

        'End If
        hdnSectionId.Value = TreeView1.SelectedNode.Value
    End Sub

    Protected Sub btnDelete_Click(sender As Object, e As EventArgs)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim list As Int32 = FlexibleFormService.DeleteSection(TreeView1.SelectedNode.Value).Result

            hdnSectionId.Value = TreeView1.SelectedNode.Value
            LoadFlexFormTemplate()
            ButtonVisibility()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs)
        tblcreatesection.Visible = False
        btnEdit.Visible = True
        btnCancel.Visible = False
        btnsave.Visible = False
        ButtonVisibility()
    End Sub



    Private Sub FillReferenceTypeList(Optional ByVal sortExpression As String = Nothing)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim list As List(Of AdminFfParameterTypesGetListModel) = New List(Of AdminFfParameterTypesGetListModel)()

            list = FlexibleFormService.GetFFParameterReferenceType(GetCurrentLanguage(), Nothing, False).Result

            ddlParameterType.DataSource = list
            ddlParameterType.DataTextField = "DefaultName"
            ddlParameterType.DataValueField = "idfsParameterType"
            ddlParameterType.DataBind()
            'Populate grid with base reference values for selected base reference type
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub FillReferenceEditorList(Optional ByVal sortExpression As String = Nothing)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim list As List(Of AdminFfParameterEditorsGetModel) = New List(Of AdminFfParameterEditorsGetModel)()

            list = FlexibleFormService.GET_FF_ParameterEditors(GetCurrentLanguage()).Result

            ddlEditor.DataSource = list
            ddlEditor.DataTextField = "name"
            ddlEditor.DataValueField = "idfsEditor"
            ddlEditor.DataBind()

            'Populate grid with base reference values for selected base reference type
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub FillHACodeList(Optional ByVal sortExpression As String = Nothing)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim list As List(Of AdminFfHaCodeListGetModel) = New List(Of AdminFfHaCodeListGetModel)()

            list = FlexibleFormService.GETFFHaCodeList(GetCurrentLanguage(), Nothing, Nothing).Result

            ddlHACode.DataSource = list
            ddlHACode.DataTextField = "DefaultName"
            ddlHACode.DataValueField = "intHACode"
            ddlHACode.DataBind()

            'Populate grid with base reference values for selected base reference type
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnParameteradd_Click(sender As Object, e As EventArgs)
        tblcreatesection.Visible = False
        tblParameterTypeQuestionEditor.Visible = True
        btnEditParameter.Visible = False
        btnParameterCancel.Visible = True
        btnDeleteParameter.Visible = False
        btnsaveParameter.Visible = True
        btnParameteradd.Visible = False
        btnAddItem.Visible = False
        btnDelete.Visible = False
        btnEdit.Visible = False
    End Sub

    Protected Sub btnsaveParameter_Click(sender As Object, e As EventArgs)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            If Not (hdnidfsParameter.Value = "") Then
                Dim adminFfParametersSetParams = New AdminFfParametersSetParams()

                adminFfParametersSetParams.defaultName = txtParametrDefaultName.Text
                adminFfParametersSetParams.defaultLongName = txtDefaultLongName.Text
                adminFfParametersSetParams.nationalLongName = txtParametrNationalLongName.Text
                adminFfParametersSetParams.nationalName = txtParametrDefaultName.Text
                adminFfParametersSetParams.idfsSection = hdnsectionidvalue.Value
                adminFfParametersSetParams.idfsFormType = hdnformTypeid.Value
                adminFfParametersSetParams.intScheme = ddlScheme.SelectedValue
                adminFfParametersSetParams.idfsParameterType = ddlParameterType.SelectedValue
                adminFfParametersSetParams.idfsEditor = ddlEditor.SelectedValue
                adminFfParametersSetParams.intHaCode = ddlHACode.SelectedValue
                adminFfParametersSetParams.intOrder = 0
                adminFfParametersSetParams.strNote = hdnstrNote.Value
                adminFfParametersSetParams.langId = hdfLangID.Value
                adminFfParametersSetParams.intLeft = 0
                adminFfParametersSetParams.intTop = 0
                adminFfParametersSetParams.intWidth = txtWidth.Text
                adminFfParametersSetParams.intHeight = txtHeight.Text
                adminFfParametersSetParams.intLabelSize = txtLabelSize.Text

                Dim saveadminparametrList As List(Of AdminFfParametersSetModel) = FlexibleFormService.SET_FF_PARAMETERS(adminFfParametersSetParams).Result
            Else


                'Dim Path As String = TreeView1.SelectedNode.Parent.ValuePath.ToString()


                Dim adminFfParametersSetParams = New AdminFfParametersSetParams()

                adminFfParametersSetParams.defaultName = txtParametrDefaultName.Text
                adminFfParametersSetParams.defaultLongName = txtDefaultLongName.Text
                adminFfParametersSetParams.nationalLongName = txtParametrNationalLongName.Text
                adminFfParametersSetParams.nationalName = txtParametrDefaultName.Text


                adminFfParametersSetParams.intScheme = ddlScheme.SelectedValue
                adminFfParametersSetParams.idfsParameterType = ddlParameterType.SelectedValue
                adminFfParametersSetParams.idfsEditor = ddlEditor.SelectedValue
                adminFfParametersSetParams.intHaCode = ddlHACode.SelectedValue
                adminFfParametersSetParams.intOrder = 0
                adminFfParametersSetParams.strNote = hdnstrNote.Value
                adminFfParametersSetParams.langId = hdfLangID.Value
                adminFfParametersSetParams.intLeft = 0
                adminFfParametersSetParams.intTop = 0
                adminFfParametersSetParams.intWidth = txtWidth.Text
                adminFfParametersSetParams.intHeight = txtHeight.Text
                adminFfParametersSetParams.intLabelSize = txtLabelSize.Text

                Dim saveadminparametrList As List(Of AdminFfParametersSetModel) = FlexibleFormService.SET_FF_PARAMETERS(adminFfParametersSetParams).Result

            End If

            LoadFlexFormTemplate()

            btnEditParameter.Visible = True
            btnParameterCancel.Visible = False
            btnDeleteParameter.Visible = True
            btnsaveParameter.Visible = False
            btnParameteradd.Visible = True
            ButtonVisibility()
            tblParameterTypeQuestionEditor.Visible = False
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnParameterCancel_Click(sender As Object, e As EventArgs)
        tblParameterTypeQuestionEditor.Visible = False
        btnEditParameter.Visible = True
        btnParameterCancel.Visible = False
        btnDeleteParameter.Visible = True
        btnsaveParameter.Visible = False
        btnParameteradd.Visible = True
        ButtonVisibility()

    End Sub

    Protected Sub btnEditParameter_Click(sender As Object, e As EventArgs)
        Try
            hdnidfsParameter.Value = TreeView1.SelectedNode.Value

            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim childParameters = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), Nothing, Nothing).Result

            Dim list As AdminFfParametersGetModel = childParameters.Where(Function(x) x.idfsParameter = hdnidfsParameter.Value).FirstOrDefault()

            tblParameterTypeQuestionEditor.Visible = True
            btnEditParameter.Visible = False
            btnParameterCancel.Visible = True
            btnDeleteParameter.Visible = False
            btnsaveParameter.Visible = True

            txtParametrDefaultName.Text = list.DefaultName
            txtParameterNationalName.Text = list.NationalName
            txtDefaultLongName.Text = list.DefaultLongName
            txtParametrNationalLongName.Text = list.NationalLongName



            'TODO: Kishore Error occuring when enabled. 
            'If (Convert.ToBoolean(ddlHACode.Items.FindByValue(list.intHACode)) = True) Then
            '    ddlHACode.SelectedValue = list.intHACode
            'Else
            '    ddlHACode.SelectedIndex = 0
            'End If


            If Not list.idfsParameterType Is Nothing Then
                If (Convert.ToBoolean(ddlParameterType.Items.FindByValue(list.idfsParameterType.Value.ToString())) = True) Then
                    ddlParameterType.SelectedValue = list.idfsParameterType.Value.ToString()

                Else
                    ddlParameterType.SelectedIndex = 0
                End If
            Else
                ddlParameterType.SelectedValue = 0
            End If

            If Not list.idfsEditor Is Nothing Then
                ddlEditor.SelectedValue = list.idfsEditor.Value.ToString()
            Else
                ddlEditor.SelectedIndex = 0
            End If


            'If Not list.intHACode Is Nothing Then
            '    If (Convert.ToBoolean(ddlHACode.Items.FindByValue(list.intHACode.Value.ToString())) = True) Then
            '        ddlHACode.SelectedValue = list.intHACode
            '    Else
            '        ddlHACode.SelectedIndex = 0
            '    End If
            'Else
            '    ddlHACode.SelectedIndex = 0
            'End If



            txtLabelSize.Text = list.intLabelSize

            If Not list.intScheme Is Nothing Then
                ddlScheme.SelectedValue = list.intScheme
            Else
                ddlScheme.SelectedIndex = 0
            End If
            txtHeight.Text = list.intHeight
            txtWidth.Text = list.intWidth
            hdnformTypeid.Value = list.idfsFormType
            hdnsectionidvalue.Value = list.idfsSection
            hdnstrNote.Value = list.strNote

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub ButtonVisibility()
        tblParameterTypeQuestionEditor.Visible = False
        tblcreatesection.Visible = False
        divTemplatesUsedParameters.Visible = False

        Select Case TreeView1.SelectedNode.Target
            Case 0
                divCrudButtonPanel.Visible = True
                btnAddItem.Visible = True
                btnDelete.Visible = True
                btnDeleteParameter.Visible = False
                btnParameteradd.Visible = True
                btnEditParameter.Visible = False
                btnDeleteParameter.Visible = False
                btnEdit.Visible = False
                btnsave.Visible = False
                btnCancel.Visible = False
                btnsaveParameter.Visible = False
                btnParameterCancel.Visible = False
            Case 1
                divCrudButtonPanel.Visible = True
                btnAddItem.Visible = False
                btnEdit.Visible = True
                btnDelete.Visible = True
                btnDeleteParameter.Visible = False
                btnParameteradd.Visible = True
                btnEditParameter.Visible = False
                btnsave.Visible = False
                btnCancel.Visible = False
                btnsaveParameter.Visible = False
                btnParameterCancel.Visible = False
            Case 2
                divCrudButtonPanel.Visible = True
                btnAddItem.Visible = False
                btnEdit.Visible = False
                btnDelete.Visible = False
                btnDeleteParameter.Visible = True
                btnParameteradd.Visible = False
                btnEditParameter.Visible = True
                btnDeleteParameter.Visible = True
                btnsave.Visible = False
                btnCancel.Visible = False
                btnsaveParameter.Visible = False
                btnParameterCancel.Visible = False
                BindTemplateByParameter()
            Case Else
                divCrudButtonPanel.Visible = False
                btnAddItem.Visible = False
                btnDelete.Visible = False
                btnDeleteParameter.Visible = False
                btnParameteradd.Visible = False
                btnEditParameter.Visible = False
                btnDeleteParameter.Visible = False
                btnEdit.Visible = False
                btnsave.Visible = False
                btnCancel.Visible = False
                btnsaveParameter.Visible = False
                btnParameterCancel.Visible = False
        End Select

    End Sub

    Protected Sub BindTemplateByParameter()
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim templatesByParameterCollection As List(Of AdminFfTemplatesByParameterGetModel) = FlexibleFormService.GET_FF_TemplateByParameter(GetCurrentLanguage(), TreeView1.SelectedNode.Value).Result

            If templatesByParameterCollection.Count > 0 Then
                divTemplatesUsedParameters.Visible = True

                RptTemplatesUsedParameter.DataSource = templatesByParameterCollection
                RptTemplatesUsedParameter.DataBind()
                lblTemplatesCount.InnerText = templatesByParameterCollection.Count.ToString() + If(templatesByParameterCollection.Count > 1, "items", " item")

            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FilterTreeViewonSectionName()
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim sectionCollection As List(Of AdminFfSectionsGetModel) = FlexibleFormService.GET_FF_Sections(GetCurrentLanguage(), Nothing, Nothing, Nothing).Result

            sectionCollection = sectionCollection.Where(Function(x) x.DefaultName.ToLower().Contains(txtsectionsearch.Text.ToLower())).ToList()

            For Each sectionRecord As AdminFfSectionsGetModel In sectionCollection

                If sectionRecord.idfsParentSection Is Nothing Then

                    Dim parentSectionCollection As List(Of AdminFfParentSectionsGetModel) = FlexibleFormService.GET_FF_ParentSections(GetCurrentLanguage(), sectionRecord.idfsSection).Result

                    For Each ParentSectionRecord As AdminFfParentSectionsGetModel In parentSectionCollection

                        Dim child As New TreeNode With {
                .Text = ParentSectionRecord.SectionName,
                .Value = ParentSectionRecord.SectionID,
                .Target = 0
                }


                        Dim sectionlist As List(Of AdminFfSectionsGetModel) = FlexibleFormService.GET_FF_Sections(GetCurrentLanguage(), Nothing, Nothing, ParentSectionRecord.SectionID).Result

                        If sectionlist.Count > 0 Then

                            For Each sectionsRecord As AdminFfSectionsGetModel In sectionlist

                                Dim sectionchild As New TreeNode With {
                        .Text = sectionsRecord.DefaultName,
                        .Value = sectionsRecord.idfsSection,
                        .Target = 1
                        }


                                Dim Parameterlist As List(Of AdminFfParametersGetModel) = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), sectionsRecord.idfsSection, sectionsRecord.idfsFormType).Result

                                For Each ParameterRecord As AdminFfParametersGetModel In Parameterlist
                                    Dim childParameter As New TreeNode With {
                        .Text = ParameterRecord.DefaultName,
                        .Value = ParameterRecord.idfsParameter,
                        .Target = 2
                        }
                                    sectionchild.ChildNodes.Add(childParameter)
                                Next

                                child.ChildNodes.Add(sectionchild)
                            Next

                            TreeView1.Nodes.Add(child)

                        End If
                    Next
                Else

                    Dim parentSectionCollection As List(Of AdminFfParentSectionsGetModel) = FlexibleFormService.GET_FF_ParentSections(GetCurrentLanguage(), sectionRecord.idfsSection).Result

                    Dim FilterparentSectionCollection As List(Of AdminFfParentSectionsGetModel) = parentSectionCollection.Where(Function(x) x.SectionID = sectionRecord.idfsParentSection).ToList()

                    For Each ParentSectionRecord As AdminFfParentSectionsGetModel In FilterparentSectionCollection

                        Dim child As New TreeNode With {
                .Text = ParentSectionRecord.SectionName,
                .Value = ParentSectionRecord.SectionID,
                .Target = 0
                }

                        Dim FindNode As TreeNode = TreeView1.FindNode(ParentSectionRecord.SectionID)

                        If FindNode Is Nothing Then
                            TreeView1.Nodes.Add(child)

                            Dim sectionchild As New TreeNode With {
                .Text = sectionRecord.DefaultName,
                .Value = sectionRecord.idfsSection,
                .Target = 1
                }
                            Dim Parameterlist As List(Of AdminFfParametersGetModel) = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), sectionRecord.idfsSection, sectionRecord.idfsFormType).Result

                            For Each ParameterRecord As AdminFfParametersGetModel In Parameterlist
                                Dim childParameter As New TreeNode With {
                        .Text = ParameterRecord.DefaultName,
                        .Value = ParameterRecord.idfsParameter,
                        .Target = 2
                        }
                                sectionchild.ChildNodes.Add(childParameter)
                            Next


                            child.ChildNodes.Add(sectionchild)

                        Else

                            Dim sectionchild As New TreeNode With {
                .Text = sectionRecord.DefaultName,
                .Value = sectionRecord.idfsSection,
                .Target = 1
                }
                            Dim Parameterlist As List(Of AdminFfParametersGetModel) = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), sectionRecord.idfsSection, sectionRecord.idfsFormType).Result

                            For Each ParameterRecord As AdminFfParametersGetModel In Parameterlist
                                Dim childParameter As New TreeNode With {
                        .Text = ParameterRecord.DefaultName,
                        .Value = ParameterRecord.idfsParameter,
                        .Target = 2
                        }
                                sectionchild.ChildNodes.Add(childParameter)
                            Next

                            FindNode.ChildNodes.Add(sectionchild)
                        End If
                    Next
                End If

            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        Try
            If txtsectionsearch.Text.Length > 0 Then
                TreeView1.Nodes.Clear()
                FilterTreeViewonSectionName()
                VisibleAllButton()

            ElseIf txtParametersearch.Text.Length > 0 Then
                TreeView1.Nodes.Clear()
                FilterTreeViewonParameterName()
                VisibleAllButton()

            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub FilterTreeViewonParameterName()
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()

                Dim list As List(Of AdminFfParameterTemplateGetModel) = FlexibleFormService.GET_FF_ParameterTemplates(Nothing, Nothing, GetCurrentLanguage()).Result

                Dim filterParameterList As List(Of AdminFfParameterTemplateGetModel) = list.Where(Function(x) x.DefaultName.ToLower().Contains(txtParametersearch.Text.ToLower())).ToList()
                For Each ParameterTemplateRecord As AdminFfParameterTemplateGetModel In filterParameterList
                    If Not ParameterTemplateRecord.idfsSection Is Nothing Then

                        ParseSection(ParameterTemplateRecord)
                        Dim child As New TreeNode() With {
                 .Text = ParameterTemplateRecord.DefaultName,
                 .Value = ParameterTemplateRecord.idfsParameter,
                 .Target = 2
                }
                        Dim FindNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString())
                        If Not (FindNode Is Nothing) Then
                            Dim FindParameterNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString() + "/" + ParameterTemplateRecord.idfsParameter.ToString())
                            If (FindParameterNode Is Nothing) Then
                                FindNode.ChildNodes.Add(child)
                            End If
                        End If

                    Else

                        Dim child As New TreeNode() With {
                .Text = ParameterTemplateRecord.DefaultName,
                .Value = ParameterTemplateRecord.idfsParameter,
                .Target = 2
               }
                        Dim FindNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString())
                        If Not (FindNode Is Nothing) Then
                            Dim FindParameterNode = TreeView1.FindNode(ParameterTemplateRecord.idfsSection.ToString() + "/" + ParameterTemplateRecord.idfsParameter.ToString())
                            If (FindParameterNode Is Nothing) Then
                                FindNode.ChildNodes.Add(child)
                            End If
                        End If
                    End If
                Next
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        Try
            VisibleAllButton()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub lnksearch_Click(sender As Object, e As EventArgs)
        'mpe.Show()
    End Sub

    Protected Sub btnClose_Click(sender As Object, e As EventArgs)

        VisibleAllButton()
    End Sub

    Private Sub VisibleAllButton()
        btnAddItem.Visible = False
        btnDelete.Visible = False
        btnDeleteParameter.Visible = False
        btnParameteradd.Visible = False
        btnEditParameter.Visible = False
        btnDeleteParameter.Visible = False
        btnEdit.Visible = False
        btnsave.Visible = False
        btnCancel.Visible = False
        btnsaveParameter.Visible = False
        btnParameterCancel.Visible = False
        divTemplatesUsedParameters.Visible = False
        tblParameterTypeQuestionEditor.Visible = False
        tblcreatesection.Visible = False
        txtsectionsearch.Text = ""
        txtParametersearch.Text = ""
    End Sub

End Class