
--##SUMMARY Recalculation of filtration Basic Syndromic Surveillance for replication .

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 05.06.2014

--##REMARKS Updated by: Romasheva S.
--##REMARKS Update date: 23.11.2015

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_BasicSyndromicSurveillance '20131231'
*/


create proc spFiltered_BasicSyndromicSurveillance (
	@StartDate datetime = null,
	@idfBasicSyndromicSurveillance bigint = null
	)
as
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
		
		
	if Object_ID('tempdb..#BasicSyndromicSurveillance') is null
	create table  #BasicSyndromicSurveillance (
		idfBasicSyndromicSurveillance bigint not null primary key
	)

	if Object_ID('tempdb..#BasicSyndromicSurveillanceFiltered') is null
	create table #BasicSyndromicSurveillanceFiltered (
		id int identity(1,1) ,
		idfBasicSyndromicSurveillanceFiltered bigint,
		idfBasicSyndromicSurveillance bigint not null,
		idfSiteGroup bigint not null,
		primary key (
			idfBasicSyndromicSurveillance asc,
			idfSiteGroup asc
		)
	)

	if Object_ID('tempdb..#Human_BSS') is null	
	create table #Human_BSS (
		idfHuman bigint not null ,
		idfBasicSyndromicSurveillance bigint not null,
		primary key (
			idfHuman asc,
			idfBasicSyndromicSurveillance asc
		)
	)
		
	if Object_ID('tempdb..#GeoLocation_BSS') is null
	create table #GeoLocation_BSS (
		idfGeoLocation bigint not null,
		idfBasicSyndromicSurveillance bigint not null,
		 primary key (
		 	idfGeoLocation asc,
			idfBasicSyndromicSurveillance asc
		 )
	)
		
	if Object_ID('tempdb..#Notification_BSS') is null		
	create table #Notification_BSS (
		idfNotification bigint not null,
		idfBasicSyndromicSurveillance bigint not null,
		primary key (
			idfNotification asc,
			idfBasicSyndromicSurveillance asc
		)
	)		
		
	if Object_ID('tempdb..#DataAuditEvent_BSS') is null		
	create table #DataAuditEvent_BSS  (
		idfDataAuditEvent bigint not null ,
		idfBasicSyndromicSurveillance bigint not null,
		primary key (
			idfDataAuditEvent asc,
			idfBasicSyndromicSurveillance asc
		)
	)			
	
	
	insert into #BasicSyndromicSurveillance
	select  distinct
		bss.idfBasicSyndromicSurveillance
	from tlbBasicSyndromicSurveillance bss
		left join #BasicSyndromicSurveillance bss_f
		on bss_f.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
	where
		bss_f.idfBasicSyndromicSurveillance is null and  
		(bss.idfBasicSyndromicSurveillance = @idfBasicSyndromicSurveillance or @idfBasicSyndromicSurveillance is null) and
		(bss.datModificationForArchiveDate >= @StartDate or @StartDate is null)	
	
	-- !!! for @idfBasicSyndromicSurveillance = -1, bss list passed into the procedure
	if @idfBasicSyndromicSurveillance = -1 set @idfBasicSyndromicSurveillance = null
	
	
	--site group by site
	insert into #BasicSyndromicSurveillanceFiltered
	(
		idfBasicSyndromicSurveillance,
		idfSiteGroup
	)
	select  distinct
		bss.idfBasicSyndromicSurveillance,
		tsg.idfSiteGroup
	from #BasicSyndromicSurveillance bss
		inner join tlbBasicSyndromicSurveillance tbss with (nolock)
		on	tbss.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = tbss.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null
			and tsg.intRowStatus = 0	
			
		left join #BasicSyndromicSurveillanceFiltered bss_f
		on bss_f.idfSiteGroup = tsg.idfSiteGroup
		and bss_f.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
	where bss_f.idfBasicSyndromicSurveillance is null
			
	---------------------------------------------------------------------------------
	-- Site group relations
	insert into #BasicSyndromicSurveillanceFiltered
	(
		idfBasicSyndromicSurveillance,
		idfSiteGroup
	)
	select distinct
		bssf.idfBasicSyndromicSurveillance,
		tsgr.idfReceiverSiteGroup
	from #BasicSyndromicSurveillanceFiltered bssf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on bssf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #BasicSyndromicSurveillanceFiltered bssf2
		on	bssf2.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance 
			and	bssf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where bssf2.idfBasicSyndromicSurveillance is null	
	---------------------------------------------------------------------------------					
	-- Border Areas Filtration
	-- updated!
	insert into #BasicSyndromicSurveillanceFiltered
	(
		idfBasicSyndromicSurveillance,
		idfSiteGroup
	)
	select distinct
		bssf.idfBasicSyndromicSurveillance,
		tsg_cent.idfSiteGroup
	from #BasicSyndromicSurveillanceFiltered bssf
		inner join tflSiteGroup tsg with (nolock)
		on tsg.idfSiteGroup = bssf.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteGroup tsg_cent with (nolock)
		on tsg_cent.idfsCentralSite = tstsg.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0		
		
		left join #BasicSyndromicSurveillanceFiltered bssf2
		on	bssf2.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance 
			and	bssf2.idfSiteGroup = tsg_cent.idfSiteGroup
	where bssf2.idfBasicSyndromicSurveillance is null
	
	
	
	-- ADD rows from tflBasicSyndromicSurveillanceFiltered
	insert into #BasicSyndromicSurveillanceFiltered
	(	idfBasicSyndromicSurveillance,	idfSiteGroup)
	select 
		bssf.idfBasicSyndromicSurveillance,
		bssf.idfSiteGroup
	from tflBasicSyndromicSurveillanceFiltered bssf
		inner join #BasicSyndromicSurveillance bss
		on bss.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance
		
		left join #BasicSyndromicSurveillanceFiltered tbssf
		on tbssf.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
		and tbssf.idfSiteGroup = bssf.idfSiteGroup
	where  tbssf.idfBasicSyndromicSurveillance is null	
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	Child objects
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------									
	---------------------------------------------------------------------------------			
	--	Human
	if @FilterListedRecordsOnly = 0
	begin
		insert into #Human_BSS
		select distinct
			tbss.idfHuman,
			bss.idfBasicSyndromicSurveillance
		from #BasicSyndromicSurveillance bss
			inner join tlbBasicSyndromicSurveillance tbss with (nolock)
			on tbss.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
			inner join tlbHuman th with (nolock)
			on th.idfHuman = tbss.idfHuman
			
			left join #Human_BSS h_f
			on h_f.idfHuman = tbss.idfHuman
			and h_f.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
		where h_f.idfHuman is null
	end
	
	---------------------------------------------------------------------------------			
	--	GeoLocation		

	if @FilterListedRecordsOnly = 0
	begin
		--geo location for human
		insert into #GeoLocation_BSS
		select distinct
			tgl.idfGeoLocation,
			h.idfBasicSyndromicSurveillance
		from #Human_BSS h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfCurrentResidenceAddress		
				
			left join #GeoLocation_BSS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfBasicSyndromicSurveillance = h.idfBasicSyndromicSurveillance
		where gl.idfGeoLocation is null	
			
		insert into #GeoLocation_BSS
		select distinct
			tgl.idfGeoLocation,
			h.idfBasicSyndromicSurveillance
		from #Human_BSS h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfRegistrationAddress		
				
			left join #GeoLocation_BSS gl
			on gl.idfGeoLocation = tgl.idfGeoLocation
			and gl.idfBasicSyndromicSurveillance = h.idfBasicSyndromicSurveillance
		where gl.idfGeoLocation is null		
			
		insert into #GeoLocation_BSS
		select distinct
			tgl.idfGeoLocation,
			h.idfBasicSyndromicSurveillance
		from #Human_BSS h
			inner join tlbHuman th with (nolock)
			on th.idfHuman = h.idfHuman
			
			inner join tlbGeoLocation tgl with (nolock)
			on tgl.idfGeoLocation = th.idfEmployerAddress		
				
			left join #GeoLocation_BSS gl_filtered
			on gl_filtered.idfGeoLocation = tgl.idfGeoLocation
			and gl_filtered.idfBasicSyndromicSurveillance = h.idfBasicSyndromicSurveillance
		where gl_filtered.idfGeoLocation is null			
	end
	---------------------------------------------------------------------------------			
	--	Notification

	if @FilterListedRecordsOnly = 0
	begin
		-- by bss
		insert into #Notification_BSS 
		select distinct 
			nt.idfNotification,
			bss.idfBasicSyndromicSurveillance
		from	tstNotification AS nt with (nolock)
			inner join #BasicSyndromicSurveillance AS bss
			on nt.idfNotificationObject = bss.idfBasicSyndromicSurveillance
			
			left join #Notification_BSS n_f
			on n_f.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
	end	
	---------------------------------------------------------------------------------			
	--	DataAuditEvent
	
	
	--bss
	insert into #DataAuditEvent_BSS
	select distinct
		tdae.idfDataAuditEvent,
		bss.idfBasicSyndromicSurveillance
	from tauDataAuditEvent tdae with (nolock)
		inner join #BasicSyndromicSurveillance bss
		on bss.idfBasicSyndromicSurveillance = tdae.idfMainObject
		
		left join #DataAuditEvent_BSS dae_f
		on dae_f.idfBasicSyndromicSurveillance = bss.idfBasicSyndromicSurveillance
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
		
	if @FilterListedRecordsOnly = 0
	begin
		-- human
		insert into #DataAuditEvent_BSS
		select distinct
			tdae.idfDataAuditEvent,
			h.idfBasicSyndromicSurveillance 
		from tauDataAuditEvent tdae with (nolock)
			inner join #Human_BSS h
			on h.idfHuman = tdae.idfMainObject
			
			left join #DataAuditEvent_BSS dae_f
			on dae_f.idfBasicSyndromicSurveillance = h.idfBasicSyndromicSurveillance
			and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
		where dae_f.idfDataAuditEvent is null
	end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	fill tfl tables 
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			
		
	-- BasicSyndromicSurveillance
	if exists(select * from #BasicSyndromicSurveillanceFiltered)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #BasicSyndromicSurveillanceFiltered as bssf
			on  bssf.idfBasicSyndromicSurveillance = nID.idfKey1
		where  nID.strTableName = 'tflBasicSyndromicSurveillanceFiltered_Pfbss'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflBasicSyndromicSurveillanceFiltered_Pfbss', 
				bssf.idfBasicSyndromicSurveillance, 
				bssf.idfSiteGroup
		from  #BasicSyndromicSurveillanceFiltered as bssf
			left join dbo.tflBasicSyndromicSurveillanceFiltered as tbssf
			on  tbssf.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance
				and tbssf.idfSiteGroup = bssf.idfSiteGroup
		where  tbssf.idfBasicSyndromicSurveillanceFiltered is null
		
		insert into dbo.tflBasicSyndromicSurveillanceFiltered
			(
				idfBasicSyndromicSurveillanceFiltered, 
				idfBasicSyndromicSurveillance, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				bssf.idfBasicSyndromicSurveillance, 
				nID.idfKey2
		from #BasicSyndromicSurveillanceFiltered as bssf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflBasicSyndromicSurveillanceFiltered_Pfbss'
				and nID.idfKey1 = bssf.idfBasicSyndromicSurveillance
				and nID.idfKey2 is not null
			left join dbo.tflBasicSyndromicSurveillanceFiltered as tbssf
			on   tbssf.idfBasicSyndromicSurveillanceFiltered = nID.NewID
		where  tbssf.idfBasicSyndromicSurveillanceFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #BasicSyndromicSurveillanceFiltered as bssf
			on   bssf.idfBasicSyndromicSurveillance = nID.idfKey1
		where  nID.strTableName = 'tflBasicSyndromicSurveillanceFiltered_Pfbss'
	end
	---------------------------------------------------------------------------------			
	-- human
	if exists(select * from #Human_BSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_BSS as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfbss'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflHumanFiltered_Pfbss', 
				h.idfHuman, 
				bssf.idfSiteGroup
		from  #Human_BSS h
			inner join #BasicSyndromicSurveillanceFiltered as bssf
			on h.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance
			left join dbo.tflHumanFiltered as tbssf
			on  tbssf.idfHuman = h.idfHuman
				and tbssf.idfSiteGroup = bssf.idfSiteGroup
		where  tbssf.idfHumanFiltered is null
		
		insert into dbo.tflHumanFiltered
			(
				idfHumanFiltered, 
				idfHuman, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				bssf.idfHuman, 
				nID.idfKey2
		from #Human_BSS as bssf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflHumanFiltered_Pfbss'
				and nID.idfKey1 = bssf.idfHuman
				and nID.idfKey2 is not null
			left join dbo.tflHumanFiltered as thf
			on   thf.idfHumanFiltered = nID.NewID
		where  thf.idfHumanFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Human_BSS as hf
			on  hf.idfHuman = nID.idfKey1 
		where  nID.strTableName = 'tflHumanFiltered_Pfbss'		
	end
	---------------------------------------------------------------------------------			
	-- geo location
	if exists(select * from #GeoLocation_BSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_BSS as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfbss'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflGeoLocationFiltered_Pfbss', 
				glf.idfGeoLocation, 
				bssf.idfSiteGroup
		from  #GeoLocation_BSS as glf
			inner join #BasicSyndromicSurveillanceFiltered as bssf
			on glf.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance
			left join dbo.tflGeoLocationFiltered as tglf
			on  tglf.idfGeoLocation = glf.idfGeoLocation
				and tglf.idfSiteGroup = bssf.idfSiteGroup
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
		from #GeoLocation_BSS as glf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflGeoLocationFiltered_Pfbss'
				and nID.idfKey1 = glf.idfGeoLocation
				and nID.idfKey2 is not null
			left join dbo.tflGeoLocationFiltered as tglf
			on   tglf.idfGeoLocationFiltered = nID.NewID
		where  tglf.idfGeoLocationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #GeoLocation_BSS as glf
			on  glf.idfGeoLocation = nID.idfKey1 
		where  nID.strTableName = 'tflGeoLocationFiltered_Pfbss'
	end
	---------------------------------------------------------------------------------			
	-- notification
	if exists(select * from #Notification_BSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_BSS as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfbss'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflNotificationFiltered_Pfbss', 
				nf.idfNotification, 
				bssf.idfSiteGroup
		from   #Notification_BSS as nf
			inner join #BasicSyndromicSurveillanceFiltered as bssf
			on nf.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance
			left join dbo.tflNotificationFiltered as tnf
			on  tnf.idfNotification = nf.idfNotification
				and tnf.idfSiteGroup = bssf.idfSiteGroup
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
		from #Notification_BSS as nf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfbss'
				and nID.idfKey1 = nf.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_BSS as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfbss'
	end
	---------------------------------------------------------------------------------			
	-- data audit event
	if exists(select * from #DataAuditEvent_BSS)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_BSS as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfbss'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflDataAuditEventFiltered_Pfbss', 
				dae.idfDataAuditEvent, 
				bssf.idfSiteGroup
		from   #DataAuditEvent_BSS as dae
			inner join #BasicSyndromicSurveillanceFiltered as bssf
			on dae.idfBasicSyndromicSurveillance = bssf.idfBasicSyndromicSurveillance
			left join dbo.tflDataAuditEventFiltered as tdae
			on  tdae.idfDataAuditEvent = dae.idfDataAuditEvent
				and tdae.idfSiteGroup = bssf.idfSiteGroup
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
		from #DataAuditEvent_BSS as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfbss'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_BSS as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfbss'
	end

		
	

												
