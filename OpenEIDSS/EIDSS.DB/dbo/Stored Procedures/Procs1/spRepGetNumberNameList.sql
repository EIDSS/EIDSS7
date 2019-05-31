

--##SUMMARY Select list of number names for barcodes.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 17.12.2009

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec spRepGetNumberNameList  'ru'

*/

CREATE  Procedure [dbo].[spRepGetNumberNameList]
    (
		@LangID as nvarchar(10)
    )
as
	select  tNumbers.idfsNumberName, 
			rfNumbers.[name] as strNumberName
	  from	tstNextNumbers				as tNumbers
inner join	fnReferenceRepair(@LangID, 19000057) as rfNumbers
		on	rfNumbers.idfsReference = tNumbers.idfsNumberName


