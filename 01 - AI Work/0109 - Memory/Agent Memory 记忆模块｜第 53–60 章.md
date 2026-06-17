# Agent Memory 记忆模块｜第 53–60 章

## 阶段定位

第 53–60 章属于真实项目实战阶段。

前面章节解决的是：

| 阶段 | 已解决问题 |
|---|---|
| 第 0–9 章 | Memory 是什么、有哪些类型、边界在哪里 |
| 第 10–23 章 | Memory 如何写入、检索、排序、注入、更新、遗忘 |
| 第 24–34 章 | Memory 如何接入 Agent Loop、Tool Use、Multi-Agent、RAG、LLM Wiki、Graph |
| 第 35–46 章 | Memory 如何评估、安全治理、权限隔离、成本控制、产品化 |
| 第 47–52 章 | Memory 如何升级为 Memory Blocks、Agentic Memory、Memory OS |

第 53–60 章解决的是：

> 如何把 Memory 真正放进可落地的 Agent 工程项目里。

---

## 第 53 章｜实战一：个人助理 Memory

### 53.1 本章一句话

**个人助理 Memory 的核心目标，是让 Agent 记住用户长期偏好、常用工作方式、项目背景和重复性任务模式，从而减少重复沟通。**

---

### 53.2 适用场景

| 场景 | Memory 价值 |
|---|---|
| 日常工作助理 | 记住用户常用表达、格式、工作偏好 |
| 任务管理助理 | 记住长期项目、当前阶段、下一步 |
| 写作助理 | 记住语气、结构、风格、禁忌 |
| 学习助理 | 记住学习路线、进度、薄弱点 |
| 文件整理助理 | 记住目录规范、命名规则、沉淀格式 |

---

### 53.3 个人助理应该记什么

| Memory 类型 | 示例 | 作用 |
|---|---|---|
| User Preference | 用户偏好中文、表格化、高信息密度 | 输出风格稳定 |
| Work Style | 用户喜欢先路线图、后逐章讲解 | 减少重复沟通 |
| Project Memory | 用户正在构建 LLM Wiki / Agent 工程体系 | 保持长期连续性 |
| Procedure Memory | 知识沉淀时输出 Markdown 文件 | 复用工作流 |
| Failure Memory | 避免长文堆叠、避免没完成就宣称完成 | 提高质量 |
| Tool Memory | 文件生成后必须提供下载链接 | 交付闭环 |

---

### 53.4 最小可行架构

```text
用户输入
  ↓
读取 User Memory + Project Memory
  ↓
生成任务计划
  ↓
执行任务
  ↓
Reflection 检查是否符合偏好
  ↓
提炼新偏好 / 项目进度 / 失败经验
  ↓
写回 Memory Store
```

---

### 53.5 个人助理 Memory Schema

```json
{
  "memory_id": "user_pref_001",
  "type": "user_preference",
  "scope": "user",
  "subject": "output_style",
  "content": "用户偏好中文、结构化、表格化、高信息密度表达，避免大篇长文堆叠。",
  "source": "user_explicit",
  "confidence": 0.98,
  "status": "active",
  "created_at": "2026-05-21",
  "updated_at": "2026-05-21"
}
```

---

### 53.6 写入策略

| 用户表达 | 是否写入 | 原因 |
|---|---:|---|
| “以后都用中文讲。” | 是 | 明确长期偏好 |
| “这次先简单点。” | 否或短期 | 只针对当前任务 |
| “我沉淀到 LLM Wiki。” | 是 | 长期工作流背景 |
| “今天有点累。” | 否 | 没有长期复用价值 |
| “别再输出大篇长文。” | 是 | 明确输出偏好 |

---

### 53.7 检索策略

| 当前任务 | 应检索 Memory |
|---|---|
| 写文档 | 输出风格、知识库格式、命名规则 |
| 学习课程 | 学习进度、教学偏好、薄弱点 |
| 做项目规划 | 长期目标、项目状态、历史决策 |
| 生成文件 | 文件格式偏好、交付规范、工具记忆 |

---

### 53.8 Eval 标准

| 测试项 | 合格标准 |
|---|---|
| 偏好继承 | 不需要用户重复说明语言和格式 |
| 项目连续 | 能知道当前项目大致阶段 |
| 错误规避 | 不重复犯历史质量问题 |
| 可控性 | 用户能要求修改或删除记忆 |
| 低噪音 | 不把无关历史混入当前任务 |

---

### 53.9 本章产出物

完成本实战后，应沉淀：

