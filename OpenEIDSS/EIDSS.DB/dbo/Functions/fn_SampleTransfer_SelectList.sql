

CREATE FUNCTION [dbo].[fn_SampleTransfer_SelectList] 
(	
	@LangID nvarchar(20)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		tlbTransferOUT.idfTransferOut,
		tlbTransferOUT.strBarcode,
		tlbTransferOUT.idfSendFromOffice,
		tlbTransferOUT.idfSendToOffice,
		--Src.idfOffice as idfOfficeFrom,
		--Dst.idfOffice as idfOfficeTo,
		SrcName.name as TransferFrom,
		DstName.name as TransferTo
	FROM		tlbTransferOUT
	LEFT JOIN	fnInstitution(@LangID) SrcName
	ON			SrcName.idfOffice=tlbTransferOUT.idfSendFromOffice
	LEFT JOIN	fnInstitution(@LangID) DstName
	ON			DstName.idfOffice=tlbTransferOUT.idfSendToOffice
	WHERE 		tlbTransferOUT.intRowStatus=0
)


