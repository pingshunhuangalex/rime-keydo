local constants = require("constants")

local castings = constants.castings

-- 在特定的函数池中，根据函数识别名称运行对应函数
--- @generic K, V
--- @param case_id string
--- @param case_table table<K, V>
--- @return V
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
--- @param text string | nil
--- @return boolean
local function is_valid(text)
    -- 若字符串存在，则进一步判断其是否为“空项”（`""`），否则就视为无效
    if text then
        return text ~= ""
    end

    return false
end

-- 判断字符串是否含有固定前缀
--- @param text string
--- @param prefix string
--- @return boolean
local function starts_with(text, prefix)
    return text:sub(1, #prefix) == prefix
end

-- 判断字符串是否含有固定后缀
--- @param text string
--- @param suffix string
--- @return boolean
local function ends_with(text, suffix)
    return text:sub(-#suffix) == suffix
end

-- 判断编码字符串是否由特定编码结尾
--- @param code string
--- @param code_set string
--- @return boolean
local function ends_with_code(code, code_set)
    return is_valid(code:match("[" .. code_set .. "]$"))
end

-- 判断字符串是否含有中文字符
--- @param text string
--- @return boolean
local function has_cn_chars(text)
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

-- 获取字符串中序号位置的字符
--- @param text string
--- @param index number
--- @return string
local function get_char(text, index)
    return text:sub(index, index)
end

-- 获取由特定分隔符分割后的字符串字段集合
--- @param text string
--- @param delimiter string
--- @return table<number, string>
local function split(text, delimiter)
    local result = {};

    -- 若字符串以分隔符为开头，则将首字段定义为“空项”（`""`）
    if (starts_with(text, delimiter)) then
        table.insert(result, "")
    end

    -- 遍历字符串中的非分隔符字段并逐一将其插入表格
    for match in (text .. delimiter):gmatch("([^" .. delimiter .. "]+)") do
        table.insert(result, match)
    end

    -- 若字符串以分隔符为结尾，则将末字段定义为“空项”（`""`）
    if (ends_with(text, delimiter)) then
        table.insert(result, "")
    end

    return result;
end

-- 在特定的变换池中，根据映射规则将罗马数字替换为中文字符
--- @param text string
--- @param digits table
--- @return string
local function to_cn_digits(text, digits)
    -- 全局逐一获取并替换罗马数字为中文字符
    local cn_digits = text:gsub(".", function(char)
        -- 若对应中文字符不存在，则不进行替换
        return digits[tonumber(char)] or char
    end)

    return cn_digits
end

-- 在特定的变换池中，根据映射规则将罗马数字替换为中文数字
--- @param text string
--- @param is_formal? boolean
--- @return string
local function to_cn_number(text, is_formal)
    local delimiter = "."
    local number_segs = split(text, delimiter)
    local segs_size = #number_segs

    if (segs_size ~= 1 and segs_size ~= 2) then
        return text
    end

    local integral = number_segs[1]
    local integral_size = #integral
    local fractional = number_segs[2]

    local index = 1
    local digit_index = integral_size - index + 1

    local integral_cn = integral:gsub(".", function(digit)
        return digit
    end)

    return text .. castings.number_symbols[delimiter] .. to_cn_digits(fractional, castings.number_digits_verbal)
end

-- 在特定的变换池中，根据映射规则将罗马数字替换为中文货币
--- @param text string
--- @return string
local function to_cn_currency(text)
    local number_segs = split(text, ".")

    return text
end

return {
    switch = switch,
    is_valid = is_valid,
    starts_with = starts_with,
    ends_with = ends_with,
    ends_with_code = ends_with_code,
    has_cn_chars = has_cn_chars,
    get_char = get_char,
    split = split,
    to_cn_digits = to_cn_digits,
    to_cn_number = to_cn_number,
    to_cn_currency = to_cn_currency
}
