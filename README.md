# Rime键道输入法

这个仓库包含了我所有关于[星空键道](https://github.com/xkinput/Rime_JD)的配置与自定义文件。

---

想要进一步了解这款优雅的中文输入方案？来看看我自制的[Rime键道输入法文档](https://pingshunhuangalex.gitbook.io/rime-xkjd/)吧!

## 回归初心

键道创始之初，其核心设计理念的一部分便是词库。“质量极高，大而不臃、全而不废，极低的词组打空率”曾一度是其闪光点。时过境迁，因缺乏统一的词库删改标准加上极其有限的审核维护资源，键道词库正渐渐趋于臃肿，怪词废词不断。

由于目前词库的删改逻辑与我的预想相去甚远，极低的更新频率更是使其雪上加霜。思前想后，我决定摒弃官方词库，另起炉灶，打造属于我自己的键道词库。

> 以新构建的词库为蓝本，本仓库将会同步更新「极速跟打器」所使用的[编码文件](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/%E6%9E%81%E9%80%9F%E8%B7%9F%E6%89%93%E5%99%A8/%E6%98%9F%E7%A9%BA%E9%94%AE%E9%81%93.txt)以保证词库在实际应用中的有效性

## 词库归类逻辑

为加强字词检索时的效率与准确性，同时优化「极速跟打器」中的编码提示与可视化，新词库将更为细化的对字词进行归类，使长度更大且码长更小的字词优先得到映射（[查看词库结构](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.extended.dict.yaml)）。词库的优先级为：

> [多字词组声声词库](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.cizuss.dict.yaml)（需倒序重排） > [专有名词声声词库](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.userss.dict.yaml) > [630简码词库](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.wxw.dict.yaml) > 二级简码词库 > [二字词组声韵词库](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.cizusy.dict.yaml) > [专有名词声韵词库](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.usersy.dict.yaml) > [单字词库](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.danzi.dict.yaml) > 一级简码词库 > [超级字词词库](https://github.com/pingshunhuangalex/rime-xkjd/blob/main/xkjd6.chaojizici.dict.yaml) > 其它词库

## 简码整理逻辑

- 移除简码三重

- 尽可能利用所有二级简码的编码空间

- 调整形码键位上的一级简码以优先考虑零声母汉字

- 尽可能利用所有一级简码与一级简码次选的编码空间

## 词库删改逻辑

- 审核改动字词是否为合理的汉语字词且具有复用性与时效性，尊崇“少既是多”的原则而非盲目占用编码空间（怪词废词越多，顶功效率越差）

- 将改动字词根据其性质与输入方式归类到相应词库

- 根据使用情况调整词频，同时调整四周具有相似编码的字词以优化该区域的平均码长

- 视实际编码情况，在不损害输入效率与可读性的前提下，尽可能利用次选位置与简码编码空间

- 视实际编码情况，在不损害输入效率与可读性的前提下，尽可能使相同结构的词拥有相同的编码长度

- 查看飞键的可行性，并做出相应的改动
