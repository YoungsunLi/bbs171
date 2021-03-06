/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50625
Source Host           : localhost:3306
Source Database       : bbs171

Target Server Type    : MYSQL
Target Server Version : 50625
File Encoding         : 65001

Date: 2020-01-02 21:30:34
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL COMMENT '帖子id',
  `from_phone` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '评论者手机',
  `to_phone` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` varchar(2050) CHARACTER SET utf8mb4 NOT NULL COMMENT '评论内容',
  `datetime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '回复日期',
  `status` int(11) DEFAULT '1' COMMENT '1=正常, 2=已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `phone` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '发帖用户手机',
  `title` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '标题',
  `content` varchar(10050) CHARACTER SET utf8mb4 NOT NULL COMMENT '正文',
  `datetime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发表时间',
  `category` int(11) DEFAULT '1' COMMENT '1=默认,2=学习,3=生活,4=表白墙',
  `views` int(11) DEFAULT '0' COMMENT '点击量',
  `status` int(11) DEFAULT '1' COMMENT '0=待审核,1=已审核,2=已删除',
  `report` int(11) DEFAULT '0' COMMENT '被举报次数',
  `comment` int(11) DEFAULT '0' COMMENT '评论数量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of posts
-- ----------------------------

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL COMMENT '被举报的帖子id',
  `user_id` int(11) NOT NULL COMMENT '举报该帖子的用户id',
  `content` varchar(10050) CHARACTER SET utf8mb4 NOT NULL COMMENT '举报内容',
  `datetime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '举报时间',
  `status` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of report
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(4) DEFAULT '1' COMMENT '0=管理员，1=普通用户',
  `phone` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '用户手机',
  `username` varchar(20) CHARACTER SET utf8mb4 NOT NULL COMMENT '用户名',
  `password` varchar(18) CHARACTER SET utf8mb4 NOT NULL COMMENT '密码',
  `gender` varchar(4) CHARACTER SET utf8mb4 DEFAULT '男' COMMENT '性别',
  `sign` varchar(255) CHARACTER SET utf8mb4 DEFAULT '你还没有签名哦' COMMENT '签名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 DEFAULT '/res/images/avatar/default.png' COMMENT '头像',
  `datetime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`id`,`phone`),
  UNIQUE KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', '0', '18888888888', '管理员', '123456', '男', '我是管理员哦', 'https://www.gravatar.com/avatar/13737148529?s=200&d=identicon', '2019-12-30 20:34:56');
