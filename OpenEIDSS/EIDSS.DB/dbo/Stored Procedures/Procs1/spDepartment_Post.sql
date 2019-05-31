

--##SUMMARY Post department data. Called from OrganizationDetail and DepartmentDetail forms

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:
DECLARE @Action int
DECLARE @idfDepartment bigint
DECLARE @idfOrganization bigint
DECLARE @DefaultName nvarchar(200)
DECLARE @Name nvarchar(200)
DECLARE @idfsCountry bigint
DECLARE @LangID nvarchar(50)

EXECUTE spDepartment_Post
   @Action
  ,@idfDepartment
  ,@idfOrganization
  ,@DefaultName
  ,@Name
  ,@idfsCountry
  ,@LangID

*/


CREATE         PROCEDURE dbo.spDepartment_Post 
	@Action AS INT, --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfDepartment AS bigint, --##PARAM @idfDepartment - Department ID
	@idfOrganization AS bigint, --##PARAM @idfOrganization - Organization ID
	@DefaultName AS NVARCHAR(200), --##PARAM @DefaultName - department name in English
	@name AS NVARCHAR(200), --##PARAM @Name - department name in language defined by @LangID
	@idfsCountry bigint, --##PARAM @idfsCountry - department country
	@LangID As nvarchar(50) --##PARAM @LangID - language ID
AS
IF @Action = 8 --Delete
BEGIN
	EXEC dbo.spDepartment_Delete @idfDepartment
	return 0
END

DECLARE @idfsDepartmentName VARCHAR(36)
SELECT 
	@idfsDepartmentName = idfsDepartmentName
FROM 
	dbo.tlbDepartment
WHERE idfDepartment = @idfDepartment

DECLARE @NewRecord BIT
IF @@ROWCOUNT=0
BEGIN
	exec spsysGetNewID @idfsDepartmentName OUTPUT
	SET @NewRecord = 1
END
if(@LangID = 'en' and IsNull(@DefaultName,N'') = N'')
	SET @DefaultName = @name
EXEC spBaseReference_SysPost @idfsDepartmentName, 19000164, @LangID, @DefaultName, @name, 0 --'rftDepartmentName'
IF @NewRecord=1
BEGIN
	IF @idfDepartment IS NULL
		exec spsysGetNewID @idfDepartment OUTPUT
	
	INSERT INTO tlbDepartment
           (
			idfDepartment
           ,idfsDepartmentName
           ,idfOrganization
			)
     VALUES
           (
			@idfDepartment
           ,@idfsDepartmentName
           ,@idfOrganization
           )
	
END














