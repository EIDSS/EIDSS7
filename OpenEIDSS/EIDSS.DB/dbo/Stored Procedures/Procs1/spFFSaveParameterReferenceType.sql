

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFSaveParameterReferenceType
(
	@idfsParameterType Bigint Output
	,@DefaultName Nvarchar(400)	
	,@NationalName  Nvarchar(600)	
	,@idfsReferenceType Bigint
	--,@System Int
	/* System
	* idfsReferenceType = -1 -> 2 ��� ������������, ������ ��� 2 -- ��� ������� ���� ���������� ����� �����, ��� � �.�.
	* idfsReferenceType = 19000069 -> 0
	* idfsReferenceType = �����-�� ID -> 1
	*/	
	,@LangID Nvarchar(50) = Null
	
)	
AS
BEGIN	
	SET NOCOUNT ON;

	If (@LangID Is Null) Set @LangID = 'en';
	
	-- ���� id < 0, ������, ��� ��������� id � ����� �������� ��� �� ���������
	If (@idfsParameterType < 0) Exec dbo.[spsysGetNewID] @idfsParameterType Output
	
	Exec dbo.spBaseReference_SysPost @idfsParameterType, 19000071/*'rftParameterType'*/,@LangID, @DefaultName, @NationalName, 0

	If Not Exists (Select Top 1 1 From dbo.ffParameterType Where [idfsParameterType] = @idfsParameterType) BEGIN
		Insert into dbo.ffParameterType
		(
			[idfsParameterType]
			,[idfsReferenceType]
		)
		Values
		(
			@idfsParameterType
			,@idfsReferenceType
		)
	End Else BEGIN
	    Update dbo.ffParameterType
			Set [idfsReferenceType] = @idfsReferenceType
					,[intRowStatus] = 0
	    Where [idfsParameterType] = @idfsParameterType
	END
End

