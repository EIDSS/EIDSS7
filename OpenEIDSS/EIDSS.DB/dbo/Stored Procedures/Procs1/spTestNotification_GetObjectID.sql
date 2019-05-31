
--##SUMMARY This procedure is intened for use in notification service tests
--##SUMMARY It creates dummy objects for references by events and notifications

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 31.07.2014

--##RETURNS Doesn't use




CREATE PROCEDURE [spTestNotification_GetObjectID]
	@objectType varchar(50)
AS 
declare @id bigint 
exec spsysGetNewID @id out
declare @idfsSite bigint
set @idfsSite = dbo.fnSiteID()
if(@objectType='humancase')
begin
	declare @idfHuman bigint
	exec spsysGetNewID @idfHuman out
	insert into tlbHuman(idfHuman,idfsSite,strLastName,strReservedAttribute)values(@idfHuman,@idfsSite,'test','test')
	insert into tlbHumanCase(idfHumanCase, idfHuman,idfsSite,strReservedAttribute) values (@id, @idfHuman, @idfsSite,'test')
	select idfHumanCase from tlbHumanCase where idfHumanCase = @id
end
else if(@objectType='vetcase')
begin
	declare @idfFarm bigint
	exec spsysGetNewID @idfFarm out
	insert into tlbFarm(idfFarm,idfsSite,strReservedAttribute)values(@idfFarm,@idfsSite,'test')
	insert into tlbVetCase(idfVetCase, idfsSite, idfFarm,idfsCaseType,strReservedAttribute) values (@id, @idfsSite,@idfFarm,10012003,'test')
	select idfVetCase from tlbVetCase where idfVetCase = @id
end

else if(@objectType='outbreak')
begin
	insert into tlbOutbreak(idfOutbreak, idfsSite,strReservedAttribute) values (@id, @idfsSite,'test')
	select idfOutbreak from tlbOutbreak where idfOutbreak = @id
end
else if(@objectType='vssession')
begin
	insert into tlbVectorSurveillanceSession(idfVectorSurveillanceSession, idfsSite, strSessionID, idfsVectorSurveillanceStatus,datStartDate,strReservedAttribute) values (@id, @idfsSite,'test',10310001,getdate(),'test')
	select idfVectorSurveillanceSession from tlbVectorSurveillanceSession where idfVectorSurveillanceSession = @id
end
else if(@objectType='ascampaign')
begin
	insert into tlbCampaign(idfCampaign, idfsSite,strReservedAttribute) values (@id, @idfsSite,'test')
	select idfCampaign from tlbCampaign where idfCampaign = @id
end
else if(@objectType='assession')
begin
	insert into tlbMonitoringSession(idfMonitoringSession, idfsSite,strReservedAttribute) values (@id, @idfsSite,'test')
	select idfMonitoringSession from tlbMonitoringSession where idfMonitoringSession = @id
end
else if(@objectType='aggrcase')
begin
	insert into tlbAggrCase(idfAggrCase, idfsSite,idfsAggrCaseType,
	idfsAdministrativeUnit,
	idfSentByOffice,
	idfSentByPerson,
	idfEnteredByOffice,
	idfEnteredByPerson,
	strReservedAttribute	
	) 
	values (@id, @idfsSite,10102001, 
	(select top 1 idfsRegion from gisRegion),
	(select top 1 idfOffice from tlbOffice),
	(select top 1 idfPerson from tlbPerson),
	(select top 1 idfOffice from tlbOffice),
	(select top 1 idfPerson from tlbPerson),
	'test'
	)
	select idfAggrCase from tlbAggrCase where idfAggrCase = @id
end
else if(@objectType='transferout')
begin
	declare @strBarcode nvarchar(50)
	exec spGetNextNumber 10057026,@strBarcode out, null
	insert into tlbTransferOUT(idfTransferOut, idfsSite,idfsTransferStatus,strBarcode,strReservedAttribute) values (@id, @idfsSite, 10001001,@strBarcode,'test')
	select idfTransferOut from tlbTransferOUT where idfTransferOut = @id
end
else if(@objectType='test')
begin
	declare @idfMaterial bigint
	exec spsysGetNewID @idfMaterial out
	insert into tlbMaterial(idfMaterial, idfsSite,idfsSampleType,strReservedAttribute ) values (@idfMaterial, @idfsSite,10320001,'test')
	declare @idfObservation bigint
	exec spsysGetNewID @idfObservation out
	insert into tlbObservation(idfObservation,strReservedAttribute) values (@idfObservation,'test')

	insert into tlbTesting(idfTesting,idfMaterial,idfsTestStatus,idfObservation,idfsDiagnosis,strReservedAttribute) values (@id,@idfMaterial,10001001,@idfObservation,(select top 1 idfsDiagnosis from trtDiagnosis),'test' )
	select idfTesting from tlbTesting where idfTesting = @id
