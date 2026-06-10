# Skill 工程化与产品化｜阶段五：渐进式披露与上下文管理

## 阶段定位

阶段五关注 Skill 的上下文架构设计，核心问题是：如何让 Agent 在需要时读取足够信息，同时避免把不相关内容一次性塞进上下文。

前四个阶段分别解决：

```text
阶段一：判断什么任务值得 Skill 化
阶段二：理解 Skill 的基础结构
阶段三：把 Prompt 重构为 Skill
阶段四：把 Workflow 工程化
```

阶段五进一步解决：

```text
Skill 内容应该如何分层？
什么应该放在 SKILL.md？
什么应该拆到 references/？
什么应该放到 assets/？
如何避免上下文污染？
如何让 Agent 只读取当前任务真正需要的信息？
```

OpenAI Codex Skills 文档说明，Skills 使用 Progressive Disclosure 管理上下文：Codex 会先看到每个 Skill 的 name、description 和文件路径；当 Skill 被选中后，再加载完整 `SKILL.md`；如果还需要额外资源，才按需读取相关文件。Agent Skills 规范也将 Skill 信息分为 metadata、instructions 和 resources 三层，并建议把详细参考资料拆到独立文件中。

阶段五的核心观点：

> 高质量 Skill 不是把所有知识塞进一个 `SKILL.md`，而是把信息按“触发、执行、参考、复用资源”分层组织，让 Agent 按需读取。

---

# 第 24 章：Progressive Disclosure 原理

## 24.1 什么是 Progressive Disclosure

Progressive Disclosure，直译为“渐进式披露”。

在 Skill 场景中，它指的是：

```text
不要一次性加载所有 Skill 内容，
而是先加载最少的识别信息，
等确定需要某个 Skill 后，再加载执行说明，
必要时再读取额外参考资料、模板或脚本。
```

可以用一个简单类比理解：

| 现实世界 | Skill 系统 |
|---|---|
| 菜单名称 | `name` |
| 菜品简介 | `description` |
| 厨师操作步骤 | `SKILL.md` 正文 |
| 菜谱书详细说明 | `references/` |
| 模具、模板、样品 | `assets/` |
| 自动切菜机器 | `scripts/` |

餐厅不会把每道菜的完整制作过程都印在菜单首页。菜单只负责帮助顾客选择；真正做菜时，厨师再看具体菜谱。Skill 也是同理。

## 24.2 为什么 Skill 需要渐进式披露

因为 Agent 的上下文窗口不是无限的。

如果所有 Skill 都一次性加载完整内容，会出现几个问题：

| 问题 | 表现 | 后果 |
|---|---|---|
| 上下文浪费 | 不相关 Skill 占用空间 | 当前任务可用上下文变少 |
| 注意力分散 | 规则太多、互相竞争 | Agent 执行不稳定 |
| 触发混乱 | 多个 Skill 内容相互干扰 | 误触发、错用规则 |
| 维护困难 | 所有资料堆在主文件 | 难更新、难测试 |
| 成本上升 | 读取无关内容 | 推理成本和延迟增加 |

渐进式披露要解决的不是“文件好不好看”，而是：

> 如何让 Agent 在当前任务中只看到必要信息。

## 24.3 Skill 加载的三层结构

一个 Skill 通常可以分成三层加载：

| 层级 | 加载时机 | 内容 | 作用 |
|---|---|---|---|
| 第一层：Metadata | Agent 发现 Skill 时 | `name`、`description`、文件路径 | 判断是否可能适用 |
| 第二层：Instructions | Skill 被选中后 | `SKILL.md` 正文 | 指导执行流程 |
| 第三层：Resources | 任务需要时 | `references/`、`assets/`、`scripts/` | 补充资料、模板、脚本 |

这三层对应三个问题：

```text
第一层：要不要用？
第二层：怎么做？
第三层：需要什么额外资料或资源？
```

## 24.4 第一层：Metadata

Metadata 是 Skill 的发现层，通常包括：

```yaml
---
name: amazon-review-analyzer
description: Use when analyzing Amazon product reviews to identify pain points, praise drivers, objections, feature requests, and product improvement opportunities.
---
```

Metadata 的核心任务是帮助 Agent 判断：

```text
用户当前任务是否需要这个 Skill？
```

