---
title: 'Harness Engineering｜阶段五：Coding Agent Harness（第 27–34 章）'
status: raw
created: '2026-05-21 09:16'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Harness'
  - 'Skill'
  - 'GitHub'
---

# Harness Engineering｜阶段五：Coding Agent Harness（第 27–34 章）

阶段五聚焦 **Coding Agent Harness**：如何让 AI Coding Agent 不只是“帮你写代码”，而是进入一个可控、可审查、可测试、可回滚、可沉淀的软件工程工作流。

本阶段的核心判断：

> Coding Agent 的质量，不取决于它一次能写多少代码，而取决于它是否被放进正确的 Repo、Diff、PR、CI、Bugfix、Refactor、Documentation Harness 里。

---

## 阶段五总览

| 章 | 主题 | 核心问题 | 一句话理解 |
|---:|---|---|---|
| 27 | Coding Agent 的工作循环 | Coding Agent 应该按什么顺序工作 | read → plan → edit → test → diff → review → PR |
| 28 | Repo Harness | 仓库如何给 Agent 提供稳定规则 | 用 AGENTS.md、目录结构、约束文件约束 Agent |
| 29 | PR Harness | 如何让 Agent 产出可审查变更 | PR 是 Agent 交付的审查容器 |
| 30 | CI Harness | 如何用自动检查防止假完成 | lint / test / typecheck / build 是硬门禁 |
| 31 | Bugfix Harness | 如何让 Agent 修 bug 不靠猜 | 先复现，再修复，再验证，再回归 |
| 32 | Refactor Harness | 如何让 Agent 重构不破坏行为 | 重构必须有边界、安全网和行为保持 |
| 33 | Documentation Harness | 如何防止代码和文档漂移 | 文档也是代码变更的一部分 |
| 34 | Codex / Claude Code / Cursor 差异 | 如何选择和组合 Coding Agent 工具 | 工具不同，但 Harness 方法相同 |

---

# 第 27 章：Coding Agent 的工作循环

## 27.1 本章核心

> **Coding Agent 的标准工作循环不是“写代码”，而是：读上下文 → 计划 → 修改 → 验证 → 审查 → 交付。**

一个不受约束的 Coding Agent 容易这样工作：

```text
看到需求
→ 直接改代码
→ 自称完成
```

工程化 Coding Agent 应该这样工作：

```text
读取需求
→ 读取仓库上下文
→ 明确任务范围
→ 制定计划
→ 最小化修改
→ 运行测试
→ 查看 diff
→ 修复失败
→ 输出 PR / 交付摘要
```

---

## 27.2 Coding Agent 的核心循环

| 阶段 | Agent 应该做什么 | 主要产物 |
|---|---|---|
| Read | 读取需求、代码、文档、错误日志 | 上下文摘要 |
| Plan | 拆解任务、判断风险、确定修改范围 | 执行计划 |
| Edit | 修改代码、测试、配置、文档 | 文件变更 |
| Test | 运行单测、lint、typecheck、build | 测试结果 |
| Diff | 查看改动范围 | git diff |
| Review | 自查 bug、风险、回归 | review notes |
| Repair | 根据失败修复 | 修复提交 |
| Deliver | 输出变更摘要、验证结果、风险 | PR / patch / summary |

---

## 27.3 为什么不能直接让 Agent 写代码

| 直接写代码的问题 | 后果 |
|---|---|
| 没读完整上下文 | 改错文件、重复造轮子 |
| 没计划 | 修改范围失控 |
| 没测试 | 假完成 |
| 没 diff | 无法审查 |
| 没回归 | 旧功能被破坏 |
| 没文档同步 | 代码和说明漂移 |
| 没风险说明 | 用户无法判断是否可合并 |

---

## 27.4 Coding Agent 的输入契约

高质量任务输入至少包含：

| 字段 | 说明 |
|---|---|
| Goal | 要修什么、做什么、改什么 |
| Context | 涉及文件、报错、issue、PRD、相关模块 |
| Constraints | 架构限制、风格限制、安全限制 |
| Done When | 什么条件下才算完成 |
| Test Command | 应该运行哪些验证命令 |
| Scope Boundary | 哪些目录或模块不能碰 |
| Risk Level | 是否涉及数据库、部署、权限、生产数据 |

示例：

```text
目标：修复 skill-quality-reviewer 在近似场景下误触发的问题。
上下文：读取 .agents/skills/skill-quality-reviewer/SKILL.md 和 evals/trigger_cases.json。
约束：不要改其他 skill；不要删除历史测试样例。
完成标准：正例、反例、近似场景测试全部通过；输出 diff 和测试结果。
```

---

## 27.5 Coding Agent 的输出契约

Agent 完成后不能只说“已完成”，必须输出：

| 输出 | 说明 |
|---|---|
| Changed Files | 改了哪些文件 |
| What Changed | 每个文件为什么改 |
| Tests Run | 跑了哪些测试 |
| Test Result | 测试是否通过 |
| Diff Summary | 改动范围摘要 |
| Risks | 潜在风险 |
| Not Done | 没做的内容 |
| Next Step | 是否需要人工 review / PR / merge |

---

## 27.6 Coding Agent 工作循环模板

```text
1. Read
- 读取需求
- 读取相关文件
- 读取项目规则

2. Plan
- 明确目标
- 限定范围
- 列出修改方案
- 标出风险

3. Edit
- 做最小必要改动
- 同步测试和文档

4. Verify
- 运行 lint / test / typecheck / build
- 失败则修复并重跑

5. Review
- 查看 git diff
- 检查是否改了无关文件
- 检查是否符合完成标准

6. Deliver
- 输出变更摘要
- 输出测试结果
- 输出风险和未完成项
```

---

## 27.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Agent 写出代码就算完成 | 代码可能没跑、没测、没审 | 必须进入验证和 diff |
| Prompt 越详细越好 | 过长但无结构会失焦 | 用 Goal / Context / Constraints / Done When |
| 让 Agent 一次做大任务 | 容易范围失控 | 拆成小任务和 PR |
| 测试失败让 Agent 继续解释 | 解释没用 | 读取日志，修复，重跑 |
| 不看 diff 直接接受 | 风险高 | diff 是最低审查门槛 |

