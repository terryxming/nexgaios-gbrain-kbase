# Skill 工程化与产品化｜阶段十：Skill Library 与组织能力资产

## 阶段定位

阶段十关注 Skill 从“单个能力包”升级为“组织能力资产库”的方法。

前九个阶段已经解决：

```text
Skill 是什么
→ Skill 如何设计
→ Prompt 如何转 Skill
→ Workflow 如何工程化
→ 上下文如何管理
→ 脚本如何增强
→ 如何测试评估
→ 如何安全治理
→ 如何产品化
```

阶段十进一步解决：

```text
多个 Skill 如何组织？
Skill 如何分类？
团队 SOP、规范、模板、经验如何 Skill 化？
多个 Skill 如何协作而不冲突？
Skill 如何与 Agent、Tool、MCP、API、Eval 组成完整系统？
```

OpenAI ChatGPT Skills 将 Skills 定义为可复用、可共享的工作流，可用于让 ChatGPT 更一致地完成特定任务；OpenAI Codex Skills 将 Skill 描述为包含 `SKILL.md` 的目录，并可附带 scripts、references 和 assets，同时通过 progressive disclosure 管理上下文。Agent Skills 标准也强调，Agent 会先加载 Skill 的 `name` 和 `description`，再按需读取完整说明和资源。这些机制共同说明：Skill 不应只作为零散文件存在，而应被组织成可发现、可组合、可治理的能力库。

阶段十的核心观点：

> 单个 Skill 解决一个高频任务；Skill Library 解决一组高频任务的系统化复用；组织能力资产解决团队经验、流程、规范和工具能力的长期沉淀。

---

# 第 50 章：从单个 Skill 到 Skill Library

## 50.1 什么是 Skill Library

Skill Library 是多个 Skill 的集合，但它不是简单文件夹堆放。

一个真正的 Skill Library 应具备：

```text
分类体系
命名规范
目录结构
索引说明
Owner 机制
版本记录
测试标准
安全审查
使用说明
生命周期管理
```

可以把 Skill Library 理解为：

> 面向 Agent 的组织能力资产库。

单个 Skill 像一个“标准作业能力包”；Skill Library 像一个“组织能力操作系统”。

## 50.2 为什么需要 Skill Library

当 Skill 数量很少时，直接使用文件夹即可。但当 Skill 增多，会出现：

| 问题 | 表现 |
|---|---|
| 找不到 | 不知道已有哪个 Skill |
| 重复造 | 多个人写了相似 Skill |
| 冲突 | 两个 Skill 都适用于同一任务 |
| 过期 | 旧 Skill 继续被使用 |
| 无 owner | 出问题无人维护 |
| 难评估 | 不知道哪些可靠 |
| 难分发 | 不知道哪些适合团队共享 |
| 难治理 | 安全和权限无标准 |

Skill Library 的作用，是让 Skill 从“个人技巧”变成“可管理资产”。

## 50.3 Skill Library 的基本结构

推荐结构：

```text
skill-library/
├── README.md
├── INDEX.md
├── GOVERNANCE.md
├── CHANGELOG.md
├── content/
│   ├── llm-wiki-writer/
│   └── content-cleaner/
├── ecommerce/
│   ├── amazon-review-analyzer/
│   └── amazon-a-plus-copywriter/
├── design/
│   ├── visual-brief-generator/
│   └── ui-reviewer/
├── product/
│   ├── requirement-clarifier/
│   └── sdd-bdd-tdd-planner/
├── engineering/
│   ├── pr-reviewer/
│   └── test-case-generator/
├── governance/
│   ├── skill-security-reviewer/
│   └── skill-eval-runner/
└── archived/
    └── deprecated-skill/
```

## 50.4 Skill Library 必备文件

| 文件 | 作用 |
|---|---|
| `README.md` | 给人看的总说明 |
| `INDEX.md` | Skill 索引表 |
| `GOVERNANCE.md` | 创建、审查、发布、废弃规则 |
| `CHANGELOG.md` | Library 级变更记录 |
| 各 Skill 目录 | 存放具体 Skill |
| `archived/` | 存放废弃或归档 Skill |

