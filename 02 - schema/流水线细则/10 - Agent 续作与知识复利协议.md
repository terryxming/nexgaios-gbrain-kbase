---
knowledge_id: 'schema-a564f92e2513'
title: 'Agent 续作与知识复利协议'
knowledge_layer: 'schema'
lifecycle_status: 'active'
source: 'not_applicable：not_applicable'
captured_at: 'not_applicable'
domain: 'schema'
tags: []
wiki_page_type: 'not_applicable'
compile_status: 'not_applicable'
compiled_to: []
trust_level: 'canonical'
gbrain_db_sync_status: 'pending'
gbrain_db_sync_error: 'not_applicable'
memory_type: 'not_applicable'
continuity_db_status: 'not_applicable'
---

# Agent 续作与知识复利协议

版本：v0.1.1

生命周期：Draft

日期：2026-06-22

适用范围：Agent 新线程启动、长任务续作、任务交接、用户授权沉淀、相似信号召回、记忆退役、知识生命周期复核

## 1. 规则定位

本规则把 GBrain 的目标落到 Agent 可执行协议。

GBrain 的目标是：

> 人和 AI 持续变聪明的工作环境 + Agent 记忆大脑 + 个人和企业的知识复利资产库。

核心特点是：

1. 可沉淀：关键任务、经验、决策、错误和过程能够被记录。
2. 可追溯：后续使用时能核查来源、时间线、版本和适用边界。
3. 可演化：知识能够更新、替代、验证、过期和尘封。

本规则不替代 `06 - GBrain DB 同步与 MCP 查询规则.md`、`07 - Agent 回写闭环规则.md` 和 `09 - Agent 资料提炼与 raw 回写 SOP.md`。

本规则只回答五个调度问题：

1. Agent 新线程如何恢复连续性。
2. Agent 什么时候应该建议或执行任务交接。
3. 什么信息值得沉淀，沉淀成哪类记忆。
4. Agent 什么时候、在哪里、查什么、怎么判断资料能不能用。
5. working 记忆如何退役，并继续进入长期知识复利链路。

> [!important]
> `memory_type` 是记忆内容类型，不是生命周期状态。短期性、候选状态、已退役状态不得写成新的 `memory_type` 枚举。

## 2. 适用触发器

出现以下任一情况时，Agent 必须读取本规则：

1. 新线程启动。
2. 用户要求继续之前的任务。
3. 用户更换设备、线程或 Agent，但任务明显未结束。
4. 用户说“记下来”“保存一下”“做个交接”“下次继续”等授权性指令。
5. 长任务结束、暂停、阻塞或跨多文件 / 多工具执行后，Agent 判断存在续作风险。
6. 当前问题与历史错误、踩坑、决策、策略或案例可能相似。
7. Agent 准备按 schema、流程、项目背景或历史经验执行任务，但当前上下文不足。
8. 用户要求审查知识是否已经过期、冲突、被替代或仍可用于决策。

普通一次性问答可以不进入完整沉淀流程，但新线程仍必须执行 active continuity 探测。

## 3. 新线程启动协议

每个 Agent 新线程启动时，必须自动查询最近的 active continuity 记忆。

启动步骤：

1. 执行 active continuity 探测：查询 `continuity_db_status: active` 且 `memory_type: working` 的最近记录。
2. 识别当前任务域：项目名、用户目标、文件路径、工具名、错误信号、时间范围、相关关键词。
3. 判断 active continuity 是否与当前任务相关。
4. 若相关，输出启动摘要。
5. 若不相关，不注入为当前上下文，但可以说明存在其他 active continuity。
6. 若查不到 active continuity，继续执行当前请求，并说明没有找到可恢复交接。

启动摘要必须包含：

| 项目 | 要求 |
| --- | --- |
| 当前任务 | Agent 判断出的任务名称或目标。 |
| 命中资料 | active continuity、wiki、schema 或 raw 的路径 / slug / knowledge_id。 |
| 当前状态 | 正在做什么，做到哪里，下一步是什么。 |
| 风险边界 | 未验收、待确认、权限、安全或同步风险。 |
| 续作建议 | 建议先执行什么，暂缓什么。 |
| 不确定点 | 必须向用户确认的内容。 |

如果命中多个相似任务，Agent 不得自行假设其中一个就是当前任务，必须向用户说明候选项和判断依据。

## 4. 记忆类型协议

