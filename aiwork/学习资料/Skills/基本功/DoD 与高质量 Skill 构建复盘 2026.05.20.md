# DoD 与高质量 Skill 构建复盘

生成日期：2026-05-20

## 1. 背景问题

本轮讨论从一个具体质量疑问开始：

> `report-contract.md` 写得很严，但 `validate_reverse_artifacts.py` 没有完全落实。

这个现象暴露出的核心问题不是“有没有写规则”，而是：

> 自然语言契约如果没有被翻译成可验证的完成定义、验证矩阵、正反例样本和人工检查项，就容易出现“文档很严，落实半截”。

本轮最终形成的判断是：

- 用户通常会提出目标，但不会天然知道如何定义完整质量标准。
- Agent 不应只执行显式请求，还应主动把用户目标翻译成可验证标准。
- `skill-creator` 本身有基础框架，但没有强制 agent 在创建 skill 前先产出 DoD 和 contract-to-validation matrix。
- 这个缺口会导致 skill 看似结构完整，但质量门禁不强。

## 2. DoD 是什么

DoD 是 **Definition of Done**，中文可译为“完成定义”。

它回答的问题是：

> 满足哪些明确、可检查的条件后，我们才允许说这件事完成了？

DoD 不是计划，也不是普通任务清单。它是一组完成前必须满足的质量标准。

在 Scrum Guide 中，Definition of Done 被定义为 Increment 达到产品所需质量度量时的正式状态描述，并用于让所有人对已完成工作形成共享理解。Scrum Guide 还明确指出，不满足 DoD 的工作不能被视为 Increment 的一部分。

Agile Alliance 的 glossary 也把 Definition of Done 描述为团队同意并显式展示的一组 criteria；这些 criteria 必须满足后，产品增量或 user story 才能被认为 done。

## 3. DoD 有什么用

DoD 的主要价值是把“完成”从主观感受变成可检查的共同标准。

它至少有六个作用：

1. 防止“看起来完成”的完成幻觉。
2. 把模糊目标翻译成可验证标准。
3. 让用户、agent、脚本、评审者使用同一把尺。
4. 暴露风险、边界、未完成项和残留假设。
5. 限制返工成本，减少“你以为完成了，但我以为还没完成”的误解。
6. 支撑后续复盘：失败时可以判断是目标没定义好，还是执行没有达标。

迁移到 agent / skill 场景后，DoD 可以理解为：

> 一个 agent 产物在被宣布完成前，必须满足的结果、验证、反例、边界和证据标准。

注意：这是对敏捷 DoD 概念的工程迁移，不是 Scrum Guide 原文直接规定。

## 4. 为什么用户不会自然给出 DoD

用户通常更容易表达目标，而不是质量系统。

例如用户会说：

- “帮我创建一个 skill。”
- “帮我逆向这个 agent。”
- “把这个流程沉淀成知识库。”

但用户通常不会自然补充：

- 哪些规则必须自动验证。
- 哪些规则可以人工检查。
- 哪些坏样本必须失败。
- 哪些输出必须有结构化 schema。
- 哪些结论必须绑定证据。
- 哪些未覆盖项必须显式声明。

因此，高质量 DoD 不应该完全由用户给出。更合理的协作模式是：

> 用户提供目标，agent 主动草拟 DoD，用户确认或修正。

这不是替用户做主，而是把用户想要的结果翻译成可检查的质量标准。

## 5. 为什么 Agent 也常常没有主动补 DoD

以下判断属于本轮案例基础上的推断，而不是有统计证据支持的普遍事实。

Agent 没有主动补 DoD，常见可能原因包括：

1. **显式请求偏置**
   Agent 容易优先完成用户直接说出的任务，例如“创建 skill”“写文件”“跑验证”，而不是主动补充用户没有说出的质量门禁。

2. **结构完成幻觉**
   当目录中已经有 `SKILL.md`、`references/`、`scripts/`、`assets/` 时，agent 容易把“结构完整”误认为“质量完整”。

3. **自然语言契约幻觉**
   文档写得越严谨，越容易让人误以为执行层也已经严谨。但实际上，规则只有进入 validator、fixture 或 manual gate 后，才真正进入质量系统。

4. **缺少强制 checkpoint**
   如果流程没有要求“先输出 DoD，再开始实现”，agent 往往会直接进入产物构建。

5. **验证定义过窄**
   基础验证通常只检查 frontmatter、命名、字段存在、脚本语法等问题，不一定检查语义质量、反例失败、视觉行为和证据链完整性。

更准确的说法是：

> 在本案例中，agent 没有把“先生成 DoD / 验证矩阵”作为创建 skill 的前置步骤。这不是用户的问题，而是流程没有强制 agent 主动补齐质量门禁。

## 6. 本案例暴露的问题：文档契约与验证实现脱节

`skill-reverse-engineering` 的 `report-contract.md` 定义了较严格的输出契约，包括：

- 输出目录和文件命名。
- `reverse-data` schema。
- `execution-trace` schema。
- `execution-review` schema。
- 主报告结构。
- 术语索引。
- HTML quality gates。
- sensitive redaction gates。
- validation duties。

