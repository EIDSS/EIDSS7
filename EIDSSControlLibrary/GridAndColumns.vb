<System.SerializableAttribute>
<System.Diagnostics.DebuggerStepThroughAttribute>
<System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)>
Public Class GridAndColumns

    Private gridField As String

    Private columnorderField As String

    ''' <remarks/>
    <System.Xml.Serialization.XmlAttributeAttribute>
    Public Property idOfGrid() As String
        Get
            Return Me.gridField
        End Get
        Set
            Me.gridField = Value
        End Set
    End Property

    ''' <remarks/>
    <System.Xml.Serialization.XmlAttributeAttribute>
    Public Property columnorder() As String
        Get
            Return Me.columnorderField
        End Get
        Set
            Me.columnorderField = Value
        End Set
    End Property
End Class

