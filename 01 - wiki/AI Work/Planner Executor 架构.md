---
title: Planner Executor 架构
status: active
wiki_page_type: 对象页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块.md"
risk_level: 中
tags:
  - Agent
  - Planner
  - Executor
  - 多Agent
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Planner Executor 架构

## 当前结论

1. Planner / Executor 架构把“规划任务步骤”和“执行具体动作”分离，适合目标复杂、步骤较多、需要计划与执行解耦的任务。
2. Planner 负责拆解目标、生成步骤、确定顺序、识别风险；Executor 负责按计划调用工具或流程执行。
3. 该架构必须有 Verifier、Trace 或 Review 机制，否则计划不可执行、执行偏离计划时难以及时发现。
4. 简单任务不应使用 Planner / Executor，固定流程优先 Workflow。
5. Planner 输出必须结构化，不能只写自然语言计划。

## 适用范围

### 适用

- 复杂研究、代码开发、长流程数据分析、跨工具任务。
- 需要先计划、后执行、再检查的任务。
- 执行步骤会影响成本、权限、风险或交付质量。

### 不适用

- 不适用于简单问答和固定脚本任务。
- 不适用于没有 Trace、状态和错误处理的系统。
- 不用于替代业务流程建模。

## 分工

| 模块 | 职责 |
| --- | --- |
| Planner | 理解目标、拆分步骤、定义依赖、识别风险。 |
| Executor | 执行计划、调用工具、记录结果、报告失败。 |
| Verifier | 检查执行结果是否满足计划和质量标准。 |
| Human | 在高风险、低置信度或多方案取舍时确认。 |

## 计划输出字段

| 字段 | 含义 |
| --- | --- |
| `goal` | 总目标。 |
| `steps` | 可执行步骤列表。 |
| `dependencies` | 步骤依赖关系。 |
| `tools_required` | 每步需要的工具。 |
| `risk_points` | 风险点和确认节点。 |
| `acceptance_criteria` | 完成标准。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构]] | Planner / Executor 是常用多 Agent 模式，适合复杂任务，但简单任务不应过度设计。 |
| [[Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块]] | 任务拆解、流程建模、状态机、异常处理和人工介入是工程化 Agent 的基础。 |

## 相关链接

- 上位知识：[[多 Agent 架构模式对比]]
- 前置流程：[[产品级 Agent 设计方法论]]
- 相关知识：[[Agent Handoff 机制]]
- 相关知识：[[Critic Reviewer 机制]]
- 前置知识：[[Agent Trace 与可观测性]]
