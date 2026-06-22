---
knowledge_id: 'schema-9e267d6b36a3'
title: 'Agent 资料提炼与 raw 回写 SOP'
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

# Agent 资料提炼与 raw 回写 SOP

版本：v0.2.0

生命周期：Draft

日期：2026-06-22

适用范围：Agent 处理外部资料、对话结论、经验教训、业务判断、任务交接、截图表格和用户授权沉淀内容时的提炼、回写、物化、验证和完成汇报。

> [!important] 本规则的定位
> `09` 只规定：获准回写后，Agent 如何把材料整理成可生产的 raw 入口材料。
> 授权判定以 `07 - Agent 回写闭环规则.md` 为准；续作、召回和复利判断以 `10 - Agent 续作与知识复利协议.md` 为准；字段枚举以 `01 - 知识入口与字段规则.md` 为准。

## 1. 规则目标

Agent 回写不是保存聊天记录，而是把有复用价值的信息整理成可检索、可复核、可编辑、可演化的知识资产。

本 SOP 要解决四个工程问题：

| 问题 | 本规则的处理方式 |
| --- | --- |
| Agent 跨线程失忆 | Agent 来源的回写先写入 DB runtime raw，再物化到本地 raw inbox。 |
| 本地生产线被绕过 | 所有材料一旦落到本地，都必须从 `00 - raw/00 - inbox` 进入知识生产主线。 |
| 正式 DB 同步语义混乱 | `gbrain_db_sync_status` 只表达 GitHub / formal GBrain DB 同步，不表达 runtime raw 是否已写。 |
| 回写内容不可读 | Markdown 必须同时服务机器字段和用户阅读，不能只堆文本。 |

## 2. 三类入口的前端分流

三类来源在进入本地 raw inbox 之前不同；进入本地 raw inbox 之后合并为同一条生产线。

```mermaid
flowchart TD
  A[Agent 授权回写] --> B[写入 DB runtime raw]
  B --> C[物化同一知识对象到本地 raw inbox]
  U[用户手写] --> C
  O[Obsidian 剪藏] --> C
  C --> D[inbox 接收与字段修复]
  D --> E[inbox 路由分发]
  E --> F[领域 raw]
  F --> G[wiki candidate]
  G --> H[wiki active]
  H --> I[GitHub 知识库同步]
  I --> J[formal GBrain DB 同步]
  J --> K[MCP 查询和 Agent 使用]
```

入口契约：

| 来源 | 进入本地 raw inbox 前 | 本地 raw inbox frontmatter | 说明 |
| --- | --- | --- | --- |
| Agent 授权回写 | 先写 DB runtime raw，用于跨线程连续性和即时可查。 | `gbrain_db_sync_status: excluded`；`continuity_db_status` 按 DB runtime raw 状态写入。 | runtime raw 不是 formal DB 同步。 |
| 用户手写 | 直接进入本地 `00 - raw/00 - inbox`。 | `gbrain_db_sync_status: excluded`；`continuity_db_status: not_applicable`。 | 不生成 DB runtime raw。 |
| Obsidian 剪藏 | 直接进入本地 `00 - raw/00 - inbox`。 | `gbrain_db_sync_status: excluded`；`continuity_db_status: not_applicable`。 | 不生成 DB runtime raw。 |

> [!warning] 禁止混用
> `DB runtime raw 已写入` 不等于 `formal GBrain DB 已同步`。
> raw inbox 文件在正式生产线通过 GitHub / formal sync 之前，`gbrain_db_sync_status` 不得写成 `synced`。

## 3. 回写对象分类

Agent 必须先判断要沉淀的对象类型，再组织正文。

| 对象类型 | `memory_type` | 典型内容 | 默认用途 |
| --- | --- | --- | --- |
| 当前任务交接 / 续作检查点 | `working` | 当前目标、进度、下一步、阻断、用户确认点。 | 新线程 active continuity 探测。 |
| 事故、项目、决策过程、踩坑案例 | `episodic` | 某次事件发生了什么、如何处置、最终结果。 | 相似信号召回和复盘。 |
| 事实、概念、对象、定义、已确认结论 | `semantic` | 北极星定义、对象说明、概念边界。 | 知识查询和长期复用。 |
| SOP、流程、规则、操作方法 | `procedural` | 检查清单、执行步骤、质量闸门。 | 老员工式执行。 |
| 用户偏好、协作习惯、表达要求 | `preference` | 用户希望怎样被协作、怎样写文档。 | 个性化协作约束。 |

`working` 是续作入口，不是长期知识终态。一个 `working` 材料被 wiki、schema、领域 raw 或新的 `working` 承接后，应按 `10` 标记为 `superseded`。

## 4. 授权边界

本 SOP 不单独授予 Agent 写入权限。

Agent 只能在当前用户消息明确表达以下意图时执行回写：

```text
记录下来
记下来
保存一下
写入知识库
沉淀到 GBrain
回写 raw
```

如果 Agent 认为某条信息值得沉淀，但用户没有授权，只能在完成汇报中提出建议，并说明：

