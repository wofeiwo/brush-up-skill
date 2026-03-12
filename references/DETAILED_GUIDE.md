# Brush-Up 详细参考文档

> 补充 SKILL.md 的详细内容，包括完整示例、常见错误、经验教训等。

---

## 📚 完整使用示例

### 基础用法

```bash
# 最简单的方式
brush-up start --topic="优化工作流"

# 指定投递渠道（多 channel 环境必需）
brush-up start --topic="优化工作流" --channel="telegram:CHAT_ID"

# 指定 agent
brush-up start --topic="交易止损优化" --agent=finance-agent

# 使用模板
brush-up start --topic="学习 LLM 优化" --template=learn-ai-tech

# 完整参数
brush-up start \
  --topic="优化工作流程" \
  --agent=main \
  --categories="openclaw-ecosystem,dev-tools" \
  --frequency=weekly \
  --mode=standard \
  --priority=high \
  --channel="telegram:CHAT_ID"
```

---

## ❌ 常见错误与修复

### 错误 1: Channel is required when multiple channels are configured

**症状**:
```
error: "Channel is required when multiple channels are configured: telegram, feishu
Set delivery.channel explicitly or use a main session with a previous channel."
```

**原因**: OpenClaw 配置了多个 channel，但 cron 任务没有指定 `--channel` 参数

**修复**:
```bash
# 1. 删除现有任务
openclaw cron rm <job-id>

# 2. 使用 --channel 重新创建
brush-up start --topic="优化工作流" --channel="telegram:CHAT_ID"
```

**预防**: 多 channel 环境下，始终使用 `--channel` 参数启动议题

---

### 错误 2: 议题名称重复

**症状**:
```
⚠️  警告：发现同名议题 'xxx'
建议：使用 brush-up rm xxx 删除后重新创建，或修改议题名称
```

**原因**: 相同名称的议题已存在

**修复**: 修改议题名称或先删除旧议题

---

### 错误 3: Cron 任务超时

**症状**: 任务状态为 `error`，错误信息包含 `timed out`

**原因**:
- 信息收集阶段工具调用过多
- 网络延迟或 API 响应慢
- Timeout 设置过短

**修复**:
1. 使用轻量模式：`--mode=light`（timeout: 10分钟）
2. 减少类别范围：`--categories=ai-tech` 而不是多个类别
3. 手动增加 timeout：编辑 `~/.openclaw/workspace/agents/{agent}/brush-up/config/cron-jobs.json`

---

## 🧠 经验教训

### 教训 1: 多 Channel 配置必须显式指定 Channel

**时间**: 2026-03-12
**触发**: brush-up v2.0 在多 channel 环境下创建 cron 任务失败
**详情**:

在 brush-up skill 中创建 cron 任务时，如果 OpenClaw 配置了多个 channel（如 telegram + feishu），必须显式指定 `--channel` 参数，否则任务会报错：

```
Channel is required when multiple channels are configured: telegram, feithu
```

**修复方案**:
1. 在 start.sh 中添加 `--channel` 参数支持
2. 将 channel 参数传递给 `openclaw cron add` 命令
3. 在 SKILL.md 中添加相关文档

**推广建议**:
- 审核其他创建 cron 任务的 skill/script，确保都处理了 channel 参数
- 在文档中明确标注这种边界情况

---

### 教训 2: Cron 任务孤儿问题

**时间**: 2026-03-12
**触发**: 发现 `~/.openclaw/cron/brush-up.json` 中的任务与 active.json 不匹配
**详情**:

议题配置（active.json）和 cron 任务可能不同步：
- 手动删除议题时可能忘记删除对应 cron 任务
- 议题名称变更后 cron 任务中的名称未同步

**解决方案**:
1. 使用 `openclaw cron list` 检查实际运行的任务
2. 定期对比 `active.json` 和 cron 任务列表
3. 清理孤儿任务：`openclaw cron rm <job-id>`

---

### 教训 3: 报告投递失败 silent drop

