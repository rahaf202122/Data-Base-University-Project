DROP DATABASE IF EXISTS MYDBproj;
CREATE DATABASE MYDBproj;
USE MYDBproj;

/* =========================================================
   Alawneh Car Trading Company - Complete Database Script
   ========================================================= */

/* ===================== TABLES ===================== */

CREATE TABLE branch (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    physical_location VARCHAR(150)
);

CREATE TABLE Brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Car_Category (
    car_cat_id INT AUTO_INCREMENT PRIMARY KEY,
    car_cat_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Part_Category (
    part_cat_id INT AUTO_INCREMENT PRIMARY KEY,
    part_cat_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE Warehouse (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    branch_id INT UNIQUE NOT NULL,

    FOREIGN KEY (branch_id)
    REFERENCES branch(branch_id)
);

CREATE TABLE Employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    job_title VARCHAR(50),

    role_id INT NOT NULL,
    user_id INT UNIQUE NOT NULL,
    branch_id INT NOT NULL,

    FOREIGN KEY (role_id)
    REFERENCES Role(role_id),

    FOREIGN KEY (user_id)
    REFERENCES Users(user_id),

    FOREIGN KEY (branch_id)
    REFERENCES branch(branch_id)
);

CREATE TABLE Employee_Phone (
    emp_id INT,
    phone VARCHAR(20),

    PRIMARY KEY (emp_id, phone),

    FOREIGN KEY (emp_id)
    REFERENCES Employee(emp_id)
    ON DELETE CASCADE
);

CREATE TABLE Customer (
    cust_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_name VARCHAR(100) NOT NULL,
    address VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Customer_Phone (
    cust_id INT,
    phone VARCHAR(20),

    PRIMARY KEY (cust_id, phone),

    FOREIGN KEY (cust_id)
    REFERENCES Customer(cust_id)
    ON DELETE CASCADE
);

CREATE TABLE Supplier (
    sup_id INT AUTO_INCREMENT PRIMARY KEY,
    sup_name VARCHAR(100) NOT NULL,
    address VARCHAR(100)
);

CREATE TABLE Supplier_Phone (
    sup_id INT,
    phone VARCHAR(20),

    PRIMARY KEY (sup_id, phone),

    FOREIGN KEY (sup_id)
    REFERENCES Supplier(sup_id)
    ON DELETE CASCADE
);

CREATE TABLE car (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    vin VARCHAR(50) UNIQUE NOT NULL,
    model VARCHAR(100) NOT NULL,
    manufacture_year INT,
    color VARCHAR(30),
    status VARCHAR(30),
    price DECIMAL(10,2),
    image_path VARCHAR(255),

    branch_id INT NOT NULL,
    brand_id INT NOT NULL,
    car_cat_id INT NOT NULL,
    added_by_emp_id INT,

    FOREIGN KEY (branch_id)
    REFERENCES branch(branch_id),

    FOREIGN KEY (brand_id)
    REFERENCES Brand(brand_id),

    FOREIGN KEY (car_cat_id)
    REFERENCES Car_Category(car_cat_id),

    FOREIGN KEY (added_by_emp_id)
    REFERENCES Employee(emp_id)
);

CREATE TABLE SparePart (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL,
    part_number VARCHAR(50) UNIQUE,
    status VARCHAR(30),
    unit_price DECIMAL(10,2),
    image_path VARCHAR(255),

    brand_id INT NOT NULL,
    part_cat_id INT NOT NULL,
    added_by_emp_id INT,

    FOREIGN KEY (brand_id)
    REFERENCES Brand(brand_id),

    FOREIGN KEY (part_cat_id)
    REFERENCES Part_Category(part_cat_id),

    FOREIGN KEY (added_by_emp_id)
    REFERENCES Employee(emp_id)
);

CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT NOT NULL,
    date_in DATE,
    date_out DATE,

    warehouse_id INT NOT NULL,
    part_id INT NOT NULL,

    UNIQUE (warehouse_id, part_id),

    FOREIGN KEY (warehouse_id)
    REFERENCES Warehouse(warehouse_id),

    FOREIGN KEY (part_id)
    REFERENCES SparePart(part_id)
);

CREATE TABLE Sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    saleDate DATE NOT NULL,
    salePrice DECIMAL(10,2) NOT NULL,

    cust_id INT NOT NULL,
    emp_id INT NOT NULL,
    branch_id INT NOT NULL,

    FOREIGN KEY (cust_id)
    REFERENCES Customer(cust_id),

    FOREIGN KEY (emp_id)
    REFERENCES Employee(emp_id),

    FOREIGN KEY (branch_id)
    REFERENCES branch(branch_id)
);

