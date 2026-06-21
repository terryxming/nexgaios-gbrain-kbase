---
title: 'Karpathy LLM Wiki 知识框架与工程落地指南'
status: raw
created: '2026-05-17 00:00'
source_type: unknown
material_type: 指南
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Codex'
  - 'Skill'
  - 'LLM-Wiki'
  - '个人知识库'
---

# Karpathy LLM Wiki 知识框架与工程落地指南

> 本文档由本线程内容提炼而成，用于沉淀到个人知识库。  
> 文档目标不是复刻聊天记录，而是把 Karpathy LLM Wiki 的概念、架构、流程、风险、工程落地和个人应用方式整理成一份可复用知识框架。

---

## 0. 文档定位

本文档回答 5 个核心问题：

1. **LLM Wiki 到底是什么？**
2. **它和 RAG、Obsidian、Memory、Knowledge Graph 有什么区别？**
3. **它的核心架构和工作流是什么？**
4. **它有哪些风险，尤其是 Compilation Gap？**
5. **如何把它落地成个人 AI 架构师知识库、Amazon 运营知识库，以及可复用 Skill？**

核心结论：

> **LLM Wiki 不是一个新产品，也不是一个完整技术标准，而是一种让 LLM 持续维护 Markdown 知识库的工作模式。**

更准确地说：

> **LLM Wiki = 让 LLM 把原始资料持续编译成一个结构化、互相链接、可维护的 Markdown Wiki；以后回答问题时，优先读取这个“已经整理好的知识层”，而不是每次都从原始资料里重新检索、重新总结。**

---

## 1. 一句话理解 LLM Wiki

### 1.1 定义

**LLM Wiki 是一种让 LLM 自动维护 Markdown 知识库的工作模式。**

它不是传统意义上的笔记软件，也不是单纯的 RAG 系统，而是一个由 LLM 参与维护的、长期演化的知识工程模式。

### 1.2 费曼类比

传统问答像：

> 临时请一个助理查资料。

LLM Wiki 像：

> 雇了一个长期图书管理员。

临时助理每次都从头查资料；图书管理员会把资料整理成目录、主题页、人物页、概念页，以后再问时，直接从整理好的知识库里找。

### 1.3 你应该能复述成这样

> LLM Wiki 是一种让 AI 把原始资料整理成结构化知识库，并持续维护、更新、交叉引用的工作模式。

---

## 2. 核心定义与边界

### 2.1 LLM Wiki 解决什么问题？

| 问题 | 传统做法 | LLM Wiki 的做法 |
|---|---|---|
| 知识分散 | 文档、文章、笔记、会议记录散落各处 | 统一沉淀为 Markdown Wiki |
| 每次都要重新理解 | RAG 每次 query 时重新检索 chunk、重新拼答案 | ingest 时先编译成结构化知识层 |
| 知识不复利 | 问完一次后，分析结果消失在聊天记录里 | 高价值问答可以写回 Wiki |
| 矛盾难发现 | 新旧资料冲突时很难追踪 | ingest / lint 时标记冲突 |
| 人类不愿维护知识库 | 交叉引用、更新索引、补链接成本高 | LLM 负责维护工作 |

LLM Wiki 的核心价值不是“一次回答更好”，而是：

> **让知识长期复利。**

### 2.2 LLM Wiki 不解决什么问题？

| 不解决的问题 | 原因 |
|---|---|
| 不保证事实永远正确 | LLM 编译时可能遗漏、误解、过度归纳 |
| 不自动替代 RAG | 大规模、实时、多源异构场景仍需要搜索 / RAG / 数据库 |
| 不等于长期记忆系统 | 它更像显式文件化知识层，不是模型内部记忆 |
| 不等于知识图谱 | 它可以有链接和标签，但不是严格 ontology / graph DB |
| 不等于 NotebookLM | NotebookLM 偏上传资料后问答，LLM Wiki 强调持续维护的中间知识层 |

---

## 3. 为什么 LLM Wiki 会出现

传统 AI 使用方式有一个明显问题：

```text
上传资料 → 提问 → 检索片段 → 拼答案 → 结束
```

答案结束后，理解成果通常就消失在聊天记录里。下次再问相关问题，AI 可能又要重新检索、重新组合、重新推理。

LLM Wiki 的核心转变是：

```text
资料进入 → LLM 阅读 → 提炼概念 → 更新页面 → 建立链接 → 形成知识层
```

这意味着：

> **一次性的理解，变成可复用的知识资产。**

它击中的核心痛点是：

> LLM 很会总结，但过去缺少一个稳定机制，让每次总结都沉淀进长期知识系统。

---

## 4. 与相邻概念的区别

### 4.1 LLM Wiki vs RAG

| 维度 | RAG | LLM Wiki |
|---|---|---|
| 核心动作 | 检索 | 编译 |
| 主要发生时间 | query time | ingest time + query time |
| 知识状态 | 多数是原始 chunk | 已综合、已链接、可维护页面 |
| 优点 | 扩展性强、适合海量资料 | 适合持续理解、沉淀、复利 |
| 缺点 | 每次重新拼上下文 | 编译可能丢事实、维护规则要求高 |
| 最适合 | 企业搜索、客服、实时问答 | 个人研究、团队知识、长期项目 |

