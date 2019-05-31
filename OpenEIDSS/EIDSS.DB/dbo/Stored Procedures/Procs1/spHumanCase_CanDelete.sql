

--##SUMMARY Checks if a human case could be deleted.
--##SUMMARY This procedure is called before the deletion of the case. Case can only be deleted when the procedure allows it.
--##SUMMARY The case is allowed to delete, if it has In Progress status and does not contain any of the materials or tests, and is not included in the outbreak.

--##REMARKS Author: Mirnaya O.
--##REMARKS 
--##REMARKS Update date: 28.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Returns 0 if the case can not be deleted.
--##RETURNS Returns 1 if the case can be deleted.


/*
Example of a call of procedure:
declare @ID bigint
declare @Result bit
exec spHumanCase_CanDelete @ID, @Result output
print @Result
*/



CREATE	procedure	[dbo].[spHumanCase_CanDelete]
( 
	@ID as bigint,--##PARAM  @ID - Human case ID
	@Result as bit output --##PARAM  @Result 0 if the case can not be deleted, 1 - otherwise
)
as
if	exists	(
		SELECT
			*
		FROM tlbMaterial tm
		WHERE tm.idfHumanCase = @ID
			AND tm.intRowStatus = 0
			)
		or exists	(
		select		*
		from		tlbHumanCase
		INNER JOIN	tlbMaterial
		ON			tlbMaterial.idfHumanCase = tlbHumanCase.idfHumanCase
					AND tlbMaterial.intRowStatus = 0
		inner join	tlbTesting
		on			tlbTesting.idfTesting = tlbMaterial.idfMainTest
					and tlbTesting.intRowStatus = 0
		where		tlbHumanCase.idfHumanCase = @ID
					)
		or exists	(
		select		*
		from		tlbVetCase
		INNER JOIN	tlbMaterial
		ON			tlbMaterial.idfVetCase = tlbVetCase.idfVetCase
					AND tlbMaterial.intRowStatus = 0
		inner join	tlbTesting
		on			tlbTesting.idfTesting = tlbMaterial.idfMainTest
					and tlbTesting.intRowStatus = 0
		where		tlbVetCase.idfVetCase = @ID
					)
		or exists	(
		select		*
		from		tlbOutbreak
		inner join	tlbHumanCase
		on			tlbHumanCase.idfOutbreak = tlbOutbreak.idfOutbreak
					and tlbHumanCase.idfHumanCase = @ID
		where		tlbOutbreak.intRowStatus = 0
					)
		or exists	(
		select		*
		from		tlbOutbreak
		inner join	tlbVetCase
		on			tlbVetCase.idfOutbreak = tlbOutbreak.idfOutbreak
					and tlbVetCase.idfVetCase = @ID
		where		tlbOutbreak.intRowStatus = 0
					)
		or exists	(
		select		*
		from		tlbVetCase
		where		tlbVetCase.idfsCaseProgressStatus = 10109002	-- Closed
					and tlbVetCase.idfVetCase = @ID
					AND tlbVetCase.intRowStatus = 0
					)
		or exists	(
		select		*
		from		tlbHumanCase
		where		tlbHumanCase.idfsCaseProgressStatus = 10109002	-- Closed
					and tlbHumanCase.idfHumanCase = @ID
					AND tlbHumanCase.intRowStatus = 0
					)
	set @Result = 0
else
	set @Result = 1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spHumanCase_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

return @Result





