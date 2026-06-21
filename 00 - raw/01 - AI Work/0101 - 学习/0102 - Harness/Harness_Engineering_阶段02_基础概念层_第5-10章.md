---
title: 'Harness Engineering｜阶段二：基础概念层｜第 5–10 章'
status: raw
created: '2026-05-21 00:35'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Harness'
  - 'Skill'
---

# Harness Engineering｜阶段二：基础概念层｜第 5–10 章

> 课程定位：本阶段不讲具体框架教程，而是拆解 Agent Harness 的 6 个基础层：Model、Instruction、Context、Tool、State、Execution。目标是让你知道一个 Agent 的外壳系统到底由哪些基础部件组成，每个部件负责什么，不负责什么，以及怎么迁移到你的 Agent 工程构建中。

---

## 阶段二总览

| 章 | 模块 | 核心问题 | 一句话理解 |
|---:|---|---|---|
| 5 | Model Layer | 模型能做什么、不能做什么 | 模型是大脑，不是完整系统 |
| 6 | Instruction Layer | 如何给 Agent 定规则 | 指令层定义行为契约 |
| 7 | Context Layer | Agent 应该看什么 | 上下文决定模型判断材料 |
| 8 | Tool Layer | Agent 能调用什么能力 | 工具层让模型从“说”变成“做” |
| 9 | State Layer | Agent 如何保存过程 | 状态层让任务可以持续推进 |
| 10 | Execution Layer | Agent 在哪里安全运行 | 执行层提供运行环境和安全边界 |

---

# 第 5 章：Model Layer｜模型能做什么，不能做什么

## 5.1 本章核心

> Model Layer 是 Agent 的智能核心，但不是 Agent 的全部。

模型负责理解、推理、生成、判断。  
Harness 负责上下文、工具、状态、执行、验证、安全、反馈。

如果把 Agent 比作一个工程团队：

| 部分 | 类比 |
|---|---|
| Model | 高智商员工 |
| Instruction | 工作规则 |
| Context | 项目资料 |
| Tool | 工具箱 |
| State | 工作记录 |
| Execution | 办公环境 |
| Eval | 质检部门 |
| Safety | 权限制度 |

---

## 5.2 Model Layer 的主要能力

| 能力 | 说明 | 在 Agent 中的作用 |
|---|---|---|
| 语言理解 | 理解自然语言、文档、代码、表格 | 读懂用户目标和资料 |
| 语义推理 | 判断原因、关系、优先级 | 做方案判断和任务拆解 |
| 规划生成 | 生成步骤和执行计划 | 拆解复杂任务 |
| 内容生成 | 生成代码、文案、报告、提示词 | 产出交付物 |
| 纠错反思 | 根据反馈修正输出 | 支持迭代改进 |
| 多模态理解 | 理解图片、截图、图表等 | 支持设计、视觉、文档分析 |
| 工具调用决策 | 判断是否调用工具 | 连接 Tool Layer |

---

## 5.3 Model Layer 的边界

| 模型不能天然保证的事 | 为什么 | 需要哪个 Harness 层补齐 |
|---|---|---|
| 永远事实正确 | 模型基于概率生成，可能幻觉 | Context / Retrieval / Verification |
| 永远按流程执行 | 模型会偷懒、跳步、误判 | Workflow / Quality Gate |
| 永远知道最新信息 | 训练数据有截止时间 | Web / RAG / Tool |
| 永远记住项目状态 | 对话上下文有限且会漂移 | State / Memory / Filesystem |
| 永远正确使用工具 | 工具描述、权限、参数可能不清 | Tool Schema / Permission |
| 永远知道自己错了 | 模型自评不稳定 | Test / Eval / Review |
| 永远安全 | 可能执行高风险操作 | Sandbox / Approval / Allowlist |

---

## 5.4 关键参数：不要只看“模型名字”

| 参数 | 影响 | Harness 设计含义 |
|---|---|---|
| 模型能力 | 推理、代码、视觉、工具调用能力 | 决定适合做什么任务 |
| 上下文窗口 | 能一次看多少内容 | 决定是否需要压缩和检索 |
| 输出稳定性 | 同一任务输出是否一致 | 决定是否需要低温度、模板、schema |
| 工具调用能力 | 能否可靠选择工具和参数 | 决定 Tool Layer 是否可重度依赖 |
| 结构化输出能力 | 能否稳定输出 JSON / schema | 决定自动化程度 |
| 成本与延迟 | 每次调用的价格和速度 | 决定是否分层使用模型 |
| 多模态能力 | 是否能看图、读表、理解截图 | 决定是否能处理视觉任务 |

---

## 5.5 常见误区

