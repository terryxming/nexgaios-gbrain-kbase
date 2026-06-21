---
title: MCP Server 与 Client
status: active
wiki_page_type: 对象页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 18–24 章：工具、MCP 与外部系统集成.md"
risk_level: 中
tags:
  - Agent
  - MCP
  - Server
  - Client
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# MCP Server 与 Client

## 当前结论

1. MCP 是连接 Agent 与外部工具、资源、提示词的标准协议，不是 Agent 本身，也不替代 API。
2. MCP Server 负责暴露 tools、resources、prompts；MCP Client 或 Host 负责发现、连接、调用这些能力。
3. MCP 的价值是把工具接入从“每个 Agent 各写一套适配”变成统一协议接入。
4. MCP Server 暴露能力时，仍然必须遵守 Tool Schema、权限、确认、审计和错误处理规则。
5. Agent 通过 MCP 获得可用能力，但真正的工具执行仍由应用程序或外部系统完成。

## 适用范围

### 适用

- 设计 MCP Server 暴露哪些工具、资源和提示词。
- 判断某个外部系统是否需要通过 MCP 接入。
- 区分 MCP Server、Client、Host 和 Agent 的责任。
- 设计 GBrain、数据库、文件系统、业务 API 的 Agent 接入层。

### 不适用

- 不替代 MCP SDK 代码实现。
- 不替代工具权限和审计系统。
- 不说明某个具体 MCP Server 的部署方案。

## 分工

| 角色 | 职责 |
| --- | --- |
| MCP Server | 暴露 tools、resources、prompts，并处理实际外部系统访问。 |
| MCP Client | 连接 MCP Server，发现可用能力，向 Host 或 Agent 提供调用接口。 |
| Host | 承载 Agent 的应用环境，管理工具列表、上下文、权限和用户交互。 |
| Agent | 根据目标、上下文和工具描述判断是否调用 MCP 暴露的能力。 |
| 外部系统 | 文件、数据库、API、脚本、知识库或业务系统。 |

## 设计检查

| 检查项 | 合格标准 |
| --- | --- |
| 暴露范围 | 只暴露任务所需 tools、resources、prompts。 |
| 工具描述 | 每个 tool 都有明确 Tool Schema。 |
| 权限 | Server 侧限制可访问数据和可执行动作。 |
| 确认 | 写入、发送、删除、交易动作不能无确认执行。 |
| 审计 | 记录调用者、参数、结果、错误和时间。 |
| 错误 | 调用失败返回结构化错误，不让 Agent 猜测。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 18–24 章：工具、MCP 与外部系统集成]] | MCP 是工具、资源和提示词的标准连接层；MCP Server 暴露 tools/resources/prompts，MCP 不能替代权限、审计、确认和回滚设计。 |

## 相关链接

- 上位知识：[[Agent 工具、MCP 与权限治理]]
- 前置知识：[[Tool Schema 设计]]
- 相关政策：[[Agent 工具最小权限原则]]
- 后续知识：[[Agent Trace 与可观测性]]
