# Skill 工程化与产品化｜阶段六：脚本增强与确定性执行

## 阶段定位

阶段六关注 Skill 从“指令型能力包”升级为“可执行能力包”的方法。前几个阶段已经建立了 Skill 的认知边界、基础结构、Prompt 转 Skill 方法、Workflow 工程化和渐进式披露。阶段六进一步解决一个关键问题：

> 当任务中存在稳定、重复、可计算、可校验的动作时，如何用脚本增强 Skill 的确定性。

OpenAI Codex Skills 文档将 Skill 描述为包含 `SKILL.md` 的目录，并可附带 scripts 与 references。OpenAI 的 skill-creator 规范也把规划 reusable contents，包括 scripts、references、assets，作为创建 Skill 的正式步骤之一。Anthropic 的 Agent Skills 工程说明同样强调，Skill 可以把说明、脚本和资源组织在一个目录中，让 Agent 在实际任务中按需使用。

阶段六的核心观点是：

> LLM 适合理解、判断、组织和表达；脚本适合计算、校验、转换和批处理。高质量 Skill 应该把二者分工清楚，而不是让模型承担所有工作。

---

## 第 29 章：为什么 Skill 需要脚本

### 29.1 纯指令型 Skill 的局限

纯指令型 Skill 只依赖 `SKILL.md` 中的自然语言说明。它适合处理文本理解、结构化总结、创意表达和业务判断，但在确定性任务上存在明显局限。

常见问题包括：

| 问题 | 表现 | 示例 |
|---|---|---|
| 结果不稳定 | 同一输入多次输出不同 | Markdown 标题层级检查结果不一致 |
| 计算易出错 | 数字统计、汇总、转换不可靠 | 字数统计、字段数量统计 |
| 格式难保证 | 输出看似正确但不符合机器可读结构 | JSON 缺逗号、表格列数不一致 |
| 批量处理弱 | 多文件、多行、多表处理容易漏项 | 批量清洗 `.md` 文件 |
| 校验不严格 | 模型倾向解释而非严格报错 | 文件名不合规但被忽略 |

LLM 的优势是语义推理，但确定性任务需要可重复、可验证的执行机制。脚本正好补足这一点。

### 29.2 脚本解决什么问题

脚本在 Skill 中主要解决四类问题：

| 类型 | 说明 | 示例 |
|---|---|---|
| 稳定性 | 每次按同一逻辑执行 | 校验 Markdown 标题层级 |
| 可重复性 | 同一输入得到同一输出 | 批量格式转换 |
| 可验证性 | 能返回明确通过/失败 | JSON schema 校验 |
| 可扩展性 | 能处理大批量材料 | 批量清洗文件夹中的 Markdown |

脚本不是为了让 Skill 显得“高级”，而是为了把机器更擅长的事情交给机器程序完成。

### 29.3 模型与脚本的分工

高质量 Skill 的基本分工：

| 任务 | 更适合 LLM | 更适合脚本 |
|---|---:|---:|
| 判断用户意图 | 是 | 否 |
| 识别任务边界 | 是 | 否 |
| 总结概念 | 是 | 否 |
| 改写文案 | 是 | 否 |
| 提取主题 | 是 | 部分 |
| 分类评论 | 是 | 部分 |
| 统计数量 | 否 | 是 |
| 校验 JSON | 否 | 是 |
| 转换文件格式 | 否 | 是 |
| 批量重命名 | 否 | 是 |
| 检查标题层级 | 否 | 是 |
| 生成报告结构 | 是 | 部分 |
| 套用固定模板 | 部分 | 是 |

一句话：

> 判断交给模型，执行交给脚本；语义交给模型，规则交给脚本。

### 29.4 脚本增强的典型价值

#### 价值一：减少模型幻觉

如果让模型自己判断某个 Markdown 文件是否存在重复标题，它可能漏掉或误判。脚本可以直接解析文件并输出重复项。

#### 价值二：让 Skill 可测试

没有脚本时，很多检查只能靠肉眼判断。加入脚本后，可以把规则变成自动化测试。

例如：

```text
输入：一个 Markdown 文件
脚本：检查是否存在空标题、跳级标题、重复标题
输出：PASS / FAIL + 问题列表
```

#### 价值三：支持批量任务

纯 LLM 适合单个任务。脚本适合批量任务。

例如：

```text
清洗 50 个 Skill 文件中的无意义表达
检查 100 个 Markdown 文件的标题层级
将 30 个 JSON 文件转成 CSV
```

