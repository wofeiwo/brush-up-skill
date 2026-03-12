---
name: brush-up
description: 持续自我改进技能。针对特定任务/议题，每日循环：信息收集→价值筛选→反思洞察→推演验证→分级授权汇报→实施沉淀。核心约束：未经批准不执行危险操作、不泄露隐私、人类最终决策、Token 效率优先。按需启动 Cron/Hook。
version: "2.1"
changelog: |
  v2.1 (2026-03-12): 修复 Cron channel 配置问题，添加 --channel 参数支持
  v2.0 (2026-03-11): 新增配置自动化、流程分级、信息源自适应、Agent 能力培养
metadata:
  {
    "openclaw": {
      "emoji": "✨",
      "requires": { "bins": ["curl", "jq"] }
    }
  }
---

# ✨ brush-up - 持续改进技能

**按需启动**: 有新议题时创建 Cron/Hook，无任务时不占用资源。

**版本**: v2.1 (2026-03-12) - 新增流程分级默认策略、频率自动推荐、强制反思提示

---

## 🔐 核心约束 (Prime Directives)

1. **未经授权，不执行任何危险操作**
2. **未经授权，不泄露个人隐私**
3. **人类是最终决策者**
4. **Token 效率优先**

---

## ⚠️ 核心原则 (非常重要！)

**brush-up 是一个流程指导技能，不是自动化工具！**

### Skill 的角色
- ✅ **提供流程框架** - P1-P7 各阶段的步骤指引
- ✅ **提供工具列表** - 可用的信息源和工具
- ✅ **提供模板** - 报告模板、通知模板
- ❌ **不代替 Agent 执行** - 不会自动收集信息或生成报告

### Agent 的角色
- ✅ **全程参与** - P1-P7 每个阶段都需要 Agent 的思考和执行
- ✅ **自主决策** - 根据议题内容选择信息源、关键词、筛选标准
- ✅ **主动思考** - 反思、洞察、实验设计都需要 Agent 的智慧
- ✅ **与用户交互** - 生成报告并发送到用户 channel，请求批准

### 关键提醒

> **⚠️ 如果你（Agent）只是被动执行脚本，brush-up 就失去了意义！**
> 
> **✅ 正确做法**:
> 1. 收到触发消息后，**主动阅读** SKILL.md 了解流程
> 2. 根据议题内容，**自主选择**信息源和关键词
> 3. **深度思考**每个阶段的输入和输出
> 4. **主动与用户交互**，请求批准和反馈
> 5. **持续改进**流程本身（通过 self-improvement-process 议题）

---

## 🎯 Phase 1-3 升级特性 (v2.0)

### 📋 Phase 1: 配置自动化

**自动校验和最佳实践引导**，避免人工配置错误。

**启动命令增强**:
```bash
brush-up start --topic="优化工作流效率" \
  --agent=main \
  --categories="dev-tools,ai-tech" \
  --frequency=weekly \
  --mode=standard
```

**自动化内容**:
| 功能 | 说明 | 示例 |
|------|------|------|
| **议题去重** | 检查是否已存在同名/相似议题 | 发现重复时提示合并 |
| **Agent 从属** | 自动关联对应 agent 的目录结构 | 金融议题→finance-agent |
| **Categories 推荐** | 基于议题名称自动推荐类别 | "交易"→finance |
| **频率建议** | 根据议题类型建议循环频率 | 机制优化→每周，市场监控→每日 |
| **Cron 验证** | 创建后自动验证 delivery 配置 | 检查 channel 配置 |
| **状态追踪** | 自动更新 cycleCount 和 lastCycle | 报告生成后更新 |

**Categories 自动映射**:
| 关键词 | 推荐类别 | 建议频率 |
|--------|----------|----------|
| 交易/量化/市场 | finance | 每日 |
| 优化/改进/效率 | dev-tools,openclaw-ecosystem | 每周 |
| 学习/研究/技术 | ai-tech,general-news | 每周 |
| 市场/竞品/用户 | social-trends,general-news | 每日 |

---

### 📊 Phase 2: 流程分级

