# Global Tech Layoffs Trend Analysis
## SQL Data Cleaning + Exploratory Data Analysis 
## + Tableau Dashboard

---

## Project Overview
An end-to-end data analysis project examining 
global tech industry layoffs across companies, 
industries, countries and funding stages. 
Raw messy data was cleaned using SQL in 
DB Browser for SQLite, analysed through 
structured EDA queries, and visualised 
in an interactive Tableau Public dashboard.

---

## 🔗 Live Dashboard
 [View on Tableau Public]https://public.tableau.com/app/profile/ankita.s3430/viz/GlobalLayoffsTrendAnalysis/Dashboard1

---

##  Dataset
- **Source:** Kaggle — World Layoffs Dataset
- **Rows:** 2,361 records
- **File:** layoffs.csv → layoffs_cleaned.csv
- **Coverage:** Global tech layoffs 2020–2024

### Columns:
| Column | Description |
|--------|-------------|
| company | Company name |
| location | Office location |
| industry | Industry sector |
| total_laid_off | Total employees laid off |
| percentage_laid_off | % of workforce laid off |
| date | Date of layoff event |
| stage | Company funding stage |
| country | Country of layoff |
| funds_raised_millions | Total funds raised (USD M) |

---

##  Tools Used
- **DB Browser for SQLite** — Data cleaning & EDA
- **Tableau Public** — Dashboard & visualisation
- **GitHub** — Version control & documentation

---

## Data Cleaning (SQL)

### 1. NULL Value Check
```sql
SELECT
COUNT(*) - COUNT(total_laid_off) 
    as null_total_laid_off,
COUNT(*) - COUNT(percentage_laid_off) 
    as null_percentage_laid_off,
COUNT(*) - COUNT(industry) 
    as null_industry,
COUNT(*) - COUNT(funds_raised_millions) 
    as null_funds_raised,
COUNT(*) - COUNT(stage) 
    as null_stage,
COUNT(*) - COUNT(country) 
    as null_country,
COUNT(*) - COUNT(date) 
    as null_date
FROM layoffs;
```

### 2. Duplicate Detection
```sql
SELECT company, location, industry,
       total_laid_off, percentage_laid_off,
       date, stage, country, 
       funds_raised_millions,
       COUNT(*) as duplicate_count
FROM layoffs
GROUP BY company, location, industry,
         total_laid_off, percentage_laid_off,
         date, stage, country,
         funds_raised_millions
HAVING COUNT(*) > 1;
```

### 3. Removing Duplicates Using ROW_NUMBER()
```sql
CREATE TABLE layoffs_cleaned AS
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location,
               industry, total_laid_off,
               percentage_laid_off, date,
               stage, country,
               funds_raised_millions
               ORDER BY company
           ) as row_num
    FROM layoffs
)
SELECT * FROM duplicate_cte
WHERE row_num = 1;
```

### 4. Standardising Company Names
```sql
UPDATE layoffs_cleaned
SET company = TRIM(company);
```

### 5. Filling Missing Industry Values
```sql
UPDATE layoffs_cleaned t1
SET industry = (
    SELECT industry
    FROM layoffs_cleaned t2
    WHERE t1.company = t2.company
    AND t2.industry IS NOT NULL
    LIMIT 1
)
WHERE t1.industry IS NULL;
```

### 6. Standardising Industry Values
```sql
UPDATE layoffs_cleaned
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

### Cleaning Summary
| Check | Finding | Action Taken |
|-------|---------|--------------|
| Duplicates | Found across multiple columns | Removed using ROW_NUMBER() CTE |
| NULL Industries | Several records missing | Filled using same-company records |
| Company Names | Leading/trailing spaces | Trimmed using TRIM() |
| Industry Values | Crypto variations found | Standardised to single value |
| Country Names | Checked for inconsistencies | Verified and confirmed clean |

---

##  Exploratory Data Analysis (SQL)

### Maximum Layoffs in Single Event
```sql
SELECT MAX(CAST(total_laid_off AS INT)) 
    AS max_layoffs
