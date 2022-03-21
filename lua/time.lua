--[[
time_translator: 将 `time` 翻译为当前时间
--]]

local conf = {
   weekday = {"星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"}
}

local function getWeekDay()
   local week = os.date("%w")
   return conf.weekday[week + 1]
end

local function translator(input, seg)
   if (input == ";xt") then
      yield(Candidate("date", seg.start, seg._end, os.date("%H:%M:%S"), ""))
   end
   if (input == ";xw") then
      yield(Candidate("date", seg.start, seg._end, getWeekDay(), ""))
   end
end

return translator
