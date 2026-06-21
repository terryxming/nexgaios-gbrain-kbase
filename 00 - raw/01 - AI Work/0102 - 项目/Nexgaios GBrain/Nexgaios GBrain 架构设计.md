---
title: 'Nexgaios GBrain 架构设计'
status: raw
created: '2026-06-17 20:31'
source_type: unknown
material_type: 方案
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'GBrain'
  - 'Garry-Tan'
  - 'Agent'
  - 'Skill'
  - 'MCP'
  - 'GitHub'
  - 'Knowledge-Base'
  - 'AWS'
---

# Nexgaios GBrain 架构设计

日期：2026-06-17

页面类型：项目架构设计 / 交接文档

项目状态：MVP 已可用，但尚未达到成熟商业 SaaS 最终形态

负责人：Terry

## 1. 这份文档是什么

这份文档用于记录 Nexgaios GBrain 当前项目的完整资产清单、系统架构、各级职能、设计原因、当前完成度、后续使用方式，以及 Terry 在公司电脑和家里电脑之间如何继续推进。

GBrain 在当前项目里的定位不是普通文档仓库，而是 Nexgaios 的企业第二大脑。它要解决的问题是：Codex、Claude、Cursor 等 Agent 默认不了解公司的业务、流程、知识、决策和上下文，导致 AI 很难真正进入企业工作流。GBrain 通过 MCP 把企业知识暴露给 Agent，使 Agent 在写代码、做产品方案、处理 Amazon 业务、生成 SOP、沉淀知识时，能先读取公司长期记忆，再给出更贴近 Nexgaios 的输出。

## 2. 当前完整资产清单

### 2.1 GBrain 源码仓库

本地路径：

```text
D:\nexgaios-gbrain-code
```

GitHub：

```text
https://github.com/terryxming/nexgaios-gbrain-code
```

仓库类型：Private

默认分支：

```text
nexgaios-saas
```

当前用途：

1. 保存 Nexgaios 改造后的 GBrain 源码。
2. 保存 SaaS 权限系统、权限后台、MCP 鉴权、成员/角色/分组/策略、中文后台、同步脚本等代码。
3. 作为后续继续开发 GBrain 产品化能力的主源码仓库。

当前状态：

1. 已从原工作区迁移到 `D:\nexgaios-gbrain-code`。
2. 已提交本地改造。
3. 已推送到 GitHub 私有仓库。
4. 本地 `origin` 指向 Nexgaios 私有源码仓库。
5. 本地 `upstream` 指向 Garry Tan 原始 GBrain 仓库。

Remote 设计：

```text
origin   = https://github.com/terryxming/nexgaios-gbrain-code.git
upstream = https://github.com/garrytan/gbrain.git
```

为什么这么设计：

1. `origin` 保存 Nexgaios 自己的商业化改造版本，避免直接污染上游开源项目。
2. `upstream` 保留 Garry Tan 原始 GBrain 项目的更新来源，后续可以选择性同步官方新功能。
3. 默认分支使用 `nexgaios-saas`，避免把 Nexgaios 的 SaaS 权限改造和上游 `master` 混在一起。

### 2.2 上游 GBrain 原始仓库

GitHub：

```text
https://github.com/garrytan/gbrain
```

当前用途：

1. 作为原始 GBrain 开源项目来源。
2. 用于后续对比、合并、学习上游实现。
3. 不直接作为 Nexgaios 的生产源码仓库。

### 2.3 Nexgaios 企业知识库仓库

本地路径：

```text
E:\nexgaios-gbrain-kbase
```

GitHub：

```text
https://github.com/terryxming/nexgaios-gbrain-kbase
```

仓库类型：Private

默认分支：

```text
main
```

当前用途：

1. 保存 Nexgaios 企业知识内容。
2. 作为 Obsidian Markdown 知识库。
3. 作为 GBrain 的长期知识来源。
4. 作为 Codex、Claude、Cursor 等 Agent 的企业上下文来源。

