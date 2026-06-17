# Terry NexGaios GBrain

这是 Terry / NexGaios 的公司级 Markdown 知识库，用于承载企业第二大脑内容，并通过 GBrain MCP 提供给 Codex、Claude、Cursor 等 Agent 使用。

## 当前定位

本仓库采用公司级单仓库结构：一个 Git 仓库保存 NexGaios 的长期知识资产，内部再按业务领域组织目录。

GBrain 侧推荐注册为一个公司级 source：

- source id：`nexgaios`
- MCP URL：`https://gbrain.nexgaios.com/mcp`

这样做的目标是让 Agent 在同一个企业上下文中检索公司文化、业务流程、产品方案、Amazon 业务、工程经验、SOP、模板和历史决策，而不是把知识切碎成多个互相隔离的来源。

## 目录结构

```text
00 - inbox/       临时收件箱，放还没有归档的新资料、草稿和待整理内容。
01 - AI Work/     AI 工作流、Agent、Skill、GBrain、MCP、工程化和第二大脑相关内容。
02 - Amazon/      Amazon 业务、运营、Listing、广告、竞品、库存、售后和平台规则。
03 - 财务/        财务、投资、成本、利润、预算和经营分析。
04 - 产品/        产品方法论、需求、PRD、用户场景、路线图和产品决策。
05 - 设计/        UI、UX、设计系统、组件规范和设计工程。
06 - 知识管理/    知识库方法论、内容沉淀、知识治理和模板。
```

## Agent Playbooks

Codex 的核心工作场景规则放在：

```text
01 - AI Work/0114 - Agent Playbooks/
```

当前第一批 playbook 包括：

1. 写代码工作流
2. 产品方案工作流
3. Amazon 业务工作流
4. SOP 生成工作流
5. 内容沉淀工作流

这些页面定义了 Codex 使用 GBrain 作为第二大脑时应该先检索什么、如何输出、什么时候询问 Terry、以及哪些内容必须写回知识库。

## 使用原则

1. `00 - inbox/` 只是暂存区，有长期价值的内容要归档到对应领域目录。
2. 重要事实、决策、流程和 SOP 应该写清楚来源、日期、状态和维护规则。
3. 涉及密码、token、密钥、Cookie 的内容不得写入正文，只能写存放原则和操作方式。
4. Agent 写入后必须读回验证，确认页面标题和关键章节存在。
5. 过期、冲突或低置信内容应标记出来，不要静默覆盖旧结论。

## 本地文件

以下内容属于本地运行状态或编辑器配置，不进入 Git：

- `.gbrain/`
- `.obsidian/`
- `.env*`
- `*token*`
- `*secret*`
- `*credential*`

## GitHub

远端仓库：

```text
https://github.com/terryxming/terry-nexgaios-gbrain
```
