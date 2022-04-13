-- 处理结果序号
-- https://github.com/rime/librime/blob/master/src/rime/processor.h
local results = {
    rejected = 0, -- 拒绝：Rime不执行任何操作 -> 直接由系统进行默认按键操作
    accepted = 1, -- 接受：Rime执行当前逻辑块操作 -> 消耗按键
    noop = 2 -- 忽略：Rime不执行当前逻辑块操作 -> 传递给下个逻辑块
}

-- 不同字符所对应的中文变换
local castings = {
    currency_digits = { [0] = "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" }, -- 货币字符
    currency_units = { [0] = "元", "角", "分" }, -- 货币单位
    currency_separators_minor = { "拾", "佰", "仟" }, -- 货币分隔符
    currency_separators = { "萬", "億", "兆", "京", "垓", "杼", "穰", "溝", "澗", "正", "載", "極" }, -- 货币分隔符（万位）
    number_digits = { [0] = "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" }, -- 数字字符
    number_separators_minor = { "十", "百", "千" }, -- 数字分隔符
    number_separators = { "万", "亿", "兆", "京", "垓", "秭", "壤", "沟", "涧", "正", "载", "极" }, -- 数字分隔符（万位）
    number_separators_decimal = { "分", "厘", "毫", "丝", "忽", "微", "纤", "沙", "尘", "埃", "渺", "漠" }, -- 数字分隔符（小数）
    number_symbols = { ["+"] = "正", ["-"] = "负", ["."] = "点" }, -- 数字符号
    number_digits_military = { [0] = "洞", "幺", "两", "三", "四", "五", "六", "拐", "八", "勾" }, -- 数字字符（军用）
    number_digits_verbal = { [0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" }, -- 数字字符（口语）
    weekdays = { [0] = "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" }, -- 星期数
    weekdays_verbal = { [0] = "周日", "周一", "周二", "周三", "周四", "周五", "周六" } -- 星期数（口语）
}

-- 不同字符所对应的格式变换
-- https://www.lua.org/pil/22.1.html
local formatters = {
    date = "%s年%s月%s日", -- 中文日期格式
    date_simple = "%Y-%m-%d", -- 数字日期格式
    time12 = "%I:%M:%S %p", -- 12小时制格式
    time24 = "%H:%M:%S", -- 24小时制格式
    day = "%d", -- 天数格式
    month = "%m", -- 月份格式
    year = "%Y", -- 年份格式
    week = "%w" -- 星期数序号格式
}

return {
    results = results,
    castings = castings,
    formatters = formatters
}
