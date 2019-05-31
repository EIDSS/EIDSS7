

--##SUMMARY Saves links from selected samples to survivor de-duplicated case 
--##SUMMARY and deletes other samples related to cases-candidates for de-duplication.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 18.08.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@SurvivorID			bigint
declare	@SupersededID		bigint
declare	@SurvivorPartyID	bigint
declare	@SupersededPartyID	bigint
declare	@MaterialID			bigint
declare	@AddToSurvivorCase	bit


exec spHumanCaseDeduplicationMaterial_Post 
	 @SurvivorID		
	,@SupersededID		
	,@SurvivorPartyID	
	,@SupersededPartyID	
	,@MaterialID		
	,@AddToSurvivorCase	

*/


CREATE	procedure	[dbo].[spHumanCaseDeduplicationMaterial_Post]
(	
	 @SurvivorID		bigint	--##PARAM @SurvivorID Id of the survivor case
	,@SupersededID		bigint	--##PARAM @SupersededID Id of the superseded case
	,@SurvivorPartyID	bigint	--##PARAM @SurvivorPartyID Id of the survivor patient
	,@SupersededPartyID	bigint	--##PARAM @SupersededPartyID Id of the superseded patient
	,@MaterialID		bigint	--##PARAM @MaterialID Sample Id
	,@AddToSurvivorCase	bit		--##PARAM @AddToSurvivorCase Flag that determines whether to update or delete sample
)
as

if	exists	(
		select		*
		from		tlbMaterial
		where		tlbMaterial.intRowStatus = 0
					and	tlbMaterial.idfMaterial = @MaterialID
					AND (
							(tlbMaterial.idfHumanCase = @SurvivorID AND tlbMaterial.idfHuman = @SurvivorPartyID) 
							OR (tlbMaterial.idfHumanCase = @SupersededID AND tlbMaterial.idfHuman = @SupersededPartyID)
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
	and exists	(
			select		*
			from		tlbHumanCase
			where		tlbHumanCase.intRowStatus = 0
						AND (	tlbHumanCase.idfHumanCase = @SurvivorID
							and tlbHumanCase.idfHuman = @SurvivorPartyID
						)
				)
	and (@AddToSurvivorCase is not null)
begin
	if (@AddToSurvivorCase = 0)
	begin
		-- Delete samples and test that user didn't select

		-- Select a list of samples for deletion
		declare	@tlbMaterial_del	table (idfMaterial bigint not null primary key)

		insert into	@tlbMaterial_del	(idfMaterial)
		values	(@MaterialID)

		-- Select child samples for deletion 
		declare	@GoOn		int
		set @GoOn = 1
		declare	@RootGoOn	int
		set	@RootGoOn = 0

		while	@GoOn > 0
		begin
			insert into	@tlbMaterial_del	(idfMaterial)
			select distinct
						tlbMaterial.idfMaterial
			from		tlbMaterial
			inner join	@tlbMaterial_del tlbMaterial_del
			on			tlbMaterial_del.idfMaterial = tlbMaterial.idfRootMaterial
			left join	@tlbMaterial_del tlbMaterial_del_ex
			on			tlbMaterial_del_ex.idfMaterial = tlbMaterial.idfMaterial
			where		tlbMaterial_del_ex.idfMaterial is null

			set	@RootGoOn = @@rowcount

			insert into	@tlbMaterial_del	(idfMaterial)
			select distinct
						tlbMaterial.idfMaterial
			from		tlbMaterial
			inner join	@tlbMaterial_del tlbMaterial_del
			on			tlbMaterial_del.idfMaterial = tlbMaterial.idfParentMaterial
			left join	@tlbMaterial_del tlbMaterial_del_ex
			on			tlbMaterial_del_ex.idfMaterial = tlbMaterial.idfMaterial
			where		tlbMaterial_del_ex.idfMaterial is null

			set	@GoOn = @@rowcount
			set	@GoOn = @GoOn + @RootGoOn
		end

		declare	@tlbTesting_del		table (idfTesting bigint not null primary key)

		-- Select tests of containers marked for deletion
		insert into	@tlbTesting_del	(idfTesting)
		select distinct
					tlbTesting.idfTesting
		from		tlbTesting
		inner join	@tlbMaterial_del tlbMaterial_del
		on			tlbMaterial_del.idfMaterial = tlbTesting.idfMaterial

		-- Delete from related tables

		delete		ap
		from		tlbActivityParameters ap
		inner join	tlbTesting
		on			tlbTesting.idfObservation = ap.idfObservation
		inner join	@tlbTesting_del tlbTesting_del
		on			tlbTesting_del.idfTesting = tlbTesting.idfTesting


		delete		o
		from		tlbObservation o
		inner join	tlbTesting
		on			tlbTesting.idfObservation = o.idfObservation
		inner join	@tlbTesting_del tlbTesting_del
		on			tlbTesting_del.idfTesting = tlbTesting.idfTesting

		delete		tv
		from		tlbTestValidation tv
		inner join	@tlbTesting_del tlbTesting_del
		on			tlbTesting_del.idfTesting = tv.idfTesting

		delete		tOutCL
		from		tlbTransferOutMaterial tOutCL
		inner join	@tlbMaterial_del tlbMaterial_del
		on			tlbMaterial_del.idfMaterial = tOutCL.idfMaterial

		-- Delete tests, containers and samples
		delete		t
		from		tlbTesting t
		inner join	@tlbTesting_del tlbTesting_del
		on			tlbTesting_del.idfTesting = t.idfTesting


		delete		m
		from		tlbMaterial m
		inner join	@tlbMaterial_del tlbMaterial_del
		on			tlbMaterial_del.idfMaterial = m.idfMaterial
		
	end
	else begin
		-- Updates links from samples and related teststo survivor patient and case


		update		m
		set			m.idfHumanCase = @SurvivorID
					, m.idfHuman = @SurvivorPartyID
		from		tlbMaterial m
		where		m.intRowStatus = 0
					and	m.idfMaterial = @MaterialID
					and m.idfHumanCase = @SupersededID 
					and m.idfHuman = @SupersededPartyID


		update		hc_survivor
		set			hc_survivor.idfsYNSpecimenCollected = 10100001	-- Yes
		from		tlbHumanCase hc_survivor
		where		hc_survivor.idfHumanCase = @SurvivorID
					and IsNull(hc_survivor.idfsYNSpecimenCollected, 10100003)	-- Unknown
						<> 10100001	-- Yes


	end
end


