------------------
-- Rime全局函数 --
------------------

-- `ReverseDb = (path: string) => void`
-- - 根据路径获取编译后的词库
-- - https://github.com/rime/librime/blob/master/src/rime/dict/reverse_lookup_dictionary.h#L41

-- `Candidate = (type: string, start: string, end: string, text: string, comment: string) => Candidate`
-- - 构建一个候选项
-- - https://github.com/rime/librime/blob/master/src/rime/candidate.h#L63

-- `yield = (cand: Candidate) => void`
-- - 生成一个候选项至候选区（每次只能生成一个候选项，但可以多次使用）

----------------
-- 常用逻辑块 --
----------------

-- 常量
keydo_constants = require("keydo_constants")

-- 常用组件
keydo_modules = require("keydo_modules")

-- 逻辑封装
keydo_utils = require("keydo_utils")

--------------------------
-- 键道·我流逻辑块 --
--------------------------

-- `processor = (key_event: KeyEvent, env) => void`
-- - 处理器 -> 响应按键并按照预设的规则依次进行编码处理
-- - https://github.com/rime/librime/blob/master/src/rime/processor.h

-- 顶功处理器
topup_processor = require("for_topup")

-- 选择处理器
keydo_select_processor = require("keydo_select_processor")

-- `translator = (input: string, seg: Segment, env) => void`
-- - 转换器 -> 将划分好的编码段转换为对应候选项
-- - https://github.com/rime/librime/blob/master/src/rime/translator.h

-- 日期与时间转换器
keydo_date_time_translator = require("keydo_date_time_translator")

-- 数字转换器：将阿拉伯数字转换为对应汉字（由`=`引导）
number_translator = require("xnumber")

-- `filter = (cand_list: vector<of<Candidate>>, env) => void`
-- - 过滤器 -> 将转换好的候选项进行过滤（增删改查）
-- - https://github.com/rime/librime/blob/master/src/rime/filter.h

-- 候选过滤器
keydo_cand_filter = require("keydo_cand_filter")
