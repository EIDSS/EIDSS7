-- ================================================================================================
-- Name: USP_VET_FARM_HERD_SPECIES_GETList
--
-- Description:	Get farm, herd, species list for the veterinary disease and monitoring session 
-- enter and edit use cases as a flattened structure.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/10/2019 Initial release.
-- Stephen Long     04/23/2019 Updated where clause on farm snapshot insert/selects to no longer 
--                             left join veterinary disease report as not needed.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_HERD_SPECIES_GETList] (
	@LanguageID NVARCHAR(50),
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@MonitoringSessionID BIGINT = NULL,
	@FarmID BIGINT = NULL,
	@FarmMasterID BIGINT = NULL,
	@EIDSSFarmID NVARCHAR(200) = NULL
	)
AS
BEGIN
	DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
	DECLARE @ReturnCode BIGINT = 0;
	DECLARE @FarmHerdSpecies TABLE (
		RecordID INT IDENTITY PRIMARY KEY,
		RecordType VARCHAR(10),
		FarmID BIGINT NULL,
		FarmMasterID BIGINT NULL,
		HerdID BIGINT NULL,
		HerdMasterID BIGINT NULL,
		SpeciesID BIGINT NULL,
		SpeciesMasterID BIGINT NULL,
		SpeciesTypeID BIGINT NULL,
		SpeciesTypeName NVARCHAR(200) NULL,
		EIDSSFarmID NVARCHAR(200) NULL,
		EIDSSHerdID NVARCHAR(200) NULL,
		StartOfSignsDate DATETIME NULL,
		AverageAge NVARCHAR(200) NULL,
		SickAnimalQuantity INT NULL,
		TotalAnimalQuantity INT NULL,
		DeadAnimalQuantity INT NULL,
		ObservationID BIGINT NULL,
		Note NVARCHAR(2000) NULL,
		RowStatus INT NULL,
		RowAction NCHAR(1)
		);

	BEGIN TRY
		IF NOT @MonitoringSessionID IS NULL
		BEGIN
			INSERT INTO @FarmHerdSpecies
			SELECT 'Farm',
				f.idfFarm,
				f.idfFarmActual,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				f.strFarmCode,
				'Farm ' + CONVERT(NVARCHAR, f.strFarmCode), -- show in herd code as well, for the proper sorting on the UI grid display.
				NULL,
				NULL,
				0,
				(COALESCE(NULLIF(RTRIM(LTRIM(f.intLivestockTotalAnimalQty)), ''), 0) + COALESCE(NULLIF(RTRIM(LTRIM(f.intAvianTotalAnimalQty)), ''), 0)) AS intTotalAnimalQty,
				0,
				NULL,
				NULL,
				f.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbFarm f
			WHERE f.idfMonitoringSession = @MonitoringSessionID
				AND f.intRowStatus = 0
			
			UNION
			
			SELECT 'Farm',
				f.idfFarm,
				f.idfFarmActual,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				f.strFarmCode,
				'Farm ' + CONVERT(NVARCHAR, f.strFarmCode), -- show in herd code as well, for the proper sorting on the UI grid display.
				NULL,
				NULL,
				0,
				(COALESCE(NULLIF(RTRIM(LTRIM(f.intLivestockTotalAnimalQty)), ''), 0) + COALESCE(NULLIF(RTRIM(LTRIM(f.intAvianTotalAnimalQty)), ''), 0)) AS intTotalAnimalQty,
				0,
				NULL,
				NULL,
				f.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbFarm f
			INNER JOIN dbo.tlbMonitoringSessionSummary AS mss
				ON mss.idfFarm = f.idfFarm
					AND mss.intRowStatus = 0
			WHERE mss.idfMonitoringSession = @MonitoringSessionID
				AND f.intRowStatus = 0;

			INSERT INTO @FarmHerdSpecies
			SELECT 'Herd',
				h.idfFarm,
				f.idfFarmActual,
				h.idfHerd,
				h.idfHerdActual,
				NULL,
				NULL,
				NULL,
				NULL,
				f.strFarmCode,
				'Herd ' + h.strHerdCode,
				NULL,
				NULL,
				h.intSickAnimalQty,
				h.intTotalAnimalQty,
				h.intDeadAnimalQty,
				NULL,
				h.strNote,
				h.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbHerd h
			INNER JOIN dbo.tlbFarm AS f
				ON f.idfFarm = h.idfFarm
					AND f.intRowStatus = 0
			INNER JOIN dbo.tlbMonitoringSession AS ms
				ON ms.idfMonitoringSession = f.idfMonitoringSession
					AND ms.intRowStatus = 0
			WHERE ms.idfMonitoringSession = @MonitoringSessionID
				AND h.intRowStatus = 0
			
			UNION
			
			SELECT 'Herd',
				h.idfFarm,
				f.idfFarmActual,
				h.idfHerd,
				h.idfHerdActual,
				NULL,
				NULL,
				NULL,
				NULL,
				f.strFarmCode,
				'Herd ' + h.strHerdCode,
				NULL,
				NULL,
				h.intSickAnimalQty,
				h.intTotalAnimalQty,
				h.intDeadAnimalQty,
				NULL,
				h.strNote,
				h.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbHerd h
			INNER JOIN dbo.tlbFarm AS f
				ON f.idfFarm = h.idfFarm
					AND f.intRowStatus = 0
			INNER JOIN dbo.tlbMonitoringSessionSummary AS mss
				ON mss.idfFarm = f.idfFarm
					AND mss.intRowStatus = 0
			WHERE mss.idfMonitoringSession = @MonitoringSessionID
				AND h.intRowStatus = 0;

			INSERT INTO @FarmHerdSpecies
			SELECT 'Species',
				h.idfFarm,
				f.idfFarmActual,
				s.idfHerd,
				h.idfHerdActual,
				s.idfSpecies,
				s.idfSpeciesActual,
				s.idfsSpeciesType,
				speciesType.name AS SpeciesTypeName,
				f.strFarmCode,
				'Herd ' + h.strHerdCode,
				s.datStartOfSignsDate,
				s.strAverageAge,
				s.intSickAnimalQty,
				s.intTotalAnimalQty,
				s.intDeadAnimalQty,
				s.idfObservation,
				s.strNote,
				s.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbSpecies s
			INNER JOIN dbo.tlbHerd AS h
				ON h.idfHerd = s.idfHerd
					AND h.intRowStatus = 0
			INNER JOIN dbo.tlbFarm AS f
				ON f.idfFarm = h.idfFarm
					AND f.intRowStatus = 0
			INNER JOIN dbo.tlbMonitoringSession AS ms
				ON ms.idfMonitoringSession = f.idfMonitoringSession
					AND ms.intRowStatus = 0
			LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
				ON speciesType.idfsReference = s.idfsSpeciesType
			WHERE ms.idfMonitoringSession = @MonitoringSessionID
				AND s.intRowStatus = 0
			
			UNION
			
			SELECT 'Species',
				h.idfFarm,
				f.idfFarmActual,
				s.idfHerd,
				h.idfHerdActual,
				s.idfSpecies,
				s.idfSpeciesActual,
				s.idfsSpeciesType,
				speciesType.name AS SpeciesTypeName,
				f.strFarmCode,
				'Herd ' + h.strHerdCode,
				s.datStartOfSignsDate,
				s.strAverageAge,
				s.intSickAnimalQty,
				s.intTotalAnimalQty,
				s.intDeadAnimalQty,
				s.idfObservation,
				s.strNote,
				s.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbSpecies s
			INNER JOIN dbo.tlbHerd AS h
				ON h.idfHerd = s.idfHerd
					AND h.intRowStatus = 0
			INNER JOIN dbo.tlbFarm AS f
				ON f.idfFarm = h.idfFarm
					AND f.intRowStatus = 0
			INNER JOIN dbo.tlbMonitoringSessionSummary AS mss
				ON mss.idfFarm = f.idfFarm
					AND mss.intRowStatus = 0
			LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
				ON speciesType.idfsReference = s.idfsSpeciesType
			WHERE mss.idfMonitoringSession = @MonitoringSessionID
				AND s.intRowStatus = 0;
		END;

		IF NOT @FarmID IS NULL
		BEGIN
			INSERT INTO @FarmHerdSpecies
			SELECT 'Farm',
				f.idfFarm,
				f.idfFarmActual,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				f.strFarmCode,
				'Farm ' + f.strFarmCode, -- show in herd code as well, for the proper sorting on the UI grid display.
				NULL,
				NULL,
				0,
				(COALESCE(NULLIF(RTRIM(LTRIM(f.intLivestockTotalAnimalQty)), ''), 0) + COALESCE(NULLIF(RTRIM(LTRIM(f.intAvianTotalAnimalQty)), ''), 0)) AS intTotalAnimalQty,
				0,
				NULL,
				NULL,
				f.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbFarm f
			WHERE f.idfFarm = @FarmID
				AND f.intRowStatus = 0;

			INSERT INTO @FarmHerdSpecies
			SELECT 'Herd',
				h.idfFarm,
				f.idfFarmActual,
				h.idfHerd,
				h.idfHerdActual,
				NULL,
				NULL,
				NULL,
				NULL,
				f.strFarmCode,
				'Herd ' + h.strHerdCode,
				NULL,
				NULL,
				h.intSickAnimalQty,
				h.intTotalAnimalQty,
				h.intDeadAnimalQty,
				NULL,
				h.strNote,
				h.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbHerd h
			LEFT JOIN dbo.tlbFarm AS f
				ON f.idfFarm = h.idfFarm
					AND f.intRowStatus = 0
			WHERE f.idfFarm = @FarmID
				AND h.intRowStatus = 0;

			INSERT INTO @FarmHerdSpecies
			SELECT 'Species',
				h.idfFarm,
				f.idfFarmActual,
				s.idfHerd,
				h.idfHerdActual,
				s.idfSpecies,
				s.idfSpeciesActual,
				s.idfsSpeciesType,
				speciesType.name AS SpeciesTypeName,
				f.strFarmCode,
				'Herd ' + h.strHerdCode,
				s.datStartOfSignsDate,
				s.strAverageAge,
				s.intSickAnimalQty,
				s.intTotalAnimalQty,
				s.intDeadAnimalQty,
				s.idfObservation,
				s.strNote,
				s.intRowStatus,
				'R' AS RowAction
			FROM dbo.tlbSpecies s
			LEFT JOIN dbo.tlbHerd AS h
				ON h.idfHerd = s.idfHerd
					AND h.intRowStatus = 0
			LEFT JOIN dbo.tlbFarm AS f
				ON f.idfFarm = h.idfFarm
					AND f.intRowStatus = 0
			LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
				ON speciesType.idfsReference = s.idfsSpeciesType
			WHERE f.idfFarm = @FarmID
				AND s.intRowStatus = 0;
		END
		ELSE IF NOT @FarmMasterID IS NULL
		BEGIN
			IF @FarmMasterID = '-1'
			BEGIN
				INSERT INTO @FarmHerdSpecies
				SELECT 'Farm',
					NULL,
					- 1,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					'',
					'Farm 0',
					NULL,
					NULL,
					0,
					0,
					0,
					NULL,
					NULL,
					0,
					'I' AS RowAction
			END
			ELSE
			BEGIN
				INSERT INTO @FarmHerdSpecies
				SELECT 'Farm',
					NULL,
					f.idfFarmActual,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					f.strFarmCode,
					'Farm ' + f.strFarmCode, -- show in herd code as well, for the proper sorting on the UI grid display.
					NULL,
					NULL,
					0,
					(COALESCE(NULLIF(RTRIM(LTRIM(f.intLivestockTotalAnimalQty)), ''), 0) + COALESCE(NULLIF(RTRIM(LTRIM(f.intAvianTotalAnimalQty)), ''), 0)) AS intTotalAnimalQty,
					0,
					NULL,
					NULL,
					f.intRowStatus,
					'R' AS RowAction
				FROM dbo.tlbFarmActual f
				WHERE f.idfFarmActual = @FarmMasterID
					AND f.intRowStatus = 0;

				INSERT INTO @FarmHerdSpecies
				SELECT 'Herd',
					NULL,
					h.idfFarmActual,
					NULL,
					h.idfHerdActual,
					NULL,
					NULL,
					NULL,
					NULL,
					f.strFarmCode,
					'Herd ' + h.strHerdCode,
					NULL,
					NULL,
					h.intSickAnimalQty,
					h.intTotalAnimalQty,
					h.intDeadAnimalQty,
					NULL,
					h.strNote,
					h.intRowStatus,
					'R' AS RowAction
				FROM dbo.tlbHerdActual h
				LEFT JOIN dbo.tlbFarmActual AS f
					ON f.idfFarmActual = h.idfFarmActual
						AND f.intRowStatus = 0
				WHERE f.idfFarmActual = CASE ISNULL(@FarmMasterID, '')
						WHEN ''
							THEN f.idfFarmActual
						ELSE @FarmMasterID
						END
					AND h.intRowStatus = 0;

				INSERT INTO @FarmHerdSpecies
				SELECT 'Species',
					NULL,
					h.idfFarmActual,
					NULL,
					h.idfHerdActual,
					NULL,
					s.idfSpeciesActual,
					s.idfsSpeciesType,
					speciesType.name AS SpeciesTypeName,
					f.strFarmCode,
					'Herd ' + h.strHerdCode,
					s.datStartOfSignsDate,
					s.strAverageAge,
					s.intSickAnimalQty,
					s.intTotalAnimalQty,
					s.intDeadAnimalQty,
					NULL,
					s.strNote,
					s.intRowStatus,
					'R' AS RowAction
				FROM dbo.tlbSpeciesActual s
				LEFT JOIN dbo.tlbHerdActual AS h
					ON h.idfHerdActual = s.idfHerdActual
						AND h.intRowStatus = 0
				LEFT JOIN dbo.tlbFarmActual AS f
					ON f.idfFarmActual = h.idfFarmActual
						AND f.intRowStatus = 0
				LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
					ON speciesType.idfsReference = s.idfsSpeciesType
				WHERE f.idfFarmActual = CASE ISNULL(@FarmMasterID, '')
						WHEN ''
							THEN f.idfFarmActual
						ELSE @FarmMasterID
						END
					AND s.intRowStatus = 0;
			END
		END

		SELECT *
		FROM @FarmHerdSpecies
		ORDER BY FarmID,
			HerdID,
			SpeciesID;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode,
			@ReturnMessage;

		THROW;
	END CATCH;
END