## 50.5 INDEX.md 示例

```markdown
# Skill Library Index

| Category | Skill | Purpose | Owner | Status | Version |
|---|---|---|---|---|---|
| content | llm-wiki-writer | Convert conversations into neutral Markdown knowledge entries | Terry | Active | 1.2.0 |
| ecommerce | amazon-review-analyzer | Analyze product reviews for pain points and opportunities | Ops | MVP | 0.4.0 |
| design | visual-brief-generator | Convert selling points into visual briefs and prompts | Design | Active | 1.0.0 |
| governance | skill-security-reviewer | Review Skill files for security and governance risks | AI Ops | Draft | 0.1.0 |
```

INDEX 的价值是让人和 Agent 都能快速知道：

```text
有什么 Skill
每个 Skill 做什么
属于哪个分类
谁负责
当前状态
当前版本
```

## 50.6 Library 状态管理

建议为每个 Skill 标记状态：

| 状态 | 含义 |
|---|---|
| Draft | 草稿，未验证 |
| MVP | 最小可用，小范围试用 |
| Active | 正常使用 |
| Stable | 稳定版本，变更谨慎 |
| Deprecated | 不推荐新使用，有替代方案 |
| Archived | 已归档，停止维护 |
| Blocked | 因安全或质量问题禁用 |

## 50.7 单个 Skill 与 Library 的关系

| 单个 Skill | Skill Library |
|---|---|
| 解决一个任务 | 管理一组任务能力 |
| 关注执行流程 | 关注分类、治理和复用 |
| 由 owner 维护 | 由 Library owner / 管理机制维护 |
| 测试自身质量 | 管理跨 Skill 冲突和重叠 |
| 可独立分发 | 可作为组织能力资产沉淀 |

## 50.8 Skill Library 常见错误

| 错误 | 问题 | 修正 |
|---|---|---|
| 只有文件夹，没有索引 | 找不到 Skill | 建 INDEX.md |
| 只按作者分类 | 使用者不知道去哪找 | 按场景和能力分类 |
| 不标状态 | 旧 Skill 持续被用 | 标 Draft / Active / Deprecated |
| 无 owner | 无人维护 | 每个 Skill 指定 owner |
| 无治理文件 | 人人随意改 | 建 GOVERNANCE.md |
| 无归档机制 | Library 越来越脏 | 建 archived/ |
| Skill 名称不统一 | 难搜索 | 建命名规范 |

## 50.9 本章小结

Skill Library 的本质不是“很多 Skill 的集合”，而是“可发现、可使用、可治理、可演进的能力资产库”。

核心公式：

```text
分类 + 索引 + 状态 + Owner + 版本 + 测试 + 治理 + 归档
```

---

# 第 51 章：Skill 分类体系

## 51.1 为什么需要分类体系

当 Skill 数量增加后，分类决定了 Skill 是否容易被找到、复用和治理。

没有分类时，Skill Library 会变成：

```text
一堆名字相似的文件夹
重复功能无法识别
用户不知道该用哪个
管理员不知道该谁维护
Agent 选择时容易混淆
```

分类体系的目标是：

> 让 Skill 按业务场景、能力类型和使用对象组织起来。

## 51.2 分类原则

高质量分类应遵循以下原则：

| 原则 | 说明 |
|---|---|
| MECE | 分类之间尽量互斥，整体覆盖完整 |
| 场景优先 | 优先按真实使用场景分类 |
| 用户可理解 | 分类名称要让使用者看得懂 |
| 可扩展 | 后续增加 Skill 不需要推翻结构 |
| 可治理 | 每类 Skill 能指定 owner 或责任团队 |
| 不过度细分 | 分类太细会增加查找成本 |

## 51.3 推荐一级分类

适合通用 AI 工作流团队的一级分类：

