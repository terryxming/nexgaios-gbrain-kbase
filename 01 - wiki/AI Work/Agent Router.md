---
title: Agent Router
status: active
wiki_page_type: 对象页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构.md"
risk_level: 中
tags:
  - Agent
  - Router
  - 多Agent
  - 路由
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Agent Router

## 当前结论

1. Agent Router 是多 Agent 系统的分诊台，负责识别任务类型并把任务分配给合适 Agent 或流程。
2. Router 错误会导致后续全错，因此必须设计置信度、fallback、转人工和 trace。
3. Router 不应该承担业务执行职责，它只负责分类、路由和交接。
4. Router 适合多业务入口、企业 AI 助手、Agent 工作台和多 Skill 调度。
5. Router 的判断必须可解释，不能只输出目标 Agent 名称。

## 适用范围

### 适用

- 多 Agent 工作台需要根据用户意图选择 Agent。
- 多 Skill 系统需要触发不同能力包。
- 同一入口承载知识问答、文件处理、广告分析、代码任务等多类任务。
- 需要将低置信度任务转人工或转澄清流程。

### 不适用

- 不适用于只有一个明确任务的 Agent。
- 不替代 Planner。
- 不替代业务 Agent 的专业判断。

## 路由输出

| 字段 | 含义 |
| --- | --- |
| `intent` | 识别出的任务意图。 |
| `route` | 推荐目标 Agent、Skill 或 Workflow。 |
| `confidence` | 路由置信度。 |
| `evidence` | 判断依据，来自用户输入或上下文。 |
| `fallback` | 低置信度或无匹配时的处理。 |
| `handoff_payload` | 交给目标 Agent 的结构化上下文。 |

## 常见风险

| 风险 | 处理 |
| --- | --- |
| 把诊断任务路由成概念解释 | 增加意图样本和 near-miss cases。 |
| 把高风险任务路由给低权限 Agent | 路由阶段检查权限等级。 |
| 低置信度仍强行分发 | 进入澄清或人工确认。 |
| Router 做了业务结论 | 限制 Router 只做分类和交接。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构]] | Router 是多 Agent 系统的常用模式，是任务分诊台；路由错会导致后续全错，需要 confidence 和 fallback。 |

## 相关链接

- 上位知识：[[多 Agent 架构模式对比]]
- 前置知识：[[Agent Handoff 机制]]
- 相关知识：[[Planner Executor 架构]]
- 相关知识：[[Agent Test 与 Eval]]
