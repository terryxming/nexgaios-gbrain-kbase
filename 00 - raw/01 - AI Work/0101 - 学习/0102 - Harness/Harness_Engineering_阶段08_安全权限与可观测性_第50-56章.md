---
title: 'Harness Engineering｜阶段八：安全、权限与可观测性（第 50–56 章）'
status: raw
created: '2026-05-21 09:31'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Harness'
  - 'Skill'
  - 'GitHub'
  - 'LLM'
  - 'Knowledge-Base'
---

# Harness Engineering｜阶段八：安全、权限与可观测性（第 50–56 章）

阶段八的核心目标：

> 把 Agent 从“能做事”升级为“能安全、可控、可追踪、可恢复地做事”。

前面阶段已经讲了任务入口、上下文、工具、状态、工作流、测试、Skill、Coding Agent 和业务应用。阶段八开始进入生产级 Agent 系统必须面对的问题：

```text
Agent 会误删吗？
Agent 会越权吗？
Agent 会泄露密钥吗？
Agent 会被提示词注入控制吗？
Agent 做错以后能不能回滚？
Agent 做过什么能不能追踪？
Agent 成本、延迟、失败率能不能观测？
```

---

## 阶段八总览

| 章 | 主题 | 核心问题 | 一句话理解 |
|---:|---|---|---|
| 50 | Agent 风险类型 | Agent 可能怎么出错 | 先识别风险，才能设计防线 |
| 51 | Permission Harness | Agent 能做什么、不能做什么 | 权限控制是 Agent 安全的第一层 |
| 52 | Sandbox Harness | Agent 在哪里执行 | 沙盒让错误影响被限制在可控范围 |
| 53 | Secret / Credential Safety | 如何保护密钥和账号 | Agent 不应该看见或泄露不该看的凭证 |
| 54 | Observability Harness | 如何看见 Agent 行为 | 没有日志和 trace，就没有工程化 |
| 55 | Recovery Harness | 出错后如何恢复 | 安全系统必须能回滚和补救 |
| 56 | Audit Harness | 如何建立责任链 | 审计让动作、原因、批准人可追踪 |

---

# 第 50 章：Agent 风险类型｜误删、越权、幻觉、假完成

## 50.1 本章核心

> Agent 安全的第一步，不是加更多规则，而是先把风险类型拆清楚。

Agent 风险不是单一问题，而是多个层面的组合：

```text
模型风险
上下文风险
工具风险
权限风险
执行环境风险
数据风险
流程风险
组织风险
```

如果不分类，就会把所有问题都归因于“模型不够好”。这会导致错误修复方向。

---

## 50.2 Agent 常见风险总表

| 风险类型 | 表现 | 典型后果 | 对应 Harness |
|---|---|---|---|
| 幻觉 | 编造事实、引用不存在资料 | 错误决策 | Context / Verification |
| 假完成 | 没做完却说完成 | 交付不可信 | Quality Gate |
| 误删 | 删除无关文件或原始资料 | 数据丢失 | Permission / Backup |
| 越权 | 执行不该执行的操作 | 安全事故 | Permission / HITL |
| 泄密 | 输出密钥、账号、隐私 | 法务和安全风险 | Secret Safety |
| 提示词注入 | 被恶意输入改变行为 | 工具被滥用 | Input Guardrail |
| 工具误用 | 调错工具、参数错 | 错误动作 | Tool Harness |
| 过度自主 | 未经批准执行外部动作 | 预算、账号、业务损失 | Approval Gate |
| 上下文污染 | 使用错误或过期信息 | 长期判断偏移 | Context / Memory |
| 输出未校验 | 模型输出直接进入系统 | 代码执行、数据污染 | Output Guardrail |
| 成本失控 | 反复调用高成本模型或工具 | 费用上升 | Observability / Limit |
| 不可追踪 | 不知道 Agent 做过什么 | 无法复盘 | Audit / Trace |

---

## 50.3 风险不是只来自模型

很多 Agent 事故不是模型单独造成的，而是系统缺口造成的。

