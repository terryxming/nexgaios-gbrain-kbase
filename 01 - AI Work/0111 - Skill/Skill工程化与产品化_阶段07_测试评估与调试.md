# Skill 工程化与产品化｜阶段七：测试、评估与调试

## 阶段定位

阶段七关注 Skill 的质量验证体系，核心问题是：

> 如何判断一个 Skill 不是“看起来能用”，而是真的稳定、可复用、可维护、可迭代。

前六个阶段已经完成了 Skill 的认知、结构、Workflow、上下文管理和脚本增强。阶段七进一步进入工程闭环：

```text
设计 Skill
→ 构造测试集
→ 运行真实任务
→ 观察失败模式
→ 定位问题来源
→ 修改 Skill
→ 回归测试
```

OpenAI Codex Skills 文档强调 Skill 是包含 `SKILL.md` 的目录，可附带 scripts、references 和 assets，并通过 progressive disclosure 管理上下文。OpenAI 的 Evals 体系则提供了对模型输出进行结构化评估的思路：通过数据集、评估器和实验记录来判断系统是否达到预期。Anthropic 关于 Agent Skills 和工具工程的文章也强调，应通过真实任务和评估来发现 Agent 在工具、说明、资源使用中的问题。

阶段七的核心观点：

> 没有测试的 Skill，只是经验文本；有测试、评估、调试和回归机制的 Skill，才是工程化能力资产。

---

# 第 34 章：为什么 Skill 必须测试

## 34.1 一次成功不代表稳定

很多 Skill 在第一次演示时看起来很好，但真实使用中会暴露问题：

| 表现 | 问题 |
|---|---|
| 第一次输出正确，第二次格式变了 | 输出契约不稳定 |
| 简单输入有效，复杂输入失效 | 测试覆盖不足 |
| 明确请求时能触发，模糊请求时不触发 | description 触发能力弱 |
| 不该使用时也被调用 | 边界不清 |
| 信息不足时胡乱补全 | 缺失输入处理不足 |
| 输出看起来完整，但事实不可靠 | 证据与推断未区分 |

Skill 的质量不能靠“感觉还不错”判断，而要靠测试案例验证。

## 34.2 测试解决什么问题

Skill 测试主要解决六类问题：

| 问题 | 测试目标 |
|---|---|
| 是否该触发 | 验证 description 是否覆盖正确场景 |
| 是否误触发 | 验证 Skill 是否会被错误调用 |
| 是否按流程执行 | 验证 Process 是否清晰 |
| 是否遵守边界 | 验证 Constraints 是否有效 |
| 是否输出稳定 | 验证 Output Format 是否稳定 |
| 是否能处理异常 | 验证 Failure Handling 是否有效 |

## 34.3 Skill 测试与普通软件测试的区别

| 维度 | 普通软件测试 | Skill 测试 |
|---|---|---|
| 对象 | 程序逻辑 | Agent 行为 |
| 输入 | 确定参数 | 自然语言、文件、上下文 |
| 输出 | 明确结果 | 结构化文本、判断、行动 |
| 判断标准 | 精确匹配较多 | 规则判断 + 人工评审 + 自动评估 |
| 失败类型 | 报错、异常、结果错误 | 误触发、漏触发、幻觉、漂移、越界 |
| 修复方式 | 改代码 | 改 description、流程、边界、示例、脚本 |

Skill 测试不只是看输出对不对，还要看 Agent 是否用对了方法。

## 34.4 Skill 测试的三个层级

| 层级 | 测试对象 | 示例 |
|---|---|---|
| 触发测试 | name / description | 用户说“沉淀成知识库”是否触发 LLM Wiki Skill |
| 执行测试 | SKILL.md / Workflow | 是否按输入、流程、输出结构执行 |
| 资源测试 | references / assets / scripts | 是否在需要时读取规则、使用模板、运行校验脚本 |

## 34.5 不测试的代价

如果不测试 Skill，会带来以下问题：

```text
Skill 越写越多，但不知道哪个可靠
Skill 互相冲突，但不知道冲突点
用户反馈不好，但不知道哪里坏
修改 Skill 后，旧能力被破坏
团队复用时，每个人得到不同结果
```

工程化的目标不是让 Skill 永远不出错，而是让错误可发现、可定位、可修复。

## 34.6 本章小结

