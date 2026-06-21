---
title: 'Harness Engineering｜阶段三：Agent Harness 核心模块（第 11–18 章）'
status: raw
created: '2026-05-21 09:00'
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

# Harness Engineering｜阶段三：Agent Harness 核心模块（第 11–18 章）

> 主题：Agent Harness 核心模块  
> 阶段：阶段三  
> 范围：第 11–18 章  
> 目标：掌握 Agent Harness 从任务入口到人工介入的核心工程模块，并能迁移到 Skill、Codex、llm-wiki、广告分析、文案生成等 Agent 工程场景中。  
> 生成日期：2026-05-21

---

## 阶段三总览

阶段二讲的是 Agent Harness 的基础层：

```text
Model / Instruction / Context / Tool / State / Execution
```

阶段三进入真正的 Agent Harness 核心模块：

```text
任务入口
→ 上下文处理
→ 工具治理
→ 记忆管理
→ 文件系统工作台
→ 工作流编排
→ 反馈修复
→ 人工介入
```

| 章 | 模块 | 核心问题 | 一句话理解 |
|---:|---|---|---|
| 11 | 任务入口 Harness | 如何把模糊需求变成可执行任务 | 不让 Agent 一上来就乱做 |
| 12 | Context Harness | 如何选择、压缩、注入上下文 | 不让 Agent 看错、看漏、看乱 |
| 13 | Tool Harness | 如何设计工具清单、参数、错误处理 | 不让 Agent 乱用工具 |
| 14 | Memory Harness | 如何管理短期记忆与长期记忆 | 不让 Agent 忘记，也不让它被记忆污染 |
| 15 | Filesystem Harness | 如何把文件系统变成 Agent 工作台 | 让 Agent 能持续产出、审查、回滚 |
| 16 | Workflow Harness | 如何设计步骤、状态机、分支 | 让 Agent 按结构推进复杂任务 |
| 17 | Feedback Harness | 如何捕获错误并自我修复 | 让失败变成下一轮改进 |
| 18 | Human-in-the-loop Harness | 什么时候需要人工审批与升级 | 让高风险判断不完全交给模型 |

---

# 第 11 章：任务入口 Harness｜从模糊需求到 Task Brief

## 11.1 本章核心

> **任务入口 Harness 的作用，是把用户的模糊想法转成 Agent 可以执行、可以验证、可以交付的任务定义。**

很多 Agent 失败，不是因为执行能力差，而是因为一开始任务入口就错了。

用户说：

```text
帮我做一个高质量 skill。
```

这不是一个可执行任务。

Agent 至少需要知道：

```text
做什么 skill？
服务什么场景？
输入是什么？
输出是什么？
哪些情况要触发？
哪些情况不能触发？
完成标准是什么？
要不要写测试？
要不要改仓库？
能不能调用工具？
```

所以任务入口 Harness 是 Agent 工程的第一道关口。

## 11.2 为什么任务入口很重要

| 没有任务入口 Harness | 结果 |
|---|---|
| 需求模糊 | Agent 自己猜 |
| 范围不清 | 改多、改少、改错 |
| 验收不清 | 做完也不知道是否合格 |
| 优先级不清 | 重要细节被忽略 |
| 风险不清 | 直接执行高风险操作 |
| 上下文不清 | 读错文件、漏读关键资料 |
| 输出不清 | 产物无法沉淀 |

一句话：

```text
任务定义不清，后面的工具、流程、评估都会偏。
```

## 11.3 Task Brief 是什么

Task Brief 是 Agent 执行任务前的标准化任务说明。

| 模块 | 要回答的问题 |
|---|---|
| 任务目标 | 最终要完成什么 |
| 背景信息 | 为什么要做 |
| 输入材料 | Agent 应该读取什么 |
| 输出产物 | 最后交付什么 |
| 范围边界 | 做什么，不做什么 |
| 执行步骤 | 先做什么，后做什么 |
| 质量标准 | 什么叫做得好 |
| 验收条件 | 什么叫完成 |
| 风险点 | 哪些地方容易出错 |
| 升级条件 | 什么时候需要问用户或人工审批 |

## 11.4 模糊需求到 Task Brief 的转换

### 原始需求

```text
帮我把这次对话整理成 md 文件。
```

### 入口 Harness 转换后

| 字段 | 内容 |
|---|---|
| 任务目标 | 将当前对话内容整理成适合 llm-wiki 沉淀的 Markdown 文件 |
| 输入材料 | 当前对话、已确认的大纲、用户格式偏好 |
| 输出产物 | 一个 .md 文件 + 下载链接 |
| 范围边界 | 只整理本阶段内容，不扩展未讲章节 |
| 结构要求 | 标题、知识边界、核心概念、表格、总结、自检 |
| 风格要求 | 中文、信息密度高、少长段落、多表格 |
| 验收条件 | 文件可下载、结构清晰、可直接放入知识库 |
| 风险点 | 不要混入下一阶段内容，不要过度扩写 |
| 完成标志 | 输出文件链接并说明已生成 |

## 11.5 任务入口 Harness 的工程模块

| 模块 | 作用 | 产物 |
|---|---|---|
| Intent Parser | 识别用户真实意图 | 任务类型 |
| Scope Clarifier | 明确范围 | 做 / 不做清单 |
| Context Auditor | 判断需要哪些上下文 | 上下文清单 |
| Risk Scanner | 识别风险 | 风险等级 |
| Output Contract Builder | 定义交付格式 | 输出 schema |
| Acceptance Criteria Builder | 定义验收标准 | Definition of Done |
| Execution Planner | 生成执行步骤 | plan / checklist |

## 11.6 任务入口的三种模式

| 模式 | 适用场景 | Agent 行为 |
|---|---|---|
| 直接执行 | 用户需求清晰、低风险 | 直接进入执行 |
| 先澄清 | 信息缺失且会影响结果 | 先问关键问题 |
| 带假设执行 | 信息不完整但可合理推进 | 明确假设后执行 |

