CREATE TABLE regions
  (
    region_id NUMBER GENERATED BY DEFAULT AS IDENTITY
    START WITH 5 PRIMARY KEY,
    region_name VARCHAR2( 50 ) NOT NULL
  );
-- countries table
CREATE TABLE countries
  (
    country_id   CHAR( 2 ) PRIMARY KEY  ,
    country_name VARCHAR2( 40 ) NOT NULL,
    region_id    NUMBER                 , -- fk
    CONSTRAINT fk_countries_regions FOREIGN KEY( region_id )
      REFERENCES regions( region_id ) 
      ON DELETE CASCADE
  );

-- location
CREATE TABLE locations
  (
    location_id NUMBER GENERATED BY DEFAULT AS IDENTITY START WITH 24 
                PRIMARY KEY       ,
    address     VARCHAR2( 255 ) NOT NULL,
    postal_code VARCHAR2( 20 )          ,
    city        VARCHAR2( 50 )          ,
    state       VARCHAR2( 50 )          ,
    country_id  CHAR( 2 )               , -- fk
    CONSTRAINT fk_locations_countries 
      FOREIGN KEY( country_id )
      REFERENCES countries( country_id ) 
      ON DELETE CASCADE
  );
-- warehouses
CREATE TABLE warehouses
  (
    warehouse_id NUMBER 
                 GENERATED BY DEFAULT AS IDENTITY START WITH 10 
                 PRIMARY KEY,
    warehouse_name VARCHAR( 255 ) ,
    location_id    NUMBER( 12, 0 ), -- fk
    CONSTRAINT fk_warehouses_locations 
      FOREIGN KEY( location_id )
      REFERENCES locations( location_id ) 
      ON DELETE CASCADE
  );
-- employees
CREATE TABLE employees
  (
    employee_id NUMBER 
                GENERATED BY DEFAULT AS IDENTITY START WITH 108 
                PRIMARY KEY,
    first_name VARCHAR( 255 ) NOT NULL,
    last_name  VARCHAR( 255 ) NOT NULL,
    email      VARCHAR( 255 ) NOT NULL,
    phone      VARCHAR( 50 ) NOT NULL ,
    hire_date  DATE NOT NULL          ,
    manager_id NUMBER( 12, 0 )        , -- fk
    job_title  VARCHAR( 255 ) NOT NULL,
    CONSTRAINT fk_employees_manager 
        FOREIGN KEY( manager_id )
        REFERENCES employees( employee_id )
        ON DELETE CASCADE
  );
-- product category
CREATE TABLE product_categories
  (
    category_id NUMBER 
                GENERATED BY DEFAULT AS IDENTITY START WITH 6 
                PRIMARY KEY,
    category_name VARCHAR2( 255 ) NOT NULL
  );

-- products table
CREATE TABLE products
  (
    product_id NUMBER 
               GENERATED BY DEFAULT AS IDENTITY START WITH 289 
               PRIMARY KEY,
    product_name  VARCHAR2( 255 ) NOT NULL,
    description   VARCHAR2( 2000 )        ,
    standard_cost NUMBER( 9, 2 )          ,
    list_price    NUMBER( 9, 2 )          ,
    category_id   NUMBER NOT NULL         ,
    CONSTRAINT fk_products_categories 
      FOREIGN KEY( category_id )
      REFERENCES product_categories( category_id ) 
      ON DELETE CASCADE
  );
-- customers
CREATE TABLE customers
  (
    customer_id NUMBER 
                GENERATED BY DEFAULT AS IDENTITY START WITH 320 
                PRIMARY KEY,
    name         VARCHAR2( 255 ) NOT NULL,
    address      VARCHAR2( 255 )         ,
    website      VARCHAR2( 255 )         ,
    credit_limit NUMBER( 8, 2 )
  );
-- contacts
CREATE TABLE contacts
  (
    contact_id NUMBER 
               GENERATED BY DEFAULT AS IDENTITY START WITH 320 
               PRIMARY KEY,
    first_name  VARCHAR2( 255 ) NOT NULL,
    last_name   VARCHAR2( 255 ) NOT NULL,
    email       VARCHAR2( 255 ) NOT NULL,
    phone       VARCHAR2( 20 )          ,
    customer_id NUMBER                  ,
    CONSTRAINT fk_contacts_customers 
      FOREIGN KEY( customer_id )
      REFERENCES customers( customer_id ) 
      ON DELETE CASCADE
  );
