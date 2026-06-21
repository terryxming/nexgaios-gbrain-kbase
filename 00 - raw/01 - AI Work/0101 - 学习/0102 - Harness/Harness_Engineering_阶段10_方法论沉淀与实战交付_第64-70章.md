---
title: 'Harness Engineering｜阶段十：方法论沉淀与实战交付（第 64–70 章）'
status: raw
created: '2026-05-21 09:44'
source_type: unknown
material_type: 普通笔记
domain_hint: 'AI Work'

compile_status: 未编译
tags:
  - 'Agent'
  - 'Harness'
  - 'Skill'
  - 'GitHub'
  - 'LLM'
  - 'Knowledge-Base'
---

# Harness Engineering｜阶段十：方法论沉淀与实战交付（第 64–70 章）

阶段十的核心目标：

> 把前面 0–63 章学到的 Harness Engineering，沉淀成一套可复用、可执行、可评估、可迭代的 Agent 工程方法论。

前九个阶段解决的是：

```text
是什么
为什么
有哪些模块
怎么测试
怎么用于 Coding Agent
怎么迁移到 Skill
怎么用于真实业务
怎么保证安全
怎么走向多 Agent 系统
```

阶段十解决的是：

```text
以后我遇到任何 Agent 工程任务，应该用哪套方法设计、检查、评估、复盘和沉淀？
```

---

## 阶段十总览

| 章 | 主题 | 产物 | 一句话理解 |
|---:|---|---|---|
| 64 | Harness Design Canvas | 设计画布 | 用一张表设计任何 Agent |
| 65 | Harness Checklist | 检查清单 | 用清单防止遗漏关键工程层 |
| 66 | Harness Evaluation Rubric | 评分表 | 用统一标准判断 Harness 质量 |
| 67 | Harness Failure Review | 失败复盘模板 | 把 Agent 失败转成规则、测试和资产 |
| 68 | Personal Agent Engineering System | 个人 Agent 工程体系 | 建设你自己的 Agent 能力系统 |
| 69 | Team Agent Engineering System | 团队 Agent 工程体系 | 从个人方法升级为团队规范 |
| 70 | 最终整合：Harness × Agent Engineering 方法论图谱 | 总图谱 | 形成完整方法论闭环 |

---

# 第 64 章：Harness Design Canvas

## 64.1 本章核心

> Harness Design Canvas 是设计任何 Agent / Skill / Workflow 前都可以先填的一张工程画布。

它的作用不是写长文档，而是快速回答：

```text
这个 Agent 要解决什么问题？
需要什么上下文？
能用什么工具？
怎么执行？
怎么验证？
有什么风险？
如何沉淀？
```

如果没有 Canvas，Agent 设计容易直接跳到：

```text
写 prompt
选模型
接工具
开始做
```

这会导致边界、质量、安全和复用问题。

---

## 64.2 Harness Design Canvas 总表

| 模块 | 要回答的问题 | 输出物 |
|---|---|---|
| 1. 任务目标 | 这个 Agent 要完成什么 | Goal |
| 2. 使用场景 | 什么时候使用它 | Use Cases |
| 3. 非使用场景 | 什么时候不该使用它 | Non-use Cases |
| 4. 输入材料 | 它需要什么输入 | Input Contract |
| 5. 上下文来源 | 它应该读取哪些资料 | Context Sources |
| 6. 工具能力 | 它能调用什么工具 | Tool Registry |
| 7. 执行流程 | 它按什么步骤做 | Workflow |
| 8. 状态管理 | 它需要保存什么 | State Plan |
| 9. 输出契约 | 它交付什么 | Output Contract |
| 10. 测试评估 | 如何判断对不对、好不好 | Test / Eval |
| 11. 安全权限 | 哪些动作要限制 | Permission / HITL |
| 12. 可观测性 | 如何追踪过程 | Logs / Trace |
| 13. 恢复机制 | 出错后怎么恢复 | Recovery Plan |
| 14. 沉淀机制 | 如何变成长期资产 | Skill / Wiki / Template |

---

## 64.3 Canvas 填写模板

```markdown
# Harness Design Canvas

## 1. Agent / Skill 名称
-

## 2. 任务目标
-

## 3. 使用场景
-

## 4. 非使用场景
-

## 5. 输入契约
-

## 6. 上下文来源
-

## 7. 工具能力
-

## 8. 执行流程
1.
2.
3.

## 9. 状态管理
-

## 10. 输出契约
-

## 11. 测试与评估
-

## 12. 安全与权限
-

## 13. 可观测性
-

## 14. 失败恢复
-

## 15. 沉淀方式
-
```

---

## 64.4 示例：llm-wiki-writer Canvas

