


 

--##SUMMARY Creates case for specified farm in monitoring session
--##SUMMARY During case creation it 
--##SUMMARY 1. Creates case itslef
--##SUMMARY 2. Links farm (including farm structure tree) to the case
--##SUMMARY 3. Links Animals/samples/tests with positive result to the case
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 02.08.2010

--##RETURNS 0 - if case is created successfully
--##RETURNS 1 - source farm doesn't exists
--##RETURNS 2 - case is already created for this farm and monitoring session
--##RETURNS 3 - user hasn't permissions for create vetcase
/*
--Example of a call of procedure:
DECLARE @idfFarm bigint
declare @idfCase bigint

EXECUTE spASSession_CreateCaseForDiagnosis 
	@idfFarm
	,@idfCase OUTPUT
Print @idfCase
*/

CREATE            Proc	spASSession_CreateCaseForDiagnosis
		@idfFarm bigint
		,@idfDiagnosis bigint
		,@idfMonitoringSession bigint
		,@idfsContolMeasureTemplate bigint
		,@idfsFarmEPITemplate bigint
		,@idfsSpeciesCSTemplate bigint
		,@idfsAnimalCSTemplate bigint
		,@idfPersonEnteredBy bigint
		,@idfTestValidation bigint
		,@idfCase bigint OUTPUT
As
--TODO insert check that case for this farm and diagnosis was created already
--SELECT @idfCase = idfCase
--from tlbParty 
--	inner join tlbFarm as sourceFarm on 
--		sourceFarm.idfFarm = tlbParty.idfParty
--	inner join tlbFarm as targetFarm on 
--		targetFarm.strFarmCode = sourceFarm.strFarmCode
--WHERE 
--	sourceFarm.idfFarm = @idfFarm 
--	and tlbParty.intRowStatus = 0
--	and 
--Create farm copy for case
--SELECT @idfCase = idfCase 
--FROM tlbCase 
--WHERE 
--	idfParentMonitoringSession = @idfMonitoringSession
--	AND intRowStatus = 0
	
if not @idfCase is null
 	return 2 -- Case is already created for this farm
-- Create case itself
DECLARE @idfTargetFarm bigint
DECLARE @idfObservation bigint
DECLARE @datEnteredDate datetime
DECLARE @idfsSite bigint
DECLARE @idfSpecies bigint
DECLARE @ret int

EXECUTE spFarm_CopyNormalToNormal
   @idfFarm
  ,@idfTargetFarm OUTPUT

EXEC spsysGetNewID @idfObservation OUTPUT
EXEC spObservation_Post	@idfObservation, @idfsFarmEPITemplate
UPDATE tlbFarm
SET idfObservation = @idfObservation
WHERE idfFarm = @idfTargetFarm

DECLARE crSpecies CURSOR For
Select	
	--tlbSpecies.idfSpecies,
	tlbSpecies.idfObservation
From	tlbSpecies
INNER JOIN tlbHerd ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd
	and tlbHerd.intRowStatus = 0
Where	    
	tlbHerd.idfFarm = @idfTargetFarm
FOR UPDATE OF tlbSpecies.idfObservation

OPEN crSpecies
Fetch Next From crSpecies 
While @@FETCH_STATUS = 0 
Begin
	EXEC spsysGetNewID @idfObservation OUTPUT
	EXEC spObservation_Post	@idfObservation, @idfsSpeciesCSTemplate
	UPDATE tlbSpecies
	SET idfObservation = @idfObservation
	WHERE CURRENT OF crSpecies
	Fetch Next From crSpecies 
End --crSpecies cursor end
Close crSpecies
Deallocate crSpecies



EXEC spsysGetNewID @idfCase OUTPUT
EXEC spsysGetNewID @idfObservation OUTPUT

SET @datEnteredDate = GETDATE()
SET @idfsSite = dbo.fnSiteID()
DECLARE @datValidation DATETIME
Select @datValidation = datValidationDate from tlbTestValidation
where idfTestValidation = @idfTestValidation