#### 价值四：把经验固化为工具

当某个检查动作反复出现时，不应该每次让模型“凭感觉检查”，而应该写成脚本。

### 29.5 什么时候应该考虑加脚本

可以用以下判断标准：

| 问题 | 如果答案是“是” |
|---|---|
| 这个动作是否需要严格一致？ | 应考虑脚本 |
| 这个动作是否涉及计算、统计、校验？ | 应考虑脚本 |
| 这个动作是否会批量重复？ | 应考虑脚本 |
| 这个动作是否有明确输入输出？ | 应考虑脚本 |
| 这个动作是否可以用程序规则表达？ | 应考虑脚本 |

满足 3 个以上，通常就适合脚本化。

### 29.6 不应滥用脚本

脚本不是所有问题的答案。

不应为了“工程化”而把所有判断写成代码。很多工作仍然适合模型完成：

- 解释概念
- 判断上下文意图
- 进行业务推理
- 生成文案
- 总结用户反馈
- 发现隐藏需求
- 将复杂信息转化为清晰表达

脚本的价值是增强 Skill 的确定性，而不是替代 LLM。

### 29.7 本章小结

脚本是 Skill 工程化的重要增强层。

核心公式：

```text
语义判断用 LLM
规则执行用 Script
复杂流程用 Skill 协调
```

---

## 第 30 章：scripts 目录设计

### 30.1 scripts 目录的作用

`scripts/` 目录用于存放 Skill 执行过程中可以调用的脚本文件。

典型结构：

```text
my-skill/
├── SKILL.md
├── references/
│   └── rules.md
├── assets/
│   └── template.md
└── scripts/
    ├── validate_markdown.py
    ├── clean_text.py
    └── convert_csv_to_json.py
```

`scripts/` 的职责不是存放业务说明，而是存放可以被执行的确定性程序。

### 30.2 scripts 与其他目录的区别

| 目录 | 职责 | 内容类型 |
|---|---|---|
| `SKILL.md` | 主流程与执行规则 | Markdown 指令 |
| `references/` | 参考知识 | 规则、案例、术语、标准 |
| `assets/` | 可复用资源 | 模板、schema、样例 |
| `scripts/` | 确定性执行 | Python、Bash、JavaScript 脚本 |
| `tests/` | 质量验证 | 测试输入、预期输出 |

```text
references 让 Agent 知道规则。
assets 让 Agent 套用模板。
scripts 让 Agent 执行动作。
tests 让 Agent 验证结果。
```

### 30.3 脚本命名规则

脚本名称应使用明确动作。

推荐：

```text
validate_markdown.py
clean_skill_content.py
extract_review_fields.py
convert_json_to_csv.py
check_frontmatter.py
normalize_file_names.py
```

不推荐：

```text
script.py
tool.py
test.py
final.py
new.py
helper.py
```

命名公式：

```text
动作 + 对象 + 可选范围
```

例如：

```text
validate_markdown_headings.py
clean_redundant_phrases.py
extract_amazon_review_themes.py
```

### 30.4 脚本输入输出设计

脚本应有清晰输入输出。

推荐写法：

```text
输入：文件路径或标准输入
输出：标准输出、生成文件或 JSON 报告
错误：返回非零退出码，并输出错误原因
```

示例：

```bash
python scripts/validate_markdown.py input.md
```

输出：

```json
{
  "status": "fail",
  "errors": [
    {
      "type": "heading_jump",
      "line": 24,
      "message": "Heading jumps from H2 to H4."
    }
  ]
}
```

### 30.5 脚本头部说明

每个脚本文件开头应写清楚用途。

Python 示例：

```python
#!/usr/bin/env python3
"""
validate_markdown.py

Purpose:
Validate Markdown files for heading structure, duplicate headings,
empty sections, and forbidden conversational phrases.

Usage:
python scripts/validate_markdown.py path/to/file.md

Output:
JSON report with status, warnings, and errors.
"""
```

这能帮助 Agent 和人类维护者快速理解脚本。

### 30.6 在 SKILL.md 中引用脚本

`SKILL.md` 中要说明什么时候运行哪个脚本，而不是简单列出脚本名称。

推荐写法：

```markdown
# Scripts

Use scripts only when relevant:

- Run `scripts/validate_markdown.py` when creating or modifying a Markdown knowledge-base file.
- Run `scripts/clean_redundant_phrases.py` when cleaning prompt or Skill instruction text.
- Run `scripts/check_frontmatter.py` before finalizing a `SKILL.md` file.
```

