--=============================================================
--Created by: Joan
--Created on: 05/23/2017 
--Note: script for getting the role info for userid
--=============================================================
declare @LogMsg varchar(max)
declare @dbo varchar (10) 
declare @ddl varchar (10)
Set @LogMsg=''

--Declare @User varChar(100)  
--======================================= 
--for unit testing
----set @User = 'srvcEIDSSDelete'
--======================================
IF @User is null or @User=''
	set @LogMsg='Invalid userid.'
ELSE
	BEGIN
		;with TempU
		as (
		SELECT
		UserName,
		Max
		(CASE RoleName WHEN 'db_owner' THEN 'Yes' ELSE 'No' END) AS db_owner,
		Max
		(CASE RoleName WHEN 'db_ddladmin' THEN 'Yes' ELSE 'No' END) AS db_ddladmin
		from 
		 (
		select b.name as USERName, c.name as RoleName
		from dbo.sysmembers a join dbo.sysusers b on a.memberuid = b.uid
		join dbo.sysusers c on a.groupuid = c.uid 
		where b.name =@User 
		) t
		Group 
		by USERName
		)
		select @dbo=db_owner,@ddl= db_ddladmin  from TempU 
		if @dbo='No' and @ddl='No'
				set @LogMsg='No permission to create table.'
		else
			set @LogMsg='With permission to create table.'
	END
select @LogMsg