---

## 27.8 Feynman 解释

Coding Agent 像一个初级开发者。

你不会只看他说“我写完了”，你会要求：

```text
你读了哪个需求？
改了哪些文件？
为什么这么改？
跑了哪些测试？
diff 给我看。
有没有风险？
```

这就是 Coding Agent 的工作循环。

---

## 27.9 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计工作循环 | 能写出 read → plan → edit → test → diff → review → deliver |
| 定义输入契约 | 能给 Agent 明确 Goal / Context / Done When |
| 定义输出契约 | 能要求变更摘要、测试结果、风险说明 |
| 防止假完成 | 能识别“没测试、没 diff、没交付物”的假完成 |
| 迁移到 Codex | 能用这个循环约束 Codex 执行任务 |

---

# 第 28 章：Repo Harness｜仓库结构、AGENTS.md、约束文件

## 28.1 本章核心

> **Repo Harness 的作用，是让代码仓库本身成为 Coding Agent 的工作说明书、边界地图和质量规则库。**

对人类来说，仓库只是代码存放处。

对 Coding Agent 来说，仓库还应该包含：

```text
怎么安装
怎么运行
怎么测试
怎么写代码
哪些目录不能碰
什么叫完成
PR 怎么写
安全规则是什么
```

---

## 28.2 Repo Harness 包含什么

| 模块 | 作用 |
|---|---|
| README.md | 面向人类的项目说明 |
| AGENTS.md | 面向 Coding Agent 的工作规则 |
| CONTRIBUTING.md | 贡献流程和协作规范 |
| CODEOWNERS | 代码责任人 |
| test scripts | 测试命令 |
| lint / format config | 静态质量规则 |
| type config | 类型检查规则 |
| CI config | 自动验证流程 |
| docs/ | 架构和使用文档 |
| evals/ | Agent / Skill 评估样例 |
| scripts/ | 可复用工程脚本 |

---

## 28.3 AGENTS.md 的作用

AGENTS.md 可以理解为：

> **给 Coding Agent 看的 README。**

它适合写入：

| 内容 | 示例 |
|---|---|
| 项目结构 | src/、tests/、docs/、scripts/ 的用途 |
| 安装命令 | pnpm install、uv sync、npm install |
| 测试命令 | pnpm test、pytest、npm run test |
| 构建命令 | pnpm build、npm run build |
| 代码风格 | TypeScript strict、单引号、函数式风格 |
| 禁止事项 | 不改生成文件、不提交密钥、不删除 raw 数据 |
| 完成标准 | 改代码后必须跑测试和检查 diff |
| PR 要求 | 摘要、测试、风险、截图 |

OpenAI Codex 文档说明，Codex 会在开始工作前读取 AGENTS.md，并且支持全局、项目级、目录级指令层叠；更靠近当前目录的文件会在合并指令中更靠后出现，从而覆盖更上层规则。官方 AGENTS.md 网站也将其描述为 “README for agents”，用于提供 build steps、tests、conventions 等面向 coding agents 的上下文。

---

## 28.4 AGENTS.md 推荐结构

```markdown
# AGENTS.md

## Project Overview
- 这个项目做什么
- 核心模块在哪里

## Setup Commands
- 安装依赖：...
- 启动开发环境：...

## Test Commands
- 单元测试：...
- 类型检查：...
- lint：...
- build：...

## Code Style
- 命名规则
- 文件组织
- 禁止模式

## Architecture Rules
- 模块边界
- 依赖方向
- 不能跨层调用

## Agent Workflow
- 修改前先读相关文件
- 修改后必须运行测试
- 交付前必须输出 diff

## Safety Rules
- 不提交密钥
- 不删除用户数据
- 不自动部署

## Definition of Done
- 测试通过
- diff 可审查
- 文档同步
- 风险说明完整
```

---

## 28.5 Repo Harness 的层级

| 层级 | 文件 | 作用 |
|---|---|---|
| 全局 | ~/.codex/AGENTS.md 或个人规则 | 个人长期偏好 |
| 仓库级 | repo/AGENTS.md | 整个项目规则 |
| 模块级 | services/payment/AGENTS.md | 某个模块特殊规则 |
| 任务级 | PLANS.md / issue / PRD | 当前任务规则 |
| Skill 级 | SKILL.md | 某个能力的执行规则 |

原则：

```text
越靠近当前任务，规则越具体；
越上层，规则越通用。
```

---

## 28.6 约束文件的价值

| 文件 | 对 Agent 的价值 |
|---|---|
| package.json | 知道脚本命令 |
| tsconfig.json | 知道类型规则 |
| eslint.config.js | 知道 lint 规则 |
| pyproject.toml | 知道 Python 工程配置 |
| pytest.ini | 知道测试配置 |
| Dockerfile | 知道运行环境 |
| GitHub Actions yaml | 知道 CI 验证 |
| .env.example | 知道环境变量结构 |
| CODEOWNERS | 知道谁该 review |

这些文件不是“给人看的附属物”，而是 Coding Agent 的工程上下文。

---

## 28.7 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 只写 README，不写 AGENTS.md | Agent 不知道具体工作规则 | 单独写 agent-facing instructions |
| AGENTS.md 写成长篇理念 | Agent 难执行 | 写命令、边界、DoD |
| 所有规则放一个文件 | 容易过长、冲突 | 根规则 + 子目录规则 |
| 规则写完不更新 | 会误导 Agent | 从失败案例迭代 |
| 只写“高质量” | 不可执行 | 转成测试命令和检查项 |

---

## 28.8 迁移到你的 Terry-AIWork

你可以这样设计仓库 Harness：

```text
Terry-AIWork/
├─ AGENTS.md                 # 全仓库 Agent 工作规则
├─ references/               # 通用参考资料
├─ templates/                # 可复用模板
├─ .agents/
│  ├─ skills/
│  │  └─ skill-name/
│  │     ├─ SKILL.md
│  │     ├─ references/
│  │     ├─ assets/
│  │     ├─ scripts/
│  │     ├─ evals/
│  │     └─ CHANGELOG.md
│  └─ evals/
├─ docs/
├─ scripts/
└─ llm-wiki/
```