| 事故表现 | 真正缺失的 Harness |
|---|---|
| Agent 删除重要文件 | 缺权限边界、备份、删除审批 |
| Agent 发错邮件 | 缺外部动作审批 |
| Agent 没跑测试却说通过 | 缺测试门禁和证据要求 |
| Agent 泄露 API key | 缺密钥隔离和输出脱敏 |
| Agent 被网页提示词诱导 | 缺不可信上下文隔离 |
| Agent 反复调用工具 | 缺成本限制和调用次数限制 |
| Agent 回答自信但错误 | 缺事实核查和引用机制 |

---

## 50.4 风险分级

| 等级 | 风险特征 | 示例 | 处理策略 |
|---|---|---|---|
| L0 | 无副作用 | 解释概念、生成草稿 | 可自动 |
| L1 | 低风险写入 | 新建本地草稿文件 | 自动 + diff |
| L2 | 中风险修改 | 修改仓库文件、更新知识库 | 自动执行但需 review |
| L3 | 高风险外部动作 | 发邮件、提交 case、调广告 bid | 人工审批 |
| L4 | 生产级动作 | 部署、删库、批量改预算 | 强审批 + 回滚 |
| L5 | 敏感安全动作 | 密钥、账号、权限、用户数据 | 默认禁止或专门流程 |

---

## 50.5 风险识别清单

Agent 执行前先问：

```text
这件事会不会改文件？
会不会删除东西？
会不会调用外部系统？
会不会花钱？
会不会影响用户、客户、平台或线上系统？
会不会暴露密钥或隐私？
会不会把模型输出交给下游程序执行？
会不会依赖不可信网页、邮件、文件？
做错后能不能回滚？
```

只要答案中有“会”，就要进入权限、沙盒、审批、审计或恢复设计。

---

## 50.6 迁移到你的场景

| 场景 | 主要风险 | 防线 |
|---|---|---|
| llm-wiki 沉淀 | 覆盖旧文件、混入错误知识 | 版本化、diff、范围门禁 |
| Codex 改仓库 | 改错文件、没跑测试、破坏 main | branch、CI、PR、diff |
| Skill 创建 | 误触发、执行空泛、无 eval | trigger tests、quality gate |
| 亚马逊广告分析 | 错误建议导致预算损失 | 只输出建议，自动操作需审批 |
| A+ 文案 | 夸大承诺、违规表达 | 合规检查、人工审稿 |
| 客服回复 | 事实错、承诺越权 | fact gate、send approval |
| 图片提示词 | 画面不合规、品牌偏移 | prompt gate、人工选择 |

---

## 50.7 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 风险识别 | 能把风险拆成幻觉、越权、泄密、假完成、误删等 |
| 风险分级 | 能判断哪些任务可自动，哪些必须审批 |
| 风险归因 | 不把所有错误都归因于模型 |
| 防线匹配 | 能把风险映射到对应 Harness |
| 场景迁移 | 能为你的业务 Agent 做风险清单 |

---

# 第 51 章：Permission Harness｜allowlist、denylist、approval

## 51.1 本章核心

> Permission Harness 的作用，是控制 Agent 能访问什么、能调用什么、能修改什么、什么时候必须先经过批准。

一句话：

```text
Agent 不是权限越大越强，而是权限越准越安全。
```

---

## 51.2 权限设计的三种机制

| 机制 | 作用 | 示例 |
|---|---|---|
| Allowlist | 明确允许什么 | 只允许读 `docs/` 和 `.agents/skills/` |
| Denylist | 明确禁止什么 | 禁止删除 `raw/`、禁止读取 `.env` |
| Approval | 高风险动作前暂停 | 发邮件、删除文件、部署、调广告预算前确认 |

---

## 51.3 最小权限原则

最小权限原则：

```text
Agent 只获得完成当前任务所需的最小权限。
```