一句话：

> **RAG 是“问的时候找”，LLM Wiki 是“资料进来时先整理”。**

更形象地说：

> RAG 像每次做饭都重新找食材；LLM Wiki 像先把食材加工成半成品菜谱库，以后优先复用。

### 4.2 LLM Wiki vs Obsidian

| 维度 | Obsidian | LLM Wiki |
|---|---|---|
| 本质 | 笔记软件 / Markdown 工具 | AI 维护知识库的模式 |
| 谁写内容 | 人为主 | LLM 为主 |
| 强项 | 双链、图谱、浏览体验 | 自动总结、更新、交叉引用 |
| 关系 | 可作为前端界面 | 是背后的工作模式 |

关键类比：

> **Obsidian 是 IDE，LLM 是程序员，Wiki 是代码库。**

Obsidian 不是 LLM Wiki 本身，它只是一个很好用的查看和编辑界面。

### 4.3 LLM Wiki vs Memory

| 维度 | Memory | LLM Wiki |
|---|---|---|
| 典型内容 | 用户偏好、长期习惯、个人事实 | 主题知识、项目知识、研究资料 |
| 形态 | 产品内部记忆较多 | 显式 Markdown 文件 |
| 可审计性 | 不一定强 | 可以 Git 版本管理 |
| 适合问题 | “你记得我喜欢什么吗？” | “这个领域的知识体系是什么？” |

一句话：

> **Memory 偏“记住我”，LLM Wiki 偏“整理世界”。**

### 4.4 LLM Wiki vs Knowledge Graph

| 维度 | Knowledge Graph | LLM Wiki |
|---|---|---|
| 核心 | 实体、关系、结构化图谱 | Markdown 页面、链接、综合解释 |
| 结构强度 | 强结构 | 中结构 |
| 人类可读性 | 不一定强 | 很强 |
| 适合 | 机器查询、关系推理 | 人机共读、知识沉淀 |

一句话：

> **Knowledge Graph 更像数据库，LLM Wiki 更像会自动更新的百科。**

### 4.5 总定位

```text
RAG：负责查资料
Obsidian：负责看资料
Memory：负责记住用户
Knowledge Graph：负责结构化关系
LLM Wiki：负责把资料变成可积累的知识资产
```

---

## 5. 三层架构：Raw Sources / Wiki / Schema

Karpathy LLM Wiki 的核心是三层架构：

```text
Raw Sources / Wiki / Schema
```

### 5.1 Raw Sources：原始资料层

Raw Sources 包括：

- 文章
- 论文
- PDF
- 会议记录
- 网页
- 图片
- 数据文件
- 高价值 AI 对话

这一层是：

> **事实来源。**

规则：

```text
LLM 可以读 raw sources，但不应该随便改 raw sources。
```

因为原始资料是证据链的根。

### 5.2 Wiki：知识层

Wiki 是 LLM 整理出来的知识层，包括：

- 概念页
- 人物页
- 项目页
- 对比页
- 总结页
- 争议页
- 决策页
- 索引页

这一层是：

> **理解成果。**

Raw Sources 是资料，Wiki 是理解后的知识。

### 5.3 Schema：规则层

Schema 告诉 AI：

- 目录怎么放
- 页面怎么写
- 引用怎么标
- 什么内容必须保留证据
- 新资料进入后怎么处理
- 冲突信息怎么标记
- 什么时候需要问人
- 什么时候可以自动更新

Schema 可以由 `AGENTS.md`、`CLAUDE.md` 或 `schema/` 目录承载。

### 5.4 三层对应关系

```text
Raw Sources 负责真实
Wiki 负责理解
Schema 负责纪律
```

这是 LLM Wiki 的最小闭环。

### 5.5 本线程中的关键修正

之前提到的最小目录中虽然包含 `AGENTS.md`，但没有明确标注它属于 Karpathy 三层架构中的 Schema 层，这会造成理解偏差。

修正后的理解：

```text
schema/ + AGENTS.md = Schema 层
raw/ = Raw Sources 层
wiki/ + reviews/ = Wiki 层
```

重要结论：

> **没有 schema 的 LLM Wiki，会退化成普通 Markdown 知识库，不符合 Karpathy 的三层架构原则。**

---

## 6. 三大操作：Ingest / Query / Lint

### 6.1 Ingest：新资料进入

Ingest 不是上传资料，而是把新资料编译进已有知识库。

标准流程：

```text
Step 1：接收新资料
Step 2：判断资料类型
Step 3：生成 source summary
Step 4：提取核心概念 / 实体 / 问题
Step 5：查找已有相关页面
Step 6：更新 Wiki 页面
Step 7：发现冲突则写入 reviews/
Step 8：更新 index.md
Step 9：追加 log.md
Step 10：列出待人工确认事项
```

一句话：

> **Ingest 的本质是“资料进入 → 知识更新 → 证据可追踪”。**

### 6.2 Query：基于 Wiki 提问

Query 不是重新搜索所有原文，而是优先调用已经整理好的 Wiki。

标准流程：

