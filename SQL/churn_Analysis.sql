---To get total table...
select * from churn_modelling;

---Query to find the total churn percentage...
select (select count(*) from churn_modelling 
where exited = 1)* 100 / (select count(*) from churn_modelling) as churn_percentage;

---Query to find country wise churn rate which is having high churn percentage...
SELECT Geography, ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct
FROM (
  SELECT * FROM Churn_Modelling
) AS t
WHERE Geography IN ('France','Spain','Germany')
GROUP BY Geography
ORDER BY churn_rate_pct DESC;

---Query to check whether churn rate is higher among older customers compared to younger customers
SELECT age_group, ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct, COUNT(*) as customers
FROM (
  SELECT *,
    CASE
      WHEN Age BETWEEN 18 AND 30 THEN '18-30'
      WHEN Age BETWEEN 31 AND 40 THEN '31-40'
      WHEN Age BETWEEN 41 AND 50 THEN '41-50'
      WHEN Age BETWEEN 51 AND 60 THEN '51-60'
      ELSE '60+' END AS age_group
  FROM Churn_Modelling
) AS t
GROUP BY age_group
ORDER BY age_group ;

---Query to find is churn higher among new customers (0–2 years) or long-term customers...
SELECT tenure_group, ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct, COUNT(*) AS customers
FROM (
  SELECT *,
    CASE
      WHEN Tenure BETWEEN 0 AND 2 THEN '0-2'
      WHEN Tenure BETWEEN 3 AND 5 THEN '3-5'
      WHEN Tenure BETWEEN 6 AND 9 THEN '6-9'
      ELSE '10+' END AS tenure_group
  FROM Churn_Modelling
) AS t
GROUP BY tenure_group
ORDER BY FIELD(tenure_group, '0-2','3-5','6-9','10+');

---Query to find Do customers with high account balances churn more or less...
SELECT balance_bucket, ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct, COUNT(*) AS customers
FROM (
  SELECT *,
    CASE
      WHEN Balance = 0 THEN '0'
      WHEN Balance BETWEEN 1 AND 50000 THEN '1-50k'
      WHEN Balance BETWEEN 50001 AND 100000 THEN '50k-100k'
      ELSE '100k+' END AS balance_bucket
  FROM Churn_Modelling
) AS t
GROUP BY balance_bucket
ORDER BY FIELD(balance_bucket, '0','1-50k','50k-100k','100k+');

---Query to find Is low credit score linked to high churn...
SELECT credit_bucket, ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct, COUNT(*) AS customers
FROM (
  SELECT *,
    CASE
      WHEN CreditScore < 550 THEN 'Low (<550)'
      WHEN CreditScore BETWEEN 550 AND 699 THEN 'Medium (550-699)'
      ELSE 'High (700+)' END AS credit_bucket
  FROM Churn_Modelling
) AS t
GROUP BY credit_bucket
ORDER BY FIELD(credit_bucket, 'Low (<550)','Medium (550-699)','High (700+)');

---Query to find Are inactive customers more likely to leave...
SELECT IsActiveMember,
       ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct,
       COUNT(*) AS customers
FROM (
  SELECT * FROM Churn_Modelling
) AS t
GROUP BY IsActiveMember
ORDER BY IsActiveMember DESC;

---Query to find Does number of products influence churn...
SELECT NumOfProducts, ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct, COUNT(*) AS customers
FROM (
  SELECT * FROM Churn_Modelling
) AS t
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

---Query to find Among customers with balance > 100,000, what is the churn rate... 
SELECT
  COUNT(*) AS customers,
  SUM(Exited) AS churned,
  ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct
FROM (
  SELECT * FROM Churn_Modelling
) AS t
WHERE Balance > 100000;

---Query to find Do male or female customers churn more... 
SELECT Gender, ROUND(100 * SUM(Exited)/COUNT(*), 2) AS churn_rate_pct, COUNT(*) AS customers
FROM (
  SELECT * FROM Churn_Modelling
) AS t
GROUP BY Gender
ORDER BY churn_rate_pct DESC;
















