
CREATE PROCEDURE uSP_Load_DataMart
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: LoadDataMart
-- ==================================================

BEGIN TRY

    SET NOCOUNT ON

  TRUNCATE TABLE dbo.EmpDepartment

  INSERT INTO dbo.EmpDepartment
  (Employee_Id
  ,EmployeeName
  ,Department_Id
  ,Department_Name)
  SELECT E.Employee_Id
        ,E.Name
	    ,D.Department_Id
	    ,D.Department_Name
   FROM [dbo].[Ext_Tbl_Emp_Details] E
   LEFT
   JOIN dbo.Ext_Tbl_Department D
     ON E.Department_Id=d.Department_Id
     

 
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
