---
title: 'Harness Engineering｜阶段一：概念入门（第 0–4 章）'
status: raw
created: '2026-05-23 21:33'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Harness'
  - 'Skill'
  - 'MCP'
  - 'LLM'
---

# Harness Engineering｜阶段一：概念入门（第 0–4 章）

> 目标：先建立 Harness Engineering 的核心认知框架，不急着写代码。  
> 学完本阶段，你应该能回答：Harness 为什么存在、它和 Prompt / Context / Tool / Workflow 有什么区别、为什么 Agent 可以理解为 Model + Harness，以及如何用一张结构图拆解 Agent Harness。

---

## 阶段一总览

| 章 | 主题 | 本章解决的问题 | 最终要掌握的判断 |
|---:|---|---|---|
| 0 | 为什么需要 Harness Engineering | 为什么光有强模型还不够 | 模型负责智能，Harness 负责让智能可执行、可控、可验证 |
| 1 | 从 Test Harness 到 Agent Harness | Harness 这个词从哪里来 | Harness 的本质是“外部控制与验证环境” |
| 2 | Agent = Model + Harness | Agent 到底由什么构成 | Raw Model 不是 Agent，模型被 Harness 包起来才成为 Agent |
| 3 | Harness 与 Prompt / Context / Tool / Workflow 的区别 | 为什么它不是旧概念换名 | Prompt / Context / Tool / Workflow 都只是 Harness 的局部 |
| 4 | Harness Engineering 完整知识地图 | 后续学习怎么展开 | 用模块化地图理解 Agent 工程系统 |

---

# 第 0 章：为什么需要 Harness Engineering

## 0.1 先用一句话理解

> **Harness Engineering 是把 LLM 的“生成能力”变成“工程能力”的外层系统设计。**

LLM 本身很强，但它默认只是一个“输入 → 输出”的概率生成器。  
它能生成文本、代码、分析、计划，但它天然不等于一个稳定工程系统。

你要的不是：

```text
我问一句 → 模型答一句
```

而是：

```text
用户目标
→ Agent 理解任务
→ 读取上下文
→ 调用工具
→ 执行步骤
→ 检查结果
→ 失败修复
→ 形成沉淀
```

这个从“聊天”到“工程系统”的外壳，就是 Harness。

---

## 0.2 为什么光有模型不够

| 模型天然能力 | 工程系统真正需要 | 中间缺口 |
|---|---|---|
| 能生成答案 | 能稳定完成任务 | 需要执行流程 |
| 能写代码 | 能跑测试、修失败、提交 diff | 需要工具与验证 |
| 能读上下文 | 能选择正确上下文 | 需要上下文管理 |
| 能推理 | 能按规则行动 | 需要约束与权限 |
| 能给建议 | 能产出可交付结果 | 需要质量门禁 |
| 能一次性回答 | 能长期迭代项目 | 需要状态与记忆 |
| 能“看起来合理” | 能被验证为正确 | 需要测试与评估 |

### 简单理解

模型像一个高智商的人。  
Harness 像公司制度、工具、文档、流程、权限、验收标准、复盘机制。

没有 Harness，模型容易出现：

| 问题 | 表现 |
|---|---|
| 假完成 | 没做完就说做完了 |
| 绕流程 | PRD 写得很清楚，但 Agent 执行时跳步骤 |
| 上下文漂移 | 一开始理解对，执行中偏离目标 |
| 工具误用 | 不该调用的工具乱调用，该调用的不调用 |
| 输出不稳定 | 同样任务每次结果差异很大 |
| 无法复盘 | 不知道为什么错、错在哪里、下次怎么防 |
| 无法迁移 | 这次做对了，下次又从零开始 |

你之前在 Codex 中遇到的“明明有 PRD，但 AI 执行时降低标准、绕过流程、未完成就宣传已完成”，本质上就是 **Harness 不完整**，不是单纯 Prompt 不够长。

---

## 0.3 Harness Engineering 解决什么核心矛盾

核心矛盾是：

> **LLM 是概率生成系统，但工程交付需要可控、可验证、可复现。**

所以 Harness Engineering 要解决 5 个问题：

| 问题 | Harness 的解决方式 |
|---|---|
| 目标不清楚 | 任务 brief、PRD、验收标准 |
| 行动不可控 | workflow、权限、工具边界 |
| 结果不可验 | tests、evals、quality gates |
| 过程不可见 | logs、trace、review record |
| 经验不可复用 | AGENTS.md、SKILL.md、templates、scripts |

