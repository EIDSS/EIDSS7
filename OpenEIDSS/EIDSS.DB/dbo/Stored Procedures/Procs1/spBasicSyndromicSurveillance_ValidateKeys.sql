
--##SUMMARY Checks foreign keys for BasicSyndromicSurveillance object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spBasicSyndromicSurveillance_Validate @ID
*/

CREATE PROCEDURE [dbo].[spBasicSyndromicSurveillance_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - BasicSyndromicSurveillance ID
AS
	EXEC spValidateKeys 'tlbBasicSyndromicSurveillance', @RootId, 'BSS'

