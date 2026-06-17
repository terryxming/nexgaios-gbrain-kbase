# NexGaios GBrain 权限系统交接文档

日期：2026-06-11

本文用于把当前 GBrain 权限系统的商业化 SaaS 设计、已落地状态、剩余工作交接给后续知识库内容建设阶段。本文不包含任何明文 Token、密码或一次性登录链接。

## 1. 目标：成熟商业 SaaS 权限系统的最终形态

最终目标是把 GBrain 从“单人或小团队可用的 LLM wiki 知识库”升级为“公司级、可审计、可运营、可商业化交付的 SaaS 权限系统”。

成熟形态应具备以下能力：

1. 租户隔离：不同公司、不同工作区、不同知识源之间天然隔离。
2. 身份治理：成员、分组、角色、设备、Token、后台会话都可被统一管理。
3. 最小权限：默认只给必要权限，读写权限按目录、source、工具动作拆开。
4. 可解释授权：管理员能看到某个成员为什么能访问、为什么被拒绝、权限来自哪个角色或策略。
5. 自助接入：成员可以通过邀请/首次设置密码/忘记密码流程进入后台或配置 MCP，而不是依赖人工发临时密码。
6. 设备级 Token：同一成员可为公司电脑、家里电脑、不同客户端分别配置 Token，支持过期、轮换、吊销。
7. 审计与告警：登录失败、权限拒绝、Token 过期、凭证变更、策略变更都进入审计，并形成安全摘要。
8. 管理后台产品化：Terry 作为 CEO/Owner 拥有最高且完整权限，管理员可以在中文后台里完成成员和权限运维。
9. 内容同步闭环：GitHub、本地 Markdown、移动硬盘知识库与 GBrain 页面能够稳定同步，并受同一套权限体系保护。
10. 商业交付能力：未来可继续扩展 SSO、SCIM、MFA、邮件通知、审批流、合规报表、租户级套餐限制和组织级审计导出。

## 2. 现在的权限系统方案

当前采用“租户/工作区/source + 成员/分组/角色/策略 + 设备 Token + 审计事件”的 SaaS 权限模型。

核心对象如下：

1. Tenant：公司级租户，目前为 `nexgaios`。
2. Workspace：公司知识库工作区，目前为 `company-brain`。
3. Source：知识源，目前按公司层级统一为 `nexgaios`，目录层级在页面 slug 内表达，例如 `aiwork/**`、`amazon/**`、`product/**`。
4. User：真实人员账号，例如 Terry、毛香明、测试 viewer/editor。
5. Membership：用户在租户内的成员身份，承载 owner/status 等组织关系。
6. Group：运营分组，例如 owners、admins、viewers、editors-aiwork。
7. Role：系统角色，例如 tenant_owner、brain_owner、security_admin、auditor、viewer、editor。
8. Resource Policy：资源策略，用于表达某个成员或分组对某类资源的 allow/deny。
9. Access Token：MCP 设备 Token，绑定成员、source、设备标签、客户端类型和生命周期。
10. Audit Event：审计事件，记录登录、授权、权限变更、Token 变更、密码变更等。

为什么采用这个方案：

1. 角色解决“人是什么身份”的问题，例如 Terry 是 owner，管理员是 security_admin，普通成员是 viewer/editor。
2. 分组解决“批量管理”的问题，例如把某个部门或领域编辑放入 editors-aiwork 后，后续只改分组或策略即可。
3. 策略解决“能访问什么资源”的问题，例如允许 AI Work 编辑组写 `nexgaios:aiwork/**`，但不允许写 Amazon 目录。
4. 设备 Token 解决“同一个人多台电脑/多个客户端”的问题，例如 Terry 公司电脑和家里电脑可以各自有 Token，任一设备丢失时只吊销对应 Token。
5. 审计事件解决“事后可追溯”的问题，能够看到谁在什么时候做了什么、为什么被允许或拒绝。
6. Effective Permissions 解决“权限看不懂”的问题，后台能解释某个成员的权限来自直接身份、分组、角色还是策略。

解决的问题：

1. 不再用一个全局共享 Token 给全团队使用，降低泄漏后的影响范围。
2. 不再把 source 误当成部门拆散；source 保持公司知识库层级，部门/领域通过目录和策略表达。
3. Terry 可以保留最高权限，同时团队成员只拿到自己需要的读写权限。
4. viewer/editor/admin 的边界可以通过真实 MCP 调用验证，而不是停留在文档设计。
5. 管理后台可以承担日常权限运营，而不是每次都 SSH 到服务器手动改数据库。