EXECUTE @ret = spVetCase_Post 
   @idfCase
  ,NULL --@idfOutbreak
  ,NULL --@@idfsCaseClassification
  ,10109001 --in progress @idfsCaseProgressStatus
  ,10012003-- @idfsCaseType
  ,@datEnteredDate
  ,NULL --@strCaseID
  ,NULL --@uidOfflineCaseID
  ,NULL --@idfsTentativeDiagnosis
  ,NULL --@idfsTentativeDiagnosis1
  ,NULL --@idfsTentativeDiagnosis2
  ,@idfDiagnosis --@idfsFinalDiagnosis
  ,NULL --@idfPersonInvestigatedBy
  ,@idfPersonEnteredBy --@idfPersonEnteredBy
  ,NULL --@idfPersonReportedBy
  ,@idfObservation
  ,@idfsContolMeasureTemplate
  ,@idfsSite
  ,NULL --@datReportDate
  ,NULL --@datAssignedDate
  ,NULL --@datInvestigationDate
  ,NULL --@datTentativeDiagnosisDate
  ,NULL --@datTentativeDiagnosis1Date
  ,NULL --@datTentativeDiagnosis2Date
  ,@datValidation --@datFinalDiagnosisDate
  ,NULL --@strSampleNotes
  ,NULL --@strTestNotes
  ,NULL --@strSummaryNotes
  ,NULL --@strClinicalNotes
  ,NULL --@strFieldAccessionID
  ,@idfTargetFarm --@idfFarm
  ,10100001	--@idfsYNTestsConducted			
  ,NULL --@idfReportedByOffice			
  ,NULL --@idfInvestigatedByOffice
  ,4578940000001		

UPDATE tlbVetCase 
	SET idfParentMonitoringSession = @idfMonitoringSession 
WHERE
	idfVetCase = @idfCase 
 

--create animals, samples and tests copy for diagnosis
declare @animals table
(
  idfAnimal bigint primary key,
  idfsAnimalGender  bigint,
  idfsAnimalAge bigint,
  strAnimalCode nvarchar(200) collate database_default,
  strName nvarchar(200) collate database_default,
  strColor nvarchar(200) collate database_default,
  idfAnimal_trg bigint,
  idfSpecies_trg bigint,
  idfObservation_trg bigint
)

--insert into [_params]
--(
--		idfFarm 
--		,idfDiagnosis 
--		,idfMonitoringSession 
--		,idfsContolMeasureTemplate 
--		,idfCase  
--		,idfTargetFarm 
--)
--values (
--		@idfFarm 
--		,@idfDiagnosis 
--		,@idfMonitoringSession 
--		,@idfsContolMeasureTemplate 
--		,@idfCase  
--		,@idfTargetFarm )

  

insert into @animals
(
  idfAnimal,
  idfsAnimalGender,
  idfsAnimalAge,
  strAnimalCode,
  strName,
  strColor,
  idfSpecies_trg,
  idfAnimal_trg
)
select distinct
  a_src.idfAnimal, 
  a_src.idfsAnimalGender, 
  a_src.idfsAnimalAge, 
  a_src.strAnimalCode, 
  a_src.strName, 
  a_src.strColor,
  s_trg.idfSpecies,
  a_trg.idfAnimal
from tlbAnimal a_src
  inner join  ( tlbMaterial m_src
        inner join tlbTesting t_src
        on t_src.idfMaterial = m_src.idfMaterial
        and t_src.intRowStatus = 0
       
        inner join tlbTestValidation tv_src
        on tv_src.idfTesting = t_src.idfTesting
        and tv_src.idfsDiagnosis = @idfDiagnosis
        and tv_src.idfsInterpretedStatus = 10104001
        and tv_src.intRowStatus = 0
  )      
  on m_src.idfAnimal = a_src.idfAnimal
  and m_src.intRowStatus = 0  
  
  inner join dbo.tlbSpecies s_src
  on s_src.idfSpecies = a_src.idfSpecies
  and s_src.intRowStatus = 0
  
  inner join tlbHerd h_src
  on h_src.idfHerd = s_src.idfHerd
  and h_src.intRowStatus = 0
  
  inner join tlbFarm f_src
  on f_src.idfFarm = h_src.idfFarm
  and f_src.idfFarm = @idfFarm
  and f_src.intRowStatus = 0
    
  inner join tlbHerd h_trg
  on h_trg.strHerdCode = h_src.strHerdCode
  and h_trg.idfFarm = @idfTargetFarm
  and h_trg.intRowStatus = 0
  
  inner join tlbSpecies s_trg
  on s_trg.idfsSpeciesType = s_src.idfsSpeciesType
  and s_trg.idfHerd = h_trg.idfHerd
  and s_trg.intRowStatus = 0
   
  left join tlbAnimal a_trg
  on a_trg.idfSpecies = s_trg.idfSpecies
  and a_src.strAnimalCode = a_trg.strAnimalCode
  and a_trg.intRowStatus = 0
  
