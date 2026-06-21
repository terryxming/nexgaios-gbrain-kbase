---
title: 'Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块'
status: raw
created: '2026-05-21 15:12'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 部分编译
compiled_at: 2026-06-20 23:35
compiled_to:
  - "产品级 Agent 设计方法论"
  - "最小可用 Agent"
  - "Agent 工程化与产品化知识地图"
  - "Agent 工程模板"
  - "Planner Executor 架构"
tags:
  - 'Agent'
  - 'LLM'
  - 'Knowledge-Base'
---

# Agent 工程化与产品化｜第 11–17 章：Agent 工程化核心模块

> 课程阶段：阶段三  
> 主题：从 Demo Agent 走向可维护的工程系统  
> 适用位置：llm-wiki / agent-engineering-productization / core-engineering-modules

---

## 本阶段目标

第 5–10 章解决的是：**如何做出一个最小可用 Agent**。

第 11–17 章解决的是：**如何让这个 Agent 从“能跑”变成“可维护、可迭代、可测试、可协作”的工程系统**。

| 能力目标 | 具体表现 |
|---|---|
| 能看懂架构 | 知道 Agent 系统由哪些工程模块组成 |
| 能拆任务 | 能把模糊任务拆成可执行流程 |
| 能建流程 | 能区分固定 Workflow 和动态 Agent 判断 |
| 能管理状态 | 知道任务执行到哪一步、失败后如何恢复 |
| 能处理异常 | 设计重试、降级、停止、人工接管 |
| 能引入人工 | 在关键节点加入 human-in-the-loop |
| 能版本管理 | 管理 prompt、工具、流程、eval、配置版本 |
| 能设计目录 | 搭建可复用的 Agent 工程文件结构 |

---

# 第 11 章｜Agent 工程架构总览

## 11.1 一句话结论

**Agent 工程架构，就是把“模型能力”放进一套可控的任务系统里，让它可以稳定完成真实工作。**

最小 Agent 关注：

```text
Goal + Instruction + Context + Tool + Output + Quality Criteria
```

工程化 Agent 关注：

```text
需求层
↓
Agent 定义层
↓
上下文层
↓
工具层
↓
流程编排层
↓
状态层
↓
异常处理层
↓
人工介入层
↓
质量评估层
↓
可观测层
↓
部署运维层
```

---

## 11.2 费曼解释

一个 Demo Agent 像“临时找一个聪明人帮忙”。

一个工程化 Agent 像“公司里一个有 SOP、有权限、有工具、有考核、有记录的岗位”。

| 临时聪明人 | 工程化岗位 |
|---|---|
| 靠个人发挥 | 有明确职责 |
| 任务边界模糊 | 有 Scope |
| 做错难追责 | 有日志和 Trace |
| 结果不稳定 | 有测试和评估 |
| 不可复制 | 有模板和版本 |
| 离开场景就失效 | 可迁移、可维护 |

Agent 工程化的本质不是让 AI 更“聪明”，而是让它在真实业务系统中**稳定发挥作用**。

---

## 11.3 工程化 Agent 的核心模块

| 模块 | 作用 | 关键问题 |
|---|---|---|
| 需求层 | 明确业务目标、用户、边界 | 为什么要做这个 Agent？ |
| Agent 定义层 | 定义角色、目标、规则、输出 | Agent 应该如何工作？ |
| Context 层 | 管理输入、资料、记忆、知识库 | Agent 依据什么判断？ |
| Tool 层 | 接入 API、文件、数据库、脚本 | Agent 能调用什么能力？ |
| Orchestration 层 | 编排步骤、分支、循环 | 任务如何推进？ |
| State 层 | 保存任务进度和中间结果 | 当前执行到哪里？ |
| Error Handling 层 | 处理失败、重试、降级、停止 | 出错怎么办？ |
| Human-in-the-loop 层 | 人工确认、审核、接管 | 哪些节点必须让人参与？ |
| Eval/Test 层 | 验证结果和过程质量 | 怎么判断做得好不好？ |
| Observability 层 | 日志、Trace、成本、延迟 | 怎么知道系统发生了什么？ |
| Deployment 层 | 上线、权限、环境、版本 | 怎么稳定运行？ |
| Ops 层 | 监控、回滚、灰度、迭代 | 怎么长期维护？ |

---

## 11.4 Demo Agent 和工程化 Agent 的差距

| 维度 | Demo Agent | 工程化 Agent |
|---|---|---|
| 目标 | 临时演示 | 稳定完成真实任务 |
| 上下文 | 手动粘贴 | 自动组装、检索、过滤 |
| 工具 | 少量手动调用 | 工具库、权限、Schema |
| 流程 | 模型自由发挥 | Workflow + Agent 判断 |
| 状态 | 基本无状态 | 有任务状态、检查点 |
| 异常 | 失败就停 | 重试、降级、人工介入 |
| 输出 | 自然语言 | 结构化、可复用 |
| 质量 | 人凭感觉看 | Test、Eval、回归 |
| 记录 | 没有或很少 | Trace、日志、指标 |
| 迭代 | 改 prompt | 改配置、工具、评估集、版本 |