当前目录结构：

```text
00 - inbox/       临时收件箱，放未归档的新资料、草稿和待整理内容。
01 - AI Work/     AI 工作流、Agent、Skill、GBrain、MCP、工程化和第二大脑相关内容。
02 - Amazon/      Amazon 业务、运营、Listing、广告、竞品、库存、售后和平台规则。
03 - 财务/        财务、投资、成本、利润、预算和经营分析。
04 - 产品/        产品方法论、需求、PRD、用户场景、路线图和产品决策。
05 - 设计/        UI、UX、设计系统、组件规范和设计工程。
06 - 知识管理/    知识库方法论、内容沉淀、知识治理和模板。
```

为什么这么设计：

1. 采用一个公司级知识库，而不是按 `aiwork`、`amazon`、`product` 拆成多个孤立 source。
2. 保留 Obsidian 友好的领域目录，方便 Terry 和团队在本地直接维护 Markdown。
3. 让 Agent 以公司整体上下文理解知识，而不是在多个 source 之间丢失关联。
4. 保留 `00 - inbox`，允许快速收集资料，再逐步整理到正式目录。

### 2.4 Agent Playbooks

本地位置：

```text
E:\nexgaios-gbrain-kbase\01 - AI Work\0114 - Agent Playbooks
```

当前已有 5 个核心工作流：

1. `codex-coding-workflow.md`：Codex 写代码工作流。
2. `product-planning-workflow.md`：产品方案工作流。
3. `amazon-business-workflow.md`：Amazon 业务工作流。
4. `sop-generation-workflow.md`：SOP 生成工作流。
5. `knowledge-capture-workflow.md`：内容沉淀工作流。

当前用途：

1. 规定 Codex 在不同工作场景下应该先检索哪些 GBrain 内容。
2. 规定输出结构、风险边界和写回规则。
3. 让 GBrain 不只是“存资料”，而是变成 Agent 的工作规则层。

为什么这么设计：

1. 先定义 Agent 怎么工作，再填充企业内容，可以避免知识库变成无结构文件堆。
2. 写代码、产品方案、Amazon、SOP、内容沉淀是 Terry 当前最核心的五个高频场景。
3. Playbook 是第二大脑的操作系统，企业知识是第二大脑的记忆内容。

### 2.5 AWS EC2 线上运行环境

实例区域：

```text
us-west-2
```

实例 ID：

```text
i-0b46eedd256219b7
```

公网 IP：

```text
34.213.22.21
```

当前用途：

1. 运行 GBrain 线上服务。
2. 对外提供 MCP 接口。
3. 对外提供权限管理后台。
4. 承载当前 Nexgaios GBrain SaaS MVP。

### 2.6 GBrain MCP 服务

线上地址：

```text
https://gbrain.nexgaios.com/mcp
```

当前用途：

1. 提供 Codex、Claude、Cursor 等 Agent 的接入入口。
2. 通过 MCP 工具读写 GBrain。
3. 用 Bearer Token 做访问控制。

常用工具：

1. `search`：搜索知识库。
2. `query`：问答式查询知识库。
3. `get_page`：读取指定页面。
4. `put_page`：写入或更新页面。
5. `list_pages`：列出页面。
6. `delete_page`：删除页面。
7. `get_tags`：读取标签。
8. `get_links`：读取页面链接。
9. `get_health`：检查服务健康状态。

为什么这么设计：

1. MCP 是 Agent 使用外部工具和知识库的标准接口。
2. URL + Bearer Token 的流式 HTTP 接入方式适合 Codex Desktop、Claude、Cursor 等多客户端接入。
3. 权限可以在服务端统一控制，不依赖某一台电脑本地文件。

### 2.7 权限管理后台

后台地址：

```text
https://gbrain.nexgaios.com/admin/
```

当前用途：

1. 管理成员。
2. 管理 MCP Token。
3. 查看角色、分组、策略。
4. 查看请求日志。
5. 查看权限拒绝和安全告警。
6. 执行权限系统 MVP 的日常管理。

