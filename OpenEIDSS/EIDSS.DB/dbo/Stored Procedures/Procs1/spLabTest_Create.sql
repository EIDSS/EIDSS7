
 
--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE proc [dbo].[spLabTest_Create]
	@idfTesting bigint,
	@idfMaterial bigint,
	@idfsTestName bigint,
	@idfsTestCategory bigint,
	@idfsDiagnosis bigint,
	@blnExternalTest bit=0,
	@idfTestedByOffice bigint

as 

declare @Country bigint
select 
	@Country=idfsCountry 
from tstSite
join tstCustomizationPackage tcpac on
	tcpac.idfCustomizationPackage = tstSite.idfCustomizationPackage
where idfsSite=dbo.fnSiteID()

declare @template bigint
exec dbo.spFFGetActualTemplate @idfsGISBaseReference=@Country,@idfsBaseReference=@idfsTestName,@idfsFormType=10034018,@idfsFormTemplateActual=@template out

if @template=-1
begin
	set @template=null
end

declare @idfObservation bigint
exec spsysGetNewID @idfObservation output

insert into tlbObservation
(
			idfObservation,
			idfsFormTemplate			
)
values(
			@idfObservation,
			@template
)

insert into	tlbTesting(
			idfTesting,
			idfsTestName,
			idfsTestCategory,
			idfMaterial,
			idfsDiagnosis,
			idfObservation,
			blnExternalTest,
			idfsTestStatus,
			idfTestedByOffice 
)
values		(
			@idfTesting,
			@idfsTestName,
			@idfsTestCategory,
			@idfMaterial,
			@idfsDiagnosis,
			@idfObservation,
			@blnExternalTest,
			10001005, --undefined
			@idfTestedByOffice
			)


