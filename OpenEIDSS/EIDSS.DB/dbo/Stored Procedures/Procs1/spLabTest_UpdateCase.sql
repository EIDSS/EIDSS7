
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

CREATE PROCEDURE [dbo].[spLabTest_UpdateCase]
	@idfTesting bigint 
AS
	--update idfsYNTestsConducted in related cases if all linked lab tests are completed
	Declare @idfHumanCase bigint
	Declare @idfVetCase bigint
	select 
		@idfHumanCase = hc.idfHumanCase
		,@idfVetCase = vc.idfVetCase
	from tlbMaterial m
	inner join tlbTesting t on 
		m.idfMaterial = t.idfMaterial
	left join tlbHumanCase hc on 
		m.idfHumanCase = hc.idfHumanCase
		and hc.intRowStatus = 0
		and isnull(hc.idfsYNTestsConducted,0) <> 10100001
	left join tlbVetCase vc on 
		m.idfVetCase = vc.idfVetCase
		and vc.intRowStatus = 0
		and isnull(vc.idfsYNTestsConducted,0) <> 10100001
	where
		t.idfTesting=@idfTesting
		and isnull(t.blnNonLaboratoryTest,0) = 0


	if(not @idfVetCase is null )
			if (not exists (select * from tlbTesting t --all tests are completed
				inner join tlbMaterial m on 
					t.idfMaterial = m.idfMaterial
				where 
					(t.idfsTestStatus is null or t.idfsTestStatus not in (10001001, 10001006)) --completed or amended
					and t.intRowStatus = 0
					and isnull(t.blnNonLaboratoryTest,0) = 0
					and m.idfVetCase = @idfVetCase
				))
			begin
				update tlbVetCase
				set 
					idfsYNTestsConducted = 10100001 --Yes
				where idfVetCase = @idfVetCase
			end

	if(not @idfHumanCase is null )
			if (not exists (select * from tlbTesting t --all tests are completed
				inner join tlbMaterial m on 
					t.idfMaterial = m.idfMaterial
				where 
					(t.idfsTestStatus is null or t.idfsTestStatus not in (10001001, 10001006)) --completed or amended
					and t.intRowStatus = 0
					and isnull(t.blnNonLaboratoryTest,0) = 0
					and m.idfHumanCase = @idfHumanCase
				))
			begin
				update tlbHumanCase
				set 
					idfsYNTestsConducted = 10100001 --Yes
				where idfHumanCase = @idfHumanCase
			end

RETURN 0