已实现能力：

1. 中文后台。
2. 深色 / 浅色模式。
3. 账号密码登录。
4. Terry 最高权限。
5. 成员列表。
6. MCP Token 统计。
7. 角色 / 分组 / 策略展示。
8. 请求日志。
9. 权限拒绝记录。
10. 密码修改基础能力。

当前边界：

1. 它是 SaaS 权限系统 MVP，不是最终成熟商业 SaaS 版本。
2. 还需要补齐邀请流程、设备级 Token 管理、MFA、密码找回、完整审计告警、备份恢复、监控和 CI/CD。

### 2.8 权限系统

核心对象：

1. 成员：使用 GBrain 的人或 Agent 使用者。
2. Token：某个成员或设备访问 MCP 的凭证。
3. 角色：定义用户可以做什么。
4. 分组：定义用户属于哪个团队或权限集合。
5. 策略：定义对哪些资源可以读、写、管理。
6. 请求日志：记录实际访问行为。
7. 权限拒绝记录：记录被拒绝的访问请求。

当前权限原则：

1. Terry 是最高权限 owner / admin。
2. 普通成员通过后台创建。
3. 成员通过 MCP URL + Bearer Token 接入。
4. Token 不应写入知识库正文。
5. 权限判断在服务端执行，而不是靠本地约定。

为什么这么设计：

1. 企业知识库必须区分“谁能看、谁能写、谁能管理”。
2. Agent 接入企业知识库后，如果没有权限边界，会带来严重安全风险。
3. 使用成员、角色、分组、策略可以从个人工具逐步演化为商业 SaaS 权限系统。

### 2.9 Terry 当前电脑的 MCP 配置

当前这台电脑已经设置用户级环境变量：

```text
GBRAIN_REMOTE_TOKEN
```

Codex Desktop 自定义 MCP 配置：

```text
名称：gbrain
类型：流式 HTTP
URL：https://gbrain.nexgaios.com/mcp
Bearer 令牌环境变量：GBRAIN_REMOTE_TOKEN
```

说明：

1. 环境变量是用户级永久变量。
2. 关机、重启、关闭 Codex 后通常不需要重新配置。
3. 如果换电脑，需要在新电脑上重新配置 token 或使用后台生成新 token。

### 2.10 文档与报告

已有报告：

```text
C:\Users\EDY\Documents\Codex\2026-06-06\garrytan-gbrain-https-github-com-garrytan\outputs\report.html
```

用途：GBrain 开源项目逆向分析报告。

```text
C:\Users\EDY\Documents\Codex\2026-06-06\garrytan-gbrain-https-github-com-garrytan\outputs\gbrain_permission_model.html
```

用途：权限模型说明报告。

已有交接文档：

```text
E:\nexgaios-gbrain-kbase\00 - inbox\nexgaios-gbrain-permission-system-handoff-2026-06-11.md
```

用途：权限系统阶段性交接。

### 2.11 已清理的旧内容

旧改造工作区已删除：

```text
C:\Users\EDY\Documents\Codex\2026-06-06\garrytan-gbrain-https-github-com-garrytan\work\gbrain
```

旧知识库路径已废弃：

```text
E:\terry-nexgaios-gbrain
```

旧源码参考仓库：

```text
D:\Terry-GBrain
```

说明：

1. 旧目录内容已经清理。
2. `D:\Terry-GBrain` 曾剩余一个被 Windows 占用的空目录壳，如果还存在，里面没有有效内容。
3. 后续不要再使用旧路径。

## 3. 当前项目架构

### 3.1 总体架构

当前 Nexgaios GBrain 可以理解为四层架构：

```text
源码层
  D:\nexgaios-gbrain-code
  https://github.com/terryxming/nexgaios-gbrain-code

知识层
  E:\nexgaios-gbrain-kbase
  https://github.com/terryxming/nexgaios-gbrain-kbase

运行层
  AWS EC2
  https://gbrain.nexgaios.com/mcp
  https://gbrain.nexgaios.com/admin/

使用层
  Codex / Claude / Cursor / 浏览器后台 / Obsidian
```