---

## 11.5 Agent 工程化的核心原则

| 原则 | 说明 |
|---|---|
| 固定优先 | 能用确定流程解决的，不交给模型自由判断 |
| 判断隔离 | 只在需要语义理解、权衡、解释的地方使用 LLM |
| 状态显式 | 不把任务进度只藏在对话里 |
| 工具最小化 | 工具越少越稳定，工具越多越要治理 |
| 权限最小化 | 只给完成任务所需的最小权限 |
| 输出结构化 | 结果必须可检查、可复用、可自动化处理 |
| 失败可恢复 | 中断后能继续，而不是重新开始 |
| 过程可追踪 | 不只看最终答案，还要看中间过程 |
| 评估前置 | 没有评估，就无法判断迭代是否变好 |
| 人机分工 | 高风险、模糊、价值判断节点交给人确认 |

---

## 11.6 本章掌握标准

你需要能回答：

1. 为什么 Agent 工程化不是“写更好的 prompt”？
2. 工程化 Agent 比最小 Agent 多了哪些模块？
3. 哪些模块决定稳定性？
4. 哪些模块决定安全性？
5. 哪些模块决定可迭代性？

---

# 第 12 章｜任务拆解与流程建模

## 12.1 一句话结论

**任务拆解，是把一个模糊目标拆成可执行、可检查、可恢复的步骤。流程建模，是决定哪些步骤固定执行，哪些步骤交给 Agent 判断。**

---

## 12.2 费曼解释

用户说：

> 帮我优化 Amazon 广告。

这不是一个任务，而是一个“愿望”。

Agent 不能直接执行“优化广告”，它需要拆成：

```text
明确优化目标
↓
读取广告数据
↓
检查数据完整性
↓
识别异常指标
↓
定位问题对象
↓
分析根因
↓
生成建议
↓
让人确认
↓
执行或输出方案
```

任务拆解的目标是：

> 把“想要一个结果”拆成“系统可以一步步推进的动作”。

---

## 12.3 任务拆解的五层

| 层级 | 问题 | 示例 |
|---|---|---|
| 目标层 | 用户最终想要什么？ | 降低 ACOS |
| 结果层 | 最后交付什么？ | 诊断报告 + 优化建议 |
| 任务层 | 需要完成哪些任务？ | 数据检查、指标对比、根因判断 |
| 动作层 | 每个任务如何执行？ | 读取文件、计算变化、排序异常 |
| 验收层 | 如何判断完成？ | 有证据、有对象、有动作、有风险 |

---

## 12.4 任务拆解模板

```markdown
# 任务拆解模板

## 1. 用户原始需求
- 用户说了什么？

## 2. 真实目标
- 用户真正想解决什么问题？

## 3. 最终交付物
- 报告？
- 表格？
- 文件？
- 操作建议？
- 自动执行结果？

## 4. 必要输入
- 需要哪些数据、文件、权限、上下文？

## 5. 执行步骤
| 步骤 | 动作 | 是否固定 | 是否需要 Agent 判断 | 是否需要人工确认 |
|---|---|---|---|---|

## 6. 异常分支
| 异常 | 处理方式 |
|---|---|

## 7. 验收标准
- 准确性：
- 完整性：
- 可执行性：
- 安全性：
```

---

## 12.5 固定流程和动态判断的拆分

| 步骤类型 | 适合谁做 | 示例 |
|---|---|---|
| 数据读取 | 程序 / Workflow | 读取广告报表 |
| 字段校验 | 程序 / Workflow | 检查 impressions、clicks、orders |
| 指标计算 | 程序 / Workflow | 计算 CTR、CVR、ACOS |
| 异常识别 | 程序 + Agent | 找出变化最大的对象 |
| 根因判断 | Agent | 判断是 CPC、CVR 还是流量结构问题 |
| 建议生成 | Agent | 输出优化动作 |
| 高风险执行 | 人工确认后工具执行 | 修改预算、暂停广告 |
| 文件输出 | 程序 / Workflow | 生成 Markdown / Excel / PDF |

核心原则：

```text
确定性强的步骤 → 交给 Workflow
语义判断强的步骤 → 交给 Agent
风险高的步骤 → 交给人确认
```

---

## 12.6 流程建模的三种方式

| 类型 | 说明 | 适合场景 |
|---|---|---|
| 线性流程 | 一步接一步 | 文档整理、报表生成 |
| 分支流程 | 根据条件走不同路径 | 客服、审核、异常诊断 |
| 循环流程 | 执行、检查、修正、再执行 | 代码开发、研究、复杂分析 |

### 线性流程

```text
输入 → 处理 → 输出
```

适合：

- 知识沉淀
- 格式转换
- 简单报告生成

### 分支流程

```text
输入
↓
分类判断
├─ 类型 A → 流程 A
├─ 类型 B → 流程 B
└─ 类型 C → 转人工
```

适合：

- 客服工单
- 售后邮件
- 风险审核

### 循环流程

```text
计划 → 执行 → 检查 → 修正 → 再执行 → 完成
```