| 模块 | 设计 |
|---|---|
| 任务目标 | 把已有对话或课程内容沉淀成 Markdown 知识资产 |
| 使用场景 | 用户要求“沉淀到 llm-wiki”“输出 .md 文件” |
| 非使用场景 | 普通解释、翻译、邮件、未生成课程内容前的沉淀 |
| 输入材料 | 当前对话、指定阶段、章节范围、用户格式偏好 |
| 上下文来源 | 当前对话、历史大纲、知识库结构、模板 |
| 工具能力 | Markdown 文件生成、文件命名、可选图片生成 |
| 执行流程 | 提取 → 结构化 → 校验 → 生成文件 → 输出链接 |
| 状态管理 | 保存文件名、阶段、版本、用户反馈 |
| 输出契约 | `.md` 文件 + 下载链接 + 内容范围说明 |
| 测试评估 | 范围检查、标题层级、表格、代码块、文件存在 |
| 安全权限 | 不覆盖旧文件，不删除 raw 资料 |
| 可观测性 | 记录来源、阶段、文件名、生成时间 |
| 恢复机制 | 文件错误时重新生成，不覆盖原文件 |
| 沉淀方式 | 加入 llm-wiki processed/courses |

---

## 64.5 示例：skill-quality-reviewer Canvas

| 模块 | 设计 |
|---|---|
| 任务目标 | 评估一个 Skill 是否可触发、可执行、可测试、可维护 |
| 使用场景 | 用户上传或指定 SKILL.md 并要求评估质量 |
| 非使用场景 | 普通解释 Skill 概念、创建新 Skill |
| 输入材料 | SKILL.md、相关 references/assets/scripts/evals |
| 上下文来源 | Skill 标准结构、用户项目规范、已有测试 |
| 工具能力 | 文件读取、结构检查、可选 eval runner |
| 执行流程 | 读文件 → 评估 frontmatter → 评估 instruction → 评估资源 → 评分 → 建议 |
| 状态管理 | 记录评分、问题、迭代建议 |
| 输出契约 | 评分表、问题清单、原因、改进建议、风险 |
| 测试评估 | 正例、反例、近似触发测试 |
| 安全权限 | 评估默认只读，不直接修改 |
| 可观测性 | 引用文件位置和评估依据 |
| 恢复机制 | 信息不足时说明缺失项 |
| 沉淀方式 | 失败案例进入 skill-quality-reviewer evals |

---

## 64.6 Canvas 的使用顺序

```text
先填 Canvas
→ 再写 Prompt / SKILL.md / AGENTS.md
→ 再配置工具和权限
→ 再写测试和 eval
→ 最后进入执行
```

不要反过来。

错误顺序：

```text
先让 Agent 做
→ 做坏了再补规则
```

正确顺序：

```text
先设计 Harness
→ 再让 Agent 执行
→ 失败后迭代 Harness
```

---

## 64.7 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 使用 Canvas | 能用一张表设计 Agent |
| 识别缺口 | 能发现缺少上下文、工具、测试、安全或沉淀 |
| 迁移场景 | 能用于 Skill、Coding Agent、业务 Agent |
| 防止直接执行 | 不再一上来只写 prompt |
| 形成设计资产 | Canvas 可进入项目文档和 llm-wiki |

---

# 第 65 章：Harness Checklist

## 65.1 本章核心

> Harness Checklist 是 Agent 执行前、执行中、交付前的检查清单，用来防止关键工程层遗漏。

Canvas 用于设计。  
Checklist 用于检查。

二者区别：

| 工具 | 作用 |
|---|---|
| Canvas | 设计一个 Agent / Skill / Workflow |
| Checklist | 检查它是否准备好、执行对、能交付 |

---

## 65.2 Agent 执行前 Checklist

| 检查项 | 问题 |
|---|---|
| 目标清楚 | 是否知道要完成什么 |
| 范围清楚 | 是否知道做什么、不做什么 |
| 输入清楚 | 是否知道需要哪些材料 |
| 上下文清楚 | 是否知道要读哪些资料 |
| 工具清楚 | 是否知道能用哪些工具 |
| 权限清楚 | 是否知道哪些动作禁止或需审批 |
| 输出清楚 | 是否知道最终交付什么 |
| DoD 清楚 | 是否知道什么叫完成 |
| 风险清楚 | 是否知道高风险点 |
| 是否需要计划 | 复杂任务是否先生成计划 |

---

## 65.3 Agent 执行中 Checklist

