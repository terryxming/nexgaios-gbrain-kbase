---
title: 'Nexgaios GBrain 五层架构与运行机制说明'
status: raw
created: '2026-06-17 22:18'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'GBrain'
  - 'Agent'
  - 'MCP'
  - 'GitHub'
  - 'Knowledge-Base'
  - 'AWS'
  - 'Obsidian'
---

# Nexgaios GBrain 五层架构与运行机制说明

日期：2026-06-17

相关项目：Nexgaios GBrain

## 1. 背景问题

Terry 当前已经同时拥有：

1. 本地源码仓库。
2. GitHub 源码仓库。
3. 本地知识库。
4. GitHub 知识库仓库。
5. AWS EC2 线上服务器。
6. 权限后台。
7. MCP 服务。

直觉上的疑问是：

```text
为什么需要这么多东西？
这些东西是不是太复杂？
运行层和知识层到底怎么连起来？
Agent 到底是在访问 Markdown，还是访问 GBrain 数据库？
```

核心答案是：

```text
这些东西解决的是不同层级的问题。
Nexgaios GBrain 不是一个普通笔记文件夹，
而是一个可以被 Agent 使用、可以权限管理、可以部署上线、可以长期演化的企业第二大脑。
```

如果只是 Terry 自己记笔记，一个 Obsidian 文件夹就够了。

但如果目标是让 Codex、Claude、Cursor 等 Agent 能安全、稳定、可权限控制地使用公司长期知识，就需要把系统拆成不同层级。

## 2. 为什么需要这么多组件

可以把 GBrain 理解成一个企业级知识服务系统，而不是单纯的 Markdown 文件夹。

不同组件分别负责不同事情：

```text
源码仓库：GBrain 这个系统怎么运行
知识仓库：Nexgaios 知道什么
EC2：把系统跑到线上
权限后台：控制谁能访问什么
MCP：让 Agent 能标准化调用知识
```

也就是说，GBrain 同时有五个身份：

```text
它是一个软件产品，所以需要源码仓库。
它是一个企业知识库，所以需要知识仓库。
它要被远程访问，所以需要 EC2。
它涉及公司权限，所以需要权限后台。
它要服务 Agent，所以需要 MCP。
```

## 3. 生活化例子：公司图书馆

可以把 Nexgaios GBrain 想成一座企业图书馆。

1. 本地知识库像 Terry 手上的原始书稿和档案。
2. GitHub 知识库像公司总部的档案备份库。
3. GBrain 数据库像图书馆的检索系统。
4. MCP 像图书馆前台服务窗口。
5. 权限后台像门禁和管理员办公室。
6. EC2 像真正对外营业的图书馆大楼。
7. 源码仓库像这座图书馆的设计图纸、设备系统和施工方案。

Agent 不是自己冲进档案室乱翻文件。

Agent 是通过 MCP 这个服务窗口向 GBrain 提问：

```text
帮我搜索某个主题。
帮我读取某个页面。
帮我写入一条结论。
帮我基于公司知识回答问题。
```

GBrain 再根据权限，从数据库和索引里取出合适的知识返回给 Agent。

## 4. 五层架构

Nexgaios GBrain 当前可以理解为五层架构：

```text
1. 源码层
2. 知识层
3. 运行层
4. 权限层
5. 使用层
```

整体关系可以画成：

```text
使用层：Terry / Codex / Claude / Cursor / Obsidian
  ↓
权限层：成员、Token、角色、策略、日志
  ↓
运行层：AWS EC2 上的 GBrain 服务
  ↓
知识服务副本：GBrain 数据库 / 搜索索引
  ↑
知识层：Nexgaios Markdown 知识库 / GitHub 知识库
  ↑
源码层：GBrain 系统代码和产品能力
```

更准确地说，源码层不是每次查询都会被直接调用。

源码层是系统底座；运行层是源码部署后的在线服务；知识层是公司知识的母本；权限层控制访问边界；使用层是人和 Agent 的入口。

## 5. 源码层是干嘛的

对应资产：

```text
D:\nexgaios-gbrain-code
https://github.com/terryxming/nexgaios-gbrain-code
```

源码层负责 GBrain 这个系统本身怎么运行。

它包含：

1. MCP 服务。
2. HTTP transport。
3. 权限后台。
4. Token 鉴权。
5. 成员、角色、分组、策略。
6. 数据库 schema 和 migration。
7. 同步脚本。
8. 测试。