```text
Step 1：理解用户问题
Step 2：先读 index.md
Step 3：定位相关 Wiki 页面
Step 4：阅读相关页面
Step 5：必要时回查 raw sources
Step 6：输出答案
Step 7：区分事实 / 观点 / 推断
Step 8：判断是否值得写回 Wiki
```

核心原则：

> **凡是以后会重复使用、重复解释、重复判断的内容，都值得写回 Wiki。**

### 6.3 Lint：知识库体检

Lint 是给知识库做体检，检查：

| 检查项 | 问题表现 | 处理方式 |
|---|---|---|
| 矛盾 | A 页面说可以，B 页面说不可以 | 写入 `reviews/contradictions.md` |
| 过时 | 旧资料被新资料推翻 | 标记 outdated |
| 孤立页面 | 没有入链 / 出链 | 补交叉引用 |
| 缺少概念页 | 高频概念没有独立页面 | 新建 concept page |
| 缺引用 | 重要判断没有 source | 回查 raw 或标记待确认 |
| 重复页面 | 多个页面讲同一件事 | 合并或重定向 |
| 结构漂移 | 页面格式不一致 | 按 schema 修复 |

一句话：

```text
Ingest 负责吸收
Query 负责使用
Lint 负责纠错
Evidence 负责可信
```

---

## 7. 核心文件：index.md / log.md / AGENTS.md / schema/

### 7.1 index.md：知识地图

`index.md` 负责告诉 AI：知识库里有什么。

它应该记录：

```text
页面名称
页面链接
一句话摘要
所属分类
相关来源数量
最后更新时间
```

类比：

> `index.md` 像图书馆大厅的导航牌。

没有 `index.md`，AI 每次回答问题都要盲目翻文件。

### 7.2 log.md：知识时间线

`log.md` 负责告诉 AI：知识库最近发生了什么。

它记录：

```text
什么时候新增了资料
什么时候更新了页面
什么时候发现了矛盾
什么时候做了 lint
什么时候把一次高价值 query 写回 Wiki
```

类比：

> `log.md` 像医院病历。

没有 `log.md`，AI 不知道知识库是怎么演化的。

### 7.3 AGENTS.md：Schema 入口

`AGENTS.md` 是给 AI 的工作纪律。

它不是写“你是知识库专家”这么简单，而是要约束：

```text
1. 你是谁
2. 你维护什么
3. 哪些文件能改，哪些不能改
4. 新资料怎么 ingest
5. 问题怎么 query
6. 知识库怎么 lint
```

核心区别：

> **低质量 AGENTS.md 是身份设定，高质量 AGENTS.md 是执行规则。**

### 7.4 schema/：详细规则层

推荐把详细规则拆到 `schema/`：

```text
schema/
├── page-formats.md
├── ingest-workflow.md
├── query-workflow.md
└── lint-workflow.md
```

`AGENTS.md` 做入口和导航，`schema/` 放详细规则。这样可以避免 `AGENTS.md` 变成臃肿百科。

---

## 8. 工程目录设计

### 8.1 最小合规目录

```text
llm-wiki/
├── AGENTS.md                 # Schema 入口
├── schema/                   # Schema 层：详细规则
│   ├── page-formats.md
│   ├── ingest-workflow.md
│   ├── query-workflow.md
│   └── lint-workflow.md
├── raw/                      # Raw Sources 层：原始资料
│   ├── sources/
│   └── assets/
├── wiki/                     # Wiki 层：LLM 生成的知识页面
│   ├── index.md
│   ├── log.md
│   ├── concepts/
│   ├── comparisons/
│   ├── projects/
│   └── questions/
└── reviews/                  # Wiki 维护区：冲突、待确认、低置信内容
    ├── contradictions.md
    ├── pending-decisions.md
    └── outdated-claims.md
```

三层对应：

```text
schema/ + AGENTS.md = Schema 层
raw/ = Raw Sources 层
wiki/ + reviews/ = Wiki 层
```

### 8.2 为什么要分 raw/ 和 wiki/

```text
raw/ = 证据
wiki/ = 理解
```

规则：

```text
AI 可以读取 raw/
AI 不应该改写 raw/
AI 可以更新 wiki/
AI 更新 wiki/ 时必须说明依据
```

如果不分开，AI 可能把自己的总结当成原始事实。

### 8.3 为什么需要 reviews/

`reviews/` 是人为判断区，放：

- 冲突信息
- 低置信结论
- 需要补资料的问题
- 需要人工确认的判断
- 可能过时的页面

类比：

> `reviews/` 像机场安检区：可靠信息进入正式 Wiki，不确定信息先放 reviews。

---

## 9. Ingest 工作流模板

每次 ingest 后，AI 应该输出：

```md
# Ingest Report

## 1. Source
- 文件：
- 类型：
- 日期：
- 可信度：

## 2. Core Summary
用 5–8 句话总结这份资料讲了什么。

## 3. Key Concepts
- 概念 A：
- 概念 B：
- 概念 C：

## 4. Updated Pages
- `wiki/concepts/xxx.md`
- `wiki/comparisons/xxx-vs-yyy.md`
- `wiki/projects/xxx.md`

## 5. New Pages Created
- `wiki/concepts/new-topic.md`

## 6. Conflicts Found
- 冲突 1：
  - 旧说法：
  - 新资料说法：
  - 处理方式：

## 7. Pending Human Review
- 待确认问题 1：
- 待确认问题 2：

## 8. Log Entry Added
- 已追加到 `log.md`
```

