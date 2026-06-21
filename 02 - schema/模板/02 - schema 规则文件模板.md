# 02 - schema 规则文件模板

模板版本：v0.1.0

用途：新建 `02 - schema` 规则文件时，以本模板为起点。

使用规则：

1. frontmatter 字段必须保留完整字段地图。
2. schema 文件正文仍保留规则版本、生命周期、日期和适用范围。
3. 规则变更只记录契约变化，不记录执行流水账。
4. 不适用字段写 `not_applicable`，未知字段写 `unknown`，空列表写 `[]`。

```markdown
---
schema_version: v0.1.0
knowledge_id: unknown
title:
knowledge_layer: schema
wiki_page_type: not_applicable
process_level: not_applicable
material_type: not_applicable
source_type: not_applicable
source_ref: not_applicable
source_title: not_applicable
source_author: not_applicable
captured_at: not_applicable
captured_by: not_applicable
domain_hint: schema
tags: []
route_status: not_applicable
route_rule_version: not_applicable
routed_at: not_applicable
routed_by: not_applicable
status: active
review_status: approved
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
compile_rule_version: not_applicable
compile_batch_id: not_applicable
compiled_at: not_applicable
compiled_by: not_applicable
trust_level: canonical
confidence: high
evidence_level: not_applicable
risk_level: 中
last_verified_at: not_applicable
verified_by: not_applicable
retrieval_scope: default
retrieval_priority: high
answer_policy: 可直接回答
search_boost: 0
visibility: private
owner: user
editable_by: []
sensitivity_level: 内部
supersedes: []
superseded_by: []
version: v0.1.0
changelog_ref: 02 - schema/规则变更日志.md
content_hash: unknown
last_synced_at: not_applicable
last_synced_by: not_applicable
sync_status: pending
sync_error: not_applicable
---

# 规则名称

版本：v0.1.0

生命周期：Draft

日期：YYYY-MM-DD

适用范围：

## 1. 规则边界

本规则只做：

1.

本规则不做：

1.
```
