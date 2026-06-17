# Skill 工程化与产品化｜阶段四：Workflow 工程化

## 阶段定位

Workflow 工程化关注的是：如何把一个“能说清楚的工作流程”，改造成一个“Agent 可以稳定执行的 Skill 流程”。

前三个阶段解决的是：

```text
阶段一：判断什么任务值得 Skill 化
阶段二：理解 Skill 的基础结构
阶段三：把 Prompt 重构为 Skill
```

阶段四进一步解决：

```text
如何把 Skill 内部的执行流程设计得稳定、可控、可验收、可迭代。
```

Skill 不只是 instructions 的集合。它通常还可以包含 examples、code、references、assets 等资源。OpenAI ChatGPT Skills 将 Skill 定义为可复用、可共享的工作流；OpenAI Codex Skills 将 Skill 描述为包含 `SKILL.md` 的目录，并可附带 scripts、references、assets。Agent Skills 标准也强调 `SKILL.md` 至少包含 `name` 与 `description`，并可通过渐进式披露按需加载更多资料。

阶段四的核心观点：

> Skill 的 Workflow 工程化，本质是把“人类工作流程”改写成“Agent 可执行流程”。

---

# 第 18 章：Skill 与 SOP

## 18.1 SOP 是什么

SOP，即 Standard Operating Procedure，标准作业流程。

它的作用是：

```text
让不同的人，在相似场景下，按相同方法完成相同质量的工作。
```

例如：

- 客服回复 SOP
- Amazon Review 分析 SOP
- A+ 图片需求整理 SOP
- 说明书审查 SOP
- 合同低级错误检查 SOP
- LLM Wiki 知识沉淀 SOP

SOP 面向人类。Skill 面向 Agent。

## 18.2 Skill 与 SOP 的关系

Skill 可以理解为：

> 面向 AI Agent 的 SOP。

二者关系如下：

| 维度 | 人类 SOP | Skill |
|---|---|---|
| 服务对象 | 人类员工 | AI Agent |
| 载体 | 文档、流程图、表格 | `SKILL.md` + references + scripts + assets |
| 目标 | 统一人的操作 | 统一 Agent 的执行 |
| 输入 | 人读取业务材料 | Agent 读取用户请求和文件 |
| 执行 | 人判断、操作、记录 | Agent 判断、调用工具、生成结果 |
| 验收 | 人工检查 | 输出契约、测试样例、质量标准 |
| 迭代 | 流程优化 | Skill 版本更新 |

## 18.3 SOP 不能直接复制成 Skill

很多 SOP 是写给人看的，不能直接复制到 `SKILL.md`。

原因：

| SOP 常见写法 | 对 Agent 的问题 |
|---|---|
| “根据经验判断” | 没有判断规则 |
| “注意语气专业” | 不知道具体标准 |
| “必要时补充说明” | 不知道何时必要 |
| “输出一份报告” | 不知道报告结构 |
| “发现异常及时处理” | 不知道异常类型和处理方式 |

Skill 需要把这些模糊表达转成可执行规则。

## 18.4 SOP 到 Skill 的转换方法

可以按六步转换：

```text
1. 提取任务目标
2. 拆出输入材料
3. 拆出执行步骤
4. 拆出判断规则
5. 拆出输出标准
6. 拆出异常处理
```

示例：人类 SOP 表达

```text
分析用户评论，找出客户最关心的问题，并给出产品优化建议。
```

Skill 化表达：

```markdown
# Process

1. Read all provided reviews.
2. Classify each review into themes: audio quality, setup, durability, battery, compatibility, service, price, and other.
3. Identify repeated complaints and praise signals.
4. Separate directly observed evidence from inferred implications.
5. Convert repeated issues into product improvement opportunities.
6. Return findings in the required output table.
```

差异在于：

```text
SOP：描述工作意图
Skill：描述可执行动作
```

## 18.5 SOP Skill 化示例：说明书审查

### 人类 SOP

```text
检查说明书是否清晰、准确、适合目标用户，有没有低级错误和用户看不懂的地方。
```

### Skill 化结构

```markdown
# Purpose

Review user manuals for clarity, accuracy, target-user fit, missing steps, confusing wording, layout issues, and low-level errors.

# Inputs

Required:
- Manual content or uploaded manual file

Optional:
- Product type
- Target user
- Sales platform
- Known product features

# Process

1. Identify the product type and target user.
2. Review the manual from the first-time user perspective.
3. Check whether key setup and operation steps are complete.
4. Identify unclear wording, missing warnings, inconsistent terminology, and low-level formatting errors.
5. Mark each issue with reason, risk, and improvement direction.
6. Separate factual issues from subjective usability suggestions.

# Output Format

| Issue | Location | Why It Matters | Risk | Improvement Direction |
```

