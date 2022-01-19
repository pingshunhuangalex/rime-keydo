sphs_common = require("sphs_common")

--------------------------
-- 键道·我流@SPHS逻辑块 --
--------------------------

-- 顶功处理器
topup_processor = require("for_topup")

-- 选择处理器：自动选择唯一候选项（忽略码长），将单引号（`'`）用作次选键等
sphs_select_processor = require("sphs_select_processor")

-- 候选过滤器：历史记录非汉字过滤（由`/`引导）
sphs_cand_filter = require("sphs_cand_filter")

-- 数字转换器：将阿拉伯数字转换为对应汉字（由`=`引导）
number_translator = require("xnumber")

-- 日期转换器：将日期参数（`date`）转换为当前日期（由`orq`引导）
date_translator = require("date")

-- 时间转换器：将时间参数（`time`）转换为当前时间/星期（由`oej`/`oxq`引导）
time_translator = require("time")
