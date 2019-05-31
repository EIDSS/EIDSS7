--*************************************************************
-- Name 				: USSP_HUMAN_DISEASE_ANTIVIRALTHERAPIES_SET
-- Description			: add update Human Disease Report Antiviral Therapies
--          
-- Author               : HAP
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- HAP				20190104     Created
-- HAP				20190109    Update delete of temp table
--
-- Testing code:
-- exec USSP_HUMAN_DISEASE_ANTIVIRALTHERAPIES_SET null
--*************************************************************
CREATE PROCEDURE [dbo].[USSP_HUMAN_DISEASE_ANTIVIRALTHERAPIES_SET]
    @idfHumanCase BIGINT = NULL,
	@AntiviralTherapiesParameters		NVARCHAR(MAX) = NULL
AS
Begin
	SET NOCOUNT ON;
		Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
	DECLARE
@idfAntimicrobialTherapy	BIGINT = NULL,
 --@idfHumanCase					BIGINT = NULL, 
 @datFirstAdministeredDate			DATETIME2 = NULL,
 @strAntimicrobialTherapyName	     nvarchar(200),
 @strDosage	     nvarchar(200)

	DECLARE @returnCode	INT = 0;
	DECLARE	@returnMsg	NVARCHAR(MAX) = 'SUCCESS';

	DECLARE  @AntiviralTherapiesTemp TABLE (				
					idfAntimicrobialTherapy	BIGINT NULL, 
					 idfHumanCase						BIGINT NULL, 
					 datFirstAdministeredDate			DATETIME2 NULL,
					 strAntimicrobialTherapyName	    nvarchar(200) NULL,
					 strDosage	     nvarchar(200) NULL
			)


	INSERT INTO	@AntiviralTherapiesTemp 
	SELECT * FROM OPENJSON(@AntiviralTherapiesParameters) 
			WITH (
					idfAntimicrobialTherapy	BIGINT, 
					 idfHumanCase						BIGINT, 
					 datFirstAdministeredDate			DATETIME2,
					 strAntimicrobialTherapyName	    nvarchar(200),
					 strDosage	     nvarchar(200)
				);

	BEGIN TRY  
		WHILE EXISTS (SELECT * FROM @AntiviralTherapiesTemp)
			BEGIN
				SELECT TOP 1
					@idfAntimicrobialTherapy = idfAntimicrobialTherapy,
					--@idfHumanCase = idfHumanCase,
					@datFirstAdministeredDate = datFirstAdministeredDate,
					@strAntimicrobialTherapyName = strAntimicrobialTherapyName,
					@strDosage = strDosage
				FROM @AntiviralTherapiesTemp


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

			SET ROWCOUNT 1
					DELETE FROM @AntiviralTherapiesTemp
					SET ROWCOUNT 0

		END		--end loop, WHILE EXISTS (SELECT * FROM @AntiviralTherapiesTemp)

		--SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage';

	END TRY
	BEGIN CATCH
		THROW;
		
	END CATCH
END
