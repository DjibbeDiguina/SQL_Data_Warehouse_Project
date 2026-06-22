# 🏢 Data Warehouse: Gold Layer Data Catalog

## Overview

The **Gold Layer** represents the **business-ready layer** of the data warehouse.  
It is designed to support **analytics, reporting, and decision-making** through a clean **star schema model**.

This layer contains:
- **Dimension tables** (descriptive business entities)
- **Fact table** (transactional and measurable data)

---

## Data Model Architecture

The Gold Layer follows a **Star Schema Design**:

-  Dimensions:
  - `gold.dim_customer`
  - `gold.dim_product`

-  Fact:
  - `gold.fact_sales`

This structure enables fast querying, simplified joins, and scalable analytics.

---

#  Dimension Table: `gold.dim_customer`

##  Description

Stores enriched customer attributes used for segmentation, profiling, and reporting.

##  Schema

| Column Name     | Data Type     | Description |
|----------------|--------------|-------------|
| customer_key   | INT           | Surrogate primary key (warehouse-generated). |
| customer_id    | INT           | Source system customer identifier. |
| customer_number | VARCHAR       | Business-defined customer reference number. |
| first_name     | VARCHAR       | Customer first name. |
| last_name      | VARCHAR       | Customer last name. |
| country        | VARCHAR       | Country of residence. |
| marital_status | VARCHAR       | Marital status of the customer. |
| gender         | VARCHAR       | Gender of the customer. |
| birth_date     | DATE          | Date of birth. |
| create_date    | DATE          | Record creation date in source system. |

##  Primary Key
`customer_key`

---

#  Dimension Table: `gold.dim_product`

##  Description

Contains product attributes used for product performance analysis and categorization.

## 📋 Schema

| Column Name     | Data Type      | Description |
|----------------|---------------|-------------|
| product_key    | INT            | Surrogate primary key (warehouse-generated). |
| product_id     | INT            | Source system product identifier. |
| category_id    | INT            | Product category identifier. |
| product_number | VARCHAR        | Business product reference number. |
| product_name   | VARCHAR        | Product name. |
| categories     | VARCHAR        | Product category. |
| sub_categories | VARCHAR        | Product sub-category. |
| product_cost   | DECIMAL(18,2)  | Cost of the product. |
| product_line   | VARCHAR        | Product line or brand classification. |
| maintenance    | VARCHAR        | Maintenance classification. |
| start_date     | DATE           | Product availability start date. |

##  Primary Key
`product_key`

---

#  Fact Table: `gold.fact_sales`

##  Description

Captures all sales transactions and measurable business events.

##  Schema

| Column Name   | Data Type      | Description |
|--------------|---------------|-------------|
| order_number | VARCHAR        | Unique sales order identifier. |
| product_key  | INT            | FK → `gold.dim_product`. |
| customer_key | INT            | FK → `gold.dim_customer`. |
| order_date   | DATE           | Date the order was placed. |
| shipping_date| DATE           | Date the order was shipped. |
| due_date     | DATE           | Expected delivery date. |
| sales_amount | DECIMAL(18,2)  | Total revenue generated. |
| quantity     | INT            | Number of units sold. |
| price        | DECIMAL(18,2)  | Unit selling price. |

---

##  Data Relationships

| Source Table    | Column        | Target Table      | Column        | Relationship |
|----------------|--------------|------------------|--------------|-------------|
| fact_sales     | customer_key | dim_customer     | customer_key | Many-to-One |
| fact_sales     | product_key  | dim_product      | product_key  | Many-to-One |

---

##  Business Metrics Layer

These metrics power dashboards, KPIs, and executive reporting.

| Metric Name            | Business Logic |
|------------------------|----------------|
| Total Sales            | SUM(sales_amount) |
| Total Quantity Sold    | SUM(quantity) |
| Average Selling Price  | AVG(price) |
| Customer Count         | COUNT(DISTINCT customer_key) |
| Product Count          | COUNT(DISTINCT product_key) |
| Sales per Customer     | Total Sales / Distinct Customers |
| Sales per Product      | Total Sales / Distinct Products |

---

##  Design Principles

- ✔ Star schema optimized for analytics workloads  
- ✔ Surrogate keys for consistency and performance  
- ✔ Clean separation of dimensions and facts  
- ✔ BI-ready structure for dashboards and reporting tools  
- ✔ Scalable for future data expansion  

---

##  Use Cases

This Gold Layer supports:

- 📊 Business Intelligence dashboards (Power BI, Tableau)
- 📈 Sales performance tracking
- 👥 Customer segmentation & analytics
- 🛍 Product performance analysis
- 📉 Executive reporting & KPIs

---

## 🏁 Summary

The Gold Layer is the **final analytical layer** of the warehouse, designed to provide **fast, clean, and reliable business insights** through a well-structured dimensional model.

---