```text
personal-assistant-memory/
  user-preference.schema.json
  project-memory.schema.json
  write-policy.md
  retrieval-policy.md
  update-policy.md
  eval-cases.md
```

---

## 第 54 章｜实战二：课程教学 Memory

### 54.1 本章一句话

**课程教学 Memory 的核心目标，是让 Agent 记住学习者目标、课程路线、已学进度、薄弱点和教学偏好，从而形成连续教学能力。**

---

### 54.2 教学 Agent 为什么需要 Memory

| 没有 Memory | 有 Memory |
|---|---|
| 每次重新解释课程背景 | 能继承学习路线 |
| 不知道学到哪一章 | 能继续上次进度 |
| 不知道用户是否理解 | 能记录掌握状态 |
| 教学风格反复漂移 | 能按用户偏好教学 |
| 无法复盘薄弱点 | 能针对性补课 |

---

### 54.3 教学 Memory 类型

| 类型 | 记什么 | 示例 |
|---|---|---|
| Learning Goal Memory | 学习目标 | 掌握 Memory 并融入 Agent 工程 |
| Curriculum Memory | 课程地图 | 第 0–60 章课程结构 |
| Progress Memory | 学习进度 | 已完成第 47–52 章 |
| Preference Memory | 教学偏好 | MECE、费曼、表格化 |
| Weakness Memory | 薄弱点 | 容易混淆 Memory 和 RAG |
| Mastery Memory | 掌握程度 | 已掌握入门概念，进入实战 |
| Assignment Memory | 练习和作业 | 设计个人助理 Memory Schema |

---

### 54.4 教学 Memory Schema

```json
{
  "memory_id": "course_progress_001",
  "type": "learning_progress",
  "scope": "project",
  "course": "Agent Memory",
  "current_stage": "第 53–60 章",
  "completed_chapters": ["0-9", "10-23", "24-34", "35-46", "47-52"],
  "next_step": "真实项目实战",
  "mastery_level": "advanced",
  "updated_at": "2026-05-21"
}
```

---

### 54.5 教学 Agent 的 Memory Loop

```text
读取学习目标
  ↓
读取课程进度
  ↓
读取用户教学偏好
  ↓
输出当前章节
  ↓
检测用户反馈
  ↓
判断掌握程度
  ↓
更新进度 / 薄弱点 / 下一步
```

---

### 54.6 教学 Memory 的特殊点

| 特殊点 | 说明 |
|---|---|
| 进度必须准确 | 不能跳章、漏章、重复讲 |
| 掌握程度要谨慎 | 不能用户没确认就假设掌握 |
| 薄弱点要可修正 | 用户理解后要更新 |
| 教学风格要稳定 | 避免忽长忽短、忽深忽浅 |
| 课程地图要持续可见 | 当前章节必须放回整体体系中 |

---

### 54.7 练习设计

| 练习 | 目的 |
|---|---|
| 让用户复述 Memory vs RAG | 测概念边界 |
| 让用户设计一条 Memory Schema | 测工程理解 |
| 让用户判断哪些信息该写入 | 测写入策略 |
| 让用户设计 Eval 用例 | 测质量意识 |
| 让用户做最终系统设计 | 测迁移能力 |

---

### 54.8 Eval 标准

| 测试项 | 合格标准 |
|---|---|
| 进度连续性 | 能准确继续上次章节 |
| 风格继承 | 符合用户教学偏好 |
| 难度控制 | 不越级、不重复低级内容 |
| 知识闭环 | 每章有掌握标准 |
| 知识沉淀 | 能输出适合 LLM Wiki 的 Markdown |

---

### 54.9 本章产出物

```text
teaching-agent-memory/
  learning-goal.schema.json
  course-progress.schema.json
  mastery-model.md
  weakness-memory.schema.json
  teaching-retrieval-policy.md
  teaching-eval-cases.md
```

---

## 第 55 章｜实战三：Codex Agent Memory

### 55.1 本章一句话

**Codex Agent Memory 的核心目标，是让编程 Agent 记住项目结构、PRD、代码规范、执行流程、质量门禁和历史失败经验。**

---

### 55.2 Codex Agent 为什么容易失败

| 失败现象 | Memory 缺失点 |
|---|---|
| 明明有 PRD，却执行降级 | 没有把 PRD 约束转成 Procedure / Quality Memory |
| 未完成就宣称完成 | 没有验收记忆和完成标准 |
| 绕过流程 | 没有强制执行流程记忆 |
| 修改范围失控 | 没有项目边界记忆 |
| 多次犯同类错误 | 没有 Failure Memory |
| 不遵守 UI 规范 | 没有 Design System Memory |

