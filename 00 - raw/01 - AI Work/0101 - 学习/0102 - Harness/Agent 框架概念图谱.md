---
title: 'Agent 框架概念图谱：LangChain、LangGraph、CrewAI、AutoGen、OpenAI Agents SDK 与 Harness Engineering'
status: raw
created: '2026-05-23 00:00'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'LangChain'
  - 'LangGraph'
  - 'CrewAI'
  - 'AutoGen'
  - 'OpenAI-Agents-SDK'
  - 'Harness-Engineering'
  - 'AI工程化'
---

# Agent 框架概念图谱：LangChain、LangGraph、CrewAI、AutoGen、OpenAI Agents SDK 与 Harness Engineering

## 1. 核心摘要

LangChain、LangGraph、CrewAI、AutoGen、OpenAI Agents SDK 都属于 Agent 应用开发与工程化生态，但它们解决的问题层级不同。

| 概念 | 本质定位 | 简单理解 |
|---|---|---|
| LangChain | LLM 应用开发框架 | 给大模型接模型、工具、RAG、记忆、Agent 的通用工具箱 |
| LangGraph | Agent 工作流 / 状态图运行时 | 把 Agent 流程设计成可控的状态机或流程图 |
| CrewAI | 多 Agent 协作框架 | 像组建一个虚拟团队，让不同 Agent 分工合作 |
| AutoGen | 多 Agent 对话框架 | 让多个 Agent 像开会一样互相对话、协作解决问题 |
| OpenAI Agents SDK | OpenAI 官方 Agent SDK | 用 OpenAI 官方方式构建 Agent、工具调用、handoff、guardrails 和 tracing |
| Harness Engineering | Agent 工程化方法论 | 给 LLM / Agent 套上上下文、工具、流程、权限、评估、观测等工程外壳 |

一句话区分：

> LangChain 解决“怎么接能力”；LangGraph 解决“怎么控流程”；CrewAI 解决“怎么分工协作”；AutoGen 解决“怎么多 Agent 对话”；OpenAI Agents SDK 解决“怎么用 OpenAI 官方方式构建 Agent”；Harness Engineering 解决“怎么把 Agent 做成稳定系统”。

---

## 2. 总体关系图

```text
AI Agent 工程化
│
├─ LangChain
│  └─ 通用 LLM 应用工具箱：模型、Prompt、工具、RAG、Agent
│
├─ LangGraph
│  └─ 可控 Agent 工作流：状态、节点、边、恢复、人工介入
│
├─ CrewAI
│  └─ 多 Agent 团队协作：角色、任务、Crew、Flow
│
├─ AutoGen
│  └─ 多 Agent 对话协作：Agent 之间互相讨论、执行、反馈
│
└─ OpenAI Agents SDK
   └─ OpenAI 官方 Agent 套件：Agent、Tool、Handoff、Guardrail、Tracing

Harness Engineering
└─ 作为总方法论，把上述框架组织成稳定、可评估、可观测、可上线的 Agent 系统
```

---

## 3. LangChain

### 3.1 是什么

LangChain 是一个 LLM 应用开发框架，用于把大模型与外部能力连接起来。

它主要提供：

| 能力 | 说明 |
|---|---|
| Model | 调用 OpenAI、Anthropic、Google、本地模型等 |
| Prompt | 管理提示词模板 |
| Tool | 让模型调用搜索、数据库、API、代码执行等外部工具 |
| RAG | 连接文档、向量数据库、检索流程 |
| Agent | 让模型根据任务自主选择工具和步骤 |
| Observability | 配合 LangSmith 做调试、追踪和评估 |

### 3.2 解决什么问题

LangChain 主要解决：

> 不从零搭建 LLM 应用的基础连接层。

典型场景：

```text
用户问题
  ↓
Prompt 模板
  ↓
LLM
  ↓
检索文档 / 调用工具 / 查询数据库
  ↓
生成结果
```

### 3.3 适合场景

