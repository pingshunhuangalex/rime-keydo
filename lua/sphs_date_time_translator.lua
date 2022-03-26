local castings = sphs_constants.castings
local formatters = sphs_constants.formatters

local switch = sphs_modules.switch

local DATE_TYPE = "date"

-- 日期与时间转换器
-- - 获取当前日期（年月日、星期数等）
-- - 获取当前时间（时分秒）
local function translator(input, seg)
    local start = seg.start
    local _end = seg._end

    local date_time_table = {
        [";xt"] = function()
            local time12 = os.date(formatters.time12)
            local time24 = os.date(formatters.time24)

            yield(Candidate(DATE_TYPE, start, _end, time12, ""))
            yield(Candidate(DATE_TYPE, start, _end, time24, ""))
        end,
        [";xw"] = function()
            local weekday_index = tonumber(os.date(formatters.week))
            local weekday = castings.weekdays[weekday_index]

            yield(Candidate(DATE_TYPE, start, _end, weekday, ""))
        end
    }

    switch(input, date_time_table)
end

return { func = translator }
