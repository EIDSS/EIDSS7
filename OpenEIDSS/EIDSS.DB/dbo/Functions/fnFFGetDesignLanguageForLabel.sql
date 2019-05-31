

-- ���������, ���� �� ��� ���������� ������ ������������� �� ��������� �����. 
-- ���� ���, �� ���������� ��������� ����, ��� �������� ���� �������������.
Create function dbo.fnFFGetDesignLanguageForLabel
(
	@LangID Nvarchar(50)
	,@idfDecorElement Bigint
)
returns bigint
as
Begin
	--
	Declare @Result Bigint
	Set @Result = dbo.fnGetLanguageCode(@LangID);  
	
	If Not Exists(Select Top 1 1 From dbo.ffDecorElement Where [idfDecorElement] =  @idfDecorElement And idfsLanguage = @Result And intRowStatus = 0) 
			Set @Result = dbo.fnGetLanguageCode('en');
		
	return	@Result;
end


