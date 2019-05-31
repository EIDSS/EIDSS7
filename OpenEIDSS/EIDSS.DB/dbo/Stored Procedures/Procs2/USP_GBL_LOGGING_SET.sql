/*******************************************************
NAME						:[dbo].[USP_GBL_LOGGING_SET]	


Description					: Creates log entries into dotNetAppenderLog

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					12/21/2018							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_GBL_LOGGING_SET]
				@LogDTM				DATETIME,		
				@ProcessThread		VARCHAR(255),
				@LogType			VARCHAR(100),
				@ClassName			VARCHAR(255),
				@ExceptionMessage	VARCHAR(MAX),
				@LogMessage			VARCHAR(MAX),
				@LogURL				VARCHAR(255),
				@StackTrace			VARCHAR(MAX),
				@AppSessionID		VARCHAR(100),
				@AppMethodObject	VARCHAR(255),
				@MethodInParms		VARCHAR(MAX),
				@MethodOutParms		VARCHAR(MAX),
				@AuditCreateUser	VARCHAR(100),
				@AuditCreateDTM		DATETIME				

AS BEGIN
	

	SET NOCOUNT ON;

	INSERT INTO dbo.dotNetAppenderLog 
				(
				[LogDTM],
				[ProcessThread],
				[LogType],
				[ClassName],
				[ExceptionMessage],
				[LogMessage],
				[LogURL],
				[StackTrace],
				[AppSessionID],
				[AppMethodObject],
				[MethodInParms],
				[MethodOutParms],
				[AuditCreateUser],
				[AuditCreateDTM]
				) 
			VALUES 
			(
			     @LogDTM						
				,@ProcessThread		
				,@LogType			
				,@ClassName			
				,@ExceptionMessage
				,@LogMessage
				,@LogURL	
				,@StackTrace			
				,@AppSessionID	
				,@AppMethodObject	
				,@MethodInParms	
				,@MethodOutParms		
				,@AuditCreateUser	
				,@AuditCreateDTM	
				)
				
	
END



