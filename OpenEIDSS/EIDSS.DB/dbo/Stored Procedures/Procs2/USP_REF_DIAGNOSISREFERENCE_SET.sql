-- ============================================================================
-- Name: USP_REF_DIAGNOSISREFERENCE_SET
-- Description:	Check to see if a diagnosis currently exists by name
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/28/2018 Initial release.
-- Ricky Moss		02/10/2019	Checks to see when updating a case classification that the name does not exists in another reference and updates English value
--
-- exec USP_REF_DIAGNOSISREFERENCE_SET NULL, 'Test Locally', 'Test Locally', '', '', 98, 10020001, 6619250000000, 6618870000000, '781320000000,782030000000,783200000000,783350000000,783480000000,783490000000', 1, 1, 'en', 0
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_DIAGNOSISREFERENCE_SET] 
(
	@idfsDiagnosis BIGINT = NULL,
	@strDefault VARCHAR(200),
	@strName  NVARCHAR(200),
	@strOIECode  NVARCHAR(200),
	@strIDC10  NVARCHAR(200),
	@intHACode INT,
	@idfsUsingType BIGINT,
	@strPensideTest NVARCHAR(MAX),
	@strLabTest NVARCHAR(MAX),
	@strSampleType NVARCHAR(MAX),
	@blnZoonotic BIT = 0,
	@blnSyndrome BIT = 0,
	@LangID  NVARCHAR(50),
	@intOrder INT
)
AS
BEGIN
DECLARE @returnCode			INT				= 0 
DECLARE	@returnMsg			NVARCHAR(max)	= 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
DECLARE @tempPensideTestToDisease TABLE  (idfsPensideTestName BIGINT)
DECLARE @tempTestToDisease TABLE (idfsTestName BIGINT) 
DECLARE @tempSampleTypeToDisease TABLE (idfsSampleType BIGINT) 
DECLARE @idfTestForDisease BIGINT
DECLARE @idfsTestName BIGINT
DECLARE @idfPensideTestForDisease BIGINT
DECLARE @idfsPensideTestName BIGINT
DECLARE @idfMaterialForDisease BIGINT
DECLARE @idfsSampleType BIGINT

