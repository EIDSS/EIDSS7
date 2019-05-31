
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/18/2017
-- Last modified by:		Joan Li
-- Description:				Created based on V6 spsysBaseReference_Delete : rename for V7
-- Testing code:
/*
----testing code:
DECLARE @idfsBaseReference bigint
EXECUTE usp_sysBaseReference_Delete
  @idfsBaseReference
*/

--=====================================================================================================
--##SUMMARY Deletes base reference record and all low level related records
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 23.01.2010
--##RETURNS Doesn't use


CREATE     PROCEDURE [dbo].[usp_sysBaseReference_Delete] 

	@idfsBaseReference BIGINT --##PARAM @idfsBaseReference - diagnosis ID

AS

BEGIN

		DELETE FROM trtBaseReferenceToCP 
		WHERE idfsBaseReference = @idfsBaseReference



		DELETE FROM trtStringNameTranslation 
		WHERE idfsBaseReference = @idfsBaseReference



		DELETE FROM trtBaseReference 
		WHERE idfsBaseReference = @idfsBaseReference



END