CREATE TABLE SalePayment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    paymentDate DATE,
    amount DECIMAL(10,2),
    paymentType VARCHAR(30),

    sale_id INT NOT NULL,

    FOREIGN KEY (sale_id)
    REFERENCES Sales(sale_id)
    ON DELETE CASCADE
);

CREATE TABLE Purchase (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    purchaseDate DATE,
    cost DECIMAL(10,2),

    emp_id INT NOT NULL,
    sup_id INT NOT NULL,

    FOREIGN KEY (emp_id)
    REFERENCES Employee(emp_id),

    FOREIGN KEY (sup_id)
    REFERENCES Supplier(sup_id)
);

CREATE TABLE PurchasePayment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    paymentDate DATE,
    amount DECIMAL(10,2),
    payment_type VARCHAR(30),

    purchase_id INT NOT NULL,

    FOREIGN KEY (purchase_id)
    REFERENCES Purchase(purchase_id)
    ON DELETE CASCADE
);

CREATE TABLE StockMovement (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    movement_type VARCHAR(50),
    quantity INT,
    movement_date DATE,
    notes VARCHAR(150),

    warehouse_id INT NOT NULL,
    part_id INT NOT NULL,

    FOREIGN KEY (warehouse_id)
    REFERENCES Warehouse(warehouse_id),

    FOREIGN KEY (part_id)
    REFERENCES SparePart(part_id)
);

CREATE TABLE CarTransferDetails (
    car_transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    transfer_date DATE,
    status VARCHAR(50),
    notes VARCHAR(150),

    car_id INT NOT NULL,
    from_branch_id INT NOT NULL,
    to_branch_id INT NOT NULL,
    emp_id INT NOT NULL,

    FOREIGN KEY (car_id)
    REFERENCES car(car_id),

    FOREIGN KEY (from_branch_id)
    REFERENCES branch(branch_id),

    FOREIGN KEY (to_branch_id)
    REFERENCES branch(branch_id),

    FOREIGN KEY (emp_id)
    REFERENCES Employee(emp_id)
);

CREATE TABLE SparePartTransferDetails (
    spare_transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    transfer_date DATE,
    status VARCHAR(50),
    notes VARCHAR(150),

    part_id INT NOT NULL,
    from_warehouse_id INT NOT NULL,
    to_warehouse_id INT NOT NULL,
    emp_id INT NOT NULL,

    FOREIGN KEY (part_id)
    REFERENCES SparePart(part_id),

    FOREIGN KEY (from_warehouse_id)
    REFERENCES Warehouse(warehouse_id),

    FOREIGN KEY (to_warehouse_id)
    REFERENCES Warehouse(warehouse_id),

    FOREIGN KEY (emp_id)
    REFERENCES Employee(emp_id)
);

CREATE TABLE SaleCarDetails (
    sale_car_details_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    unit_price DECIMAL(10,2),

    sale_id INT NOT NULL,
    car_id INT NOT NULL,

    FOREIGN KEY (sale_id)
    REFERENCES Sales(sale_id)
    ON DELETE CASCADE,

    FOREIGN KEY (car_id)
    REFERENCES car(car_id)
);

CREATE TABLE SalePartDetails (
    sale_part_details_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    unit_price DECIMAL(10,2),

    sale_id INT NOT NULL,
    part_id INT NOT NULL,
    warehouse_id INT NOT NULL,

    FOREIGN KEY (sale_id)
    REFERENCES Sales(sale_id)
    ON DELETE CASCADE,

    FOREIGN KEY (part_id)
    REFERENCES SparePart(part_id),

    FOREIGN KEY (warehouse_id)
    REFERENCES Warehouse(warehouse_id)
);

