-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 19, 2025 at 08:34 PM
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
(3, 'Home Décor & Living', 'home-decor', NULL, '2025-10-17 09:00:45'),
(4, 'Bathroom & Personal Care', 'bathroom-personal-care', NULL, '2025-11-14 12:03:59'),
(5, 'Lifestyle & Wellness', 'lifestyle-wellness', NULL, '2025-11-14 12:03:59'),
(6, 'Kids & Pets', 'kids-pets', NULL, '2025-11-14 12:03:59'),
(7, 'Outdoor & Garden', 'outdoor-garden', NULL, '2025-11-14 12:03:59');

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

--
-- Dumping data for table `ecopoints_ledger`
--

INSERT INTO `ecopoints_ledger` (`id`, `user_id`, `delta`, `reason`, `ref_type`, `ref_id`, `created_at`) VALUES
(1, 7, 3, 'comment', 'forum_comment', 0, '2025-11-13 12:43:45'),
(2, 7, 3, 'comment', 'forum_comment', 0, '2025-11-13 12:43:53'),
(3, 7, 10, 'post', 'forum_post', 7, '2025-11-13 12:44:27'),
(4, 9, 3, 'comment', 'forum_comment', 0, '2025-11-13 12:47:48'),
(5, 10, 3, 'comment', 'forum_comment', 0, '2025-11-13 12:50:02'),
(6, 10, 10, 'post', 'forum_post', 8, '2025-11-13 12:58:09'),
(7, 7, 3, 'comment', 'forum_comment', 0, '2025-11-17 12:14:46'),
(8, 7, 209, 'purchase', 'order', 23, '2025-11-17 12:33:20'),
(9, 9, 3, 'comment', 'forum_comment', 0, '2025-11-17 13:17:00'),
(10, 5, 3, 'comment', 'forum_comment', 0, '2025-11-17 15:45:08'),
(11, 5, 79, 'purchase', 'order', 24, '2025-11-17 15:45:36'),
(12, 5, 180, 'purchase', 'order', 25, '2025-11-18 13:42:04'),
(13, 5, 199, 'purchase', 'order', 26, '2025-11-18 13:51:55'),
(14, 7, 180, 'purchase', 'order', 46, '2025-11-18 23:11:23'),
(15, 7, 159, 'purchase', 'order', 47, '2025-11-18 23:57:14'),
(16, 7, 3, 'comment', 'forum_comment', 0, '2025-11-18 23:59:20'),
(17, 7, 3, 'comment', 'forum_comment', 0, '2025-11-19 00:06:13'),
(18, 7, 10, 'post', 'forum_post', 9, '2025-11-19 00:20:39'),
(19, 7, 10, 'post', 'forum_post', 10, '2025-11-19 00:48:08'),
(20, 7, 10, 'post', 'forum_post', 11, '2025-11-19 20:46:26'),
(21, 5, 10, 'post', 'forum_post', 12, '2025-11-19 21:17:22'),
(22, 5, 3, 'comment', 'forum_comment', 0, '2025-11-19 21:17:35');

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

--
-- Dumping data for table `forum_comments`
--