适合：

- 代码开发 Agent
- 深度研究 Agent
- 数据诊断 Agent

---

## 12.7 任务拆解常见误区

| 误区 | 后果 | 正确做法 |
|---|---|---|
| 直接让 Agent 做大任务 | 容易跳步、漏步 | 先拆任务 |
| 所有步骤都交给模型 | 不稳定、成本高 | 固定步骤程序化 |
| 不设计异常分支 | 一失败就卡住 | 提前定义异常处理 |
| 不设计验收标准 | 不知道结果好坏 | 每一步有完成标准 |
| 不区分建议和执行 | 容易越权 | 高风险动作必须确认 |
| 只拆成功路径 | 真实系统必然失败 | 同时拆失败路径 |

---

## 12.8 本章掌握标准

你需要能回答：

1. 为什么用户需求通常不能直接交给 Agent 执行？
2. 任务拆解的五层是什么？
3. 哪些步骤应该固定，哪些步骤应该交给 Agent？
4. 为什么异常分支必须提前设计？
5. 如何把一个模糊任务拆成可执行流程？

---

# 第 13 章｜状态机与执行流

## 13.1 一句话结论

**状态机解决“Agent 当前执行到哪一步、下一步该做什么、失败后怎么恢复”的问题。执行流解决“任务如何从开始走到完成”的问题。**

---

## 13.2 费曼解释

没有状态机的 Agent 像一个没有工作记录的人。

你问：

> 做到哪了？

它说：

> 我觉得快好了。

工程系统不能这样。

工程系统需要明确：

```text
当前状态：正在检查数据
上一状态：已读取文件
下一状态：计算指标
失败状态：字段缺失
完成状态：已生成诊断报告
```

状态机的作用是：

> 让 Agent 的任务进度从“模糊感觉”变成“明确状态”。

---

## 13.3 什么是状态

状态就是系统在某一时刻的任务位置。

| 状态 | 含义 |
|---|---|
| created | 任务已创建 |
| input_received | 已收到输入 |
| context_ready | 上下文已准备 |
| planning | 正在规划 |
| tool_calling | 正在调用工具 |
| waiting_user_confirm | 等待用户确认 |
| executing | 正在执行 |
| reviewing | 正在检查结果 |
| completed | 已完成 |
| failed | 已失败 |
| cancelled | 已取消 |

---

## 13.4 状态机基本结构

```text
状态 State
↓
事件 Event
↓
条件 Condition
↓
动作 Action
↓
下一个状态 Next State
```

示例：

| 当前状态 | 事件 | 条件 | 动作 | 下一状态 |
|---|---|---|---|---|
| input_received | 开始处理 | 输入完整 | 组装上下文 | context_ready |
| input_received | 开始处理 | 输入缺失 | 请求补充 | waiting_user_input |
| context_ready | 开始规划 | 无高风险 | 生成计划 | planning |
| planning | 计划完成 | 需要工具 | 调用工具 | tool_calling |
| tool_calling | 工具成功 | 结果可用 | 整合结果 | reviewing |
| tool_calling | 工具失败 | 可重试 | 重试工具 | tool_calling |
| tool_calling | 工具失败 | 不可重试 | 标记失败 | failed |
| reviewing | 检查通过 | 无需确认 | 输出结果 | completed |
| reviewing | 检查未通过 | 可修正 | 重新规划 | planning |

---

## 13.5 为什么 Agent 需要状态机

| 问题 | 没有状态机 | 有状态机 |
|---|---|---|
| 进度 | 不知道做到哪 | 明确当前状态 |
| 失败 | 只能重新开始 | 可从断点恢复 |
| 调试 | 很难定位错误 | 可看状态转移 |
| 人工介入 | 不知道在哪里插入 | 可在指定状态暂停 |
| 评估 | 只能看最终输出 | 可评估每一步 |
| 协作 | 多 Agent 容易混乱 | 状态可共享 |
| 产品化 | 难以嵌入系统 | 可和业务流程对齐 |

LangGraph 的持久化层会将图状态保存为 checkpoints，使 human-in-the-loop、会话记忆、时间旅行调试和容错执行成为可能；这说明状态保存是产品级 Agent 的关键基础设施之一。参考资料：https://docs.langchain.com/oss/python/langgraph/persistence

---

## 13.6 执行流的三种模式

| 模式 | 说明 | 适合场景 |
|---|---|---|
| Sequential | 顺序执行 | 文档生成、报表整理 |
| Conditional | 条件分支 | 客服分类、风险判断 |
| Iterative | 循环迭代 | 代码修复、研究、复杂诊断 |

---

## 13.7 检查点 Checkpoint

Checkpoint 是“任务快照”。

它记录：

| 内容 | 示例 |
|---|---|
| 当前状态 | tool_calling |
| 已完成步骤 | 已读取文件、已计算指标 |
| 中间结果 | 指标变化表 |
| 上下文 | 当前任务相关资料 |
| 工具返回 | API 结果 |
| 错误信息 | 字段缺失 |
| 用户确认 | 已确认继续执行 |

