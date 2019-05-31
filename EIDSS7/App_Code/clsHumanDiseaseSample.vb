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
    Public Class clsHumanDiseaseSample


        'Private oComm As clsCommon = New clsCommon()
        'Private oService As EIDSSService

        Property idfHumanCase As Int64?
        Property idfMaterial As Int64
        Property strBarcode As String
        Property strFieldBarcode As String

        'Property idfsSampleType As Int64

        Private _idfsSampleType As Int64?
        Public Property idfsSampleType As Object
            Get
                Return _idfsSampleType
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsSampleType = Nothing
                Else
                    _idfsSampleType = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property



        Property strSampleTypeName As String
        Property datFieldCollectionDate As DateTime?

        'Property idfSendToOffice As Int64?

        Private _idfSendToOffice As Int64?
        Public Property idfSendToOffice As Object
            Get
                Return _idfSendToOffice
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfSendToOffice = Nothing
                Else
                    _idfSendToOffice = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property








        Property strSendToOffice As String
        Property idfFieldCollectedByOffice As Int64?
        Property strFieldCollectedByOffice As String
        Property datFieldSentDate As DateTime?
        Property strNote As String
        Property datAccession As DateTime?
        Property idfsAccessionCondition As Int64?
        Property strCondition As String
        Property idfsRegion As Int64?
        Property strRegionName As String
        Property idfsRayon As Int64?
        Property strRayonName As String
        Property blnAccessioned As Int32
        Property RecordAction As String
        Property idfsSampleKind As Int64?
        Property SampleKindTypeName As String
        Property idfsSampleStatus As Int64?
        Property SampleStatusTypeName As String
        Property idfFieldCollectedByPerson As Int64?
        Property datSampleStatusDate As DateTime?
        Property sampleGuid As Guid
        Property intRowStatus As Int32




        'Public Function ListAll(Optional args() As String = Nothing) As DataSet

        '    ListAll = Nothing

        '    Try
        '        oService = oComm.GetService()

        '        Dim oDS As DataSet = Nothing
        '        Dim KeyValPair As New List(Of clsCommon.Param)

        '        Dim param As String = String.Empty
        '        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
        '        If Not (args Is Nothing) Then param = "|" & args(0)

        '        Dim oTuple = oService.GetData(GetCurrentCountry(), "HumDisSamplesGet", oComm.KeyValPairToString(KeyValPair) & param)
        '        oDS = oTuple.m_Item1
        '        oDS.CheckDataSet()

        '        ListAll = oDS

        '    Catch ex As Exception

        '        ListAll = Nothing
        '        Throw

        '    End Try

        '    Return ListAll

        'End Function


        'Public Function SelectOne(dblId As Double) As DataSet

        '    SelectOne = Nothing

        '    Try
        '        oService = oComm.GetService()

        '        Dim oDS As DataSet = Nothing
        '        Dim KeyValPair As New List(Of clsCommon.Param)

        '        Dim param As String = "|idfMaterial;" & dblId.ToString() & ";IN"
        '        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
        '        Dim oTuple = oService.GetData(GetCurrentCountry(), "HumDisSamplesGet", oComm.KeyValPairToString(KeyValPair) & param)
        '        oDS = oTuple.m_Item1
        '        oDS.CheckDataSet()

        '        SelectOne = oDS

        '    Catch ex As Exception

        '        SelectOne = Nothing
        '        Throw

        '    End Try

        '    Return SelectOne

        'End Function

        '''' <summary>
        '''' Saves a List Of customObjects to an xml file 
        '''' </summary>
        '''' <param name="oList"></param>
        '''' <param name="fileName"></param>
        'Public Sub SerializeListToXmlFile(ByRef oList As List(Of clsHumanDiseaseSample), fileName As String)
        '    'Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(oList.GetType())
        '    Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseSample)))
        '    Dim fw As IO.StreamWriter
        '    Dim sFile As String = fileName
        '    If sFile <> "" Then
        '        fw = New IO.StreamWriter(sFile)
        '        oSerializer.Serialize(fw, oList)
        '        fw.Flush()
        '        fw.Close()
        '        fw.Dispose()
        '    End If
        'End Sub

        '''' <summary>
        '''' Hydrates a List Of customObjects from an xml file 
        '''' </summary>
        '''' <param name="oList"></param>
        '''' <param name="fileName"></param>
        'Public Sub HydrateListFromXmlFile(ByRef oList As List(Of clsHumanDiseaseSample), FileName As String)
        '    Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseSample)))
        '    Dim fs As IO.FileStream
        '    Dim sFile As String = FileName
        '    If sFile <> "" AndAlso IO.File.Exists(sFile) Then
        '        fs = New IO.FileStream(sFile, IO.FileMode.Open)
        '        oList = oSerializer.Deserialize(fs)
        '        fs.Close()
        '        fs.Dispose()
        '    End If
        'End Sub






    End Class
End Namespace



