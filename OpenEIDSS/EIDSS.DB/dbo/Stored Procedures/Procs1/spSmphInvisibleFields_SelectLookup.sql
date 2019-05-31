

-- exec spSmphInvisibleFields_SelectLookup 51577370000000
CREATE     PROCEDURE [dbo].[spSmphInvisibleFields_SelectLookup] 
	@idfCustomizationPackage bigint
AS
select tstInvisibleFieldsToCP.idfInvisibleField as id, tstInvisibleFields.strFieldAlias as fld
from tstInvisibleFieldsToCP
inner join tstInvisibleFields on tstInvisibleFieldsToCP.idfInvisibleField = tstInvisibleFields.idfInvisibleField
where tstInvisibleFieldsToCP.idfCustomizationPackage = @idfCustomizationPackage

