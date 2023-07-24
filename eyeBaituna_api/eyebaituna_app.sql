-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 11, 2023 at 10:03 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eyebaituna_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `banned_urls`
--

CREATE TABLE `banned_urls` (
  `id` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `banned_urls`
--

INSERT INTO `banned_urls` (`id`, `url`, `user_id`) VALUES
(28, 'pls.com', 103),
(29, 'exampleuser.com', 103),
(30, 'block.com', 109),
(31, 'www.facebook.com', 103),
(33, 'virus.com', 103),
(34, 'www.malwaresite2.com', 103),
(35, 'www.malwaresite1.com', 103),
(37, 'www.adultsite2.com', 103);

-- --------------------------------------------------------

--
-- Table structure for table `categories_table`
--

CREATE TABLE `categories_table` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `categories_table`
--

INSERT INTO `categories_table` (`category_id`, `category_name`) VALUES
(1, 'News'),
(2, 'Pornography'),
(3, 'Social'),
(4, 'Search Engine'),
(5, 'Malicious');

-- --------------------------------------------------------

--
-- Table structure for table `connected_devices`
--

CREATE TABLE `connected_devices` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `device_name` varchar(50) DEFAULT NULL,
  `bandwidth_limit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `connected_devices`
--

INSERT INTO `connected_devices` (`id`, `user_id`, `device_name`, `bandwidth_limit`) VALUES
(1, 103, 'Device 1', 1111),
(2, 103, 'Device 2', 2321),
(3, 103, 'Device 3', 4444),
(4, 103, 'Device 4', 5000),
(5, 103, 'Device 5', 6666),
(6, 109, 'Device 1', 5000),
(7, 109, 'Device 2', 5000),
(8, 109, 'Device 3', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `internet_switch`
--

CREATE TABLE `internet_switch` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `switch_status` enum('off','on') NOT NULL DEFAULT 'off',
  `switch_value` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `internet_switch`
--

INSERT INTO `internet_switch` (`id`, `user_id`, `switch_status`, `switch_value`) VALUES
(1, 103, 'off', 0),
(2, 109, 'off', 0);

-- --------------------------------------------------------

--
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `schedule`
--

INSERT INTO `schedule` (`id`, `user_id`, `start_date`, `end_date`) VALUES
(1, 103, '2023-07-10 12:45:00', '2023-07-10 13:45:00'),
(2, 109, '2023-07-10 12:19:00', '2023-07-12 12:19:00'),
(3, 110, '2023-07-04 12:32:00', '2023-07-05 12:32:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `pincode` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `pincode`) VALUES
(99, 'majd', 'alali@majd.com', '$2y$10$nQMdSHrzNMU9NFsFfAaURe.QnMMT/g1iFoBBe0rMIjGkQNEcK0uUy', NULL),
(100, 'test', 'alali@test.com', '$2y$10$Ce14/ICamyiJcoX2sOggF.6/m6AvyFeXJoCzXmMSxDn/PwO.3FCLu', NULL),
(101, 'majd', 'alal1i@majd.com', '$2y$10$IX2.s6NMgkJUbHTKqW3wU.Z79kXe30bnrJ/djbG11ZxNy7DUFiXiK', NULL),
(102, 'majd aalali', 'm@majd.com', '$2y$10$kShkDnikqXdhSOgI7i0FuO6okZ78o7L0jgY4guuOV.WAhdXiCxcWe', NULL),
(103, 'Admin Majd', 'admin@mail.com', '$2y$10$cHl6GxVVo8begoZdgzLqge9rRM/WJAkBo7Y3a6T0LpoSqVoP2VjHS', 123333),
(104, 'majd alali', 'majd@hotmail.com', '$2y$10$vt5S6AaEC8..ZRshgI2QEOizgmz1l/hUbclXfuNQUBRMRyiN.P3U.', NULL),
(105, 'Majd Alali', 'majd2@hotmail.com', '$2y$10$TR9yy2yW48wZRj.DQE4KE.mC8LsWOUqtHtrEvVYvlcL4Qb5Rj/JGO', NULL),
(106, 'Test DemoTwo', 'demo@mail.com', '$2y$10$I3Y6LgRQ.aQT1WPFPURi2.zhwL71c06RzaOSLMISdvd5xuWXUlxsq', NULL),
(107, 'majd', 'admin1@mail.com', '$2y$10$H19oCrMdz9EWWiSTtxVRbespSQeXlhx75xnqpqvrdVd82lu4jnE52', NULL),
(108, 'Majd Demo', 'demo2@mail.com', '$2y$10$Qd7VwsY/AD7GCk.XGy.Rx.yvMZzRBHZfsx14xZd.WvSJHj6maaRPu', NULL),
(109, 'Tester', 'admin2@mail.com', '$2y$10$BtK1URa2LPGCjqlPzhHA3.l1symYXGgu1g0iwQaB/d29OSQMoe1c6', 555444),
(110, 'Majd', 'admin3@mail.com', '$2y$10$aiSFNwA5GqrLxEA1CU08TOn3q9NhV0p812fUUSodWVKzBmvpCAznq', 343434),
(111, 'pin', 'pin@mail.com', '$2y$10$y.25nccLIBweDDkcNMpO.O9hLw63DDxAGX/.1kkH60JBLjsNWAGva', 666666);

-- --------------------------------------------------------

--
-- Table structure for table `visited_websites`
--

CREATE TABLE `visited_websites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `link` varchar(255) NOT NULL,
  `visit_time` datetime NOT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `visited_websites`
--

INSERT INTO `visited_websites` (`id`, `user_id`, `link`, `visit_time`, `category_id`) VALUES
(1, 103, 'https://www.google.com', '2023-05-01 12:00:00', 4),
(2, 103, 'https://www.facebook.com', '2023-05-02 09:30:00', 3),
(3, 103, 'https://www.youtube.com', '2023-05-03 14:15:00', 3),
(4, 103, 'https://www.twitter.com', '2023-05-04 16:45:00', 3),
(5, 103, 'https://www.instagram.com', '2023-05-05 10:00:00', 3),
(6, 103, 'https://www.linkedin.com', '2023-05-06 11:30:00', 3),
(7, 103, 'https://www.amazon.com', '2023-05-07 13:45:00', 3),
(8, 103, 'https://www.netflix.com', '2023-05-08 15:20:00', 3),
(9, 109, 'https://www.apple.com', '2023-05-01 12:00:00', 3),
(10, 109, 'https://www.microsoft.com', '2023-05-02 09:30:00', 3),
(11, 109, 'https://www.yahoo.com', '2023-05-03 14:15:00', 4),
(12, 109, 'https://www.amazon.com', '2023-05-04 16:45:00', 3),
(13, 109, 'https://www.wikipedia.org', '2023-05-05 10:00:00', 3),
(14, 109, 'https://www.ebay.com', '2023-05-06 11:30:00', 3),
(15, 103, 'https://www.etsy.com', '2023-07-11 11:32:01', 3),
(16, 103, 'https://www.reddit.com', '2023-07-11 11:32:01', 3),
(17, 103, 'https://www.stackoverflow.com', '2023-07-11 11:32:01', 3),
(18, 103, 'https://www.netflix.com', '2023-07-11 11:32:01', 3),
(19, 103, 'https://www.pinterest.com', '2023-07-11 11:32:01', 3),
(20, 103, 'www.google.com', '2023-07-11 11:58:23', 4),
(21, 103, 'www.google.com', '2023-07-11 11:58:23', 4),
(22, 103, 'www.google.com', '2023-07-11 11:58:23', 4),
(23, 103, 'www.google.com', '2023-07-11 11:58:23', 4),
(24, 103, 'www.google.com', '2023-07-11 11:58:23', 4),
(25, 103, 'www.youtube.com', '2023-07-11 11:58:23', 3),
(26, 103, 'www.youtube.com', '2023-07-11 11:58:23', 3),
(27, 103, 'www.youtube.com', '2023-07-11 11:58:23', 3),
(28, 103, 'www.youtube.com', '2023-07-11 11:58:23', 3),
(29, 103, 'www.youtube.com', '2023-07-11 11:58:23', 3),
(30, 103, 'www.facebook.com', '2023-07-11 11:58:23', 3),
(31, 103, 'www.facebook.com', '2023-07-11 11:58:23', 3),
(32, 103, 'www.facebook.com', '2023-07-11 11:58:23', 3),
(33, 103, 'www.facebook.com', '2023-07-11 11:58:23', 3),
(34, 103, 'www.facebook.com', '2023-07-11 11:58:23', 3),
(35, 103, 'www.youtube.com', '2023-07-11 11:58:57', 3),
(36, 103, 'www.youtube.com', '2023-07-11 11:58:57', 3),
(37, 103, 'www.youtube.com', '2023-07-11 11:58:57', 3),
(38, 103, 'www.youtube.com', '2023-07-11 11:58:57', 3),
(39, 103, 'www.youtube.com', '2023-07-11 11:58:57', 3),
(42, 103, 'www.youtube.com', '2023-07-11 11:59:31', 3),
(43, 103, 'www.youtube.com', '2023-07-11 11:59:31', 3),
(44, 103, 'www.youtube.com', '2023-07-11 11:59:31', 3),
(45, 103, 'www.youtube.com', '2023-07-11 11:59:31', 3),
(46, 103, 'www.youtube.com', '2023-07-11 11:59:31', 3),
(49, 103, 'www.cnn.com', '2023-07-11 14:51:31', 1),
(50, 103, 'www.bbc.com', '2023-07-11 14:51:31', 1),
(51, 103, 'www.nytimes.com', '2023-07-11 14:51:31', 1),
(52, 103, 'www.adultsite1.com', '2023-07-11 14:51:31', 2),
(53, 103, 'www.adultsite2.com', '2023-07-11 14:51:31', 2),
(54, 103, 'www.adultsite3.com', '2023-07-11 14:51:31', 2),
(55, 103, 'www.facebook.com', '2023-07-11 14:51:31', 3),
(56, 103, 'www.instagram.com', '2023-07-11 14:51:31', 3),
(57, 103, 'www.twitter.com', '2023-07-11 14:51:31', 3),
(58, 103, 'www.google.com', '2023-07-11 14:51:31', 4),
(59, 103, 'www.yahoo.com', '2023-07-11 14:51:31', 4),
(60, 103, 'www.bing.com', '2023-07-11 14:51:31', 4),
(61, 103, 'www.malwaresite1.com', '2023-07-11 14:51:31', 5),
(62, 103, 'www.malwaresite2.com', '2023-07-11 14:51:31', 5),
(63, 103, 'www.malwaresite3.com', '2023-07-11 14:51:31', 5);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `banned_urls`
--
ALTER TABLE `banned_urls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `categories_table`
--
ALTER TABLE `categories_table`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `connected_devices`
--
ALTER TABLE `connected_devices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `internet_switch`
--
ALTER TABLE `internet_switch`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `visited_websites`
--
ALTER TABLE `visited_websites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `banned_urls`
--
ALTER TABLE `banned_urls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `connected_devices`
--
ALTER TABLE `connected_devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `internet_switch`
--
ALTER TABLE `internet_switch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `schedule`
--
ALTER TABLE `schedule`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT for table `visited_websites`
--
ALTER TABLE `visited_websites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `banned_urls`
--
ALTER TABLE `banned_urls`
  ADD CONSTRAINT `banned_urls_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `connected_devices`
--
ALTER TABLE `connected_devices`
  ADD CONSTRAINT `connected_devices_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `internet_switch`
--
ALTER TABLE `internet_switch`
  ADD CONSTRAINT `internet_switch_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `visited_websites`
--
ALTER TABLE `visited_websites`
  ADD CONSTRAINT `visited_websites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
