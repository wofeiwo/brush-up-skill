# Brush-Up 使用示例

> 实际使用场景和示例

---

## 基础示例

### 启动一个学习类议题

```bash
brush-up start --topic="学习 React 新特性"
```

系统自动推荐：
- Agent: main
- 类别: ai-tech, general-news
- 频率: weekly
- 模式: standard

### 启动一个优化类议题

```bash
brush-up start --topic="优化工作流程效率"
```

系统自动推荐：
- Agent: main
- 类别: openclaw-ecosystem, dev-tools
- 频率: weekly（机制优化类）
- 模式: standard

### 多 Channel 环境必需指定渠道

```bash
brush-up start --topic="市场趋势分析" --channel="telegram:123456789"
```

---

## 高级示例

### 完整参数启动

```bash
brush-up start \
  --topic="系统架构优化" \
  --agent=main \
  --categories="dev-tools,ai-tech" \
  --frequency=weekly \
  --mode=full \
  --priority=high \
  --channel="telegram:123456789"
```

### 使用轻量模式（快速同步）

```bash
brush-up start --topic="每周 AI 新闻" --mode=light
```

适用场景：
- 信息同步类任务
- 不需要深度分析
- 只需要收集和筛选

### 使用完整模式（深度研究）

```bash
brush-up start --topic="重构系统架构" --mode=full
```

适用场景：
- 复杂技术决策
- 需要多维度验证
- 长期规划类议题

---

## 管理示例

### 列出所有议题

```bash
brush-up list
```

输出示例：
```
✨ brush-up 议题列表

📁 Agent: main
| ID | 名称 | 状态 | 优先级 | 循环次数 |
|----|------|------|--------|----------|
| topic-xxx | 学习 React 新特性 | active | medium | 3 |

📊 统计：总计 1 | 活跃 1 | 暂停 0
```

### 停止一个议题

```bash
brush-up stop topic-xxx
```

### 删除一个议题

```bash
brush-up rm topic-xxx
```

---

## 自动推荐逻辑

### 关键词映射

| 关键词 | Agent | 类别 | 频率 | 模式 |
|--------|-------|------|------|------|
| 新闻/同步/简报/例行 | main | general-news | daily | **light** |
| 重构/架构/系统设计 | main | dev-tools | weekly | **full** |
| 优化/改进/机制/流程 | main | openclaw-ecosystem | **weekly** | standard |
| 学习/研究/AI/技术 | main | ai-tech | weekly | standard |
| 市场/竞品/用户/趋势 | main | social-trends | daily | standard |

---

## 报告输出示例

### P5 分级汇报结构

```markdown
# 📊 Brush-Up 循环报告

**议题**: 优化工作流程效率
**循环**: #3 (2026-03-12)

## 1️⃣ 议题名称和信息
[议题背景和目标]

## 2️⃣ 今日操作和高价值信息小结
[收集到的关键信息]

## 3️⃣ 核心观点提炼和思考
[深度反思三问的回答]

## 4️⃣ 本任务/议题的现状
[当前进展]

## 5️⃣ 启发和提升
[对比优缺点]

## 6️⃣ 所有方案和提案
| 提案 | 内容 | 风险 | 建议 |
|------|------|------|------|
| A | ... | 🟢 低 | ✅ 批准 |
| B | ... | 🟡 中 | 🤔 试点 |

## 7️⃣ 历史结果对比
[与上周对比]

## 8️⃣ 下周期的计划规划
[下一步行动]
```

---

## 最佳实践

1. **议题聚焦**: 一次 1-2 个活跃议题
2. **及时响应**: 每晚查看报告
3. **定期回顾**: 每周回顾趋势
4. **适度授权**: 低风险改进可批量授权
5. **及时清理**: 完成的议题及时 stop/rm
6. **多 channel 必需**: 使用 `--channel` 参数确保报告送达

---

*✨ 每天进步一点点*
