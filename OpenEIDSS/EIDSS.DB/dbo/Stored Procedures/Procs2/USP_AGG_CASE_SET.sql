-- Batch submitted through debugger: SQLQuery34.sql|7|0|C:\Users\Arnold Kennedy\AppData\Local\Temp\~vs887C.sql

-- Batch submitted through debugger: SQLQuery7.sql|7|0|C:\Users\Arnold Kennedy\AppData\Local\Temp\~vs1785.sql

--*************************************************************
-- Name 				: USP_AGG_CASE_SET
-- Description			: Insert/Update Human Aggregate Case, Vet Aggregate Case and Vet Aggregate Action
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--		Name       Date       Change Detail
--	   Arnold Kennedy 05/02/18   Change idfVersion to output parm for NEXTKEYID_GET proc
--     Arnold Kennedy 05/03/18  insert matrix value  into tlbAggrMatrixVersionHeader table
--     Arnold Kennedy 05/08/18   add next key for tbleAggrMatrixVersionHeader
--     Arnold Kennedy 05/09/18   retrieve the idfsMatrixType(prepopulated) and idfversion before inserting in tlbAggrCase
--	   Arnold Kennedy 06/07/18   retrieve the  idfversion before update
--     Arnold Kennedy 01/07/19   Added Return Code and Return Message for API
--	   Arnold Kennedy/Mark Wilson  01/29/19   Changed SELECT @idfVersion = (	SELECT MAX(idfVersion)
--     Daryl Constable 03/27/2019 - Changed the following
--			from Human Aggregate Case to Human Aggregate Disease Report
--			from Vet Aggregate Case to Vet Aggregate Disease Report
--		Steven Verner 04/16/2019 - Removed additional BEGIN/END Statemens and properized code blocks.
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_AGG_CASE_SET]
	 @idfAggrCase								BIGINT			=NULL		--##PARAM @idfAggrCase - aggregate case ID
    ,@strCaseID									NVARCHAR(200)	= NULL
    ,@idfsAggrCaseType							BIGINT
    ,@idfsAdministrativeUnit					BIGINT						--Stores County, Region, Rayon and Settlement
    ,@idfReceivedByOffice						BIGINT
    ,@idfReceivedByPerson						BIGINT
    ,@idfSentByOffice							BIGINT
    ,@idfSentByPerson							BIGINT
    ,@idfEnteredByOffice						BIGINT
    ,@idfEnteredByPerson						BIGINT
    ,@idfCaseObservation						BIGINT = NULL
    ,@idfsCaseObservationFormTemplate			BIGINT = NULL
    ,@idfDiagnosticObservation					BIGINT = NULL
    ,@idfsDiagnosticObservationFormTemplate		BIGINT = NULL
    ,@idfProphylacticObservation				BIGINT = NULL
    ,@idfsProphylacticObservationFormTemplate	BIGINT = NULL
    ,@idfSanitaryObservation					BIGINT = NULL
    ,@idfVersion								BIGINT = null 
	,@idfDiagnosticVersion						BIGINT = NULL
	,@idfProphylacticVersion					BIGINT = NULL
	,@idfSanitaryVersion						BIGINT = NULL
    ,@idfsSanitaryObservationFormTemplate		BIGINT = NULL
    ,@datReceivedByDate							DATETIME
    ,@datSentByDate								DATETIME
    ,@datEnteredByDate							DATETIME
    ,@datStartDate								DATETIME
    ,@datFinishDate								DATETIME
	,@datModificationForArchiveDate				DATETIME = NULL

AS

