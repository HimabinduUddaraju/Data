
CREATE PROCEDURE uSP_Create_External_Tables
(
   @ExternalDataSource Varchar(255),
   @SysTableName varchar(255)
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Dynamically Creates External Tables
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

 DECLARE @PrepareSQL nvarchar(max)
 DECLARE @ExecuteSQL nvarchar(max)
 SET @EXECUTESQL=''

 SET @PrepareSQL ='
 SELECT @Result= (
 SELECT DISTINCT '' ''+  ''IF EXISTS ( SELECT * FROM sys.external_tables WHERE object_id = OBJECT_ID(''''Ext_Tbl_''+so.table_name+'''''') ) DROP EXTERNAL TABLE Ext_Tbl_''+so.table_name+'' CREATE EXTERNAL TABLE Ext_Tbl_'' + so.TABLE_NAME + '' ('' + o.list + '')'' 
				 +'' WITH (Data_Source=['+@ExternalDataSource+'],Schema_Name=''''dbo'''',Object_Name=''''''+so.table_name+'''''')''
  FROM dbo.'+@SysTableName+' so
 CROSS APPLY
   (SELECT STUFF ((SELECT '',''+
           ''  [''+column_name+''] '' + 
           data_type + case data_type
           when ''sql_variant'' then ''''
           when ''text'' then ''''
           when ''ntext'' then ''''
           when ''xml'' then ''''
           when ''decimal'' then ''('' + cast(numeric_precision as varchar) + '', '' + cast(numeric_scale as varchar) + '')''
           else coalesce(''(''+case when character_maximum_length = -1 then ''MAX'' else cast(character_maximum_length as varchar) end +'')'','''') end + '' '' +
           + '' '' +
           (case when IS_NULLABLE = ''No'' then ''NOT '' else '''' end ) + ''NULL '' 
     FROM  dbo.'+@SysTableName+'
    WHERE  table_name = so.table_name
    ORDER  BY ordinal_position
      FOR  XML PATH('''')),1,1,'''')) o (list)
 WHERE so.table_schema<>''sys''
  FOR XML PATH(''''))
  '
 
 
 EXEC SP_EXECUTESQL @PrepareSQL,N'@Result varchar(max) out',@ExecuteSQL OUT

 EXEC SP_EXECUTESQL @ExecuteSQL

 
END TRY

BEGIN CATCH
   SELECT
     ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 

  END CATCH

GO
