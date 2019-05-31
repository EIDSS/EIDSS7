Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI.Control
Imports System
Imports System.Reflection
Imports System.Web.UI
Imports System.Xml.Serialization
Imports System.IO

Namespace EIDSS



    Public Class Item

        Private itemID As String
        Private itemName As String

        Public Property ID() As String
            Get
                Return itemID
            End Get
            Set(ByVal Value As String)
                itemID = Value
            End Set
        End Property

        Public Property Name() As String
            Get
                Return itemName
            End Get
            Set(ByVal Value As String)
                itemName = Value
            End Set
        End Property

    End Class
    Public Class clsVASCampaign

        Private campaignID As String
        Private campaignStrID As String
        Private campaignType As String
        Private campaignName As String
        Private campaignDisease As String
        Private campaignSpecies As New List(Of Item)
        Private campaignSamples As New List(Of Item)
        Private campaignSpeciesAndSamples As New List(Of Item)

        Public Property ID() As String
            Get
                Return campaignID
            End Get
            Set(ByVal Value As String)
                campaignID = Value
            End Set
        End Property
        Public Property StrID() As String
            Get
                Return campaignStrID
            End Get
            Set(ByVal Value As String)
                campaignStrID = Value
            End Set
        End Property
        Public Property Type() As String
            Get
                Return campaignType
            End Get
            Set(ByVal Value As String)
                campaignType = Value
            End Set
        End Property
        Public Property Name() As String
            Get
                Return campaignName
            End Get
            Set(ByVal Value As String)
                campaignName = Value
            End Set
        End Property

        Public Property Disease() As String
            Get
                Return campaignDisease
            End Get
            Set(ByVal Value As String)
                campaignDisease = Value
            End Set
        End Property
        Public Property Species() As List(Of Item)
            Get
                Return campaignSpecies
            End Get
            Set(value As List(Of Item))
                campaignSpecies = value
            End Set
        End Property
        Public Property Samples() As List(Of Item)
            Get
                Return campaignSamples
            End Get
            Set(value As List(Of Item))
                campaignSamples = value
            End Set
        End Property
        Public Property SpeciesAndSamples() As List(Of Item)
            Get
                Return campaignSpeciesAndSamples
            End Get
            Set(value As List(Of Item))
                campaignSpeciesAndSamples = value
            End Set
        End Property


    End Class
End Namespace
