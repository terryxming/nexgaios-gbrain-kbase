# Agent 工程化与产品化｜第 53–60 章：多 Agent 与系统架构

> 课程阶段：阶段八  
> 主题：多 Agent 与系统架构  
> 目标：从“单 Agent 能完成任务”，升级到“多角色、多工具、多流程、多权限、多质量门禁的系统设计能力”。

---

# 阶段目标

本阶段解决的问题不是“怎么堆更多 Agent”，而是：

| 能力目标 | 具体表现 |
|---|---|
| 能判断 | 判断什么时候需要多 Agent，什么时候单 Agent 更好 |
| 能选型 | 能选择主管型、流水线型、专家协作型、Router 型、Planner/Executor 型等架构 |
| 能设计交接 | 能设计 Agent 之间的 Handoff、输入、输出、责任边界 |
| 能路由任务 | 能用 Agent Router 把任务分配给合适 Agent |
| 能拆规划与执行 | 能设计 Planner / Executor 架构 |
| 能引入审查 | 能设计 Critic / Reviewer 机制 |
| 能控制复杂度 | 知道 Agent Swarm 的边界和风险 |
| 能平台化 | 能理解组织级 Agent Platform 的基本结构 |

---

# 第 53 章｜多 Agent 是否必要

## 53.1 一句话结论

**多 Agent 不是高级的代名词，而是复杂任务在“角色、上下文、工具、权限、质量标准”上无法被一个 Agent 稳定承载时，才需要引入的系统架构。**

优先级应该是：

```text
Prompt
↓
Workflow
↓
Single Agent
↓
Single Agent + Tools
↓
Single Agent + Workflow
↓
Multi-Agent
↓
Agent Platform
```

不要一开始就多 Agent。

---

## 53.2 费曼解释

一个小店刚开始做客服，不需要设置：

- 售前客服
- 售后客服
- 退款专员
- 技术支持
- 质检主管
- 客诉升级专员

一个人就能处理。

但当任务变复杂后，一个人会出现问题：

| 复杂点 | 后果 |
|---|---|
| 问题类型太多 | 一个 Agent 指令过长，容易混乱 |
| 工具太多 | 工具选择错误率上升 |
| 权限差异大 | 一个 Agent 拿了过多权限 |
| 上下文太杂 | 无关资料污染判断 |
| 质量要求不同 | 同一个标准无法覆盖所有子任务 |
| 风险等级不同 | 低风险和高风险动作混在一起 |

这时才需要多 Agent。

---

## 53.3 多 Agent 解决什么问题

| 问题 | 多 Agent 解决方式 |
|---|---|
| 角色复杂 | 每个 Agent 负责一个专业角色 |
| 上下文复杂 | 每个 Agent 只拿自己需要的上下文 |
| 工具复杂 | 每个 Agent 只拥有相关工具 |
| 权限复杂 | 不同 Agent 分配不同权限等级 |
| 流程复杂 | 通过 Orchestrator 或 Workflow 编排 |
| 质量复杂 | 不同 Agent 用不同 Eval 标准 |
| 协作复杂 | 通过 Handoff、共享状态、消息协议协作 |

OpenAI Agents 文档把 agents 描述为可以规划、调用工具、跨专家协作，并保留足够状态来完成多步骤工作的应用；这说明多 Agent 的核心是“协作完成复杂任务”，不是简单增加角色数量。

---

## 53.4 什么时候不该用多 Agent

| 情况 | 更合适的方案 |
|---|---|
| 任务很简单 | Prompt / Workflow |
| 流程非常固定 | Workflow |
| 只是需要一个工具 | Single Agent + Tool |
| 问题主要是上下文不足 | RAG / Context Engineering |
| 问题主要是输出不稳定 | Structured Output / Eval |
| 团队还没有测试和 trace | 先补质量体系 |
| 任务风险很高但不可控 | 人工流程优先 |
| 只是为了“显得高级” | 不做多 Agent |