INSERT INTO `forum_comments` (`id`, `post_id`, `user_id`, `body`, `is_flagged`, `created_at`) VALUES
(12, 6, 7, 'Do it work', 0, '2025-11-13 12:25:31'),
(13, 6, 7, 'Do it work', 0, '2025-11-13 12:43:45'),
(14, 6, 7, 'it works', 0, '2025-11-13 12:43:53'),
(15, 7, 9, 'This would be cool', 0, '2025-11-13 12:47:48'),
(16, 7, 10, 'Wow this is working', 0, '2025-11-13 12:50:02'),
(17, 7, 7, 'what a great test', 0, '2025-11-17 12:14:46'),
(18, 8, 9, 'Dragonstone is the best', 0, '2025-11-17 13:17:00'),
(19, 7, 5, 'Love testing', 0, '2025-11-17 15:45:08'),
(20, 7, 7, 'does this work', 0, '2025-11-18 23:59:20'),
(21, 8, 7, 'help me', 0, '2025-11-19 00:06:13'),
(22, 12, 5, 'comments do work', 0, '2025-11-19 21:17:35');

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
(5, NULL, 'do it work', 'do-it-work-d85c49', 'tyesting', '', 1, 0, 1, 0, '2025-10-31 09:50:17'),
(6, NULL, 'testing 002', 'testing-002-1a372d', 'hello world', '', 1, 0, 2, 3, '2025-11-05 12:29:25'),
(7, 7, 'Building a house', 'building-a-house-af8d68', 'We still testing', '', 1, 0, 3, 5, '2025-11-13 12:44:27'),
(8, 10, 'Cleaning house tips', 'cleaning-house-tips-56ae0b', 'When cleaning bye the right cleaning agents form dragonstone, the best store out there', '', 1, 0, 2, 2, '2025-11-13 12:58:09'),
(9, 7, 'Lets build an eltric car', 'lets-build-an-eltric-car-d2901e', 'you need all the parts, we are testing', NULL, 1, 0, 0, 0, '2025-11-19 00:20:39'),
(10, 7, 'vigvogib', 'vigvogib-f04cf3', 'ljblbnlbl', NULL, 1, 0, 0, 0, '2025-11-19 00:48:08'),
(11, 7, 'testing 0021', 'testing-0021-099f92', 'hoop hoop', NULL, 1, 0, 0, 0, '2025-11-19 20:46:26'),
(12, 5, 'Hello world', 'hello-world-bf535e', 'we are going places', '', 1, 0, 1, 1, '2025-11-19 21:17:22');

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

--
-- Dumping data for table `forum_votes`
--

INSERT INTO `forum_votes` (`id`, `post_id`, `user_id`, `vote`, `created_at`) VALUES
(10, 6, 7, 1, '2025-11-13 12:25:21'),
(13, 7, 9, 1, '2025-11-13 12:47:40'),
(14, 7, 10, 1, '2025-11-13 12:49:49'),
(16, 5, 10, 1, '2025-11-13 12:53:05'),
(18, 8, 5, 1, '2025-11-17 11:04:44'),
(19, 7, 7, 1, '2025-11-17 12:14:32'),
(20, 8, 9, 1, '2025-11-17 12:50:57'),
(23, 6, 9, 1, '2025-11-17 12:51:06'),
(24, 12, 5, 1, '2025-11-19 21:17:25');

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
  `delivery_address` varchar(255) NOT NULL,
  `carbon_grams` decimal(12,2) DEFAULT NULL COMMENT 'Total CO2e grams for this order'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `status`, `placed_at`, `customer_name`, `email`, `delivery_address`, `carbon_grams`) VALUES