## 18.6 SOP Skill 化的关键

SOP Skill 化不是“把流程写进 Markdown”，而是完成三类转换：

| 转换 | 说明 |
|---|---|
| 人类经验 → 明确规则 | 把“根据经验”改成判断条件 |
| 模糊目标 → 可验收产物 | 把“做好”改成输出结构 |
| 临场处理 → 异常分支 | 把“必要时处理”改成 if/then 规则 |

## 18.7 本章小结

SOP 是 Skill 的重要来源，但 SOP 不能直接等于 Skill。

核心结论：

> SOP 是给人看的工作说明，Skill 是给 Agent 执行的工作程序。

---

# 第 19 章：任务边界设计

## 19.1 为什么任务边界重要

Skill 的边界决定：

- 什么时候应该使用
- 什么时候不应该使用
- 能做到什么程度
- 不能替代什么
- 遇到高风险任务如何处理

没有边界的 Skill，会产生四类问题：

| 问题 | 表现 |
|---|---|
| 误触发 | 不该用 Skill 时也被调用 |
| 过度执行 | 用户只想轻量总结，Skill 却输出完整报告 |
| 越权判断 | 把建议说成结论 |
| 虚构补全 | 缺少信息时自行编造 |

## 19.2 任务边界的五个组成

一个 Skill 的边界至少包含：

| 边界类型 | 要回答的问题 |
|---|---|
| 任务边界 | 这个 Skill 做什么，不做什么 |
| 输入边界 | 需要什么输入，缺什么不能继续 |
| 输出边界 | 输出到什么程度，不能承诺什么 |
| 权限边界 | 能否调用工具、读写文件、执行脚本 |
| 风险边界 | 遇到法律、医疗、财务、安全问题如何处理 |

## 19.3 任务边界示例：Amazon A+ 设计需求 Skill

### 做什么

```markdown
This skill converts product selling points into structured Amazon A+ image briefs, including visual hierarchy, composition direction, copy suggestions, image-generation prompts, and design acceptance criteria.
```

### 不做什么

```markdown
Do not:
- Invent unsupported product features.
- Guarantee Amazon compliance approval.
- Replace final legal, compliance, or brand review.
- Add certifications, awards, or performance claims not provided by the user.
```

## 19.4 任务边界示例：LLM Wiki Writer Skill

### 做什么

```markdown
Convert source content into reusable neutral Markdown knowledge entries.
```

### 不做什么

```markdown
Do not:
- Produce casual chat summaries.
- Preserve dialogue framing.
- Add unsupported facts.
- Turn the content into marketing copy.
- Include temporary task instructions as knowledge.
```

## 19.5 边界写法模板

```markdown
# Scope

This skill is for:
- [Applicable task 1]
- [Applicable task 2]
- [Applicable task 3]

This skill is not for:
- [Excluded task 1]
- [Excluded task 2]
- [Excluded task 3]

When the request is outside scope:
- Explain the limitation briefly.
- Offer the closest safe or relevant alternative.
- Do not force the workflow onto the task.
```

## 19.6 边界粒度

边界不能太宽，也不能太窄。

### 太宽

```text
Use for all Amazon tasks.
```

问题：

- Review 分析、Listing 文案、广告分析、库存测算都会混在一起
- 触发冲突严重

### 太窄

```text
Use only when analyzing one-star reviews for one exact product model.
```

问题：

- 复用价值太低
- 容易漏触发

### 合适

```text
Use when analyzing Amazon product reviews to identify pain points, praise drivers, objections, feature requests, and product opportunities.
```

## 19.7 任务边界与 description 的关系

`description` 是外层边界，用于触发判断。

`Scope / Constraints` 是内层边界，用于执行约束。

| 位置 | 作用 |
|---|---|
| `description` | 帮助 Agent 判断是否使用 Skill |
| `Scope` | 说明 Skill 的适用范围 |
| `Constraints` | 限制执行中的风险行为 |
| `Failure Handling` | 定义超出边界后的处理方式 |

## 19.8 本章小结

任务边界设计的核心，不是限制 Skill 能力，而是提高 Skill 的可靠性。

核心公式：

