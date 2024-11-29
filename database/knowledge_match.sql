/*M!999999\- enable the sandbox mode */
-- MariaDB dump 10.19  Distrib 10.5.26-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: knowledge_match
-- ------------------------------------------------------
-- Server version       10.5.26-MariaDB-0+deb11u2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Keyword`
--

DROP TABLE IF EXISTS `Keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Keyword` (
  `K_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Levels` int(11) DEFAULT NULL,
  `Keyword` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`K_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Keyword2Topic`
--

DROP TABLE IF EXISTS `Keyword2Topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Keyword2Topic` (
  `K_ID` int(11) NOT NULL,
  `T_ID` int(11) NOT NULL,
  PRIMARY KEY (`K_ID`,`T_ID`),
  KEY `T_ID` (`T_ID`),
  CONSTRAINT `Keyword2Topic_ibfk_1` FOREIGN KEY (`K_ID`) REFERENCES `Keyword` (`K_ID`),
  CONSTRAINT `Keyword2Topic_ibfk_2` FOREIGN KEY (`T_ID`) REFERENCES `Topic` (`T_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Token`
--

DROP TABLE IF EXISTS `Token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Token` (
  `Token_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Token` varchar(255) NOT NULL,
  `U_ID` varchar(255) NOT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`Token_ID`),
  UNIQUE KEY `U_ID` (`U_ID`,`Token`)
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Topic`
--

DROP TABLE IF EXISTS `Topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Topic` (
  `T_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Levels` int(11) DEFAULT NULL,
  `Topic` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`T_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `U_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Surname` varchar(100) NOT NULL,
  `Reachability` int(11) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `Picture` longblob DEFAULT NULL,
  `Seniority` int(11) DEFAULT 0,
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`U_ID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `User2Keyword`
--

DROP TABLE IF EXISTS `User2Keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User2Keyword` (
  `U_ID` int(11) NOT NULL,
  `K_ID` int(11) NOT NULL,
  PRIMARY KEY (`U_ID`,`K_ID`),
  KEY `K_ID` (`K_ID`),
  CONSTRAINT `User2Keyword_ibfk_2` FOREIGN KEY (`K_ID`) REFERENCES `Keyword` (`K_ID`),
  CONSTRAINT `fk_user2keyword_user` FOREIGN KEY (`U_ID`) REFERENCES `User` (`U_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `User2Topic`
--

DROP TABLE IF EXISTS `User2Topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User2Topic` (
  `U_ID` int(11) NOT NULL,
  `T_ID` int(11) NOT NULL,
  PRIMARY KEY (`U_ID`,`T_ID`),
  KEY `T_ID` (`T_ID`),
  CONSTRAINT `User2Topic_ibfk_2` FOREIGN KEY (`T_ID`) REFERENCES `Topic` (`T_ID`),
  CONSTRAINT `fk_user2topic_user` FOREIGN KEY (`U_ID`) REFERENCES `User` (`U_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-29 13:01:12