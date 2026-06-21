---
title: '《inbox 新笔记模板》模板代码解释'
status: raw
created: '2026-06-11 19:14'
source_type: unknown
material_type: 模板
domain_hint: '产品'
compile_status: 未编译
tags:
  - 'obsidian'
---

# 《inbox 新笔记模板》代码解释   
## 1. 这段代码解决什么问题

这是一段 Obsidian 第三方插件 **Templater** 的模板脚本，用于在新建笔记时自动完成以下动作：

1. 弹窗输入笔记标题；
2. 弹窗输入笔记类型 `type`；
3. 弹窗输入来源 `source`；
4. 弹窗输入标签 `tags`；
5. 自动生成创建时间 `created`；
6. 自动把文件名改成输入的标题；
7. 自动生成 YAML frontmatter 属性；
8. 自动生成正文写作结构。

它的核心作用是：

> 把“新建空白笔记”变成“带属性、带结构、带标题命名规则的标准化笔记”。

---

## 2. 代码整体结构

Templater 的脚本块格式是：

```javascript

<%*  
let title = await tp.system.prompt("请输入笔记标题", tp.file.title);

if (!title || title.trim() === "") {  
title = tp.file.title;  
}

title = title.trim();

let type = await tp.system.prompt("请输入类型 type，例如 concept / idea / project / personal / writing，可留空", "");  
let source = await tp.system.prompt("请输入来源 source，可留空", "");  
let tagsInput = await tp.system.prompt("请输入标签 tags，用英文逗号分隔，可留空", "");

let status = "inbox";  
let created = tp.date.now("YYYY-MM-DDTHH:mm:ss");

let fileName = title.replace(/[\/:*?"<>|]/g, "-");

let tags = [];

if (tagsInput && tagsInput.trim() !== "") {  
tags = tagsInput  
.split(",")  
.map(tag => tag.trim().replace(/^#/, ""))  
.filter(tag => tag !== "");  
}

await tp.file.rename(fileName);

function yamlString(value) {  
return JSON.stringify(value || "");  
}

let tagsYaml = "tags: []";

if (tags.length > 0) {  
tagsYaml = "tags:\n" + tags.map(tag => " - " + tag).join("\n");  
}

tR += "---\n";  
tR += "title: " + yamlString(title) + "\n";  
tR += "type: " + yamlString(type) + "\n";  
tR += "created: " + yamlString(created) + "\n";  
tR += "updated:\n";  
tR += tagsYaml + "\n";  
tR += "status: " + yamlString(status) + "\n";  
tR += "source: " + yamlString(source) + "\n";  
tR += "---\n\n";

tR += "# " + title + "\n\n";

tR += "## 原文\n\n";  
tR += "> 粘贴那段启发你的内容，或简单描述发生了什么。\n\n";

tR += "## 我的理解\n\n";  
tR += "这让我意识到什么？\n\n";

tR += "## 用处\n\n";  
tR += "它可能用于：concept / idea / project / personal / writing\n\n";

tR += "## 下一步\n\n";  
tR += "要不要行动？要不要合并到某个主题？\n";  
%>

```

其中：
```js
<%* 表示开始执行一段 JavaScript 脚本。
%> 表示脚本结束。
```

在这个代码块内部，不能直接写普通 Markdown，例如：

```md
# 标题
## 原文
```

如果要输出 Markdown 内容，需要通过：

```js
tR += "要输出的内容";
```

把内容写入最终笔记。

---

## 3. 用户输入部分

### 3.1 输入笔记标题

```js
let title = await tp.system.prompt("请输入笔记标题", tp.file.title);
```

含义：

- 弹出一个输入框；
    
- 提示用户输入笔记标题；
    
- 默认值是当前文件名；
    
- 输入结果保存到变量 `title`。
    

其中：

```js
tp.system.prompt()
```

是 Templater 的弹窗输入函数。

```js
tp.file.title
```

