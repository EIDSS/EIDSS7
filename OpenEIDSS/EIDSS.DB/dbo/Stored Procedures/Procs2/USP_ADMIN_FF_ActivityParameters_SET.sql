
-- ================================================================================================
-- Name: USP_ADMIN_FF_ActivityParameters_SET
-- Description: Save the Activity Parameters
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- Lamont/Kishore   1/6/2019   Renamed output variables to work with POCO.
-- Kishore Kodru	1/17/2019  Changed the USP_GBL_NextKeyID and added BEGIN TRANSACTION
-- ================================================================================================
--[dbo].[USP_ADMIN_FF_ActivityParameters_SET] 6724140000000, 1, 3022590000000, 'Kodru', 0, 0, NULL
--[dbo].[USP_ADMIN_FF_ActivityParameters_SET] 6809750000000, 1, 3022590000000, 'Hello', 0,0, NULL
--[dbo].[USP_ADMIN_FF_ActivityParameters_SET] 6809710000000, 1, 3022590000000, 'World', 0,0, NULL

--[dbo].[USP_ADMIN_FF_ActivityParameters_SET] 6724060000000, 1, 3022590000000, '25460000000', 0,0, NULL
--[dbo].[USP_ADMIN_FF_ActivityParameters_SET] 6809630000000, 1, 3022590000000, '25460000000', 0,0, NULL


CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ActivityParameters_SET] 
(
	@idfsParameter BIGINT
	,@idfObservation BIGINT  
	,@idfsFormTemplate BIGINT   
    ,@varValue SQL_VARIANT
    ,@IsDynamicParameter BIT = 0
	,@idfRow BIGINT = NULL --was output
	,@idfActivityParameters BIGINT = NULL -- was output
)	
AS
BEGIN	
	SET NOCOUNT ON;	

	DECLARE
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'   ;
		
		Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)    
	
	BEGIN TRY	
		BEGIN TRANSACTION	
			IF (@IsDynamicParameter = 0)
			BEGIN
				If NOT EXISTS(SELECT TOP 1 1 
							  FROM dbo.ffParameterForTemplate
							  WHERE idfsParameter = @idfsParameter
									AND idfsFormTemplate = @idfsFormTemplate
									AND intRowStatus = 0)
					RETURN;
			END;

			IF NOT EXISTS (SELECT TOP 1 1 
						   FROM dbo.tlbObservation 
						   WHERE idfObservation = @idfObservation)
				RETURN;

			IF (@idfRow < 0)
			BEGIN
				DECLARE @idSection BIGINT
		
				SELECT @idSection = [idfsSection] 
				FROM dbo.ffParameter
				WHERE idfsParameter = @idfsParameter;
		
				DECLARE @isSectionTable BIT
				SET @isSectionTable = 0;

				IF (@idSection IS NOT NULL)
					BEGIN
						SELECT @isSectionTable = [blnGrid]
						FROM dbo.ffSection
						WHERE idfsSection = @idSection;

						IF (@isSectionTable = 1)
							BEGIN
								INSERT INTO @SupressSelect
								EXEC dbo.[usp_sysGetNewID] @idfRow OUTPUT
							END 
						ELSE
							BEGIN
								SET @idfRow = 0;     	
							END
					END 
				ELSE
					BEGIN
						SET @idfRow = 0;     	
					END
			END

			IF ((@varValue IS NULL) OR (LEN(CAST(@varValue AS VARCHAR(MAX))) = 0)) 
				BEGIN
					EXEC dbo.USP_ADMIN_FF_ActivityParameters_DEL @idfsParameter, @idfObservation, @idfRow                                                  	
				END
			ELSE 
				BEGIN	
					IF NOT EXISTS (SELECT TOP 1 1 
								   FROM dbo.tlbActivityParameters
								   WHERE [idfsParameter] = @idfsParameter
										 AND [idfObservation] = @idfObservation
										 AND [idfRow] = @idfRow)
						BEGIN
					 
							IF @idfActivityParameters IS NULL
							BEGIN
								INSERT INTO @SupressSelect
								EXEC USP_GBL_NEXTKEYID_GET 'tlbActivityParameters', @idfActivityParameters OUTPUT
							END
					 
								INSERT INTO [dbo].[tlbActivityParameters]
								(
									idfActivityParameters
			   						,[idfsParameter]
									,[idfObservation]
									,[varValue]
									,[idfRow]		
								)
								VALUES
								(
									@idfActivityParameters
									,@idfsParameter
									,@idfObservation
									,@varValue
									,@idfRow
								)
						END
					ELSE
						BEGIN
							UPDATE [dbo].[tlbActivityParameters]
							SET [varValue] = @varValue
								,[intRowStatus] = 0									
							WHERE [idfsParameter] = @idfsParameter
								  AND [idfObservation] = @idfObservation
								  AND [idfRow] = @idfRow
						END
				END	
			
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' ,@idfActivityParameters 'idfActivityParameters' , @idfRow 'idfRow'
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
