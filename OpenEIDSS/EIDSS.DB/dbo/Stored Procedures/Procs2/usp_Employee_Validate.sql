--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spEmployee_Validate : rename for V7
--                          Input: ID; Output: 
--                          05/02/2017: change name to: usp_Employee_Validate

-- Testing code:
/*
----testing code:
DECLARE @ID bigint
DECLARE @Result BIT
EXEC @Result = usp_Employee_Validate @ID

Print @Result
*/

--=====================================================================================================
--##SUMMARY Checks data validation for Employee object
--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015
--##RETURNS 0 if all internal validation procedures returns no errors
--##RETURNS 1 if some internal validation procedures returns errors

CREATE PROCEDURE [dbo].[usp_Employee_Validate]
	@RootId BIGINT	--##PARAM @RootId - Employee ID
AS
	EXEC usp_Employee_ValidateForeignKeys @RootId
	
	IF (SELECT @@ROWCOUNT) > 0
		RETURN 1

	RETURN 0


