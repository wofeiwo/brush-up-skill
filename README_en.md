# Brush-Up ✨

> Continuous Self-Improvement Skill for OpenClaw Agents

[![Version](https://img.shields.io/badge/version-2.1-blue.svg)](./SKILL.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Introduction

Brush-Up is a continuous improvement skill for OpenClaw Agents. For specific tasks or topics, it performs daily cycles: Information Collection → Value Filtering → Reflective Insights → Deductive Validation → Tiered Authorization Reporting → Implementation & Documentation.

## Core Features

### v2.1 New
- **Process Tiering Strategy** - Auto-recommend light/standard/full mode based on topic complexity
- **Frequency Auto-Recommendation** - Weekly for mechanism topics, daily for market topics
- **Mandatory Reflection Prompts** - Force Agent deep thinking at P1/P3/P5 stages
- **Multi-Channel Support** - Support Telegram, Feishu, and other delivery channels
- **Dual Deletion Mechanism** - Fix orphan tasks and path issues

### v2.0 Features
- **Configuration Automation** - Auto-detect Agent, categories, frequency, mode
- **Process Tiering** - Three modes: light/standard/full
- **Adaptive Information Sources** - Match tool priorities by topic category
- **Agent Capability Building** - L2 Deep Thinking + L3 Meta-Cognition + L4 Self-Driving

## Quick Start

```bash
# Basic usage
brush-up start --topic="Learn LLM Optimization"

# Multi-channel environment requires channel specification
brush-up start --topic="Optimize Workflow" --channel="telegram:CHAT_ID"

# See detailed usage → references/DETAILED_GUIDE.md
```

## Documentation

| Document | Description |
|----------|-------------|
| [SKILL.md](./SKILL.md) | Main document - Quick start and core concepts |
| [references/DETAILED_GUIDE.md](./references/DETAILED_GUIDE.md) | Detailed examples, common errors, lessons learned |
| [references/EXAMPLES.md](./references/EXAMPLES.md) | Usage examples |

## Directory Structure

```
brush-up/
├── README.md               # This document
├── README_en.md           # English version
├── SKILL.md               # Main document
├── LICENSE                # License
├── config/
│   ├── sources.json       # Information source configuration
│   └── tool-priority-mapping.json
├── scripts/               # Execution scripts
│   ├── start.sh          # Start topic
│   ├── stop.sh           # Stop topic
│   ├── rm.sh             # Remove topic
│   ├── list.sh           # List topics
│   ├── daily-run.sh      # Daily execution
│   └── auto-propose.sh   # Auto-propose topics
├── references/            # Reference documents
│   ├── DETAILED_GUIDE.md # Detailed guide
│   └── EXAMPLES.md       # Usage examples
└── .gitignore
```

## Core Constraints

1. **Do not execute any dangerous operations without authorization**
2. **Do not leak personal privacy without authorization**
3. **Humans are the final decision-makers**
4. **Token efficiency first**

## Version History

| Version | Date | Major Updates |
|---------|------|---------------|
| v2.1 | 2026-03-12 | Process tiering strategy, frequency auto-recommendation, mandatory reflection prompts, fix Cron channel |
| v2.0 | 2026-03-11 | Configuration automation, process tiering, adaptive information sources, agent capability building |
| v1.0 | 2026-03-08 | Initial version: P1-P7 basic process |

## License

MIT

---

*✨ A little progress every day*
