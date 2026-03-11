# ✨ Brush-Up - Continuous Self-Improvement Skill

> Empowering AI Agents with continuous evolution capabilities

[![OpenClaw Skill](https://img.shields.io/badge/OpenClaw-Skill-blue)](https://openclaw.ai)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.1.0-orange)](https://github.com/wofeiwo/brush-up-skill/releases)

**[中文文档](README.md)** | **[English](README_en.md)**

---

## 📖 Introduction

**Brush-Up** is a continuous self-improvement skill designed for OpenClaw Agents. It provides a complete workflow framework to help agents proactively discover problems, think deeply, generate improvement plans, and continuously track execution results.

### Core Philosophy

- 🎯 **Agent-Led** - Not an automation script, but a process guide. Agents participate in thinking throughout.
- 🔄 **Continuous Cycle** - Information gathering → Value filtering → Reflection & insight → Validation → Reporting → Implementation → Review
- 📊 **Data-Driven** - Automatically discover improvement opportunities based on errors/learning logs
- 🧠 **Capability Building** - From process following to autonomous driving, truly enhancing agent capabilities

---

## 🚀 Quick Start

### Prerequisites

- OpenClaw v2026.3.8 or higher
- Node.js v22+
- Bash 5.0+
- jq (JSON processing)
- Python 3.8+

### Installation

```bash
# Clone the repository
git clone https://github.com/wofeiwo/brush-up-skill.git
cd brush-up-skill

# Copy skill to OpenClaw workspace
cp -r . ~/.openclaw/workspace/skills/brush-up

# Verify installation
brush-up start --help
```

### Start Your First Topic

```bash
# Simple mode - auto-detect configuration
brush-up start --topic="Optimize workflow efficiency"

# Full mode - specify all parameters
brush-up start \
  --topic="Optimize HK stock trading system" \
  --agent=agent-a \
  --categories=finance,ai-tech \
  --frequency=weekly \
  --mode=standard
```

---

## 📋 Core Features

### Phase 1: Configuration Automation

- ✅ **Auto Agent Detection** - Recommend agent based on topic keywords
- ✅ **Smart Deduplication** - Check for existing topics before starting
- ✅ **Categories Recommendation** - Auto-match information source categories
- ✅ **Frequency Suggestion** - Mechanism optimization→Weekly, Market monitoring→Daily
- ✅ **Cron Validation** - Automatically verify delivery configuration

### Phase 2: Process Tiers

| Mode | Process Steps | Token Cost | Use Case |
|------|---------------|-----------|----------|
| **light** | P1→P2→P5 | ~15k | Weekly checks, info sync |
| **standard** | P1→P2→P3→P5 | ~50k | Most topics (default) |
| **full** | P1-P7 Full cycle | ~150k | Complex topics, quarterly reviews |

### Phase 3: Adaptive Information Sources

- 🎯 **Category→Tool Mapping** - 6 categories auto-match tool priorities
- 💰 **Token Strategy** - Auto-adjust sources based on remaining tokens
- ⚡ **Performance** - 60% fewer API calls, 93% reduction in timeouts

### Phase 4: Agent Capability Building

- 🧠 **L2 Deep Thinking** - Mandatory reflection prompts to avoid shallow execution
- 🔍 **L3 Meta-Cognition** - P7 self-assessment for continuous improvement
- 🚀 **L4 Autonomous Driving** - Auto-generate topics every Monday, user approval only

---

## 🔄 Cycle Workflow

```
┌─────────────────────────────────────────────────────────┐
│  P1 Information Gathering (08:00) → Multi-source scan  │
│       ↓                                                 │
│  P2 Value Filtering         → Blacklist, scoring       │
│       ↓                                                 │
│  P3 Reflection & Insight    → Generate insights        │
│       ↓                                                 │
│  P4 Validation              → Thought experiments      │
│       ↓                                                 │
│  P5 Reporting (21:00)       → Generate report          │
│       ↓                                                 │
│  P6 Implementation          → Execute changes          │
│       ↓                                                 │
│  P7 Review                  → Update metrics           │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 Directory Structure

```
brush-up-skill/
├── SKILL.md                          # Core skill documentation
├── README.md                         # Chinese documentation
├── README_en.md                      # English documentation
├── UPGRADE-v2.0.md                   # Version upgrade log
├── LICENSE                           # MIT License
├── config/
│   ├── sources.json                  # Information source config
│   └── tool-priority-mapping.json    # Tool priority mapping
├── scripts/
│   ├── start.sh                      # Start topic
│   ├── stop.sh                       # Stop topic
│   ├── rm.sh                         # Remove topic
│   ├── list.sh                       # List topics
│   ├── daily-run.sh                  # Daily execution
│   └── auto-propose.sh               # L4 auto-proposal
└── logs/
    └── cycles/                       # Cycle reports (runtime)
```

---

## 🛠️ Usage Examples

### Basic Commands

```bash
# Start new topic
brush-up start --topic="Optimize HK stock stop-loss"

# View active topics
brush-up list

# View topic details
brush-up status optimize-workflow

# Stop topic (keep records)
brush-up stop optimize-workflow

# Remove topic (clean all)
brush-up rm optimize-workflow
```

### Advanced Usage

```bash
# Light mode - weekly check
brush-up start --topic="Weekly AI news sync" \
  --mode=light \
  --frequency=weekly

# Full mode - system research
brush-up start --topic="Refactor OpenClaw memory system" \
  --mode=full \
  --agent=main

# Specify categories
brush-up start --topic="Competitive analysis" \
  --categories=social-trends,general-news
```

### Automation

```bash
# Create OpenClaw Cron (auto-propose every Monday 08:00)
openclaw cron add \
  --agent=main \
  --name="brush-up auto-proposal" \
  --cron="0 8 * * 1" \
  --message="Execute brush-up/scripts/auto-propose.sh"
```

---

## 📊 Performance Comparison

| Metric | v1.0 (Before) | v2.1 (Current) | Improvement |
|--------|---------------|----------------|-------------|
| Config Error Rate | ~30% | <5% | ⬇️ 83% |
| Timeout Rate | 67% | <10% | ⬇️ 85% |
| Token Consumption | ~150k (fixed) | 15k-150k (tiered) | ⬇️ 40-80% |
| API Calls | Full scan | Category-filtered | ⬇️ 60% |
| Agent Engagement | Passive | Active + Autonomous | 📈 Qualitative leap |

---

## 🔧 Configuration

### sources.json

Information source category configuration:

```json
{
  "categories": {
    "ai-tech": {
      "name": "AI Technology",
      "sources": ["exa-search", "arxiv", "hackernews-ai"]
    },
    "finance": {
      "name": "Finance/Quant",
      "sources": ["tushare-api", "stock-monitor"]
    }
  }
}
```

### tool-priority-mapping.json

Tool priority mapping (Phase 3):

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

## 🧪 Development & Debugging

```bash
# Manual cycle execution
cd ~/.openclaw/workspace/skills/brush-up
bash scripts/daily-run.sh --topic=xxx --phase=full

# View logs
tail -f logs/cycles/latest.md

# Test configuration
jq . config/sources.json
jq . config/tool-priority-mapping.json
```

---

## 📝 Version History

### v2.1.0 (2026-03-11)
- ✨ Phase 4: Agent Capability Building (L2/L3/L4)
- ✨ Mandatory reflection prompts
- ✨ P7 meta-cognitive self-assessment
- ✨ Auto-proposal generation script

### v2.0.0 (2026-03-11)
- ✨ Phase 1: Configuration Automation
- ✨ Phase 2: Process Tiers
- ✨ Phase 3: Adaptive Information Sources

### v1.0.0 (2026-03-08)
- 🎉 Initial release

---

## 🤝 Contributing

1. Fork this repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to remote (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- [OpenClaw](https://openclaw.ai) - AI Agent gateway framework
- [ClawHub](https://clawhub.com) - Skill marketplace

---

## 📬 Contact

- GitHub Issues: [Report issues](https://github.com/wofeiwo/brush-up-skill/issues)
- Documentation: [View SKILL.md](SKILL.md)
- Upgrade Log: [View UPGRADE-v2.0.md](UPGRADE-v2.0.md)
