---
title: Code Review Agent
status: active
wiki_page_type: 案例页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 61–68 章：真实项目实战.md"
risk_level: 中
tags:
  - Agent
  - CodeReview
  - 代码质量
  - 案例
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Code Review Agent

## 当前结论

1. Code Review Agent 的目标不是泛泛评价代码，而是发现具体缺陷、行为风险、回归风险、权限风险和测试缺口。
2. Code Review 输出必须绑定代码位置、变更上下文和可验证证据。
3. 该 Agent 应优先按风险排序，先报 bug、回归、数据损坏、安全问题，再报风格和可维护性建议。
4. Code Review Agent 不能声称测试通过，除非实际运行并记录结果。
5. 该案例适合与 Critic / Reviewer 机制、Test / Eval、Trace 和 PR 工作流结合。

## 适用范围

### 适用

- 审查 Pull Request、diff、补丁和代码变更。
- 找出 bug、边界条件、测试缺口、安全风险和行为回归。
- 生成带优先级、证据和修复建议的 review 发现。
- 为代码 Agent 建立回归案例和审查标准。

### 不适用

- 不替代人工最终合并决策。
- 不在没有代码上下文时输出确定缺陷。
- 不把风格偏好放在真实风险前面。

## 案例字段

| 字段 | 内容 |
| --- | --- |
| Goal | 审查代码变更中的缺陷、风险和测试缺口。 |
| Input | diff、PR 描述、相关代码、测试结果、需求背景。 |
| Context | 架构约束、编码规范、历史 bug、业务规则。 |
| Tools | 文件读取、测试运行、静态检查、Git diff、CI 日志。 |
| Output | Review findings、风险等级、代码位置、修复建议。 |
| Quality | 发现证据明确，优先级合理，避免无证据猜测。 |
| Risk | 漏报严重 bug、误报浪费精力、虚假测试通过、错误修改代码。 |
| Asset | Review checklist、回归测试、failure cases、代码质量 Eval。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 61–68 章：真实项目实战]] | 代码开发 Agent 必须围绕 PRD、diff、test 和 PR 流程交付，不能虚假完成。 |

## 相关链接

- 上位案例：[[Agent 真实项目案例库]]
- 前置知识：[[Critic Reviewer 机制]]
- 前置知识：[[Agent Test 与 Eval]]
- 前置知识：[[Agent Trace 与可观测性]]
- 相关知识：[[Planner Executor 架构]]