```text
做什么 + 不做什么 + 输入限制 + 输出限制 + 风险处理
```

---

# 第 20 章：输入输出契约

## 20.1 什么是输入输出契约

输入输出契约是 Skill 的“接口说明”。

它定义：

```text
Agent 可以接收什么输入
应该如何处理缺失输入
最终必须输出什么结构
输出必须满足什么标准
```

如果 Skill 是一个能力模块，那么输入输出契约就是它的 API 契约。

## 20.2 为什么需要输入输出契约

没有契约时：

```text
用户输入不完整 → Agent 猜
输出格式不固定 → 用户难用
质量标准不明确 → 无法测试
多个 Skill 协作 → 数据接不上
```

有契约后：

```text
输入清楚
默认可控
输出稳定
可测试
可组合
```

## 20.3 输入契约结构

```markdown
# 输入契约

必填：

- [必填输入]

可选：

- [可选输入]

默认值：

- [默认假设]

缺失信息处理：

- [如果缺少必填信息，应如何处理]

无效输入：

- [不应被接受的输入]
```

## 20.4 输出契约结构

```markdown
# 输出契约

格式：

- [Markdown / 表格 / JSON / 报告 / 检查清单]

必需章节：

- [章节 1]
- [章节 2]
- [章节 3]

质量要求：

- [要求 1]
- [要求 2]

禁止输出：

- [禁止输出 1]
- [禁止输出 2]
```

## 20.5 示例：内容清洁 Skill 的输入输出契约

### 输入契约

```markdown
# 输入契约

必填：

- 需要清理的源文本、提示词、SKILL.md 内容或工作流指令。

可选：

- 目标使用场景
- 风格规则
- 需要保留的章节
- 严格程度

默认值：

- 保留具有实际操作价值的指令。
- 删除填充内容、奉承语、重复内容、模糊的质量形容词和不必要的角色扮演。
- 保持原始任务意图不变。

缺失信息处理：

- 如果缺少目标使用场景，则从文本内容中推断。
- 如果内容过短，只清理明显噪音。

无效输入：

- 不得为了绕过安全、合规或审核流程而改写内容。
```

### 输出契约

```markdown
# 输出契约

格式：

- 先返回清理后的版本。
- 如有必要，再返回变更摘要。

必需章节：

1. 清理后内容
2. 已删除的噪音
3. 剩余风险或歧义

质量要求：

- 保留有用的约束。
- 删除冗余指令。
- 保持内容易维护。
- 不削弱安全性或事实准确性规则。
```

## 20.6 契约与可组合性

Skill 想要与其他 Skill 协作，必须输出稳定。

例如：

```text
Review 抓取 Skill → Review 分析 Skill → A+ 文案 Skill → 图片需求 Skill
```

如果 Review 分析 Skill 的输出每次结构不同，后续 A+ 文案 Skill 就很难稳定使用。

因此，输出契约也是 Skill 可组合的基础。

## 20.7 契约常见错误

| 错误 | 问题 | 修正 |
|---|---|---|
| 只写“输出报告” | 报告结构不稳定 | 写清章节 |
| 只写“用户提供材料” | 不知道必填项 | 分 required / optional |
| 没有缺失处理 | 信息不足时乱编 | 写 Missing Information Handling |
| 没有禁止输出 | 容易越界 | 写 Forbidden Outputs |
| 质量标准抽象 | 无法测试 | 写可检查标准 |

## 20.8 本章小结

输入输出契约决定 Skill 是否可稳定调用、可组合、可测试。

核心结论：

> 没有输入输出契约的 Skill，本质上只是一个包装过的 Prompt。

---

# 第 21 章：分支逻辑设计

## 21.1 什么是分支逻辑

分支逻辑是 Skill 在不同情况下面对不同路径的处理规则。

常见格式：

```text
如果 A，则执行 X
如果 B，则执行 Y
如果 C，不继续执行，并说明原因
```

Skill 不能只写理想路径。真实任务经常存在：

- 输入不足
- 目标冲突
- 文件格式不匹配
- 用户要求不合理
- 数据缺失
- 任务超出边界
- 多个输出目标竞争

## 21.2 为什么分支逻辑重要

没有分支逻辑时，Agent 容易：

- 信息不足时乱补
- 目标冲突时自作主张
- 遇到风险时继续执行
- 输出格式不一致
- 把建议当结论

分支逻辑的作用是：

> 提前把不确定情况变成可执行路径。

## 21.3 常见分支类型