Anthropic 在“Building Effective Agents”中强调，成功实现通常依赖简单、可组合的模式，而不是一开始就使用复杂框架。这个原则对多 Agent 设计尤其重要：复杂性必须由真实任务复杂性驱动，而不是由架构审美驱动。

---

## 53.5 是否需要多 Agent 的判断表

| 判断问题 | 如果答案是“是” | 说明 |
|---|---|---|
| 是否有明显不同角色？ | 可以考虑 | 如研究、执行、审核 |
| 是否需要不同工具权限？ | 可以考虑 | 如读取、写入、发送分离 |
| 是否存在不同上下文边界？ | 可以考虑 | 如财务资料和客服资料分开 |
| 是否需要并行处理？ | 可以考虑 | 如多方向研究 |
| 是否需要独立审核？ | 可以考虑 | 如 Critic / Reviewer |
| 是否一个 Agent 指令已经过长？ | 可以考虑 | 拆分职责 |
| 是否已有 trace / eval 能力？ | 必须具备 | 否则调试困难 |
| 是否能定义清楚交接协议？ | 必须具备 | 否则协作混乱 |

---

## 53.6 本章误区

| 误区 | 正确理解 |
|---|---|
| 多 Agent 一定比单 Agent 强 | 不一定，复杂性会增加失败率 |
| 多 Agent 能自动提升质量 | 只有职责、上下文、交接、评估清楚才会提升 |
| Agent 越多越接近团队 | 没有管理机制的多 Agent 只是混乱 |
| 先做多 Agent 再优化 | 应先验证单 Agent 边界 |
| 多 Agent 可以替代 Workflow | 多 Agent 仍然需要流程编排 |

---

# 第 54 章｜多 Agent 架构模式

## 54.1 一句话结论

**多 Agent 架构模式，本质上是在设计“谁负责决策、谁负责执行、谁负责审核、谁负责交接”。**

常见模式包括：

| 模式 | 简单理解 |
|---|---|
| Supervisor 模式 | 一个主管 Agent 调度多个专家 Agent |
| Pipeline 模式 | 多个 Agent 按顺序接力 |
| Router 模式 | 先判断任务类型，再分配给对应 Agent |
| Planner / Executor 模式 | 一个负责规划，一个负责执行 |
| Critic / Reviewer 模式 | 一个生成，一个审查 |
| Blackboard 模式 | 多个 Agent 围绕共享工作区协作 |
| Swarm 模式 | 多 Agent 分布式协作，自治程度更高 |

LangChain 多 Agent 文档把常见方式分为 subagents 和 handoffs：subagents 中主 Agent 负责协调并把子 Agent 当工具调用；handoffs 则根据状态动态切换当前活跃 Agent。这对应了集中式和去中心化两类多 Agent 控制模式。

---

## 54.2 模式一：Supervisor / Subagents

```text
用户任务
↓
Supervisor Agent
├─ Research Agent
├─ Data Agent
├─ Writing Agent
└─ Review Agent
```

| 维度 | 内容 |
|---|---|
| 核心 | 一个主管 Agent 统一调度 |
| 优点 | 控制清晰、易审计、便于统一输出 |
| 缺点 | Supervisor 容易成为瓶颈 |
| 适合 | 多专家协作但需要统一控制的任务 |

适合场景：

- 研究报告生成
- 电商运营诊断
- PRD 拆解与开发任务分配
- 多角色内容生产

---

## 54.3 模式二：Pipeline

```text
输入
↓
需求分析 Agent
↓
方案设计 Agent
↓
执行 Agent
↓
审核 Agent
↓
输出
```

| 维度 | 内容 |
|---|---|
| 核心 | 多个 Agent 按固定顺序接力 |
| 优点 | 流程清晰、稳定、易测试 |
| 缺点 | 灵活性较低，前一步错误会传递 |
| 适合 | 流程稳定、有明确阶段的任务 |

适合场景：

- 知识沉淀
- 内容生产
- 报告生成
- 客服回复草稿生成
- 开发任务流程化处理

---

## 54.4 模式三：Router

