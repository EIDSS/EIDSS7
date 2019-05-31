
CREATE PROCEDURE [dbo].[spSystemPreferences_SelectDetail]
AS
	SELECT 
		ISNULL(CAST(1 as bigint),1) as idfSystemPreferences,
		CAST(0 as int) as intListGridPageSize,
		CAST(0 as int) as intPopupGridPageSize,
		CAST(0 as int) as intDetailGridPageSize,
		CAST(0 as int) as intLabSectionPageSize,
		CAST(0 as bit) as blnDefaultRegion,
		CAST(0 as int) as intDefaultDays,
		CAST(0 as bit) as blnFilterByDiagnosis,
		CAST(0 as bit) as blnPrintMapInVetInvestigationForm,
		CAST(0 as bit) as blnShowWharningForFinalCaseDefinition

