---
title: 'Nexgaios GBrain 无 EC2 运行方案'
status: raw
created: '2026-06-17 23:58'
source_type: unknown
material_type: 方案
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'GBrain'
  - 'Agent'
  - 'MCP'
  - 'GitHub'
  - 'Knowledge-Base'
  - 'Supabase'
  - 'AWS'
---

# Nexgaios GBrain 无 EC2 运行方案

日期：2026-06-17

相关项目：Nexgaios GBrain

## 1. 背景问题

Terry 的核心问题是：

```text
如果取消 EC2，这套 GBrain 系统怎样继续转起来？
```

进一步的问题包括：

1. 是否必须要线上服务器？
2. Supabase 已经是远程数据库，是否还需要两台电脑各自维护索引？
3. 两台电脑如何运行 GBrain 应用层？
4. Supabase 是否有 MCP？
5. Agent 能不能直接通过 MCP 访问 Supabase？
6. 家里电脑现在是否已经能跑 GBrain 应用层？

核心结论：

```text
如果数据库是 Supabase，取消 EC2 后，不需要两台电脑各自维护索引。
但仍然需要某个地方运行 GBrain 应用层。
这个地方可以从 EC2 改成办公室电脑和家里电脑本地运行。
```

## 2. 有 EC2 时的架构

当前线上模式是：

```text
办公室电脑 / 家里电脑 / Agent
  ↓
https://gbrain.nexgaios.com/mcp
  ↓
EC2 上的 GBrain 应用层
  ↓
Supabase GBrain DB
```

EC2 负责：

1. 对外提供统一 MCP URL。
2. 运行 GBrain HTTP 服务。
3. 提供权限后台。
4. 处理 Bearer Token / OAuth / 权限判断。
5. 记录请求日志。
6. 连接 Supabase 数据库。
7. 作为 24 小时在线的服务入口。

Supabase 负责：

1. 保存 pages。
2. 保存 chunks。
3. 保存 embeddings。
4. 保存 links / tags / metadata。
5. 保存权限相关表。
6. 保存请求日志和运行数据。

## 3. 取消 EC2 后的架构

取消 EC2 后，架构变成：

```text
办公室电脑
  ↓ 本地运行 GBrain 应用层
  ↓
Supabase GBrain DB

家里电脑
  ↓ 本地运行 GBrain 应用层
  ↓
同一个 Supabase GBrain DB
```

也就是说：

```text
取消的是 EC2 这个 24 小时在线的 GBrain 服务入口。
保留的是 Supabase 中央数据库、GitHub 知识库、本地知识库、本地 GBrain 程序。
```

因为两台电脑连接的是同一个 Supabase，所以：

```text
不需要两台电脑各自维护一份索引。
pages / chunks / embeddings 都在同一个 Supabase 数据库里。
```

## 4. 无 EC2 后保留什么

无 EC2 方案仍然保留：

```text
本地源码仓库：
D:\nexgaios-gbrain-code

GitHub 源码仓库：
https://github.com/terryxming/nexgaios-gbrain-code

本地知识库：
E:\nexgaios-gbrain-kbase

GitHub 知识库：
https://github.com/terryxming/nexgaios-gbrain-kbase

Supabase GBrain DB：
中心数据库和索引

本地 GBrain 应用层：
办公室电脑 / 家里电脑分别运行
```

无 EC2 后移除或暂停：

```text
https://gbrain.nexgaios.com/mcp
https://gbrain.nexgaios.com/admin/
EC2 上常驻的 GBrain serve --http
```

## 5. 为什么仍然需要 GBrain 应用层

Supabase 是数据库，不是 GBrain 应用层。

GBrain 应用层负责：

1. MCP 工具协议。
2. `search` / `query` / `get_page` / `put_page` 等语义工具。
3. 权限判断。
4. source 隔离。
5. compiled_truth / timeline 的读取规则。
6. 混合搜索和向量搜索。
7. 请求日志。
8. 写入规则。
9. 后台管理 API。

如果没有 GBrain 应用层，Agent 只能直接面对数据库表。

这就像：

