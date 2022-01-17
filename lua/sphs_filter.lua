local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function has_cn_char(text)
    for pos, code in utf8.codes(text) do
        local char = utf8.char(code)
        local byte1 = char:byte(1)
        local byte2 = char:byte(2)
        local byte3 = char:byte(3)

        if not byte1 or not byte2 or not byte3 then
            goto continue
        end

        -- Chinese characters range from 0x4E00 to 0x9FA5 in Unicode, aka from [228, 184, 128] to [233, 190, 165] in UTF-8.
        -- As a rule of thumb, any characters within [228-233, 128-191, 128-191] can be assumed as Chinese.
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

local function add_keycode_hint(cand, context, reverse)
    local phonetics_keycode = "[bcdefghjklmnpqrstwxyz]"
    local stroke_keycodes = "[aiouv]+"

    local input = context.input

    local lookup = " " .. reverse:lookup(cand.text) .. " "
    local keycode_hint = lookup:match(" (".. phonetics_keycode .. stroke_keycodes .. ") ") or
                         lookup:match(" (".. phonetics_keycode .. phonetics_keycode .. ") ")

    if keycode_hint and
       #input > #keycode_hint and
       not starts_with(keycode_hint, input)
    then
        cand:get_genuine().comment = cand.comment .. " [" .. keycode_hint .. "]"
    end
end

local function sphs_filter(cand_list, env)
    local repeat_keycode = "/" -- sync with repeat_history/input in sphs.schema.yaml

    local context = env.engine.context
    local reverse = env.reverse
    local input = context.input

    local is_sbb_hint_on = context:get_option("sbb_hint")
    local is_repeat_on = starts_with(input, repeat_keycode)

    for cand in cand_list:iter() do
        if cand.text == nil or
           cand.text == "" or
           (is_repeat_on and not has_cn_char(cand.text))
        then
            goto continue
        end

        if is_sbb_hint_on and utf8.len(cand.text) > 1 then
            add_keycode_hint(cand, context, reverse)
        end

        yield(cand)

        ::continue::
    end
end

local function init(env)
    env.reverse = ReverseDb("build/sphs.reverse.bin")
end

return { init = init, func = sphs_filter }
