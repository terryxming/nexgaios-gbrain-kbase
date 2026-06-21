---
title: 'Harness Engineering｜阶段九：多 Agent 与高级架构（第 57–63 章）'
status: raw
created: '2026-05-21 09:37'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Harness'
  - 'Skill'
  - 'LLM'
  - 'Knowledge-Base'
---

# Harness Engineering｜阶段九：多 Agent 与高级架构（第 57–63 章）

阶段九的核心目标：

> 把 Agent 从“单个智能体完成任务”，升级为“多个角色、多个模型、多个工具、多个状态协同工作的 Agent 系统”。

但是，多 Agent 不是越多越好。

本阶段最重要的判断是：

```text
多 Agent 不是高级感装饰，而是复杂任务分工、质量审查、路由调度、长任务恢复和平台化治理的架构手段。
```

---

## 阶段九总览

| 章 | 主题 | 核心问题 | 一句话理解 |
|---:|---|---|---|
| 57 | Planner / Executor / Reviewer 架构 | 复杂任务如何分工 | 一个 Agent 不要同时负责计划、执行和审查 |
| 58 | Critic Agent 与 Review Agent | 如何做质量审查 | 让审查角色独立于执行角色 |
| 59 | Router Harness：任务路由与模型选择 | 如何把任务分给合适能力 | 先判断任务类型，再选择 Agent / Skill / Model / Tool |
| 60 | Long-Horizon Harness：长任务规划与恢复 | 如何处理长周期复杂任务 | 长任务必须有状态、检查点、恢复和阶段门禁 |
| 61 | Multi-Agent State：共享状态与冲突控制 | 多 Agent 如何共享信息 | 共享状态要有事实源、权限和冲突规则 |
| 62 | Agent Swarm 的边界与误区 | 什么时候不该多 Agent | 多 Agent 会放大复杂度，不是默认答案 |
| 63 | Agent System Design：从单 Agent 到 Agent 平台 | 如何构建系统级 Agent 工程 | 最终目标是平台化能力，而不是堆很多 Agent |

---

# 第 57 章：Planner / Executor / Reviewer 架构

## 57.1 本章核心

> Planner / Executor / Reviewer 架构的作用，是把“计划、执行、审查”三种职责拆开，避免一个 Agent 既当运动员，又当裁判。

单 Agent 常见问题：

```text
自己定计划
自己执行
自己检查
自己宣布完成
```

这会导致：

| 问题 | 表现 |
|---|---|
| 计划过粗 | 没拆清任务就直接执行 |
| 执行漂移 | 做着做着偏离目标 |
| 自检不可靠 | 自己检查自己的错误，容易漏掉 |
| 假完成 | 没满足 DoD 就说完成 |
| 难复盘 | 不知道是计划错、执行错还是审查错 |

所以需要三角色拆分。

---

## 57.2 三角色模型

| 角色 | 负责什么 | 不负责什么 |
|---|---|---|
| Planner | 理解目标、拆任务、定路径、识别风险 | 不直接改文件、不直接交付 |
| Executor | 按计划执行、调用工具、修改文件、生成产物 | 不随意改计划、不自称完成 |
| Reviewer | 检查结果、发现问题、判断是否通过门禁 | 不直接替代执行，除非进入修复流程 |

简单理解：

```text
Planner = 项目经理 / 架构师
Executor = 工程师 / 执行者
Reviewer = 质检 / 审稿 / Code Reviewer
```

---

## 57.3 标准工作流

```text
用户目标
→ Planner 生成任务计划
→ Reviewer 审查计划是否合理
→ Executor 执行计划
→ Reviewer 审查结果
→ Executor 修复问题
→ Reviewer 复核
→ Delivery Gate 放行
```

---

## 57.4 Planner 的输入与输出

### Planner 输入

| 输入 | 说明 |
|---|---|
| 用户目标 | 用户真正想完成什么 |
| 背景上下文 | PRD、对话、仓库、业务资料 |
| 约束 | 时间、范围、工具、格式、安全限制 |
| 完成标准 | Definition of Done |
| 风险 | 高风险动作、不可逆动作、信息缺失 |

### Planner 输出

| 输出 | 说明 |
|---|---|
| Task Brief | 标准任务说明 |
| Work Breakdown | 任务拆解 |
| Execution Plan | 执行步骤 |
| Context Plan | 需要读取哪些上下文 |
| Tool Plan | 需要调用哪些工具 |
| Risk Plan | 风险与审批点 |
| Quality Plan | 需要哪些测试和门禁 |

---

## 57.5 Executor 的输入与输出

### Executor 输入

| 输入 | 说明 |
|---|---|
| 已批准计划 | 不应随意偏离 |
| 目标文件 / 数据 | 要处理的对象 |
| 工具权限 | 可用工具范围 |
| 输出契约 | 最终要交付什么 |
| 失败处理规则 | 遇到阻塞怎么办 |

### Executor 输出

| 输出 | 说明 |
|---|---|
| 变更内容 | 文件、报告、文案、分析结果 |
| 执行日志 | 做了哪些步骤 |
| 工具结果 | 测试、diff、搜索、生成结果 |
| 未完成项 | 无法完成的内容 |
| 风险说明 | 执行中发现的问题 |

---