`memory_type` 使用 `01 - 知识入口与字段规则.md` v0.2.2 的内容类型轴。

| memory_type | 用途 | 典型材料 | 初始落点 |
| --- | --- | --- | --- |
| `working` | 当前工作状态、任务交接、续作上下文。 | 当前进度、下一步、阻塞、未闭环事项。 | DB continuity raw -> local raw inbox |
| `episodic` | 事件经验、项目经历、事故复盘、决策过程。 | 事故处置、历史案例、踩坑记录、复盘时间线。 | local raw inbox |
| `semantic` | 事实、概念、对象、定义和稳定结论。 | 北极星定义、对象说明、确认过的结论。 | local raw inbox 或 wiki candidate |
| `procedural` | 流程、SOP、规则和可复用操作方法。 | 操作手册、验收规则、检查清单、脚本执行契约。 | local raw inbox 或 schema Draft |
| `preference` | 用户偏好、协作习惯、表达风格和长期个人化设定。 | 用户明确偏好、长期工作方式、禁忌和风格。 | local raw inbox |
| `not_applicable` | 当前材料不适用记忆内容类型判断。 | 普通 schema 文件、模板自身。 | 当前层级 |
| `unknown` | 理论上应该判断但当前无法判断。 | 字段缺失或语义不足的材料。 | 阻断后续自动路由 |

`working` 解决连续性，不等于长期知识。

`episodic` 是长期记忆的一种内容类型，用于记录具体时间线、参与者、原因、动作和结果。

`semantic` 与 `procedural` 是长期复利资产的主要稳定形态。

## 5. 任务交接协议

任务交接用于解决跨设备、跨线程、跨 Agent 的记忆断裂。

### 5.1 用户授权触发

当用户明确说“这个记下来”“保存一下”“做个交接”“下次继续”“写进 GBrain”等指令时，Agent 必须启动交接沉淀。

用户授权是最高优先级。

### 5.2 Agent 建议触发

当出现以下情况时，Agent 应该建议用户保存任务交接：

1. 任务超过一个会话仍未完成。
2. 已发生 Git 提交、DB 同步、脚本修复、结构性决策或重要排错。
3. 存在明确下一步但当前线程即将结束。
4. 任务有未解决阻塞、风险或外部依赖。
5. 后续切换设备或 Agent 后，缺少交接会明显增加重复劳动或误操作风险。

Agent 建议时必须说明保存理由，并等待用户确认。

### 5.3 写入链路

任务交接必须走双落点：

```text
Agent 授权回写
-> DB continuity raw 写入
-> local 00 - raw/00 - inbox 物化
-> inbox 字段修复与路由
-> raw / wiki / schema 生产线
```

本地物化文件的 frontmatter 至少满足：

```yaml
knowledge_layer: 'raw'
lifecycle_status: 'inbox'
gbrain_db_sync_status: 'excluded'
memory_type: 'working'
continuity_db_status: 'active'
```

如果 DB continuity raw 写入失败，不得报告“已保存交接”。

如果本地物化失败，不得报告“知识生产线已接收”。

### 5.4 交接正文契约

正文至少包含：

1. 任务目标。
2. 当前状态。
3. 已完成事项。
4. 未完成事项。
5. 阻塞点。
6. 下一步建议。
7. 关键文件、slug、commit、分支、脚本或 DB source。
8. 关键决策和理由。
9. 相关规则或验收标准。
10. 恢复方式：下次 Agent 应该先查什么、从哪里继续。
11. 验收状态：已验收、未验收、部分验收或无法验收。
12. 时间线。

建议正文类型标识：

```text
material_role: task_state
```

建议标签：

```text
task-state
handoff
项目名或领域名
```

这些标识写在正文或 tags 中，不新增 frontmatter 字段。

## 6. working 退役协议

`working` 记忆是续作入口，不是终态。

一条 `working` 记忆的正常生命周期是：

```text
DB continuity raw: active
-> local raw inbox: working + active
-> raw 路由与编译
-> wiki / schema / raw 领域产物承接当前状态
-> DB continuity raw: superseded
-> local raw: continuity_db_status: superseded
```

触发退役的条件：

| 条件 | 处理 |
| --- | --- |
| 任务已闭环且用户确认无需续作 | 标记为 `superseded`。 |
| 已生成新的 active working 交接 | 旧 working 标记为 `superseded`。 |
| 已编译为 active wiki，且 wiki 承载当前状态 / 结论 / 下一步 | 原 working 标记为 `superseded`。 |
| 用户明确废弃该任务 | 标记为 `superseded`，正文写明废弃原因。 |
| DB 写入或本地物化失败 | 标记为 `failed`，进入补偿队列或人工处理。 |

