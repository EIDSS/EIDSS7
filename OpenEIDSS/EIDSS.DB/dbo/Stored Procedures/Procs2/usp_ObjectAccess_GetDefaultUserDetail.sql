--=====================================================================================================
-- Created by:				Joan Li
-- Description:				07/10/2017: Created for  V7 USP85
--                          provide two list of object access: 
--                           first  is for default possible access
--                           second is the object Access list based on userID
--                          from tables: tstObjectAccess,trtSystemFunctionOperation
--                          8/3/2017: fixed glitch of id and type number, add third list with idfsobjectaccess
/*
----testing code:
execute usp_ObjectAccess_GetDefaultUserDetail 3449750000000
execute usp_ObjectAccess_GetDefaultUserDetail -1
*/
--=====================================================================================================



CREATE procedure	[dbo].[usp_ObjectAccess_GetDefaultUserDetail]
(		 @userID 	bigint		--userid in tstObjectAccess table

)
as

--========================================================
--pivot default list of access
--========================================================

	;WITH tbl_ObjectAccess AS
	(
		SELECT idfsObjectType, idfsObjectTypeName,[idfsObjectOperation],[idfsObjectOperationnName],idfsObjectID
		FROM dbo.trtSystemFunctionOperation

	)
	,tbl_PivotedAccess AS
	(
	  SELECT idfsObjectType,idfsObjectTypeName, idfsObjectID, [10059001] AS 'Create',[10059003] AS 'Read',[10059004] AS 'Write', [10059002] AS 'Delete',[10059005] AS 'Execute',[10059006] AS 'Access To Personal Data'
	  FROM tbl_ObjectAccess 
	  PIVOT 
	  ( 
   		MAX(idfsObjectOperation)
		FOR idfsObjectOperation IN([10059001],[10059002],[10059003],[10059004],[10059005],[10059006]) 

	  ) AS p
	)

	SELECT idfsObjectType,
		MAX(idfsObjectTypeName) AS 'idfsObjectTypeName', 
		MAX(idfsObjectID) AS 'idfsObjectID',
		MAX([Create]) AS 'Create', 
		MAX([Read]) AS 'Read',
		MAX([Write]) AS 'Write', 
		MAX([Delete]) AS 'Delete', 
		MAX([Execute]) AS 'Execute', 
		MAX([Access To Personal Data]) AS 'Access To Personal Data'
	FROM tbl_PivotedAccess 
	GROUP BY idfsObjectType
	ORDER BY idfsObjectType
	--========================================================
	--pivot existing user object access status: 2: allow; 1:deny
	--========================================================
	----DECLARE @userID BIGINT
	----SELECT @userID=3449750000000
	;WITH tbl_AllAccess AS 
	(
	  SELECT idfsObjectType, idfsObjectTypeName,MAX(idfsObjectID) AS idfsObjectID
	  FROM trtSystemFunctionOperation GROUP BY idfsObjectType,idfsObjectTypeName
	)
	,tbl_UserAccess AS
	(
		  SELECT [idfActor], [idfObjectAccess], idfsObjectType, idfsObjectID, idfsObjectOperation,intPermission
		FROM tstObjectAccess WHERE idfActor=@userID
	)
	,tbl_PivotedUA AS
	(
	  SELECT [idfActor], [idfObjectAccess], idfsObjectType, idfsObjectID, [10059001] AS 'Create',[10059003] AS 'Read',[10059004] AS 'Write', [10059002] AS 'Delete',[10059005] AS 'Execute',[10059006] AS 'Access To Personal Data'
	  FROM tbl_UserAccess 
	  PIVOT 
	  ( 
   		----MAX(idfsObjectOperation)
		MAX(intPermission)
		FOR idfsObjectOperation IN([10059001],[10059002],[10059003],[10059004],[10059005],[10059006]
		
		) 

	  ) AS p
	)
	,tbl_UserAccessFinal AS
	(
		SELECT 
		idfsObjectID,
		MAX([Create]) AS 'Create', 
		MAX([Read]) AS 'Read',
		MAX([Write]) AS 'Write', 
		MAX([Delete]) AS 'Delete', 
		MAX([Execute]) AS 'Execute', 
		MAX([Access To Personal Data]) AS 'Access To Personal Data'
	  ----,[idfactor] 
		FROM tbl_PivotedUA 
		GROUP BY [idfactor],idfsObjectID
	)

	SELECT a.* 
	,b.[Create]
	,b.[Read] 
	,b.Write
	,b.[Delete]
	,b.[Execute]
	,b.[Access To Personal Data] 
	FROM tbl_AllAccess a
	LEFT OUTER JOIN  tbl_UserAccessFinal b
	ON a.idfsObjectID=b.idfsObjectID
	ORDER BY a.idfsobjecttype

	--========================================================
	--pivot existing user idfsobjectAccessID
	--========================================================
	;WITH tbl_AllAccess2 AS 
	(
	  SELECT idfsObjectType, idfsObjectTypeName,MAX(idfsObjectID) AS idfsObjectID
	  FROM trtSystemFunctionOperation GROUP BY idfsObjectType,idfsObjectTypeName
	)
	,tbl_UserAccess2 AS
	(
		  SELECT [idfActor], [idfObjectAccess], idfsObjectType, idfsObjectID, idfsObjectOperation,intPermission
		FROM tstObjectAccess WHERE idfActor=@userID
	)
	,tbl_PivotedUA2 AS
	(
	  SELECT  idfsObjectType,[idfactor], idfsObjectID, [10059001] ,[10059003] ,[10059004] , [10059002]  ,[10059005] ,[10059006] 
	  FROM tbl_UserAccess2 
	  PIVOT 
	  ( 
   		----MAX(idfsObjectOperation)
		MAX(idfObjectAccess)
		FOR idfsObjectOperation IN([10059001],[10059002],[10059003],[10059004],[10059005],[10059006]) 

	  ) AS p
	  )
	 ,tbl_UserAccessFinal2 AS
	(
		SELECT 
		idfsObjectID
		,MAX([10059001]) AS 'Create'
		,MAX([10059002]) AS 'Delete'
		,MAX([10059003]) AS 'Read'
		,MAX([10059004]) AS 'Write'
		,MAX([10059005]) AS 'Execute'
		,MAX([10059006]) AS 'Access To Personal Data'
		FROM tbl_PivotedUA2 
		GROUP BY [idfactor],idfsObjectID
	)
	  	SELECT a.* 
	,b.[Create]
	,b.[Read] 
	,b.Write
	,b.[Delete]
	,b.[Execute]
	,b.[Access To Personal Data] 
	FROM tbl_AllAccess2 a
	LEFT OUTER JOIN  tbl_UserAccessFinal2 b
	ON a.idfsObjectID=b.idfsObjectID
	ORDER BY a.idfsobjecttype
