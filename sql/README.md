SQL — Data Engineering Journey
This folder contains my SQL practice and project work, covering core concepts from data cleaning to advanced querying techniques. All scripts are written in MySQL.
---
📁 Files in this folder
File	Description
`data_cleaning.sql`	Full data cleaning pipeline on a real-world layoffs dataset
`eda.sql`	Exploratory Data Analysis on the cleaned layoffs dataset
`ctes.sql`	Common Table Expressions — syntax, chaining, and use cases
`case_statements.sql`	CASE logic for conditional bucketing and salary calculations
`window_functions.sql`	ROW_NUMBER, RANK, DENSE_RANK, SUM OVER, PARTITION BY
`subqueries.sql`	Correlated and non-correlated subqueries
`joins.sql`	INNER JOIN, UNION, UNION ALL with practical examples
`string_functions.sql`	LENGTH, UPPER, LOWER, REPLACE, SUBSTRING, CONCAT, LOCATE
`stored_procedures.sql`	Creating and calling stored procedures with parameters
`triggers.sql`	AFTER INSERT trigger to auto-populate a related table
`events.sql`	Scheduled SQL events (e.g. auto-deleting retired employees)
`temp_tables.sql`	Creating and querying temporary tables
`where_clauses.sql`	Filtering with WHERE, AND, OR, NOT, LIKE
`sql_tables.sql`	Database and table creation, INSERT statements, sample dataset
---
🧠 Concepts Covered
1. Data Cleaning
File: `data_cleaning.sql`  
Dataset: Tech industry layoffs (real-world dataset)
A complete data cleaning pipeline following four steps:
Remove Duplicates — using `ROW_NUMBER()` with `PARTITION BY` across all key columns to identify and delete exact duplicates
Standardize Data — `TRIM()` for whitespace, `UPDATE` to normalize inconsistent values (e.g. "Crypto%", trailing dots in country names), `STR_TO_DATE()` to convert string dates to proper `DATE` type
Handle Null / Blank Values — self-join technique to fill missing `industry` values from matching company records; deleting rows where both `total_laid_off` and `percentage_laid_off` are NULL
Remove Unnecessary Columns — dropping the helper `row_num` column after cleaning is complete
```sql
-- Example: filling missing industry values using a self-join
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
```
---
2. Exploratory Data Analysis (EDA)
File: `eda.sql`  
Dataset: `layoffs_staging2` (cleaned layoffs data)
Querying the cleaned dataset to surface insights:
Companies and industries with the highest total layoffs
Layoffs by country, year, and funding stage
Monthly layoff trends using `SUBSTRING()` on dates
Rolling total of layoffs over time using `SUM() OVER(ORDER BY month)`
```sql
-- Rolling total of layoffs by month
WITH Rolling_Total AS (
    SELECT SUBSTRING(`date`, 1, 7) `Month`, SUM(total_laid_off) total_off
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY `Month`
    ORDER BY 1 ASC
)
SELECT `Month`, total_off,
SUM(total_off) OVER(ORDER BY `Month`) rolling_total
FROM Rolling_Total;
```
---
3. Common Table Expressions (CTEs)
File: `ctes.sql`
Named temporary result sets defined with `WITH` that make complex queries more readable and reusable.
Single CTEs for aggregations (avg, max, min salary by gender)
Querying a CTE result (e.g. `AVG` of an already-aggregated column)
Multiple chained CTEs joined together
```sql
-- Chaining two CTEs and joining them
WITH cte_example AS (
    SELECT employee_id, gender, birth_date
    FROM employee_demographics
    WHERE birth_date > '1985-01-01'
),
cte_example2 AS (
    SELECT employee_id, salary
    FROM employee_salary
    WHERE salary > 50000
)
SELECT * FROM cte_example
JOIN cte_example2 ON cte_example.employee_id = cte_example2.employee_id;
```
> **Key insight:** CTEs are cleaner than nested subqueries and can reference themselves in recursive scenarios.
---
4. Window Functions
File: `window_functions.sql`
Perform calculations across related rows without collapsing results like `GROUP BY` does.
Function	What it does
`AVG() OVER(PARTITION BY)`	Average per group, kept on every row
`SUM() OVER(ORDER BY)`	Running/rolling total
`ROW_NUMBER()`	Unique sequential number per partition
`RANK()`	Rank with gaps for ties
`DENSE_RANK()`	Rank without gaps for ties
```sql
-- Comparing ROW_NUMBER, RANK, and DENSE_RANK side by side
SELECT dem.first_name, dem.last_name, gender, sal.salary,
    ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num,
    RANK()       OVER(PARTITION BY gender ORDER BY salary DESC) rank_num,
    DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id;
```
> **Key insight:** `RANK()` skips numbers after ties (1,1,3), `DENSE_RANK()` does not (1,1,2). Choose based on whether gaps matter.
---
5. CASE Statements
File: `case_statements.sql`
Conditional logic inside SQL queries — similar to `IF/ELSE` in programming.
Age brackets (Young / Old / On Death's Door)
Salary raise calculations based on current pay band
Department-specific bonus logic
```sql
-- Salary increase logic with a Finance bonus
SELECT first_name, last_name, salary,
    CASE
        WHEN salary < 50000 THEN salary + (salary * 0.05)
        WHEN salary > 50000 THEN salary + (salary * 0.07)
    END new_salary,
    CASE
        WHEN dept_id = 6 THEN salary * 0.1
    END bonus
FROM employee_salary;
```
---
6. Subqueries
File: `subqueries.sql`
Queries nested inside other queries, used as filters or computed columns.
`IN` subquery to filter by a related table's condition
Scalar subquery returning a single value (e.g. company-wide average salary)
Subquery in `FROM` clause used as an inline aggregated table
```sql
-- Filter employees using a subquery on another table
SELECT * FROM employee_demographics
WHERE employee_id IN (
    SELECT employee_id FROM employee_salary
    WHERE dept_id = 1
);
```
---
7. Joins & Unions
File: `joins.sql`
Combining data from multiple tables.
`JOIN` to link `employee_demographics` and `employee_salary` on `employee_id`
`UNION` (deduplicates) vs `UNION ALL` (keeps duplicates)
Labelled UNION sets for categorising records (e.g. "Old Man", "Old Woman", "Overpaid")
```sql
-- Labelled UNION to categorise employees
SELECT first_name, last_name, 'Old Man' Label
FROM employee_demographics WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Woman' Label
FROM employee_demographics WHERE age > 40 AND gender = 'Female'
UNION ALL
SELECT first_name, last_name, 'Overpaid' Label
FROM employee_salary WHERE salary > 70000
ORDER BY first_name, last_name;
```
---
8. String Functions
File: `string_functions.sql`
Built-in MySQL functions for manipulating text data.
Function	Purpose
`LENGTH()`	Character count of a string
`UPPER()` / `LOWER()`	Change case
`TRIM()`	Remove leading/trailing whitespace
`REPLACE()`	Swap characters within a string
`SUBSTRING()`	Extract part of a string
`LOCATE()`	Find position of a substring
`CONCAT()`	Combine strings (e.g. full name)
---
9. Stored Procedures
File: `stored_procedures.sql`
Reusable SQL blocks saved and called by name — useful for repetitive queries.
Basic procedure with no parameters
Multi-statement procedure using `BEGIN...END` and `DELIMITER`
Parameterised procedure accepting an input value
```sql
-- Parameterised stored procedure
DELIMITER $$
CREATE PROCEDURE large_salaries3(number_id INT)
BEGIN
    SELECT salary FROM employee_salary
    WHERE employee_id = number_id;
END $$
DELIMITER ;

CALL large_salaries3(2);
```
---
10. Triggers
File: `triggers.sql`
Automatic actions that fire when a specified database event occurs.
`AFTER INSERT` trigger on `employee_salary` that auto-inserts a matching record into `employee_demographics`
```sql
-- Auto-populate demographics when a new salary record is inserted
DELIMITER $$
CREATE TRIGGER employee_insert
    AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
    INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES(new.employee_id, new.first_name, new.last_name);
END $$
DELIMITER ;
```
---
11. Events
File: `events.sql`
Scheduled tasks that run automatically on a timer — MySQL's version of a cron job.
`DELETE` event that removes employees aged 60+ every 30 seconds
```sql
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    DELETE FROM employee_demographics WHERE age >= 60;
END;
```
---
12. Temporary Tables
File: `temp_tables.sql`
Tables that exist only for the duration of a session — useful for staging intermediate results.
Creating a temp table manually with defined columns
Creating a temp table directly from a `SELECT` query
```sql
-- Create a temp table from a query result
CREATE TEMPORARY TABLE salary_over_50k
SELECT * FROM employee_salary WHERE salary > 50000;
```
---
13. WHERE Clauses & Logical Operators
File: `where_clauses.sql`
Filtering rows based on conditions.
Comparison operators: `=`, `!=`, `>`, `>=`, `<`, `<=`
Logical operators: `AND`, `OR`, `NOT`
Pattern matching: `LIKE` with `%` (wildcard) and `_` (single character)
---
14. Database & Table Setup
File: `sql_tables.sql`
Creating the sample database used across all practice scripts.
`CREATE DATABASE`, `USE`, `DROP DATABASE IF EXISTS`
`CREATE TABLE` with data types, `NOT NULL`, `PRIMARY KEY`, `AUTO_INCREMENT`
`INSERT INTO` with multiple rows
Basic `SELECT` queries with arithmetic expressions (`PEMDAS` order of operations)
---
🗃️ Datasets Used
Dataset	Description
`layoffs`	Real-world tech layoffs data (2020–2023) — used for cleaning and EDA
`employee_demographics`	Sample Parks & Recreation employee data — used for practice queries
`employee_salary`	Salary and department data for the same employee set
`parks_departments`	Department lookup table
---
📌 Notes
All scripts were written and tested in MySQL Workbench
The `employee_*` tables are fictional data based on the Parks and Recreation TV show — used purely for SQL practice
The layoffs dataset is real-world data, publicly available
