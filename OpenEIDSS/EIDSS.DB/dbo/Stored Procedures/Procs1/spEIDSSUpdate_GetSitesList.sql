
--exec spEIDSSUpdate_GetSitesList 1100
CREATE PROCEDURE [dbo].[spEIDSSUpdate_GetSitesList]
(
	@idfsSite bigint = null -- сайт, для которого строятся он и все его потомки
)
AS
Begin
	if (@idfsSite is null) select @idfsSite = [dbo].fnSiteID();

	;
	WITH 
	   tree (idfsSite, idfsParentSite)
	   AS (
	  SELECT
	   ts.idfsSite
	   , ts.idfsParentSite
	  FROM tstSite ts
	  WHERE ts.intRowStatus = 0
	   AND ts.idfsParentSite = @idfsSite
	  UNION ALL
	  SELECT
	   ts2.idfsSite
	   , ts2.idfsParentSite
	  FROM tstSite ts2
	  JOIN tree t ON 
	   t.idfsSite = ts2.idfsParentSite
	  WHERE ts2.intRowStatus = 0
	   )


	Select
		S.[idfsSite]
		,S.[idfsParentSite]
		,S.[idfsSiteType]
		,ST.[name] as [SiteTypeName]
		,case when ST.idfsReference = 10085001 then 1
			when ST.idfsReference = 10085002 then 2
			when ST.idfsReference = 10085007 then 3 
		end as [Level]
		,S.[strSiteName]
		,S.[strServerName]
		,left(S.[strServerName],len(S.[strServerName])-patindex(N'%\%',reverse(S.[strServerName]))) as [strComputerName]
	From dbo.tstSite S
	inner join dbo.fnReference('en', 19000085) ST On S.[idfsSiteType] = ST.idfsReference
	where ((@idfsSite = -1) or (S.[idfsSite] = @idfsSite)) and (S.intRowStatus = 0)

	union all

	Select
		S.[idfsSite]
		,S.[idfsParentSite]
		,S.[idfsSiteType]
		,ST.[name] as [SiteTypeName]
		,case when ST.idfsReference = 10085001 then 1
			when ST.idfsReference = 10085002 then 2
			when ST.idfsReference = 10085007 then 3 
		end as [Level]
		,S.[strSiteName]
		,S.[strServerName]
		,left(S.[strServerName],len(S.[strServerName])-patindex(N'%\%',reverse(S.[strServerName]))) as [strComputerName]
	From dbo.tstSite S
	inner join tree T on S.idfsSite = T.idfsSite
	inner join tstSite parentSite 
	on S.idfsParentSite = parentSite.idfsSite
	and parentSite.blnIsWEB <> 1
	inner join dbo.fnReference('en', 19000085) ST On S.[idfsSiteType] = ST.idfsReference	
End

