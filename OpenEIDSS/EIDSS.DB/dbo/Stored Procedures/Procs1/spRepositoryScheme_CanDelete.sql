

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 15.08.2011

CREATE PROCEDURE [dbo].[spRepositoryScheme_CanDelete]
	@ID AS bigint,
	@Result AS BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set @Result=1

	declare @VialsCount as int
	select @VialsCount=count(*)
	from		tlbMaterial
	inner join	tlbFreezerSubdivision
	on			tlbFreezerSubdivision.idfSubdivision=tlbMaterial.idfSubdivision and
				tlbFreezerSubdivision.idfFreezer=@ID and
				tlbMaterial.idfsSampleStatus in (10015007,10015003,10015002) and--accessioned or marked
				tlbMaterial.intRowStatus=0 and
				tlbFreezerSubdivision.intRowStatus=0

	if (@VialsCount <> 0) begin
		set @Result=0
	end

END