数据流：

```text
Terry / 团队
  ↓ 写入、整理、提交
E:\nexgaios-gbrain-kbase
  ↓ GitHub 同步
GitHub 知识库远端
  ↓ GBrain 同步 / MCP 写入
AWS EC2 上的 GBrain 服务
  ↓ MCP 工具
Codex / Claude / Cursor
```

代码流：

```text
上游 garrytan/gbrain
  ↓ upstream 同步
D:\nexgaios-gbrain-code
  ↓ Nexgaios SaaS 改造
terryxming/nexgaios-gbrain-code
  ↓ 部署
AWS EC2 上的 GBrain 服务
```

### 3.2 源码层职能

源码层负责 GBrain 产品本身。

它包含：

1. MCP 服务。
2. HTTP transport。
3. 权限系统。
4. 后台管理界面。
5. 数据库 schema 和 migration。
6. Token 鉴权。
7. 同步脚本。
8. 测试。

它不负责：

1. 保存公司具体知识内容。
2. 保存 token 明文。
3. 充当日常笔记仓库。

### 3.3 知识层职能

知识层负责 Nexgaios 的长期知识资产。

它包含：

1. 公司上下文。
2. AI 工作流。
3. Agent Playbooks。
4. Amazon 业务资料。
5. 产品方法论和 PRD。
6. SOP。
7. 复盘。
8. 模板。
9. 决策记录。

它不负责：

1. 保存 GBrain 源码。
2. 保存密钥、token、密码。
3. 承载权限系统逻辑。

### 3.4 运行层职能

运行层负责把 GBrain 变成可访问服务。

它包含：

1. AWS EC2。
2. 线上 MCP endpoint。
3. 权限后台。
4. 运行时数据。
5. 服务端鉴权。
6. 服务端日志。

它不负责：

1. 直接作为 Markdown 编辑器。
2. 替代 GitHub 版本管理。
3. 替代 Obsidian 的人工知识整理。

### 3.5 使用层职能

使用层是 Terry 和团队实际接触 GBrain 的入口。

主要入口：

1. Codex：适合写代码、整理文档、写入 GBrain、执行同步和验证。
2. Claude / Cursor：适合通过 MCP 读取企业知识辅助工作。
3. Obsidian：适合 Terry 手动维护本地 Markdown 知识库。
4. 权限后台：适合管理成员、token、权限和日志。
5. GitHub：适合版本管理、远程同步和跨电脑继续工作。

## 4. 为什么采用当前架构

### 4.1 为什么源码仓库和知识仓库分开

原因：

1. 源码是系统能力，知识库是企业内容，两者生命周期不同。
2. 源码需要测试、构建、部署、版本分支和上游同步。
3. 知识库需要 Obsidian 编辑、Markdown 归档、内容审核和业务维护。
4. 混在一起会导致代码仓库越来越像笔记仓库，知识库也会被工程文件污染。

对 Terry 的价值：

1. 后续做产品化时，源码可以独立迭代。
2. 团队维护知识时，不需要理解 GBrain 源码。
3. Agent 可以清楚区分“系统怎么运行”和“公司知道什么”。

### 4.2 为什么知识库采用公司级单仓库

原因：

1. 企业知识天然是互相关联的，产品、Amazon、工程、SOP、决策不能完全割裂。
2. Agent 需要统一企业上下文，而不是只读某个部门小片段。
3. 单仓库更容易在 GitHub、Obsidian、移动硬盘之间同步。
4. 目录内再按领域拆分，兼顾整体性和可维护性。

对 Terry 的价值：

1. 可以把公司知识看成一个整体资产。
2. 不需要维护多个分散仓库。
3. 在家里、公司、移动硬盘之间更容易同步。
4. 后续团队接入时可以逐步按目录授权，而不是一开始就拆成多个系统。

