---
title: 'Skill 工程化与产品化｜阶段十二：专家级专题'
status: raw
created: '2026-06-02 15:52'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Skill'
  - 'MCP'
  - 'GitHub'
  - 'LLM'
  - 'Knowledge-Base'
---

# Skill 工程化与产品化｜阶段十二：专家级专题

## 阶段定位

阶段十二是整套课程的专家级专题，目标不是继续学习“如何写一个 Skill”，而是掌握：

```text
如何设计 Skill 架构
如何自动生成和修复 Skill
如何建设 Skill 评估系统
如何让 Skill 与 MCP、API、Agent、工具链协作
如何设计企业级安全架构
如何制定发布、维护、废弃和迁移标准
如何完成一个从业务流程到 Skill Library 的最终综合项目
```

前十一阶段已经解决了 Skill 的认知、结构、Workflow、上下文、脚本、测试、安全、产品化、Library 和实战落地。阶段十二要解决的是：

> 如何把 Skill 从“可用能力包”升级为“可规模化生产、可系统集成、可治理运营、可企业化落地的组织级 AI 能力工程”。

本阶段包含第 61–70 章：

| 章节 | 专题 | 重点 |
|---|---|---|
| 第 61 章 | Skill 架构设计 | 粒度、组合、依赖、冲突、生命周期 |
| 第 62 章 | Skill 自动生成 | 从 Prompt、SOP、案例、失败记录生成 Skill |
| 第 63 章 | Skill 评估系统 | 自动化测试、人工评审、多模型测试、质量看板 |
| 第 64 章 | Skill 与 MCP 集成 | 外部工具、数据源、权限、文件处理、自动化流程 |
| 第 65 章 | Skill 与 API / Actions 集成 | API schema、认证、数据读取、写操作、安全控制 |
| 第 66 章 | Skill 安全架构 | 信任等级、权限分层、沙箱、审计、风险隔离 |
| 第 67 章 | Skill 产品化发布标准 | 用户说明、边界、安装、测试报告、变更记录 |
| 第 68 章 | Skill 维护与废弃 | 更新、拆分、合并、废弃、迁移 |
| 第 69 章 | 企业级 Skill 体系 | 组织资产、权限体系、共享机制、审核机制 |
| 第 70 章 | 最终综合项目 | 从真实业务流程完成 Skill 需求、实现、测试、发布和沉淀 |

---

# 第 61 章：Skill 架构设计

## 61.1 什么是 Skill 架构设计

Skill 架构设计，是指从系统角度设计 Skill 的粒度、职责、组合方式、依赖关系、调用边界、资源分层和生命周期。

初级 Skill 关注：

```text
这个 Skill 怎么写？
```

专家级 Skill 架构关注：

```text
这个 Skill 应该多大？
是否应该拆成多个 Skill？
它依赖哪些资料、脚本、工具？
它和其他 Skill 如何协作？
它是否会和已有 Skill 冲突？
它如何测试、发布、维护、废弃？
```

## 61.2 Skill 粒度设计

Skill 粒度决定 Skill 的可用性和维护成本。

### 粒度过大

示例：

```text
amazon-operation-assistant
```

问题：

- 范围过宽
- Review、Listing、广告、库存、客服都混在一起
- `description` 难写
- 容易误触发
- 测试集难设计
- 维护成本高

### 粒度过小

示例：

```text
amazon-one-star-review-audio-complaint-extractor-for-wireless-microphone
```

问题：

- 复用范围太窄
- Skill 数量膨胀
- Library 难管理
- 用户不知道该用哪个

### 合适粒度

示例：

```text
amazon-review-analyzer
amazon-a-plus-copywriter
amazon-a-plus-visual-brief
```

原则：

```text
一个 Skill 应解决一个稳定任务类型，而不是一个完整业务部门，也不是一个过窄微动作。
```

## 61.3 Skill 粒度判断标准

可以用 6 个问题判断粒度是否合适：

```text
1. 是否有明确用户？
2. 是否有明确输入？
3. 是否有明确输出？
4. 是否有稳定流程？
5. 是否能独立测试？
6. 是否能被其他 Skill 复用？
```

如果答案大多是否，说明粒度可能不合适。

## 61.4 Skill 组合设计

Skill 可以分为三类组合关系：

