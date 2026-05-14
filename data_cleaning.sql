-- =========================================
-- WORLD LAYOFFS DATA CLEANING PROJECT
-- =========================================

-- Previewing dataset

SELECT *
FROM layoffs;

-- =========================================
-- Checking NULL Values
-- =========================================

SELECT
COUNT(*) - COUNT(total_laid_off) as null_total_laid_off,
COUNT(*) - COUNT(percentage_laid_off) as null_percentage_laid_off,
COUNT(*) - COUNT(industry) as null_industry,
COUNT(*) - COUNT(funds_raised_millions) as null_funds_raised,
COUNT(*) - COUNT(stage) as null_stage,
COUNT(*) - COUNT(country) as null_country,
COUNT(*) - COUNT(date) as null_date
FROM layoffs;

-- =========================================
-- Checking Duplicate Records
-- =========================================
SELECT company,
       location,
       industry,
       total_laid_off,
       percentage_laid_off,
       date,
       stage,
       country,
       funds_raised_millions,
       COUNT(*) as duplicate_count
FROM layoffs
GROUP BY company,
         location,
         industry,
         total_laid_off,
         percentage_laid_off,
         date,
         stage,
         country,
         funds_raised_millions
HAVING COUNT(*) > 1;

-- =========================================
-- Inspecting Duplicates
-- =========================================
SELECT *
FROM layoffs
WHERE company = 'Yahoo';
-- =========================================
-- Creating Cleaned Table Without Duplicates
-- =========================================

-- Created layoffs_cleaned table using ROW_NUMBER()
-- to remove true duplicate records safely while
-- preserving the original layoffs table.


CREATE TABLE layoffs_cleaned AS
WITH duplicate_cte AS
(
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company,
                            location,
                            industry,
                            total_laid_off,
                            percentage_laid_off,
                            date,
                            stage,
                            country,
                            funds_raised_millions
               ORDER BY company
           ) as row_num
    FROM layoffs
)

SELECT *
FROM duplicate_cte
WHERE row_num = 1;
-- ========================================
-- Standardize company names
-- ========================================
UPDATE layoffs_cleaned
SET company = TRIM(company);
-- ========================================
-- Check Industry inconsistencies
-- ========================================
SELECT DISTINCT industry
FROM layoffs_cleaned
ORDER BY industry;
-- ========================================
-- Standardize Country names
-- ========================================
SELECT DISTINCT country
FROM layoffs_cleaned
ORDER BY country;
-- ========================================
-- Checking null industries
-- ========================================
SELECT *
FROM layoffs_cleaned
WHERE industry IS NULL;
-- =========================================
-- Filling Missing Industry Values
-- =========================================

UPDATE layoffs_cleaned t1
SET industry = (
    SELECT industry
    FROM layoffs_cleaned t2
    WHERE t1.company = t2.company
      AND t2.industry IS NOT NULL
    LIMIT 1
)
WHERE t1.industry IS NULL;
-- Verifying remaining NULL industries

SELECT *
FROM layoffs_cleaned
WHERE industry IS NULL;
-- =========================================
-- Verifying Missing Industries Were Filled
-- =========================================

SELECT *
FROM layoffs_cleaned
WHERE industry IS NULL;
-- =========================================
-- Checking Company Name Consistency
-- =========================================

SELECT DISTINCT company
FROM layoffs_cleaned
ORDER BY company;
-- =========================================
-- Removing Extra Spaces From Company Names
-- =========================================

UPDATE layoffs_cleaned
SET company = TRIM(company);
-- =========================================
-- Verifying Distinct Company names
-- =========================================
SELECT DISTINCT company
FROM layoffs_cleaned
ORDER BY company;
-- =========================================
-- Standardizing Industry Values
-- =========================================

SELECT DISTINCT industry
FROM layoffs_cleaned
ORDER BY industry;

UPDATE layoffs_cleaned
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Verifying standardization

SELECT DISTINCT industry
FROM layoffs_cleaned
ORDER BY industry;