```text
用户输入
↓
Router Agent
├─ 广告诊断 Agent
├─ Listing 优化 Agent
├─ 客服回复 Agent
└─ 知识沉淀 Agent
```

| 维度 | 内容 |
|---|---|
| 核心 | 先判断任务类型，再分配给对应 Agent |
| 优点 | 可扩展，适合多业务入口 |
| 缺点 | 路由错会导致后续全错 |
| 适合 | 多 Agent 工作台、企业 AI 助手 |

---

## 54.5 模式四：Planner / Executor

```text
用户目标
↓
Planner Agent：拆解计划
↓
Executor Agent：执行步骤
↓
Verifier：检查结果
```

| 维度 | 内容 |
|---|---|
| 核心 | 规划和执行分离 |
| 优点 | 计划更清晰，执行更可控 |
| 缺点 | 计划可能脱离执行能力 |
| 适合 | 复杂任务、代码开发、研究任务 |

---

## 54.6 模式五：Critic / Reviewer

```text
Generator Agent
↓
Critic / Reviewer Agent
↓
修改或通过
```

| 维度 | 内容 |
|---|---|
| 核心 | 一个 Agent 生成，另一个 Agent 审查 |
| 优点 | 提高质量、发现漏项 |
| 缺点 | 增加成本和延迟 |
| 适合 | 高价值输出、报告、代码、客服、合规内容 |

---

## 54.7 模式六：Blackboard

```text
共享工作区 / Blackboard
├─ Research Agent 写入资料
├─ Analysis Agent 写入判断
├─ Writing Agent 写入草稿
└─ Review Agent 写入反馈
```

| 维度 | 内容 |
|---|---|
| 核心 | 多个 Agent 围绕共享状态协作 |
| 优点 | 适合复杂开放任务 |
| 缺点 | 状态治理难，容易冲突 |
| 适合 | 研究、复杂项目、长期任务 |

---

## 54.8 模式选择表

| 任务特征 | 推荐模式 |
|---|---|
| 多专家但需要统一控制 | Supervisor |
| 流程阶段清晰 | Pipeline |
| 多入口、多任务类型 | Router |
| 目标复杂、需要先规划 | Planner / Executor |
| 输出质量要求高 | Critic / Reviewer |
| 需要共享长期工作区 | Blackboard |
| 高并行、探索型任务 | Swarm，但谨慎使用 |

---

# 第 55 章｜Handoff 机制

## 55.1 一句话结论

**Handoff 是 Agent 之间的任务交接机制。它不是简单“叫另一个 Agent”，而是把任务、上下文、状态、责任和输出要求清楚交给下一个 Agent。**

OpenAI Agents SDK 文档说明，handoffs 允许一个 Agent 将任务委托给另一个 Agent，适用于不同 Agent 专门处理不同任务的场景；handoff 在模型侧通常表现为一个可调用工具。

---

## 55.2 费曼解释

在人类团队中，交接不能只说：

> 这个你处理一下。

好的交接应该说：

```text
客户问题是什么？
已经查过什么？
当前状态是什么？
需要你做什么？
不要做什么？
交付物是什么？
什么时候需要升级？
```

Agent Handoff 也是一样。

---

## 55.3 Handoff 的基本结构

| 字段 | 说明 |
|---|---|
| from_agent | 谁发起交接 |
| to_agent | 交给谁 |
| task_summary | 任务摘要 |
| current_state | 当前状态 |
| relevant_context | 必要上下文 |
| completed_steps | 已完成步骤 |
| pending_steps | 待完成步骤 |
| constraints | 约束和禁止事项 |
| expected_output | 预期输出 |
| escalation_rule | 什么时候升级或返回 |

---

## 55.4 Handoff 示例：广告诊断

