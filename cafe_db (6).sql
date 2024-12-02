-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 02, 2024 at 09:28 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cafe_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `archived_sales`
--

CREATE TABLE `archived_sales` (
  `archive_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_date` datetime(6) NOT NULL,
  `total_amount` float NOT NULL,
  `user_id` int(11) NOT NULL,
  `payment_status` varchar(255) NOT NULL,
  `archived_date` datetime(6) NOT NULL,
  `archived_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `archived_sales`
--

INSERT INTO `archived_sales` (`archive_id`, `order_id`, `customer_id`, `order_date`, `total_amount`, `user_id`, `payment_status`, `archived_date`, `archived_by`) VALUES
(1, 43, 52, '2024-12-02 13:54:38.000000', 246, 1, 'paid', '2024-12-02 16:25:00.000000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`user_id`, `product_id`, `quantity`) VALUES
(4, 59, 1),
(4, 56, 3);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `total_amount` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `Name`, `total_amount`) VALUES
(22, 'test1', 100),
(23, 'HIZOLA, JOHN CARLO A.', 1090),
(24, 'HIZOLA, JOHN CARLO A.', 2000),
(25, 'test1', 400),
(26, 'test1', 400),
(27, 'test1', 400),
(29, 'Xyrell Dave', 20),
(30, 'Xyrell Dave', 20),
(31, 'Xyrell Dave', 20),
(32, 'Xyrell Dave', 20),
(33, 'Lauraa Kate Roa', 200),
(34, 'Lauraa Kate Roa', 10000),
(35, 'Lauraa Kate Roa', 50),
(36, 'John Carlo Arceo Hizola', 600),
(37, 'John Carlo Arceo Hizola', 300),
(38, 'hizz', 10000),
(39, 'kjhkjh', 6000),
(40, 'hizola, John Carlo A. JC', 500),
(41, 'dear', 500),
(42, 'test3', 300),
(43, 'test2', 1234),
(44, 'HIZOLA, JOHN CARLO A.', 400),
(45, 'test2', 20),
(46, 'test2', 200),
(47, 'HIZOLA, JOHN CARLO A.', 200),
(48, 'test2', 500),
(49, 'fitness roms', 400),
(50, 'HIZOLA, JOHN CARLO A.', 120),
(51, 'hizola, John Carlo A. JC', 400),
(52, 'fitness roms', 300);

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `inventory_id` int(11) NOT NULL,
  `stock_quantity` int(11) NOT NULL,
  `last_updated` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `unit_of_measure` varchar(50) DEFAULT 'pieces'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`inventory_id`, `stock_quantity`, `last_updated`, `user_id`, `item_name`, `unit_of_measure`) VALUES
(15, 100, '2024-11-18 18:49:51.000000', 0, 'ice', 'pieces'),
(18, 6, '2024-11-17 15:15:49.000000', 0, 'flour', 'pieces'),
(19, 83, '2024-12-02 09:20:14.000000', 0, 'Burger Buns', 'pieces'),
(20, 137, '2024-12-02 11:23:50.000000', 0, 'Beef Patty', 'pieces'),
(21, 188, '2024-12-02 09:20:14.000000', 0, 'Cheese Slices', 'pieces'),
(22, 10, '2024-12-02 09:20:14.000000', 0, 'Potatoes', 'kilograms'),
(23, 30, '2024-12-02 09:20:14.000000', 0, 'Lettuce', 'pieces'),
(24, 50, '2024-12-02 09:20:14.000000', 0, 'Tomatoes', 'pieces'),
(25, 20, '2024-12-02 09:20:14.000000', 0, 'Mayo', 'liters'),
(26, 20, '2024-12-02 09:20:14.000000', 0, 'Ketchup', 'liters'),
(27, 99, '2024-11-29 15:37:15.000000', 0, 'Pizza Dough', 'pieces'),
(28, 30, '2024-11-29 16:42:51.000000', 0, 'Tomato Sauce', 'liters'),
(29, 40, '2024-11-29 16:42:51.000000', 0, 'Mozzarella', 'kilograms'),
(30, 30, '2024-11-29 16:42:51.000000', 0, 'Pepperoni', 'kilograms'),
(31, 20, '2024-11-18 18:48:25.000000', 0, 'Bell Peppers', 'kilograms'),
(32, 20, '2024-11-18 18:48:25.000000', 0, 'Mushrooms', 'kilograms'),
(33, 21, '2024-12-02 09:24:18.000000', 0, 'Chocolate', 'kilograms'),
(34, 24, '2024-12-02 09:24:18.000000', 0, 'Cream Cheese', 'kilograms'),
(35, 20, '2024-12-02 09:24:18.000000', 0, 'Whipped Cream', 'liters'),
(36, 10, '2024-12-02 09:24:18.000000', 0, 'Graham Crackers', 'kilograms'),
(37, 30, '2024-11-18 18:48:25.000000', 0, 'Butter', 'kilograms'),
(38, 50, '2024-11-18 18:48:25.000000', 0, 'Milk', 'liters'),
(39, 50, '2024-11-18 18:48:25.000000', 0, 'Sugar', 'kilograms'),
(40, 200, '2024-11-18 18:48:25.000000', 0, 'Eggs', 'pieces'),
(41, 40, '2024-11-18 18:48:25.000000', 0, 'Coffee Beans', 'kilograms'),
(42, 500, '2024-11-18 18:48:25.000000', 0, 'Tea Bags', 'pieces'),
(43, 30, '2024-11-18 18:48:25.000000', 0, 'Chocolate Powder', 'kilograms'),
(44, 20, '2024-11-18 18:48:25.000000', 0, 'Vanilla Syrup', 'liters'),
(45, 20, '2024-11-18 18:48:25.000000', 0, 'Caramel Syrup', 'liters'),
(47, 10, '2024-11-29 15:37:15.000000', 0, 'Cooking Oil', 'liters'),
(49, 10, '2024-11-19 08:59:24.000000', 0, 'Chocolate Syrup', 'liters'),
(50, 19, '2024-11-29 16:42:51.000000', 0, 'dough', 'pieces'),
(53, 7, '2024-12-02 13:55:57.000000', 0, 'test', 'kilograms');

--
-- Triggers `inventory`
--
DELIMITER $$
CREATE TRIGGER `update_ingredient_name` AFTER UPDATE ON `inventory` FOR EACH ROW BEGIN
    UPDATE product_ingredients 
    SET ingredient_name = NEW.item_name 
    WHERE inventory_id = NEW.inventory_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_date` datetime(6) NOT NULL,
  `total_amount` float NOT NULL,
  `user_id` int(11) NOT NULL,
  `payment_status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`order_id`, `customer_id`, `order_date`, `total_amount`, `user_id`, `payment_status`) VALUES
(18, 22, '2024-11-17 16:55:08.000000', 54, 1, 'paid'),
(19, 23, '2024-11-18 10:18:03.000000', 184, 1, 'paid'),
(21, 25, '2024-11-18 17:29:08.000000', 246, 1, 'paid'),
(22, 26, '2024-11-18 18:01:09.000000', 240, 1, 'paid'),
(23, 27, '2024-11-18 18:07:10.000000', 243, 1, 'paid'),
(28, 32, '2024-11-19 08:48:35.000000', 15, 1, 'paid'),
(29, 33, '2024-11-19 09:22:46.000000', 179, 1, 'paid'),
(30, 34, '2024-11-19 09:23:40.000000', 8950, 1, 'paid'),
(31, 36, '2024-11-19 13:13:12.000000', 587, 1, 'paid'),
(32, 37, '2024-11-26 16:44:25.000000', 229, 1, 'paid'),
(33, 38, '2024-11-29 15:37:15.000000', 5713, 1, 'paid'),
(34, 39, '2024-11-29 15:53:03.000000', 5000, 1, 'paid'),
(35, 40, '2024-11-29 16:42:51.000000', 399, 1, 'paid'),
(36, 41, '2024-11-29 16:44:54.000000', 408, 4, 'paid'),
(37, 42, '2024-11-30 09:45:34.000000', 229, 1, 'paid'),
(38, 47, '2024-12-02 09:06:35.000000', 179, 1, 'paid'),
(39, 48, '2024-12-02 09:20:14.000000', 407, 1, 'paid'),
(40, 49, '2024-12-02 09:24:18.000000', 179, 1, 'paid'),
(41, 50, '2024-12-02 10:34:15.000000', 100, 1, 'paid'),
(42, 51, '2024-12-02 11:37:32.000000', 246, 1, 'paid'),
(43, 52, '2024-12-02 13:54:38.000000', 246, 1, 'paid');

-- --------------------------------------------------------

--
-- Table structure for table `order_item`
--

CREATE TABLE `order_item` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_item`
--

INSERT INTO `order_item` (`order_item_id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(41, 28, 65, 1, 15),
(42, 29, 49, 1, 179),
(43, 30, 49, 50, 179),
(44, 31, 59, 1, 229),
(45, 31, 51, 2, 179),
(46, 32, 59, 1, 229),
(47, 33, 58, 1, 199),
(48, 33, 65, 1, 15),
(49, 33, 55, 1, 499),
(50, 33, 49, 1, 5000),
(51, 34, 49, 1, 5000),
(52, 35, 56, 1, 399),
(53, 36, 51, 1, 179),
(54, 36, 59, 1, 229),
(55, 37, 59, 1, 229),
(56, 38, 51, 1, 179),
(57, 39, 59, 1, 228),
(58, 39, 51, 1, 179),
(59, 40, 51, 1, 179),
(60, 41, 70, 1, 100),
(61, 42, 71, 2, 123),
(62, 43, 71, 2, 123);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` float NOT NULL,
  `category` varchar(255) NOT NULL,
  `image` blob NOT NULL,
  `size` varchar(50) DEFAULT 'base-size'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `name`, `price`, `category`, `image`, `size`) VALUES
(36, 'Pearl Black', 159, 'Drinks', 0x313733313932373938355f6c6f676f2e706e67, 'Small'),
(37, 'Pearl Black', 169, 'Drinks', 0x313733313932373939365f6c6f676f2e706e67, 'Large'),
(38, 'Okinawa', 165, 'Drinks', 0x313733313932373937315f6c6f676f2e706e67, 'Small'),
(39, 'Okinawa', 175, 'Drinks', 0x313733313932373936355f6c6f676f2e706e67, 'Large'),
(40, 'Wintermelon', 165, 'Drinks', 0x313733313932383032325f6c6f676f2e706e67, 'Small'),
(41, 'Wintermelon', 175, 'Drinks', 0x313733313932383033305f6c6f676f2e706e67, 'Large'),
(42, 'Hokkaido', 165, 'Drinks', 0x313733313932373934365f6c6f676f2e706e67, 'Small'),
(43, 'Hokkaido', 175, 'Drinks', 0x313733313932373935305f6c6f676f2e706e67, 'Large'),
(44, 'Strawberry', 165, 'Drinks', 0x313733313932383030365f6c6f676f2e706e67, 'Small'),
(45, 'Strawberry', 175, 'Drinks', 0x313733313932383031335f6c6f676f2e706e67, 'Large'),
(46, 'Matcha', 165, 'Drinks', 0x313733313932373935355f6c6f676f2e706e67, 'Small'),
(47, 'Matcha', 175, 'Drinks', 0x313733313932383036335f6c6f676f2e706e67, 'Large'),
(48, 'Dark Choco', 179, 'Chocolate Series', 0x313733313932373632315f6c6f676f2e706e67, 'Standard'),
(49, 'Chocolate Cheesecake', 200, 'Chocolate Series', 0x313733313932373631315f6c6f676f2e706e67, 'Small'),
(50, 'Hershey Cheesecake', 179, 'Chocolate Series', 0x313733313932373633395f6c6f676f2e706e67, 'Standard'),
(51, 'Blueberry Cheesecake', 179, 'Chocolate Series', 0x313733333130313932385f6c6f676f2e706e67, 'Standard'),
(52, 'Strawberry Cheesecake', 179, 'Chocolate Series', 0x313733313932373737305f6c6f676f2e706e67, 'Standard'),
(53, 'Matcha Cheesecake', 179, 'Chocolate Series', 0x313733313932373736305f6c6f676f2e706e67, 'Standard'),
(54, 'Pepperoni Pizza', 399, 'Pizza', 0x313733313932383035335f6c6f676f2e706e67, 'Small'),
(55, 'Pepperoni Pizza', 499, 'Pizza', 0x313733313932373931305f6c6f676f2e706e67, 'Large'),
(56, 'Hawaiian Pizza', 399, 'Pizza', 0x313733313932373835325f6c6f676f2e706e67, 'Small'),
(58, 'Classic Burger', 199, 'Burger & Fries', 0x313733313932373631365f6c6f676f2e706e67, 'Standard'),
(59, 'Cheese Burger', 228, 'Burger & Fries', 0x313733313932373630365f6c6f676f2e706e67, 'Standard'),
(60, 'Double Cheese Burger', 299, 'Burger & Fries', 0x313733313932373632365f6c6f676f2e706e67, 'Standard'),
(63, 'nachos', 120, 'Nachos', 0x313733313932383737305f6c6f676f2e706e67, 'Standard'),
(64, 'Hawaiian pizza', 499, 'Pizza', 0x313733313932383830365f6c6f676f2e706e67, 'Large'),
(65, 'Fries', 15, 'Burger & Fries', 0x313733313934343538305f6c6f676f2e706e67, 'Standard'),
(67, 'Pepperoni Pizza', 454, 'Pizza', 0x313733313939323936365f6c6f676f2e706e67, 'Standard'),
(70, 'test', 100, 'Pizza', 0x313733333034343734335f6c6f676f2e706e67, 'Standard'),
(71, 'test', 123, 'Pizza', 0x313733333130313934325f6c6f676f2e706e67, 'Standard');

-- --------------------------------------------------------

--
-- Table structure for table `product_ingredients`
--

CREATE TABLE `product_ingredients` (
  `product_ingredient_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `ingredient_name` varchar(255) DEFAULT NULL,
  `quantity_needed` float NOT NULL DEFAULT 1,
  `unit_of_measure` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_ingredients`
--

INSERT INTO `product_ingredients` (`product_ingredient_id`, `product_id`, `inventory_id`, `ingredient_name`, `quantity_needed`, `unit_of_measure`) VALUES
(5, 58, 20, 'Beef Patty', 1, ''),
(6, 59, 20, 'Beef Patty', 18, 'pieces'),
(7, 60, 20, 'Beef Patty', 1, ''),
(8, 58, 19, 'Burger Buns', 1, ''),
(9, 59, 19, 'Burger Buns', 2, 'pieces'),
(10, 60, 19, 'Burger Buns', 1, ''),
(11, 58, 21, 'Cheese Slices', 1, ''),
(12, 59, 21, 'Cheese Slices', 1, ''),
(13, 60, 21, 'Cheese Slices', 1, ''),
(14, 48, 33, 'Chocolate', 0.2, ''),
(15, 49, 33, 'Chocolate', 0.2, ''),
(16, 50, 33, 'Chocolate', 0.2, ''),
(17, 51, 33, 'Chocolate', 0.2, ''),
(18, 52, 33, 'Chocolate', 0.2, ''),
(19, 53, 33, 'Chocolate', 0.2, ''),
(20, 48, 34, 'Cream Cheese', 0.3, ''),
(21, 49, 34, 'Cream Cheese', 0.3, ''),
(22, 50, 34, 'Cream Cheese', 0.3, ''),
(23, 51, 34, 'Cream Cheese', 0.3, ''),
(24, 52, 34, 'Cream Cheese', 0.3, ''),
(25, 53, 34, 'Cream Cheese', 0.3, ''),
(26, 48, 36, 'Graham Crackers', 0.2, ''),
(27, 49, 36, 'Graham Crackers', 0.2, ''),
(28, 50, 36, 'Graham Crackers', 0.2, ''),
(29, 51, 36, 'Graham Crackers', 0.2, ''),
(30, 52, 36, 'Graham Crackers', 0.2, ''),
(31, 53, 36, 'Graham Crackers', 0.2, ''),
(32, 58, 26, 'Ketchup', 0.03, ''),
(33, 59, 26, 'Ketchup', 0.03, ''),
(34, 60, 26, 'Ketchup', 0.03, ''),
(35, 58, 23, 'Lettuce', 0.2, ''),
(36, 59, 23, 'Lettuce', 0.2, ''),
(37, 60, 23, 'Lettuce', 0.2, ''),
(38, 58, 25, 'Mayo', 0.03, ''),
(39, 59, 25, 'Mayo', 0.03, ''),
(40, 60, 25, 'Mayo', 0.03, ''),
(53, 36, 38, 'Milk', 0, ''),
(54, 37, 38, 'Milk', 0, ''),
(55, 38, 38, 'Milk', 0, ''),
(56, 39, 38, 'Milk', 0, ''),
(57, 40, 38, 'Milk', 0, ''),
(58, 41, 38, 'Milk', 0, ''),
(59, 42, 38, 'Milk', 0, ''),
(60, 43, 38, 'Milk', 0, ''),
(61, 44, 38, 'Milk', 0, ''),
(62, 45, 38, 'Milk', 0, ''),
(63, 46, 38, 'Milk', 0, ''),
(64, 47, 38, 'Milk', 0, ''),
(65, 54, 29, 'Mozzarella', 0.3, ''),
(66, 55, 29, 'Mozzarella', 0.3, ''),
(67, 56, 29, 'Mozzarella', 0.3, ''),
(69, 54, 30, 'Pepperoni', 0.2, ''),
(70, 55, 30, 'Pepperoni', 0.2, ''),
(71, 56, 30, 'Pepperoni', 0.2, ''),
(73, 54, 27, 'Pizza Dough', 1, ''),
(74, 55, 27, 'Pizza Dough', 1, ''),
(77, 58, 22, 'Potatoes', 0.2, ''),
(78, 59, 22, 'Potatoes', 0.2, ''),
(79, 60, 22, 'Potatoes', 0.2, ''),
(80, 36, 39, 'Sugar', 0, ''),
(81, 37, 39, 'Sugar', 0, ''),
(82, 38, 39, 'Sugar', 0, ''),
(83, 39, 39, 'Sugar', 0, ''),
(84, 40, 39, 'Sugar', 0, ''),
(85, 41, 39, 'Sugar', 0, ''),
(86, 42, 39, 'Sugar', 0, ''),
(87, 43, 39, 'Sugar', 0, ''),
(88, 44, 39, 'Sugar', 0, ''),
(89, 45, 39, 'Sugar', 0, ''),
(90, 46, 39, 'Sugar', 0, ''),
(91, 47, 39, 'Sugar', 0, ''),
(92, 36, 42, 'Tea Bags', 2, ''),
(93, 37, 42, 'Tea Bags', 2, ''),
(94, 38, 42, 'Tea Bags', 2, ''),
(95, 39, 42, 'Tea Bags', 2, ''),
(96, 40, 42, 'Tea Bags', 2, ''),
(97, 41, 42, 'Tea Bags', 2, ''),
(98, 42, 42, 'Tea Bags', 2, ''),
(99, 43, 42, 'Tea Bags', 2, ''),
(100, 44, 42, 'Tea Bags', 2, ''),
(101, 45, 42, 'Tea Bags', 2, ''),
(102, 46, 42, 'Tea Bags', 2, ''),
(103, 47, 42, 'Tea Bags', 2, ''),
(104, 54, 28, 'Tomato Sauce', 0.2, ''),
(105, 55, 28, 'Tomato Sauce', 0.2, ''),
(106, 56, 28, 'Tomato Sauce', 0.2, ''),
(108, 58, 24, 'Tomatoes', 0.2, ''),
(109, 59, 24, 'Tomatoes', 0.2, ''),
(110, 60, 24, 'Tomatoes', 0.2, ''),
(111, 48, 35, 'Whipped Cream', 0.2, ''),
(112, 49, 35, 'Whipped Cream', 0.2, ''),
(113, 50, 35, 'Whipped Cream', 0.2, ''),
(114, 51, 35, 'Whipped Cream', 0.2, ''),
(115, 52, 35, 'Whipped Cream', 0.2, ''),
(116, 53, 35, 'Whipped Cream', 0.2, ''),
(132, 58, 20, 'Beef Patty', 1, ''),
(133, 58, 19, 'Burger Buns', 1, ''),
(134, 58, 21, 'Cheese Slices', 1, ''),
(135, 58, 26, 'Ketchup', 0.03, ''),
(136, 58, 23, 'Lettuce', 0.2, ''),
(137, 58, 25, 'Mayo', 0.03, ''),
(138, 58, 22, 'Potatoes', 0.2, ''),
(139, 58, 24, 'Tomatoes', 0.2, ''),
(140, 59, 20, 'Beef Patty', 1, ''),
(141, 59, 19, 'Burger Buns', 1, ''),
(142, 59, 21, 'Cheese Slices', 1, ''),
(143, 59, 26, 'Ketchup', 0.03, ''),
(144, 59, 23, 'Lettuce', 0.2, ''),
(145, 59, 25, 'Mayo', 0.03, ''),
(146, 59, 22, 'Potatoes', 0.2, ''),
(147, 59, 24, 'Tomatoes', 0.2, ''),
(148, 60, 20, 'Beef Patty', 1, ''),
(149, 60, 19, 'Burger Buns', 1, ''),
(150, 60, 21, 'Cheese Slices', 1, ''),
(151, 60, 26, 'Ketchup', 0.03, ''),
(152, 60, 23, 'Lettuce', 0.2, ''),
(153, 60, 25, 'Mayo', 0.03, ''),
(154, 60, 22, 'Potatoes', 0.2, ''),
(155, 60, 24, 'Tomatoes', 0.2, ''),
(164, 65, 47, 'Cooking Oil', 5, 'liters'),
(165, 65, 22, 'Potatoes', 5, 'kilograms'),
(166, 56, 50, 'dough', 1, 'pieces'),
(170, 70, 53, 'test', 2, 'pieces'),
(181, 71, 53, 'test', 8, 'kilograms');

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `receipt_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `generated_at` datetime(6) NOT NULL,
  `total_amount` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`receipt_id`, `order_id`, `generated_at`, `total_amount`) VALUES
(19, 28, '2024-11-19 08:48:35.000000', 15),
(20, 28, '2024-11-19 08:48:36.000000', 15),
(21, 29, '2024-11-19 09:22:46.000000', 179),
(22, 29, '2024-11-19 09:22:46.000000', 179),
(23, 30, '2024-11-19 09:23:40.000000', 8950),
(24, 30, '2024-11-19 09:23:40.000000', 8950),
(25, 31, '2024-11-19 13:13:12.000000', 587),
(26, 31, '2024-11-19 13:13:12.000000', 587),
(27, 32, '2024-11-26 16:44:25.000000', 229),
(28, 32, '2024-11-26 16:44:26.000000', 229),
(29, 33, '2024-11-29 15:37:15.000000', 5713),
(30, 33, '2024-11-29 15:37:16.000000', 5713),
(31, 34, '2024-11-29 15:53:03.000000', 5000),
(32, 34, '2024-11-29 15:53:03.000000', 5000),
(33, 35, '2024-11-29 16:42:51.000000', 399),
(34, 35, '2024-11-29 16:42:51.000000', 399),
(35, 36, '2024-11-29 16:44:54.000000', 408),
(36, 36, '2024-11-29 16:44:54.000000', 408),
(37, 37, '2024-11-30 09:45:34.000000', 229),
(38, 37, '2024-11-30 09:45:34.000000', 229),
(39, 38, '2024-12-02 09:06:35.000000', 179),
(40, 39, '2024-12-02 09:20:15.000000', 407),
(41, 40, '2024-12-02 09:24:19.000000', 179),
(42, 41, '2024-12-02 10:34:15.000000', 100),
(43, 42, '2024-12-02 11:37:32.000000', 246),
(44, 43, '2024-12-02 13:54:39.000000', 246);

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `total_sales` float NOT NULL,
  `sales_date` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sale_id`, `order_id`, `total_sales`, `sales_date`, `user_id`) VALUES
(17, 28, 15, '2024-11-19 08:48:36.000000', 1),
(18, 29, 179, '2024-11-19 09:22:46.000000', 1),
(19, 30, 8950, '2024-11-19 09:23:40.000000', 1),
(20, 31, 587, '2024-11-19 13:13:12.000000', 1),
(21, 32, 229, '2024-11-26 16:44:25.000000', 1),
(22, 33, 5713, '2024-11-29 15:37:16.000000', 1),
(23, 34, 5000, '2024-11-29 15:53:03.000000', 1),
(24, 35, 399, '2024-11-29 16:42:51.000000', 1),
(25, 36, 408, '2024-11-29 16:44:54.000000', 4),
(26, 37, 229, '2024-11-30 09:45:34.000000', 1),
(27, 38, 179, '2024-12-02 09:06:35.000000', 1),
(28, 39, 407, '2024-12-02 09:20:15.000000', 1),
(29, 40, 179, '2024-12-02 09:24:18.000000', 1),
(30, 41, 100, '2024-12-02 10:34:15.000000', 1),
(31, 42, 246, '2024-12-02 11:37:32.000000', 1),
(32, 43, 246, '2024-12-02 13:54:39.000000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_acc`
--

CREATE TABLE `user_acc` (
  `User_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_acc`
--

INSERT INTO `user_acc` (`User_id`, `username`, `password`, `role`) VALUES
(1, 'admin', '$2y$10$/mZoUSDLsZRD/YXcvvlxS.7YQ5F.yt7mCtWjqlRZOb3BVuAbw13EG', 1),
(2, 'admin1', '$2y$10$klQVrS4bOo.luLJyIGDUMu7ps6w24o7dZD039IvjXE6TbC/ISbHNm', 1),
(3, 'admin2', '$2y$10$g94zqr7GiGuf4AycQeWrUuxkmSQBR11vblOdl9nSeSiTqY.8hHcHO', 1),
(4, 'staff1', '$2y$10$dztoSfznH4AdUBGHq2V4pOVucey92OY.Sr2Gtrwi.XOmtwEB21KIG', 0),
(5, 'staff2', '$2y$10$zwXssga5L1NVVg4scxWGV.EKJ3bAj53mwAh5BExJfoP/jz7kgKge2', 0),
(6, 'test2', '$2y$10$Gk3Lx76/7p4Wg8/Z/2EZDOzZ3u61btjIuE0VbzCEym6o0tUp0b8OG', 0),
(7, 'hiztest', '$2y$10$4.SZMCX.uiPJy2thgxhzS./s6l8I85M7b80qeDBmuKnrGczO7Tzbq', 0),
(8, 'hiztest1', '$2y$10$pIlsMI0vhAX/iyZkbCu3h.NO86hdO8S4Ma2Jv2qUVCwLNvKagat3y', 0),
(9, 'admin4', '$2y$10$ROueso1fSffgyPMfcmj0SOl2pVEzgfWbgdSnRhuntGoTSs8c.3Uyu', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `archived_sales`
--
ALTER TABLE `archived_sales`
  ADD PRIMARY KEY (`archive_id`),
  ADD KEY `archived_by` (`archived_by`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`inventory_id`),
  ADD KEY `inventory_ibfk_1` (`user_id`),
  ADD KEY `idx_item_name` (`item_name`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `order_ibfk_1` (`user_id`);

--
-- Indexes for table `order_item`
--
ALTER TABLE `order_item`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `product_ingredients`
--
ALTER TABLE `product_ingredients`
  ADD PRIMARY KEY (`product_ingredient_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `inventory_id` (`inventory_id`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`receipt_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `sales_ibfk_1` (`user_id`);

--
-- Indexes for table `user_acc`
--
ALTER TABLE `user_acc`
  ADD PRIMARY KEY (`User_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `archived_sales`
--
ALTER TABLE `archived_sales`
  MODIFY `archive_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `order_item`
--
ALTER TABLE `order_item`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `product_ingredients`
--
ALTER TABLE `product_ingredients`
  MODIFY `product_ingredient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `user_acc`
--
ALTER TABLE `user_acc`
  MODIFY `User_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `archived_sales`
--
ALTER TABLE `archived_sales`
  ADD CONSTRAINT `archived_sales_ibfk_1` FOREIGN KEY (`archived_by`) REFERENCES `user_acc` (`User_id`);

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user_acc` (`User_id`);

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_acc` (`User_id`),
  ADD CONSTRAINT `order_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);

--
-- Constraints for table `order_item`
--
ALTER TABLE `order_item`
  ADD CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  ADD CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

--
-- Constraints for table `product_ingredients`
--
ALTER TABLE `product_ingredients`
  ADD CONSTRAINT `product_ingredients_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  ADD CONSTRAINT `product_ingredients_ibfk_2` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`);

--
-- Constraints for table `receipt`
--
ALTER TABLE `receipt`
  ADD CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_acc` (`User_id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
