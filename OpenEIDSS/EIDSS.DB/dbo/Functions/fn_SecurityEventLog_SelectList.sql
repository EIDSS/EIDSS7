

CREATE   FUNCTION dbo.fn_SecurityEventLog_SelectList(@LangID as nvarchar(50))
returns table 
as
return
Select 
	  [idfSecurityAudit]
      ,[idfsAction]
      ,Act.strDefault As [strActionDefaultName]
      ,Act.LongName As [strActionNationalName]
      ,[idfsResult]
      ,Res.strDefault As [strResultDefaultName]
      ,Res.LongName As [strResultNationalName]
      ,[idfsProcessType]
      ,ProcessType.strDefault As [strProcessTypeDefaultName]
      ,ProcessType.LongName As [strProcessTypeNationalName]
      ,[idfAffectedObjectType]
      ,Cast([idfObjectID] as nvarchar) as strObjectID
      ,SA.[idfUserID]
	  ,P.idfPerson
      ,UT.strAccountName
	  ,dbo.fnConcatFullName(strFamilyName, strFirstName, strSecondName)  AS strPersonName
      ,[idfDataAuditEvent]
      ,[datActionDate]
      ,[strErrorText]
      ,[strProcessID]
      ,[strDescription]
  From [dbo].[tstSecurityAudit] SA
  Inner Join dbo.fnReferenceRepair(@LangID, 19000112) Act On SA.idfsAction = Act.idfsReference
  Inner Join dbo.fnReferenceRepair(@LangID, 19000113) Res On SA.idfsResult = Res.idfsReference
  Inner Join dbo.fnReferenceRepair(@LangID, 19000114) ProcessType On SA.idfsProcessType = ProcessType.idfsReference
  LEFT OUTER JOIN	(
					tstUserTable UT
						INNER JOIN	tlbPerson P
						ON		P.idfPerson = UT.idfPerson
					)
		ON		UT.idfUserID = SA.idfUserID



