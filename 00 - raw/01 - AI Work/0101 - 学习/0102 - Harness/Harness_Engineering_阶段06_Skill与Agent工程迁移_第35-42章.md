---
title: 'Harness Engineering｜阶段六：Skill 与 Agent 工程迁移（第 35–42 章）'
status: raw
created: '2026-05-21 09:21'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Harness'
  - 'Skill'
  - 'MCP'
  - 'LLM'
  - 'Knowledge-Base'
  - 'Obsidian'
---

# Harness Engineering｜阶段六：Skill 与 Agent 工程迁移（第 35–42 章）

阶段六的核心目标：

> 把 Harness Engineering 从“理解一套 Agent 外壳方法论”，迁移到“能设计、创建、测试、组合、沉淀 Skill 能力包”。

在 Agent 工程里，Skill 不是一个简单提示词，也不是一个普通脚本，而是一个可复用能力包：

```text
Skill = 触发契约 + 执行指令 + 上下文资源 + 工具脚本 + 质量测试 + 版本沉淀
```

OpenAI Codex Skills 文档将 skill 描述为一个目录，包含必需的 `SKILL.md`，以及可选的 `scripts/`、`references/`、`assets/` 等资源；Claude Code Skills 文档也强调，每个 skill 需要 `SKILL.md`，其 YAML frontmatter 用于告诉 Claude 何时使用该 skill，Markdown 正文用于提供运行时指令。  

---

## 阶段六总览

| 章 | 主题 | 核心问题 | 一句话理解 |
|---:|---|---|---|
| 35 | Skill 是 Harness 的能力插件 | Skill 在 Agent 系统中处于什么位置 | Skill 是可复用的局部 Harness |
| 36 | SKILL.md 与 Harness 规则 | SKILL.md 如何控制 Agent 行为 | SKILL.md 是能力级行为契约 |
| 37 | references / assets / scripts / evals 的作用 | Skill 目录为什么不只是一个文件 | 资源工程化决定 Skill 上限 |
| 38 | Skill 触发 Harness | Skill 什么时候该调用、什么时候不该调用 | description 是触发契约，不是广告语 |
| 39 | Skill 执行 Harness | Skill 被调用后如何稳定执行 | 指令要变成步骤、输入、输出、失败处理 |
| 40 | Skill 质量 Harness | 如何判断 Skill 是否真的可用 | 用测试和评估防止误触发、假完成 |
| 41 | 多 Skill 系统 Harness | 多个 Skill 如何协同而不冲突 | Skill 系统需要路由、边界、共享规范 |
| 42 | 从一次任务到可复用 Agent 能力 | 如何把经验沉淀为 Skill | 失败案例和重复流程都要变成工程资产 |

---

# 第 35 章：Skill 是 Harness 的能力插件

## 35.1 本章核心

> **Skill 是 Agent Harness 的可复用能力插件。**

它不是临时 prompt，也不是孤立脚本，而是把一类任务的执行经验封装起来，让 Agent 在合适场景下自动加载和执行。

简单公式：

```text
Agent Harness = 总系统外壳
Skill = 局部任务能力外壳
```

如果 Agent Harness 是操作系统，那么 Skill 就像应用插件。  
如果 Agent Harness 是公司制度，那么 Skill 就像某个岗位的标准作业流程。

---

## 35.2 Skill 解决什么问题

| 没有 Skill | 有 Skill |
|---|---|
| 每次都重新写提示词 | 重复任务自动加载标准流程 |
| 经验散在对话中 | 经验沉淀为可复用能力 |
| Agent 执行标准不稳定 | Skill 规定输入、步骤、输出、验收 |
| 不同任务混在一起 | 每个 Skill 负责一类清晰任务 |
| 失败无法复盘 | Skill 可以加入 evals 和 changelog |
| 工具和资料靠临时提供 | references、assets、scripts 固化资源 |

一句话：

```text
Skill 把“我会这样做”变成“Agent 每次都按这套方法做”。
```

---

## 35.3 Skill 在 Harness 中的位置

| Harness 层 | Skill 中的对应物 |
|---|---|
| Instruction Layer | SKILL.md |
| Context Layer | references/、示例、方法文档 |
| Tool Layer | scripts/、MCP、CLI 工具说明 |
| State Layer | CHANGELOG.md、版本记录 |
| Execution Layer | 执行步骤、脚本运行环境 |
| Workflow Layer | Skill 内部流程 |
| Eval Layer | evals/、测试样例、质量 rubric |
| Feedback Layer | 失败案例、修复记录 |
| Knowledge Layer | 规范、模板、案例库 |

所以 Skill 不是一个文件，而是一个小型 Harness。

---

## 35.4 Skill 与相邻概念的区别

| 概念 | 关注点 | 与 Skill 的关系 |
|---|---|---|
| Prompt | 一次性指令 | Skill 可以包含 prompt，但不等于 prompt |
| Workflow | 步骤顺序 | Skill 可以封装 workflow |
| Script | 确定性程序 | Skill 可以调用 script |
| Agent | 可以自主执行任务的系统 | Skill 是 Agent 可调用的能力 |
| MCP Tool | 外部工具接口 | Skill 可以说明如何使用 MCP 工具 |
| AGENTS.md | 仓库级规则 | Skill 是能力级规则 |
| SKILL.md | Skill 的核心说明文件 | 是 Skill 的入口和执行契约 |
| Eval | 质量评估机制 | Skill 应该包含 evals 来验证自己 |

---

## 35.5 Skill 的最小结构

