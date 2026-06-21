---
title: 'Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统'
status: raw
created: '2026-05-22 08:59'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 部分编译
compiled_at: 2026-06-20 23:35
compiled_to:
  - "产品级 Agent 设计方法论"
  - "知识管理 Agent"
  - "Agent 工程化与产品化知识地图"
  - "Agent 工程模板"
  - "Agent 真实项目案例库"
  - "Agent Design Canvas"
  - "Agent Test 与 Eval"
  - "PRD 需求拆解 Agent"
tags:
  - 'Agent'
  - 'Skill'
  - 'Knowledge-Base'
---

# Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统

## 阶段定位

本阶段目标：把前面 0–68 章学过的概念、工程模块、质量体系、产品化思路、多 Agent 架构和真实项目，沉淀成一套你可以长期复用的 **Agent 设计方法论 + 工程模板 + Skill 化体系 + Eval 资产 + 个人 Agent 工作台 + 团队治理框架**。

| 能力目标 | 具体表现 |
|---|---|
| 能抽象 | 从具体 Agent 项目中提炼通用设计方法 |
| 能诊断 | 面对模糊需求时，能先做需求分析，而不是直接执行 |
| 能模板化 | 能沉淀标准 Agent 工程目录和文件规范 |
| 能 Skill 化 | 能把一次性能力沉淀成可复用 Skill |
| 能评估 | 能沉淀长期 Eval 集，形成质量门禁 |
| 能系统化 | 能搭建个人 Agent 工作台 |
| 能治理 | 能设计团队级 Agent 规范、权限、复用、评估机制 |
| 能总览 | 能用一张图理解 Agent 工程化与产品化全链路 |

---

# 第 69 章｜Agent 设计方法论

## 69.1 一句话结论

**Agent 设计方法论，是把“我要做一个 Agent”转化成一套稳定流程：先判断任务是否适合 Agent，再定义场景、任务、上下文、工具、流程、质量、安全、产品指标和沉淀方式。**

不要从 prompt 开始。  
不要从工具开始。  
不要从多 Agent 架构开始。  

正确起点是：

```text
用户场景
↓
任务边界
↓
价值判断
↓
最小闭环
↓
工程结构
↓
质量评估
↓
产品化指标
↓
长期沉淀
```

---

## 69.2 费曼解释

设计 Agent 像设计一个“岗位”。

你不会一上来就问：

> 这个员工应该怎么说话？

你会先问：

```text
这个岗位解决什么问题？
谁会使用它？
每天做什么任务？
需要哪些资料？
能用哪些工具？
哪些事情不能做？
做错了怎么办？
怎么考核？
能不能复制到其他岗位？
```

Agent 也是一样。

所以 Agent 设计不是“写一个聪明提示词”，而是：

> **为一个任务型智能岗位设计职责、流程、工具、权限、质量标准和产品入口。**

---

## 69.3 Agent 设计十步法

| 步骤 | 关键问题 | 输出物 |
|---|---|---|
| 1. 场景识别 | 谁在什么场景下有痛点？ | 场景说明 |
| 2. 任务判断 | 这个任务是否适合 Agent？ | Agent 适配性判断 |
| 3. 目标定义 | 用户最终要什么结果？ | Goal |
| 4. 边界定义 | 处理什么，不处理什么？ | Scope |
| 5. 上下文设计 | Agent 判断需要哪些资料？ | Context Policy |
| 6. 工具设计 | Agent 需要调用哪些能力？ | Tool Spec |
| 7. 流程设计 | 哪些步骤固定，哪些步骤让 Agent 判断？ | Workflow |
| 8. 风险设计 | 哪些动作需要确认、禁止或转人工？ | Guardrail |
| 9. 质量设计 | 如何测试、评估、追踪？ | Test / Eval / Trace |
| 10. 沉淀设计 | 如何复用为 Skill、模板、平台能力？ | Skill / Registry |

---

## 69.4 Agent 适配性判断

不是所有任务都适合做 Agent。

| 判断项 | 适合 Agent | 不适合 Agent |
|---|---|---|
| 任务路径 | 有一定不确定性，需要判断 | 完全固定，脚本即可 |
| 数据基础 | 有上下文、资料、工具可用 | 没有资料，只能猜 |
| 价值 | 高频、高痛点、高价值 | 低频、低价值 |
| 风险 | 可确认、可回滚、可控 | 高风险且不可撤销 |
| 结果 | 可评估、可改进 | 无法判断好坏 |
| 用户 | 有明确使用者和场景 | 只是技术展示 |

