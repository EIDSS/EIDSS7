


CREATE FUNCTION [dbo].[fnGetPermissionOnSite](
	@ObjectOperation BIGINT
	, @Employee BIGINT
)
RETURNS TABLE 
AS
RETURN
/* test
DECLARE @ObjectOperation BIGINT
DECLARE @Employee BIGINT

SET @Employee = 3
*/


SELECT
	ts.idfsSite
	, COALESCE(
				MIN(InstanceUser.intPermission)
				, MIN(TypeUser.intPermission)
				, MIN(InstanceDefault.intPermission)
				, MIN(TypeDefault.intPermission)
				, 2
				) intPermission
FROM tstSite ts
--user rights on instance
LEFT JOIN dbo.fnGetPermissionOnObjectOrType(10060011 /*objSite*/, @ObjectOperation, @Employee, 1) InstanceUser ON
	InstanceUser.idfsObjectID = ts.idfsSite
--user rights on Type
LEFT JOIN dbo.fnGetPermissionOnObjectOrType(10060011 /*objSite*/, @ObjectOperation, @Employee, 0) TypeUser ON
	1 = 1
--default rights on instance
LEFT JOIN dbo.fnGetPermissionOnObjectOrType(10060011 /*objSite*/, @ObjectOperation, -1, 1) InstanceDefault ON
	InstanceDefault.idfsObjectID = ts.idfsSite
--default rights on Type
LEFT JOIN  dbo.fnGetPermissionOnObjectOrType(10060011 /*objSite*/, @ObjectOperation, -1, 0) TypeDefault ON
	1 = 1
WHERE ts.intRowStatus = 0
GROUP BY ts.idfsSite



