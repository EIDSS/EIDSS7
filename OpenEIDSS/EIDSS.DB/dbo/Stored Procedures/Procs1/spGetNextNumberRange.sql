





--##SUMMARY Selects tha range of unique barcodes for printing. 
--##SUMMARY After this procedure call the barcode counter in the tstNextNumbers table is increased to @count. 
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.12.2009

--##RETURNS Doesn't use



/*
Example of procedure call:

DECLARE @NextNumberName bigint
DECLARE @count int
DECLARE @InstallationSite bigint

EXECUTE spGetNextNumberRange
   @NextNumberName
  ,@count
  ,@InstallationSite

*/


CREATE      PROCEDURE dbo.spGetNextNumberRange 
	@NextNumberName AS bigint, --##PARAM @NumberingObjectID - ID of numbering object to print
	@count AS int, --##PARAM @count - the number of barcodes in the printing range
	@InstallationSite bigint --##PARAM @InstallationSite - ID of site for which barcode is printing
AS

DECLARE @i int
IF EXISTS (SELECT name FROM sysobjects WHERE name = '#NextNumberRange')
BEGIN
	DROP TABLE #NextNumberRange
END

CREATE TABLE #NextNumberRange ( 
	NumbersRange nvarchar (200) COLLATE database_default NOT NULL  PRIMARY KEY
	)

SET @i=0
DECLARE @NextNumberValue nvarchar(200)
While @i<@count
BEGIN
-- Set parameter values
	EXEC [dbo].[spGetNextNumber] @NextNumberName, @NextNumberValue OUTPUT, @InstallationSite 	
	Insert Into #NextNumberRange
		(NumbersRange)
	VALUES
		(@NextNumberValue)
		
SET @i=@i+1
END

Select NumbersRange
FROM #NextNumberRange










