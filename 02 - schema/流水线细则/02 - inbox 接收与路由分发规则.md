---
knowledge_id: 'schema-9786bc067620'
title: 'inbox 接收与路由分发规则'
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
memory_type: 'not_applicable'
continuity_db_status: 'not_applicable'
---

# inbox 接收与路由分发规则

版本：v0.3.0

生命周期：Draft

日期：2026-06-22

适用范围：本地 `00 - raw/00 - inbox` 的接收、字段修复、材料包检查、tags 生成、路由判断、高置信度移动、Excel 审核表、路由结果清单、formal DB 同步交接，以及 Agent runtime raw 物化材料的连续性状态交接。

> [!important] 阶段边界
> 本规则只处理本地 raw inbox。
> 它不直接读取、写入、删除或退役 DB runtime raw，也不执行 GitHub / formal GBrain DB 同步。

## 1. 阶段输入

本阶段唯一输入目录：

```text
00 - raw/00 - inbox/*
```

进入本目录前，三类来源已经完成前端分流：

| 来源 | 进入 inbox 前 | 本阶段接收的形态 |
| --- | --- | --- |
| Agent 授权回写 | 已按 09 写入 DB runtime raw，并物化为本地 Markdown。 | 本地 raw inbox Markdown。 |
| 用户手写 | 直接进入本地 raw inbox。 | 本地 Markdown。 |
| Obsidian 剪藏 | 直接进入本地 raw inbox。 | 本地 Markdown 或材料包。 |

支持材料：

```text
Markdown
PDF
图片
截图
Office 文档
网页剪藏附件
```

非 Markdown 文件必须有同名 Markdown 说明卡。说明卡负责承载 frontmatter、来源说明、正文摘要和关联文件列表。

## 2. 接收质量闸门

材料进入本阶段后，先做接收检查。质量不合格时，不得进入路由移动。

| 闸门 | 合格标准 | 不合格处理 |
| --- | --- | --- |
| 文件可读 | Markdown 能解析；非 Markdown 材料包存在说明卡。 | 输出材料包问题，进入人工处理。 |
| 16 字段存在 | frontmatter 符合 `01` 的 16 字段契约。 | 可安全修复则修复；不可修复则阻断。 |
| raw inbox 状态正确 | `knowledge_layer: raw`；`lifecycle_status: inbox`。 | 修复或阻断。 |
| formal sync 状态正确 | inbox 阶段 `gbrain_db_sync_status: excluded`。 | 修复为 `excluded`，并记录修复原因。 |
| 连续性状态不混淆 | Agent 物化材料保留 `continuity_db_status`；非 Agent 材料默认 `not_applicable`。 | 缺失或冲突时标为 `unknown` 并进入人工复核。 |
| 敏感信息安全 | 不含明文密钥、token、Cookie、连接串。 | 阻断，要求脱敏。 |

## 3. 字段修复目标

inbox 阶段 frontmatter 必须全量展示 16 个字段：

```yaml
knowledge_id: <自动生成或沿用>
title: <已有标题、一级标题或文件名>
knowledge_layer: raw
lifecycle_status: inbox
source: <沿用或迁移；缺失为 unknown：unknown>
captured_at: <已有值、旧 created、来源时间或文件修改时间>
domain: unknown
tags: []
wiki_page_type: not_applicable
compile_status: 未编译
compiled_to: []
trust_level: raw
gbrain_db_sync_status: excluded
gbrain_db_sync_error: not_applicable
memory_type: <按 01 判断；不适用写 not_applicable；无法判断写 unknown>
continuity_db_status: <Agent runtime raw 状态；不适用写 not_applicable>
```

字段修复规则：

| 字段 | inbox 默认 | 说明 |
| --- | --- | --- |
| `gbrain_db_sync_status` | `excluded` | raw inbox 不参与 formal GBrain DB 同步。 |
| `memory_type` | `unknown` 或实际类型 | Agent 回写优先按 09 判断；用户手写和剪藏无法判断时写 `unknown`。 |
| `continuity_db_status` | Agent 材料按实际状态；非 Agent 材料 `not_applicable` | 不得用它表达 formal sync。 |
| `domain` | `unknown` | 路由完成后才写具体领域。 |
| `tags` | `[]` | 路由判断后由 Codex 基于正文生成。 |

> [!warning] 旧语义废止
> inbox 阶段不得使用 formal 已同步状态表示 Agent 已写 DB runtime raw。
> runtime raw 状态只能通过 `continuity_db_status`、工具返回包、补偿队列或正文处置记录表达。

## 4. 旧字段迁移

