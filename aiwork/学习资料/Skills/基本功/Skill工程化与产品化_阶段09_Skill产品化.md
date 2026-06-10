# Skill 工程化与产品化｜阶段九：Skill 产品化

## 阶段定位

阶段九关注 Skill 的产品化。前八个阶段已经解决了 Skill 的结构、流程、上下文、脚本、测试、安全和治理问题。阶段九进一步解决：

```text
Skill 给谁用？
解决什么具体问题？
什么版本才算 MVP？
用户如何知道何时使用？
如何分发？
如何收集反馈？
如何判断继续维护、合并、拆分或下架？
```

OpenAI ChatGPT Skills 文档将 Skills 定义为可复用、可共享的工作流，并支持将强流程转成可分享、可发布到工作区库的 Skill。OpenAI Academy 的 Skills 课程也强调 Skills 可用于构建可复用工作流、自动化重复任务并提高输出一致性。OpenAI Codex Skills 文档则强调 Skill 是包含 `SKILL.md` 的目录，可附带 scripts、references 和 assets，并使用 progressive disclosure 管理上下文。

阶段九的核心观点：

> Skill 产品化的目标，不是把 Skill 写得更复杂，而是让 Skill 被正确的人在正确场景中低成本使用，并通过反馈持续产生稳定价值。

---

# 第 45 章：Skill 的产品定位

## 45.1 什么是 Skill 产品定位

Skill 产品定位，是指明确一个 Skill 作为“能力产品”到底服务谁、解决什么问题、在哪些场景使用、产生什么交付物、如何判断价值。

一个 Skill 如果缺少产品定位，即使工程结构完整，也可能出现：

```text
用户不知道什么时候用
输出看起来专业但不解决真实问题
Skill 和其他 Skill 重叠
维护人不知道该优化什么
团队不知道值不值得推广
```

产品化 Skill 必须从“写给模型的说明”升级为“给用户、团队和组织使用的能力产品”。

## 45.2 Skill 产品定位五要素

| 要素 | 要回答的问题 | 示例 |
|---|---|---|
| 用户 | 谁会使用这个 Skill？ | Amazon 运营、UI 设计师、知识库维护者 |
| 场景 | 用户在什么情况下需要它？ | 分析评论、整理知识库、审查说明书 |
| 痛点 | 不用 Skill 时有什么问题？ | 每次重复写 Prompt、输出标准不一致 |
| 产物 | Skill 最终交付什么？ | Markdown、报告、表格、brief、测试用例 |
| 价值 | 使用后改善什么？ | 节省时间、统一标准、减少漏项、提升质量 |

定位公式：

```text
为 [目标用户]，在 [高频场景] 中，解决 [具体痛点]，输出 [可用产物]，带来 [可衡量价值]。
```

## 45.3 示例：LLM Wiki Writer Skill 定位

| 要素 | 内容 |
|---|---|
| 用户 | 知识库维护者、AI 学习者、团队知识管理者 |
| 场景 | 将对话、课程、说明、笔记沉淀为知识库 |
| 痛点 | 临时总结口语化、结构不统一、难复用 |
| 产物 | 中立百科体 Markdown 知识条目 |
| 价值 | 提高知识沉淀效率，保证格式统一，降低重复整理成本 |

定位表达：

```text
为知识库维护者，在需要将 AI 对话或学习内容沉淀到 LLM Wiki 时，提供中立、结构化、可复用的 Markdown 知识条目输出，减少重复整理成本并提升知识库一致性。
```

## 45.4 示例：Amazon Review Analyzer Skill 定位

| 要素 | 内容 |
|---|---|
| 用户 | Amazon 运营、产品经理、市场分析人员 |
| 场景 | 分析商品评论、提取用户痛点和机会 |
| 痛点 | 评论量大、人工阅读慢、洞察容易零散 |
| 产物 | Review 洞察报告、痛点表、卖点机会、产品优化建议 |
| 价值 | 提高评论分析效率，支持产品优化和文案决策 |

