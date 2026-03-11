#!/bin/bash
# brush-up 删除议题（清理所有：Cron + Hook + 配置 + 日志）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$SKILL_DIR/config"
TOPICS_FILE="$CONFIG_DIR/topics.json"

TOPIC_ID="$1"

if [ -z "$TOPIC_ID" ]; then
    echo "❌ 必须提供议题 ID"
    echo ""
    echo "用法：$0 <TOPIC_ID>"
    echo ""
    echo "查看议题列表：brush-up list"
    exit 1
fi

# 检查议题是否存在
if ! jq -e ".topics[] | select(.id==\"$TOPIC_ID\")" "$TOPICS_FILE" > /dev/null 2>&1; then
    echo "❌ 议题 '$TOPIC_ID' 不存在"
    echo ""
    echo "查看议题列表：brush-up list"
    exit 1
fi

echo "⚠️  警告：此操作将删除议题 '$TOPIC_ID' 的所有数据"
echo ""
echo "将删除:"
echo "   • Cron 定时任务"
echo "   • Session Hook"
echo "   • 配置文件"
echo "   • 所有日志和记录"
echo ""
echo "此操作不可恢复！"
echo ""
read -p "确认删除？输入 '$TOPIC_ID' 继续：" CONFIRM

if [ "$CONFIRM" != "$TOPIC_ID" ]; then
    echo "❌ 已取消"
    exit 0
fi

echo ""
echo "🗑️  正在删除..."

# 1. 删除 OpenClaw Cron 任务
echo "   • 删除 OpenClaw Cron 任务..."
CRON_CONFIG_FILE="$(dirname "$SCRIPT_DIR")/config/cron-jobs.json"
if [ -f "$CRON_CONFIG_FILE" ]; then
    # 读取 cron job IDs 并删除
    for job_id in $(jq -r '.jobs[] | select(.topic == "'$TOPIC_ID'") | .id' "$CRON_CONFIG_FILE" 2>/dev/null); do
        openclaw cron rm "$job_id" 2>/dev/null && echo "      - 已删除：$job_id"
    done
    # 清空 cron 配置
    rm -f "$CRON_CONFIG_FILE"
else
    # 兼容旧版本：尝试从 crontab 删除
    (crontab -l 2>/dev/null | grep -v "brush-up.*$TOPIC_ID") | crontab - 2>/dev/null || true
fi

# 2. 删除 Hook
echo "   • 删除 Session Hook..."
HOOK_FILE="$HOME/.openclaw/hooks/brush-up-${TOPIC_ID}.js"
if [ -f "$HOOK_FILE" ]; then
    rm -f "$HOOK_FILE"
fi

# 3. 删除日志
echo "   • 删除日志..."
rm -rf "$SKILL_DIR/logs/cycles/"*-"$TOPIC_ID"-*
rm -rf "$SKILL_DIR/logs/insights/"*-"$TOPIC_ID"-*
rm -rf "$SKILL_DIR/logs/experiments/"*-"$TOPIC_ID"-*

# 4. 从 topics.json 删除
echo "   • 更新配置..."
jq "del(.topics[] | select(.id==\"$TOPIC_ID\"))" "$TOPICS_FILE" > "${TOPICS_FILE}.tmp" && mv "${TOPICS_FILE}.tmp" "$TOPICS_FILE"

echo ""
echo "✅ 议题 '$TOPIC_ID' 已删除"
echo ""
echo "💡 如需重新启动：brush-up start --topic=\"名称\" --id=$TOPIC_ID"
