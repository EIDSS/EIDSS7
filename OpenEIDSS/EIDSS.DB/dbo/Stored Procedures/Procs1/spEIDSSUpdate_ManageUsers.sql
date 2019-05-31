

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spEIDSSUpdate_ManageUsers
(
	@enable Bit
)
AS
BEGIN
	Set Nocount On;
	
	--Alter Login A1 Enable
	--Alter Login A1 Disable

	Declare @Name Nvarchar(255)

	Declare curs Cursor For Select [name] From sys.server_principals Where type_desc='SQL_LOGIN' And [name] <> 'EIDSSMaintanceEngineer' And [name] <> 'sa'

	Open curs

	Fetch Next From curs Into @Name

	Declare @sql Nvarchar(500)

	While @@FETCH_STATUS = 0 Begin
		If (@enable = 1) Begin
			Set @sql = 'Alter Login [' + @Name + '] Enable';
		End Else Begin
			Set @sql = 'Alter Login [' + @Name + '] Disable';
		End	
			
		exec(@sql)
		
		Fetch Next From curs Into @Name                     	
	END

	Close curs
	Deallocate curs
	
END

