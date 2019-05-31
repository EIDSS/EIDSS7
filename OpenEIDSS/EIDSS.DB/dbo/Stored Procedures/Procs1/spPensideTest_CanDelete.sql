

--##SUMMARY Checks if vet case can be deleted.
--##SUMMARY This procedure is called before case deleting. Case is deleted only if procedure enables this.
--##SUMMARY Now we consider that case can be deleted only if it contains no important information:
--##SUMMARY  - Case farm contains no species/animal (and thus no specimens too)
--##SUMMARY  - Case has no attached tests 
--##SUMMARY  - Case has no vaccination records
--##SUMMARY  - Case has no case log records
--##SUMMARY  - No outbreaks refer this case
--##SUMMARY  - There is no control measures records related with case

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 4.12.2009

--##RETURNS 0 if case can't be deleted 
--##RETURNS 1 if case can be deleted 
		
--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011


/*
Example of procedure call:

--DECLARE @ID bigint
--DECLARE @Result bit
--EXEC spVetCase_CanDelete @ID, @Result OUTPUT
--Print @Result

*/




CREATE            PROCEDURE [dbo].[spPensideTest_CanDelete]( 
	@ID AS BIGINT,--##PARAM  @ID - Vet case ID
	@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
)
as


Select @Result = 1;

return @Result





