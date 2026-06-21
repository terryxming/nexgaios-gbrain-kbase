---
title: 'Skill 工程化与产品化：阶段一｜认知边界与概念地图'
status: raw
created: '2026-06-02 22:32'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Skill'
  - 'MCP'
  - 'LLM'
  - 'Knowledge-Base'
---

# Skill 工程化与产品化：阶段一｜认知边界与概念地图

## 0. 阶段定位

阶段一的目标不是立即编写 Skill，而是建立判断框架：什么是 Skill，Skill 解决什么问题，和 Prompt、Agent、Tool、API、MCP、Workflow、RAG 等概念分别是什么关系，以及什么任务值得被 Skill 化。

这一阶段完成后，应具备三类能力：

1. 能解释 Skill 的本质，而不是把 Skill 简化成“高级提示词”。
2. 能区分 Skill、Prompt、Agent、Tool、API、MCP、RAG、Workflow 的职责边界。
3. 能判断一个业务任务是否适合沉淀为 Skill。

---

## 第 0 章：为什么需要 Skill

### 0.1 重复 Prompt 的问题

在日常 AI 使用中，很多任务会反复出现，例如：

- 将对话整理成知识库 Markdown
- 将产品卖点改写成 Amazon A+ 文案
- 将用户评论拆解成痛点、需求、卖点、风险
- 将产品想法拆成 SDD、BDD、TDD
- 将设计需求整理成生图提示词
- 将杂乱 Prompt 清洁成可维护指令

如果每次都重新写 Prompt，会出现几个问题：

| 问题 | 表现 | 后果 |
|---|---|---|
| 表达不稳定 | 每次写法不同 | 输出质量波动 |
| 经验难复用 | 方法只存在于单次对话 | 不能沉淀成资产 |
| 边界不清楚 | 没写清楚做什么、不做什么 | AI 容易过度发挥 |
| 输出难验收 | 没有固定格式和标准 | 结果可用性差 |
| 团队难协作 | 每个人都有自己的提示词 | 标准不一致 |

Prompt 的核心问题不是“不能用”，而是“难以长期复用、测试、共享、迭代”。

### 0.2 Skill 解决的核心问题

Skill 的核心价值是：

> 将可重复的 AI 工作方法，封装成可复用、可共享、可维护、可测试的能力包。

OpenAI 将 ChatGPT Skills 定义为可复用、可共享的工作流，用于告诉 ChatGPT 如何更一致地完成特定任务；Skill 可以包含 instructions、examples 和 code。Codex 的 Agent Skills 文档则进一步强调，Skill 可以把 instructions、resources 和 optional scripts 打包起来，让 Codex 更可靠地执行特定工作流。

Skill 解决的是“能力沉淀”问题：

| 没有 Skill | 有 Skill |
|---|---|
| 每次重新写 Prompt | 一次封装，多次复用 |
| 依赖个人表达能力 | 依赖结构化能力包 |
| 难以团队共享 | 可以安装、共享、发布 |
| 难以测试 | 可以建立测试样例 |
| 难以维护 | 可以版本化迭代 |

### 0.3 Skill 的本质

Skill 的本质不是“把 Prompt 写长一点”，而是把一套可重复的专业工作方法封装成 Agent 能理解、能选择、能执行的能力模块。

更精确地说，Skill 至少包含四层信息：

1. **何时使用**：通过 `name` 和 `description` 让 Agent 判断是否该调用。
2. **如何执行**：通过 `SKILL.md` 中的步骤、原则、边界、示例指导执行。
3. **需要什么资料**：通过 `references/`、`assets/` 等资源补充上下文。
4. **哪些操作应交给代码**：通过 `scripts/` 处理稳定、重复、确定性的任务。

### 0.4 Skill 在 Agent 时代的位置

Agent 时代的关键变化是：AI 不再只是回答问题，而是开始承担多步骤任务执行。任务执行需要的不只是“回答能力”，还包括：

- 选择正确方法
- 调用正确工具
- 遵守固定流程
- 读取参考资料
- 处理异常路径
- 输出可验收结果

Skill 正是给 Agent 使用的“专业方法包”。

可以用一个生活化类比理解：

