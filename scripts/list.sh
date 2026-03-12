#!/bin/bash
# brush-up 列出所有议题
# 支持多 Agent 隔离，读取所有 agent 目录下的 active.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Agent 数据目录根
AGENTS_DIR="$HOME/.openclaw/workspace/agents"

# 检查是否有 --all 参数（读取所有 agent）
SHOW_ALL=false
if [ "$1" = "--all" ]; then
    SHOW_ALL=true
fi

echo "✨ brush-up 议题列表"
echo ""

# 查找所有 active.json 文件
TOTAL_TOPICS=0
ACTIVE_COUNT=0
PAUSED_COUNT=0

# 如果没有 agent 目录，显示空
if [ ! -d "$AGENTS_DIR" ]; then
    echo "ℹ️  暂无议题"
    echo ""
    echo "启动新议题：brush-up start --topic=\"议题名称\""
    exit 0
fi

# 遍历所有 agent 目录
FIRST_AGENT=true
for AGENT_DIR in "$AGENTS_DIR"/*/brush-up/topics/active.json; do
    # 检查文件是否存在
    if [ ! -f "$AGENT_DIR" ]; then
        continue
    fi
    
    # 提取 agent 名称
    AGENT_NAME=$(echo "$AGENT_DIR" | sed 's|.*/agents/\([^/]*\)/.*|\1|')
    
    # 检查是否有议题
    TOPIC_COUNT=$(jq '.topics | length' "$AGENT_DIR" 2>/dev/null || echo "0")
    if [ "$TOPIC_COUNT" -eq 0 ]; then
        continue
    fi
    
    # 打印 agent 分隔线（如果不是第一个）
    if [ "$FIRST_AGENT" = false ]; then
        echo ""
    fi
    FIRST_AGENT=false
    
    echo "📁 Agent: $AGENT_NAME"
    echo ""
    
    # 打印表头
    echo "| ID | 名称 | 状态 | 优先级 | 循环次数 | 最后运行 |"
    echo "|----|------|------|--------|----------|----------|"
    
    # 打印该 agent 的所有议题
    jq -r '.topics[] | "| \(.id) | \(.name) | \(.status) | \(.priority) | \(.cycleCount) | \(.lastCycle // \"从未\") |"' "$AGENT_DIR"
    
    # 统计
    AGENT_ACTIVE=$(jq '[.topics[] | select(.status=="active")] | length' "$AGENT_DIR")
    AGENT_PAUSED=$(jq '[.topics[] | select(.status=="paused")] | length' "$AGENT_DIR")
    
    TOTAL_TOPICS=$((TOTAL_TOPICS + TOPIC_COUNT))
    ACTIVE_COUNT=$((ACTIVE_COUNT + AGENT_ACTIVE))
    PAUSED_COUNT=$((PAUSED_COUNT + AGENT_PAUSED))
done

# 如果没有找到任何议题
if [ "$TOTAL_TOPICS" -eq 0 ]; then
    echo "ℹ️  暂无议题"
    echo ""
    echo "启动新议题：brush-up start --topic=\"议题名称\""
    exit 0
fi

echo ""
echo "📊 统计：总计 $TOTAL_TOPICS | 活跃 $ACTIVE_COUNT | 暂停 $PAUSED_COUNT"
echo ""
echo "💡 提示:"
echo "   • 查看详情：brush-up status <ID>"
echo "   • 停止议题：brush-up stop <ID>"
echo "   • 删除议题：brush-up rm <ID>"
echo "   • 启动新议题：brush-up start --topic=\"名称\""