代表当前笔记的文件名，不包含 `.md` 后缀。

---

### 3.2 如果标题为空，则使用当前文件名

```js
if (!title || title.trim() === "") {
title = tp.file.title;
}
```

含义：

如果用户没有输入标题，或者只输入了空格，就使用当前文件名作为标题。

其中：

```js
title.trim()
```

表示去掉标题前后的空格。

---

### 3.3 清理标题前后空格

```js
title = title.trim();
```

含义：

无论用户输入什么标题，都先去掉前后多余空格。

例如：

```text
  专家模式  
```

会变成：

```text
专家模式
```

---

### 3.4 输入 type、source、tags

```js
let type = await tp.system.prompt("请输入类型 type，例如 concept / idea / project / personal / writing，可留空", "");
let source = await tp.system.prompt("请输入来源 source，可留空", "");
let tagsInput = await tp.system.prompt("请输入标签 tags，用英文逗号分隔，可留空", "");
```

含义：

新建笔记时，会依次弹出 3 个输入框：

|输入项|写入属性|示例|
|---|---|---|
|类型|`type`|`concept`|
|来源|`source`|`ChatGPT`|
|标签|`tags`|`obsidian,templater,note`|

其中标签要求用英文逗号分隔：

```text
obsidian,templater,note
```

---

## 4. 固定属性和时间生成

### 4.1 固定状态为 inbox

```js
let status = "inbox";
```

含义：

所有通过这个模板新建的笔记，默认状态都是：

```yaml
status: raw
```

适合用于收集箱笔记。

---

### 4.2 自动生成创建时间

```js
let created = tp.date.now("YYYY-MM-DDTHH:mm:ss");
```

含义：

自动生成当前时间，格式为：

```text
2026-06-11 17:04
```

其中：

```js
tp.date.now()
```

是 Templater 的日期函数。

---

## 5. 文件名处理

```js
let fileName = title.replace(/[\/:*?"<>|]/g, "-");
```

含义：

把标题中不能作为文件名的特殊字符替换成 `-`。

例如：

```text
LLM / Agent: 工作流
```

会变成：

```text
LLM - Agent- 工作流
```

这一步是为了避免 Windows 文件名非法字符导致重命名失败。

### 注意

当前这行代码没有处理反斜杠：

```text
\
```

更稳妥的写法是：

```js
let fileName = title.replace(/[\\/:*?"<>|]/g, "-");
```

建议使用这一版，因为 Windows 文件名中反斜杠也是非法字符。

---

## 6. tags 标签处理

### 6.1 初始化空标签数组

```js
let tags = [];
```

含义：

先创建一个空数组，用来保存用户输入的标签。

---

### 6.2 如果用户输入了标签，则拆分处理

```js
if (tagsInput && tagsInput.trim() !== "") {
tags = tagsInput
.split(",")
.map(tag => tag.trim().replace(/^#/, ""))
.filter(tag => tag !== "");
}
```

这段逻辑的作用是把用户输入的标签字符串转换成 YAML 能识别的标签列表。

例如用户输入：

```text
#obsidian, templater, note
```

会被处理成：

```yaml
tags:
  - obsidian
  - templater
  - note
```

逐行解释：

```js
tagsInput && tagsInput.trim() !== ""
```

判断用户是否真的输入了标签。

```js
.split(",")
```

按英文逗号拆分标签。

```js
.map(tag => tag.trim().replace(/^#/, ""))
```

对每个标签做清理：

- 去掉前后空格；
    
- 去掉开头的 `#`。
    

```js
.filter(tag => tag !== "")
```

过滤掉空标签。

---

## 7. 自动重命名文件

```js
await tp.file.rename(fileName);
```

含义：

把当前笔记文件名改成用户输入的标题。

例如用户输入：

```text
专家模式
```

文件名会变成：

```text
专家模式.md
```

注意：

这是一次性动作。  
如果之后手动修改标题或文件名，模板不会自动同步更新。

