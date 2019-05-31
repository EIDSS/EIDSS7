
--##SUMMARY Recalculation of filtration Aggregate Cases/Actions for replication .

--##REMARKS Author: Romasheva S.
--##REMARKS Update date: 05.06.2014

--##REMARKS Updated by: Romasheva S.
--##REMARKS Update date: 23.11.2015

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spFiltered_AggrCase '20131231'
*/


create proc spFiltered_AggrCase (
	@StartDate datetime = null,
	@idfAggrCase bigint = null
	)
as
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
		
		
	if Object_ID('tempdb..#AggrCase') is null		
	create table #AggrCase (
		idfAggrCase bigint not null primary key
	)

	if Object_ID('tempdb..#AggrCaseFiltered') is null		
	create table #AggrCaseFiltered (
		id int identity(1,1) ,
		idfAggrCaseFiltered bigint,
		idfAggrCase bigint not null,
		idfSiteGroup bigint not null,
		primary key (
			idfAggrCase asc,
			idfSiteGroup asc
		)
	)
	
	if Object_ID('tempdb..#Observation_AC') is null
	create table #Observation_AC (
		idfObservation bigint not null,
		idfAggrCase bigint not null,
		primary key (
			idfObservation asc,
			idfAggrCase asc
		)	
	)		

	if Object_ID('tempdb..#Notification_AC') is null		
	create table #Notification_AC (
		idfNotification bigint not null,
		idfAggrCase bigint not null,
		primary key (
			idfNotification asc,
			idfAggrCase asc
		)
	)		
		
	if Object_ID('tempdb..#DataAuditEvent_AC') is null		
	create table #DataAuditEvent_AC  (
		idfDataAuditEvent bigint not null ,
		idfAggrCase bigint not null,
		primary key (
			idfDataAuditEvent asc,
			idfAggrCase asc
		)
	)				
	

	
	insert into #AggrCase
	select distinct
		hc.idfAggrCase
	from tlbAggrCase hc
		left join #AggrCase ac_f
		on ac_f.idfAggrCase = hc.idfAggrCase
	where
		ac_f.idfAggrCase is null and 
		(hc.idfAggrCase = @idfAggrCase or @idfAggrCase is null) and
		(hc.datModificationForArchiveDate >= @StartDate or @StartDate is null)	
	
	-- !!! for @idfAggrCase = -1, aggr case list passed into the procedure
	if @idfAggrCase = -1 set @idfAggrCase = null
	
	
	--	Aggregate Cases/Actions data is sent to all sites of organizations, which are specified 
	--	for the acegate case. Specific organizations list for the  acegate cases/actions includes: 
	
	--	Organization, specified in the �Notification sent by: Organization� field
	insert into #AggrCaseFiltered
	(
		idfAggrCase,
		idfSiteGroup
	)
	select distinct
		ac.idfAggrCase,
		tsg.idfSiteGroup
	from #AggrCase ac
		inner join tlbAggrCase tac with (nolock)
		on tac.idfAggrCase = ac.idfAggrCase
		inner join	tstSite AS s with (nolock)
		on	tac.idfSentByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #AggrCaseFiltered acf
		on	acf.idfAggrCase = ac.idfAggrCase 
			and	acf.idfSiteGroup = tsg.idfSiteGroup	
	where acf.idfAggrCase is null						
	
	--	Organization, specified in the �Notification received by: Organization� field
	insert into #AggrCaseFiltered
	(
		idfAggrCase,
		idfSiteGroup
	)
	select distinct
		ac.idfAggrCase,
		tsg.idfSiteGroup
	from #AggrCase ac
		inner join tlbAggrCase tac with (nolock)
		on tac.idfAggrCase = ac.idfAggrCase
		inner join	tstSite AS s with (nolock)
		on	tac.idfReceivedByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #AggrCaseFiltered acf
		on	acf.idfAggrCase = ac.idfAggrCase 
			and	acf.idfSiteGroup = tsg.idfSiteGroup	
	where acf.idfAggrCase is null						
	
	
	--	Organization, specified in the �Entered by: Organization� field
	insert into #AggrCaseFiltered
	(
		idfAggrCase,
		idfSiteGroup
	)
	select distinct
		ac.idfAggrCase,
		tsg.idfSiteGroup
	from #AggrCase ac
		inner join tlbAggrCase tac with (nolock)
		on tac.idfAggrCase = ac.idfAggrCase
		inner join	tstSite AS s with (nolock)
		on	tac.idfEnteredByOffice = s.idfOffice 
			and	s.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on	tstsg.idfsSite = s.idfsSite
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfSiteGroup = tstsg.idfSiteGroup
			and tsg.idfsRayon is null		
			and tsg.intRowStatus = 0	
		left join #AggrCaseFiltered acf
		on	acf.idfAggrCase = ac.idfAggrCase 
			and	acf.idfSiteGroup = tsg.idfSiteGroup	
	where acf.idfAggrCase is null		
	

	
	--	Aggregate Cases/Actions data is sent to all sites of the same rayon, as rayon, 
	--	specified in field �General Info: Rayon� or rayon of the settlement, specified 
	--	in field �General Info: Settlement� of the Aggregate Case.
	
	--�General Info: Rayon�	
	insert into #AggrCaseFiltered
	(
		idfAggrCase,
		idfSiteGroup
	)
	select distinct
		ac.idfAggrCase,
		tsg2.idfSiteGroup
	from #AggrCase ac
		inner join tlbAggrCase tac with (nolock)
		on	tac.idfAggrCase = ac.idfAggrCase

		inner join gisRayon gr with (nolock)
		on gr.idfsRayon = tac.idfsAdministrativeUnit
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfsRayon = gr.idfsRayon
			and tsg.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg2 with (nolock)
		on tstsg2.idfsSite = tstsg.idfsSite
		inner join tflSiteGroup tsg2 with (nolock)
		on	tsg2.idfSiteGroup = tstsg2.idfSiteGroup
			and tsg2.idfsRayon is null		
			and tsg2.intRowStatus = 0	
			
		left join #AggrCaseFiltered acf
		on	acf.idfAggrCase = ac.idfAggrCase 
			and	acf.idfSiteGroup = tsg2.idfSiteGroup	
	where acf.idfAggrCase is null				
		
	--rayon of the settlement, specified in field �General Info: Settlement�
	insert into #AggrCaseFiltered
	(
		idfAggrCase,
		idfSiteGroup
	)
	select distinct
		ac.idfAggrCase,
		tsg2.idfSiteGroup
	from #AggrCase ac
		inner join tlbAggrCase tac with (nolock)
		on	tac.idfAggrCase = ac.idfAggrCase
		inner join gisSettlement gs
		on gs.idfsSettlement = tac.idfsAdministrativeUnit
		
		inner join tflSiteGroup tsg with (nolock)
		on	tsg.idfsRayon = gs.idfsRayon
			and tsg.intRowStatus = 0
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg2 with (nolock)
		on tstsg2.idfsSite = tstsg.idfsSite
		inner join tflSiteGroup tsg2 with (nolock)
		on	tsg2.idfSiteGroup = tstsg2.idfSiteGroup
			and tsg2.idfsRayon is null		
			and tsg2.intRowStatus = 0	
			
		left join #AggrCaseFiltered acf
		on	acf.idfAggrCase = ac.idfAggrCase 
			and	acf.idfSiteGroup = tsg2.idfSiteGroup	
	where acf.idfAggrCase is null
	
	---------------------------------------------------------------------------------
	-- Site group relations
	insert into #AggrCaseFiltered
	(
		idfAggrCase,
		idfSiteGroup
	)
	select distinct
		acf.idfAggrCase,
		tsgr.idfReceiverSiteGroup
	from #AggrCaseFiltered acf
		inner join tflSiteGroupRelation tsgr with (nolock)
		on acf.idfSiteGroup = tsgr.idfSenderSiteGroup
		
		left join #AggrCaseFiltered acf2
		on	acf2.idfAggrCase = acf.idfAggrCase 
			and	acf2.idfSiteGroup = tsgr.idfReceiverSiteGroup	
	where acf2.idfAggrCase is null	

	---------------------------------------------------------------------------------
	
	-- Border Areas Filtration
	-- updated!
	insert into #AggrCaseFiltered
	(
		idfAggrCase,
		idfSiteGroup
	)
	select distinct
		acf.idfAggrCase,
		tsg_cent.idfSiteGroup
	from #AggrCaseFiltered acf
		inner join tflSiteGroup tsg with (nolock)
		on tsg.idfSiteGroup = acf.idfSiteGroup
		
		inner join tflSiteToSiteGroup tstsg with (nolock)
		on tstsg.idfSiteGroup = tsg.idfSiteGroup
		
		inner join tflSiteGroup tsg_cent with (nolock)
		on tsg_cent.idfsCentralSite = tstsg.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0		
		
		left join #AggrCaseFiltered acf2
		on	acf2.idfAggrCase = acf.idfAggrCase 
			and	acf2.idfSiteGroup = tsg_cent.idfSiteGroup
	where acf2.idfAggrCase is null	
	
	
	-- ADD rows from tflAggrCaseFiltered
	insert into #AggrCaseFiltered
	(	idfAggrCase,	idfSiteGroup)
	select 
		acf.idfAggrCase,
		acf.idfSiteGroup
	from tflAggrCaseFiltered acf
		inner join #AggrCase ac
		on ac.idfAggrCase = acf.idfAggrCase
		
		left join #AggrCaseFiltered tacf
		on tacf.idfAggrCase = ac.idfAggrCase
		and tacf.idfSiteGroup = acf.idfSiteGroup
	where  tacf.idfAggrCase is null		

	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	Child objects
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			

	--	Observation - 4x
	

	if @FilterListedRecordsOnly = 0
	begin
		insert into #Observation_AC
		select distinct
			tac.idfCaseObservation,
			ac.idfAggrCase
		from #AggrCase ac
			inner join tlbAggrCase tac with (nolock)
			on tac.idfAggrCase = ac.idfAggrCase
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tac.idfCaseObservation
			
			left join #Observation_AC obs_filtered
			on obs_filtered.idfObservation = tac.idfCaseObservation
			and obs_filtered.idfAggrCase = ac.idfAggrCase
		where obs_filtered.idfObservation is null
		
		insert into #Observation_AC
		select distinct
			tac.idfDiagnosticObservation,
			ac.idfAggrCase
		from #AggrCase ac
			inner join tlbAggrCase tac with (nolock)
			on tac.idfAggrCase = ac.idfAggrCase
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tac.idfDiagnosticObservation
			
			left join #Observation_AC obs_filtered
			on obs_filtered.idfObservation = tac.idfDiagnosticObservation
			and obs_filtered.idfAggrCase = ac.idfAggrCase
		where obs_filtered.idfObservation is null
		
		insert into #Observation_AC
		select distinct
			tac.idfProphylacticObservation,
			ac.idfAggrCase
		from #AggrCase ac
			inner join tlbAggrCase tac with (nolock)
			on tac.idfAggrCase = ac.idfAggrCase
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tac.idfProphylacticObservation
			
			left join #Observation_AC obs_filtered
			on obs_filtered.idfObservation = tac.idfProphylacticObservation
			and obs_filtered.idfAggrCase = ac.idfAggrCase
		where obs_filtered.idfObservation is null			

		insert into #Observation_AC
		select distinct
			tac.idfSanitaryObservation,
			ac.idfAggrCase
		from #AggrCase ac
			inner join tlbAggrCase tac with (nolock)
			on tac.idfAggrCase = ac.idfAggrCase
			
			inner join tlbObservation obs with (nolock)
			on obs.idfObservation = tac.idfSanitaryObservation
			
			left join #Observation_AC obs_filtered
			on obs_filtered.idfObservation = tac.idfSanitaryObservation
			and obs_filtered.idfAggrCase = ac.idfAggrCase
		where obs_filtered.idfObservation is null			
	end
	---------------------------------------------------------------------------------			
	--	Notification

	if @FilterListedRecordsOnly = 0
	begin
	-- by case
		insert into #Notification_AC 
		select distinct 
			nt.idfNotification,
			ac.idfAggrCase
		from	tstNotification AS nt with (nolock)
			inner join #AggrCase AS ac
			on nt.idfNotificationObject = ac.idfAggrCase		
			
			left join #Notification_AC n_f
			on n_f.idfAggrCase = ac.idfAggrCase
			and n_f.idfNotification = nt.idfNotification
		where n_f.idfNotification is null
	end	

	---------------------------------------------------------------------------------			
	--	DataAuditEvent
		
	
	--AggrCase
	insert into #DataAuditEvent_AC
	select distinct
		tdae.idfDataAuditEvent,
		ac.idfAggrCase
	from tauDataAuditEvent tdae with (nolock)
		inner join #AggrCase ac
		on ac.idfAggrCase = tdae.idfMainObject		
		
		left join #DataAuditEvent_AC dae_f
		on dae_f.idfAggrCase = ac.idfAggrCase
		and dae_f.idfDataAuditEvent = tdae.idfDataAuditEvent
	where dae_f.idfDataAuditEvent is null
		
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------		
	--	fill tfl tables 
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------			
		
	-- Aggr case
	if exists(select * from #AggrCaseFiltered)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #AggrCaseFiltered as acf
			on  acf.idfAggrCase = nID.idfKey1
		where  nID.strTableName = 'tflAggrCaseFiltered_Pfac'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  distinct
				'tflAggrCaseFiltered_Pfac', 
				acf.idfAggrCase, 
				acf.idfSiteGroup
		from  #AggrCaseFiltered as acf
			left join dbo.tflAggrCaseFiltered as tacf with (nolock)
			on  tacf.idfAggrCase = acf.idfAggrCase
				and tacf.idfSiteGroup = acf.idfSiteGroup
		where  tacf.idfAggrCaseFiltered is null
		
		insert into dbo.tflAggrCaseFiltered
			(
				idfAggrCaseFiltered, 
				idfAggrCase, 
				idfSiteGroup
			)
		select distinct
				nID.NewID, 
				acf.idfAggrCase, 
				nID.idfKey2
		from #AggrCaseFiltered as acf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflAggrCaseFiltered_Pfac'
				and nID.idfKey1 = acf.idfAggrCase
				and nID.idfKey2 is not null
			left join dbo.tflAggrCaseFiltered as tacf with (nolock)
			on   tacf.idfAggrCaseFiltered = nID.NewID
		where  tacf.idfAggrCaseFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #AggrCaseFiltered as acf
			on   acf.idfAggrCase = nID.idfKey1
		where  nID.strTableName = 'tflAggrCaseFiltered_Pfac'
	end
	---------------------------------------------------------------------------------			
	-- observation
	if exists(select * from #Observation_AC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_AC as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfac'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflObservationFiltered_Pfac', 
				ofl.idfObservation, 
				acf.idfSiteGroup
		from   #Observation_AC as ofl
			inner join #AggrCaseFiltered as acf
			on ofl.idfAggrCase = acf.idfAggrCase
			left join dbo.tflObservationFiltered as tofl with (nolock)
			on  tofl.idfObservation = ofl.idfObservation
				and tofl.idfSiteGroup = acf.idfSiteGroup
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
		from #Observation_AC as ofl
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflObservationFiltered_Pfac'
				and nID.idfKey1 = ofl.idfObservation
				and nID.idfKey2 is not null
			left join dbo.tflObservationFiltered as tofl with (nolock)
			on   tofl.idfObservationFiltered = nID.NewID
		where  tofl.idfObservationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Observation_AC as ofl
			on  ofl.idfObservation = nID.idfKey1 
		where  nID.strTableName = 'tflObservationFiltered_Pfac'		
	end
	---------------------------------------------------------------------------------			
	-- notification
	if exists(select * from #Notification_AC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_AC as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfac'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflNotificationFiltered_Pfac', 
				nf.idfNotification, 
				acf.idfSiteGroup
		from   #Notification_AC as nf
			inner join #AggrCaseFiltered as acf
			on nf.idfAggrCase = acf.idfAggrCase
			left join dbo.tflNotificationFiltered as tnf with (nolock)
			on  tnf.idfNotification = nf.idfNotification
				and tnf.idfSiteGroup = acf.idfSiteGroup
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
		from #Notification_AC as nf
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflNotificationFiltered_Pfac'
				and nID.idfKey1 = nf.idfNotification
				and nID.idfKey2 is not null
			left join dbo.tflNotificationFiltered as tnf with (nolock)
			on   tnf.idfNotificationFiltered = nID.NewID
		where  tnf.idfNotificationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #Notification_AC as nf
			on  nf.idfNotification = nID.idfKey1 
		where  nID.strTableName = 'tflNotificationFiltered_Pfac'
	end
	---------------------------------------------------------------------------------			
	-- data audit event
	if exists(select * from #DataAuditEvent_AC)
	begin
		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_AC as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_PfAggr'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select distinct
				'tflDataAuditEventFiltered_PfAggr', 
				dae.idfDataAuditEvent, 
				Aggrf.idfSiteGroup
		from   #DataAuditEvent_AC as dae
			inner join #AggrCaseFiltered as Aggrf
			on dae.idfAggrCase = Aggrf.idfAggrCase
			left join dbo.tflDataAuditEventFiltered as tdae with (nolock)
			on  tdae.idfDataAuditEvent = dae.idfDataAuditEvent
				and tdae.idfSiteGroup = Aggrf.idfSiteGroup
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
		from #DataAuditEvent_AC as dae
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflDataAuditEventFiltered_PfAggr'
				and nID.idfKey1 = dae.idfDataAuditEvent
				and nID.idfKey2 is not null
			left join dbo.tflDataAuditEventFiltered as tdae with (nolock)
			on   tdae.idfDataAuditEventFiltered = nID.NewID
		where  tdae.idfDataAuditEventFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join #DataAuditEvent_AC as dae
			on  dae.idfDataAuditEvent = nID.idfKey1 
		where  nID.strTableName = 'tflDataAuditEventFiltered_PfAggr'
	end
		
