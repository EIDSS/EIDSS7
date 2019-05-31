
--##SUMMARY Recalculation of filtration Active Surveillance Session for replication .

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 02.06.2014

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 26.08.2014

--##REMARKS Updated: Romasheva S.
--##REMARKS Update date: 26.08.2015

--##REMARKS Updated by: Romasheva S.
--##REMARKS Update date: 23.11.2015

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_ActiveSurveillanceSession '20131231'
*/


create proc spFiltered_ActiveSurveillanceSession (
	@StartDate datetime = null,
	@idfMonitoringSession bigint = null
	)
as
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
		
		
	if Object_ID('tempdb..#MonitoringSession') is null		
	create table #MonitoringSession (
		idfMonitoringSession bigint not null primary key
	)

	if Object_ID('tempdb..#MonitoringSessionFiltered') is null	
	create table #MonitoringSessionFiltered (
		id int identity(1,1),
		idfMonitoringSessionFiltered bigint,
		idfMonitoringSession bigint not null,
		idfSiteGroup bigint not null,
		primary key (
			idfMonitoringSession asc,
			idfSiteGroup asc
		)
	)
	
	if Object_ID('tempdb..#TransferOutFiltered_MS') is null	
	create table #TransferOutFiltered_MS (
		idfTransferOut	bigint,
		idfSiteGroup bigint not null,
		primary key (
		 	idfTransferOut	asc,
			idfSiteGroup asc
		 )
	)
	
	if Object_ID('tempdb..#Farm_MS') is null	
	create table #Farm_MS (
		idfFarm bigint not null ,
		idfMonitoringSession bigint not null,
		primary key (
			idfFarm asc,
			idfMonitoringSession asc
		)
		
	)	
	
	if Object_ID('tempdb..#Human_MS') is null	
	create table #Human_MS (
		idfHuman bigint not null ,
		idfMonitoringSession bigint not null,
		primary key (
			idfHuman asc,
			idfMonitoringSession asc
		)
		
	)
	
	
	if Object_ID('tempdb..#GeoLocation_MS') is null
	create table #GeoLocation_MS (
		idfGeoLocation bigint not null,
		idfMonitoringSession bigint not null,
		 primary key (
		 	idfGeoLocation asc,
			idfMonitoringSession asc
		 )
	)
	
		
	if Object_ID('tempdb..#BatchTest_MS') is null
	create table  #BatchTest_MS (
		idfBatchTest bigint not null,
		idfMonitoringSession bigint not null,
		primary key (
			idfBatchTest asc,
			idfMonitoringSession asc
		)
	)		

	if Object_ID('tempdb..#Observation_MS') is null
	create table #Observation_MS (
		idfObservation bigint not null,
		idfMonitoringSession bigint not null,
		primary key (
			idfObservation asc,
			idfMonitoringSession asc
		)	
	)		
	

	if Object_ID('tempdb..#Notification_MS') is null		
	create table #Notification_MS (
		idfNotification bigint not null,
		idfMonitoringSession bigint not null,
		primary key (
			idfNotification asc,
			idfMonitoringSession asc
		)
	)		
		
	if Object_ID('tempdb..#DataAuditEvent_MS') is null		
	create table #DataAuditEvent_MS  (
		idfDataAuditEvent bigint not null ,
		idfMonitoringSession bigint not null,
		primary key (
			idfDataAuditEvent asc,
			idfMonitoringSession asc
		)
	)			
	
	insert into #MonitoringSession
	select distinct
		ms.idfMonitoringSession
	from tlbMonitoringSession ms
		left join #MonitoringSession ms_f
		on ms_f.idfMonitoringSession = ms.idfMonitoringSession
	where
		 ms_f.idfMonitoringSession is null and
		(ms.idfMonitoringSession = @idfMonitoringSession or @idfMonitoringSession is null) and
		(ms.datModificationForArchiveDate >= @StartDate or @StartDate is null)	
	
	-- !!! for @idfMonitoringSession = -1, session list passed into the procedure
	if @idfMonitoringSession = -1 set @idfMonitoringSession = null
	
	
	--	Active Surveillance Session data is always distributed across the sites 
	--	where the Livestock Cases, linked to the Active Surveillance Session, is replicated.	
	declare @idfVetCase bigint	
	declare cur cursor local forward_only 
	for
	select 
		tvc.idfVetCase
	from #MonitoringSession ms
		inner join	dbo.tlbMonitoringSession AS tms with (nolock)
		on	ms.idfMonitoringSession = tms.idfMonitoringSession	
		inner join tlbVetCase tvc with (nolock)
		on tvc.idfParentMonitoringSession = tms.idfMonitoringSession
	open cur
	fetch next from cur into @idfVetCase
	while @@FETCH_STATUS = 0 begin
		exec spFiltered_VetCase null, @idfVetCase
		fetch next from cur into @idfVetCase
	end	
	close cur
	deallocate cur
	
	
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tvcf.idfSiteGroup
	from #MonitoringSession ms
		inner join	dbo.tlbMonitoringSession AS tms with (nolock)
		on	ms.idfMonitoringSession = tms.idfMonitoringSession	
		inner join tlbVetCase tvc with (nolock)
		on tvc.idfParentMonitoringSession = tms.idfMonitoringSession		
		inner join tflVetCaseFiltered tvcf  with (nolock)
		on	tvcf.idfVetCase = tvc.idfVetCase
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tvcf.idfSiteGroup	
	where msf.idfMonitoringSession is null
	
	--site group by site
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg.idfSiteGroup
	from #MonitoringSession ms
		inner join tlbMonitoringSession tms with (nolock)
		on	tms.idfMonitoringSession = ms.idfMonitoringSession
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = tms.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null
			and tsg.intRowStatus = 0
		
		left join #MonitoringSessionFiltered mssf
		on mssf.idfSiteGroup = tsg.idfSiteGroup
		and mssf.idfMonitoringSession = ms.idfMonitoringSession
	where mssf.idfMonitoringSession is null
			

			
	--	Active Surveillance Session data is sent to all sites of organizations where 
	--	session-connected Samples were transferred out.			
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg.idfSiteGroup
	from #MonitoringSession ms
		inner join	tlbMaterial AS m with (nolock)
		on	ms.idfMonitoringSession = m.idfMonitoringSession	
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
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tsg.idfSiteGroup	
	where msf.idfMonitoringSession is null				
	
	--Organization, specified in the �Collected By Institution� field for any sample -- !!!new 26.08.2015
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg.idfSiteGroup
	from #MonitoringSession ms
		inner join	tlbMaterial AS m with (nolock)
		on	ms.idfMonitoringSession = m.idfMonitoringSession	
		inner join	tlbTransferOutMaterial AS toutm with (nolock)
		on	m.idfMaterial = toutm.idfMaterial
		inner join	tstSite AS s with (nolock)
		on	m.idfFieldCollectedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tsg.idfSiteGroup	
	where msf.idfMonitoringSession is null		
	
	--Organization, specified in the �Sent To Organization� field for any sample -- !!!new 26.08.2015
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg.idfSiteGroup
	from #MonitoringSession ms
		inner join	tlbMaterial AS m with (nolock)
		on	ms.idfMonitoringSession = m.idfMonitoringSession	
		inner join	tlbTransferOutMaterial AS toutm with (nolock)
		on	m.idfMaterial = toutm.idfMaterial
		inner join	tstSite AS s with (nolock)
		on	m.idfSendToOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tsg.idfSiteGroup	
	where msf.idfMonitoringSession is null		
	

	
	-- Transfer OUT 
	-- site group by creation site for tranfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_MS
		select  distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #MonitoringSession vc
			inner join	tlbMaterial AS m with (nolock)
			on	vc.idfMonitoringSession = m.idfMonitoringSession	
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
			left join #TransferOutFiltered_MS tof_filt
			on tof_filt.idfTransferOut = tout.idfTransferOut 
			and tof_filt.idfSiteGroup = tsg.idfSiteGroup
		where 	tof_filt.idfTransferOut is null
		
		-- site group by transfer to
		insert into #TransferOutFiltered_MS
		select distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #MonitoringSession ms
			inner join	tlbMaterial AS m with (nolock)
			on	ms.idfMonitoringSession = m.idfMonitoringSession	
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
			left join #TransferOutFiltered_MS tof_filt
			on tof_filt.idfTransferOut = tout.idfTransferOut 
		where 	tof_filt.idfTransferOut is null
		--end transfer OUT		
	end	

	--	Active Surveillance Session data is always distributed across the sites of the same administrative Rayon. 
	--	All sites, where the value of the Rayon equals to one of the Specific Session Rayons, have to receive 
	--	Active Surveillance Session data. Specific Session Rayons list for the case includes: 
	
	--	Rayon of the site, where the session was created;
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg2.idfSiteGroup
	from #MonitoringSession ms
		inner join tlbMonitoringSession tms with (nolock)
		on	tms.idfMonitoringSession = ms.idfMonitoringSession
		inner join	tstSite AS s with (nolock)
		on	tms.idfsSite = s.idfsSite
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
			
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tsg2.idfSiteGroup	
	where msf.idfMonitoringSession is null			
		

		
	--	Rayon of the session address;
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg2.idfSiteGroup
	from #MonitoringSession ms
		inner join tlbMonitoringSession tms with (nolock)
		on	tms.idfMonitoringSession = ms.idfMonitoringSession

		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfsRayon = tms.idfsRayon
			and tsg.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg2 with (nolock)
		on tstsg2.idfsSite = tstsg.idfsSite
		inner join tflSiteGroup tsg2 with (nolock)
		on	tsg2.idfSiteGroup = tstsg2.idfSiteGroup
			and tsg2.idfsRayon is null		
			and tsg2.intRowStatus = 0	
			
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tsg2.idfSiteGroup	
	where msf.idfMonitoringSession is null			


	
	--	Rayon of any farm address, linked to the session;
	--select distinct
	--	ms.idfMonitoringSession,
	--	tstsg.strSiteID as [SiteID by Rayon],
	--	tstsg2.strSiteID, tsg2.strSiteGroupName, tsg2.idfsCentralSite,
	--	tsg2.idfsRayon
	--from #MonitoringSession ms
	--	inner join tlbMonitoringSession tms with (nolock)
	--	on	tms.idfMonitoringSession = ms.idfMonitoringSession
	--	inner join tlbFarm tf with (nolock)
	--	on tf.idfMonitoringSession = tms.idfMonitoringSession
	--	inner join tlbGeoLocation tgl with (nolock)
	--	on tgl.idfGeoLocation = tf.idfFarmAddress
	--	inner join tflSiteGroup tsg with (nolock)
	--	on	tsg.idfsRayon = tgl.idfsRayon
	--		and tsg.intRowStatus = 0
	--	inner join tflSiteToSiteGroup tstsg with (nolock)
	--	on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
	--	inner join tflSiteToSiteGroup tstsg2 with (nolock)
	--	on tstsg2.idfsSite = tstsg.idfsSite
	--	inner join tflSiteGroup tsg2 with (nolock)
	--	on	tsg2.idfSiteGroup = tstsg2.idfSiteGroup
	--		and tsg2.idfsRayon is null		
	--		and tsg2.intRowStatus = 0	
			
			
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg2.idfSiteGroup
	from #MonitoringSession ms
		inner join tlbMonitoringSession tms with (nolock)
		on	tms.idfMonitoringSession = ms.idfMonitoringSession
		inner join tlbFarm tf with (nolock)
		on tf.idfMonitoringSession = tms.idfMonitoringSession
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
			
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tsg2.idfSiteGroup	
	where msf.idfMonitoringSession is null	
	
	--check!!!
	--select tsg.*, tstsg.strSiteID
	--from #MonitoringSessionFiltered msf
	--inner join tflSiteGroup tsg
	--on tsg.idfSiteGroup = msf.idfSiteGroup	
	--inner join tflSiteToSiteGroup tstsg
	--on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		ms.idfMonitoringSession,
		tsg2.idfSiteGroup
	from #MonitoringSession ms
		inner join tlbMonitoringSessionSummary tmss with (nolock)
		on	tmss.idfMonitoringSession = ms.idfMonitoringSession
		inner join tlbFarm tf with (nolock)
		on tf.idfFarm = tmss.idfFarm
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
			
		left join #MonitoringSessionFiltered msf
		on	msf.idfMonitoringSession = ms.idfMonitoringSession 
			and	msf.idfSiteGroup = tsg2.idfSiteGroup	
	where msf.idfMonitoringSession is null	
					
	---------------------------------------------------------------------------------
	-- Site group relations
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		msf.idfMonitoringSession,
		tsgr.idfReceiverSiteGroup
	from #MonitoringSessionFiltered msf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on msf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #MonitoringSessionFiltered msf2
		on	msf2.idfMonitoringSession = msf.idfMonitoringSession 
			and	msf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where msf2.idfMonitoringSession is null	
	
	-- Site group relations for transfer out
	insert into #TransferOutFiltered_MS
	(
		idfTransferOut,
		idfSiteGroup
	)
	select distinct
		vcf.idfTransferOut,
		tsgr.idfReceiverSiteGroup
	from #TransferOutFiltered_MS vcf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on vcf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #TransferOutFiltered_MS vcf2
		on	vcf2.idfTransferOut = vcf.idfTransferOut 
			and	vcf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where vcf2.idfTransferOut is null			
	---------------------------------------------------------------------------------					
	-- Border Areas Filtration
	-- updated!
	insert into #MonitoringSessionFiltered
	(
		idfMonitoringSession,
		idfSiteGroup
	)
	select distinct
		msf.idfMonitoringSession,
		tsg_cent.idfSiteGroup
	from #MonitoringSessionFiltered msf
		inner join tflSiteGroup tsg with (nolock)
		on tsg.idfSiteGroup = msf.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteGroup tsg_cent with (nolock)
		on tsg_cent.idfsCentralSite = tstsg.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0		
		
		left join #MonitoringSessionFiltered msf2
		on	msf2.idfMonitoringSession = msf.idfMonitoringSession 
			and	msf2.idfSiteGroup = tsg_cent.idfSiteGroup
	where msf2.idfMonitoringSession is null
	
	-- + for transfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_MS
		(
			idfTransferOut,
			idfSiteGroup
		)
		select distinct
			vcf.idfTransferOut,
			tsg_cent.idfSiteGroup
		from #TransferOutFiltered_MS vcf
			inner join tflSiteGroup tsg with (nolock)
			on tsg.idfSiteGroup = vcf.idfSiteGroup
			
			inner join tflSiteToSiteGroup tstsg with (nolock)
			on tstsg.idfSiteGroup = tsg.idfSiteGroup
			
			inner join tflSiteGroup tsg_cent with (nolock)
			on tsg_cent.idfsCentralSite = tstsg.idfsSite
			and tsg_cent.idfsRayon is null
			and tsg_cent.intRowStatus = 0	
			
			left join #TransferOutFiltered_MS vcf2
			on	vcf2.idfTransferOut = vcf.idfTransferOut 
				and	vcf2.idfSiteGroup = tsg_cent.idfSiteGroup
		where vcf2.idfTransferOut is null
	end
	---------------------------------------------------------------------------------		
		
	-- ADD rows from tflMonitoringSessionFiltered
	insert into #MonitoringSessionFiltered
	(	idfMonitoringSession,	idfSiteGroup)
	select 
		msf.idfMonitoringSession,
		msf.idfSiteGroup
	from tflMonitoringSessionFiltered msf
		inner join #MonitoringSession ms
		on ms.idfMonitoringSession = msf.idfMonitoringSession
		
		left join #MonitoringSessionFiltered tmsf
		on tmsf.idfMonitoringSession = ms.idfMonitoringSession
		and tmsf.idfSiteGroup = msf.idfSiteGroup
	where  tmsf.idfMonitoringSession is null	
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	Child objects
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------						
	
	---------------------------------------------------------------------------------			
	--	Farm 

	if @FilterListedRecordsOnly = 0
	begin
		insert into #Farm_MS
		select distinct
			tf.idfFarm,
			ms.idfMonitoringSession
		from #MonitoringSession ms
			inner join tlbMonitoringSession tms with (nolock)
			on tms.idfMonitoringSession = ms.idfMonitoringSession
			inner join tlbFarm tf with (nolock)
			on tf.idfMonitoringSession = tms.idfMonitoringSession	
			
			left join #Farm_MS f_f
			on f_f.idfFarm = tf.idfFarm
			and f_f.idfMonitoringSession = ms.idfMonitoringSession
		where f_f.idfFarm is null 
		
			
		insert into #Farm_MS
		select distinct
			tf.idfFarm,
			ms.idfMonitoringSession
		from #MonitoringSession ms
			inner join tlbMonitoringSessionSummary tmss with (nolock)
			on tmss.idfMonitoringSession = ms.idfMonitoringSession
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = tmss.idfFarm	
			left join #Farm_MS f
			on f.idfFarm = tf.idfFarm
			and f.idfMonitoringSession = ms.idfMonitoringSession
		where f.idfFarm is null	
	end	
	---------------------------------------------------------------------------------			
	--	Farm owner
	
	if @FilterListedRecordsOnly = 0
	begin
		insert into #Human_MS
		select distinct
			th.idfHuman,
			ms.idfMonitoringSession
		from #MonitoringSession ms
			inner join tlbMonitoringSession tms with (nolock)
			on tms.idfMonitoringSession = ms.idfMonitoringSession
			inner join tlbFarm tf with (nolock)
			on tf.idfMonitoringSession = tms.idfMonitoringSession			
			inner join tlbHuman th with (nolock)
			on th.idfHuman = tf.idfHuman
			
			left join #Human_MS h_f
			on h_f.idfHuman = th.idfHuman
			and h_f.idfMonitoringSession = ms.idfMonitoringSession
		where h_f.idfHuman is null
			
		insert into #Human_MS
		select distinct
			th.idfHuman,
			ms.idfMonitoringSession
		from #MonitoringSession ms
			inner join tlbMonitoringSessionSummary tms with (nolock)
			on tms.idfMonitoringSession = ms.idfMonitoringSession
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = tms.idfFarm			
			inner join tlbHuman th with (nolock)
			on th.idfHuman = tf.idfHuman		
			left join #Human_MS h
			on h.idfHuman = th.idfHuman
			and h.idfMonitoringSession = ms.idfMonitoringSession
		where h.idfHuman is null
	end	
		

	---------------------------------------------------------------------------------			
	--	GeoLocation		

	
	if @FilterListedRecordsOnly = 0
	begin
		--geo location for farm
		insert into #GeoLocation_MS
		select distinct
			tgl.idfGeoLocation,
			f.idfMonitoringSession
		from #Farm_MS f
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = f.idfFarm
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = tf.idfFarmAddress		
			
			left join #GeoLocation_MS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfMonitoringSession = f.idfMonitoringSession
		where gl.idfGeoLocation is null	
		
		
		--geo location for human - farm owner
		insert into #GeoLocation_MS
		select distinct
			tgl.idfGeoLocation,
			h.idfMonitoringSession
		from #Human_MS h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfCurrentResidenceAddress		
				
			left join #GeoLocation_MS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfMonitoringSession = h.idfMonitoringSession
		where gl.idfGeoLocation is null	
			
		insert into #GeoLocation_MS
		select distinct
			tgl.idfGeoLocation,
			h.idfMonitoringSession
		from #Human_MS h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfRegistrationAddress		
				
			left join #GeoLocation_MS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfMonitoringSession = h.idfMonitoringSession
		where gl.idfGeoLocation is null		
			
		insert into #GeoLocation_MS
		select distinct
			tgl.idfGeoLocation,
			h.idfMonitoringSession
		from #Human_MS h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfEmployerAddress		
				
			left join #GeoLocation_MS gl_filtered
			on gl_filtered.idfGeoLocation = tgl.idfGeoLocation
			and gl_filtered.idfMonitoringSession = h.idfMonitoringSession
		where gl_filtered.idfGeoLocation is null				
	end
	
	---------------------------------------------------------------------------------			
	--	Batch Test	

	--print '#BatchTest_MS - ms'
	
	if @FilterListedRecordsOnly = 0
	begin
		insert into #BatchTest_MS
		select distinct
			bt.idfBatchTest,
			ms.idfMonitoringSession
		from #MonitoringSession ms
			inner join	tlbMaterial as m with (nolock)
			on	ms.idfMonitoringSession = m.idfMonitoringSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join	tlbBatchTest as bt with (nolock)
			on	t.idfBatchTest = bt.idfBatchTest
		
			left join #BatchTest_MS bt_filtered
			on	bt_filtered.idfBatchTest = bt.idfBatchTest
			and bt_filtered.idfMonitoringSession = ms.idfMonitoringSession
		where bt_filtered.idfBatchTest is null	
	end
	---------------------------------------------------------------------------------			
	--	Observation
	

	if @FilterListedRecordsOnly = 0
	begin
		--farm
		--print '#Observation_MS - farm'
		insert into #Observation_MS
		select distinct
			obs.idfObservation,
			f.idfMonitoringSession
		from #Farm_MS f
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = f.idfFarm
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tf.idfObservation
			
			left join #Observation_MS obs_filtered
			on obs_filtered.idfObservation = obs.idfObservation
			and obs_filtered.idfMonitoringSession = f.idfMonitoringSession
		where obs_filtered.idfObservation is null
		
		--species
		--print '#Observation_MS - species'
		insert into #Observation_MS
		select distinct
			obs.idfObservation,
			f.idfMonitoringSession
		from #Farm_MS f
			inner join tlbFarm tf with (nolock)
			on tf.idfFarm = f.idfFarm
			
			inner join	tlbHerd as herd with (nolock)
			on	tf.idfFarm = herd.idfFarm
			
			inner join	tlbSpecies as species with (nolock)
			on	herd.idfHerd = species.idfHerd		
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = species.idfObservation
			
			left join #Observation_MS obs_filtered
			on obs_filtered.idfObservation = obs.idfObservation
			and obs_filtered.idfMonitoringSession = f.idfMonitoringSession
		where obs_filtered.idfObservation is null
		
		--animal
		--print '#Observation_MS - animal'
		insert into #Observation_MS
		select distinct
			obs.idfObservation,
			f.idfMonitoringSession
		from #Farm_MS f
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
			
			left join #Observation_MS obs_filtered
			on obs_filtered.idfObservation = obs.idfObservation
			and obs_filtered.idfMonitoringSession = f.idfMonitoringSession
		where obs_filtered.idfObservation is null
		
		--batch
		--print '#Observation_MS - batch'
		insert into #Observation_MS
		select distinct
			obs.idfObservation,
			bt.idfMonitoringSession
		from #BatchTest_MS bt
			inner join tlbBatchTest tbt with (nolock)
			on tbt.idfBatchTest = bt.idfBatchTest
			
			inner join tlbObservation obs with (nolock)
			on tbt.idfObservation = obs.idfObservation
		
			left join #Observation_MS obs_filtered
			on obs_filtered.idfObservation = tbt.idfObservation
			and obs_filtered.idfMonitoringSession = bt.idfMonitoringSession
		where obs_filtered.idfObservation is null	
				
		-- test
		--print '#Observation_MS - test'
		insert into #Observation_MS
		select distinct
			obs.idfObservation,
			ms.idfMonitoringSession
		from #MonitoringSession ms
			inner join tlbMonitoringSession tms with (nolock)
			on tms.idfMonitoringSession = ms.idfMonitoringSession
			
			inner join	tlbMaterial as m with (nolock)
			on	ms.idfMonitoringSession = m.idfMonitoringSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial		
			
			inner join tlbObservation obs with (nolock)
			on t.idfObservation = obs.idfObservation
			
			left join #Observation_MS obs_filtered
			on obs_filtered.idfObservation = t.idfObservation
			and obs_filtered.idfMonitoringSession = ms.idfMonitoringSession
		where obs_filtered.idfObservation is null
	end
	---------------------------------------------------------------------------------			
	--	Notification

	if @FilterListedRecordsOnly = 0
	begin
		-- by ms
		insert into #Notification_MS 
		select distinct 
			nt.idfNotification,
			ms.idfMonitoringSession
		from	tstNotification AS nt with (nolock)
			inner join #MonitoringSession AS ms
			on nt.idfNotificationObject = ms.idfMonitoringSession
			
			left join #Notification_MS n_f
			on n_f.idfMonitoringSession = ms.idfMonitoringSession
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
			
		
		-- by campaign
		insert into #Notification_MS 
		select distinct 
			nt.idfNotification,
			ms.idfMonitoringSession
		from	tstNotification AS nt with (nolock)
			inner join tlbCampaign tc
			on tc.idfCampaign = nt.idfNotificationObject
			inner join tlbMonitoringSession tms with (nolock)
			on tms.idfCampaign = tc.idfCampaign
			inner join #MonitoringSession AS ms
			on  ms.idfMonitoringSession = tms.idfMonitoringSession
			
			left join #Notification_MS n_f
			on n_f.idfMonitoringSession = ms.idfMonitoringSession
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null		
				
		-- test
		insert into #Notification_MS 
		select distinct 
			nt.idfNotification,
			vss.idfMonitoringSession	
		from #MonitoringSession vss
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfMonitoringSession = m.idfMonitoringSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tstNotification nt
			on nt.idfNotificationObject = t.idfTesting		
			
			left join #Notification_MS n_f
			on n_f.idfMonitoringSession = vss.idfMonitoringSession
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
			
		-- + transfer out from #TransferOutFiltered_MS!!		
	end
	---------------------------------------------------------------------------------			
	--	DataAuditEvent
	--ms
	insert into #DataAuditEvent_MS
	select distinct
		tdae.idfDataAuditEvent,
		ms.idfMonitoringSession
	from tauDataAuditEvent tdae with (nolock)
		inner join #MonitoringSession ms
		on ms.idfMonitoringSession = tdae.idfMainObject
		
		left join #DataAuditEvent_MS dae_f
		on dae_f.idfMonitoringSession = ms.idfMonitoringSession
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null


	if @FilterListedRecordsOnly = 0
	begin
		-- human
		insert into #DataAuditEvent_MS
		select distinct
			tdae.idfDataAuditEvent,
			h.idfMonitoringSession 
		from tauDataAuditEvent tdae with (nolock)
			inner join #Human_MS h
			on h.idfHuman = tdae.idfMainObject		
			left join #DataAuditEvent_MS dae_f
			
			on dae_f.idfMonitoringSession = h.idfMonitoringSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null		
			
		-- farm
		insert into #DataAuditEvent_MS
		select distinct
			tdae.idfDataAuditEvent,
			f.idfMonitoringSession 
		from tauDataAuditEvent tdae with (nolock)
			inner join #Farm_MS f
			on f.idfFarm = tdae.idfMainObject	
			
			left join #DataAuditEvent_MS dae_f
			on dae_f.idfMonitoringSession = f.idfMonitoringSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null					
			
		-- batch test
		insert into #DataAuditEvent_MS
		select distinct
			tdae.idfDataAuditEvent,
			bt.idfMonitoringSession
		from tauDataAuditEvent tdae with (nolock)
			inner join #BatchTest_MS bt
			on bt.idfBatchTest = tdae.idfMainObject		
			
			left join #DataAuditEvent_MS dae_f
			on dae_f.idfMonitoringSession = bt.idfMonitoringSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null				
			
		-- test
		insert into #DataAuditEvent_MS 
		select distinct 
			tdae.idfDataAuditEvent,
			ms.idfMonitoringSession	
		from #MonitoringSession ms
			inner join	tlbMaterial as m with (nolock)
			on	ms.idfMonitoringSession = m.idfMonitoringSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = t.idfTesting
			
			left join #DataAuditEvent_MS dae_f
			on dae_f.idfMonitoringSession = ms.idfMonitoringSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null			
			
		-- sample
		insert into #DataAuditEvent_MS 
		select distinct 
			tdae.idfDataAuditEvent,
			ms.idfMonitoringSession	
		from #MonitoringSession ms
			inner join	tlbMaterial as m with (nolock)
			on	ms.idfMonitoringSession = m.idfMonitoringSession
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = m.idfMaterial
			
			left join #DataAuditEvent_MS dae_f
			on dae_f.idfMonitoringSession = ms.idfMonitoringSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null			
		
		-- + transfer out from #TransferOutFiltered_MS!!			
	end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	fill tfl tables 
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			
	-- ms
	if exists(select * from #MonitoringSessionFiltered)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #MonitoringSessionFiltered as msf
			on  msf.idfMonitoringSession = nID.idfKey1
		where  nID.strTableName = 'tflMonitoringSessionFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflMonitoringSessionFiltered_Pfms', 
				msf.idfMonitoringSession, 
				msf.idfSiteGroup
		from  #MonitoringSessionFiltered as msf
			left join dbo.tflMonitoringSessionFiltered as tmsf
			on  tmsf.idfMonitoringSession = msf.idfMonitoringSession
				and tmsf.idfSiteGroup = msf.idfSiteGroup
		where  tmsf.idfMonitoringSessionFiltered is null
		
		insert into dbo.tflMonitoringSessionFiltered
			(
				idfMonitoringSessionFiltered, 
				idfMonitoringSession, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				msf.idfMonitoringSession, 
				nID.idfKey2
		from #MonitoringSessionFiltered as msf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflMonitoringSessionFiltered_Pfms'
				and nID.idfKey1 = msf.idfMonitoringSession
				and nID.idfKey2 is not null
			left join dbo.tflMonitoringSessionFiltered as tmsf
			on   tmsf.idfMonitoringSessionFiltered = nID.NewID
		where  tmsf.idfMonitoringSessionFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #MonitoringSessionFiltered as msf
			on   msf.idfMonitoringSession = nID.idfKey1
		where  nID.strTableName = 'tflMonitoringSessionFiltered_Pfms'
	end
	---------------------------------------------------------------------------------			
	-- Farm
	if exists(select * from #Farm_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Farm_MS as ff
			on  ff.idfFarm = nID.idfKey1 
		where  nID.strTableName = 'tflFarmFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflFarmFiltered_Pfms', 
				f.idfFarm, 
				msf.idfSiteGroup
		from  #Farm_MS f
			inner join #MonitoringSessionFiltered as msf
			on f.idfMonitoringSession = msf.idfMonitoringSession
			left join dbo.tflFarmFiltered as tof
			on  tof.idfFarm = f.idfFarm
				and tof.idfSiteGroup = msf.idfSiteGroup
		where  tof.idfFarmFiltered is null
		
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
		from #Farm_MS as ff
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflFarmFiltered_Pfms'
				and nID.idfKey1 = ff.idfFarm
				and nID.idfKey2 is not null
			left join dbo.tflFarmFiltered as tff
			on   tff.idfFarmFiltered = nID.NewID
		where  tff.idfFarmFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Farm_MS as ff
			on  ff.idfFarm = nID.idfKey1 
		where  nID.strTableName = 'tflFarmFiltered_Pfms'	
		
	end
	---------------------------------------------------------------------------------			
	-- human
	if exists(select * from #Human_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_MS as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflHumanFiltered_Pfms', 
				h.idfHuman, 
				msf.idfSiteGroup
		from  #Human_MS h
			inner join #MonitoringSessionFiltered as msf
			on h.idfMonitoringSession = msf.idfMonitoringSession
			left join dbo.tflHumanFiltered as tmsf
			on  tmsf.idfHuman = h.idfHuman
				and tmsf.idfSiteGroup = msf.idfSiteGroup
		where  tmsf.idfHumanFiltered is null
		
		insert into dbo.tflHumanFiltered
			(
				idfHumanFiltered, 
				idfHuman, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				msf.idfHuman, 
				nID.idfKey2
		from #Human_MS as msf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflHumanFiltered_Pfms'
				and nID.idfKey1 = msf.idfHuman
				and nID.idfKey2 is not null
			left join dbo.tflHumanFiltered as thf
			on   thf.idfHumanFiltered = nID.NewID
		where  thf.idfHumanFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_MS as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfms'	
	end
	---------------------------------------------------------------------------------			
	-- geo location
	if exists(select * from #GeoLocation_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_MS as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflGeoLocationFiltered_Pfms', 
				glf.idfGeoLocation, 
				msf.idfSiteGroup
		from  #GeoLocation_MS as glf 
			inner join #MonitoringSessionFiltered as msf 
			on glf.idfMonitoringSession = msf.idfMonitoringSession
			left join dbo.tflGeoLocationFiltered as tglf
			on  tglf.idfGeoLocation = glf.idfGeoLocation
				and tglf.idfSiteGroup = msf.idfSiteGroup
		where  tglf.idfGeoLocation is null
		
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
		from #GeoLocation_MS as glf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflGeoLocationFiltered_Pfms'
				and nID.idfKey1 = glf.idfGeoLocation
				and nID.idfKey2 is not null
			left join dbo.tflGeoLocationFiltered as tglf
			on   tglf.idfGeoLocationFiltered = nID.NewID
		where  tglf.idfGeoLocationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_MS as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfms'	
	end
	---------------------------------------------------------------------------------			
	-- batch test
	if exists(select * from #BatchTest_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_MS as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflBatchTestFiltered_Pfms', 
				btf.idfBatchTest, 
				msf.idfSiteGroup
		from  #BatchTest_MS as btf
			inner join #MonitoringSessionFiltered as msf
			on btf.idfMonitoringSession = msf.idfMonitoringSession
			left join dbo.tflBatchTestFiltered as tbtf
			on  tbtf.idfBatchTest = btf.idfBatchTest
				and tbtf.idfSiteGroup = msf.idfSiteGroup
		where  tbtf.idfBatchTest is null
		
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
		from #BatchTest_MS as btf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflBatchTestFiltered_Pfms'
				and nID.idfKey1 = btf.idfBatchTest
				and nID.idfKey2 is not null
			left join dbo.tflBatchTestFiltered as tbtf
			on   tbtf.idfBatchTestFiltered = nID.NewID
		where  tbtf.idfBatchTestFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_MS as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfms'		
	end
	---------------------------------------------------------------------------------			
	-- observation
	if exists(select * from #Observation_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_MS as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflObservationFiltered_Pfms', 
				ofl.idfObservation, 
				msf.idfSiteGroup
		from   #Observation_MS as ofl 
			inner join #MonitoringSessionFiltered as msf
			on ofl.idfMonitoringSession = msf.idfMonitoringSession
			left join dbo.tflObservationFiltered as tofl
			on  tofl.idfObservation = ofl.idfObservation
				and tofl.idfSiteGroup = msf.idfSiteGroup
		where  tofl.idfObservation is null
		
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
		from #Observation_MS as ofl
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflObservationFiltered_Pfms'
				and nID.idfKey1 = ofl.idfObservation
				and nID.idfKey2 is not null
			left join dbo.tflObservationFiltered as tofl
			on   tofl.idfObservationFiltered = nID.NewID
		where  tofl.idfObservationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_MS as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfms'			
	end
	---------------------------------------------------------------------------------			
	-- notification
	if exists(select * from #Notification_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_MS as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflNotificationFiltered_Pfms', 
				nf.idfNotification, 
				msf.idfSiteGroup
		from   #Notification_MS as nf
			inner join #MonitoringSessionFiltered as msf
			on nf.idfMonitoringSession = msf.idfMonitoringSession
			left join dbo.tflNotificationFiltered as tnf
			on  tnf.idfNotification = nf.idfNotification
				and tnf.idfSiteGroup = msf.idfSiteGroup
		where  tnf.idfNotification is null
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflNotificationFiltered_Pfms', 
			tn.idfNotification, 
			tout.idfSiteGroup
		from #TransferOutFiltered_MS tout
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
		from #Notification_MS as nf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfms'
				and nID.idfKey1 = nf.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null

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
		from #TransferOutFiltered_MS tout
			inner join tstNotification tn
			on tn.idfNotificationObject = tout.idfTransferOut
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfms'
				and nID.idfKey1 = tn.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_MS as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfms'
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join tstNotification tn
			on  tn.idfNotification = nID.idfKey1 
			
			inner join #TransferOutFiltered_MS tout
			on tn.idfNotification = tout.idfTransferOut
		where  nID.strTableName = 'tflNotificationFiltered_Pfms'			
	end
	---------------------------------------------------------------------------------			
	-- TransferOut
	if exists(select * from #TransferOutFiltered_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_MS as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflTransferOutFiltered_Pfms', 
				toutf.idfTransferOut, 
				toutf.idfSiteGroup
		from  #TransferOutFiltered_MS as toutf
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
		from #TransferOutFiltered_MS as toutf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflTransferOutFiltered_Pfms'
				and nID.idfKey1 = toutf.idfTransferOut
				and nID.idfKey2 is not null
			left join dbo.tflTransferOutFiltered as tof
			on   tof.idfTransferOutFiltered = nID.NewID
		where  tof.idfTransferOutFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_MS as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfms'
	end			
	---------------------------------------------------------------------------------			
	-- data audit event
	if exists(select * from #DataAuditEvent_MS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_MS as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfms'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflDataAuditEventFiltered_Pfms', 
				dae.idfDataAuditEvent, 
				msf.idfSiteGroup
		from   #DataAuditEvent_MS as dae
			inner join #MonitoringSessionFiltered as msf
			on dae.idfMonitoringSession = msf.idfMonitoringSession
			left join dbo.tflDataAuditEventFiltered as tdae
			on  tdae.idfDataAuditEvent = dae.idfDataAuditEvent
				and tdae.idfSiteGroup = msf.idfSiteGroup
		where  tdae.idfDataAuditEvent is null
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflDataAuditEventFiltered_Pfms', 
			tn.idfDataAuditEvent, 
			tout.idfSiteGroup
		from #TransferOutFiltered_MS tout
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
		from #DataAuditEvent_MS as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfms'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null

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
		from #DataAuditEvent_MS as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfms'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_MS as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfms'
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join tauDataAuditEvent tn
			on  tn.idfDataAuditEvent = nID.idfKey1 
			
			inner join #TransferOutFiltered_MS tout
			on tn.idfDataAuditEvent = tout.idfTransferOut
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfms'					
	end
	
