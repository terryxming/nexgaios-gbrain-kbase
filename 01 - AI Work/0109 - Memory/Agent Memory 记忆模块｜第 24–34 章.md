# Agent Memory 记忆模块｜第 24–34 章

> 主题：Memory 与 Agent Loop 集成、Memory 与 RAG / LLM Wiki / Graph 融合  
> 目标：把 Memory 从“独立模块”接入真实 Agent 工程系统。

---

## 阶段定位

第 0–9 章解决：Memory 是什么、有哪些类型、边界在哪里。  
第 10–23 章解决：Memory 如何写入、检索、排序、注入、更新、遗忘。  
第 24–34 章解决：Memory 如何真正嵌入 Agent Loop、工具调用、多 Agent 系统、RAG、LLM Wiki 与 Graph 系统。

| 范围 | 主题 | 核心问题 |
|---|---|---|
| 第 24–29 章 | Memory 与 Agent Loop 集成 | Memory 如何参与感知、计划、执行、反思、多 Agent 协作 |
| 第 30–34 章 | Memory 与知识系统融合 | Memory 如何与 RAG、向量检索、结构化数据库、LLM Wiki、Graph 组合 |

---

# 第 24 章｜Agent Loop 中的 Memory 位置

## 24.1 本章一句话

Memory 不是 Agent Loop 外面的“资料库”，而是贯穿感知、计划、执行、观察、反思、更新的状态系统。

---

## 24.2 标准 Agent Loop

```text
用户输入
  ↓
Perception 感知
  ↓
Planning 计划
  ↓
Tool Use 工具调用 / Action 执行
  ↓
Observation 观察结果
  ↓
Reflection 反思
  ↓
Memory Update 记忆更新
  ↓
下一轮 Agent Loop
```

---

## 24.3 Memory 在每个环节中的作用

| Agent Loop 环节 | Memory 作用 | 示例 |
|---|---|---|
| Perception 感知 | 识别当前任务和历史背景 | 用户说“继续”，需要知道继续哪一章 |
| Planning 计划 | 调用历史经验辅助拆解步骤 | 先讲义，再生成 `.md` 文件 |
| Tool Use 工具调用 | 记住工具能力、限制、路径、失败经验 | 生成文件后必须提供下载链接 |
| Observation 观察 | 保存工具返回结果和执行状态 | 文件是否生成成功 |
| Reflection 反思 | 复盘这次执行是否符合标准 | 是否漏掉章节、格式是否符合知识库要求 |
| Update 更新 | 把新偏好、新项目状态、新失败经验写回 | 当前课程完成第 24–34 章 |

---

## 24.4 Memory 的两条路径

| 路径 | 说明 | 例子 |
|---|---|---|
| Read Path | Agent 执行前读取相关记忆 | 取回用户偏好和项目进度 |
| Write Path | Agent 执行后写入新记忆 | 记录本阶段已完成 |

```text
Read Path：Memory → Agent Context → Agent Decision
Write Path：Agent Result → Memory Extractor → Memory Store
```

---

## 24.5 错误理解

| 错误理解 | 正确认知 |
|---|---|
| Memory 只在对话开始时读取一次 | 复杂任务中，每个关键步骤都可能需要读取状态 |
| Memory 只在任务结束后更新 | 工具调用、计划变更、失败复盘后都可能更新 |
| Memory 只是长期记忆 | Agent Loop 里还有 working memory、short-term state、tool memory |
| Memory 和 Agent State 无关 | 短期记忆通常就是 Agent State 的一部分 |

---

## 24.6 费曼解释

一个没有 Memory 的 Agent 像“只会看当前纸条的人”。  
一个有 Memory 的 Agent 像“带着项目笔记、操作手册、复盘记录工作的人”。

---

## 24.7 本章掌握标准

你能画出：

```text
Agent Loop 的每一步分别读取什么记忆、产生什么记忆、更新什么记忆。
```

---

# 第 25 章｜Tool Use 与 Memory

## 25.1 本章一句话

Tool Use 让 Agent 能做事，Memory 让 Agent 记住工具怎么用、工具做过什么、工具哪里容易失败。

---

## 25.2 Tool Use 中有三类记忆

| 类型 | 记什么 | 示例 |
|---|---|---|
| Tool Capability Memory | 工具能做什么 | 文件生成、网页搜索、代码执行、图片生成 |
| Tool Result Memory | 工具做了什么 | 生成了哪个文件、返回了什么数据 |
| Tool Failure Memory | 工具哪里失败过 | 路径错误、权限错误、格式不兼容 |