where a_src.intRowStatus = 0  
  
 
delete from	tstNewID

insert into	tstNewID
(	idfTable,
	idfKey1
)
select		75460000000,--	tlbAnimal
          a.idfAnimal
from	@animals  a
WHERE a.idfAnimal_trg is null

update		a
set			a.idfAnimal_trg = nID.[NewID]
from		@animals  a
inner join	tstNewID nID
on			nID.idfKey1 = a.idfAnimal
WHERE a.idfAnimal_trg IS NULL 

delete from	tstNewID
insert into	tstNewID
(	idfTable,
	idfKey1
)
select		75740000000,--	tlbObservation
          a.idfAnimal
from	@animals  a
WHERE a.idfObservation_trg is null

update		a
set			a.idfObservation_trg = nID.[NewID]
from		@animals  a
inner join	tstNewID nID
on			nID.idfKey1 = a.idfAnimal
WHERE a.idfObservation_trg IS NULL

delete from	tstNewID

--create observations

declare crAnimal cursor local static for
select idfObservation_trg
from @animals
open crAnimal
fetch next from crAnimal into @idfObservation
while @@FETCH_STATUS = 0
begin
  insert into tlbObservation(idfObservation,idfsFormTemplate)
  values(@idfObservation, @idfsAnimalCSTemplate)
  
  fetch next from crAnimal into @idfObservation
end


close crAnimal
deallocate crAnimal

--insert into [_animals]
--(
--  idfAnimal,
--  idfsAnimalGender,
--  idfsAnimalAge,
--  strAnimalCode,
--  strName,
--  strColor,
--  idfAnimal_trg,
--  idfSpecies_trg)
--select  
--  idfAnimal,
--  idfsAnimalGender,
--  idfsAnimalAge,
--  strAnimalCode,
--  strName,
--  strColor,
--  idfAnimal_trg,
--  idfSpecies_trg
--from @animals


insert into tlbAnimal
(
  idfAnimal,
  idfsAnimalGender,
  idfsAnimalAge,
  strAnimalCode,
  strName,
  strColor,
  idfSpecies,
  idfObservation
)
select 
  a.idfAnimal_trg,
  a.idfsAnimalGender,
  a.idfsAnimalAge,
  a.strAnimalCode,
  a.strName,
  a.strColor,
  a.idfSpecies_trg,
  a.idfObservation_trg
from @animals  a
  left join tlbAnimal a1
  on a.idfAnimal_trg = a1.idfAnimal
  and a1.intRowStatus = 0
where a1.idfAnimal is null

declare @material table
(
idfMaterial bigint primary key,
idfMaterial_trg bigint
)

insert into @material
(
  idfMaterial
)
select
  distinct m.idfMaterial
from   tlbMaterial m
  inner join @animals a
  on a.idfAnimal = m.idfAnimal
  
  inner join tlbTesting t_src
  on t_src.idfMaterial = m.idfMaterial
  --and t_src.idfsDiagnosis = @idfDiagnosis  
  and t_src.intRowStatus = 0
where m.intRowStatus = 0

      
delete from	tstNewID

insert into	tstNewID
(	idfTable,
	idfKey1
)
select		75620000000,--	tlbMaterial
          m.idfMaterial
from	@material  m
WHERE m.idfMaterial_trg is null

update		m
set			m.idfMaterial_trg = nID.[NewID]
from		@material  m
inner join	tstNewID nID
on			nID.idfKey1 = m.idfMaterial
WHERE m.idfMaterial_trg IS NULL 

delete from	tstNewID

declare @strCaseID nvarchar(200)
select @strCaseID = strCaseID from tlbVetCase where idfVetCase = @idfCase