**时间**: 2026-03-12
**触发**: Token 消耗监控任务报错 `⚠️ ✉️ Message failed`
**详情**:

Cron 任务执行成功，但报告未送达：
```json
{
  "status": "error",
  "error": "⚠️ ✉️ Message failed",
  "deliveryStatus": "not-delivered"
}
```

**原因**: 多 channel 环境下未指定 channel，消息无法投递

**修复**: 删除并重建任务，添加 `--channel` 参数

---

## 🔧 调试技巧

### 查看 Cron 任务运行日志

```bash
# 查看任务运行历史
openclaw cron runs --id <job-id>

# 查看最近一条记录
openclaw cron runs --id <job-id> | jq '.entries[-1]'

# 查看错误信息
openclaw cron runs --id <job-id> | jq '.entries[-1].error'
```

### 手动触发测试

```bash
# 立即执行一次 cron 任务（调试用）
openclaw cron run --id <job-id>
```

### 检查 Channel 配置

```bash
# 查看 OpenClaw 配置了哪些 channel
openclaw config get channels

# 查看当前 channel 列表
openclaw status
```

---

## 📊 性能优化建议

### Token 消耗优化

| 策略 | 效果 | 实施方式 |
|------|------|----------|
| 使用轻量模式 | 减少 60% token | `--mode=light` |
| 减少类别范围 | 减少 40% token | `--categories=ai-tech` |
| 调整循环频率 | 减少 57% 循环 | `--frequency=weekly` |
| 自适应工具选择 | 减少 60% API 调用 | 自动（按类别映射） |

### Timeout 设置建议

| 模式 | 建议 Timeout | 适用场景 |
|------|-------------|----------|
| light | 600s (10分钟) | 简单议题、信息同步 |
| standard | 1800s (30分钟) | 大多数议题 |
| full | 3600s (1小时) | 复杂研究、季度复盘 |

---

## 🔗 相关链接

- **SKILL.md**: [SKILL.md](../SKILL.md) - 主文档
- **EXAMPLES.md**: [EXAMPLES.md](./EXAMPLES.md) - 使用示例
- **sources.json**: [../config/sources.json](../config/sources.json) - 信息源配置

---

*最后更新: 2026-03-12*

---

## ✅ 已实施的改进提案

### 提案 A: 流程分级默认策略 (2026-03-12)
**状态**: ✅ 已实施
**位置**: `scripts/start.sh`

根据议题关键词自动推荐默认流程模式：

| 关键词 | 推荐模式 | 说明 |
|--------|---------|------|
| 新闻/同步/简报/例行/检查 | light | 信息同步类，快速处理 |
| 重构/架构/系统设计/季度复盘 | full | 复杂议题，深度研究 |
| 其他 | standard | 默认，平衡深度和效率 |

---

### 提案 B: 频率自动推荐 (2026-03-12)
**状态**: ✅ 已实施  
**位置**: `scripts/start.sh`

根据议题类型自动推荐循环频率：

| 关键词 | 推荐频率 | 说明 |
|--------|---------|------|
| 优化/改进/机制/流程 | weekly | 机制类每周一次足够 |
| 交易/市场/监控 | daily | 市场类需要每日跟踪 |
| 其他 | daily | 默认每日 |

---

### 提案 C: L2 强制反思提示 (2026-03-12)
**状态**: ✅ 已实施
**位置**: `SKILL.md`

在 P1/P3/P5 阶段插入强制性反思提示，Agent 必须回答：

- **P1**: 信息收集策略说明（选什么工具，为什么）
- **P3**: 深度反思三问（意外发现、实际价值、一句话总结）
- **P5**: 提案价值自检（3点优势、2点风险、用户视角）

**效果**: 防止 Agent 被动执行，强制深度思考

---

### 提案 D: L4 自主议题生成
**状态**: ⏸️ 待定（需试点/讨论）

Agent 主动分析 errors/learnings，每周生成备选议题。

---