CREATE TABLE PurchaseCarDetails (
    purchase_car_details_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    unit_price DECIMAL(10,2),

    purchase_id INT NOT NULL,
    car_id INT NOT NULL,

    FOREIGN KEY (purchase_id)
    REFERENCES Purchase(purchase_id)
    ON DELETE CASCADE,

    FOREIGN KEY (car_id)
    REFERENCES car(car_id)
);

CREATE TABLE PurchasePartDetails (
    purchase_part_details_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    unit_price DECIMAL(10,2),

    purchase_id INT NOT NULL,
    part_id INT NOT NULL,

    FOREIGN KEY (purchase_id)
    REFERENCES Purchase(purchase_id)
    ON DELETE CASCADE,

    FOREIGN KEY (part_id)
    REFERENCES SparePart(part_id)
);

/* ===================== SAMPLE DATA ===================== */

INSERT INTO branch (branch_name, city, physical_location)
VALUES
('Ramallah Branch', 'Ramallah', 'Al-Bireh Street'),
('Jenin Branch', 'Jenin', 'Main Street');

INSERT INTO Brand (brand_name)
VALUES
('Toyota'),
('Hyundai'),
('Kia'),
('Mercedes'),
('BMW'),
('Audi'),
('Honda'),
('Nissan');

INSERT INTO Car_Category (car_cat_name)
VALUES
('Sedan'),
('SUV'),
('Luxury');

INSERT INTO Part_Category (part_cat_name)
VALUES
('Engine Parts'),
('Brake Parts'),
('Electrical Parts'),
('Body Parts');

INSERT INTO Role (role_name)
VALUES
('Manager'),
('Sales Employee'),
('Inventory Employee'),
('Purchase Employee'),
('Transfer Employee');

INSERT INTO Users (email, password, is_active)
VALUES
('manager@company.com', '1234', TRUE),
('sales@company.com', '1234', TRUE),
('inventory@company.com', '1234', TRUE),
('purchase@company.com', '1234', TRUE),
('transfer@company.com', '1234', TRUE),
('rahaf@gmail.com', '123', TRUE),
('samar@gmail.com', '123', TRUE);

INSERT INTO Warehouse (location, capacity, branch_id)
VALUES
('Ramallah Warehouse', 500, 1),
('Jenin Warehouse', 400, 2);

INSERT INTO Employee
(emp_name, salary, job_title, role_id, user_id, branch_id)
VALUES
('Ahmad Ali', 3500.00, 'Manager', 1, 1, 1),
('Lina Omar', 2500.00, 'Sales Employee', 2, 2, 1),
('Yousef Khaled', 2400.00, 'Inventory Employee', 3, 3, 2),
('Omar Nasser', 2600.00, 'Purchase Employee', 4, 4, 1),
('Khaled Saleh', 2500.00, 'Transfer Employee', 5, 5, 1),
('Rahaf', 0.00, 'Sales Employee', 2, 6, 1),
('Samar', 0.00, 'Sales Employee', 2, 7, 2);

INSERT INTO Employee_Phone (emp_id, phone)
VALUES
(1, '0599000001'),
(2, '0599000002'),
(3, '0599000003'),
(4, '0599000004'),
(5, '0599000005');

INSERT INTO Customer (cust_name, address, email)
VALUES
('Mohammad Salem', 'Ramallah', 'mohammad@gmail.com'),
('Sara Ahmad', 'Jenin', 'sara@gmail.com');

INSERT INTO Customer_Phone (cust_id, phone)
VALUES
(1, '0598111111'),
(2, '0598222222');

INSERT INTO Supplier (sup_name, address)
VALUES
('Auto Parts Company', 'Ramallah'),
('Global Cars Supplier', 'Jenin');

INSERT INTO Supplier_Phone (sup_id, phone)
VALUES
(1, '0599333333'),
(2, '0599444444');

INSERT INTO car
(vin, model, manufacture_year, color, status, price, image_path,
 branch_id, brand_id, car_cat_id, added_by_emp_id)
