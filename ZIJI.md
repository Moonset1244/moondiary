# 自记（MoonDiary）改造方案

> 基于 moodiary 2.8.x（develop@a9890c9）二次开发的私人日记 App。
> 目标：完全替代榴莲日记，Markdown 记日记 + 高度自定义 + 多端同库。
> 本文档为开发总纲，2026-10-26 由望舒（Hermes）产出，Moonset 审阅。

## 一、定位

- 自用为主，未来可能开源分享，永不收费
- 多端：Android（APK，Linux 构建）+ Windows（GitHub Actions 云构建），同一数据库（drift/SQLite，快照式 WebDAV/S3 同步）
- 界面延续 moodiary（Material You 风格），不重造 UI

## 二、功能差距矩阵（榴莲日记 → moodiary 现状）

### 已具备（验证过代码，无需开发）

| 功能 | moodiary 实现 |
|---|---|
| 心情/评分/天气/定位 | diary_mood、score(27文件)、weather(42文件)、place/map(184文件) |
| 日历/时间轴首页 | ViewModeType 切换（diary_home_page） |
| 热力图+写作统计 | moodiary_data/dashboard_controller（heatmapLevelResolver、DashboardStats） |
| 分类（层级+颜色） | Category(parentId, color) |
| 搜索/回收站/图表/地图足迹 | search/recycle/graph/map 页面齐备 |
| 多媒体附件 | image/audio/video/fileName 四类 |
| 云同步 | WebDAV + S3/MinIO + 局域网 + 端到端加密（超榴莲） |
| 导出 | Markdown/Word/PDF/长图 + share_sheet 分享卡片 |
| 导入 | Markdown 压缩包导入 |
| 应用锁 | moodiary_lock + 生物识别 |
| 主题/字体 | moodiary_theme + font 包（含可变字体导入） |
| AI 助手 | moodiary_assistant（OpenAI/Anthropic 兼容） |
| md 编辑基础 | TipTap 3.32 + @tiptap/markdown（GFM/CJK-friendly，WebView 内嵌） |

### 需开发（按优先级）

| # | 功能 | 现状 | 改动点 | 阶段 |
|---|---|---|---|---|
| 1 | md 编辑体验强化 | TipTap WYSIWYG 已懂 md 语法 | 验证现状→补源码模式切换、粘贴 md 智能识别打磨 | 1 |
| 2 | 多级标签 | tags 是扁平 List\<String\> | 新建 Tag 实体表（parent_id/color），迁移旧 tags，标签管理页 | 2 |
| 3 | 多日记本 | Category 已有层级 | UI/语义升级为"日记本"（book），或独立 Book 实体，二选一评审后定 | 2 |
| 4 | 五年日记 | 无 | 新视图：同年同日五行对照 | 3 |
| 5 | 那年今日 | 仅 AI 助手工具版 | 独立回顾页/首页卡片 | 3 |
| 6 | 随机漫步 | 无 | 随机日记卡片流 | 3 |
| 7 | 定时提醒写日记 | 无 | flutter_local_notifications + 设置页 | 3 |
| 8 | 日记模板 | 无 | 模板实体+模板市场（可复用 AI 助手生态） | 3 |
| 9 | 年度日历/月度年度总结 | dashboard 有统计 | 对标榴莲的年度回顾报告 | 4 |
| 10 | 独立图库 | 有 image_browser | 汇聚全部图片的图库页 | 4 |
| 11 | 第三方 App 导入 | 仅 Markdown | 榴莲 20+ App 导入为低优先级（自用已够） | 4 |

### 不做

- Firebase 系、上架应用商店、付费体系

## 三、开发阶段

- 阶段 0（当前）：基线 APK 构建跑通 → 用户装机验收基线
- 阶段 1：md 编辑体验（#1）
- 阶段 2：标签+日记本数据模型改造（#2 #3，含 drift migration）
- 阶段 3：回顾类功能补齐（#4-#8）
- 阶段 4：打磨（#9-#11）+ 同步验证 + Windows CI

## 四、开发规范（标准体系，每阶段强制）

1. 编码前加载 skill：flutter-best-practices（架构分层/编码规范/测试规范）+ riverpod（状态管理是本项目主栈）
2. 库 API 一律 Context7 MCP 查最新文档，不凭记忆写
3. 数据模型改动必须走 drift migration（tool/task.dart migrations），禁止破坏旧数据
4. 每个功能：先写计划 → TDD（测试先行）→ 实现 → code-review skill 过一遍 → tool/task.dart analyze + test 受影响包 → git commit（规范 message）
5. 提交纪律：一个功能一个 commit，随时可回滚；develop 分支直推，里程碑打 tag

## 五、构建与交付

- Linux 构建 Android APK：`dart tool/task.dart build-apk`（fvm 3.47.2，环境细节见项目 skill）
- Windows exe：GitHub Actions windows-latest 云构建（待配置 workflow）
- 交付：APK 直接发用户微信；源码推 Moonset1244/moondiary