| 任务 | 应给权限 | 不应给权限 |
|---|---|---|
| 解释概念 | 无工具或只读上下文 | 文件写入、外部 API |
| 生成 md 文件 | 指定输出目录写入 | 删除、覆盖 raw |
| 评估 SKILL.md | 只读 skill 文件 | 修改仓库 |
| 修改 skill | 目标目录写入 | 全仓库写入 |
| 发客服回复 | 创建草稿 | 自动发送 |
| 广告分析 | 读取报表 | 自动修改预算 |

---

## 51.4 权限矩阵

| 权限级别 | Agent 能做什么 | 适用 |
|---|---|---|
| P0 | 只能回答，不用工具 | 概念解释 |
| P1 | 只读上下文 | 读取文件、网页、报表 |
| P2 | 写草稿 | 生成文件、创建草稿 |
| P3 | 修改受控工作区 | 修改指定 repo 目录 |
| P4 | 执行命令 | 测试、构建、脚本 |
| P5 | 外部动作需审批 | 邮件、case、广告操作 |
| P6 | 生产动作强审批 | 部署、删库、权限变更 |

---

## 51.5 Tool Permission

每个工具都要标注权限属性。

| 字段 | 示例 |
|---|---|
| tool_name | `send_email` |
| read_or_write | write |
| external_side_effect | yes |
| reversible | no |
| requires_approval | yes |
| allowed_scope | specific recipient / draft only |
| audit_required | yes |

工具设计时必须区分：

```text
只读工具
本地写入工具
外部写入工具
不可逆工具
高成本工具
敏感工具
```

---

## 51.6 Approval Gate

高风险操作前应该展示：

| 审批信息 | 说明 |
|---|---|
| 即将做什么 | 动作内容 |
| 为什么要做 | 任务原因 |
| 会影响什么 | 文件、账号、预算、用户 |
| 是否可回滚 | 可逆性 |
| 风险是什么 | 错误后果 |
| 替代方案 | 是否可以先草稿 |
| 用户选择 | approve / edit / reject |

---

## 51.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 只靠 prompt 禁止 Agent 做坏事 | prompt 不是硬权限 | 用工具和系统权限限制 |
| 给全仓库写入最方便 | 误改范围大 | 限定目录和文件类型 |
| 删除后可以从 Git 找回 | 不是所有东西都在 Git | 删除要审批和备份 |
| 每次都确认最安全 | 用户疲劳 | 按风险分级审批 |
| allowlist 和 denylist 二选一 | 两者互补 | 核心路径 allow，敏感路径 deny |

---

## 51.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计权限级别 | 能按任务风险分 P0–P6 |
| 设计 allowlist | 能限定 Agent 可访问范围 |
| 设计 denylist | 能保护敏感路径和动作 |
| 设计 approval | 能让高风险动作暂停 |
| 迁移工具权限 | 能给每个工具标注风险属性 |

---

# 第 52 章：Sandbox Harness｜隔离运行环境

## 52.1 本章核心

> Sandbox Harness 的作用，是把 Agent 的执行影响限制在一个可控、可复现、可销毁、可恢复的环境里。

如果 Permission Harness 解决“Agent 能做什么”，那么 Sandbox Harness 解决：

```text
Agent 在哪里做？
能影响多大范围？
出错能不能隔离？
环境能不能复现？
```

---

## 52.2 Sandbox 解决的问题

| 问题 | 没有沙盒 | 有沙盒 |
|---|---|---|
| 文件破坏 | 可能影响真实项目 | 限制在工作区 |
| 依赖污染 | 改坏本地环境 | 容器或虚拟环境隔离 |
| 命令风险 | 误运行危险命令 | 命令 allowlist |
| 网络风险 | 随意访问外网 | 网络策略 |
| 数据泄露 | 读到敏感文件 | 挂载范围限制 |
| 难复现 | 环境不一致 | 固定依赖和镜像 |
| 难恢复 | 出错后手动修 | snapshot / rollback |

---

## 52.3 Sandbox 的组成

| 模块 | 作用 |
|---|---|
| Workspace | 指定工作目录 |
| File Mount | 控制挂载哪些文件 |
| Read-only Mount | 只读挂载重要资料 |
| Container | 隔离依赖和系统环境 |
| Virtualenv | Python 依赖隔离 |
| Network Policy | 限制联网 |
| Command Allowlist | 限制可运行命令 |
| Timeout | 防止无限运行 |
| Resource Limit | 限制 CPU、内存、磁盘 |
| Snapshot | 执行前保存状态 |
| Restore | 出错后恢复 |

