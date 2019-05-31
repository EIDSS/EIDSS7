/*******************************************************
NAME						: USP_ADMIN_CONF_DataArchiveSettings_Get	


Description					: Retreives Entries from [[ArchiveSetting]] For data Archive Settings

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					12/13/2018							Initial Created
			EXEC USP_ADMIN_CONF_DataArchiveSettings_Get

--          LJM                            12/31/2019 		     	included intRowStatus as filter 
										   04/01/19					Changed description
*******************************************************/
CREATE PROCEDURE [dbo].[USP_ADMIN_CONF_DataArchiveSettings_Get]
	
	    			

AS BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';

	SET NOCOUNT ON;

	BEGIN TRY
		SELECT 		
			[ArchiveSettingUID], 
			[ArchiveBeginDate], 
			[ArchiveScheduledStartTime], 
			[DataAgeforArchiveInYears], 
			[ArchiveFrequencyInDays], 
			[intRowStatus], 
			[AuditCreateUser], 
			[AuditCreateDTM], 
			[AuditUpdateUser], 
			[AuditUpdateDTM]
		FROM [dbo].[ArchiveSetting] where intRowStatus = 0
		
			
	END TRY
	BEGIN CATCH
			THROW
	END CATCH
END
--Delete from [ArchiveSetting]


