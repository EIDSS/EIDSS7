
CREATE PROCEDURE [dbo].[spDataArchiving](
	@TargetServer NVARCHAR(100)
	, @TargetDataBase NVARCHAR(100)	
	, @DateRelevanceInterval INT
	)
AS

DECLARE @RC INT

EXEC spSetContext 'DataArchiving'

DECLARE @ArchiveDate DATETIME
SET @ArchiveDate = DATEADD(yy, 0 - @DateRelevanceInterval, GETDATE())


SET XACT_ABORT ON
SET NOCOUNT ON

BEGIN TRAN


	DECLARE @ReferenceTable ListOfTable

	INSERT INTO @ReferenceTable
	VALUES	
		('gisReferenceType', 1)
		, ('gisBaseReference', 2)
		, ('gisCountry', 3)
		, ('gisRegion', 4)
		, ('gisRayon', 5)
		, ('gisSettlement', 6)
		, ('gisStringNameTranslation', 7)
		, ('gisOtherBaseReference', 8)
		, ('gisOtherStringNameTranslation', 9)	
		, ('gisUserLayer', 10)
		, ('gisMetadata', 11)
		, ('gisWKBCountry', 12)
		, ('gisWKBRegion', 13)
		, ('gisWKBRayon', 14)
		, ('gisWKBSettlement', 15)
		, ('gisWKBEarthRoad', 16)
		, ('gisWKBForest', 17)
		, ('gisWKBHighway', 18)
		, ('gisWKBInlandWater', 19)
		, ('gisWKBLake', 20)
		, ('gisWKBLanduse', 21)
		, ('gisWKBMainRiver', 22)
		, ('gisWKBMajorRoad', 23)
		, ('gisWKBPath', 24)
		, ('gisWKBRailroad', 25)	
		, ('gisWKBRiver', 26)
		, ('gisWKBRiverPolygon', 27)
		, ('gisWKBRuralDistrict', 28)
		, ('gisWKBSea', 29)	
		, ('gisWKBSmallRiver', 30)	
		, ('locBaseReference', 31)
		, ('locStringNameTranslation', 32)
		, ('trtReferenceType', 33)	
		, ('trtBaseReference', 34)
		, ('trtBaseReferenceToCP', 35)
		, ('trtStringNameTranslation', 36)	
		, ('trtDiagnosis', 37)
		, ('trtDiagnosisAgeGroup', 38)
		, ('trtReportDiagnosisGroup', 39)
		, ('trtEventType', 40)
		, ('trtHACodeList', 41)
		, ('tstGeoLocationFormat', 42)
		, ('trtProphilacticAction', 43)	
		, ('trtSampleType', 44)
		, ('trtSanitaryAction', 45)
		, ('trtSpeciesType', 46)	
		, ('trtStatisticDataType', 47)
		, ('trtSystemFunction', 48)	
		, ('trtVectorType', 49)	
		, ('trtVectorSubType', 50)	
		, ('trtDiagnosisToGroupForReportType', 51)
		, ('trtObjectTypeToObjectOperation', 52)
		, ('trtObjectTypeToObjectType', 53)
		, ('trtPensideTestTypeToTestResult', 54)
		, ('trtPensideTestTypeToTestResultToCP', 55)
		--, ('trtReportRows', 56)
		, ('trtTestTypeToTestResult', 57)
		, ('trtTestTypeToTestResultToCP', 58)
		, ('tstAggrSetting', 59)
		, ('tstBarcodeLayout', 60)
		, ('tstEventSubscription', 61)
		, ('tstGlobalSiteOptions', 62)
		, ('tstLocalClient', 63)	
		, ('tstLocalSiteOptions', 64)	
		, ('tstMandatoryFields', 65)
		, ('tstMandatoryFieldsToCP', 66)
		, ('tstNextNumbers', 67)	
		, ('tstSecurityConfiguration', 68)
		, ('tstSecurityConfigurationAlphabet', 69)
		, ('tstSecurityConfigurationAlphabetParticipation', 70)
		, ('tstVersionCompare', 71)		
		, ('ffFormTemplate', 72)
		, ('ffDeterminantType', 73)
		--, ('ffDeterminantValue', 74)
		, ('ffSection', 75)	
		--, ('ffSectionDesignOption', 76)
		, ('ffSectionForTemplate', 77)	
		, ('ffDecorElement', 78)
		, ('ffDecorElementText', 79)
		, ('ffDecorElementLine', 80)
		, ('ffParameterType', 81)
		, ('ffParameterFixedPresetValue', 82)	
		, ('ffParameter', 83)
		--, ('ffParameterDesignOption', 84)
		, ('ffRuleFunction', 85)
		, ('ffParameterForTemplate', 86)
		, ('ffRule', 87)
		, ('ffRuleConstant', 88)
		--, ('ffParameterForFunction', 89)
		, ('ffSectionForAction', 90)	
		--, ('ffParameterForAction', 91)
		, ('tasSearchTable', 92)	
		, ('tasSearchObject', 93)
		, ('tasSearchObjectToSystemFunction', 94)
		, ('tasMainTableForObject', 95)
		, ('tasSearchField', 96)
		, ('tasSearchFieldToFFParameter', 97)
		, ('tstPersonalDataGroup', 98)
		, ('tstPersonalDataGroupToCP', 99)
		, ('tasSearchFieldToPersonalDataGroup', 100)
		, ('tasFieldSourceForTable', 101)
		, ('tasSearchObjectToSearchObject', 102)	
		, ('tasSearchTableJoinRule', 103)
		, ('tasglQuery', 104)
		, ('tasglQuerySearchObject', 105)
		, ('tasglQuerySearchField', 106)
		, ('tasglQueryConditionGroup', 107)
		, ('tasglQuerySearchFieldCondition', 108)	
		, ('tasglLayoutFolder', 109)	
		, ('tasglLayout', 110)
		, ('tasglLayoutSearchField', 111)
		, ('tasQuery', 112)
		, ('tasQuerySearchObject', 113)
		, ('tasQuerySearchField', 114)	
		, ('tasQueryConditionGroup', 115)	
		, ('tasQuerySearchFieldCondition', 116)		
		, ('tasLayoutFolder', 117)	
		, ('tasLayout', 118)
		, ('tasLayoutSearchField', 119)
		, ('tauTable', 120)		
		, ('tauColumn', 121)		
		, ('tlbAggrMatrixVersionHeader', 122)
		, ('tlbAggrMatrixVersion', 123)
		, ('tlbAggrDiagnosticActionMTX', 124)
		, ('tlbAggrProphylacticActionMTX', 125)		
		, ('tlbAggrVetCaseMTX', 126)	
		, ('tlbGeoLocationShared', 127)	
		, ('tlbOffice', 128)	
		, ('tstSite', 129)
		, ('tlbEmployee', 130)
		, ('tlbEmployeeGroup', 131)
		, ('tlbPerson', 132)	
		, ('tlbEmployeeGroupMember', 133)
		, ('tstUserTable', 134)
		, ('tstUserTableLocal', 135)
		, ('tstUserTableOldPassword', 136)
		, ('tlbStatistic', 137)
		, ('tlbStreet', 138)
		, ('tlbPostalCode', 139)
		, ('tlbHumanActual', 140)					
		, ('tlbFarmActual', 141)
		, ('tlbHerdActual', 142)
		, ('tlbSpeciesActual', 143)
		, ('tlbFreezer', 144)
		, ('tlbFreezerSubdivision', 145)
		, ('tauDataAuditEvent', 146)
		, ('trtDiagnosisToDiagnosisGroup', 147)
		, ('trtDiagnosisToDiagnosisGroupToCP', 148)
		, ('trtDiagnosisAgeGroupToStatisticalAgeGroupToCP', 149)
		, ('trtBssAggregateColumns', 150)
		, ('tasAggregateFunction', 151)
		, ('tasglMapImage', 152)
		, ('tasMapImage', 153)
		, ('tasglLayoutToMapImage', 154)
		, ('tasLayoutToMapImage', 155)
		, ('tasView', 156)
		, ('tasglView', 157)
		, ('tasViewBand', 158)
		, ('tasglViewBand', 159)
		, ('tasViewColumn', 160)
		, ('tasglViewColumn', 161)
		, ('gisLegendSymbol', 162)
		--, ('tflSiteFilteredBase', 163)
		, ('trtAttributeType', 164)
		, ('trtBaseReferenceAttribute', 165)
		, ('trtBaseReferenceAttributeToCP', 166)
		, ('trtGISBaseReferenceAttribute', 167)
		, ('trtGISObjectForCustomReport', 168)
		, ('tstRayonToReportSite', 169)
		, ('tflSiteGroup', 170)
		, ('tflSiteToSiteGroup', 171)
		, ('tflSiteGroupRelation', 172)

		, ('trtSpeciesGroup', 173)
		--, ('trtSpeciesToGroupForCustomReport', 174)
		--, ('trtSpeciesContentInCustomReport', 175)
		, ('gisDistrictSubdistrict', 174)
		, ('gisWKBDistrict', 175)
		, ('gisWKBDistrictReady', 176)
		, ('gisWKBRegionReady', 177)
		, ('gisWKBRayonReady', 178)
		, ('gisWKBSettlementReady', 179)
		, ('tlbDepartment', 180)

	EXEC @RC = spDataArchiving_MergeReference @TargetServer, @TargetDataBase, @ReferenceTable

	IF @RC = 0	
			EXEC @RC = spDataArchiving_MergeMatrixReference @TargetServer, @TargetDataBase

	IF @RC = 0
	BEGIN
	
		PRINT 'MergeReference successed'
		PRINT ''
		PRINT ''
		PRINT ''
			
		EXEC @RC = spDataArchiving_MovingData @TargetServer, @TargetDataBase, @ArchiveDate

		IF @RC = 0		
		BEGIN
			PRINT 'MovingData successed'
		
			EXEC spLogSecurityEvent @idfsAction = 10110006, @success = 1
			EXEC spSetContext ''
		END
		ELSE
			BEGIN
				PRINT 'MovingData failed'
			
				EXEC spLogSecurityEvent @idfsAction = 10110006, @success = 0, @strErrorText = 'MovingData failed'
				EXEC spSetContext ''
			
				RAISERROR ('MovingData failed.', 16, 1)
			END
		
	END
	ELSE
		BEGIN
			PRINT 'MergeReference failed'

			EXEC spLogSecurityEvent @idfsAction = 10110006, @success = 0, @strErrorText = 'MergeReference failed'
			EXEC spSetContext ''
		
			RAISERROR ('MergeReference failed.', 16, 1)
		END

IF @@ERROR <> 0 OR @RC <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN

SET NOCOUNT OFF
SET XACT_ABORT OFF
