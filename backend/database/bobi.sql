-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 29, 2021 at 01:21 PM
-- Server version: 5.5.64-MariaDB
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bobi`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity`
--

CREATE TABLE IF NOT EXISTS `activity` (
  `activityId` int(11) NOT NULL,
  `startTime` timestamp NULL DEFAULT NULL,
  `endTime` timestamp NULL DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `forecastId` int(11) NOT NULL,
  `locationId` int(11) NOT NULL,
  `categoryId` int(11) DEFAULT NULL,
  `activityStatusId` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `activity`
--

INSERT INTO `activity` (`activityId`, `startTime`, `endTime`, `title`, `description`, `forecastId`, `locationId`, `categoryId`, `activityStatusId`, `created_at`, `type`) VALUES
(1, '2021-01-30 17:00:00', '2021-01-30 19:00:00', 'Dinner', 'Dinner for two', 1, 1, 1, 1, '2021-01-28 12:07:07', 3),
(2, '2021-02-01 09:00:00', '2021-02-01 11:00:00', 'DM store', 'Buy everything', 2, 2, 7, 1, '2021-01-28 12:07:49', 3),
(3, '2021-01-30 06:00:00', '2021-01-30 19:00:00', 'Hanging out with girl', 'Netflix & Chill ;)', 3, 3, 4, 1, '2021-01-28 12:08:58', 3),
(4, '2021-01-28 04:00:00', '2021-01-28 17:00:00', 'AIR', 'Learning for exam', 4, 4, 6, 3, '2021-01-28 12:10:17', 3),
(5, '2021-01-30 16:00:00', '2021-01-30 21:00:00', 'Games', 'Playing games with family', 5, 5, 3, 1, '2021-01-28 12:11:39', 3),
(7, '2021-01-29 04:00:00', '2021-01-29 17:00:00', 'Presenting App', 'Preseting final App :)', 7, 7, 6, 2, '2021-01-28 12:17:08', 3),
(8, '2021-02-04 16:00:00', '2021-02-04 17:00:00', 'Gaming with boys', 'Gaming CS:GO with the bois', 8, 8, 8, 1, '2021-01-28 12:17:56', 3),
(9, '2021-01-31 16:00:00', '2021-01-31 17:00:00', 'Playing football', 'TTS football', 9, 9, 2, 1, '2021-01-28 12:18:37', 3),
(10, '2021-01-26 17:00:00', '2021-01-26 18:00:00', 'Private activity', 'Doing pushups', 10, 10, 2, 4, '2021-01-28 12:20:35', 3);

-- --------------------------------------------------------

--
-- Table structure for table `activitystatus`
--

CREATE TABLE IF NOT EXISTS `activitystatus` (
  `activityStatusId` int(11) NOT NULL,
  `statusType` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `activitystatus`
--

INSERT INTO `activitystatus` (`activityStatusId`, `statusType`) VALUES
(1, 'Future'),
(2, 'In progress'),
(3, 'Past'),
(4, 'Default');

-- --------------------------------------------------------

--
-- Table structure for table `avatar`
--

CREATE TABLE IF NOT EXISTS `avatar` (
  `avatarId` int(11) NOT NULL,
  `avatarName` varchar(100) NOT NULL,
  `path` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `avatar`
--

INSERT INTO `avatar` (`avatarId`, `avatarName`, `path`) VALUES
(1, 'avatar1', 'avatar1'),
(2, 'avatar2', 'avatar2'),
(3, 'avatar3', 'avatar3'),
(4, 'avatar4', 'avatar4'),
(5, 'avatar5', 'avatar5'),
(6, 'avatar6', 'avatar6'),
(7, 'avatar7', 'avatar7'),
(8, 'avatar8', 'avatar8'),
(9, 'avatar9', 'avatar9'),
(10, 'avatar10', 'avatar10');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE IF NOT EXISTS `category` (
  `categoryId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryId`, `name`) VALUES
(0, 'Uncategorized'),
(1, 'Food'),
(2, 'Sports'),
(3, 'Family'),
(4, 'Romance'),
(5, 'Business'),
(6, 'Studying'),
(7, 'Shopping'),
(8, 'Entertainment');

-- --------------------------------------------------------

--
-- Table structure for table `desiredforecast`
--

CREATE TABLE IF NOT EXISTS `desiredforecast` (
  `activityId` int(11) NOT NULL,
  `forecastTypeId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `desiredforecast`
--

INSERT INTO `desiredforecast` (`activityId`, `forecastTypeId`) VALUES
(1, 0),
(2, 0),
(3, 0),
(4, 0),
(5, 0),
(7, 0),
(8, 0),
(9, 0),
(10, 0);

-- --------------------------------------------------------

--
-- Table structure for table `doing`
--

CREATE TABLE IF NOT EXISTS `doing` (
  `mail` varchar(100) NOT NULL,
  `activityId` int(11) NOT NULL,
  `doingStatus` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `doing`
--

INSERT INTO `doing` (`mail`, `activityId`, `doingStatus`) VALUES
('admin', 1, 1),
('admin', 2, 1),
('admin', 3, 1),
('admin', 4, 1),
('admin', 5, 1),
('admin', 7, 1),
('admin', 8, 1),
('admin', 9, 1),
('admin', 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `forecast`
--

CREATE TABLE IF NOT EXISTS `forecast` (
  `forecastId` int(11) NOT NULL,
  `temperature` float DEFAULT NULL,
  `feelsLike` float DEFAULT NULL,
  `wind` double DEFAULT NULL,
  `humidity` float DEFAULT NULL,
  `forecastTypeId` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `forecast`
--

INSERT INTO `forecast` (`forecastId`, `temperature`, `feelsLike`, `wind`, `humidity`, `forecastTypeId`) VALUES
(1, 7.43, 4.17, 2.83, 80, 2),
(2, -1.25, -4.1, 0.93, 98, 1),
(3, 2.35, -0.19, 1.05, 92, 8),
(4, 4.28, -0.05, 2.73, 58, 2),
(5, 8.31, 5.01, 2.72, 72, 2),
(7, 2.99, -1.92, 4.15, 80, 2),
(8, 4.28, -0.05, 2.73, 58, 2),
(9, NULL, NULL, NULL, NULL, 0),
(10, 4.37, 0.15, 2.59, 58, 2);

-- --------------------------------------------------------

--
-- Table structure for table `forecasttype`
--

CREATE TABLE IF NOT EXISTS `forecasttype` (
  `forecastTypeId` int(11) NOT NULL,
  `forecastType` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `forecasttype`
--

INSERT INTO `forecasttype` (`forecastTypeId`, `forecastType`) VALUES
(0, 'None'),
(1, 'Sunny'),
(2, 'Cloudy'),
(3, 'SunCloudy'),
(4, 'Rainy'),
(5, 'Foggy'),
(6, 'Snowy'),
(7, 'Stormy'),
(8, 'Windy');

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

CREATE TABLE IF NOT EXISTS `location` (
  `locationId` int(11) NOT NULL,
  `locationName` varchar(255) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`locationId`, `locationName`, `latitude`, `longitude`) VALUES
(1, 'Ulica Vladimira Nazora 7A', 46.311181922627924, 16.33407540122255),
(2, 'Trg slobode 9A', 46.30595700575219, 16.33623477965341),
(3, 'Franjevački trg 10', 46.3076987, 16.335897),
(4, 'Franjevački trg 10', 46.3076987, 16.335897),
(5, 'Trg Stjepana Radića', 45.8011745, 15.9785517),
(7, 'Franjevački trg 10', 46.3076987, 16.335897),
(8, 'Franjevački trg 10', 46.3076987, 16.335897),
(9, NULL, NULL, NULL),
(10, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `remind`
--

CREATE TABLE IF NOT EXISTS `remind` (
  `mail` varchar(255) NOT NULL,
  `reminderId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `reminder`
--

CREATE TABLE IF NOT EXISTS `reminder` (
  `reminderId` int(11) NOT NULL,
  `reminderValue` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `mail` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `deviceToken` varchar(255) NOT NULL,
  `avatarId` int(11) NOT NULL,
  `sessionToken` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`mail`, `username`, `password`, `firstName`, `lastName`, `deviceToken`, `avatarId`, `sessionToken`) VALUES
('admin', 'admin', '$2b$10$x9FfaajHoyFHnSS/RhTJ9eHcFlv5KEBJNCLU58U4HZgIWBGc096Yi', 'Ivan', 'Ivić', '1', 10, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Iml2YW5AZ21haWwuY29tIiwidXNlcm5hbWUiOiJJdmVrIiwiaWF0IjoxNjExOTA2ODMyfQ.7nOKI_HSBuStLFhWRpr5hnc_2EF07VR5wgx9sfLfi1A');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity`
--
ALTER TABLE `activity`
  ADD PRIMARY KEY (`activityId`),
  ADD UNIQUE KEY `forecastId` (`forecastId`),
  ADD UNIQUE KEY `forecastId_2` (`forecastId`),
  ADD UNIQUE KEY `forecastId_3` (`forecastId`),
  ADD KEY `fk_activity_location` (`locationId`),
  ADD KEY `fk_activity_category` (`categoryId`),
  ADD KEY `fk_activity_activityStatus` (`activityStatusId`);

--
-- Indexes for table `activitystatus`
--
ALTER TABLE `activitystatus`
  ADD PRIMARY KEY (`activityStatusId`);

--
-- Indexes for table `avatar`
--
ALTER TABLE `avatar`
  ADD PRIMARY KEY (`avatarId`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryId`);

--
-- Indexes for table `desiredforecast`
--
ALTER TABLE `desiredforecast`
  ADD PRIMARY KEY (`activityId`,`forecastTypeId`),
  ADD KEY `fk_desiredForecast_forecastType` (`forecastTypeId`);

--
-- Indexes for table `doing`
--
ALTER TABLE `doing`
  ADD UNIQUE KEY `mail` (`mail`,`activityId`,`doingStatus`);

--
-- Indexes for table `forecast`
--
ALTER TABLE `forecast`
  ADD UNIQUE KEY `forecastId` (`forecastId`);

--
-- Indexes for table `forecasttype`
--
ALTER TABLE `forecasttype`
  ADD PRIMARY KEY (`forecastTypeId`);

--
-- Indexes for table `location`
--
ALTER TABLE `location`
  ADD UNIQUE KEY `locationId` (`locationId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD UNIQUE KEY `mail` (`mail`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity`
--
ALTER TABLE `activity`
  MODIFY `activityId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `forecast`
--
ALTER TABLE `forecast`
  MODIFY `forecastId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `location`
--
ALTER TABLE `location`
  MODIFY `locationId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
DELIMITER $$
--
-- Events
--
CREATE DEFINER=`bobi`@`%` EVENT `activityScheduler` ON SCHEDULE EVERY 15 MINUTE STARTS '2021-01-27 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

UPDATE activity SET activityStatusId = 2 WHERE startTime <= DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 HOUR) AND activityStatusId < 2;

UPDATE activity SET activityStatusId = 3 WHERE endTime <= DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 HOUR) AND activityStatusId < 3;

END$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
