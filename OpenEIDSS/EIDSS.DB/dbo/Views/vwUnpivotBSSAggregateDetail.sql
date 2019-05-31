


--##SUMMARY Unpivot tlbBasicSyndromicSurveillanceAggregateDetail table

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 24.02.2014

--##RETURNS Doesn't use

/*

select 
ag.*, br.strDefault
from vwUnpivotBSSAggregateDetail ag
inner join trtBaseReference br 
on br.idfsBaseReference = ag.idfsAggregateColumn
and br.idfsReferenceType = 19000163


*/

create view vwUnpivotBSSAggregateDetail
as
select 
	idfAggregateDetail,
	idfAggregateHeader,
	idfHospital,
	intRowStatus,
	ACol as strAggregateColumn,
	intACol as idfsAggregateColumn,
	AValue as intAggregateColumnValue

from
	(	select 
	 		idfAggregateDetail,
	 		idfAggregateHeader,
	 		idfHospital,
	 		intRowStatus,
	 		
	 		cast('0-4' as nvarchar(50)) as ACol1,
	 		50815390000000 as intACol1,
	 		intAge0_4 as AValue1,
	 		
	 		cast('5-14' as nvarchar(50)) as ACol2,
	 		50815400000000 as intACol2,
	 		intAge5_14 as AValue2,
	 		
	 		cast('15-29' as nvarchar(50)) as ACol3,
	 		50815410000000 as intACol3,
	 		intAge15_29 as AValue3,
	 		
	 		cast('30-64' as nvarchar(50)) as ACol4,
	 		50815420000000 as intACol4,
	 		intAge30_64 as AValue4,
	 		
	 		cast('>=65' as nvarchar(50)) as ACol5,
	 		50815430000000 as intACol5,
	 		intAge65 as AValue5,
	 		
	 		cast('Total ILI' as nvarchar(50)) as ACol6,
	 		50815440000000 as intACol6,
	 		inTotalILI as AValue6,
	 		
	 		cast('ILI Admissions' as nvarchar(50)) as ACol7,
	 		50815450000000 as intACol7,
	 		intTotalAdmissions as AValue7,
	 			 		
	 		cast('ILI Samples' as nvarchar(50)) as ACol8,
	 		50815460000000 as intACol8,
	 		intILISamples as AValue8
	 	from tlbBasicSyndromicSurveillanceAggregateDetail 
	 	
	) as s
	unpivot ( ACol		FOR ACols			IN (ACol1, ACol2, ACol3, ACol4, ACol5, ACol6, ACol7, ACol8)) as unpvt_ACols 
	unpivot ( intACol	FOR intACols		IN (intACol1, intACol2, intACol3, intACol4, intACol5, intACol6, intACol7, intACol8)) as unpvt_intACols 	
	unpivot ( AValue	FOR AValues			IN (AValue1, AValue2, AValue3, AValue4, AValue5, AValue6, AValue7, AValue8)) as unpvt_AValues 
	where	right(ACols,1) =  right(AValues,1) and
			right(intACols,1) =  right(AValues,1) 