AGENTS.md 重点写：

```text
工作语言：中文
输出偏好：MECE、表格化、少长文
Skill 结构标准
llm-wiki 沉淀规则
测试和 eval 要求
禁止修改无关目录
交付前必须 diff
```

---

## 28.9 Feynman 解释

Repo Harness 像新员工入职手册 + 项目地图。

如果没有它，新员工只能到处问、自己猜、乱翻文件。

如果有它，他知道：

```text
项目怎么跑
代码在哪
测试怎么跑
什么风格是对的
哪些地方不能碰
做完怎么交付
```

Coding Agent 也是一样。

---

## 28.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 理解 Repo Harness | 能说出仓库不只是代码，还包含 Agent 工作规则 |
| 设计 AGENTS.md | 能写 setup、test、style、DoD、safety |
| 设计层级规则 | 能区分全局、仓库、目录、任务规则 |
| 识别约束文件 | 能让 Agent 使用 package、CI、lint、type config |
| 迁移到个人仓库 | 能为 Terry-AIWork 设计 repo harness |

---

# 第 29 章：PR Harness｜diff、review、merge gate

## 29.1 本章核心

> **PR Harness 的作用，是把 Coding Agent 的代码变更放进一个可讨论、可审查、可验证、可回滚的交付容器。**

PR 不只是 GitHub 上的按钮。

在 Coding Agent 工程里，PR 是：

```text
变更边界
审查入口
CI 触发器
讨论空间
质量门禁
合并前最后防线
```

---

## 29.2 为什么 Coding Agent 必须重视 PR

| 没有 PR Harness | 风险 |
|---|---|
| 直接改 main | 无法隔离风险 |
| 不看 diff | 不知道改了什么 |
| 不跑 CI | 假完成 |
| 不写说明 | Reviewer 不知道意图 |
| 不记录讨论 | 决策不可追踪 |
| 不设 merge gate | 低质量代码进入主分支 |

GitHub 文档将 pull request 定义为提出、审查并合并代码变更的协作功能；PR 页面中的 Conversation、Commits、Checks、Files changed 和 Merge status 分别用于讨论、查看提交历史、查看自动检查、查看 diff 和识别合并阻塞点。

---

## 29.3 PR Harness 的核心结构

| 模块 | 作用 |
|---|---|
| Branch | 隔离变更 |
| Commit | 保存变更点 |
| Diff | 展示具体修改 |
| PR Description | 说明为什么改 |
| Review | 人工或 Agent 审查 |
| Checks | CI 验证结果 |
| Comments | 讨论和修改意见 |
| Merge Gate | 合并前门禁 |
| Revert Path | 出错后回滚 |

---

## 29.4 Diff 是最小审查单元

Diff 回答：

```text
哪里被改了？
新增了什么？
删除了什么？
有没有改到无关文件？
测试有没有同步？
文档有没有同步？
```

Agent 交付时至少要输出：

| 内容 | 说明 |
|---|---|
| Modified Files | 文件清单 |
| Added Lines | 主要新增 |
| Deleted Lines | 主要删除 |
| Risky Areas | 高风险变更 |
| Test Impact | 测试影响 |
| Review Focus | Reviewer 应重点看什么 |

---

## 29.5 高质量 PR 描述模板

```markdown
## Summary
- 本 PR 解决什么问题
- 核心改动是什么

## Changes
- 修改 A：原因
- 修改 B：原因

## Tests
- [ ] npm test
- [ ] npm run lint
- [ ] npm run typecheck

## Risk
- 风险 1：...
- 回滚方式：...

## Review Focus
- 请重点看 ...

## Not Included
- 本 PR 不处理 ...
```

---

## 29.6 PR Review Harness

PR Review 不只是“看代码”。

| 评审维度 | 检查问题 |
|---|---|
| Correctness | 是否解决问题 |
| Scope | 是否只改必要范围 |
| Architecture | 是否符合架构边界 |
| Maintainability | 是否容易维护 |
| Security | 是否引入安全风险 |
| Tests | 是否有足够测试 |
| Regression | 是否破坏旧功能 |
| Docs | 文档是否同步 |
| Observability | 是否有日志 / 错误处理 |

OpenAI Codex 的 GitHub code review 文档说明，Codex 可以在 PR 评论中通过 `@codex review` 触发审查，也可以启用自动审查；它会读取 PR diff、遵循仓库 guidance，并聚焦严重问题。

---

## 29.7 Merge Gate

PR 合并前必须过门禁。

| Gate | 是否必须 |
|---|---:|
| CI 通过 | 必须 |
| 关键测试通过 | 必须 |
| 无未解决 blocker comment | 必须 |
| Scope 合理 | 必须 |
| 文档同步 | 视任务 |
| Code owner approval | 视仓库 |
| Security review | 高风险必须 |
| Rollback plan | 高风险建议必须 |

---

## 29.8 Coding Agent 的 PR 工作流

```text
创建 feature branch
→ Agent 修改代码
→ Agent 运行测试
→ Agent 输出 diff summary
→ 创建 draft PR
→ CI 自动运行
→ Agent / 人工 review
→ 修复评论
→ checks 通过
→ merge gate 放行
→ 合并 main
```

---

## 29.9 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| Agent 改完就直接合并 | 风险太高 | 必须 review + checks |
| PR 描述随便写 | Reviewer 难判断 | 写清 Summary / Tests / Risks |
| diff 太大也接受 | 难审查 | 拆小 PR |
| CI 失败先合并 | 破坏主分支 | CI 失败不得合并 |
| 只看代码不看测试 | 可能没验证 | 测试是 PR 的一部分 |

---

## 29.10 Feynman 解释

PR Harness 像工程变更申请单。

不能因为一个工程师说“我改好了”，就直接把桥梁设计图换掉。

必须说明：

```text
改了哪里
为什么改
谁审查
测试是否通过
风险是什么
能否回滚
```