| 适合场景 | 原因 |
|---|---|
| 快速搭建 LLM 应用原型 | 集成多、组件丰富 |
| RAG 系统 | 文档加载、切分、检索、向量库生态较完整 |
| 工具调用型应用 | 能统一管理模型与外部工具 |
| 多模型、多工具组合 | 适合复杂集成 |

### 3.4 不适合场景

| 不适合场景 | 原因 |
|---|---|
| 极简单的一次性 LLM 调用 | 直接调用 API 更简单 |
| 高度定制的生产级 Agent 流程 | 需要更明确的状态和流程控制 |
| 对每一步状态、回滚、重试要求很高的系统 | 更适合使用 LangGraph 这类状态图运行时 |

### 3.5 费曼理解

LangChain 像一个 **AI 应用乐高工具箱**。

它不保证自动搭出好房子，但提供模型积木、工具积木、检索积木、记忆积木和 Agent 积木。

---

## 4. LangGraph

### 4.1 是什么

LangGraph 是 LangChain 生态中的 Agent 编排框架 / 状态图运行时。

它把复杂 Agent 流程拆成：

| 结构 | 含义 |
|---|---|
| State | 当前任务状态 |
| Node | 一个处理步骤，例如调用 LLM、调用工具、人工审核 |
| Edge | 步骤之间的流转关系 |
| Conditional Edge | 根据条件决定下一步 |
| Checkpoint / Persistence | 保存过程状态，支持恢复和长任务执行 |

### 4.2 解决什么问题

LangGraph 主要解决：

> Agent 不能只是让大模型自由发挥，而要像工程系统一样可控。

示例流程：

```text
开始
 ↓
读取数据
 ↓
判断数据是否完整
 ├─ 不完整 → 请求补充
 └─ 完整 → 进入分析
        ↓
      生成诊断
        ↓
      风险审核
        ↓
      输出结果
```

### 4.3 适合场景

| 适合场景 | 原因 |
|---|---|
| 多步骤 Agent | 可以显式设计流程 |
| 长任务 Agent | 支持状态保存和恢复 |
| 需要人工介入的 Agent | 可插入 human-in-the-loop |
| 企业级流程自动化 | 比单纯 Agent loop 更可控 |
| 复杂工具调用 | 能管理分支、循环、失败重试 |

### 4.4 不适合场景

| 不适合场景 | 原因 |
|---|---|
| 简单聊天机器人 | 成本和结构复杂度偏高 |
| 一次性 Prompt 输出 | 没必要使用状态图 |
| 流程结构还不清晰的探索型任务 | 前期可先用简单 Agent 原型验证 |

### 4.5 费曼理解

LangGraph 像 **AI 流水线的交通指挥系统**。

它负责决定：

- 谁先做；
- 谁后做；
- 出错怎么办；
- 是否回退；
- 哪一步需要人工确认；
- 任务状态保存在哪里。

---

## 5. CrewAI

### 5.1 是什么

CrewAI 是一个多 Agent 协作框架，核心思想是把复杂任务拆给多个有角色分工的 Agent。

典型结构：

| 元素 | 说明 |
|---|---|
| Agent | 角色，例如 Researcher、Writer、Reviewer |
| Task | 每个角色要完成的任务 |
| Crew | 多个 Agent 组成的团队 |
| Flow | 更确定性的流程控制 |
| Tool | 每个 Agent 可使用的工具 |

### 5.2 解决什么问题

CrewAI 主要解决：

> 用“团队协作”的方式组织 Agent。

示例：新品 Listing 优化 Agent 团队

| Agent | 职责 |
|---|---|
| Market Research Agent | 分析竞品 |
| Keyword Agent | 提取关键词 |
| Copywriting Agent | 写标题、五点、A+ 文案 |
| Compliance Agent | 检查违规风险 |
| Review Agent | 对最终方案打分和修正 |

### 5.3 适合场景

| 适合场景 | 原因 |
|---|---|
| 多角色协作任务 | 框架天然支持 role / task / crew |
| 内容生产流程 | 研究、写作、审核、润色适配度高 |
| 业务流程自动化 | 可以让不同 Agent 分工处理 |
| 快速搭建多 Agent 原型 | 抽象直观 |

