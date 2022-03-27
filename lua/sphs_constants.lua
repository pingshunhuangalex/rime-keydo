-- 处理结果序号
-- https://github.com/rime/librime/blob/master/src/rime/processor.h

local RESULT_REJECTED = 0 -- 拒绝：Rime不执行任何操作 -> 直接由系统进行默认按键操作
local RESULT_ACCEPTED = 1 -- 接受：Rime执行当前逻辑块操作 -> 消耗按键
local RESULT_NOOP = 2 -- 忽略：Rime不执行当前逻辑块操作 -> 传递给下个逻辑块

-- 不同字符所对应的中文变换
local castings = {
    currency_decimals = { [0] = "元", "角", "分" }, -- 货币数位（小数）
    currency_digits = { "拾", "佰", "仟" }, -- 货币数位
    currency_separators = { "萬", "億", "兆", "京", "垓", "杼", "穰", "溝", "澗", "正", "載", "極" }, -- 货币分隔数
    currency_strings = { [0] = "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" }, -- 货币字符
    number_decimals = { "分", "厘", "毫", "丝", "忽", "微", "纤", "沙", "尘", "埃", "渺", "漠" }, -- 数字数位（小数）
    number_digits = { "十", "百", "千" }, -- 数字数位
    number_separators = { "万", "亿", "兆", "京", "垓", "秭", "壤", "沟", "涧", "正", "载", "极" }, -- 数字分隔数
    number_strings = { [0] = "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" }, -- 数字字符
    number_symbols = { ["+"] = "正", ["-"] = "负", ["."] = "点" }, -- 数字符号
    numbers_military = { [0] = "洞", "幺", "两", "三", "四", "五", "六", "拐", "八", "勾", "十" }, -- 数字字符（军用）
    numbers_verbal = { [0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }, -- 数字字符（口语）
    weekdays = { [0] = "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" }, -- 星期数
    weekdays_verbal = { [0] = "周日", "周一", "周二", "周三", "周四", "周五", "周六" } -- 星期数（口语）
}

-- 不同字符所对应的格式变换
local formatters = {
    time12 = "%I:%M:%S %p", -- 12小时制格式
    time24 = "%H:%M:%S", -- 24小时制格式
    week = "%w" -- 星期数序号格式
}

return {
    RESULT_REJECTED = RESULT_REJECTED,
    RESULT_ACCEPTED = RESULT_ACCEPTED,
    RESULT_NOOP = RESULT_NOOP,
    castings = castings,
    formatters = formatters
}
