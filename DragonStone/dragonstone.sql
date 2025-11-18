-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 05, 2025 at 11:41 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dragonstone`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('shipping','billing') NOT NULL,
  `line1` varchar(255) NOT NULL,
  `city` varchar(120) NOT NULL,
  `province` varchar(120) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  `country` varchar(120) NOT NULL DEFAULT 'South Africa',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `type`, `line1`, `city`, `province`, `postal_code`, `country`, `created_at`) VALUES
(1, 3, 'shipping', '12 Greenway', 'Cape Town', 'Western Cape', '8001', 'South Africa', '2025-10-17 09:00:45'),
(2, 3, 'billing', '12 Greenway', 'Cape Town', 'Western Cape', '8001', 'South Africa', '2025-10-17 09:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 3, '2025-10-17 09:00:45', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `qty`, `price`, `created_at`) VALUES
(1, 1, 1, 1, 79.99, '2025-10-17 09:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `slug` varchar(140) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `parent_id`, `created_at`) VALUES
(1, 'Cleaning & Household Supplies', 'cleaning-household', NULL, '2025-10-17 09:00:45'),
(2, 'Kitchen & Dining', 'kitchen-dining', NULL, '2025-10-17 09:00:45'),
(3, 'Home Décor & Living', 'home-decor', NULL, '2025-10-17 09:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `ecopoints_ledger`
--

CREATE TABLE `ecopoints_ledger` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `delta` int(11) NOT NULL,
  `reason` varchar(120) NOT NULL,
  `ref_type` varchar(40) DEFAULT NULL,
  `ref_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `eco_points`
--

CREATE TABLE `eco_points` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `points` int(11) NOT NULL,
  `reason` varchar(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `eco_points`
--

INSERT INTO `eco_points` (`id`, `user_id`, `points`, `reason`, `created_at`) VALUES
(1, 3, 50, 'First purchase', '2025-10-17 09:00:45'),
(2, 3, 25, 'Forum contribution', '2025-10-17 09:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `forum_comments`
--

CREATE TABLE `forum_comments` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `body` text NOT NULL,
  `is_flagged` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forum_posts`
--

CREATE TABLE `forum_posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(180) NOT NULL,
  `slug` varchar(220) NOT NULL,
  `body` text NOT NULL,
  `tags` varchar(250) DEFAULT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT 1,
  `is_flagged` tinyint(1) NOT NULL DEFAULT 0,
  `upvotes` int(11) NOT NULL DEFAULT 0,
  `comments_cnt` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `forum_posts`
--

INSERT INTO `forum_posts` (`id`, `user_id`, `title`, `slug`, `body`, `tags`, `is_published`, `is_flagged`, `upvotes`, `comments_cnt`, `created_at`) VALUES
(1, NULL, 'Build a Chair', 'build-a-chair-fb5bff', 'Take wood and start building', '', 1, 0, 0, 0, '2025-10-29 12:32:34'),
(2, NULL, 'This is a test', 'this-is-a-test-d9f93b', 'Do it work', '', 1, 0, 0, 0, '2025-10-30 10:54:13'),
(3, NULL, 'This is test 2', 'this-is-test-2-827252', 'Do it work now', '', 1, 0, 0, 0, '2025-10-30 12:19:15'),
(4, NULL, 'Building a solar pannel', 'building-a-solar-pannel-74e70e', 'You get everything you need, start collecting the sun', '', 1, 0, 0, 0, '2025-10-31 08:59:38'),
(5, NULL, 'do it work', 'do-it-work-d85c49', 'tyesting', '', 1, 0, 0, 0, '2025-10-31 09:50:17'),
(6, NULL, 'testing 002', 'testing-002-1a372d', 'hello world', '', 1, 0, 0, 0, '2025-11-05 12:29:25');

-- --------------------------------------------------------

--
-- Table structure for table `forum_votes`
--

CREATE TABLE `forum_votes` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `vote` tinyint(4) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','paid','shipped','completed','cancelled') NOT NULL DEFAULT 'pending',
  `placed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `customer_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `delivery_address` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `status`, `placed_at`, `customer_name`, `email`, `delivery_address`) VALUES
(1, 3, 199.00, 'completed', '2025-10-09 22:00:00', '', '', ''),
(2, 3, 129.00, 'paid', '2025-10-13 22:00:00', '', '', ''),
(3, 3, 238.00, 'paid', '2025-10-15 22:00:00', '', '', ''),
(13, 7, 368.97, 'pending', '2025-10-29 10:46:47', 'koos', 'koos@example.com', 'work'),
(19, 8, 79.99, 'pending', '2025-10-30 21:06:34', 'cutomer', 'customer@example.com', 'adress'),
(20, 5, 79.99, 'pending', '2025-10-31 06:56:22', 'admin', 'admin@example.com', 'testing 20'),
(21, 5, 715.00, 'pending', '2025-10-31 06:58:23', 'admin', 'admin@example.com', 'Admin adress');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `qty`, `unit_price`, `name`) VALUES
(1, 1, 3, 1, 199.00, ''),
(2, 2, 4, 1, 129.00, ''),
(3, 3, 1, 1, 79.99, ''),
(4, 3, 2, 1, 59.00, ''),
(5, 3, 4, 1, 99.01, ''),
(19, 13, 4, 1, 79.99, 'Soy wax candle - lavender'),
(27, 19, 1, 1, 79.99, 'Laundry detergent sheets'),
(28, 20, 1, 1, 79.99, 'Laundry detergent sheets'),
(29, 21, 2, 2, 59.00, 'Compostable cleaning pods'),
(30, 21, 3, 3, 199.00, 'Bamboo cutting board');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `method` varchar(40) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('unpaid','paid','refunded','failed') NOT NULL DEFAULT 'unpaid',
  `paid_at` timestamp NULL DEFAULT NULL,
  `ref` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `method`, `amount`, `status`, `paid_at`, `ref`) VALUES
