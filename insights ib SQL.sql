
-- ==========================================================
-- HR Attrition Project - Manager/Stakeholder Views
-- Database: HR_Attrition
-- Table: hr_attrition_cleaned
-- Author: Abhinav
-- ==========================================================

use hr_attrition;
select * FROM hr_attrition_cleaned

-- 1) Company-wide attrition snapshot
CREATE VIEW vw_attrition_overall AS
SELECT 
  COUNT(*) AS Total_Employees,
  SUM(Attrition = 'Yes') AS Employees_Left,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
  ROUND(AVG(MonthlyIncome),2) AS Avg_Salary,
  ROUND(AVG(YearsAtCompany),2) AS Avg_Tenure
FROM hr_attrition_cleaned;
select * FROM vw_attrition_overall

-- 2) Attrition by Department
CREATE VIEW vw_attrition_department AS
SELECT 
  Department,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY Department
HAVING COUNT(*) >= 10;
select * FROM vw_attrition_department

-- 3) Attrition by Job Role
CREATE VIEW vw_attrition_jobrole AS
SELECT 
  JobRole,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY JobRole
HAVING COUNT(*) >= 10;
select* FROM vw_attrition_jobrole

-- 4) Attrition by Tenure Buckets
CREATE VIEW vw_attrition_tenure AS
SELECT 
  CASE 
    WHEN YearsAtCompany < 1 THEN '0-0.9 yrs'
    WHEN YearsAtCompany BETWEEN 1 AND 2 THEN '1-2 yrs'
    WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5 yrs'
    WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 yrs'
    ELSE '10+ yrs'
  END AS Tenure_Bucket,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY Tenure_Bucket;
select* from vw_attrition_tenure

-- 5) Attrition by Overtime
CREATE VIEW vw_attrition_overtime AS
SELECT 
  OverTime,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY OverTime;
select*from vw_attrition_overtime

-- 6) Attrition by Business Travel
CREATE VIEW vw_attrition_travel AS
SELECT 
  BusinessTravel,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY BusinessTravel;
select*from vw_attrition_travel

-- 7) attrition by attrition_salaryquartile
CREATE OR REPLACE VIEW vw_attrition_salaryquartile AS
SELECT 
  CONCAT('Q', t.Salary_Quartile) AS Salary_Quartile,
  COUNT(*) AS Headcount,
  SUM(CASE WHEN t.attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Count,
  ROUND(SUM(CASE WHEN t.attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
  ROUND(AVG(t.monthlyincome),2) AS Avg_Salary
FROM (
    SELECT 
      employeenumber, monthlyincome, attrition,
      NTILE(4) OVER (ORDER BY monthlyincome) AS Salary_Quartile
    FROM HR_Attrition.hr_attrition_cleaned
) t
GROUP BY t.Salary_Quartile;
select * from vw_attrition_salaryquartile


-- 8) Attrition by Job Satisfaction
CREATE VIEW vw_attrition_satisfaction AS
SELECT 
  JobSatisfaction,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY JobSatisfaction;
select* from vw_attrition_satisfaction


-- 9a) Attrition by Work-Life Balance
CREATE VIEW vw_attrition_worklife AS
SELECT 
  WorkLifeBalance,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY WorkLifeBalance;
select* from vw_attrition_worklife

-- 9b) Attrition by Distance Buckets
CREATE VIEW vw_attrition_distance AS
SELECT 
  CASE 
    WHEN DistanceFromHome <= 5 THEN '0-5 km'
    WHEN DistanceFromHome <= 15 THEN '6-15 km'
    WHEN DistanceFromHome <= 30 THEN '16-30 km'
    ELSE '30+ km'
  END AS Distance_Bucket,
  COUNT(*) AS Headcount,
  SUM(Attrition = 'Yes') AS Left_Count,
  ROUND(SUM(Attrition = 'Yes') * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_attrition_cleaned
GROUP BY Distance_Bucket;
select*from vw_attrition_distance