```markdown
# Handoff: Ads Diagnosis Agent → Recommendation Agent

## task_summary
用户需要分析 ACOS 上升原因，并生成优化建议。

## completed_steps
- 已读取广告报表
- 已完成当前周期和对比周期指标计算
- 已定位到 keyword: karaoke machine 的 CVR 明显下降

## relevant_context
- CPC 变化较小
- CVR 从 5.5% 降至 3.8%
- Spend 增长但 Orders 下降

## constraints
- 不得建议直接暂停核心关键词
- 不得建议未经确认修改预算
- 必须区分事实、判断和建议

## expected_output
- 输出 3–5 条优化建议
- 每条建议包含对象、动作、理由、风险和优先级
```

---

## 55.5 好 Handoff 的标准

| 标准 | 说明 |
|---|---|
| 简短 | 不把所有历史都塞过去 |
| 相关 | 只传当前 Agent 需要的信息 |
| 有状态 | 说明任务进行到哪里 |
| 有责任 | 明确下一个 Agent 做什么 |
| 有边界 | 明确不能做什么 |
| 可追踪 | 记录交接来源和原因 |
| 可恢复 | 下一个 Agent 能接着做，不用重来 |

---

## 55.6 Handoff 常见错误

| 错误 | 后果 |
|---|---|
| 只传原始对话 | 下游 Agent 重新理解，容易偏差 |
| 传太多上下文 | 污染判断 |
| 不说明已完成步骤 | 重复执行 |
| 不说明失败点 | 重复踩坑 |
| 不说明约束 | 可能越权 |
| 不说明输出要求 | 交付物不一致 |
| 交接循环 | Agent 互相转交不完成 |

---

# 第 56 章｜Agent Router

## 56.1 一句话结论

**Agent Router 是多 Agent 系统的分流器，负责判断用户任务应该交给哪个 Agent、哪个 Workflow 或哪个人工入口。**

Router 的核心不是“聪明回答”，而是：

```text
分类准确
边界清晰
低风险兜底
可解释
可回退
```

---

## 56.2 Router 和 Supervisor 的区别

| 对比项 | Router | Supervisor |
|---|---|---|
| 主要职责 | 分配任务入口 | 管理完整执行过程 |
| 生命周期 | 通常在任务开始时工作 | 贯穿任务全过程 |
| 输出 | 选择哪个 Agent / Workflow | 调度、检查、整合结果 |
| 复杂度 | 中 | 高 |
| 类比 | 前台分诊 | 项目经理 |

---

## 56.3 Router 的输入

| 输入 | 作用 |
|---|---|
| 用户原始输入 | 判断任务意图 |
| 用户角色 | 判断权限和场景 |
| 当前项目 | 判断上下文范围 |
| 可用 Agent 列表 | 决定候选路由 |
| 任务历史 | 判断是否接续任务 |
| 风险规则 | 高风险任务转人工或确认 |
| Agent 能力描述 | 避免错配 |

---

## 56.4 Router 的输出

```json
{
  "route": "ads_diagnosis_agent",
  "confidence": "high",
  "reason": "User asks to diagnose ACOS increase using advertising data.",
  "required_context": ["ads_report", "date_range", "comparison_period"],
  "fallback": "ask_for_missing_data"
}
```

Router 输出最好包含：

| 字段 | 说明 |
|---|---|
| route | 分配到哪个 Agent |
| confidence | 路由置信度 |
| reason | 为什么这样分配 |
| required_context | 需要哪些上下文 |
| fallback | 失败或低置信度时怎么办 |
| risk_level | 风险等级 |

---

## 56.5 Router 测试重点

| 测试类型 | 示例 |
|---|---|
| 正确路由 | “分析 ACOS 为什么升高” → 广告诊断 Agent |
| 错误拒绝 | “ACOS 是什么” → 概念解释，不进诊断 Agent |
| 近似区分 | “整理这段内容” vs “沉淀成 llm-wiki 文件” |
| 低置信度处理 | 模糊任务先澄清 |
| 权限拦截 | 无权限用户不得进入高权限 Agent |
| 转人工 | 高风险或合规问题转人工 |

---

# 第 57 章｜Planner / Executor 架构

## 57.1 一句话结论