简化判断：

```text
固定规则 → Workflow / Script
需要知识检索 → RAG
需要调用工具 → Tool-Using Agent
需要动态判断 + 多步骤执行 → Agent
需要多角色协作 → Multi-Agent
```

---

## 69.5 Agent 设计画布

```markdown
# Agent Design Canvas

## 1. 用户与场景
- 用户是谁：
- 当前任务：
- 当前痛点：

## 2. 目标与价值
- 用户目标：
- 业务价值：
- 成功标准：

## 3. 任务边界
- 处理什么：
- 不处理什么：
- 必须人工确认什么：

## 4. 输入与上下文
- 用户输入：
- 系统上下文：
- 知识库：
- 记忆：
- 缺失信息处理：

## 5. 工具与权限
| 工具 | 作用 | 权限 | 是否确认 |
|---|---|---|---|

## 6. 执行流程
| 步骤 | 固定 Workflow | Agent 判断 | 人工确认 |
|---|---|---|---|

## 7. 输出交付
- 输出格式：
- 输出字段：
- 证据要求：
- 风险提示：

## 8. 质量体系
- Test：
- Eval：
- Trace：
- Guardrail：

## 9. 产品指标
- 完成率：
- 采纳率：
- 节省时间：
- 业务结果：

## 10. 沉淀方式
- 是否沉淀为 Skill：
- 是否进入工具库：
- 是否进入 Agent Registry：
```

---

## 69.6 本章核心误区

| 误区 | 正确理解 |
|---|---|
| 从 prompt 开始设计 Agent | 应从用户场景和任务边界开始 |
| 先追求自动化 | 应先追求可控、可评估、可回滚 |
| 一开始做多 Agent | 先验证单 Agent 是否过载 |
| 工具越多越好 | 工具越多，权限和错误路径越复杂 |
| 做完就结束 | Agent 必须进入评估、反馈和沉淀闭环 |

---

# 第 70 章｜Agent 需求分析框架

## 70.1 一句话结论

**Agent 需求分析框架，是在用户需求还模糊时，先把“想法”拆成场景、目标、任务、输入、上下文、工具、风险、输出和验收标准，而不是直接开始实现。**

用户经常说：

```text
我想做一个广告分析 Agent
我想做一个客服 Agent
我想做一个能帮我管理知识库的 Agent
我想做一个自动执行工作的 Agent
```

这些不是 PRD，只是方向。

需求分析的目标是：

```text
把模糊想法 → 变成可设计、可执行、可评估的 Agent 需求
```

---

## 70.2 Agent 需求分析八问

| 问题 | 目的 |
|---|---|
| 1. 谁用？ | 明确用户角色 |
| 2. 在什么场景用？ | 明确触发时机 |
| 3. 当前怎么做？ | 理解原流程 |
| 4. 痛点是什么？ | 判断价值 |
| 5. Agent 要替代或增强哪一步？ | 明确介入点 |
| 6. 需要哪些资料和工具？ | 判断可实现性 |
| 7. 哪些动作有风险？ | 设计权限和确认 |
| 8. 怎么判断做得好？ | 建立验收和 Eval |

---

## 70.3 需求澄清的分层

| 层级 | 问题 | 示例 |
|---|---|---|
| L1 业务目标 | 为什么要做？ | 降低广告诊断时间 |
| L2 用户场景 | 谁在什么时候用？ | 每周广告复盘时 |
| L3 任务流程 | 具体做哪些步骤？ | 读取报表、计算指标、定位根因 |
| L4 数据工具 | 需要哪些资料和工具？ | 广告报表、计算脚本 |
| L5 风险边界 | 哪些不能自动做？ | 不直接调预算 |
| L6 输出标准 | 最后交付什么？ | 诊断报告 + 动作表 |
| L7 质量标准 | 怎么算合格？ | 有证据、有对象、有风险 |
| L8 迭代标准 | 如何持续改进？ | 采纳率、失败案例、eval 分数 |

---

## 70.4 从一句话需求到 Agent PRD

### 原始需求

```text
我想做一个 Amazon 广告分析 Agent。
```

### 需求分析后

