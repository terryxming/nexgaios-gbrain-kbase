---
title: 'Amazon US Review Insight Codex Agent Skill 构建计划'
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
  - '美国站'
---

# Amazon US Review Insight Codex Agent Skill 构建计划

计划版本：v0.1.0-plan  
目标 skill 名称：`amazon-review-insight`  
计划日期：2026-06-15  
构建形态：Codex agent skill  
报告语言：中文  
目标站点：Amazon US  

## 1. 定位

本 skill 面向亚马逊美国站单个 ASIN 的 Review VOC 决策分析。用户提供一个 Amazon US ASIN 后，Codex agent 通过 Sorftime MCP 抓取产品详情和评论数据，亲自完成 Review 开放编码、VOC 主题归因、业务动作生成，并最终交付一份中文自包含 `.html` 分析报告。

本 skill 不是本地 Web 工作台，不内置或外接独立 LLM provider。语义分析由使用 skill 的当前 Codex/code agent 完成；脚本只负责确定性任务，例如字段解析、数据规范化、统计计算、checkpoint 校验、HTML 渲染、密钥扫描和缓存清理。

## 2. v0.1.0 范围

### 必须做

1. 只支持 Amazon US。
2. 只支持单个 ASIN。
3. 只使用 Sorftime MCP 抓取 Review 和产品详情。
4. 生成中文自包含 `.html` 报告。
5. 当前 agent 完成 Review 语义理解、开放编码、主题归因和业务动作生成。
6. 使用渐进式披露组织 `SKILL.md`、`references/`、`scripts/`、`checkpoints/`、`tests/`、`evals/`。
7. 保留明确的数据口径、报告契约、分析规则、用户确认规则。
8. 建立 tests、checkpoints、evals 三层质量保障。
9. 建立 GitHub 发布所需的版本管理、迭代记录、发布前检查和生命周期管理规则。
10. 发布 skill 包，同时发布辅助 CLI 脚本。
11. v0.1.0 sample HTML report 使用真实 Sorftime 数据生成。

### 暂不做

1. 不做本地 Web 工作台。
2. 不做外接 LLM provider。
3. 不做多 ASIN 分析。
4. 不做竞品对比。
5. v0.1.0 不做 CSV、XLSX、PDF 导出；从 v0.2.0 起新增 Review 编码层 Excel 交付物，但仍不做 CSV 和 PDF 导出。
6. 不自动改写或发布 Amazon Listing。
7. HTML 主报告不展示完整 Review 编码明细；从 v0.2.0 起，Review 编码明细通过独立 `.xlsx` 文件交付，供审计、复盘和二次分析使用。
8. 主报告页不展示大段完整 Review；VOC 主题详情页默认展示完整 Review 原文和完整中文翻译。

### v0.2.0 已确认迭代方向

v0.2.0 在 v0.1.0 已发布能力基础上增加两个分析交付能力：

1. 关键结论从“单句摘要 + 总量”升级为“单句摘要 + 类型/观点分布表 + 主次矛盾判断 + 业务解读”。
2. Review 编码层新增 `.xlsx` 交付物，展示 normalized reviews、feedback units、开放标签、关键结论分布、VOC 主题、业务动作和 checkpoint。

v0.2.0 不改变以下边界：

1. 仍只支持 Amazon US。
2. 仍只支持单个 ASIN。
3. 仍只使用 Sorftime MCP。
4. 仍不做本地 Web 工作台。
5. 仍不接外部 LLM provider。
6. HTML 报告仍是主要阅读与决策交付物。

## 3. 典型触发方式

Skill metadata 的描述需要覆盖以下用户意图：

1. 分析某个 Amazon US ASIN 的评论。
2. 生成中文 Review VOC 分析报告。
3. 从 Review 中提炼产品优化建议。
4. 从 Review 中提炼 Listing、图片、视频优化建议。
5. 用 Sorftime MCP 抓取 Amazon US 评论并生成 HTML 报告。

示例用户请求：

```text
用 amazon-review-insight 分析 ASIN B0DHPN1DMJ，生成中文 HTML 报告。
```

```text
帮我分析这个 Amazon US ASIN 的 review，输出产品和 Listing 优化建议。
```

## 4. 目标仓库结构

GitHub 仓库根目录放项目级治理文件，skill 包内部只放 agent 执行任务必需的资源。

```text
repo-root/
  README.md
  LICENSE
  SECURITY.md
  CONTRIBUTING.md
  CHANGELOG.md
  .gitignore
  package.json
  amazon-review-insight/
    SKILL.md
    agents/
      openai.yaml
    references/
      specs/
        sorftime-contract.md
        data-contract.md
        analysis-rules.md
        report-contract.md
        user-confirmation-rules.md
      features/
        report-generation.feature
        user-confirmation.feature
    checkpoints/
      checkpoints.json
    scripts/
      render_report.ts
      export_review_coding_excel.ts
      agent_contract_check.ts
      secret_scan.ts
      clear_cache.ts
    tests/
      fixtures/
      unit/
      integration/
    evals/
      data/
      tasks/
      rubrics/
    assets/
      report/
        design-tokens.json
        report.css
        report-layout.md
  .github/
    workflows/
      ci.yml
      release.yml
    ISSUE_TEMPLATE/
      bug_report.yml
      report_quality_issue.yml
      sorftime_field_change.yml
    PULL_REQUEST_TEMPLATE.md
```

## 5. 渐进式披露设计

### `SKILL.md`

`SKILL.md` 只保留核心执行流程、固定规则和引用文件导航，避免塞入完整规格细节。目标是让 agent 触发 skill 后快速知道：

1. 当前只处理单个 Amazon US ASIN。
2. 调用 Sorftime 前读哪个契约。
3. 解析数据前读哪个契约。
4. 生成分析前读哪个规则。
5. 生成报告前读哪个契约。
6. 交付前运行哪些校验。

`SKILL.md` 正文必须写入 `skill_version`，初始值为 `v0.1.0`。版本号不得写入 YAML frontmatter；frontmatter 只保留 `name` 和 `description`。每次 release 必须同步更新 `SKILL.md` 中的 `skill_version`，并跟随 SemVer、发布规则和生命周期规则维护。

### `references/specs/`

规格文件作为 SDD 的来源。只有在当前任务需要时才读取。

1. `sorftime-contract.md`：Sorftime MCP 工具、参数、返回结构和字段限制。
2. `data-contract.md`：规范化数据结构、字段含义、样本数和分母口径。
3. `analysis-rules.md`：开放编码、VOC 主题、业务动作、证据忠实规则。
4. `report-contract.md`：HTML 报告章节、视觉风格、禁止项、交付要求。
5. `user-confirmation-rules.md`：缺失信息、模糊信息、不得推断规则。

### `references/features/`

BDD 场景文件只保存用户可见行为和验收标准。

1. `report-generation.feature`：单 ASIN 报告生成验收。
2. `user-confirmation.feature`：缺失信息和模糊信息处理验收。

### `scripts/`

脚本只处理可确定、可重复、可测试的任务。

1. `render_report.ts`：把 agent 产出的 `analysis.json` 渲染成自包含 HTML。
2. `agent_contract_check.ts`：检查 `analysis.json` 和 HTML 报告是否符合契约。
3. `secret_scan.ts`：扫描报告、缓存、日志和样例中是否含 key。
4. `clear_cache.ts`：清理 `.cache/asin-review-insight/`，不删除 `outputs/`。
5. `export_review_coding_excel.ts`：从 agent 产出的 `analysis.json` 导出 Review 编码层 `.xlsx`，只负责 deterministic workbook 结构、sheet、列名、格式和数据写入，不负责语义判断。

辅助 CLI 脚本随 GitHub release 一起发布。仓库根目录 `package.json` 必须提供 CLI 入口或 npm scripts，至少覆盖：

1. 渲染报告：把 `analysis.json` 渲染为 `.html`。
2. 契约检查：检查 `analysis.json` 和 `.html` 是否符合报告契约。
3. 密钥扫描：检查报告、缓存、日志和样例中是否泄露 key。
4. 缓存清理：清理 `.cache/asin-review-insight/`。
5. live smoke：使用真实 Sorftime 数据验证 `product_detail` 和 `product_reviews` 可用。
6. Review 编码层 Excel 导出：把 `analysis.json` 中的 normalized reviews、feedback units、开放标签、关键结论分布、VOC 主题、业务动作和 checkpoint 导出为 `.xlsx`。

