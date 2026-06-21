---
title: 'Amazon Review Insight Codex Agent Skill v0.2.0 迭代计划'
status: raw
created: '2026-06-17 14:47'
source_type: unknown
material_type: 方案
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Skill'
  - 'MCP'
  - 'GitHub'
  - 'LLM'
---

# Amazon Review Insight Codex Agent Skill v0.2.0 迭代计划

计划版本：v0.2.0-plan  
目标 skill 名称：`amazon-review-insight`  
计划日期：2026-06-15  
构建形态：Codex agent skill  
基线版本：v0.1.0  
目标版本：v0.2.0  

## 1. 迭代定位

v0.2.0 是在 v0.1.0 已发布能力基础上的分析深度增强版本，不改变 skill 的核心边界：

1. 仍只做 Amazon US。
2. 仍只做单个 ASIN。
3. 仍只使用 Sorftime MCP。
4. 仍由当前 Codex/code agent 完成 Review 语义理解、开放编码、VOC 主题归因和业务动作生成。
5. 仍不做本地 Web 工作台。
6. 仍不接外部 LLM provider。
7. HTML 仍是主要阅读与决策报告。

v0.2.0 主要解决两个问题：

1. v0.1.0 的关键结论只有摘要和总量，无法看清每个维度下的主要类型、次要类型和长尾信号。
2. v0.1.0 的 Review 编码层只作为 agent 内部中间产物，没有单独交付，不方便审计、复盘、二次分析和人工校正。

## 2. v0.2.0 必须做

1. 关键结论增加 `distribution[]` 类型/观点分布。
2. HTML 报告中的关键结论卡片增加分布表。
3. `analysis.json` 数据契约增加关键结论分布字段。
4. 新增 Review 编码层 `.xlsx` 交付物。
5. 新增 Excel 导出脚本和 CLI 命令。
6. 新增 Excel schema 检查和契约检查。
7. 新增关键结论分布相关 tests、checkpoints、evals。
8. 更新 Product Design report assets，支持关键结论分布表的桌面端和移动端展示。
9. 更新 sample analysis、sample HTML、sample Excel。
10. 更新 GitHub Release 产物清单。

## 3. v0.2.0 不做

1. 不做多 ASIN 分析。
2. 不做竞品对比。
3. 不做 CSV 导出。
4. 不做 PDF 导出。
5. 不把 Excel 作为主报告替代物。
6. 不自动改写或发布 Amazon Listing。
7. 不把 Review 编码层完整明细塞进 HTML 主报告。
8. 不做长期评论数据库、跨任务历史库或远程缓存。

## 4. 关键结论分布设计

### 现状

v0.1.0 的关键结论类似：

```text
当前样本中，人群信号主要来自家庭购买者、儿童/青少年使用者、伴侣礼物购买者和经常办聚会的人。
```

这个摘要本身有价值，但只回答了“总体怎么看”，没有回答：

1. 每类人群分别被多少条 Review 提及。
2. 每类人群占样本多少比例。
3. 哪些是主要使用者。
4. 哪些是次要使用者。
5. 哪些只是长尾信号。
6. 每类判断由哪些原文支撑。

### 决策

从 v0.2.0 起，每个关键结论维度必须包含：

1. `summary`：一句话摘要。
2. `count / sample_size / percentage`：该维度整体被明确表达的 Review 数和占比。
3. `confidence`：整体置信度。
4. `distribution[]`：该维度下的类型/观点分布。
5. `business_implication`：业务解读。
6. `theme_ids`：关联主题。
7. `evidence`：摘要层短证据。

### `distribution[]` 字段

```json
{
  "label": "家庭购买者",
  "review_count": 18,
  "sample_size": 76,
  "percentage": 23.7,
  "role": "primary",
  "reason": "多条评论表达家庭购买、家庭使用或家庭聚会。",
  "evidence": ["karaoke with the family", "Our family has used this"],
  "theme_ids": ["theme_family_party_gifting"]
}
```

字段说明：

