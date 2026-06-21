# 00 - raw 材料说明卡模板

模板版本：v0.4.5

适用规则：`《全层》知识生产流水线操作手册.md` v0.4.5；`流水线细则/01 - 知识入口与字段规则.md` v0.2.0；`流水线细则/02 - inbox 接收与路由分发规则.md` v0.2.1

用途：新建 Markdown raw，或为 PDF、图片、截图、Office 文档等非 Markdown 材料创建同名说明卡。

使用规则：

1. 所有新材料先进入 `00 - raw/00 - inbox`。
2. 非 Markdown 原文件必须有同名 Markdown 说明卡。
3. frontmatter 只保留知识入口与字段细则规定的 14 个字段。
4. 字符串使用单引号，空列表写 `[]`。
5. 正文必须保留原始材料说明，不写成正式 wiki 结论。

```markdown
---
knowledge_id: 'unknown'
title: ''
knowledge_layer: 'raw'
lifecycle_status: 'inbox'
source: 'unknown：unknown'
captured_at: ''
domain: 'unknown'
tags: []
wiki_page_type: 'not_applicable'
compile_status: '未编译'
compiled_to: []
trust_level: 'raw'
gbrain_db_sync_status: 'pending'
gbrain_db_sync_error: 'not_applicable'
---

# 材料标题

## 来源说明

| 字段 | 值 |
| --- | --- |
| 来源类型 |  |
| 来源引用 |  |
| 捕获时间 |  |
| 原始作者 |  |
| 原始链接/会话/文件 |  |

## 关联文件

| 文件名 | 相对路径 | 文件类型 | 说明 |
| --- | --- | --- | --- |
|  |  |  |  |

## 原始内容说明
```