最小 Skill：

```text
my-skill/
└─ SKILL.md
```

工程化 Skill：

```text
my-skill/
├─ SKILL.md
├─ references/
├─ assets/
├─ scripts/
├─ evals/
└─ CHANGELOG.md
```

推荐理解：

| 文件 / 目录 | 简单理解 |
|---|---|
| SKILL.md | 这个 Skill 是什么、何时用、怎么做 |
| references/ | 背景资料、方法论、案例 |
| assets/ | 模板、示例文件、可复用资源 |
| scripts/ | 确定性脚本、检查器、转换器 |
| evals/ | 测试用例、评分标准、回归样本 |
| CHANGELOG.md | 版本演化和修复记录 |

---

## 35.6 高质量 Skill 的判断

一个高质量 Skill 至少要满足 6 个条件：

| 条件 | 判断问题 |
|---|---|
| 可触发 | Agent 知道什么时候调用它 |
| 不误触发 | Agent 知道什么时候不调用它 |
| 可执行 | 指令不是空泛建议，而是能一步步做 |
| 可验证 | 有测试或 eval 判断结果 |
| 可迁移 | 能用于同类任务，而不是只适合一次对话 |
| 可迭代 | 失败后能更新规则、样例和版本 |

---

## 35.7 你的场景中的 Skill 示例

| Skill | 任务 |
|---|---|
| complex-task-clarifier | 把模糊想法转成需求文档 |
| skill-quality-reviewer | 评估 SKILL.md 质量 |
| repo-reverse-engineering | 逆向理解一个代码仓库 |
| llm-wiki-writer | 将对话沉淀为知识库 Markdown |
| amazon-ad-diagnoser | 诊断亚马逊广告 CTR / CVR / ACOS 问题 |
| aplus-copywriter | 生成 A+ 转化文案 |
| image-prompt-designer | 生成高质量图片提示词 |
| case-reply-writer | 生成平台客服 case 回复 |

这些都不应该只靠临时 prompt，而应该沉淀成 Skill。

---

## 35.8 常见误区

| 误区 | 问题 | 正确理解 |
|---|---|---|
| Skill 就是一个 prompt | 太窄 | Skill 是能力包 |
| Skill 越大越好 | 容易触发混乱 | 一个 Skill 负责一类清晰任务 |
| Skill 不需要测试 | 会误触发和假完成 | 必须设计 evals |
| Skill 只写 instructions 就够 | 复杂任务需要资料、模板、脚本 | 用 references / assets / scripts |
| Skill 写完就不动了 | 真实使用会暴露问题 | 需要 CHANGELOG 和回归样本 |

---

## 35.9 Feynman 解释

Skill 像公司里的 SOP 文件夹。

不是只写一句“请专业处理客户投诉”，而是包含：

```text
什么时候使用这个 SOP
处理步骤
话术模板
风险提醒
历史案例
检查清单
升级条件
版本记录
```

Agent Skill 也是一样。

---

## 35.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 理解 Skill 本质 | 能说出 Skill 是局部 Harness，不是 prompt |
| 拆解 Skill 结构 | 能解释 SKILL.md、references、assets、scripts、evals |
| 判断 Skill 质量 | 能判断是否可触发、可执行、可验证 |
| 迁移业务经验 | 能把重复任务识别为潜在 Skill |
| 防止 Skill 泛化 | 能控制一个 Skill 的边界和范围 |

---

# 第 36 章：SKILL.md 与 Harness 规则

## 36.1 本章核心

> **SKILL.md 是 Skill 的核心行为契约。它同时负责触发说明和执行说明。**

一个 SKILL.md 至少要回答两个问题：

```text
1. 什么时候应该使用这个 Skill？
2. 使用后应该怎么执行？
```

第一个问题靠 metadata / description。  
第二个问题靠 Markdown instruction。

OpenAI Codex Skills 文档指出，skill 是包含 `SKILL.md` 的目录，`SKILL.md` 必须包含 `name` 和 `description`；Claude Code Skills 文档也说明，YAML frontmatter 用于告诉 Claude 何时使用 skill，Markdown 正文用于提供执行指令。

---

## 36.2 SKILL.md 的双层结构

```markdown
---
name: skill-name
description: Use this skill when...
---

# Skill Instructions

## Purpose
...

## Workflow
...

## Output
...

## Quality Checks
...
```

| 部分 | 作用 |
|---|---|
| YAML frontmatter | 触发契约 |
| Markdown body | 执行契约 |
| name | Skill 标识 |
| description | 何时调用 |
| instructions | 调用后怎么做 |
| examples | 如何处理典型任务 |
| constraints | 禁止事项 |
| quality checks | 完成前检查 |

---

## 36.3 Description 是触发契约

description 不是广告语，不是简介，而是 Agent 判断是否加载 Skill 的核心信号。

低质量 description：

```text
Helps with documents.
```

问题：

| 问题 | 说明 |
|---|---|
| 范围太大 | 什么文档都可能触发 |
| 任务不清 | 是写、改、总结还是评估 |
| 输入不清 | 需要文件、对话还是网页 |
| 边界不清 | 不知道什么时候不用 |

高质量 description：

```text
Use this skill when the user asks to convert an existing conversation, course section, or structured explanation into a Markdown knowledge-base note for an llm-wiki or Obsidian-style repository. Do not use it for casual summarization, translation, email writing, or generating new lesson content before the source content exists.
```

---

## 36.4 Instruction 是执行契约

低质量 instruction：

```text
整理内容，保持清晰。
```

