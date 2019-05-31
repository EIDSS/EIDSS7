

CREATE FUNCTION [dbo].[fnPolicyDefaultValue]
(
	@ID nvarchar(200)
)
RETURNS int
AS
BEGIN

	if @ID='AccountLockTimeout' return 15

	if @ID='AccountTryCount' return 3

	if @ID='PasswordAge' return 90

	if @ID='PasswordHistoryLength' return 3

	if @ID='PasswordMinimalLength' return 5

	if @ID='InactivityTimeout' return 15
	
	if @ID='ForcePasswordComplexity' return 0

	return null
END