对 Terry 的价值：

1. Terry 作为公司 CEO/Owner，拥有完整控制权和最终兜底能力。
2. Terry 可以在公司电脑和家里电脑分别接入 MCP，不需要共享同一个设备凭证。
3. 团队成员接入时可以按人、按设备、按目录给权限，便于快速小范围试点。
4. 后续知识库内容扩大后，可以先用权限边界保护内容质量和公司信息安全。
5. 管理后台变成可交接的产品能力，后续管理员可以替 Terry 分担成员和 Token 运维。

## 3. 当前形态

当前线上服务形态：

1. 管理后台：`https://gbrain.nexgaios.com/admin/`
2. MCP 入口：`https://gbrain.nexgaios.com/mcp`
3. 部署位置：AWS EC2，region `us-west-2`，服务由 `gbrain.service` 托管。
4. 当前监听：服务器本机 `127.0.0.1:3131`，公网由反向代理暴露为 HTTPS。
5. 当前主租户：`nexgaios`
6. 当前主工作区：`company-brain`
7. 当前主 source：`nexgaios`

当前数据流：

1. Terry 或管理员在后台创建成员、分配分组/角色/策略。
2. 后台为成员生成设备级 MCP Token。
3. 成员在 Codex Desktop / Claude / Cursor 等客户端配置 `URL + Bearer Token`。
4. 客户端调用 `/mcp`，服务端先校验 Token 是否有效、是否过期、是否被吊销。
5. 服务端解析 Token 上绑定的 SaaS principal，得到成员身份和 source。
6. 每个 MCP tool call 会经过授权判断：资源策略优先，其次角色权限。
7. 授权结果写入 audit_events。
8. 后台安全告警读取 audit_events 和 Token 生命周期，展示风险摘要和处理建议。

当前资源依赖：

1. Postgres/Supabase：保存页面、成员、权限、Token、审计事件等核心数据。
2. AWS EC2：运行 GBrain HTTP MCP 服务。
3. systemd：托管 `gbrain.service`。
4. Caddy/反向代理：提供 `https://gbrain.nexgaios.com` 公网访问。
5. GitHub：承载公司 Markdown 知识库仓库。
6. 移动硬盘本地目录：Terry 本地维护 Markdown 内容的工作区。
7. Codex Desktop：Terry 和团队成员通过自定义 MCP 连接 GBrain。

当前后台能力：

1. 中文权限管理后台。
2. 深色/浅色模式切换。
3. 成员列表、Token 数、拒绝次数、最近授权可见。
4. 分组 / 角色 / 策略编辑器。
5. 成员停用、恢复、软删除。
6. 设备 Token 创建、轮换、吊销。
7. 管理员重置密码。
8. 一次性设置密码链接。
9. Effective Permissions 有效权限解释视图。
10. 授权审计与安全告警。

## 4. 已完成的部分

已完成的权限基础：

1. 建立 SaaS 权限数据模型：users、memberships、groups、roles、role_permissions、role_assignments、resource_policies、credentials、audit_events、user_password_credentials。
2. 建立 NexGaios 当前租户、工作区、source 和基础角色/分组。
3. Terry 已是 owner，具备最高且完整权限。
4. 已验证 viewer-test 只读访问。
5. 已验证 aiwork-editor-test 可维护 AI Work，不能写 Amazon。
6. 已创建毛香明 `mxm@nexgaios.com` 为管理员组成员。
7. 已清理旧 smoke token 和旧非 SaaS token。

已完成的后台产品化：

1. 后台中文化，并采用语言包维护中文文案。
2. 后台支持深色/浅色模式。
3. 最小字号已统一为 14px。
4. 后台账号密码登录已落地。
5. 支持前端修改密码，密码规则为至少 8 位，可使用数字、字母和符号。
6. 保留 bootstrap/magic link 作为应急入口。

已完成的 1-4 实施项：

1. Effective Permissions 可解释视图：
   - 新增 `/admin/api/permissions/members/:membershipId/effective`
   - 后台成员详情可点击“查看有效权限”
   - 展示成员身份来源、分组、角色授权、策略授权、可写目录、有效 Token 数、是否已设密码、最近授权决策

2. 邀请 / 首次设置密码 / 忘记密码基础闭环：
   - 管理员可为成员生成一次性设置密码链接
   - 成员打开带 `setup_token` 的后台链接后可设置新密码
   - 设置成功后一次性 token 立即失效并写审计
   - 登录页提供“忘记密码”入口；当前无邮件服务，所以先记录请求并提示联系管理员生成一次性链接

