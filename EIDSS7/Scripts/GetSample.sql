declare @ret int
declare @Logmsg nvarchar(max)
declare @results nvarchar(max)

set @results = ''
set @Logmsg = 'Single Sample'

declare @idfMaterial bigint
--set @idfMaterial = 52610500000000;

--declare @strBarCode nvarchar(50)
--set @strBarcode = 'S001170360'
--set @strBarCode = (select strBarCode from dbo.tlbMaterial where idfMaterial = @idfMaterial) - Commented by VT
Set @idfMaterial = (select top 1 idfMaterial from dbo.tlbMaterial where strBarCode = @strBarcode And intRowStatus = 0)

declare @MList table(
  idfMaterial bigint,
  strBarCode nvarchar(50),
  idfRootMaterial bigint,
  idfParentMaterial bigint,
  MLevel int
); 

with MList as
(
  select M.idfMaterial, M.strBarCode, M.idfRootMaterial, M.idfParentMaterial, 0 as Level
  from dbo.tlbMaterial M
  where M.idfMaterial = @idfMaterial
  and M.intRowStatus = 0
  union all

  select  T.idfMaterial, T.strBarCode, T.idfRootMaterial, T.idfParentMaterial, M.Level + 1
  from dbo.tlbMaterial T 
  INNER JOIN MList M on T.idfParentMaterial = M.idfMaterial
  where T.intRowStatus = 0
 )

insert into @MList
select * from MList
order by idfMaterial

select @ret = count(*) from @MList

select @results = coalesce(@results + ' ; ','') + strBarCode from @MList where idfMaterial != @idfMaterial

if (@ret > 1)
begin
  set @LogMsg = 'Sample ' + @strBarCode + ' has been split.  In order to delete this sample, the following samples also need to be deleted:' + char(13) + char(10) + @results
end

-- get related VetCase, sessions, etc.
select 
  M.idfMaterial,
  --@Logmsg, -- Commented by VT
  SUBSTRING (@results, 3, LEN(@results)) [Aliquot/Derivative Samples],
  M.strBarcode,
  VC.strCaseID,
  MS.strMonitoringSessionID,
  SampleType.strDefault as SampleType,
  P.strFirstName + ' ' + P.strSecondName + ' ' + P.strFamilyName as PersonCollectedBy

from dbo.tlbMaterial M
left outer join dbo.tlbVetCase VC on M.idfVetCase = VC.idfVetCase
left outer join dbo.tlbMonitoringSession MS on M.idfMonitoringSession = MS.idfMonitoringSession
left outer join dbo.trtBaseReference SampleType on M.idfsSampleType = SampleType.idfsBaseReference
left outer join dbo.tlbPerson P on M.idfFieldCollectedByPerson = P.idfPerson

--where M.idfMaterial in (select idfMaterial from @MList) -- Commented by VT
Where M.idfMaterial = @idfMaterial

