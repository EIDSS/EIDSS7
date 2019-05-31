
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/07/2017
-- Last modified by:		Joan Li
-- Description:				06/07/2017:Created based on V6 spSettlement_CanDelete: rename for V7 USP46
--                          Checking records in the following:
--                          tables: gisSettlement;tlbGeoLocation;tlbMonitoringSession
--     
-- Testing code:
/*
DECLARE	@return_value int,
		@Result bit
EXEC	@return_value = [dbo].[usp_Settlement_CanDelete]
		@ID = 55690000000,
		@Result = @Result OUTPUT
Select @Result
*/
--=====================================================================================================


CREATE   procedure [dbo].[usp_Settlement_CanDelete]
	@ID as bigint --##PARAM
	,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
As

IF EXISTS (SELECT 0 from dbo.gisSettlement WHERE idfsSettlement = @ID and blnIsCustomSettlement <> 1 )
	SET @Result = 0
ELSE IF EXISTS (SELECT 0 from dbo.tlbGeoLocation WHERE idfsSettlement = @ID and intRowStatus = 0)
	SET @Result = 0
--It seems this is extra checks (Mike)
--ELSE IF EXISTS (SELECT 0 from dbo.tlbPostalCode WHERE idfsSettlement = @ID and intRowStatus = 0)
--	SET @Result = 0
--ELSE IF EXISTS (SELECT 0 from dbo.tlbStreet WHERE idfsSettlement = @ID and intRowStatus = 0)
--	SET @Result = 0
ELSE IF EXISTS (SELECT 0 from dbo.tlbMonitoringSession WHERE idfsSettlement = @ID and intRowStatus = 0)
	SET @Result = 0
ELSE	
	SET @Result = 1

Return @Result