--insert into [_material]
--(
--idfMaterial_trg,
--idfMaterial)
--select
--idfMaterial_trg,
--idfMaterial
--from @material

insert into tlbMaterial
(
  idfMaterial,
  idfRootMaterial,
  idfParentMaterial,
  idfsSampleType,
  idfAnimal,
  idfVetCase,
  strCalculatedCaseID,
  idfFieldCollectedByPerson,
  idfFieldCollectedByOffice,
  datFieldCollectionDate,
  datFieldSentDate,
  strFieldBarcode,
  idfSubdivision,
  idfsSampleStatus,
  idfInDepartment,
  idfDestroyedByPerson,
  datAccession,
  datEnteringDate,
  datDestructionDate,
  strBarcode,
  strNote,
  idfsSite,
  idfSendToOffice,
  idfsAccessionCondition,
  blnReadOnly
)
select
  m_trg.idfMaterial_trg,
  m_src.idfRootMaterial,
  m_src.idfParentMaterial,
  m_src.idfsSampleType,
  a_trg.idfAnimal_trg,
  @idfCase,
  @strCaseID,
  m_src.idfFieldCollectedByPerson,
  m_src.idfFieldCollectedByOffice,
  m_src.datFieldCollectionDate,
  m_src.datFieldSentDate,
  m_src.strFieldBarcode,
  m_src.idfSubdivision,
  m_src.idfsSampleStatus,
  m_src.idfInDepartment,
  m_src.idfDestroyedByPerson,
  m_src.datAccession,
  m_src.datEnteringDate,
  m_src.datDestructionDate,
  m_src.strBarcode,
  m_src.strNote,
  m_src.idfsSite,
  m_src.idfSendToOffice,
  m_src.idfsAccessionCondition,
  1
from tlbMaterial m_src
  inner join @material m_trg
  on m_src.idfMaterial = m_trg.idfMaterial
  
  inner join @animals a_trg
  on a_trg.idfAnimal = m_src.idfAnimal



declare @testing table
(
idfTesting bigint primary key,
idfTesting_trg bigint,
idfsFormTemplate bigint,
idfObservation_trg bigint
)

insert into @testing
(
  idfTesting,
  idfsFormTemplate
)
select
  t.idfTesting,
  obs.idfsFormTemplate
from   tlbTesting t
  inner join tlbMaterial m
  on m.idfMaterial = t.idfMaterial
  and m.intRowStatus = 0
  
  inner join tlbObservation obs
  on obs.idfObservation = t.idfObservation
  and obs.intRowStatus = 0
    
  inner join @animals a
  on a.idfAnimal = m.idfAnimal
where t.intRowStatus = 0 --and
      --t.idfsDiagnosis = @idfDiagnosis  

      
delete from	tstNewID

insert into	tstNewID
(	idfTable,
	idfKey1
)
select		75740000000,--	tlbTesting
          t.idfTesting
from	@testing  t
WHERE t.idfTesting_trg is null

update		t
set			t.idfTesting_trg = nID.[NewID]
from		@testing  t
inner join	tstNewID nID
on			nID.idfKey1 = t.idfTesting
WHERE t.idfTesting_trg IS NULL 

delete from	tstNewID

insert into	tstNewID
(	idfTable,
	idfKey1
)
select		75740000000,--	tlbObservation
          t.idfTesting
from	@testing  t
WHERE t.idfObservation_trg is null

update		t
set			t.idfObservation_trg = nID.[NewID]
from		@testing  t
inner join	tstNewID nID
on			nID.idfKey1 = t.idfTesting
WHERE t.idfObservation_trg IS NULL 

delete from	tstNewID


--insert into[_testing]
--(
--idfTesting_trg,
--idfTesting)
--select
--idfTesting_trg,
--idfTesting
--from @testing


--create observations
declare @idfsFormTemplate bigint

declare cur cursor local static for
select idfObservation_trg, idfsFormTemplate
from @testing
open cur
fetch next from cur into @idfObservation, @idfsFormTemplate
while @@FETCH_STATUS = 0
begin
  insert into tlbObservation(idfObservation,idfsFormTemplate)
  values(@idfObservation ,@idfsFormTemplate)
  
  fetch next from cur into @idfObservation, @idfsFormTemplate
