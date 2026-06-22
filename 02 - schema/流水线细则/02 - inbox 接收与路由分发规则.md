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
---

# inbox 接收与路由分发规则

版本：v0.2.1

生命周期：Draft

日期：2026-06-22

适用范围：inbox 接收、字段修复、tags 生成、目标目录判断、高置信度直接移动、Excel 审核表、自动执行安全边界、路由结果清单、GBrain DB 同步交接

## 1. 阶段输入

```text
00 - raw/00 - inbox/*
```

支持材料：

```text
Markdown
PDF
图片
截图
Office 文档
```

非 Markdown 文件必须有同名 Markdown 说明卡。

## 2. 字段修复目标

inbox 阶段 frontmatter 必须全量展示 14 个字段：

```yaml
knowledge_id: <自动生成或沿用>
title: <已有标题、一级标题或文件名>
knowledge_layer: raw
lifecycle_status: inbox
source: <沿用或迁移；缺失为 unknown：unknown>
captured_at: <已有值、旧 created 或文件修改时间>
domain: unknown
tags: []
wiki_page_type: not_applicable
compile_status: 未编译
compiled_to: []
trust_level: raw
gbrain_db_sync_status: pending
gbrain_db_sync_error: not_applicable
```

Agent 回写进入 inbox 时，`gbrain_db_sync_status: synced` 只表示已写入 GBrain DB raw 即时记忆。路由移动后路径或 slug 发生变化，必须重新进入同步校验。

## 3. 旧字段迁移

| 旧字段 | 新字段 |
| --- | --- |
| `status` | `lifecycle_status` |
| `domain_hint` | `domain` |
| `source_type` + `source_ref` | `source` |
| `sync_status` | `gbrain_db_sync_status` |
| `sync_error` | `gbrain_db_sync_error` |
| `created`、`created_at` | `captured_at` |

`material_type` 已删除，不迁移。

字段地图外字段删除。

## 4. 执行者分工

脚本负责：

1. frontmatter 结构校验。
2. frontmatter 安全修复。
3. 非 Markdown 材料包检查。
4. 输出待 Codex 语义判断材料。

Codex 负责：

1. 阅读正文主体。
2. 判断 `tags`。
3. 判断目标目录。
4. 判断分发后 `domain`。
5. 判断是否属于 schema 规则材料。
6. 输出判断依据、置信度、是否需要改名和动作建议。

用户负责：

1. 复核中低置信度材料。
2. 复核 schema 规则材料。
3. 在 Excel 审核表中决定目标目录、暂缓或不进入知识库。

## 5. tags 生成规则

inbox 阶段 `tags` 只从正文内容或说明卡正文提取。

生成规则：

1. 优先提取正文中用于判断主题、对象、流程、工具或业务问题的词。
2. 不从标题、文件名、路径、来源类型、状态、领域名中提取。
3. 不确定时使用 `tags: []`。
4. 单个 tag 不允许空格。
5. 英文多词 tag 使用连字符。
6. 删除重复 tag。
7. 最多保留 8 个 tag。

合格示例：

```yaml
tags:
  - GBrain
  - agent-memory
  - Supabase
```

不合格示例：

```yaml
tags:
  - agent memory
  - 网页剪藏
  - AI Work
```

## 6. 目标目录判断

目标目录不是靠关键词硬匹配。

判断顺序：

1. 读正文主体，确认主对象。
2. 判断材料层级：普通 raw 材料、schema 规则材料、wiki 编译候选。
3. 判断主对象属于哪个领域：AI Work、Amazon、认知管理、财务投资、设计、产品、schema。
4. 判断材料用途：学习、项目、资料、行业资讯、政策、工具、方法、规则、SOP。
5. 在现有目录中选择最具体且已经存在的目录。
6. 如果两个以上目录同时满足证据，输出 `待定` 并列出候选目录和理由。
7. 如果没有合适目录，输出 `待定` 并说明是信息不足还是现有目录缺失。

schema 规则材料包括：

1. 规则、字段、流程、状态机、版本、生命周期、自动化约束。
2. Agent 执行 SOP、MCP 工具边界、GBrain 同步策略、inbox 路由策略。
3. 直接影响 `02 - schema` 中主手册、流水线细则、模板、脚本或变更日志的内容。

schema 规则材料不得由自动执行流程直接移动到 `00 - raw` 领域目录。

schema 规则材料必须进入用户复核，复核后按 `08 - schema 治理与变更日志规则.md` 落地。

Amazon 外部文章、网页剪藏、政策来源、资料提炼，默认优先在 `02 - Amazon` 下选择具体子目录：