FROM layoffs_cleaned;
```

### Top 10 Companies by Total Layoffs
```sql
SELECT company,
       SUM(CAST(total_laid_off AS INT)) 
           AS total_layoffs
FROM layoffs_cleaned
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;
```

### Industries with Highest Layoffs
```sql
SELECT industry,
       SUM(CAST(total_laid_off AS INT)) 
           AS total_layoffs
FROM layoffs_cleaned
GROUP BY industry
ORDER BY total_layoffs DESC;
```

### Countries with Highest Layoffs
```sql
SELECT country,
       SUM(CAST(total_laid_off AS INT)) 
           AS total_layoffs
FROM layoffs_cleaned
GROUP BY country
ORDER BY total_layoffs DESC;
```

### Layoffs by Year
```sql
SELECT SUBSTR(date, 1, 4) AS year,
       SUM(CAST(total_laid_off AS INT)) 
           AS total_layoffs
FROM layoffs_cleaned
GROUP BY year
ORDER BY year;
```

### Rolling Monthly Total (Window Function)
```sql
WITH monthly_layoffs AS (
    SELECT SUBSTR(date,1,7) AS month,
           SUM(CAST(total_laid_off AS INT)) 
               AS total_layoffs
    FROM layoffs_cleaned
    GROUP BY month
)
SELECT month, total_layoffs,
       SUM(total_layoffs) OVER (
           ORDER BY month
       ) AS rolling_total
FROM monthly_layoffs;
```

### Companies with Multiple Layoff Events
```sql
SELECT company,
       COUNT(*) AS layoff_events
FROM layoffs_cleaned
GROUP BY company
HAVING layoff_events > 1
ORDER BY layoff_events DESC;
```

### Layoffs by Funding Stage
```sql
SELECT stage,
       SUM(CAST(total_laid_off AS INT)) 
           AS total_layoffs
FROM layoffs_cleaned
GROUP BY stage
ORDER BY total_layoffs DESC;
```

---

## Key Business Insights

1. **US Dominates Global Layoffs** — United States 
   accounts for the largest share of total layoffs 
   globally, reflecting concentration of major 
   tech employers

2. **Consumer and Retail Industries Hit Hardest** — 
   Consumer-facing and retail tech sectors recorded 
   highest total layoffs indicating post-pandemic 
   demand correction

3. **Peak Layoff Period: 2022-2023** — Layoff 
   events surged significantly following the 
   post-pandemic tech hiring boom, with rolling 
   monthly totals accelerating sharply

4. **Large Funded Companies Not Immune** — Several 
   companies with hundreds of millions in funding 
   still conducted significant layoff rounds, 
   disproving the assumption that capital protects 
   against workforce reduction

5. **Post-IPO Stage Companies Hit Hardest** — 
   Analysis by funding stage reveals Post-IPO 
   companies recorded the highest total layoffs, 
   suggesting pressure from public market 
   performance expectations

6. **Companies with Repeated Layoff Events** — 
   Multiple companies conducted more than one 
   round of layoffs, indicating structural 
   rather than one-time workforce adjustments

7. **Crypto Industry Consolidation** — Crypto 
   sector showed significant layoffs consistent 
   with the broader 2022 crypto market collapse

---

## Recommendations

-  Companies with multiple layoff events 
  should be monitored as indicators of 
  deeper structural instability
-  Geographic diversification of tech 
  workforce reduces concentration risk
-  High funding alone is insufficient 
  predictor of workforce stability
- Seasonal and macroeconomic triggers 
  should inform hiring cycle planning

---

##  Dashboard Preview
![Dashboard]<img width="1098" height="527" alt="Dashboard_main" src="https://github.com/user-attachments/assets/11b5c17a-16b3-43fd-90c5-e11e6d57259b" />


---

##  Project Structure
global-layoffs-trend-analysis/
│
├── data/
│   ├── layoffs.csv (raw)
│   └── layoffs_cleaned.csv
├── sql/
│   ├── data_cleaning.sql
│   └── eda_queries.sql
├── dashboard/
│   └── GlobalLayoffsTrendAnalysis.twbx
├── screenshots/
│   └── dashboard.png
└── README.md
