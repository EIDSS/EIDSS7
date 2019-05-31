
-- =============================================
-- Author:		Kletkin
-- Create date: 14.01.2010
-- Description:	Returns list of all system functions with permissions specified for specific user
-- =============================================
/*
exec spEvaluatePermissions 0 70980000000
*/

CREATE PROCEDURE [dbo].[spEvaluatePermissions](
	@idfEmployee bigint
)
AS
BEGIN

select * from fnEvaluatePermissions(@idfEmployee)
END