| 关系 | 说明 | 示例 |
|---|---|---|
| 串行组合 | 上游输出作为下游输入 | Review 分析 → A+ 文案 → 图片 Brief |
| 并行组合 | 多个 Skill 分别评估同一对象 | UI 审查 + 开发工作量评估 + 品牌一致性检查 |
| 主从组合 | 主 Skill 调度子 Skill | 产品交付 Planner 调用 SDD、BDD、TDD Skill |

## 61.5 Skill 依赖设计

Skill 可能依赖：

```text
references/
assets/
scripts/
外部工具
MCP 服务
API
其他 Skill
组织规范
测试集
```

依赖设计应遵循：

```text
少依赖
显式依赖
稳定依赖
可替换依赖
可测试依赖
```

不要让一个 Skill 隐式依赖“某个人知道的规则”。

## 61.6 Skill 冲突设计

冲突类型：

| 冲突类型 | 表现 | 解决方法 |
|---|---|---|
| 触发冲突 | 多个 Skill 都匹配同一请求 | 精简 description，明确排除条件 |
| 职责冲突 | 多个 Skill 都处理同一流程 | 拆分 Scope |
| 输出冲突 | 下游无法接收上游输出 | 建 Output Contract |
| 边界冲突 | 一个 Skill 保守，一个激进 | 安全和事实优先 |
| 版本冲突 | 上游更新破坏下游 | 回归测试和版本兼容说明 |

## 61.7 Skill 生命周期架构

建议采用以下状态：

```text
Draft → MVP → Active → Stable → Deprecated → Archived
```

其中：

| 状态 | 管理重点 |
|---|---|
| Draft | 快速探索，不共享 |
| MVP | 小范围验证 |
| Active | 正常使用和反馈 |
| Stable | 控制变更 |
| Deprecated | 停止新增使用，提供替代 |
| Archived | 归档保留，不推荐使用 |

## 61.8 本章小结

Skill 架构设计的核心是：

```text
粒度合适
职责清楚
依赖显式
接口稳定
冲突可控
生命周期可管理
```

专家级判断：

> 不是会写很多 Skill，而是知道什么时候写一个，什么时候拆成多个，什么时候合并，什么时候废弃。

---

# 第 62 章：Skill 自动生成

## 62.1 什么是 Skill 自动生成

Skill 自动生成，是指通过已有材料自动或半自动生成 Skill 初稿，包括：

```text
从 Prompt 生成 Skill
从 SOP 生成 Skill
从成功案例生成 Skill
从失败案例修复 Skill
从知识库生成 Skill
从测试集反推 Skill
```

目标不是让 AI 一次性生成完美 Skill，而是提高 Skill 初稿生产效率。

## 62.2 Skill 自动生成的输入来源

| 来源 | 可转化内容 |
|---|---|
| 高频 Prompt | 目标、输入、输出、约束 |
| SOP 文档 | Process、Decision Logic |
| 业务规范 | Constraints、Quality Criteria |
| 模板文件 | assets |
| 成功案例 | Positive Examples、Golden Cases |
| 失败案例 | Negative Examples、Regression Tests |
| 用户反馈 | 迭代方向 |
| 测试集 | Eval Criteria |

## 62.3 自动生成流程

```text
1. 收集原始材料
2. 去除一次性上下文
3. 提取稳定任务目标
4. 拆解输入输出契约
5. 提取流程步骤
6. 提取边界和禁止事项
7. 生成 name 和 description
8. 生成 SKILL.md 初稿
9. 生成 references / assets / tests 建议
10. 人工审查和测试
```

## 62.4 从 Prompt 生成 Skill

原 Prompt：

```text
帮我把这段对话整理成知识库 Markdown，不要出现“你的问题”，要中立百科体。
```

自动提取：

| Skill 部分 | 提取内容 |
|---|---|
| name | `llm-wiki-writer` |
| description | 当用户要求沉淀知识库、整理成 `.md` 时使用 |
| Purpose | 将内容转为中立 Markdown 知识条目 |
| Inputs | 对话、笔记、说明文本 |
| Output | Markdown 知识条目 |
| Constraints | 不出现对话口吻，不编造事实 |
| Tests | 对话口吻泄漏案例 |

## 62.5 从 SOP 生成 Skill

SOP 原文往往写给人看，例如：

```text
检查 A+ 图片是否突出卖点，文案是否清楚，画面是否高级。
```

自动生成时要转换为：

