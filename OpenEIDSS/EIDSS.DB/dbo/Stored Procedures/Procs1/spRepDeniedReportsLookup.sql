
 
 --##SUMMARY Defines which reports are avaliable for current user on current site.
 --##REMARKS Author: Romasheva S.
 --##REMARKS Create date: 02.06.2014
 --##RETURNS Doesn't use
 
 /*
 --Example of a call of procedure:
 
 exec [spRepDeniedReportsLookup] 1101, 3448480000000
 
 
 -- deny vet reports
 exec [spRepDeniedReportsLookup] 1117, 3448480000000
 
 -- deny human reports

  
select ts.idfsSite,o.intHACode,  * from tlbOffice o
		inner join tstSite ts
		on ts.idfOffice = o.idfOffice
		--and ts.idfsSite = @SiteID
	where 
	--o.intHACode & 2 > 0 or 
	o.intHACode is null
 
 -- deny Laboratory Research Result (20) on all sites, exept sites 1117, 1176, 1178
 exec [spRepDeniedReportsLookup] 1117
 exec [spRepDeniedReportsLookup] 1101
 exec [spRepDeniedReportsLookup] 768
 exec [spRepDeniedReportsLookup] 52
 
 exec [spRepDeniedReportsLookup] 870
 
 
 
 
 
871
870
2001
 */
 
 
 CREATE  Procedure [dbo].[spRepDeniedReportsLookup]
 	(
 		@SiteID				as bigint = null,
 		@UserID				as bigint = null
 	)
 AS	
 BEGIN
 
 
 
 	declare @Result as table
 	(
 	  idfsCustomReportType	bigint  not null primary key,
 	  strReportAlias		nvarchar(200),
 	  strReportEnglishName	nvarchar(200),
 	  blnReportDenied		bit
 	  
 	)
 
 	insert into @Result values (01, 'ReportsHumAberrationAnalysis',						'Human Cases Aberration Analysis', 0)
 	insert into @Result values (02, 'ReportsVetAberrationAnalysis',						'Avian/Livestock Cases Aberration Analysis', 0)
 	insert into @Result values (03, 'ReportsSyndrAberrationAnalysis',					'Syndromic Surveillance Aberration Analysis', 0)
 	insert into @Result values (04, 'ReportsILISyndrAberrationAnalysis',				'ILI Aberration Analysis', 0)
 	insert into @Result values (05, 'ReportsHumDiagnosisToChangedDiagnosis',			'Human Concordance of Initial and Final Diagnosis', 0)
 	insert into @Result values (06, 'ReportsHumMonthlyMorbidityAndMortality',			'Human Monthly Morbidity And Mortality', 0)
 	insert into @Result values (07, 'ReportsHumSummaryOfInfectiousDiseases',			'Human Summary Of Infectious Diseases', 0)
 								
 	insert into @Result values (09, 'ReportsJournal60BReportCard',						'60B Journal', 0)
 	insert into @Result values (10, 'ReportsHumInfectiousDiseaseMonth',					'Report on Cases of Infectious Diseases (Monthly Form IV–03/1 Old Revision)', 0)
 	insert into @Result values (11, 'ReportsHumInfectiousDiseaseMonthNew',				'Report on Certain Diseases/Conditions (Monthly Form IV–03)', 0)
 	insert into @Result values (12, 'HumInfectiousDiseaseIntermediateMonth',			'Intermediate Report by Monthly Form IV–03/1 (Old Revision)', 0)
 	insert into @Result values (13, 'HumInfectiousDiseaseIntermediateMonthNew',			'Intermediate Report by Monthly Form IV–03', 0)
 	insert into @Result values (14, 'ReportsHumInfectiousDiseaseYear',					'Report on Cases of Annually Reportable Infectious Diseases (Annual Form IV–03 Old Revision)', 0)
 	insert into @Result values (15, 'HumInfectiousDiseaseIntermediateYear',				'Intermediate Report by Annual Form IV–03 (Old Revision)', 0)
 																						
 	insert into @Result values (17, 'ReportsHumSerologyResearchCard',					'Serology Research Result', 0)
 	insert into @Result values (18, 'ReportsHumMicrobiologyResearchCard',				'Microbiology Research Result', 0)
 	insert into @Result values (19, 'HumAntibioticResistanceCard',						'Antibiotic Resistance Card (NCDC&PH)', 0)
 	insert into @Result values (20, 'VetLaboratoryResearchResult',						'Laboratory Research Result', 0)
 	insert into @Result values (22, 'HumAntibioticResistanceCardLMA',					'Antibiotic Resistance Card (LMA)', 0)
 								
 	insert into @Result values (23, 'HumFormN1A3',										'Form # 1 (A3)', 0)
 	insert into @Result values (24, 'HumFormN1A4',										'Form # 1 (A4)', 0)
 	insert into @Result values (25, 'HumDataQualityIndicators',							'Data Quality Indicators', 0)
 	insert into @Result values (26, 'HumDataQualityIndicatorsRayons',					'Data Quality Indicators for rayons', 0)
 	insert into @Result values (27, 'HumComparativeReport',								'Comparative Report', 0)
 	insert into @Result values (28, 'HumSummaryByRayonDiagnosisAgeGroups',				'Report of human cases by rayon, diagnosis', 0)
 	insert into @Result values (29, 'HumExternalComparativeReport',						'External comparative Report', 0)
 	insert into @Result values (30, 'HumMainIndicatorsOfAFPSurveillance',				'Main indicators of AFP surveillance', 0)
 	insert into @Result values (31, 'HumAdditionalIndicatorsOfAFPSurveillance',			'Additional indicators of AFP surveillance', 0)
 	insert into @Result values (32, 'HumWhoMeaslesRubellaReport',						'WHO Report on Measles and Rubella', 0)
 	insert into @Result values (34, 'HumComparativeReportOfTwoYears',					'Comparative Report of two years by month', 0)
 																					
 	insert into @Result values (35, 'VeterinaryCasesReport',							'Veterinary Cases Report', 0)
 	insert into @Result values (37, 'VeterinaryLaboratoriesAZ',							'Report of Activities Conducted in Veterinary Laboratories', 0)
 																					
 	insert into @Result values (38, 'HumFormN85Annual',									'National Statistic Form # 85 (annual)', 0)
 	insert into @Result values (40, 'HumFormN85Monthly',								'National Statistic Form # 85 (monthly)', 0)
 																					
 	insert into @Result values (41, 'WeeklySituationDiseasesByDistricts',				'Weekly situation on infectious diseases by districts', 0)
 	insert into @Result values (42, 'WeeklySituationDiseasesByAgeGroupAndSex',			'Weekly situation on infectious diseases by age group and sex', 0)
 	insert into @Result values (44, 'HumComparativeIQReport',							'Comparative Report', 0)
 																					
 	insert into @Result values (45, 'ReportsVetSamplesCount',							'Veterinary Samples Count', 0)
 	insert into @Result values (46, 'ReportsVetSamplesReportBySampleType',				'Veterinary Samples By Sample Type', 0)
 	insert into @Result values (47, 'ReportsVetSamplesReportBySampleTypesWithinRegions','Veterinary Samples By Sample Types Within Regions', 0)
 	insert into @Result values (48, 'ReportsVetYearlySituation',						'Veterinary Yearly Situation', 0)
 	insert into @Result values (51, 'ReportsActiveSurveillance',						'Active Surveillance Report', 0)
 																						
 																					
 	insert into @Result values (52, 'VetCountryPlannedDiagnosticTestsReport',			'Country Report "Planned diagnostic tests"', 0)
 	insert into @Result values (53, 'VetRegionPlannedDiagnosticTestsReport',			'Oblast Report "Planned diagnostic tests"', 0)
 	insert into @Result values (54, 'VetCountryPreventiveMeasuresReport',				'Country Report "Veterinary preventive measures"', 0)
 	insert into @Result values (55, 'VetRegionPreventiveMeasuresReport',				'Oblast Report "Veterinary preventive measures"', 0)
 	insert into @Result values (56, 'VetCountryProphilacticMeasuresReport',				'Country Report "Veterinary- sanitary measures"', 0)
 	insert into @Result values (57, 'VetRegionProphilacticMeasuresReport',				'Oblast Report "Veterinary- sanitary measures"', 0)
 																					
 	insert into @Result values (58, 'ReportsAdmEventLog',								'Administrative Event Log', 0)

 	insert into @Result values (59, 'LabTestingResultsAZ',								'Laboratory testing results', 0)
  	insert into @Result values (60, 'AssignmentLabDiagnosticAZ',						'Assignment for Laboratory Diagnostic', 0)	

	insert into @Result values (61, 'VeterinaryFormVet1',								'Veterinary Report Form Vet 1', 0)	
    insert into @Result values (62, 'VeterinaryFormVet1A',								'Veterinary Report Form Vet 1A', 0)	

	insert into @Result values (63, 'HumBorderRayonsComparativeReport',					'Border rayons’ incidence comparative report', 0)	
   
	insert into @Result values (64, 'HumTuberculosisCasesTested',						'Report on Tuberculosis cases tested for HIV', 0)	
 
 	--  “Veterinary Sites” 
 	--(22, 'HumAntibioticResistanceCardLMA',					'Antibiotic Resistance Card (LMA)', 0)
 	update res set
 		blnReportDenied = 1
 	from @Result res
 	where res.idfsCustomReportType in (22) and
 	not exists (select *
 				from [dbo].[fnRepVetOrHumanSiteList](96) hvl
 				inner join tstSite ts
 				on ts.idfsSite = hvl.idfsSite and
 				ts.idfsSite = @SiteID
 			)
 	
 	
 	--  “Human/Vet Sites” 	
 	--(19, 'HumAntibioticResistanceCard',						'Antibiotic Resistance Card (NCDC&PH)', 0)
	--(18, 'ReportsHumMicrobiologyResearchCard',				'Microbiology Research Result', 0)
	--(17, 'ReportsHumSerologyResearchCard',					'Serology Research Result', 0)
	
 	update res set
 		blnReportDenied = 1
 	from @Result res
 	where res.idfsCustomReportType in (17, 18, 19) and
 	not exists (select *
 				from [dbo].[fnRepVetOrHumanSiteList](2) hvl
 				inner join tstSite ts
 				on ts.idfsSite = hvl.idfsSite and
 				ts.idfsSite = @SiteID
 			) 


 	
 	--  'Laboratory Research Result' - 20
 	update res set
 		blnReportDenied = 1
 	from @Result res
 	where res.idfsCustomReportType = 20 and
 	not exists (select *
 				from [dbo].[fnRepSiteListForLMAReport]() hvl
 				inner join tstSite ts
 				on ts.idfsSite = hvl.idfsSite and
 				ts.idfsSite = @SiteID
 			)
 	 
 				
 	--59, 'LabTestingResultsAZ'
  	--60, 'AssignmentLabDiagnosticAZ'
    --64, 'HumTuberculosisCasesTested'
  	--34, 'HumComparativeReportOfTwoYears'
  	--63, 'HumBorderRayonsComparativeReport'
 	update res set
 		blnReportDenied = 1
 	from @Result res
 	where res.idfsCustomReportType in (34, 63, 59, 60, 64) and
 	not exists (
 					select * from tlbOffice o
 						inner join tstSite ts
 						on ts.idfOffice = o.idfOffice
 						and ts.idfsSite = @SiteID
 					where o.intHACode & 2 > 0 or isnull(o.intHACode, 0) = 0 
 				)	
 								 
 	select	* 
 	from	@Result
 	where	blnReportDenied = 1		 
 									 
 								 
 END								 

