# Skill 工程化与产品化｜阶段二：Skill 基础结构

## 阶段定位

阶段二聚焦 Skill 的基础结构，核心目标是理解一个高质量 Skill 的“骨架”应该如何组织。

阶段一解决的是“什么任务值得做成 Skill”。

阶段二解决的是：

> 一个值得 Skill 化的任务，应该被封装成什么样的文件结构、说明结构、触发结构和示例结构。

Skill 不是一段更长的 Prompt，而是一个可复用能力包。其基础结构通常由 `SKILL.md` 作为主入口，并可根据任务需要附带 `scripts/`、`references/`、`assets/` 等资源。

---

## 第 6 章：Skill 文件夹结构

### 6.1 标准结构

一个典型 Skill 可以采用如下结构：

```text
my-skill/
├── SKILL.md
├── references/
│   ├── style-guide.md
│   └── examples.md
├── scripts/
│   ├── validate.py
│   └── transform.py
├── assets/
│   ├── template.md
│   └── sample.json
└── tests/
    ├── cases.md
    └── expected.md
```

其中，只有 `SKILL.md` 是必需部分，其余目录根据实际需要添加。

### 6.2 各目录职责

| 结构 | 是否必需 | 职责 | 适合存放内容 |
|---|---:|---|---|
| `SKILL.md` | 必需 | Skill 主说明文件 | 元数据、触发说明、执行指令、输出规则 |
| `references/` | 可选 | 参考资料 | 规范、术语表、长文档、判断标准 |
| `scripts/` | 可选 | 可执行脚本 | 数据清洗、文件转换、格式校验、批处理 |
| `assets/` | 可选 | 静态资源 | 模板、样例文件、配置、品牌素材 |
| `tests/` | 推荐 | 测试样例 | 正例、反例、边界案例、预期输出 |

### 6.3 最小可用 Skill

最小可用 Skill 可以只有一个 `SKILL.md`：

```text
review-summary/
└── SKILL.md
```

适合：

- 简单文本处理
- 固定输出格式
- 不依赖外部资料
- 不需要脚本执行

例如：

```markdown
---
name: review-summary
description: 当需要将产品评论总结为用户痛点、好评点、功能需求和购买动机时使用。
---

请按照以下结构总结产品评论：  
1. 用户痛点  
2. 正向驱动因素  
3. 功能需求  
4. 购买动机  
5. 产品改进建议
```

### 6.4 资源型 Skill

当 Skill 需要引用品牌规范、术语表、行业规则、写作模板时，应加入 `references/` 或 `assets/`。

```text
amazon-a-plus-copywriter/
├── SKILL.md
├── references/
│   ├── brand-voice.md
│   └── amazon-copy-rules.md
└── assets/
    └── module-template.md
```

适合：

- 品牌文案
- 说明书审查
- 合同检查
- UI 规范检查
- 知识库沉淀

### 6.5 脚本型 Skill

当任务包含稳定、重复、可计算、可校验的动作时，应加入 `scripts/`。

```text
markdown-cleaner/
├── SKILL.md
├── scripts/
│   ├── clean_markdown.py
│   └── validate_headings.py
└── tests/
    └── cases.md
```

适合：

- 批量清洗 Markdown
- 检查标题层级
- 文件格式转换
- 表格字段校验
- JSON / CSV / Excel 结构化处理

### 6.6 文件结构设计原则

#### 原则一：主文件要轻

`SKILL.md` 应该只放核心触发说明和执行步骤。过长的背景资料、样例库、规范文件应放到 `references/`。

#### 原则二：目录只为真实需求存在

不要为了“看起来完整”而创建空目录。

错误做法：

```text
my-skill/
├── SKILL.md
├── references/   # 空目录
├── scripts/      # 空目录
├── assets/       # 空目录
└── tests/        # 空目录
```

正确做法：

```text
my-skill/
└── SKILL.md
```

如果当前 Skill 不需要脚本，就不要创建 `scripts/`。

#### 原则三：一个文件只承担一个职责

不要把所有规则堆进一个文件。

错误：

```text
SKILL.md = 触发说明 + 品牌规范 + 100 个案例 + 脚本说明 + 测试集
```

正确：

