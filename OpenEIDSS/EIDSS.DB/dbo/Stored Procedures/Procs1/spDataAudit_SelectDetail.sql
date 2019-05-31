
















--##SUMMARY Returns data for DataAuditDetail form.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.04.2010

--##RETURNS Doesn't use

/*
--Example of procedure call:
DECLARE @ID bigint
SELECT @ID = idfDataAuditEvent from fn_DataAudit_SelectList('en')
exec spDataAudit_SelectDetail @ID, 'en'

*/


create           PROCEDURE dbo.spDataAudit_SelectDetail
	@idfDataAuditEvent AS bigint,	--##PARAM @idfDataAuditEvent - data audit event ID
	@LangID AS nvarchar(50)			--##PARAM @LangID - language ID
AS

SELECT idfDataAuditEvent
      ,ObjectType.name AS strObjectType
      ,idfsDataAuditEventType
      ,EventType.name AS strActionName
      ,idfMainObject
      ,tauTable.strName as strTableName
      ,tstSite.strSiteID
      ,datEnteringDate
      ,strHostname
	  ,dbo.fnConcatFullName(tlbPerson.strFirstName, tlbPerson.strSecondName, tlbPerson.strFamilyName)  AS strPersonName

  FROM tauDataAuditEvent
INNER JOIN		fnReference(@LangID,19000016) AS EventType --'rftDataAuditEventType'
	ON				tauDataAuditEvent.idfsDataAuditEventType = EventType.idfsReference
				
INNER JOIN		fnReference(@LangID,19000017) AS ObjectType --'rftDataAuditObjectType'
	ON				tauDataAuditEvent.idfsDataAuditObjectType = ObjectType.idfsReference
INNER JOIN tstSite
	ON	tauDataAuditEvent.idfsSite = tstSite.idfsSite
LEFT OUTER JOIN tauTable 
	ON tauTable.idfTable = tauDataAuditEvent.idfMainObjectTable

LEFT OUTER JOIN	(
	tstUserTable 
	INNER JOIN		tlbPerson 
	ON				tlbPerson.idfPerson = tstUserTable.idfPerson
				)
ON				tstUserTable.idfUserID = tauDataAuditEvent.idfUserID
WHERE 
	idfDataAuditEvent=@idfDataAuditEvent

DECLARE @Create AS NVARCHAR(200)
DECLARE @Edit AS NVARCHAR(200)
DECLARE @Delete AS NVARCHAR(200)
DECLARE @restore AS NVARCHAR(200)
SELECT @Create = name FROM fnReference(@LangID,19000016) WHERE idfsReference = 10016001
SELECT @Edit = name FROM fnReference(@LangID,19000016) WHERE idfsReference = 10016003
SELECT @Delete = name FROM fnReference(@LangID,19000016) WHERE idfsReference = 10016002
SELECT @restore = name FROM fnReference(@LangID,19000016) WHERE idfsReference = 10016005

SELECT idfDataAuditDetailUpdate as idfDataAuditDetail
      ,tauTable.strName as strTableName
      ,tauColumn.strName as strColumnName
      ,idfObject
      ,idfObjectDetail
      ,strOldValue
      ,strNewValue
	  ,@Edit as strActionType
  FROM tauDataAuditDetailUpdate
LEFT OUTER JOIN tauTable 
	ON tauTable.idfTable = tauDataAuditDetailUpdate.idfObjectTable
LEFT OUTER JOIN tauColumn 
	ON tauColumn.idfColumn = tauDataAuditDetailUpdate.idfColumn
WHERE 
	idfDataAuditEvent=@idfDataAuditEvent

UNION

SELECT idfDataAuditDetailDelete as idfDataAuditDetail
      ,tauTable.strName as strTableName
      ,NULL AS strColumnName
      ,idfObject
      ,idfObjectDetail
      ,NULL AS strOldValue
      ,NULL AS strNewValue
	  ,@Delete as strActionType

  FROM tauDataAuditDetailDelete
INNER JOIN tauTable 
	ON tauTable.idfTable = tauDataAuditDetailDelete.idfObjectTable
WHERE 
	idfDataAuditEvent=@idfDataAuditEvent

UNION

SELECT idfDataAuditDetailRestore as idfDataAuditDetail
      ,tauTable.strName as strTableName
      ,NULL AS strColumnName
      ,idfObject
      ,idfObjectDetail
      ,NULL AS strOldValue
      ,NULL AS strNewValue
	  ,@restore as strActionType

  FROM tauDataAuditDetailRestore
INNER JOIN tauTable 
	ON tauTable.idfTable = tauDataAuditDetailRestore.idfObjectTable
WHERE 
	idfDataAuditEvent=@idfDataAuditEvent

UNION 

SELECT idfDataAuditDetailCreate as idfDataAuditDetail
      ,tauTable.strName as strTableName
      ,NULL AS strColumnName
      ,idfObject
      ,idfObjectDetail
      ,NULL AS strOldValue
      ,NULL AS strNewValue
	  ,@Create as strActionType
  FROM tauDataAuditDetailCreate
INNER JOIN tauTable 
	ON tauTable.idfTable = tauDataAuditDetailCreate.idfObjectTable
WHERE 
	idfDataAuditEvent=@idfDataAuditEvent


