
-- =============================================
-- Author:		Steven Verner
-- Create date: 04.05.2019
-- Description:	Inserts a new user into the ASPNetUser table
-- =============================================
CREATE PROCEDURE [dbo].[USP_ASPNetUser_Set]
	 
	 @id NVARCHAR(128)
	,@idfUserId BIGINT
	,@UserName NVARCHAR(256)
	,@Email NVARCHAR(256) = NULL
	,@EmailConfirmed BIT = false
	,@PasswordHash NVARCHAR(MAX)
	,@SecurityStamp NVARCHAR(MAX)
	,@LockoutEndDateUtc DATETIME
	,@LockoutEnabled BIT
	,@AccessFailedCount INT
AS
		INSERT INTO ASPNetUsers(
		 Id
		,idfUserID
		,Email
		,EmailConfirmed
		,PasswordHash
		,SecurityStamp
		,PhoneNumber
		,PhoneNumberConfirmed
		,TwoFactorEnabled
		,LockoutEndDateUtc
		,LockoutEnabled
		,AccessFailedCount
		,UserName
		)
		VALUES(
		 @Id
		,@idfUserId
		,@Email
		,@EmailConfirmed
		,@PasswordHash
		,@SecurityStamp
		,NULL
		,0
		,0
		,@LockoutEndDateUtc
		,@LockoutEnabled
		,@AccessFailedCount
		,@UserName 
		)
		
	SELECT	
		 Id
		,idfUserID
		,Email
		,EmailConfirmed
		,PasswordHash
		,SecurityStamp
		,PhoneNumber
		,PhoneNumberConfirmed
		,TwoFactorEnabled
		,LockoutEndDateUtc
		,LockoutEnabled
		,AccessFailedCount
		,UserName
	FROM ASPNetUsers 
	WHERE Id = @Id


