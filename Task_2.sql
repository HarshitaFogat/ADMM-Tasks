
-- Task
-- 1. Create a database named "FoodDelivery".
-- 2. Create tables customers, restaurants, orders, and order_items with appropriate columns and constraints.
-- 3. Insert sample data into each table.
-- 4. Write Aggregation queries
-- 5. Write join queries
-- 6: Write subqueries
-- 7: Union and Union All
-- 8: DateTime Functions

-- -----------------------------------------------------------------

-- Task 1: Create Database FoodDelivery
CREATE DATABASE FoodDelivery;
USE FoodDelivery;

-- Task 2: Create Tables

-- Customers Table Schema

-- | Column      | Type         | Constraints               |
-- | ----------- | ------------ | ------------------------- |
-- | customer_id | INT          | PRIMARY KEY               |
-- | name        | VARCHAR(100) | NOT NULL                  |
-- | email       | VARCHAR(100) | UNIQUE NOT NULL           |
-- | phone       | VARCHAR(15)  | UNIQUE                    |
-- | city        | VARCHAR(50)  | NOT NULL                  |
-- | signup_date | DATETIME     | DEFAULT CURRENT_TIMESTAMP |

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(50) NOT NULL,
    signup_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Restaurants Table Schema

-- | Column          | Type         | Constraints                    |
-- | --------------- | ------------ | ------------------------------ |
-- | restaurant_id   | INT          | PRIMARY KEY                    |
-- | restaurant_name | VARCHAR(100) | NOT NULL                       |
-- | city            | VARCHAR(50)  | NOT NULL                       |
-- | rating          | DECIMAL(2,1) | CHECK (rating BETWEEN 0 AND 5) |

CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5)
);


-- Menu table Schema

-- | Column        | Type         | Constraints       |
-- | ------------- | ------------ | ----------------- |
-- | item_id       | INT          | PRIMARY KEY       |
-- | restaurant_id | INT          | FOREIGN KEY       |
-- | item_name     | VARCHAR(100) | NOT NULL          |
-- | price         | DECIMAL(8,2) | CHECK (price > 0) |
-- | is_available  | BOOLEAN      | DEFAULT TRUE      |

CREATE TABLE Menu (
    item_id INT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) CHECK (price > 0),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- Orders Table Schema

-- | Column        | Type          | Constraints                                           |
-- | ------------- | ------------- | ----------------------------------------------------- |
-- | order_id      | INT           | PRIMARY KEY                                           |
-- | customer_id   | INT           | FOREIGN KEY                                           |
-- | restaurant_id | INT           | FOREIGN KEY                                           |
-- | order_date    | DATETIME      | NOT NULL                                              |
-- | total_amount  | DECIMAL(10,2) | CHECK (total_amount >= 0)                             |
-- | status        | VARCHAR(20)   | CHECK (status IN ('Pending','Delivered','Cancelled')) |

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0),
    status VARCHAR(20) CHECK (status IN ('Pending','Delivered','Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- Order_Items Table Schema

-- | Column        | Type | Constraints          |
-- | ------------- | ---- | -------------------- |
-- | order_item_id | INT  | PRIMARY KEY          |
-- | order_id      | INT  | FOREIGN KEY          |
-- | item_id       | INT  | FOREIGN KEY          |
-- | quantity      | INT  | CHECK (quantity > 0) |

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Menu(item_id)
);

-- -------------------------------------------------------------------

-- Task 3: Insert Sample Data

INSERT INTO Customers VALUES
(1, 'Aarav Sharma', 'aarav@gmail.com', '9876543210', 'Mumbai', '2025-01-05 10:15:00'),
(2, 'Priya Mehta', 'priya@gmail.com', '9876543211', 'Delhi', '2025-01-10 12:30:00'),
(3, 'Rohan Verma', 'rohan@gmail.com', '9876543212', 'Bangalore', '2025-02-01 09:20:00'),
(4, 'Sneha Iyer', 'sneha@gmail.com', '9876543213', 'Chennai', '2025-02-15 14:45:00'),
(5, 'Kabir Khan', 'kabir@gmail.com', '9876543214', 'Mumbai', '2025-03-01 16:10:00'),
(6, 'Ananya Patel', 'ananya@gmail.com', '9876543215', 'Pune', '2025-03-10 11:25:00');

INSERT INTO Restaurants VALUES
(1, 'Spice Hub', 'Mumbai', 4.3),
(2, 'Pizza Palace', 'Delhi', 4.5),
(3, 'Burger Town', 'Bangalore', 4.1),
(4, 'Healthy Bites', 'Pune', 4.7);

INSERT INTO Menu VALUES
(1, 1, 'Paneer Butter Masala', 250.00, TRUE),
(2, 1, 'Chicken Biryani', 300.00, TRUE),
(3, 1, 'Butter Naan', 40.00, TRUE),
(4, 2, 'Margherita Pizza', 350.00, TRUE),
(5, 2, 'Farmhouse Pizza', 450.00, TRUE),
(6, 2, 'Garlic Bread', 150.00, TRUE),
(7, 3, 'Veg Burger', 120.00, TRUE),
(8, 3, 'Chicken Burger', 180.00, TRUE),
(9, 3, 'French Fries', 90.00, TRUE),
(10, 4, 'Quinoa Salad', 220.00, TRUE),
(11, 4, 'Grilled Chicken', 320.00, TRUE),
(12, 4, 'Smoothie Bowl', 180.00, TRUE);

INSERT INTO Orders VALUES
(1, 1, 1, '2025-03-15 13:10:00', 340.00, 'Delivered'),
(2, 2, 2, '2025-03-16 18:20:00', 500.00, 'Delivered'),
(3, 1, 3, '2025-03-18 20:00:00', 210.00, 'Delivered'),
(4, 3, 1, '2025-03-20 14:30:00', 300.00, 'Pending'),
(5, 4, 2, '2025-03-22 19:45:00', 450.00, 'Delivered'),
(6, 2, 3, '2025-03-25 21:15:00', 180.00, 'Cancelled'),
(7, 5, 1, '2025-04-01 12:00:00', 290.00, 'Delivered'),
(8, 1, 2, '2025-04-03 17:40:00', 350.00, 'Pending');

INSERT INTO Order_Items VALUES
(1, 1, 1, 1),
(2, 1, 3, 2),
(3, 2, 4, 1),
(4, 2, 6, 1),
(5, 3, 7, 1),
(6, 3, 9, 1),
(7, 4, 2, 1),
(8, 5, 5, 1),
(9, 6, 8, 1),
(10, 7, 1, 1),
(11, 7, 3, 1),
(12, 8, 4, 1),
(13, 8, 6, 1),
(14, 8, 6, 1),
(15, 8, 5, 1);

-- 4. Write Aggregation queries
-- Find total revenue generated.
SELECT SUM(total_amount) AS total_revenue
FROM Orders
WHERE status = 'Delivered';

-- Find average order value.
SELECT AVG(total_amount) AS avg_order_value
FROM Orders
WHERE status = 'Delivered';

-- Find highest and lowest priced menu item.
SELECT MAX(price) AS highest_price, MIN(price) AS lowest_price
FROM Menu;

-- Find number of orders grouped by status.
SELECT status, COUNT(*) AS total_orders
FROM Orders
GROUP BY status;


-- -------------------------------------------------------------------


-- 5. Write join queries

-- INNER JOIN
-- Display: Customer Name, Restaurant Name, Order Date, Total Amount.
SELECT c.name, r.restaurant_name, o.order_date, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id;

-- LEFT JOIN
-- Display all restaurants and their orders (include restaurants with no orders).
SELECT r.restaurant_name, o.order_id
FROM Restaurants r
LEFT JOIN Orders o ON r.restaurant_id = o.restaurant_id;

-- RIGHT JOIN
-- Display all customers and their orders.
SELECT c.name AS customer_name, o.order_id, o.order_date, o.total_amount, o.status
FROM Orders o
RIGHT JOIN Customers c
ON o.customer_id = c.customer_id;

-- Count number of orders per restaurant.
SELECT r.restaurant_name, COUNT(o.order_id) AS order_count
FROM Restaurants r
LEFT JOIN Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;

-- Find total sales per restaurant.
SELECT r.restaurant_name, SUM(o.total_amount) AS total_sales
FROM Restaurants r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.restaurant_name;
-- --------------------------------------------------------------------

-- Task 6: Write subqueries
-- Find customers who have ordered from 'Spice Hub'.
SELECT name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE restaurant_id = (
        SELECT restaurant_id
        FROM Restaurants
        WHERE restaurant_name = 'Spice Hub'
    )
);