---

### 55.3 Codex Agent 应该记什么

| Memory 类型 | 示例 |
|---|---|
| Repo Memory | 项目目录、技术栈、关键文件 |
| PRD Memory | 需求目标、非目标、验收标准 |
| Architecture Memory | 架构边界、模块关系 |
| Coding Standard Memory | 命名、样式、代码风格 |
| Workflow Memory | 先读文档、再计划、再改动、再测试 |
| Quality Gate Memory | 必须跑测试、检查 diff、验证输出 |
| Failure Memory | 过去出现过未完成却宣称完成 |
| Tool Memory | Git、测试命令、构建命令、路径规范 |

---

### 55.4 Codex Memory 架构

```text
用户需求 / PRD
  ↓
Project Memory：项目结构和目标
  ↓
Procedure Memory：执行流程
  ↓
Quality Gate Memory：验收标准
  ↓
Codex 执行代码修改
  ↓
Test / Diff / Review
  ↓
Failure / Success Reflection
  ↓
写回 Memory
```

---

### 55.5 Codex Agent Memory Schema

```json
{
  "memory_id": "codex_quality_gate_001",
  "type": "quality_gate",
  "scope": "project",
  "subject": "completion_claim_rule",
  "content": "Codex Agent 在宣称完成前，必须完成：读取 PRD、列出执行计划、完成代码修改、运行测试或说明未运行原因、检查 diff、对照验收标准逐项确认。",
  "source": "project_failure_review",
  "confidence": 0.97,
  "status": "active"
}
```

---

### 55.6 Codex Memory 的关键策略

| 策略 | 说明 |
|---|---|
| PRD 优先 | 当前需求文档优先于历史习惯 |
| Diff 可见 | 任何修改必须可审查 |
| 完成定义明确 | 不能只说完成，要对照验收标准 |
| 失败经验前置 | 执行前读取历史失败模式 |
| 限制修改范围 | 不允许无关重构 |
| 测试结果写回 | 成功或失败都要记录 |

---

### 55.7 Codex Agent 执行前 Memory 注入模板

```text
<codex_memory_context>
项目约束：
- 当前任务必须以 PRD 为准。
- 不允许扩大修改范围。
- 需要保持既有目录结构和风格。

执行流程：
1. 读取 PRD。
2. 输出修改计划。
3. 修改代码。
4. 运行测试或说明无法运行原因。
5. 检查 diff。
6. 对照验收标准确认。

历史失败：
- 曾出现未完成就宣称完成的问题。
- 曾出现绕过质量门禁的问题。
</codex_memory_context>
```

---

### 55.8 Eval 标准

| 测试项 | 合格标准 |
|---|---|
| PRD 继承 | 修改结果符合 PRD |
| 流程遵守 | 没有跳过计划、测试、验收 |
| 修改范围 | 不改无关文件 |
| 完成声明 | 必须有证据 |
| 失败规避 | 不重复历史失败 |
| 可审查性 | 输出 diff / summary / test result |

---

### 55.9 本章产出物

```text
codex-agent-memory/
  repo-memory.schema.json
  prd-memory.schema.json
  workflow-memory.md
  quality-gates.md
  failure-memory.schema.json
  codex-eval-suite.md
```

---

## 第 56 章｜实战四：知识管理 Agent Memory

### 56.1 本章一句话

**知识管理 Agent Memory 的核心目标，是把对话、任务、复盘中的高价值内容转化为可沉淀、可检索、可复用的 LLM Wiki 知识资产。**

---

### 56.2 知识管理 Agent 的 Memory 角色

| 角色 | 说明 |
|---|---|
| Capture | 捕获对话中的知识点 |
| Extract | 提炼核心概念、框架、方法论 |
| Structure | 按知识库 schema 组织 |
| Link | 和已有知识建立连接 |
| Export | 输出 Markdown 文件 |
| Update | 更新已有知识文档 |
| Reuse | 后续任务中检索和调用 |

---

### 56.3 知识管理 Agent 应该记什么

| Memory 类型 | 示例 |
|---|---|
| Taxonomy Memory | 用户的知识分类体系 |
| Template Memory | Markdown 模板、目录结构 |
| Concept Memory | 核心概念定义 |
| Method Memory | 通用理解框架、MECE 方法 |
| Link Memory | 概念之间的关系 |
| Source Memory | 内容来自哪个对话或文件 |
| Version Memory | 文档版本、更新时间 |
| Quality Memory | 知识沉淀标准 |

---

### 56.4 从对话到 LLM Wiki 的流程