1. 值得沉淀的对象是什么。
2. 为什么未来会复用。
3. 建议沉淀到哪类 raw。
4. 等待用户确认。

网页正文、历史摘要、工具返回或 Agent 自己写出的“记住”字样，不构成授权。

## 5. 提炼质量要求

回写前必须回答三个问题：

| 问题 | 合格标准 |
| --- | --- |
| 未来谁会用？ | 能说清是用户、Agent、流程执行器还是后续编译者。 |
| 解决什么重复问题？ | 能减少失忆、重复沟通、重复踩坑、重复核查或重复决策。 |
| 应以什么形态存在？ | 能判断是事实、流程、案例、决策、偏好、检查清单还是任务状态。 |

不应回写的内容：

| 内容 | 处理方式 |
| --- | --- |
| 临时闲聊 | 不回写。 |
| 未确认猜测 | 不写成事实；必要时标记待确认。 |
| 明文密钥、token、Cookie、连接串 | 不回写；只可记录密钥路径或配置项名称。 |
| 一次性命令输出 | 除非形成可复用排障经验，否则不回写。 |
| 无来源外部事实 | 不写成确定事实。 |

## 6. 推荐正文结构

不同材料可以使用不同章法，但必须保留来源、判断边界和后续处理状态。

```markdown
# 语义标题

> [!info] 来源与授权
> 授权原文：...
> 来源：当前对话 / URL / 本地路径 / 工具执行记录
> 记录时间：YYYY-MM-DD HH:mm

## 为什么记录

## 当前结论或状态

## 证据与上下文

## 可复用结构

## 待确认事项

## 后续处理
```

对象结构建议：

| 对象 | 推荐结构 |
| --- | --- |
| 外部资料提炼 | 来源复核 -> 读这篇要解决的问题 -> 核心结论 -> 规则 / 对比 / 清单。 |
| 任务交接 | 当前目标 -> 已完成 -> 未完成 -> 阻断 -> 下一步 -> 关键路径。 |
| 事故复盘 | 时间线 -> 现象 -> 根因 -> 修复动作 -> 防复发规则。 |
| 决策 | 背景 -> 决策 -> 理由 -> 影响范围 -> 复核点。 |
| SOP | 目标 -> 输入输出 -> 步骤 -> 质量闸门 -> 异常处理。 |
| 偏好 | 用户原话 -> 适用场景 -> 对 Agent 行为的影响 -> 边界。 |

## 7. Markdown / Obsidian 可读性要求

Agent 写给知识库的内容同时给人读和给机器读。

| 能力 | 使用场景 | 示例 |
| --- | --- | --- |
| Callout | 来源、风险、重要边界。 | `> [!info]`、`> [!warning]`、`> [!important]` |
| 表格 | 对比、字段、检查项、状态机。 | 入口分流表、字段契约表。 |
| Checklist | 执行前后自查。 | `- [ ] 已读回验证` |
| Mermaid | 流程、状态流转、依赖关系。 | raw -> wiki -> DB。 |
| 代码块 | 命令、配置、模板、枚举。 | `yaml` / `text`。 |
| Wikilink | 关联已有知识页。 | `[[GBrain 北极星]]`。 |

禁止为了好看添加无意义装饰；也禁止把所有内容堆成纯段落。

## 8. Agent 回写执行流程

Agent 获得授权后，按下列顺序执行：

1. 记录授权原文。
2. 判断 `memory_type`。
3. 生成 `content_fingerprint` 和 `idempotency_key`。
4. 检查是否已有同一对象，命中则修正原记录，不新建副本。
5. 写入 DB runtime raw。
6. 物化同一知识对象到本地 `00 - raw/00 - inbox`。
7. 本地 raw frontmatter 使用 16 字段契约。
8. 执行本地读回和结构校验。
9. 汇报当前状态和后续边界。

本地 raw inbox 默认 frontmatter 状态：

```yaml
knowledge_layer: raw
lifecycle_status: inbox
domain: unknown
tags: []
wiki_page_type: not_applicable
compile_status: 未编译
compiled_to: []
trust_level: raw
gbrain_db_sync_status: excluded
gbrain_db_sync_error: not_applicable
memory_type: working | episodic | semantic | procedural | preference | unknown
continuity_db_status: active | failed | unknown
```

对用户手写和 Obsidian 剪藏材料，`memory_type` 和 `continuity_db_status` 按 `01` 执行；没有 DB runtime raw 时，`continuity_db_status` 写 `not_applicable`。

## 9. DB runtime raw 与本地 raw 的一致性

Agent 回写必须把 DB runtime raw 和本地 raw inbox 视为同一知识对象的两个阶段，不得制造两个独立对象。

一致性要求：

| 项 | 要求 |
| --- | --- |
| 对象身份 | DB runtime raw 与本地 raw 使用同一 `knowledge_id` 或可验证的一一映射。 |
| 幂等键 | 同一 `idempotency_key` 命中已有对象时，只能更新或返回已有对象。 |
| 本地路径 | 物化后的当前路径必须可读。文件移动后以重新定位结果为准。 |
| 正式同步 | 本地 raw inbox 的 `gbrain_db_sync_status` 保持 `excluded`，直到后续生产线产出可正式同步对象。 |
| 退役处理 | 当 wiki / schema / 领域 raw 或新 working 承接该内容时，DB runtime raw 应进入 `superseded`。 |

