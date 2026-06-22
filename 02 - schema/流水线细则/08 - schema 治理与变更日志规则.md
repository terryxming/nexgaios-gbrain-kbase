---
knowledge_id: 'schema-158e5716425f'
title: 'schema 治理与变更日志规则'
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

# schema 治理与变更日志规则

版本：v0.1.1

生命周期：Draft

日期：2026-06-22

适用范围：schema 规则版本、生命周期、活动脚本依赖、规则变更日志、迁移要求

## 1. 版本规则

schema 层规则版本必须使用三段式语义化版本：

```text
vMAJOR.MINOR.PATCH
```

## 2. 生命周期

生命周期只允许：

```text
Draft
Stable
Deprecated
```

含义：

| 生命周期 | 含义 |
| --- | --- |
| Draft | 仍在整理和试运行，可以继续修改当前版本。 |
| Stable | 已确认可长期引用，后续实质修改必须升版本。 |
| Deprecated | 已废弃，只保留追溯，不再作为活动规则。 |

知识文件 frontmatter 中的 `lifecycle_status` 不等于 schema 规则生命周期。

## 3. 脚本依赖

活动脚本必须声明依赖规则和规则版本。

脚本实际执行某个流水线阶段时，必须声明主手册和对应阶段细则。

脚本、模板与规则冲突时，以规则为准，并同步修改脚本或模板。

## 4. 规则变更日志

规则变更日志固定为：

```text
02 - schema/规则变更日志.md
```

规则变更日志只记录规则契约变化，不记录执行过程。

每条变更必须包含：

```text
变更类型
影响范围
兼容影响
涉及规则
规则契约
决策原因
迁移要求
```

以下内容不写入规则变更日志：

1. 跑了一次审计。
2. 修了多少个文件。
3. 删除一次性报告或副产物脚本。
4. 某次手工整理过程。
5. Git / GitHub / Supabase 操作记录。
6. inbox 当前是否为空。

## 5. 渐进式披露要求

主手册只保留执行主线、调度表、全局约束和冲突处理。

阶段细则保存该阶段的执行规则、判断标准、字段细节和验收标准。

旧主题规则入口默认删除，不保留 Deprecated 空壳。

Deprecated 只用于确实需要保留的历史文件；保留前必须说明外部依赖和删除风险。

修改任一细则时，必须检查主手册调度表是否需要同步更新。

## 6. 版本变更工程规则

Draft 表示规则仍可试运行，但不表示可以静默改变工程契约。

以下修改可以不升版本：

1. 错别字。
2. 排版。
3. 不改变执行含义的措辞澄清。
4. 增加非规范性说明示例。

以下修改必须至少升 PATCH，并写入规则变更日志：

1. 新增、删除或改变阻断条件。
2. 新增、删除或改变字段枚举、字段语义、frontmatter 契约。
3. 新增、删除或改变目录 include / exclude 范围。
4. 新增、删除或改变脚本输入、输出、退出条件或报告字段。
5. 新增、删除或改变 Agent 可直接执行的写入权限。
6. 新增、删除或改变同步、回写、验收、晋升的状态机。

以下修改必须升 MINOR：

1. 新增一个流水线阶段。
2. 新增一个活动规则文件。
3. 新增一个受控执行脚本或模板。
4. 改变跨阶段执行顺序。

以下修改必须升 MAJOR：

1. 废弃当前流水线主线。
2. 改变 raw / wiki / schema 三层边界。
3. 使旧脚本、模板或 Agent SOP 必须整体重写。

## 7. 依赖同步检查

修改任一活动规则后，必须检查：

1. 主手册活动规则清单中的版本、生命周期和依赖项。
2. 主手册阶段状态机是否仍能调度到正确细则。
3. 相关模板的“适用规则”版本。
4. 相关脚本头部声明的依赖规则版本。
5. 规则变更日志是否需要新增条目。
6. GBrain DB 同步范围是否需要重新 dry-run。

如果修改只影响单一规则文件、且不改变执行契约，可以在完成汇报中明确说明“未触发依赖同步”。

如果修改改变执行契约，但主手册、模板或脚本尚未同步，必须标记为未完成，不得宣称 schema 治理已闭环。

## 8. frontmatter 与正文生命周期

schema Markdown 的 frontmatter `lifecycle_status` 表示该规则页在 GBrain DB 中是否为当前可检索对象。

正文中的“生命周期：Draft / Stable / Deprecated”表示规则契约成熟度。

两者不得混用：

1. 当前活动规则页：frontmatter 使用 `lifecycle_status: 'active'`。
2. 废弃但保留追溯的规则页：frontmatter 使用 `lifecycle_status: 'deprecated'`，正文生命周期使用 `Deprecated`。
3. 规则草案尚未进入活动清单时：frontmatter 可以使用 `lifecycle_status: 'candidate'`，正文生命周期使用 `Draft`。

## 9. 迁移要求写法

规则变更日志中的“迁移要求”必须写成可执行检查清单。

至少说明：

1. 需要检查哪些文件、脚本、模板或 DB 配置。
2. 哪些旧字段、旧路径、旧状态或旧入口需要迁移。
3. 如何验证迁移完成。
4. 不迁移会产生什么风险。
5. 本次是否允许延后迁移。

如果没有迁移要求，必须明确写：

```text
迁移要求：无。
```

禁止只写“后续同步”“后续注意”这类不可执行描述。
