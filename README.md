# Nginx Location & Proxy_pass 测试项目

这是一个专门用于测试 Nginx 中 `location` 和 `proxy_pass` 配置组合的 Spring Boot 项目。通过 Docker 一键启动，可以快速验证不同配置下 URL 转发规则的行为。

## 📋 项目背景

在 Nginx 配置中，`location` 和 `proxy_pass` 的组合行为常常令人困惑。特别是以下两个可变条件会产生 **8 种不同的转发结果**：

1. **location** 路径末尾是否带斜杠（`/api/` vs `/api`）
2. **proxy_pass** 是否有路径以及末尾是否带斜杠（`http://backend:8080` vs `http://backend:8080/` vs `http://backend:8080/backend` vs `http://backend:8080/backend/`）

## 🎯 8 种测试场景

| 场景 | location | proxy_pass | 请求 `/api/hello` 转发到 |
|------|----------|------------|--------------------------|
| 1 | `/api/` | `http://backend:8080` | `/api/hello` |
| 2 | `/api/` | `http://backend:8080/` | `/hello` |
| 3 | `/api/` | `http://backend:8080/backend` | `/backendhello` |
| 4 | `/api/` | `http://backend:8080/backend/` | `/backend/hello` |
| 5 | `/api` | `http://backend:8080` | `/api/hello` |
| 6 | `/api` | `http://backend:8080/` | `//hello` |
| 7 | `/api` | `http://backend:8080/backend` | `/backend/hello` |
| 8 | `/api` | `http://backend:8080/backend/` | `/backend//hello` |

> **注意**：场景 3 的结果 `/backendhello` 是一个常见的坑——当 `proxy_pass` 带有路径且 **不带末尾斜杠** 时，请求路径会直接拼接到路径后面，不会产生中间的斜杠。

## 🏗️ 项目结构

```
test-nginx-controller/
├── src/main/java/com/example/nginxcontroller/
│   ├── NginxControllerApplication.java    # Spring Boot 启动类
│   ├── controller/
│   │   └── NginxTestController.java     # 测试接口，提供各路径端点
│   └── dto/
│       └── ResponseDTO.java              # 响应 DTO
├── nginx.conf                             # Nginx 配置文件（8种场景）
├── docker-compose.yml                     # Docker 编排文件
├── Dockerfile                             # 多阶段构建
├── test_all.sh                            # 自动化测试脚本
└── pom.xml                                # Maven 配置
```

## 🚀 快速开始

### 环境要求

- Docker 20+（包含 `docker compose` 命令）

### 启动服务

```bash
docker compose up -d --build
```

> **注意**：首次启动或修改代码后需要加 `--build` 参数，因为 Spring Boot 应用是在构建阶段编译的。

服务启动后，包含两个容器：
- **nginx-controller-app**：Spring Boot 后端应用（端口 8080）
- **nginx-proxy**：Nginx 反向代理（端口 8881-8888）

### 端口说明

| 端口 | 服务 | 说明 |
|------|------|------|
| 8080 | Spring Boot | 后端应用直接访问 |
| 8881 | Nginx | 场景 1：location `/api/` + proxy_pass `:8080`（无斜杠） |
| 8882 | Nginx | 场景 2：location `/api/` + proxy_pass `:8080/`（有斜杠） |
| 8883 | Nginx | 场景 3：location `/api/` + proxy_pass `:8080/backend`（无斜杠） |
| 8884 | Nginx | 场景 4：location `/api/` + proxy_pass `:8080/backend/`（有斜杠） |
| 8885 | Nginx | 场景 5：location `/api` + proxy_pass `:8080`（无斜杠） |
| 8886 | Nginx | 场景 6：location `/api` + proxy_pass `:8080/`（有斜杠） |
| 8887 | Nginx | 场景 7：location `/api` + proxy_pass `:8080/backend`（无斜杠） |
| 8888 | Nginx | 场景 8：location `/api` + proxy_pass `:8080/backend/`（有斜杠） |

### 测试

#### 方式一：手动 curl 测试

```bash
# 场景1：转发到 /api/hello
curl http://localhost:8881/api/hello

# 场景2：转发到 /hello
curl http://localhost:8882/api/hello

# 场景3：转发到 /backendhello
curl http://localhost:8883/api/hello

# 场景4：转发到 /backend/hello
curl http://localhost:8884/api/hello

# 场景5：转发到 /api/hello
curl http://localhost:8885/api/hello

# 场景6：转发到 //hello
curl http://localhost:8886/api/hello

# 场景7：转发到 /backend/hello
curl http://localhost:8887/api/hello

# 场景8：转发到 /backend//hello
curl http://localhost:8888/api/hello
```

每个请求返回 JSON 格式：
```json
{
  "message": "收到请求: /api/hello",
  "uri": "后端收到的URI: /具体路径"
}
```

#### 方式二：使用自动化测试脚本

项目提供了 `test_all.sh` 脚本，可以一次性测试所有场景（需要安装 `jq`）：

```bash
chmod +x test_all.sh
./test_all.sh
```

### 停止服务

```bash
docker compose down
```

如果需要同时清理构建缓存：

```bash
docker compose down --rmi local
```

## 📝 Nginx 配置详解

项目的 `nginx.conf` 文件中，每个场景都在独立的 `server` 块中，监听不同的端口（8881-8888）。

### 核心规则总结

1. **proxy_pass 只有域名/端口，没有路径**：请求路径保持不变
2. **proxy_pass 有路径，末尾不带斜杠**：请求路径直接拼接，注意场景3的 `/backendhello` 陷阱
3. **proxy_pass 有路径，末尾带斜杠**：`location` 匹配部分被替换为 `proxy_pass` 路径
4. **location 末尾不带斜杠**：可能产生双斜杠（如场景6的 `//hello`）

### 最佳实践

- **推荐写法**：`location /api/` + `proxy_pass http://backend:8080/backend/`（都有末尾斜杠，行为最直观）
- 避免场景3的写法，容易产生路径拼接错误
- 在生产环境部署前，务必测试所有组合

## ❓ 常见问题

### Q: 为什么只能用 Docker，不能直接本地运行？

因为 Nginx 配置中 `proxy_pass` 指向的是容器名 `nginx-controller-app`，而非 `localhost`。本地运行需要修改 `nginx.conf` 中所有 `proxy_pass` 的地址为 `http://localhost:8080`，并且需要本地安装 Nginx。为了方便所有用户，项目只提供 Docker 方式。

### Q: 启动后 curl 返回连接被拒绝？

确保两个容器都已启动且正常运行：
```bash
docker compose ps
```

如果 Spring Boot 应用还没启动完成，可以等待几秒后再测试。

### Q: 修改了 Java 代码或 nginx.conf 怎么生效？

- **修改 Java 代码**：需要重新构建 `docker compose up -d --build`
- **修改 nginx.conf**：Nginx 容器通过 volume 挂载，修改后重启即可 `docker compose restart nginx-proxy`，或重载配置 `docker exec nginx-proxy nginx -s reload`

### Q: `test_all.sh` 提示 `jq: command not found`？

需要安装 `jq` 工具：
- macOS: `brew install jq`
- Ubuntu/Debian: `sudo apt install jq`
- 或者直接手动执行 README 中的 curl 命令

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目！

## 📄 许可证

MIT License
