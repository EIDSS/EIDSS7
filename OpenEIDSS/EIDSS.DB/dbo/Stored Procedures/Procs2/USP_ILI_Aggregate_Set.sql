


--*************************************************************
-- Name: [USP_ILI_Aggregate_Set]
-- Description: Insert/Update for ILI Aggregate
--          
-- Author: Arnold Kennedy
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_ILI_Aggregate_Set]
(    
	@LangID								NVARCHAR(50), 
	@idfAggregateDetail					BIGINT = NULL,
	@idfAggregateHeader					BIGINT = -1,
	@idfEnteredBy						BIGINT,
	@idfsSite							BIGINT,
	@intYear							INT,
	@intWeek							INT,
	@datStartDate						DATETIME,
	@datFinishDate						DATETIME,
	@idfHospital						BIGINT = NULL,
	@intAge0_4							BIGINT,
	@intAge5_14							BIGINT,
	@intAge15_29						INT,
	@intAge30_64						INT,
	@intAge65							INT,
	@inTotalILI							INT,
    @intTotalAdmissions   				INT,
    @intILISamples  					INT

)
AS

BEGIN    

	DECLARE	@returnCode	INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';
	DECLARE @strFormID NVARCHAR(200)

	DECLARE @SupressSelect table
	( 
		retrunCode int,
		returnMessage varchar(200)
	)
	BEGIN TRY
		-- Update the header if this is an edit
		IF EXISTS (SELECT * FROM dbo.tlbBasicSyndromicSurveillanceAggregateHeader WHERE idfAggregateHeader = @idfAggregateHeader)
			BEGIN
				UPDATE tlbBasicSyndromicSurveillanceAggregateHeader
				SET 
					datDateLastSaved = GETDATE(),
					intYear = @intYear,
					intWeek = @intWeek,
					datStartDate = @datStartDate,
					datFinishDate = @datFinishDate,
					datModificationForArchiveDate = GETDATE()  -- Not sure what the difference is between this and datDateLastSaved

				WHERE
					idfAggregateHeader=@idfAggregateHeader

			END
		ELSE
		BEGIN
			-- Get new PK for insert
			BEGIN
				INSERT INTO @SupressSelect
				EXEC	dbo.USP_GBL_NEXTKEYID_GET 'tlbBasicSyndromicSurveillanceAggregateHeader', @idfAggregateHeader OUTPUT; 
			END
		-- Get New Smartkey
		IF ISNULL(@strFormID,N'') = N'' OR LEFT(ISNULL(@strFormID,N''),4)='(new'
			BEGIN
				INSERT INTO @SupressSelect
				EXEC dbo.USP_GBL_NextNumber_GET 'Basic Syndromic Surveillance Aggregate Form', @strFormID OUTPUT, NULL
			END

			INSERT INTO	dbo.tlbBasicSyndromicSurveillanceAggregateHeader
			(

				idfAggregateHeader,
				strFormID,
				datDateEntered,
				datDateLastSaved,
				idfEnteredBy,
				idfsSite,
				intYear,
				intWeek,
				datStartDate,
				datFinishDate,
				datModificationForArchiveDate,
				strMaintenanceFlag,
				strReservedAttribute,
				SourceSystemNameID

			)
			VALUES
			(

				@idfAggregateHeader,
				@strFormID,
				GETDATE(),
				GETDATE(),
				@idfEnteredBy,
				@idfsSite,
				@intYear,
				@intWeek,
				@datStartDate,
				@datFinishDate,
				GETDATE(),
				'system',
				'V7 ILI Syndromic Surveillance Aggregate Form',
				10519001 -- EIDSS7

			)

		END

		-- Update details if this is an edit
		IF EXISTS (SELECT * FROM tlbBasicSyndromicSurveillanceAggregateDetail WHERE idfAggregateDetail = @idfAggregateDetail)
			BEGIN
				UPDATE		tlbBasicSyndromicSurveillanceAggregateDetail
				SET 
								idfHospital = @idfHospital,
								intAge0_4 = @intAge0_4,			
								intAge5_14 = @intAge5_14,
								intAge15_29 = @intAge15_29,
								intAge30_64 = @intAge30_64,
								intAge65 = @intAge65,
								inTotalILI = @inTotalILI,
								intTotalAdmissions = @intTotalAdmissions,
								intILISamples = @intILISamples
									

				WHERE
							idfAggregateDetail=@idfAggregateDetail

			END

			ELSE
			BEGIN
				-- Get new PK for insert
				Begin
					INSERT INTO @SupressSelect
					EXEC	dbo.USP_GBL_NEXTKEYID_GET 'tlbBasicSyndromicSurveillanceAggregateDetail', @idfAggregateDetail OUTPUT;
				END
	
				INSERT INTO	dbo.tlbBasicSyndromicSurveillanceAggregateDetail 
				(
					idfAggregateDetail,
					idfAggregateHeader,
					idfHospital,
					intAge0_4,			
					intAge5_14 ,
					intAge15_29 ,
					intAge30_64,
					intAge65 ,
					inTotalILI,
					intTotalAdmissions,
					intILISamples,
					rowguid,
					strMaintenanceFlag,
					strReservedAttribute,
					SourceSystemNameID

				)
				VALUES
				(
					@idfAggregateDetail,
					@idfAggregateHeader,
					@idfHospital,
					@intAge0_4,			
					@intAge5_14,
					@intAge15_29,
					@intAge30_64,
					@intAge65,
					@inTotalILI,
					@intTotalAdmissions,
					@intILISamples,
					NEWID(),
					'system',
					'V7 ILI Syndromic Surveillance Aggregate Form',
					10519001 -- EIDSS7

				)

			END


		IF @@TRANCOUNT > 0
		BEGIN
					COMMIT
		END					
	

	END TRY
	BEGIN CATCH 
		IF @@TRANCOUNT > 0
			ROLLBACK;

		Throw;

	END CATCH
	SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @strFormID 'strFormID', @idfAggregateHeader 'idfAggregateHeader', @idfAggregateDetail 'idfAggregateDetail'
END