因此，`description` 不是介绍文案，而是触发路由。

## 24.5 第二层：Instructions

Instructions 是 Skill 被激活后读取的执行层。

它应包含：

- Purpose
- Inputs
- Process
- Decision Logic
- Output Format
- Quality Criteria
- Constraints
- Failure Handling

它的任务是回答：

```text
既然已经决定使用这个 Skill，接下来应该怎么稳定执行？
```

## 24.6 第三层：Resources

Resources 是按需加载的补充层，通常包括：

| 资源类型 | 目录 | 示例 |
|---|---|---|
| 参考资料 | `references/` | 品牌语气、术语表、规则说明、案例库 |
| 静态资源 | `assets/` | 模板、样例、配置、表格结构 |
| 可执行脚本 | `scripts/` | 清洗脚本、校验脚本、转换脚本 |

Resources 不应该默认全部读取。只有当前任务需要时，才读取对应文件。

## 24.7 渐进式披露的价值

| 价值 | 说明 |
|---|---|
| 节省上下文 | 只加载必要内容 |
| 降低干扰 | 减少无关规则进入当前任务 |
| 提高触发准确性 | Metadata 负责清晰路由 |
| 提高执行稳定性 | 主流程简洁，资源按需补充 |
| 提高维护性 | 长资料可独立更新 |
| 支持扩展 | 可以逐步增加 references、assets、scripts |

## 24.8 常见错误

| 错误 | 问题 | 修正 |
|---|---|---|
| 把所有内容塞进 `SKILL.md` | 主文件过长，执行重点丢失 | 主文件只放流程和指针 |
| description 写得太短 | Agent 不知道何时触发 | 写清任务、产物和排除场景 |
| references 没有索引 | Agent 不知道该读哪个文件 | 在 `SKILL.md` 中写明何时读取什么 |
| 资源全部强制读取 | 违背按需加载 | 只在条件满足时读取 |
| 示例过多放主文件 | 主流程被案例淹没 | 大量示例放 `references/examples.md` |

## 24.9 本章小结

Progressive Disclosure 的本质是上下文预算管理。

核心公式：

```text
先用 metadata 判断是否适用，
再用 SKILL.md 指导执行，
最后按需读取 references、assets、scripts。
```

---

# 第 25 章：主文件瘦身

## 25.1 为什么 `SKILL.md` 要瘦身

`SKILL.md` 是 Skill 被激活后的主执行文件。它应该足够完整，让 Agent 能执行任务；也应该足够精简，避免被背景资料、长案例、模板和无关解释淹没。

一个过胖的 `SKILL.md` 会导致：

- Agent 找不到主流程
- 指令之间互相冲突
- 重要约束被稀释
- 后续维护困难
- 测试失败时难定位问题

主文件瘦身的目标不是“写得少”，而是：

> 主文件只保留当前任务执行所必需的高优先级信息。

## 25.2 `SKILL.md` 应该放什么

推荐放入主文件的内容：

| 模块 | 是否应放主文件 | 原因 |
|---|---:|---|
| `name` | 是 | 识别 Skill |
| `description` | 是 | 决定触发 |
| Purpose | 是 | 明确任务目标 |
| Scope | 是 | 明确做什么、不做什么 |
| Inputs | 是 | 明确输入要求 |
| Process | 是 | 明确执行步骤 |
| Decision Logic | 是 | 处理分支和异常 |
| Output Format | 是 | 保证输出稳定 |
| Quality Criteria | 是 | 支持验收 |
| Constraints | 是 | 防止越界 |
| Resource Pointers | 是 | 指向 references/assets/scripts |

## 25.3 `SKILL.md` 不应该放什么

不推荐直接放入主文件的内容：

| 内容 | 应放位置 | 原因 |
|---|---|---|
| 大量业务背景 | `references/domain-background.md` | 主文件不应承载百科资料 |
| 长案例库 | `references/examples.md` | 案例多时会淹没流程 |
| 品牌完整规范 | `references/brand-voice.md` | 只在文案任务需要时读取 |
| 大型模板 | `assets/template.md` | 模板是复用资源，不是主流程 |
| 长代码 | `scripts/` | 代码应独立维护和执行 |
| 原始数据 | 外部文件或 data 目录 | 数据不应混入执行说明 |
| 版本记录 | `CHANGELOG.md` | 避免干扰执行 |

