

-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- =============================================


--##SUMMARY Select Date and administrative uniot for aggregate case report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of function:
select dbo.fnCreateNameString ('Last', 'First', null)
*/

Create Function dbo.fnCreateNameString
(
	@strLastName as nvarchar(200),
	@strFirstName as nvarchar(200),
	@strSecondName as nvarchar(200)
)
returns nvarchar(600)
as
begin
	return
	(
		IsNull(@strLastName + ' ', '') +
		IsNull(@strFirstName + ' ', '') + 
		IsNull(@strSecondName, '') 
	)	
end



