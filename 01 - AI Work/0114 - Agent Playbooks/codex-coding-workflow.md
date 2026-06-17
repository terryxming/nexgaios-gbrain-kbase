# Codex 写代码工作流

日期：2026-06-16

页面类型：Agent Playbook

适用范围：NexGaios 内部所有由 Codex 参与的工程实现、代码修改、后台功能、脚本、部署、权限、MCP 接入、数据同步和技术排障任务。

## 1. 这页是什么

这页定义 Codex 在 NexGaios 做工程任务时如何使用 GBrain 作为第二大脑。

Codex 的第一大脑是模型自身的通用编程、推理和调试能力。GBrain 的第二大脑是公司长期记忆，包括业务背景、架构、部署方式、权限边界、历史决策、项目状态、踩坑记录和 Terry 的偏好。

本工作流的目标是让 Codex 在写代码时不只“能写”，而是能在 NexGaios 的真实上下文里写对、写稳、可交接。

## 2. 适用场景

只要任务符合下面任一条件，Codex 都应该进入本工作流：

1. 修改 GBrain、后台、MCP、同步脚本、权限系统、部署脚本或其他生产代码。
2. 新增 API、后台页面、数据库字段、迁移、脚本、测试或自动化任务。
3. 排查线上服务、AWS、Postgres、GitHub、Markdown 同步、Codex Desktop MCP 接入问题。
4. 修改和权限、Token、账号、密码、成员、审计、公司知识库内容写入相关的逻辑。
5. 对已有工程设计作出新决策，例如调整目录结构、source 模型、数据同步方式、部署方式。

## 3. 写代码前必须检索的第二大脑内容

Codex 开始写代码前，应优先从 GBrain 检索以下页面或目录。若页面还不存在，应在任务中明确标记“缺少该类长期记忆”，不要假装已经知道。

### 3.1 公司与业务背景

优先检索：

1. `company/context`
2. `company/strategy`
3. `company/terry-principles`

目的：

1. 理解 NexGaios 当前阶段目标。
2. 理解 Terry 的决策偏好、管理方式、产品审美和风险偏好。
3. 避免把通用 SaaS 或通用工程最佳实践机械套进公司实际。

### 3.2 当前系统架构

优先检索：

1. `engineering/architecture`
2. `engineering/gbrain-architecture`
3. `engineering/data-flow`
4. `engineering/mcp-architecture`

目的：

1. 知道 GBrain 当前由哪些模块组成。
2. 知道 HTTP MCP、Admin 后台、Postgres、Markdown repo、GitHub、本地移动硬盘之间如何流转。
3. 避免新增重复机制或破坏已有数据流。

### 3.3 部署和运行环境

优先检索：

1. `engineering/deployments`
2. `engineering/aws-production`
3. `engineering/runtime-env`
4. `engineering/rollback`

目的：

1. 确认线上入口、服务端口、systemd 服务、部署路径、反向代理和健康检查方式。
2. 确认是否需要备份、是否需要重启服务、如何验证线上服务。
3. 避免把本地开发假设当作线上事实。

当前已知生产入口：

1. Admin 后台：`https://gbrain.nexgaios.com/admin/`
2. MCP 入口：`https://gbrain.nexgaios.com/mcp`
3. 主租户：`nexgaios`
4. 主工作区：`company-brain`
5. 主 source：`nexgaios`

### 3.4 权限与安全边界

优先检索：

1. `aiwork/gbrain/permission-system-handoff-2026-06-11`
2. `engineering/permissions`
3. `engineering/security`
4. `agent-playbooks/codex-coding-workflow`

目的：

1. 确认 Terry、管理员、viewer、editor 的权限边界。
2. 确认 Token、密码、setup link、审计、成员状态的处理规则。
3. 修改权限相关代码前，必须理解当前权限系统不是临时脚本，而是商业 SaaS 权限模型的 V1。

### 3.5 历史技术决策

优先检索：

1. `decisions/engineering`
2. `decisions/gbrain`
3. `decisions/permissions`
4. `decisions/knowledge-architecture`

目的：

1. 知道哪些方案已经被讨论、采用或放弃。
2. 保留决策理由，而不是只保留最后代码状态。
3. 避免重复争论已经确定过的方向。

### 3.6 当前项目状态

优先检索：

1. `projects/current`
2. `projects/gbrain/current-status`
3. `projects/gbrain/next-steps`

目的：

1. 确认当前阶段重点。
2. 知道哪些任务已经完成，哪些是下一阶段。
3. 避免在知识库内容阶段又回头做不必要的权限系统扩展。

## 4. 写代码时必须遵守的工程规则

### 4.1 先读现有系统，再改代码

Codex 必须先理解现有代码结构、数据模型、调用路径和测试方式，再做修改。

不允许：

1. 未读现有代码就重写模块。
2. 为了完成小需求引入大而新的抽象。
3. 对无关文件做格式化或风格改造。
4. 覆盖用户或团队已经做出的未提交修改。

### 4.2 保持改动边界清晰

每次工程任务应尽量只修改与目标直接相关的文件。

若发现顺手可改的问题，应先判断是否属于当前任务：

1. 若会影响当前功能安全性，可以一起修。
2. 若只是代码洁癖或重构偏好，应记录为后续待办。
3. 若会改变产品行为、权限边界或数据结构，应先和 Terry 确认。