测试的目标不是证明 Skill 完美，而是系统性发现它在哪些场景下不稳定。

核心结论：

> Skill 没有测试，就没有质量边界；没有质量边界，就无法工程化复用。

---

# 第 35 章：测试集设计

## 35.1 什么是 Skill 测试集

Skill 测试集是一组代表性任务输入及其预期行为，用于判断 Skill 是否稳定满足设计目标。

一个测试样例通常包括：

```markdown
## Case ID

### User Input
[用户请求]

### Expected Skill Behavior
[应该触发 / 不应该触发 / 应该降级 / 应该拒绝 / 应该输出什么结构]

### Evaluation Criteria
[如何判断合格]
```

## 35.2 测试集不是示例库

示例库用于教 Agent 如何做。测试集用于检验 Agent 是否做到了。

| 类型 | 作用 |
|---|---|
| Examples | 行为示范 |
| Tests | 质量验证 |

二者可以相关，但不能混为一谈。

示例通常放在：

```text
references/examples.md
```

测试集通常放在：

```text
tests/cases.md
tests/expected.md
tests/regression.md
```

## 35.3 测试案例类型

高质量测试集至少包含五类案例：

| 类型 | 目的 |
|---|---|
| 正常案例 | 验证主流程是否可用 |
| 边界案例 | 验证模糊输入是否正确处理 |
| 反向案例 | 验证不该触发时不触发 |
| 异常案例 | 验证信息不足、冲突、错误格式时如何处理 |
| 回归案例 | 验证历史 bug 不再出现 |

## 35.4 正常案例

正常案例用于验证 Skill 的主路径。

示例：LLM Wiki Writer Skill

```markdown
## Case 001: Conversation to LLM Wiki Entry

### User Input
把这段关于 MCP 与 API 区别的对话沉淀成 .md 文件，放到 LLM Wiki。

### Expected Behavior
- 触发 LLM Wiki Writer Skill
- 输出中立百科体 Markdown
- 包含定义、区别、关系、边界、应用场景、误区
- 不保留“我们聊到”“你的问题”等对话口吻

### Pass Criteria
- 输出结构完整
- 可脱离原对话复用
- 不出现对话框架表达
```

## 35.5 边界案例

边界案例用于验证模糊输入。

```markdown
## Case 002: Ambiguous Knowledge Organization Request

### User Input
整理一下这段内容，后面可能放知识库。

### Expected Behavior
- 可以轻量触发 LLM Wiki Writer Skill
- 不过度扩写
- 使用较简洁的知识条目结构
- 如果内容不足，应标注信息不足

### Pass Criteria
- 输出结构化
- 没有编造来源内容
- 没有过度展开
```

## 35.6 反向案例

反向案例用于防止误触发。

```markdown
## Case 003: Casual Summary

### User Input
简单总结一下刚才聊天，几句话就行。

### Expected Behavior
- 不应使用完整 LLM Wiki Writer Skill
- 只做简短总结
- 不输出完整知识条目结构

### Pass Criteria
- 没有强行输出 Definition / Boundaries / Pitfalls 等结构
- 没有把轻量任务复杂化
```

## 35.7 异常案例

异常案例用于验证 Failure Handling。

```markdown
## Case 004: Missing Source Content

### User Input
把 Agent 沉淀成知识库。

### Expected Behavior
- 识别缺少来源内容
- 可以询问补充材料，或输出框架型条目
- 不声称基于已有对话
- 不编造“之前讨论过”的内容

### Pass Criteria
- 明确信息不足
- 不虚构来源
- 输出受限或请求补充
```

## 35.8 回归案例

回归案例来自历史失败。

例如，某个 Skill 曾经出现问题：

```text
用户要求“沉淀成知识库”，输出中出现“你的问题非常关键”。
```

则加入回归测试：

```markdown
## Regression 001: Conversational Phrase Leakage

### User Input
把下面内容沉淀成知识库 Markdown。

### Expected Behavior
- 不出现“你的问题”“我们刚才聊到”“我来帮你”等对话表达
- 使用中立百科体
```

回归测试的价值是防止“修一个问题，过两周又复发”。

## 35.9 测试集规模建议