## 57.6 Reviewer 的输入与输出

### Reviewer 输入

| 输入 | 说明 |
|---|---|
| 用户目标 | 原始需求 |
| 执行计划 | 是否按计划做 |
| 执行结果 | 最终产物 |
| 测试结果 | 硬性检查 |
| 质量标准 | rubric / DoD |
| 变更记录 | diff / changelog |

### Reviewer 输出

| 输出 | 说明 |
|---|---|
| 是否通过 | pass / fail / warning |
| 问题清单 | 具体问题 |
| 严重程度 | blocker / major / minor |
| 修复建议 | 回到哪个步骤修 |
| 是否可交付 | 是否进入 Delivery Gate |

---

## 57.7 适用场景

| 场景 | 是否适合三角色架构 | 原因 |
|---|---:|---|
| 简单解释概念 | 否 | 复杂度过高 |
| 写一段短文案 | 通常否 | 单 Agent 足够 |
| 创建 Skill | 是 | 涉及设计、实现、测试、评审 |
| Codex 改仓库 | 是 | 需要计划、执行、diff、测试、review |
| 需求澄清到 PRD | 是 | 需要拆解和审查 |
| 广告大盘诊断 | 是 | 需要假设、动作、风险复核 |
| 批量改知识库结构 | 是 | 高风险，需要审查和回滚 |

---

## 57.8 迁移到你的工作流

### Skill 创建

```text
Planner：根据 PRD 设计 Skill 结构
Executor：创建 SKILL.md、references、assets、evals
Reviewer：检查触发边界、执行可落地性、测试闭环
```

### llm-wiki 沉淀

```text
Planner：确定沉淀范围和结构
Executor：生成 Markdown 文件
Reviewer：检查范围、层级、表格、是否可沉淀
```

### Codex 工程任务

```text
Planner：读 PRD 和仓库，制定修改计划
Executor：改代码、跑测试、输出 diff
Reviewer：检查 diff、测试、架构、风险
```

---

## 57.9 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 所有任务都要三角色 | 过度工程化 | 只在复杂任务使用 |
| Planner 计划太细 | 限制执行灵活性 | 计划到关键步骤和门禁即可 |
| Executor 可以随便改计划 | 容易漂移 | 重大偏离要回到 Planner |
| Reviewer 只看最终结果 | 过程可能错误 | 同时看计划、过程、结果 |
| 三个 Agent 互相聊天就行 | 容易空转 | 必须有产物、门禁和状态 |

---

## 57.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分三种职责 | 能说清 Planner、Executor、Reviewer 各自边界 |
| 判断适用场景 | 知道什么时候需要三角色，什么时候不用 |
| 设计角色输入输出 | 每个角色都有明确产物 |
| 设计交接门禁 | Planner 到 Executor、Executor 到 Reviewer 有交接标准 |
| 防止假完成 | Reviewer 独立判断是否可交付 |

---

# 第 58 章：Critic Agent 与 Review Agent

## 58.1 本章核心

> Critic Agent 和 Review Agent 的作用，是让质量判断独立于生成过程，降低自我审查失效的风险。

执行者常见盲区：

```text
自己写的内容，自己觉得合理；
自己漏掉的步骤，自己也不容易发现；
自己没有验证的结果，自己容易默认通过。
```

所以需要独立审查角色。

---

## 58.2 Critic 与 Reviewer 的区别

| 角色 | 关注点 | 输出 |
|---|---|---|
| Critic Agent | 找问题、挑毛病、指出不足 | 问题清单、风险、反例 |
| Review Agent | 按标准判断是否通过 | pass / fail、评分、修复建议 |

简单理解：

```text
Critic 更像“挑刺者”；
Reviewer 更像“验收者”。
```

二者可以合并，也可以拆开。

---

## 58.3 Critic Agent 适合检查什么

| 维度 | 检查问题 |
|---|---|
| 逻辑漏洞 | 推理是否跳步 |
| 范围偏移 | 是否超出用户要求 |
| 事实风险 | 是否缺少证据 |
| 表达泛化 | 是否太空、太泛 |
| 可执行性 | 建议是否能落地 |
| 安全风险 | 是否有越权、泄密、误删风险 |
| 用户偏好 | 是否符合用户明确风格 |
| 反例 | 是否存在明显反例推翻结论 |

---

## 58.4 Review Agent 适合检查什么

| 维度 | 检查问题 |
|---|---|
| DoD | 是否满足完成标准 |
| Output Contract | 输出字段和结构是否完整 |
| Test Result | 是否运行并通过必要测试 |
| Process | 是否按 workflow 执行 |
| Risk | 风险是否被说明和控制 |
| Regression | 是否破坏旧能力 |
| Delivery | 是否可以交付 |

---

## 58.5 审查输入

Review / Critic 不应只看最终输出，还应看到：

```text
用户原始任务
Task Brief
执行计划
执行日志
工具调用结果
最终产物
测试结果
diff / 变更记录
质量标准
历史失败案例
```

否则容易变成“凭感觉点评”。

---

## 58.6 Critic Prompt 模板