| 分支类型 | 示例 |
|---|---|
| 输入完整度分支 | 信息完整则执行；信息不足则输出框架或请求补充 |
| 任务范围分支 | 在范围内则执行；超出范围则说明限制 |
| 风险等级分支 | 低风险直接处理；高风险标注并限制输出 |
| 输出格式分支 | 用户指定格式则遵循；未指定则用默认格式 |
| 数据可信度分支 | 有证据则总结；无证据则标注假设 |
| 多目标分支 | 目标冲突时按优先级处理 |

## 21.4 分支逻辑模板

```markdown
# Decision Logic

If the input is complete:
- Execute the full workflow.

If required information is missing:
- Ask for the missing information, or
- Produce a limited framework if the user needs a best-effort output.

If the request is outside scope:
- State that the skill does not apply.
- Do not force the workflow.
- Offer a safer or closer alternative.

If the request contains unsupported claims:
- Mark them as unsupported.
- Do not include them as confirmed facts.

If the user specifies a format:
- Follow the user-specified format unless it conflicts with safety or factuality.
```

## 21.5 示例：Review 分析分支逻辑

```markdown
# Decision Logic

If review text is provided:
- Analyze only the provided review content.

If only an ASIN is provided:
- Use available tools only if permitted and available.
- If review data cannot be retrieved, output a review-analysis framework instead of inventing reviews.

If review volume is small:
- Mark findings as directional, not conclusive.

If review content conflicts:
- Separate positive and negative signals instead of forcing one conclusion.

If the user asks for claims not supported by reviews:
- Mark them as unsupported and suggest validation.
```

## 21.6 示例：设计提示词 Skill 分支逻辑

```markdown
# Decision Logic

If product image references are provided:
- Preserve visible product structure and avoid inventing major design changes.

If no product image is provided:
- Create a conceptual visual brief and mark product appearance as unspecified.

If the user requests platform compliance:
- Provide design-risk considerations.
- Do not guarantee approval.

If the user requests unsupported product claims:
- Exclude or mark them for verification.
```

## 21.7 分支逻辑的优先级

分支可能互相冲突，需要定义优先级。

推荐优先级：

```text
安全与事实
→ 用户明确要求
→ Skill 输出契约
→ 默认策略
→ 风格偏好
```

示例：

```text
用户要求输出强转化文案，但产品功能没有证据。
```

处理：

```text
不能为了转化虚构功能。
应优先保留事实边界，再优化表达。
```

## 21.8 分支逻辑误区

| 误区 | 问题 | 修正 |
|---|---|---|
| 只写正常流程 | 异常时乱编 | 加入 if/then |
| 分支太多太细 | 主流程被淹没 | 只保留高频分支 |
| 没有优先级 | 冲突时不稳定 | 明确优先顺序 |
| 分支没有输出结果 | Agent 不知如何结束 | 每个分支写处理产物 |
| 把风险分支写得模糊 | 高风险任务易越界 | 写清限制和替代方案 |

## 21.9 本章小结

分支逻辑的本质，是把真实世界的不确定性转成 Skill 的可控执行路径。

核心公式：

```text
正常路径 + 缺失路径 + 冲突路径 + 风险路径 + 超界路径
```

---

# 第 22 章：默认策略设计

## 22.1 什么是默认策略

默认策略是当用户没有说明某些细节时，Skill 自动采用的处理规则。

例如：

```text
未指定输出格式 → 默认 Markdown
未指定语气 → 默认中立、简洁、可复用
未指定分析维度 → 默认按痛点、卖点、需求、机会分析
```

默认策略的作用是减少不必要追问，提高执行效率。

## 22.2 默认策略适合默认什么

适合默认的内容：

| 类型 | 示例 |
|---|---|
| 输出格式 | 默认 Markdown |
| 结构层级 | 默认二级标题组织 |
| 语气 | 默认中立、清晰、非口语化 |
| 分析维度 | 默认使用通用分析框架 |
| 文件命名 | 默认使用主题名 + 阶段名 |
| 缺失标题 | 默认从内容推断简洁标题 |

## 22.3 不适合默认什么

不适合默认的内容：

| 类型 | 原因 |
|---|---|
| 事实数据 | 容易虚构 |
| 法律结论 | 风险高 |
| 医疗建议 | 风险高 |
| 财务承诺 | 风险高 |
| 产品参数 | 必须有依据 |
| 平台审核结果 | 无法保证 |
| 用户授权 | 不能替用户假设 |

原则：

