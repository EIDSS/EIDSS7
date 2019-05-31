
--*************************************************************
-- Name 				: USP_GBL_MENU_GETList
-- Description			: SELECTs data for Active Surveillance Campaign form
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name			Date		Change Detail
--		Mandar Kulkarni	20180906	Created
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_MENU_GETList]
(  
	@idfUserId					BIGINT,
 	@LangID						NVARCHAR(50) = 'EN'	--##PARAM @LangID - language ID  
)  
AS  
DECLARE @idfPerson				BIGINT
DECLARE @returnMsg				VARCHAR(MAX) = 'Success'
DECLARE @returnCode				BIGINT = 0
DECLARE @RoleId					BIGINT
DECLARE @idfsLangId				BIGINT

BEGIN
	--Set LangId Code
	SET @idfsLangId = (SELECT dbo.FN_GBL_LanguageCode_GET(@LangID))

	BEGIN TRY  	
		--	Get the person id for the logged in user
		SET	@idfPerson = (SELECT	a.idfPerson
							FROM	dbo.tstUserTable a
							INNER JOIN dbo.tstSite b
							ON		a.idfsSite = b.idfsSite
							WHERE	a.idfUserId = @idfUserId
							AND		a.intRowStatus = 0	-- Check if user is active
							AND		b.intRowStatus = 0  -- Check if site is active
						)

		-- If active site or person is not found
		IF @idfPerson IS NULL 
			BEGIN
				SET	@returnCode = 10
				SET @returnMsg = 'Either the Site or the User is not active'
			END
		ELSE
			-- Get the all the me menu options for every role that user is associated with.
			BEGIN
				SELECT	a.idfsBaseReference, 
						ISNULL(b.strTextString, a.strDefault) AS MenuName, 
						a.idfsReferenceType,
						f.EIDSSMenuID AS EIDSSMenuId,
						ISNULL(f.EIDSSParentMenuID,f.EIDSSMenuID) AS EIDSSParentMenuId,
						g.PageName,
						g.PageTitleID,
						g.PageLink, 
						g.ExceptionControlList,
						g.DisplayOrder,
						ISNULL(g.IsOpenInNewWindow, 0) AS IsOpenInNewWindow,
						g.AppModuleGroupList
				FROM	dbo.trtBaseReference a
				INNER JOIN dbo.LkupEIDSSMenu f ON f.EIDSSMenuID = a.idfsBaseReference AND f.intRowStatus = 0
				INNER JOIN dbo.LkupEIDSSAppObject g on f.EIDSSMenuID = g.AppObjectNameID AND g.intRowStatus = 0 
				LEFT OUTER JOIN dbo.trtStringNameTranslation b ON b.idfsBaseReference = a.idfsBaseReference AND b.intRowStatus = 0 AND b.idfsLanguage = @idfsLangId
				WHERE	a.intRowStatus = 0
				AND		a.idfsReferenceType = 19000506
				AND		a.idfsBaseReference IN (
												SELECT c.EIDSSMenuID 
												FROM	dbo.LkupRoleMenuAccess C
												WHERE	c.intRowStatus = 0 
												AND		c.RoleID IN (
																		SELECT d.idfsEmployeeGroupName
																		FROM	dbo.tlbEmployeeGroup d
																		INNER JOIN dbo.tlbEmployeeGroupMember e ON e.idfEmployeeGroup = d.idfEmployeeGroup and e.intRowStatus = 0
																		WHERE e.idfEmployee = @idfPerson
																		AND  d.intRowStatus = 0
																	)
												)
				--AND (Pagelink <> '#' OR EIDSSMenuId = EIDSSParentMenuId)
				ORDER BY EIDSSParentMenuId, EIDSSMenuId
			END
					

		--return the result set if success
		SELECT	@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
			SET	@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
							+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
							+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
							+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
							+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
							+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SET	@returnCode = ERROR_NUMBER();
			SELECT	@returnCode, @returnMsg;
	END CATCH
END