**三级流程模式**，根据议题复杂度选择合适的流程深度。

| 模式 | 流程步骤 | 适用场景 | Token 消耗 | 执行时长 |
|------|----------|----------|-----------|----------|
| **轻量 (light)** | P1→P2→P5 | 简单议题、周常检查、信息同步 | ~15k | 5-10 分钟 |
| **标准 (standard)** | P1→P2→P3→P5 | 大多数议题（默认模式） | ~50k | 15-30 分钟 |
| **完整 (full)** | P1-P7 全流程 | 复杂议题、季度复盘、重大决策 | ~150k | 1-2 小时 |

**各模式详细说明**:

**轻量模式** - 快速同步型:
```
P1 信息收集 → P2 价值筛选 → P5 分级汇报
```
- 适用：每周例行检查、信息同步类议题
- 输出：高价值信息 Top 10 + 简要洞察

**标准模式** - 深度思考型（默认）:
```
P1 信息收集 → P2 价值筛选 → P3 反思洞察 → P5 分级汇报
```
- 适用：大多数优化类、学习类议题
- 输出：完整洞察 + 可执行提案

**完整模式** - 系统研究型:
```
P1 信息收集 → P2 价值筛选 → P3 反思洞察 → P4 推演验证 → P5 分级汇报 → P6 实施沉淀 → P7 记录比对
```
- 适用：重大架构调整、新系统引入、季度复盘
- 输出：完整报告 + 实施记录 + 效果对比

**启动时指定模式**:
```bash
# 轻量模式
brush-up start --topic="每周 AI 新闻同步" --mode=light --frequency=weekly

# 标准模式（默认）
brush-up start --topic="优化港股止损策略" --mode=standard

# 完整模式
brush-up start --topic="重构 OpenClaw 记忆系统" --mode=full
```

---

### 🎯 Phase 3: 信息源自适应

**根据议题类别自动匹配工具优先级**，减少不必要 API 调用。

**类别到工具的映射**:

| 议题类别 | Priority=1 (必用) | Priority=2 (辅助) | Priority=3 (可选/跳过) |
|----------|------------------|------------------|----------------------|
| **finance** | tushare-api, 持仓分析，美股数据 | 政策扫描，web_search | 代码库，GitHub |
| **ai-tech** | exa-search, arxiv, hackernews-ai | web_search, multi-engine | 金融数据，持仓分析 |
| **dev-tools** | GitHub API, session 日志 | web_search, producthunt | 金融数据 |
| **openclaw** | 配置文件，session 日志，clawhub | GitHub-openclaw | 外部 API |
| **social-trends** | twitter-x, reddit, moltbook | farcaster, producthunt | 学术论文 |
| **general-news** | web_search, multi-engine | jina-search, RSS | 专业数据库 |

**Token 紧张时的自适应策略**:

| Token 状态 | 策略 | 说明 |
|-----------|------|------|
| **充足** (>80% 剩余) | 使用 Priority=1+2 | 完整信息收集 |
| **紧张** (<50% 剩余) | 仅用 Priority=1 | 跳过 Priority=2+3 |
| **紧急** (<20% 剩余) | 仅核心 API | 跳过所有搜索，用缓存 |

**启动时自动匹配**:
```bash
# 金融类议题 - 自动启用 tushare + 持仓分析
brush-up start --topic="优化港股止损" --categories=finance

# 技术类议题 - 自动启用 exa-search + arxiv
brush-up start --topic="学习 LLM 优化" --categories=ai-tech

# 多类别议题 - 合并工具列表
brush-up start --topic="量化系统架构" --categories=finance,dev-tools
```

**效果对比**:
| 优化前 | 优化后 | 改进 |
|--------|--------|------|
| 全量扫描所有工具 | 按类别筛选 | ⬇️ 减少 60% API 调用 |
| 固定 600s 超时 | 动态超时 (Priority 数量) | ⬇️ 减少 50% 超时 |
| 每日循环所有议题 | 按类型设置频率 | ⬇️ 减少 57% 循环次数 |

---