---

## 0.4 Feynman 解释

想象你要请一个非常聪明的实习生帮你做项目。

如果你只说：

> 帮我做一个高质量 Agent。

他可能会做，但结果不稳定。

如果你给他：

```text
1. 项目目标
2. 参考资料
3. 文件结构
4. 允许使用的工具
5. 禁止做的事情
6. 每一步检查项
7. 完成标准
8. 测试方法
9. 出错时如何修复
10. 最终如何交付
```

这个外部系统就是 Harness。

所以：

> **Harness 不是替代聪明人，而是让聪明人稳定产出。**

---

## 0.5 迁移到 Agent 工程

在 Agent 工程中，Harness 的作用可以理解为：

| Agent 工程问题 | Harness 设计 |
|---|---|
| Agent 不知道该怎么拆任务 | Planner / task decomposition |
| Agent 不知道读哪些文件 | Context policy |
| Agent 不知道用什么工具 | Tool registry / MCP config |
| Agent 做错了不知道 | Test / eval harness |
| Agent 自称完成但没完成 | Definition of Done / quality gate |
| Agent 每次都重复犯错 | Regression test / failure memory |
| Agent 输出风格不统一 | Template / schema / style rules |
| Agent 无法长期迭代 | State / filesystem / Git / memory |

---

## 0.6 本章结论

```text
Harness Engineering 的核心不是“让模型更聪明”，
而是让模型的聪明可以被工程系统稳定调用。
```

### 本章自检

| 问题 | 你应该能回答 |
|---|---|
| 为什么强模型仍然会把任务做坏？ | 因为模型强不等于流程、工具、验证、权限都完整 |
| Harness 的根本价值是什么？ | 把生成能力变成可执行、可控、可验证的工程能力 |
| 为什么这和你的 Agent 工程目标直接相关？ | 因为高质量 Agent 不是只靠 prompt，而是靠完整外层系统 |

---

# 第 1 章：Harness 的词源——从 Test Harness 到 Agent Harness

## 1.1 Test Harness 是什么

传统软件测试中，**Test Harness** 指的是为了执行测试而搭建的一组外部支持结构，通常包含：

| 组成 | 作用 |
|---|---|
| Driver | 驱动被测模块运行 |
| Stub / Mock / Test Double | 替代真实依赖，制造可控测试环境 |
| Fixture | 准备测试数据和环境 |
| Assertion | 判断结果是否符合预期 |
| Runner | 执行测试套件 |
| Report | 输出测试结果 |

简单说：

> **Test Harness = 为了让一个模块可以被测试，而搭建的外部测试环境。**

例如你要测试一个支付模块，但不想真的扣钱，就要用 stub 模拟支付网关。  
这个“让测试可运行、可控制、可判断”的外层系统，就是 test harness。

---

## 1.2 Agent Harness 是怎么从 Test Harness 迁移来的

Test Harness 的对象是：

```text
被测代码模块
```

Agent Harness 的对象是：

```text
LLM / Agent 行为
```

迁移关系如下：

| Test Harness | Agent Harness | 迁移后的含义 |
|---|---|---|
| Driver | Workflow / Planner | 驱动 Agent 按步骤执行 |
| Stub / Mock | Tool simulation / sandbox | 给 Agent 一个安全可控环境 |
| Fixture | Context package / test case | 准备输入上下文和任务条件 |
| Assertion | Eval / test / quality gate | 判断输出是否合格 |
| Runner | Agent runtime | 执行 Agent 任务循环 |
| Report | Trace / logs / review | 记录过程与结果 |

---

## 1.3 为什么这个迁移重要

因为 Agent 的问题不是“能不能回答”，而是：

```text
能不能在复杂环境中稳定行动？
能不能被检查？
能不能失败后修复？
能不能复用？
```

传统代码测试关注：

```text
函数输入 → 函数输出
```

Agent Harness 关注：

```text
目标输入
→ 上下文选择
→ 工具调用
→ 中间状态
→ 多轮决策
→ 最终输出
→ 质量判断
```

这比普通测试更复杂，因为 Agent 有多轮行为、有工具调用、有不确定性、有上下文污染风险。

---

