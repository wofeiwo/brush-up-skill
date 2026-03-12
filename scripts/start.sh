#!/bin/bash
# brush-up 启动议题脚本
# 创建新议题，并按需创建 OpenClaw Cron 或 macOS plist

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# 数据目录：按 Agent 隔离（支持多 agent 独立配置）
# 优先级：1. --agent 参数  2. OPENCLAW_AGENT_ID  3. 默认 main
if [ -n "$AGENT_ID" ]; then
    WORKSPACE_DIR="$HOME/.openclaw/workspace/agents/${AGENT_ID}/brush-up"
elif [ -n "$OPENCLAW_AGENT_ID" ]; then
    WORKSPACE_DIR="$HOME/.openclaw/workspace/agents/${OPENCLAW_AGENT_ID}/brush-up"
else
    WORKSPACE_DIR="$HOME/.openclaw/workspace/agents/main/brush-up"
fi
TOPICS_DIR="$WORKSPACE_DIR/topics"
LOGS_DIR="$WORKSPACE_DIR/logs"
CONFIG_DIR="$WORKSPACE_DIR/config"
TOPICS_FILE="$TOPICS_DIR/active.json"

# 参数
TOPIC_NAME=""
TOPIC_ID=""
AGENT_ID=""
PRIORITY="medium"
TEMPLATE=""
CATEGORIES=""
FREQUENCY="daily"  # daily | weekly | monthly
MODE="standard"    # light | standard | full
CRON_TYPE="openclaw"  # openclaw | macos | manual
DELIVERY_CHANNEL=""  # telegram:chat_id or feishu:chat_id

# OpenClaw Cron 配置目录
OPENCLAW_CRON_DIR="$HOME/.openclaw/cron"
BRUSHUP_CRON_FILE="$OPENCLAW_CRON_DIR/brush-up.json"

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --topic=*)
            TOPIC_NAME="${1#*=}"
            shift
            ;;
        --id=*)
            TOPIC_ID="${1#*=}"
            shift
            ;;
        --agent=*)
            AGENT_ID="${1#*=}"
            shift
            ;;
        --priority=*)
            PRIORITY="${1#*=}"
            shift
            ;;
        --template=*)
            TEMPLATE="${1#*=}"
            shift
            ;;
        --categories=*)
            CATEGORIES="${1#*=}"
            shift
            ;;
        --frequency=*)
            FREQUENCY="${1#*=}"
            shift
            ;;
        --mode=*)
            MODE="${1#*=}"
            shift
            ;;
        --cron=*)
            CRON_TYPE="${1#*=}"
            shift
            ;;
        --channel=*)
            DELIVERY_CHANNEL="${1#*=}"
            shift
            ;;
        *)
            echo "❌ 未知参数：$1"
            exit 1
            ;;
    esac
done

# 检查必要参数
if [ -z "$TOPIC_NAME" ]; then
    echo "❌ 必须提供议题名称：--topic=\"议题名称\""
    exit 1
fi

