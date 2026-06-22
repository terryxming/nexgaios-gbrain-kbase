---
knowledge_id: 'schema-55ce9f101cab'
title: 'raw 目录与编译状态规则'
knowledge_layer: 'schema'
lifecycle_status: 'active'
source: 'not_applicable：not_applicable'
captured_at: 'not_applicable'
domain: 'schema'
tags: []
wiki_page_type: 'not_applicable'
compile_status: 'not_applicable'
compiled_to: []
trust_level: 'canonical'
gbrain_db_sync_status: 'pending'
gbrain_db_sync_error: 'not_applicable'
---

# raw 目录与编译状态规则

版本：v0.1.1

生命周期：Draft

日期：2026-06-22

适用范围：raw 领域目录、目录编号、中文命名、目录重命名、raw 编译状态、覆盖率统计

## 1. raw 定位

`00 - raw` 是本地知识库的原始材料层，不是最终 wiki。

它保存：

1. 未进入 wiki 编译的项目记录。
2. 一手资料。
3. 原始网页剪藏。
4. 原始附件和截图。
5. 历史方案文件。
6. 用户或 Agent 直接写入的未编译笔记。

## 2. 顶层结构

`00 - raw` 下固定保留系统入口目录：

```text
00 - inbox
```

从 `01` 开始是领域目录。

领域目录格式：

```text
NN - 领域名
```

第一版领域目录：

```text
01 - AI Work
02 - Amazon
03 - 认知管理
04 - 财务投资
05 - 设计
06 - 产品
```

## 3. 子分类结构

领域下的子分类使用四位编号：

```text
NNMM - 子分类名
```

其中 `NN` 必须等于父领域编号。

每个领域必须有一个学习分类：

```text
NN01 - 学习
```

学习分类用于保存概念解释、术语说明、工具教程和学习笔记。

## 4. 编号规则

编号只表达排序，不表达永久知识 ID。

规则：

1. `00 - inbox` 是系统入口目录，不属于领域。
2. `01` 起是领域目录。
3. 新增领域使用下一个可用两位编号。
4. 新增子分类使用该领域下一个可用四位编号。
5. 子分类编号前两位必须等于父领域编号。
6. 整理期允许修正跳号和错位编号。
7. 正式同步前必须运行目录校验。
8. 正式同步后，禁止重排已有编号。
9. 正式同步后，只新增编号，不整体重排，不复用已废弃编号。
10. 正式同步后必须重排编号时，先建立迁移清单，再由用户确认。

## 5. 命名中文化

目录名和文件名优先使用中文。

允许保留英文或英文缩写的情况：

1. 产品名：Amazon、GBrain、Supabase、GitHub、Obsidian。
2. 技术名：MCP、API、LLM、RAG、OAuth。
3. 常用工程缩写：PR、CI、CLI、DB。
4. 原始标题必须保留英文才能准确溯源的材料。

文件命名格式：

```text
中文主题 + 必要英文术语 + 可选日期
```

政策、报告、阶段方案、外部资料快照必须带日期。

概念笔记、术语说明、固定工具说明不强制日期。

禁止使用：

```text
note1.md
final.md
new.md
temp.md
misc.md
```

## 6. 目录重命名安全

目录重命名不能只看目录名，还必须看目录内容。

有内容的目录必须按语义映射移动。

目录交换必须使用中转目录，避免 Windows 大小写和同名冲突。

自动化默认只报告计划；实际移动必须得到用户确认。

移动后必须重新运行目录校验。

## 7. 目录校验工程契约

目录校验必须能被脚本或 Agent 稳定复现，不能只输出“看起来没问题”。

每次目录校验至少检查：

1. `00 - raw/00 - inbox` 存在，且不被当作领域目录统计。
2. 领域目录符合 `NN - 领域名`，编号从 `01` 开始。
3. 子分类目录符合 `NNMM - 子分类名`，前两位等于父领域编号。
4. 每个领域至少存在 `NN01 - 学习`。
5. 不存在 `其他`、`未分类`、`杂项`、`临时`、`temp`、`misc` 等兜底目录。
6. Markdown 文件名不存在 `note1.md`、`final.md`、`new.md`、`temp.md`、`misc.md`。
7. 非 Markdown 材料必须存在同名 Markdown 说明卡。
8. 同一目录下不存在清洗后会生成相同 slug 的 Markdown 文件。
9. 已正式同步过的目录编号没有被重排、复用或静默交换。

校验输出必须包含：

```text
检查时间
检查范围
领域目录数量
Markdown raw 数量
非 Markdown 材料数量
说明卡缺失数量
编号问题列表
命名问题列表
slug 冲突列表
是否阻断正式同步
```

出现以下任一情况时，必须阻断正式 GitHub / GBrain DB 同步：

1. 领域目录或子分类编号不合法。
2. 非 Markdown 材料缺少同名 Markdown 说明卡。
3. slug 冲突会导致 GBrain DB 覆盖或合并错误。
4. 正式同步后发生编号重排但没有迁移清单和用户确认。

## 8. 编译状态管理

材料进入领域 raw 目录后，进入 raw 编译状态管理。

本阶段只允许修改：

```text
lifecycle_status
compile_status
compiled_to
gbrain_db_sync_status
gbrain_db_sync_error
```

编译批次、规则版本、执行者、执行时间进入 `_meta/编译日志.md`，不进入每篇 Markdown frontmatter。

