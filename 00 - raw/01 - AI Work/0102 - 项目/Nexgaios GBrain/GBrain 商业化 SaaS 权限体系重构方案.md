---
title: 'GBrain 商业化 SaaS 权限体系重构方案'
status: raw
created: '2026-06-11 19:58'
source_type: unknown
material_type: 方案
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'GBrain'
  - 'MCP'
  - 'GitHub'
  - 'Knowledge-Base'
---

# GBrain 商业化 SaaS 权限体系重构方案

## 0. 设计目标

当前 GBrain 已经完成了公司级知识库的基础形态：

```text
公司知识库 repo: terry-nexgaios-gbrain
GBrain source:   nexgaios
MCP endpoint:    https://gbrain.nexgaios.com/mcp
Terry token:     terry-home-codex
```

但当前权限仍然是内测形态：

```text
URL + legacy bearer token
token 权限 = read / write / admin
```

这对 Terry 一个人或极小范围可信团队够用，但不适合作为商业化 SaaS 产品的权限底座。商业 SaaS 必须支持：

```text
多租户隔离
组织 / 团队 / 成员管理
角色权限
资源级权限
MCP 工具级权限
搜索结果级权限过滤
短期 token / 可撤销 token
完整审计日志
权限管理后台
企业级 SSO / SCIM / 合规扩展
```

本方案目标是把 GBrain 从“个人/团队内部工具”重构为“可商业化交付的企业知识库 SaaS 权限系统”。

## 1. 总体权限模型

### 设计

新的权限层级：

```text
Tenant / Organization 租户 / 公司
  Workspace / Brain 工作区 / 知识脑
    Source 内容来源 / Git repo
      Collection / Folder 知识集合 / 文件夹
        Page 页面 / Markdown 文档
          Chunk / Attachment 文本块 / 附件
```

当前 NexGaios 映射为：

```text
Tenant:    NexGaios
Workspace: Company Brain
Source:    nexgaios
Repo:      terry-nexgaios-gbrain
Folders:   aiwork / amazon / product
Pages:     Markdown 文件
```

### 为什么这样设计

商业 SaaS 的第一原则是：**客户之间必须隔离，公司内部不同团队也要能分权**。

如果只用一个 token 控制整个 GBrain，那么任何拿到 token 的人都能读写所有知识；这不符合 SaaS 的安全要求，也无法支持未来的客户、团队、外部顾问、只读成员等场景。

### 解决的问题

```text
避免不同公司数据混在一起
避免一个成员看到不该看的知识
避免一个 token 泄露导致全库暴露
避免以后扩展企业客户时推倒重来
```

### 对 Terry 的价值

Terry 是 CEO，需要最高且完整权限，但同时需要把权限“可控地分发”给团队。这个模型让 Terry 拥有公司全局视角，又能给不同成员分配不同访问范围。

Terry 的目标不是自己少权限，而是：

```text
Terry 拥有全部权限
团队成员只拥有完成工作所需的权限
所有权限变更和访问行为可审计
```

## 2. 租户与工作区模型

### 设计

新增核心概念：

```text
tenant = 一个客户 / 一家公司
workspace = 该客户下的一个知识工作区
brain = workspace 背后的 GBrain 数据库或逻辑知识脑
```

当前：

```text
tenant_id: nexgaios
workspace_id: company-brain
```

未来商业化：

```text
tenant: NexGaios
tenant: Client A
tenant: Client B
```

每个 tenant 的数据、成员、token、审计日志都必须隔离。

### 为什么这样设计

SaaS 产品不是只服务 Terry 一家公司，而是未来可能服务多个客户。多租户模型是商业化 SaaS 的基础。

如果没有 tenant 层，后续会出现：

```text
客户 A 的用户误查客户 B 的数据
审计日志无法按客户分离
账单和权限无法按客户管理
企业客户无法放心接入
```

### 解决的问题

```text
多客户隔离
按客户收费
按客户导出数据
按客户配置 SSO
按客户设置安全策略
```

### 对 Terry 的价值

Terry 当前是 NexGaios 的最高管理员。以后如果把 GBrain 产品化，Terry 可以同时看到：

```text
NexGaios 自己的知识库
客户租户列表
客户使用情况
安全与审计状态
```

