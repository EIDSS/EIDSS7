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
    Public Class clsHumanDiseaseTest


        'Private oComm As clsCommon = New clsCommon()
        'Private oService As EIDSSService

        Private _newIndicator As String
        Public Property newIndicator As Object
            Get
                Return _newIndicator
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _newIndicator = String.Empty
                Else
                    _newIndicator = value.ToString()
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

        Private _idfMaterial As Int64?
        Public Property idfMaterial As Object
            Get
                Return _idfMaterial
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfMaterial = Nothing
                Else
                    _idfMaterial = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property


        Private _strBarcode As String
        Public Property strBarcode As Object
            Get
                Return _strBarcode
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strBarcode = String.Empty
                Else
                    _strBarcode = value.ToString()
                End If
            End Set
        End Property

        Private _strFieldBarcode As String
        Public Property strFieldBarcode As Object
            Get
                Return _strFieldBarcode
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strFieldBarcode = String.Empty
                Else
                    _strFieldBarcode = value.ToString()
                End If
            End Set
        End Property

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

        Private _strSampleTypeName As String
        Public Property strSampleTypeName As Object
            Get
                Return _strSampleTypeName
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strSampleTypeName = String.Empty
                Else
                    _strSampleTypeName = value.ToString()
                End If
            End Set
        End Property

        Private _datFieldCollectionDate As DateTime?
        Public Property datFieldCollectionDate As Object
            Get
                Return _datFieldCollectionDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datFieldCollectionDate = Nothing
                Else
                    _datFieldCollectionDate = value
                End If
            End Set
        End Property

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

        Private _strSendToOffice As String
        Public Property strSendToOffice As Object
            Get
                Return _strSendToOffice
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strSendToOffice = String.Empty
                Else
                    _strSendToOffice = value.ToString()
                End If
            End Set
        End Property

        Private _idfFieldCollectedByOffice As Int64?
        Public Property idfFieldCollectedByOffice As Object
            Get
                Return _idfFieldCollectedByOffice
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfFieldCollectedByOffice = Nothing
                Else
                    _idfFieldCollectedByOffice = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _strFieldCollectedByOffice As String
        Public Property strFieldCollectedByOffice As Object
            Get
                Return _strFieldCollectedByOffice
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strFieldCollectedByOffice = String.Empty
                Else
                    _strFieldCollectedByOffice = value.ToString()
                End If
            End Set
        End Property

        Private _datFieldSentDate As DateTime?
        Public Property datFieldSentDate As Object
            Get
                Return _datFieldSentDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datFieldSentDate = Nothing
                Else
                    _datFieldSentDate = value
                End If
            End Set
        End Property

        Private _idfsSampleKind As Int64?
        Public Property idfsSampleKind As Object
            Get
                Return _idfsSampleKind
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsSampleKind = Nothing
                Else
                    _idfsSampleKind = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _SampleKindTypeName As String
        Public Property SampleKindTypeName As Object
            Get
                Return _SampleKindTypeName
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _SampleKindTypeName = String.Empty
                Else
                    _SampleKindTypeName = value.ToString()
                End If
            End Set
        End Property

        Private _idfsSampleStatus As Int64?
        Public Property idfsSampleStatus As Object
            Get
                Return _idfsSampleStatus
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsSampleStatus = Nothing
                Else
                    _idfsSampleStatus = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _SampleStatusTypeName As String
        Public Property SampleStatusTypeName As Object
            Get
                Return _SampleStatusTypeName
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _SampleStatusTypeName = String.Empty
                Else
                    _SampleStatusTypeName = value.ToString()
                End If
            End Set
        End Property

        Private _idfFieldCollectedByPerson As Int64?
        Public Property idfFieldCollectedByPerson As Object
            Get
                Return _idfFieldCollectedByPerson
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfFieldCollectedByPerson = Nothing
                Else
                    _idfFieldCollectedByPerson = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _datSampleStatusDate As DateTime?
        Public Property datSampleStatusDate As Object
            Get
                Return _datSampleStatusDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datSampleStatusDate = Nothing
                Else
                    _datSampleStatusDate = value
                End If
            End Set
        End Property

        Private _sampleGuid As Guid?
        Public Property sampleGuid As Object
            Get
                Return _sampleGuid
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _sampleGuid = Nothing
                Else
                    _sampleGuid = Guid.Parse(value.ToString())
                End If
            End Set
        End Property

        Private _idfTesting As Int64?
        Public Property idfTesting As Object
            Get
                Return _idfTesting
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfTesting = Nothing
                Else
                    _idfTesting = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfsTestName As Int64?
        Public Property idfsTestName As Object
            Get
                Return _idfsTestName
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsTestName = Nothing
                Else
                    _idfsTestName = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfsTestCategory As Int64?
        Public Property idfsTestCategory As Object
            Get
                Return _idfsTestCategory
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsTestCategory = Nothing
                Else
                    _idfsTestCategory = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfsTestResult As Int64?
        Public Property idfsTestResult As Object
            Get
                Return _idfsTestResult
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsTestResult = Nothing
                Else
                    _idfsTestResult = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfsTestStatus As Int64?
        Public Property idfsTestStatus As Object
            Get
                Return _idfsTestStatus
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsTestStatus = Nothing
                Else
                    _idfsTestStatus = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfsDiagnosis As Int64?
        Public Property idfsDiagnosis As Object
            Get
                Return _idfsDiagnosis
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsDiagnosis = Nothing
                Else
                    _idfsDiagnosis = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _strTestStatus As String
        Public Property strTestStatus As Object
            Get
                Return _strTestStatus
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strTestStatus = String.Empty
                Else
                    _strTestStatus = value.ToString()
                End If
            End Set
        End Property

        Private _strTestResult As String
        Public Property strTestResult As Object
            Get
                Return _strTestResult
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strTestResult = String.Empty
                Else
                    _strTestResult = value.ToString()
                End If
            End Set
        End Property

        Private _name As String
        Public Property name As Object
            Get
                Return _name
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _name = String.Empty
                Else
                    _name = value.ToString()
                End If
            End Set
        End Property

        Private _datReceivedDate As DateTime?
        Public Property datReceivedDate As Object
            Get
                Return _datReceivedDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datReceivedDate = Nothing
                Else
                    _datReceivedDate = value
                End If
            End Set
        End Property

        Private _datConcludedDate As DateTime?
        Public Property datConcludedDate As Object
            Get
                Return _datConcludedDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datConcludedDate = Nothing
                Else
                    _datConcludedDate = value
                End If
            End Set
        End Property

        Private _idfTestedByPerson As Int64?
        Public Property idfTestedByPerson As Object
            Get
                Return _idfTestedByPerson
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfTestedByPerson = Nothing
                Else
                    _idfTestedByPerson = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfTestedByOffice As Int64?
        Public Property idfTestedByOffice As Object
            Get
                Return _idfTestedByOffice
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfTestedByOffice = Nothing
                Else
                    _idfTestedByOffice = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _idfsInterpretedStatus As Int64?
        Public Property idfsInterpretedStatus As Object
            Get
                Return _idfsInterpretedStatus
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _idfsInterpretedStatus = Nothing
                Else
                    _idfsInterpretedStatus = If(IsNumeric(value), Convert.ToInt64(value), Nothing)
                End If
            End Set
        End Property

        Private _strInterpretedStatus As String
        Public Property strInterpretedStatus As Object
            Get
                Return _strInterpretedStatus
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strInterpretedStatus = String.Empty
                Else
                    _strInterpretedStatus = value.ToString()
                End If
            End Set
        End Property

        Private _strInterpretedComment As String
        Public Property strInterpretedComment As Object
            Get
                Return _strInterpretedComment
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strInterpretedComment = String.Empty
                Else
                    _strInterpretedComment = value.ToString()
                End If
            End Set
        End Property

        Private _datInterpretedDate As DateTime?
        Public Property datInterpretedDate As Object
            Get
                Return _datInterpretedDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datInterpretedDate = Nothing
                Else
                    _datInterpretedDate = value
                End If
            End Set
        End Property

        Private _strInterpretedBy As String
        Public Property strInterpretedBy As Object
            Get
                Return _strInterpretedBy
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strInterpretedBy = String.Empty
                Else
                    _strInterpretedBy = value.ToString()
                End If
            End Set
        End Property

        Private _blnValidateStatus As Boolean
        Public Property blnValidateStatus As Object
            Get
                Return _blnValidateStatus
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _blnValidateStatus = String.Empty
                Else
                    _blnValidateStatus = value.ToString()
                End If
            End Set
        End Property

        Private _strValidateComment As String
        Public Property strValidateComment As Object
            Get
                Return _strValidateComment
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strValidateComment = String.Empty
                Else
                    _strValidateComment = value.ToString()
                End If
            End Set
        End Property

        Private _datValidationDate As DateTime?
        Public Property datValidationDate As Object
            Get
                Return _datValidationDate
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _datValidationDate = Nothing
                Else
                    _datValidationDate = value
                End If
            End Set
        End Property

        Private _strValidatedBy As String
        Public Property strValidatedBy As Object
            Get
                Return _strValidatedBy
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strValidatedBy = String.Empty
                Else
                    _strValidatedBy = value.ToString()
                End If
            End Set
        End Property

        Private _strAccountName As String
        Public Property strAccountName As Object
            Get
                Return _strAccountName
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value)) Then
                    _strAccountName = String.Empty
                Else
                    _strAccountName = value.ToString()
                End If
            End Set
        End Property

        Private _testGuid As Guid?
        Public Property testGuid As Object
            Get
                Return _testGuid
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _testGuid = Nothing
                Else
                    _testGuid = Guid.Parse(value.ToString())
                End If
            End Set
        End Property

        Private _intRowStatus As Int32
        Public Property intRowStatus As Object
            Get
                Return _intRowStatus
            End Get
            Set(ByVal value As Object)
                If (IsDBNull(value) Or value Is Nothing Or IsNothing(value)) Then
                    _intRowStatus = Nothing
                Else
                    _intRowStatus = If(IsNumeric(value), Convert.ToInt32(value), Nothing)
                End If
            End Set
        End Property


        'Public Function ListAll(Optional args() As String = Nothing) As DataSet

        '    ListAll = Nothing

        '    Try
        '        oService = oComm.GetService()

        '        Dim oDS As DataSet = Nothing
        '        Dim KeyValPair As New List(Of clsCommon.Param)

        '        Dim param As String = String.Empty
        '        KeyValPair.Add(New clsCommon.Param() With {.ParamName = "@LangID", .ParamValue = GetCurrentLanguage(), .ParamMode = "IN"})
        '        If Not (args Is Nothing) Then param = "|" & args(0)

        '        Dim oTuple = oService.GetData(GetCurrentCountry(), "HumDisTestsGet", oComm.KeyValPairToString(KeyValPair) & param)
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
        '        Dim oTuple = oService.GetData(GetCurrentCountry(), "HumDisTestsGet", oComm.KeyValPairToString(KeyValPair) & param)
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
        'Public Sub SerializeListToXmlFile(ByRef oList As List(Of clsHumanDiseaseTest), fileName As String)
        '    'Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(oList.GetType())
        '    Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseTest)))
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
        'Public Sub HydrateListFromXmlFile(ByRef oList As List(Of clsHumanDiseaseTest), FileName As String)
        '    Dim oSerializer As System.Xml.Serialization.XmlSerializer = New System.Xml.Serialization.XmlSerializer(GetType(List(Of clsHumanDiseaseTest)))
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