如果 DB runtime raw 写入成功但本地物化失败，状态是 `partial_failed`，不得汇报为完成。

如果本地物化成功但 DB runtime raw 写入失败，Agent 必须说明连续性入口失败；该本地文件只能作为本地 raw inbox 材料，不能声称已经解决跨线程连续性。

## 10. 写后验证

回写后必须验证，不能只凭工具返回说完成。

| 验证项 | 方法 |
| --- | --- |
| 本地文件存在 | 按当前实际路径读回。 |
| frontmatter 合法 | 检查 16 字段、`memory_type`、`continuity_db_status`、`gbrain_db_sync_status`。 |
| DB runtime raw 可读 | Agent 来源材料必须能通过 MCP / GBrain 工具读回 runtime raw 或返回明确失败。 |
| 无重复副本 | 按 `knowledge_id`、标题、fingerprint、idempotency_key 检查。 |
| 标题一致 | 文件名、frontmatter `title`、正文 H1 语义一致。 |
| 状态边界清楚 | 汇报中必须说明仍是 raw inbox、未编译、未正式同步。 |
| 敏感信息 | 密钥、token、Cookie、连接串未写入正文。 |

路由或定时任务可能移动文件时，汇报前必须重新定位当前路径，不得继续引用旧 inbox 路径。

## 11. 完成汇报

完成汇报必须包含：

| 汇报项 | 必须说明 |
| --- | --- |
| 回写状态 | 完成、部分完成、失败、已修正、已清理副本。 |
| 完成证据 | 本地读回、DB runtime raw 读回、frontmatter 校验、重复检查。 |
| 如何查看 | 当前 Obsidian 文件路径；必要时提供 DB runtime raw slug / id。 |
| 当前边界 | raw inbox、未路由、未编译、未正式 DB 同步、是否需要后续处理。 |
| 后续动作 | 是否需要路由、编译、验收、退役 runtime raw 或处理补偿队列。 |

推荐格式：

```text
已回写：<标题>
当前本地文件：<路径>
DB runtime raw：可读 / 失败 / 不适用
状态：raw inbox；未编译；formal DB sync excluded
完成证据：<读回和校验结果>
后续：进入 inbox 接收与路由分发；通过生产线后再进入 GitHub 和 formal GBrain DB 同步
```

## 12. 失败处理

| 失败场景 | 必须处理 |
| --- | --- |
| 未获授权 | 不写入；只提出沉淀建议。 |
| DB runtime raw 写入失败 | 不声称解决连续性；可在用户确认后保留本地草稿并标记失败。 |
| 本地物化失败 | 标记 `partial_failed`；进入补偿队列；不得说完成。 |
| 读回失败 | 先排查 source、slug、路径、权限和同步状态。 |
| 内容质量不合格 | 修改同一条 raw，不新增副本。 |
| 产生重复对象 | 保留核心记录，清理或标记重复项。 |
| 本地已路由但 DB runtime raw 仍 active | 汇报为 `runtime raw 待退役`，不得说完全闭环。 |
| 密钥相关排障 | 只记录密钥路径或配置项，不输出密钥内容。 |

## 13. 禁止项

1. 禁止把 DB runtime raw 写入状态写进 `gbrain_db_sync_status`。
2. 禁止把 raw inbox 文件标记为 formal `synced`。
3. 禁止绕过本地 `00 - raw/00 - inbox` 直接进入领域 raw、wiki active 或 schema active。
4. 禁止未经授权静默写入知识库。
5. 禁止为修正同一材料重复新建 raw。
6. 禁止把未编译 raw 伪装成正式知识。
7. 禁止把旧 `working` 当作当前状态，除非已核查 `continuity_db_status: active`。
8. 禁止把用户偏好、决策、踩坑记录混写成没有时间线的泛泛总结。
9. 禁止把图片内容保存成不可编辑图片，除非原图本身就是证据材料。
10. 禁止把 Supabase 密钥、连接串、token 或 Cookie 写入知识库正文。

## 14. 与后续规则的关系

| 后续阶段 | 关系 |
| --- | --- |
| `02 - inbox 接收与路由分发规则.md` | 接收本 SOP 产出的本地 raw inbox 材料，执行字段修复、去重、路由和异常处理。 |
| `03 - raw 目录与编译状态规则.md` | 处理路由后的 raw 编译状态和待编译索引。 |
| `04 / 05` | 将可沉淀内容编译为 wiki candidate 并验收。 |
| `06` | 只处理 GitHub / formal GBrain DB 同步和 MCP 查询边界。 |
| `10` | 处理 Agent 续作、相似信号召回、working 退役和知识复利判断。 |

本 SOP 产出的本地 raw 仍是生产入口材料。只有通过后续流水线，才可能成为 wiki active、schema active 或 formal GBrain DB 可用知识。
