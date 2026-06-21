---
title: Agent 工程模板
status: active
wiki_page_type: 模板页
created: 2026-06-20 23:21
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块.md"
risk_level: 中
tags:
  - Agent
  - 工程模板
  - 目录结构
  - Skill
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# Agent 工程模板

## 当前结论

1. Agent 工程模板用于把一个 Agent 从一次性 prompt 或对话产物，沉淀为可维护、可测试、可评估、可复用的工程资产。
2. 模板必须把 PRD、行为契约、配置、指令、流程、工具、上下文、输入输出 Schema、测试、评估、脚本、参考资料、文档和变更记录分开管理。
3. `AGENT.md` 是 Agent 的行为契约，`README.md` 是给人看的项目说明，二者不能互相替代。
4. `tests` 和 `evals` 必须分离：tests 检查是否按规则运行，evals 判断结果质量是否足够好。
5. 只有会重复使用、需要长期维护、需要工具或评估的 Agent，才需要进入完整工程模板。

## 适用范围

### 适用

- 将稳定 Agent 能力沉淀成工程项目。
- 设计 Codex Skill、MCP 工具链、内部 Agent 或个人 Agent 工作台模块。
- 建立 Agent 的版本、测试、评估、上下文、工具和文档管理方式。
- 从 Agent Design Canvas 进入工程化落地。

### 不适用

- 不适用于一次性提示词。
- 不适用于仍处于模糊探索期、没有稳定场景的 Agent 想法。
- 不替代具体代码框架、部署架构或运行平台。

## 推荐目录结构

```text
agent-name/
├─ README.md
├─ AGENT.md
├─ PRD.md
├─ config.yaml
├─ CHANGELOG.md
│
├─ prompts/
│  ├─ main.md
│  ├─ tool_policy.md
│  ├─ output_policy.md
│  └─ failure_policy.md
│
├─ workflows/
│  ├─ main.yaml
│  ├─ states.yaml
│  └─ handoffs.yaml
│
├─ tools/
│  ├─ registry.yaml
│  ├─ schemas/
│  └─ docs/
│
├─ context/
│  ├─ context_policy.md
│  ├─ memory_policy.md
│  └─ retrieval_policy.md
│
├─ schemas/
│  ├─ input.schema.json
│  ├─ output.schema.json
│  └─ state.schema.json
│
├─ tests/
│  ├─ trigger_cases.yaml
│  ├─ near_miss_cases.yaml
│  ├─ failure_cases.yaml
│  └─ output_schema_cases.yaml
│
├─ evals/
│  ├─ golden_cases.yaml
│  ├─ scoring_rubric.md
│  └─ regression_cases.yaml
│
├─ scripts/
│  ├─ data_cleaning.py
│  └─ report_generator.py
│
├─ references/
│  ├─ domain_knowledge.md
│  ├─ business_rules.md
│  └─ examples.md
│
├─ assets/
│  ├─ templates/
│  └─ sample_outputs/
│
└─ docs/
   ├─ usage.md
   ├─ runbook.md
   └─ design_notes.md
```

## 核心文件职责

| 文件或目录 | 职责 |
| --- | --- |
| `README.md` | 给人看的项目说明、用途、启动方式和目录说明。 |
| `PRD.md` | 产品目标、用户、场景、范围、非目标和验收标准。 |
| `AGENT.md` | Agent 行为契约，包括 Scope、Inputs、Context、Tools、Workflow、Output、Quality、Failure、Security、Eval。 |
| `config.yaml` | 模型、工具、权限、流程、质量、安全和观测配置。 |
| `prompts/` | 主指令、工具策略、输出策略和失败策略。 |
| `workflows/` | 主流程、状态、交接和异常路径。 |
| `tools/` | 工具注册、Schema、权限说明和工具文档。 |
| `context/` | 上下文、记忆、检索和资料选择策略。 |
| `schemas/` | 输入、输出、状态结构。 |
| `tests/` | 触发、误触发、失败和格式测试。 |
| `evals/` | 黄金案例、评分标准和回归样本。 |
| `scripts/` | 稳定、确定性的程序能力。 |
| `references/` | 领域知识、业务规则和案例。 |
| `assets/` | 模板、示例输出和可复用资产。 |
| `docs/` | 使用说明、运行手册和设计记录。 |
| `CHANGELOG.md` | 版本契约变化记录。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]] | Agent 工程模板、目录结构、AGENT.md、config.yaml、Skill 化和个人 Agent 系统。 |
| [[Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块]] | 工程化模块、配置版本、目录结构、tests 与 evals 的职责分离。 |

## 相关链接

- 上位流程：[[产品级 Agent 设计方法论]]
- 前置模板：[[Agent Design Canvas]]
- 前置概念：[[最小可用 Agent]]
- 后续流程：[[Agent 工具、MCP 与权限治理]]
- 后续流程：[[Agent 质量、安全与可观测体系]]