不推荐：

```markdown
There are some scripts in the scripts folder. Use them if needed.
```

问题：

- 没有触发条件
- Agent 不知道何时使用
- 容易不用或乱用

### 30.7 脚本依赖说明

如果脚本依赖第三方库，应明确说明。

推荐结构：

```text
scripts/
├── validate_markdown.py
├── clean_text.py
└── requirements.txt
```

`requirements.txt` 示例：

```text
pyyaml>=6.0
jsonschema>=4.0
```

如果能用标准库完成，就优先使用标准库。

原则：

```text
脚本依赖越少，Skill 越容易迁移。
```

### 30.8 脚本错误处理

脚本要明确区分：

| 类型 | 说明 |
|---|---|
| 成功 | 返回 `status: pass` 或退出码 0 |
| 警告 | 有问题但不阻止继续 |
| 失败 | 存在必须修复的问题 |
| 异常 | 文件不存在、格式错误、权限不足 |

推荐输出结构：

```json
{
  "status": "warning",
  "summary": "Markdown structure is usable but contains minor issues.",
  "warnings": [],
  "errors": []
}
```

### 30.9 脚本目录设计检查清单

```text
1. 脚本是否有明确用途？
2. 脚本名称是否表达动作和对象？
3. 输入输出是否清楚？
4. 是否能在命令行独立运行？
5. 是否有错误处理？
6. 是否尽量减少依赖？
7. 是否在 SKILL.md 中写明使用条件？
8. 是否避免把业务判断硬编码到脚本里？
9. 是否有测试样例？
10. 是否便于迁移到其他项目？
```

### 30.10 本章小结

`scripts/` 目录的目标不是堆代码，而是将确定性动作封装为可调用、可验证、可维护的小工具。

核心公式：

```text
脚本名称清晰
输入输出清晰
使用条件清晰
错误处理清晰
依赖关系清晰
```

---

## 第 31 章：脚本适用场景

### 31.1 脚本最适合的任务类型

脚本适合处理具有以下特征的任务：

```text
规则明确
输入明确
输出明确
执行可重复
结果可验证
```

典型任务包括：

- 文件转换
- 数据清洗
- 格式校验
- 批量处理
- 字段提取
- 结构检查
- 规则匹配
- 报告生成前预处理
- 输出结果后验证

### 31.2 文件转换

文件转换适合脚本处理。

示例：

| 输入 | 输出 |
|---|---|
| CSV | JSON |
| JSON | Markdown 表格 |
| Excel | CSV |
| Markdown | HTML |
| 多个 `.md` 文件 | 合并后的知识库索引 |

脚本示例：

```bash
python scripts/convert_json_to_markdown.py input.json output.md
```

Skill 中的 LLM 负责判断是否需要转换，脚本负责执行转换。

### 31.3 数据清洗

数据清洗通常需要稳定规则。

适合脚本处理的清洗动作包括：

- 去除空行
- 统一字段名
- 删除重复记录
- 修正常见编码问题
- 标准化日期格式
- 删除无效字符
- 去除 Markdown 多余空格

示例：

```bash
python scripts/clean_review_export.py reviews.csv cleaned_reviews.csv
```

### 31.4 格式校验

格式校验非常适合脚本。

常见校验：

| 文件类型 | 校验内容 |
|---|---|
| Markdown | 标题层级、空标题、重复标题 |
| JSON | schema、必填字段、数据类型 |
| CSV | 列数、列名、空值、重复行 |
| YAML | frontmatter 是否完整 |
| Skill | 是否包含 `name`、`description`、Purpose、Inputs、Process、Output |

示例：

```bash
python scripts/check_skill_structure.py SKILL.md
```

输出：

```text
PASS: name found
PASS: description found
WARN: no negative examples found
FAIL: no output format section found
```

### 31.5 批量处理

当任务涉及多个文件或大量数据时，应优先考虑脚本。

示例：

```text
批量清洗 50 个 Skill 文件
批量检查 100 个 Markdown 知识条目
批量从 Review CSV 中提取关键词
批量生成文件索引
```

脚本价值：

- 不漏项
- 可重复
- 可复跑
- 可记录日志

### 31.6 结构化提取

对于格式相对稳定的内容，脚本可以先提取结构，再交给 LLM 分析。

例如 Review 数据：

```text
脚本负责：
- 读取 CSV
- 提取 rating、title、body、date
- 删除重复评论
- 输出结构化 JSON

LLM 负责：
- 主题分类
- 痛点总结
- 购买动机推理
- 产品机会提炼
```

