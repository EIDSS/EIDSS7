﻿


--##SUMMARY This function returns extended property value of column for given table

--##REMARKS Author: Romasheva S.
--##REMARKS 
--##REMARKS Update date: 

--##RETURNS Returns extended property value of column


/*
Example of a call of function:

select dbo.fnsysGetColumnExtendedProperty('ffDecorElement', 'idfDecorElement')

*/



CREATE  FUNCTION dbo.fnsysGetColumnExtendedProperty
  (
      @TableName NVARCHAR(128),--##PARAM @TableName Table name
      @Column  NVARCHAR(128)--##PARAM @Column Column name
  )  
RETURNS NVARCHAR(2000)  
AS
BEGIN
	
    DECLARE 
       @Value NVARCHAR(2000),  
       @ExPropName NVARCHAR(128)

    SET  @ExPropName = N'MS_Description'
      
    SELECT 
        @Value = CAST(VALUE AS NVARCHAR(2000))
    FROM ::fn_listextendedproperty(NULL, 'USER', 'dbo', 'Table', @TableName, 'Column', @Column)
    WHERE name = @ExPropName
    
             
    RETURN (@Value)
END


