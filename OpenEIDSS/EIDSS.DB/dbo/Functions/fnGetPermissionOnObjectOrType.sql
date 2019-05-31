
--##SUMMARY Returns list of fixed permission for specified object type.
--##SUMMARY Returns permission for specified object type itself if @IsObject = 0.

--##REMARKS Updated by: Zhdanova A.
--##REMARKS Date of update: 11.10.2011


--##RETURNS Returns list of fixed permission.



/*
select * from dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, null, null, 1) 
select * from dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, null, null, 0) 
select * from dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, null, -1, 1) 
select * from dbo.fnGetPermissionOnObjectOrType(10060001 /*objDiagnosis*/, null, -1, 0)
*/

CREATE FUNCTION [dbo].[fnGetPermissionOnObjectOrType](
	@ObjectType BIGINT
	, @ObjectOperation BIGINT
	, @Employee BIGINT
	, @IsObject BIT
)
RETURNS TABLE 
AS
RETURN
/* test
DECLARE @ObjectType BIGINT
DECLARE @ObjectOperation BIGINT
DECLARE @Employee BIGINT
DECLARE @IsObject BIT

SET @ObjectType = 10060001 /*objDiagnosis*/
SET @Employee = 3
SET @IsObject = 1
*/
	
SELECT		
	toa.idfsObjectID
	, toa.intPermission
FROM tstObjectAccess AS toa
JOIN fn_ObjectActorRelations(
								ISNULL(@Employee, 
										(SELECT 
											tut.idfPerson
										FROM tstUserTable tut 
										WHERE tut.idfUserID = dbo.fnUserID())
										)
							) Groups ON
								Groups.idfEmployee = toa.idfActor
WHERE toa.intRowStatus = 0
	AND toa.idfsOnSite=dbo.fnPermissionSite()
	AND toa.idfsObjectOperation = ISNULL(@ObjectOperation, 10059003/*Read*/)
	AND toa.idfsObjectType = @ObjectType
	AND (
			(@IsObject = 1 AND (toa.idfsObjectID IS NOT NULL AND NOT toa.idfsObjectID = toa.idfsObjectType))
			OR
			(@IsObject = 0 AND (toa.idfsObjectID IS NULL OR toa.idfsObjectID = toa.idfsObjectType))
		)



