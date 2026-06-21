# 01 - wiki 页面模板

用途：新建 `01 - wiki` 页面时，以本模板为起点。

使用规则：

1. 创建正式 wiki 页面时，删除本说明区。
2. 必填 frontmatter 必须保留。
3. 条件字段只在满足条件时保留。
4. 无冲突时删除 `冲突与待确认`。
5. 无结论演化时删除 `变更记录`。
6. `依据来源` 必须指向 raw。
7. `相关链接` 必须写明关系类型。

```markdown
---
title:
status: candidate
wiki_page_type:
created:
updated:
source_refs: []
risk_level:
tags: []
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

## 条件字段片段

流程页使用：

```yaml
process_level:
```

`status: active` 使用：

```yaml
promoted_at:
promotion_basis:
```

`status: deprecated` 使用：

```yaml
deprecated_at:
deprecated_reason:
replaced_by:
```

`status: rejected` 使用：

```yaml
rejected_reason:
```
