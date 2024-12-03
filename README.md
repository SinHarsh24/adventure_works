# Adventure Works Profit and Sales Data Warehouse

## Overview

This project involves developing a **Profit and Sales Data Warehouse** for Adventure Works, a bicycle and cycling accessory manufacturing company. The solution is designed to enhance data analysis, improve customer management, and support strategic decision-making by implementing a star or snowflake schema, ETL pipelines, analytical queries, and visualization solutions.

---

## Features

### 1. **Data Warehouse Design**
- Schema: Star/Snowflake
- Database: MySQL
- Key Tables:
  - Customer Table
  - Product Table
  - Product Category and Subcategory Tables
  - Territory Table
  - Sales Table

### 2. **ETL Automation**
- **Tableau Prep**: Used to load raw data into MySQL Workbench efficiently.
- Stored Procedures for data extraction, transformation, and loading (ETL).
- Staging and transformation for clean and reliable data.
- Audit table for logging transactions.

### 3. **Analytical Capabilities**
- Predefined analytical queries:
  - Customer demographics and sales performance.
  - Sales trends and geographical distribution.
  - Profitability insights by product and customer.
  - Ranking and aggregation using CTEs and Window Functions.

### 4. **Integration**
- Seamless integration of application data into the warehouse.
- Support for Slowly Changing Dimensions (SCD) Type 2 for customer views.

