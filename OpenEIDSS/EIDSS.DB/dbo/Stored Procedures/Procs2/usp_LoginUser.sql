
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/10/2017
-- Last modified by:		Joan Li
-- Description:				4/10/2017: Created baseed on V6 spLoginUser: add one input parameter
/*
----testing code:

DECLARE	@return_value int,
		@Result int
EXEC	@return_value = [dbo].[usp_LoginUser]
		@UserName = N'admin',
		@Password = 0x123,
		@indContextN = N'N',
		@Result = @Result OUTPUT
SELECT	@Result as N'@Result'
SELECT	'Return Value' = @return_value
GO

*/
--=====================================================================================================
--##SUMMARY Performs login to the system.
--##SUMMARY Login uses @Organization, @UserName, @Password
--##SUMMARY Password encoded using Challenge value returned by spLoginChallenge
--##SUMMARY After successfull login current connection context is assotiated with @ClientID and user defined by login.

--##REMARKS Author: Kletkin
--##REMARKS Create date: 31.05.2010

--##RETURNS @Result parameter returns the extended error Code
--##RETURNS 		0 - No errors
--##RETURNS 		2 - User with such login/password is not found
--##RETURNS 		6 - Login is locked after 3 unsuccessfull login attempt. 

/*
--Example of procedure call:
*/

CREATE PROCEDURE [dbo].[usp_LoginUser]
	@UserName AS NVARCHAR(200),--##PARAM @UserName - user login
	@Password AS varbinary(max) = NULL,--##PARAM @Password - user password
	@indContextN as varchar(10) =NULL,
	@Result as int output
AS
BEGIN

	declare @UserID bigint

	exec usp_LoginUserInternal @UserName,@Password, NULL, @indContextN, @Result output,@UserID output

	return

END