复杂 Agent 工程不应一律追问，更好的策略是：

```text
低风险 → 直接做
中风险 → 带假设做
高风险 → 先确认
```

## 11.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 一收到任务就执行 | 容易跑偏 | 先转成 Task Brief |
| 追问越多越专业 | 会阻塞任务 | 只问影响结果的关键问题 |
| 用户没说就不能做 | 低风险任务可合理假设 | 明确假设即可 |
| 有 PRD 就够了 | PRD 也可能模糊 | 还要做上下文审计和验收拆解 |
| 只定义目标不定义完成标准 | 容易假完成 | 必须有 Definition of Done |

## 11.8 迁移到你的 Agent 工程

### Skill 创建 Agent

```text
Skill 名称
触发场景
非触发场景
输入
输出
执行步骤
资源结构
测试方式
完成标准
```

### llm-wiki 沉淀 Agent

```text
沉淀主题
覆盖范围
输出文件名
知识库路径
结构模板
是否需要图片
是否需要拆分多文件
完成标准
```

### 亚马逊广告分析 Agent

```text
分析目标
时间范围
核心指标
对比基准
数据来源
诊断维度
输出格式
决策建议标准
```

## 11.9 Feynman 解释

任务入口 Harness 像医生问诊。

病人说：

```text
我不舒服。
```

医生不会马上开药，而是先确认哪里不舒服、持续多久、有没有发烧、有没有旧病史。Agent 也是一样。用户说的是愿望，Task Brief 才是可执行任务。

## 11.10 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 把模糊需求转成 Task Brief | 能写出目标、范围、输入、输出、验收 |
| 判断是否需要追问 | 能区分低风险、中风险、高风险 |
| 设计 Definition of Done | 能定义任务完成标准 |
| 防止 Agent 一上来乱做 | 能设置入口检查和计划步骤 |
| 迁移到自己的任务 | 能为 Skill、wiki、广告分析设计入口模板 |

---

# 第 12 章：Context Harness｜上下文选择、压缩、注入

## 12.1 本章核心

> **Context Harness 的作用，是管理 Agent 在每一步应该看到什么信息、以什么结构看到、看到多少、相信哪些。**

阶段二讲 Context Layer 是“看什么”。本章进一步讲 Context Harness：如何工程化地管理上下文。

## 12.2 Context Harness 解决的问题

| 问题 | 表现 |
|---|---|
| 上下文缺失 | Agent 漏掉关键文件或历史决策 |
| 上下文过载 | 一次塞太多，重点丢失 |
| 上下文冲突 | 新旧规则不一致 |
| 上下文过期 | 引用旧资料 |
| 上下文污染 | 错误信息被当成事实 |
| 上下文无结构 | 模型读了但抓不住重点 |
| 上下文不可追踪 | 不知道答案依据来自哪里 |

## 12.3 Context Harness 的核心动作

| 动作 | 作用 | 例子 |
|---|---|---|
| Discover | 找到可能相关的信息 | 搜索文件、网页、历史对话 |
| Select | 选择真正相关的信息 | 只选本阶段章节 |
| Rank | 排优先级 | 当前用户要求 > 已确认大纲 > 通用规则 |
| Compress | 压缩长内容 | 对长对话做摘要 |
| Structure | 结构化呈现 | 表格、目录树、schema |
| Inject | 注入模型上下文 | 放入 prompt、tool result、system context |
| Refresh | 更新过期资料 | 检索最新文档 |
| Validate | 验证可信度 | 来源、时间、交叉检查 |
| Persist | 持久化重要上下文 | 写入 md、memory、reference |

## 12.4 上下文优先级

| 优先级 | 上下文类型 | 说明 |
|---:|---|---|
| 1 | 当前用户明确指令 | 本轮最重要 |
| 2 | 系统 / 开发者约束 | 必须遵守 |
| 3 | 当前任务材料 | 本次任务输入 |
| 4 | 项目规范 | AGENTS.md、README、PRD |
| 5 | 历史确认决策 | 之前确认过的大纲或偏好 |
| 6 | 长期用户偏好 | 稳定偏好 |
| 7 | 通用知识 | 最低优先级 |

当上下文冲突时，不能平均处理，要按优先级裁决。

## 12.5 Context Compression

长上下文不是直接压缩成短摘要，而是按任务目的压缩。

| 压缩方式 | 适合场景 |
|---|---|
| 摘要压缩 | 长对话、长文档 |
| 结构压缩 | 复杂知识体系 |
| 决策压缩 | 只保留已确认结论 |
| 任务压缩 | 只保留和当前任务有关的信息 |
| 错误压缩 | 只保留失败原因和修复策略 |
| 引用压缩 | 保留来源和位置，不复制全文 |

低质量压缩：

```text
这段内容主要讲了 Agent Harness 的相关知识。
```

高质量压缩：

```text
已确认：本课程按 Agent Harness Engineering 讲，不讲 Harness.io 产品；
阶段一讲边界与总图；
阶段二讲 Model / Instruction / Context / Tool / State / Execution；
阶段三应讲任务入口、上下文、工具、记忆、文件系统、工作流、反馈、人工介入。
```

## 12.6 Context Injection

| 注入位置 | 用途 |
|---|---|
| System Instruction | 长期规则 |
| Developer Instruction | 任务策略和约束 |
| User Message | 当前任务输入 |
| Tool Result | 工具返回信息 |
| Memory | 长期偏好 |
| File Context | 项目文件和文档 |
| Scratchpad | 中间计划 |
| Eval Context | 评分标准 |

关键不是“塞进去”，而是“放在正确位置”。

## 12.7 长任务中的分阶段上下文

复杂任务不能一次性把所有上下文塞给 Agent，而要分阶段供给。