| 一级分类 | 覆盖范围 |
|---|---|
| content | 内容生产、改写、清洁、知识沉淀 |
| data | 数据清洗、分析、可视化、结构化 |
| ecommerce | 电商运营、Review、Listing、广告、库存 |
| design | 视觉 brief、UI 审查、生图提示词、包装 |
| product | 需求澄清、PRD、SDD、BDD、TDD |
| engineering | 代码审查、测试生成、文档生成、脚本 |
| support | 客服回复、售后处理、用户沟通 |
| knowledge | 知识库、术语表、学习路线、课程沉淀 |
| governance | 安全审查、Eval、版本治理、权限检查 |
| automation | 多工具流程、API / MCP / Agent 协作 |

## 51.4 二级分类示例

以 `ecommerce/` 为例：

```text
ecommerce/
├── review-analysis/
├── listing-copy/
├── a-plus-content/
├── competitor-research/
├── inventory-planning/
├── customer-support/
└── compliance-check/
```

以 `design/` 为例：

```text
design/
├── visual-brief/
├── image-prompt/
├── ui-review/
├── a-plus-image/
├── packaging/
└── brand-style/
```

## 51.5 按能力类型分类

除了按业务场景，也可以按能力类型打标签。

常见标签：

| 标签 | 含义 |
|---|---|
| `writer` | 生成内容 |
| `reviewer` | 审查内容 |
| `analyzer` | 分析数据或材料 |
| `planner` | 制定计划 |
| `converter` | 格式转换 |
| `cleaner` | 清洗内容 |
| `validator` | 校验输出 |
| `generator` | 生成结构化产物 |
| `router` | 判断任务并分派 |
| `governor` | 治理和审查 |

示例：

```yaml
tags:
  - ecommerce
  - analyzer
  - review-analysis
  - product-insight
```

## 51.6 分类与命名的关系

分类解决“放在哪里”，命名解决“叫什么”。

例如：

```text
ecommerce/amazon-review-analyzer/
design/amazon-a-plus-visual-brief/
knowledge/llm-wiki-writer/
governance/skill-security-reviewer/
```

不要把所有信息都塞进名称。

不推荐：

```text
amazon-product-review-user-pain-point-positive-negative-feature-request-analysis-skill
```

推荐：

```text
ecommerce/amazon-review-analyzer
```

## 51.7 分类冲突处理

有些 Skill 可能跨领域。例如：

```text
amazon-a-plus-visual-brief
```

它既属于电商，也属于设计。

处理方式：

1. 以主要使用场景为主分类
2. 用 tags 表示次要属性
3. 在 INDEX 中交叉索引
4. 不复制 Skill 文件夹，避免多版本冲突

示例：

```markdown
| Skill | Primary Category | Tags |
|---|---|---|
| amazon-a-plus-visual-brief | design | ecommerce, amazon, image-prompt, visual-brief |
```

## 51.8 分类体系常见错误

| 错误 | 问题 | 修正 |
|---|---|---|
| 按作者分类 | 用户找不到能力 | 按场景分类 |
| 按技术分类过早 | 业务用户看不懂 | 业务分类优先 |
| 分类太细 | Library 难维护 | 保持 6–10 个一级类 |
| 一个 Skill 复制到多个类 | 版本冲突 | 用 tags 和索引 |
| 没有 archived | 过期 Skill 污染分类 | 建归档区 |
| 没有 governance 分类 | 治理能力分散 | 单独设治理类 |

## 51.9 本章小结

分类体系的目标不是“整理得漂亮”，而是降低查找、复用、维护和治理成本。

核心公式：

```text
一级按场景，二级按任务，标签按能力，索引做交叉。
```

---

# 第 52 章：组织知识 Skill 化

## 52.1 什么是组织知识 Skill 化

组织知识 Skill 化，是指把团队中原本分散的知识资产转化为 Agent 可调用的 Skill。

组织知识包括：

