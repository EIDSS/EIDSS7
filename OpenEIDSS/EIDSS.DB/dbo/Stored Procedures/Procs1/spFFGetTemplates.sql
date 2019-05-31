﻿

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 21.09.09
-- Description:	Return list of Templates
-- =============================================
CREATE PROCEDURE dbo.spFFGetTemplates
(
	@LangID Nvarchar(50) = Null
	,@idfsFormTemplate Bigint = Null
	,@idfsFormType Bigint = Null
)	
AS
BEGIN	
	Set Nocount On;

	If (@LangID Is Null) Set @LangID = 'en';

    SELECT 
		FT.[idfsFormTemplate]
      ,FT.[idfsFormType]   
      ,FT.[blnUNI]   
      ,FT.[rowguid]
      ,FT.[intRowStatus]
      ,FT.strNote
      ,RF.[strDefault] As [DefaultName]
      ,RF.[name] As [NationalName]
      ,RF.[LongName] As [NationalLongName]
      ,@LangID As [langid]
  FROM [dbo].[ffFormTemplate] FT
		Inner Join dbo.fnReference(@LangID, 19000033 /*'rftFFTemplate'*/) RF On FT.[idfsFormTemplate] = RF.idfsReference
    Where
	((FT.[idfsFormTemplate] = @idfsFormTemplate ) Or (@idfsFormTemplate Is Null))
	And	
	((FT.[idfsFormType]  = @idfsFormType) Or (@idfsFormType  Is Null))	  
	And
	(FT.intRowStatus = 0)
    ORDER BY [NationalName]   
End

