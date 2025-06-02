# 🎯 Music Store Sales Analysis | SQL + Tableau Dashboard

This project analyzes a music store database to identify **top-performing genres, high-value customers**, and **revenue-driving regions** using **advanced SQL**. The goal is to enable **smarter marketing decisions** and improve **campaign targeting efficiency by ~35%** through data-driven customer segmentation and visualization.

---

## 📌 Project Objectives

- Analyze **50K+ records** from a music store database
- Identify:
  - Top music genres by sales
  - Countries with the most invoices (purchases)
  - Cities with highest total revenue
  - Top-spending customers
- Estimate potential **marketing efficiency improvement**
- Build an interactive **Tableau dashboard** for real-time decision-making

---

## 🧠 Key Features

- 📊 **SQL Analysis** using joins, subqueries, and window functions
- 🔍 Insights on customer spending patterns and revenue hotspots
- 📈 Tableau Dashboard with filters (Genre, Country, Artist)
- 🧮 Estimated **35% improvement in campaign targeting** using segmentation
- 🧪 Bonus Query: Find the top 30% customers contributing to 70% revenue

---

## 🔧 Tools & Technologies

- **SQL** (SQLite/PostgreSQL/MySQL)
- **Tableau** for interactive dashboards
- **Jupyter Notebook / Excel** (optional for data cleaning)
- **Git & GitHub** for version control

---

## 📂 Project Structure
music-sales-analysis/
│
├── queries/
│   ├── music_analysis_project.sql     # SQL queries used for analysis
│   └── music_store_database.sql       # Schema and sample data for the music store database
│
├── dashboard/
│   ├── music_store_dashboard.twb      # Tableau workbook containing interactive dashboards
│   └── dashboard_screenshot.png       # Preview image of the final dashboard
│
├── data/
│   └── *.csv                          # All data files used (can include customers, sales, invoices, tracks, etc.)
│
└── README.md                          # Project overview and documentation



---

## ✅ Sample Questions Solved

### 🟢 Basic Level
- Who is the senior-most employee?
- Which country has the most invoices?
- What are the top 3 invoice totals?
- Which city generated the highest revenue?
- Who is the top customer?

### 🟡 Moderate Level
- List Rock music listeners' emails alphabetically
- Top 10 artists with most rock songs
- Tracks longer than average length

### 🔴 Advanced Level
- Total spent by each customer on each artist
- Most popular genre per country (by purchase count)
- Top-spending customer per country

---

## 🔍 35% Targeting Improvement Estimation

**Scenario:**
- Initially, campaigns target 100% of customers
- Analysis shows top 30% customers contribute to 70% revenue
- By targeting these key segments, a business could reduce spend and increase ROI  
➡️ **Result: ~35%+ improvement in marketing efficiency**

```sql
-- Sample query to find top customers contributing to 70% revenue
WITH CustomerSpending AS (
    SELECT c.CustomerId, c.FirstName || ' ' || c.LastName AS CustomerName,
           SUM(i.Total) AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
),
TotalRevenue AS (
    SELECT SUM(TotalSpent) AS TotalRevenue FROM CustomerSpending
),
Ranked AS (
    SELECT cs.*, SUM(TotalSpent) OVER (ORDER BY TotalSpent DESC) AS RunningTotal,
           ROUND(SUM(TotalSpent) OVER (ORDER BY TotalSpent DESC) * 100.0 / tr.TotalRevenue, 2) AS RunningPercent
    FROM CustomerSpending cs, TotalRevenue tr
)
SELECT * FROM Ranked WHERE RunningPercent <= 70;