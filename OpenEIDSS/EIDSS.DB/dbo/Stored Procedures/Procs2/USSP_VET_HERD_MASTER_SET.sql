-- ================================================================================================
-- Name: USSP_VET_HERD_MASTER_SET
--
-- Description:	Inserts or updates herd actual for the avian and livestock veterinary disease 
-- report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/10/2019 Initial release.
-- Stephen Long     04/23/2019 Added OUTPUT to the EIDSSHerdID parameter.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_HERD_MASTER_SET] (
	@LanguageID NVARCHAR(50),
	@HerdMasterID BIGINT = NULL OUTPUT,
	@FarmMasterID BIGINT = NULL,
	@EIDSSHerdID NVARCHAR(200) = NULL OUTPUT,
	@SickAnimalQuantity INT = NULL,
	@TotalAnimalQuantity INT = NULL,
	@DeadAnimalQuantity INT = NULL,
	@Note NVARCHAR(2000) = NULL,
	@RowStatus INT,
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbHerdActual',
				@HerdMasterID OUTPUT;

			EXECUTE dbo.USP_GBL_NextNumber_GET 'Animal Group',
				@EIDSSHerdID OUTPUT,
				NULL;

			INSERT INTO dbo.tlbHerdActual (
				idfHerdActual,
				idfFarmActual,
				strHerdCode,
				intSickAnimalQty,
				intTotalAnimalQty,
				intDeadAnimalQty,
				strNote,
				intRowStatus
				)
			VALUES (
				@HerdMasterID,
				@FarmMasterID,
				@EIDSSHerdID,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				@Note,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbHerdActual
			SET idfFarmActual = @FarmMasterID,
				strHerdCode = @EIDSSHerdID,
				intSickAnimalQty = @SickAnimalQuantity,
				intTotalAnimalQty = @TotalAnimalQuantity,
				intDeadAnimalQty = @DeadAnimalQuantity,
				strNote = @Note,
				intRowStatus = @RowStatus
			WHERE idfHerdActual = @HerdMasterID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
