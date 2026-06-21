---
title: 'Harness Engineering 与敏捷开发的区别、联系、应用场景与边界'
status: raw
created: '2026-05-21 00:00'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Harness-Engineering'
  - '敏捷开发'
  - 'Agent-工程'
  - '工程方法论'
  - '反馈系统'
---

# Harness Engineering 与敏捷开发的区别、联系、应用场景与边界

## 0. 一句话结论

> **敏捷开发解决：我们如何持续做对的事。**  
> **Harness Engineering 解决：Agent / 系统如何持续把事做对。**

| 概念 | 一句话理解 |
|---|---|
| 敏捷开发 | 管理需求、团队、节奏、反馈，让团队持续交付用户价值 |
| Harness Engineering | 管理上下文、工具、测试、eval、沙箱、反馈闭环，让 Agent / 自动化系统可靠执行 |

在 Agent 工程中：

> **敏捷开发 = Agent 工程的项目操作系统**  
> **Harness Engineering = Agent 工程的执行控制系统**

---

## 1. 核心定义

| 维度 | 敏捷开发 | Harness Engineering |
|---|---|---|
| 核心问题 | 如何在不确定需求中持续交付价值 | 如何让 Agent / 自动化系统稳定、可控、可验证地执行任务 |
| 主要对象 | 团队、需求、用户反馈、迭代节奏 | 模型、工具、上下文、测试、评估、沙箱、日志、反馈机制 |
| 关注层级 | 产品交付层 / 项目管理层 / 团队协作层 | 工程执行层 / 系统基础设施层 / Agent 控制层 |
| 典型产物 | Backlog、Sprint、User Story、Review、Retro、DoD | Prompt、Tool Contract、Context Pack、eval、test、sandbox、CI、logs、verifier |
| 判断标准 | 是否持续交付用户价值 | 是否稳定、可控、可验证、可复现 |
| 失败表现 | 有流程、有会议，但交付价值低 | Agent 很能跑，但容易漂移、乱改、误判、不可控 |

---

## 2. 敏捷开发的本质

### 2.1 本质定义

> **敏捷开发的本质：用短周期反馈降低需求不确定性。**

敏捷不是“开站会”，也不是“做 Scrum 表格”，而是一套围绕用户价值持续交付的反馈系统。

### 2.2 敏捷主要解决的问题

| 问题 | 敏捷的回答 |
|---|---|
| 用户需求会变怎么办？ | 短周期迭代，持续调整 |
| 一次性大项目容易失败怎么办？ | 拆成小增量，持续交付 |
| 团队沟通失真怎么办？ | 高频协作、透明化、可视化 |
| 怎么知道做得对不对？ | 交付可工作的产品，并获取反馈 |
| 怎么持续变好？ | 定期复盘，调整流程和优先级 |

### 2.3 敏捷的典型机制

| 机制 | 作用 |
|---|---|
| Backlog | 管理需求池和优先级 |
| User Story | 把需求表达为用户视角的价值单元 |
| Sprint | 用固定周期组织交付节奏 |
| Sprint Planning | 决定本轮迭代做什么 |
| Daily Scrum | 识别阻塞和同步进度 |
| Sprint Review | 展示结果，获取反馈 |
| Retrospective | 复盘协作和流程问题 |
| Definition of Ready | 判断任务是否准备好进入开发 |
| Definition of Done | 判断任务是否真正完成 |

---

## 3. Harness Engineering 的本质

### 3.1 本质定义

> **Harness Engineering 的本质：给 Agent / 自动化系统套上一整套可控、可测、可反馈、可纠偏的工程外骨骼。**

在 Agent 语境中，harness 不只是测试框架，而是模型之外支撑 Agent 工作的整套执行系统。

可以理解为：

```text
Agent = Model + Harness
```

其中：

| 组成 | 含义 |
|---|---|
| Model | 负责理解、推理、生成、决策 |
| Harness | 负责上下文、工具、流程、验证、反馈、权限、恢复 |

### 3.2 Harness Engineering 主要解决的问题

