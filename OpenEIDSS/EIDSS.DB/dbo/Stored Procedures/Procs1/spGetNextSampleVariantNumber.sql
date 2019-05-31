



--##REMARKS CREATED BY: Romasheva S.
--##REMARKS Date: 13.09.2013

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 27.03.2015

/*
 declare @NextNumberValue nvarchar(100)
 exec [spGetNextSampleVariantNumber] 943630001104, 'D', @NextNumberValue out
 print @NextNumberValue
  
 exec [spGetNextSampleVariantNumber] 943630001104, 'A', @NextNumberValue
 print @NextNumberValue
*/

create PROCEDURE [dbo].[spGetNextSampleVariantNumber] ( 
	 @idfMaterial bigint --id of parent material
	,@variantType char(1) -- type of variant, can accept values 'A' or 'D' - aliqoute or derivative
	,@NextNumberValue AS NVARCHAR(1000) OUTPUT
)
AS
declare @SampleBarCode NVARCHAR (200)
declare @strBarcode NVARCHAR(200)
declare @idfBaseMaterial bigint
declare @CountChild int


;with MaterialTree_GetRoot (idfMaterial, idfParentMaterial, idfsSampleKind, strBaseBarcode)
as (
		select 
			m.idfMaterial,
			m.idfParentMaterial,
			m.idfsSampleKind,
			strBaseBarcode = m.strBarcode
		from tlbMaterial m
		where m.idfMaterial = @idfMaterial
		union all
		select 
			m.idfMaterial,
			m.idfParentMaterial,
			m.idfsSampleKind,
			strBaseBarcode = m.strBarcode
		from tlbMaterial m
			join MaterialTree_GetRoot mt  
			on mt.idfParentMaterial = m.idfMaterial
			and mt.idfParentMaterial is not null 
			and mt.idfsSampleKind <> 12675430000000
)

select	@idfBaseMaterial = mt.idfMaterial, @SampleBarCode = mt.strBaseBarcode
from MaterialTree_GetRoot mt
where mt.idfParentMaterial is null 
	  or mt.idfsSampleKind = 12675430000000
	  

;with MaterialTree_FromRoot (idfMaterial, idfParentMaterial, idfsSampleKind, idfBaseMaterial, idfBaseParentMaterial, strBaseBarcode)
as (
		select 
			m.idfMaterial,
			m.idfParentMaterial,
			m.idfsSampleKind,
			idfBaseMaterial = m.idfMaterial,
			idfBaseParentMaterial = m.idfParentMaterial,
			strBaseBarcode = m.strBarcode
		from tlbMaterial m
		where m.idfMaterial = @idfBaseMaterial
		union all
		select 
			m.idfMaterial,
			m.idfParentMaterial,
			m.idfsSampleKind,
			idfBaseMaterial = mt.idfBaseMaterial,
			idfBaseParentMaterial = mt.idfBaseParentMaterial,
			strBaseBarcode = mt.strBaseBarcode
		from tlbMaterial m
			join MaterialTree_FromRoot mt  
			on mt.idfMaterial = m.idfParentMaterial
)

SELECT		@CountChild = count (mt.idfBaseMaterial)
FROM		MaterialTree_FromRoot mt
where		mt.idfsSampleKind = case 
										when @variantType = 'A' then 12675410000000 
										when @variantType = 'D' then 12675420000000
										else null
									end		
							
print @SampleBarCode
print @idfBaseMaterial
print @CountChild							 

set @strBarcode = @SampleBarCode + @variantType + dbo.fnAlphaNumeric(isnull(@CountChild, 0), 2)

while exists (select * from tlbMaterial where strBarcode = @strBarCode)
begin
	set @CountChild = isnull(@CountChild, 0) + 1
	set @strBarcode = @SampleBarCode + @variantType + dbo.fnAlphaNumeric(isnull(@CountChild, 0), 2)
end

set @NextNumberValue = @strBarcode














