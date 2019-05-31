

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 29.09.09
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFGetReferenceTypesList
(
	@LangID Nvarchar(50) = Null
	,@idfsReferenceType Bigint
)	
AS
BEGIN	
	SET NOCOUNT ON;

	If (@LangID Is Null) Set @LangID = 'en';

	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);

	Declare @ResultTable Table 
	(
		[idfsBaseReference] Bigint	
		,[idfsReferenceType]	Bigint		
		,[DefaultName] Nvarchar(4000)
		,[NationalName]	Nvarchar(4000)	
		,[langid]	Nvarchar(50)
	)
	
	If (@idfsReferenceType <> 19000019) Begin
		Insert into @ResultTable
		(
			[idfsBaseReference]	
			,[idfsReferenceType]		
			,[DefaultName]
			,[NationalName]
			,[langid]
		)
		Select 
			R.idfsReference as  [idfsBaseReference]
			,R.idfsReferenceType			
			,R.strDefault As [DefaultName]
			,Isnull(R.[name], R.strDefault) As [NationalName]		
			,@LangID As [langid]	
		From dbo.fnReference(@LangID, @idfsReferenceType) R	
		Order By R.[name]			
	End Else BEGIN
	     Insert into @ResultTable
		(
			[idfsBaseReference]	
			,[idfsReferenceType]		
			,[DefaultName]
			,[NationalName]
			,[langid]
		)
		Select 
			R.idfsReference as  [idfsBaseReference]
			,R.idfsReferenceType			
			,R.strDefault As [DefaultName]
			,Isnull(R.[name], R.strDefault) As [NationalName]		
			,@LangID As [langid]	
		From dbo.fnReference(@LangID, @idfsReferenceType) R
		Inner Join dbo.trtDiagnosis D On 
			R.idfsReference = D.idfsDiagnosis 
			And D.intRowStatus = 0 
			And D.idfsUsingType = 10020001 
		Order By R.[name]    	
	END
	
	Select 
			[idfsBaseReference]	
			,[idfsReferenceType]		
			,[DefaultName]
			,[NationalName]
			,[langid]
	From @ResultTable		
End
