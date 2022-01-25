local RESULT_ACCEPTED = sphs_common.RESULT_ACCEPTED
local RESULT_NOOP = sphs_common.RESULT_NOOP
local starts_with = sphs_common.starts_with
local is_key = sphs_common.is_key
local is_pressed = sphs_common.is_pressed
local force_select = sphs_common.force_select

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
        return RESULT_NOOP
    end

    -- 若按键为次选键
    -- - 尝试上屏次选项
    -- - 尝试上屏高亮选项
    -- - 清空输入区
    -- - 确保选择按键最终被消耗（应对边界情况，如次选键连按）
    if is_key(SELECT2_KEY, key_event) then
        return force_select(1, RESULT_ACCEPTED, RESULT_ACCEPTED, env)
    end

    -- 除次选键外，仅处理历史模式下的按键事件，其它模式下的按键事件将被传递给下个逻辑块
    if not is_history then
        return RESULT_NOOP
    end

    -- 若在历史模式下按下历史模式引导键
    -- - 尝试上屏高亮选项（保持历史模式开启 -> 不消耗按键 -> 将历史候选项顶上屏）
    -- - 清空输入区（关闭历史模式 -> 消耗按键）
    if is_key(history_leader, key_event) then
        return force_select(nil, RESULT_NOOP, RESULT_ACCEPTED, env)
    end

    -- 若在历史模式下按下其它按键
    -- - 尝试上屏高亮选项
    -- - 清空输入区
    -- - 确保当前按键不被消耗（传递给下个逻辑块 -> 将历史候选项顶上屏）
    return force_select(nil, RESULT_NOOP, RESULT_NOOP, env)
end

-- 初始化
local function init(env)
    local config = env.engine.schema.config

    env.history_leader = config:get_string("repeat_history/input") -- 从设置中读取历史模式引导键
end

return { init = init, func = processor }