| 字段 | 作用 | 规则 |
| --- | --- | --- |
| `label` | 类型或观点名称 | 必须业务可读，不能写泛词 |
| `review_count` | 命中该类型的去重 Review 数 | 同一 Review 多次表达同一类型只计 1 次 |
| `sample_size` | Review 样本数 | 固定等于 `review_sample_size` |
| `percentage` | 样本占比 | `review_count / sample_size` |
| `role` | 主次判断 | `primary`、`secondary`、`long_tail`、`risk_signal`、`unknown` |
| `reason` | 为什么归为该类型 | 必须基于 Review 原文 |
| `evidence` | 原文证据 | 非 unknown 必须有 |
| `theme_ids` | 关联主题 | 可为空，但不能编造 |

### 多标签口径

同一条 Review 可以命中同一维度下多个类型。例如一条 Review 同时提到：

1. 给妻子买。
2. 家庭聚会使用。
3. 孩子也喜欢。

则在人群维度中，这条 Review 可以同时计入：

1. `伴侣礼物购买者`
2. `家庭购买者`
3. `儿童/青少年使用者`

因此，同一维度下各类型百分比允许合计超过 100%。报告中必须明确说明这是多标签统计。

### 角色判定规则

| role | 含义 | 建议判定 |
| --- | --- | --- |
| `primary` | 主要矛盾或主要类型 | count 领先，且对业务动作有直接影响 |
| `secondary` | 次要但稳定的类型 | 有多条证据，但不是最主要方向 |
| `long_tail` | 长尾类型 | count 较低，暂不作为主结论 |
| `risk_signal` | 低频高风险 | count 低但严重度高，例如硬件故障、退货 |
| `unknown` | 未明确表达 | Review 没有足够证据 |

## 5. 八类关键结论分布要求

每次报告必须覆盖八类维度，且每类都必须有分布表：

| 维度 | 分布表应该回答什么 |
| --- | --- |
| 人群 | 谁在买，谁在用，主要使用者和次要使用者分别是谁 |
| 场景 | 哪些使用场景最高频，哪些是长尾场景 |
| 用户任务 | 用户想完成哪些任务，核心任务和附加任务分别是什么 |
| 购买理由 | 用户为什么选择它，主购买驱动和辅助理由分别是什么 |
| 用户期望 | 用户买前期待什么，哪些期待最稳定 |
| 实际体验 | 真实使用后发生了什么，正向体验和落差分别是什么 |
| 满意点 | 哪些满意点最高频，哪些可以强化为 Listing 卖点 |
| 不满意点 | 哪些痛点最高频，哪些低频但高风险 |

主报告页展示每个维度的 Top 8 到 Top 12 分布项。完整分布进入 Excel 的 `key_insight_distribution` sheet。

## 6. HTML 报告改造

### 关键结论卡片结构

每张关键结论卡片从 v0.1.0 的摘要卡片升级为：

1. 维度标题。
2. 一句话摘要。
3. 总 `count / sample_size / percentage`。
4. `confidence`。
5. 分布表。
6. 业务解读。
7. 最多 3 条摘要 evidence。
8. 关联主题。

### 分布表列

| 列 | 内容 |
| --- | --- |
| 类型/观点 | `label` |
| 提及占比 | `percentage` + `review_count` |
| 角色 | `role` |
| 原因 | `reason` |

### 视觉要求

1. 表格必须适合横向比较，不要只做成散落标签。
2. `primary` 应在视觉上比 `secondary` 更容易识别。
3. 移动端允许分布表转为紧凑列表。
4. 不允许表格文本溢出卡片。
5. 不允许主报告页展示大段完整 Review 原文。

## 7. Review 编码层 Excel 交付物

### 文件命名

```text
<ASIN>-review-coding-v0.2.0.xlsx
```

### 必须 sheet

| Sheet | 用途 |
| --- | --- |
| `metadata` | ASIN、站点、抓取时间、样本数、版本 |
| `normalized_reviews` | 规范化 Review 样本 |
| `feedback_units` | Review 编码层原子反馈 |
| `open_tags` | 开放标签和归并关系 |
| `key_insight_distribution` | 八类关键结论完整分布 |
| `voc_themes` | VOC 主题归因结果 |
| `business_actions` | 业务动作清单 |
| `checkpoints` | 质量检查结果 |

