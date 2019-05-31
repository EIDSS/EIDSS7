



--##SUMMARY 

--##REMARKS Author: 
--##REMARKS Create date: 

--##REMARKS UPDATED BY: 
--##REMARKS Date: 

--##RETURNS Doesn't use

/*

*/

create  Procedure [dbo].[spVectorFieldTest_Post]
(
			@Action INT --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfPensideTest bigint output--##PARAM @idfPensideTest - penside test record ID
			,@idfMaterial bigint --##PARAM @idfMaterial - ID of sample to which test is applied
			,@idfsPensideTestResult bigint --##PARAM @idfsPensideTestResult - penside test result, reference to rftPensideTestResult (19000105)
			,@idfsPensideTestName bigint --##PARAM  @idfsPensideTestName -penside test Type, reference to rftPensideTestType (19000104)
			,@idfTestedByPerson bigint
			,@idfTestedByOffice bigint
			,@idfsDiagnosis bigint
			,@datTestDate DateTime output			
			,@idfsPensideTestCategory bigint
)
As
Begin
If (@Action = 8) Begin
		EXEC [dbo].[spVectorFieldTest_Delete] @ID = @idfPensideTest
END ELSE BEGIN

		if	(	(	@idfsPensideTestResult is not null
					or	@datTestDate is not null
					or	@idfsDiagnosis is not null
					or	@idfsPensideTestCategory is not null
				)
				and (	@idfPensideTest is null
						or @idfPensideTest <= 0
					)
			)
			or	(	@idfPensideTest is not null
					and @idfPensideTest > 0
				)
			or	exists	(
				select		top 1 1
				from		tlbPensideTest pt
				inner join	tlbMaterial m
				on			m.idfMaterial = pt.idfMaterial
							and m.intRowStatus = 0
				where		pt.intRowStatus = 0
							and pt.idfMaterial = IsNull(@idfMaterial, 0)
							and pt.idfsPensideTestName = IsNull(@idfsPensideTestName, 0)

						)	
		begin
			if	(	@idfPensideTest is null
					or	@idfPensideTest <= 0
				)
			begin
				select		@idfPensideTest = pt.idfPensideTest
				from		tlbPensideTest pt
				inner join	tlbMaterial m
				on			m.idfMaterial = pt.idfMaterial
							and m.intRowStatus = 0
				where		pt.intRowStatus = 0
							and pt.idfMaterial = @idfMaterial
							and pt.idfsPensideTestName = IsNull(@idfsPensideTestName, 0)
			end
		
			if	@idfPensideTest is null
				or	@idfPensideTest <= 0
			begin
				exec spsysGetNewID @idfPensideTest output
			end

			if	exists	(
					select	top 1 1
					from	tlbPensideTest pt
					where	pt.idfPensideTest = @idfPensideTest
						)
			begin
				update		pt
				set			pt.idfsPensideTestName = @idfsPensideTestName,
							pt.idfsPensideTestResult = @idfsPensideTestResult,
							pt.datTestDate = @datTestDate,
							pt.idfsDiagnosis = @idfsDiagnosis,
							pt.idfsPensideTestCategory = @idfsPensideTestCategory,
							pt.idfTestedByPerson = @idfTestedByPerson,
							pt.idfTestedByOffice = @idfTestedByOffice,
							pt.intRowStatus = 0
				from		tlbPensideTest pt
				where		pt.idfPensideTest = @idfPensideTest
							and (	IsNull(pt.idfsPensideTestName, 0) <> IsNull(@idfsPensideTestName, 0)
									or	IsNull(pt.idfsPensideTestResult, 0) <> IsNull(@idfsPensideTestResult, 0)
									or	IsNull(pt.datTestDate, N'19000101') <> IsNull(@datTestDate, N'19000101')
									or	IsNull(pt.idfsDiagnosis, 0) <> IsNull(@idfsDiagnosis, 0)
									or	IsNull(pt.idfsPensideTestCategory, 0) <> IsNull(@idfsPensideTestCategory, 0)
									or	IsNull(pt.idfTestedByPerson, 0) <> IsNull(@idfTestedByPerson, 0)
									or	IsNull(pt.idfTestedByOffice, 0) <> IsNull(@idfTestedByOffice, 0)
									or	pt.intRowStatus <> 0
								)
			end
			else if	exists	(
						select	top 1 1
						from	tlbMaterial m
						where	m.idfMaterial = @idfMaterial
								and m.intRowStatus = 0
								)
			begin
				-- set Test Date only if Test Result is set

				if ((@datTestDate is null) and (@idfsPensideTestResult is not null)) set @datTestDate = GetDate();

				insert into	tlbPensideTest
				(	idfPensideTest,
					idfMaterial,
					idfsPensideTestResult,
					idfsPensideTestName,
					idfTestedByPerson,
					idfTestedByOffice,
					idfsDiagnosis,
					datTestDate,
					idfsPensideTestCategory,
					intRowStatus
				)
				select	@idfPensideTest,
						m.idfMaterial,
						@idfsPensideTestResult,
						@idfsPensideTestName,
						@idfTestedByPerson,
						@idfTestedByOffice,
						@idfsDiagnosis,
						@datTestDate,
						@idfsPensideTestCategory,
						0
				from	tlbMaterial m
				where	m.idfMaterial = @idfMaterial
						and m.intRowStatus = 0
				
			end
		end
	END
	
	return 0
end