```text
SKILL.md = 主流程
references/brand-voice.md = 品牌规范
references/examples.md = 案例
scripts/validate.py = 校验逻辑
tests/cases.md = 测试样例
```

#### 原则四：命名要让 Agent 和人都容易理解

文件名应表达内容用途。

| 不推荐 | 推荐 |
|---|---|
| `doc1.md` | `brand-voice.md` |
| `rules-final-final.md` | `amazon-copy-rules.md` |
| `test.md` | `review-analysis-cases.md` |
| `script.py` | `validate_markdown_structure.py` |

### 6.7 本章小结

Skill 文件夹结构的本质是：

> 用 `SKILL.md` 管主流程，用 `references/` 管知识，用 `assets/` 管模板，用 `scripts/` 管确定性执行，用 `tests/` 管质量验证。

---

## 第 7 章：`SKILL.md` 基础语法

### 7.1 `SKILL.md` 的作用

`SKILL.md` 是 Skill 的主入口。它承担两个核心职责：

1. **让 Agent 知道什么时候使用这个 Skill**
2. **让 Agent 知道使用后应该怎么执行任务**

可以把 `SKILL.md` 理解为：

> Skill 的说明书、触发器和作业手册。

### 7.2 基础结构

一个标准 `SKILL.md` 通常由两部分组成：

```markdown
---
name: skill-name
description: 说明该 Skill 应该在什么情况下使用。
---

# 使用说明

请按照以下步骤执行……
```

第一部分是 YAML frontmatter。
第二部分是 Markdown 正文。

### 7.3 YAML frontmatter

YAML frontmatter 是文件开头由 `---` 包裹的元数据区域。

```yaml
---
name: llm-wiki-writer
description: 当需要将 AI 对话、笔记或解释内容，转换为适合 LLM Wiki 知识库沉淀的中立百科风格 Markdown 条目时使用。
---
```

其中：

| 字段 | 作用 |
|---|---|
| `name` | Skill 的唯一名称 |
| `description` | Skill 的触发说明 |

### 7.4 Markdown 正文

正文用于写执行规则。

常见结构：

```markdown
# 目的

定义该 Skill 的作用。

# 使用该 Skill 时

请按照以下步骤执行：
1. ...
2. ...
3. ...

# 输出格式

使用以下结构：
...

# 约束条件

不要...
```

### 7.5 推荐正文结构

基础型 Skill 可以使用以下结构：

```markdown
---
name: skill-name
description: Use when...
---

# Purpose

Explain the task this skill performs.

# Inputs

The user may provide:
- ...
- ...

# Process

Follow these steps:
1. ...
2. ...
3. ...

# Output

Return the result in this format:
- ...
- ...

# Constraints

- Do not...
- Always...
- If information is missing...

# Examples

## Example 1
Input:
...

Output:
...
```

### 7.6 `SKILL.md` 不应该写什么

| 不应该写 | 原因 |
|---|---|
| 大量背景科普 | 浪费上下文 |
| 与任务无关的口号 | 降低指令密度 |
| 重复表达 | 增加冲突概率 |
| 模糊形容词 | 难以执行和测试 |
| 太多开放式建议 | 让 Agent 不知道优先级 |
| 过度人格化表达 | Skill 是作业手册，不是角色扮演脚本 |

错误示例：

```markdown
你是一位世界级、极其专业、非常优秀、能力出众的助手。请尽最大努力帮助用户创造高质量的成果。
```

问题：

- 信息密度低
- 没有任务边界
- 没有执行步骤
- 无法测试

更好的写法：

```markdown
将提供的对话转换为中立风格的 Markdown 知识条目。保留可复用的概念，删除对话中的冗余表达，并按照定义、边界、示例、常见误区和应用说明来组织结果。
```

### 7.7 `SKILL.md` 的质量标准

一个合格的 `SKILL.md` 应满足：

| 标准 | 检查问题 |
|---|---|
| 可触发 | description 是否清楚说明何时使用？ |
| 可执行 | 正文是否提供明确步骤？ |
| 可验收 | 是否定义输出格式和质量标准？ |
| 可边界化 | 是否说明不做什么？ |
| 可维护 | 是否避免堆积无关内容？ |
| 可扩展 | 是否能把长资料拆到 references？ |

### 7.8 本章小结