### 5.4 不适合场景

| 不适合场景 | 原因 |
|---|---|
| 强状态机型流程 | LangGraph 更合适 |
| 复杂底层控制 | CrewAI 的高层抽象可能不够细 |
| 对执行路径要求极度确定的任务 | 多 Agent 自主协作会引入不确定性 |
| 简单单 Agent 任务 | 多角色会增加复杂度和调用成本 |

### 5.5 费曼理解

CrewAI 像一个 **AI 项目小组**。

不是雇一个万能助手，而是安排：

- 一个负责查资料；
- 一个负责分析；
- 一个负责写作；
- 一个负责质检；
- 一个负责最终汇总。

---

## 6. AutoGen

### 6.1 是什么

AutoGen 是微软推出的多 Agent 框架，核心思想是让多个 Agent 通过消息对话来协作完成任务。

经典形态：

```text
User Proxy Agent
  ↔ Assistant Agent
  ↔ Tool Agent
  ↔ Reviewer Agent
```

### 6.2 解决什么问题

AutoGen 主要解决：

> 多个 Agent 通过对话协作，而不是只按固定流程执行。

示例：

```text
Planner Agent：拆解任务
Coder Agent：编写代码
Executor Agent：运行代码
Reviewer Agent：检查错误
Planner Agent：根据反馈重新规划
```

### 6.3 适合场景

| 适合场景 | 原因 |
|---|---|
| 多 Agent 研究实验 | 对话式协作灵活 |
| 代码生成 / 代码执行型任务 | 早期典型场景之一 |
| 探索 Agent 之间如何协作 | 适合研究和原型 |
| 人机协作场景 | 可以设计 User Proxy Agent |

### 6.4 不适合场景

| 不适合场景 | 原因 |
|---|---|
| 强流程可控任务 | LangGraph 更清晰 |
| 简单业务自动化 | AutoGen 可能偏重 |
| 对稳定生产化要求很高的新系统 | 需要结合当前维护状态和替代框架谨慎评估 |

### 6.5 费曼理解

AutoGen 像一个 **AI 圆桌会议室**。

每个 Agent 都会发言、反驳、补充、执行，最后一起完成任务。

---

## 7. OpenAI Agents SDK

### 7.1 是什么

OpenAI Agents SDK 是 OpenAI 官方提供的 Agent 开发 SDK。

核心对象是 Agent。一个 Agent 通常包含：

| 组成 | 说明 |
|---|---|
| Instructions | Agent 的行为指令 |
| Model | 使用的模型 |
| Tools | 可调用的工具 |
| Handoffs | 任务转交机制 |
| Guardrails | 输入、输出、工具调用约束 |
| Structured Outputs | 结构化输出 |
| Tracing | 运行过程追踪 |

### 7.2 解决什么问题

OpenAI Agents SDK 主要解决：

> 用 OpenAI 官方方式构建 Agent 应用。

典型客服 Agent 结构：

```text
入口 Agent
 ├─ 订单 Agent
 ├─ 退款 Agent
 ├─ FAQ Agent
 └─ 人工升级 Agent
```

入口 Agent 根据用户问题判断应该交给哪个专业 Agent。

### 7.3 适合场景

| 适合场景 | 原因 |
|---|---|
| 主要使用 OpenAI 模型 | 官方 SDK，适配度高 |
| 需要 OpenAI 托管工具 | 例如 web search、file search、code interpreter、image generation 等 |
| 客服、内部助手、业务 Agent | handoff、guardrails、tracing 实用 |
| 希望少做底层封装 | 官方抽象直接 |

### 7.4 不适合场景

| 不适合场景 | 原因 |
|---|---|
| 强多模型中立架构 | LangChain / LangGraph 生态更开放 |
| 极复杂自定义状态机 | LangGraph 的图结构更适合 |
| 不想绑定 OpenAI 生态 | 官方 SDK 天然偏 OpenAI |
| 跨云、跨模型、跨企业系统深度集成 | 可能需要更中立的编排层 |

