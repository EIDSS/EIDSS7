

--##SUMMARY Select data for Human Notification form for Tanzania republicreport.
--##REMARKS Author: 
--##REMARKS Create 

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:


exec spRepHumTanzaniaSpecimen 'en', 12558370000000

*/

create  Procedure [dbo].[spRepHumTanzaniaSpecimen]
	(
		@LangID as nvarchar(10),
		@ObjID	as bigint
	)
AS	

	declare @Result table
	(
		idfsSample bigint primary key not null,
		strSampleType nvarchar(200) not null, --31
		datCollectionDate  date null, --32
		strSentToOrganization nvarchar(200) null, --33
		datSentDate  date null --34
	)
	
	insert into @Result
	(
		idfsSample,
		strSampleType,
		datCollectionDate,
		strSentToOrganization,
		datSentDate	
	)
	select		m.idfMaterial as idfsSample, 
				[ref_sflHCSample_SampleType].[name] as strSampleType,
				m.datFieldCollectionDate as datCollectionDate, 
				[ref_sflHCSample_SentToOrganization].[name] as strSentToOrganization,
				m.datFieldSentDate as [sflHCSample_SentDate]
				

	from 
	( 
		tlbHumanCase hc 
		inner join	tlbHuman h_hc 
		on			h_hc.idfHuman = hc.idfHuman 
					and h_hc.intRowStatus = 0 
		inner join ( tlbMaterial m 
			left join tlbHuman h_m
			on h_m.idfHuman = m.idfHuman
			and h_m.intRowStatus = 0

			--left join tlbAccessionIN aIn_m 
			--on aIn_m.idfMaterial = m.idfMaterial
			--and aIn_m.intRowStatus = 0
			
			left join tlbOffice m_sent_to_o 
			ON m_sent_to_o.idfOffice = m.idfSendToOffice 
		) 
		ON h_hc.idfHuman = m.idfHuman AND m.intRowStatus = 0 
	) 
	
	left join	fnReferenceRepair(@LangID, 19000087) [ref_sflHCSample_SampleType] 
	on			[ref_sflHCSample_SampleType].idfsReference = m.idfsSampleType
	left join	fnReferenceRepair(@LangID, 19000046) [ref_sflHCSample_SentToOrganization] 
	on			[ref_sflHCSample_SentToOrganization].idfsReference = m_sent_to_o.idfsOfficeName




	where		hc.intRowStatus = 0 and hc.idfHumanCase = @ObjID


	select * from @Result