### `assets/report/`

报告样式资源由 Product Design 插件设计阶段产出，再沉淀为 skill 内可复用资产。

1. `design-tokens.json`：颜色、字体、间距、圆角、阴影、状态色等设计 token。
2. `report.css`：自包含 HTML 报告使用的基础样式。
3. `report-layout.md`：报告页面结构、主题卡片、详情页、高亮样式和响应式规则。

## 6. Sorftime MCP 契约

v0.1.0 固定使用 Sorftime MCP。

### 工具

1. `product_reviews`：查询 Amazon 产品近一年用户留评，最多返回 100 条评论。
2. `product_detail`：查询 Amazon 产品详情数据。

### 参数

`product_reviews`：

1. `asin`：必填。
2. `amzSite`：固定 `US`。
3. `reviewType`：默认 `Both`。

`product_detail`：

1. `asin`：必填。
2. `amzSite`：固定 `US`。

### 已知返回口径

1. `product_reviews` 外层返回 `result.content[0].text`。
2. `product_reviews` 的 `text` 是 JSON 数组字符串。
3. `product_reviews` 当前使用中文字段名：`评论产品的属性`、`评论日期`、`评星`、`标题`、`评论`。
4. `评论日期` 当前格式为 `yyyyMMdd`。
5. `评星` 当前为数字或可转数字。
6. `product_detail` 外层返回 `result.content[0].text`。
7. `product_detail` 的 `text` 当前是按行排列的中文键值文本，不是 JSON 对象。
8. `product_detail` 字段 `评论数` 固定展示为 ASIN 总评论数量，含义是 ASIN 层全部评论数量，包含 review 和 rating。

### 缺失字段限制

当前 `product_reviews` 不保证返回：

1. Review ID。
2. reviewer name。
3. verified purchase。
4. helpful vote。
5. Amazon review URL。
6. 抓取页码。
7. Vine 字段。

缺失字段不得由 agent 推断。报告中需要时使用 `unknown`。

## 7. 数据契约

### 核心口径

1. `asin_total_review_count` = Sorftime `product_detail` 字段 `评论数`。
2. `asin_total_review_count` 展示名为 ASIN 总评论数量，含义是 ASIN 层全部评论数量，包含文本 review 和 rating。
3. `review_sample_size` = `product_reviews` 实际返回条数。
4. 所有 VOC 主题、关键结论、业务动作的百分比分母必须使用 `review_sample_size`。
5. `asin_total_review_count` 只能作为产品规模背景，不得作为 VOC 洞察分母。

### 规范化 Review 对象

```json
{
  "asin": "B0DHPN1DMJ",
  "variant": "Size=Shell S3;Color=Black",
  "review_date": "2025-01-31",
  "rating": 5,
  "title": "Great speaker",
  "text": "Original review text",
  "raw": {}
}
```

### 字段处理规则

1. 原始 Sorftime 字段必须保留到 `raw`。
2. 空评论正文标记为数据质量问题。
3. 日期无法解析时写 `unknown`，并进入 checkpoint warning。
4. 星级无法解析时写 `unknown`，并进入 checkpoint warning 或 fail。
5. 重复 Review 以 `评论日期 + 评星 + 标题 + 评论` 完全一致为默认判断口径。

## 8. Agent 分析契约

### Review 编码层

当前 agent 逐条阅读 Review 原文，输出 `feedback_units[]`。每条 Review 可以拆成 0 个、1 个或多个反馈单元。

Review 编码层的作用是把一整段自然语言评论拆成可统计、可追溯、可转成动作的原子反馈。它不是为了“翻译评论”，而是回答：

1. 谁在用。
2. 在什么场景用。
3. 想完成什么任务。
4. 为什么买。
5. 买前期待什么。
6. 实际体验如何。
7. 哪些点满意。
8. 哪些点不满意。
9. 造成了什么后果。
10. 哪一句原文支撑这个判断。

每个 `feedback_unit` 固定字段：

| 字段 | 用途 | 例子 |
| --- | --- | --- |
| `audience` | 判断评论代表的人群或购买者身份 | `grandparent_buyer`、`children_family_users` |
| `scenario` | 判断产品在哪个使用场景产生价值或问题 | `thanksgiving_family_gathering` |
| `user_task` | 判断用户用产品完成什么任务 | `family_karaoke_entertainment` |
| `purchase_reason` | 判断购买或认可该产品的理由 | `portable_all_in_one_karaoke_machine` |
| `user_expectation` | 判断用户买前希望产品做到什么 | `quality_durable_wireless_portable_good_sound` |
| `expectation_source` | 判断期望来自哪里；评论没说就写 `unknown` | `unknown` |
| `actual_experience` | 判断实际使用结果 | `children_sang_for_hours_and_took_turns` |
| `satisfied_points` | 记录具体满意点，支持多值 | `good_sound`、`compact_video_screen` |
| `unsatisfied_points` | 记录具体不满点，支持多值 | 没有明确不满时为空数组或 `unknown` |
| `consequence` | 记录体验带来的结果 | `hours_of_family_engagement` |
| `evidence` | 支撑该反馈单元的短原文证据 | `singing their hearts out for hours` |
| `confidence` | 判断证据强度 | `high`、`medium`、`low` |

规则：

1. 字段没有明确表达时写 `unknown`。
2. 非 `unknown` 字段必须带 evidence。
3. evidence 必须能在原 Review text 中找到。
4. 不得根据标题、价格、品牌、类目、Listing 文案补充 Review 未表达的信息。
5. 不得根据星级单独推断满意点或不满意点。
6. 同一条 Review 同时包含多个独立反馈逻辑时，拆成多个 `feedback_unit`。

#### 少样本编码示例

以下示例只用于说明编码结构。单条 Review 的 `count=1` 不能直接当成正式报告强结论；正式报告需要在聚合后根据样本数、证据数、严重度和置信度决定是否进入前台。

评论原文片段：

```text
This Karaoke machine is excellent in every aspect... durable, wireless, connecting via bluetooth/wifi, portable, versatile, compact, good sound, color video screen...
It's really useful for all ages. Ages 3-20+ are my grandchildren, nieces and nephews... had a blast on Thanksgiving...
They were preoccupied and singing their hearts out for hours... lots of giggles, smiles and taking turns!
I think for the size, and all reasons above, it is totally worth the price.
```

编码结果示例：

```json
{
  "asin": "unknown_in_example",
  "review_index": 1,
  "feedback_units": [
    {
      "unit_id": "fu_001",
      "audience": { "value": "family_buyer_for_children", "evidence": "my grandchildren, nieces and nephews" },
      "scenario": { "value": "family_holiday_gathering", "evidence": "had a blast on Thanksgiving" },
      "user_task": { "value": "family_karaoke_entertainment", "evidence": "singing their hearts out for hours" },
      "purchase_reason": { "value": "all_in_one_family_entertainment_device", "evidence": "fun and easy karaoke" },
      "user_expectation": { "value": "quality_durable_wireless_portable_good_sound", "evidence": "quality, durable, wireless... portable... good sound" },
      "expectation_source": { "value": "unknown", "evidence": "" },
      "actual_experience": { "value": "children_engaged_for_hours_and_took_turns", "evidence": "for hours... taking turns" },
      "satisfied_points": [
        { "value": "durable_build_quality", "evidence": "Very great quality, durable" },
        { "value": "wireless_bluetooth_wifi_connectivity", "evidence": "wireless, connecting via bluetooth/wifi" },
        { "value": "portable_compact_design", "evidence": "portable, versatile, compact" },
        { "value": "good_sound_output", "evidence": "speakers that produce good sound" },
        { "value": "built_in_color_video_screen", "evidence": "color video screen" }
      ],
      "unsatisfied_points": [],
      "consequence": { "value": "high_family_engagement_and_positive_emotion", "evidence": "lots of giggles, smiles" },
      "evidence": "They were preoccupied and singing their hearts out for hours... lots of giggles, smiles and taking turns!",
      "confidence": "high"
    }
  ]
}
```

#### 同一条 Review 拆成多个 feedback_unit 的例子

同一条 Review 中如果出现多个独立反馈逻辑，就不要压成一个大而全的单元。以上评论至少可以拆成 3 个反馈单元：

