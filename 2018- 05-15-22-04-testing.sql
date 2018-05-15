# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.6.38)
# Database: testing
# Generation Time: 2018-05-15 21:04:26 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table assetindexdata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assetindexdata`;

CREATE TABLE `assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) NOT NULL DEFAULT '',
  `volumeId` int(11) NOT NULL,
  `uri` text,
  `size` bigint(20) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `recordId` int(11) DEFAULT NULL,
  `inProgress` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assetindexdata_sessionId_volumeId_idx` (`sessionId`,`volumeId`),
  KEY `assetindexdata_volumeId_idx` (`volumeId`),
  CONSTRAINT `assetindexdata_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table assets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assets`;

CREATE TABLE `assets` (
  `id` int(11) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `kind` varchar(50) NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `focalPoint` varchar(13) DEFAULT NULL,
  `dateModified` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assets_filename_folderId_unq_idx` (`filename`,`folderId`),
  KEY `assets_folderId_idx` (`folderId`),
  KEY `assets_volumeId_idx` (`volumeId`),
  CONSTRAINT `assets_folderId_fk` FOREIGN KEY (`folderId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table assettransformindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assettransformindex`;

CREATE TABLE `assettransformindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assetId` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `fileExists` tinyint(1) NOT NULL DEFAULT '0',
  `inProgress` tinyint(1) NOT NULL DEFAULT '0',
  `dateIndexed` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assettransformindex_volumeId_assetId_location_idx` (`volumeId`,`assetId`,`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table assettransforms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assettransforms`;

CREATE TABLE `assettransforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `mode` enum('stretch','fit','crop') NOT NULL DEFAULT 'crop',
  `position` enum('top-left','top-center','top-right','center-left','center-center','center-right','bottom-left','bottom-center','bottom-right') NOT NULL DEFAULT 'center-center',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `quality` int(11) DEFAULT NULL,
  `interlace` enum('none','line','plane','partition') NOT NULL DEFAULT 'none',
  `dimensionChangeTime` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assettransforms_name_unq_idx` (`name`),
  UNIQUE KEY `assettransforms_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `categories_groupId_idx` (`groupId`),
  CONSTRAINT `categories_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categories_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table categorygroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `categorygroups`;

CREATE TABLE `categorygroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_name_unq_idx` (`name`),
  UNIQUE KEY `categorygroups_handle_unq_idx` (`handle`),
  KEY `categorygroups_structureId_idx` (`structureId`),
  KEY `categorygroups_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `categorygroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `categorygroups_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table categorygroups_sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `categorygroups_sites`;

CREATE TABLE `categorygroups_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_sites_groupId_siteId_unq_idx` (`groupId`,`siteId`),
  KEY `categorygroups_sites_siteId_idx` (`siteId`),
  CONSTRAINT `categorygroups_sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categorygroups_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table content
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content`;

CREATE TABLE `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `content_siteId_idx` (`siteId`),
  KEY `content_title_idx` (`title`),
  CONSTRAINT `content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `content` WRITE;
/*!40000 ALTER TABLE `content` DISABLE KEYS */;

INSERT INTO `content` (`id`, `elementId`, `siteId`, `title`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,NULL,'2018-04-23 17:28:21','2018-04-23 17:28:21','ec787f8c-b2c8-4b28-9fa6-e44fa2a154c7'),
	(2,2,1,'A New Toga','2018-04-23 17:30:25','2018-05-02 11:57:49','332b3fbc-00bd-4434-9d39-1fe573c251ed'),
	(3,3,1,'A New Toga','2018-04-23 17:30:25','2018-05-02 11:57:49','2c572501-63f4-4564-9af3-7226ec50622b'),
	(4,4,1,'Parka With Stripes On Back','2018-04-23 17:30:25','2018-05-02 11:59:49','87119b82-01f8-4595-a93f-dfb82c8123fc'),
	(5,5,1,'Parka With Stripes On Back','2018-04-23 17:30:25','2018-05-02 11:59:49','b9d0a1c4-735c-47a8-9999-35968eebe2a0'),
	(6,6,1,'Romper For A Red Eye','2018-04-23 17:30:25','2018-05-02 11:57:49','f3b91446-d1fe-4888-9084-2de3903616a3'),
	(7,7,1,'Romper For A Red Eye','2018-04-23 17:30:25','2018-05-02 11:57:49','e60d5d70-0145-4707-8ef2-503bd012caa1'),
	(8,8,1,'The Fleece Awakens','2018-04-23 17:30:25','2018-05-02 11:57:49','9b3a886b-b371-434a-8a93-4ab36f1f0753'),
	(9,9,1,'The Fleece Awakens','2018-04-23 17:30:25','2018-05-02 11:57:49','3ed3677d-3936-4bd5-87d7-a10a7017caa7'),
	(10,10,1,'The Last Knee-High','2018-04-23 17:30:25','2018-05-02 11:57:49','56880e2b-c90a-45c4-bcaf-af301ec0696b'),
	(11,11,1,'The Last Knee-High','2018-04-23 17:30:25','2018-05-02 11:57:49','a8802692-2c52-4830-9365-fb36594d8551'),
	(12,12,1,NULL,'2018-04-27 11:35:28','2018-04-27 11:35:33','6a3ffc17-151f-4ea0-9eb7-b34309f7b65b'),
	(13,13,1,NULL,'2018-04-27 11:35:44','2018-04-27 11:35:44','e06f30a4-2d05-4440-903a-f6df0663072b'),
	(14,14,1,NULL,'2018-04-27 13:45:13','2018-04-27 13:48:44','bc2522b1-a255-4f8f-b96b-24c16db47915'),
	(15,15,1,NULL,'2018-04-27 13:59:23','2018-04-27 13:59:23','7e1bc575-c754-49bc-a508-60c38cfea45e'),
	(16,16,1,'Parka With Stripes On Back','2018-05-02 11:59:12','2018-05-02 11:59:49','134a9b6c-de37-4650-80a8-5dd69418f232'),
	(17,17,1,'Home Page','2018-05-15 20:16:26','2018-05-15 20:16:26','34db5d6f-669b-4ffe-95cd-099c8d5dd7f4'),
	(18,18,1,'Pricing','2018-05-15 20:16:41','2018-05-15 20:16:41','27c7eb9d-1be8-4164-8b9c-dc465cde3bd1');

/*!40000 ALTER TABLE `content` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craftidtokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craftidtokens`;

CREATE TABLE `craftidtokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `accessToken` text NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craftidtokens_userId_fk` (`userId`),
  CONSTRAINT `craftidtokens_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table deprecationerrors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deprecationerrors`;

CREATE TABLE `deprecationerrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `fingerprint` varchar(255) NOT NULL,
  `lastOccurrence` datetime NOT NULL,
  `file` varchar(255) NOT NULL,
  `line` smallint(6) unsigned DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `traces` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `deprecationerrors_key_fingerprint_unq_idx` (`key`,`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `deprecationerrors` WRITE;
/*!40000 ALTER TABLE `deprecationerrors` DISABLE KEYS */;

INSERT INTO `deprecationerrors` (`id`, `key`, `fingerprint`, `lastOccurrence`, `file`, `line`, `message`, `traces`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'craft.request.getSegments()','/Users/rosana/01_My_projects/testing-site/templates/_base.twig:16','2018-05-15 20:26:01','/Users/rosana/01_My_projects/testing-site/templates/_base.twig',16,'craft.request.getSegments() has been deprecated. Use craft.app.request.segments instead.','[{\"objectClass\":\"craft\\\\services\\\\Deprecator\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/twig/variables/Request.php\",\"line\":153,\"class\":\"craft\\\\services\\\\Deprecator\",\"method\":\"log\",\"args\":\"\\\"craft.request.getSegments()\\\", \\\"craft.request.getSegments() has been deprecated. Use craft.app.r...\\\"\"},{\"objectClass\":\"craft\\\\web\\\\twig\\\\variables\\\\Request\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/twig/twig/lib/Twig/Extension/Core.php\",\"line\":1605,\"class\":\"craft\\\\web\\\\twig\\\\variables\\\\Request\",\"method\":\"getSegments\",\"args\":null},{\"objectClass\":null,\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/helpers/Template.php\",\"line\":73,\"class\":null,\"method\":\"twig_get_attribute\",\"args\":\"craft\\\\web\\\\twig\\\\Environment, Twig_Source, craft\\\\web\\\\twig\\\\variables\\\\Request, \\\"segments\\\", ...\"},{\"objectClass\":null,\"file\":\"/Users/rosana/01_My_projects/testing-site/storage/runtime/compiled_templates/d3/d39ac0c5f1db7541edc4a15527f46f4baeced51168d45c84480e6930c5bea314.php\",\"line\":55,\"class\":\"craft\\\\helpers\\\\Template\",\"method\":\"attribute\",\"args\":\"craft\\\\web\\\\twig\\\\Environment, Twig_Source, craft\\\\web\\\\twig\\\\variables\\\\Request, \\\"segments\\\", ...\"},{\"objectClass\":\"__TwigTemplate_b2dd0c150ade33470dac8c3a598524a286ce35fcc953fa7fffc0982374df9030\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/twig/twig/lib/Twig/Template.php\",\"line\":390,\"class\":\"__TwigTemplate_b2dd0c150ade33470dac8c3a598524a286ce35fcc953fa7fffc0982374df9030\",\"method\":\"doDisplay\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b2dd0c150ade33470dac8c3a598524a286ce35fcc953fa7fffc0982374df9030\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/twig/Template.php\",\"line\":49,\"class\":\"Twig_Template\",\"method\":\"displayWithErrorHandling\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b2dd0c150ade33470dac8c3a598524a286ce35fcc953fa7fffc0982374df9030\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/twig/twig/lib/Twig/Template.php\",\"line\":367,\"class\":\"craft\\\\web\\\\twig\\\\Template\",\"method\":\"displayWithErrorHandling\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b2dd0c150ade33470dac8c3a598524a286ce35fcc953fa7fffc0982374df9030\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/twig/Template.php\",\"line\":31,\"class\":\"Twig_Template\",\"method\":\"display\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b2dd0c150ade33470dac8c3a598524a286ce35fcc953fa7fffc0982374df9030\",\"file\":\"/Users/rosana/01_My_projects/testing-site/storage/runtime/compiled_templates/51/512af1bbcf8ddd7e6462b939278e561df60623af935ec521f3764b8aa010ee11.php\",\"line\":28,\"class\":\"craft\\\\web\\\\twig\\\\Template\",\"method\":\"display\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/twig/twig/lib/Twig/Template.php\",\"line\":390,\"class\":\"__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6\",\"method\":\"doDisplay\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/twig/Template.php\",\"line\":49,\"class\":\"Twig_Template\",\"method\":\"displayWithErrorHandling\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/twig/twig/lib/Twig/Template.php\",\"line\":367,\"class\":\"craft\\\\web\\\\twig\\\\Template\",\"method\":\"displayWithErrorHandling\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\", \\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, ...], [\\\"body\\\" => [__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6, \\\"block_body\\\"]]\"},{\"objectClass\":\"__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/twig/Template.php\",\"line\":31,\"class\":\"Twig_Template\",\"method\":\"display\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"], []\"},{\"objectClass\":\"__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/twig/twig/lib/Twig/Template.php\",\"line\":375,\"class\":\"craft\\\\web\\\\twig\\\\Template\",\"method\":\"display\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]\"},{\"objectClass\":\"__TwigTemplate_b44fbcdda4bfdefb4b291b872e8a9686930a8a5bf588e2ef3a6b36f0f89673f6\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/twig/twig/lib/Twig/Environment.php\",\"line\":289,\"class\":\"Twig_Template\",\"method\":\"render\",\"args\":\"[\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\twig\\\\Environment\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/View.php\",\"line\":305,\"class\":\"Twig_Environment\",\"method\":\"render\",\"args\":\"\\\"pricing\\\", [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\View\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/View.php\",\"line\":352,\"class\":\"craft\\\\web\\\\View\",\"method\":\"renderTemplate\",\"args\":\"\\\"pricing\\\", [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\View\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/Controller.php\",\"line\":128,\"class\":\"craft\\\\web\\\\View\",\"method\":\"renderPageTemplate\",\"args\":\"\\\"pricing\\\", [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]\"},{\"objectClass\":\"craft\\\\controllers\\\\TemplatesController\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/controllers/TemplatesController.php\",\"line\":78,\"class\":\"craft\\\\web\\\\Controller\",\"method\":\"renderTemplate\",\"args\":\"\\\"pricing\\\", [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]\"},{\"objectClass\":\"craft\\\\controllers\\\\TemplatesController\",\"file\":null,\"line\":null,\"class\":\"craft\\\\controllers\\\\TemplatesController\",\"method\":\"actionRender\",\"args\":\"\\\"pricing\\\", [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]\"},{\"objectClass\":null,\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/yiisoft/yii2/base/InlineAction.php\",\"line\":57,\"class\":null,\"method\":\"call_user_func_array\",\"args\":\"[craft\\\\controllers\\\\TemplatesController, \\\"actionRender\\\"], [\\\"pricing\\\", [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"]]\"},{\"objectClass\":\"yii\\\\base\\\\InlineAction\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/yiisoft/yii2/base/Controller.php\",\"line\":157,\"class\":\"yii\\\\base\\\\InlineAction\",\"method\":\"runWithParams\",\"args\":\"[\\\"variables\\\" => [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"], \\\"template\\\" => \\\"pricing\\\", \\\"p\\\" => \\\"ai/pricing\\\"]\"},{\"objectClass\":\"craft\\\\controllers\\\\TemplatesController\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/Controller.php\",\"line\":76,\"class\":\"yii\\\\base\\\\Controller\",\"method\":\"runAction\",\"args\":\"\\\"render\\\", [\\\"variables\\\" => [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"], \\\"template\\\" => \\\"pricing\\\", \\\"p\\\" => \\\"ai/pricing\\\"]\"},{\"objectClass\":\"craft\\\\controllers\\\\TemplatesController\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/yiisoft/yii2/base/Module.php\",\"line\":528,\"class\":\"craft\\\\web\\\\Controller\",\"method\":\"runAction\",\"args\":\"\\\"render\\\", [\\\"variables\\\" => [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"], \\\"template\\\" => \\\"pricing\\\", \\\"p\\\" => \\\"ai/pricing\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/Application.php\",\"line\":273,\"class\":\"yii\\\\base\\\\Module\",\"method\":\"runAction\",\"args\":\"\\\"templates/render\\\", [\\\"variables\\\" => [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"], \\\"template\\\" => \\\"pricing\\\", \\\"p\\\" => \\\"ai/pricing\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/yiisoft/yii2/web/Application.php\",\"line\":103,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"runAction\",\"args\":\"\\\"templates/render\\\", [\\\"variables\\\" => [\\\"country_code\\\" => \\\"ai\\\", \\\"section_URI\\\" => \\\"pricing\\\"], \\\"template\\\" => \\\"pricing\\\", \\\"p\\\" => \\\"ai/pricing\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/craftcms/cms/src/web/Application.php\",\"line\":262,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"handleRequest\",\"args\":\"craft\\\\web\\\\Request\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/Users/rosana/01_My_projects/testing-site/vendor/yiisoft/yii2/base/Application.php\",\"line\":386,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"handleRequest\",\"args\":\"craft\\\\web\\\\Request\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/Users/rosana/01_My_projects/testing-site/web/index.php\",\"line\":21,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"run\",\"args\":null}]','2018-05-15 20:26:01','2018-05-15 20:26:01','74519db1-c0e1-4c1a-be3a-68739e0d6947');

/*!40000 ALTER TABLE `deprecationerrors` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table elementindexsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `elementindexsettings`;

CREATE TABLE `elementindexsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elementindexsettings_type_unq_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `elements`;

CREATE TABLE `elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `elements_fieldLayoutId_idx` (`fieldLayoutId`),
  KEY `elements_type_idx` (`type`),
  KEY `elements_enabled_idx` (`enabled`),
  KEY `elements_archived_dateCreated_idx` (`archived`,`dateCreated`),
  CONSTRAINT `elements_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `elements` WRITE;
/*!40000 ALTER TABLE `elements` DISABLE KEYS */;

INSERT INTO `elements` (`id`, `fieldLayoutId`, `type`, `enabled`, `archived`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'craft\\elements\\User',1,0,'2018-04-23 17:28:21','2018-04-23 17:28:21','fdc85ead-3a9e-44d5-8abe-1f122c5b3136'),
	(2,2,'craft\\commerce\\elements\\Product',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','958f431b-6d0f-4976-86d1-33320492f00b'),
	(3,3,'craft\\commerce\\elements\\Variant',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','c8a7491a-2552-46b4-9bb0-dab8175fb07d'),
	(4,2,'craft\\commerce\\elements\\Product',1,0,'2018-04-23 17:30:25','2018-05-02 11:59:49','bec843ba-ac59-40ba-82b4-0bb3af11442e'),
	(5,3,'craft\\commerce\\elements\\Variant',1,0,'2018-04-23 17:30:25','2018-05-02 11:59:49','137b0d0c-b9c2-45b3-9173-2d2da2cebcfc'),
	(6,2,'craft\\commerce\\elements\\Product',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','cdd5ca96-0ae1-4710-9818-581741775ff7'),
	(7,3,'craft\\commerce\\elements\\Variant',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','dc4c9904-b465-4e00-af8e-5cd57f8056d9'),
	(8,2,'craft\\commerce\\elements\\Product',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','a5dbfaab-f01b-4af7-8be7-f8a81c4b8a3c'),
	(9,3,'craft\\commerce\\elements\\Variant',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','e3be0bcc-3ab9-467d-b8b6-0f505b807983'),
	(10,2,'craft\\commerce\\elements\\Product',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','144bf422-5888-44fd-9119-b8aa8320557c'),
	(11,3,'craft\\commerce\\elements\\Variant',1,0,'2018-04-23 17:30:25','2018-05-02 11:57:49','680f060e-5710-41a7-ac00-9a6248ad1025'),
	(12,1,'craft\\commerce\\elements\\Order',1,0,'2018-04-27 11:35:28','2018-04-27 11:35:33','72c9c9cb-0a8e-4292-9a0b-f7a1e9544e09'),
	(13,1,'craft\\commerce\\elements\\Order',1,0,'2018-04-27 11:35:44','2018-04-27 11:35:44','28e3d0ea-330a-458b-8b45-7c103bd5e7e8'),
	(14,1,'craft\\commerce\\elements\\Order',1,0,'2018-04-27 13:45:13','2018-04-27 13:48:44','1c005e29-811e-4968-b013-1368d45804f0'),
	(15,1,'craft\\commerce\\elements\\Order',1,0,'2018-04-27 13:59:23','2018-04-27 13:59:23','aa15fa63-f3cc-4b4d-8eb5-44e3dad52faa'),
	(16,3,'craft\\commerce\\elements\\Variant',1,0,'2018-05-02 11:59:12','2018-05-02 11:59:49','0c537740-6414-4620-bf45-e37e49c9c9e3'),
	(17,4,'craft\\elements\\Entry',1,0,'2018-05-15 20:16:26','2018-05-15 20:16:26','4b0a7f47-e434-47af-b0c6-c048adf235bd'),
	(18,5,'craft\\elements\\Entry',1,0,'2018-05-15 20:16:41','2018-05-15 20:16:41','a5443c79-3ade-4473-998b-bc18bc86c698');

/*!40000 ALTER TABLE `elements` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table elements_sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `elements_sites`;

CREATE TABLE `elements_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elements_sites_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  UNIQUE KEY `elements_sites_uri_siteId_unq_idx` (`uri`,`siteId`),
  KEY `elements_sites_siteId_idx` (`siteId`),
  KEY `elements_sites_slug_siteId_idx` (`slug`,`siteId`),
  KEY `elements_sites_enabled_idx` (`enabled`),
  CONSTRAINT `elements_sites_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `elements_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `elements_sites` WRITE;
/*!40000 ALTER TABLE `elements_sites` DISABLE KEYS */;

INSERT INTO `elements_sites` (`id`, `elementId`, `siteId`, `slug`, `uri`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,NULL,NULL,1,'2018-04-23 17:28:21','2018-04-23 17:28:21','3c37e155-18a1-4264-8279-b61a60b2e971'),
	(2,2,1,'ant-001','shop/products/ant-001',1,'2018-04-23 17:30:25','2018-05-02 11:57:49','4c6be525-6a4b-426f-b47e-2c7dbc45f602'),
	(3,3,1,'ant-001',NULL,1,'2018-04-23 17:30:25','2018-05-02 11:57:49','43f2dcc4-bae9-4395-bcf6-15890785b3ea'),
	(4,4,1,'psb-001','shop/products/psb-001',1,'2018-04-23 17:30:25','2018-05-02 11:59:49','323b3842-f0a2-4d56-9c36-9cf230bfe45c'),
	(5,5,1,'psb-001',NULL,1,'2018-04-23 17:30:25','2018-05-02 11:59:49','9436f8ba-bc4c-4876-a87e-f569d0ecffb1'),
	(6,6,1,'rre-001','shop/products/rre-001',1,'2018-04-23 17:30:25','2018-05-02 11:57:49','69a772da-2e77-43ff-bfd3-927d1de9de77'),
	(7,7,1,'rre-001',NULL,1,'2018-04-23 17:30:25','2018-05-02 11:57:49','c6507f33-3ad7-4586-ac22-208b104fa101'),
	(8,8,1,'tfa-001','shop/products/tfa-001',1,'2018-04-23 17:30:25','2018-05-02 11:57:49','64ecf67a-1c95-43c9-9680-0a5923bbafc2'),
	(9,9,1,'tfa-001',NULL,1,'2018-04-23 17:30:25','2018-05-02 11:57:49','dbd7c914-35a8-44fe-af17-ab239a6b9a5b'),
	(10,10,1,'lkh-001','shop/products/lkh-001',1,'2018-04-23 17:30:25','2018-05-02 11:57:49','56d2b564-f51e-46e9-aae8-a7bdaa30d672'),
	(11,11,1,'lkh-001',NULL,1,'2018-04-23 17:30:25','2018-05-02 11:57:49','cf2652d5-8262-47eb-bd47-06e63fa2d359'),
	(12,12,1,NULL,NULL,1,'2018-04-27 11:35:28','2018-04-27 11:35:33','7bdbe939-f9df-4030-ba2f-c41c7c3428e5'),
	(13,13,1,NULL,NULL,1,'2018-04-27 11:35:44','2018-04-27 11:35:44','ab327965-71c2-4d60-8ba2-67283efa5dfb'),
	(14,14,1,NULL,NULL,1,'2018-04-27 13:45:13','2018-04-27 13:48:44','a3bc4bf1-17b0-4658-b860-ee2b2a87b6b9'),
	(15,15,1,NULL,NULL,1,'2018-04-27 13:59:23','2018-04-27 13:59:23','6b49a908-aa61-4a37-a36b-96cc72f6ed78'),
	(16,16,1,NULL,NULL,1,'2018-05-02 11:59:12','2018-05-02 11:59:49','47e11794-6a34-4c52-92cc-694c9c7cd61b'),
	(17,17,1,'home-page','__home__',1,'2018-05-15 20:16:26','2018-05-15 20:16:26','ce6d15f6-bfa4-44f4-9c97-2eb741882f47'),
	(18,18,1,'pricing','pricing',1,'2018-05-15 20:16:41','2018-05-15 20:16:41','31222d10-b9b6-4419-b1b8-84ee2d5945cc');

/*!40000 ALTER TABLE `elements_sites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table entries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entries`;

CREATE TABLE `entries` (
  `id` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entries_postDate_idx` (`postDate`),
  KEY `entries_expiryDate_idx` (`expiryDate`),
  KEY `entries_authorId_idx` (`authorId`),
  KEY `entries_sectionId_idx` (`sectionId`),
  KEY `entries_typeId_idx` (`typeId`),
  CONSTRAINT `entries_authorId_fk` FOREIGN KEY (`authorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `entrytypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `entries` WRITE;
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;

INSERT INTO `entries` (`id`, `sectionId`, `typeId`, `authorId`, `postDate`, `expiryDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(17,1,1,NULL,'2018-05-15 20:16:26',NULL,'2018-05-15 20:16:26','2018-05-15 20:16:26','4b379efe-edd8-431b-9468-04e6c4d05a83'),
	(18,2,2,NULL,'2018-05-15 20:16:41',NULL,'2018-05-15 20:16:41','2018-05-15 20:16:41','4105450f-4ba4-4f31-abd3-b04d2a8f9cdb');

/*!40000 ALTER TABLE `entries` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table entrydrafts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entrydrafts`;

CREATE TABLE `entrydrafts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entrydrafts_sectionId_idx` (`sectionId`),
  KEY `entrydrafts_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entrydrafts_siteId_idx` (`siteId`),
  KEY `entrydrafts_creatorId_idx` (`creatorId`),
  CONSTRAINT `entrydrafts_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table entrytypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entrytypes`;

CREATE TABLE `entrytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `hasTitleField` tinyint(1) NOT NULL DEFAULT '1',
  `titleLabel` varchar(255) DEFAULT 'Title',
  `titleFormat` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrytypes_name_sectionId_unq_idx` (`name`,`sectionId`),
  UNIQUE KEY `entrytypes_handle_sectionId_unq_idx` (`handle`,`sectionId`),
  KEY `entrytypes_sectionId_idx` (`sectionId`),
  KEY `entrytypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `entrytypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entrytypes_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `entrytypes` WRITE;
/*!40000 ALTER TABLE `entrytypes` DISABLE KEYS */;

INSERT INTO `entrytypes` (`id`, `sectionId`, `fieldLayoutId`, `name`, `handle`, `hasTitleField`, `titleLabel`, `titleFormat`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,4,'Home Page','homePage',0,NULL,'{section.name|raw}',1,'2018-05-15 20:16:25','2018-05-15 20:16:25','8bb13d74-e5a6-477a-beba-ab2078e88cb3'),
	(2,2,5,'Pricing','pricing',0,NULL,'{section.name|raw}',1,'2018-05-15 20:16:41','2018-05-15 20:16:41','da452dc1-0519-4933-a02a-aecfbce87890');

/*!40000 ALTER TABLE `entrytypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table entryversions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entryversions`;

CREATE TABLE `entryversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `siteId` int(11) NOT NULL,
  `num` smallint(6) unsigned NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entryversions_sectionId_idx` (`sectionId`),
  KEY `entryversions_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entryversions_siteId_idx` (`siteId`),
  KEY `entryversions_creatorId_idx` (`creatorId`),
  CONSTRAINT `entryversions_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entryversions_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table fieldgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldgroups`;

CREATE TABLE `fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `fieldgroups` WRITE;
/*!40000 ALTER TABLE `fieldgroups` DISABLE KEYS */;

INSERT INTO `fieldgroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Common','2018-04-23 17:28:21','2018-04-23 17:28:21','de06d13f-908b-45b8-9494-38ae85ba6b75');

/*!40000 ALTER TABLE `fieldgroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table fieldlayoutfields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldlayoutfields`;

CREATE TABLE `fieldlayoutfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `tabId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldlayoutfields_layoutId_fieldId_unq_idx` (`layoutId`,`fieldId`),
  KEY `fieldlayoutfields_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayoutfields_tabId_idx` (`tabId`),
  KEY `fieldlayoutfields_fieldId_idx` (`fieldId`),
  CONSTRAINT `fieldlayoutfields_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_tabId_fk` FOREIGN KEY (`tabId`) REFERENCES `fieldlayouttabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table fieldlayouts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldlayouts`;

CREATE TABLE `fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `fieldlayouts` WRITE;
/*!40000 ALTER TABLE `fieldlayouts` DISABLE KEYS */;

INSERT INTO `fieldlayouts` (`id`, `type`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'craft\\commerce\\elements\\Order','2018-04-23 17:30:25','2018-04-23 17:30:25','3bebcd8a-f038-45aa-a901-002925c85e5a'),
	(2,'craft\\commerce\\elements\\Product','2018-04-23 17:30:25','2018-05-02 11:57:48','88b621a1-fa28-4ae0-a823-360c5e548c50'),
	(3,'craft\\commerce\\elements\\Variant','2018-04-23 17:30:25','2018-05-02 11:57:48','3cb66098-7c3d-4ae5-b90a-eb3ef8162b45'),
	(4,'craft\\elements\\Entry','2018-05-15 20:16:25','2018-05-15 20:16:25','ded31a92-67ba-4492-b2da-fc46d31ab431'),
	(5,'craft\\elements\\Entry','2018-05-15 20:16:41','2018-05-15 20:16:41','1b1329b4-f899-4d46-a1e6-3754abb6cbd3');

/*!40000 ALTER TABLE `fieldlayouts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table fieldlayouttabs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldlayouttabs`;

CREATE TABLE `fieldlayouttabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouttabs_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayouttabs_layoutId_idx` (`layoutId`),
  CONSTRAINT `fieldlayouttabs_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table fields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fields`;

CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(64) NOT NULL,
  `context` varchar(255) NOT NULL DEFAULT 'global',
  `instructions` text,
  `translationMethod` varchar(255) NOT NULL DEFAULT 'none',
  `translationKeyFormat` text,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fields_handle_context_unq_idx` (`handle`,`context`),
  KEY `fields_groupId_idx` (`groupId`),
  KEY `fields_context_idx` (`context`),
  CONSTRAINT `fields_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `fieldgroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table globalsets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `globalsets`;

CREATE TABLE `globalsets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `globalsets_name_unq_idx` (`name`),
  UNIQUE KEY `globalsets_handle_unq_idx` (`handle`),
  KEY `globalsets_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `globalsets_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `globalsets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table info
# ------------------------------------------------------------

DROP TABLE IF EXISTS `info`;

CREATE TABLE `info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(50) NOT NULL,
  `schemaVersion` varchar(15) NOT NULL,
  `edition` tinyint(3) unsigned NOT NULL,
  `timezone` varchar(30) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `on` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `fieldVersion` char(12) NOT NULL DEFAULT '000000000000',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `info` WRITE;
/*!40000 ALTER TABLE `info` DISABLE KEYS */;

INSERT INTO `info` (`id`, `version`, `schemaVersion`, `edition`, `timezone`, `name`, `on`, `maintenance`, `fieldVersion`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'3.0.7','3.0.91',0,'America/Los_Angeles','Testing Site',1,0,'ZE8fuFX70jHP','2018-04-23 17:28:21','2018-05-15 20:15:33','d128a51a-6bfd-4ade-b26f-94f7b4cf7d7a');

/*!40000 ALTER TABLE `info` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table matrixblocks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `matrixblocks`;

CREATE TABLE `matrixblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `ownerSiteId` int(11) DEFAULT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `matrixblocks_ownerId_idx` (`ownerId`),
  KEY `matrixblocks_fieldId_idx` (`fieldId`),
  KEY `matrixblocks_typeId_idx` (`typeId`),
  KEY `matrixblocks_sortOrder_idx` (`sortOrder`),
  KEY `matrixblocks_ownerSiteId_idx` (`ownerSiteId`),
  CONSTRAINT `matrixblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerSiteId_fk` FOREIGN KEY (`ownerSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `matrixblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `matrixblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table matrixblocktypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `matrixblocktypes`;

CREATE TABLE `matrixblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `matrixblocktypes_name_fieldId_unq_idx` (`name`,`fieldId`),
  UNIQUE KEY `matrixblocktypes_handle_fieldId_unq_idx` (`handle`,`fieldId`),
  KEY `matrixblocktypes_fieldId_idx` (`fieldId`),
  KEY `matrixblocktypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `matrixblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pluginId` int(11) DEFAULT NULL,
  `type` enum('app','plugin','content') NOT NULL DEFAULT 'app',
  `name` varchar(255) NOT NULL,
  `applyTime` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `migrations_pluginId_idx` (`pluginId`),
  KEY `migrations_type_pluginId_idx` (`type`,`pluginId`),
  CONSTRAINT `migrations_pluginId_fk` FOREIGN KEY (`pluginId`) REFERENCES `plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;

INSERT INTO `migrations` (`id`, `pluginId`, `type`, `name`, `applyTime`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'app','Install','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','1468d230-b2b0-4835-b30a-e893859c837a'),
	(2,NULL,'app','m150403_183908_migrations_table_changes','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','7c25ad1a-29ee-47dd-9803-eec5d0ad1d8d'),
	(3,NULL,'app','m150403_184247_plugins_table_changes','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','6a06d7f8-90f6-4e66-84c3-8729e2fcd10d'),
	(4,NULL,'app','m150403_184533_field_version','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','fa499413-4dc8-41a6-8b0f-71c6ddcd6f74'),
	(5,NULL,'app','m150403_184729_type_columns','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','d101bcb2-b14b-40ad-9f6d-bb657ccf8f56'),
	(6,NULL,'app','m150403_185142_volumes','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','6598be61-93ec-4ac7-b3bc-d24459120c65'),
	(7,NULL,'app','m150428_231346_userpreferences','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','eeab8dd9-e024-4388-9f01-ff7e0cee64d9'),
	(8,NULL,'app','m150519_150900_fieldversion_conversion','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','6e5231da-89a8-4df9-ba38-2f6c7761cd7b'),
	(9,NULL,'app','m150617_213829_update_email_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','7a8d2004-9a18-4939-908e-1cb6fd3db1a8'),
	(10,NULL,'app','m150721_124739_templatecachequeries','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','b7f6ea2a-d698-4a5c-8b33-6aefee83faa6'),
	(11,NULL,'app','m150724_140822_adjust_quality_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','58e56012-9f69-489e-95a2-ff51e02b1a74'),
	(12,NULL,'app','m150815_133521_last_login_attempt_ip','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','7ae19af9-b3ea-4045-8a53-320740063719'),
	(13,NULL,'app','m151002_095935_volume_cache_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','5c508523-25b0-46b7-8212-7cb9b9ca2d76'),
	(14,NULL,'app','m151005_142750_volume_s3_storage_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','fde17326-6f6d-410c-97a8-2227172bc825'),
	(15,NULL,'app','m151016_133600_delete_asset_thumbnails','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','f64991f8-f9b0-4ad3-b55c-ef4136ea8e18'),
	(16,NULL,'app','m151209_000000_move_logo','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','5a7f6487-3a1f-46a3-8f81-5dd0bc295de2'),
	(17,NULL,'app','m151211_000000_rename_fileId_to_assetId','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','4be78d44-bd26-4fd9-9898-21e8647d81b4'),
	(18,NULL,'app','m151215_000000_rename_asset_permissions','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','827a6145-5b43-47e1-9e78-b6a4859dad17'),
	(19,NULL,'app','m160707_000001_rename_richtext_assetsource_setting','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','31d03cdc-7d38-4cb2-8626-1f351b5d30e3'),
	(20,NULL,'app','m160708_185142_volume_hasUrls_setting','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','fbb221c3-6cf0-4339-b52b-15dbaac249dc'),
	(21,NULL,'app','m160714_000000_increase_max_asset_filesize','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','4fe0fadb-36df-4c9d-bc02-4472e3e33a57'),
	(22,NULL,'app','m160727_194637_column_cleanup','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','c5554188-6b9e-4399-a087-9148f24f5243'),
	(23,NULL,'app','m160804_110002_userphotos_to_assets','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','b5cdffb7-1a66-46c9-9cb4-3929ae87a517'),
	(24,NULL,'app','m160807_144858_sites','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','d70b07b5-7e95-492f-8b07-158f0c693641'),
	(25,NULL,'app','m160829_000000_pending_user_content_cleanup','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','1412e675-b704-4b43-b954-7a46772c99af'),
	(26,NULL,'app','m160830_000000_asset_index_uri_increase','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','e11b9c7f-3905-439b-83f1-5a29e7c20181'),
	(27,NULL,'app','m160912_230520_require_entry_type_id','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','b829729e-2180-417d-9f8a-2eed3fe1509f'),
	(28,NULL,'app','m160913_134730_require_matrix_block_type_id','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','6c1045e4-9605-482e-b10b-d6757a520a10'),
	(29,NULL,'app','m160920_174553_matrixblocks_owner_site_id_nullable','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','c2ee2d3e-95c4-42d9-97fb-78f09b5f7220'),
	(30,NULL,'app','m160920_231045_usergroup_handle_title_unique','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','b944a1d9-5421-4ac8-b926-75d3cf81510d'),
	(31,NULL,'app','m160925_113941_route_uri_parts','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','a7683239-424a-4826-b5e4-dd9a5fa49e48'),
	(32,NULL,'app','m161006_205918_schemaVersion_not_null','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','09ef8b30-5c18-452b-a3ac-9a4352f4d4bf'),
	(33,NULL,'app','m161007_130653_update_email_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','aa6512eb-dc97-481a-bf24-7fd29f2be23a'),
	(34,NULL,'app','m161013_175052_newParentId','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','65f9e8f5-2a64-4976-a5d8-13cd6c2a56b6'),
	(35,NULL,'app','m161021_102916_fix_recent_entries_widgets','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','d25732ef-0b99-4ef7-9ba3-48e5177961d7'),
	(36,NULL,'app','m161021_182140_rename_get_help_widget','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','fce07043-6b32-4628-8102-ac100c5ec484'),
	(37,NULL,'app','m161025_000000_fix_char_columns','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','8cb3b916-31ec-45ce-a807-242d020345a3'),
	(38,NULL,'app','m161029_124145_email_message_languages','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','9f9fdc59-1e87-4472-8996-cfa34cd2887c'),
	(39,NULL,'app','m161108_000000_new_version_format','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','7f1baef7-5106-458f-8d77-0ccab36ac192'),
	(40,NULL,'app','m161109_000000_index_shuffle','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','2080b75e-a640-449d-bc80-da2cf0163417'),
	(41,NULL,'app','m161122_185500_no_craft_app','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','e3b62103-6d9a-4181-93dc-d901db707348'),
	(42,NULL,'app','m161125_150752_clear_urlmanager_cache','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','7a0ec26e-3adf-4e38-9901-d8763c6eed6e'),
	(43,NULL,'app','m161220_000000_volumes_hasurl_notnull','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','d76b4377-8417-48fa-975c-63c8673c123f'),
	(44,NULL,'app','m170114_161144_udates_permission','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','01819d47-fa74-4cab-8e5f-cf10a4ab4045'),
	(45,NULL,'app','m170120_000000_schema_cleanup','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','d358125b-3399-44a4-9cee-452e3888c524'),
	(46,NULL,'app','m170126_000000_assets_focal_point','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','c1dc730b-d300-4156-99a7-01be0d9181d2'),
	(47,NULL,'app','m170206_142126_system_name','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','4a5b387a-5670-4fa0-89be-a91e75d60007'),
	(48,NULL,'app','m170217_044740_category_branch_limits','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','2e186b9b-1d2f-470c-8853-1a9fa40f4c0a'),
	(49,NULL,'app','m170217_120224_asset_indexing_columns','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','af877301-671e-4505-870e-2b056fc66d5d'),
	(50,NULL,'app','m170223_224012_plain_text_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','33b4525c-c086-4dd0-9889-d63aed21d216'),
	(51,NULL,'app','m170227_120814_focal_point_percentage','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','487e5cd0-0975-43cd-83e0-aed3936a58b9'),
	(52,NULL,'app','m170228_171113_system_messages','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','0d97d178-1456-47c7-9c8f-7821b8b4d079'),
	(53,NULL,'app','m170303_140500_asset_field_source_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','3b52ecde-5b80-417a-ab54-435f244129d6'),
	(54,NULL,'app','m170306_150500_asset_temporary_uploads','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','7f56f9e0-a2c9-45fa-8580-425a97fe6284'),
	(55,NULL,'app','m170414_162429_rich_text_config_setting','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','7ec9bb23-f6f0-41d0-acd0-117ea19bc270'),
	(56,NULL,'app','m170523_190652_element_field_layout_ids','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','552ad5e0-4362-46d7-9a7c-59d2c04eeebf'),
	(57,NULL,'app','m170612_000000_route_index_shuffle','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','daf92d08-9749-4b4b-9e28-e74ea99cbe5c'),
	(58,NULL,'app','m170621_195237_format_plugin_handles','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','6ae9eee5-7b9f-4d7d-929f-889f0e5c0be2'),
	(59,NULL,'app','m170630_161028_deprecation_changes','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','254d3a19-1ab0-4d0a-bf20-05f48ee34d42'),
	(60,NULL,'app','m170703_181539_plugins_table_tweaks','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','adb984d8-1359-43c9-9392-b5c2b548d0c8'),
	(61,NULL,'app','m170704_134916_sites_tables','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','b4a56119-4bfe-4c4f-8422-bc807c61dd43'),
	(62,NULL,'app','m170706_183216_rename_sequences','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','c45a5c77-925c-4a23-9030-f9926686fbec'),
	(63,NULL,'app','m170707_094758_delete_compiled_traits','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','705eb0fd-abbe-405f-a287-92e05b87c895'),
	(64,NULL,'app','m170731_190138_drop_asset_packagist','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','3a3788a7-4501-471f-8edd-182b1ed6b944'),
	(65,NULL,'app','m170810_201318_create_queue_table','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','e4c9f48b-fd29-45ec-bbcc-bad9460f419f'),
	(66,NULL,'app','m170816_133741_delete_compiled_behaviors','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','f30c8a5c-f03c-4467-9083-26a807e5827a'),
	(67,NULL,'app','m170821_180624_deprecation_line_nullable','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','0ba4d7b4-ff85-45fa-b4cb-ef3195f8fbfe'),
	(68,NULL,'app','m170903_192801_longblob_for_queue_jobs','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','eee20249-199c-448e-bd65-40dcbecd2f77'),
	(69,NULL,'app','m170914_204621_asset_cache_shuffle','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','da7c6f57-fe81-4b10-baa2-145150a6c174'),
	(70,NULL,'app','m171011_214115_site_groups','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','fb5eef07-543f-46cf-ae39-6af628f9980a'),
	(71,NULL,'app','m171012_151440_primary_site','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','8e1aec1e-719c-40bf-b30d-e5ac296d681c'),
	(72,NULL,'app','m171013_142500_transform_interlace','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','058e4e8d-bcbc-42e1-a923-010d12dc3fd4'),
	(73,NULL,'app','m171016_092553_drop_position_select','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','33eb7e07-f230-453d-841e-ebf8dc38e500'),
	(74,NULL,'app','m171016_221244_less_strict_translation_method','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','732b1ba6-8cae-4d5a-bafd-f40da15d12ad'),
	(75,NULL,'app','m171107_000000_assign_group_permissions','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','55f0ed03-dbcc-464d-8282-cecfeb670a75'),
	(76,NULL,'app','m171117_000001_templatecache_index_tune','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','fa0c6a8a-e83d-4d58-98a6-704703156a6a'),
	(77,NULL,'app','m171126_105927_disabled_plugins','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','1d426602-f0d6-4232-be2c-2d25451220da'),
	(78,NULL,'app','m171130_214407_craftidtokens_table','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','855a0946-4fd3-4cca-85f5-9d8f2c1b9a92'),
	(79,NULL,'app','m171202_004225_update_email_settings','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','c0b94caa-5ac5-46b3-bae4-15baf8fb7971'),
	(80,NULL,'app','m171204_000001_templatecache_index_tune_deux','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','0866ba0f-998f-4fcb-aa66-944a0a4f24f2'),
	(81,NULL,'app','m171205_130908_remove_craftidtokens_refreshtoken_column','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','ec2c9563-73d1-4b87-8e3b-cdb056d24cac'),
	(82,NULL,'app','m171218_143135_longtext_query_column','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','19769732-883e-4edb-a72f-0b28774f5bd8'),
	(83,NULL,'app','m171231_055546_environment_variables_to_aliases','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','3d9c0909-cca8-431c-8baf-8a405632968d'),
	(84,NULL,'app','m180113_153740_drop_users_archived_column','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','4a6b14e4-a1c9-4f58-a079-aae2a03277ad'),
	(85,NULL,'app','m180122_213433_propagate_entries_setting','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','29a923df-c7e5-4974-8af4-075a96bd4890'),
	(86,NULL,'app','m180124_230459_fix_propagate_entries_values','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','531c5737-341d-4d7e-ad98-ca8d6e86d64e'),
	(87,NULL,'app','m180128_235202_set_tag_slugs','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','d71b1ef1-1406-4a30-8f68-3d2361408697'),
	(88,NULL,'app','m180202_185551_fix_focal_points','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','2db7abd2-094a-4e17-a38d-a14ceb6d8566'),
	(89,NULL,'app','m180217_172123_tiny_ints','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','c8872eaa-4649-4e45-a0dd-9eb45c63c9d9'),
	(90,NULL,'app','m180321_233505_small_ints','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','b517ed9c-fb8f-4dae-9fb5-8aa7cf01311d'),
	(91,NULL,'app','m180328_115523_new_license_key_statuses','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','cf7feac1-010a-4a55-9972-1d0953e90696'),
	(92,NULL,'app','m180404_182320_edition_changes','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','9437f237-887b-438a-b121-8d47b9e2754c'),
	(93,NULL,'app','m180411_102218_fix_db_routes','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','ec6c1804-8c74-43cc-b292-334cb4932912'),
	(94,NULL,'app','m180416_205628_resourcepaths_table','2018-04-23 17:28:24','2018-04-23 17:28:24','2018-04-23 17:28:24','e222ae8c-f822-4122-a5f6-8b9e871cc378'),
	(136,2,'plugin','Install','2018-05-15 20:14:37','2018-05-15 20:14:37','2018-05-15 20:14:37','de279341-5d70-41db-ab44-01554dd38d10'),
	(137,2,'plugin','m180314_002756_base_install','2018-05-15 20:14:37','2018-05-15 20:14:37','2018-05-15 20:14:37','ed390d21-86c7-44cf-9372-8d9faabc662e'),
	(138,2,'plugin','m180403_002756_field_type','2018-05-15 20:14:37','2018-05-15 20:14:37','2018-05-15 20:14:37','bd83b5c6-1645-4383-a236-e2439983c65d'),
	(139,2,'plugin','m180502_202319_remove_field_metabundles','2018-05-15 20:14:37','2018-05-15 20:14:37','2018-05-15 20:14:37','3bf9eb7a-f861-4ada-bc8a-04205ef1f418'),
	(140,NULL,'app','m180418_205713_widget_cleanup','2018-05-15 20:15:33','2018-05-15 20:15:33','2018-05-15 20:15:33','dc16fd7b-1bcc-4bd2-af8c-d2e02275085e');

/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table plugins
# ------------------------------------------------------------

DROP TABLE IF EXISTS `plugins`;

CREATE TABLE `plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `handle` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `schemaVersion` varchar(255) NOT NULL,
  `licenseKey` char(24) DEFAULT NULL,
  `licenseKeyStatus` enum('valid','invalid','mismatched','astray','unknown') NOT NULL DEFAULT 'unknown',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `installDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `plugins_handle_unq_idx` (`handle`),
  KEY `plugins_enabled_idx` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;

INSERT INTO `plugins` (`id`, `handle`, `version`, `schemaVersion`, `licenseKey`, `licenseKeyStatus`, `enabled`, `settings`, `installDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(2,'seomatic','3.0.12','3.0.5',NULL,'invalid',1,NULL,'2018-05-15 20:14:36','2018-05-15 20:14:36','2018-05-15 20:21:09','dcd6d272-8d4a-4114-a5ec-0ac105ddd823');

/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table queue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `queue`;

CREATE TABLE `queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` longblob NOT NULL,
  `description` text,
  `timePushed` int(11) NOT NULL,
  `ttr` int(11) NOT NULL,
  `delay` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) unsigned NOT NULL DEFAULT '1024',
  `dateReserved` datetime DEFAULT NULL,
  `timeUpdated` int(11) DEFAULT NULL,
  `progress` smallint(6) NOT NULL DEFAULT '0',
  `attempt` int(11) DEFAULT NULL,
  `fail` tinyint(1) DEFAULT '0',
  `dateFailed` datetime DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`id`),
  KEY `queue_fail_timeUpdated_timePushed_idx` (`fail`,`timeUpdated`,`timePushed`),
  KEY `queue_fail_timeUpdated_delay_idx` (`fail`,`timeUpdated`,`delay`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table relations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `relations`;

CREATE TABLE `relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `sourceSiteId` int(11) DEFAULT NULL,
  `targetId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `relations_fieldId_sourceId_sourceSiteId_targetId_unq_idx` (`fieldId`,`sourceId`,`sourceSiteId`,`targetId`),
  KEY `relations_sourceId_idx` (`sourceId`),
  KEY `relations_targetId_idx` (`targetId`),
  KEY `relations_sourceSiteId_idx` (`sourceSiteId`),
  CONSTRAINT `relations_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceSiteId_fk` FOREIGN KEY (`sourceSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `relations_targetId_fk` FOREIGN KEY (`targetId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table resourcepaths
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resourcepaths`;

CREATE TABLE `resourcepaths` (
  `hash` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  PRIMARY KEY (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `resourcepaths` WRITE;
/*!40000 ALTER TABLE `resourcepaths` DISABLE KEYS */;

INSERT INTO `resourcepaths` (`hash`, `path`)
VALUES
	('102baa71','@lib/fabric'),
	('10656309','@craft/web/assets/pluginstore/dist'),
	('155d32b7','@lib/xregexp'),
	('191e5374','@craft/web/assets/cp/dist'),
	('1f31763d','@lib/selectize'),
	('209d4866','@lib/fileupload'),
	('28e32114','@craft/commerce/web/assets/productindex/dist'),
	('2aa26ac2','@lib/timepicker'),
	('2c117e97','@app/web/assets/dbbackup/dist'),
	('30d6799f','@craft/web/assets/utilities/dist'),
	('33ff33b4','@app/web/assets/editentry/dist'),
	('34198ed4','@craft/web/assets/updater/dist'),
	('3608ae5','@craft/web/assets/updateswidget/dist'),
	('36d069c9','@lib/d3'),
	('38754998','@lib/picturefill'),
	('3ddac88b','@craft/web/assets/recententries/dist'),
	('3fd1755a','@lib/jquery-touch-events'),
	('45ea7be8','@lib/d3'),
	('4a0a75e','@craft/commerce/web/assets/commercecp/dist'),
	('4b4f5bb9','@lib/picturefill'),
	('4ceb677b','@lib/jquery-touch-events'),
	('5192bca7','@app/web/assets/plugins/dist'),
	('53a75a47','@lib/fileupload'),
	('56424f3f','@craft/commerce/web/assets/variantmatrix/dist'),
	('56d7e4f','@lib/garnishjs'),
	('58ba0a27','@nystudio107/seomatic/assetbundles/seomatic/dist'),
	('599878e3','@lib/timepicker'),
	('6063e395','@app/web/assets/dashboard/dist'),
	('6311b850','@lib/fabric'),
	('66672096','@lib/xregexp'),
	('6a244155','@craft/web/assets/cp/dist'),
	('6c0b641c','@lib/selectize'),
	('76576c6e','@lib/garnishjs'),
	('796cbb10','@craft/commerce/web/assets/editproduct/dist'),
	('7f9e2ce4','@app/web/assets/updates/dist'),
	('8099c83a','@app/web/assets/updateswidget/dist'),
	('8e0b64fb','@app/web/assets/craftsupport/dist'),
	('90cc9a05','@app/web/assets/updater/dist'),
	('969b8c54','@app/web/assets/installer/dist'),
	('98abb458','@app/web/assets/findreplace/dist'),
	('98c30be6','@lib/jquery-ui'),
	('9b4fdeea','@lib/element-resize-detector'),
	('9bd941a8','@craft/web/assets/feed/dist'),
	('a36eadd9','@app/web/assets/cp/dist'),
	('a4cc7cec','@craft/web/assets/craftsupport/dist'),
	('a5508262','@lib/velocity'),
	('a750b8a7','@app/web/assets/login/dist'),
	('a8712a14','@craft/web/assets/updates/dist'),
	('b22ffd69','@app/web/assets/utilities/dist'),
	('b4df751f','@bower/jquery/dist'),
	('b856e0f2','@app/web/assets/pluginstore/dist'),
	('b9772d8a','@lib/jquery.payment'),
	('be238a54','@app/web/assets/recententries/dist'),
	('c0200be6','@craft/commerce/web/assets/commercecp/dist'),
	('c115ef48','@app/web/assets/utilities/dist'),
	('c7e5673e','@bower/jquery/dist'),
	('ca4d3fab','@lib/jquery.payment'),
	('d054bff8','@app/web/assets/cp/dist'),
	('d122bbb3','@craft/commerce/web/assets/orderswidget/dist'),
	('d66a9043','@lib/velocity'),
	('da75e667','@app/web/assets/feed/dist'),
	('e29a6763','@craft/web/assets/dashboard/dist'),
	('e875cccb','@lib/element-resize-detector'),
	('ebf919c7','@lib/jquery-ui'),
	('f547a876','@craft/web/assets/plugins/dist'),
	('ffcfa6c6','@lib');

/*!40000 ALTER TABLE `resourcepaths` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table routes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `routes`;

CREATE TABLE `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) DEFAULT NULL,
  `uriParts` varchar(255) NOT NULL,
  `uriPattern` varchar(255) NOT NULL,
  `template` varchar(500) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `routes_uriPattern_idx` (`uriPattern`),
  KEY `routes_siteId_idx` (`siteId`),
  CONSTRAINT `routes_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table searchindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `searchindex`;

CREATE TABLE `searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `searchindex` WRITE;
/*!40000 ALTER TABLE `searchindex` DISABLE KEYS */;

INSERT INTO `searchindex` (`elementId`, `attribute`, `fieldId`, `siteId`, `keywords`)
VALUES
	(1,'username',0,1,' rosana '),
	(1,'firstname',0,1,''),
	(1,'lastname',0,1,''),
	(1,'fullname',0,1,''),
	(1,'email',0,1,' rosanarufer gmail com '),
	(1,'slug',0,1,''),
	(12,'billingfirstname',0,1,''),
	(12,'billinglastname',0,1,''),
	(12,'email',0,1,' rosanarufer gmail com '),
	(12,'number',0,1,' ec914d5232e07eda02469fd300eaed0b '),
	(12,'shippingfirstname',0,1,''),
	(12,'shippinglastname',0,1,''),
	(12,'shortnumber',0,1,' ec914d5 '),
	(12,'transactionreference',0,1,''),
	(12,'username',0,1,' rosana '),
	(12,'slug',0,1,''),
	(13,'billingfirstname',0,1,''),
	(13,'billinglastname',0,1,''),
	(13,'email',0,1,''),
	(13,'number',0,1,' f685ec9571bd3b9901394f478b29f984 '),
	(13,'shippingfirstname',0,1,''),
	(13,'shippinglastname',0,1,''),
	(13,'shortnumber',0,1,' f685ec9 '),
	(13,'transactionreference',0,1,''),
	(13,'username',0,1,''),
	(13,'slug',0,1,''),
	(14,'billingfirstname',0,1,' rosana '),
	(14,'billinglastname',0,1,' ruiz '),
	(14,'email',0,1,' rosanarufer gmail com '),
	(14,'number',0,1,' 0ac17fa5f974dc23f05d5e77236a296f '),
	(14,'shippingfirstname',0,1,' rosana '),
	(14,'shippinglastname',0,1,' ruiz '),
	(14,'shortnumber',0,1,' 0ac17fa '),
	(14,'transactionreference',0,1,''),
	(14,'username',0,1,' rosana '),
	(14,'slug',0,1,''),
	(15,'billingfirstname',0,1,''),
	(15,'billinglastname',0,1,''),
	(15,'email',0,1,''),
	(15,'number',0,1,' 92d75adc902791e0301b7d15d892c7da '),
	(15,'shippingfirstname',0,1,''),
	(15,'shippinglastname',0,1,''),
	(15,'shortnumber',0,1,' 92d75ad '),
	(15,'transactionreference',0,1,''),
	(15,'username',0,1,''),
	(15,'slug',0,1,''),
	(3,'sku',0,1,' ant 001 '),
	(3,'price',0,1,' 20 0000 '),
	(3,'width',0,1,''),
	(3,'height',0,1,''),
	(3,'length',0,1,''),
	(3,'weight',0,1,''),
	(3,'stock',0,1,' 0 '),
	(3,'hasunlimitedstock',0,1,' 1 '),
	(3,'minqty',0,1,''),
	(3,'maxqty',0,1,''),
	(3,'slug',0,1,' ant 001 '),
	(3,'title',0,1,' a new toga '),
	(2,'title',0,1,' a new toga '),
	(2,'defaultsku',0,1,' ant 001 '),
	(2,'sku',0,1,' ant 001 '),
	(2,'slug',0,1,' ant 001 '),
	(5,'sku',0,1,' psb 001 '),
	(5,'price',0,1,' 30 '),
	(5,'width',0,1,''),
	(5,'height',0,1,''),
	(5,'length',0,1,''),
	(5,'weight',0,1,''),
	(5,'stock',0,1,' 0 '),
	(5,'hasunlimitedstock',0,1,' 1 '),
	(5,'minqty',0,1,''),
	(5,'maxqty',0,1,''),
	(5,'slug',0,1,' psb 001 '),
	(5,'title',0,1,' parka with stripes on back '),
	(4,'title',0,1,' parka with stripes on back '),
	(4,'defaultsku',0,1,' psb 001 '),
	(4,'sku',0,1,' psb 2 psb 001 '),
	(4,'slug',0,1,' psb 001 '),
	(7,'sku',0,1,' rre 001 '),
	(7,'price',0,1,' 40 0000 '),
	(7,'width',0,1,''),
	(7,'height',0,1,''),
	(7,'length',0,1,''),
	(7,'weight',0,1,''),
	(7,'stock',0,1,' 0 '),
	(7,'hasunlimitedstock',0,1,' 1 '),
	(7,'minqty',0,1,''),
	(7,'maxqty',0,1,''),
	(7,'slug',0,1,' rre 001 '),
	(7,'title',0,1,' romper for a red eye '),
	(6,'title',0,1,' romper for a red eye '),
	(6,'defaultsku',0,1,' rre 001 '),
	(6,'sku',0,1,' rre 001 '),
	(6,'slug',0,1,' rre 001 '),
	(9,'sku',0,1,' tfa 001 '),
	(9,'price',0,1,' 50 0000 '),
	(9,'width',0,1,''),
	(9,'height',0,1,''),
	(9,'length',0,1,''),
	(9,'weight',0,1,''),
	(9,'stock',0,1,' 0 '),
	(9,'hasunlimitedstock',0,1,' 1 '),
	(9,'minqty',0,1,''),
	(9,'maxqty',0,1,''),
	(9,'slug',0,1,' tfa 001 '),
	(9,'title',0,1,' the fleece awakens '),
	(8,'title',0,1,' the fleece awakens '),
	(8,'defaultsku',0,1,' tfa 001 '),
	(8,'sku',0,1,' tfa 001 '),
	(8,'slug',0,1,' tfa 001 '),
	(11,'sku',0,1,' lkh 001 '),
	(11,'price',0,1,' 60 0000 '),
	(11,'width',0,1,''),
	(11,'height',0,1,''),
	(11,'length',0,1,''),
	(11,'weight',0,1,''),
	(11,'stock',0,1,' 0 '),
	(11,'hasunlimitedstock',0,1,' 1 '),
	(11,'minqty',0,1,''),
	(11,'maxqty',0,1,''),
	(11,'slug',0,1,' lkh 001 '),
	(11,'title',0,1,' the last knee high '),
	(10,'title',0,1,' the last knee high '),
	(10,'defaultsku',0,1,' lkh 001 '),
	(10,'sku',0,1,' lkh 001 '),
	(10,'slug',0,1,' lkh 001 '),
	(16,'sku',0,1,' psb 2 '),
	(16,'price',0,1,' 20 '),
	(16,'width',0,1,''),
	(16,'height',0,1,''),
	(16,'length',0,1,''),
	(16,'weight',0,1,''),
	(16,'stock',0,1,' 0 '),
	(16,'hasunlimitedstock',0,1,' 1 '),
	(16,'minqty',0,1,''),
	(16,'maxqty',0,1,''),
	(16,'slug',0,1,''),
	(16,'title',0,1,' parka with stripes on back '),
	(17,'slug',0,1,' home page '),
	(17,'title',0,1,' home page '),
	(18,'slug',0,1,' pricing '),
	(18,'title',0,1,' pricing ');

/*!40000 ALTER TABLE `searchindex` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sections
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sections`;

CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` enum('single','channel','structure') NOT NULL DEFAULT 'channel',
  `enableVersioning` tinyint(1) NOT NULL DEFAULT '0',
  `propagateEntries` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_handle_unq_idx` (`handle`),
  UNIQUE KEY `sections_name_unq_idx` (`name`),
  KEY `sections_structureId_idx` (`structureId`),
  CONSTRAINT `sections_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;

INSERT INTO `sections` (`id`, `structureId`, `name`, `handle`, `type`, `enableVersioning`, `propagateEntries`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'Home Page','homePage','single',1,1,'2018-05-15 20:16:25','2018-05-15 20:16:25','c96268a7-3b52-47a6-a241-7af2f76753e7'),
	(2,NULL,'Pricing','pricing','single',1,1,'2018-05-15 20:16:41','2018-05-15 20:16:41','ede14a33-2729-4847-b3e5-eae510803fa1');

/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sections_sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sections_sites`;

CREATE TABLE `sections_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `enabledByDefault` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_sites_sectionId_siteId_unq_idx` (`sectionId`,`siteId`),
  KEY `sections_sites_siteId_idx` (`siteId`),
  CONSTRAINT `sections_sites_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sections_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sections_sites` WRITE;
/*!40000 ALTER TABLE `sections_sites` DISABLE KEYS */;

INSERT INTO `sections_sites` (`id`, `sectionId`, `siteId`, `hasUrls`, `uriFormat`, `template`, `enabledByDefault`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,1,'__home__','index',1,'2018-05-15 20:16:25','2018-05-15 20:16:25','10955f4b-8717-4eef-a4e6-240e2e4893b9'),
	(2,2,1,1,'pricing','pricing',1,'2018-05-15 20:16:41','2018-05-15 20:16:41','459acd82-6459-42b5-8ea5-a0141e2a580c');

/*!40000 ALTER TABLE `sections_sites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table seomatic_metabundles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `seomatic_metabundles`;

CREATE TABLE `seomatic_metabundles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `bundleVersion` varchar(255) NOT NULL DEFAULT '',
  `sourceBundleType` varchar(255) NOT NULL DEFAULT '',
  `sourceId` int(11) DEFAULT NULL,
  `sourceName` varchar(255) NOT NULL DEFAULT '',
  `sourceHandle` varchar(64) NOT NULL DEFAULT '',
  `sourceType` varchar(64) NOT NULL DEFAULT '',
  `sourceTemplate` varchar(500) DEFAULT '',
  `sourceSiteId` int(11) DEFAULT NULL,
  `sourceAltSiteSettings` text,
  `sourceDateUpdated` datetime NOT NULL,
  `metaGlobalVars` text,
  `metaSiteVars` text,
  `metaSitemapVars` text,
  `metaContainers` text,
  `redirectsContainer` text,
  `frontendTemplatesContainer` text,
  `metaBundleSettings` text,
  PRIMARY KEY (`id`),
  KEY `seomatic_metabundles_sourceBundleType_idx` (`sourceBundleType`),
  KEY `seomatic_metabundles_sourceId_idx` (`sourceId`),
  KEY `seomatic_metabundles_sourceSiteId_idx` (`sourceSiteId`),
  KEY `seomatic_metabundles_sourceHandle_idx` (`sourceHandle`),
  CONSTRAINT `seomatic_metabundles_sourceSiteId_fk` FOREIGN KEY (`sourceSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `seomatic_metabundles` WRITE;
/*!40000 ALTER TABLE `seomatic_metabundles` DISABLE KEYS */;

INSERT INTO `seomatic_metabundles` (`id`, `dateCreated`, `dateUpdated`, `uid`, `bundleVersion`, `sourceBundleType`, `sourceId`, `sourceName`, `sourceHandle`, `sourceType`, `sourceTemplate`, `sourceSiteId`, `sourceAltSiteSettings`, `sourceDateUpdated`, `metaGlobalVars`, `metaSiteVars`, `metaSitemapVars`, `metaContainers`, `redirectsContainer`, `frontendTemplatesContainer`, `metaBundleSettings`)
VALUES
	(1,'2018-05-15 20:14:37','2018-05-15 20:16:59','4a2e69ea-d7bf-4fe4-b781-adcc38bfc01e','1.0.25','__GLOBAL_BUNDLE__',1,'__GLOBAL_BUNDLE__','__GLOBAL_BUNDLE__','__GLOBAL_BUNDLE__','',1,'[]','2018-05-15 20:14:37','{\"language\":null,\"mainEntityOfPage\":\"WebSite\",\"seoTitle\":\"*Global* Title\",\"siteNamePosition\":\"before\",\"seoDescription\":\"\",\"seoKeywords\":\"\",\"seoImage\":\"\",\"seoImageDescription\":\"\",\"canonicalUrl\":\"{{ craft.app.request.pathInfo }}\",\"robots\":\"all\",\"ogType\":\"website\",\"ogTitle\":\"{seomatic.meta.seoTitle}\",\"ogSiteNamePosition\":\"none\",\"ogDescription\":\"{seomatic.meta.seoDescription}\",\"ogImage\":\"{seomatic.meta.seoImage}\",\"ogImageDescription\":\"{seomatic.meta.seoImageDescription}\",\"twitterCard\":\"summary\",\"twitterCreator\":\"{seomatic.site.twitterHandle}\",\"twitterTitle\":\"{seomatic.meta.seoTitle}\",\"twitterSiteNamePosition\":\"none\",\"twitterDescription\":\"{seomatic.meta.seoDescription}\",\"twitterImage\":\"{seomatic.meta.seoImage}\",\"twitterImageDescription\":\"{seomatic.meta.seoImageDescription}\"}','{\"siteName\":\"Testing Site\",\"identity\":{\"siteType\":\"Organization\",\"siteSubType\":\"LocalBusiness\",\"siteSpecificType\":\"\",\"computedType\":\"Organization\",\"genericName\":\"\",\"genericAlternateName\":\"\",\"genericDescription\":\"\",\"genericUrl\":\"\",\"genericImage\":\"\",\"genericImageWidth\":\"\",\"genericImageHeight\":\"\",\"genericImageIds\":[],\"genericTelephone\":\"\",\"genericEmail\":\"\",\"genericStreetAddress\":\"\",\"genericAddressLocality\":\"\",\"genericAddressRegion\":\"\",\"genericPostalCode\":\"\",\"genericAddressCountry\":\"\",\"genericGeoLatitude\":\"\",\"genericGeoLongitude\":\"\",\"personGender\":\"\",\"personBirthPlace\":\"\",\"organizationDuns\":\"\",\"organizationFounder\":\"\",\"organizationFoundingDate\":\"\",\"organizationFoundingLocation\":\"\",\"organizationContactPoints\":[],\"corporationTickerSymbol\":\"\",\"localBusinessPriceRange\":\"\",\"localBusinessOpeningHours\":[],\"restaurantServesCuisine\":\"\",\"restaurantMenuUrl\":\"\",\"restaurantReservationsUrl\":\"\"},\"creator\":{\"siteType\":\"Organization\",\"siteSubType\":\"LocalBusiness\",\"siteSpecificType\":\"\",\"computedType\":\"Organization\",\"genericName\":\"\",\"genericAlternateName\":\"\",\"genericDescription\":\"\",\"genericUrl\":\"\",\"genericImage\":\"\",\"genericImageWidth\":\"\",\"genericImageHeight\":\"\",\"genericImageIds\":[],\"genericTelephone\":\"\",\"genericEmail\":\"\",\"genericStreetAddress\":\"\",\"genericAddressLocality\":\"\",\"genericAddressRegion\":\"\",\"genericPostalCode\":\"\",\"genericAddressCountry\":\"\",\"genericGeoLatitude\":\"\",\"genericGeoLongitude\":\"\",\"personGender\":\"\",\"personBirthPlace\":\"\",\"organizationDuns\":\"\",\"organizationFounder\":\"\",\"organizationFoundingDate\":\"\",\"organizationFoundingLocation\":\"\",\"organizationContactPoints\":[],\"corporationTickerSymbol\":\"\",\"localBusinessPriceRange\":\"\",\"localBusinessOpeningHours\":[],\"restaurantServesCuisine\":\"\",\"restaurantMenuUrl\":\"\",\"restaurantReservationsUrl\":\"\"},\"twitterHandle\":\"\",\"facebookProfileId\":\"\",\"facebookAppId\":\"\",\"googleSiteVerification\":\"\",\"bingSiteVerification\":\"\",\"pinterestSiteVerification\":\"\",\"sameAsLinks\":{\"twitter\":{\"siteName\":\"Twitter\",\"handle\":\"twitter\",\"url\":\"\"},\"facebook\":{\"siteName\":\"Facebook\",\"handle\":\"facebook\",\"url\":\"\"},\"wikipedia\":{\"siteName\":\"Wikipedia\",\"handle\":\"wikipedia\",\"url\":\"\"},\"linkedin\":{\"siteName\":\"LinkedIn\",\"handle\":\"linkedin\",\"url\":\"\"},\"googleplus\":{\"siteName\":\"Google+\",\"handle\":\"googleplus\",\"url\":\"\"},\"youtube\":{\"siteName\":\"YouTube\",\"handle\":\"youtube\",\"url\":\"\"},\"instagram\":{\"siteName\":\"Instagram\",\"handle\":\"instagram\",\"url\":\"\"},\"pinterest\":{\"siteName\":\"Pinterest\",\"handle\":\"pinterest\",\"url\":\"\"},\"github\":{\"siteName\":\"GitHub\",\"handle\":\"github\",\"url\":\"\"},\"vimeo\":{\"siteName\":\"Vimeo\",\"handle\":\"vimeo\",\"url\":\"\"}},\"siteLinksSearchTarget\":\"\",\"siteLinksQueryInput\":\"\"}','{\"sitemapUrls\":true,\"sitemapAssets\":true,\"sitemapFiles\":true,\"sitemapAltLinks\":true,\"sitemapChangeFreq\":\"weekly\",\"sitemapPriority\":0.5,\"sitemapLimit\":null,\"sitemapImageFieldMap\":[{\"property\":\"title\",\"field\":\"title\"},{\"property\":\"caption\",\"field\":\"\"},{\"property\":\"geo_location\",\"field\":\"\"},{\"property\":\"license\",\"field\":\"\"}],\"sitemapVideoFieldMap\":[{\"property\":\"title\",\"field\":\"title\"},{\"property\":\"description\",\"field\":\"\"},{\"property\":\"thumbnailLoc\",\"field\":\"\"},{\"property\":\"duration\",\"field\":\"\"},{\"property\":\"category\",\"field\":\"\"}]}','{\"MetaTagContainergeneral\":{\"data\":{\"generator\":{\"charset\":\"\",\"content\":\"SEOmatic\",\"httpEquiv\":\"\",\"name\":\"generator\",\"property\":null,\"include\":true,\"key\":\"generator\",\"environment\":null,\"dependencies\":null},\"keywords\":{\"charset\":\"\",\"content\":\"{seomatic.meta.seoKeywords}\",\"httpEquiv\":\"\",\"name\":\"keywords\",\"property\":null,\"include\":true,\"key\":\"keywords\",\"environment\":null,\"dependencies\":null},\"description\":{\"charset\":\"\",\"content\":\"{seomatic.meta.seoDescription}\",\"httpEquiv\":\"\",\"name\":\"description\",\"property\":null,\"include\":true,\"key\":\"description\",\"environment\":null,\"dependencies\":null},\"referrer\":{\"charset\":\"\",\"content\":\"no-referrer-when-downgrade\",\"httpEquiv\":\"\",\"name\":\"referrer\",\"property\":null,\"include\":true,\"key\":\"referrer\",\"environment\":null,\"dependencies\":null},\"robots\":{\"charset\":\"\",\"content\":\"{seomatic.meta.robots}\",\"httpEquiv\":\"\",\"name\":\"robots\",\"property\":null,\"include\":true,\"key\":\"robots\",\"environment\":{\"live\":{\"content\":\"{seomatic.meta.robots}\"},\"staging\":{\"content\":\"none\"},\"local\":{\"content\":\"none\"}},\"dependencies\":null}},\"name\":\"General\",\"description\":\"General Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaTagContaineropengraph\":{\"data\":{\"fb:profile_id\":{\"charset\":\"\",\"content\":\"{seomatic.site.facebookProfileId}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"fb:profile_id\",\"include\":true,\"key\":\"fb:profile_id\",\"environment\":null,\"dependencies\":null},\"fb:app_id\":{\"charset\":\"\",\"content\":\"{seomatic.site.facebookAppId}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"fb:app_id\",\"include\":true,\"key\":\"fb:app_id\",\"environment\":null,\"dependencies\":null},\"og:locale\":{\"charset\":\"\",\"content\":\"{{ craft.app.language }}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:locale\",\"include\":true,\"key\":\"og:locale\",\"environment\":null,\"dependencies\":null},\"og:locale:alternate\":{\"charset\":\"\",\"content\":\"\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:locale:alternate\",\"include\":true,\"key\":\"og:locale:alternate\",\"environment\":null,\"dependencies\":null},\"og:type\":{\"charset\":\"\",\"content\":\"{seomatic.meta.ogType}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:type\",\"include\":true,\"key\":\"og:type\",\"environment\":null,\"dependencies\":null},\"og:url\":{\"charset\":\"\",\"content\":\"{seomatic.meta.canonicalUrl}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:url\",\"include\":true,\"key\":\"og:url\",\"environment\":null,\"dependencies\":null},\"og:title\":{\"siteName\":\"{seomatic.site.siteName}\",\"siteNamePosition\":\"{seomatic.meta.ogSiteNamePosition}\",\"separatorChar\":\"{seomatic.config.separatorChar}\",\"charset\":\"\",\"content\":\"{seomatic.meta.ogTitle}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:title\",\"include\":true,\"key\":\"og:title\",\"environment\":null,\"dependencies\":null},\"og:description\":{\"charset\":\"\",\"content\":\"{seomatic.meta.ogDescription}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:description\",\"include\":true,\"key\":\"og:description\",\"environment\":null,\"dependencies\":null},\"og:image\":{\"charset\":\"\",\"content\":\"{seomatic.meta.ogImage}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:image\",\"include\":true,\"key\":\"og:image\",\"environment\":null,\"dependencies\":null},\"og:image:alt\":{\"charset\":\"\",\"content\":\"{seomatic.meta.ogImageDescription}\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:image:alt\",\"include\":true,\"key\":\"og:image:alt\",\"environment\":null,\"dependencies\":{\"tag\":[\"og:image\"]}},\"og:see_also\":{\"charset\":\"\",\"content\":\"\",\"httpEquiv\":\"\",\"name\":\"\",\"property\":\"og:see_also\",\"include\":true,\"key\":\"og:see_also\",\"environment\":null,\"dependencies\":null}},\"name\":\"Facebook\",\"description\":\"Facebook OpenGraph Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"opengraph\",\"include\":true,\"dependencies\":[]},\"MetaTagContainertwitter\":{\"data\":{\"twitter:card\":{\"charset\":\"\",\"content\":\"{seomatic.meta.twitterCard}\",\"httpEquiv\":\"\",\"name\":\"twitter:card\",\"property\":null,\"include\":true,\"key\":\"twitter:card\",\"environment\":null,\"dependencies\":null},\"twitter:site\":{\"charset\":\"\",\"content\":\"@{seomatic.site.twitterHandle}\",\"httpEquiv\":\"\",\"name\":\"twitter:site\",\"property\":null,\"include\":true,\"key\":\"twitter:site\",\"environment\":null,\"dependencies\":{\"site\":[\"twitterHandle\"]}},\"twitter:creator\":{\"charset\":\"\",\"content\":\"@{seomatic.meta.twitterCreator}\",\"httpEquiv\":\"\",\"name\":\"twitter:creator\",\"property\":null,\"include\":true,\"key\":\"twitter:creator\",\"environment\":null,\"dependencies\":{\"meta\":[\"twitterCreator\"]}},\"twitter:title\":{\"siteName\":\"{seomatic.site.siteName}\",\"siteNamePosition\":\"{seomatic.meta.twitterSiteNamePosition}\",\"separatorChar\":\"{seomatic.config.separatorChar}\",\"charset\":\"\",\"content\":\"{seomatic.meta.twitterTitle}\",\"httpEquiv\":\"\",\"name\":\"twitter:title\",\"property\":null,\"include\":true,\"key\":\"twitter:title\",\"environment\":null,\"dependencies\":null},\"twitter:description\":{\"charset\":\"\",\"content\":\"{seomatic.meta.twitterDescription}\",\"httpEquiv\":\"\",\"name\":\"twitter:description\",\"property\":null,\"include\":true,\"key\":\"twitter:description\",\"environment\":null,\"dependencies\":null},\"twitter:image\":{\"charset\":\"\",\"content\":\"{seomatic.meta.twitterImage}\",\"httpEquiv\":\"\",\"name\":\"twitter:image\",\"property\":null,\"include\":true,\"key\":\"twitter:image\",\"environment\":null,\"dependencies\":null},\"twitter:image:alt\":{\"charset\":\"\",\"content\":\"{seomatic.meta.twitterImageDescription}\",\"httpEquiv\":\"\",\"name\":\"twitter:image:alt\",\"property\":null,\"include\":true,\"key\":\"twitter:image:alt\",\"environment\":null,\"dependencies\":{\"tag\":[\"twitter:image\"]}}},\"name\":\"Twitter\",\"description\":\"Twitter Card Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"twitter\",\"include\":true,\"dependencies\":{\"site\":[\"twitterHandle\"]}},\"MetaTagContainermiscellaneous\":{\"data\":{\"google-site-verification\":{\"charset\":\"\",\"content\":\"{seomatic.site.googleSiteVerification}\",\"httpEquiv\":\"\",\"name\":\"google-site-verification\",\"property\":null,\"include\":true,\"key\":\"google-site-verification\",\"environment\":null,\"dependencies\":{\"site\":[\"googleSiteVerification\"]}},\"bing-site-verification\":{\"charset\":\"\",\"content\":\"{seomatic.site.bingSiteVerification}\",\"httpEquiv\":\"\",\"name\":\"msvalidate.01\",\"property\":null,\"include\":true,\"key\":\"msvalidate.01\",\"environment\":null,\"dependencies\":{\"site\":[\"bingSiteVerification\"]}},\"pinterest-site-verification\":{\"charset\":\"\",\"content\":\"{seomatic.site.pinterestSiteVerification}\",\"httpEquiv\":\"\",\"name\":\"p:domain_verify\",\"property\":null,\"include\":true,\"key\":\"p:domain_verify\",\"environment\":null,\"dependencies\":{\"site\":[\"pinterestSiteVerification\"]}}},\"name\":\"Miscellaneous\",\"description\":\"Miscellaneous Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"miscellaneous\",\"include\":true,\"dependencies\":[]},\"MetaLinkContainergeneral\":{\"data\":{\"canonical\":{\"crossorigin\":\"\",\"href\":\"{seomatic.meta.canonicalUrl}\",\"hreflang\":\"\",\"media\":\"\",\"rel\":\"canonical\",\"sizes\":\"\",\"type\":\"\",\"include\":true,\"key\":\"canonical\",\"environment\":null,\"dependencies\":null},\"home\":{\"crossorigin\":\"\",\"href\":\"{{ siteUrl }}\",\"hreflang\":\"\",\"media\":\"\",\"rel\":\"home\",\"sizes\":\"\",\"type\":\"\",\"include\":true,\"key\":\"home\",\"environment\":null,\"dependencies\":null},\"author\":{\"crossorigin\":\"\",\"href\":\"{{ url(\\\"/humans.txt\\\") }}\",\"hreflang\":\"\",\"media\":\"\",\"rel\":\"author\",\"sizes\":\"\",\"type\":\"text/plain\",\"include\":true,\"key\":\"author\",\"environment\":null,\"dependencies\":{\"frontend_template\":[\"humans\"]}},\"publisher\":{\"crossorigin\":\"\",\"href\":\"{seomatic.site.googlePublisherLink}\",\"hreflang\":\"\",\"media\":\"\",\"rel\":\"publisher\",\"sizes\":\"\",\"type\":\"\",\"include\":true,\"key\":\"publisher\",\"environment\":null,\"dependencies\":{\"site\":[\"googlePublisherLink\"]}}},\"name\":\"General\",\"description\":\"Link Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaLinkContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaScriptContainergeneral\":{\"data\":{\"googleAnalytics\":{\"name\":\"Google Analytics\",\"description\":\"Google Analytics gives you the digital analytics tools you need to analyze data from all touchpoints in one place, for a deeper understanding of the customer experience. You can then share the insights that matter with your whole organization. [Learn More](https://www.google.com/analytics/analytics/)\",\"templatePath\":\"_frontend/scripts/googleAnalytics.twig\",\"templateString\":\"{% if trackingId.value is defined and trackingId.value %}\\n(function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;i[r]=i[r]||function(){\\n(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\\nm=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\\n})(window,document,\'script\',\'{{ analyticsUrl.value }}\',\'ga\');\\nga(\'create\', \'{{ trackingId.value |raw }}\', \'auto\'{% if linker.value %}, {allowLinker: true}{% endif %});\\n{% if ipAnonymization.value %}\\nga(\'set\', \'anonymizeIp\', true);\\n{% endif %}\\n{% if displayFeatures.value %}\\nga(\'require\', \'displayfeatures\');\\n{% endif %}\\n{% if ecommerce.value %}\\nga(\'require\', \'ecommerce\');\\n{% endif %}\\n{% if enhancedEcommerce.value %}\\nga(\'require\', \'ec\');\\n{% endif %}\\n{% if enhancedLinkAttribution.value %}\\nga(\'require\', \'linkid\');\\n{% endif %}\\n{% if enhancedLinkAttribution.value %}\\nga(\'require\', \'linker\');\\n{% endif %}\\n{% if sendPageView.value %}\\nga(\'send\', \'pageview\');\\n{% endif %}\\n{% endif %}\\n\",\"position\":1,\"bodyTemplatePath\":null,\"bodyPosition\":2,\"vars\":{\"trackingId\":{\"title\":\"Google Analytics Tracking ID\",\"instructions\":\"Only enter the ID, e.g.: `UA-XXXXXX-XX`, not the entire script code. [Learn More](https://support.google.com/analytics/answer/1032385?hl=e)\",\"type\":\"string\",\"value\":\"\"},\"sendPageView\":{\"title\":\"Automatically send Google Analytics PageView\",\"instructions\":\"Controls whether the Google Analytics script automatically sends a PageView to Google Analytics when your pages are loaded.\",\"type\":\"bool\",\"value\":true},\"ipAnonymization\":{\"title\":\"Google Analytics IP Anonymization\",\"instructions\":\"When a customer of Analytics requests IP address anonymization, Analytics anonymizes the address as soon as technically feasible at the earliest possible stage of the collection network.\",\"type\":\"bool\",\"value\":false},\"displayFeatures\":{\"title\":\"Display Features\",\"instructions\":\"The display features plugin for analytics.js can be used to enable Advertising Features in Google Analytics, such as Remarketing, Demographics and Interest Reporting, and more. [Learn More](https://developers.google.com/analytics/devguides/collection/analyticsjs/display-features)\",\"type\":\"bool\",\"value\":false},\"ecommerce\":{\"title\":\"Ecommerce\",\"instructions\":\"Ecommerce tracking allows you to measure the number of transactions and revenue that your website generates. [Learn More](https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce)\",\"type\":\"bool\",\"value\":false},\"enhancedEcommerce\":{\"title\":\"Enhanced Ecommerce\",\"instructions\":\"The enhanced ecommerce plug-in for analytics.js enables the measurement of user interactions with products on ecommerce websites across the user\'s shopping experience, including: product impressions, product clicks, viewing product details, adding a product to a shopping cart, initiating the checkout process, transactions, and refunds. [Learn More](https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-ecommerce)\",\"type\":\"bool\",\"value\":false},\"enhancedLinkAttribution\":{\"title\":\"Enhanced Link Attribution\",\"instructions\":\"Enhanced Link Attribution improves the accuracy of your In-Page Analytics report by automatically differentiating between multiple links to the same URL on a single page by using link element IDs. [Learn More](https://developers.google.com/analytics/devguides/collection/analyticsjs/enhanced-link-attribution)\",\"type\":\"bool\",\"value\":false},\"linker\":{\"title\":\"Linker\",\"instructions\":\"The linker plugin simplifies the process of implementing cross-domain tracking as described in the Cross-domain Tracking guide for analytics.js. [Learn More](https://developers.google.com/analytics/devguides/collection/analyticsjs/linker)\",\"type\":\"bool\",\"value\":false},\"analyticsUrl\":{\"title\":\"Google Analytics Script URL\",\"instructions\":\"The URL to the Google Analytics tracking script. Normally this should not be changed, unless you locally cache it.\",\"type\":\"string\",\"value\":\"//www.google-analytics.com/analytics.js\"}},\"include\":false,\"key\":\"_frontend/scripts/googleAnalytics.twig\",\"environment\":{\"staging\":{\"include\":false},\"local\":{\"include\":false}},\"dependencies\":null},\"gtag\":{\"name\":\"Google gtag.js\",\"description\":\"The global site tag (gtag.js) is a JavaScript tagging framework and API that allows you to send event data to AdWords, DoubleClick, and Google Analytics. Instead of having to manage multiple tags for different products, you can use gtag.js and more easily benefit from the latest tracking features and integrations as they become available. [Learn More](https://developers.google.com/gtagjs/)\",\"templatePath\":\"_frontend/scripts/gtagHead.twig\",\"templateString\":\"{% set gtagProperty = googleAnalyticsId.value ?? googleAdWordsId.value ?? dcFloodlightId ?? null %}\\n{% if gtagProperty %}\\nwindow.dataLayer = window.dataLayer || [{% if dataLayer is defined and dataLayer %}{{ dataLayer |json_encode() |raw }}{% endif %}];\\nfunction gtag(){dataLayer.push(arguments)};\\ngtag(\'js\', new Date());\\n{% if googleAnalyticsId.value %}\\n{%- set gtagConfig = \\\"{\\\"\\n    ~ \\\"\'send_page_view\': #{sendPageView.value ? \'true\' : \'false\'},\\\"\\n    ~ \\\"\'anonymize_ip\': #{ipAnonymization.value ? \'true\' : \'false\'},\\\"\\n    ~ \\\"\'link_attribution\': #{enhancedLinkAttribution.value ? \'true\' : \'false\'},\\\"\\n    ~ \\\"\'allow_display_features\': #{displayFeatures.value ? \'true\' : \'false\'},\\\"\\n    ~ \\\"}\\\"\\n-%}\\ngtag(\'config\', \'{{ googleAnalyticsId.value }}\', {{ gtagConfig }});\\n{% endif %}\\n{% if googleAdWordsId.value %}\\n{%- set gtagConfig = \\\"{\\\"\\n    ~ \\\"\'send_page_view\': #{sendPageView.value ? \'true\' : \'false\'}\\\"\\n    ~ \\\"}\\\"\\n-%}\\ngtag(\'config\', \'{{ googleAdWordsId.value }}\', {{ gtagConfig }});\\n{% endif %}\\n{% if dcFloodlightId.value %}\\n{%- set gtagConfig = \\\"{\\\"\\n    ~ \\\"\'send_page_view\': #{sendPageView.value ? \'true\' : \'false\'}\\\"\\n    ~ \\\"}\\\"\\n-%}\\ngtag(\'config\', \'{{ dcFloodlightId.value }}\', {{ gtagConfig }});\\n{% endif %}\\n{% endif %}\\n\",\"position\":1,\"bodyTemplatePath\":null,\"bodyPosition\":2,\"vars\":{\"googleAnalyticsId\":{\"title\":\"Google Analytics Tracking ID\",\"instructions\":\"Only enter the ID, e.g.: `UA-XXXXXX-XX`, not the entire script code. [Learn More](https://support.google.com/analytics/answer/1032385?hl=e)\",\"type\":\"string\",\"value\":\"\"},\"googleAdWordsId\":{\"title\":\"AdWords Conversion ID\",\"instructions\":\"Only enter the ID, e.g.: `AW-XXXXXXXX`, not the entire script code. [Learn More](https://developers.google.com/adwords-remarketing-tag/)\",\"type\":\"string\",\"value\":\"\"},\"dcFloodlightId\":{\"title\":\"DoubleClick Floodlight ID\",\"instructions\":\"Only enter the ID, e.g.: `DC-XXXXXXXX`, not the entire script code. [Learn More](https://support.google.com/dcm/partner/answer/7568534)\",\"type\":\"string\",\"value\":\"\"},\"sendPageView\":{\"title\":\"Automatically send PageView\",\"instructions\":\"Controls whether the `gtag.js` script automatically sends a PageView to Google Analytics, AdWords, and DoubleClick Floodlight when your pages are loaded.\",\"type\":\"bool\",\"value\":true},\"ipAnonymization\":{\"title\":\"Google Analytics IP Anonymization\",\"instructions\":\"In some cases, you might need to anonymize the IP addresses of hits sent to Google Analytics. [Learn More](https://developers.google.com/analytics/devguides/collection/gtagjs/ip-anonymization)\",\"type\":\"bool\",\"value\":false},\"displayFeatures\":{\"title\":\"Google Analytics Display Features\",\"instructions\":\"The display features plugin for gtag.js can be used to enable Advertising Features in Google Analytics, such as Remarketing, Demographics and Interest Reporting, and more. [Learn More](https://developers.google.com/analytics/devguides/collection/gtagjs/display-features)\",\"type\":\"bool\",\"value\":false},\"enhancedLinkAttribution\":{\"title\":\"Google Analytics Enhanced Link Attribution\",\"instructions\":\"Enhanced link attribution improves click track reporting by automatically differentiating between multiple link clicks that have the same URL on a given page. [Learn More](https://developers.google.com/analytics/devguides/collection/gtagjs/enhanced-link-attribution)\",\"type\":\"bool\",\"value\":false},\"gtagScriptUrl\":{\"title\":\"Google gtag.js Script URL\",\"instructions\":\"The URL to the Google gtag.js tracking script. Normally this should not be changed, unless you locally cache it. The JavaScript `dataLayer` will automatically be set to the `dataLayer` Twig template variable.\",\"type\":\"string\",\"value\":\"//www.googletagmanager.com/gtag/js\"}},\"include\":false,\"key\":\"_frontend/scripts/gtagHead.twig\",\"environment\":{\"staging\":{\"include\":false},\"local\":{\"include\":false}},\"dependencies\":null},\"googleTagManager\":{\"name\":\"Google Tag Manager\",\"description\":\"Google Tag Manager is a tag management system that allows you to quickly and easily update tags and code snippets on your website. Once the Tag Manager snippet has been added to your website or mobile app, you can configure tags via a web-based user interface without having to alter and deploy additional code. [Learn More](https://support.google.com/tagmanager/answer/6102821?hl=en)\",\"templatePath\":\"_frontend/scripts/googleTagManagerHead.twig\",\"templateString\":\"{% if googleTagManagerId.value is defined and googleTagManagerId.value %}\\n{{ dataLayerVariableName.value }} = [{% if dataLayer is defined and dataLayer %}{{ dataLayer |json_encode() |raw }}{% endif %}];\\n(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({\'gtm.start\':\\nnew Date().getTime(),event:\'gtm.js\'});var f=d.getElementsByTagName(s)[0],\\nj=d.createElement(s),dl=l!=\'dataLayer\'?\'&l=\'+l:\'\';j.async=true;j.src=\\n\'{{ googleTagManagerUrl.value }}?id=\'+i+dl;f.parentNode.insertBefore(j,f);\\n})(window,document,\'script\',\'{{ dataLayerVariableName.value }}\',\'{{ googleTagManagerId.value }}\');\\n{% endif %}\\n\",\"position\":1,\"bodyTemplatePath\":\"_frontend/scripts/googleTagManagerBody.twig\",\"bodyPosition\":2,\"vars\":{\"googleTagManagerId\":{\"title\":\"Google Tag Manager ID\",\"instructions\":\"Only enter the ID, e.g.: `GTM-XXXXXX`, not the entire script code. [Learn More](https://developers.google.com/tag-manager/quickstart)\",\"type\":\"string\",\"value\":\"\"},\"dataLayerVariableName\":{\"title\":\"DataLayer Variable Name\",\"instructions\":\"The name to use for the JavaScript DataLayer variable. The value of this variable will be set to the `dataLayer` Twig template variable.\",\"type\":\"string\",\"value\":\"dl\"},\"googleTagManagerUrl\":{\"title\":\"Google Tag Manager Script URL\",\"instructions\":\"The URL to the Google Tag Manager script. Normally this should not be changed, unless you locally cache it.\",\"type\":\"string\",\"value\":\"//www.googletagmanager.com/gtm.js\"},\"googleTagManagerNoScriptUrl\":{\"title\":\"Google Tag Manager Script &lt;noscript&gt; URL\",\"instructions\":\"The URL to the Google Tag Manager `&lt;noscript&gt;`. Normally this should not be changed, unless you locally cache it.\",\"type\":\"string\",\"value\":\"//www.googletagmanager.com/ns.html\"}},\"include\":false,\"key\":\"_frontend/scripts/googleTagManagerHead.twig\",\"environment\":{\"staging\":{\"include\":false},\"local\":{\"include\":false}},\"dependencies\":null},\"facebookPixel\":{\"name\":\"Facebook Pixel\",\"description\":\"The Facebook pixel is an analytics tool that helps you measure the effectiveness of your advertising. You can use the Facebook pixel to understand the actions people are taking on your website and reach audiences you care about. [Learn More](https://www.facebook.com/business/help/651294705016616)\",\"templatePath\":\"_frontend/scripts/facebookPixelHead.twig\",\"templateString\":\"{% if facebookPixelId.value is defined and facebookPixelId.value %}\\n!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?\\nn.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;\\nn.push=n;n.loaded=!0;n.version=\'2.0\';n.queue=[];t=b.createElement(e);t.async=!0;\\nt.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,\\ndocument,\'script\',\'{{ facebookPixelUrl.value }}\');\\nfbq(\'init\', \'{{ facebookPixelId.value }}\');\\n{% if sendPageView.value %}\\nfbq(\'track\', \'PageView\');\\n{% endif %}\\n{% endif %}\\n\",\"position\":1,\"bodyTemplatePath\":\"_frontend/scripts/facebookPixelBody.twig\",\"bodyPosition\":2,\"vars\":{\"facebookPixelId\":{\"title\":\"Facebook Pixel ID\",\"instructions\":\"Only enter the ID, e.g.: `XXXXXXXXXX`, not the entire script code. [Learn More](https://developers.facebook.com/docs/facebook-pixel/api-reference)\",\"type\":\"string\",\"value\":\"\"},\"sendPageView\":{\"title\":\"Automatically send Facebook Pixel PageView\",\"instructions\":\"Controls whether the Facebook Pixel script automatically sends a PageView to Facebook Analytics when your pages are loaded.\",\"type\":\"bool\",\"value\":true},\"facebookPixelUrl\":{\"title\":\"Facebook Pixel Script URL\",\"instructions\":\"The URL to the Facebook Pixel script. Normally this should not be changed, unless you locally cache it.\",\"type\":\"string\",\"value\":\"//connect.facebook.net/en_US/fbevents.js\"},\"facebookPixelNoScriptUrl\":{\"title\":\"Facebook Pixel Script &lt;noscript&gt; URL\",\"instructions\":\"The URL to the Facebook Pixel `&lt;noscript&gt;`. Normally this should not be changed, unless you locally cache it.\",\"type\":\"string\",\"value\":\"//www.facebook.com/tr\"}},\"include\":false,\"key\":\"_frontend/scripts/facebookPixelHead.twig\",\"environment\":{\"staging\":{\"include\":false},\"local\":{\"include\":false}},\"dependencies\":null}},\"position\":1,\"name\":\"General\",\"description\":\"Script Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaScriptContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaJsonLdContainergeneral\":{\"data\":{\"mainEntityOfPage\":{\"issn\":null,\"about\":null,\"accessMode\":null,\"accessModeSufficient\":null,\"accessibilityAPI\":null,\"accessibilityControl\":null,\"accessibilityFeature\":null,\"accessibilityHazard\":null,\"accessibilitySummary\":null,\"accountablePerson\":null,\"aggregateRating\":null,\"alternativeHeadline\":null,\"associatedMedia\":null,\"audience\":null,\"audio\":null,\"author\":{\"id\":\"{seomatic.site.identity.genericUrl}#identity\"},\"award\":null,\"character\":null,\"citation\":null,\"comment\":null,\"commentCount\":null,\"contentLocation\":null,\"contentRating\":null,\"contentReferenceTime\":null,\"contributor\":null,\"copyrightHolder\":{\"id\":\"{seomatic.site.identity.genericUrl}#identity\"},\"copyrightYear\":null,\"creator\":{\"id\":\"{seomatic.site.creator.genericUrl}#creator\"},\"dateCreated\":null,\"dateModified\":null,\"datePublished\":null,\"discussionUrl\":null,\"editor\":null,\"educationalAlignment\":null,\"educationalUse\":null,\"encoding\":null,\"exampleOfWork\":null,\"expires\":null,\"fileFormat\":null,\"funder\":null,\"genre\":null,\"hasPart\":null,\"headline\":null,\"inLanguage\":\"{seomatic.meta.language}\",\"interactionStatistic\":null,\"interactivityType\":null,\"isAccessibleForFree\":null,\"isBasedOn\":null,\"isFamilyFriendly\":null,\"isPartOf\":null,\"keywords\":null,\"learningResourceType\":null,\"license\":null,\"locationCreated\":null,\"mainEntity\":null,\"material\":null,\"mentions\":null,\"offers\":null,\"position\":null,\"producer\":null,\"provider\":null,\"publication\":null,\"publisher\":null,\"publisherImprint\":null,\"publishingPrinciples\":null,\"recordedAt\":null,\"releasedEvent\":null,\"review\":null,\"schemaVersion\":null,\"sourceOrganization\":null,\"spatialCoverage\":null,\"sponsor\":null,\"temporalCoverage\":null,\"text\":null,\"thumbnailUrl\":null,\"timeRequired\":null,\"translationOfWork\":null,\"translator\":null,\"typicalAgeRange\":null,\"version\":null,\"video\":null,\"workExample\":null,\"workTranslation\":null,\"additionalType\":null,\"alternateName\":null,\"description\":\"{seomatic.meta.seoDescription}\",\"disambiguatingDescription\":null,\"identifier\":null,\"image\":{\"type\":\"ImageObject\",\"url\":\"{seomatic.meta.seoImage}\"},\"mainEntityOfPage\":\"{seomatic.meta.canonicalUrl}\",\"name\":\"{seomatic.meta.seoTitle}\",\"potentialAction\":{\"type\":\"SearchAction\",\"target\":\"{seomatic.site.siteLinksSearchTarget}\",\"query-input\":\"{seomatic.site.siteLinksQueryInput}\"},\"sameAs\":null,\"url\":\"{seomatic.meta.canonicalUrl}\",\"context\":\"http://schema.org\",\"type\":\"{seomatic.meta.mainEntityOfPage}\",\"id\":null,\"include\":true,\"key\":\"mainEntityOfPage\",\"environment\":null,\"dependencies\":null},\"identity\":{\"actionableFeedbackPolicy\":null,\"address\":{\"type\":\"PostalAddress\",\"streetAddress\":\"{seomatic.site.identity.genericStreetAddress}\",\"addressLocality\":\"{seomatic.site.identity.genericAddressLocality}\",\"addressRegion\":\"{seomatic.site.identity.genericAddressRegion}\",\"postalCode\":\"{seomatic.site.identity.genericPostalCode}\",\"addressCountry\":\"{seomatic.site.identity.genericAddressCountry}\"},\"aggregateRating\":null,\"alumni\":null,\"areaServed\":null,\"award\":null,\"brand\":null,\"contactPoint\":null,\"correctionsPolicy\":null,\"department\":null,\"dissolutionDate\":null,\"diversityPolicy\":null,\"duns\":\"{seomatic.site.identity.organizationDuns}\",\"email\":\"{seomatic.site.identity.genericEmail}\",\"employee\":null,\"ethicsPolicy\":null,\"event\":null,\"faxNumber\":null,\"founder\":\"{seomatic.site.identity.organizationFounder}\",\"foundingDate\":\"{seomatic.site.identity.organizationFoundingDate}\",\"foundingLocation\":\"{seomatic.site.identity.organizationFoundingLocation}\",\"funder\":null,\"globalLocationNumber\":null,\"hasOfferCatalog\":null,\"hasPOS\":null,\"isicV4\":null,\"legalName\":null,\"leiCode\":null,\"location\":null,\"logo\":{\"type\":\"ImageObject\",\"url\":\"{seomatic.site.identity.genericImage}\",\"width\":\"{seomatic.site.identity.genericImageWidth}\",\"height\":\"{seomatic.site.identity.genericImageHeight}\"},\"makesOffer\":null,\"member\":null,\"memberOf\":null,\"naics\":null,\"numberOfEmployees\":null,\"owns\":null,\"parentOrganization\":null,\"publishingPrinciples\":null,\"review\":null,\"seeks\":null,\"sponsor\":null,\"subOrganization\":null,\"taxID\":null,\"telephone\":\"{seomatic.site.identity.genericTelephone}\",\"unnamedSourcesPolicy\":null,\"vatID\":null,\"additionalType\":null,\"alternateName\":\"{seomatic.site.identity.genericAlternateName}\",\"description\":\"{seomatic.site.identity.genericDescription}\",\"disambiguatingDescription\":null,\"identifier\":null,\"image\":{\"type\":\"ImageObject\",\"url\":\"{seomatic.site.identity.genericImage}\",\"width\":\"{seomatic.site.identity.genericImageWidth}\",\"height\":\"{seomatic.site.identity.genericImageHeight}\"},\"mainEntityOfPage\":null,\"name\":\"{seomatic.site.identity.genericName}\",\"potentialAction\":null,\"sameAs\":null,\"url\":\"{seomatic.site.identity.genericUrl}\",\"context\":\"http://schema.org\",\"type\":\"{seomatic.site.identity.computedType}\",\"id\":\"{seomatic.site.identity.genericUrl}#identity\",\"include\":true,\"key\":\"identity\",\"environment\":null,\"dependencies\":null},\"creator\":{\"actionableFeedbackPolicy\":null,\"address\":{\"type\":\"PostalAddress\",\"streetAddress\":\"{seomatic.site.creator.genericStreetAddress}\",\"addressLocality\":\"{seomatic.site.creator.genericAddressLocality}\",\"addressRegion\":\"{seomatic.site.creator.genericAddressRegion}\",\"postalCode\":\"{seomatic.site.creator.genericPostalCode}\",\"addressCountry\":\"{seomatic.site.creator.genericAddressCountry}\"},\"aggregateRating\":null,\"alumni\":null,\"areaServed\":null,\"award\":null,\"brand\":null,\"contactPoint\":null,\"correctionsPolicy\":null,\"department\":null,\"dissolutionDate\":null,\"diversityPolicy\":null,\"duns\":\"{seomatic.site.creator.organizationDuns}\",\"email\":\"{seomatic.site.creator.genericEmail}\",\"employee\":null,\"ethicsPolicy\":null,\"event\":null,\"faxNumber\":null,\"founder\":\"{seomatic.site.creator.organizationFounder}\",\"foundingDate\":\"{seomatic.site.creator.organizationFoundingDate}\",\"foundingLocation\":\"{seomatic.site.creator.organizationFoundingLocation}\",\"funder\":null,\"globalLocationNumber\":null,\"hasOfferCatalog\":null,\"hasPOS\":null,\"isicV4\":null,\"legalName\":null,\"leiCode\":null,\"location\":null,\"logo\":{\"type\":\"ImageObject\",\"url\":\"{seomatic.site.creator.genericImage}\",\"width\":\"{seomatic.site.creator.genericImageWidth}\",\"height\":\"{seomatic.site.creator.genericImageHeight}\"},\"makesOffer\":null,\"member\":null,\"memberOf\":null,\"naics\":null,\"numberOfEmployees\":null,\"owns\":null,\"parentOrganization\":null,\"publishingPrinciples\":null,\"review\":null,\"seeks\":null,\"sponsor\":null,\"subOrganization\":null,\"taxID\":null,\"telephone\":\"{seomatic.site.creator.genericTelephone}\",\"unnamedSourcesPolicy\":null,\"vatID\":null,\"additionalType\":null,\"alternateName\":\"{seomatic.site.creator.genericAlternateName}\",\"description\":\"{seomatic.site.creator.genericDescription}\",\"disambiguatingDescription\":null,\"identifier\":null,\"image\":{\"type\":\"ImageObject\",\"url\":\"{seomatic.site.creator.genericImage}\",\"width\":\"{seomatic.site.creator.genericImageWidth}\",\"height\":\"{seomatic.site.creator.genericImageHeight}\"},\"mainEntityOfPage\":null,\"name\":\"{seomatic.site.creator.genericName}\",\"potentialAction\":null,\"sameAs\":null,\"url\":\"{seomatic.site.creator.genericUrl}\",\"context\":\"http://schema.org\",\"type\":\"{seomatic.site.creator.computedType}\",\"id\":\"{seomatic.site.creator.genericUrl}#creator\",\"include\":true,\"key\":\"creator\",\"environment\":null,\"dependencies\":null}},\"name\":\"General\",\"description\":\"JsonLd Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaJsonLdContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaTitleContainergeneral\":{\"data\":{\"title\":{\"title\":\"{seomatic.meta.seoTitle}\",\"siteName\":\"{seomatic.site.siteName}\",\"siteNamePosition\":\"{seomatic.meta.siteNamePosition}\",\"separatorChar\":\"{seomatic.config.separatorChar}\",\"include\":true,\"key\":\"title\",\"environment\":null,\"dependencies\":null}},\"name\":\"General\",\"description\":\"Meta Title Tag\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTitleContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]}}','[]','{\"data\":{\"humans\":{\"templateVersion\":\"1.0.0\",\"templateString\":\"/* TEAM */\\n\\nCreator: {{ seomatic.site.creator.genericName ?? \\\"n/a\\\" }}\\nURL: {{ seomatic.site.creator.genericUrl ?? \\\"n/a\\\" }}\\nDescription: {{ seomatic.site.creator.genericDescription ?? \\\"n/a\\\" }}\\n\\n/* THANKS */\\n\\nCraftCMS - https://craftcms.com\\nPixel & Tonic - https://pixelandtonic.com\\n\\n/* SITE */\\n\\nStandards: HTML5, CSS3\\nComponents: Craft CMS 3, Yii2, PHP, JavaScript, SEOmatic\\n\",\"siteId\":null,\"include\":true,\"handle\":\"humans\",\"path\":\"humans.txt\",\"template\":\"_frontend/pages/humans.twig\",\"controller\":\"frontend-template\",\"action\":\"humans\"},\"robots\":{\"templateVersion\":\"1.0.0\",\"templateString\":\"# robots.txt for {{ siteUrl }}\\n\\nSitemap: {{ seomatic.helper.sitemapIndexForSiteId() }}\\n{% switch seomatic.config.environment %}\\n\\n{% case \\\"live\\\" %}\\n\\n# live - don\'t allow web crawlers to index cpresources/ or vendor/\\n\\nUser-agent: *\\nDisallow: /cpresources/\\nDisallow: /vendor/\\nDisallow: /.env\\n\\n{% case \\\"staging\\\" %}\\n\\n# staging - disallow all\\n\\nUser-agent: *\\nDisallow: /\\n\\n{% case \\\"local\\\" %}\\n\\n# local - disallow all\\n\\nUser-agent: *\\nDisallow: /\\n\\n{% default %}\\n\\n# default - don\'t allow web crawlers to index cpresources/ or vendor/\\n\\nUser-agent: *\\nDisallow: /cpresources/\\nDisallow: /vendor/\\nDisallow: /.env\\n\\n{% endswitch %}\\n\",\"siteId\":null,\"include\":true,\"handle\":\"robots\",\"path\":\"robots.txt\",\"template\":\"_frontend/pages/robots.twig\",\"controller\":\"frontend-template\",\"action\":\"robots\"}},\"name\":\"Frontend Templates\",\"description\":\"Templates that are rendered on the frontend\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\FrontendTemplateContainer\",\"handle\":\"SeomaticEditableTemplate\",\"include\":true,\"dependencies\":null}','{\"siteType\":\"CreativeWork\",\"siteSubType\":\"WebSite\",\"siteSpecificType\":\"none\",\"seoTitleSource\":\"fromCustom\",\"seoTitleField\":\"\",\"siteNamePositionSource\":\"fromCustom\",\"seoDescriptionSource\":\"fromCustom\",\"seoDescriptionField\":\"\",\"seoKeywordsSource\":\"fromCustom\",\"seoKeywordsField\":\"\",\"seoImageIds\":\"\",\"seoImageSource\":\"fromAsset\",\"seoImageField\":\"\",\"seoImageTransform\":\"1\",\"seoImageDescriptionSource\":\"fromCustom\",\"seoImageDescriptionField\":\"\",\"twitterCreatorSource\":\"sameAsSite\",\"twitterCreatorField\":\"\",\"twitterTitleSource\":\"sameAsSeo\",\"twitterTitleField\":\"\",\"twitterSiteNamePositionSource\":\"fromCustom\",\"twitterDescriptionSource\":\"sameAsSeo\",\"twitterDescriptionField\":\"\",\"twitterImageIds\":[],\"twitterImageSource\":\"sameAsSeo\",\"twitterImageField\":\"\",\"twitterImageTransform\":true,\"twitterImageDescriptionSource\":\"sameAsSeo\",\"twitterImageDescriptionField\":\"\",\"ogTitleSource\":\"sameAsSeo\",\"ogTitleField\":\"\",\"ogSiteNamePositionSource\":\"fromCustom\",\"ogDescriptionSource\":\"sameAsSeo\",\"ogDescriptionField\":\"\",\"ogImageIds\":[],\"ogImageSource\":\"sameAsSeo\",\"ogImageField\":\"\",\"ogImageTransform\":true,\"ogImageDescriptionSource\":\"sameAsSeo\",\"ogImageDescriptionField\":\"\"}'),
	(2,'2018-05-15 20:16:26','2018-05-15 20:17:25','1df1aa14-4653-4b6b-be0b-bd2dc88ec2f5','1.0.25','section',1,'Home Page','homePage','single','index',1,'{\"1\":{\"id\":1,\"sectionId\":null,\"siteId\":\"1\",\"enabledByDefault\":true,\"hasUrls\":true,\"uriFormat\":\"__home__\",\"template\":\"index\",\"language\":\"en-us\"}}','2018-05-15 20:16:26','{\"language\":null,\"mainEntityOfPage\":\"WebPage\",\"seoTitle\":\"*Content Title* for Home Page\",\"siteNamePosition\":\"\",\"seoDescription\":\"\",\"seoKeywords\":\"\",\"seoImage\":\"\",\"seoImageDescription\":\"\",\"canonicalUrl\":\"{entry.url}\",\"robots\":\"all\",\"ogType\":\"website\",\"ogTitle\":\"{seomatic.meta.seoTitle}\",\"ogSiteNamePosition\":\"none\",\"ogDescription\":\"{seomatic.meta.seoDescription}\",\"ogImage\":\"{seomatic.meta.seoImage}\",\"ogImageDescription\":\"{seomatic.meta.seoImageDescription}\",\"twitterCard\":\"summary_large_image\",\"twitterCreator\":\"{seomatic.site.twitterHandle}\",\"twitterTitle\":\"{seomatic.meta.seoTitle}\",\"twitterSiteNamePosition\":\"none\",\"twitterDescription\":\"{seomatic.meta.seoDescription}\",\"twitterImage\":\"{seomatic.meta.seoImage}\",\"twitterImageDescription\":\"{seomatic.meta.seoImageDescription}\"}','{\"siteName\":\"Testing Site\",\"identity\":null,\"creator\":null,\"twitterHandle\":\"\",\"facebookProfileId\":\"\",\"facebookAppId\":\"\",\"googleSiteVerification\":\"\",\"bingSiteVerification\":\"\",\"pinterestSiteVerification\":\"\",\"sameAsLinks\":[],\"siteLinksSearchTarget\":\"\",\"siteLinksQueryInput\":\"\"}','{\"sitemapUrls\":true,\"sitemapAssets\":true,\"sitemapFiles\":true,\"sitemapAltLinks\":true,\"sitemapChangeFreq\":\"weekly\",\"sitemapPriority\":0.5,\"sitemapLimit\":null,\"sitemapImageFieldMap\":[{\"property\":\"title\",\"field\":\"title\"},{\"property\":\"caption\",\"field\":\"\"},{\"property\":\"geo_location\",\"field\":\"\"},{\"property\":\"license\",\"field\":\"\"}],\"sitemapVideoFieldMap\":[{\"property\":\"title\",\"field\":\"title\"},{\"property\":\"description\",\"field\":\"\"},{\"property\":\"thumbnailLoc\",\"field\":\"\"},{\"property\":\"duration\",\"field\":\"\"},{\"property\":\"category\",\"field\":\"\"}]}','{\"MetaTagContainergeneral\":{\"data\":[],\"name\":\"General\",\"description\":\"General Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaTagContaineropengraph\":{\"data\":[],\"name\":\"Facebook\",\"description\":\"Facebook OpenGraph Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"opengraph\",\"include\":true,\"dependencies\":[]},\"MetaTagContainertwitter\":{\"data\":[],\"name\":\"Twitter\",\"description\":\"Twitter Card Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"twitter\",\"include\":true,\"dependencies\":[]},\"MetaTagContainermiscellaneous\":{\"data\":[],\"name\":\"Miscellaneous\",\"description\":\"Miscellaneous Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"miscellaneous\",\"include\":true,\"dependencies\":[]},\"MetaLinkContainergeneral\":{\"data\":[],\"name\":\"General\",\"description\":\"Link Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaLinkContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaScriptContainergeneral\":{\"data\":[],\"position\":1,\"name\":\"General\",\"description\":\"Script Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaScriptContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaJsonLdContainergeneral\":{\"data\":{\"mainEntityOfPage\":{\"breadcrumb\":null,\"lastReviewed\":null,\"mainContentOfPage\":null,\"primaryImageOfPage\":null,\"relatedLink\":null,\"reviewedBy\":null,\"significantLink\":null,\"speakable\":null,\"specialty\":null,\"about\":null,\"accessMode\":null,\"accessModeSufficient\":null,\"accessibilityAPI\":null,\"accessibilityControl\":null,\"accessibilityFeature\":null,\"accessibilityHazard\":null,\"accessibilitySummary\":null,\"accountablePerson\":null,\"aggregateRating\":null,\"alternativeHeadline\":null,\"associatedMedia\":null,\"audience\":null,\"audio\":null,\"author\":{\"id\":\"{seomatic.site.identity.genericUrl}#identity\"},\"award\":null,\"character\":null,\"citation\":null,\"comment\":null,\"commentCount\":null,\"contentLocation\":null,\"contentRating\":null,\"contentReferenceTime\":null,\"contributor\":null,\"copyrightHolder\":{\"id\":\"{seomatic.site.identity.genericUrl}#identity\"},\"copyrightYear\":\"{entry.postDate |atom}\",\"creator\":{\"id\":\"{seomatic.site.identity.genericUrl}#creator\"},\"dateCreated\":false,\"dateModified\":\"{entry.dateUpdated |atom}\",\"datePublished\":\"{entry.postDate |atom}\",\"discussionUrl\":null,\"editor\":null,\"educationalAlignment\":null,\"educationalUse\":null,\"encoding\":null,\"exampleOfWork\":null,\"expires\":null,\"fileFormat\":null,\"funder\":null,\"genre\":null,\"hasPart\":null,\"headline\":\"{seomatic.meta.seoTitle}\",\"inLanguage\":\"{seomatic.meta.language}\",\"interactionStatistic\":null,\"interactivityType\":null,\"isAccessibleForFree\":null,\"isBasedOn\":null,\"isFamilyFriendly\":null,\"isPartOf\":null,\"keywords\":null,\"learningResourceType\":null,\"license\":null,\"locationCreated\":null,\"mainEntity\":null,\"material\":null,\"mentions\":null,\"offers\":null,\"position\":null,\"producer\":null,\"provider\":null,\"publication\":null,\"publisher\":{\"id\":\"{seomatic.site.identity.genericUrl}#creator\"},\"publisherImprint\":null,\"publishingPrinciples\":null,\"recordedAt\":null,\"releasedEvent\":null,\"review\":null,\"schemaVersion\":null,\"sourceOrganization\":null,\"spatialCoverage\":null,\"sponsor\":null,\"temporalCoverage\":null,\"text\":null,\"thumbnailUrl\":null,\"timeRequired\":null,\"translationOfWork\":null,\"translator\":null,\"typicalAgeRange\":null,\"version\":null,\"video\":null,\"workExample\":null,\"workTranslation\":null,\"additionalType\":null,\"alternateName\":null,\"description\":\"{seomatic.meta.seoDescription}\",\"disambiguatingDescription\":null,\"identifier\":null,\"image\":{\"type\":\"ImageObject\",\"url\":\"{seomatic.meta.seoImage}\"},\"mainEntityOfPage\":\"{seomatic.meta.canonicalUrl}\",\"name\":\"{seomatic.meta.seoTitle}\",\"potentialAction\":{\"type\":\"SearchAction\",\"target\":\"{seomatic.site.siteLinksSearchTarget}\",\"query-input\":\"{seomatic.site.siteLinksQueryInput}\"},\"sameAs\":null,\"url\":\"{seomatic.meta.canonicalUrl}\",\"context\":\"http://schema.org\",\"type\":\"{seomatic.meta.mainEntityOfPage}\",\"id\":null,\"include\":true,\"key\":\"mainEntityOfPage\",\"environment\":null,\"dependencies\":null}},\"name\":\"General\",\"description\":\"JsonLd Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaJsonLdContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaTitleContainergeneral\":{\"data\":{\"title\":{\"title\":\"{seomatic.meta.seoTitle}\",\"siteName\":\"{seomatic.site.siteName}\",\"siteNamePosition\":\"{seomatic.meta.siteNamePosition}\",\"separatorChar\":\"{seomatic.config.separatorChar}\",\"include\":true,\"key\":\"title\",\"environment\":null,\"dependencies\":null}},\"name\":\"General\",\"description\":\"Meta Title Tag\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTitleContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]}}','[]','{\"data\":[],\"name\":null,\"description\":null,\"class\":\"nystudio107\\\\seomatic\\\\models\\\\FrontendTemplateContainer\",\"handle\":null,\"include\":true,\"dependencies\":null}','{\"siteType\":\"CreativeWork\",\"siteSubType\":\"WebPage\",\"siteSpecificType\":\"none\",\"seoTitleSource\":\"fromCustom\",\"seoTitleField\":\"title\",\"siteNamePositionSource\":\"sameAsGlobal\",\"seoDescriptionSource\":\"fromCustom\",\"seoDescriptionField\":\"title\",\"seoKeywordsSource\":\"fromCustom\",\"seoKeywordsField\":\"title\",\"seoImageIds\":\"\",\"seoImageSource\":\"fromAsset\",\"seoImageField\":\"\",\"seoImageTransform\":\"1\",\"seoImageDescriptionSource\":\"fromCustom\",\"seoImageDescriptionField\":\"title\",\"twitterCreatorSource\":\"sameAsSite\",\"twitterCreatorField\":\"\",\"twitterTitleSource\":\"sameAsSeo\",\"twitterTitleField\":\"\",\"twitterSiteNamePositionSource\":\"sameAsGlobal\",\"twitterDescriptionSource\":\"sameAsSeo\",\"twitterDescriptionField\":\"\",\"twitterImageIds\":[],\"twitterImageSource\":\"sameAsSeo\",\"twitterImageField\":\"\",\"twitterImageTransform\":true,\"twitterImageDescriptionSource\":\"sameAsSeo\",\"twitterImageDescriptionField\":\"\",\"ogTitleSource\":\"sameAsSeo\",\"ogTitleField\":\"\",\"ogSiteNamePositionSource\":\"sameAsGlobal\",\"ogDescriptionSource\":\"sameAsSeo\",\"ogDescriptionField\":\"\",\"ogImageIds\":[],\"ogImageSource\":\"sameAsSeo\",\"ogImageField\":\"\",\"ogImageTransform\":true,\"ogImageDescriptionSource\":\"sameAsSeo\",\"ogImageDescriptionField\":\"\"}'),
	(3,'2018-05-15 20:16:41','2018-05-15 20:17:57','654b45b4-229c-4b63-bcf2-4511887c947c','1.0.25','section',2,'Pricing','pricing','single','pricing',1,'{\"1\":{\"id\":2,\"sectionId\":null,\"siteId\":\"1\",\"enabledByDefault\":true,\"hasUrls\":true,\"uriFormat\":\"pricing\",\"template\":\"pricing\",\"language\":\"en-us\"}}','2018-05-15 20:16:41','{\"language\":null,\"mainEntityOfPage\":\"WebPage\",\"seoTitle\":\"*Content* title for Pricing\",\"siteNamePosition\":\"\",\"seoDescription\":\"\",\"seoKeywords\":\"\",\"seoImage\":\"\",\"seoImageDescription\":\"\",\"canonicalUrl\":\"{entry.url}\",\"robots\":\"all\",\"ogType\":\"website\",\"ogTitle\":\"{seomatic.meta.seoTitle}\",\"ogSiteNamePosition\":\"none\",\"ogDescription\":\"{seomatic.meta.seoDescription}\",\"ogImage\":\"{seomatic.meta.seoImage}\",\"ogImageDescription\":\"{seomatic.meta.seoImageDescription}\",\"twitterCard\":\"summary_large_image\",\"twitterCreator\":\"{seomatic.site.twitterHandle}\",\"twitterTitle\":\"{seomatic.meta.seoTitle}\",\"twitterSiteNamePosition\":\"none\",\"twitterDescription\":\"{seomatic.meta.seoDescription}\",\"twitterImage\":\"{seomatic.meta.seoImage}\",\"twitterImageDescription\":\"{seomatic.meta.seoImageDescription}\"}','{\"siteName\":\"Testing Site\",\"identity\":null,\"creator\":null,\"twitterHandle\":\"\",\"facebookProfileId\":\"\",\"facebookAppId\":\"\",\"googleSiteVerification\":\"\",\"bingSiteVerification\":\"\",\"pinterestSiteVerification\":\"\",\"sameAsLinks\":[],\"siteLinksSearchTarget\":\"\",\"siteLinksQueryInput\":\"\"}','{\"sitemapUrls\":true,\"sitemapAssets\":true,\"sitemapFiles\":true,\"sitemapAltLinks\":true,\"sitemapChangeFreq\":\"weekly\",\"sitemapPriority\":0.5,\"sitemapLimit\":null,\"sitemapImageFieldMap\":[{\"property\":\"title\",\"field\":\"title\"},{\"property\":\"caption\",\"field\":\"\"},{\"property\":\"geo_location\",\"field\":\"\"},{\"property\":\"license\",\"field\":\"\"}],\"sitemapVideoFieldMap\":[{\"property\":\"title\",\"field\":\"title\"},{\"property\":\"description\",\"field\":\"\"},{\"property\":\"thumbnailLoc\",\"field\":\"\"},{\"property\":\"duration\",\"field\":\"\"},{\"property\":\"category\",\"field\":\"\"}]}','{\"MetaTagContainergeneral\":{\"data\":[],\"name\":\"General\",\"description\":\"General Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaTagContaineropengraph\":{\"data\":[],\"name\":\"Facebook\",\"description\":\"Facebook OpenGraph Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"opengraph\",\"include\":true,\"dependencies\":[]},\"MetaTagContainertwitter\":{\"data\":[],\"name\":\"Twitter\",\"description\":\"Twitter Card Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"twitter\",\"include\":true,\"dependencies\":[]},\"MetaTagContainermiscellaneous\":{\"data\":[],\"name\":\"Miscellaneous\",\"description\":\"Miscellaneous Meta Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTagContainer\",\"handle\":\"miscellaneous\",\"include\":true,\"dependencies\":[]},\"MetaLinkContainergeneral\":{\"data\":[],\"name\":\"General\",\"description\":\"Link Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaLinkContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaScriptContainergeneral\":{\"data\":[],\"position\":1,\"name\":\"General\",\"description\":\"Script Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaScriptContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaJsonLdContainergeneral\":{\"data\":{\"mainEntityOfPage\":{\"breadcrumb\":null,\"lastReviewed\":null,\"mainContentOfPage\":null,\"primaryImageOfPage\":null,\"relatedLink\":null,\"reviewedBy\":null,\"significantLink\":null,\"speakable\":null,\"specialty\":null,\"about\":null,\"accessMode\":null,\"accessModeSufficient\":null,\"accessibilityAPI\":null,\"accessibilityControl\":null,\"accessibilityFeature\":null,\"accessibilityHazard\":null,\"accessibilitySummary\":null,\"accountablePerson\":null,\"aggregateRating\":null,\"alternativeHeadline\":null,\"associatedMedia\":null,\"audience\":null,\"audio\":null,\"author\":{\"id\":\"{seomatic.site.identity.genericUrl}#identity\"},\"award\":null,\"character\":null,\"citation\":null,\"comment\":null,\"commentCount\":null,\"contentLocation\":null,\"contentRating\":null,\"contentReferenceTime\":null,\"contributor\":null,\"copyrightHolder\":{\"id\":\"{seomatic.site.identity.genericUrl}#identity\"},\"copyrightYear\":\"{entry.postDate |atom}\",\"creator\":{\"id\":\"{seomatic.site.identity.genericUrl}#creator\"},\"dateCreated\":false,\"dateModified\":\"{entry.dateUpdated |atom}\",\"datePublished\":\"{entry.postDate |atom}\",\"discussionUrl\":null,\"editor\":null,\"educationalAlignment\":null,\"educationalUse\":null,\"encoding\":null,\"exampleOfWork\":null,\"expires\":null,\"fileFormat\":null,\"funder\":null,\"genre\":null,\"hasPart\":null,\"headline\":\"{seomatic.meta.seoTitle}\",\"inLanguage\":\"{seomatic.meta.language}\",\"interactionStatistic\":null,\"interactivityType\":null,\"isAccessibleForFree\":null,\"isBasedOn\":null,\"isFamilyFriendly\":null,\"isPartOf\":null,\"keywords\":null,\"learningResourceType\":null,\"license\":null,\"locationCreated\":null,\"mainEntity\":null,\"material\":null,\"mentions\":null,\"offers\":null,\"position\":null,\"producer\":null,\"provider\":null,\"publication\":null,\"publisher\":{\"id\":\"{seomatic.site.identity.genericUrl}#creator\"},\"publisherImprint\":null,\"publishingPrinciples\":null,\"recordedAt\":null,\"releasedEvent\":null,\"review\":null,\"schemaVersion\":null,\"sourceOrganization\":null,\"spatialCoverage\":null,\"sponsor\":null,\"temporalCoverage\":null,\"text\":null,\"thumbnailUrl\":null,\"timeRequired\":null,\"translationOfWork\":null,\"translator\":null,\"typicalAgeRange\":null,\"version\":null,\"video\":null,\"workExample\":null,\"workTranslation\":null,\"additionalType\":null,\"alternateName\":null,\"description\":\"{seomatic.meta.seoDescription}\",\"disambiguatingDescription\":null,\"identifier\":null,\"image\":{\"type\":\"ImageObject\",\"url\":\"{seomatic.meta.seoImage}\"},\"mainEntityOfPage\":\"{seomatic.meta.canonicalUrl}\",\"name\":\"{seomatic.meta.seoTitle}\",\"potentialAction\":{\"type\":\"SearchAction\",\"target\":\"{seomatic.site.siteLinksSearchTarget}\",\"query-input\":\"{seomatic.site.siteLinksQueryInput}\"},\"sameAs\":null,\"url\":\"{seomatic.meta.canonicalUrl}\",\"context\":\"http://schema.org\",\"type\":\"{seomatic.meta.mainEntityOfPage}\",\"id\":null,\"include\":true,\"key\":\"mainEntityOfPage\",\"environment\":null,\"dependencies\":null}},\"name\":\"General\",\"description\":\"JsonLd Tags\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaJsonLdContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]},\"MetaTitleContainergeneral\":{\"data\":{\"title\":{\"title\":\"{seomatic.meta.seoTitle}\",\"siteName\":\"{seomatic.site.siteName}\",\"siteNamePosition\":\"{seomatic.meta.siteNamePosition}\",\"separatorChar\":\"{seomatic.config.separatorChar}\",\"include\":true,\"key\":\"title\",\"environment\":null,\"dependencies\":null}},\"name\":\"General\",\"description\":\"Meta Title Tag\",\"class\":\"nystudio107\\\\seomatic\\\\models\\\\MetaTitleContainer\",\"handle\":\"general\",\"include\":true,\"dependencies\":[]}}','[]','{\"data\":[],\"name\":null,\"description\":null,\"class\":\"nystudio107\\\\seomatic\\\\models\\\\FrontendTemplateContainer\",\"handle\":null,\"include\":true,\"dependencies\":null}','{\"siteType\":\"CreativeWork\",\"siteSubType\":\"WebPage\",\"siteSpecificType\":\"none\",\"seoTitleSource\":\"fromCustom\",\"seoTitleField\":\"title\",\"siteNamePositionSource\":\"sameAsGlobal\",\"seoDescriptionSource\":\"fromCustom\",\"seoDescriptionField\":\"title\",\"seoKeywordsSource\":\"fromCustom\",\"seoKeywordsField\":\"title\",\"seoImageIds\":\"\",\"seoImageSource\":\"fromAsset\",\"seoImageField\":\"\",\"seoImageTransform\":\"1\",\"seoImageDescriptionSource\":\"fromCustom\",\"seoImageDescriptionField\":\"title\",\"twitterCreatorSource\":\"sameAsSite\",\"twitterCreatorField\":\"\",\"twitterTitleSource\":\"sameAsSeo\",\"twitterTitleField\":\"\",\"twitterSiteNamePositionSource\":\"sameAsGlobal\",\"twitterDescriptionSource\":\"sameAsSeo\",\"twitterDescriptionField\":\"\",\"twitterImageIds\":[],\"twitterImageSource\":\"sameAsSeo\",\"twitterImageField\":\"\",\"twitterImageTransform\":true,\"twitterImageDescriptionSource\":\"sameAsSeo\",\"twitterImageDescriptionField\":\"\",\"ogTitleSource\":\"sameAsSeo\",\"ogTitleField\":\"\",\"ogSiteNamePositionSource\":\"sameAsGlobal\",\"ogDescriptionSource\":\"sameAsSeo\",\"ogDescriptionField\":\"\",\"ogImageIds\":[],\"ogImageSource\":\"sameAsSeo\",\"ogImageField\":\"\",\"ogImageTransform\":true,\"ogImageDescriptionSource\":\"sameAsSeo\",\"ogImageDescriptionField\":\"\"}');

/*!40000 ALTER TABLE `seomatic_metabundles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `token` char(100) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sessions_uid_idx` (`uid`),
  KEY `sessions_token_idx` (`token`),
  KEY `sessions_dateUpdated_idx` (`dateUpdated`),
  KEY `sessions_userId_idx` (`userId`),
  CONSTRAINT `sessions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;

INSERT INTO `sessions` (`id`, `userId`, `token`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'EQIpmx7yDygYnN0BC5cARUiPGxCx_pfrUHhVGHMSzUM7PnX8V5nS1JaL0SyaDK_ocw8TrPGEYXM5pdaDnzm3Jw3rsBavpSxzOn8p','2018-04-24 15:49:44','2018-04-24 16:18:17','0702e7c0-73aa-4a23-b78f-e3be91029720'),
	(2,1,'s3HIaOPowBYsfqLqj-JUv3UaUJa9HpotdWjyRvzR3xGZ98Dnr54vBHwU6DXCIL8DfvHYKtyTJ93OBkV8Sr2GWbQAso1v1j5UzTKq','2018-04-27 13:46:43','2018-04-27 13:58:06','0bc99497-0504-4d63-9296-4dd4c81709c0'),
	(4,1,'rBTKBJuUKWsgWbOHg2xOe9eNr9bj7S6wV2Mpr_iLvuMp-CHy6aNzm-AntGNXaPK0mbbApFP7H5sDDnV3dcjW5p5fIKM0w4VUF4z_','2018-05-02 13:07:30','2018-05-02 13:35:31','8ce7ed16-fd9d-4351-b9b0-c66728d04a09'),
	(5,1,'AauT2zijiCwfd4XrqQNhgyT1IImxSfrqsOSxgBWWQhjxtk9kNxenwyL47F26a8yxEhusm1Q-jtvvnTpDUU8NIh6Bh7vNkO1h_562','2018-05-15 19:59:21','2018-05-15 21:04:18','a2abd617-225c-4160-a9c8-c4f74cfae4de');

/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table shunnedmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shunnedmessages`;

CREATE TABLE `shunnedmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shunnedmessages_userId_message_unq_idx` (`userId`,`message`),
  CONSTRAINT `shunnedmessages_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table sitegroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sitegroups`;

CREATE TABLE `sitegroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sitegroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sitegroups` WRITE;
/*!40000 ALTER TABLE `sitegroups` DISABLE KEYS */;

INSERT INTO `sitegroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Testing Site','2018-04-23 17:28:21','2018-04-23 17:28:21','cbad09c4-87b5-4e7d-9b51-31ca85e67561');

/*!40000 ALTER TABLE `sitegroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sites`;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `language` varchar(12) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '0',
  `baseUrl` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sites_handle_unq_idx` (`handle`),
  KEY `sites_sortOrder_idx` (`sortOrder`),
  KEY `sites_groupId_fk` (`groupId`),
  CONSTRAINT `sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `sitegroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;

INSERT INTO `sites` (`id`, `groupId`, `primary`, `name`, `handle`, `language`, `hasUrls`, `baseUrl`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,'Testing Site','default','en-US',1,'@web/',1,'2018-04-23 17:28:21','2018-04-23 17:28:21','777e9820-b1d1-419f-b74f-596f43eba354');

/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table structureelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `structureelements`;

CREATE TABLE `structureelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `elementId` int(11) DEFAULT NULL,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `structureelements_structureId_elementId_unq_idx` (`structureId`,`elementId`),
  KEY `structureelements_root_idx` (`root`),
  KEY `structureelements_lft_idx` (`lft`),
  KEY `structureelements_rgt_idx` (`rgt`),
  KEY `structureelements_level_idx` (`level`),
  KEY `structureelements_elementId_idx` (`elementId`),
  CONSTRAINT `structureelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `structureelements_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table structures
# ------------------------------------------------------------

DROP TABLE IF EXISTS `structures`;

CREATE TABLE `structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table systemmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `systemmessages`;

CREATE TABLE `systemmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemmessages_key_language_unq_idx` (`key`,`language`),
  KEY `systemmessages_language_idx` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table systemsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `systemsettings`;

CREATE TABLE `systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `systemsettings` WRITE;
/*!40000 ALTER TABLE `systemsettings` DISABLE KEYS */;

INSERT INTO `systemsettings` (`id`, `category`, `settings`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'email','{\"fromEmail\":\"rosanarufer@gmail.com\",\"fromName\":\"Testing Site\",\"transportType\":\"craft\\\\mail\\\\transportadapters\\\\Sendmail\"}','2018-04-23 17:28:24','2018-04-23 17:28:24','e2530431-bc35-4b9a-bacf-14bb4e85671c');

/*!40000 ALTER TABLE `systemsettings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table taggroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `taggroups`;

CREATE TABLE `taggroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggroups_name_unq_idx` (`name`),
  UNIQUE KEY `taggroups_handle_unq_idx` (`handle`),
  KEY `taggroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `taggroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tags`;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tags_groupId_idx` (`groupId`),
  CONSTRAINT `tags_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `taggroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tags_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table templatecacheelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templatecacheelements`;

CREATE TABLE `templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `templatecacheelements_cacheId_idx` (`cacheId`),
  KEY `templatecacheelements_elementId_idx` (`elementId`),
  CONSTRAINT `templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table templatecachequeries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templatecachequeries`;

CREATE TABLE `templatecachequeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `query` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecachequeries_cacheId_idx` (`cacheId`),
  KEY `templatecachequeries_type_idx` (`type`),
  CONSTRAINT `templatecachequeries_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table templatecaches
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templatecaches`;

CREATE TABLE `templatecaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) NOT NULL,
  `cacheKey` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `body` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_path_idx` (`cacheKey`,`siteId`,`expiryDate`,`path`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_idx` (`cacheKey`,`siteId`,`expiryDate`),
  KEY `templatecaches_siteId_idx` (`siteId`),
  CONSTRAINT `templatecaches_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tokens`;

CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` char(32) NOT NULL,
  `route` text,
  `usageLimit` tinyint(3) unsigned DEFAULT NULL,
  `usageCount` tinyint(3) unsigned DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokens_token_unq_idx` (`token`),
  KEY `tokens_expiryDate_idx` (`expiryDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `usergroups`;

CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_handle_unq_idx` (`handle`),
  UNIQUE KEY `usergroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table usergroups_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `usergroups_users`;

CREATE TABLE `usergroups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_users_groupId_userId_unq_idx` (`groupId`,`userId`),
  KEY `usergroups_users_userId_idx` (`userId`),
  CONSTRAINT `usergroups_users_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usergroups_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpermissions`;

CREATE TABLE `userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpermissions_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpermissions_usergroups`;

CREATE TABLE `userpermissions_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_usergroups_permissionId_groupId_unq_idx` (`permissionId`,`groupId`),
  KEY `userpermissions_usergroups_groupId_idx` (`groupId`),
  CONSTRAINT `userpermissions_usergroups_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_usergroups_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpermissions_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpermissions_users`;

CREATE TABLE `userpermissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_users_permissionId_userId_unq_idx` (`permissionId`,`userId`),
  KEY `userpermissions_users_userId_idx` (`userId`),
  CONSTRAINT `userpermissions_users_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpreferences
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpreferences`;

CREATE TABLE `userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `userpreferences` WRITE;
/*!40000 ALTER TABLE `userpreferences` DISABLE KEYS */;

INSERT INTO `userpreferences` (`userId`, `preferences`)
VALUES
	(1,'{\"language\":\"en-US\"}');

/*!40000 ALTER TABLE `userpreferences` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `photoId` int(11) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `pending` tinyint(1) NOT NULL DEFAULT '0',
  `lastLoginDate` datetime DEFAULT NULL,
  `lastLoginAttemptIp` varchar(45) DEFAULT NULL,
  `invalidLoginWindowStart` datetime DEFAULT NULL,
  `invalidLoginCount` tinyint(3) unsigned DEFAULT NULL,
  `lastInvalidLoginDate` datetime DEFAULT NULL,
  `lockoutDate` datetime DEFAULT NULL,
  `hasDashboard` tinyint(1) NOT NULL DEFAULT '0',
  `verificationCode` varchar(255) DEFAULT NULL,
  `verificationCodeIssuedDate` datetime DEFAULT NULL,
  `unverifiedEmail` varchar(255) DEFAULT NULL,
  `passwordResetRequired` tinyint(1) NOT NULL DEFAULT '0',
  `lastPasswordChangeDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unq_idx` (`username`),
  UNIQUE KEY `users_email_unq_idx` (`email`),
  KEY `users_uid_idx` (`uid`),
  KEY `users_verificationCode_idx` (`verificationCode`),
  KEY `users_photoId_fk` (`photoId`),
  CONSTRAINT `users_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_photoId_fk` FOREIGN KEY (`photoId`) REFERENCES `assets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `username`, `photoId`, `firstName`, `lastName`, `email`, `password`, `admin`, `locked`, `suspended`, `pending`, `lastLoginDate`, `lastLoginAttemptIp`, `invalidLoginWindowStart`, `invalidLoginCount`, `lastInvalidLoginDate`, `lockoutDate`, `hasDashboard`, `verificationCode`, `verificationCodeIssuedDate`, `unverifiedEmail`, `passwordResetRequired`, `lastPasswordChangeDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Rosana',NULL,NULL,NULL,'rosanarufer@gmail.com','$2y$13$ihB..4uAOYkK9RyOI0zCF.YwW8n4B5oi/YBCEN2Gqfmc64DzcChsS',1,0,0,0,'2018-05-15 19:59:21','127.0.0.1',NULL,NULL,'2018-05-15 19:59:07',NULL,1,NULL,NULL,NULL,0,'2018-04-23 17:28:24','2018-04-23 17:28:24','2018-05-15 19:59:21','aa34ff90-6ea5-404f-8e89-4f8f313bafbb');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table volumefolders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `volumefolders`;

CREATE TABLE `volumefolders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumefolders_name_parentId_volumeId_unq_idx` (`name`,`parentId`,`volumeId`),
  KEY `volumefolders_parentId_idx` (`parentId`),
  KEY `volumefolders_volumeId_idx` (`volumeId`),
  CONSTRAINT `volumefolders_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `volumefolders_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table volumes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `volumes`;

CREATE TABLE `volumes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `url` varchar(255) DEFAULT NULL,
  `settings` text,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumes_name_unq_idx` (`name`),
  UNIQUE KEY `volumes_handle_unq_idx` (`handle`),
  KEY `volumes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `volumes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table widgets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `widgets`;

CREATE TABLE `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `colspan` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `widgets_userId_idx` (`userId`),
  CONSTRAINT `widgets_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `widgets` WRITE;
/*!40000 ALTER TABLE `widgets` DISABLE KEYS */;

INSERT INTO `widgets` (`id`, `userId`, `type`, `sortOrder`, `colspan`, `settings`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'craft\\widgets\\RecentEntries',1,0,'{\"section\":\"*\",\"siteId\":\"1\",\"limit\":10}','2018-04-23 17:28:25','2018-04-23 17:28:25','bd8c89e0-ad52-4ce7-b3f4-79c86946014b'),
	(2,1,'craft\\widgets\\CraftSupport',2,0,'[]','2018-04-23 17:28:25','2018-04-23 17:28:25','f32d847d-73b2-4f25-a053-95eed76072ef'),
	(3,1,'craft\\widgets\\Updates',3,0,'[]','2018-04-23 17:28:25','2018-04-23 17:28:25','8b4f056d-d177-42f8-be78-7810645c6203'),
	(4,1,'craft\\widgets\\Feed',4,0,'{\"url\":\"https://craftcms.com/news.rss\",\"title\":\"Craft News\",\"limit\":5}','2018-04-23 17:28:25','2018-04-23 17:28:25','14d0d7d3-2a37-40d3-a49b-9c3c2126430e');

/*!40000 ALTER TABLE `widgets` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
