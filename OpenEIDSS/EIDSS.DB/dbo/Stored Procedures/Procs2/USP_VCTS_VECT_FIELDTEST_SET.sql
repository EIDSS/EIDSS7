
-- ============================================================================
-- Name: USP_VCTS_VECT_FIELDTEST_SET
-- Description:	Inserts or updates vector "fieldtest" 
-- create vector surveillance session use case.
--                      
-- Author: Harold Pryor
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Harold Pryor     04/17/2018 Initial release.
-- Harold Pryor     05/17/2018 Changed GetUTCDate() to GetDate()  
-- Harold Pryor     05/22/2018 Updated to update @RecordAction
-- Harold Pryor     05/29/2018 Updated to pass @idfTestedByOffice, @idfTestedByPerson and @idfsTestResult values to dbo.USSP_GBL_TESTING_SET 
--LAMONT MITCHELL	01/23/19 ALIASED output and Supressed Select Statment, Removed Output parameter and moved to Select
-- ============================================================================

CREATE  Procedure [dbo].[USP_VCTS_VECT_FIELDTEST_SET]
(
	@strFieldBarCode    varchar(50),
	@LangID				varchar(50), 
	@idfTesting		    BIGINT,
	@idfsTestName		BIGINT,
	@idfsTestCategory   BIGINT,
	@idfTestedByOffice  BIGINT,
	@idfsTestResult     BIGINT,
	@idfTestedByPerson  BIGINT,
	@idfsDiagnosis      BIGINT
)
As
DECLARE @returnCode							INT = 0;
DECLARE	@returnMsg							NVARCHAR(MAX) = 'SUCCESS';

DECLARE @intRowStatus INT = 0,
		@datReceivedDate datetime = GetDate(),
		@datStartDate datetime = GetDate(),
		@RecordAction NCHAR(1) = 'I',
		@idfsSite INT = 1,	
		@idfsTestStatus INT = 10001005,	-- default set to Not Started 	
		@idfObservation INT = 0,
		@blnReadOnly    BIT = 0, 
		@blnNonLaboratory   BIT = 0,
		@idfmaterial INT,
		@idfTestingOut  BIGINT
		Select @idfmaterial = idfmaterial from tlbMaterial where strFieldBarCode = @strFieldBarCode

		IF EXISTS(SELECT idfTesting from dbo.tlbTesting where idfTesting = @idfTesting)
		BEGIN
			SET @RecordAction = 'U'
		END 

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
	Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200),
			  idftesting bigint
			)
		BEGIN TRANSACTION;
				BEGIN
				  INSERT INTO @SupressSelect
                   EXEC					dbo.USSP_GBL_TESTING_SET 
											@LangID, 
											@idfTesting, 
											@idfsTestName,
											@idfsTestCategory, 
											@idfsTestResult, 
											@idfsTestStatus, 
											@idfsDiagnosis, 
											@idfmaterial, 
											null, 
											@idfObservation, 
											null,
											null,
											@intRowStatus, 
											@datStartDate,  
											null,  
											@idfTestedByOffice, 
											@idfTestedByPerson,  
											null, 
											null, 
											null,   
											null, 
											@blnReadOnly, 
											@blnNonLaboratory, 
											null, 
											null, 											
											@datReceivedDate, 											
											null, 
											null, 
											@RecordAction;
				END
				SELECT @idfTestingOut =  idftesting FROM  @SupressSelect;
		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT;

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfTestingOut 'idfTesting';
	END TRY
	BEGIN CATCH
		IF @@Trancount = 1 
			ROLLBACK;
			Throw;
	END CATCH
END