### 4.3 为什么使用 MCP

原因：

1. MCP 是 Agent 调用外部工具和知识库的标准方式。
2. Codex、Claude、Cursor 都可以通过 URL + token 接入。
3. 权限可以在服务端统一控制。
4. 不需要每台电脑都复制完整知识库才能让 Agent 使用。

对 Terry 的价值：

1. Terry 在任何电脑上配置 MCP 后，都可以让 Agent 读取公司第二大脑。
2. 团队成员可以使用自己的 token 接入，不需要共享 Terry 的 token。
3. 后续商业化时，可以把 GBrain 变成标准 SaaS 接入能力。

### 4.4 为什么做权限后台

原因：

1. 企业知识库不是个人笔记，必须有成员、角色、策略和审计。
2. URL + token 虽然方便，但没有后台就难以管理 token 生命周期。
3. 团队小范围接入后，需要知道谁访问了什么、谁被拒绝、哪些 token 有风险。

对 Terry 的价值：

1. Terry 可以作为 CEO 拥有最高权限。
2. 可以给不同成员发不同权限的 token。
3. 可以逐步把个人知识系统升级为公司级 SaaS 能力。

### 4.5 为什么保留 upstream

原因：

1. GBrain 原项目仍可能更新。
2. Nexgaios 改造版需要保留与上游合并的能力。
3. 私有仓库保存商业化改造，上游仓库保存开源主线。

对 Terry 的价值：

1. 不会被锁死在某个旧版本。
2. 可以继续吸收 Garry Tan GBrain 的新功能。
3. 同时保留 Nexgaios 自己的商业化路线。

## 5. 当前已完成的部分

### 5.1 已完成

1. GBrain 开源项目逆向分析。
2. 权限系统 SaaS 化方案设计。
3. 权限后台 MVP。
4. 中文后台和深浅色模式。
5. 账号密码登录。
6. Terry 最高权限。
7. 成员、Token、角色、分组、策略的基础展示。
8. 请求日志和权限拒绝记录。
9. MCP URL + Bearer Token 接入。
10. Terry 当前电脑 Codex MCP 接入。
11. 公司级知识库本地目录。
12. 知识库 GitHub 私有远端。
13. 源码 GitHub 私有远端。
14. 5 个 Agent Playbooks。
15. 旧目录清理。
16. 源码和知识库命名统一。

### 5.2 当前仍未完成

1. 企业基础知识页还没有系统补齐。
2. `02 - Amazon`、`03 - 财务`、`05 - 设计` 等目录仍较空。
3. GitHub / Obsidian / GBrain 的自动同步闭环还没有产品化。
4. 权限后台仍是 MVP，不是成熟商业 SaaS。
5. 设备级 token 管理仍需完善。
6. 邀请流程、密码找回、MFA、完整审计告警仍需补。
7. 备份恢复和监控体系仍需补。
8. CI/CD 和正式部署流程仍需补。
9. 团队成员规模化接入流程仍需打磨。
10. 从本地 Markdown 到线上 GBrain 的标准同步 SOP 仍需固化。

## 6. Terry 之后如何应用

### 6.1 日常让 Codex 使用 GBrain

可以直接对 Codex 说：

```text
先查 GBrain，再回答这个问题：……
```

或者：

```text
把这次结论写入 GBrain，放到 nexgaios source，slug 用 xxx/yyy
```

常见任务：

1. 写代码前，先查 `Agent Playbooks` 和相关项目资料。
2. 做产品方案前，先查公司上下文、历史决策和产品方法论。
3. 做 Amazon 业务前，先查 Amazon 目录和业务规则。
4. 生成 SOP 前，先查已有 SOP、模板和相关流程。
5. 每次完成重要工作后，把结论写回知识库。

### 6.2 日常维护本地知识库

打开：

```text
E:\nexgaios-gbrain-kbase
```

推荐方式：

