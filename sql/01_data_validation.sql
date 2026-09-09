-- ============================================================
-- NCHS Leading Causes of Death Analysis
-- Data Validation
-- ============================================================

-- Validate the structure and quality of the imported NCHS dataset
-- before beginning analysis.

-- Dataset:
-- 10,868 records
-- Years: 1999–2017
-- Causes: 11
-- Geography: 50 states + District of Columbia + United States


-- ============================================================
-- 1. TOTAL RECORD COUNT
-- ============================================================

SELECT COUNT(*) AS total_records
FROM nchs_deaths;

-- RESULT:
-- 10,868


-- ============================================================
-- 2. YEAR RANGE
-- ============================================================

SELECT
    MIN(Year) AS earliest_year,
    MAX(Year) AS latest_year
FROM nchs_deaths;

-- RESULT:
-- 1999–2017


-- ============================================================
-- 3. UNIQUE CAUSES
-- ============================================================

SELECT DISTINCT "Cause Name"
FROM nchs_deaths
ORDER BY "Cause Name";

-- RESULT:
-- 11 causes:
--      All causes
--      Alzheimer's disease
--      CLRD
--      Cancer
--      Diabetes
--      Heart disease
--      Influenza and pneumonia
--      Kidney disease
--      Stroke
--      Suicide
--      Unintentional injuries


-- ============================================================
-- 4. UNIQUE GEOGRAPHIES
-- ============================================================

SELECT DISTINCT State
FROM nchs_deaths
ORDER BY State;

-- RESULT:
-- 50 states + District of Columbia + United States


-- ============================================================
-- 5. DUPLICATE CHECK
-- ============================================================

SELECT
    Year,
    "Cause Name",
    State,
    COUNT(*) AS record_count
FROM nchs_deaths
GROUP BY
    Year,
    "Cause Name",
    State
HAVING COUNT(*) > 1;

-- RESULT:
-- No duplicate Year + Cause + State combinations found.


-- ============================================================
-- 6. MISSING VALUE CHECK
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Year IS NULL THEN 1 ELSE 0 END) AS missing_year,
    SUM(CASE WHEN "Cause Name" IS NULL THEN 1 ELSE 0 END) AS missing_cause,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS missing_state,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS missing_deaths,
    SUM(CASE WHEN "Age-adjusted Death Rate" IS NULL THEN 1 ELSE 0 END) AS missing_rate
FROM nchs_deaths;

-- RESULT:
-- No missing values found in the analyzed fields.


-- ============================================================
-- 7. SAMPLE RECORDS
-- ============================================================

SELECT
    Year,
    "Cause Name",
    State,
    Deaths,
    "Age-adjusted Death Rate"
FROM nchs_deaths
LIMIT 10;

-- Deaths contains numeric-looking values despite being imported
-- as NVARCHAR. This will be investigated before calculations
-- requiring numeric operations.


-- ============================================================
-- 8. NATIONAL-LEVEL RECORDS
-- ============================================================

SELECT
    Year,
    "Cause Name",
    Deaths,
    "Age-adjusted Death Rate"
FROM nchs_deaths
WHERE State = 'United States'
ORDER BY Year, "Cause Name";

-- OBSERVATION:
-- The dataset includes national-level records where State = 'United States'.
-- These records provide the national death count and age-adjusted death rate
-- for each cause and year.
--
-- For national-level analysis, these records will be used directly rather
-- than aggregating the individual state records.


-- ============================================================
-- 9. Deaths Column Format Check
-- ============================================================

SELECT
    MIN(Deaths) AS minimum_deaths,
    MAX(Deaths) AS maximum_deaths
FROM nchs_deaths
WHERE State = 'United States'
  AND "Cause Name" != 'All causes';

-- RESULT: 
-- minimum_deaths: 101,537
-- maximum_deaths:  97,900
-- The column was imported as NARVAR because the source
-- data contains comma-formatted numbers. SQL is comparing the entries
-- as strings. 


SELECT
    MIN(CAST(REPLACE(Deaths, ',', '') AS INTEGER)) AS minimum_deaths,
    MAX(CAST(REPLACE(Deaths, ',', '') AS INTEGER)) AS maximum_deaths
FROM nchs_deaths
WHERE State = 'United States'
  AND "Cause Name" != 'All causes';


-- Removed commas and casting column entries as an integer 
-- minimum_deaths: 29,199
-- maximum_deaths:  725,192
-- A clearer output. 