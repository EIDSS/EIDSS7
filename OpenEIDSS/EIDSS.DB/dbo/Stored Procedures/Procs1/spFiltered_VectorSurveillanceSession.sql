
--##SUMMARY Recalculation of filtration Vector Surveillance Session for replication .

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 02.06.2014

--##REMARKS Updated: Romasheva S.
--##REMARKS Update date: 26.08.2015

--##REMARKS Updated by: Romasheva S.
--##REMARKS Update date: 23.11.2015

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_VectorSurveillanceSession '20131231'
*/


create proc spFiltered_VectorSurveillanceSession (
	@StartDate datetime = null,
	@idfVectorSurveillanceSession bigint = null
	)
as
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
		
	if Object_ID('tempdb..#VectorSurveillanceSession') is null
	create table #VectorSurveillanceSession (
		idfVectorSurveillanceSession bigint not null primary key
	)

	if Object_ID('tempdb..#VectorSurveillanceSessionFiltered') is null
	create table #VectorSurveillanceSessionFiltered (
		id int identity(1,1),
		idfVectorSurveillanceSessionFiltered bigint,
		idfVectorSurveillanceSession bigint not null,
		idfSiteGroup bigint not null,
		primary key (
			idfVectorSurveillanceSession asc,
			idfSiteGroup  asc
		)
	)
	
	if Object_ID('tempdb..#TransferOutFiltered_VSS') is null
	create table #TransferOutFiltered_VSS (
		idfTransferOut	bigint,
		idfSiteGroup bigint not null,
		primary key (
			idfTransferOut	asc,
			idfSiteGroup asc
		)
	)
	
	if Object_ID('tempdb..#Outbreak_VSS') is null
	create table #Outbreak_VSS (
		idfOutbreak bigint not null ,
		idfVectorSurveillanceSession bigint not null,
		primary key(
			idfOutbreak asc ,
			idfVectorSurveillanceSession asc
		)
	)	
	
	if Object_ID('tempdb..#GeoLocation_VSS') is null
	create table #GeoLocation_VSS (
		idfGeoLocation bigint not null,
		idfVectorSurveillanceSession bigint not null,
		 primary key (
		 	idfGeoLocation asc,
			idfVectorSurveillanceSession asc
		 )
	)	
	
	if Object_ID('tempdb..#BatchTest_VSS') is null
	create table  #BatchTest_VSS (
		idfBatchTest bigint not null,
		idfVectorSurveillanceSession bigint not null,
		primary key (
			idfBatchTest asc,
			idfVectorSurveillanceSession asc
		)
	)
	
	if Object_ID('tempdb..#Observation_VSS') is null
	create table #Observation_VSS (
		idfObservation bigint not null,
		idfVectorSurveillanceSession bigint not null,
		primary key (
			idfObservation asc,
			idfVectorSurveillanceSession asc
		)	
	)
		
		
	if Object_ID('tempdb..#Notification_VSS') is null		
	create table #Notification_VSS (
		idfNotification bigint not null,
		idfVectorSurveillanceSession bigint not null,
		primary key (
			idfNotification asc,
			idfVectorSurveillanceSession asc
		)
	)		
		
	if Object_ID('tempdb..#DataAuditEvent_VSS') is null		
	create table #DataAuditEvent_VSS  (
		idfDataAuditEvent bigint not null ,
		idfVectorSurveillanceSession bigint not null,
		primary key (
			idfDataAuditEvent asc,
			idfVectorSurveillanceSession asc
		)
	)			

	
	insert into #VectorSurveillanceSession
	select distinct
		vss.idfVectorSurveillanceSession
	from tlbVectorSurveillanceSession vss
		left join #VectorSurveillanceSession vss_f
		on vss_f.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
	where 
		vss_f.idfVectorSurveillanceSession is null and 
		(vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null) and
		(vss.datModificationForArchiveDate >= @StartDate or @StartDate is null)	
	
	-- !!! for @idfVectorSurveillanceSession = -1, session list passed into the procedure
	if @idfVectorSurveillanceSession = -1 set @idfVectorSurveillanceSession = null
		
	
	--site group by site
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join tlbVectorSurveillanceSession tvss with (nolock)
		on	tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = tvss.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null
			and tsg.intRowStatus = 0	
		
		left join #VectorSurveillanceSessionFiltered vssf
		on vssf.idfSiteGroup = tsg.idfSiteGroup
		and vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
	where vssf.idfVectorSurveillanceSession is null
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
	--=============================================================================		
	--	VectorSurveillanceSession data is always distributed across the sites, 
	--	where the connected Outbreak is send, if the VectorSurveillanceSession 
	--	is the primary session for this Outbreak	
	-- sessions
	declare @idfVectorSurveillanceSessionFromOtb bigint	
	declare cur cursor local forward_only 
	for
	select 
		tvss.idfVectorSurveillanceSession
	from #VectorSurveillanceSession vss
		inner join	tlbOutbreak AS otb with (nolock)
		on	vss.idfVectorSurveillanceSession = otb.idfPrimaryCaseOrSession	
		inner join tlbVectorSurveillanceSession tvss
		on tvss.idfOutbreak = otb.idfOutbreak
		and tvss.idfVectorSurveillanceSession <> otb.idfPrimaryCaseOrSession
		and tvss.idfVectorSurveillanceSession <> isnull(@idfVectorSurveillanceSession, 0)
	where (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	open cur
	fetch next from cur into @idfVectorSurveillanceSessionFromOtb
	while @@FETCH_STATUS = 0 begin
		exec spFiltered_VectorSurveillanceSession null, @idfVectorSurveillanceSessionFromOtb
		fetch next from cur into @idfVectorSurveillanceSessionFromOtb
	end	
	close cur
	deallocate cur
	
	--vet cases
	declare @idfVetCaseFromOtb bigint	
	declare cur cursor local forward_only 
	for
	select 
		tvc.idfVetCase
	from #VectorSurveillanceSession vss 
		inner join	tlbOutbreak AS otb with (nolock)
		on	vss.idfVectorSurveillanceSession = otb.idfPrimaryCaseOrSession	
		inner join tlbVetCase tvc
		on tvc.idfOutbreak = otb.idfOutbreak
		and tvc.idfVetCase <> otb.idfPrimaryCaseOrSession
	where (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	open cur
	fetch next from cur into @idfVetCaseFromOtb
	while @@FETCH_STATUS = 0 begin
		exec spFiltered_VetCase null, @idfVetCaseFromOtb
		fetch next from cur into @idfVetCaseFromOtb
	end	
	close cur
	deallocate cur	
	
	-- human cases
	declare @idfHumanCaseFromOtb bigint	
	declare cur cursor local forward_only 
	for
	select 
		tvc.idfHumanCase
	from #VectorSurveillanceSession vss 
		inner join	tlbOutbreak AS otb with (nolock)
		on	vss.idfVectorSurveillanceSession = otb.idfPrimaryCaseOrSession	
		inner join tlbHumanCase tvc
		on tvc.idfOutbreak = otb.idfOutbreak
		and tvc.idfHumanCase <> otb.idfPrimaryCaseOrSession
	where (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	open cur
	fetch next from cur into @idfHumanCaseFromOtb
	while @@FETCH_STATUS = 0 begin
		exec spFiltered_HumanCase null, @idfHumanCaseFromOtb
		fetch next from cur into @idfHumanCaseFromOtb
	end	
	close cur
	deallocate cur	
	
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tof.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join	tlbOutbreak AS otb with (nolock)
		on	vss.idfVectorSurveillanceSession = otb.idfPrimaryCaseOrSession		
		inner join tflOutbreakFiltered tof  with (nolock)
		on	tof.idfOutbreak = otb.idfOutbreak
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tof.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	-- end recalc case and sessions for outbreak
	--=============================================================================		
					
			
	--	Vector Surveillance Session data is sent to all sites of organizations, 
	--	which are specific for the session. Specific organizations list for the  session includes: 
	
	--	Organization, specified in the �Collected By Institution� field for any vector/pool
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join tlbVector tv with (nolock)
		on tv.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		inner join	tstSite AS s with (nolock)
		on	tv.idfCollectedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null		
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
	
	--	Organization, specified in the �Identified By Institution� field for any vector/pool
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join tlbVector tv with (nolock)
		on tv.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		inner join	tstSite AS s with (nolock)
		on	tv.idfIdentifiedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null		
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)		
	
	--	Organization, specified in the �Collected By Institution� field for any sample
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join	tlbMaterial AS m with (nolock)
		on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession		
		inner join	tstSite AS s with (nolock)
		on	m.idfFieldCollectedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0		
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null	
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
	
	--	Organization, specified in the �Sent To Organization� field for any sample. -- !!!new 26.08.2015
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join	tlbMaterial AS m with (nolock)
		on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession		
		inner join	tstSite AS s with (nolock)
		on	m.idfSendToOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0		
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null	
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
		
	
	
	--	Organization, specified in the �Tested By Institution� field for any laboratory test
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join	tlbMaterial AS m with (nolock)
		on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession	
		inner join tlbTesting tt
		on tt.idfMaterial = m.idfMaterial	
		inner join	tstSite AS s with (nolock)
		on	tt.idfTestedByOffice = s.idfOffice
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0		
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null		
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	
	--	Organization, specified in the �Tested By Institution� field for any field test
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join	tlbMaterial AS m with (nolock)
		on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession	
		inner join tlbPensideTest tpt
		on tpt.idfMaterial = m.idfMaterial	
		inner join	tstSite AS s with (nolock)
		on	tpt.idfTestedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0		
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null		
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
	
	--	Vector Surveillance Session data is sent to all sites of organizations where session-connected Samples were transferred out.
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join	tlbMaterial AS m with (nolock)
		on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession	
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
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null	
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)			
	

	-- Transfer OUT 
	-- site group by creation site for tranfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_VSS
		select  distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #VectorSurveillanceSession vc
			inner join	tlbMaterial AS m with (nolock)
			on	vc.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession	
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
			left join #TransferOutFiltered_VSS tof_filt
			on tof_filt.idfTransferOut = tout.idfTransferOut 
			and tof_filt.idfSiteGroup = tsg.idfSiteGroup
		where 	tof_filt.idfTransferOut is null
		
		
		-- site group by transfer to	
		insert into #TransferOutFiltered_VSS
		select distinct
			tout.idfTransferOut,
			tsg.idfSiteGroup
		from #VectorSurveillanceSession vss
			inner join	tlbMaterial AS m with (nolock)
			on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession	
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
			left join #TransferOutFiltered_VSS toutf
			on toutf.idfSiteGroup = tsg.idfSiteGroup
			and toutf.idfTransferOut = tout.idfTransferOut
		where toutf.idfTransferOut is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end
	--end transfer OUT
	
				
	--	Vector Surveillance Session data is always distributed across the sites 
	--	of the specific administrative Rayon. All sites, where the value of the 
	--	Rayon equals to one of the Specific Session Rayons, have to receive Vector 
	--	Surveillance Session data. Specific Session Rayons list for the  session includes: 
	
	--	Rayon of the site, where the session was created;
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg2.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join tlbVectorSurveillanceSession tvss with (nolock)
		on	tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		inner join	tstSite AS s with (nolock)
		on	tvss.idfsSite = s.idfsSite
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
			
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg2.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null		
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	
	--	Rayon of the session location, if corresponding field was filled in;
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg2.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join tlbVectorSurveillanceSession tvss with (nolock)
		on	tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
	
		inner join tlbGeoLocation tgl with (nolock)
		on tgl.idfGeoLocation = tvss.idfLocation
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
			
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg2.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null	
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
	
	
	--	Rayon of any vector location, if corresponding field was filled in;
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg2.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join tlbVectorSurveillanceSession tvss with (nolock)
		on	tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		inner join tlbVector tv
		on tv.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
	
		inner join tlbGeoLocation tgl with (nolock)
		on tgl.idfGeoLocation = tv.idfLocation
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
			
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg2.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null		
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
	
	--	Rayon of the location of any vector surveillance session summary record, if corresponding field was filled in.
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vss.idfVectorSurveillanceSession,
		tsg2.idfSiteGroup
	from #VectorSurveillanceSession vss
		inner join tlbVectorSurveillanceSession tvss with (nolock)
		on	tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		inner join tlbVectorSurveillanceSessionSummary tvsss
		on tvsss.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
	
		inner join tlbGeoLocation tgl with (nolock)
		on tgl.idfGeoLocation = tvsss.idfGeoLocation
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
			
		left join #VectorSurveillanceSessionFiltered vssf
		on	vssf.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession 
			and	vssf.idfSiteGroup = tsg2.idfSiteGroup	
	where vssf.idfVectorSurveillanceSession is null
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	
	---------------------------------------------------------------------------------
	-- Site group relations
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vssf.idfVectorSurveillanceSession,
		tsgr.idfReceiverSiteGroup
	from #VectorSurveillanceSessionFiltered vssf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on vssf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #VectorSurveillanceSessionFiltered vssf2
		on	vssf2.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession 
			and	vssf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where vssf2.idfVectorSurveillanceSession is null	
	and (vssf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	
	-- Site group relations for transfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_VSS
		(
			idfTransferOut,
			idfSiteGroup
		)
		select distinct
			vcf.idfTransferOut,
			tsgr.idfReceiverSiteGroup
		from #TransferOutFiltered_VSS vcf
			inner join tflSiteGroupRelation tsgr with (nolock)
			on vcf.idfSiteGroup = tsgr.idfSenderSiteGroup
			
			left join #TransferOutFiltered_VSS vcf2
			on	vcf2.idfTransferOut = vcf.idfTransferOut 
				and	vcf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
		where vcf2.idfTransferOut is null		
	end
	---------------------------------------------------------------------------------					
	-- Border Areas Filtration
	-- updated!
	insert into #VectorSurveillanceSessionFiltered
	(
		idfVectorSurveillanceSession,
		idfSiteGroup
	)
	select distinct
		vssf.idfVectorSurveillanceSession,
		tsg_cent.idfSiteGroup
	from #VectorSurveillanceSessionFiltered vssf
		inner join tflSiteGroup tsg with (nolock)
		on tsg.idfSiteGroup = vssf.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteGroup tsg_cent with (nolock)
		on tsg_cent.idfsCentralSite = tstsg.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0			
		
		left join #VectorSurveillanceSessionFiltered vssf2
		on	vssf2.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession 
			and	vssf2.idfSiteGroup = tsg_cent.idfSiteGroup
	where vssf2.idfVectorSurveillanceSession is null
	and (vssf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	
	-- + for transfer out
	if @FilterListedRecordsOnly = 0
	begin
		insert into #TransferOutFiltered_VSS
		(
			idfTransferOut,
			idfSiteGroup
		)
		select distinct
			vcf.idfTransferOut,
			tsg_cent.idfSiteGroup
		from #TransferOutFiltered_VSS vcf
			inner join tflSiteGroup tsg with (nolock)
			on tsg.idfSiteGroup = vcf.idfSiteGroup
			
			inner join tflSiteToSiteGroup tstsg with (nolock)
			on tstsg.idfSiteGroup = tsg.idfSiteGroup
			
			inner join tflSiteGroup tsg_cent with (nolock)
			on tsg_cent.idfsCentralSite = tstsg.idfsSite
			and tsg_cent.idfsRayon is null
			and tsg_cent.intRowStatus = 0	
			
			left join #TransferOutFiltered_VSS vcf2
			on	vcf2.idfTransferOut = vcf.idfTransferOut 
				and	vcf2.idfSiteGroup = tsg_cent.idfSiteGroup
		where vcf2.idfTransferOut is null	
	end
	---------------------------------------------------------------------------------					
	
	
	-- ADD rows from tflVectorSurveillanceSessionFiltered
	insert into #VectorSurveillanceSessionFiltered
	(	idfVectorSurveillanceSession,	idfSiteGroup)
	select 
		msf.idfVectorSurveillanceSession,
		msf.idfSiteGroup
	from tflVectorSurveillanceSessionFiltered msf
		inner join #VectorSurveillanceSession ms
		on ms.idfVectorSurveillanceSession = msf.idfVectorSurveillanceSession
		
		left join #VectorSurveillanceSessionFiltered tmsf
		on tmsf.idfVectorSurveillanceSession = ms.idfVectorSurveillanceSession
		and tmsf.idfSiteGroup = msf.idfSiteGroup
	where  tmsf.idfVectorSurveillanceSession is null	
	and (ms.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	Child objects
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------														
	--	Outbreak

	
	insert into #Outbreak_VSS
	select distinct
		otb.idfOutbreak,
		vss.idfVectorSurveillanceSession
	from #VectorSurveillanceSession vss
		inner join tlbVectorSurveillanceSession tvss with (nolock)
		on tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		inner join tlbOutbreak otb with (nolock)
		on otb.idfOutbreak = tvss.idfOutbreak	
		
		left join #Outbreak_VSS o_f
		on o_f.idfOutbreak = otb.idfOutbreak
		and o_f.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
	where o_f.idfOutbreak is null
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
	---------------------------------------------------------------------------------			
	--	GeoLocation		

	if @FilterListedRecordsOnly = 0
	begin
		--geo location for outbreak
		insert into #GeoLocation_VSS
		select distinct
			tgl.idfGeoLocation,
			otb.idfVectorSurveillanceSession
		from #Outbreak_VSS otb
			inner join tlbOutbreak totb with (nolock)
			on totb.idfOutbreak = otb.idfOutbreak
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = totb.idfGeoLocation	
			
			left join #GeoLocation_VSS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVectorSurveillanceSession = otb.idfVectorSurveillanceSession
		where gl.idfGeoLocation is null		
		and (otb.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		--geo location for vss
		insert into #GeoLocation_VSS
		select distinct
			tgl.idfGeoLocation,
			vss.idfVectorSurveillanceSession
		from #VectorSurveillanceSession vss
			inner join tlbVectorSurveillanceSession tvss with (nolock)
			on tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = tvss.idfLocation
			
			left join #GeoLocation_VSS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		where gl.idfGeoLocation is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		--geo location for vector
		insert into #GeoLocation_VSS
		select distinct
			tgl.idfGeoLocation,
			vss.idfVectorSurveillanceSession
		from #VectorSurveillanceSession vss
			inner join tlbVectorSurveillanceSession tvss with (nolock)
			on tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			
			inner join tlbVector tv with (nolock)
			on tv.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = tv.idfLocation	
			
			left join #GeoLocation_VSS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		where gl.idfGeoLocation is null		
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		--geo location for vss summary
		insert into #GeoLocation_VSS
		select distinct
			tgl.idfGeoLocation,
			vss.idfVectorSurveillanceSession
		from #VectorSurveillanceSession vss
			inner join tlbVectorSurveillanceSessionSummary tvsss
			on tvsss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = tvsss.idfGeoLocation	
			
			left join #GeoLocation_VSS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		where gl.idfGeoLocation is null		
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)				
	end
	
	---------------------------------------------------------------------------------			
	--	Batch Test	

	if @FilterListedRecordsOnly = 0
	begin
		insert into #BatchTest_VSS
		select distinct
			bt.idfBatchTest,
			vss.idfVectorSurveillanceSession
		from #VectorSurveillanceSession vss
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join	tlbBatchTest as bt with (nolock)
			on	t.idfBatchTest = bt.idfBatchTest
		
			left join #BatchTest_VSS bt_filtered
			on	bt_filtered.idfBatchTest = bt.idfBatchTest
			and bt_filtered.idfBatchTest = bt.idfBatchTest
		where bt_filtered.idfBatchTest is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end
	---------------------------------------------------------------------------------			
	--	Observation- 
	if @FilterListedRecordsOnly = 0
	begin
		-- pool
		insert into #Observation_VSS
		select distinct
			obs.idfObservation,
			vss.idfVectorSurveillanceSession
		from #VectorSurveillanceSession vss
			inner join tlbVector tv
			on tv.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			
			inner join tlbObservation obs with (nolock)
			on tv.idfObservation = obs.idfObservation
		
			left join #Observation_VSS obs_filtered
			on obs_filtered.idfObservation = tv.idfObservation
			and obs_filtered.idfObservation = obs.idfObservation
		where obs_filtered.idfObservation is null	
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
		
				
		--batch
		insert into #Observation_VSS
		select distinct
			obs.idfObservation,
			bt.idfVectorSurveillanceSession
		from #BatchTest_VSS bt
			inner join tlbBatchTest tbt with (nolock)
			on tbt.idfBatchTest = bt.idfBatchTest
			
			inner join tlbObservation obs with (nolock)
			on tbt.idfObservation = obs.idfObservation
		
			left join #Observation_VSS obs_filtered
			on obs_filtered.idfObservation = tbt.idfObservation
			and obs_filtered.idfObservation = obs.idfObservation
		where obs_filtered.idfObservation is null	
		and (bt.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
				
		-- test
		insert into #Observation_VSS
		select distinct
			obs.idfObservation,
			vss.idfVectorSurveillanceSession
		from #VectorSurveillanceSession vss
			inner join tlbVectorSurveillanceSession tvss with (nolock)
			on tvss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial		
			
			inner join tlbObservation obs with (nolock)
			on t.idfObservation = obs.idfObservation
			
			left join #Observation_VSS obs_filtered
			on obs_filtered.idfObservation = t.idfObservation
			and obs_filtered.idfObservation = obs.idfObservation
		where obs_filtered.idfObservation is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end
	---------------------------------------------------------------------------------			
	--	Notification

	if @FilterListedRecordsOnly = 0
	begin
		-- vss
		insert into #Notification_VSS 
		select distinct 
			nt.idfNotification,
			vss.idfVectorSurveillanceSession
		from	tstNotification AS nt with (nolock)
			inner join #VectorSurveillanceSession AS vss
			on nt.idfNotificationObject = vss.idfVectorSurveillanceSession			
			
			left join #Notification_VSS n_f
			on n_f.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		
		-- outbreak
		insert into #Notification_VSS 
		select distinct 
			nt.idfNotification,
			otb.idfVectorSurveillanceSession
		from	tstNotification AS nt with (nolock)
			inner join #Outbreak_VSS AS otb
			on nt.idfNotificationObject = otb.idfOutbreak		
			
			left join #Notification_VSS n_f
			on n_f.idfVectorSurveillanceSession = otb.idfVectorSurveillanceSession
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
		and (otb.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
			
		-- test
		insert into #Notification_VSS 
		select distinct 
			nt.idfNotification,
			vss.idfVectorSurveillanceSession	
		from #VectorSurveillanceSession vss
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tstNotification nt with (nolock)
			on nt.idfNotificationObject = t.idfTesting
			
			left join #Notification_VSS n_f
			on n_f.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end		
	-- + transfer out from #TransferOutFiltered_VSS!!
	
	
	---------------------------------------------------------------------------------			
	--	DataAuditEvent
	
	
	--vss
	insert into #DataAuditEvent_VSS
	select distinct
		tdae.idfDataAuditEvent,
		vss.idfVectorSurveillanceSession
	from tauDataAuditEvent tdae with (nolock)
		inner join #VectorSurveillanceSession vss
		on vss.idfVectorSurveillanceSession = tdae.idfMainObject
		
		left join #DataAuditEvent_VSS dae_f
		on dae_f.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
	and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	
	-- outbreak
	insert into #DataAuditEvent_VSS
	select distinct
		tdae.idfDataAuditEvent,
		otb.idfVectorSurveillanceSession
	from tauDataAuditEvent tdae with (nolock)
		inner join #Outbreak_VSS otb
		on otb.idfOutbreak = tdae.idfMainObject	
		left join #DataAuditEvent_VSS dae_f
		on dae_f.idfVectorSurveillanceSession = otb.idfVectorSurveillanceSession
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
	and (otb.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
	if @FilterListedRecordsOnly = 0
	begin	
		-- batch test
		insert into #DataAuditEvent_VSS
		select distinct
			tdae.idfDataAuditEvent,
			bt.idfVectorSurveillanceSession
		from tauDataAuditEvent tdae with (nolock)
			inner join #BatchTest_VSS bt
			on bt.idfBatchTest = tdae.idfMainObject	
			left join #DataAuditEvent_VSS dae_f
			on dae_f.idfVectorSurveillanceSession = bt.idfVectorSurveillanceSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null
		and (bt.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)		
			
		-- test
		insert into #DataAuditEvent_VSS 
		select distinct 
			tdae.idfDataAuditEvent,
			vss.idfVectorSurveillanceSession	
		from #VectorSurveillanceSession vss
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
			
			inner join	tlbTesting as t with (nolock)
			on	m.idfMaterial = t.idfMaterial
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = t.idfTesting
			
			left join #DataAuditEvent_VSS dae_f
			on dae_f.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
			
		-- sample
		insert into #DataAuditEvent_VSS 
		select distinct 
			tdae.idfDataAuditEvent,
			vss.idfVectorSurveillanceSession	
		from #VectorSurveillanceSession vss
			inner join	tlbMaterial as m with (nolock)
			on	vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
			
			inner join tauDataAuditEvent tdae  with (nolock)
			on tdae.idfMainObject = m.idfMaterial
			
			left join #DataAuditEvent_VSS dae_f
			on dae_f.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null
		and (vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end
	-- + transfer out from #TransferOutFiltered_VSS!!
				
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	fill tfl tables 
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			
	-- vss
	if exists(select * from #VectorSurveillanceSessionFiltered)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #VectorSurveillanceSessionFiltered as vssf
			on  vssf.idfVectorSurveillanceSession = nID.idfKey1
		where  nID.strTableName = 'tflVectorSurveillanceSessionFiltered_Pfvss'
		and (vssf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflVectorSurveillanceSessionFiltered_Pfvss', 
				vssf.idfVectorSurveillanceSession, 
				vssf.idfSiteGroup
		from  #VectorSurveillanceSessionFiltered as vssf
			left join dbo.tflVectorSurveillanceSessionFiltered as tvssf
			on  tvssf.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession
				and tvssf.idfSiteGroup = vssf.idfSiteGroup
		where  tvssf.idfVectorSurveillanceSessionFiltered is null
		and (vssf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		insert into dbo.tflVectorSurveillanceSessionFiltered
			(
				idfVectorSurveillanceSessionFiltered, 
				idfVectorSurveillanceSession, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				vssf.idfVectorSurveillanceSession, 
				nID.idfKey2
		from #VectorSurveillanceSessionFiltered as vssf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflVectorSurveillanceSessionFiltered_Pfvss'
				and nID.idfKey1 = vssf.idfVectorSurveillanceSession
				and nID.idfKey2 is not null
			left join dbo.tflVectorSurveillanceSessionFiltered as tvssf
			on   tvssf.idfVectorSurveillanceSessionFiltered = nID.NewID
		where  tvssf.idfVectorSurveillanceSessionFiltered is null
		and (vssf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #VectorSurveillanceSessionFiltered as vssf
			on   vssf.idfVectorSurveillanceSession = nID.idfKey1
		where  nID.strTableName = 'tflVectorSurveillanceSessionFiltered_Pfvss'
		and (vssf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end						
	---------------------------------------------------------------------------------			
	-- outbreak
	if exists(select * from #Outbreak_VSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Outbreak_VSS as otbf
			on  otbf.idfOutbreak = nID.idfKey1 
		where  nID.strTableName = 'tflOutbreakFiltered_Pfvss'
		and (otbf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflOutbreakFiltered_Pfvss', 
				otb.idfOutbreak, 
				vssf.idfSiteGroup
		from  #Outbreak_VSS otb
			inner join #VectorSurveillanceSessionFiltered as vssf
			on otb.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession
			left join dbo.tflOutbreakFiltered as tof
			on  tof.idfOutbreak = otb.idfOutbreak
				and tof.idfSiteGroup = vssf.idfSiteGroup
		where  tof.idfOutbreakFiltered is null
		and (otb.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
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
		from #Outbreak_VSS as otbf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflOutbreakFiltered_Pfvss'
				and nID.idfKey1 = otbf.idfOutbreak
				and nID.idfKey2 is not null
			left join dbo.tflOutbreakFiltered as totbf
			on   totbf.idfOutbreakFiltered = nID.NewID
		where  totbf.idfOutbreakFiltered is null
		and (otbf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Outbreak_VSS as otbf
			on  otbf.idfOutbreak = nID.idfKey1 
		where  nID.strTableName = 'tflOutbreakFiltered_Pfvss'
		and (otbf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end						
	---------------------------------------------------------------------------------			
	-- geo location
	if exists(select * from #GeoLocation_VSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_VSS as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfvss'
		and (glf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflGeoLocationFiltered_Pfvss', 
				glf.idfGeoLocation, 
				vssf.idfSiteGroup
		from  #GeoLocation_VSS as glf 
			inner join #VectorSurveillanceSessionFiltered as vssf
			on glf.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession
			left join dbo.tflGeoLocationFiltered as tglf
			on  tglf.idfGeoLocation = glf.idfGeoLocation
				and tglf.idfSiteGroup = vssf.idfSiteGroup
		where  tglf.idfGeoLocation is null
		and (glf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
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
		from #GeoLocation_VSS as glf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflGeoLocationFiltered_Pfvss'
				and nID.idfKey1 = glf.idfGeoLocation
				and nID.idfKey2 is not null
			left join dbo.tflGeoLocationFiltered as tglf
			on   tglf.idfGeoLocationFiltered = nID.NewID
		where  tglf.idfGeoLocationFiltered is null
		and (glf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_VSS as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfvss'	
		and (glf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
	end
	---------------------------------------------------------------------------------			
	-- batch test
	if exists(select * from #BatchTest_VSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_VSS as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfvss'
		and (btf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflBatchTestFiltered_Pfvss', 
				btf.idfBatchTest, 
				vssf.idfSiteGroup
		from  #BatchTest_VSS as btf
			inner join #VectorSurveillanceSessionFiltered as vssf
			on btf.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession
			left join dbo.tflBatchTestFiltered as tbtf
			on  tbtf.idfBatchTest = btf.idfBatchTest
				and tbtf.idfSiteGroup = vssf.idfSiteGroup
		where  tbtf.idfBatchTest is null
		and (btf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
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
		from #BatchTest_VSS as btf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflBatchTestFiltered_Pfvss'
				and nID.idfKey1 = btf.idfBatchTest
				and nID.idfKey2 is not null
			left join dbo.tflBatchTestFiltered as tbtf
			on   tbtf.idfBatchTestFiltered = nID.NewID
		where  tbtf.idfBatchTestFiltered is null
		and (btf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #BatchTest_VSS as btf
			on  btf.idfBatchTest = nID.idfKey1 
		where  nID.strTableName = 'tflBatchTestFiltered_Pfvss'	
		and (btf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)	
	end
	---------------------------------------------------------------------------------			
	-- observation
	if exists(select * from #Observation_VSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_VSS as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfvss'
		and (ofl.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflObservationFiltered_Pfvss', 
				ofl.idfObservation, 
				vssf.idfSiteGroup
		from   #Observation_VSS as ofl 
			inner join #VectorSurveillanceSessionFiltered as vssf
			on ofl.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession
			left join dbo.tflObservationFiltered as tofl
			on  tofl.idfObservation = ofl.idfObservation
				and tofl.idfSiteGroup = vssf.idfSiteGroup
		where  tofl.idfObservation is null
		and (ofl.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
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
		from #Observation_VSS as ofl
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflObservationFiltered_Pfvss'
				and nID.idfKey1 = ofl.idfObservation
				and nID.idfKey2 is not null
			left join dbo.tflObservationFiltered as tofl
			on   tofl.idfObservationFiltered = nID.NewID
		where  tofl.idfObservationFiltered is null
		and (ofl.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_VSS as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfvss'
		and (ofl.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)			
	end
	---------------------------------------------------------------------------------			
	-- notification
	if exists(select * from #Notification_VSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_VSS as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfvss'
		and (nf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflNotificationFiltered_Pfvss', 
				nf.idfNotification, 
				vssf.idfSiteGroup
		from   #Notification_VSS as nf
			inner join #VectorSurveillanceSessionFiltered as vssf
			on nf.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession
			left join dbo.tflNotificationFiltered as tnf
			on  tnf.idfNotification = nf.idfNotification
				and tnf.idfSiteGroup = vssf.idfSiteGroup
		where  tnf.idfNotification is null
		and (nf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflNotificationFiltered_Pfvss', 
			tn.idfNotification, 
			tout.idfSiteGroup
		from #TransferOutFiltered_VSS tout
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
		from #Notification_VSS as nf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfvss'
				and nID.idfKey1 = nf.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null
		and (nf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

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
		from #TransferOutFiltered_VSS tout
			inner join tstNotification tn
			on tn.idfNotificationObject = tout.idfTransferOut
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfvss'
				and nID.idfKey1 = tn.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_VSS as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfvss'
		and (nf.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join tstNotification tn
			on  tn.idfNotification = nID.idfKey1 
			
			inner join #TransferOutFiltered_VSS tout
			on tn.idfNotification = tout.idfTransferOut
		where  nID.strTableName = 'tflNotificationFiltered_Pfvss'				
	end
	
	---------------------------------------------------------------------------------			
	-- TransferOut
	if exists(select * from #TransferOutFiltered_VSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_VSS as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfvss'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflTransferOutFiltered_Pfvss', 
				toutf.idfTransferOut, 
				toutf.idfSiteGroup
		from  #TransferOutFiltered_VSS as toutf
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
		from #TransferOutFiltered_VSS as toutf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflTransferOutFiltered_Pfvss'
				and nID.idfKey1 = toutf.idfTransferOut
				and nID.idfKey2 is not null
			left join dbo.tflTransferOutFiltered as tof
			on   tof.idfTransferOutFiltered = nID.NewID
		where  tof.idfTransferOutFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #TransferOutFiltered_VSS as toutf
			on  toutf.idfTransferOut = nID.idfKey1
		where  nID.strTableName = 'tflTransferOutFiltered_Pfvss'
	end								
	---------------------------------------------------------------------------------			
	-- data audit event
	if exists(select * from #DataAuditEvent_VSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_VSS as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfvss'
		and (dae.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflDataAuditEventFiltered_Pfvss', 
				dae.idfDataAuditEvent, 
				vssf.idfSiteGroup
		from   #DataAuditEvent_VSS as dae
			inner join #VectorSurveillanceSessionFiltered as vssf
			on dae.idfVectorSurveillanceSession = vssf.idfVectorSurveillanceSession
			left join dbo.tflDataAuditEventFiltered as tdae
			on  tdae.idfDataAuditEvent = dae.idfDataAuditEvent
				and tdae.idfSiteGroup = vssf.idfSiteGroup
		where  tdae.idfDataAuditEvent is null
		and (dae.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select 
			'tflDataAuditEventFiltered_Pfvss', 
			tn.idfDataAuditEvent, 
			tout.idfSiteGroup
		from #TransferOutFiltered_VSS tout
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
		from #DataAuditEvent_VSS as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfvss'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null
		and (dae.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)

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
		from #TransferOutFiltered_VSS tout
			inner join tauDataAuditEvent tn
			on tn.idfMainObject = tout.idfTransferOut
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfvss'
				and nID.idfKey1 = tn.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_VSS as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfvss'
		and (dae.idfVectorSurveillanceSession = @idfVectorSurveillanceSession or @idfVectorSurveillanceSession is null)
		
		delete  nID
		from  dbo.tflNewID as nID
			inner join tauDataAuditEvent tn
			on  tn.idfDataAuditEvent = nID.idfKey1 
			
			inner join #TransferOutFiltered_VSS tout
			on tn.idfDataAuditEvent = tout.idfTransferOut
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfvss'
	end													
