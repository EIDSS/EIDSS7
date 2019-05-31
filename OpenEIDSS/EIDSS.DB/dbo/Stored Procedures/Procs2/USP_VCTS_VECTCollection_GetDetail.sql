
--*************************************************************
-- Name 				: USP_VCTS_VECTCollection_GetDetail
-- Description			: Get Vector Surveillance Vector Details
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor  5/20/2018   Updated to properly return idfsCollectionMethod value
--  Harold Pryor  6/12/2018   Updated to return idfsGeoLocationType
--
-- Testing code:
/*
--Example of a call of procedure:
declare	@idfVector	bigint

select @idfVector = MAX(idfVector) from dbo.tlbVector

execute	dbo.USP_VCTS_VECTCollection_GetDetail @idfVectorSurveillanceSession
*/
--*************************************************************
CREATE PROCEDURE[dbo].[USP_VCTS_VECTCollection_GetDetail]
(		
	@idfVector BIGINT,--##PARAM @idfVector - AS vector ID
	@idfVectorSurveillanceSession BIGINT,--##PARAM @idfVectorSurveillanceSession - AS session ID
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

			SELECT 	V.idfVector,
					V.idfVectorSurveillanceSession, 
					VS.strSessionID,
					V.idfsVectorType, 
					VectorType.name	AS [strVectorType],
					VectorSubType.name AS [strSpecies],
					V.idfsSex,	
					Sex.name AS [strSex],
					V.idfsVectorSubType, 
					V.strVectorID, 
					V.strFieldVectorID,
					Vs.intCollectionEffort,
					tgl.strForeignAddress,
					groundType.idfsReference,
					groundType.Name,
					tgl.dblDistance,
					--tgl.Direction,
					tgl.strDescription,
					V.intElevation,
					V.idfsSurrounding,
					surrounding.name,
					V.strGEOReferenceSources,
					V.idfsBasisOfRecord,
					basisOfRecord.name,
					V.idfCollectedByOffice,
					CollectedByOffice.Name  AS CollectedByOfffice,
					V.idfCollectedByPerson, 
					ISNULL(CollectedByPerson.strFamilyName, N'') + ISNULL(' ' + CollectedByPerson.strFirstName, '') + ISNULL(' ' + CollectedByPerson.strSecondName, '') AS [strCollectedByPerson],
					V.datCollectionDateTime,
					V.idfsDayPeriod,
					DayPeriod.name AS DayPeriod,
					V.idfsCollectionMethod,
					CollectionMethod.name,
					V.idfsEctoparasitesCollected,
					V.intQuantity,
					V.idfIdentifiedByOffice,
					IdentifiedByOffice.Name  AS IdentifiedByOfffice,
					V.idfIdentifiedByPerson,
					ISNULL(IdentifiedByPerson.strFamilyName, N'') + ISNULL(' ' + IdentifiedByPerson.strFirstName, '') + ISNULL(' ' + IdentifiedByPerson.strSecondName, '') AS [strIdentifiedByPerson],
					V.idfLocation,
					ISNULL(tgl.idfsGeoLocationType,10036003) as idfsGeoLocationType,
					tgl.idfsCountry,
					tgl.idfsRegion,
					tgl.idfsSettlement,
					tgl.idfsRayon,
					tgl.dblLatitude,
					tgl.dblLongitude

		FROM		dbo.tlbVector V
		INNER JOIN	dbo.tlbVectorSurveillanceSession VS ON V.idfVectorSurveillanceSession = VS.idfVectorSurveillanceSession
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangId,19000141) VectorSubType
		ON			VectorSubType.idfsReference = V.idfsVectorSubType
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangId,19000140) VectorType
		ON			VectorType.idfsReference = V.idfsVectorType
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangId,19000043) Sex
		ON			Sex.idfsReference = V.idfsSex
		LEFT JOIN	dbo.tlbGeoLocation tgl
					ON V.idfLocation = tgl.idfGeolocation
		LEFT JOIN		dbo.FN_GBL_REFERENCEREPAIR(@langId,19000038) groundType
		ON			groundType.idfsReference = tgl.idfsGroundType
		LEFT JOIN		dbo.FN_GBL_REFERENCEREPAIR(@langId,19000038) surrounding
		ON			surrounding.idfsReference = V.idfsSurrounding
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@langId,19000137) basisOfRecord
		ON			basisOfRecord.idfsReference = V.idfsBasisOfRecord
		LEFT JOIN	dbo.FN_GBL_Reference_List_GET(@LangID,19000045) CollectedByOffice	ON CollectedByOffice.idfsReference = V.idfCollectedByOffice	 
		LEFT JOIN	dbo.tlbPerson CollectedByPerson ON CollectedByPerson.idfPerson = V.idfCollectedByPerson 
		LEFT JOIN	dbo.FN_GBL_Reference_List_GET(@LangID,19000045) IdentifiedByOffice	ON IdentifiedByOffice.idfsReference = V.idfCollectedByOffice	 
		LEFT JOIN	dbo.tlbPerson IdentifiedByPerson ON IdentifiedByPerson.idfPerson = V.idfIdentifiedByPerson
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@langId,19000136) DayPeriod
		ON			DayPeriod.idfsReference = V.idfsDayPeriod
		LEFT JOIN		dbo.FN_GBL_REFERENCEREPAIR(@langId,19000135) CollectionMethod
		ON			CollectionMethod.idfsReference = V.idfsCollectionMethod
		--JOIN		dbo.FN_GBL_REFERENCEREPAIR(@langId,19000135) EctoParasitesCollected
		--ON			EctoParasitesCollected.idfsReference = V.idfsDayPeriod
		WHERE		v.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		AND			v.intRowStatus = 0
		and         v.idfVector = @idfVector
		
		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SET @returnCode = ERROR_NUMBER()
			SELECT @returnCode, @returnMsg
		END

	END CATCH; 
		
END
