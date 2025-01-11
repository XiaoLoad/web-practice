-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: farm_system
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `farm_system`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `farm_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `farm_system`;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '账号',
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `avatar` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `role` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='管理员信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','admin','管理员','http://localhost:9090/files/download/avatar.png','ADMIN');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='农产品分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'蔬菜'),(2,'水果'),(3,'农副产品'),(4,'菌菇');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `img` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
  `descr` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简介',
  `specials` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '特色',
  `price` decimal(10,2) DEFAULT NULL COMMENT '单价',
  `unit` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `store` int DEFAULT NULL COMMENT '库存量',
  `category_id` int DEFAULT NULL COMMENT '分类',
  `shelf_life` int DEFAULT NULL COMMENT '保质期',
  `manufacturer` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生产厂家\n',
  `production_date` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生产日期',
  `sales_volume` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='农产品信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES (1,'新鲜土豆','http://localhost:9090/files/download/1720146768626-土豆1.png','新鲜土豆，产自海南，好吃不贵','香甜软糯，口口留香',0.85,'斤',2193,1,12,'昆明艾尔饲料厂','2024-01-01 12:00:00',34234),(2,'西红柿','http://localhost:9090/files/download/1720146162330-西红柿.png','新疆普罗旺斯沙瓤西红柿，新鲜上市','香糯软沙，满口留香',9.90,'kg',1098,1,12,'昆明艾尔饲料厂','2024-11-18 16:30:00',2341),(4,'黄桃','http://localhost:9090/files/download/1720164318655-黄桃.png','山东蒙阴黄桃新鲜水果桃子黄金蜜桃黄毛桃','出口品质，山泉灌溉',5.88,'斤',991,2,12,'北京克拉玛依饲料有限公司','2024-10-15 15:30:00',0),(5,'美都西瓜','http://localhost:9090/files/download/1720164348761-西瓜.png','超甜美都西瓜8424美都现摘薄皮无籽有籽当季新鲜水果超甜美都西瓜8424美都现摘薄皮无籽有籽当季新鲜水果','花样吃法，口感更佳',21.99,'个',654,2,12,'重庆可丽尔饲料有限公司','2024-11-12 16:30:00',0),(6,'一口一口派大星','http://localhost:9090/files/download/1734262898038-猫咪.png','吃了长脑子','没啥特色，特别没脑子，粉色,好吃',12.00,'个',58,2,12,'重庆可丽尔饲料有限公司','2024-08-14 16:30:00',0),(9,'213213','http://localhost:9090/files/download/1734263142138-c6bf1e7344e6283436bef68b46abcec.jpg','21321','321313',1231.00,'1231',3123,4,131,'312313','1313',0);
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_stock`
--

DROP TABLE IF EXISTS `goods_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods_stock` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_id` int DEFAULT NULL COMMENT '商品ID',
  `num` int DEFAULT NULL COMMENT '进货数量',
  `channel` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '进货渠道',
  `date` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '进货日期',
  `comment` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='农产品进货';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_stock`
--

LOCK TABLES `goods_stock` WRITE;
/*!40000 ALTER TABLE `goods_stock` DISABLE KEYS */;
INSERT INTO `goods_stock` VALUES (1,2,104,'农产品批发市场','2024-07-05','1'),(2,1,100,'农产品批发市场','2024-07-05',NULL),(3,2,100,'农产品批发市场','2024-07-05',NULL),(4,1,200,'	 农产品批发市场','2024-07-05',NULL),(5,6,6,'12321','2024-11-10','2131');
/*!40000 ALTER TABLE `goods_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `content` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容',
  `time` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='系统公告';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (1,'好物上新！新鲜黄桃低至5元起！','好物上新！新鲜黄桃低至5元起！甄选黄桃，口味绝佳，夏日必备！','2024-07-01 15:00:00'),(2,'夏天最适合吃什么？当然是西瓜更配！','新鲜无籽麒麟西瓜新鲜上市！农家自种，现摘现发，无添加更健康！','2024-07-02 15:00:00');
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_no` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单编号',
  `goods_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商品ID',
  `num` int DEFAULT NULL COMMENT '购买数量',
  `user_id` int DEFAULT NULL COMMENT '下单人',
  `status` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单状态',
  `time` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='订单信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (7,'249849bd448d449589e52b4613908748','6',3,4,'待收货','2024-11-10 20:46:30'),(8,'e0aea4f1902a492188a17f3aeabc1997','5',3,4,'待收货','2024-11-10 20:46:35'),(9,'3b737f33cd2d40598b95d5709ea4dba2','4',3,4,'待收货','2024-11-10 20:46:37'),(10,'346c215344b04548ac05a07006e49ebc','6',3,4,'已取消','2024-11-10 20:47:01'),(11,'788c99bbb9e34ce692e9f4f7f7f2faf7','5',4,4,'待收货','2024-11-10 20:47:04'),(12,'ecdf02941ff84034b48a7107093d36a4','1',4,4,'已完成','2024-11-10 20:47:07'),(13,'0e9edcad67de4fababaa017e1a3f0b4d','1',3,4,'已完成','2024-11-10 20:47:09'),(15,'4810cfd3081547d281142e39573e73b5','6',125,4,'已完成','2024-11-10 20:47:18'),(17,'b0d5c304d9274ce0a5bfa860c141b7d0','5',3,4,'待收货','2024-12-01 16:21:29'),(18,'516be8d6706847589f04092b790a6802','4',3,4,'待收货','2024-12-01 16:21:57'),(19,'bcf187b7321244208f0f81cc110b07ec','5',1,4,'已退货','2024-12-01 16:44:06'),(21,'a14a40f79f3742448c40d371e11a41ae','4',1,4,'已完成','2024-12-01 16:52:14'),(22,'7f63d0a91b9c4efc8cfcdb22982e56d0','2',1,4,'已退款','2024-12-01 16:52:45'),(24,'ff360b13e2b14bc3856a90c96013e8bb','6',1,4,'已退货','2024-12-03 16:19:47'),(25,'c7303f854acb40a6a83e3ebb43bd352a','6',3,4,'已退款','2024-12-13 23:00:29'),(39,'ca89917b20a543ae8ea7b4714a509875','4',4,4,'已退款','2024-12-15 17:01:52'),(46,'7de6ac1b680a421d9ed80111cd0a0055','5',2,4,'待退款','2024-12-15 18:58:12'),(47,'92e55109008d4bd2a09e26445e73c341','6',2,4,'待发货','2024-12-15 18:58:13');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_cart` (
  `id` tinyint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int NOT NULL COMMENT '下单人ID',
  `goods_id` int NOT NULL COMMENT '商品ID',
  `count` int unsigned NOT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shopping_cart_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_cart`
--

LOCK TABLES `shopping_cart` WRITE;
/*!40000 ALTER TABLE `shopping_cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '账号',
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `avatar` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `role` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色',
  `sex` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '性别',
  `phone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='普通用户信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (4,'user','123','派大星','http://localhost:9090/files/download/1731242673303-微信图片_20230602195430.jpg','USER','男','18290449672','3395879653@qq.com');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-15 19:51:12
