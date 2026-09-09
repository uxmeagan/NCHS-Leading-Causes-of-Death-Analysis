-- ============================================================
-- NCHS Leading Causes of Death Analysis
-- Data Analysis
-- ============================================================



-- --------------------- National Level Analysis --------------------- -- 


-- ============================================================
-- QUESTION 1:
-- How have age-adjusted death rates changed over time?
-- ============================================================

SELECT
    Year,
    cause_name,
    age_adjusted_death_rate
FROM national_deaths
WHERE cause_name != 'All causes'
ORDER BY
    cause_name,
    Year;

-- ------------------------------------------------------------
-- How much did each cause's age-adjusted death rate change
-- between 1999 and 2017?
-- ------------------------------------------------------------

SELECT 
	cause_name,
	MAX(CASE 
		WHEN year = 1999 THEN age_adjusted_death_rate
		END) AS rate_1999,
	MAX(CASE 
		WHEN year = 2017 THEN age_adjusted_death_rate
		END) AS rate_1999,
	ROUND(
        MAX(CASE WHEN Year = 2017 THEN age_adjusted_death_rate END) -
        MAX(CASE WHEN Year = 1999 THEN age_adjusted_death_rate END),
        1
    ) AS rate_change	
FROM national_deaths
WHERE cause_name != 'All causes'
GROUP BY cause_name
ORDER BY rate_change DESC;

-- RESULT:
-- Compared with 1999, three causes had higher age-adjusted
-- death rates in 2017:
--   Alzheimer's disease: +14.5
--   Unintentional injuries: +14.1
--   Suicide: +3.5
--
-- Kidney disease showed no overall change.
--
-- The largest decreases were:
--   Heart disease: -101.5
--   Cancer: -48.3
--   Stroke: -24.0
--
-- OBSERVATION:
-- The results show a broad decline in age-adjusted mortality
-- for several major causes, particularly heart disease, cancer,
-- and stroke, while Alzheimer's disease, unintentional injuries,
-- and suicide increased over the study period.

-- ------------------------------------------------------------
-- Percentage change
-- ------------------------------------------------------------

SELECT
    cause_name,
    MAX(CASE WHEN Year = 1999 THEN age_adjusted_death_rate END) AS rate_1999,  
    MAX(CASE WHEN Year = 2017 THEN age_adjusted_death_rate END) AS rate_2017,
    ROUND(
        (MAX(CASE WHEN Year = 2017 THEN age_adjusted_death_rate END)
            -
            MAX(CASE WHEN Year = 1999 THEN age_adjusted_death_rate END))
        /
        MAX(CASE WHEN Year = 1999 THEN age_adjusted_death_rate END)
        * 100,
        1
    ) AS percent_change
FROM national_deaths
WHERE cause_name != 'All causes'
GROUP BY cause_name
ORDER BY percent_change DESC;

-- RESULT:
-- The largest percentage increases were:
--   Alzheimer's disease: +87.9%
--   Unintentional injuries: +39.9%
--   Suicide: +33.3%
--
-- Kidney disease showed no overall percentage change.
--
-- The largest percentage decreases were:
--   Influenza and pneumonia: -39.1%
--   Stroke: -39.0%
--   Heart disease: -38.1%
--
-- OBSERVATION:
-- Percentage change provides additional context beyond absolute
-- change by accounting for each cause's starting rate. Alzheimer's
-- disease had the largest proportional increase, while several
-- major causes experienced declines of roughly 38–39%.
--
-- Heart disease had the largest absolute decrease, but its
-- percentage decrease was smaller because its 1999 rate was much
-- higher.



-- ============================================================
-- QUESTION 2:
-- How has the ranking of causes of death changed over time?
-- ============================================================

SELECT
    Year,
    cause_name,
    age_adjusted_death_rate,
    RANK() OVER (
        PARTITION BY Year
        ORDER BY age_adjusted_death_rate DESC
    ) AS mortality_rank
FROM national_deaths
WHERE 
	cause_name != 'All causes'
ORDER BY
    Year,
    mortality_rank;

-- Full ranking for each year + cause

-- ------------------------------------------------------------
-- Which cause had the highest age-adjusted death rate each year?
-- ------------------------------------------------------------