| 检查项 | 问题 |
|---|---|
| 是否按计划执行 | 有无偏离原始计划 |
| 是否读了必要上下文 | 是否漏读关键文件 |
| 是否正确调用工具 | 工具选择和参数是否正确 |
| 是否记录状态 | 当前进度是否可恢复 |
| 是否处理失败 | 工具失败、测试失败是否被处理 |
| 是否触发审批 | 高风险动作是否暂停 |
| 是否控制范围 | 是否修改了无关文件 |
| 是否记录过程 | 是否有 trace / log |
| 是否有中间产物 | 是否能审查过程 |
| 是否避免目标漂移 | 是否仍在解决原始问题 |

---

## 65.4 Agent 交付前 Checklist

| 检查项 | 问题 |
|---|---|
| 输出是否存在 | 文件、报告、代码、文案是否真实生成 |
| 输出是否完整 | 该有的部分是否齐全 |
| 格式是否正确 | Markdown、JSON、PR、表格是否合规 |
| 测试是否运行 | 是否有测试命令和结果 |
| eval 是否通过 | 是否达到质量标准 |
| diff 是否审查 | 是否知道改了什么 |
| 风险是否说明 | 是否说明潜在副作用 |
| 未完成项是否说明 | 有没有把未完成伪装成完成 |
| 是否满足 DoD | 是否达到完成标准 |
| 是否需要人工确认 | 是否涉及外部动作或高风险操作 |

---

## 65.5 Skill Checklist

| 模块 | 检查项 |
|---|---|
| Frontmatter | name、description 是否清楚 |
| Trigger | 是否有正例、反例、近似场景 |
| Boundary | 是否说明何时不用 |
| Workflow | 是否可执行，不是空话 |
| Inputs | 是否定义输入要求 |
| Outputs | 是否定义输出契约 |
| References | 是否有必要背景资料 |
| Assets | 是否有模板资源 |
| Scripts | 是否把确定性任务脚本化 |
| Evals | 是否有基础测试和回归样本 |
| Changelog | 是否记录版本变化 |
| Safety | 是否限制危险动作 |

---

## 65.6 Coding Agent Checklist

| 阶段 | 检查项 |
|---|---|
| 任务前 | 是否有 Goal / Context / Constraints / Done When |
| 读取 | 是否读了 README、AGENTS.md、相关文件 |
| 计划 | 是否制定修改计划 |
| 修改 | 是否只改必要范围 |
| 测试 | 是否运行 lint / test / typecheck / build |
| Diff | 是否查看并解释 diff |
| PR | 是否写 Summary / Tests / Risk |
| Review | 是否处理 reviewer feedback |
| Merge | 是否通过 CI 和门禁 |
| Recovery | 是否可回滚 |

---

## 65.7 业务 Agent Checklist

| 业务类型 | 核心检查 |
|---|---|
| 广告分析 | 数据周期、指标链路、假设、动作、风险、观察周期 |
| A+ 文案 | 差异化、用户收益、短、转化、合规、画面适配 |
| 图片提示词 | 主体、产品、动作、场景、构图、比例、负面约束 |
| 客服回复 | 事实、语气、诉求、承诺边界、发送审批 |
| 知识沉淀 | 范围、结构、文件、命名、可复用性 |
| 需求澄清 | 背景、目标、用户、范围、验收、风险 |
| 仓库逆向 | 入口、技术栈、目录、核心模块、测试、风险 |

---

## 65.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分设计与检查 | Canvas 用于设计，Checklist 用于执行检查 |
| 建立分阶段清单 | 执行前、执行中、交付前各有检查 |
| 按任务定制 | 不同 Agent 有不同清单 |
| 防止假完成 | 交付前必须对照 DoD |
| 沉淀清单 | 常见失败转成新检查项 |

---

# 第 66 章：Harness Evaluation Rubric

## 66.1 本章核心

> Harness Evaluation Rubric 是用来评价一个 Agent Harness 设计质量的评分标准。

Checklist 判断“有没有”。  
Rubric 判断“好不好”。

例如：

| 检查 | 评价 |
|---|---|
| 有无测试 | 测试覆盖是否合理 |
| 有无工具 | 工具是否最小、准确、安全 |
| 有无流程 | 流程是否能处理失败和分支 |
| 有无权限 | 权限是否按风险分级 |

---

## 66.2 Harness 质量评分维度

| 维度 | 权重 | 评估问题 |
|---|---:|---|
| 任务边界 | 10% | 目标、范围、非适用场景是否清楚 |
| 上下文设计 | 10% | 上下文来源、优先级、压缩是否合理 |
| 工具设计 | 10% | 工具是否必要、schema 是否清楚、权限是否合适 |
| 工作流设计 | 15% | 步骤、分支、Gate、失败处理是否完整 |
| 输出契约 | 10% | 输出格式、字段、产物是否稳定 |
| 测试评估 | 15% | Test、Eval、Regression 是否存在 |
| 安全权限 | 10% | 权限、审批、沙盒、密钥是否控制 |
| 可观测性 | 5% | 是否有 logs、trace、metrics |
| 恢复审计 | 5% | 是否可回滚、可审计 |
| 沉淀复用 | 10% | 是否能沉淀为 Skill、模板、知识资产 |

