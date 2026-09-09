# NCHS Leading Causes of Death Analysis

## Overview

This project analyzes trends in the leading causes of death in the United States using data from the National Center for Health Statistics (NCHS).

The goal is to explore how mortality rates and rankings have changed over time and identify notable patterns that could be relevant to public-health decision making.

The project intentionally uses two analytical tools — **SQL and Python/Pandas** — to strengthen my ability to approach the same analytical questions in different environments.

**Research Questions → Data Validation → SQL Analysis → Python/Pandas EDA → Visualization → Findings**

---

## Research Questions

This analysis focuses on:

1. **How have age-adjusted mortality rates changed over time for the leading causes of death?**

2. **Which causes of death experienced the largest increases or decreases in mortality rates?**

3. **How has the ranking of leading causes changed over time?**

4. **Which causes show the most notable long-term trends or changes?**

5. **[Optional question added after initial exploration]**

These questions were selected to provide a focused analysis rather than attempting to investigate every available variable.

---

# Dataset

**Source:** National Center for Health Statistics (NCHS)

**Dataset:** Leading Causes of Death: United States

**Time period:** [1999–XXXX]

**Records:** [Number]

### About the Data

The dataset contains information on mortality rates for leading causes of death in the United States.

The primary measure used in this analysis is:

**Age-adjusted death rate per 100,000 population**

Age-adjusted rates allow mortality trends to be compared across years while accounting for differences in population age structure.

**Source:** [Official NCHS/CDC dataset link]

---

# Data Preparation

## Initial Data Inspection

Before analyzing the data, I examined:

* Number of records
* Number of columns
* Data types
* Missing values
* Duplicate records
* Unique causes of death
* Year range
* Unexpected values

### Data Quality Findings

[Document what you actually discover.]

---

## Data Cleaning

[Describe the cleaning performed in SQL.]

Examples:

* Standardized column names
* Converted data types
* Handled missing values
* Removed/flagged duplicate records
* Created analytical fields
* [Other]

All cleaning decisions are documented in the SQL files.

---

# SQL Analysis

SQL was used to perform the initial data validation, cleaning, aggregation, and analysis.

### SQL Skills Demonstrated

* Filtering
* Aggregation
* GROUP BY
* CASE statements
* CTEs
* Window functions
* Ranking
* Date/year analysis
* [Other]

### Example Analysis

[Briefly describe one or two important SQL analyses.]

---

# Python / Pandas Analysis

The cleaned/raw dataset was also analyzed using Python and Pandas.

The purpose was not simply to repeat the SQL analysis, but to learn how analytical concepts translate between SQL and Python while using Python's additional exploratory capabilities.

### Python Skills Demonstrated

* Loading CSV data with Pandas
* Data inspection
* Data cleaning
* Boolean filtering
* Grouping and aggregation
* Sorting/ranking
* Creating calculated fields
* Working with dates
* Exploratory data analysis
* Data visualization
* [Other]

---

# SQL vs. Pandas

One goal of this project was to compare how similar analytical tasks can be performed in SQL and Pandas.

| Analytical Task | SQL              | Pandas              |
| --------------- | ---------------- | ------------------- |
| Filter records  | `WHERE`          | Boolean filtering   |
| Group data      | `GROUP BY`       | `.groupby()`        |
| Aggregate       | `SUM()`, `AVG()` | `.sum()`, `.mean()` |
| Sort            | `ORDER BY`       | `.sort_values()`    |
| Join            | `JOIN`           | `.merge()`          |
| Ranking         | Window functions | `.rank()`           |
| [Other]         | [SQL]            | [Pandas]            |

This comparison helped reinforce analytical concepts rather than focusing solely on memorizing syntax.

---

# Exploratory Data Analysis

## Mortality Trends

[Describe the trends you discover.]

### Visualization

[Insert chart or image.]

---

## Changes in Ranking

[Describe changes in the ranking of causes over time.]

### Visualization

[Insert chart.]

---

## Largest Increases / Decreases

[Describe findings.]

### Visualization

[Insert chart.]

---

# Key Findings

### 1. [Finding]

[Evidence and explanation.]

### 2. [Finding]

[Evidence and explanation.]

### 3. [Finding]

[Evidence and explanation.]

---

# Important Considerations

This analysis describes patterns in mortality data but does not establish causal relationships.

[Document additional limitations or considerations discovered during the project.]

Examples:

* The dataset represents reported mortality statistics.
* Changes in mortality rates do not necessarily indicate a single underlying cause.
* Some causes may be affected by changes in classification or reporting.
* [Other limitation]

---

# Conclusion

[Summarize the most important trends discovered and what they demonstrate.]

---

# What I Learned

This project helped me develop:

* SQL EDA skills
* Python/Pandas fundamentals
* Data-cleaning skills
* Data visualization
* Longitudinal analysis
* Ability to translate analytical logic between SQL and Python
* Ability to distinguish between descriptive findings and causal conclusions

---

# Tools

* SQL
* Python
* Pandas
* Matplotlib / [other visualization library]
* Jupyter Notebook
* GitHub

---

# Project Structure

```text
nchs-leading-causes-analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_data_cleaning.sql
│   └── 03_analysis.sql
│
├── notebooks/
│   └── 01_eda.ipynb
│
├── outputs/
│   └── charts/
│
├── README.md
└── .gitignore
```

---