```text
Supabase = 图书馆数据库后台
GBrain 应用层 = 图书馆前台和业务系统
MCP = 服务窗口
Agent = 来窗口提问的人
```

日常使用应该让 Agent 通过 GBrain MCP 使用知识，而不是直接查 Supabase 表。

## 6. Supabase MCP 和 GBrain MCP 的区别

Supabase 有官方 MCP。

但 Supabase MCP 的定位是数据库和项目管理工具，通常用于：

1. 查看表。
2. 执行 SQL。
3. 查看日志。
4. 管理 migration。
5. 辅助开发和调试。

GBrain MCP 的定位是企业第二大脑工具，提供：

1. `search`
2. `query`
3. `get_page`
4. `put_page`
5. `list_pages`
6. `get_tags`
7. `get_links`
8. `delete_page`
9. `get_health`

区别是：

```text
Supabase MCP = 数据库维修入口
GBrain MCP = 企业第二大脑使用入口
```

Agent 技术上可以通过 Supabase MCP 直接访问 Supabase。

但那是数据库级访问，不是 GBrain 级访问。

它会绕过：

1. GBrain 的权限逻辑。
2. GBrain 的 source 隔离。
3. GBrain 的 search/query 语义。
4. GBrain 的请求日志和安全告警。
5. GBrain 对 compiled_truth / timeline / chunks 的理解。

因此日常架构应保持：

```text
Agent
  ↓ GBrain MCP
GBrain 应用层
  ↓
Supabase GBrain DB
```

而不是：

```text
Agent
  ↓ Supabase MCP
Supabase DB
```

## 7. 两台电脑如何运行 GBrain 应用层

两台电脑都需要具备：

1. GBrain 源码或已安装的 GBrain CLI。
2. Bun 运行时。
3. 项目依赖。
4. Supabase 数据库连接环境变量。
5. 本地 MCP 配置。

本地 HTTP 方式：

```powershell
cd D:\nexgaios-gbrain-code

$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
$env:GBRAIN_SOURCE = "nexgaios"

bun run src/cli.ts serve --http --port 3131
```

本地 MCP 地址：

```text
http://127.0.0.1:3131/mcp
```

本地 stdio 方式：

```powershell
cd D:\nexgaios-gbrain-code

$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
$env:GBRAIN_SOURCE = "nexgaios"

bun run src/cli.ts serve
```

stdio 方式适合只给本机 Agent 使用。

HTTP 方式适合本机多个工具连接同一个本地 MCP endpoint。

## 8. Supabase 连接串

本地 GBrain 应用层需要两个环境变量：

```text
GBRAIN_DATABASE_URL
GBRAIN_DIRECT_DATABASE_URL
```

通常对应：

```text
GBRAIN_DATABASE_URL        = Supabase Transaction pooler，端口 6543
GBRAIN_DIRECT_DATABASE_URL = Supabase Session pooler，端口 5432
```

设置方式：

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_DATABASE_URL", "这里填 Transaction pooler 连接串", "User")
[Environment]::SetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "这里填 Session pooler 连接串", "User")
```

注意：

1. 不要把连接串写进 Markdown。
2. 不要提交到 Git。
3. 不要发到聊天记录。
4. 如果密码里有 `#`、`@`、`/`、`?`、`&` 等特殊字符，需要 URL encode。
5. 设置用户级环境变量后，已有终端进程不会自动看到，需要重新打开终端或重启 Codex。

### 8.1 `GBRAIN_DATABASE_URL` 是什么

`GBRAIN_DATABASE_URL` 是 GBrain 日常运行主要使用的数据库连接串。

当前建议指向 Supabase Transaction pooler：

```text
端口：6543
用途：本地 GBrain 应用层日常读写 Supabase
```

它适合：

1. 本地 HTTP MCP 服务。
2. `search` / `query` / `list_pages` / `get_page` 等常规读操作。
3. `put_page` / `sync` 等常规写操作。
4. 多个短连接或频繁请求的应用层访问。

生活化理解：

```text
GBRAIN_DATABASE_URL 像图书馆前台的日常窗口。
大多数人来借书、还书、查书，都走这个窗口。
```

