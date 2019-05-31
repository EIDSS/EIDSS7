<System.SerializableAttribute>
<System.Diagnostics.DebuggerStepThroughAttribute>
<System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)>
Public Class GridAndUser

    Private gridField As GridAndColumns()

    Private idField As String

    ''' <remarks/>
    <System.Xml.Serialization.XmlElementAttribute("grid")>
    Public Property grid() As GridAndColumns()
        Get
            Return Me.gridField
        End Get
        Set
            Me.gridField = Value
        End Set
    End Property

    ''' <remarks/>
    <System.Xml.Serialization.XmlAttributeAttribute>
    Public Property userId() As String
        Get
            Return Me.idField
        End Get
        Set
            Me.idField = Value
        End Set
    End Property
End Class
