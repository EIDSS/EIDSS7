

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Function dbo.fnFFCheckForSaveTemplateDeterminants
(
	@idfsFormTemplate BigInt	
	,@determinantList Nvarchar(600)
)
RETURNS @ResultTable Table
(
		[ErrorMessage] nvarchar(400)	COLLATE database_default
)
AS
BEGIN
	
	declare	@ErrorMessage nvarchar(400)
	
	Declare @Country Bigint, @idfsFormType Bigint
		
	-- �� ������ ���� ���������� UNI-������+������
	Select Top 1 @Country = Cast([Value] As Bigint) From [dbo].[fnsysSplitList](@determinantList, null, null)
	Select @idfsFormType = [idfsFormType] From dbo.ffFormTemplate Where idfsFormTemplate = @idfsFormTemplate
	
	If Exists(Select Top 1 1 From dbo.ffDeterminantValue DV
	          Where idfsFormTemplate In 	(Select Distinct idfsFormTemplate From dbo.ffFormTemplate FT Where idfsFormType = @idfsFormType And idfsFormTemplate <> @idfsFormTemplate)
				And DV.idfsGISBaseReference = @Country) BEGIN
		Set @ErrorMessage = 'Determinant_Save_Has_Not_Unique_UNI';
	END	
	
	Insert into @ResultTable(ErrorMessage) Values (@ErrorMessage);	
	
	Return;
End