Ingest 三条红线：

| 红线 | 原因 |
|---|---|
| 不得改写 `raw/` | raw 是事实根 |
| 不得静默覆盖旧结论 | 需要保留知识演化过程 |
| 不得把推断当事实 | 防止幻觉固化进 Wiki |

---

## 10. Query 工作流模板

Query 输出可以采用：

```md
# Query Answer

## 1. Direct Answer
先直接回答问题。

## 2. Evidence
列出依据来自哪些 Wiki 页面 / raw sources。

## 3. Reasoning
解释为什么得出这个判断。

## 4. Caveats
说明不确定性、边界和例外。

## 5. Suggested Wiki Update
本次回答是否值得写回 Wiki？
- 是 / 否
- 建议写入：
  - `wiki/questions/xxx.md`
  - `wiki/comparisons/xxx-vs-yyy.md`
```

### 10.1 Query 的三种深度

| 类型 | 适合场景 | 是否查 raw |
|---|---|---|
| 快速查询 | 问定义、目录、已有结论 | 通常不用 |
| 深度查询 | 要对比、判断、框架 | 可能需要 |
| 高风险查询 | 涉及事实准确性、决策、争议 | 必须回查 raw |

### 10.2 什么内容值得写回 Wiki？

| 内容 | 是否写回 |
|---|---|
| 临时问答 | 不一定 |
| 概念定义 | 应该 |
| 重要对比 | 应该 |
| 决策依据 | 应该 |
| 框架总结 | 应该 |
| 一次性闲聊 | 不需要 |
| 错误排查过程 | 看是否可复用 |

---

## 11. Lint 工作流模板

Lint 输出可以采用：

```md
# Lint Report

## 1. Scope
本次检查范围：
- `wiki/03-skill/`
- `wiki/comparisons/skill-vs-agent.md`

## 2. Contradictions
- 矛盾 1：
  - 页面 A：
  - 页面 B：
  - 建议处理：

## 3. Stale Claims
- 过时结论 1：
  - 原结论：
  - 新证据：
  - 建议：

## 4. Orphan Pages
- 孤立页面：
  - `wiki/concepts/xxx.md`

## 5. Missing Pages
- 高频但缺页概念：
  - `agentic-rag`
  - `knowledge-compounding`

## 6. Missing Citations
- 缺引用判断：
  - 页面：
  - 句子：

## 7. Recommended Fixes
- 高优先级：
- 中优先级：
- 低优先级：
```

### 11.1 Lint 频率

| 类型 | 频率 | 检查范围 |
|---|---|---|
| 小 Lint | 每次 ingest 后 | 相关页面 |
| 中 Lint | 每周 / 每阶段 | 某个主题目录 |
| 大 Lint | 每月 / 大版本前 | 全库 |

### 11.2 质量门禁

```text
1. 没有来源的重要结论，不得进入正式 Wiki。
2. 新资料和旧结论冲突时，不得静默覆盖。
3. 低置信判断必须进入 reviews/。
4. 大范围修改必须更新 log.md。
5. 每个核心概念页必须能从 index.md 找到。
```

---

## 12. 证据、引用、冲突、过期信息处理

### 12.1 四类内容状态

| 类型 | 含义 | 示例 |
|---|---|---|
| 事实 | 来源明确、可验证 | Karpathy 提出三层架构 |
| 观点 | 作者或资料中的主张 | 某文章认为 LLM Wiki 会降低 token 成本 |
| 推断 | 你或 AI 基于资料得出的判断 | LLM Wiki 适合个人 AI 学习系统 |
| 待确认 | 证据不足或需要人工判断 | 是否替代现有知识库结构 |

最危险的是：

> **把推断写成事实。**

### 12.2 Evidence 表

建议每个核心页面都有：

```md
## Evidence｜证据

| Claim | Source | Type | Confidence |
|---|---|---|---|
| LLM Wiki 有三层架构：raw sources、wiki、schema | Karpathy gist | Fact | High |
| LLM Wiki 能减少重复 query-time synthesis | Karpathy gist + 工具实践 | Inference | Medium |
| 它适合个人 AI 架构师知识库 | 基于用户场景判断 | Inference | Medium |
```

### 12.3 冲突处理模板

```md
## Conflict Record

### Topic
LLM Wiki 是否替代 RAG？

### Previous Claim
LLM Wiki 可能替代传统 RAG。

### New Evidence
Karpathy 原文更强调它是一种 pattern，不是完整替代方案；并且提到规模变大后仍可能需要搜索工具。

### Resolution
改为：
LLM Wiki 不应被理解为 RAG 的简单替代，而是把部分 query-time synthesis 前置到 ingest-time compilation。大规模场景仍可能需要搜索 / RAG / qmd 类工具。

### Status
Resolved

### Updated Pages
- `wiki/concepts/llm-wiki.md`
- `wiki/comparisons/llm-wiki-vs-rag.md`
```

### 12.4 过期信息处理模板

