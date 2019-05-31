

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 
-- Description:
-- =============================================
Create Function dbo.fnFFGetFullPathBySections
(
	@LangID Nvarchar(50) = null
	,@idfsSection Bigint
)
Returns
@ResultTable Table
(
	[FullPathStr] Nvarchar(Max) COLLATE database_default
	,[FullPathIdfs] Nvarchar(Max) COLLATE database_default
)
AS
Begin
	If (@LangID Is Null) Set @LangID = 'en';
	
	Declare @idfsParentSection Bigint,  @DefaultName Nvarchar(400), @NationalName Nvarchar(600)
	Select @idfsParentSection = S.idfsParentSection,  @DefaultName = RF.strDefault, @NationalName = RF.[name]
	  From dbo.ffSection S 
			Inner Join dbo.fnReference(@LangID, 19000101/*'rftSection'*/) RF On S.idfsSection = RF.idfsReference
			Where 
				S.idfsSection = @idfsSection
				And
				S.intRowStatus = 0
			
	--
	Declare @FullPathStr Nvarchar(Max),@FullPathIdfs Nvarchar(Max)
	Select @FullPathStr = Isnull(@NationalName, @DefaultName), @FullPathIdfs = @idfsSection;
	
	-- ���� ���� ������������ ������, �� ��������� ���������� ���� �����
	If (@idfsParentSection Is Not null) BEGIN
	     Declare @parentFullPathStr Nvarchar(Max), @parentFullPathIdfs Nvarchar(Max)
	     Select @parentFullPathStr = '', @parentFullPathIdfs = '';
	     Select  @parentFullPathStr = [FullPathStr], @parentFullPathIdfs = [FullPathIdfs] From dbo.fnFFGetFullPathBySections(@LangID, @idfsParentSection);            	
		 Select @FullPathStr = @parentFullPathStr + ' > ' + @FullPathStr, @FullPathIdfs = @parentFullPathIdfs +';' + @FullPathIdfs
	END
     
	-- ����������
	Insert into @ResultTable
	(
		FullPathStr,
		FullPathIdfs
	)
	VALUES
	(
		@FullPathStr
		,@FullPathIdfs
	)
	
	Return
END