---

## 52.4 沙盒成熟度

| 等级 | 特征 | 适用 |
|---|---|---|
| S0 | 无沙盒 | 纯文本任务 |
| S1 | 目录隔离 | 文档生成、低风险文件任务 |
| S2 | Git 分支隔离 | Coding Agent |
| S3 | 虚拟环境隔离 | Python / Node 本地开发 |
| S4 | 容器隔离 | CI、复杂依赖、脚本执行 |
| S5 | 生产级隔离 | 企业 Agent、敏感数据、外部动作 |

---

## 52.5 Coding Agent 沙盒

Coding Agent 推荐最小沙盒：

```text
独立 branch
指定工作目录
只允许修改目标模块
禁止读取密钥文件
允许运行 test / lint / typecheck
禁止危险 shell 命令
所有变更必须 diff
失败可 git restore
```

---

## 52.6 llm-wiki 沙盒

知识库沉淀 Agent 推荐：

```text
raw/ 只读
processed/ 可新增
schema/ 修改需确认
assets/ 可新增图片
禁止删除原始对话
禁止覆盖旧文件
所有输出加版本或日期
```

---

## 52.7 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 理解沙盒作用 | 能说明沙盒不只是安全，也支持复现和回滚 |
| 设计文件隔离 | 能区分只读、可写、禁止访问 |
| 设计命令隔离 | 能限制可运行命令 |
| 设计依赖隔离 | 能用虚拟环境或容器减少污染 |
| 迁移到项目 | 能为 Codex / llm-wiki 设计沙盒策略 |

---

# 第 53 章：Secret / Credential Safety

## 53.1 本章核心

> Secret / Credential Safety 的作用，是防止 Agent 读取、输出、记录、提交、转发或滥用密钥、账号、token、cookie、私钥和用户敏感数据。

Agent 一旦能读文件、调用工具、生成代码、写日志，就可能接触敏感信息。

---

## 53.2 什么属于 Secret / Credential

| 类型 | 示例 |
|---|---|
| API Key | OpenAI、AWS、Stripe、Amazon SP-API key |
| Token | GitHub token、OAuth access token |
| Cookie | 登录态 cookie |
| Password | 账号密码 |
| Private Key | SSH key、JWT signing key |
| Database URL | 带账号密码的连接串 |
| `.env` 文件 | 环境变量 |
| Cloud Credential | AWS access key、GCP service account |
| Customer Data | 客户邮箱、订单、地址 |
| Business Confidential | 成本、预算、供应链、广告数据 |

---

## 53.3 Secret Safety 的风险

| 风险 | 表现 |
|---|---|
| 读取风险 | Agent 读取 `.env`、密钥文件 |
| 输出风险 | Agent 把密钥写进回答 |
| 日志风险 | 工具返回中包含密钥，被写进 trace |
| 提交风险 | 密钥被 commit 到 Git |
| 转发风险 | 密钥进入邮件、case、外部系统 |
| 调用风险 | Agent 用凭证执行未授权动作 |
| 记忆风险 | 敏感数据被长期保存 |
| 训练 / 数据保留风险 | 敏感数据进入不该进入的系统 |

---

## 53.4 Secret Safety 设计原则

| 原则 | 说明 |
|---|---|
| 不暴露 | Agent 默认不读取密钥 |
| 不输出 | 输出前做 secret scan |
| 不记录 | 日志脱敏 |
| 不提交 | commit 前扫描 |
| 不记忆 | 敏感信息不进入长期记忆 |
| 不转发 | 邮件 / case / 文档输出前检查 |
| 最小授权 | token 只给必要权限 |
| 短期凭证 | 优先临时 token |
| 可撤销 | 凭证泄露后可快速 revoke |
| 分环境 | dev / staging / prod 凭证分离 |

---