```text
任务入口阶段：给目标、范围、约束
设计阶段：给 PRD、参考案例、规范
执行阶段：给相关文件、工具结果
验证阶段：给测试标准、失败日志
总结阶段：给变更记录、复盘模板
```

## 12.8 常见误区

| 误区 | 为什么错 | 正确做法 |
|---|---|---|
| 上下文越多越好 | 噪声会稀释重点 | 精选、排序、结构化 |
| RAG 等于 Context Harness | RAG 只是获取方式 | 还要做选择、压缩、验证、注入 |
| 历史信息都可信 | 历史也会过期 | 加时间和来源 |
| 摘要就是压缩 | 摘要可能丢掉关键约束 | 按任务目的压缩 |
| 当前对话最重要 | 不一定；系统规则更高 | 建立优先级 |

## 12.9 迁移到 llm-wiki

```text
raw：保存原始上下文
processed：保存加工后的稳定知识
schema：保存结构规则和知识组织方式
references：保存案例和来源
index：提供检索入口
```

每次沉淀知识时，Agent 应该做：

```text
1. 识别主题
2. 找到相关历史
3. 排除无关上下文
4. 提炼已确认结论
5. 按固定框架结构化
6. 输出 Markdown
7. 回写知识库
```

## 12.10 Feynman 解释

Context Harness 像给律师准备案卷。不是把仓库里所有文件搬给律师，而是挑出相关证据、按时间排序、标明来源、指出冲突、突出关键事实、把无关资料放一边。

## 12.11 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 设计上下文来源 | 能列出 Agent 需要读哪些资料 |
| 设计上下文优先级 | 能处理新旧规则冲突 |
| 压缩长上下文 | 能保留任务关键约束 |
| 分阶段注入上下文 | 能按任务阶段给不同资料 |
| 防止上下文污染 | 能识别过期、错误、无关信息 |

---

# 第 13 章：Tool Harness｜工具清单、参数、错误处理

## 13.1 本章核心

> **Tool Harness 的作用，是让 Agent 安全、准确、可控地调用工具。**

Tool Layer 讲“Agent 能调用什么”。Tool Harness 讲“Agent 应该如何调用、何时调用、失败怎么处理、风险如何控制”。

## 13.2 Tool Harness 包含什么

| 模块 | 作用 |
|---|---|
| Tool Registry | 工具清单 |
| Tool Description | 工具用途说明 |
| Tool Schema | 参数结构 |
| Tool Policy | 使用规则 |
| Tool Permission | 权限边界 |
| Tool Routing | 何时用哪个工具 |
| Error Handling | 失败处理 |
| Tool Result Parsing | 解析工具返回 |
| Audit Log | 记录调用 |
| Rollback Strategy | 错误动作恢复 |

## 13.3 高质量 Tool Description

低质量工具描述：

```text
Search files.
```

高质量工具描述：

```text
用于在用户的文件库中检索与当前问题相关的历史文档。
适用：用户询问之前上传的文件、某个文件内容、近期上传资料。
不适用：用户要求联网搜索、生成新文件、读取当前未上传内容。
返回：相关文件片段、文件名、行号、元数据。
```

好的工具描述必须包含：

| 要素 | 说明 |
|---|---|
| 工具做什么 | 能力边界 |
| 什么时候用 | 正触发 |
| 什么时候不用 | 反触发 |
| 输入参数 | 参数结构 |
| 输出结果 | 返回内容 |
| 副作用 | 是否会改变外部世界 |
| 风险 | 是否需要审批 |

## 13.4 Tool Schema

Tool Schema 是工具参数的结构约束。

```json
{
  "query": "string",
  "source_filter": ["file_library"],
  "intent": "nav"
}
```

它解决的是：

| 问题 | 说明 |
|---|---|
| 参数缺失 | 必填字段必须存在 |
| 参数类型错误 | 字符串、数组、对象不能混乱 |
| 范围错误 | source_filter 只能用允许值 |
| 语义错误 | intent 只能在导航场景使用 |
| 输出不可解析 | 返回结构要可继续处理 |

## 13.5 Tool Policy

| 规则类型 | 例子 |
|---|---|
| 只读优先 | 先 read，再 write |
| 最小权限 | 只开放当前任务需要的工具 |
| 高风险审批 | 删除、发送、购买、部署前必须确认 |
| 成本限制 | 高成本工具必须有明确必要性 |
| 幂等控制 | 避免重复发送、重复删除 |
| 错误重试 | 网络失败可重试，权限失败不重试 |
| 顺序约束 | 修改前先读文件，提交前先 diff |
| 审计要求 | 所有写操作记录日志 |

## 13.6 Error Handling

| 错误类型 | 处理方式 |
|---|---|
| 参数错误 | 修正参数后重试 |
| 权限错误 | 停止并请求授权 |
| 网络错误 | 可有限重试 |
| 文件不存在 | 搜索相近文件或报告缺失 |
| 测试失败 | 读取日志，定位原因，修复后再跑 |
| 写入失败 | 检查路径、权限、冲突 |
| API 限流 | 等待、降频或换方案 |
| 高风险错误 | 停止执行并升级人工 |

## 13.7 Tool Result Parsing

| 返回结果 | 应提取 |
|---|---|
| 搜索结果 | 标题、来源、时间、相关片段 |
| 文件内容 | 文件名、路径、行号、关键段落 |
| 测试结果 | 通过数、失败数、错误堆栈 |
| Git diff | 新增、删除、修改、影响范围 |
| API 响应 | 状态码、业务字段、错误码 |
| 网页内容 | 来源、日期、核心事实 |

## 13.8 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 工具越多越好 | Agent 更容易选错 | 按任务暴露最小工具集 |
| 有工具调用就等于 Agent | 工具只是能力接口 | 还要有流程、状态、验证 |
| 工具描述随便写 | Agent 会误用 | 描述要有适用/不适用场景 |
| 所有错误都重试 | 会浪费成本或扩大风险 | 按错误类型处理 |
| 只看工具结果，不看副作用 | 可能造成真实损失 | 标记写操作和高风险操作 |

