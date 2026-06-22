---
knowledge_id: 'schema-f9ef851876a4'
title: 'wiki 质量验收规则'
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

# wiki 质量验收规则

版本：v0.1.1

生命周期：Draft

日期：2026-06-22

适用范围：wiki 写入验收、质量验收、知识簇验收、验收结论和处理动作

## 1. 触发条件

每次新建、更新或晋升 wiki 页面后，必须执行验收。

## 2. 写入验收

必须检查：

1. frontmatter 必填字段是否齐全。
2. `lifecycle_status` 是否属于允许值。
3. `wiki_page_type` 是否属于 10 类页面形态。
4. 由 raw 编译生成或更新的页面，正文 `依据来源` 是否指向 raw。
5. `_meta/编译日志.md` 是否记录编译规则版本和编译批次。
6. `相关链接` 是否使用类型化链接。
7. 页面是否保留了模板说明文字。

无真实冲突时，禁止保留空的 `冲突与待确认` 小节。

无结论演化时，禁止保留空的 `变更记录` 小节。

## 3. 补丁污染验收

禁止页面正文中出现：

```text
*** Add File
*** Update File
*** End Patch
```

如果发现补丁标记进入正文，必须停止后续写入，先修复污染。

## 4. 质量验收触发条件

以下情况必须执行 wiki 质量验收：

1. candidate 晋升为 active 后。
2. active 页面新增、删除或修改正文结论后。
3. active 页面新增、删除或修改 `相关链接` 后。
4. 索引页新增或移除下位 active 页面后。
5. 发现断链、冲突、生命周期表述不一致或证据缺失时。

只修改错别字、空行或纯排版时，不需要执行完整质量验收。

## 5. 单页面验收标准

单页面必须同时满足：

1. frontmatter 必填字段齐全。
2. `lifecycle_status`、`wiki_page_type`、`trust_level` 使用允许值。
3. `lifecycle_status: active` 页面必须能在正文或晋升记录中追溯晋升依据。
4. 流程页必须在正文中说明是指南还是 SOP。
5. 正文必须包含 `当前结论`、`适用范围`、`依据来源`、`相关链接`。
6. `当前结论` 必须是可执行判断，不是空泛摘要。
7. `适用范围` 必须同时说明适用和不适用场景。
8. `依据来源` 必须能追溯到 raw。
9. `相关链接` 必须使用类型化链接。
10. 页面内不得残留模板说明文字。
11. 页面内不得残留与当前生命周期冲突的表述。

## 6. 知识簇验收

索引页必须执行知识簇验收。

对象页、主题页、流程页、政策页、模板页、案例页、对比页至少执行单页面验收。

每次知识簇验收至少提出 2 个真实使用问题。

可用性测试必须输出：

| 字段 | 含义 |
| --- | --- |
| 测试问题 | 本次用于验证的真实问题。 |
| 命中页面 | 回答该问题需要调用的 wiki 页面。 |
| 可执行路径 | 从入口页到具体页面的导航路径。 |
| 验收结论 | 通过、修复后通过、不通过。 |
| 处理动作 | 无、直接修复、进入待处理、进入冲突索引。 |

## 7. 验收结论

验收结论只允许：

| 结论 | 含义 |
| --- | --- |
| 通过 | 页面或知识簇可被用户和 Agent 默认使用。 |
| 修复后通过 | 存在可直接修复的问题，修复后可使用。 |
| 不通过 | 存在证据缺失、冲突、断链或用户判断缺口，不能默认使用。 |

验收发现问题时，只允许：

1. 直接修复页面正文、frontmatter、链接或索引。
2. 在 `_meta/待处理索引.md` 记录不能直接修复的问题。
3. 在 `_meta/冲突索引.md` 记录知识冲突。
4. 将不应默认使用的页面降级为 `candidate` 或 `deprecated`。

禁止为了通过验收而编造 raw 证据。

## 8. 验收记录落盘

wiki 质量验收必须留下可追溯记录。

验收记录写入位置：

| 场景 | 记录位置 |
| --- | --- |
| candidate 晋升 active | `_meta/晋升记录.md` |
| raw 编译后首次验收 | `_meta/编译日志.md` |
| 修复后通过 | 原记录追加修复说明 |
| 不通过且待补材料 | `_meta/待处理索引.md` |
| 不通过且存在结论冲突 | `_meta/冲突索引.md` |

验收记录至少包含：

```text
验收时间
验收对象
验收触发原因
验收规则版本
验收人或执行 Agent
验收结论
发现问题
处理动作
复验要求
```

只在聊天中说明验收通过、但没有写入上述记录时，active 晋升不得视为完成。

## 9. 阻断项

出现以下任一问题时，验收结论不得为 `通过`：

1. 页面缺少 16 字段 frontmatter。
2. `knowledge_layer`、`lifecycle_status`、`wiki_page_type`、`trust_level` 或 `gbrain_db_sync_status` 使用非法值。
3. `lifecycle_status: active` 但 `trust_level` 不是 `canonical`。
4. `lifecycle_status: candidate` 但被 `_index.md` 当作默认 active 入口展示。
5. `依据来源` 缺失、断链或指向旧 inbox 路径且没有同步说明。
6. `相关链接` 没有关系类型，或链接目标不存在。
7. 页面正文残留模板说明、补丁标记或空的治理小节。
8. 存在未解决冲突但未写入 `冲突与待确认` 和 `_meta/冲突索引.md`。
9. active 页面结论修改后没有同步更新变更记录或晋升记录。

## 10. 修复后复验

验收结论为 `修复后通过` 时，必须满足：

1. 问题可以由当前 Agent 直接修复。
2. 修复不改变高风险业务判断。
3. 修复完成后重新执行相关检查项。
4. 验收记录追加“修复内容”和“复验结论”。

如果修复需要用户判断、补充证据或重新编译 raw，结论必须保持 `不通过`，并进入待处理或冲突索引。

## 11. active 晋升写入规则

candidate 晋升为 active 时，必须同步修改：

```yaml
lifecycle_status: 'active'
trust_level: 'canonical'
gbrain_db_sync_status: 'pending'
gbrain_db_sync_error: 'not_applicable'
```

同时必须更新：

1. `_meta/晋升记录.md`。
2. `_index.md` 中的 active 入口或待处理摘要。
3. 相关页面的类型化链接，必要时补双向链接。

上述任一写入失败时，不得宣称晋升完成。

## 12. 验收脚本输出契约

后续实现 wiki 验收脚本时，输出必须至少包含：

```text
checked_files
passed_files
fix_after_pass_files
failed_files
blocking_issues
broken_links
missing_raw_sources
template_residue
patch_pollution
index_updates_required
meta_records_required
```

脚本只提供验收观察，不自动编造缺失证据，不自动将 candidate 晋升 active。