```text
目标 → 审查 A+ 图片 brief
输入 → 图片、卖点、目标用户、尺寸
流程 → 识别卖点、检查层级、检查文案、检查风险
输出 → 问题表、原因、风险、修改建议
```

## 62.6 从失败案例修复 Skill

失败案例：

```text
用户只想简单总结，Skill 却输出完整知识库结构。
```

应自动反推：

```text
需要补充 Non-example
需要修改 description 的 Do not use
需要增加轻量总结分支
需要加入 regression test
```

## 62.7 自动生成的风险

| 风险 | 表现 |
|---|---|
| 复制噪音 | 把原 Prompt 的废话也写进 Skill |
| 范围过大 | 想覆盖所有相关场景 |
| 边界不足 | 没有反例和禁止事项 |
| description 模糊 | 自动生成“helps with content” |
| 缺少测试 | 只生成说明，不生成验证案例 |
| 错误抽象 | 把一次性偏好当成长期规则 |
| 安全缺失 | 没有处理敏感信息和脚本风险 |

## 62.8 自动生成验收标准

自动生成的 Skill 初稿必须经过：

```text
人工审查
测试案例验证
安全检查
description 触发检查
输出契约检查
边界检查
版本记录
```

## 62.9 本章小结

Skill 自动生成的价值是提高初稿生产效率，不是替代工程判断。

核心公式：

```text
材料收集 → 稳定任务提取 → 结构化生成 → 人工审查 → 测试修复 → 版本化沉淀
```

---

# 第 63 章：Skill 评估系统

## 63.1 什么是 Skill 评估系统

Skill 评估系统，是一套持续判断 Skill 是否稳定、准确、可用、安全的机制。

它不仅是 `tests/` 文件夹，而是包括：

```text
测试集
评估维度
评分规则
自动检查脚本
人工评审表
回归测试
多模型测试
使用数据
质量看板
版本对比
```

## 63.2 评估对象

Skill 评估应覆盖：

| 对象 | 评估内容 |
|---|---|
| 触发 | 是否该用时用，不该用时不用 |
| 流程 | 是否按 `SKILL.md` 执行 |
| 输出 | 是否符合格式和质量标准 |
| 事实 | 是否区分事实、推断、建议 |
| 边界 | 是否避免越界和虚构 |
| 资源 | 是否正确使用 references、assets、scripts |
| 安全 | 是否避免数据泄露和危险操作 |
| 稳定性 | 多次使用是否表现一致 |

## 63.3 自动化评估

适合自动化检查：

```text
是否包含必需章节
是否出现禁用词
JSON 是否合法
Markdown 标题层级是否正确
表格列是否完整
frontmatter 是否存在
文件命名是否合规
输出是否包含敏感字段
```

## 63.4 人工评估

必须人工判断：

```text
业务洞察是否有价值
文案是否符合目标用户
设计 brief 是否可执行
需求拆解是否合理
边界处理是否符合业务风险
建议是否有实际意义
```

## 63.5 多模型测试

专家级 Skill 应考虑多模型测试：

```text
同一 Skill 在不同模型上是否表现稳定？
是否依赖某个模型的特定表达习惯？
是否在强模型上有效、弱模型上失效？
是否需要降低指令复杂度？
```

多模型测试不是为了追求完全一致，而是验证关键行为一致。

## 63.6 质量看板

建议建立 Skill 质量看板：

```markdown
| Skill | 版本 | 测试通过率 | 误触发数 | 漏触发数 | 回归失败 | 安全问题 | 最近更新 | 状态 |
|---|---|---:|---:|---:|---:|---:|---|---|
| llm-wiki-writer | 1.2.0 | 92% | 1 | 0 | 0 | 0 | 2026-06-02 | Active |
| amazon-review-analyzer | 0.5.0 | 76% | 2 | 1 | 1 | 0 | 2026-06-02 | MVP |
```

## 63.7 Eval 驱动迭代

评估系统应形成闭环：

```text
真实任务
→ 失败记录
→ 测试案例
→ 自动/人工评估
→ 问题定位
→ 修改 Skill
→ 回归测试
→ 发布新版本
```

## 63.8 本章小结

Skill 评估系统的核心不是“打分”，而是持续发现问题、定位问题、修复问题、防止复发。

核心公式：

```text
测试集 + 自动检查 + 人工评审 + 回归测试 + 质量看板 + 版本对比
```