定位表达：

```text
为 Amazon 运营和产品人员，在需要从商品评论中提取用户洞察时，提供主题分类、痛点识别、好评驱动、功能请求和产品机会分析，帮助快速形成可执行的运营与产品建议。
```

## 45.5 产品定位与 Skill 边界

定位越清楚，边界越容易写。

例如：

```text
Skill 定位：分析 Amazon 评论，支持产品和运营决策。
```

对应边界：

```text
不负责抓取未授权数据
不虚构评论
不把少量评论当作市场定论
不替代正式市场调研
不直接生成未经证据支持的功能宣称
```

定位不清会导致边界不清，边界不清会导致误触发和越界输出。

## 45.6 产品定位的常见错误

| 错误 | 表现 | 修正 |
|---|---|---|
| 用户过泛 | “给所有人用” | 明确主要用户 |
| 场景过泛 | “提升工作效率” | 指向具体任务场景 |
| 痛点抽象 | “提高质量” | 说明质量问题在哪里 |
| 产物不清 | “输出建议” | 定义报告、表格、brief、文件 |
| 价值不可判断 | “更专业” | 定义节省时间、减少漏项、统一格式 |
| 定位与能力不匹配 | 定位很大，Skill 很小 | 缩小定位或拆分 Skill |

## 45.7 产品定位检查表

```text
1. 是否明确目标用户？
2. 是否明确高频使用场景？
3. 是否说明不用 Skill 时的真实痛点？
4. 是否定义最终交付物？
5. 是否能解释使用后的价值？
6. 是否能和其他 Skill 区分？
7. 是否能指导 description、Scope 和 Output Format？
8. 是否能判断哪些需求不该纳入该 Skill？
```

## 45.8 本章小结

Skill 产品定位的核心不是“这个 Skill 能做什么”，而是“谁在什么场景下为什么需要它”。

核心公式：

```text
目标用户 + 高频场景 + 具体痛点 + 明确产物 + 可衡量价值
```

---

# 第 46 章：Skill 的最小可用版本

## 46.1 什么是 MVP Skill

MVP Skill，即 Minimum Viable Product Skill，最小可用 Skill。

它不是功能最少的 Skill，而是：

> 能在一个明确场景中稳定解决一个核心问题，并产生可验收输出的最小 Skill。

MVP Skill 的目标是快速进入真实使用，收集反馈，而不是一开始就把所有能力做完。

## 46.2 MVP Skill 的组成

一个 MVP Skill 至少应包含：

| 组成 | 说明 |
|---|---|
| `SKILL.md` | 主说明文件 |
| `name` | 清晰名称 |
| `description` | 明确触发条件 |
| Purpose | 明确任务目标 |
| Scope | 做什么、不做什么 |
| Inputs | 必填和可选输入 |
| Process | 核心执行步骤 |
| Output Format | 固定输出结构 |
| Constraints | 禁止事项 |
| Examples | 至少 1 个正例和 1 个反例 |
| Tests | 至少 3 个测试案例 |

如果一个 Skill 不能通过 3 个真实测试案例，就不应发布给团队。

## 46.3 MVP Skill 不需要什么

MVP 阶段不一定需要：

| 内容 | 原因 |
|---|---|
| 大量 references | 初期先验证核心流程 |
| 完整案例库 | 可从真实使用中沉淀 |
| 多脚本系统 | 先手动验证是否值得脚本化 |
| 复杂权限体系 | 小范围试用即可 |
| 完美 UI 文档 | 先保证任务可用 |
| 大规模分发 | 避免未成熟 Skill 扩散 |

MVP 不是低质量，而是低范围。

## 46.4 MVP Skill 的边界

MVP Skill 必须有明确边界。

例如，Review 分析 MVP：