```md
## Outdated Claim

### Claim
旧说法是什么？

### Why Outdated
为什么过期？

### Superseded By
被哪条新证据替代？

### Action
- 保留历史记录
- 更新正式页面
- 在 log.md 记录
```

### 12.5 证据等级

| 等级 | 含义 | 能否进入正式 Wiki |
|---|---|---|
| A | 一手资料 / 官方文档 / 原文 | 可以 |
| B | 高质量二手解读 | 可以，但要标明 |
| C | 社区讨论 / 工具 README / 个人博客 | 可以作为参考 |
| D | AI 推断 / 未验证信息 | 不直接进入正式结论 |

---

## 13. Compilation Gap 风险

### 13.1 定义

> **Compilation Gap = 原始资料被 LLM 编译成 Wiki 的过程中，关键信息被遗漏、压扁、误解或过度概括。**

LLM Wiki 的核心动作是：

```text
raw source → source summary → concept page → synthesis page
```

每过一层，信息都会被压缩一次。

### 13.2 常见错误形态

| 错误 | 表现 |
|---|---|
| 遗漏 | 原文里的关键限制条件没有进入 Wiki |
| 压扁 | 多个不同概念被合并成一个概念 |
| 过度归纳 | 一篇文章的观点被写成领域共识 |
| 错位引用 | A 资料的结论被错误归到 B 资料 |
| 旧结论固化 | 后续新资料没有修正旧页面 |
| 反例丢失 | Wiki 只保留主结论，不保留边界 |

### 13.3 解决机制

不要幻想一次 ingest 就完美。要设计成：

```text
Compile → Evaluate → Refine
编译 → 检查 → 修正
```

最小机制：

```text
1. 每个重要结论必须带 source
2. 每个 source summary 必须保留限制条件
3. 每次 ingest 后做小 lint
4. 每个高价值页面保留 Evidence 表
5. 发现缺口时回查 raw/
6. 低置信内容先进 reviews/
```

核心判断：

> **LLM Wiki 的质量，不取决于它总结得多漂亮，而取决于它有没有把原始证据、限定条件、反例和冲突保留下来。**

---

## 14. LLM Wiki + RAG 混合架构

### 14.1 基本判断

> **LLM Wiki 不应该被理解成 RAG 的简单替代，而应该和 RAG 组合使用。**

类比：

```text
LLM Wiki 像整理好的知识书架。
RAG 像搜索引擎。
Raw sources 像原始档案馆。
```

最合理的是：

```text
先看书架
不够再搜索
必要时回查原始档案
最后把新发现整理回书架
```

### 14.2 推荐架构：Wiki First，RAG Fallback

```text
用户提问
  ↓
读取 index.md
  ↓
检索相关 Wiki 页面
  ↓
判断 Wiki 是否足够
  ├─ 足够：基于 Wiki 回答
  └─ 不足：回查 raw sources / RAG / web
          ↓
       生成答案
          ↓
       高价值内容写回 Wiki
```

核心原则：

> **Wiki 是第一记忆层，RAG 是补充检索层，raw 是最终证据层。**

### 14.3 什么时候用 Wiki？什么时候用 RAG？

| 场景 | 优先方式 |
|---|---|
| 问已有概念定义 | Wiki |
| 问已有框架总结 | Wiki |
| 问多个概念关系 | Wiki + 必要时回查 raw |
| 问最新资料 | RAG / Web / Raw |
| 问细节证据 | Raw source |
| 问大规模资料库 | Wiki + 搜索工具 |
| 问高风险判断 | Wiki + Raw 交叉验证 |

一句话：

> **RAG 解决“找得到”，LLM Wiki 解决“积累得起来”。**

---

## 15. LLM Wiki + Codex / Skill / Agent

### 15.1 四者分工

| 部件 | 作用 | 类比 |
|---|---|---|
| LLM Wiki | 存知识、沉淀理解 | 知识库 |
| Skill | 封装标准流程 | SOP |
| Codex | 读写文件、执行命令、改仓库 | 工程执行员 |
| Agent | 判断何时调用什么能力 | 项目经理 |

一句话：

> **LLM Wiki 是知识层，Skill 是流程层，Codex 是执行层，Agent 是调度层。**

### 15.2 推荐工程组合

```text
ai-architect-wiki/
├── AGENTS.md
├── schema/
│   ├── ingest-workflow.md
│   ├── query-workflow.md
│   ├── lint-workflow.md
│   └── page-formats.md
├── raw/
├── wiki/
├── reviews/
└── scripts/
    ├── lint_wiki.py
    ├── check_citations.py
    └── update_index.py
```

对应关系：

```text
AGENTS.md + schema/ = 规则层
raw/ = 证据层
wiki/ = 知识层
reviews/ = 人工审核缓冲区
scripts/ = 自动检查工具
Codex = 执行这些文件操作和检查
Skill = 规定何时、如何执行 ingest/query/lint
```

### 15.3 AGENTS.md 不要写成百科全书

`AGENTS.md` 应该短、稳定、指路。详细规则放进 `schema/`。

推荐：

```text
AGENTS.md：入口规则，告诉 Codex 必须读哪些 schema 文件
schema/：详细规则
raw/：原始资料
wiki/：正式知识
reviews/：待确认内容
```