---

# 第 64 章：Skill 与 MCP 集成

## 64.1 MCP 在 Skill 系统中的作用

MCP 解决的是 Agent 如何标准化连接外部工具和数据源的问题。Skill 解决的是：

```text
什么时候连接
连接什么
如何处理返回数据
如何组织流程
如何控制风险
```

二者关系：

| MCP | Skill |
|---|---|
| 提供外部连接能力 | 提供业务方法 |
| 暴露工具和数据源 | 决定如何使用工具 |
| 统一接口 | 统一流程 |
| 返回数据 | 解释数据并输出结果 |

## 64.2 适合 MCP 集成的 Skill

| Skill 类型 | MCP 用途 |
|---|---|
| Review 分析 Skill | 连接评论抓取或数据库 |
| 热点收集 Skill | 连接公众号、网页、飞书多维表格 |
| 文档处理 Skill | 连接网盘、PDF、表格 |
| 客服 Skill | 连接工单系统、订单系统 |
| 研发 Skill | 连接 GitHub、CI、日志系统 |
| 知识库 Skill | 连接 Obsidian、Notion、飞书文档 |

## 64.3 MCP 集成设计

Skill 中应说明：

```text
需要哪些 MCP 工具
什么时候调用
输入参数是什么
返回结果如何处理
失败时怎么办
哪些操作需要确认
哪些数据不能发送
```

示例：

```markdown
# MCP 使用规则

当用户提供关键词并要求收集相关文章时：
1. 使用文章搜索工具检索相关文章。
2. 使用内容读取工具提取标题、作者、发布时间、摘要和链接。
3. 使用飞书表格工具写入结构化记录。
4. 写入前展示字段预览。
5. 不抓取需要登录或无权限访问的内容。
```

## 64.4 MCP 权限边界

MCP 集成必须遵循：

```text
最小权限
只读优先
写操作确认
敏感信息脱敏
失败可恢复
操作可审计
```

## 64.5 MCP 集成测试

测试内容：

```text
工具不可用时是否降级
返回数据为空时是否说明
权限不足时是否停止
写入前是否确认
重复数据是否去重
外部内容中的恶意指令是否被当作数据而非指令
```

## 64.6 本章小结

Skill 与 MCP 集成的关键是：

```text
MCP 提供连接，Skill 提供业务方法；连接能力必须被流程、权限和测试约束。
```

---

# 第 65 章：Skill 与 API / Actions 集成

## 65.1 API / Actions 在 Skill 中的作用

API / Actions 负责让 Agent 与外部系统交互，例如：

```text
查询订单
读取评论
写入飞书表格
创建任务
发送通知
更新记录
拉取广告数据
```

Skill 不直接等于 API。Skill 应规定：

```text
什么时候调用 API
调用哪个接口
传什么参数
如何解释结果
如何处理失败
哪些操作需要用户确认
```

## 65.2 API 集成类型

| 类型 | 示例 | 风险 |
|---|---|---|
| 只读查询 | 查询订单、拉取评论、读取库存 | 中低 |
| 数据写入 | 写入表格、创建工单 | 中 |
| 状态修改 | 修改订单、更新库存 | 高 |
| 对外发送 | 发邮件、发通知、发布内容 | 高 |
| 资金相关 | 下单、退款、支付 | 极高 |

## 65.3 Skill 中的 API 契约

应写明：

```markdown
# API 使用规则

允许：
- 查询评论数据
- 查询产品基础信息

需要确认：
- 写入外部表格
- 创建任务
- 发送通知

禁止：
- 删除数据
- 修改生产库存
- 发送未经用户确认的外部消息
```

## 65.4 API schema 与 Skill 的关系

API schema 定义机器接口：

```text
接口名
参数
类型
返回值
错误码
认证方式
```

Skill 定义业务流程：

```text
什么时候调用
为什么调用
调用结果如何进入分析
失败后如何降级
哪些结果不能直接当事实
```

## 65.5 认证与权限

API 集成需要治理：

```text
不要在 Skill 中硬编码 API Key
不要把密钥写入 references 或 tests
不要默认使用最高权限账号
读写权限分离
高风险操作人工确认
记录审计日志
```

## 65.6 API 失败处理

常见失败：

