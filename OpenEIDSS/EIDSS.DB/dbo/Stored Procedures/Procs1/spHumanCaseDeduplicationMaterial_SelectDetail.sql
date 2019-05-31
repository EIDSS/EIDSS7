

--##SUMMARY Selects samples data of two specified human cases (one of them is marked as survivor, 
--##SUMMARY and another case is marked as superseded).

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 01.03.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
declare	@SurvivorID		bigint
declare	@SupersededID	bigint
declare	@LangID			varchar(36)

execute	spHumanCaseDeduplicationMaterial_SelectDetail
	@SurvivorID,
	@SupersededID,
	@LangID
*/



CREATE procedure	[dbo].[spHumanCaseDeduplicationMaterial_SelectDetail]
(		 @SurvivorID	bigint		--##PARAM @SurvivorID Id of the survivor case
		,@SupersededID	bigint		--##PARAM @SupersededID Id of the superseded case
		,@LangID		varchar(36)	--##PARAM @LangID Language Id
)
as

-- 0 tlbMaterial
select		tlbMaterial.idfMaterial,
			case IsNull(tlbMaterial.idfHumanCase, -1)
				when @SurvivorID
					then 'Survivor'
				when @SupersededID
					then 'Superseded'
				else 'None'
			end as rowType,
			tlbMaterial.strFieldBarcode,
			tlbMaterial.idfsSampleType,
			SampleType.[name] as SampleType_Name,
			tlbMaterial.datFieldCollectionDate,
			tlbMaterial.datFieldSentDate,
			IsNull(Testing.TestQuantity, 0) as TestQuantity,
			case 
				when	IsNull(Testing.TestQuantity, 0) = 0 
						and IsNull(tlbMaterial.blnAccessioned, 0) = 0
					then	cast(0 as bit)
				else		cast(1 as bit)
			end as AddToSurvivorCase,
			case
				when	IsNull(tlbMaterial.blnAccessioned, 0) > 0 
					then	cast(0 as bit)
				else		cast(1 as bit)
			end as CanRemoveFromSurvivorCase
from		tlbMaterial
left join	fnReference(@LangID, 19000087) SampleType	-- rftSampleType
on			SampleType.idfsReference = tlbMaterial.idfsSampleType
left join	(
	select		idfMaterial, count(*) as TestQuantity
	from		tlbTesting
	where		intRowStatus = 0
	group by	idfMaterial
			)	Testing
on			Testing.idfMaterial = tlbMaterial.idfMaterial
where		tlbMaterial.intRowStatus = 0
			and (	tlbMaterial.idfHumanCase = @SurvivorID
					or tlbMaterial.idfHumanCase = @SupersededID)