## 53.5 文件和路径 denylist

常见禁止访问路径：

```text
.env
.env.*
*.pem
*.key
id_rsa
id_ed25519
credentials.json
secrets.*
.aws/
.gcp/
.azure/
node_modules/.cache with tokens
```

对 Agent 的规则：

```text
可以知道这些文件存在；
不应读取其内容；
不应复制其内容；
不应把它们写入知识库；
不应提交到 Git。
```

---

## 53.6 Secret Scan

应在这些阶段扫描：

| 阶段 | 检查 |
|---|---|
| 工具返回后 | 是否包含 token / key |
| 输出前 | 是否泄露敏感信息 |
| 写文件前 | 是否把 secret 写入文件 |
| commit 前 | 是否把 secret 提交 |
| 发邮件前 | 是否转发敏感内容 |
| 生成日志前 | 是否需要脱敏 |

---

## 53.7 迁移到你的场景

| 场景 | Secret 风险 | 处理 |
|---|---|---|
| Codex 改仓库 | 读到 `.env` | denylist + secret scan |
| Amazon 分析 | 广告数据、订单、账号 | 文件权限 + 脱敏 |
| 客服回复 | 客户信息、订单号 | 最小必要披露 |
| llm-wiki | 把敏感案例写入知识库 | 脱敏、去标识化 |
| GitHub | token 被提交 | pre-commit secret scan |
| MCP 工具 | 外部工具拿到凭证 | 最小权限 token |

---

## 53.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 识别 Secret | 能列出 API key、token、cookie、私钥等 |
| 设计 denylist | 能禁止敏感路径读取 |
| 设计脱敏 | 能在输出、日志、文件中隐藏敏感字段 |
| 设计 secret scan | 能在写入、提交、发送前检查 |
| 设计凭证权限 | 能使用最小授权和可撤销凭证 |

---

# 第 54 章：Observability Harness｜logs、trace、cost、latency

## 54.1 本章核心

> Observability Harness 的作用，是让你能看见 Agent 做了什么、为什么这么做、哪里失败、成本多少、是否值得信任。

没有可观测性，Agent 就是黑盒。

黑盒 Agent 的问题：

```text
不知道读了什么
不知道调用了什么工具
不知道为什么失败
不知道成本花在哪里
不知道是否绕流程
不知道是否重复犯错
```

---

## 54.2 Observability 看什么

| 观测对象 | 说明 |
|---|---|
| Input | 用户输入和任务类型 |
| Context | 注入了哪些上下文 |
| Model Call | 调用了哪个模型、参数是什么 |
| Tool Call | 调用了哪些工具、参数和结果 |
| Workflow Step | 当前执行到哪一步 |
| State Change | 文件、记忆、数据库改了什么 |
| Error | 错误类型、错误位置 |
| Guardrail | 哪些门禁通过 / 触发 |
| Human Approval | 谁批准了什么 |
| Output | 最终输出 |
| Cost | token、API、工具成本 |
| Latency | 每一步耗时 |
| Success Rate | 成功率、失败率、重试率 |

---

## 54.3 Logs 与 Trace 的区别

| 概念 | 说明 |
|---|---|
| Logs | 离散事件记录 |
| Trace | 一次任务从开始到结束的完整链路 |
| Metrics | 聚合指标 |
| Span | trace 中的一个步骤 |
| Event | 某个时间点发生的动作 |
| Alert | 关键异常触发通知 |

简单理解：

```text
Logs 像日记；
Trace 像行车记录仪；
Metrics 像仪表盘。
```

---

## 54.4 Trace 应该记录什么

一次 Agent run 的 trace 至少包括：

```text
run_id
user_request
selected_agent / skill
task_brief
context_sources
model_calls
tool_calls
files_read
files_written
tests_run
guardrails_triggered
human_approval
final_output
cost
latency
status
error_summary
```

---

## 54.5 指标体系