## 25.4 主文件推荐结构

```markdown
---
name: skill-name
description: Use when...
---

# Purpose

# Scope

# Inputs

# Process

# Decision Logic

# Output Format

# Quality Criteria

# Constraints

# Resources

# Examples
```

其中，`Examples` 只放 1–3 个短示例。大量示例应放到 `references/examples.md`。

## 25.5 主文件中的资源指针

主文件不应该复制长资料，而应该写清楚何时读取哪个资料。

示例：

```markdown
# Resources

Use these files only when relevant:
- `references/brand-voice.md`: Read when rewriting brand-facing copy.
- `references/claim-rules.md`: Read when checking product claims.
- `assets/a-plus-module-template.md`: Use when the user asks for Amazon A+ module output.
- `scripts/validate_markdown.py`: Run when creating or editing a Markdown knowledge-base file.
```

这类资源指针的价值是：

```text
不让 Agent 盲目读取全部资源，
而是根据任务条件选择需要的文件。
```

## 25.6 主文件瘦身前后对比

### 瘦身前

```text
SKILL.md
= 触发描述
+ 执行步骤
+ 50 个案例
+ 品牌完整手册
+ Markdown 模板全文
+ 代码片段
+ 历史版本记录
```

问题：主流程被埋没。

### 瘦身后

```text
SKILL.md
= 触发描述
+ 任务目标
+ 核心流程
+ 输出契约
+ 边界规则
+ 资源索引
```

```text
references/examples.md = 案例库
references/brand-voice.md = 品牌规范
assets/template.md = 输出模板
scripts/validate.py = 校验脚本
CHANGELOG.md = 版本记录
```

优点：职责清楚，易维护，易调试。

## 25.7 主文件瘦身检查清单

写完 `SKILL.md` 后检查：

```text
1. 是否能在 1 分钟内看懂这个 Skill 做什么？
2. description 是否已经说明触发条件？
3. 主流程是否被长案例干扰？
4. 是否存在可以拆到 references 的长说明？
5. 是否存在可以拆到 assets 的模板？
6. 是否存在应该放入 scripts 的代码？
7. 是否每个外部文件都有读取条件？
8. 是否存在重复、口号、空泛形容词？
9. 是否能直接支持测试？
10. 是否方便后续版本维护？
```

## 25.8 本章小结

`SKILL.md` 的目标不是完整保存所有知识，而是稳定指导当前任务执行。

核心公式：

```text
主文件放流程，长知识放 references，模板放 assets，确定性操作放 scripts。
```

---

# 第 26 章：references 设计

## 26.1 references 的作用

`references/` 用来存放支持 Skill 执行的参考资料。

它适合存放：

- 领域知识
- 品牌规范
- 术语表
- 案例库
- 判断标准
- 平台规则摘要
- 长文档说明
- 反例集合
- 审查清单

`references/` 的核心作用是：

> 把不适合塞进主文件、但执行时可能需要的知识资料，拆成可按需读取的独立文件。

## 26.2 references 与 `SKILL.md` 的区别

| 维度 | `SKILL.md` | `references/` |
|---|---|---|
| 职责 | 指导执行 | 提供补充知识 |
| 加载时机 | Skill 激活后读取 | 任务需要时读取 |
| 内容类型 | 流程、边界、输出规则 | 长规范、案例、术语、标准 |
| 长度 | 应精简 | 可较长，但要结构化 |
| 更新频率 | 低到中 | 中到高 |

简单区分：

```text
SKILL.md 告诉 Agent 怎么做。
references/ 告诉 Agent 参考什么规则、案例或知识。
```

## 26.3 references 常见文件类型

| 文件 | 作用 |
|---|---|
| `style-guide.md` | 语气、风格、表达规则 |
| `brand-voice.md` | 品牌语气、禁用词、常用表达 |
| `examples.md` | 正例、反例、边界案例 |
| `taxonomy.md` | 分类体系、标签体系 |
| `glossary.md` | 术语表 |
| `claim-rules.md` | 产品声称、证据要求、禁用表达 |
| `review-themes.md` | Review 主题分类标准 |
| `error-patterns.md` | 常见错误模式 |
| `acceptance-criteria.md` | 验收标准 |

