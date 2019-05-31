
--##SUMMARY Recalculation of filtration Vet Cases for replication .

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 26.05.2014

--##REMARKS Updated by: Romasheva S.
--##REMARKS Update date: 23.11.2015

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_VetCase null, 51583490000000

exec spFiltered_VetCase null, 51583910000000
*/


create proc spFiltered_VetCase (
	@StartDate datetime = null,
	@idfVetCase bigint = null
	)
as
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
		
	if Object_ID('tempdb..#VetCase') is null
	create table #VetCase (
		idfVetCase bigint not null primary key
	)

	if Object_ID('tempdb..#VetCaseFiltered') is null
	create table #VetCaseFiltered (
		id int identity(1,1),
		idfVetCaseFiltered bigint,
		idfVetCase bigint not null,
		idfSiteGroup bigint not null,
		primary key(
			idfVetCase asc,
			idfSiteGroup asc
		)
	)
	
	if Object_ID('tempdb..#TransferOutFiltered_VC') is null
	create table #TransferOutFiltered_VC (
		idfTransferOut	bigint,
		idfSiteGroup bigint not null,
		primary key (
			idfTransferOut asc,
			idfSiteGroup asc
		)
	)
	
	if Object_ID('tempdb..#Outbreak_VC') is null
	create table #Outbreak_VC (
		idfOutbreak bigint not null,
		idfVetCase bigint not null,
		primary key (
			idfOutbreak asc,
			idfVetCase asc
		)
	)	
	
	if Object_ID('tempdb..#Farm_VC') is null
	create table #Farm_VC (
		idfFarm bigint not null,
		idfVetCase bigint not null,
		primary key (
			idfFarm asc,
			idfVetCase asc
		)
		
	)
	
	if Object_ID('tempdb..#Human_VC') is null
	create table #Human_VC (
		idfHuman bigint not null,
		idfVetCase bigint not null
		primary key (
			idfHuman asc,
			idfVetCase asc
		)
	)	
	
	if Object_ID('tempdb..#GeoLocation_VC') is null
	create table #GeoLocation_VC (
		idfGeoLocation bigint not null, 
		idfVetCase bigint not null,
		primary key (
			idfGeoLocation asc, 
			idfVetCase asc
		)
	)	
	
	if Object_ID('tempdb..#BatchTest_VC') is null
	create table #BatchTest_VC (
		idfBatchTest bigint not null, 
		idfVetCase bigint not null,
		primary key (
			idfBatchTest asc, 
			idfVetCase asc
		)
	)
	
	if Object_ID('tempdb..#Observation_VC') is null
	create table #Observation_VC  (
		idfObservation bigint not null,
		idfVetCase bigint not null,	
		primary key (
			idfObservation asc,
			idfVetCase asc
		)
	)
	
	if Object_ID('tempdb..#Notification_VC') is null
	create table #Notification_VC  (
		idfNotification bigint not null,
		idfVetCase bigint not null,
		primary key (
			idfNotification asc,
			idfVetCase asc
		)
	)

	
	if Object_ID('tempdb..#DataAuditEvent_VC') is null
	create table #DataAuditEvent_VC  (
		idfDataAuditEvent bigint not null, 
		idfVetCase bigint not null,
		primary key (
			idfDataAuditEvent asc, 
			idfVetCase asc
		)
	)	
	
	
	
	insert into #VetCase
	select 
		vc.idfVetCase
	from tlbVetCase vc
	where (vc.idfVetCase = @idfVetCase or @idfVetCase is null) and
	(vc.datModificationForArchiveDate >= @StartDate or @StartDate is null)	
	
	
	-- !!! for @idfVetCase = -1,  vet case list passed into the procedure
	if @idfVetCase = -1 set @idfVetCase = null
	

	--site group by site
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg.idfSiteGroup
	from #VetCase vc
		inner join tlbVetCase tvc with (nolock)
		on	tvc.idfVetCase = vc.idfVetCase
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = tvc.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null
			and tsg.intRowStatus = 0
		left join #VetCaseFiltered vcf
		on vcf.idfVetCase = vc.idfVetCase
		and vcf.idfSiteGroup = tsg.idfSiteGroup
	where vcf.idfVetCase is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)
			
	--=============================================================================		
	--	Vet Case data is always distributed across the sites, 
	--	where the connected Outbreak is send, if the Vet Case 
	--	is the primary case for this Outbreak	
	declare @idfVetCaseFromOtb bigint	
	declare cur cursor local forward_only 
	for
	select 
		tvc.idfVetCase
	from #VetCase vc
		inner join	tlbOutbreak AS otb with (nolock)
		on	vc.idfVetCase = otb.idfPrimaryCaseOrSession	
		inner join tlbVetCase tvc
		on tvc.idfOutbreak = otb.idfOutbreak
		and tvc.idfVetCase <> otb.idfPrimaryCaseOrSession
		and tvc.idfVetCase <> isnull(@idfVetCase, 0)
	where (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	open cur
	fetch next from cur into @idfVetCaseFromOtb
	while @@FETCH_STATUS = 0 begin
		exec spFiltered_VetCase null, @idfVetCaseFromOtb
		fetch next from cur into @idfVetCaseFromOtb
	end	
	close cur
	deallocate cur
	
	declare @idfHumanCaseFromOtb bigint	
	declare cur cursor local forward_only 
	for
	select 
		tvc.idfHumanCase
	from #VetCase vc
		inner join	tlbOutbreak AS otb with (nolock)
		on	vc.idfVetCase = otb.idfPrimaryCaseOrSession	
		inner join tlbHumanCase tvc
		on tvc.idfOutbreak = otb.idfOutbreak
		and tvc.idfHumanCase <> otb.idfPrimaryCaseOrSession
	where (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	open cur
	fetch next from cur into @idfHumanCaseFromOtb
	while @@FETCH_STATUS = 0 begin
		exec spFiltered_HumanCase null, @idfHumanCaseFromOtb
		fetch next from cur into @idfHumanCaseFromOtb
	end	
	close cur
	deallocate cur
		
	--sessions
	declare @idfVectorSurveillanceSessionFromOtb bigint	
	declare cur cursor local forward_only 
	for
	select 
		tvss.idfVectorSurveillanceSession
	from #VetCase vc
		inner join	tlbOutbreak AS otb with (nolock)
		on	vc.idfVetCase = otb.idfPrimaryCaseOrSession	
		inner join tlbVectorSurveillanceSession tvss
		on tvss.idfOutbreak = otb.idfOutbreak
		and tvss.idfVectorSurveillanceSession <> otb.idfPrimaryCaseOrSession
	where (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	open cur
	fetch next from cur into @idfVectorSurveillanceSessionFromOtb
	while @@FETCH_STATUS = 0 begin
		exec spFiltered_VectorSurveillanceSession null, @idfVectorSurveillanceSessionFromOtb
		fetch next from cur into @idfVectorSurveillanceSessionFromOtb
	end	
	close cur
	deallocate cur		
	
	
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tof.idfSiteGroup
	from #VetCase vc
		inner join	tlbOutbreak AS otb with (nolock)
		on	vc.idfVetCase = otb.idfPrimaryCaseOrSession		
		inner join tflOutbreakFiltered tof  with (nolock)
		on	tof.idfOutbreak = otb.idfOutbreak
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tof.idfSiteGroup	
	where vcf.idfVetCase is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)
	-- end recalc case and sessions for outbreak
	--=============================================================================			
	
	--	Vet Case data is sent to all sites, which organizations are connected to 
	--	this particular Vet Case. Specific organizations list for the case includes: 
	
	--	Organization of the employee, specified in the �Reported By� field
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg.idfSiteGroup
	from #VetCase vc
		inner join tlbVetCase tvc with (nolock)
		on tvc.idfVetCase = vc.idfVetCase
		inner join tlbPerson pr with (nolock)
		on pr.idfPerson = tvc.idfPersonReportedBy
		inner join	tstSite AS s with (nolock)
		on	pr.idfInstitution = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tsg.idfSiteGroup	
	where vcf.idfVetCase is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)
		
	--	Organization of the employee, specified in the �Investigator Name� field
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg.idfSiteGroup
	from #VetCase vc
		inner join tlbVetCase tvc with (nolock)
		on tvc.idfVetCase = vc.idfVetCase
		inner join tlbPerson pr with (nolock)
		on pr.idfPerson = tvc.idfPersonInvestigatedBy
		inner join	tstSite AS s with (nolock)
		on	pr.idfInstitution = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tsg.idfSiteGroup	
	where vcf.idfVetCase is null	
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)
	
	
	--	Organization, specified in the �Collected By Institution� field for any sample
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg.idfSiteGroup
	from #VetCase vc
		inner join	tlbMaterial AS m with (nolock)
		on	vc.idfVetCase = m.idfVetCase		
		inner join	tstSite AS s with (nolock)
		on	m.idfFieldCollectedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0		
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tsg.idfSiteGroup	
	where vcf.idfVetCase is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
	--	Organization, specified in the �Sent To Organization� field for any sample
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg.idfSiteGroup
	from #VetCase vc
		inner join	tlbMaterial AS m with (nolock)
		on	vc.idfVetCase = m.idfVetCase		
		inner join	tstSite AS s with (nolock)
		on	m.idfSendToOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tsg.idfSiteGroup	
	where vcf.idfVetCase is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)		
	
	
	--	Organization where case-connected samples were transferred out. 
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg.idfSiteGroup
	from #VetCase vc
		inner join	tlbMaterial AS m with (nolock)
		on	vc.idfVetCase = m.idfVetCase	
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
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tsg.idfSiteGroup	
	where vcf.idfVetCase is null	
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	

	-- Transfer OUT 
	-- site group by creation site for tranfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_VC
		select  distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #VetCase vc
			inner join	tlbMaterial AS m with (nolock)
			on	vc.idfVetCase = m.idfVetCase	
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
			left join #TransferOutFiltered_VC tof_filt
			on tof_filt.idfTransferOut = tout.idfTransferOut 
			and tof_filt.idfSiteGroup = tsg.idfSiteGroup
		where 	tof_filt.idfTransferOut is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)
		
		-- site group by transfer to
		insert into #TransferOutFiltered_VC
		select  distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #VetCase vc
			inner join	tlbMaterial AS m with (nolock)
			on	vc.idfVetCase = m.idfVetCase	
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
			left join #TransferOutFiltered_VC tof_filt
			on tof_filt.idfTransferOut = tout.idfTransferOut 
			and tof_filt.idfSiteGroup = tsg.idfSiteGroup
		where 	tof_filt.idfTransferOut is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)
		--end transfer OUT
	end
	
	
	--	Vet Case data is always distributed across the sites 
	--	of the same administrative Rayon. All sites, where the value 
	--	of the Rayon equals to one of the Specific Case Rayons, have 
	--	to receive Vet Case data. Specific Case Rayons list for the case includes: 
	
	--	Rayon of the site, where the case was created;
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg2.idfSiteGroup
	from #VetCase vc
		inner join tlbVetCase tvc with (nolock)
		on	tvc.idfVetCase = vc.idfVetCase
		inner join	tstSite AS s with (nolock)
		on	tvc.idfsSite = s.idfsSite
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
			
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tsg2.idfSiteGroup	
	where vcf.idfVetCase is null	
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)		
	
	
	
	
	--	Rayon of the farm address;
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vc.idfVetCase,
		tsg2.idfSiteGroup
	from #VetCase vc
		inner join tlbVetCase tvc with (nolock)
		on	tvc.idfVetCase = vc.idfVetCase
		inner join tlbFarm tf with (nolock)
		on tf.idfFarm = tvc.idfFarm
		inner join tlbGeoLocation tgl with (nolock)
		on tgl.idfGeoLocation = tf.idfFarmAddress
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
			
		left join #VetCaseFiltered vcf
		on	vcf.idfVetCase = vc.idfVetCase 
			and	vcf.idfSiteGroup = tsg2.idfSiteGroup	
	where vcf.idfVetCase is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)
	
	---------------------------------------------------------------------------------
	-- Site group relations
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vcf.idfVetCase,
		tsgr.idfReceiverSiteGroup
	from #VetCaseFiltered vcf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on vcf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #VetCaseFiltered vcf2
		on	vcf2.idfVetCase = vcf.idfVetCase 
			and	vcf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where vcf2.idfVetCase is null	
	and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)
	
	-- Site group relations for transfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_VC
		(
			idfTransferOut,
			idfSiteGroup
		)
		select distinct
			vcf.idfTransferOut,
			tsgr.idfReceiverSiteGroup
		from #TransferOutFiltered_VC vcf
			inner join tflSiteGroupRelation tsgr with (nolock)
			on vcf.idfSiteGroup = tsgr.idfSenderSiteGroup
			
			left join #TransferOutFiltered_VC vcf2
			on	vcf2.idfTransferOut = vcf.idfTransferOut 
				and	vcf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
		where vcf2.idfTransferOut is null	
	end

	---------------------------------------------------------------------------------					
	-- Border Areas Filtration
	-- updated!
	insert into #VetCaseFiltered
	(
		idfVetCase,
		idfSiteGroup
	)
	select distinct
		vcf.idfVetCase,
		tsg_cent.idfSiteGroup
	from #VetCaseFiltered vcf
		inner join tflSiteGroup tsg with (nolock)
		on tsg.idfSiteGroup = vcf.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteGroup tsg_cent with (nolock)
		on tsg_cent.idfsCentralSite = tstsg.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0	
		
		left join #VetCaseFiltered vcf2
		on	vcf2.idfVetCase = vcf.idfVetCase 
			and	vcf2.idfSiteGroup = tsg_cent.idfSiteGroup
	where vcf2.idfVetCase is null
	and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)	
	
	
	-- + for transfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_VC
		(
			idfTransferOut,
			idfSiteGroup
		)
		select distinct
			vcf.idfTransferOut,
			tsg_cent.idfSiteGroup
		from #TransferOutFiltered_VC vcf
			inner join tflSiteGroup tsg with (nolock)
			on tsg.idfSiteGroup = vcf.idfSiteGroup
			
			inner join tflSiteToSiteGroup tstsg with (nolock)
			on tstsg.idfSiteGroup = tsg.idfSiteGroup
			
			inner join tflSiteGroup tsg_cent with (nolock)
			on tsg_cent.idfsCentralSite = tstsg.idfsSite
			and tsg_cent.idfsRayon is null
			and tsg_cent.intRowStatus = 0	
			
			left join #TransferOutFiltered_VC vcf2
			on	vcf2.idfTransferOut = vcf.idfTransferOut 
				and	vcf2.idfSiteGroup = tsg_cent.idfSiteGroup
		where vcf2.idfTransferOut is null
	end
	---------------------------------------------------------------------------------					
	
	-- ADD rows from tflVetCase
	insert into #VetCaseFiltered
	(	idfVetCase,	idfSiteGroup)
	select 
		vcf.idfVetCase,
		vcf.idfSiteGroup
	from tflVetCaseFiltered vcf
		inner join #VetCase vc
		on vc.idfVetCase = vcf.idfVetCase
		
		left join #VetCaseFiltered tvcf
		on tvcf.idfVetCase = vc.idfVetCase
		and tvcf.idfSiteGroup = vcf.idfSiteGroup
	where  tvcf.idfVetCase is null	
	and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)	
	
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	Child objects
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------				
	--	Outbreak

	
	insert into #Outbreak_VC
	select distinct
		otb.idfOutbreak,
		vc.idfVetCase
	from #VetCase vc
		inner join tlbVetCase tvc with (nolock)
		on tvc.idfVetCase = vc.idfVetCase
		inner join tlbOutbreak otb with (nolock)
		on otb.idfOutbreak = tvc.idfOutbreak
		left join #Outbreak_VC otb_f
		on otb_f.idfOutbreak = otb.idfOutbreak
		and otb_f.idfVetCase = vc.idfVetCase
	where otb_f.idfVetCase is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	
	---------------------------------------------------------------------------------			
	--	Farm 
	
	if @FilterListedRecordsOnly = 0
	begin
		insert into #Farm_VC
		select distinct
			tf.idfFarm,
			vc.idfVetCase
		from #VetCase vc
			inner join tlbVetCase tvc with (nolock)
			on tvc.idfVetCase = vc.idfVetCase
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = tvc.idfFarm	
			left join #Farm_VC f_f
			on f_f.idfFarm = tf.idfFarm
			and f_f.idfVetCase = vc.idfVetCase
		where f_f.idfFarm is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	
	---------------------------------------------------------------------------------			
	--	Farm owner
	if @FilterListedRecordsOnly = 0
	begin
		insert into #Human_VC
		select distinct
			th.idfHuman,
			vc.idfVetCase
		from #VetCase vc
			inner join tlbVetCase tvc with (nolock)
			on tvc.idfVetCase = vc.idfVetCase
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = tvc.idfFarm			
			inner join tlbHuman th with (nolock)
			on th.idfHuman = tf.idfHuman
			left join #Human_VC h_f
			on h_f.idfHuman = th.idfHuman
			and h_f.idfVetCase = vc.idfVetCase
		where h_f.idfHuman is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	---------------------------------------------------------------------------------			
	--	GeoLocation		

	if @FilterListedRecordsOnly = 0
	begin
		--geo location for outbreak
		insert into #GeoLocation_VC
		select distinct
			tgl.idfGeoLocation,
			otb.idfVetCase
		from #Outbreak_VC otb
			inner join tlbOutbreak totb with (nolock)
			on totb.idfOutbreak = otb.idfOutbreak
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = totb.idfGeoLocation	
			
			left join #GeoLocation_VC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVetCase = otb.idfVetCase
		where gl.idfGeoLocation is null		
		and (otb.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		--geo location for farm
		insert into #GeoLocation_VC
		select distinct
			tgl.idfGeoLocation,
			f.idfVetCase
		from #Farm_VC f
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = f.idfFarm
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = tf.idfFarmAddress		
			
			left join #GeoLocation_VC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVetCase = f.idfVetCase
		where gl.idfGeoLocation is null	
		and (f.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		
		--geo location for human - farm owner
		
		insert into #GeoLocation_VC
		select distinct
			tgl.idfGeoLocation,
			h.idfVetCase
		from #Human_VC h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfCurrentResidenceAddress		
				
			left join #GeoLocation_VC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVetCase = h.idfVetCase
		where gl.idfGeoLocation is null	
		and (h.idfVetCase = @idfVetCase or @idfVetCase is null)	
			
		insert into #GeoLocation_VC
		select distinct
			tgl.idfGeoLocation,
			h.idfVetCase
		from #Human_VC h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfRegistrationAddress		
				
			left join #GeoLocation_VC gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVetCase = h.idfVetCase
		where gl.idfGeoLocation is null		
		and (h.idfVetCase = @idfVetCase or @idfVetCase is null)	
			
		insert into #GeoLocation_VC
		select distinct
			tgl.idfGeoLocation,
			h.idfVetCase
		from #Human_VC h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfEmployerAddress		
				
			left join #GeoLocation_VC gl_filtered
			on gl_filtered.idfGeoLocation = tgl.idfGeoLocation
			and gl_filtered.idfVetCase = h.idfVetCase
		where gl_filtered.idfGeoLocation is null
		and (h.idfVetCase = @idfVetCase or @idfVetCase is null)					
	end
	
	---------------------------------------------------------------------------------			
	--	Batch Test	

	if @FilterListedRecordsOnly = 0
	begin
		insert into #BatchTest_VC
		select distinct
			bt.idfBatchTest,
			vc.idfVetCase
		from #VetCase vc
			inner join	tlbMaterial as m with (nolock)
			on	vc.idfVetCase = m.idfVetCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join	tlbBatchTest as bt with (nolock)
			on	t.idfBatchTest = bt.idfBatchTest
		
			left join #BatchTest_VC bt_filtered
			on	bt_filtered.idfBatchTest = bt.idfBatchTest
			and bt_filtered.idfVetCase = vc.idfVetCase
		where bt_filtered.idfBatchTest is null	
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	---------------------------------------------------------------------------------			
	--	Observation- x6 (VetCase, Farm, Species, Animal, batch, test)	
	

	if @FilterListedRecordsOnly = 0
	begin
		--case
		insert into #Observation_VC
		select distinct
			obs.idfObservation,
			vc.idfVetCase
		from #VetCase vc
			inner join tlbVetCase tvc with (nolock)
			on tvc.idfVetCase = vc.idfVetCase
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tvc.idfObservation
			
			left join #Observation_VC obs_filtered
			on obs_filtered.idfObservation = obs.idfObservation
			and obs_filtered.idfVetCase = vc.idfVetCase
		where obs_filtered.idfObservation is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
		

		
		--farm
		insert into #Observation_VC
		select distinct
			obs.idfObservation,
			f.idfVetCase
		from #Farm_VC f
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = f.idfFarm
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tf.idfObservation
			
			left join #Observation_VC obs_filtered
			on obs_filtered.idfObservation = obs.idfObservation
			and obs_filtered.idfVetCase = f.idfVetCase
		where obs_filtered.idfObservation is null
		and (f.idfVetCase = @idfVetCase or @idfVetCase is null)	

			
		--species
		insert into #Observation_VC
		select distinct
			obs.idfObservation,
			f.idfVetCase
		from #Farm_VC f
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = f.idfFarm
			
			inner join	tlbHerd as herd with (nolock)
			on	tf.idfFarm = herd.idfFarm
			
			inner join	tlbSpecies as species with (nolock)
			on	herd.idfHerd = species.idfHerd		
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = species.idfObservation
			
			left join #Observation_VC obs_filtered
			on obs_filtered.idfObservation = obs.idfObservation
			and obs_filtered.idfVetCase = f.idfVetCase
		where obs_filtered.idfObservation is null
		and (f.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		--animal
		insert into #Observation_VC
		select distinct
			obs.idfObservation,
			f.idfVetCase
		from #Farm_VC f
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = f.idfFarm
			
			inner join	tlbHerd as herd with (nolock)
			on	tf.idfFarm = herd.idfFarm
			
			inner join	tlbSpecies as species with (nolock)
			on	herd.idfHerd = species.idfHerd		
			
			inner join	tlbAnimal as animal with (nolock)
			on	species.idfSpecies = animal.idfSpecies		
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = animal.idfObservation
			
			left join #Observation_VC obs_filtered
			on obs_filtered.idfObservation = obs.idfObservation
			and obs_filtered.idfVetCase = f.idfVetCase
		where obs_filtered.idfObservation is null
		and (f.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		--batch
		insert into #Observation_VC
		select distinct
			obs.idfObservation,
			bt.idfVetCase
		from #BatchTest_VC bt
			inner join tlbBatchTest tbt with (nolock)
			on tbt.idfBatchTest = bt.idfBatchTest
			
			inner join tlbObservation obs with (nolock)
			on tbt.idfObservation = obs.idfObservation
		
			left join #Observation_VC obs_filtered
			on obs_filtered.idfObservation = tbt.idfObservation
			and obs_filtered.idfVetCase = bt.idfVetCase
		where obs_filtered.idfObservation is null	
		and (bt.idfVetCase = @idfVetCase or @idfVetCase is null)	
				
		-- test
		insert into #Observation_VC
		select distinct
			obs.idfObservation,
			vc.idfVetCase
		from #VetCase vc
			inner join tlbVetCase tvc with (nolock)
			on tvc.idfVetCase = vc.idfVetCase
			
			inner join	tlbMaterial as m with (nolock)
			on	vc.idfVetCase = m.idfVetCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial		
			
			inner join tlbObservation obs with (nolock)
			on t.idfObservation = obs.idfObservation
			
			left join #Observation_VC obs_filtered
			on obs_filtered.idfObservation = t.idfObservation
			and obs_filtered.idfVetCase = vc.idfVetCase
		where obs_filtered.idfObservation is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	---------------------------------------------------------------------------------			
	--	Notification
	if @FilterListedRecordsOnly = 0
	begin
		-- by case
		insert into #Notification_VC 
		select distinct 
			nt.idfNotification,
			vc.idfVetCase
		from	tstNotification AS nt with (nolock)
			inner join #VetCase AS vc
			on nt.idfNotificationObject = vc.idfVetCase
			left join #Notification_VC n_f
			on n_f.idfVetCase = vc.idfVetCase
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
		

		-- by outbreak
		insert into #Notification_VC 
		select distinct 
			nt.idfNotification,
			otb.idfVetCase
		from	tstNotification AS nt with (nolock)
			inner join #Outbreak_VC AS otb
			on nt.idfNotificationObject = otb.idfOutbreak	
			left join #Notification_VC n_f
			on n_f.idfVetCase = otb.idfVetCase
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
		and (otb.idfVetCase = @idfVetCase or @idfVetCase is null)	
			
		-- test
		insert into #Notification_VC 
		select distinct 
			nt.idfNotification,
			vss.idfVetCase	
		from #VetCase vss
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfVetCase = m.idfVetCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tstNotification nt  with (nolock)
			on nt.idfNotificationObject = t.idfTesting	
			
			left join #Notification_VC n_f
			on n_f.idfVetCase = vss.idfVetCase
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null	
		and (vss.idfVetCase = @idfVetCase or @idfVetCase is null)		
	end	
		
	---------------------------------------------------------------------------------			
	--	DataAuditEvent
	
	
	--vc
	insert into #DataAuditEvent_VC
	select distinct
		tdae.idfDataAuditEvent,
		vc.idfVetCase
	from tauDataAuditEvent tdae with (nolock)
		inner join #VetCase vc
		on vc.idfVetCase = tdae.idfMainObject
		left join #DataAuditEvent_VC dae_f
		on dae_f.idfVetCase = vc.idfVetCase
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
	and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	
	-- outbreak
	insert into #DataAuditEvent_VC
	select distinct
		tdae.idfDataAuditEvent,
		otb.idfVetCase 
	from tauDataAuditEvent tdae with (nolock)
		inner join #Outbreak_VC otb
		on otb.idfOutbreak = tdae.idfMainObject	
		left join #DataAuditEvent_VC dae_f
		on dae_f.idfVetCase = otb.idfVetCase
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
	and (otb.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
	if @FilterListedRecordsOnly = 0
	begin
		-- human
		insert into #DataAuditEvent_VC
		select distinct
			tdae.idfDataAuditEvent,
			h.idfVetCase 
		from tauDataAuditEvent tdae with (nolock)
			inner join #Human_VC h
			on h.idfHuman = tdae.idfMainObject		
			left join #DataAuditEvent_VC dae_f
			on dae_f.idfVetCase = h.idfVetCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null
		and (h.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		-- farm
		insert into #DataAuditEvent_VC
		select distinct
			tdae.idfDataAuditEvent,
			f.idfVetCase 
		from tauDataAuditEvent tdae with (nolock)
			inner join #Farm_VC f
			on f.idfFarm = tdae.idfMainObject	
			left join #DataAuditEvent_VC dae_f
			on dae_f.idfVetCase = f.idfVetCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null	
		and (f.idfVetCase = @idfVetCase or @idfVetCase is null)			
			
		-- batch test
		insert into #DataAuditEvent_VC
		select distinct
			tdae.idfDataAuditEvent,
			bt.idfVetCase
		from tauDataAuditEvent tdae with (nolock)
			inner join #BatchTest_VC bt
			on bt.idfBatchTest = tdae.idfMainObject		
			left join #DataAuditEvent_VC dae_f
			on dae_f.idfVetCase = bt.idfVetCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null	
		and (bt.idfVetCase = @idfVetCase or @idfVetCase is null)	
			
		-- test
		insert into #DataAuditEvent_VC 
		select distinct 
			tdae.idfDataAuditEvent,
			vc.idfVetCase	
		from #VetCase vc
			inner join	tlbMaterial as m with (nolock)
			on	vc.idfVetCase = m.idfVetCase
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = t.idfTesting
			
			left join #DataAuditEvent_VC dae_f
			on dae_f.idfVetCase = vc.idfVetCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
			
		-- sample
		insert into #DataAuditEvent_VC 
		select distinct 
			tdae.idfDataAuditEvent,
			vc.idfVetCase	
		from #VetCase vc
			inner join	tlbMaterial as m with (nolock)
			on	vc.idfVetCase = m.idfVetCase
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = m.idfMaterial
			
			left join #DataAuditEvent_VC dae_f
			on dae_f.idfVetCase = vc.idfVetCase
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null
		and (vc.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
		
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	fill tfl tables 
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			
		-- Vet case
	if exists(select * from #VetCaseFiltered)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #VetCaseFiltered as vcf
			on  vcf.idfVetCase = nID.idfKey1
		where  nID.strTableName = 'tflVetCaseFiltered_Pfvc'
		and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflVetCaseFiltered_Pfvc', 
				vcf.idfVetCase, 
				vcf.idfSiteGroup
		from  #VetCaseFiltered as vcf
			left join dbo.tflVetCaseFiltered as tvcf
			on  tvcf.idfVetCase = vcf.idfVetCase
				and tvcf.idfSiteGroup = vcf.idfSiteGroup
		where  tvcf.idfVetCaseFiltered is null
		and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		insert into dbo.tflVetCaseFiltered
			(
				idfVetCaseFiltered, 
				idfVetCase, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				vcf.idfVetCase, 
				nID.idfKey2
		from #VetCaseFiltered as vcf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflVetCaseFiltered_Pfvc'
				and nID.idfKey1 = vcf.idfVetCase
				and nID.idfKey2 is not null
			left join dbo.tflVetCaseFiltered as tvcf
			on   tvcf.idfVetCaseFiltered = nID.NewID
		where  tvcf.idfVetCaseFiltered is null
		and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		delete  nID
		from  dbo.tflNewID as nID
			inner join #VetCaseFiltered as vcf
			on   vcf.idfVetCase = nID.idfKey1
		where  nID.strTableName = 'tflVetCaseFiltered_Pfvc'
		and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	
	---------------------------------------------------------------------------------			
	-- outbreak
	if exists(select * from #Outbreak_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Outbreak_VC as otbf
			on  otbf.idfOutbreak = nID.idfKey1 
		where  nID.strTableName = 'tflOutbreakFiltered_Pfvc'
		and (otbf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflOutbreakFiltered_Pfvc', 
				otb.idfOutbreak, 
				vcf.idfSiteGroup
		from  #Outbreak_VC otb
			inner join #VetCaseFiltered as vcf
			on otb.idfVetCase = vcf.idfVetCase
			left join dbo.tflOutbreakFiltered as tof
			on  tof.idfOutbreak = otb.idfOutbreak
				and tof.idfSiteGroup = vcf.idfSiteGroup
		where  tof.idfOutbreakFiltered is null
		and (otb.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
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
		from #Outbreak_VC as otbf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflOutbreakFiltered_Pfvc'
				and nID.idfKey1 = otbf.idfOutbreak
				and nID.idfKey2 is not null
			left join dbo.tflOutbreakFiltered as totbf
			on   totbf.idfOutbreakFiltered = nID.NewID
		where  totbf.idfOutbreakFiltered is null
		and (otbf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Outbreak_VC as otbf
			on  otbf.idfOutbreak = nID.idfKey1 
		where  nID.strTableName = 'tflOutbreakFiltered_Pfvc'
		and (otbf.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end	

	---------------------------------------------------------------------------------			
	-- Farm
	if exists(select * from #Farm_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Farm_VC as ff
			on  ff.idfFarm = nID.idfKey1 
		where  nID.strTableName = 'tflFarmFiltered_Pfvc'
		and (ff.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflFarmFiltered_Pfvc', 
				f.idfFarm, 
				vcf.idfSiteGroup
		from  #Farm_VC f
			inner join #VetCaseFiltered as vcf
			on f.idfVetCase = vcf.idfVetCase
			left join dbo.tflFarmFiltered as tof
			on  tof.idfFarm = f.idfFarm
				and tof.idfSiteGroup = vcf.idfSiteGroup
		where  tof.idfFarmFiltered is null
		and (f.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		insert into dbo.tflFarmFiltered
			(
				idfFarmFiltered, 
				idfFarm, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				ff.idfFarm, 
				nID.idfKey2
		from #Farm_VC as ff
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflFarmFiltered_Pfvc'
				and nID.idfKey1 = ff.idfFarm
				and nID.idfKey2 is not null
			left join dbo.tflFarmFiltered as tff
			on   tff.idfFarmFiltered = nID.NewID
		where  tff.idfFarmFiltered is null
		and (ff.idfVetCase = @idfVetCase or @idfVetCase is null)	

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Farm_VC as ff
			on  ff.idfFarm = nID.idfKey1 
		where  nID.strTableName = 'tflFarmFiltered_Pfvc'	
		and (ff.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	
	---------------------------------------------------------------------------------			
	-- human
	if exists(select * from #Human_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_VC as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfvc'
		and (hf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflHumanFiltered_Pfvc', 
				h.idfHuman, 
				vcf.idfSiteGroup
		from  #Human_VC h
			inner join #VetCaseFiltered as vcf
			on h.idfVetCase = vcf.idfVetCase
			left join dbo.tflHumanFiltered as tvcf
			on  tvcf.idfHuman = h.idfHuman
				and tvcf.idfSiteGroup = vcf.idfSiteGroup
		where  tvcf.idfHumanFiltered is null
		and (h.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		insert into dbo.tflHumanFiltered
			(
				idfHumanFiltered, 
				idfHuman, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				vcf.idfHuman, 
				nID.idfKey2
		from #Human_VC as vcf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflHumanFiltered_Pfvc'
				and nID.idfKey1 = vcf.idfHuman
				and nID.idfKey2 is not null
			left join dbo.tflHumanFiltered as thf
			on   thf.idfHumanFiltered = nID.NewID
		where  thf.idfHumanFiltered is null
		and (vcf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_VC as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfvc'	
		and (hf.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	---------------------------------------------------------------------------------			
	-- geo location
	if exists(select * from #GeoLocation_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_VC as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfvc'
		and (glf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflGeoLocationFiltered_Pfvc', 
				glf.idfGeoLocation, 
				vcf.idfSiteGroup
		from  #GeoLocation_VC as glf 
			inner join #VetCaseFiltered as vcf 
			on glf.idfVetCase = vcf.idfVetCase
			left join dbo.tflGeoLocationFiltered as tglf
			on  tglf.idfGeoLocation = glf.idfGeoLocation
				and tglf.idfSiteGroup = vcf.idfSiteGroup
		where  tglf.idfGeoLocation is null
		and (glf.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
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
		from #GeoLocation_VC as glf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflGeoLocationFiltered_Pfvc'
				and nID.idfKey1 = glf.idfGeoLocation
				and nID.idfKey2 is not null
			left join dbo.tflGeoLocationFiltered as tglf
			on   tglf.idfGeoLocationFiltered = nID.NewID
		where  tglf.idfGeoLocationFiltered is null
		and (glf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_VC as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfvc'	
		and (glf.idfVetCase = @idfVetCase or @idfVetCase is null)	
	end
	---------------------------------------------------------------------------------			
	-- batch test
	if exists(select * from #BatchTest_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_VC as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfvc'
		and (btf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflBatchTestFiltered_Pfvc', 
				btf.idfBatchTest, 
				vcf.idfSiteGroup
		from  #BatchTest_VC as btf
			inner join #VetCaseFiltered as vcf
			on btf.idfVetCase = vcf.idfVetCase
			left join dbo.tflBatchTestFiltered as tbtf
			on  tbtf.idfBatchTest = btf.idfBatchTest
				and tbtf.idfSiteGroup = vcf.idfSiteGroup
		where  tbtf.idfBatchTest is null
		and (btf.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
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
		from #BatchTest_VC as btf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflBatchTestFiltered_Pfvc'
				and nID.idfKey1 = btf.idfBatchTest
				and nID.idfKey2 is not null
			left join dbo.tflBatchTestFiltered as tbtf
			on   tbtf.idfBatchTestFiltered = nID.NewID
		where  tbtf.idfBatchTestFiltered is null
		and (btf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_VC as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfvc'	
		and (btf.idfVetCase = @idfVetCase or @idfVetCase is null)		
	end
	---------------------------------------------------------------------------------			
	-- observation
	if exists(select * from #Observation_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_VC as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfvc'
		and (ofl.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflObservationFiltered_Pfvc', 
				ofl.idfObservation, 
				vcf.idfSiteGroup
		from   #Observation_VC as ofl 
			inner join #VetCaseFiltered as vcf
			on ofl.idfVetCase = vcf.idfVetCase
			left join dbo.tflObservationFiltered as tofl
			on  tofl.idfObservation = ofl.idfObservation
				and tofl.idfSiteGroup = vcf.idfSiteGroup
		where  tofl.idfObservation is null
		and (ofl.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
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
		from #Observation_VC as ofl
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflObservationFiltered_Pfvc'
				and nID.idfKey1 = ofl.idfObservation
				and nID.idfKey2 is not null
			left join dbo.tflObservationFiltered as tofl
			on   tofl.idfObservationFiltered = nID.NewID
		where  tofl.idfObservationFiltered is null
		and (ofl.idfVetCase = @idfVetCase or @idfVetCase is null)	

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_VC as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfvc'	
		and (ofl.idfVetCase = @idfVetCase or @idfVetCase is null)			
	end
	---------------------------------------------------------------------------------			
	-- notification
	if exists(select * from #Notification_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_VC as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfvc'
		and (nf.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflNotificationFiltered_Pfvc', 
				nf.idfNotification, 
				vcf.idfSiteGroup
		from   #Notification_VC as nf
			inner join #VetCaseFiltered as vcf
			on nf.idfVetCase = vcf.idfVetCase
			left join dbo.tflNotificationFiltered as tnf
			on  tnf.idfNotification = nf.idfNotification
				and tnf.idfSiteGroup = vcf.idfSiteGroup
		where  tnf.idfNotification is null
		and (nf.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflNotificationFiltered_Pfvc', 
			tn.idfNotification, 
			tout.idfSiteGroup
		from #TransferOutFiltered_VC tout
			inner join tstNotification tn
			on tn.idfNotificationObject = tout.idfTransferOut
			left join dbo.tflNotificationFiltered as tnf
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
		from #Notification_VC as nf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfvc'
				and nID.idfKey1 = nf.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null
		and (nf.idfVetCase = @idfVetCase or @idfVetCase is null)	

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
		from #TransferOutFiltered_VC tout
			inner join tstNotification tn
			on tn.idfNotificationObject = tout.idfTransferOut
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfvc'
				and nID.idfKey1 = tn.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null


		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_VC as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfvc'	
		and (nf.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join tstNotification tn
			on  tn.idfNotification = nID.idfKey1 
			
			inner join #TransferOutFiltered_VC tout
			on tn.idfNotification = tout.idfTransferOut
		where  nID.strTableName = 'tflNotificationFiltered_Pfvc'		
	end
	---------------------------------------------------------------------------------			
	-- TransferOut
	if exists(select * from #TransferOutFiltered_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_VC as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfvc'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflTransferOutFiltered_Pfvc', 
				toutf.idfTransferOut, 
				toutf.idfSiteGroup
		from  #TransferOutFiltered_VC as toutf
			left join dbo.tflTransferOutFiltered as tof
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
		from #TransferOutFiltered_VC as toutf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflTransferOutFiltered_Pfvc'
				and nID.idfKey1 = toutf.idfTransferOut
				and nID.idfKey2 is not null
			left join dbo.tflTransferOutFiltered as tof
			on   tof.idfTransferOutFiltered = nID.NewID
		where  tof.idfTransferOutFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_VC as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfvc'
	end
	---------------------------------------------------------------------------------			
	-- data audit event
	if exists(select * from #DataAuditEvent_VC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_VC as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfvc'
		and (dae.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflDataAuditEventFiltered_Pfvc', 
				dae.idfDataAuditEvent, 
				vcf.idfSiteGroup
		from   #DataAuditEvent_VC as dae
			inner join #VetCaseFiltered as vcf
			on dae.idfVetCase = vcf.idfVetCase
			left join dbo.tflDataAuditEventFiltered as tdae
			on  tdae.idfDataAuditEvent = dae.idfDataAuditEvent
				and tdae.idfSiteGroup = vcf.idfSiteGroup
		where  tdae.idfDataAuditEvent is null
		and (dae.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflDataAuditEventFiltered_Pfvc', 
			tn.idfDataAuditEvent, 
			tout.idfSiteGroup
		from #TransferOutFiltered_VC tout
			inner join tauDataAuditEvent tn
			on tn.idfMainObject = tout.idfTransferOut
			left join dbo.tflDataAuditEventFiltered as tdae
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
		from #DataAuditEvent_VC as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfvc'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null
		and (dae.idfVetCase = @idfVetCase or @idfVetCase is null)	

		insert into dbo.tflDataAuditEventFiltered
			(
				idfDataAuditEventFiltered, 
				idfDataAuditEvent, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				tn.idfDataAuditEvent, 
				nID.idfKey2
		from #TransferOutFiltered_VC tout
			inner join tauDataAuditEvent tn
			on tn.idfMainObject = tout.idfTransferOut
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfvc'
				and nID.idfKey1 = tn.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_VC as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfvc'
		and (dae.idfVetCase = @idfVetCase or @idfVetCase is null)	
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join tauDataAuditEvent tn
			on  tn.idfDataAuditEvent = nID.idfKey1 
			
			inner join #TransferOutFiltered_VC tout
			on tn.idfDataAuditEvent = tout.idfTransferOut
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfvc'		
	end		
