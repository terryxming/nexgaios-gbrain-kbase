---
title: 'Skill 工程化与产品化｜阶段三：从 Prompt 到 Skill'
status: raw
created: '2026-06-04 23:31'
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
  - '敏捷开发'
---

# Skill 工程化与产品化｜阶段三：从 Prompt 到 Skill

## 阶段定位

阶段三关注从一次性 Prompt 到可复用 Skill 的转化方法。

Prompt 适合临时表达意图，Skill 适合沉淀稳定能力。将 Prompt 改造成 Skill，不是把原 Prompt 复制进 `SKILL.md`，而是要完成一次工程化重构：识别任务、拆解目标、定义输入、约束输出、设计步骤、补充边界、加入示例和测试。

OpenAI Codex Skills 将 Skill 定义为包含 `SKILL.md` 的目录，并可附带 scripts、references 和 assets；`SKILL.md` 至少需要包含 `name` 与 `description`。Agent Skills 开放标准也将 Skill 视为一个以 `SKILL.md` 为核心、可附带参考资料、模板和脚本的文件夹。OpenAI skill-creator 的创建流程强调，应先通过具体示例理解 Skill，再规划 scripts、references、assets，初始化、编辑、校验并基于真实使用迭代。

阶段三的核心任务是：

> 将“这次让 AI 怎么做”的 Prompt，重构成“以后遇到这类任务都能稳定执行”的 Skill。

---

# 第 12 章：识别可 Skill 化任务

## 12.1 什么是可 Skill 化任务

可 Skill 化任务，是指适合被封装成可复用能力包的 AI 工作任务。

它通常具备以下特征：

| 特征 | 说明 | 示例 |
|---|---|---|
| 高频 | 会反复出现 | 每次对话后沉淀知识库 |
| 稳定 | 执行方法相对固定 | 按固定结构整理 Markdown |
| 可流程化 | 能拆成步骤 | 先识别主题，再拆概念、边界、误区 |
| 可验收 | 有明确好坏标准 | 输出必须符合知识库格式 |
| 可复用 | 不只服务一次任务 | 所有 AI 工程主题都可套用 |
| 可边界化 | 能说明不做什么 | 不写成聊天总结，不使用口语化表达 |

判断公式：

```text
高频 × 稳定 × 可流程化 × 可验收 = Skill 化价值高
```

## 12.2 Prompt 不等于 Skill 原料

不是所有 Prompt 都适合直接改造成 Skill。

Prompt 只是用户当下表达需求的文本，它里面往往混合了：

- 真实任务
- 临时偏好
- 情绪表达
- 重复要求
- 口语化补充
- 不完整约束
- 一次性上下文

Skill 需要提取其中可复用的部分，删除一次性内容。

例如：

```text
你是知识管理专家，把我们刚才聊到的内容整理成 .md 文件，我要放到我的 llm-wiki 知识库中。要求结构清晰、完整、系统，别太口语化。
```

其中可复用内容是：

```text
将对话内容整理成适合 LLM Wiki 的 Markdown 知识条目。
要求结构清晰、中立、可复用、去除口语化表达。
```

一次性内容是：

```text
我们刚才聊到的内容
```

Skill 应沉淀前者，而不是复制后者。

## 12.3 识别任务的五个问题

识别一个任务是否值得 Skill 化，可以先问五个问题：

| 问题 | 判断重点 |
|---|---|
| 这个任务是否会反复出现？ | 高频性 |
| 每次是否都按类似步骤完成？ | 稳定性 |
| 输出是否需要固定结构？ | 格式约束 |
| 是否能判断输出好坏？ | 可验收性 |
| 是否能迁移到类似场景？ | 可复用性 |

如果五个问题中有三个以上答案为“是”，通常值得做成轻量 Skill。

## 12.4 适合 Skill 化的任务类型

| 类型 | 示例 | Skill 化价值 |
|---|---|---|
| 内容整理 | 对话转知识库、会议纪要转文档 | 高 |
| 文案生成 | Amazon A+ 文案、五点描述、广告标题 | 高 |
| 审查检查 | 说明书审查、合同低级错误检查 | 高 |
| 数据分析 | Review 分类、竞品分析、广告数据归因 | 高 |
| 需求拆解 | SDD、BDD、TDD、Sprint Backlog | 高 |
| 设计转译 | 卖点转画面需求、生图提示词、验收标准 | 高 |
| 格式转换 | Markdown 清洗、表格规范化 | 高 |

