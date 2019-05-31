

-- =============================================
-- Author:		Leonov E.N.
-- =============================================
CREATE PROCEDURE dbo.spFFGetDeterminantTypes
(
	@idfsFormType Bigint = Null
	,@LangID Nvarchar(50) = Null
)	
AS
BEGIN	
	Set Nocount On;

	If (@LangID Is Null) Set @LangID = 'en';
	
	Select [idfDeterminantType]
			  ,[idfsReferenceType]
			  ,[idfsGISReferenceType]
			  ,[idfsFormType]
			  ,[intOrder]		  
	From [dbo].[ffDeterminantType]	
	Where 
	(([idfsFormType] = @idfsFormType) Or (@idfsFormType Is Null)) 

End