```text
SOP
业务规范
设计规范
文案风格
客服话术
产品经验
审查清单
测试标准
复盘结论
模板文件
培训材料
专家经验
```

Skill 化不是简单把这些资料放进 references，而是要把它们转成：

```text
触发条件
输入要求
执行步骤
输出契约
判断规则
边界约束
测试案例
维护机制
```

## 52.2 哪些组织知识适合 Skill 化

适合 Skill 化的组织知识通常具备：

| 特征 | 说明 |
|---|---|
| 高频使用 | 经常被问、被执行 |
| 流程稳定 | 有相对固定步骤 |
| 标准明确 | 有好坏判断 |
| 可复用 | 多人、多项目可用 |
| 容易出错 | 人工执行容易漏项 |
| 可训练新人 | 能降低新人上手成本 |
| 可沉淀案例 | 有正例、反例、边界案例 |

## 52.3 组织知识 Skill 化对象

| 知识类型 | Skill 化方向 |
|---|---|
| SOP | 转成 Process + Decision Logic |
| 规范 | 转成 Constraints + Quality Criteria |
| 模板 | 转成 assets |
| 案例 | 转成 references/examples.md |
| 审查清单 | 转成 validator / reviewer Skill |
| 复盘经验 | 转成 pitfalls + regression tests |
| 专家经验 | 转成判断规则和边界案例 |
| 培训材料 | 转成学习 Skill 或知识库 Skill |

## 52.4 SOP Skill 化

SOP 通常是给人看的，表达较模糊。

原 SOP：

```text
检查 A+ 图片是否突出卖点，画面是否清晰高级，文案是否有转化力。
```

Skill 化后：

```markdown
# Process

1. Identify the product, target audience, image size, and main selling point.
2. Check whether the visual hierarchy makes the product and core benefit clear within 3 seconds.
3. Verify that all claims are supported by provided product facts.
4. Review layout for text area, product placement, scene relevance, and visual clutter.
5. Mark each issue with severity, reason, and revision direction.
6. Output a structured review table.
```

模糊表达被转成可检查步骤。

## 52.5 规范 Skill 化

规范适合转成 Constraints 和 Quality Criteria。

原规范：

```text
知识库内容要中立、系统、完整，不要出现“你的问题”“我们聊到”。
```

Skill 化：

```markdown
# Quality Criteria

The output must:
- Use a neutral encyclopedia-style voice.
- Be reusable outside the original conversation.
- Include definition, boundaries, adjacent concepts, applications, pitfalls, and checklist when supported by source content.

# Constraints

Do not:
- Refer to the source as a conversation.
- Use phrases such as “your question,” “we discussed,” “as mentioned above.”
- Preserve temporary task-management instructions.
```

## 52.6 模板 Skill 化

模板不应直接塞进 `SKILL.md`，而应放进 `assets/`。

结构：

```text
llm-wiki-writer/
├── SKILL.md
└── assets/
    └── knowledge-entry-template.md
```

模板示例：

```markdown
# [Concept Name]

## Definition

## Knowledge Boundaries

## Adjacent Concepts

## Core Principles

## Application Scenarios

## Common Pitfalls

## Practical Checklist
```

`SKILL.md` 中写：

```markdown
Use `assets/knowledge-entry-template.md` when generating a full LLM Wiki entry.
```

## 52.7 案例 Skill 化

案例应分为：

| 类型 | 用途 |
|---|---|
| 正例 | 教 Agent 什么是好输出 |
| 反例 | 防止误触发或错误输出 |
| 边界案例 | 处理模糊场景 |
| 异常案例 | 处理缺失、冲突、风险 |
| 回归案例 | 防止旧问题复发 |

不要只沉淀成功案例。失败案例更有工程价值。

## 52.8 专家经验 Skill 化

专家经验通常是隐性知识。例如：

```text
领导汇报时，不能只说设计好看，要从开发工作量、后续延展、维护成本、物料复用来说服。
```

Skill 化后：

