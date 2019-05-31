--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/10/2017
-- Last modified by:		Joan Li
-- Description:				4/10/2017: change name for V7
/*
----testing code:

DECLARE	@return_value int,
		@PasswordHash varbinary(100)
EXEC	@return_value = [dbo].[usp_CalculatePasswordHash]
		@Password = 0x7768617465766572,
		@Challenge = 0x7768617465766572,
		@PasswordHash = @PasswordHash OUTPUT
SELECT	@PasswordHash as N'@PasswordHash'
SELECT	'Return Value' = @return_value
GO
*/
--=====================================================================================================
--##SUMMARY System stores password as binary hash
--##SUMMARY Password that passed to spLoginLogin procedure is encoded using Challenge value returned by spLoginChallenge
--##SUMMARY This procedure encodes password with the same Challenge value as it is done by client application.
--##SUMMARY After encoding password passed to spLoginLogin procedure should be the same as password returned by this procedure .

--##REMARKS Author: Zurin Michael
--##REMARKS Create date: 29.05.2011

--##RETURNS  None

/*
--Example of procedure call:
*/

CREATE PROCEDURE [dbo].[usp_CalculatePasswordHash]
	@Password as varbinary(100),--##PARAM @Password - user password hash
	@Challenge as varbinary(100),--##PARAM @Challenge - the array of bytes that is used to encode @Password
	@PasswordHash as varbinary(100) output--##PARAM @PasswordHash - encoded password value
AS
BEGIN


declare @byte tinyint 
declare @i int
set @i=1
declare @challengepos int
set @challengepos=1
SET @PasswordHash = null
while @i<=DATALENGTH(@Password)
begin
	set @byte=substring(@Password,@i,1)
	set @byte=@byte ^ cast (substring(@Challenge,@challengepos,1) as tinyint)
	
	if (@PasswordHash is null) set @PasswordHash=cast(@byte as varbinary)
	else set @PasswordHash=@PasswordHash+cast(@byte as varbinary)
	set @i=@i+1
	set @challengepos=@challengepos+1
	if @challengepos>DATALENGTH(@Challenge) set @challengepos=1
end

select @PasswordHash=hashbytes('SHA1',@PasswordHash)

END