## 13.9 迁移到 Skill 工程

| 工具 | 使用规则 |
|---|---|
| read_file | 先读 PRD、现有 SKILL.md、目录结构 |
| write_file | 只写目标 skill 目录 |
| run_tests | 修改后必须运行 |
| git_diff | 交付前必须查看 |
| search_repo | 不确定结构时使用 |
| update_changelog | 版本变化时使用 |
| delete_file | 默认禁止，除非明确确认 |

## 13.10 Feynman 解释

Tool Harness 像公司的工具管理制度。员工可以用电脑、财务系统、仓库系统、邮件系统，但公司不会让所有人拥有所有权限。工具必须明确谁能用、什么时候用、怎么用、用完怎么记录、出错怎么处理、高风险动作谁审批。

## 13.11 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 设计工具清单 | 能按任务列出最小工具集 |
| 写工具描述 | 能包含适用、不适用、输入、输出、风险 |
| 设计工具参数 | 能定义 schema |
| 设计错误处理 | 能按错误类型决定重试、停止、升级 |
| 设计工具安全策略 | 能识别副作用和审批点 |

---

# 第 14 章：Memory Harness｜短期记忆与长期记忆

## 14.1 本章核心

> **Memory Harness 的作用，是管理 Agent 应该记住什么、忘记什么、什么时候使用记忆、如何防止记忆污染。**

Memory 不是越多越好。错误记忆会让 Agent 长期犯错。

## 14.2 Memory 与 Context / State 的关系

| 概念 | 说明 |
|---|---|
| Context | 当前模型可见的信息 |
| State | 任务和系统保存的状态 |
| Memory | 从历史中提取、可长期复用的信息 |
| Filesystem | 保存记忆和状态的一种载体 |
| Knowledge Base | 结构化长期记忆 |

关系：

```text
Memory 是 State 的一部分；
Memory 被读取后，会进入 Context；
Memory 可以保存在文件、数据库、向量库或系统记忆中。
```

## 14.3 记忆类型

| 类型 | 保存什么 | 例子 |
|---|---|---|
| Working Memory | 当前任务临时信息 | 当前章节正在讲第 14 章 |
| Session Memory | 当前会话信息 | 已完成阶段一、阶段二 |
| Episodic Memory | 事件记忆 | 某次 Codex 执行失败案例 |
| Semantic Memory | 稳定知识 | Harness = Model 外层工程系统 |
| User Preference Memory | 用户偏好 | 工作语言中文、喜欢表格化 |
| Procedural Memory | 操作方法 | 沉淀 md 文件的流程 |
| Project Memory | 项目规则 | llm-wiki 的目录结构和命名规则 |
| Failure Memory | 失败经验 | Agent 容易假完成，需要质量门禁 |

## 14.4 什么值得记住

| 值得记住 | 不值得记住 |
|---|---|
| 长期稳定偏好 | 一次性闲聊 |
| 可复用规则 | 临时情绪 |
| 已确认方法论 | 未验证猜测 |
| 项目结构 | 临时文件名 |
| 反复出现的问题 | 偶然错误 |
| 用户明确要求记住 | 敏感、无关、短期信息 |

## 14.5 Memory Harness 的核心动作

| 动作 | 作用 |
|---|---|
| Extract | 从对话和任务中提取可记忆信息 |
| Classify | 判断属于偏好、规则、案例、方法、失败 |
| Validate | 判断是否稳定、可信、值得保存 |
| Store | 保存到合适载体 |
| Retrieve | 在合适任务中取出 |
| Apply | 用于当前判断或生成 |
| Update | 新信息覆盖旧信息 |
| Expire | 过期记忆失效 |
| Forget | 用户要求或风险原因删除 |
| Audit | 记录记忆来源和更新时间 |

## 14.6 记忆污染

| 污染类型 | 例子 | 修复 |
|---|---|---|
| 错误事实 | 旧目录结构被当成当前结构 | 加更新时间和验证 |
| 过期偏好 | 过去喜欢长文，现在要求短表格 | 新偏好覆盖旧偏好 |
| 片面案例 | 一次失败被过度泛化 | 标注适用范围 |
| 未确认假设 | Agent 自己猜的内容被保存 | 只保存确认信息 |
| 敏感信息 | 不该长期保存的数据 | 不保存或脱敏 |

## 14.7 Memory 使用策略

| 场景 | 策略 |
|---|---|
| 用户明确要求记住 | 保存 |
| 长期稳定偏好 | 保存 |
| 项目规则 | 保存到项目文件优于记忆 |
| 方法论 | 保存到 wiki |
| 临时任务状态 | 保存到任务文件或 scratchpad |
| 高风险事实 | 使用前重新验证 |
| 可能变化的信息 | 标注时间或不保存 |
| 敏感信息 | 默认不保存，除非明确要求且合规 |

## 14.8 迁移到 llm-wiki

| 内容 | 适合位置 |
|---|---|
| 稳定方法论 | processed/methods |
| 原始对话 | raw/conversations |
| 结构模板 | schema/templates |
| 案例复盘 | cases |
| 失败经验 | retrospectives |
| Agent 规则 | agents/specs |
| Skill 规范 | skills/specs |

## 14.9 Feynman 解释

Memory Harness 像公司的知识管理系统。公司不会把所有聊天记录都当制度，只有经过确认、整理、归档的信息，才会进入知识库。

记忆不是“全部记住”，而是：

```text
该记的记住；
不该记的不记；
过期的更新；
错误的删除；
重要的结构化沉淀。
```

