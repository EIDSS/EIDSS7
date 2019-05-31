    
--*************************************************************    
-- Name     : USP_ADMIN_USR_LOGININFO_SET    
-- Description   : Insert/Update user login info    
--              
-- Author               : Maheshwar D Deo    
-- Revision History    
--  Name       Date       Change Detail    
--  Arnold Kennedy 08-02-2018  - Change input parms from idfPerson to idfEmployee  
--    
-- Testing code:    
--*************************************************************    
    
CREATE PROCEDURE [dbo].[USP_ADMIN_USR_LOGININFO_SET]    
 (    
  @idfUserID   BIGINT = NULL OUTPUT    
  --,@idfPerson   BIGINT = NULL    
 ,@idfEmployee   BIGINT = NULL    
 ,@strAccountName NVARCHAR(200) = NULL    
 ,@binPassword  VARBINARY(50) = NULL    
 )    
AS     
    
DECLARE @returnCode  INT = 0     
DECLARE @returnMsg  NVARCHAR(MAX) = 'SUCCESS'     
DECLARE @idfsPersonSite BIGINT    
    
BEGIN    
 BEGIN TRY       
    
  BEGIN TRANSACTION    
    
  --------------------------------------------------------------------    
  -- Insert    
  --------------------------------------------------------------------    
  DECLARE @datPasswordSet DATETIME    
  SET @datPasswordSet = GETDATE()    
    
  IF NOT EXISTS (SELECT idfUserId FROM tstUserTable WHERE idfUserID = @idfUserID)    
    
   BEGIN    
    
    BEGIN    
     EXEC dbo.USP_GBL_NEXTKEYID_GET 'tstUserTable', @idfUserID OUTPUT    
    END    
     
    --@idfsSite of user table record must be initialized by site of person organization site    
    --interface form prevents editing login info if person organization is not related with any site    
        
    SELECT @idfsPersonSite = s.idfsSite    
    FROM  tlbPerson p      
    INNER JOIN tstSite s ON s.idfOffice = p.idfInstitution and s.intRowStatus = 0    
     --   WHERE  p.idfPerson = @idfPerson   
    WHERE  p.idfPerson = @idfEmployee      
    
    IF @idfsPersonSite IS NULL    
     BEGIN    
          RAISERROR('Person does not have associated site!',18,0)    
      RETURN    
       END    
    
    -- Insert into user table    
    INSERT INTO [dbo].[tstUserTable]    
    (    
     idfUserID    
     ,idfPerson    
     ,idfsSite    
     ,strAccountName    
     ,binPassword    
     ,datPasswordSet     
    )    
    VALUES    
    (    
     @idfUserID    
     --,@idfPerson 
	 ,@idfEmployee     
     ,@idfsPersonSite    
     ,@strAccountName    
     ,@binPassword    
     ,@datPasswordSet    
    )    
    
   END    
  ELSE    
   ---------------------------------------------------------------------------------    
   -- Update    
   ---------------------------------------------------------------------------------    
   BEGIN     
     
    UPDATE [dbo].[tstUserTable]    
    SET  strAccountName = @strAccountName    
      ,binPassword = @binPassword    
      ,datPasswordSet = @datPasswordSet    
    WHERE  idfUserID = @idfUserID    
    
   END    
    
  IF @@TRANCOUNT > 0     
   COMMIT      
    
  SELECT @returnCode, @returnMsg    
    
 END TRY      
    
 BEGIN CATCH     
    
  SET @returnMsg =     
   'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() )     
   + ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )    
   + ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())    
   + ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')    
   + ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))    
   + ' ErrorMessage: '+ ERROR_MESSAGE()    
    
  SET @returnCode = ERROR_NUMBER()    
    
  SELECT @returnCode, @returnMsg    
    
 END CATCH    
END 