| feedback_unit | 独立反馈逻辑 | 为什么要拆开 |
| --- | --- | --- |
| `fu_001` 产品能力满意 | 质量、耐用、无线连接、便携、屏幕、声音都被正向评价 | 这些是产品功能和硬件卖点，可进入产品和 Listing 卖点统计 |
| `fu_002` 家庭聚会场景成功 | 孩子和亲友在 Thanksgiving 聚会中长时间唱歌、轮流玩 | 这是场景化价值，可进入图片/视频和 A+ 场景表达 |
| `fu_003` 价格价值感 | 用户认为结合尺寸和功能“worth the price” | 这是价格价值感，不应和声音、屏幕等功能满意点混在一起 |

拆分后的简化示例：

```json
[
  {
    "unit_id": "fu_001",
    "scenario": { "value": "product_feature_evaluation", "evidence": "quality, durable, wireless... good sound, color video screen" },
    "user_task": { "value": "use_karaoke_machine_as_all_in_one_entertainment_device", "evidence": "karaoke... boom box too" },
    "satisfied_points": [
      { "value": "durable_build_quality", "evidence": "Very great quality, durable" },
      { "value": "built_in_screen_for_lyrics_and_video", "evidence": "It shows videos with the words of songs" }
    ],
    "unsatisfied_points": [],
    "evidence": "durable, wireless... good sound, color video screen",
    "confidence": "high"
  },
  {
    "unit_id": "fu_002",
    "audience": { "value": "children_and_young_family_members", "evidence": "Ages 3-20+ are my grandchildren, nieces and nephews" },
    "scenario": { "value": "thanksgiving_family_party", "evidence": "had a blast on Thanksgiving" },
    "user_task": { "value": "keep_family_members_entertained_singing_together", "evidence": "singing their hearts out for hours" },
    "satisfied_points": [
      { "value": "multi_age_family_appeal", "evidence": "really useful for all ages" },
      { "value": "supports_turn_taking_group_fun", "evidence": "taking turns" }
    ],
    "consequence": { "value": "hours_of_engagement_and_positive_emotion", "evidence": "lots of giggles, smiles" },
    "evidence": "They were preoccupied and singing their hearts out for hours",
    "confidence": "high"
  },
  {
    "unit_id": "fu_003",
    "purchase_reason": { "value": "perceived_value_for_size_and_features", "evidence": "for the size, and all reasons above" },
    "actual_experience": { "value": "price_felt_worth_it_after_use", "evidence": "totally worth the price" },
    "satisfied_points": [
      { "value": "strong_value_for_money", "evidence": "totally worth the price" }
    ],
    "unsatisfied_points": [],
    "evidence": "I think for the size... it is totally worth the price",
    "confidence": "high"
  }
]
```

### 开放标签规则

开放标签的作用是把原文里的具体表达变成可聚合的业务信号。它解决三个问题：

1. Review 表达千变万化，不能靠固定枚举覆盖所有真实反馈。
2. 同义表达需要归并，否则统计会碎成很多无法决策的小词。
3. 新出现的场景、痛点、卖点不能被丢弃，必须用 `new_tag` 保留下来。

开放标签可以用于：

1. 统计高频满意点和不满意点。
2. 发现新的使用场景。
3. 发现 Listing 没有讲清楚但用户真实在意的卖点。
4. 发现低频但高风险的问题。
5. 为 VOC 主题聚类提供原子信号。

标签对象建议结构：

```json
{
  "field": "satisfied_points",
  "raw_value": "speakers that produce good sound",
  "normalized_tag": "good_sound_output",
  "taxonomy_status": "new_tag",
  "evidence": "speakers that produce good sound",
  "confidence": "high"
}
```

规则：

1. 不固定标签枚举。
2. 标签由 agent 根据 Review 原文开放生成。
3. 标签必须具体，不能只写 `quality`、`good`、`bad`、`sound` 这类泛词。
4. 相同语义要归并，例如 `good sound`、`speakers produce good sound` 可归并为 `good_sound_output`。
5. 不同业务含义要拆开，例如 `portable_compact_design` 和 `strong_value_for_money` 不能合并成 `good_product`。
6. 既有标签无法覆盖的新表达保留为 `new_tag`。
7. `new_tag` 必须保留 raw value 和 evidence。
8. 标签不得来自产品描述、Listing 文案或 agent 常识，只能来自 Review 原文。

本条样例 Review 可生成的开放标签示例：

| 字段 | raw_value | normalized_tag | 用途 |
| --- | --- | --- | --- |
| `audience` | `grandchildren, nieces and nephews` | `children_and_young_family_members` | 判断核心受众 |
| `scenario` | `Thanksgiving` | `thanksgiving_family_party` | 发现节日家庭聚会场景 |
| `satisfied_points` | `wireless, connecting via bluetooth/wifi` | `wireless_bluetooth_wifi_connectivity` | 统计连接能力满意点 |
| `satisfied_points` | `color video screen` | `built_in_color_video_screen` | 统计屏幕卖点 |
| `satisfied_points` | `totally worth the price` | `strong_value_for_money` | 统计价值感 |

### VOC 主题归因层

输入：`feedback_units[]`  
输出：`voc_themes[]`

VOC 主题归因层的作用是把零散 feedback units 聚合成可以进入报告和决策的主题。它不是重复列标签，而是回答：

1. 多条 Review 是否在说同一个业务问题或同一个购买驱动。
2. 这个主题出现多少次，占样本多少比例。
3. 它是卖点、痛点、场景问题、预期落差，还是低频高风险。
4. 它为什么重要。
5. 它可能由什么原因造成，但只能写成假设。
6. 它应该进入哪些业务动作方向。

主题类型固定：

1. `positive_purchase_driver`：正向购买驱动。
2. `product_pain_point`：产品痛点。
3. `scenario_problem`：场景化问题。
4. `expectation_gap`：预期落差。
5. `audience_fit`：人群匹配。
6. `low_frequency_high_risk`：低频高风险。

每个主题固定字段：

| 字段 | 用途 |
| --- | --- |
| `theme_id` | 稳定引用主题，供业务动作绑定 |
| `theme_name` | 给业务用户看的主题名称，必须具体 |
| `theme_category` | 判断主题类型，决定报告分组 |
| `priority` | 主题处理优先级 |
| `count` | 命中该主题的 Review 数或反馈单元数，需在契约中固定口径 |
| `sample_size` | Review 样本数 |
| `percentage` | `count / sample_size` |
| `core_issue` | 主题背后的核心问题或核心价值 |
| `root_cause_hypothesis` | 可能原因，只能写成假设 |
| `severity` | 严重度，影响优先级 |
| `business_meaning` | 对产品、转化、差评、退货、内容表达的意义 |
| `related_action_areas` | 该主题可转向哪些动作方向 |
| `theme_evidence` | 支撑主题的短原文证据 |
| `confidence` | 主题可信度 |

规则：

1. `theme_name` 开放生成，但必须具体。
2. `root_cause_hypothesis` 必须写成假设，不得写成确定事实。
3. `count >= 3` 的主题进入前台报告。
4. `count` 为 1 到 2 且 `severity = high` 的主题进入前台报告，并归入低频高风险。
5. `count` 为 1 到 2 且非高严重度的主题进入后台观察池，不进入关键结论。
6. 前台报告不得只展示 Top N 后丢弃符合进入规则的主题。

基于样例 Review 的候选主题示例：

```json
{
  "theme_id": "theme_001",
  "theme_name": "家庭聚会场景下多年龄儿童持续参与度高",
  "theme_category": "positive_purchase_driver",
  "priority": "P1",
  "count": 1,
  "sample_size": 1,
  "percentage": 100.0,
  "core_issue": "该产品能让多个年龄段孩子在家庭聚会中持续参与和轮流互动。",
  "root_cause_hypothesis": "可能是便携一体机、内置屏幕、麦克风收纳和较容易上手的组合降低了多人娱乐场景的使用门槛。",
  "severity": "low",
  "business_meaning": "这是一个强场景卖点，但在单条样本中只能作为候选正向主题，不能写成强结论。",
  "related_action_areas": ["listing", "image_video"],
  "theme_evidence": [
    "Ages 3-20+ are my grandchildren, nieces and nephews",
    "had a blast on Thanksgiving",
    "singing their hearts out for hours"
  ],
  "confidence": "medium"
}
```