### 31.7 输出后验证

脚本不只可以在执行前使用，也可以在输出后使用。

例如：

```text
LLM 生成 Markdown 文件
→ 脚本检查标题层级
→ 脚本检查禁用词
→ 脚本检查空章节
→ LLM 根据报告修复
```

这能形成一个闭环：

```text
生成 → 校验 → 修复 → 再校验
```

### 31.8 适用场景总结

| 场景 | 是否适合脚本 | 原因 |
|---|---:|---|
| 统计评论数量 | 是 | 规则明确 |
| 检查 JSON 是否有效 | 是 | 可程序化 |
| 批量替换禁用词 | 是 | 可重复 |
| 判断文案是否有说服力 | 否 | 需要语义判断 |
| 提取用户隐藏需求 | 否 | 需要推理 |
| 判断设计风格是否高级 | 否 | 主观审美 |
| 校验 Markdown 标题层级 | 是 | 规则明确 |
| 生成创意广告标题 | 否 | 需要创意 |

### 31.9 本章小结

脚本适合做确定性任务，不适合做开放性判断。

核心公式：

```text
能用规则判断的，优先脚本。
需要语义理解的，优先模型。
```

---

## 第 32 章：脚本不适用场景

### 32.1 为什么要定义不适用场景

很多人理解脚本增强后，会走向另一个极端：

```text
把所有事情都写成脚本。
```

这会让 Skill 变得僵硬、难维护，也会削弱 LLM 的优势。

脚本不是智能体的大脑，而是稳定执行器。

### 32.2 主观判断不适合完全脚本化

以下任务不适合完全交给脚本：

- 判断文案是否打动用户
- 判断画面是否高级
- 判断一个产品卖点是否有传播力
- 判断用户真正意图
- 判断一段解释是否容易理解
- 判断课程内容是否符合费曼教学法

这些任务依赖语义、上下文和人类经验，脚本只能提供辅助信号。

### 32.3 创意表达不适合脚本化

创意任务通常不适合脚本生成最终内容。

例如：

```text
生成广告标题
设计 KV 创意
写儿童产品音效命名
构思 UI 风格方向
提出产品卖点表达
```

脚本可以辅助做：

- 长度检查
- 禁用词检查
- 重复表达检查
- 格式检查

但核心创意仍应由 LLM 生成。

### 32.4 复杂业务决策不适合脚本独立完成

例如：

```text
是否应该发货
是否应该做一个新功能
是否建议领导采用某个 UI 方案
是否判断某份协议可商用
```

这些任务需要综合：

- 业务目标
- 数据
- 风险
- 组织约束
- 证据强度
- 人类决策偏好

脚本可以参与计算，但不能单独替代判断。

### 32.5 高风险结论不应脚本化自动输出

高风险领域包括：

- 法律
- 医疗
- 财务
- 安全
- 合规
- 隐私
- 权限变更
- 删除数据
- 自动发送外部消息

在这些场景中，脚本可以做检查和辅助，但最终输出需要保留限制说明、证据边界和必要的人类确认。

### 32.6 频繁变化的规则不适合硬编码

如果规则经常变化，不适合直接写死在脚本里。

例如：

```text
平台广告政策
Amazon 类目合规规则
公司内部审批流程
产品参数表
品牌禁用词
```

更好的做法：

```text
规则放 references 或配置文件
脚本读取配置
不要把变化规则写死在代码里
```

示例结构：

```text
scripts/validate_claims.py
references/claim-rules.md
assets/claim-rules.json
```

### 32.7 脚本不适用的信号

如果任务具备以下特征，脚本化要谨慎：

| 信号 | 原因 |
|---|---|
| 没有明确规则 | 无法稳定编码 |
| 结果依赖语境 | 脚本不理解上下文 |
| 评价标准主观 | 难以自动判断 |
| 输入变化极大 | 维护成本高 |
| 需要权衡多个目标 | 应由模型或人判断 |
| 结论风险高 | 需要人类确认或限制说明 |

### 32.8 脚本滥用的后果

| 滥用方式 | 后果 |
|---|---|
| 把业务判断写死 | 结果僵化，无法适应变化 |
| 把复杂语义规则硬编码 | 误判多，维护困难 |
| 依赖太多第三方库 | 可迁移性下降 |
| 自动执行高风险动作 | 安全风险增加 |
| 缺少日志和错误处理 | 调试困难 |

### 32.9 脚本与模型的协作边界

推荐分工：