```markdown
# Decision Logic

When preparing leadership-facing design recommendations:
- Do not rely only on aesthetic preference.
- Translate the recommendation into business, development, maintenance, and scalability reasons.
- If recommending one option, compare it against alternatives using effort, consistency, reusability, and risk.
```

这就是把“经验判断”转成可执行规则。

## 52.9 组织知识 Skill 化流程

```text
1. 收集高频知识材料
2. 判断是否值得 Skill 化
3. 提取目标用户和场景
4. 拆解输入、流程、输出和边界
5. 把长知识放 references
6. 把模板放 assets
7. 把确定性操作放 scripts
8. 加入正例、反例、边界案例
9. 建测试集
10. 指定 owner 和版本
```

## 52.10 本章小结

组织知识 Skill 化的核心，是把“人知道但说不清的经验”变成“Agent 可调用、团队可复用、结果可评估的能力”。

核心公式：

```text
SOP → Process
规范 → Constraints
模板 → Assets
案例 → Examples / Tests
经验 → Decision Logic
复盘 → Regression Tests
```

---

# 第 53 章：多 Skill 协作

## 53.1 为什么需要多 Skill 协作

真实任务往往不是一个 Skill 能完全覆盖的。

例如：

```text
输入一个产品想法，完成从需求澄清到 SDD、BDD、TDD、AI 实现任务拆解。
```

可能涉及：

```text
requirement-clarifier
→ product-scope-planner
→ sdd-writer
→ bdd-scenario-writer
→ tdd-test-planner
→ implementation-task-splitter
→ review-checker
```

单个 Skill 解决局部任务，多 Skill 协作解决端到端流程。

## 53.2 多 Skill 协作的三种模式

| 模式 | 说明 | 示例 |
|---|---|---|
| 串行协作 | 一个 Skill 的输出作为下一个 Skill 的输入 | Review 分析 → A+ 文案 → 图片 brief |
| 并行协作 | 多个 Skill 从不同角度处理同一输入 | UI 方案同时做设计评审、开发工作量评估 |
| 主从协作 | 一个主 Skill 调度多个子 Skill | 产品需求总控 Skill 调用 SDD、BDD、TDD Skill |

## 53.3 串行协作

示例：Amazon 产品优化流程

```text
amazon-review-analyzer
→ product-opportunity-summarizer
→ amazon-a-plus-copywriter
→ amazon-a-plus-visual-brief
```

每个 Skill 的输出必须能被下一个 Skill 接收。

关键要求：

```text
输出格式稳定
字段命名一致
事实和推断分开
保留证据
不丢失边界
```

## 53.4 并行协作

示例：UI 方案评估

```text
ui-design-reviewer
ui-development-effort-estimator
brand-consistency-checker
user-age-fit-reviewer
```

多 Skill 输出后，由一个整合步骤合并：

```text
设计适配性
开发成本
品牌一致性
用户年龄适配
风险和建议
```

并行协作适合多维评估。

## 53.5 主从协作

主 Skill 负责规划和调度，子 Skill 负责专门任务。

示例：

```text
agile-product-delivery-planner/
├── requirement-clarifier
├── sdd-writer
├── bdd-writer
├── tdd-writer
└── sprint-reviewer
```

主 Skill 不应重复子 Skill 的全部规则，而应说明：

```text
什么时候调用哪个子 Skill
子 Skill 的输入是什么
子 Skill 的输出如何合并
冲突时谁优先
```

## 53.6 多 Skill 协作的接口契约

多 Skill 协作最重要的是接口。

每个 Skill 应说明：

```text
接收什么输入
输出什么结构
哪些字段是事实
哪些字段是推断
哪些字段可传给下一个 Skill
哪些限制必须保留
```

示例输出契约：

```markdown
## Output for Downstream Skills

Return:
- `product_facts`: Provided product facts only
- `customer_pain_points`: Evidence-backed review themes
- `inferred_opportunities`: Clearly marked inferences
- `unsupported_claims`: Claims that require validation
- `recommended_angles`: Copy or design angles that may be used downstream
```

