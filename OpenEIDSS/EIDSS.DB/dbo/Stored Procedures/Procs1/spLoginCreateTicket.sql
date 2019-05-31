
CREATE PROCEDURE [dbo].[spLoginCreateTicket]
	@idfUserID bigint,
	@strTicket nvarchar(100) output,
	@Result int output
AS
SET @Result = 1
BEGIN TRAN

	SET @strTicket = NEWID()
	IF EXISTS(SELECT * FROM tstUserTicket WHERE strTicket = @strTicket)
		UPDATE tstTicket 
		SET 
			tatExpirationDate = GETDATE(),
			idfUserID = @idfUserID
		WHERE strTicket = @strTicket
	ELSE
		INSERT INTO tstUserTicket
		(
			strTicket,
			idfUserID,
			datExpirationDate
		)
		VALUES
		(
			@strTicket,
			@idfUserID,
			GETDATE()
		)
	SET @Result = 0
COMMIT TRAN
RETURN 0

