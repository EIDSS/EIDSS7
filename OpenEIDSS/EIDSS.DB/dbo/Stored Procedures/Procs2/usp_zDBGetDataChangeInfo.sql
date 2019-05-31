
--=====================================================================================================
-- Created by:				Joan Li
-- Description:				06/22/2017: Created for V7 get data chage info
-- Testing code:
/*
----testing code:
execute usp_zDBGetDataChangeInfo 'johnDoe'
execute usp_zDBGetDataChangeInfo 
*/

--=====================================================================================================

CREATE        PROCEDURE [dbo].[usp_zDBGetDataChangeInfo]

( 
	@User varchar(100) =NULL
)
AS	
	BEGIN
		DECLARE @IP_Address varchar(255),  @protocol varchar(100) , @connecttime date,@l_output xml
		select @IP_Address= (select  client_net_address  FROM sys.dm_exec_connections  WHERE Session_id = @@SPID ) 
		select @protocol= (select  protocol_type  FROM sys.dm_exec_connections  WHERE Session_id = @@SPID ) 
		select @connecttime= (select  connect_time  FROM sys.dm_exec_connections  WHERE Session_id = @@SPID ) 
		select @l_output =
		(
		select 
		@IP_Address as connectIP
		,@protocol as protocol_type
		,@connecttime as connect_time
		,convert(varchar,convert(varchar,getdate(),101)) as LastModDate
		,convert(varchar, isnull(@User,SYSTEM_USER)) as LastModUser
		for xml path ('UpdateIndo'), type
		)
		select  @l_output
	END
	





