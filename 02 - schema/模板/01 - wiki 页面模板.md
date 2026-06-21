# 01 - wiki 页面模板

模板版本：v0.2.0

用途：新建 `01 - wiki` 页面时，以本模板为起点。

使用规则：

1. 创建正式 wiki 页面时，删除本说明区。
2. frontmatter 字段必须保留完整字段地图。
3. 不适用字段写 `not_applicable`，未知字段写 `unknown`，空列表写 `[]`。
4. 无冲突时删除 `冲突与待确认`。
5. 无结论演化时删除 `变更记录`。
6. `依据来源` 必须指向 raw。
7. `相关链接` 必须写明关系类型。

```markdown
---
schema_version: v0.1.0
knowledge_id: unknown
title:
knowledge_layer: wiki
wiki_page_type:
process_level: not_applicable
material_type: not_applicable
source_type: not_applicable
source_ref: not_applicable
source_title: not_applicable
source_author: not_applicable
captured_at: not_applicable
captured_by: not_applicable
domain_hint: unknown
tags: []
route_status: not_applicable
route_rule_version: not_applicable
routed_at: not_applicable
routed_by: not_applicable
status: candidate
review_status: unreviewed
created_at:
updated_at:
promoted_at: not_applicable
promotion_basis: not_applicable
archived_at: not_applicable
deprecated_at: not_applicable
deprecated_reason: not_applicable
replaced_by: not_applicable
rejected_reason: not_applicable
compile_status: not_applicable
source_refs: []
compiled_from: []
compiled_to: []
compile_rule_version:
compile_batch_id:
compiled_at:
compiled_by:
trust_level: reviewed
confidence: unknown
evidence_level: unknown
risk_level:
last_verified_at: not_applicable
verified_by: not_applicable
retrieval_scope: explicit_only
retrieval_priority: normal
answer_policy: 仅作参考
search_boost: 0
visibility: unknown
owner: unknown
editable_by: []
sensitivity_level: unknown
supersedes: []
superseded_by: []
version: v0.1.0
changelog_ref: not_applicable
content_hash: unknown
last_synced_at: not_applicable
last_synced_by: not_applicable
sync_status: pending
sync_error: not_applicable
---

# 页面标题

## 当前结论

用 1-5 条写清楚当前可复用结论。

要求：

1. 只写结论，不复述 raw 原文。
2. 结论必须能被人或 Agent 执行、引用或判断。
3. 不确定内容不得写成确定结论。

## 适用范围

### 适用

- 

### 不适用

- 

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[]] |  |

## 相关链接

- 上位知识：
- 下位知识：
- 前置流程：
- 后续流程：
- 同一项目：
- 同一系统：
- 同一决策：
- 替代关系：
- 冲突关系：

## 冲突与待确认

| 冲突点 | 旧结论 | 新证据 | 当前处理 |
| --- | --- | --- | --- |

## 变更记录

| 时间 | 变化 | 依据 |
| --- | --- | --- |
```

## 条件字段填写规则

流程页将 `process_level` 填为 `指南` 或 `SOP`，非流程页保持 `not_applicable`。

`status: active` 时填写 `promoted_at` 和 `promotion_basis`，并将：

```yaml
trust_level: canonical
retrieval_scope: default
answer_policy: 可直接回答
```

`status: deprecated` 时填写 `deprecated_at`、`deprecated_reason` 和 `replaced_by`。

`status: rejected` 时填写 `rejected_reason`。
