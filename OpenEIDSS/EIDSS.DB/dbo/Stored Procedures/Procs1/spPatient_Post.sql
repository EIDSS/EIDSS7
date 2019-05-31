

--##SUMMARY Saves information about the human (patient or farm owner).

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 23.01.2010

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 08.07.2011

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@idfHuman					bigint
declare	@idfRootHuman				bigint
declare	@idfCase					bigint
declare	@idfsOccupationType			bigint
declare	@idfsNationality			bigint
declare	@idfsHumanGender			bigint
declare	@idfCurrentResidenceAddress	bigint
declare	@idfEmployerAddress			bigint
declare	@idfRegistrationAddress		bigint
declare	@datDateofBirth				datetime
declare	@datDateOfDeath				datetime
declare	@strLastName				nvarchar(200)
declare	@strSecondName				nvarchar(200)
declare	@strFirstName				nvarchar(200)
declare	@strRegistrationPhone		nvarchar(200)
declare	@strEmployerName			nvarchar(200)
declare	@strHomePhone				nvarchar(200)
declare	@strWorkPhone				nvarchar(200)

exec spPatient_Post 
	 1
	,@idfRootHuman
	,@idfCase
	,@idfsOccupationType
	,@idfsNationality
	,@idfsHumanGender
	,@idfCurrentResidenceAddress
	,@idfEmployerAddress
	,@idfRegistrationAddress
	,@datDateofBirth
	,@datDateOfDeath
	,'AAA'
	,@strSecondName
	,@strFirstName
	,@strRegistrationPhone
	,@strEmployerName
	,@strHomePhone
	,@strWorkPhone
	
delete tlbHumanActual
from tlbHumanActual
inner join tlbHuman
	on tlbHumanActual.idfHumanActual = tlbHuman.idfHumanActual
	and tlbHuman.idfHuman = 1
	
delete tlbHuman
where tlbHuman.idfHuman = 1
*/


CREATE	procedure	[dbo].[spPatient_Post]
(	 @idfHuman						bigint			--##PARAM @idfHuman Human Id
	,@idfRootHuman					bigint	= null	--##PARAM @idfRootHuman Id of the original human (must be null for original human) (reference to tlbParty)
	,@idfCase						bigint	= null	--##PARAM @idfCase Id of the case, for which this human is a patient (reference to tlbCase); this parameter could be not specified
	,@idfsOccupationType			bigint			--##PARAM @idfsOccupationType Id of the occupation (reference to trtBaseReference with Type rftOccupationType (19000061))
	,@idfsNationality				bigint			--##PARAM @idfsNationality Id of the nationality or citizenship (reference to trtBaseReference with Type rftNationality (19000054))
	,@idfsHumanGender				bigint			--##PARAM @@idfsHumanGender Id of the patient sex (reference to trtBaseReference with Type rftHumanGender (19000043))
	,@idfCurrentResidenceAddress	bigint			--##PARAM @idfCurrentResidenceAddress Id of the current residence address (reference to tlbGeoLocation)
	,@idfEmployerAddress			bigint			--##PARAM @idfEmployerAddress Id of the address of the employer, children's facility, and school (reference to tlbGeoLocation)
	,@idfRegistrationAddress		bigint			--##PARAM @idfRegistrationAddress Id of the permanent residence address (reference to tlbGeoLocation)
	,@datDateofBirth				datetime		--##PARAM @datDateofBirth Date of birth
	,@datDateOfDeath				datetime		--##PARAM @datDateOfDeath Date of death
	,@strLastName					nvarchar(200)	--##PARAM @strLastName Last name of the patient
	,@strSecondName					nvarchar(200)	--##PARAM @strSecondName Second name of the patient
	,@strFirstName					nvarchar(200)	--##PARAM @strFirstName First name of the patient
	,@strRegistrationPhone			nvarchar(200)	--##PARAM @strRegistrationPhone Phone number of the permanent residence
	,@strEmployerName				nvarchar(200)	--##PARAM @strEmployerName name of employer
	,@strHomePhone					nvarchar(200)	--##PARAM @strHomePhone Phone number of the current residence
	,@strWorkPhone					nvarchar(200)	--##PARAM @strWorkPhone Phone number of the employer, children's facility, and school
	,@idfsPersonIDType				bigint			--##PARAM @idfsPersonIDType Type of document for personal ID
	,@strPersonID					nvarchar(100)	--##PARAM @strPersonID Personal ID
	,@datEnteredDate				datetime out
	,@datModificationDate			datetime out
	,@datModificationForArchiveDate	datetime = null

)
as

