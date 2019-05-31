
--*************************************************************
-- Name 				:	USP_HUM_HUMAN_DISEASE_VACCINATION_SET
-- Description			:	Insert OR UPDATE Human Disease Report Vaccination record
--          
-- Author               :	Harold Pryor
-- Revision History
--Name  Date		Change Detail
-- HAP				20190228     Created
---
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_DISEASE_VACCINATION_SET]
(
 @HumanDiseaseReportVaccinationUID	BIGINT, -- HumanDiseaseReportVaccination.HumanDiseaseReportVaccinationUID Primary Key
 @idfHumanCase						BIGINT, -- HumanDiseaseReportVaccination.idfHumanCase
 @VaccinationName					nvarchar(200) NULL, -- HumanDiseaseReportVaccination.VaccinationName
 @VaccinationDate					DATETIME = NULL --HumanDiseaseReportVaccination.VaccinationDate 
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)	

BEGIN
	BEGIN TRY

			-- Create a human record from Human Actual if not already present
			--IF  @HumanDiseaseReportVaccinationUID IS NULL 
			IF NOT EXISTS(SELECT TOP 1 HumanDiseaseReportVaccinationUID from HumanDiseaseReportVaccination WHERE HumanDiseaseReportVaccinationUID = @HumanDiseaseReportVaccinationUID)
						
				BEGIN

				    INSERT INTO @SupressSelect
					-- Get next key value
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'HumanDiseaseReportVaccination',  @HumanDiseaseReportVaccinationUID OUTPUT					

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
		
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @HumanDiseaseReportVaccinationUID 'HumanDiseaseReportVaccinationUID'

	END TRY
	BEGIN CATCH
		THROW;
		
	END CATCH
END

