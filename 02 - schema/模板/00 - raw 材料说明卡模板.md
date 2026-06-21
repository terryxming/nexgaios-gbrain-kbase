# 00 - raw 材料说明卡模板

模板版本：v0.1.0

用途：新建 Markdown raw，或为 PDF、图片、截图、Office 文档等非 Markdown 材料创建同名说明卡。

使用规则：

1. 所有新材料先进入 `00 - raw/00 - inbox`。
2. 非 Markdown 原文件必须有同名 Markdown 说明卡。
3. frontmatter 字段必须保留完整字段地图。
4. 不适用字段写 `not_applicable`，未知字段写 `unknown`，空列表写 `[]`。
5. 正文必须保留原始材料说明，不写成正式 wiki 结论。

```markdown
---
schema_version: v0.1.0
knowledge_id: unknown
title:
knowledge_layer: raw
wiki_page_type: not_applicable
process_level: not_applicable
material_type: unknown
source_type: unknown
source_ref: unknown
source_title: unknown
source_author: unknown
captured_at:
captured_by: unknown
domain_hint: unknown
tags: []
route_status: pending
route_rule_version: v0.7.0
routed_at: not_applicable
routed_by: not_applicable
status: inbox
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
compile_status: 未编译
source_refs: []
compiled_from: []
compiled_to: []
compile_rule_version: not_applicable
compile_batch_id: not_applicable
compiled_at: not_applicable
compiled_by: not_applicable
trust_level: raw
confidence: unknown
evidence_level: unknown
risk_level: not_applicable
last_verified_at: not_applicable
verified_by: not_applicable
retrieval_scope: explicit_only
retrieval_priority: low
answer_policy: 必须提示未验证
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

# 材料标题

来源说明：

关联文件：

原始内容：
```
