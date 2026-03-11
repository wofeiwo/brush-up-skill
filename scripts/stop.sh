#!/bin/bash
# brush-up 停止议题（保留记录，可随时恢复）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$SKILL_DIR/config"
TOPICS_FILE="$CONFIG_DIR/topics.json"

TOPIC_ID="$1"

if [ -z "$TOPIC_ID" ]; then
    echo "❌ 必须提供议题 ID"
    exit 1
fi

# 检查议题是否存在
if ! jq -e ".topics[] | select(.id==\"$TOPIC_ID\")" "$TOPICS_FILE" > /dev/null 2>&1; then
    echo "❌ 议题 '$TOPIC_ID' 不存在"
    exit 1
fi

echo "⏸️  正在停止议题 '$TOPIC_ID'..."

# 1. 删除 OpenClaw Cron 任务
echo "   • 删除 OpenClaw Cron 任务..."
CRON_CONFIG_FILE="$(dirname "$SCRIPT_DIR")/config/cron-jobs.json"
if [ -f "$CRON_CONFIG_FILE" ]; then
    # 读取 cron job IDs 并删除
    for job_id in $(jq -r '.jobs[] | select(.topic == "'$TOPIC_ID'") | .id' "$CRON_CONFIG_FILE" 2>/dev/null); do
        openclaw cron rm "$job_id" 2>/dev/null && echo "      - 已删除：$job_id"
    done
    # 清空 cron 配置
    echo '{"jobs":[]}' > "$CRON_CONFIG_FILE"
else
    # 兼容旧版本：尝试从 crontab 删除
    (crontab -l 2>/dev/null | grep -v "brush-up.*$TOPIC_ID") | crontab - 2>/dev/null || true
fi

# 2. 禁用 Hook（不删除文件）
echo "   • 禁用 Hook..."
HOOK_FILE="$HOME/.openclaw/hooks/brush-up-${TOPIC_ID}.js"
if [ -f "$HOOK_FILE" ]; then
    mv "$HOOK_FILE" "${HOOK_FILE}.disabled"
fi

# 3. 更新状态
echo "   • 更新状态..."
jq "(.topics[] | select(.id==\"$TOPIC_ID\")).status = \"paused\"" "$TOPICS_FILE" > "${TOPICS_FILE}.tmp" && mv "${TOPICS_FILE}.tmp" "$TOPICS_FILE"

echo ""
echo "✅ 议题已停止"
echo ""
echo "💡 恢复议题：brush-up start --id=$TOPIC_ID --no-create"
echo "   删除议题：brush-up rm $TOPIC_ID"