`SKILL.md` 不是普通 Markdown 文档，而是 Agent 的任务执行入口。

核心判断标准：

> Agent 只看这个文件，是否能知道“何时用、怎么做、输出什么、避免什么”。

---

## 第 8 章：`name` 设计

### 8.1 `name` 的作用

`name` 是 Skill 的唯一标识。它不仅给人看，也给系统和 Agent 使用。

`name` 应该具备：

- 简短
- 清晰
- 稳定
- 可区分
- 可维护

### 8.2 命名基本规则

推荐规则：

```text
lowercase-words-separated-by-hyphens
```

例如：

```yaml
name: llm-wiki-writer
```

不推荐：

```yaml
name: LLM Wiki Writer!!!
name: 我的超级知识库整理神器
name: skill_001
name: new-final-final-skill
```

### 8.3 好名字的标准

| 标准 | 说明 | 示例 |
|---|---|---|
| 动作清晰 | 看名字知道做什么 | `review-analyzer` |
| 场景清楚 | 看名字知道服务哪个场景 | `amazon-a-plus-writer` |
| 粒度适中 | 不过大也不过小 | `markdown-cleaner` |
| 可扩展 | 后续可加入同类 Skill | `ui-reviewer` |
| 不冲突 | 不与其他 Skill 重名 | `feishu-table-writer` |

### 8.4 命名模式

#### 模式一：对象 + 动作

```text
review-analyzer
markdown-cleaner
pdf-extractor
copywriter-reviewer
```

适合数据处理、内容处理、文件处理。

#### 模式二：平台 + 场景 + 动作

```text
amazon-review-analyzer
amazon-a-plus-writer
feishu-table-writer
github-pr-reviewer
```

适合和具体平台绑定的 Skill。

#### 模式三：领域 + 产物

```text
llm-wiki-writer
product-requirement-planner
brand-voice-editor
sdd-bdd-tdd-planner
```

适合知识管理、产品设计、研发协作。

### 8.5 命名粒度

命名粒度要避免两个极端。

#### 过大

```text
amazon-helper
```

问题：

- 范围太宽
- 不知道是写文案、查评论还是做广告分析
- 容易和其他 Amazon Skill 冲突

#### 过小

```text
amazon-review-one-star-negative-complaint-classifier-for-speaker-products
```

问题：

- 太长
- 维护困难
- 复用范围过窄

#### 更合适

```text
amazon-review-analyzer
```

### 8.6 命名反例与修正

| 反例 | 问题 | 修正 |
|---|---|---|
| `helper` | 太泛 | `markdown-cleaner` |
| `amazon` | 不知道具体做什么 | `amazon-review-analyzer` |
| `copy` | 含义模糊 | `amazon-a-plus-copywriter` |
| `skill1` | 没有语义 | `llm-wiki-writer` |
| `best-ai-agent-super-skill` | 口号化 | `agent-task-planner` |

### 8.7 本章小结

`name` 的核心不是“好听”，而是“可识别、可维护、可扩展”。

判断标准：

> 只看 `name`，是否能大致判断这个 Skill 的对象、动作和边界。

---

## 第 9 章：`description` 设计

### 9.1 `description` 的作用

`description` 是 Skill 的触发说明。它决定 Agent 在什么情况下会考虑调用这个 Skill。

`description` 不是简介，而是路由规则。

它应该回答：

1. 这个 Skill 做什么？
2. 用户说什么时应该触发？
3. 哪些场景适用？
4. 哪些场景不适用？

### 9.2 为什么 `description` 极其重要

Agent 在选择 Skill 时，通常不会一开始读取完整 `SKILL.md`。它先看到的是 Skill 的 name 和 description，然后判断是否相关。

因此，如果 `description` 写得模糊，可能出现：

| 问题 | 表现 |
|---|---|
| 漏触发 | 该用 Skill 时没用 |
| 误触发 | 不该用 Skill 时用了 |
| 触发冲突 | 多个 Skill 看起来都适用 |
| 输出漂移 | Agent 对任务边界理解错误 |

### 9.3 description 的推荐结构

推荐结构：

```text
Use when [用户任务/场景] to [核心动作/产物]. Trigger for [关键词/典型请求]. Do not use when [排除场景].
```

