
--##SUMMARY Checks if the aggregate case record with passed parameters exists

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 5.5.2012

--##RETURNS Returns 1 if freezer with given name doesn't exist on current site
--##RETURNS			0 in other case


/*
--Example of procedure call:

DECLARE @Result int
EXECUTE @Result = spFreezer_ValidateName
	1
	,'FreezerName'
Print @Result
*/

CREATE PROCEDURE [dbo].[spFreezer_ValidateName]
	@idfFreezer bigint, 
	@strFreezerName nvarchar(200)
AS
	if EXISTS (SELECT idfFreezer FROM tlbFreezer WHERE idfFreezer<>@idfFreezer AND strFreezerName=@strFreezerName AND idfsSite = dbo.fnSiteID())
		RETURN 0
RETURN 1