Coding Agent 的代码变更也必须进入这个流程。

---

## 29.11 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 理解 PR Harness | 能说出 PR 不只是合并工具，而是质量容器 |
| 看懂 diff | 能用 diff 审查 Agent 变更 |
| 写 PR 模板 | 能包含 Summary、Tests、Risk、Review Focus |
| 设计 merge gate | 能定义什么条件下允许合并 |
| 迁移到 Codex | 能让 Codex 输出可审查 PR，而不是直接改 main |

---

# 第 30 章：CI Harness｜lint、test、typecheck、build

## 30.1 本章核心

> **CI Harness 的作用，是用自动化检查把 Coding Agent 的“我觉得可以”变成“机器验证通过”。**

CI 是 Coding Agent 的硬约束系统。

它负责检查：

```text
代码能不能构建
测试能不能通过
类型有没有错误
格式是否合规
lint 是否违规
安全扫描是否报警
```

---

## 30.2 CI Harness 的核心模块

| 模块 | 检查内容 |
|---|---|
| Format | 代码格式 |
| Lint | 静态规则 |
| Typecheck | 类型正确性 |
| Unit Test | 单元功能 |
| Integration Test | 模块协作 |
| Build | 是否可构建 |
| Security Scan | 依赖和安全风险 |
| Coverage | 测试覆盖 |
| E2E | 端到端行为 |
| Artifact Check | 产物是否生成 |

GitHub 文档说明，PR 的 Checks tab 可以查看自动测试、build 或其他 CI workflow 的详细输出，也可以重跑失败检查；这些 checks 会帮助团队在合并前确认变更满足质量标准。

---

## 30.3 CI 与 Agent 的关系

| 没有 CI | 有 CI |
|---|---|
| Agent 自称测试通过 | 系统显示测试是否通过 |
| 用户手动检查 | 自动运行检查 |
| 错误晚发现 | PR 阶段发现 |
| 难回归 | 每次变更自动跑 |
| 无硬门禁 | checks 可阻止 merge |

原则：

```text
Agent 可以生成代码，但 CI 决定代码能不能进入主线。
```

---

## 30.4 Coding Agent 应该如何使用 CI

Agent 不是等 CI 报错后才处理，而应该：

```text
本地先跑相关测试
→ 查看失败日志
→ 修复
→ 再跑
→ 提交 PR
→ 等 CI 全量验证
→ 如果 CI 失败，读取 CI 日志修复
```

---

## 30.5 常见验证命令

| 技术栈 | 常见命令 |
|---|---|
| Node / React | npm test、npm run lint、npm run typecheck、npm run build |
| Python | pytest、ruff check、mypy、python -m build |
| Rust | cargo test、cargo clippy、cargo fmt --check、cargo build |
| Go | go test ./...、go vet ./...、gofmt |
| Java | mvn test、gradle test、mvn package |
| General | docker build、make test、make lint |

---

## 30.6 CI Harness 的设计原则

| 原则 | 说明 |
|---|---|
| 快速反馈 | 先跑快测试，慢测试后置 |
| 分层验证 | format → lint → typecheck → test → build |
| 失败可读 | 日志要能定位问题 |
| 与 PR 绑定 | PR 自动触发 |
| 与 merge gate 绑定 | 失败不能合并 |
| 可本地复现 | Agent 本地也能跑同样命令 |
| 覆盖关键路径 | 不追求盲目全量，先覆盖高风险 |

---

## 30.7 CI 失败处理流程

```text
CI failed
→ 读取失败 job
→ 定位失败命令
→ 读取错误日志
→ 判断错误类型
→ 本地复现
→ 最小修复
→ 重跑相关测试
→ 推送更新
→ 等 CI 再次验证
```

错误类型：

| 错误 | 处理 |
|---|---|
| 格式失败 | 运行 formatter |
| lint 失败 | 修规则违规 |
| typecheck 失败 | 修类型 |
| unit test 失败 | 修逻辑或测试 |
| build 失败 | 修依赖或配置 |
| flaky test | 标注并复现，不能直接忽略 |
| 环境失败 | 检查 CI 配置和依赖 |

---

## 30.8 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| CI 是最后才看的东西 | 失败发现太晚 | 本地先跑关键命令 |
| CI 失败可以先合并 | 破坏主分支 | 失败必须阻塞 |
| Agent 说跑过测试就信 | 可能没有真实日志 | 要看命令和输出 |
| 只跑单测就够了 | 构建或类型也可能失败 | 分层检查 |
| flaky test 可以忽略 | 可能隐藏真实问题 | 单独治理 flaky |

---

## 30.9 Feynman 解释

CI Harness 像工厂流水线上的自动检测设备。

工人说“我觉得没问题”不够。产品要经过：

```text
尺寸检测
电气检测
压力测试
包装检查
出厂检验
```

Coding Agent 写的代码也必须过自动检测。

---

## 30.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 理解 CI Harness | 能说出 CI 是 Agent 质量硬门禁 |
| 设计检查层 | 能列出 format、lint、typecheck、test、build |
| 处理 CI 失败 | 能按日志定位、复现、修复、重跑 |
| 绑定 PR | 能让 checks 阻止低质量合并 |
| 迁移到个人项目 | 能为 Terry-AIWork 设计基本 CI 命令 |

---

# 第 31 章：Bugfix Harness｜复现、修复、验证、回归

## 31.1 本章核心

> **Bugfix Harness 的作用，是让 Coding Agent 修 bug 时不靠猜，而是按复现 → 定位 → 修复 → 验证 → 回归的闭环工作。**

低质量修 bug：

```text
看到报错
→ 猜一个原因
→ 改代码
→ 说修好了
```

高质量 Bugfix Harness：

```text
理解 bug
→ 最小复现
→ 定位根因
→ 写失败测试
→ 最小修复
→ 测试通过
→ 加回归保护
→ 输出风险说明
```

---

## 31.2 Bugfix 标准流程