Checkpoint 的价值：

| 价值 | 说明 |
|---|---|
| 可恢复 | 失败后不用从头开始 |
| 可审计 | 知道每一步发生了什么 |
| 可暂停 | 等待用户确认后继续 |
| 可回放 | 调试时重现过程 |
| 可协作 | 多 Agent 可以接力 |

---

## 13.8 本章误区

| 误区 | 正确理解 |
|---|---|
| 对话历史就是状态 | 对话历史太松散，状态需要结构化 |
| 小 Agent 不需要状态 | 只要多步骤，就需要最小状态 |
| 状态越复杂越好 | 状态只记录推进任务所需信息 |
| 状态机限制智能 | 状态机限制的是混乱，不是智能 |
| 失败重新跑就行 | 高成本任务必须支持断点恢复 |

---

## 13.9 本章掌握标准

你需要能回答：

1. 状态和上下文有什么区别？
2. 状态机由哪些元素组成？
3. 为什么多步骤 Agent 必须显式管理状态？
4. Checkpoint 解决什么问题？
5. 什么情况下需要暂停等待用户确认？

---

# 第 14 章｜错误处理与重试机制

## 14.1 一句话结论

**错误处理决定 Agent 是否能进入真实生产环境。没有错误处理的 Agent，只是一次性 Demo。**

---

## 14.2 费曼解释

真实世界里，Agent 一定会遇到失败：

| 失败类型 | 例子 |
|---|---|
| 用户输入缺失 | 没给时间范围 |
| 文件格式错误 | 上传了错误表格 |
| 工具调用失败 | API 超时 |
| 权限不足 | 没有读写权限 |
| 模型判断错误 | 把诊断任务当成解释任务 |
| 输出格式错误 | 没按 JSON 返回 |
| 高风险动作 | 可能修改预算或删除文件 |
| 外部系统异常 | 数据库不可用 |

工程化不是假设不会失败，而是：

> 假设失败一定会发生，然后设计系统如何处理失败。

---

## 14.3 错误分类

| 错误类型 | 来源 | 处理策略 |
|---|---|---|
| 输入错误 | 用户输入不完整、不清楚 | 请求补充或使用默认假设 |
| 上下文错误 | 资料缺失、过期、不相关 | 标记缺失、重新检索 |
| 工具错误 | API 超时、参数错误、权限不足 | 重试、修正参数、降级 |
| 模型错误 | 理解错、格式错、编造 | 重新提示、格式校验、审查 |
| 流程错误 | 跳步、循环、状态异常 | 状态机约束、最大循环次数 |
| 权限错误 | 越权读取、越权写入 | 拦截、请求授权 |
| 安全错误 | Prompt Injection、敏感信息泄露 | Guardrail、安全检查 |
| 业务错误 | 建议不可执行、风险过高 | 人工审核、风险标记 |

---

## 14.4 错误处理四件套

```text
Detect → Classify → Recover → Report
```

| 阶段 | 作用 | 示例 |
|---|---|---|
| Detect | 发现错误 | 工具返回 500 |
| Classify | 判断错误类型 | API 超时 |
| Recover | 尝试恢复 | 重试一次或切换备用工具 |
| Report | 报告结果 | 说明失败原因和下一步 |

---

## 14.5 重试机制设计

不是所有错误都应该重试。

| 错误 | 是否重试 | 原因 |
|---|---|---|
| API 超时 | 可以 | 可能是临时故障 |
| 网络失败 | 可以 | 可能恢复 |
| 参数格式错误 | 先修正再重试 | 直接重试无效 |
| 权限不足 | 不重试 | 需要授权 |
| 文件不存在 | 不重试 | 需要用户提供 |
| 高风险动作未确认 | 不重试 | 需要人工确认 |
| 模型输出格式错 | 可以 | 可用结构化约束修正 |
| 业务规则冲突 | 不重试 | 需要人判断 |

---

## 14.6 Retry Policy 模板

```yaml
retry_policy:
  max_attempts: 2
  retryable_errors:
    - timeout
    - rate_limit
    - temporary_unavailable
  non_retryable_errors:
    - permission_denied
    - missing_required_input
    - user_confirmation_required
    - unsafe_action
  backoff:
    type: exponential
    initial_seconds: 2
    max_seconds: 30
  on_failure:
    action: report_error
    include:
      - error_type
      - failed_step
      - attempted_recovery
      - suggested_next_step
```

---

## 14.7 降级策略

当完整能力不可用时，系统应该尽量提供部分价值。

| 正常能力 | 降级方案 |
|---|---|
| 自动读取报表 | 让用户上传 CSV |
| 自动调用 API | 输出手动操作步骤 |
| 自动生成完整报告 | 先输出诊断摘要 |
| 自动执行修改 | 改成生成待确认方案 |
| 多工具分析 | 只用已可用工具 |
| 实时数据 | 使用用户提供的离线数据 |

降级不是失败，而是：

> 在约束下保留最大可用价值。

---

## 14.8 停止条件

Agent 不能无限执行。

常见停止条件：