示例：

```yaml
description: 当需要将 AI 对话、笔记或解释内容，转换为适合 LLM Wiki 知识库沉淀的中立百科风格 Markdown 条目时使用。适用于将讨论内容总结为可复用的 .md 知识文件的请求。不适用于普通闲聊总结或营销文案。```
```
### 9.4 好 description 的特征

| 特征     | 说明                   |
| ------ | -------------------- |
| 前置关键词  | 开头就说明核心用途            |
| 触发场景明确 | 写清楚用户什么时候需要它         |
| 产物明确   | 说明输出是什么              |
| 边界明确   | 说明什么时候不要用            |
| 不写空话   | 不使用“高质量”“专业”“强大”等空泛词 |
### 9.5 description 写法对比
#### 差写法

```yaml
description: 帮助用户写出更好的内容。
```

问题：

- 太宽泛
- 无法判断触发场景
- 容易误触发
- 没有输出边界
#### 好写法

```yaml
description: 当需要将 Amazon 产品 Listing 文案改写为简洁、符合美国市场电商表达习惯的内容时使用，包括标题、五点描述、A+ 模块文案和对比表格文案。不适用于法律声明、合规审批或未经证实的产品功能。
```

优点：

- 明确平台：Amazon
- 明确任务：listing copy
- 明确产物：titles、bullets、A+ copy、comparison-table text
- 明确边界：不做法律合规承诺，不虚构功能

### 9.6 常见 description 模板

#### 内容处理类

```yaml
description: 当需要将提供的文本转换为适用于【目标场景】的【目标格式】时使用。当用户要求改写、清理、总结、结构化，或将内容转换为【产物】时触发。不适用于【排除场景】。
```

#### 数据分析类

```yaml
description: 当需要分析【数据类型】，以识别【分析维度】并产出【输出产物】时使用。当用户提供【输入数据】或要求执行【分析任务】时触发。如果数据缺失或无法验证，则不使用；除非用户明确要求仅进行框架型分析。
```

#### 文档审查类

```yaml
description: 当需要审查【文档类型】中的【问题类型】时使用，包括【检查项】。当用户上传或粘贴【文档】时触发。不用于法律、医疗、财务或合规审批。
```

#### 设计需求类

```yaml
description: 当需要将产品卖点转换为结构化创意方向、画面构图、生图提示词和设计验收标准时使用。适用于 Amazon A+ 图片、产品 KV、广告横幅或视觉 Brief 请求。不用于最终合规审批或卖点真实性验证。
```

### 9.7 description 的常见错误

| 错误 | 示例 | 问题 |
|---|---|---|
| 太泛 | `Use for writing.` | 任何写作都可能触发 |
| 太窄 | `Use only when user says exactly “analyze review”.` | 容易漏触发 |
| 只有能力没有场景 | `Summarizes text.` | 不知道何时用 |
| 只有场景没有产物 | `Use for Amazon.` | 不知道做什么 |
| 夸张表达 | `Creates world-class outputs.` | 不可执行 |
| 边界缺失 | 没有 `Do not use` | 容易误触发 |

### 9.8 description 检查清单

写完后检查：

- 是否在第一句话说明核心任务？
- 是否包含用户可能说出的触发词？
- 是否说明输出产物？
- 是否说明适用边界？
- 是否说明不适用边界？
- 是否避免空泛词？
- 是否能与其他 Skill 区分？

### 9.9 本章小结

`description` 是 Skill 的路由规则。

高质量 description 的公式：

```text
任务对象 + 核心动作 + 典型触发 + 输出产物 + 排除边界
```

---

## 第 10 章：Instruction 设计

### 10.1 Instruction 的作用

Instruction 是 Skill 被触发后，Agent 实际执行任务时要遵守的操作说明。

它决定：

- 执行顺序
- 判断规则
- 输出格式
- 质量标准
- 异常处理
- 禁止事项

如果说 `description` 决定“是否调用”，Instruction 决定“调用后怎么做”。

### 10.2 Instruction 不等于角色扮演

错误写法：

```markdown
你是一位拥有 20 年经验的顶级专家。你非常专业，必须产出高质量、令人满意的成果。
```

问题：

- 没有执行步骤
- 没有验收标准
- 没有边界
- 难以复现

更好的写法：

```markdown
审查提供的 Amazon A+ 文案，重点评估清晰度、卖点依据、客户相关性和转化力。标记缺乏依据的声明、模糊的利益点、重复表达和缺失的证明点。请以表格形式输出，包含：问题、原因、风险和修改方向。
```

### 10.3 Instruction 的基本结构

推荐结构：

```markdown
# Purpose 目的