| 误区 | 为什么错 | 正确理解 |
|---|---|---|
| 模型越强，Harness 越不重要 | 强模型会承担更复杂任务，复杂任务更需要控制 | 模型越强，越需要 Harness 放大能力 |
| 换更强模型就能解决所有问题 | 很多问题是上下文、流程、验证缺失 | 先诊断是 Model 问题还是 Harness 问题 |
| 模型自检等于质量保证 | 自检仍然是模型生成，可能同样出错 | 需要外部 test / eval |
| 长上下文等于好上下文 | 长上下文可能引入噪声 | 关键是上下文选择和结构 |
| Agent 出错就是模型差 | 也可能是工具、状态、权限、验证设计差 | 用分层方式定位问题 |

---

## 5.6 在 Agent 工程中的设计原则

| 原则 | 说明 |
|---|---|
| 模型负责判断，不负责兜底 | 兜底要靠测试、权限、回滚 |
| 模型负责生成，不负责最终验收 | 验收要用外部标准 |
| 模型适合语义任务，程序适合确定性任务 | 能用代码校验的，不让模型主观判断 |
| 不同任务可用不同模型 | 规划、执行、审查、总结可以分模型 |
| 模型输出必须进入 Harness 检查 | 不能把模型最终回答直接当交付结果 |

---

## 5.7 Feynman 解释

模型像一个聪明的大脑。  
但大脑不能替代：

```text
眼睛看到的资料
手能使用的工具
身体所在的环境
工作过程的记录
交付前的质检
危险动作的权限控制
```

所以 Agent 不是“一个大脑”，而是“大脑 + 外部工程系统”。

---

## 5.8 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 区分 Model 和 Harness | 能说清哪些问题靠模型，哪些问题靠外层系统 |
| 判断模型适用边界 | 能判断一个任务是否需要强推理、长上下文、工具调用 |
| 诊断 Agent 失败原因 | 能区分是模型能力不足，还是上下文/工具/验证缺失 |
| 设计模型使用策略 | 能决定是否需要多模型、低温度、结构化输出、外部校验 |

---

# 第 6 章：Instruction Layer｜系统提示词与规则

## 6.1 本章核心

> Instruction Layer 是 Agent 的行为契约，规定 Agent 应该怎么理解任务、怎么行动、遵守什么边界、按什么格式输出。

Instruction 不只是“提示词”。  
在工程场景中，它更像：

```text
角色定义
任务范围
工作流程
禁止事项
输出格式
质量标准
失败处理
调用工具规则
```

---

## 6.2 Instruction Layer 包含什么

| 类型 | 作用 | 例子 |
|---|---|---|
| Role Instruction | 定义 Agent 身份 | 你是 Skill 质量评估专家 |
| Task Instruction | 定义任务目标 | 评估 SKILL.md 是否可执行 |
| Boundary Instruction | 定义边界 | 不要修改无关文件 |
| Process Instruction | 定义步骤 | 先读 PRD，再审计上下文，再执行 |
| Tool Instruction | 定义工具使用规则 | 只有需要读文件时才调用 file search |
| Output Instruction | 定义输出格式 | 输出评分表、问题清单、改进建议 |
| Quality Instruction | 定义完成标准 | 必须说明触发准确性、执行落地性 |
| Safety Instruction | 定义风险控制 | 涉及删除文件必须先确认 |
| Failure Instruction | 定义失败处理 | 信息不足时先列出假设和风险 |

---

## 6.3 指令层的层级

| 层级 | 位置 | 作用 | 稳定性 |
|---|---|---|---|
| System / Developer Instruction | 系统级 | 定义最高优先级行为规则 | 最高 |
| Agent Instruction | Agent 定义中 | 定义这个 Agent 的专业能力和边界 | 高 |
| Repo Instruction | AGENTS.md / 项目规范 | 定义仓库级工程规则 | 高 |
| Skill Instruction | SKILL.md | 定义某个能力如何触发和执行 | 中高 |
| Task Instruction | 当前用户任务 | 定义本次任务目标 | 中 |
| Output Instruction | 当前输出约束 | 定义格式、长度、语言 | 中 |

---

## 6.4 高质量 Instruction 的结构

推荐结构：

```text
1. 角色：你是谁
2. 目标：你要完成什么
3. 输入：你会收到什么
4. 输出：你要交付什么
5. 流程：你按什么步骤做
6. 约束：你不能做什么
7. 工具：什么时候用什么工具
8. 验收：什么叫完成
9. 失败：做不到时怎么处理
```

---

## 6.5 示例：低质量 vs 高质量

### 低质量 Instruction

```text
你是一个专业 Agent，请帮我创建一个高质量 skill。
```

问题：

| 问题 | 说明 |
|---|---|
| 目标模糊 | 什么叫高质量不清楚 |
| 输入不清 | 读哪些文件不清楚 |
| 流程不清 | 是否要先设计、再实现不清楚 |
| 输出不清 | 交付什么不清楚 |
| 验收不清 | 如何判断完成不清楚 |

### 高质量 Instruction