---

## 25.3 Tool Use 与 Memory 的流程

```text
当前任务
  ↓
检索工具相关记忆
  ↓
选择工具
  ↓
调用工具
  ↓
读取工具结果
  ↓
判断是否成功
  ↓
写入结果 / 失败经验
```

---

## 25.4 Tool Memory 应该记录什么

| 字段 | 说明 | 示例 |
|---|---|---|
| tool_name | 工具名称 | file_exporter |
| capability | 能力 | 生成 Markdown 文件 |
| input_requirement | 输入要求 | 需要文件名和正文 |
| output | 输出内容 | `.md` 文件路径 |
| limitation | 限制 | 不支持后台异步交付 |
| failure_case | 常见失败 | 路径不存在 |
| recovery | 修复方式 | 创建目录后重试 |

---

## 25.5 Tool Result 是否要长期保存

| 工具结果 | 是否长期保存 | 原因 |
|---|---:|---|
| 当前生成的临时文件路径 | 通常否 | 短期任务内有用 |
| 常用导出流程 | 是 | 可复用 |
| 某次报错堆栈 | 视情况 | 如果能形成失败经验，则保存 |
| 用户项目目录规范 | 是 | 影响未来执行 |
| 一次网页搜索结果 | 通常否 | 时效性强，容易过期 |

---

## 25.6 常见错误

| 错误 | 后果 |
|---|---|
| 不记工具限制 | Agent 重复调用不合适的工具 |
| 不记工具结果 | 后续步骤无法接上 |
| 不记失败经验 | 同类错误重复发生 |
| 把所有工具输出长期保存 | Memory Store 膨胀，噪音增加 |

---

## 25.7 本章掌握标准

你能判断：

```text
一次工具调用之后，哪些结果只属于当前状态，哪些应该沉淀为长期 Tool Memory 或 Failure Memory。
```

---

# 第 26 章｜Planning 与 Memory

## 26.1 本章一句话

Planning 负责决定“接下来怎么做”，Memory 负责提供“过去怎么做过、哪些约束不能忘、哪些坑不能再踩”。

---

## 26.2 Planning 为什么需要 Memory

| 没有 Memory 的 Planning | 有 Memory 的 Planning |
|---|---|
| 每次重新拆解任务 | 复用历史任务模式 |
| 忽略用户长期偏好 | 按用户习惯制定计划 |
| 重复踩坑 | 使用失败记忆规避风险 |
| 计划和项目状态脱节 | 继承当前阶段和上次决策 |

---

## 26.3 Planning 需要检索哪些记忆

| 记忆类型 | 用途 | 示例 |
|---|---|---|
| User Memory | 计划风格适配 | 用户喜欢先路线图后讲解 |
| Project Memory | 继承项目状态 | 已完成第 10–23 章，当前进入第 24–34 章 |
| Procedural Memory | 复用流程 | 先讲完整内容，再导出 Markdown |
| Failure Memory | 风险预防 | 防止输出不完整就宣称完成 |
| Tool Memory | 选择合适工具 | 需要生成文件时使用文件写入工具 |

---

## 26.4 Memory-Augmented Planning 模板

```text
1. 理解当前任务
2. 读取用户偏好记忆
3. 读取项目状态记忆
4. 读取相似任务流程记忆
5. 读取相关失败记忆
6. 生成计划
7. 执行计划
8. 根据结果更新记忆
```

---

## 26.5 计划层常见风险

| 风险 | 表现 | 解决方式 |
|---|---|---|
| 过度依赖旧计划 | 当前任务已经变化还照旧执行 | 当前指令优先 |
| 取错项目状态 | 把其他项目进度混进来 | project_id 隔离 |
| 忽略失败记忆 | 重复发生低级错误 | planning 前检索 failure memory |
| 计划太泛 | 没有转成可执行步骤 | 引入 procedural memory |

---

## 26.6 本章掌握标准

你能设计：

```text
Plan 生成之前，Agent 应该读取哪些 Memory；Plan 执行之后，应该写回哪些 Memory。
```

---

# 第 27 章｜Reflection 与 Memory

## 27.1 本章一句话

Reflection 负责复盘“这次做得怎么样”，Memory 负责把复盘结论沉淀成未来可用的经验。

