
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatistic_Delete:  V7 usp53
--                          Delete statistic record from table:tlbStatistic
/*
----testing code:
DECLARE @idfStatistic BIGINT
EXECUTE spStatistic_Delete @idfStatistic
*/
--=====================================================================================================

CREATE                 PROCEDURE [dbo].[usp_Statistic_Delete](
	@ID AS BIGINT
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN

	DELETE FROM tlbStatistic
	WHERE idfStatistic = @ID

	Select @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
END