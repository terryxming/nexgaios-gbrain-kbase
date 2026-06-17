# Git 远端与分支：Nexgaios GBrain 源码仓库说明

日期：2026-06-17

相关项目：Nexgaios GBrain

适用仓库：

```text
D:\nexgaios-gbrain-code
```

## 1. 背景问题

在 Nexgaios GBrain 架构设计中，源码仓库采用如下设计：

```text
origin   = https://github.com/terryxming/nexgaios-gbrain-code.git
upstream = https://github.com/garrytan/gbrain.git
默认分支 = nexgaios-saas
```

Terry 的疑问是：

1. `origin`、`upstream` 是什么？有什么用？怎么用？
2. 分支是什么？为什么源码仓库使用 `nexgaios-saas`？
3. 如果在 `nexgaios-saas` 分支上开发维护，那 `main` 怎么办？

## 2. origin 和 upstream 是什么

`origin` 和 `upstream` 都是 Git 里的远程仓库别名。

它们不是特殊魔法词，本质上只是远程 Git 地址的昵称。一个本地仓库可以同时连接多个远程仓库，每个远程仓库用一个名字区分。

在当前 GBrain 项目中：

```text
origin   = Nexgaios 自己的私有源码仓库
upstream = Garry Tan 原始 GBrain 开源仓库
```

也就是说：

1. `origin` 用来保存 Terry / Nexgaios 自己改造后的商业化版本。
2. `upstream` 用来保留原作者 Garry Tan 的开源版本来源。
3. 日常开发主要推送到 `origin`。
4. 后续如果原始 GBrain 有好功能，再从 `upstream` 选择性同步。

## 3. 生活化例子：菜谱原版和公司改良版

可以把 `upstream` 理解成一本公开出版的原版菜谱。

Garry Tan 原始 GBrain 仓库就像原作者出版的菜谱书。Nexgaios 先从这本菜谱学会基础做法，然后复制出一份自己的公司厨房手册。

这份公司厨房手册就是 `origin`。

接下来，Nexgaios 在自己的手册里加入公司专属做法：

1. SaaS 权限系统。
2. 权限管理后台。
3. 中文后台。
4. 成员、角色、分组、策略。
5. MCP Token 鉴权。
6. Nexgaios 自己的部署和使用方式。

这些改造不应该直接写回原作者的菜谱书，因为它们是 Nexgaios 自己的商业化版本。

所以：

```text
upstream = 原作者菜谱
origin   = Nexgaios 公司厨房手册
本地仓库 = Terry 当前电脑上的工作副本
```

## 4. origin 和 upstream 怎么用

查看当前远程仓库：

```powershell
git remote -v
```

从 Nexgaios 私有仓库拉取最新代码：

```powershell
git pull origin nexgaios-saas
```

把本地改动推送到 Nexgaios 私有仓库：

```powershell
git push origin nexgaios-saas
```

查看 Garry Tan 原始 GBrain 是否有更新：

```powershell
git fetch upstream
```

注意：`git fetch upstream` 只是把上游信息取回来，不会自动合并到 Nexgaios 代码里。

如果确认要合并上游主线，可以再评估：

```powershell
git merge upstream/master
```

如果只想挑选上游某一个具体提交，可以使用：

```powershell
git cherry-pick <commit-id>
```

实际工作中，不建议看到上游更新就立刻合并。更好的做法是先查看上游改了什么，再决定是否吸收。

## 5. 分支是什么

分支是 Git 里的独立开发路线。

同一个仓库可以有多条分支，每条分支可以承载不同方向的开发。

例如：

```text
master         原始开源项目主线
main           常见默认主分支名
nexgaios-saas  Nexgaios SaaS 商业化改造主线
feature/xxx    某个具体功能开发分支
```

分支的价值是：允许不同方向的工作并行存在，避免互相污染。

## 6. 为什么源码仓库使用 nexgaios-saas