VALUES
('VIN1001', 'Toyota Corolla', 2020, 'White', 'Sold', 18000.00, NULL, 1, 1, 1, 2),
('VIN1002', 'Hyundai Tucson', 2022, 'Black', 'Available', 28000.00, NULL, 2, 2, 2, 2),
('VIN1003', 'Kia Sportage', 2021, 'Gray', 'Sold', 25000.00, NULL, 2, 3, 2, 6),
('VIN1004', 'Mercedes C200', 2023, 'Silver', 'Available', 52000.00, NULL, 2, 4, 3, 4),
('VIN1005', 'BMW X5', 2021, 'Blue', 'Available', 60000.00, NULL, 1, 5, 2, 4),
('VIN1006', 'Audi A6', 2022, 'White', 'Available', 55000.00, NULL, 2, 6, 3, 7),
('VIN1007', 'Honda Civic', 2019, 'Red', 'Sold', 17000.00, NULL, 1, 7, 1, 2),
('VIN1008', 'Nissan Altima', 2020, 'Black', 'Available', 22000.00, NULL, 2, 8, 1, 7);

INSERT INTO SparePart
(part_name, part_number, status, unit_price, image_path,
 brand_id, part_cat_id, added_by_emp_id)
VALUES
('Brake Pad', 'BP100', 'Available', 120.00, NULL, 1, 2, 3),
('Oil Filter', 'OF200', 'Available', 45.00, NULL, 2, 1, 3),
('Headlight', 'HL300', 'Available', 250.00, NULL, 4, 3, 3),
('Front Bumper', 'FB400', 'Out of Stock', 500.00, NULL, 5, 4, 3);

INSERT INTO Inventory
(quantity, date_in, date_out, warehouse_id, part_id)
VALUES
(63, '2026-01-10', NULL, 1, 1),
(5, '2026-06-02', NULL, 2, 1),
(80, '2026-01-15', NULL, 1, 2),
(34, '2026-02-01', NULL, 2, 3),
(0, '2026-02-10', NULL, 2, 4);

INSERT INTO Sales
(saleDate, salePrice, cust_id, emp_id, branch_id)
VALUES
('2026-05-01', 18240.00, 1, 2, 1),
('2026-05-10', 25250.00, 2, 6, 2);

INSERT INTO SalePayment
(paymentDate, amount, paymentType, sale_id)
VALUES
('2026-05-01', 18240.00, 'Cash', 1),
('2026-05-10', 25250.00, 'Card', 2);

INSERT INTO Purchase
(purchaseDate, cost, emp_id, sup_id)
VALUES
('2026-04-01', 54400.00, 4, 1),
('2026-04-15', 63750.00, 4, 2);

INSERT INTO PurchasePayment
(paymentDate, amount, payment_type, purchase_id)
VALUES
('2026-04-01', 54400.00, 'Cash', 1),
('2026-04-15', 63750.00, 'Bank Transfer', 2);

INSERT INTO CarTransferDetails
(transfer_date, status, notes, car_id, from_branch_id, to_branch_id, emp_id)
VALUES
('2026-06-01', 'Completed',
 'Car transferred from Ramallah to Jenin',
 2, 1, 2, 5),
('2026-06-05', 'Pending',
 'Car transfer waiting for approval',
 5, 1, 2, 5);

INSERT INTO SparePartTransferDetails
(quantity, transfer_date, status, notes,
 part_id, from_warehouse_id, to_warehouse_id, emp_id)
VALUES
(5, '2026-06-02', 'Completed',
 'Brake pads transferred between warehouses',
 1, 1, 2, 5),
(3, '2026-06-06', 'Pending',
 'Headlights waiting for transfer',
 3, 2, 1, 5);

INSERT INTO SaleCarDetails
(quantity, unit_price, sale_id, car_id)
VALUES
(1, 18000.00, 1, 1),
(1, 25000.00, 2, 3);

INSERT INTO SalePartDetails
(quantity, unit_price, sale_id, part_id, warehouse_id)
VALUES
(2, 120.00, 1, 1, 1),
(1, 250.00, 2, 3, 2);

INSERT INTO PurchaseCarDetails
(quantity, unit_price, purchase_id, car_id)
VALUES
(1, 52000.00, 1, 4),
(1, 60000.00, 2, 5);

INSERT INTO PurchasePartDetails
(quantity, unit_price, purchase_id, part_id)
VALUES
(20, 120.00, 1, 1),
(15, 250.00, 2, 3);

