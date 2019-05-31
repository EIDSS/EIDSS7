--=====================================================================================================
-- Name: USP_REF_UPDATEREFERENCEDEDITORLINKS_SET
-- Description:	Saves the url for reference editor pages
--							
-- Author: Ricky Moss.
-- Revision History:
-- Name             Date		Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2019/01/11	Initial Release
-- Ricky Moss		2019/01/29	Updated for new references to be added to the navigation menu
-- Ricky Moss		2019/02/14	Updated for new references to be added to the navigation menu
-- Test Code:
-- exec USP_REF_UPDATEREFERENCEDEDITORLINKS_SET
-- 
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_UPDATEREFERENCEDEDITORLINKS_SET]
AS
BEGIN
	BEGIN TRY
		UPDATE trtBaseReference SET strDefault = 'Species Types' WHERE idfsBaseReference = 10506073
		UPDATE trtBaseReference SET strDefault = 'Report Disease Groups' WHERE idfsBaseReference = 10506075
		UPDATE lkupEIDSSAppObject SET PageLink = '/System/Administration/ReferenceEditors/ReportDiagnosisGroup.aspx' WHERE AppObjectNameID = 10506075
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END