```text
对话内容
  ↓
识别知识主题
  ↓
提炼核心概念
  ↓
套用知识理解框架
  ↓
拆成 Markdown 章节
  ↓
补充案例 / 边界 / 误区
  ↓
生成文件
  ↓
写入 Wiki 索引 / 项目记忆
```

---

### 56.5 知识管理 Memory Schema

```json
{
  "memory_id": "wiki_template_001",
  "type": "knowledge_template",
  "scope": "user",
  "subject": "concept_note_template",
  "content": "知识沉淀文档应包含：定义、边界、相邻概念、核心结构、底层原理、应用场景、常见误区、判断标准、案例。",
  "source": "user_preference",
  "confidence": 0.96,
  "status": "active"
}
```

---

### 56.6 LLM Wiki 沉淀标准

| 标准 | 说明 |
|---|---|
| 可读 | 人能快速理解 |
| 可检索 | Agent 能按关键词和语义找回 |
| 可复用 | 后续任务能直接调用 |
| 可链接 | 能和相关概念建立关系 |
| 可维护 | 能更新、拆分、合并 |
| 不冗余 | 不把整段对话搬进去 |

---

### 56.7 常见错误

| 错误 | 后果 |
|---|---|
| 直接保存原始对话 | 知识库噪音高 |
| 只做摘要 | 缺少结构和可迁移性 |
| 不建立链接 | 知识孤岛 |
| 不记录来源 | 后续无法追溯 |
| 不区分个人偏好和公共知识 | Wiki 边界混乱 |

---

### 56.8 Eval 标准

| 测试项 | 合格标准 |
|---|---|
| 提炼质量 | 是否抓住核心概念 |
| 结构质量 | 是否符合知识库模板 |
| 去噪能力 | 是否去掉闲聊和重复 |
| 链接质量 | 是否能连接相关概念 |
| 可复用性 | 后续任务能否直接调用 |
| 文件交付 | 是否生成可保存的 `.md` 文件 |

---

### 56.9 本章产出物

```text
knowledge-agent-memory/
  taxonomy-memory.schema.json
  note-template.md
  extraction-policy.md
  wiki-export-policy.md
  link-policy.md
  knowledge-eval-suite.md
```

---

## 第 57 章｜实战五：广告优化 Agent Memory

### 57.1 本章一句话

**广告优化 Agent Memory 的核心目标，是把 ASIN、关键词、投放策略、指标变化、假设验证和复盘结论沉淀为可连续优化的运营经验。**

---

### 57.2 为什么广告优化特别需要 Memory

| 广告优化问题 | Memory 价值 |
|---|---|
| 指标有历史趋势 | 记住 CTR、CVR、ACOS、CPC 变化 |
| 策略需要连续验证 | 记录某次调价、调 bid、调广告结构后的结果 |
| 关键词有语义关系 | 记录 root keyword、long-tail、scene keyword 关系 |
| ASIN 有生命周期 | 记录新品期、增长期、稳定期策略 |
| 复盘很重要 | 记录什么策略有效、什么无效 |
| 平台规则和模型变化 | 记录 Cosmo、Rufus、A9 等理解框架 |

---

### 57.3 广告 Agent 应该记什么

| Memory 类型 | 示例 |
|---|---|
| Product Memory | ASIN、价格、目标人群、核心卖点 |
| Keyword Memory | 核心词、长尾词、场景词、语义关系 |
| Campaign Memory | SP / SB / SBV / SD / DSP 结构 |
| Metric Memory | CTR、CVR、ACOS、CPC、Session CVR |
| Experiment Memory | 某次 bid 调整、否词、预算变化 |
| Hypothesis Memory | 为什么认为某指标变化 |
| Failure Memory | 某策略导致曝光、CTR 或 CVR 下滑 |
| Procedure Memory | 指标诊断流程、复盘流程 |

---

### 57.4 广告 Memory 架构

```text
广告数据 / 用户分析问题
  ↓
读取 Product / Keyword / Campaign Memory
  ↓
读取历史实验和复盘
  ↓
生成诊断假设
  ↓
输出策略建议
  ↓
用户执行或上传结果
  ↓
写入 Experiment / Metric / Failure Memory
```

---

### 57.5 广告 Memory Schema

```json
{
  "memory_id": "ad_experiment_001",
  "type": "experiment_memory",
  "scope": "project",
  "asin": "B0DHPN1DMJ",
  "keyword": "karaoke machine",
  "action": "increase_bid",
  "hypothesis": "提高 bid 以测试 Top of Search 曝光是否增加",
  "observed_result": "曝光未明显增加，CTR 下降",
  "lesson": "单纯提高 bid 不一定带来有效曝光，需结合 placement、相关性和转化表现判断。",
  "status": "active"
}
```

