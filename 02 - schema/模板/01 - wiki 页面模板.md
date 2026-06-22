---
knowledge_id: 'schema-4f99bf94e27e'
title: '01 - wiki 页面模板'
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

# 01 - wiki 页面模板

模板版本：v0.5.9

适用规则：`《全层》知识生产流水线操作手册.md` v0.4.13；`流水线细则/01 - 知识入口与字段规则.md` v0.2.2；`流水线细则/04 - wiki 编译与页面治理规则.md` v0.1.1；`流水线细则/05 - wiki 质量验收规则.md` v0.1.1

用途：新建 `01 - wiki` 页面时，以本模板为起点。

使用规则：

1. 创建正式 wiki 页面时，删除本说明区。
2. frontmatter 只保留知识入口与字段细则规定的 16 个字段。
3. 字符串使用单引号，空列表写 `[]`。
4. 无冲突时删除 `冲突与待确认`。
5. 无结论演化时删除 `变更记录`。
6. `依据来源` 必须指向 raw。
7. `相关链接` 必须写明关系类型。

```markdown
---
knowledge_id: 'unknown'
title: ''
knowledge_layer: 'wiki'
lifecycle_status: 'candidate'
source: 'not_applicable：not_applicable'
captured_at: ''
domain: 'unknown'
tags: []
wiki_page_type: ''
compile_status: 'not_applicable'
compiled_to: []
trust_level: 'reviewed'
gbrain_db_sync_status: 'pending'
gbrain_db_sync_error: 'not_applicable'
memory_type: 'not_applicable'
continuity_db_status: 'not_applicable'
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

`lifecycle_status: active` 时，将：

```yaml
trust_level: 'canonical'
```

`lifecycle_status: deprecated` 时，在正文 `变更记录` 或 `替代关系` 中写明废弃原因和新页面。

`lifecycle_status: rejected` 时，在正文 `变更记录` 中写明拒绝原因。
