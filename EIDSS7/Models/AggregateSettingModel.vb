Public Class AggregateSettingModel
    Private _idfsAggrCaseType As String
    Public Property IdfsAggrCaseType() As String
        Get
            Return _idfsAggrCaseType
        End Get
        Set(ByVal value As String)
            _idfsAggrCaseType = value
        End Set
    End Property

    Private _idfCustomizationPackage As String
    Public Property IdfCustomizationPackage() As String
        Get
            Return _idfCustomizationPackage
        End Get
        Set(ByVal value As String)
            _idfCustomizationPackage = value
        End Set
    End Property

    Private _strValue As String
    Public Property StrValue() As String
        Get
            Return _strValue
        End Get
        Set(ByVal value As String)
            _strValue = value
        End Set
    End Property

    Private _idfsStatisticAreaType As String
    Public Property IdfsStatisticAreaType() As String
        Get
            Return _idfsStatisticAreaType
        End Get
        Set(ByVal value As String)
            _idfsStatisticAreaType = value
        End Set
    End Property

    Private _idfsStatisticPeriodType As String
    Public Property IdfsStatisticPeriodType() As String
        Get
            Return _idfsStatisticPeriodType
        End Get
        Set(ByVal value As String)
            _idfsStatisticPeriodType = value
        End Set
    End Property
End Class
