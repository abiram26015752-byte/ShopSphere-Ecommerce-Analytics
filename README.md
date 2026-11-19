# ShopSphere – E-commerce Orders and Customer Analytics

**Course:** DBMS for Analytics (25MSDA1S04)  
**Project:** Problem 03 – ShopSphere  
**Domain:** Retail  
**Technologies:** MySQL, Python, pandas, matplotlib, MongoDB

## 1. Project overview
ShopSphere is a sample retail analytics project. It combines a normalized MySQL database for customers, orders, payments and returns; Python analysis and visualizations; and a MongoDB product catalogue for category-specific product attributes.

The project uses **synthetic data** generated locally with Faker. It does not contain real customer information.

## 2. Project objectives
- Design an eight-table relational schema normalized to 3NF.
- Use primary keys, foreign keys, UNIQUE, NOT NULL and CHECK constraints.
- Demonstrate DDL and DML operations.
- Use a trigger to reduce stock when an order item is inserted.
- Create a view for monthly revenue.
- Answer retail business questions with analytical SQL.
- Connect Python to MySQL using DB-API, load data, analyse results and create charts.
- Demonstrate MongoDB CRUD, indexes and aggregation pipelines.
- Compare relational and document database use cases.

## 3. Repository structure
```text
database/       MySQL schema, seed data, views, triggers and queries
python/         Synthetic data generation, loading and analysis scripts
data/           Generated CSV files (created when generate_data.py runs)
notebooks/      Jupyter notebook
mongodb/        Product catalogue, CRUD, indexes and aggregations
docs/           Project documentation
results/        Generated tables and charts
presentation/   Project presentation
```

## 4. Requirements
- Python 3.10+
- MySQL 8.0+
- MongoDB 6.0+ (or MongoDB Atlas)
- Jupyter Notebook

Install Python packages:
```bash
pip install -r requirements.txt
```

## 5. Setup and run

### Step 1 – Configure MySQL
Create a database:
```sql
CREATE DATABASE shopsphere;
```
Run the scripts in this order in MySQL Workbench:
1. `database/schema.sql`
2. `database/triggers.sql`
3. `database/views.sql`

### Step 2 – Configure environment variables
Copy `.env.example` to `.env` and enter your local database credentials. Never commit `.env`.

### Step 3 – Generate synthetic data
From the repository root:
```bash
python python/generate_data.py
```
This creates eight CSV files in `data/` and a reproducible `database/data.sql` insert script. The generator uses a fixed random seed and creates more than 500 total rows.

### Step 4 – Load data
```bash
python python/load_data.py
```
The loader inserts generated CSV data in foreign-key order. The stock trigger is temporarily dropped during initial loading so that the initial product stock is not reduced a second time by historical order lines. Re-run `database/triggers.sql` after loading.

### Step 5 – Run analytical SQL
Run `database/queries.sql` in MySQL Workbench, or run:
```bash
python python/analysis.py
```

### Step 6 – Create charts
```bash
python python/visualizations.py
```
Charts are saved in `results/charts/`.

### Step 7 – MongoDB
Select your database in `mongosh`, then run:
```javascript
load("mongodb/crud_operations.js")
load("mongodb/indexes.js")
load("mongodb/aggregation.js")
```
The scripts use the `shopsphere` database and `products` collection.

### Step 8 – Notebook
Start Jupyter:
```bash
jupyter notebook
```
Open `notebooks/ShopSphere_Analytics.ipynb`. Set the same environment variables before running its cells.

## 6. Data source and row counts
The data is **synthetic**, generated using Python Faker with a fixed seed. It is not scraped or obtained from a public retailer. After generation, check the printed row counts. The total across all eight tables must be at least 500.

## 7. Business questions
1. Monthly revenue trend.
2. Top 10 products by sales value.
3. Top 10 customers by lifetime value.
4. Repeat purchase rate.
5. Return rate by product category.

## 8. MongoDB document model
A product document can contain flexible nested attributes:
```json
{
  "_id": "P1042",
  "name": "Noise-cancelling headphones",
  "category": "Electronics",
  "price": 4999,
  "attributes": {"battery_hours": 30, "color": "black"},
  "tags": ["audio", "wireless"]
}
```

## 9. Important notes
- The sample dataset is synthetic and results will vary if you change the seed or record counts.
- The revenue view calculates gross order-item sales. Refunds are analysed separately; they are not silently deducted from the view.
- The stock trigger is an educational example. For production use, stock validation and deduction should be handled transactionally to prevent overselling.
- Replace any presentation placeholders with actual results from your run.
- Do not upload passwords, `.env`, database dumps containing private data, or API keys.

## 10. Author
**Name:** Abiram P  
**USN:** 26MSDSR003  
**Programme:** M.Sc. Data Science
