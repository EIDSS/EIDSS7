Imports EIDSS.EIDSS
Public Class DropDownAdd
    Inherits System.Web.UI.UserControl

#Region "Global Values"

    Public Enum TypeOfAdd
        Reference = 1
    End Enum

    Public Property AddType As TypeOfAdd
        Get
            Return _addType
        End Get
        Set(value As TypeOfAdd)
            _addType = value
        End Set
    End Property

#Region "Base Reference Add"

    Public Enum ReferenceTypes
        SpeciesList = 19000086
        TestCategory = 19000095
        TestName = 19000097
        TestResult = 19000096
        ASSessionActionType = 19000127
    End Enum

    Public Property ReferenceType As ReferenceTypes
        Get
            Return _referenceType
        End Get
        Set(value As ReferenceTypes)
            _referenceType = value
        End Set
    End Property

    Public Property BaseReferenceName As String
        Get
            Return _baseReferenceName
        End Get
        Set(value As String)
            _baseReferenceName = value
        End Set
    End Property

    Public Property AccessoryCode As String
        Get
            Return _accessoryCode
        End Get
        Set(value As String)
            _accessoryCode = value
        End Set
    End Property

    Public Property HACode As String
        Get
            Return _haCode
        End Get
        Set(value As String)
            _haCode = value
        End Set
    End Property

#End Region

#Region "All Items Drop Down"

    Public ReadOnly Property SelectedValue As String
        Get
            If ddlAllItems.SelectedIndex = -1 Then
                Return String.Empty
            Else
                Return ddlAllItems.SelectedValue
            End If
        End Get
    End Property

    Public ReadOnly Property ItemCount As Integer
        Get
            Return ddlAllItems.Items.Count
        End Get
    End Property

    Public Property DataSource As Object
        Get
            Return ddlAllItems.DataSource
        End Get
        Set(value As Object)
            ddlAllItems.DataSource = value
        End Set
    End Property

#End Region

#Region "All Items Drop Down Required Field Validator"

    Public Property ErrorMessage As String
        Get
            Return _errorMessage
        End Get
        Set(value As String)
            _errorMessage = value
        End Set
    End Property

    Public Property Text As String
        Get
            Return _text
        End Get
        Set(value As String)
            _text = value
        End Set
    End Property

    Public Property Enabled As String
        Get
            Return _enabled
        End Get
        Set(value As String)
            _enabled = value
        End Set
    End Property

    Public Property InitialValue As String
        Get
            Return _initialValue
        End Get
        Set(value As String)
            _initialValue = value
        End Set
    End Property

    Public Property ValidationGroup As String
        Get
            Return _validationGroup
        End Get
        Set(value As String)
            _validationGroup = value
        End Set
    End Property

#End Region

    Private _addType As TypeOfAdd
    Private _referenceType As ReferenceTypes
    Private _baseReferenceName As String
    Private _accessoryCode As String
    Private _haCode As String
    Private _errorMessage As String
    Private _text As String
    Private _enabled As String
    Private _initialValue As String
    Private _validationGroup As String

    Private oDS As DataSet
    Private oBaseReference As New EIDSS.clsBaseReference
    Private Shared oCommon As clsCommon = New clsCommon
    Private Shared oService As NG.EIDSSService = oCommon.GetService()
    Private Const BASE_REFERENCE_SET_SP As String = "BaseReferenceSet"

#End Region

#Region "Initialize"

    Protected Overrides Sub OnPreRender(e As EventArgs)
        If Not IsPostBack Then
            If AddType = TypeOfAdd.Reference And ReferenceType = Nothing Then
                Throw New ApplicationException("Please set a reference type.")
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            rfvAllItems.Enabled = Convert.ToBoolean(Enabled)
            rfvAllItems.ErrorMessage = ErrorMessage
            rfvAllItems.Text = Text
            rfvAllItems.InitialValue = InitialValue
            rfvAllItems.ValidationGroup = ValidationGroup

            Select Case AddType
                Case TypeOfAdd.Reference
                    Dim dsCat As DataSet = oBaseReference.SelectCategories()
                    If dsCat.CheckDataSet() Then
                        ddlReferenceType.DataSource = dsCat
                        ddlReferenceType.DataTextField = "strDefault"
                        ddlReferenceType.DataValueField = "idfsBaseReference"
                        ddlReferenceType.DataBind()
                        ddlReferenceType.SelectedValue = ReferenceType
                        ddlReferenceType.Enabled = False

                        BaseReferenceLookUp(ddlAccessoryType, BaseReferenceConstants.AccessoryList, 0, False)
                        ddlAccessoryType.SelectedValue = AccessoryCode
                        ddlAccessoryType.Enabled = False
                    End If
                    txtOrder.Text = ddlAllItems.Items.Count + 1
                    pnlBaseReferenceEditor.Visible = True
            End Select
        End If

    End Sub

#End Region

#Region "Base Reference Add"

    Protected Sub btnAddReference_Click(sender As Object, e As EventArgs)

        Dim aSPP As String() = oService.getSPList(BASE_REFERENCE_SET_SP)
        Dim strParams As String = oCommon.Gather(pnlBaseReferenceEditor, aSPP(0), 3, True)
        Dim oReturnValues As Object() = Nothing
        Dim result As Int16 = oBaseReference.AddUpdateBaseReference("LangID;EN;IN|" & strParams, oReturnValues)

        If result = 0 Then
            ddlAllItems.Items.Clear()
            BaseReferenceLookUp(ddlAllItems, BaseReferenceName, HACode, True)
        End If

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "hideModal();", True)

    End Sub

#End Region

End Class