## 1.4 Feynman 解释

Test Harness 像一个考试系统。

学生是被测对象。  
考试系统要提供：

```text
试卷
计时器
答题纸
监考规则
评分标准
成绩报告
```

没有考试系统，你只知道“学生很聪明”，但不知道他到底掌握没有。

Agent Harness 也是一样。

模型是学生。  
Harness 是任务环境、工具、规则、评分标准、纠错机制。

---

## 1.5 从 Test Harness 到 Agent Harness 的本质变化

| 维度 | Test Harness | Agent Harness |
|---|---|---|
| 对象 | 代码模块 | LLM / Agent 行为 |
| 输入 | 测试数据 | 用户目标 + 上下文 |
| 执行 | 函数调用 / 测试运行 | 多轮推理 + 工具调用 |
| 输出 | 结果值 / 状态变化 | 文本、代码、文件、动作 |
| 判断 | 断言是否通过 | 格式、事实、流程、业务效果是否通过 |
| 难点 | 依赖隔离 | 不确定性、上下文、长任务、工具风险 |
| 目标 | 验证代码正确性 | 让 Agent 行为可控、可验、可复用 |

---

## 1.6 本章结论

```text
Harness 的底层含义不是“工具集合”，
而是“让某个能力在受控环境中运行、验证和改进的外部系统”。
```

### 本章自检

| 问题 | 你应该能回答 |
|---|---|
| Test Harness 的核心作用是什么？ | 给被测对象提供可控测试环境 |
| Agent Harness 继承了什么思想？ | 外部控制、外部验证、外部反馈 |
| Agent Harness 为什么比 Test Harness 更复杂？ | 因为 Agent 有多轮推理、工具调用、上下文变化和不确定性 |

---

# 第 2 章：Agent = Model + Harness

## 2.1 先建立核心公式

```text
Agent = Model + Harness
```

这个公式是理解 Harness Engineering 的核心。

| 部分 | 作用 |
|---|---|
| Model | 负责理解、推理、生成、决策 |
| Harness | 负责上下文、工具、状态、执行、验证、反馈、安全 |

Raw Model 不是 Agent。  
模型被外部系统包起来，能感知上下文、调用工具、执行动作、保存状态、接受反馈，才成为 Agent。

---

## 2.2 Model 负责什么

| 能力 | 说明 |
|---|---|
| 语言理解 | 读懂用户目标、文档、代码、数据 |
| 语义推理 | 判断关系、原因、优先级、方案 |
| 计划生成 | 拆解任务、安排步骤 |
| 内容生成 | 生成代码、文案、报告、提示词 |
| 决策建议 | 在多个选项中做判断 |
| 反思修正 | 根据反馈调整输出 |

模型像“大脑”。

---

## 2.3 Harness 负责什么

| 模块 | 作用 |
|---|---|
| Instruction | 规定 Agent 身份、边界、规则 |
| Context | 选择给模型看的信息 |
| Tool | 让模型可以行动 |
| State | 保存任务过程和长期信息 |
| Workflow | 控制任务步骤 |
| Runtime | 提供执行环境 |
| Eval | 判断是否合格 |
| Feedback | 让 Agent 修复错误 |
| Safety | 控制权限和风险 |
| Observability | 记录过程，便于复盘 |
| Knowledge | 沉淀成文档、模板、skill |

Harness 像“身体 + 工具箱 + 工作制度 + 质检部门”。

---

## 2.4 为什么不能只靠 Model

因为模型本身通常不能天然完成这些事：

| 工程需求 | 模型天然是否具备 | 需要 Harness 吗 |
|---|---:|---:|
| 访问实时文件 | 不一定 | 需要 |
| 修改代码仓库 | 不具备 | 需要 |
| 运行测试 | 不具备 | 需要 |
| 管理长期状态 | 不稳定 | 需要 |
| 调用外部 API | 不具备 | 需要 |
| 控制权限 | 不具备 | 需要 |
| 自动回滚 | 不具备 | 需要 |
| 输出可审计日志 | 不具备 | 需要 |
| 防止假完成 | 不具备 | 需要 |

所以：

```text
模型越强，Harness 越重要。
```

不是因为模型弱，而是因为越强的模型越能做复杂任务，复杂任务越需要外部控制系统。

---

## 2.5 用 Codex 场景理解