```text
只处理用户已提供的评论文本
只输出主题分类、痛点、好评驱动和产品机会
不负责自动抓取评论
不负责竞品对比
不负责生成完整上市策略
```

这样可以避免一开始范围过大。

## 46.5 MVP Skill 示例：内容清洁 Skill

### MVP 定位

```text
清理 Prompt、Skill 文件或工作流说明中的废话、重复表达、迎合性语言和无效约束，保留可执行内容。
```

### 最小输入

```text
一段待清理文本
```

### 最小输出

```text
1. Cleaned Content
2. Removed Noise
3. Remaining Ambiguities
```

### 最小流程

```text
识别任务意图
→ 删除重复表达
→ 删除空泛形容词
→ 删除迎合性语言
→ 保留操作性规则
→ 输出清洁版本
```

### 最小测试

```text
1. 输入一段冗长 Prompt，检查是否保留关键约束
2. 输入一段 Skill.md，检查是否删除无效角色扮演
3. 输入一段安全规则，检查是否没有弱化安全约束
```

## 46.6 MVP Skill 的验收标准

MVP Skill 通过标准：

```text
1. 用户知道什么时候用
2. 用户知道需要提供什么
3. 输出结构稳定
4. 至少能通过 3–5 个真实案例
5. 不会明显误触发
6. 不会明显越界
7. 有最小示例
8. 有 owner
9. 有下一步迭代方向
```

## 46.7 从 MVP 到成熟 Skill

演进路径：

```text
MVP：一个场景稳定可用
→ V1：补充边界和反例
→ V2：增加 references 和模板
→ V3：增加 scripts 和校验
→ V4：增加测试集和回归测试
→ V5：团队共享与治理
```

## 46.8 MVP Skill 常见错误

| 错误 | 表现 | 修正 |
|---|---|---|
| 一开始做太大 | 想覆盖所有场景 | 先锁定一个核心场景 |
| 没有测试 | 只靠主观满意 | 至少跑 3–5 个案例 |
| 没有反例 | 容易误触发 | 加入不适用案例 |
| 输出不固定 | 每次格式不同 | 固定 Output Format |
| 过早脚本化 | 维护成本高 | 先验证流程稳定 |
| 直接全员发布 | 风险扩散 | 小范围试用 |

## 46.9 本章小结

MVP Skill 的关键不是小，而是“在最小范围内可用、可测、可迭代”。

核心公式：

```text
一个用户 + 一个场景 + 一个痛点 + 一个产物 + 一组测试
```

---

# 第 47 章：Skill 用户体验

## 47.1 Skill UX 是什么

Skill 用户体验不是界面设计，而是用户使用 Skill 时的整体体验：

```text
能不能找到
能不能理解
能不能正确触发
能不能少解释
能不能得到可用结果
失败时能不能知道原因
```

OpenAI ChatGPT Skills 支持用户创建、安装、分享和发布 Skill；Codex Skills 支持通过 `description` 进行发现和调用。因此，Skill UX 不只发生在输出结果，也发生在命名、描述、触发、示例、错误处理和交付方式中。

## 47.2 Skill UX 的五个关键点

| 关键点 | 说明 |
|---|---|
| 可发现 | 用户或 Agent 能知道这个 Skill 存在 |
| 可理解 | 看名称和描述能知道用途 |
| 可触发 | 用户自然表达时能被正确使用 |
| 可执行 | 用户不需要反复补充说明 |
| 可交付 | 输出能直接进入下一步工作 |

## 47.3 名称体验

名称要让用户一眼知道用途。

| 差名称 | 问题 | 好名称 |
|---|---|---|
| `helper` | 太泛 | `llm-wiki-writer` |
| `amazon` | 不知道做什么 | `amazon-review-analyzer` |
| `copy-tool` | 场景不清 | `amazon-a-plus-copywriter` |
| `cleaner` | 对象不清 | `skill-content-cleaner` |

名称体验公式：

```text
对象 + 动作
```

或：