(13, 7, 368.97, 'pending', '2025-10-29 10:46:47', 'koos', 'koos@example.com', 'work', NULL),
(19, 8, 79.99, 'pending', '2025-10-30 21:06:34', 'cutomer', 'customer@example.com', 'adress', NULL),
(20, 5, 79.99, 'pending', '2025-10-31 06:56:22', 'admin', 'admin@example.com', 'testing 20', NULL),
(21, 5, 715.00, 'pending', '2025-10-31 06:58:23', 'admin', 'admin@example.com', 'Admin adress', NULL),
(22, 7, 239.97, 'pending', '2025-11-14 11:59:19', 'Koos', 'koos@example.com', 'koos street address', NULL),
(23, 7, 209.99, 'pending', '2025-11-17 10:33:20', 'koos', 'koos@example.com', 'koos street', NULL),
(24, 5, 79.99, 'pending', '2025-11-17 13:45:36', 'admin', 'admin@example.com', 'admin streeet', 60.00),
(25, 5, 180.00, 'pending', '2025-11-18 11:42:04', 'admin', 'admin@example.com', 'admin home', 85.00),
(26, 5, 199.00, 'pending', '2025-11-18 11:51:55', 'admin', 'admin@example.com', 'admin home 2', 64.00),
(42, 7, 79.99, 'pending', '2025-11-18 21:07:02', 'koos', 'koos@example.com', 'koos huis', NULL),
(43, 7, 59.00, 'pending', '2025-11-18 21:07:35', 'koos', 'koos@example.com', 'koos huis 5', NULL),
(44, 7, 59.00, 'pending', '2025-11-18 21:08:07', 'koos', 'koos@example.com', 'koos 6', NULL),
(45, 7, 79.99, 'pending', '2025-11-18 21:08:44', 'koos', 'koos@example.com', 'koos 7', NULL),
(46, 7, 180.00, 'pending', '2025-11-18 21:11:23', 'koos', 'koos@example.com', 'koos 10', NULL),
(47, 7, 159.98, 'pending', '2025-11-18 21:57:14', 'koos', 'koos@example.com', 'koos huis', NULL),
(48, 5, 179.98, 'pending', '2025-11-19 19:16:45', 'admin', 'admin@example.com', 'admin street 10', NULL);

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
(19, 13, 4, 1, 79.99, 'Soy wax candle - lavender'),
(27, 19, 1, 1, 79.99, 'Laundry detergent sheets'),
(28, 20, 1, 1, 79.99, 'Laundry detergent sheets'),
(29, 21, 2, 2, 59.00, 'Compostable cleaning pods'),
(30, 21, 3, 3, 199.00, 'Bamboo cutting board'),
(31, 22, 1, 3, 79.99, 'Laundry detergent sheets'),
(32, 23, 12, 1, 120.00, 'Eco-friendly yoga mats'),
(33, 23, 11, 1, 89.99, 'Reusable water bottles'),
(34, 24, 1, 1, 79.99, 'Laundry detergent sheets'),
(35, 25, 14, 1, 180.00, 'Solar-powered garden lights'),
(36, 26, 3, 1, 199.00, 'Bamboo cutting board'),
(37, 42, 1, 1, 79.99, 'Laundry detergent sheets'),
(38, 43, 2, 1, 59.00, 'Compostable cleaning pods'),
(39, 44, 2, 1, 59.00, 'Compostable cleaning pods'),
(40, 45, 1, 1, 79.99, 'Laundry detergent sheets'),
(41, 46, 14, 1, 180.00, 'Solar-powered garden lights'),
(42, 47, 1, 2, 79.99, 'Laundry detergent sheets'),
(43, 48, 11, 2, 89.99, 'Reusable water bottles');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `carbon_per_unit` decimal(10,2) DEFAULT NULL COMMENT 'Estimated g CO2e per unit'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `sku`, `price`, `stock_qty`, `description`, `img`, `status`, `created_at`, `carbon_per_unit`) VALUES
(1, 1, 'Laundry detergent sheets', 'DS-LAUN-001', 79.99, 200, 'Eco-friendly laundry sheets', 'https://media.istockphoto.com/id/1387977149/photo/eco-friendly-organic-natural-baby-laundry-detergent-and-soap-gel-bottle-with-branch-of-green.jpg?s=612x612&w=0&k=20&c=wVQEvmIqGpJ1Ob4AovjkYfOFt17nKin2-q0n92gq7zE=', 'active', '2025-10-17 09:00:45', 50.00),
(2, 1, 'Compostable cleaning pods', 'DS-CLEAN-001', 59.00, 150, 'Biodegradable pods', 'https://www.innuscience.com/web/image/product.template/19691/image_1920?unique=a687abb', 'active', '2025-10-17 09:00:45', NULL),
(3, 2, 'Bamboo cutting board', 'DS-BAM-001', 199.00, 80, 'Sustainable bamboo board', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLQyuaCmFBEDeLFKtGozuiT-9y7l7sxKrM-g&s', 'active', '2025-10-17 09:00:45', NULL),
(4, 3, 'Soy wax candle - lavender', 'DS-CAND-001', 129.00, 12, 'Natural essential oils', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlDOdYF3vSjSuLh8gHk-GnEc_LFR86jwndhA&s', 'active', '2025-10-17 09:00:45', NULL),
(5, 3, 'Organic cotton towel', 'DS-TOWEL-001', 189.00, 9, 'Soft and sustainable', 'https://misona.co.uk/cdn/shop/articles/close_up_organic_cotton_towels_sage_e90b951c-bece-48c5-b075-bfe7d2f6d834.jpg?v=1745495594&width=1060', 'active', '2025-10-17 09:00:45', NULL),
(7, 1, 'ECO Floor Cleaner', NULL, 85.99, 26, '', 'https://www.shutterstock.com/image-vector/floor-cleaner-ads-product-package-260nw-1936160983.jpg', 'active', '2025-10-22 18:08:33', 100.00),
(10, 3, 'Recycled glass vases', NULL, 350.00, 20, 'Recycled glass vase', 'https://sfycdn.speedsize.com/aa5d6cd7-da91-4546-92d9-893ea42dd7ff/www.nkuku.com/cdn/shop/files/Kotri-Recycled-Glass-Organic-Shape-Vase-Clear-nkuku-2_1200x1200.jpg?v=1731508542', 'active', '2025-10-29 06:42:29', NULL),
(11, 5, 'Reusable water bottles', NULL, 89.99, 50, '', 'https://media.istockphoto.com/id/1286669433/photo/water-bottles-minimalistic-design-on-the-counter-in-the-store.jpg?s=612x612&w=0&k=20&c=Qdh6Axm0DBxziRcNDtgzQ2kAHjzv-rDRuJ9nvUSqeGM=', 'active', '2025-11-14 12:54:18', NULL),
(12, 6, 'Eco-friendly yoga mats', NULL, 120.00, 30, '', 'https://media.istockphoto.com/id/1472464529/photo/environmentally-friendly-living-room-interior-with-exercise-ball-yoga-mat-green-plants-and.jpg?s=612x612&w=0&k=20&c=ZJMHfY0u5qS0Uy96Y78I3qvQw6wSiy3gaGAHF0TgOfM=', 'active', '2025-11-14 12:59:04', NULL),
(13, 6, 'Wooden toy car', NULL, 250.00, 20, '', 'https://media.istockphoto.com/id/911953018/photo/souvenirs-and-gifts.jpg?s=612x612&w=0&k=20&c=NKnvPLe0v-69gxqtvB1WwpEA_xUhRXw2t_VJUle7PrY=', 'active', '2025-11-14 18:53:43', NULL),
(14, 7, 'Solar-powered garden lights', NULL, 180.00, 90, '', 'https://media.istockphoto.com/id/629434366/photo/small-solar-garden-light-lantern-in-flower-bed-garden-design.jpg?s=612x612&w=0&k=20&c=JDKIfPRgq1KhJmXFuwPTIEwYkT0yjTjcpOlCTnDsVTE=', 'active', '2025-11-14 19:58:28', NULL);

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
  `role` enum('admin','staff','customer','manager') NOT NULL DEFAULT 'customer',
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
(8, 'customer', 'customer@example.com', '$2y$10$3IcTxWVdpMfnin2ztIcaOeujjuV2sgcDUnut4ifPiwB09o5G55Wlq', 'customer', '2025-10-30 20:38:00'),
(9, 'Wian', 'wian@example.com', '$2y$10$c4rUuwmokljSzHl5odqbJe7T2CLwWrzDWjjDwfuhwzCWWWCWNMdy.', 'customer', '2025-11-13 10:45:09'),
(10, 'kian', 'kian@example.com', '$2y$10$6IvKJ3INNvQY.EXqQ7CHQuFJJimDPidZbQJcOom.PJf5wnNwLod0C', 'customer', '2025-11-13 10:48:19'),
(11, 'admin2', 'admin2@example.com', '$2y$10$lfFfwnadCX4dCCzxeSMbA.Rm4VV4fY8SZbg2J1SeVZD8yvRsFlu0a', 'admin', '2025-11-18 10:11:41'),
(12, 'peter', 'peter@example.com', '$2y$10$8FH8eKSuXmNSdE1c0bRJa.PJoXHk15qTE.ddmOKNOp8sd3UdVw0Vm', 'customer', '2025-11-19 18:59:20'),
(13, 'green', 'green@example.com', '$2y$10$bNa8/nGv8GNdsiMKILt4mO7ew78uAlpv/w3mLgE.roFY9TsCIPTX2', 'customer', '2025-11-19 19:30:03');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `ecopoints_ledger`
--
ALTER TABLE `ecopoints_ledger`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `eco_points`
--
ALTER TABLE `eco_points`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `forum_comments`
--
ALTER TABLE `forum_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `forum_posts`
--
ALTER TABLE `forum_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `forum_votes`
--
ALTER TABLE `forum_votes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

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