你让 Codex 做一个 skill：

```text
读取 PRD
调用 skill-creator
实现 skill
测试 skill
输出结果
```

如果没有 Harness，Codex 可能会：

| 失败点 | 原因 |
|---|---|
| 没读完 PRD | 缺少 context audit |
| 随便理解需求 | 缺少 task brief |
| 直接写文件 | 缺少 plan gate |
| 不跑测试 | 缺少 verification gate |
| 没完成就说完成 | 缺少 Definition of Done |
| 输出不可复用 | 缺少 template / schema |
| 下次又犯同样错 | 缺少 regression harness |

更好的 Harness 应该是：

```text
PRD
→ 需求解析
→ 上下文审计
→ 任务拆解
→ 方案确认
→ 文件修改
→ 测试验证
→ diff review
→ 质量门禁
→ 交付总结
→ 失败沉淀
```

---

## 2.6 Feynman 解释

一个高级厨师是 Model。  
厨房系统是 Harness。

厨师很厉害，但要稳定开餐厅，需要：

```text
菜单
食材库存
厨房设备
卫生标准
出餐流程
质检标准
采购系统
投诉处理
员工分工
```

没有这些，厨师可能偶尔做出好菜，但无法稳定经营餐厅。

Agent 也是一样。

模型能产生智能，Harness 让智能稳定工作。

---

## 2.7 本章结论

```text
Agent 的质量，不只取决于模型多强，
还取决于 Harness 是否把模型能力组织成可执行系统。
```

### 本章自检

| 问题 | 你应该能回答 |
|---|---|
| Raw Model 为什么不是 Agent？ | 因为它缺少工具、状态、执行环境、反馈和约束 |
| Agent = Model + Harness 中 Harness 负责什么？ | 负责让模型能行动、能被检查、能被约束、能长期工作 |
| 为什么模型越强，Harness 越重要？ | 因为强模型会承担更复杂任务，复杂任务需要更强工程控制 |

---

# 第 3 章：Harness 与 Prompt / Context / Tool / Workflow 的区别

## 3.1 先给结论

> **Prompt、Context、Tool、Workflow 都是 Harness 的组成部分，但没有任何一个单独等于 Harness。**

关系如下：

```text
Harness Engineering
├─ Prompt Engineering
├─ Context Engineering
├─ Tool Engineering
├─ Workflow Engineering
├─ Eval Engineering
├─ Runtime Engineering
├─ Safety Engineering
├─ Observability Engineering
└─ Knowledge Engineering
```

---

## 3.2 Harness vs Prompt Engineering

| 对比项 | Prompt Engineering | Harness Engineering |
|---|---|---|
| 关注点 | 怎么写好指令 | 怎么构建完整 Agent 外层系统 |
| 核心对象 | 文本指令 | 指令 + 工具 + 状态 + 流程 + 评估 + 权限 |
| 输出 | prompt 模板 | 可运行、可检查、可复用的系统 |
| 风险 | 只靠模型自觉执行 | 用外部机制约束执行 |
| 典型问题 | “怎么说得更清楚” | “怎么保证它真的按要求做” |

### 简单理解

Prompt 是“说清楚”。  
Harness 是“说清楚 + 给工具 + 设流程 + 做检查 + 留记录 + 能修复”。

---

## 3.3 Harness vs Context Engineering

| 对比项 | Context Engineering | Harness Engineering |
|---|---|---|
| 关注点 | 模型看到什么信息 | Agent 如何完整运行 |
| 典型内容 | RAG、文件、历史、记忆、示例 | 上下文 + 工具 + 运行 + 验证 +反馈 |
| 目标 | 提高理解质量 | 提高任务完成质量 |
| 风险 | 上下文太多、太乱、污染判断 | 整个系统失控、不可验、不可复用 |

### 简单理解

Context 是给 Agent “看什么”。  
Harness 是决定 Agent “怎么看、怎么做、怎么检查”。

---

## 3.4 Harness vs Tool Use / MCP

| 对比项 | Tool Use / MCP | Harness Engineering |
|---|---|---|
| 关注点 | Agent 能调用什么工具 | Agent 如何安全、正确、可控地调用工具 |
| 典型内容 | API、函数、命令行、浏览器、文件系统 | 工具选择、权限、失败处理、审计、回滚 |
| 目标 | 扩展行动能力 | 管理行动能力 |
| 风险 | 工具误用、越权、误删 | 通过 Harness 降低工具风险 |

