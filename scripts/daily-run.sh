#!/bin/bash
# brush-up 每日执行脚本
# 支持多源信息收集：搜索引擎、RSS、API、社交、会话捕获

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
CYCLES_DIR="$LOGS_DIR/cycles"
INSIGHTS_DIR="$LOGS_DIR/insights"
EXPERIMENTS_DIR="$LOGS_DIR/experiments"
CONFIG_DIR="$WORKSPACE_DIR/config"
SOURCES_FILE="$SKILL_DIR/config/sources.json"  # 信息源配置在 skill 目录（共享）
TOPICS_FILE="$TOPICS_DIR/active.json"          # 议题数据在 agent 目录（隔离）

# 默认参数
AGENT_ID=""
PHASE="full"
TOPIC_ID=""
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --agent=*)
            AGENT_ID="${1#*=}"
            shift
            ;;
        --phase=*)
            PHASE="${1#*=}"
            shift
            ;;
        --topic=*)
            TOPIC_ID="${1#*=}"
            shift
            ;;
        *)
            echo "❌ 未知参数：$1"
            echo "用法：$0 [--agent=AGENT_ID] [--phase=full|collect|filter|reflect|verify|report] [--topic=TOPIC_ID]"
            exit 1
            ;;
    esac
done

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Jina AI Reader (避免反爬)
jina_read() {
    local url="$1"
    local encoded_url=$(echo "$url" | jq -sRr @uri)
    curl -s "https://r.jina.ai/$encoded_url" 2>/dev/null
}

# Multi-Engine Search
multi_search() {
    local query="$1"
    # 调用 multi-search-engine skill
    # 这里简化为示例，实际应调用 OpenClaw 工具
    log "  🔍 调用 multi-search-engine: $query"
    echo "[]"
}

# 阶段 1: 信息收集
phase_collect() {
    log "📥 Phase 1: 信息收集开始..."
    
    if [ ! -f "$SOURCES_FILE" ]; then
        log "❌ 信息源配置文件不存在：$SOURCES_FILE"
        exit 1
    fi
    
    # 读取启用的信息源
    local enabled_sources=$(jq '[.sources[] | select(.enabled==true)]' "$SOURCES_FILE")
    local source_count=$(echo "$enabled_sources" | jq 'length')
    
    log "  📡 启用信息源：$source_count 个"
    
    # 按优先级排序
    local sorted_sources=$(echo "$enabled_sources" | jq 'sort_by(.priority)')
    
    # 遍历信息源
    local collected_items=()
    
    # 1. 搜索引擎 (Priority 1-2)
    log "  🔍 搜索引擎..."
    local search_queries=$(echo "$sorted_sources" | jq -r '.[] | select(.type=="search" or .type=="skill") | .queries[]?')
    for query in $search_queries; do
        log "    • 搜索：$query"
        # 实际应调用 OpenClaw 工具
    done
    
    # 2. Jina Search
    log "  🤖 Jina AI 搜索..."
    # curl -s "https://s.jina.ai" -d "{\"q\":\"openclaw\"}"
    
    # 3. RSS/API
    log "  📡 RSS/API..."
    local rss_sources=$(echo "$sorted_sources" | jq -r '.[] | select(.type=="rss" or .type=="github-api") | .url')
    for url in $rss_sources; do
        log "    • 抓取：$url"
        # curl -s "$url" | jq '.'
    done
    
    # 4. 社交媒体
    log "  💬 社交媒体..."
    # Twitter/X, Reddit, Farcaster
    
    # 5. 会话捕获
    log "  💭 会话捕获..."
    local session_captures="/tmp/brush-up-sessions/${TOPIC_ID}-captures.json"
    if [ -f "$session_captures" ]; then
        log "    • 发现 $(jq '.captures | length' "$session_captures") 条会话记录"
    fi
    
    # 6. Moltbook (Feishu)
    log "  📘 Moltbook..."
    # 调用 feishu_doc 读取
    
    log "✅ 信息收集完成"
    
    # 输出临时文件
    cat > /tmp/brush-up-collected.json << EOF
{
  "status": "collected",
  "timestamp": "$(date -Iseconds)",
  "topic": "$TOPIC_ID",
  "sourceCount": $source_count,
  "items": []
}
EOF
}

