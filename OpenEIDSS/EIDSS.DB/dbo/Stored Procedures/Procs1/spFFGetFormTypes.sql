﻿

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 14.09.09
-- Description:	Return list of Form Types
-- exec [dbo].[spFFGetFormTypes]
-- select * from dbo.fnReference('en', 19000034 /*'rftFFType'*/)
-- =============================================
CREATE PROCEDURE dbo.spFFGetFormTypes
(
	@LangID Nvarchar(50) = Null
	,@idfsFormType Bigint = Null	 	
)	
AS
BEGIN	
	Set Nocount On;

	If (@LangID Is Null) Set @LangID = 'en';
		
    Select
		fr.[idfsReference] As [idfsFormType]		
		,fr.[name] as [Name]
		,fr.[LongName]
		,isnull((select top 1 Case When (P.[idfsParameter] Is Not null)  Then 1 Else 0 End 
			from dbo.ffParameter P 
			where (P.[idfsFormType] = fr.[idfsReference]) And (P.[idfsSection] Is Null) And P.[intRowStatus] = 0), 0)
			As [HasParameters]
		,isnull((select top 1 Case When (S.[idfsSection] Is Not null)  Then 1 Else 0 End 
			from dbo.ffSection S
			where S.[idfsFormType] = fr.[idfsReference] And S.[intRowStatus] = 0), 0)
			As [HasNestedSections]
		,isnull((select top 1 Case When (FT.[idfsFormTemplate] Is Not null)  Then 1 Else 0 End 
			from dbo.ffFormTemplate FT 
			where FT.[idfsFormType] = fr.[idfsReference] And FT.[intRowStatus] = 0), 0)
			As [HasTemplates]
		,MT.[idfsMatrixType]
	From dbo.fnReference(@LangID, 19000034 /*'rftFFType'*/) fr
	left join dbo.trtMatrixType MT On fr.[idfsReference] = MT.[idfsFormType]
    WHERE
	(fr.[idfsReference] = @idfsFormType ) OR (@idfsFormType Is null)		
    ORDER BY fr.[name]

End


