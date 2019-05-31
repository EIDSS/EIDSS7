
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

create procedure	[dbo].[spVectorSample_CanDelete]
(		
	@idfMaterial	bigint,		--##PARAM @@idfMaterial Vector Sample Id
	@Result AS BIT OUTPUT	--##PARAM  @Result - 0 if case can't be deleted, 1 in other case
)
as
Begin
	set @Result=1
	
	if	exists	(
			select Top 1 1
			from	dbo.tlbPensideTest	
			where	
			idfMaterial = @idfMaterial 
			AND (idfsPensideTestResult IS NULL)
			AND (datTestDate IS NULL)
			AND (idfsPensideTestCategory IS NULL)
			AND (idfTestedByPerson IS NULL)
			AND (idfTestedByOffice IS NULL)
			AND (idfsDiagnosis IS NULL)
			and intRowStatus=0
	)	set @Result=0
		
	If (@Result=1) begin	
		if	exists	(	
		SELECT top 1 1 
		from tlbMaterial 
		where idfMaterial = @idfMaterial and blnAccessioned = 1 and intRowStatus = 0
		)	set @Result=0
	end
	
	return @Result

end
