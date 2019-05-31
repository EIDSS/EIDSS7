--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spEmployee_ValidateForeignKeys : rename for V7
--                          Input: ID; Output: 
--                          05/02/2017: change name to: usp_Employee_ValidateForeignKeys

-- Testing code:
/*
----testing code:
DECLARE @ID bigint
EXEC usp_Employee_ValidateForeignKeys @ID
*/

--=====================================================================================================
--##SUMMARY Checks foreign keys for Person object
--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015
--##RETURNS table with incorrect records


CREATE PROCEDURE [dbo].[usp_Employee_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Person ID
AS
	EXEC usp_ValidateForeignKeys 'tlbPerson', @RootId, 'Employee'