# 生成 ID（如果未提供）
if [ -z "$TOPIC_ID" ]; then
    # 使用 python 生成安全的 ID（避免 iconv 中文字符问题）
    TOPIC_ID=$(python3 -c "
import re, sys
name = sys.argv[1]
# 转小写，替换空格为 -
slug = name.lower().replace(' ', '-')
# 移除非法字符（只保留字母数字和 -）
slug = re.sub(r'[^a-z0-9-]', '', slug)
# 移除连续多个 -
slug = re.sub(r'-+', '-', slug)
# 移除首尾的 -
slug = slug.strip('-')
# 如果为空，使用时间戳
print(slug or f'topic-$(date +%s)')
" "$TOPIC_NAME")
fi

echo "✨ 正在启动 brush-up 议题..."
echo "   名称：$TOPIC_NAME"
echo "   ID: $TOPIC_ID"
echo "   Agent: ${AGENT_ID:-${OPENCLAW_AGENT_ID:-main}}"
echo "   优先级：$PRIORITY"
echo "   模式：$MODE"
echo "   频率：$FREQUENCY"
echo "   数据目录：$WORKSPACE_DIR"
echo "   Cron 类型：$CRON_TYPE"
echo "   投递渠道：${DELIVERY_CHANNEL:-自动检测}"

# ============================================
# Phase 1: 配置自动化
# ============================================

# 1. 自动检测 Agent（如果未指定）
if [ -z "$AGENT_ID" ] && [ -z "$OPENCLAW_AGENT_ID" ]; then
    # 根据议题名称关键词自动推荐 Agent
    if echo "$TOPIC_NAME" | grep -qiE "港股|A 股|交易|量化|Marcus"; then
        AGENT_ID="marcus"
        echo "   🤖 自动检测：议题属于 marcus agent (金融/量化类)"
    elif echo "$TOPIC_NAME" | grep -qiE "写作 | 小说 | 故事|项主任 | 小石男 | 剧毒妹"; then
        AGENT_ID="xiangzhuren"
        echo "   🤖 自动检测：议题属于 xiangzhuren agent (写作类)"
    else
        AGENT_ID="main"
        echo "   🤖 自动检测：使用 main agent (默认)"
    fi
    
    # 重新计算 WORKSPACE_DIR
    WORKSPACE_DIR="$HOME/.openclaw/workspace/agents/${AGENT_ID}/brush-up"
    TOPICS_DIR="$WORKSPACE_DIR/topics"
    TOPICS_FILE="$TOPICS_DIR/active.json"
fi

# 2. 自动推荐 Categories（如果未指定）
if [ -z "$CATEGORIES" ]; then
    if echo "$TOPIC_NAME" | grep -qiE "港股|A 股|交易 | 量化 | 止损 | 持仓"; then
        CATEGORIES="finance,ai-tech,dev-tools"
        echo "   🏷️  自动分类：finance (金融/量化类议题)"
    elif echo "$TOPIC_NAME" | grep -qiE "优化 | 改进 | 效率 | 技能|workflow|openclaw"; then
        CATEGORIES="openclaw-ecosystem,dev-tools"
        echo "   🏷️  自动分类：openclaw-ecosystem,dev-tools (优化类议题)"
    elif echo "$TOPIC_NAME" | grep -qiE "学习 | 研究 | 技术|AI|LLM|模型"; then
        CATEGORIES="ai-tech,general-news"
        echo "   🏷️  自动分类：ai-tech (学习/技术类议题)"
    elif echo "$TOPIC_NAME" | grep -qiE "市场 | 竞品 | 用户 | 趋势|social"; then
        CATEGORIES="social-trends,general-news"
        echo "   🏷️  自动分类：social-trends (市场/趋势类议题)"
    else
        CATEGORIES="general-news"
        echo "   🏷️  自动分类：general-news (默认)"
    fi
fi

# 3. 自动推荐频率（如果未指定或为默认值）
if [ "$FREQUENCY" = "daily" ]; then
    if echo "$TOPIC_NAME" | grep -qiE "优化 | 改进 | 机制 | 流程|架构"; then
        FREQUENCY="weekly"
        echo "   📅 自动频率：weekly (机制优化类建议每周)"
    elif echo "$TOPIC_NAME" | grep -qiE "港股 | 市场 | 交易 | 监控"; then
        FREQUENCY="daily"
        echo "   📅 自动频率：daily (市场监控类建议每日)"
    fi
fi

# 3.5 自动推荐流程模式（如果用户使用默认的 standard）
if [ "$MODE" = "standard" ]; then
    if echo "$TOPIC_NAME" | grep -qiE "新闻|同步|简报|例行|检查|周报|日报"; then
        MODE="light"
        echo "   🔄 自动模式：light (信息同步类建议轻量流程)"
    elif echo "$TOPIC_NAME" | grep -qiE "重构|架构|系统设计|季度复盘|年度规划|重大.*调整"; then
        MODE="full"
        echo "   🔄 自动模式：full (复杂议题建议完整流程)"
    fi
fi

# 4. 检查议题是否重复（名称相似度检测）
if [ -f "$TOPICS_FILE" ]; then
    SIMILAR_TOPIC=$(jq -r ".topics[] | select(.name==\"$TOPIC_NAME\") | .id" "$TOPICS_FILE" 2>/dev/null | head -1)
    if [ -n "$SIMILAR_TOPIC" ]; then
        echo "   ⚠️  警告：发现同名议题 '$SIMILAR_TOPIC'"
        echo "   建议：使用 brush-up rm $SIMILAR_TOPIC 删除后重新创建，或修改议题名称"
        exit 1
    fi
fi

# 处理模板或类别
ENABLED_SOURCES="[]"
if [ -n "$TEMPLATE" ]; then
    echo "   模板：$TEMPLATE"
    SOURCES_FILE="$SKILL_DIR/config/sources.json"
    if [ -f "$SOURCES_FILE" ]; then
        ENABLED_SOURCES=$(jq -r ".topicTemplates[\"$TEMPLATE\"].categories // empty" "$SOURCES_FILE" 2>/dev/null)
        if [ -z "$ENABLED_SOURCES" ]; then
            echo "⚠️  模板 '$TEMPLATE' 不存在，使用自动分类"
        fi
    fi
fi

if [ -n "$CATEGORIES" ]; then
    echo "   类别：$CATEGORIES"
    ENABLED_SOURCES=$(echo "$CATEGORIES" | tr ',' '\n' | jq -R . | jq -s .)
fi

echo ""

# 确保目录存在
mkdir -p "$TOPICS_DIR" "$LOGS_DIR/cycles" "$LOGS_DIR/insights" "$LOGS_DIR/experiments" "$CONFIG_DIR"

# 初始化 topics.json（如果不存在）
if [ ! -f "$TOPICS_FILE" ]; then
    echo '{"topics":[]}' > "$TOPICS_FILE"
fi

# 检查议题是否已存在
if jq -e ".topics[] | select(.id==\"$TOPIC_ID\")" "$TOPICS_FILE" > /dev/null 2>&1; then
    echo "⚠️  议题 '$TOPIC_ID' 已存在"
    exit 1
fi

# 添加新议题
NEW_TOPIC=$(cat << EOF
{
  "id": "$TOPIC_ID",
  "name": "$TOPIC_NAME",
  "status": "active",
  "startDate": "$(date +%Y-%m-%d)",
  "priority": "$PRIORITY",
  "categories": $([ -n "$ENABLED_SOURCES" ] && echo "$ENABLED_SOURCES" || echo '["general-news"]'),
  "cycleCount": 0,
  "lastCycle": null
}
EOF
)

# 写入 topics.json
jq ".topics += [$NEW_TOPIC]" "$TOPICS_FILE" > "${TOPICS_FILE}.tmp" && mv "${TOPICS_FILE}.tmp" "$TOPICS_FILE"

echo "✅ 议题创建成功"
echo "   📂 数据位置：$TOPICS_FILE"
echo ""

# 创建调度任务
case $CRON_TYPE in
    openclaw)
        echo "⏰ 创建 OpenClaw Cron 任务..."
        
        # 根据频率设置 Cron 表达式
        if [ "$FREQUENCY" = "weekly" ]; then
            COLLECT_CRON="0 8 * * 1"  # 周一 08:00
            REPORT_CRON="0 21 * * 1"  # 周一 21:00
            FREQ_DESC="每周一"
        elif [ "$FREQUENCY" = "monthly" ]; then
            COLLECT_CRON="0 8 1 * *"  # 每月 1 号 08:00
            REPORT_CRON="0 21 1 * *"  # 每月 1 号 21:00
            FREQ_DESC="每月 1 号"
        else
            COLLECT_CRON="0 8 * * *"  # 每日 08:00
            REPORT_CRON="0 21 * * *"  # 每日 21:00
            FREQ_DESC="每天"
        fi
        
        # 根据模式设置超时时间
        if [ "$MODE" = "light" ]; then
            TIMEOUT=600   # 10 分钟
        elif [ "$MODE" = "full" ]; then
            TIMEOUT=3600  # 1 小时
        else
            TIMEOUT=1800  # 30 分钟 (standard)
        fi
        
        # 创建两个 cron 任务：信息收集和报告生成
        echo "   创建信息收集任务 ($FREQ_DESC)..."
        
        # 构建 channel 参数
        CHANNEL_ARG=""
        if [ -n "$DELIVERY_CHANNEL" ]; then
            CHANNEL_ARG="--channel=$DELIVERY_CHANNEL"
        fi
        
        COLLECT_JOB_ID=$(openclaw cron add \
            --name="brush-up ${TOPIC_ID}_信息收集" \
            --cron="$COLLECT_CRON" \
            --agent="$AGENT_ID" \
            --message="brush-up 议题：${TOPIC_NAME} - P1 信息收集" \
            --session="isolated" \
            --description="brush-up 议题${FREQ_DESC}信息收集" \
            --tz="Asia/Shanghai" \
            --timeout="$TIMEOUT" \
            $CHANNEL_ARG \
            --json 2>&1 | jq -r '.id')
        
        echo "   创建报告生成任务 ($FREQ_DESC)..."
        REPORT_JOB_ID=$(openclaw cron add \
            --name="brush-up ${TOPIC_ID}_报告生成" \
            --cron="$REPORT_CRON" \
            --agent="$AGENT_ID" \
            --message="brush-up 议题：${TOPIC_NAME} - P5 分级汇报" \
            --session="isolated" \
            --description="brush-up 议题${FREQ_DESC}报告生成" \
            --tz="Asia/Shanghai" \
            --timeout="$TIMEOUT" \
            $CHANNEL_ARG \
            --json 2>&1 | jq -r '.id')
        
        # Phase 1: 验证 Cron 配置（检查 delivery.channel 是否配置）
        echo "   验证 Cron 配置..."
        if [ -z "$DELIVERY_CHANNEL" ]; then
            echo "   ⚠️  警告：未指定投递渠道（--channel），报告可能无法送达"
            echo "   提示：使用 --channel=telegram:chat_id 或 --channel=feishu:chat_id 指定"
            echo "   当前 cron 任务已创建，但需要在多 channel 环境下手动修复"
        else
            echo "   ✅ 投递渠道已配置：$DELIVERY_CHANNEL"
        fi
        
        # 保存 cron 配置（用于 stop/rm 时清理）
        CRON_CONFIG="$CONFIG_DIR/cron-jobs.json"
        mkdir -p "$CONFIG_DIR"
        cat > "$CRON_CONFIG" << EOF
{
  "jobs": [
    {
      "id": "$COLLECT_JOB_ID",
      "topic": "$TOPIC_ID",
      "phase": "collect",
      "schedule": "$COLLECT_CRON",
      "enabled": true,
      "mode": "$MODE",
      "timeout": $TIMEOUT,
      "channel": "$DELIVERY_CHANNEL"
    },
    {
      "id": "$REPORT_JOB_ID",
      "topic": "$TOPIC_ID",
      "phase": "report",
      "schedule": "$REPORT_CRON",
      "enabled": true,
      "mode": "$MODE",
      "timeout": $TIMEOUT,
      "channel": "$DELIVERY_CHANNEL"
    }
  ]
}
EOF
        
        echo "   ✅ OpenClaw Cron 任务已注册"
        echo "      - 信息收集：$COLLECT_JOB_ID ($FREQ_DESC)"
        echo "      - 报告生成：$REPORT_JOB_ID ($FREQ_DESC)"
        echo "      - 模式：$MODE (timeout: ${TIMEOUT}s)"
        ;;
    
    macos)
        echo "⏰ 创建 macOS LaunchAgent (plist)..."
        PLIST_DIR="$HOME/Library/LaunchAgents"
        PLIST_FILE="$PLIST_DIR/com.brushup.${TOPIC_ID}.plist"
        
        mkdir -p "$PLIST_DIR"
        
        cat > "$PLIST_FILE" << PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.brushup.${TOPIC_ID}</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>bash</string>
        <string>$SKILL_DIR/scripts/daily-run.sh</string>
        <string>--topic=$TOPIC_ID</string>
        <string>--phase=full</string>
    </array>
    
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    
    <key>StandardOutPath</key>
    <string>$LOGS_DIR/macos-cron.log</string>
    
    <key>StandardErrorPath</key>
    <string>$LOGS_DIR/macos-cron.err</string>
</dict>
</plist>
PLISTEOF
        
        # 加载 plist
        launchctl unload "$PLIST_FILE" 2>/dev/null || true
        launchctl load "$PLIST_FILE"
        
        echo "   ✅ macOS LaunchAgent 已创建：$PLIST_FILE"
        echo "   🔍 查看状态：launchctl list | grep brushup"
        ;;
    
    manual)
        echo "⏭️  跳过自动 Cron 创建（手动模式）"
        echo "   📝 手动运行：brush-up run $TOPIC_ID"
        ;;
esac

echo ""
echo "═══════════════════════════════════════"
echo "🎉 议题启动完成！"
echo ""
echo "📋 后续命令:"
echo "   • 查看状态：brush-up status $TOPIC_ID"
echo "   • 手动运行：brush-up run $TOPIC_ID"
echo "   • 停止议题：brush-up stop $TOPIC_ID"
echo "   • 删除议题：brush-up rm $TOPIC_ID"
echo ""
echo "📂 数据位置：$WORKSPACE_DIR"
echo "═══════════════════════════════════════"
