

-- ���������, ���� �� ��� ���������� ��������� ������������� �� ��������� �����. 
-- ���� ���, �� ���������� ��������� ����, ��� �������� ���� �������������.
Create function dbo.fnFFGetDesignLanguageForParameter
(
	@LangID Nvarchar(50)
	,@idfsParameter Bigint
	,@idfsFormTemplate Bigint	
)
returns bigint
as
Begin
	--
	Declare @Result Bigint
	Set @Result = dbo.fnGetLanguageCode(@LangID);  
	If (@idfsFormTemplate Is Null) begin	
		If Not Exists(Select Top 1 1 From dbo.ffParameterDesignOption Where [idfsParameter] =  @idfsParameter And idfsLanguage = @Result And idfsFormTemplate Is Null And intRowStatus = 0) 
			Set @Result = dbo.fnGetLanguageCode('en');
	End Else Begin
		If Not Exists(Select Top 1 1 From dbo.ffParameterDesignOption Where [idfsParameter] =  @idfsParameter And idfsLanguage = @Result And idfsFormTemplate = @idfsFormTemplate And intRowStatus = 0) 
			Set @Result = dbo.fnGetLanguageCode('en');
	End	
	
	return	@Result;
end