高质量 instruction：

```text
1. 识别沉淀主题和覆盖范围；
2. 提取当前对话中已讲内容，不扩展未讲章节；
3. 按知识库模板组织：背景、核心概念、结构图、章节内容、误区、自检、总结；
4. 使用中文，信息密度高，多表格，少长段落；
5. 生成 .md 文件；
6. 输出下载链接；
7. 如果无法生成文件，明确说明失败原因。
```

---

## 36.5 SKILL.md 推荐结构

```markdown
# Purpose
这个 Skill 解决什么问题。

# When to Use
适用场景。

# When Not to Use
不适用场景。

# Inputs
需要哪些输入。

# Workflow
执行步骤。

# Output Contract
输出格式和交付物。

# Quality Checks
完成前检查项。

# Failure Handling
信息不足、工具失败、权限不足时怎么处理。

# Examples
正例、反例、边界场景。
```

---

## 36.6 SKILL.md 与 Harness 层的映射

| SKILL.md 模块 | 对应 Harness |
|---|---|
| Purpose | 目标层 |
| When to Use | 输入触发 Harness |
| When Not to Use | 防误触发 Harness |
| Inputs | Context Harness |
| Workflow | Workflow Harness |
| Output Contract | Output Test Harness |
| Quality Checks | Quality Gate |
| Failure Handling | Feedback Harness |
| Examples | Eval / Regression Harness |
| References | Context Layer |
| Scripts | Tool / Execution Layer |

---

## 36.7 常见错误

| 错误 | 后果 | 修复 |
|---|---|---|
| description 太宽 | 误触发 | 写清不适用场景 |
| description 太窄 | 漏触发 | 覆盖多种表达方式 |
| instruction 太抽象 | 执行漂移 | 写步骤和检查项 |
| 没有输出契约 | 结果不稳定 | 定义格式、字段、文件 |
| 没有失败处理 | 信息不足时胡编 | 加澄清、假设、停止条件 |
| 没有示例 | 边界不清 | 加正例、反例、近似例 |
| 没有测试 | 质量不可控 | 加 evals |

---

## 36.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 写触发契约 | description 能覆盖正例、排除反例 |
| 写执行契约 | instruction 能按步骤执行 |
| 写输出契约 | 明确最终交付物 |
| 写失败处理 | 信息不足时不胡编 |
| 映射 Harness | 能把 SKILL.md 各部分对应到 Harness 层 |

---

# 第 37 章：references / assets / scripts / evals 的作用

## 37.1 本章核心

> **Skill 的上限不只取决于 SKILL.md，还取决于它是否有工程化资源。**

一个 Skill 如果只有 SKILL.md，适合轻量任务。  
复杂任务需要：

```text
references：补充知识
assets：稳定模板
scripts：确定性能力
evals：质量门禁
CHANGELOG：版本沉淀
```

OpenAI Codex Skills 文档将 `scripts/`、`references/`、`assets/` 作为 skill 目录的可选资源；OpenAI API Skills cookbook 也将 skill 描述为由 instructions、scripts、assets 等文件组成的可复用 bundle。

---

## 37.2 references/：知识资源

references 存放 Skill 运行时需要查阅的背景资料。

| 适合放入 references 的内容 | 示例 |
|---|---|
| 方法论说明 | FABE 文案法则、通用知识理解框架 |
| 领域知识 | Amazon 广告指标解释 |
| 案例库 | 优秀 A+ 文案案例 |
| 规则文档 | 平台政策、项目规范 |
| 长文资料 | 不适合塞进 SKILL.md 的细节 |

使用原则：

```text
SKILL.md 写流程；
references 写知识。
```

---

## 37.3 assets/：稳定资源

assets 存放可复用产物模板或静态资源。

| 适合放入 assets 的内容 | 示例 |
|---|---|
| Markdown 模板 | llm-wiki 知识沉淀模板 |
| 文案模板 | A+ 标题 / 正文格式 |
| 表格模板 | 广告分析诊断表 |
| 图片布局模板 | Banner 构图参考 |
| 示例文件 | 标准输出样例 |
| CSS / HTML 模板 | 本地静态 HTML 规范 |

使用原则：

```text
能模板化的，不要每次让模型重新发明。
```

---

## 37.4 scripts/：确定性能力

scripts 存放可执行脚本，用于完成模型不擅长或不该主观判断的任务。

| 适合用 scripts 的任务 | 示例 |
|---|---|
| 格式检查 | Markdown 标题层级检查 |
| 数据清洗 | 广告报表标准化 |
| 文件转换 | CSV → Markdown 表格 |
| 批量处理 | 批量重命名、批量导出 |
| Schema 校验 | JSON / YAML 校验 |
| 指标计算 | CTR、CVR、ACOS 计算 |
| 回归测试 | 运行样本集检查输出 |

原则：

```text
确定性任务交给脚本；
语义判断交给模型。
```

---

## 37.5 evals/：质量门禁

evals 存放测试样例、评分标准、回归案例。

| eval 类型 | 测什么 |
|---|---|
| trigger eval | 是否正确触发 |
| negative eval | 是否避免误触发 |
| output eval | 输出结构是否合规 |
| process eval | 是否按流程执行 |
| quality eval | 结果质量是否达标 |
| regression eval | 历史错误是否复发 |

OpenAI 关于系统性测试 Agent Skills 的文章指出，skill 的 name 和 description 是决定是否调用 skill 的主要信号；如果它们模糊或过载，skill 就无法可靠触发。因此，trigger eval 和 negative eval 是 Skill 质量工程中的基础测试。

