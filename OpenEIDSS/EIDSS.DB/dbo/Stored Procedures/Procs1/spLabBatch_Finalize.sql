
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013
 
create proc [dbo].[spLabBatch_Finalize]
	@idfBatchTest bigint
as 
 -- 1. Close tests of batch - Set status - Complite
	update	tlbBatchTest
	set		idfsBatchStatus=10001001
	where	idfBatchTest=@idfBatchTest

	update	tlbTesting 
	set		
		idfsTestStatus=10001001,
		datStartedDate = b.datPerformedDate,
		datConcludedDate = b.datValidatedDate,
		idfResultEnteredByOffice =ISNULL(t.idfResultEnteredByOffice, b.idfResultEnteredByOffice),
		idfResultEnteredByPerson = ISNULL(t.idfResultEnteredByPerson, b.idfResultEnteredByPerson),
		idfTestedByOffice = b.idfPerformedByOffice,
		idfTestedByPerson = idfPerformedByPerson,
		idfValidatedByOffice = b.idfValidatedByOffice,
		idfValidatedByPerson = b.idfValidatedByPerson
	from tlbTesting t
		inner join tlbBatchTest b
		on t.idfBatchTest = b.idfBatchTest 
	where	t.idfBatchTest=@idfBatchTest 
			and t.intRowStatus = 0
			and b.intRowStatus = 0

	UPDATE tlbHumanCase 
		SET idfsYNTestsConducted = 10100001 --Yes
	WHERE idfHumanCase IN (
		select 
			hc.idfHumanCase
		from tlbMaterial m
		inner join tlbTesting t on 
			m.idfMaterial = t.idfMaterial
			and m.intRowStatus  = 0
		inner join tlbHumanCase hc on 
			m.idfHumanCase = hc.idfHumanCase
			and hc.intRowStatus = 0
			and isnull(hc.idfsYNTestsConducted,0) <> 10100001
		where
			t.idfBatchTest=@idfBatchTest
			and t.intRowStatus = 0
			--and isnull(t.blnNonLaboratoryTest,0) = 0
		)
    IF @@ROWCOUNT = 0
	BEGIN
		UPDATE tlbVetCase 
			SET idfsYNTestsConducted = 10100001 --Yes
		WHERE idfVetCase IN (
			select 
				vc.idfVetCase 
			from tlbMaterial m
			inner join tlbTesting t on 
				m.idfMaterial = t.idfMaterial
				and m.intRowStatus  = 0
			inner join tlbVetCase vc on 
				m.idfVetCase = vc.idfVetCase
				and vc.intRowStatus = 0
				and isnull(vc.idfsYNTestsConducted,0) <> 10100001
			where
				t.idfBatchTest=@idfBatchTest
				and t.intRowStatus = 0
				--and isnull(t.blnNonLaboratoryTest,0) = 0
			)
	END



