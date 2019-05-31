


--##SUMMARY Checks if Session object can be deleted.
--##SUMMARY This procedure is called from AS Sessions list.
--##SUMMARY We consider that session can be deleted if there no samples this session.


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.06.2010

--##RETURNS 0 if session can't be deleted 
--##RETURNS 1 if session can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spASSession_CanDelete @ID, @Result OUTPUT

Print @Result

*/


CREATE   procedure [dbo].[spASSession_CanDelete]
	@ID as bigint --##PARAM @ID - farm ID
	,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if session can't be deleted, 1 in other case
as

IF EXISTS(
SELECT tlbAnimal.idfAnimal
FROM tlbAnimal
	Inner Join tlbMaterial ON 
		tlbMaterial.idfAnimal = tlbAnimal.idfAnimal and tlbMaterial.intRowStatus=0
	WHERE
		tlbMaterial.idfMonitoringSession = @ID and
		tlbAnimal.intRowStatus=0
	)
	SET @Result = 0
ELSE
	SET @Result = 1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spASSession_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

Return @Result