| 停止条件 | 说明 |
|---|---|
| 任务完成 | 已生成合格结果 |
| 达到最大重试次数 | 防止死循环 |
| 缺少关键输入 | 继续执行会编造 |
| 权限不足 | 需要用户授权 |
| 风险过高 | 必须人工确认 |
| 成本超限 | 防止无限消耗 |
| 用户取消 | 停止任务 |
| 工具不可用 | 输出失败原因和替代方案 |

OWASP 2025 LLM 风险中包含 Prompt Injection、过度代理权、无边界资源消耗等风险，这些风险都要求 Agent 系统具备权限限制、停止条件、资源控制和安全拦截。参考资料：https://genai.owasp.org/llm-top-10/

---

## 14.9 本章掌握标准

你需要能回答：

1. 为什么真实 Agent 必须假设错误一定会发生？
2. 哪些错误适合重试，哪些不适合？
3. 降级策略和失败有什么区别？
4. 停止条件解决什么问题？
5. 错误报告应该包含哪些信息？

---

# 第 15 章｜Human-in-the-loop

## 15.1 一句话结论

**Human-in-the-loop 不是 Agent 不够智能，而是产品级 Agent 必须具备的安全、信任和质量机制。**

---

## 15.2 费曼解释

你不会让一个新员工在没有审批的情况下：

- 删除客户资料
- 修改广告预算
- 发送正式邮件
- 改生产数据库
- 对外承诺赔偿
- 发布品牌内容

同样，Agent 也不能在高风险节点完全自动执行。

Human-in-the-loop 的作用是：

```text
Agent 做分析和准备
↓
人做判断和确认
↓
Agent 再执行或生成交付
```

---

## 15.3 哪些节点需要人工介入

| 节点 | 原因 |
|---|---|
| 需求不清楚 | 继续执行容易误解 |
| 关键数据缺失 | 继续执行容易编造 |
| 高风险写入 | 可能造成业务损失 |
| 对外发送 | 品牌、法律、关系风险 |
| 删除操作 | 不可逆风险 |
| 金钱相关 | 预算、支付、交易风险 |
| 权限升级 | 安全风险 |
| 置信度低 | 需要人判断 |
| 多方案选择 | 涉及偏好和策略 |
| 伦理/法律/合规问题 | 必须人工确认 |

---

## 15.4 Human-in-the-loop 的三种模式

| 模式 | 说明 | 适合场景 |
|---|---|---|
| Confirm | 执行前确认 | 发邮件、改预算、删除文件 |
| Review | 输出后审核 | 报告、文案、客服回复 |
| Escalate | 转人工处理 | 高风险、低置信度、异常案例 |

---

## 15.5 确认节点设计

差的确认：

```text
是否继续？
```

好的确认：

```markdown
即将执行以下动作：

| 动作 | 对象 | 影响 | 风险 |
|---|---|---|---|
| 降低 bid | keyword: karaoke machine | 预计降低 CPC | 可能降低曝光 |

请确认：
1. 执行
2. 修改方案
3. 取消
```

好的确认必须包括：

| 内容 | 说明 |
|---|---|
| 要执行什么 | 动作清晰 |
| 作用对象 | 具体到文件、广告、邮件、记录 |
| 可能影响 | 用户知道后果 |
| 风险 | 明确不确定性 |
| 可选项 | 执行、修改、取消 |

---

## 15.6 审核节点设计

适合审核的内容：

| 类型 | 审核重点 |
|---|---|
| 广告建议 | 是否有数据证据 |
| 客服回复 | 是否符合品牌语气 |
| Listing 文案 | 是否准确、合规、有转化力 |
| 代码修改 | 是否通过测试 |
| 知识文档 | 是否结构清晰、可沉淀 |
| 研究报告 | 是否有来源、是否有推测标记 |

审核不是让人重新做一遍，而是让人检查关键风险点。

---

## 15.7 中断与恢复

产品级 Agent 的人工介入不是“停住就结束”，而是：

```text
执行到关键节点
↓
保存状态
↓
等待用户输入
↓
收到确认
↓
从原状态继续执行
```

LangGraph 的 interrupt 机制允许在图节点中暂停执行、保存状态并等待外部输入，再从该位置恢复，这正是 human-in-the-loop 的典型工程实现方式。参考资料：https://docs.langchain.com/oss/python/langgraph/interrupts

---

## 15.8 本章误区

| 误区 | 正确理解 |
|---|---|
| 人工介入说明 Agent 不够强 | 人工介入是安全和信任设计 |
| 所有步骤都要确认 | 只在高风险或低置信节点确认 |
| 确认只要问“是否继续” | 必须说明动作、对象、影响、风险 |
| 人工审核会降低效率 | 正确节点审核会降低错误成本 |
| 高级 Agent 应该全自动 | 高级 Agent 应该知道何时不自动 |

---

## 15.9 本章掌握标准

你需要能回答：

1. Human-in-the-loop 解决什么问题？
2. Confirm、Review、Escalate 有什么区别？
3. 哪些任务节点必须人工确认？
4. 好的确认界面应该包含什么？
5. 为什么中断后必须能从状态恢复？