## 🧠 Phase 4: Agent 能力培养 (v2.1)

**核心目标**: 从"流程跟随"提升到"自主驱动"，真正增强 Agent 能力。

### 四层能力模型

```
┌─────────────────────────────────────────────┐
│  L4: 自主驱动  │  Agent 自己发现改进机会    │ ← 终极目标
├─────────────────────────────────────────────┤
│  L3: 元认知    │  Agent 评估自己的流程表现  │
├─────────────────────────────────────────────┤
│  L2: 深度思考  │  强制反思提示 + 结构化输出 │
├─────────────────────────────────────────────┤
│  L1: 流程跟随  │  当前状态：按 P1-P7 执行   │
└─────────────────────────────────────────────┘
```

---

### L2: 深度思考增强 ✅

**核心机制**: 在每个阶段插入**强制性反思提示**，Agent 必须回答才能继续。

**P1 信息收集 - 强制提示**:
```markdown
## 🎯 信息收集策略说明

**我选择的信息源**: [列出使用的工具]
**选择理由**: [为什么这些源最适合当前议题]
**预期收获**: [希望找到什么类型的信息]
```

**P3 反思洞察 - 强制提示** (必须回答，不能跳过):
```markdown
## 🧠 深度反思三问

**问题 1**: 今天收集的信息中，哪一条最让你意外？为什么？
> [必须填写]

**问题 2**: 结合议题"[议题名称]"，这个洞察能解决什么实际问题？
> [必须填写]

**问题 3**: 如果让你用一句话总结今天的核心发现，会是什么？
> [必须填写]
```

**P5 报告生成 - 强制提示**:
```markdown
## 🎯 提案价值自检

**这个提案的优势**: [列出 3 点]
**潜在风险**: [列出 2 点]
**如果我是用户，我会关心什么**: [从用户角度思考]
```

**效果**: 强制 Agent 深度处理信息，而不是简单罗列。

---

### L3: 元认知能力 ✅

**核心机制**: P7 阶段添加**流程自我评估**，Agent 要评估自己的表现。

**P7 元评估模板**:
```markdown
## 🔍 本次循环的自我评估

### 流程效率评分 (1-10 分): [ ]

**信息收集是否充分？为什么？**
> [回答]

**哪个阶段耗时最长？是否值得？**
> [回答]

### 思考深度评分 (1-10 分): [ ]

**是否提出了原创性洞察？**
> [回答]

**是否挑战了既有假设？**
> [回答]

### 用户价值评分 (1-10 分): [ ]

**今天的报告对用户有实际帮助吗？**
> [回答]

**用户最可能采纳哪个提案？为什么？**
> [回答]

### 改进计划

**下次循环我会尝试**: ____________
**我需要用户帮助的是**: ____________
**我学到的一个新技巧**: ____________
```

**效果**: Agent 学会评估自己的工作质量，形成自我改进循环。

---

### L4: 自主驱动 ✅

**核心机制**: Agent 主动分析错误/学习日志，**自己生成议题**，用户只需审批。

**每周一 08:00 自动执行流程**:
```
1. 分析过去 7 天的 errors/learnings/requests
2. 识别重复出现的问题模式
3. 生成 2-3 个备选议题
4. 发送给用户审批
5. 用户批准后自动启动 brush-up
```

**主动议题生成脚本**:
```bash
# 每周一自动执行
brush-up/scripts/auto-propose.sh
```

**输出示例**:
```markdown
## 🎯 本周改进议题建议

基于过去 7 天的分析，我发现了 3 个可改进的模式：

**议题 A**: 修复任务超时问题
- **触发事件**: 3 次超时错误
- **影响**: 报告延迟送达，无法及时决策
- **预计工作量**: 2-3 小时
- **推荐优先级**: 🔴 高

**议题 B**: 优化 Channel 配置管理
- **触发事件**: 2 次 delivery 配置缺失
- **影响**: 报告无法送达
- **预计工作量**: 1 小时
- **推荐优先级**: 🟡 中

**议题 C**: 建立 Cron 健康检查机制
- **触发事件**: 多个 error 任务持续存在
- **影响**: 系统可靠性下降
- **预计工作量**: 4-6 小时
- **推荐优先级**: 🟡 中

---

**请批准 1-2 个议题启动 brush-up**:
回复：`批准 A,B` 或 `全部批准` 或 `都不批准，原因是...`
```