1. 用 Obsidian 打开这个目录。
2. 临时资料先放到 `00 - inbox`。
3. 长期知识整理到对应领域目录。
4. 不要把 token、密码、密钥写入 Markdown 正文。
5. 修改后让 Codex 帮忙检查、commit、push。

常用指令：

```text
帮我检查 E:\nexgaios-gbrain-kbase 的改动，commit 并 push。
```

### 6.3 日常维护源码

打开：

```text
D:\nexgaios-gbrain-code
```

默认分支：

```text
nexgaios-saas
```

常用场景：

1. 修改权限后台。
2. 修改 MCP 鉴权。
3. 修改同步脚本。
4. 修改数据库 schema。
5. 增加测试。
6. 合并上游 GBrain 更新。

注意：

1. 不要在旧路径继续开发。
2. 不要直接改 `master` 作为 Nexgaios 主分支。
3. 需要同步上游时，先 fetch `upstream`，再评估是否合并。

### 6.4 管理权限后台

打开：

```text
https://gbrain.nexgaios.com/admin/
```

用途：

1. 查看成员。
2. 查看 token。
3. 查看角色、分组、策略。
4. 查看请求日志。
5. 查看权限拒绝。
6. 管理团队小范围接入。

### 6.5 配置 Agent 接入

MCP 配置：

```text
名称：gbrain
类型：流式 HTTP
URL：https://gbrain.nexgaios.com/mcp
Bearer 令牌环境变量：GBRAIN_REMOTE_TOKEN
```

使用原则：

1. 每个人使用自己的 token。
2. 不要共享 Terry 的 token。
3. 不要把 token 写入 GitHub 或知识库正文。
4. 新电脑需要重新配置环境变量或从后台生成 token。

## 7. Terry 在家里办公如何继续

当前项目没有做完，所以家里办公时需要先把“源码、知识库、MCP token、后台登录”四件事接上。

### 7.1 家里电脑需要准备什么

家里电脑至少需要：

1. Git。
2. GitHub 登录权限。
3. Codex Desktop。
4. 可以访问 GitHub。
5. 可以访问 `https://gbrain.nexgaios.com`。
6. GBrain MCP token。
7. 如果要本地编辑知识库，建议安装 Obsidian。

### 7.2 家里电脑拉取知识库

推荐路径：

```text
E:\nexgaios-gbrain-kbase
```

如果家里电脑没有 E 盘，也可以放到其他固定路径，但需要告诉 Codex 新路径。

拉取：

```powershell
git clone https://github.com/terryxming/nexgaios-gbrain-kbase.git E:\nexgaios-gbrain-kbase
```

进入后检查：

```powershell
git -C E:\nexgaios-gbrain-kbase status --short --branch
```

### 7.3 家里电脑拉取源码仓库

推荐路径：

```text
D:\nexgaios-gbrain-code
```

拉取：

```powershell
git clone https://github.com/terryxming/nexgaios-gbrain-code.git D:\nexgaios-gbrain-code
git -C D:\nexgaios-gbrain-code checkout nexgaios-saas
```

设置 upstream：

```powershell
git -C D:\nexgaios-gbrain-code remote add upstream https://github.com/garrytan/gbrain.git
```

如果 upstream 已存在，则不用重复添加。

### 7.4 家里电脑配置 MCP token

