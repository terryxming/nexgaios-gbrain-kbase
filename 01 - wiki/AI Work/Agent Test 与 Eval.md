---
title: Agent Test 与 Eval
status: active
wiki_page_type: 对比页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统.md"
risk_level: 中
tags:
  - Agent
  - Test
  - Eval
  - 质量体系
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Agent Test 与 Eval

## 当前结论

1. Test 和 Eval 不能混用：Test 检查 Agent 有没有按规则运行，Eval 判断 Agent 的结果质量是否足够好。
2. Test 更偏工程正确性，输出通常是 pass / fail；Eval 更偏业务质量，输出通常是 score / grade / review。
3. Agent 的 Test 至少覆盖触发、误触发、格式、缺失信息、权限、工具失败和高风险确认。
4. Agent 的 Eval 至少覆盖准确性、完整性、证据性、可执行性、安全性和业务价值。
5. 每次修复失败案例，都应补充回归样本；没有 Eval 集，Agent 迭代只能靠感觉。

## 适用范围

### 适用

- 为 Agent、Skill、MCP 工具链设计质量门禁。
- 判断一个 Agent 是否可以进入内测、生产或自动化执行。
- 沉淀 golden cases、failure cases、edge cases、regression cases、attack cases。
- 区分工程测试和业务质量评估。

### 不适用

- 不替代具体行业评分细则。
- 不替代自动化测试框架实现。
- 不把一次人工好评当成 Eval 集。

## Test 与 Eval 对比

| 对比项 | Test | Eval |
| --- | --- | --- |
| 核心问题 | 有没有按规则运行？ | 做得好不好？ |
| 判断方式 | pass / fail | score / grade / review |
| 关注点 | 触发、格式、权限、流程、错误处理 | 准确性、完整性、有用性、业务价值 |
| 样本来源 | 边界输入、错误输入、触发条件 | 真实任务、黄金案例、失败案例 |
| 典型结果 | 是否通过 | 分数、等级、评审意见 |
| 维护责任 | 工程侧为主 | 工程、产品、业务共同维护 |

## 最小样本类型

| 样本类型 | 用途 |
| --- | --- |
| Trigger Cases | 验证应该触发时能触发。 |
| Near-miss Cases | 验证相似但不该触发时不触发。 |
| Failure Cases | 验证缺数据、工具失败、权限不足时能正确处理。 |
| Golden Cases | 保存高质量标准答案。 |
| Regression Cases | 防止旧问题复发。 |
| Attack Cases | 验证 Prompt Injection、越权和危险工具调用。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 33–42 章：质量、安全与可观测性]] | Test 解决“有没有按规则运行”，Eval 解决“结果质量好不好”；质量体系需覆盖输入、过程、工具、输出、安全和运营。 |
| [[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]] | Eval 集应沉淀成功案例、失败案例、边界案例、攻击案例和回归案例。 |

## 相关链接

- 上位知识：[[Agent 质量、安全与可观测体系]]
- 相关知识：[[Agent Trace 与可观测性]]
- 相关知识：[[Agent Guardrail]]
- 前置知识：[[Agent 工程模板]]
- 后续案例：[[Agent 真实项目案例库]]