| 类比对象 | AI 系统中的对应物 |
|---|---|
| 员工 | Agent |
| 工具箱里的工具 | Tool / API / MCP |
| 公司 SOP 手册 | Skill |
| 资料库 | Knowledge / RAG |
| 临时口头交代 | Prompt |

员工本身有执行能力，工具箱能帮他做动作，资料库能提供信息，但如果没有 SOP，执行结果就会靠个人理解。Skill 的作用就是把 SOP 变成 Agent 可调用的能力模块。

---

## 第 1 章：Skill 的定义

### 1.1 官方视角下的 Skill

不同平台对 Skill 的表述略有差异，但核心高度一致。

| 来源 | 定义重点 |
|---|---|
| OpenAI ChatGPT Skills | 可复用、可共享的工作流；帮助 ChatGPT 更一致地完成特定任务；可包含 instructions、examples、code |
| OpenAI Codex Agent Skills | 用于扩展 Codex 的任务特定能力；将 instructions、resources、optional scripts 打包，使 Codex 可靠执行工作流 |
| Agent Skills Open Standard | 以 `SKILL.md` 为核心的目录结构；包含 `name`、`description`、instructions，并可附带 scripts、references、assets |
| Anthropic Agent Skills | 通过渐进式披露，让 Agent 按需加载元数据、主说明、引用文件和脚本 |

归纳后的统一定义：

> Skill 是一种面向 AI Agent 的可复用能力包，用来封装某类任务的触发条件、执行步骤、参考资料、输出标准、边界规则和可选脚本。

### 1.2 Skill 的基本结构

一个典型 Skill 通常是一个文件夹：

```text
my-skill/
├── SKILL.md
├── references/
│   └── reference.md
├── scripts/
│   └── helper.py
├── assets/
│   └── template.md
└── tests/
    └── cases.md
```

其中最核心的是 `SKILL.md`。

一个最小 Skill 可以只有：

```markdown
---
name: review-analyzer
description: 当需要分析产品评论，用于识别用户痛点、购买动机、投诉问题、功能需求和产品改进机会时使用。
---

请按照以下步骤执行：  
1. 按主题对评论内容进行分类。  
2. 提取重复出现的用户痛点。  
3. 识别正向购买驱动因素。  
4. 总结产品改进机会。  
5. 以结构化表格输出分析结果。
```

### 1.3 Skill 的四个必要问题

设计 Skill 前必须回答四个问题：

| 问题               | 对应 Skill 部分                                            |
| ---------------- | ------------------------------------------------------ |
| 这个 Skill 解决什么任务？ | name、description、任务目标                                  |
| 什么时候应该调用？        | description、触发条件                                       |
| 调用后怎么做？          | instructions（说明）、workflow steps（工作流程步骤）                |
| 做到什么程度算合格？       | output contract（输出规范）、quality criteria（质量标准）、tests（测试） |

如果这四个问题答不清楚，就不适合直接写 Skill。

### 1.4 Skill 的三个层级

| 层级 | 特征 | 示例 |
|---|---|---|
| 指令型 Skill | 只有 `SKILL.md`，主要靠步骤和规则 | 文案改写、知识库整理 |
| 资源型 Skill | 附带 references / assets | 品牌文案规范、设计规范、合同审查 |
| 脚本型 Skill | 附带 scripts，执行确定性任务 | 数据清洗、文件转换、格式校验 |

入门阶段优先掌握指令型 Skill；进阶阶段学习资源型 Skill；专家阶段学习脚本型 Skill 与 Skill Library。

---

## 第 2 章：Skill 与 Prompt 的区别

### 2.1 Prompt 是临时指令，Skill 是长期能力

Prompt 和 Skill 都会影响 AI 行为，但它们处在不同层级。

| 维度 | Prompt | Skill |
|---|---|---|
| 本质 | 一次性指令 | 可复用能力包 |
| 生命周期 | 当前对话或当前任务 | 可安装、可共享、可迭代 |
| 结构 | 通常是一段文本 | 文件夹 + `SKILL.md` + 可选资源 |
| 触发方式 | 用户直接输入 | Agent 根据任务自动或显式调用 |
| 可维护性 | 较弱 | 较强 |
| 可测试性 | 通常没有 | 可以建立测试集 |
| 团队协作 | 复制粘贴为主 | 可发布、共享、版本管理 |