| Skill 类型 | 初始测试数 | 成熟测试数 |
|---|---:|---:|
| 简单文本 Skill | 3–5 | 8–12 |
| 文档整理 Skill | 5–8 | 15–25 |
| 数据分析 Skill | 8–12 | 20–40 |
| 高风险审查 Skill | 10–20 | 30–60 |
| 团队级通用 Skill | 15–30 | 50+ |

## 35.10 本章小结

测试集设计的核心不是堆数量，而是覆盖真实失败路径。

核心公式：

```text
正常案例 + 边界案例 + 反向案例 + 异常案例 + 回归案例
```

---

# 第 36 章：评估维度

## 36.1 什么是 Skill 评估

Skill 评估是对 Skill 行为进行系统判断。

它不仅判断最终输出，还判断：

```text
是否正确触发
是否读取正确资源
是否遵守流程
是否保持边界
是否满足输出契约
是否能稳定复现
```

OpenAI Evals 的基本思想是用数据集和评估器衡量系统输出是否符合预期，这一思路可以迁移到 Skill 评估中：把真实任务转成测试样例，再用明确标准判断输出是否通过。

## 36.2 六个核心评估维度

| 维度 | 评估问题 |
|---|---|
| 触发准确性 | 应该用时是否用了？不该用时是否没用？ |
| 流程遵循度 | 是否按 SKILL.md 的步骤执行？ |
| 输出契约一致性 | 是否符合规定格式和章节？ |
| 事实与边界 | 是否避免编造、越界和过度承诺？ |
| 资源使用合理性 | 是否按需读取 references、assets、scripts？ |
| 稳定性 | 类似输入下是否有一致表现？ |

## 36.3 触发准确性

触发准确性包括两类：

| 类型 | 问题 |
|---|---|
| Recall | 该触发时是否触发 |
| Precision | 不该触发时是否避免触发 |

示例：

| 用户输入 | 理想行为 |
|---|---|
| “把这个内容沉淀成 llm-wiki .md” | 应触发 |
| “简单总结一下” | 不应完整触发 |
| “整理一下，后面可能放知识库” | 可轻量触发 |
| “写一段营销文案” | 不应触发知识库 Skill |

## 36.4 流程遵循度

检查 Agent 是否按 `Process` 执行。

例如 Review 分析 Skill 的流程：

```text
读取评论
→ 分类主题
→ 提取正负信号
→ 区分证据和推断
→ 生成产品机会
→ 输出表格
```

评估问题：

- 是否真的分类？
- 是否区分正面和负面？
- 是否把推断当事实？
- 是否遗漏产品机会？
- 是否按指定表格输出？

## 36.5 输出契约一致性

输出契约评估关注结构。

可检查：

- 是否使用指定格式
- 是否包含必需章节
- 表格列是否完整
- Markdown 层级是否正确
- JSON 是否可解析
- 是否包含禁止内容

这类评估可以部分用脚本完成。

## 36.6 事实与边界

检查 Skill 是否遵守事实和边界。

常见问题：

| 问题 | 示例 |
|---|---|
| 编造事实 | 没有产品参数，却写出具体参数 |
| 过度承诺 | “一定能通过 Amazon 审核” |
| 混淆证据与推断 | 从 3 条评论推断整个市场 |
| 忽略限制 | 用户要求虚构卖点时仍照做 |
| 越权结论 | 合同审查中直接给法律结论 |

## 36.7 资源使用合理性

对于多文件 Skill，还要评估：

- 是否读取了必要 reference
- 是否没有读取无关 reference
- 是否使用了正确 assets
- 是否按条件运行 scripts
- 是否正确解释脚本输出
- 脚本失败时是否如实说明

## 36.8 稳定性评估

稳定性不是要求每次逐字相同，而是要求关键行为一致。

例如：

```text
同类输入下：
- 都触发正确 Skill
- 都保留同一输出结构
- 都遵守相同边界
- 都不虚构事实
- 都处理缺失信息
```

## 36.9 评分表模板

```markdown
| Case ID | Trigger | Process | Output Format | Boundary | Resource Use | Overall | Notes |
|---|---:|---:|---:|---:|---:|---:|---|
| 001 | 1 | 1 | 1 | 1 | 1 | Pass | 主流程正常 |
| 002 | 1 | 0.5 | 1 | 1 | N/A | Partial | 流程部分遗漏 |
| 003 | 0 | N/A | N/A | 1 | N/A | Pass | 正确未触发 |
```