INSERT INTO StockMovement
(movement_type, quantity, movement_date, notes, warehouse_id, part_id)
VALUES
('Purchase', 20, '2026-04-01', 'Purchase #1 from Auto Parts Company', 1, 1),
('Purchase', 15, '2026-04-15', 'Purchase #2 from Global Cars Supplier', 2, 3),
('Sale', 2, '2026-05-01', 'Sale #1 to Mohammad Salem', 1, 1),
('Sale', 1, '2026-05-10', 'Sale #2 to Sara Ahmad', 2, 3),
('Transfer Out', 5, '2026-06-02', 'Transfer #1 to Jenin Warehouse', 1, 1),
('Transfer In', 5, '2026-06-02', 'Transfer #1 from Ramallah Warehouse', 2, 1);

/* ===================== SAMPLE QUERIES ===================== */

/* Query 1: Retrieve all branches located in a specific city */
SELECT *
FROM branch
WHERE city = 'Ramallah';

/* Query 2: Retrieve warehouse information for each branch */
SELECT b.branch_name,
       w.warehouse_id,
       w.location,
       w.capacity
FROM branch b
JOIN Warehouse w
ON b.branch_id = w.branch_id;

/* Query 3: Retrieve all branches with the number of employees */
SELECT b.branch_name,
       COUNT(e.emp_id) AS total_employees
FROM branch b
LEFT JOIN Employee e
ON b.branch_id = e.branch_id
GROUP BY b.branch_id,
         b.branch_name;

/* Query 4: Retrieve available cars in a specific branch */
SELECT c.car_id,
       c.vin,
       c.model,
       c.price,
       b.branch_name
FROM car c
JOIN branch b
ON c.branch_id = b.branch_id
WHERE c.branch_id = 1
AND c.status = 'Available';

/* Query 5: Retrieve cars of a specific brand in a specific branch */
SELECT c.car_id,
       c.vin,
       c.model,
       c.price,
       b.brand_name,
       br.branch_name
FROM car c
JOIN Brand b
ON c.brand_id = b.brand_id
JOIN branch br
ON c.branch_id = br.branch_id
WHERE b.brand_name = 'Toyota'
AND c.branch_id = 1;

/* Query 6: Retrieve cars of a specific category */
SELECT c.car_id,
       c.vin,
       c.model,
       c.price,
       cc.car_cat_name
FROM car c
JOIN Car_Category cc
ON c.car_cat_id = cc.car_cat_id
WHERE cc.car_cat_name = 'SUV';

/* Query 7: Retrieve cars within a price range */
SELECT *
FROM car
WHERE price BETWEEN 15000 AND 30000;

/* Query 8: Retrieve cars within a manufacture-year range */
SELECT *
FROM car
WHERE manufacture_year BETWEEN 2020 AND 2023;

/* Query 9: Retrieve all available cars */
SELECT *
FROM car
WHERE status = 'Available';

/* Query 10: Retrieve all sold cars */
SELECT *
FROM car
WHERE status = 'Sold';

/* Query 11: Retrieve the total number of available cars in each branch */
SELECT b.branch_name,
       COUNT(c.car_id) AS available_cars
FROM branch b
LEFT JOIN car c
ON b.branch_id = c.branch_id
AND c.status = 'Available'
GROUP BY b.branch_id,
         b.branch_name;

/* Query 12: Retrieve the average car price in each branch */
SELECT b.branch_name,
       AVG(c.price) AS average_car_price
FROM branch b
JOIN car c
ON b.branch_id = c.branch_id
GROUP BY b.branch_id,
         b.branch_name;

/* Query 13: Retrieve spare parts stored in a specific warehouse */
SELECT sp.part_name,
       sp.part_number,
       i.quantity,
       w.location
FROM Inventory i
JOIN SparePart sp
ON i.part_id = sp.part_id
JOIN Warehouse w
ON i.warehouse_id = w.warehouse_id
WHERE w.warehouse_id = 1;

/* Query 14: Retrieve spare parts of a specific brand */
SELECT sp.part_id,
       sp.part_name,
       sp.part_number,
       sp.unit_price,
       b.brand_name
FROM SparePart sp
JOIN Brand b
ON sp.brand_id = b.brand_id
WHERE b.brand_name = 'Toyota';

/* Query 15: Retrieve spare parts of a specific category */
SELECT sp.part_id,
       sp.part_name,
       sp.part_number,
       sp.unit_price,
       pc.part_cat_name
