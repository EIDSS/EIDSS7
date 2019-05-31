

CREATE            PROCEDURE dbo.spLabSample_MaterialExists( 
	@idfMaterial AS bigint--,
	--@LangID NVARCHAR(50)
)
AS

SELECT top 1 * from tlbMaterial where idfMaterial = @idfMaterial and intRowStatus = 0
	
	if(@@ROWCOUNT > 0) select 'true'; 
	else select 'false';