## 12.5 不适合立即 Skill 化的任务

| 类型 | 原因 | 更适合方式 |
|---|---|---|
| 一次性灵感发散 | 没有稳定流程 | 普通 Prompt |
| 目标还没想清楚 | 无法设计边界 | 先对话澄清 |
| 强依赖实时信息 | Skill 本身不保证数据新鲜 | Skill + Web/API/MCP |
| 高度主观审美 | 标准难固化 | 先沉淀参考案例 |
| 低频琐碎任务 | 维护成本高于收益 | 普通模板 |

## 12.6 Skill 化优先级矩阵

| 高频程度 | 流程稳定度 | 建议 |
|---|---|---|
| 高频 | 稳定 | 优先 Skill 化 |
| 高频 | 不稳定 | 先沉淀流程，再 Skill 化 |
| 低频 | 稳定 | 可做模板，不急于 Skill 化 |
| 低频 | 不稳定 | 不建议 Skill 化 |

## 12.7 本章小结

识别可 Skill 化任务的关键，不是看任务是否“重要”，而是看它是否值得被复用、测试和维护。

一句话：

> 只有高频、稳定、可流程化、可验收的 AI 工作方法，才值得从 Prompt 升级为 Skill。

---

# 第 13 章：拆解任务目标

## 13.1 为什么先拆目标

很多低质量 Skill 的问题不是写得不够长，而是目标不清。

目标不清会导致：

- Skill 范围过大
- 输出结果漂移
- 步骤无法验证
- description 难以触发
- 和其他 Skill 职责重叠

拆目标的目的，是把一句模糊需求变成可执行任务定义。

## 13.2 任务目标四要素

一个 Skill 的任务目标至少要定义四件事：

| 要素 | 说明 | 示例 |
|---|---|---|
| 用户 | 谁会使用这个 Skill | 运营、设计师、知识管理者、开发者 |
| 对象 | 处理什么材料 | 对话、评论、文案、PDF、截图、需求草稿 |
| 动作 | 要完成什么处理 | 分析、整理、改写、审查、转化、提取 |
| 产物 | 最终输出什么 | Markdown、表格、报告、提示词、测试用例 |

公式：

```text
为谁 + 处理什么 + 做什么动作 + 输出什么产物
```

## 13.3 目标拆解示例：知识库沉淀

原始 Prompt：

```text
你是知识管理专家，把我们聊到的内容沉淀成 .md 文件，我要放到 llm-wiki 知识库中。
```

拆解后：

| 要素 | 内容 |
|---|---|
| 用户 | LLM Wiki 知识库维护者 |
| 对象 | AI 对话、课程内容、解释文本 |
| 动作 | 提取稳定知识，去除对话噪音，结构化整理 |
| 产物 | 中立百科体 Markdown 知识条目 |

Skill 目标可以写成：

```text
Convert AI conversations, explanations, or notes into neutral, reusable Markdown knowledge entries for an LLM Wiki.
```

## 13.4 目标拆解示例：Amazon Review 分析

原始 Prompt：

```text
输入 ASIN，通过工具抓评论，然后帮我做 Review 分析。
```

拆解后：

| 要素 | 内容 |
|---|---|
| 用户 | Amazon 运营、产品经理 |
| 对象 | 商品评论数据 |
| 动作 | 分类、提取痛点、识别卖点、总结机会 |
| 产物 | Review 洞察报告、痛点表、产品优化建议 |

Skill 目标可以写成：

```text
Analyze Amazon product reviews to identify user pain points, praise drivers, objections, feature requests, and product improvement opportunities.
```

## 13.5 目标边界

拆目标时必须同步定义边界。

| 目标 | 边界 |
|---|---|
| 整理知识库 | 不写成聊天纪要，不保留口语废话 |
| Review 分析 | 不虚构不存在的评论，不替代市场调研结论 |
| 文案生成 | 不编造功能，不做法律合规承诺 |
| 设计提示词 | 不替代最终设计审核，不保证平台审核通过 |

没有边界的目标，不适合进入 Skill 结构设计。

