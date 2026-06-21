---
title: 'Amazon Review Insight Codex Agent Skill v0.3.0 迭代计划'
status: raw
created: '2026-06-17 14:47'
source_type: unknown
material_type: 方案
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Skill'
  - 'LLM'
---

# Amazon Review Insight Codex Agent Skill v0.3.0 迭代计划

计划版本：v0.3.0-plan  
目标 skill 名称：`amazon-review-insight`  
计划日期：2026-06-15  
构建形态：Codex agent skill  
基线版本：v0.2.1  
目标版本：v0.3.0  

## 1. 迭代定位

v0.3.0 是在 v0.2.1 的基础上，对 HTML 报告中的 `VOC 主题地图` 做分析深度和阅读交互升级。

v0.2.1 已经解决：

1. 关键结论有八个维度和类型分布。
2. Review 编码层 Excel 可读性增强，一行解释一个 feedback unit。
3. HTML 中 VOC 主题卡片可以跳到主题详情页。

v0.3.0 要解决的新问题：

1. 当前 VOC 主题地图只展示主题级卡片，例如“音质/麦克风体验”“应用/订阅边界”等。
2. 主题卡片虽然有提及数量和占比，但没有像关键结论一样穷举该主题下面的具体观点。
3. 用户看不到每个 VOC 主题内部到底有哪些主要观点、次要观点、长尾观点和风险观点。
4. 当前主题详情页是主题级评论集合，不支持点击某个具体观点后，只查看该观点相关的全量评论。

v0.3.0 的核心目标：

> VOC 主题地图从“主题卡片”升级为“主题卡片 + 主题内观点分布 + 新标签主题详情页 + 详情页内观点筛选”。

## 2. v0.3.0 必须做

1. `voc_themes[]` 增加 `viewpoints[]` 字段。
2. 每个 VOC 主题必须穷举该主题下的具体观点。
3. 每个观点必须有提及 Review 数量、样本数、占比、角色、判断依据和证据；角色保留在分析数据和 Excel 中用于复核，HTML 主报告不展示角色列或角色徽标。
4. HTML 的 VOC 主题卡片中展示观点分布，视觉逻辑类似关键结论分布表，并以一行一个默认展开的可折叠主题块呈现。
5. 用户点击 VOC 主题卡片时，当前主报告页不得滚动跳转；浏览器必须在新标签页打开该主题详情页。
6. 主题详情页上方 sticky 面板在同一个卡片内显示该 VOC 主题卡片和观点筛选入口。
7. 主题详情页默认列出支撑该主题的全量评论原文和中文翻译。
8. 用户在主题详情页中点击某个观点时，当前标签页筛选出与该观点相关的全量评论。
9. 主题详情页和观点筛选状态中，原文和译文必须高亮支撑主题或观点的词、词组或短句。
10. 更新 HTML report contract、data contract、BDD、tests、checkpoints、evals。
11. 更新 Product Design report assets，支持 sticky VOC 主题卡片、主题详情页和观点筛选阅读体验。
12. 左侧一级导航和二级导航都必须带序号；“3. 关键结论”和“4. VOC 主题地图”这两个带二级导航的一级导航必须默认展开并支持折叠；正文中不重复渲染“八类横向洞察”或“主题与观点分布”副标题；每个一级章节标题下方不展示说明文字；关键结论、VOC 主题和业务动作都必须是一行一个默认展开的可折叠块。
13. 关键结论和 VOC 主题地图标题右上角必须有问号 tooltip，解释两者区别；摘要 chip 必须带中文标签，不得只展示裸值。
14. 机会矩阵与业务动作必须按方向拆分，不得渲染为单个横向大表。
15. HTML 报告只维护电脑端桌面布局，不再做移动端媒体查询或移动端特化样式。
16. VOC 主题优先级必须改成运营可读口径：HTML 展示“运营优先级”及动作语义，不得裸展示 `P0/P1/P2`；每个主题必须展示“运营动作”，说明运营下一步应放大、澄清、止损还是排期补齐。

## 3. v0.3.0 不做

1. 不做多 ASIN 分析。
2. 不做竞品对比。
3. 不做本地 Web 工作台。
4. 不接外部 LLM provider。
5. 不把报告拆成多个 HTML 文件。
6. 不做 CSV 或 PDF 导出。
7. 不改变关键结论八维度的基本结构。
8. 不把观点筛选做成需要后端服务的动态页面。