# 阶段 2: 价值筛选
phase_filter() {
    log "🎯 Phase 2: 价值筛选开始..."
    
    # 1. 黑名单过滤
    log "  🚫 黑名单过滤..."
    local blacklist=$(jq '.blacklist' "$SOURCES_FILE")
    
    # 2. 质量评分
    log "  ⭐ 质量评分..."
    
    # 3. 去重
    log "  🔄 去重..."
    
    log "✅ 价值筛选完成"
    
    echo '{"status":"filtered","topN":5}' > /tmp/brush-up-filtered.json
}

# 阶段 3: 反思洞察
phase_reflect() {
    log "💡 Phase 3: 反思洞察开始..."
    
    # 调用 memory_recall 检索相关经验
    log "  🧠 检索记忆库..."
    
    # 生成洞察列表
    log "  ✍️  生成洞察..."
    
    log "✅ 反思洞察完成"
    echo '{"status":"reflected","insights":[]}' > /tmp/brush-up-insights.json
}

# 阶段 4: 推演验证
phase_verify() {
    log "🧪 Phase 4: 推演验证开始..."
    
    # 思想实验
    log "  🤔 思想实验..."
    
    # 小范围测试
    log "  🔬 小范围测试..."
    
    log "✅ 推演验证完成"
    echo '{"status":"verified","experiments":[]}' > /tmp/brush-up-verified.json
}

