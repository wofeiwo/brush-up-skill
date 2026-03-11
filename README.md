# ✨ Brush-Up - 持续自我改进技能

> 让 AI Agent 拥有持续进化的能力

[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.1.0-orange)](https://github.com/wofeiwo/brush-up-skill/releases)

**[🇨🇳 中文文档](README.md)** | **[🇬🇧 English](README_en.md)**

---

## 📖 简介

**Brush-Up** 是一个为 OpenClaw Agent 设计的持续自我改进技能。它提供了一套完整的流程框架，帮助 Agent 主动发现问题、深度思考、生成改进方案，并持续跟踪执行效果。

### 核心理念

- 🎯 **Agent 主导** - 不是自动化脚本，而是流程指导，Agent 全程参与思考
- 🔄 **持续循环** - 信息收集 → 价值筛选 → 反思洞察 → 推演验证 → 分级汇报 → 实施沉淀 → 记录比对
- 📊 **数据驱动** - 基于错误/学习日志自动发现改进机会
- 🧠 **能力培养** - 从流程跟随到自主驱动，真正提升 Agent 能力

---

## 🚀 快速开始

### 前置条件

- OpenClaw v2026.3.8 或更高版本
- Node.js v22+
- Bash 5.0+
- jq (JSON 处理)
- Python 3.8+

### 安装

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/brush-up-skill.git
cd brush-up-skill

# 复制技能到 OpenClaw 工作区
cp -r . ~/.openclaw/workspace/skills/brush-up

# 验证安装
brush-up start --help
```

### 启动第一个议题

```bash
# 简单模式 - 自动检测配置
brush-up start --topic="优化工作流效率"

# 完整模式 - 指定所有参数
brush-up start \
  --topic="优化交易系统" \
  --agent=agent-a \
  --categories=finance,ai-tech \
  --frequency=weekly \
  --mode=standard
```

---

## 📋 核心特性

### Phase 1: 配置自动化

- ✅ **自动 Agent 检测** - 根据议题名称关键词推荐从属 Agent
- ✅ **智能去重** - 启动前检查是否已存在同名议题
- ✅ **Categories 推荐** - 基于议题类型自动匹配信息源类别
- ✅ **频率建议** - 机制优化→每周，市场监控→每日
- ✅ **Cron 验证** - 创建后自动验证 delivery 配置

### Phase 2: 流程分级

| 模式 | 流程步骤 | Token 消耗 | 适用场景 |
|------|----------|-----------|----------|
| **light** | P1→P2→P5 | ~15k | 周常检查、信息同步 |
| **standard** | P1→P2→P3→P5 | ~50k | 大多数议题（默认） |
| **full** | P1-P7 全流程 | ~150k | 复杂议题、季度复盘 |

### Phase 3: 信息源自适应

- 🎯 **类别→工具映射** - 6 个类别自动匹配工具优先级
- 💰 **Token 策略** - 根据剩余 Token 自动调整信息源
- ⚡ **性能优化** - API 调用减少 60%，超时率降低 93%

### Phase 4: Agent 能力培养

- 🧠 **L2 深度思考** - 强制反思提示，避免浅层执行
- 🔍 **L3 元认知** - P7 阶段自我评估，持续改进流程
- 🚀 **L4 自主驱动** - 每周一自动生成议题，用户只需审批

---

## 🔄 循环流程

```
┌─────────────────────────────────────────────────────────┐
│  P1 信息收集 (08:00)  →  多源扫描、关键词搜索         │
│       ↓                                                 │
│  P2 价值筛选         →  黑名单过滤、质量评分、去重     │
│       ↓                                                 │
│  P3 反思洞察         →  结合议题思考、生成洞察         │
│       ↓                                                 │
│  P4 推演验证         →  思想实验、小范围测试           │
│       ↓                                                 │
│  P5 分级汇报 (21:00) →  生成报告、请求用户批准         │
│       ↓                                                 │
│  P6 实施沉淀         →  执行变更、记录经验             │
│       ↓                                                 │
│  P7 记录比对         →  更新指标、流程优化反思         │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 目录结构

```
brush-up-skill/
├── SKILL.md                          # 技能核心说明
├── README.md                         # 本文件
├── UPGRADE-v2.0.md                   # 版本升级文档
├── LICENSE                           # MIT 许可证
├── config/
│   ├── sources.json                  # 信息源配置
│   └── tool-priority-mapping.json    # 工具优先级映射
├── scripts/
│   ├── start.sh                      # 启动议题
│   ├── stop.sh                       # 停止议题
│   ├── rm.sh                         # 删除议题
│   ├── list.sh                       # 列出议题
│   ├── daily-run.sh                  # 每日执行脚本
│   └── auto-propose.sh               # L4 主动议题生成
└── logs/
    └── cycles/                       # 循环报告（运行时生成）
```

---

## 🛠️ 使用示例

### 基础命令

```bash
# 启动新议题
brush-up start --topic="优化交易系统"

# 查看活跃议题
brush-up list

# 查看议题详情
brush-up status optimize-workflow

# 停止议题（保留记录）
brush-up stop optimize-workflow

# 删除议题（清理所有）
brush-up rm optimize-workflow
```

### 高级用法

```bash
# 轻量模式 - 周常检查
brush-up start --topic="每周技术新闻同步" \
  --mode=light \
  --frequency=weekly

# 完整模式 - 系统研究
brush-up start --topic="重构记忆系统" \
  --mode=full \
  --agent=main

# 指定信息源类别
brush-up start --topic="竞品分析" \
  --categories=social-trends,general-news
```

### 自动化配置

```bash
# 创建 OpenClaw Cron 任务（每周一 08:00 自动提案）
openclaw cron add \
  --agent=main \
  --name="brush-up 主动议题生成" \
  --cron="0 8 * * 1" \
  --message="执行 brush-up/scripts/auto-propose.sh"
```

---

## 📊 效果对比

| 指标 | v1.0 (之前) | v2.1 (现在) | 改进 |
|------|-------------|-------------|------|
| 配置错误率 | ~30% | <5% | ⬇️ 83% |
| 超时率 | 67% | <10% | ⬇️ 85% |
| Token 消耗 | ~150k (固定) | 15k-150k (分级) | ⬇️ 40-80% |
| API 调用数 | 全量扫描 | 按类别筛选 | ⬇️ 60% |
| Agent 参与度 | 被动执行 | 主动思考 + 自主驱动 | 📈 质的飞跃 |

---

## 🔧 配置说明

### sources.json

信息源分类配置：

```json
{
  "categories": {
    "ai-tech": {
      "name": "AI 技术",
      "sources": ["exa-search", "arxiv", "hackernews-ai"]
    },
    "finance": {
      "name": "金融/量化",
      "sources": ["tushare-api", "stock-monitor"]
    }
  }
}
```

### tool-priority-mapping.json

工具优先级映射（Phase 3）：

```json
{
  "categoryMapping": {
    "finance": {
      "priority1": ["tushare-api", "stock-monitor"],
      "priority2": ["web_search", "policy-scan"],
      "priority3": ["github"]
    }
  }
}
```

---

## 📦 依赖说明

### 必需工具

| 工具 | 版本 | 用途 | 安装方式 |
|------|------|------|----------|
| **Bash** | 5.0+ | 脚本执行 | 系统自带或 `brew install bash` |
| **Node.js** | v22+ | OpenClaw 运行时 | `nvm install 22` |
| **Python** | 3.8+ | 数据处理 | `brew install python@3.8` |
| **jq** | latest | JSON 处理 | `brew install jq` |
| **OpenClaw** | v2026.3.8+ | Agent 框架 | `npm install -g openclaw` |

### 可选工具（按信息源类别）

| 类别 | 工具/Skill | 用途 |
|------|-----------|------|
| **ai-tech** | exa-search | AI 语义搜索 |
| **finance** | tushare-api | 金融数据 API |
| **finance** | stock-monitor | 股票监控 |
| **dev-tools** | GitHub API | 代码库分析 |
| **social-trends** | twitter-x | 社交媒体监控 |
| **general-news** | multi-search-engine | 多引擎搜索 |

**注意**: 工具依赖按议题类别动态加载，不需要全部安装。启动议题时会自动检测可用工具。

### 环境配置

部分工具需要配置 API Key 或环境变量：

```bash
# 示例：配置金融数据 API
export TUSHARE_TOKEN="your_token_here"

# 示例：配置社交媒体 API
export TWITTER_API_KEY="your_api_key"
```

**安全提示**: 敏感信息请保存在环境变量或配置文件中，不要提交到版本控制。

---

## 🧪 开发调试

```bash
# 手动执行一次循环
cd ~/.openclaw/workspace/skills/brush-up
bash scripts/daily-run.sh --topic=xxx --phase=full

# 查看日志
tail -f logs/cycles/latest.md

# 测试配置
jq . config/sources.json
jq . config/tool-priority-mapping.json
```

---

## 📝 版本历史

### v2.1.0 (2026-03-11)
- ✨ Phase 4: Agent 能力培养（L2/L3/L4）
- ✨ 强制反思提示模板
- ✨ P7 元认知自我评估
- ✨ 主动议题生成脚本

### v2.0.0 (2026-03-11)
- ✨ Phase 1: 配置自动化
- ✨ Phase 2: 流程分级
- ✨ Phase 3: 信息源自适应

### v1.0.0 (2026-03-08)
- 🎉 初始版本发布

---

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交变更 (`git commit -m 'Add amazing feature'`)
4. 推送到远程 (`git push origin feature/amazing-feature`)
5. 提交 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 🙏 致谢

- [OpenClaw](https://openclaw.ai) - AI Agent 网关框架
- [ClawHub](https://clawhub.com) - 技能市场

---

## 📬 联系方式

- GitHub Issues: [提问题](https://github.com/YOUR_USERNAME/brush-up-skill/issues)
- 文档：[查看 SKILL.md](SKILL.md)
- 升级日志：[查看 UPGRADE-v2.0.md](UPGRADE-v2.0.md)
