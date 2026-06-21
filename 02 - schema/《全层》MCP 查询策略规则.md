# 全层 MCP 查询策略规则

版本：v0.1.0

生命周期：Draft

日期：2026-06-21

适用范围：Agent 通过 MCP 查询 GBrain DB 时的检索范围、优先级和回答策略

## 1. 规则边界

本规则只做：

1. 规定 Agent 默认查询 raw、wiki、schema 的范围。
2. 规定不同查询意图对应的检索层级。
3. 规定 raw、wiki、schema 冲突时的优先级。
4. 规定回答时如何标注未编译、候选和规则来源。

本规则不做：

1. 不执行 GBrain DB 同步。
2. 不修改 raw、wiki 或 schema 文件。
3. 不规定 Agent 回写权限。回写边界以 `《全层》Agent 回写工具边界规则.md` 为准。
4. 不规定 raw 到 wiki 编译细则。编译以 `《01 - wiki》知识编译规则.md` 为准。

## 2. 查询总原则

默认优先查询 wiki。

需要过程、来源、最新上下文时查询 raw。

需要规则、流程、字段、自动化约束时查询 schema。

raw 可以作为即时记忆和新证据使用，但未编译 raw 不得伪装成正式结论。

schema 是规则来源，不是业务事实来源。

## 3. 查询意图与默认范围

| 查询意图 | 默认范围 | 回答策略 |
| --- | --- | --- |
| 普通知识问答 | `wiki active` | 可直接回答。 |
| 方法论 / SOP / 流程 | `wiki active + schema` | 先回答知识，再按 schema 校验流程。 |
| 最近讨论 / 对话沉淀 | `raw + wiki` | 必须提示 raw 是否未编译。 |
| 找资料来源 / 证据链 | `wiki source_refs + raw` | 引用 raw 作为依据。 |
| 执行规则 / 路由 / 编译 / 同步 | `schema` | schema 是最高优先级。 |
| 探索性问题 / 没有 wiki 命中 | `wiki candidate + raw` | 标注不确定或未编译。 |
| 冲突判断 | `wiki active + wiki candidate + raw` | active 优先，raw 作为新证据。 |
| 用户明确说“查全部” | `raw + wiki + schema` | 分层说明结果来源。 |

## 4. 默认查询顺序

普通问题按以下顺序查询：

```text
wiki active
wiki candidate
raw
schema
```

规则执行类问题按以下顺序查询：

```text
schema
wiki active
raw
```

最近上下文类问题按以下顺序查询：

```text
raw
wiki active
wiki candidate
```

## 5. 冲突优先级

知识事实冲突时，优先级为：

```text
wiki active > wiki candidate > raw 已编译 > raw 未编译
```

规则执行冲突时，优先级为：

```text
schema > wiki active > raw
```

schema 只在规则、流程、字段、同步、权限、编译和路由问题上优先。

schema 不回答业务事实。

## 6. raw 使用规则

raw 命中后必须判断：

```text
compile_status
trust_level
answer_policy
retrieval_scope
```

raw 未编译时，回答必须标注：

```text
以下内容来自未编译 raw，尚未进入正式 wiki。
```

raw 已编译时，必须优先查找对应 wiki：

```text
compiled_to
```

raw 与 active wiki 冲突时，不得直接推翻 active wiki。

raw 与 active wiki 冲突时，回答应写成：

```text
当前正式 wiki 结论是 X；最新 raw 材料显示 Y，建议进入冲突复核。
```

## 7. wiki 使用规则

`status: active` 的 wiki 可作为默认回答依据。

`status: candidate` 的 wiki 只能作为参考，回答必须标注候选状态。

`status: deprecated` 的 wiki 不得作为当前结论使用，只能用于历史追溯。

`status: rejected` 的 wiki 不得作为回答依据。

active wiki 回答前必须检查：

```text
trust_level
answer_policy
retrieval_scope
```

## 8. schema 使用规则

schema 用于回答：

1. 规则如何执行。
2. 字段如何填写。
3. inbox 如何路由。
4. raw 如何编译。
5. wiki 如何验收。
6. Agent 回写边界。
7. 同步范围和流程。

schema 不用于回答：

1. 市场事实。
2. 产品事实。
3. 项目结论。
4. 外部政策内容。
5. 用户业务判断。

## 9. 回答标注规则

回答必须按来源状态标注：

| 来源 | 标注方式 |
| --- | --- |
| active wiki | 可直接作为当前结论。 |
| candidate wiki | 标注“候选 wiki，尚未晋升 active”。 |
| raw 未编译 | 标注“未编译 raw，尚未进入正式 wiki”。 |
| raw 已编译 | 优先引用对应 wiki；raw 只作为来源证据。 |
| schema | 标注“规则依据”。 |
| deprecated wiki | 标注“历史知识，已废弃”。 |

## 10. 扩大查询范围条件

只有满足以下条件之一，Agent 才能扩大查询范围：

1. 默认范围没有命中。
2. 用户明确要求查最近材料、原始材料或全部材料。
3. 问题涉及来源追溯、证据链或冲突判断。
4. 问题涉及规则执行，需要 schema 校验。
5. active wiki 结论不足以回答用户问题。

扩大范围后，回答必须说明扩大的范围和原因。

## 11. 禁止行为

Agent 禁止：

1. 把未编译 raw 当作正式结论。
2. 把 candidate wiki 当作 active wiki。
3. 用 schema 回答业务事实。
4. 用 deprecated wiki 回答当前结论。
5. 在未说明来源状态时混合 raw、wiki、schema。
6. 为了得到想要的结论随意扩大查询范围。

## 12. 后续同步要求

修改本规则时，必须同步检查：

1. 《全层》知识字段地图规则.md
2. 《全层》Agent 回写工具边界规则.md
3. 《00 - inbox》路由分发规则.md
4. 《01 - wiki》知识编译规则.md
5. 《01 - wiki》质量验收规则.md
6. MCP 工具说明、Codex MCP 启动配置和 Agent 使用提示
7. 规则变更日志.md
