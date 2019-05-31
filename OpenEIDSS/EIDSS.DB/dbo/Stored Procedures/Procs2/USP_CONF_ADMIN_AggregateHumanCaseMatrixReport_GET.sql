CREATE PROCEDURE [dbo].[USP_CONF_ADMIN_AggregateHumanCaseMatrixReport_GET] 
/*******************************************************
NAME						: [USP_CONF_ADMIN_AggregateHumanCaseMatrixReport_GET]		


Description					: Retreives List of Diseases For Human Aggregate Case Matrix Version by version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					03/4/19							 Initial Created
*******************************************************/
@idfVersion		BIGINT
AS
BEGIN

	BEGIN TRY 
		SELECT	 
				mtx.intNumRow,
				mtx.idfAggrHumanCaseMTX as idfHumanCaseMtx
				,mtx.idfsDiagnosis
				,t.strDefault
				,d.strIDC10
		FROM	tlbAggrHumanCaseMTX mtx
			inner join trtDiagnosis d
			on d.idfsDiagnosis = mtx.idfsDiagnosis
			inner join dbo.tlbAggrMatrixVersionHeader  amvh
			on	amvh.intRowStatus = 0 and amvh.idfVersion = mtx.idfVersion and mtx.idfVersion = @idfVersion 
			inner Join trtBaseReference t
			on   t.idfsBaseReference = d.idfsDiagnosis
		WHERE mtx.intRowStatus = 0 and  mtx.idfVersion = @idfVersion
		ORDER BY mtx.intNumRow ASC
		 

	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END