---

## 27.2 Reflection 的作用

| 问题 | Reflection 要回答 |
|---|---|
| 任务是否完成 | 是否满足用户要求 |
| 过程是否合格 | 是否按计划执行 |
| 输出是否达标 | 是否符合格式、质量、边界 |
| 出现什么问题 | 错误原因是什么 |
| 下次怎么改 | 什么经验要写入 Memory |

---

## 27.3 Reflection 可以产生哪些 Memory

| Reflection 结论 | 转化为 Memory |
|---|---|
| 用户反复要求表格化 | User Preference Memory |
| 某章节已经完成 | Project Memory |
| 生成文件时容易漏链接 | Failure Memory |
| 某类任务应先讲再导出 | Procedural Memory |
| 某工具适合某文件格式 | Tool Memory |

---

## 27.4 Reflection → Memory 流程

```text
执行结果
  ↓
对照任务目标检查
  ↓
发现成功经验 / 失败问题
  ↓
判断是否有未来复用价值
  ↓
提炼成候选记忆
  ↓
写入或更新 Memory Store
```

---

## 27.5 Failure Memory 是 Reflection 的高价值产物

| 失败 | 反思结论 | 未来记忆 |
|---|---|---|
| 输出章节不完整 | 没有验收清单 | 长任务必须做章节完整性检查 |
| 生成文件后没给链接 | 交付动作缺失 | 文件类任务最终必须给下载链接 |
| 混入无关背景 | 检索范围过宽 | 当前项目优先，低相关记忆不注入 |
| 长文难读 | 信息组织不佳 | 优先表格化和模块化 |

---

## 27.6 常见错误

| 错误 | 后果 |
|---|---|
| 只反思，不写入 | 下次仍然重复犯错 |
| 把所有反思都写入 | 记忆库变脏 |
| 只写失败，不写成功流程 | 无法复用有效方法 |
| 不区分一次性失败和系统性失败 | 过度修正 |

---

## 27.7 本章掌握标准

你能把一次任务复盘拆成：

```text
成功经验 → Procedural Memory
失败原因 → Failure Memory
项目进展 → Project Memory
用户反馈 → User Memory
```

---

# 第 28 章｜Multi-Agent Memory

## 28.1 本章一句话

多 Agent 系统中的 Memory 设计，核心不是“大家共享所有记忆”，而是区分共享记忆、私有记忆、任务交接记忆和权限边界。

---

## 28.2 多 Agent 为什么更需要 Memory

| 问题 | 没有 Memory 的后果 |
|---|---|
| 多 Agent 分工 | 每个 Agent 只知道自己局部任务 |
| 任务交接 | 上一个 Agent 的决策无法传给下一个 Agent |
| 状态同步 | 各 Agent 对项目状态理解不一致 |
| 质量控制 | 审核 Agent 不知道执行 Agent 的约束 |
| 工具调用 | 多个 Agent 重复调用同一工具或重复踩坑 |

OpenAI 对 Agents 的描述中包含 plan、tools、collaborate across specialists、state 等特征，这说明多 Agent 场景中状态和交接不是附属问题，而是系统能力的一部分。

---

## 28.3 多 Agent Memory 的四种范围

| 范围 | 谁能访问 | 适合内容 |
|---|---|---|
| Private Memory | 单个 Agent | 专属策略、内部中间状态 |
| Shared Memory | 多个 Agent | 项目目标、全局约束、关键决策 |
| Handoff Memory | 上下游 Agent | 任务交接摘要、输入输出契约 |
| User-level Memory | 面向所有授权 Agent | 用户偏好、长期目标 |

---

## 28.4 示例：课程生成多 Agent 系统

| Agent | 私有记忆 | 共享记忆 |
|---|---|---|
| Course Designer | 课程结构方法 | 用户学习目标、章节进度 |
| Teacher Agent | 教学表达策略 | 用户偏好中文、表格化 |
| Knowledge Manager | Markdown 沉淀规范 | 当前章节内容 |
| Quality Reviewer | 检查清单 | 课程完整性标准 |

---

## 28.5 Handoff Memory 模板

```yaml
handoff_memory:
  from_agent: course_teacher
  to_agent: knowledge_manager
  task_summary: 已完成第 24–34 章课程讲义
  key_outputs:
    - 每章核心概念
    - 总结表
    - 阶段能力标准
  constraints:
    - 输出为 Markdown
    - 适合沉淀到 LLM Wiki
  open_issues: []
```

