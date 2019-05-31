
CREATE PROCEDURE [dbo].[spCollectionMethod_SelectLookup]
(
	@LangID As nvarchar(50)
	,@idfsVectorType bigint
)
As
Begin
	
 SELECT 
	 CM.[idfCollectionMethodForVectorType]
      ,CM.[idfsCollectionMethod]
      ,CM.[idfsVectorType]
      ,Isnull(CMT.name, CMT.strDefault) as [CMName]
      ,Isnull(VT.name, VT.strDefault) as [VTName]
      ,CM.intRowStatus
  FROM dbo.trtCollectionMethodForVectorType CM
  Inner Join dbo.fnReference(@LangID, 19000135) CMT On CM.idfsCollectionMethod = CMT.idfsReference
  Inner Join dbo.fnReference(@LangID, 19000140) VT On CM.idfsVectorType = VT.idfsReference
 Where CM.intRowStatus = 0 and CM.[idfsVectorType] = @idfsVectorType
 Order By CMT.[name], CMT.strDefault 
 
End