注意：这个例子 `sample_size=1`，只说明主题对象怎么写。正式报告中，单条正向主题一般不进入强关键结论；只有聚合后满足进入规则，或属于低频高风险，才进入前台主题地图。

### 业务动作层

输入：`voc_themes[]`  
输出：`business_actions[]`

业务动作层的作用是把 VOC 主题转成团队可以执行和验证的动作。它回答：

1. 这个 Review 主题应该由谁处理。
2. 应该改产品、改 Listing，还是改图片/视频。
3. 具体改什么。
4. 为什么优先。
5. 影响哪个业务指标。
6. 后续怎么验证动作是否有效。

动作方向固定为：

1. `product`：产品优化。
2. `listing`：Listing 优化。
3. `image_video`：图片/视频优化。

每条动作固定字段：

| 字段 | 用途 |
| --- | --- |
| `action_id` | 稳定引用动作 |
| `theme_id` | 绑定来源主题，避免无证据建议 |
| `action_area` | 动作归属：产品、Listing、图片/视频 |
| `business_finding` | 用业务语言解释发现 |
| `recommendation` | 具体建议动作 |
| `priority` | `P0`、`P1`、`P2` |
| `priority_score` | 优先级分数，便于排序 |
| `priority_reason` | 为什么这个动作值得做 |
| `impact_metrics` | 预期影响指标 |
| `validation_method` | 后续验证方式 |
| `evidence` | 原文证据 |
| `confidence` | 建议可信度 |

Listing 动作必须细化到：

1. 主图副文案建议。
2. 五点描述建议。
3. A+ 模块建议。
4. QA 问题建议。

产品动作必须包含：

1. 产品改进建议。
2. 不修复风险。

图片/视频动作必须包含：

1. 图片建议。
2. 视频建议。

基于样例主题的业务动作示例：

```json
{
  "action_id": "action_001",
  "theme_id": "theme_001",
  "action_area": "image_video",
  "business_finding": "评论明确显示该产品在 Thanksgiving 家庭聚会中能让 3-20+ 岁孩子持续参与、轮流唱歌并产生强互动情绪。",
  "recommendation": {
    "summary": "强化家庭聚会和多年龄儿童互动场景表达。",
    "image_suggestions": [
      "增加一张家庭客厅或节日聚会场景图，展示孩子轮流拿麦唱歌、其他人观看屏幕歌词。",
      "在图片角标突出 all ages family karaoke、built-in screen、wireless microphones 等卖点。"
    ],
    "video_suggestions": [
      "制作 15-30 秒短视频，展示开机、连接、屏幕歌词、孩子轮流唱歌和家庭互动。",
      "视频中体现便携搬动、麦克风顶部收纳和电视连接。"
    ]
  },
  "priority": "P1",
  "priority_score": 6,
  "priority_reason": "这是明确正向场景证据，对图片理解效率和转化有帮助；但当前示例只有单条证据，不能定为 P0。",
  "impact_metrics": ["图片点击理解效率", "广告点击后转化", "A+ 内容解释充分度"],
  "validation_method": ["主图点击率对比", "Listing 文案 A/B 测试", "新批次 Review 复盘"],
  "evidence": [
    "had a blast on Thanksgiving",
    "singing their hearts out for hours",
    "lots of giggles, smiles and taking turns"
  ],
  "confidence": "medium"
}
```

## 9. HTML 报告契约

### Product Design 样式设计流程

HTML 报告的视觉样式必须使用 Product Design 插件完成设计，不由渲染脚本临时拼凑。Product Design 插件只用于设计阶段，不作为最终 `.html` 报告的运行时依赖。

设计阶段固定流程：

1. 使用 Product Design `get-context` 确认报告设计 brief。
2. 根据 brief 生成报告视觉方向，至少包含桌面主报告页、VOC 主题地图、VOC 主题详情页、移动端阅读状态。
3. 用户选择或确认视觉方向后，再沉淀为 `assets/report/design-tokens.json`、`assets/report/report.css` 和 `assets/report/report-layout.md`。
4. `render_report.ts` 只能使用已确认的 report assets 渲染 HTML，不得自行发明新的视觉体系。
5. 交付前用 Product Design 做视觉 QA，检查信息层级、卡片密度、主题详情页跳转、高亮可读性、移动端排版和长评论承载。

当前已知设计 brief：

1. 产品类型：Amazon US 单 ASIN Review VOC 决策分析报告。
2. 目标读者：中文产品经理、亚马逊运营、Listing 优化人员。
3. 核心任务：快速判断用户洞察、产品改进机会、Listing 和图片/视频优化动作。
4. 视觉气质：浅色、专业、数据报告感、证据优先、动作导向。
5. 交互要求：自包含 HTML 内部跳转；VOC 主题卡片可进入详情页；详情页展示完整 Review 原文、完整中文翻译和黄色高亮。
6. 禁止方向：营销 landing page、hero 大图、装饰性渐变背景、复杂图表、外部 CDN、过度花哨的单色主题。

### 输出要求

1. 报告必须是中文。
2. 输出为自包含 `.html`。
3. 不依赖外部 CDN。
4. 主报告页只展示短 evidence snippets。
5. 不展示完整 Review 编码明细。
6. 主报告页不展示大段完整 Review；VOC 主题详情页默认展示该主题相关的完整 Review 原文和完整中文翻译。
7. 不展示执行摘要。
8. 报告必须是一个自包含 HTML；主题详情页必须在同一个 HTML 内完成跳转和返回，不依赖外部服务。

### 前台章节

v0.1.0 单 ASIN 报告固定包含：

1. 数据范围与口径。
2. Review 健康度。
3. 关键结论。
4. VOC 主题地图。
5. VOC 主题详情页。
6. 机会矩阵与业务动作清单。
7. 限制说明与 checkpoint 状态。

### 章节边界

每个章节必须有清楚边界，避免重复表达：

| 章节 | 回答的问题 | 边界 |
| --- | --- | --- |
| 数据范围与口径 | 本次数据从哪里来、样本有多少、统计分母是什么 | 只讲数据来源和口径，不输出业务判断 |
| Review 健康度 | 这个 ASIN 的评论基础状态如何 | 只讲星级、样本量、分布、数据质量，不解释深层原因 |
| 关键结论 | 从 Review 中可以得到哪些面向用户洞察、产品改进和 Listing 优化的核心判断 | 必须覆盖八类洞察；不穷举所有主题，不展示完整证据链 |
| VOC 主题地图 | 支撑关键结论的主题证据结构是什么 | 展示全部进入前台规则的主题卡片、数据、严重度、证据摘要和详情页入口 |
| VOC 主题详情页 | 某个主题背后的具体评论证据是什么 | 展示该主题相关完整 Review 原文、完整中文翻译和高亮，不新增未在主题层出现的新结论 |
| 机会矩阵与业务动作清单 | 应该改产品、改 Listing，还是改图片/视频 | 只输出可执行动作，必须绑定 `theme_id` 和 evidence，不新增无证据建议 |
| 限制说明与 checkpoint 状态 | 哪些结论受样本、字段、抓取和质量限制影响 | 只讲限制、warn、fail 和未知项，不补充业务结论 |

### 数据范围与口径

必须展示：

1. ASIN。
2. 站点：Amazon US。
3. 数据来源：Sorftime MCP。
4. 抓取时间。
5. Review 样本数。
6. ASIN 总评论数量。
7. VOC 分母说明。
8. 已知缺失字段说明。

### Review 健康度

必须展示：

1. 产品星级。
2. ASIN 总评论数量。
3. Review 样本数。
4. 样本星级分布。
5. 4-5 星占比。
6. 1-3 星占比。
7. 最新 Review 日期。
8. 数据质量 warning。

### 关键结论

关键结论的作用是给用户一个高层、业务可读的判断层。它必须回答八类洞察，因为这八类信息分别服务于用户洞察、产品改进和 Listing 优化：

1. 人群：谁在买、谁在用，帮助判断目标用户和图片人群表达。
2. 场景：在什么使用场景产生价值或问题，帮助判断图片、视频、A+ 场景。
3. 用户任务：用户想完成什么任务，帮助判断产品功能和 Listing 文案重点。
4. 购买理由：用户为什么选择它，帮助判断主卖点和广告钩子。
5. 用户期望：用户买前期待什么，帮助判断 Listing 承诺是否准确。
6. 实际体验：真实使用后发生了什么，帮助判断产品体验落差。
7. 满意点：哪些正向点可强化，帮助优化卖点、图片和视频。
8. 不满意点：哪些负向点需修复或提前解释，帮助降低差评、退货和售前疑虑。

