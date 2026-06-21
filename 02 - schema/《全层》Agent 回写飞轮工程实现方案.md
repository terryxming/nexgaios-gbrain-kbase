---
schema_version: v0.1.0
knowledge_id: schema-agent-writeback-flywheel-v0.1.0
title: 全层 Agent 回写飞轮工程实现方案
knowledge_layer: schema
wiki_page_type: not_applicable
process_level: not_applicable
material_type: not_applicable
source_type: not_applicable
source_ref: not_applicable
source_title: not_applicable
source_author: not_applicable
captured_at: not_applicable
captured_by: not_applicable
domain_hint: schema
tags:
  - Agent回写
  - 知识飞轮
  - GBrain同步
  - raw编译
route_status: not_applicable
route_rule_version: not_applicable
routed_at: not_applicable
routed_by: not_applicable
status: active
review_status: approved
created_at: 2026-06-21 14:49
updated_at: 2026-06-21 14:55
promoted_at: not_applicable
promotion_basis: not_applicable
archived_at: not_applicable
deprecated_at: not_applicable
deprecated_reason: not_applicable
replaced_by: not_applicable
rejected_reason: not_applicable
compile_status: not_applicable
source_refs: []
compiled_from: []
compiled_to: []
compile_rule_version: not_applicable
compile_batch_id: not_applicable
compiled_at: not_applicable
compiled_by: not_applicable
trust_level: canonical
confidence: high
evidence_level: not_applicable
risk_level: 高
last_verified_at: 2026-06-21 14:49
verified_by: user
retrieval_scope: default
retrieval_priority: high
answer_policy: 可直接回答
search_boost: 0
visibility: private
owner: user
editable_by: []
sensitivity_level: 内部
supersedes: []
superseded_by: []
version: v0.2.0
changelog_ref: 02 - schema/规则变更日志.md
content_hash: unknown
last_synced_at: not_applicable
last_synced_by: not_applicable
sync_status: pending
sync_error: not_applicable
---

# 全层 Agent 回写飞轮工程实现方案

版本：v0.2.0

生命周期：Draft

日期：2026-06-21

适用范围：Agent 对话回写、本地知识库、GitHub 知识库、GBrain DB、MCP 查询

## 1. 规则边界

本方案只做：

1. 规定 Agent 优质内容如何进入知识库。
2. 规定 raw、wiki、schema 进入 GBrain DB 后的运行关系。
3. 规定即时记忆和企业编译的工程链路。
4. 规定跨设备使用时，本地、GitHub、GBrain DB、MCP 的职责。
5. 规定第一版工程验收口径。

本方案不做：

1. 不定义字段枚举。字段以 `《全层》知识字段地图规则.md` 为准。
2. 不定义 Agent 权限边界。回写权限以 `《全层》Agent 回写工具边界规则.md` 为准。
3. 不定义 inbox 路由细则。路由以 `《00 - inbox》路由分发规则.md` 为准。
4. 不定义 raw 到 wiki 编译细则。编译以 `《01 - wiki》知识编译规则.md` 为准。
5. 不定义 MCP 回答优先级。查询以 `《全层》MCP 查询策略规则.md` 为准。

## 2. 总体飞轮

第一版飞轮固定为：

```text
Agent 对话
-> 用户确认值得回写
-> GBrain DB raw 即时记忆
-> MCP 可即时检索
-> 物化到 00 - raw/00 - inbox
-> inbox 路由
-> 00 - raw 领域目录
-> raw 到 wiki 编译
-> 01 - wiki candidate
-> wiki 质量验收
-> 01 - wiki active
-> GitHub 知识库同步
-> GBrain DB 增量更新
-> MCP 查询
-> 下一次 Agent 对话
```

该飞轮包含两条路径：

| 路径 | 作用 | 默认可信度 |
| --- | --- | --- |
| 即时记忆 | Agent 回写 raw 先进入 GBrain DB，供 MCP 立即检索。 | `raw` |
| 企业编译 | raw 经过路由、编译、验收后进入 active wiki。 | `canonical` |

即时记忆解决“刚发生的高价值内容能被找到”。

企业编译解决“长期可复用知识能被默认回答”。

## 3. 系统职责

