


--##SUMMARY Clears link from farm to monitoring session.
--##SUMMARY Called when farm is deleted from session Detail/TableView, but summary contains the link to the same farm

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.02.2012


--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @idfFarm bigint
EXEC spASFarm_Unlink @idfFarm

*/


CREATE   procedure [dbo].[spASFarm_Unlink]
	@idfFarm as bigint --##PARAM @@idfFarm - farm ID
as
	Update tlbFarm
	SET idfMonitoringSession = null
	WHERE idfFarm = @idfFarm