---

## 28.6 多 Agent Memory 的常见风险

| 风险 | 说明 | 解决方式 |
|---|---|---|
| 共享过度 | 所有 Agent 看到所有信息 | 最小必要共享 |
| 共享不足 | 下游 Agent 缺少关键背景 | Handoff Memory |
| 状态冲突 | 不同 Agent 更新同一字段 | 写入权限和锁 |
| 责任不清 | 不知道谁写错了记忆 | source、agent_id、trace_id |
| 权限泄露 | 私有记忆被错误共享 | scope + access policy |

---

## 28.7 本章掌握标准

你能为多 Agent 系统设计：

```text
哪些记忆共享
哪些记忆私有
哪些记忆用于交接
谁有读写权限
```

---

# 第 29 章｜Skill / Workflow / Agent 与 Memory

## 29.1 本章一句话

Skill、Workflow、Agent 都可以使用 Memory，但三者使用 Memory 的粒度不同。

---

## 29.2 三者区别

| 概念 | 本质 | Memory 作用 |
|---|---|---|
| Skill | 可复用能力包 | 记住触发条件、执行规范、质量门禁 |
| Workflow | 固定或半固定流程 | 记住流程状态、步骤结果、异常处理 |
| Agent | 自主决策系统 | 记住用户、项目、工具、失败经验 |

---

## 29.3 Skill 中的 Memory

Skill 通常不应该拥有大量自由记忆，而应该拥有明确的执行契约。

| Skill Memory | 示例 |
|---|---|
| Trigger Memory | 什么场景该调用这个 Skill |
| Procedure Memory | 调用后执行哪些步骤 |
| Quality Gate Memory | 输出必须满足什么检查 |
| Near-miss Memory | 哪些情况不应该触发 |

示例：

```text
complex-task-clarifier skill：
当用户提出复杂、模糊、早期想法时，不直接执行，而是先做需求澄清、任务建模、上下文审计、验收标准设计。
```

---

## 29.4 Workflow 中的 Memory

Workflow Memory 更关注流程状态。

| Workflow 状态 | 示例 |
|---|---|
| 当前步骤 | 已完成讲义输出，下一步生成 `.md` |
| 输入输出 | 讲义正文、文件路径 |
| 分支状态 | 是否需要用户确认 |
| 失败恢复 | 文件生成失败后重试 |

---

## 29.5 Agent 中的 Memory

Agent Memory 更综合。

| Agent 记忆 | 示例 |
|---|---|
| 用户偏好 | 中文、表格化、MECE |
| 项目状态 | 当前课程阶段 |
| 工具经验 | 文件生成后要给链接 |
| 失败经验 | 长任务必须检查完整性 |
| 决策历史 | 为什么采用某个课程顺序 |

---

## 29.6 三者组合方式

```text
Agent 负责判断目标和调度
  ↓
Workflow 负责流程推进
  ↓
Skill 负责局部能力执行
  ↓
Memory 贯穿三者，提供状态、偏好、经验和质量约束
```

---

## 29.7 常见错误

| 错误 | 后果 |
|---|---|
| 把所有 Memory 都塞进 Skill | Skill 变得臃肿且不通用 |
| Workflow 不记录状态 | 长流程容易断裂 |
| Agent 不记录失败经验 | 反复出现质量漂移 |
| Skill 没有质量门禁记忆 | 每次输出标准不稳定 |

---

## 29.8 本章掌握标准

你能判断：

```text
某条记忆应该属于 Skill 规范、Workflow 状态，还是 Agent 长期记忆。
```

---

# 第 30 章｜Memory 与 RAG 的组合边界

## 30.1 本章一句话

RAG 主要解决“外部知识怎么取回来”，Memory 主要解决“用户、项目、任务、经验怎么延续”。

---

## 30.2 RAG 与 Memory 对比

| 维度 | RAG | Memory |
|---|---|---|
| 核心对象 | 外部知识、文档、资料 | 用户偏好、项目状态、历史经验 |
| 主要问题 | 当前问题需要哪些知识 | 当前任务需要哪些历史上下文 |
| 典型内容 | 文档、论文、网页、知识库 | 偏好、进度、失败教训、流程规则 |
| 更新频率 | 文档更新时更新 | 每次任务或阶段后可能更新 |
| 作用 | 提供事实和资料 | 提供连续性和个性化 |

