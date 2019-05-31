

--##SUMMARY Reurns links from queries to system functions that should be used for check user parmission to execute the query.
--##SUMMARY Queries without links to system functions are not included in the result.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 06.02.2013

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsQueryToSystemFunctionSelectLookup 'en'
*/ 
 
create PROCEDURE [dbo].[spAsQueryToSystemFunctionSelectLookup]
	@LangID	as nvarchar(50),
	@QueryID	as bigint = null
AS
BEGIN
	declare  @result as table
	(
			 strQueryToSF			varchar(200) not null primary key
			,idflQuery				bigint not null
			,idfsSystemFunction		bigint not null
			,DefQueryName			nvarchar(2000) null
			,QueryName				nvarchar(2000) null
			,strFunctionName		nvarchar(2000) null
			,blnReadOnly			bit
			,DefSystemFunctionName	nvarchar(2000) null
			,SystemFunctionName		nvarchar(2000) null
	)
	insert into @result
	select distinct 
				 CAST(q.idflQuery as varchar(20)) + '_to_' + CAST(sf.idfsSystemFunction as varchar(20)) 
				,q.idflQuery
				,sf.idfsSystemFunction
				,ref_q.strEnglishName	
				,ref_q.strName			
				,q.strFunctionName		
				,q.blnReadOnly			
				,ref_sf.strDefault		
				,ref_sf.[name]			
	from		tasQuery q
	inner join	dbo.fnLocalReference(@LangID) ref_q
	on			ref_q.idflBaseReference = q.idflQuery
	inner join	tasQuerySearchObject qso
	on			qso.idflQuery = q.idflQuery
	inner join	tasSearchObject so
	on			so.idfsSearchObject = qso.idfsSearchObject
				and so.intRowStatus = 0
	inner join	trtBaseReference br_so
	on			br_so.idfsBaseReference = so.idfsSearchObject
				and br_so.intRowStatus = 0
	inner join	tasSearchObjectToSystemFunction so_to_sf
	on			so_to_sf.idfsSearchObject = so.idfsSearchObject
	inner join	trtSystemFunction sf
	on			sf.idfsSystemFunction = so_to_sf.idfsSystemFunction
				and sf.intRowStatus = 0
	inner join	fnReference(@LangID, 19000094) ref_sf	-- System Function
	on			ref_sf.idfsReference = sf.idfsSystemFunction
	where		(@QueryID is null or @QueryID = q.idflQuery)
	
	
	select * from @result
	order by	QueryName, idflQuery, SystemFunctionName, idfsSystemFunction
	
END