## 26.4 references 设计原则

### 原则一：按用途拆分，不按来源堆积

不推荐：

```text
references/all-docs.md
```

推荐：

```text
references/brand-voice.md
references/claim-rules.md
references/examples.md
references/output-criteria.md
```

原因：Agent 需要按任务读取具体资料，而不是翻一个大杂烩文件。

### 原则二：文件名表达用途

不推荐：

```text
doc1.md
rules-final.md
new-guide.md
```

推荐：

```text
amazon-copy-rules.md
review-theme-taxonomy.md
llm-wiki-style-guide.md
```

### 原则三：每个 reference 文件开头写用途说明

推荐格式：

```markdown
# Purpose

This file defines the style rules for LLM Wiki Markdown entries.

# Use When

Read this file when creating or revising knowledge-base Markdown entries.

# Do Not Use When

Do not use this file for marketing copy, casual summaries, or customer support messages.
```

这样可以降低误读。

### 原则四：references 也要结构化

长参考资料不要写成散文。推荐结构：

```markdown
# Purpose
# Use When
# Rules
# Examples
# Non-examples
# Checklist
```

## 26.5 示例：LLM Wiki references 结构

```text
llm-wiki-writer/
├── SKILL.md
└── references/
    ├── llm-wiki-style-guide.md
    ├── knowledge-entry-structure.md
    ├── forbidden-conversational-phrases.md
    └── examples.md
```

各文件职责：

| 文件 | 作用 |
|---|---|
| `llm-wiki-style-guide.md` | 中立百科体风格规则 |
| `knowledge-entry-structure.md` | 知识条目标准结构 |
| `forbidden-conversational-phrases.md` | 禁用对话口吻表达 |
| `examples.md` | 正例、反例、边界案例 |

## 26.6 示例：Amazon A+ references 结构

```text
amazon-a-plus-brief/
├── SKILL.md
└── references/
    ├── amazon-a-plus-module-types.md
    ├── product-claim-rules.md
    ├── visual-hierarchy-guide.md
    ├── copy-tone-guide.md
    └── examples.md
```

各文件职责：

| 文件 | 作用 |
|---|---|
| `amazon-a-plus-module-types.md` | A+ 常见模块类型 |
| `product-claim-rules.md` | 产品声称和证据边界 |
| `visual-hierarchy-guide.md` | 画面层级设计规则 |
| `copy-tone-guide.md` | 文案语气规则 |
| `examples.md` | 示例需求与输出 |

## 26.7 references 的读取规则

在 `SKILL.md` 中应写明读取条件：

```markdown
# Reference Use

- Read `references/llm-wiki-style-guide.md` when the user asks for knowledge-base Markdown output.
- Read `references/forbidden-conversational-phrases.md` when cleaning conversational text.
- Read `references/examples.md` only when examples are needed to resolve ambiguity.
```

不要写：

```markdown
Read all files in references before starting.
```

原因：这会破坏渐进式披露。

## 26.8 references 常见误区

| 误区 | 问题 | 修正 |
|---|---|---|
| 一个 reference 装所有资料 | 难检索，难按需读取 | 按用途拆分 |
| references 没有目录说明 | Agent 不知读哪个 | 在主文件写资源指针 |
| 文件名无语义 | 难维护 | 使用清晰命名 |
| 参考资料与主流程冲突 | 执行不稳定 | 主流程优先，references 补充 |
| 把过期内容放 references | 误导输出 | 加版本和适用范围 |

## 26.9 本章小结

`references/` 是 Skill 的知识扩展层，不是垃圾箱。

核心公式：

```text
按用途拆分 + 文件名清晰 + 开头说明用途 + 主文件写读取条件。
```

---

# 第 27 章：assets 设计

## 27.1 assets 的作用

`assets/` 用于存放 Skill 执行过程中可以复用的静态资源。

常见 assets 包括：

- Markdown 模板
- 表格模板
- JSON schema
- 示例输入文件
- 示例输出文件
- 图片占位模板
- 配置文件
- 品牌素材说明
- 交付物骨架

`assets/` 的核心作用是：

> 存放可直接复用的产物模板或静态材料，避免 Agent 每次从零生成。

