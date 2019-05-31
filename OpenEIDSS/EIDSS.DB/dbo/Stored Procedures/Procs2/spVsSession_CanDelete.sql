


--##SUMMARY Checks if VS Session object can be deleted.
--##SUMMARY This procedure is called from VS Sessions list.
--##SUMMARY We consider that session can be deleted if there no vectors and samples this session.


--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 18.07.2011

--##RETURNS 0 if session can't be deleted 
--##RETURNS 1 if session can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spVsSession_CanDelete @ID, @Result OUTPUT

Print @Result

*/


CREATE   procedure [dbo].[spVsSession_CanDelete]
	@ID as bigint --##PARAM @ID - Session ID
  ,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if session can't be deleted, 1 in other case
as

IF EXISTS(
            SELECT *
            FROM tlbVector
	            WHERE
		            tlbVector.idfVectorSurveillanceSession = @ID and
		            tlbVector.intRowStatus=0
	 ) OR
   EXISTS	(
            select *
            from tlbMaterial
              where tlbMaterial.idfVectorSurveillanceSession =  @ID and
                    tlbMaterial.intRowStatus=0   
    )
	
	SET @Result = 0
ELSE
	SET @Result = 1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spVsSession_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

Return @Result