这让 Terry 从“使用者”升级成“平台所有者”。

## 3. 身份主体模型

### 设计

所有请求必须解析成一个明确主体：

```text
user              人类用户
service_account   服务账号
mcp_client        MCP 客户端
api_client        API 客户端
system_job        系统任务
break_glass_admin 应急管理员
```

每个主体包含：

```text
principal_id
tenant_id
workspace_id
auth_method
roles
groups
scopes
resource_grants
token_id
last_used_at
risk_level
```

### 为什么这样设计

当前 token 只知道“这个 token 能用”，但不知道背后是谁、属于哪个组织、为什么有权限、是否应该撤销。

SaaS 权限必须回答：

```text
谁在访问？
代表哪个组织？
用什么凭据？
能访问哪些资源？
为什么允许？
什么时候访问？
```

### 解决的问题

```text
无法追责
无法按人撤销
无法区分人类和自动化脚本
无法限制某个 MCP 客户端
无法判断异常访问
```

### 对 Terry 的价值

Terry 可以清楚看到：

```text
谁接入了公司知识库
谁最近使用过
谁创建了内容
哪个自动化任务在同步
哪个 token 需要撤销
```

这对 CEO 管理公司知识资产非常关键。

## 4. 角色模型 RBAC

### 设计

使用 RBAC 做粗粒度角色控制。

租户级角色：

```text
tenant_owner      租户所有者
tenant_admin      租户管理员
security_admin    安全管理员
billing_admin     账单管理员
auditor           审计员
member            普通成员
external_guest    外部访客
```

知识脑 / 工作区级角色：

```text
brain_owner
brain_admin
maintainer
editor
contributor
viewer
```

服务角色：

```text
sync_runner
embed_runner
readonly_mcp_client
writer_mcp_client
admin_mcp_client
automation_bot
```

Terry 默认：

```text
tenant_owner
brain_owner
security_admin
```

### 为什么这样设计

角色是权限管理后台里最容易理解的抽象。商业产品不能要求管理员手动配置几百条底层权限。

RBAC 让 Terry 可以用简单语言管理：

```text
这个人是管理员
这个人只能看
这个人能编辑
这个机器人只能同步
```

### 解决的问题

```text
权限配置复杂
成员入职配置成本高
权限含义不清楚
管理员不知道某个人能做什么
```

### 对 Terry 的价值

Terry 不需要理解每个底层 tool 的权限细节，只需要选择角色。比如：

```text
核心团队：editor
普通成员：viewer
外部顾问：external_guest
自动同步任务：sync_runner
```

这符合 CEO 的管理方式。

## 5. 资源级权限 ABAC / ACL

### 设计

RBAC 只解决“这个人是什么角色”，还需要资源级权限解决“这个人能访问哪部分内容”。

资源引用格式：

```text
nexgaios:/**
nexgaios:aiwork/**
nexgaios:amazon/**
nexgaios:product/**
nexgaios:people/**
nexgaios:projects/<project>/**
```

策略示例：

```json
{
  "tenant_id": "nexgaios",
  "workspace_id": "company-brain",
  "resource_type": "collection",
  "resource_ref": "nexgaios:amazon/**",
  "principal_type": "group",
  "principal_ref": "amazon-team",
  "actions": ["page.read", "page.write", "search.query"],
  "effect": "allow"
}
```

### 为什么这样设计

现在 `aiwork / amazon / product` 已经不是 GBrain source，而是 `nexgaios` repo 下的文件夹。业务权限必须落到文件夹、页面、分类层。

这样既保留了一个公司级 repo 的管理便利，又能做到业务权限隔离。

### 解决的问题

```text
一个 source 里不同目录无法分权
Amazon 团队不一定应该看 Product
外部顾问只能看指定文件夹
敏感页面需要单独限制
```

### 对 Terry 的价值

Terry 可以从 CEO 视角统一管理公司知识库，同时精细授权：

```text
自己看全部
Amazon 负责人看 amazon/**
产品负责人看 product/**
AI 工作流成员看 aiwork/**
外部合作方只看某个项目目录
```

这比拆多个 repo 更适合 Terry 的日常管理。

## 6. 页面分类与敏感级别

