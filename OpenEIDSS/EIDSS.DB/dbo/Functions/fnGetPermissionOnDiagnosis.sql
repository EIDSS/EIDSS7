


CREATE FUNCTION [dbo].[fnGetPermissionOnDiagnosis](
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
	td.idfsDiagnosis
	, COALESCE(
				MIN(InstanceUser.intPermission)
				, MIN(TypeUser.intPermission)
				, MIN(InstanceDefault.intPermission)
				, MIN(TypeDefault.intPermission)
				, 2
				) intPermission
FROM trtDiagnosis td
--user rights on instance
LEFT JOIN dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, @ObjectOperation, @Employee, 1) InstanceUser ON
	InstanceUser.idfsObjectID = td.idfsDiagnosis
--user rights on Type
LEFT JOIN dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, @ObjectOperation, @Employee, 0) TypeUser ON 
	1 = 1
--default rights on instance
LEFT JOIN dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, @ObjectOperation, -1, 1) InstanceDefault ON
	InstanceDefault.idfsObjectID = td.idfsDiagnosis
--default rights on Type
LEFT JOIN dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, @ObjectOperation, -1, 0) TypeDefault ON 
	1 = 1
WHERE td.intRowStatus = 0
GROUP BY td.idfsDiagnosis



