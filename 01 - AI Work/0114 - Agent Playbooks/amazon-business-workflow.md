# Codex Amazon 业务工作流

日期：2026-06-16

页面类型：Agent Playbook

适用范围：NexGaios 内部所有由 Codex 参与的 Amazon 业务分析、Listing 优化、SKU 资料整理、广告策略、库存补货、运营 SOP、竞品研究、复盘总结和内容沉淀任务。

## 1. 这页是什么

这页定义 Codex 在处理 Amazon 业务时如何使用 GBrain 作为第二大脑。

Amazon 业务不是单纯写文案，也不是只看平台数据。它涉及产品资料、Listing、关键词、广告、库存、物流、评论、售后、合规、利润、竞品和运营节奏。Codex 必须先理解公司自己的产品和流程，再输出运营建议。

本工作流的目标是让 Codex 能成为 Amazon 业务的知识助理：能整理资料、生成 SOP、辅助分析、沉淀复盘，但不替代 Terry 或业务负责人做最终商业判断。

## 2. 适用场景

只要任务符合下面任一条件，Codex 都应该进入本工作流：

1. 整理 Amazon 产品资料、SKU、变体、卖点、图片需求、包装信息。
2. 写或优化 Listing 标题、五点描述、A+ 内容、FAQ、Search Terms。
3. 做关键词、竞品、类目、价格、评价、卖点研究。
4. 生成广告投放、预算、关键词分组、否词、复盘分析。
5. 生成库存、补货、物流、售后、评论维护相关 SOP。
6. 把 Amazon 运营经验沉淀到知识库。
7. 把 Terry 或团队的运营判断整理成可复用流程。

## 3. 做 Amazon 业务前必须检索的第二大脑内容

Codex 开始 Amazon 业务任务前，应优先从 GBrain 检索以下页面或目录。若页面还不存在，应明确标记缺口，并建议补齐。

### 3.1 公司和业务背景

优先检索：

1. `company/context`
2. `company/strategy`
3. `amazon/business-overview`
4. `amazon/current-priorities`

目的：

1. 理解 Amazon 业务在 NexGaios 当前阶段的角色。
2. 明确当前目标是选品、上架、优化、广告、库存周转、利润改善还是流程沉淀。
3. 避免输出脱离业务阶段的泛泛建议。

### 3.2 产品和 SKU 资料

优先检索：

1. `amazon/products`
2. `amazon/skus`
3. `amazon/listings`
4. `amazon/brand-assets`

目的：

1. 确认产品是什么、目标用户是谁、核心卖点是什么。
2. 确认 SKU、变体、规格、材质、尺寸、包装、图片、视频、说明书等基础资料。
3. 避免 Codex 编造产品功能、材质、认证、效果或承诺。

### 3.3 平台规则和合规

优先检索：

1. `amazon/compliance`
2. `amazon/platform-rules`
3. `amazon/restricted-claims`
4. `amazon/review-policy`

目的：

1. 避免违反 Amazon 平台政策。
2. 避免夸大宣传、违规索评、敏感词、禁用承诺或不合规文案。
3. 需要最新政策时，Codex 必须联网查 Amazon 官方文档或 Seller Central 官方资料。

### 3.4 Listing 和内容资产

优先检索：

1. `amazon/listing-template`
2. `amazon/title-rules`
3. `amazon/bullet-rules`
4. `amazon/a-plus-content`
5. `amazon/faq`

目的：

1. 保持 Listing 结构统一。
2. 保持品牌语气、卖点表达和关键词策略一致。
3. 把每次优化沉淀为可复用模板。

### 3.5 广告和关键词

优先检索：

1. `amazon/keywords`
2. `amazon/ads`
3. `amazon/ad-campaign-structure`
4. `amazon/search-term-reports`
5. `amazon/ad-optimization-log`

目的：

1. 理解当前关键词池。
2. 理解广告结构、预算、ACOS/TACOS/CTR/CVR 等指标口径。
3. 避免每次从零开始做关键词和广告建议。

### 3.6 库存、物流和售后

优先检索：

1. `amazon/inventory`
2. `amazon/replenishment`
3. `amazon/fba`
4. `amazon/customer-service`
5. `amazon/reviews`

目的：

1. 理解库存和补货周期。
2. 理解物流、FBA、缺货风险、滞销风险。
3. 把售后和评论问题转化为产品和 Listing 改进。

## 4. Amazon 业务输出必须回答的问题

Codex 输出 Amazon 业务建议时，至少要回答：

1. 当前任务属于哪个环节：产品、Listing、关键词、广告、库存、售后、复盘还是 SOP？
2. 已知事实是什么？
3. 缺少哪些数据？
4. 当前目标是什么？
5. 推荐动作是什么？
6. 为什么这样做？
7. 预期影响哪个指标？
8. 风险是什么？
9. 需要 Terry 或业务负责人确认什么？
10. 哪些结论需要写回 GBrain？

如果缺少销量、广告、库存、利润、竞品等关键数据，Codex 应明确说明不能做确定性判断，只能给出假设和下一步数据需求。

## 5. 常见任务的输出结构

### 5.1 Listing 优化

默认结构：

