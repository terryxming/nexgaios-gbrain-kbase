# 00 - raw 编译状态规则

版本：v0.2.0

生命周期：Draft

日期：2026-06-20

适用范围：`00 - raw`

## 1. 规则边界

本规则只做：

1. 规定 raw frontmatter 中的 wiki 编译状态字段。
2. 规定 raw 被编译、跳过、暂缓、过期时如何标记。
3. 规定如何统计 raw 已编译和未编译数量。
4. 规定 raw 编译状态与 wiki `source_refs` 的一致性校验。

本规则不做：

1. 不判断 raw 应放在哪个目录。
2. 不判断 raw 是否值得进入 wiki。
3. 不生成 wiki 页面。
4. 不替代 inbox 路由分发。
5. 不执行 GitHub、Supabase 或 GBrain DB 同步。

`status: raw` 表示材料已经进入 raw 层。

`compile_status` 表示该 raw 是否已经参与 wiki 编译。

二者不能混用。

## 2. Raw Frontmatter 字段

raw Markdown frontmatter 必须包含：

```yaml
compile_status:
```

字段位置固定放在：

```yaml
domain_hint:
compile_status:
tags:
```

非 Markdown raw 文件使用同名 Markdown 说明卡维护 `compile_status`。

## 3. compile_status 允许值

`compile_status` 只允许以下值：

```text
未编译
已编译
部分编译
跳过编译
暂缓编译
已过期
```

含义：

| 值 | 含义 |
| --- | --- |
| 未编译 | 已进入 raw，但尚未判断或尚未进入 wiki 编译。 |
| 已编译 | 该 raw 的核心知识已经进入 wiki，且能在 wiki `source_refs` 中追溯。 |
| 部分编译 | 该 raw 的部分知识已进入 wiki，仍有明确可复用内容未处理。 |
| 跳过编译 | 已判断不进入 wiki，原因必须写入 `compile_reason`。 |
| 暂缓编译 | 暂时不能判断是否进入 wiki，需要补证据、补上下文或用户确认。 |
| 已过期 | 材料已失效，但仍保留追溯价值。 |

## 4. 条件字段

以下字段按状态出现：

| 字段 | 出现条件 | 含义 |
| --- | --- | --- |
| `compiled_at` | `已编译`、`部分编译` | 最近一次进入 wiki 编译的时间。 |
| `compiled_to` | `已编译`、`部分编译` | 该 raw 支撑的 wiki 页面列表。 |
| `compile_reason` | `跳过编译`、`暂缓编译`、`已过期` | 不进入、暂缓或过期的原因。 |

示例：

```yaml
compile_status: 已编译
compiled_at: 2026-06-20 23:35
compiled_to:
  - Agent 的本质
  - 最小可用 Agent
```

```yaml
compile_status: 跳过编译
compile_reason: 重复剪藏，已有同源 raw 支撑 active wiki。
```

## 5. 新 raw 默认状态

材料从 inbox 分发到 raw 领域目录后，默认写入：

```yaml
compile_status: 未编译
```

新 raw 不允许直接写成 `已编译`。

只有完成 wiki 编译并同步 `compiled_to` 后，才能改为 `已编译` 或 `部分编译`。

## 6. 已编译判定

raw 标为 `已编译` 必须同时满足：

1. 至少一个 wiki 页面在 `source_refs` 中引用该 raw。
2. raw 的核心知识已经进入 wiki 的 `当前结论`、`依据来源` 或相关结构。
3. `compiled_to` 列出对应 wiki 页面。
4. 不存在明确未处理的核心知识。

如果 raw 只被局部使用，必须标为：

```yaml
compile_status: 部分编译
```

## 7. 未编译待处理统计

统计 raw 编译覆盖率时，必须输出：

```text
raw 总数
Markdown raw 数
非 Markdown raw 数
已编译
部分编译
未编译
跳过编译
暂缓编译
已过期
缺少 compile_status
```

统计必须同时输出按领域目录分组的数量。

## 8. 一致性校验

raw 编译状态校验必须检查：

1. `compile_status` 是否存在。
2. `compile_status` 是否属于允许值。
3. `已编译` 和 `部分编译` 是否包含 `compiled_at`。
4. `已编译` 和 `部分编译` 是否包含 `compiled_to`。
5. `compiled_to` 指向的 wiki 页面是否存在。
6. wiki `source_refs` 是否能追溯到该 raw。
7. `跳过编译`、`暂缓编译`、`已过期` 是否包含 `compile_reason`。
8. frontmatter 是否存在开头和结尾两个独立的 `---` 分隔符。
9. frontmatter 结尾分隔符是否位于正文内容之前。

如果 raw 被 wiki `source_refs` 引用，但 raw 仍为 `未编译`，必须修正 raw frontmatter。

如果 raw 标记 `已编译`，但没有任何 wiki 页面引用它，必须改为 `暂缓编译` 或补齐 wiki 引用。

## 9. 批量迁移验收

批量新增、修改或迁移 raw frontmatter 后，必须执行落盘验收。

必须检查：

1. 每个 Markdown raw 第一行必须是独立的 `---`。
2. 每个 Markdown raw 必须存在第二个独立的 `---` 作为 frontmatter 结束分隔符。
3. `来源说明`、`原始链接`、一级标题、图片、正文段落不得出现在 frontmatter 内。
4. `compile_status` 必须位于 frontmatter 内。
5. `tags`、`compiled_to` 等列表字段必须使用缩进列表。
6. 验收失败时，必须先修复 frontmatter，再继续后续编译、统计或同步。

如果 Obsidian 显示“无效属性”，优先检查 frontmatter 结束分隔符是否缺失。

## 10. 与 Wiki 编译的关系

raw 到 wiki 编译完成后，必须同步更新 raw 的 `compile_status`。

wiki 页面删除、降级或替换时，必须检查相关 raw 的 `compiled_to` 是否需要调整。

raw 的 `compile_status` 不替代 wiki 的 `status`。

示例：

```text
raw compile_status: 已编译
wiki status: active
```

表示该 raw 已参与编译，且对应 wiki 当前可默认使用。

```text
raw compile_status: 已编译
wiki status: deprecated
```

表示该 raw 曾经参与编译，但对应知识已经过期或被替代。

## 11. 后续同步要求

修改以下内容时，必须同步更新本规则和规则变更日志：

1. `compile_status` 允许值。
2. 条件字段。
3. 新 raw 默认状态。
4. 已编译判定。
5. 编译覆盖率统计字段。
6. 一致性校验规则。
7. 批量迁移验收规则。