| 正文主用途 | 目标目录 |
| --- | --- |
| 学习概念、教程、课程 | `0201 - 学习` |
| 平台政策、规则原文、官方要求 | `0202 - 政策` |
| 外部文章、资料提炼、行业报告、网页剪藏 | `0203 - 资料` |
| 具体项目执行材料 | `0204 - 项目` |
| 广告投放方法、广告数据、广告策略 | `0205 - 广告` |
| 品类研究、竞品、商品机会 | `0206 - 品类` |
| 行业新闻、动态、趋势 | `0207 - 行业资讯` |

## 7. 置信度定义

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

任一条件不满足，置信度不得为 `高`。

`中` 置信度表示目标目录有主要候选，但仍存在一个需要用户确认的判断。

`低` 置信度表示目标目录、材料层级或用途无法可靠判断。

## 8. 直接执行条件

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

移动后必须更新：

```yaml
lifecycle_status: raw
domain: <分发后领域>
tags:
  - <Codex 从正文提取的标签>
compile_status: 未编译
gbrain_db_sync_status: pending
gbrain_db_sync_error: not_applicable
```

路径、目录、文件名或 slug 变化后，旧的 `gbrain_db_sync_status: synced` 自动失效。

## 9. 自动执行安全边界

自动执行路由前必须创建运行锁。

运行锁固定为：

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
3. GBrain DB 正式同步。
4. wiki 编译。
5. 新建目录。
6. 删除旧 slug 或 DB 记录。

自动执行完成后必须释放运行锁。

异常退出时必须在完成汇报中说明锁是否残留。

## 10. 移动事务与材料包

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

第一版不做自动回滚。

发生部分移动时，必须生成用户决策记录，不得继续自动处理该材料包。

## 11. 路由结果清单

每次执行移动后必须生成路由结果清单。

保存位置：

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
old_slug
new_slug
domain
tags
confidence
evidence
action
route_status
gbrain_db_sync_status_after_route
needs_github_sync
needs_gbrain_db_sync
user_visible_path
error_code
error_message
```

路由结果清单是操作交接件，不是知识材料，不进入 GBrain 知识库。

## 12. 路由后同步交接

路由移动完成后，本阶段只负责标记同步需求，不负责执行正式同步。

路由后的本地 Markdown 必须设置：

```yaml
gbrain_db_sync_status: pending
gbrain_db_sync_error: not_applicable
```

后续 `06 - GBrain DB 同步与 MCP 查询规则.md` 必须消费路由结果清单或重新扫描 `gbrain_db_sync_status: pending` 的文件。

正式同步完成前，Agent 必须这样说明状态：

```text
本地已路由，GBrain DB 正式同步待完成。
```

只有同时满足以下条件，才能把路由后的文件标记为 `gbrain_db_sync_status: synced`：

1. `get_page(new_slug)` 可读。
2. 读回内容对应当前文件正文。
3. 读回 frontmatter 中 `knowledge_id` 与本地一致。
4. 旧 inbox slug 不再作为当前查看入口。
5. 关键词检索或 resolve slug 至少有一项能定位新 slug。

如果 DB 仍只能读到旧 inbox slug，必须保留本地 `pending`，并在完成汇报中给出当前本地路径和当前可读旧 slug。

## 13. Excel 审核表

以下材料进入 Excel：

1. 置信度为 `中` 或 `低`。
2. 动作建议为 `待用户确认`、`不可路由` 或 `转 schema 治理`。
3. 建议目标目录为 `待定`。
4. 存在多个候选目录。
5. 属于 schema 规则材料。
6. 需要用户补充目标目录、用途、项目归属或文件名处理意见。
7. 命中敏感信息或安全门禁。

审核表字段固定为：

```text
文件
问题类型
建议 tags
建议目标目录
候选目标目录
判断依据
置信度
是否需要修改文件名
用户决策
用户指定目标目录
用户备注
执行状态
```

`问题类型` 只允许：

```text
目标目录待定
候选目录冲突
schema 规则材料
需要修改文件名
安全门禁
不可路由
材料包不完整
```

## 14. 完成复验与用户路径

路由完成后必须复验：

1. 旧路径不存在。
2. 新路径存在。
3. frontmatter 14 字段合法。
4. `lifecycle_status` 与路径一致。
5. `domain` 与目标领域一致。
6. `gbrain_db_sync_status` 已因路由移动重置为 `pending`。
7. 非 Markdown 材料包没有被拆散。
8. 路由结果清单已写入。

完成汇报必须说明：

1. 自动移动数量。
2. 待用户决策数量。
3. 跳过数量和原因。
4. 路由结果清单路径。
5. Excel 审核表路径；没有待决材料时写 `无`。
6. 用户查看每个已移动文件时使用的新路径。
7. GBrain DB 是否仍待正式同步。

禁止把旧 inbox 路径作为用户查看入口。
