

--##SUMMARY Replace required links from superseded case to survivor case for de-duplication.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 18.08.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@SurvivorID			bigint
declare	@SupersededID		bigint
declare	@SurvivorPartyID	bigint
declare	@SupersededPartyID	bigint


exec spHumanCaseDeduplicationLinks_Post 
	 @SurvivorID		
	,@SupersededID		
	,@SurvivorPartyID	
	,@SupersededPartyID	

*/


CREATE	procedure	[dbo].[spHumanCaseDeduplicationLinks_Post]
(	
	 @SurvivorID		bigint	--##PARAM @SurvivorID Id of the survivor case
	,@SupersededID		bigint	--##PARAM @SupersededID Id of the superseded case
	,@SurvivorPartyID	bigint	--##PARAM @SurvivorPartyID Id of the survivor patient
	,@SupersededPartyID	bigint	--##PARAM @SupersededPartyID Id of the superseded patient
)
as

if	exists	(
		select		*
		from		tlbHumanCase
		where		tlbHumanCase.intRowStatus = 0
					AND (	tlbHumanCase.idfHumanCase = @SurvivorID
						and tlbHumanCase.idfHuman = @SurvivorPartyID
					)
			)
	and exists	(
			select		*
			from		tlbHumanCase
			where		tlbHumanCase.intRowStatus = 0
						AND (	tlbHumanCase.idfHumanCase = @SupersededID
							and tlbHumanCase.idfHuman = @SupersededPartyID
						)
				)
begin
	-- Updates links to outbreak for survivor case if it is not included in any another outbreak
	update		hc_survivor
	set			hc_survivor.idfsYNRelatedToOutbreak = 10100001	-- Yes
	from		(
		tlbHumanCase hc_survivor
		left join	tlbOutbreak o_survivor
		on			o_survivor.idfOutbreak = hc_survivor.idfOutbreak
					and o_survivor.intRowStatus = 0
				)
	inner join	(
		tlbHumanCase hc_superseded
		inner join	tlbOutbreak o_superseded
		on			o_superseded.idfOutbreak = hc_superseded.idfOutbreak
					and o_superseded.intRowStatus = 0
				)
	on			hc_superseded.idfHumanCase = @SupersededID
	where		hc_survivor.idfHumanCase = @SurvivorID
				and o_survivor.idfOutbreak is null


	update		hc_survivor
	set			hc_survivor.idfOutbreak = o_superseded.idfOutbreak
	from		(
		tlbHumanCase hc_survivor
		left join	tlbOutbreak o_survivor
		on			o_survivor.idfOutbreak = hc_survivor.idfOutbreak
					and o_survivor.intRowStatus = 0
				)
	inner join	(
		tlbHumanCase hc_superseded
		inner join	tlbOutbreak o_superseded
		on			o_superseded.idfOutbreak = hc_superseded.idfOutbreak
					and o_superseded.intRowStatus = 0
				)
	on			hc_superseded.idfHumanCase = @SupersededID
	where		hc_survivor.idfHumanCase = @SurvivorID
				and o_survivor.idfOutbreak is null


	-- Updates links from contacts of superseded case to survivor case 
	-- if it doesn't include copies of corresponding root parties as patient or contacts
	update		ccp_superseded
	set			ccp_superseded.idfHumanCase = @SurvivorID
	from		tlbContactedCasePerson ccp_superseded
	
	INNER JOIN	tlbHuman contact_superseded
	ON			contact_superseded.idfHuman = ccp_superseded.idfHuman
				AND contact_superseded.intRowStatus = 0		
	LEFT JOIN	(
				tlbContactedCasePerson ccp_survivor
				INNER JOIN	tlbHuman contact_survivor
				ON			contact_survivor.idfHuman = ccp_survivor.idfHuman
							AND contact_survivor.intRowStatus = 0							
				INNER JOIN	(
							tlbHumanCase hcase_survivor	
							INNER JOIN	tlbHuman patient_survivor
							ON			patient_survivor.idfHuman = hcase_survivor.idfHuman
										AND patient_survivor.intRowStatus = 0
							)
				ON			hcase_survivor.idfHumanCase = ccp_survivor.idfHumanCase
				)
	ON			ccp_survivor.intRowStatus = 0
				AND ccp_survivor.idfHumanCase = @SurvivorID
				AND( contact_survivor.idfHumanActual = contact_superseded.idfHumanActual
				OR patient_survivor.idfHumanActual = contact_superseded.idfHumanActual)	

	where		ccp_superseded.intRowStatus = 0
				and ccp_superseded.idfHumanCase = @SupersededID
				and ccp_survivor.idfContactedCasePerson is null

	-- Mark superseded case as de-duplicated with survivor case
	update		hc
	set			hc.idfDeduplicationResultCase = @SurvivorID
	from		tlbHumanCase hc
	where		hc.idfHumanCase = @SupersededID
end


