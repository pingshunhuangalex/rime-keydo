--------------------------
-- 键道·我流@SPHS逻辑块 --
--------------------------

-- 顶功处理器
topup_processor = require("for_topup")

-- 次选处理器：将单引号（`'`）用作次选键
smart_2 = require("smart_2")

-- 候选过滤器：历史记录非汉字过滤（由`/`引导），特殊简码、二级简码编码提示（`❖`）等
sphs_filter = require("sphs_filter")

-- 数字转换器：将阿拉伯数字转换为对应汉字（由`=`引导）
number_translator = require("xnumber")

-- 日期转换器：将日期参数（`date`）转换为当前日期（由`orq`引导）
date_translator = require("date")

-- 时间转换器：将时间参数（`time`）转换为当前时间/星期（由`oej`/`oxq`引导）
time_translator = require("time")

--------------------
-- 其它方案逻辑块 --
--------------------

-- 单字模式 & 630 即 ss 词组提示
xkjd6_filter = require("xkjd6_filter")

----------------
-- 归档逻辑块 --
----------------

-- 候选项重排序，使单字优先
-- single_char_filter = require("single_char")

-- 声笔笔简码提示 | 顶功提示 | 补全处理
-- hint_filter = require("for_hint")
