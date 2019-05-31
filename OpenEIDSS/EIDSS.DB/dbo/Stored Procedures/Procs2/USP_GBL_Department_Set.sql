
-- ================================================================================================
-- Name: USP_GBL_Department_Set
--
-- Description:	Add, updates and deletes department records.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Joan Li          04/18/2017 Initial release; created based on V6.
-- Joan Li			04/26/2017 Insert data into table tlbDepartment.
-- Joan Li			06/21/2017 Add data to modify date and user info.
-- Joan Li			05/16/2018 Change to valid function FN_GBL_DATACHANGE_INFO.
-- Stephen Long     11/19/2018 Renamed for global use; used by multiple modules.
--
-- Testing Code:
-- EXECUTE dbo.usp_Department_Set 'I', NULL, 49710000000, NULL, NULL, NULL, NULL, 'Lij';
-- SELECT * FROM dbo.tlbdepartment ORDER BY idfdepartment DESC;
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_Department_Set] 
(
	@LanguageID								NVARCHAR(50),
	@DepartmentID							BIGINT OUTPUT,
	@OrganizationID							BIGINT,
	@DefaultName							NVARCHAR(200) = NULL,
	@NationalName							NVARCHAR(200) = NULL,
	@CountryID								BIGINT = NULL,
	@UserName								VARCHAR(100) = NULL, 
	@RecordAction							NCHAR = NULL
)
AS
BEGIN
	BEGIN TRY
		SET XACT_ABORT, NOCOUNT ON;

		BEGIN TRANSACTION

		IF UPPER(@RecordAction) = 'D' -- Delete
		BEGIN
			EXECUTE							dbo.usp_Department_Delete @DepartmentID;
		END
		ELSE
		BEGIN
			DECLARE @DepartmentNameTypeID	BIGINT,
				@NewRecordIndicator			BIT;
			IF NOT EXISTS (SELECT idfsDepartmentName FROM dbo.tlbDepartment WHERE idfDepartment = @DepartmentID)
			BEGIN
				EXECUTE						dbo.usp_sysGetNewID @DepartmentNameTypeID OUTPUT;
				SET							@NewRecordIndicator = 1;
			END

			IF(UPPER(@LanguageID) = 'EN' AND ISNULL(@DefaultName, N'') = N'')
			BEGIN
				SET							@DefaultName = @NationalName;
			END
	
			EXECUTE							dbo.usp_BaseReference_SysSet @DepartmentNameTypeID, 19000164, @LanguageID, @DefaultName, @NationalName, 0;

			IF @NewRecordIndicator = 1
			BEGIN
				IF @DepartmentID IS NULL
				BEGIN
					EXECUTE					dbo.usp_sysGetNewID @DepartmentID OUTPUT;
				END
				
				INSERT INTO					dbo.tlbDepartment
				(
											idfDepartment,
											idfsDepartmentName,
											idfOrganization,
											strReservedAttribute
				)
				VALUES
				(
											@DepartmentID,
											@DepartmentNameTypeID,
											@OrganizationID,
											dbo.FN_GBL_DATACHANGE_INFO(@UserName)
				);	   
			END
		END

		IF @@TRANCOUNT > 0
			COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK;

		THROW;
	END CATCH
END
