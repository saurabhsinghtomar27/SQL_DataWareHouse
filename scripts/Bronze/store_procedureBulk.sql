/*
Author: Saurabh Singh
====================================================
Description:
Bronze Layer - Bulk Load Data
====================================================
Note: Please make sure you copied the source files in docker container at /datasets/ folder before executing this script.
command to copy the files in docker container:
docker cp <source_path> <container_name>:/datasets/
====================================================
*/
exec bronze.load_bronze;

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
   Declare @StartTime datetime;
   Declare @EndTime datetime;
    BEGIN TRY
        PRINT 'Bulk Loading Data into Bronze Layer';
        SET @StartTime = GETDATE();
        PRINT 'Inserting data into bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info FROM '/datasets/source_crm/cust_info.csv'
            WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, FIRSTROW = 2);
        set @EndTime = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' seconds';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT 'Inserting data into bronze.crm_prd_info';
        Set @StartTime = GETDATE();
        BULK INSERT bronze.crm_prd_info FROM '/datasets/source_crm/prd_info.csv'
            WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, FIRSTROW = 2);
        set @EndTime = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' seconds';
        PRINT 'Inserting data into bronze.crm_sales_details';
        Set @StartTime = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details FROM '/datasets/source_crm/sales_details.csv'
            WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, FIRSTROW = 2);
        set @EndTime = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' seconds';
        PRINT 'Inserting data into bronze.erp_cust_az12';
        set @starttime = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12 FROM '/datasets/source_erp/cust_az12.csv'
            WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, FIRSTROW = 2);
        set @EndTime = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' seconds';
        PRINT 'Inserting data into bronze.erp_loc_a101';
        set @starttime = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101 FROM '/datasets/source_erp/loc_a101.csv'
            WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, FIRSTROW = 2);
        set @EndTime = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' seconds';
        PRINT 'Inserting data into bronze.erp_px_cat_g1v2';
        set @starttime = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2 FROM '/datasets/source_erp/px_cat_g1v2.csv'
            WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, FIRSTROW = 2);
        set @EndTime = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS VARCHAR(10)) + ' seconds';
        SELECT count(*) AS total_records
        FROM   bronze.crm_cust_info;
        SELECT count(*) AS total_records
        FROM   bronze.crm_prd_info;
        SELECT count(*) AS total_records
        FROM   bronze.crm_sales_details;
        SELECT count(*) AS total_records
        FROM   bronze.erp_cust_az12;
        SELECT count(*) AS total_records
        FROM   bronze.erp_loc_a101;
        SELECT count(*) AS total_records
        FROM   bronze.erp_px_cat_g1v2;
    END TRY
    BEGIN CATCH
        PRINT ('Error Occured while loading data into Bronze Layer');
        PRINT (ERROR_MESSAGE());
    END CATCH
END