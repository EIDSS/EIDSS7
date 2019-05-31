
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/11/2017
-- Last modified by:		Joan Li
-- Description:				Getting info from tstSecurityConfiguration table: returns native dataset
--                          04/11/2017: add languageID input paramter
-- Testing code:
/*
----testing code:

DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_SecurityGetConfig]
		@LangID = N'en'
SELECT	'Return Value' = @return_value
GO
*/
--=====================================================================================================
CREATE PROCEDURE [dbo].[usp_SecurityGetConfig]
		@LangID nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select		PolicyList.*,
				[Level].name as SecurityLevel
	from		fnPolicyValue() PolicyList
	left join	fnReference('en',19000119) [Level]
	on			[Level].idfsReference=PolicyList.idfsSecurityLevel
END

