# Terry Nexgaios GBrain Knowledge Base

这是 Terry / Nexgaios 的企业第二大脑知识库。Markdown 文件和 Git 仓库是知识资产的主版本；GBrain DB / Supabase 是运行层索引，不是主版本。

## 当前结构

```text
00 - raw/       原始材料层。保存网页剪藏、对话沉淀、研究资料、用户笔记和附件。
01 - wiki/      编译知识层。保存经过抽取、合并、校验后的可复用知识页面。
02 - schema/    规则层。保存目录规则、入口规则、编译规则、质量验收规则和变更日志。
```

## 工作流

1. 新知识先进入 `00 - raw/00 - inbox/`。
2. inbox 路由先检查、补全、修正 frontmatter，再分发到 `00 - raw/` 的领域目录。
3. raw 中满足编译条件的材料进入 `01 - wiki/`。
4. wiki 页面必须保留来源依据，并接受质量验收。
5. 第一版 GBrain 同步只同步 `01 - wiki/`。
6. GBrain DB / Supabase 清空或重建时，只处理运行层索引，不反向修改 Markdown 主版本。

## 同步策略

本仓库远端：

```text
https://github.com/terryxming/nexgaios-gbrain-kbase
```

GitHub 保存 Markdown 主版本。远端旧目录结构由普通 commit 替换，不重写 Git 历史；只有出现密钥、隐私或商业敏感内容泄漏时，才考虑清理历史。

## 本地排除

以下内容属于本地状态、编辑器配置或敏感信息，不进入 Git：

```text
.gbrain/
.obsidian/
.env
.env.*
*.pem
*.key
*secret*
*token*
*credential*
```
