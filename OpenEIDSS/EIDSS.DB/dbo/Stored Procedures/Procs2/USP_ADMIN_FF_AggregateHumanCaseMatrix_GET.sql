
-- ================================================================================================
-- Name: USP_ADMIN_FF_AggregateHumanCaseMatrix_GET
-- Description: Selects data for AggregateHumanCaseMTXDetail form. 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    1/2/2019 Initial release for new API.
-- ================================================================================================

CREATE PROCEDURE [dbo].[USP_ADMIN_FF_AggregateHumanCaseMatrix_GET]
AS
BEGIN

	BEGIN TRY 
		SELECT	 
				mtx.idfAggrHumanCaseMTX as idfHumanCaseMtx
				,isnull(amvh.idfVersion,0) as idfVersion
				,null as idfDiagnosisRow -- don't use now
				,null as idfIDCCodeRow -- don't use now
				,mtx.idfsDiagnosis
				,d.strIDC10
				,mtx.intNumRow
		FROM	tlbAggrHumanCaseMTX mtx
			inner join trtDiagnosis d
			on d.idfsDiagnosis = mtx.idfsDiagnosis
			inner join dbo.tlbAggrMatrixVersionHeader  amvh
			on	amvh.intRowStatus = 0 and amvh.idfVersion = mtx.idfVersion
		ORDER BY mtx.intNumRow

	END TRY
	BEGIN CATCH
		--IF @@TRANCOUNT > 0 
		--	ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END