---

# 第 16 章｜配置化与版本管理

## 16.1 一句话结论

**Agent 工程化不能只靠改 prompt。真正可维护的 Agent，需要把模型、指令、工具、流程、参数、评估集、权限都纳入配置和版本管理。**

---

## 16.2 费曼解释

如果每次 Agent 出问题，你都只是在聊天框里改一句提示词，这不是工程化。

工程化的做法是：

```text
当前版本是什么？
改了什么？
为什么改？
影响哪些能力？
有没有测试？
是否能回滚？
```

版本管理解决的是：

> 让 Agent 的变化可记录、可比较、可测试、可回退。

---

## 16.3 Agent 需要管理哪些版本

| 对象 | 示例 | 影响 |
|---|---|---|
| Prompt / Instruction | 角色、流程、边界 | 影响行为 |
| Model | GPT-5.5、其他模型 | 影响能力、成本、延迟 |
| Tool Schema | 参数、返回值 | 影响工具调用稳定性 |
| Workflow | 步骤、分支、循环 | 影响执行路径 |
| State Schema | 状态字段 | 影响恢复和协作 |
| Eval Set | 测试用例、评分规则 | 影响质量判断 |
| Knowledge Base | 文档、规则、SOP | 影响上下文 |
| Config | 温度、最大轮数、重试次数 | 影响稳定性和成本 |
| Permission | 工具权限、数据权限 | 影响安全 |
| Output Schema | JSON、Markdown、表格格式 | 影响下游复用 |

---

## 16.4 配置化的价值

| 没有配置化 | 有配置化 |
|---|---|
| 改代码才能调参数 | 改配置即可调整 |
| 行为变化不可追踪 | 每次变化有记录 |
| 不能快速回滚 | 可回到旧版本 |
| 多环境混乱 | dev / staging / prod 分离 |
| 多 Agent 难复用 | 公共配置可继承 |
| 难以做 A/B 测试 | 可比较不同版本表现 |

---

## 16.5 Agent 配置文件示例

```yaml
agent:
  name: amazon_ads_diagnosis_agent
  version: 0.1.0
  owner: ops_team
  description: Diagnose Amazon Ads performance changes and generate action recommendations.

model:
  provider: openai
  name: gpt-5.5-thinking
  temperature: 0.2
  max_tool_calls: 6

instruction:
  file: prompts/main.md
  version: 0.1.3

tools:
  - name: read_ads_report
    permission: read
    required: true
  - name: calculate_metrics
    permission: compute
    required: true
  - name: generate_markdown_report
    permission: write_file
    confirmation_required: false

workflow:
  file: workflows/diagnosis.yaml
  max_steps: 12
  max_retries: 2

guardrails:
  require_evidence: true
  forbid_fabricated_data: true
  require_confirmation_for:
    - modify_budget
    - pause_campaign
    - send_email

output:
  schema: schemas/diagnosis_report.schema.json
  format: markdown

eval:
  testset: evals/ads_diagnosis_cases.yaml
  minimum_score: 0.85
```

---

## 16.6 版本号建议

使用语义化版本：

```text
MAJOR.MINOR.PATCH
```

| 类型 | 什么时候改 | 示例 |
|---|---|---|
| PATCH | 修 bug，不改变能力边界 | 0.1.0 → 0.1.1 |
| MINOR | 增加能力，但兼容旧行为 | 0.1.1 → 0.2.0 |
| MAJOR | 改变架构或行为边界 | 0.2.0 → 1.0.0 |

---

## 16.7 变更记录模板

```markdown
# CHANGELOG

## [0.2.0] - 2026-05-21

### Added
- 增加 Search Term 根因诊断流程。
- 增加低置信度人工确认节点。

### Changed
- 优化 ACOS 上升原因判断顺序。
- 将输出从自由文本改为 Markdown 表格。

### Fixed
- 修复缺少 spend 字段时仍继续分析的问题。

### Risk
- 新流程可能增加一次工具调用成本。

### Eval
- 通过 18/20 个诊断测试用例。
- 失败案例：低样本量关键词判断仍不稳定。
```

---

## 16.8 本章误区

| 误区 | 正确理解 |
|---|---|
| Agent 版本就是 prompt 版本 | 还包括工具、流程、模型、评估集 |
| 小项目不需要版本 | 只要持续迭代，就需要版本 |
| 配置越多越专业 | 配置必须服务于可维护性 |
| 改了能跑就行 | 必须记录影响和测试结果 |
| 没必要回滚 | 产品级系统必须能回滚 |

---

## 16.9 本章掌握标准

你需要能回答：

1. Agent 哪些部分需要版本管理？
2. 配置化解决什么问题？
3. 为什么 prompt 版本不等于 Agent 版本？
4. 什么情况下应该升 PATCH、MINOR、MAJOR？
5. CHANGELOG 应该记录哪些内容？

---

# 第 17 章｜Agent 工程目录结构

## 17.1 一句话结论