生活化例子：

```text
源码层像机器图纸和零件库。
它决定这台机器怎么造、怎么修、怎么升级。
```

## 6. 知识层是干嘛的

对应资产：

```text
E:\nexgaios-gbrain-kbase
https://github.com/terryxming/nexgaios-gbrain-kbase
```

知识层负责 Nexgaios 知道什么。

它包含：

1. 公司背景。
2. 项目文档。
3. Agent Playbooks。
4. Amazon 业务资料。
5. SOP。
6. 产品方案。
7. 决策记录。
8. 复盘和方法论。

生活化例子：

```text
知识层像公司档案室和图书馆。
它保存公司的经验、规则、判断和记忆。
```

这个层级的主形态是 Markdown，适合 Terry 和团队用 Obsidian 编辑、整理、归档和版本管理。

## 7. 运行层是干嘛的

对应资产：

```text
AWS EC2
https://gbrain.nexgaios.com
https://gbrain.nexgaios.com/mcp
https://gbrain.nexgaios.com/admin/
```

运行层本质上是把源码层部署到了线上。

但更准确地说，运行层包括：

1. 线上运行起来的 GBrain 程序。
2. GBrain 数据库。
3. 搜索索引。
4. Embeddings。
5. 环境变量。
6. 域名。
7. 后台服务。
8. MCP 服务。
9. 日志和运行时数据。

源码层是图纸，运行层是开机运转的机器。

生活化例子：

```text
源码层像图纸和零件。
运行层像真正开门营业的门店。
```

没有运行层，源码只是代码，知识库只是文件。

有了运行层，GBrain 才能被 Codex、Claude、Cursor 和团队成员通过统一 URL 访问。

## 8. 权限层是干嘛的

对应资产：

```text
权限后台
成员 / Token / 角色 / 分组 / 策略 / 日志
```

权限层负责控制：

1. 谁能访问。
2. 谁能读取。
3. 谁能写入。
4. 谁能管理。
5. 哪些请求被拒绝。
6. 哪些 Token 有风险。

企业第二大脑不能所有人共用一把万能钥匙。

权限层就是发钥匙、收钥匙、查记录、限制访问边界的系统。

生活化例子：

```text
权限层像门禁系统和保安室。
不是每个人都能进所有房间，也不是每个人都能搬走资料。
```

## 9. 使用层是干嘛的

对应入口：

```text
Codex
Claude
Cursor
Obsidian
浏览器后台
Terry / 团队成员
```

使用层是人和 Agent 真正接触 GBrain 的地方。

例如：

1. Terry 用 Obsidian 写知识。
2. Terry 用浏览器后台管理成员和 Token。
3. Codex 通过 MCP 查询和写入知识。
4. Claude / Cursor 通过 MCP 获取公司上下文。
5. 团队成员通过自己的 Token 接入。

生活化例子：

```text
使用层就是员工、AI 助手和办公入口。
大家不直接碰机器内部，而是通过合适的入口完成工作。
```

## 10. 运行层如何调取知识

一个关键点是：

```text
运行层不是直接读取 Terry 家里电脑的 E:\nexgaios-gbrain-kbase。
```

EC2 看不到 Terry 家里电脑的 E 盘。

运行层和知识层之间，需要通过同步链路打通。

当前可以这样理解：

```text
本地知识库
E:\nexgaios-gbrain-kbase
  ↓ commit / push
GitHub 知识库仓库
  ↓ EC2 拉取 / 同步
EC2 上的知识库副本
  ↓ gbrain sync + embed
GBrain 数据库 / 搜索索引
  ↓ MCP search / query / get_page
Codex / Claude / Cursor
```

也就是说，运行层调取知识时，实际读取的是：

```text
GBrain 数据库 / 搜索索引里已经同步过的知识
```

而不是直接读取本地 Markdown 文件。

## 11. sync 和 embed 是什么

GBrain 把 Markdown 知识变成 Agent 可查询知识，核心依赖两个动作：

```text
gbrain sync --repo <知识库路径>
gbrain embed --stale
```

其中：

```text
sync  = 把 Markdown 文件同步进 GBrain 数据库
embed = 给还没有向量化的内容补齐 embeddings
```

同步后的知识会从 Markdown 文件变成更适合机器检索的结构：

