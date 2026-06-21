---
title: 产品级 Agent 设计方法论
status: active
wiki_page_type: 流程页
created: 2026-06-20 22:47
updated: 2026-06-20 23:13
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 0–4 章：认知边界与基础概念.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 5–10 章：最小可用 Agent.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 43–52 章｜Agent 产品化.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统.md"
risk_level: 中
tags:
  - Agent
  - 方法论
  - 产品化
  - 流程
process_level: 指南
promoted_at: 2026-06-20 23:13
promotion_basis: 用户确认
---

# 产品级 Agent 设计方法论

## 当前结论

1. 产品级 Agent 设计不能从 prompt、工具或多 Agent 架构开始，必须从用户场景、任务边界和业务价值开始。
2. 一个任务是否适合做成 Agent，取决于任务价值、自动化空间、数据和工具可得性、风险可控性、结果可评估性和产品嵌入性。
3. 产品级 Agent 的最小闭环必须同时定义 Goal、Instruction、Context、Tool、Workflow、Output、Quality、Guardrail 和 Feedback。
4. 工程化保证 Agent 稳定、可控、可追踪、可复用；产品化保证 Agent 有明确用户、场景、指标、信任机制和持续使用入口。
5. 多 Agent、复杂工具和自动执行不是起点；当单 Agent 过载、职责冲突或需要独立审核时，才进入多 Agent 架构设计。

## 适用范围

### 适用

- 设计 Nexgaios 内部 Agent、Skill 或自动化工作流。
- 评估一个业务需求是否适合做成 Agent。
- 将模糊 Agent 想法拆成可执行方案。
- 评审 Agent PRD、Agent 工程模板或 Skill 设计。

### 不适用

- 不替代具体行业 Agent 的业务规则。
- 不替代工程实现细节、API 设计或部署方案。
- 不适用于完全固定、无需判断的脚本任务。

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 0–4 章：认知边界与基础概念]] | Agent 工程化、产品化的定义，以及 Agent 是否值得做的判断条件。 |
| [[Agent 工程化与产品化｜第 5–10 章：最小可用 Agent]] | 最小 Agent 六件套、Instruction、Context、Tool 和结构化输出。 |
| [[Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块]] | 任务拆解、流程建模、状态管理、异常处理和 Human-in-the-loop。 |
| [[Agent 工程化与产品化｜第 43–52 章｜Agent 产品化]] | 场景定义、产品形态、信任设计、指标和运营闭环。 |
| [[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]] | Agent 设计十步法、设计画布、工程模板、Skill 化和 Eval 资产。 |

## 设计流程

| 步骤 | 关键问题 | 输出物 |
| --- | --- | --- |
| 1. 场景识别 | 谁在什么场景下有痛点？ | 场景说明 |
| 2. 任务判断 | 这个任务是否适合 Agent？ | Agent 适配性判断 |
| 3. 目标定义 | 用户最终要什么结果？ | Goal |
| 4. 边界定义 | 处理什么，不处理什么？ | Scope |
| 5. 上下文设计 | Agent 判断需要哪些资料？ | Context Policy |
| 6. 工具设计 | Agent 需要调用哪些能力？权限是什么？ | Tool Spec |
| 7. 流程设计 | 哪些步骤固定，哪些步骤由 Agent 判断？ | Workflow |
| 8. 风险设计 | 哪些动作需要确认、禁止或转人工？ | Guardrail |
| 9. 质量设计 | 如何测试、评估、追踪？ | Test / Eval / Trace |
| 10. 沉淀设计 | 如何复用为 Skill、模板或平台能力？ | Skill / Registry |

## 适配性判断

| 判断项 | 适合 Agent | 不适合 Agent |
| --- | --- | --- |
| 任务路径 | 有一定不确定性，需要判断 | 完全固定，脚本即可 |
| 数据基础 | 有上下文、资料、工具可用 | 没有资料，只能猜 |
| 价值 | 高频、高痛点、高价值 | 低频、低价值 |
| 风险 | 可确认、可回滚、可控 | 高风险且不可撤销 |
| 结果 | 可评估、可改进 | 无法判断好坏 |
| 用户 | 有明确使用者和场景 | 只是技术展示 |

简化判断：

```text
固定规则 -> Workflow / Script
需要知识检索 -> RAG
需要调用工具 -> Tool-Using Agent
需要动态判断 + 多步骤执行 -> Agent
需要多角色协作 -> Multi-Agent
```

## 相关链接

- 上位知识：[[Agent 工程化与产品化知识地图]]
- 前置概念：[[Agent 的本质]]
- 前置概念：[[最小可用 Agent]]
- 后续流程：[[Agent 工具、MCP 与权限治理]]
- 后续流程：[[Agent 质量、安全与可观测体系]]
- 下位模板：[[Agent Design Canvas]]
- 下位模板：[[Agent 工程模板]]
- 证据来源：[[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]]
