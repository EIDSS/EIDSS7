


--##SUMMARY Selects lookup list of organizations for GG vet reports.

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Doesn't use

/*
--Example of procedure call:
exec spRepVetOrganizationSelectLookup 'en', NULL
exec spRepVetOrganizationSelectLookup 'en', 48130000000

*/

CREATE      PROCEDURE [dbo].[spRepVetOrganizationSelectLookup]
	@LangID As nvarchar(50), --##PARAM @LangID - language ID
	@ID as bigint = NULL --##PARAM @ID - organization ID, if not null only record with this organization is selected
AS

SELECT  
	cast(ROW_NUMBER() OVER (ORDER BY tbra.varValue, [name]) as bigint) idfKey
	, Organization.idfOffice AS idfInstitution
	, Organization.[name]
	, Organization.FullName	
	, tbra.varValue as strReportType
	, Organization.intRowStatus
FROM dbo.fnInstitutionRepair(@LangID) Organization
JOIN trtAttributeType tat ON
	tat.strAttributeTypeName = 'attr_department'
JOIN trtBaseReferenceAttribute tbra ON
	tbra.idfAttributeType = tat.idfAttributeType
	AND tbra.idfsBaseReference = Organization.idfsOfficeAbbreviation
WHERE Organization.idfOffice = ISNULL(@ID, Organization.idfOffice)
--ORDER BY Organization.name