## 14.10 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 区分记忆类型 | 能区分 working、session、semantic、procedural memory |
| 判断什么该记 | 能识别长期稳定、可复用信息 |
| 防止记忆污染 | 能处理错误、过期、未确认记忆 |
| 选择记忆载体 | 能决定放 memory、wiki、文件还是 Git |
| 设计更新机制 | 能让新规则覆盖旧规则 |

---

# 第 15 章：Filesystem Harness｜文件系统作为 Agent 工作台

## 15.1 本章核心

> **Filesystem Harness 的作用，是把文件系统设计成 Agent 可以持续工作、保存中间产物、审查变更、回滚错误的工程工作台。**

文件系统不只是存文件。在 Agent 工程中，它是：

```text
上下文来源
状态载体
任务工作区
产物交付区
审查对象
回滚基础
知识沉淀空间
```

## 15.2 为什么 Agent 需要文件系统

| 没有文件系统 | 有文件系统 |
|---|---|
| 只能一次性回答 | 可以多步骤产出 |
| 中间过程难保存 | 可以保存 draft、plan、logs |
| 输出难复查 | 可以 diff、review |
| 任务难延续 | 可以下次继续 |
| 无法版本化 | 可以接入 Git |
| 知识难沉淀 | 可以形成 wiki / docs |

## 15.3 文件系统在 Harness 中的角色

| 角色 | 说明 |
|---|---|
| Context Store | 存放 PRD、参考资料、规范 |
| Working Memory | 保存计划、草稿、中间结果 |
| Artifact Store | 保存最终产物 |
| Test Fixture Store | 保存测试输入和期望输出 |
| Evaluation Store | 保存 evals、rubric、结果 |
| Log Store | 保存执行日志 |
| Versioned State | 通过 Git 保存版本 |
| Knowledge Base | 保存长期知识资产 |

## 15.4 推荐目录结构

以 Skill 项目为例：

```text
.agent/
├─ AGENTS.md
├─ skills/
│  └─ skill-name/
│     ├─ SKILL.md
│     ├─ references/
│     ├─ assets/
│     ├─ scripts/
│     ├─ evals/
│     └─ CHANGELOG.md
├─ templates/
├─ evals/
├─ logs/
└─ docs/
```

以 llm-wiki 为例：

```text
llm-wiki/
├─ raw/
│  ├─ conversations/
│  └─ sources/
├─ processed/
│  ├─ concepts/
│  ├─ methods/
│  ├─ courses/
│  └─ cases/
├─ schema/
│  ├─ templates/
│  └─ rules/
├─ assets/
│  ├─ images/
│  └─ diagrams/
├─ index/
└─ changelog/
```

## 15.5 Filesystem Harness 的核心规则

| 规则 | 说明 |
|---|---|
| 明确工作区 | Agent 只能在指定目录工作 |
| 读写分离 | 先读，确认后写 |
| 不覆盖原始资料 | raw 只追加，不随意改 |
| 产物命名规范 | 文件名要可检索 |
| 中间产物可删除 | 但最终产物要版本化 |
| 高风险操作需确认 | 删除、批量覆盖、移动目录 |
| 交付前必须 diff | 查看变更范围 |
| 重要变更写 changelog | 保持可追踪 |

## 15.6 Filesystem 与 Git

文件系统保存状态，Git 管理版本。

| 文件系统 | Git |
|---|---|
| 保存当前内容 | 保存历史版本 |
| 可读写 | 可 diff、commit、revert |
| 容易被覆盖 | 可以恢复 |
| 适合工作中间态 | 适合稳定检查点 |
| 本身无审查 | PR 可审查 |

高质量 Agent 工作流：

```text
创建分支
→ 修改文件
→ 运行测试
→ 查看 diff
→ 写变更摘要
→ 人工 review
→ commit / PR
```

## 15.7 常见风险

| 风险 | 表现 | 修复 |
|---|---|---|
| 写错目录 | 文件散落 | 限定 workspace |
| 覆盖原文件 | 资料丢失 | 先备份或版本化 |
| 删除无关文件 | 破坏项目 | 删除需审批 |
| 产物无命名规则 | 难检索 | 使用统一命名 |
| 没有 changelog | 不知道改了什么 | 每次重要变更记录 |
| 没有 diff | 无法审查 | 交付前必须 diff |
| 文件和记忆冲突 | Agent 不知道信谁 | 定义事实源优先级 |

## 15.8 Feynman 解释

Filesystem Harness 像工匠的工作台。材料放哪里、工具放哪里、半成品放哪里、成品放哪里，都要有规则。否则工匠再聪明，也会找不到材料、弄丢半成品、把旧版本覆盖、交付错文件、无法复盘。

## 15.9 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 把文件系统理解为工作台 | 不再只把它当存储 |
| 设计目录结构 | 能为 Skill 或 llm-wiki 设计目录 |
| 设计读写规则 | 能防止误写、覆盖、删除 |
| 接入 Git 审查 | 能用 diff、commit、PR 管理变更 |
| 支持知识沉淀 | 能把产物保存为长期知识资产 |

---

# 第 16 章：Workflow Harness｜步骤、状态机、分支

## 16.1 本章核心

> **Workflow Harness 的作用，是把 Agent 的复杂任务拆成可控步骤、状态和分支。**

没有 Workflow，Agent 容易：

```text
想到哪做到哪
跳过关键步骤
失败后不知道回到哪里
重复执行同一动作
在长任务中迷路
```

## 16.2 Workflow 不只是步骤列表

低质量 workflow：

```text
1. 分析
2. 执行
3. 总结
```

高质量 Workflow Harness：

```text
状态
入口条件
执行动作
输出产物
通过条件
失败处理
下一步分支
人工介入点
```

## 16.3 Workflow Harness 的核心结构