```text
平台 + 对象 + 动作
```

## 47.4 描述体验

`description` 既给 Agent 看，也影响用户理解。

好的 description 应该包含：

```text
什么场景使用
处理什么对象
输出什么产物
什么时候不用
```

示例：

```yaml
description: Use when converting AI conversations, notes, or explanations into neutral Markdown knowledge entries for an LLM Wiki. Trigger for requests to 沉淀, 整理成 .md, or build reusable knowledge-base notes. Do not use for casual summaries or marketing copy.
```

## 47.5 输入体验

用户体验差的 Skill 会要求用户提供太多信息。

好的 Skill 应区分：

```text
必填输入：没有就不能做
可选输入：有则更好
默认策略：缺少时可安全默认
```

示例：

```text
用户只提供“把这段内容沉淀成知识库”
Skill 应能默认：
- Markdown 格式
- 中立百科体
- 自动推断标题
- 去除口语化表达
```

不应默认：

```text
事实
数据
产品参数
法律结论
平台审核结果
```

## 47.6 输出体验

用户体验好的 Skill 输出应具备：

| 特征 | 说明 |
|---|---|
| 可复制 | 结构清楚，可直接粘贴 |
| 可执行 | 下一步动作明确 |
| 可复用 | 脱离当前对话仍能使用 |
| 可检查 | 用户知道哪里对、哪里不确定 |
| 可修改 | 结构便于人工调整 |
| 不废话 | 不含无效铺垫和自我解释 |

## 47.7 失败体验

失败体验是 Skill 产品化的重要部分。

低质量失败：

```text
抱歉，我无法完成。
```

高质量失败：

```text
当前缺少源内容，无法生成基于材料的知识库条目。可先提供对话、笔记或草稿；如果需要，我也可以先输出一个框架型条目，但会标注“信息不足”。
```

失败处理应包含：

```text
失败原因
缺少什么
能做什么降级处理
不能做什么
下一步怎么继续
```

## 47.8 用户文档

团队级 Skill 应提供最小使用说明：

```markdown
# How to Use

Use this skill when:
- [Scenario 1]
- [Scenario 2]

Do not use it when:
- [Excluded scenario]

Required input:
- [Input]

Example requests:
- [Example 1]
- [Example 2]

Expected output:
- [Output structure]
```

## 47.9 Skill UX 检查表

```text
1. 名称是否一眼可懂？
2. description 是否说明何时用、何时不用？
3. 用户是否能用自然语言触发？
4. 是否减少不必要追问？
5. 缺失信息时是否有明确降级策略？
6. 输出是否可直接复制到工作流？
7. 失败时是否说明原因和下一步？
8. 示例是否贴近真实任务？
9. 新用户是否能在 1 分钟内理解用途？
10. 结果是否减少用户后处理成本？
```

## 47.10 本章小结

Skill UX 的核心是降低使用成本。

核心公式：

```text
易发现 + 易理解 + 易触发 + 少追问 + 可交付 + 失败可恢复
```

---

# 第 48 章：Skill 分发

## 48.1 什么是 Skill 分发

Skill 分发，是指让 Skill 从创建者手中进入真实使用场景的过程。

分发不是简单“发文件”，而是包含：

```text
分发对象
分发范围
安装方式
权限控制
使用说明
版本同步
反馈渠道
下架机制
```

OpenAI ChatGPT Skills 文档说明，用户可以将强工作流转成可复用 Skill，并分享给 teammates 或发布到 workspace library；企业/教育工作区管理员还可控制 Skill 创建、上传、分享、发布和安装等权限。

## 48.2 分发层级

| 层级 | 适用阶段 | 特征 |
|---|---|---|
| 个人使用 | 草稿 / MVP | 自己验证 |
| 小组试用 | V1 | 收集真实反馈 |
| 项目内使用 | V2 | 服务具体项目流程 |
| 部门共享 | V3 | 形成部门标准 |
| 工作区发布 | V4 | 经过治理的通用 Skill |
| 外部发布 | V5 | 需要品牌、合规、安全审查 |