```text
你是 skill-creator。
目标：根据 PRD 创建一个可触发、可执行、可测试、可迭代的 skill。
流程：
1. 先读取 PRD 和现有仓库结构；
2. 提炼 skill 的触发场景、非触发场景、输入输出；
3. 生成 SKILL.md；
4. 必要时创建 references / assets / scripts / evals；
5. 运行触发测试、输出测试、近似场景测试；
6. 输出 diff、测试结果、风险说明。
约束：
- 不得修改无关文件；
- 不得在测试未通过时宣称完成；
- 不确定时必须列出假设。
验收：
- SKILL.md 结构完整；
- description 可触发但不误触发；
- instruction 可落地；
- 至少有测试样例。
```

---

## 6.6 Instruction Layer 的常见问题

| 问题 | 表现 | 修复方式 |
|---|---|---|
| 规则太抽象 | “高质量”“专业”“完整”不可执行 | 转成检查项 |
| 规则太多但无优先级 | Agent 不知道哪个更重要 | 加优先级和冲突处理 |
| 只有目标没有流程 | Agent 直接跳到输出 | 加流程 gate |
| 只有流程没有验收 | 做完步骤但质量差 | 加 Definition of Done |
| 没有失败处理 | 信息不足时胡编 | 加假设、风险、停止条件 |
| 没有非触发边界 | Skill 容易误调用 | 加 negative examples |
| 没有工具规则 | 工具乱用或不用 | 加工具调用条件 |

---

## 6.7 Instruction 与 Prompt 的区别

| Prompt | Instruction |
|---|---|
| 更偏一次性表达 | 更偏长期行为契约 |
| 可随任务变化 | 应稳定沉淀 |
| 可以是自然语言 | 应尽量结构化、可检查 |
| 解决“怎么回答” | 解决“怎么工作” |
| 用户临时输入也可以是 Prompt | AGENTS.md / SKILL.md 更像 Instruction |

---

## 6.8 Feynman 解释

Instruction Layer 就像给员工的岗位说明书和工作制度。

只说“好好干”，没有意义。  
要说清楚：

```text
你负责什么
不负责什么
先做什么
后做什么
遇到问题怎么处理
什么结果才算合格
```

---

## 6.9 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 写清楚 Agent 行为契约 | 能把“高质量”转成具体规则 |
| 设计触发边界 | 能写正例、反例、近似场景 |
| 设计执行流程 | 能防止 Agent 跳步 |
| 设计输出约束 | 能让结果稳定可复用 |
| 设计失败处理 | 能防止 Agent 胡编和假完成 |

---

# 第 7 章：Context Layer｜上下文工程基础

## 7.1 本章核心

> Context Layer 决定 Agent “看什么”。Agent 的判断质量，很大程度取决于上下文质量。

模型不是凭空工作。  
它需要材料：

```text
用户目标
项目文件
历史决策
业务规则
参考案例
数据表
错误日志
测试结果
设计规范
```

这些材料如何选择、组织、压缩、更新，就是 Context Layer。

---

## 7.2 Context 的类型

| 类型 | 说明 | 例子 |
|---|---|---|
| Task Context | 本次任务目标 | “生成第 5–10 章课程内容” |
| User Context | 用户偏好和长期背景 | 工作语言是中文，喜欢 MECE 表格 |
| Domain Context | 领域知识 | Agent 工程、Skill 结构、亚马逊广告 |
| Project Context | 当前项目资料 | PRD、README、AGENTS.md、目录结构 |
| Historical Context | 历史决策 | 上一轮确认的大纲 |
| Runtime Context | 执行过程信息 | 当前文件、测试结果、错误日志 |
| Retrieved Context | 检索得到的信息 | RAG 搜索结果、网页、文件库 |
| Tool Context | 工具返回结果 | API 响应、命令行输出 |
| Constraint Context | 约束条件 | 禁止英文、输出 .md、不要太长文 |
| Evaluation Context | 质量标准 | rubric、test cases、Definition of Done |

---

## 7.3 上下文不是越多越好

| 上下文问题 | 表现 | 后果 |
|---|---|---|
| 太少 | Agent 缺少关键事实 | 幻觉、误判 |
| 太多 | 材料噪声过大 | 重点丢失 |
| 太旧 | 引用过期资料 | 决策错误 |
| 太碎 | 信息无结构 | 模型难以整合 |
| 冲突 | 多份资料说法不同 | Agent 随机选择 |
| 未标权重 | 不知道哪个更重要 | 低优先级信息覆盖高优先级信息 |
| 未压缩 | 长文直接塞入 | 浪费上下文窗口 |

---

## 7.4 Context Engineering 的核心动作

| 动作 | 目的 | 例子 |
|---|---|---|
| Select | 选择相关上下文 | 只给与当前任务相关的 PRD |
| Rank | 排序优先级 | 用户最新要求 > 历史偏好 > 通用规则 |
| Compress | 压缩信息 | 把长对话提炼成任务 brief |
| Structure | 结构化 | 表格、目录树、schema |
| Cite | 标注来源 | 文件名、行号、链接、时间 |
| Refresh | 更新上下文 | 检索最新资料 |
| Filter | 过滤噪声 | 排除无关历史 |
| Resolve Conflict | 解决冲突 | 用更高优先级来源覆盖低优先级来源 |
| Persist | 持久化 | 写入 wiki、memory、reference |

