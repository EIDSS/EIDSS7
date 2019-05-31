

CREATE     PROCEDURE [dbo].[spSmphBaseReference_SelectLookup] 
	@idfsReferenceType bigint
AS
select idfsBaseReference as id, idfsReferenceType as tp, intHACode as ha, strDefault  as df, intRowStatus as rs, isnull(intOrder,0) as rd
from trtBaseReference 
where idfsReferenceType = @idfsReferenceType

