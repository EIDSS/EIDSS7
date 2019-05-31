
-- ================================================================================================
-- Name: USP_VCTS_SURVEILLANCE_SESSION_GetList
--
-- Description: Gets a list of vector surveillance sessions filtered by various criteria.
--          
-- Revision History:
-- Name             Date       Change Detail
-- Maheshwar Deo	3/8/2019	Fixed filter for @DiseaseID
--
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/31/2018 Added additional search parameters
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCTS_SURVEILLANCE_SESSION_GetList]
(
    @LanguageID NVARCHAR(50),
    @EIDSSSessionID NVARCHAR(200) = NULL,
    @FieldSessionID NVARCHAR(200) = NULL,
    @StatusTypeID BIGINT = NULL,
    @VectorTypeID NVARCHAR(MAX) = NULL,
    @SpeciesTypeID BIGINT = NULL,
    @DiseaseID BIGINT = NULL,
    @DiseaseGroupID NVARCHAR(MAX) = NULL,
    @RegionID BIGINT = NULL,
    @RayonID BIGINT = NULL,
    @SettlementID BIGINT = NULL,
    @StartDateFrom DATETIME = NULL,
    @StartDateTo DATETIME = NULL,
    @EndDateFrom DATETIME = NULL,
    @EndDateTo DATETIME = NULL,
    @OutbreakID BIGINT = NULL,
    @SiteID BIGINT = NULL,
    @PaginationSet INT = 1,
    @PageSize INT = 10,
    @MaxPagesPerFetch INT = 10
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        SELECT DISTINCT
               idfVectorSurveillanceSession AS VectorSurveillanceSessionID,
               strSessionID AS EIDSSSessionID,
               strVectors AS Vectors,
               strVectorTypeIds AS VectorTypes,
               strDiagnoses AS Disease,
               strFieldSessionID AS FieldSessionID,
               strVSStatus AS StatusTypeName,
               idfsVectorSurveillanceStatus AS StatusTypeID,
               strRegion AS RegionName,
               strRayon AS RayonName,
               strSettlement AS SettlementName,
               dblLatitude AS Latitude,
               dblLongitude AS Longitude,
               datStartDate AS StartDate,
               datCloseDate AS CloseDate,
               idfOUtBreak AS OutbreakID,
               idfLocation AS LocationID,
               idfsSite AS SiteID
        FROM dbo.FN_VCTS_VSSESSION_GetList(@LanguageID)
        WHERE (
                  (strSessionID LIKE CASE ISNULL(@EIDSSSessionID, '')
                                         WHEN '' THEN
                                             strSessionID
                                         ELSE
                                             '%' + @EIDSSSessionID + '%'
                                     END
                  )
                  OR strSessionID IS NULL
              )
              AND
              (
                  (strFieldSessionID LIKE CASE ISNULL(@FieldSessionID, '')
                                              WHEN '' THEN
                                                  strFieldSessionID
                                              ELSE
                                                  '%' + @FieldSessionID + '%'
                                          END
                  )
                  OR strFieldSessionID IS NULL
              )
              AND idfsVectorSurveillanceStatus = CASE ISNULL(@StatusTypeID, '')
                                                     WHEN '' THEN
                                                         idfsVectorSurveillanceStatus
                                                     ELSE
                                                         @StatusTypeID
                                                 END
              AND
              (
                  (strVectorTypeIds = CASE ISNULL(@VectorTypeID, '')
                                          WHEN '' THEN
                                              strVectorTypeIds
                                          ELSE
                                              @VectorTypeID
                                      END
                  )
                  OR strVectorTypeIds IS NULL
              )
              AND
              (
                  (idfsVectorSubType = CASE ISNULL(@SpeciesTypeID, '')
                                           WHEN '' THEN
                                               idfsVectorSubType
                                           ELSE
                                               @SpeciesTypeID
                                       END
                  )
                  OR idfsVectorSubType IS NULL
              )
              AND
              (
                  (strDiagnosesIDs LIKE CASE ISNULL(@DiseaseID, '')
                                         WHEN '' THEN
                                             strDiagnosesIDs
                                         ELSE
                                             '%' + Cast(@DiseaseID As VARCHAR(20)) + '%'
                                     END
                  )
                  OR strDiagnosesIDs IS NULL
              )
              AND
              (
                  (idfsRegion = CASE ISNULL(@RegionID, '')
                                    WHEN '' THEN
                                        idfsRegion
                                    ELSE
                                        @RegionID
                                END
                  )
                  OR idfsRegion IS NULL
              )
              AND
              (
                  (idfsRayon = CASE ISNULL(@RayonID, '')
                                   WHEN '' THEN
                                       idfsRayon
                                   ELSE
                                       @RayonID
                               END
                  )
                  OR idfsRayon IS NULL
              )
              AND
              (
                  (idfsSettlement = CASE ISNULL(@SettlementID, '')
                                        WHEN '' THEN
                                            idfsSettlement
                                        ELSE
                                            @SettlementID
                                    END
                  )
                  OR idfsSettlement IS NULL
              )
              AND datStartDate >= CASE ISNULL(@StartDateFrom, '')
                                      WHEN '' THEN
                                          datStartDate
                                      ELSE
                                          @StartDateFrom
                                  END
              AND datStartDate <= CASE ISNULL(@StartDateTo, '')
                                      WHEN '' THEN
                                          datStartDate
                                      ELSE
                                          @StartDateTo
                                  END
              AND ISNULL(datCloseDate, '') >= CASE ISNULL(@EndDateFrom, '')
                                                  WHEN '' THEN
                                                      ISNULL(datCloseDate, '')
                                                  ELSE
                                                      @EndDateFrom
                                              END
              AND ISNULL(datCloseDate, '') <= CASE ISNULL(@EndDateTo, '')
                                                  WHEN '' THEN
                                                      ISNULL(datCloseDate, '')
                                                  ELSE
                                                      @EndDateTo
                                              END
              AND
              (
                  (idfOUtBreak = CASE ISNULL(@OutbreakID, '')
                                     WHEN '' THEN
                                         idfOUtBreak
                                     ELSE
                                         @OutbreakID
                                 END
                  )
                  OR idfOUtBreak IS NULL
              )
              AND
              (
                  (idfsSite = CASE ISNULL(@SiteID, '')
                                  WHEN '' THEN
                                      idfsSite
                                  ELSE
                                      @SiteID
                              END
                  )
                  OR idfsSite IS NULL
              )
        ORDER BY strSessionID,
                 strVSStatus,
                 datStartDate,
                 strVectorTypeIds OFFSET (@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS FETCH NEXT (@PageSize
                                                                                                                 * @MaxPagesPerFetch
                                                                                                                ) ROWS ONLY;
    END TRY
    BEGIN CATCH
        ; THROW;
    END CATCH;
END;