| 指标 | 说明 |
|---|---|
| Success Rate | 成功完成率 |
| Failure Rate | 失败率 |
| Retry Rate | 重试率 |
| Tool Error Rate | 工具调用失败率 |
| False Trigger Rate | Skill 误触发率 |
| False Negative Rate | Skill 漏触发率 |
| Avg Cost | 平均成本 |
| Avg Latency | 平均耗时 |
| Human Approval Rate | 人工审批比例 |
| Regression Failure Rate | 回归失败率 |
| User Correction Rate | 用户纠错比例 |
| Hallucination Rate | 事实错误比例 |

---

## 54.6 可观测性在你的场景中的应用

| 场景 | 关键观测 |
|---|---|
| Skill 创建 | 触发是否准确、eval 是否通过 |
| Codex | 读了哪些文件、改了哪些文件、测试是否运行 |
| llm-wiki | 是否覆盖指定范围、文件是否生成 |
| 广告分析 | 数据来源、指标计算、建议被采纳后的结果 |
| A+ 文案 | 用户修改点、被否定的表达 |
| 客服回复 | fact gate 是否通过、是否人工发送 |
| 图片提示词 | 用户对构图、风格、主体的反馈 |

---

## 54.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 只看最终输出 | 看不到过程风险 | 记录 trace |
| 日志越多越好 | 噪声大、成本高 | 记录关键事件 |
| trace 可以包含所有内容 | 可能泄密 | 日志脱敏 |
| 只记录失败 | 成功样本也有优化价值 | 成功和失败都记录 |
| 成本不重要 | 多 Agent 系统成本会放大 | 记录 token 和工具成本 |

---

## 54.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分 logs / trace / metrics | 能说明三者用途 |
| 设计 trace schema | 能列出一次 run 应记录什么 |
| 设计指标 | 能观察成功率、失败率、成本、延迟 |
| 诊断失败 | 能通过 trace 找到失败层 |
| 保护隐私 | 能对日志做脱敏和权限控制 |

---

# 第 55 章：Recovery Harness｜失败恢复与回滚

## 55.1 本章核心

> Recovery Harness 的作用，是让 Agent 做错后能够停止损失、恢复状态、修复问题、沉淀教训。

安全系统不能只设计“不要出错”，还要设计：

```text
出错以后怎么办？
```

---

## 55.2 Recovery 的四类动作

| 动作 | 含义 | 示例 |
|---|---|---|
| Stop | 立即停止继续损失 | 停止循环调用工具 |
| Restore | 恢复到之前状态 | git restore、snapshot rollback |
| Repair | 修复错误结果 | 改回文件、补发说明 |
| Learn | 沉淀为规则和测试 | 加 regression case |

---

## 55.3 常见失败与恢复方式

| 失败 | 恢复方式 |
|---|---|
| 改错文件 | git diff → restore 文件 |
| 覆盖旧 md | 从备份或 Git 恢复 |
| 测试失败 | 读取日志 → 修复 → 重跑 |
| 发错草稿 | 不发送，删除草稿 |
| 已发邮件错误 | 发送更正邮件，记录事故 |
| 广告操作错误 | 立即恢复预算 / bid，记录时间 |
| 密钥泄露 | revoke token，轮换密钥 |
| 数据库误改 | 从备份恢复，锁定写权限 |
| Prompt injection 成功 | 停用工具，分析 trace，加 guardrail |

---

## 55.4 Recovery 预案

高风险 Agent 任务前应该有恢复预案：

| 问题 | 预案 |
|---|---|
| 做错能不能回滚 | Git / backup / snapshot |
| 回滚需要多久 | 恢复步骤 |
| 谁来批准恢复 | 负责人 |
| 是否影响外部系统 | 影响范围 |
| 是否需要通知用户 | 通知模板 |
| 是否需要停用 Agent | Kill switch |
| 如何防止复发 | regression / rule update |

---

## 55.5 Git Recovery

Coding Agent 最常用恢复手段：

| 命令 / 机制 | 作用 |
|---|---|
| `git diff` | 看改了什么 |
| `git restore <file>` | 恢复指定文件 |
| `git restore .` | 恢复全部工作区改动 |
| branch | 隔离风险 |
| commit | 保存安全点 |
| revert | 撤销已提交变更 |
| PR close | 不合并错误变更 |
| tag | 标记稳定版本 |

