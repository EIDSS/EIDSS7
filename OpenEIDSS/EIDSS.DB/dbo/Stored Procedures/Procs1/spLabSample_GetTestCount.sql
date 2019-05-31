

--##REMARKS Created BY: Zurin M.
--##REMARKS Date: 04.02.2012

/*
exec spLabSample_GetTestCount 9150000510
*/

CREATE PROCEDURE [dbo].[spLabSample_GetTestCount]
	@idfMaterial bigint
AS

BEGIN
	SET NOCOUNT ON;
select		ISNULL(COUNT(*),0)  as TestsCount
from		tlbTesting
where		tlbTesting.intRowStatus = 0
			and tlbTesting.idfMaterial = @idfMaterial
			and ISNULL(tlbTesting.blnNonLaboratoryTest,0) = 0
END