因为 Supabase Transaction pooler 通常使用 PgBouncer transaction mode，GBrain 会自动关闭 prepared statements。这类提示一般不是错误：

```text
Prepared statements disabled (PgBouncer transaction-mode convention on port 6543)
```

### 8.2 `GBRAIN_DIRECT_DATABASE_URL` 是什么

`GBRAIN_DIRECT_DATABASE_URL` 是更接近直连数据库会话的连接串。

当前建议指向 Supabase Session pooler：

```text
端口：5432
用途：需要更稳定会话语义的数据库操作
```

它适合：

1. migration。
2. schema 检查。
3. 某些需要 session 级行为的维护命令。
4. 调试数据库连接问题。
5. GBrain 内部在需要 direct/session 连接时作为备用连接。

生活化理解：

```text
GBRAIN_DIRECT_DATABASE_URL 像图书馆后台办公室。
不是每次查书都进去，但遇到盘点、改规则、修系统时需要它。
```

### 8.3 为什么两个都要设置

两个连接串不是重复配置，而是服务不同场景：

```text
GBRAIN_DATABASE_URL        = 日常应用访问入口
GBRAIN_DIRECT_DATABASE_URL = 维护 / 迁移 / session 语义入口
```

如果只设置 `GBRAIN_DATABASE_URL`，很多日常查询可能能跑，但遇到迁移、维护、schema 检查或某些特殊命令时可能缺少 direct 连接。

如果只设置 `GBRAIN_DIRECT_DATABASE_URL`，GBrain 日常应用层不一定会按预期选择连接。

因此家里电脑和办公室电脑都建议同时设置这两个用户级环境变量。

### 8.4 用户级、进程级、系统级环境变量区别

设置方式里的 `"User"` 表示用户级环境变量：

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_DATABASE_URL", "...", "User")
```

三种常见层级：

```text
Process 进程级：
只在当前 PowerShell / 当前进程有效，窗口关闭后消失。

User 用户级：
当前 Windows 用户长期有效，重启电脑后仍然存在。
适合保存 Terry 个人使用的 GBrain 连接串和 token。

Machine / System 系统级：
整台电脑所有用户和系统服务可见，通常需要管理员权限。
适合系统服务，不建议随便放个人密钥。
```

注意：

```text
用户级环境变量是永久的，但已经打开的 Codex 或 PowerShell 不会自动刷新。
```

所以设置后通常需要：

1. 重启 Codex。
2. 重新打开 PowerShell。
3. 或在当前进程里手动读取 User 环境变量：

```powershell
$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
```

### 8.5 与 source 的关系

数据库连接串只解决“连到哪个数据库”。

它不解决“读哪个 GBrain source”。

当前 Nexgaios 知识库在 Supabase 里的 source 是：

```text
nexgaios
```

因此本地运行时还应该让 GBrain 知道当前 source：

```powershell
$env:GBRAIN_SOURCE = "nexgaios"
```

对于 HTTP MCP，最终读哪个 source 还会受到 token 权限影响。

所以本地 MCP token 也应该用 `--source nexgaios` 创建。

## 9. 家里电脑当前验证状态

2026-06-17，家里电脑已完成以下验证：

```text
D:\nexgaios-gbrain-code 源码存在
Bun 已安装
项目依赖已安装
GBrain CLI 可通过源码入口运行
Supabase 连接串已写入用户级环境变量
GBrain 可连接 Supabase
本地 HTTP GBrain 服务可启动
```

已验证数据库访问：

```text
Pages:     94
Chunks:    2061
Embedded:  1362
Tags:      130
```

已验证本地健康检查：

```json
{
  "status": "ok",
  "version": "0.42.26.0",
  "engine": "postgres"
}
```

当前本地服务地址：

```text
http://127.0.0.1:3131
http://127.0.0.1:3131/mcp
http://127.0.0.1:3131/health
```

## 10. 启动和停止命令

手动启动：

```powershell
cd D:\nexgaios-gbrain-code

$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
$env:GBRAIN_SOURCE = "nexgaios"

