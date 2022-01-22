-- 常用逻辑块
sphs_common = require("sphs_common")

--------------------------
-- 键道·我流@SPHS逻辑块 --
--------------------------

-- 顶功处理器
topup_processor = require("for_topup")

-- 选择处理器
sphs_select_processor = require("sphs_select_processor")

-- 日期转换器：将日期参数（`date`）转换为当前日期（由`orq`引导）
date_translator = require("date")

-- 时间转换器：将时间参数（`time`）转换为当前时间/星期（由`oej`/`oxq`引导）
time_translator = require("time")

-- 数字转换器：将阿拉伯数字转换为对应汉字（由`=`引导）
number_translator = require("xnumber")

-- 候选过滤器
sphs_cand_filter = require("sphs_cand_filter")
