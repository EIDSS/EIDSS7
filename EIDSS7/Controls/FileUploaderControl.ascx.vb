Public Class FileUploaderControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public ReadOnly Property FileUpload() As FileUpload

        Get
            Return fuControl
        End Get

    End Property
    Public Property AllowMultiple() As Boolean
        Set(value As Boolean)
            fuControl.AllowMultiple = value
        End Set
        Get
            Return fuControl.AllowMultiple
        End Get

    End Property

    Public ReadOnly Property FileName() As String
        Get
            Return fuControl.FileName
        End Get
    End Property


End Class