```text
可以默认格式，不可以默认事实。
可以默认结构，不可以默认证据。
可以默认语气，不可以默认承诺。
```

## 22.4 默认策略模板

```markdown
# Defaults

Unless the user specifies otherwise:
- Use Markdown.
- Use a neutral, direct, reusable style.
- Prefer structured sections over prose-only output.
- Separate facts, assumptions, and recommendations.
- Use conservative language for unsupported claims.
- Do not invent missing data.
```

## 22.5 示例：LLM Wiki 默认策略

```markdown
# Defaults

Unless otherwise specified:
- Use neutral encyclopedia-style Markdown.
- Infer the title from the central concept.
- Remove conversational filler.
- Preserve durable knowledge.
- Do not refer to the source as a conversation.
- Include boundaries, adjacent concepts, common pitfalls, and practical checklist when enough source content exists.
```

## 22.6 示例：Amazon Review 分析默认策略

```markdown
# Defaults

Unless otherwise specified:
- Analyze reviews by pain points, praise drivers, objections, feature requests, purchase motivations, and product opportunities.
- Separate observed evidence from inferred implications.
- Treat small review samples as directional signals.
- Do not invent review content.
- Do not present review patterns as market-wide conclusions without sufficient evidence.
```

## 22.7 默认策略与用户指令冲突

默认策略的优先级低于用户明确指令，但不能低于安全和事实要求。

优先级：

```text
安全 / 事实 / 法规边界
→ 用户明确要求
→ Skill 默认策略
→ 风格偏好
```

示例：

```text
默认策略：输出 Markdown
用户要求：输出表格
```

处理：

```text
输出表格。
```

示例：

```text
默认策略：不虚构产品参数
用户要求：帮我编一个 SNR > 90dB
```

处理：

```text
不编造。标注该参数需要验证。
```

## 22.8 默认策略误区

| 误区 | 问题 | 修正 |
|---|---|---|
| 默认事实 | 容易幻觉 | 只默认格式与流程 |
| 默认太多 | 降低灵活性 | 保留必要默认 |
| 默认不透明 | 用户不知道假设 | 重要推断要说明 |
| 默认覆盖用户要求 | 不尊重任务目标 | 用户明确要求优先 |
| 默认没有边界 | 容易越权 | 加入“不默认事实”原则 |

## 22.9 本章小结

默认策略的价值是减少低价值追问，而不是替用户做高风险假设。

核心公式：

```text
默认低风险结构，不默认高风险事实。
```

---

# 第 23 章：质量标准设计

## 23.1 为什么 Skill 需要质量标准

没有质量标准，Skill 的输出只能凭感觉判断。

高质量 Skill 必须回答：

```text
什么样的输出算合格？
什么样的输出算失败？
如何检查？
如何改进？
```

质量标准让 Skill 从“能用”变成“可评估”。

## 23.2 质量标准的六个维度

| 维度 | 检查问题 |
|---|---|
| 完整性 | 是否覆盖必要部分？ |
| 准确性 | 是否保留事实边界？ |
| 一致性 | 是否符合固定格式和风格？ |
| 可执行性 | 是否能直接用于下一步工作？ |
| 可复用性 | 是否脱离单次对话仍能使用？ |
| 可维护性 | 是否结构清晰、方便迭代？ |

## 23.3 通用质量标准模板

```markdown
# 质量标准  
  
只有在满足以下条件时，输出才可接受：  
  
- 遵循规定的输出格式。  
- 直接回应用户的任务。  
- 区分事实、假设和建议。  
- 避免无依据的断言。  
- 明确处理缺失信息。  
- 可复用于目标工作流。  
- 避免填充内容、重复内容和模糊赞美。
```

## 23.4 示例：LLM Wiki Skill 质量标准

```markdown
# 质量标准  
  
输出必须：  
  
- 使用中立的百科式语气。  
- 避免提及原始对话。  
- 保留可复用概念，而不是临时任务指令。  
- 在源内容支持的情况下，包含定义、边界、相邻概念、使用场景、常见误区和检查清单。  
- 避免无依据的事实。  
- 可直接存入知识库。
```

## 23.5 示例：Amazon A+ 图片需求 Skill 质量标准

```markdown
# Quality Criteria

The output must:
- Translate each selling point into a clear visual message.
- Define image hierarchy, layout, scene, product placement, and text area.
- Distinguish provided product facts from creative suggestions.
- Avoid unsupported claims, unverifiable certifications, and exaggerated guarantees.
- Include design acceptance criteria.
- Be clear enough for a designer or image-generation model to execute.
```

