/*******************************************************
NAME						: USP_CONF_DataArchiveSettings_Get		


Description					: Save Entries to [ArchiveSetting] For data Archive Settings

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					12/13/2018							Initial Created
			Select * from [ArchiveSetting]
			EXEC USP_ADMIN_CONF_DataArchiveSettings_SET 3809220000000,'12/2/2018','9:00:00 AM',1,1,'demo','demo'
*******************************************************/
CREATE PROCEDURE [dbo].[USP_ADMIN_CONF_DataArchiveSettings_SET]
	
			@ArchiveSettingUID              BIGINT = 0,
	    	@ArchiveBeginDate				DATETIME,
			@ArchiveScheduledStartTime		TIME,
			@DataAgeforArchiveInYears		INT, 
			@ArchiveFrequencyInDays			INT,
			@AuditCreateUser				VARCHAR(100)
			--@AuditUpdateUser				VARCHAR(100)
			--@AuditUpdateDTM					datetime		

AS BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;

	SET NOCOUNT ON;

	BEGIN TRY

		IF EXISTS(SELECT * from [dbo].[ArchiveSetting] WHERE [ArchiveSettingUID]  = @ArchiveSettingUID)
		BEGIN
				UPDATE [dbo].[ArchiveSetting]
				SET 
					[ArchiveBeginDate] = @ArchiveBeginDate,
					[ArchiveScheduledStartTime] = @ArchiveScheduledStartTime,
					[DataAgeforArchiveInYears] = @DataAgeforArchiveInYears,
					[ArchiveFrequencyInDays]  = @ArchiveFrequencyInDays,
					[AuditUpdateUser] = @AuditCreateUser,
					[AuditUpdateDTM] = GetDate()
				WHERE [ArchiveSettingUID]  = @ArchiveSettingUID
				SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage';
		END
		ELSE
		BEGIN
				DECLARE @ID BIGINT
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'ArchiveSetting', @ID OUTPUT
				Print @ID
				INSERT INTO  [dbo].[ArchiveSetting]
				(
					[ArchiveSettingUID],
					[ArchiveBeginDate], 
					[ArchiveScheduledStartTime], 
					[DataAgeforArchiveInYears], 
					[ArchiveFrequencyInDays], 
					[AuditCreateUser], 
					[AuditCreateDTM], 
					[AuditUpdateUser], 
					[AuditUpdateDTM]
				
				)
				VALUES
				(
					@ID
					,@ArchiveBeginDate				
					,@ArchiveScheduledStartTime		
					,@DataAgeforArchiveInYears		 
					,@ArchiveFrequencyInDays			
					,@AuditCreateUser				
					,GETDATE()					
					,@AuditCreateUser			
					,GETDATE()	
				)	
				SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage';
		END	
	END TRY
	BEGIN CATCH
			THROW
	END CATCH
END