### 4.3 生产安全优先

涉及线上服务时，必须遵守：

1. 部署前先备份关键线上文件或数据库变更点。
2. 本地测试通过后再部署。
3. 重启服务后检查 systemd 状态。
4. 使用正确端口和公网入口做健康检查。
5. 验收核心 API 或页面，而不是只看服务 active。
6. 若部署失败，应优先保护当前线上服务可用性。

### 4.4 权限、Token、密码必须高谨慎

涉及以下内容时必须写审计、做验证、避免明文泄漏：

1. 成员创建、停用、删除。
2. 分组、角色、策略变更。
3. MCP Token 创建、轮换、吊销、过期。
4. 后台登录、密码修改、密码重置、setup link。
5. AWS、Postgres、GitHub、移动硬盘、服务器路径。

不允许把明文 Token、密码、一次性链接写入长期文档。

### 4.5 后台 UI 必须符合 NexGaios 当前产品规则

后台 UI 相关修改必须遵守：

1. 中文文案走语言包。
2. 支持深色和浅色模式。
3. 最小字号不低于 14px。
4. 不新增英文主流程文案，除非是 API 名、Token、MCP、URL 等技术名词。
5. 不把操作说明堆在页面上，优先用清晰控件和状态表达。
6. 操作结果中可复制 Token 或链接，但必须标明只显示一次。

## 5. 写完代码后的验证要求

根据改动范围，Codex 应选择合适验证：

1. 纯函数或解析逻辑：跑对应 unit test。
2. 后台 UI：跑 admin build，必要时打开页面验证。
3. TypeScript 改动：跑 typecheck。
4. 权限系统：验证允许和拒绝两条路径。
5. Token/密码/setup link：验证成功路径和失败路径。
6. 线上部署：检查 `/health`、核心 API、后台静态资源和实际业务动作。

验证结果必须在最终回复和写回文档中记录。

## 6. 写完代码后必须写回 GBrain 的内容

如果任务产生了长期价值，Codex 必须写回 GBrain。不要把重要工程知识只留在聊天记录里。

### 6.1 必须写回的内容

1. 新增能力：
   - 新 API
   - 新后台页面
   - 新脚本
   - 新同步流程
   - 新权限模型

2. 数据流变化：
   - 新增表、字段、JSON 结构
   - 新增文件路径
   - 新增 GitHub 或本地目录规则
   - 新增 MCP tool 使用方式

3. 部署变化：
   - 服务路径
   - 端口
   - systemd 服务
   - 反向代理
   - 环境变量
   - 回滚方式

4. 权限变化：
   - 成员权限
   - 分组和角色
   - 策略
   - Token 生命周期
   - 审计和告警规则

5. 踩坑记录：
   - 失败命令
   - 错误原因
   - 解决方式
   - 下次如何避免

6. 后续待办：
   - 当前未完成的风险
   - 商业化成熟度差距
   - 下一阶段建议

### 6.2 推荐写回位置

根据任务类型写回：

1. 工程架构：`engineering/architecture`
2. 部署运维：`engineering/deployments`
3. 权限系统：`engineering/permissions` 或 `aiwork/gbrain/permission-system-handoff-*`
4. 技术决策：`decisions/engineering`
5. 当前状态：`projects/gbrain/current-status`
6. 踩坑记录：`engineering/incidents` 或 `engineering/runbooks`
7. Agent 工作规则：`agent-playbooks/*`

## 7. 什么情况必须问 Terry

以下情况不得默认执行，必须先问 Terry：

1. 会改变公司知识库顶层目录结构。
2. 会删除、迁移或覆盖大批 Markdown 内容。
3. 会新增长期云资源或产生持续成本。
4. 会改变 Terry 或管理员的最高权限。
5. 会吊销 Terry 当前正在使用的 Token。
6. 会把某个成员从只读提升为可写或管理员。
7. 会公开、外发或同步可能包含公司敏感信息的内容。
8. 会引入新的第三方 SaaS、邮件服务、SSO、支付或身份系统。
9. 需要在生产数据库做不可逆迁移。

## 8. 推荐执行模板

Codex 在执行工程任务时，应按这个节奏：

1. 识别任务类型。
2. 检索 GBrain 相关页面。
3. 读取本地代码和当前状态。
4. 给出简短执行计划。
5. 实施代码改动。
6. 本地测试和构建。
7. 如需要，备份并部署线上。
8. 线上验收。
9. 写回 GBrain。
10. 用简洁总结告诉 Terry：改了什么、验证了什么、下一步是什么。

## 9. 当前第一版的边界

这份 playbook 是 Codex 写代码场景的第一版。它目前已经能指导 GBrain 权限系统、后台、MCP、同步脚本和内容层建设。

后续需要补充：

1. 代码仓库规范页面。
2. GBrain 线上部署 runbook。
3. Markdown 到 GBrain 同步 runbook。
4. 常见事故处理 runbook。
5. 数据库迁移和回滚规范。
6. 前端后台设计规范。

## 10. 本页的维护规则

当 Terry 明确改变工程偏好、部署方式、权限边界或知识库内容流转方式时，Codex 应更新本页。

当 Codex 在工程任务中踩到新坑并确认有复用价值时，应把经验沉淀到相关 runbook，并在本页补充引用。
