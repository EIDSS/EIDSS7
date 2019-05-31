

--##SUMMARY Checks if vet case can be deleted.
--##SUMMARY This procedure is called before case deleting. Case is deleted only if procedure enables this.
--##SUMMARY Now we consider that case can be deleted only if it contains no important information:
--##SUMMARY  - Case farm contains no species/animal (and thus no specimens too)
--##SUMMARY  - Case has no attached tests 
--##SUMMARY  - Case has no vaccination records
--##SUMMARY  - Case has no case log records
--##SUMMARY  - No outbreaks refer this case
--##SUMMARY  - There is no control measures records related with case

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 4.12.2009

--##RETURNS 0 if case can't be deleted 
--##RETURNS 1 if case can be deleted 
		
--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

/*
Example of procedure call:

--DECLARE @ID bigint
--DECLARE @Result bit
--EXEC spVetCase_CanDelete @ID, @Result OUTPUT
--Print @Result

*/




CREATE            PROCEDURE [dbo].[spVetCase_CanDelete]( 
	@ID AS BIGINT,--##PARAM  @ID - Vet case ID
	@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
)
as


if (exists	(
	SELECT		*
	FROM		tlbSpecies 
	INNER JOIN	dbo.tlbHerd ON
		tlbHerd.idfHerd = tlbSpecies.idfHerd
		AND tlbHerd.intRowStatus=0  
	INNER JOIN	dbo.tlbFarm ON
		tlbFarm.idfFarm = tlbHerd.idfFarm
		AND tlbFarm.intRowStatus=0  
	INNER JOIN dbo.tlbVetCase ON
		tlbVetCase.idfFarm = tlbFarm.idfFarm
	WHERE		tlbVetCase.idfVetCase = @ID 
				AND tlbSpecies.intRowStatus=0  
			)
	OR
	exists	(
		select		*
		from		tlbPensideTest
		INNER JOIN dbo.tlbMaterial ON
			tlbMaterial.idfMaterial = tlbPensideTest.idfMaterial
			AND tlbMaterial.intRowStatus = 0
		where		(tlbMaterial.idfHumanCase = @ID OR tlbMaterial.idfVetCase = @ID) and tlbPensideTest.intRowStatus=0
			)
	OR
	exists	(
		select		*
		from		tlbVaccination
		where		idfVetCase = @ID and intRowStatus=0
			)
	OR
	exists	(
		select		*
		from		tlbVetCaseLog
		where		idfVetCase = @ID and intRowStatus=0
			)
	OR
	exists	(
		select		*
		from		tlbTesting
		INNER JOIN dbo.tlbMaterial ON
			tlbMaterial.idfMaterial = tlbTesting.idfMaterial
			AND tlbMaterial.intRowStatus = 0
		where		(tlbMaterial.idfHumanCase = @ID OR tlbMaterial.idfVetCase = @ID) and tlbTesting.intRowStatus=0		
			)
	OR
	exists	(
		select		*
		from		tlbHumanCase
		inner join	tlbOutbreak ON
					tlbOutbreak.idfOutbreak = tlbHumanCase.idfOutbreak
					and tlbOutbreak.intRowStatus = 0
		where		idfHumanCase = @ID and tlbHumanCase.intRowStatus=0
			)
	OR
	exists	(
		select		*
		from		tlbVetCase
		inner join	tlbOutbreak ON
					tlbOutbreak.idfOutbreak = tlbVetCase.idfOutbreak
					and tlbOutbreak.intRowStatus = 0
		where		idfVetCase = @ID and tlbVetCase.intRowStatus=0
			)
	OR
	exists	(
		select		*
		from		dbo.tlbActivityParameters
		INNER JOIN tlbVetCase ON
			tlbVetCase.idfObservation = tlbActivityParameters.idfObservation
		where	idfVetCase = @ID and tlbActivityParameters.intRowStatus=0 and (varValue IS NOT NULL OR CAST(varValue AS NVARCHAR) <> N'')
			)
)
		
	set @Result=0

else
	set @Result=1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spVetCase_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

return @Result