## 13.6 目标粒度

目标粒度要避免两个极端。

### 过大

```text
帮助我做 Amazon 运营。
```

问题：

- 范围过宽
- 无法设计输出格式
- 容易触发冲突

### 过小

```text
只分析 Amazon 评论里关于蓝牙连接失败的 1 星差评。
```

问题：

- 复用范围过窄
- 不值得单独成 Skill

### 合适

```text
分析 Amazon 评论，提取用户痛点、好评驱动、功能请求和产品优化机会。
```

## 13.7 本章小结

拆目标的本质，是把模糊意图变成可执行任务定义。

高质量 Skill 目标应满足：

```text
用户明确 + 对象明确 + 动作明确 + 产物明确 + 边界明确
```

---

# 第 14 章：拆解输入

## 14.1 为什么要拆输入

Prompt 通常默认上下文充足，但 Skill 必须面对多种输入情况。

用户可能提供：

- 完整材料
- 半成品草稿
- 一个关键词
- 一个文件
- 一个链接
- 一个产品型号
- 一段模糊需求

如果 Skill 不定义输入要求，Agent 会在信息不足时乱猜。

## 14.2 输入分类

输入可以分为四类：

| 输入类型 | 说明 | 示例 |
|---|---|---|
| 必填输入 | 没有就无法完成任务 | 原始评论、原始文档、待整理对话 |
| 可选输入 | 有则提升质量 | 品牌语气、目标用户、输出长度 |
| 默认输入 | 缺失时可采用默认值 | Markdown 格式、中立语气 |
| 禁止输入 | 不应被接受或不应执行 | 要求虚构数据、绕过审核 |

## 14.3 输入契约

输入契约用于告诉 Agent：需要什么、缺什么怎么办。

模板：

```markdown
# Inputs

Required:
- [Required input 1]
- [Required input 2]

Optional:
- [Optional input 1]
- [Optional input 2]

Defaults:
- If [x] is missing, assume [y].
- If [z] is missing, infer from context only when safe.

Do not proceed when:
- [Condition 1]
- [Condition 2]
```

## 14.4 示例：LLM Wiki Skill 输入设计

```markdown
# Inputs

Required:
- Source content, such as conversation text, notes, or explanation material.

Optional:
- Topic title
- Target knowledge-base category
- Required sections
- Existing style guide

Defaults:
- If no title is provided, infer a concise title from the source content.
- Use neutral encyclopedia-style Markdown.
- Remove conversational filler by default.

Do not:
- Invent missing facts.
- Preserve user-assistant dialogue framing unless it is conceptually necessary.
```

## 14.5 示例：Amazon Review Skill 输入设计

```markdown
# Inputs

Required:
- Product review text, review export, or accessible review dataset.

Optional:
- ASIN
- Product category
- Target market
- Analysis goal
- Competitor comparison target

Defaults:
- If no analysis goal is provided, analyze pain points, positive drivers, objections, feature requests, and product improvement opportunities.

Do not:
- Fabricate reviews.
- Treat unverifiable data as confirmed market facts.
```

## 14.6 缺失输入处理

Skill 要明确缺失输入时的处理方式。

| 情况 | 处理方式 |
|---|---|
| 缺少核心材料 | 请求材料或输出框架 |
| 缺少标题 | 自动推断 |
| 缺少目标用户 | 从内容中推断，并标注假设 |
| 缺少输出格式 | 使用默认格式 |
| 缺少关键数据 | 不编造，标注缺失 |

## 14.7 默认假设设计

默认假设可以减少不必要追问，但必须可控。

好默认：

```text
如果未指定输出格式，默认使用 Markdown。
```

坏默认：

```text
如果没有数据，就根据常识补全。
```

默认假设的原则：

- 只默认格式、语气、结构等低风险内容
- 不默认事实、数据、承诺、法律判断
- 需要推断时，应说明推断来源

## 14.8 本章小结

拆输入的核心，是让 Skill 在不同输入完整度下都能稳定工作。

高质量输入设计公式：

```text
必填输入 + 可选输入 + 默认假设 + 缺失处理 + 禁止输入
```

---

# 第 15 章：拆解输出

## 15.1 为什么输出比步骤更重要

很多 Prompt 失败，不是因为 AI 不会做，而是因为输出无法直接使用。