---

## 55.6 llm-wiki Recovery

知识库恢复策略：

```text
raw/ 只追加，不覆盖
processed/ 允许新增，不直接覆盖
覆盖前创建 backup
重要重构先建 branch
每次沉淀后可 git commit
错误文件可 revert
schema 修改需要确认
```

---

## 55.7 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计恢复策略 | 能为文件、代码、邮件、广告操作设计恢复方式 |
| 使用 Git 回滚 | 能用 diff、restore、revert 理解恢复 |
| 设计 kill switch | 能在 Agent 失控时停止 |
| 把事故变学习 | 能把失败变成 guardrail / regression |
| 判断不可逆动作 | 能提前要求人工审批 |

---

# 第 56 章：Audit Harness｜审计与责任链

## 56.1 本章核心

> Audit Harness 的作用，是记录 Agent 在什么时间、基于什么输入、用什么权限、调用什么工具、做了什么变更、由谁批准，最终产生什么结果。

审计不是为了“追责”而已，更重要的是：

```text
复盘
合规
安全
质量改进
团队协作
长期信任
```

---

## 56.2 Audit 与 Observability 的区别

| 维度 | Observability | Audit |
|---|---|---|
| 关注点 | 系统运行是否正常 | 谁做了什么、为何做、是否合规 |
| 用途 | 调试、优化、监控 | 责任链、合规、复盘 |
| 数据 | logs、trace、metrics | approval、decision、change record |
| 时间尺度 | 实时或短期 | 长期留存 |
| 重点 | 性能和故障 | 权限和行为记录 |

---

## 56.3 Audit Log 应记录什么

| 字段 | 说明 |
|---|---|
| audit_id | 审计记录编号 |
| run_id | 对应 Agent run |
| user_request | 用户请求 |
| agent / skill | 哪个 Agent 或 Skill 执行 |
| timestamp | 时间 |
| input_sources | 使用了哪些输入 |
| context_sources | 读取了哪些上下文 |
| tool_calls | 调用了哪些工具 |
| permission_level | 权限等级 |
| approval_record | 谁批准了什么 |
| files_changed | 改了哪些文件 |
| external_actions | 是否有外部动作 |
| test_results | 验证结果 |
| final_output | 最终产物 |
| risk_level | 风险等级 |
| reviewer | 审查人 |
| rollback_info | 回滚方式 |

---

## 56.4 审计链路

```text
用户请求
→ 任务入口
→ 权限分级
→ 上下文读取
→ 工具调用
→ 文件变更
→ 测试验证
→ 人工审批
→ 最终交付
→ 复盘沉淀
```

每个关键节点都应该留下记录。

---

## 56.5 审计在你的场景中的应用

| 场景 | 审计重点 |
|---|---|
| Codex 改代码 | 改动文件、测试结果、PR review |
| Skill 创建 | Skill 版本、eval 结果、changelog |
| llm-wiki | 来源对话、输出文件、版本 |
| 广告建议 | 数据周期、建议动作、采纳结果 |
| 客服回复 | 原 case、事实核对、发送审批 |
| 图片生成 | 输入提示词、参考图、版本选择 |
| 权限变更 | 谁授权、授权范围、有效期 |

---

## 56.6 审计与知识沉淀

审计记录可以转化为：

| 审计内容 | 沉淀产物 |
|---|---|
| 高频错误 | failure patterns |
| 常见修复 | playbook |
| 高风险动作 | approval policy |
| 重复用户反馈 | style guide |
| 回归失败 | regression cases |
| 成功案例 | best practices |
| 工具事故 | tool policy update |

---

## 56.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 审计只适合企业 | 个人 Agent 系统也需要复盘 | 轻量审计即可 |
| 只记录最终输出 | 无法追踪过程 | 记录关键节点 |
| 审计记录越详细越好 | 泄密和噪声风险 | 记录必要信息并脱敏 |
| 没有外部动作就不用审计 | 文件和知识库也会被污染 | 重要变更都要审计 |
| 审计只是事后记录 | 也能反哺规则和测试 | 审计进入反馈循环 |

