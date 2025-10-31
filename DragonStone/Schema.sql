/* =========================================================
   DragonStone E-Commerce — Full Schema (Fresh Install)
   Creates DB, tables, FKs, views, and seed data.
   Tested on MySQL 8+ (works on 5.7+).
   ========================================================= */

-- 0) Database
CREATE DATABASE IF NOT EXISTS dragonstone
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dragonstone;

-- 0.1) Drop views if this is re-run (avoid dependency issues)
DROP VIEW IF EXISTS v_top_products;
DROP VIEW IF EXISTS v_daily_sales;
DROP VIEW IF EXISTS v_low_stock;

-- 0.2) Drop tables if re-run (optional) — comment out in production
-- SET FOREIGN_KEY_CHECKS=0;
-- DROP TABLE IF EXISTS forum_comments, forum_posts, eco_points, subscriptions,
--   shipments, payments, order_items, orders,
--   cart_items, carts, products, categories, addresses, users;
-- SET FOREIGN_KEY_CHECKS=1;

/* =========================================================
   1) Core: Users & Addresses
   ========================================================= */
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin','staff','customer') NOT NULL DEFAULT 'customer',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE addresses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type ENUM('shipping','billing') NOT NULL,
  line1 VARCHAR(255) NOT NULL,
  city VARCHAR(120) NOT NULL,
  province VARCHAR(120) NOT NULL,
  postal_code VARCHAR(20) NOT NULL,
  country VARCHAR(120) NOT NULL DEFAULT 'South Africa',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(user_id),
  CONSTRAINT fk_addresses_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================================================
   2) Catalog: Categories & Products
   ========================================================= */
CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  slug VARCHAR(140) UNIQUE,
  parent_id INT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(parent_id),
  CONSTRAINT fk_categories_parent
    FOREIGN KEY (parent_id) REFERENCES categories(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT NULL,
  name VARCHAR(160) NOT NULL,
  sku VARCHAR(64) UNIQUE,
  price DECIMAL(10,2) NOT NULL,
  stock_qty INT NOT NULL DEFAULT 0,
  description TEXT,
  img VARCHAR(255),
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(category_id), INDEX(name), INDEX(status),
  CONSTRAINT fk_products_category
    FOREIGN KEY (category_id) REFERENCES categories(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================================================
   3) Carts
   ========================================================= */
CREATE TABLE carts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL,
  CONSTRAINT fk_carts_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cart_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cart_id INT NOT NULL,
  product_id INT NOT NULL,
  qty INT NOT NULL,
  price_at_add DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(cart_id), INDEX(product_id),
  CONSTRAINT fk_cart_items_cart
    FOREIGN KEY (cart_id) REFERENCES carts(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_cart_items_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================================================
   4) Orders & Order Items
   ========================================================= */
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status ENUM('pending','paid','shipped','completed','cancelled') NOT NULL DEFAULT 'pending',
  placed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(status), INDEX(placed_at),
  CONSTRAINT fk_orders_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  qty INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  INDEX(order_id), INDEX(product_id),
  CONSTRAINT fk_order_items_order
    FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_order_items_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================================================
   5) Payments & Shipments
   ========================================================= */
CREATE TABLE payments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  method VARCHAR(40) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  status ENUM('unpaid','paid','refunded','failed') NOT NULL DEFAULT 'unpaid',
  paid_at TIMESTAMP NULL,
  ref VARCHAR(120),
  INDEX(order_id), INDEX(status),
  CONSTRAINT fk_payments_order
    FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE shipments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  carrier VARCHAR(120) NOT NULL,
  tracking_no VARCHAR(120) NOT NULL,
  status ENUM('pending','shipped','delivered') NOT NULL DEFAULT 'pending',
  shipped_at TIMESTAMP NULL,
  INDEX(order_id), INDEX(status),
  CONSTRAINT fk_shipments_order
    FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================================================
   6) Subscriptions (recurring)
   ========================================================= */
CREATE TABLE subscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  interval_weeks INT NOT NULL DEFAULT 4,
  next_run DATE NULL,
  status ENUM('active','paused','cancelled') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(user_id), INDEX(product_id), INDEX(status),
  CONSTRAINT fk_subs_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_subs_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================================================
   7) Community & Eco Points
   ========================================================= */