| 阶段 | 目标 | 产物 |
|---|---|---|
| Understand | 理解 bug 现象 | bug summary |
| Reproduce | 稳定复现 | reproduction steps / failing test |
| Diagnose | 找根因 | root cause |
| Fix | 最小修复 | code change |
| Verify | 验证 bug 消失 | test result |
| Regress | 防止复发 | regression test |
| Deliver | 输出说明 | PR summary |

---

## 31.3 为什么“复现”最重要

没有复现，就无法判断是否真的修好。

| 没复现就修 | 风险 |
|---|---|
| 可能修错问题 | 表面症状消失，根因还在 |
| 可能引入新 bug | 改动无依据 |
| 无法证明修复有效 | 只能靠猜 |
| 无法做回归测试 | 下次还会坏 |

原则：

```text
不能复现的 bug，不能宣称已修复；最多只能说做了防御性改动。
```

---

## 31.4 Bug Report 输入模板

```text
Bug Title:
- 一句话描述问题

Observed Behavior:
- 实际发生了什么

Expected Behavior:
- 应该发生什么

Steps to Reproduce:
1. ...
2. ...
3. ...

Environment:
- OS / browser / version / branch

Logs / Screenshots:
- 错误日志或截图

Impact:
- 影响范围和严重程度
```

---

## 31.5 Coding Agent 修 bug 的 Prompt 模板

```text
请按 Bugfix Harness 修复这个问题：

1. 先阅读 bug report 和相关代码；
2. 先尝试复现，不要直接修改；
3. 如果可以复现，先写一个失败测试；
4. 定位根因，说明原因；
5. 做最小必要修复；
6. 运行相关测试；
7. 如果测试失败，读取日志继续修复；
8. 最后输出 changed files、root cause、tests run、risk。

禁止：
- 未复现就宣称修复；
- 删除测试绕过失败；
- 大范围重构；
- 修改无关模块。
```

---

## 31.6 Bugfix 的测试策略

| 测试 | 作用 |
|---|---|
| Failing Test | 证明 bug 存在 |
| Regression Test | 防止复发 |
| Unit Test | 验证小逻辑 |
| Integration Test | 验证模块协作 |
| Snapshot Test | 验证输出变化 |
| E2E Test | 验证用户路径 |
| Negative Test | 验证异常输入 |

---

## 31.7 Bugfix 常见错误

| 错误 | 后果 | 修复 |
|---|---|---|
| 不复现直接修 | 无法证明有效 | 先复现 |
| 只修症状 | 根因仍在 | root cause analysis |
| 改动过大 | 引入新风险 | 最小修复 |
| 删除失败测试 | 掩盖问题 | 保留并修复 |
| 没加回归测试 | 下次复发 | 加 regression |
| 没说明风险 | Reviewer 难判断 | 输出 risk |

---

## 31.8 Feynman 解释

Bugfix Harness 像医生治病。

不能病人一说头疼，医生就随便开药。要先问诊、检查、确认原因，再治疗，最后复查。

Coding Agent 修 bug 也是：

```text
先复现，再治疗。
```

---

## 31.9 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计 bugfix 流程 | 能写出复现、定位、修复、验证、回归 |
| 判断修复可信度 | 能识别未复现就宣称修复的问题 |
| 设计失败测试 | 能让 bug 先红后绿 |
| 控制修复范围 | 能避免大范围重构 |
| 沉淀回归保护 | 能把 bug 变成长期测试 |

---

# 第 32 章：Refactor Harness｜重构边界与安全网

## 32.1 本章核心

> **Refactor Harness 的作用，是让 Coding Agent 在不改变外部行为的前提下改善内部结构。**

重构不是重写。

重构的核心是：

```text
外部行为不变
内部结构变好
```

如果没有 Harness，Agent 很容易把重构变成：

```text
顺手改功能
顺手换架构
顺手删代码
顺手重写半个项目
```

---

## 32.2 重构的目标

| 目标 | 说明 |
|---|---|
| 降低复杂度 | 减少重复、拆分大函数 |
| 提升可读性 | 命名清晰、结构清楚 |
| 提升可测试性 | 依赖可注入、逻辑可分离 |
| 改善模块边界 | 降低耦合 |
| 消除技术债 | 去掉过时模式 |
| 准备未来功能 | 为新需求铺路，但不实现新需求 |

---

## 32.3 Refactor Harness 的安全网

| 安全网 | 作用 |
|---|---|
| Existing Tests | 保证旧行为不变 |
| Characterization Tests | 为旧行为补测试 |
| Typecheck | 防止接口破坏 |
| Snapshot | 检查输出变化 |
| Diff Review | 控制改动范围 |
| Feature Flag | 降低上线风险 |
| Incremental PR | 小步重构 |
| Rollback Plan | 出错可回退 |

---

## 32.4 重构前检查

Coding Agent 重构前必须回答：

| 问题 | 目的 |
|---|---|
| 为什么要重构？ | 防止无意义美化 |
| 重构范围是什么？ | 防止扩散 |
| 外部行为是什么？ | 明确不变条件 |
| 当前测试是否覆盖？ | 判断安全网 |
| 是否需要先补测试？ | 防止无保护重构 |
| 是否可以拆小 PR？ | 降低 review 难度 |
| 是否涉及 public API？ | 判断兼容性风险 |

---

## 32.5 Refactor Prompt 模板

```text
请执行一次受控重构：

目标：改善 [模块] 的结构，不改变外部行为。

要求：
1. 先说明当前结构问题；
2. 明确重构边界；
3. 检查现有测试覆盖；
4. 如果测试不足，先补 characterization test；
5. 小步修改；
6. 每轮修改后运行相关测试；
7. 输出 diff summary 和风险。

禁止：
- 不要新增业务功能；
- 不要改变 public API，除非明确说明；
- 不要顺手修改无关文件；
- 不要删除测试来通过检查。
```

---

## 32.6 重构类型

| 类型 | 示例 | 风险 |
|---|---|---|
| Rename | 改变量、函数、文件名 | 引用漏改 |
| Extract Function | 抽函数 | 参数和副作用变化 |
| Extract Module | 拆模块 | 依赖路径变化 |
| Remove Duplication | 去重复 | 行为差异被合并 |
| Dependency Inversion | 依赖反转 | 架构影响大 |
| Simplify Condition | 简化判断 | 边界条件漏掉 |
| Data Structure Change | 改数据结构 | 序列化兼容性 |
| API Refactor | 改接口 | 下游破坏 |

