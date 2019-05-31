

--##SUMMARY Checks if a human could be deleted.
--##SUMMARY This procedure is called before the deletion of the human. Human can only be deleted when the procedure allows it.
--##SUMMARY The human is allowed to delete, if he isn't a patient or contact person of any case, or a farm owner, and hasn't any specimens or copies.

--##REMARKS Author: Mirnaya O.
--##REMARKS 
--##REMARKS Update date: 22.01.2010

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 08.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Returns 0 if the human can not be deleted.
--##RETURNS Returns 1 if the human can be deleted.


/*
Example of a call of procedure:
declare @ID bigint
declare @Result bit
exec spPatient_CanDelete @ID, @Result output
print @Result
*/



CREATE	procedure	[dbo].[spPatientActual_CanDelete]
( 
	@ID as bigint,			--##PARAM  @ID - Human Id
	@Result as bit output	--##PARAM  @Result 0 if the human can not be deleted, 1 - otherwise
)
as
if	exists	(
			select		*
			from		tlbHumanCase
			inner join	tlbHuman
			on			tlbHuman.idfHuman = tlbHumanCase.idfHuman
						and tlbHuman.idfHumanActual = @ID
						and tlbHuman.intRowStatus = 0
			where		tlbHumanCase.intRowStatus = 0
			)
		or exists	(
			select		*
			from		tlbMaterial
			inner join	tlbHuman
			on			tlbHuman.idfHuman = tlbMaterial.idfHuman
						and tlbHuman.idfHumanActual = @ID
						and tlbHuman.intRowStatus = 0
			where		tlbMaterial.intRowStatus = 0
					)
		or exists	(
			select		*
			from		tlbContactedCasePerson
			inner join	tlbHuman
			on			tlbHuman.idfHuman = tlbContactedCasePerson.idfHuman
						and tlbHuman.idfHumanActual = @ID
						and tlbHuman.intRowStatus = 0
			where		tlbContactedCasePerson.intRowStatus = 0
					)
		or exists	(
			select		*
			from	tlbFarm
			inner join	tlbHuman 
			on			tlbHuman.idfHuman = tlbFarm.idfHuman
						and tlbHuman.idfHumanActual = @ID
						and tlbHuman.intRowStatus = 0
			where tlbFarm.intRowStatus = 0	
					)
		or exists	(
			select		*
			from	tlbFarmActual
			inner join	tlbHumanActual 
			on			tlbHumanActual.idfHumanActual = tlbFarmActual.idfHumanActual
						and tlbHumanActual.idfHumanActual = @ID
						and tlbHumanActual.intRowStatus = 0
			where tlbFarmActual.intRowStatus = 0	
					)
	set @Result = 0
else
	set @Result = 1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spPatientActual_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

return @Result