---

## 7.5 Context Layer 在 Agent 工程中的设计

| 模块 | 设计问题 | 产物 |
|---|---|---|
| Context Source | 上下文从哪里来 | 文件、网页、数据库、记忆、用户输入 |
| Context Policy | 什么信息能进入上下文 | 选择规则、优先级规则 |
| Context Window | 一次塞多少 | 摘要、分块、检索 |
| Context Format | 如何组织 | markdown、json、table、schema |
| Context Freshness | 如何保证新鲜 | 时间戳、检索策略 |
| Context Trust | 如何判断可信度 | 来源等级、引用、验证 |
| Context Update | 如何更新 | 复盘后写入知识库 |
| Context Boundary | 什么不该进入 | 旧信息、冲突信息、敏感信息 |

---

## 7.6 Context 与 RAG 的关系

| 概念 | 说明 |
|---|---|
| Context Engineering | 总体上下文设计方法 |
| RAG | 从外部知识库检索上下文的一种方法 |
| Memory | 保存历史状态的一种上下文来源 |
| File Search | 从文件库找上下文的一种工具 |
| Web Search | 获取最新上下文的一种工具 |
| Manual Context | 用户直接提供的上下文 |

所以：

```text
RAG 只是 Context Layer 的一个子模块。
```

不要把 Context Engineering 简化成 RAG。

---

## 7.7 迁移到你的 llm-wiki

你要做 llm-wiki，本质上就是在建设一个长期 Context Layer。

| llm-wiki 设计 | Context Layer 价值 |
|---|---|
| raw / processed / schema 三层 | 区分原始资料、加工知识、结构规则 |
| 通用知识理解框架 | 让上下文结构统一 |
| 每次对话沉淀 .md | 把临时上下文转成长期上下文 |
| 文件命名规范 | 方便未来检索 |
| 知识卡片互链 | 增强上下文网络 |
| 来源与版本记录 | 提升可信度和可追踪性 |

---

## 7.8 Feynman 解释

模型像一个律师。  
Context 是给律师看的案卷材料。

如果案卷缺关键证据，律师会误判。  
如果案卷塞满无关资料，律师会抓不住重点。  
如果案卷里有过期资料，律师会引用错误依据。

所以，好的 Agent 不是“给模型一堆资料”，而是“给模型正确、干净、结构化、有优先级的资料”。

---

## 7.9 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 区分不同上下文类型 | 能识别 task、user、project、runtime、evaluation context |
| 设计上下文选择规则 | 能判断哪些资料该给模型，哪些不该给 |
| 处理上下文冲突 | 能说明优先级和取舍理由 |
| 把临时上下文沉淀为长期资产 | 能输出 md、reference、schema |
| 不把 RAG 等同于上下文工程 | 能解释 RAG 只是获取上下文的一种方式 |

---

# 第 8 章：Tool Layer｜工具调用与 MCP 基础

## 8.1 本章核心

> Tool Layer 让 Agent 从“只能说”变成“可以做”。

没有工具的模型，只能生成建议。  
有工具的 Agent，可以：

```text
读文件
写文件
查网页
运行代码
调用 API
操作浏览器
查询数据库
创建日历
发送邮件
执行测试
生成图片
```

---

## 8.2 Tool Layer 的本质

Tool Layer 不是“工具越多越好”，而是：

```text
给 Agent 提供有限、明确、可控、可审计的行动接口。
```

工具层解决 4 个问题：

| 问题 | 说明 |
|---|---|
| 能力扩展 | 模型本身不能访问外部系统，工具补上行动能力 |
| 环境连接 | 连接文件系统、浏览器、数据库、API |
| 行动约束 | 控制 Agent 能做什么、不能做什么 |
| 结果反馈 | 工具返回结果，成为下一轮推理上下文 |

---

## 8.3 工具类型

| 类型 | 作用 | 例子 |
|---|---|---|
| Retrieval Tool | 获取信息 | web search、file search、RAG |
| File Tool | 操作文件 | read、write、patch、mkdir |
| Code Tool | 执行代码 | Python、shell、unit test |
| Browser Tool | 操作网页 | open、click、screenshot |
| API Tool | 调用外部服务 | Gmail、Calendar、GitHub |
| Database Tool | 查询结构化数据 | SQL、vector DB |
| Media Tool | 生成或处理媒体 | image generation、PDF render |
| Communication Tool | 对外沟通 | email、chat、ticket |
| Deployment Tool | 构建和发布 | CI/CD、Docker、cloud |
| Evaluation Tool | 检查质量 | test runner、lint、eval scripts |

---

## 8.4 工具设计的核心要素