---

## 30.3 什么时候用 RAG

| 情况 | 示例 |
|---|---|
| 需要查外部资料 | 查框架文档、论文、政策 |
| 需要引用知识库内容 | 从公司 SOP 中找答案 |
| 需要处理大量文档 | 对几十份 PDF 做问答 |
| 需要事实依据 | 查某工具最新 API |

---

## 30.4 什么时候用 Memory

| 情况 | 示例 |
|---|---|
| 需要记住用户偏好 | 用户喜欢中文、表格化 |
| 需要继承项目状态 | 课程进入第 24–34 章 |
| 需要复用历史经验 | 之前某种输出格式效果好 |
| 需要规避重复错误 | 之前导出文件忘了链接 |

---

## 30.5 RAG + Memory 的组合流程

```text
当前任务
  ↓
Memory 检索：取回用户偏好、项目状态、历史经验
  ↓
RAG 检索：取回外部知识、文档、资料
  ↓
合并上下文
  ↓
Agent 推理和输出
  ↓
将任务结果和新经验写回 Memory
```

---

## 30.6 常见错误

| 错误 | 正确认知 |
|---|---|
| 用 RAG 替代 Memory | RAG 不天然记得用户和项目状态 |
| 用 Memory 替代 RAG | Memory 不适合保存大量外部知识全文 |
| 把用户偏好放进向量知识库乱检索 | 用户偏好应结构化、可控、可更新 |
| 把所有历史对话当 RAG 文档 | 会产生大量噪音和隐私风险 |

---

## 30.7 本章掌握标准

你能判断：

```text
当前任务需要的是外部知识检索，还是历史上下文延续，还是两者都需要。
```

---

# 第 31 章｜Memory + 向量检索

## 31.1 本章一句话

向量检索适合处理“语义相似的历史记忆”，但不适合管理所有 Memory。

---

## 31.2 向量检索适合什么 Memory

| 适合内容 | 原因 |
|---|---|
| 历史对话片段 | 用户表达方式多样，关键词不稳定 |
| 相似失败案例 | 失败描述可能不同但本质相似 |
| 经验片段 | 适合按语义召回 |
| 非结构化笔记 | 不容易用固定字段筛选 |

---

## 31.3 不适合只用向量检索的 Memory

| 内容 | 原因 | 更适合方式 |
|---|---|---|
| 用户语言偏好 | 应该精确读取 | JSON / SQL |
| 当前项目阶段 | 需要确定状态 | Project State |
| 权限配置 | 不能靠相似度 | RBAC / Policy Store |
| 工具开关 | 需要精确控制 | KV Store |
| 敏感信息 | 检索风险高 | 加密 / 权限隔离 |

---

## 31.4 Memory + Vector 的典型架构

```text
Memory Item
  ↓
结构化字段保存到 SQL / JSON
  ↓
文本内容 embedding 后保存到 Vector Store
  ↓
检索时先按 metadata 过滤
  ↓
再做语义相似度召回
  ↓
最后 rerank 和注入
```

---

## 31.5 Metadata 很重要

向量检索不能只靠 embedding，相当一部分准确性来自 metadata 过滤。

| Metadata | 用途 |
|---|---|
| user_id | 防止跨用户污染 |
| project_id | 防止跨项目污染 |
| memory_type | 控制召回类型 |
| created_at / updated_at | 控制新旧优先级 |
| status | 排除 archived / deprecated |
| confidence | 排除低可信记忆 |

---

## 31.6 常见错误

| 错误 | 后果 |
|---|---|
| 所有 Memory 都扔进向量库 | 状态不可控 |
| 不做 metadata 过滤 | 跨用户、跨项目污染 |
| 只看相似度 | 旧信息、低可信信息被召回 |
| 不做 rerank | 相似但无用的内容进入上下文 |

---

## 31.7 本章掌握标准

你能设计：

```text
哪些 Memory 进入向量库
哪些 Memory 保持结构化
检索时如何用 metadata 限定范围
```

---

# 第 32 章｜Memory + 结构化数据库

## 32.1 本章一句话

结构化数据库适合保存稳定、可精确查询、可更新、可审计的 Memory。

---

## 32.2 哪些 Memory 适合结构化存储

