


--*************************************************************
-- Name 				: USP_GBL_ASCAMPAIGN_SET
-- Description			: Insert/Update Active Surveillance Campaign
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name        Date        Change Detail
--		m.jessee	20180426	revised to GBL usage
--		A.Kennedy/L.Mitchell 01-07-19 added Return Code, Message, CampaignID for API
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_ASCAMPAIGN_SET]
(
	@idfCampaign					BIGINT ,
	@idfsCampaignType				BIGINT,
	@idfsCampaignStatus				BIGINT,
	@datCampaignDateStart			DATETIME,
	@datCampaignDateEnd				DATETIME,
	@strCampaignID					NVARCHAR(50) ,
	@strCampaignName				NVARCHAR(200),
	@strCampaignAdministrator		NVARCHAR(200),
	@strComments					NVARCHAR(500),
	@strConclusion					NVARCHAR(max),
	@idfsDiagnosis					BIGINT,
	@CampaignCategoryID				BIGINT, -- Campaign Category Vet or Human
	@datModificationForArchiveDate	DATETIME = NULL
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
	SET XACT_ABORT ON
		BEGIN TRANSACTION

		Declare @SupressSelect table
		( retrunCode int,
		  returnMessage varchar(200)
		)

			IF NOT EXISTS (SELECT * FROM dbo.tlbCampaign WHERE idfCampaign = @idfCampaign AND intRowStatus = 0)
				BEGIN
					IF ISNULL(@idfCampaign,-1)<0
					BEGIN
					   insert into @SupressSelect
					  
						EXEC USP_GBL_NEXTKEYID_GET 'tlbCampaign', @idfCampaign OUTPUT
					END
					IF LEFT(ISNULL(@strCampaignID, '(new'),4) = '(new'
						BEGIN
						insert into @SupressSelect
							EXEC dbo.USP_GBL_NextNumber_GET 'Active Surveillance Campaign', @strCampaignID OUTPUT , NULL --N'AS Session'
						END

					INSERT INTO tlbCampaign
							   (
								idfCampaign,
							    idfsCampaignType,
							    idfsCampaignStatus,
							    datCampaignDateStart,
							    datCampaignDateEnd,
							    strCampaignID,
							    strCampaignName,
							    strCampaignAdministrator,
							    strComments,
							    strConclusion,
								idfsDiagnosis,
								CampaignCategoryID
							   )
						 VALUES
							   (
								@idfCampaign,
							    @idfsCampaignType,
							    @idfsCampaignStatus,
							    @datCampaignDateStart,
							    @datCampaignDateEnd,
							    @strCampaignID,
							    @strCampaignName,
							    @strCampaignAdministrator,
							    @strComments,
							    @strConclusion,
								@idfsDiagnosis,
								@CampaignCategoryID
							   )
				END
			ELSE 
				BEGIN
					UPDATE tlbCampaign
					   SET idfsCampaignType = @idfsCampaignType,
						   idfsCampaignStatus = @idfsCampaignStatus,
						   datCampaignDateStart = @datCampaignDateStart,
						   datCampaignDateEnd = @datCampaignDateEnd,
						   strCampaignID = @strCampaignID,
						   strCampaignName = @strCampaignName,
						   strCampaignAdministrator = @strCampaignAdministrator,
						   strComments = @strComments,
						   strConclusion = @strConclusion,
						   idfsDiagnosis = @idfsDiagnosis,
						   CampaignCategoryID = @CampaignCategoryID
					 WHERE 	idfCampaign=@idfCampaign
				END

		IF @@TRANCOUNT > 0 AND @returnCode =0
			COMMIT

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' ,@idfCampaign 'idfCampaign' ,@strCampaignID	 'strCampaignID'
	END TRY

	BEGIN CATCH

			-- Test XACT_STATE for 0, 1, or -1.

			-- Test whether the transaction is uncommittable.
			IF (XACT_STATE()) = -1
			BEGIN
				PRINT 'The transaction is in an uncommittable state.' +
					  ' Rolling back transaction.'
				ROLLBACK TRANSACTION;
			END;

			-- Test whether the transaction is active and valid.
			IF (XACT_STATE()) = 1
			BEGIN
				PRINT 'The transaction is committable.' + 
					  ' Committing transaction.'
				COMMIT TRANSACTION;   
			END;


			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg = 
			'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			+ ' ErrorState: ' + convert(varchar,ERROR_STATE())
			+ ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()
			----select @LogErrMsg

			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' ,@idfCampaign 'idfCampaign',@strCampaignID	 'strCampaignID'

	END CATCH

END


