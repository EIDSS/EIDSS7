

--##SUMMARY Select Contacts data for Human report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 16.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepHumCaseFormContacts @LangID=N'en',@ObjID=12171490000000


*/

create  Procedure [dbo].[spRepHumCaseFormContacts]
    (
        @LangID as nvarchar(10),
        @ObjID	as bigint
    )
as
begin
	
	select 
	dbo.fnConcatFullName(tHuman.strLastName, 
							tHuman.strFirstName, 
							tHuman.strSecondName) as ContactName,
	rfContactType.[name]			as Relation_Type,
	datDateOfLastContact			as ContactDate,
	tContacted.strPlaceInfo			as PlaceOfContact,
	(
		IsNull(dbo.fnAddressString(@LangID, tHuman.idfCurrentResidenceAddress) + ', ', '') + 
		IsNull(tHuman.strHomePhone, '')
	)								as ContactInformation,
	dbo.fnAddressStringDenyRigths(@LangID, tHuman.idfCurrentResidenceAddress, 1)		
									as ContactInformationDenyRightsSettlement,
	dbo.fnAddressStringDenyRigths(@LangID, tHuman.idfCurrentResidenceAddress, 0)		
									as ContactInformationDenyRightsDetailed		,
	tContacted.strComments			as Comments

	from		dbo.tlbContactedCasePerson	as tContacted
	 inner join	dbo.tlbHuman				as tHuman
			on	tHuman.idfHuman	= tContacted.idfHuman
				AND tHuman.intRowStatus = 0
	 left join	fnReferenceRepair(@LangID, 19000014 /*rftPartyRelationType */) as rfContactType
			on	rfContactType.idfsReference = tContacted.idfsPersonContactType
		 where	tContacted.idfHumanCase = @ObjID

end			