这八类都必须回答。没有足够证据时，不得空着或编造，必须写成：

```text
评论未明确表达，当前样本中记为 unknown。
```

每类结论必须包含：

1. 一句话自然语言摘要，用来回答该维度的高层判断。
2. 该维度的总 `count / sample_size / percentage`。
3. 置信度。
4. 类型/观点分布表，用来穷举该维度下已识别的主要类型、次要类型和长尾类型。
5. 最多 3 条短原文证据。
6. 关联的 `theme_id` 列表。
7. 对产品、Listing 或图片/视频的启发。

从 v0.2.0 起，关键结论不能只给一句话总结。每个维度必须补充 `distribution[]`，用于回答“主要矛盾是什么、次要矛盾是什么、长尾信号是什么”。例如“人群”维度不能只写“家庭购买者、儿童/青少年使用者、伴侣礼物购买者和经常办聚会的人”，还必须列出这些类型分别被多少条 Review 提及、占样本多少比例、属于主要人群还是次要人群。

`distribution[]` 的推荐结构：

```json
{
  "dimension": "人群",
  "summary": "当前样本中，人群信号主要来自家庭购买者、儿童/青少年使用者、伴侣礼物购买者和经常办聚会的人。",
  "count": 25,
  "sample_size": 76,
  "percentage": 32.9,
  "confidence": "high",
  "distribution": [
    {
      "label": "家庭购买者",
      "review_count": 18,
      "sample_size": 76,
      "percentage": 23.7,
      "role": "primary",
      "reason": "多条评论表达家庭购买、家庭使用或家庭聚会。",
      "evidence": ["karaoke with the family", "Our family has used this"]
    },
    {
      "label": "儿童/青少年使用者",
      "review_count": 10,
      "sample_size": 76,
      "percentage": 13.2,
      "role": "secondary",
      "reason": "评论明确提到 kids、daughter、son、grandchildren 等使用者。",
      "evidence": ["My 17 year old daughter loves this machine"]
    }
  ],
  "business_implication": "主要使用者不是单人唱歌用户，而是家庭/聚会场景中的多人娱乐用户。"
}
```

`distribution[]` 规则：

1. 每个维度都必须有 `distribution[]`；没有足够证据时，至少保留一个 `unknown` 类型。
2. `label` 必须是业务可读的人群、场景、任务、理由、期望、体验、满意点或不满意点，不能只写 `good`、`bad`、`quality` 这类泛词。
3. `review_count` 统计命中该类型的去重 Review 数，不统计 feedback_unit 数；同一 Review 多次表达同一类型只计 1 次。
4. `percentage = review_count / review_sample_size`，分母固定为 Review 样本数。
5. 同一条 Review 可以命中同一维度下多个类型，因此同一维度内各类型百分比允许合计超过 100%；报告必须说明这是多标签统计。
6. `role` 建议使用 `primary`、`secondary`、`long_tail`、`risk_signal`、`unknown`，用于标注主要矛盾、次要矛盾和长尾信号。
7. 每个非 `unknown` 类型必须有原文 evidence。
8. 分布表默认按 `role`、`review_count`、`percentage` 排序，先展示主要类型，再展示次要和长尾类型。
9. 主报告页展示分布表的 Top 8 到 Top 12；完整分布必须进入 Excel 的 `key_insight_distribution` sheet。

关键结论不得替代 VOC 主题地图。关键结论只负责“告诉用户应该怎么看”，VOC 主题地图负责“展示这个判断背后的主题证据结构”。

### VOC 主题地图

VOC 主题地图是主报告页中必须展示的章节，不得省略。它的作用是把 `voc_themes[]` 可视化为主题卡片，让用户看到每个主题的证据强度、严重度、置信度和动作方向。

每张主题卡片必须展示：

1. `theme_name`。
2. `theme_category`。
3. `count / sample_size / percentage`。
4. `severity`。
5. `priority`。
6. `confidence`。
7. `core_issue`。
8. `business_meaning`。
9. 最多 2 条短 evidence snippets。
10. `related_action_areas`。
11. 跳转到 VOC 主题详情页的入口。

展示规则：

1. 按 `theme_category` 分组。
2. 组内按 `priority`、`severity`、`count` 排序。
3. 必须展示所有进入前台规则的主题。
4. 不得只展示 Top N。
5. 主题卡片不得展开完整评论原文。
6. 点击主题卡片或详情按钮后，跳转到同一个 HTML 内的 VOC 主题详情页。

### VOC 主题详情页

VOC 主题详情页是同一个自包含 HTML 内的第二页面或详情视图。它不是外部网页，不需要本地 Web 服务。实现可以使用 hash anchor、内部视图切换或纯锚点跳转；即使 JavaScript 不可用，也应能通过锚点定位到对应主题详情区。

每个主题详情页必须展示：

1. 主题名称。
2. 主题类型。
3. `count / sample_size / percentage`。
4. 严重度、优先级、置信度。
5. 核心问题。
6. 归因假设。
7. 业务含义。
8. 关联业务动作。
9. 该主题相关的评论证据列表。
10. 返回主报告页的入口。

评论证据列表必须包含：

1. Review 序号。
2. rating。
3. review date。
4. review title。
5. 完整 Review 原文。
6. 完整中文翻译。
7. 黄色高亮的原文关键词、词组或短句。
8. 黄色高亮的中文翻译对应词、词组或短句。

高亮规则：

1. 原文高亮必须来自原始 Review text 中可定位的词、词组或短句。
2. 中文高亮必须对应原文高亮的语义位置。
3. 高亮背景使用黄色，例如 `background: #fff3a3`。
4. 一个主题可以有多个高亮片段。
5. 高亮片段必须和该主题的 `theme_evidence` 对应。
6. 不得高亮评论中没有支撑该主题的内容。

原文展示规则：

1. VOC 主题详情页默认展示该主题相关的完整 Review 原文。
2. VOC 主题详情页默认展示该主题相关的完整中文翻译。
3. 完整原文和完整中文翻译必须按 Review 一一对应展示。
4. 高亮只标出和当前主题相关的词、词组或短句，不高亮无关内容。
5. 同一条 Review 如果命中多个主题，可以出现在多个主题详情页；每个详情页只高亮与当前主题相关的片段。
6. 主报告页仍只展示短 evidence snippets，避免首页被长评论淹没。

### 机会矩阵与业务动作清单

每条业务动作必须展示：

1. 对应主题。
2. 业务发现。
3. 建议动作。
4. 优先级。
5. 优先级理由。
6. 影响指标。
7. 验证方式。
8. 原文证据。

### Review 编码层 Excel 交付物契约

从 v0.2.0 起，除中文自包含 HTML 报告外，必须额外交付一份 Review 编码层 `.xlsx` 文件。Excel 的作用是审计、复盘、二次分析和人工校正，不替代 HTML 报告。

Excel 文件命名：

```text
<ASIN>-review-coding-v<skill_version>.xlsx
```

### Excel 交付边界

1. Excel 展示完整 Review 编码明细，HTML 主报告不展示完整编码明细。
2. Excel 可以包含完整 Review 原文和 agent 生成的中文翻译。
3. Excel 不得包含 Sorftime key、运行时 token、环境变量值或私密备注。
4. Excel 的统计分母仍为 `review_sample_size`。
5. Excel 中的百分比字段必须和 HTML 报告一致。
6. Excel 的每一行都必须能追溯到 `review_index`、`feedback_unit_id` 或 `theme_id`。
7. Excel 只导出当前单 ASIN 的当次分析结果，不作为长期评论数据库。

### 必须包含的 Sheet