---

## 8. YAML 字符串安全处理

```js
function yamlString(value) {
return JSON.stringify(value || "");
}
```

含义：

把输入内容转换成安全的 YAML 字符串。

例如：

```js
yamlString("ChatGPT")
```

会输出：

```yaml
"ChatGPT"
```

这样可以避免一些特殊字符破坏 YAML 结构。

例如标题中包含冒号：

```text
Agent: 工作流
```

如果不加引号，YAML 可能解析异常。

---

## 9. tags YAML 生成

### 9.1 默认没有标签

```js
let tagsYaml = "tags: []";
```

含义：

如果用户不输入标签，frontmatter 会生成：

```yaml
tags: []
```

表示标签为空。

---

### 9.2 如果有标签，则生成列表格式

```js
if (tags.length > 0) {
tagsYaml = "tags:\n" + tags.map(tag => "  - " + tag).join("\n");
}
```

含义：

如果用户输入了标签，则生成 YAML 列表。

例如：

```text
obsidian,templater,note
```

会生成：

```yaml
tags:
  - obsidian
  - templater
  - note
```

---

## 10. frontmatter 输出部分

```js
tR += "---\n";
tR += "title: " + yamlString(title) + "\n";
tR += "type: " + yamlString(type) + "\n";
tR += "created: " + yamlString(created) + "\n";
tR += "updated:\n";
tR += tagsYaml + "\n";
tR += "status: " + yamlString(status) + "\n";
tR += "source: " + yamlString(source) + "\n";
tR += "---\n\n";
```

这段代码用于生成 Obsidian 的笔记属性，也就是 YAML frontmatter。

生成结果示例：

```yaml
---
title: "专家模式"
type: "concept"
created: "2026-06-11 17:04"
updated:
tags:
  - obsidian
  - templater
status: raw
source: "ChatGPT"
---
```

其中：

|属性|含义|
|---|---|
|`title`|笔记标题|
|`type`|笔记类型|
|`created`|创建时间|
|`updated`|更新时间，当前留空|
|`tags`|标签|
|`status`|笔记状态|
|`source`|来源|

---

## 11. 正文标题输出

```js
tR += "# " + title + "\n\n";
```

含义：

在正文中生成一个一级标题。

例如：

```md
# 专家模式
```

如果不想在正文里出现标题，可以删除这一行。

删除后，笔记会直接从下面的正文结构开始。

---

## 12. 正文结构输出

```js
tR += "## 原文\n\n";
tR += "> 粘贴那段启发你的内容，或简单描述发生了什么。\n\n";

tR += "## 我的理解\n\n";
tR += "这让我意识到什么？\n\n";

tR += "## 用处\n\n";
tR += "它可能用于：concept / idea / project / personal / writing\n\n";

tR += "## 下一步\n\n";
tR += "要不要行动？要不要合并到某个主题？\n";
```

这部分用于生成笔记正文框架。

最终效果是：

```md
## 原文

> 粘贴那段启发你的内容，或简单描述发生了什么。

## 我的理解

这让我意识到什么？

## 用处

它可能用于：concept / idea / project / personal / writing

## 下一步

要不要行动？要不要合并到某个主题？
```

这个结构适合用于 Inbox 收集型笔记，帮助你快速记录：

1. 原始信息；
    
2. 自己的理解；
    
3. 可能用途；
    
4. 下一步动作。
    

---

## 13. 这段代码的执行流程

完整流程如下：

```text
新建笔记
↓
Templater 自动触发
↓
弹窗输入标题
↓
弹窗输入 type
↓
弹窗输入 source
↓
弹窗输入 tags
↓
生成 created 时间
↓
清洗文件名非法字符
↓
重命名文件
↓
生成 YAML frontmatter
↓
生成正文写作结构
```

---

## 14. 输入与输出示例

### 输入

标题：

```text
专家模式
```

type：

```text
concept
```

source：