| Memory 类型 | 示例 |
|---|---|
| User Preference | 用户工作语言、输出格式偏好 |
| Project State | 当前阶段、已完成任务、下一步 |
| Tool Capability | 工具名称、能力、限制 |
| Permission | 读写权限、可见范围 |
| Evaluation Result | 测试结果、质量评分 |

---

## 32.3 结构化 Memory 表设计示例

| 字段 | 类型 | 说明 |
|---|---|---|
| memory_id | string | 记忆 ID |
| user_id | string | 用户 ID |
| project_id | string | 项目 ID |
| type | string | preference / state / failure / procedure |
| subject | string | 记忆主题 |
| content | text/json | 记忆内容 |
| confidence | float | 可信度 |
| status | string | active / archived / deprecated |
| created_at | datetime | 创建时间 |
| updated_at | datetime | 更新时间 |

---

## 32.4 结构化数据库的优势

| 优势 | 说明 |
|---|---|
| 精确查询 | 按用户、项目、类型筛选 |
| 可更新 | 精确覆盖某个字段 |
| 可审计 | 记录来源和更新时间 |
| 可权限控制 | 支持访问策略 |
| 可评估 | 方便做一致性检查 |

---

## 32.5 结构化数据库的不足

| 不足 | 解决方式 |
|---|---|
| 语义检索弱 | 结合向量库 |
| Schema 设计成本高 | 从小 schema 开始 |
| 对非结构化内容不友好 | 先提取再保存 |
| 容易过度建模 | 只建高价值字段 |

---

## 32.6 推荐组合

```text
稳定状态 → SQL / JSON
语义经验 → Vector Store
历史原文 → Event Log / Archive
知识沉淀 → Markdown / LLM Wiki
关系网络 → Graph Store
```

---

## 32.7 本章掌握标准

你能判断：

```text
哪些记忆必须精确管理，应该进入结构化数据库，而不是只做语义检索。
```

---

# 第 33 章｜Memory + LLM Wiki

## 33.1 本章一句话

Memory 负责“运行时记住”，LLM Wiki 负责“知识资产沉淀”；两者结合，能把 Agent 的经验转化为长期可维护知识库。

---

## 33.2 Memory 与 LLM Wiki 的区别

| 维度 | Memory | LLM Wiki |
|---|---|---|
| 目标 | 支持 Agent 当前和未来行为 | 沉淀人和 Agent 都能读的知识资产 |
| 粒度 | 记忆项、状态、偏好、经验 | 主题文档、方法论、案例、模板 |
| 使用场景 | Agent 执行时读取 | 学习、复盘、迁移、检索 |
| 形态 | JSON、DB、向量、状态 | Markdown、目录、schema、文档 |
| 更新方式 | 高频、小粒度 | 阶段性、结构化整理 |

---

## 33.3 Memory 如何进入 LLM Wiki

```text
对话 / 任务 / 工具结果
  ↓
Memory Extractor 提炼短期经验
  ↓
Project Memory 记录阶段状态
  ↓
Knowledge Manager 汇总主题内容
  ↓
生成 Markdown 文档
  ↓
进入 LLM Wiki
```

---

## 33.4 哪些 Memory 适合沉淀到 LLM Wiki

| Memory 类型 | 是否适合 | 示例 |
|---|---:|---|
| 用户个人偏好 | 部分适合 | 只适合沉淀为个人工作规范 |
| 项目阶段总结 | 适合 | Memory 第 24–34 章课程笔记 |
| 流程方法论 | 很适合 | Memory 写入/检索/注入流程 |
| 失败复盘 | 很适合 | Codex 执行漂移案例 |
| 临时状态 | 不适合 | 当前正在生成某个文件 |
| 敏感信息 | 不适合 | 私密数据、账号、身份细节 |

---

## 33.5 LLM Wiki 反过来如何服务 Memory

| LLM Wiki 内容 | 如何服务 Memory |
|---|---|
| 标准方法论 | 作为 Procedural Memory 来源 |
| 项目文档 | 作为 Project Memory 来源 |
| 模板 | 作为 Tool / Skill Memory 来源 |
| 复盘文档 | 作为 Failure Memory 来源 |
| 术语库 | 作为 Semantic Memory 来源 |

---

## 33.6 推荐目录结构

```text
llm-wiki/
  agent/
    memory/
      00-overview.md
      01-concepts/
      02-principles/
      03-engineering/
      04-rag-and-knowledge/
      05-evals/
      06-cases/
      templates/
        memory-schema-template.md
        memory-policy-template.md
```

