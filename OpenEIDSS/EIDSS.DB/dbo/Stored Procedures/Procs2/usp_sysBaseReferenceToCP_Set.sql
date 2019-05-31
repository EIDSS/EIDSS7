

--=====================================================================================================
-- Created by:				Joan Li
-- Description:				
-- Revision History
--		Name       Date       Change Detail
--		JL		   04/18/2017 Created based on V6 spsysBaseReferenceToCP_Post:  V7 USP30
--		JL         04/26/2017 usp_BaseReference_SysSet call this passing  reference ID and country ID 
--                                         and code will insert data into table: trtBaseReferenceToCP
--      JL         06/21/2017 there is no action and only insert functional code:only allow insert (revisit if need delete or update )
--                                      table does NOT have triggers handle delete,insert and update; add data modify date and user info
--      JL         05/16/2018 change to valide function FN_GBL_DATACHANGE_INFO
--                                     
-- Testing code:
/*
----testing code:
SELECT * FROM trtBaseReferenceToCP
*/

--=====================================================================================================

CREATE     PROCEDURE [dbo].[usp_sysBaseReferenceToCP_Set] 
	@idfsReference BIGINT, --##PARAM @idfsReference - reference ID
	@idfCustomizationPackage BIGINT --##PARAM @idfCustomizationPackage - Customization Package ID
	,@User VARCHAR(100)=NULL  --who required data change
AS

BEGIN
	DECLARE @DataChageInfo AS NVARCHAR(MAX)
	SELECT @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)
	IF NOT EXISTS (SELECT * FROM trtBaseReferenceToCP WHERE idfsBaseReference = @idfsReference AND idfCustomizationPackage = @idfCustomizationPackage)
		INSERT INTO trtBaseReferenceToCP(
				idfsBaseReference
			   ,idfCustomizationPackage
               ,strReservedAttribute
		)
		VALUES (
				@idfsReference
			   ,@idfCustomizationPackage
			   ,@DataChageInfo
		)

END