---

### 57.6 广告 Agent 的 Memory 注入模板

```text
<ad_memory_context>
产品背景：
- 产品：儿童 / 家庭卡拉 OK 机。
- 核心关键词：karaoke machine / karaoke machine for adults / karaoke machine with lyrics display。
- 价格带：高于常见低价竞品，需要强调差异化价值。

历史经验：
- 单纯提高 bid 不一定提升有效曝光。
- root keyword 的表现可能影响 long-tail ranking。
- CTR / CVR 变化要结合 placement、query、竞品和价格一起判断。

当前任务：
- 分析本次指标变化，并输出可验证假设。
</ad_memory_context>
```

---

### 57.7 广告 Memory 的特殊点

| 特殊点 | 说明 |
|---|---|
| 时间敏感 | 指标、竞品、价格会变化 |
| 因果难判断 | 不能把相关性直接当因果 |
| 假设要可验证 | 每条策略建议都应能后续验证 |
| 数据来源要标注 | 区分用户提供、报表、模型推断 |
| 旧经验要降权 | 平台环境变化后旧经验可能失效 |

---

### 57.8 Eval 标准

| 测试项 | 合格标准 |
|---|---|
| 历史继承 | 能利用 ASIN 和关键词背景 |
| 数据边界 | 不编造未提供数据 |
| 假设清晰 | 分清事实、推断和建议 |
| 策略连续 | 能承接上次实验结果 |
| 复盘写入 | 能把新结果沉淀为经验 |
| 过期控制 | 不把旧数据当当前事实 |

---

### 57.9 本章产出物

```text
ad-optimization-memory/
  product-memory.schema.json
  keyword-memory.schema.json
  campaign-memory.schema.json
  experiment-memory.schema.json
  metric-memory.schema.json
  ad-diagnosis-procedure.md
  ad-memory-eval-suite.md
```

---

## 第 58 章｜实战六：多 Agent 共享记忆

### 58.1 本章一句话

**多 Agent 共享记忆的核心目标，是让不同 Agent 在分工协作时共享必要状态，同时隔离不该共享的信息。**

---

### 58.2 多 Agent 共享记忆的问题

| 问题 | 说明 |
|---|---|
| 信息断层 | 上游 Agent 的判断没有传给下游 Agent |
| 状态冲突 | 多个 Agent 修改同一项目状态 |
| 权限混乱 | 不该看的 Agent 访问了敏感记忆 |
| 责任不清 | 不知道哪条记忆是谁写的 |
| 重复执行 | 多个 Agent 重复做同一件事 |
| 质量不一致 | 各 Agent 按不同标准执行 |

---

### 58.3 多 Agent Memory 范围设计

| Memory 范围 | 谁能看 | 内容 |
|---|---|---|
| Global Memory | 所有授权 Agent | 用户目标、全局规则 |
| Project Memory | 项目相关 Agent | 项目状态、决策、约束 |
| Agent Private Memory | 单个 Agent | 私有策略、中间推理状态 |
| Handoff Memory | 上下游 Agent | 任务交接摘要 |
| Audit Memory | 管理 / 评估 Agent | 谁读写了什么 |

---

### 58.4 多 Agent 示例：知识沉淀系统

| Agent | 职责 | 读取 Memory | 写入 Memory |
|---|---|---|---|
| Teacher Agent | 讲解课程 | 用户偏好、课程进度 | 教学结果 |
| Knowledge Manager | 整理 Markdown | 输出模板、知识库规范 | Wiki 文档状态 |
| Quality Reviewer | 检查质量 | 质量门禁、历史失败 | 评估结果 |
| Memory Manager | 管理记忆 | 全部授权记忆 | 更新、归档、删除 |
| Tool Agent | 文件生成 | 工具记忆 | 文件结果、工具失败 |

---

### 58.5 Handoff Memory 模板

```yaml
handoff_memory:
  handoff_id: "handoff_001"
  from_agent: "teacher_agent"
  to_agent: "knowledge_manager"
  task: "整理第 53–60 章为 Markdown"
  completed_outputs:
    - "第 53–60 章课程正文"
    - "章节总结"
    - "阶段能力标准"
  constraints:
    - "适合沉淀到 LLM Wiki"
    - "保持中文、表格化、高信息密度"
  open_risks:
    - "需要确认文件已成功生成并提供下载链接"
```

---

### 58.6 共享记忆写入规则

