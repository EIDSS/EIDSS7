
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/14/2017
-- Last modified by:		Joan Li
-- Description:				06/14/2017: Created based on V6 spLoginInfo_SelectDetail:  V7 usp64
--                          purpose: select data from table : tstUserTable;tlbPerson;tstSite
/*
----testing code:
EXEC	usp_LoginInfo_GetDetail
		@idfPerson=3449800000000
		,@LangID = N'en'
select * from tstUserTable --3449800000000
*/
--=====================================================================================================

CREATE PROCEDURE [dbo].[usp_LoginInfo_GetDetail]
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