```text
你是 Critic Agent。

你的任务不是重写答案，而是找出当前产物的问题。
请从以下维度审查：
1. 是否偏离用户目标；
2. 是否遗漏关键要求；
3. 是否存在事实风险；
4. 是否有逻辑跳跃；
5. 是否过于空泛；
6. 是否不可执行；
7. 是否存在安全或权限风险；
8. 是否有更好的结构。

输出：
- blocker 问题
- major 问题
- minor 问题
- 必须修复建议
- 可选优化建议
```

---

## 58.7 Review Prompt 模板

```text
你是 Review Agent。

请根据任务目标、Definition of Done、输出契约和测试结果判断当前产物是否可以交付。

你必须输出：
1. 是否通过：pass / fail / pass with warnings；
2. 未通过项；
3. 证据；
4. 修复建议；
5. 是否需要回到 Planner 或 Executor；
6. 是否允许最终交付。

禁止：
- 不看证据就通过；
- 只说“整体不错”；
- 把建议当成验收结论。
```

---

## 58.8 迁移到你的场景

| 场景 | Critic 检查 | Reviewer 判断 |
|---|---|---|
| A+ 文案 | 是否太泛、不转化、不差异化 | 是否符合 FABE 和字符限制 |
| 图片提示词 | 是否画面不清、卖点不可视化 | 是否满足构图、比例、禁止项 |
| Skill 创建 | 是否边界模糊、执行空泛 | 是否通过触发和输出测试 |
| Codex 改代码 | 是否有架构风险 | 是否测试通过、diff 合理 |
| llm-wiki | 是否只是流水账 | 是否可沉淀、范围正确 |
| 广告分析 | 是否假设不可验证 | 是否给出可执行动作和观察周期 |

---

## 58.9 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Critic 只是让模型再看一遍 | 容易重复原判断 | 给独立 rubric 和反例视角 |
| Reviewer 只看最终文本 | 看不到过程问题 | 必须看计划、测试、日志 |
| 审查只输出泛泛建议 | 不可执行 | 按 blocker / major / minor 分类 |
| 审查 Agent 可以替代测试 | 不能替代硬测试 | test + eval + review 组合 |
| 审查越严越好 | 会阻塞迭代 | 区分必须修复和可选优化 |

---

## 58.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分 Critic 和 Reviewer | 能说清挑错和验收的区别 |
| 设计审查输入 | 不只看最终输出，还看过程证据 |
| 设计审查 Rubric | 能按任务类型定义质量标准 |
| 输出可执行反馈 | 能区分 blocker、major、minor |
| 防止自检失效 | 能让审查独立于执行角色 |

---

# 第 59 章：Router Harness｜任务路由与模型选择

## 59.1 本章核心

> Router Harness 的作用，是根据任务类型、风险、上下文、成本和质量要求，把请求分配给合适的 Agent、Skill、Model、Tool 或 Workflow。

如果没有 Router，系统会变成：

```text
所有任务都交给同一个 Agent；
所有问题都用同一个模型；
所有能力都靠同一个 prompt；
复杂任务和简单任务成本一样。
```

这会导致成本高、误触发、质量不稳定、任务分工混乱。

OpenAI Agents SDK 将 handoffs 用于 Agent 将任务委派给其他专门 Agent；LangChain 多 Agent 文档也区分了“subagents 作为工具由主 Agent 调用”和“handoffs 根据状态动态切换控制权”等模式。这些都说明路由和交接是多 Agent 架构中的核心问题。

---

## 59.2 Router 路由对象

Router 可以路由到不同层级：

| 路由对象 | 示例 |
|---|---|
| Agent | Planner、Executor、Reviewer |
| Skill | llm-wiki-writer、skill-quality-reviewer |
| Model | 强推理模型、低成本模型、视觉模型 |
| Tool | file search、web search、Python、Git |
| Workflow | bugfix workflow、文案 workflow、知识沉淀 workflow |
| Human | 高风险审批、专家评审 |

---

## 59.3 Router 输入

Router 判断时需要这些信息：

| 输入 | 说明 |
|---|---|
| 用户意图 | 用户想做什么 |
| 任务类型 | 解释、生成、分析、修改、执行、审查 |
| 风险等级 | 是否有外部动作、文件修改、成本 |
| 上下文状态 | 是否已有足够资料 |
| 所需工具 | 是否需要文件、网络、代码、图片 |
| 输出要求 | 是否需要文件、代码、图、PR |
| 质量要求 | 是否需要 reviewer 或 eval |
| 成本约束 | 是否能用低成本模型 |
| 时效要求 | 是否需要最新信息 |

---

## 59.4 任务类型路由表

| 用户请求 | 推荐路由 |
|---|---|
| “解释这个概念” | 单 Agent + 无工具 |
| “把这轮对话沉淀成 md” | llm-wiki-writer Skill |
| “评估这个 SKILL.md” | skill-quality-reviewer Skill |
| “根据 PRD 实现 skill” | Planner → Executor → Reviewer |
| “修复这个 bug” | Bugfix Workflow + Coding Agent |
| “分析广告 ACOS 上升原因” | Amazon Ad Diagnoser |
| “写 A+ 文案” | A+ Copywriting Skill + Review |
| “生成图片提示词” | Image Prompt Designer |
| “回复 Amazon case” | Case Reply Agent + HITL |
| “修改广告预算” | Analysis Agent → Human Approval → External Tool |

---