一句话：

> Prompt 是“这次怎么做”，Skill 是“以后遇到这类任务都怎么做”。

### 2.2 Prompt 适合什么

Prompt 适合：

- 一次性任务
- 临时创意
- 不确定探索
- 低频需求
- 还没有稳定流程的任务

例如：

> 帮我想 10 个儿童卡拉 OK 产品的广告标题。

这种任务可以直接用 Prompt，不一定要做成 Skill。

### 2.3 Skill 适合什么

Skill 适合：

- 高频重复任务
- 有固定流程的任务
- 有明确输出格式的任务
- 有团队协作需求的任务
- 需要稳定质量的任务
- 需要沉淀经验的任务

例如：

> 每次输入产品卖点后，固定输出 Amazon A+ 模块结构、主标题、副文案、画面构图、设计验收标准。

这类任务适合做成 Skill。

### 2.4 从 Prompt 到 Skill 的判断标准

一个 Prompt 是否值得 Skill 化，可以用“五问法”：

| 问题 | 如果答案是“是” |
|---|---|
| 这个任务会反复出现吗？ | 值得 Skill 化 |
| 每次输出是否需要固定结构？ | 值得 Skill 化 |
| 是否有明确的好坏标准？ | 值得 Skill 化 |
| 是否经常因为漏步骤出错？ | 值得 Skill 化 |
| 是否希望团队其他人也按同一方法执行？ | 值得 Skill 化 |

只满足 1 个条件，可以先继续用 Prompt；满足 3 个以上，通常应考虑 Skill 化。

---

## 第 3 章：Skill 与 Agent 的区别

### 3.1 Agent 是执行者，Skill 是能力包

Agent 和 Skill 最容易混淆。可以这样区分：

| 概念 | 作用 |
|---|---|
| Agent | 接收目标、理解任务、规划步骤、调用工具、执行工作 |
| Skill | 给 Agent 提供某类任务的专业方法、规则、资源和脚本 |

Agent 像一个“会做事的人”，Skill 像这个人可以查阅和执行的“专业作业手册”。

### 3.2 没有 Skill 的 Agent

没有 Skill 的 Agent 主要依赖：

- 系统提示词
- 当前用户输入
- 模型已有知识
- 可用工具说明

问题是：当任务涉及公司流程、个人偏好、固定格式、业务规范时，Agent 不一定知道该怎么稳定执行。

例如：

> 把这段对话沉淀成我的 LLM Wiki Markdown。

如果没有 Skill，Agent 可能不知道：

- 应采用什么知识库风格
- 是否要避免“你提到”这种措辞
- 标题层级如何设计
- 是否要包含误区、边界、应用场景
- 输出是否应为中立百科体

### 3.3 有 Skill 的 Agent

有 Skill 后，Agent 可以按 Skill 中沉淀的方法执行：

```text
用户任务
→ Agent 判断任务类型
→ 匹配 Skill description
→ 加载 SKILL.md
→ 按步骤执行
→ 必要时读取 references / assets
→ 必要时运行 scripts
→ 输出符合标准的结果
```

这使 Agent 从“临场发挥”变成“按标准流程执行”。

### 3.4 Skill 不是替代 Agent

Skill 不负责自主决策整个任务目标，它更像 Agent 的能力模块。

| 错误理解 | 正确理解 |
|---|---|
| Skill 就是 Agent | Skill 是 Agent 可调用的能力包 |
| 有 Skill 就不需要 Agent | Skill 需要 Agent 来选择和执行 |
| Agent 越强就不需要 Skill | Agent 越强，越需要高质量 Skill 来约束复杂任务 |
| Skill 会自动完成所有事 | Skill 只是指导执行，仍需要上下文、工具、权限和判断 |

### 3.5 Agent 与 Skill 的协作关系

可以用一句话概括：

> Agent 负责“做事”，Skill 负责“教它按什么方法做事”。

更工程化地说：

| 层级 | 负责内容 |
|---|---|
| 用户 | 提出目标 |
| Agent | 理解目标、规划执行 |
| Skill | 提供专业方法与流程 |
| Tool / API / MCP | 执行具体动作或连接外部系统 |
| Eval | 判断结果质量 |