CREATE TABLE forum_posts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  body MEDIUMTEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FULLTEXT KEY ft_forum_posts_body (body),
  INDEX(user_id),
  CONSTRAINT fk_posts_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE forum_comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(post_id), INDEX(user_id),
  CONSTRAINT fk_comments_post
    FOREIGN KEY (post_id) REFERENCES forum_posts(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_comments_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE eco_points (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  points INT NOT NULL,
  reason VARCHAR(200) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX(user_id),
  CONSTRAINT fk_points_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================================================
   8) Reporting Views
   ========================================================= */
CREATE VIEW v_daily_sales AS
SELECT
  DATE(placed_at) AS day,
  COUNT(*)       AS orders,
  SUM(total_amount) AS revenue
FROM orders
WHERE status IN ('paid','completed')
GROUP BY DATE(placed_at)
ORDER BY day DESC;

CREATE VIEW v_top_products AS
SELECT
  oi.product_id,
  p.name,
  SUM(oi.qty)                                   AS qty_sold,
  SUM(oi.qty * oi.unit_price)                   AS revenue
FROM order_items oi
JOIN products p ON p.id = oi.product_id
JOIN orders  o ON o.id = oi.order_id
WHERE o.status IN ('paid','completed')
GROUP BY oi.product_id, p.name
ORDER BY revenue DESC;

CREATE VIEW v_low_stock AS
SELECT id, name, sku, stock_qty
FROM products
WHERE status = 'active' AND stock_qty <= 10
ORDER BY stock_qty ASC;

/* =========================================================
   9) Seed Data (demo-friendly; change as needed)
   ========================================================= */

-- Users (password = admin123 for all three; change in production)
INSERT INTO users (name,email,password_hash,role) VALUES
('Admin','admin@dragonstone.test','$2y$10$F0lM4zujOeZ9h6R0o5f2be1ykY3nQm9gqv1nmxvJ8V6p20bWwqXBy','admin'),
('Staff','staff@dragonstone.test','$2y$10$F0lM4zujOeZ9h6R0o5f2be1ykY3nQm9gqv1nmxvJ8V6p20bWwqXBy','staff'),
('Aegon T','aegon@dragonstone.test','$2y$10$F0lM4zujOeZ9h6R0o5f2be1ykY3nQm9gqv1nmxvJ8V6p20bWwqXBy','customer');
('Admin','admin@example.com',
        '$2y$10$h9PtHSBkOTo3caEvmjlJIud4yhIAnaiQHuppkNDWJxaYWZwoABoSm', -- bcrypt for 'admin123'
        'admin')

-- Addresses for customer
INSERT INTO addresses (user_id,type,line1,city,province,postal_code,country) VALUES
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),'shipping','12 Greenway','Cape Town','Western Cape','8001','South Africa'),
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),'billing','12 Greenway','Cape Town','Western Cape','8001','South Africa');

-- Categories
INSERT INTO categories (name,slug) VALUES
('Cleaning & Household Supplies','cleaning-household'),
('Kitchen & Dining','kitchen-dining'),
('Home Décor & Living','home-decor');

-- Products (with SKUs & stock)
INSERT INTO products (category_id,name,sku,price,stock_qty,description,image_path,status) VALUES
((SELECT id FROM categories WHERE slug='cleaning-household'),'Laundry detergent sheets','DS-LAUN-001',79.99,200,'Eco-friendly laundry sheets','/images/detergent.jpg','active'),
((SELECT id FROM categories WHERE slug='cleaning-household'),'Compostable cleaning pods','DS-CLEAN-001',59.00,150,'Biodegradable pods','/images/pods.jpg','active'),
((SELECT id FROM categories WHERE slug='kitchen-dining'),'Bamboo cutting board','DS-BAM-001',199.00,80,'Sustainable bamboo board','/images/board.jpg','active'),
((SELECT id FROM categories WHERE slug='home-decor'),'Soy wax candle - lavender','DS-CAND-001',129.00,12,'Natural essential oils','/images/candle.jpg','active'),
((SELECT id FROM categories WHERE slug='home-decor'),'Organic cotton towel','DS-TOWEL-001',189.00,9,'Soft and sustainable','/images/towel.jpg','active');

-- Optional: a cart for the customer
INSERT INTO carts (user_id) VALUES ((SELECT id FROM users WHERE email='aegon@dragonstone.test'));
INSERT INTO cart_items (cart_id,product_id,qty,price_at_add)
SELECT c.id, p.id, 1, p.price
FROM carts c JOIN products p ON p.sku='DS-LAUN-001'
WHERE c.user_id = (SELECT id FROM users WHERE email='aegon@dragonstone.test');