| 系统 | 职责 | 禁止事项 |
| --- | --- | --- |
| 本地知识库 | 承载 raw、wiki、schema 的 Markdown 源文件。 | 不把 GBrain DB 当作唯一事实来源。 |
| GitHub 知识库 | 承载版本同步、跨设备分发和变更追溯。 | 不保存运行索引状态作为业务事实。 |
| GBrain DB | 承载 Agent 回写 raw 第一落点、运行索引、检索、MCP 查询和 Agent 记忆调用。 | 不把未编译 raw 当作正式知识源。 |
| MCP | 给 Agent 提供查询入口。 | 不把未编译 raw 伪装成 active wiki。 |
| Agent | 生成 raw 回写、编译建议、查询回答。 | 不直接写 active wiki、schema、canonical 结论。 |
| 定时任务 | 执行 inbox 巡检、路由、同步和验收触发。 | 不替代用户复核高风险判断。 |

## 4. 工程能力拆分

第一版需要以下工程能力：

| 能力 | 触发方式 | 输入 | 输出 |
| --- | --- | --- | --- |
| Agent raw 回写 | 用户明确要求沉淀。 | 对话内容、标题建议、来源上下文。 | GBrain DB raw 记录。 |
| raw 物化 | Agent 回写成功后触发。 | GBrain DB raw 记录。 | `00 - raw/00 - inbox` Markdown。 |
| inbox 路由 | 定时任务或用户手动触发。 | inbox 文件。 | raw 领域目录文件，必要时生成 Excel 审核表。 |
| raw 编译扫描 | 定时任务或用户手动触发。 | `compile_status: 未编译` 的 raw。 | 编译候选清单。 |
| raw 到 wiki 编译 | 用户确认或低风险自动执行。 | raw 正文、相关 wiki、编译规则。 | candidate wiki 或 wiki 修改建议。 |
| wiki 质量验收 | wiki 新建、晋升、更新后触发。 | wiki 页面、相关 raw、索引页。 | 验收结论、修复项、晋升记录。 |
| GitHub 同步 | 批量整理完成后触发。 | 本地 Markdown repo。 | 远端 GitHub repo 更新。 |
| GBrain DB 增量更新 | GitHub 同步后触发。 | Markdown repo、include/exclude 范围。 | GBrain DB page、chunk、embedding 和 raw/wiki/schema 状态更新。 |
| MCP 查询 | Agent 回答时触发。 | 用户问题、GBrain DB。 | 分层检索结果和回答。 |

## 5. 回写状态流转

Agent 回写内容必须按以下状态流转：

| 阶段 | 位置 | `status` | `route_status` | `compile_status` | `trust_level` | `answer_policy` |
| --- | --- | --- | --- | --- | --- | --- |
| 即时回写 | `GBrain DB raw` | `inbox` | `pending` | `未编译` | `raw` | `必须提示未验证` |
| 本地物化 | `00 - raw/00 - inbox` | `inbox` | `pending` | `未编译` | `raw` | `必须提示未验证` |
| 完成路由 | `00 - raw/领域目录` | `raw` | `routed` | `未编译` | `raw` | `必须提示未验证` |
| 编译候选 | `01 - wiki` | `candidate` | `not_applicable` | `not_applicable` | `reviewed` | `仅作参考` |
| 正式知识 | `01 - wiki` | `active` | `not_applicable` | `not_applicable` | `canonical` | `可直接回答` |
| 规则知识 | `02 - schema` | `active` | `not_applicable` | `not_applicable` | `canonical` | `可直接回答` |

GBrain DB raw 即时回写状态只表达该记录进入运行层。

本地物化状态表达该记录是否已经落成 Markdown。

GBrain DB 同步状态不改变知识可信等级。

## 6. DB 同步范围

GBrain DB 第一版允许同步三层：

```text
00 - raw
01 - wiki
02 - schema
```

同步后必须保留以下字段用于 MCP 查询：

```text
knowledge_layer
status
review_status
compile_status
trust_level
retrieval_scope
retrieval_priority
answer_policy
visibility
sensitivity_level
source_refs
compiled_from
compiled_to
compile_rule_version
compile_batch_id
```

`01 - wiki active` 是默认查询来源。

`00 - raw` 是已物化的原始材料和证据来源。

