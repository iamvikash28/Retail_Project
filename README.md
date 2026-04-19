# 🛍️ Retail Store Data Analysis

> **End-to-end retail analytics pipeline** — from raw data generation to an interactive Power BI dashboard.  
> 5,000 orders · 2023–2024 · 7 categories · 5 regions · 3 customer segments

---

## 📸 Preview

<img width="1521" height="883" alt="Screenshot (24)" src="https://github.com/user-attachments/assets/81ec4717-4b5e-4001-a259-431a45ac633c" />

---

## 📌 Project Description

The **Retail Store Data Analysis** project is a complete, end-to-end business intelligence pipeline built on a synthetic retail dataset of **5,000 transactions** spanning two fiscal years (2023–2024). It demonstrates how raw transactional data is transformed into actionable insights using a modern analytics stack.

The dataset covers **7 product categories**, **5 geographic regions** across India, **3 customer segments**, and includes detailed revenue, cost, profit, discount, and margin fields — providing a rich foundation for multi-dimensional analysis.

> **What this project solves:** Retail businesses generate vast amounts of transaction data but often lack the tools to extract meaningful patterns. This project demonstrates how to systematically analyse top products, regional performance, customer behaviour, and the financial impact of discounting — all connected through a single live Power BI dashboard.

---

## 🔍 Key Analysis Areas

### 🏆 Top Performing Products
- Identify top 10 products by revenue and profitability
- Category-level performance comparison across all 7 verticals
- Spot high-discount, low-margin problem SKUs that erode profit
- Dynamic `TOP N` filtering using Power BI slicers and DAX `TOPN()`

### 🗺️ Regional Sales Comparison
- Revenue and profit breakdown across North, South, East, West, Central
- Year-over-year growth with directional indicators per region
- Top 10 states ranked by total revenue contribution
- Regional category mix — which product types dominate each zone

### 💰 Profit vs Revenue Analysis
- Full P&L summary: total revenue, cost, profit, and blended margin
- Monthly revenue vs profit trend across 24 months
- Discount band impact on margin (No discount → 21%+ tiers)
- High-revenue, low-margin order identification for pricing review

### 👥 Customer Segment Analysis
- Three segments: Consumer (50%), Corporate (35%), Home Office (15%)
- Segment × Category revenue cross-matrix
- Quarterly revenue trend per segment for seasonality detection
- Average order value, discount behaviour, and margin by segment

---

## 🛠️ Technology Stack

| Tool | Version | Purpose | Output |
|------|---------|---------|--------|
| **Python 3** | 3.8+ | Dataset generation & Excel creation | `retail_sales.csv`, `.xlsx` |
| **Pandas / NumPy** | Latest | Data manipulation, seeded generation | Structured 5,000-row dataset |
| **OpenPyXL** | Latest | Multi-sheet Excel workbook with charts | `Retail_Store_Analysis.xlsx` |
| **SQLite** | 3.x | Relational query engine | `retail.db` database |
| **DB Browser for SQLite** | Latest | GUI for running SQL queries visually | Interactive SQL results |
| **Power BI Desktop** | Latest | Interactive dashboard with DAX | `Retail_Project.pbix` |
| **Power BI Service** | Cloud | Web publishing & sharing | Shareable dashboard URL |

---

## 📁 Repository Structure

```
retail-store-analysis/
├── data/
│   └── retail_sales.csv          # 5,000-row generated dataset
├── sql/
│   └── retail_analysis.sql            # 30+ SQL queries across 6 sections
├── excel/
│   └── Retail_Store_Analysis.xlsx     # 6-sheet Excel workbook with charts
├── powerbi/
│   └── Retail_Project.pbix          # Power BI report (open in Desktop)
├── scripts/
│   ├── generate_data.py               # Reproducible dataset generator (seed=42)
│   └── build_excel.py                 # Excel workbook builder
├── docs/
│   └── README.md                      # This file
└── requirements.txt                   # Python dependencies
```

---

## 📊 Dataset Schema

The generated dataset (`retail_sales.csv`) contains **5,000 rows** and **18 columns**. All data is synthetically generated using a fixed random seed (`42`) for full reproducibility.

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `Order_ID` | Text | Unique order identifier | `ORD-00001` |
| `Order_Date` | Date | Transaction date (2023–2024) | `2024-03-15` |
| `Year` | Integer | Calendar year | `2024` |
| `Month` | Integer | Calendar month (1–12) | `3` |
| `Quarter` | Text | Fiscal quarter | `Q1` |
| `Region` | Text | Geographic region (5 values) | `North` |
| `State` | Text | Indian state name | `Delhi` |
| `Customer_Segment` | Text | Business segment (3 values) | `Consumer` |
| `Category` | Text | Product category (7 values) | `Electronics` |
| `Product_Name` | Text | Product name (35 unique) | `Laptop Pro 15"` |
| `Quantity` | Integer | Units ordered (1–10) | `3` |
| `Unit_Price` | Decimal | Price after discount applied | `1020.00` |
| `Unit_Cost` | Decimal | Cost of goods per unit | `800.00` |
| `Discount` | Decimal | Discount rate (0 to 0.30) | `0.15` |
| `Sales` | Decimal | Total revenue: Unit_Price × Quantity | `3060.00` |
| `Cost` | Decimal | Total cost: Unit_Cost × Quantity | `2400.00` |
| `Profit` | Decimal | Sales minus Cost | `660.00` |
| `Profit_Margin` | Decimal | Profit ÷ Sales × 100 (%) | `21.57` |