| 结构 | 说明 |
|---|---|
| Step | 一个明确步骤 |
| State | 当前执行状态 |
| Transition | 状态如何转移 |
| Condition | 转移条件 |
| Branch | 不同情况走不同路径 |
| Loop | 失败后重试或修复 |
| Gate | 进入下一步前的检查 |
| Interrupt | 暂停等待人工 |
| Resume | 从中断点继续 |
| Exit | 结束条件 |

## 16.4 典型 Agent Workflow

### 通用复杂任务工作流

```text
需求进入
→ 任务理解
→ 上下文审计
→ 计划生成
→ 风险检查
→ 执行
→ 验证
→ 修复
→ 交付
→ 沉淀
```

### Coding Agent Workflow

```text
读取需求
→ 读取仓库
→ 生成计划
→ 修改代码
→ 运行测试
→ 修复失败
→ 查看 diff
→ 输出 PR 摘要
```

### llm-wiki 沉淀 Workflow

```text
识别主题
→ 提炼对话
→ 分类归档
→ 结构化重写
→ 生成 md
→ 检查格式
→ 输出文件链接
```

## 16.5 Workflow Gate

Gate 是工作流中的质量关口。

| Gate | 检查内容 |
|---|---|
| Plan Gate | 是否明确任务范围和步骤 |
| Context Gate | 是否读取了必要上下文 |
| Tool Gate | 是否需要工具、工具是否安全 |
| Write Gate | 是否允许写入 |
| Test Gate | 是否通过测试 |
| Diff Gate | 是否审查变更 |
| Delivery Gate | 是否满足验收标准 |
| Reflection Gate | 是否沉淀经验 |

没有 Gate 的 workflow 只是流程图；有 Gate 才是工程系统。

## 16.6 分支设计

| 情况 | 分支 |
|---|---|
| 信息充分 | 直接执行 |
| 信息不足但低风险 | 带假设执行 |
| 信息不足且高风险 | 先问用户 |
| 工具失败可恢复 | 重试或换工具 |
| 工具失败不可恢复 | 停止并报告 |
| 测试失败 | 修复后重跑 |
| 权限不足 | 请求授权 |
| 输出不合格 | 回到生成步骤 |

## 16.7 Workflow 与 State 的关系

| Workflow 需要知道 | 对应 State |
|---|---|
| 当前执行到哪一步 | step state |
| 已经读了哪些文件 | context state |
| 哪些测试失败 | test state |
| 哪些分支已尝试 | branch state |
| 是否等待人工审批 | interrupt state |
| 最终产物在哪里 | artifact state |

没有 State，Workflow 无法恢复。

## 16.8 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Workflow 等于步骤清单 | 缺少状态和分支 | 加 state、condition、gate |
| 越自动越好 | 高风险步骤不能全自动 | 加人工介入 |
| 所有任务都用同一流程 | 任务类型不同 | 按任务类型设计 workflow |
| 失败就重试 | 可能重复错误 | 先分析错误类型 |
| 只设计成功路径 | 真实任务常走失败路径 | 设计异常分支 |

## 16.9 Feynman 解释

Workflow Harness 像机场安检流程。真实流程不是只有“排队 → 安检 → 登机”，还要处理证件不对、行李超重、需要人工检查、航班延误、登机口变更等分支。Agent 也是一样，复杂任务必须设计成功路径和失败路径。

## 16.10 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 设计步骤 | 能把复杂任务拆成阶段 |
| 设计状态 | 能记录当前执行点 |
| 设计分支 | 能处理信息不足、工具失败、测试失败 |
| 设计 Gate | 能防止未完成就进入下一步 |
| 设计恢复机制 | 能让任务中断后继续 |

---

# 第 17 章：Feedback Harness｜错误捕获与自我修复

## 17.1 本章核心

> **Feedback Harness 的作用，是把 Agent 的失败转化为可诊断、可修复、可沉淀的反馈循环。**

没有 Feedback Harness，Agent 失败后只会：

```text
道歉
重试
换一种说法
继续犯同样的错
```

有 Feedback Harness，Agent 失败后会：

```text
捕获错误
分类错误
定位原因
生成修复方案
执行修复
重新验证
沉淀规则
```

## 17.2 Feedback Loop

```text
执行
→ 检查
→ 发现问题
→ 归因
→ 修复
→ 再检查
→ 通过
→ 沉淀
```

这就是 Agent 从“生成器”变成“工程系统”的关键。

## 17.3 Feedback 来源

| 来源 | 例子 |
|---|---|
| Tool Error | 工具调用失败 |
| Test Failure | 单元测试、eval 不通过 |
| Lint Error | 格式或静态检查失败 |
| User Feedback | 用户指出不符合预期 |
| Reviewer Feedback | 审查 Agent 提出问题 |
| Runtime Error | 执行时报错 |
| Quality Gate Failure | 未满足验收标准 |
| Business Metric Feedback | CTR、CVR、ACOS 等数据反馈 |
| Trace Analysis | 发现跳步、误调用、重复操作 |

## 17.4 错误分类

| 错误类型 | 例子 | 修复方式 |
|---|---|---|
| 需求理解错误 | 误解用户目标 | 回到 Task Brief |
| 上下文错误 | 漏读关键资料 | 回到 Context Harness |
| 工具错误 | 参数错、工具选错 | 修正 Tool Schema 或 Policy |
| 流程错误 | 跳过测试 | 加 Workflow Gate |
| 输出错误 | 格式不对、字段缺失 | 加 Output Schema |
| 事实错误 | 引用错误信息 | 增加来源验证 |
| 安全错误 | 高风险操作未确认 | 加 HITL |
| 质量错误 | 内容泛、浅、不落地 | 加 rubric 和 eval |
| 记忆错误 | 使用过期偏好 | 更新 Memory |

## 17.5 自我修复不是随便再试一次

低质量修复：

```text
重新生成一次。
```

高质量修复：