---

## 第 4 章：Skill 与 Tool / API / MCP 的区别

### 4.1 Tool 是动作能力

Tool 解决的是“能不能做某个动作”。

例如：

- 搜索网页
- 读取文件
- 创建日历事件
- 发送邮件
- 查询数据库
- 运行 Python 脚本

Tool 的本质是可调用能力，通常有明确输入和输出。

### 4.2 API 是系统接口

API 是外部系统暴露的接口，通常由软件系统提供。

例如：

- Amazon API 查询商品数据
- 飞书 API 写入多维表格
- Gmail API 发送邮件
- Notion API 创建页面

API 解决的是系统之间如何通信。

### 4.3 MCP 是连接协议

MCP 的作用是让模型或 Agent 以标准方式连接外部工具、数据源和系统。

可以把 MCP 理解为：

> 给 Agent 接入外部世界的一套标准插座。

它不直接规定某个业务任务怎么做，而是让 Agent 能访问外部能力。

### 4.4 Skill 是方法封装

Skill 解决的是“面对某类任务应该怎么做”。

例如同样是“分析 Amazon Review”：

| 层级 | 负责什么 |
|---|---|
| API / MCP | 抓取 Review 数据 |
| Tool | 读取、清洗、分类数据 |
| Skill | 规定分析维度、分类逻辑、输出格式、判断标准 |
| Agent | 组织整个任务执行 |

### 4.5 四者关系

可以用下面的结构理解：

```text
用户目标
  ↓
Agent：理解任务并规划
  ↓
Skill：提供完成该任务的方法
  ↓
Tool / API / MCP：执行具体动作或连接外部系统
  ↓
输出结果
```

### 4.6 一个具体例子

任务：输入 ASIN，抓取 Amazon 评论，生成用户痛点分析。

| 模块 | 具体作用 |
|---|---|
| Agent | 判断任务需要抓评论、清洗、分类、总结 |
| Skill | 定义 Review 分析框架：痛点、动机、抱怨、场景、功能需求、改进机会 |
| MCP / API | 连接评论抓取工具或数据源 |
| Tool / Script | 清洗评论、去重、统计关键词 |
| Output Contract | 输出表格、洞察摘要、产品建议 |

如果只有 API，没有 Skill，系统只能拿到数据，不知道怎么分析。

如果只有 Skill，没有 API / Tool，系统知道怎么分析，但拿不到数据或无法稳定处理大批量内容。

---

## 第 5 章：Skill 的适用边界

### 5.1 什么任务适合做 Skill

适合 Skill 化的任务通常具备以下特征：

| 特征 | 说明 | 示例 |
|---|---|---|
| 高频 | 经常重复出现 | 每周整理竞品评论 |
| 稳定 | 方法相对固定 | 合同低级错误检查 |
| 可流程化 | 能拆成步骤 | A+ 图需求整理 |
| 可验收 | 有明确好坏标准 | 输出固定 Markdown 结构 |
| 可复用 | 不只适用于一次任务 | 说明书审查、客服回复 |
| 可迁移 | 方法能迁移到类似任务 | Review 分析迁移到问卷分析 |

判断公式：

> 高频 × 稳定 × 可验收 = Skill 化优先级高。

### 5.2 什么任务不适合做 Skill

不适合 Skill 化的任务：

| 不适合类型 | 原因 | 更适合方式 |
|---|---|---|
| 一次性问题 | 没有复用价值 | 普通 Prompt |
| 高度开放创意 | 过度规则会限制发散 | Prompt + 参考案例 |
| 尚未探索清楚的问题 | 还没有稳定流程 | 先用对话探索 |
| 目标经常变化的任务 | Skill 容易过期 | 先沉淀为备忘或模板 |
| 需要强实时信息的任务 | Skill 本身不保证最新数据 | Skill + Web/API/MCP |
| 高风险自动执行任务 | 需要权限、安全、审计 | Agent + Tool 权限治理 + 人工确认 |

### 5.3 Skill 化优先级矩阵