**Planner / Executor 架构把“怎么做计划”和“怎么执行动作”分开，让复杂任务更清晰、更可控、更容易评估。**

```text
Planner：负责拆任务、定步骤、识别风险
Executor：负责按计划调用工具、执行动作、返回结果
Verifier：负责检查结果是否符合计划
```

---

## 57.2 为什么要分离 Planner 和 Executor

| 不分离的问题 | 分离后的好处 |
|---|---|
| 边想边做，容易跳步 | 先计划，再执行 |
| 执行时乱改目标 | Executor 按计划执行 |
| 工具调用不受控 | 每一步工具明确 |
| 失败后难恢复 | 可定位是哪一步失败 |
| 质量评估困难 | 可分别评估计划和执行 |

---

## 57.3 Planner 负责什么

| 职责 | 示例 |
|---|---|
| 理解目标 | 用户要降低 ACOS |
| 拆解任务 | 数据检查、指标计算、根因判断 |
| 定义步骤 | Step 1 / Step 2 / Step 3 |
| 识别依赖 | 先有报表，才能计算指标 |
| 标记风险 | 不直接改预算 |
| 定义输出 | 诊断表、建议表、风险提示 |
| 设定停止条件 | 缺数据时停止 |

---

## 57.4 Executor 负责什么

| 职责 | 示例 |
|---|---|
| 读取计划 | 接收 Planner 输出 |
| 调用工具 | 读取报表、计算指标 |
| 记录结果 | 保存每步输出 |
| 处理错误 | 工具失败则重试或报告 |
| 遵守边界 | 不执行未授权动作 |
| 返回状态 | completed / failed / waiting |

---

## 57.5 Planner 输出模板

```markdown
# Execution Plan

## Goal
分析 ACOS 上升原因并输出优化建议。

## Steps
| Step | Action | Tool | Input | Output | Risk |
|---|---|---|---|---|---|
| 1 | 检查字段 | validate_report_schema | ads_report | 字段检查结果 | 低 |
| 2 | 计算指标 | calculate_ads_metrics | report rows | 指标变化表 | 低 |
| 3 | 判断根因 | reasoning | metrics summary | 根因判断 | 中 |
| 4 | 生成建议 | reasoning | root causes | 建议动作表 | 中 |

## Stop Conditions
- 缺少 spend、sales、orders 字段
- 工具连续失败 2 次
- 涉及预算修改但未获得确认
```

---

## 57.6 Planner / Executor 的风险

| 风险 | 说明 |
|---|---|
| Planner 计划过度 | 小任务被拆太复杂 |
| Planner 脱离工具能力 | 计划了不存在的工具 |
| Executor 机械执行 | 不发现计划本身错误 |
| 两者沟通成本高 | token、延迟上升 |
| 责任边界不清 | 失败不知道谁负责 |

解决方式：

| 风险 | 解决 |
|---|---|
| 过度规划 | 设置任务复杂度阈值 |
| 工具不匹配 | Planner 只能看到可用工具清单 |
| 机械执行 | Executor 可标记计划不可执行 |
| 成本上升 | 简单任务不走 Planner / Executor |
| 边界不清 | 明确 plan schema 和执行状态 |

---

# 第 58 章｜Critic / Reviewer 架构

## 58.1 一句话结论

**Critic / Reviewer 架构通过独立审查 Agent 来发现错误、漏项、风险和低质量输出，是提升 Agent 结果可靠性的常见方式。**

但它不是万能保险。

```text
Generator 负责生成
Reviewer 负责检查
Generator 根据反馈修正
Human 对高风险结果最终确认
```

---

## 58.2 Reviewer 适合检查什么

| 检查项 | 示例 |
|---|---|
| 是否完成任务 | 有没有回答用户真正问题 |
| 是否缺字段 | 报告是否缺风险提示 |
| 是否有证据 | 结论是否基于数据 |
| 是否有编造 | 是否引用不存在信息 |
| 是否违反约束 | 是否执行了禁止动作 |
| 是否有安全风险 | 是否泄露敏感信息 |
| 是否可执行 | 建议是否落到具体对象 |
| 是否格式正确 | Markdown / JSON 是否合规 |

