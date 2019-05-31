


--##SUMMARY Selects tha range of unique barcodes for printing.
--##SUMMARY After this procedure call the barcode counter in the tstNextNumbers table is increased to @count.
--##SUMMARY In distinguish with spGetNextNumberRange this procedure returns the table that contains optional
--##SUMMARY text headers and footers (that is always empty in current version) for printing barcodes.
--##SUMMARY This procedure is called from BarcodePrint form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.12.2009

--##RETURNS Doesn't use



/*
Example of procedure call:

DECLARE @NextNumberName bigint
DECLARE @count int
DECLARE @InstallationSite bigint

EXECUTE spGetBarcodeRange
@NextNumberName
,@count
,@InstallationSite

*/


CREATE     PROCEDURE [dbo].[spGetBarcodeRange]
@NextNumberName AS bigint, --##PARAM @NumberingObjectID - ID of numbering object to print
@count AS int, --##PARAM @count - the number of barcodes in the printing range
@InstallationSite bigint --##PARAM @InstallationSite - ID of site for which barcode is printing
AS
SET @InstallationSite = ISNULL(@InstallationSite, dbo.fnSiteID())

IF EXISTS (SELECT name FROM SYSOBJECTS WHERE name = '#BarcodeRange')
BEGIN
DROP TABLE #BarcodeRange
END

CREATE TABLE #BarcodeRange
(
NumbersRange nvarchar (200) COLLATE database_default NOT NULL  PRIMARY KEY,
[TopLine] nvarchar (100) COLLATE database_default,
[BottomLine] nvarchar (100) COLLATE database_default
)

INSERT INTO #BarcodeRange (NumbersRange)
EXEC spGetNextNumberRange @NextNumberName, @count, @InstallationSite

UPDATE	#BarcodeRange
SET [TopLine] = ''

UPDATE	#BarcodeRange
SET [BottomLine] = ''

SELECT * FROM #BarcodeRange

DROP TABLE #BarcodeRange




