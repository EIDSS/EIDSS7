
--##SUMMARY Deletes vet case object.
--##SUMMARY Can be called from VetCaseList/LivestockCaseDetail/AvianCaseDetail forms. In this case spVetCase_CanDelete
--##SUMMARY procedure should enable case deleting only if there is test/specimens related with case, case farm has no herds/animals
--##SUMMARY , and also no vaccinations and case log records exists.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 4.12.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spVetCase_Delete @ID

*/


CREATE         Proc [dbo].[spVetCase_Delete]
		@ID bigint --##PARAM  @ID - Vet case ID
As


DECLARE @FarmID BIGINT
DECLARE @idfObservation BIGINT

SELECT	@FarmID = idfFarm
		,@idfObservation = idfObservation
FROM	tlbVetCase
WHERE 
		idfVetCase=@ID 

DELETE tlbVetCaseLog WHERE idfVetCase = @ID
DELETE tlbVaccination WHERE idfVetCase = @ID

declare @sample_del bigint
declare Sample_Cursor Cursor local read_only forward_only for
	select		idfMaterial
	from		tlbMaterial
	where		tlbMaterial.idfVetCase=@ID
				and tlbMaterial.intRowStatus = 0
open Sample_Cursor
fetch next from Sample_Cursor into @sample_del
while @@FETCH_STATUS <>-1
begin
	exec spLabSample_Delete @sample_del
	fetch next from Sample_Cursor into @sample_del
end
close Sample_Cursor
deallocate Sample_Cursor

delete from tlbVetCaseDisplayDiagnosis where idfVetCase = @ID

delete from tflVetCaseFiltered where idfVetCase = @ID
DELETE tlbVetCase WHERE idfVetCase = @ID


EXEC spFarm_Delete @FarmID
EXEC spObservation_Delete @idfObservation
