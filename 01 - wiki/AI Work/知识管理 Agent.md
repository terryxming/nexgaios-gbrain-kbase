---
title: 知识管理 Agent
status: active
wiki_page_type: 案例页
created: 2026-06-20 23:27
updated: 2026-06-20 23:35
source_refs:
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 61–68 章：真实项目实战.md"
  - "00 - raw/01 - AI Work/0101 - 学习/0101 - Agent/Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统.md"
risk_level: 中
tags:
  - Agent
  - 知识管理
  - LLMWiki
  - 案例
promoted_at: 2026-06-20 23:35
promotion_basis: 用户确认
---

# 知识管理 Agent

## 当前结论

1. 知识管理 Agent 的目标不是总结内容，而是把对话、资料、经验和方法论转化成可检索、可复用、可维护的知识资产。
2. 知识管理 Agent 必须区分 raw、wiki、schema、inbox、编译和路由，不应把原始材料直接当成稳定知识。
3. 该 Agent 的核心输出不是“摘要”，而是 Markdown 知识文件、分类建议、关联链接、待处理项和可追溯证据。
4. 知识管理 Agent 适合先做 Copilot 或 Workflow Agent，自动写入 active wiki 需要用户确认。
5. 运行后应沉淀成模板、规则、Skill、Eval 样本和项目记忆。

## 适用范围

### 适用

- 将 ChatGPT/Codex 对话沉淀成知识库材料。
- 将课程、网页剪藏、项目过程整理成 raw 或 candidate wiki。
- 维护 Obsidian / llm-wiki / GBrain 知识网络。
- 生成待处理索引、编译日志和知识链接建议。

### 不适用

- 不自动把未经确认的 candidate 晋升为 active。
- 不替代用户对关键概念、规则、商业判断的确认。
- 不负责清空或重写系统数据库。

## 案例字段

| 字段 | 内容 |
| --- | --- |
| Goal | 将输入内容转化为可长期沉淀的知识资产。 |
| Input | 对话、网页、课程、PDF、图片、项目记录。 |
| Context | 当前知识库目录、frontmatter 规则、wiki 编译规则、已有 active 页面。 |
| Tools | 文件读写、Markdown 校验、Excel 审核表、Obsidian 剪藏、Git。 |
| Output | raw 文件、candidate wiki、分类建议、待处理索引、编译日志。 |
| Quality | 去除闲聊，保留证据，结构清晰，链接真实，状态正确。 |
| Risk | 编造知识、误分发、覆盖 active、错误晋升、链接污染。 |
| Asset | inbox 路由 Skill、wiki 编译规则、模板、Eval 样本。 |

## 依据来源

| raw 来源 | 支撑内容 |
| --- | --- |
| [[Agent 工程化与产品化｜第 61–68 章：真实项目实战]] | 知识管理 Agent 的目标、场景、最小设计、输出类型和目录归档策略。 |
| [[Agent 工程化与产品化｜第 69–76 章：方法论沉淀与个人 Agent 系统]] | 个人 Agent 工作台、llm-wiki、Skill 化和 Eval 集沉淀。 |

## 相关链接

- 上位案例：[[Agent 真实项目案例库]]
- 前置流程：[[产品级 Agent 设计方法论]]
- 前置模板：[[Agent Design Canvas]]
- 相关知识：[[Agent Test 与 Eval]]
- 相关知识：[[Agent Trace 与可观测性]]