---

## 58.3 Reviewer 不适合单独决定什么

| 不适合 | 原因 |
|---|---|
| 最终高风险批准 | 需要人类确认 |
| 精确财务真实性 | 应由确定性计算和数据源验证 |
| 法律合规最终判断 | 需要专业责任人 |
| 医疗诊断最终判断 | 高风险专业领域 |
| 安全权限最终裁决 | 应由权限系统控制 |

---

## 58.4 Critic / Reviewer 模板

```markdown
# Review Report

## 1. 是否完成用户目标
- 结论：
- 问题：

## 2. 准确性
- 是否有事实错误：
- 是否有编造：

## 3. 完整性
- 缺失内容：

## 4. 证据性
- 哪些结论有证据：
- 哪些结论缺证据：

## 5. 可执行性
- 建议是否具体：
- 是否有下一步：

## 6. 风险与边界
- 是否涉及高风险：
- 是否需要人工确认：

## 7. 修改建议
| 问题 | 修改建议 | 优先级 |
|---|---|---|
```

---

## 58.5 Reviewer 设计原则

| 原则 | 说明 |
|---|---|
| 独立标准 | Reviewer 不应只复述 Generator |
| 明确评分表 | 用 rubric 而不是凭感觉 |
| 关注约束 | 检查禁止项和风险 |
| 输出可操作 | 给出具体修改建议 |
| 不无限循环 | 设置最多修订次数 |
| 高风险转人工 | Reviewer 不能替代责任人 |

---

# 第 59 章｜Agent Swarm 的边界

## 59.1 一句话结论

**Agent Swarm 是多个 Agent 以较高自治程度协作的模式，适合探索型、并行型、开放型任务，但不适合作为大多数业务系统的默认架构。**

Anthropic 在多 Agent 研究系统复盘中提到，研究类任务可以由一个 Agent 规划研究流程，并创建并行 Agent 同时搜索信息；这类系统适合“广度优先”的复杂研究，但也带来架构、工具设计和提示工程上的生产化挑战。

---

## 59.2 Swarm 适合什么

| 场景 | 原因 |
|---|---|
| 广度研究 | 多方向并行搜索 |
| 竞品扫描 | 多个 Agent 分别查不同竞品 |
| 多资料源汇总 | 分头读取不同来源 |
| 创意发散 | 多 Agent 生成不同方案 |
| 大规模信息归纳 | 分块处理，再汇总 |
| 复杂问题探索 | 需要多条路径同时尝试 |

---

## 59.3 Swarm 不适合什么

| 场景 | 原因 |
|---|---|
| 高风险写入 | 难以控制副作用 |
| 金钱交易 | 权限和确认复杂 |
| 强一致流程 | Workflow 更好 |
| 小任务 | 架构成本过高 |
| 需要精确审计 | Swarm 路径复杂 |
| 工具权限混乱 | 容易越权 |
| 没有 Trace / Eval | 无法调试质量 |

LangChain 关于何时构建多 Agent 的讨论强调，上下文工程非常关键，且主要“读”的多 Agent 系统通常比会“写”的多 Agent 系统更容易控制。这一点可作为 Swarm 设计边界：读多写少更适合，写入动作必须强治理。

---

## 59.4 Swarm 的主要风险

| 风险 | 说明 |
|---|---|
| 成本爆炸 | 多 Agent 并行调用模型和工具 |
| 结果冲突 | 不同 Agent 得出不同结论 |
| 状态混乱 | 谁完成了什么不清楚 |
| 重复劳动 | 多个 Agent 查同一资料 |
| 权限扩散 | 多个 Agent 拥有过多工具 |
| 调试困难 | 错误链路难追踪 |
| 质量不可控 | 输出整合困难 |
| 责任不清 | 不知道哪个 Agent 造成错误 |

---

## 59.5 Swarm 控制原则