end


close cur
deallocate cur


insert into tlbTesting
(
  idfTesting, 
  idfsTestName, 
  idfsTestCategory, 
  idfsTestResult, 
  idfsTestStatus, 
  idfsDiagnosis, 
  idfMaterial, 
  idfObservation,
  intTestNumber, 
  strNote, 
  datStartedDate, 
  datConcludedDate, 
  idfTestedByOffice, 
  idfTestedByPerson, 
  idfResultEnteredByOffice, 
  idfResultEnteredByPerson, 
  idfValidatedByOffice, 
  idfValidatedByPerson, 
  blnReadOnly, 
  blnNonLaboratoryTest
)
select 
  t_trg.idfTesting_trg, 
  t.idfsTestName, 
  t.idfsTestCategory, 
  t.idfsTestResult, 
  t.idfsTestStatus, 
  t.idfsDiagnosis, 
  m_trg.idfMaterial_trg, 
  t.idfObservation,
  t.intTestNumber, 
  t.strNote, 
  t.datStartedDate, 
  t.datConcludedDate, 
  t.idfTestedByOffice, 
  t.idfTestedByPerson, 
  t.idfResultEnteredByOffice, 
  t.idfResultEnteredByPerson, 
  t.idfValidatedByOffice, 
  t.idfValidatedByPerson, 
  1, 
  t.blnNonLaboratoryTest

from tlbTesting t
  inner join @testing t_trg
  on t.idfTesting = t_trg.idfTesting
  
  inner join tlbMaterial m 
  on m.idfMaterial = t.idfMaterial
  and m.intRowStatus = 0
  
  inner join @material m_trg
  on m.idfMaterial = m_trg.idfMaterial





declare @testvalidation table
(
idfTestValidation bigint primary key,
idfTestValidation_trg bigint
)


insert into @testvalidation
(
  idfTestValidation
)
select 
  idfTestValidation
from tlbTestValidation tv
  inner join @testing t
  on t.idfTesting = tv.idfTesting
and tv.intRowStatus = 0  
  

delete from	tstNewID

insert into	tstNewID
(	idfTable,
	idfKey1
)
select		75750000000,--	tlbTestValidation
          tv.idfTestValidation
from	@testvalidation  tv
WHERE tv.idfTestValidation_trg is null

update		tv
set			tv.idfTestValidation_trg = nID.[NewID]
from		@testvalidation  tv
inner join	tstNewID nID
on			nID.idfKey1 = tv.idfTestValidation
WHERE tv.idfTestValidation_trg IS NULL 

delete from	tstNewID


insert into tlbTestValidation
(
  idfTestValidation, 
  idfsDiagnosis, 
  idfsInterpretedStatus, 
  idfValidatedByOffice, 
  idfValidatedByPerson, 
  idfInterpretedByOffice, 
  idfInterpretedByPerson, 
  idfTesting, 
  blnValidateStatus, 
  blnCaseCreated, 
  strValidateComment, 
  strInterpretedComment, 
  datValidationDate, 
  datInterpretationDate, 
  blnReadOnly
)
select
  tv_trg.idfTestValidation_trg, 
  tv.idfsDiagnosis, 
  tv.idfsInterpretedStatus, 
  tv.idfValidatedByOffice, 
  tv.idfValidatedByPerson, 
  tv.idfInterpretedByOffice, 
  tv.idfInterpretedByPerson, 
  t_trg.idfTesting_trg, 
  tv.blnValidateStatus, 
  tv.blnCaseCreated, 
  tv.strValidateComment, 
  tv.strInterpretedComment, 
  tv.datValidationDate, 
  tv.datInterpretationDate, 
  1
from tlbTestValidation tv
  inner join @testvalidation tv_trg
  on tv.idfTestValidation = tv_trg.idfTestValidation
  
  inner join @testing t_trg
  on t_trg.idfTesting = tv.idfTesting
where tv.intRowStatus = 0  
  
  
  
--create animals, samples and tests copy for diagnosis - end




if (@ret = -1)
	begin
		set @idfCase = NULL
	 	return 3 -- User hasn't permissions for create vetcase
	end

return 0