end
else if(@objectType='bss')
begin
	declare @strFormID nvarchar(50)
	exec spGetNextNumber 10057031,@strFormID out, null
	declare @idfHuman1 bigint
	exec spsysGetNewID @idfHuman1 out
	insert into tlbHuman(idfHuman,idfsSite,strLastName,strReservedAttribute)values(@idfHuman1,@idfsSite,'test','test')
	insert into tlbBasicSyndromicSurveillance(idfBasicSyndromicSurveillance, idfsSite,strFormID,idfHuman,
	datDateEntered,
	datDateLastSaved,
	idfEnteredBy,
	strReservedAttribute
	) values (@id, @idfsSite,@strFormID,@idfHuman1,
	getdate(),
	getdate(),
	(select top 1 idfPerson from tlbPerson),
	'test')
	select idfBasicSyndromicSurveillance from tlbBasicSyndromicSurveillance where idfBasicSyndromicSurveillance = @id
end
else if(@objectType='bssaggr')
begin
	declare @strFormID1 nvarchar(50)
	exec spGetNextNumber 10057032,@strFormID1 out, null
	insert into tlbBasicSyndromicSurveillanceAggregateHeader(idfAggregateHeader, idfsSite,strFormID,intYear,intWeek,
	datDateEntered,
	datDateLastSaved, 
	datStartDate,
	datFinishDate,
	idfEnteredBy, 
	strReservedAttribute
	) values (@id, @idfsSite,@strFormID1,2014,1,
	getdate(),
	getdate(),
	getdate(),
	getdate(),
	(select top 1 idfPerson from tlbPerson),
	'test')
	select idfAggregateHeader from tlbBasicSyndromicSurveillanceAggregateHeader where idfAggregateHeader = @id
end
else if(@objectType='settlement')
	Select Top 1 idfsSettlement from dbo.gisSettlement
--returns local layout with existing global layout
else if(@objectType='createlayout')
begin
		declare	@idflQuery					bigint
		select top 1 @idflQuery = q.idflQuery from tasQuery q inner join tasQuerySearchObject qso on q.idflQuery = qso.idflQuery where not qso.idfQuerySearchObject is null
		declare @idfPerson bigint
		select top 1 @idfPerson = idfPerson from tstUserTable order by idfUserID desc

		EXEC	[dbo].[spAsLayoutPost]
				 @strLanguage			= 'en'				
				,@idflLayout			= @id			
				,@strLayoutName			= 'some name'			
				,@strDefaultLayoutName	= 'default name'	
				,@idflQuery				= @idflQuery				
				,@idflLayoutFolder		= null		
				,@idfPerson				= @idfPerson	
				,@idflDescription		= 128760000000	
				,@strDescription		= null	
				,@blbPivotGridSettings		= 0x78DAB3B1AFC8CD51284B2D2ACECCCFB35532D433505248CD4BCE4FC9CC4BB7552A2D49D3B550B2B7B349CECF4BCB4C2F2D4A2C012AB3B3D147E503002DD1182F
				,@blnReadOnly			= 0	
				,@idfsDefaultGroupDate		= 10039001	
				,@blnShowColsTotals		= 1	
				,@blnShowRowsTotals		= 0	
				,@blnShowColGrandTotals	= 1	
				,@blnShowRowGrandTotals	= 0
				,@blnShowForSingleTotals	= 1
				,@blnApplyPivotGridFilter			= 0
				,@blnShareLayout		= 1	
				,@intPivotGridXmlVersion = 5
				,@blnCompactPivotGrid = 0
				,@blnFreezeRowHeaders = 0
				,@blnUseArchivedData = 0
				,@blnShowMissedValuesInPivotGrid = 0
		update tasLayout set strReservedAttribute='test' where idflLayout=@id
		declare @idfsLayout bigint 
		exec spAsLayoutPublish  @id
		select @idfsLayout = idfsGlobalLayout from tasLayout where idflLayout = @id
		update tasglLayout set strReservedAttribute='test' where idfsLayout=@idfsLayout
end
else if(@objectType='layout')
begin
		exec spTestNotification_GetObjectID 'createlayout'
		select top 1 idflLayout from tasLayout inner join tasglLayout on tasglLayout.idfsLayout = tasLayout.idfsGlobalLayout 
		where tasglLayout.strReservedAttribute='test'

end
--returns global layout with existing local one
else if(@objectType='layoutgl')
begin
		exec spTestNotification_GetObjectID 'createlayout'
		select top 1 idfsLayout from tasLayout inner join tasglLayout on tasglLayout.idfsLayout = tasLayout.idfsGlobalLayout 
		where tasglLayout.strReservedAttribute='test'
end
--emulate global layout that come with replication (local layout is absent)
else if(@objectType='layoutToPublish')
begin
		exec spTestNotification_GetObjectID 'createlayout'
		declare @idfsLayout1  bigint
		declare @idflLayout1  bigint
		select top 1 @idflLayout1= idflLayout, @idfsLayout1 = idfsLayout from tasLayout inner join tasglLayout on tasglLayout.idfsLayout = tasLayout.idfsGlobalLayout 
		where tasLayout.strReservedAttribute='test'
		delete from tasLayout where idflLayout = @idflLayout1
		select top 1 idfsLayout from tasglLayout where idfsLayout = @idfsLayout1
