-- Initial check of dataset 
SELECT * FROM kaggle.adult


-- Data Exploration

-- Checking data types of dataset
DESCRIBE kaggle.adult

-- Get count of records in dataset
-- Count is 10,705 
SELECT COUNT(*) FROM kaggle.adult

-- Checking statistics for age
SELECT 
	MIN(age) AS min_age,
    MAX(age) AS max_age,
    AVG(age) AS avg_age
FROM kaggle.adult;

-- Get the distribution of categorical columns
SELECT workclass, COUNT(*) FROM kaggle.adult GROUP BY workclass order by count(*) asc;
SELECT education, COUNT(*) FROM kaggle.adult GROUP BY education order by count(*) asc;
	-- Need to fix column name 
-- SELECT marital.status, COUNT(*) FROM kaggle.adult GROUP BY marital.status order by count(*) asc;
SELECT occupation, COUNT(*) FROM kaggle.adult GROUP BY occupation order by count(*) asc;
SELECT relationship, COUNT(*) FROM kaggle.adult GROUP BY relationship order by count(*) asc;
SELECT race, COUNT(*) FROM kaggle.adult GROUP BY race order by count(*) asc;
SELECT sex, COUNT(*) FROM kaggle.adult GROUP BY sex order by count(*) asc;
	-- Need to fix column name it is currently native.co
-- SELECT native_country, COUNT(*) FROM kaggle.adult GROUP BY native_country order by count(*) asc;

-- Create a backup of the original dataset
CREATE TABLE kaggle.adult_backup AS SELECT * FROM kaggle.adult;
SELECT * FROM kaggle.adult_backup;

-- Create a version of the dataset for data cleaning
CREATE TABLE kaggle.adult_cleaned AS SELECT * FROM kaggle.adult;
SELECT * FROM kaggle.adult_cleaned;
DESCRIBE kaggle.adult_cleaned;

-- Data Cleaning 
-- Fixing column names
ALTER TABLE kaggle.adult_cleaned 
CHANGE COLUMN `workclass` `work_class` TEXT,
CHANGE COLUMN `fnlwgt` `final_weight` INT,
CHANGE COLUMN `education.num` `education_number` INT,
CHANGE COLUMN `marital.status` `marital_status` TEXT,
CHANGE COLUMN `capital.gain` `capital_gain` INT,
CHANGE COLUMN `capital.loss` `capital_loss` INT,
CHANGE COLUMN `hours.per.week` `hours_per_week` INT,
CHANGE COLUMN `native.country` `native_country` TEXT;

-- Verify column name changes 
DESCRIBE kaggle.adult_cleaned;

-- Inspecting columns with '?'
SELECT work_class, COUNT(*)
FROM kaggle.adult_cleaned
GROUP BY work_class
ORDER BY COUNT(*) ASC; 

SELECT occupation, COUNT(*)
FROM kaggle.adult_cleaned
GROUP BY occupation
ORDER BY COUNT(*) ASC; 

SELECT native_country, COUNT(*)
FROM kaggle.adult_cleaned
GROUP BY native_country
ORDER BY COUNT(*) ASC; 

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;
-- Replace '?' with 'Not Available' in work_class, occupation and native_country
UPDATE kaggle.adult_cleaned
SET work_class = 'Not Available'
WHERE work_class = '?'; 

UPDATE kaggle.adult_cleaned
SET occupation = 'Not Available'
WHERE occupation = '?';

UPDATE kaggle.adult_cleaned
SET native_country = 'Not Available'
WHERE native_country = '?'; 

-- Re-inspecting columns with '?'
SELECT work_class, COUNT(*)
FROM kaggle.adult_cleaned
GROUP BY work_class
ORDER BY COUNT(*) ASC; 

SELECT occupation, COUNT(*)
FROM kaggle.adult_cleaned
GROUP BY occupation
ORDER BY COUNT(*) ASC; 

SELECT native_country, COUNT(*)
FROM kaggle.adult_cleaned
GROUP BY native_country
ORDER BY COUNT(*) ASC; 

SELECT capital_loss, COUNT(*)
FROM kaggle.adult_cleaned
GROUP BY capital_loss
ORDER BY COUNT(*) ASC; 

SELECT * FROM kaggle.adult_cleaned;

-- Checking for null values in all columns
-- No nulls found across all columns 
SELECT
	COUNT(*) AS total_rows,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN work_class IS NULL THEN 1 ELSE 0 END) AS null_work_class,
    SUM(CASE WHEN final_weight IS NULL THEN 1 ELSE 0 END) AS null_final_weight,
    SUM(CASE WHEN education IS NULL THEN 1 ELSE 0 END) AS null_education,
    SUM(CASE WHEN education_number IS NULL THEN 1 ELSE 0 END) AS null_education_number,
    SUM(CASE WHEN marital_status IS NULL THEN 1 ELSE 0 END) AS null_marital_status,
    SUM(CASE WHEN occupation IS NULL THEN 1 ELSE 0 END) AS null_marital_status,
    SUM(CASE WHEN relationship IS NULL THEN 1 ELSE 0 END) AS null_relationship,
    SUM(CASE WHEN race IS NULL THEN 1 ELSE 0 END) AS null_race,
    SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS null_sex,
    SUM(CASE WHEN capital_gain IS NULL THEN 1 ELSE 0 END) AS null_capital_gain,
    SUM(CASE WHEN capital_loss IS NULL THEN 1 ELSE 0 END) AS null_capital_loss,
    SUM(CASE WHEN hours_per_week IS NULL THEN 1 ELSE 0 END) AS null_hours_per_week,
    SUM(CASE WHEN native_country IS NULL THEN 1 ELSE 0 END) AS null_native_country,
    SUM(CASE WHEN income IS NULL THEN 1 ELSE 0 END) AS null_income
