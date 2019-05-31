----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: USP_GBL_NextNumbers_GET
-- Description			: Get Next Numbers for barcodes
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
--
--
-- Testing code:
--
-- EXEC USP_GBL_NextNumbers_GET
----------------------------------------------------------------------------
----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GBL_NextNumbers_GET] 
AS
BEGIN

	DECLARE @RC int

	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057006, N'Box Barcode', N'B', N'', 0, 4 
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057011, N'Freezer Barcode', N'W', N'', 0, 4
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057012, N'Shelf Barcode', N'G', N'', 0, 4
	--EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057017, N'Rack Barcode', N'K', N'', 0, 4
	--EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057018, N'Rack Position Barcode', N'L', N'', 0, 4
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057001, N'Human Aggregate Case', N'A', N'', 0, 4,1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057003, N'Vet Aggregate Case', N'Q', N'', 0, 4,1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057002, N'Vet Aggregate Action', N'Z', N'', 0, 4,1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057004, N'Animal', N'X', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057010, N'Farm', N'F', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057013, N'Animal Group', N'I', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057014, N'Human Case', N'H', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057015, N'Outbreak', N'O', N'', 0, 4, 1
	--EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057016, N'Patient ID', N'P', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057019, N'Sample Field Barcode', N'M', N'', 0, 4, 0
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057020, N'Sample/Aliquot/Derivative', N'S', N'', 0, 4, 0
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057022, N'Pendide Test', N'T', N'', 0, 4, 1
	--EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057023, N'Test Request', N'R', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057024, N'Vet Case', N'V', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057025, N'Vet Case Field Accession Number', N'N', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057005, N'Batch Test Barcode',N'C',N'',0,4,1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057026, N'Sample Transfer Barcode', N'Y', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057027, N'Active Surveillance Campaign', N'D', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057028, N'Active Surveillance Session', N'E', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057029, N'Vector Surveillance Session', N'J', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057030, N'Vector Surveillance Vector', N'K', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057031, N'Vector Surveillance Summary Vector', N'P', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057032, N'Basic Syndromic Surveillance Form', N'L', N'', 0, 4, 1
	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057033, N'Basic Syndromic Surveillance Aggregate Form', N'R', N'', 0, 4, 1

	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057007, N'Accession In Act', N'C', N'', 0, 4, 1
	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057009, N'Destruction Act', N'D', N'', 0, 4, 1
	---- PACS
	--if @ModuleName = 'pacs_main' or @ModuleName is null
	--begin
	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057007, N'Accession In Act', N'C', N'', 0, 4
	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057008, N'Transfer Out Barcode', N'Y', N'', 0, 4
	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057009, N'Destruction Act', N'D', N'', 0, 4
	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057021, N'Strain Passport Barcode', N'N', N'', 0, 4
	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057020, N'Sample Barcode', N'S', N'', 0, 4, 1
	--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057026, N'Container Barcode', N'J', N'', 0, 4
	--end


	RETURN @RC

END

