

CREATE VIEW [dbo].[vw_AVR_BasicSyndromicSurveillanceAggregateReport]
as

select		bssAForm.idfAggregateHeader as [PKField], 
			bssAForm.idfAggregateHeader as [PKField_4583090000073], 
			p_ent_bssAForm.idfPerson as [PKField_4583090000074], 
			site_bssAForm.idfsSite as [PKField_4583090000075], 
			bssAValues.idfAggregateDetail as [PKField_4583090000076], 
			hosp_bssAValues.idfOffice as [PKField_4583090000077], 
			bssAForm.strFormID  as [sflBssAForm_FormID], 
			bssAForm.datDateEntered  as [sflBssAForm_DateEntered], 
			bssAForm.datDateLastSaved  as [sflBssAForm_DateLastSaved], 
			dbo.fnConcatFullName(p_ent_bssAForm.strFamilyName, p_ent_bssAForm.strFirstName, p_ent_bssAForm.strSecondName) as [sflBssAForm_EnteredBy], 
			office_bssAForm.idfsOfficeAbbreviation as [sflBssAForm_Site_ID], 
			dbo.fnGetNDayOfNWeekInYear(1, bssAForm.intYear,  bssAForm.intWeek)  as [sflBssAForm_WeekStartDate], 
			dbo.fnGetNDayOfNWeekInYear(7, bssAForm.intYear,  bssAForm.intWeek)  as [sflBssAForm_WeekEndDate], 
			dbo.fnGetNDayOfNWeekInYear(4, bssAForm.intYear,  bssAForm.intWeek)  as [sflBssAForm_WeekDateForGrouping], 
			hosp_bssAValues.idfsOfficeAbbreviation  as [sflBssAValues_NameOfHospital_ID], 
			bssAValues.idfsAggregateColumn  as [sflBssAValues_ColumnName_ID], 
			bssAValues.intAggregateColumnValue  as [sflBssAValues_Value]

from 

( 
	tlbBasicSyndromicSurveillanceAggregateHeader bssAForm
left join 

 
	tlbPerson p_ent_bssAForm
 

ON p_ent_bssAForm.idfPerson = bssAForm.idfEnteredBy 
left join 

( 
	tstSite site_bssAForm
		inner join tlbOffice office_bssAForm
		on site_bssAForm.idfOffice = office_bssAForm.idfOffice
) 

ON site_bssAForm.idfsSite = bssAForm.idfsSite 
left join 

( 
	vwUnpivotBSSAggregateDetail bssAValues
left join 

 
	tlbOffice hosp_bssAValues
 

ON hosp_bssAValues.idfOffice = bssAValues.idfHospital 
) 

ON bssAForm.idfAggregateHeader = bssAValues.idfAggregateHeader 
) 





