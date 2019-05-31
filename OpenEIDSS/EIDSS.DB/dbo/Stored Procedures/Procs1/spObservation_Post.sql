


--##SUMMARY Saves observation with its flexible form template.
--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 29.12.2009

--##RETURNS Doesn't use



/*
--Example of a call of procedure:
declare	@idfObservation		bigint
declare	@idfsFormTemplate	bigint
exec spObservation_Post
		@idfObservation,
		@idfsFormTemplate
*/

create	procedure	spObservation_Post
(	 @idfObservation	bigint	--##PARAM @idfObservation Observation Id
	,@idfsFormTemplate	bigint	--##PARAM @idfsFormTemplate Id of flexible form template (reference to ffFormTemplate)
)
as
begin

if (@idfObservation is null) return;

-- Post tlbObservation
if exists	(
	select	*
	from	tlbObservation
	where	idfObservation = @idfObservation
			)
begin
	update	tlbObservation
	set		idfsFormTemplate = @idfsFormTemplate
	where	idfObservation = @idfObservation
			and isnull(idfsFormTemplate,0) != isnull(@idfsFormTemplate,0)
end
else begin
	insert into	tlbObservation
	(	idfObservation,
		idfsFormTemplate
	)
	values
	(	@idfObservation,
		@idfsFormTemplate
	)
end

end