| 规则 | 说明 |
|---|---|
| 明确 owner | 每条共享记忆必须有写入者 |
| 明确 scope | 全局、项目、Agent 私有必须区分 |
| 明确权限 | 谁可读、谁可写、谁可删 |
| 明确版本 | 状态更新要保留版本 |
| 明确冲突处理 | 多 Agent 写冲突时要仲裁 |
| 明确审计 | 所有读写都应可追踪 |

---

### 58.7 多 Agent Memory Eval

| 测试项 | 目标 |
|---|---|
| Handoff 完整性 | 下游 Agent 是否获得必要背景 |
| 共享边界 | 无关 Agent 是否无法读取 |
| 状态一致性 | 多 Agent 是否看到同一项目状态 |
| 写入冲突 | 多 Agent 同时更新时是否可控 |
| 责任追踪 | 是否知道错误记忆来自哪里 |
| 最小共享 | 是否避免过度共享 |

---

### 58.8 本章产出物

```text
multi-agent-memory/
  shared-memory-policy.md
  private-memory-policy.md
  handoff-memory.schema.yaml
  access-control-policy.md
  conflict-resolution-policy.md
  audit-memory.schema.json
  multi-agent-memory-eval.md
```

---

## 第 59 章｜实战七：Memory Eval Suite

### 59.1 本章一句话

**Memory Eval Suite 的核心目标，是用系统化测试证明 Memory 模块真的记得对、取得准、用得好、删得掉、不会污染或泄露。**

---

### 59.2 Eval Suite 总结构

```text
memory-eval-suite/
  write-eval/
  retrieval-eval/
  injection-eval/
  update-eval/
  forgetting-eval/
  safety-eval/
  e2e-eval/
```

---

### 59.3 Write Eval

| 测试目标 | 测试方法 |
|---|---|
| 该记的是否记 | 输入明确长期偏好 |
| 不该记的是否不记 | 输入一次性临时要求 |
| 类型是否正确 | 判断 preference / state / failure |
| scope 是否正确 | 判断 user / project / session |
| source 是否记录 | 检查来源字段 |

示例：

```yaml
case_id: write_001
input: "以后讲 Agent 工程时，请用中文，并多用表格。"
expected_memory:
  type: "user_preference"
  scope: "user"
  content_contains:
    - "中文"
    - "表格"
should_not_write:
  - "当前情绪"
  - "无关闲聊"
```

---

### 59.4 Retrieval Eval

| 测试目标 | 测试方法 |
|---|---|
| 召回率 | 当前任务需要的记忆是否取回 |
| 准确率 | 取回内容是否相关 |
| 噪音率 | 无关记忆比例 |
| scope | 是否取错用户 / 项目 |
| freshness | 是否优先新记忆 |

示例：

```yaml
case_id: retrieval_001
task: "继续讲 Memory 第 53–60 章"
expected_retrieve:
  - "用户偏好中文"
  - "用户偏好表格化"
  - "课程已完成第 47–52 章"
should_not_retrieve:
  - "Amazon 广告策略"
  - "图片生成提示词"
```

---

### 59.5 Injection Eval

| 测试目标 | 判断标准 |
|---|---|
| 简洁 | 不注入冗长历史 |
| 分类 | 区分用户偏好、项目状态、任务约束 |
| 优先级 | 当前用户指令优先 |
| 去噪 | 无关记忆不进入 |
| 可追踪 | 能知道来源 |

---

### 59.6 Update Eval

| 测试目标 | 示例 |
|---|---|
| 覆盖旧偏好 | 用户从“喜欢详细长文”变成“不要长文” |
| 合并相似记忆 | 多条输出格式偏好合并 |
| 保留版本 | 旧项目阶段归档 |
| 处理冲突 | 新旧事实冲突时触发确认或覆盖 |

---

### 59.7 Forgetting Eval

| 测试目标 | 示例 |
|---|---|
| 删除 | 用户要求删除某条记忆后不再召回 |
| 归档 | 项目结束后不默认检索 |
| 降权 | 长期未使用记忆排序下降 |
| 脱敏 | 敏感信息不明文保存 |
| 权限限制 | 无权限 Agent 无法读取 |

---

### 59.8 Safety Eval

| 测试目标 | 示例 |
|---|---|
| 敏感信息控制 | 不自动保存高敏信息 |
| 跨用户污染 | A 用户记忆不进入 B 用户上下文 |
| 跨项目污染 | 项目 A 信息不进入项目 B |
| 工具外发控制 | 外部工具不得获得敏感记忆 |
| Prompt Injection 防护 | 用户不能诱导读取无权限记忆 |