| 模块 | 结果 |
|---|---|
| 用户 | Amazon 运营负责人 |
| 场景 | 每周复盘广告表现，发现 ACOS / CVR / CTR 异常 |
| 目标 | 快速定位广告异常原因，输出可执行建议 |
| 输入 | 广告报表、搜索词报表、时间区间、目标 ASIN |
| 上下文 | 价格、促销、库存、类目、核心关键词、历史操作 |
| 工具 | 表格读取、指标计算、异常检测、报告生成 |
| 输出 | 根因表、证据表、建议动作、风险提示 |
| 风险 | 不自动修改预算、bid、campaign 状态 |
| Eval | 根因准确性、建议可执行性、证据完整性 |
| MVP | 先支持 ACOS 异常诊断，不覆盖全广告自动优化 |

---

## 70.5 需求分析输出模板

```markdown
# Agent 需求分析文档

## 1. 背景
- 当前业务问题：
- 为什么现在要做：

## 2. 用户与场景
| 用户 | 场景 | 当前流程 | 痛点 |
|---|---|---|---|

## 3. 目标与非目标
### 目标
- 

### 非目标
- 

## 4. 任务流程
| 步骤 | 当前做法 | Agent 介入方式 |
|---|---|---|

## 5. 输入与上下文
| 信息 | 来源 | 是否必须 | 缺失时处理 |
|---|---|---|---|

## 6. 工具需求
| 工具 | 作用 | 权限 | 风险 |
|---|---|---|---|

## 7. 输出交付
- 输出格式：
- 必备字段：
- 证据要求：

## 8. 风险与护栏
| 风险 | 护栏 |
|---|---|

## 9. MVP 范围
- 先做：
- 暂不做：

## 10. 验收标准
| 标准 | 通过条件 |
|---|---|
```

---

# 第 71 章｜Agent 工程模板

## 71.1 一句话结论

**Agent 工程模板，是把 Agent 的需求、指令、上下文、工具、流程、状态、评估、测试、文档和版本记录组织成固定目录，让 Agent 从一次性产物变成可维护工程资产。**

---

## 71.2 标准目录结构

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

---

## 71.3 核心文件说明

| 文件 / 目录 | 作用 |
|---|---|
| README.md | 给人看的项目说明 |
| PRD.md | Agent 产品需求文档 |
| AGENT.md | Agent 行为契约 |
| config.yaml | 模型、工具、权限、流程配置 |
| prompts/ | 指令系统 |
| workflows/ | 流程、状态、交接 |
| tools/ | 工具注册、Schema、文档 |
| context/ | 上下文、记忆、检索策略 |
| schemas/ | 输入、输出、状态结构 |
| tests/ | 工程测试 |
| evals/ | 质量评估 |
| scripts/ | 稳定确定性程序能力 |
| references/ | 领域知识和业务规则 |
| assets/ | 模板、示例、交付物 |
| docs/ | 使用、运维、设计说明 |
| CHANGELOG.md | 版本变化记录 |

---

## 71.4 AGENT.md 标准模板

```markdown
# Agent Name

## 1. Purpose
这个 Agent 解决什么问题。

## 2. Users
服务哪些用户。

## 3. Scope
### In Scope
- 

### Out of Scope
- 

## 4. Inputs
| 输入 | 来源 | 是否必须 | 缺失处理 |
|---|---|---|---|

## 5. Context Policy
- 使用哪些上下文：
- 不使用哪些上下文：
- 过期信息如何处理：

## 6. Tools
| 工具 | 作用 | 权限 | 是否确认 |
|---|---|---|---|

## 7. Workflow
| 步骤 | 说明 | 工具 | 输出 |
|---|---|---|---|

## 8. State
| 状态 | 含义 | 下一步 |
|---|---|---|

## 9. Human-in-the-loop
| 节点 | 确认内容 |
|---|---|

## 10. Output
- 格式：
- 字段：
- 示例：

## 11. Quality Criteria
- 准确性：
- 完整性：
- 可执行性：
- 安全性：

## 12. Failure Policy
| 异常 | 处理 |
|---|---|

## 13. Security Policy
- 权限：
- 敏感信息：
- Prompt Injection：

## 14. Eval
- 测试集位置：
- 评分标准：
- 最低通过线：
```

---

## 71.5 config.yaml 标准模板

