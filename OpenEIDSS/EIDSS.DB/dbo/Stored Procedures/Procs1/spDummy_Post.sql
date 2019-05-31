

--##SUMMARY Fake post procedure that should be assigned to object that should not be posted itself but have postable related objects

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.11.2011

--##RETURNS Doesn't use

/*
Example of procedure call:


EXECUTE spDummy_Post 

*/
CREATE PROCEDURE [dbo].[spDummy_Post]
AS

RETURN 0