| Sheet | 用途 | 关键字段 |
| --- | --- | --- |
| `metadata` | 展示 ASIN、站点、抓取时间、样本数、ASIN 总评论数量、版本号 | `asin`、`site`、`generated_at`、`review_sample_size`、`asin_total_review_count`、`skill_version` |
| `normalized_reviews` | 展示规范化后的 Review 样本 | `review_index`、`variant`、`review_date`、`rating`、`title`、`text`、`raw_json` |
| `feedback_units` | 展示 Review 编码层的原子反馈 | `feedback_unit_id`、`review_index`、`audience`、`scenario`、`user_task`、`purchase_reason`、`user_expectation`、`actual_experience`、`satisfied_points`、`unsatisfied_points`、`consequence`、`evidence`、`confidence` |
| `open_tags` | 展示开放标签和归并关系 | `tag_id`、`feedback_unit_id`、`field`、`raw_value`、`normalized_tag`、`taxonomy_status`、`evidence`、`confidence` |
| `key_insight_distribution` | 展示八类关键结论下的完整类型/观点分布 | `dimension`、`label`、`review_count`、`sample_size`、`percentage`、`role`、`reason`、`evidence`、`theme_ids` |
| `voc_themes` | 展示 VOC 主题归因结果 | `theme_id`、`theme_name`、`theme_category`、`count`、`sample_size`、`percentage`、`severity`、`priority`、`confidence`、`core_issue`、`business_meaning` |
| `business_actions` | 展示业务动作清单 | `action_id`、`theme_id`、`action_area`、`business_finding`、`recommendation`、`priority`、`priority_reason`、`impact_metrics`、`validation_method`、`evidence` |
| `checkpoints` | 展示质量检查结果 | `checkpoint_id`、`name`、`status`、`message` |

### Excel 样式与可读性

1. 第一行冻结。
2. 所有 sheet 开启筛选。
3. 长文本列自动换行。
4. `status=fail` 使用浅红底，`status=warn` 使用浅黄底，`status=pass` 使用浅绿底。
5. `role=primary`、`role=secondary`、`role=risk_signal` 可用不同浅色底辅助识别主次矛盾。
6. 不合并单元格，避免影响筛选和复制。
7. 所有列名使用英文 snake_case，单元格内容可为中文或英文原文。

### Excel 契约检查

交付前必须检查：

1. `.xlsx` 文件可被 Excel 打开。
2. 必须 sheet 全部存在。
3. 必须列全部存在。
4. `key_insight_distribution` 覆盖八类维度。
5. 非 `unknown` 的分布项必须有 evidence。
6. `percentage` 与 `review_count / sample_size` 一致。
7. `feedback_units.evidence` 必须能在对应 Review 原文中定位。
8. 文件中不得出现 Sorftime key、运行时 token 或环境变量值。

## 10. SDD、BDD、TDD 落地方式

### SDD

SDD 负责把业务口径写成不可随意变动的规格源头。

放置位置：

```text
amazon-review-insight/references/specs/
```

必须覆盖：

1. Sorftime 工具契约。
2. 数据字段契约。
3. Review 样本数和 ASIN 总评论数量口径。
4. 分析规则。
5. 报告契约。
6. 用户确认规则。
7. v0.2.0 起，关键结论类型/观点分布契约。
8. v0.2.0 起，Review 编码层 Excel 交付物契约。

修改字段口径、报告章节或分析规则前，必须先更新对应 SDD 文件。

### BDD

BDD 负责约束用户可见行为。

放置位置：

```text
amazon-review-insight/references/features/
```

必须覆盖：

1. 单 ASIN 报告生成。
2. 缺失信息使用 `unknown`。
3. 无 evidence 不进入关键结论。
4. 报告中不展示完整 Review 编码明细。
5. 关键结论必须覆盖八类洞察。
6. v0.2.0 起，关键结论必须展示每个维度的类型/观点分布表。
7. v0.2.0 起，关键结论分布必须能区分主要类型、次要类型和长尾/风险信号。
8. v0.2.0 起，必须额外交付 Review 编码层 `.xlsx` 文件。
9. VOC 主题地图必须展示主题卡片。
10. 点击主题卡片必须进入同一个 HTML 内的 VOC 主题详情页。
11. 主题详情页必须展示完整 Review 原文、完整中文翻译和黄色高亮。

示例：

```gherkin
Feature: 单 ASIN Review 分析报告

Scenario: 用户输入单个 Amazon US ASIN 并生成中文 HTML 报告
  Given 用户提供一个合法 Amazon US ASIN
  And Sorftime MCP 返回 product_detail 和 product_reviews
  When agent 完成 Review 编码、VOC 主题归因和业务动作生成
  Then 系统生成中文自包含 HTML 报告
  And 报告展示 Review 样本数
  And 报告展示 ASIN 总评论数量
  And 关键结论覆盖人群、场景、用户任务、购买理由、用户期望、实际体验、满意点、不满意点
  And 关键结论展示每个维度的类型或观点分布表
  And 分布表展示提及 Review 数、样本占比、主次角色、原因和证据
  And 报告展示 VOC 主题地图
  And VOC 主题地图中的主题卡片可以跳转到 VOC 主题详情页
  And VOC 主题详情页展示该主题相关完整 Review 原文、完整中文翻译和黄色高亮
  And 报告展示机会矩阵与业务动作清单
  And 系统额外交付 Review 编码层 Excel 文件
```

```gherkin
Scenario: VOC 主题详情页高亮证据
  Given 报告中存在一个 VOC 主题卡片
  And 该主题包含 theme_evidence
  When 用户点击主题卡片
  Then 系统跳转到同一个 HTML 内的主题详情页
  And 详情页展示该主题相关的完整 Review 原文
  And 详情页展示该主题相关的完整中文翻译
  And 完整 Review 原文中的关键词、词组或短句使用黄色背景高亮
  And 完整中文翻译中对应词、词组或短句使用黄色背景高亮
  And 详情页提供返回主报告页的入口
```

### TDD

TDD 负责约束确定性代码。

放置位置：

```text
amazon-review-insight/tests/
```

必须先测试再实现的模块：

1. ASIN 输入校验。
2. Sorftime response parser。
3. 中文字段映射。
4. Review 日期转换。
5. Review 星级转换。
6. Review 去重。
7. Review 样本数计算。
8. ASIN 总评论数量解析。
9. 星级分布计算。
10. 好评和差评占比计算。
11. checkpoint 状态计算。
12. HTML 报告章节渲染。
13. VOC 主题详情页渲染。
14. 证据高亮渲染。
15. 关键结论 `distribution[]` 百分比计算和多标签口径校验。
16. 关键结论分布表渲染。
17. Review 编码层 Excel workbook 导出。
18. Excel 必须 sheet 和必须列校验。
19. Excel 百分比和 evidence 定位校验。
20. 密钥扫描。

## 11. Tests、Checkpoints、Evals

### Tests

`tests` 验证确定性逻辑，不依赖实时 Sorftime MCP。默认使用人工合成 fixture，保留 Sorftime 字段形状，不包含真实 key 和未脱敏个人信息。

建议目录：

```text
tests/
  fixtures/
    sorftime_single_asin_reviews.json
    sorftime_empty_reviews.json
    sorftime_missing_fields.json
    golden_analysis_single_asin.json
  unit/
    asin-input.test.ts
    sorftime-response-parser.test.ts
    review-normalizer.test.ts
    review-health-metrics.test.ts
    report-renderer.test.ts
    key-insight-distribution.test.ts
    excel-exporter.test.ts
    secret-scan.test.ts
  integration/
    pipeline-with-mock-data.test.ts
    agent-contract-check.test.ts
    excel-export-with-mock-data.test.ts
    sorftime-live-smoke.test.ts
```

`sorftime-live-smoke.test.ts` 只在发布前或维护者本地显式运行，使用固定测试 ASIN `B0DHPN1DMJ`，不对实时 Review 样本数做固定断言。

### Checkpoints

`checkpoints` 嵌入每次实际分析。每个 checkpoint 输出 `pass`、`warn`、`fail`。

1. `fail` 阻止进入下一阶段。
2. `warn` 允许继续，但必须进入报告限制说明。
3. `pass` 记录为已通过。

v0.1.0 checkpoint：

1. 输入校验。
2. Sorftime MCP 抓取。
3. 数据质量。
4. Review 编码检查。
5. VOC 主题检查。
6. 统计计算检查。
7. 业务动作检查。
8. HTML 报告检查。
9. Product Design 视觉 QA。
10. 密钥扫描。

v0.2.0 新增 checkpoint：

1. 关键结论分布检查。
2. Excel 导出检查。
3. Excel schema 检查。

关键 fail 规则：

