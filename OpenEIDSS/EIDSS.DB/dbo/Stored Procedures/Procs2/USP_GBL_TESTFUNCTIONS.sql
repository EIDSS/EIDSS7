-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE USP_GBL_TESTFUNCTIONS
	-- Add the parameters for the stored procedure here
	 @idfsKey	BIGINT  OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



  
	EXEC [USP_GBL_NEXTKEYID_GET_NO_Result] 'tlbHumanCase', @idfsKey OUTPUT




END