Skill 必须定义输出产物，否则结果会出现：

- 结构漂移
- 粒度不一致
- 可读但不可用
- 没有验收标准
- 难以复制到工作流

输出定义就是 Skill 的交付标准。

## 15.2 输出契约

输出契约要回答：

| 问题 | 示例 |
|---|---|
| 输出是什么格式？ | Markdown、表格、JSON、清单、报告 |
| 包含哪些部分？ | 定义、边界、场景、误区、检查表 |
| 粒度到什么程度？ | 每个问题至少给出原因和改进方向 |
| 不应包含什么？ | 不要闲聊、不要虚构、不要泛泛而谈 |
| 如何判断合格？ | 可直接复制、可执行、可验收 |

模板：

```markdown
# Output Format

Return the output using this structure:

## Section 1
[Requirement]

## Section 2
[Requirement]

# Output Rules

The output must:
- [Rule 1]
- [Rule 2]

The output must not:
- [Forbidden output 1]
- [Forbidden output 2]
```

## 15.3 示例：LLM Wiki 输出设计

```markdown
# Output Format

Return a Markdown knowledge entry with this structure:

# [Title]

## Definition

## Knowledge Boundaries

## Adjacent Concepts

## Core Principles

## Application Scenarios

## Common Pitfalls

## Practical Checklist

# Output Rules

The output must:
- Use a neutral encyclopedia-style voice.
- Avoid referring to the original conversation.
- Preserve reusable concepts.
- Remove task-management language and conversational filler.
- Be suitable for direct storage in a knowledge base.
```

## 15.4 示例：Review 分析输出设计

```markdown
# Output Format

Return the analysis using this structure:

## Executive Summary

## Review Theme Table
| Theme | Positive Signals | Negative Signals | Evidence | Product Implication |

## Pain Points

## Purchase Motivations

## Feature Requests

## Product Improvement Opportunities

## Copywriting Angles

# Output Rules

The output must distinguish between:
- Directly observed review evidence
- Inferred product implications
- Suggested next actions
```

## 15.5 输出粒度

输出粒度决定结果是否可用。

### 粒度过粗

```text
用户不满意音质，需要优化。
```

问题：

- 没有具体问题
- 没有证据
- 没有动作建议

### 合适粒度

```text
部分用户反馈高音量下人声发闷，可能影响家庭派对场景下的演唱体验。建议在文案中强调智能降噪和低失真，同时检查高音量场景下的音频调校表现。
```

## 15.6 输出禁止项

Skill 应明确禁止输出内容。

| Skill 类型 | 禁止项 |
|---|---|
| 知识库 Skill | 不保留“我们聊到”“你的问题” |
| 电商文案 Skill | 不虚构认证、奖项、参数 |
| 合同审查 Skill | 不冒充法律意见 |
| Review 分析 Skill | 不把少量评论当作市场结论 |
| 设计提示词 Skill | 不加入未提供的品牌 Logo 或敏感元素 |

## 15.7 输出验收标准

输出标准可以写成检查清单。

示例：

```markdown
# Quality Criteria

The output is acceptable only if:
- It follows the requested structure.
- It can be used without reading the original conversation.
- It separates facts from assumptions.
- It avoids unsupported claims.
- It includes actionable next steps where appropriate.
```

## 15.8 本章小结

输出契约是 Skill 的交付边界。

高质量输出设计公式：

```text
格式 + 章节 + 粒度 + 禁止项 + 验收标准
```

---

# 第 16 章：拆解步骤

## 16.1 为什么要拆步骤

Prompt 通常只描述目标，而 Skill 必须描述稳定执行过程。

例如：

```text
帮我分析 Review。
```

这只是目标，不是步骤。

Skill 需要明确：

```text
先清洗评论 → 再分类主题 → 再提取痛点 → 再统计频次 → 再总结机会 → 再输出建议
```

步骤设计的目的，是降低结果随机性。

## 16.2 步骤设计原则

| 原则 | 说明 |
|---|---|
| 顺序清楚 | 先做什么，后做什么 |
| 动作具体 | 使用动词，而不是抽象形容词 |
| 单步单责 | 每一步只做一类动作 |
| 可检查 | 能判断是否完成 |
| 有分支 | 信息不足或目标冲突时有处理方式 |
| 有回退 | 无法完成时不乱编 |