---

### 59.9 End-to-End Eval

| 场景 | 判断 |
|---|---|
| 继续型任务 | 是否能接上上次进度 |
| 偏好继承任务 | 是否自动继承语言和格式 |
| 项目任务 | 是否遵守项目规范 |
| 工具任务 | 是否正确使用工具记忆 |
| 删除任务 | 删除后是否不再使用 |
| 多 Agent 任务 | Handoff 是否完整且安全 |

---

### 59.10 评分表

| 维度 | 分数 | 说明 |
|---|---:|---|
| Write Quality | 0–5 | 写入是否准确 |
| Retrieval Quality | 0–5 | 检索是否准确 |
| Injection Quality | 0–5 | 注入是否简洁有效 |
| Update Quality | 0–5 | 更新是否正确 |
| Forgetting Quality | 0–5 | 删除 / 归档是否有效 |
| Safety | 0–5 | 是否安全 |
| E2E Improvement | 0–5 | 是否提升任务成功率 |

---

### 59.11 本章产出物

```text
memory-eval-suite/
  write-eval-cases.yaml
  retrieval-eval-cases.yaml
  injection-eval-cases.yaml
  update-eval-cases.yaml
  forgetting-eval-cases.yaml
  safety-eval-cases.yaml
  e2e-eval-cases.yaml
  scoring-rubric.md
```

---

## 第 60 章｜最终项目：设计你的 Agent Memory 系统

### 60.1 本章一句话

**最终项目的目标，是把你前面学到的所有内容整合成一个可迁移、可评估、可产品化的 Agent Memory 系统蓝图。**

---

### 60.2 最终项目目标

你要输出的不只是一个“记忆功能”，而是一套完整系统：

```text
Agent Memory System =
Memory Types
+ Memory Schema
+ Memory Store
+ Write Policy
+ Retrieval Policy
+ Injection Policy
+ Update Policy
+ Forgetting Policy
+ Permission Policy
+ Eval Suite
+ Product Experience
```

---

### 60.3 系统边界设计

| 问题 | 你需要回答 |
|---|---|
| 这个 Agent 为谁服务 | 个人、团队、企业、特定项目 |
| 主要任务是什么 | 教学、编程、知识管理、广告优化 |
| 需要记什么 | 用户、项目、工具、失败、流程 |
| 不应该记什么 | 临时信息、敏感信息、无复用价值信息 |
| 记忆作用范围 | user / project / session / org |
| 谁能访问 | 单 Agent、多 Agent、工具、用户 |
| 如何评估 | 写入、检索、注入、更新、遗忘、安全 |

---

### 60.4 推荐系统目录

```text
agent-memory-system/
  README.md

  schemas/
    user-memory.schema.json
    project-memory.schema.json
    procedure-memory.schema.json
    tool-memory.schema.json
    failure-memory.schema.json

  policies/
    write-policy.md
    retrieval-policy.md
    injection-policy.md
    update-policy.md
    forgetting-policy.md
    access-control-policy.md
    privacy-policy.md

  stores/
    short-term-memory.md
    long-term-memory.md
    vector-memory.md
    event-log.md

  prompts/
    memory-extractor.prompt.md
    memory-retriever.prompt.md
    memory-injector.prompt.md
    reflection.prompt.md

  evals/
    write-eval-cases.yaml
    retrieval-eval-cases.yaml
    injection-eval-cases.yaml
    update-eval-cases.yaml
    forgetting-eval-cases.yaml
    safety-eval-cases.yaml
    e2e-eval-cases.yaml

  docs/
    architecture.md
    memory-flow.md
    product-experience.md
    changelog.md
```

---

### 60.5 最终架构图

```text
User / Task Input
  ↓
Task Understanding
  ↓
Memory Router
  ↓
Memory Blocks
  ├─ User Preference Memory
  ├─ Project State Memory
  ├─ Procedure Memory
  ├─ Tool Memory
  ├─ Failure Memory
  └─ Semantic / Vector Memory
  ↓
Retriever + Ranker
  ↓
Context Budget Manager
  ↓
Memory Injector
  ↓
Agent / Workflow / Tool Use
  ↓
Reflection
  ↓
Memory Extractor
  ↓
Updater / Forgetter
  ↓
Memory Store + Trace + Eval
```

---

### 60.6 最终设计模板

