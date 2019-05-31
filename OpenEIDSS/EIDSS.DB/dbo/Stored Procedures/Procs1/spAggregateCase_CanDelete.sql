
--##SUMMARY Checks if AggregateCase object can be deleted.

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 27.05.2015

--##RETURNS 0 if case can't be deleted 
--##RETURNS 1 if case can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spAggregateCase_CanDelete @ID, @Result OUTPUT

Print @Result

*/

CREATE PROCEDURE [dbo].[spAggregateCase_CanDelete]( 
	@ID AS BIGINT,--##PARAM  @ID - Aggregate case ID
	@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
)
as


SET @Result = 1

DECLARE @DataValidationResult INT	
DECLARE @AggregateCaseType BIGINT
SELECT 
	@AggregateCaseType = idfsAggrCaseType
FROM tlbAggrCase 
WHERE idfAggrCase = @ID

IF @AggregateCaseType = 10102001 /*Human Aggregate Case*/
	EXEC @DataValidationResult = spHumanAggregateCase_Validate @ID
ELSE 
	IF @AggregateCaseType = 10102002 /*Vet Aggregate Case*/
		EXEC @DataValidationResult = spVetAggregateCase_Validate @ID
	ELSE 
		IF @AggregateCaseType = 10102003 /*Vet Aggregate Action*/
			EXEC @DataValidationResult = spVetAggregateAction_Validate @ID
	
IF @DataValidationResult <> 0
	SET @Result = 0

RETURN @Result
