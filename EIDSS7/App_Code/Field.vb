Namespace EIDSS
    Public Class Field
        Private mIndex As Int32
        Private mKey As System.String
        Private mValue As System.String
        Private mLabel As System.String
        Private mChecked As System.Boolean

        Public Property Index() As Int32
            Get
                Return Me.mIndex
            End Get
            Set(ByVal Value As Int32)
                Me.mIndex = Value
            End Set
        End Property
        Public Property Key() As String
            Get
                Return Me.mKey
            End Get
            Set(ByVal Value As String)
                Me.mKey = Value
            End Set
        End Property
        Public Property Value() As String
            Get
                Return Me.mValue
            End Get
            Set(ByVal Value As String)
                Me.mValue = Value
            End Set
        End Property
        Public Property Label() As String
            Get
                Return Me.mLabel
            End Get
            Set(ByVal Value As String)
                Me.mLabel = Value
            End Set
        End Property
        Public Property Checked() As Boolean
            Get
                Return Me.mChecked
            End Get
            Set(ByVal Value As Boolean)
                Me.mChecked = Value
            End Set
        End Property

        Public Sub New()
            Index = 0
            Key = String.Empty
            Value = String.Empty
            Label = String.Empty
            Checked = False
        End Sub
        Public Sub New(ByVal existingObject As Field)
            Index = existingObject.Index
            Key = existingObject.Key
            Value = existingObject.Value
            Label = existingObject.Label
            Checked = existingObject.Checked
        End Sub
    End Class
End Namespace