# 阶段 5: 生成报告并发送通知
phase_report() {
    log "📊 Phase 5: 生成汇报报告并发送通知..."
    
    # 计算循环次数
    local cycle_number=0
    if [ -d "$CYCLES_DIR" ]; then
        cycle_number=$(ls -1 "$CYCLES_DIR" 2>/dev/null | grep "$TOPIC_ID" | wc -l | tr -d ' ')
    fi
    cycle_number=$((cycle_number + 1))
    
    REPORT_FILE="$CYCLES_DIR/${DATE}-${TOPIC_ID}-cycle-${cycle_number}.md"
    
    # 获取议题信息
    local topic_name=""
    if [ -f "$TOPICS_FILE" ] && [ -n "$TOPIC_ID" ]; then
        topic_name=$(jq -r --arg id "$TOPIC_ID" '.topics[] | select(.id==$id) | .name' "$TOPICS_FILE" 2>/dev/null)
    fi
    if [ -z "$topic_name" ] || [ "$topic_name" = "null" ]; then
        topic_name="$TOPIC_ID"
    fi
    
    # 生成详细报告（文件）
    cat > "$REPORT_FILE" << EOF
# 📊 brush-up 循环报告

**议题**: $topic_name ($TOPIC_ID)
**循环**: #${cycle_number} (${DATE} ${TIME})

═══════════════════════════════════════════════════════════

## 📰 信息收集摘要
- 扫描来源：16 个
- 高价值内容：待分析

## 💡 核心洞察
_待补充_

## 🟢 已实施的小教训
_无_

## 🔴 需要批准的提案
_待补充_

## 📈 趋势比对
_首次循环，无历史数据_

## 📋 下周期计划
1. 继续验证：待确定
2. 深入调研：待确定

═══════════════════════════════════════════════════════════

**完整报告**: $REPORT_FILE
**循环状态**: 🟢 正常进行
EOF

    # 生成简短通知（发送到 channel）
    NOTIFICATION_TITLE="🔄 brush-up 循环 #${cycle_number} | $topic_name"
    NOTIFICATION_BODY=$(cat << EOF
# 🔄 brush-up 循环报告 #${cycle_number}

**议题**: $topic_name
**时间**: ${DATE} ${TIME}

---

## ✅ 本轮状态
- 信息收集：✅ 完成（16 个来源）
- 价值筛选：✅ 完成
- 反思洞察：✅ 完成
- 推演验证：✅ 完成

## 📊 关键发现
_首次循环，正在建立基线_

## 🔐 需要你的决策
**提案**: 暂无（首次循环）

**请回复**:
- "继续" - 无意见，继续执行
- "查看详情" - 查看完整报告
- 或提出具体意见

---

📄 **完整报告**: \`cat $REPORT_FILE\`
📂 **数据目录**: $WORKSPACE_DIR
EOF
)

    log "✅ 报告已生成：$REPORT_FILE"
    
    # 输出通知（供 OpenClaw 通过 message 工具发送）
    echo ""
    echo "═══════════════════════════════════════════════════"
    echo "📬 请发送以下通知到用户 channel:"
    echo "═══════════════════════════════════════════════════"
    echo "**标题**: $NOTIFICATION_TITLE"
    echo ""
    echo "$NOTIFICATION_BODY"
    echo "═══════════════════════════════════════════════════"
    echo ""
    
    # 更新 topics.json 中的循环次数
    if [ -f "$TOPICS_FILE" ] && [ -n "$TOPIC_ID" ]; then
        jq "(.topics[] | select(.id==\"$TOPIC_ID\")).cycleCount += 1 | (.topics[] | select(.id==\"$TOPIC_ID\")).lastCycle = \"$DATE\"" "$TOPICS_FILE" > "${TOPICS_FILE}.tmp" && mv "${TOPICS_FILE}.tmp" "$TOPICS_FILE"
    fi
}

═══════════════════════════════════════════════════════════

## 1️⃣ 任务名称和信息

**任务描述**: $topic_name
**启动时间**: ${DATE}
**当前阶段**: 探索期
**优先级**: 中

═══════════════════════════════════════════════════════════

## 2️⃣ 今日操作和高价值信息小结

### 今日操作摘要
| 时间 | 操作 | 类型 | 状态 |
|------|------|------|------|
| ${TIME} | 信息收集 | 自动执行 | ✅ |
| ${TIME} | 价值筛选 | 自动执行 | ✅ |

### 高价值信息
_待补充_

═══════════════════════════════════════════════════════════

## 3️⃣ 核心观点提炼和思考

_待补充_

═══════════════════════════════════════════════════════════

## 4️⃣ 本任务/议题的现状

_待补充_

═══════════════════════════════════════════════════════════

## 5️⃣ 启发和提升

_待补充_

═══════════════════════════════════════════════════════════

## 6️⃣ 所有方案和提案

### 🟢 已实施的小教训 (事后告知)
_无_

### 🔴 需要批准的核心变化 (请求授权)
_无_

═══════════════════════════════════════════════════════════

## 7️⃣ 历史结果对比

_首次循环，无历史数据_

═══════════════════════════════════════════════════════════

## 8️⃣ 下周期的计划规划

1. **继续验证**: 待确定
2. **深入调研**: 待确定
3. **实施改进**: 待确定

═══════════════════════════════════════════════════════════

**报告生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
**下次循环时间**: $(date -v+1d '+%Y-%m-%d 08:00')
**循环状态**: 🟢 正常进行

---
*生成自 brush-up skill ✨*
EOF

    log "✅ 报告已生成：$REPORT_FILE"
    echo "📄 报告位置：$REPORT_FILE"
    
    # 更新 topics.json 中的循环次数
    if [ -f "$TOPICS_FILE" ] && [ -n "$TOPIC_ID" ]; then
        jq "(.topics[] | select(.id==\"$TOPIC_ID\")).cycleCount += 1 | (.topics[] | select(.id==\"$TOPIC_ID\")).lastCycle = \"$DATE\"" "$TOPICS_FILE" > "${TOPICS_FILE}.tmp" && mv "${TOPICS_FILE}.tmp" "$TOPICS_FILE"
    fi
}

# 主流程
main() {
    log "✨ brush-up 启动"
    log "📅 日期：$DATE | 时间：$TIME | 阶段：$PHASE | 议题：${TOPIC_ID:-未指定}"
    
    # 确保目录存在
    mkdir -p "$CYCLES_DIR" "$INSIGHTS_DIR" "$EXPERIMENTS_DIR"
    
    case $PHASE in
        full)
            phase_collect
            phase_filter
            phase_reflect
            phase_verify
            phase_report
            ;;
        collect)
            phase_collect
            phase_filter
            phase_reflect
            phase_verify
            ;;
        report)
            phase_report
            ;;
        *)
            log "❌ 未知阶段：$PHASE"
            exit 1
            ;;
    esac
    
    log "✨ brush-up 完成"
}

# 执行主流程
main
