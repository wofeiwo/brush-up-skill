#!/bin/bash
# brush-up 列出所有议题

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$SKILL_DIR/config"
TOPICS_FILE="$CONFIG_DIR/topics.json"

echo "✨ brush-up 议题列表"
echo ""

# 检查配置文件
if [ ! -f "$TOPICS_FILE" ]; then
    echo "ℹ️  暂无议题"
    echo ""
    echo "启动新议题：brush-up start --topic=\"议题名称\""
    exit 0
fi

# 列出议题
echo "| ID | 名称 | 状态 | 优先级 | 循环次数 | 最后运行 |"
echo "|----|------|------|--------|----------|----------|"

jq -r '.topics[] | "| \(.id) | \(.name) | \(.status) | \(.priority) | \(.cycleCount) | \(.lastCycle // "从未") |"' "$TOPICS_FILE"

echo ""

# 统计
ACTIVE=$(jq '[.topics[] | select(.status=="active")] | length' "$TOPICS_FILE")
PAUSED=$(jq '[.topics[] | select(.status=="paused")] | length' "$TOPICS_FILE")
TOTAL=$(jq '.topics | length' "$TOPICS_FILE")

echo "📊 统计：总计 $TOTAL | 活跃 $ACTIVE | 暂停 $PAUSED"
echo ""
echo "💡 提示:"
echo "   • 查看详情：brush-up status <ID>"
echo "   • 停止议题：brush-up stop <ID>"
echo "   • 删除议题：brush-up rm <ID>"
echo "   • 启动新议题：brush-up start --topic=\"名称\""