FROM SparePart sp
JOIN Part_Category pc
ON sp.part_cat_id = pc.part_cat_id
WHERE pc.part_cat_name = 'Brake Parts';

/* Query 16: Retrieve the quantity of each spare part in each warehouse */
SELECT w.location,
       sp.part_name,
       sp.part_number,
       i.quantity
FROM Inventory i
JOIN Warehouse w
ON i.warehouse_id = w.warehouse_id
JOIN SparePart sp
ON i.part_id = sp.part_id
ORDER BY w.location,
         sp.part_name;

/* Query 17: Retrieve spare parts below a specific quantity */
SELECT sp.part_name,
       sp.part_number,
       i.quantity,
       w.location
FROM Inventory i
JOIN SparePart sp
ON i.part_id = sp.part_id
JOIN Warehouse w
ON i.warehouse_id = w.warehouse_id
WHERE i.quantity < 20;

/* Query 18: Retrieve the total number of spare parts stored in each warehouse */
SELECT w.location,
       SUM(i.quantity) AS total_parts
FROM Inventory i
JOIN Warehouse w
ON i.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id,
         w.location;

/* Query 19: Retrieve stock movements for a specific spare part */
SELECT sm.movement_id,
       sm.movement_type,
       sm.quantity,
       sm.movement_date,
       sm.notes,
       sp.part_name
FROM StockMovement sm
JOIN SparePart sp
ON sm.part_id = sp.part_id
WHERE sp.part_id = 1;

/* Query 20: Retrieve stock movements within a date range */
SELECT sm.movement_id,
       sm.movement_type,
       sm.quantity,
       sm.movement_date,
       sm.notes,
       sp.part_name,
       w.location
FROM StockMovement sm
JOIN SparePart sp
ON sm.part_id = sp.part_id
JOIN Warehouse w
ON sm.warehouse_id = w.warehouse_id
WHERE sm.movement_date BETWEEN '2026-04-01' AND '2026-05-31';

/* Query 21: Retrieve total spare-part quantity added through purchases */
SELECT SUM(quantity) AS total_purchased_quantity
FROM StockMovement
WHERE movement_type = 'Purchase';

/* Query 22: Retrieve total spare-part quantity removed through sales */
SELECT SUM(quantity) AS total_sold_quantity
FROM StockMovement
WHERE movement_type = 'Sale';

/* Query 23: Retrieve stock movements in a specific warehouse */
SELECT sm.movement_id,
       sm.movement_type,
       sm.quantity,
       sm.movement_date,
       sm.notes,
       w.location
FROM StockMovement sm
JOIN Warehouse w
ON sm.warehouse_id = w.warehouse_id
WHERE w.warehouse_id = 1;

/* Query 24: Retrieve customers who purchased cars during a specific period */
SELECT DISTINCT c.cust_id,
                c.cust_name,
                c.email
FROM Customer c
JOIN Sales s
ON c.cust_id = s.cust_id
JOIN SaleCarDetails scd
ON s.sale_id = scd.sale_id
WHERE s.saleDate BETWEEN '2026-05-01' AND '2026-05-31';

/* Query 25: Retrieve customers who purchased spare parts during a specific period */
SELECT DISTINCT c.cust_id,
                c.cust_name,
                c.email
FROM Customer c
JOIN Sales s
ON c.cust_id = s.cust_id
JOIN SalePartDetails spd
ON s.sale_id = spd.sale_id
WHERE s.saleDate BETWEEN '2026-05-01' AND '2026-05-31';

/* Query 26: Retrieve sales handled by a specific employee */
SELECT s.sale_id,
       s.saleDate,
       s.salePrice,
       c.cust_name,
       e.emp_name,
       b.branch_name
FROM Sales s
JOIN Customer c
ON s.cust_id = c.cust_id
JOIN Employee e
ON s.emp_id = e.emp_id
JOIN branch b
ON s.branch_id = b.branch_id
WHERE s.emp_id = 2;

/* Query 27: Retrieve payments for a specific sale */
SELECT sp.payment_id,
       sp.paymentDate,
       sp.amount,
       sp.paymentType,
       s.sale_id