---

## 37.6 CHANGELOG.md：版本沉淀

CHANGELOG 记录 Skill 的演化。

| 记录内容 | 示例 |
|---|---|
| 新增能力 | 增加近似场景触发测试 |
| 修复问题 | 修复翻译任务误触发 |
| 调整规则 | 将输出从长文改为表格优先 |
| 新增资源 | 增加 A+ 文案案例库 |
| 新增脚本 | 增加 Markdown 校验脚本 |
| 新增 eval | 增加 10 个 negative cases |

没有 CHANGELOG，Skill 会变成黑盒。  
有 CHANGELOG，Skill 才能持续工程化。

---

## 37.7 资源目录的设计原则

| 原则 | 说明 |
|---|---|
| SKILL.md 不要塞太多 | 只写关键流程和触发规则 |
| references 放知识 | 长背景和案例不要塞进主指令 |
| assets 放模板 | 输出稳定性靠模板支撑 |
| scripts 放确定性逻辑 | 减少模型主观判断 |
| evals 放质量样本 | 防止回归 |
| CHANGELOG 放演化记录 | 支持长期维护 |

---

## 37.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分资源类型 | 能说清 references、assets、scripts、evals 各自作用 |
| 设计 Skill 目录 | 能按任务复杂度决定资源结构 |
| 把知识外置 | 不把所有内容塞进 SKILL.md |
| 用脚本增强稳定性 | 能识别确定性任务 |
| 用 evals 做质量门禁 | 能让 Skill 可测试、可迭代 |

---

# 第 38 章：Skill 触发 Harness｜何时调用、何时不调用

## 38.1 本章核心

> **Skill 触发 Harness 的作用，是让 Agent 在正确场景调用正确 Skill，并避免误触发。**

Skill 触发失败有两种：

| 类型 | 说明 |
|---|---|
| False Negative | 该调用 Skill 但没调用 |
| False Positive | 不该调用 Skill 但误调用 |

对 Skill 系统来说，误触发和漏触发一样严重。

---

## 38.2 Skill 触发由什么决定

| 信号 | 作用 |
|---|---|
| name | Skill 的短标识 |
| description | 主要触发信号 |
| 用户请求 | 当前意图 |
| 上下文 | 是否有相关文件、任务、历史 |
| 其他 Skill | 是否存在更适合的 Skill |
| 工具可用性 | Skill 是否能完成任务 |
| 风险等级 | 是否需要人工确认 |

---

## 38.3 好的 description 应该包含什么

| 要素 | 说明 |
|---|---|
| 任务类型 | 处理什么任务 |
| 输入类型 | 需要什么材料 |
| 输出目标 | 交付什么 |
| 使用场景 | 什么时候调用 |
| 排除场景 | 什么时候不调用 |
| 边界条件 | 模糊时怎么处理 |

示例：llm-wiki-writer

```text
Use this skill when the user asks to transform an existing conversation, lesson section, or structured explanation into a Markdown knowledge-base note for an llm-wiki / Obsidian-style repository. Use it only after source content exists. Do not use it for casual summarization, translation, email drafting, or creating new lesson content before the lesson has been written.
```

---

## 38.4 触发测试矩阵

| 样本类型 | 目的 | 示例 |
|---|---|---|
| 正例 | 应该触发 | “把这轮对话沉淀成 .md” |
| 反例 | 不该触发 | “解释一下 Harness 是什么” |
| 近似例 | 判断边界 | “帮我整理一下这个内容” |
| 冲突例 | 多 Skill 争抢 | “把这个 skill 评估后整理成知识库” |
| 缺失例 | 输入不足 | “帮我看下这个” |
| 高风险例 | 需审批 | “覆盖我原来的知识库文件” |

---

## 38.5 多 Skill 冲突

当多个 Skill 都可能触发时，需要路由规则。

| 冲突场景 | 处理 |
|---|---|
| 一个更具体，一个更通用 | 优先具体 Skill |
| 一个生成内容，一个沉淀内容 | 先生成，再沉淀 |
| 一个评估，一个修改 | 先评估，再决定是否修改 |
| 一个低风险，一个高风险 | 先低风险，涉及写入再审批 |
| 用户明确指定 Skill | 优先用户指定，但仍检查安全 |

---

## 38.6 触发 Harness 的输出

在复杂系统中，路由层可以输出：

```text
候选 Skill
选择原因
未选择原因
是否需要澄清
是否需要人工审批
```

示例：

| 候选 Skill | 是否选用 | 原因 |
|---|---:|---|
| llm-wiki-writer | 是 | 用户明确要求沉淀成 .md |
| course-teacher | 否 | 本阶段内容已经讲完 |
| translator | 否 | 用户不是要求翻译 |
| file-exporter | 部分 | 作为输出工具使用 |

---

## 38.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 靠关键词触发 | 容易误判 | 按意图和上下文触发 |
| description 写得很宽 | 误触发 | 加不适用场景 |
| 每个 Skill 都想覆盖很多事 | 路由混乱 | 一个 Skill 一个清晰任务族 |
| 不测试反例 | 误触发无法发现 | 必须有 negative eval |
| 多 Skill 没有优先级 | 互相抢任务 | 建立 routing policy |

---

## 38.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计触发描述 | description 能判断何时用 |
| 设计不触发边界 | 能写清 when not to use |
| 设计触发测试 | 正例、反例、近似例齐全 |
| 处理多 Skill 冲突 | 能定义优先级和路由规则 |
| 诊断触发问题 | 能判断是 description、样本还是路由问题 |

