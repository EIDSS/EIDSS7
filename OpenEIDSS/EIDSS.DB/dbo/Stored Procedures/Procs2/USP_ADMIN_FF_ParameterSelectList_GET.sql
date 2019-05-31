
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterSelectList_GET
-- Description: Return list of Parameters Select List
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- Samples
 /*
exec dbo.spFFGetParameterSelectList 'en', 229630000000
exec dbo.spFFGetParameterSelectList1 'en', 229630000000
 */
-- ================================================================================================

 CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterSelectList_GET]
 (
 	@LangID NVARCHAR(50) = NULL	
 	,@idfsParameter BIGINT
 	,@idfsParameterType BIGINT = NULL
 	,@intHACode BIGINT = NULL
 )	
 AS
 BEGIN	
 	SET NOCOUNT ON;	
 
 	IF (@LangID IS NULL)
		SET @LangID = 'en'
 
    DECLARE
		@idfsReferenceType BIGINT,
		@aggParam BIT, 
 		@idfsFormType BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY
     
		IF (@idfsParameterType IS NULL) 
			BEGIN
 				SELECT TOP 1 @idfsParameterType = p.idfsParameterType
 				FROM ffParameter p
 				INNER JOIN dbo.ffParameterType pt 
 				ON p.idfsParameterType = pt.idfsParameterType 
 				   AND pt.[intRowStatus] = 0    
 				WHERE [idfsParameter] = @idfsParameter 
 					  AND p.[intRowStatus] = 0
 			END
 		
		SELECT TOP 1 @idfsReferenceType = [idfsReferenceType]
 		FROM dbo.ffParameterType
 		WHERE [idfsParameterType] = @idfsParameterType 
 			  AND [intRowStatus] = 0
	
 		SET @aggParam = 0
 	
 		SELECT @idfsFormType = idfsFormType 
 		FROM dbo.ffParameter 
 		WHERE idfsParameter = @idfsParameter 
 			  AND intRowStatus = 0
 	
 		IF ((@idfsFormType = 10034012) OR 
 			(@idfsFormType = 10034021) OR 
 			(@idfsFormType = 10034022) OR 
 			(@idfsFormType = 10034023) OR 
 			(@idfsFormType = 10034024))	
			SET @aggParam = 1 
 		ELSE	
 			SET @aggParam = 0
     
		IF (@idfsReferenceType = 19000069 /*'rftParametersFixedPresetValue'*/) 
			BEGIN       
     			PRINT 1
 				SELECT p.idfsParameter AS [idfsParameter]
 					   ,p.idfsParameterType AS [idfsParameterType]
 				       ,CAST(19000069 AS BIGINT)/*'rftParametersFixedPresetValue'*/	AS [idfsReferenceType]
 				       ,fpv.idfsParameterFixedPresetValue AS [idfsValue]
 				       ,CAST(fr.LongName AS NVARCHAR(300)) AS [strValueCaption]
 				       ,@LangID AS [langid] 
 				       ,fr.intOrder AS [intOrder]
 				       ,fr.intHACode AS [intHACode]
 				       ,p.[intRowStatus] AS [intRowStatus]
 				FROM dbo.ffParameter p
 				INNER JOIN dbo.ffParameterFixedPresetValue fpv 
 				ON p.idfsParameterType = fpv.idfsParameterType 
 				   AND fpv.[intRowStatus] = 0
 				INNER JOIN dbo.FN_GBL_Reference_List_GET(@LangID, 19000069 /*'rftParametersFixedPresetValue'*/) fr 
 				ON fpv.idfsParameterFixedPresetValue = fr.idfsReference
 				WHERE p.idfsParameter = @idfsParameter
				ORDER BY fr.intOrder ASC, fr.LongName ASC
			END 
		ELSE 
			IF (@idfsReferenceType IS NOT NULL) 
				BEGIN
					IF (@idfsReferenceType = 19000019) 
						BEGIN
          					IF (@aggParam = 1) 
          						BEGIN
 									SELECT @idfsParameter AS [idfsParameter]
 										   ,@idfsParameterType AS [idfsParameterType]
 										   ,@idfsReferenceType AS [idfsReferenceType]
 										   ,idfsReference AS [idfsValue]
 										   ,CAST([name]	AS NVARCHAR(300)) AS [strValueCaption]
 										   ,@LangID AS [langid] 
 										   ,intOrder AS [intOrder]
 										   ,intHACode AS [intHACode]
 										   ,CAST((CASE WHEN d.idfsUsingType = 10020002 
 										   			   THEN 0 
 										   			   ELSE 1 
 													   END)	AS INT)	AS intRowStatus
 										   --,d.idfsUsingType		as idfsUsingType
 									FROM dbo.FN_GBL_ReferenceRepair(@LangID, @idfsReferenceType)	 rl
 									INNER JOIN dbo.trtDiagnosis d 
 									ON rl.idfsReference = d.idfsDiagnosis
 									ORDER BY intOrder ASC, [name] ASC
 			
          						END -- if (@aggParam = 1) 
          					ELSE -- if (@aggParam = 0) 
          						BEGIN
 									SELECT @idfsParameter AS [idfsParameter]
 										   ,@idfsParameterType AS [idfsParameterType]
 										   ,@idfsReferenceType AS [idfsReferenceType]
 										   ,idfsReference AS [idfsValue]
 										   ,CAST([name]	AS NVARCHAR(300)) AS [strValueCaption]
 										   ,@LangID	AS [langid] 
 										   ,intOrder AS [intOrder]
 										   ,intHACode AS [intHACode]
 										   ,CAST((CASE WHEN(D.idfsUsingType = 10020001							
 															AND D.intRowStatus = 0
 															AND RL.intRowStatus = 0
 															AND	(@intHACode = 0
 																 OR @intHACode IS NULL
 																 OR intHACode IS NULL
																 --1=animal, 32=LiveStock , 64=avian
 											--below we assume that client will never pass animal bit without livstock or avian bits
 																 OR	CASE WHEN (RL.intHACode & 97) > 1
 																		 THEN (~1 & RL.intHACode) & @intHACode 
 													-- if avian or livstock bits are set, clear animal bit in  b.intHA_Code
 																		 WHEN (RL.intHACode & 97) = 1 
 																		 THEN (~1 & RL.intHACode | 96) & @intHACode
 													--if only animal bit is set, 
 													--clear animal bit and set both avian and livstock bits in  b.intHA_Code
 																		 ELSE RL.intHACode & @intHACode
 																		 END >0)
 															)
															THEN 0
															ELSE 1
															END) AS INT) AS intRowStatus
 					  ---,D.idfsUsingType
 									FROM dbo.FN_GBL_ReferenceRepair(@LangID, @idfsReferenceType)	RL
 									INNER JOIN dbo.trtDiagnosis D
									ON RL.idfsReference = D.idfsDiagnosis		
 									ORDER BY intOrder ASC, [name] ASC
 								END
						END --if (@idfsReferenceType = 19000019) 
					ELSE
						BEGIN  --if (@idfsReferenceType <> 19000019)                	
 							SELECT @idfsParameter AS [idfsParameter]
 								   ,@idfsParameterType AS [idfsParameterType]
 								   ,@idfsReferenceType AS [idfsReferenceType]
 								   ,idfsReference AS [idfsValue]
 								   ,CAST([name]AS NVARCHAR(300)) AS [strValueCaption]
 								   ,@LangID	AS [langid] 
 								   ,ISNULL([intOrder], 0) AS [intOrder]
 								   ,intHACode AS [intHACode]
 								   ,intRowStatus AS [intRowStatus]
 							FROM dbo.FN_GBL_ReferenceRepair(@LangID, @idfsReferenceType)
 							ORDER BY intOrder ASC, [name] ASC
 						END
				END --if (@idfsReferenceType is Not null) 
			ELSE
				SELECT CAST(0 AS BIGINT) AS [idfsParameter]
 					   ,CAST(0 AS BIGINT) AS [idfsParameterType]
 					   ,CAST(0 AS BIGINT) AS [idfsReferenceType]
 					   ,CAST(0 AS BIGINT) AS [idfsValue]
 					   ,CAST('' AS NVARCHAR(300)) AS [strValueCaption]
 					   ,@LangID AS [langid]
 					   ,CAST(0 AS INT) AS [intOrder]
 					   ,CAST(0 AS INT) AS [intHACode]
 					   ,CAST(0 AS INT) AS intRowStatus	
				WHERE NULL = NULL
				
		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;     
 END

