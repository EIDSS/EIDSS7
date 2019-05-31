




--##SUMMARY Posts data from DiagnosisReferenceDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 5.12.2009

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @Action int
DECLARE @idfsBaseReference bigint
DECLARE @strDefault varchar(200)
DECLARE @Name nvarchar(200)
DECLARE @strOIECode nvarchar(200)
DECLARE @strIDC10 nvarchar(200)
DECLARE @intHACode int
DECLARE @idfsUsingType bigint
DECLARE @intOrder int
DECLARE @LangID nvarchar(50)


EXECUTE @spDiagnosisReference_Post
   @Action
  ,@idfsBaseReference
  ,@strDefault
  ,@Name
  ,@strOIECode
  ,@strIDC10
  ,@intHACode
  ,@idfsUsingType
  ,@intOrder
  ,@LangID

*/


CREATE     PROCEDURE dbo.spDiagnosisReference_Post 
	@Action INT,--##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfsBaseReference BIGINT,--##PARAM @idfsBaseReference - diagnosis ID
	@strDefault VARCHAR(200),--##PARAM @strDefault - english diagnosis name
	@Name  NVARCHAR(200),--##PARAM @Name - diagnosis name in language defined by @LangID parameter
	@strOIECode  NVARCHAR(200),--##PARAM @strOIECode - OIE diagnosis Code
	@strIDC10  NVARCHAR(200),--##PARAM @strIDC10 - IDC10 diagnosis Code
	@intHACode INT,--##PARAM @intHACode - bit mask that defines what Type of cases(human, LiveStock, avian) can use this diagnosis.
	@idfsUsingType BIGINT,--##PARAM @idfsUsingType - diagnosis using Type that defines what kind of cases (standard od aggregate) can use this diagnosis
	@intOrder INT,--##PARAM @intOrder - diagnosis order
	@LangID  NVARCHAR(50),--##PARAM @LangID - language ID 
	@blnZoonotic BIT = 0
AS
BEGIN
	IF @Action = 8
	BEGIN

		DELETE FROM trtDiagnosis 
		WHERE idfsDiagnosis = @idfsBaseReference

		EXECUTE spsysBaseReference_Delete  @idfsBaseReference


	END
	ELSE
	BEGIN
		EXEC dbo.spBaseReference_SysPost 
				@idfsBaseReference,
				19000019/*Diagnosis*/,
				@LangID,
				@strDefault,
				@Name,
				@intHACode,
				@intOrder
		IF @Action = 4 --Added
		BEGIN
				INSERT INTO trtDiagnosis
				(	
					idfsDiagnosis
					,idfsUsingType
					,strIDC10
					,strOIECode
					,blnZoonotic
				) 
                VALUES  
				(
					@idfsBaseReference
					,@idfsUsingType
					,@strIDC10
					,@strOIECode
					,ISNULL(@blnZoonotic,0)
				)
		END
		IF @Action = 16 --Modified
		BEGIN
				UPDATE trtDiagnosis
				SET 
						idfsUsingType = @idfsUsingType
						,strIDC10 = @strIDC10
						,strOIECode = @strOIECode
						,blnZoonotic = ISNULL(@blnZoonotic,0)
                WHERE	idfsDiagnosis = @idfsBaseReference
		END
		
	END

END