```yaml
agent:
  name: example_agent
  version: 0.1.0
  owner: team_or_person
  status: draft

model:
  provider: openai
  name: gpt-5.5-thinking
  temperature: 0.2
  max_steps: 12
  max_tool_calls: 6

instruction:
  main: prompts/main.md
  tool_policy: prompts/tool_policy.md
  output_policy: prompts/output_policy.md
  failure_policy: prompts/failure_policy.md

workflow:
  main: workflows/main.yaml
  states: workflows/states.yaml
  handoffs: workflows/handoffs.yaml

tools:
  registry: tools/registry.yaml
  default_permission: read_only

context:
  policy: context/context_policy.md
  memory_policy: context/memory_policy.md
  retrieval_policy: context/retrieval_policy.md

schemas:
  input: schemas/input.schema.json
  output: schemas/output.schema.json
  state: schemas/state.schema.json

quality:
  tests: tests/
  evals: evals/
  minimum_eval_score: 0.85

safety:
  require_confirmation_for:
    - send_email
    - delete_file
    - modify_budget
    - publish_content
  forbid:
    - fabricated_data
    - unapproved_external_send
    - secret_leakage

observability:
  trace_enabled: true
  log_level: info
  cost_limit_per_run: 1.0
```

---

# 第 72 章｜Agent Skill 化

## 72.1 一句话结论

**Skill 化，是把一个 Agent 在某类任务中的稳定方法、工具、模板、脚本、评估和经验，沉淀成可复用能力包。**

Tool 解决：

```text
能调用什么动作
```

Agent 解决：

```text
如何完成一个任务
```

Skill 解决：

```text
如何高质量、可复用地完成一类任务
```

---

## 72.2 Tool、Agent、Skill 的区别

| 概念 | 简单理解 | 示例 |
|---|---|---|
| Tool | 单个可调用能力 | read_file、calculate_metrics |
| Agent | 执行一个任务的智能单元 | 广告诊断 Agent |
| Skill | 可复用任务能力包 | Amazon 广告诊断 Skill |
| Workflow | 固定流程 | 读取报表 → 计算 → 输出报告 |
| Template | 可复用输出格式 | 诊断报告模板 |

---

## 72.3 什么时候应该 Skill 化

| 条件 | 是否适合 Skill 化 |
|---|---|
| 同类任务重复出现 | 适合 |
| 已经形成稳定方法 | 适合 |
| 有固定输出模板 | 适合 |
| 需要领域知识 | 适合 |
| 有专用工具或脚本 | 适合 |
| 有可评估标准 | 适合 |
| 只是一次性任务 | 暂不 Skill 化 |
| 还在探索阶段 | 先沉淀为 draft |

---

## 72.4 Skill 标准结构

```text
skill-name/
├─ SKILL.md
├─ README.md
├─ CHANGELOG.md
│
├─ references/
│  ├─ domain_knowledge.md
│  ├─ methods.md
│  └─ examples.md
│
├─ assets/
│  ├─ templates/
│  └─ sample_outputs/
│
├─ scripts/
│  ├─ helper.py
│  └─ validators.py
│
├─ evals/
│  ├─ golden_cases.yaml
│  └─ scoring_rubric.md
│
└─ tests/
   ├─ trigger_cases.yaml
   ├─ near_miss_cases.yaml
   └─ failure_cases.yaml
```

---

## 72.5 SKILL.md 模板

```markdown
# Skill Name

## 1. Purpose
这个 Skill 解决哪类任务。

## 2. Trigger
什么时候应该使用这个 Skill。

## 3. Non-Trigger
什么时候不应该使用这个 Skill。

## 4. Inputs
需要哪些输入。

## 5. Process
执行步骤。

## 6. Tools / Scripts
可用工具或脚本。

## 7. Output
输出格式和模板。

## 8. Quality Criteria
质量标准。

## 9. Failure Policy
失败处理方式。

## 10. Examples
典型输入和输出。

## 11. Eval
如何评估这个 Skill 是否有效。

## 12. Changelog
版本变化。
```

---

## 72.6 Skill 化示例：知识沉淀 Skill

| 模块 | 内容 |
|---|---|
| Purpose | 把对话、课程、资料沉淀成 llm-wiki Markdown |
| Trigger | 用户要求整理、沉淀、导出 `.md` |
| Non-Trigger | 用户只是问概念或要求简单总结 |
| Inputs | 对话内容、主题、知识库风格 |
| Process | 主题识别 → 结构重组 → 去除闲聊 → 模板化输出 |
| Tools | 文件生成工具 |
| Output | Markdown 文件 |
| Quality | 结构清晰、可复用、适合知识库 |
| Eval | 是否保留核心框架，是否去除噪声 |

---

## 72.7 Skill 化示例：广告诊断 Skill

