

-- ���������, ���� �� ��� ��������� ������ ������������� �� ��������� �����. 
-- ���� ���, �� ���������� ��������� ����, ��� �������� ���� �������������.
Create function dbo.fnFFGetDesignLanguageForSection
(
	@LangID Nvarchar(50)
	,@idfsSection Bigint
	,@idfsFormTemplate Bigint	
)
returns bigint
as
Begin
	--
	Declare @Result Bigint
	Set @Result = dbo.fnGetLanguageCode(@LangID);  
	If (@idfsFormTemplate Is Null) begin	
		If Not Exists(Select Top 1 1 From dbo.ffSectionDesignOption Where [idfsSection] =  @idfsSection And idfsLanguage = @Result And idfsFormTemplate Is Null And [intRowStatus]=0) 
			Set @Result = dbo.fnGetLanguageCode('en');
	End Else Begin
		If Not Exists(Select Top 1 1 From dbo.ffSectionDesignOption Where [idfsSection] =  @idfsSection And idfsLanguage = @Result And idfsFormTemplate = @idfsFormTemplate And [intRowStatus]=0) 
			Set @Result = dbo.fnGetLanguageCode('en');
	End	
	
	return	@Result;
end


