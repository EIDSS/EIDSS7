

--##SUMMARY Reurns links from AVR search objects to system functions that should be used 
--##SUMMARY for check user permission to use search object in the query.
--##SUMMARY Search objects without links to system functions are not included in the result.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 06.02.2013

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsSearchObjectToSystemFunctionSelectLookup 'en'
*/ 
 
create PROCEDURE [dbo].[spAsSearchObjectToSystemFunctionSelectLookup]
	@LangID	as nvarchar(50),
	@ID	as bigint = null
AS
BEGIN
	declare  @result as table
	(
			 strSearchObjectToSystemFunction	varchar(200) not null primary key
			,idfsSearchObject		bigint not null
			,idfsSystemFunction		bigint not null
			,SearchObjectName		nvarchar(2000) null
			,SystemFunctionName		nvarchar(2000) null
	)
	
	insert into @result
	select		 CAST(so.idfsSearchObject as varchar(20)) + '_to_' + CAST(sf.idfsSystemFunction as varchar(20))
				,so.idfsSearchObject
				,sf.idfsSystemFunction
				,ref_so.[name] 
				,ref_sf.[name]		
				
	from		tasSearchObject so
	inner join	fnReference('en', 19000082) ref_so		-- Search Object
	on			ref_so.idfsReference = so.idfsSearchObject
	inner join	tasSearchObjectToSystemFunction so_to_sf
	on			so_to_sf.idfsSearchObject = so.idfsSearchObject
	inner join	trtSystemFunction sf
	on			sf.idfsSystemFunction = so_to_sf.idfsSystemFunction
				and sf.intRowStatus = 0
	inner join	fnReference(@LangID, 19000094) ref_sf	-- System Function
	on			ref_sf.idfsReference = sf.idfsSystemFunction
	where		so.intRowStatus = 0
				and (@ID is null or @ID = so.idfsSearchObject)
				
				
	select * from @result
	order by	SearchObjectName, idfsSearchObject, SystemFunctionName, idfsSystemFunction
END