---

## 56.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分观测与审计 | 能说明 observability 看运行，audit 看责任链 |
| 设计审计字段 | 能记录输入、工具、权限、审批、变更 |
| 建立责任链 | 能知道谁批准了什么、Agent 做了什么 |
| 支持复盘 | 能从审计记录提炼失败模式 |
| 支持知识沉淀 | 能把审计结果转成规则、模板、测试 |

---

# 阶段八总结

## 1. 用一句话总结

> 阶段八的核心是：让 Agent 的能力被安全边界、权限控制、执行隔离、密钥保护、可观测性、恢复机制和审计链路包住。

---

## 2. 七大安全模块总图

```text
安全、权限与可观测性 Harness
├─ 50 风险类型
│  └─ 误删、越权、幻觉、泄密、假完成
├─ 51 Permission Harness
│  └─ allowlist、denylist、approval
├─ 52 Sandbox Harness
│  └─ workspace、container、network、snapshot
├─ 53 Secret Safety
│  └─ 密钥隔离、脱敏、扫描、最小授权
├─ 54 Observability Harness
│  └─ logs、trace、metrics、cost、latency
├─ 55 Recovery Harness
│  └─ stop、restore、repair、learn
└─ 56 Audit Harness
   └─ 审计记录、责任链、复盘沉淀
```

---

## 3. 安全设计的核心公式

```text
Agent 安全 = 风险识别
           + 最小权限
           + 沙盒隔离
           + 密钥保护
           + 自动门禁
           + 人工审批
           + 可观测性
           + 可恢复性
           + 审计记录
```

---

## 4. 阶段八最重要的判断

```text
不要问：如何让 Agent 更自由？

应该问：

它需要哪些最小权限？
哪些动作必须审批？
它在哪里运行？
它能不能看到密钥？
它做过什么能不能追踪？
它做错后能不能回滚？
这次失败能不能沉淀为规则和测试？
```

---

## 5. 阶段八掌握标准

| 能力 | 判断标准 |
|---|---|
| 风险识别 | 能识别幻觉、越权、误删、泄密、假完成 |
| 权限设计 | 能设计 allowlist、denylist、approval |
| 沙盒设计 | 能隔离文件、命令、网络、依赖 |
| 密钥保护 | 能防止 secret 被读取、输出、提交、记录 |
| 可观测性 | 能设计 logs、trace、metrics |
| 恢复机制 | 能设计 stop、restore、repair、learn |
| 审计能力 | 能建立行为记录和责任链 |
| 场景迁移 | 能为 Codex、Skill、llm-wiki、业务 Agent 设计安全外壳 |

---

# 下一阶段预告

## 阶段九：多 Agent 与高级架构｜第 57–63 章

| 章 | 主题 |
|---:|---|
| 57 | Planner / Executor / Reviewer 架构 |
| 58 | Critic Agent 与 Review Agent |
| 59 | Router Harness：任务路由与模型选择 |
| 60 | Long-Horizon Harness：长任务规划与恢复 |
| 61 | Multi-Agent State：共享状态与冲突控制 |
| 62 | Agent Swarm 的边界与误区 |
| 63 | Agent System Design：从单 Agent 到 Agent 平台 |

---

# 参考来源

- OpenAI Agents SDK：Guardrails and human review  
  https://developers.openai.com/api/docs/guides/agents/guardrails-approvals
- OpenAI Agents SDK：Agents overview  
  https://developers.openai.com/api/docs/guides/agents
- OpenAI Agents Python SDK：Guardrails  
  https://openai.github.io/openai-agents-python/guardrails/
- Model Context Protocol：Tools specification  
  https://modelcontextprotocol.io/specification/2025-06-18/server/tools
- OWASP Top 10 for Large Language Model Applications  
  https://owasp.org/www-project-top-10-for-large-language-model-applications/
- OWASP GenAI Security Project：Top 10 2025  
  https://genai.owasp.org/llm-top-10/