## 16.3 步骤模板

```markdown
# Process

Follow these steps:
1. Identify the task type and confirm this skill is applicable.
2. Extract the relevant input materials.
3. Remove irrelevant or noisy content.
4. Classify the content into the required categories.
5. Generate the output according to the defined format.
6. Check the output against the quality criteria.
7. If key information is missing, state the limitation instead of inventing details.
```

## 16.4 示例：LLM Wiki Skill 步骤

```markdown
# Process

1. Identify the central topic from the source content.
2. Remove conversational filler, repeated instructions, greetings, and task-management language.
3. Extract reusable knowledge, including definitions, boundaries, adjacent concepts, principles, examples, and pitfalls.
4. Reorganize the extracted knowledge into a neutral Markdown structure.
5. Add practical checklists only when they help future reuse.
6. Remove references to the original conversation unless needed for historical context.
7. Review the final entry for clarity, neutrality, and knowledge-base suitability.
```

## 16.5 示例：Amazon A+ 设计需求 Skill 步骤

```markdown
# Process

1. Identify the product, target audience, selling points, and target image size.
2. Convert each selling point into a visual message.
3. Define the image hierarchy: main subject, supporting scene, proof points, and text area.
4. Generate a composition brief with layout, mood, background, props, and constraints.
5. Produce an image-generation prompt if requested.
6. Add design acceptance criteria, including clarity, claim support, visual hierarchy, and platform fit.
7. Mark any unsupported product claims that require verification.
```

## 16.6 分支逻辑

Skill 不应只覆盖理想输入，还要覆盖分支情况。

| 情况 | 分支处理 |
|---|---|
| 输入不足 | 输出框架或请求关键材料 |
| 目标冲突 | 按优先级处理，并说明冲突 |
| 格式不明确 | 使用默认格式 |
| 内容有风险 | 标注风险，不直接执行 |
| 数据不可信 | 标注来源限制 |

## 16.7 步骤中的判断与执行分工

Skill 需要区分“模型判断”和“脚本执行”。

| 任务 | 更适合模型 | 更适合脚本 |
|---|---:|---:|
| 判断用户意图 | 是 | 否 |
| 提取主题 | 是 | 部分 |
| 统计字数 | 否 | 是 |
| 校验 Markdown 标题层级 | 否 | 是 |
| 分类评论主题 | 是 | 部分 |
| 文件批量转换 | 否 | 是 |

Anthropic 的 Agent Skills 工程文章强调，Skill 可以包含代码，代码适合执行确定性、可重复的操作；这也是脚本型 Skill 的工程价值所在。

## 16.8 步骤设计误区

| 误区 | 问题 | 修正 |
|---|---|---|
| 步骤太抽象 | Agent 不知道如何执行 | 写成具体动作 |
| 步骤太多 | 增加认知负担 | 合并同类步骤 |
| 步骤无优先级 | 冲突时无法判断 | 写清优先顺序 |
| 只有正向路径 | 异常时乱编 | 加入失败处理 |
| 步骤和输出脱节 | 做了很多但产物不可用 | 每步服务最终输出 |

## 16.9 本章小结

拆步骤的本质，是把“希望 AI 做好”变成“让 AI 按流程稳定执行”。

高质量步骤设计公式：

```text
确认适用性 → 读取输入 → 清理噪音 → 分类处理 → 生成产物 → 质量检查 → 异常处理
```

---

# 第 17 章：把一个 Prompt 改造成 Skill

## 17.1 改造流程总览

从 Prompt 到 Skill，可以按七步完成：

```text
1. 提取真实任务
2. 删除一次性内容
3. 定义 Skill 目标
4. 设计 name 与 description
5. 拆解输入与输出
6. 设计执行步骤与边界
7. 加入示例与测试
```

OpenAI skill-creator 的流程强调：先用具体示例理解 Skill，再规划可复用内容，包括 scripts、references、assets；随后初始化、编辑、验证，并基于真实使用迭代。这说明 Skill 创建不是单次写作，而是一个设计、实现、校验、迭代的工程过程。

## 17.2 原始 Prompt 示例