### Excel 边界

1. Excel 展示完整 Review 编码明细。
2. HTML 主报告不展示完整 Review 编码明细。
3. Excel 可以包含完整 Review 原文和中文翻译。
4. Excel 不得包含 Sorftime key、token、环境变量值。
5. Excel 不作为长期评论数据库。

### Excel 样式

1. 冻结首行。
2. 开启筛选。
3. 长文本自动换行。
4. 不合并单元格。
5. checkpoint 状态使用浅色底区分。
6. `role` 使用浅色底辅助区分主次。
7. 列名使用英文 snake_case。

## 8. 数据契约变更

### `analysis.json` 新增或调整

1. `key_insights[].summary`
2. `key_insights[].distribution[]`
3. `key_insights[].business_implication`
4. `feedback_units[]`
5. `open_tags[]`
6. `normalized_reviews[]`

### 兼容策略

v0.2.0 可以读取 v0.1.0 的 analysis JSON，但如果缺少 `distribution[]`：

1. contract check 必须 fail。
2. 渲染器不得静默生成不完整报告。
3. 错误信息必须说明缺少哪个维度的分布表。

## 9. 脚本改造

### 新增脚本

```text
amazon-review-insight/scripts/export_review_coding_excel.ts
```

职责：

1. 读取 `analysis.json`。
2. 校验 Excel 必须字段。
3. 生成 `.xlsx`。
4. 写入必须 sheet。
5. 设置基础样式。
6. 不做语义分析。

### 更新脚本

`render_report.ts`：

1. 渲染关键结论分布表。
2. 显示多标签统计说明。
3. 移动端保证表格可读。

`agent_contract_check.ts`：

1. 检查八类关键结论都有 `distribution[]`。
2. 检查分布项百分比。
3. 检查非 unknown 分布项 evidence。
4. 检查 Excel 文件存在、sheet 和列。

`secret_scan.ts`：

1. 覆盖 `.xlsx` 文件。
2. 或者提供 Excel 文本抽取后扫描。

`cli.ts`：

新增命令：

```bash
amazon-review-insight export-excel <analysis.json> <review-coding.xlsx>
```

`package.json` 新增：

```bash
npm run export:excel -- <analysis.json> <review-coding.xlsx>
```

## 10. Tests

### Unit Tests

新增：

1. `key-insight-distribution.test.ts`
2. `excel-exporter.test.ts`
3. `excel-schema.test.ts`

必须覆盖：

1. `distribution[]` 必填。
2. 八类维度完整。
3. 百分比计算正确。
4. 多标签合计超过 100% 时不报错。
5. 非 unknown 分布项必须有 evidence。
6. Excel 必须 sheet 存在。
7. Excel 必须列存在。
8. Excel 文件可打开。

### Integration Tests

新增：

1. `excel-export-with-mock-data.test.ts`
2. `pipeline-with-distribution-and-excel.test.ts`

必须覆盖：

1. mock analysis 渲染 HTML。
2. mock analysis 导出 Excel。
3. contract check 同时检查 HTML 和 Excel。
4. secret scan 覆盖 HTML 和 Excel。

## 11. Checkpoints

v0.2.0 新增 checkpoint：

| checkpoint | fail 条件 |
| --- | --- |
| 关键结论分布检查 | 缺少八类维度、缺少 `distribution[]`、百分比错误、非 unknown 无 evidence |
| Excel 导出检查 | `.xlsx` 未生成、无法打开、sheet 缺失 |
| Excel schema 检查 | 必须列缺失、关键字段为空 |
| Excel 安全检查 | 出现 Sorftime key、token、环境变量值 |

## 12. Evals

v0.2.0 新增：

1. `eval_08_key_insight_distribution`
2. `eval_09_review_coding_excel`

### `eval_08_key_insight_distribution`