| 要素 | 说明 | 设计重点 |
|---|---|---|
| Name | 工具名称 | 清晰、可区分 |
| Description | 工具用途 | 说明什么时候用、什么时候不用 |
| Input Schema | 参数结构 | 字段明确、类型明确、必填明确 |
| Output Schema | 返回结构 | 方便 Agent 继续推理 |
| Error Behavior | 失败时怎么返回 | 不要让错误信息模糊 |
| Permission | 权限边界 | 读写分离、高风险审批 |
| Idempotency | 重复调用是否安全 | 防止重复发送、重复删除 |
| Auditability | 是否可审计 | 留日志、留结果 |
| Cost | 成本 | 限制高成本工具滥用 |
| Latency | 延迟 | 长任务要有执行策略 |

---

## 8.5 MCP 在 Tool Layer 中的位置

MCP，即 Model Context Protocol，是一种让 AI 应用连接外部数据源和工具的开放标准。它的价值是把“每个工具单独集成”的碎片化模式，变成更标准化的连接方式。

在 Tool Layer 中，MCP 可以理解为：

```text
Agent 连接外部工具和数据源的一种标准协议层。
```

MCP 的工具机制允许 server 向模型暴露可调用工具，每个工具有名称、描述和 input schema；工具可以让模型查询数据库、调用 API 或执行计算等。官方 MCP 文档也强调，工具调用应关注安全和人类可确认机制，尤其是高风险操作。

---

## 8.6 Tool Use 与 MCP 的区别

| 概念 | 说明 |
|---|---|
| Tool Use | Agent 调用工具的能力或机制 |
| Function Calling | 一种常见工具调用形式 |
| MCP | 标准化连接外部工具和上下文的协议 |
| Tool Registry | 工具清单和元数据 |
| Tool Policy | 工具使用规则和权限 |
| Tool Harness | 围绕工具调用的完整控制系统 |

所以：

```text
MCP 是 Tool Layer 的一种标准化实现方式，
但 Tool Layer 不等于 MCP。
```

---

## 8.7 工具层常见风险

| 风险 | 表现 | 修复方式 |
|---|---|---|
| 工具太多 | Agent 选择困难或误调用 | 工具分组、按任务暴露 |
| 描述不清 | Agent 不知道什么时候用 | 写清用途和反例 |
| 参数不严 | 工具调用失败 | 使用严格 schema |
| 权限过大 | 误删、误发、越权 | 最小权限、审批 |
| 无幂等性 | 重复调用造成副作用 | 加确认、加幂等键 |
| 错误不可读 | Agent 无法修复 | 结构化错误返回 |
| 无日志 | 无法追踪事故 | 记录 tool call trace |
| 无回滚 | 错误动作不可恢复 | 设计 rollback path |

---

## 8.8 迁移到你的 Agent 工程

以 “llm-wiki 知识沉淀 Agent” 为例：

| 工具 | 用途 | 风险控制 |
|---|---|---|
| file search | 找历史资料 | 只读 |
| markdown writer | 生成 .md | 不覆盖原文件 |
| schema checker | 检查结构 | 自动校验 |
| git diff | 查看变更 | 交付前审查 |
| image generator | 生成知识图 | 用户确认风格 |
| export tool | 输出文件 | 文件名规范 |

以 “Skill 创建 Agent” 为例：

| 工具 | 用途 | 风险控制 |
|---|---|---|
| repo reader | 读取项目结构 | 只读优先 |
| file writer | 写 SKILL.md | 限定目录 |
| test runner | 运行 evals | 失败不得宣称完成 |
| git diff | 查看改动 | 输出 review 摘要 |
| changelog writer | 记录版本 | 不删除旧记录 |

---

## 8.9 Feynman 解释

模型像一个会思考的人。  
Tool Layer 像他的手、眼睛、电脑、浏览器、文件柜、电话。

但工具越多，不一定越好。  
如果不给规则，他可能拿错工具、误删文件、重复发邮件。

所以工具层的重点不是“给更多工具”，而是“给正确工具，并控制工具怎么用”。

---

## 8.10 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 区分工具能力和工具治理 | 不只说能调用什么，还能说明如何限制 |
| 设计工具 schema | 能定义 name、description、input、output、error |
| 判断工具风险 | 能识别副作用、权限、幂等性、回滚风险 |
| 理解 MCP 位置 | 能说清 MCP 是标准协议，不是 Harness 全部 |
| 设计工具调用策略 | 能决定何时调用、何时人工确认、何时禁止 |

---

# 第 9 章：State Layer｜文件、记忆、Git、数据库

## 9.1 本章核心

> State Layer 让 Agent 不只是“临时回答”，而是能保存进度、延续任务、复盘历史、沉淀资产。

没有 State，Agent 只能做短任务。  
有 State，Agent 才能做长任务、项目任务、工程任务。

---

## 9.2 State 是什么

State 指 Agent 在任务过程中需要保存和读取的状态信息。

包括：

```text
当前任务进度
已读文件
已做决策
生成文件
测试结果
错误记录
用户偏好
项目版本
历史对话摘要
外部系统状态
```

---

## 9.3 State 的类型