**Agent 工程目录结构，是把 Agent 的指令、工具、上下文、流程、测试、评估、资产和版本记录组织起来，让它从“一次性产物”变成“可复用工程资产”。**

---

## 17.2 费曼解释

如果一个 Agent 只有一段 prompt，它很难长期维护。

你会遇到：

| 问题 | 表现 |
|---|---|
| 找不到规则 | prompt 散在聊天记录里 |
| 不知道工具怎么用 | 工具说明不完整 |
| 不能复用 | 下次只能重新写 |
| 不能测试 | 没有用例 |
| 不能协作 | 别人不知道结构 |
| 不能迭代 | 不知道改动历史 |

工程目录的作用是：

> 把 Agent 能力从“脑子里的经验”变成“文件系统里的资产”。

---

## 17.3 最小目录结构

```text
agent-name/
├─ README.md
├─ AGENT.md
├─ config.yaml
├─ prompts/
│  └─ main.md
├─ workflows/
│  └─ main.yaml
├─ tools/
│  └─ tools.yaml
├─ schemas/
│  └─ output.schema.json
├─ evals/
│  └─ cases.yaml
├─ tests/
│  └─ trigger_cases.yaml
├─ references/
│  └─ domain_knowledge.md
├─ assets/
│  └─ templates/
└─ CHANGELOG.md
```

---

## 17.4 推荐目录结构

```text
agent-name/
├─ README.md
├─ AGENT.md
├─ config.yaml
├─ CHANGELOG.md
│
├─ prompts/
│  ├─ main.md
│  ├─ tool_policy.md
│  ├─ failure_policy.md
│  └─ output_policy.md
│
├─ workflows/
│  ├─ main.yaml
│  ├─ states.yaml
│  └─ error_paths.yaml
│
├─ tools/
│  ├─ registry.yaml
│  ├─ schemas/
│  └─ docs/
│
├─ context/
│  ├─ context_policy.md
│  ├─ retrieval_policy.md
│  └─ memory_policy.md
│
├─ schemas/
│  ├─ input.schema.json
│  ├─ output.schema.json
│  └─ state.schema.json
│
├─ evals/
│  ├─ golden_cases.yaml
│  ├─ scoring_rubric.md
│  └─ regression_cases.yaml
│
├─ tests/
│  ├─ trigger_cases.yaml
│  ├─ near_miss_cases.yaml
│  └─ failure_cases.yaml
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
   ├─ design_notes.md
   └─ runbook.md
```

---

## 17.5 每个文件夹的作用

| 目录 | 作用 |
|---|---|
| README.md | 给人看的项目说明 |
| AGENT.md | Agent 的核心行为契约 |
| config.yaml | 模型、工具、流程、权限配置 |
| prompts/ | 指令和提示词 |
| workflows/ | 流程、状态、异常路径 |
| tools/ | 工具注册、Schema、说明 |
| context/ | 上下文、检索、记忆策略 |
| schemas/ | 输入、输出、状态结构 |
| evals/ | 质量评估用例和评分规则 |
| tests/ | 触发、误触发、失败测试 |
| scripts/ | 稳定的程序化能力 |
| references/ | 领域知识、业务规则、案例 |
| assets/ | 模板、示例、视觉或文件资产 |
| docs/ | 使用文档、设计记录、运维手册 |
| CHANGELOG.md | 版本变更记录 |

---

## 17.6 AGENT.md 推荐结构

```markdown
# Agent Name

## 1. Purpose
这个 Agent 解决什么问题。

## 2. Users
服务哪些用户。

## 3. Scope
处理什么，不处理什么。

## 4. Inputs
需要哪些输入。

## 5. Context Policy
如何选择和使用上下文。

## 6. Tools
可用工具和使用边界。

## 7. Workflow
核心执行流程。

## 8. State
需要保存哪些状态。

## 9. Human-in-the-loop
哪些节点需要人工确认。

## 10. Output
输出格式和交付标准。

## 11. Quality Criteria
结果质量标准。

## 12. Failure Policy
异常处理策略。

## 13. Security Policy
权限和安全边界。

## 14. Eval
评估方式和用例位置。
```

---

## 17.7 tests 和 evals 的区别

| 对比项 | tests | evals |
|---|---|---|
| 目标 | 检查是否按规则运行 | 判断质量好不好 |
| 关注点 | 对/错、触发/不触发、格式是否合规 | 有用性、准确性、完整性、可执行性 |
| 示例 | 输入缺字段时是否停止 | 广告诊断是否抓住主要根因 |
| 结果 | pass / fail | score / grade / review |
| 位置 | 更偏工程测试 | 更偏质量评估 |

你的 Skill 目录理解中，tests 和 evals 应该分开，这是正确的：

```text
tests = 检查系统有没有按规则运行
evals = 判断结果质量是否足够好
```

---

## 17.8 目录结构设计原则

