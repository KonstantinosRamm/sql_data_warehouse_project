/*
===============================================================================
Create Database,schemas and tables
===============================================================================
WARNING
    Running this script will drop the entire data_warehouse database if exists already.
    All the data will be deleted.Proceed with caution and ensure you have backups before 
    running this script
*/

-- initialize database
\i scripts/init_db.sql
-- populate tables
\i scripts/load_data.sql
