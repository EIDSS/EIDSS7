
-- ================================================================================================
-- Name: USP_ADMIN_FF_ActualTemplate_GET
-- Description: Retrieves the list of Activity Parameters
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- Kishore Kodru     1/6/2019  Removed Output parameter instead returning in the Select 
-- Samples
/*
	exec dbo.spFFGetActualTemplate 2340000000, 41530000000, 10034019
	exec dbo.spFFGetActualTemplate 780000000, 500000000, 10034010
	exec dbo.spFFGetActualTemplate 780000000, 0, 10034010
	exec dbo.spFFGetActualTemplate 170000000, 0, 10034010
*/
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ActualTemplate_GET] 
(
	@idfsGISBaseReference BIGINT = NULL
	,@idfsBaseReference BIGINT = NULL
	,@idfsFormType BIGINT
	,@blnReturnTable BIT = 1
	)
AS
BEGIN
	DECLARE
		@idfsFormTemplate BIGINT,
		@IsUNITemplate BIT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY   
		SET @IsUNITemplate = 0

		IF (@idfsGISBaseReference IS NULL)
		SELECT @idfsGISBaseReference = dbo.fnCustomizationCountry()

		SELECT @idfsFormTemplate = COALESCE(fft1.[idfsFormTemplate], 
											fft2_uni.[idfsFormTemplate], fft2.[idfsFormTemplate], 
											fft3_uni.[idfsFormTemplate], fft3.[idfsFormTemplate], 
											fft4.[idfsFormTemplate], fft5.[idfsFormTemplate], fft6.[idfsFormTemplate])
		FROM [ffFormTemplate] AS fft1
		INNER JOIN [ffDeterminantValue] AS dv11 
		ON fft1.[idfsFormTemplate] = dv11.[idfsFormTemplate]
		   AND dv11.[idfsBaseReference] = @idfsBaseReference
		   AND dv11.intRowStatus = 0
		INNER JOIN [ffDeterminantValue] AS dv12	
		ON fft1.[idfsFormTemplate] = dv12.[idfsFormTemplate]
		   AND dv12.[idfsGISBaseReference] = @idfsGISBaseReference
		   AND dv12.intRowStatus = 0
		   AND (fft1.[idfsFormType] = @idfsFormType)
		   AND fft1.intRowStatus = 0
		FULL JOIN (SELECT fft2_uni.[idfsFormTemplate]
				   FROM [ffFormTemplate] AS fft2_uni
				   LEFT JOIN [ffDeterminantValue] AS dv21_uni
				   ON fft2_uni.[idfsFormTemplate] = dv21_uni.[idfsFormTemplate]
					  AND dv21_uni.[idfsBaseReference] IS NOT NULL
					  AND dv21_uni.intRowStatus = 0
				   INNER JOIN [ffDeterminantValue] AS dv22_uni
				   ON fft2_uni.[idfsFormTemplate] = dv22_uni.[idfsFormTemplate]
					  AND dv22_uni.[idfsGISBaseReference] = @idfsGISBaseReference
					  AND dv22_uni.intRowStatus = 0
				   WHERE fft2_uni.[blnUNI] = 1
						 AND (fft2_uni.[idfsFormType] = @idfsFormType
							  AND dv21_uni.[idfDeterminantValue] IS NULL)
						 AND fft2_uni.intRowStatus = 0) AS fft2_uni
		ON 1=1
		FULL JOIN (SELECT fft2.[idfsFormTemplate]
				   FROM [ffFormTemplate] AS fft2
				   LEFT JOIN [ffDeterminantValue] AS dv21 
				   ON fft2.[idfsFormTemplate] = dv21.[idfsFormTemplate]
					  AND dv21.[idfsBaseReference] IS NOT NULL 
					  AND dv21.intRowStatus = 0
				   INNER JOIN [ffDeterminantValue] AS dv22 
				   ON fft2.[idfsFormTemplate] = dv22.[idfsFormTemplate]
					  AND dv22.[idfsGISBaseReference] = @idfsGISBaseReference
					  AND dv22.intRowStatus = 0
				   WHERE (fft2.[idfsFormType] = @idfsFormType
						  AND dv21.[idfDeterminantValue] IS NULL)
						 AND fft2.intRowStatus = 0) AS fft2
		ON 1=1
		FULL JOIN (SELECT fft3_uni.[idfsFormTemplate]
				   FROM [ffFormTemplate] AS fft3_uni
				   LEFT JOIN [ffDeterminantValue] AS dv32_uni 
				   ON fft3_uni.[idfsFormTemplate] = dv32_uni.[idfsFormTemplate]
					  AND dv32_uni.[idfsGISBaseReference] IS NOT NULL
					  AND dv32_uni.intRowStatus = 0 
				   INNER JOIN [ffDeterminantValue] AS dv31_uni 
				   ON fft3_uni.[idfsFormTemplate] = dv31_uni.[idfsFormTemplate]
					  AND dv31_uni.[idfsBaseReference] = @idfsBaseReference
					  AND dv31_uni.intRowStatus = 0
				   WHERE fft3_uni.[blnUNI] = 1
						 AND (fft3_uni.[idfsFormType] = @idfsFormType
							  AND dv32_uni.[idfDeterminantValue] IS NULL)
						 AND fft3_uni.intRowStatus = 0) AS fft3_uni
		ON 1=1
		FULL JOIN (SELECT fft3.[idfsFormTemplate]
				   FROM [ffFormTemplate] AS fft3
				   LEFT JOIN [ffDeterminantValue] AS dv32 
				   ON fft3.[idfsFormTemplate] = dv32.[idfsFormTemplate]
					  AND dv32.[idfsGISBaseReference] IS NOT NULL
					  AND dv32.intRowStatus = 0 
				   INNER JOIN [ffDeterminantValue] AS dv31 
				   ON fft3.[idfsFormTemplate] = dv31.[idfsFormTemplate]
					  AND dv31.[idfsBaseReference] = @idfsBaseReference 
					  AND dv31.intRowStatus = 0
				   WHERE (fft3.[idfsFormType] = @idfsFormType
						  AND dv32.[idfDeterminantValue] IS NULL)
						 AND fft3.intRowStatus = 0) AS fft3
		ON 1=1
		FULL JOIN (SELECT fft4.[idfsFormTemplate]
				   FROM [ffFormTemplate] AS fft4
				   INNER JOIN [ffDeterminantValue] AS dv42 
				   ON fft4.[idfsFormTemplate] = dv42.[idfsFormTemplate]
					  AND dv42.[idfsGISBaseReference] = @idfsGISBaseReference
					  AND dv42.intRowStatus = 0
				   WHERE fft4.[blnUNI] = 1
						 AND fft4.[idfsFormType] = @idfsFormType
						 AND fft4.intRowStatus = 0) AS fft4
		ON 1=1
		FULL JOIN (SELECT fft5.[idfsFormTemplate]
				   FROM [ffFormTemplate] AS fft5
				   LEFT JOIN [ffDeterminantValue] AS dv52 
				   ON fft5.[idfsFormTemplate] = dv52.[idfsFormTemplate]
					  AND dv52.[idfsGISBaseReference] IS NOT NULL
					  AND dv52.intRowStatus = 0
				   WHERE fft5.[blnUNI] = 1
						 AND fft5.[idfsFormType] = @idfsFormType
						 AND dv52.[idfDeterminantValue] IS NULL
						 AND fft5.intRowStatus = 0) AS fft5
		ON 1=1
		FULL JOIN (SELECT fft6.[idfsFormTemplate]
				   FROM [ffFormTemplate] AS fft6
				   WHERE blnUNI = 1
						 AND idfsFormType = @idfsFormType) AS fft6
		ON 1=1

		SELECT @IsUNITemplate = [blnUNI]
		FROM [ffFormTemplate] 
		WHERE [idfsFormTemplate] = @idfsFormTemplate
		
		IF (@idfsFormTemplate IS NULL)
			SET @idfsFormTemplate = -1;
		
		IF(@blnReturnTable = 1)
			SELECT @idfsFormTemplate AS [idfsFormTemplate]
				   ,@IsUNITemplate AS [IsUNITemplate]   
		
		--COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		--IF @@TRANCOUNT > 0
		--	ROLLBACK TRANSACTION;

		THROW;
	END CATCH;	
END


