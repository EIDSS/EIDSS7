<System.SerializableAttribute>
<System.Diagnostics.DebuggerStepThroughAttribute>
<System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)>
<System.Xml.Serialization.XmlRootAttribute([Namespace]:="", IsNullable:=False)>
Public Class GridViewColumnOrder

    Private userField As GridAndUser()

    ''' <remarks/>
    <System.Xml.Serialization.XmlElementAttribute("user")>
    Public Property user() As GridAndUser()
        Get
            Return Me.userField
        End Get
        Set
            Me.userField = Value
        End Set
    End Property
End Class