# Inputs 输入内容

# Process 执行流程

# Output Format 输出格式

# Quality Criteria 质量标准

# Constraints 约束条件

# Failure Handling 失败处理
```

### 10.4 Purpose：任务目标

Purpose 要说明这个 Skill 的最终目标。

示例：

```markdown
# Purpose

将提供的 AI 对话内容转换为可复用的 LLM Wiki Markdown 知识条目。输出应保留具有长期复用价值的概念，删除对话中的冗余表达，并使用中立、百科式的知识条目语气。
```

Purpose 不应该写成：

```markdown
帮助用户优化内容质量。
```

### 10.5 Inputs：输入要求

Inputs 要说明用户可能提供什么，以及缺失时如何处理。

示例：

```markdown
# Inputs

用户可能提供：

- 原始对话文本
- 主题名称
- 目标知识库格式
- 现有笔记
- 必需章节

如果缺少主题名称，则根据内容推断一个简洁标题。如果内容不足，则输出一个框架，并明确标注假设。
```

### 10.6 Process：执行步骤

Process 要写成可执行步骤，不要写成抽象原则。

弱写法：

```markdown
仔细分析，并撰写一份高质量总结。
```

强写法：

```markdown
# Process

1. 识别核心概念。
2. 删除对话中的冗余表达、重复指令和任务管理类语言。
3. 提取定义、边界、相邻概念、使用场景和常见误区。
4. 将内容重新组织为中立风格的 Markdown 知识条目。
5. 仅在有助于解释概念时添加示例。
6. 保留不确定性，不编造缺失事实。
```

### 10.7 Output Format：输出格式

输出格式要明确，避免 Agent 自由发挥。

示例：

```markdown
# Output Format

请按照以下结构输出 Markdown：

1. 标题
2. 定义
3. 知识边界
4. 相邻概念
5. 核心原则
6. 应用场景
7. 常见误区
8. 实用检查清单
```

### 10.8 Quality Criteria：质量标准

质量标准用于判断输出是否合格。

示例：

```markdown
# Quality Criteria

输出内容必须满足以下要求：

- 可脱离原始对话独立复用
- 语气中立
- 不包含对话式表达
- 使用清晰的标题结构
- 足够具体，能够指导后续工作
- 如实保留不确定性
```

### 10.9 Constraints：禁止事项

高质量 Skill 必须写禁止事项。

示例：

```markdown
# Constraints

不要：

- 提及“用户的问题”或“我们的对话”
- 添加缺乏依据的事实
- 保留重复指令
- 使用激励式空话
- 将输出变成随意的摘要
```

### 10.10 Failure Handling：异常处理

需要提前设计异常情况。

示例：

```markdown
# Failure Handling

如果输入内容过短：

- 产出一个最小化知识条目
- 将缺失章节标记为“源内容不足”
- 不编造细节

如果输入内容包含相互冲突的指令：

- 优先遵循最新的明确用户指令
- 保留安全性和事实准确性要求
- 如果冲突会影响输出结果，则简要说明冲突
```

### 10.11 Instruction 设计误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 只写角色 | 没有流程 | 写步骤 |
| 只写原则 | 不可执行 | 写动作 |
| 只写正向要求 | 容易越界 | 写禁止事项 |
| 没有输出结构 | 结果漂移 | 写 Output Format |
| 没有异常处理 | 信息不足时乱编 | 写 Failure Handling |
| 把所有内容塞进正文 | 上下文浪费 | 长资料放 references |

### 10.12 本章小结

Instruction 的核心不是让 Agent “更聪明”，而是让 Agent “更稳定”。

高质量 Instruction 的公式：

```text
任务目标 + 输入要求 + 执行步骤 + 输出格式 + 质量标准 + 禁止事项 + 异常处理
```

---

## 第 11 章：示例设计

### 11.1 为什么 Skill 需要示例

示例的作用不是装饰，而是校准 Agent 的行为。

示例可以帮助 Agent 理解：

- 什么输入会触发这个 Skill
- 应该输出到什么粒度
- 语气应该如何
- 格式应该如何
- 哪些情况不应该使用
- 边界案例如何处理

### 11.2 示例类型

| 示例类型 | 作用 |
|---|---|
| 正向示例 | 展示应该如何执行 |
| 反向示例 | 展示什么时候不该使用 |
| 边界示例 | 展示模糊情况如何判断 |
| 异常示例 | 展示信息不足、格式错误、目标冲突时如何处理 |
| 对比示例 | 展示差输出与好输出的区别 |

### 11.3 正向示例

正向示例用于告诉 Agent：遇到这类输入，应该如何产出。

示例：

```markdown
## Example: LLM Wiki conversion

