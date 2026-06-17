# Nexgaios GBrain 本地运行踩坑记录

日期：2026-06-17

场景：家里电脑取消 EC2 后，本地运行 GBrain 应用层，并让 Codex 通过本地 MCP 访问 Supabase 中的 Nexgaios GBrain 知识库。

## 1. 用户级环境变量设置后，当前进程没反应

### 现象

在 PowerShell 里执行：

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_DATABASE_URL", "...", "User")
[Environment]::SetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "...", "User")
```

命令没有报错，但当前 Codex 或当前已经打开的 PowerShell 里仍然像“没设置成功”。

### 原因

`"User"` 表示写入 Windows 当前用户的永久环境变量。

它不是临时变量，但它只会被之后新启动的进程读取。已经打开的 Codex、PowerShell、终端窗口不会自动刷新这两个变量。

### 解法

在当前 PowerShell 里临时注入一次：

```powershell
$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
```

或者重启 Codex / 重新打开 PowerShell。

### 以后怎么避免

设置用户级环境变量后，默认要记住一句话：

```text
User 环境变量是永久的，但不是对已打开进程实时生效的。
```

## 2. Supabase 密码里的特殊字符没有 URL encode

### 现象

连接串看起来复制完整了，但 GBrain 连接数据库失败，或者连接串解析结果不符合预期。

### 原因

Postgres URL 里，密码部分如果含有 `#`、`@`、`/`、`?`、`&` 等特殊字符，需要 URL encode。

例如：

```text
# 需要写成 %23
```

如果不 encode，URL 解析器会把这些字符当成 URL 结构的一部分，而不是密码字符。

### 解法

在 Supabase 连接串中把密码里的特殊字符 URL encode 后再写入环境变量。

### 以后怎么避免

从 Supabase 复制连接串后，不要只看“字符串像不像”，还要确认密码部分是否已经 URL encode。

## 3. 全局没有 gbrain 命令

### 现象

直接运行：

```powershell
gbrain --help
```

找不到命令。

### 原因

当前家里电脑只是拉取了源码仓库，还没有把 GBrain CLI 安装成全局命令。

### 解法

在源码仓库里使用源码入口：

```powershell
cd D:\nexgaios-gbrain-code
bun run src/cli.ts --help
```

### 以后怎么避免

在没有全局安装之前，本地命令都使用：

```powershell
bun run src/cli.ts <command>
```

## 4. bun install 在 Windows 上 postinstall 失败

### 现象

执行：

```powershell
bun install
```

依赖安装过程中 postinstall 脚本失败。

### 原因

仓库里的某些 postinstall 脚本更偏 Unix shell 习惯，在 Windows PowerShell 环境下容易因为重定向或 shell 差异失败。

### 解法

先跳过脚本安装依赖：

```powershell
bun install --ignore-scripts
```

之后用源码入口验证 CLI：

```powershell
bun run src/cli.ts --help
```

## 5. MCP 能连上，但 list_pages / search 返回空

### 现象

本地 HTTP 服务可启动：

```text
http://127.0.0.1:3131/health
```

MCP `tools/list` 也能通，但 `list_pages` / `search` 返回空数组。

### 原因

Supabase 中实际知识页面的 `source_id` 是：

```text
nexgaios
```

而第一次创建的本地 legacy bearer token 没有指定 source，默认落在：

```text
default
```

HTTP MCP 会根据 token 权限决定可读 source。token 只允许读 `default`，自然查不到 `nexgaios` 下的页面。

这不是数据库没数据，也不是 MCP 不通，而是 source 权限上下文不对。

### 解法

创建本地 token 时指定 source：

```powershell
cd D:\nexgaios-gbrain-code

$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")

bun run src/cli.ts auth create terry-home-local-codex-nexgaios-20260617 --source nexgaios --takes-holders world
```