## 59.5 模型选择策略

| 任务 | 模型策略 |
|---|---|
| 简单分类 / 路由 | 低成本模型 |
| 复杂规划 | 强推理模型 |
| 代码修改 | coding 能力强的模型 |
| 视觉理解 | 多模态模型 |
| 大量批处理 | 低成本模型 + 规则校验 |
| 高风险审查 | 强推理模型 + 人工复核 |
| 文案生成 | 语言表达强的模型 + rubric |
| 事实核查 | 模型 + 检索 + 引用 |

原则：

```text
不要用最强模型解决所有问题；
要按任务价值、风险、复杂度、成本选择模型。
```

---

## 59.6 Router 输出契约

Router 不应只“选择一个 Agent”，还应输出理由。

| 字段 | 说明 |
|---|---|
| selected_route | 选择哪个 Agent / Skill / Workflow |
| reason | 为什么选它 |
| rejected_routes | 为什么不选其他候选 |
| risk_level | 风险等级 |
| required_context | 需要哪些上下文 |
| required_tools | 需要哪些工具 |
| approval_needed | 是否需要人工确认 |
| fallback | 失败后退回哪里 |

---

## 59.7 Router 的常见错误

| 错误 | 表现 | 修复 |
|---|---|---|
| 路由过宽 | 什么都触发同一个 Skill | 缩窄 description |
| 路由过窄 | 该触发时没触发 | 增加正例 |
| 路由冲突 | 多个 Skill 抢任务 | 建优先级 |
| 路由黑盒 | 不知道为什么选它 | 输出 route rationale |
| 成本失控 | 全部用强模型 | 分级模型策略 |
| 风险忽略 | 高风险任务直接执行 | 加 approval route |

---

## 59.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计路由表 | 能按任务类型分配 Agent / Skill |
| 选择模型 | 能按复杂度、成本、风险选模型 |
| 处理冲突 | 能解决多 Skill 抢任务 |
| 输出路由理由 | 能解释为什么这么分配 |
| 设计 fallback | 路由失败时能退回澄清、人工或通用 Agent |

---

# 第 60 章：Long-Horizon Harness｜长任务规划与恢复

## 60.1 本章核心

> Long-Horizon Harness 的作用，是让 Agent 能处理跨多步骤、多文件、多轮对话、多天迭代的复杂任务，并且可以中断、恢复、审查和回滚。

长任务和短任务的区别：

| 短任务 | 长任务 |
|---|---|
| 一次回答完成 | 多阶段完成 |
| 上下文较少 | 上下文不断变化 |
| 状态简单 | 状态复杂 |
| 失败成本低 | 失败后难恢复 |
| 不一定需要 checkpoint | 必须有 checkpoint |
| 单 Agent 足够 | 可能需要多角色 |

LangGraph 文档说明，其 persistence 层可以把 graph state 保存为 checkpoints，从而支持 human-in-the-loop、conversation memory、time travel debugging 和 fault-tolerant execution；这正是长任务 Harness 需要的基础能力。

---

## 60.2 长任务的典型风险

| 风险 | 表现 |
|---|---|
| 目标漂移 | 做着做着偏离原始目标 |
| 上下文丢失 | 忘记早期决策 |
| 状态混乱 | 不知道做到哪一步 |
| 重复劳动 | 已做工作又做一遍 |
| 失败不可恢复 | 中断后只能重来 |
| 成本失控 | 多轮调用没有预算控制 |
| 质量下降 | 后期为了完成而降低标准 |
| 交付不可审查 | 没有阶段产物和记录 |

---

## 60.3 Long-Horizon Harness 的组成

| 模块 | 作用 |
|---|---|
| Goal Contract | 长任务目标和边界 |
| Milestone Plan | 阶段拆解 |
| Checkpoint | 保存中间状态 |
| Progress Log | 记录已完成和未完成 |
| Context Summary | 压缩历史上下文 |
| State Store | 保存任务状态 |
| Review Gate | 阶段性审查 |
| Recovery Plan | 失败恢复 |
| Cost Budget | 控制成本 |
| Human Interrupt | 必要时暂停确认 |

---

## 60.4 长任务标准工作流

```text
定义目标
→ 拆成里程碑
→ 为每个里程碑定义 DoD
→ 执行阶段 1
→ 保存 checkpoint
→ Review Gate
→ 执行阶段 2
→ 保存 checkpoint
→ Review Gate
→ 处理失败和恢复
→ 最终整合
→ 回归检查
→ 交付与沉淀
```

---

## 60.5 Checkpoint 设计

每个 checkpoint 应保存：

| 字段 | 说明 |
|---|---|
| milestone | 当前阶段 |
| completed_items | 已完成 |
| pending_items | 未完成 |
| decisions | 已确认决策 |
| assumptions | 当前假设 |
| files_changed | 已修改文件 |
| test_results | 测试结果 |
| open_risks | 未解决风险 |
| next_step | 下一步 |
| rollback_point | 可回滚位置 |

---

## 60.6 长任务中的人工介入

长任务不能完全无监督。需要在这些点加入人工确认：

| 节点 | 为什么需要确认 |
|---|---|
| 计划确认 | 防止方向错误 |
| 范围变更 | 防止任务扩张 |
| 高风险动作 | 防止不可逆损失 |
| 中期验收 | 防止后期返工 |
| 最终交付 | 确认是否满足目标 |

