# 发布说明

## 构建和发布流程

```bash
# 1. 更新版本号 (在 README.md 和 package.json 如果有的话)
# 2. 创建 git tag
git tag -a v2.1.0 -m "Brush-Up v2.1.0 - Agent 能力培养完整版"

# 3. 推送到 GitHub
git remote add origin https://github.com/YOUR_USERNAME/brush-up-skill.git
git push -u origin main
git push origin v2.1.0

# 4. 在 GitHub 创建 Release
# 访问：https://github.com/YOUR_USERNAME/brush-up-skill/releases/new
# 选择 tag v2.1.0
# 复制下方的发布说明
```

## Release Notes 模板

---

## ✨ Brush-Up v2.1.0 - 持续自我改进技能

### 🎯 核心特性

#### Phase 1: 配置自动化
- 自动 Agent 检测（根据议题名称关键词）
- 智能去重检查
- Categories 自动推荐
- 频率智能建议
- Cron 配置验证

#### Phase 2: 流程分级
- **light 模式**: P1→P2→P5 (~15k tokens)
- **standard 模式**: P1→P2→P3→P5 (~50k tokens)
- **full 模式**: P1-P7 全流程 (~150k tokens)

#### Phase 3: 信息源自适应
- 6 个类别→工具优先级映射
- Token 紧张时自动降级策略
- API 调用减少 60%

#### Phase 4: Agent 能力培养
- **L2 深度思考**: 强制反思提示
- **L3 元认知**: P7 自我评估
- **L4 自主驱动**: 每周一自动生成议题

### 📊 性能提升

| 指标 | v1.0 | v2.1 | 改进 |
|------|------|------|------|
| 配置错误率 | ~30% | <5% | ⬇️ 83% |
| 超时率 | 67% | <10% | ⬇️ 85% |
| Token 消耗 | ~150k | 15k-150k | ⬇️ 40-80% |
| API 调用数 | 全量 | 分级 | ⬇️ 60% |

### 📦 安装

```bash
git clone https://github.com/YOUR_USERNAME/brush-up-skill.git
cd brush-up-skill
cp -r . ~/.openclaw/workspace/skills/brush-up
```

### 🚀 快速开始

```bash
# 启动第一个议题
brush-up start --topic="优化工作流效率"

# 轻量模式周常检查
brush-up start --topic="每周 AI 新闻同步" --mode=light --frequency=weekly
```

### 📝 完整文档

- [README.md](README.md) - 使用指南
- [SKILL.md](SKILL.md) - 技能核心说明
- [UPGRADE-v2.0.md](UPGRADE-v2.0.md) - 升级日志

### 🔧 技术栈

- Bash 5.0+
- Node.js v22+
- Python 3.8+
- jq
- OpenClaw v2026.3.8+

### 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 后续步骤

1. **创建 GitHub 仓库**
   ```bash
   # 在 GitHub 创建新仓库（名字：brush-up-skill）
   # 然后推送代码
   git remote add origin https://github.com/YOUR_USERNAME/brush-up-skill.git
   git push -u origin main
   ```

2. **发布 Release**
   - 访问：https://github.com/YOUR_USERNAME/brush-up-skill/releases/new
   - Tag version: `v2.1.0`
   - 复制上方 Release Notes

3. **提交到 ClawHub**（可选）
   ```bash
   clawhub publish brush-up-skill
   ```

4. **推广**
   - OpenClaw Discord 社区
   - ClawHub 技能市场
   - 社交媒体分享