| 模块 | 内容 |
|---|---|
| Purpose | 诊断广告指标异常并输出优化动作 |
| Trigger | 用户要求分析 ACOS / CTR / CVR / CPC 变化 |
| Non-Trigger | 用户只是问广告概念 |
| Inputs | 广告报表、时间区间、目标维度 |
| Process | 字段检查 → 指标计算 → 异常定位 → 根因判断 |
| Scripts | 指标计算、报表清洗 |
| Output | 根因表、证据表、动作表 |
| Eval | 根因是否有数据证据，建议是否具体可执行 |

---

# 第 73 章｜Agent Eval 集沉淀

## 73.1 一句话结论

**Eval 集沉淀，是把 Agent 的典型成功案例、失败案例、边界案例、攻击案例和高价值样本长期保存下来，用于每次版本更新前做质量回归。**

没有 Eval 集，Agent 改动只能靠感觉。

有 Eval 集，Agent 每次改动都能回答：

```text
这次改动有没有变好？
有没有破坏旧能力？
有没有引入新风险？
高价值场景有没有保持质量？
```

---

## 73.2 Eval 集和测试集的区别

| 对比项 | Test Set | Eval Set |
|---|---|---|
| 目标 | 检查规则是否通过 | 判断质量是否足够好 |
| 结果 | pass / fail | score / review |
| 关注 | 触发、格式、权限、错误 | 准确性、完整性、可执行性 |
| 样本 | 边界输入、错误输入 | 真实任务、黄金案例 |
| 维护 | 工程侧 | 工程 + 业务 + 产品 |

---

## 73.3 Eval 集的五类样本

| 类型 | 作用 | 示例 |
|---|---|---|
| Golden Cases | 高质量标准答案 | 成功广告诊断案例 |
| Failure Cases | 已知失败案例 | 错误否词建议 |
| Edge Cases | 边界情况 | 数据缺字段、时间区间异常 |
| Regression Cases | 防止能力退化 | 旧版本做对的样本 |
| Attack Cases | 安全攻击样本 | Prompt Injection、越权请求 |

---

## 73.4 Eval 样本格式

```yaml
id: ads_eval_001
task_type: ads_diagnosis
input:
  user_request: "分析 1/26–1/29 ACOS 为什么升高"
  files:
    - current_period_report.csv
    - previous_period_report.csv
context:
  product: "karaoke machine"
  constraints:
    - "不得直接修改广告"
expected:
  must_include:
    - "ACOS 变化"
    - "CVR / CPC / Spend / Sales 拆解"
    - "具体 campaign 或 keyword"
    - "证据"
    - "风险提示"
  must_not_include:
    - "编造不存在的数据"
    - "未经确认直接执行调价"
scoring:
  accuracy: 0.3
  completeness: 0.2
  evidence: 0.2
  actionability: 0.2
  safety: 0.1
minimum_score: 0.85
```

---

## 73.5 Eval Rubric 模板

```markdown
# Eval Rubric

## 1. 准确性：30%
- 是否基于事实和数据；
- 是否避免编造；
- 是否正确理解任务。

## 2. 完整性：20%
- 是否覆盖关键维度；
- 是否缺失必要字段；
- 是否包含风险和限制。

## 3. 证据性：20%
- 是否给出数据、来源或依据；
- 结论是否能追溯。

## 4. 可执行性：20%
- 建议是否具体；
- 是否能落到对象、动作和优先级。

## 5. 安全性：10%
- 是否遵守权限；
- 是否避免敏感信息泄露；
- 是否需要人工确认。
```

---

## 73.6 Eval 集维护规则

| 规则 | 说明 |
|---|---|
| 每次线上失败都要沉淀 | 失败案例进入 regression |
| 每次用户高度采纳都要沉淀 | 好案例进入 golden |
| 每次新增能力都要新增 eval | 不新增 eval，不算能力稳定 |
| 每次修复 bug 都要补回归样本 | 防止未来复发 |
| 高风险工具必须有攻击样本 | 测试越权和注入 |
| Eval 要版本化 | 评估集本身也会演进 |

---

# 第 74 章｜个人 Agent 工作台

## 74.1 一句话结论

**个人 Agent 工作台，是把你的常用任务、知识库、工具、Skill、模板、评估和项目记忆整合起来，形成一个长期可复用的个人 AI 工作系统。**

它不是一个聊天窗口。

它是：

```text
个人知识库
+ 常用 Agent
+ Skill 库
+ 工具库
+ 项目上下文
+ 文件系统
+ 评估体系
+ 工作流入口
```

---

## 74.2 个人 Agent 工作台应该解决什么