FROM SalePayment sp
JOIN Sales s
ON sp.sale_id = s.sale_id
WHERE sp.sale_id = 1;

/* Query 28: Retrieve total sales amount for each branch */
SELECT b.branch_name,
       SUM(s.salePrice) AS total_sales_amount
FROM branch b
JOIN Sales s
ON b.branch_id = s.branch_id
GROUP BY b.branch_id,
         b.branch_name;

/* Query 29: Retrieve the number of cars sold in each branch */
SELECT b.branch_name,
       SUM(scd.quantity) AS cars_sold
FROM branch b
JOIN Sales s
ON b.branch_id = s.branch_id
JOIN SaleCarDetails scd
ON s.sale_id = scd.sale_id
GROUP BY b.branch_id,
         b.branch_name;

/* Query 30: Retrieve the number of spare parts sold in each branch */
SELECT b.branch_name,
       SUM(spd.quantity) AS spare_parts_sold
FROM branch b
JOIN Sales s
ON b.branch_id = s.branch_id
JOIN SalePartDetails spd
ON s.sale_id = spd.sale_id
GROUP BY b.branch_id,
         b.branch_name;

/* Query 31: Retrieve purchases handled by a specific employee */
SELECT p.purchase_id,
       p.purchaseDate,
       p.cost,
       e.emp_name,
       s.sup_name
FROM Purchase p
JOIN Employee e
ON p.emp_id = e.emp_id
JOIN Supplier s
ON p.sup_id = s.sup_id
WHERE p.emp_id = 4;

/* Query 32: Retrieve purchases from a specific supplier */
SELECT p.purchase_id,
       p.purchaseDate,
       p.cost,
       s.sup_name,
       e.emp_name
FROM Purchase p
JOIN Supplier s
ON p.sup_id = s.sup_id
JOIN Employee e
ON p.emp_id = e.emp_id
WHERE p.sup_id = 1;

/* Query 33: Retrieve payments for a specific purchase */
SELECT pp.payment_id,
       pp.paymentDate,
       pp.amount,
       pp.payment_type,
       p.purchase_id
FROM PurchasePayment pp
JOIN Purchase p
ON pp.purchase_id = p.purchase_id
WHERE pp.purchase_id = 1;

/* Query 34: Retrieve total purchase cost from each supplier */
SELECT s.sup_name,
       SUM(p.cost) AS total_purchase_cost
FROM Supplier s
JOIN Purchase p
ON s.sup_id = p.sup_id
GROUP BY s.sup_id,
         s.sup_name;

/* Query 35: Retrieve all car transfers between branches */
SELECT ctd.car_transfer_id,
       ctd.transfer_date,
       ctd.status,
       c.model,
       c.vin,
       b1.branch_name AS from_branch,
       b2.branch_name AS to_branch,
       e.emp_name AS transfer_employee
FROM CarTransferDetails ctd
JOIN car c
ON ctd.car_id = c.car_id
JOIN branch b1
ON ctd.from_branch_id = b1.branch_id
JOIN branch b2
ON ctd.to_branch_id = b2.branch_id
JOIN Employee e
ON ctd.emp_id = e.emp_id;

/* Query 36: Retrieve all spare-part transfers between warehouses */
SELECT spt.spare_transfer_id,
       spt.transfer_date,
       spt.status,
       spt.quantity,
       sp.part_name,
       w1.location AS from_warehouse,
       w2.location AS to_warehouse,
       e.emp_name AS transfer_employee
FROM SparePartTransferDetails spt
JOIN SparePart sp
ON spt.part_id = sp.part_id
JOIN Warehouse w1
ON spt.from_warehouse_id = w1.warehouse_id
JOIN Warehouse w2
ON spt.to_warehouse_id = w2.warehouse_id
JOIN Employee e
ON spt.emp_id = e.emp_id;

/* Query 37: Retrieve all transfers within a specific date range */
SELECT 'Car Transfer' AS transfer_type,
       ctd.car_transfer_id AS transfer_id,
       ctd.transfer_date,
       ctd.status,
       e.emp_name
FROM CarTransferDetails ctd
JOIN Employee e
ON ctd.emp_id = e.emp_id
WHERE ctd.transfer_date BETWEEN '2026-06-01' AND '2026-06-30'