```text
你是知识管理专家，将我们聊到的内容沉淀成 .md 文件，我要沉淀到我的 llm-wiki 知识库中。要求内容系统、完整、结构清晰，去掉废话，不要出现“你的问题”“我们刚才聊到”这种表达，要像知识库条目一样。
```

这个 Prompt 是一个很好的 Skill 原料，因为它具备：

- 高频：经常需要沉淀知识库
- 稳定：处理流程相似
- 输出固定：Markdown 文件
- 标准明确：中立、结构化、去口语化
- 可复用：不同主题都可以使用

## 17.3 第一步：提取真实任务

从原始 Prompt 中提取任务核心：

```text
将 AI 对话或解释内容转化为适合 LLM Wiki 的 Markdown 知识条目。
```

删除非核心表达：

| 原始表达 | 处理方式 |
|---|---|
| 你是知识管理专家 | 可转化为任务能力，不必保留角色扮演 |
| 我们聊到的内容 | 一次性上下文，删除 |
| 我要沉淀到我的 llm-wiki | 保留为目标场景 |
| 系统、完整、结构清晰 | 转化为质量标准 |
| 不要出现“你的问题” | 转化为约束 |

## 17.4 第二步：定义 Skill 名称

推荐名称：

```yaml
name: llm-wiki-writer
```

原因：

| 部分 | 作用 |
|---|---|
| `llm-wiki` | 场景明确 |
| `writer` | 动作明确 |
| 小写连字符 | 符合常见 Skill 命名习惯 |

不推荐：

```yaml
name: knowledge-helper
name: md-output
name: chat-summary
```

问题：

- 过泛
- 不知道目标格式
- 容易和普通总结混淆

## 17.5 第三步：设计 description

弱 description：

```yaml

description: Helps organize content into Markdown.
```

问题：

- 太宽泛
- 不能区分普通 Markdown 整理和知识库沉淀
- 没有边界

强 description：

```yaml

description: Use when converting AI conversations, explanations, or notes into neutral, reusable Markdown knowledge entries for an LLM Wiki. Trigger for requests to沉淀, summarize into .md, build knowledge-base entries, or convert discussion content into structured reusable notes. Do not use for casual summaries, marketing copy, or personal chat recaps.
```

这个 description 包含：

| 组成 | 内容 |
|---|---|
| 任务对象 | AI conversations, explanations, notes |
| 核心动作 | converting into Markdown knowledge entries |
| 使用场景 | LLM Wiki |
| 触发词 | 沉淀、.md、knowledge-base、structured notes |
| 排除场景 | casual summaries、marketing copy、chat recaps |

## 17.6 第四步：设计输入

```markdown
# Inputs

Required:
- Source content, such as AI conversation text, notes, explanations, or draft material.

Optional:
- Topic title
- Target category
- Required sections
- Existing knowledge-base style guide

Defaults:
- If no title is provided, infer a concise topic title.
- Use neutral encyclopedia-style Markdown.
- Remove conversational filler by default.

Do not:
- Invent missing facts.
- Preserve dialogue framing unless needed for conceptual clarity.
```

## 17.7 第五步：设计输出

```markdown
# Output Format

Return a Markdown knowledge entry with this structure:

# [Title]

## Definition

## Knowledge Boundaries

## Adjacent Concepts

## Core Concepts

## Underlying Principles

## Application Scenarios

## Common Pitfalls

## Practical Checklist

# Output Rules

The output must:
- Use a neutral encyclopedia-style voice.
- Be reusable outside the original conversation.
- Avoid phrases such as “your question,” “we discussed,” or “the above conversation.”
- Preserve durable knowledge and remove temporary task-management content.
```

## 17.8 第六步：设计流程

```markdown
# Process

1. Identify the central topic and scope of the source content.
2. Remove conversational filler, repeated requests, greetings, and task-management language.
3. Extract durable knowledge: definitions, boundaries, adjacent concepts, principles, examples, pitfalls, and checklists.
4. Reorganize the content into a neutral Markdown knowledge entry.
5. Preserve uncertainty when source content is incomplete.
6. Check that the final entry does not depend on the original conversation context.
7. If asked to create a file, save the result as a `.md` file with a clear filename.
```

## 17.9 第七步：加入边界

