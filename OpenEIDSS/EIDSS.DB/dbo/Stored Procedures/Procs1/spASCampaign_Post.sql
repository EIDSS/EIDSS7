


CREATE         PROCEDURE dbo.spASCampaign_Post(
			@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
           ,@idfCampaign bigint OUTPUT
           ,@idfsCampaignType bigint
           ,@idfsCampaignStatus bigint
           ,@datCampaignDateStart datetime
           ,@datCampaignDateEnd datetime
           ,@strCampaignID nvarchar(50) OUTPUT
           ,@strCampaignName nvarchar(200)
           ,@strCampaignAdministrator nvarchar(200)
           ,@strComments nvarchar(500)
           ,@strConclusion nvarchar(max)
		   ,@datModificationForArchiveDate datetime = NULL

)
AS

IF @Action = 4
BEGIN
	IF ISNULL(@idfCampaign,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfCampaign OUTPUT
	END
	IF LEFT(ISNULL(@strCampaignID, '(new'),4) = '(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057027, @strCampaignID OUTPUT , NULL --N'AS Campaign'
	END
	INSERT INTO tlbCampaign
			   (idfCampaign
			   ,idfsCampaignType
			   ,idfsCampaignStatus
			   ,datCampaignDateStart
			   ,datCampaignDateEnd
			   ,strCampaignID
			   ,strCampaignName
			   ,strCampaignAdministrator
			   ,strComments
			   ,strConclusion
			   ,datModificationForArchiveDate
			   )
		 VALUES
			   (@idfCampaign
			   ,@idfsCampaignType
			   ,@idfsCampaignStatus
			   ,@datCampaignDateStart
			   ,@datCampaignDateEnd
			   ,@strCampaignID
			   ,@strCampaignName
			   ,@strCampaignAdministrator
			   ,@strComments
			   ,@strConclusion
			   ,getdate()
			   )
END
ELSE IF @Action=16
BEGIN
	UPDATE tlbCampaign
	   SET 
		  idfsCampaignType = @idfsCampaignType
		  ,idfsCampaignStatus = @idfsCampaignStatus
		  ,datCampaignDateStart = @datCampaignDateStart
		  ,datCampaignDateEnd = @datCampaignDateEnd
		  ,strCampaignID = @strCampaignID
		  ,strCampaignName = @strCampaignName
		  ,strCampaignAdministrator = @strCampaignAdministrator
		  ,strComments = @strComments
		  ,strConclusion = @strConclusion
		  ,@datModificationForArchiveDate = getdate()
	 WHERE 
		idfCampaign=@idfCampaign
END
ELSE IF @Action=8
BEGIN
	EXEC spAsCampaign_Delete @idfCampaign
END