```text
脚本提供事实层信号：
- 数量
- 格式
- 重复
- 缺失
- 错误
- 规则匹配

模型进行解释层判断：
- 为什么重要
- 有什么风险
- 如何修正
- 哪个方案更合适
- 如何表达给用户
```

示例：

```text
脚本：发现 Markdown 中有 3 个空章节。
模型：解释这些空章节为什么影响知识库复用，并给出修复后的内容结构。
```

### 32.10 本章小结

脚本不适合取代模型的语义理解和业务判断。

核心结论：

```text
脚本负责确定性信号，
模型负责语义解释和决策辅助。
```

---

## 第 33 章：脚本与 Skill 指令协同

### 33.1 为什么需要协同设计

很多 Skill 虽然有 `scripts/`，但 Agent 不知道：

- 什么时候用脚本
- 脚本输入是什么
- 脚本输出怎么看
- 脚本失败怎么办
- 脚本结果如何进入最终回答

这会导致脚本存在但不被使用，或者被错误使用。

脚本必须通过 `SKILL.md` 纳入 Workflow。

### 33.2 SKILL.md 中脚本协同的必要内容

`SKILL.md` 至少应说明：

| 内容 | 作用 |
|---|---|
| 脚本名称 | Agent 知道可用脚本 |
| 使用条件 | 什么时候运行 |
| 输入格式 | 传什么参数 |
| 输出格式 | 如何读取结果 |
| 失败处理 | 脚本报错怎么办 |
| 后续动作 | 脚本结果如何影响输出 |

### 33.3 推荐结构

```markdown
# Scripts

Use scripts only when their conditions are met.

## `scripts/validate_markdown.py`

Use when:
- Creating or editing Markdown knowledge-base files.
- Checking generated `.md` output before final delivery.

Command:
```bash
python scripts/validate_markdown.py <file_path>

Expected output:
- JSON report with `status`, `warnings`, and `errors`.

If the script fails:
- Report the error briefly.
- Do not claim validation passed.
- Fix issues only when the error message is clear.
```

### 33.4 脚本调用时机

脚本可以在三个阶段使用：

| 阶段 | 作用 | 示例 |
|---|---|---|
| 前处理 | 清洗、转换、提取输入 | 清洗 Review CSV |
| 中处理 | 辅助分类、统计、规则检查 | 统计评论评分分布 |
| 后处理 | 校验输出、格式检查 | 检查 Markdown 结构 |

典型流程：

```text
用户输入
→ 脚本前处理
→ LLM 语义分析
→ 脚本后校验
→ LLM 修复并交付
```
### 33.5 示例：内容清洁 Skill 的脚本协同

Skill 目标：清理 Prompt 或 Skill 文件中的废话、重复表达、迎合性语言。

```

```markdown
# Scripts

## `scripts/detect_noise_phrases.py`

Use when:
- Cleaning long prompt files or `SKILL.md` files.
- The user asks to remove filler, flattery, repetition, or vague quality language.

Command:
```bash
python scripts/detect_noise_phrases.py <input_file>

Expected output:
- A list of suspected noise phrases.
- Line numbers.
- Suggested category: filler, flattery, repetition, vague-quality, role-play.

How to use the result:
- Do not delete automatically.
- Use the report as evidence.
- Preserve any phrase that carries operational meaning.
```

这里脚本只负责检测，模型负责判断是否删除。

### 33.6 示例：LLM Wiki Skill 的脚本协同

Skill 目标：生成知识库 Markdown 文件。

```markdown
# Scripts

## `scripts/validate_wiki_entry.py`

Use after generating a Markdown knowledge entry.

Command:
```bash
python scripts/validate_wiki_entry.py <file_path>

Checks:
- Title exists.
- Required sections exist.
- No forbidden conversational phrases.
- No empty required sections.
- Heading levels are valid.

If validation fails:
- Revise the Markdown file.
- Run the validation again if possible.
- Report remaining limitations.
```

### 33.7 脚本结果如何进入最终输出

脚本输出不应该原样全部塞进最终回答，除非用户需要。

```
推荐处理：

| 脚本结果 | 最终输出方式 |
|---|---|
| 全部通过 | 简短说明“已通过结构校验” |
| 有警告 | 列出关键警告和处理情况 |
| 有错误 | 说明错误、修复动作、剩余问题 |
| 脚本失败 | 说明脚本未能完成，不声称已验证 |
```
### 33.8 脚本失败处理

脚本失败并不等于任务失败，但不能假装成功。

失败处理模板：