`validate_reverse_artifacts.py` 也确实实现了一部分验证能力，包括：

- schema 字段存在性。
- 关键报告字段非空。
- evidence id 收集。
- evidence_refs 引用检查。
- score 范围检查。
- terminology 字段检查。
- HTML 锚点和部分质量标记检查。
- 常见 token / secret / 高熵字符串扫描。
- 文件命名检查。
- generated artifacts 存在性检查。
- execution trace 和 execution review 基础检查。

但问题在于：契约中仍有一些规则没有完全落到自动验证层。

典型差距包括：

| Contract 要求 | 当前验证覆盖 | 缺口 |
|---|---|---|
| 术语解释必须包含“是什么 / 有什么用 / 边界是什么” | 只检查 terminology 列表和字段存在 | 没有验证解释内容是否真的包含三部分 |
| 英文术语首次出现时添加锚点 | 只检查 HTML 中有 `id="terminology"` | 没有验证首次出现位置和双向锚点完整性 |
| HTML 表格可读、正文宽度受控、长 URL 自动换行 | 只检查少量 CSS/HTML 标记 | 没有视觉/布局级验证 |
| 无外部 CDN、可离线打开 | 部分可通过字符串或链接扫描验证 | 没有形成完整外链扫描规则 |
| 敏感信息允许已脱敏且 trace 记录处理方式 | 有 secret 扫描 | 没有把“脱敏例外”和 `sensitive_redaction_log` 严格联动 |
| 内容不存在时必须说明原因并提供证据 | 检查部分字段非空 | 没有验证“不存在说明 + 原因 + 证据引用”的语义完整性 |

因此，本案例的问题不是“没有 validator”，而是：

> 没有一张 contract-to-validation matrix 来确保每条规则都有对应的验证方式、反例样本或人工 gate。

## 7. 高质量 Skill 不只是文件结构，而是质量闭环

`skill-creator` 已经提供了高质量 skill 的基础框架：

- `SKILL.md`
- YAML frontmatter
- description 触发机制
- `agents/openai.yaml`
- `scripts/`
- `references/`
- `assets/`
- 渐进披露
- quick validation
- forward-testing
- 根据任务脆弱度设置自由度

所以，本轮问题不是“skill-creator 完全没有框架”。

更准确的问题是：

> 这个框架没有强制 agent 在创建或更新 skill 前，先把用户目标转成可验证 DoD。

换句话说，skill 的结构层是有的，但质量闭环层还不够强。

一个高质量 skill 至少应该包含三层：

1. **结构层**
   文件、目录、frontmatter、description、references、scripts、assets。

2. **行为层**
   触发条件、工作流、分支决策、异常处理、输出契约。

3. **质量层**
   DoD、验证矩阵、正例、反例、manual gates、残留风险声明。

缺少第三层时，skill 仍然可能“能用”，但不一定可靠、可审计、可复用。

## 8. 改进后的 Skill 创建流程

建议将创建或更新 skill 的流程调整为：

1. 明确用户目标。
2. Agent 主动草拟 DoD。
3. 用户确认或修正 DoD。
4. 根据 DoD 设计 skill 框架。
5. 将复杂知识沉入 `references/`。
6. 将重复、脆弱、需要确定性的动作沉入 `scripts/`。
7. 将模板、样例、静态资源沉入 `assets/`。
8. 建立 contract-to-validation matrix。
9. 准备正例 fixture。
10. 准备反例 fixture。
11. 运行基础结构验证。
12. 运行功能验证。
13. 运行反例验证。
14. 对无法自动验证的规则执行 manual gates。
15. 明确未覆盖规则和残留风险。

这个流程的关键变化是：

> 在写 skill 之前，先定义什么叫完成。

## 9. 推荐的 Skill DoD 模板

创建或更新 skill 前，agent 应先输出以下 DoD 草案：

```text
本 skill 只有在满足以下条件后，才可以声明完成：

1. 触发条件明确：
   - description 覆盖主要用户表达方式。
   - 不适用场景不会误触发。

2. 工作流明确：
   - 用户输入如何处理。
   - 如何分类。
   - 如何选择分支。
   - 如何处理异常。

3. 输出契约明确：
   - 输出文件、字段、格式、目录、命名规则清楚。
   - 必需字段和可选字段区分清楚。

4. 资源分层合理：
   - 稳定重复逻辑进入 scripts。
   - 长知识进入 references。
   - 模板和静态资源进入 assets。

5. 验证闭环完整：
   - contract 中每条规则映射到 validator、fixture 或 manual gate。
   - 至少有一个正例通过。
   - 至少有一个反例失败。

6. 证据链完整：
   - 评分、判断、建议有证据引用。
   - 推断和观点不伪装成事实。

7. 残留风险明确：
   - 不能自动验证的规则列出原因。
   - 后续改进项明确。
```

## 10. Contract-to-Validation Matrix 模板

建议每个复杂 skill 都维护一张验证矩阵：

