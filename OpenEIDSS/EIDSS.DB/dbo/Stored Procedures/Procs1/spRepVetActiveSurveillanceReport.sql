

--##SUMMARY Select data for Active Surveillance Report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 15.10.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec spRepVetActiveSurveillanceReport  'en', '2015'

*/

create  Procedure [dbo].[spRepVetActiveSurveillanceReport]
    (
		@LangID as nvarchar(10),
        @Year   as int
    )
as
begin
	if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
	drop table #ReportTable
	
	create	table #ReportTable	
	(	idfReportRow	bigint identity(1, 1) not null primary key,
		idfsDiagnosis	bigint not null,
		strDiagnosis	nvarchar(2000) collate database_default null,
		idfsSpeciesType	bigint not null,
		strSpeciesType	nvarchar(2000) collate database_default null,
		intPlanned		bigint null,
		intSampled		bigint null
	)

	if ((IsNull(@Year, 0) >= 1900) and (IsNull(@Year, 0) <= Year(getdate()) + 1))
	begin

		declare	@Campaigns	table
		(	idfCampaign	bigint not null primary key
		)
		
		declare	@Sessions	table
		(	idfMonitoringSession	bigint not null primary key
		)
		
		declare	@SampledValuesFromSummary	table
		(	idfReportRow	bigint not null primary key,
			intSampled		bigint not null
		)
		
		declare	@SampledValuesFromDetail	table
		(	idfReportRow	bigint not null primary key,
			intSampled		bigint not null
		)

		insert into	@Campaigns	(idfCampaign)
		select		c.idfCampaign
		from		tlbCampaign c
		where		(	(	c.datCampaignDateStart is not null
							and	c.datCampaignDateEnd is not null
							and Year(dateadd(ss, datediff(ss, c.datCampaignDateStart, c.datCampaignDateEnd) / 2, c.datCampaignDateStart)) = @Year
						)
						or	(	c.datCampaignDateStart is not null
								and	c.datCampaignDateEnd is null
								and Year(c.datCampaignDateStart) = @Year
							)
						or	(	c.datCampaignDateStart is null
								and	c.datCampaignDateEnd is not null
								and Year(c.datCampaignDateEnd) = @Year
							)
					)
					and c.intRowStatus = 0


		insert into	@Sessions	(idfMonitoringSession)
		select		ms.idfMonitoringSession
		from		tlbMonitoringSession ms
		inner join	tlbCampaign c
		on			c.idfCampaign = ms.idfCampaign
					and c.intRowStatus = 0
		inner join	@Campaigns c_selected
		on			c_selected.idfCampaign = ms.idfCampaign
		where		ms.intRowStatus = 0


		insert into	@Sessions	(idfMonitoringSession)
		select		ms.idfMonitoringSession
		from		tlbMonitoringSession ms
		left join	tlbCampaign c
		on			c.idfCampaign = ms.idfCampaign
					and c.intRowStatus = 0
		where		(	(	ms.datStartDate is not null
							and	ms.datEndDate is not null
							and Year(dateadd(ss, datediff(ss, ms.datStartDate, ms.datEndDate) / 2, ms.datStartDate)) = @Year
						)
						or	(	ms.datStartDate is not null
								and	ms.datEndDate is null
								and Year(ms.datStartDate) = @Year
							)
						or	(	ms.datStartDate is null
								and	ms.datEndDate is not null
								and Year(ms.datEndDate) = @Year
							)
					)
					and ms.intRowStatus = 0
					and c.idfCampaign is null

		insert into	#ReportTable
		(	idfsDiagnosis,
			strDiagnosis,
			idfsSpeciesType,
			strSpeciesType,
			intPlanned
		)
		select		cd.idfsDiagnosis,
					IsNull(d.[name], N''),
					st.idfsReference,
					IsNull(st.[name], N''),
					sum(IsNull(cd.intPlannedNumber, 0))
		from		tlbCampaignToDiagnosis cd
		inner join	tlbCampaign c
		on			c.idfCampaign = cd.idfCampaign
					and c.intRowStatus = 0
		inner join	@Campaigns c_selected
		on			c_selected.idfCampaign = c.idfCampaign
		inner join	fnReferenceRepair(@LangID, 19000019) d	-- Diagnosis
		on			d.idfsReference = cd.idfsDiagnosis
		inner join	fnReferenceRepair(@LangID, 19000086) st	-- Species Type
		on			st.idfsReference = cd.idfsSpeciesType
		where		cd.intRowStatus = 0
		group by	cd.idfsDiagnosis,
					IsNull(d.[name], N''),
					st.idfsReference,
					IsNull(st.[name], N'')

		update		rt
		set			rt.intPlanned = null
		from		#ReportTable rt
		left join	(
			tlbCampaignToDiagnosis cd
			inner join	tlbCampaign c
			on			c.idfCampaign = cd.idfCampaign
						and c.intRowStatus = 0
			inner join	@Campaigns c_selected
			on			c_selected.idfCampaign = c.idfCampaign
			inner join	fnReferenceRepair(@LangID, 19000019) d	-- Diagnosis
			on			d.idfsReference = cd.idfsDiagnosis
			inner join	fnReferenceRepair(@LangID, 19000086) st	-- Species Type
			on			st.idfsReference = cd.idfsSpeciesType
					)
		on			cd.idfsDiagnosis = rt.idfsDiagnosis
					and IsNull(st.idfsReference, 0) = IsNull(rt.idfsSpeciesType, 0)
					and cd.intRowStatus = 0
					and cd.intPlannedNumber is not null
		where		cd.idfCampaignToDiagnosis is null


		insert into	#ReportTable
		(	idfsDiagnosis,
			strDiagnosis,
			idfsSpeciesType,
			strSpeciesType,
			intPlanned,
			intSampled
		)
		select distinct
					msd.idfsDiagnosis,
					IsNull(d.[name], N''),
					st.idfsReference,
					IsNull(st.[name], N''),
					null,
					null
		from		tlbMonitoringSessionToDiagnosis msd
		inner join	tlbMonitoringSession ms
		on			ms.idfMonitoringSession = msd.idfMonitoringSession
					and ms.intRowStatus = 0
		inner join	@Sessions s_selected
		on			s_selected.idfMonitoringSession = ms.idfMonitoringSession
		inner join	fnReferenceRepair(@LangID, 19000019) d	-- Diagnosis
		on			d.idfsReference = msd.idfsDiagnosis
		inner join	fnReferenceRepair(@LangID, 19000086) st	-- Species Type
		on			st.idfsReference = msd.idfsSpeciesType
		left join	#ReportTable rt
		on			rt.idfsDiagnosis = msd.idfsDiagnosis
					and IsNull(rt.idfsSpeciesType, 0) = IsNull(st.idfsReference, 0)
		where		msd.intRowStatus = 0
					and rt.idfReportRow is null


		insert into	@SampledValuesFromSummary
		(	idfReportRow,
			intSampled
		)
		select		rt.idfReportRow,
					sum(IsNull(mss.intSampledAnimalsQty, 0))
		from		tlbMonitoringSessionToDiagnosis msd
		inner join	tlbMonitoringSession ms
		on			ms.idfMonitoringSession = msd.idfMonitoringSession
					and ms.intRowStatus = 0
		inner join	@Sessions s_selected
		on			s_selected.idfMonitoringSession = ms.idfMonitoringSession
		inner join	fnReferenceRepair(@LangID, 19000019) d	-- Diagnosis
		on			d.idfsReference = msd.idfsDiagnosis
		inner join	fnReferenceRepair(@LangID, 19000086) st	-- Species Type
		on			st.idfsReference = msd.idfsSpeciesType
		inner join	#ReportTable rt
		on			rt.idfsDiagnosis = msd.idfsDiagnosis
					and IsNull(rt.idfsSpeciesType, 0) = IsNull(st.idfsReference, 0)
		inner join	tlbMonitoringSessionSummary mss
			inner join	tlbSpecies s
			on			s.idfSpecies = IsNull(mss.idfSpecies, 0)
						and s.intRowStatus = 0
			inner join	tlbHerd h
			on			h.idfHerd = s.idfHerd
						and h.idfFarm = mss.idfFarm
						and h.intRowStatus = 0
			inner join	tlbFarm f
			on			f.idfFarm = h.idfFarm
						and f.intRowStatus = 0
		on			mss.idfMonitoringSession = ms.idfMonitoringSession
					and s.idfsSpeciesType = IsNull(rt.idfsSpeciesType, 0)
					and mss.intRowStatus = 0
					and mss.intSampledAnimalsQty is not null
		where		msd.intRowStatus = 0
		group by	rt.idfReportRow



		insert into	@SampledValuesFromDetail
		(	idfReportRow,
			intSampled
		)
		select		rt.idfReportRow,
					count(a.idfAnimal)
		from		tlbMonitoringSessionToDiagnosis msd
		inner join	tlbMonitoringSession ms
		on			ms.idfMonitoringSession = msd.idfMonitoringSession
					and ms.intRowStatus = 0
		inner join	@Sessions s_selected
		on			s_selected.idfMonitoringSession = ms.idfMonitoringSession
		inner join	fnReferenceRepair(@LangID, 19000019) d	-- Diagnosis
		on			d.idfsReference = msd.idfsDiagnosis
		inner join	fnReferenceRepair(@LangID, 19000086) st	-- Species Type
		on			st.idfsReference = msd.idfsSpeciesType
		inner join	#ReportTable rt
		on			rt.idfsDiagnosis = msd.idfsDiagnosis
					and IsNull(rt.idfsSpeciesType, 0) = IsNull(st.idfsReference, 0)
		inner join	tlbFarm f
			inner join	tlbHerd h
			on			h.idfFarm = f.idfFarm
						and h.intRowStatus = 0
			inner join	tlbSpecies s
			on			s.idfHerd = h.idfHerd
						and s.intRowStatus = 0
			inner join	tlbAnimal a
			on			a.idfSpecies = s.idfSpecies
						and a.intRowStatus = 0
		on			f.idfMonitoringSession = ms.idfMonitoringSession
					and f.intRowStatus = 0
					and s.idfsSpeciesType = IsNull(st.idfsReference, 0)
		left join	tlbMonitoringSessionSummary mss
		on			mss.idfMonitoringSession = ms.idfMonitoringSession
					and mss.intRowStatus = 0
		where		msd.intRowStatus = 0
					and mss.idfMonitoringSessionSummary is null
		group by	rt.idfReportRow


		update		rt
		set			rt.intSampled = sv_s.intSampled
		from		#ReportTable rt
		inner join	@SampledValuesFromSummary sv_s
		on			sv_s.idfReportRow = rt.idfReportRow


		update		rt
		set			rt.intSampled = rt.intSampled + sv_d.intSampled
		from		#ReportTable rt
		inner join	@SampledValuesFromDetail sv_d
		on			sv_d.idfReportRow = rt.idfReportRow
		where		rt.intSampled is not null


		update		rt
		set			rt.intSampled = sv_d.intSampled
		from		#ReportTable rt
		inner join	@SampledValuesFromDetail sv_d
		on			sv_d.idfReportRow = rt.idfReportRow
		where		rt.intSampled is null

	end


	select		idfsDiagnosis,
				strDiagnosis,
				idfsSpeciesType,
				strSpeciesType,
				intPlanned,
				intSampled

	from		#ReportTable

	order by	strDiagnosis,
				idfsDiagnosis,
				strSpeciesType,
				idfsSpeciesType
				
end
