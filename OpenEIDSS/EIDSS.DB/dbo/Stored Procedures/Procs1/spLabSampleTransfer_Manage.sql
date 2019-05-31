

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE PROCEDURE [dbo].[spLabSampleTransfer_Manage]
	@idfTransferOut bigint,
	@idfMaterial bigint,
	@add integer
AS
BEGIN
	if @add>0
	BEGIN

		DECLARE @transfer nvarchar(200)
		DECLARE @tid bigint
		DECLARE @barcode nvarchar(200)

		SELECT		@transfer=tlbTransferOUT.strBarcode,
					@tid=tlbTransferOUT.idfTransferOut,
					@barcode=tlbMaterial.strBarcode
		FROM		tlbTransferOutMaterial
		INNER JOIN	tlbTransferOUT
		ON			tlbTransferOUT.idfTransferOut=tlbTransferOutMaterial.idfTransferOut AND
					tlbTransferOUT.intRowStatus=0
		INNER JOIN	tlbMaterial
		ON			tlbMaterial.idfMaterial=tlbTransferOutMaterial.idfMaterial AND
					tlbMaterial.intRowStatus=0
		WHERE		tlbTransferOutMaterial.idfMaterial=@idfMaterial AND
					tlbTransferOutMaterial.intRowStatus=0
		
		IF @tid is not null
		BEGIN
			   RAISERROR ('errSampleInTransfer %s %s', 16, 1, @barcode,@transfer)
		END

		INSERT INTO tlbTransferOutMaterial
		(idfMaterial,idfTransferOut)
		VALUES(@idfMaterial,@idfTransferOut)

	END
	ELSE
	BEGIN

		DELETE FROM tlbTransferOutMaterial
		WHERE	idfTransferOut=@idfTransferOut and idfMaterial=@idfMaterial
	END
END