| 失败 | Skill 处理 |
|---|---|
| 认证失败 | 说明权限问题，不重试敏感操作 |
| 数据为空 | 输出空结果和可能原因 |
| 接口超时 | 说明未完成，保留已处理部分 |
| 字段缺失 | 标注缺失字段，不编造 |
| 写入失败 | 不声称已写入，返回错误摘要 |
| 权限不足 | 停止操作，说明需要授权 |

## 65.7 本章小结

Skill 与 API / Actions 集成的核心是：

```text
API 负责连接系统，Skill 负责业务流程、权限边界和结果解释。
```

---

# 第 66 章：Skill 安全架构

## 66.1 什么是 Skill 安全架构

Skill 安全架构，是指从系统层面设计 Skill 的信任等级、权限范围、数据边界、脚本隔离、外部连接、审计和应急机制。

安全不是最后检查一次，而是贯穿：

```text
设计
创建
测试
上传
安装
运行
共享
更新
废弃
```

## 66.2 Skill 信任等级

建议分级：

| 等级 | 类型 | 处理 |
|---|---|---|
| L0 | 个人草稿 Skill | 不共享，不接触敏感数据 |
| L1 | 指令型 Skill | 基础审查 |
| L2 | references/assets Skill | 检查资料和模板 |
| L3 | scripts Skill | 代码审查和沙箱 |
| L4 | 外部连接 Skill | 权限审查和审计 |
| L5 | 可写操作 Skill | 人工确认和强审计 |

## 66.3 权限分层

权限应分为：

```text
查看
使用
编辑
上传
分享
发布
安装给他人
执行脚本
连接外部系统
执行写操作
```

原则：

```text
默认最小权限
高风险权限单独申请
写操作必须可审计
生产系统必须隔离
```

## 66.4 沙箱与隔离

含脚本 Skill 应尽量：

```text
在隔离环境运行
不默认联网
不默认访问系统路径
不覆盖源文件
输出到新文件
记录执行日志
限制依赖安装
```

## 66.5 审计日志

应记录：

```text
谁使用了 Skill
何时使用
使用哪个版本
触发了哪些工具
是否运行脚本
是否写入外部系统
是否出现失败
是否有人确认高风险操作
```

## 66.6 风险隔离

风险隔离方法：

```text
只读 Skill 与写操作 Skill 分开
个人 Skill 与团队 Skill 分开
测试环境与生产环境分开
高风险工具与普通工具分开
外部来源 Skill 与内部审查 Skill 分开
```

## 66.7 本章小结

Skill 安全架构的核心是：

```text
分级信任 + 最小权限 + 沙箱执行 + 审计日志 + 人工确认 + 风险隔离
```

---

# 第 67 章：Skill 产品化发布标准

## 67.1 为什么需要发布标准

一个 Skill 能运行，不代表可以发布。发布意味着：

```text
别人会依赖它
它会影响工作流
它可能接触数据
它需要持续维护
它可能成为团队标准
```

## 67.2 发布前必备材料

成熟 Skill 发布包应包含：

```text
SKILL.md
README.md
CHANGELOG.md
SECURITY.md
tests/
references/
assets/
scripts/（如需要）
```

## 67.3 README 标准

README 应面向人，说明：

```text
Skill 做什么
适合谁使用
什么时候用
什么时候不用
需要什么输入
输出什么结果
示例请求
owner
版本
反馈方式
```

## 67.4 测试报告标准

发布前应有测试报告：

```markdown
| Case | 类型 | 结果 | 问题 | 是否修复 |
|---|---|---|---|---|
| 001 | 正常 | Pass | 无 | 是 |
| 002 | 反例 | Pass | 无 | 是 |
| 003 | 边界 | Partial | 输出过长 | 已修复 |
```

## 67.5 发布门槛

建议门槛：

```text
1. 至少 5 个测试案例
2. 至少 1 个反例
3. 至少 1 个边界案例
4. 通过安全审查
5. 有 owner
6. 有版本号
7. 有 changelog
8. 有 README
9. 输出结构稳定
10. 明确不适用范围
```

## 67.6 发布分级

| 级别 | 说明 |
|---|---|
| Personal | 个人使用 |
| Team Trial | 小组试用 |
| Team Standard | 团队标准 |
| Workspace | 工作区发布 |
| Enterprise | 企业级发布 |

## 67.7 本章小结

发布标准的核心是：

```text
可理解 + 可测试 + 可审查 + 可维护 + 可回滚
```