---

## 32.7 重构与功能开发的边界

| 行为 | 是否属于重构 |
|---|---:|
| 提取重复函数 | 是 |
| 改变量名 | 是 |
| 拆分大文件 | 是 |
| 新增业务流程 | 否 |
| 改用户可见行为 | 否 |
| 顺手修 bug | 通常不应混入 |
| 替换架构框架 | 高风险，不是普通重构 |

原则：

```text
重构 PR 不要混功能；功能 PR 不要顺手大重构。
```

---

## 32.8 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 重构就是让代码更漂亮 | 容易主观化 | 要有明确结构目标 |
| 没测试也能重构 | 风险高 | 先补 characterization tests |
| 一次重构越彻底越好 | 难 review、难回滚 | 小步重构 |
| 重构顺手加功能 | 难定位问题 | 分 PR |
| Agent 会自动保持行为 | 不可靠 | 用测试和 diff 验证 |

---

## 32.9 Feynman 解释

Refactor 像整理房间结构。

你可以把书架换位置、把物品分类、把乱线收好，但不能把用户的电脑扔掉，也不能把卧室改成厨房。

重构是改善内部结构，不是改变房子的用途。

---

## 32.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分重构和功能 | 能判断哪些改动不该混在一起 |
| 设计重构边界 | 能明确哪些行为必须不变 |
| 建立安全网 | 能要求测试、typecheck、diff |
| 控制 PR 大小 | 能拆小步重构 |
| 防止 Agent 乱改 | 能写出重构约束和禁止项 |

---

# 第 33 章：Documentation Harness｜文档与代码同步

## 33.1 本章核心

> **Documentation Harness 的作用，是让代码、测试、配置、架构说明和用户文档保持同步。**

Coding Agent 很容易只改代码，不改文档。

结果是：

```text
代码已经变了
README 还是旧的
配置说明过期
API 文档不匹配
使用者按文档操作会失败
```

---

## 33.2 文档也是交付物

| 代码变更 | 应同步的文档 |
|---|---|
| 新增功能 | README、使用说明、示例 |
| 改 API | API docs、类型注释、迁移说明 |
| 改配置 | .env.example、config docs |
| 改命令 | AGENTS.md、README、CI docs |
| 改架构 | architecture docs、ADR |
| 改测试方式 | CONTRIBUTING、AGENTS.md |
| 修 bug | changelog、release notes |
| 改 Skill | SKILL.md、CHANGELOG、evals |

---

## 33.3 Documentation Harness 包含什么

| 模块 | 作用 |
|---|---|
| README | 项目入口说明 |
| API Docs | 接口和类型说明 |
| Architecture Docs | 架构和模块关系 |
| ADR | 架构决策记录 |
| CHANGELOG | 版本变化 |
| Migration Guide | 破坏性变更迁移 |
| Examples | 用法示例 |
| AGENTS.md | Agent 工作规则 |
| Inline Comments | 局部复杂逻辑说明 |
| Generated Docs | 自动生成文档 |

---

## 33.4 文档同步检查

Coding Agent 完成代码变更前应检查：

| 问题 | 说明 |
|---|---|
| README 是否还准确？ | 入口说明是否过期 |
| 命令是否变了？ | setup / test / run 命令是否同步 |
| API 是否变了？ | 参数、返回值、错误码是否同步 |
| 配置是否变了？ | env、config、schema 是否同步 |
| 示例是否还能跑？ | examples 是否仍正确 |
| AGENTS.md 是否要更新？ | Agent 工作规则是否变化 |
| CHANGELOG 是否要写？ | 是否需要记录用户可见变化 |

---

## 33.5 文档不是越多越好

| 低质量文档 | 问题 |
|---|---|
| 过度解释简单代码 | 噪声 |
| 文档和代码重复 | 容易漂移 |
| 注释写“做什么”但代码已清楚 | 无价值 |
| 没写“为什么” | 难维护 |
| 自动生成后没人验证 | 可能错误 |

高质量文档关注：

```text
为什么这样设计
如何使用
如何测试
有什么限制
变更后如何迁移
```

---

## 33.6 Documentation Prompt 模板

```text
请检查本次代码变更是否需要同步文档：

1. 查看 diff；
2. 判断是否影响 README、API docs、配置、示例、AGENTS.md、CHANGELOG；
3. 只更新必要文档；
4. 不要写空泛说明；
5. 文档必须和实际命令、参数、行为一致；
6. 输出文档变更摘要。
```

---

## 33.7 Documentation Harness 与 AGENTS.md

当项目工作方式变化时，AGENTS.md 也要更新。

| 变化 | 是否更新 AGENTS.md |
|---|---:|
| 新增测试命令 | 需要 |
| 改构建命令 | 需要 |
| 新增模块规则 | 需要 |
| 新增禁止模式 | 需要 |
| 修复一次 Agent 常犯错 | 建议需要 |
| 只是改文案 | 通常不需要 |

OpenAI Codex best practices 明确建议：当 Codex 重复犯同样错误时，可以让它做 retrospective 并更新 AGENTS.md；这说明 AGENTS.md 应该随真实失败和流程变化持续演化。

---

## 33.8 常见误区

| 误区 | 问题 | 正确做法 |
|---|---|---|
| 文档是最后再补 | 容易忘 | 和代码同 PR 更新 |
| Agent 写文档就一定对 | 可能幻觉命令 | 必须核对实际代码 |
| 注释越多越好 | 维护成本高 | 只解释复杂逻辑和原因 |
| README 给人看，AGENTS.md 不重要 | Agent 会缺规则 | 二者分工 |
| 改配置不改示例 | 用户按文档失败 | 同步 .env.example 和 docs |

---

## 33.9 Feynman 解释

Documentation Harness 像机器说明书。

机器内部零件换了，如果说明书不更新，用户按旧说明操作就会出错。