LangGraph 的 interrupt 文档说明，interrupt 可以在图节点中暂停执行并等待外部输入，状态由 persistence 层保存后再恢复。这类机制适合长任务中的人工审批和中断恢复。

---

## 60.7 迁移到你的场景

### 创建一个复杂 Skill

```text
M1：需求澄清和任务建模
M2：设计 Skill 边界
M3：编写 SKILL.md
M4：准备 references / assets / scripts
M5：编写 evals
M6：运行测试和修复
M7：Review 和沉淀
```

### 建设个人 llm-wiki

```text
M1：确定三层架构
M2：定义 schema
M3：整理 raw
M4：沉淀 processed
M5：建立 index
M6：接入 Agent / Skill
M7：回归和质量检查
```

---

## 60.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 识别长任务 | 能区分一次性任务和长周期任务 |
| 设计里程碑 | 能拆阶段和阶段 DoD |
| 设计 checkpoint | 能保存中间状态和恢复点 |
| 设计中断恢复 | 能暂停、确认、继续 |
| 控制目标漂移 | 能通过 progress log 和 review gate 保持方向 |

---

# 第 61 章：Multi-Agent State｜共享状态与冲突控制

## 61.1 本章核心

> Multi-Agent State 的作用，是让多个 Agent 能共享必要信息，但不互相污染、不覆盖、不冲突。

多 Agent 系统最大的难点之一不是“Agent 怎么聊天”，而是：

```text
谁知道什么？
谁能改什么？
哪个信息是事实源？
多个 Agent 意见冲突时听谁的？
状态错了怎么恢复？
```

LangGraph memory 文档把 short-term memory 作为 agent state 的一部分，并说明状态可通过 checkpointer 持久化以便 thread 恢复；其 memory 文档也区分短期记忆和长期记忆。这类状态管理思想对于多 Agent 协作尤其关键。

---

## 61.2 多 Agent 状态类型

| 状态类型 | 说明 | 示例 |
|---|---|---|
| Task State | 当前任务状态 | 当前阶段、待办、阻塞 |
| Shared Context | 多 Agent 共享上下文 | PRD、用户目标、约束 |
| Role State | 每个 Agent 独有状态 | Planner 的计划、Reviewer 的问题 |
| Artifact State | 产物状态 | 文件、代码、报告、图 |
| Tool State | 工具执行结果 | 测试结果、diff、搜索结果 |
| Decision State | 已确认决策 | 范围、方案、架构选择 |
| Risk State | 风险和审批 | 高风险操作、审批记录 |
| Memory State | 长期偏好和经验 | 用户偏好、失败样本 |

---

## 61.3 共享状态的三种模式

| 模式 | 说明 | 适用 |
|---|---|---|
| Central Blackboard | 所有 Agent 读写同一个共享工作区 | 复杂协作，但需强权限控制 |
| Coordinator-owned State | 由主 Agent 管理共享状态 | Supervisor 架构 |
| Artifact-based State | 通过文件、PR、任务卡交接 | Coding / 文档 / Skill 工程 |

推荐优先使用：

```text
Artifact-based State + Coordinator-owned State
```

因为它更容易审查、回滚和追踪。

---

## 61.4 事实源设计

状态冲突时必须知道听谁的。

| 信息类型 | 事实源 |
|---|---|
| 用户当前明确要求 | 当前用户消息 |
| 系统安全规则 | system / developer instruction |
| 项目结构 | 仓库文件 |
| 代码真实状态 | git diff / 文件系统 |
| 测试是否通过 | 测试输出 |
| 业务数据 | 原始报表 |
| 已确认决策 | decision log |
| 长期偏好 | memory / wiki，但低于当前明确要求 |

原则：

```text
不要让 Agent 的“口头总结”覆盖真实文件、测试结果和用户当前要求。
```

---

## 61.5 状态冲突类型

| 冲突 | 示例 | 处理 |
|---|---|---|
| 目标冲突 | 用户新要求与旧计划冲突 | 当前用户要求优先 |
| 文件冲突 | Executor 改了 Reviewer 不认可的文件 | diff review |
| 决策冲突 | Planner 和 Reviewer 方案不同 | 升级 human / arbiter |
| 记忆冲突 | 旧偏好与当前要求冲突 | 当前要求优先 |
| 测试冲突 | Agent 说通过，CI 显示失败 | CI 结果优先 |
| 工具冲突 | 两个工具返回不一致 | 查事实源或交叉验证 |

---

## 61.6 状态权限

不是所有 Agent 都能改所有状态。

| 状态 | 谁能写 | 谁能读 |
|---|---|---|
| Task Brief | Planner，用户确认后锁定 | 所有 Agent |
| Execution Log | Executor | Reviewer / Planner |
| Review Notes | Reviewer | Planner / Executor |
| Final Artifact | Executor，经 Reviewer 放行 | 用户 / 系统 |
| Decision Log | Planner 或 Human | 所有 Agent |
| Memory | Memory Manager / 用户确认 | Router / Planner |
| Audit Log | 系统写入 | 只读 |

---

## 61.7 多 Agent 状态工作流

