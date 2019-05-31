

--##SUMMARY Checks if VectorType can be deleted.
--##SUMMARY This procedure is called from VectorType Editor.
--##SUMMARY We consider that VectorType can be deleted if there is no reference to this VectorType from next tables:
--##SUMMARY dbo.trtVectorSubType
--##SUMMARY dbo.trtCollectionMethodForVectorType
--##SUMMARY dbo.trtPensideTestTypeForVectorType
--##SUMMARY dbo.trtSampleTypeForVectorType
--##SUMMARY dbo.tlbVectorSurveillanceSessionToVectorType
--##SUMMARY dbo.tlbVector


--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 12.09.2011

--##RETURNS 0 if Prophylactic Action can't be deleted 
--##RETURNS 1 if Prophylactic Action can be deleted 

/*
--Example of procedure call:

DECLARE @Result BIT
EXEC [spVectorTypeReference_CanDelete] 1, @Result OUTPUT

Print @Result

*/


create   procedure [dbo].[spVectorTypeReference_CanDelete]
	@idfsBaseReference BIGINT,--##PARAM @idfsBaseReference - vector type ID
	@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
as

IF EXISTS(SELECT * from dbo.trtVectorSubType  where idfsVectorType = @idfsBaseReference and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.trtCollectionMethodForVectorType  where  idfsVectorType = @idfsBaseReference and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.trtPensideTestTypeForVectorType  where  idfsVectorType = @idfsBaseReference and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.trtSampleTypeForVectorType  where  idfsVectorType = @idfsBaseReference and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbVector  where  idfsVectorType = @idfsBaseReference and intRowStatus = 0)
	SET @Result = 0
ELSE
	SET @Result = 1

Return @Result


