Imports EIDSS.EIDSS

Public Class ReferenceUserControl
    Inherits System.Web.UI.UserControl

#Region "Global Values"

    Private _referenceType As ReferenceTypes
    Private _baseReferenceName As String
    Private _accessoryCode As String
    Private _haCode As String
    Private _text As String

    Private oDS As DataSet
    Private oBaseReference As New EIDSS.clsBaseReference
    Private Shared oCommon As clsCommon = New clsCommon
    Private Const BASE_REFERENCE_SET_SP As String = "BaseReferenceSet"

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

#Region "Initialize Methods"

    Protected Overrides Sub OnPreRender(e As EventArgs)
        'If Not IsPostBack Then
        '    If ReferenceType = Nothing Then
        '        Throw New ApplicationException("Please set a reference type.")
        '    End If
        'End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            Dim dsCat As DataSet = oBaseReference.SelectCategories()
            If dsCat.CheckDataSet() Then
                ddlReferenceType.DataSource = dsCat
                ddlReferenceType.DataTextField = "strDefault"
                ddlReferenceType.DataValueField = "idfsBaseReference"
                ddlReferenceType.DataBind()
                'ddlReferenceType.Enabled = False

                BaseReferenceLookUp(ddlHACode, BaseReferenceConstants.AccessoryList, 0, False)
            End If
        End If

    End Sub

    Public Sub Setup()

        ddlReferenceType.SelectedValue = ReferenceType

        Dim ddl As DropDownList = New DropDownList()
        BaseReferenceLookUp(ddl, BaseReferenceConstants.TestName, HACodeList.AllHACode, True)
        txtOrder.Text = ddl.Items.Count + 1

    End Sub

#End Region

#Region "Add/Update Methods"

    Public Sub Save()

        Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(BASE_REFERENCE_SET_SP)(0), 3, True)
        strParams &= "|" & oCommon.Gather(divReferenceContainer, oCommon.GetSPList(BASE_REFERENCE_SET_SP)(0), 3, True)
        Dim oReturnValues As Object() = Nothing
        Dim result As Int16 = oBaseReference.AddUpdateBaseReference("LangID;EN;IN|" & strParams, oReturnValues)

    End Sub

#End Region

End Class