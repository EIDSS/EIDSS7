
--##SUMMARY Checks if Vector can be deleted.  
--##SUMMARY Vector can be deleted if it dasn't relate to material.

--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 3.08.2011

--##RETURNS 0 if case can't be deleted 
--##RETURNS 1 if case can be deleted 

/*
--Example of a call of procedure:
declare	@idfVector	bigint, @res bit

select @idfVector = MAX(idfVector) from dbo.tlbVector

execute	dbo.[spVector_CanDelete]
	@idfVector, @res output
	
print 'Result:'
print @res
*/

create procedure	[dbo].[spVector_CanDelete]
(		
	@idfVector	bigint,		--##PARAM @idfVector Vector Id
	@Result AS BIT OUTPUT	--##PARAM  @Result - 0 if case can't be deleted, 1 in other case
)
as
if	exists	(
		select		*
		from	dbo.tlbMaterial	
		where	idfVector = @idfVector and intRowStatus=0
			)	
	set @Result=0

else
	set @Result=1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spVector_Validate @idfVector
	IF @DataValidationResult <> 0
		SET @Result = 0
END

return @Result