| 原则 | 说明 |
|---|---|
| 只读优先 | 先用于研究、检索、分析 |
| 限制 Agent 数量 | 不无限创建 |
| 限制深度 | 不无限递归 |
| 共享任务板 | 所有 Agent 写入统一状态 |
| 去重机制 | 避免重复搜索 |
| 汇总 Agent | 最后统一整合 |
| Reviewer 审查 | 检查冲突、证据、风险 |
| 成本预算 | 设置最大 token、工具调用和时间 |
| 权限隔离 | 子 Agent 默认低权限 |

---

# 第 60 章｜组织级 Agent 平台

## 60.1 一句话结论

**组织级 Agent 平台不是“很多 Agent 的集合”，而是一套统一管理 Agent、工具、上下文、权限、评估、Trace、部署和运营的系统。**

它解决的问题是：

```text
Agent 多了以后怎么发现？
工具多了以后怎么复用？
权限多了以后怎么治理？
输出多了以后怎么评估？
事故发生后怎么追踪？
版本更新后怎么回滚？
```

---

## 60.2 从单 Agent 到平台的演进

```text
单点 Prompt
↓
单 Agent
↓
Workflow Agent
↓
多个专用 Agent
↓
工具库 / Skill 库
↓
统一评估和 Trace
↓
组织级 Agent Platform
```

---

## 60.3 Agent Platform 核心模块

| 模块 | 作用 |
|---|---|
| Agent Registry | 管理有哪些 Agent、适用场景、owner、版本 |
| Tool Registry | 管理工具能力、权限、Schema、状态 |
| Skill Library | 管理可复用方法、模板、脚本、evals |
| Context Layer | 管理知识库、文件、检索、上下文注入 |
| Memory Layer | 管理用户记忆、项目记忆、团队记忆 |
| Permission System | 管理用户、Agent、工具、数据权限 |
| Orchestration Layer | 管理 Workflow、Router、Handoff、多 Agent 协作 |
| Eval System | 管理测试集、评分标准、回归评估 |
| Trace / Observability | 记录运行链路、成本、延迟、错误 |
| Deployment System | 管理 dev / staging / prod、灰度、回滚 |
| Feedback System | 收集用户采纳、修改、投诉、失败案例 |
| Governance | 管理安全、合规、审计、版本策略 |

---

## 60.4 Agent Registry 示例

```yaml
agents:
  - name: knowledge_markdown_agent
    owner: knowledge_team
    version: 1.2.0
    status: stable
    use_cases:
      - conversation_to_markdown
      - course_notes_export
    permissions:
      - read_conversation
      - write_file
    eval_set: evals/knowledge_cases.yaml

  - name: amazon_ads_diagnosis_agent
    owner: ops_team
    version: 0.5.0
    status: beta
    use_cases:
      - acos_diagnosis
      - keyword_performance_analysis
    permissions:
      - read_ads_report
      - calculate_metrics
      - generate_report
    restricted_actions:
      - modify_budget
      - pause_campaign
```

---

## 60.5 平台级治理问题

| 问题 | 治理方式 |
|---|---|
| 谁能创建 Agent | Agent 创建权限 |
| 谁能发布 Agent | 审批和评估通过 |
| 谁能调用工具 | RBAC / ABAC 权限模型 |
| 谁能读取数据 | 数据权限和脱敏 |
| Agent 出错谁负责 | owner 和 runbook |
| Prompt 改动如何上线 | 版本、评估、灰度 |
| 工具变更如何通知 | registry + changelog |
| 高风险动作如何审批 | human-in-the-loop |
| 事故如何复盘 | trace + incident review |

---

## 60.6 不要过早平台化

| 过早平台化表现 | 风险 |
|---|---|
| 场景没验证就做平台 | 没用户使用 |
| 工具还不稳定就做工具市场 | 复用低、维护高 |
| eval 没建立就扩 Agent | 质量不可控 |
| 权限没设计就开放工具 | 安全风险大 |
| 没 owner 就上线 Agent | 出问题无人负责 |
| UI 先行，能力滞后 | 好看但不可用 |

