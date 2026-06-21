# 02 - schema 规则文件模板

模板版本：v0.4.5

适用规则：`《全层》知识生产流水线操作手册.md` v0.4.5；`流水线细则/01 - 知识入口与字段规则.md` v0.2.0；`流水线细则/08 - schema 治理与变更日志规则.md` v0.1.0

用途：新建 `02 - schema` 规则文件时，以本模板为起点。

使用规则：

1. frontmatter 只保留知识入口与字段细则规定的 14 个字段。
2. schema 文件正文仍保留规则版本、生命周期、日期和适用范围。
3. 规则变更只记录契约变化，不记录执行流水账。
4. 字符串使用单引号，空列表写 `[]`。

```markdown
---
knowledge_id: 'unknown'
title: ''
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