UNION

SELECT 'Spare Part Transfer' AS transfer_type,
       spt.spare_transfer_id AS transfer_id,
       spt.transfer_date,
       spt.status,
       e.emp_name
FROM SparePartTransferDetails spt
JOIN Employee e
ON spt.emp_id = e.emp_id
WHERE spt.transfer_date BETWEEN '2026-06-01' AND '2026-06-30';

/* Query 38: Retrieve the number of completed car transfers between branches */
SELECT b1.branch_name AS from_branch,
       b2.branch_name AS to_branch,
       COUNT(ctd.car_transfer_id) AS transferred_cars
FROM CarTransferDetails ctd
JOIN branch b1
ON ctd.from_branch_id = b1.branch_id
JOIN branch b2
ON ctd.to_branch_id = b2.branch_id
WHERE ctd.status = 'Completed'
GROUP BY b1.branch_id,
         b1.branch_name,
         b2.branch_id,
         b2.branch_name;

/* Query 39: Retrieve the total quantity of completed spare parts transferred between warehouses */
SELECT w1.location AS from_warehouse,
       w2.location AS to_warehouse,
       SUM(spt.quantity) AS transferred_quantity
FROM SparePartTransferDetails spt
JOIN Warehouse w1
ON spt.from_warehouse_id = w1.warehouse_id
JOIN Warehouse w2
ON spt.to_warehouse_id = w2.warehouse_id
WHERE spt.status = 'Completed'
GROUP BY w1.warehouse_id,
         w1.location,
         w2.warehouse_id,
         w2.location;

/* Query 40: Retrieve car transfers handled by a specific employee */
SELECT ctd.car_transfer_id,
       ctd.transfer_date,
       ctd.status,
       c.model,
       b1.branch_name AS from_branch,
       b2.branch_name AS to_branch
FROM CarTransferDetails ctd
JOIN car c
ON ctd.car_id = c.car_id
JOIN branch b1
ON ctd.from_branch_id = b1.branch_id
JOIN branch b2
ON ctd.to_branch_id = b2.branch_id
WHERE ctd.emp_id = 5;

/* Query 41: Retrieve spare-part transfers handled by a specific employee */
SELECT spt.spare_transfer_id,
       spt.transfer_date,
       spt.status,
       spt.quantity,
       sp.part_name,
       w1.location AS from_warehouse,
       w2.location AS to_warehouse
FROM SparePartTransferDetails spt
JOIN SparePart sp
ON spt.part_id = sp.part_id
JOIN Warehouse w1
ON spt.from_warehouse_id = w1.warehouse_id
JOIN Warehouse w2
ON spt.to_warehouse_id = w2.warehouse_id
WHERE spt.emp_id = 5;

/* Query 42: Retrieve all employees with their roles */
SELECT e.emp_id,
       e.emp_name,
       e.job_title,
       r.role_name,
       b.branch_name
FROM Employee e
JOIN Role r
ON e.role_id = r.role_id
JOIN branch b
ON e.branch_id = b.branch_id;

/* Query 43: Retrieve all active users */
SELECT user_id,
       email,
       is_active
FROM Users
WHERE is_active = TRUE;

/* Query 44: Retrieve all users with employee information and roles */
SELECT u.user_id,
       u.email,
       u.is_active,
       e.emp_id,
       e.emp_name,
       e.job_title,
       r.role_name,
       b.branch_name
FROM Users u
JOIN Employee e
ON u.user_id = e.user_id
JOIN Role r
ON e.role_id = r.role_id
JOIN branch b
ON e.branch_id = b.branch_id;

/* Query 45: Retrieve the number of cars added by each employee */
SELECT e.emp_id,
       e.emp_name,
       COUNT(c.car_id) AS cars_added
FROM Employee e
LEFT JOIN car c
ON e.emp_id = c.added_by_emp_id
GROUP BY e.emp_id,
         e.emp_name;

/* Query 46: Retrieve the number of spare parts added by each employee */
SELECT e.emp_id,
       e.emp_name,
       COUNT(sp.part_id) AS spare_parts_added
FROM Employee e
LEFT JOIN SparePart sp
ON e.emp_id = sp.added_by_emp_id
GROUP BY e.emp_id,
         e.emp_name;