## 4. 核心决策

### 决策 1：仍交付单个自包含 HTML

用户最终确认的交互是“点击主题卡片打开新标签页查看主题全量评论；在新标签页内点击观点进行评论筛选”。

v0.3.0 默认实现为：

1. 仍生成一个自包含 `.html` 文件。
2. 每个主题详情页是同一个 HTML 内的独立 section。
3. 点击主题卡片后通过 `target="_blank"` 与 `rel="noopener"` 在新标签页打开对应 hash 详情视图，例如：

```text
#theme-detail-theme_sound_power_mic
```

主题详情页默认展示该主题的全量评论；点击主题详情页内的观点筛选控件时，不再打开新标签页，而是在当前标签页筛选出该观点相关的全量评论。这样既满足“打开新标签页/新页面阅读”，又保持当前 skill 的交付边界：用户只拿到一个 HTML 文件即可离线打开。

补充约束：

1. `#theme-detail-<theme_id>` 必须表现为独立详情视图，而不是普通长文档锚点滚动。
2. 新标签页进入主题详情后，只显示当前主题详情 section，隐藏目录、主报告其它章节和其它主题详情 section。
3. 用户在新标签页向上或向下滚动时，不得看到其它 VOC 主题卡片或主报告内容。
4. 主题级摘要只在顶部 sticky 详情面板的主题区中完整展示；观点筛选入口必须与主题区合并在同一个卡片内，不能拆成上下两个独立卡片，也不得重复渲染同一主题标题、核心问题、归因假设或业务含义。

### 决策 2：VOC 主题和 VOC 观点分层

VOC 主题不是最终最小观点。

| 层级 | 作用 | 例子 |
| --- | --- | --- |
| VOC 主题 | 一组相关用户声音形成的业务问题或机会域 | 音质、音量和麦克风体验是核心强项 |
| VOC 观点 | 主题内部可统计、可点击、可追溯的具体观点 | 音量大；低音强；麦克风清晰；麦克风收纳充电方便 |
| Review 证据 | 支撑某个观点的原文评论 | “great sound”“mics are good”“excellent volume” |

### 决策 3：观点分布允许重叠

同一条 Review 可以同时属于同一个 VOC 主题下的多个观点。

例如一条 Review 同时说：

1. sound quality is good
2. excellent volume
3. microphones are stored within the speaker

则它可以同时计入：

1. `音质好`
2. `音量大`
3. `麦克风收纳方便`

因此，同一 VOC 主题下的观点百分比允许合计超过 100%。报告中必须说明这是多标签提及率。

## 5. 数据结构设计

### `voc_themes[].viewpoints[]`

新增字段示例：

```json
{
  "theme_id": "theme_sound_power_mic",
  "theme_name": "音质、音量和麦克风体验是核心强项",
  "count": 62,
  "sample_size": 100,
  "percentage": 62,
  "viewpoints": [
    {
      "viewpoint_id": "vp_sound_quality",
      "viewpoint_name": "音质清晰有力",
      "viewpoint_polarity": "positive",
      "review_count": 54,
      "sample_size": 100,
      "percentage": 54,
      "role": "primary",
      "reason": "大量评论直接提到 great sound、sound quality、clear、powerful。",
      "tag_ids": ["tag_sound_power_quality"],
      "review_indexes": [1, 3, 4, 10],
      "evidence": ["sound quality is good", "great sound", "sounds better"],
      "business_meaning": "这是主图、视频和标题中最应该被放大的核心卖点。",
      "detail_reviews": []
    }
  ]
}
```

### `ThemeViewpoint` 字段

| 字段 | 作用 | 规则 |
| --- | --- | --- |
| `viewpoint_id` | 观点稳定 ID | 同一报告内唯一，建议以 `vp_` 开头 |
| `viewpoint_name` | 观点名称 | 必须业务可读，不能只写关键词 |
| `viewpoint_polarity` | 观点极性 | `positive`、`negative`、`mixed`、`neutral` |
| `review_count` | 命中该观点的去重 Review 数 | 同一 Review 多次表达只计 1 次 |
| `sample_size` | Review 样本数 | 固定等于 `metadata.review_sample_size` |
| `percentage` | 提及占比 | `review_count / sample_size` |
| `role` | 主次角色 | `primary`、`secondary`、`emerging`、`long_tail`、`risk_signal`、`unknown` |
| `reason` | 判断依据 | 必须基于 Review 原文 |
| `tag_ids` | 来源开放标签 | 可多个 |
| `review_indexes` | 关联 Review 序号 | 必须与详情评论可追溯 |
| `evidence` | 代表证据 | 非 unknown 必须有 |
| `business_meaning` | 业务含义 | 说明这个观点能用于产品、Listing 或图片视频的哪个决策 |
| `detail_reviews` | 全量观点评论 | 该观点相关的所有评论原文、中文翻译和高亮 |