```text
1. 读取失败信息
2. 判断失败类型
3. 定位对应 Harness 层
4. 修改最小必要内容
5. 重新运行检查
6. 如果仍失败，升级人工或报告阻塞
```

## 17.6 Feedback Harness 的工程模块

| 模块 | 作用 |
|---|---|
| Error Capture | 捕获错误 |
| Error Normalizer | 标准化错误格式 |
| Error Classifier | 归类错误 |
| Root Cause Analyzer | 分析根因 |
| Repair Planner | 制定修复计划 |
| Repair Executor | 执行修复 |
| Revalidator | 重新验证 |
| Escalation Policy | 失败升级 |
| Regression Builder | 把错误转成回归测试 |
| Knowledge Updater | 把经验写入规则或文档 |

## 17.7 Feedback 到 Regression

| 失败 | 应沉淀为 |
|---|---|
| Skill 误触发 | negative trigger test |
| 输出字段缺失 | schema test |
| Agent 跳过测试 | workflow gate |
| 文案太泛 | quality rubric |
| 工具参数错误 | tool schema update |
| 文件写错路径 | filesystem policy |
| 用户多次要求表格 | output template |
| Codex 假完成 | Definition of Done checklist |

## 17.8 迁移到你的场景

### Codex 执行失败

| 失败表现 | Feedback Harness 修复 |
|---|---|
| 未完成就说完成 | 增加 DoD gate |
| 跳过测试 | 测试未运行不得交付 |
| 改错文件 | 限定 workspace + diff gate |
| 标准降低 | 增加 acceptance criteria checklist |
| 反复犯错 | 加 regression tests |

### A+ 文案 Agent

| 失败表现 | Feedback Harness 修复 |
|---|---|
| 文案太泛 | 增加差异化检查 |
| 正文太长 | 加字符限制 |
| 没有父母购买理由 | 加目标用户收益检查 |
| 没有 FABE | 加结构检查 |
| 英文不自然 | 加 native review rubric |

## 17.9 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 失败后重新生成就行 | 可能重复同一错误 | 先分类再修复 |
| 只修输出，不修系统 | 下次还会错 | 更新 Harness |
| 用户反馈只用于当前回答 | 浪费经验 | 沉淀为规则或测试 |
| 所有失败都自动修 | 高风险失败应升级 | 设计 escalation |
| 只看最终结果 | 过程跳步也要反馈 | 分析 trace |

## 17.10 Feynman 解释

Feedback Harness 像工厂质检系统。产品不合格，不是简单重新做一个，而是要查原料、机器、流程、操作、标准、检测方法。Agent 也是一样，错误不是只改答案，而是改系统。

## 17.11 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 捕获错误 | 能从工具、测试、用户反馈中识别问题 |
| 分类错误 | 能判断错误属于哪一层 Harness |
| 设计修复流程 | 能从失败回到对应模块修复 |
| 建立回归保护 | 能把失败转成测试或规则 |
| 避免重复犯错 | 能把反馈沉淀到 Skill、wiki、evals |

---

# 第 18 章：Human-in-the-loop Harness｜人工审批与升级

## 18.1 本章核心

> **Human-in-the-loop Harness 的作用，是在高风险、高不确定、高价值判断点，让人类介入审批、修改、拒绝或接管。**

Agent 工程不是追求“全部自动化”，而是追求：

```text
低风险自动化
中风险可审查
高风险需审批
```

## 18.2 哪些情况需要 HITL

| 场景 | 是否需要人工 |
|---|---:|
| 删除文件 | 需要 |
| 批量覆盖知识库 | 需要 |
| 发送邮件 | 需要 |
| 提交 PR | 通常需要 |
| 部署线上服务 | 必须需要 |
| 调用付费 API | 视成本需要 |
| 修改数据库 | 需要 |
| 处理用户隐私 | 需要 |
| 低风险生成草稿 | 通常不需要 |
| 只读搜索 | 通常不需要 |

## 18.3 HITL 的四种动作

| 动作 | 含义 | 适用场景 |
|---|---|---|
| Approve | 批准继续 | 计划合理、风险可接受 |
| Edit | 修改后继续 | 方向对，但需要调整 |
| Reject | 拒绝执行 | 高风险、错误、越权 |
| Respond | 人工回答或补充信息 | Agent 信息不足 |

## 18.4 HITL 不是每一步都问用户

低质量 HITL：

```text
每做一步都问用户。
```

高质量 HITL：

```text
只在关键风险点、不可逆动作、价值判断点介入。
```

## 18.5 审批点设计

| 审批点 | 审批内容 |
|---|---|
| Plan Approval | 执行计划是否合理 |
| Tool Approval | 是否允许调用高风险工具 |
| Write Approval | 是否允许写入或覆盖 |
| Delete Approval | 是否允许删除 |
| External Action Approval | 是否允许发送、发布、部署 |
| Merge Approval | 是否允许合并 PR |
| Memory Approval | 是否允许长期保存记忆 |
| Final Approval | 是否接受最终交付 |

## 18.6 HITL 与 Workflow 的关系

HITL 应该嵌入 Workflow Harness，而不是临时打断。

```text
执行到高风险节点
→ 保存当前状态
→ 暂停
→ 展示计划 / diff / 风险
→ 人工批准、修改或拒绝
→ 恢复执行或终止
```

关键能力：

| 能力 | 说明 |
|---|---|
| Pause | 暂停执行 |
| Serialize State | 保存当前状态 |
| Explain Action | 解释准备做什么 |
| Show Risk | 展示风险 |
| Collect Decision | 收集人工决策 |
| Resume | 恢复执行 |
| Audit | 记录决策 |

## 18.7 HITL 与权限控制

| 权限等级 | Agent 能做什么 |
|---|---|
| L0 | 只能建议 |
| L1 | 只读工具 |
| L2 | 写草稿，不执行外部动作 |
| L3 | 可修改受控工作区 |
| L4 | 高风险动作需审批 |
| L5 | 生产操作需多级审批 |