| 问题 | 工作台能力 |
|---|---|
| 知识散落 | llm-wiki 统一沉淀 |
| 对话不可复用 | 自动整理成 Markdown |
| Prompt 重复写 | Skill 化和模板化 |
| 工具难调用 | 工具库和 MCP |
| 项目上下文丢失 | 项目记忆 |
| Agent 质量不稳定 | Eval 集 |
| 工作流重复 | Workflow Agent |
| 文件难管理 | 文件系统型知识库 |

---

## 74.3 推荐个人工作台结构

```text
personal-agent-workbench/
├─ llm-wiki/
│  ├─ 00_inbox/
│  ├─ 10_raw/
│  ├─ 20_notes/
│  ├─ 30_frameworks/
│  ├─ 40_projects/
│  ├─ 50_skills/
│  ├─ 60_cases/
│  └─ 90_archives/
│
├─ agents/
│  ├─ knowledge_markdown_agent/
│  ├─ amazon_ads_diagnosis_agent/
│  ├─ listing_optimization_agent/
│  ├─ customer_reply_agent/
│  └─ code_prd_agent/
│
├─ skills/
│  ├─ knowledge-capture/
│  ├─ ads-diagnosis/
│  ├─ listing-copywriting/
│  └─ complex-task-clarifier/
│
├─ tools/
│  ├─ file-tools/
│  ├─ spreadsheet-tools/
│  ├─ markdown-tools/
│  └─ ads-metrics-tools/
│
├─ evals/
│  ├─ knowledge_cases/
│  ├─ ads_cases/
│  ├─ copywriting_cases/
│  └─ security_cases/
│
├─ templates/
│  ├─ agent_prd.md
│  ├─ skill.md
│  ├─ eval_rubric.md
│  └─ launch_checklist.md
│
└─ registry/
   ├─ agents.yaml
   ├─ tools.yaml
   ├─ skills.yaml
   └─ projects.yaml
```

---

## 74.4 个人常用 Agent 建议

| Agent | 解决问题 |
|---|---|
| Knowledge Markdown Agent | 对话和课程沉淀为 Markdown |
| Complex Task Clarifier Agent | 模糊需求澄清和任务建模 |
| Amazon Ads Diagnosis Agent | 广告数据诊断 |
| Listing Optimization Agent | Listing / A+ / 文案优化 |
| Customer Reply Agent | 售后回复草稿 |
| Image Prompt Agent | 广告图提示词设计 |
| Code PRD Agent | PRD 拆解、开发任务规划 |
| Skill Creator Agent | 把稳定流程沉淀成 Skill |
| Eval Builder Agent | 为 Agent 生成测试和评估集 |

---

## 74.5 个人工作台优先建设顺序

```text
1. 先整理 llm-wiki 目录
2. 建立知识沉淀模板
3. 沉淀 3–5 个高频 Skill
4. 建立 Agent 工程模板
5. 建立最小 eval 集
6. 建立工具注册表
7. 建立项目记忆
8. 再考虑多 Agent 和平台化
```

---

# 第 75 章｜团队级 Agent 治理

## 75.1 一句话结论

**团队级 Agent 治理，是为了让多个成员、多个 Agent、多个工具、多个项目在统一规范下安全、稳定、可复用地运行。**

个人使用 Agent，核心是效率。  
团队使用 Agent，核心是治理。

团队必须回答：

```text
谁能创建 Agent？
谁能修改 prompt？
谁能调用高风险工具？
谁负责 eval？
谁审批上线？
出了事故谁复盘？
工具和数据权限怎么管？
```

---

## 75.2 团队治理对象

| 对象 | 治理内容 |
|---|---|
| Agent | owner、版本、适用范围、状态 |
| Tool | 权限、Schema、风险、日志 |
| Skill | 触发条件、质量标准、维护人 |
| Context | 数据来源、权限、更新频率 |
| Memory | 写入、读取、过期、删除 |
| Eval | 样本、评分、通过线 |
| Prompt | 版本、变更原因、回滚 |
| Model | 成本、性能、适用场景 |
| User | 角色、权限、审计 |
| Incident | 事故记录、复盘、修复 |

---

## 75.3 团队 Agent 分级

| 等级 | 状态 | 要求 |
|---|---|---|
| L0 Draft | 个人实验 | 不接高风险工具 |
| L1 Internal | 小范围内部使用 | 有 README 和基本测试 |
| L2 Beta | 可给团队试用 | 有 eval、trace、owner |
| L3 Production | 生产使用 | 有权限、监控、回滚、runbook |
| L4 Critical | 关键业务系统 | 有审批、审计、SLA、事故机制 |

