---
schema_version: v0.1.0
knowledge_id: wiki-aiwork-agent-real-project-case-library
title: 'Agent 真实项目案例库'
knowledge_layer: wiki
wiki_page_type: 案例页
process_level: not_applicable
material_type: not_applicable
source_type: not_applicable
source_ref: not_applicable
source_title: not_applicable
source_author: not_applicable
captured_at: not_applicable
captured_by: not_applicable
domain_hint: AI Work
tags:
  - Agent
  - 案例库
  - 项目实战
  - 产品化
  - GBrain
route_status: not_applicable
route_rule_version: not_applicable
routed_at: not_applicable
routed_by: not_applicable
status: active
review_status: reviewed
created_at: 2026-06-20 23:04
updated_at: 2026-06-22 09:22
promoted_at: 2026-06-20 23:13
promotion_basis: 用户确认；2026-06-22 删除测试产物引用，不改变原 active 结论。
archived_at: not_applicable
deprecated_at: not_applicable
deprecated_reason: not_applicable
replaced_by: not_applicable
rejected_reason: not_applicable
compile_status: not_applicable
source_refs:
  - '00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 61–68 章：真实项目实战.md'
  - '00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统.md'
compiled_from:
  - '00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 61–68 章：真实项目实战.md'
  - '00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统.md'
compiled_to: []
compile_rule_version: v0.9.0
compile_batch_id: compile-20260621-001
compiled_at: 2026-06-21 15:35
compiled_by: Codex
trust_level: canonical
confidence: high
evidence_level: raw证据
risk_level: 中
last_verified_at: 2026-06-21 15:35
verified_by: Codex
retrieval_scope: default
retrieval_priority: normal
answer_policy: 可直接回答
search_boost: 0
visibility: private
owner: user
editable_by: []
sensitivity_level: 内部
supersedes: []
superseded_by: []
version: v0.1.2
changelog_ref: _meta/编译日志.md
content_hash: unknown
last_synced_at: not_applicable
last_synced_by: not_applicable
sync_status: pending
sync_error: not_applicable
---

# Agent 真实项目案例库

## 当前结论

1. Agent 真实项目不能只验证“能不能回答”，必须同时设计业务场景、Agent 结构、工程实现、工具接入、上下文系统、质量评估、产品指标和可沉淀资产。
2. 知识管理 Agent 的目标不是总结内容，而是把对话、资料、经验和方法论转化成可检索、可复用、可维护的知识资产。
3. 电商广告分析 Agent 的目标不是解释广告指标，而是基于数据证据诊断广告表现变化，并输出可执行优化动作。
4. 不同 Agent 案例应统一沉淀 Goal、Input、Context、Tools、Output、Quality、Workflow 和风险边界。
5. 项目实战案例的价值，不只是证明某个 Agent 能运行，而是反向沉淀模板、Skill、Eval、工具和项目记忆。

## 适用范围

### 适用

- 沉淀 Nexgaios 内部 Agent 项目案例。
- 对比不同业务场景下 Agent 的 Goal、工具、上下文、质量标准和输出形式。
- 从真实项目中提炼可复用模板、Skill 和评估标准。
- 为后续 Amazon、GBrain、知识管理、客服、PRD、Code Review 等 Agent 提供案例入口。

### 不适用

- 不替代具体项目 PRD。
- 不替代具体业务 SOP 或执行记录。
- 不用于直接证明某个 Agent 已达到 active 生产标准。

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 61–68 章：真实项目实战]] | 知识管理 Agent、电商广告分析 Agent、客服 Agent、PRD Agent、Code Review Agent 等案例框架。 |
| [[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]] | Agent 设计方法论、工程模板、Skill 化、Eval 资产和个人 Agent 工作台。 |

## 案例总览

| 案例 | 核心目标 | 关键输出 | 关键质量要求 |
| --- | --- | --- | --- |
| 知识管理 Agent | 将对话、资料、经验和方法论转化为知识资产。 | Markdown 知识文件、分类建议、关联标签。 | 可检索、可复用、去除闲聊、保留方法。 |
| 电商广告分析 Agent | 基于数据证据诊断广告表现变化。 | 根因表、证据表、优化动作表、风险提示。 | 结论有数据证据，动作落到具体对象。 |
| 客服回复 Agent | 基于客户问题和订单上下文生成可审核回复。 | 回复草稿、证据引用、风险提示。 | 不编造承诺，高风险场景转人工。 |
| PRD / 需求拆解 Agent | 将模糊需求拆成目标、边界、流程和验收标准。 | PRD、用户故事、验收标准、任务拆分。 | 需求边界清晰，可进入研发协作。 |
| Code Review Agent | 审查代码变更中的风险、缺陷和测试缺口。 | Review 发现、风险等级、修复建议。 | 发现优先级明确，证据绑定代码位置。 |
| 个人 Agent 工作台 | 整合常用任务、知识库、工具、Skill、模板和评估。 | 工作台入口、任务模板、Skill 库、记忆系统。 | 可持续复用，可治理，可扩展。 |

## 案例沉淀字段

| 字段 | 含义 |
| --- | --- |
| Goal | 这个 Agent 解决什么任务。 |
| User | 谁使用它。 |
| Input | 需要什么输入。 |
| Context | 需要哪些业务背景、知识库、记忆或状态。 |
| Tools | 需要哪些工具和权限。 |
| Workflow | 执行流程是什么。 |
| Output | 交付物格式和字段。 |
| Quality | 怎么判断结果合格。 |
| Risk | 哪些场景需要拒绝、确认或转人工。 |
| Asset | 运行后沉淀成什么模板、Skill、Eval 或知识。 |

## 相关链接

- 上位知识：[[Agent 工程化与产品化知识地图]]
- 前置流程：[[产品级 Agent 设计方法论]]
- 前置知识：[[Agent 工具、MCP 与权限治理]]
- 前置知识：[[Agent 质量、安全与可观测体系]]
- 前置知识：[[多 Agent 架构模式对比]]
- 下位案例：[[知识管理 Agent]]
- 下位案例：[[电商广告分析 Agent]]
- 下位案例：[[客服回复 Agent]]
- 下位案例：[[PRD 需求拆解 Agent]]
- 下位案例：[[Code Review Agent]]
- 证据来源：[[Agent 工程化与产品化｜第 61–68 章：真实项目实战]]