把生成的 token 保存到用户级环境变量：

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_LOCAL_TOKEN", "这里填刚生成的 token", "User")
```

### 以后怎么避免

Nexgaios GBrain 目前不是 `default` source，而是：

```text
source_id = nexgaios
```

凡是本地 HTTP MCP token，都要确认 token 的 source 权限是否指向 `nexgaios`。

## 6. 旧的 GBRAIN_REMOTE_TOKEN 不适合本地服务

### 现象

使用原来的：

```text
GBRAIN_REMOTE_TOKEN
```

访问本地：

```text
http://127.0.0.1:3131/mcp
```

返回：

```text
401 invalid_token
```

### 原因

`GBRAIN_REMOTE_TOKEN` 是原线上/远程 MCP 使用的 token。

本地 HTTP 服务读取的是当前 Supabase `access_tokens` 里存在且未撤销的 token。远程 token 不一定适用于这个本地服务，尤其在 source 权限、token 来源、服务实例不同的情况下。

### 解法

本地服务使用单独的本地 token：

```text
GBRAIN_LOCAL_TOKEN
```

并确保它是用 `--source nexgaios` 创建的。

## 7. 本地服务健康检查提示 database pool may be saturated

### 现象

访问：

```text
http://127.0.0.1:3131/health
```

返回类似：

```json
{
  "error": "service_unavailable",
  "error_description": "Health check timed out (database pool may be saturated)"
}
```

### 原因

之前有 CLI 查询或服务请求超时，可能让本地服务里的数据库连接处于卡住状态。

这不是连接串一定错了，而是当前本地服务进程可能已经不健康。

### 解法

只重启监听 3131 端口的 GBrain 服务：

```powershell
$pid = (Get-NetTCPConnection -LocalPort 3131 -State Listen).OwningProcess
Stop-Process -Id $pid -Force
```

然后重新启动：

```powershell
cd D:\nexgaios-gbrain-code

$env:GBRAIN_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DATABASE_URL", "User")
$env:GBRAIN_DIRECT_DATABASE_URL = [Environment]::GetEnvironmentVariable("GBRAIN_DIRECT_DATABASE_URL", "User")
$env:GBRAIN_SOURCE = "nexgaios"

bun run src/cli.ts serve --http --port 3131
```

## 8. PowerShell 调 bun.ps1 时容易把 stderr 提示当成错误

### 现象

启动服务时日志里出现：

```text
Prepared statements disabled (PgBouncer transaction-mode convention on port 6543)
```

PowerShell 把它包装成 `NativeCommandError`，看起来像启动失败。

### 原因

`bun` 在当前环境里可能解析到 npm shim：

```text
C:\Users\terry\AppData\Roaming\npm\bun.ps1
```

这个 PowerShell 包装脚本会把原程序的 stderr 提示包装得像异常。

但这条 prepared statements 信息本身不是致命错误，而是 GBrain 识别 Supabase transaction pooler 后的提示。

### 解法

如果需要更稳定地后台启动，可以直接调用真实的 bun 可执行文件：

```powershell
C:\Users\terry\AppData\Roaming\npm\node_modules\bun\bin\bun.exe
```

示例：

```powershell
& "C:\Users\terry\AppData\Roaming\npm\node_modules\bun\bin\bun.exe" run src/cli.ts serve --http --port 3131
```

## 9. MCP 返回的是 SSE 文本，不是 PowerShell 自动解析的 JSON 对象

### 现象

用 PowerShell `Invoke-RestMethod` 调 MCP：

```powershell
tools/list
```

看起来工具数是 0，或者 `result.content` 为空。

### 原因

本地 GBrain MCP 返回的是 SSE 文本流，形如：

```text
event: message
data: {"result":{...},"jsonrpc":"2.0","id":1}
```

PowerShell 不会自动把 `data:` 后面的 JSON 当成 JSON-RPC 对象解析。

### 解法

先读取原始响应文本，再解析 `data:` 行里的 JSON。

排障时不要只看 PowerShell 自动转换后的对象。

## 10. 查询能跑通，但 list_pages / search 比较慢

### 现象

本地 MCP 已经能返回结果，但：

```text
list_pages 大约 30 秒
search 大约 30 多秒
```

### 原因

当前 GBrain 应用层运行在本地电脑，数据库在 Supabase。

每次查询都要跨网络访问远程 Postgres，并且 GBrain 的 search/list 可能触发较复杂的 source 过滤、排序、搜索或向量相关逻辑。

### 当前结论

这是性能优化问题，不是链路不通。

已验证本地 MCP 能读到：

```text
Pages:     94
Chunks:    2061
Embedded:  1362
Tags:      130
```

已验证：

```text
list_pages 可以返回 Nexgaios GBrain 架构设计等页面
search "Nexgaios GBrain" 可以返回架构设计、SaaS 权限方案、README 等内容
```

## 11. 当前可用启动形态

本地服务地址：

```text
http://127.0.0.1:3131/mcp
```

本地健康检查：

```text
http://127.0.0.1:3131/health
```

Agent 接入方式：

```text
Codex / 其他 Agent
  ↓ MCP HTTP
本机 GBrain 应用层 127.0.0.1:3131
  ↓
Supabase GBrain DB
```

当前最重要的配置点：

```text
GBRAIN_DATABASE_URL
GBRAIN_DIRECT_DATABASE_URL
GBRAIN_LOCAL_TOKEN
GBRAIN_SOURCE=nexgaios
```
