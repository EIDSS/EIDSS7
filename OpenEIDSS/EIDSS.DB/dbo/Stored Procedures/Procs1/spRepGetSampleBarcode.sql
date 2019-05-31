

--##SUMMARY Select data for barcode.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 13.01.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec spRepGetSampleBarcode 747500000000, 'en'

*/

create  Procedure [dbo].[spRepGetSampleBarcode]
	(
		@ObjID	    as bigint,
		@LangID		varchar(20)
	)
AS	
	select		
	      COALESCE (tlbHumanCase.strCaseID,tlbVetCase.strCaseID,tlbMonitoringSession.strMonitoringSessionID,tlbVectorSurveillanceSession.strSessionID) as strCase, 
				tlbMaterial.strBarcode				as strBarcode,
				tlbMaterial.strBarcode				as strBarcodeLabel,
				trtSpeciesType.strCode				as strSpeciesCode,
				trtSampleType.strSampleCode			as strSampleCode,
				convert(varchar(10), tlbMaterial.datFieldCollectionDate, 103)	
													as datCollectionDate
	from		tlbMaterial 
	left join	trtSampleType
	on			trtSampleType.idfsSampleType = tlbMaterial.idfsSampleType
	left join	tlbHumanCase
	on			tlbHumanCase.idfHumanCase = tlbMaterial.idfHumanCase
  	left join	tlbVetCase
	on			tlbVetCase.idfVetCase = tlbMaterial.idfVetCase
	left join	tlbMonitoringSession
	on			tlbMonitoringSession.idfMonitoringSession = tlbMaterial.idfMonitoringSession
	left join	tlbVectorSurveillanceSession
	on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession
	left join	tlbSpecies
	on			tlbSpecies.idfSpecies = tlbMaterial.idfSpecies
	left join	trtSpeciesType
	on			trtSpeciesType.idfsSpeciesType = tlbSpecies.idfsSpeciesType
	
	where		tlbMaterial.idfMaterial  = @ObjID
	        and tlbMaterial.intRowStatus = 0
	

