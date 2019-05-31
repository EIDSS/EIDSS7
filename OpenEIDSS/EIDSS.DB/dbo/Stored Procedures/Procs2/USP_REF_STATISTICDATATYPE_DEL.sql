--=====================================================================================================
-- Name: USP_REF_STATISTICDATATYPE_DEL
-- Description:	Removes a statistic data type from the active list
--							
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/10/12 Initial Release
-- Ricky Moss		12/13/2018	Removed the return code
-- 
-- Test Code:
-- exec USP_REF_STATISTICDATATYPE_DEL 55615180000061
-- 
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_STATISTICDATATYPE_DEL]
(
	@idfsStatisticDataType BIGINT,
	@deleteAnyway BIT
)
AS
BEGIN
	BEGIN TRY
	DECLARE @returnCode					INT = 0 
	DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
	IF NOT EXISTS(select idfsStatisticDataType from tlbStatistic where idfsStatisticDataType = @idfsStatisticDataType and intRowStatus = 0) OR @deleteAnyway = 1
	BEGIN
		UPDATE trtStatisticDataType SET intRowStatus = 1 
			WHERE idfsStatisticDataType = @idfsStatisticDataType
			and intRowStatus = 0

		UPDATE trtBaseReference SET intRowStatus = 1 
			WHERE idfsBaseReference = @idfsStatisticDataType
			AND intRowStatus = 0

		UPDATE trtStringNameTranslation SET intRowStatus = 1
			WHERE idfsBaseReference = @idfsStatisticDataType
	END
	ELSE IF	EXISTS(select idfsStatisticDataType from tlbStatistic where idfsStatisticDataType = @idfsStatisticDataType and intRowStatus = 0)
	BEGIN
		SELECT @returnCode = -1
		SELECT @returnMsg = 'IN USE'
	END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END