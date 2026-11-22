/*
==========================================================
Author: Saurabh Singh
Created on: 2026-11-16
==========================================================
Script Purpose: Create DataWarehouse Database and Schemas
==========================================================
*/

use master;
GO
--Drop the database if it already exists
if exists (select * from sys.databases where name = 'DataWarehouse')
begin
    drop database DataWarehouse;
end
-- Create the DataWarehouse database
create database DataWarehouse;

use DataWarehouse;
-- Create Schemas for Bronze, Silver, and Gold layers
GO
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;