if @idfHuman is null
begin
	raiserror('Incorrect using of [spPatient_Post]',10,1)
	return
end

declare @uniquePersonID as int
-- Update RootParty, if RootParty not null
-- Party - ex.,  RootParty - ex. => Check. Do not change RootParty for existing Party. 
-- Party - ex.,  RootParty - not ex. => Create RootParty, update Party 
-- Party - not ex.,  RootParty - ex. => Create Party, update RootParty 
-- Party - not ex.,  RootParty - not ex. => Create both

declare @Check bigint
set @Check = null
declare @curDate datetime
set @curDate = getdate()
select @datModificationDate = @curDate
if @idfRootHuman is not null
begin
-- Check!!!
	--select @Check = idfHumanActual
	--from tlbHuman
	--where idfHuman = @idfHuman
	
	--if @idfRootHuman <> ISNULL(@Check,@idfRootHuman)
	--begin
	--DECLARE @err AS NVARCHAR(200)
	--	SET @err = 'Try to change RootHuman('+CAST(@idfRootHuman as NVARCHAR(20))+')  for existing Human ('+CAST(@Check as NVARCHAR(20))+') in [spPatient_Post]'
	--	raiserror(@err, 16,1)
	--	return
	--end
	EXEC @uniquePersonID = spPatient_ValidatePersonID @idfRootHuman, @strPersonID, @idfsPersonIDType
	IF @uniquePersonID = 0
		RAISERROR ('msgNotUniquePatientID', 16, 1)
-- check is new human
	declare @isNew bit
	if exists (select	* from	tlbHuman where	idfHuman = @idfHuman)
		select @isNew = 0
	else
	begin
		select @isNew = 1
		set @datEnteredDate = @curDate
	end