1. 非法 ASIN。
2. Sorftime MCP 连接失败。
3. 所有 Review 样本数为 0。
4. Review text 存在率低于 60%。
5. rating 存在率低于 60%。
6. 非 `unknown` 字段缺少 evidence。
7. evidence 在原 Review text 中找不到。
8. percentage 与 `count / sample_size` 不一致。
9. 关键结论没有 evidence。
10. 业务动作没有绑定主题和 evidence。
11. HTML 报告缺少核心章节。
12. 关键结论没有覆盖八类洞察，且未对缺失项写 `unknown`。
13. v0.2.0 起，关键结论缺少 `distribution[]`。
14. v0.2.0 起，关键结论分布项缺少 `label`、`review_count`、`percentage`、`role`、`reason` 或 evidence。
15. v0.2.0 起，关键结论分布百分比与 `review_count / review_sample_size` 不一致。
16. v0.2.0 起，Excel 文件缺失、无法打开、缺少必须 sheet 或缺少必须列。
17. VOC 主题地图缺失主题卡片。
18. 主题卡片缺少详情页入口。
19. VOC 主题详情页缺少证据列表。
20. 高亮文本无法在原 Review text 或中文翻译中定位。
21. 报告样式未使用已确认的 Product Design report assets。
22. 主题详情页在移动端出现文字重叠、横向溢出不可读或高亮不可见。
23. 报告、Excel 或缓存中发现 Sorftime key。

关键 warn 规则：

1. Review 样本数低于 20。
2. Review date 存在率低于 70%。
3. 重复 Review 占比达到 5%。
4. 关键主题 evidence_count 小于 3。
5. Vine 字段缺失，展示 `unknown`。

### Evals

`evals` 评估 agent 分析质量，防止只靠人工感觉验收。

v0.1.0 建议固定 7 个 eval：

1. `eval_01_single_asin_basic`：数据范围、健康度、报告章节完整。
2. `eval_02_unknown_handling`：Review 未表达的信息必须为 `unknown`。
3. `eval_03_evidence_fidelity`：所有非 unknown 观点必须由原文支持。
4. `eval_04_granular_pain_points`：宽泛问题必须拆到可行动颗粒度。
5. `eval_05_low_sample_warning`：低样本不得写成强结论。
6. `eval_06_business_action_specificity`：产品、Listing、图片/视频动作必须具体可执行。
7. `eval_07_theme_detail_page`：VOC 主题卡片可进入详情页，详情页完整 Review 原文、完整中文翻译和黄色高亮正确。

v0.2.0 新增 2 个 eval：

8. `eval_08_key_insight_distribution`：关键结论必须在八类维度下展示类型/观点分布，能区分主要类型、次要类型、长尾和风险信号。
9. `eval_09_review_coding_excel`：Review 编码层 Excel 文件必须存在，sheet、列、百分比、evidence 和密钥安全检查正确。

v0.1.0 评分权重：

| 维度 | 分值 |
| --- | ---: |
| 证据忠实度 | 35 |
| unknown 使用 | 15 |
| Review 编码完整度 | 15 |
| 主题粒度和归因质量 | 15 |
| 业务动作可执行性 | 15 |
| 报告契约一致性 | 5 |

v0.2.0 评分权重：

| 维度 | 分值 |
| --- | ---: |
| 证据忠实度 | 30 |
| unknown 使用 | 10 |
| Review 编码完整度 | 15 |
| 主题粒度和归因质量 | 10 |
| 业务动作可执行性 | 10 |
| 报告契约一致性 | 5 |
| 关键结论分布质量 | 10 |
| Excel 交付质量 | 10 |

通过线：

1. 单个 eval 得分达到 80。
2. v0.1.0 的 7 个 eval 平均分达到 85。
3. v0.2.0 的 9 个 eval 平均分达到 85。
4. 证据忠实度单项不得低于 32。
5. 出现编造 evidence 时该 eval 直接失败。
6. 出现统计分母错误时该 eval 直接失败。
7. 出现非 unknown 字段无 evidence 时该 eval 直接失败。
8. v0.2.0 起，关键结论缺少分布表时 `eval_08` 直接失败。
9. v0.2.0 起，Excel 缺少必须 sheet 或无法打开时 `eval_09` 直接失败。

## 12. 缓存策略

v0.1.0 已确认保留轻量本地缓存，用于复盘、debug 和避免重复抓取。缓存不是最终交付物。

目录：

```text
.cache/asin-review-insight/
```

允许缓存：

1. Sorftime 原始响应。
2. normalized reviews。
3. agent 生成的 analysis JSON。
4. checkpoint 结果。
5. 渲染后的任务内 report HTML。
6. v0.2.0 起，任务内生成的 Review 编码层 `.xlsx`。
7. cache metadata。

禁止缓存：

1. Sorftime key。
2. `.env`。
3. 运行时 token。
4. 用户私密备注。
5. 未脱敏的外部私有数据。

缓存规则：

1. `.cache/asin-review-insight/` 必须写入 `.gitignore`。
2. 缓存默认保留 7 天。
3. `force_refresh=true` 时重新调用 Sorftime MCP。
4. 重新抓取失败时不得覆盖旧缓存。
5. 交付给用户的 HTML 和 Excel 必须复制到 `outputs/` 或用户指定位置，并且不依赖 `.cache/`。
6. v0.1.0 不做复杂缓存索引、远程缓存、跨机器缓存和长期历史库。

## 13. 密钥与安全规则

1. Sorftime key 只能来自用户当次明确提供、环境变量 `SORFTIME_MCP_KEY`、或用户授权的运行环境。
2. 不得把 Sorftime key 写入 `SKILL.md`、`references/`、`tests/fixtures/`、`evals/`、缓存、报告、Excel、日志。
3. 不得在报告或 Excel 中展示 key、token、环境变量值。
4. secret scan 发现密钥时，CI 和发布流程必须失败。
5. 发现已提交真实 key 时，必须立即撤销该 key，并发布安全修复版本。
6. 公开 fixture 必须使用人工合成数据，不提交真实 Sorftime 原始响应。
7. 主报告页只展示短摘录；VOC 主题详情页默认展示该主题相关完整 Review 原文和完整中文翻译。
8. v0.2.0 起，Review 编码层 Excel 必须纳入 secret scan 范围。

## 14. 发布、版本迭代与生命周期

### 版本规则

使用 SemVer：`MAJOR.MINOR.PATCH`。

v0 阶段规则：

1. `v0.1.0` 表示第一版可用 Codex agent skill。
2. PATCH：bug fix、解析修复、文案修复、测试修复。
3. MINOR：新增报告章节、新增 eval、新增 checkpoint、新增分析能力。
4. MAJOR：破坏数据契约、报告契约、安装方式或 Sorftime 工具路径。

独立版本字段：

| 对象 | 字段 | 位置 |
| --- | --- | --- |
| skill | `skill_version` | `SKILL.md` |
| 数据契约 | `data_contract_version` | `references/specs/data-contract.md` |
| 报告契约 | `report_contract_version` | `references/specs/report-contract.md` |
| Sorftime 契约 | `sorftime_contract_version` | `references/specs/sorftime-contract.md` |
| 分析规则 | `analysis_rules_version` | `references/specs/analysis-rules.md` |
| eval 数据集 | `eval_dataset_version` | `evals/data/golden_labels.json` |

### 生命周期

| 阶段 | 触发条件 | 维护规则 |
| --- | --- | --- |
| `alpha` | 内部可运行 | 不承诺兼容性 |
| `beta` | 外部小范围试用 | 接收 issue，允许破坏性变更 |
| `stable` | v1.0.0 发布 | 破坏性变更必须升 MAJOR |
| `deprecated` | 新版本替代旧版本 | 保留 90 天迁移期 |
| `archived` | 停止维护 | 仓库只读并标注停止维护 |

### 发布前检查

发布前必须按顺序完成：