### 简单理解

Tool 是手。  
Harness 是告诉这只手什么时候能动、怎么动、动完怎么检查。

---

## 3.5 Harness vs Workflow

| 对比项 | Workflow | Harness Engineering |
|---|---|---|
| 关注点 | 步骤顺序 | 完整执行系统 |
| 典型内容 | Step 1 → Step 2 → Step 3 | 流程 + 工具 + 状态 + 评估 + 权限 + 反馈 |
| 适合任务 | 稳定、可预期任务 | 稳定任务 + 复杂开放任务 |
| 风险 | 过度固定，无法适应变化 | Harness 可以结合固定流程与动态决策 |

### 简单理解

Workflow 是路线图。  
Harness 是车、司机、导航、交通规则、刹车、维修系统、行车记录仪。

---

## 3.6 Harness vs Agent Framework

| 对比项 | Agent Framework | Harness Engineering |
|---|---|---|
| 关注点 | 提供开发抽象 | 设计 Agent 外层系统 |
| 例子 | LangChain、LangGraph、CrewAI、AutoGen、OpenAI Agents SDK | 可以用这些框架实现 Harness |
| 本质 | 工具 / 框架 | 方法论 / 系统设计 |
| 风险 | 会用框架但不会设计系统 | 先设计 Harness，再选工具实现 |

### 简单理解

Framework 是积木。  
Harness Engineering 是知道该搭什么房子、怎么验收房子、怎么维护房子。

---

## 3.7 一个判断公式

当你不确定某个东西是不是 Harness，可以问 4 个问题：

| 问题 | 如果答案是“是”，它就属于 Harness |
|---|---|
| 它是否在模型外部？ | 是 |
| 它是否影响 Agent 行为？ | 是 |
| 它是否提高可控性、可执行性或可验证性？ | 是 |
| 它是否能被工程化复用？ | 是 |

例子：

| 对象 | 是否属于 Harness | 原因 |
|---|---:|---|
| system prompt | 是 | 外部指令，影响行为 |
| MCP 配置 | 是 | 决定可用工具 |
| AGENTS.md | 是 | 仓库级行为约束 |
| SKILL.md | 是 | 能力级执行规则 |
| evals | 是 | 质量判断机制 |
| Git diff | 是 | 变更可审查机制 |
| 模型权重 | 否 | 属于 Model，不属于 Harness |
| 用户临时一句话 | 部分是 | 如果只是输入，不算稳定 Harness；如果沉淀为规则，算 Harness |

---

## 3.8 本章结论

```text
Prompt 解决“怎么说”；
Context 解决“看什么”；
Tool 解决“能做什么”；
Workflow 解决“按什么步骤做”；
Harness 解决“如何让 Agent 稳定、可控、可验证地完成任务”。
```

### 本章自检

| 问题 | 你应该能回答 |
|---|---|
| Prompt 为什么不等于 Harness？ | 因为它缺少工具、状态、验证、权限、反馈等系统组件 |
| Tool 为什么不等于 Harness？ | 因为工具只是行动接口，不负责何时调用、如何检查、如何回滚 |
| Workflow 为什么不等于 Harness？ | 因为流程只是控制流，不等于完整工程系统 |
| Framework 为什么不等于 Harness？ | 因为框架是实现工具，Harness 是系统设计方法 |

---

# 第 4 章：Harness Engineering 的完整知识地图

## 4.1 总体结构图

```text
Harness Engineering
├─ A. 目标层：Task / Goal / Definition of Done
├─ B. 指令层：System Prompt / Rules / Policies
├─ C. 上下文层：Context / RAG / Files / Memory
├─ D. 工具层：Tools / APIs / MCP / CLI / Browser
├─ E. 状态层：Filesystem / Git / DB / Long-term Memory
├─ F. 执行层：Runtime / Sandbox / Container / Environment
├─ G. 编排层：Workflow / Planner / Router / Subagent
├─ H. 验证层：Tests / Evals / Schema / Quality Gate
├─ I. 反馈层：Errors / Review / Self-correction / Regression
├─ J. 安全层：Permissions / Approval / Secrets / Rollback
├─ K. 观测层：Logs / Trace / Cost / Latency / Success Rate
└─ L. 沉淀层：AGENTS.md / SKILL.md / Templates / Playbooks
```

