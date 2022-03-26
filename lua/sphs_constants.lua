-- 处理结果序号
-- https://github.com/rime/librime/blob/master/src/rime/processor.h

local RESULT_REJECTED = 0 -- 拒绝：Rime不执行任何操作 -> 直接由系统进行默认按键操作
local RESULT_ACCEPTED = 1 -- 接受：Rime执行当前逻辑块操作 -> 消耗按键
local RESULT_NOOP = 2 -- 忽略：Rime不执行当前逻辑块操作 -> 传递给下个逻辑块

-- 不同字符所对应的中文变换
local castings = {
    currency_digits = { [0] = "个", "拾", "佰", "仟" }, -- 货币数位
    currency_strings = { [0] = "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" }, -- 货币字符
    currency_units = { [0] = "元", "角", "分", "厘", "毫" }, -- 货币单位
    number_digits = { [0] = "个", "十", "百", "千" }, -- 数字数位
    number_strings = { [0] = "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" }, -- 数字字符
    numbers_military = { ["+"] = "正", ["-"] = "负", ["."] = "点", [0] = "洞", "幺", "两", "三", "四", "五", "六", "拐", "八", "勾", "十" }, -- 军用数字
    numbers_verbal = { ["+"] = "正", ["-"] = "负", ["."] = "点", [0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }, -- 口语数字
    weekdays = { [0] = "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" } -- 星期数
}

-- 不同字符所对应的格式变换
local formatters = {
    time12 = "%I:%M:%S %p",
    time24 = "%H:%M:%S",
    week = "%w"
}

return {
    RESULT_REJECTED = RESULT_REJECTED,
    RESULT_ACCEPTED = RESULT_ACCEPTED,
    RESULT_NOOP = RESULT_NOOP,
    castings = castings,
    formatters = formatters
}
