/*
 Navicat Premium Data Transfer

 Source Server         : heart
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : localhost:3306
 Source Schema         : bbs01

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 29/03/2024 11:32:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article_article
-- ----------------------------
DROP TABLE IF EXISTS `article_article`;
CREATE TABLE `article_article`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` date NOT NULL,
  `up_num` bigint(20) NOT NULL,
  `up_down` bigint(20) NOT NULL,
  `comment_num` bigint(20) NOT NULL,
  `blog_id` bigint(20) NULL DEFAULT NULL,
  `category_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `article_article_blog_id_7c0cd15d_fk_blog_blog_id`(`blog_id`) USING BTREE,
  INDEX `article_article_category_id_36b3c456_fk_article_category_id`(`category_id`) USING BTREE,
  CONSTRAINT `article_article_blog_id_7c0cd15d_fk_blog_blog_id` FOREIGN KEY (`blog_id`) REFERENCES `blog_blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `article_article_category_id_36b3c456_fk_article_category_id` FOREIGN KEY (`category_id`) REFERENCES `article_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_article
-- ----------------------------
INSERT INTO `article_article` VALUES (1, 'SQL奇遇记：解锁 SQL 的秘密', '数据库基础 在我们探究SQL语言之旅的起点，首先要对数据库的核心理念有所了解。数据库在现代生活中无处不在，每次网购、网页浏览、即时通讯，都在产生数据。简单来说，数据库就是按一定数据结构组织、存储、管理数据的系统，它能够长期存储于计算机内，实现数据的有序共享和统一管理。 以图书馆为例，成千上万的书籍需 ...', '<div id=\"post_detail\">\r\n    <div id=\"topics\">\r\n        <div class=\"post\">\r\n            <h1 class=\"postTitle\">\r\n            </h1>\r\n            <div class=\"clear\"></div>\r\n            <div class=\"postBody\">\r\n                <div id=\"cnblogs_post_body\" class=\"blogpost-body blogpost-body-html\">\r\n<p>$.ajax({</p>\r\n<p>&nbsp;url:\"\",</p>\r\n<p>&nbsp;success : function(datas, status){</p>\r\n<p>datas:&nbsp;</p>\r\n<p>.net framework:&nbsp; json类型&nbsp;</p>\r\n<p>.net core为 字符串或为空</p>\r\n<p>}</p>\r\n<p>})</p>\r\n<p>C#：</p>\r\n<p>public ActionResult GetData(){</p>\r\n<p>&nbsp;var res = 获取到一个list对象</p>\r\n<p>//&nbsp;.net froamework</p>\r\n<p>return Json( data，AllowGetRequest)&nbsp; //</p>\r\n<p>//.net core</p>\r\n<p>return Json(data) //没有AllowGetRequest的选项，类库底层有修改。若直接这样写，前端收不到数据。需要把data转换为字符串对象</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p>}</p>\r\n</div>\r\n<div class=\"clear\"></div>\r\n<div id=\"blog_post_info_block\" role=\"contentinfo\">\r\n    <div id=\"blog_post_info\">', '2024-03-19', 4, 1, 29, 1, 1);
INSERT INTO `article_article` VALUES (2, 'Garnet: 力压Redis的C#高性能分布式存储数据库', '今天看到微软研究院开源了一个新的C#项目，叫Garnet，它实现了Redis协议，可以直接将Redis替换为Garnet，客户端不需要任何修改。根据其官网的信息，简单的介绍一下它。 开源仓库地址：https://github.com/microsoft/garnet 文档地址：https://mic ...', '..', '2024-02-06', 4, 2, 6, 1, 1);
INSERT INTO `article_article` VALUES (3, '单目测距那些事儿(上) | 从MobileEye谈起', '在 ADAS 领域，有个功能叫自适应巡航控制 (Adaptive Cruise Control, ACC) 。 ACC 是一种纵向距离控 制，具体包括发现目标车辆、判断目标车辆所在路径、测量相对本车的距离和速度，然后进行相应的 刹车等制动操作以保持安全驾驶距离。当没有发现目标车辆时，则保持预设的巡航... ...', '...', '2024-02-24', 4, 5, 7, 1, 1);
INSERT INTO `article_article` VALUES (4, '从 Linux 内核角度探秘 JDK MappedByteBuffer', '本文涉及到的内核源码版本为： 5.4 ，JVM 源码为：OpenJDK17，RocketMQ 源码版本为：5.1.1 在之前的文章《一步一图带你深入剖析 JDK NIO ByteBuffer 在不同字节序下的设计与实现》 中，笔者为大家详细剖析了 JDK Buffer 的整个设计体系，从总体上来讲， ...', '...', '2024-01-10', 23, 33, 44, 1, 2);
INSERT INTO `article_article` VALUES (5, '记录工作过程中一次业务优化', '1需求 用户需要输入身份证和姓名进行登录，登录时需要判断是否存在在数据库存在，登录成功后需要记录登录的信息以及微信Id', '。。。', '2024-01-28', 7, 8, 89, 1, 2);
INSERT INTO `article_article` VALUES (6, 'golang 依赖控制反转（IoC） 改进版', '最近在开发基于golang下的cqrs框架 https://github.com/berkaroad/squat （陆续开发中，最近断了半年，懒了。。。）。这个框架依赖ioc框架，因为之前写了一个ioc，所以借此完善下，主要从灵活性、易用性、性能角度进行了优化。顺带也支持了go mod，并将源码文件 ...', '...', '2023-07-19', 3, 11, 58, 2, 3);
INSERT INTO `article_article` VALUES (7, 'golang sync.Map之如何设计一个并发安全的读写分离结构?', '在 golang中，想要并发安全的操作map，可以使用sync.Map结构，sync.Map 是一个适合读多写少的数据结构，今天我们来看看它的设计思想，来看看为什么说它适合读多写少的场景。 如下，是golang 中sync.Map的数据结构，其中 属性read 是 只读的 map，dirty 是负责 ...', '。。。', '2023-11-01', 2, 3, 11, 2, 3);
INSERT INTO `article_article` VALUES (8, 'Locust 断言的实现？', '一、检查点的方式有哪些: 主要是python 内置的assert 断言（自动断言）还有locust 中的catch_response 断言（手动断言）；那么这两者之间有什么区别呢？ 其实主要区别在与生成locust 报告上面，手动断言失败，我们在locust上面可以清楚的看到报错信息，如果通过内置断 ...', '。。。', '2023-11-01', 1, 0, 0, 2, 3);
INSERT INTO `article_article` VALUES (9, 'GaussDB(分布式)实例故障处理', '本文分享自华为云社区《GaussDB(分布式)实例故障处理》，作者：subverter。 一、说明 GaussDB Kernel实例出现故障时，可以按照本节的办法进行实例快速修复。 1、执行gs_om -t status --detail查看集群状态，cluster_state为Normal，bal ...', '。。。', '2023-07-19', 0, 0, 0, 2, 4);
INSERT INTO `article_article` VALUES (10, 'Rust Rocket简单入门', '目录简介hello world常用功能动态路径多个片段(segments)静态文件服务器简单WebAPI示例添加依赖实现接口接口测试参考链接 简介 Rust中最知名的两个web框架要数Rocket和Actix了，Rocket更注重易用性，Actix则更注重性能。这里只是了解一下Rust下的WebAP ...', '。。。', '2023-08-19', 0, 0, 0, 2, 4);
INSERT INTO `article_article` VALUES (16, 'testt', 'testt', 'testt', '2024-03-28', 0, 0, 0, 1, 2);

-- ----------------------------
-- Table structure for article_article2tag
-- ----------------------------
DROP TABLE IF EXISTS `article_article2tag`;
CREATE TABLE `article_article2tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `tag_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `article_article2tag_article_id_393b2906_fk_article_article_id`(`article_id`) USING BTREE,
  INDEX `article_article2tag_tag_id_38232ae4_fk_article_tag_id`(`tag_id`) USING BTREE,
  CONSTRAINT `article_article2tag_article_id_393b2906_fk_article_article_id` FOREIGN KEY (`article_id`) REFERENCES `article_article` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `article_article2tag_tag_id_38232ae4_fk_article_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `article_tag` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_article2tag
-- ----------------------------
INSERT INTO `article_article2tag` VALUES (1, 1, 1);
INSERT INTO `article_article2tag` VALUES (2, 1, 2);
INSERT INTO `article_article2tag` VALUES (3, 1, 3);
INSERT INTO `article_article2tag` VALUES (4, 2, 1);
INSERT INTO `article_article2tag` VALUES (5, 2, 2);
INSERT INTO `article_article2tag` VALUES (6, 3, 3);
INSERT INTO `article_article2tag` VALUES (7, 3, 2);
INSERT INTO `article_article2tag` VALUES (8, 4, 1);
INSERT INTO `article_article2tag` VALUES (9, 4, 3);
INSERT INTO `article_article2tag` VALUES (10, 5, 2);
INSERT INTO `article_article2tag` VALUES (11, 6, 4);
INSERT INTO `article_article2tag` VALUES (12, 6, 5);
INSERT INTO `article_article2tag` VALUES (13, 6, 6);
INSERT INTO `article_article2tag` VALUES (14, 7, 4);
INSERT INTO `article_article2tag` VALUES (15, 7, 6);
INSERT INTO `article_article2tag` VALUES (16, 8, 5);
INSERT INTO `article_article2tag` VALUES (17, 8, 6);
INSERT INTO `article_article2tag` VALUES (18, 9, 4);
INSERT INTO `article_article2tag` VALUES (19, 10, 6);
INSERT INTO `article_article2tag` VALUES (20, 10, 5);
INSERT INTO `article_article2tag` VALUES (36, 16, 1);

-- ----------------------------
-- Table structure for article_category
-- ----------------------------
DROP TABLE IF EXISTS `article_category`;
CREATE TABLE `article_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `blog_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `article_category_blog_id_08ff0327_fk_blog_blog_id`(`blog_id`) USING BTREE,
  CONSTRAINT `article_category_blog_id_08ff0327_fk_blog_blog_id` FOREIGN KEY (`blog_id`) REFERENCES `blog_blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_category
-- ----------------------------
INSERT INTO `article_category` VALUES (1, 'heart分类1', 1);
INSERT INTO `article_category` VALUES (2, 'heart分类2', 1);
INSERT INTO `article_category` VALUES (3, 'god分类一', 2);
INSERT INTO `article_category` VALUES (4, 'god分类二', 2);

-- ----------------------------
-- Table structure for article_comment
-- ----------------------------
DROP TABLE IF EXISTS `article_comment`;
CREATE TABLE `article_comment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `comment_time` datetime(6) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `parent_id` bigint(20) NULL DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `article_comment_article_id_4fa145bf_fk_article_article_id`(`article_id`) USING BTREE,
  INDEX `article_comment_parent_id_c90d4bf0_fk_article_comment_id`(`parent_id`) USING BTREE,
  INDEX `article_comment_user_id_8d360365_fk_user_userinfo_id`(`user_id`) USING BTREE,
  CONSTRAINT `article_comment_article_id_4fa145bf_fk_article_article_id` FOREIGN KEY (`article_id`) REFERENCES `article_article` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `article_comment_parent_id_c90d4bf0_fk_article_comment_id` FOREIGN KEY (`parent_id`) REFERENCES `article_comment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `article_comment_user_id_8d360365_fk_user_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `user_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_comment
-- ----------------------------
INSERT INTO `article_comment` VALUES (1, '好评论！', '2024-03-26 12:49:34.386161', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (5, '123', '2024-03-26 13:17:20.813034', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (6, '1234', '2024-03-26 13:18:01.404718', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (7, '1234', '2024-03-26 13:22:18.566658', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (8, '123', '2024-03-26 13:24:46.922666', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (9, '好文章！', '2024-03-26 13:38:36.213378', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (10, '写的真好！', '2024-03-26 13:39:16.509505', 1, NULL, 4);
INSERT INTO `article_comment` VALUES (11, '你好呀', '2024-03-26 13:40:38.855063', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (12, 'hello', '2024-03-26 13:41:33.401919', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (13, '你好吗', '2024-03-26 13:41:47.718307', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (14, '\n123123', '2024-03-26 14:07:08.969018', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (15, '1', '2024-03-26 14:08:38.128533', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (16, '没错', '2024-03-26 14:09:53.983890', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (17, '嗯嗯', '2024-03-26 14:10:10.995785', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (18, '哈哈你好啊', '2024-03-27 01:11:23.617767', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (19, '哈哈你好啊', '2024-03-27 01:11:28.865915', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (20, '嘿嘿你好啊', '2024-03-27 01:13:38.490288', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (21, '123', '2024-03-27 01:16:33.357445', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (22, '111', '2024-03-27 01:16:51.725213', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (23, '222', '2024-03-27 01:17:08.888939', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (24, '333', '2024-03-27 01:18:49.008147', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (25, 'test', '2024-03-27 01:19:21.011279', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (26, 'test1', '2024-03-27 01:21:13.464866', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (27, 'test2', '2024-03-27 01:21:37.580986', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (28, 'test3', '2024-03-27 01:21:52.873702', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (29, 'test4', '2024-03-27 01:24:58.376278', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (30, 'test5', '2024-03-27 01:26:18.302602', 1, NULL, 2);
INSERT INTO `article_comment` VALUES (31, 'hello world', '2024-03-27 01:29:08.366962', 3, NULL, 2);
INSERT INTO `article_comment` VALUES (32, '你好呀', '2024-03-27 01:29:17.437195', 3, 31, 2);
INSERT INTO `article_comment` VALUES (33, '123', '2024-03-27 03:30:45.313170', 6, NULL, 4);
INSERT INTO `article_comment` VALUES (34, '123', '2024-03-27 03:30:50.096937', 6, 33, 4);
INSERT INTO `article_comment` VALUES (35, '你好', '2024-03-27 03:30:55.389432', 6, 34, 4);
INSERT INTO `article_comment` VALUES (36, '123123123123123', '2024-03-27 12:46:12.779327', 1, 30, 2);
INSERT INTO `article_comment` VALUES (37, '123123213', '2024-03-27 12:46:45.513522', 1, 10, 2);
INSERT INTO `article_comment` VALUES (38, '你好', '2024-03-28 12:16:36.237696', 2, NULL, 2);
INSERT INTO `article_comment` VALUES (39, '你也好', '2024-03-28 12:16:41.066272', 2, 38, 2);
INSERT INTO `article_comment` VALUES (40, '你好111', '2024-03-29 01:11:21.787066', 2, NULL, 2);

-- ----------------------------
-- Table structure for article_tag
-- ----------------------------
DROP TABLE IF EXISTS `article_tag`;
CREATE TABLE `article_tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `blog_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `article_tag_blog_id_15364ce7_fk_blog_blog_id`(`blog_id`) USING BTREE,
  CONSTRAINT `article_tag_blog_id_15364ce7_fk_blog_blog_id` FOREIGN KEY (`blog_id`) REFERENCES `blog_blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_tag
-- ----------------------------
INSERT INTO `article_tag` VALUES (1, 'heart1', 1);
INSERT INTO `article_tag` VALUES (2, 'heart2', 1);
INSERT INTO `article_tag` VALUES (3, 'heart3', 1);
INSERT INTO `article_tag` VALUES (4, 'god1', 2);
INSERT INTO `article_tag` VALUES (5, 'god2', 2);
INSERT INTO `article_tag` VALUES (6, 'god3', 2);

-- ----------------------------
-- Table structure for article_upanddown
-- ----------------------------
DROP TABLE IF EXISTS `article_upanddown`;
CREATE TABLE `article_upanddown`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_up` tinyint(1) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `article_upanddown_article_id_5e636f97_fk_article_article_id`(`article_id`) USING BTREE,
  INDEX `article_upanddown_user_id_50bfeaf5_fk_user_userinfo_id`(`user_id`) USING BTREE,
  CONSTRAINT `article_upanddown_article_id_5e636f97_fk_article_article_id` FOREIGN KEY (`article_id`) REFERENCES `article_article` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `article_upanddown_user_id_50bfeaf5_fk_user_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `user_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_upanddown
-- ----------------------------
INSERT INTO `article_upanddown` VALUES (21, 1, 2, 2);
INSERT INTO `article_upanddown` VALUES (22, 1, 1, 4);
INSERT INTO `article_upanddown` VALUES (23, 1, 1, 2);
INSERT INTO `article_upanddown` VALUES (24, 1, 6, 4);

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add user', 6, 'add_userinfo');
INSERT INTO `auth_permission` VALUES (22, 'Can change user', 6, 'change_userinfo');
INSERT INTO `auth_permission` VALUES (23, 'Can delete user', 6, 'delete_userinfo');
INSERT INTO `auth_permission` VALUES (24, 'Can view user', 6, 'view_userinfo');
INSERT INTO `auth_permission` VALUES (25, 'Can add blog', 7, 'add_blog');
INSERT INTO `auth_permission` VALUES (26, 'Can change blog', 7, 'change_blog');
INSERT INTO `auth_permission` VALUES (27, 'Can delete blog', 7, 'delete_blog');
INSERT INTO `auth_permission` VALUES (28, 'Can view blog', 7, 'view_blog');
INSERT INTO `auth_permission` VALUES (29, 'Can add article', 8, 'add_article');
INSERT INTO `auth_permission` VALUES (30, 'Can change article', 8, 'change_article');
INSERT INTO `auth_permission` VALUES (31, 'Can delete article', 8, 'delete_article');
INSERT INTO `auth_permission` VALUES (32, 'Can view article', 8, 'view_article');
INSERT INTO `auth_permission` VALUES (33, 'Can add article2 tag', 9, 'add_article2tag');
INSERT INTO `auth_permission` VALUES (34, 'Can change article2 tag', 9, 'change_article2tag');
INSERT INTO `auth_permission` VALUES (35, 'Can delete article2 tag', 9, 'delete_article2tag');
INSERT INTO `auth_permission` VALUES (36, 'Can view article2 tag', 9, 'view_article2tag');
INSERT INTO `auth_permission` VALUES (37, 'Can add category', 10, 'add_category');
INSERT INTO `auth_permission` VALUES (38, 'Can change category', 10, 'change_category');
INSERT INTO `auth_permission` VALUES (39, 'Can delete category', 10, 'delete_category');
INSERT INTO `auth_permission` VALUES (40, 'Can view category', 10, 'view_category');
INSERT INTO `auth_permission` VALUES (41, 'Can add comment', 11, 'add_comment');
INSERT INTO `auth_permission` VALUES (42, 'Can change comment', 11, 'change_comment');
INSERT INTO `auth_permission` VALUES (43, 'Can delete comment', 11, 'delete_comment');
INSERT INTO `auth_permission` VALUES (44, 'Can view comment', 11, 'view_comment');
INSERT INTO `auth_permission` VALUES (45, 'Can add tag', 12, 'add_tag');
INSERT INTO `auth_permission` VALUES (46, 'Can change tag', 12, 'change_tag');
INSERT INTO `auth_permission` VALUES (47, 'Can delete tag', 12, 'delete_tag');
INSERT INTO `auth_permission` VALUES (48, 'Can view tag', 12, 'view_tag');
INSERT INTO `auth_permission` VALUES (49, 'Can add up and down', 13, 'add_upanddown');
INSERT INTO `auth_permission` VALUES (50, 'Can change up and down', 13, 'change_upanddown');
INSERT INTO `auth_permission` VALUES (51, 'Can delete up and down', 13, 'delete_upanddown');
INSERT INTO `auth_permission` VALUES (52, 'Can view up and down', 13, 'view_upanddown');
INSERT INTO `auth_permission` VALUES (53, 'Can add adv', 14, 'add_adv');
INSERT INTO `auth_permission` VALUES (54, 'Can change adv', 14, 'change_adv');
INSERT INTO `auth_permission` VALUES (55, 'Can delete adv', 14, 'delete_adv');
INSERT INTO `auth_permission` VALUES (56, 'Can view adv', 14, 'view_adv');

-- ----------------------------
-- Table structure for blog_adv
-- ----------------------------
DROP TABLE IF EXISTS `blog_adv`;
CREATE TABLE `blog_adv`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `img` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_background_img` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_adv
-- ----------------------------
INSERT INTO `blog_adv` VALUES (3, '传奇', '传奇来砍我', '2024-03-18 09:26:50.709205', '2024-03-18 09:26:50.709205', '110', 'advImg/1_00mZMsq.jpg', 0);
INSERT INTO `blog_adv` VALUES (4, '草', '123', '2024-03-18 09:28:36.196443', '2024-03-18 09:28:36.196443', '110', 'adVimg/7482511a9d16fdfafb417625f18f8c5495ee7bbf.jpg', 0);
INSERT INTO `blog_adv` VALUES (6, '你好', '你好test1', '2024-03-18 09:29:33.238898', '2024-03-18 09:29:33.238898', '110', 'advImg/Ej0GYqPy_400x400.jpg', 1);
INSERT INTO `blog_adv` VALUES (14, 'test5', 'test55', '2024-03-18 11:30:25.867565', '2024-03-18 11:30:25.868555', '555', 'advImg/7482511a9d16fdfafb417625f18f8c5495ee7bbf.jpg', 1);
INSERT INTO `blog_adv` VALUES (15, 'test6', 'test666', '2024-03-18 11:31:30.220469', '2024-03-18 11:31:30.220469', '666', 'advImg/微信图片_20230214230708.png', 1);
INSERT INTO `blog_adv` VALUES (16, 'test7', 'test777', '2024-03-18 11:33:08.508614', '2024-03-18 11:33:08.508614', '777', 'advImg/微信图片_20240204171350.png', 1);
INSERT INTO `blog_adv` VALUES (17, 'test8', 'test888', '2024-03-18 11:34:42.525417', '2024-03-18 11:34:42.525417', '888', 'advImg/QQ图片20200309024047.png', 1);
INSERT INTO `blog_adv` VALUES (22, '5', '5', '2024-03-19 08:24:12.806808', '2024-03-19 08:24:12.806808', '5', 'adVimg/_3WD$2X8S6}37(LJZ%}J[DT.png', 0);
INSERT INTO `blog_adv` VALUES (23, '3', '3', '2024-03-19 08:24:54.785387', '2024-03-19 08:24:54.785387', '3', 'advImg/kaixin.png', 0);

-- ----------------------------
-- Table structure for blog_blog
-- ----------------------------
DROP TABLE IF EXISTS `blog_blog`;
CREATE TABLE `blog_blog`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `site_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `site_title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `site_theme` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_blog
-- ----------------------------
INSERT INTO `blog_blog` VALUES (1, 'heart', 'be water', 'heart.css');
INSERT INTO `blog_blog` VALUES (2, 'god', '无限进步', 'god.css');

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(11) NULL DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_user_userinfo_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_user_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `user_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2024-03-19 12:05:10.870750', '7', 'zeus1233', 3, '', 6, 2);
INSERT INTO `django_admin_log` VALUES (2, '2024-03-19 12:22:30.787175', '5', 'zeus', 2, '[{\"changed\": {\"fields\": [\"Last login\", \"\\u7528\\u6237\\u5934\\u50cf\"]}}]', 6, 2);
INSERT INTO `django_admin_log` VALUES (3, '2024-03-19 12:28:22.968364', '1', 'Blog object (1)', 1, '[{\"added\": {}}]', 7, 2);
INSERT INTO `django_admin_log` VALUES (4, '2024-03-19 12:28:34.522645', '1', 'Category object (1)', 1, '[{\"added\": {}}]', 10, 2);
INSERT INTO `django_admin_log` VALUES (5, '2024-03-19 12:29:30.595605', '1', 'SQL奇遇记：解锁 SQL 的秘密', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (6, '2024-03-19 12:30:22.110007', '2', 'Garnet: 力压Redis的C#高性能分布式存储数据库', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (7, '2024-03-19 12:30:35.091489', '3', '单目测距那些事儿(上) | 从MobileEye谈起', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (8, '2024-03-19 12:30:57.440322', '2', 'heart分类2', 1, '[{\"added\": {}}]', 10, 2);
INSERT INTO `django_admin_log` VALUES (9, '2024-03-19 12:30:59.091234', '4', '从 Linux 内核角度探秘 JDK MappedByteBuffer', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (10, '2024-03-19 12:31:15.244043', '5', '记录工作过程中一次业务优化', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (11, '2024-03-19 12:31:39.912428', '2', 'god', 1, '[{\"added\": {}}]', 7, 2);
INSERT INTO `django_admin_log` VALUES (12, '2024-03-19 12:31:46.459002', '3', 'god分类一', 1, '[{\"added\": {}}]', 10, 2);
INSERT INTO `django_admin_log` VALUES (13, '2024-03-19 12:31:50.179539', '6', 'golang 依赖控制反转（IoC） 改进版', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (14, '2024-03-19 12:32:00.384060', '7', 'golang sync.Map之如何设计一个并发安全的读写分离结构?', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (15, '2024-03-19 12:32:13.341149', '8', 'Locust 断言的实现？', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (16, '2024-03-19 12:32:31.328354', '4', 'god分类二', 1, '[{\"added\": {}}]', 10, 2);
INSERT INTO `django_admin_log` VALUES (17, '2024-03-19 12:32:33.531486', '9', 'GaussDB(分布式)实例故障处理', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (18, '2024-03-19 12:32:43.172430', '10', 'Rust Rocket简单入门', 1, '[{\"added\": {}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (19, '2024-03-19 12:33:17.860128', '1', 'heart1', 1, '[{\"added\": {}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (20, '2024-03-19 12:33:21.708438', '2', 'heart2', 1, '[{\"added\": {}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (21, '2024-03-19 12:33:24.690228', '3', 'heart3', 1, '[{\"added\": {}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (22, '2024-03-19 12:33:27.722316', '4', 'god1', 1, '[{\"added\": {}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (23, '2024-03-19 12:33:30.242435', '5', 'god2', 1, '[{\"added\": {}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (24, '2024-03-19 12:33:32.693804', '6', 'god3', 1, '[{\"added\": {}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (25, '2024-03-19 12:34:41.179616', '1', 'Article2Tag object (1)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (26, '2024-03-19 12:34:44.987436', '2', 'Article2Tag object (2)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (27, '2024-03-19 12:34:46.884042', '3', 'Article2Tag object (3)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (28, '2024-03-19 12:34:48.983399', '4', 'Article2Tag object (4)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (29, '2024-03-19 12:34:51.144136', '5', 'Article2Tag object (5)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (30, '2024-03-19 12:34:54.420080', '6', 'Article2Tag object (6)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (31, '2024-03-19 12:34:56.470563', '7', 'Article2Tag object (7)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (32, '2024-03-19 12:34:58.849676', '8', 'Article2Tag object (8)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (33, '2024-03-19 12:35:00.838706', '9', 'Article2Tag object (9)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (34, '2024-03-19 12:35:04.834142', '10', 'Article2Tag object (10)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (35, '2024-03-19 12:35:09.092534', '11', 'Article2Tag object (11)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (36, '2024-03-19 12:35:11.641843', '12', 'Article2Tag object (12)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (37, '2024-03-19 12:35:13.699030', '13', 'Article2Tag object (13)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (38, '2024-03-19 12:35:16.979279', '14', 'Article2Tag object (14)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (39, '2024-03-19 12:35:19.197333', '15', 'Article2Tag object (15)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (40, '2024-03-19 12:35:22.328245', '16', 'Article2Tag object (16)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (41, '2024-03-19 12:35:24.481937', '17', 'Article2Tag object (17)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (42, '2024-03-19 12:35:26.818170', '18', 'Article2Tag object (18)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (43, '2024-03-19 12:35:29.009260', '19', 'Article2Tag object (19)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (44, '2024-03-19 12:35:31.041587', '20', 'Article2Tag object (20)', 1, '[{\"added\": {}}]', 9, 2);
INSERT INTO `django_admin_log` VALUES (45, '2024-03-19 12:36:48.457977', '2', 'heart', 2, '[{\"changed\": {\"fields\": [\"Last login\", \"Blog\"]}}]', 6, 2);
INSERT INTO `django_admin_log` VALUES (46, '2024-03-19 12:36:52.894399', '4', 'god', 2, '[{\"changed\": {\"fields\": [\"Last login\", \"Blog\"]}}]', 6, 2);
INSERT INTO `django_admin_log` VALUES (47, '2024-03-19 12:59:13.441971', '2', 'heart', 2, '[{\"changed\": {\"fields\": [\"\\u7528\\u6237\\u5934\\u50cf\"]}}]', 6, 2);
INSERT INTO `django_admin_log` VALUES (48, '2024-03-20 13:11:09.617894', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (49, '2024-03-20 13:12:11.903074', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (50, '2024-03-20 13:14:56.501281', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (51, '2024-03-20 13:16:34.531459', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (52, '2024-03-20 13:18:15.887480', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (53, '2024-03-20 13:18:33.888820', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (54, '2024-03-20 13:19:37.450767', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (55, '2024-03-20 13:20:21.208837', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (56, '2024-03-20 13:21:03.563557', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);
INSERT INTO `django_admin_log` VALUES (57, '2024-03-20 13:58:42.484508', '1', 'SQL奇遇记：解锁 SQL 的秘密', 2, '[{\"changed\": {\"fields\": [\"\\u6587\\u7ae0\\u5185\\u5bb9\"]}}]', 8, 2);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (8, 'article', 'article');
INSERT INTO `django_content_type` VALUES (9, 'article', 'article2tag');
INSERT INTO `django_content_type` VALUES (10, 'article', 'category');
INSERT INTO `django_content_type` VALUES (11, 'article', 'comment');
INSERT INTO `django_content_type` VALUES (12, 'article', 'tag');
INSERT INTO `django_content_type` VALUES (13, 'article', 'upanddown');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (14, 'blog', 'adv');
INSERT INTO `django_content_type` VALUES (7, 'blog', 'blog');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (6, 'user', 'userinfo');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'blog', '0001_initial', '2024-03-13 08:02:08.782855');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0001_initial', '2024-03-13 08:02:08.868466');
INSERT INTO `django_migrations` VALUES (3, 'contenttypes', '0002_remove_content_type_name', '2024-03-13 08:02:08.965175');
INSERT INTO `django_migrations` VALUES (4, 'auth', '0001_initial', '2024-03-13 08:02:09.279712');
INSERT INTO `django_migrations` VALUES (5, 'auth', '0002_alter_permission_name_max_length', '2024-03-13 08:02:09.342624');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0003_alter_user_email_max_length', '2024-03-13 08:02:09.349631');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0004_alter_user_username_opts', '2024-03-13 08:02:09.356704');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0005_alter_user_last_login_null', '2024-03-13 08:02:09.363674');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0006_require_contenttypes_0002', '2024-03-13 08:02:09.368193');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0007_alter_validators_add_error_messages', '2024-03-13 08:02:09.374086');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0008_alter_user_username_max_length', '2024-03-13 08:02:09.381157');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0009_alter_user_last_name_max_length', '2024-03-13 08:02:09.388119');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0010_alter_group_name_max_length', '2024-03-13 08:02:09.420527');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0011_update_proxy_permissions', '2024-03-13 08:02:09.427572');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0012_alter_user_first_name_max_length', '2024-03-13 08:02:09.434529');
INSERT INTO `django_migrations` VALUES (16, 'user', '0001_initial', '2024-03-13 08:02:09.883900');
INSERT INTO `django_migrations` VALUES (17, 'admin', '0001_initial', '2024-03-13 08:02:10.040087');
INSERT INTO `django_migrations` VALUES (18, 'admin', '0002_logentry_remove_auto_add', '2024-03-13 08:02:10.050085');
INSERT INTO `django_migrations` VALUES (19, 'admin', '0003_logentry_add_action_flag_choices', '2024-03-13 08:02:10.059085');
INSERT INTO `django_migrations` VALUES (20, 'article', '0001_initial', '2024-03-13 08:02:10.253952');
INSERT INTO `django_migrations` VALUES (21, 'article', '0002_initial', '2024-03-13 08:02:10.949309');
INSERT INTO `django_migrations` VALUES (22, 'sessions', '0001_initial', '2024-03-13 08:02:11.017030');
INSERT INTO `django_migrations` VALUES (23, 'user', '0002_alter_userinfo_avatar', '2024-03-13 08:58:56.451904');
INSERT INTO `django_migrations` VALUES (24, 'blog', '0002_adv', '2024-03-18 07:40:38.685845');
INSERT INTO `django_migrations` VALUES (25, 'blog', '0003_alter_adv_img', '2024-03-18 10:42:42.041506');
INSERT INTO `django_migrations` VALUES (26, 'blog', '0004_alter_adv_img', '2024-03-18 10:46:42.829429');
INSERT INTO `django_migrations` VALUES (27, 'blog', '0005_alter_adv_img', '2024-03-18 10:48:58.785568');
INSERT INTO `django_migrations` VALUES (28, 'blog', '0006_alter_adv_img', '2024-03-18 10:54:01.261805');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('q5284t59qumvgraq0dh7dweoh7f248la', '.eJxVjDsOwyAQBe9CHSFYsIGU6XMGaxfWwbGFJX-KKMrdgyU3bmfmva-Ic2JxF-P0KUrcRIf7lrt95aUbUuVwZYRx5HKI9MbymmWcy7YMJI9EnnaVz3o6Pc72cpBxzXXtQAcCFZBbTQahJwUJDKNrtQ9oVWQXe9MYZ4mSaav0NlhqGHw0pMXvD_nnPAY:1rq0vU:gxEce5Whn-bKWJ80DqEvFtxtWPVbJmHzVDoCd72fJrE', '2024-04-12 01:21:00.972106');

-- ----------------------------
-- Table structure for user_userinfo
-- ----------------------------
DROP TABLE IF EXISTS `user_userinfo`;
CREATE TABLE `user_userinfo`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `create_time` date NOT NULL,
  `blog_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `blog_id`(`blog_id`) USING BTREE,
  CONSTRAINT `user_userinfo_blog_id_976bf542_fk_blog_blog_id` FOREIGN KEY (`blog_id`) REFERENCES `blog_blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_userinfo
-- ----------------------------
INSERT INTO `user_userinfo` VALUES (2, 'pbkdf2_sha256$260000$MbAlVJmme86nhrbEfIb8qB$Lu3iyeMl2mTOEAxbz+SKuoXimDi8mN9yHywn+5kaIMY=', '2024-03-29 01:21:00.969230', 1, 'heart', '', '', 'heart@ssr.com', 1, 1, '2024-03-14 03:44:00.000000', '110', 'avatar/Ej0GYqPy_400x400.jpg', 0, '2024-03-14', 1);
INSERT INTO `user_userinfo` VALUES (4, 'pbkdf2_sha256$260000$BlKvxWPe5mfRfYyjuqU1D3$qU5lQd5sfWKm5KH3sW/i1X7lk+kVWY8qull9ka7JDkY=', '2024-03-27 02:23:00.074129', 0, 'god', '', '', 'god@ssr.com', 0, 1, '2024-03-14 04:16:00.000000', '120', 'avatar/微信图片_20240215144919.jpg', 0, '2024-03-14', 2);
INSERT INTO `user_userinfo` VALUES (5, 'pbkdf2_sha256$260000$Qr3xei0b2BYZlhAlpk5ixR$DneZiq8BCwr7CK4EsrUu3RJYBE0lZCitGm63mGL/Huo=', '2024-03-19 11:34:00.000000', 0, 'zeus', '', '', 'zeus@ssr.com', 0, 1, '2024-03-14 04:16:00.000000', '130', 'avatar/7482511a9d16fdfafb417625f18f8c5495ee7bbf.jpg', 0, '2024-03-14', NULL);
INSERT INTO `user_userinfo` VALUES (6, 'pbkdf2_sha256$260000$2fQYq4tH10pAfvBCbRsF2s$UiPWESqL4KiixKIT06rMaCnS0OM5NYTpFjYnwy0BbDI=', NULL, 0, 'zeus123', '', '', '123@123.com', 0, 1, '2024-03-15 11:44:23.175650', '144', 'avatar/b59501309a3f4b7859a1cfed0bf6bce0_middle_NKi3WBs.jpg', 0, '2024-03-15', NULL);

-- ----------------------------
-- Table structure for user_userinfo_groups
-- ----------------------------
DROP TABLE IF EXISTS `user_userinfo_groups`;
CREATE TABLE `user_userinfo_groups`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userinfo_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_userinfo_groups_userinfo_id_group_id_427ab23f_uniq`(`userinfo_id`, `group_id`) USING BTREE,
  INDEX `user_userinfo_groups_group_id_660e8d76_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `user_userinfo_groups_group_id_660e8d76_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_userinfo_groups_userinfo_id_80ed863e_fk_user_userinfo_id` FOREIGN KEY (`userinfo_id`) REFERENCES `user_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_userinfo_groups
-- ----------------------------

-- ----------------------------
-- Table structure for user_userinfo_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `user_userinfo_user_permissions`;
CREATE TABLE `user_userinfo_user_permissions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userinfo_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_userinfo_user_permi_userinfo_id_permission_i_8245f325_uniq`(`userinfo_id`, `permission_id`) USING BTREE,
  INDEX `user_userinfo_user_p_permission_id_a994ee6a_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `user_userinfo_user_p_permission_id_a994ee6a_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_userinfo_user_p_userinfo_id_76f2e887_fk_user_user` FOREIGN KEY (`userinfo_id`) REFERENCES `user_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_userinfo_user_permissions
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
