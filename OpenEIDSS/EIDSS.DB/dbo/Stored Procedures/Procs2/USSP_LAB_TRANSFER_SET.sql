
-- ================================================================================================
-- Name: USSP_LAB_TRANSFER_SET
--
-- Description:	Inserts or updates transfer records for various use cases.
--
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/01/2018 Initial release.
-- Stephen Long     02/19/2019 Added test requested parameter to match use case.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_LAB_TRANSFER_SET]
(
    @LanguageID NVARCHAR(50),
    @TransferID BIGINT OUTPUT,
    @SampleID BIGINT,
    @EIDSSTransferID NVARCHAR(200) = NULL,
    @TransferStatusTypeID BIGINT,
    @TransferredFromOrganizationID BIGINT = NULL,
    @TransferredToOrganizationID BIGINT = NULL,
    @SentByPersonID BIGINT = NULL,
    @TransferDate DATETIME = NULL,
    @Note NVARCHAR(200) = NULL,
    @SiteID BIGINT,
	@TestRequested NVARCHAR(200) = NULL, 
    @RowStatus INT,
    @RowAction CHAR
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @RowAction = 'I'
        BEGIN
            EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbTransferOut',
                                              @idfsKey = @TransferID OUTPUT;

            EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Sample Transfer Barcode',
                                               @NextNumberValue = @EIDSSTransferID OUTPUT,
                                               @InstallationSite = NULL;

            INSERT INTO dbo.tlbTransferOUT
            (
                idfTransferOut,
                idfsTransferStatus,
                idfSendFromOffice,
                idfSendToOffice,
                idfSendByPerson,
                datSendDate,
                strNote,
                strBarcode,
                idfsSite,
				TestRequested,
                intRowStatus
            )
            VALUES
            (@TransferID, @TransferStatusTypeID, @TransferredFromOrganizationID, @TransferredToOrganizationID, @SentByPersonID, @TransferDate, @Note,
             @EIDSSTransferID, @SiteID, @TestRequested, @RowStatus);

            INSERT INTO dbo.tlbTransferOutMaterial
            (
                idfMaterial,
                idfTransferOut,
                intRowStatus
            )
            VALUES
            (@SampleID, @TransferID, 0);
        END;
        ELSE
        BEGIN
            UPDATE dbo.tlbTransferOUT
            SET idfsTransferStatus = @TransferStatusTypeID,
                idfSendFromOffice = @TransferredFromOrganizationID,
                idfSendToOffice = @TransferredToOrganizationID,
                idfSendByPerson = @SentByPersonID,
                datSendDate = @TransferDate,
                strNote = @Note,
                strBarcode = @EIDSSTransferID,
                idfsSite = @SiteID,
				TestRequested = @TestRequested, 
                intRowStatus = @RowStatus
            WHERE idfTransferOut = @TransferID;

            UPDATE dbo.tlbTransferOutMaterial
            SET intRowStatus = @RowStatus
            WHERE idfTransferOut = @TransferID;
        END;
    END TRY
    BEGIN CATCH
        ; THROW;
    END CATCH;
END;