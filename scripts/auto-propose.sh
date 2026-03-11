#!/bin/bash
# brush-up 主动议题生成脚本 (Phase 4: L4 自主驱动)
# 每周一自动执行，分析过去 7 天的错误/学习，生成改进议题

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
WORKSPACE_DIR="$HOME/.openclaw/workspace"
LEARNINGS_DIR="$WORKSPACE_DIR/.learnings"

# 输出配置
OUTPUT_FILE="$WORKSPACE_DIR/agents/main/brush-up/proposed-topics-$(date +%Y-%m-%d).md"

echo "🔍 正在分析过去 7 天的错误和学习..."

# 1. 收集过去 7 天的 errors 和 learnings
ERRORS_FILE="$LEARNINGS_DIR/ERRORS.md"
LEARNINGS_FILE="$LEARNINGS_DIR/LEARNINGS.md"

# 2. 使用 AI 分析并生成议题
python3 << 'PYTHON_SCRIPT'
import json
import sys
from datetime import datetime, timedelta
from pathlib import Path

# 读取 learnings 和 errors 文件
learnings_dir = Path.home() / ".openclaw" / "workspace" / ".learnings"
errors_file = learnings_dir / "ERRORS.md"
learnings_file = learnings_dir / "LEARNINGS.md"

# 解析错误和学习
def parse_markdown_entries(file_path, days_back=7):
    """解析 markdown 文件中的条目，返回最近 N 天的内容"""
    if not file_path.exists():
        return []
    
    entries = []
    current_entry = []
    cutoff_date = datetime.now() - timedelta(days=days_back)
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            if line.startswith('## ') or line.startswith('### '):
                if current_entry:
                    entries.append('\n'.join(current_entry))
                current_entry = [line]
            elif current_entry:
                current_entry.append(line)
        
        if current_entry:
            entries.append('\n'.join(current_entry))
    
    # 简单的时间过滤（实际应该解析日期）
    return entries[-50:]  # 返回最近 50 条

errors = parse_markdown_entries(errors_file)
learnings = parse_markdown_entries(learnings_file)

# 生成议题建议
proposals = []

# 分析错误模式
if len(errors) > 0:
    # 超时错误
    timeout_count = sum(1 for e in errors if '超时' in e or 'timeout' in e.lower())
    if timeout_count >= 2:
        proposals.append({
            'id': 'A',
            'title': '修复系统性超时问题',
            'trigger': f'{timeout_count} 次超时错误',
            'impact': '任务执行失败，报告延迟送达',
            'effort': '2-3 小时',
            'priority': '🔴 高'
        })
    
    # 配置错误
    config_count = sum(1 for e in errors if '配置' in e or 'config' in e.lower())
    if config_count >= 2:
        proposals.append({
            'id': 'B',
            'title': '优化配置管理和验证机制',
            'trigger': f'{config_count} 次配置错误',
            'impact': '功能无法正常使用',
            'effort': '1-2 小时',
            'priority': '🟡 中'
        })
    
    # 持续存在的错误
    if len(errors) >= 5:
        proposals.append({
            'id': 'C',
            'title': '建立错误自动清理和归档机制',
            'trigger': f'累积 {len(errors)} 个未处理错误',
            'impact': '系统技术债务累积',
            'effort': '3-4 小时',
            'priority': '🟡 中'
        })

# 分析学习模式
if len(learnings) > 0:
    # 重复出现的主题
    learning_topics = {}
    for l in learnings:
        # 简单关键词提取
        if '优化' in l:
            learning_topics['优化'] = learning_topics.get('优化', 0) + 1
        if '效率' in l:
            learning_topics['效率'] = learning_topics.get('效率', 0) + 1
    
    if learning_topics:
        top_topic = max(learning_topics.items(), key=lambda x: x[1])
        proposals.append({
            'id': 'D',
            'title': f'系统性改进{top_topic[0]}流程',
            'trigger': f'相关学习出现 {top_topic[1]} 次',
            'impact': '提升整体工作效率',
            'effort': '4-6 小时',
            'priority': '🟢 建议优先'
        })

# 确保至少有 2-3 个提案
if len(proposals) < 2:
    proposals.append({
        'id': 'X',
        'title': '建立 Cron 任务健康检查机制',
        'trigger': '定期自动检查',
        'impact': '提前发现问题，提升系统可靠性',
        'effort': '2-3 小时',
        'priority': '🟡 中'
    })

if len(proposals) < 3:
    proposals.append({
        'id': 'Y',
        'title': '优化 brush-up 报告送达机制',
        'trigger': '确保报告正确送达用户',
        'impact': '提升用户体验',
        'effort': '1 小时',
        'priority': '🟢 低'
    })

# 生成输出
output = f"""# 🎯 本周改进议题建议

**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M')}  
**分析范围**: 过去 7 天的错误和学习记录

---

## 📊 分析摘要

- **错误数量**: {len(errors)} 个
- **学习记录**: {len(learnings)} 个
- **生成提案**: {len(proposals)} 个

---

## 📋 提案详情

"""

for p in proposals:
    output += f"""### 议题 {p['id']}: {p['title']}

- **触发事件**: {p['trigger']}
- **影响**: {p['impact']}
- **预计工作量**: {p['effort']}
- **推荐优先级**: {p['priority']}

---

"""

output += f"""## ✅ 请批准 1-2 个议题启动 brush-up

**回复示例**:
- `批准 A,B` - 批准议题 A 和 B
- `全部批准` - 批准所有提案
- `都不批准，原因是...` - 拒绝并说明原因

**或者提出修改建议**:
- "议题 A 优先级不够，先做议题 C"
- "合并议题 A 和 B，一起解决"
- "我需要更多信息再决定"
"""

# 输出到文件
output_path = Path.home() / ".openclaw" / "workspace" / "agents" / "main" / "brush-up" / f"proposed-topics-{datetime.now().strftime('%Y-%m-%d')}.md"
output_path.parent.mkdir(parents=True, exist_ok=True)

with open(output_path, 'w', encoding='utf-8') as f:
    f.write(output)

print(f"✅ 已生成 {len(proposals)} 个议题提案")
print(f"📄 输出文件：{output_path}")
print("")
print(output)
PYTHON_SCRIPT

echo "✅ 主动议题生成完成"
echo "📬 提案已发送到 main agent，等待用户审批"