| 任务类型 | 是否适合 Skill 化 | 原因 |
|---|---|---|
| 每天重复、格式固定 | 非常适合 | 投入产出比高 |
| 每周重复、需要专业判断 | 适合 | 可沉淀方法论 |
| 偶尔出现、但流程复杂 | 可考虑 | 如果错误成本高，值得做 |
| 一次性创意发散 | 不优先 | Prompt 更灵活 |
| 没有明确标准的探索 | 不优先 | 先建立方法再封装 |

### 5.4 判断任务是否值得 Skill 化的 10 个问题

1. 这个任务是否会重复出现？
2. 是否每次都要按相似步骤完成？
3. 是否经常因为漏步骤导致结果不可用？
4. 是否需要固定输出格式？
5. 是否有明确质量标准？
6. 是否需要引用固定资料、规范或模板？
7. 是否需要团队成员按同一标准执行？
8. 是否有可积累的正例、反例、边界案例？
9. 是否能通过测试样例判断效果？
10. 是否能随着业务反馈持续迭代？

满足 7 个以上，优先 Skill 化。

满足 4–6 个，可以先做轻量 Skill。

满足 3 个以下，暂时用 Prompt 或模板即可。

### 5.5 Skill 的边界意识

高质量 Skill 不只写“应该做什么”，还必须写“不应该做什么”。

例如一个“Amazon A+ 图片需求整理 Skill”需要明确：

| 应该做 | 不应该做 |
|---|---|
| 拆解卖点 | 不虚构不存在的功能 |
| 输出画面结构 | 不直接承诺平台合规结果 |
| 给出生图提示词 | 不替代最终设计审核 |
| 给出验收标准 | 不忽略品牌和尺寸限制 |

Skill 的边界越清楚，Agent 的执行越稳定。

---

## 阶段一总结

阶段一建立了 Skill 的认知底座：

1. Skill 的本质是可复用能力包，不是普通 Prompt。
2. Skill 的价值在于把重复 AI 工作方法沉淀成可维护资产。
3. Prompt 负责临时表达，Skill 负责长期复用。
4. Agent 是执行者，Skill 是给 Agent 使用的方法模块。
5. Tool / API / MCP 提供动作和连接能力，Skill 提供任务执行方法。
6. 适合 Skill 化的任务通常高频、稳定、可流程化、可验收、可复用。
7. 不适合 Skill 化的任务通常一次性、探索性强、目标未定或缺乏稳定标准。

阶段一的核心判断句：

> 不是所有 Prompt 都值得变成 Skill；只有那些高频、稳定、可验收、可复用的 AI 工作方法，才值得工程化沉淀为 Skill。

---

## 阶段一掌握检查

完成阶段一后，应能回答以下问题：

1. Skill 和 Prompt 的核心区别是什么？
2. Skill 和 Agent 的关系是什么？
3. Skill、Tool、API、MCP 各自负责什么？
4. 为什么 `description` 对 Skill 很重要？
5. 什么样的任务值得 Skill 化？
6. 什么样的任务暂时不该 Skill 化？
7. 一个 Skill 如果没有边界，会出现什么问题？
8. 为什么 Skill 是能力资产，而不是普通文本？

若能用自己的业务场景举出 3 个适合 Skill 化的任务、3 个不适合 Skill 化的任务，并能说明原因，则阶段一已经达到可进入下一阶段的标准。

---

## 可沉淀的最小方法论

```text
判断一个任务是否适合做 Skill：

1. 是否高频？
2. 是否稳定？
3. 是否可流程化？
4. 是否可验收？
5. 是否可复用？
6. 是否需要团队统一？
7. 是否能通过案例测试？

满足越多，越值得 Skill 化。
```

---

## 参考资料

- OpenAI Help Center, “Skills in ChatGPT”: https://help.openai.com/en/articles/20001066-skills-in-chatgpt
- OpenAI Developers, “Agent Skills – Codex”: https://developers.openai.com/codex/skills
- Agent Skills, “Agent Skills Overview”: https://agentskills.io/home
- Anthropic Engineering, “Equipping agents for the real world with Agent Skills”: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- Microsoft Learn, “Agent Skills”: https://learn.microsoft.com/en-us/agent-framework/agents/skills