## 23.6 失败标准

只写“合格标准”还不够，也要定义失败标准。

```markdown
# 失败标准  
  
如果出现以下情况，则输出不可接受：  
  
- 编造事实、数据、主张或产品功能。  
- 忽略规定的输出格式。  
- 生成可套用于任何任务的泛泛回答。  
- 遗漏工作流要求的关键章节。  
- 隐藏不确定性。  
- 包含对话填充内容或重复指令。
```

## 23.7 质量标准与测试的关系

质量标准用于人工判断，测试样例用于具体验证。

关系如下：

```text
质量标准 → 定义什么是好
测试样例 → 验证是否做到了
失败案例 → 暴露哪里不稳定
迭代规则 → 修复 Skill
```

例如：

| 质量标准 | 测试案例 |
|---|---|
| 不出现对话口吻 | 输入一段聊天记录，看输出是否去掉“我们聊到” |
| 不虚构功能 | 输入缺少参数的产品信息，看输出是否编造 |
| 结构固定 | 输入不同主题，看输出是否保持同一结构 |
| 边界清楚 | 输入超出范围任务，看 Skill 是否拒绝或降级 |

## 23.8 可执行质量检查清单

每次写完 Skill 后，可检查：

```text
1. 是否能判断何时使用？
2. 是否能判断何时不用？
3. 是否有必填输入？
4. 是否有缺失输入处理？
5. 是否有固定输出格式？
6. 是否有禁止输出？
7. 是否有异常路径？
8. 是否有默认策略？
9. 是否有质量标准？
10. 是否能设计至少 3 个测试样例？
```

## 23.9 本章小结

质量标准决定 Skill 是否能从“个人经验”变成“可验证资产”。

核心结论：

> 没有质量标准的 Skill，无法工程化；没有失败标准的 Skill，无法持续改进。

---

# 阶段四总结

阶段四的核心结论：

1. **Skill 是面向 Agent 的 Workflow。**  
   它不是简单说明，而是可执行流程。

2. **SOP 是 Skill 的重要来源，但不能直接复制。**  
   SOP 面向人，Skill 面向 Agent，需要把模糊经验转成明确规则。

3. **任务边界决定 Skill 的可靠性。**  
   必须写清楚做什么、不做什么、输入限制、输出限制和风险处理。

4. **输入输出契约决定 Skill 是否可组合。**  
   没有契约，后续 Skill 或工具无法稳定接上。

5. **分支逻辑决定 Skill 是否能处理真实世界。**  
   真实任务一定有缺失、冲突、风险和超界情况。

6. **默认策略决定 Skill 的效率。**  
   可以默认格式、结构、语气，但不能默认事实、数据和承诺。

7. **质量标准决定 Skill 是否可评估。**  
   没有质量标准，就无法测试、复盘和迭代。

阶段四最重要的一句话：

> Workflow 工程化的目标，是把模糊的人类工作经验，改造成 Agent 可以按条件、按步骤、按边界、按标准稳定执行的流程。

---

# 阶段四掌握检查

完成阶段四后，应能回答：

1. SOP 和 Skill 的区别是什么？
2. 为什么不能直接把 SOP 复制成 Skill？
3. 一个 Skill 的任务边界应该包含哪些部分？
4. 输入输出契约为什么重要？
5. 分支逻辑解决什么问题？
6. 默认策略适合默认什么，不适合默认什么？
7. 质量标准和测试样例是什么关系？
8. 如何判断一个 Skill 的 Workflow 是否工程化？

---

# 可沉淀的最小方法论

```text
Workflow 工程化七步法：

1. 从 SOP 中提取任务目标
2. 明确 Skill 做什么与不做什么
3. 定义输入契约：必填、可选、默认、缺失、禁止
4. 定义输出契约：格式、章节、粒度、禁止项、验收标准
5. 设计分支逻辑：正常、缺失、冲突、风险、超界
6. 设计默认策略：默认结构，不默认事实
7. 设计质量标准：合格标准 + 失败标准 + 测试依据
```

---

# 参考来源

- OpenAI Help Center, “Skills in ChatGPT”
- OpenAI Developers, “Agent Skills – Codex”
- Agent Skills Open Standard, “Agent Skills Overview”
- Anthropic Engineering, “Equipping agents for the real world with Agent Skills”
- OpenAI Skills GitHub, `skill-creator/SKILL.md`