end
else if(@objectType='fftemplate')
begin
	SELECT TOP 1 idfsFormTemplate  FROM ffFormTemplate
end
else if(@objectType='query')
begin
		select top 1 q.idflQuery from tasQuery q inner join tasQuerySearchObject qso on q.idflQuery = qso.idflQuery where not qso.idfQuerySearchObject is null
end
else if(@objectType='querygl')
begin
	if not exists (select top 1 qgl.idfsQuery from tasglQuery qgl 
		inner join tasglQuerySearchObject qso on qgl.idfsQuery = qso.idfsQuery 
		inner join tasQuery q on q.idfsGlobalQuery = qgl.idfsQuery
		where not qso.idfQuerySearchObject is null)
	begin
		declare	@idflQuery1					bigint
		select top 1 @idflQuery1 = q.idflQuery from tasQuery q inner join tasQuerySearchObject qso on q.idflQuery = qso.idflQuery where not qso.idfQuerySearchObject is null
		exec spAsQueryPublish @idflQuery1, @id out
		update tasglQuery set strReservedAttribute='test' where idfsQuery=@id
	end
	select top 1 qgl.idfsQuery from tasglQuery qgl 
			inner join tasglQuerySearchObject qso on qgl.idfsQuery = qso.idfsQuery 
			inner join tasQuery q on q.idfsGlobalQuery = qgl.idfsQuery
			where not qso.idfQuerySearchObject is null
end
else if(@objectType='createfolder')
begin
		declare	@idflQuery2					bigint
		select top 1 @idflQuery2 = q.idflQuery from tasQuery q inner join tasQuerySearchObject qso on q.idflQuery = qso.idflQuery where not qso.idfQuerySearchObject is null
		exec spAsFolderPost 'en', @id, null,'test folder', 'test folder', @idflQuery2
		update tasLayoutFolder set strReservedAttribute='test' where idflLayoutFolder=@id
		declare	@idfsFolder					bigint
		exec spAsFolderPublish  @id, @idfsFolder out
		update tasglLayoutFolder set strReservedAttribute='test' where idfsLayoutFolder=@idfsFolder
end
else if(@objectType='folder')
begin
		exec spTestNotification_GetObjectID 'createfolder'
		select top 1 idflLayoutFolder from tasLayoutFolder inner join tasglLayoutFolder on tasglLayoutFolder.idfsLayoutFolder = tasLayoutFolder.idfsGlobalLayoutFolder 
		where tasglLayoutFolder.strReservedAttribute='test'
end
else if(@objectType='foldergl')
begin
		exec spTestNotification_GetObjectID 'createfolder'
		select top 1 idfsLayoutFolder from tasLayoutFolder inner join tasglLayoutFolder on tasglLayoutFolder.idfsLayoutFolder = tasLayoutFolder.idfsGlobalLayoutFolder 
		where tasglLayoutFolder.strReservedAttribute='test'
end
else if(@objectType='folderToPublish')
begin
		exec spTestNotification_GetObjectID 'createfolder'
		declare @idfsLayoutFolder1  bigint
		declare @idflLayoutFolder1  bigint
		select top 1 @idflLayoutFolder1= idflLayoutFolder, @idfsLayoutFolder1 = idfsLayoutFolder from tasLayoutFolder inner join tasglLayoutFolder on tasglLayoutFolder.idfsLayoutFolder = tasLayoutFolder.idfsGlobalLayoutFolder 
		where tasLayoutFolder.strReservedAttribute='test'
		delete from tasLayoutFolder where idflLayoutFolder = @idflLayoutFolder1
		select top 1 idfsLayoutFolder from tasglLayoutFolder where idfsLayoutFolder = @idfsLayoutFolder1
end

RETURN 0
/*
Example of procedure call:
declare @id bigint
exec spTestNotification_GetObjectID 'humancase'
exec spTestNotification_GetObjectID 'vetcase'
exec spTestNotification_GetObjectID 'outbreak'
exec spTestNotification_GetObjectID 'vssession'
exec spTestNotification_GetObjectID 'ascampaign'
exec spTestNotification_GetObjectID 'assession'
exec spTestNotification_GetObjectID 'aggrcase'
exec spTestNotification_GetObjectID 'transferout'
exec spTestNotification_GetObjectID 'test'
exec spTestNotification_GetObjectID 'bss'
exec spTestNotification_GetObjectID 'bssaggr'
exec spTestNotification_GetObjectID 'settlement'
exec spTestNotification_GetObjectID 'fftemplate'
exec spTestNotification_GetObjectID 'query'
exec spTestNotification_GetObjectID 'querygl'
exec spTestNotification_GetObjectID 'folder'
exec spTestNotification_GetObjectID 'foldergl'
exec spTestNotification_GetObjectID 'folderToPublish'
exec spTestNotification_GetObjectID 'layout'
exec spTestNotification_GetObjectID 'layoutgl'
exec spTestNotification_GetObjectID 'layoutToPublish'

*/
