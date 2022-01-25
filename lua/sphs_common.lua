-- 处理结果序号
-- https://github.com/rime/librime/blob/master/src/rime/processor.h

local RESULT_REJECTED = 0 -- 拒绝：Rime不执行任何操作 -> 直接由系统进行默认按键操作
local RESULT_ACCEPTED = 1 -- 接受：Rime执行当前逻辑块操作 -> 消耗按键
local RESULT_NOOP = 2 -- 忽略：Rime不执行当前逻辑块操作 -> 传递给下个逻辑块

-- 判断字符串是否有效 -> “无效”的定义为“不存在”（`nil`）或者“空项”（`""`）
local function is_valid(text)
    return text and text ~= ""
end

-- 判断字符串是否含有固定前缀
local function starts_with(text, prefix)
    return text:sub(1, #prefix) == prefix
end

-- 判断字符串是否含有中文字符
local function has_cn_char(text)
    -- 遍历字符串中的每一个字符，并在识别到首个中文字符后终止
    for pos, code in utf8.codes(text) do
        local char = utf8.char(code) -- 当前字符所对应的UTF-8编码
        local byte1 = char:byte(1) -- UTF-8编码第一位
        local byte2 = char:byte(2) -- UTF-8编码第二位
        local byte3 = char:byte(3) -- UTF-8编码第三位

        -- UTF-8编码获取失败则忽略当前字符
        if not byte1 or not byte2 or not byte3 then
            goto continue
        end

        -- 中文字符在Unicode编码中的范围为[0x4E00, 0x9FA5]，其在UTF-8编码中所对应的范围为[(228, 184, 128), (233, 190, 165)]
        -- 一般而言，任何处在([228, 233], [128, 191], [128, 191])范围内的字符都可以被当作中文字符
        -- https://titanwolf.org/Network/Articles/Article?AID=038ec1a2-6ed1-49ac-9bf2-e1b00c376d43
        if (byte1 >= 228 and byte1 <= 233) and
           (byte2 >= 128 and byte2 <= 191) and
           (byte3 >= 128 and byte3 <= 191)
        then
            return true
        end

        ::continue::
    end

    return false
end

-- [处理器]判断按键是否为目标键位
local function is_key(key, key_event)
    local target_key = string.char(key_event.keycode) -- 当前按键对应字符

    -- 若无目标键位，则交由其它函数进行判断
    if not key then
        return true
    end

    return target_key == key
end

-- [处理器]判断按键是否被按下 -> “按下”的定义为按键尚未弹起，不包含修饰键且未激活大写锁定
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
local function force_select(select_index, result_success, result_failure, env)
    local context = env.engine.context

    -- 若指定候选项序号，则上屏待选项并消耗选择按键
    if select_index and context:select(select_index) then
        context:commit()

        return RESULT_ACCEPTED
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
local function force_commit(text, env)
    local engine = env.engine

    local context = engine.context

    context:clear()
    engine:commit_text(text)
end

return {
    RESULT_REJECTED = RESULT_REJECTED,
    RESULT_ACCEPTED = RESULT_ACCEPTED,
    RESULT_NOOP = RESULT_NOOP,
    is_valid = is_valid,
    starts_with = starts_with,
    has_cn_char = has_cn_char,
    is_key = is_key,
    is_pressed = is_pressed,
    force_select = force_select,
    force_commit = force_commit
}