---

## 4.2 十二层模块解释

| 层 | 名称 | 解决的问题 | 典型产物 |
|---|---|---|---|
| A | 目标层 | 到底要完成什么 | task brief、PRD、Definition of Done |
| B | 指令层 | Agent 应该遵守什么规则 | system prompt、AGENTS.md、policy |
| C | 上下文层 | Agent 应该看什么信息 | references、RAG、context pack |
| D | 工具层 | Agent 能调用什么能力 | MCP、CLI、API、scripts |
| E | 状态层 | Agent 如何保存过程 | files、Git、memory、database |
| F | 执行层 | Agent 在哪里运行 | sandbox、container、workspace |
| G | 编排层 | Agent 按什么结构行动 | workflow、planner、router、subagent |
| H | 验证层 | 如何判断做得对不对 | tests、evals、schema、quality gate |
| I | 反馈层 | 做错后如何修复 | error report、review comment、retry loop |
| J | 安全层 | 如何防止高风险行为 | permission、approval、rollback |
| K | 观测层 | 如何知道 Agent 做了什么 | logs、trace、metrics |
| L | 沉淀层 | 如何变成长期资产 | SKILL.md、templates、playbooks、checklists |

---

## 4.3 用“个人 Agent 工程系统”理解

假设你要构建一个 **高质量 Skill 生成 Agent**。

它的 Harness 应该这样拆：

| Harness 模块 | 在 Skill 生成 Agent 中的体现 |
|---|---|
| 目标层 | 生成一个可用、可测、可迭代的 skill |
| 指令层 | 遵守标准 SKILL.md 结构和触发边界 |
| 上下文层 | 读取 PRD、参考 skill、项目规范 |
| 工具层 | 文件读写、Git、测试脚本、格式检查 |
| 状态层 | 保存设计稿、版本、变更记录 |
| 执行层 | 在 repo workspace 中执行 |
| 编排层 | 需求解析 → 设计 → 实现 → 测试 → 复盘 |
| 验证层 | trigger tests、output tests、quality rubric |
| 反馈层 | 根据失败测试修复 skill |
| 安全层 | 不删除无关文件，不改无关模块 |
| 观测层 | 输出 diff、执行日志、测试结果 |
| 沉淀层 | 更新 CHANGELOG、evals、templates |

---

## 4.4 用“llm-wiki 知识沉淀 Agent”理解

如果你要让 Agent 帮你沉淀知识到 llm-wiki，它的 Harness 可以这样设计：

| Harness 模块 | 在 llm-wiki 中的体现 |
|---|---|
| 目标层 | 把对话沉淀成结构化知识资产 |
| 指令层 | 按你的通用知识理解框架组织内容 |
| 上下文层 | 读取当前对话、相关历史、知识库目录 |
| 工具层 | Markdown 生成、文件命名、目录写入 |
| 状态层 | 记录版本、来源、更新时间 |
| 执行层 | 本地文件系统或 Git 仓库 |
| 编排层 | 提炼 → 分类 → 结构化 → 输出 .md |
| 验证层 | 检查标题、层级、表格、链接、缺失项 |
| 反馈层 | 根据你的修改偏好更新模板 |
| 安全层 | 不覆盖原文件，避免错误归档 |
| 观测层 | 输出文件路径和变更摘要 |
| 沉淀层 | 形成模板和知识卡片规范 |

---

## 4.5 Harness 的三种成熟度

| 成熟度 | 特征 | 典型表现 |
|---|---|---|
| L1：Prompt Harness | 主要靠提示词控制 | 能让 Agent 输出格式更稳定，但执行不可控 |
| L2：Workflow Harness | 有固定流程和工具 | 能完成中等复杂任务，但质量依赖人工检查 |
| L3：System Harness | 有工具、状态、验证、反馈、安全、观测 | 能支撑长期 Agent 工程化 |

你当前的目标不是停留在 L1，而是逐步走向 L3。

---

## 4.6 Harness 的设计顺序

设计一个 Agent Harness，不建议从“用什么框架”开始，而应从这 8 个问题开始：

