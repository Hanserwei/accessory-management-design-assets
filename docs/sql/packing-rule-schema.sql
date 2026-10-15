-- 配件管理端规则三表建表评审稿 v0.6（2026-10-15），未执行。
-- 参照日常 alsc_dish_0000 的 mutual_exclusion_0000 / mutual_exclusion_prop_0000。
-- 目标兼容 MySQL 5.7.28；InnoDB、utf8、DYNAMIC 行格式。
-- 以下为逻辑表模板，实际物理分库/分表及路由需在结构设计工单中配置。
-- 三表按相同 merchant_id 路由，规则仅总部一套，org_id 不用于派生门店副本。

CREATE TABLE `packing_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '物理主键',
  `packing_rule_id` varchar(64) NOT NULL COMMENT '总部规则业务ID',
  `packing_rule_name` varchar(128) NOT NULL COMMENT '规则名称，服务端生成并校验同品牌重名',
  `packing_type` varchar(32) NOT NULL DEFAULT 'ACCESSORY_PACKING' COMMENT '打包类型，本期ACCESSORY_PACKING',
  `merchant_id` varchar(64) NOT NULL COMMENT '主账号ID(集团机构ID)，分片键',
  `brand_id` varchar(64) NOT NULL COMMENT '所属品牌ID',
  `org_id` varchar(64) NOT NULL COMMENT '总部归属机构ID，不存门店规则副本',
  `biz_source` varchar(64) NOT NULL COMMENT '业务来源',
  `state` varchar(32) NOT NULL DEFAULT 'ONLINE' COMMENT '商户状态:ONLINE起售,PAUSE停售,INVALID逻辑删除',
  `validity_status` varchar(32) NOT NULL DEFAULT 'VALID' COMMENT '规则有效性:VALID有效,EXPIRED已失效',
  `pick_group` varchar(64) NOT NULL COMMENT '配件组，来源基础categoryId',
  `priority` int(11) NOT NULL COMMENT '同组配件优先级，由配件sort映射，越大越优先',
  `ext_info` json DEFAULT NULL COMMENT 'JSON扩展，expireReason对象记录失效原因，不作为计算准入字段',
  `env` varchar(10) NOT NULL COMMENT '环境',
  `gmt_create` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `gmt_modified` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_idx_packing_rule_id` (`merchant_id`,`biz_source`,`brand_id`,`packing_rule_id`),
  KEY `idx_rule_state_validity` (`merchant_id`,`biz_source`,`brand_id`,`packing_type`,`state`,`validity_status`),
  KEY `idx_rule_pick_group` (`merchant_id`,`biz_source`,`brand_id`,`pick_group`),
  KEY `idx_rule_name` (`merchant_id`,`biz_source`,`brand_id`,`packing_rule_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='总部配件规则主体表';

CREATE TABLE `packing_rule_condition` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '物理主键',
  `condition_id` varchar(64) NOT NULL COMMENT '规则条件业务ID',
  `packing_rule_id` varchar(64) NOT NULL COMMENT '所属总部规则业务ID',
  `merchant_id` varchar(64) NOT NULL COMMENT '主账号ID(集团机构ID)，分片键',
  `brand_id` varchar(64) NOT NULL COMMENT '所属品牌ID',
  `org_id` varchar(64) NOT NULL COMMENT '总部归属机构ID',
  `biz_source` varchar(64) NOT NULL COMMENT '业务来源',
  `dimension` varchar(32) NOT NULL COMMENT '条件维度:DISH_SKU,PRACTICE,SIDE',
  `target_id` varchar(64) NOT NULL COMMENT '基础skuId/标准做法dictId/加料dishId，每行一个目标',
  `target_parent_id` varchar(64) DEFAULT NULL COMMENT 'SKU所属基础dishId，非SKU维度可空',
  `target_name` varchar(256) DEFAULT NULL COMMENT '目标名称，服务端冗余回显',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '条件回显顺序，不表示命中优先级',
  `env` varchar(10) NOT NULL COMMENT '环境',
  `gmt_create` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `gmt_modified` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_idx_condition_id` (`merchant_id`,`biz_source`,`brand_id`,`condition_id`),
  UNIQUE KEY `uk_idx_rule_target` (`merchant_id`,`biz_source`,`brand_id`,`packing_rule_id`,`dimension`,`target_id`),
  KEY `idx_condition_target` (`merchant_id`,`biz_source`,`brand_id`,`dimension`,`target_id`),
  KEY `idx_condition_parent` (`merchant_id`,`biz_source`,`brand_id`,`dimension`,`target_parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='总部配件规则条件表';

CREATE TABLE `packing_rule_material` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '物理主键',
  `material_action_id` varchar(64) NOT NULL COMMENT '物料动作业务ID',
  `packing_rule_id` varchar(64) NOT NULL COMMENT '所属总部规则业务ID',
  `merchant_id` varchar(64) NOT NULL COMMENT '主账号ID(集团机构ID)，分片键',
  `brand_id` varchar(64) NOT NULL COMMENT '所属品牌ID',
  `org_id` varchar(64) NOT NULL COMMENT '总部归属机构ID',
  `biz_source` varchar(64) NOT NULL COMMENT '业务来源',
  `material_id` varchar(64) NOT NULL COMMENT '当前配件的基础dishId',
  `material_name` varchar(256) DEFAULT NULL COMMENT '配件名称，冗余回显',
  `factor_type` varchar(32) NOT NULL DEFAULT 'PER_ITEM' COMMENT '本期固定PER_ITEM，数量由业务固定为1',
  `env` varchar(10) NOT NULL COMMENT '环境',
  `gmt_create` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `gmt_modified` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_idx_material_action_id` (`merchant_id`,`biz_source`,`brand_id`,`material_action_id`),
  UNIQUE KEY `uk_idx_material_rule` (`merchant_id`,`biz_source`,`brand_id`,`packing_rule_id`),
  KEY `idx_material_rule_ref` (`merchant_id`,`biz_source`,`brand_id`,`material_id`,`packing_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='总部配件规则物料动作表';