**效果**: 用户从"想议题"变成"审批议题"，Agent 主动驱动改进。

---

## 📋 快速参考

### 命令列表

| 命令 | 用途 | 示例 |
|------|------|------|
| `brush-up start` | 启动新议题 | `brush-up start --topic="优化工作流"` |
| `brush-up list` | 查看所有议题 | `brush-up list` |
| `brush-up status` | 查看议题详情 | `brush-up status optimize-workflow` |
| `brush-up stop` | 停止议题（保留记录） | `brush-up stop optimize-workflow` |
| `brush-up rm` | 删除议题（清理所有） | `brush-up rm optimize-workflow` |
| `brush-up run` | 手动执行一次循环 | `brush-up run optimize-workflow` |

---

## 🚀 快速启动

### 开始新议题

```bash
# 基础用法
brush-up start --topic="学习 LLM 优化"

# 多 channel 环境必需指定投递渠道
brush-up start --topic="优化工作流" --channel="telegram:CHAT_ID"

# 查看详细用法和常见错误 → references/DETAILED_GUIDE.md
```

**⚠️ 多 Channel 必需**: 如果 OpenClaw 配置了多个 channel，必须使用 `--channel` 参数，否则任务会失败。详见 [references/DETAILED_GUIDE.md](./references/DETAILED_GUIDE.md)。

**预设模板**:
| 模板 | 类别 | 适用场景 |
|------|------|----------|
| `optimize-workflow` | openclaw-ecosystem + dev-tools | 工作流优化 |
| `learn-ai-tech` | ai-tech + general-news | 学习 AI 技术 |
| `market-research` | social-trends + general-news | 市场调研 |
| `competitive-analysis` | openclaw-ecosystem + social-trends | 竞品分析 |

**信息源类别**:
| 类别 | 说明 | 包含信息源 |
|------|------|------------|
| `ai-tech` | AI 技术 | exa-search, arxiv, hackernews-ai |
| `openclaw-ecosystem` | OpenClaw 生态 | github-openclaw, clawhub, moltbook |
| `social-trends` | 社交趋势 | twitter-x, reddit, farcaster |
| `dev-tools` | 开发工具 | github-trending, producthunt |
| `general-news` | 综合新闻 | brave-search, multi-engine, jina |

**启动后自动创建**:
- ✅ 议题配置（自动检测 Agent、类别、频率、模式）
- ✅ Cron 任务（每日/每周，按议题类型自动推荐）
- ✅ Session Hook（捕获对话作为信息源）
- ✅ 日志目录

### 自动推荐逻辑

启动议题时，系统根据议题名称自动推荐以下配置：

| 关键词 | 推荐类别 | 频率 | 模式 |
|--------|----------|------|------|
| 新闻/同步/简报/例行 | general-news | daily | **light** |
| 重构/架构/系统设计 | dev-tools | weekly | **full** |
| 优化/改进/机制/流程 | openclaw-ecosystem | weekly | standard |
| 交易/量化/市场 | finance | daily | standard |
| 学习/研究/AI/技术 | ai-tech | weekly | standard |

### 查看议题

```bash
# 查看所有议题
brush-up list

# 输出示例：
# | ID | 名称 | 状态 | 循环次数 | 最后运行 |
# |----|------|------|----------|----------|
# | optimize-workflow | 优化 OpenClaw 工作流 | active | 5 | 2 小时前 |
# | learn-typescript | TypeScript 学习 | paused | 12 | 昨天 |
```

### 停止议题

```bash
# 停止（保留记录，可随时恢复）
brush-up stop optimize-workflow

# 清理 Cron 和 Hook，保留日志和配置
```

### 删除议题

```bash
# 删除（清理所有：Cron + Hook + 配置 + 日志）
brush-up rm optimize-workflow

# 确认后执行，不可恢复
```