退役信息不得新增 frontmatter 字段。

退役详情写入正文 `连续性处置记录`，或写入 DB continuity raw 的运行层 metadata。

建议结构：

```markdown
## 连续性处置记录

| 字段 | 值 |
| --- | --- |
| continuity_status | active / superseded / failed |
| superseded_at |  |
| superseded_by |  |
| superseded_reason |  |
| operator |  |
```

新线程自动查询时，只能把 `continuity_db_status: active` 的 `working` 记忆当作当前续作候选。

已经 `superseded` 的 working 记忆只能作为历史追溯材料，不得作为当前任务状态。

## 7. 沉淀判定协议

“什么值得沉淀”的第一优先级是用户授权。

当用户未明确授权时，Agent 可以基于当前上下文提出沉淀建议，但必须说明理由并等待用户复核。

建议沉淀的判断标准：

1. 未来可能重复出现。
2. 包含明确决策、取舍或边界。
3. 记录了错误、踩坑、修复过程或失败原因。
4. 能帮助下一个 Agent 像熟悉项目的老员工一样工作。
5. 能解释某次结果为什么发生，而不只是记录结论。
6. 包含可核查来源、文件、时间线、版本或命令输出。
7. 对个人或企业知识资产有长期复用价值。

Agent 建议沉淀时，必须同时说明建议沉淀成哪类记忆、落到哪里：

| 材料角色 | memory_type | 用途 | 初始落点 |
| --- | --- | --- | --- |
| `task_state` | `working` | 续作、交接、当前任务状态。 | DB continuity raw -> raw inbox |
| `case_log` | `episodic` | 相似事件、错误、处置过程、最终结果。 | raw inbox |
| `decision_log` | `episodic` | 决策、取舍、反对理由、适用边界。 | raw inbox |
| `concept_note` | `semantic` | 概念、事实、定义、对象、结论。 | raw inbox |
| `process_note` | `procedural` | 流程技巧、操作经验、检查清单。 | raw inbox |
| `preference_note` | `preference` | 用户偏好、协作习惯和长期个性化信息。 | raw inbox |
| `schema_draft` | `procedural` | 需要改变规则、流程或字段契约。 | schema Draft |

除用户明确授权外，Agent 不得静默把对话内容写入知识库。

## 8. 查询使用协议

Agent 必须区分三类查询：

| 查询类型 | 触发条件 | 优先来源 | 使用边界 |
| --- | --- | --- | --- |
| active continuity 探测 | 每个新线程启动。 | DB continuity raw 中 `working + active`。 | 只用于续作候选，不等于正式知识。 |
| 正式知识查询 | 需要规则、结论、流程、对象或已验收知识。 | formal GBrain DB 中 synced wiki / schema。 | 默认可信，但仍检查版本和适用范围。 |
| 未验证材料查询 | 需要查近期 raw、待编译材料或历史线索。 | raw inbox / raw pending / candidate。 | 必须标注未验证、未编译或待确认。 |

Agent 不是每次都查全库，但在以下场景必须查询正式知识或未验证材料：

1. 当前任务需要按 GBrain schema、SOP、项目背景或历史决策执行。
2. Agent 准备修改知识库规则、同步 DB、执行回写或变更生命周期。
3. 当前问题和过去的错误、踩坑、策略、结果可能相似。
4. Agent 对流程边界、文件状态、版本、来源或验收标准不确定。
5. 用户询问“以前怎么处理”“上次做到哪了”“这个规则是什么”。

查询词应包含至少两类信号：

1. 项目或领域。
2. 任务名、错误信号、文件路径、命令、slug、规则名、时间范围或关键词。

资料可用性判断必须检查：

1. `knowledge_layer`。
2. `lifecycle_status`。
3. `trust_level`。
4. `compile_status`。
5. `gbrain_db_sync_status`。
6. `memory_type`。
7. `continuity_db_status`。
8. 来源、时间、版本和是否被替代。

命中 raw、candidate、deprecated、failed、pending、unknown 或 superseded 状态资料时，Agent 必须在回答中标注状态，不能把它们当作正式结论。

## 9. 相似信号召回协议

