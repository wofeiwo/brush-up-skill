#!/bin/bash
# brush-up 停止议题（保留记录，可随时恢复）
# 支持多 Agent 隔离

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 数据目录：按 Agent 隔离
AGENTS_DIR="$HOME/.openclaw/workspace/agents"

TOPIC_ID="$1"
AGENT_ID="$2"  # 可选，指定 agent

if [ -z "$TOPIC_ID" ]; then
    echo "❌ 必须提供议题 ID"
    echo ""
    echo "用法：brush-up stop <TOPIC_ID> [AGENT_ID]"
    echo ""
    echo "查看议题列表：brush-up list"
    exit 1
fi

# 如果没有指定 agent，尝试在所有 agent 中查找
if [ -z "$AGENT_ID" ]; then
    FOUND_AGENT=""
    FOUND_FILE=""
    for AGENT_CHECK in "$AGENTS_DIR"/*/brush-up/topics/active.json; do
        if [ -f "$AGENT_CHECK" ]; then
            if jq -e ".topics[] | select(.id==\"$TOPIC_ID\")" "$AGENT_CHECK" > /dev/null 2>&1; then
                FOUND_AGENT=$(echo "$AGENT_CHECK" | sed 's|.*/agents/\([^/]*\)/.*|\1|')
                FOUND_FILE="$AGENT_CHECK"
                break
            fi
        fi
    done
    
    if [ -z "$FOUND_AGENT" ]; then
        echo "❌ 议题 '$TOPIC_ID' 不存在"
        echo ""
        echo "查看议题列表：brush-up list"
        exit 1
    fi
    
    AGENT_ID="$FOUND_AGENT"
    TOPICS_FILE="$FOUND_FILE"
else
    # 指定了 agent
    TOPICS_FILE="$AGENTS_DIR/$AGENT_ID/brush-up/topics/active.json"
    if [ ! -f "$TOPICS_FILE" ]; then
        echo "❌ Agent '$AGENT_ID' 没有 brush-up 数据"
        exit 1
    fi
    if ! jq -e ".topics[] | select(.id==\"$TOPIC_ID\")" "$TOPICS_FILE" > /dev/null 2>&1; then
        echo "❌ 议题 '$TOPIC_ID' 不存在于 agent '$AGENT_ID'"
        exit 1
    fi
fi

echo "⏸️  正在停止议题 '$TOPIC_ID' (Agent: $AGENT_ID)..."

# 1. 删除 OpenClaw Cron 任务
echo "   • 删除 OpenClaw Cron 任务..."
CRON_CONFIG_FILE="$AGENTS_DIR/$AGENT_ID/brush-up/config/cron-jobs.json"

DELETED_JOBS=0

# 方式1: 从 cron-jobs.json 读取并删除
if [ -f "$CRON_CONFIG_FILE" ]; then
    for job_id in $(jq -r ".jobs[] | select(.topic == \"$TOPIC_ID\") | .id" "$CRON_CONFIG_FILE" 2>/dev/null); do
        if [ -n "$job_id" ] && [ "$job_id" != "null" ]; then
            if openclaw cron rm "$job_id" 2>/dev/null; then
                echo "      - 已删除：$job_id"
                DELETED_JOBS=$((DELETED_JOBS + 1))
            fi
        fi
    done
    # 从配置中移除该议题的 jobs
    jq "del(.jobs[] | select(.topic == \"$TOPIC_ID\"))" "$CRON_CONFIG_FILE" > "${CRON_CONFIG_FILE}.tmp" && mv "${CRON_CONFIG_FILE}.tmp" "$CRON_CONFIG_FILE"
fi

# 方式2: 如果 json 中没有记录，尝试从 openclaw 列表中查找
if [ "$DELETED_JOBS" -eq 0 ]; then
    echo "   • 在 openclaw 中搜索相关任务..."
    for job_id in $(openclaw cron list 2>/dev/null | grep -i "$TOPIC_ID" | awk '{print $1}'); do
        if [ -n "$job_id" ]; then
            if openclaw cron rm "$job_id" 2>/dev/null; then
                echo "      - 已删除：$job_id"
                DELETED_JOBS=$((DELETED_JOBS + 1))
            fi
        fi
    done
fi

if [ "$DELETED_JOBS" -eq 0 ]; then
    echo "      - 未找到相关 cron 任务（可能已删除）"
else
    echo "      - 共删除 $DELETED_JOBS 个任务"
fi

# 2. 禁用 Hook（不删除文件）
echo "   • 禁用 Hook..."
HOOK_FILE="$HOME/.openclaw/hooks/brush-up-${TOPIC_ID}.js"
if [ -f "$HOOK_FILE" ]; then
    mv "$HOOK_FILE" "${HOOK_FILE}.disabled"
    echo "      - 已禁用：$HOOK_FILE"
fi

# 3. 更新状态
echo "   • 更新状态..."
jq "(.topics[] | select(.id==\"$TOPIC_ID\")).status = \"paused\"" "$TOPICS_FILE" > "${TOPICS_FILE}.tmp" && mv "${TOPICS_FILE}.tmp" "$TOPICS_FILE"

echo ""
echo "✅ 议题已停止"
echo ""
echo "💡 恢复议题：brush-up start --id=$TOPIC_ID"
echo "   删除议题：brush-up rm $TOPIC_ID"