---

## 33.7 常见错误

| 错误 | 后果 |
|---|---|
| 把所有 Memory 都写进 Wiki | Wiki 变成垃圾桶 |
| Wiki 只存长文，不结构化 | Agent 难以检索和复用 |
| Memory 和 Wiki 不同步 | 运行时状态和知识库冲突 |
| 不区分个人偏好和公共知识 | 知识库边界混乱 |

---

## 33.8 本章掌握标准

你能设计：

```text
哪些内容留在运行时 Memory
哪些内容沉淀成 LLM Wiki 文档
LLM Wiki 如何反过来成为 Agent 的知识来源
```

---

# 第 34 章｜Memory + Graph

## 34.1 本章一句话

Graph 适合表达实体、关系、因果、依赖和路径；当 Memory 不再只是“单条事实”，而是复杂关系网络时，就需要 Graph。

---

## 34.2 为什么 Memory 需要 Graph

普通 Memory Item 适合表达：

```text
用户喜欢表格化输出。
```

Graph Memory 更适合表达：

```text
用户 → 学习 → Agent Memory
Agent Memory → 包含 → Short-term Memory
Short-term Memory → 属于 → Agent State
Agent State → 影响 → Tool Use
Tool Use → 产生 → Failure Memory
Failure Memory → 改进 → Procedural Memory
```

---

## 34.3 Graph 适合解决什么问题

| 问题 | Graph 的价值 |
|---|---|
| 多实体关系 | 用户、项目、工具、任务、文件之间的关系 |
| 因果链路 | 为什么某次失败导致某条规则产生 |
| 依赖关系 | 某步骤依赖哪些前置条件 |
| 知识导航 | 从一个概念跳到相关概念 |
| 多跳推理 | A 影响 B，B 影响 C，因此 A 间接影响 C |

Microsoft GraphRAG 文档说明，GraphRAG 会从输入语料构建知识图谱，并结合社区摘要等结构在查询时增强提示；Microsoft Research 也把 GraphRAG 描述为结合文本抽取、网络分析、LLM 提示和总结的端到端系统。

---

## 34.4 Memory Graph 的基本结构

| 元素 | 示例 |
|---|---|
| Node 节点 | 用户、项目、任务、工具、记忆、文档 |
| Edge 边 | 属于、依赖、导致、更新、引用、冲突 |
| Property 属性 | 时间、可信度、来源、状态、权限 |
| Path 路径 | 某个失败经验如何影响后续流程 |

---

## 34.5 示例：Agent Memory 学习项目图

```text
Terry
  → 学习目标 → 构建高质量 Agent 工程
  → 当前课程 → Agent Memory

Agent Memory
  → 阶段 → 第 24–34 章
  → 需要沉淀 → LLM Wiki
  → 包含概念 → Agent Loop / RAG / Graph

第 24–34 章
  → 输出物 → Markdown 文件
  → 约束 → 中文 / MECE / 表格化
```

---

## 34.6 Graph Memory 与 Vector Memory 的区别

| 维度 | Vector Memory | Graph Memory |
|---|---|---|
| 主要能力 | 相似召回 | 关系推理 |
| 查询方式 | “和这个语义相似的内容” | “A 和 B 有什么关系” |
| 适合内容 | 文本片段、经验片段 | 实体、关系、依赖、因果 |
| 缺点 | 关系不显式 | 建模成本高 |
| 最佳组合 | 先召回相似内容 | 再沿图谱做关系扩展 |

---

## 34.7 Memory + Graph 的推荐用法

| 场景 | 是否值得用 Graph |
|---|---:|
| 简单用户偏好 | 不需要 |
| 项目状态管理 | 可选 |
| 多 Agent 协作 | 值得 |
| 知识图谱型 Wiki | 值得 |
| 复杂因果复盘 | 值得 |
| 广告关键词/ASIN/转化关系 | 值得 |
| 工具权限配置 | 不一定 |

---

## 34.8 常见错误

| 错误 | 后果 |
|---|---|
| 一开始就上 Graph | 建模成本过高 |
| 所有记忆都建节点 | 图谱变成垃圾图 |
| 没有关系类型规范 | 后续无法查询 |
| Graph 和文档脱节 | 只剩图，没有解释文本 |
| Graph 和运行时 Memory 脱节 | Agent 用不上图谱 |

