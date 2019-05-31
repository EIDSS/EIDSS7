
-- ============================================================================
-- Name: USP_VCTS_VECT_SAMPLES_SET
-- Description:	Inserts or updates vector "case" 
-- create vector surveillance session use case.
--                      
-- Author: Harold Pryor
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Harold Pryor     04/17/2018 Initial release.
-- @datFieldCollectionDate datetime NULL, populate with current date
--	@datFieldSentDate datetime NULL,populate with current date,  @datAccession
-- Harold Pryor     05/16/2018 Removed @datAccession 
-- Harold Pryor     05/21/2018 Modified @idfSampleType to @idfsSampleType 
-- Harold Pryor     06/21/2018 Modified to add @strFieldBarcode input parameter
-- Lamont Mitcell	01/23/19	Aliased Return Columns added Supress Statement
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VCTS_VECT_SAMPLES_SET]
(
    @LangID							NVARCHAR(50),
	@idfMaterial					BIGINT ,
	@strFieldBarcode                NVarchar(200) null,
	@idfsSampleType					BIGINT,
	@idfVectorSurveillanceSession	BIGINT,
	@idfVector						BIGINT,
	@idfSendToOffice				BIGINT = null,
	@idfFieldCollectedByOffice      BIGINT = null
)
AS

DECLARE @returnCode							INT = 0;
DECLARE	@returnMsg							NVARCHAR(MAX) = 'SUCCESS';

DECLARE @intRowStatus INT = 0,
		@datFieldCollectionDate datetime = GetDate(),
		@datFieldSentDate datetime  = GetDate(),
		@RecordAction NCHAR(1) = 'I',
		@idfsSite INT = 1	

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @SupressSelect table
			( 
				
				retrunCode		INT,
				returnMessage	VARCHAR(200),
				idfMaterial		BIGINT,
				strBarcode		NVARCHAR(200)
			)
    BEGIN TRY
		BEGIN TRANSACTION;
				BEGIN
					
					IF EXISTS( SELECT * FROM dbo.tlbMaterial WHERE idfMaterial = @idfMaterial)	
					BEGIN
					 SET @RecordAction = 'U'
					END
						INSERT INTO @SupressSelect
							EXEC			dbo.USSP_GBL_MATERIAL_SET 
											@LangID, 
											@idfMaterial , 
											@idfsSampleType,
											null, 
											null,  
											NULL, 
											null,  
											null, 
											null, 
											null, 
											@idfFieldCollectedByOffice,
											null,  
											@datFieldCollectionDate, 
											@datFieldSentDate, 
											@strFieldBarcode, 
											NULL, 
											NULL, 
											@idfVectorSurveillanceSession, 
											@idfVector, 
											NULL, 
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											@idfsSite, 
											@intRowStatus, 
											@idfSendToOffice, 
											0, 
											null, 
											NULL, 
											null, 
											null,
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											@RecordAction;


							END
DECLARE @idfMaterialOut  BIGINT
SELECT @idfMaterialOut = idfMaterial from @SupressSelect;
		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT;

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfMaterialOut 'idfMaterial'
	END TRY
	BEGIN CATCH
		IF @@Trancount = 1 
			ROLLBACK;
			Throw;

		SELECT @returnCode, @returnMsg;
	END CATCH
END
