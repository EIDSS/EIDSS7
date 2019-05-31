

CREATE PROCEDURE [dbo].[spLabSampleTransfer_Post]
	@Action INT,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfTransferOut bigint,
	@strBarcode nvarchar(200),
	@strNote nvarchar(2000),
	@idfSendFromOffice bigint,--target site
	@idfSendToOffice bigint,--target site
	@idfSendByPerson bigint,--who sent
	@datSendDate datetime,--time sent
	@idfsTransferStatus bigint--transfer status


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @Action = 4
	BEGIN
		insert	tlbTransferOUT(
			idfTransferOut,
			idfSendFromOffice,
			idfsTransferStatus,
			strBarcode,
			strNote,
			idfSendToOffice,
			idfSendByPerson,
			datSendDate,
			datModificationForArchiveDate
			)
	values	(
			@idfTransferOut,
			@idfSendFromOffice,
			@idfsTransferStatus,
			@strBarcode,
			@strNote,
			@idfSendToOffice,
			@idfSendByPerson,
			@datSendDate,
			getdate()
			)
	END
	ELSE IF @Action = 16
	BEGIN
	update	tlbTransferOUT
		set		
				strBarcode=@strBarcode,
				strNote=@strNote,
				idfSendToOffice=@idfSendToOffice,
				idfSendByPerson =@idfSendByPerson,
				datSendDate =@datSendDate,
				idfsTransferStatus =@idfsTransferStatus,
				datModificationForArchiveDate = getdate()
		where	idfTransferOut=@idfTransferOut
	END

END

