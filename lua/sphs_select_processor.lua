local RESULT_ACCEPTED = sphs_common.RESULT_ACCEPTED
local RESULT_NOOP = sphs_common.RESULT_NOOP
local starts_with = sphs_common.starts_with
local is_pressed = sphs_common.is_pressed

local SELECT2_KEY = "'" -- 次选键字符串

-- 选择处理器
-- - 将指定按键用作次选键
-- - 连按历史模式引导键将自动选择候选项首项
local function processor(key_event, env)
    local context = env.engine.context
    local history_leader = env.history_leader -- 历史模式引导键

    local select_index = 1 -- 待选项序号（默认为次选位置）
    local input = context.input -- 输入区字符串
    local is_history = starts_with(input, history_leader) -- 是否进入历史模式，即输入区是否由历史模式引导键引导
    local is_history_select = is_history and is_pressed(history_leader, key_event) -- 是否连按历史模式引导键

    -- 仅处理“选择键”“按下”的事件，其它按键事件将被传递给下个逻辑块
    if not is_pressed(SELECT2_KEY, key_event) and not is_history_select then
        return RESULT_NOOP
    end

    -- 如为连按历史模式引导键的情况，则切换待选项至首选位置
    if is_history_select then
        select_index = 0
    end

    -- 如待选项存在，则上屏待选项并消耗选择按键
    if context:select(select_index) then
        context:commit()

        return RESULT_ACCEPTED
    end

    if context:get_selected_candidate() then -- 如待选项不存在，则上屏当前处于高亮状态的候选项
        context:commit()
    else -- 如不存在合适候选项，则清空输入区
        context:clear()
    end

    return RESULT_ACCEPTED -- 无论进行何种选择，确保选择按键最终被消耗（应对边界情况，如次选键连按）
end

-- 初始化
local function init(env)
    local config = env.engine.schema.config

    env.history_leader = config:get_string("repeat_history/input") -- 从设置中读取历史模式引导键
end

return { init = init, func = processor }
