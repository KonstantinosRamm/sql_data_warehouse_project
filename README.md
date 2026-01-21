
# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project**! 🚀 
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project in order to practice PostgreSQL

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into PostgreSQL.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.


---
## 📊 Data Flow & Diagrams
* The purpose of this section is to provide a visual overview of the data processes, from ingestion to analytics, helping to understand how data moves and transforms across the system.
1. [Architecture Design](docs/diagrams/Architecture_design.png)
2. [Layers Design](docs/diagrams/design_layers.png)
3. [Data Flow](docs/diagrams/data_flow.png)
4. [Integration_model](docs/diagrams/Integration_model.png)
5. [Star Schema](docs/diagrams/Data_Warehouse_star.png)
---
## Data Dictionary 📖
* This section documents all tables in the Gold layer, as they represent the business-ready data.For further details check this : [Data Dictionary](docs/dictionary.md)

## 🛠️ Important Links & Tools:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[PostgreSQL](https://www.postgresql.org/):** powerful, open source object-relational database system 
- **[psql](https://www.postgresql.org/docs/current/app-psql.html):** the command-line interface (CLI) for PostgreSQL
- **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion](https://www.notion.com/):** All-in-one tool for project management and organization.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making. 




## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## Setup Instructions ⚙️
1. [PostgreSQL Installation and setup](docs/postgreSQL.md)