---

## 75.4 团队发布流程

```text
需求提出
↓
场景评审
↓
Agent PRD
↓
工程实现
↓
Test / Eval
↓
安全审查
↓
灰度发布
↓
线上监控
↓
反馈迭代
↓
正式发布
```

---

## 75.5 团队治理清单

| 类别 | 检查项 |
|---|---|
| Owner | 每个 Agent 是否有负责人 |
| Scope | 是否定义处理边界 |
| Permission | 是否遵循最小权限 |
| Tool | 工具是否有 Schema 和日志 |
| Eval | 是否有最低评估标准 |
| Trace | 是否能追踪运行过程 |
| Security | 是否有 Prompt Injection 测试 |
| Cost | 是否有成本上限 |
| Rollback | 是否能回滚版本 |
| Docs | 是否有使用文档和 Runbook |
| Changelog | 是否记录变更 |
| Incident | 是否有事故复盘机制 |

---

# 第 76 章｜最终总图谱

## 76.1 一句话结论

**Agent 工程化与产品化的完整路径，是从“理解概念”到“设计最小 Agent”，再到“工程化、工具化、上下文化、质量化、产品化、多 Agent 化、项目化、方法论化”，最终形成个人或团队的 Agent 系统。**

---

## 76.2 总路径图

```text
认知边界
第 0–4 章
理解 Agent 是什么、不是什么
↓
最小可用 Agent
第 5–10 章
Goal / Instruction / Context / Tool / Output / Quality
↓
工程化核心模块
第 11–17 章
任务拆解 / 流程 / 状态 / 异常 / 人工介入 / 版本 / 目录
↓
工具、MCP 与外部系统
第 18–24 章
Tool / Schema / API / Script / DB / MCP / Permission / Tool Registry
↓
状态、记忆与上下文工程
第 25–32 章
State / Context / Memory / RAG / Knowledge Base / Context Compression
↓
质量、安全与可观测性
第 33–42 章
Test / Eval / Trace / Guardrail / Prompt Injection / Cost / AgentOps
↓
Agent 产品化
第 43–52 章
场景 / 任务模型 / 产品形态 / 交互 / 信任 / 指标 / MVP / 平台化
↓
多 Agent 与系统架构
第 53–60 章
Router / Handoff / Supervisor / Pipeline / Planner / Reviewer / Platform
↓
真实项目实战
第 61–68 章
知识管理 / 广告分析 / Listing / 客服 / 代码 / 多 Agent 交付 / PRD / 上线检查
↓
方法论与个人系统
第 69–76 章
设计方法论 / 需求分析 / 工程模板 / Skill / Eval / 工作台 / 团队治理
```

---

## 76.3 最终能力模型

| 能力层 | 你应该具备的能力 |
|---|---|
| 概念层 | 能解释 Agent、Workflow、RAG、Tool、MCP、Skill 的边界 |
| 判断层 | 能判断什么任务该用 Agent，什么任务不该用 |
| 设计层 | 能设计 Agent 的目标、边界、上下文、工具、输出 |
| 工程层 | 能设计状态、流程、异常、版本、目录 |
| 工具层 | 能封装工具、设计权限、接入 MCP |
| 上下文层 | 能设计 Context、Memory、RAG、知识库 |
| 质量层 | 能设计 Test、Eval、Trace、Guardrail |
| 产品层 | 能设计场景、交互、信任、指标、MVP |
| 架构层 | 能设计多 Agent、Handoff、Router、Reviewer |
| 沉淀层 | 能把经验沉淀成 Skill、模板、Eval、工作台 |
| 治理层 | 能做团队级权限、发布、复盘、持续迭代 |

---

## 76.4 最终判断题

| 问题 | 如果你能回答，说明掌握 |
|---|---|
| 这个需求是否真的需要 Agent？ | 能做方案选型 |
| 这个 Agent 的最小闭环是什么？ | 能做 MVP |
| 哪些步骤应该固定，哪些交给 Agent？ | 能做流程建模 |
| 需要哪些工具，权限怎么控制？ | 能做工具设计 |
| 上下文从哪里来，如何避免污染？ | 能做上下文工程 |
| 如何测试和评估它？ | 能做质量体系 |
| 如何防止越权、泄露、注入攻击？ | 能做安全设计 |
| 用户为什么会信任和持续使用？ | 能做产品化 |
| 什么时候拆多 Agent？ | 能做架构设计 |
| 如何沉淀成 Skill 和 Eval？ | 能做长期复用 |
| 团队如何维护它？ | 能做治理体系 |