-- Orders: paid/completed to light up reports
INSERT INTO orders (user_id,total_amount,status,placed_at) VALUES
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),199.00,'completed', DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),129.00,'paid',      DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),238.00,'paid',      DATE_SUB(CURDATE(), INTERVAL 1 DAY));

-- Order items
INSERT INTO order_items (order_id,product_id,qty,unit_price) VALUES
(1, (SELECT id FROM products WHERE sku='DS-BAM-001'), 1, 199.00),
(2, (SELECT id FROM products WHERE sku='DS-CAND-001'),1, 129.00),
(3, (SELECT id FROM products WHERE sku='DS-LAUN-001'),1, 79.99),
(3, (SELECT id FROM products WHERE sku='DS-CLEAN-001'),1, 59.00),
(3, (SELECT id FROM products WHERE sku='DS-CAND-001'),1, 99.01); -- to reach 238.00

-- Payments (simulated)
INSERT INTO payments (order_id,method,amount,status,paid_at,ref) VALUES
(1,'card',199.00,'paid',NOW(),'SIM-0001'),
(2,'card',129.00,'paid',NOW(),'SIM-0002'),
(3,'card',238.00,'paid',NOW(),'SIM-0003');

-- Shipment for order 1
INSERT INTO shipments (order_id,carrier,tracking_no,status,shipped_at) VALUES
(1,'GreenCourier','GRN123456','delivered', DATE_SUB(CURDATE(), INTERVAL 6 DAY));

-- Subscription example (every 4 weeks)
INSERT INTO subscriptions (user_id,product_id,interval_weeks,next_run,status)
VALUES (
 (SELECT id FROM users WHERE email='aegon@dragonstone.test'),
 (SELECT id FROM products WHERE sku='DS-LAUN-001'),
 4, DATE_ADD(CURDATE(), INTERVAL 4 WEEK), 'active'
);

-- Forum + Comments + Eco points
INSERT INTO forum_posts (user_id,title,body) VALUES
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),'My zero-waste kitchen','Sharing tips about bamboo boards and reusable jars.');

INSERT INTO forum_comments (post_id,user_id,body) VALUES
(1,(SELECT id FROM users WHERE email='staff@dragonstone.test'),'Great ideas! Thanks for sharing.');

INSERT INTO eco_points (user_id,points,reason) VALUES
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),50,'First purchase'),
((SELECT id FROM users WHERE email='aegon@dragonstone.test'),25,'Forum contribution');

/* =========================================================
   END — DragonStone Full Schema + Seed
   Login demo:
   admin@dragonstone.test / admin123  (admin)
   staff@dragonstone.test / admin123  (staff)
   aegon@dragonstone.test / admin123  (customer)
   ========================================================= */
CREATE TABLE IF NOT EXISTS forum_posts (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  user_id       INT NULL,
  title         VARCHAR(180) NOT NULL,
  slug          VARCHAR(220) NOT NULL UNIQUE,
  body          TEXT NOT NULL,
  tags          VARCHAR(250) NULL,
  is_published  TINYINT(1) NOT NULL DEFAULT 1,
  is_flagged    TINYINT(1) NOT NULL DEFAULT 0,
  upvotes       INT NOT NULL DEFAULT 0,
  comments_cnt  INT NOT NULL DEFAULT 0,
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS forum_comments (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  post_id      INT NOT NULL,
  user_id      INT NULL,
  body         TEXT NOT NULL,
  is_flagged   TINYINT(1) NOT NULL DEFAULT 0,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS forum_votes (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  post_id   INT NOT NULL,
  user_id   INT NOT NULL,
  vote      TINYINT NOT NULL, -- +1 only (no downvotes for now)
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_vote (post_id, user_id),
  FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ECOPOINTS LEDGER (earn/spend)
CREATE TABLE IF NOT EXISTS ecopoints_ledger (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  delta       INT NOT NULL,  -- + earn / - spend
  reason      VARCHAR(120) NOT NULL,  -- 'post', 'comment', 'purchase', 'review', 'challenge'
  ref_type    VARCHAR(40) NULL,       -- 'forum_post', 'forum_comment', 'order', etc.
  ref_id      INT NULL,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- quick view: total points per user
CREATE OR REPLACE VIEW v_ecopoints_balance AS
  SELECT user_id, COALESCE(SUM(delta),0) AS balance
  FROM ecopoints_ledger GROUP BY user_id;