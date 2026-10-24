/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

use master
Go

If exists (select 1 from sys.databases where name = 'DataWarehouse1')
Begin
	Alter DATABASE DataWarehouse1 Set SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE DataWarehouse1
END
GO

CREATE DATABASE DataWarehouse1
GO

use DataWarehouse1
GO
--we are using "go" since they can't be run together hek
Create SCHEMA bronze
go
Create SCHEMA silver
go
Create SCHEMA gold
go
