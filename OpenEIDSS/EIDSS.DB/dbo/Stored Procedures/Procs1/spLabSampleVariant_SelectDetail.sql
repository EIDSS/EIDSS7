

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE PROCEDURE [dbo].[spLabSampleVariant_SelectDetail] 
	@idfMaterial bigint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT		tlbMaterial.idfMaterial,
				tlbMaterial.strBarcode,
				tlbMaterial.idfInDepartment,
				tlbMaterial.idfsSampleType,
				tlbMaterial.idfSubdivision,
				tlbMaterial.strNote,
				HA.intHACode
	FROM		tlbMaterial
	inner join	fnReference('en', 19000087) HA --rftSpecimenType
	on			tlbMaterial.idfsSampleType=HA.idfsReference

	WHERE tlbMaterial.idfMaterial=@idfMaterial
		AND tlbMaterial.intRowStatus = 0

END

