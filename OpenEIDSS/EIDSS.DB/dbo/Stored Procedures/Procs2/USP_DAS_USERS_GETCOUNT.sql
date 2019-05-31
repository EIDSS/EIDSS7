USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_DAS_USERS_GETList]    Script Date: 12/11/2018 4:26:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================
-- NAME: USP_DAS_USERS_GETCOUNT
-- DESCRIPTION: Returns a count of users in the system
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name				Date			Change Detail
-- Ricky Moss		05/07/2018		Initial Release
-- Testing Code:
-- exec USP_DAS_USERS_GETCount
-- ============================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_USERS_GETCOUNT]
AS
BEGIN
	BEGIN TRY
	SELECT		
				COUNT(tlbPerson.idfPerson) AS RecordCount
				FROM	
					tlbPerson
					INNER JOIN tlbEmployee ON
						tlbEmployee.idfEmployee = tlbPerson.idfPerson
						AND 
						tlbEmployee.intRowStatus = 0		
	END TRY  
	BEGIN CATCH 
		THROW;
	END CATCH
END