

-- ================================================================================================
-- Name: USP_LAB_FREEZER_SET
--
-- Description:	Inserts or updates freezer for the laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/29/2018 Initial release.
-- Stephen Long     01/25/2019 Added box place availability.
-- Stephen Long     03/06/2019 Changed the get next number object name paramater value from the ID 
--                             to the name.
-- Stephen Long     03/28/2019 Changed Notes parameter to FreezerNote.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_FREEZER_SET] (
	@LanguageID NVARCHAR(50),
	@FreezerID BIGINT,
	@StorageTypeID BIGINT,
	@OrganizationID BIGINT,
	@FreezerName NVARCHAR(200) = NULL,
	@FreezerNote NVARCHAR(200) = NULL,
	@EIDSSFreezerID NVARCHAR(200) = NULL,
	@Building NVARCHAR(200) = NULL,
	@Room NVARCHAR(200) = NULL,
	@RowStatus INT,
	@FreezerSubdivisions NVARCHAR(MAX) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode INT = 0,
		@ReturnMessage NVARCHAR(MAX) = 'SUCCESS';
	DECLARE @SupressSelect TABLE (
		ReturnCode INT,
		ReturnMessage NVARCHAR(MAX)
		);
	DECLARE @RowID BIGINT,
		@FreezerSubdivisionID BIGINT,
		@SubdivisionTypeID BIGINT = NULL,
		@ParentFreezerSubdivisionID BIGINT = NULL,
		@EIDSSFreezerSubdivisionID NVARCHAR(200) = NULL,
		@FreezerSubdivisionName NVARCHAR(200) = NULL,
		@SubdivisionNote NVARCHAR(200) = NULL,
		@NumberOfLocations INT = NULL,
		@BoxSizeTypeID BIGINT = NULL,
		@BoxPlaceAvailability NVARCHAR(MAX) = NULL,
		@RowAction CHAR = NULL;
	DECLARE @FreezerSubdivisionTemp TABLE (
		FreezerSubdivisionID BIGINT NOT NULL,
		SubdivisionTypeID BIGINT NULL,
		FreezerID BIGINT NOT NULL,
		ParentFreezerSubdivisionID BIGINT NULL,
		OrganizationID BIGINT NOT NULL,
		EIDSSFreezerSubdivisionID NVARCHAR(200) NULL,
		FreezerSubdivisionName NVARCHAR(200) NULL,
		SubdivisionNote NVARCHAR(200) NULL,
		NumberOfLocations INT NULL,
		BoxSizeTypeID INT NULL,
		BoxPlaceAvailability NVARCHAR(MAX) NULL,
		RowStatus INT NOT NULL,
		RowAction CHAR NULL
		);

	BEGIN TRY
		BEGIN TRANSACTION;

		IF @EIDSSFreezerID IS NULL
		BEGIN
			INSERT INTO @SupressSelect
			EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = 'Freezer Barcode',
				@NextNumberValue = @EIDSSFreezerID OUTPUT,
				@InstallationSite = @OrganizationID;
		END;

		IF NOT EXISTS (
				SELECT *
				FROM dbo.tlbFreezer
				WHERE idfFreezer = @FreezerID
					AND intRowStatus = 0
				)
		BEGIN
			INSERT INTO @SupressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbFreezer',
				@idfsKey = @FreezerID OUTPUT;

			INSERT INTO dbo.tlbFreezer (
				idfFreezer,
				idfsStorageType,
				idfsSite,
				strFreezerName,
				strNote,
				strBarcode,
				intRowStatus,
				LocBuildingName,
				LocRoom
				)
			VALUES (
				@FreezerID,
				@StorageTypeID,
				@OrganizationID,
				@FreezerName,
				@FreezerNote,
				@EIDSSFreezerID,
				@RowStatus,
				@Building,
				@Room
				);
		END;
		ELSE
		BEGIN
			UPDATE dbo.tlbFreezer
			SET idfsStorageType = @StorageTypeID,
				idfsSite = @OrganizationID,
				strFreezerName = @FreezerName,
				strNote = @FreezerNote,
				strBarcode = @EIDSSFreezerID,
				intRowStatus = @RowStatus,
				LocBuildingName = @Building,
				LocRoom = @Room
			WHERE idfFreezer = @FreezerID;
		END;

		INSERT INTO @FreezerSubdivisionTemp
		SELECT *
		FROM OPENJSON(@FreezerSubdivisions) WITH (
				FreezerSubdivisionID BIGINT,
				SubdivisionTypeID BIGINT,
				FreezerID BIGINT,
				ParentFreezerSubdivisionID BIGINT,
				OrganizationID BIGINT,
				EIDSSFreezerSubdivisionID NVARCHAR(200),
				FreezerSubdivisionName NVARCHAR(200),
				SubdivisionNote NVARCHAR(200),
				NumberOfLocations INT,
				BoxSizeTypeID INT,
				BoxPlaceAvailability NVARCHAR(MAX),
				RowStatus INT,
				RowAction CHAR
				);

		WHILE EXISTS (
				SELECT *
				FROM @FreezerSubdivisionTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = FreezerSubdivisionID,
				@FreezerSubdivisionID = FreezerSubdivisionID,
				@SubdivisionTypeID = SubdivisionTypeID,
				@ParentFreezerSubdivisionID = ParentFreezerSubdivisionID,
				@OrganizationID = OrganizationID,
				@EIDSSFreezerSubdivisionID = EIDSSFreezerSubdivisionID,
				@FreezerSubdivisionName = FreezerSubdivisionName,
				@SubdivisionNote = SubdivisionNote,
				@NumberOfLocations = NumberOfLocations,
				@BoxSizeTypeID = BoxSizeTypeID,
				@BoxPlaceAvailability = BoxPlaceAvailability,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @FreezerSubdivisionTemp;

			IF @RowAction = 'I'
			BEGIN
				INSERT INTO @SupressSelect
				EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbFreezerSubdivision',
					@idfsKey = @FreezerSubdivisionID OUTPUT;

				IF @SubdivisionTypeID = 39890000000 --Box
				BEGIN
					INSERT INTO @SupressSelect
					EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Box Barcode',
						@NextNumberValue = @EIDSSFreezerSubdivisionID OUTPUT,
						@InstallationSite = NULL;
				END
				ELSE
				BEGIN
					INSERT INTO @SupressSelect
					EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Shelf Barcode',
						@NextNumberValue = @EIDSSFreezerSubdivisionID OUTPUT,
						@InstallationSite = NULL;
				END;

				INSERT INTO dbo.tlbFreezerSubdivision (
					idfSubdivision,
					idfsSubdivisionType,
					idfFreezer,
					idfParentSubdivision,
					idfsSite,
					strBarcode,
					strNameChars,
					strNote,
					intCapacity,
					intRowStatus,
					BoxSizeID,
					BoxPlaceAvailability
					)
				VALUES (
					@FreezerSubdivisionID,
					@SubdivisionTypeID,
					@FreezerID,
					@ParentFreezerSubdivisionID,
					@OrganizationID,
					@EIDSSFreezerSubdivisionID,
					@FreezerSubdivisionName,
					@SubdivisionNote,
					@NumberOfLocations,
					@RowStatus,
					@BoxSizeTypeID,
					@BoxPlaceAvailability
					);
			END;
			ELSE
			BEGIN
				UPDATE dbo.tlbFreezerSubdivision
				SET idfsSubdivisionType = @SubdivisionTypeID,
					idfFreezer = @FreezerID,
					idfParentSubdivision = @ParentFreezerSubdivisionID,
					idfsSite = @OrganizationID,
					strBarcode = @EIDSSFreezerSubdivisionID,
					strNameChars = @FreezerSubdivisionName,
					strNote = @SubdivisionNote,
					intCapacity = @NumberOfLocations,
					intRowStatus = @RowStatus,
					BoxSizeID = @BoxSizeTypeID,
					BoxPlaceAvailability = @BoxPlaceAvailability
				WHERE idfSubdivision = @FreezerSubdivisionID;
			END;

			UPDATE @FreezerSubdivisionTemp
			SET ParentFreezerSubdivisionID = @FreezerSubdivisionID
			WHERE ParentFreezerSubdivisionID = @RowID;

			DELETE
			FROM @FreezerSubdivisionTemp
			WHERE FreezerSubdivisionID = @RowID;
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@FreezerID FreezerID,
			@EIDSSFreezerID EIDSSFreezerID;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@FreezerID FreezerID,
			@EIDSSFreezerID EIDSSFreezerID;

		THROW;
	END CATCH;
END;
