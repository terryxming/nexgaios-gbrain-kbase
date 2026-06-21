# 全层 Agent 回写工具边界规则

版本：v0.2.0

生命周期：Draft

日期：2026-06-21

适用范围：Agent 对 `00 - raw`、`01 - wiki`、`02 - schema` 的回写行为

## 1. 规则边界

本规则只做：

1. 规定 Agent 可以回写哪些知识层。
2. 规定 Agent 回写 raw、wiki、schema 的权限边界。
3. 规定用户复核、流程落值和同步执行的关系。
4. 规定禁止 Agent 绕过编译流程直接生成正式知识。

本规则不做：

1. 不规定字段地图。字段以 `《全层》知识字段地图规则.md` 为准。
2. 不规定 inbox 目标目录判断。路由以 `《00 - inbox》路由分发规则.md` 为准。
3. 不规定 raw 到 wiki 编译细则。编译以 `《01 - wiki》知识编译规则.md` 为准。
4. 不规定 GitHub、Supabase 或 GBrain DB 的全量同步机制。

## 2. 总原则

Agent 回写默认先进入 GBrain DB raw 即时记忆。

GBrain DB raw 即时记忆必须物化为本地 `00 - raw/00 - inbox` Markdown。

Agent 可以生成 wiki 修改建议。

Agent 不得自动修改 schema。

Agent 不得直接把新知识标记为 `canonical`。

Agent 不得绕过 raw 到 wiki 编译流程直接写入 active 知识。

Agent 回写到 GBrain DB raw 不等于写入正式知识。

Markdown 物化、inbox 路由、raw 编译和 GitHub 同步由流程执行。

## 3. 回写通道

| 回写类型 | Agent 权限 | 用户角色 |
| --- | --- | --- |
| 日常对话沉淀 | 可写入 GBrain DB raw 即时记忆，随后物化到 `00 - raw/00 - inbox`。 | 事后复核。 |
| 明确指定回写某个 raw | 可生成 GBrain DB raw 记录和本地 raw 草稿。 | 复核高风险字段。 |
| 明确指定回写某个 wiki | 可生成 wiki 修改建议；默认不得直接改 active 页面。 | 复核后由流程落地。 |
| 修改 schema 规则 | 只能生成变更草案。 | 必须明确确认。 |
| 同步到 GBrain DB | 可执行 raw 即时记忆写入；不得执行正式知识同步。 | 验收同步结果。 |

## 4. raw 回写边界

Agent 可以新增 raw。

新增 raw 必须先进入 GBrain DB raw 即时记忆。

GBrain DB raw 记录必须具备完整字段地图中的等价字段。

新增 raw 随后必须物化到：

```text
00 - raw/00 - inbox
```

新增 raw 必须使用完整字段地图。

新增 raw 在 GBrain DB 和本地 Markdown 中的默认字段一致：

```yaml
knowledge_layer: raw
status: inbox
route_status: pending
compile_status: 未编译
trust_level: raw
retrieval_scope: explicit_only
answer_policy: 必须提示未验证
sync_status: pending
```

GBrain DB raw 记录物化为本地 Markdown 后，必须保留同一个 `knowledge_id`。

Agent 可以根据正文生成以下字段建议：

```text
title
material_type
domain_hint
tags
confidence
evidence_level
sensitivity_level
```

Agent 不能把新 raw 直接标记为：

```yaml
trust_level: canonical
compile_status: 已编译
status: active
```

## 5. wiki 回写边界

Agent 可以生成 wiki 修改建议。

Agent 可以在用户明确指定目标 wiki 页面时执行以下动作：

1. 读取目标 wiki 页面。
2. 读取相关 raw 来源。
3. 输出修改建议、判断依据、影响范围和风险。
4. 生成待复核补丁。

Agent 默认不得直接修改 `status: active` 的 wiki 页面。

允许直接修改 wiki 的条件：

1. 用户明确指定目标页面。
2. 修改不改变页面结论。
3. 修改只涉及错别字、格式、断链修复或来源补全。
4. 修改后不改变 `trust_level`、`answer_policy`、`retrieval_scope`。

修改 wiki 结论、页面形态、适用范围、替代关系或 active 状态时，必须先进入用户复核。

## 6. schema 回写边界

Agent 不得自动修改 schema 规则。

Agent 可以生成 schema 变更草案。

修改 schema 必须满足：

1. 用户明确要求修改规则。
2. Agent 输出变更原因、影响范围、迁移要求。
3. 用户确认后才能落地。
4. 落地后必须更新规则变更日志。

Agent 不得在普通对话沉淀、raw 路由或 wiki 编译中顺手修改 schema。

## 7. 禁止行为

Agent 禁止执行以下行为：

1. 直接把对话内容写成 active wiki。
2. 直接把新 raw 标记为 `已编译`。
3. 直接把 `trust_level` 写成 `canonical`。
4. 直接修改 schema 规则。
5. 绕过 inbox 路由把未分类材料写入领域目录。
6. 绕过 raw 到 wiki 编译流程写入正式结论。
7. 绕过同步流程直接写 GBrain DB 作为正式知识。
8. 只写 GBrain DB raw，不物化到本地 Markdown。

## 8. 复核触发条件

以下情况必须触发用户复核：

| 触发条件 | 原因 |
| --- | --- |
| 修改 active wiki 结论 | 影响 Agent 默认回答。 |
| 修改 `trust_level` | 影响可信等级。 |
| 修改 `retrieval_scope` | 影响检索范围。 |
| 修改 `answer_policy` | 影响回答策略。 |
| 修改 `visibility` | 涉及权限范围。 |
| 修改 `sensitivity_level` | 涉及安全边界。 |
| 修改 `supersedes` | 涉及旧知识替代。 |
| 修改 schema 规则 | 影响后续自动化行为。 |

复核输出必须包含：

```text
建议值
判断依据
影响范围
风险
是否建议落地
```

## 9. 与 GBrain DB 的关系

GBrain DB 是 Agent 回写 raw 的第一运行落点。

GBrain DB 不是正式知识的唯一事实来源。

Agent 回写 raw 后，必须先进入 GBrain DB raw 层，使 Agent 即时可检索。

GBrain DB raw 层记录必须异步物化到本地 `00 - raw/00 - inbox`。

该 raw 在编译前必须保持：

```yaml
trust_level: raw
answer_policy: 必须提示未验证
retrieval_scope: explicit_only
```

raw 经过 wiki 编译和质量验收后，才能通过同步流程成为高可信 wiki 知识。

GBrain DB 中的未编译 raw 只能作为即时记忆使用。

## 10. 后续同步要求

修改本规则时，必须同步检查：

1. 《全层》知识字段地图规则.md
2. 《全层》MCP 查询策略规则.md
3. 《00 - inbox》路由分发规则.md
4. 《01 - wiki》知识编译规则.md
5. 《01 - wiki》质量验收规则.md
6. Agent 回写相关 skill、脚本或 MCP 工具
7. 规则变更日志.md
