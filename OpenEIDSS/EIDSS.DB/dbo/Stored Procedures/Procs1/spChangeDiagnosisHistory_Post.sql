

--##SUMMARY Saves information about change of diagnosis.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 19.08.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@idfChangeDiagnosisHistory	bigint
declare	@idfHumanCase				bigint
declare	@idfUserID					bigint
declare	@idfsPreviousDiagnosis		bigint
declare	@idfsCurrentDiagnosis		bigint
declare	@datChangedDate				datetime
declare	@idfsChangeDiagnosisReason 					nvarchar(2000)

exec spChangeDiagnosisHistory_Post 
		 @idfContactedCasePerson
		,@idfHumanCase
		,@idfUserID
		,@idfsPreviousDiagnosis
		,@idfsCurrentDiagnosis
		,@datChangedDate
		,@idfsChangeDiagnosisReason 

*/

create	procedure	spChangeDiagnosisHistory_Post
(	 @idfChangeDiagnosisHistory	bigint			--##PARAM @idfChangeDiagnosisHistory Diagnosis change Id
	,@idfHumanCase				bigint			--##PARAM @idfHumanCase Id of the human case with changed diagnosis (reference to tlbHumanCase)
	,@idfPerson					bigint			--##PARAM @idfPerson Id of employee who changed diagnosi (reference to tlbPerson)
	,@idfsPreviousDiagnosis		bigint			--##PARAM @idfsPreviousDiagnosis Id of previous diagnosis (reference to trtDiagnosis -> trtBaseReference with Type rftDiagnosis (19000019))
	,@idfsCurrentDiagnosis		bigint			--##PARAM @idfsCurrentDiagnosis Id of new diagnosis (reference to trtDiagnosis -> trtBaseReference with Type rftDiagnosis (19000019))
	,@datChangedDate			datetime		--##PARAM @datChangedDate Date of diagnosis change
	,@idfsChangeDiagnosisReason bigint			--##PARAM @idfsChangeDiagnosisReason  Reason for diagnosis change
)
as

-- Update reference parameters related to tlbChangeDiagnosisHistory
if not exists	(
	select		*
	from		trtBaseReference
	inner join	trtDiagnosis
	on			trtDiagnosis.idfsDiagnosis = trtBaseReference.idfsBaseReference
	where		trtBaseReference.idfsBaseReference = @idfsPreviousDiagnosis
				and trtBaseReference.idfsReferenceType = 19000019	-- rftDiagnosis
				and trtBaseReference.intRowStatus = 0
				)
begin
	set @idfsPreviousDiagnosis = null
end

if not exists	(
	select		*
	from		trtBaseReference
	inner join	trtDiagnosis
	on			trtDiagnosis.idfsDiagnosis = trtBaseReference.idfsBaseReference
	where		trtBaseReference.idfsBaseReference = @idfsCurrentDiagnosis
				and trtBaseReference.idfsReferenceType = 19000019	-- rftDiagnosis
				and trtBaseReference.intRowStatus = 0
				)
begin
	set @idfsCurrentDiagnosis = null
end

if not exists	(
	select		*
	from		tlbHumanCase HumanCase
	where		HumanCase.idfHumanCase = @idfHumanCase
				AND HumanCase.intRowStatus = 0
				)
begin
	set @idfHumanCase = null
end

if not exists	(
	select		*
	from		tlbPerson
	where		idfPerson = @idfPerson
				and intRowStatus = 0
				)
begin
	set @idfPerson = null
end

-- Post tlbChangeDiagnosisHistory
if	@idfHumanCase is not null
	and @idfPerson is not null
	and @datChangedDate is not null
	and @idfsChangeDiagnosisReason  is not null
begin
	if	exists	(
			select	*
			from	tlbChangeDiagnosisHistory
			where	idfChangeDiagnosisHistory = @idfChangeDiagnosisHistory
				)
	begin
		update	tlbChangeDiagnosisHistory
		set		idfHumanCase			=	@idfHumanCase,
				idfPerson				=	@idfPerson,
				idfsPreviousDiagnosis	=	@idfsPreviousDiagnosis,
				idfsCurrentDiagnosis	=	@idfsCurrentDiagnosis,
				datChangedDate			=	@datChangedDate,
				idfsChangeDiagnosisReason 	=	@idfsChangeDiagnosisReason 

		where	idfChangeDiagnosisHistory = @idfChangeDiagnosisHistory
	end
	else begin
		insert into	tlbChangeDiagnosisHistory
		(	idfChangeDiagnosisHistory,
			idfHumanCase,
			idfPerson,
			idfsPreviousDiagnosis,
			idfsCurrentDiagnosis,
			datChangedDate,
			idfsChangeDiagnosisReason,
			strReason
		)
		values
		(	@idfChangeDiagnosisHistory,
			@idfHumanCase,
			@idfPerson,
			@idfsPreviousDiagnosis,
			@idfsCurrentDiagnosis,
			@datChangedDate,
			@idfsChangeDiagnosisReason,
			N''
		)
	end
end