---

## 66.3 五分制评分表

| 分数 | 标准 |
|---:|---|
| 1 | 只有 prompt，边界模糊，无法验证 |
| 2 | 有基本流程，但缺少测试、权限和输出契约 |
| 3 | 可执行，有基本测试和输出规范，但失败处理不足 |
| 4 | 边界清楚，流程完整，有测试、eval、安全和沉淀 |
| 5 | 系统级 Harness，可观测、可回归、可审计、可持续迭代 |

---

## 66.4 Rubric 详细评分表

| 维度 | 1 分 | 3 分 | 5 分 |
|---|---|---|---|
| 任务边界 | 目标泛泛 | 有目标和范围 | 有适用 / 不适用 / 风险边界 |
| 上下文设计 | 临时塞资料 | 有上下文来源 | 有优先级、压缩、验证、更新 |
| 工具设计 | 工具随意 | 有工具清单 | 有 schema、权限、错误处理、审计 |
| 工作流设计 | 只有步骤 | 有流程和 Gate | 有状态、分支、失败恢复 |
| 输出契约 | 无格式 | 有基本格式 | 有字段、文件、质量要求、禁止项 |
| 测试评估 | 无测试 | 有基础测试 | 有输入、输出、过程、结果、回归 |
| 安全权限 | 无限制 | 有简单禁止项 | 有 allowlist、denylist、approval、sandbox |
| 可观测性 | 无记录 | 有简单日志 | 有 trace、metrics、cost、latency |
| 恢复审计 | 无恢复 | 可手动修复 | 有 rollback、audit、责任链 |
| 沉淀复用 | 一次性 | 有模板 | 可沉淀为 Skill / Wiki / Playbook |

---

## 66.5 示例评分：普通 Prompt 型 Agent

```text
“你是广告专家，请分析这个广告报表并给建议。”
```

| 维度 | 分数 | 原因 |
|---|---:|---|
| 任务边界 | 2 | 目标有，但范围和指标不清 |
| 上下文设计 | 1 | 未定义数据来源 |
| 工具设计 | 1 | 无指标计算工具 |
| 工作流设计 | 2 | 没有标准诊断流程 |
| 输出契约 | 2 | 没有固定报告结构 |
| 测试评估 | 1 | 无 eval |
| 安全权限 | 2 | 只分析时风险低，但没有操作边界 |
| 可观测性 | 1 | 无记录 |
| 恢复审计 | 1 | 无复盘 |
| 沉淀复用 | 1 | 一次性 prompt |

综合：约 1.5 / 5。

---

## 66.6 示例评分：工程化 Amazon Ad Diagnoser Skill

| 维度 | 分数 | 原因 |
|---|---:|---|
| 任务边界 | 5 | 明确广告诊断场景和非适用场景 |
| 上下文设计 | 4 | 报表、周期、关键词、placement 清楚 |
| 工具设计 | 4 | 有指标计算和表格处理 |
| 工作流设计 | 5 | 数据 → 指标链路 → 假设 → 动作 → 观察 |
| 输出契约 | 5 | 报告结构稳定 |
| 测试评估 | 4 | 有案例和 rubric，仍可加强回归 |
| 安全权限 | 4 | 默认只建议，自动操作需审批 |
| 可观测性 | 3 | 可记录分析历史 |
| 恢复审计 | 3 | 操作建议可审计，自动动作需加强 |
| 沉淀复用 | 5 | 可进入 Skill 系统 |

综合：约 4.2 / 5。

---

## 66.7 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 使用 Rubric | 能评价一个 Harness 的质量 |
| 找短板 | 能指出哪个维度最弱 |
| 区分 3 分和 5 分 | 知道“能用”和“工程化”的差距 |
| 用评分驱动迭代 | 低分项进入改进计划 |
| 统一评估语言 | 团队或个人能用同一标准评估 Agent |

---

# 第 67 章：Harness Failure Review

## 67.1 本章核心

> Harness Failure Review 的作用，是把每次 Agent 失败转化为系统改进，而不是只修一次输出。

Agent 失败后，低质量处理是：

```text
重新生成一次。
```

高质量处理是：

```text
识别失败类型
定位 Harness 缺口
修复系统
增加测试
更新规则
记录复盘
```

---

## 67.2 失败复盘模板

