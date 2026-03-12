# Brush-Up ✨

> 持续自我改进的 OpenClaw Agent Skill

[![Version](https://img.shields.io/badge/version-2.1-blue.svg)](./SKILL.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 简介

Brush-Up 是一个用于 OpenClaw Agent 的持续改进技能。针对特定任务或议题，每日循环执行：信息收集 → 价值筛选 → 反思洞察 → 推演验证 → 分级授权汇报 → 实施沉淀。

## 核心特性

### v2.1 新增
- **流程分级默认策略** - 根据议题复杂度自动推荐轻量/标准/完整模式
- **频率自动推荐** - 机制类议题每周，市场类议题每日
- **强制反思提示** - P1/P3/P5 阶段强制 Agent 深度思考
- **多 Channel 支持** - 支持 Telegram、飞书等投递渠道
- **双重新增机制** - 修复孤儿任务和路径问题

### v2.0 特性
- **配置自动化** - 自动检测 Agent、类别、频率、模式
- **流程分级** - light/standard/full 三级模式
- **信息源自适应** - 按议题类别匹配工具优先级
- **Agent 能力培养** - L2 深度思考 + L3 元认知 + L4 自主驱动

## 快速开始

```bash
# 基础用法
brush-up start --topic="学习 LLM 优化"

# 多 channel 环境必需指定投递渠道
brush-up start --topic="优化工作流" --channel="telegram:CHAT_ID"

# 查看详细用法 → references/DETAILED_GUIDE.md
```

## 文档

| 文档 | 说明 |
|------|------|
| [SKILL.md](./SKILL.md) | 主文档 - 快速入门和核心概念 |
| [references/DETAILED_GUIDE.md](./references/DETAILED_GUIDE.md) | 详细示例、常见错误、经验教训 |
| [references/EXAMPLES.md](./references/EXAMPLES.md) | 使用示例 |

## 目录结构

```
brush-up/
├── README.md               # 本文档
├── README_en.md           # 英文版
├── SKILL.md               # 主文档
├── LICENSE                # 许可证
├── config/
│   ├── sources.json       # 信息源配置
│   └── tool-priority-mapping.json
├── scripts/               # 执行脚本
│   ├── start.sh          # 启动议题
│   ├── stop.sh           # 停止议题
│   ├── rm.sh             # 删除议题
│   ├── list.sh           # 列出议题
│   ├── daily-run.sh      # 每日执行
│   └── auto-propose.sh   # 主动提案
├── references/            # 参考文档
│   ├── DETAILED_GUIDE.md # 详细指南
│   └── EXAMPLES.md       # 使用示例
└── .gitignore
```

## 核心约束

1. **未经授权，不执行任何危险操作**
2. **未经授权，不泄露个人隐私**
3. **人类是最终决策者**
4. **Token 效率优先**

## 版本历史

| 版本 | 日期 | 主要更新 |
|------|------|----------|
| v2.1 | 2026-03-12 | 流程分级默认策略、频率自动推荐、强制反思提示、修复 Cron channel |
| v2.0 | 2026-03-11 | 配置自动化、流程分级、信息源自适应、Agent 能力培养 |
| v1.0 | 2026-03-08 | 初始版本：P1-P7 基础流程 |

## License

MIT

---

*✨ 每天进步一点点*
