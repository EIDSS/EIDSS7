


--##SUMMARY Checks if Farm object can be deleted.
--##SUMMARY This procedure is called from farms list and thus can be applied to the root farms only.
--##SUMMARY We consider that farm can be deleted if there no child farms related to the case, i. e if farm is created directly from farms list
--##SUMMARY and no cases refer to this farm.


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##RETURNS 0 if farm can't be deleted 
--##RETURNS 1 if farm can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spFarm_CanDelete @ID, @Result OUTPUT

Print @Result

*/


CREATE   procedure [dbo].[spFarm_CanDelete]
	@ID as bigint --##PARAM @ID - farm ID
	,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
as

IF EXISTS(SELECT * FROM tlbFarm 
		INNER JOIN tlbVetCase ON tlbVetCase.idfFarm = tlbFarm.idfFarm WHERE idfFarmActual = @ID AND tlbFarm.intRowStatus = 0 AND tlbVetCase.intRowStatus = 0)
	OR EXISTS(SELECT * FROM tlbFarm 
		INNER JOIN tlbMonitoringSession ON tlbMonitoringSession.idfMonitoringSession = tlbFarm.idfMonitoringSession WHERE idfFarmActual = @ID AND tlbFarm.intRowStatus = 0 AND tlbMonitoringSession.intRowStatus = 0)
	SET @Result = 0
ELSE
	SET @Result = 1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spFarmActual_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

Return @Result