-- Find restaurants that have never received an order.
SELECT restaurant_name
FROM Restaurants
WHERE restaurant_id NOT IN (
    SELECT DISTINCT restaurant_id FROM Orders
);

-- Find customers whose total spending is above average.
SELECT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_amount) > (
    SELECT AVG(total_amount) FROM Orders
);

-- --------------------------------------------------------------------


-- Task 7: Union and Union All
-- Find all unique cities where customers or restaurants are located (use UNION).
SELECT city FROM Customers
UNION
SELECT city FROM Restaurants;
-- Find all cities where customers or restaurants are located, including duplicates (use UNION ALL).
SELECT city FROM Customers
UNION ALL
SELECT city FROM Restaurants;

-- Create a table: Archived_Customers (Same structure as Customers), insert 2 records
CREATE TABLE Archived_Customers LIKE Customers;
INSERT INTO Archived_Customers 
(customer_id, name, email, phone, city, signup_date)
VALUES
(101, 'Ravi Kumar', 'ravi_old@gmail.com', '9991112221', 'Jaipur', '2024-01-10 09:00:00'),
(102, 'Neha Singh', 'neha_old@gmail.com', '9991112222', 'Bhopal', '2024-02-15 11:30:00');

-- Display all active and archived customers using UNION.
SELECT customer_id, name, email, phone, city, signup_date
FROM Customers
UNION
SELECT customer_id, name, email, phone, city, signup_date
FROM Archived_Customers;

-- Repeat using UNION ALL.
SELECT customer_id, name, email, phone, city, signup_date
FROM Customers
UNION ALL
SELECT customer_id, name, email, phone, city, signup_date
FROM Archived_Customers;

-- --------------------------------------------------------------------

-- Task 8: DateTime Functions

-- Write queries to:

-- Show orders placed in the last 7 days.
SELECT * FROM Orders
WHERE order_date >= NOW() - INTERVAL 7 DAY;

-- Show total revenue for the March 2025.
SELECT SUM(total_amount)
FROM Orders
WHERE MONTH(order_date) = 3 AND YEAR(order_date) = 2025;

-- Extract year and month from order_date.
SELECT order_id, YEAR(order_date), MONTH(order_date)
FROM Orders;

-- Calculate number of days since each customer signed up.
SELECT name, DATEDIFF(CURRENT_DATE(), signup_date) AS since_signup
FROM Customers;

-- Group orders by month and count them.
SELECT YEAR(order_date), MONTH(order_date), COUNT(*)
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date);

-- Use functions like:
-- NOW() / GETDATE()
-- DATEDIFF()
-- MONTH()
-- YEAR()
-- CURRENT_DATE()