-- Post root tlbHuman
	declare	@idfRootCurrentResidenceAddress bigint
	declare	@idfRootEmployerAddress			bigint
	declare	@idfRootRegistrationAddress		bigint

	-- Get id for root idfCurrentResidenceAddress
	set	@idfRootCurrentResidenceAddress = null
	select		@idfRootCurrentResidenceAddress	= tlbHumanActual.idfCurrentResidenceAddress
	from		tlbHumanActual
	where		tlbHumanActual.idfHumanActual = @idfRootHuman

	if @idfRootCurrentResidenceAddress is null and not @idfCurrentResidenceAddress is null--and @isNew = 1
		exec spsysGetNewID @idfRootCurrentResidenceAddress output

	-- Get id for root idfEmployerAddress
	set	@idfRootEmployerAddress = null
	select		@idfRootEmployerAddress	= tlbHumanActual.idfEmployerAddress
	from		tlbHumanActual
	where		tlbHumanActual.idfHumanActual = @idfRootHuman

	if @idfRootEmployerAddress is null and not @idfEmployerAddress is null--and @isNew = 1
		exec spsysGetNewID @idfRootEmployerAddress output

	-- Get id for root idfRegistrationAddress
	set	@idfRootRegistrationAddress = null
	select		@idfRootRegistrationAddress	= tlbHumanActual.idfRegistrationAddress
	from		tlbHumanActual
	where		tlbHumanActual.idfHumanActual = @idfRootHuman

	if @idfRootRegistrationAddress is null and not @idfRegistrationAddress is null--and @isNew = 1
		exec spsysGetNewID @idfRootRegistrationAddress output

	-- Copy addresses for root human
	exec spGeoLocation_CreateCopy	
			@idfCurrentResidenceAddress,
			@idfRootCurrentResidenceAddress,
			1

	exec spGeoLocation_CreateCopy	
			@idfEmployerAddress,
			@idfRootEmployerAddress,
			1

	exec spGeoLocation_CreateCopy	
			@idfRegistrationAddress,
			@idfRootRegistrationAddress,
			1

	if exists	(
		select	*
		from	tlbHumanActual
		where	idfHumanActual = @idfRootHuman
				)
	begin
		update	tlbHumanActual
		set		idfsOccupationType			=	@idfsOccupationType,
				idfsNationality				=	@idfsNationality,
				idfsHumanGender				=	@idfsHumanGender,
				--idfCurrentResidenceAddress	=	@idfRootCurrentResidenceAddress,
				--idfEmployerAddress			=	@idfRootEmployerAddress,
				--idfRegistrationAddress		=	@idfRootRegistrationAddress,
				datDateofBirth				=	@datDateofBirth,
				datDateOfDeath				=	@datDateOfDeath,
				strLastName					=	@strLastName,
				strSecondName				=	@strSecondName,
				strFirstName				=	@strFirstName,
				strRegistrationPhone		=	@strRegistrationPhone,
				strEmployerName				=	@strEmployerName,
				strHomePhone				=	@strHomePhone,
				strWorkPhone				=	@strWorkPhone,				
				idfsPersonIDType			=	@idfsPersonIDType,
				strPersonID					=	@strPersonID
				,datModificationDate		=	@datModificationDate
		where	idfHumanActual = @idfRootHuman
	end
	else /*if (@isNew = 1)*/
	 begin
		insert into	tlbHumanActual
		(	idfHumanActual,
			idfsOccupationType,
			idfsNationality,
			idfsHumanGender,
			idfCurrentResidenceAddress,
			idfEmployerAddress,
			idfRegistrationAddress,
			datDateofBirth,
			datDateOfDeath,
			strLastName,
			strSecondName,
			strFirstName,
			strRegistrationPhone,
			strEmployerName,
			strHomePhone,
			strWorkPhone,
			idfsPersonIDType,
			strPersonID
			,datEnteredDate
			,datModificationDate
			
		)
		values
		(	@idfRootHuman,
			@idfsOccupationType,
			@idfsNationality,
			@idfsHumanGender,
			@idfRootCurrentResidenceAddress,
			@idfRootEmployerAddress,
			@idfRootRegistrationAddress,
			@datDateofBirth,
			@datDateOfDeath,
			@strLastName,
			@strSecondName,
			@strFirstName,
			@strRegistrationPhone,
			@strEmployerName,
			@strHomePhone,
			@strWorkPhone,
			@idfsPersonIDType,
			@strPersonID
			,@datEnteredDate
			,@datModificationDate
		)
	end


	-- Post tlbHuman
	if exists	(
		select	*
		from	tlbHuman
		where	idfHuman = @idfHuman
				)
	begin
		update	tlbHuman
		set		idfsOccupationType			=	@idfsOccupationType,
				idfsNationality				=	@idfsNationality,
				idfsHumanGender				=	@idfsHumanGender,
				idfCurrentResidenceAddress	=	@idfCurrentResidenceAddress,
				idfEmployerAddress			=	@idfEmployerAddress,
				idfRegistrationAddress		=	@idfRegistrationAddress,
				datDateofBirth				=	@datDateofBirth,
				datDateOfDeath				=	@datDateOfDeath,
				strLastName					=	@strLastName,
				strSecondName				=	@strSecondName,
				strFirstName				=	@strFirstName,
				strRegistrationPhone		=	@strRegistrationPhone,
				strEmployerName				=	@strEmployerName,
				strHomePhone				=	@strHomePhone,
				strWorkPhone				=	@strWorkPhone,
				idfHumanActual              =   @idfRootHuman,				
				idfsPersonIDType			=	@idfsPersonIDType,
				strPersonID					=	@strPersonID
				,datModificationDate		=	@datModificationDate
				,datModificationForArchiveDate = getdate()
		where	idfHuman = @idfHuman
	end
	else begin
		set @datEnteredDate = @curDate

		insert into	tlbHuman
		(	idfHuman,
			idfsOccupationType,
			idfsNationality,
			idfsHumanGender,
			idfCurrentResidenceAddress,
			idfEmployerAddress,
			idfRegistrationAddress,
			datDateofBirth,
			datDateOfDeath,
			strLastName,
			strSecondName,
			strFirstName,
			strRegistrationPhone,
			strEmployerName,
			strHomePhone,
			strWorkPhone,
			idfHumanActual,
			idfsPersonIDType,
			strPersonID
			,datEnteredDate
			,datModificationDate
			,datModificationForArchiveDate
		
		)
		values
		(	@idfHuman,
			@idfsOccupationType,
			@idfsNationality,
			@idfsHumanGender,
			@idfCurrentResidenceAddress,
			@idfEmployerAddress,
			@idfRegistrationAddress,
			@datDateofBirth,
			@datDateOfDeath,
			@strLastName,
			@strSecondName,
			@strFirstName,
			@strRegistrationPhone,
			@strEmployerName,
			@strHomePhone,
			@strWorkPhone,
			@idfRootHuman,
			@idfsPersonIDType,
			@strPersonID
			,@datEnteredDate
			,@datModificationDate
			,getdate()
		)
	end