代码也是机器，文档就是说明书。

---

## 33.10 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 把文档视为交付物 | 能要求代码和文档同 PR |
| 识别文档影响 | 能判断 README、API、config、examples 是否需更新 |
| 防止文档漂移 | 能用检查项验证文档是否仍准确 |
| 更新 AGENTS.md | 能把重复失败变成 Agent 规则 |
| 控制文档质量 | 不写空泛文档，只写有维护价值的内容 |

---

# 第 34 章：Codex / Claude Code / Cursor 的 Harness 差异

## 34.1 本章核心

> **Codex、Claude Code、Cursor 的差异，不只是模型差异，而是产品形态、工作入口、规则系统、工具生态、审查方式和执行环境的差异。**

但底层方法相同：

```text
任务入口
→ 上下文
→ 工具
→ 文件系统
→ diff
→ test
→ review
→ PR
→ CI
→ 沉淀
```

---

## 34.2 三类工具的定位

| 工具 | 更适合的定位 | 简单理解 |
|---|---|---|
| Codex | 面向 repo、PR、云任务、代码审查的 Coding Agent | 更像可配置的工程队友 |
| Claude Code | 面向终端、hooks、skills、subagents、MCP 的开发者 Agent | 更像可扩展的命令行工程助手 |
| Cursor | 面向 IDE、Agent mode、rules、MCP、cloud agents 的 AI 编辑器 | 更像带 Agent 能力的开发环境 |

---

## 34.3 Codex 的 Harness 特点

Codex 适合关注：

| Harness 维度 | 特点 |
|---|---|
| Repo Guidance | AGENTS.md 支持全局、仓库、目录层级规则 |
| PR Review | 可在 GitHub PR 中触发 Codex review |
| Cloud Task | 可围绕 PR / repo 上下文执行任务 |
| Diff Review | 强调变更审查和修复 |
| Configuration | 支持 sandbox、approval、MCP、skills 等配置方向 |
| Best Practice | 强调 goal、context、constraints、done when、testing、review |

OpenAI Codex best practices 建议把 Codex 当作一个可配置并可持续改进的队友，而不是一次性助手；官方推荐任务提示包含 Goal、Context、Constraints、Done when，并把 AGENTS.md 用作可复用指导，将测试、lint、typecheck、diff review 等纳入工作流。

---

## 34.4 Claude Code 的 Harness 特点

Claude Code 适合关注：

| Harness 维度 | 特点 |
|---|---|
| CLAUDE.md | 项目和团队约定沉淀 |
| Hooks | 可在生命周期事件中自动执行命令、HTTP endpoint 或 LLM prompt |
| Skills | 把重复工作沉淀为能力 |
| Subagents | 拆分专门角色 |
| MCP | 连接外部工具和数据 |
| Plugins | 将 skills、hooks、subagents、MCP servers 打包复用 |

Claude Code 文档说明，hooks 是在 Claude Code 生命周期中特定点自动执行的 shell command、HTTP endpoint 或 LLM prompt；其 feature overview 也说明 plugin 可以把 skills、hooks、subagents、MCP servers 打包为可安装单元。

---

## 34.5 Cursor 的 Harness 特点

Cursor 适合关注：

| Harness 维度 | 特点 |
|---|---|
| IDE Context | 与编辑器、文件、选区、代码导航结合紧 |
| Agent Mode | 在 IDE 中启动代码任务 |
| Plan Mode | 先研究代码库并生成可审查计划 |
| Rules | Project / Team / User rules 等持久规则 |
| MCP | 连接外部工具和数据源 |
| Skills | 复用专门能力 |
| Cloud Agent | 在云端持续处理 coding task |

Cursor 官方文档入口覆盖 Agent、Rules、MCP、Skills、CLI；其 Plan Mode 文档描述了在写代码前创建详细实现计划，Agent 会研究 codebase、提出澄清问题并生成可审查 plan；其 MCP 文档说明 Cursor 可以通过 MCP 连接外部工具和数据源。

---

## 34.6 三者对比表

| 维度 | Codex | Claude Code | Cursor |
|---|---|---|---|
| 主要入口 | CLI / app / GitHub / cloud | terminal / CLI | IDE / agent / cloud |
| 仓库规则 | AGENTS.md | CLAUDE.md / commands / config | Rules / AGENTS.md |
| 自动化扩展 | MCP、skills、automations | hooks、skills、subagents、MCP、plugins | rules、skills、MCP、cloud agents |
| 审查机制 | diff、/review、GitHub PR review | hooks / manual review / tool outputs | IDE review、plan、diff、cloud PR |
| 强项 | repo 级任务、PR 审查、云端任务 | 命令行可扩展性、hooks、subagents | IDE 内上下文、编辑体验、计划与云 Agent |
| 风险 | 规则过少会漂移；权限过宽有风险 | hooks 配置不当有副作用 | IDE 便利性可能掩盖 review 和 test |
| 推荐 Harness | AGENTS.md + tests + PR gate | CLAUDE.md + hooks + skills + permissions | Rules + plan mode + tests + PR review |

---

## 34.7 不要把工具选择当成核心问题

错误问题：

```text
我应该用 Codex、Claude Code 还是 Cursor？
```

更好的问题：

```text
我的 Coding Agent Harness 是否完整？
```

先检查：

| 问题 | 是否清楚 |
|---|---:|
| 任务入口是否清楚 | □ |
| Repo 规则是否清楚 | □ |
| Agent 是否知道测试命令 | □ |
| 是否必须输出 diff | □ |
| 是否有 PR review | □ |
| CI 是否阻止合并 | □ |
| bugfix 是否先复现 | □ |
| refactor 是否有安全网 | □ |
| 文档是否同步 | □ |

工具不同，但这套 Harness 判断不变。

---

## 34.8 选择建议

| 你的目标 | 更适合 |
|---|---|
| 仓库级任务、PR 审查、云端任务 | Codex |
| 终端工作流、hooks、subagents、MCP 编排 | Claude Code |
| IDE 内开发、快速编辑、上下文导航、Agent mode | Cursor |
| 复杂工程交付 | 三者都可以，但必须接入 PR / CI / review |
| 个人知识工程 + Skill 工程 | Codex / Claude Code 更适合沉淀规则；Cursor 适合 IDE 内快速迭代 |