```text
ChatGPT
```

tags：

```text
obsidian,templater,note
```

### 输出

```md
---
title: "专家模式"
type: "concept"
created: "2026-06-11 17:04"
updated:
tags:
  - obsidian
  - templater
  - note
status: raw
source: "ChatGPT"
---

# 专家模式

## 原文

> 粘贴那段启发你的内容，或简单描述发生了什么。

## 我的理解

这让我意识到什么？

## 用处

它可能用于：concept / idea / project / personal / writing

## 下一步

要不要行动？要不要合并到某个主题？
```

---

## 15. 常见修改方式

### 15.1 删除 updated 属性

删除这一行：

```js
tR += "updated:\n";
```

---

### 15.2 删除 tags 属性

需要删除三部分：

第一，删除 tags 输入：

```js
let tagsInput = await tp.system.prompt("请输入标签 tags，用英文逗号分隔，可留空", "");
```

第二，删除 tags 处理逻辑：

```js
let tags = [];

if (tagsInput && tagsInput.trim() !== "") {
tags = tagsInput
.split(",")
.map(tag => tag.trim().replace(/^#/, ""))
.filter(tag => tag !== "");
}
```

第三，删除 tagsYaml 输出：

```js
let tagsYaml = "tags: []";

if (tags.length > 0) {
tagsYaml = "tags:\n" + tags.map(tag => "  - " + tag).join("\n");
}

tR += tagsYaml + "\n";
```

---

### 15.3 删除正文里的一级标题

删除这一行：

```js
tR += "# " + title + "\n\n";
```

删除后，正文会直接从：

```md
## 原文
```

开始。

---

### 15.4 修改默认 status

当前代码是：

```js
let status = "inbox";
```

如果要改成草稿状态，可以改成：

```js
let status = "draft";
```

如果要改成待处理，可以改成：

```js
let status = "todo";
```

---

### 15.5 修改 created 时间格式

当前格式是：

```js
let created = tp.date.now("YYYY-MM-DDTHH:mm:ss");
```

输出示例：

```text
2026-06-11 17:04
```

如果只想要日期，可以改成：

```js
let created = tp.date.now("YYYY-MM-DD");
```

输出示例：

```text
2026-06-11
```

---

## 16. 这段代码的关键概念

|概念|含义|
|---|---|
|`tp.system.prompt()`|弹窗输入|
|`tp.file.title`|当前文件名|
|`tp.date.now()`|当前日期时间|
|`tp.file.rename()`|重命名当前文件|
|`tR +=`|向最终笔记输出内容|
|`YAML frontmatter`|Obsidian 笔记顶部的属性区|
|`tagsYaml`|把标签数组转换成 YAML 标签格式|
|`JSON.stringify()`|把内容转换成安全的带引号字符串|

---

## 17. 容易出错的地方

### 17.1 在 `<%* ... %>` 中直接写 Markdown

错误写法：

```md
<%*
# 标题
## 原文
%>
```

正确写法：

```js
<%*
tR += "# 标题\n\n";
tR += "## 原文\n\n";
%>
```

---

### 17.2 忘记用 `tR +=` 输出内容

在 Templater 脚本块中，普通字符串不会自动写入笔记。

必须使用：

```js
tR += "内容";
```

---

### 17.3 文件名包含非法字符

如果标题中包含：

```text
\ / : * ? " < > |
```

可能导致文件重命名失败。

建议使用：

```js
let fileName = title.replace(/[\\/:*?"<>|]/g, "-");
```

---

### 17.4 模板只在新建时执行一次

Templater 模板不是动态绑定。

如果模板执行后，你再修改文件名，已经生成的：

```yaml
title: "原标题"
```

不会自动更新。

---

## 18. 一句话总结

这段 Templater 脚本的本质是：

> 通过弹窗收集笔记元信息，然后自动重命名文件，并生成标准化的 Obsidian frontmatter 与正文写作结构。