---

# 第 68 章：Skill 维护与废弃

## 68.1 Skill 为什么需要维护

Skill 会过期，因为：

```text
平台规则变化
业务流程变化
组织结构变化
工具接口变化
模型能力变化
用户需求变化
安全要求变化
```

不维护的 Skill 会从资产变成负债。

## 68.2 什么时候更新

需要更新：

```text
频繁误触发
输出格式不稳定
用户反馈集中
规则过期
接口变化
新增高频场景
发现安全风险
测试失败
```

## 68.3 什么时候拆分

需要拆分：

```text
description 过长
一个 Skill 覆盖多个用户群
输出格式有多套
测试案例无法统一
不同流程互相干扰
维护人难以负责全部内容
```

## 68.4 什么时候合并

需要合并：

```text
两个 Skill 高度重叠
用户分不清
输出结构类似
测试集相似
维护规则重复
```

## 68.5 什么时候废弃

需要废弃：

```text
长期无人使用
已有替代 Skill
规则严重过期
owner 缺失
存在无法接受的安全风险
维护成本高于价值
```

## 68.6 废弃流程

```text
1. 标记 Deprecated
2. 在 README 中说明原因
3. 提供替代 Skill
4. 保留迁移指南
5. 停止新用户使用
6. 迁移历史流程
7. 移入 archived
```

## 68.7 迁移指南模板

```markdown
# 迁移指南

## 废弃 Skill

[旧 Skill 名称]

## 替代 Skill

[新 Skill 名称]

## 废弃原因

[说明原因]

## 主要差异

| 项目 | 旧版 | 新版 |
|---|---|---|

## 迁移步骤

1. 替换调用方式
2. 更新输入格式
3. 检查输出差异
4. 运行回归测试
```

## 68.8 本章小结

Skill 维护与废弃的核心是：

```text
持续更新有价值的 Skill，及时淘汰低价值或高风险 Skill。
```

---

# 第 69 章：企业级 Skill 体系

## 69.1 企业级 Skill 体系是什么

企业级 Skill 体系，是指组织将 Skill 作为 AI 能力资产进行统一建设、发布、使用、审计和治理。

它通常包括：

```text
Skill Library
权限体系
安全审查
版本管理
发布流程
评估系统
使用数据
培训机制
合规机制
资产归档
```

## 69.2 企业级角色

| 角色 | 职责 |
|---|---|
| Skill Creator | 创建 Skill |
| Skill Owner | 负责质量和维护 |
| Domain Expert | 提供业务规则 |
| Security Reviewer | 审查安全 |
| Eval Owner | 维护测试和评估 |
| Workspace Admin | 管理权限和发布 |
| User | 使用并反馈 |
| Governance Lead | 制定标准和流程 |

## 69.3 企业级治理流程

```text
需求提出
→ 是否值得 Skill 化
→ 创建 MVP
→ 测试验证
→ 安全审查
→ 小组试用
→ 发布审批
→ 工作区分发
→ 使用监控
→ 定期复审
→ 归档或升级
```

## 69.4 企业级资产分层

| 层级 | 内容 |
|---|---|
| 个人层 | 个人实验 Skill |
| 项目层 | 项目专用 Skill |
| 团队层 | 团队标准 Skill |
| 部门层 | 部门流程 Skill |
| 企业层 | 组织级通用 Skill |
| 归档层 | 废弃与历史 Skill |

## 69.5 企业级指标

可追踪：

```text
Skill 数量
Active Skill 数量
Deprecated Skill 数量
使用次数
使用人数
成功率
返工率
误触发率
安全事件
平均维护周期
回归测试通过率
```

## 69.6 企业级风险

| 风险 | 表现 |
|---|---|
| Skill 膨胀 | 大量低质量 Skill |
| 重复建设 | 多团队写同类 Skill |
| 规则过期 | 旧流程继续被调用 |
| 权限过宽 | 成员可上传高风险 Skill |
| 数据泄露 | 示例或日志含敏感信息 |
| 无 owner | 资产无人维护 |
| 无测试 | 质量不可控 |
| 无淘汰 | Library 污染 |

## 69.7 本章小结

企业级 Skill 体系的核心是：

```text
把个人经验、团队流程和组织规范转化为可治理、可评估、可持续运营的 AI 能力资产。
```

---

# 第 70 章：最终综合项目

## 70.1 项目目标

