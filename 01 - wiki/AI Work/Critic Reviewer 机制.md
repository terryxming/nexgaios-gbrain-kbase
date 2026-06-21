---
title: Critic Reviewer 机制
status: active
wiki_page_type: 对象页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性.md"
risk_level: 中
tags:
  - Agent
  - Critic
  - Reviewer
  - 质量审核
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Critic Reviewer 机制

## 当前结论

1. Critic / Reviewer 机制把“生成结果”和“审查结果”分离，适合高风险输出、质量要求高或需要独立复核的任务。
2. Reviewer 不能只评价“看起来不错”，必须基于明确标准检查准确性、完整性、证据、可执行性、安全性和格式。
3. Critic / Reviewer 可以提升质量，但不能替代确定性测试、Trace、业务 Owner 和人工责任。
4. 审查标准不清时，Reviewer 会变成形式审核，无法真正降低风险。
5. Reviewer 的发现应进入 Eval、Regression Case 或待修复清单。

## 适用范围

### 适用

- 代码审查、PRD 审核、广告诊断、客服回复、对外文案、知识编译。
- 需要独立检查事实、证据、风险和格式的任务。
- 需要把失败案例沉淀为回归样本的 Agent。

### 不适用

- 不适用于低风险、完全固定的脚本任务。
- 不替代人工审批。
- 不应在没有评审标准时启用。

## 最小审查维度

| 维度 | 检查问题 |
| --- | --- |
| 准确性 | 结论是否基于输入和证据。 |
| 完整性 | 是否遗漏关键字段、步骤或风险。 |
| 证据性 | 是否能追溯到 raw、数据、代码或工具结果。 |
| 可执行性 | 建议是否具体，能否进入下一步。 |
| 安全性 | 是否越权、泄露、编造或绕过确认。 |
| 格式 | 是否符合输出 schema 或模板。 |

## 输出字段

| 字段 | 含义 |
| --- | --- |
| `finding` | 发现的问题。 |
| `severity` | 风险等级。 |
| `evidence` | 支撑证据。 |
| `recommended_fix` | 修复建议。 |
| `requires_human_review` | 是否需要人工复核。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构]] | Critic / Reviewer 是常用多 Agent 模式，可提升质量，但不能替代确定性测试和人工责任。 |
| [[Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性]] | Agent 质量需要覆盖过程、结果、风险和运营；Eval 与 Trace 支撑审查和回归。 |

## 相关链接

- 上位知识：[[多 Agent 架构模式对比]]
- 相关知识：[[Planner Executor 架构]]
- 前置知识：[[Agent Test 与 Eval]]
- 前置知识：[[Agent Trace 与可观测性]]
- 相关知识：[[Agent Guardrail]]