```markdown
# Constraints

Do not:
- Refer to the source as a conversation unless historically necessary.
- Use phrases such as “your question,” “we talked about,” or “as mentioned above.”
- Add unsupported facts.
- Convert the result into marketing copy.
- Preserve repeated user instructions.
- Include motivational filler or casual commentary.
```

## 17.10 第八步：加入示例

```markdown
# Examples

## Positive Example

Input:
“把我们聊到的 MCP 与 API 的区别沉淀成 .md 文件，放到 llm-wiki。”

Expected behavior:
- Create a Markdown knowledge entry.
- Include definition, distinction, relationship, scenarios, pitfalls, and checklist.
- Avoid conversational framing.

## Negative Example

Input:
“简单总结一下刚才聊天。”

Expected behavior:
- Do not over-apply this skill.
- Provide a casual summary unless the user asks for knowledge-base output.

## Boundary Example

Input:
“整理一下这段内容，后面可能放知识库。”

Expected behavior:
- Use a lightweight knowledge-entry structure.
- Avoid over-expansion beyond the source material.
```

## 17.11 完整改造后的 `SKILL.md`

```markdown
---
name: llm-wiki-writer
description: 当需要将 AI 对话、解释或笔记转换为中立、可复用的 LLM Wiki Markdown 知识条目时使用。适用于“沉淀”内容、总结为 `.md`、构建知识库条目，或将讨论内容转换为结构化、可复用笔记等请求。不适用于普通摘要、营销文案或个人聊天回顾。
---

# 目的

将源内容转换为可复用的 LLM Wiki Markdown 知识条目。保留长期有效的概念，移除对话中的冗余内容，并使用中立的百科式表达。

# 输入

必需：

- 源内容，例如 AI 对话文本、笔记、解释或草稿材料。

可选：

- 主题标题
- 目标分类
- 必需章节
- 现有知识库风格指南

默认规则：

- 如果未提供标题，则推断一个简洁的主题标题。
- 使用中立的百科式 Markdown。
- 默认移除对话中的冗余内容。

不要：

- 编造缺失事实。
- 保留对话式框架，除非这对概念理解是必要的。

# 流程

1. 识别源内容的核心主题和范围。
2. 移除对话冗余、重复请求、问候语和任务管理类表达。
3. 提取长期有效的知识：定义、边界、相邻概念、原则、示例、常见问题和检查清单。
4. 将内容重新组织为中立的 Markdown 知识条目。
5. 当源内容不完整时，保留不确定性。
6. 检查最终条目是否不依赖原始对话上下文。
7. 如果用户要求创建文件，则将结果保存为一个文件名清晰的 `.md` 文件。

# 输出格式

返回一个 Markdown 知识条目，结构如下：

# [标题]

## 定义

## 知识边界

## 相邻概念

## 核心概念

## 底层原则

## 应用场景

## 常见误区

## 实用检查清单

# 输出规则

输出必须：

- 使用中立的百科式表达。
- 能够脱离原始对话复用。
- 避免使用“你的问题”“我们讨论过”“上面的对话”等表达。
- 保留长期有效的知识，并移除临时性的任务管理内容。

# 约束

不要：

- 将源内容称为对话，除非从历史记录角度有必要。
- 使用“你的问题”“我们聊到的”“如上所述”等表达。
- 添加没有依据的事实。
- 将结果改写成营销文案。
- 保留重复的用户指令。
- 包含激励式废话或随意评论。

# 示例

## 正向示例

输入：  
“把我们聊到的 MCP 与 API 的区别沉淀成 .md 文件，放到 llm-wiki。”

预期行为：

- 创建一个 Markdown 知识条目。
- 包含定义、区别、关系、场景、误区和检查清单。
- 避免对话式框架。

## 反向示例

输入：  
“简单总结一下刚才聊天。”

预期行为：

- 不要过度套用此 skill。
- 除非用户要求知识库输出，否则提供普通摘要。

## 边界示例

输入：  
“整理一下这段内容，后面可能放知识库。”

预期行为：

- 使用轻量级知识条目结构。
- 避免超出源材料进行过度扩展。
```

## 17.12 改造前后对比