如果家里电脑使用 Codex Desktop 自定义 MCP，建议设置用户级环境变量：

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_REMOTE_TOKEN", "这里填 Terry 的 token", "User")
```

然后重启 Codex Desktop。

Codex Desktop MCP 配置：

```text
名称：gbrain
类型：流式 HTTP
URL：https://gbrain.nexgaios.com/mcp
Bearer 令牌环境变量：GBRAIN_REMOTE_TOKEN
```

注意：

1. token 不要写到 Markdown。
2. token 不要提交到 Git。
3. 如果不确定 token，回到权限后台生成或让 Codex 在安全环境中协助生成。

### 7.5 家里继续工作的推荐顺序

回到家后，建议按这个顺序恢复：

1. 打开 Codex Desktop。
2. 确认 MCP `gbrain` 连接正常。
3. 拉取知识库最新内容：

```powershell
git -C E:\nexgaios-gbrain-kbase pull
```

4. 拉取源码最新内容：

```powershell
git -C D:\nexgaios-gbrain-code pull
```

5. 对 Codex 说：

```text
请读取 E:\nexgaios-gbrain-kbase\01 - AI Work\0102 - 项目\Nexgaios GBrain\Nexgaios GBrain 架构设计.md，继续这个项目。
```

6. 如果要继续内容层，就从企业基础页开始补：

```text
company/context
company/strategy
company/terry-principles
projects/current
amazon/business-overview
```

7. 如果要继续产品化，就从权限后台和同步闭环开始补。

### 7.6 家里办公时如何判断用哪个仓库

如果是改系统功能：

```text
D:\nexgaios-gbrain-code
```

如果是写公司知识：

```text
E:\nexgaios-gbrain-kbase
```

如果是查线上服务：

```text
https://gbrain.nexgaios.com/mcp
https://gbrain.nexgaios.com/admin/
```

如果是部署或查服务器：

```text
AWS EC2
```

### 7.7 家里办公时最容易出错的地方

1. 忘记 pull，导致公司电脑和家里电脑内容冲突。
2. 把 token 写进知识库。
3. 在旧路径继续工作。
4. 把源码和知识库混在一起。
5. 忘记切换到 `nexgaios-saas` 分支。
6. 修改完本地 Markdown 但没有 commit / push。
7. 修改完源码但没有推送到 GitHub。

建议每次开始工作先对 Codex 说：

```text
先检查 D:\nexgaios-gbrain-code 和 E:\nexgaios-gbrain-kbase 的 git 状态，再继续。
```

## 8. 后续优先级

### 8.1 第一优先级：补企业基础知识页

需要补：

1. `company/context`
2. `company/strategy`
3. `company/terry-principles`
4. `projects/current`
5. `aiwork/gbrain/overview`

价值：

1. 让 Agent 知道 Nexgaios 是什么。
2. 让 Agent 知道 Terry 的判断原则。
3. 让产品方案、SOP、Amazon 业务不再空转。

### 8.2 第二优先级：建立内容同步 SOP

需要明确：

1. Obsidian 修改后怎么同步到 GitHub。
2. GitHub 内容怎么进入 GBrain。
3. GBrain 写入后怎么读回验证。
4. 冲突怎么处理。
5. 哪些内容进入 `00 - inbox`，哪些进入正式目录。

### 8.3 第三优先级：完善权限后台

需要补：

1. 设备级 token 管理。
2. 邀请成员流程。
3. 密码找回。
4. MFA。
5. 完整审计告警。
6. 更成熟的策略编辑器。
7. 更清晰的成员权限变更流程。

### 8.4 第四优先级：成熟 SaaS 产品化

需要补：

1. CI/CD。
2. 监控。
3. 备份恢复。
4. 部署 SOP。
5. 版本管理。
6. 计费或租户模型。
7. 客户级隔离。
8. 安全合规。

## 9. 当前结论

当前 Nexgaios GBrain 已经完成从“开源项目逆向分析”到“可用的企业第二大脑 MVP”的第一阶段。

已经具备：

1. 私有源码仓库。
2. 私有知识库仓库。
3. 线上 GBrain MCP。
4. 权限后台 MVP。
5. Terry 最高权限。
6. Codex MCP 接入。
7. Agent Playbook 规则层。

还没有完成：

1. 企业基础内容层。
2. 完整同步闭环。
3. 成熟商业 SaaS 权限系统。
4. 规模化团队接入。
5. 正式部署和运维体系。

下一阶段应该从“内容层”开始，而不是继续堆功能。最重要的是先让 GBrain 真正知道 Nexgaios 的公司背景、业务重点、Terry 的判断原则、当前项目和 Amazon 业务基础信息。
