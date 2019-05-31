
--##SUMMARY Recalculation of filtration Basic Syndromic Surveillance Aggregate Form for replication .

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 05.06.2014

--##REMARKS Updated by: Romasheva S.
--##REMARKS Update date: 23.11.2015

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_BasicSyndromicSurveillanceAggregateForm '20131231'
*/


create proc spFiltered_BasicSyndromicSurveillanceAggregateForm (
	@StartDate datetime = null,
	@idfAggregateHeader bigint = null
	)
as
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
		
	if Object_ID('tempdb..#BasicSyndromicSurveillanceAggregateHeader') is null
	create table #BasicSyndromicSurveillanceAggregateHeader (
		idfAggregateHeader bigint not null primary key
	)

	if Object_ID('tempdb..#BasicSyndromicSurveillanceAggregateHeaderFiltered') is null
	create table #BasicSyndromicSurveillanceAggregateHeaderFiltered (
		id int identity(1,1) ,
		idfBasicSyndromicSurveillanceAggregateHeaderFiltered bigint,
		idfAggregateHeader bigint not null,
		idfSiteGroup bigint not null,
		primary key (
			idfAggregateHeader asc,
			idfSiteGroup asc
		)
	)
	
	if Object_ID('tempdb..#Notification_BSSa') is null		
	create table #Notification_BSSa (
		idfNotification bigint not null,
		idfAggregateHeader bigint not null,
		primary key (
			idfNotification asc,
			idfAggregateHeader asc
		)
	)		
		
	if Object_ID('tempdb..#DataAuditEvent_BSSa') is null		
	create table #DataAuditEvent_BSSa  (
		idfDataAuditEvent bigint not null ,
		idfAggregateHeader bigint not null,
		primary key (
			idfDataAuditEvent asc,
			idfAggregateHeader asc
		)
	)		

	
	
	insert into #BasicSyndromicSurveillanceAggregateHeader
	select distinct
		bssag.idfAggregateHeader
	from tlbBasicSyndromicSurveillanceAggregateHeader bssag
		left join #BasicSyndromicSurveillanceAggregateHeader bssh_f
		on bssh_f.idfAggregateHeader = bssag.idfAggregateHeader
	where 
		bssh_f.idfAggregateHeader is null and
		(bssag.idfAggregateHeader = @idfAggregateHeader or @idfAggregateHeader is null) and
		(bssag.datModificationForArchiveDate >= @StartDate or @StartDate is null)	
	
	-- !!! for @idfAggregateHeader = -1,  list passed into the procedure
	if @idfAggregateHeader = -1 set @idfAggregateHeader = null
	
	
		
	--site group by site
	insert into #BasicSyndromicSurveillanceAggregateHeaderFiltered
	(
		idfAggregateHeader,
		idfSiteGroup
	)
	select distinct
		bssag.idfAggregateHeader,
		tsg.idfSiteGroup
	from #BasicSyndromicSurveillanceAggregateHeader bssag
		inner join tlbBasicSyndromicSurveillanceAggregateHeader tbssag with (nolock)
		on	tbssag.idfAggregateHeader = bssag.idfAggregateHeader
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = tbssag.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null
			and tsg.intRowStatus = 0	
			
		left join #BasicSyndromicSurveillanceAggregateHeaderFiltered bssah_f
		on bssah_f.idfSiteGroup = tsg.idfSiteGroup
		and bssah_f.idfAggregateHeader = bssag.idfAggregateHeader
	where bssah_f.idfAggregateHeader is null
			
			
	---------------------------------------------------------------------------------
	-- Site group relations
	insert into #BasicSyndromicSurveillanceAggregateHeaderFiltered
	(
		idfAggregateHeader,
		idfSiteGroup
	)
	select distinct
		bssagf.idfAggregateHeader,
		tsgr.idfReceiverSiteGroup
	from #BasicSyndromicSurveillanceAggregateHeaderFiltered bssagf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on bssagf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #BasicSyndromicSurveillanceAggregateHeaderFiltered bssagf2
		on	bssagf2.idfAggregateHeader = bssagf.idfAggregateHeader 
			and	bssagf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where bssagf2.idfAggregateHeader is null	
	---------------------------------------------------------------------------------					
	-- Border Areas Filtration
	-- updated!
	insert into #BasicSyndromicSurveillanceAggregateHeaderFiltered
	(
		idfAggregateHeader,
		idfSiteGroup
	)
	select distinct
		bssagf.idfAggregateHeader,
		tsg_cent.idfSiteGroup
	from #BasicSyndromicSurveillanceAggregateHeaderFiltered bssagf
		inner join tflSiteGroup tsg with (nolock)
		on tsg.idfSiteGroup = bssagf.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteGroup tsg_cent with (nolock)
		on tsg_cent.idfsCentralSite = tstsg.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0		
		
		left join #BasicSyndromicSurveillanceAggregateHeaderFiltered bssagf2
		on	bssagf2.idfAggregateHeader = bssagf.idfAggregateHeader 
			and	bssagf2.idfSiteGroup = tsg_cent.idfSiteGroup
	where bssagf2.idfAggregateHeader is null
	
	-- ADD rows from tflBasicSyndromicSurveillanceAggregateHeaderFiltered
	insert into #BasicSyndromicSurveillanceAggregateHeaderFiltered
	(	idfAggregateHeader,	idfSiteGroup)
	select 
		bsshf.idfAggregateHeader,
		bsshf.idfSiteGroup
	from tflBasicSyndromicSurveillanceAggregateHeaderFiltered bsshf
		inner join #BasicSyndromicSurveillanceAggregateHeader bssh
		on bssh.idfAggregateHeader = bsshf.idfAggregateHeader
		
		left join #BasicSyndromicSurveillanceAggregateHeaderFiltered tbsshf
		on tbsshf.idfAggregateHeader = bssh.idfAggregateHeader
		and tbsshf.idfSiteGroup = bsshf.idfSiteGroup
	where  tbsshf.idfAggregateHeader is null		
	
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	Child objects
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------									
	---------------------------------------------------------------------------------			

	--	Notification


	-- by bssag
	if @FilterListedRecordsOnly = 0
	begin
		insert into #Notification_BSSa 
		select distinct 
			nt.idfNotification,
			bssag.idfAggregateHeader
		from	tstNotification AS nt with (nolock)
			inner join #BasicSyndromicSurveillanceAggregateHeader AS bssag
			on nt.idfNotificationObject = bssag.idfAggregateHeader
			
			left join #Notification_BSSa n_f
			on n_f.idfAggregateHeader = bssag.idfAggregateHeader
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
	end	
	---------------------------------------------------------------------------------			
	--	DataAuditEvent
	
	
	--bssag
	insert into #DataAuditEvent_BSSa
	select distinct
		tdae.idfDataAuditEvent,
		bssag.idfAggregateHeader
	from tauDataAuditEvent tdae with (nolock)
		inner join #BasicSyndromicSurveillanceAggregateHeader bssag
		on bssag.idfAggregateHeader = tdae.idfMainObject
		
		left join #DataAuditEvent_BSSa dae_f
		on dae_f.idfAggregateHeader = bssag.idfAggregateHeader
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
		

	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	fill tfl tables 
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			
		
	-- BasicSyndromicSurveillance
	if exists(select * from #BasicSyndromicSurveillanceAggregateHeaderFiltered)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #BasicSyndromicSurveillanceAggregateHeaderFiltered as bssagf
			on  bssagf.idfAggregateHeader = nID.idfKey1
		where  nID.strTableName = 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered_Pfbssag'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflBasicSyndromicSurveillanceAggregateHeaderFiltered_Pfbssag', 
				bssagf.idfAggregateHeader, 
				bssagf.idfSiteGroup
		from  #BasicSyndromicSurveillanceAggregateHeaderFiltered as bssagf
			left join dbo.tflBasicSyndromicSurveillanceAggregateHeaderFiltered as tbssagf
			on  tbssagf.idfAggregateHeader = bssagf.idfAggregateHeader
				and tbssagf.idfSiteGroup = bssagf.idfSiteGroup
		where  tbssagf.idfBasicSyndromicSurveillanceAggregateHeaderFiltered is null
		
		insert into dbo.tflBasicSyndromicSurveillanceAggregateHeaderFiltered
			(
				idfBasicSyndromicSurveillanceAggregateHeaderFiltered, 
				idfAggregateHeader, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				bssagf.idfAggregateHeader, 
				nID.idfKey2
		from #BasicSyndromicSurveillanceAggregateHeaderFiltered as bssagf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered_Pfbssag'
				and nID.idfKey1 = bssagf.idfAggregateHeader
				and nID.idfKey2 is not null
			left join dbo.tflBasicSyndromicSurveillanceAggregateHeaderFiltered as tbssagf
			on   tbssagf.idfBasicSyndromicSurveillanceAggregateHeaderFiltered = nID.NewID
		where  tbssagf.idfBasicSyndromicSurveillanceAggregateHeaderFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #BasicSyndromicSurveillanceAggregateHeaderFiltered as bssagf
			on   bssagf.idfAggregateHeader = nID.idfKey1
		where  nID.strTableName = 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered_Pfbssag'
	end	

	---------------------------------------------------------------------------------			
	-- notification
	if exists(select * from #Notification_BSSa)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_BSSa as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfbssag'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflNotificationFiltered_Pfbssag', 
				nf.idfNotification, 
				bssagf.idfSiteGroup
		from   #Notification_BSSa as nf
			inner join #BasicSyndromicSurveillanceAggregateHeaderFiltered as bssagf
			on nf.idfAggregateHeader = bssagf.idfAggregateHeader
			left join dbo.tflNotificationFiltered as tnf
			on  tnf.idfNotification = nf.idfNotification
				and tnf.idfSiteGroup = bssagf.idfSiteGroup
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
		from #Notification_BSSa as nf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfbssag'
				and nID.idfKey1 = nf.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_BSSa as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfbssag'
	end
	---------------------------------------------------------------------------------			
	-- data audit event
	if exists(select * from #DataAuditEvent_BSSa)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_BSSa as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfbssag'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflDataAuditEventFiltered_Pfbssag', 
				dae.idfDataAuditEvent, 
				bssagf.idfSiteGroup
		from   #DataAuditEvent_BSSa as dae
			inner join #BasicSyndromicSurveillanceAggregateHeaderFiltered as bssagf
			on dae.idfAggregateHeader = bssagf.idfAggregateHeader
			left join dbo.tflDataAuditEventFiltered as tdae
			on  tdae.idfDataAuditEvent = dae.idfDataAuditEvent
				and tdae.idfSiteGroup = bssagf.idfSiteGroup
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
		from #DataAuditEvent_BSSa as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_Pfbssag'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_BSSa as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_Pfbssag'
	end
		
	

												
