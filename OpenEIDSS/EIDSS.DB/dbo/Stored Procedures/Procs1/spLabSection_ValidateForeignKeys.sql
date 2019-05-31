
--##SUMMARY Checks foreign keys for LabSection object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLabSection_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spLabSection_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LabSection ID
AS

	DECLARE @ValidateTable TABLE (
		TableName VARCHAR(200),
		RootObjectName VARCHAR(200),
		ConstraintName VARCHAR(500),
		[Where] VARCHAR(500),
		Id BIGINT,
		RootTableName VARCHAR(200),
		RootId BIGINT,
		StrRootId VARCHAR(200),
		InvalidFieldName VARCHAR(200),
		InvalidFieldValue VARCHAR(500),
		[Query] VARCHAR(MAX)
	)

	DECLARE @MaterialId BIGINT = NULL

	IF EXISTS (SELECT * FROM tlbTesting tt WHERE tt.idfTesting = @RootId)
	BEGIN
		INSERT INTO @ValidateTable
		EXEC spValidateForeignKeys 'tlbTesting', @RootId, 'Lab Section'
		
		SELECT @MaterialId = tt.idfMaterial FROM tlbTesting tt WHERE tt.idfTesting = @RootId
		
		INSERT INTO @ValidateTable
		EXEC spValidateForeignKeys 'tlbMaterial', @MaterialId, 'Lab Section'	
	END
	ELSE
		INSERT INTO @ValidateTable
		EXEC spValidateForeignKeys 'tlbMaterial', @RootId, 'Lab Section'
		
	SELECT
	*
	FROM @ValidateTable

