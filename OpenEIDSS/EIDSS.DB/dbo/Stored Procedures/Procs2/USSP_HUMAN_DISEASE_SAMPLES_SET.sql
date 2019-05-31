--*************************************************************
-- Name 				: USSP_HUMAN_DISEASE_SAMPLES_SET
-- Description			: add update delete Human Disease Report Samples
--          
-- Author               : JWJ
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- JWJ				20180703		created 
-- HAP              20181112     Updated to only execute dbo.USP_GBL_NextNumber_GET 10057019 when user leaves strFieldBarCode blank.
-- HAP				20181206	 Removed updating Primary Key column for tlbMaterial update.
-- HAP              20181221     Changed @Samples parameter to NVARCHAR(MAX).
-- LJM				01/02/19	 Changed @idfHumanCase from Output parameter and Added to Select Statment.  Added Temp Table to Surpress output from internal Stored Procs
-- HAP              03/22/19     Added @idfHuman and @DiseaseID input parameters. Also updated to save idfHuman, idfRootMaterial, idfParentMaterial,strBarcode, idfsSite, DiseaseID, and datEnteringDate in tlbMaterial table 
--
-- Testing code:
-- exec USSP_HUMAN_DISEASE_SAMPLES_SET null
--*************************************************************
CREATE PROCEDURE [dbo].[USSP_HUMAN_DISEASE_SAMPLES_SET] 
    @idfHuman  BIGINT = NULL,
	@idfHumanCase BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@SamplesParameters		NVARCHAR(MAX) = NULL