### `detail_reviews[]` 复用主题详情结构

每个 viewpoint 的 `detail_reviews[]` 必须包含：

```json
{
  "review_index": 1,
  "rating": 5,
  "review_date": "2026-04-25",
  "title": "Great Sound, Great Times...",
  "text": "Original full review text",
  "translation": "完整中文翻译",
  "highlight_terms": ["great sound", "excellent volume"],
  "translation_highlight_terms": ["声音很好", "音量很棒"]
}
```

规则：

1. `text` 必须是完整 Review 原文。
2. `translation` 必须是完整中文翻译。
3. `highlight_terms` 必须能在 `text` 中定位。
4. `translation_highlight_terms` 必须能在 `translation` 中定位。
5. `detail_reviews.length` 必须等于该观点命中的去重 Review 数，除非报告明确标记为截断；v0.3.0 默认不截断。

## 6. VOC 主题地图 HTML 改造

### 当前结构

当前 VOC 主题地图主要是主题卡片：

1. 主题名称。
2. 主题类型。
3. 运营优先级。
4. 提及数量和占比。
5. 核心问题。
6. 业务含义。
7. 代表证据。

### v0.3.0 目标结构

每个 VOC 主题卡片升级为：

1. 主题标题。
2. 主题元信息：`运营优先级`、`severity`、`count/sample_size/percentage`、`confidence`；运营优先级必须带动作语义，例如 `P0 立即放大卖点`、`P1 本轮澄清预期`、`P2 排期补齐体验`。
3. 主题一句话核心问题。
4. 主题业务含义。
5. 运营动作，回答运营下一步应放大、澄清、止损还是排期补齐。
6. 主题内观点分布表。
7. 主题卡片整体可点击，并在新标签页打开主题详情页。
8. 主报告页中的观点分布表用于预览主题下观点构成；观点筛选发生在主题详情页内。
9. 主题卡片在主报告中一行一个块，默认展开，并支持折叠。

运营优先级不是严重度，也不是抽象排序：

- `P0`：立即处理。正向购买驱动主题用于立即放大转化主卖点；负向、风险或预期落差主题用于立即止损。
- `P1`：本轮迭代处理，用于澄清预期、闭环风险或放大已验证机会。
- `P2`：排期优化，用于低成本补齐体验、补强信任或进入后续页面/素材/客服优化池。

### 观点分布表列

| 列 | 内容 |
| --- | --- |
| 观点 | `viewpoint_name` |
| 提及占比 | `review_count/sample_size (percentage%)` |
| 极性 | `viewpoint_polarity` |
| 判断依据 | `reason` |

说明：`role` 仍是分析数据和 Excel 复核字段，但不再进入 HTML 主报告的观点分布表。

### 点击行为

点击 VOC 主题卡片时，新标签页打开：

```text
#theme-detail-<theme_id>
```

示例：

```text
#theme-detail-theme_sound_power_mic
```

进入主题详情页后，点击该主题下的观点筛选按钮，不再新开标签页，而是在当前主题详情页内筛选出对应观点的全量评论。

## 7. 主题详情页与观点筛选设计

### 页面结构

每个主题详情页包含：

1. 顶部 sticky 详情面板，VOC 主题卡片和观点筛选入口合并在同一个卡片内。
2. 观点筛选入口，包含“全部主题评论”和该主题下每个观点。
3. 当前筛选摘要条。
4. 默认展示支撑该主题的全量相关评论列表。
5. 点击观点后展示该观点统计：`review_count/sample_size/percentage`、`role`、`polarity`、`confidence`、判断依据和业务含义。
6. 返回 VOC 主题地图入口。

进入 `#theme-detail-<theme_id>` 后，页面必须隐藏目录、主报告其它 section 和其它主题详情 section，只保留当前主题详情。这样用户把它当作新标签“主题详情页”阅读时，不会在滚动中看到无关主题或主报告内容。

### Sticky VOC 主题卡片