---

# 第 39 章：Skill 执行 Harness｜步骤、输入、输出、失败处理

## 39.1 本章核心

> **Skill 执行 Harness 的作用，是让 Skill 被调用后能够按稳定流程完成任务，而不是只给模型一个方向。**

触发只是开始。  
真正决定 Skill 质量的是执行：

```text
输入是否清楚
步骤是否明确
工具是否正确
输出是否稳定
失败是否可处理
验收是否可检查
```

---

## 39.2 执行 Harness 的基本结构

```text
Input Contract
→ Context Audit
→ Execution Workflow
→ Tool Use
→ Intermediate Checks
→ Output Contract
→ Quality Gate
→ Failure Handling
```

---

## 39.3 Input Contract

Skill 必须说明需要什么输入。

| 输入类型 | 示例 |
|---|---|
| 用户目标 | “评估这个 skill” |
| 文件 | SKILL.md、PRD、报表 |
| 上下文 | 当前对话、历史大纲 |
| 约束 | 中文、表格化、不扩展未讲内容 |
| 输出格式 | .md、JSON、报告、PR |
| 工具权限 | 是否可读文件、写文件、运行脚本 |

输入不足时不能胡编，要进入失败处理或澄清。

---

## 39.4 Execution Workflow

好的 Skill workflow 应该是可执行的。

示例：llm-wiki-writer

```text
1. 确认沉淀主题和范围；
2. 提取已有内容；
3. 排除未讲或无关内容；
4. 按知识库模板重组；
5. 检查标题、表格、代码块、总结；
6. 生成 .md 文件；
7. 输出下载链接；
8. 说明文件内容范围。
```

示例：skill-quality-reviewer

```text
1. 读取目标 SKILL.md；
2. 检查 frontmatter；
3. 检查 description 触发边界；
4. 检查 instruction 可执行性；
5. 检查 references / assets / scripts / evals；
6. 检查测试和评估闭环；
7. 输出评分、问题、原因、改进建议；
8. 区分必须修复和可选优化。
```

---

## 39.5 Output Contract

Skill 输出必须稳定。

| Skill 类型 | 输出契约 |
|---|---|
| 评估类 Skill | 评分表、问题清单、改进建议、风险 |
| 生成类 Skill | 产物、结构、版本、说明 |
| 转换类 Skill | 输入来源、转换结果、校验结果 |
| 分析类 Skill | 现象、原因、假设、动作、观察指标 |
| 修复类 Skill | 根因、改动、测试、风险、回归 |
| 沉淀类 Skill | Markdown 文件、目录建议、摘要、链接 |

---

## 39.6 Failure Handling

Skill 必须定义失败处理。

| 失败类型 | 处理方式 |
|---|---|
| 输入缺失 | 低风险可假设，高风险先澄清 |
| 文件不存在 | 搜索相近文件，找不到则说明 |
| 工具失败 | 报告错误并给替代方案 |
| 测试失败 | 读取失败原因，修复或说明阻塞 |
| 权限不足 | 停止并请求授权 |
| 上下文冲突 | 按优先级裁决并说明 |
| 输出无法生成 | 明确说明未完成原因 |
| 高风险操作 | 进入人工审批 |

---

## 39.7 执行过程中的 Gate

| Gate | 检查 |
|---|---|
| Input Gate | 输入是否足够 |
| Context Gate | 必要上下文是否读取 |
| Plan Gate | 执行步骤是否明确 |
| Tool Gate | 工具调用是否必要和安全 |
| Output Gate | 输出是否满足契约 |
| Quality Gate | 是否达成任务目标 |
| Delivery Gate | 是否可以交付 |

---

## 39.8 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Skill 只写原则 | Agent 执行会漂移 | 写步骤和门禁 |
| 不写输入要求 | 信息不足时胡编 | 定义 input contract |
| 不写输出格式 | 结果不稳定 | 定义 output contract |
| 不写失败处理 | 工具失败时乱说 | 加 failure policy |
| 只考虑成功路径 | 真实任务常失败 | 加异常分支 |

---

## 39.9 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计输入契约 | 能说明 Skill 需要什么材料 |
| 设计执行步骤 | 能把任务拆成可执行流程 |
| 设计输出契约 | 能让结果稳定 |
| 设计失败处理 | 能处理缺失、冲突、工具失败 |
| 设计过程门禁 | 能防止跳步和假完成 |

---

# 第 40 章：Skill 质量 Harness｜测试与评估

## 40.1 本章核心

> **Skill 质量 Harness 的作用，是用测试、评估和回归样本判断 Skill 是否真的可用。**

一个 Skill 写得再漂亮，如果不能稳定触发、执行、输出、复用，就不是高质量 Skill。

---

## 40.2 Skill 质量的 6 个维度

| 维度 | 问题 |
|---|---|
| 触发准确性 | 该触发时触发，不该触发时不触发 |
| 执行可落地性 | 指令是否能一步步执行 |
| 输出稳定性 | 输出格式和内容是否稳定 |
| 资源工程化 | references / assets / scripts 是否合理 |
| 质量可验证性 | 是否有 tests / evals |
| 迭代可维护性 | 是否有 changelog 和失败沉淀 |

---

## 40.3 evals/ 推荐结构

```text
evals/
├─ trigger_cases.json
├─ negative_cases.json
├─ near_miss_cases.json
├─ output_schema_tests.json
├─ quality_rubric.md
├─ regression_cases.json
└─ README.md
```

