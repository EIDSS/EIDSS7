

--##SUMMARY select aggregate function list for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsAggregateFunctionSelectLookup 'ru'
*/ 


  
create PROCEDURE [dbo].[spAsAggregateFunctionSelectLookup]
	@LangID	as nvarchar(50)
AS
BEGIN
	select		
				tRef.idfsBaseReference		as idfAggregateFunction,
				tRef.strBaseReferenceCode	as idfsAggregateFunction,
				fnRef.strDefault			as AggregateFunctionNameDef,
				fnRef.[name]				as AggregateFunctionName,
				tAggr.blnPivotGridFunction,
				tAggr.blnViewFunction,
				tAggr.intDefaultPrecision,
				tRef.intOrder
		  from	dbo.fnReference(@LangID, 19000004 /*'rftAggregateFunction'*/) as fnRef
	inner join	dbo.trtBaseReference		as tRef
			on	tRef.idfsBaseReference = fnRef.idfsReference
	inner join  dbo.tasAggregateFunction	as tAggr
			on	tRef.idfsBaseReference = tAggr.idfsAggregateFunction

	  order by	tRef.intOrder, AggregateFunctionName
	  

END

