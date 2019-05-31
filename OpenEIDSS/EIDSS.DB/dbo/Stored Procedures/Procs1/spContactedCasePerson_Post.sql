

--##SUMMARY Saves information about the human case contacts.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 23.01.2010

--##REMARKS UPDATED BY: Shatilova T.
--##REMARKS Date: 26.10.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@idfContactedCasePerson	bigint
declare	@idfHumanCase			bigint
declare	@idfHuman				bigint
declare	@idfsPersonContactType	bigint
declare	@datDateOfLastContact	datetime
declare	@strPlaceInfo			nvarchar(200)
declare @strComments			nvarchar(500)

exec spContactedCasePerson_Post 
		 @idfContactedCasePerson
		,@idfHumanCase
		,@idfHuman
		,@idfsPersonContactType
		,@datDateOfLastContact
		,@strPlaceInfo
		,@@strComments

*/

CREATE	procedure	[dbo].[spContactedCasePerson_Post]
(	 @idfContactedCasePerson	bigint			--##PARAM @idfContactedCasePerson Contact Id
	,@idfHumanCase				bigint			--##PARAM @idfHumanCase Id of the human case that includes a specified contact (reference to tlbHumanCase)
	,@idfHuman					bigint			--##PARAM @idfHuman Id of the contact human (reference to tlbHuman)
	,@idfsPersonContactType		bigint			--##PARAM @idfsPersonContactType Id of the contact Type (reference to trtBaseReference with Type rftContact_Type (19000014))
	,@datDateOfLastContact		datetime		--##PARAM @datDateOfLastContact Date of the last contact
	,@strPlaceInfo              nvarchar(200)   --##PARAM @strPlaceInfo Place of the last contact
	,@strComments				nvarchar(500)
)
as

-- Update reference parameters related to tlbContactedCasePerson
if not exists	(
	select	*
	from	trtBaseReference ContactType
	where	ContactType.idfsBaseReference = @idfsPersonContactType
			and ContactType.idfsReferenceType = 19000014	-- rftContact_Type
			and ContactType.intRowStatus = 0
				)
begin
	set @idfsPersonContactType = null
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
	from		tlbHuman Human
	where		Human.idfHuman = @idfHuman
				AND Human.intRowStatus = 0
				)
begin
	set @idfHuman = null
end

-- Post tlbContactedCasePerson
if	@idfHumanCase is not null
	and @idfHuman is not null
	and @idfsPersonContactType is not null
begin
	if	exists	(
			select	*
			from	tlbContactedCasePerson
			where	idfContactedCasePerson = @idfContactedCasePerson
				)
	begin
		update	tlbContactedCasePerson
		set		idfHumanCase			=	@idfHumanCase,
				idfHuman				=	@idfHuman,
				idfsPersonContactType	=	@idfsPersonContactType,
				datDateOfLastContact	=	@datDateOfLastContact,
				strPlaceInfo			=	@strPlaceInfo,
				strComments				=	@strComments

		where	idfContactedCasePerson = @idfContactedCasePerson
	end
	else begin
		insert into	tlbContactedCasePerson
		(	idfContactedCasePerson,
			idfHumanCase,
			idfHuman,
			idfsPersonContactType,
			datDateOfLastContact,
			strPlaceInfo,
			strComments
		)
		values
		(	@idfContactedCasePerson,
			@idfHumanCase,
			@idfHuman,
			@idfsPersonContactType,
			@datDateOfLastContact,
			@strPlaceInfo,
			@strComments
		)
	end
end