sticky 卡片展示主题级信息，而不是观点级信息：

1. VOC 主题名称。
2. 主题类型。
3. 运营优先级。
4. 严重度。
5. 主题提及数量和占比。
6. 核心问题。
7. 业务含义。
8. 运营动作。

目的：

用户进入某个主题详情页并筛选观点后，始终知道当前观点属于哪个更大的 VOC 主题。

### 评论列表

每条评论展示：

1. Review 序号。
2. 星级。
3. 评论日期。
4. title。
5. 完整原文。
6. 完整中文翻译。
7. 黄色高亮词、词组或短句。

默认评论列表必须是该主题相关的全量评论，不只展示代表性片段。点击某个观点后，评论列表必须切换为该观点相关的全量评论。

## 8. VOC 主题地图与关键结论的边界

### 关键结论

关键结论回答八个跨主题问题：

1. 人群是谁。
2. 场景是什么。
3. 用户任务是什么。
4. 购买理由是什么。
5. 用户期望是什么。
6. 实际体验是什么。
7. 满意点是什么。
8. 不满意点是什么。

它是横向洞察层，用于快速理解用户和业务。

### VOC 主题地图

VOC 主题地图回答：

1. 用户声音被归并成哪些主题。
2. 每个主题下有哪些具体观点。
3. 每个观点分别有多少 Review 支撑。
4. 每个观点的全量原文证据是什么。
5. 这些观点如何转化为产品、Listing、图片视频或售后动作。

它是主题归因层和证据追溯层。

### 不能重复的部分

1. 关键结论可以引用 VOC 主题，但不要展开主题内所有观点详情。
2. VOC 主题地图可以承载观点分布，但不要重复八个关键结论维度。
3. 主题详情页和观点筛选只服务证据追溯，不做新的业务动作长篇解释。

## 9. Excel 交付物影响

v0.3.0 建议新增两个 sheet：

| Sheet | 用途 |
| --- | --- |
| `VOC主题观点` | 每个 VOC 主题下的观点分布 |
| `VOC观点评论明细` | 每个观点关联的全量 Review 原文、译文和高亮词 |

### `VOC主题观点` 字段

1. `主题ID`
2. `主题名称`
3. `观点ID`
4. `观点名称`
5. `观点极性`
6. `提及评论数`
7. `样本数`
8. `占比`
9. `角色`
10. `判断依据`
11. `业务含义`
12. `开放标签ID`
13. `关联Review序号`
14. `代表证据`
15. `置信度`

### `VOC观点评论明细` 字段

1. `主题ID`
2. `主题名称`
3. `观点ID`
4. `观点名称`
5. `Review序号`
6. `ASIN`
7. `评论日期`
8. `星级`
9. `title`
10. `text`
11. `中文翻译`
12. `原文高亮词`
13. `译文高亮词`

## 10. 分析规则

### 观点来源

观点优先从 `feedback_units[]` 和 `open_tags[]` 聚合，不直接从 theme 名称反推。

推荐流程：

1. 先对每条 Review 拆 `feedback_units[]`。
2. 每个 feedback unit 绑定一个或多个开放标签。
3. 开放标签归入 VOC 主题。
4. 同一主题内，把业务含义接近的开放标签聚合成 viewpoint。
5. 每个 viewpoint 记录命中的去重 Review 序号。
6. 每个 viewpoint 生成全量 `detail_reviews[]`。

### 观点命名规则

观点名称必须满足：

1. 用户读完能知道具体观点是什么。
2. 不写泛词，例如 `体验问题`、`产品好`、`不满意`。
3. 尽量使用业务语言，例如 `HDMI 仅视频导致家庭影院连接预期落差`。
4. 正向观点和负向观点分开，不混在一个观点里。

### 角色判定规则

| role | 含义 |
| --- | --- |
| `primary` | 主题内最主要观点 |
| `secondary` | 主题内稳定次要观点 |
| `emerging` | 新兴信号 |
| `long_tail` | 长尾信号 |
| `risk_signal` | 低频但高伤害风险 |
| `unknown` | 无法明确判断 |

## 11. Contract Check 更新

`contract:check` 必须新增以下校验：

