

CREATE PROCEDURE [dbo].[spUserOptionsSave]
	@UserID as bigint,
	@strOptions AS varchar(max)
AS
BEGIN

 if exists (select 1 from tstUserTableLocal where idfUserID = @UserID)    
  update tstUserTableLocal      
  set  strOptions=@strOptions   
  where idfUserID=@UserID      
 else    
 insert tstUserTableLocal (idfUserID, strOptions)    
 values (@userID, @strOptions)    

END


