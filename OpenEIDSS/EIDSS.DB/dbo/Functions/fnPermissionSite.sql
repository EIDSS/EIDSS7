
--##SUMMARY Returns id of site to which all permissions shall be linked.
--##SUMMARY According new concept permissions are created for single site and all permission objects use these permissions on any site. 
--##SUMMARY By default returns reference to BV site.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.04.2016

--##RETURNS id of site to which all permissions shall be linked


/*
--Example of function call:
SELECT dbo.fnPermissionSite()

*/
CREATE FUNCTION [fnPermissionSite]()
RETURNS BIGINT
AS
BEGIN
	RETURN 1
END

