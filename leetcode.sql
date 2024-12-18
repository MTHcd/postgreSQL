-- Managers with at least 5 direct reports
SELECT managerId, COUNT(*) AS directReports
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) >= 5;

-- Confirmation Rate

SELECT
    s.user_id,
    ROUND(
        SUM(IF(c.action = 'confirmed', 1, 0)) / COUNT(1), 
        2
    ) AS confirmation_rate  
FROM
    signups s 
LEFT JOIN
    confirmations c ON s.user_id = c.user_id
GROUP BY
    s.user_id;

-- Students and Examinations

SELECT s.student_id, s.student_name, sub.subject_name, COUNT(e.subject_name) AS attended_exams
FROM Students as s CROSS JOIN Subjects as sub LEFT JOIN Examinations as e
ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

-- Employee Bonus

SELECT E.name, B.bonus
FROM Employee E LEFT JOIN Bonus B ON E.empId = B.empId
WHERE B.Bonus < 1000 OR B.bonus IS NULL;

-- Average Time of Process per Machine

select a1.machine_id,round( avg(a1.timestamp - a2.timestamp),3 ) as processing_time from Activity a1
join activity a2 on  a1.process_id = a2.process_id and a1.machine_id = a2.machine_id
where a1.activity_type='end' and a2.activity_type='start'
group by a1.machine_id;

-- Rising Temperature

SELECT w1.id 
FROM Weather as w1, Weather as w2
WHERE DATEDIFF(w1.recordDate, w2.recordDate) = 1 AND w1.temperature > w2.temperature;

-- Customer Who Visited but Did Not Make Any Transactions

select customer_id , count(visit_id) as count_no_trans from Visits
where 
visit_id not in (select  visit_id from Transactions)
group by customer_id;

-- Product Sales Analysis I

SELECT Product.product_name, Sales.year, Sales.price
FROM Sales
LEFT JOIN Product
ON Sales.product_id = Product.product_id;

-- Replace Employee ID with the unique identifier

SELECT t2.unique_id, t1.name
FROM Employees as t1
LEFT JOIN EmployeeUNI as t2
ON t1.id = t2.id;

-- Invalid Tweets

SELECT tweet_id FROM Tweets WHERE LENGTH(content) > 15; 

-- Article Views I

SELECT DISTINCT author_id id FROM Views
WHERE author_id = viewer_id
ORDER BY author_id ASC;

-- Big Countries

SELECT name, population, area FROM World
WHERE area >= 3000000
   OR population >= 25000000;

-- Find Customer Referee

SELECT name
FROM Customer c1
WHERE NOT EXISTS (
    SELECT 1
    FROM Customer c2
    WHERE c2.id = 2
    AND c1.referee_id = c2.id
);

-- Recyclable and Low Fat Products

SELECT product_id FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

-- Count Salary Categories

SELECT 
    'Low Salary' AS category,
    COUNT(*) AS accounts_count
FROM 
    Accounts
WHERE 
    income < 20000

UNION ALL

SELECT 
    'Average Salary' AS category,
    COUNT(*) AS accounts_count
FROM 
    Accounts
WHERE 
    income BETWEEN 20000 AND 50000

UNION ALL

SELECT 
    'High Salary' AS category,
    COUNT(*) AS accounts_count
FROM 
    Accounts
WHERE 
    income > 50000;

-- Consecutive Numbers

SELECT DISTINCT num as ConsecutiveNums
FROM (
    SELECT 
        num,
        LAG(num, 1) OVER (ORDER BY id) AS prev_num,
        LAG(num, 2) OVER (ORDER BY id) AS prev_prev_num,
        LEAD(num, 1) OVER (ORDER BY id) AS next_num,
        LEAD(num, 2) OVER (ORDER BY id) AS next_next_num
    FROM 
        Logs
) AS subquery
WHERE 
    (num = prev_num AND num = prev_prev_num) OR
    (num = next_num AND num = next_next_num);

-- Primary Department for Each Employee

SELECT employee_id, department_id 
FROM Employee
WHERE primary_flag = 
    CASE 
        WHEN (SELECT COUNT(*) FROM Employee AS e WHERE e.employee_id = Employee.employee_id) > 1 THEN 'Y'
        ELSE 'N'
    END;

-- The Number of Employees Which Report to Each Employee

