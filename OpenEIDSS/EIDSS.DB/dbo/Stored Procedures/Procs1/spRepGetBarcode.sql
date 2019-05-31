

--##SUMMARY Select data for barcode.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 13.01.2010

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepGetBarcode 10057026, 12674910000000

*/

CREATE  Procedure [dbo].[spRepGetBarcode]
	(
	    @TemplateID	as bigint,
		@ObjID	    as bigint
	)
AS	
	-----------------------Sample Trasnfer         ---------------------------------------------------------
	IF @TemplateID = 10057026--N'nbtSampleTransfer'
	BEGIN
		SELECT	strBarcode	as strBarcode,
				strBarcode	as strBottom
		FROM dbo.tlbTransferOUT
		WHERE idfTransferOut=@ObjID
	END
	ELSE
	BEGIN
		SELECT	'top id'	as strTop,
				'barcode'	as strBarcode,
				'bottom id'	as strBottom
	END