## 27.2 assets 与 references 的区别

| 维度 | references | assets |
|---|---|---|
| 本质 | 参考知识 | 复用资源 |
| 作用 | 帮 Agent 判断和理解 | 帮 Agent 生成或套用产物 |
| 示例 | 风格指南、规则、案例 | 模板、schema、样例文件 |
| 使用方式 | 阅读后应用 | 复制、填充、引用、改写 |

简单区分：

```text
references 是“看了之后知道怎么做”。
assets 是“拿来就能用的材料”。
```

## 27.3 assets 常见文件类型

| 文件 | 作用 |
|---|---|
| `template.md` | Markdown 输出模板 |
| `report-template.md` | 报告结构模板 |
| `table-template.csv` | 表格字段模板 |
| `schema.json` | JSON 输出结构 |
| `prompt-template.md` | 生图提示词模板 |
| `brief-template.md` | 设计需求模板 |
| `sample-input.md` | 示例输入 |
| `sample-output.md` | 示例输出 |
| `config.json` | 默认配置 |

## 27.4 assets 设计原则

### 原则一：模板要可填充

不推荐：

```markdown
这是一份高质量报告模板，请自由发挥。
```

推荐：

```markdown
# [Report Title]

## Executive Summary

[Summarize the key findings in 3–5 bullets.]

## Findings Table

| Finding | Evidence | Implication | Recommended Action |
|---|---|---|---|
```

模板要能直接被 Agent 填充。

### 原则二：模板中保留占位符

占位符能减少输出漂移。

推荐占位符：

```text
[Title]
[Input Summary]
[Evidence]
[Assumption]
[Recommendation]
[Risk]
[Next Step]
```

### 原则三：assets 不要混入长规则

模板里可以有简单说明，但不应塞入完整规则。

错误：

```text
a-plus-template.md 同时包含模板、平台规则、品牌规范、案例库、审查说明
```

正确：

```text
assets/a-plus-template.md = 模板
references/claim-rules.md = 声称规则
references/copy-tone-guide.md = 文案风格
```

### 原则四：assets 要稳定

资产文件应该是可以反复复用的，不应放临时草稿。

不适合放 assets：

- 某次对话的临时输出
- 未审核的半成品
- 一次性参考截图
- 与 Skill 无关的素材

## 27.5 示例：LLM Wiki assets 结构

```text
llm-wiki-writer/
├── SKILL.md
├── references/
│   └── llm-wiki-style-guide.md
└── assets/
    ├── knowledge-entry-template.md
    └── checklist-template.md
```

`knowledge-entry-template.md` 示例：

```markdown
# [Concept Name]

## Definition

[Define the concept clearly.]

## Knowledge Boundaries

[Explain what is included and excluded.]

## Adjacent Concepts

[Compare with related concepts.]

## Core Principles

[List the underlying principles.]

## Application Scenarios

[Describe real use cases.]

## Common Pitfalls

[List common misunderstandings.]

## Practical Checklist

[Provide a reusable checklist.]
```

## 27.6 示例：Amazon A+ assets 结构

```text
amazon-a-plus-brief/
├── SKILL.md
├── references/
│   ├── visual-hierarchy-guide.md
│   └── product-claim-rules.md
└── assets/
    ├── a-plus-image-brief-template.md
    ├── comparison-table-template.md
    └── image-prompt-template.md
```

`image-prompt-template.md` 示例：

```markdown
# Image Generation Prompt Template

Create a [image type] for [product name], designed for [platform/use case].

Composition:
- Main subject: [product placement]
- Background: [scene/background]
- Supporting elements: [props/context]
- Visual hierarchy: [primary/secondary focus]
- Text area: [reserved text area]

Style:
- Mood: [mood]
- Lighting: [lighting]
- Color palette: [colors]
- Rendering style: [style]

Constraints:
- Do not add unsupported product features.
- Do not add unreadable text.
- Preserve product structure when reference images are provided.
```

## 27.7 assets 的调用规则

在 `SKILL.md` 中写明：

```markdown
# Assets Use

- Use `assets/knowledge-entry-template.md` when creating a new LLM Wiki entry.
- Use `assets/checklist-template.md` when the output requires an operational checklist.
- Do not modify asset templates unless the user asks for template updates.
```