---

## 16. AI 架构师 Wiki 案例

### 16.1 目标

AI 架构师 Wiki 用来沉淀：

```text
Prompt → Workflow → Skill → Agent → RAG / Memory → MCP / Tool Use → AI System Design
```

目标：

> **把 AI 学习过程沉淀成一个可复用、可更新、可检索、可审计的知识系统。**

### 16.2 推荐目录

```text
ai-architect-wiki/
├── AGENTS.md
├── schema/
│   ├── page-formats.md
│   ├── ingest-workflow.md
│   ├── query-workflow.md
│   └── lint-workflow.md
├── raw/
│   ├── official-docs/
│   ├── articles/
│   ├── papers/
│   ├── conversations/
│   └── assets/
├── wiki/
│   ├── index.md
│   ├── log.md
│   ├── 00-overview/
│   ├── 01-prompt/
│   ├── 02-workflow/
│   ├── 03-skill/
│   ├── 04-agent/
│   ├── 05-rag-memory/
│   ├── 06-mcp-tools/
│   ├── 07-system-design/
│   └── comparisons/
└── reviews/
    ├── contradictions.md
    ├── pending-decisions.md
    └── outdated-claims.md
```

### 16.3 第一批核心页面

```text
wiki/00-overview/ai-architecture-map.md
wiki/01-prompt/prompt-engineering.md
wiki/02-workflow/workflow.md
wiki/03-skill/skill.md
wiki/04-agent/agent.md
wiki/05-rag-memory/rag.md
wiki/05-rag-memory/llm-wiki.md
wiki/06-mcp-tools/mcp.md
wiki/07-system-design/ai-system-design.md
wiki/comparisons/prompt-vs-workflow-vs-skill-vs-agent.md
wiki/comparisons/rag-vs-llm-wiki.md
wiki/comparisons/memory-vs-llm-wiki.md
```

---

## 17. Amazon 运营 Wiki 案例

### 17.1 目标

Amazon 运营 Wiki 用来沉淀：

```text
Amazon Ads
A9 / Cosmo / Rufus
Listing 优化
关键词策略
广告归因
竞品分析
Karaoke machine 类目经验
```

目标：

> **把广告经验、算法理解、Listing 实验、竞品洞察沉淀成可复用的运营决策系统。**

### 17.2 推荐目录

```text
amazon-ops-wiki/
├── AGENTS.md
├── schema/
│   ├── page-formats.md
│   ├── ingest-workflow.md
│   ├── query-workflow.md
│   └── lint-workflow.md
├── raw/
│   ├── amazon-docs/
│   ├── reports/
│   ├── cases/
│   ├── competitor-screenshots/
│   ├── listing-drafts/
│   └── conversations/
├── wiki/
│   ├── index.md
│   ├── log.md
│   ├── 01-algorithm/
│   ├── 02-ads/
│   ├── 03-listing/
│   ├── 04-keywords/
│   ├── 05-competitors/
│   ├── 06-attribution/
│   ├── 07-cases/
│   └── comparisons/
└── reviews/
    ├── contradictions.md
    ├── pending-decisions.md
    └── outdated-claims.md
```

### 17.3 第一批核心页面

```text
wiki/01-algorithm/a9.md
wiki/01-algorithm/cosmo.md
wiki/01-algorithm/rufus.md

wiki/02-ads/sponsored-products.md
wiki/02-ads/sponsored-brands.md
wiki/02-ads/sponsored-brands-video.md
wiki/02-ads/sponsored-display.md
wiki/02-ads/dsp.md

wiki/03-listing/listing-optimization.md
wiki/03-listing/rufus-aware-copywriting.md
wiki/03-listing/image-and-a-plus-content.md

wiki/04-keywords/keyword-strategy.md
wiki/04-keywords/search-term-mining.md
wiki/04-keywords/negative-keyword-strategy.md

wiki/comparisons/a9-vs-cosmo-vs-rufus.md
wiki/comparisons/sp-vs-sb-vs-sbv-vs-sd.md
wiki/comparisons/head-term-vs-long-tail.md
```

### 17.4 Amazon Wiki 的真正价值

它不是文章收藏夹，而是：

> **运营判断库 + 实验复盘库 + 策略推演库。**

它应该帮助回答：

```text
这个关键词要不要否定？
这个广告组为什么 CVR 掉了？
这个 Listing 改版是否影响广告学习？
Rufus 是否能理解 A+ 图片里的文字？
高价产品怎么打低价竞品？
头部词排名下降会不会影响长尾？
```

---

## 18. llm-wiki-maintainer Skill 设计

### 18.1 Skill 定位

> **LLM Wiki 是知识库，Skill 是调用这套知识库的标准流程。**

Skill 不负责拥有知识，而是负责：

```text
规定如何使用知识
规定如何更新知识
规定如何审查知识
规定如何输出变更报告
```

### 18.2 Skill 目录结构

```text
.agents/skills/llm-wiki-maintainer/
├── SKILL.md
├── references/
│   ├── wiki-directory-standard.md
│   ├── page-template.md
│   ├── ingest-template.md
│   ├── query-template.md
│   └── lint-template.md
└── scripts/
    ├── check_links.py
    ├── check_citations.py
    └── update_index.py
```