### 7.5 费曼理解

OpenAI Agents SDK 像 **OpenAI 官方的 Agent 工程脚手架**。

它可以标准化搭建：

- 一个 Agent；
- 多个 Agent；
- Agent 之间转交任务；
- Agent 调用工具；
- Agent 输出结构化结果；
- 全过程可追踪。

---

## 8. 五个框架的核心区别

### 8.1 按抽象层级区分

| 层级 | 对应框架 | 说明 |
|---|---|---|
| LLM 应用连接层 | LangChain | 连接模型、Prompt、工具、RAG、Agent |
| Agent 编排层 | LangGraph | 管理状态、节点、边、流程、恢复 |
| 多 Agent 协作层 | CrewAI | 用角色、任务、团队组织 Agent |
| 多 Agent 对话层 | AutoGen | 让 Agent 通过对话协作 |
| 官方 Agent SDK | OpenAI Agents SDK | 用 OpenAI 官方方式构建 Agent、工具、handoff、guardrails、tracing |

### 8.2 按控制力区分

| 框架 | 控制力 | 自由度 | 更适合 |
|---|---:|---:|---|
| LangChain | 中 | 高 | 通用 LLM 应用 |
| LangGraph | 高 | 中高 | 可控 Agent 流程 |
| CrewAI | 中 | 高 | 多角色协作 |
| AutoGen | 中低到中 | 高 | 对话式多 Agent 实验 |
| OpenAI Agents SDK | 中高 | 中 | OpenAI 生态内 Agent 应用 |

### 8.3 按生产化倾向区分

| 框架 | 生产化倾向 | 说明 |
|---|---|---|
| LangChain | 中高 | 生态成熟，但复杂流程通常需要配合 LangGraph |
| LangGraph | 高 | 更适合可控、长任务、状态化 Agent |
| CrewAI | 中高 | 多 Agent 业务自动化友好 |
| AutoGen | 低到中 | 更偏研究、原型、多 Agent 对话探索 |
| OpenAI Agents SDK | 高 | 官方 SDK，适合 OpenAI 模型栈应用 |

---

## 9. Harness Engineering

### 9.1 是什么

Harness Engineering 是 Agent 工程化方法论。

它关注的不是模型本身有多聪明，而是如何给模型套上一整套工程化外壳，让它从“会回答”变成“能稳定完成任务”。

### 9.2 核心模块

| Harness 模块 | 解决的问题 |
|---|---|
| Context Harness | 给模型正确上下文 |
| Tool Harness | 让模型安全调用工具 |
| Workflow Harness | 控制任务步骤 |
| Memory Harness | 管理短期记忆和长期记忆 |
| Guardrail Harness | 限制错误、越权、违规输出 |
| Evaluation Harness | 测试效果是否稳定 |
| Observability Harness | 追踪每一步发生了什么 |
| Human-in-the-loop | 哪些步骤需要人工确认 |
| Deployment Harness | 如何上线、监控、回滚 |

一句话：

> Harness Engineering 是 Agent 工程化方法论；Agent 框架是实现 Harness 的工具。

---

## 10. 各框架与 Harness Engineering 的关系

| 框架 | 对应 Harness Engineering 模块 | 关系 |
|---|---|---|
| LangChain | Tool Harness、RAG Harness、Model Harness | 负责把模型、工具、知识库连接起来 |
| LangGraph | Workflow Harness、State Harness、Human-in-the-loop | 负责把 Agent 流程变成可控状态机 |
| CrewAI | Role Harness、Task Harness、Collaboration Harness | 负责把多 Agent 分工协作组织起来 |
| AutoGen | Conversation Harness、Multi-agent Harness | 负责 Agent 之间的对话协作 |
| OpenAI Agents SDK | Tool Harness、Handoff Harness、Guardrail Harness、Tracing Harness | 负责 OpenAI 生态内 Agent 的标准化构建 |

---