| 文件 | 作用 |
|---|---|
| trigger_cases.json | 正确触发样本 |
| negative_cases.json | 防误触发样本 |
| near_miss_cases.json | 近似边界样本 |
| output_schema_tests.json | 输出结构测试 |
| quality_rubric.md | 质量评分标准 |
| regression_cases.json | 历史失败回归样本 |
| README.md | 如何运行和解释 eval |

---

## 40.4 Skill 测试矩阵

| 测试类型 | 目的 |
|---|---|
| Positive Trigger Test | 是否能识别适用场景 |
| Negative Trigger Test | 是否避免误触发 |
| Near-miss Test | 是否处理模糊边界 |
| Input Test | 输入缺失时是否正确处理 |
| Output Test | 输出格式是否符合契约 |
| Process Test | 是否按步骤执行 |
| Tool Test | 是否正确调用工具 |
| Quality Eval | 结果是否有价值 |
| Regression Test | 历史问题是否复发 |

---

## 40.5 Skill 评分表

| 维度 | 0 分 | 1 分 | 2 分 |
|---|---|---|---|
| 触发边界 | 模糊 | 有正例 | 有正例、反例、边界 |
| 执行流程 | 空泛 | 有步骤 | 有步骤、门禁、失败处理 |
| 输出契约 | 无 | 简单格式 | 字段、结构、产物清楚 |
| 资源结构 | 无 | 有少量参考 | references/assets/scripts/evals 分工清楚 |
| 测试闭环 | 无 | 简单样例 | 正例、反例、回归、rubric |
| 可维护性 | 无记录 | 有版本说明 | 有 changelog 和失败沉淀 |

---

## 40.6 质量门禁

Skill 合并前应过这些门禁：

| Gate | 通过条件 |
|---|---|
| Frontmatter Gate | name、description 存在且清楚 |
| Trigger Gate | 正例 / 反例 / 近似场景通过 |
| Instruction Gate | 步骤可执行 |
| Resource Gate | 资源目录合理 |
| Output Gate | 输出契约明确 |
| Eval Gate | 有基本测试 |
| Regression Gate | 已知失败不复发 |
| Documentation Gate | 有使用说明和版本记录 |

---

## 40.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Skill 能用一次就算成功 | 不能证明可复用 | 用多样本测试 |
| 只看最终输出 | 触发和过程也可能错 | 测输入、过程、输出 |
| eval 太复杂所以不做 | 质量无法守住 | 先做最小 eval |
| 只测正例 | 误触发严重 | 反例和近似例必须有 |
| 不维护回归集 | 错误会复发 | 失败样本加入 regression |

---

## 40.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计 Skill evals | 能建立 trigger、negative、output、quality、regression |
| 评估 Skill 质量 | 能按 6 个维度评分 |
| 设计合并门禁 | 能阻止低质量 Skill 进入系统 |
| 把失败转成测试 | 能持续增加回归样本 |
| 控制测试复杂度 | 能从最小 eval 开始 |

---

# 第 41 章：多 Skill 系统 Harness

## 41.1 本章核心

> **多 Skill 系统不是把很多 Skill 堆在一起，而是要设计路由、边界、共享资源、版本和冲突处理。**

单个 Skill 解决一个任务族。  
多 Skill 系统解决能力组合问题。

---

## 41.2 多 Skill 系统的问题

| 问题 | 表现 |
|---|---|
| 触发冲突 | 多个 Skill 都想处理同一请求 |
| 能力重叠 | 两个 Skill 做同一件事 |
| 边界不清 | Agent 不知道选哪个 |
| 资源重复 | 每个 Skill 都复制同一套参考资料 |
| 标准不一致 | 输出格式、质量标准不统一 |
| 版本混乱 | 不知道哪个 Skill 是最新 |
| 回归困难 | 改一个 Skill 影响其他 Skill |
| 组合失败 | A Skill 输出不能被 B Skill 使用 |

---

## 41.3 多 Skill 系统的结构

```text
skills/
├─ _shared/
│  ├─ references/
│  ├─ assets/
│  ├─ rubrics/
│  └─ scripts/
├─ complex-task-clarifier/
├─ skill-quality-reviewer/
├─ repo-reverse-engineering/
├─ llm-wiki-writer/
├─ amazon-ad-diagnoser/
├─ aplus-copywriter/
└─ image-prompt-designer/
```

| 目录 | 作用 |
|---|---|
| _shared/ | 共享参考、模板、脚本、评分标准 |
| 每个 skill/ | 独立能力包 |
| system evals/ | 跨 Skill 路由和组合测试 |
| registry | Skill 清单、版本、负责人、状态 |

---

## 41.4 Skill Registry

Skill Registry 是多 Skill 系统的能力清单。

| 字段 | 说明 |
|---|---|
| name | Skill 名称 |
| purpose | 解决什么问题 |
| trigger | 何时触发 |
| anti-trigger | 何时不触发 |
| inputs | 需要什么输入 |
| outputs | 产出什么 |
| dependencies | 依赖哪些资源或工具 |
| risk | 风险等级 |
| version | 当前版本 |
| status | active / experimental / deprecated |

---

## 41.5 多 Skill 路由规则

| 规则 | 说明 |
|---|---|
| 具体优先于通用 | 专门 Skill 优先 |
| 用户明确指定优先 | 但仍检查安全 |
| 生成先于沉淀 | 没有内容时不能直接沉淀 |
| 评估先于修改 | 不确定质量时先 review |
| 低风险先执行 | 高风险动作再审批 |
| 单 Skill 优先 | 不要过度组合 |
| 输出契约兼容 | 上一个 Skill 输出要能给下一个 Skill 用 |