1. 每个 `voc_theme` 必须包含 `viewpoints[]`。
2. 每个 `viewpoint` 必须有 `viewpoint_id`、`viewpoint_name`、`review_count`、`sample_size`、`percentage`、`role`、`reason`、`evidence`。
3. `viewpoint.percentage` 必须等于 `review_count / sample_size`。
4. 非 unknown viewpoint 必须有 evidence。
5. `viewpoint.review_indexes` 不得为空。
6. `viewpoint.detail_reviews` 不得为空。
7. `detail_reviews[].text` 必须是完整原文。
8. `detail_reviews[].translation` 不得为空。
9. `highlight_terms` 必须能在原文中定位。
10. `translation_highlight_terms` 必须能在译文中定位。
11. HTML 必须存在主题详情页 anchor。
12. HTML 主题卡片链接必须使用 `target="_blank"` 与 `rel="noopener"`。
13. HTML 必须存在 sticky VOC 主题卡片。
14. HTML 主题详情页必须存在“全部主题评论”和观点筛选入口。
15. HTML 主题详情页评论必须带有观点筛选数据。
16. Excel 如生成 `VOC主题观点` 和 `VOC观点评论明细`，必须校验 sheet 和字段。
17. HTML 必须包含主题详情独立路由模式：详情 hash 下隐藏目录、主报告其它章节和其它主题详情。
18. HTML 主题详情页不得在 sticky VOC 主题卡片下方重复渲染同一主题摘要。
19. HTML 主题详情页必须将 sticky VOC 主题卡片和观点筛选入口合并为同一个卡片。
20. HTML 左侧一级导航和二级导航必须带序号；关键结论和 VOC 主题地图下的二级导航默认展开并支持折叠；主报告卡片采用一行一个默认展开的可折叠块。
21. HTML 的关键结论分布表和 VOC 观点分布表不得展示角色列或角色徽标。
22. HTML 机会矩阵与业务动作必须按方向拆分为多个默认展开的动作块，不得混在一个横向大表中。
23. 主报告一级章节标题下方不得展示说明文字；关键结论和 VOC 主题地图标题必须有问号 tooltip；摘要 chip 必须带中文标签。
24. HTML 只维护电脑端桌面布局，不再包含移动端媒体查询或移动端特化样式。
25. VOC 主题地图和主题详情 sticky 面板不得裸展示 `优先级：P0/P1/P2`；必须展示“运营优先级”和“运营动作”，并在 tooltip 中解释 P0/P1/P2 是动作顺序而非严重度。

## 12. Tests、Checkpoints、Evals

### Tests

新增或更新单元测试：

1. `voc-theme-viewpoints.test.ts`
2. `report-voc-theme-filter-detail.test.ts`
3. `contract-voc-viewpoints.test.ts`
4. `excel-voc-viewpoints.test.ts`

### Checkpoints

新增 checkpoint：

1. `voc_viewpoint_distribution`
2. `voc_theme_detail_filter_reviews`
3. `voc_viewpoint_highlights`
4. `voc_theme_sticky_card`

### Evals

新增 eval：

`eval_10_voc_theme_viewpoint_drilldown`

通过要求：

1. VOC 主题地图展示主题内全部观点。
2. 每个观点有提及数量和占比。
3. 点击 VOC 主题卡片后在新标签页打开主题详情页，当前主报告页不滚动跳转。
4. 主题详情页上方 sticky 面板在同一个卡片内展示所属 VOC 主题和观点筛选入口。
5. 新标签主题详情页只展示当前主题详情，不显示目录、主报告其它章节或其它主题详情。
6. sticky 面板下方不再另起卡片重复展示同一主题摘要。
7. 主题详情页默认展示该主题相关全量评论。
8. 点击主题详情页内某个观点后，当前标签页筛选出该观点相关全量评论。
9. 评论原文和译文有黄色高亮。
10. 观点统计分母使用 Review 样本数。
11. 观点之间允许多标签重叠，报告中说明清楚。

## 13. Product Design 更新

v0.3.0 需要更新报告视觉资产，重点是：

1. VOC 主题卡片内的观点分布表。
2. 可点击主题卡片的 hover/focus 状态。
3. 主题详情页观点筛选控件的 hover/focus/active 状态。
4. 主题详情页的合并式 sticky VOC 主题和观点筛选面板。
5. 长评论列表的阅读密度。
6. 桌面端 sticky 卡片不遮挡正文。
7. 黄色高亮在原文和译文中的可读性。

设计原则：

1. 保持分析型、克制、高信息密度。
2. 不做营销 landing page。
3. 不使用大块装饰图形。
4. 只维护电脑端桌面布局，不做移动端转化。
5. 卡片内表格不得溢出。
6. sticky 区域高度必须受控。

