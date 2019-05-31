




--##SUMMARY Posts data from Test->TestResult matrix form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 22.11.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:
DECLARE @Action int
DECLARE @idfsTestName bigint
DECLARE @idfsTestResult bigint
DECLARE @TestKind int


EXECUTE spTestResult2Test_Post
   @Action
  ,@idfsTestName
  ,@idfsTestResult
  ,@TestKind
*/



CREATE          PROCEDURE dbo.spTestResult2Test_Post(
	@Action as INT, --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfsTestName AS bigint, --##PARAM @idfsTestName - test Type (reference to rftTestName or to rftPensideTestType)
	@idfsTestResult as bigint, --##PARAM @idfsTestResult - test result (reference to rftTestResult or to rftPensideTestResult)
	@TestKind as int, --##PARAM @TestKind - kind of record: 0 - laboratory test, 1 - penside test
	@blnIndicative as bit
	)
AS
--@Action=16 --modified
--has no sence because both PK fields are passed as parameter


IF @Action = 8 --deleted
BEGIN
	IF @TestKind = 0
	BEGIN
		DELETE FROM trtTestTypeToTestResultToCP
		WHERE
			idfsTestName=@idfsTestName
			AND idfsTestResult = @idfsTestResult
		DELETE FROM trtTestTypeToTestResult
		WHERE
			idfsTestName=@idfsTestName
			AND idfsTestResult = @idfsTestResult

	END		
	ELSE IF @TestKind = 1
	BEGIN
		DELETE FROM trtPensideTestTypeToTestResultToCP
		WHERE
			idfsPensideTestName=@idfsTestName
			AND idfsPensideTestResult = @idfsTestResult
		DELETE FROM trtPensideTestTypeToTestResult
		WHERE
			idfsPensideTestName=@idfsTestName
			AND idfsPensideTestResult = @idfsTestResult
	END
END
ELSE IF @Action=4 OR @Action = 16 --new or update
BEGIN
	IF @TestKind = 0
	BEGIN
		if EXISTS( SELECT * FROM trtTestTypeToTestResult WHERE idfsTestName=@idfsTestName
				AND idfsTestResult = @idfsTestResult)
			UPDATE trtTestTypeToTestResult
			SET
				intRowStatus = 0,
				blnIndicative = @blnIndicative
			WHERE
				idfsTestName=@idfsTestName
				AND idfsTestResult = @idfsTestResult
		ELSE
			INSERT INTO trtTestTypeToTestResult(
				idfsTestName,
				idfsTestResult,
				blnIndicative
			)VALUES(
				@idfsTestName,
				@idfsTestResult,
				@blnIndicative
			)
		if NOT EXISTS( SELECT * FROM trtTestTypeToTestResultToCP WHERE idfsTestName=@idfsTestName
				AND idfsTestResult = @idfsTestResult)
			INSERT INTO trtTestTypeToTestResultToCP(
				idfsTestName,
				idfsTestResult,
				idfCustomizationPackage
			)VALUES(
				@idfsTestName,
				@idfsTestResult,
				dbo.fnCustomizationPackage()
			)

	END
	ELSE IF @TestKind = 1
	BEGIN
		IF EXISTS( SELECT * FROM trtPensideTestTypeToTestResult WHERE idfsPensideTestName=@idfsTestName
					AND idfsPensideTestResult = @idfsTestResult)
			UPDATE trtPensideTestTypeToTestResult
			SET
				intRowStatus = 0
				,blnIndicative = @blnIndicative
			WHERE
				idfsPensideTestName=@idfsTestName
				AND idfsPensideTestResult = @idfsTestResult		
		ELSE
			INSERT INTO trtPensideTestTypeToTestResult(
				idfsPensideTestName,
				idfsPensideTestResult,
				blnIndicative
			)VALUES(
				@idfsTestName,
				@idfsTestResult,
				@blnIndicative
			)
		IF NOT EXISTS( SELECT * FROM trtPensideTestTypeToTestResultToCP WHERE idfsPensideTestName=@idfsTestName
					AND idfsPensideTestResult = @idfsTestResult)
			INSERT INTO trtPensideTestTypeToTestResultToCP(
				idfsPensideTestName,
				idfsPensideTestResult,
				idfCustomizationPackage
			)VALUES(
				@idfsTestName,
				@idfsTestResult,
				dbo.fnCustomizationPackage()
			)
	END
END
Return 0