---

## 41.6 Skill 组合模式

| 模式 | 说明 | 示例 |
|---|---|---|
| 串联 | A 输出给 B | 课程生成 → llm-wiki 沉淀 |
| 并联 | 多个 Skill 各自分析 | 文案、视觉、广告策略分别产出 |
| 审查型 | Reviewer 检查 Executor | skill-creator → skill-quality-reviewer |
| 路由型 | Router 选择 Skill | 用户请求 → 对应业务 Skill |
| 补强型 | Script 增强 Skill | markdown checker 辅助 llm-wiki-writer |
| 回归型 | evals 检查多个 Skill | 系统级 regression |

---

## 41.7 多 Skill 质量门禁

| Gate | 检查 |
|---|---|
| Registry Gate | Skill 是否登记 |
| Boundary Gate | 是否有清楚边界 |
| Conflict Gate | 是否与已有 Skill 冲突 |
| Dependency Gate | 依赖是否清楚 |
| Compatibility Gate | 输入输出是否能组合 |
| Regression Gate | 是否破坏旧 Skill |
| Version Gate | 是否有版本记录 |
| Deprecation Gate | 是否标记废弃 Skill |

---

## 41.8 你的个人 Skill 系统建议

可以按工作域组织：

```text
skills/
├─ knowledge/
│  ├─ llm-wiki-writer/
│  ├─ concept-explainer/
│  └─ course-map-designer/
├─ agent-engineering/
│  ├─ complex-task-clarifier/
│  ├─ skill-creator/
│  ├─ skill-quality-reviewer/
│  └─ repo-reverse-engineering/
├─ amazon/
│  ├─ ad-diagnoser/
│  ├─ listing-copywriter/
│  └─ case-reply-writer/
├─ creative/
│  ├─ image-prompt-designer/
│  ├─ aplus-copywriter/
│  └─ banner-brief-writer/
└─ _shared/
```

---

## 41.9 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Skill 越多越强 | 路由和维护成本上升 | 控制数量和边界 |
| 每个 Skill 自带所有资料 | 重复和冲突 | 建 shared resources |
| 没有 registry | 不知道有哪些能力 | 建 Skill 清单 |
| 不做系统级测试 | 改一个影响多个 | 做 route 和 regression eval |
| 不废弃旧 Skill | 旧能力污染系统 | 加 deprecated 状态 |

---

## 41.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计多 Skill 结构 | 能区分领域、共享资源、系统评估 |
| 建立 Skill Registry | 能记录用途、触发、版本、状态 |
| 处理触发冲突 | 能定义路由优先级 |
| 设计组合模式 | 能串联、并联、审查、路由 |
| 维护系统质量 | 能做系统级 regression 和 deprecation |

---

# 第 42 章：从一次任务到可复用 Agent 能力

## 42.1 本章核心

> **Skill 工程化的终点，是把一次性任务、重复经验、失败案例和个人偏好沉淀成可复用 Agent 能力。**

你现在做的课程沉淀，就是典型路径：

```text
一次对话
→ 阶段课程
→ Markdown 文件
→ llm-wiki 知识资产
→ 未来可复用模板
→ Skill 能力包
```

---

## 42.2 什么值得沉淀成 Skill

| 值得沉淀 | 原因 |
|---|---|
| 高频重复任务 | 节省时间 |
| 高标准任务 | 保证质量 |
| 容易犯错任务 | 用规则和测试防错 |
| 多步骤任务 | 用 workflow 稳定执行 |
| 需要固定格式任务 | 用 output contract 稳定输出 |
| 需要领域知识任务 | 用 references 固化上下文 |
| 需要工具脚本任务 | 用 scripts 固化确定性能力 |
| 有明确评估标准任务 | 用 evals 持续优化 |

不值得沉淀：

| 不适合沉淀 | 原因 |
|---|---|
| 一次性闲聊 | 复用价值低 |
| 目标不稳定 | 容易过早固化 |
| 没有明确边界 | 容易做成大杂烩 |
| 只是一句简单提示 | 不需要 Skill |
| 风险很高但无审批 | 不宜自动化 |

---

## 42.3 从任务到 Skill 的转换流程

```text
1. 识别重复任务
2. 提炼任务边界
3. 定义触发场景
4. 定义非触发场景
5. 设计输入契约
6. 设计执行 workflow
7. 设计输出契约
8. 准备 references / assets
9. 必要时编写 scripts
10. 编写 evals
11. 运行测试
12. 记录 changelog
13. 纳入 Skill Registry
14. 持续迭代
```

---

## 42.4 失败案例如何变成 Skill 资产

| 失败案例 | 沉淀方式 |
|---|---|
| Agent 假完成 | 加 DoD 和 Quality Gate |
| Skill 误触发 | 加 negative eval |
| 输出太长 | 加长度和结构检查 |
| 文案太泛 | 加差异化 rubric |
| Codex 绕流程 | 加 workflow gate |
| 文档漂移 | 加 Documentation Harness |
| 上下文漏读 | 加 Context Audit |
| 文件覆盖错误 | 加 Filesystem Safety Rule |

---

## 42.5 Prompt → Workflow → Skill → Agent System

这是你前面一直关注的能力进阶路径。

