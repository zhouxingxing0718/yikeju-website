# 易客居民宿品牌宣传网站（第一版）

## 包含内容
- `index.html`：高端简约风格品牌宣传页、空间展示、房东合作意向表单。
- `admin.html`：管理员登录、查看意向、搜索筛选、更新跟进状态和内部备注。
- `schema.sql`：Supabase 数据表和行级安全策略。
- 网站默认使用易客居作为演示品牌名，可在代码里修改；可将 Logo 图片放入 `assets/logo.png` 并配置路径。

## 重要安全提醒
1. `index.html` 和 `admin.html` 里只填 Supabase 项目 URL 和 publishable/anon key。
2. **绝对不要把 `service_role` / secret key 放到网页代码里。**
3. 在 Supabase Auth 中关闭公开注册；只手动创建自己的管理员账号。
4. `schema.sql` 中管理员 UUID 占位符必须换成真实管理员 UID，否则后台读写会被拒绝。不要把真实 UID 发给别人。
5. 上线前请在无敏感测试数据的情况下测试：访客可提交表单；访客无法读取列表；未授权账号无法登录查看；管理员可查看并更新状态。
6. 表单会处理姓名、电话等个人信息。请在正式上线前完善隐私说明、联系渠道和数据删除流程，并遵守当地适用的个人信息保护及网站合规要求。
7. 静态网页的防刷能力有限；正式运营建议增加验证码/限流、备份和异常监控。

## 一、创建 Supabase 项目
1. 打开 https://supabase.com/ 并创建项目。
2. 进入项目的 Project Settings / API（或 Connect 页面），复制 Project URL 和 publishable/anon key。
3. 进入 SQL Editor，打开本项目 `schema.sql`，先执行建表、权限和访客提交策略部分。
4. 在 Authentication -> Users 中手动添加管理员用户，设置你自己的邮箱和强密码。不要开启公开注册。
5. 复制该管理员用户的 UID。
6. 回到 SQL Editor，把 schema.sql 中两处 `REPLACE_WITH_ADMIN_USER_UUID` 替换成真实 UID，再执行最后两段管理员策略。也可以将占位符替换后一次性执行整份 SQL。
7. 在 `index.html` 和 `admin.html` 中，把 `YOUR_SUPABASE_URL` 替换成 Project URL，把 `YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY` 替换成 publishable/anon key。两个文件必须使用同一个项目。
8. 在 `index.html` 中将 `BRAND_NAME` 改为你的品牌名；如果有 Logo，上传到 `assets/logo.png` 并将 `LOGO_PATH` 改成 `assets/logo.png`。

## 二、本地预览
最简单：用浏览器打开 `index.html`。若浏览器限制脚本或表单行为，建议用 VS Code 的 Live Server 插件，或 Python 本地 HTTP 服务：
`python -m http.server 8000`
然后访问 `http://localhost:8000`。在该目录启动命令。

## 三、部署到 Cloudflare Pages
建议用 GitHub 集成，方便以后更新：
1. 创建 GitHub 仓库，把这几个文件上传（不要上传密码或 service_role key）。
2. 登录 https://dash.cloudflare.com/ ，进入 Workers & Pages。
3. 创建 Pages 项目并连接 GitHub 仓库。
4. 如果是纯 HTML 项目，Build command 可留空或使用 `exit 0`；输出目录填写仓库根目录（通常是 `/` 或 `.`，按平台界面要求填写）。
5. 部署后使用 Cloudflare 提供的 `*.pages.dev` 地址访问。
6. `admin.html` 的后台地址是 `https://你的项目.pages.dev/admin.html`。
7. 每次更新代码并推送到 GitHub，Cloudflare 会自动重新部署。

官方文档：
- Cloudflare Pages 静态 HTML：https://developers.cloudflare.com/pages/framework-guides/deploy-anything/
- Cloudflare Pages Git 集成：https://developers.cloudflare.com/pages/configuration/git-integration/
- Supabase RLS：https://supabase.com/docs/guides/database/postgres/row-level-security

## 四、上线前检查清单
- [ ] 替换品牌名称和 Logo
- [ ] 把演示空间图替换为自己有权使用的真实图片，清楚区分真实房源和风格示意图
- [ ] 配置 Supabase URL 和公开 key
- [ ] 创建唯一管理员账号、关闭公开注册
- [ ] 替换 SQL 中管理员 UUID 并验证策略
- [ ] 测试表单成功提交
- [ ] 测试未登录不能读取意向列表
- [ ] 测试管理员能登录、查看、保存状态和备注
- [ ] 补全隐私说明、联系信息与必要的网站合规要求

## 费用说明
以上工具有免费方案，但免费额度、可用性和条款会变化。自定义域名通常另行付费。该版本不包含短信验证码、邮件通知、文件上传、复杂防刷或自动备份服务。