## 53.7 防止多 Skill 冲突

多 Skill 协作常见冲突：

| 冲突类型 | 表现 | 解决 |
|---|---|---|
| 职责重叠 | 两个 Skill 都想处理同一任务 | 明确 Scope |
| 输出结构不一致 | 下游无法接收 | 定义 Output Contract |
| 边界冲突 | 一个保守，一个激进 | 定义优先级 |
| 事实丢失 | 下游把推断当事实 | 字段分层 |
| 触发冲突 | 多个 Skill 同时匹配 | description 加边界 |
| 版本不兼容 | 上游更新导致下游失效 | 版本和回归测试 |

## 53.8 多 Skill 协作优先级

推荐优先级：

```text
安全与事实边界
→ 用户明确目标
→ 主流程 Skill
→ 专业子 Skill
→ 风格偏好
```

示例：

```text
A+ 文案 Skill 希望强化转化，
但 Review 分析 Skill 标记某卖点证据不足。
```

处理：

```text
不能把证据不足的卖点写成确定事实。
应保留证据边界，并建议验证。
```

## 53.9 多 Skill 协作测试

多 Skill 协作必须做端到端测试。

测试内容：

```text
1. 上游输出是否符合下游输入要求
2. 下游是否保留上游边界
3. 多个 Skill 是否互相覆盖职责
4. 输出是否出现事实漂移
5. 端到端产物是否可用
6. 某个 Skill 更新后是否破坏链路
```

## 53.10 本章小结

多 Skill 协作的关键不是“让所有 Skill 都能用”，而是让它们职责清晰、接口稳定、边界一致。

核心公式：

```text
职责拆分 + 输入输出契约 + 边界传递 + 主从调度 + 端到端测试
```

---

# 第 54 章：Skill 与 Agent 系统协作

## 54.1 为什么要看系统协作

Skill 不是孤立存在的。真实 Agent 系统通常包含：

```text
Agent
Skill
Tool
API
MCP
RAG / Knowledge
Memory
Eval
Governance
Human-in-the-loop
```

单个 Skill 只解决“方法问题”。完整系统还要解决：

```text
谁来规划？
谁来调用工具？
谁来取数据？
谁来执行动作？
谁来校验结果？
谁来确认高风险操作？
谁来记录反馈？
```

## 54.2 Agent、Skill、Tool 的分工

| 组件 | 职责 |
|---|---|
| Agent | 理解目标、规划步骤、选择 Skill、调用工具 |
| Skill | 提供任务方法、流程、边界、输出标准 |
| Tool | 执行具体动作，如搜索、读文件、写表格、运行代码 |
| API | 与外部系统通信 |
| MCP | 标准化连接外部数据和工具 |
| RAG / Knowledge | 提供可检索知识 |
| Memory | 保留长期偏好和历史上下文 |
| Eval | 评估结果质量 |
| Governance | 管理权限、安全、版本和发布 |

一句话：

> Agent 负责调度，Skill 负责方法，Tool/API/MCP 负责动作，Eval/Governance 负责质量和风险。

## 54.3 Skill 在 Agent 系统中的位置

执行链路可以表示为：

```text
用户目标
→ Agent 判断任务
→ Agent 匹配 Skill
→ Skill 提供流程和边界
→ Agent 读取 references / assets
→ Agent 调用 Tool / API / MCP
→ scripts 处理确定性任务
→ Eval 检查输出
→ Human 审批高风险动作
→ 输出结果
```

## 54.4 Skill 与 Tool 的协作

Tool 能做动作，但不知道业务方法。

例如：

```text
Tool 能抓 Review。
Skill 决定 Review 应如何分类、如何判断证据、如何输出洞察。
```

如果只有 Tool，没有 Skill：

```text
拿到了数据，但分析维度不稳定。
```

如果只有 Skill，没有 Tool：

```text
知道怎么分析，但无法稳定获取或处理数据。
```