### 设计

每个页面支持 classification：

```text
public
internal
confidential
restricted
secret
```

默认：

```text
internal
```

Markdown frontmatter 示例：

```yaml
---
classification: confidential
owner: terry
allowed_groups:
  - leadership
---
```

如果页面没有 frontmatter，则继承文件夹策略。

### 为什么这样设计

商业知识库里，不是所有内容都同等敏感。

比如：

```text
公开 SOP
内部流程
客户资料
财务信息
战略判断
CEO 私人判断
```

它们必须有不同保护等级。

### 解决的问题

```text
敏感内容误暴露
普通成员看到 CEO 战略判断
外部成员看到内部资料
权限只能按目录，无法按内容敏感度控制
```

### 对 Terry 的价值

Terry 可以把重要判断和敏感信息放进知识库，而不是因为担心泄露而不敢沉淀。

这会让 GBrain 真正成为 CEO 的公司大脑，而不是只能放低风险资料的文档库。

## 7. 动作权限模型

### 设计

把所有能力拆成标准动作：

```text
brain.read
brain.admin
source.sync
source.admin
collection.read
collection.write
page.read
page.create
page.update
page.delete
page.restore
page.export
search.query
tool.call
credential.create
credential.revoke
audit.read
admin.read
admin.write
```

每个 MCP tool 映射到动作：

```text
whoami       -> self.read
sources_list -> source.read
query/search -> search.query + page.read
get_page     -> page.read
put_page     -> page.create / page.update
delete_page  -> page.delete
sources_add  -> source.admin
auth create  -> credential.create
jobs list    -> admin.read
```

### 为什么这样设计

MCP 工具很多，如果不统一建模，就会变成每个工具自己判断权限，后续一定出漏洞。

统一 action 模型可以保证：

```text
所有入口用同一套权限判断
新增 tool 必须声明权限
权限后台能展示清楚
审计日志能归类
```

### 解决的问题

```text
工具权限散落在代码里
新增 tool 忘记加权限
读权限用户调用了写工具
管理员不知道某个 token 到底能做什么
```

### 对 Terry 的价值

Terry 可以清楚知道：

```text
这个人能不能写页面
这个人能不能删页面
这个 token 能不能创建其他 token
这个客户端能不能同步 source
```

这让权限从“感觉安全”变成“可解释、可管理”。

## 8. Token 与凭据体系

### 设计

废弃普通成员使用永久 full-admin legacy bearer token。

凭据类型：

```text
browser_session
oauth_access_token
oauth_refresh_token
personal_access_token
service_account_key
mcp_install_token
break_glass_token
```

推荐有效期：

```text
OAuth access token: 15-60 分钟
refresh token: 7-30 天，轮换
个人 MCP token: 30-90 天
service account key: 90-180 天
break-glass token: 默认禁用，临时启用
```

token 必须包含：

```text
token_id
owner_principal_id
tenant_id
workspace_id
scopes
resource_grants
expires_at
last_used_at
revoked_at
created_by
```

token 只保存 hash，不保存明文。

### 为什么这样设计

商业 SaaS 最大风险之一是 token 泄露。当前 `expires_at=null` 的永久 full-admin token 对 SaaS 来说风险太高。

### 解决的问题

```text
token 泄露无法控制损失
token 不知道是谁创建的
token 没有过期时间
token 无法按资源限制
token 被滥用无法定位
```

### 对 Terry 的价值

Terry 仍然有最高权限，但不再需要日常使用永久 root token。

Terry 可以：

```text
给某成员发只读 token
给某机器人发同步 token
给某外部顾问发 7 天临时 token
看到 token 最近使用时间
一键撤销异常 token
```

这才像真正的 SaaS 权限体验。

## 9. MCP 授权机制

### 设计

每次 MCP 请求都必须经过完整授权链：

```text
1. authenticate token
2. resolve principal
3. load tenant / workspace / grants
4. authorize tool
5. authorize resource
6. pre-filter search candidates
7. post-filter returned results
8. write audit event
```

不同权限用户看到的 tools/list 不一样。

示例：

```text
viewer:
  whoami
  query
  search
  get_page

editor:
  viewer tools
  put_page within allowed folders

admin:
  source management
  credential management
  jobs
  audit
```

