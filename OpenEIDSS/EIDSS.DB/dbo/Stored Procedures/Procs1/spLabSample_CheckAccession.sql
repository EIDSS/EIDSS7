

CREATE            PROCEDURE dbo.spLabSample_CheckAccession( 
	@idfMaterial AS bigint--,
	--@LangID NVARCHAR(50)
)
AS

SELECT top 1 * from tlbMaterial where idfMaterial = @idfMaterial AND blnAccessioned = 1
	
	if(@@ROWCOUNT > 0) select 'true'; 
	else select 'false';