```markdown
# Harness Failure Review

## 1. 失败摘要
-

## 2. 原始任务
-

## 3. 期望结果
-

## 4. 实际结果
-

## 5. 失败类型
- [ ] 任务理解错误
- [ ] 上下文错误
- [ ] 工具错误
- [ ] 流程错误
- [ ] 输出错误
- [ ] 质量错误
- [ ] 权限 / 安全错误
- [ ] 记忆污染
- [ ] 假完成
- [ ] 其他

## 6. 根因分析
-

## 7. 缺失的 Harness
-

## 8. 修复动作
-

## 9. 新增测试 / eval / gate
-

## 10. 是否需要更新 Skill / AGENTS.md / Wiki
-

## 11. 防复发措施
-

## 12. 复盘结论
-
```

---

## 67.3 失败类型与对应修复

| 失败类型 | 表现 | 应修复的 Harness |
|---|---|---|
| 任务理解错误 | 做错方向 | Task Entry / Clarification |
| 上下文错误 | 漏读、读错、用旧资料 | Context Harness |
| 工具错误 | 调错工具、参数错 | Tool Harness |
| 流程错误 | 跳步骤、绕测试 | Workflow Gate |
| 输出错误 | 格式、字段、文件缺失 | Output Contract |
| 质量错误 | 内容浅、泛、不可执行 | Eval Rubric |
| 权限错误 | 越权、误删、外部动作 | Permission / HITL |
| 安全错误 | 泄密、注入、危险命令 | Guardrail / Sandbox |
| 记忆污染 | 旧偏好或错误事实影响 | Memory Update |
| 假完成 | 未满足 DoD 却说完成 | Quality Gate |

---

## 67.4 失败到回归的转换

| 失败 | 新增保护 |
|---|---|
| Skill 误触发 | negative trigger case |
| 输出漏字段 | output schema test |
| 文案太泛 | quality rubric 增加“差异化” |
| Codex 没跑测试 | delivery gate 增加 test evidence |
| 知识库文件覆盖 | filesystem rule 增加禁止覆盖 |
| 客服回复事实错 | fact gate 增加 ASIN / case 校验 |
| 广告建议太冒进 | action gate 增加风险等级 |

---

## 67.5 Failure Review 的工作流

```text
发现失败
→ 暂停继续执行
→ 收集原始输入和输出
→ 分类失败类型
→ 定位缺失 Harness
→ 修复当前结果
→ 更新规则 / 测试 / eval
→ 记录 changelog
→ 下次运行回归检查
```

---

## 67.6 复盘不是追责

复盘的目标不是证明“模型错了”，而是找到：

```text
哪一层 Harness 没有设计好？
什么检查没有挡住错误？
什么规则没有沉淀？
什么测试应该新增？
什么权限应该收紧？
```

---

## 67.7 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 复盘失败 | 能按模板记录失败 |
| 归因到 Harness 层 | 不把所有失败归因于模型 |
| 转成测试 | 每次重要失败都能变成回归样本 |
| 更新系统 | 能改 SKILL.md、AGENTS.md、evals、checklist |
| 防止重复错误 | 同类问题下次能被门禁挡住 |

---

# 第 68 章：Personal Agent Engineering System

## 68.1 本章核心

> Personal Agent Engineering System 是你个人长期使用的 Agent 工程体系，它把知识库、Skill、项目规则、工具、评估和复盘连接起来。

目标不是“会用 ChatGPT”，而是形成个人生产系统：

```text
知识沉淀
→ Skill 构建
→ Agent 工作流
→ Coding Agent
→ 业务 Agent
→ 复盘评估
→ 再沉淀
```

---

## 68.2 个人系统的核心组成

| 模块 | 作用 |
|---|---|
| llm-wiki | 长期知识库 |
| AGENTS.md | 个人工程规则 |
| skills/ | 可复用能力包 |
| templates/ | 输出模板 |
| scripts/ | 确定性工具 |
| evals/ | 测试和评分 |
| logs/ | 执行记录 |
| playbooks/ | 常见任务 SOP |
| cases/ | 失败和成功案例 |
| changelog/ | 方法论演化 |

---

## 68.3 推荐目录结构

```text
Terry-AIWork/
├─ AGENTS.md
├─ llm-wiki/
│  ├─ raw/
│  ├─ processed/
│  ├─ schema/
│  ├─ assets/
│  └─ index/
├─ skills/
│  ├─ knowledge/
│  ├─ agent-engineering/
│  ├─ amazon/
│  ├─ creative/
│  └─ _shared/
├─ templates/
├─ scripts/
├─ evals/
├─ playbooks/
├─ cases/
├─ logs/
└─ changelog/
```

---

## 68.4 个人 Agent 能力优先级