AS
Begin
	SET NOCOUNT ON;
		Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
	DECLARE
	--	@idfHumanCase	bigint,
		@idfMaterial	bigint,
		@strBarcode	nvarchar(200),
		@strFieldBarcode	nvarchar(200),
		@idfsSampleType	bigint,
		@strSampleTypeName	nvarchar(2000),
		@datFieldCollectionDate	datetime2,
		@idfSendToOffice	bigint,
		@strSendToOffice	nvarchar(2000),
		@idfFieldCollectedByOffice	bigint,
		@strFieldCollectedByOffice	nvarchar(2000),
		@datFieldSentDate	datetime2,
		@strNote	nvarchar(500),
		@datAccession	datetime2,
		@idfsAccessionCondition	bigint,
		@strCondition	nvarchar(200),
		@idfsRegion	bigint,
		@strRegionName	nvarchar(300),
		@idfsRayon	bigint,
		@strRayonName	nvarchar(300),
		@blnAccessioned	int,
		@RecordAction	varchar(1),
		@idfsSampleKind	bigint,
		@SampleKindTypeName	nvarchar(2000),
		@idfsSampleStatus	bigint,
		@SampleStatusTypeName	nvarchar(2000),
		@idfFieldCollectedByPerson	bigint,
		@datSampleStatusDate	datetime2,
		@sampleGuid	uniqueidentifier,
		@intRowStatus	int,	
		@idfsSite       int = 1

	DECLARE @returnCode	INT = 0;
	DECLARE	@returnMsg	NVARCHAR(MAX) = 'SUCCESS';

	DECLARE  @SamplesTemp TABLE (				
					[idfHumanCase] [bigint],
					[idfMaterial] [bigint],
					[strBarcode] [nvarchar](200),
					[strFieldBarcode] [nvarchar](200),
					[idfsSampleType] [bigint],
					[strSampleTypeName] [nvarchar](2000),
					[datFieldCollectionDate] [datetime2],
					[idfSendToOffice] [bigint],
					[strSendToOffice] [nvarchar](2000),
					[idfFieldCollectedByOffice] [bigint],
					[strFieldCollectedByOffice] [nvarchar](2000),
					[datFieldSentDate] [datetime2],
					[strNote] [nvarchar](500),
					[datAccession] [datetime2],
					[idfsAccessionCondition] [bigint],
					[strCondition] [nvarchar](200),
					[idfsRegion] [bigint],
					[strRegionName] [nvarchar](300),
					[idfsRayon] [bigint],
					[strRayonName] [nvarchar](300),
					[blnAccessioned] [int],
					[RecordAction] [varchar](1),
					[idfsSampleKind] [bigint],
					[SampleKindTypeName] [nvarchar](2000),
					[idfsSampleStatus] [bigint],
					[SampleStatusTypeName] [nvarchar](2000),
					[idfFieldCollectedByPerson] [bigint],
					[datSampleStatusDate] [datetime2],
					[sampleGuid] [uniqueidentifier],
					[intRowStatus] [int]
			)


	INSERT INTO	@SamplesTemp 
	SELECT * FROM OPENJSON(@SamplesParameters) 
			WITH (
					[idfHumanCase] [bigint],
					[idfMaterial] [bigint],
					[strBarcode] [nvarchar](200),
					[strFieldBarcode] [nvarchar](200),
					[idfsSampleType] [bigint],
					[strSampleTypeName] [nvarchar](2000),
					[datFieldCollectionDate] [datetime2],
					[idfSendToOffice] [bigint],
					[strSendToOffice] [nvarchar](2000),
					[idfFieldCollectedByOffice] [bigint],
					[strFieldCollectedByOffice] [nvarchar](2000),
					[datFieldSentDate] [datetime2],
					[strNote] [nvarchar](500),
					[datAccession] [datetime2],
					[idfsAccessionCondition] [bigint],
					[strCondition] [nvarchar](200),
					[idfsRegion] [bigint],
					[strRegionName] [nvarchar](300),
					[idfsRayon] [bigint],
					[strRayonName] [nvarchar](300),
					[blnAccessioned] [int],
					[RecordAction] [varchar](1),
					[idfsSampleKind] [bigint],
					[SampleKindTypeName] [nvarchar](2000),
					[idfsSampleStatus] [bigint],
					[SampleStatusTypeName] [nvarchar](2000),
					[idfFieldCollectedByPerson] [bigint],
					[datSampleStatusDate] [datetime2],
					[sampleGuid] [uniqueidentifier],
					[intRowStatus] [int]
				);
	BEGIN TRY  
		WHILE EXISTS (SELECT * FROM @SamplesTemp)
			BEGIN
				SELECT TOP 1
					--@idfHumanCase	=idfHumanCase,
					@idfMaterial	=idfMaterial,
					@strBarcode	=strBarcode,
					@strFieldBarcode	=strFieldBarcode,
					@idfsSampleType	=idfsSampleType,
					--@strSampleTypeName	=strSampleTypeName
					@datFieldCollectionDate	=datFieldCollectionDate,
					@idfSendToOffice	=idfSendToOffice,
					--@strSendToOffice	=strSendToOffice,
					@idfFieldCollectedByOffice	=idfFieldCollectedByOffice,
					--@strFieldCollectedByOffice	=strFieldCollectedByOffice,
					@datFieldSentDate	=datFieldSentDate,
					@strNote	=strNote,
					@datAccession	=datAccession,
					@idfsAccessionCondition	=idfsAccessionCondition,
					@strCondition	=strCondition,					
					@idfsSampleKind	=idfsSampleKind,
					--@SampleKindTypeName	=SampleKindTypeName,
					@idfsSampleStatus	=idfsSampleStatus,
					--@SampleStatusTypeName	=SampleStatusTypeName,
					@idfFieldCollectedByPerson	=idfFieldCollectedByPerson,
					--@datSampleStatusDate	=datSampleStatusDate,
					@sampleGuid	=sampleGuid,
					@intRowStatus	=intRowStatus					
				FROM @SamplesTemp

        If @idfSendToOffice > 0 
		BEGIN
         set @idfsSite = (select idfsSite from [dbo].[tlbOffice] where idfoffice = @idfSendToOffice)

		 If @idfsSite is null 
		 BEGIN
			set @idfsSite = 1
		 END

		END		

		IF NOT EXISTS(SELECT TOP 1 rowGuid from tlbMaterial WHERE rowGuid = @sampleGuid)
		BEGIN
				INSERT INTO @SupressSelect
				EXEC				
						dbo.USP_GBL_NEXTKEYID_GET 'tlbMaterial', @idfMaterial OUTPUT;

				--Local/field sample ID.  Only system assign when user leaves blank.
				IF							@strFieldBarcode IS NULL 
				BEGIN
				    INSERT INTO @SupressSelect
					EXEC					dbo.USP_GBL_NextNumber_GET 10057019, @strFieldBarcode OUTPUT, NULL; 
				END 

				INSERT INTO					dbo.tlbMaterial
				(						
					idfHumanCase,
					idfMaterial,
					strBarcode,
					strFieldBarcode,
					idfsSampleType,
					idfParentMaterial,
					idfRootMaterial,
					idfHuman,
					datEnteringDate,
					idfsSite,
					DiseaseID,
					--strSampleTypeName,
					datFieldCollectionDate,
					idfSendToOffice,
					--strSendToOffice,
					idfFieldCollectedByOffice,
					--strFieldCollectedByOffice,
					datFieldSentDate,
					strNote,

					datAccession,
					idfsAccessionCondition,
					strCondition,					
					idfsSampleKind,
					--SampleKindTypeName,
					idfsSampleStatus,
					--SampleStatusTypeName,
					idfFieldCollectedByPerson,
					--datSampleStatusDate,
					rowGuid,
					intRowStatus
				)
				VALUES
				(					
					@idfHumanCase,
					@idfMaterial,
					null,
					@strFieldBarcode,
					@idfsSampleType,
					@idfMaterial,
					@idfMaterial,
					@idfHuman,
					GETDATE(),
					@idfsSite,
					@DiseaseID,
					--strSampleTypeName,
					@datFieldCollectionDate,
					@idfSendToOffice,
					--strSendToOffice,
					@idfFieldCollectedByOffice,
					--@strFieldCollectedByOffice,
					@datFieldSentDate,
					@strNote,
					@datAccession,
					@idfsAccessionCondition,
					@strCondition,
					@idfsSampleKind,
					--SampleKindTypeName,
					@idfsSampleStatus,
					--SampleStatusTypeName,
					@idfFieldCollectedByPerson,
					--datSampleStatusDate,
					@sampleGuid,
					@intRowStatus
				)

			END
		ELSE
			BEGIN
				UPDATE dbo.tlbMaterial
				SET 
					idfHumanCase=	@idfHumanCase,
					strBarcode=	@strBarcode,
					strFieldBarcode=	@strFieldBarcode,
					idfsSampleType=	@idfsSampleType,
					idfsSite = @idfsSite,
					DiseaseID = @DiseaseID,
					--strSampleTypeName=	@strSampleTypeName,
					datFieldCollectionDate=	@datFieldCollectionDate,
					idfSendToOffice=	@idfSendToOffice,
					--strSendToOffice=	@strSendToOffice,
					idfFieldCollectedByOffice=	@idfFieldCollectedByOffice,
					--strFieldCollectedByOffice=	@strFieldCollectedByOffice,
					datFieldSentDate=	@datFieldSentDate,
					strNote=	@strNote,
					datAccession=	@datAccession,
					idfsAccessionCondition=	@idfsAccessionCondition,
					strCondition=	@strCondition,
					idfsSampleKind=	@idfsSampleKind,
					--SampleKindTypeName=	@SampleKindTypeName,
					idfsSampleStatus=	@idfsSampleStatus,
					--SampleStatusTypeName=	@SampleStatusTypeName,
					idfFieldCollectedByPerson=	@idfFieldCollectedByPerson,
					--datSampleStatusDate=	@datSampleStatusDate,
					rowGuid=	@sampleGuid,
					intRowStatus=	@intRowStatus


				WHERE	rowGuid = @sampleGuid;
			END

					--UPDATE	@TestsTemp SET idfMaterial = @idfMaterial WHERE idfMaterial = @idfMaterialTempID;

				DELETE FROM	@SamplesTemp WHERE sampleGuid = @sampleGuid

			END		--end loop, WHILE EXISTS (SELECT * FROM @SamplesTemp)
			
		--SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfHumanCase 'idfHumanCase';

	END TRY
	BEGIN CATCH
		THROW;
		
	END CATCH
END
