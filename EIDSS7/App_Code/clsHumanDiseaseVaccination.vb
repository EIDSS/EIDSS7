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
    Public Class clsHumanDiseaseVaccination

        Private _humanDiseaseReportVaccinationUID As Object
        Public Property humanDiseaseReportVaccinationUID As Object
            Get
                Return _humanDiseaseReportVaccinationUID
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _humanDiseaseReportVaccinationUID = Nothing
                Else
                    _humanDiseaseReportVaccinationUID = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
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

        Private _vaccinationName As String
        Public Property vaccinationName As Object
            Get
                Return _vaccinationName
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _vaccinationName = String.Empty
                Else
                    _vaccinationName = value.ToString()
                End If
            End Set
        End Property

        Private _vaccinationDate As DateTime?
        Public Property vaccinationDate As Object
            Get
                Return _vaccinationDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _vaccinationDate = Nothing
                Else
                    _vaccinationDate = value
                End If
            End Set
        End Property

    End Class
End Namespace