## 14. GitHub 实施步骤

1. 从当前 v0.2.1 基线创建分支：`codex/v0.3.0-voc-viewpoint-drilldown`。
2. 更新 `package.json` 和 `SKILL.md` 到 `v0.3.0`。
3. 更新 `data-contract.md`、`report-contract.md`、`analysis-rules.md`。
4. 更新 BDD feature。
5. 扩展 `core.ts` 类型。
6. 更新报告 renderer，支持主题内观点分布、主题详情页和详情页内观点筛选。
7. 更新 CSS 和 Product Design assets。
8. 更新 Excel exporter，新增 `VOC主题观点` 和 `VOC观点评论明细`。
9. 更新 contract checker。
10. 更新 tests、checkpoints、evals。
11. 使用真实 Sorftime ASIN 生成 sample。
12. 跑完整发布前检查。
13. 更新 README、CHANGELOG、release notes。
14. 提交 PR。
15. 合并后打 `v0.3.0` tag。

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
11. 主题详情页和观点筛选人工点击检查
12. 电脑端宽度检查
13. Release zip SHA256 校验
14. 发布后重新下载安装并 smoke test

## 16. 验收标准

v0.3.0 完成时必须满足：

1. HTML 报告仍是单个自包含 `.html` 文件。
2. VOC 主题地图中每个主题都展示观点分布。
3. 每个观点都有提及数量和占比。
4. 点击 VOC 主题卡片后在新标签页打开主题详情页，当前主报告页不滚动跳转。
5. 主题详情页顶部 sticky 展示所属 VOC 主题卡片。
6. 主题详情页默认展示该主题相关全量 Review 原文和完整中文翻译。
7. 在主题详情页内点击观点后，当前标签页筛选出该观点相关全量 Review 原文和完整中文翻译。
8. 原文和译文高亮词可定位。
9. 观点统计分母使用 Review 样本数。
10. 多标签重叠口径在报告中说明清楚。
11. Excel 包含 VOC 主题观点明细。
12. Contract check 能拦截缺失观点、缺失详情评论、错误占比和高亮定位失败。
13. HTML、Excel、缓存和 release assets 都通过 secret scan。
14. 主报告关键结论、VOC 主题地图和业务动作清单均为一行一个默认展开的可折叠块。
15. HTML 分布表不展示角色列；角色只保留在分析 JSON 和 Excel 中。
16. 机会矩阵与业务动作按方向拆分，电脑端无卡片文本溢出。

## 17. 决策日志

### 2026-06-15：VOC 主题地图升级为主题内观点分布

现状：

v0.2.1 的 VOC 主题地图只展示主题级卡片，无法看清每个主题内部的具体观点构成。

决策：

v0.3.0 为每个 VOC 主题增加 `viewpoints[]`，并在 HTML 中展示观点分布表。

原因：

用户需要像关键结论一样看到“有哪些观点、分别多少条、占比多少、主次矛盾是什么”，否则主题卡片只能说明大方向，不能直接指导产品、Listing 和图片视频优化。

### 2026-06-15：主题详情页保留在单个 HTML 内，并通过新标签页打开

现状：

用户希望点击 VOC 主题地图后进入新的页面，但不是在当前主报告页内滚动跳转；进入新页面后再按观点筛选证据。

决策：

v0.3.0 仍交付单个自包含 HTML，主题详情页实现为同一 HTML 内的独立 section/hash 详情视图；主题卡片链接必须使用 `target="_blank"` 与 `rel="noopener"`，点击后在新标签页打开对应主题详情。观点筛选发生在主题详情页内，不再打开新标签页。

原因：

这样既满足用户明确要求的“点击 VOC 主题地图后打开新标签页/新页面”，又保留一个更自然的证据阅读流：先看主题全量评论，再筛选观点，不破坏当前 skill 的离线交付和 GitHub 发布边界。

### 2026-06-15：主题详情页和观点筛选必须展示全量评论

现状：

主题卡片通常只展示代表证据，主题详情页也容易只展示部分样例。

决策：

主题详情页默认展示该主题相关的全量 Review 原文和完整中文翻译；点击某个观点后，当前标签页筛选出该观点相关的全量 Review 原文和完整中文翻译，默认不截断。

原因：

主题详情页和观点筛选的核心价值是证据追溯和人工复核，不应只展示代表性片段。