## 11. 用 Harness Engineering 视角重新理解这些框架

这些框架不是简单的替代关系，而是不同 Harness 模块的实现工具。

```text
Harness Engineering 是总方法论
        ↓
选择合适框架实现不同 Harness
        ↓
把 Agent 从 Demo 做成可靠系统
```

示例：亚马逊运营 Agent 系统

| 系统需求 | 更适合的框架 |
|---|---|
| 读取广告报表、连接数据库、调用分析工具 | LangChain |
| 控制诊断流程：数据检查 → 异常识别 → 原因分析 → 策略输出 | LangGraph |
| 多 Agent 分工：关键词专家、广告专家、Listing 专家、财务专家 | CrewAI |
| 多 Agent 讨论策略 | AutoGen / CrewAI |
| 使用 OpenAI 模型和官方工具快速构建可追踪 Agent | OpenAI Agents SDK |

---

## 12. 选择建议

### 12.1 按目标选择

| 目标 | 优先选择 |
|---|---|
| 快速做一个 LLM 应用 | LangChain |
| 做一个稳定、可控、多步骤 Agent | LangGraph |
| 做一个多角色 AI 团队 | CrewAI |
| 研究多个 Agent 互相对话 | AutoGen |
| 主要使用 OpenAI，并想用官方工具链 | OpenAI Agents SDK |
| 做生产级 Agent 系统 | LangGraph / OpenAI Agents SDK / CrewAI，并配合 eval、observability、guardrails |

### 12.2 按判断问题选择

| 判断问题 | 推荐方向 |
|---|---|
| 任务流程是否复杂？ | 复杂：LangGraph |
| 是否需要多个角色分工？ | 是：CrewAI |
| 是否主要使用 OpenAI 模型和工具？ | 是：OpenAI Agents SDK |
| 是否需要多模型、多工具、多数据源？ | 是：LangChain / LangGraph |
| 是否只是研究 Agent 互相聊天？ | AutoGen |
| 是否要长期维护生产系统？ | 优先评估 LangGraph、OpenAI Agents SDK、CrewAI 等生产化路径 |

---

## 13. 关键认知边界

### 13.1 框架不等于可靠 Agent

使用框架不代表自动拥有可靠 Agent。

框架只能提供结构和抽象，不能自动解决：

| 问题 | 仍然需要工程设计 |
|---|---|
| Prompt 是否清晰 | 需要 Prompt 设计 |
| 工具是否安全 | 需要权限和参数约束 |
| 流程是否合理 | 需要 Workflow 设计 |
| 输出是否可靠 | 需要 Evaluation |
| 成本是否可控 | 需要 Token 和调用策略 |
| 错误能否定位 | 需要 tracing 和日志 |
| 是否会乱调用工具 | 需要 guardrails |
| 业务目标是否正确 | 需要需求建模 |

### 13.2 Agent 系统的真正难点

真正的难点不是“选择哪个框架”，而是：

> 是否把 Agent 的上下文、工具、流程、记忆、权限、评估、观测、交付全部工程化。

这也是 Harness Engineering 的核心价值。

---

## 14. 最终结论

| 结论 | 说明 |
|---|---|
| LangChain 是工具箱 | 适合连接模型、工具、RAG、外部系统 |
| LangGraph 是流程控制器 | 适合可控、状态化、多步骤 Agent |
| CrewAI 是虚拟团队框架 | 适合角色分工、多 Agent 协作 |
| AutoGen 是 Agent 会议室 | 适合多 Agent 对话、研究、原型验证 |
| OpenAI Agents SDK 是官方脚手架 | 适合 OpenAI 生态内构建 Agent 应用 |
| Harness Engineering 是总方法论 | 负责把 Agent 变成稳定、可测、可观测、可上线的系统 |

最终理解：

> Agent 框架解决“搭建问题”；Harness Engineering 解决“工程化问题”。  
> 生产级 Agent 系统不是靠某一个框架自动生成的，而是靠上下文、工具、流程、权限、评估、观测、部署等 Harness 模块共同支撑出来的。
