

--##SUMMARY Select data for Container Transfer report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 15.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepLimSampleTransferForm @ObjID=181450001100,@LangID=N'en'

*/
 
create  Procedure [dbo].[spRepLimSampleTransferForm]
    (
		@ObjID bigint,
		@LangID as nvarchar(20)
    )
as
begin 
	select	
		tlbTransferOUT.strBarcode		as TransferOutBarcode,
		tlbTransferOUT.strBarcode		as TransferOutLabel,
		tlbTransferOUT.strNote			as PurposeOfTransfer,
		InstFromName.name				as TransferredFrom,
		InstToName.[name]				as SampleTrasnferredTo,
		dbo.fnConcatFullName(SentByPerson.strFamilyName, SentByPerson.strFirstName, SentByPerson.strSecondName) as SentBy,
		datSendDate						as DateSent,
		
		Cont.strBarcode					as SourceLabID,
		Cont.strBarcode					as SourceLabIDBarcode,
		SpecimenType.name				as SampleType,
		tlbMaterial.datAccession		as DateSampleReceived,
		dbo.fnConcatFullName(ReceivedByPerson.strFamilyName, ReceivedByPerson.strFirstName, ReceivedByPerson.strSecondName)	as ReceivedBy,

		Cont.strFieldBarcode			as SampleID,
		tlbMaterial.strBarcode			as LabSampleID,
		rfCondition.name				as Condition,				
		rfFreezers.[Path]				as StorageLocation,				
		tlbMaterial.strCondition		as Comment,
		rfFuncArea.name					as FunctionalArea				
		
	

	from		tlbTransferOUT
	
	left join	tlbTransferOutMaterial
	on			tlbTransferOutMaterial.idfTransferOut=tlbTransferOUT.idfTransferOut
	
	left join	tlbMaterial Cont
	on			Cont.idfMaterial = tlbTransferOutMaterial.idfMaterial
	and Cont.intRowStatus = 0
	
	left join	dbo.fnReferenceRepair(@LangID,19000087) SpecimenType
    on			SpecimenType.idfsReference = Cont.idfsSampleType

	

	left join	tlbMaterial
	on			tlbMaterial.idfParentMaterial=Cont.idfMaterial
				AND tlbMaterial.idfsSampleKind = 12675430000000 --TransferredIn
				AND tlbMaterial.intRowStatus = 0
				
	left join	dbo.fnReferenceRepair(@LangID,19000110) rfCondition
    on			rfCondition.idfsReference = tlbMaterial.idfsAccessionCondition
    
   	left join	dbo.fn_RepositorySchema(@LangID,null,null) rfFreezers
	on			rfFreezers.idfSubdivision = tlbMaterial.idfSubdivision
	
	left join	dbo.fnDepartment(@LangID) rfFuncArea
	on			rfFuncArea.idfDepartment = tlbMaterial.idfInDepartment
	
    				
	left join fnInstitution (@LangID) as InstFromName
	on tlbTransferOUT.idfSendFromOffice=InstFromName.idfOffice

	left join fnInstitution (@LangID) as InstToName
	on tlbTransferOUT.idfSendToOffice=InstToName.idfOffice

	Left join tlbPerson as SentByPerson
	on tlbTransferOUT.idfSendByPerson=SentByPerson.idfPerson

	Left join tlbPerson as ReceivedByPerson
	on tlbMaterial.idfAccesionByPerson=ReceivedByPerson.idfPerson

	where	tlbTransferOUT.idfTransferOut=@ObjID
end	
			