| 类型 | 生命周期 | 例子 |
|---|---|---|
| Ephemeral State | 当前轮临时状态 | 当前工具调用结果 |
| Session State | 当前会话状态 | 本次任务目标、阶段进度 |
| Task State | 单个任务状态 | TODO、已完成项、失败项 |
| Project State | 项目状态 | repo 文件、配置、issue、PR |
| User State | 用户长期偏好 | 工作语言、输出风格、知识库结构 |
| Memory State | 长期记忆 | 稳定偏好、历史决策 |
| External State | 外部系统状态 | Gmail、Calendar、GitHub、数据库 |
| Version State | 版本状态 | commit、diff、changelog |

---

## 9.4 常见 State 载体

| 载体 | 适合保存什么 | 特点 |
|---|---|---|
| 对话上下文 | 当前任务短期信息 | 易丢失、易膨胀 |
| Memory | 稳定长期偏好 | 适合少量高价值信息 |
| 文件系统 | 中间产物、文档、配置 | 可查看、可版本化 |
| Git | 代码和文档变更 | 可 diff、可回滚 |
| 数据库 | 结构化状态 | 可查询、可扩展 |
| Vector DB | 语义检索知识 | 适合相似度召回 |
| Logs / Trace | 执行过程 | 适合调试和审计 |
| Wiki / Obsidian | 结构化知识资产 | 适合长期沉淀 |

---

## 9.5 State Layer 的核心问题

| 问题 | 说明 |
|---|---|
| 保存什么 | 哪些状态值得长期保存 |
| 保存在哪里 | 对话、文件、Git、数据库、memory |
| 保存多久 | 临时、会话、项目、长期 |
| 如何更新 | 覆盖、追加、版本化 |
| 如何读取 | 全量读取、检索、摘要、索引 |
| 如何防污染 | 过期信息、错误信息不能长期影响判断 |
| 如何回滚 | 状态错误时能恢复 |
| 如何审计 | 能知道状态从哪里来、何时改的 |

---

## 9.6 Memory 与 State 的区别

| 概念 | 说明 |
|---|---|
| State | 所有可保存、可读取的任务状态 |
| Memory | State 的一种，通常指长期用户偏好或历史经验 |
| Filesystem | State 的一种，适合保存文档、代码、产物 |
| Git | State 的一种，适合保存版本和变更历史 |
| Database | State 的一种，适合结构化查询 |

所以：

```text
Memory 不等于 State。
State 是更大的概念。
```

---

## 9.7 State Layer 的风险

| 风险 | 表现 | 修复方式 |
|---|---|---|
| 状态缺失 | Agent 忘记做过什么 | 写 progress log |
| 状态污染 | 错误信息被长期记住 | 加验证和过期机制 |
| 状态冲突 | 多处记录不一致 | 定义单一事实源 |
| 状态不可追踪 | 不知道谁改了什么 | Git / changelog |
| 状态不可回滚 | 错误修改无法恢复 | 版本控制 |
| 状态过载 | 什么都保存，检索困难 | 分层保存 |
| 状态泄露 | 敏感信息长期存储 | 权限和脱敏 |

---

## 9.8 迁移到你的 llm-wiki

你的 llm-wiki 可以看作 Agent 的长期 State Layer + Context Layer。

| llm-wiki 元素 | State 作用 |
|---|---|
| raw 原始资料 | 保存未加工来源 |
| processed 加工知识 | 保存理解后的知识资产 |
| schema 结构规则 | 保存知识组织方式 |
| 课程阶段笔记 | 保存学习进度 |
| 方法论图谱 | 保存高层框架 |
| 案例库 | 保存真实应用样例 |
| 版本记录 | 保存知识演化轨迹 |

---

## 9.9 迁移到 Codex / GitHub 工作流

在 Coding Agent 中，Git 是非常重要的 State Layer。

| Git 元素 | State 作用 |
|---|---|
| working tree | 当前工作状态 |
| diff | 改了什么 |
| commit | 保存一个稳定版本 |
| branch | 隔离不同任务 |
| PR | 审查和合并状态 |
| tag / release | 标记可发布版本 |
| revert | 回滚错误变更 |

这也是为什么高质量 coding agent 不应该只“改文件”，还要输出 diff、测试结果和变更摘要。

---

## 9.10 Feynman 解释

没有 State 的 Agent，像一个没有笔记本的人。

你让他做长项目，他每次都靠记忆。  
做着做着就会忘记：

```text
刚才决定了什么
哪个文件改过
哪个测试失败过
哪些方案被否定过
用户偏好是什么
最终版本是哪一个
```

State Layer 就是 Agent 的笔记本、版本库和项目档案。

---

## 9.11 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 区分 Memory 和 State | 能解释 Memory 只是 State 的子集 |
| 设计状态保存策略 | 能决定什么存对话、什么存文件、什么存 Git |
| 防止状态污染 | 能识别过期、错误、冲突状态 |
| 用 Git 理解 Agent 工程 | 能解释 diff、branch、commit、PR 对 Agent 的价值 |
| 把知识库作为 State | 能把 llm-wiki 设计成长期上下文和状态资产 |