评分建议：

```text
1 = 通过
0.5 = 部分通过
0 = 失败
N/A = 不适用
```

## 36.10 本章小结

评估不是只看输出漂亮不漂亮，而是看 Skill 是否在正确场景中按正确流程产生正确边界内的稳定结果。

核心公式：

```text
触发准确 + 流程遵循 + 输出一致 + 边界可靠 + 资源合理 + 行为稳定
```

---

# 第 37 章：Skill Debug 方法

## 37.1 Skill Debug 的对象

Skill 出问题时，不一定是模型能力问题，也可能是 Skill 设计问题。

常见 Debug 对象包括：

| 对象               | 可能问题               |
| ---------------- | ------------------ |
| Name             | 过泛、过窄、与其他 Skill 冲突 |
| Description      | 触发条件模糊，导致误触发或漏触发   |
| SKILL.md Process | 步骤抽象、缺少顺序、没有异常处理   |
| Output Format    | 结构不明确，导致输出漂移       |
| Constraints      | 边界弱，导致越界           |
| Examples         | 示例不足或与规则冲突         |
| References       | 资料太长、命名混乱、读取条件不清   |
| Scripts          | 输入输出不明、失败处理缺失      |
| Tests            | 覆盖不足，没有反例和边界案例     |

## 37.2 Debug 总流程

```text
1. 复现问题
2. 判断问题类型
3. 定位发生层级
4. 修改最小必要内容
5. 用原失败案例回归测试
6. 用相邻案例验证没有引入新问题
```

不要凭感觉大改。先定位，再修改。

## 37.3 问题一：Skill 没有触发

表现：

```text
用户请求明显符合 Skill 场景，但 Agent 没有使用该 Skill。
```

可能原因：

| 原因 | 修复 |
|---|---|
| description 太抽象 | 增加典型触发词 |
| name 过于模糊 | 改成对象 + 动作 |
| 用户常用中文触发词缺失 | 在 description 加入中文触发表达 |
| Skill 范围写得太窄 | 扩展适用场景 |
| 与其他 Skill 冲突 | 明确差异边界 |

示例修复：

```yaml
description: Use when converting AI conversations, explanations, or notes into neutral Markdown knowledge entries for an LLM Wiki. Trigger for requests such as 沉淀, 整理成 .md, 放入知识库, 转成知识条目, or summarize into reusable notes.
```

## 37.4 问题二：Skill 误触发

表现：

```text
用户只想轻量总结，Agent 却使用完整知识库 Skill。
```

可能原因：

| 原因 | 修复 |
|---|---|
| description 太宽泛 | 增加 Do not use |
| 反例不足 | 加入 Non-examples |
| Scope 不清 | 明确轻量总结不适用 |
| 输出格式过度默认 | 增加轻量分支 |

修复示例：

```markdown
Do not use this skill for casual summaries, personal chat recaps, short explanations, or marketing copy unless the user explicitly asks for knowledge-base-style Markdown.
```

## 37.5 问题三：输出格式漂移

表现：

```text
有时输出表格，有时输出散文，有时缺章节。
```

可能原因：

| 原因 | 修复 |
|---|---|
| Output Format 不具体 | 写固定结构 |
| Quality Criteria 太抽象 | 改成可检查标准 |
| 示例格式不一致 | 统一示例 |
| 用户格式与 Skill 格式冲突 | 写优先级规则 |
| 没有后校验 | 加脚本或检查清单 |

修复示例：

```markdown
# Output Format

Always return the result using these sections, in this order:
1. Executive Summary
2. Findings Table
3. Pain Points
4. Purchase Motivations
5. Product Opportunities
6. Next Actions
```

## 37.6 问题四：边界失效

表现：

```text
Skill 编造产品参数，或把建议说成确定结论。
```

可能原因：

| 原因 | 修复 |
|---|---|
| Constraints 不够明确 | 写禁止事项 |
| 缺失输入处理不足 | 明确信息不足时不编造 |
| 输出没有区分事实和推断 | 增加 Evidence / Assumption / Recommendation |
| 示例中有过度承诺 | 修改示例 |

修复示例：

```markdown
The output must clearly separate:
- Provided facts
- Inferences
- Recommendations
- Missing information

Do not convert assumptions into confirmed facts.
```