| 问题 | Harness 的回答 |
|---|---|
| Agent 不知道该看什么上下文 | 设计 Context Pack / Memory / Docs 输入机制 |
| Agent 会乱调用工具 | 设计 Tool Contract、权限、沙箱 |
| Agent 输出质量不稳定 | 设计 test、eval、verifier |
| Agent 执行过程不可控 | 设计 workflow、checkpoint、logs |
| Agent 做错没人发现 | 设计自动验证、人工审查点、反馈闭环 |
| Agent 下次又漂移 | 把规则沉淀进文档、代码、测试、CI、skill |

### 3.3 Harness 的典型组成

| 模块 | 作用 |
|---|---|
| Context | 控制 Agent 能看到什么信息 |
| Prompt / Instruction | 控制 Agent 应该如何理解任务 |
| Tool Contract | 控制 Agent 可以调用什么工具、如何调用 |
| Workflow | 控制任务执行顺序和检查点 |
| Sandbox | 控制执行环境，防止不可控破坏 |
| Test | 检查结果是否做对 |
| Eval | 判断过程和结果是否做好 |
| Verifier | 对关键输出进行二次验证 |
| Logs / Trace | 让执行过程可观察、可追踪 |
| Human Review | 在关键节点引入人工判断 |
| Recovery / Rollback | 执行失败后可恢复、可回滚 |

---

## 4. 二者的核心区别

| 对比项 | 敏捷开发 | Harness Engineering |
|---|---|---|
| 解决对象 | 人、团队、需求、交付节奏 | Agent、工具链、执行环境、验证系统 |
| 主要不确定性 | 需求不确定、用户价值不确定、协作不确定 | 执行不确定、输出不稳定、工具调用不可控 |
| 核心机制 | 迭代、反馈、协作、复盘 | 上下文、工具、测试、eval、日志、沙箱 |
| 主要目标 | 持续交付正确的产品价值 | 持续产生可靠的执行结果 |
| 管理层级 | 产品 / 项目 / 团队层 | 工程 / 系统 / 执行层 |
| 更像什么 | 项目操作系统 | 执行控制系统 |
| 典型失败 | 流程敏捷，但质量不敏捷 | 技术稳定，但方向不一定对 |

---

## 5. 二者的联系

### 5.1 不是替代关系，而是上下层关系

```text
敏捷开发：决定做什么、为什么做、什么时候交付、如何获取反馈
Harness Engineering：决定 Agent / 系统怎么可靠地执行、验证和纠偏
```

在 Agent 工程中，二者应该组合使用：

| 敏捷开发负责 | Harness Engineering 负责 |
|---|---|
| 需求拆解 | 任务上下文打包 |
| 用户故事 | Agent 可执行任务说明 |
| Sprint 计划 | Agent 执行批次 / 工作流 |
| Definition of Ready | 输入是否足够清晰 |
| Definition of Done | 输出是否达到验收标准 |
| Sprint Review | 结果评审 |
| Sprint Retrospective | harness 规则、工具、测试、文档迭代 |
| Backlog 优先级 | Agent 执行队列优先级 |
| 团队协作 | 人机协作机制 |

### 5.2 二者都是反馈系统

| 层级 | 反馈对象 | 反馈方式 |
|---|---|---|
| 敏捷开发 | 产品方向、需求、团队协作 | Review、用户反馈、Retro、Backlog 调整 |
| Harness Engineering | Agent 执行、输出质量、工具链、上下文 | eval、test、logs、CI、human review、自动修复 |

整体反馈链路：

```text
用户反馈
  ↓
敏捷开发：调整需求、优先级、交付节奏
  ↓
Agent 工程任务
  ↓
Harness Engineering：控制 Agent 如何执行
  ↓
测试 / eval / review
  ↓
沉淀为规则、文档、工具、脚本、质量门禁
```

---

## 6. 应用场景

## 6.1 敏捷开发适合的场景

