
--##SUMMARY Recalculation of filtration Human Cases for replication .

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 20.05.2014

--##REMARKS Updated by: Romasheva S.
--##REMARKS Update date: 23.11.2015

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_HumanCase null, 3670001294
*/


create proc spFiltered_HumanCase (
	@StartDate datetime = null,
	@idfHumanCase bigint = null
	)
as
	--print @idfHumanCase
	if @@NESTLEVEL > 10 return(0)
	
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
	
	
	if Object_ID('tempdb..#HumanCase') is null
	create table #HumanCase (
		idfHumanCase bigint not null primary key
	)

	
	if Object_ID('tempdb..#HumanCaseFiltered') is null
	create table #HumanCaseFiltered (
		id int identity(1,1),
		idfHumanCaseFiltered bigint,
		idfHumanCase bigint not null,
		idfSiteGroup bigint not null,
		primary key(
			idfHumanCase  asc,
			idfSiteGroup asc
			)
		)

	if Object_ID('tempdb..#TransferOutFiltered_HC') is null
	create table #TransferOutFiltered_HC (
		idfTransferOut	bigint,
		idfSiteGroup bigint not null,
		primary key (
			idfTransferOut	asc,
			idfSiteGroup asc
		)
	)
	
	if Object_ID('tempdb..#Outbreak_HC') is null
	create table #Outbreak_HC (
		idfOutbreak bigint not null,
		idfHumanCase bigint not null,
		primary key (
			idfOutbreak asc,
			idfHumanCase asc
		)
	)				
	
	if Object_ID('tempdb..#Human_HC') is null
	create table #Human_HC (
		idfHuman bigint not null,
		idfHumanCase bigint not null,
		primary key (
		 	idfHuman asc,
			idfHumanCase asc
		 )
	)	

	if Object_ID('tempdb..#GeoLocation_HC') is null
	create table #GeoLocation_HC (
		idfGeoLocation bigint not null,
		idfHumanCase bigint not null,
		primary key (
			idfGeoLocation asc,
			idfHumanCase asc
		)
	)	

	if Object_ID('tempdb..#BatchTest_HC') is null
	create table #BatchTest_HC (
		idfBatchTest bigint not null,
		idfHumanCase bigint not null,
		primary key (
			idfBatchTest asc,
			idfHumanCase asc
		)
	)
	
	if Object_ID('tempdb..#Observation_HC') is null
	create table #Observation_HC (
		idfObservation bigint not null,
		idfHumanCase bigint not null,
		primary key (
			idfObservation asc,
			idfHumanCase asc
		)	
	)

	if Object_ID('tempdb..#Notification_HC') is null
	create table #Notification_HC  (
		idfNotification bigint not null,
		idfHumanCase bigint not null,
		primary key (
			idfNotification asc,
			idfHumanCase asc
		)
	)
	
	if Object_ID('tempdb..#DataAuditEvent_HC') is null
	create table #DataAuditEvent_HC  (
		idfDataAuditEvent bigint not null,
		idfHumanCase bigint not null,
		primary key (
			idfDataAuditEvent asc,
			idfHumanCase asc
		)
	)	
	-- END create tables	
	
	
	insert into #HumanCase
	select 
		hc.idfHumanCase
	from tlbHumanCase hc
		left join #HumanCase hc_f
		on hc_f.idfHumanCase = hc.idfHumanCase
		
	where
	 hc_f.idfHumanCase is null and
	(hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null) and
	(hc.datModificationForArchiveDate >= @StartDate or @StartDate is null)	
	
	-- !!! for @idfHumanCase = -1, human case list passed to the procedure
	if @idfHumanCase = -1 set @idfHumanCase = null
	
		
	--site group by site
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on	thc.idfHumanCase = hc.idfHumanCase
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = thc.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null
			and tsg.intRowStatus = 0	
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
		and	hcf.idfSiteGroup = tstsg.idfSiteGroup	
	where hcf.idfHumanCase is null	
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

	-- Human Case data is sent to all sites, 
	-- which have cases connected to this particular Human Case 
	-- by de-duplication of cases. The Survivor Human Case data 
	-- is sent to the site of Superseded Human Case and to the 
	-- site of the Survivor Human Case. 
	
			
			
	declare @idfHumanCaseDup bigint	
	declare cur cursor local forward_only 
	for
	select 
		hc_d.idfHumanCase
	from #HumanCase hc
		inner join	tlbHumanCase AS hc_d with (nolock)
		on	hc.idfHumanCase = hc_d.idfDeduplicationResultCase
		and isnull(@idfHumanCase, 0) <> hc_d.idfHumanCase
		
		left join #HumanCase hcf --#HumanCaseFiltered
		on hcf.idfHumanCase = hc_d.idfHumanCase
	where hc.idfHumanCase <> hc_d.idfHumanCase 
			and hcf.idfHumanCase is null
			and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
			 
	open cur
	fetch next from cur into @idfHumanCaseDup
	while @@FETCH_STATUS = 0 begin
		--print 'calc dedupl'
		--print @idfHumanCaseDup
		exec spFiltered_HumanCase null, @idfHumanCaseDup
		fetch next from cur into @idfHumanCaseDup
	end	
	close cur
	deallocate cur	
	
	--select distinct
	--	thcf.idfHumanCase,
	--	thcf.idfSiteGroup,
	--	hc_d.idfDeduplicationResultCase	,
	--	tstsg.strSiteID
		
	--from #HumanCase hc
	--	inner join	tlbHumanCase AS hc_d with (nolock)
	--	on	hc.idfHumanCase = hc_d.idfDeduplicationResultCase		
	--	inner join tflHumanCaseFiltered thcf with (nolock)
	--	on	thcf.idfHumanCase = hc_d.idfHumanCase
		
	--	inner join tflSiteToSiteGroup tstsg
	--	on tstsg.idfSiteGroup = thcf.idfSiteGroup
			
	----print 'de-duplication'
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		thcf.idfSiteGroup
	from #HumanCase hc
		inner join	tlbHumanCase AS hc_d with (nolock)
		on	hc.idfHumanCase = hc_d.idfDeduplicationResultCase		
		inner join tflHumanCaseFiltered thcf with (nolock)
		on	thcf.idfHumanCase = hc_d.idfHumanCase
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase
			and	hcf.idfSiteGroup = thcf.idfSiteGroup	
	where hcf.idfHumanCase is null	
			and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	
	--=============================================================================		
	-- Human Case data is always distributed across the sites, 
	-- where the connected Outbreak is send, if the Human Case 
	-- is the primary case for this Outbreak

	
	--vet cases
	declare @idfVetCaseFromOtb bigint	 
	declare cur cursor local forward_only 
	for
	select 
		tvc.idfVetCase
	from #HumanCase vc
		inner join	tlbOutbreak AS otb with (nolock)
		on	vc.idfHumanCase = otb.idfPrimaryCaseOrSession	
		inner join tlbVetCase tvc
		on tvc.idfOutbreak = otb.idfOutbreak
		and tvc.idfVetCase <> otb.idfPrimaryCaseOrSession
	where (vc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	open cur
	fetch next from cur into @idfVetCaseFromOtb
	while @@FETCH_STATUS = 0 begin
		--print 'exec spFiltered_VetCase null, ' + cast(@idfVetCaseFromOtb as nvarchar(20))
		exec spFiltered_VetCase null, @idfVetCaseFromOtb
		fetch next from cur into @idfVetCaseFromOtb
	end	
	close cur
	deallocate cur		

	declare @idfHumanCaseFromOtb bigint
	declare @ci int, @i int
	select @ci = count(tvc.idfHumanCase)
	from #HumanCase hc
		inner join	tlbOutbreak AS otb with (nolock)
		on	hc.idfHumanCase = otb.idfPrimaryCaseOrSession	
		inner join tlbHumanCase tvc
		on tvc.idfOutbreak = otb.idfOutbreak
		and tvc.idfHumanCase <> otb.idfPrimaryCaseOrSession
		and tvc.idfHumanCase <> isnull(@idfHumanCase, 0)
	where (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	set @i = 0
	declare cur cursor local forward_only 
	for
	select distinct
		tvc.idfHumanCase
	from #HumanCase hc
		inner join	tlbOutbreak AS otb with (nolock)
		on	hc.idfHumanCase = otb.idfPrimaryCaseOrSession	
		inner join tlbHumanCase tvc
		on tvc.idfOutbreak = otb.idfOutbreak
		and tvc.idfHumanCase <> otb.idfPrimaryCaseOrSession
		and tvc.idfHumanCase <> isnull(@idfHumanCase, 0)
	where (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	open cur
	fetch next from cur into @idfHumanCaseFromOtb
	while @@FETCH_STATUS = 0 begin
		set @i = @i +1
		--print cast(@i as varchar)+' (' + cast(@ci as varchar)+ ') 
		--exec spFiltered_HumanCase null,' + cast(@idfHumanCaseFromOtb as nvarchar(20))
		exec spFiltered_HumanCase null, @idfHumanCaseFromOtb
		fetch next from cur into @idfHumanCaseFromOtb
	end	
	close cur
	deallocate cur
		
	--tlbOutbreak
	
	declare @idfVectorSurveillanceSessionFromOtb bigint	 
	declare cur cursor local forward_only 
	for
	select 
		tvss.idfVectorSurveillanceSession
	from #HumanCase hc
		inner join	tlbOutbreak AS otb with (nolock)
		on	hc.idfHumanCase = otb.idfPrimaryCaseOrSession	
		inner join tlbVectorSurveillanceSession tvss
		on tvss.idfOutbreak = otb.idfOutbreak
		and tvss.idfVectorSurveillanceSession <> otb.idfPrimaryCaseOrSession
	where (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	open cur
	fetch next from cur into @idfVectorSurveillanceSessionFromOtb
	while @@FETCH_STATUS = 0 begin
		--print 'exec spFiltered_VectorSurveillanceSession null, ' + cast(@idfVectorSurveillanceSessionFromOtb as nvarchar(20))
		exec spFiltered_VectorSurveillanceSession null, @idfVectorSurveillanceSessionFromOtb
		fetch next from cur into @idfVectorSurveillanceSessionFromOtb
	end	
	close cur
	deallocate cur		
	
	----print 'hc from recalc case and sessions for outbreak'
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tof.idfSiteGroup
	from #HumanCase hc
		inner join	tlbOutbreak AS otb with (nolock)
		on	hc.idfHumanCase = otb.idfPrimaryCaseOrSession		
		inner join tflOutbreakFiltered tof  with (nolock)
		on	tof.idfOutbreak = otb.idfOutbreak
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tof.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	-- end recalc case and sessions for outbreak
	--=============================================================================		
					
		

	-- Human Case data is sent to all sites, which organizations are 
	-- connected to this particular Human Case. Specific organizations 
	-- list for the case includes: 
	
	--	Organization, specified in the “Notification sent by: Facility” field
	--print 'Organization'
	--print 'Organization, specified in the “Notification sent by: Facility” field'
	
				
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select 
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on thc.idfHumanCase = hc.idfHumanCase
		inner join	tstSite AS s with (nolock)
		on	thc.idfSentByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	     	
	
	--	Organization, specified in the “Notification received by: Facility” field
	--print 'Organization, specified in the “Notification received by: Facility” field'
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select 
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on thc.idfHumanCase = hc.idfHumanCase
		inner join	tstSite AS s with (nolock)
		on	thc.idfReceivedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null			
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)			
	
	--	Organization, specified in the “Organization conducting investigation” field
	--print 'Organization, specified in the “Organization conducting investigation” field'
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select 
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on thc.idfHumanCase = hc.idfHumanCase
		inner join	tstSite AS s with (nolock)
		on	thc.idfInvestigatedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null	
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)				
	
	--	Organization, specified in the “Facility where patient first sought care” field
	--print 'Organization, specified in the “Facility where patient first sought care” field'
	
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on thc.idfHumanCase = hc.idfHumanCase
		inner join	tstSite AS s with (nolock)
		on	thc.idfSoughtCareFacility = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null
			and tsg.intRowStatus = 0		
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)		
	
	--	Organization, specified in the “Hospital name” field on the “Notification” tab
	--print 'Organization, specified in the “Hospital name” field on the “Notification” tab'
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on thc.idfHumanCase = hc.idfHumanCase
		inner join	tstSite AS s with (nolock)
		on	thc.idfHospital = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)			
	
	--	Organization, specified in the “Collected By Institution” field for any sample
	--print 'Organization, specified in the “Collected By Institution” field for any sample'
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join	tlbMaterial AS m with (nolock)
		on	hc.idfHumanCase = m.idfHumanCase		
		inner join	tstSite AS s with (nolock)
		on	m.idfFieldCollectedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0		
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null	
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
	--	Organization, specified in the “Sent To Organization” field for any sample
	--print 'Organization, specified in the “Sent To Organization” field for any sample'
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join	tlbMaterial AS m with (nolock)
		on	hc.idfHumanCase = m.idfHumanCase		
		inner join	tstSite AS s with (nolock)
		on	m.idfSendToOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)		
	
	--	Organization where case-connected samples were transferred out. 
	--print 'Organization where case-connected samples were transferred out. '
	
		
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg.idfSiteGroup
	from #HumanCase hc
		inner join	tlbMaterial AS m with (nolock)
		on	hc.idfHumanCase = m.idfHumanCase	
		inner join	tlbTransferOutMaterial AS toutm with (nolock)
		on	m.idfMaterial = toutm.idfMaterial
		inner join	tlbTransferOUT AS tout with (nolock)
		on	toutm.idfTransferOut = tout.idfTransferOut
		inner join	tstSite AS s with (nolock)
		on	tout.idfSendToOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)		
	
	
	-- Transfer OUT 
	-- site group by creation site for tranfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_HC
		select  distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #HumanCase vc
			inner join	tlbMaterial AS m with (nolock)
			on	vc.idfHumanCase = m.idfHumanCase	
			inner join	tlbTransferOutMaterial AS toutm with (nolock)
			on	m.idfMaterial = toutm.idfMaterial
			inner join	tlbTransferOUT AS tout with (nolock)
			on	toutm.idfTransferOut = tout.idfTransferOut
			inner join tflSiteToSiteGroup tstsg with (nolock)
			on	tstsg.idfsSite = tout.idfsSite
			inner join tflSiteGroup tsg with (nolock)
			on	tsg.idfSiteGroup = tstsg.idfSiteGroup
				and tsg.idfsRayon is null		
				and tsg.intRowStatus = 0	
			left join #TransferOutFiltered_HC tof_filt
			on tof_filt.idfTransferOut = tout.idfTransferOut 
			and tof_filt.idfSiteGroup = tsg.idfSiteGroup
		where 	tof_filt.idfTransferOut is null
		and (vc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		-- site group by transfer to
		insert into #TransferOutFiltered_HC
		select distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #HumanCase hc
			inner join	tlbMaterial AS m with (nolock)
			on	hc.idfHumanCase = m.idfHumanCase	
			inner join	tlbTransferOutMaterial AS toutm with (nolock)
			on	m.idfMaterial = toutm.idfMaterial
			inner join	tlbTransferOUT AS tout with (nolock)
			on	toutm.idfTransferOut = tout.idfTransferOut
			inner join	tstSite AS s with (nolock)
			on	tout.idfSendToOffice = s.idfOffice 
				and	s.intRowStatus = 0
			inner join tflSiteToSiteGroup tstsg with (nolock)
			on	tstsg.idfsSite = s.idfsSite
			inner join tflSiteGroup tsg with (nolock)
			on	tsg.idfSiteGroup = tstsg.idfSiteGroup
				and tsg.idfsRayon is null		
				and tsg.intRowStatus = 0	
			left join #TransferOutFiltered_HC tof_filt
			on tof_filt.idfTransferOut = tout.idfTransferOut 
			and tof_filt.idfSiteGroup = tsg.idfSiteGroup
		where 	tof_filt.idfTransferOut is null
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		--end transfer OUT				
	end
	
	--	Human Case data is always distributed across the sites of the same 
	--	administrative Rayon. All sites, where the value of the Rayon equals 
	--	to one of the Specific Case Rayons, have to receive Human Case data. 
	--	Specific Case Rayons list for the case includes: 
	
	

	--print 'Rayon'
	
	--	Rayon of the site, where the case was created;
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg2.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on	thc.idfHumanCase = hc.idfHumanCase
		inner join	tstSite AS s with (nolock)
		on	thc.idfsSite = s.idfsSite
		inner join tlbOffice o with (nolock)
		on	o.idfOffice = s.idfOffice
		inner join tlbGeoLocationShared tgl with (nolock)
		on tgl.idfGeoLocationShared = o.idfLocation
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfsRayon = tgl.idfsRayon
			and tsg.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg2 with (nolock)
		on tstsg2.idfsSite = tstsg.idfsSite
		inner join tflSiteGroup tsg2 with (nolock)
		on	tsg2.idfSiteGroup = tstsg2.idfSiteGroup
			and tsg2.idfsRayon is null		
			and tsg2.intRowStatus = 0	
			
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg2.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)	
	
	--	Rayon of the case current residence address;
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg2.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on	thc.idfHumanCase = hc.idfHumanCase
		inner join tlbHuman th
		on th.idfHuman = thc.idfHuman
		inner join tlbGeoLocation tgl with (nolock)
		on tgl.idfGeoLocation = th.idfCurrentResidenceAddress
		--and tgl.intRowStatus = 0 
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfsRayon = tgl.idfsRayon
			and tsg.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg2 with (nolock)
		on tstsg2.idfsSite = tstsg.idfsSite
		inner join tflSiteGroup tsg2 with (nolock)
		on	tsg2.idfSiteGroup = tstsg2.idfSiteGroup
			and tsg2.idfsRayon is null		
			and tsg2.intRowStatus = 0	
			
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg2.idfSiteGroup	
	where hcf.idfHumanCase is null		
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)	
	
	
	--	Rayon of the case location of exposure, if corresponding field was filled in;
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hc.idfHumanCase,
		tsg2.idfSiteGroup
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on	thc.idfHumanCase = hc.idfHumanCase
		inner join tlbGeoLocation tgl with (nolock)
		on tgl.idfGeoLocation = thc.idfPointGeoLocation
		--and tgl.intRowStatus = 0
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfsRayon = tgl.idfsRayon
			and tsg.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg2 with (nolock)
		on tstsg2.idfsSite = tstsg.idfsSite
		inner join tflSiteGroup tsg2 with (nolock)
		on	tsg2.idfSiteGroup = tstsg2.idfSiteGroup
			and tsg2.idfsRayon is null		
			and tsg2.intRowStatus = 0	
			
		left join #HumanCaseFiltered hcf
		on	hcf.idfHumanCase = hc.idfHumanCase 
			and	hcf.idfSiteGroup = tsg2.idfSiteGroup	
	where hcf.idfHumanCase is null	
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

	---------------------------------------------------------------------------------
	--print  'Site group relations'
	-- Site group relations
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hcf.idfHumanCase,
		tsgr.idfReceiverSiteGroup
	from #HumanCaseFiltered hcf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on hcf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #HumanCaseFiltered hcf2
		on	hcf2.idfHumanCase = hcf.idfHumanCase 
			and	hcf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where hcf2.idfHumanCase is null	
	and (hcf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

	-- Site group relations for transfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_HC
		(
			idfTransferOut,
			idfSiteGroup
		)
		select distinct
			vcf.idfTransferOut,
			tsgr.idfReceiverSiteGroup
		from #TransferOutFiltered_HC vcf
			inner join tflSiteGroupRelation tsgr with (nolock)
			on vcf.idfSiteGroup = tsgr.idfSenderSiteGroup
			
			left join #TransferOutFiltered_HC vcf2
			on	vcf2.idfTransferOut = vcf.idfTransferOut 
				and	vcf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
		where vcf2.idfTransferOut is null		
	end
	---------------------------------------------------------------------------------
	--print  'Border Areas Filtration'
	-- Border Areas Filtration
	-- updated!
	insert into #HumanCaseFiltered
	(
		idfHumanCase,
		idfSiteGroup
	)
	select distinct
		hcf.idfHumanCase,
		tsg_cent.idfSiteGroup
	from #HumanCaseFiltered hcf
		inner join tflSiteGroup tsg with (nolock)
		on tsg.idfSiteGroup = hcf.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteGroup tsg_cent with (nolock)
		on tsg_cent.idfsCentralSite = tstsg.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0	
		
		left join #HumanCaseFiltered hcf2
		on	hcf2.idfHumanCase = hcf.idfHumanCase 
			and	hcf2.idfSiteGroup = tsg_cent.idfSiteGroup
	where hcf2.idfHumanCase is null	
	and (hcf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	
	-- + for transfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_HC
		(
			idfTransferOut,
			idfSiteGroup
		)
		select distinct
			vcf.idfTransferOut,
			tsg_cent.idfSiteGroup
		from #TransferOutFiltered_HC vcf
			inner join tflSiteGroup tsg with (nolock)
			on tsg.idfSiteGroup = vcf.idfSiteGroup
			
			inner join tflSiteToSiteGroup tstsg with (nolock)
			on tstsg.idfSiteGroup = tsg.idfSiteGroup
			
			inner join tflSiteGroup tsg_cent with (nolock)
			on tsg_cent.idfsCentralSite = tstsg.idfsSite
			and tsg_cent.idfsRayon is null
			and tsg_cent.intRowStatus = 0	
			
			left join #TransferOutFiltered_HC vcf2
			on	vcf2.idfTransferOut = vcf.idfTransferOut 
				and	vcf2.idfSiteGroup = tsg_cent.idfSiteGroup
		where vcf2.idfTransferOut is null
	end
	---------------------------------------------------------------------------------	

	
	
	
	-- ADD rows from tflHumanCase
	insert into #HumanCaseFiltered
	(	idfHumanCase,	idfSiteGroup)
	select 
		thcf.idfHumanCase,
		thcf.idfSiteGroup
	from tflHumanCaseFiltered thcf
		inner join #HumanCase hc
		on hc.idfHumanCase = thcf.idfHumanCase
		
		left join #HumanCaseFiltered hcf
		on hcf.idfHumanCase = hc.idfHumanCase
		and hcf.idfSiteGroup = thcf.idfSiteGroup
	where  hcf.idfHumanCase is null
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		
	
	

	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	Child objects
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------	
	--print  'Child objects'
	--print  'Outbreak'	
	--	Outbreak

	
	insert into #Outbreak_HC
	select distinct
		thc.idfOutbreak,
		hc.idfHumanCase
	from #HumanCase hc
		inner join tlbHumanCase thc with (nolock)
		on thc.idfHumanCase = hc.idfHumanCase
		inner join tlbOutbreak otb with (nolock)
		on otb.idfOutbreak = thc.idfOutbreak
		
		left join #Outbreak_HC otb_f
		on otb_f.idfOutbreak = otb.idfOutbreak
		and otb_f.idfHumanCase = hc.idfHumanCase
	where  otb_f.idfOutbreak is null
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
				
		
	---------------------------------------------------------------------------------		
	--print  'Human'	
	--	Human
	if @FilterListedRecordsOnly = 0 
	begin
		insert into #Human_HC
		select distinct
			thc.idfHuman,
			hc.idfHumanCase
		from #HumanCase hc
			inner join tlbHumanCase thc with (nolock)
			on thc.idfHumanCase = hc.idfHumanCase
			inner join tlbHuman th with (nolock)
			on th.idfHuman = thc.idfHuman
			
			left join #Human_HC h_f
			on h_f.idfHuman = thc.idfHuman
			and h_f.idfHumanCase = thc.idfHumanCase
		where h_f.idfHuman is null
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		
		insert into #Human_HC
		select distinct
			tccp.idfHuman,
			hc.idfHumanCase
		from #HumanCase hc
			inner join tlbHumanCase thc with (nolock)
			on thc.idfHumanCase = hc.idfHumanCase		
				
			inner join tlbContactedCasePerson tccp with (nolock)
			on tccp.idfHumanCase = thc.idfHumanCase
			
			inner join tlbHuman th with (nolock)
			on th.idfHuman = thc.idfHuman
					
			left join #Human_HC h
			on h.idfHuman = tccp.idfHuman
			and h.idfHumanCase = tccp.idfHumanCase
			
		where h.idfHuman is null	
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end
	---------------------------------------------------------------------------------		
	--print  'GeoLocation'		
	--	GeoLocation		

	--geo location for  human case
	if @FilterListedRecordsOnly = 0 
	begin
		insert into #GeoLocation_HC
		select distinct
			thc.idfPointGeoLocation,
			hc.idfHumanCase
		from #HumanCase hc
			inner join tlbHumanCase thc with (nolock)
			on thc.idfHumanCase = hc.idfHumanCase	
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = thc.idfPointGeoLocation
			
			left join #GeoLocation_HC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfHumanCase = hc.idfHumanCase
		where gl.idfGeoLocation is null
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		--geo location for outbreak
		insert into #GeoLocation_HC
		select distinct
			tgl.idfGeoLocation,
			otb.idfHumanCase
		from #Outbreak_HC otb
			inner join tlbOutbreak totb with (nolock)
			on totb.idfOutbreak = otb.idfOutbreak
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = totb.idfGeoLocation	
			
			left join #GeoLocation_HC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfHumanCase = otb.idfHumanCase
		where gl.idfGeoLocation is null		
		and (otb.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		

		--geo location for human
		insert into #GeoLocation_HC
		select distinct
			tgl.idfGeoLocation,
			h.idfHumanCase
		from #Human_HC h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfCurrentResidenceAddress		
				
			left join #GeoLocation_HC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfHumanCase = h.idfHumanCase
		where gl.idfGeoLocation is null	
		and (h.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
			
		insert into #GeoLocation_HC
		select distinct
			tgl.idfGeoLocation,
			h.idfHumanCase
		from #Human_HC h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfRegistrationAddress		
				
			left join #GeoLocation_HC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfHumanCase = h.idfHumanCase
		where gl.idfGeoLocation is null		
		and (h.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
			
		insert into #GeoLocation_HC
		select distinct
			tgl.idfGeoLocation,
			h.idfHumanCase
		from #Human_HC h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfEmployerAddress		
				
			left join #GeoLocation_HC gl_filtered
			on gl_filtered.idfGeoLocation = tgl.idfGeoLocation
			and gl_filtered.idfHumanCase = h.idfHumanCase
		where gl_filtered.idfGeoLocation is null	
		and (h.idfHumanCase = @idfHumanCase or @idfHumanCase is null)		
	end	


	---------------------------------------------------------------------------------
	--print  'Batch Test	'				
	--	Batch Test	

	if @FilterListedRecordsOnly = 0 
	begin
		insert into #BatchTest_HC
		select distinct
			bt.idfBatchTest,
			hc.idfHumanCase
		from #HumanCase hc
			inner join	tlbMaterial as m with (nolock)
			on	hc.idfHumanCase = m.idfHumanCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join	tlbBatchTest as bt with (nolock)
			on	t.idfBatchTest = bt.idfBatchTest
		
			left join #BatchTest_HC bt_filtered
			on	bt_filtered.idfBatchTest = bt.idfBatchTest
			and bt_filtered.idfHumanCase = hc.idfHumanCase
		where bt_filtered.idfBatchTest is null
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end

	---------------------------------------------------------------------------------			
	--	Observation- x4 (CS, EPI, batch, test)
	--print  'Observation	'	

	if @FilterListedRecordsOnly = 0 
	begin
	insert into #Observation_HC
		select distinct
			thc.idfCSObservation,
			hc.idfHumanCase
		from #HumanCase hc
			inner join tlbHumanCase thc with (nolock)
			on thc.idfHumanCase = hc.idfHumanCase
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = thc.idfCSObservation
			
			left join #Observation_HC obs_filtered
			on obs_filtered.idfObservation = thc.idfCSObservation
			and obs_filtered.idfHumanCase = hc.idfHumanCase
		where obs_filtered.idfObservation is null
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into #Observation_HC
		select distinct
			thc.idfEpiObservation,
			hc.idfHumanCase
		from #HumanCase hc
			inner join tlbHumanCase thc with (nolock)
			on thc.idfHumanCase = hc.idfHumanCase
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = thc.idfEpiObservation
			
			left join #Observation_HC obs_filtered
			on obs_filtered.idfObservation = thc.idfEpiObservation
			and obs_filtered.idfHumanCase = hc.idfHumanCase
		where obs_filtered.idfObservation is null	
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
			
		insert into #Observation_HC
		select distinct
			tbt.idfObservation,
			bt.idfHumanCase
		from #BatchTest_HC bt
			inner join tlbBatchTest tbt with (nolock)
			on tbt.idfBatchTest = bt.idfBatchTest
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tbt.idfObservation
		
			left join #Observation_HC obs_filtered
			on obs_filtered.idfObservation = tbt.idfObservation
			and obs_filtered.idfHumanCase = bt.idfHumanCase
		where obs_filtered.idfObservation is null	
		and (bt.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
				
		insert into #Observation_HC
		select distinct
			t.idfObservation,
			hc.idfHumanCase
		from #HumanCase hc
			inner join tlbHumanCase thc with (nolock)
			on thc.idfHumanCase = hc.idfHumanCase
			
			inner join	tlbMaterial as m with (nolock)
			on	hc.idfHumanCase = m.idfHumanCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial		
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = t.idfObservation
			
			left join #Observation_HC obs_filtered
			on obs_filtered.idfObservation = t.idfObservation
			and obs_filtered.idfHumanCase = hc.idfHumanCase
		where obs_filtered.idfObservation is null	
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)	
	end
	
	---------------------------------------------------------------------------------		
	--print  'Notification	'		
	--	Notification
	if @FilterListedRecordsOnly = 0 
	begin
		-- by case
		insert into #Notification_HC 
		select distinct 
			nt.idfNotification,
			hc.idfHumanCase
		from	tstNotification AS nt with (nolock)
			inner join #HumanCase AS hc
			on nt.idfNotificationObject = hc.idfHumanCase
			
			left join #Notification_HC n_f
			on n_f.idfHumanCase = hc.idfHumanCase
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		
		-- by outbreak
		insert into #Notification_HC 
		select distinct 
			nt.idfNotification,
			otb.idfHumanCase
		from	tstNotification AS nt with (nolock)
			inner join #Outbreak_HC AS otb
			on nt.idfNotificationObject = otb.idfOutbreak
				
			left join #Notification_HC n_f
			on n_f.idfHumanCase = otb.idfHumanCase
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
		and (otb.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
			
		-- test
		insert into #Notification_HC 
		select distinct 
			nt.idfNotification,
			vss.idfHumanCase	
		from #HumanCase vss
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfHumanCase = m.idfHumanCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tstNotification nt
			on nt.idfNotificationObject = t.idfTesting	
				
			left join #Notification_HC n_f
			on n_f.idfHumanCase = vss.idfHumanCase
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null		
		and (vss.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end	
	-- + transfer out from #TransferOutFiltered_HC!!
	
	---------------------------------------------------------------------------------	
	--print  'DataAuditEvent	'		
	--	DataAuditEvent
		
	
	--hc
	insert into #DataAuditEvent_HC
	select distinct
		tdae.idfDataAuditEvent,
		hc.idfHumanCase
	from tauDataAuditEvent tdae with (nolock)
		inner join #HumanCase hc
		on hc.idfHumanCase = tdae.idfMainObject
		
		left join #DataAuditEvent_HC dae_f
		on dae_f.idfHumanCase = hc.idfHumanCase
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
	and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	
	-- outbreak
	insert into #DataAuditEvent_HC
	select distinct
		tdae.idfDataAuditEvent,
		otb.idfHumanCase 
	from tauDataAuditEvent tdae with (nolock)
		inner join #Outbreak_HC otb
		on otb.idfOutbreak = tdae.idfMainObject	
		
		left join #DataAuditEvent_HC dae_f
		on dae_f.idfHumanCase = otb.idfHumanCase
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
	and (otb.idfHumanCase = @idfHumanCase or @idfHumanCase is null)		
		
	if @FilterListedRecordsOnly = 0 
	begin
		-- human
		insert into #DataAuditEvent_HC
		select distinct
			tdae.idfDataAuditEvent,
			h.idfHumanCase 
		from tauDataAuditEvent tdae with (nolock)
			inner join #Human_HC h
			on h.idfHuman = tdae.idfMainObject	
			
			left join #DataAuditEvent_HC dae_f
			on dae_f.idfHumanCase = h.idfHumanCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null	
		and (h.idfHumanCase = @idfHumanCase or @idfHumanCase is null)				
			
		-- batch test
		insert into #DataAuditEvent_HC
		select distinct
			tdae.idfDataAuditEvent,
			bt.idfHumanCase
		from tauDataAuditEvent tdae with (nolock)
			inner join #BatchTest_HC bt
			on bt.idfBatchTest = tdae.idfMainObject			
			
			left join #DataAuditEvent_HC dae_f
			on dae_f.idfHumanCase = bt.idfHumanCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null	
		and (bt.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
				
		-- test
		insert into #DataAuditEvent_HC 
		select distinct 
			tdae.idfDataAuditEvent,
			hc.idfHumanCase	
		from #HumanCase hc
			inner join	tlbMaterial as m with (nolock)
			on	hc.idfHumanCase = m.idfHumanCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = t.idfTesting

			left join #DataAuditEvent_HC dae_f
			on dae_f.idfHumanCase = hc.idfHumanCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null	
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
				
		-- sample
		insert into #DataAuditEvent_HC 
		select distinct 
			tdae.idfDataAuditEvent,
			hc.idfHumanCase	
		from #HumanCase hc
			inner join	tlbMaterial as m with (nolock)
			on	hc.idfHumanCase = m.idfHumanCase
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = m.idfMaterial
		
			left join #DataAuditEvent_HC dae_f
			on dae_f.idfHumanCase = hc.idfHumanCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null		
		and (hc.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end
	
	
	
	
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	fill tfl tables 
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			
	--print  'fill tfl tables	'	
	-- human case
	if exists(select * from #HumanCaseFiltered) 
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #HumanCaseFiltered as hcf
			on  hcf.idfHumanCase = nID.idfKey1
		where  nID.strTableName = 'tflHumanCaseFiltered_Pfhc'
		and (hcf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflHumanCaseFiltered_Pfhc', 
				hcf.idfHumanCase, 
				hcf.idfSiteGroup
		from  #HumanCaseFiltered as hcf
			left join dbo.tflHumanCaseFiltered as thcf with (nolock)
			on  thcf.idfHumanCase = hcf.idfHumanCase
				and thcf.idfSiteGroup = hcf.idfSiteGroup
		where  thcf.idfHumanCaseFiltered is null
		and (hcf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflHumanCaseFiltered
			(
				idfHumanCaseFiltered, 
				idfHumanCase, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				hcf.idfHumanCase, 
				nID.idfKey2
		from #HumanCaseFiltered as hcf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflHumanCaseFiltered_Pfhc'
				and nID.idfKey1 = hcf.idfHumanCase
				and nID.idfKey2 is not null
			left join dbo.tflHumanCaseFiltered as thcf with (nolock)
			on   thcf.idfHumanCaseFiltered = nID.NewID
		where  thcf.idfHumanCaseFiltered is null
		and (hcf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #HumanCaseFiltered as hcf
			on   hcf.idfHumanCase = nID.idfKey1
		where  nID.strTableName = 'tflHumanCaseFiltered_Pfhc'
		and (hcf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end
	---------------------------------------------------------------------------------			
	-- outbreak
	if exists(select * from #Outbreak_HC) 
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Outbreak_HC as otbf
			on  otbf.idfOutbreak = nID.idfKey1 
		where  nID.strTableName = 'tflOutbreakFiltered_Pfhc'
		and (otbf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflOutbreakFiltered_Pfhc', 
				otbf.idfOutbreak, 
				hcf.idfSiteGroup
		from  #Outbreak_HC otbf
			inner join #HumanCaseFiltered as hcf
			on otbf.idfHumanCase = hcf.idfHumanCase
			left join dbo.tflOutbreakFiltered as tof with (nolock)
			on  tof.idfOutbreak = otbf.idfOutbreak
				and tof.idfSiteGroup = hcf.idfSiteGroup
		where  tof.idfOutbreakFiltered is null
		and (otbf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflOutbreakFiltered
			(
				idfOutbreakFiltered, 
				idfOutbreak, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				otbf.idfOutbreak, 
				nID.idfKey2
		from #Outbreak_HC as otbf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflOutbreakFiltered_Pfhc'
				and nID.idfKey1 = otbf.idfOutbreak
				and nID.idfKey2 is not null
			left join dbo.tflOutbreakFiltered as totbf with (nolock)
			on   totbf.idfOutbreakFiltered = nID.NewID
		where  totbf.idfOutbreakFiltered is null
		and (otbf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Outbreak_HC as otbf
			on  otbf.idfOutbreak = nID.idfKey1 
		where  nID.strTableName = 'tflOutbreakFiltered_Pfhc'
		and (otbf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end
	---------------------------------------------------------------------------------			
	-- human
	if exists(select * from #Human_HC) 
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_HC as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfhc'
		and (hf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflHumanFiltered_Pfhc', 
				hf.idfHuman, 
				hcf.idfSiteGroup
		from  #Human_HC hf
			inner join #HumanCaseFiltered as hcf
			on hf.idfHumanCase = hcf.idfHumanCase
			left join dbo.tflHumanFiltered as thcf with (nolock)
			on  thcf.idfHuman = hf.idfHuman
				and thcf.idfSiteGroup = hcf.idfSiteGroup
		where  thcf.idfHumanFiltered is null
		and (hf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflHumanFiltered
			(
				idfHumanFiltered, 
				idfHuman, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				hcf.idfHuman, 
				nID.idfKey2
		from #Human_HC as hcf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflHumanFiltered_Pfhc'
				and nID.idfKey1 = hcf.idfHuman
				and nID.idfKey2 is not null
			left join dbo.tflHumanFiltered as thf with (nolock)
			on   thf.idfHumanFiltered = nID.NewID
		where  thf.idfHumanFiltered is null
		and (hcf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_HC as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfhc'
		and (hf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end	
	---------------------------------------------------------------------------------			
	-- geo location
	if exists(select * from #GeoLocation_HC) 
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_HC as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfhc'
		and (glf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflGeoLocationFiltered_Pfhc', 
				glf.idfGeoLocation, 
				hcf.idfSiteGroup
		from  #GeoLocation_HC as glf
			inner join #HumanCaseFiltered as hcf
			on glf.idfHumanCase = hcf.idfHumanCase
			left join dbo.tflGeoLocationFiltered as tglf with (nolock)
			on  tglf.idfGeoLocation = glf.idfGeoLocation
				and tglf.idfSiteGroup = hcf.idfSiteGroup
		where  tglf.idfGeoLocation is null
		and (glf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflGeoLocationFiltered
			(
				idfGeoLocationFiltered, 
				idfGeoLocation, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				glf.idfGeoLocation, 
				nID.idfKey2
		from #GeoLocation_HC as glf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflGeoLocationFiltered_Pfhc'
				and nID.idfKey1 = glf.idfGeoLocation
				and nID.idfKey2 is not null
			left join dbo.tflGeoLocationFiltered as tglf with (nolock)
			on   tglf.idfGeoLocationFiltered = nID.NewID
		where  tglf.idfGeoLocationFiltered is null
		and (glf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_HC as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfhc'
		and (glf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
	end
	---------------------------------------------------------------------------------			
	-- batch test
	if exists(select * from #BatchTest_HC)  
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_HC as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfhc'
		and (btf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflBatchTestFiltered_Pfhc', 
				btf.idfBatchTest, 
				hcf.idfSiteGroup
		from  #BatchTest_HC as btf
			inner join #HumanCaseFiltered as hcf
			on btf.idfHumanCase = hcf.idfHumanCase
			left join dbo.tflBatchTestFiltered as tbtf with (nolock)
			on  tbtf.idfBatchTest = btf.idfBatchTest
				and tbtf.idfSiteGroup = hcf.idfSiteGroup
		where  tbtf.idfBatchTest is null
		and (btf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflBatchTestFiltered
			(
				idfBatchTestFiltered, 
				idfBatchTest, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				btf.idfBatchTest, 
				nID.idfKey2
		from #BatchTest_HC as btf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflBatchTestFiltered_Pfhc'
				and nID.idfKey1 = btf.idfBatchTest
				and nID.idfKey2 is not null
			left join dbo.tflBatchTestFiltered as tbtf with (nolock)
			on   tbtf.idfBatchTestFiltered = nID.NewID
		where  tbtf.idfBatchTestFiltered is null
		and (btf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_HC as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfhc'	
		and (btf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)	
	end
	---------------------------------------------------------------------------------			
	-- observation
	if exists(select * from #Observation_HC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_HC as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfhc'
		and (ofl.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflObservationFiltered_Pfhc', 
				ofl.idfObservation, 
				hcf.idfSiteGroup
		from   #Observation_HC as ofl
			inner join #HumanCaseFiltered as hcf
			on ofl.idfHumanCase = hcf.idfHumanCase
			left join dbo.tflObservationFiltered as tofl with (nolock)
			on  tofl.idfObservation = ofl.idfObservation
				and tofl.idfSiteGroup = hcf.idfSiteGroup
		where  tofl.idfObservation is null
		and (ofl.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflObservationFiltered
			(
				idfObservationFiltered, 
				idfObservation, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				ofl.idfObservation, 
				nID.idfKey2
		from #Observation_HC as ofl
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflObservationFiltered_Pfhc'
				and nID.idfKey1 = ofl.idfObservation
				and nID.idfKey2 is not null
			left join dbo.tflObservationFiltered as tofl with (nolock)
			on   tofl.idfObservationFiltered = nID.NewID
		where  tofl.idfObservationFiltered is null
		and (ofl.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_HC as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfhc'	
		and (ofl.idfHumanCase = @idfHumanCase or @idfHumanCase is null)	
	end		
	---------------------------------------------------------------------------------			
	-- notification
	if exists(select * from #Notification_HC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_HC as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfhc'
		and (nf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflNotificationFiltered_Pfhc', 
				nf.idfNotification, 
				hcf.idfSiteGroup
		from   #Notification_HC as nf
			inner join #HumanCaseFiltered as hcf
			on nf.idfHumanCase = hcf.idfHumanCase
			left join dbo.tflNotificationFiltered as tnf with (nolock)
			on  tnf.idfNotification = nf.idfNotification
				and tnf.idfSiteGroup = hcf.idfSiteGroup
		where  tnf.idfNotification is null
		and (nf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflNotificationFiltered_Pfhc', 
			tn.idfNotification, 
			tout.idfSiteGroup
		from #TransferOutFiltered_HC tout
			inner join tstNotification tn with (nolock)
			on tn.idfNotificationObject = tout.idfTransferOut
			left join dbo.tflNotificationFiltered as tnf with (nolock)
			on  tnf.idfNotification = tn.idfNotification
				and tnf.idfSiteGroup = tout.idfSiteGroup
		where  tnf.idfNotification is null
		
		insert into dbo.tflNotificationFiltered
			(
				idfNotificationFiltered, 
				idfNotification, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				nf.idfNotification, 
				nID.idfKey2
		from #Notification_HC as nf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfhc'
				and nID.idfKey1 = nf.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf with (nolock)
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null
		and (nf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNotificationFiltered
			(
				idfNotificationFiltered, 
				idfNotification, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				tn.idfNotification, 
				nID.idfKey2
		from #TransferOutFiltered_HC tout
			inner join tstNotification tn
			on tn.idfNotificationObject = tout.idfTransferOut
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfhc'
				and nID.idfKey1 = tn.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_HC as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfhc'
		and (nf.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join tstNotification tn with (nolock)
			on  tn.idfNotification = nID.idfKey1 
			
			inner join #TransferOutFiltered_HC tout
			on tn.idfNotification = tout.idfTransferOut
		where  nID.strTableName = 'tflNotificationFiltered_Pfhc'	
	end
	
	---------------------------------------------------------------------------------			
	-- TransferOut
	if exists(select * from #TransferOutFiltered_HC)  
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_HC as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfhc'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflTransferOutFiltered_Pfhc', 
				toutf.idfTransferOut, 
				toutf.idfSiteGroup
		from  #TransferOutFiltered_HC as toutf
			left join dbo.tflTransferOutFiltered as tof with (nolock)
			on  tof.idfTransferOut = toutf.idfTransferOut
				and tof.idfSiteGroup = toutf.idfSiteGroup
		where  tof.idfTransferOutFiltered is null
		
		insert into dbo.tflTransferOutFiltered
			(
				idfTransferOutFiltered, 
				idfTransferOut, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				toutf.idfTransferOut, 
				nID.idfKey2
		from #TransferOutFiltered_HC as toutf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflTransferOutFiltered_Pfhc'
				and nID.idfKey1 = toutf.idfTransferOut
				and nID.idfKey2 is not null
			left join dbo.tflTransferOutFiltered as tof with (nolock)
			on   tof.idfTransferOutFiltered = nID.NewID
		where  tof.idfTransferOutFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_HC as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfhc'
	end
	---------------------------------------------------------------------------------			
	-- data audit event
	if exists(select * from #DataAuditEvent_HC)  
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_HC as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfhc'
		and (dae.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflDataAuditEventFiltered_Pfhc', 
				dae.idfDataAuditEvent, 
				hcf.idfSiteGroup
		from   #DataAuditEvent_HC as dae
			inner join #HumanCaseFiltered as hcf
			on dae.idfHumanCase = hcf.idfHumanCase
			left join dbo.tflDataAuditEventFiltered as tdae with (nolock)
			on  tdae.idfDataAuditEvent = dae.idfDataAuditEvent
				and tdae.idfSiteGroup = hcf.idfSiteGroup
		where  tdae.idfDataAuditEvent is null
		and (dae.idfHumanCase = @idfHumanCase or @idfHumanCase is null)
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflDataAuditEventFiltered_Pfhc', 
			tn.idfDataAuditEvent, 
			tout.idfSiteGroup
		from #TransferOutFiltered_HC tout
			inner join tauDataAuditEvent tn
			on tn.idfMainObject = tout.idfTransferOut
			left join dbo.tflDataAuditEventFiltered as tdae with (nolock)
			on  tdae.idfDataAuditEvent = tn.idfDataAuditEvent
				and tdae.idfSiteGroup = tout.idfSiteGroup
		where  tdae.idfDataAuditEvent is null

		
		insert into dbo.tflDataAuditEventFiltered
			(
				idfDataAuditEventFiltered, 
				idfDataAuditEvent, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				dae.idfDataAuditEvent, 
				nID.idfKey2
		from #DataAuditEvent_HC as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfhc'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae with (nolock)
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null
		and (dae.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		insert into dbo.tflDataAuditEventFiltered
			(
				idfDataAuditEventFiltered, 
				idfDataAuditEvent, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				dae.idfDataAuditEvent, 
				nID.idfKey2
		from #DataAuditEvent_HC as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfhc'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null
		and (dae.idfHumanCase = @idfHumanCase or @idfHumanCase is null)


		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_HC as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfhc'
		and (dae.idfHumanCase = @idfHumanCase or @idfHumanCase is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join tauDataAuditEvent tn with (nolock)
			on  tn.idfDataAuditEvent = nID.idfKey1 
			
			inner join #TransferOutFiltered_HC tout
			on tn.idfDataAuditEvent = tout.idfTransferOut
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfhc'
	end													