bun run src/cli.ts serve --http --port 3131
```

健康检查：

```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:3131/health"
```

停止服务：

```powershell
$pid = (Get-NetTCPConnection -LocalPort 3131 -State Listen).OwningProcess
Stop-Process -Id $pid -Force
```

注意：重启电脑后，本地服务不会自动恢复，除非后续做 Windows 启动项或任务计划程序。

## 11. 知识同步怎么做

无 EC2 方案下，知识同步仍然走 GitHub + Supabase。

Markdown 同步：

```powershell
git -C E:\nexgaios-gbrain-kbase pull
```

把 Markdown 同步进 Supabase GBrain DB：

```powershell
cd D:\nexgaios-gbrain-code

$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
$env:GBRAIN_SOURCE = "nexgaios"

bun run src/cli.ts sync --repo E:\nexgaios-gbrain-kbase
bun run src/cli.ts embed --stale
```

因为 Supabase 是中心数据库，所以任意一台电脑运行 sync/embed 后，另一台电脑连接同一个 Supabase 时也能查到更新后的索引。

## 12. 日常工作流

开始工作前：

```powershell
git -C E:\nexgaios-gbrain-kbase pull
git -C D:\nexgaios-gbrain-code pull
```

编辑知识后：

```powershell
git -C E:\nexgaios-gbrain-kbase status --short
git -C E:\nexgaios-gbrain-kbase add .
git -C E:\nexgaios-gbrain-kbase commit -m "更新 GBrain 知识"
git -C E:\nexgaios-gbrain-kbase push
```

同步到 GBrain DB：

```powershell
cd D:\nexgaios-gbrain-code
$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
$env:GBRAIN_SOURCE = "nexgaios"

bun run src/cli.ts sync --repo E:\nexgaios-gbrain-kbase
bun run src/cli.ts embed --stale
```

本机 Agent 使用：

```text
http://127.0.0.1:3131/mcp
```

## 13. 无 EC2 方案的优点

优点：

1. 不需要维护 EC2。
2. 不需要线上域名和反向代理。
3. 成本更低。
4. 适合只有 Terry 两台电脑使用的阶段。
5. Supabase 仍然保证数据库和索引中心化。
6. 本地调试 GBrain 更直接。

## 14. 无 EC2 方案的代价

代价：

1. 没有 24 小时在线的公网 MCP 地址。
2. 每台电脑都要配置 GBrain 运行环境。
3. 每台电脑都要配置 Supabase 连接串。
4. 数据库密钥暴露面从 EC2 扩大到两台电脑。
5. 权限后台不再是统一线上入口。
6. 手机、云端 Agent、外部成员无法随时访问，除非某台电脑开着服务。
7. 本地服务重启、端口占用、任务计划都要自己处理。
8. 如果未来团队成员接入，管理复杂度会上升。

## 15. 什么时候可以取消 EC2

适合取消 EC2 的情况：

```text
使用者只有 Terry。
只需要办公室电脑和家里电脑。
不需要公网统一 MCP 地址。
不需要团队成员随时访问。
不需要稳定的线上权限后台。
可以接受每台电脑本地运行 GBrain。
```

## 16. 什么时候应该保留或恢复 EC2

应该保留或恢复 EC2 的情况：

```text
需要团队成员接入。
需要统一 MCP URL。
需要 Claude / ChatGPT / 云端 Agent 随时访问。
需要权限后台稳定在线。
需要统一请求日志和安全审计。
需要把 GBrain 当 SaaS 产品继续推进。
需要自动定时同步、后台任务、监控和告警。
```

## 17. 最终结论

取消 EC2 后，这套系统仍然可以转起来。

关键不是“有没有服务器”，而是：

```text
GBrain 应用层必须运行在某个地方。
Supabase 负责中心数据库和索引。
本地电脑可以临时代替 EC2 运行应用层。
```

最终架构可以理解为：

```text
本地知识库 + GitHub 知识库 = 知识母本
Supabase = 中央 GBrain 数据库和索引
家里电脑 / 办公室电脑 = 本地 GBrain 应用层
MCP = Agent 访问入口
```

一句话总结：

```text
无 EC2 方案不是取消 GBrain 应用层，
而是把 GBrain 应用层从 EC2 搬到 Terry 的本地电脑运行。
```