3. Token 过期、轮换、设备管理：
   - 新创建设备 Token 默认 180 天有效
   - 支持 1-730 天有效期
   - 支持 owner break-glass 场景选择永不过期
   - Token 权限 JSON 中记录 `token_lifecycle`
   - MCP 鉴权会拒绝已过期 Token
   - 轮换 Token 时刷新生命周期，避免复制旧过期时间
   - 后台成员详情展示 Token 到期状态

4. 审计告警和安全摘要：
   - 告警包含权限拒绝、后台登录失败、凭证变更、权限变更、成员状态变更、长期未使用 Token
   - 新增 Token 即将过期告警
   - 新增 Token 已过期但未吊销告警
   - 告警面板显示处理建议

已完成的生产验证：

1. 本地针对测试通过：`test/admin-permissions-api.test.ts`、`test/admin-password-auth.test.ts`、`test/provision-saas-member-args.test.ts`
2. 后台构建通过：`bun run build:admin`
3. TypeScript 全量检查通过：`bun run typecheck`
4. 线上服务重启成功，`/health` 返回 ok
5. 线上后台静态资源已更新到 `index--fKtp7eS.js`
6. 线上管理员登录、成员列表、Effective Permissions、告警 API 已验收
7. 线上短期测试 Token 创建后已立即吊销
8. 无效 setup token 返回 401，说明一次性设置密码入口不是开放绕过

## 5. 未完成的部分

距离成熟商业 SaaS 最终形态仍未完成：

1. 邮件发送系统：
   - 当前忘记密码只记录请求，不会自动发邮件。
   - 后续需要接入 SES、Resend、Postmark 或企业邮箱服务。

2. 邀请邮件和成员首次登录体验：
   - 当前管理员可以生成一次性链接，但需要人工复制给成员。
   - 后续应支持后台点击“邀请”后自动发送邮件。

3. MFA/二次验证：
   - 当前后台只有密码登录和应急入口。
   - 商业 SaaS 建议支持 TOTP、Passkey 或短信/邮箱二次验证。

4. SSO/SCIM：
   - 当前成员由后台或脚本创建。
   - 企业级交付需要支持 Google Workspace、Microsoft Entra ID、Okta 等 SSO/SCIM。

5. 审批流：
   - 当前管理员可直接改权限。
   - 商业化可增加“申请访问 -> 审批 -> 自动授权 -> 到期回收”的流程。

6. 更细粒度数据权限：
   - 当前主要按 source/目录前缀/页面动作控制。
   - 未来可扩展到字段级、标签级、敏感级别、项目级隔离。

7. Token 自助管理：
   - 当前 Token 由管理员后台管理。
   - 后续可让成员在自己的账号安全页查看自己的设备、轮换自己的 Token、吊销丢失设备。

8. 审计导出和合规报表：
   - 当前后台可查看审计和告警。
   - 后续需要 CSV/JSON 导出、按人/按资源/按时间范围生成报表。

9. 告警通知：
   - 当前告警只在后台展示。
   - 后续可接入 Slack、飞书、邮件或短信，把高风险事件主动推送给 Terry/管理员。

10. 权限策略版本管理：
   - 当前策略变更写审计，但没有策略版本 diff 和一键回滚。
   - 后续可增加策略快照、变更对比、回滚能力。

11. 租户级商业套餐限制：
   - 当前只有 NexGaios 单租户生产形态。
   - 真正商业 SaaS 需要套餐、额度、计费、租户配置、功能开关。

12. GitHub / 本地 Markdown / GBrain 内容同步产品化：
   - 当前权限系统已经能保护 MCP 写入。
   - 下一阶段重点应转向知识库内容层：统一 Markdown 目录、GitHub repo、移动硬盘本地目录和 GBrain 页面同步闭环。

## 后续建议

权限系统当前已经达到“小团队 MCP 接入 + 管理后台运营 + 基础商业化权限模型”的可用状态。下一阶段建议把重心切换到知识库内容：

1. 先确定 `terry-nexgaios-gbrain` 的 Markdown 目录规范。
2. 建立本地 Markdown -> GitHub -> GBrain 的同步规则。
3. 为 AI Work、Amazon、Product 等目录定义内容模板。
4. 用现有权限系统保护不同成员对不同目录的写入边界。
5. 等内容规模扩大后，再回头补邮件、MFA、SSO、审批流和合规报表。
