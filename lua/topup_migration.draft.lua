local utils = require("utils")
local helpers = require("helpers")

local is_valid = utils.is_valid
local starts_with = utils.starts_with
local ends_with_code = utils.ends_with_code
local has_cn_chars = utils.has_cn_chars
local get_char = utils.get_char

local force_commit = helpers.force_commit

-- 候选过滤器
-- - 历史模式候选项过滤（Rime历史模式允许记录所有输入字符，如标点、表情、英文字母等）
-- - 历史模式候选项去重（Rime自带去重允许历史模式中相邻两项重复一次，即重复连续输入）
-- - 候选项唯一时自动上屏（Rime自带自动上屏只在输入编码与词库编码吻合时才会触发）
local function filter(cand_list, env)
    local input = env.engine.context.input -- 输入区字符串
    local reverse_dict = env.reverse_dict -- 反查词库
    local has_auto_select = env.has_auto_select -- 是否开启自动上屏
    local history_leader = env.history_leader -- 历史模式引导键
    local phonetics_code = env.phonetics_code -- 音码集合
    local stroke_code = env.stroke_code -- 形码集合

    local auto_commit_cand = nil -- 待自动上屏的候选项
    local prev_cand_text = nil -- 上一个候选项字符串
    local is_history = starts_with(input, history_leader) -- 是否进入历史模式，即输入区是否由历史模式引导键引导
    local should_auto_commit = has_auto_select -- 是否优化自动上屏（若自动上屏未开启，则不考虑进一步优化）
    local should_handle_key = ends_with_code(input, phonetics_code .. stroke_code) -- 是否为待处理按键（音码或形码）

    -- 判断是否应该自动上屏，即候选项是否唯一
    local function handle_auto_commit(cand)
        if auto_commit_cand then -- [获取上屏选项]首次有效循环 -> auto_commit_cand = nil，should_auto_commit = true
            if should_auto_commit then -- [取消自动上屏]二次有效循环 -> auto_commit_cand = cand，should_auto_commit = true
                should_auto_commit = false
            end

            return -- [无操作]多次有效循环 -> auto_commit_cand = cand，should_auto_commit = false
        end

        auto_commit_cand = cand

        local code = reverse_dict:lookup(auto_commit_cand.text) or "" -- 待自动上屏的候选项编码

        -- 若字词音码未完整输入（即下一位待输入编码仍为音码），则取消自动上屏
        if ends_with_code(get_char(code, #input + 1), phonetics_code) then
            should_auto_commit = false
        end
    end

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
                handle_auto_commit(cand)

                prev_cand_text = cand.text
            else
                goto continue
            end
        else -- 输入模式
            handle_auto_commit(cand)
        end

        yield(cand) -- 生成候选项

        ::continue::
    end

    -- 优化自动上屏条件
    -- - 当前按键为待处理按键
    -- - 优化自动上屏已开启
    -- - 待自动上屏的候选项存在
    if should_handle_key and should_auto_commit and auto_commit_cand then
        force_commit(auto_commit_cand.text, env)
    end -- 若按键不产生候选项（数字、标点等）或按键为引导键（等号、分号等），则传递给下个逻辑块
end

-- 初始化
local function init(env)
    local config = env.engine.schema.config

    env.reverse_dict = ReverseDb("build/keydo.reverse.bin") -- 从编译文件中获取反查词库

    env.has_auto_select = config:get_bool("speller/auto_select") or false -- 从设置中读取自动上屏设置
    env.history_leader = config:get_string("repeat_history/input") -- 从设置中读取历史模式引导键
    env.phonetics_code = config:get_string("topup/phonetics_code") -- 从设置中读取音码集合
    env.stroke_code = config:get_string("topup/stroke_code") -- 从设置中读取形码集合
end

return { init = init, func = filter }
