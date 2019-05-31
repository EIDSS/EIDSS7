
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterTypes_FILTER
-- Description: EIDSS7 SCUC20_Usecase Filters the columns DefaultName and NationalName that contains the searchString. 
--         
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterTypes_FILTER]
(
	@LangID NVARCHAR(50) = NULL
	,@searchString VARCHAR(100) = NULL
)	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)       
	
	BEGIN TRY
		IF (@LangID IS NULL)
			SET @LangID = 'en';
		IF (@searchString IS NULL)
			SET @searchString = '';
		SET @searchString = '%' + @searchString + '%'

SELECT idfsParameterType,
		DefaultName,
		NationalName,
		idfsReferenceType,
		System,
		LangID
FROM 
		(SELECT 
			idfsParameterType	
			,RT.strDefault AS [DefaultName]
			,ISNULL(RT.name, RT.strDefault) AS [NationalName]
			,PT.idfsReferenceType
			,CASE ISNULL(PT.idfsReferenceType, -1) WHEN -1 
												   THEN '2'
												   WHEN 19000069
												   THEN '0'
												   ELSE '1'
			 END AS [System]
			,@LangID AS [LangID]
		FROM dbo.ffParameterType AS PT
		LEFT JOIN FN_GBL_Reference_List_GET(@LangID, 19000071 /*'rftParameterType'*/) AS RT
		ON RT.idfsReference = PT.idfsParameterType
		WHERE RT.strDefault LIKE @searchString
			  OR ISNULL(RT.name, RT.strDefault) LIKE @searchString
			  AND (PT.intRowStatus = 0)
		) A
		WHERE System <> 2
		ORDER BY NationalName			
		
	END TRY
	BEGIN CATCH

		THROW;
	END CATCH
END