SELECT e1.employee_id,e1.name,COUNT(e2.reports_to) AS reports_count,ROUND(AVG(e2.age),0) AS average_age
FROM employees e1 INNER JOIN employees e2 ON e2.reports_to=e1.employee_id # one to many logic with many employees for one manager
GROUP BY e1.employee_id,e1.name
ORDER BY e1.employee_id

-- Triangle Judgment
  
SELECT
    x,
    y, 
    z, 
    CASE
        WHEN (x + y > z) AND (x + z > y) AND (y + z > x) THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle;

-- Find Users With Valid E-Mails

SELECT 
    user_id, 
    name, 
    mail 
FROM Users
WHERE 
    mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode\\.com$';

-- List the Products Ordered in a Period

SELECT 
    distinct(product_name) as product_name, 
    SUM(unit) as unit
FROM 
    Products 
    INNER JOIN 
    Orders 
    ON Products.product_id = Orders.product_id
WHERE
    LEFT(Orders.order_date, 7) = '2020-02'
GROUP BY
    Products.product_name
HAVING
    SUM(unit) >= 100;

-- Group Sold Products By the Date

SELECT 
    DISTINCT sell_date,
    COUNT(DISTINCT product) as num_sold,
    GROUP_CONCAT(DISTINCT product SEPARATOR ',') as products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date ASC;

-- Second Highest Salary

SELECT 
    (SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary;

-- Patients with a Condition

SELECT *
FROM Patients
WHERE 
    conditions LIKE '% DIAB1%'
    OR
    conditions LIKE 'DIAB1%';

-- Fix Names in a Table

SELECT 
    user_id, 
    CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name,2))) AS name
FROM Users
ORDER BY user_id;

-- Employees Whose Manager Left the Company

SELECT employee_id FROM Employees
WHERE manager_id NOT IN (SELECT employee_id FROM Employees) AND salary < 30000
ORDER BY employee_id;

-- Customers WHo Bought All Products

SELECT customer_id FROM Customer GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(DISTINCT(product_key)) FROM Product);

-- Find Followers Count

SELECT user_id, COUNT(follower_id) AS followers_count FROM Followers
GROUP BY user_id
ORDER BY user_id ASC;

-- Biggest Single Number

select max(num) as num from (
select num from MyNumbers
    group by num
    having count(1) = 1
    order by num desc
    limit 1) as c;

-- Classes More than 5 students

SELECT class FROM (SELECT class, COUNT(*) AS count
FROM Courses
GROUP BY class) AS T WHERE count >= 5;

-- User Activity for the Past 30 Days I

SELECT activity_date AS day,count(DISTINCT user_id) AS active_users
FROM Activity
GROUP BY day
HAVING day BETWEEN '2019-06-28' AND '2019-07-27';

-- Number of Unique Subjects Taught by Each Teacher

SELECT teacher_id, COUNT(DISTINCT(subject_id)) AS cnt
FROM Teacher
GROUP BY teacher_id;

-- Immediate Food Delivery II

SELECT round(avg(order_date = customer_pref_delivery_date)*100, 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
  SELECT customer_id, min(order_date) 
  FROM Delivery
  GROUP BY customer_id
);

-- Queries Quality and Percentage

SELECT query_name,
       ROUND(AVG(rating / position), 2) AS quality,
       ROUND(AVG(IF(rating < 3, 1, 0)) * 100, 2) AS poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY query_name;

-- Percentage of Users Attended a Contest

select contest_id, 
round(count(user_id) * 100.0 / (select count(user_id) from Users), 2) as percentage
from Register
group by contest_id
order by percentage desc, contest_id;

-- Project Employees I

SELECT p.project_id, ROUND(AVG(e.experience_years),2) AS average_years
FROM Project p LEFT JOIN Employee e ON p.employee_id = e.employee_id
GROUP BY p.project_id;

-- Average Selling Price

SELECT Prices.product_id,
IFNULL(ROUND(SUM(Prices.price*UnitsSold.units)/SUM(UnitsSold.units),2),0) AS average_price
FROM Prices LEFT JOIN UnitsSold
ON Prices.product_id = UnitsSold.product_id 
AND purchase_date BETWEEN start_date AND end_date
GROUP BY product_id;

-- Not Boring Movies

SELECT * FROM Cinema WHERE (id % 2) <> 0 AND description <> "boring"
ORDER BY rating DESC;

