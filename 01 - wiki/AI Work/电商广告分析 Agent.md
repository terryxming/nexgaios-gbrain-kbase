---
title: 电商广告分析 Agent
status: active
wiki_page_type: 案例页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 61–68 章：真实项目实战.md"
risk_level: 中
tags:
  - Agent
  - 电商广告
  - AmazonAds
  - 案例
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# 电商广告分析 Agent

## 当前结论

1. 电商广告分析 Agent 的目标不是解释广告指标，而是基于数据证据诊断广告表现变化，并输出可执行优化动作。
2. 该 Agent 必须把结论落到 campaign、ad group、keyword、search term、ASIN 或时间区间等具体对象。
3. 广告分析 Agent 的输出必须区分事实、判断、建议和风险，禁止凭经验猜测。
4. 调预算、暂停 campaign、否词、改 bid 等动作默认只能生成建议，不能未经确认自动执行。
5. 该案例适合沉淀为 Amazon 广告诊断 Skill、Eval 集和报告模板。

## 适用范围

### 适用

- 分析 ACOS、CTR、CVR、CPC、Spend、Sales、Orders 等广告指标变化。
- 诊断广告异常、流量结构变化、关键词表现变化。
- 生成广告优化建议和复盘报告。
- 建立广告诊断 Eval 样本。

### 不适用

- 不自动修改广告预算、bid 或 campaign 状态。
- 不在缺少数据字段时输出确定根因。
- 不替代运营负责人对策略和利润目标的判断。

## 案例字段

| 字段 | 内容 |
| --- | --- |
| Goal | 诊断广告表现变化原因，并输出可执行优化动作。 |
| Input | 广告报表、Search Term Report、时间区间、目标 ASIN、目标关键词。 |
| Context | 广告结构、历史操作、商品价格、库存、促销、竞品定位。 |
| Tools | 表格读取、指标计算、异常检测、报告生成。 |
| Output | 根因表、证据表、动作表、风险提示。 |
| Quality | 结论有数据证据，动作落到具体对象，风险明确。 |
| Risk | 数据缺失、样本量不足、误判根因、未经确认执行高风险操作。 |
| Asset | 广告诊断 Skill、指标计算脚本、Eval 案例、报告模板。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 61–68 章：真实项目实战]] | 电商广告分析 Agent 的目标、典型任务和质量要求：必须基于数据证据输出根因和动作。 |

## 相关链接

- 上位案例：[[Agent 真实项目案例库]]
- 前置知识：[[Agent Test 与 Eval]]
- 前置知识：[[Agent Guardrail]]
- 前置政策：[[Agent 工具最小权限原则]]
- 相关案例：[[知识管理 Agent]]
