
--##SUMMARY

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 18.08.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spsysValidateChildren
*/
CREATE PROCEDURE [dbo].[spsysValidateChildren]
AS

	EXEC spASSession_ValidateChildren
