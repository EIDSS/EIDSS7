

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE  PROCEDURE [dbo].[spRepositoryScheme_Delete]
	@ID as bigint
 AS
--dbo.tlbContainer
declare @VialsCount as int
--set @VialsCount = (
	select @VialsCount=count(*)
	from		tlbMaterial
	inner join	tlbFreezerSubdivision
	on			tlbFreezerSubdivision.idfSubdivision=tlbMaterial.idfSubdivision and
				tlbFreezerSubdivision.idfFreezer=@ID and
				tlbMaterial.idfsSampleStatus=10015007 and--accessioned
				tlbMaterial.intRowStatus=0 and
				tlbFreezerSubdivision.intRowStatus=0
--)
if (@VialsCount <> 0) begin
	raiserror ('OperFailed nonzero vials amount', 16, 1)
	rollback transaction
	return
end
--select idfsSubdivisionID into #table from FreezerSubdivision where idfsFreezerID = @ID

--update tlbFreezerSubdivision set idfsParentSubdivision = NULL 
--	where FreezerSubdivision.idfsFreezerID = @ID

DELETE FROM tlbFreezerSubdivision
WHERE idfFreezer = @ID

DELETE FROM tlbFreezer
WHERE idfFreezer = @ID