SELECT
    Year,
    cause_name,
    age_adjusted_death_rate
FROM (
    SELECT
        Year,
        cause_name,
        age_adjusted_death_rate,
        RANK() OVER (
            PARTITION BY Year
            ORDER BY age_adjusted_death_rate DESC
        ) AS mortality_rank
    FROM national_deaths
    WHERE cause_name != 'All causes'
)
WHERE mortality_rank = 1
ORDER BY Year;

-- RESULT:
-- Heart disease ranked #1 by age-adjusted death rate in every
-- year from 1999 through 2017.
--
-- OBSERVATION:
-- Although heart disease remained the leading cause throughout
-- the study period, its age-adjusted death rate declined from
-- 266.5 in 1999 to 165.0 in 2017, a decrease of 101.5 deaths
-- per 100,000.
--
-- This demonstrates that a cause can maintain the same ranking
-- while its underlying mortality rate changes substantially.

-- ------------------------------------------------------------
-- Which causes changed rank the most between 1999 and 2017?
-- ------------------------------------------------------------

SELECT
    cause_name,
    MAX(CASE WHEN Year = 1999 THEN mortality_rank END) AS rank_1999,
    MAX(CASE WHEN Year = 2017 THEN mortality_rank END) AS rank_2017,
    MAX(CASE WHEN Year = 2017 THEN mortality_rank END)
        - MAX(CASE WHEN Year = 1999 THEN mortality_rank END) AS rank_change
FROM (
    SELECT
        Year,
        cause_name,
        RANK() OVER (
            PARTITION BY Year
            ORDER BY age_adjusted_death_rate DESC
        ) AS mortality_rank
    FROM national_deaths
    WHERE cause_name != 'All causes'
) ranked_causes
GROUP BY cause_name
ORDER BY rank_change;

-- RESULT:
-- Between 1999 and 2017, Alzheimer's disease and unintentional
-- injuries each moved up two positions in the mortality ranking.
-- Stroke moved down two positions.
--
-- Heart disease, cancer, and CLRD remained in the same ranking
-- positions between 1999 and 2017.
--
-- OBSERVATION:
-- The ranking changes show that the relative importance of some
-- causes shifted over time. Alzheimer's disease and unintentional
-- injuries became more prominent, while stroke declined in rank.
--
-- Ranking changes should be considered alongside changes in
-- age-adjusted death rates, since ranking describes relative
-- position rather than the size of the underlying change.



-- ============================================================
-- QUESTION 3:
-- How consistent were mortality trends over time?
-- ============================================================

-- ------------------------------------------------------------
-- Highest and lowest rates
-- ------------------------------------------------------------

SELECT
    cause_name,
    MIN(age_adjusted_death_rate) AS lowest_rate,
    MAX(age_adjusted_death_rate) AS highest_rate
FROM national_deaths
WHERE cause_name != 'All causes'
GROUP BY cause_name
ORDER BY cause_name;

-- RESULT:
-- Several causes showed substantial differences between their
-- lowest and highest rates over the study period.
--
-- Heart disease, cancer, and stroke had large ranges primarily
-- associated with long-term declines.
--
-- Alzheimer's disease, suicide, and unintentional injuries
-- showed overall increases from 1999 to 2017.
--
-- Kidney disease had the same rate in 1999 and 2017 (13.0),
-- but reached a higher rate of 15.3 during the study period,
-- demonstrating that endpoint comparisons can hide changes
-- occurring between the starting and ending years.
--
-- OBSERVATION:
-- Comparing only the beginning and ending years does not always
-- capture the full pattern of change. Year-by-year analysis is
-- necessary to identify causes with fluctuations or changes
-- in direction over time.

-- ============================================================
-- QUESTION 5:
-- When did the largest year-to-year changes occur?
-- ============================================================

SELECT
    Year,
    cause_name,
    age_adjusted_death_rate,
    LAG(age_adjusted_death_rate) OVER (
        PARTITION BY cause_name
        ORDER BY Year
    ) AS previous_year_rate,
    ROUND(
        age_adjusted_death_rate -
        LAG(age_adjusted_death_rate) OVER (
            PARTITION BY cause_name
            ORDER BY Year
        ),
        1
    ) AS year_to_year_change
