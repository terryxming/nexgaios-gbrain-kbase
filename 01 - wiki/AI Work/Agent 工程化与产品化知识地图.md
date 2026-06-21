---
title: Agent 工程化与产品化知识地图
status: active
wiki_page_type: 索引页
created: 2026-06-20 22:47
updated: 2026-06-20 23:44
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 0–4 章：认知边界与基础概念.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 5–10 章：最小可用 Agent.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 18–24 章：工具、MCP 与外部系统集成.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 25–32 章：状态、记忆与上下文工程.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 43–52 章｜Agent 产品化.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 61–68 章：真实项目实战.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统.md"
risk_level: 中
tags:
  - Agent
  - 工程化
  - 产品化
  - 知识地图
promoted_at: 2026-06-20 23:13
promotion_basis: 用户确认
---

# Agent 工程化与产品化知识地图

## 当前结论

1. Agent 工程化的核心目标，是把看起来聪明的 AI Demo 变成稳定、可控、可复用、可上线的系统。
2. Agent 产品化的核心目标，是把 Agent 能力嵌入真实用户场景，形成可持续使用、可评估、可迭代的产品系统。
3. 产品级 Agent 不是单个 prompt，也不是单个工具调用，而是由目标、指令、上下文、工具、流程、状态、质量、安全、指标和沉淀机制组成的任务型系统。
4. Agent 学习路径应从认知边界开始，经过最小 Agent、工程模块、工具权限、上下文记忆、质量治理、产品化、多 Agent 架构，最后沉淀为方法论、模板、Skill 和工作台。
5. 这组 raw 应编译成 Agent 知识簇，而不是机械生成 10 个章节摘要页。

## 适用范围

### 适用

- 规划 Nexgaios 内部 Agent、Skill、GBrain 或自动化能力建设。
- 判断一个任务是否适合做成 Agent。
- 设计 Agent 工程化学习路线和知识导航。
- 为后续 Agent 设计方法论、工具治理、质量体系、产品化指标等页面提供入口。

### 不适用

- 不替代具体 Agent 项目的 PRD、SOP 或实现文档。
- 不作为 OpenAI、LangGraph、MCP 等外部技术的官方说明。
- 不替代具体规则页；工具权限、安全护栏、质量评估等执行规则以对应 active 页面为准。

## 知识图谱

| 知识组 | 关系 | 页面 |
| --- | --- | --- |
| 总入口 | 上位索引 | [[Agent 工程化与产品化知识地图]] |
| 基础概念 | 下位知识 | [[Agent 的本质]] |
| 基础概念 | 下位知识 | [[最小可用 Agent]] |
| 设计方法 | 下位流程 | [[产品级 Agent 设计方法论]] |
| 设计方法 | 下位模板 | [[Agent Design Canvas]] |
| 设计方法 | 下位模板 | [[Agent 工程模板]] |
| 工具治理 | 下位主题 | [[Agent 工具、MCP 与权限治理]] |
| 工具治理 | 下位知识 | [[Tool Schema 设计]] |
| 工具治理 | 下位知识 | [[MCP Server 与 Client]] |
| 工具治理 | 下位政策 | [[Agent 工具最小权限原则]] |
| 质量安全 | 下位主题 | [[Agent 质量、安全与可观测体系]] |
| 质量安全 | 下位知识 | [[Agent Test 与 Eval]] |
| 质量安全 | 下位知识 | [[Agent Trace 与可观测性]] |
| 质量安全 | 下位知识 | [[Agent Guardrail]] |
| 多 Agent | 下位对比 | [[多 Agent 架构模式对比]] |
| 多 Agent | 下位知识 | [[Agent Handoff 机制]] |
| 多 Agent | 下位知识 | [[Agent Router]] |
| 多 Agent | 下位知识 | [[Planner Executor 架构]] |
| 多 Agent | 下位知识 | [[Critic Reviewer 机制]] |
| 真实案例 | 下位案例 | [[Agent 真实项目案例库]] |
| 真实案例 | 下位案例 | [[知识管理 Agent]] |
| 真实案例 | 下位案例 | [[电商广告分析 Agent]] |
| 真实案例 | 下位案例 | [[客服回复 Agent]] |
| 真实案例 | 下位案例 | [[PRD 需求拆解 Agent]] |
| 真实案例 | 下位案例 | [[Code Review Agent]] |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 0–4 章：认知边界与基础概念]] | Agent 工程化、产品化的基础定义、能力分层和相邻概念边界。 |
| [[Agent 工程化与产品化｜第 5–10 章：最小可用 Agent]] | 最小 Agent 的结构、指令、上下文、工具和输出边界。 |
| [[Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块]] | 工程化 Agent 的任务拆解、状态、异常、人工介入和运行记录。 |
| [[Agent 工程化与产品化｜第 18–24 章：工具、MCP 与外部系统集成]] | Tool、MCP、Tool Schema、权限和外部系统接入。 |
| [[Agent 工程化与产品化｜第 25–32 章：状态、记忆与上下文工程]] | Context、Memory、RAG、Markdown 知识结构和记忆治理。 |
| [[Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性]] | Test、Eval、Trace、Guardrail、成本、延迟和稳定性。 |
| [[Agent 工程化与产品化｜第 43–52 章｜Agent 产品化]] | 用户场景、产品形态、信任机制、指标和运营闭环。 |
| [[Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构]] | 多 Agent 架构模式、handoff、reviewer、blackboard 和平台化。 |
| [[Agent 工程化与产品化｜第 61–68 章：真实项目实战]] | 知识管理 Agent、电商广告分析 Agent、客服 Agent、PRD Agent 等项目案例。 |
| [[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]] | Agent 设计十步法、工程模板、Skill 化、Eval 资产和个人工作台。 |

## 相关链接

- 下位知识：[[产品级 Agent 设计方法论]]
- 后续流程：[[Agent 工具、MCP 与权限治理]]
- 后续流程：[[Agent 质量、安全与可观测体系]]
- 后续流程：[[多 Agent 架构模式对比]]
- 后续流程：[[Agent 真实项目案例库]]
- 同一项目：[[Nexgaios GBrain 五层架构与运行机制说明]]
- 证据来源：[[Agent 工程化与产品化｜第 0–4 章：认知边界与基础概念]]
- 证据来源：[[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]]
