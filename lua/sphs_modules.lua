-- 在特定的函数池中，根据函数识别名称运行对应函数
local function switch(case_id, case_table)
    local case = case_table[case_id] -- 获取识别名称所对应的函数

    -- 若函数存在，则运行该函数
    if case then
        return case()
    end

    local default_case = case_table['default'] -- 获取默认函数

    -- 若默认函数存在，则运行默认函数，否则不进行任何处理
    if default_case then
        return default_case()
    else
        return nil
    end
end

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

        -- 若UTF-8编码获取失败，则忽略当前字符
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

return {
    switch = switch,
    is_valid = is_valid,
    starts_with = starts_with,
    has_cn_char = has_cn_char
}
