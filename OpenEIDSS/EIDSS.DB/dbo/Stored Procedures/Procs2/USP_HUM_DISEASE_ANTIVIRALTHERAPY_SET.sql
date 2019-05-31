--*************************************************************
-- Name 				: USP_HUM_DISEASE_ANTIVIRALTHERAPY_SET
-- Description			: add update Human Disease Report Antiviral Therapy
--          
-- Author               : HAP
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- HAP				20190228     Created
--
-- Testing code:
-- exec USP_HUM_DISEASE_ANTIVIRALTHERAPY_SET null
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_DISEASE_ANTIVIRALTHERAPY_SET]
	@idfAntimicrobialTherapy	BIGINT NULL, 
	@idfHumanCase						BIGINT NULL, 
	@datFirstAdministeredDate			DATETIME2 NULL,
	@strAntimicrobialTherapyName	    nvarchar(200) NULL,
	@strDosage	     nvarchar(200) NULL
AS
Begin 
	SET NOCOUNT ON;
		Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)	

	DECLARE @returnCode	INT = 0;
	DECLARE	@returnMsg	NVARCHAR(MAX) = 'SUCCESS';
	
	
	BEGIN TRY  
		
		IF NOT EXISTS(SELECT TOP 1 idfAntimicrobialTherapy from tlbAntimicrobialTherapy WHERE idfAntimicrobialTherapy = @idfAntimicrobialTherapy)
		BEGIN
				INSERT INTO @SupressSelect
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbAntimicrobialTherapy',  @idfAntimicrobialTherapy OUTPUT;
							

				INSERT 
					INTO	dbo.tlbAntimicrobialTherapy
							(							
								idfAntimicrobialTherapy,
								idfHumanCase,
								datFirstAdministeredDate,
								strAntimicrobialTherapyName,
								strDosage
							)
					VALUES (
								@idfAntimicrobialTherapy,
								@idfHumanCase,
								@datFirstAdministeredDate,
								@strAntimicrobialTherapyName,
								@strDosage 
							);
		END
		ELSE
			BEGIN
				UPDATE dbo.tlbAntimicrobialTherapy
					SET			
							 idfHumanCase	  = @idfHumanCase,
							 datFirstAdministeredDate  = @datFirstAdministeredDate,
							 strAntimicrobialTherapyName  = @strAntimicrobialTherapyName,				
							 strDosage	  = @strDosage

					WHERE	idfAntimicrobialTherapy = @idfAntimicrobialTherapy
					AND		intRowStatus = 0
			END

			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfAntimicrobialTherapy '@idfAntimicrobialTherapy'

	END TRY  
	BEGIN CATCH
		THROW;
		
	END CATCH
END