| 原则 | 说明 |
|---|---|
| 指令和代码分离 | Prompt 不混在业务代码里 |
| 规则和案例分离 | 通用规则放 AGENT.md，案例放 references |
| 流程和工具分离 | Workflow 不直接写死工具细节 |
| 测试和评估分离 | tests 检查规则，evals 检查质量 |
| 模板和输出分离 | assets 放模板，outputs 放生成结果 |
| 配置和实现分离 | config 控制行为，scripts 提供能力 |
| 文档和变更分离 | docs 解释使用，CHANGELOG 记录变化 |

---

## 17.9 本章掌握标准

你需要能回答：

1. 为什么 Agent 需要工程目录？
2. AGENT.md 和 README.md 有什么区别？
3. prompts、workflows、tools、schemas、evals、tests 分别放什么？
4. tests 和 evals 的区别是什么？
5. 如何把一个一次性 Agent 沉淀成长期资产？

---

# 第 11–17 章总复盘

## 1. 本阶段核心公式

```text
工程化 Agent
= 最小 Agent
+ 任务拆解
+ 流程编排
+ 状态管理
+ 异常处理
+ 人工介入
+ 配置版本
+ 工程目录
```

---

## 2. 本阶段七个核心结论

| 序号 | 核心结论 |
|---|---|
| 1 | Agent 工程化不是让模型自由发挥，而是把模型放进可控任务系统 |
| 2 | 任务拆解的核心是把模糊目标拆成可执行、可检查、可恢复步骤 |
| 3 | 固定步骤交给 Workflow，语义判断交给 Agent，高风险节点交给人 |
| 4 | 状态机让 Agent 知道当前执行到哪里、下一步做什么、失败后如何恢复 |
| 5 | 错误处理不是补丁，而是产品级 Agent 的基础模块 |
| 6 | Human-in-the-loop 是安全、信任、质量机制，不是低级能力 |
| 7 | 工程目录让 Agent 从一次性 prompt 变成可复用、可迭代的工程资产 |

---

## 3. 本阶段关键判断表

| 判断问题 | 判断标准 |
|---|---|
| 是否需要工程化？ | 只要任务会反复执行、多人使用、接入工具，就需要工程化 |
| 是否需要状态机？ | 只要任务超过一步并可能中断，就需要状态 |
| 是否需要人工确认？ | 只要涉及写入、发送、删除、金钱、权限、品牌风险，就需要 |
| 是否需要重试？ | 只有临时性错误才适合重试 |
| 是否需要降级？ | 外部工具不稳定或权限不足时需要 |
| 是否需要版本管理？ | 只要 Agent 会持续迭代，就需要 |
| 是否需要目录结构？ | 只要希望复用和沉淀，就需要 |

---

## 4. 本阶段实践作业

选择一个你真实要做的 Agent，例如：

- 知识沉淀 Agent
- Amazon 广告诊断 Agent
- Listing 优化 Agent
- 客服回复 Agent
- PRD 拆解 Agent
- Codex Skill Creator Agent

然后按下面模板设计：

```markdown
# Agent 工程化设计草案

## 1. Agent 名称

## 2. 业务目标

## 3. 用户与使用场景

## 4. 任务拆解
| 步骤 | 动作 | 固定 Workflow | Agent 判断 | 人工确认 |
|---|---|---|---|---|

## 5. 状态设计
| 状态 | 含义 | 下一步 |
|---|---|---|

## 6. 工具设计
| 工具 | 类型 | 权限 | 是否需要确认 |
|---|---|---|---|

## 7. 异常处理
| 异常 | 处理方式 | 是否重试 |
|---|---|---|

## 8. Human-in-the-loop
| 节点 | 介入方式 | 用户需要确认什么 |
|---|---|---|

## 9. 配置与版本
- model:
- prompt:
- workflow:
- tools:
- evals:

## 10. 工程目录结构
```text
agent-name/
├─ AGENT.md
├─ config.yaml
├─ prompts/
├─ workflows/
├─ tools/
├─ schemas/
├─ evals/
├─ tests/
├─ references/
├─ assets/
└─ CHANGELOG.md
```

## 11. 验收标准
- 准确性：
- 完整性：
- 可执行性：
- 安全性：
- 可维护性：
```

---

## 5. 本阶段和下一阶段的关系

第 11–17 章解决：

```text
Agent 如何工程化
```

下一阶段第 18–24 章将进入：

```text
工具、MCP 与外部系统集成
```

也就是从“Agent 内部工程结构”进入“Agent 如何连接真实世界”。

---

## 参考来源

- OpenAI Agents SDK - Agents: https://openai.github.io/openai-agents-python/agents/
- OpenAI Agents SDK - Tracing: https://openai.github.io/openai-agents-python/tracing/
- OpenAI Agents SDK - Guides: https://developers.openai.com/api/docs/guides/agents
- LangGraph - Workflows and agents: https://docs.langchain.com/oss/python/langgraph/workflows-agents
- LangGraph - Persistence: https://docs.langchain.com/oss/python/langgraph/persistence
- LangGraph - Durable execution: https://docs.langchain.com/oss/python/langgraph/durable-execution
- LangGraph - Interrupts: https://docs.langchain.com/oss/python/langgraph/interrupts
- OWASP GenAI Security Project - LLM Top 10: https://genai.owasp.org/llm-top-10/