二者结合才形成可执行流程。

## 54.5 Skill 与 MCP 的协作

MCP 解决外部连接问题，Skill 解决任务方法问题。

| MCP 负责 | Skill 负责 |
|---|---|
| 连接数据库、文件系统、业务系统 | 决定什么时候查、查什么、如何解释 |
| 暴露工具能力 | 规定工具使用边界 |
| 提供统一接口 | 提供业务流程 |
| 返回数据 | 判断数据如何进入产物 |

示例：

```text
微信公众号热点收集 Skill：
- MCP/API 负责抓取文章、写入飞书多维表格
- Skill 负责关键词语义扩展、文章筛选规则、字段结构、摘要格式、去重规则、阅读优先级
```

## 54.6 Skill 与 RAG / Knowledge 的协作

RAG / Knowledge 提供内容，Skill 提供使用方法。

例如：

```text
Knowledge：品牌规范文档、产品参数表、客服话术库
Skill：规定何时读取、如何引用、哪些不能编造、输出什么格式
```

如果只有 Knowledge：

```text
Agent 可能读到了资料，但不知道如何稳定应用。
```

如果有 Skill：

```text
Agent 按规则读取资料，并按输出契约生成结果。
```

## 54.7 Skill 与 Memory 的协作

Memory 存长期偏好，Skill 存可复用方法。

| Memory | Skill |
|---|---|
| 用户偏好 | 任务方法 |
| 长期习惯 | 标准流程 |
| 个人风格 | 组织规范 |
| 可跨对话调用 | 可共享和版本化 |
| 粒度较小 | 结构化能力包 |

示例：

```text
Memory：用户偏好 LLM Wiki 用中立百科体，不要写“你的问题”。
Skill：llm-wiki-writer 中系统化规定知识条目结构、输入输出、边界和测试。
```

Memory 可以辅助 Skill 个性化，但不应替代 Skill。

## 54.8 Skill 与 Eval 的协作

Eval 是 Skill 的质量反馈机制。

```text
Skill 生成输出
→ Eval 检查触发、格式、边界、事实、资源使用
→ 失败案例进入 tests/regression.md
→ 修改 Skill
→ 再评估
```

没有 Eval，Skill 很容易变成“越改越乱”的经验堆。

## 54.9 Skill 与 Human-in-the-loop

高风险任务需要人工确认。

需要人工确认的场景：

```text
发送邮件
删除文件
提交订单
发布内容
修改生产数据
调用外部系统写操作
法律、医疗、财务等高风险结论
组织级权限变更
```

Skill 应明确：

```markdown
# Human Approval

Require user confirmation before:
- Sending external messages
- Deleting or overwriting files
- Making purchases
- Publishing public content
- Updating production systems
- Treating high-risk recommendations as final decisions
```

## 54.10 本章小结

Skill 不是完整 Agent 系统本身，而是 Agent 系统中的方法层。

核心公式：

```text
Agent 规划
+ Skill 方法
+ Tool 执行
+ MCP 连接
+ Knowledge 提供资料
+ Memory 保留偏好
+ Eval 评估质量
+ Governance 控制风险
+ Human 审批关键动作
```

---

# 阶段十总结

阶段十的核心结论：

1. **单个 Skill 是能力单元，Skill Library 是能力资产库。**  
   Library 需要分类、索引、状态、owner、版本、测试、治理和归档机制。

2. **分类体系决定 Skill 是否可发现、可复用、可治理。**  
   一级按场景，二级按任务，标签按能力，索引做交叉。

3. **组织知识 Skill 化是经验资产化。**  
   SOP 转 Process，规范转 Constraints，模板转 Assets，案例转 Examples/Tests，经验转 Decision Logic，复盘转 Regression Tests。

4. **多 Skill 协作需要接口契约。**  
   上下游 Skill 必须稳定传递事实、推断、边界和输出结构。