| 优先级 | 能力 | 原因 |
|---:|---|---|
| 1 | llm-wiki-writer | 高频沉淀知识 |
| 2 | complex-task-clarifier | 处理模糊想法 |
| 3 | skill-quality-reviewer | 提升所有 Skill 质量 |
| 4 | skill-creator | 构建新能力 |
| 5 | repo-reverse-engineering | 理解代码项目 |
| 6 | amazon-ad-diagnoser | 服务业务核心 |
| 7 | aplus-copywriter | 提高商业输出效率 |
| 8 | image-prompt-designer | 提高视觉创意效率 |
| 9 | case-reply-writer | 降低平台沟通风险 |

---

## 68.5 个人工作流

```text
遇到任务
→ 判断是否一次性任务 / 可沉淀任务
→ 用 Canvas 设计
→ 用 Checklist 执行
→ 用 Rubric 评估
→ 如果重复出现，沉淀为 Skill
→ 如果失败，做 Failure Review
→ 更新 llm-wiki / evals / AGENTS.md
```

---

## 68.6 个人系统的质量门禁

| Gate | 检查 |
|---|---|
| Knowledge Gate | 重要学习是否沉淀到 llm-wiki |
| Skill Gate | 高频任务是否沉淀为 Skill |
| Eval Gate | 关键 Skill 是否有测试 |
| Coding Gate | 仓库变更是否走 diff / test |
| Safety Gate | 高风险动作是否审批 |
| Review Gate | 重要产物是否审查 |
| Retrospective Gate | 失败是否复盘 |

---

## 68.7 最小启动版本

不要一开始做大平台。先做最小版本：

```text
AGENTS.md
+ llm-wiki/
+ skills/llm-wiki-writer/
+ skills/skill-quality-reviewer/
+ templates/
+ evals/
```

第一阶段只保证：

```text
知识能沉淀
Skill 能评估
失败能记录
仓库有规则
```

---

## 68.8 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 设计个人系统 | 能规划目录和模块 |
| 设定优先级 | 知道先做哪些 Skill |
| 建立工作流 | 每个任务进入设计、执行、评估、沉淀循环 |
| 控制复杂度 | 从最小可用系统开始 |
| 持续迭代 | 失败和高频任务推动系统升级 |

---

# 第 69 章：Team Agent Engineering System

## 69.1 本章核心

> Team Agent Engineering System 是把个人 Agent 工程方法升级成团队级规范、协作流程、权限体系、质量门禁和知识资产。

个人系统关注：

```text
我怎么更高效？
```

团队系统关注：

```text
团队如何一致、高质量、安全地使用 Agent？
```

---

## 69.2 个人级与团队级的区别

| 维度 | 个人系统 | 团队系统 |
|---|---|---|
| 规则 | AGENTS.md | 团队规范、代码规范、审批规则 |
| 知识库 | 个人 llm-wiki | 团队知识库 |
| Skill | 个人 Skill | 团队 Skill Registry |
| Review | 自查 | PR review、Code owner、专家审查 |
| 权限 | 本地控制 | RBAC、审批流 |
| 测试 | 本地 eval | CI / regression suite |
| 安全 | 自我约束 | secret scan、audit、compliance |
| 复盘 | 个人记录 | incident review、postmortem |
| 治理 | 自己维护 | owner、version、deprecation |

---

## 69.3 团队系统核心模块

| 模块 | 作用 |
|---|---|
| Team AGENTS.md | 团队级 Agent 规则 |
| Skill Registry | 团队可用 Skill 清单 |
| Tool Registry | 团队工具和权限清单 |
| Workflow Library | 标准工作流 |
| Eval Suite | 团队评估集 |
| PR / CI Gate | 代码与文档门禁 |
| Security Policy | 权限、密钥、数据规则 |
| Review Process | 人工审查流程 |
| Audit Log | 关键动作记录 |
| Knowledge Base | 方法论、案例、SOP |
| Incident Review | 失败复盘机制 |

---

## 69.4 团队 Agent 使用规范

团队至少需要约定：

| 规范 | 内容 |
|---|---|
| 哪些任务可以用 Agent | 低风险生成、分析、代码草稿 |
| 哪些任务必须人工确认 | 发邮件、上线、广告预算、删除数据 |
| 哪些数据不能给 Agent | 密钥、客户隐私、未授权数据 |
| Agent 产物如何审查 | PR、diff、rubric、人工 review |
| Agent 失败如何处理 | failure review、回归测试 |
| Skill 如何发布 | registry、owner、版本、eval |
| 工具如何接入 | 权限等级、审批、审计 |
| 文档如何同步 | README、AGENTS.md、wiki、changelog |

---

## 69.5 团队 Skill 发布流程

```text
提出 Skill 需求
→ 填 Harness Design Canvas
→ 编写 SKILL.md 和资源
→ 编写 trigger / output / regression evals
→ Reviewer 评估
→ 进入 Skill Registry
→ 小范围使用
→ 收集失败案例
→ 迭代版本
→ 正式启用
```

