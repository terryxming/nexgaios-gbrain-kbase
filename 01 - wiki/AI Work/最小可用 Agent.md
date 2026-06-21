---
title: 最小可用 Agent
status: active
wiki_page_type: 对象页
created: 2026-06-20 23:21
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 5–10 章：最小可用 Agent.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块.md"
risk_level: 中
tags:
  - Agent
  - MVP
  - 最小闭环
  - 质量标准
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# 最小可用 Agent

## 当前结论

1. 最小可用 Agent 不是一个 Prompt，而是由 Goal、Instruction、Context、Tool、Output、Quality Criteria 组成的最小任务系统。
2. 最小可用 Agent 的目标不是一次性做复杂架构，而是先建立可运行、可判断、可复用的任务闭环。
3. Output 和 Quality Criteria 是最小 Agent 的必要组成；没有稳定输出和验收标准，Agent 无法进入测试、评估和长期迭代。
4. 最小闭环应覆盖输入、任务识别、上下文组装、执行计划、工具调用、结构化输出、质量检查和用户反馈。
5. 能固定的步骤应优先用 Workflow 或程序实现，只有需要语义判断、解释、权衡的节点才交给 Agent。

## 适用范围

### 适用

- 从 0 设计一个单任务 Agent。
- 判断一个 Agent MVP 是否已经具备最小闭环。
- 评审 Agent 方案是否遗漏 Goal、Context、Tool、Output 或 Quality Criteria。
- 把一次性提示词改造成可复用任务系统。

### 不适用

- 不替代完整工程化 Agent 架构。
- 不覆盖复杂多 Agent 协作。
- 不作为高风险自动执行任务的上线标准。

## 最小结构

| 模块 | 作用 | 必须回答的问题 |
| --- | --- | --- |
| Goal | 定义任务目标 | 要完成什么？ |
| Instruction | 定义行为规则 | 应该怎么做，不能怎么做？ |
| Context | 提供判断资料 | 需要参考什么？ |
| Tool | 连接外部能力 | 能调用什么？ |
| Output | 定义交付格式 | 最后交付什么？ |
| Quality Criteria | 定义验收标准 | 怎么判断结果合格？ |

## 最小闭环

```text
输入
↓
任务识别
↓
上下文组装
↓
执行计划
↓
工具调用或流程执行
↓
结构化输出
↓
质量检查
↓
用户反馈
```

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 5–10 章：最小可用 Agent]] | 最小 Agent 六件套、Instruction、Context、Tool Use、结构化输出和简单任务闭环。 |
| [[Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块]] | 固定 Workflow、Agent 判断、人机确认、状态和异常处理的工程化原则。 |

## 相关链接

- 上位知识：[[Agent 的本质]]
- 上位流程：[[产品级 Agent 设计方法论]]
- 后续模板：[[Agent Design Canvas]]
- 后续模板：[[Agent 工程模板]]
- 后续流程：[[Agent 质量、安全与可观测体系]]
