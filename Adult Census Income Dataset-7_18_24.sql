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