---

## 69.6 团队质量门禁

| Gate | 检查 |
|---|---|
| Design Gate | Canvas 是否完整 |
| Security Gate | 权限和数据风险是否评估 |
| Eval Gate | 是否有测试样本 |
| Review Gate | 是否经 owner 审查 |
| CI Gate | 自动检查是否通过 |
| Registry Gate | 是否登记版本和状态 |
| Audit Gate | 高风险动作是否可追踪 |
| Deprecation Gate | 旧 Skill 是否处理 |

---

## 69.7 本章掌握标准

| 能力 | 判断标准 |
|---|---|
| 区分个人与团队 | 能说明团队系统多了权限、审计、owner、CI |
| 设计团队规范 | 能制定 Agent 使用规则 |
| 设计 Skill 发布流程 | 能让 Skill 进入团队 registry |
| 设计团队门禁 | 能设置安全、评估、审查、版本规则 |
| 控制组织风险 | 能防止团队滥用 Agent 或无标准使用 |

---

# 第 70 章：最终整合：Harness Engineering × Agent Engineering 方法论图谱

## 70.1 本章核心

> Harness Engineering 的最终价值，是把 Agent 从“会回答的模型”变成“可执行、可控制、可验证、可恢复、可复用、可治理的工程系统”。

最终公式：

```text
Agent Engineering = Model Capability
                  + Harness Design
                  + Tool / State / Workflow
                  + Test / Eval / Quality Gate
                  + Safety / Observability / Recovery
                  + Skill / Knowledge / System Design
```

---

## 70.2 全课程总图

```text
Harness Engineering 完整方法论
├─ 阶段一：概念入门
│  └─ 理解 Harness 是模型外层工程系统
├─ 阶段二：基础概念层
│  └─ Model / Instruction / Context / Tool / State / Execution
├─ 阶段三：核心模块
│  └─ Task Entry / Context / Tool / Memory / Filesystem / Workflow / Feedback / HITL
├─ 阶段四：质量工程
│  └─ Test / Eval / Regression / Quality Gate
├─ 阶段五：Coding Agent Harness
│  └─ Repo / Diff / PR / CI / Bugfix / Refactor / Docs
├─ 阶段六：Skill 工程迁移
│  └─ SKILL.md / references / assets / scripts / evals / registry
├─ 阶段七：真实业务应用
│  └─ 知识库 / 广告 / 文案 / 图片 / 客服 / 需求 / 仓库逆向
├─ 阶段八：安全与可观测性
│  └─ Risk / Permission / Sandbox / Secret / Observability / Recovery / Audit
├─ 阶段九：多 Agent 架构
│  └─ Planner / Executor / Reviewer / Router / Long-Horizon / State / Platform
└─ 阶段十：方法论沉淀
   └─ Canvas / Checklist / Rubric / Failure Review / Personal System / Team System
```

---

## 70.3 Harness Engineering 的 12 层最终模型

| 层 | 作用 | 关键问题 |
|---|---|---|
| 1. Goal Layer | 定义目标 | 要完成什么 |
| 2. Entry Layer | 任务入口 | 用户请求如何变成 task brief |
| 3. Instruction Layer | 行为规则 | Agent 应该怎么工作 |
| 4. Context Layer | 上下文 | Agent 应该看什么 |
| 5. Tool Layer | 行动能力 | Agent 能调用什么 |
| 6. State Layer | 状态管理 | Agent 如何记住进度 |
| 7. Workflow Layer | 流程控制 | Agent 按什么步骤执行 |
| 8. Quality Layer | 测试评估 | 如何判断做对和做好 |
| 9. Safety Layer | 安全权限 | 哪些动作要限制 |
| 10. Observability Layer | 可观测性 | 如何看见过程 |
| 11. Recovery Layer | 恢复机制 | 出错后如何回滚 |
| 12. Knowledge Layer | 沉淀复用 | 如何变成长期资产 |

---

## 70.4 Agent 工程成熟度模型

| 等级 | 名称 | 特征 |
|---:|---|---|
| L0 | Chat Prompt | 只会聊天提问 |
| L1 | Prompt Template | 有固定提示词 |
| L2 | Workflow Agent | 有步骤流程 |
| L3 | Tool-Using Agent | 能调用工具 |
| L4 | Tested Agent | 有测试和 eval |
| L5 | Safe Agent | 有权限、沙盒、审批 |
| L6 | Skill-Based Agent | 能复用 Skill |
| L7 | Multi-Agent System | 多角色协作 |
| L8 | Agent Platform | Registry、Router、Eval、Audit 完整 |
| L9 | Self-Improving System | 失败自动进入复盘、测试和沉淀 |