不要让 MVP 直接进入全员分发。

## 48.3 个人分发

个人分发适合：

- 草稿 Skill
- 私人工作流
- 未经过测试的 Skill
- 只服务个人偏好的 Skill

个人 Skill 可以快速迭代，但不应被视为团队标准。

## 48.4 小组试用

小组试用适合验证：

```text
是否真实有用
用户是否会触发
输出是否稳定
边界是否清楚
是否存在误用
是否值得继续产品化
```

小组试用建议记录：

| 字段 | 说明 |
|---|---|
| 使用者 | 谁在用 |
| 场景 | 什么任务 |
| 输入 | 用户如何表达 |
| 输出 | 结果是否可用 |
| 问题 | 失败或不稳定点 |
| 迭代建议 | 应改哪里 |

## 48.5 团队共享

团队共享前应具备：

```text
清晰定位
稳定 description
输入输出契约
至少 5–10 个测试案例
基础安全审查
owner
版本号
使用说明
反馈机制
```

团队共享的目标是统一流程，而不是让每个人自由改。

## 48.6 工作区发布

工作区发布适合：

- 高频通用 Skill
- 已通过测试和审查
- 有 owner
- 有维护计划
- 对团队有明确价值
- 风险可控

OpenAI ChatGPT Skills 文档说明，Skill 可以发布到 workspace library，管理员可在 Skills 页面查看 owner、access、users、invocations、created、updated 等信息，并管理访问、所有权和删除。这些信息可用于分发后的治理。

## 48.7 分发包内容

一个成熟 Skill 分发包建议包含：

```text
SKILL.md
README.md
CHANGELOG.md
SECURITY.md
references/
assets/
scripts/
tests/
```

其中：

| 文件 | 作用 |
|---|---|
| `README.md` | 给人看的使用说明 |
| `SKILL.md` | 给 Agent 的执行说明 |
| `CHANGELOG.md` | 版本变化 |
| `SECURITY.md` | 安全说明 |
| `tests/` | 验证案例 |
| `references/` | 参考资料 |
| `assets/` | 模板资源 |
| `scripts/` | 可执行脚本 |

## 48.8 分发中的常见错误

| 错误 | 风险 | 修正 |
|---|---|---|
| 未测试就分发 | 输出不稳定 | 先跑测试集 |
| 无 owner | 问题无人处理 | 指定维护人 |
| 无说明文档 | 用户不会用 | 增加 README |
| 无版本号 | 更新不可追踪 | 使用版本治理 |
| 全员默认安装 | 风险扩散 | 分阶段分发 |
| 无反馈入口 | 问题无法沉淀 | 建反馈表 |
| 不下架旧版 | 旧流程污染团队 | 建废弃机制 |

## 48.9 本章小结

Skill 分发的本质，是把能力从个人经验变成可控共享资产。

核心公式：

```text
先个人验证 → 小组试用 → 项目共享 → 部门推广 → 工作区发布
```

---

# 第 49 章：Skill 运营

## 49.1 什么是 Skill 运营

Skill 运营，是指 Skill 发布后围绕使用、反馈、质量、版本和生命周期进行持续管理。

很多 Skill 的问题不是“做不出来”，而是：

```text
发布后没人用
用错场景
旧版继续流通
反馈没人处理
越改越复杂
低质量 Skill 越积越多
```

Skill 运营的目标是让 Skill 长期保持价值。

## 49.2 Skill 运营指标

可以关注以下指标：

| 指标 | 说明 |
|---|---|
| 使用次数 | 是否真的被使用 |
| 使用人数 | 是否被多人复用 |
| 成功率 | 输出是否可用 |
| 失败类型 | 误触发、漏触发、格式漂移、越界等 |
| 返工率 | 用户是否需要大量修改 |
| 反馈数量 | 是否有真实改进信号 |
| 更新时间 | 是否长期无人维护 |
| 替代率 | 是否被更好 Skill 替代 |
| 安全事件 | 是否出现敏感数据或越权问题 |