`GBrain DB raw` 是即时记忆入口。

`02 - schema` 是规则、流程、字段和权限来源。

未编译 raw 即使进入 GBrain DB，也必须保持：

```yaml
trust_level: raw
retrieval_scope: explicit_only
answer_policy: 必须提示未验证
```

## 7. 跨设备工作流

家里电脑产生新知识时，固定流程为：

```text
家里 Agent 回写到 GBrain DB raw
-> 公司电脑 Agent 可通过 MCP 查询到该 raw 即时记忆
-> 物化任务把该 raw 写入家里本地 00 - raw/00 - inbox
-> GitHub 知识库同步
-> 公司电脑拉取 GitHub 后获得本地 Markdown
-> 后续 raw 编译和 wiki 同步提升为正式知识
```

公司电脑产生新知识时，执行同一流程。

跨设备即时可检索依赖 GBrain DB。

跨设备 Markdown 可编辑性依赖 GitHub。

本地 Markdown 负责可编辑性。

GBrain DB 负责运行时可检索性。

## 8. 冲突处理

出现以下情况时，流程必须暂停自动落地：

| 场景 | 处理 |
| --- | --- |
| raw 与 active wiki 冲突 | raw 标记 `暂缓编译` 或 `部分编译`，登记冲突索引。 |
| Agent 回写涉及权限、财务、合规、客户、商业决策 | 触发用户复核。 |
| wiki 修改会改变正式结论 | 生成 candidate 或修改建议，不直接覆盖 active。 |
| schema 规则需要修改 | 生成变更草案，等待用户确认。 |
| GBrain DB raw 回写失败 | 不生成“已回写”提示，要求用户重试或改为本地草稿。 |
| raw 物化失败 | GBrain DB raw 保留为即时记忆，`sync_status` 标记失败并进入补偿队列。 |
| GBrain DB 增量更新失败 | `sync_status` 写入失败状态，保留 Markdown 源文件。 |

## 9. 第一版验收标准

第一版工程打通必须满足：

1. Agent 能根据用户确认，把内容写入 GBrain DB raw。
2. MCP 能立即检索到该 GBrain DB raw。
3. MCP 使用该 raw 时必须提示未验证。
4. GBrain DB raw 能物化为 `00 - raw/00 - inbox` Markdown。
5. 物化后的 Markdown 与 GBrain DB raw 保持同一个 `knowledge_id`。
6. inbox 路由能处理物化后的 Agent 回写 raw。
7. raw 路由后默认保持 `compile_status: 未编译`。
8. raw 编译后能同步更新 raw 的 `compiled_to`、`compiled_at`、`compiled_by`、`compile_rule_version`、`compile_batch_id`。
9. wiki 编译后能同步写入 `source_refs`、`compiled_from`、`compile_rule_version`、`compile_batch_id`。
10. GBrain DB 能区分 raw、wiki、schema。
11. MCP 默认优先使用 active wiki。
12. 公司电脑无需拉取 GitHub，也能通过 MCP 查询 GBrain DB raw 即时记忆。
13. 公司电脑拉取 GitHub 后，能获得对应 Markdown 源文件。

## 10. 禁止方案

以下方案禁止作为第一版实现：

1. Agent 直接把对话内容写入 active wiki。
2. Agent 直接把对话内容写为 `trust_level: canonical`。
3. Agent 直接写 GBrain DB active wiki。
4. Agent 写入 GBrain DB raw 后不物化为本地 Markdown。
5. DB 内容反向覆盖已存在的本地 Markdown 源文件。
6. 未编译 raw 默认参与正式回答。
7. schema 规则由定时任务自动改写。
8. raw、wiki、schema 同步到 DB 后不保留 `knowledge_layer`。

## 11. 后续同步要求

修改本方案时，必须同步检查：

1. 《全层》知识字段地图规则.md
2. 《全层》Agent 回写工具边界规则.md
3. 《全层》MCP 查询策略规则.md
4. 《00 - inbox》路由分发规则.md
5. 《00 - raw》编译状态规则.md
6. 《01 - wiki》知识编译规则.md
7. 《01 - wiki》质量验收规则.md
8. Agent 回写相关 skill、MCP 工具和定时任务
9. 规则变更日志.md