-- orders table
CREATE TABLE orders
  (
    order_id NUMBER 
             GENERATED BY DEFAULT AS IDENTITY START WITH 106 
             PRIMARY KEY,
    customer_id NUMBER( 6, 0 ) NOT NULL, -- fk
    status      VARCHAR( 20 ) NOT NULL ,
    salesman_id NUMBER( 6, 0 )         , -- fk
    order_date  DATE NOT NULL          ,
    CONSTRAINT fk_orders_customers 
      FOREIGN KEY( customer_id )
      REFERENCES customers( customer_id )
      ON DELETE CASCADE,
    CONSTRAINT fk_orders_employees 
      FOREIGN KEY( salesman_id )
      REFERENCES employees( employee_id ) 
      ON DELETE SET NULL
  );
-- order items
CREATE TABLE order_items
  (
    order_id   NUMBER( 12, 0 )                                , -- fk
    item_id    NUMBER( 12, 0 )                                ,
    product_id NUMBER( 12, 0 ) NOT NULL                       , -- fk
    quantity   NUMBER( 8, 2 ) NOT NULL                        ,
    unit_price NUMBER( 8, 2 ) NOT NULL                        ,
    CONSTRAINT pk_order_items 
      PRIMARY KEY( order_id, item_id ),
    CONSTRAINT fk_order_items_products 
      FOREIGN KEY( product_id )
      REFERENCES products( product_id ) 
      ON DELETE CASCADE,
    CONSTRAINT fk_order_items_orders 
      FOREIGN KEY( order_id )
      REFERENCES orders( order_id ) 
      ON DELETE CASCADE
  );
-- inventories
CREATE TABLE inventories
  (
    product_id   NUMBER( 12, 0 )        , -- fk
    warehouse_id NUMBER( 12, 0 )        , -- fk
    quantity     NUMBER( 8, 0 ) NOT NULL,
    CONSTRAINT pk_inventories 
      PRIMARY KEY( product_id, warehouse_id ),
    CONSTRAINT fk_inventories_products 
      FOREIGN KEY( product_id )
      REFERENCES products( product_id ) 
      ON DELETE CASCADE,
    CONSTRAINT fk_inventories_warehouses 
      FOREIGN KEY( warehouse_id )
      REFERENCES warehouses( warehouse_id ) 
      ON DELETE CASCADE
  );


INSERT INTO regions(region_name) VALUES ('Asia');

INSERT INTO countries(country_id, country_name, region_id) VALUES ('FR', 'France', 5);

INSERT INTO locations(address, postal_code, city, state, country_id) VALUES ('15th Avenue', '12345', 'Seattle', 'WA', 'FR');

INSERT INTO warehouses(warehouse_name, location_id) VALUES ('West Warehouse', 25);

INSERT INTO employees(first_name, last_name, email, phone, hire_date, manager_id, job_title)
VALUES ('John', 'Doe', 'john.doe@example.com', '123456789', '01-01-2022', NULL, 'Salesman');

INSERT INTO product_categories(category_name) VALUES ('Electronic');

INSERT INTO products(product_name, description, standard_cost, list_price, category_id)
VALUES ('Smartphone', 'A smartphone with advanced features', 200.00, 500.00, 6);

INSERT INTO customers(name, address, website, credit_limit) VALUES ('Acme Corporation', '123 Main Street', 'www.acme.com', 50000.00);

INSERT INTO contacts(first_name, last_name, email, phone, customer_id)
VALUES ('Jane', 'Doe', 'jane.doe@example.com', '987654321', 320);

INSERT INTO orders(customer_id, status, salesman_id, order_date)
VALUES (320, 'Pending', 128, '04-25-2023');

INSERT INTO order_items(order_id, item_id, product_id, quantity, unit_price)
VALUES (127, 1, 290, 2, 450.00);

INSERT INTO inventories(product_id, warehouse_id, quantity)
VALUES (290, 31, 50);