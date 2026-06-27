#!/bin/bash

# Clash 控制 API 端口，默认为 9090
CLASH_API="http://127.0.0.1:9090"
GROUP_NAME="YouTubeControl"

if grep -q '# KIDS_MODE_START' /etc/hosts; then
    # 解封本地 hosts
    sed -i '' '/# KIDS_MODE_START/,/# KIDS_MODE_END/d' /etc/hosts
    
    # 解封 Clash YouTube
    if [ -f /tmp/clash_yt_state ]; then
        PREV=$(cat /tmp/clash_yt_state)
        curl -s -X PUT -H 'Content-Type: application/json' -d "{\"name\":\"$PREV\"}" "$CLASH_API/proxies/$GROUP_NAME" > /dev/null
    fi
    
    dscacheutil -flushcache
    killall -HUP mDNSResponder
    echo '✅ 娱乐网站已解封，可以放松一下了。'
else
    # 屏蔽本地 hosts
    echo '# KIDS_MODE_START' >> /etc/hosts
    echo '127.0.0.1 www.bilibili.com' >> /etc/hosts
    echo '127.0.0.1 bilibili.com' >> /etc/hosts
    echo '127.0.0.1 search.bilibili.com' >> /etc/hosts
    echo '127.0.0.1 www.douyin.com' >> /etc/hosts
    echo '127.0.0.1 douyin.com' >> /etc/hosts
    echo '127.0.0.1 v.qq.com' >> /etc/hosts
    echo '127.0.0.1 www.iqiyi.com' >> /etc/hosts
    echo '127.0.0.1 iqiyi.com' >> /etc/hosts
    echo '127.0.0.1 www.youku.com' >> /etc/hosts
    echo '127.0.0.1 youku.com' >> /etc/hosts
    echo '# KIDS_MODE_END' >> /etc/hosts
    
    # 屏蔽 Clash YouTube
    CURRENT=$(curl -s "$CLASH_API/proxies/$GROUP_NAME" | grep -o '"now":"[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$CURRENT" ] && [ "$CURRENT" != "REJECT" ]; then
        echo "$CURRENT" > /tmp/clash_yt_state
        curl -s -X PUT -H 'Content-Type: application/json' -d '{"name":"REJECT"}' "$CLASH_API/proxies/$GROUP_NAME" > /dev/null
    fi
    
    dscacheutil -flushcache
    killall -HUP mDNSResponder
    echo '🚫 学习模式已开启，视频网站已被屏蔽。'
fi