```text
Planner 写 Task Brief
→ Executor 读取 Task Brief 并写 Execution Log
→ Reviewer 读取 Task Brief + Execution Log + Artifact
→ Reviewer 写 Review Notes
→ Executor 根据 Review Notes 修复
→ Delivery Gate 写 Final Status
→ Audit 写不可变记录
```

---

## 61.8 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 多 Agent 只要共享对话就行 | 上下文会混乱 | 使用结构化状态 |
| 所有 Agent 都可写状态 | 容易互相覆盖 | 状态写权限分级 |
| 记忆越多协作越好 | 会污染判断 | 只共享必要信息 |
| 冲突让模型自己判断 | 可能不稳定 | 定义事实源优先级 |
| 没有状态版本 | 无法恢复 | checkpoint / Git / audit |

---

## 61.9 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计共享状态 | 能区分 task、artifact、decision、memory state |
| 设计事实源 | 能判断冲突时听谁的 |
| 设计写权限 | 能限制每个 Agent 能改什么 |
| 设计交接产物 | 用文件、日志、review notes 交接 |
| 防止状态污染 | 能识别过期、错误、冲突状态 |

---

# 第 62 章：Agent Swarm 的边界与误区

## 62.1 本章核心

> Agent Swarm 不是“Agent 越多越智能”，而是多个 Agent 在明确目标、角色、通信、状态和门禁下协同工作。

没有 Harness 的 Agent Swarm，通常会变成：

```text
很多 Agent 互相讨论；
成本快速上升；
结论越来越长；
责任越来越不清；
没有人真正执行；
没有明确交付物。
```

---

## 62.2 什么是 Agent Swarm

广义上，Agent Swarm 指多个 Agent 共同完成任务。

但工程上要区分：

| 类型 | 说明 |
|---|---|
| Role-based Multi-Agent | Planner / Executor / Reviewer |
| Specialist Multi-Agent | 广告专家、文案专家、图片专家 |
| Debate Multi-Agent | 多个 Agent 讨论和反驳 |
| Swarm Exploration | 多个 Agent 并行探索方案 |
| Supervisor-Worker | 主 Agent 调度多个专家 |
| Peer-to-Peer | Agent 之间相互通信 |

LangChain 多 Agent 文档把 subagents 和 handoffs 作为常见模式：前者由主 Agent 调用子 Agent，后者会根据状态动态改变当前控制者。OpenAI Agents SDK 的 handoffs 也把委派给专门 Agent 作为处理不同专业任务的方式。

---

## 62.3 什么时候需要多个 Agent

| 情况 | 是否需要多 Agent | 原因 |
|---|---:|---|
| 任务很简单 | 否 | 单 Agent 成本更低 |
| 只是输出一段文案 | 通常否 | 可用单 Agent + rubric |
| 需要独立审查 | 是 | 执行与审查分离 |
| 涉及多个专业领域 | 是 | 专家分工 |
| 长任务多阶段 | 是 | 计划、执行、复核分开 |
| 高风险操作 | 是 | 增加 reviewer / human gate |
| 需要并行探索方案 | 可能 | 多 Agent 提供多个候选 |
| 只是想显得高级 | 否 | 复杂度无收益 |

---

## 62.4 多 Agent 的成本

| 成本 | 表现 |
|---|---|
| Token 成本 | 多角色、多轮对话迅速增加 |
| 延迟成本 | 多 Agent 往返更慢 |
| 上下文成本 | 每个 Agent 需要不同上下文 |
| 状态成本 | 状态同步和冲突处理复杂 |
| 调试成本 | 错误来源更难定位 |
| 评估成本 | 每个 Agent 和整体系统都要测 |
| 安全成本 | 权限和工具控制更复杂 |
| 组织成本 | 角色和责任链要定义清楚 |

---

## 62.5 Agent Swarm 的必要 Harness

| Harness | 作用 |
|---|---|
| Role Contract | 每个 Agent 的职责边界 |
| Routing Policy | 谁在什么时候参与 |
| Communication Protocol | Agent 如何交换信息 |
| Shared State | 共享哪些信息 |
| Conflict Resolution | 意见冲突怎么处理 |
| Cost Limit | 最大轮数、最大 token、最大工具调用 |
| Quality Gate | 最终谁判断通过 |
| Audit Trace | 谁做了什么 |
| Stop Condition | 什么时候停止讨论 |

---

## 62.6 不推荐的 Swarm 形态

| 形态 | 问题 |
|---|---|
| 无主 Agent 群聊 | 容易发散 |
| 所有 Agent 都能调用所有工具 | 风险过大 |
| 没有终止条件 | 无限讨论 |
| 没有共享状态规范 | 信息混乱 |
| 没有最终决策者 | 结论不落地 |
| 没有质量门禁 | 多 Agent 只是堆意见 |
| 没有成本限制 | 成本失控 |

---

## 62.7 推荐的多 Agent 模式

| 模式 | 适用 |
|---|---|
| Planner → Executor → Reviewer | 大多数复杂任务 |
| Supervisor → Specialists | 多领域任务 |
| Generator → Critic → Rewriter | 文案、报告、提示词 |
| Analyst → Strategist → Risk Reviewer | 广告分析、业务决策 |
| Coder → Tester → Reviewer | Coding Agent |
| Router → Skill Agent | 多 Skill 系统 |
| Agent → Human Approval | 高风险动作 |

