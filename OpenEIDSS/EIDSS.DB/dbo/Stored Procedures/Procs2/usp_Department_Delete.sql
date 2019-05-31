
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/18/2017
-- Last modified by:		Joan Li
-- Description:				Created based on V6 spDepartment_Delete: rename for V7
-- Testing code:
/*
----testing code:
DECLARE @ID as bigint
EXEC usp_Department_Delete @ID
*/

--=====================================================================================================
--##SUMMARY Deletes department Record. Called from OrganizationDetail form
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009
--##RETURNS Doesn't use

CREATE      procedure [dbo].[usp_Department_Delete]( 

	@ID as bigint

)

as

DECLARE @NameID bigint



SELECT 

	@NameID = idfsDepartmentName

FROM 

	tlbDepartment 

WHERE 

	idfDepartment=@ID



delete from tlbDepartment

where idfDepartment = @ID

exec dbo.usp_sysBaseReference_Delete @NameID












