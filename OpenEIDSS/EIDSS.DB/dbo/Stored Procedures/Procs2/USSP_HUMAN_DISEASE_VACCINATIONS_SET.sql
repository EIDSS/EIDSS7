--*************************************************************
-- Name 				: USSP_HUMAN_DISEASE_VACCINATIONS_SET
-- Description			: add update delete Human Disease Report Vaccinations
--          
-- Author               : HAP
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- HAP				20190104     Created
-- HAP				20190109    Update delete of temp table
--
-- Testing code:
-- exec USSP_HUMAN_DISEASE_VACCINATIONS_SET null
--*************************************************************
CREATE PROCEDURE [dbo].[USSP_HUMAN_DISEASE_VACCINATIONS_SET] 
    @idfHumanCase BIGINT = NULL,
	@VaccinationsParameters		NVARCHAR(MAX) = NULL
AS
Begin
	SET NOCOUNT ON;
		Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
	DECLARE
@HumanDiseaseReportVaccinationUID	BIGINT, -- HumanDiseaseReportVaccination.HumanDiseaseReportVaccinationUID Primary Key
-- @idfHumanCase						BIGINT, -- HumanDiseaseReportVaccination.idfHumanCase
 @VaccinationName					nvarchar(200), -- HumanDiseaseReportVaccination.VaccinationName
 @VaccinationDate					DATETIME = NULL --HumanDiseaseReportVaccination.VaccinationDate 

	DECLARE @returnCode	INT = 0;
	DECLARE	@returnMsg	NVARCHAR(MAX) = 'SUCCESS';

	DECLARE  @VaccinationsTemp TABLE (				
					[HumanDiseaseReportVaccinationUID] [bigint] NULL,
					[idfHumanCase] [bigint] NULL,
					[VaccinationName] [nvarchar](200) NULL,
					[VaccinationDate] [datetime2] NULL					
			)


	INSERT INTO	@VaccinationsTemp 
	SELECT * FROM OPENJSON(@VaccinationsParameters) 
			WITH (
					[HumanDiseaseReportVaccinationUID] [bigint],
					[idfHumanCase] [bigint],
					[VaccinationName] [nvarchar](200),
					[VaccinationDate] [datetime2]
				)
	BEGIN TRY  
		WHILE EXISTS (SELECT * FROM @VaccinationsTemp)
			BEGIN
				SELECT TOP 1
					@HumanDiseaseReportVaccinationUID=HumanDiseaseReportVaccinationUID,
					--@idfHumanCase	=idfHumanCase ,
					@VaccinationName	=VaccinationName,
					@VaccinationDate  = @VaccinationDate
				FROM @VaccinationsTemp


		IF NOT EXISTS(SELECT TOP 1 HumanDiseaseReportVaccinationUID from HumanDiseaseReportVaccination WHERE HumanDiseaseReportVaccinationUID = @HumanDiseaseReportVaccinationUID)
		BEGIN
				INSERT INTO @SupressSelect
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'HumanDiseaseReportVaccination',  @HumanDiseaseReportVaccinationUID OUTPUT;
							

				INSERT 
					INTO	dbo.HumanDiseaseReportVaccination
							(
							 HumanDiseaseReportVaccinationUID,
							 idfHumanCase,		
							 VaccinationName,
							 VaccinationDate,				
							 intRowStatus,
							 AuditCreateUser,
							 AuditCreateDTM	
							)
					VALUES (
							 @HumanDiseaseReportVaccinationUID,
							 @idfHumanCase,		
							 @VaccinationName,
							 @VaccinationDate,
							 0,
							 'test',
							 Getdate()	
							)
			END
		ELSE
			BEGIN
				UPDATE dbo.HumanDiseaseReportVaccination
					SET			
							 idfHumanCase	  = @idfHumanCase,
							 VaccinationName  = @VaccinationName,
							 VaccinationDate  = @VaccinationDate,				
							 intRowStatus	  = 0,
							 AuditUpdateUser  = 'test',
							 AuditUpdateDTM	  =  Getdate()	

					WHERE	HumanDiseaseReportVaccinationUID = @HumanDiseaseReportVaccinationUID
					AND		intRowStatus = 0
			END

		--DELETE FROM	@VaccinationsTemp  WHERE HumanDiseaseReportVaccinationUID = @HumanDiseaseReportVaccinationUID
				SET ROWCOUNT 1
					DELETE FROM @VaccinationsTemp
					SET ROWCOUNT 0

			END		--end loop, WHILE EXISTS (SELECT * FROM @VaccinationsTemp)

		--SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage';

	END TRY
	BEGIN CATCH
		THROW;
		
	END CATCH
END
