

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveTemplateDeterminantValues
(
	@idfDeterminantValue Bigint
)
AS
BEGIN
	Set Nocount On;	
	--	
	Delete from dbo.[ffDeterminantValue] Where [idfDeterminantValue] = @idfDeterminantValue
		
END

