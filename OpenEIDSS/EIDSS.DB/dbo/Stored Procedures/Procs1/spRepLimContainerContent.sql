

--##SUMMARY Select data for Container content report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 15.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec dbo.spRepLimContainerContent @LangID=N'en',@ContID=NULL,@FreezerID=66630001100
exec dbo.spRepLimContainerContent @LangID=N'en',@ContID=145900000000,@FreezerID=NULL


select * from dbo.fn_RepositorySchema( N'en', 145890000000, null)
select * from dbo.fn_RepositorySchema( N'en',  null, 145900000000)


*/

create  Procedure [dbo].[spRepLimContainerContent]
    (
        @LangID			as nvarchar(10),
		@ContID			as bigint,
		@FreezerID		as bigint
    )
as
	if @FreezerID < 0 SET @FreezerID=null
	if @ContID < 0 SET @ContID=null
	if (@FreezerID is not null) SET @ContID=null

	select 
	tRepository.FreezerBarcode		as FreezerBarcode,
	tRepository.FreezerBarcode		as FreezerLabel,
	tRepository.strFreezerName		as FreezerName,
	tRepository.FreezerNote			as FreezerNote,
	rfFreezerType.[name]			as FreezerType,
	tRepository.SubdivisionBarcode	as SubDivisionBarcode,
	tRepository.SubdivisionBarcode	as SubDivisionLabel,
	tRepository.SubdivisionName		as SubDivisionName,
	tRepository.SubdivisionNote		as SubDivisionNote,
	rfSubdivisionType.[name]		as SubDivisionType,
	tMaterial.strBarcode			as ContainerBarcode,
	tMaterial.idfMaterial			as ContainerID,
	tMaterial.strFieldBarcode		as FieldID,
	rfSpecimenType.[name]			as MaterialType,
	tRepository.[Path]				as [Path]

	from		dbo.fn_RepositorySchema (@LangID, @FreezerID, @ContID) as tRepository
	 left join	dbo.tlbMaterial	as tMaterial
			on	tMaterial.idfSubdivision = tRepository.idfSubdivision
			and	tMaterial.intRowStatus = 0	   
	 left join	dbo.fnReferenceRepair(@LangID, 19000087/*rftSpecimenType*/) rfSpecimenType
			on	tMaterial.idfsSampleType = rfSpecimenType.idfsReference
	 left join  fnReference(@LangID,19000092) rfFreezerType 
			on  rfFreezerType.idfsReference = tRepository.idfsStorageType
	 left join	fnReference(@LangID,19000093) rfSubdivisionType-- box or shelf			
			on  rfSubdivisionType.idfsReference = tRepository.idfsSubdivisionType

