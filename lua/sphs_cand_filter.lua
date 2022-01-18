local function filter(cand_list, env)
    local is_valid = sphs_common.is_valid
    local starts_with = sphs_common.starts_with
    local has_cn_char = sphs_common.has_cn_char

    local repeat_keycode = env.repeat_keycode
    local input = env.engine.context.input

    local is_repeat_on = starts_with(input, repeat_keycode)

    for cand in cand_list:iter() do
        local is_repeat_cand_invalid = is_repeat_on and not has_cn_char(cand.text)

        if not is_valid(cand.text) or is_repeat_cand_invalid then
            goto continue
        end

        yield(cand)

        ::continue::
    end
end

local function init(env)
    local config = env.engine.schema.config

    env.repeat_keycode = config:get_string("repeat_history/input")
end

return { init = init, func = filter }