---

## 🗄️ SQL Analysis Reference

The file `retail_analysis.sql` contains **30+ queries** organised into 6 logical sections. All queries are compatible with **SQLite**, **PostgreSQL**, and **MySQL**.

| Section | Queries | Key Insights |
|---------|---------|--------------|
| 1 — Database Setup | 2 | `CREATE TABLE`, import CSV |
| 2 — Top Products | 4 | Top 10 by revenue, top 10 by profit, category summary, problem SKUs |
| 3 — Regional Analysis | 5 | Region overview, YoY growth, top states, category mix, quarterly trend |
| 4 — Profit vs Revenue | 5 | P&L summary, monthly trend, discount impact, category margins |
| 5 — Customer Segments | 5 | Segment overview, segment×category matrix, discount behaviour |
| 6 — Executive KPI View | 1 | `CREATE VIEW` for year-level KPI summary |

---

## 📗 Excel Workbook

| Sheet | Contents | Key Visual |
|-------|----------|------------|
| 📊 Dashboard | KPI cards + monthly trend | Line chart: Revenue vs Profit (24 months) |
| 🏆 Top Products | Top 10 products + category summary | Bar chart: Category revenue & profit |
| 🗺️ Regional Analysis | Region overview + YoY + top states | Bar chart: Regional revenue comparison |
| 💰 Profit vs Revenue | P&L + discount analysis + margins | Pie chart: Profit share by category |
| 👥 Customer Segments | Segment overview + cross-analysis | Clustered bar: Quarterly by segment |
| 📋 Raw Data | All 5,000 transaction rows | Filterable full dataset table |

---

## 📊 Power BI Dashboard

### DAX Measures

```dax
-- Core KPIs
Total Revenue   = SUM(retail_sales[Sales])
Total Profit    = SUM(retail_sales[Profit])
Total Orders    = COUNTROWS(retail_sales)
Avg Order Value = DIVIDE([Total Revenue], [Total Orders], 0)
Profit Margin % = DIVIDE(SUM(retail_sales[Profit]), SUM(retail_sales[Sales]), 0) * 100

-- Dynamic text KPIs
Top Category by Revenue =
VAR T = SUMMARIZE(retail_sales, retail_sales[Category], "R", [Total Revenue])
VAR M = MAXX(T, [R])
RETURN MAXX(FILTER(T, [R] = M), retail_sales[Category])

Top Region by Revenue =
VAR T = SUMMARIZE(retail_sales, retail_sales[Region], "R", [Total Revenue])
VAR M = MAXX(T, [R])
RETURN MAXX(FILTER(T, [R] = M), retail_sales[Region])

-- Time intelligence
YoY Growth % =
DIVIDE(
    [Total Revenue] - CALCULATE([Total Revenue], DATEADD(Date_Table[Date], -1, YEAR)),
    CALCULATE([Total Revenue], DATEADD(Date_Table[Date], -1, YEAR)),
    0
) * 100
```
---

## 🚀 Quick Setup

### 1. Clone the repository
```bash
git clone https://github.com/iamvikash28/Retail_Project.git
cd Retail_Project
```

### 2. Install Python dependencies
```bash
pip install pandas numpy openpyxl
```

### 3. Generate the dataset
```bash
python scripts/generate_data.py
# Output: data/retail_sales.csv  (5,000 rows, seed=42)
```

### 4. Run SQL analysis (DB Browser for SQLite)
1. Open DB Browser → **New Database** → save as `retail.db`
2. **File → Import → Table from CSV** → select `retail_sales.csv`
3. **Execute SQL** tab → paste queries from `retail_analysis.sql` → press **F5**

### 5. Open the Excel workbook
```
Double-click Retail_Store_Analysis.xlsx
→ All 6 sheets open with charts pre-populated
```

### 6. Open the Power BI dashboard
```
Open Retail_Project.pbix in Power BI Desktop
→ If prompted to refresh data, point source to retail_sales.csv
→ Use slicers (Year / Region / Category / Segment / Quarter) to explore
```

---

## 📈 Project Highlights

| Metric | Value |
|--------|-------|
| Total dataset rows | 5,000 orders |
| Date range | Jan 2023 – Dec 2024 (24 months) |
| Product categories | 7 |
| Unique products | 35 |
| Geographic regions | 5 (North / South / East / West / Central) |
| Indian states covered | 21 |
| Customer segments | 3 (Consumer / Corporate / Home Office) |
| SQL queries | 30+ across 6 analytical sections |
| Excel sheets | 6 |
| Power BI visuals | 11 (5 KPI cards + 6 charts) |
| DAX measures | 7 |
| Dashboard slicers | 5 (Year, Region, Category, Segment, Quarter) |

---

## 📋 Requirements

| Tool | Minimum Version |
|------|----------------|---------|
| Python | 3.8+ |
| DB Browser for SQLite | Any | 
| Microsoft Excel | 2016+ |
| Power BI Desktop | March 2024+ |

> ⚠️ **Power BI Desktop is Windows only.** Mac users: use [Power BI Service](https://app.powerbi.com) (browser-based, free account) or run via Parallels / Boot Camp.

---

## 👤 Author

**Vikash Verma**
Aspiring Data Analyst | Excel · SQL · Power BI · Python | E-mail- vikashverma566@gmail.com

---
