﻿

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 21.09.09
-- Description:	Return list of HACodes
-- =============================================
CREATE PROCEDURE dbo.spFFGetHACodeList
(
	@LangID Nvarchar(50) = Null 
	,@intHACode Bigint = Null
	,@idfsCodeName Bigint = Null	
)	
AS
BEGIN	
	Set Nocount On
	
	If (@LangID Is Null) Set @LangID = 'en';
		
	SELECT 
		HA.[intHACode]
      ,HA.[idfsCodeName]
      ,HA.[strNote]
      ,HA.[rowguid]
      ,RF.[strDefault] As [DefaultName]
      ,RF.[name] As [CodeName]
      ,RF.[LongName] As [NationalLongName]
  FROM [dbo].[trtHACodeList] HA
  Inner Join dbo.fnReference(@LangID, 19000040 /*'rftHA_Code_List'*/) RF On HA.idfsCodeName = RF.idfsReference
	Where 
	HA.idfsCodeName In (10040005, 10040007, 10040003, 10040011)	
	And
	((HA.[intHACode] = @intHACode ) Or (@intHACode Is Null))
	And	
	((HA.[idfsCodeName] = @idfsCodeName) Or (@idfsCodeName  Is Null))
	ORDER BY [CodeName] -- TODO: � ����� �������� �� [NationalName]
End

