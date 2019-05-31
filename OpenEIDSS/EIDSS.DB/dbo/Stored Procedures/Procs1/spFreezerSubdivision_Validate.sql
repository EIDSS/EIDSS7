

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011

/*
exec spFreezerTree
exec spFreezerSubdivision_Validate @idfMaterial=749880000000 ,@idfSubdivision=750130000000 
*/


CREATE    PROCEDURE [dbo].[spFreezerSubdivision_Validate]
	@idfSubdivision bigint,
	@idfMaterial bigint=null,
	@intCapacity int=null output,
	@intStored int = null output
as
	declare @stored int

--	set @stored=0
	
	select	@stored=count(*)
	from	tlbMaterial
	where	idfSubdivision=@idfSubdivision and
			intRowStatus=0 and
			(idfMaterial<>@idfMaterial or @idfMaterial is null)

	declare @real int
	set @real=@intCapacity

	if @real is null
	begin
		select	@real=intCapacity
		from	tlbFreezerSubdivision
		where	idfSubdivision=@idfSubdivision
		set @intCapacity = @real
	end

	if @idfMaterial is not null set @stored=@stored-1
	Set @intStored = @stored
	if @stored>@real
	begin
		if @intCapacity is null	raiserror('errNoFreeLocation',16,1,null)
		else raiserror('msgCanNotDecreaseLocationVial',16,1,null) --here should be other message

	end


