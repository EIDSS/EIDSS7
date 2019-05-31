

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveActivityParameters
(
	@idfsParameter Bigint
	,@idfObservation Bigint
    ,@idfRow Bigint
)
AS
BEGIN
	Set Nocount On;
	Set Xact_abort On;
	
	Delete from dbo.tlbActivityParameters
				Where [idfsParameter] = @idfsParameter And [idfObservation] = @idfObservation And [idfRow] = @idfRow
End