---

## 34.9 你的推荐组合

结合你的目标：

```text
目标：创建高质量 Agent / Skill，并沉淀到 Terry-AIWork 和 llm-wiki。
```

推荐工作方式：

| 层 | 建议 |
|---|---|
| Repo Harness | Terry-AIWork 根目录写 AGENTS.md |
| Skill Harness | 每个 skill 用 SKILL.md + references + assets + scripts + evals |
| Coding Agent | 用 Codex 或 Claude Code 做仓库级实现 |
| IDE 迭代 | 用 Cursor 做局部文件修改和快速 review |
| PR Harness | 所有重要变更走 branch → diff → PR |
| CI Harness | 至少建立 lint / test / markdown check |
| Knowledge Harness | 每次阶段学习输出 md 到 llm-wiki |

---

## 34.10 常见误区

| 误区 | 问题 | 正确理解 |
|---|---|---|
| 工具强就不需要规则 | 强工具也会漂移 | 必须有 repo rules |
| IDE 自动补全就是 Coding Agent | 只是局部能力 | Coding Agent 应能完成任务循环 |
| Agent 能跑测试就不用 review | 测试覆盖有限 | review 仍必要 |
| Cloud Agent 可以完全放手 | 云端也要权限和 PR gate | 异步不等于无审查 |
| 多工具一起用就更强 | 可能上下文和规则混乱 | 先统一 Harness，再选工具 |

---

## 34.11 Feynman 解释

Codex、Claude Code、Cursor 像三种不同的工程师工作台：

```text
Codex 更像远程工程队友和 PR reviewer；
Claude Code 更像可编排的终端工程助手；
Cursor 更像带 Agent 的 IDE 工作台。
```

但不管用哪个，工程纪律一样：

```text
读需求、看代码、做计划、改文件、跑测试、看 diff、走 review、过 CI。
```

---

## 34.12 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分工具定位 | 能说清 Codex / Claude Code / Cursor 的入口和强项 |
| 不迷信工具 | 能把注意力放在 Harness 是否完整 |
| 设计组合工作流 | 能让不同工具服务于同一工程流程 |
| 迁移到个人项目 | 能规划 Terry-AIWork 的 Coding Agent 使用方式 |
| 控制风险 | 能用 rules、tests、PR、CI、review 约束所有工具 |

---

# 阶段五总结

## 1. 用一句话总结

> **Coding Agent Harness 的核心，不是让 Agent 多写代码，而是让它在 repo、diff、PR、CI、bugfix、refactor、docs 这些工程机制中稳定交付。**

---

## 2. 阶段五总图

```text
Coding Agent Harness
├─ 27 工作循环
│  └─ read → plan → edit → test → diff → review → deliver
├─ 28 Repo Harness
│  └─ AGENTS.md、目录结构、约束文件
├─ 29 PR Harness
│  └─ branch、diff、review、merge gate
├─ 30 CI Harness
│  └─ lint、test、typecheck、build
├─ 31 Bugfix Harness
│  └─ 复现、定位、修复、验证、回归
├─ 32 Refactor Harness
│  └─ 行为不变、结构改善、安全网
├─ 33 Documentation Harness
│  └─ 代码、配置、文档、AGENTS.md 同步
└─ 34 工具差异
   └─ Codex、Claude Code、Cursor 的定位与组合
```

---

## 3. 阶段五最重要的判断

```text
Agent 写代码只是开始。
真正的 Coding Agent 工程化，要看：

是否读了上下文；
是否有计划；
是否最小化改动；
是否跑了测试；
是否输出 diff；
是否进入 PR；
是否通过 CI；
是否同步文档；
是否能回滚；
是否把失败沉淀为规则。
```

---

## 4. 阶段五掌握标准

| 能力 | 判断标准 |
|---|---|
| 工作流设计 | 能设计 read → plan → edit → test → diff → review → PR |
| Repo Harness | 能写 AGENTS.md 和约束文件 |
| PR Harness | 能设计 PR 模板、review 规则、merge gate |
| CI Harness | 能定义 lint、test、typecheck、build 检查 |
| Bugfix Harness | 能要求先复现、再修复、再回归 |
| Refactor Harness | 能要求行为不变、安全网、小步 PR |
| Documentation Harness | 能让代码和文档同步 |
| 工具判断 | 能根据场景选择 Codex / Claude Code / Cursor |

---

# 下一阶段预告

## 阶段六：Skill 与 Agent 工程迁移｜第 35–42 章

| 章 | 主题 |
|---:|---|
| 35 | Skill 是 Harness 的能力插件 |
| 36 | SKILL.md 与 Harness 规则 |
| 37 | references / assets / scripts / evals 的作用 |
| 38 | Skill 触发 Harness：何时调用、何时不调用 |
| 39 | Skill 执行 Harness：步骤、输入、输出、失败处理 |
| 40 | Skill 质量 Harness：测试与评估 |
| 41 | 多 Skill 系统 Harness |
| 42 | 从一次任务到可复用 Agent 能力 |

---

# 参考来源

- OpenAI Codex best practices: https://developers.openai.com/codex/learn/best-practices
- OpenAI Codex AGENTS.md guide: https://developers.openai.com/codex/guides/agents-md
- OpenAI Codex GitHub code review: https://developers.openai.com/codex/integrations/github
- GitHub Pull Requests documentation: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests
- GitHub Status Checks documentation: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks
- AGENTS.md official site: https://agents.md/
- Claude Code hooks reference: https://code.claude.com/docs/en/hooks
- Claude Code features overview: https://code.claude.com/docs/en/features-overview
- Cursor documentation: https://cursor.com/docs
- Cursor Plan Mode: https://cursor.com/docs/agent/plan-mode
- Cursor Rules: https://cursor.com/docs/rules
- Cursor MCP: https://cursor.com/docs/mcp
- Cursor Skills: https://cursor.com/docs/skills