| 旧字段 | 新字段或处理方式 |
| --- | --- |
| `status` | `lifecycle_status` |
| `domain_hint` | `domain` |
| `source_type` + `source_ref` | `source` |
| `sync_status` | `gbrain_db_sync_status`，但 inbox 阶段统一修复为 `excluded`。 |
| `sync_error` | `gbrain_db_sync_error` |
| `created`、`created_at` | `captured_at` |
| `memory_kind`、旧记忆类型字段 | `memory_type`，枚举以 `01` 为准。 |
| runtime raw 工程字段 | 不进入 frontmatter，写入正文处置记录、工具返回包或补偿队列。 |

字段地图外字段删除。删除前必须确认不是正文内容的一部分。

## 5. 执行者分工

| 执行者 | 职责 | 不做什么 |
| --- | --- | --- |
| dry-run 脚本 | frontmatter 结构检查、安全修复、材料包完整性检查、输出待语义判断列表。 | 不移动文件，不同步 DB，不判断业务含义。 |
| Codex / Agent | 阅读正文，判断 `memory_type`、`tags`、目标目录、置信度、是否 schema 材料、是否需要用户复核。 | 不绕过质量闸门，不擅自落 schema。 |
| 用户 | 复核中低置信度、schema 规则材料、冲突目录、安全风险和文件名决策。 | 不需要处理脚本可确定的机械字段修复。 |

## 6. tags 生成规则

inbox 阶段 `tags` 只从正文内容或说明卡正文提取。

1. 优先提取正文中用于判断主题、对象、流程、工具或业务问题的词。
2. 不从路径、来源类型、状态、领域名中机械提取。
3. 不确定时使用 `tags: []`。
4. 单个 tag 不允许空格。
5. 英文多词 tag 使用连字符。
6. 删除重复 tag。
7. 最多保留 8 个 tag。

## 7. 目标目录判断

目标目录不是靠关键词硬匹配。判断顺序：

1. 读正文主体，确认主对象。
2. 判断材料层级：普通 raw 材料、Agent working 材料、schema 规则材料、wiki 编译候选。
3. 判断主对象属于哪个领域：AI Work、Amazon、认知管理、财务投资、设计、产品、schema 等。
4. 判断材料用途：学习、项目、资料、行业资讯、政策、工具、方法、规则、SOP、任务状态。
5. 在现有目录中选择最具体且已经存在的目录。
6. 如果两个以上目录同时满足证据，输出 `待定` 并列出候选目录和理由。
7. 如果没有合适目录，输出 `待定` 并说明是信息不足还是现有目录缺失。

schema 规则材料必须进入用户复核，复核后按 `08 - schema 治理与变更日志规则.md` 落地，不得由自动路由直接移动到 schema active 文件。

Amazon 外部文章、网页剪藏、政策来源、资料提炼，默认优先在 `02 - Amazon` 下选择具体子目录。

| 正文主用途 | 目标目录 |
| --- | --- |
| 学习概念、教程、课程 | `0201 - 学习` |
| 平台政策、规则原文、官方要求 | `0202 - 政策` |
| 外部文章、资料提炼、行业报告、网页剪藏 | `0203 - 资料` |
| 具体项目执行材料 | `0204 - 项目` |
| 广告投放方法、广告数据、广告策略 | `0205 - 广告` |
| 品类研究、竞品、商品机会 | `0206 - 品类` |
| 行业新闻、动态、趋势 | `0207 - 行业资讯` |

## 8. 置信度定义

`高` 置信度必须同时满足：

1. 正文主对象唯一。
2. 材料层级明确，不属于 schema 规则材料。
3. 目标领域唯一。
4. 目标目录唯一且存在。
5. 判断依据来自正文主体或说明卡正文。
6. 不需要用户补充项目、用途、来源或文件名处理意见。
7. 不需要修改文件名。
8. 不命中敏感信息或安全门禁。
9. 非 Markdown 材料包完整。
10. Agent runtime raw 物化材料没有 DB / 本地对象身份冲突。

任一条件不满足，置信度不得为 `高`。

## 9. 直接执行条件

同时满足以下条件，Codex 可以直接移动：

1. 动作建议为 `可移动`。
2. 置信度为 `高`。
3. 建议目标目录唯一。
4. 目标目录存在。
5. 源文件存在于 `00 - raw/00 - inbox`。
6. 目标文件不存在。
7. 当前 `lifecycle_status` 是 `inbox`。
8. 当前 `domain` 是 `unknown`。
9. 不需要修改文件名。
10. 不属于 schema 规则材料。
11. 未命中安全门禁。
12. 自动执行锁与最近修改保护通过。

移动后必须更新为：

```yaml
lifecycle_status: raw
domain: <分发后领域>
tags:
  - <Codex 从正文提取的标签>
compile_status: 未编译
gbrain_db_sync_status: pending
gbrain_db_sync_error: not_applicable
```

移动后 `gbrain_db_sync_status: pending` 的含义是：该文件已经离开 raw inbox，后续可由 GitHub / formal GBrain DB 同步流程处理。

