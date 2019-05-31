

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveRuleParameterForFunction
(
	@idfsRule BigInt
    ,@idfsParameter BigInt
)
AS
BEGIN
	Set Nocount On;
	
	-- удаляем специфические данные из языковых таблиц
	Delete from dbo.ffParameterForFunction
	Where 
		[idfsRule] = @idfsRule
		And
		[idfsParameter] = @idfsParameter	
	
END