当当前事件与历史事件相似时，Agent 应主动检索历史 `episodic` 记忆、任务状态和决策记录。

输出至少包含：

1. 命中的历史资料。
2. 相似依据。
3. 历史处置策略。
4. 历史最终结果。
5. 当前事件与历史事件的关键差异。
6. 可复用部分。
7. 不可复用或需要重新验证的部分。
8. 置信度。

Agent 不得因为历史方案成功，就直接套用到当前任务。

如果相似性只来自关键词而缺少机制性证据，必须标注为低置信度。

## 10. 老员工工作协议

Agent 执行 GBrain 相关任务时，不应只根据当前用户消息机械行动。

Agent 需要结合：

1. 用户当前授权。
2. 项目目标。
3. 当前任务状态。
4. 相关规则。
5. 历史决策。
6. 风险边界。
7. 验收标准。
8. active continuity 探测结果。

但 Agent 也不得用“老员工判断”替代用户决策。

需要用户价值判断、业务判断、授权写入或高风险操作时，必须停下确认。

## 11. 时间线与版本协议

信息需要能够演化。

当 raw、wiki 或 schema 页面记录的是任务状态、决策、案例、流程或规则演化时，正文应包含以下结构中的相关部分：

```markdown
## 当前状态

## 时间线

## 版本记录

## 替代关系

## 连续性处置记录

## 待验证问题
```

正文状态可以使用：

| 状态 | 含义 |
| --- | --- |
| 待验证 | 有价值但尚未被验证。 |
| 已验证 | 已通过执行或证据核查。 |
| 可决策 | 可以作为当前决策依据。 |
| 冲突 | 与其他资料或现实状态不一致。 |
| 已过期 | 时间、外部环境或依赖变化导致失效。 |
| 已替代 | 被新版本、新规则或新页面替代。 |
| 已尘封 | 保留历史追溯价值，但不再用于当前决策。 |

这些状态写在正文表格或章节中，不新增 frontmatter 字段。

frontmatter 只允许 `01 - 知识入口与字段规则.md` 定义的 16 个字段。

## 12. 生命周期健康检查

Agent 在维护知识库时，应主动识别以下风险：

1. 长期未编译但频繁被引用的 raw。
2. 长期 pending、failed 或 partial_failed 的同步和回写材料。
3. 已过期但仍被当作 active 使用的 wiki。
4. 有新版本但旧版本未标注替代关系的规则或页面。
5. 未完成的 `working` 记忆长期没有后续。
6. active continuity 已被 wiki 或新 working 记忆承接，但未标记 `superseded`。
7. 相似 case 的最终结果缺失。
8. 用户已经修正观点，但旧观点仍被当作当前结论。

第一版健康检查由 Agent 人工执行并在完成汇报中说明证据。

自动化脚本实现前，不得声称已经自动扫描全库生命周期。

## 13. 与既有规则关系

| 规则 | 职责 |
| --- | --- |
| 01 | 决定 frontmatter 字段、`memory_type` 与 `continuity_db_status` 枚举。 |
| 06 | 决定正式 GBrain DB 如何同步，以及 MCP 查询结果如何按层级使用。 |
| 07 | 决定 Agent 回写在用户授权、安全门禁、DB continuity raw 和本地物化上的闭环。 |
| 09 | 决定 Agent 资料如何提炼成高质量 raw。 |
| 10 | 决定 Agent 什么时候续作、什么时候交接、什么时候建议沉淀、什么时候查历史、怎么让知识持续复利。 |

如果本规则触发沉淀或回写，必须继续执行 07 和 09。

如果本规则触发查询，必须继续执行 06。

如果本规则触发 schema 变更，必须继续执行 08。

## 14. 禁止项

1. 禁止在新线程中跳过 active continuity 探测。
2. 禁止在续作任务中不检查任务状态就直接执行。
3. 禁止未经用户授权静默写入知识库。
4. 禁止把 raw、candidate、deprecated、failed、pending、unknown 或 superseded 资料伪装成正式结论。
5. 禁止只记录结论，不记录时间线、依据、版本和适用边界。
6. 禁止把旧 working 记忆当作当前状态，除非已核查 `continuity_db_status: active`。
7. 禁止把正文生命周期状态写入 frontmatter 扩展字段。
8. 禁止用历史成功经验替代当前验证。
9. 禁止在自动化脚本尚未实现前声称全库生命周期已自动治理。
