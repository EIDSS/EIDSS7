
CREATE PROCEDURE [dbo].[spRepositoryScheme_CopyFreezer]
	@idfFreezer bigint, 
	@strFreezerName nvarchar(200)
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @idfNewFreezer bigint
	exec spsysGetNewID @idfNewFreezer OUTPUT
	INSERT INTO tlbFreezer(
			idfFreezer,
			strFreezerName, 
			strNote, 
			strBarcode, 
			idfsStorageType
			)
	SELECT
			@idfNewFreezer,
			@strFreezerName, 
			strNote, 
			NULL, --strBarcode, 
			idfsStorageType
	FROM tlbFreezer
	WHERE 
		idfFreezer = @idfFreezer


	-- Create new id for freezer Subdivisions in temporary table
	DECLARE @Subdivisions TABLE
	(
	idfSubdivision bigint,
	idfNewSubdivision bigint
	)


	INSERT INTO @Subdivisions
	(
		idfSubdivision
	)
	SELECT DISTINCT 
				idfSubdivision
	FROM		tlbFreezerSubdivision
	WHERE		idfFreezer = @idfFreezer
				and intRowStatus = 0

	delete from	tstNewID

	insert into	tstNewID
	(	idfTable,
		idfKey1
	)
	select		75570000000,--	tlbFreezerSubdivision
			  idfSubdivision
	from	@Subdivisions  a
	WHERE idfNewSubdivision is null

	update		s
	set			s.idfNewSubdivision = nID.[NewID]
	from		@Subdivisions  s
	inner join	tstNewID nID
	on			nID.idfKey1 = s.idfSubdivision
	WHERE s.idfNewSubdivision IS NULL 

	delete from	tstNewID

	-- now @Subdivisions table contains pairs old Subdivision id/new Subdivision id

	INSERT INTO tlbFreezerSubdivision(
			idfSubdivision, 
			strNameChars, 
			idfFreezer, 
			strNote, 
			strBarcode, 
			idfsSubdivisionType, 
			idfParentSubdivision,
			intCapacity
	)
	SELECT	s.idfNewSubdivision, 
			fs.strNameChars, 
			@idfNewFreezer, 
			fs.strNote, 
			NULL, --strBarcode, 
			fs.idfsSubdivisionType, 
			fs.idfParentSubdivision,
			fs.intCapacity
	FROM		tlbFreezerSubdivision fs
	inner join @Subdivisions s on
		s.idfSubdivision = fs.idfSubdivision
	WHERE		idfFreezer = @idfFreezer

	UPDATE tlbFreezerSubdivision
	SET idfParentSubdivision = s.idfNewSubdivision
	FROM @Subdivisions s
	where s.idfSubdivision = tlbFreezerSubdivision.idfParentSubdivision
		and tlbFreezerSubdivision.idfFreezer = @idfNewFreezer
	COMMIT TRAN
END TRY
BEGIN CATCH
    -- Test whether the transaction is uncommittable.
    IF (XACT_STATE()) = -1
    BEGIN
        PRINT
            N'The transaction is in an uncommittable state. ' +
            'Rolling back transaction.'
        ROLLBACK TRAN
    END;

    -- Test whether the transaction is active and valid.
    IF (XACT_STATE()) = 1
    BEGIN
        PRINT
            N'The transaction is committable. ' +
            'Committing transaction.'
        COMMIT TRAN
    END
	RETURN -1
END CATCH


RETURN 0
