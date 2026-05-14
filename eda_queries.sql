-- =========================================
-- WORLD LAYOFFS EXPLORATORY DATA ANALYSIS
-- =========================================
-- =========================================
-- Maximum Layoffs
-- =========================================

SELECT MAX(CAST(total_laid_off AS INT)) AS max_layoffs
FROM layoffs_cleaned;
-- =========================================
-- Maximum Layoffs by a Company
-- =========================================

SELECT MAX(CAST(total_laid_off AS INT)) AS max_layoffs
FROM layoffs_cleaned;

-- =========================================
-- Maximum Percentage of Layoffs
-- =========================================

SELECT MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_cleaned;

-- =========================================
-- Top 10 Companies by Total Layoffs
-- =========================================

SELECT company,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;
-- =========================================
-- Industries with Highest Total Layoffs
-- =========================================

SELECT industry,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY industry
ORDER BY total_layoffs DESC;

-- =========================================
-- Countries with Highest Total Layoffs
-- =========================================

SELECT country,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY country
ORDER BY total_layoffs DESC;

-- =========================================
-- Layoffs by Year
-- =========================================

SELECT SUBSTR(date, 1, 4) AS year,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY year
ORDER BY year;

-- =========================================
-- Layoffs by Month
-- =========================================

SELECT SUBSTR(date, 1, 7) AS month,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY month
ORDER BY month;

-- =========================================
-- Total Layoffs by Stage
-- =========================================

SELECT stage,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY stage
ORDER BY total_layoffs DESC;

-- =========================================
-- Average Layoffs by Industry
-- =========================================

SELECT industry,
       ROUND(AVG(CAST(total_laid_off AS INT)),2) AS avg_layoffs
FROM layoffs_cleaned
GROUP BY industry
ORDER BY avg_layoffs DESC;

-- =========================================
-- Average Layoff Percentage by Industry
-- =========================================

SELECT industry,
       ROUND(AVG(percentage_laid_off),2) AS avg_percentage_laid_off
FROM layoffs_cleaned
GROUP BY industry
ORDER BY avg_percentage_laid_off DESC;
-- =========================================
-- Companies with Most Funds Raised
-- =========================================

SELECT company,
       MAX(CAST(funds_raised_millions AS INT)) AS funds_raised
FROM layoffs_cleaned
GROUP BY company
ORDER BY funds_raised DESC
LIMIT 10;

SELECT company,
       ROUND(AVG(CAST(total_laid_off AS INT)),2) AS avg_layoffs
FROM layoffs_cleaned
GROUP BY company
ORDER BY avg_layoffs DESC
LIMIT 10;
-- =========================================
-- Rolling Total Layoffs by Month
-- =========================================

WITH monthly_layoffs AS
(
    SELECT SUBSTR(date,1,7) AS month,
           SUM(CAST(total_laid_off AS INT)) AS total_layoffs
    FROM layoffs_cleaned
    GROUP BY month
)

SELECT month,
       total_layoffs,
       SUM(total_layoffs) OVER
       (
           ORDER BY month
       ) AS rolling_total
FROM monthly_layoffs;

-- =========================================
-- Total Layoffs by Location
-- =========================================

SELECT location,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 15;



-- =========================================
-- Companies with Multiple Layoff Events
-- =========================================

SELECT company,
       COUNT(*) AS layoff_events
FROM layoffs_cleaned
GROUP BY company
HAVING layoff_events > 1
ORDER BY layoff_events DESC;



-- =========================================
-- Yearly Layoffs by Country
-- =========================================

SELECT country,
       SUBSTR(date,1,4) AS year,
       SUM(CAST(total_laid_off AS INT)) AS total_layoffs
FROM layoffs_cleaned
GROUP BY country, year
ORDER BY year, total_layoffs DESC;

-- =========================================
-- Top Companies by Average Layoffs
-- =========================================

SELECT company,
       ROUND(AVG(CAST(total_laid_off AS INT)),2) AS avg_layoffs
FROM layoffs_cleaned
GROUP BY company
ORDER BY avg_layoffs DESC
LIMIT 10;