BEGIN TRY 
	IF (EXISTS(SELECT idfsBaseReference from trtBaseReference where strDefault = @strDefault AND idfsReferenceType = 19000019 AND intRowStatus = 0) AND @idfsDiagnosis IS NULL) OR (EXISTS(SELECT idfsBaseReference from trtBaseReference where strDefault = @strDefault AND idfsReferenceType = 19000019 AND intRowStatus = 0 AND idfsBaseReference <> @idfsDiagnosis) AND @idfsDiagnosis IS NOT NULL)
	BEGIN
		SELECT @idfsDiagnosis = (SELECT idfsBaseReference from trtBaseReference where strDefault = @strDefault AND idfsReferenceType = 19000019)
		SELECT @returnMsg = 'DOES EXIST'
	END
	ELSE IF EXISTS(SELECT idfsBaseReference from trtBaseReference where idfsBaseReference = @idfsDiagnosis) and EXISTS(SELECT idfsDiagnosis from trtDiagnosis where idfsDiagnosis = @idfsDiagnosis)
	BEGIN
		UPDATE trtDiagnosis
				SET 
						idfsUsingType = @idfsUsingType
						,strIDC10 = @strIDC10
						,strOIECode = @strOIECode
						,blnZoonotic = ISNULL(@blnZoonotic,0)
						,blnSyndrome = ISNULL(@blnSyndrome,0)
                WHERE	idfsDiagnosis = @idfsDiagnosis

		UPDATE trtBaseReference
			SET strDefault = @strDefault,
				intOrder = @intOrder,
				intHACode = @intHACode			
            WHERE	idfsBaseReference = @idfsDiagnosis

		UPDATE dbo.[trtStringNameTranslation]
		SET 
			strTextString = @strName
		WHERE idfsBaseReference = @idfsDiagnosis AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
	END
	ELSE
	BEGIN		
		INSERT INTO @SupressSelect	
		EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsDiagnosis OUTPUT;	

		EXEC dbo.USP_GBL_BaseReference_SET @idfsDiagnosis, 19000019, @LangID, @strDefault, @strName, @intHACode, @intOrder

		INSERT INTO trtDiagnosis
		(	
			idfsDiagnosis
			,idfsUsingType
			,strIDC10
			,strOIECode
			,blnZoonotic
			,blnSyndrome
		) 
        VALUES  
		(
			@idfsDiagnosis
			,@idfsUsingType
			,@strIDC10
			,@strOIECode
			,ISNULL(@blnZoonotic,0)
			,ISNULL(@blnSyndrome,0)
		)
	
	END	

	IF @strLabTest IS NOT NULL
	BEGIN
		UPDATE trtTestforDisease
		SET intRowStatus = 1
		WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0
	--convert comma separate string into table
		INSERT INTO @tempTestToDisease SELECT VALUE AS idfsTestName FROM STRING_SPLIT(@strLabTest,',');

		WHILE(SELECT COUNT(idfsTestName) FROM @tempTestToDisease) > 0
		BEGIN
			SELECT @idfsTestName = (SELECT TOP 1 (idfsTestName) FROM @tempTestToDisease)
			
			--creates new test for disease
			IF NOT EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsTestName = @idfsTestName)
			BEGIN
				INSERT INTO @SupressSelect
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtTestForDisease', @idfTestForDisease OUTPUT;
				INSERT INTO trtTestForDisease (idfTestForDisease, idfsTestName, idfsDiagnosis, intRowStatus) VALUES(@idfTestForDisease, @idfsTestName, @idfsDiagnosis, 0)
			END
			ELSE IF EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsTestName = @idfsTestName)
			BEGIN
				UPDATE trtTestForDisease SET intRowStatus = 0 WHERE idfsDiagnosis = @idfsDiagnosis AND idfsTestName = @idfsTestName
			END
			DELETE FROM @tempTestToDisease WHERE idfsTestName = @idfsTestName
		END
	END
	ELSE
	BEGIN
		UPDATE trtTestforDisease
		SET intRowStatus = 1
		WHERE idfsDiagnosis = @idfsDiagnosis 
	END 

	IF @strPensideTest IS NOT NULL
	BEGIN
		INSERT INTO @tempPensideTestToDisease SELECT VALUE FROM STRING_SPLIT(@strPensideTest,',');
		
		--deactive penside tests for disease are not part of strPensideTest value 
		UPDATE trtPensideTestForDisease SET intRowStatus = 1
		WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0
		
		WHILE (SELECT COUNT(idfsPensideTestName) FROM @tempPensideTestToDisease) > 0
		BEGIN
			SELECT @idfsPensideTestName = (SELECT TOP 1(idfsPensideTestName) FROM @tempPensideTestToDisease)
			
			IF NOT EXISTS(SELECT idfsPensideTestName FROM trtPensideTestForDisease where idfsDiagnosis = @idfsDiagnosis AND idfsPensideTestName = @idfsPensideTestName AND intRowStatus = 0)
			BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtPensideTestForDisease', @idfPensideTestForDisease OUTPUT;

			INSERT INTO trtPensideTestForDisease (idfPensideTestForDisease, idfsPensideTestName, idfsDiagnosis, intRowStatus) VALUES (@idfPensideTestForDisease, @idfsPensideTestName, @idfsDiagnosis, 0)
			INSERT INTO trtPensideTestForDiseaseToCP (idfPensideTestForDisease, idfCustomizationPackage) VALUES ( @idfPensideTestForDisease, dbo.FN_GBL_CustomizationPackage_GET())
			END
			ELSE IF EXISTS(SELECT idfsPensideTestName FROM trtPensideTestForDisease where idfsDiagnosis = @idfsDiagnosis AND idfsPensideTestName = @idfsPensideTestName)
			BEGIN
				UPDATE trtPensideTestForDisease SET intRowStatus = 0
				WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0 AND idfsPensideTestName = @idfsPensideTestName
			END
			DELETE FROM @tempPensideTestToDisease WHERE idfsPensideTestName = @idfsPensideTestName
		END
	END
	ELSE
	BEGIN		
		UPDATE trtPensideTestforDisease
		SET intRowStatus = 1
		WHERE idfsDiagnosis = @idfsDiagnosis
	END

	IF @strSampleType IS NOT NULL
	BEGIN
		INSERT INTO @tempSampleTypeToDisease SELECT VALUE as idfsSampleType FROM STRING_SPLIT(@strSampleType, ',');

		--removes common records for temp table that will not need change 
		DELETE FROM @tempSampleTypeToDisease WHERE @idfsSampleType IN(
		SELECT idfsSampleType FROM trtMaterialForDisease where idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0
		INTERSECT
		SELECT idfsSampleType FROM @tempSampleTypeToDisease)
		
		--deactive penside tests for disease are not part of strPensideTest value 
		UPDATE trtMaterialForDisease SET intRowStatus = 1
		WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType IN (
		SELECT idfsSampleType FROM trtMaterialForDisease WHERE idfsDiagnosis = @idfsDiagnosis	
		EXCEPT
		SELECT idfsSampleType FROM @tempSampleTypeToDisease)

		WHILE(SELECT COUNT(idfsSampleType) FROM @tempSampleTypeToDisease) > 0
		BEGIN
			SELECT @idfsSampleType = (SELECT TOP 1 (idfsSampleType) FROM @tempSampleTypeToDisease)
			
			IF NOT EXISTS(SELECT idfMaterialForDisease FROM trtMaterialForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType = @idfsSampleType AND intRowStatus = 0)
			BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtMaterialForDisease', @idfMaterialForDisease OUTPUT;

			INSERT INTO trtMaterialForDisease (idfMaterialForDisease, idfsSampleType, idfsDiagnosis, intRowStatus) VALUES(@idfMaterialForDisease, @idfsSampleType, @idfsDiagnosis, 0)
			END
			DELETE FROM @tempSampleTypeToDisease WHERE idfsSampleType = @idfsSampleType
		END
	END
	ELSE
	BEGIN
		UPDATE trtMaterialforDisease
		SET intRowStatus = 1
		WHERE idfsDiagnosis = @idfsDiagnosis
	END
	SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfsDiagnosis 'idfsDiagnosis'
END TRY
BEGIN CATCH
	THROW;
END CATCH
END