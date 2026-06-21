---
title: Agent Handoff 机制
status: active
wiki_page_type: 对象页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构.md"
risk_level: 中
tags:
  - Agent
  - Handoff
  - 多Agent
  - 交接
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Agent Handoff 机制

## 当前结论

1. Handoff 不是转发聊天记录，而是结构化交接任务状态、上下文、责任边界和输出要求。
2. 多 Agent 协作中，Handoff 决定谁把什么任务交给谁、带什么信息、交付什么结果、失败如何处理。
3. 没有清晰 Handoff 的多 Agent 系统会出现责任不清、上下文污染、重复执行和结果不可追踪。
4. Handoff 必须和 Trace、状态、权限、Eval 一起设计。
5. Handoff 只在职责边界真实存在时使用，不应为了“多 Agent 化”人为制造交接。

## 适用范围

### 适用

- 设计 Supervisor、Pipeline、Router、Planner / Executor、Reviewer 等多 Agent 协作。
- 在不同角色、不同工具权限、不同上下文边界之间交接任务。
- 定义 Agent 之间的输入、输出、责任、失败处理和追踪字段。

### 不适用

- 不适用于单 Agent 能稳定完成的简单任务。
- 不替代共享状态或工作流编排。
- 不用于传递无关历史聊天记录。

## 最小交接字段

| 字段 | 含义 |
| --- | --- |
| `from_agent` | 发起交接的 Agent。 |
| `to_agent` | 接收交接的 Agent。 |
| `task_goal` | 被交接任务的目标。 |
| `current_state` | 当前任务状态和已完成步骤。 |
| `context_package` | 接收方必须使用的上下文。 |
| `constraints` | 权限、禁止事项、风险边界。 |
| `expected_output` | 接收方需要交付什么。 |
| `failure_policy` | 无法完成时如何退回、转人工或停止。 |
| `trace_id` | 交接链路追踪标识。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构]] | 多 Agent 需要通过 Handoff、共享状态、消息协议协作；Handoff 不是转发聊天记录，而是结构化交接任务状态和责任。 |

## 相关链接

- 上位知识：[[多 Agent 架构模式对比]]
- 相关知识：[[Agent Router]]
- 相关知识：[[Planner Executor 架构]]
- 相关知识：[[Critic Reviewer 机制]]
- 前置知识：[[Agent Trace 与可观测性]]
