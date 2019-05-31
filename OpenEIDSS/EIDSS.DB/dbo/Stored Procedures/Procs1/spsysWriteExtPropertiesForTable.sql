


--##SUMMARY This procedure write extended property value of table and column 

--##REMARKS Author: Romasheva S.
--##REMARKS 
--##REMARKS Update date: 

--##RETURNS 


/*
Example of a call of procedure:

-- ��������� extended property ��� �������
EXEC dbo.spsysWriteExtPropertiesForTable 'tstNewID' ,'������� ��� ��������� ����� ID', NULL, NULL


-- ��������� extended property ��� ���� �������
EXEC dbo.spsysWriteExtPropertiesForTable 'tstNewID', NULL, 'NewID', '���� ������������ ����� ID'

*/



CREATE PROCEDURE 
  [dbo].[spsysWriteExtPropertiesForTable]
  (
  @TableName varchar(100),
  @TableDescription varchar(1000),
  @FieldName varchar(100) = NULL,
  @FieldDescription varchar(1000) = NULL,
  @ExPropName varchar(100) = 'MS_Description'
  )  
AS

-- ������� �������� MS_Description �������, ���� � ������� ��� ���� ��������, ������ ���
  IF (@FieldName IS NULL) OR (@FieldDescription IS NULL)
  BEGIN
    IF EXISTS(
              SELECT * FROM 
                  ::fn_listextendedproperty(NULL, 'USER', 'dbo', 'Table', @TableName, NULL, NULL)
              WHERE name = @ExPropName        
             )
    BEGIN
      EXEC dbo.sp_dropextendedproperty @ExPropName, 'USER', 'dbo', 'Table', @TableName, NULL, NULL
    END
    IF @TableDescription IS NOT NULL
      EXEC dbo.sp_addextendedproperty @ExPropName, @TableDescription, 'USER', 'dbo', 'Table', @TableName, NULL, NULL
  END

  IF (@FieldName IS NOT NULL) AND (@FieldDescription IS NOT NULL)
  BEGIN
    IF EXISTS(
              SELECT * FROM 
                  ::fn_listextendedproperty(NULL, 'USER', 'dbo', 'Table', @TableName, 'Column', @FieldName)
              WHERE name = @ExPropName 
             )
    BEGIN
      EXEC dbo.sp_dropextendedproperty @ExPropName, 'USER', 'dbo', 'Table', @TableName, 'Column', @FieldName
    END

    IF @FieldDescription IS NOT NULL
      EXEC dbo.sp_addextendedproperty @ExPropName, @FieldDescription, 'USER', 'dbo', 'Table', @TableName, 'Column', @FieldName    

  END