OpenAI ChatGPT Skills 文档提到管理员可查看 Skill 的 users、invocations、created、updated 等信息，这类数据可作为运营和复审依据。

## 49.3 Skill 反馈闭环

反馈应进入结构化流程：

```text
收集反馈
→ 分类问题
→ 判断严重度
→ 定位 Skill 层级
→ 修改 Skill
→ 加入测试
→ 发布新版本
→ 观察结果
```

问题分类示例：

| 问题类型 | 可能修改位置 |
|---|---|
| 不会触发 | description |
| 误触发 | description + non-examples |
| 输出缺失 | Output Format |
| 编造事实 | Constraints |
| 语气不对 | references/style-guide.md |
| 模板不合适 | assets/template.md |
| 格式错误 | scripts/validate.py |
| 权限风险 | SECURITY.md / Scope |

## 49.4 Skill 生命周期

Skill 可以分为六个生命周期阶段：

| 阶段 | 状态 | 管理重点 |
|---|---|---|
| Draft | 草稿 | 快速验证 |
| MVP | 最小可用 | 小范围真实使用 |
| Active | 活跃 | 收集反馈、维护质量 |
| Stable | 稳定 | 控制变更、回归测试 |
| Deprecated | 即将废弃 | 提供替代 Skill |
| Archived | 已归档 | 停止推荐使用 |

## 49.5 Skill 继续维护的判断

值得继续维护的 Skill 通常具备：

```text
使用频率高
问题清晰可修
业务价值稳定
没有更好替代
owner 仍可维护
安全风险可控
```

不值得继续维护的 Skill：

```text
长期无人使用
场景已消失
规则已过期
与其他 Skill 重叠
维护成本高于收益
存在不可控风险
```

## 49.6 Skill 合并、拆分与下架

### 需要合并的情况

```text
两个 Skill 高度重叠
用户经常不知道用哪个
输出结构接近
维护规则重复
```

### 需要拆分的情况

```text
一个 Skill 覆盖太多场景
description 变得很长
输出格式有多套
测试案例难以统一
不同用户群需求冲突
```

### 需要下架的情况

```text
存在安全风险
规则严重过期
误用频率高
已被新 Skill 替代
无人维护
```

## 49.7 Skill 运营节奏

推荐节奏：

```text
每周：查看高频反馈和严重问题
每月：更新测试集和 changelog
每季度：复审低使用 Skill、过期 Skill、重叠 Skill
重大业务变化后：重新评估相关 Skill
安全事件后：立即审查和回滚
```

## 49.8 Skill 运营看板

可建立简单表格：

```markdown
| Skill | Owner | Status | Users | Invocations | Success Rate | Last Updated | Main Issues | Next Action |
|---|---|---|---:|---:|---:|---|---|---|
| llm-wiki-writer | Terry | Active | 3 | 48 | 85% | 2026-06-02 | 输出偶尔过长 | 增加轻量模式 |
| amazon-review-analyzer | Ops | MVP | 2 | 12 | 70% | 2026-06-02 | 缺少反例 | 补测试集 |
```

## 49.9 Skill 运营常见误区

| 误区 | 问题 | 修正 |
|---|---|---|
| 发布后不管 | 质量持续下降 | 建立 owner 和复审 |
| 只看使用次数 | 高频不等于高价值 | 看成功率和返工率 |
| 所有反馈都吸收 | Skill 变臃肿 | 只吸收稳定共性需求 |
| 不淘汰旧 Skill | Skill Library 污染 | 建归档和废弃机制 |
| 不记录版本 | 无法复盘 | 建 changelog |
| 不做回归 | 修复引入新问题 | 加 regression tests |

## 49.10 本章小结

