Namespace EIDSS

    Public Interface IOpenEidssEntity

        Function GetList(Of T)(Optional parameters() As String = Nothing) As Generic.List(Of T)

        Function GetDetail(Of T)(id As Long) As T

    End Interface

End Namespace