---

## 🔄 循环流程

| 阶段 | 时间 | 内容 |
|------|------|------|
| P1 信息收集 | 08:00 | 多源扫描 (RSS/API/搜索/社交/会话) |
| P2 价值筛选 | 08:15 | 黑名单否决 + 质量评分 |
| P3 反思洞察 | 08:30 | 结合任务思考 |
| P4 推演验证 | 09:00 | 思想实验 + 小范围测试 |
| P5 分级汇报 | 21:00 | 生成报告 + 请求授权 |
| P6 实施沉淀 | 批准后 | 执行变更 + 记录经验 |
| P7 记录比对 | 完成后 | 更新指标 + 趋势分析 |

---

## 📊 汇报报告模板

```markdown
# 📊 brush-up 循环报告

**议题**: {{topicName}}
**循环**: #{{cycleNumber}} ({{date}})

═══════════════════════════════════════════════

## 1️⃣ 任务名称和信息
## 2️⃣ 今日操作和高价值信息小结
## 3️⃣ 核心观点提炼和思考
## 4️⃣ 本任务/议题的现状
## 5️⃣ 启发和提升 (对比优缺点)
## 6️⃣ 所有方案和提案
## 7️⃣ 历史结果对比
## 8️⃣ 下周期的计划规划
```

---

## ⚙️ 配置

### 数据目录结构

**Agent 级别隔离设计**:
```
{openclaw-workspace}/agents/{agent-id}/brush-up/
├── topics/
│   └── active.json              # 当前活跃议题
├── logs/
│   ├── cycles/                  # 循环报告
│   ├── insights/                # 洞察记录
│   └── experiments/             # 实验记录
└── config/
    └── cron-jobs.json           # Cron 配置
```

**共享资源**:
```
{openclaw-workspace}/skills/brush-up/
├── SKILL.md                     # 技能说明
├── config/
│   └── sources.json             # 信息源配置（共享）
└── scripts/                     # 执行脚本（共享）
```

**Agent ID 检测优先级**:
1. `--agent` 参数显式指定
2. `OPENCLAW_AGENT_ID` 环境变量
3. 默认值：`main`

### Cron 调度方式

**三种调度选项**:

| 方式 | 命令 | 适用场景 |
|------|------|----------|
| **OpenClaw Cron** | `--cron=openclaw` | 推荐，与 OpenClaw 集成 |
| **macOS plist** | `--cron=macos` | macOS 原生支持 |
| **手动运行** | `--cron=manual` | 测试或临时使用 |

**OpenClaw Cron 配置**:
```json
// {openclaw-workspace}/brush-up/config/cron-jobs.json
{
  "jobs": [
    {
      "id": "brush-up-topic-collect",
      "schedule": "0 8 * * *",
      "command": "bash scripts/daily-run.sh --topic=xxx --phase=collect"
    },
    {
      "id": "brush-up-topic-report",
      "schedule": "0 21 * * *",
      "command": "bash scripts/daily-run.sh --topic=xxx --phase=report"
    }
  ]
}
```

**macOS plist 位置**:
```
~/Library/LaunchAgents/com.brushup.{topic-id}.plist
```

---

## 🛠️ 工具链 (多源兼容)

### 信息源分类

| 类别 | 包含信息源 | 适用议题 |
|------|------------|----------|
| **🤖 AI 技术** | exa-search, arxiv, hackernews-ai, twitter-ai | 学习新技术、研究趋势 |
| **🦞 OpenClaw 生态** | github-openclaw, clawhub, moltbook, session-capture | 优化工作流、bug 修复 |
| **💬 社交趋势** | twitter-x, reddit, farcaster, producthunt | 市场调研、用户反馈 |
| **🛠️ 开发工具** | github-trending, producthunt-dev | 工具选型、效率提升 |
| **📰 综合新闻** | brave-search, multi-engine, jina-search | 一般性调研 |

### 工具详情

