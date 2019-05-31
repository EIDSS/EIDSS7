

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveLine
(
	@idfDecorElement Bigint
)
AS
BEGIN
	Set Nocount On;	
	
	-- удаляем зависимые объекты
	Delete from dbo.[ffDecorElementLine] Where [idfDecorElement] = @idfDecorElement
		
	--	
	Delete from dbo.[ffDecorElement]	Where [idfDecorElement] = @idfDecorElement
		
END

