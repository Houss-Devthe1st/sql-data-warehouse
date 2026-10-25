/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze as 
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME

	BEGIN TRY
		SET @batch_start_time = GETDATE()
		PRINT('====================================================')
		PRINT('-------------Loading the bronze Layer---------------')
		PRINT('====================================================')
		---CRM---
		PRINT('-------------Loading CRM section-------------')
		SET @start_time = GETDATE()
		PRINT('>> Truncating table: bronze.crm_cust_info')
		TRUNCATE table bronze.crm_cust_info
		PRINT('>> Inserting into table: bronze.crm_cust_info')
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\User\Documents\Data Engineering Projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			Firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE() 
		PRINT '>> LOAD DURATION: ' + CAST (datediff(second, @start_time, @end_time) as NVARCHAR) + ' seconds'
		PRINT '>>-------------------------------------------------------------------<<'
		SET @start_time = GETDATE()
		PRINT('>> Truncating table: bronze.crm_prd_info')
		TRUNCATE table bronze.crm_prd_info
		PRINT('>> Inserting into table: bronze.crm_prd_info')
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\User\Documents\Data Engineering Projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			Firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST (datediff(second, @start_time, @end_time) as NVARCHAR) + ' seconds'
		PRINT '>>-------------------------------------------------------------------<<'
		SET @start_time = GETDATE()
		PRINT('>> Truncating table: bronze.crm_sales_details')
		TRUNCATE table bronze.crm_sales_details
		PRINT('>> Inserting into table: bronze.crm_sales_details')
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\User\Documents\Data Engineering Projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			Firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST (datediff(second, @start_time, @end_time) as NVARCHAR) + ' seconds'
		---ERP---
		PRINT('---------------------------------------------------')
		PRINT('---------------Loading ERP section-----------------')
		PRINT('---------------------------------------------------')
		SET @start_time = GETDATE()
		PRINT('>> Truncating table: bronze.erp_cust_az12')
		TRUNCATE table bronze.erp_cust_az12	
		PRINT('>> Inserting into table: bronze.erp_cust_az12')
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\User\Documents\Data Engineering Projects\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			Firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST (datediff(second, @start_time, @end_time) as NVARCHAR) + ' seconds'
		PRINT '>>-------------------------------------------------------------------<<'
		SET @start_time = GETDATE()
		PRINT('>> Truncating table: bronze.erp_loc_a101')
		TRUNCATE table bronze.erp_loc_a101
		PRINT('>> Inserting into table: bronze.erp_loc_a101')
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\User\Documents\Data Engineering Projects\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			Firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST (datediff(second, @start_time, @end_time) as NVARCHAR) + ' seconds'
		PRINT '>>-------------------------------------------------------------------<<'
		SET @start_time = GETDATE()
		PRINT('>> Truncating table: bronze.erp_px_cat_g1v2')
		TRUNCATE table bronze.erp_px_cat_g1v2
		PRINT('>> Inserting into table: bronze.erp_px_cat_g1v2')
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\User\Documents\Data Engineering Projects\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			Firstrow = 2,
			fieldterminator = ',',
			tablock
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST (datediff(second, @start_time, @end_time) as NVARCHAR) + ' seconds'
		SET @batch_end_time = GETDATE()
		PRINT '========================================================='
		PRINT 'Loading Bronze Layer COMPLETE. Total Duration = ' + CAST (datediff(second, @start_time, @end_time) as NVARCHAR) + ' seconds'
		PRINT '========================================================='
		END TRY
		BEGIN CATCH
			PRINT '============================================='
			PRINT 'ERROR occured during BRONZE LAYER'
			PRINT 'ERROR MESSAGE' + error_message()
			PRINT 'ERROR NUMBER' + CAST(error_number() as NVARCHAR)
			PRINT 'ERROR STATE' + CAST(error_state() as NVARCHAR)
			PRINT '============================================='
		END CATCH
END
