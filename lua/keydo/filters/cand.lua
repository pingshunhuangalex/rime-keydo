local utils = require("utils")

local is_valid = utils.is_valid
local starts_with = utils.starts_with
local has_cn_chars = utils.has_cn_chars

-- 候选过滤器
-- - 历史模式候选项过滤（Rime历史模式允许记录所有输入字符，如标点、表情、英文字母等）
-- - 历史模式候选项去重（Rime自带去重允许历史模式中相邻两项重复一次，即重复连续输入）
local function filter(cand_list, env)
    local input = env.engine.context.input -- 输入区字符串
    local history_leader = env.history_leader -- 历史模式引导键

    local prev_cand_text = nil -- 上一个候选项字符串
    local is_history = starts_with(input, history_leader) -- 是否进入历史模式，即输入区是否由历史模式引导键引导

    -- 待遍历的候选项为vector类型，能否将所有过滤器逻辑压缩在用于生成候选项的一次遍历中对渲染速度至关重要
    -- https://github.com/rime/librime/blob/master/src/rime/candidate.h#L56
    for cand in cand_list:iter() do
        -- 若候选项为无效字符串，则跳过（不生成）该候选项
        if not is_valid(cand.text) then
            goto continue
        end

        if is_history then -- 历史模式
            -- 确保历史模式中的候选项不是重复项且含有中文字符，否则跳过（不生成）该候选项
            if cand.text ~= prev_cand_text and has_cn_chars(cand.text) then
                prev_cand_text = cand.text
            else
                goto continue
            end
        end

        yield(cand) -- 生成候选项

        ::continue::
    end
end

-- 初始化
local function init(env)
    local config = env.engine.schema.config

    env.history_leader = config:get_string("repeat_history/input") -- 从设置中读取历史模式引导键
end

return { init = init, func = filter }
