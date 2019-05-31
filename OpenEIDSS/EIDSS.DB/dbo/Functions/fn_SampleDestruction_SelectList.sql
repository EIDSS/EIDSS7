

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011

create FUNCTION [dbo].[fn_SampleDestruction_SelectList]
(	
	@LangID nvarchar(20)
)
RETURNS TABLE 
AS
RETURN 
(
	select
				tlbMaterial.idfMaterial,
				tlbMaterial.strBarcode,
				tlbMaterial.idfsSampleStatus,
				ST.name as strSampleName,
				tlbMaterial.idfsSampleType,
				tlbMaterial.idfsDestructionMethod,
				DM.name as DestructionMethod
	from		tlbMaterial
	left join	fnReferenceRepair(@LangID,19000087) ST --rftSampleType
	on			ST.idfsReference=tlbMaterial.idfsSampleType
	left join	fnReferenceRepair(@LangID,19000157) DM--rftDestructionMethod
	on			DM.idfsReference=tlbMaterial.idfsDestructionMethod
	JOIN fnGetPermissionOnSample(NULL, NULL) GetPermission ON
		GetPermission.idfMaterial = tlbMaterial.idfMaterial
		AND GetPermission.intPermission = 2
	where		tlbMaterial.idfsSampleStatus = 10015003 and--RoutineDestruction
				tlbMaterial.idfsCurrentSite=dbo.fnSiteID()

)