Input:
“请把我们刚才聊到的 MCP 与 API 的区别沉淀成 .md 文件。”

预期行为：

- 将讨论内容转换为中立风格的 Markdown 知识条目
- 包含定义、差异、关系、边界、示例和常见误区
- 避免使用“我们刚才聊到”或“你的问题”等表达
```

### 11.4 反向示例

反向示例用于减少误触发。

示例：

```markdown
## Non-example

Input:
“帮我随便总结一下这段聊天。”

如果用户只是想要普通摘要，并没有要求输出可复用的知识库内容，则不要使用该 Skill。
```

反向示例很重要，因为很多低质量 Skill 只写“什么时候用”，不写“什么时候不用”。

### 11.5 边界示例

边界示例用于处理模糊情况。

示例：

```markdown
## Boundary example

Input:
“把这段内容整理一下，我可能后面放知识库。”

Behavior：
轻量使用该 Skill。输出结构化的 Markdown 草稿，但不要在提供内容之外过度扩展。如果知识库目标不明确，则使用通用的可复用笔记格式。
```

### 11.6 异常示例

异常示例用于处理输入不足。

```markdown
## Insufficient input example

Input:
“把 Agent 沉淀成知识库。”

Behavior:
如果用户期望基于源内容生成知识条目，则先要求用户提供源内容。如果继续执行，则只创建通用框架，并明确标记为“仅框架”。
```

### 11.7 对比示例

对比示例能显著提高输出稳定性。

#### 差输出

```markdown
这是我们刚才聊到的内容，主要是关于 Skill 的一些理解。我帮你整理如下……
```

问题：

- 依赖原对话场景
- 不适合知识库复用
- 口语化

#### 好输出

```markdown
# Skill

## 定义

Skill 是一种面向 AI Agent 的可复用能力包，用于封装特定任务的触发条件、执行步骤、参考资料、输出标准和可选脚本。
```

优点：

- 中立
- 可复用
- 不依赖对话上下文
- 适合知识库沉淀

### 11.8 示例数量建议

| Skill 类型 | 建议示例数量 |
|---|---:|
| 简单文本 Skill | 2–3 个 |
| 业务流程 Skill | 4–6 个 |
| 数据分析 Skill | 5–8 个 |
| 高风险审查 Skill | 8–12 个 |
| 团队级标准 Skill | 10 个以上，并配测试集 |

### 11.9 示例写在哪里

少量核心示例可以放在 `SKILL.md` 中。

大量示例应放在：

```text
references/examples.md
```

推荐结构：

```text
my-skill/
├── SKILL.md
└── references/
    ├── examples.md
    └── non-examples.md
