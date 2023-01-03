# 键道·我流

[![星空键道](https://img.shields.io/badge/%E6%98%9F%E7%A9%BA%E9%94%AE%E9%81%93-2021.12.19%20--%20da33652-orange)](https://github.com/xkinput/Rime_JD/commits/master)

`键道·我流`是一款脱胎于[星空键道]的音形码顶功输入方案。该方案基于[Colemak-DH Matrix布局]并通过[Rime开源输入平台]得以实现。

![Colemak-DH Matrix Layout](https://github.com/pingshunhuangalex/rime-xkjd-docs/blob/main/.gitbook/assets/xkjd-colemak-dh-matrix.png)

作为一款独立的输入方案，用户只需在[下载安装Rime]后将本仓库覆盖于`Rime用户文件夹`，便可无需配置立即使用`键道·我流`。

想要进一步了解这款优雅的中文输入方案？先看看我自制的[Rime键道输入法文档]吧!

## 回归初心

键道创始之初，其核心设计理念的一部分便是词库。“质量极高，大而不臃、全而不废，极低的词组打空率”曾一度是其闪光点。时过境迁，因缺乏统一的词库删改标准加上极其有限的审核维护资源，键道词库正渐渐趋于臃肿，怪词废词不断。

由于目前词库的删改逻辑与我的预想相去甚远，极低的更新频率更是使其雪上加霜。思前想后，我决定摒弃官方词库，另起炉灶，打造属于我自己的键道词库。

## 以词为魂，以库为核

如果说[星空键道]的灵魂在于对字词编码的有理化（即在不增加心智负担的前提下，以高效的方式将字词罗马化），那么`键道·我流`便是在这基础上对字词的解码进行有理化（即在不增加心智负担的前提下，以高效的方式将编码与字词产生联系）。

为达成这一目标，`键道·我流`力求对词库编码规则进行量化，以此来构建一个标准化的词库，从而使用户能通过记忆少量规则来自然反应出字词所需的编码。如词库设计得当，盲打应是`键道·我流`最有效的运用方式（初学者可开启[辅助轮设置]来降低学习难度）。

另外为加强字词检索时的效率与准确性，同时优化「极速跟打器」中的编码提示与可视化，`键道·我流`的[词库结构]对字词进行更为细化的归类，使长度更大且码长更小的字词优先得到映射。

## 简码整理逻辑

- 移除简码三重

- 移除三级简码

- 避免将除一级简码以外的简码空间用于单字

- 尽可能利用所有简码与其次选的编码空间

- 尽可能将完全由一级简码单字组成的二字与三字词组在不改变音形码的情况下编入简码空间（优先使用首选项）

- 移除完全由简码字词（不包括完全由一级简码单字组成的二字与三字词组）组成的多字词组（无论码长是否增加）

- 在多字词组本身不是成语或专有名词的情况下，移除完全由三字词组与任意简码组成的多字词组（无论码长是否增加）

- 移除特殊简码词组所对应的声韵编码词组以节省声韵编码空间（关闭630提示）

- 在码长没有缩短的情况下（含上屏用空格或次码编码），优先采用简码编码形式或直接拆分为单字进行输入以节省声韵编码空间

- 如单字为一级简码，则在声韵编码空间只保留其所对应的声韵全码编码

- 避免将衔接词（不包括完全由一级简码组成的词组）编入特殊简码（优先使用二级简码）

- 避免将网络用语（例如烂梗，谐音和火星文等）和专有名词编入任意简码

- 为特殊简码添加次选，且允许使用形码作为首码，从而将编码空间从630（`21 * 5 + 21 * 5 * 5 = 630`）扩充至1560（`(26 * 5 + 26 * 5 * 5) * 2 = 1560`）

## 词库删改逻辑

- 审核改动字词是否为合理的汉语字词且具有复用性与时效性（应尽量避免网络用语，例如烂梗，谐音和火星文等），尊崇“少既是多”的原则而非盲目占用编码空间（怪词废词越多，顶功效率越差）

- 将改动字词根据其性质与输入方式归类到相应词库

- 尽可能在次选编码位置收录与首选相同结构的词组（无论码长是否增加）

- 在码长没有明显降低（三字或多字词组）的情况下，避免将泛用型前后缀（如`不`，`的`等）编入词组以避免编码膨胀

- 避免将数字、量词与名词同时编入词组来减少编码膨胀（不包括固定搭配或意义抽象）

- 避免收录通过重复叠加形成的多字词组来减少编码膨胀（无论码长是否增加）

- 在出现字词编码长度超出其默认编码长度两位以上时，尽可能利用编码次选位置来降低平均码长

- 根据使用频率调整字词顺序
  - 优先提升高频字词在其所在区域的顺位（无论同区域低频字词的码长是否会膨胀）
  - 在四周字词具有相似使用频率的情况下，调整字词的顺序使该区域的平均码长尽可能降低
  - 在候选字词具有相似使用频率的情况下，应遵循`衔接词 > 常用动词 > 常用名词 > 含数量词 > 文书用词 > 专有名词`的规则来调整字词的顺序

- 如衔接词由衔接字与独立二字词组（非衔接词）组成时，尽可能将其分配在首个形码的编码位置
  - 别（`bd`）
  - 并（`bg`）
  - 不（`bj`）
  - 但（`df`）
  - 还（`hh`）
  - 却（`qh`）
  - 所（`sl`）
  - 也（`ye`）
  - 越（`yh`）
  - 再（`zh`）

- 如形容词由层级前缀与二字形容词（可含`的`后缀）组成时，尽可能将其分配在首个形码的编码位置
  - 怪（`gg`）
  - 过（`gl`）
  - 更（`gr`）
  - 很（`hn`）
  - 好（`hz`）
  - 超（`jz`）
  - 蛮（`mf`）
  - 真（`qn`）
  - 挺（`tg`）
  - 太（`th`）
  - 许（`xl`）
  - 最（`zb`）

- 如名词由二字名词与特定前后缀组成时，尽可能将其分配在首个形码的编码位置
  - 度（`dj`）
  - 者（`fe`）
  - 性（`xg`）

- 如状语由二字动词或名词与介词组成时，尽可能将其分配在首个形码的编码位置
  - 中（`fy`）
  - 后（`hd`）
  - 里（`lk`）

- 如俗语由二字动词与特定后缀组成时，尽可能将其分配在首个形码的编码位置
  - 点（`dm`）

- 尽可能使词组中单字的首、次选位置与词组本身的首、次选位置相对应

- 尽可能使相同结构的词拥有相同的编码长度（优先对应并分配在首个形码的编码位置）
  - 词组如能同时与`办`与`搬`搭配，则确保相应词组顺序为`办`，然后才是`搬`
  - 词组如能同时与`不`、`别`与`被`搭配，则确保相应词组顺序为`不`，`别`，最后才是`被`
  - 词组如能同时与`大`、`多`、`低`与`对`搭配，则确保相应词组顺序为`大`，`多`，`低`，最后才是`对`
  - 词组如能同时与`得`、`地`与`的`搭配，则确保相应词组顺序为`得`，`地`，最后才是`的`
  - 词组如能同时与`爽`、`少`与`深`搭配，则确保相应词组顺序为`爽`，`少`，最后才是`深`
  - 词组如能同时与`高`与`贵`搭配，则确保相应词组顺序为`高`，然后才是`贵`
  - 词组如能同时与`好`与`很`搭配，则确保相应词组顺序为`好`，然后才是`很`
  - 词组如能同时与`花`与`划`搭配，则确保相应词组顺序为`花`，然后才是`划`
  - 词组如能同时与`进`与`出`搭配，则确保相应词组顺序为`进`，然后才是`出`
  - 词组如能同时与`近`、`急`、`长`与`久`搭配，则确保相应词组顺序为`近`，`急`，`长`，最后才是`久`
  - 词组如能同时与`快`与`宽`搭配，则确保相应词组顺序为`快`，然后才是`宽`
  - 词组如能同时与`买`与`卖`搭配，则确保相应词组顺序为`买`，然后才是`卖`
  - 词组如能同时与`男`与`女`搭配，则确保相应词组顺序为`男`，然后才是`女`
  - 词组如能同时与`那`与`哪`搭配，则确保相应词组顺序为`那`，然后才是`哪`
  - 词组如能同时与`他`、`她`与`它`搭配，则确保相应词组顺序为`他`，`她`，最后才是`它`
  - 词组如能同时与`疼`、`痛`与`甜`搭配，则确保相应词组顺序为`疼`，`痛`，最后才是`甜`
  - 词组如能同时与`吃`与`玩`搭配，则确保相应词组顺序为`吃`，然后才是`玩`
  - 词组如能同时与`想`与`像`搭配，则确保相应词组顺序为`想`，然后才是`像`
  - 词组如能同时与`小`、`新`与`响`搭配，则确保相应词组顺序为`小`，`新`，最后才是`响`
  - 词组如能同时与`学`与`爱`搭配，则确保相应词组顺序为`学`，然后才是`爱`
  - 词组如能同时与`有`与`一`搭配，则确保相应词组顺序为`有`，然后才是`一`
  - 词组如能同时与`在`与`再`搭配，则确保相应词组顺序为`在`，然后才是`再`

- 查看飞键的可行性，但在词库中只保留手感最佳的飞键方案（避免无名指、小指与同手）
  - `chao`（`jz`）
  - `che`（`we`）
  - `zhai`（`fh`）
  - `zhao`（`fz`）
  - `zhe`（`fe`）
  - `uang`（与声母不同手的`m`或`x`）

- 查看词组中是否存在多音单字
  - 如读音变化不影响其含义（方言或口语读音），则在词库中只保留手感最佳的读音方案（避免无名指、小指与同手），但在单字中仍保留所有读音所对应的编码
    - 熟（`ed`）
    - 谁（`ew`）
    - 这（`fe`）
    - 尿（`nc`）
    - 那（`ns`）
    - 哪（`ns`）
    - 血（`xh`）
  - 如不同的读音对应的含义不同，则遵循并保留其正确读音所对应的编码
    - 地（`de`，`dk`）
    - 得（`de`，`dw`）
    - 说（`eb`，`el`）
    - 着（`fe`，`fl`）
    - 卡（`ks`，`qs`）

- 确保单字与词组词库中不含有繁体字（无对应简体字的生僻字除外）

- 确保所有单字（无论使用简码与否）均保留了其对应的全码编码

- 测试编码的实际使用情况，确保编码无误且输入效率与可读性没有降低

## 极速跟打器

以新构建的词库为蓝本，本仓库将会同步更新「极速跟打器」所使用的[编码文件]以保证词库在实际应用中的有效性。编码生成的步骤为：

- 将所需字词及其编码（不包含生僻单字、偏旁部首、符号等非必要词库）按词库优先级顺序进行集中

- 在次选的字词编码后添加次选编码（`'`）

- 在下列字词的编码后添加空格编码（`_`）
  - 所有简码字词（不包含特殊简码）
  - 编码的声码部分为奇数且无形码的词组
  - 编码的声码部分为声韵（`sy`）且无形码的单字

- 保持含次选词组、简码词组与所有单字的默认编码排列顺序

- 对多字词组按字数（含标点）进行倒序排列，使长度更大词组优先得到映射

- 在词组字数相同的情况下，对该组词组按编码进行倒序排列，使词组映射组合更加准确（不包含简码词组）

- 测试编码的实际使用情况，确保字词映射无误且理论码长结果理想

[星空键道]: https://github.com/xkinput/Rime_JD
[Colemak-DH Matrix布局]: https://colemakmods.github.io/mod-dh/keyboards.html#matrix-keyboards
[Rime开源输入平台]: https://github.com/rime
[Rime键道输入法文档]: https://pingshunhuangalex.gitbook.io/rime-xkjd/
[下载安装Rime]: https://rime.im/download/
[辅助轮设置]: https://github.com/pingshunhuangalex/rime-xkjd/blob/main/keydo.custom.yaml
[词库结构]: https://github.com/pingshunhuangalex/rime-xkjd/blob/main/keydo.dict.yaml
[编码文件]: https://github.com/pingshunhuangalex/rime-xkjd/blob/main/customisation/%E6%9E%81%E9%80%9F%E8%B7%9F%E6%89%93%E5%99%A8/%E7%BC%96%E7%A0%81%E6%96%87%E4%BB%B6/%E9%94%AE%E9%81%93%C2%B7%E6%88%91%E6%B5%81.txt
