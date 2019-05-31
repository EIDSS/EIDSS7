
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/19/2017
-- Last modified by:		Joan Li
-- Description:				Created based on V6 spPerson_Delete : rename for V7
--                          Input: person ID; Output: N/A  
--                          Hard delete records from 4 tables
-- Testing code:
/*
----testing code:
DECLARE @idfPerson bigint
EXECUTE usp_Person_Delete
  @idfPerson
*/

--=====================================================================================================
CREATE   Proc [dbo].[usp_Person_Delete]
		@idfPerson bigint

As

-- StaffPosition

delete from tstObjectAccess WHERE idfActor = @idfPerson

delete from tlbEmployeeGroupMember where idfEmployee = @idfPerson

delete from tlbPerson WHERE idfPerson = @idfPerson

delete from tlbEmployee WHERE idfEmployee = @idfPerson
