### 18.3 三个主模式

```text
1. ingest-source
2. query-wiki
3. lint-wiki
```

### 18.4 触发条件

```md
## 何时调用本 Skill

当用户希望执行以下任务时，调用本 Skill：

- 把新资料加入 LLM Wiki
- 将文章、文档、对话整理进已有知识库
- 基于已有 Wiki 回答问题
- 更新 index.md 或 log.md
- 检查知识库中的矛盾、过时结论、缺引用、孤立页面
- 将高价值对话沉淀成 Wiki 页面
```

### 18.5 执行流程

```text
识别任务类型
  ↓
读取目标 Wiki 的 AGENTS.md
  ↓
读取 schema/
  ↓
判断是 ingest / query / lint
  ↓
执行对应流程
  ↓
更新 wiki / reviews / index / log
  ↓
输出变更报告
```

---

## 19. 质量评估框架

### 19.1 一句话理解

> **LLM Wiki 的质量，不看页面数量，而看它是否可信、可复用、可维护。**

### 19.2 六个评估维度

| 维度 | 判断问题 | 不合格表现 |
|---|---|---|
| 证据性 | 重要结论能不能追溯来源？ | 没有 source，只有总结 |
| 结构性 | 页面之间有没有清晰分类和链接？ | 文件很多，但找不到 |
| 准确性 | 有没有把观点、推断写成事实？ | 结论很满，但证据不足 |
| 完整性 | 有没有保留边界、反例、限制条件？ | 只保留主结论 |
| 可维护性 | 新资料进来能否稳定更新？ | 每次靠临时提示词 |
| 可复用性 | 后续 Query 能否直接调用？ | 写完之后没人用 |

### 19.3 5 分制评分标准

| 分数 | 状态 | 描述 |
|---|---|---|
| 1 分 | 资料堆 | 只是把文章、PDF、对话放在一起 |
| 2 分 | 总结库 | 有 AI 总结，但缺结构和证据 |
| 3 分 | 可用 Wiki | 有目录、概念页、部分引用、基础流程 |
| 4 分 | 可信 Wiki | 有 schema、evidence、log、review、lint |
| 5 分 | 知识操作系统 | 可持续 ingest / query / lint，并能支持决策 |

第一阶段目标：

```text
先做到 3 分可用
再升级到 4 分可信
最后靠长期使用逼近 5 分
```

### 19.4 正式页面最低标准

一个正式进入 Wiki 的页面，至少要满足：

```text
1. 有一句话定义
2. 有适用边界
3. 有相邻概念对比
4. 有 evidence 表
5. 有最后更新时间
6. 能从 index.md 找到
```

### 19.5 最危险的反模式

| 反模式 | 后果 |
|---|---|
| 只总结，不链接 | 页面孤立，无法形成知识网络 |
| 只写结论，不留证据 | 后期无法判断真假 |
| 只新增，不整理 | Wiki 变成垃圾堆 |
| 只信新资料，覆盖旧资料 | 丢失知识演化过程 |
| 让 AI 自由发挥 | 结构漂移，质量不可控 |

关键判断：

> **LLM Wiki 不能靠“AI 很聪明”维持质量，必须靠 schema、lint、review、evidence 维持质量。**

---

## 20. 从 10 篇资料启动 LLM Wiki

### 20.1 启动原则

> **不要从“建一个大知识库”开始，而要从“10 篇资料 + 1 个主题 + 1 套流程”开始。**

第一个 Wiki 只需要验证：

> **这套机制能不能让知识沉淀、复用、更新。**

### 20.2 推荐资料结构

| 类型 | 数量 | 作用 |
|---|---:|---|
| 官方文档 | 3 | 保证事实根 |
| 高质量文章 | 2 | 提供解释和趋势 |
| 论文 / 技术报告 | 2 | 提供底层原理 |
| 高价值对话 | 2 | 沉淀个人理解 |
| 项目 / GitHub README | 1 | 连接工程实践 |

选资料原则：

```text
少而精
来源清楚
主题相关
可以复用
能够互相补充
```

### 20.3 最小目录

```text
ai-architect-wiki/
├── AGENTS.md
├── schema/
│   ├── page-formats.md
│   ├── ingest-workflow.md
│   ├── query-workflow.md
│   └── lint-workflow.md
├── raw/
│   ├── official-docs/
│   ├── articles/
│   ├── papers/
│   ├── conversations/
│   └── repos/
├── wiki/
│   ├── index.md
│   ├── log.md
│   ├── concepts/
│   ├── comparisons/
│   └── questions/
└── reviews/
    ├── contradictions.md
    ├── pending-decisions.md
    └── outdated-claims.md
```

### 20.4 先建 6 个核心页面

```text
wiki/concepts/prompt.md
wiki/concepts/workflow.md
wiki/concepts/skill.md
wiki/concepts/agent.md
wiki/concepts/llm-wiki.md
wiki/comparisons/prompt-workflow-skill-agent.md
```

### 20.5 逐篇 Ingest

不要一次性把 10 篇资料全丢进去。