(1, 1, 'card', 199.00, 'paid', '2025-10-17 09:00:45', 'SIM-0001'),
(2, 2, 'card', 129.00, 'paid', '2025-10-17 09:00:45', 'SIM-0002'),
(3, 3, 'card', 238.00, 'paid', '2025-10-17 09:00:45', 'SIM-0003');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(160) NOT NULL,
  `sku` varchar(64) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_qty` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `sku`, `price`, `stock_qty`, `description`, `img`, `status`, `created_at`) VALUES
(1, 1, 'Laundry detergent sheets', 'DS-LAUN-001', 79.99, 200, 'Eco-friendly laundry sheets', 'https://media.istockphoto.com/id/1387977149/photo/eco-friendly-organic-natural-baby-laundry-detergent-and-soap-gel-bottle-with-branch-of-green.jpg?s=612x612&w=0&k=20&c=wVQEvmIqGpJ1Ob4AovjkYfOFt17nKin2-q0n92gq7zE=', 'active', '2025-10-17 09:00:45'),
(2, 1, 'Compostable cleaning pods', 'DS-CLEAN-001', 59.00, 150, 'Biodegradable pods', 'https://www.innuscience.com/web/image/product.template/19691/image_1920?unique=a687abb', 'active', '2025-10-17 09:00:45'),
(3, 2, 'Bamboo cutting board', 'DS-BAM-001', 199.00, 80, 'Sustainable bamboo board', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLQyuaCmFBEDeLFKtGozuiT-9y7l7sxKrM-g&s', 'active', '2025-10-17 09:00:45'),
(4, 3, 'Soy wax candle - lavender', 'DS-CAND-001', 129.00, 12, 'Natural essential oils', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlDOdYF3vSjSuLh8gHk-GnEc_LFR86jwndhA&s', 'active', '2025-10-17 09:00:45'),
(5, 3, 'Organic cotton towel', 'DS-TOWEL-001', 189.00, 9, 'Soft and sustainable', 'https://misona.co.uk/cdn/shop/articles/close_up_organic_cotton_towels_sage_e90b951c-bece-48c5-b075-bfe7d2f6d834.jpg?v=1745495594&width=1060', 'active', '2025-10-17 09:00:45'),
(7, 1, 'ECO Floor Cleaner', NULL, 85.99, 26, '', 'https://www.shutterstock.com/image-vector/floor-cleaner-ads-product-package-260nw-1936160983.jpg', 'active', '2025-10-22 18:08:33'),
(10, NULL, 'Recycled glass vases', NULL, 350.00, 20, 'Recycled glass vase', 'https://sfycdn.speedsize.com/aa5d6cd7-da91-4546-92d9-893ea42dd7ff/www.nkuku.com/cdn/shop/files/Kotri-Recycled-Glass-Organic-Shape-Vase-Clear-nkuku-2_1200x1200.jpg?v=1731508542', 'active', '2025-10-29 06:42:29');

-- --------------------------------------------------------

--
-- Table structure for table `shipments`
--

CREATE TABLE `shipments` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `carrier` varchar(120) NOT NULL,
  `tracking_no` varchar(120) NOT NULL,
  `status` enum('pending','shipped','delivered') NOT NULL DEFAULT 'pending',
  `shipped_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipments`
--

INSERT INTO `shipments` (`id`, `order_id`, `carrier`, `tracking_no`, `status`, `shipped_at`) VALUES
(1, 1, 'GreenCourier', 'GRN123456', 'delivered', '2025-10-10 22:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `interval_weeks` int(11) NOT NULL DEFAULT 4,
  `next_run` date DEFAULT NULL,
  `status` enum('active','paused','cancelled') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `user_id`, `product_id`, `interval_weeks`, `next_run`, `status`, `created_at`) VALUES
(1, 3, 1, 4, '2025-11-14', 'active', '2025-10-17 09:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(160) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','staff','customer') NOT NULL DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'Admin', 'admin@dragonstone.test', '$2y$10$F0lM4zujOeZ9h6R0o5f2be1ykY3nQm9gqv1nmxvJ8V6p20bWwqXBy', 'admin', '2025-10-17 09:00:43'),
(2, 'Staff', 'staff@dragonstone.test', '$2y$10$F0lM4zujOeZ9h6R0o5f2be1ykY3nQm9gqv1nmxvJ8V6p20bWwqXBy', 'staff', '2025-10-17 09:00:43'),
(3, 'Aegon T', 'aegon@dragonstone.test', '$2y$10$F0lM4zujOeZ9h6R0o5f2be1ykY3nQm9gqv1nmxvJ8V6p20bWwqXBy', 'customer', '2025-10-17 09:00:43'),
(4, 'koos', 'koos@cp.co', '$2y$10$d0GkCHWYRSjapcML8LCfU.Utf40ooAZBE.doN0s9CROqc3qQqVD2W', 'customer', '2025-10-20 12:23:39'),
(5, 'Admin', 'admin@example.com', '$2y$10$h9PtHSBkOTo3caEvmjlJIud4yhIAnaiQHuppkNDWJxaYWZwoABoSm', 'admin', '2025-10-21 07:30:13'),
(6, 'Piet', 'piet@example.com', '$2y$10$DoamAgV33vPtjBht7diYceAbYjS8v5mk9JHD8DcWXDlX76xA6JCb.', '', '2025-10-22 18:12:58'),
(7, 'Koos', 'koos@example.com', '$2y$10$BXgmHIoSph.SRnMpkopXO.xIALAU4g.BolPGSjrsUC9cRXm6bl73S', 'customer', '2025-10-29 07:02:57'),
(8, 'customer', 'customer@example.com', '$2y$10$3IcTxWVdpMfnin2ztIcaOeujjuV2sgcDUnut4ifPiwB09o5G55Wlq', 'customer', '2025-10-30 20:38:00');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_daily_sales`
-- (See below for the actual view)
--
CREATE TABLE `v_daily_sales` (
`day` date
,`orders` bigint(21)
,`revenue` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_ecopoints_balance`
-- (See below for the actual view)
--
CREATE TABLE `v_ecopoints_balance` (
`user_id` int(11)
,`balance` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_low_stock`
-- (See below for the actual view)
--
CREATE TABLE `v_low_stock` (
`id` int(11)
,`name` varchar(160)
,`sku` varchar(64)
,`stock_qty` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_top_products`
-- (See below for the actual view)
--
CREATE TABLE `v_top_products` (
`product_id` int(11)
,`name` varchar(160)
,`qty_sold` decimal(32,0)
,`revenue` decimal(42,2)
);

-- --------------------------------------------------------

--
-- Structure for view `v_daily_sales`
--
DROP TABLE IF EXISTS `v_daily_sales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_daily_sales`  AS SELECT cast(`orders`.`placed_at` as date) AS `day`, count(0) AS `orders`, sum(`orders`.`total_amount`) AS `revenue` FROM `orders` WHERE `orders`.`status` in ('paid','completed') GROUP BY cast(`orders`.`placed_at` as date) ORDER BY cast(`orders`.`placed_at` as date) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `v_ecopoints_balance`
--
DROP TABLE IF EXISTS `v_ecopoints_balance`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_ecopoints_balance`  AS SELECT `ecopoints_ledger`.`user_id` AS `user_id`, coalesce(sum(`ecopoints_ledger`.`delta`),0) AS `balance` FROM `ecopoints_ledger` GROUP BY `ecopoints_ledger`.`user_id` ;

-- --------------------------------------------------------

--
-- Structure for view `v_low_stock`
--
DROP TABLE IF EXISTS `v_low_stock`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_low_stock`  AS SELECT `products`.`id` AS `id`, `products`.`name` AS `name`, `products`.`sku` AS `sku`, `products`.`stock_qty` AS `stock_qty` FROM `products` WHERE `products`.`status` = 'active' AND `products`.`stock_qty` <= 10 ORDER BY `products`.`stock_qty` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `v_top_products`
--
DROP TABLE IF EXISTS `v_top_products`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_top_products`  AS SELECT `oi`.`product_id` AS `product_id`, `p`.`name` AS `name`, sum(`oi`.`qty`) AS `qty_sold`, sum(`oi`.`qty` * `oi`.`unit_price`) AS `revenue` FROM ((`order_items` `oi` join `products` `p` on(`p`.`id` = `oi`.`product_id`)) join `orders` `o` on(`o`.`id` = `oi`.`order_id`)) WHERE `o`.`status` in ('paid','completed') GROUP BY `oi`.`product_id`, `p`.`name` ORDER BY sum(`oi`.`qty` * `oi`.`unit_price`) DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `ecopoints_ledger`
--
ALTER TABLE `ecopoints_ledger`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `eco_points`
--
ALTER TABLE `eco_points`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `forum_comments`
--
ALTER TABLE `forum_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `forum_posts`
--
ALTER TABLE `forum_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `forum_votes`
--
ALTER TABLE `forum_votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_vote` (`post_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`),
  ADD KEY `placed_at` (`placed_at`),
  ADD KEY `fk_orders_user` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `name` (`name`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `shipments`
--
ALTER TABLE `shipments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ecopoints_ledger`
--
ALTER TABLE `ecopoints_ledger`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `eco_points`
--
ALTER TABLE `eco_points`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `forum_comments`
--
ALTER TABLE `forum_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `forum_posts`
--
ALTER TABLE `forum_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `forum_votes`
--
ALTER TABLE `forum_votes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `shipments`
--
ALTER TABLE `shipments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `fk_carts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cart_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `ecopoints_ledger`
--
ALTER TABLE `ecopoints_ledger`
  ADD CONSTRAINT `ecopoints_ledger_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `eco_points`
--
ALTER TABLE `eco_points`
  ADD CONSTRAINT `fk_points_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `forum_comments`
--
ALTER TABLE `forum_comments`
  ADD CONSTRAINT `forum_comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `forum_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `forum_posts`
--
ALTER TABLE `forum_posts`
  ADD CONSTRAINT `forum_posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `forum_votes`
--
ALTER TABLE `forum_votes`
  ADD CONSTRAINT `forum_votes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `forum_votes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `shipments`
--
ALTER TABLE `shipments`
  ADD CONSTRAINT `fk_shipments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `fk_subs_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `fk_subs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