通过要求：

1. 八类关键结论都有分布表。
2. 分布表能识别 primary、secondary、long_tail 或 risk_signal。
3. 分布项有 count、percentage、reason、evidence。
4. 不把泛词当成分布项。
5. 业务解读能说明主次矛盾。

### `eval_09_review_coding_excel`

通过要求：

1. Excel 文件存在并可打开。
2. 必须 sheet 全部存在。
3. 必须列全部存在。
4. `key_insight_distribution` 覆盖八类维度。
5. Excel 中不含 key 或 token。

## 13. Product Design 更新

v0.2.0 需要重新确认报告视觉资产，重点是关键结论分布表。

设计 brief：

1. 产品是 Amazon Review VOC 决策报告。
2. 报告读者是亚马逊卖家、产品经理、运营和 Listing 优化人员。
3. 关键结论卡片需要同时承载摘要和结构化分布表。
4. 视觉风格保持 v0.1.0 的克制、分析型、可扫描风格。
5. 不做营销 landing page。
6. 桌面端优先信息密度，移动端保证不溢出。

需要更新：

1. `assets/report/design-tokens.json`
2. `assets/report/report.css`
3. `assets/report/report-layout.md`

## 14. Release 产物

v0.2.0 Release 必须包含：

1. skill zip 包。
2. `SHA256SUMS.txt`。
3. `CHANGELOG.md` 摘要。
4. 辅助 CLI 脚本。
5. sample input。
6. sample output JSON。
7. sample HTML report。
8. sample Review 编码层 Excel。
9. compatibility matrix。
10. migration notes。
11. known limitations。

sample 仍使用真实 Sorftime 数据，默认 ASIN 为 `B0DHPN1DMJ`。

## 15. 发布前检查

发布前必须通过：

1. `npm run typecheck`
2. `npm test`
3. `npm run render -- <analysis.json> <report.html>`
4. `npm run export:excel -- <analysis.json> <review-coding.xlsx>`
5. `npm run contract:check -- <analysis.json> <report.html> <review-coding.xlsx>`
6. `npm run secret:scan -- .`
7. skill `quick_validate.py`
8. sample HTML 人工检查
9. sample Excel 人工检查
10. Product Design 视觉 QA
11. Release zip SHA256 校验
12. 发布后重新下载安装并 smoke test

## 16. GitHub 实施步骤

1. 从 `main` 创建 `codex/v0.2.0-key-insights-excel` 分支。
2. 更新 `SKILL.md` 到 `skill_version: v0.2.0`。
3. 更新 specs、features、checkpoints、evals。
4. 实现数据契约和渲染器。
5. 实现 Excel exporter。
6. 更新 tests。
7. 更新 sample analysis、sample HTML、sample Excel。
8. 跑完整发布前检查。
9. 更新 `CHANGELOG.md`。
10. 提交 PR。
11. 合并后打 `v0.2.0` tag。
12. 创建 GitHub Release。

## 17. 验收标准

v0.2.0 完成时必须满足：

1. HTML 报告仍可打开。
2. HTML 关键结论覆盖八类维度。
3. 每类关键结论都有分布表。
4. 分布表能看出主要类型和次要类型。
5. 分布表 count 和 percentage 正确。
6. 分布表非 unknown 项都有 evidence。
7. Excel 文件生成成功。
8. Excel 必须 sheet 全部存在。
9. Excel `key_insight_distribution` 覆盖八类维度。
10. Excel 可用于筛选、排序、人工复盘。
11. HTML、Excel、缓存和 release assets 都通过 secret scan。
12. v0.2.0 Release 包可重新下载安装并验证。

## 18. 决策日志引用

本 v0.2.0 计划对应总计划文件中的 `## 18. 决策日志`，核心决策包括：

1. 关键结论从摘要升级为摘要加分布表。
2. Review 编码层新增 Excel 交付物。
3. v0.2.0 只新增 Excel，不新增 CSV 和 PDF。
4. 新增关键结论分布和 Excel 的 tests、checkpoints、evals、secret scan。

