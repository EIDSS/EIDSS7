﻿






--##SUMMARY Selects data for human aggregate case list forms.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 015.12.2009

--##RETURNS Doesn't use



/*
Example of function call:

SELECT * FROM fn_AggregateCase_SelectList('en')

*/

CREATE	Function fn_AggregateCase_SelectList(
			@LangID as nvarchar(50)--##PARAM @LangID - language ID
)
returns table
as
return
SELECT idfAggrCase
		,Year(datStartDate) as YearForAggr
		,QuarterForAggr =
			case DateDiff(quarter, datStartDate, datFinishDate)
				when 0 then DatePart(quarter, datStartDate)
				when 1 then DatePart(quarter, datStartDate)
				else null
			end
		,MonthForAggr =
			case DateDiff(month, datStartDate, datFinishDate)
				when 0 then DatePart(month, datStartDate)
				when 1 then DatePart(month, datStartDate)
				else null
			end
		,WeekForAggr =
			case dbo.fnWeekDatediff(datStartDate, datFinishDate)
				when 0 then dbo.fnWeekDatepart(datStartDate)
				when 1 then dbo.fnWeekDatepart(datStartDate)
				else null
			end
		,DayForAggr =
			case DateDiff(day, datStartDate, datFinishDate)
				when 0 then datStartDate
				when 1 then datStartDate
				else null
			end
		,strCaseID
		,gisCountry.idfsCountry
		,ISNULL(Country.name,Country.strDefault) as NationalCountryName
		,Country.strDefault  as EnglishCountryName
		,gisRegion.idfsRegion
		,ISNULL(Region.name,Region.strDefault) as NationalRegionName
		,Region.strDefault  as EnglishRegionName
		,gisRayon.idfsRayon
		,ISNULL(Rayon.name,Rayon.strDefault) as NationalRayonName
		,Rayon.strDefault  as EnglishRayonName
		,gisSettlement.idfsSettlement
		,ISNULL(Settlement.name,Settlement.strDefault) as NationalSettlementName
		,Settlement.strDefault  as EnglishSettlementName
		,idfCaseObservation
		,idfDiagnosticObservation
		,idfProphylacticObservation
		,idfSanitaryObservation

  FROM tlbAggrCase
		left outer join gisCountry
		on		gisCountry.idfsCountry = idfsAdministrativeUnit 
				or exists(
					select	* 
					from	gisRegion
					where	gisRegion.idfsRegion = idfsAdministrativeUnit
							and gisRegion.idfsCountry = gisCountry.idfsCountry)
				or exists(
					select	* 
					from	gisRayon
					where	gisRayon.idfsRayon = idfsAdministrativeUnit
							and gisRayon.idfsCountry = gisCountry.idfsCountry)
				or exists(
					select	* 
					from	gisSettlement 
					where	gisSettlement.idfsSettlement = idfsAdministrativeUnit
							and gisSettlement.idfsCountry = gisCountry.idfsCountry)
		left outer join	fnGisReference(@LangID, 19000001/*rftCountry*/) Country
		on				Country.idfsReference = gisCountry.idfsCountry

		left outer join gisRegion
		on		gisRegion.idfsRegion = idfsAdministrativeUnit 
				or exists(
					select	* 
					from	gisRayon
					where	gisRayon.idfsRayon = idfsAdministrativeUnit
							and gisRayon.idfsRegion = gisRegion.idfsRegion)
				or exists(
					select	* 
					from	gisSettlement
					where	gisSettlement.idfsSettlement = idfsAdministrativeUnit
							and gisSettlement.idfsRegion = gisRegion.idfsRegion)
		left outer join	fnGisReference(@LangID, 19000003/*rftRegion*/) Region
		on				Region.idfsReference = gisRegion.idfsRegion
		left outer join gisRayon
		on		gisRayon.idfsRayon = idfsAdministrativeUnit
				or exists(
					select	* 
					from	gisSettlement
					where	gisSettlement.idfsSettlement = idfsAdministrativeUnit
							and gisSettlement.idfsRayon = gisRayon.idfsRayon)
		left outer join	fnGisReference(@LangID, 19000002/*rftRayon*/) Rayon
		on				Rayon.idfsReference = gisRayon.idfsRayon
		left outer join gisSettlement
		on		gisSettlement.idfsSettlement = idfsAdministrativeUnit
		left outer join	fnGisReference(@LangID, 19000004/*rftSettlement*/) Settlement
		on				Settlement.idfsReference = gisSettlement.idfsSettlement