| 维度 | 原 Prompt | Skill |
|---|---|---|
| 作用 | 完成一次任务 | 长期复用 |
| 结构 | 一段自然语言 | 元数据 + 输入 + 流程 + 输出 + 约束 + 示例 |
| 触发 | 用户主动复制 | Agent 可根据 description 判断 |
| 边界 | 只写了部分禁止项 | 系统定义不适用场景 |
| 输出 | 依赖当次表达 | 固定结构 |
| 维护 | 难以版本化 | 可放入 Skill Library |
| 测试 | 无测试样例 | 可扩展 tests/cases.md |

## 17.13 Prompt 到 Skill 的通用转换模板

```markdown
---
name: [scenario-action]
description: Use when [task object/context] to [core outcome]. Trigger for [typical user requests]. Do not use for [excluded scenarios].
---

# Purpose

[Define the reusable task this skill performs.]

# Inputs

Required:
- [Required input]

Optional:
- [Optional input]

Defaults:
- [Default assumption]

Do not proceed when:
- [Unsafe or invalid input condition]

# Process

1. [Confirm applicability]
2. [Extract input]
3. [Clean or normalize material]
4. [Analyze or transform]
5. [Generate output]
6. [Check quality]
7. [Handle missing information]

# Output Format

[Define exact output structure.]

# Quality Criteria

The output must:
- [Criterion]
- [Criterion]

# Constraints

Do not:
- [Forbidden behavior]
- [Forbidden behavior]

# Examples

## Positive Example

Input:
[Input]

Expected behavior:
[Expected behavior]

## Negative Example

Input:
[Input]

Expected behavior:
[Expected behavior]
```

## 17.14 本章小结

从 Prompt 到 Skill 的关键，不是复制，而是重构。

核心公式：

```text
Prompt → 提取稳定任务 → 删除一次性表达 → 定义目标 → 拆输入 → 拆输出 → 拆步骤 → 加边界 → 加示例 → 可测试 Skill
```

---

# 阶段三总结

阶段三的核心结论：

1. **Prompt 是原料，不是 Skill 本身。**
   Prompt 中包含任务、偏好、上下文、噪音和临时表达，Skill 只沉淀可复用部分。

2. **Skill 化前要先判断任务是否值得。**
   高频、稳定、可流程化、可验收、可复用的任务，才值得工程化。

3. **目标拆解决定 Skill 边界。**
   必须明确用户、对象、动作、产物和不做什么。

4. **输入设计决定 Skill 的容错能力。**
   要区分必填输入、可选输入、默认假设、缺失处理和禁止输入。

5. **输出设计决定 Skill 是否可用。**
   输出要有格式、章节、粒度、禁止项和验收标准。

6. **步骤设计决定 Skill 是否稳定。**
   步骤必须具体、顺序清楚、可检查、有分支、有回退。

7. **完整改造要从一次性 Prompt 变成可维护能力包。**
   最终产物不是一段更长文本，而是可复用、可测试、可迭代的 `SKILL.md`。

阶段三最重要的一句话：

> 从 Prompt 到 Skill，不是把提示词写长，而是把一次性指令重构成有目标、有输入、有输出、有步骤、有边界、有示例的可复用能力包。

---

# 阶段三掌握检查

完成阶段三后，应能回答：

1. 什么样的 Prompt 值得改造成 Skill？
2. 为什么不能直接把 Prompt 复制进 `SKILL.md`？
3. 拆解任务目标时要看哪四个要素？
4. 输入契约应该包含哪些内容？
5. 输出契约应该包含哪些内容？
6. 为什么输出格式比“写得好”更重要？
7. 步骤设计为什么要包含异常处理？
8. 如何判断一个 Prompt 是否已经成功 Skill 化？

---

# 可沉淀的最小方法论

```text
Prompt 转 Skill 七步法：

1. 识别是否值得 Skill 化
2. 提取稳定任务，删除一次性表达
3. 定义目标：用户、对象、动作、产物
4. 定义输入：必填、可选、默认、缺失处理、禁止输入
5. 定义输出：格式、章节、粒度、禁止项、验收标准
6. 定义流程：步骤、分支、回退、质量检查
7. 加入边界、示例和测试样例
```

---

# 参考来源

- OpenAI Developers: Agent Skills – Codex
- Agent Skills Open Standard: Agent Skills Overview
- Anthropic Engineering: Equipping agents for the real world with Agent Skills
- OpenAI Skills GitHub: skill-creator/SKILL.md
