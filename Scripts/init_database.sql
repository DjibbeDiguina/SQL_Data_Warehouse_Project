/*==============================================================
    WARNING / IMPORTANT NOTICE
    ------------------------------------------------------------
    This script will:

    1. Check if the database 'DataWarehouse' exists
    2. Force disconnect all active users/sessions
    3. DROP (DELETE) the existing database
    4. Create a fresh new database

    ------------------------------------------------------------
    ⚠ WARNING:
    Running this script will permanently delete ALL data,
    tables, stored procedures, views, and records inside
    the 'DataWarehouse' database.

    Make sure:
    - You have a backup if needed
    - No important work is stored inside the database
    - You really want to recreate the database from scratch

    Recommended for:
    - Learning projects
    - Development environments
    - Testing ETL/Data Warehouse pipelines

    NOT recommended for:
    - Production environments
    - Important business databases

==============================================================*/


/* Using Master location to create Database*/
Use master;

GO
/* Condition of creating new Database*/

IF EXISTS (
    SELECT 1 
    FROM sys.databases 
    WHERE name = 'DataWarehouse'
)
BEGIN
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END

/* Creating 'DataWarehouse'  Databse inside our 'master'*/
create database DataWarehouse;

GO

/* Selecting my 'DataWarehouse' Database*/
USE DataWarehouse;

GO

/*Creating my bronze SCHEMA*/
create schema bronze;

GO

/*Creating my silver SCHEMA*/
create schema silver;

Go

/*Creating my gold SCHEMA*/
create schema gold;
