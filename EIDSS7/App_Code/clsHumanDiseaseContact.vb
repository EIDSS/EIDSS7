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
    Public Class clsHumanDiseaseContact

        Property idfContactedCasePerson As Int64?
        Property idfsPersonContactType As Int64?
        Property idfHuman As Int64?
        Property idfHumanActual As Int64?
        Property idfHumanCase As Int64?
        Property datDateOfLastContact As DateTime?
        Property strPlaceInfo As String
        Property intRowStatus As Int64?
        Property rowguid As Guid?
        Property strComments As String
        Property strMaintenanceFlag As String
        Property strReservedAttribute As String

        Property strFirstName As String
        Property strSecondName As String
        Property strLastName As String
        Property strContactPersonFullName As String

        Property strPersonContactType As String
        Property datDateOfBirth As DateTime?
        Property ReportedAge As String
        Property ReportedAgeUOMID As Int64?
        Property idfsHumanGender As Int64?
        Property idfCitizenship As Int64?
        Property idfsCountry As Int64?
        Property idfsRegion As Int64?
        Property idfsRayon As Int64?
        Property idfsSettlement As Int64?
        Property strStreetName As String
        Property strPostCode As String
        Property strBuilding As String
        Property strHouse As String
        Property strApartment As String
        Property strContactPhone As String
        Property idfContactPhoneType As Int64?

    End Class

End Namespace