---

# 第 10 章：Execution Layer｜运行环境与沙盒

## 10.1 本章核心

> Execution Layer 决定 Agent 在哪里执行任务、能访问什么资源、能产生什么副作用、出错后如何恢复。

如果 Tool Layer 是“能做什么”，  
Execution Layer 是“在哪里做、以什么权限做、出了问题怎么隔离”。

---

## 10.2 Execution Layer 包含什么

| 模块 | 作用 |
|---|---|
| Runtime | Agent 执行循环所在环境 |
| Workspace | 文件和项目的工作目录 |
| Sandbox | 隔离运行环境 |
| Container | 可复现的依赖环境 |
| Dependency Manager | 管理包、库、版本 |
| Command Runner | 执行 shell / test / build |
| Network Policy | 控制网络访问 |
| File Permission | 控制文件读写范围 |
| Secret Manager | 管理密钥和凭证 |
| Snapshot / Restore | 保存和恢复环境状态 |
| Timeout / Resource Limit | 限制时间、内存、计算资源 |

---

## 10.3 为什么 Execution Layer 重要

Agent 一旦能调用工具，就可能产生真实影响：

| 行为 | 风险 |
|---|---|
| 写文件 | 覆盖重要文件 |
| 删除文件 | 数据丢失 |
| 运行命令 | 破坏环境 |
| 安装依赖 | 污染项目 |
| 调用 API | 产生费用或外部动作 |
| 发邮件 | 造成真实沟通后果 |
| 改数据库 | 修改业务数据 |
| 部署服务 | 影响线上系统 |

所以执行环境必须被限制。

---

## 10.4 Sandbox 的作用

Sandbox 是隔离执行环境。

它的目的不是让 Agent 更聪明，而是让 Agent 更安全。

| Sandbox 能力 | 说明 |
|---|---|
| 文件隔离 | 只允许访问指定目录 |
| 网络隔离 | 限制访问外部网络 |
| 权限隔离 | 禁止高危命令 |
| 依赖隔离 | 不污染主环境 |
| 快照恢复 | 出错后恢复到之前状态 |
| 资源限制 | 限制 CPU、内存、时间 |
| 审计记录 | 记录执行动作 |

---

## 10.5 Execution Layer 与 Tool Layer 的区别

| 对比项 | Tool Layer | Execution Layer |
|---|---|---|
| 关注点 | Agent 能调用什么 | 工具在哪里运行 |
| 问题 | 能不能读文件、写代码、调用 API | 是否安全、隔离、可恢复 |
| 典型对象 | web search、file write、shell、API | sandbox、container、workspace、permissions |
| 风险 | 工具误用 | 环境破坏、副作用不可控 |
| 设计重点 | schema、description、permission | 隔离、依赖、资源、回滚 |

---

## 10.6 Execution Layer 的成熟度

| 成熟度 | 特征 | 适用场景 |
|---|---|---|
| L1：无隔离执行 | 直接在当前环境操作 | 低风险临时任务 |
| L2：工作区隔离 | 在指定 folder / repo 操作 | 普通文档和代码任务 |
| L3：沙盒隔离 | 有权限限制、快照、恢复 | coding agent、自动化任务 |
| L4：容器化执行 | 依赖可复现，环境可销毁 | CI、批量测试、复杂工程 |
| L5：生产级执行 | 权限、审计、回滚、监控完整 | 企业级 Agent 系统 |

---

## 10.7 Coding Agent 的执行环境

一个高质量 coding agent 的 Execution Layer 通常需要：

```text
独立工作区
受控文件读写权限
依赖安装规则
测试命令
lint / typecheck 命令
git diff 检查
超时限制
失败日志
回滚策略
```

如果没有这些，就会出现：

| 问题 | 表现 |
|---|---|
| 环境不一致 | 本地能跑，别处不能跑 |
| 测试不可复现 | Agent 说通过，但你这里失败 |
| 改动不可控 | 修改了无关文件 |
| 失败不可定位 | 没有日志 |
| 错误不可恢复 | 没有快照或 Git 状态 |

---

## 10.8 llm-wiki Agent 的执行环境

你的 llm-wiki 沉淀 Agent 也需要 Execution Layer。

| 执行需求 | 设计 |
|---|---|
| 输出 .md 文件 | 指定输出目录 |
| 不覆盖旧文件 | 文件名加版本或日期 |
| 保持格式统一 | 使用模板和 schema |
| 可追踪变更 | Git diff |
| 可回滚 | commit 前审查 |
| 支持图片产物 | assets 目录 |
| 支持多文件拆分 | 按章节或主题生成文件夹 |

---

## 10.9 Execution Layer 常见误区

