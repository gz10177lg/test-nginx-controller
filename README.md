# Nginx Location & Proxy_pass 测试项目

这是一个专门用于测试 Nginx 中 `location` 和 `proxy_pass` 配置组合的 Spring Boot 项目。通过这个项目，你可以清楚地了解不同配置组合下的 URL 转发规则。

## 📋 项目背景

在 Nginx 配置中，`location` 和 `proxy_pass` 的组合行为常常令人困惑。特别是以下两个可变条件的组合会产生 8 种不同的情况：

1. **location** 是否带斜杠（`/api/` vs `/api`）
2. **proxy_pass** 是否有路径以及末尾是否带斜杠

## 🎯 测试场景

项目测试以下 8 种组合：

### 场景 1: location带斜杠 + proxy_pass只有端口 + 不带斜杠
```nginx
location /api/ {
    proxy_pass http://localhost:8080;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080/api/hello`

### 场景 2: location带斜杠 + proxy_pass只有端口 + 带斜杠
```nginx
location /api/ {
    proxy_pass http://localhost:8080/;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080/hello`

### 场景 3: location带斜杠 + proxy_pass有路径 + 不带斜杠
```nginx
location /api/ {
    proxy_pass http://localhost:8080/backend;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080/backendhello`

### 场景 4: location带斜杠 + proxy_pass有路径 + 带斜杠
```nginx
location /api/ {
    proxy_pass http://localhost:8080/backend/;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080/backend/hello`

### 场景 5: location不带斜杠 + proxy_pass只有端口 + 不带斜杠
```nginx
location /api {
    proxy_pass http://localhost:8080;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080/api/hello`

### 场景 6: location不带斜杠 + proxy_pass只有端口 + 带斜杠
```nginx
location /api {
    proxy_pass http://localhost:8080/;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080//hello`

### 场景 7: location不带斜杠 + proxy_pass有路径 + 不带斜杠
```nginx
location /api {
    proxy_pass http://localhost:8080/backend;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080/backend/hello`

### 场景 8: location不带斜杠 + proxy_pass有路径 + 带斜杠
```nginx
location /api {
    proxy_pass http://localhost:8080/backend/;
}
```
- 请求: `GET /api/hello`
- 预期转发到: `http://localhost:8080/backend//hello`

## 🏗️ 项目结构

```
test-nginx-controller/
├── src/main/java/com/example/nginxcontroller/
│   ├── NginxControllerApplication.java    # 主应用程序
│   ├── controller/
│   │   └── NginxTestController.java     # 测试控制器
│   └── dto/
│       └── ResponseDTO.java              # 响应 DTO
├── pom.xml                              # Maven 配置
└── README.md                            # 项目说明
```

## 🚀 快速开始

### 环境要求

- Java 21+
- Maven 3.6+
- Docker (可选，用于容器化部署)

### 本地运行

1. 克隆项目
```bash
git clone <repository-url>
cd test-nginx-controller
```

2. 编译项目
```bash
mvn clean package
```

3. 运行 Spring Boot 应用
```bash
java -jar target/nginx-controller-1.0-SNAPSHOT.jar
```

应用将在 `http://localhost:8080` 启动

### Docker 部署

1. 构建Spring Boot应用镜像
```bash
mvn clean package
docker build -t nginx-controller-app .
```

2. 使用 docker-compose 启动所有服务
```bash
docker-compose up -d
```

## 🐳 Docker Compose 部署

项目提供了 `docker-compose.yml` 文件，一键启动所有服务：

1. Spring Boot 应用（端口 8080）
2. Nginx 代理（端口 8881-8888）

```yaml
version: '3.8'

services:
  # Spring Boot 应用
  nginx-controller:
    build: .
    ports:
      - "8080:8080"
    networks:
      - nginx-network

  # Nginx 代理服务器
  nginx-proxy:
    image: nginx:alpine
    ports:
      - "8881:8881"
      - "8882:8882"
      - "8883:8883"
      - "8884:8884"
      - "8885:8885"
      - "8886:8886"
      - "8887:8887"
      - "8888:8888"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - nginx-controller
    networks:
      - nginx-network

networks:
  nginx-network:
    driver: bridge
```

## 🧪 测试方法

### 1. 启动服务

确保所有服务都已启动：
```bash
docker-compose ps
```

### 2. 测试每个场景

使用 curl 或浏览器访问以下 URL，查看实际转发的结果：

```bash
# 场景1
curl http://localhost:8881/api/hello

# 场景2
curl http://localhost:8882/api/hello

# 场景3
curl http://localhost:8883/api/hello

# 场景4
curl http://localhost:8884/api/hello

# 场景5
curl http://localhost:8885/api/hello

# 场景6
curl http://localhost:8886/api/hello

# 场景7
curl http://localhost:8887/api/hello

# 场景8
curl http://localhost:8888/api/hello
```

### 3. 预期响应

每个请求都会返回 JSON 格式的响应，包含：
```json
{
  "message": "收到请求: /api/hello",
  "uri": "后端收到的URI: /具体路径"
}
```

通过 `uri` 字段的值，你可以验证实际转发的路径是否与预期一致。

## 🔍 Nginx 配置说明

项目的 Nginx 配置文件包含了所有 8 个场景的配置。每个场景都在独立的 server 块中，监听不同的端口（8881-8888）。

### 关键规则

1. **location 带 `/`**：
   - 会保留 location 匹配的部分
   - 如果 proxy_pass 不带路径，完整保留请求路径

2. **location 不带 `/`**：
   - 行为更复杂，取决于 proxy_pass 是否带路径
   - 可能导致意外的路径拼接（如双斜杠）

## 📝 测试结果记录

| 场景 | location | proxy_pass | 实际转发 | 是否符合预期 |
|------|----------|------------|----------|--------------|
| 1    | /api/    | http://localhost:8080 | /api/hello | ✓ |
| 2    | /api/    | http://localhost:8080/ | /hello | ✓ |
| 3    | /api/    | http://localhost:8080/backend | /backendhello | ✓ |
| 4    | /api/    | http://localhost:8080/backend/ | /backend/hello | ✓ |
| 5    | /api     | http://localhost:8080 | /api/hello | ✓ |
| 6    | /api     | http://localhost:8080/ | //hello | ✓ |
| 7    | /api     | http://localhost:8080/backend | /backend/hello | ✓ |
| 8    | /api     | http://localhost:8080/backend/ | /backend//hello | ✓ |

## 🎓 最佳实践

1. **始终在 location 末尾使用 `/`**：避免路径拼接问题
2. **在 proxy_pass 中明确指定路径**：提高配置的可读性
3. **测试所有组合**：在生产环境部署前验证转发规则
4. **使用不同的端口**：避免不同场景之间的干扰

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目！

## 📄 许可证

MIT License