DECLARE @returnCode	INT = 0 
DECLARE	@returnMsg	NVARCHAR(max) = 'SUCCESS' 
Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF EXISTS (SELECT * FROM tlbAggrCase WHERE idfAggrCase = @idfAggrCase)
				BEGIN
					IF NOT @idfCaseObservation IS NULL
							EXEC USP_AGG_OBSERVATION_SET @idfCaseObservation, @idfsCaseObservationFormTemplate

					IF NOT @idfDiagnosticObservation IS NULL
							EXEC USP_AGG_OBSERVATION_SET @idfDiagnosticObservation, @idfsDiagnosticObservationFormTemplate

					IF NOT @idfProphylacticObservation IS NULL
							EXEC USP_AGG_OBSERVATION_SET @idfProphylacticObservation, @idfsProphylacticObservationFormTemplate

					IF NOT @idfSanitaryObservation IS NULL
							EXEC USP_AGG_OBSERVATION_SET @idfSanitaryObservation, @idfsSanitaryObservationFormTemplate

					set @idfVersion = (	SELECT idfVersion 
											FROM tlbAggrCase 
											WHERE idfAggrCase = @idfAggrCase
										)

					UPDATE 
						tlbAggrCase
					SET 
						idfsAggrCaseType = @idfsAggrCaseType
						,idfsAdministrativeUnit = @idfsAdministrativeUnit
						,idfReceivedByOffice = @idfReceivedByOffice
						,idfReceivedByPerson = @idfReceivedByPerson
						,idfSentByOffice = @idfSentByOffice
						,idfSentByPerson = @idfSentByPerson
						,idfEnteredByOffice = @idfEnteredByOffice
						,idfEnteredByPerson = @idfEnteredByPerson
						,idfCaseObservation = @idfCaseObservation
						,idfDiagnosticObservation = @idfDiagnosticObservation
						,idfProphylacticObservation = @idfProphylacticObservation
						,idfSanitaryObservation = @idfSanitaryObservation
						,idfVersion = @idfVersion
						,idfDiagnosticVersion = @idfDiagnosticVersion
						,idfProphylacticVersion = @idfProphylacticVersion
						,idfSanitaryVersion = @idfSanitaryVersion
						,datReceivedByDate = @datReceivedByDate
						,datSentByDate = @datSentByDate
						,datEnteredByDate = @datEnteredByDate
						,datStartDate = @datStartDate
						,datFinishDate = @datFinishDate
						,strCaseID = @strCaseID
						,datModificationForArchiveDate = GETDATE()
					WHERE 
						idfAggrCase = @idfAggrCase
				END
			ELSE
				BEGIN

					--In previous implementation Primary Key was generated based on case type
					--In new implementation it is based on table tlbAggrCase
					--DECLARE @NextNumberType BIGINT
					--SET @NextNumberType =	CASE @idfsAggrCaseType 
					--						WHEN 10102001 /*AggregateCase*/ THEN 10057001
					--						WHEN 10102002 /*VetAggregateCase*/ THEN 10057003
					--						WHEN 10102003 /*VetAggregateAction*/ THEN 10057002
					--						END

					insert into @SupressSelect
						EXEC USP_GBL_NEXTKEYID_GET 'tlbAggrCase', @idfAggrCase OUTPUT

					IF ISNULL(@strCaseID,N'') = N'' OR LEFT(ISNULL(@strCaseID,N''),4)='(new'
						BEGIN
							DECLARE @ObjectName NVARCHAR(600)

							SET @ObjectName = CASE @idfsAggrCaseType 
											  WHEN 10102001 /*AggregateCase*/ THEN 'Human Aggregate Disease Report'		--tstNextNumbers.idfsNumberName = 10057001
											  WHEN 10102002 /*VetAggregateCase*/ THEN 'Vet Aggregate Disease Report'		--tstNextNumbers.idfsNumberName = 10057003
											  WHEN 10102003 /*VetAggregateAction*/ THEN 'Vet Aggregate Action'	--tstNextNumbers.idfsNumberName = 10057002
											  END
							insert into @SupressSelect
							EXEC dbo.USP_GBL_NextNumber_GET @ObjectName, @strCaseID OUTPUT, NULL

						END

					IF NOT @idfCaseObservation IS NULL
						EXEC USP_AGG_OBSERVATION_SET @idfCaseObservation, @idfsCaseObservationFormTemplate

					IF NOT @idfDiagnosticObservation IS NULL
						EXEC USP_AGG_OBSERVATION_SET @idfDiagnosticObservation, @idfsDiagnosticObservationFormTemplate

					IF NOT @idfProphylacticObservation IS NULL
						EXEC USP_AGG_OBSERVATION_SET @idfProphylacticObservation, @idfsProphylacticObservationFormTemplate

					IF NOT @idfSanitaryObservation IS NULL
						EXEC USP_AGG_OBSERVATION_SET @idfSanitaryObservation, @idfsSanitaryObservationFormTemplate

					INSERT INTO @SupressSelect
					EXEC USP_GBL_NEXTKEYID_GET 'tlbAggrMatrixVersionHeader', @idfVersion OUTPUT

					DECLARE @idfsMatrixType BIGINT
					SET @idfsMatrixType =	CASE @idfsAggrCaseType 
											WHEN 10102001 /*AggregateCase*/ THEN 71190000000		--tstNextNumbers.idfsNumberName = 10057001
											WHEN 10102002 /*VetAggregateCase*/ THEN 71090000000		--tstNextNumbers.idfsNumberName = 10057003
											END

					SELECT @idfVersion = (	SELECT Max( idfVersion )
											FROM dbo.tlbAggrMatrixVersionHeader 
											WHERE idfsMatrixType = @idfsMatrixType
										)

					INSERT INTO tlbAggrCase
					   (idfAggrCase
					   ,idfsAggrCaseType
					   ,idfsAdministrativeUnit
					   ,idfReceivedByOffice
					   ,idfReceivedByPerson
					   ,idfSentByOffice
					   ,idfSentByPerson
					   ,idfEnteredByOffice
					   ,idfEnteredByPerson
					   ,idfCaseObservation
					   ,idfDiagnosticObservation
					   ,idfProphylacticObservation
					   ,idfSanitaryObservation
					   ,idfVersion
					   ,idfDiagnosticVersion
					   ,idfProphylacticVersion
					   ,idfSanitaryVersion
					   ,datReceivedByDate
					   ,datSentByDate
					   ,datEnteredByDate
					   ,datStartDate
					   ,datFinishDate
					   ,strCaseID
					   ,datModificationForArchiveDate
						)
					VALUES
					   (
						@idfAggrCase
					   ,@idfsAggrCaseType
					   ,@idfsAdministrativeUnit
					   ,@idfReceivedByOffice
					   ,@idfReceivedByPerson
					   ,@idfSentByOffice
					   ,@idfSentByPerson
					   ,@idfEnteredByOffice
					   ,@idfEnteredByPerson
					   ,@idfCaseObservation
					   ,@idfDiagnosticObservation
					   ,@idfProphylacticObservation
					   ,@idfSanitaryObservation
					   ,@idfVersion
					   ,@idfDiagnosticVersion
					   ,@idfProphylacticVersion
					   ,@idfSanitaryVersion
					   ,@datReceivedByDate
					   ,@datSentByDate
					   ,@datEnteredByDate
					   ,@datStartDate
					   ,@datFinishDate
					   ,@strCaseID
					   ,GETDATE()
					)
  		
				END

		IF @@TRANCOUNT > 0
			COMMIT

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfAggrCase 'idfAggrCase',@idfVersion 'idfVersion' ,@strCaseID 'strCaseID'
	END TRY  

	BEGIN CATCH 
		IF @@TRANCOUNT > 0
			ROLLBACK;

		Throw;

	END CATCH
END