1. 当前 Listing 问题
2. 目标用户和核心场景
3. 核心卖点
4. 关键词策略
5. 标题方案
6. 五点描述方案
7. A+ 内容结构
8. 图片/视频需求
9. 合规风险
10. 需要确认的信息
11. 写回内容

### 5.2 广告优化

默认结构：

1. 当前广告目标
2. 已有数据摘要
3. 关键词分层
4. Campaign / Ad Group 建议
5. 出价和预算建议
6. 否词建议
7. 指标观察窗口
8. 风险
9. 下次复盘时间
10. 写回内容

### 5.3 竞品分析

默认结构：

1. 竞品范围
2. 价格
3. 卖点
4. 图片和 A+ 内容
5. 评论痛点
6. 关键词
7. 差异化机会
8. 风险和限制
9. 可执行动作
10. 写回内容

涉及最新竞品、价格、评价、排名、平台规则时，Codex 必须联网确认，并说明信息日期。

### 5.4 SOP 生成

默认结构：

1. SOP 目标
2. 适用范围
3. 输入资料
4. 操作步骤
5. 检查清单
6. 异常情况
7. 输出物
8. 责任人
9. 更新频率
10. 关联页面

## 6. 做 Amazon 业务时必须遵守的原则

### 6.1 不编造产品事实

Codex 不得编造：

1. 产品材质
2. 认证资质
3. 功效承诺
4. 销量
5. 评论内容
6. 广告表现
7. 库存数量
8. 利润率
9. 平台政策

缺少资料时必须标记为待确认。

### 6.2 平台规则优先

涉及 Amazon 政策、Listing 规范、索评、广告规则、类目限制、合规声明时，Codex 必须优先查官方资料或公司已验证规则。

不确定时不能给确定结论，只能给“待确认”。

### 6.3 业务判断要和指标绑定

建议必须尽量绑定指标：

1. CTR
2. CVR
3. ACOS
4. TACOS
5. CPC
6. Sessions
7. Unit Session Percentage
8. Buy Box
9. 库存周转
10. 毛利

没有数据时，Codex 应说明需要哪些报表。

### 6.4 所有经验要沉淀

Amazon 业务很容易变成零散经验。Codex 每次完成 Listing、广告、库存、售后、竞品、SOP 任务后，都应判断是否有可复用经验，并写回 GBrain。

## 7. 做完 Amazon 任务后必须写回 GBrain 的内容

### 7.1 必须写回的内容

1. 新 SKU 资料
2. Listing 修改记录
3. 关键词池变化
4. 广告结构和复盘
5. 库存补货规则
6. 售后问题和解决方式
7. 竞品洞察
8. 合规风险
9. SOP
10. Terry 或业务负责人明确的判断

### 7.2 推荐写回位置

根据内容类型写回：

1. 业务总览：`amazon/business-overview`
2. SKU：`amazon/skus`
3. 产品资料：`amazon/products`
4. Listing：`amazon/listings`
5. 关键词：`amazon/keywords`
6. 广告：`amazon/ads`
7. 库存：`amazon/inventory`
8. 售后：`amazon/customer-service`
9. 评论：`amazon/reviews`
10. SOP：`amazon/sop`
11. 决策：`decisions/amazon`
12. 模板：`templates/amazon`

## 8. 什么情况必须问 Terry 或业务负责人

以下情况不得默认执行，必须先问：

1. 修改品牌定位。
2. 修改核心卖点。
3. 承诺产品效果、认证或合规结论。
4. 调整价格策略。
5. 改变广告预算。
6. 改变补货计划。
7. 下架或合并 SKU。
8. 对外发布 Listing 文案。
9. 对平台政策作确定性解释。
10. 使用未确认数据做商业决策。

## 9. 标准执行模板

Codex 处理 Amazon 业务时，应按这个节奏：

1. 识别任务属于产品、Listing、广告、库存、售后、竞品、SOP 或复盘。
2. 检索 GBrain 中对应 Amazon 目录。
3. 标记已知事实和缺失数据。
4. 如涉及最新平台规则、竞品、价格或评价，联网验证。
5. 给出结构化建议。
6. 标出需要 Terry 或业务负责人确认的点。
7. 得到反馈后修订。
8. 把最终结论、数据口径、SOP 或复盘写回 GBrain。

## 10. 当前第一版的边界

这份 playbook 是 Codex Amazon 业务场景的第一版。它目前主要服务于资料整理、流程沉淀、运营辅助和 SOP 生成。

它还不能替代：

1. Seller Central 原始数据分析。
2. 财务利润核算。
3. 最终广告投放决策。
4. 平台合规法律判断。
5. Terry 或业务负责人对产品方向的最终判断。

后续需要补充：

1. SKU 页面模板。
2. Listing 优化模板。
3. 广告复盘模板。
4. 库存补货模板。
5. 竞品分析模板。
6. 评论和售后问题模板。

## 11. 本页的维护规则

当 Amazon 业务流程、平台规则、广告打法、SKU 结构或 Terry 的运营判断发生变化时，Codex 应更新本页。

当某个 Amazon 任务形成可复用经验时，Codex 应把经验沉淀到对应目录，并在本页补充引用。
