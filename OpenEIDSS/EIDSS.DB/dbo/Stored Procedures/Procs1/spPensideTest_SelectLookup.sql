
--##SUMMARY 

--##REMARKS Author: Leonov E.
--##REMARKS Create date: 10.11.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.02.2012

--##RETURNS Doesn't use


/*
--Example of procedure call:
exec spPensideTest_SelectLookup 'en', NULL
*/

CREATE      PROCEDURE dbo.spPensideTest_SelectLookup
(
	@LangID As nvarchar(50) --##PARAM @LangID - language ID	
)
AS
Begin
	SELECT 
			Matrix.[idfPensideTestTypeForVectorType]
			,Matrix.[idfsPensideTestName]
			,Matrix.[idfsVectorType]
			,VectorType.[intOrder]
			,Isnull(VectorType.[name], VectorType.strDefault) As [strVectorTypeName]
			,Isnull(TestType.[name], TestType.strDefault) As [strPensideTypeName]
			,Matrix.intRowStatus
	FROM 
		dbo.trtPensideTestTypeForVectorType Matrix
		Inner Join dbo.fnReference(@LangID, 19000140) VectorType On Matrix.idfsVectorType = VectorType.idfsReference
		Inner Join dbo.fnReference(@LangID, 19000104) TestType ON TestType.idfsReference = Matrix.idfsPensideTestName
	ORDER BY
		VectorType.[intOrder] Asc
end 
