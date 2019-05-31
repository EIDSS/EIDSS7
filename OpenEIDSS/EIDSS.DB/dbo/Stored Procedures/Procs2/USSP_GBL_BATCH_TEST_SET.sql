

-- ================================================================================================
-- Name: USSP_GBL_BATCH_TEST_SET
--
-- Description:	Inserts or updates batch test records for various use cases.
--
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/22/2018 Initial release.
-- Stephen Long     02/19/2019 Remove positive control, negative control and reagent lot numbers 
--                             to match use case.  Increased test requested from 100 to 200 and 
--                             made nvarchar.
-- Stephen Long     03/28/2019 Updated get next number call to use the name instead of the ID.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_BATCH_TEST_SET]
(
    @LanguageID NVARCHAR(50),
    @BatchTestID BIGINT OUTPUT,
    @TestNameTypeID BIGINT = NULL,
    @BatchStatusTypeID BIGINT = NULL,
    @PerformedByOrganizationID BIGINT = NULL,
    @PerformedByPersonID BIGINT = NULL,
    @ValidatedByOrganizationID BIGINT = NULL,
    @ValidatedByPersonID BIGINT = NULL,
    @ObservationID BIGINT,
    @SiteID BIGINT,
    @PerformedDate DATETIME = NULL,
    @ValidationDate DATETIME = NULL,
    @EIDSSBatchTestID NVARCHAR(200) = NULL,
    @RowStatus INT,
    @ResultEnteredByPersonID BIGINT = NULL,
    @ResultEnteredByOrganizationID BIGINT = NULL,
    @TestRequested NVARCHAR(200) = NULL,
    @RowAction CHAR(1)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @RowAction = 'I'
        BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbBatchTest',
				@idfsKey = @BatchTestID OUTPUT;

            EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Batch Test Barcode',
				@NextNumberValue = @EIDSSBatchTestID OUTPUT,
                @InstallationSite = @SiteID;

            INSERT INTO dbo.tlbBatchTest
            (
                idfBatchTest,
                idfsTestName,
                idfsBatchStatus,
                idfPerformedByOffice,
                idfPerformedByPerson,
                idfValidatedByOffice,
                idfValidatedByPerson,
                idfObservation,
                idfsSite,
                datPerformedDate,
                datValidatedDate,
                strBarcode,
                intRowStatus,
                idfResultEnteredByPerson,
                idfResultEnteredByOffice,
                TestRequested
            )
            VALUES
            (@BatchTestID, @TestNameTypeID, @BatchStatusTypeID, @PerformedByOrganizationID, @PerformedByPersonID,
             @ValidatedByOrganizationID, @ValidatedByPersonID, @ObservationID, @SiteID, @PerformedDate,
             @ValidationDate, @EIDSSBatchTestID, @RowStatus, @ResultEnteredByPersonID, @ResultEnteredByOrganizationID,
             @TestRequested);
        END;
        ELSE
        BEGIN
            UPDATE dbo.tlbBatchTest
            SET idfsTestName = @TestNameTypeID,
                idfsBatchStatus = @BatchStatusTypeID,
                idfPerformedByOffice = @PerformedByOrganizationID,
                idfPerformedByPerson = @PerformedByPersonID,
                idfValidatedByOffice = @ValidatedByOrganizationID,
                idfValidatedByPerson = @ValidatedByPersonID,
                idfObservation = @ObservationID,
                idfsSite = @SiteID,
                datPerformedDate = @PerformedDate,
                datValidatedDate = @ValidationDate,
                strBarcode = @EIDSSBatchTestID,
                intRowStatus = @RowStatus,
                idfResultEnteredByPerson = @ResultEnteredByPersonID,
                idfResultEnteredByOffice = @ResultEnteredByOrganizationID,
                TestRequested = @TestRequested
            WHERE idfBatchTest = @BatchTestID;
        END;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
