CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

DECLARE @whole_start_time DATETIME;
DECLARE @whole_end_time DATETIME;
DECLARE @start_time DATETIME;
DECLARE @end_time DATETIME;

BEGIN TRY

	SET @whole_start_time = GETDATE();

	PRINT('===========================================');
	PRINT('Loading bronze layer');
	PRINT('===========================================');


	PRINT('-------------------------------------------');
	PRINT('Loading CRM Tables');
	PRINT('-------------------------------------------');

	SET @start_time = GETDATE();
	PRINT('');
	PRINT('>> Truncating Table: bronze.crm_cust_info');
	TRUNCATE TABLE bronze.crm_cust_info;
	PRINT('>> Inserting Data Into Table: bronze.crm_cust_info');
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\ArchiveCurrent\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT('>> Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms');


	SET @start_time = GETDATE();
	PRINT('');
	PRINT('>> Truncating Table: bronze.crm_prd_info');
	TRUNCATE TABLE bronze.crm_prd_info;
	PRINT('>> Inserting Data Into Table: bronze.crm_prd_info');
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\ArchiveCurrent\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT('>> Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms');


	SET @start_time = GETDATE();
	PRINT('');
	PRINT('>> Truncating Table: bronze.crm_sales_details');
	TRUNCATE TABLE bronze.crm_sales_details;
	PRINT('>> Inserting Data Into Table: bronze.crm_sales_details');
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\ArchiveCurrent\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT('>> Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms');

	PRINT('');
	PRINT('-------------------------------------------');
	PRINT('Loading ERP Tables');
	PRINT('-------------------------------------------');


	SET @start_time = GETDATE();
	PRINT('');
	PRINT('>> Truncating Table: bronze.erp_cust_az12');
	TRUNCATE TABLE bronze.erp_cust_az12;
	PRINT('>> Inserting Data Into Table: bronze.erp_cust_az12');
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\ArchiveCurrent\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT('>> Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms');


	SET @start_time = GETDATE();
	PRINT('');
	PRINT('>> Truncating Table: bronze.erp_loc_a101');
	TRUNCATE TABLE bronze.erp_loc_a101;
	PRINT('>> Inserting Data Into Table: bronze.erp_loc_a101');
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\ArchiveCurrent\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT('>> Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms');


	SET @start_time = GETDATE();
	PRINT('');
	PRINT('>> Truncating Table: bronze.erp_px_cat_g1v2');
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	PRINT('>> Inserting Data Into Table: bronze.erp_px_cat_g1v2');
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\ArchiveCurrent\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH
	(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT('>> Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms');

	PRINT('');
	PRINT('===========================================');
	PRINT('SUCCESSFULLY LOAD ALL DATA');
	PRINT('===========================================');

	SET @whole_end_time = GETDATE();
	PRINT('Data Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @whole_start_time, @whole_end_time) AS NVARCHAR) + ' ms');

END TRY
BEGIN CATCH

	PRINT('===========================================');
	PRINT('ERROR OCCURED DURING LOADING BRONZE LAYER');
	PRINT('Error message: ' + ERROR_MESSAGE());
	PRINT('Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
	PRINT('Error state: ' + CAST(ERROR_STATE() AS NVARCHAR));
	PRINT('Error line: ' + CAST(ERROR_LINE() AS NVARCHAR));
	PRINT('===========================================');

END CATCH
END;