FROM national_deaths
WHERE cause_name != 'All causes'
ORDER BY
    cause_name,
    Year;


-- RESULT:
-- Heart disease experienced the largest single-year decline,
-- decreasing by 14.7 deaths per 100,000 from 2003 to 2004.
--
-- Unintentional injuries showed notable increases later in the
-- study period, including a 4.2 increase from 2015 to 2016.
--
-- Alzheimer's disease also had a notable 4.0 increase from
-- 2014 to 2015.
--
-- Cancer and stroke generally showed more consistent
-- year-to-year declines throughout the study period.
--
-- OBSERVATION:
-- Year-to-year analysis reveals differences in how causes
-- changed over time. Some causes followed relatively steady
-- long-term trends, while others experienced more noticeable
-- fluctuations or changes in direction.


-- --------------------- State Level Analysis --------------------- -- 

-- ============================================================
-- QUESTION 1:
--  How did heart disease mortality rates change by state
-- between 1999 and 2017?
-- ============================================================

SELECT
    State,
    MAX(CASE WHEN Year = 1999 THEN "Age-adjusted Death Rate" END) AS rate_1999,
    MAX(CASE WHEN Year = 2017 THEN "Age-adjusted Death Rate" END) AS rate_2017,
    ROUND(
        MAX(CASE WHEN Year = 2017 THEN "Age-adjusted Death Rate" END)
        - MAX(CASE WHEN Year = 1999 THEN "Age-adjusted Death Rate" END),
        1
    ) AS rate_change
FROM nchs_deaths
WHERE "Cause Name" = 'Heart disease'
  AND State != 'United States'
GROUP BY State
ORDER BY rate_change;

-- RESULT:
-- Every state and the District of Columbia experienced a decline
-- in heart disease age-adjusted mortality between 1999 and 2017.
--
-- The largest absolute decreases were:
--   New York: -134.9 deaths per 100,000
--   West Virginia: -133.5
--   Illinois: -115.8
--   Mississippi: -115.8
--   Kentucky: -115.0
--
-- Utah had the smallest absolute decrease at -39.9 deaths
-- per 100,000.
--
-- Texas experienced a decrease of -100.9 deaths per 100,000.
--
-- OBSERVATION:
-- Heart disease mortality declined across every state during
-- the study period, but the size of the decline varied
-- substantially by state.
--
-- New York had the largest absolute decrease, while Utah had
-- the smallest. This suggests that the national decline in
-- heart disease mortality was not uniform across states.


-- ============================================================
-- QUESTION 2:
-- Which states experienced the largest percentage decrease
-- in heart disease mortality from 1999 to 2017?
-- ============================================================

SELECT
    State,
    MAX(CASE WHEN Year = 1999 THEN "Age-adjusted Death Rate" END) AS rate_1999,
    MAX(CASE WHEN Year = 2017 THEN "Age-adjusted Death Rate" END) AS rate_2017,
    ROUND(
        (
            MAX(CASE WHEN Year = 2017 THEN "Age-adjusted Death Rate" END)
            -
            MAX(CASE WHEN Year = 1999 THEN "Age-adjusted Death Rate" END)
        )
        /
        MAX(CASE WHEN Year = 1999 THEN "Age-adjusted Death Rate" END)
        * 100,
        1
    ) AS percent_change
FROM nchs_deaths
WHERE "Cause Name" = 'Heart disease'
  AND State != 'United States'
GROUP BY State
ORDER BY percent_change;

-- RESULT:
-- California experienced the largest percentage decrease:
--   -44.5%
--
-- Other large percentage decreases included:
--   New York: -44.1%
--   Illinois: -41.5%
--   Delaware: -41.2%
--   North Dakota: -41.2%
--
-- Utah experienced the smallest percentage decrease at -21.0%.
--
-- Texas experienced a percentage decrease of -37.4%.
--
-- OBSERVATION:
-- Percentage change provides additional context because states
-- began the study period with different heart disease mortality
-- rates.
--
-- California had the largest proportional decline even though
-- it did not have the largest absolute decrease. New York,
-- however, ranked near the top using both measures, indicating
-- a substantial decline in both absolute and relative terms.
--
-- Comparing absolute and percentage change demonstrates why
-- both measures are useful when evaluating differences between
-- states.