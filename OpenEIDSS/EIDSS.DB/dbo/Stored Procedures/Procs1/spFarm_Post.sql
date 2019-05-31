

--##SUMMARY Posts FarmDetail control data.
--##SUMMARY The main posting is performed in spFarmPanel_Post procedure that is called before this one,
--##SUMMARY so it just updates several fields that belongs to FarmDetail control only.
--##SUMMARY Now this procedure is called for editing livestock farm from AS session detail form only, so posting to FarmActual is not needed.


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 17.08.2011

--##REMARKS UPDATED BY: Gorodentseva T. updating tlbFarmActual commented
--##REMARKS Date: 24.07.2012

--##RETURNS Doesn't use





CREATE             PROCEDURE [dbo].[spFarm_Post]
	@idfFarm bigint,		--##PARAM @idfFarm - farm ID
	@intHACode int,	--##PARAM 
	@datModificationDate datetime = NULL out
AS


IF EXISTS(SELECT * FROM dbo.tlbFarm WHERE idfFarm = @idfFarm)
BEGIN
	UPDATE tlbFarm
	SET
		intHACode=@intHACode
		,datModificationDate = GETDATE()
	WHERE 
		idfFarm=@idfFarm
		AND intRowStatus = 0
		AND ISNULL(intHACode,0)<>ISNULL(@intHACode,0)
	SELECT @datModificationDate = datModificationDate
	FROM dbo.tlbFarm WHERE idfFarm = @idfFarm
END