end
else --@idfRootHuman is  null - we assume that root party is edited in this case
begin
	EXEC @uniquePersonID = spPatient_ValidatePersonID @idfHuman, @strPersonID, @idfsPersonIDType
	IF @uniquePersonID = 0
		RAISERROR ('msgNotUniquePatientID', 16, 1)
	-- Post tlbHumanActual
	if exists	(
		select	*
		from	tlbHumanActual
		where	idfHumanActual = @idfHuman
				)
	begin
		update	tlbHumanActual
		set		idfsOccupationType			=	@idfsOccupationType,
				idfsNationality				=	@idfsNationality,
				idfsHumanGender				=	@idfsHumanGender,
				idfCurrentResidenceAddress	=	@idfCurrentResidenceAddress,
				idfEmployerAddress			=	@idfEmployerAddress,
				idfRegistrationAddress		=	@idfRegistrationAddress,
				datDateofBirth				=	@datDateofBirth,
				datDateOfDeath				=	@datDateOfDeath,
				strLastName					=	@strLastName,
				strSecondName				=	@strSecondName,
				strFirstName				=	@strFirstName,
				strRegistrationPhone		=	@strRegistrationPhone,
				strEmployerName				=	@strEmployerName,
				strHomePhone				=	@strHomePhone,
				strWorkPhone				=	@strWorkPhone,
				idfsPersonIDType			=	@idfsPersonIDType,
				strPersonID					=	@strPersonID
				,datModificationDate		=	@datModificationDate

		where	idfHumanActual = @idfHuman
	end
	else begin
		set @datEnteredDate = @curDate
		insert into	tlbHumanActual
		(	idfHumanActual,
			idfsOccupationType,
			idfsNationality,
			idfsHumanGender,
			idfCurrentResidenceAddress,
			idfEmployerAddress,
			idfRegistrationAddress,
			datDateofBirth,
			datDateOfDeath,
			strLastName,
			strSecondName,
			strFirstName,
			strRegistrationPhone,
			strEmployerName,
			strHomePhone,
			strWorkPhone,
			idfsPersonIDType,
			strPersonID
			,datEnteredDate
			,datModificationDate
		)
		values
		(	@idfHuman,
			@idfsOccupationType,
			@idfsNationality,
			@idfsHumanGender,
			@idfCurrentResidenceAddress,
			@idfEmployerAddress,
			@idfRegistrationAddress,
			@datDateofBirth,
			@datDateOfDeath,
			@strLastName,
			@strSecondName,
			@strFirstName,
			@strRegistrationPhone,
			@strEmployerName,
			@strHomePhone,
			@strWorkPhone,
			@idfsPersonIDType,
			@strPersonID
			,@datEnteredDate
			,@datModificationDate
		)
	end
end