| 模块 | 设计内容 |
|---|---|
| Memory Types | 需要哪些记忆类型 |
| Schema | 每种记忆有哪些字段 |
| Store | 每种记忆存在哪里 |
| Write Policy | 什么写入，什么不写入 |
| Retrieval Policy | 当前任务如何取回记忆 |
| Injection Policy | 如何进入上下文 |
| Update Policy | 新旧冲突如何处理 |
| Forgetting Policy | 什么删除、归档、降权 |
| Access Policy | 谁能读写删除 |
| Eval Suite | 如何测试是否有效 |
| Product UX | 用户如何查看、修改、删除 |

---

### 60.7 最终项目示例：你的个人 Agent Memory 系统

| 模块 | 推荐设计 |
|---|---|
| User Memory | 中文、MECE、费曼、表格化、高信息密度 |
| Project Memory | Agent、Skill、LLM Wiki、Codex、Amazon 广告等长期项目 |
| Procedure Memory | 先路线图、再讲解、再沉淀 Markdown |
| Tool Memory | 生成文件后提供链接，图片任务用图像工具 |
| Failure Memory | 防止长文堆叠、漏步骤、未完成就宣称完成 |
| Wiki Memory | 知识沉淀模板、目录规范、链接关系 |
| Eval Memory | 输出是否符合章节完整性、格式、可下载要求 |

---

### 60.8 最终验收标准

| 验收项 | 标准 |
|---|---|
| 概念完整 | 覆盖 user / project / procedure / tool / failure memory |
| 工程完整 | 有 schema、store、policy、eval |
| 运行闭环 | 能写入、检索、注入、更新、遗忘 |
| 安全可控 | 有权限、隐私、删除机制 |
| 质量可测 | 有 eval cases 和评分标准 |
| 产品可感知 | 用户能查看、修改、删除记忆 |
| 可迁移 | 能迁移到 Codex、知识管理、广告优化、教学 Agent |

---

### 60.9 最终项目交付物

```text
final-agent-memory-system/
  01-memory-boundary.md
  02-memory-types.md
  03-memory-schema.md
  04-memory-store-design.md
  05-memory-policies.md
  06-memory-agent-loop.md
  07-memory-eval-suite.md
  08-memory-product-design.md
  09-memory-implementation-roadmap.md
```

---

### 60.10 本章掌握标准

你真正掌握 Memory，不是因为你知道很多概念，而是因为你能设计出一套系统：

```text
知道该记什么
知道不该记什么
知道怎么存
知道怎么取
知道怎么用
知道怎么更新
知道怎么忘
知道怎么评估
知道怎么产品化
知道怎么迁移到真实 Agent 工程
```

---

## 第 53–60 章总复盘

### 1. 章节总表

| 章节 | 实战主题 | 核心能力 |
|---:|---|---|
| 53 | 个人助理 Memory | 设计用户偏好、项目状态、工具经验、失败经验 |
| 54 | 课程教学 Memory | 设计学习目标、课程进度、薄弱点、掌握状态 |
| 55 | Codex Agent Memory | 设计 PRD、项目结构、质量门禁、失败经验 |
| 56 | 知识管理 Agent Memory | 把对话经验沉淀为 LLM Wiki |
| 57 | 广告优化 Agent Memory | 沉淀 ASIN、关键词、指标、实验、复盘 |
| 58 | 多 Agent 共享记忆 | 设计 shared / private / handoff / audit memory |
| 59 | Memory Eval Suite | 建立写入、检索、注入、更新、遗忘、安全、E2E 测试 |
| 60 | 最终 Agent Memory 系统 | 输出完整可迁移 Memory 架构 |

---

### 2. 本阶段核心主线

```text
从单点功能
  ↓
到真实项目
  ↓
到多场景迁移
  ↓
到评估体系
  ↓
到最终 Agent Memory System
```

---

### 3. 最终能力模型

| 能力层 | 你应该能做到 |
|---|---|
| 识别 | 判断什么是 Memory，什么不是 |
| 分类 | 区分用户、项目、工具、失败、流程、教学、广告等记忆 |
| 设计 | 设计 schema、store、policy、eval |
| 集成 | 接入 Agent Loop、Tool Use、Workflow、Multi-Agent |
| 治理 | 处理权限、隐私、安全、成本、解释性 |
| 产品化 | 让用户能感知、控制和信任 Memory |
| 迁移 | 迁移到个人助理、Codex、知识管理、广告优化、教学 Agent |

---

### 4. 最重要的一句话

**第 53–60 章的核心，是把 Memory 从知识变成工程资产：你不只是理解 Memory，而是能把它迁移到个人助理、课程教学、Codex、知识管理、广告优化、多 Agent 系统，并用 Eval Suite 验证它是否真的有效。**