Nexgaios 当前不是简单复制原始 GBrain，而是在原始 GBrain 基础上做商业化 SaaS 改造。

改造内容包括：

1. 权限后台。
2. MCP 鉴权。
3. 成员系统。
4. Token 管理。
5. 角色、分组、策略。
6. 请求日志和权限拒绝记录。
7. 面向企业第二大脑的产品化能力。

这些内容已经明显区别于原始开源项目。

因此，源码仓库使用 `nexgaios-saas` 作为主开发分支，目的是清楚表达：

```text
这是 Nexgaios 自己的 SaaS 商业化改造版本。
```

这样做有几个好处：

1. 避免把 Nexgaios 的商业化代码和上游 `master` 混在一起。
2. 让团队一眼知道当前工作主线是什么。
3. 后续同步上游时，可以清楚区分原版和商业改造版。
4. 部署时可以固定使用 `origin/nexgaios-saas`。

## 7. 生活化例子：主菜谱和公司版本

上游 `master` 像原作者的主菜谱。

`nexgaios-saas` 像 Nexgaios 自己的公司版菜谱。

公司版菜谱里可能加入了：

1. 适合公司厨房的流程。
2. 适合团队分工的权限。
3. 适合商业客户的标准。
4. 适合内部管理的记录方式。

这些内容对 Nexgaios 很重要，但不一定适合直接放回原作者的公开菜谱。

所以公司应该维护自己的主线：`nexgaios-saas`。

## 8. 那 main 怎么办

`main` 不是 Git 必须存在的东西。

`main` 只是一个常见默认分支名。Git 技术上并不要求每个仓库必须叫 `main`。

分支名可以是：

```text
main
master
nexgaios-saas
release
production
```

谁是主线，取决于仓库把哪个分支设为默认分支。

在当前项目里：

```text
源码仓库 D:\nexgaios-gbrain-code
主开发分支：nexgaios-saas
```

而知识库是：

```text
知识仓库 E:\nexgaios-gbrain-kbase
主分支：main
```

这是合理的，因为两个仓库职责不同。

源码仓库的 `nexgaios-saas` 就相当于它自己的 `main`，只是名字更准确。

## 9. 当前推荐工作方式

源码开发时：

```powershell
git -C D:\nexgaios-gbrain-code checkout nexgaios-saas
git -C D:\nexgaios-gbrain-code pull origin nexgaios-saas
```

完成修改后：

```powershell
git -C D:\nexgaios-gbrain-code status --short
git -C D:\nexgaios-gbrain-code add .
git -C D:\nexgaios-gbrain-code commit -m "描述本次修改"
git -C D:\nexgaios-gbrain-code push origin nexgaios-saas
```

如果要开发一个较大的新功能，可以从 `nexgaios-saas` 拉出临时功能分支：

```powershell
git -C D:\nexgaios-gbrain-code checkout nexgaios-saas
git -C D:\nexgaios-gbrain-code checkout -b feature/device-token-management
```

开发完成后再合回 `nexgaios-saas`：

```powershell
git -C D:\nexgaios-gbrain-code checkout nexgaios-saas
git -C D:\nexgaios-gbrain-code merge feature/device-token-management
git -C D:\nexgaios-gbrain-code push origin nexgaios-saas
```

## 10. 最终结论

当前 Nexgaios GBrain 源码仓库的 Git 设计可以总结为：

```text
origin   保存 Nexgaios 自己的商业化改造版本
upstream 保留 Garry Tan 原始 GBrain 的更新来源
nexgaios-saas 作为 Nexgaios SaaS 改造主线
```

日常开发主要维护：

```text
origin/nexgaios-saas
```

上游同步时参考：

```text
upstream/master
```

知识库继续使用：

```text
main
```

一句话理解：

```text
源码仓库里，nexgaios-saas 就是 Nexgaios 的 main。
只是它没有叫 main，而是用更准确的名字说明它是 Nexgaios 的 SaaS 改造主线。
```