| 场景 | 为什么适合 |
|---|---|
| 产品需求不确定 | 可以边做边验证 |
| 用户反馈重要 | 可以持续吸收反馈 |
| 跨职能团队协作 | 需要统一节奏和透明度 |
| 软件 / Agent 产品持续迭代 | 需要不断发布、复盘、调整 |
| 从 0 到 1 探索型项目 | 不适合一次性大计划锁死 |
| 商业价值需要验证 | 可以用 MVP 快速测试方向 |

示例：构建一个 Amazon 广告分析 Agent。

敏捷开发关注：

```text
- 第一版解决什么核心痛点？
- 先做关键词诊断，还是广告结构诊断？
- 一周交付什么 MVP？
- 用户试用后反馈什么？
- 下一轮迭代改什么？
```

## 6.2 Harness Engineering 适合的场景

| 场景 | 为什么适合 |
|---|---|
| Coding Agent | 需要控制代码修改、测试、PR、回滚 |
| 多工具 Agent | 需要管理工具调用边界 |
| 高质量 Skill 系统 | 需要标准结构、触发条件、eval、测试 |
| Agent 工作流自动化 | 需要可复现、可观察、可恢复 |
| AI 生成内容质量控制 | 需要验收标准、评估器、反馈闭环 |
| 企业级 Agent 系统 | 需要权限、审计、安全、沙箱、CI/CD |

示例：构建一个 Amazon 广告分析 Agent。

Harness Engineering 关注：

```text
- Agent 能读取哪些数据？
- 输入数据格式是什么？
- 分析流程是否固定？
- 如何判断诊断结论是否靠谱？
- 是否有错误触发测试？
- 是否有输出格式测试？
- 是否有 eval 检查推理质量？
- 是否能把人工反馈沉淀回规则？
```

---

## 7. 各自边界

## 7.1 敏捷开发的边界

### 敏捷能解决

```text
- 需求如何拆解
- 优先级如何排序
- 迭代节奏如何组织
- 团队如何协作
- 用户反馈如何进入下一轮开发
- 什么叫完成
```

### 敏捷不能自动解决

```text
- 代码质量差
- 测试覆盖不足
- Agent 输出漂移
- 工具调用混乱
- 上下文污染
- CI 不稳定
- 评估标准缺失
```

结论：

> **敏捷没有 Harness，容易变成“流程敏捷，质量不敏捷”。**

也就是：会开 Sprint Planning、Daily Scrum、Review、Retro，但每次交付还是不稳定。

## 7.2 Harness Engineering 的边界

### Harness 能解决

```text
- Agent 如何稳定执行
- 输出如何验证
- 错误如何发现
- 上下文如何控制
- 工具如何约束
- 流程如何复现
- 失败如何恢复
```

### Harness 不能替代

```text
- 用户真正要什么
- 哪个需求优先级最高
- 功能有没有商业价值
- 是否应该砍掉某个方向
- 团队如何协作
- 什么时候发布
```

结论：

> **Harness 没有敏捷，容易变成“技术很稳，但方向不一定对”。**

也就是：Agent 很规范、测试很多、流程很漂亮，但可能在高效地做一个用户并不需要的东西。

---

## 8. 在 Agent 工程中的组合方法

| 阶段 | 用敏捷开发解决 | 用 Harness Engineering 解决 |
|---|---|---|
| 需求发现 | 用户问题、场景、优先级 | 输入模板、需求澄清器 |
| 任务拆解 | User Story、Backlog、Sprint | Agent task schema、上下文包 |
| 执行 | 迭代交付节奏 | Tool use、workflow、sandbox |
| 验收 | DoD、Review | tests、evals、verifier |
| 复盘 | Retro、流程改进 | 规则固化、prompt 更新、工具升级 |
| 沉淀 | 方法论、知识库 | SKILL.md、references、scripts、evals |

### 8.1 一个可复用组合框架

```text
1. 用敏捷定义价值
   - 用户是谁？
   - 痛点是什么？
   - 本轮迭代交付什么？
   - 如何判断有价值？

2. 用 Harness 定义执行
   - Agent 需要什么上下文？
   - 可以调用哪些工具？
   - 执行步骤是什么？
   - 哪些节点必须验证？

3. 用敏捷获取反馈
   - 用户是否接受？
   - 需求是否需要调整？
   - 下一轮优先做什么？

4. 用 Harness 固化改进
   - 哪些规则要写入 instruction？
   - 哪些错误要变成 test？
   - 哪些质量标准要变成 eval？
   - 哪些流程要脚本化或自动化？
```