最终综合项目要求选择一个真实业务流程，完整完成 Skill 工程化和产品化闭环。

目标是产出：

```text
一个可用 Skill
一组 references/assets/scripts
一组测试案例
一个发布说明
一个安全审查
一个维护计划
一个可纳入 Skill Library 的能力资产
```

## 70.2 选题建议

可选题：

| 业务流程 | 适合 Skill |
|---|---|
| Amazon Review 分析 | `amazon-review-analyzer` |
| A+ 图片需求整理 | `amazon-a-plus-visual-brief` |
| LLM Wiki 知识沉淀 | `llm-wiki-writer` |
| 内容清洁 | `content-cleaner` |
| SDD/BDD/TDD 拆解 | `sdd-bdd-tdd-planner` |
| 说明书审查 | `manual-reviewer` |
| 客服回复标准化 | `customer-support-replier` |
| UI 方案汇报 | `design-report-advisor` |

## 70.3 最终项目步骤

```text
1. 选择真实业务流程
2. 判断是否值得 Skill 化
3. 明确用户、场景、痛点、产物、价值
4. 设计 Skill 架构和粒度
5. 编写 SKILL.md
6. 拆分 references、assets、scripts
7. 编写测试案例
8. 运行测试并修复
9. 完成安全审查
10. 编写 README、CHANGELOG、SECURITY
11. 发布到 Skill Library
12. 制定维护与废弃策略
```

## 70.4 最终交付目录

```text
final-skill-project/
├── SKILL.md
├── README.md
├── CHANGELOG.md
├── SECURITY.md
├── references/
│   ├── style-guide.md
│   └── examples.md
├── assets/
│   └── output-template.md
├── scripts/
│   └── validate_output.py
└── tests/
    ├── cases.md
    ├── regression.md
    └── eval-results.md
```

## 70.5 最终验收标准

最终项目合格必须满足：

```text
1. 任务值得 Skill 化
2. 用户、场景、痛点、产物清楚
3. name 和 description 可触发且边界清晰
4. 输入输出契约完整
5. Process 可执行
6. 有 Constraints 和 Failure Handling
7. 有至少 5 个测试案例
8. 有至少 1 个反例和 1 个边界案例
9. 如有 scripts，脚本有安全说明
10. 有 README、CHANGELOG、SECURITY
11. 能纳入 Skill Library
12. 有维护和废弃策略
```

## 70.6 最终项目评分表

```markdown
| 维度 | 分值 | 检查点 |
|---|---:|---|
| 场景价值 | 10 | 是否高频、稳定、可复用 |
| 架构设计 | 15 | 粒度、职责、依赖是否合理 |
| SKILL.md 质量 | 20 | 触发、流程、输出、边界是否清晰 |
| 资源分层 | 10 | references/assets/scripts 是否合理 |
| 测试评估 | 15 | 测试集、反例、边界、回归是否完整 |
| 安全治理 | 10 | 权限、数据、脚本、外部连接是否可控 |
| 产品化 | 10 | README、版本、发布、反馈是否完整 |
| Library 集成 | 10 | 是否可纳入分类、索引、维护体系 |
```

## 70.7 最终项目输出模板

```markdown
# 最终综合项目：[Skill 名称]

## 一、业务流程说明

## 二、为什么值得 Skill 化

## 三、目标用户与使用场景

## 四、Skill 架构设计

## 五、SKILL.md

## 六、references / assets / scripts 设计

## 七、测试案例

## 八、评估结果

## 九、安全审查

## 十、发布说明

## 十一、维护与废弃策略

## 十二、纳入 Skill Library 的位置
```

## 70.8 本章小结

最终综合项目的核心目标是完成一次从业务流程到 Skill 资产的闭环：

```text
业务流程 → Skill 设计 → 工程实现 → 测试评估 → 安全审查 → 产品化发布 → Library 沉淀 → 持续维护
```

---

# 阶段十二总结

阶段十二的核心结论：

1. **专家级 Skill 能力不只是会写 Skill。**  
   它要求理解架构、自动化、评估、集成、安全、发布、维护和企业治理。

2. **Skill 架构设计决定可扩展性。**  
   粒度、依赖、接口、冲突和生命周期决定 Skill 能否长期维护。

3. **Skill 自动生成只能生成初稿。**  
   真正可用的 Skill 仍需要人工审查、测试、边界设计和版本管理。

