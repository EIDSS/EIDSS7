

--##SUMMARY select layouts for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 03.04.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:


select * from tasLayout
exec spAsLayoutSelectDetail 'en', 74700000870, 51389520000000
exec spAsLayoutSelectDetail 'en', 708000000000


*/ 
 
create PROCEDURE [dbo].[spAsLayoutSelectDetail]
	@LangID		as nvarchar(50),
	@LayoutID	as BIGINT,
	@UserID		AS BIGINT = NULL
AS
BEGIN


	select	   lay.idflLayout
			  ,brLay.strName			as strLayoutName
			  ,brLay.strEnglishName		as strDefaultLayoutName
			  ,lay.idflDescription
			  ,refDescription.strName	as strDescription 
			  ,lay.idflQuery
			  ,lay.idflLayoutFolder
			  ,lay.idfPerson
			  ,lay.blnReadOnly
			  ,lay.idfsDefaultGroupDate
			  ,brGI.[name]				as strGroupIntervalName
			  ,lay.blnShowColsTotals
			  ,lay.blnShowRowsTotals
			  ,lay.blnShowColGrandTotals
			  ,lay.blnShowRowGrandTotals
			  ,lay.blnShowForSingleTotals
			  ,lay.blnApplyPivotGridFilter
			  ,lay.blnShareLayout
			  ,lay.blbPivotGridSettings
			  ,lay.intPivotGridXmlVersion
			  ,lay.blnCompactPivotGrid
			  ,lay.blnFreezeRowHeaders
			  ,lay.blnUseArchivedData
			  ,lay.blnShowMissedValuesInPivotGrid
			  ,lay.blbGisLayerGeneralSettings
			  ,lay.blbGisMapGeneralSettings
			  ,lay.intGisLayerPosition
			  ,isnull(qso_counter.blnSingleSearchObject, 0) as blnSingleSearchObject
			  ,lay.blnShowDataInPivotGrid as blnShowDataInPivotGrid
		  
	from		dbo.tasLayout	as lay
	inner join	dbo.fnLocalReference(@LangID)	as brLay
			on	lay.idflLayout = brLay.idflBaseReference
	 left join	dbo.fnLocalReference(@LangID)	as refDescription
			on	lay.idflDescription = refDescription.idflBaseReference
	 left join	fnReference(@LangID, 19000039 /*'rftGroupInterval'*/)	as brGI
			on	brGI.idfsReference = lay.idfsDefaultGroupDate
		   
   	 left join	(
					select	idflQuery, 
							case COUNT(idfQuerySearchObject) 
								when 1 then 1
								else 0 
							end				 as blnSingleSearchObject
					from	tasQuerySearchObject qso_root
					inner join	trtBaseReference br_so_root
					on	br_so_root.idfsBaseReference = qso_root.idfsSearchObject
					group by idflQuery
				) as qso_counter
			on	qso_counter.idflQuery = lay.idflQuery
		 where	@LayoutID = lay.idflLayout

END

