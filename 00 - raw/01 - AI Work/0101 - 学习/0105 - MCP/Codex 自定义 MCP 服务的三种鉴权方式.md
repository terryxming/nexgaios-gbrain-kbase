---
title: 'Codex 自定义 MCP 服务的三种鉴权方式'
status: raw
created: '2026-06-11 18:24'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'MCP'
---

# Codex 自定义 MCP 的三种鉴权方式

GBrain MCP 使用标准 Bearer Token 鉴权：

```http
Authorization: Bearer gbrain_xxxxx
```

MCP URL：

```text
https://gbrain.nexgaios.com/mcp
```

## 方式一：Bearer 令牌环境变量

正式团队长期使用时，推荐这种方式。

Codex 里填写：

```text
名称：
viewer-test

类型：
流式 HTTP

URL：
https://gbrain.nexgaios.com/mcp

Bearer 令牌环境变量：
GBRAIN_VIEWER_TEST_TOKEN
```

电脑环境变量里保存：

```text
GBRAIN_VIEWER_TEST_TOKEN=gbrain_xxxxx
```

这里填的是“环境变量名”，不是 Token 本身。

Codex 会自动转换成：

```http
Authorization: Bearer gbrain_xxxxx
```

适合场景：

- 正式团队成员长期使用
- 不希望 Token 明文出现在 Codex 配置界面
- 每台设备一个独立 Token，方便吊销和轮换

### Windows 设置用户级永久环境变量

推荐使用用户级环境变量。设置一次后，关机、重启电脑、重启 Codex 都会保留。

#### 方法一：PowerShell 设置

打开 PowerShell，执行：

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_VIEWER_TEST_TOKEN", "gbrain_xxxxx", "User")
```

把 `gbrain_xxxxx` 换成真实 Token。

验证是否设置成功：

```powershell
[Environment]::GetEnvironmentVariable("GBRAIN_VIEWER_TEST_TOKEN", "User")
```

设置完成后，需要完全退出并重启 Codex Desktop。

#### 修改 Token

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_VIEWER_TEST_TOKEN", "新的gbrain_token", "User")
```

#### 删除 Token

```powershell
[Environment]::SetEnvironmentVariable("GBRAIN_VIEWER_TEST_TOKEN", $null, "User")
```

#### 方法二：Windows 图形界面设置

1. Windows 搜索：`环境变量`
2. 打开：`编辑你的账户的环境变量`
3. 点击：`新建`
4. 变量名填写：

```text
GBRAIN_VIEWER_TEST_TOKEN
```

5. 变量值填写：

```text
gbrain_xxxxx
```

6. 点击确定保存
7. 完全退出并重启 Codex Desktop

---

## 方式二：标头

临时测试时，推荐这种方式。

Codex 里填写：

```text
名称：
viewer-test

类型：
流式 HTTP

URL：
https://gbrain.nexgaios.com/mcp

Bearer 令牌环境变量：
留空
```

在“标头”里新增：

```text
键：
Authorization

值：
Bearer gbrain_xxxxx
```

注意：`Bearer` 和 Token 中间必须有一个空格。

适合场景：

- 临时测试
- 快速验证 MCP 是否能连通
- 不想先配置系统环境变量

缺点：

- Token 会明文保存在 Codex MCP 配置中，安全性不如环境变量方式

---

## 方式三：来自环境变量的标头

这是更通用的 Header 环境变量方式。

Codex 里填写：

```text
名称：
viewer-test

类型：
流式 HTTP

URL：
https://gbrain.nexgaios.com/mcp
```

在“来自环境变量的标头”里新增：

```text
键：
Authorization

值：
GBRAIN_AUTH_HEADER
```

电脑环境变量里保存：

```text
GBRAIN_AUTH_HEADER=Bearer gbrain_xxxxx
```

含义：

- Header 的名字写在 Codex 里
- Header 的完整值从环境变量读取

适合场景：

- 服务不是标准 Bearer Token
- 需要自定义 Header，例如：
  - `X-API-Key`
  - `x-client-token`
  - `Authorization: Basic xxx`

GBrain 不优先推荐这种方式，因为 GBrain 使用标准 Bearer Token，方式一更简单，不容易漏写 `Bearer` 或空格。

---

## 推荐选择

| 场景 | 推荐方式 |
|---|---|
| 正式团队长期使用 | 方式一：Bearer 令牌环境变量 |
| 临时测试、快速验证 | 方式二：标头 |
| 非标准 Header 鉴权 | 方式三：来自环境变量的标头 |

---

## 最常见错误

错误写法：

```text
Bearer 令牌环境变量：
gbrain_xxxxx
```

原因：

这里不能填 Token 本身，应该填环境变量名。

正确写法：

```text
Bearer 令牌环境变量：
GBRAIN_VIEWER_TEST_TOKEN
```

然后在电脑环境变量中保存：

```text
GBRAIN_VIEWER_TEST_TOKEN=gbrain_xxxxx
```

---

## GBrain 推荐标准

正式使用时，每个成员、每台设备都应该使用独立 MCP Token。

例如：

```text
terry-company-codex
terry-home-codex
viewer-test-company-codex
editor-aiwork-codex
```

这样某台电脑丢失或某个客户端不用了，只需要吊销对应 Token，不影响同一成员的其他设备。
