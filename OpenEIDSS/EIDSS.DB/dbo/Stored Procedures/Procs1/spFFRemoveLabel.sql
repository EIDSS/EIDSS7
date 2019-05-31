

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveLabel
(
	@idfDecorElement Bigint
)
AS
BEGIN
	Set Nocount On;	
	
	-- удаляем зависимые объекты
	Delete from dbo.[ffDecorElementText] Where [idfDecorElement] = @idfDecorElement
		
	--	
	Delete from dbo.[ffDecorElement]	Where [idfDecorElement] = @idfDecorElement
		
END