| 阶段 | 特征 | 产物 |
|---|---|---|
| Prompt | 一次性指令 | 提示词 |
| Workflow | 固定流程 | 步骤清单 |
| Skill | 可复用能力包 | SKILL.md + resources + evals |
| Agent | 可自主执行任务 | Harness + tools + state |
| Agent System | 多 Agent / 多 Skill 平台 | Registry + routing + CI + evals |

---

## 42.6 你的 Skill 沉淀优先级

建议优先沉淀这 6 类：

| 优先级 | Skill | 原因 |
|---:|---|---|
| 1 | llm-wiki-writer | 高频、明确、可标准化 |
| 2 | complex-task-clarifier | 模糊需求多，价值高 |
| 3 | skill-quality-reviewer | 能提升所有 Skill 质量 |
| 4 | skill-creator | 直接服务你的 Agent 工程目标 |
| 5 | amazon-ad-diagnoser | 贴合你的业务核心 |
| 6 | aplus-copywriter | 高频商业输出，格式明确 |

---

## 42.7 Skill 生命周期

| 阶段 | 目标 | 产物 |
|---|---|---|
| Discover | 发现可沉淀任务 | 候选 Skill 清单 |
| Design | 定义边界和流程 | Skill PRD |
| Build | 编写 SKILL.md 和资源 | Skill 目录 |
| Test | 验证触发和输出 | evals |
| Deploy | 放入可用目录 | registry |
| Use | 在真实任务中使用 | 使用记录 |
| Review | 收集失败和反馈 | failure log |
| Improve | 更新规则和测试 | changelog |
| Deprecate | 废弃过时 Skill | deprecated 记录 |

---

## 42.8 最小可用 Skill 模板

```markdown
---
name: example-skill
description: Use this skill when... Do not use it when...
---

# Purpose
说明这个 Skill 解决什么问题。

# Inputs
列出需要的输入材料。

# Workflow
1. ...
2. ...
3. ...

# Output Contract
说明必须输出什么。

# Quality Checks
- [ ] ...
- [ ] ...

# Failure Handling
说明信息不足、工具失败、权限不足时怎么处理。

# Examples
## Positive
...

## Negative
...

## Near-miss
...
```

---

## 42.9 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 识别可沉淀任务 | 能判断哪些任务值得做 Skill |
| 把经验结构化 | 能从一次任务提炼边界、流程、输出 |
| 把失败变资产 | 能将失败案例变成规则和 eval |
| 设计 Skill 生命周期 | 能让 Skill 持续迭代 |
| 搭建个人 Agent 能力库 | 能规划自己的多 Skill 系统 |

---

# 阶段六总结

## 1. 用一句话总结

> **阶段六的核心是：把 Harness Engineering 迁移到 Skill 工程，把一次性任务沉淀为可触发、可执行、可测试、可组合、可迭代的 Agent 能力包。**

---

## 2. Skill 工程总图

```text
Skill Engineering
├─ 35 Skill 本质
│  └─ Skill 是局部 Harness
├─ 36 SKILL.md
│  └─ 触发契约 + 执行契约
├─ 37 Resources
│  └─ references / assets / scripts / evals
├─ 38 Trigger Harness
│  └─ 何时调用、何时不调用
├─ 39 Execution Harness
│  └─ 输入、步骤、输出、失败处理
├─ 40 Quality Harness
│  └─ 测试、评估、回归、门禁
├─ 41 Multi-Skill Harness
│  └─ 路由、冲突、共享资源、系统评估
└─ 42 Capability Migration
   └─ 一次任务 → 可复用 Agent 能力
```

---

## 3. Skill 与 Harness 的最终关系

| Harness 视角 | Skill 中的实现 |
|---|---|
| 目标层 | Purpose |
| 输入层 | Inputs |
| 触发层 | description / When to Use |
| 反触发层 | When Not to Use / negative cases |
| 上下文层 | references |
| 资源层 | assets |
| 工具层 | scripts / MCP |
| 流程层 | Workflow |
| 输出层 | Output Contract |
| 质量层 | evals / Quality Checks |
| 反馈层 | regression cases / failure log |
| 版本层 | CHANGELOG |
| 系统层 | Skill Registry / routing policy |

---

## 4. 阶段六最重要的判断

```text
不要把 Skill 当成“提示词文件”。

Skill 应该是：

一个有明确触发边界、
有执行流程、
有上下文资源、
有工具脚本、
有输出契约、
有测试评估、
有版本演化的能力包。
```

---

## 5. 阶段六掌握标准

| 能力 | 判断标准 |
|---|---|
| Skill 本质理解 | 能说清 Skill 是局部 Harness |
| SKILL.md 设计 | 能写 description、workflow、output、failure handling |
| 资源工程化 | 能合理使用 references、assets、scripts、evals |
| 触发测试 | 能设计正例、反例、近似例 |
| 执行稳定性 | 能设计输入、步骤、输出、门禁 |
| 质量评估 | 能评估 Skill 是否可用 |
| 多 Skill 系统 | 能处理路由、冲突、共享资源 |
| 能力沉淀 | 能把一次任务变成长期 Agent 能力 |

---

# 下一阶段预告

## 阶段七：真实业务应用｜第 43–49 章

| 章 | 主题 |
|---:|---|
| 43 | 知识库沉淀 Agent Harness |
| 44 | 亚马逊广告分析 Agent Harness |
| 45 | A+ 文案生成 Agent Harness |
| 46 | 图片提示词 Agent Harness |
| 47 | 客服回复 Agent Harness |
| 48 | 需求澄清 Agent Harness |
| 49 | Repo Reverse Engineering Harness |