---

# 第 69–76 章总复盘

## 1. 本阶段核心公式

```text
Agent 方法论
= 场景判断
+ 任务建模
+ 工程结构
+ 工具权限
+ 上下文记忆
+ 质量安全
+ 产品指标
+ 长期沉淀
```

```text
可复用 Agent 能力
= Agent Spec
+ Tool Spec
+ Workflow
+ Context Policy
+ Eval Set
+ Skill Package
+ Registry
```

```text
个人 Agent 系统
= llm-wiki
+ Agents
+ Skills
+ Tools
+ Evals
+ Templates
+ Project Memory
+ Workflows
```

```text
团队级 Agent 治理
= Owner
+ Scope
+ Permission
+ Eval
+ Trace
+ Security
+ Cost Control
+ Release Process
+ Incident Review
```

---

## 2. 八个核心结论

| 序号 | 核心结论 |
|---|---|
| 1 | Agent 设计不能从 prompt 开始，要从用户场景、任务边界和价值判断开始 |
| 2 | 模糊需求必须先做需求分析，不能直接实现 |
| 3 | Agent 工程模板让 Agent 从一次性产物变成可维护工程资产 |
| 4 | Skill 化是把稳定方法、工具、模板、脚本和 eval 沉淀成可复用能力包 |
| 5 | Eval 集是 Agent 质量长期稳定的核心资产 |
| 6 | 个人 Agent 工作台是知识库、Agent、Skill、工具、评估和项目记忆的组合系统 |
| 7 | 团队级 Agent 治理重点不是效率，而是权限、质量、安全、发布和责任 |
| 8 | Agent 工程化与产品化的终点不是一个 Agent，而是一套可持续迭代的 Agent 能力体系 |

---

## 3. 最终实践作业

```markdown
# 我的个人 Agent 系统设计

## 1. 我的高频任务
| 任务 | 频率 | 痛点 | 是否适合 Agent |
|---|---|---|---|

## 2. 我的 Agent 清单
| Agent | 解决任务 | 状态 | 下一步 |
|---|---|---|---|

## 3. 我的 Skill 清单
| Skill | 触发场景 | 是否已有模板 | 是否已有 Eval |
|---|---|---|---|

## 4. 我的工具库
| 工具 | 用途 | 权限 | 是否复用 |
|---|---|---|---|

## 5. 我的 llm-wiki 目录
```text
llm-wiki/
├─ 00_inbox/
├─ 10_raw/
├─ 20_notes/
├─ 30_frameworks/
├─ 40_projects/
├─ 50_skills/
├─ 60_cases/
└─ 90_archives/
```

## 6. 我的 Eval 集
| Eval 集 | 对应 Agent / Skill | 样本数量 | 状态 |
|---|---|---|---|

## 7. 我的项目记忆
| 项目 | 当前状态 | 关键规则 | 文件位置 |
|---|---|---|---|

## 8. 我的迭代计划
| 阶段 | 目标 | 交付物 |
|---|---|---|
| V0 | 整理知识库结构 | llm-wiki 目录 |
| V1 | 建立知识沉淀 Agent | Markdown 导出流程 |
| V2 | 建立 3 个高频 Skill | Skill 包 |
| V3 | 建立 Eval 集 | golden / failure / attack cases |
| V4 | 建立工具注册表 | tools.yaml |
| V5 | 建立个人工作台 | agents + skills + evals + registry |
```

---

## 4. 完课后的下一步建议

完成第 0–76 章后，不建议继续堆概念。

更高价值的下一步是从你的真实工作里选 1 个 Agent 做成完整交付包：

| 推荐项目 | 原因 |
|---|---|
| 知识沉淀 Agent | 和你的 llm-wiki 强相关，最容易形成长期复用 |
| Amazon 广告诊断 Agent | 和你的业务价值直接相关 |
| Listing 优化 Agent | 能结合关键词、场景、转化和文案 |
| Complex Task Clarifier Skill | 能改善 Codex / Agent 执行前的需求质量 |
| Skill Creator Agent | 能帮助你持续沉淀可复用能力 |

建议优先级：

```text
1. 知识沉淀 Agent
2. Complex Task Clarifier Skill
3. Amazon 广告诊断 Agent
4. Listing 优化 Agent
5. Skill Creator Agent
```
