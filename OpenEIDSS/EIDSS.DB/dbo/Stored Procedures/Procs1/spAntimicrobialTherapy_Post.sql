

--##SUMMARY Saves information about the human case contacts.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 25.01.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@idfAntimicrobialTherapy		bigint
declare	@idfHumanCase					bigint
declare	@datFirstAdministeredDate		datetime
declare	@strAntimicrobialTherapyName	nvarchar(200)
declare	@strDosage						nvarchar(200)

exec spAntimicrobialTherapy_Post 
		 @idfAntimicrobialTherapy
		,@idfHumanCase
		,@datFirstAdministeredDate
		,@strAntimicrobialTherapyName
		,@strDosage

*/

create	procedure	spAntimicrobialTherapy_Post
(	 @idfAntimicrobialTherapy		bigint			--##PARAM @idfAntimicrobialTherapy Antibiotic/antitrivial therapy Id
	,@idfHumanCase					bigint			--##PARAM @idfHumanCase Id of the human case that includes a specified antibiotic/antitrivial therapy (reference to tlbHumanCase)
	,@datFirstAdministeredDate		datetime		--##PARAM @datFirstAdministeredDate First administered date
	,@strAntimicrobialTherapyName	nvarchar(200)	--##PARAM @strAntimicrobialTherapyName name of the antibiotic/antitrivial therapy
	,@strDosage						nvarchar(200)	--##PARAM @strDosage Dosage of the antibiotic/antitrivial therapy
)
as

-- Update reference parameters related to tlbAntimicrobialTherapy
if not exists	(
	select		*
	from		tlbHumanCase HumanCase
	where		HumanCase.idfHumanCase = @idfHumanCase
				AND HumanCase.intRowStatus = 0
				)
begin
	set @idfHumanCase = null
end

-- Post tlbAntimicrobialTherapy
if	@idfHumanCase is not null
begin
	if	exists	(
			select	*
			from	tlbAntimicrobialTherapy
			where	idfAntimicrobialTherapy = @idfAntimicrobialTherapy
				)
	begin
		update	tlbAntimicrobialTherapy
		set		idfHumanCase				=	@idfHumanCase,
				datFirstAdministeredDate	=	@datFirstAdministeredDate,
				strAntimicrobialTherapyName	=	@strAntimicrobialTherapyName,
				strDosage					=	@strDosage

		where	idfAntimicrobialTherapy = @idfAntimicrobialTherapy
	end
	else begin
		insert into	tlbAntimicrobialTherapy
		(	idfAntimicrobialTherapy,
			idfHumanCase,
			datFirstAdministeredDate,
			strAntimicrobialTherapyName,
			strDosage
		)
		values
		(	@idfAntimicrobialTherapy,
			@idfHumanCase,
			@datFirstAdministeredDate,
			@strAntimicrobialTherapyName,
			@strDosage
		)
	end
end