---

## 62.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 判断是否需要多 Agent | 能用复杂度、风险、专业分工判断 |
| 识别 Swarm 风险 | 能指出成本、状态、调试、安全问题 |
| 设计角色边界 | 每个 Agent 职责清楚 |
| 设计终止条件 | 避免无限讨论 |
| 选择最小多 Agent 架构 | 不为高级感堆 Agent |

---

# 第 63 章：Agent System Design｜从单 Agent 到 Agent 平台

## 63.1 本章核心

> Agent System Design 的目标，不是创建一个个孤立 Agent，而是构建一套可复用、可治理、可评估、可扩展的 Agent 工程平台。

从单 Agent 到 Agent 平台，是这样的升级路径：

```text
Prompt
→ Workflow
→ Skill
→ Agent
→ Multi-Agent
→ Agent System
→ Agent Platform
```

OpenAI Agents SDK 将 Agents 描述为会计划、调用工具、跨专家协作并保持足够状态来完成多步骤工作的应用；这说明真正的 Agent 系统不仅是 prompt，而是围绕计划、工具、协作和状态构建的工程应用。

---

## 63.2 单 Agent 与 Agent 平台的区别

| 维度 | 单 Agent | Agent 平台 |
|---|---|---|
| 任务范围 | 单一任务 | 多任务、多领域 |
| 能力来源 | prompt + tools | Skill registry + workflow + tools |
| 路由 | 手动选择 | Router 自动分配 |
| 质量 | 人工看结果 | Test / Eval / Gate |
| 状态 | 对话上下文 | 文件、数据库、Git、memory |
| 安全 | 简单限制 | 权限、沙盒、审计、审批 |
| 复用 | 复制 prompt | Skill / template / playbook |
| 可观测 | 很弱 | trace、metrics、audit |
| 迭代 | 靠感觉改 | failure → eval → regression |

---

## 63.3 Agent 平台的核心模块

```text
Agent Platform
├─ Task Entry Layer
├─ Router Layer
├─ Skill Registry
├─ Agent Registry
├─ Tool Registry
├─ Context / Memory Layer
├─ Workflow Engine
├─ State Store
├─ Evaluation System
├─ Permission / Safety System
├─ Observability System
├─ Artifact Store
├─ Human Review Console
└─ Knowledge / Playbook System
```

---

## 63.4 Agent Registry

Agent Registry 记录可用 Agent。

| 字段 | 说明 |
|---|---|
| agent_name | Agent 名称 |
| role | planner / executor / reviewer / specialist |
| capabilities | 能做什么 |
| tools | 能用哪些工具 |
| risk_level | 风险等级 |
| input_contract | 接受什么输入 |
| output_contract | 输出什么 |
| owner | 谁维护 |
| eval_status | 是否通过评估 |
| version | 当前版本 |
| status | active / experimental / deprecated |

---

## 63.5 Skill Registry

Skill Registry 管理可复用能力。

| 字段 | 说明 |
|---|---|
| skill_name | Skill 名称 |
| domain | 所属领域 |
| when_to_use | 使用场景 |
| when_not_to_use | 不使用场景 |
| inputs | 输入要求 |
| outputs | 输出契约 |
| resources | references / assets / scripts / evals |
| dependencies | 依赖工具或其他 Skill |
| quality_score | 质量评分 |
| regression_status | 回归状态 |
| version | 版本 |

---

## 63.6 Tool Registry

Tool Registry 管理工具能力和风险。

| 字段 | 说明 |
|---|---|
| tool_name | 工具名称 |
| capability | 工具做什么 |
| input_schema | 参数结构 |
| output_schema | 返回结构 |
| side_effect | 是否有副作用 |
| permission_level | 权限等级 |
| approval_required | 是否需审批 |
| cost | 成本 |
| latency | 延迟 |
| audit_required | 是否审计 |

---

## 63.7 Agent 平台工作流

```text
用户请求
→ Task Entry 解析任务
→ Router 选择 Agent / Skill / Model / Tool
→ Context Layer 加载上下文
→ Workflow Engine 执行流程
→ Tool Registry 控制工具调用
→ State Store 记录状态
→ Eval System 做测试和评估
→ Permission System 控制风险
→ Human Review 处理审批
→ Artifact Store 保存产物
→ Observability 记录 trace
→ Knowledge System 沉淀经验
```

---

## 63.8 你的个人 Agent 平台雏形

结合你的长期目标，可以设计成：

```text
Terry-AIWork Agent System
├─ AGENTS.md
├─ skills/
│  ├─ knowledge/
│  │  ├─ llm-wiki-writer/
│  │  └─ course-map-designer/
│  ├─ agent-engineering/
│  │  ├─ complex-task-clarifier/
│  │  ├─ skill-creator/
│  │  ├─ skill-quality-reviewer/
│  │  └─ repo-reverse-engineering/
│  ├─ amazon/
│  │  ├─ amazon-ad-diagnoser/
│  │  ├─ listing-copywriter/
│  │  └─ case-reply-writer/
│  └─ creative/
│     ├─ image-prompt-designer/
│     └─ aplus-copywriter/
├─ _shared/
│  ├─ references/
│  ├─ assets/
│  ├─ rubrics/
│  └─ scripts/
├─ evals/
├─ logs/
├─ llm-wiki/
└─ docs/
```

