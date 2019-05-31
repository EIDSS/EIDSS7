

--exec spSmphFF_SelectLookups

CREATE PROCEDURE [dbo].[spSmphFF_SelectLookups] 
AS


-- 0 dummy
select 
	cast(0 as bigint) as idfsDummy

-- 1. table FFTemplate (defines the structure of ff templates)
-- We are collecting all Sections, Parameters and Labels into universal structure
select 
	cast(0 as bigint) as idfsDummy,
	cast(1 as bigint) as idfsBaseReference,
	cast(2 as bigint) as idfsFormTemplate,
	cast(3 as bigint) as idfsBaseReferenceParent,
	cast(4 as bigint) as idfsFormTemplateParent,
	cast(5 as int) as intElementType,
	cast(6 as bigint) as idfsEditor,
	cast(7 as int) as intReadOnly,
	cast(8 as int) as intMandatory,
	cast(9 as bigint) as idfsParameterType,
	cast(10 as int) as intOrder
	
--2. table FFDeterminant - it shall allow finding current template by diagnosis. It shall contain records for 
declare @FFDeterminant table
(
	idfsDummy bigint
	,idfDeterminantValue bigint
	,idfsFormType bigint
	,idfsFormTemplate bigint
)

Insert into @FFDeterminant(idfsDummy, idfDeterminantValue, idfsFormType)
Select
	0	
	,D.idfsReference
	,FT.idfsReference 
From dbo.fnReference('en', 19000034 ) FT
Cross join
dbo.fnReference('en', 19000019) D

declare @ftype bigint, @d bigint, @formtemplate bigint, @gisbr bigint
select @gisbr = dbo.fnCustomizationCountry();

declare curs cursor
	for select idfDeterminantValue, idfsFormType from @FFDeterminant
Open curs

FETCH NEXT FROM curs into @d, @ftype

While @@FETCH_STATUS = 0
Begin
	set @formtemplate = null;
	exec [dbo].[spFFGetActualTemplate] @gisbr, @d, @ftype, @formtemplate Out, 0;

	Update @FFDeterminant
		set idfsFormTemplate = @formtemplate
		where idfDeterminantValue = @d and idfsFormType = @ftype

	FETCH NEXT FROM curs into @d, @ftype
end

close curs
deallocate curs

select idfsDummy
	,idfDeterminantValue
	,idfsFormType
	,idfsFormTemplate
from @FFDeterminant
	
--3. Table FFRule
select 
	  cast(0 as bigint) as idfsDummy
	  ,[idfsRule]
      ,[idfsFormTemplate]
      ,[idfsCheckPoint]
      ,[idfsRuleMessage]
      ,[idfsRuleFunction]
      ,cast([blnNot] as int) as [intNot]
From [dbo].[ffRule]
where intRowStatus = 0;

--4. table FFRuleConstant
select 
	  cast(0 as bigint) as idfsDummy	  
      ,[idfsRule]
      ,cast([varConstant] as nvarchar(512)) as strConstant
From [dbo].[ffRuleConstant]
where intRowStatus = 0;

--5. table FFParameterForFunction - link between parameter and rules
select 
      cast(0 as bigint) as idfsDummy
	  ,[idfsParameter]      
      ,[idfsRule]
      ,[intOrder]      
From [dbo].[ffParameterForFunction]
where intRowStatus = 0;

--6. table FFParameterForAction
select 
	  cast(0 as bigint) as idfsDummy
      ,[idfsParameter]
	  ,[idfsRule]
	  ,[idfsRuleAction]          
From [dbo].[ffParameterForAction]
where intRowStatus = 0;

--7. All templates
Select
	  cast(0 as bigint) as idfsDummy
      ,[idfsFormTemplate]
      ,[idfsFormType]      
From [dbo].[ffFormTemplate]
where intRowStatus = 0;

-- 8. Fixed preset values
Select
	  cast(0 as bigint) as idfsDummy
      ,[idfsParameterFixedPresetValue]
      ,[idfsParameterType]
From [dbo].[ffParameterFixedPresetValue]
where intRowStatus = 0;

-- 9. Reference types for lookups
declare @ReferenceTypeTable table
(
	idfsParameterType bigint
	,DefaultName nvarchar(500)
	,NationalName nvarchar(500)
	,idfsReferenceType bigint
	,[System] int
	,[LangID] varchar(500)
)

Insert into @ReferenceTypeTable
exec dbo.spFFGetParameterReferenceType 'en'
Select
      distinct		
	  cast(0 as bigint) as idfsDummy
      ,idfsReferenceType
From @ReferenceTypeTable
where idfsReferenceType is not null and idfsReferenceType <> 19000069

