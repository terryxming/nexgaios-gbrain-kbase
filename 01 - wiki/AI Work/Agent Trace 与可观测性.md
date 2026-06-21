---
title: Agent Trace 与可观测性
status: active
wiki_page_type: 主题页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 61–68 章：真实项目实战.md"
risk_level: 中
tags:
  - Agent
  - Trace
  - 可观测性
  - AgentOps
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Agent Trace 与可观测性

## 当前结论

1. Trace 是产品级 Agent 的黑匣子；没有 Trace，就无法还原过程、定位失败、评估工具调用或做回归治理。
2. Agent 可观测性不能只记录最终输出，必须记录输入、上下文、步骤、工具调用、模型判断、错误、成本、延迟和用户反馈。
3. Trace 是 Guardrail、Eval、AgentOps 和事故复盘的共同证据来源。
4. 没有 Trace 的 Agent 不应被授予高风险工具权限。
5. 可观测性指标应同时覆盖任务成功率、工具成功率、护栏触发率、延迟、成本、失败率和用户采纳率。

## 适用范围

### 适用

- 设计 Agent、Skill、MCP 工具链的运行记录。
- 调试 Agent 工具调用、上下文选择、输出质量和失败原因。
- 建立 AgentOps、事故复盘、回归测试和用户反馈闭环。
- 判断某个 Agent 是否具备可上线观测基础。

### 不适用

- 不替代具体日志平台或可观测系统实现。
- 不直接定义数据留存周期和隐私合规策略。
- 不用于记录无关闲聊或不必要敏感信息。

## 必须记录

| 记录项 | 用途 |
| --- | --- |
| 用户输入 | 判断任务触发和目标识别是否正确。 |
| 上下文来源 | 判断是否使用了正确资料。 |
| 执行步骤 | 还原任务流程和状态转移。 |
| 工具调用 | 记录工具名、参数、返回结果和错误。 |
| 模型输出 | 记录中间判断和最终交付。 |
| Guardrail 触发 | 说明拦截原因和处理动作。 |
| 成本与延迟 | 支撑产品化和运营优化。 |
| 用户反馈 | 形成 eval 和迭代样本。 |

## 关键指标

| 指标 | 含义 |
| --- | --- |
| `task_success_rate` | 任务完成率。 |
| `tool_call_success_rate` | 工具调用成功率。 |
| `guardrail_trigger_rate` | 护栏触发率。 |
| `retry_rate` | 重试率。 |
| `failure_rate` | 失败率。 |
| `p95_latency` | 高分位延迟。 |
| `avg_cost_per_run` | 单次平均成本。 |
| `user_acceptance_rate` | 用户采纳率。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性]] | Trace 是 Agent 黑匣子；生产级 Agent 需要 Test、Eval、Trace、Guardrail、Security、Cost Control、Monitoring 和 AgentOps。 |
| [[Agent 工程化与产品化｜第 61–68 章：真实项目实战]] | 真实 Agent 项目上线必须通过质量、安全、成本、Trace、Owner 和回滚检查。 |

## 相关链接

- 上位知识：[[Agent 质量、安全与可观测体系]]
- 前置知识：[[Agent Test 与 Eval]]
- 相关知识：[[Agent Guardrail]]
- 相关政策：[[Agent 工具最小权限原则]]
- 后续案例：[[Agent 真实项目案例库]]
