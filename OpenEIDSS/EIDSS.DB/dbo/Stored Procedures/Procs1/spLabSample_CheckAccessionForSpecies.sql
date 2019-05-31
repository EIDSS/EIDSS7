

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

CREATE            PROCEDURE [dbo].[spLabSample_CheckAccessionForSpecies]( 
	@idfSpecies AS bigint--,
	--@LangID NVARCHAR(50)
)
AS

IF Exists(
	SELECT top 1 * from  tlbMaterial
	where idfSpecies = @idfSpecies
		AND intRowStatus = 0
		AND blnAccessioned = 1
	)
	select 1;

else
	select 0;



