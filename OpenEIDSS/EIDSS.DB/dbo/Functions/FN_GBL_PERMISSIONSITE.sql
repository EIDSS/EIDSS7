
--*************************************************************
-- Name 				: FN_GBL_PERMISSIONSITE
-- Description			: According new concept permissions are created for single site and all permission objects use these permissions on any site. 
--							By default returns reference to BV site.RETURNS id of site to which all permissions shall be linked
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--Example of function call:
--SELECT dbo.FN_GBL_PERMISSIONSITE()
--*/
--*************************************************************

CREATE FUNCTION [dbo].[FN_GBL_PERMISSIONSITE]()
RETURNS BIGINT
AS
BEGIN
	RETURN 1
END