```markdown
# 脚本失败处理

如果脚本无法运行：

- 说明无法完成基于脚本的验证或转换。
- 仅在安全的情况下，继续进行基于人工判断或 LLM 的最大努力处理。
- 不得声称已通过确定性的验证。
- 如果错误信息有助于调试，应保留该错误信息。
```
### 33.9 脚本安全边界

脚本可能带来安全风险，因此 Skill 必须写清限制。

常见风险：

- 删除文件
- 覆盖原文件
- 读取敏感路径
- 执行外部命令
- 访问网络
- 安装依赖
- 上传数据

安全策略：

```markdown
# 脚本安全

- 尽可能优先使用只读脚本。 
- 除非用户明确要求，否则不要删除或覆盖源文件。 
- 默认将输出写入新文件。 
- 除非用户明确要求且环境允许，否则不要访问网络资源。 
- 未经审查，不要运行来自不可信来源的脚本。
```

### 33.10 脚本协同检查清单

```text
1. SKILL.md 是否列出脚本用途？
2. 是否说明脚本什么时候运行？
3. 是否说明脚本输入参数？
4. 是否说明脚本输出格式？
5. 是否说明失败处理？
6. 是否说明脚本结果如何影响最终输出？
7. 是否区分自动修复和人工判断？
8. 是否避免危险文件操作？
9. 是否尽量默认不覆盖原文件？
10. 是否能形成“生成 → 校验 → 修复”的闭环？
```

### 33.11 本章小结

脚本只有被纳入 Skill Workflow，才真正构成 Skill 能力的一部分。

核心公式：

```text
脚本存在 ≠ 脚本可用
脚本可用 = 使用条件 + 输入输出 + 失败处理 + 安全边界 + 结果回流
```

---

## 阶段六总结

阶段六的核心结论：

1. **脚本增强解决确定性问题。**  
   LLM 适合理解、判断和表达；脚本适合计算、转换、校验和批处理。

2. **`scripts/` 是 Skill 的执行增强层。**  
   它不负责解释业务，而负责稳定执行可程序化动作。

3. **脚本设计必须有清晰输入输出。**  
   没有输入输出契约的脚本，很难被 Agent 正确调用。

4. **适合脚本化的任务通常规则明确。**  
   文件转换、数据清洗、格式校验、批量处理、字段提取、结构检查都适合脚本。

5. **不适合脚本化的任务通常需要语义判断。**  
   创意表达、用户意图、复杂业务决策、主观审美和高风险结论不能完全交给脚本。

6. **脚本必须写进 Skill Workflow。**  
   `SKILL.md` 要说明脚本的使用条件、命令、输入输出、失败处理、安全边界和结果回流方式。

7. **脚本安全必须前置设计。**  
   默认不覆盖源文件，不删除文件，不访问不必要路径，不运行不可信代码。

阶段六最重要的一句话：

> 脚本增强不是让 Skill 变得复杂，而是把 LLM 不擅长的确定性任务交给程序执行，让 Skill 的结果更稳定、更可验证、更可复现。

---

## 阶段六掌握检查

完成阶段六后，应能回答：

1. 为什么纯指令型 Skill 在确定性任务上不稳定？
2. 哪些任务适合交给脚本？
3. 哪些任务不适合脚本化？
4. `scripts/` 和 `references/`、`assets/` 的区别是什么？
5. 一个脚本应该如何设计输入输出？
6. 为什么脚本必须在 `SKILL.md` 中写明使用条件？
7. 脚本失败时 Skill 应该如何处理？
8. 脚本结果如何进入最终输出？
9. 如何避免脚本带来的安全风险？
10. 什么是“生成 → 校验 → 修复”的闭环？

---

## 可沉淀的最小方法论

```text
Skill 脚本增强七步法：

1. 找出任务中的确定性动作
2. 判断是否适合脚本化
3. 设计脚本名称、输入、输出、错误处理
4. 把脚本放入 scripts/ 目录
5. 在 SKILL.md 中写清使用条件和命令
6. 设计脚本失败处理与安全边界
7. 让脚本结果回流到最终输出或修复流程中
```

---

## 参考来源

- OpenAI Codex Skills：`https://developers.openai.com/codex/skills`
- OpenAI Skills Catalog / skill-creator：`https://github.com/openai/skills/blob/main/skills/.system/skill-creator/SKILL.md`
- Anthropic：Equipping agents for the real world with Agent Skills：`https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills`
- Agent Skills Open Standard：`https://agentskills.io/specification`