```

### 11.10 示例设计误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 只写正例 | 容易误触发 | 增加反例 |
| 示例太完美 | 无法覆盖真实输入 | 加入混乱输入 |
| 示例太长 | 浪费上下文 | 抽取关键模式 |
| 示例没有预期行为 | Agent 只能猜 | 明确 Expected behavior |
| 示例和规则冲突 | 输出不稳定 | 保持规则一致 |

### 11.11 本章小结

示例的本质是行为校准器。

高质量示例应该覆盖：

```text
正例 + 反例 + 边界 + 异常 + 对比
```

---

## 阶段二总结

阶段二的核心结论：

1. **Skill 的核心入口是 `SKILL.md`。**
   它既是触发说明，也是执行手册。

2. **Skill 文件夹不是越复杂越好。**
   目录只为真实需求存在，能用一个 `SKILL.md` 解决的任务，不需要强行拆分。

3. **`name` 负责识别。**
   好名字应该简短、稳定、可区分、可维护。

4. **`description` 负责触发。**
   它不是介绍文案，而是 Agent 的路由规则。

5. **Instruction 负责稳定执行。**
   它需要包含目标、输入、步骤、输出、标准、边界和异常处理。

6. **示例负责行为校准。**
   不仅要写正例，还要写反例、边界案例和异常案例。

阶段二最重要的一句话：

> 高质量 Skill 的基础结构，不是把 Prompt 写长，而是把任务触发、执行流程、资源引用、输出标准和边界规则组织成一个可复用能力包。

---

## 阶段二掌握检查

完成阶段二后，应能回答：

1. `SKILL.md` 在 Skill 中承担什么作用？
2. `references/`、`scripts/`、`assets/` 分别适合放什么？
3. 什么情况下只需要一个最小 Skill？
4. `name` 应该如何命名？
5. 为什么 `description` 不是简介，而是触发规则？
6. 一个好的 Instruction 应该包含哪些部分？
7. 为什么示例不能只写正向案例？
8. 如何判断一个 Skill 的基础结构是否合格？

---

## 阶段二最小实践任务

选择一个真实高频任务，完成以下内容：

```text
1. 给 Skill 命名
2. 写 description
3. 写 Purpose
4. 写 Inputs
5. 写 Process
6. 写 Output Format
7. 写 Constraints
8. 写 1 个正例
9. 写 1 个反例
10. 判断是否需要 references / scripts / assets
```

推荐练习任务：

- LLM Wiki 沉淀 Skill
- 内容清洁 Skill
- Amazon Review 分析 Skill
- A+ 图片需求整理 Skill
- SDD / BDD / TDD 拆解 Skill

---

## 可复用模板：基础 `SKILL.md`

```markdown
---
name: skill-name
description: Use when [task/context] to [produce outcome]. Trigger for [typical user requests]. Do not use when [excluded cases].
---

# Purpose 目的

[Define the task this skill performs.] 【定义该 Skill 执行的任务。】

# Inputs 输入内容

The user may provide: 用户可能提供：
- [Input 1] 【输入 1】
- [Input 2] 【输入 2】
- [Input 3] 【输入 3】

If required information is missing: 如果必要信息缺失：
- [Default behavior] 【默认处理方式】
- [Clarification or assumption rule] 【澄清或假设规则】

# Process 执行流程

Follow these steps: 请按照以下步骤执行：
1. [Step 1] 【步骤 1】
2. [Step 2] 【步骤 2】
3. [Step 3] 【步骤 3】
4. [Step 4] 【步骤 4】

# Output Format 输出格式

Return the result using this structure: 请按照以下结构返回结果：

## [Section 1] 【章节 1】

## [Section 2] 【章节 2】

## [Section 3] 【章节 3】

# Quality Criteria 质量标准

The output must be: 输出内容必须满足以下要求：
- [Criterion 1] 【标准 1】
- [Criterion 2] 【标准 2】
- [Criterion 3] 【标准 3】

# Constraints 约束条件

Do not: 不要：
- [Forbidden behavior 1] 【禁止行为 1】
- [Forbidden behavior 2] 【禁止行为 2】
- [Forbidden behavior 3] 【禁止行为 3】

# Examples 示例

## Positive Example 正向示例

Input: 输入：
[Example input] 【示例输入】

Expected behavior: 预期行为：
[Expected behavior] 【预期行为】

## Negative Example 反向示例

Input: 输入： 
[Example input] 【示例输入】

Expected behavior: 预期行为：
[Explain why this skill should not be used or how it should limit itself] 【说明为什么不应使用该 Skill，或该 Skill 应如何限制自身行为】
```

---

## 参考资料

- OpenAI Help Center: Skills in ChatGPT
- OpenAI Developers: Agent Skills – Codex
- OpenAI Skills GitHub: skill-creator / SKILL.md
- Agent Skills Open Standard: Agent Skills Overview
- Anthropic Engineering: Equipping agents for the real world with Agent Skills