只要本阶段修改了 raw frontmatter 或移动了 raw 路径，必须将本地 Markdown 的：

```yaml
gbrain_db_sync_status: 'pending'
gbrain_db_sync_error: 'not_applicable'
```

除非本次操作同时完成正式 GBrain DB 同步并读回验证。

## 9. compile_status

`compile_status` 只允许：

```text
未编译
已编译
部分编译
跳过编译
暂缓编译
已过期
not_applicable
```

含义：

| 值 | 含义 |
| --- | --- |
| 未编译 | 已进入 raw，但尚未判断或尚未进入 wiki 编译。 |
| 已编译 | 核心知识已进入 wiki，且 `compiled_to` 指向对应 wiki。 |
| 部分编译 | 部分知识已进入 wiki，仍有可复用内容未处理。 |
| 跳过编译 | 已判断不进入 wiki，原因写入编译日志或待处理索引。 |
| 暂缓编译 | 暂时不能判断是否进入 wiki，需要补证据、补上下文或用户确认。 |
| 已过期 | 材料已失效，但仍保留追溯价值。 |
| not_applicable | 非 raw 知识使用。 |

位于 `00 - raw` 的 Markdown 材料不得使用 `not_applicable`。

`not_applicable` 只用于 wiki、schema 或其他非 raw 知识层。

## 10. compiled_to 可解析规则

`compiled_to` 必须保持为 YAML 数组。

允许值只包括：

1. wiki 页面路径。
2. Obsidian wiki 链接。
3. 能稳定解析到 wiki 页面的 ID。

示例：

```yaml
compiled_to:
  - '[[Agent 真实项目案例库]]'
```

禁止写入自然语言说明、未确认页面名或不存在的目标。

`compile_status` 为 `已编译` 或 `部分编译` 时，`compiled_to` 不得为空。

`compile_status` 为 `未编译`、`跳过编译` 或 `暂缓编译` 时，`compiled_to` 必须为空，除非正在记录历史已覆盖关系并在编译日志中说明原因。

目录、标题或 wiki 文件名变更后，必须重新解析 `compiled_to`，发现断链时不得继续晋升 wiki。

## 11. 状态闭环

| 场景 | raw `compile_status` | raw frontmatter | wiki 正文 | 编译日志 |
| --- | --- | --- | --- | --- |
| 尚未处理 | `未编译` | `compiled_to: []` | 无 | 可不记录 |
| 核心内容全部进入 wiki | `已编译` | `compiled_to` 指向全部目标 wiki | `依据来源` 指向 raw | 记录规则版本、批次、执行者、时间 |
| 只有部分内容进入 wiki | `部分编译` | `compiled_to` 指向已覆盖 wiki | `依据来源` 指向 raw | 记录未覆盖内容和原因 |
| 判断不值得进 wiki | `跳过编译` | `compiled_to: []` | 无 | 记录跳过原因 |
| 暂时无法判断 | `暂缓编译` | `compiled_to: []` | 必要时写入待处理索引 | 记录缺少的信息 |
| 材料已失效但保留追溯 | `已过期` | 必要时保留 `compiled_to` | 必要时将对应 wiki 降级 | 记录过期原因和替代关系 |

## 12. 新 raw 默认状态

材料从 inbox 分发到 raw 领域目录后，默认写入：

```yaml
lifecycle_status: raw
compile_status: 未编译
compiled_to: []
```

新 raw 不允许直接写成 `已编译`。

只有完成 wiki 编译并同步 `compiled_to` 后，才能改为 `已编译` 或 `部分编译`。

## 13. 已编译判定

raw 标为 `已编译` 必须同时满足：

1. raw 的核心知识已经进入 wiki 的 `当前结论`、`依据来源` 或相关结构。
2. raw 的 `compiled_to` 列出全部对应 wiki 页面。
3. 对应 wiki 页面正文 `依据来源` 能追溯到该 raw。
4. `_meta/编译日志.md` 记录本次编译规则版本、批次、执行者和时间。
5. 不存在明确未处理的核心知识。

如果 raw 只被局部使用，必须标为：

```yaml
compile_status: 部分编译
```

## 14. 冲突与暂缓

raw 与 active wiki 冲突时，禁止直接覆盖 active wiki。

发生冲突时：

1. raw 标记为 `暂缓编译` 或 `部分编译`。
2. `_meta/冲突索引.md` 或 `_meta/待处理索引.md` 记录冲突对象、冲突点和待复核事项。
3. 相关 wiki 页面写入 `冲突与待确认`。

## 15. 覆盖率统计

统计 raw 编译覆盖率时，必须输出：

```text
raw 总数
Markdown raw 数
非 Markdown raw 数
已编译
部分编译
未编译
跳过编译
暂缓编译
已过期
缺少 compile_status
缺少 compiled_to
raw 引用 wiki 缺失
wiki 依据来源缺失
```

统计必须按领域目录分组。

覆盖率统计中的 `raw 总数` 指可进入知识生产流水线的材料单元：

1. Markdown raw 直接计为一个材料单元。
2. 非 Markdown 原文件与其同名 Markdown 说明卡合并计为一个材料单元。
3. `00 - raw/00 - inbox` 不进入领域 raw 覆盖率统计。
4. `_meta`、索引、路由结果清单和补偿队列不计入 raw 覆盖率。
