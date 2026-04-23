#!/bin/bash

# 测试所有场景的脚本
# 确保服务已经启动: docker-compose up -d

echo "开始测试 Nginx Location & Proxy_pass 的8种场景..."
echo "=================================================="
echo

BASE_URL="http://localhost"

# 测试函数
test_scenario() {
    local scenario=$1
    local port=$2
    local description=$3

    echo "场景 ${scenario}: ${description}"
    echo "请求: GET /api/hello"
    echo "URL: ${BASE_URL}:${port}/api/hello"
    echo "响应:"
    curl -s "${BASE_URL}:${port}/api/hello" | jq .
    echo
    echo "----------------------------------------"
    echo
}

# 执行测试
test_scenario "1" "8881" "location带斜杠 + proxy_pass只有端口 + 不带斜杠"
test_scenario "2" "8882" "location带斜杠 + proxy_pass只有端口 + 带斜杠"
test_scenario "3" "8883" "location带斜杠 + proxy_pass有路径 + 不带斜杠"
test_scenario "4" "8884" "location带斜杠 + proxy_pass有路径 + 带斜杠"
test_scenario "5" "8885" "location不带斜杠 + proxy_pass只有端口 + 不带斜杠"
test_scenario "6" "8886" "location不带斜杠 + proxy_pass只有端口 + 带斜杠"
test_scenario "7" "8887" "location不带斜杠 + proxy_pass有路径 + 不带斜杠"
test_scenario "8" "8888" "location不带斜杠 + proxy_pass有路径 + 带斜杠"

echo "测试完成！"
echo
echo "请查看上面的响应，验证实际转发的URI是否符合预期。"