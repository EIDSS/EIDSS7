
CREATE PROCEDURE [dbo].[spLoginInfo_SelectDetail]
(
	@idfPerson Bigint = null
	,@LangID nvarchar(50) = N'en'
)
AS
Begin
	Select
	  u.idfUserID
      ,u.idfPerson
      ,[datTryDate]
      ,[datPasswordSet]
      ,[strAccountName]
      ,[binPassword]
      ,[intTry]
	From [dbo].[tstUserTable] u
	inner join tlbPerson p on p.idfPerson = u.idfPerson and p.intRowStatus = 0
	inner join tstSite s on s.idfOffice = p.idfInstitution and s.intRowStatus = 0
	Where (u.[idfPerson] = @idfPerson Or @idfPerson Is Null) 
			and u.[intRowStatus] = 0 
			and u.idfsSite = s.idfsSite
End