| Contract 规则 | 验证方式 | 对应脚本/函数 | 正例 fixture | 反例 fixture | Manual gate | 状态 |
|---|---|---|---|---|---|---|
| 必需字段存在 | 自动 | `validate_schema` | 有完整字段的 JSON | 缺字段 JSON | 无 | 已覆盖 |
| evidence_refs 必须引用已有 evidence id | 自动 | `validate_evidence_refs` | 引用已存在 id | 引用不存在 id | 无 | 已覆盖 |
| 术语解释包含是什么/有什么用/边界 | 人工或 LLM 审计 | 暂无 | 解释完整样本 | 只写一句空泛解释 | 需要人工检查 | 未自动覆盖 |
| HTML 可离线打开且无 CDN | 自动 + 人工 | 待补外链扫描 | 无外链 HTML | 含 CDN HTML | 浏览器打开检查 | 部分覆盖 |
| 敏感信息已脱敏且 trace 记录 | 自动 + 人工 | 待补 trace 联动 | 脱敏并记录 | 泄露 token 或无记录 | 审查 redaction log | 部分覆盖 |

这张表的作用是让团队看到：

- 哪些规则真的被验证了。
- 哪些只是写在文档里。
- 哪些需要人工判断。
- 哪些需要后续补 validator。

## 11. 证据与结论分级

本轮讨论中，应区分四类结论：

| 类型 | 示例 | 证据要求 |
|---|---|---|
| 外部事实 | DoD 在 Scrum / Agile 中的定义和作用 | 绑定 Scrum Guide / Agile Alliance |
| 本案例事实 | `report-contract.md` 有严格 validation duties，validator 实现了部分函数 | 绑定 GitHub 文件或本地文件 |
| 推断 | Agent 容易跳过 DoD，因为流程没有强制 checkpoint | 标注为推断，说明依据 |
| 观点 | 高质量 skill 必须先生成 DoD | 标注为方法论建议 |

建议知识库中所有类似结论都遵守：

> 事实绑定证据，推断说明依据，观点明确标注。

## 12. 本轮回答质量审计结论

本轮前几次回答方向基本正确，但存在质量漏洞：

1. 没有一开始就把事实、推断、观点分开。
2. 对“agent 通常不主动补 DoD”的说法缺少统计证据，应标为推断。
3. 对 `skill-creator` 的评价容易让人误解为“它没有框架”，更准确是“它有基础框架，但没有强制 DoD 前置 gate”。
4. 对 `report-contract.md` 与 validator 的差距判断是成立的，但应使用 matrix 逐条证明。

修正后的结论是：

> DoD 是一种共享、显式、可检查的完成标准。这个概念有敏捷来源；迁移到 agent / skill 场景是一种工程类比。本案例真正暴露的问题不是没有 skill 框架，而是没有强制 agent 在创建 skill 前产出 DoD 和契约-验证映射。因此，bug 不主要在用户，而在 agent 执行流程没有主动补齐用户想不到的质量门禁。

## 13. 可复用检查清单

创建或更新复杂 skill 前，先检查：

- [ ] 是否先写出用户目标？
- [ ] 是否由 agent 主动草拟 DoD？
- [ ] DoD 是否经用户确认或修正？
- [ ] 是否有输出契约？
- [ ] 契约是否逐条映射到验证方式？
- [ ] 是否区分自动验证、人工验证和暂不验证？
- [ ] 是否有正例 fixture？
- [ ] 是否有反例 fixture？
- [ ] 反例是否真的失败？
- [ ] 是否有 evidence_refs 或等价证据链？
- [ ] 推断和观点是否明确标注？
- [ ] 是否列出未覆盖项和残留风险？

## 14. 证据源

### 外部来源

- Scrum Guide, 2020 Scrum Guide, `Commitment: Definition of Done`：https://scrumguides.org/scrum-guide.html
- Agile Alliance, `Definition of Done` glossary：https://agilealliance.org/glossary/definition-of-done/

### 本地 / 项目来源

- `skill-creator` 本地说明：`C:/Users/terry/.codex/skills/.system/skill-creator/SKILL.md`
  - Core Principles
  - Set Appropriate Degrees of Freedom
  - Protect Validation Integrity
  - Anatomy of a Skill
  - Progressive Disclosure Design Principle
  - Skill Creation Process
  - Validate the Skill
  - Forward-testing

- `skill-reverse-engineering` 发布版：
  - `SKILL.md`：https://github.com/terryxming/skill-reverse-engineering/blob/V0.1.0/SKILL.md
  - `report-contract.md`：https://github.com/terryxming/skill-reverse-engineering/blob/V0.1.0/references/report-contract.md
  - `validate_reverse_artifacts.py`：https://github.com/terryxming/skill-reverse-engineering/blob/V0.1.0/scripts/validate_reverse_artifacts.py

## 15. 一句话沉淀

> 高质量 skill 的关键不是把文件结构搭完整，而是让用户目标先变成 DoD，再让 DoD 逐条落到契约、验证、反例和人工 gate 中。
