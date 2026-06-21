---
title: 多 Agent 架构模式对比
status: active
wiki_page_type: 对比页
created: 2026-06-20 23:04
updated: 2026-06-20 23:13
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性.md"
risk_level: 中
tags:
  - Agent
  - 多Agent
  - 架构模式
  - 对比
promoted_at: 2026-06-20 23:13
promotion_basis: 用户确认
---

# 多 Agent 架构模式对比

## 当前结论

1. 多 Agent 不是高级的代名词；只有当角色、上下文、工具、权限或质量标准无法被单 Agent 稳定承载时，才需要引入多 Agent 架构。
2. 多 Agent 架构的本质，是设计谁负责决策、谁负责执行、谁负责审核、谁负责交接。
3. 选择多 Agent 之前，必须先验证 Prompt、Workflow、Single Agent、Single Agent + Tools、Single Agent + Workflow 是否足够。
4. 多 Agent 成功的前提是职责边界、上下文边界、工具权限、交接协议、Trace 和 Eval 都能定义清楚。
5. 没有管理机制的多 Agent 会增加失败率；复杂性必须来自真实任务复杂性，不应来自架构审美。

## 适用范围

### 适用

- 判断某个 Agent 项目是否需要多 Agent。
- 选择 Supervisor、Pipeline、Router、Planner / Executor、Critic / Reviewer、Blackboard 等架构模式。
- 设计多 Agent 之间的职责、交接、权限和质量门禁。
- 评审多 Agent 工作台或企业 Agent Platform 的初始架构。

### 不适用

- 不适用于简单任务或固定流程任务。
- 不替代具体多 Agent 框架的实现文档。
- 不在缺少 trace、eval 和交接协议时直接推动多 Agent 化。

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构]] | 多 Agent 必要性判断、架构模式、handoff、router、planner/executor、critic/reviewer 和平台化。 |
| [[Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性]] | 多 Agent 调试、trace、eval、安全和运营质量前置条件。 |

## 模式对比

| 模式 | 核心设计 | 适合场景 | 主要风险 |
| --- | --- | --- | --- |
| Supervisor / Subagents | 一个主管 Agent 调度多个专家 Agent。 | 多专家协作但需要统一控制。 | Supervisor 成为瓶颈，错误调度会影响全局。 |
| Pipeline | 多个 Agent 按固定顺序接力。 | 流程稳定、有明确阶段的任务。 | 前一步错误会传递，灵活性较低。 |
| Router | 先判断任务类型，再分配给对应 Agent。 | 多业务入口、企业 AI 助手、Agent 工作台。 | 路由错误会导致后续全错。 |
| Planner / Executor | 一个负责规划，一个负责执行。 | 目标复杂、步骤多、需要计划和执行分离。 | 计划不可执行或执行偏离计划。 |
| Critic / Reviewer | 一个生成，一个审查。 | 高风险输出、质量要求高的任务。 | 审查标准不清会变成形式审核。 |
| Blackboard | 多个 Agent 围绕共享工作区协作。 | 复杂研究、持续推理、多人/多角色协作。 | 共享状态污染，责任边界模糊。 |
| Swarm | 多 Agent 分布式自治协作。 | 高复杂探索性系统。 | 难以控制、难以追踪、难以产品化。 |

## 是否需要多 Agent 判断

| 判断问题 | 如果答案是“是” | 说明 |
| --- | --- | --- |
| 是否有明显不同角色？ | 可以考虑 | 如研究、执行、审核。 |
| 是否需要不同工具权限？ | 可以考虑 | 如读取、写入、发送分离。 |
| 是否存在不同上下文边界？ | 可以考虑 | 如财务资料和客服资料分开。 |
| 是否需要并行处理？ | 可以考虑 | 如多方向研究。 |
| 是否需要独立审核？ | 可以考虑 | 如 Critic / Reviewer。 |
| 是否一个 Agent 指令已经过长？ | 可以考虑 | 拆分职责。 |
| 是否已有 trace / eval 能力？ | 必须具备 | 否则调试困难。 |
| 是否能定义清楚交接协议？ | 必须具备 | 否则协作混乱。 |

## 相关链接

- 上位知识：[[Agent 工程化与产品化知识地图]]
- 前置流程：[[产品级 Agent 设计方法论]]
- 前置知识：[[Agent 质量、安全与可观测体系]]
- 下位知识：[[Agent Handoff 机制]]
- 下位知识：[[Agent Router]]
- 下位知识：[[Planner Executor 架构]]
- 下位知识：[[Critic Reviewer 机制]]
- 后续流程：[[Agent 真实项目案例库]]
- 证据来源：[[Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构]]
