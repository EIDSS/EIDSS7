

--=====================================================================================================
-- Created by:				Joan Li
-- Description:				04/18/2017: JL:Created based on V6 spDepartment_Post : V7 USP38

-- Revision History
--		Name       Date       Change Detail
--      JL         04/26/2017 insert data into table: tlbDepartment
--      JL         06/21/2017 table does have triggers handle delete,insert and update; add data modify date and user info
--      JL         05/16/2018 change to valide function FN_GBL_DATACHANGE_INFO
--
/*
----testing code:
execute usp_Department_Set 'I',NULL,49710000000,NULL,NULL,NULL,NULL,'Lij'
select * from tlbdepartment order by idfdepartment desc
*/

--=====================================================================================================

CREATE         PROCEDURE [dbo].[usp_Department_Set] 

	@Action AS VARCHAR(2), --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfDepartment AS BIGINT, --##PARAM @idfDepartment - Department ID
	@idfOrganization AS BIGINT, --##PARAM @idfOrganization - Organization ID
	@DefaultName AS NVARCHAR(200), --##PARAM @DefaultName - department name in English
	@name AS NVARCHAR(200), --##PARAM @Name - department name in language defined by @LangID
	@idfsCountry BIGINT, --##PARAM @idfsCountry - department country
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
	,@User VARCHAR(100)=NULL  --who required data change

AS

IF upper(@Action) = 'D'  --Delete

	BEGIN
		EXEC usp_Department_Delete @idfDepartment
		RETURN 0
	END

	----get data change date and user info: before app send final user 
	DECLARE @DataChageInfo as nvarchar(max)
	select @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)

	DECLARE @idfsDepartmentName VARCHAR(36)

	SELECT @idfsDepartmentName = idfsDepartmentName
	FROM dbo.tlbDepartment
	WHERE idfDepartment = @idfDepartment

	DECLARE @NewRecord BIT
	IF @@ROWCOUNT=0
	BEGIN
		exec usp_sysGetNewID @idfsDepartmentName OUTPUT
		SET @NewRecord = 1
	END

	if(@LangID = 'en' and IsNull(@DefaultName,N'') = N'')
		SET @DefaultName = @name
	EXEC usp_BaseReference_SysSet @idfsDepartmentName, 19000164, @LangID, @DefaultName, @name, 0 --'rftDepartmentName'

	IF @NewRecord=1

		BEGIN
			IF @idfDepartment IS NULL
				EXEC usp_sysGetNewID @idfDepartment OUTPUT
			INSERT INTO tlbDepartment
				   (
					idfDepartment
				   ,idfsDepartmentName
				   ,idfOrganization
				   ,strReservedAttribute
					)
			 VALUES
				   (
					@idfDepartment
				   ,@idfsDepartmentName
				   ,@idfOrganization
				   ,@DataChageInfo
				   )	   

		END


