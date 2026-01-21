# Data Dictionary 📘

### This document describes all database tables and columns for gold layer used in the current project.Its purpose is to provide a clear and consistent reference for how data is structured, named, and used across the system.

---
# Gold layer 🟡
The gold layer is the business level data representation,structured to support analytics and reporting.It consists of dimension and fact tables. 


## Table:gold.dim_customers
* Purpose:Provide details about customers encriched with demographics

| Column Name       | Data Type | Description | Example |
|-------------------|-----------|-------------|---------|
| `customer_key`    | INTEGER   | A surrogate key unique for each customer for identification on dimesion table | 1,2,1000,100523|
| `customer_id`     | INTEGER   | Unique Numerical Identifier assigned on each customer | 10001,10002,11558 |
| `customer_number` | VARCHAR(50) | Unique Alphanumerical Identifier assigned on each customer | AW00011000,AW00011410 |
| `firstname` | VARCHAR(50) | First name of  customer | John,George |
| `lastname` | VARCHAR(50) | Last name of customer | Yang,Johnson |
| `marital_status` | VARCHAR(50) | Marital Status of the customer | MARRIED,SINGLE,N\A |
| `gender` | VARCHAR(50) | The gender of the customer | MALE,FEMALE,N/A |
| `birthdate` | DATE | The date of birth of customer | 1999-05-25,1970-01-01|
| `create_date` | DATE | The date customer details created on the system | 2020-05-10,2025-10-02 |  
| `country` | VARCHAR(50) | The country  of residence of the customer | Australia,Greece |



---
## Table:gold.dim_products
* Purpose:Provide information about the products

| Column Name | Data Type | Description | Example |
| ----------- | --------- | ----------- | ------- |
| `product key` | INTEGER | A surrogate key unique for each product for identification on dimesion table | 1,2,3,1000 |
| `product_id ` | INTEGER | Unique Numerical Identifier assigned on each product |
| `category_id` | VARCHAR(50) | Unique Alphanumerical identifier for each products category | CO_RF,BI_MB |
| `product_number` | VARCHAR(50) | Alphanumerical code for categorization of each product | FR-R92B-58,BK-M82B-38 |
| `product_line` | VARCHAR(50) | The series to which the product belongs | Mountain,Road |
| `product_name` | VARCHAR(50) | Description of the product including details such as type,color | HL Road Frame - Black- 58,Mountain-100 Silver- 38 |
| `category` | VARCHAR(50) | The category of the product | Clothing,Components |
| `subcategory` | VARCHAR(50) | A more detailed classification of the product within a category | Gloves,Locks |
| `maintenance` | VARCHAR(50) | Indicates If the product requires maintenance or not | Yes,No |
| `cost` | INTEGER | The price of the product |  16,55,100 |
| `start_date` | DATE | The date the product became available for sales | 2012-07-01,2022-11-03 | 

---
## Table:gold.fact_sales
* Purpose:Provide transaction details

| Column Name | Data Type | Description | Example |
| ----------- | --------- | ----------- | ------- |
| `order_number` | VARCHAR(50) | Unique alphanumeric identifier for each order | SO43697,SO43698 |
| `product_key` | INTEGER | surrogate key used to link order with product dimension table | 9,10 |
| `customer_key` | INTEGER | surrogate key used to link order with customer dimension table | 4,3502 |
| `order_date` | DATE | The date the order took place | 2010-12-29,2010-12-30|
| `shipping_date` | DATE | The date where the order shipped to customer |  2011-01-06,2011-01-14 | 
| `due_date` | DATE | The date where the order payment is due | 2011-01-19,2011-01-27|
| `total_sales` | INTEGER | The total income from the order calculated as quantity * price | 3375,2400 |
| `quantity` | INTEGER | The quantity of the the product sold within this order | 1,20 |
| `unit_price` | INTEGER | The price for a single unit of that product | 10,500 |
 