FROM kaggle.adult_cleaned;

-- Check for unexpected values in work_class
SELECT DISTINCT work_class FROM kaggle.adult_cleaned;
-- Check for unexpected values in education
SELECT DISTINCT education FROM kaggle.adult_cleaned;
-- Check for unexpected values in marital_status
SELECT DISTINCT marital_status FROM kaggle.adult_cleaned;
-- Check for unexpected values in occupation
SELECT DISTINCT occupation FROM kaggle.adult_cleaned;
-- Check for unexpected values in relationship
SELECT DISTINCT relationship FROM kaggle.adult_cleaned;
-- Check for unexpected values in race
SELECT DISTINCT race FROM kaggle.adult_cleaned;
-- Check for unexpected values in sex
SELECT DISTINCT sex FROM kaggle.adult_cleaned;
-- Check for unexpected values in native_country
SELECT DISTINCT native_country FROM kaggle.adult_cleaned;
-- Check for unexpected values in income
SELECT DISTINCT income FROM kaggle.adult_cleaned;

-- Inspecting ranges for numerical columns
-- Age Min age is 17 and Max age is 90
SELECT MIN(age) AS min_age, MAX(age) AS max_age FROM kaggle.adult_cleaned; 
-- Final Weight
SELECT MIN(final_weight) AS min_final_weight, MAX(final_weight) AS max_final_weight FROM kaggle.adult_cleaned;
-- Education Number
-- min grade is 1 and max grade is 16 
SELECT MIN(education_number) AS min_education_number, MAX(education_number) AS max_education_number FROM kaggle.adult_cleaned; 
-- Capital Gain
SELECT MIN(capital_gain) AS min_capital_gain, MAX(capital_gain) AS max_capital_gain FROM kaggle.adult_cleaned;
-- Capital Loss
SELECT MIN(capital_loss) AS min_capital_loss, MAX(capital_loss) AS max_capital_loss FROM kaggle.adult_cleaned;
-- Hours Per Week
-- min hours worked is 1 hour and max hours worked in 99 
SELECT MIN(hours_per_week) AS min_hours_per_week, MAX(hours_per_week) AS max_hours_per_week FROM kaggle.adult_cleaned;

-- Data Analysis
-- Age Analysis
SELECT age, COUNT(*) AS age_count FROM kaggle.adult_cleaned GROUP BY age ORDER BY age_count ASC;  
-- Income Distribution
-- More people are making less than or equal to $50K with a count of 7,025 while people making above $50K has a count of 3,680
SELECT income, COUNT(*) AS income_count FROM kaggle.adult_cleaned GROUP BY income ORDER BY income_count ASC; 
-- Education Analysis
-- Most people that took this survey were High School graduates with a count of 3,224 
SELECT education, COUNT(*) AS education_count FROM kaggle.adult_cleaned GROUP BY education ORDER BY education_count ASC;  
-- Occupation vs. Income
SELECT occupation, income, COUNT(*) AS count FROM kaggle.adult_cleaned GROUP BY occupation, income ORDER BY count Desc;
-- Gender based income distribution
SELECT
	sex,
    income,
    COUNT(*) as count
FROM kaggle.adult_cleaned
GROUP BY sex, income
ORDER BY count DESC;
-- Education level vs. income
SELECT
	education,
    income,
    COUNT(*) as count
FROM kaggle.adult_cleaned
GROUP BY education, income
ORDER BY count DESC;
-- Marital status vs. income
SELECT
	marital_status,
    income,
    COUNT(*) AS count
FROM kaggle.adult_cleaned
GROUP BY marital_status, income
ORDER BY count DESC;
-- Race vs. income
SELECT
	race,
    income,
    COUNT(*) AS count
FROM kaggle.adult_cleaned
GROUP BY race, income
ORDER BY count DESC;
-- Work class vs. hours per week
SELECT 
	work_class,
    AVG(hours_per_week) AS avg_hours_per_week
FROM kaggle.adult_cleaned
GROUP BY work_class
ORDER BY avg_hours_per_week DESC;
-- Capital gain/loss by income
 SELECT
	income,
    AVG(capital_gain) AS avg_capital_gain,
    AVG(capital_loss) AS avg_capital_loss
FROM kaggle.adult_cleaned
GROUP BY income;
-- Age distribution by education level
SELECT
	education,
    AVG(age) AS avg_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age
FROM kaggle.adult_cleaned
GROUP BY education
ORDER BY avg_age;
-- Income distribution by native country 
SELECT 
    native_country,
    income,
    COUNT(*) AS count
FROM kaggle.adult_cleaned
GROUP BY native_country, income
ORDER BY count DESC;
-- Average hours per week by occupation and income
SELECT 
    occupation,
    income,
    AVG(hours_per_week) AS avg_hours_per_week
FROM kaggle.adult_cleaned
GROUP BY occupation, income
ORDER BY avg_hours_per_week DESC;
-- Work class vs. education number
SELECT 
    work_class,
    AVG(education_number) AS avg_education_number
FROM kaggle.adult_cleaned
GROUP BY work_class
ORDER BY avg_education_number DESC;

 