### 为什么这样设计

MCP 是 AI agent 的工具入口。AI agent 可以自动调用工具，所以权限必须比普通 API 更严格。

不能依赖“模型会自觉不调用危险工具”。

### 解决的问题

```text
只读用户看到写工具
AI agent 意外删除页面
工具调用绕过 Web 后台权限
MCP 成为权限后门
```

### 对 Terry 的价值

Terry 可以放心让团队用 Codex / Claude / Cursor 接入 GBrain，因为每个 AI client 的能力被权限系统限制住。

Terry 自己仍然拥有完整工具集。

## 10. 搜索与向量检索权限

### 设计

搜索必须权限感知。

过滤维度：

```text
tenant_id
workspace_id
source_id
slug prefix
classification
deleted_at
retention policy
legal hold
```

过滤必须发生在：

```text
keyword search 前
vector search 前
rerank 前
neighbor expansion 前
query cache 读写前
最终结果返回前
```

query cache key 必须包含：

```text
tenant_id
workspace_id
principal_policy_hash
allowed_resource_hash
query_text
search knobs
```

### 为什么这样设计

知识库权限最容易出问题的地方不是 `get_page`，而是搜索。

如果搜索先查全库再过滤，可能在 rerank、cache、摘要、中间日志里泄露信息。

### 解决的问题

```text
用户通过搜索看到无权限页面片段
向量检索召回了敏感 chunk
query cache 把管理员结果返回给普通用户
reranker 处理了不该看的内容
```

### 对 Terry 的价值

Terry 可以把更多真实业务内容放进 GBrain，而不用担心成员通过模糊搜索“捞到”敏感信息。

这对 CEO 级知识库非常重要。

## 11. 审计日志

### 设计

所有关键行为写入不可变审计日志：

```text
auth.login
auth.token_created
auth.token_revoked
mcp.tool_called
page.read
page.write
page.delete
source.sync
policy.created
policy.updated
admin.action
export.created
```

审计字段：

```text
event_id
tenant_id
workspace_id
principal_id
token_id
client_id
ip
user_agent
tool_name
resource_ref
decision
policy_version
request_id
created_at
```

### 为什么这样设计

商业 SaaS 必须能回答：

```text
谁看过这份资料？
谁改了权限？
谁创建了 token？
哪个 AI client 调用了写工具？
某次事故影响了哪些页面？
```

### 解决的问题

```text
权限问题无法追责
数据泄露无法调查
客户合规审计无法交付
管理员操作不可见
```

### 对 Terry 的价值

Terry 能获得公司知识资产的真实可见性：

```text
谁在使用知识库
哪些内容被频繁查询
哪些 token 有风险
团队是否真的在沉淀和复用知识
```

这不只是安全，也是管理仪表盘。

## 12. 权限管理后台

### 设计

新增权限管理后台，作为 SaaS 产品的一等模块。

后台一级导航：

```text
Overview 总览
Members 成员
Groups 用户组
Roles 角色
Resources 资源权限
MCP Clients MCP 客户端
Tokens & Keys 凭据
Audit Logs 审计日志
Security 安全设置
Integrations 集成
Billing / Plan 计费方案
```

核心页面：

```text
成员列表
成员详情
用户组管理
角色模板管理
文件夹权限管理
MCP client 管理
token 创建 / 撤销 / 过期
审计日志检索
异常访问告警
SSO / SCIM 设置
```

### 为什么这样设计

没有后台，权限系统就只是数据库和命令行配置，不是 SaaS 产品。

商业客户需要的是：

```text
管理员能看懂
权限能自助配置
出问题能追踪
成员变动能快速处理
```

### 解决的问题

```text
权限只能靠工程师改数据库
无法让非技术管理员操作
无法审计和撤销 token
客户无法自主管理组织
```

### 对 Terry 的价值

Terry 作为 CEO 可以直接在后台看到：

```text
谁有最高权限
谁能访问 Amazon 资料
谁最近使用了 MCP
哪个 token 长期没用
哪些页面被频繁访问
是否存在过期权限
```

这会让 GBrain 从“工具”变成“公司知识治理系统”。

## 13. 权限管理后台的 Terry 视角

