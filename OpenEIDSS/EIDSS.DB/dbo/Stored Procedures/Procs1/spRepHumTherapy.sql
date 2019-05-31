

--##SUMMARY Select data for Therapy subreport of Human Case Investigation report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepHumTherapy 'en', 1

*/

CREATE  Procedure [dbo].[spRepHumTherapy]
    (
        @LangID as nvarchar(10), 
        @ObjID	as bigint
    )
as
	select	tTherapy.strAntimicrobialTherapyName	as AntibioticName,
		    tTherapy.strDosage						as AntibioticDose,
		    tTherapy.datFirstAdministeredDate		as FirstAdministeredDate
    from	dbo.tlbAntimicrobialTherapy		as tTherapy
    where	tTherapy.idfHumanCase = @ObjID
	and		tTherapy.intRowStatus = 0
			

