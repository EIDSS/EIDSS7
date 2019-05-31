

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 16.03.2012

-- exec [spLabSampleTransfer_SelectDetail] 0, 'en'

CREATE PROCEDURE [dbo].[spLabSampleTransfer_SelectDetail] 
	@idfTransferOut bigint,
	@LangID as nvarchar(20)
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select		
		idfTransferOut,
		datSendDate,
		idfSendByPerson,
		idfSendFromOffice,
		idfSendToOffice,
		idfsSite,
		idfsTransferStatus,
		strBarcode,
		strNote,
		datModificationForArchiveDate
	from		tlbTransferOUT
	where		idfTransferOut=@idfTransferOut

	select		tlbMaterial.idfMaterial,
				tlbMaterial.strBarcode,
				dbo.fnReferenceRepair.name AS strSampleName,
				--attributes of material copy that was created during transfer out
				--before trasfer in blnAccessioned = 0
				--idfMaterialForTransferIn<>NULL and blnAccessioned = 0 is the condition to enable transfer in
				--if idfMaterialForTransferIn = NULL, material can't be transferred in because material record for transfer in is not replicated yet
				MaterialForTransferIn.strBarcode as strBarcodeNew,
				MaterialForTransferIn.idfInDepartment,

				MaterialForTransferIn.datAccession,
				MaterialForTransferIn.idfsAccessionCondition,
				MaterialForTransferIn.strCondition,
				MaterialForTransferIn.idfAccesionByPerson,
				MaterialForTransferIn.blnAccessioned,
				MaterialForTransferIn.idfSubdivision,
				MaterialForTransferIn.idfMaterial as idfMaterialForTransferIn

	from tlbMaterial 
	inner join	tlbTransferOutMaterial
	on			tlbTransferOutMaterial.idfMaterial=tlbMaterial.idfMaterial and
				tlbTransferOutMaterial.idfTransferOut=@idfTransferOut and
				tlbTransferOutMaterial.intRowStatus=0
	left join	tlbMaterial MaterialForTransferIn
	on			MaterialForTransferIn.idfParentMaterial=tlbMaterial.idfMaterial
				AND MaterialForTransferIn.idfsSampleKind = 12675430000000 --TransferredIn
				AND MaterialForTransferIn.intRowStatus = 0
	left join	dbo.fnReferenceRepair(@LangID,19000087) --rftSpecimenType
  on			dbo.fnReferenceRepair.idfsReference = tlbMaterial.idfsSampleType

	
where tlbMaterial.intRowStatus = 0
	

END