### Terry 的权限

Terry 是最高权限用户：

```text
tenant_owner
brain_owner
security_admin
billing_admin
auditor
```

Terry 可以：

```text
查看全部知识
编辑全部知识
删除 / 恢复知识
管理成员
创建和撤销 token
管理 MCP client
设置权限策略
查看全部审计日志
导出数据
配置 SSO / SCIM
处理安全事件
```

### Terry 的日常管理任务

```text
给新员工开通账号
把员工加入对应组
给外部顾问设置临时访问
查看团队知识使用情况
撤销离职员工权限
检查高权限 token
审计 AI client 的写入行为
```

### 为什么单独设计 Terry 视角

CEO 不是普通管理员。Terry 需要全局权限，但更需要全局可见性和控制权。

后台应该让 Terry 快速回答：

```text
公司知识资产在哪里？
谁能看？
谁改过？
哪些内容最重要？
哪里有安全风险？
```

## 14. 数据库结构建议

### 新增表

```text
tenants
users
memberships
groups
group_members
workspaces
collections
resource_policies
credentials
service_accounts
mcp_clients
audit_events
policy_versions
```

### 现有表增加字段

```text
pages.tenant_id
pages.workspace_id
pages.classification
pages.owner_user_id
content_chunks.tenant_id
content_chunks.workspace_id
query_cache.tenant_id
query_cache.policy_hash
oauth_clients.tenant_id
access_tokens.tenant_id
```

### 为什么这样设计

权限不能只存在代码里，必须成为数据模型的一部分。

### 解决的问题

```text
无法按租户过滤
无法按策略审计
无法知道页面归属
无法安全缓存搜索结果
无法做企业导出
```

### 对 Terry 的价值

这让 Terry 的公司知识库具备商业级可治理性，为未来产品化、客户化、融资尽调、合规审计打基础。

## 15. 迁移路线

### Phase 1：冻结风险

```text
停止创建共享 legacy token
盘点所有 active token / OAuth client
把 Terry token 标记为 owner-only
记录当前 token 使用者
```

### Phase 2：身份与组织表

```text
创建 tenant / user / group / membership
创建 workspace
把 nexgaios source 绑定到 workspace
```

### Phase 3：策略引擎

```text
实现 authorize(principal, action, resource)
所有 MCP tool 调用接入 authorize
```

### Phase 4：搜索权限过滤

```text
query/search 前置权限过滤
返回结果二次过滤
query cache 加 policy hash
```

### Phase 5：scoped MCP token

```text
替换 legacy token
支持 read-only / editor / admin / service token
支持过期、撤销、last_used_at
```

### Phase 6：权限管理后台

```text
成员管理
组管理
角色管理
资源授权
MCP client 管理
token 管理
审计日志
```

### Phase 7：企业能力

```text
SSO / OIDC
SCIM
审计导出
保留策略
legal hold
企业级 rate limit
安全告警
```

## 16. NexGaios 初始权限模板

### 组

```text
owners
admins
editors
viewers
external
```

### Terry

```text
user: terry
groups: owners
roles:
  tenant_owner
  brain_owner
  security_admin
  billing_admin
  auditor
permissions:
  nexgaios:/** all actions
```

### admins

```text
nexgaios:/** read/write
credential.manage non-owner tokens
audit.read
```

### editors

```text
nexgaios:aiwork/** read/write
nexgaios:amazon/** read/write if assigned
nexgaios:product/** read/write if assigned
```

### viewers

```text
nexgaios:/** read
```

### external

```text
explicit folder grant only
default deny
short token expiry
```

## 17. 不可妥协原则

```text
不共享团队 token
普通成员不使用永久 admin token
搜索必须先过滤权限
写入必须检查资源授权
管理员操作必须审计
token 不保存明文
query cache 不能跨权限复用
审计日志不能通过产品 UI 删除
Terry 拥有最高权限，但日常操作仍被审计
```

## 18. 参考标准与实践

本方案参考：

```text
OWASP Multi Tenant Security
OWASP Authorization Cheat Sheet
OWASP API Security
OAuth 2.1 / OAuth 2.0 Security Best Current Practice
MCP Authorization Specification
NIST Digital Identity Guidelines
```