正确路径：

```text
先做 1 个高价值 Agent
↓
验证任务闭环
↓
沉淀工具和模板
↓
复制到相邻场景
↓
建立 registry / eval / trace
↓
再做平台
```

---

# 第 53–60 章总复盘

## 1. 本阶段核心公式

```text
多 Agent 系统
= 单 Agent 能力
+ 明确角色分工
+ 清晰 Handoff
+ 共享状态
+ 路由机制
+ 质量审查
+ 权限隔离
+ Trace / Eval / Governance
```

```text
什么时候需要多 Agent
= 一个 Agent 的角色、工具、上下文、权限、质量标准已经过载
```

```text
组织级 Agent Platform
= Agent Registry
+ Tool Registry
+ Skill Library
+ Context / Memory Layer
+ Permission System
+ Orchestration
+ Eval
+ Trace
+ Deployment
+ Governance
```

---

## 2. 八个核心结论

| 序号 | 核心结论 |
|---|---|
| 1 | 多 Agent 不是默认选项，只有当单 Agent 过载时才需要 |
| 2 | 多 Agent 架构的核心是角色、上下文、工具、权限和责任边界 |
| 3 | Supervisor、Pipeline、Router、Planner/Executor、Critic/Reviewer 是最常用的模式 |
| 4 | Handoff 不是转发聊天记录，而是结构化交接任务状态和责任 |
| 5 | Router 是多 Agent 系统的分诊台，路由错会导致后续全错 |
| 6 | Planner / Executor 适合复杂任务，但简单任务不应过度设计 |
| 7 | Critic / Reviewer 能提升质量，但不能替代确定性测试和人工责任 |
| 8 | Agent Platform 不是 Agent 堆叠，而是统一治理 Agent、工具、上下文、权限、评估和运营 |

---

## 3. 本阶段实践作业

```markdown
# 多 Agent 系统设计草案

## 1. 系统名称

## 2. 是否真的需要多 Agent
| 判断项 | 结论 |
|---|---|
| 单 Agent 是否已过载 |  |
| 是否存在多种专业角色 |  |
| 是否需要不同工具权限 |  |
| 是否需要不同上下文边界 |  |
| 是否需要独立审核 |  |
| 是否有 Trace / Eval 基础 |  |

## 3. Agent 角色设计
| Agent | 职责 | 输入 | 输出 | 工具 | 权限 |
|---|---|---|---|---|---|

## 4. 架构模式选择
- Supervisor：
- Pipeline：
- Router：
- Planner / Executor：
- Critic / Reviewer：
- Blackboard：
- Swarm：

## 5. Handoff 设计
| From | To | 交接内容 | 输出要求 | 失败处理 |
|---|---|---|---|---|

## 6. Router 设计
| 用户意图 | Route | Confidence | Fallback |
|---|---|---|---|

## 7. Planner / Executor 设计
| 模块 | 职责 |
|---|---|
| Planner |  |
| Executor |  |
| Verifier |  |

## 8. Reviewer 设计
| 检查项 | 标准 |
|---|---|

## 9. 共享状态设计
| 状态字段 | 作用 | 谁读 | 谁写 |
|---|---|---|---|

## 10. 权限隔离
| Agent | 权限等级 | 禁止动作 |
|---|---|---|

## 11. Trace / Eval
| 项目 | 设计 |
|---|---|
| Trace |  |
| Test |  |
| Eval |  |
| Review |  |

## 12. 平台化沉淀
| 可沉淀资产 | 形式 |
|---|---|
| Agent | Registry |
| Tool | Tool Registry |
| Skill | Skill Library |
| Eval | Eval Set |
| Workflow | Orchestration Template |
```

---

# 参考来源

- OpenAI Agents SDK / Agents
- OpenAI Agents SDK / Handoffs
- LangChain Docs / Multi-agent
- Anthropic / Building Effective Agents
- Anthropic / How we built our multi-agent research system
- LangChain Blog / How and when to build multi-agent systems
