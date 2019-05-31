----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: USP_GBL_BaseReferenceToCP_SET
-- Description			: Insert/Update Base Reference To Customization Pkg 
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
-- Mark Wilson    10-Nov-2017   Convert EIDSS 6 to EIDSS 7 standards and 
--                              converted table name to USP_GBL_BaseReferenceToCP_SET
--                              call
--
-- Testing code:

/*
--Example of a call of procedure:
DECLARE @idfsReference bigint
DECLARE @idfCustomizationPackage bigint


EXECUTE USP_GBL_BaseReferenceToCP_SET
   @idfsReference
  ,@idfCustomizationPackage

*/

CREATE PROCEDURE [dbo].[USP_GBL_BaseReferenceToCP_SET] 
	@idfsReference BIGINT, --##PARAM @idfsReference - reference ID
	@idfCustomizationPackage BIGINT --##PARAM @idfCustomizationPackage - Customization Package ID

AS
BEGIN
	IF NOT EXISTS (SELECT * FROM dbo.trtBaseReferenceToCP WHERE idfsBaseReference = @idfsReference AND idfCustomizationPackage = @idfCustomizationPackage)
		INSERT INTO trtBaseReferenceToCP(
				idfsBaseReference,
				idfCustomizationPackage
		)
		Values (
				@idfsReference
			   ,@idfCustomizationPackage
		)

END