正确节奏：

```text
一次只 ingest 一篇
每篇都生成 Ingest Report
每篇都更新 index.md 和 log.md
每篇都检查是否影响已有页面
```

### 20.6 做 5 个 Query 测试

Wiki 建完后，用 5 个问题测试：

```text
1. Prompt、Workflow、Skill、Agent 的边界是什么？
2. Skill 和 Agent 最大区别是什么？
3. 为什么 Workflow 是 Skill 的前置能力？
4. LLM Wiki 和 RAG 的区别是什么？
5. 如果我要设计一个复杂任务澄清 Skill，应该参考哪些页面？
```

如果这些问题回答不好，说明 Wiki 还没有形成知识网络。

### 20.7 把高价值 Query 写回 Wiki

例如：

> Prompt、Workflow、Skill、Agent 的边界是什么？

这个答案一定值得写回：

```text
wiki/comparisons/prompt-workflow-skill-agent.md
```

---

## 21. 可直接复制给 Codex 的后续任务建议

下面是一段可以直接给 Codex 的任务指令草案：

```text
请在当前仓库中创建一个 LLM Wiki 项目骨架，用于沉淀我的 AI 架构师知识体系。

项目路径：
ai-architect-wiki/

目标：
建立一个符合 Karpathy LLM Wiki 三层架构的 Markdown 知识库，三层分别是：
1. Raw Sources：原始资料层
2. Wiki：知识页面层
3. Schema：规则层

请创建以下目录和文件：

ai-architect-wiki/
├── AGENTS.md
├── schema/
│   ├── page-formats.md
│   ├── ingest-workflow.md
│   ├── query-workflow.md
│   └── lint-workflow.md
├── raw/
│   ├── official-docs/
│   ├── articles/
│   ├── papers/
│   ├── conversations/
│   └── repos/
├── wiki/
│   ├── index.md
│   ├── log.md
│   ├── concepts/
│   │   ├── prompt.md
│   │   ├── workflow.md
│   │   ├── skill.md
│   │   ├── agent.md
│   │   └── llm-wiki.md
│   ├── comparisons/
│   │   └── prompt-workflow-skill-agent.md
│   └── questions/
└── reviews/
    ├── contradictions.md
    ├── pending-decisions.md
    └── outdated-claims.md

要求：
1. AGENTS.md 必须作为 Schema 入口，而不是普通说明文档。
2. AGENTS.md 要明确 raw/ 是事实来源，AI 只读不改。
3. wiki/ 是 AI 可以更新的知识层。
4. reviews/ 用于存放冲突、低置信、待人工确认内容。
5. 每个 schema 文件要写清楚对应工作流。
6. 每个概念页要使用统一页面模板。
7. index.md 和 log.md 需要初始化。
8. 不要把没有来源的推断写成事实。
9. 输出完成后，给出创建的文件列表和下一步建议。
```

---

## 22. 总结：LLM Wiki 的完整心智模型

可以把 LLM Wiki 理解成一个完整系统：

```text
1. 三层架构
   Raw Sources / Wiki / Schema

2. 三大操作
   Ingest / Query / Lint

3. 两个核心文件
   index.md / log.md

4. 四类内容状态
   事实 / 观点 / 推断 / 待确认

5. 一个核心风险
   Compilation Gap

6. 一个推荐架构
   Wiki First, RAG Fallback

7. 一个工程组合
   LLM Wiki + Skill + Codex + Agent

8. 一个质量闭环
   Evidence / Review / Lint / Write-back
```

最重要的 5 句话：

1. **LLM Wiki 不是资料库，而是可持续维护的知识系统。**
2. **LLM Wiki 的核心不是检索，而是编译。**
3. **Raw Sources 是证据，Wiki 是理解，Schema 是规则。**
4. **Compilation Gap 是最大风险，因为从 raw 到 wiki 的过程中会丢信息。**
5. **真正可用的系统 = Wiki + Schema + Skill + Codex + Review。**

---

## 附录：关键资料来源

> 以下来源为本线程中用于建立知识框架的主要参考。正式进入个人知识库时，建议把这些来源保存到 `raw/`，并在对应 Wiki 页面中建立 Evidence 表。

- Karpathy LLM Wiki gist：`https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f`
- qmd Markdown search：`https://github.com/tobi/qmd`
- atomicstrata/llm-wiki-compiler：`https://github.com/atomicstrata/llm-wiki-compiler`
- ussumant/llm-wiki-compiler：`https://github.com/ussumant/llm-wiki-compiler`
- nashsu/llm_wiki：`https://github.com/nashsu/llm_wiki`
- MindStudio LLM Wiki article：`https://www.mindstudio.ai/blog/andrej-karpathy-llm-wiki-knowledge-base-claude-code/`
- Saeloun private LLM Wiki workflow article：`https://blog.saeloun.com/2026/04/28/private-karpathy-llm-wiki-gbrain-gstack-rails-ai-workflow/`
- Knowledge Compounding 预印本：`https://arxiv.org/abs/2604.11243`
- Memory as Metabolism 预印本：`https://arxiv.org/abs/2604.12034`
- WiCER 预印本：`https://arxiv.org/abs/2605.07068`
