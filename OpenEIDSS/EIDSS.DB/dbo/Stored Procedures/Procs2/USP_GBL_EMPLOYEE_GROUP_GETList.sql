
-- ============================================================================
-- Name: USP_GBL_EMPLOYEE_GROUP_GETList
-- Description:	Get employee group list for verifying user permissions.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/30/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_EMPLOYEE_GROUP_GETList] 
(
	@LangID									NVARCHAR(50)
)
AS
BEGIN
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;

	BEGIN TRY  	
		SELECT								eg.idfEmployeeGroup,
											eg.idfsEmployeeGroupName,
											e.idfEmployee,
											ISNULL(groupName.name,eg.strName) AS strName,
											eg.strDescription
		FROM								dbo.tlbEmployeeGroup eg
		INNER JOIN							dbo.tlbEmployee e ON 
											e.idfEmployee = eg.idfEmployeeGroup
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000022) groupName ON groupName.idfsReference = eg.idfsEmployeeGroupName
		WHERE								e.intRowStatus = 0 
		AND									eg.idfEmployeeGroup <> -1 
		AND									eg.intRowStatus = 0;

		SELECT								@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET								@returnCode = ERROR_NUMBER();
			SET								@returnMsg = 
											'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
											+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
											+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
											+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
											+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
											+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT							@returnCode, @returnMsg;
		END
	END CATCH;
END