避免写：

```markdown
Use assets as needed.
```

因为这太模糊。

## 27.8 assets 常见误区

| 误区 | 问题 | 修正 |
|---|---|---|
| 模板没有占位符 | Agent 不知道怎么填 | 使用清晰占位符 |
| assets 混入规则 | 职责混乱 | 规则放 references |
| 临时文件放 assets | 资源污染 | 只放可复用资产 |
| 文件名太泛 | 难定位 | 用 `*-template.md`、`*-schema.json` |
| 没有调用条件 | Agent 不知何时用 | 在主文件写明 |

## 27.9 本章小结

`assets/` 是 Skill 的复用资源层。

核心公式：

```text
references 管判断，assets 管复用，scripts 管执行。
```

---

# 第 28 章：多文件引用

## 28.1 为什么需要多文件引用

随着 Skill 变复杂，单个 `SKILL.md` 很快会不够用。

多文件引用可以解决：

- 主文件过长
- 规则难维护
- 模板难复用
- 案例难扩展
- 脚本难管理
- 多场景混杂

多文件结构让 Skill 变成一个可维护的小型能力包。

## 28.2 多文件引用的基本结构

```text
my-skill/
├── SKILL.md
├── references/
│   ├── style-guide.md
│   ├── examples.md
│   └── taxonomy.md
├── assets/
│   ├── output-template.md
│   └── schema.json
└── scripts/
    ├── validate.py
    └── transform.py
```

`SKILL.md` 负责引用这些资源，而不是复制它们。

## 28.3 推荐引用方式

```markdown
# Resources

Use the following resources only when relevant:

- `references/style-guide.md`: Read when the task requires tone, style, or terminology alignment.
- `references/examples.md`: Read when examples are needed to resolve ambiguous input or output expectations.
- `references/taxonomy.md`: Read when classifying content into standard categories.
- `assets/output-template.md`: Use when generating the final deliverable.
- `scripts/validate.py`: Run when validating the output structure.
```

这种写法同时说明了：

```text
文件路径 + 文件用途 + 读取条件
```

## 28.4 不推荐引用方式

```markdown
Read all references before starting.
```

问题：破坏渐进式披露。

```markdown
Use the files in this folder.
```

问题：没有指定文件和条件。

```markdown
See the examples.
```

问题：没有文件路径。

```markdown
Use doc1.md.
```

问题：文件名无语义。

## 28.5 文件路径规则

推荐使用相对路径：

```text
references/style-guide.md
assets/output-template.md
scripts/validate.py
```

不推荐使用绝对路径或本机路径：

```text
C:\Users\Terry\Desktop\skill\style-guide.md
/Users/terry/Downloads/template.md
```

原因：绝对路径不利于分发和迁移。

## 28.6 多文件依赖关系

多文件 Skill 应尽量保持浅层依赖。

推荐：

```text
SKILL.md
  ├── references/style-guide.md
  ├── references/examples.md
  ├── assets/template.md
  └── scripts/validate.py
```

不推荐：

```text
SKILL.md
  └── references/a.md
        └── references/b.md
              └── references/c.md
                    └── assets/d.md
```

深层链式引用的问题：

- Agent 容易漏读
- 调试困难
- 文件依赖不透明
- 迁移容易断链

## 28.7 多文件索引

复杂 Skill 可以增加资源索引文件：

```text
references/README.md
assets/README.md
```

`references/README.md` 示例：

```markdown
# References Index

| File | Use When | Notes |
|---|---|---|
| `style-guide.md` | Writing or rewriting final output | Defines tone and formatting |
| `taxonomy.md` | Classifying review themes | Use standard category names |
| `examples.md` | Resolving ambiguity | Contains positive and negative examples |
```

但注意：索引不是必须。只有当 reference 文件较多时才需要。

## 28.8 多文件命名规范

推荐命名：

```text
lowercase-words-separated-by-hyphens.md
```

示例：

```text
llm-wiki-style-guide.md
amazon-claim-rules.md
review-theme-taxonomy.md
image-brief-template.md
validate-markdown-structure.py
```

命名应表达：

```text
领域 + 用途 + 文件类型
```

## 28.9 多文件版本管理

当 Skill 进入团队复用阶段，应考虑版本管理。

可增加：