4. **Skill 评估系统是质量核心。**  
   自动检查、人工评审、回归测试和质量看板共同决定 Skill 是否可靠。

5. **Skill 必须进入 Agent 系统。**  
   Skill 与 MCP、API、工具、知识库、Memory、Eval 和 Governance 协作，才能支撑真实业务。

6. **企业级 Skill 体系本质是组织能力资产化。**  
   它将个人经验、团队 SOP、业务规范和专家判断转化为可治理、可复用、可迭代的 AI 能力资产。

阶段十二最重要的一句话：

> 专家级 Skill 工程化的目标，不是生产更多 Skill，而是建立一套能持续生产、评估、集成、治理和淘汰 Skill 的组织能力系统。

---

# 阶段十二掌握检查

完成阶段十二后，应能回答：

1. 如何判断一个 Skill 的粒度是否合适？
2. 什么时候应该拆分 Skill，什么时候应该合并 Skill？
3. 从 Prompt、SOP、成功案例、失败案例生成 Skill 时分别要提取什么？
4. Skill 评估系统应包含哪些组成？
5. 哪些评估适合自动化，哪些必须人工评审？
6. Skill 与 MCP 的边界是什么？
7. Skill 与 API / Actions 的边界是什么？
8. Skill 安全架构为什么需要信任等级和权限分层？
9. 一个 Skill 发布前必须具备哪些材料？
10. 如何判断一个 Skill 应该更新、拆分、合并、废弃或归档？
11. 企业级 Skill 体系有哪些角色和治理流程？
12. 最终综合项目应交付哪些文件和评估结果？

---

# 可沉淀的最小方法论

```text
专家级 Skill 工程化十步法：

1. 架构设计：确定粒度、职责、依赖、接口和生命周期
2. 自动生成：从 Prompt、SOP、案例、反馈中生成 Skill 初稿
3. 工程实现：编写 SKILL.md，拆分 references、assets、scripts
4. 测试评估：建立测试集、评估维度、回归案例和质量看板
5. 系统集成：接入 MCP、API、工具、知识库和 Memory
6. 安全架构：设计信任等级、权限分层、沙箱、审计和人工确认
7. 发布标准：准备 README、CHANGELOG、SECURITY、测试报告
8. 维护治理：根据反馈更新、拆分、合并、废弃和归档
9. 企业体系：建立 owner、reviewer、admin、eval owner 和 governance lead
10. 最终沉淀：纳入 Skill Library，形成可持续运营的组织能力资产
```

---

# 推荐专家级 Skill 资产目录

```text
enterprise-skill-system/
├── README.md
├── INDEX.md
├── GOVERNANCE.md
├── SECURITY.md
├── EVALS.md
├── CHANGELOG.md
├── skills/
│   ├── content/
│   ├── ecommerce/
│   ├── design/
│   ├── product/
│   ├── engineering/
│   └── governance/
├── shared-references/
│   ├── brand-style.md
│   ├── security-policy.md
│   └── evaluation-rubric.md
├── shared-assets/
│   ├── report-template.md
│   └── skill-readme-template.md
├── shared-scripts/
│   ├── validate_skill_structure.py
│   └── check_sensitive_data.py
├── evals/
│   ├── datasets/
│   ├── graders/
│   └── reports/
└── archived/
    └── deprecated-skills/
```

---

# 参考依据

- OpenAI Codex Skills：Skill 是包含 `SKILL.md` 的目录，可附带 scripts、references、assets；Codex 使用 progressive disclosure，先加载 name、description 和文件路径，匹配后再读取完整 `SKILL.md`。
- OpenAI ChatGPT Skills：Skills 是可复用、可共享的工作流，可包含 instructions、supporting files 和 code；管理员可控制创建、上传、分享、发布、安装等权限。
- OpenAI Evals：Evaluations 用于测试模型输出是否满足指定的风格和内容标准；评估流程包括描述任务、运行测试输入、分析结果并迭代。
- OpenAI Evaluation Best Practices：生成式 AI 具有可变性，evals 是测试 AI 系统准确性、性能和可靠性的重要方法；建议采用 eval-driven development、任务特定 eval、日志记录、自动化评分和人工校准。
- OpenAI Apps / RBAC 管理：工作区可通过角色权限、应用访问、动作控制、参数约束和域名限制管理外部连接能力。