## 37.7 问题五：资源使用错误

表现：

```text
Agent 没有读取必要 reference，或读取了所有无关文件。
```

可能原因：

| 原因 | 修复 |
|---|---|
| Resources 没有使用条件 | 给每个文件写 Use when |
| 文件名无语义 | 重命名文件 |
| reference 太多太乱 | 增加索引 |
| SKILL.md 要求读全部资料 | 改为按需读取 |
| assets 与 references 混放 | 重新分层 |

修复示例：

```markdown
# Resource Use

- Read `references/claim-rules.md` only when checking product claims.
- Read `assets/a-plus-template.md` only when producing an Amazon A+ module brief.
- Do not read all references by default.
```

## 37.8 问题六：脚本没有被正确使用

表现：

```text
Skill 有 scripts，但 Agent 没调用；或者调用后不知道如何解释结果。
```

可能原因：

| 原因 | 修复 |
|---|---|
| SKILL.md 没写使用条件 | 加入脚本触发条件 |
| 脚本输入输出不明 | 写命令和输出格式 |
| 脚本失败处理缺失 | 增加 Failure Handling |
| 脚本名称过泛 | 重命名 |
| 脚本结果未回流 | 写明如何使用结果修复输出 |

## 37.9 Debug 检查表

```text
1. 是触发问题，还是执行问题？
2. 是 description 问题，还是正文流程问题？
3. 是输出格式不清，还是质量标准不清？
4. 是缺少反例，还是边界规则不足？
5. 是 reference 没读，还是 reference 内容冲突？
6. 是脚本没调用，还是脚本结果没解释？
7. 是否已有测试案例覆盖该问题？
8. 修复后是否加入回归测试？
```

## 37.10 本章小结

Skill Debug 的原则是：

```text
先复现，再归因；先小改，再回归；先修规则，再补测试。
```

---

# 第 38 章：迭代方法

## 38.1 Skill 不是一次写完的

Skill 的质量来自持续迭代。

真实流程通常是：

```text
V0：能执行
V1：结构稳定
V2：边界清楚
V3：案例覆盖
V4：脚本增强
V5：团队可复用
```

不要期待第一个版本就完整。正确做法是让 Skill 在真实任务中暴露问题，然后逐步补强。

## 38.2 从失败案例反推规则

每一次失败都应转化为 Skill 改进项。

| 失败 | 反推规则 |
|---|---|
| 输出出现对话口吻 | 增加禁用表达 |
| 信息不足时编造 | 增加缺失输入处理 |
| 用户轻量请求却输出完整报告 | 增加反向案例 |
| Review 分析把推断当事实 | 增加 evidence / inference 分离规则 |
| 设计提示词虚构功能 | 增加 unsupported claims 处理规则 |

## 38.3 从常见错误沉淀约束

如果某类错误出现多次，不应只靠人工提醒，而应写入 Skill：

```markdown
# Constraints

Do not:
- Invent missing product features.
- Treat assumptions as facts.
- Preserve conversational framing.
- Add unsupported platform compliance claims.
```

## 38.4 从成功案例沉淀模板

成功案例也要沉淀。

如果某次输出非常好，应分析：

- 结构为什么好
- 粒度为什么合适
- 哪些章节可复用
- 哪些表达可作为模板
- 哪些判断规则可写入 reference

然后沉淀为：

```text
assets/template.md
references/examples.md
tests/golden-cases.md
```

## 38.5 Skill 版本迭代记录

建议维护 `CHANGELOG.md`：

```markdown
# 更新日志
## v0.3.0

### 新增
- 新增针对随意摘要请求的反例。 
- 新增源内容不足时的缺失输入处理规则。

### 变更
- 优化 description，加入中文触发词：沉淀、知识库、.md。

### 修复
- 防止“你的问题”等对话式表达出现在最终输出中。
```

## 38.6 迭代优先级

当同时发现多个问题时，按以下顺序修复：

```text
安全与事实问题
→ 误触发 / 漏触发问题
→ 输出结构问题
→ 边界问题
→ 示例不足
→ 语气与风格问题
```

原因：

- 安全和事实问题风险最高
- 触发问题影响是否能用
- 输出结构影响可复用
- 风格问题重要，但优先级低于稳定性

## 38.7 不要过度迭代

过度迭代会导致 Skill 变复杂。