| 顺序 | 问题 | 输出 |
|---:|---|---|
| 1 | 这个 Agent 要完成什么任务？ | 目标层 |
| 2 | 什么叫完成？ | Definition of Done |
| 3 | 它需要看什么上下文？ | Context policy |
| 4 | 它需要调用什么工具？ | Tool registry |
| 5 | 它应该按什么流程做？ | Workflow |
| 6 | 如何判断它做对了？ | Tests / evals |
| 7 | 做错了如何修复？ | Feedback loop |
| 8 | 哪些行为必须限制？ | Permission / safety |

---

## 4.7 本章结论

```text
Harness Engineering 不是单点技巧，
而是一套围绕 Agent 行为设计的外部工程系统。
```

你后面学习的重点不是记术语，而是学会这套拆解方式：

```text
目标 → 上下文 → 工具 → 状态 → 流程 → 验证 → 反馈 → 安全 → 沉淀
```

### 本章自检

| 问题 | 你应该能回答 |
|---|---|
| 一个完整 Harness 至少包含哪些层？ | 目标、指令、上下文、工具、状态、执行、编排、验证、反馈、安全、观测、沉淀 |
| 为什么不能先选框架再设计 Agent？ | 因为框架只是实现工具，先要明确任务、边界、验证和风险 |
| 你的个人 Agent 工程中最缺哪几层？ | 通常是验证层、反馈层、安全层、沉淀层 |

---

# 阶段一总结

## 1. 用一句话总结

> **Harness Engineering 是围绕模型构建外部工程系统，让 LLM 从“会生成”升级为“会稳定完成任务”。**

## 2. 用一张表总结

| 核心问题 | 阶段一答案 |
|---|---|
| Harness 是什么？ | 模型外部的控制、执行、验证、反馈系统 |
| 它从哪里来？ | 从传统 Test Harness 迁移到 Agent 工程 |
| 它和 Agent 的关系？ | Agent = Model + Harness |
| 它和 Prompt 的关系？ | Prompt 是 Harness 的一部分 |
| 它和 Context 的关系？ | Context 是 Harness 的信息供给层 |
| 它和 Tool 的关系？ | Tool 是 Harness 的行动接口 |
| 它和 Workflow 的关系？ | Workflow 是 Harness 的控制流模块 |
| 它的完整结构？ | 目标、指令、上下文、工具、状态、执行、编排、验证、反馈、安全、观测、沉淀 |

## 3. 阶段一最重要的判断

```text
不要把 Agent 工程理解为“写一个更好的 prompt”。
应该理解为：
设计一个外部系统，让模型在受控环境中完成任务，并且能被验证、修复、复用和沉淀。
```

## 4. 阶段一掌握标准

| 能力 | 判断标准 |
|---|---|
| 概念理解 | 能说清楚 Harness 不是 Prompt，而是完整外层系统 |
| 边界判断 | 能区分 Model、Harness、Context、Tool、Workflow |
| 结构拆解 | 能把任意 Agent 拆成 10 个以上 Harness 模块 |
| 迁移应用 | 能解释 Codex / Skill / llm-wiki 为什么需要 Harness |
| 问题诊断 | 能判断 Agent 失败是模型问题，还是 Harness 缺失问题 |

---

# 下一阶段预告

## 阶段二：基础概念层｜第 5–10 章

| 章 | 主题 |
|---:|---|
| 5 | Model Layer：模型能做什么，不能做什么 |
| 6 | Instruction Layer：系统提示词与规则 |
| 7 | Context Layer：上下文工程基础 |
| 8 | Tool Layer：工具调用与 MCP 基础 |
| 9 | State Layer：文件、记忆、Git、数据库 |
| 10 | Execution Layer：运行环境与沙盒 |

---

# 参考来源

| 来源 | 用途 |
|---|---|
| OpenAI, “Harness engineering: leveraging Codex in an agent-first codebase”, 2026-02-11 | Agent-first codebase、evaluation harness、CI、review、repo scripts 等实践背景 |
| LangChain, “The Anatomy of an Agent Harness”, 2026-03-10 | Agent = Model + Harness，Harness 包含 system prompts、tools、MCP、filesystem、sandbox、orchestration、hooks/middleware |
| Martin Fowler, “Harness engineering for coding agent users” | 将 Agent Harness 视为通过 feed-forward 和 feedback 调节代码库状态的外部系统 |
| ISTQB Glossary, “test harness” | Test Harness 的传统定义：执行测试套件所需的 drivers 和 test doubles |
