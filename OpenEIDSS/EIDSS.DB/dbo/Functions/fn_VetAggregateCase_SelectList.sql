
--##SUMMARY Returns list of vet aggregate cases.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 03.10.2011


--##RETURNS Returns list of vet aggregate cases.



/*
select * from fn_VetAggregateCase_SelectList ('en')
*/

/* Statistic period types
    None = 0
    Month = 10091001
    Day = 10091002
    Quarter = 10091003
    Week = 10091004
    Year = 10091005

*/
/*
StatisticAreaType
    None = 0
    Country = 10089001
    Rayon = 10089002
    Region = 10089003
    Settlement = 10089004
*/
CREATE     Function [dbo].[fn_VetAggregateCase_SelectList](
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return
SELECT * from dbo.fnAggregateCaseList(@LangID,10102002)









