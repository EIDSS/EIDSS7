



-- ================================================================================================
-- Name: USP_ADMIN_FF_AggregateMatrixVersion_GETList
-- Description: ----Current matrix version
----We select latest matrix version as default current versione. 
--##SUMMARY Selects lookup list of aggregate matrix versions for specific aggregate matrix Type.
--##SUMMARY Usable matix types are:
--##SUMMARY     VetCase = 71090000000
--##SUMMARY     DiagnosticAction = 71460000000
--##SUMMARY     ProphylacticAction = 71300000000
--##SUMMARY     HumanCase = 71190000000
--##SUMMARY     SanitaryAction = 71260000000
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    1/2/2019 Initial release for new API.
-- ================================================================================================

CREATE PROCEDURE [dbo].[USP_ADMIN_FF_AggregateMatrixVersion_GETList]
(
		@LangID as nvarchar(50),
		@idfMatrix BIGINT
)
AS
BEGIN
	BEGIN TRY 

		if @idfMatrix is null --correct matrixes defaults during loading lookup cache
		begin
			exec spAggregateMatrixVersion_CorrectDefault 71090000000
			exec spAggregateMatrixVersion_CorrectDefault 71190000000
			exec spAggregateMatrixVersion_CorrectDefault 71460000000
			exec spAggregateMatrixVersion_CorrectDefault 71300000000
			exec spAggregateMatrixVersion_CorrectDefault 71260000000
		end
		select idfVersion
			  ,idfsMatrixType as idfsAggrCaseSection
			  ,MatrixName
			  ,datStartDate
			  ,blnIsActive
			  ,blnIsDefault
			  ,CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) AS intState
			  ,intRowStatus
		from	tlbAggrMatrixVersionHeader
		where (@idfMatrix IS NULL OR idfsMatrixType = @idfMatrix)
		order by intState desc, datStartDate desc


	END TRY
	BEGIN CATCH
		--IF @@TRANCOUNT > 0 
		--	ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END



