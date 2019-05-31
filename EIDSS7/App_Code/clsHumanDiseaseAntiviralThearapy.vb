Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO
Namespace EIDSS
    <Serializable()>
    Public Class clsHumanDiseaseAntiviralThearapy

        Private _idfAntimicrobialTherapy As Object
        Public Property idfAntimicrobialTherapy As Object
            Get
                Return _idfAntimicrobialTherapy
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _idfAntimicrobialTherapy = Nothing
                Else
                    _idfAntimicrobialTherapy = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfHumanCase As Int64?
        Public Property idfHumanCase As Object
            Get
                Return _idfHumanCase
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfHumanCase = Nothing
                Else
                    _idfHumanCase = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _datFirstAdministeredDate As DateTime?
        Public Property datFirstAdministeredDate As Object
            Get
                Return _datFirstAdministeredDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datFirstAdministeredDate = Nothing
                Else
                    _datFirstAdministeredDate = value
                End If
            End Set
        End Property

        Private _strAntimicrobialTherapyName As String
        Public Property strAntimicrobialTherapyName As Object
            Get
                Return _strAntimicrobialTherapyName
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strAntimicrobialTherapyName = String.Empty
                Else
                    _strAntimicrobialTherapyName = value.ToString()
                End If
            End Set
        End Property

        Private _strDosage As String
        Public Property strDosage As Object
            Get
                Return _strDosage
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strDosage = String.Empty
                Else
                    _strDosage = value.ToString()
                End If
            End Set
        End Property

    End Class
End Namespace
