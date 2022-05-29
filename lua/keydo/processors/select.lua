local constants = require("constants")
local utils = require("utils")
local helpers = require("helpers")

local results = constants.results

local starts_with = utils.starts_with

local is_key = helpers.is_key
local is_pressed = helpers.is_pressed
local force_select = helpers.force_select

local SELECT1_KEY = " " -- 首选键字符串
local SELECT2_KEY = "'" -- 次选键字符串

-- 选择处理器
-- - 将指定按键用作次选键
-- - 连按历史模式引导键将自动选择候选项首项
local function processor(key_event, env)
    local input = env.engine.context.input -- 输入区字符串
    local history_leader = env.history_leader -- 历史模式引导键

    local is_history = starts_with(input, history_leader) -- 是否进入历史模式，即输入区是否由历史模式引导键引导

    -- 仅处理特定按键事件，其它事件将被传递给下个逻辑块
    -- - 仅处理“按下”事件
    -- - 忽略首选键 -> 空格键作为可以输出字符的选择键应由express_editor控制
    if not is_pressed(nil, key_event) or is_key(SELECT1_KEY, key_event) then
        return results.noop
    end

    -- 若按键为次选键
    -- - 尝试上屏次选项（消耗按键）
    -- - 尝试上屏高亮选项（消耗按键）
    -- - 清空输入区（不消耗按键 -> 传递给下个逻辑块）
    if is_key(SELECT2_KEY, key_event) then
        return force_select(1, results.accepted, results.noop, env)
    end

    -- 除次选键外，仅处理历史模式下的按键事件，其它模式下的按键事件将被传递给下个逻辑块
    if not is_history then
        return results.noop
    end

    -- 若在历史模式下按下历史模式引导键
    -- - 尝试上屏高亮选项（将历史候选项顶上屏 -> 不消耗按键 -> 再次开启历史模式）
    -- - 清空输入区（消耗按键 -> 关闭历史模式）
    if is_key(history_leader, key_event) then
        return force_select(nil, results.noop, results.accepted, env)
    end

    -- 若在历史模式下按下其它按键
    -- - 尝试上屏高亮选项（将历史候选项顶上屏 -> 不消耗按键 -> 传递给下个逻辑块）
    -- - 清空输入区（不消耗按键 -> 传递给下个逻辑块）
    return force_select(nil, results.noop, results.noop, env)
end

-- 初始化
local function init(env)
    local config = env.engine.schema.config

    env.history_leader = config:get_string("repeat_history/input") -- 从设置中读取历史模式引导键
end

return { init = init, func = processor }
