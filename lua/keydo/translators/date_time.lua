local constants = require("constants")
local utils = require("utils")

local castings = constants.castings
local formatters = constants.formatters

local switch = utils.switch
local to_cn_digits = utils.to_cn_digits
local to_cn_number = utils.to_cn_number

local DATE_TYPE = "date" -- 日期与时间所对应的候选项类型字符串

-- 日期与时间转换器
-- - 获取当前日期
-- - 获取当前星期数
-- - 获取当前时间
local function translator(input, seg)
    local start = seg.start -- 高亮选项在输入区字符串中的起始位置
    local _end = seg._end -- 高亮选项在输入区字符串中的结束位置

    -- 日期与时间功能所对应的编码集
    local date_time_table = {
        [";xd"] = function()
            local year = to_cn_digits(tostring(os.date(formatters.year)), castings.number_digits) -- 当前年份
            local month = os.date(formatters.month) -- 当前月份
            local day = os.date(formatters.day) -- 当前天数
            local date = string.format(formatters.date, year, month, day) -- 当前日期（中文大写）
            local date_simple = os.date(formatters.date_simple) -- 当前日期（数字简写）

            yield(Candidate(DATE_TYPE, start, _end, date, ""))
            yield(Candidate(DATE_TYPE, start, _end, date_simple, ""))
        end,
        [";xt"] = function()
            local time24 = os.date(formatters.time24) -- 当前时间（24小时制）
            local time12 = os.date(formatters.time12) -- 当前时间（12小时制）

            yield(Candidate(DATE_TYPE, start, _end, time24, ""))
            yield(Candidate(DATE_TYPE, start, _end, time12, ""))
        end,
        [";xw"] = function()
            local weekday_index = tonumber(os.date(formatters.week)) -- 当前星期数序号
            local weekday = castings.weekdays[weekday_index] -- 当前星期数
            local weekday_verbal = castings.weekdays_verbal[weekday_index] -- 当前星期数（口语）

            yield(Candidate(DATE_TYPE, start, _end, weekday, ""))
            yield(Candidate(DATE_TYPE, start, _end, weekday_verbal, ""))
        end
    }

    switch(input, date_time_table) -- 生成候选项集合
end

return { func = translator }