1. `main` 分支 CI 通过。
2. `CHANGELOG.md` 写入目标版本。
3. `SKILL.md` 版本号更新。
4. SDD specs 版本号更新。
5. eval dataset 版本号更新。
6. unit tests 通过。
7. integration tests 通过。
8. checkpoint mock pipeline 通过。
9. eval smoke 通过。
10. `sorftime-live-smoke.test.ts` 使用 `B0DHPN1DMJ` 通过。
11. 确认 Product Design report assets 已更新且被 `render_report.ts` 使用。
12. 生成单 ASIN sample HTML report。
13. v0.2.0 起，生成单 ASIN sample Review 编码层 Excel。
14. v0.2.0 起，Excel schema、sheet、列、百分比和 evidence 检查通过。
15. 执行 Product Design 视觉 QA。
16. 人工检查 sample HTML report。
17. v0.2.0 起，人工检查 sample Excel。
18. secret scan 通过，且覆盖 HTML、Excel、缓存和 release assets。
19. 清理缓存验证通过。
20. 创建 Git tag。
21. 创建 GitHub Release。
22. 发布后用 release 包重新安装并运行 smoke test。

任一步失败时停止发布。

### Release 产物

每个 release 包含：

1. skill zip 包。
2. `SHA256SUMS.txt`。
3. `CHANGELOG.md` 摘要。
4. 辅助 CLI 脚本。
5. 使用真实 Sorftime 数据生成的单 ASIN sample report。
6. sample input。
7. sample output JSON。
8. v0.2.0 起，使用真实 Sorftime 数据生成的单 ASIN sample Review 编码层 Excel。
9. compatibility matrix。
10. migration notes。
11. known limitations。

v0.1.0 sample report 固定使用真实 Sorftime 数据生成，默认测试 ASIN 为 `B0DHPN1DMJ`。sample report 不得包含 Sorftime key、环境变量值或运行时 token。

## 15. 实施顺序

当前阶段先只写计划，不创建 skill。

后续执行阶段建议顺序：

1. 确认计划文件。
2. 确认 skill 名称和目标目录。
3. 使用 `skill-creator` 初始化 skill 骨架。
4. 写 `SKILL.md`。
5. 写 SDD specs。
6. 写 BDD feature 文件。
7. 写 checkpoint 定义。
8. 使用 Product Design 插件确认 HTML 报告视觉设计 brief。
9. 使用 Product Design 插件产出并确认报告视觉方向。
10. 将确认后的设计沉淀为 `assets/report/design-tokens.json`、`assets/report/report.css`、`assets/report/report-layout.md`。
11. 写 mock fixtures。
12. 写 parser、normalizer、metrics、renderer、contract check、secret scan 脚本。
13. v0.2.0 起，写关键结论分布计算与校验逻辑。
14. v0.2.0 起，写 Review 编码层 Excel exporter。
15. 写 unit tests 和 integration tests。
16. 写 eval tasks 和 rubrics。
17. 运行 mock pipeline。
18. 验证 Sorftime MCP，测试 ASIN 使用 `B0DHPN1DMJ`。
19. 生成 sample HTML report。
20. v0.2.0 起，生成 sample Review 编码层 Excel。
21. 使用 Product Design 插件做视觉 QA。
22. 运行发布前检查。
23. 补齐 GitHub 项目治理文件。
24. 准备 release。

## 16. 验收标准

v0.1.0 计划进入实现前，需要确认：

1. 只做 Codex agent skill。
2. 只做单个 ASIN。
3. 只做 Amazon US。
4. 只用 Sorftime MCP。
5. 不做本地 Web 工作台。
6. 不做外接 LLM provider。
7. 报告固定中文 HTML，v0.2.0 起额外交付 Review 编码层 Excel。
8. Review 样本数和 ASIN 总评论数量口径固定。
9. SDD、BDD、TDD、tests、checkpoints、evals 都要落地。
10. GitHub 发布治理必须保留。
11. HTML 报告样式使用 Product Design 插件完成设计。
12. v0.2.0 起，关键结论必须包含类型/观点分布表。

实现完成后，需要确认：

1. skill frontmatter 合法。
2. `SKILL.md` 正文包含 `skill_version`，且版本号与 release 版本一致。
3. `agents/openai.yaml` 存在且匹配 skill。
4. `references/specs/` 文件存在。
5. `references/features/` 文件存在。
6. tests 通过。
7. checkpoints 可执行。
8. eval smoke 通过。
9. live smoke 可用。
10. sample HTML report 使用真实 Sorftime 数据生成并可打开。
11. 辅助 CLI 脚本可执行。
12. `assets/report/design-tokens.json`、`assets/report/report.css`、`assets/report/report-layout.md` 存在。
13. `render_report.ts` 使用已确认的 Product Design report assets。
14. Product Design 视觉 QA 通过。
15. secret scan 通过。
16. v0.2.0 起，关键结论分布表覆盖八类洞察。
17. v0.2.0 起，Review 编码层 Excel 生成成功并通过 schema 检查。
18. v0.2.0 起，sample Excel 使用真实 Sorftime 数据生成并可打开。

## 17. 已确认决策

1. skill 名称固定为 `amazon-review-insight`。
2. `SKILL.md` 正文必须说明版本号，初始为 `v0.1.0`，并跟随版本迭代和生命周期规则更新。
3. GitHub release 发布 skill 包，同时发布辅助 CLI 脚本。
4. v0.1.0 sample HTML report 使用真实 Sorftime 数据生成，默认测试 ASIN 为 `B0DHPN1DMJ`。
5. HTML 报告视觉风格使用 Product Design 插件设计，并沉淀为 `assets/report/` 资源。
6. v0.1.0 保留轻量本地缓存：只缓存 7 天，缓存目录写入 `.gitignore`，不得缓存 Sorftime key。

## 18. 决策日志

决策日志用于记录 skill 迭代中的关键产品和工程决策。每条记录必须说明：现状是什么、决策是什么、为什么做出这个改变、影响哪个版本、需要改哪些契约或交付物。

| 日期 | 现状 | 决策 | 为什么做出这个改变 | 影响版本 | 影响范围 |
| --- | --- | --- | --- | --- | --- |
| 2026-06-15 | v0.1.0 的关键结论以一句话摘要、总 count、总 percentage 和少量 evidence 为主，例如“人群信号主要来自家庭购买者、儿童/青少年使用者、伴侣礼物购买者和经常办聚会的人”。这种表达能快速总结，但不能看清各类型的提及数量、占比和主次关系。 | 从 v0.2.0 起，关键结论升级为“单句摘要 + 类型/观点分布表 + 主次矛盾判断 + 业务解读”。每个维度必须包含 `distribution[]`。 | 用户需要判断主要使用者、次要使用者、主要场景、次要场景、主要满意点和次要痛点。只有一句摘要会掩盖主要矛盾和次要矛盾，不利于用户洞察、产品改进和 Listing 优化。 | v0.2.0 | `analysis-rules.md`、`report-contract.md`、`agent_contract_check.ts`、`render_report.ts`、evals、sample report |
| 2026-06-15 | v0.1.0 的 Review 编码层是 agent 内部分析产物，只在 HTML 报告中通过主题、证据和详情页间接呈现，不单独交付完整编码明细。 | 从 v0.2.0 起，新增 Review 编码层 `.xlsx` 交付物，包含 `normalized_reviews`、`feedback_units`、`open_tags`、`key_insight_distribution`、`voc_themes`、`business_actions` 和 `checkpoints` 等 sheet。 | 用户需要审计编码、复盘判断、二次分析和人工校正。Excel 更适合筛选、排序、复制和对照原文；HTML 继续作为阅读和决策报告，不承载完整编码明细。 | v0.2.0 | `export_review_coding_excel.ts`、CLI、tests、checkpoints、release assets、sample Excel |
| 2026-06-15 | v0.1.0 的“不做 CSV、XLSX、PDF 导出”适用于首版范围，但与后续 Review 编码层审计需求冲突。 | 调整边界为：仍不做 CSV 和 PDF；从 v0.2.0 起只新增 Review 编码层 Excel，不把 Excel 作为主报告替代物。 | 这样既满足编码层审计需求，又避免 scope 膨胀成通用报表导出工具。 | v0.2.0 | v0.2.0 范围、Release 产物、验收标准 |
| 2026-06-15 | v0.1.0 的质量门禁主要检查 HTML、主题详情、高亮、业务动作和密钥安全。 | 从 v0.2.0 起，新增关键结论分布检查、Excel schema 检查、Excel evidence 检查、Excel secret scan。 | 新增交付物必须进入 tests、checkpoints 和 evals，否则 Excel 容易成为未受控的旁路输出。 | v0.2.0 | TDD、tests、checkpoints、evals、发布前检查 |