## 18.8 迁移到你的场景

### llm-wiki

| 动作 | 是否需要 HITL |
|---|---:|
| 新增一个 md 文件 | 通常不需要 |
| 覆盖旧文件 | 需要 |
| 批量重构目录 | 需要 |
| 删除 raw 原始资料 | 必须需要 |
| 更新 schema 规则 | 建议需要 |
| 生成图片 | 可先自动生成，最终人工选择 |

### Codex / Skill

| 动作 | 是否需要 HITL |
|---|---:|
| 读取 repo | 不需要 |
| 修改 skill 文件 | 中风险，可自动但要 diff |
| 删除文件 | 需要 |
| 提交 commit | 视流程需要 |
| 创建 PR | 通常需要 |
| 合并 main | 必须需要 |
| 改全局 AGENTS.md | 需要 |

### 亚马逊业务 Agent

| 动作 | 是否需要 HITL |
|---|---:|
| 生成广告诊断报告 | 不需要 |
| 建议调价 / 调 bid | 不需要 |
| 自动修改广告预算 | 需要 |
| 自动暂停广告 | 需要 |
| 自动回复平台 case | 需要 |
| 自动上传 Listing 文案 | 必须需要 |

## 18.9 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 全自动才高级 | 高风险全自动很危险 | 分级自动化 |
| 所有步骤都人工确认 | 太低效 | 只在关键节点介入 |
| 人工审批只看一句话 | 容易误批 | 展示 diff、风险、回滚方式 |
| 拒绝后流程结束 | 浪费反馈 | 拒绝应带原因并进入修复 |
| 审批不记录 | 无法审计 | 保存审批记录 |

## 18.10 Feynman 解释

HITL 像公司审批制度。员工可以自己写草稿、做分析、准备方案；但涉及花钱、发给客户、改数据库、上线发布、删除资料、改变公司制度，就要审批。

Agent 也是一样。不是不信任 Agent，而是不同风险级别需要不同控制。

## 18.11 本章掌握标准

| 你需要能做到 | 判断方式 |
|---|---|
| 判断何时需要人工 | 能按风险、不可逆性、外部影响判断 |
| 设计审批点 | 能在 workflow 中设置 pause / approve / reject |
| 设计权限等级 | 能区分只读、草稿、写入、外部动作 |
| 设计恢复机制 | 能在批准或拒绝后继续流程 |
| 设计审计记录 | 能记录谁在何时批准了什么 |

---

# 阶段三总结

## 1. 用一句话总结

> **阶段三的核心是：把 Agent 从“能调用模型和工具”升级成“能按任务入口、上下文、工具、记忆、文件、流程、反馈、人工介入稳定完成复杂任务的工程系统”。**

## 2. 八大核心模块总图

```text
Agent Harness 核心模块
├─ 11. Task Entry Harness
│  └─ 模糊需求 → Task Brief
├─ 12. Context Harness
│  └─ 上下文选择、压缩、注入
├─ 13. Tool Harness
│  └─ 工具清单、参数、错误处理
├─ 14. Memory Harness
│  └─ 短期记忆、长期记忆、记忆污染治理
├─ 15. Filesystem Harness
│  └─ 文件系统作为 Agent 工作台
├─ 16. Workflow Harness
│  └─ 步骤、状态机、分支、Gate
├─ 17. Feedback Harness
│  └─ 错误捕获、自我修复、回归沉淀
└─ 18. Human-in-the-loop Harness
   └─ 人工审批、修改、拒绝、接管
```

## 3. 八大模块关系

```text
任务入口定义目标
→ Context 提供材料
→ Tool 提供行动能力
→ Memory 保存长期经验
→ Filesystem 保存工作产物
→ Workflow 控制执行路径
→ Feedback 修复错误
→ HITL 控制高风险节点
```

## 4. 阶段三最重要的判断

```text
一个 Agent 是否工程化，不看它会不会回答，
而看它是否具备：

清晰任务入口
可控上下文
安全工具调用
稳定记忆管理
可审查文件工作台
可恢复工作流
错误反馈闭环
人工审批机制
```

## 5. 阶段三掌握标准

| 能力 | 判断标准 |
|---|---|
| 任务入口设计 | 能把模糊需求转成 Task Brief |
| 上下文治理 | 能选择、压缩、注入、验证上下文 |
| 工具治理 | 能设计工具 schema、policy、错误处理 |
| 记忆治理 | 能判断记什么、不记什么、防止污染 |
| 文件系统设计 | 能把目录变成 Agent 工作台 |
| 工作流设计 | 能设计步骤、状态、分支、Gate |
| 反馈闭环设计 | 能把错误转成修复和回归测试 |
| 人工介入设计 | 能设置审批点、权限等级和恢复机制 |

---

# 下一阶段预告

## 阶段四：Eval / Test / Quality Harness｜第 19–26 章

| 章 | 主题 |
|---:|---|
| 19 | Test Harness 基础：fixture、stub、driver |
| 20 | Eval Harness 基础：测试集、评分器、基准线 |
| 21 | 输入测试：正确触发、错误触发、近似场景 |
| 22 | 输出测试：格式、字段、完整性、约束 |
| 23 | 过程评估：是否绕流程、是否遗漏检查 |
| 24 | 结果评估：是否真的解决问题 |
| 25 | Regression Harness：防止改好一个、弄坏三个 |
| 26 | Quality Gate：任务完成前的质量门禁 |

---

# 来源与延伸阅读

- LangChain：The Anatomy of an Agent Harness
- LangChain Docs：Harness capabilities
- LangChain Docs：Human-in-the-loop
- LangGraph Docs：Persistence
- OpenAI Agents SDK：Guardrails and Human Review
- OpenAI Agents SDK：Human-in-the-loop
- Model Context Protocol：Tools Specification