---

## 63.9 平台化质量门禁

| Gate | 检查 |
|---|---|
| Registry Gate | Agent / Skill 是否登记 |
| Trigger Gate | 路由是否正确 |
| Context Gate | 上下文是否正确 |
| Tool Gate | 工具权限是否安全 |
| Workflow Gate | 是否按流程执行 |
| Eval Gate | 是否通过测试评估 |
| Regression Gate | 是否破坏旧能力 |
| Security Gate | 是否越权、泄密、高风险 |
| Human Gate | 是否需要人工审批 |
| Delivery Gate | 是否满足 DoD |
| Knowledge Gate | 是否沉淀经验 |

---

## 63.10 从个人系统到团队系统

| 个人级 | 团队级 |
|---|---|
| 个人偏好 | 团队规范 |
| 本地 llm-wiki | 团队知识库 |
| 手动 review | PR + code owner review |
| 简单 eval | CI + regression suite |
| 个人 Skill | 团队 Skill Registry |
| 本地日志 | 集中 observability |
| 简单权限 | RBAC / approval workflow |
| 手动复盘 | incident review / postmortem |

---

## 63.11 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Agent 平台就是很多 Agent | 只是堆数量 | 平台核心是治理和复用 |
| 先做复杂架构 | 容易空转 | 从高频任务和 Skill 开始 |
| 所有流程都自动化 | 高风险失控 | 分级自动化 |
| 只做工具接入 | 没有质量体系 | 必须有 eval 和 gate |
| 不维护 registry | 能力失控 | Agent / Skill / Tool 都要登记 |
| 没有观测和审计 | 不能复盘 | trace、logs、audit 必须有 |

---

## 63.12 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 理解 Agent System | 能区分单 Agent 和 Agent 平台 |
| 设计核心模块 | 能设计 registry、router、workflow、eval、safety |
| 平台化复用 | 能把 Skill、Agent、Tool 组织成能力系统 |
| 治理复杂度 | 能用 registry、gate、audit 控制系统扩张 |
| 迁移到个人工程 | 能规划 Terry-AIWork Agent System |

---

# 阶段九总结

## 1. 用一句话总结

> 阶段九的核心是：从单 Agent 走向多 Agent 与 Agent 平台，但始终用 Harness 控制分工、路由、状态、质量、安全和成本。

---

## 2. 阶段九总图

```text
多 Agent 与高级架构
├─ 57 Planner / Executor / Reviewer
│  └─ 计划、执行、审查三权分离
├─ 58 Critic / Review Agent
│  └─ 独立挑错和验收
├─ 59 Router Harness
│  └─ 任务路由、Skill 选择、模型选择
├─ 60 Long-Horizon Harness
│  └─ 长任务规划、checkpoint、恢复
├─ 61 Multi-Agent State
│  └─ 共享状态、事实源、冲突控制
├─ 62 Agent Swarm
│  └─ 多 Agent 的边界、成本和误区
└─ 63 Agent System Design
   └─ 从单 Agent 到 Agent 平台
```

---

## 3. 阶段九最重要的判断

```text
不要为了“高级”而多 Agent。

只有当任务存在明确的：
- 角色分工
- 专业分工
- 独立审查
- 长任务状态
- 高风险审批
- 并行探索
- 平台化复用

多 Agent 才有必要。
```

---

## 4. 多 Agent 架构的核心公式

```text
Multi-Agent System = Role Contract
                   + Router
                   + Shared State
                   + Workflow
                   + Review Gate
                   + Permission
                   + Observability
                   + Cost Control
                   + Human Escalation
```

---

## 5. 阶段九掌握标准

| 能力 | 判断标准 |
|---|---|
| 三角色架构 | 能设计 Planner / Executor / Reviewer |
| 独立审查 | 能设计 Critic / Reviewer 的输入输出 |
| 路由系统 | 能按任务选择 Agent / Skill / Model / Tool |
| 长任务管理 | 能设计 milestone、checkpoint、resume |
| 状态治理 | 能控制共享状态、事实源和写权限 |
| Swarm 边界 | 能判断何时不该多 Agent |
| 平台设计 | 能规划 Agent Registry、Skill Registry、Tool Registry |
| 系统治理 | 能设计 eval、permission、observability、audit |

---

# 下一阶段预告

## 阶段十：方法论沉淀与实战交付｜第 64–70 章

| 章 | 主题 |
|---:|---|
| 64 | Harness Design Canvas |
| 65 | Harness Checklist |
| 66 | Harness Evaluation Rubric |
| 67 | Harness Failure Review |
| 68 | Personal Agent Engineering System |
| 69 | Team Agent Engineering System |
| 70 | 最终整合：Harness Engineering × Agent Engineering 方法论图谱 |

---

## 参考资料

- OpenAI Agents SDK：Agents、handoffs、tracing、guardrails、stateful multi-step work
- LangChain / LangGraph：multi-agent patterns、persistence、short-term / long-term memory、interrupt / human-in-the-loop
- Microsoft AutoGen：multi-agent conversation framework
