

CREATE PROCEDURE [dbo].[spLabTestAmendmentHistory_Post]
	@idfTestAmendmentHistory bigint,
	@datAmendmentDate datetime,
	@idfsOldTestResult bigint,
	@idfsNewTestResult bigint,
	@strOldNote nvarchar(500),
	@strNewNote nvarchar(500),
	@strReason nvarchar(500),
	@idfTesting bigint,
	@idfAmendByOffice bigint,
	@idfAmendByPerson bigint
AS
BEGIN
	SET NOCOUNT ON;

	if @idfTestAmendmentHistory is null return -1;

	if not exists(select idfTestAmendmentHistory from tlbTestAmendmentHistory where idfTestAmendmentHistory = @idfTestAmendmentHistory)
	BEGIN
		INSERT INTO [dbo].[tlbTestAmendmentHistory]
				   (
				    [idfTestAmendmentHistory]
				   ,[idfTesting]
				   ,[idfAmendByOffice]
				   ,[idfAmendByPerson]
				   ,[datAmendmentDate]
				   ,[idfsOldTestResult]
				   ,[idfsNewTestResult]
				   ,[strOldNote]
				   ,[strNewNote]
				   ,[strReason]
				   )
			 VALUES
				   (
				    @idfTestAmendmentHistory
				   ,@idfTesting
				   ,@idfAmendByOffice
				   ,@idfAmendByPerson
				   ,@datAmendmentDate
				   ,@idfsOldTestResult
				   ,@idfsNewTestResult
				   ,@strOldNote
				   ,@strNewNote
				   ,@strReason
				   )
	END
	ELSE
	BEGIN
		UPDATE [dbo].[tlbTestAmendmentHistory]
		   SET 
			   [idfTesting] = @idfTesting
			  ,[idfAmendByOffice] = @idfAmendByOffice
			  ,[idfAmendByPerson] = @idfAmendByPerson
			  ,[datAmendmentDate] = @datAmendmentDate
			  ,[idfsOldTestResult] = @idfsOldTestResult
			  ,[idfsNewTestResult] = @idfsNewTestResult
			  ,[strOldNote] = @strOldNote
			  ,[strNewNote] = @strNewNote
			  ,[strReason] = @strReason
		 WHERE 
			[idfTestAmendmentHistory] = @idfTestAmendmentHistory

	END
	DELETE FROM tlbTestValidation 
	WHERE idfTesting = @idfTesting AND intRowStatus=0
END