你的目标不是停在 L1 或 L2，而是逐步建设到 L6–L8。

---

## 70.5 最终判断框架

以后遇到任何 Agent 任务，都按这 10 个问题判断：

| 序号 | 问题 |
|---:|---|
| 1 | 这个任务是否值得做成 Agent / Skill？ |
| 2 | 它的输入、输出、边界是否清楚？ |
| 3 | 它需要哪些上下文？ |
| 4 | 它需要哪些工具？ |
| 5 | 它是否需要状态和文件系统？ |
| 6 | 它应该按什么 workflow 执行？ |
| 7 | 如何测试它是否做对？ |
| 8 | 如何评估它是否做好？ |
| 9 | 哪些风险需要权限、沙盒和人工审批？ |
| 10 | 这次经验如何沉淀为 Skill、模板、wiki 或 eval？ |

---

## 70.6 Harness Engineering × Skill × llm-wiki 的闭环

你的个人目标可以形成一个闭环：

```text
学习新概念
→ 课程化理解
→ 对话沉淀为 llm-wiki
→ 从高频任务提炼 Skill
→ 用 Skill 提高工作效率
→ 用 eval 和 checklist 保证质量
→ 失败进入 Failure Review
→ 更新 Skill / AGENTS.md / wiki
→ 下一次执行质量提升
```

这就是：

```text
知识管理
+ Agent 工程
+ Skill 工程
+ 质量工程
+ 复盘系统
```

---

## 70.7 最小可执行落地路线

不要一次做完整平台。建议按 5 步落地：

| 步骤 | 目标 | 产物 |
|---:|---|---|
| 1 | 建规则 | AGENTS.md |
| 2 | 建知识库 | llm-wiki 三层结构 |
| 3 | 建核心 Skill | llm-wiki-writer、skill-quality-reviewer |
| 4 | 建测试门禁 | trigger / output / regression evals |
| 5 | 建复盘系统 | Failure Review + changelog |

完成这 5 步后，再扩展：

```text
skill-creator
repo-reverse-engineering
amazon-ad-diagnoser
aplus-copywriter
image-prompt-designer
case-reply-writer
```

---

## 70.8 最终方法论压缩版

```text
先定义目标；
再拆边界；
再找上下文；
再配工具；
再设流程；
再建状态；
再做测试；
再加评估；
再控权限；
再加观测；
再能恢复；
再做审计；
最后沉淀为 Skill、模板、Wiki、Playbook。
```

---

# 阶段十总结

## 1. 用一句话总结

> 阶段十的核心是：把 Harness Engineering 沉淀成可复用的方法论工具，包括 Canvas、Checklist、Rubric、Failure Review、个人系统、团队系统和总图谱。

---

## 2. 阶段十产物清单

| 产物 | 用途 |
|---|---|
| Harness Design Canvas | 设计任何 Agent / Skill 前使用 |
| Harness Checklist | 执行前、执行中、交付前检查 |
| Harness Evaluation Rubric | 评价 Harness 质量 |
| Harness Failure Review | 把失败变成测试和规则 |
| Personal Agent Engineering System | 构建个人长期 Agent 工程体系 |
| Team Agent Engineering System | 团队级治理、评估、权限、审计 |
| Final Methodology Map | 总体方法论图谱 |

---

## 3. 阶段十最重要的判断

```text
Harness Engineering 不是一套概念，而是一套工作方式。

以后不要只问：
“这个 prompt 怎么写？”

而要问：
“这个 Agent 的目标、边界、上下文、工具、状态、流程、测试、评估、安全、观测、恢复和沉淀设计完整吗？”
```

---

## 4. 阶段十掌握标准

| 能力 | 判断标准 |
|---|---|
| 方法论沉淀 | 能用 Canvas 设计 Agent |
| 执行检查 | 能用 Checklist 防止遗漏 |
| 质量评估 | 能用 Rubric 给 Harness 打分 |
| 失败复盘 | 能把失败转成规则、测试和沉淀 |
| 个人系统建设 | 能规划自己的 Agent 工程目录 |
| 团队系统建设 | 能理解团队级权限、评估、审计 |
| 总体迁移 | 能把 Harness Engineering 用到 Skill、Codex、业务 Agent、llm-wiki |

---

# 全课程最终收束

Harness Engineering 的最终理解：

```text
Harness Engineering
不是 Prompt Engineering 的升级版，
也不是 Agent Framework 的使用教程。

它是一套围绕 Agent 行为的工程系统设计方法。

它的目标是让模型能力被正确组织、约束、验证、恢复和沉淀，
从而把 LLM 从“会生成内容”
升级为“能稳定完成任务的工程系统”。
```

