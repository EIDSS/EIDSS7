

CREATE   procedure dbo.spSettlement_CanDelete
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


