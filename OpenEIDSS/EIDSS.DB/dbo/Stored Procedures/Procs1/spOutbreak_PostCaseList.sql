
--##SUMMARY Posts outbreak cases related with outbreak.
--##SUMMARY Called by OutbreakDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.11.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:

DECLARE @Action int
DECLARE @idfOutbreak bigint
DECLARE @idfCase bigint

EXECUTE spOutbreak_PostCaseList
   @Action
  ,@idfOutbreak
  ,@idfCase

*/


CREATE    PROCEDURE dbo.spOutbreak_PostCaseList
	@Action int, --##PARAM @Action - action to be perfomed: 4 - Added, 8 - Deleted, 16 - Modified
	@idfOutbreak bigint, --##PARAM @idfOutbreak - outbreak ID
    @idfCase bigint --##PARAM @idfCase - ID of case related with outbreak
as

	IF @Action = 8 
	BEGIN
		--at the moment of deletion case can be moved to other outbreak in many ways, so we need this check to avoid deletion error
		IF EXISTS(SELECT * FROM tlbHumanCase WHERE idfOutbreak = @idfOutbreak and idfHumanCase = @idfCase) 
		BEGIN
			update tlbHumanCase
			set idfsYNRelatedToOutbreak = null
				, idfOutbreak = null
			WHERE 
				idfOutbreak = @idfOutbreak
				and idfHumanCase = @idfCase
		END
		ELSE IF EXISTS(SELECT * FROM tlbVetCase WHERE idfOutbreak = @idfOutbreak and idfVetCase = @idfCase)		
		BEGIN
			update tlbVetCase
			set idfOutbreak = null
			WHERE 
				idfOutbreak = @idfOutbreak
				and idfVetCase = @idfCase
		END
		ELSE IF EXISTS(SELECT * FROM tlbVectorSurveillanceSession WHERE idfOutbreak = @idfOutbreak and idfVectorSurveillanceSession = @idfCase)		
		BEGIN
			update tlbVectorSurveillanceSession
			set idfOutbreak = null
			WHERE 
				idfOutbreak = @idfOutbreak
				and idfVectorSurveillanceSession = @idfCase
		END

	END
	ELSE 
	BEGIN
		IF EXISTS( SELECT * FROM tlbHumanCase WHERE idfHumanCase = @idfCase)
		BEGIN
			update dbo.tlbHumanCase
			set idfsYNRelatedToOutbreak = 10100001
				, idfOutbreak = @idfOutbreak
			WHERE 
				idfHumanCase = @idfCase and (idfOutbreak is null or idfOutbreak <> @idfOutbreak)
		END			
		ELSE IF EXISTS( SELECT * FROM tlbVetCase WHERE idfVetCase = @idfCase)
		BEGIN
			update tlbVetCase
			set idfOutbreak = @idfOutbreak
			WHERE 
				idfVetCase = @idfCase and (idfOutbreak is null or idfOutbreak <> @idfOutbreak)
			
		END
		ELSE IF EXISTS( SELECT * FROM tlbVectorSurveillanceSession WHERE idfVectorSurveillanceSession = @idfCase)
		BEGIN
			update tlbVectorSurveillanceSession
			set idfOutbreak = @idfOutbreak
			WHERE 
				idfVectorSurveillanceSession = @idfCase and (idfOutbreak is null or idfOutbreak <> @idfOutbreak)
			
		END
	END
	EXEC spOutbreak_CheckPrimaryCase @idfCase, @idfOutbreak