`continuity_db_status` 不因移动自动清空。若材料来自 Agent runtime raw，路由结果清单必须记录是否需要后续退役 runtime raw。

## 10. 自动执行安全边界

自动执行路由前必须创建运行锁。

```text
C:\Users\terry\Downloads\gbrain-inbox-route.lock
```

运行锁存在且未超过 2 小时时，新的路由任务必须停止。

运行锁超过 2 小时时，新的路由任务可以报告过期锁，但不得自动删除，必须让用户确认。

自动执行必须跳过最近 5 分钟内修改过的文件或材料包。

自动执行不得处理正在被 Excel、Obsidian、浏览器剪藏插件或其他进程锁定的文件。

自动执行不得执行：

1. schema 规则落地。
2. Git / GitHub 同步。
3. formal GBrain DB 同步。
4. DB runtime raw 删除或退役。
5. wiki 编译。
6. 新建目录。
7. 删除旧 slug 或 DB 记录。

## 11. 移动事务与材料包

Markdown 单文件按单文件移动。

非 Markdown 材料包必须作为一个整体移动，材料包包括：

1. 原始非 Markdown 文件。
2. 同名 Markdown 说明卡。
3. 与说明卡正文 `关联文件` 列表一致的附件。

材料包移动必须满足：

1. 所有源文件存在。
2. 所有目标文件不存在。
3. 所有目标目录相同。
4. 说明卡和原文件共享同一个 `knowledge_id`。
5. 任一文件移动失败，必须停止后续移动并报告已移动文件清单。

第一版不做自动回滚。发生部分移动时，必须生成用户决策记录，不得继续自动处理该材料包。

## 12. 路由结果清单

每次执行移动后必须生成路由结果清单。保存位置：

```text
C:\Users\terry\Downloads
```

文件名：

```text
YYYY-MM-DD - NN - inbox 路由结果清单.json
```

每条记录固定包含：

```text
knowledge_id
title
old_path
new_path
domain
tags
memory_type
continuity_db_status_before_route
needs_runtime_raw_retirement_review
confidence
evidence
action
route_status
gbrain_db_sync_status_after_route
needs_github_sync
needs_formal_gbrain_db_sync
user_visible_path
error_code
error_message
```

路由结果清单是操作交接件，不是知识材料，不进入 GBrain 知识库。

## 13. 路由后同步交接

路由移动完成后，本阶段只负责标记同步需求，不负责执行正式同步。

路由后的本地 Markdown 必须设置：

```yaml
gbrain_db_sync_status: pending
gbrain_db_sync_error: not_applicable
```

后续 `06 - GBrain DB 同步与 MCP 查询规则.md` 必须消费路由结果清单或重新扫描 `gbrain_db_sync_status: pending` 的文件。

正式同步完成前，Agent 必须这样说明状态：

```text
本地已路由，GitHub 和 formal GBrain DB 同步待完成。
```

如果材料带有 `continuity_db_status: active`，但已经被领域 raw、wiki、schema 或新 working 承接，后续退役动作按 `10` 执行。本阶段只输出交接信号，不直接退役 DB runtime raw。

## 14. Excel 审核表

以下材料进入 Excel：

1. 置信度为 `中` 或 `低`。
2. 动作建议为 `待用户确认`、`不可路由` 或 `转 schema 治理`。
3. 建议目标目录为 `待定`。
4. 存在多个候选目录。
5. 属于 schema 规则材料。
6. 需要用户补充目标目录、用途、项目归属或文件名处理意见。
7. 命中敏感信息或安全门禁。
8. Agent runtime raw 与本地 materialized raw 的对象身份无法确认。

审核表字段固定为：

```text
文件
问题类型
建议 tags
建议目标目录
候选目标目录
判断依据
置信度
memory_type
continuity_db_status
是否需要修改文件名
用户决策
用户指定目标目录
用户备注
执行状态
```

## 15. 完成复验与用户路径

路由完成后必须复验：

1. 旧路径不存在。
2. 新路径存在。
3. frontmatter 16 字段合法。
4. `lifecycle_status` 与路径一致。
5. `domain` 与目标领域一致。
6. `gbrain_db_sync_status` 已从 inbox 的 `excluded` 变为领域 raw 的 `pending`。
7. `continuity_db_status` 未被误改为 formal sync 状态。
8. 非 Markdown 材料包没有被拆散。
9. 路由结果清单已写入。

完成汇报必须说明：

1. 自动移动数量。
2. 待用户决策数量。
3. 跳过数量和原因。
4. 路由结果清单路径。
5. Excel 审核表路径；没有待决材料时写 `无`。
6. 用户查看每个已移动文件时使用的新路径。
7. GitHub / formal GBrain DB 是否仍待同步。
8. DB runtime raw 是否需要后续退役复核。

禁止把旧 inbox 路径作为用户查看入口。