```text
Markdown 文件
  ↓
pages 页面
  ↓
chunks 分块
  ↓
embeddings 向量
  ↓
links / tags / metadata
  ↓
可搜索、可问答、可权限控制的数据
```

为什么需要这一步？

因为 Agent 查询需要的不只是打开文件。

它还需要：

1. 关键词搜索。
2. 语义搜索。
3. 混合排序。
4. 页面读取。
5. source 隔离。
6. 权限判断。
7. 请求日志。
8. 大文档分块。
9. embedding 向量索引。

这些能力不能只靠一个文件夹自然获得，需要运行层里的数据库和索引支撑。

## 12. GBrain 里的 brain 和 source

GBrain 源码里有两个重要概念：

```text
brain  = 一个数据库
source = 数据库里的一个内容来源 / 知识仓库
```

放到 Nexgaios 项目里，可以这样理解：

```text
brain  = 线上 GBrain 的数据库
source = Nexgaios 知识库这个内容源
```

一个 brain 里可以有多个 source。

例如未来可能有：

```text
source=nexgaios-kbase
source=amazon
source=product
source=engineering
source=customer-support
```

这样做的价值是：

1. 同一个数据库里可以管理多个内容来源。
2. 每个 source 可以有自己的权限边界。
3. Agent 查询时可以指定或限制知识来源。
4. 不同团队、业务、项目可以逐步隔离。

## 13. Agent 到底访问的是什么

可以明确回答：

```text
Agent 不是直接读你的 Markdown 知识库。
Agent 是通过 MCP 访问运行层里的 GBrain 服务。
GBrain 服务再从自己的数据库 / 索引里取知识。
```

更完整的链路是：

```text
E:\nexgaios-gbrain-kbase
本地 Markdown 知识库
  ↓ sync / import / embed
运行层 GBrain 数据库
pages / chunks / embeddings / links / tags
  ↓ MCP
Codex / Claude / Cursor
```

所以知识有两种形态：

```text
原始形态：Markdown 知识库
服务形态：GBrain 数据库 / 索引
```

## 14. Markdown 知识库和 GBrain 数据库的关系

不能简单说知识库只存在于 GBrain 数据库中。

更准确的说法是：

```text
Markdown 知识库 = 知识的源头和长期资产
GBrain 数据库 = 知识的线上检索副本 / 服务副本
```

Markdown 知识库适合：

1. 人类编辑。
2. Obsidian 维护。
3. Git 版本管理。
4. 长期沉淀。
5. 跨电脑同步。

GBrain 数据库适合：

1. Agent 快速搜索。
2. 语义查询。
3. 权限控制。
4. 请求记录。
5. MCP 标准化调用。
6. 线上服务。

生活化例子：

```text
Markdown 是原始书籍和档案。
GBrain 数据库是图书馆的检索系统。
MCP 是图书馆前台服务窗口。
Agent 是来窗口提问的人。
```

## 15. 读路径和写路径

GBrain 和知识库之间有两条重要路径。

读路径：

```text
知识库 Markdown
  ↓ GitHub
  ↓ EC2 同步
  ↓ sync / embed
  ↓ GBrain DB / index
  ↓ MCP 查询
  ↓ Agent 获取答案
```

写路径：

```text
Agent / Terry
  ↓ MCP put_page 或本地编辑 Markdown
  ↓ GBrain DB 或本地知识库
  ↓ 导出 / 同步 / commit / push
  ↓ GitHub 知识库
```

当前读路径相对清楚。

但写路径，也就是：

```text
MCP 写入 GBrain 后如何稳定回写 Markdown，
再如何 commit / push 回 GitHub 知识库
```

还需要继续产品化和固化 SOP。

这也是架构设计文档里提到“内容同步 SOP 仍需固化”的原因。

## 16. 最终总结

可以用一句话理解当前架构：

```text
源码层负责造机器。
知识层负责装记忆。
运行层负责让机器在线工作。
权限层负责管钥匙和边界。
使用层负责让人和 Agent 真正用起来。
```

再用一句话理解 Agent 访问知识的本质：

```text
Agent 本质上是通过 MCP 访问运行层的 GBrain 服务，
再由 GBrain 从数据库和索引中获取已经同步进去的知识。
```

最后要记住：

```text
Markdown 知识库是母本。
GBrain 数据库是服务副本。
MCP 是访问接口。
EC2 是线上运行环境。
权限后台是门禁系统。
Agent 是使用者。
```
