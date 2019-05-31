

--##SUMMARY Select data for Outbreak report report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 11.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepUniOutbreakNotesReport @LangID=N'en',@ObjID=51556680000000


*/

create  Procedure [dbo].[spRepUniOutbreakNotesReport]
    (
        @LangID as nvarchar(10), 
        @ObjID	as bigint
    )
as
	SELECT 
			 idfOutbreakNote
			,idfOutbreak
			,strNote
			,datNoteDate
			,dbo.fnConcatFullName(p.strFamilyName, 
							p.strFirstName, 
							p.strSecondName) as strCreatorName
			
	FROM	tlbOutbreakNote n
	left join tlbPerson p
	on n.idfPerson = p.idfPerson
	
	WHERE 
			idfOutbreak = @ObjID
			and n.intRowStatus = 0


			