5. **Skill 是 Agent 系统中的方法层。**  
   Agent 负责规划，Skill 负责方法，Tool/API/MCP 负责动作，Eval/Governance 负责质量和风险。

阶段十最重要的一句话：

> Skill Library 的价值，不是保存很多 Skill，而是把组织中可重复、可验证、可治理的知识和流程沉淀为 Agent 可调用的能力资产。

---

# 阶段十掌握检查

完成阶段十后，应能回答：

1. Skill Library 和普通文件夹有什么区别？
2. Skill Library 为什么需要 INDEX.md？
3. 一个 Skill 应该有哪些状态？
4. Skill 分类体系为什么要优先按场景组织？
5. 组织知识 Skill 化时，SOP、规范、模板、案例、经验分别应该转成什么？
6. 多 Skill 协作有哪三种模式？
7. 多 Skill 协作为什么需要输入输出契约？
8. Skill 与 Agent、Tool、MCP、Knowledge、Memory、Eval 分别是什么关系？
9. 哪些动作需要 human-in-the-loop？
10. 如何判断一个团队是否真正形成了 Skill 能力资产？

---

# 可沉淀的最小方法论

```text
Skill Library 建设七步法：

1. 先定义分类：按场景建立一级分类，按任务建立二级分类
2. 建立索引：用 INDEX.md 管理 Skill 名称、用途、owner、状态、版本
3. 规范命名：对象 + 动作，避免过泛和重名
4. 组织知识 Skill 化：SOP、规范、模板、案例、经验、复盘分别沉淀
5. 设计协作接口：明确每个 Skill 的输入、输出、边界和下游用途
6. 建立治理：owner、测试、版本、安全审查、发布和归档
7. 系统集成：让 Skill 与 Agent、Tool、MCP、Knowledge、Memory、Eval 协同
```

---

# 推荐 Skill Library 目录结构

```text
skill-library/
├── README.md
├── INDEX.md
├── GOVERNANCE.md
├── CHANGELOG.md
├── content/
│   ├── llm-wiki-writer/
│   └── content-cleaner/
├── ecommerce/
│   ├── amazon-review-analyzer/
│   └── amazon-a-plus-copywriter/
├── design/
│   ├── visual-brief-generator/
│   └── ui-reviewer/
├── product/
│   ├── requirement-clarifier/
│   └── sdd-bdd-tdd-planner/
├── engineering/
│   ├── pr-reviewer/
│   └── test-case-generator/
├── governance/
│   ├── skill-security-reviewer/
│   └── skill-eval-runner/
└── archived/
    └── deprecated-skill/
```

---

# INDEX.md 模板

```markdown
# Skill Library Index

| Category | Skill | Purpose | Owner | Status | Version | Tags |
|---|---|---|---|---|---|---|
| content | llm-wiki-writer | Convert source content into neutral Markdown knowledge entries | Terry | Active | 1.2.0 | knowledge, writer |
| ecommerce | amazon-review-analyzer | Analyze product reviews for pain points and opportunities | Ops | MVP | 0.4.0 | amazon, review, analyzer |
| design | visual-brief-generator | Convert selling points into visual briefs and image prompts | Design | Active | 1.0.0 | design, prompt, brief |
```

---

# 参考依据

- OpenAI ChatGPT Skills：Skills 是可复用、可共享的工作流，可帮助 ChatGPT 更一致地完成特定任务，并可被创建、安装、分享和发布到工作区。
- OpenAI Codex Skills：Skill 是包含 `SKILL.md` 的目录，可附带 scripts、references、assets，并通过 progressive disclosure 管理上下文。
- Agent Skills Open Standard：Agent 通过 name、description 发现 Skill，再按需加载 instructions 和 resources。
- Anthropic Agent Skills：Skill 是包含 instructions、scripts 和 resources 的目录，用于让 Agent 在真实工作环境中执行专业任务。
- OpenAI Evals：通过测试集、评估器和实验记录改进 AI 系统行为，可作为 Skill Library 质量治理的参考。