Skill 运营的核心是生命周期管理。

核心公式：

```text
使用数据 + 用户反馈 + 质量评估 + 版本迭代 + 合并拆分 + 淘汰归档
```

---

# 阶段九总结

阶段九的核心结论：

1. **Skill 产品化从定位开始。**  
   必须明确目标用户、使用场景、具体痛点、交付产物和可衡量价值。

2. **MVP Skill 要小范围可用、可测、可迭代。**  
   它不是功能简陋，而是聚焦一个核心场景。

3. **Skill UX 决定用户是否愿意用。**  
   名称、description、输入要求、输出结构、失败处理都会影响体验。

4. **分发不是发文件，而是能力交付。**  
   需要范围、权限、版本、说明、反馈和下架机制。

5. **运营决定 Skill 是否长期有价值。**  
   发布后要持续看使用、反馈、质量、版本、生命周期和安全风险。

阶段九最重要的一句话：

> Skill 产品化不是把 Skill 做大，而是让 Skill 在明确用户、明确场景、明确价值和可持续运营中变成真正可复用的能力产品。

---

# 阶段九掌握检查

完成阶段九后，应能回答：

1. Skill 产品定位包含哪五个要素？
2. 为什么 Skill 不能只从“能做什么”出发？
3. MVP Skill 的最小组成是什么？
4. MVP Skill 为什么不应该一开始就全员发布？
5. Skill UX 包含哪些部分？
6. 为什么 description 同时影响触发和用户理解？
7. Skill 分发有哪些层级？
8. 一个成熟 Skill 分发包应该包含哪些文件？
9. Skill 运营应该关注哪些指标？
10. 什么时候应该维护、合并、拆分、下架一个 Skill？

---

# 可沉淀的最小方法论

```text
Skill 产品化七步法：

1. 定位：明确用户、场景、痛点、产物、价值
2. MVP：用最小范围验证一个核心场景
3. UX：优化名称、description、输入、输出、失败体验
4. 分发：从个人验证到小组试用，再到团队或工作区发布
5. 反馈：记录真实使用问题和成功案例
6. 迭代：用反馈更新规则、示例、模板、测试和版本
7. 运营：持续维护、合并、拆分、下架和归档
```

---

# 推荐产品化文件结构

```text
my-productized-skill/
├── SKILL.md
├── README.md
├── CHANGELOG.md
├── SECURITY.md
├── references/
│   ├── style-guide.md
│   └── examples.md
├── assets/
│   └── output-template.md
├── scripts/
│   └── validate_output.py
└── tests/
    ├── cases.md
    ├── regression.md
    └── eval-results.md
```

---

# README 模板

```markdown
# [Skill Name]

## What this skill does

[Describe the specific workflow.]

## Who should use it

- [Target user 1]
- [Target user 2]

## When to use it

- [Scenario 1]
- [Scenario 2]

## When not to use it

- [Excluded scenario 1]
- [Excluded scenario 2]

## Required input

- [Required input]

## Example requests

- [Example 1]
- [Example 2]

## Expected output

- [Output structure]

## Owner

[Owner name/team]

## Version

[Version number]
```

---

# 参考依据

- OpenAI ChatGPT Skills：Skills 是可复用、可共享的工作流，可分享给 teammates 或发布到 workspace library；管理员可管理访问、所有权、使用和发布。
- OpenAI Academy Skills：Skills 用于构建可复用工作流、自动化重复任务、提高一致性和质量。
- OpenAI Codex Skills：Skill 是包含 `SKILL.md` 的目录，可附带 scripts、references、assets，并使用 progressive disclosure。
- OpenAI GPT Sharing / Workspace 管理：共享范围、权限等级、owner、workspace 管理可作为 Skill 团队分发和治理的参考。
- OpenAI Evals：通过测试输入、评估器和迭代改进来提升 AI 系统表现，可迁移为 Skill 产品化后的质量运营机制。
