
-- select * from fnGetRunningReplications()
/*
returns running replications
*/

CREATE FUNCTION [dbo].[fnGetRunningReplications]
(
)
RETURNS @runningReplications TABLE (
   session_id       int      NOT NULL,
   subscriber_name nvarchar(128) NULL
) 
AS
BEGIN

if exists (select * from sys.databases   where [name] = 'distribution')
 and exists (select * from sys.tables where	[name] = 'MSMerge_Sessions')
INSERT INTO @runningReplications (session_id, subscriber_name) 

SELECT 
MSMerge_Sessions.session_id,
a.subscriber_name collate Cyrillic_General_CI_AS as subscriber_name
FROM MSMerge_Sessions 
INNER JOIN 
(
 SELECT 
Agent_ID, 
MaxTime = MAX(Start_Time) 
FROM 
MSMerge_Sessions 
GROUP BY 
Agent_ID
 ) AS CurrentSession ON 
CurrentSession.Agent_ID = MSMerge_Sessions.Agent_ID AND 
Start_Time = MaxTime 
INNER JOIN distribution.dbo.MSMerge_Agents a ON 
a.ID = MSMerge_Sessions.Agent_ID 
WHERE 
a.Publisher_db = DB_NAME()
AND MSMerge_Sessions.RunStatus IN (1,3,4,5)/* 1-'starting' 3-'running but idle' 4-'in progress' 5-'retrying' */

RETURN;
END