| 误区 | 为什么错 | 正确理解 |
|---|---|---|
| Agent 不写代码就不需要执行层 | 写文档、发邮件、生成图片也有副作用 | 只要有外部动作，就需要执行控制 |
| 沙盒只是安全功能 | 沙盒也提高可复现性 | 安全 + 复现 + 回滚 |
| 有 Git 就足够安全 | Git 不能防止发邮件、调用 API、泄露密钥 | Git 只管文件版本 |
| 允许所有命令更方便 | 方便但风险高 | 用最小权限 |
| 测试通过就可以部署 | 部署是高风险动作 | 需要审批和回滚 |

---

## 10.10 Feynman 解释

Execution Layer 像给员工安排工作场地。

你不会让新员工直接进入财务系统、生产数据库、公司主仓库随便操作。  
你会给他：

```text
测试环境
临时账号
有限权限
操作记录
审批流程
出错回滚
```

Agent 也是一样。

越能干的 Agent，越需要清晰的执行环境。

---

## 10.11 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 区分 Tool 和 Execution | 能说明工具是能力，执行层是环境 |
| 识别执行风险 | 能指出写文件、发邮件、部署、API 调用的风险 |
| 设计沙盒边界 | 能定义目录、网络、命令、权限限制 |
| 设计可复现环境 | 能用依赖、容器、测试命令保证复现 |
| 设计回滚机制 | 能用 Git、snapshot、backup 降低风险 |

---

# 阶段二总结

## 1. 用一句话总结

> 阶段二的核心是：把 Agent Harness 的基础层拆清楚，知道模型、指令、上下文、工具、状态、执行环境分别负责什么。

---

## 2. 六层关系总图

```text
Agent 基础 Harness
├─ Model Layer：谁来理解和推理
├─ Instruction Layer：按什么规则工作
├─ Context Layer：看什么信息
├─ Tool Layer：能调用什么能力
├─ State Layer：如何保存进度和历史
└─ Execution Layer：在哪里安全运行
```

---

## 3. 六层对比表

| 层 | 解决的问题 | 典型失败 | 关键产物 |
|---|---|---|---|
| Model | 智能从哪里来 | 推理弱、幻觉、误判 | 模型选择、参数策略 |
| Instruction | 如何约束行为 | 跳步、泛化、误触发 | system prompt、AGENTS.md、SKILL.md |
| Context | 看什么材料 | 缺资料、噪声、过期 | context policy、reference pack |
| Tool | 能做什么动作 | 乱调用、参数错、越权 | tool schema、MCP、API |
| State | 如何延续任务 | 忘记、冲突、污染 | files、Git、memory、database |
| Execution | 在哪里运行 | 环境破坏、不可复现 | sandbox、workspace、container |

---

## 4. 阶段二最重要的判断

```text
不要把 Agent 失败简单归因为“模型不够强”。

要按层诊断：

是模型不会？
还是指令不清？
还是上下文不对？
还是工具设计差？
还是状态没保存？
还是执行环境不安全？
```

---

## 5. 阶段二掌握标准

| 能力 | 判断标准 |
|---|---|
| 模块拆解 | 能把一个 Agent 拆成 Model / Instruction / Context / Tool / State / Execution |
| 问题诊断 | 能定位 Agent 失败发生在哪一层 |
| 工程迁移 | 能把这 6 层迁移到 Skill、Codex、llm-wiki、广告分析 Agent |
| 设计意识 | 不再只写 prompt，而是开始设计外部系统 |
| 风险意识 | 能识别工具、状态、执行环境带来的真实副作用 |

---

# 下一阶段预告

## 阶段三：Agent Harness 核心模块｜第 11–18 章

| 章 | 主题 |
|---:|---|
| 11 | 任务入口 Harness：从模糊需求到 task brief |
| 12 | Context Harness：上下文选择、压缩、注入 |
| 13 | Tool Harness：工具清单、参数、错误处理 |
| 14 | Memory Harness：短期记忆与长期记忆 |
| 15 | Filesystem Harness：文件系统作为 Agent 工作台 |
| 16 | Workflow Harness：步骤、状态机、分支 |
| 17 | Feedback Harness：错误捕获与自我修复 |
| 18 | Human-in-the-loop Harness：人工审批与升级 |

---

# 参考资料

- OpenAI Agents SDK 官方文档：Agents 是能计划、调用工具、协作、保持状态以完成多步骤工作的应用；SDK 适合由应用拥有 orchestration、tool execution、state 和 approvals 的场景。
- OpenAI Agents SDK Python 文档：Agent 是配置了 instructions、tools，以及可选 handoffs、guardrails、structured outputs 等运行行为的 LLM。
- Model Context Protocol 官方文档：MCP 标准化应用如何向 LLM 暴露工具和上下文。
- MCP Tools 规范：MCP server 可以暴露可由模型调用的工具，工具包括 name、description、input schema，并建议对工具调用保留 human-in-the-loop 安全机制。
- Anthropic MCP 发布说明：MCP 是连接 AI assistants 与数据源、业务工具、开发环境的开放标准，用于减少碎片化集成。
