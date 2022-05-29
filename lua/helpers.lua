local constants = require("constants")

local results = constants.results

-- [处理器]判断按键是否为目标键位
--- @param key string | nil
--- @param key_event unknown
--- @return boolean
local function is_key(key, key_event)
    local target_key = string.char(key_event.keycode) -- 当前按键对应字符

    -- 若无目标键位，则交由其它函数进行判断
    if not key then
        return true
    end

    return target_key == key
end

-- [处理器]判断按键是否被按下 -> “按下”的定义为按键尚未弹起，不包含修饰键且未激活大写锁定
--- @param key string | nil
--- @param key_event unknown
--- @return boolean
local function is_pressed(key, key_event)
    local is_released = key_event:release() -- 按键是否弹起
    -- 按键是否包含修饰键，大写锁定是否激活
    local is_modifier_pressed = key_event:alt() or
                                key_event:ctrl() or
                                key_event:shift() or
                                key_event:super() or
                                key_event:caps()

    return not is_released and not is_modifier_pressed and is_key(key, key_event)
end

-- [处理器]强制选择候选项（无视输入区与候选区状态）
--- @param select_index integer | nil
--- @param result_success integer
--- @param result_failure integer
--- @param env unknown
--- @return integer
local function force_select(select_index, result_success, result_failure, env)
    local context = env.engine.context

    -- 若指定候选项序号，则上屏待选项并消耗选择按键
    if select_index and context:select(select_index) then
        context:commit()

        return results.accepted
    end

    -- 若未指定候选项序号但候选区存在，则上屏当前处于高亮状态的候选项
    if context:get_selected_candidate() then
        context:commit()

        return result_success
    end

    -- 若不存在合适候选项，则清空输入区
    context:clear()

    return result_failure
end

-- [过滤器]强制上屏字符串（无视输入区与候选区状态）
--- @param text string
--- @param env unknown
--- @return nil
local function force_commit(text, env)
    local engine = env.engine

    local context = engine.context

    context:clear()
    engine:commit_text(text)
end

return {
    is_key = is_key,
    is_pressed = is_pressed,
    force_select = force_select,
    force_commit = force_commit
}