警惕以下现象：

| 现象 | 风险 |
|---|---|
| 为一个低频失败写大量规则 | 主文件膨胀 |
| 每次用户偏好都写入 Skill | Skill 失去通用性 |
| 把所有案例都塞进 SKILL.md | 上下文污染 |
| 规则互相冲突 | 输出不稳定 |
| 过度脚本化 | 维护成本上升 |

正确策略：

```text
高频失败写入主流程
中频失败写入 references
低频失败写入测试集或备注
一次性偏好不写入 Skill
```

## 38.8 本章小结

Skill 迭代不是不断加内容，而是把真实使用中的稳定规律沉淀到正确位置。

核心公式：

```text
失败案例 → 规则
成功案例 → 模板
历史问题 → 回归测试
高频需求 → 主流程
低频需求 → 参考资料
```

---

# 第 39 章：Eval 驱动开发

## 39.1 什么是 Eval 驱动开发

Eval 驱动开发是指：

> 在开发或修改 Skill 前，先定义测试案例和评估标准，再根据评估结果迭代 Skill。

它类似软件开发中的 TDD，但对象不是普通函数，而是 Agent 行为。

```text
先写测试
→ 再写 Skill
→ 跑测试
→ 发现失败
→ 修改 Skill
→ 回归测试
```

## 39.2 为什么 Skill 适合 Eval 驱动

Skill 的核心问题不是“能不能回答”，而是“能不能稳定按预期行为回答”。

Eval 可以验证：

- 是否触发正确
- 是否避免误触发
- 是否按流程执行
- 是否遵守边界
- 是否输出稳定格式
- 是否处理异常输入
- 是否在更新后保持旧能力

## 39.3 Eval 驱动开发流程

```text
1. 定义 Skill 目标
2. 写 5–10 个代表性测试案例
3. 写预期行为与通过标准
4. 创建最小 Skill
5. 用测试案例运行 Skill
6. 记录失败模式
7. 修改 description、流程、边界、示例或脚本
8. 回归测试
9. 扩充测试集
```

## 39.4 最小 Eval 表

```markdown
| Case ID | Input | Expected Behavior | Pass Criteria | Result | Notes |
|---|---|---|---|---|---|
| 001 | 把内容沉淀成 llm-wiki .md | 触发知识库 Skill | 输出中立 Markdown | Pass | - |
| 002 | 简单总结一下 | 不完整触发 | 只输出简短总结 | Fail | 误触发 |
| 003 | 缺少来源内容 | 标注不足 | 不编造事实 | Pass | - |
```

## 39.5 自动评估与人工评估

Skill Eval 可以分为两类：

| 类型 | 适合评估 |
|---|---|
| 自动评估 | 格式、字段、标题层级、禁用词、JSON 合法性 |
| 人工评估 | 语义质量、判断合理性、业务价值、表达是否自然 |

不要试图把所有评估都自动化。很多 Skill 输出需要人类判断。

## 39.6 可自动化的评估项

| 评估项 | 自动化方式 |
|---|---|
| 是否包含必需章节 | 正则或 Markdown 解析 |
| 是否出现禁用词 | 字符串匹配 |
| JSON 是否合法 | JSON parser |
| 表格列是否完整 | Markdown table parser |
| 是否缺少 frontmatter | YAML parser |
| 文件名是否合规 | 正则 |
| 是否存在空章节 | 文本规则 |
| 是否标题层级跳跃 | Markdown parser |

## 39.7 需要人工评估的项目

| 评估项 | 原因 |
|---|---|
| 是否真正理解任务 | 需要语义判断 |
| 输出是否有业务价值 | 需要领域经验 |
| 建议是否合理 | 需要上下文判断 |
| 文案是否有转化力 | 需要市场判断 |
| 设计 brief 是否可执行 | 需要设计经验 |
| 是否过度简化 | 需要知识判断 |

## 39.8 Eval 结果如何反哺 Skill

| Eval 发现 | 修改位置 |
|---|---|
| 该触发没触发 | `description` |
| 不该触发却触发 | `description` + Non-examples |
| 输出缺章节 | Output Format |
| 编造事实 | Constraints + Missing Information Handling |
| 资源没读 | Resources Use |
| 语气不稳定 | references/style-guide.md |
| 格式错误 | scripts/validate.py |
| 老问题复发 | regression tests |

