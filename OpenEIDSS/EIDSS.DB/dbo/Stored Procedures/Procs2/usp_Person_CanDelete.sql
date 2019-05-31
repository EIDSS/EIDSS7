--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spPerson_CanDelete : rename for V7
--                          Input: ID; Output: bit
--                          05/02/2017: change name to: usp_Person_CanDelete
--                          all the code checking record in tlbBatchTest;tlbTransferOUT;tlbMaterial;tlbTestValidation;tlbVetCase;tlbVetCaseLog;tlbAggrCase are bloked
--                          and only checking tables: tstUserTable;tstGlobalSiteOptions
-- Testing code:
/*
----testing code:
DECLARE @ID bigint
DECLARE @Result BIT
EXEC usp_Person_CanDelete 1, @Result OUTPUT

Print @Result
*/

--=====================================================================================================
--##SUMMARY Checks if Person object can be deleted.
--##SUMMARY This procedure is called from Persons list.
--##SUMMARY We consider that person can be deleted if there is no reference to this person 
--##SUMMARY from any other table
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.05.2010
--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011
--##RETURNS 0 if Person can't be deleted 
--##RETURNS 1 if Person can be deleted 


CREATE   procedure [dbo].[usp_Person_CanDelete]
	@ID as bigint --##PARAM @ID - farm ID
	,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
as


IF EXISTS(SELECT * from  tstUserTable where idfPerson = @ID and intRowStatus = 0)
	SET @Result = 0
ELSE
	SET @Result = 1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = usp_Employee_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

Return @Result