---

## 9. 常见误区

| 误区 | 错误点 | 正确理解 |
|---|---|---|
| 有了 Agent，就不需要敏捷 | 把执行效率等同于方向正确 | Agent 提高执行吞吐量，但更需要敏捷判断做什么、为什么做、先做什么 |
| 有了 Scrum，Agent 工程就可控 | 把项目节奏等同于执行控制 | 敏捷提供反馈节奏，但不自动提供上下文、工具边界、eval、沙箱和质量门禁 |
| Harness Engineering = 写测试 | 把 harness 简化为 test | 测试只是 Harness 的一部分，还包括上下文、工具、权限、流程、反馈、日志、回滚 |
| Harness 越复杂越好 | 把工程控制做成过度系统 | Harness 应该围绕高风险、高频、高价值任务建设 |
| 敏捷只适合人类团队 | 忽略人机协作场景 | Agent 工程同样需要需求池、迭代节奏、验收标准和复盘机制 |

---

## 10. 决策判断表

当你不知道该用敏捷思维还是 Harness 思维时，可以用下面的判断表。

| 当前问题 | 更偏向使用 |
|---|---|
| 不知道用户真正要什么 | 敏捷开发 |
| 不知道本周应该先做什么 | 敏捷开发 |
| 团队协作混乱 | 敏捷开发 |
| 功能做出来没人用 | 敏捷开发 |
| Agent 经常乱改文件 | Harness Engineering |
| Agent 输出格式不稳定 | Harness Engineering |
| Agent 工具调用不可控 | Harness Engineering |
| Agent 执行后无法验证对错 | Harness Engineering |
| 每次都靠人工重复提醒 Agent | Harness Engineering |
| 需求对了，但实现质量不稳 | 敏捷 + Harness |
| 执行很稳，但方向不确定 | 敏捷 + Harness |

---

## 11. 最终总图谱

```text
高质量 Agent 工程
│
├── 敏捷开发：产品交付系统
│   ├── 需求发现
│   ├── Backlog 管理
│   ├── User Story
│   ├── Sprint 节奏
│   ├── Review 反馈
│   ├── Retro 复盘
│   └── 持续交付用户价值
│
└── Harness Engineering：执行控制系统
    ├── Context 管理
    ├── Tool Contract
    ├── Workflow
    ├── Sandbox
    ├── Test
    ├── Eval
    ├── Logs / Trace
    ├── Human Review
    └── 持续提升 Agent 执行可靠性
```

---

## 12. 最终总结

| 结论 | 说明 |
|---|---|
| 敏捷开发管方向和节奏 | 解决做什么、为什么做、什么时候交付、如何反馈 |
| Harness Engineering 管执行和质量 | 解决怎么执行、怎么验证、怎么纠偏、怎么复现 |
| 敏捷不是 Harness 的替代品 | 敏捷不能自动保证 Agent 执行质量 |
| Harness 不是敏捷的替代品 | Harness 不能自动保证产品方向正确 |
| 二者结合才适合 Agent 工程 | 敏捷控制价值流，Harness 控制执行流 |

最终压缩为一句话：

> **用敏捷开发保证 Agent 工程持续走在正确方向上；用 Harness Engineering 保证 Agent 在这个方向上稳定、可控、可验证地执行。**

---

## 13. 参考来源

- Agile Manifesto: https://agilemanifesto.org/
- Agile Alliance - 12 Principles: https://agilealliance.org/agile101/12-principles-behind-the-agile-manifesto/
- Scrum Guide: https://scrumguides.org/scrum-guide.html
- Martin Fowler - Harness Engineering: https://martinfowler.com/articles/harness-engineering.html
- OpenAI - Harness Engineering: https://openai.com/index/harness-engineering/