```text
CHANGELOG.md
VERSION.md
```

也可以在主文件写：

```yaml
---
name: amazon-review-analyzer
description: Use when...
version: 0.2.0
---
```

但版本字段是否支持取决于具体平台。即使平台不使用该字段，团队内部仍可通过文件管理版本。

## 28.10 多文件引用检查清单

```text
1. SKILL.md 是否只引用必要资源？
2. 每个引用是否有明确路径？
3. 每个引用是否说明使用条件？
4. 文件名是否有语义？
5. 是否避免深层链式引用？
6. references 是否按用途拆分？
7. assets 是否只放可复用资源？
8. scripts 是否有清楚输入输出？
9. 是否存在过期或重复文件？
10. 文件结构是否方便迁移到其他项目？
```

## 28.11 本章小结

多文件引用的目标不是把 Skill 做复杂，而是把复杂内容分层管理。

核心公式：

```text
主文件做调度，references 做知识，assets 做模板，scripts 做执行。
```

---

# 阶段五总结

阶段五的核心结论：

1. **渐进式披露是 Skill 的上下文管理机制。**
   先加载 metadata，再加载 `SKILL.md`，最后按需读取资源。

2. **`SKILL.md` 不应该承载所有内容。**
   它的职责是触发、流程、边界、输出和资源指针。

3. **主文件要瘦身。**
   长知识、长案例、模板、代码、版本记录都应拆出去。

4. **`references/` 是知识扩展层。**
   它存放规则、案例、术语、分类体系、判断标准等参考资料。

5. **`assets/` 是复用资源层。**
   它存放模板、schema、样例文件、配置等可直接复用的材料。

6. **多文件引用要有条件。**
   不要让 Agent 读取所有文件，而要说明“什么时候读哪个文件”。

7. **上下文管理就是质量管理。**
   读得太少，Agent 缺少必要规则；读得太多，Agent 被无关内容干扰。

阶段五最重要的一句话：

> Skill 的上下文管理，不是把资料堆得越多越好，而是让 Agent 在正确时间读取正确层级的信息。

---

# 阶段五掌握检查

完成阶段五后，应能回答：

1. Progressive Disclosure 在 Skill 中是什么意思？
2. Skill 通常分为哪三层加载？
3. 为什么 `SKILL.md` 不能写得太长？
4. 哪些内容应该留在 `SKILL.md`？
5. 哪些内容应该拆到 `references/`？
6. `references/` 和 `assets/` 的区别是什么？
7. 多文件引用为什么要写读取条件？
8. 如何判断一个 Skill 是否存在上下文污染？
9. 什么是“主文件做调度，资源文件做扩展”？
10. 如何设计一个可维护的多文件 Skill？

---

# 可沉淀的最小方法论

```text
Skill 上下文管理五层法：

1. Metadata 层：name + description，只负责发现和触发
2. SKILL.md 层：目标、范围、流程、输出、约束，只负责执行主线
3. References 层：规则、案例、术语、分类，只负责补充知识
4. Assets 层：模板、schema、样例、配置，只负责复用材料
5. Scripts 层：清洗、转换、校验、批处理，只负责确定性执行

设计原则：
少量核心信息常驻，长资料按需读取，模板和脚本独立管理。
```

---

# 可复用模板：带渐进式披露的 `SKILL.md`

```markdown
---
name: [skill-name]
description: Use when [task/context] to [outcome]. Trigger for [typical requests]. Do not use when [excluded cases].
---

# Purpose

[Define the reusable task.]

# Scope

This skill is for:
- [Applicable scenario]

This skill is not for:
- [Excluded scenario]

# Inputs

Required:
- [Required input]

Optional:
- [Optional input]

# Process

1. [Confirm applicability]
2. [Read provided input]
3. [Apply workflow]
4. [Use resources only when needed]
5. [Generate output]
6. [Check quality]

# Output Format

[Define required output structure.]

# Quality Criteria

The output must:
- [Criterion]
- [Criterion]

# Constraints

Do not:
- [Forbidden behavior]
- [Forbidden behavior]

# Resources

Use these files only when relevant:
- `references/[file].md`: Read when [condition].
- `assets/[template].md`: Use when [condition].
- `scripts/[script].py`: Run when [condition].

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
