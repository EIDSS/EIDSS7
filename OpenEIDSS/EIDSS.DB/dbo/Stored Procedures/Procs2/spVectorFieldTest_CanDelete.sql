
--##SUMMARY Checks if Vector can be deleted.  
--##SUMMARY Vector can be deleted if it dasn't relate to material.

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS 0 if case can't be deleted 
--##RETURNS 1 if case can be deleted 

/*
--Example of a call of procedure:

	
print 'Result:'
print @res
*/

create procedure	[dbo].[spVectorFieldTest_CanDelete]
(		
	@idfVectorFieldTest	bigint,		--##PARAM @idfVector Vector Id
	@Result AS BIT OUTPUT	--##PARAM  @Result - 0 if case can't be deleted, 1 in other case
)
as

	set @Result=1

return @Result