---

## 34.9 本章掌握标准

你能判断：

```text
当前 Memory 问题是简单事实存储、语义召回，还是复杂关系推理。
如果是复杂关系推理，再考虑 Graph。
```

---

# 第 24–34 章总复盘

## 1. 章节总表

| 章节 | 主题 | 核心能力 |
|---:|---|---|
| 24 | Agent Loop 中的 Memory 位置 | 知道 Memory 如何贯穿感知、计划、执行、反思 |
| 25 | Tool Use 与 Memory | 记录工具能力、结果和失败经验 |
| 26 | Planning 与 Memory | 用历史偏好、状态、流程、失败经验辅助计划 |
| 27 | Reflection 与 Memory | 把复盘结论转成可复用记忆 |
| 28 | Multi-Agent Memory | 设计共享、私有、交接、权限记忆 |
| 29 | Skill / Workflow / Agent 与 Memory | 区分三类系统使用 Memory 的粒度 |
| 30 | Memory 与 RAG 边界 | 区分外部知识检索和历史上下文延续 |
| 31 | Memory + 向量检索 | 用向量召回语义相似历史经验 |
| 32 | Memory + 结构化数据库 | 管理精确状态、偏好、权限、项目数据 |
| 33 | Memory + LLM Wiki | 把运行时经验沉淀成知识资产 |
| 34 | Memory + Graph | 用图表达实体、关系、因果和依赖 |

---

## 2. 本阶段核心主线

```text
Memory 不只是存储模块
  ↓
它进入 Agent Loop
  ↓
影响计划、工具调用、反思、多 Agent 协作
  ↓
再与 RAG、数据库、LLM Wiki、Graph 组合
  ↓
形成可持续演化的 Agent 知识与经验系统
```

---

## 3. Memory 与其他系统的组合边界

| 组合对象 | Memory 负责 | 对方负责 |
|---|---|---|
| Agent Loop | 状态、偏好、历史经验 | 感知、计划、执行、反思 |
| Tool Use | 工具经验、结果、失败 | 外部能力调用 |
| Planning | 历史约束、流程经验 | 任务拆解和路径选择 |
| Reflection | 复盘沉淀 | 判断成败和改进点 |
| Multi-Agent | 状态共享和交接 | 分工协作 |
| RAG | 用户/项目/经验上下文 | 外部知识召回 |
| Vector Store | Memory metadata 和使用策略 | 语义相似检索 |
| SQL / JSON | 结构化 Memory | 精确查询和更新 |
| LLM Wiki | 运行时经验来源 | 长期知识资产 |
| Graph | 记忆节点和关系 | 多跳关系推理 |

---

## 4. 阶段性能力标准

完成第 24–34 章后，你应该能做到：

| 能力 | 标准 |
|---|---|
| Agent Loop 集成 | 能说明 Memory 在感知、计划、执行、反思中的位置 |
| Tool Memory 设计 | 能区分工具能力、工具结果、工具失败经验 |
| Planning 设计 | 能让计划读取用户偏好、项目状态、流程经验和失败记忆 |
| Reflection 设计 | 能把复盘转化为 user/project/procedural/failure memory |
| 多 Agent 设计 | 能区分 shared/private/handoff memory |
| RAG 边界判断 | 能判断什么时候用 RAG，什么时候用 Memory |
| 向量检索设计 | 能把语义型记忆和结构化 metadata 结合 |
| 数据库设计 | 能把稳定状态和偏好放进结构化存储 |
| LLM Wiki 沉淀 | 能把运行时经验转成长期知识资产 |
| Graph 判断 | 能判断何时需要关系型 Memory |

---

## 5. 最重要的一句话

第 24–34 章的核心，是把 Memory 从“可读写的模块”升级成“Agent 系统的连续性中枢”：它连接 Agent Loop、工具、计划、反思、多 Agent、RAG、数据库、LLM Wiki 和 Graph，让 Agent 不只是会回答，而是能持续积累、复用和迁移经验。

---

## 参考来源

- LangGraph / LangChain Memory 概念与短期、长期记忆文档
- OpenAI Agents SDK Sessions 与 Agents 概念文档
- LlamaIndex Memory 与 Memory Blocks 文档
- Microsoft GraphRAG 官方文档与 Microsoft Research GraphRAG 项目说明
