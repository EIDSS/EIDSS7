--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 spHumanCase_Validate :  V7 USP71
--                          validate humancase: calling spHumanCase_ValidateForeignKeys: 0:valid; 1:invalide
--                          spHumanCase_ValidateForeignKeys calling :spValidateForeignKeys
--                          spValidateForeignKeys is the last one SP already in EIDSS7
/*
----testing code:
DECLARE @ID bigint
DECLARE @Result BIT
EXEC @Result = spHumanCase_Validate @ID
Print @Result
----related fact data from
select * from tlbhumancase
*/
--=====================================================================================================

CREATE PROCEDURE [dbo].[usp_HumanCase_Validate]
	@RootId BIGINT	--##PARAM @RootId - HumanCase ID
AS
	----EXEC spHumanCase_ValidateForeignKeys @RootId  ----JL: will retired this one at then end of development to make sure the retirement will not cause an issue

	EXEC usp_ValidateForeignKeys 'tlbHumanCase', @RootId, 'Human Case'
	IF (SELECT @@ROWCOUNT) > 0
		RETURN 1

	RETURN 0