## 39.9 Eval 驱动开发的最小闭环

```text
测试案例
→ 运行 Skill
→ 记录结果
→ 定位失败
→ 修改 Skill
→ 加入回归案例
→ 再运行测试
```

## 39.10 本章小结

Eval 驱动开发让 Skill 从“靠感觉优化”转为“靠证据迭代”。

核心结论：

> 先定义如何判断好坏，再编写和修改 Skill；否则 Skill 优化只是主观修补。

---

# 阶段七总结

阶段七的核心结论：

1. **一次成功不代表 Skill 稳定。**  
   Skill 必须通过多案例验证，而不是靠一次演示判断质量。

2. **测试集要覆盖真实失败路径。**  
   正常案例、边界案例、反向案例、异常案例和回归案例缺一不可。

3. **评估不只看最终输出。**  
   还要看触发是否准确、流程是否遵守、边界是否可靠、资源是否合理、行为是否稳定。

4. **Debug 要定位层级。**  
   可能是 description、Process、Output Format、Constraints、Examples、References、Scripts 或 Tests 的问题。

5. **迭代要基于案例。**  
   失败案例沉淀规则，成功案例沉淀模板，历史问题沉淀回归测试。

6. **Eval 驱动开发是 Skill 工程化的核心。**  
   先定义测试和通过标准，再写 Skill，再根据评估结果迭代。

阶段七最重要的一句话：

> Skill 的质量不是写出来的，而是通过测试、评估、调试和回归逐步验证出来的。

---

# 阶段七掌握检查

完成阶段七后，应能回答：

1. 为什么一次成功不能证明 Skill 稳定？
2. Skill 测试集应该包含哪些类型的案例？
3. 正常案例、边界案例、反向案例、异常案例、回归案例分别解决什么问题？
4. Skill 评估应覆盖哪些维度？
5. 如何判断一个 Skill 是漏触发还是误触发？
6. 输出格式漂移应该如何 Debug？
7. 边界失效通常应该修改哪里？
8. 为什么每次修复 bug 后都要加入回归测试？
9. 哪些评估适合自动化，哪些必须人工评估？
10. Eval 驱动开发和普通“试试看”有什么区别？

---

# 可沉淀的最小方法论

```text
Skill 测试评估六步法：

1. 先定义测试集：正常、边界、反向、异常、回归
2. 再定义评估维度：触发、流程、输出、边界、资源、稳定性
3. 运行真实任务样例
4. 记录失败模式
5. 定位到 description、Process、Output、Constraints、Examples、Resources、Scripts 或 Tests
6. 修改后加入回归测试，防止问题复发
```

---

# 推荐目录结构

```text
my-skill/
├── SKILL.md
├── references/
│   ├── examples.md
│   └── style-guide.md
├── scripts/
│   └── validate_output.py
└── tests/
    ├── cases.md
    ├── expected.md
    ├── regression.md
    └── eval-results.md
```

---

# 测试案例模板

```markdown
## Case ID: [case-id]

### Type
[normal / boundary / negative / failure / regression]

### User Input
[User request]

### Expected Behavior
- [Expected trigger behavior]
- [Expected workflow behavior]
- [Expected output behavior]
- [Expected boundary behavior]

### Pass Criteria
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

### Failure Notes
[Record actual failures here.]
```

---

# Eval 结果模板

```markdown
| Case ID | Type | Trigger | Process | Output | Boundary | Resource Use | Result | Notes |
|---|---|---:|---:|---:|---:|---:|---|---|
| 001 | normal | 1 | 1 | 1 | 1 | N/A | Pass | - |
| 002 | negative | 0 | N/A | N/A | 1 | N/A | Pass | Correctly did not trigger |
| 003 | boundary | 1 | 0.5 | 1 | 1 | N/A | Partial | Process missed missing-info note |
```

---

# 参考依据

- OpenAI Codex Skills：Skill 目录结构、`SKILL.md`、scripts、references、progressive disclosure。
- OpenAI Evals：通过数据集、评估器、实验记录对模型行为进行结构化评估。
- Anthropic Agent Skills：Skill 作为包含 instructions、scripts、resources 的目录，并面向真实 Agent 工作流。
- Anthropic 工具工程实践：通过真实任务与评估改进 Agent 工具和工具说明。