| 类型 | 工具 | 优先级 | 说明 |
|------|------|--------|------|
| **搜索引擎** | | | |
| | exa-search (skill) | 1 | AI 语义搜索，论文/博客/技术内容 |
| | web_search (builtin) | 1 | Brave API，默认搜索 |
| | multi-search-engine (skill) | 2 | 17 个引擎 (8 中文 +9 全球) |
| | s.jina.ai | 3 | Jina AI 搜索，AI 优化结果 |
| **页面抓取** | | | |
| | r.jina.ai | 1 | `https://r.jina.ai/URL`，避免反爬 |
| | web_fetch (builtin) | 2 | 内置提取器 |
| | markitdown (skill) | 3 | PDF/Office 转 Markdown |
| **RSS/API** | | | |
| | GitHub API | 1 | Issues/Releases/Trending |
| | arXiv API | 2 | AI 论文 |
| | curl+jq (cli) | 1 | 通用 RSS 解析 |
| **社交媒体** | | | |
| | X (Twitter) API | 1 | 需 `TWITTER_API_KEY` |
| | neynar (skill) | 2 | Farcaster 协议 |
| | moltbook | 3 | 个人社交记录 |
| **会话捕获** | | | |
| | session-hook | 1 | 当前对话脱敏提取 |

### 按议题类型选择信息源

**启动议题时自动匹配**:
```bash
# AI 技术研究
brush-up start --topic="学习 LLM 优化" --template=learn-ai-tech
# → 自动启用：ai-tech + general-news 类别

# OpenClaw 工作流优化
brush-up start --topic="提升技能效率" --template=optimize-workflow
# → 自动启用：openclaw-ecosystem + dev-tools 类别

# 市场调研
brush-up start --topic="竞品分析" --template=market-research
# → 自动启用：social-trends + general-news 类别
```

**手动指定类别**:
```bash
brush-up start --topic="自定义" --categories=ai-tech,social-trends
```

**工具选择原则**:
- 优先使用 priority=1 的工具
- 同类型工具不重复调用
- 失败自动 fallback 到下一优先级
- Token 紧张时跳过 priority=3 的工具

---

## 📂 文件结构

```
{openclaw-workspace}/skills/brush-up/
├── SKILL.md
├── config/
│   ├── topics.json
│   └── sources.json
├── scripts/
│   ├── start.sh
│   ├── stop.sh
│   ├── rm.sh
│   ├── list.sh
│   └── daily-run.sh
├── logs/{cycles,insights,experiments}/
└── hooks/session-capture.js
```

---

## 🔐 分级授权

| 类型 | 示例 | 授权 |
|------|------|------|
| 🟢 小教训 | Prompt 微调、参数调整 | 直接实施，事后告知 |
| 🔴 核心变化 | 安装工具、修改配置 | 需要批准 |

---

## ✅ 最佳实践

1. **议题聚焦**: 一次 1-2 个活跃议题
2. **及时响应**: 每晚查看报告
3. **定期回顾**: 每周回顾趋势
4. **适度授权**: 低风险改进可批量授权
5. **及时清理**: 完成的议题及时 stop/rm
6. **多 channel 必需**: 使用 `--channel` 参数确保报告送达

---

## 📚 参考文档

| 文档 | 内容 |
|------|------|
| [SKILL.md](./SKILL.md) | 本文档 - 快速入门和核心概念 |
| [references/DETAILED_GUIDE.md](./references/DETAILED_GUIDE.md) | 详细示例、常见错误、经验教训 |
| [UPGRADE-v2.0.md](./UPGRADE-v2.0.md) | v2.0 升级报告 |
| [config/sources.json](./config/sources.json) | 信息源配置 |

---

## 📝 版本历史

| 版本 | 日期 | 主要更新 |
|------|------|----------|
| v2.1 | 2026-03-12 | 流程分级默认策略、频率自动推荐、强制反思提示、修复 Cron channel |
| v2.0 | 2026-03-11 | 配置自动化、流程分级、信息源自适应、Agent 能力培养 |
| v1.0 | 2026-03-08 | 初始版本：P1-P7 基础流程 |

---

*✨ 每天进步一点点*
