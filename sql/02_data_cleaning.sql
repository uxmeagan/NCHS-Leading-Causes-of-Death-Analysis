-- ============================================================
-- NCHS Leading Causes of Death Analysis
-- Data Cleaning
-- ============================================================

-- PURPOSE:
-- Prepare the validated NCHS data for analysis.
--
-- Data validation found:
-- - No duplicate Year + Cause + State combinations
-- - No missing values in the primary fields
-- - No non-numeric Deaths values
-- - Deaths was imported as NVARCHAR because values contain commas
--
-- Cleaning required:
-- 1. Convert Deaths from text to INTEGER for numeric analysis.
-- 2. Create a national-level analysis table using the records
--    where State = 'United States'.
--
-- The original nchs_deaths table will not be modified so that the
-- imported source data remains preserved.


-- ============================================================
-- 1. New table + Int fix
-- ============================================================

CREATE TABLE national_deaths AS
SELECT
    Year,
    "Cause Name" AS cause_name,
    CAST(REPLACE(Deaths, ',', '') AS INTEGER) AS deaths,
    "Age-adjusted Death Rate" AS age_adjusted_death_rate
FROM nchs_deaths
WHERE State = 'United States';


-- ============================================================
-- 2. SAMPLE RECORDS
-- ============================================================

SELECT *
FROM national_deaths
LIMIT 10;


-- ============================================================
-- 3. Count Records
-- ============================================================

SELECT COUNT(*) AS total_records
FROM national_deaths;

-- RESULT: 209 Records
-- Correct because we are covering 19 years (1999-2017) and 11 causes
-- 19*11 = 209

-- ============================================================
-- 4. Check the original test (in Data Validation)
-- ============================================================
SELECT
    MIN(deaths) AS minimum_deaths,
    MAX(deaths) AS maximum_deaths
FROM national_deaths
WHERE cause_name != 'All causes';

-- RESULT: 
-- minimum: 29,199
-- maximum: 725,192



-- ============================================================
-- CLEANING VALIDATION
-- ============================================================

-- The cleaned national_deaths table contains 209 records,
-- representing 19 years (1999–2017) across 11 cause categories.
--
-- Deaths was successfully converted from text to INTEGER.
-- Minimum deaths: 29,199
-- Maximum deaths: 725,192
--
-- No additional cleaning was required based on the validation
-- checks performed.